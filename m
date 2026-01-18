Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D5DC98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 20:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD0C6B00CE; Sun, 18 Jan 2026 15:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595346B00CF; Sun, 18 Jan 2026 15:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498136B00D0; Sun, 18 Jan 2026 15:34:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5936B00CE
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:34:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEBED1405E0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:34:46 +0000 (UTC)
X-FDA: 84346238172.11.C4A1B38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0440240009
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:34:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yp9Omi+U;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768768485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXjFIywGCeawKJ3x763Bn9+9hKYrYLVFDceaSleabVc=;
	b=GPthtDbscmuLilren2PgcquOqSMSb4XJkWRqMMjuNhH000kBiev5Lv5VmL43rO2hARv59L
	hGMcKR2clst8HAOuOZXn/DMmU04Q9d4FTJrDs0SbheGYrkXluE6nP1Y+20aur9Ab9q3ubh
	lTqaH9z9ZARU0euANoU2K0tCa0EJx/Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yp9Omi+U;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768768485; a=rsa-sha256;
	cv=none;
	b=Avv8eQvPCOQpVUzRgwIDtPdJOb+g8/7T886ZZn9A9XSMF1znFrfkW5CtHCaDe7YPlxr49Y
	7xn1GJpnHVwnycvbcOvQ5KLIMCdiR6hYeyefcXQDikZf+l5UEwvGZxZTN4ppLIQ3hNR6Yn
	PtpKSyUhuibIwzuxnAIeCUM/LIqiSBI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2135760126;
	Sun, 18 Jan 2026 20:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C06C116D0;
	Sun, 18 Jan 2026 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768768483;
	bh=e9h+pp7oNwHgEcYrXOOefHF6AY4g+1SO+8eZNn/P28U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yp9Omi+U7pDXrgu2LcbDZiONkEiU5K0Om2mCGVyztQemI/4kCRLcD4bT85h7HcsIp
	 ulg5q5VKppOQt5PkiZxudm/ycHx+v32t1DO/9SMTSOs3QTuK/Rj7ivVDsF1aWCUpAo
	 46HT7Sn0ZM+8rikr/qTl0EXLV5fx3vdjc2ZRr/LU=
Date: Sun, 18 Jan 2026 12:34:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/5] mm/khugepaged: cleanups and scan limit fix
Message-Id: <20260118123442.f55db3e141388836df0c7785@linux-foundation.org>
In-Reply-To: <20260118192253.9263-4-shivankg@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 15yes5ezhaozei54fwoxao5rfkfedsfe
X-Rspamd-Queue-Id: 0440240009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768768484-952891
X-HE-Meta: U2FsdGVkX18vNN7F3AxRBBp3Hnla/wjpMulDXcAlOjBhALpuf9UZZl+xdX3Nmr95RzQO3kxkUW1LUSKixOicbL9UrIf92sdQJX0ZaKrANv4HNtZBGNj0X6h8zEZ94Q+ELLItFMwHd07x/YJ7lbfK+7u0AF6zLD1NQFUJZiUACTTi+4WWaBwqn1ppBWftl0AycFndZ9je+x1juW6ttp4bWq4woh1qymtNN6XYCuR3+kSGWKGnEaqN3cCDymA2kBq4c1Jf5upXc9JSHhUlRL96Rc30B1z4FZiMiXEdDTU9hyKQOqZTSHH8XPe4kukxS50h07OpWnOFHSkDNZLGKViYGbCh2yKCxrJzP+/7oBeJNCS3y+/qSb/RhWf/DDPZSJKOtbJ3tz9K3c3wpj5IWvnEcyYaSN0AIozjUv9Pzd6sLm07rzpsuEfOU90Y53hHvpGsV6oAqNYNkeG3OCZStbeXk+/mMumMNhxM9sf1U8P4ErvlS8wLsBNmZGKnRiQQ+6jiw1tu2uO9mHPRxTsa+2brB3Y+zxsgAQSCBEpZtUImPjxBrqUwYMdB3DahP6Za44oGHp9/9g0GtTXa3I+CM3zEfgAi4b5y2WcwmJXbm91Qz9xehyBVJuptP50PQmpS9hOdF3U9sx8hxBRbyaiXT52AkVkxJwfLQvpfXshrN/IW82ZdwPOTkT7fKDFgCXnq+DFk0BY+DgYPReA+lFQYCIs2tpFYrjdcw1eOti4eT8YDfBb4p4BaFdklm6AugfDtP7HEIcWbHEfmFl2YDQEIdw9hH15zR16JFcH9wlkcoco0QejPkQgirRDFcP9hqsjP3eNUXK6EvRYuMpMDix5IQu3hMNmhhYLdXMFcBLEBheKOPdMjoNrJgiKQ7bfpBFRBnZBjOjpCLO1Kwwu7d1ZCnAhbUVUPupOwEu5O5z19i+Ns4gcN0br/+LG/VaAJcNVyW4xTgKXt/kgvO02SW2qNQd3
 vMGmOGC6
 IishvwNISJM7ifU5f+IPtUZkE2rxsgqyWrhEmgg5RCNwj37k+NT5b6j0LWwkJsYUMnRbszOjMQ7gBhWDyZLie4eZdHK9A18jj/kXRdTiI9gUGm5+X57+lDrnVpoA8SHSuOTL1AyIF+ff+x0B/mZ9XyNyL1eYOn7y42fGXpZ4FDHMoGGPSOSsi2TBEJftnlY7IcPR1+zydIu8SBOsbU6d3LfVZ5v/KNG3iNoISWTJgpJh2mez7LlOaoccwqeUI7RUUfOJp2WRymM8E03bORdepvEPuq/iTxAkYwtZ3/NxuV4eHWee+ieecmluUXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Jan 2026 19:22:51 +0000 Shivank Garg <shivankg@amd.com> wrote:

