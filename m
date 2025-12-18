Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE32DD6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2374F6B009D; Thu, 18 Dec 2025 10:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203696B009E; Thu, 18 Dec 2025 10:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010FC6B009F; Thu, 18 Dec 2025 10:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E76906B009D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B26731601FD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:16 +0000 (UTC)
X-FDA: 84232927632.27.6FE6729
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88E57C0009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbvfuUVg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070614; a=rsa-sha256;
	cv=none;
	b=ee8SpDXF6U1KEI6PhZ8ZfYLv54D5nkVRAQPRzcUIAEffAMm22rN1pf2LT/R16QIoZAySTS
	xK0jTZf7MubR4Ju7jxR+hwhnmnpOm5sKIitTctg9x1vcrZ3lIsnwIQslauxXu1g6iErSri
	H1PFUP5iNWfNbaMs/BVby7cl+Ki4IVI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbvfuUVg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiVMyxS7FVQhS6jfzervWzfyLFx9ggSU/C9XEYEXJyI=;
	b=vmSIhcrPwNdMG+yXsxLstRb2Os1Zx6GeowQ+/Z2iPPdnWzuSEM8GKVrpBG5rXFdPoMBsrz
	oILl0ElX/QiV1lfXYkQF3uDvibw9RAfU52etlpp4RZYaiw7cmnqXIiURlSHTmQgOcduPJI
	gKI05y2YYqaaDevCstDtoodECuhmcZo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B65634453E;
	Thu, 18 Dec 2025 15:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E66C4AF09;
	Thu, 18 Dec 2025 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070613;
	bh=KvWrlZMa/fy15OEAlaraMbBiVbwGjnzQ3O0cdSp0QTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbvfuUVgUs3InYofE2oM9JKFREK+k3BdcQadj+/yvmP7l0Ht18EMioAd2UJCfd9Td
	 P1sNLU9DPEFXYLn3g89RCeMgl1/uknM920uqKcm+mx/3cfkENnuEAVdVDq3TbmjKaI
	 1GW0kQa3zG7QcwtbDLBeGumSu467Bqal4v8lLWrh6sPmLHN76P85L690A0FYdVReQH
	 FrjUQWUDXf9gHqFm1QVhPw6mOOyp7GMFtra7es4nB2zby2h+VgS6f0ANfWR4ZN/sjS
	 3ZNpC1M8EurLsNnf9yp2EKAzjgI1WEpEFBH/RWEc1IL1d0dg3kSpjvkfOLADU2tlIM
	 yatRe7vokmjSA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 55830F40078;
	Thu, 18 Dec 2025 10:10:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 18 Dec 2025 10:10:12 -0500
X-ME-Sender: <xms:VBlEaTgk4TXx6QmBuh2WTGSd1W1umcE1jVkq97SuxrK6hd-NMojE0w>
    <xme:VBlEaVKwZUXJSEC6rx45plOHVTVWf9C2jPjHawZ2bYSBSMECX_QyLcRe3MmWnkL7y
    8A52k7nVfclIaHTSFHQ02Pba0rO-dRHb1YEFPG1A2lp_KCdlHmecvE>
X-ME-Received: <xmr:VBlEaWCWHw1rac8JmR4P75ySJ7Njp3F8Z3bhUP75oHPJeIPFdwg_fGrvIHyKkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:VBlEaWSPWQup7JqqI5uCU9cXLL5kKWgM0UWcgOJ7yFc7fDffu1IENg>
    <xmx:VBlEaXo0KRDUOiBsQs3Ip8wcrYxwTp_ysm-snOfKwPmk89qtmW1XYw>
    <xmx:VBlEafXaPBxyGv_xsoTYe_OOmIJoWuANtjL6W1qU4sqkE8mnLUjoOg>
    <xmx:VBlEaV9C8FUEq6aI7YvcNy9Bu_P1JhZmcclMrBblcsj8ZbgTOh-LOw>
    <xmx:VBlEaXZV7X9UqHMGHSaMeEFDicT5w8vxbHZ-ViPYwvzbqutr5h40y0vh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:11 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 10/14] mm: Drop fake head checks
