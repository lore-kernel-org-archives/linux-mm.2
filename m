Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D65E7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB53F6B0109; Mon,  2 Feb 2026 10:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F986B010B; Mon,  2 Feb 2026 10:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57CF6B010C; Mon,  2 Feb 2026 10:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C14286B0109
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CB2DB6C9E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:25 +0000 (UTC)
X-FDA: 84399973770.16.9A2C6A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D185C000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwRkykUT;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FP4cd1GnVqMkrbdfU6db46J7iWct+2ghMOJpL3f85I=;
	b=a9zAis//VYrGNmzC9fO3VM/u5iHonl/6eYWvSy0stktdFh4dZsovVRJ3NUxGbeqasJiKkX
	PkyTgOQqwykGHwXxybaa0WtVGrcoPKhMWZ8+nHYZiDOoD9QZWl7bRPtDGdKe0sNO2A5QDw
	AcbXAZbEl2aSgTTrZoafMF1nIpR/QPQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwRkykUT;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047903; a=rsa-sha256;
	cv=none;
	b=U7XX2p+Z6YR1FE7J6TQpWWUw26mlQ+bqEc2lH9NRJFCSppUsFHez97AfuZzV7EI9Uo4sMq
	prqAGjFOphYEvtduoQnkDzyfvfoB9LKHdmGn4Ngf7THwtVSXDtxMuPCqoafignea5dNxWZ
	BjTUjT/COrzM8FssfhVybmn1FKBQW/0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B339B4169D;
	Mon,  2 Feb 2026 15:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF426C4AF09;
	Mon,  2 Feb 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047902;
	bh=7Z6tJ7UV3KGjuuHR1mbB3/Q82XEIqePwo/xEe3Pwwms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwRkykUTveFdtHDDtWZ17IxHYNcVVg6JFrPDloSIVKjKNBj7HwDrWI1NN5uTxlTn8
	 nuQsk+TgJyrxjif31zS6MXE+fCBKsIgal1xxQHPcmdbJ9kORUWBVGCmAcamTvOBTO4
	 Vwjt6tb03/fCsZ3sCLECiVfqYajNTJQEiQA+fBgj/eZ6udTRoMSSfF+vIuFnPIC1vW
	 XTvjdQlf9kGIR6diRgzM+OQnMMA/S9ruyuyKYqImXNdzQBzXdnI+7WTIdsaK9qjgB9
	 ZvDBhhr9DllPmu07lbPaLHXZHU/9eDIN7T6D3I/jiHGFUtw/OIrvsWtbkuokjoa+UV
	 zqD4a1vuJLJgw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 10639F4006A;
	Mon,  2 Feb 2026 10:58:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 02 Feb 2026 10:58:21 -0500
X-ME-Sender: <xms:ncmAaQCU4hXvMDF6wFPhspDH--GtM5O5g-tVtPPBWVZXseKZB-J6UA>
    <xme:ncmAabsNIqKiR7XyaPoJa9ZzrS0M1tK-Iwoz1CAO_WHK-zBHjup6ys5yUnSGZ7f1G
    Plwh91PnBe0HPu2EhkFQ1ejZItsoiO-BuACHf5SrtQl2zvGabkT_-I>
X-ME-Received: <xmr:ncmAadu753BCbKjLAIBIyRtGQ2Ss4zThDq6YifZFQH_aNbx6L5CYDlw0kN0BKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:ncmAaXoReZrJa2XgT-w-CpSrhRLhvm06BboiKal8VaUQYgEpCpHihg>
    <xmx:ncmAaRP3clhDRPh989eCb5dC_YGHxlZE_wQ9-6NaCu8ynTdQnvo3pQ>
    <xmx:ncmAadnIva4StXQTWQeL-gwDVLanjGTt75_Ufrm4mInTYjI0XVtyww>
    <xmx:ncmAaTvismtKTgMTQtOBBKjVDWt7WDS_w6M3Xx7lkgyzLxJAYbnpSQ>
    <xmx:ncmAaUk117j5Bej5Fz2a9DX3iA8C5OdV7-PjFi_hNLumDMRgpEs5htXa>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:19 -0500 (EST)
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
Subject: [PATCHv6 12/17] mm: Drop fake head checks
Date: Mon,  2 Feb 2026 15:56:28 +0000
Message-ID: <20260202155634.650837-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D185C000C
X-Stat-Signature: xzsfcom1d9bfinsft7csgo9yp96y8zh4
X-Rspam-User: 
X-HE-Tag: 1770047903-724336
X-HE-Meta: U2FsdGVkX1/O5N2CfuRhrimAXji95oaGAeLmryo/2ar8zUJKfegG6dutPbSGaX4Q1Pf3mUyL9kwbvGWq6E0pL+UG53QCI8OZrSN/MKLW2u5HaDbtIFwWSiQF2nQQy/ojjgfeQ5yrMUvFGNCGsOW1lR+vzL/HIIp7HHMCBK+QtVXXzWUCeTiJ67bNszox7p4n92WslV11bT429L8Ok/b4R8lsqdtegqbGWEJmmNNRvmxRXObtD0HbBBLr8AoxfzWJ5XFnU9Tfg+T1FiS17RNrXZIOE+2q9l8daPh1+/3G17T+vtgMz9B4UrKMXBMjj4X3GWGqlfgs0MbwBCYV6ngZVRuYfIADQSqHoh5SX6zpi4b0CyFypuScWWmx5LXREjO119+0doNn71zT6UeMTpOpaK/xM/VDEUQkHNc/x9FDjcc/EX9cCDI4Cw5J5plPGxeUNyxfZOZsCY0MZvPtmR56hkGjQp+puRJ9O0r3ITCsVpVq6w1ztqWcRXXCI4TlVb6ZIlNanTz1l4/PdB9MBRQ+6p2F1J4nJKIpFV8q4h/fxHaz5ZSKHo9Q4nlVkwx8zK63rvdSI+EYRUJR3yQLJpy+aUuO2MP/jFYftf7alV7GrlbRX89GpAraip0ShLHqJbre/GfeD5naeJh2xtXDt5/eEjEOlq8B3S7AXPesboybOty50BAS78RKDfeYgL+1pE9u0E7/bihuTIKxO0NWypDJ4KPBhWkfDPs1hhdWADxAqEcypSlvIxWcDI/RI5sqeR7z8ldBV4wcHzIUja1n4vnra8LhYIU3lWYWGUdZ8tDsIsF+E1EE2/ibCwHLEetJLIsGvTsj5NbLIQET5CdLplR6Kep6jyq08Dfss67rHsLgQ1t4DGKOxSbBq7X81DQjljZQvE11pJZn8EzYVPTBp43F/NtxB49iJz1UtpvYylCOE9X9hg3eWbD5O+ufjKOVk71jTevilpnfkFn4UageH7g
 afjb408j
 X7zN2njuZ1E6Nz5nD/36eW2B3YBRiQ1IdCq01H+PFPRzDm3BBPrBMAUlJB+D1i0cUTARPxpGeiJmVsik1NPqApE4SQQUg3WAtRmPHPf2ZcD/b9ruzUEMSvozNuMEj+Q9RkbY2aFTX6gslES6iWtcYqWl+A0nyzZ+DAMSji5oZz+bWLmiRzCj1OAf43c60ZJ7zyHQJupPZBNj9Ju5UowD+ZhyJ+L7r3MHxw7RsrI9R1Q7HrVChC28PkDp49vOT4NrDROX4
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


