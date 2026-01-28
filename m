Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7C0D2FEDA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FA16B00A9; Wed, 28 Jan 2026 08:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003B06B00AB; Wed, 28 Jan 2026 08:56:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31236B00AC; Wed, 28 Jan 2026 08:56:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDE4C6B00A9
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:56:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91F5213B5A9
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:52 +0000 (UTC)
X-FDA: 84381523464.01.22B1021
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id AA8D58000F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tbhWGKeC;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FP4cd1GnVqMkrbdfU6db46J7iWct+2ghMOJpL3f85I=;
	b=5csI1iTwXNXfMF9FdbvFitc6NRkPuuRieEbo1lwKBABkZkRC6gxuqQ+TSdjlaX3pUeJEHo
	Qez85kQcthRJmbfmbiFllf+fk+fQhjXAfjxfB0GttcJ4kQjJIQbHlJmOm5KplPB+fk8+sL
	xbaHWKmeJ8/p0LAWtQYOCHIwG9CiaO4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tbhWGKeC;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608610; a=rsa-sha256;
	cv=none;
	b=DuSquaepdsxWiLAMvExWscDPzcuqXyBMQBDFHcPSOh77Qxa1WmDWpHotqAxDlWpXeQBJhv
	86S4uZzsgib9RkhqxOfIPkp+IVs5ItbAZcRDENK7x4eoHD97u2vF6BK71/kXRj15R4OS6R
	iNmxrfQ+G6n0Pw1ltyOmUfif+/uy1qs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FFBB60122;
	Wed, 28 Jan 2026 13:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CE0C116C6;
	Wed, 28 Jan 2026 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608610;
	bh=7Z6tJ7UV3KGjuuHR1mbB3/Q82XEIqePwo/xEe3Pwwms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbhWGKeCTHMaN3D4K7RV5AtzLEVqBweRGfDyRSuZeGfZepV26G4+0K4kAEONMrimY
	 6+WQtJKvDkaCZhufMcXby3hKI5wZMpwI4Yy+5RmKqyUvcsa+KeSIfTBgnmL0j/E90g
	 PepUroTBZZSbv+SJiHNPwQXXe7O3mTkrAbg/FMITFxCmXnNlWqwjW1mtsEg8AL/VRA
	 9SvDtKP/0t9tAMiw5YWidZvc6KJQoanJKu0SRSoWDCyTSDkixFjXb7DVTsld9nn5mM
	 bUVs+8ycB1IuiaiUtvowoOzdRudFfNdKVLu3Jsy4o3H0rIZsN5A6AIazYeO5JsI/hB
	 E6ofxmY5xusRA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3EA20F40068;
	Wed, 28 Jan 2026 08:56:48 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:56:48 -0500
X-ME-Sender: <xms:oBV6afS85RW4X3s9Kx-10gTns20HE30X_IZZQ3lYimT575RG0DdvJg>
    <xme:oBV6aZ-1NdMp39YVS7r9TiCwXnvU6o5MjBd1M_mQCi8v1M--Oy_5BTUH7VFnRe-SN
    0xwiVztWss0LxuLixOsXDBgTTXj73gef5s8vlokkANlXT1dJ-h80_JJ>
X-ME-Received: <xmr:oBV6ae8PTX2FWfTHkOMZJTbQYTZudXMo8pvn0ATSYbiCSlFe-bDigI3Lz5DpTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:oBV6af7Vl8UlhYo1lP2DpEG82rhwnhWYvvgiwEBQMUdCQB0pfQGSig>
    <xmx:oBV6aUc7y_pVnsRGj-MB2FJ-wlL1m4ZaMIoZ3_MN8TwKaOAxvGxc8g>
    <xmx:oBV6af2KiRMo1iYKQgWwGsG1giy_BvtlDOnTxGm0YxUroCF5eUCfWg>
    <xmx:oBV6aY_jEJiscmFdWKBRdchHVsqdMEVrmgyCxCRMTsAKYT4Vq5RlYw>
    <xmx:oBV6aQ0-fyNSu80qrlqhRvGfcNuhqQxbWIQCdvuu8P-7C2MKp9zfkrCv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:56:46 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv5 12/17] mm: Drop fake head checks
