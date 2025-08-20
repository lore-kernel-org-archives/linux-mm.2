Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11979CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58F08E003F; Wed, 20 Aug 2025 05:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30408E003E; Wed, 20 Aug 2025 05:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83F68E003F; Wed, 20 Aug 2025 05:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEDB8E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61CB31DC844
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:46 +0000 (UTC)
X-FDA: 83796558132.14.8548AEF
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4BF3A160012
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eiFBmUyn;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680864; a=rsa-sha256;
	cv=none;
	b=iqjc/1zsJ8fEc3zxgYYnKB5TCOb5Ld5V8LGYLf3ZF7bXk7U3z0eTSHDF//qcNfpvTN39Jb
	HOpw7LE6ba78VexbciR3EPqPhPpc/eKf398RgyayvB0ad1DoNJWaCjwdZLnXz6A1q2FU7i
	FZwGpcimNW2wbRKQEz9JxEuPmDUclHM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eiFBmUyn;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d861k2/gR3LU0SyA7Qgfbs2BiibixgL7AImClvK96mk=;
	b=tHWBvzj318VbjUu/mNE3LY1j5FZBT0F3bmSTDzBS/5nnWL2vGGQWdvMjvR5gvLloZbScoC
	SjH+GrjOZ9VJFoYpHgcx1uxC0EMa1+/S7f6DAYrcSDyEHQPwuH9TFqbB/MowyXagVgjP1W
	oknSSzPVeJ4+RXsWw09jIoo44BiUo7E=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680861; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=d861k2/gR3LU0SyA7Qgfbs2BiibixgL7AImClvK96mk=;
	b=eiFBmUynNdcecFONKJHzv1pGE8TDJuvUGYPZggCuviyMwQFGlBjjYur7PijCG8kzrUvi1yrnqq+KNyftWuOKdb2NFPFmEqZczn6o0z6mcYfecOf6AXXXNJxoU1hrTI8t68efWIsrZrpBuFIXcZ+cHlRMzLJWUbyAttEQ6zFC8ls=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBY55V_1755680857 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:38 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 04/11] mm: khugepaged: add shmem/file mTHP collapse support
Date: Wed, 20 Aug 2025 17:07:15 +0800
Message-ID: <a05642935d6e38963d8d71de1570d9ffbfa96ab6.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4BF3A160012
X-Stat-Signature: gj7cye7s8fm1k656bzbfd8gsaoa4556b
X-Rspam-User: 
X-HE-Tag: 1755680863-4328
X-HE-Meta: U2FsdGVkX18L9s9FSqJ/P+DrhVE2YtFFuj0fVsTw3oQJXXo8wPXz5yZA7eqvY8EPKG3uFTxZtjYCZQs1cHiEWe6gHI///tUU13hnWP7wU5U1PZ2D9A5xevWkInKEWVRZjoWPVqbTNdU4r09uao2qV44xMXCNmeX/EPDrZdUl2tHebj7Auda/36zo0cVkz5eKLymT8Ro2iqe03PRHLLIsHe3cdeC+N6eMLTrPlgvDaKsDTND5096VWyELx6bPLs9QPw9dxRdHr/+hUZE0yt5kcmCyRida2TF74heHCEKjCo4aVMHD3kp5FFe3MStXE961ntJ34+fn5UQ3KtdEuP4LpnDWLsZQWXecKE9V5tq4MGhU4hJBtsjzVMi+B5QcoATaP6ahpxblr7huDJAVt7hJgPDp0xwofZ3dzSjxcapcOdZtRncTOcbHEwwqPsRzG3A0kU9ofiMwkku34RFn1EoW+TiHkTA3SqF+o3GyTFw/Hor84GBS2wejFQ98iIcVz1aBc0vPsrLbCQYklInbvmXwzc9EkGK1UMo52JBo1CaQOIIB3myRzkX6bInvCRyKm3cxUq831BGVatnJtyHjEx9zBBWIxyxBINjQbBlCMSNEGKIJYTGOLm/LHKWOE72qWKtRUoJvexcDZZ9MHEhy62lUNBO8tb+c/juG+w7g0EPFyravgtr2B1gFFEMbmI/JpDKcOOA/6CA2wiia1Ij2izUzPrOR6ITFcZ7rlFPtd6PbSPMg3ZxBAYFBKs35aOBcMWV2jiOG1ID8ynq146jL4/PXfLQm54U6l8w3tj2v9KX+18tZW/5Jja9fVPgUDtOcH6OMd1fuhKZCxV1CbOKU2Eod8iBytq46BxsCmaHF4Fye6/PL46wv7vbXgInOilkF2DjlsajO0a0fZRvhSnn7AdKwjm13Y6zYsbEYF7gI2ldLSD2DfF2gFCWX5J4QcoM6gPX55bWFnG5mb4fpt/TEoMI
 FlOKissX
 d0ZeRMtMweawP0/LbAK0gznEe4hZjUmd6EyIr3pla0RGHAeBUzWzF+rjY/0459NOdPyDQWAAOH/mumE+BHVg3IjjMW+ixFRSMKtCopKS9g1sxYYYNPdvoB7mmWl1uKs75RyKmD3NS7yhpy0GTA/XDUdQQJZdy4x2DkCXFzR12z39ctuuZvwIhhH+S3QUtbEs0H592aQbNXn9h3/sFqel891hU9oywZsd4kGL/9mn7iHI1ocVri9vGaeNgu5qK9qPdeZmqgtvJDTE8qKuMEpLhVJJvaIGLGNWuDaBO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Khugepaged already supports the anonymous mTHP collapse. Similarly, let
