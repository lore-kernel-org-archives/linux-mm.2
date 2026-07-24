Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17EDC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A256B0095; Fri, 24 Jul 2026 18:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E96D6B009B; Fri, 24 Jul 2026 18:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FA56B009D; Fri, 24 Jul 2026 18:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37F8C6B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B305B1401E4
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:18 +0000 (UTC)
X-FDA: 85025114916.12.784C7EB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0998710000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=EfkmCcu6;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWyDOLxEr139JST0LPn3P6hJ2pi3B91Laa+5/sQT2jw=;
	b=0FmZH91LdqGIQ1jyk4n5rPlmafcf/cnPjpmjCYHkaIackkhDhFnA1bv5jV5jqzzCsD0b7E
	FqlKN+hJQvcQpjKSLcE8jY8lfwegdeL/71srbuOoKtBMVQUEpb3Ae8TIOzAvCieNl3aWdh
	GMjm2nTyxO+QmY+dF9k/a0bNTf4QKqc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=EfkmCcu6;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932217;
	b=7i4ZKqtIqwGCkMi4jSegmS5GxQelXHRzCX1z5raHOi/EY6y2DVQ9JGQgxtZXgmQ/DOfBV5
	xq+JzsSwWc7Be9vV5KgEM6bHKEiaUJHeW0ISbBuQrSGIooJI6jP4KIS/V+Nh8hk+qIF7uH
	wFPncPDO923j6piDeHiGReX/aVWZrwQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uWyDOLxEr139JST0LPn3P6hJ2pi3B91Laa+5/sQT2jw=; b=EfkmCcu6UjqwvmHokFq/BB/q+Q
	gPqMopzT/+YNSB6yVdiT/pKeZDWxT7f8LDs2kaCaCfHxpsuhsSrwUnuD50CJB4hYFrRagxEH5Th7F
	hVnbCgzJG7ECtC6Y4JnrE7GJutVka3iswTkbIDFvPVcdz35kQrgqvvw4Tfg3V/HUAHkZ1AbYZvRYc
	rTpIs7UUU8oxCw8mWiYUKfj/YxBUgQcTdBKWB7ZdRGaChZb4v+B0Lf3BEFmfbMDUy3A81oXrh3EI8
	svZ9pU1efMXiuFt5yeLXUd5yoCXgb3t9+3PYb+nQe6b5ACYLw0Z/pzA2F3zY+GWVs5Z8ynhNt4Vl6
	caekI+YQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1xxW;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 10/12] mm/gup: pass an end address to follow_page_mask() and return a page count