Date: Wed, 28 Jan 2026 13:54:53 +0000
Message-ID: <20260128135500.22121-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 5kxn3bj68uiwntuhab4hsaanqget93dx
X-Rspam-User: 
X-Rspamd-Queue-Id: AA8D58000F
X-HE-Tag: 1769608610-762415
X-HE-Meta: U2FsdGVkX19OUf69HuZyFJApqZEsqEFfpHa2crHv+lqkLnWFYXfEtirgJ0rjIFZpYlI+c6K3v4y0G5OWLkFT3TInK9EwamfG9zJuJdhk82g60b/y9BOITBfTtK+ORS33NJ5JuFAHf8O35jtvcnrCJi0yozvJe5fbDohrallI2yxvQv3IWqBYu86RBhSspXWtNHqEQESZCc9X4vdknvkFBaYbaaI1LogsEcz5GA7+4HIFcyGqcMt5TYfmEryGGCZO4a1PI7RFcG9iD2HacxJUJ4Ms4oc4Ja1h7MtJRzzne+gZT8dhgjM6kdQONDHfoMiQSQy/52YsGmb2PHUdSb4XCLiqUOBm5IKEIp3ql/g7I42H4K/BLE+CGTzVwT5Abuddpyxxd8EKAczNJ0Spa9LKoF5OFV0nVISdJY63lq5CabxXXEM/Zw7o1bhfXhwATk2Kfzcg+wFlnGz13Whye9CgTgYetxAzawAlxLp4aot63nZn+1x9i2NC6GrJZ50LiRZY1aMS52KRpfIb1WJeLApQdJy1drF5L048LJ4IVVWY1/wpsrmqCQZozpb/w1G7NSg1z+hssyrzbrTlbgSuyMI+wniHZAmCIhskONxXK/uC8EfAWI6FTLDy+la4wxkihb/rZiV1O2MFnkE6PhVPkWV1TzEwfeyZq9IhgmQ9kBdOfnYkrMgb+ghyrD2HmP7iy3mTAV2yuKxDTSK6FAN9I32ysJ7XtNQXzvEcbw/qRmaPkFjfqewFavg3s+VTNH+wiI15EKMQUGCikpIXXNmnmehjKWFTH18MYb07etaRJVKRM4mPjUWdXKdSyy9GLEI2abyYPm6Hh7xU6OHjen9C5cAHWnh2IYfHmaIlzMzrdwc1+d1hZwnvyUaY7aegyXYflTcyl840hKSHUBLdRB/S0rlqfAOKWYqw5nOTCo1PJK3li3Rokj2icmwtVSAgtDLUhk9hiSdcVlLUHPwhnIVS7bl
 SU7cmxyQ
 8RyOGXd2e6DqdfOCtf47sMtCwPYLQ7pcns70p4dcPSSRPA4/Hj4iLL/IJrr6Yfer9jRgDfSFaywRjDKQw0K6VZme+2sXdBBCYOj2Ck+zzRDOE4Clsvitn9E3aiFhRKjHA8dyKsVagrvjZwX4nXXVaRK78MT+NpXsxayVTRs25mD0jgxCHzWk3Me22UzLjDosrCDsSkysrRNH6tWIh6v85X37sriwl5RfmrzjblBWXpUzt09ZogS+gYCmAFckMlxOmi2jk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With fake head pages eliminated in the previous commit, remove the
supporting infrastructure:

  - page_fixed_fake_head(): no longer needed to detect fake heads;
  - page_is_fake_head(): no longer needed;
  - page_count_writable(): no longer needed for RCU protection;
  - RCU read_lock in page_ref_add_unless(): no longer needed;