khugepaged also support the shmem/file mTHP collapse. The strategy for
shmem/file mTHP collapse follows the anonymous mTHP collapse, which is,
quoting from Nico:

"while scanning PMD ranges for potential collapse candidates, keep
track of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER PTEs.

After the scan is complete, we will perform binary recursion on the bitmap
to determine which mTHP size would be most efficient to collapse to. The
'max_ptes_none' will be scaled by the attempted collapse order to determine
how full a THP must be to be eligible.
"

Moreover, to facilitate the scanning of shmem/file folios, extend the
'cc->mthp_bitmap_temp' bitmap to record whether each index within the
PMD range corresponds to a present page, and then this temp bitmap is used
to determine whether each chunk should be marked as present for mTHP
collapse.

Currently, the collapse_pte_mapped_thp() does not build the mapping for mTHP.
Cause we still expect to establish the mTHP mapping via refault under the
control of fault_around. So collapse_pte_mapped_thp() remains responsible
only for building the mapping for PMD-sized THP, which is reasonable and
makes life easier.

Note that we do not need to remove pte page tables for shmem/file mTHP
collapse.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 133 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 107 insertions(+), 26 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 195c26699118..53ca7bb72fbc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -113,7 +113,7 @@ struct collapse_control {
 	 * 1bit = order KHUGEPAGED_MIN_MTHP_ORDER mTHP
 	 */
 	DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
-	DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
+	DECLARE_BITMAP(mthp_bitmap_temp, HPAGE_PMD_NR);
 	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE];
 };
 
@@ -147,6 +147,10 @@ static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+static int collapse_file(struct mm_struct *mm, unsigned long addr,
+			struct file *file, pgoff_t start,
+			struct collapse_control *cc, int order);
+
 #ifdef CONFIG_SYSFS
 static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
 					 struct kobj_attribute *attr,
@@ -1366,7 +1370,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 /* Recursive function to consume the bitmap */
 static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