Date: Fri, 24 Jul 2026 18:29:32 -0400
Message-ID: <20260724222934.1463812-11-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0998710000D
X-Rspam-User: 
X-Stat-Signature: mmduk7mq4kx7c93xpgo6idcbn3cfuqwa
X-Rspamd-Server: rspam04
X-HE-Tag: 1784932216-891569
X-HE-Meta: U2FsdGVkX19rPMnlxjSG58XJFmINt5R46gFyEft15Li17OwEQdBdZIReLJIhDUjZV28vDz4Tan5ueWw76rOKV1rDMWdkBSq3Bc5ScNaEQbgtQNcGm4vnoTVNVvON6dv0V10/G+eknDeKn1rxtwJvTWACTb6mdoAcfrXi8ZpPTlmKHwZTvEquS18aH/ZYIovswg2S/Yra5pqxQKmsVQyipjmyx1ZTHYdSIVM79rN4RX6Dab2bW6eAgiXI7J5FnDQcEX7/CyVmNHpURXY4pgcNLRTLrO5V5n7MRAnXJjfgwZ8kts/Y4LNoKoKCFg6d76kjt/NlU52Ad06peQEU5FH3KSLMX/deeCYeRgKigLXib/h135nnkJD1PnzVRK3JBEEnAVolU3NgLfpjmSrPisdoCQro7kmzAE+HEmKvlQcB81ezpO1n2auyovfauXMAVVSn1YZd/fzDInxpdGSbTuyqilFdmuG7J3jXtexWPHrM5uC9yAJ1e0DdxDKDEgNm78BFPGuMiC5nuE2p0qYpkhSHDz0i0El9KPt9AGW0e/s6a8q0ehF5a0kkAO8PI8HNX19yO+cH2xtqUWCK5Hdq70pdrzAhxOTLGjwUJ94nuS1tNHbVo9HnqlcJlalVDZ4qRrqUstsNPCq0M1537TTXnldxTdBNVyZ/lV60ZTbd+0dxoV4vPyQ9J4v384AI2xBhmfUD4OmrS6du7DtHee3HOUiCzGsVgfgSJayi6DddeRhHpBhzW/SdNjKHU3mMP922Kxo7tBQx9p9vw5LTWbEpuBx5lrcqHwZJUONrtXXlVdZ3NLEssVetvMssG6yzrwSDM8D2OLhvhuNgFctWlcW02ogoF0ltouYRPxHqqE+dvQ25jvXaMHxDhlEJbUZzHFYxB9K3Q4ctuEddx+hsiGQ7xobIuZjDf2oB+gqB9Ehkp94XxPt0giy3mg7I2op9zoEZUrEC5bo3nwlFKaQNiRnU5gK
 iEqTWpcN
 VwpJEYvrAMFonrKvGlsaSI9UFmhQO8UVnNvMA6+jhhp7WoLK7UIm/5GTRA+NoULAJanhUFbVjDdxbo6UQafV9tWwFgG/Vryl5XwRRcq7L1o486HcU8Mfe95jr0QLA9goUJdoVbQOZPwLAScC4b6wQxiYWRhnpRHzzAZtz4IuUHhXi1aAubo/mhVy7VESIpwfqvCprgiFHzuJYJYPJOTUYSNDIAUZHmfq+JPqo38ubvpM+bm1nhLzPX05ihpToFjp7K7Qy9ueOpVvNTGuhdBOOGaiqn3Q0p9POgJRyWH1gFAus93hvQiyMBpxco//tF5chTrvts27o9CAGh736Nlfeyl3KjLSJBQPWJakx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() reports how many pages the returned page covers with a
page_mask: a bitmask of the enclosing naturally-aligned huge page. Callers
turn that into a stride, which assumes the run is a power-of-two block
aligned to its own size.

That form cannot describe an arbitrary contiguous run, which a later patch
needs to batch PTE-mapped large folios.

Replace the page_mask output with nr_pages, the number of contiguous pages
the returned page covers starting at @address, and add an @end argument
bounding how far the walk looks, so a small request does not scan an entire
large folio.

The huge PMD and PUD paths report the same stride as before, now as a count
clamped to @end. __get_user_pages() uses the count directly.
get_user_page_vma() passes @address + PAGE_SIZE and still returns one page.

No functional change intended.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 102 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 56 insertions(+), 46 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7f4107f7ff10..96b00ddf7e04 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -647,8 +647,9 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 }
 
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pud_t *pudp, int flags,
+				    unsigned long *nr_pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
@@ -672,10 +673,13 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 		return ERR_PTR(-EMLINK);
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
-	if (ret)
+	if (ret) {
 		page = ERR_PTR(ret);
-	else
-		*page_mask = HPAGE_PUD_NR - 1;
+	} else {
+		unsigned long off = (addr & ~PUD_MASK) >> PAGE_SHIFT;
+
+		*nr_pages = min(HPAGE_PUD_NR - off, (end - addr) >> PAGE_SHIFT);
+	}
 
 	return page;
 }
@@ -699,9 +703,9 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 }
 
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pmd_t *pmd, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
@@ -738,23 +742,25 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	*page_mask = HPAGE_PMD_NR - 1;
+	*nr_pages = min(HPAGE_PMD_NR - ((addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT),
+			(end - addr) >> PAGE_SHIFT);
 
 	return page;
 }
 
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pud_t *pudp, int flags,
+				    unsigned long *nr_pages)
 {
 	return NULL;
 }
 
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pmd_t *pmd, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	return NULL;
 }
@@ -800,7 +806,8 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags)
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, unsigned long *nr_pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -885,6 +892,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		 */
 		folio_mark_accessed(folio);
 	}
