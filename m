Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75165D3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287946B02CC; Fri,  5 Dec 2025 14:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2498E6B02CE; Fri,  5 Dec 2025 14:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FCC6B02CF; Fri,  5 Dec 2025 14:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F274D6B02CC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D04201A02D3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:09 +0000 (UTC)
X-FDA: 84186443418.01.F9B7A9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBA521C0016
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YYBZl+RF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963847; a=rsa-sha256;
	cv=none;
	b=482khLI6wZABh27CQ6iEK66OAZhP5l1l9sxofFEgMypyd0YhdQWZi7P36Xx3MPwMdFVDhL
	4wuJqSepKAdsXjkSebY8wZCkDdtR1GxpRG3ETLS/VawbTuRYfDzrk9LByK4+gy93rrwvho
	qgAL7Vk81DppGBIvj+LwNAc1gZjWSmw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YYBZl+RF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vox9Vg0uxQffQ0cfkto/HrjUxCSQIc1zpLRP30gnlAU=;
	b=dwdg1/5WZq/3NKuTgJPcCaFhfz4hwKUx3tnn0K/ZSxOPVFx0oiKFe8u5xKOD/NzDne7ATA
	WyAS4+h8Pyaeg67dHrec94p8IGOYc7Lrsa93cYdFPAKkXCm1bDxV40ISUX8oom6TcPPX6h
	f51cSMvFsjsPSQVuedW1CGuFZNr3geg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2CD943A2F;
	Fri,  5 Dec 2025 19:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D725C4AF0B;
	Fri,  5 Dec 2025 19:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963846;
	bh=QSFmiqQuAu4Xe8qwQuUx5JcV9uyzyjf22IqZdZAyLHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYBZl+RFV5ksiVH6NISnSSMBo/mhcOKzJuEWY5Pp+wC7asR3BN6qPaFjNKjZfrimC
	 K8OxiULVd3Yn2ye9Kfr2j5ecodkEZkAENl+M9xuunlVPEAxyIJlCD9H9iFNSh2rske
	 JeX8z5NuAJejFQkx8ckt4LKSzQevIAOEXOv5GfQagVMATh0/ZKqPVbAzmnvgRJglHx
	 YWcygjV0yCovSob3ppuLwR6tFh6Kf3KGYH9BdCogYM+QYfBL+A5TyHkuZmBqQTLGEk
	 rydEW+5V/WMIaLl6G/N8ojQTR3WaK/6Q/y+9MBHtO39pi+znAircJ+QRACAUp52FZ+
	 VTMBULgDSVbqg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 882CBF40070;
	Fri,  5 Dec 2025 14:44:05 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 05 Dec 2025 14:44:05 -0500
X-ME-Sender: <xms:BTYzaUiH0EleHELMpgzNYfeRWNpDBGLhGQeCsCodEuQbhArq_9QkbA>
    <xme:BTYzaebgzk82Q_-pS8TTpGy8ZM53h9OeSesYBDF__EaeCvzcibj8MpAdi25X8DRvx
    GWoCaZPw9mYzetdLTW-SCedVaioag9vXa7Y-oRn21KV3iEnGJa0lnA>
X-ME-Received: <xmr:BTYzaVUl4zylC-TQGQMgpfXIIiisJZ3TbAuF8c3byXwQtmH6R5EWXGMls3_97A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpd
    hrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorh
    grtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:BTYzadj5kyRkWn0mhn5ci5DWGDJkMzomCYi9Wmc91nhPG1yANlNEIg>
    <xmx:BTYzaYl6Pz7ooWqAWChz3x0Nb8ZvfJklcoCL_OpcHlXsck7v84Ps5Q>
    <xmx:BTYzaeyfTWIDVeuRVN8Hb29SVDKaZ2__rWG3ECmTnqkZHfh_MFzRMw>
    <xmx:BTYzabtxOmArYk9XX8-9gOJQKlzuOuRiQs7CMo7wPdLy9XHeRV3leg>
    <xmx:BTYzabumKqJHXStWHe43bAEv_2IpqUB2w9Kfg-rgbZ31SC6h4DCxpm7f>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:05 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 07/11] mm: Drop fake head checks and fix a race condition