-			int referenced, int unmapped, struct collapse_control *cc,
+			struct file *file, int referenced, int unmapped,
+			pgoff_t start, struct collapse_control *cc,
 			bool *mmap_locked, unsigned long enabled_orders)
 {
 	u8 order, next_order;
@@ -1401,10 +1406,14 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
 
 		/* Check if the region is "almost full" based on the threshold */
 		if (bits_set > threshold_bits || is_pmd_only
-			|| test_bit(order, &huge_anon_orders_always)) {
-			ret = collapse_huge_page(mm, address, referenced, unmapped,
-						 cc, mmap_locked, order,
-						 offset * KHUGEPAGED_MIN_MTHP_NR);
+			|| (!file && test_bit(order, &huge_anon_orders_always))) {
+			if (file)
+				ret = collapse_file(mm, address, file,
+						start + offset * KHUGEPAGED_MIN_MTHP_NR, cc, order);
+			else
+				ret = collapse_huge_page(mm, address, referenced, unmapped,
+						cc, mmap_locked, order,
+						offset * KHUGEPAGED_MIN_MTHP_NR);
 
 			/*
 			 * Analyze failure reason to determine next action:
@@ -1418,6 +1427,7 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
 				collapsed += (1 << order);
 			case SCAN_PAGE_RO:
 			case SCAN_PTE_MAPPED_HUGEPAGE:
+			case SCAN_PAGE_COMPOUND:
 				continue;
 			/* Cases were lower orders might still succeed */
 			case SCAN_LACK_REFERENCED_PAGE:
@@ -1481,7 +1491,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 
 	bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
-	bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
+	bitmap_zero(cc->mthp_bitmap_temp, HPAGE_PMD_NR);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 
@@ -1649,8 +1659,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_scan_bitmap(mm, address, referenced, unmapped, cc,
-					      mmap_locked, enabled_orders);
+		result = collapse_scan_bitmap(mm, address, NULL, referenced, unmapped,
+					      0, cc, mmap_locked, enabled_orders);
 		if (result > 0)
 			result = SCAN_SUCCEED;
 		else
@@ -2067,6 +2077,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 struct collapse_control *cc,
 			 int order)
 {
+	int max_scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
@@ -2128,9 +2139,10 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 				}
 				nr_none++;
 
-				if (cc->is_khugepaged && nr_none > khugepaged_max_ptes_none) {
+				if (cc->is_khugepaged && nr_none > max_scaled_none) {
 					result = SCAN_EXCEED_NONE_PTE;
 					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+					count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 					goto xa_locked;
 				}
 
@@ -2223,6 +2235,18 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/*
+		 * If the folio order is greater than the collapse order, there is
+		 * no need to continue attempting to collapse.
+		 * And should return SCAN_PAGE_COMPOUND instead of SCAN_PTE_MAPPED_HUGEPAGE,
+		 * then we can build the mapping under the control of fault_around
+		 * when refaulting.
+		 */
+		if (folio_order(folio) >= order) {
+			result = SCAN_PAGE_COMPOUND;
+			goto out_unlock;
+		}
+
 		if (folio_mapping(folio) != mapping) {
 			result = SCAN_TRUNCATED;
 			goto out_unlock;
@@ -2443,12 +2467,12 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
+	 * Remove pte page tables for PMD-sized THP collapse, so we can re-fault
+	 * the page as huge.
 	 * If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp().
 	 */
-	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
-		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	if (order == HPAGE_PMD_ORDER)
+		retract_page_tables(mapping, start);
 	folio_unlock(new_folio);
 
 	/*
@@ -2504,21 +2528,35 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-			      struct file *file, pgoff_t start,
+static int collapse_scan_file(struct mm_struct *mm, struct vm_area_struct *vma,
+			      unsigned long addr, struct file *file, pgoff_t start,
 			      struct collapse_control *cc)
 {
+	int max_scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER);
+	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
-	int present, swap;
+	int present, swap, nr_pages;
+	unsigned long enabled_orders;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
+	bool is_pmd_only;
 
 	present = 0;
 	swap = 0;
+	bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
+	bitmap_zero(cc->mthp_bitmap_temp, HPAGE_PMD_NR);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	if (cc->is_khugepaged)
+		enabled_orders = thp_vma_allowable_orders(vma, vma->vm_flags,
+				type, THP_ORDERS_ALL_FILE_DEFAULT);
+	else
+		enabled_orders = BIT(HPAGE_PMD_ORDER);
+	is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
+
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
@@ -2587,7 +2625,20 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		 * is just too costly...
 		 */
 
-		present += folio_nr_pages(folio);
+		nr_pages = folio_nr_pages(folio);
+		present += nr_pages;
+
+		/*
+		 * If there are folios present, keep track of it in the bitmap
+		 * for file/shmem mTHP collapse.
+		 */
+		if (!is_pmd_only) {
+			pgoff_t pgoff = max_t(pgoff_t, start, folio->index) - start;
+
+			nr_pages = min_t(int, HPAGE_PMD_NR - pgoff, nr_pages);
+			bitmap_set(cc->mthp_bitmap_temp, pgoff, nr_pages);
+		}
+
 		folio_put(folio);
 
 		if (need_resched()) {
@@ -2597,16 +2648,46 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	}
 	rcu_read_unlock();
 
-	if (result == SCAN_SUCCEED) {
-		if (cc->is_khugepaged &&
-		    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
+	if (result != SCAN_SUCCEED)
+		goto out;
+
+	if (cc->is_khugepaged && is_pmd_only &&
+	    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+		goto out;
+	}
+
+	/*
+	 * Check each KHUGEPAGED_MIN_MTHP_NR page chunks, and keep track of it
+	 * in the bitmap if this chunk has enough present folios.
+	 */
+	if (!is_pmd_only) {
+		int i;
+
+		for (i = 0; i < HPAGE_PMD_NR; i += KHUGEPAGED_MIN_MTHP_NR) {
+			if (bitmap_weight(cc->mthp_bitmap_temp, KHUGEPAGED_MIN_MTHP_NR) >
+					  KHUGEPAGED_MIN_MTHP_NR - max_scaled_none)
+				bitmap_set(cc->mthp_bitmap, i / KHUGEPAGED_MIN_MTHP_NR, 1);
+
+			bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bitmap_temp,
+					   KHUGEPAGED_MIN_MTHP_NR, HPAGE_PMD_NR);
 		}
+
+		bitmap_zero(cc->mthp_bitmap_temp, HPAGE_PMD_NR);
+	}
+	result = collapse_scan_bitmap(mm, addr, file, 0, 0, start,
+				      cc, NULL, enabled_orders);
+	if (result > 0) {
+		if (cc && !cc->is_khugepaged)
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+		else
+			result = SCAN_SUCCEED;
+	} else {
+		result = SCAN_FAIL;
 	}
 
+out:
 	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
@@ -2628,7 +2709,7 @@ static int collapse_single_pmd(unsigned long addr,
 
 		mmap_read_unlock(mm);
 		*mmap_locked = false;
-		result = collapse_scan_file(mm, addr, file, pgoff, cc);
+		result = collapse_scan_file(mm, vma, addr, file, pgoff, cc);
 		fput(file);
 		if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 			mmap_read_lock(mm);
-- 
2.43.5