This substantially simplifies compound_head() and page_ref_add_unless(),
removing both branches and RCU overhead from these hot paths.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h | 93 ++------------------------------------
 include/linux/page_ref.h   |  8 +---
 2 files changed, 4 insertions(+), 97 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8f2c7fbc739b..5a8f6fab2255 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -221,102 +221,15 @@ static __always_inline bool compound_info_has_mask(void)
 	return is_power_of_2(sizeof(struct page));
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
-/*
- * Return the real head page struct iff the @page is a fake head page, otherwise
- * return the @page itself. See Documentation/mm/vmemmap_dedup.rst.
- */
-static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
-{
-	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
-		return page;
-
-	/* Fake heads only exists if compound_info_has_mask() is true */
-	if (!compound_info_has_mask())
-		return page;
-
-	/*
-	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
-	 * struct page. The alignment check aims to avoid access the fields (
-	 * e.g. compound_info) of the @page[1]. It can avoid touch a (possibly)
-	 * cold cacheline in some cases.
-	 */
-	if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
-	    test_bit(PG_head, &page->flags.f)) {
-		/*
-		 * We can safely access the field of the @page[1] with PG_head
-		 * because the @page is a compound page composed with at least
-		 * two contiguous pages.
-		 */
-		unsigned long info = READ_ONCE(page[1].compound_info);
-
-		/* See set_compound_head() */
-		if (likely(info & 1)) {
-			unsigned long p = (unsigned long)page;
-
-			return (const struct page *)(p & info);
-		}
-	}
-	return page;
-}
-
-static __always_inline bool page_count_writable(const struct page *page, int u)
-{
-	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
-		return true;
-
-	/*
-	 * The refcount check is ordered before the fake-head check to prevent
-	 * the following race:
-	 *   CPU 1 (HVO)                     CPU 2 (speculative PFN walker)
-	 *
-	 *   page_ref_freeze()
-	 *   synchronize_rcu()
-	 *                                   rcu_read_lock()
-	 *                                   page_is_fake_head() is false
-	 *   vmemmap_remap_pte()
-	 *   XXX: struct page[] becomes r/o
-	 *
-	 *   page_ref_unfreeze()
-	 *                                   page_ref_count() is not zero
-	 *
-	 *                                   atomic_add_unless(&page->_refcount)
-	 *                                   XXX: try to modify r/o struct page[]
-	 *
-	 * The refcount check also prevents modification attempts to other (r/o)
-	 * tail pages that are not fake heads.
-	 */
-	if (atomic_read_acquire(&page->_refcount) == u)
-		return false;
-
-	return page_fixed_fake_head(page) == page;
-}
-#else
-static inline const struct page *page_fixed_fake_head(const struct page *page)
-{
-	return page;
-}
-
-static inline bool page_count_writable(const struct page *page, int u)
-{
-	return true;
-}
-#endif
-
-static __always_inline int page_is_fake_head(const struct page *page)
-{
-	return page_fixed_fake_head(page) != page;
-}
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
 
 	/* Bit 0 encodes PageTail() */
 	if (!(info & 1))
-		return (unsigned long)page_fixed_fake_head(page);
+		return (unsigned long)page;
 
 	/*
 	 * If compound_info_has_mask() is false, the rest of compound_info is
@@ -397,7 +310,7 @@ static __always_inline void clear_compound_head(struct page *page)
 
 static __always_inline int PageTail(const struct page *page)
 {
-	return READ_ONCE(page->compound_info) & 1 || page_is_fake_head(page);
+	return READ_ONCE(page->compound_info) & 1;
 }
 
 static __always_inline int PageCompound(const struct page *page)
@@ -924,7 +837,7 @@ static __always_inline bool folio_test_head(const struct folio *folio)
 static __always_inline int PageHead(const struct page *page)
 {
 	PF_POISONED_CHECK(page);
-	return test_bit(PG_head, &page->flags.f) && !page_is_fake_head(page);
+	return test_bit(PG_head, &page->flags.f);
 }
 
 __SETPAGEFLAG(Head, head, PF_ANY)
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 544150d1d5fd..490d0ad6e56d 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -230,13 +230,7 @@ static inline int folio_ref_dec_return(struct folio *folio)
 
 static inline bool page_ref_add_unless(struct page *page, int nr, int u)
 {
-	bool ret = false;
-
-	rcu_read_lock();
-	/* avoid writing to the vmemmap area being remapped */
-	if (page_count_writable(page, u))
-		ret = atomic_add_unless(&page->_refcount, nr, u);
-	rcu_read_unlock();
+	bool ret = atomic_add_unless(&page->_refcount, nr, u);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
-- 
2.51.2


