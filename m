Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227BDCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38DF6B0095; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10246B0096; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D046B0098; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B916C6B0095
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884801C288B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:42 +0000 (UTC)
X-FDA: 84863631804.12.3FBE47E
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58035120003
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kn2aySCw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4biN/oAT+ak60w5oZZalu280HqYTdojibr3grv/ESUA=;
	b=RFxoDj+7fLMGPu26jQLeMNdFiPxOQVK0a1eAdgn4b+86PbtFERSiVDbmN6vnCYm2Irwl3J
	OgpYS6ZgZZh5+JO2wqcBnarx0/LheTmYfiKtQK84j0VKnbBy+CYdwBVUL5x65iztxOr8U0
	0UeohKzBbmN/6yyeHoUuB2EK6xhtSCo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kn2aySCw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087381;
	b=yqz52SPgmNNuz7deaos3vig6X3r7ZdAx4Ny6a3LdtBf+nu//lorina2bXNMtgqY/2suK1C
	30k3O0uCr+Yr3JXENR6h1iTRYfu3g2kUTvsMg4zOZLkckMe3ZXufq3Aj3Qa3kFFEv5TydM
	n6yu9jmQhM6Rc26SKkDgNyhWfLnozDk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087374; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4biN/oAT+ak60w5oZZalu280HqYTdojibr3grv/ESUA=;
	b=kn2aySCwtK9FjtTo9xQVNa3VBPq9VQcnCqd7C6fo681kNK1tstH94dVOar2QQ3rymyuMlB38yJ5bmYVq10r3j85lhpxgz9MBfQzIDSmM777fB0zm+spIjVPHscCvCxxEL5aJIOv+6KVRtPR7S6lPS/HVzS06zOXX8t992lgnklY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aI8WM_1781087372;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aI8WM_1781087372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:33 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse support
Date: Wed, 10 Jun 2026 18:29:12 +0800
Message-ID: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ywdeg463pozen47jgbatfomyfyhft3qr
X-Rspamd-Queue-Id: 58035120003
X-HE-Tag: 1781087378-117142
X-HE-Meta: U2FsdGVkX1+KpGFTD1Peo/AxFymuKKUqnllZJyflfmk8PyZA2D/mN4qdMGJljmpfrTOI1c6THlw+KmHrt1aOYoH6D6Ewm6gKViUBHJ08RATYuzyaxknEu0gnB6kA0cSXCEh+5+Q/qB73H3KMI4taZRW84GJIHxM/Wn6s2zNtnkO1zlk5FLynqqupMM/adsOd2ArI2S2Nt7tVWJmWjrNNpxGK7xIKei2YiVMo4WkILEJVNJ/ekC0rWpHBXEhralKBBlMw6n/mPIILKKAMVAanClvE1zWfK2swbRWKw4DZWFFywVH9lBBrFkDzFFwA+hwbY/7lNX/iEiixLx7P9HRpJ9sEevkJwywx+5PXLGrOXHhJfuKp/sPYaMnH5/Ka7ZWAv5ZTpTwyIILyjKOjbq0BIZ3wCcKx8wqSbfgSJdlLKqM5nyT1/Ez12rkLqScMrEeXwPITDaPmw51yzyxi/MDa0cAbPSRkG1pTM7ObDUOmqKoaya3bDnTvYQWPf4nkI0qaUZ7bq/xepFjL04b6LNddKDJyGkvPL2g+PjpKWFVak99S3I7rtGmJWBVznLZ8Pno0/2+nGC5ic3Vy9XRu0asJnCFbm7SUaeqeKkSj0c9CY3m26KbFKUeeWDtogyZjK5PHWEqdAUuKHucRkmUcYP9Tz5wuiFvUlxVjdFI/oQgAe0BpeUMC4QDqoYnN+eVjWyzl04wq2kzytG5yl61xJ8d5OrLMbZIiG8QnqxWyUMEwfFD9gsKgKBpVJ58ylfYIEj9dcMcDAzwAp50P7kIKNc3v1JN8f6xu3pvz3U3+h3/Qg4DeZnrWHuCJApiYX4trnd1tZAzbr8A+y9hsOf7vuu+fSGnmoBsqFWUuhRajw/zEXKAWYsZQUawmvMwczXfyW8VCeaM9Xm8GoC3drf0AWql+49UWGGfNPraTH3ns5CE5kv/YNVMAetudUmMyTpWeP0d+rDRnjUv0v6GM9djD9Dw
 lbT1HkPL
 sr0dEoQZaRXNXME0NNmOYqeB3tEc8Yn6XxnCVhPip9flkh2bDdrbCYcvIfTeauoI0kPPO1XqvPR7kxOKy7DgbEnk0hhXqzb3/AkTWMbQ8lxUskz2kHE3fUgB5sJwGuRAtGO+9nFnvYnlXy69iBZVeBoRZwCdD1SyUIBEQVujz/FO9m350lq1CtLp7fBZM7JxTu3zGXzlRXVdEDFJ+0WDdMpcdVyjrFt5L3+++TldCFZTqgp351fy2+M1Xae28dLa0OOX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Khugepaged already supports the anonymous mTHP collapse. Similarly, let