Date: Thu, 18 Dec 2025 15:09:41 +0000
Message-ID: <20251218150949.721480-11-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88E57C0009
X-Stat-Signature: nuj84rcwdzfsto9eb5d6cj5rhucy8ja7
X-HE-Tag: 1766070614-764818
X-HE-Meta: U2FsdGVkX189oe5jiBvi5F6GiCaG+Cs9d1U3qyYHZbiY9Muv+4CNWv0/fA48DDD+o3PptxBxxil5zrzrLTaScnYF47JSUdq+VvaSh8KYkSVLKiWO2FdzU5WiabeMphyg2BKIHjvrDd8ewPVAhQp32Yh4wBf8ipGLLvUVnA2qY77d7A1CX9TMmncNWXj++iveaKB0iN/oH3qGA8QlNjrc1j1gjWVUnUH2ePoDKJoNL7XpMwzADYSABB0M7TE2KfpfU+Jv9mJm4EvjLEkj0VffY0c8fCs0tGbiejcTDYr202kVbcjeT+N8M06g6KmbZ8R7EnxzcM+6guuChJ0YTAeFiKYHfq2aiv5a+q4BMT7O2wewqh1IqjVYVzFF9V1cc8/NlJvC3Ic+snVxd/+s6yLDTFbH+MXl8XUnIPyhFDrCxGQnXXDuKYD/Rixt3YRN8C+4hYXXr++Ut36s4vj42OnBpbmz2YEQEZA7Y2qKCU2zyHirilK1KMDAnUAUcmndysgKhP3zlZNCjo7zFmQaH7rfFOQULW3hSkniy8zqCa38UQsi9SXUDpS/PySsZR+yC7MMPjam8fELWdngxc47V4o1qCEI9K3YhUU/Dgm3hOHtZDZfg2pE+c+MVdYDeAoGi3jHQtWP6NNSoGC/Y0K8lHC6EzDXRolfGvgRM4c+6ISHUgxZ2ZYI2Bq63P01p78z7p8ddJlr1zZ0qaU/dFIJD7QCAR9uVyBIeaN7MABT5kGX6PUndDE/F4MrGvmOUn+FchvZfOGfL+9JaHWVqQtCbMCwdvSPaIw8v76jmnAPz964z4zoSrqXVnl18uhYEAFGnvE1wDNTfuNQRFjtBM0/oCT7GxkgUq+NSfjPcqrEdMFOAM713GEI+OaaP2AezVhOOSbu0EI6oKZD8KruecuHj7l3nxd58E/sMyzR4LyvnO5zc1bUNKgjmygaLtftnVYMn+5jLuRcEiM7yc0kdtEDjQF
 Jbm+LZiu
 r9loz8Stv86NtGMccKW5a8MDzWwOvnXRLQQWHA0gs0ZF7DzyncVTcQZ41GI80JuKZ7hna6jfoMe32zu2RTuLabmyAaZh0RZipWurjKwO7d5efjsFjP+z8uy2GOJ5p+3NOw6cwzCqFzcwj6Np7YWwlmxgBYSqo30G+fRn1/5qzI3smmt1b96emzcVRKSYQ6OhSn+i6QDvKALv/IqKvO1yp05YiynpJM+at6phBQza3CDSKuKX/3TmXnyG7JladIqwV9e3M
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
---
 include/linux/page-flags.h | 96 ++------------------------------------
 include/linux/page_ref.h   |  8 +---
 2 files changed, 4 insertions(+), 100 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index fac5f41b3b27..9d89beed9df6 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,105 +198,15 @@ enum pageflags {
 
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
 	 * If the size of struct page is not power-of-2, the rest of
@@ -378,7 +288,7 @@ static __always_inline void clear_compound_head(struct page *page)
 
 static __always_inline int PageTail(const struct page *page)
 {
-	return READ_ONCE(page->compound_info) & 1 || page_is_fake_head(page);
+	return READ_ONCE(page->compound_info) & 1;
 }
 
 static __always_inline int PageCompound(const struct page *page)
@@ -905,7 +815,7 @@ static __always_inline bool folio_test_head(const struct folio *folio)
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