> This series contains several cleanups for mm/khugepaged.c to improve code
> readability and type safety, and one functional fix to ensure
> khugepaged_scan_mm_slot() correctly accounts for small VMAs towards
> scan limit.
> 

That's a lot of changes to a well-reviewed 24 day old patchset.

> 
> v3:
> - Fold mm-khugepaged-count-small-vmas-towards-scan-limit-fix: add comment (Lance)
> - Remove extern and use two tabs indent (David) 

Are you sure?  The v2->v3 diff is large.  A lot of (unchangelogged)
alterations from `int' to `enum scan_result'.

It all looks pretty simple/straightforward to me but again, can
reviewers please check this over fairly soonly, thanks.



--- a/include/linux/khugepaged.h~b
+++ a/include/linux/khugepaged.h
@@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
-extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				    bool install_pmd);
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -43,7 +43,7 @@ static inline void khugepaged_enter_vma(
 {
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
-					   unsigned long addr, bool install_pmd)
+		unsigned long addr, bool install_pmd)
 {
 }
 
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -537,17 +537,16 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long start_addr,
-					pte_t *pte,
-					struct collapse_control *cc,
-					struct list_head *compound_pagelist)
+static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
+		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
+		struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
@@ -780,13 +779,13 @@ static void __collapse_huge_page_copy_fa
  * @ptl: lock on raw pages' PTEs
  * @compound_pagelist: list that stores compound pages
  */
-static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
+static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
 		unsigned long address, spinlock_t *ptl,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
@@ -898,10 +897,8 @@ static int hpage_collapse_find_target_no
  * Returns enum scan_result value.
  */
 
-static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-				   bool expect_anon,
-				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -930,7 +927,7 @@ static int hugepage_vma_revalidate(struc
 	return SCAN_SUCCEED;
 }
 