+
 out:
 	pte_unmap_unlock(ptep, ptl);
 	return page;
@@ -896,9 +904,9 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 }
 
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long address, unsigned long end,
+				    pud_t *pudp, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
@@ -912,7 +920,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, end, pmd, flags, nr_pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -925,24 +933,24 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, end, pmd, flags, nr_pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags);
+			follow_page_pte(vma, address, end, pmd, flags, nr_pages);
 	}
-	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
+	page = follow_huge_pmd(vma, address, end, pmd, flags, nr_pages);
 	spin_unlock(ptl);
 	return page;
 }
 
 static struct page *follow_pud_mask(struct vm_area_struct *vma,
-				    unsigned long address, p4d_t *p4dp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long address, unsigned long end,
+				    p4d_t *p4dp, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
@@ -955,7 +963,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+		page = follow_huge_pud(vma, address, end, pudp, flags, nr_pages);
 		spin_unlock(ptl);
 		if (page)
 			return page;
@@ -964,13 +972,13 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
+	return follow_pmd_mask(vma, address, end, pudp, flags, nr_pages);
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,
-				    unsigned long address, pgd_t *pgdp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long address, unsigned long end,
+				    pgd_t *pgdp, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	p4d_t *p4dp, p4d;
 
@@ -981,15 +989,16 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
+	return follow_pud_mask(vma, address, end, p4dp, flags, nr_pages);
 }
 
 /**
  * follow_page_mask - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
+ * @end: virtual address at which to stop batching contiguous pages
  * @flags: flags modifying lookup behaviour
- * @page_mask: a pointer to output page_mask
+ * @nr_pages: output; number of contiguous pages the caller can read
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -998,15 +1007,17 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, @page_mask is set according to the size of the page.
+ * On output, @nr_pages holds how many contiguous pages the folio that includes
+ * the returned page has mapped into this process, so the caller can advance
+ * over a large folio in one step.
  *
  * Return: the mapped (struct page *), %NULL if no mapping exists, or
  * an error pointer if there is a mapping to something not represented
  * by a page descriptor (see also vm_normal_page()).
  */
 static struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned long *page_mask)
+			      unsigned long address, unsigned long end,
+			      unsigned int flags, unsigned long *nr_pages)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1014,13 +1025,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
+	*nr_pages = 1;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		page = no_page_table(vma, flags, address);
 	else
-		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
+		page = follow_p4d_mask(vma, address, end, pgd, flags, nr_pages);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1198,7 +1209,7 @@ struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
 			       unsigned int gup_flags)
 {
 	bool vma_locked = gup_flags & FOLL_VMA_LOCK;
-	unsigned long page_mask;
+	unsigned long nr_pages;
 	struct page *page;
 	int locked = 1;
 	bool pfnmap;
@@ -1231,10 +1242,10 @@ struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
 		}
 		cond_resched();
 
-		/* follow_page_mask() requires @page_mask; it is unused here. */
-		page = follow_page_mask(vma, addr,
+		/* This helper hands back a single page; cap the batch at one. */
+		page = follow_page_mask(vma, addr, addr + PAGE_SIZE,
 					gup_flags | FOLL_TOUCH | FOLL_GET,
-					&page_mask);
+					&nr_pages);
 		if (!IS_ERR_OR_NULL(page)) {
 			/* Match __get_user_pages(): flush for VIVT/aliasing caches. */
 			flush_anon_page(vma, page, addr);
@@ -1529,7 +1540,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1544,7 +1554,7 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
+		unsigned long page_increm;
 
 		/* first iteration or cross vma bound */
 		if (!vma || start >= vma->vm_end) {
@@ -1571,7 +1581,7 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				page_mask = 0;
+				page_increm = 1;
 				goto next_page;
 			}
 
@@ -1594,7 +1604,8 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, gup_flags, &page_mask);
+		page = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+					gup_flags, &page_increm);
 		if (!page || PTR_ERR(page) == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
@@ -1627,7 +1638,6 @@ static long __get_user_pages(struct mm_struct *mm,
 			goto out;
 		}
 next_page:
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
 
-- 
2.53.0-Meta