khugepaged also support the shmem mTHP collapse. The strategy for shmem
mTHP collapse follows the anonymous mTHP collapse:

Track present pages via a bitmap while scanning PMD ranges for collapse
candidates. After the scan completes, use the bitmap to determine the
most efficient mTHP order to collapse to. Scale 'max_ptes_none' by the
attempted collapse order to determine the minimum fill threshold for
eligibility. Similarly, shmem mTHP collapse rejects regions containing
swapped-out pages to avoid creep.

Currently, the collapse_pte_mapped_thp() does not build the mapping for mTHP.
Cause we still expect to establish the mTHP mapping via refault under the
control of fault_around. So collapse_pte_mapped_thp() remains responsible
only for building the mapping for PMD-sized THP, which is reasonable and
makes life easier.

Note that we do not need to remove pte page tables for shmem mTHP collapse.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 115 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 91 insertions(+), 24 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0c8dfbd48410..818d51915748 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -135,6 +135,10 @@ static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start,
+		struct collapse_control *cc, int order);
+
 #ifdef CONFIG_SYSFS
 static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
 					 struct kobj_attribute *attr,
@@ -1487,6 +1491,7 @@ static unsigned int max_order_from_offset(unsigned int offset)
  * mTHP.
  */
 static enum scan_result mthp_collapse(struct mm_struct *mm,
+		struct file *file, pgoff_t start,
 		unsigned long address, int referenced, int unmapped,
 		struct collapse_control *cc, unsigned long enabled_orders)
 {
@@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+			if (file)
+				ret = collapse_file(mm, collapse_address, file,
+						start + offset, cc, order);
+			else
+				ret = collapse_huge_page(mm, collapse_address,
+						referenced, unmapped, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 				collapsed += nr_ptes;
 				fallthrough;
 			case SCAN_PTE_MAPPED_HUGEPAGE:
+			case SCAN_PAGE_COMPOUND:
 				goto next_offset;
 			/* Cases where lower orders might still succeed */
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
@@ -1774,7 +1784,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	if (result == SCAN_SUCCEED) {
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
+		result = mthp_collapse(mm, NULL, 0, start_addr, referenced,
 				       unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
@@ -2306,7 +2316,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 				if (++nr_none > max_ptes_none) {
 					result = SCAN_EXCEED_NONE_PTE;
-					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+					if (is_pmd_order(order))
+						count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+					count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 					goto xa_locked;
 				}
 
@@ -2316,6 +2328,19 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
 				xas_unlock_irq(&xas);
+
+				/*
+				 * TODO: Support swapin without leading to further mTHP
+				 * collapses. Currently bringing in new pages via swapin may
+				 * cause a future higher order collapse on a rescan of the same
+				 * range.
+				 */
+				if (!is_pmd_order(order)) {
+					count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+					result = SCAN_EXCEED_SWAP_PTE;
+					goto xa_unlocked;
+				}
+
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index, 0,
 						&folio, SGP_NOALLOC)) {
@@ -2399,6 +2424,18 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2621,12 +2658,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
+	 * Remove pte page tables for PMD-sized THP collapse, so we can
+	 * re-fault the page as huge.
 	 */
-	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
-		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	if (is_pmd_order(order))
+		retract_page_tables(mapping, start);
 	folio_unlock(new_folio);
 
 	/*
@@ -2675,22 +2711,35 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 }
 
 static enum scan_result collapse_scan_file(struct mm_struct *mm,
-		unsigned long addr, struct file *file, pgoff_t start,
-		struct collapse_control *cc)
+		struct vm_area_struct *vma, unsigned long addr,
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
-	int present, swap;
-	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long enabled_orders, nr_pages;
+	struct folio *folio = NULL;
+	int node = NUMA_NO_NODE;
+	int present, swap;
+	pgoff_t pgoff;
 
 	present = 0;
 	swap = 0;
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
+	/*
+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
+	 * scan all pages to populate the bitmap for mTHP collapse.
+	 */
+	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
+		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
@@ -2754,7 +2803,17 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
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
+		pgoff = max_t(pgoff_t, start, folio->index) - start;
+		nr_pages = min_t(int, HPAGE_PMD_NR - pgoff, nr_pages);
+		bitmap_set(cc->mthp_present_ptes, pgoff, nr_pages);
+
 		folio_put(folio);
 
 		if (need_resched()) {
@@ -2768,15 +2827,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
-		}
+	if (result != SCAN_SUCCEED)
+		goto out;
+
+	if (present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+		count_mthp_stat(HPAGE_PMD_ORDER,
+				MTHP_STAT_COLLAPSE_EXCEED_NONE);
+		goto out;
 	}
 
+	result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
+	if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
+		/* If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp(). */
+		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	}
+out:
 	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
@@ -2808,7 +2875,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	mmap_read_unlock(mm);
 	*lock_dropped = true;
 retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	result = collapse_scan_file(mm, vma, addr, file, pgoff, cc);
 
 	/*
 	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
-- 
2.47.3