-static inline int check_pmd_state(pmd_t *pmd)
+static inline enum scan_result check_pmd_state(pmd_t *pmd)
 {
 	pmd_t pmde = pmdp_get_lockless(pmd);
 
@@ -953,9 +950,8 @@ static inline int check_pmd_state(pmd_t
 	return SCAN_SUCCEED;
 }
 
-static int find_pmd_or_thp_or_none(struct mm_struct *mm,
-				   unsigned long address,
-				   pmd_t **pmd)
+static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+		unsigned long address, pmd_t **pmd)
 {
 	*pmd = mm_find_pmd(mm, address);
 	if (!*pmd)
@@ -964,12 +960,11 @@ static int find_pmd_or_thp_or_none(struc
 	return check_pmd_state(*pmd);
 }
 
-static int check_pmd_still_valid(struct mm_struct *mm,
-				 unsigned long address,
-				 pmd_t *pmd)
+static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
+		unsigned long address, pmd_t *pmd)
 {
 	pmd_t *new_pmd;
-	int result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
+	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
 
 	if (result != SCAN_SUCCEED)
 		return result;
@@ -985,15 +980,14 @@ static int check_pmd_still_valid(struct
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
-static int __collapse_huge_page_swapin(struct mm_struct *mm,
-				       struct vm_area_struct *vma,
-				       unsigned long start_addr, pmd_t *pmd,
-				       int referenced)
+static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
+		int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
 	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
-	int result;
+	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
@@ -1062,8 +1056,8 @@ out:
 	return result;
 }
 
-static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-			      struct collapse_control *cc)
+static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
+		struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
@@ -1090,9 +1084,8 @@ static int alloc_charge_folio(struct fol
 	return SCAN_SUCCEED;
 }
 
-static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
-			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
@@ -1100,7 +1093,7 @@ static int collapse_huge_page(struct mm_
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 
@@ -1246,15 +1239,14 @@ out_nolock:
 	return result;
 }
 
-static int hpage_collapse_scan_pmd(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long start_addr, bool *mmap_locked,
-				   struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int result = SCAN_FAIL, referenced = 0;
-	int none_or_zero = 0, shared = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
@@ -1441,8 +1433,8 @@ static void collect_mm_slot(struct mm_sl
 }
 
 /* folio must be locked, and mmap_lock must be held */
-static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmdp, struct folio *folio, struct page *page)
+static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmdp, struct folio *folio, struct page *page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
@@ -1477,10 +1469,11 @@ static int set_huge_pmd(struct vm_area_s
 	return SCAN_SUCCEED;
 }
 
-static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				       bool install_pmd)
+static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
 {
-	int nr_mapped_ptes = 0, result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
+	int nr_mapped_ptes = 0;
 	unsigned int nr_batch_ptes;
 	struct mmu_notifier_range range;
 	bool notified = false;
@@ -1712,7 +1705,7 @@ drop_folio:
  * as pmd-mapped. Possibly install a huge PMD mapping the THP.
  */
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-			     bool install_pmd)
+		bool install_pmd)
 {
 	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
 }
@@ -1862,9 +1855,8 @@ drop_pml:
  *    + unlock old pages
  *    + unlock and free huge page;
  */
-static int collapse_file(struct mm_struct *mm, unsigned long addr,
-			 struct file *file, pgoff_t start,
-			 struct collapse_control *cc)
+static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
@@ -1872,7 +1864,8 @@ static int collapse_file(struct mm_struc
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
-	int nr_none = 0, result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
+	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
@@ -2293,16 +2286,15 @@ out:
 	return result;
 }
 
-static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-				    struct file *file, pgoff_t start,
-				    struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	present = 0;
 	swap = 0;
@@ -2400,7 +2392,7 @@ static int hpage_collapse_scan_file(stru
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2562,7 +2554,7 @@ static void khugepaged_do_scan(struct co
 	unsigned int progress = 0, pass_through_head = 0;
 	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
 	bool wait = true;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	lru_add_drain_all();
 
@@ -2775,7 +2767,8 @@ int madvise_collapse(struct vm_area_stru
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long hstart, hend, addr;
-	int thps = 0, last_fail = SCAN_FAIL;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
 	bool mmap_locked = true;
 
 	BUG_ON(vma->vm_start > start);
@@ -2796,7 +2789,7 @@ int madvise_collapse(struct vm_area_stru
 	hend = end & HPAGE_PMD_MASK;
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		int result = SCAN_FAIL;
+		enum scan_result result = SCAN_FAIL;
 		bool triggered_wb = false;
 
 retry:
_