Date: Fri,  5 Dec 2025 19:43:43 +0000
Message-ID: <20251205194351.1646318-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pbeq766h8upiu76qpa9dr6n9jj6uj1r9
X-Rspam-User: 
X-Rspamd-Queue-Id: BBA521C0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1764963847-438982
X-HE-Meta: U2FsdGVkX1+AzzoL5hJPW5RdwnAGQNmTA3RAAjN/BviFaIoCC+G3szyU3tqC7Mqb1OIhSdfVPzYevk3bGwOrB+ajITnz+bKmNbttRPlak29XQenUsOpaNX6hTe6QbAPoFEqYFpcyDUF7h4ulP8RR76sclHOZQoXHy5KbURYk4ypz2rNK/iPAYDMD90m3f/zDaHXL1/PTlbEqcadiz47ze8Lwn++EiFkiLyKy9i/luNo1Br9D6DV1soEt+Fi+OesRJ6mYOeOAJBlfDMAS6iHv1fpeej2P3nA+3fkzleFJuWRW6uYdISohztKyPS72I0HiPRHvwhYAfkOkM8zIQz9uDLttblzL5x/zNEFw9l28jASfbzjESHBdGIWqkiKXhS69LEW8aYX5D7QWynETwnzEk+AM3ECA++SmDfNUQ/0j4PHlvKj0KWtdIfRQ+6LsL7T5VRR2eeLWlCRYXNX+RreTOBESvYgBDNLO/mcErs2Av7A6kgH/34hzRCbk444F+7UlYrC89/C5QRC6JJKxIxcuZEEvZKxihBItgvbS/nl+LOCtRywhe8srG0VDUCGH8Nkb0zeso9x4EdiDM3jxSriJ5P8/seH+btZcu8VCPWdFqIOkMyEBbAsLYYbVQUPTdHl7o615xmiWFqDECzSaarQ3qP48o4TDX1Km/81VX8AEppd7E9Iy2SkY1SuJIsFkezhqz9YZRBOtvYFRvTDH0KmBnIRcQHYfs1Ue7GMbPRl3HMh8bXxNh7zpq/ZPN8IsNTRex2QBh2uiumlxoqpHQ+q1+58P4G6oYF+RSkWGx9f7PuEd7NKWyMDfVmwKBazOHmF3CeeSTnjQaHoAeKGlBDVlhyuM1NZEoMhNE8+hQERMx94a2bxv808xAqrBI98jh1f1AKkKuKrDTz5qL1HW3W96q2IC8FsUdbuMXgB94qVYy+7hjUmX0m+/UeynIgJi9binbNJfpaF7S6azFGFRQjX
 uALPdH4Z
 fhNP3Dq2obe8btAN232hWg7LaSut541OA0qIlOq/z7e0Anh5tKNdoNbVTlrz3HkGviEnaoH7BhYSwTsps2uClQQHnfYccfSATTNPrw7wRC8mef0pWOMrZrqM4x/D2rqfkbiy+5TIqGVBvShJgfFoSO7yYRINpZCSWF+MBbvqU7TfggeFCT2sog8bW/+BUgvHhjulc1Bf2zrVc2lvaY8N1o+JS0w5U853Cj76V0EZh51r5AYCI4b3p8dkiOzbPmpbGHq1XnnWm2HMotBg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fake heads are no longer in use, so checks for them should be removed.

It simplifies compound_head() and page_ref_add_unless() substantially.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 95 ++------------------------------------
 include/linux/page_ref.h   |  8 +---
 2 files changed, 4 insertions(+), 99 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index eef02fbbb40f..8acb141a127b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,104 +198,15 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
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
-	/*
-	 * Fake heads only exists if size of struct page is power-of-2.
-	 * See hugetlb_vmemmap_optimizable_size().
-	 */
-	if (!is_power_of_2(sizeof(struct page)))
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
 	 * If the size of struct page is not power-of-2, the rest if
@@ -377,7 +288,7 @@ static __always_inline void clear_compound_head(struct page *page)
 
 static __always_inline int PageTail(const struct page *page)
 {
-	return READ_ONCE(page->compound_info) & 1 || page_is_fake_head(page);
+	return READ_ONCE(page->compound_info) & 1;
 }
 
 static __always_inline int PageCompound(const struct page *page)
@@ -904,7 +815,7 @@ static __always_inline bool folio_test_head(const struct folio *folio)
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


