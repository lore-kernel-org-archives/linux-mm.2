Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1247C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607C56B009D; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8A06B009F; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5AC6B00A0; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA216B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD6461A055D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:59:01 +0000 (UTC)
X-FDA: 85225527282.12.29AB3BA
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A87740002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="X+/AthxS";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703939;
	b=0cUgF19fRl/8lh1+ZQE2RaaSUasUDHxoev/Tnydkb0oTIdfqbY24QxuIsdpq0vn37BcRHb
	3Lh3ZCCkCW39Mt4NryQZG3/PBtFkujUszidKsSe3Tz+U8QOsL6lFOlJXqVsXCW/FKyzjOs
	Ai87Nkpg6xjsPZKRKaT2gjSPbheffU4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="X+/AthxS";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVLNVVgni+ygI11Mkg6WFcdyrUYsnS6Lm8jx1pX0R4A=;
	b=udh5nxk5jlFxB6UGV4DE+EHAPy0cP7FfM1yagque652mo36ra1Kq/tZPVkl8L58JXQn6Xo
	FwqG+y+m/Q9sV8nB24HEPAJR6iZygJaI90ea2QtAF678Q2BhzKeacmMuYqZlkwYL4DjjTk
	wnXL/s3xsMzyxVHjJQKR6/fQtFz0Kfg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703936; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=GVLNVVgni+ygI11Mkg6WFcdyrUYsnS6Lm8jx1pX0R4A=;
	b=X+/AthxSxY0CnTgVwXl7QmtWDHOoZ0zguAWdxSMgpMLy7Y5VHc3ufPztOluMqtNRlHIGGs3W0IqpIVY+2QgMkJBGS08nJESkrXPEBi+hasbYVWVcSDhYIuQqohXnsWCzJXs1/Lq+8+ipfbsL070uMSBSHutk6TIBEjEpeNfEJ+Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9uK64_1789703934;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9uK64_1789703934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:54 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] mm: khugepaged: add shmem mTHP collapse support
Date: Fri, 18 Sep 2026 11:58:40 +0800
Message-ID: <0bcc8d5e6cc15670c83c643c0f0527138014fe6a.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A87740002
X-Rspam-User: 
X-Stat-Signature: e8enx8or19r3skq9y4n8hb9zxeuky8k5
X-HE-Tag: 1789703938-975415
X-HE-Meta: U2FsdGVkX1+j8ncftkA29AYOhtrA0fNbRHJJ+vAmgTk8Ux3498rMEPaF/T+TltNNiHEo06HbBfWej0I3h+mo5D9h0qLwyyY3XskkxYRF6n1N6GLqDZWHheFfSPhmyyOxSo56JPxpBB2u5BrAWQhK1WEnkGAJTwC7TN2GlkM1+WlzTtO5s02IVRY9b/rU0ofsWiDarvgzMREKDZxP6M7BE5o4tMqV2ClbON3c6vyCPZU6lddxK55G1a/Ba7UcUHDD9e2jku5U//3BtThq4SZsrlVXJDROgGNZvrfvcx786xM+eEQSZ0fqSV6gulCU3YxZkI65mfbVtA1Nuq710g4CpOq6N2QgPS0LtOFAfuij2xwR91rJwpaZhmF1tfKeuZ1ij8yU1a3/WJX+ZmHlzHxMNcA2d1B0bWmpGh1N1dcQzrrbstODoxBrQZwtxl0LJBhh+SGXn8ynJJNHnEL2dAgQId6d9IZrcU3teRcggMkQCcqYX9Rb5FULTK/uxM63E48ovqumrmBIEdiGdREQ8BiU7+Fn78pv9tqj33UU3TjmjgQ1sm5hc6xnVR/bswp6cw+/cn5Pr6HrbCLbgwPjA8i9/WvhZ5LZcuzKdfK/1nbT4UfbofvNCN3LYp+i9vQBAoph/kU/EDa0vErrddmzeidO2jQ0BRkHqua61j31kpYXla4zyLZrwUNAbpgCQqF3eO7rprBevmjvDAJYHuVz5uLP0BPXY3fc+lAqLSG/ywx8JMurvMVaKi3RKWFGBT5hMoWBx93udOLHKbRSY8btNyarCANefQ0RGCLNq3uCJ3nX/arwwS9T59MeEtdKXyBtTTrB4zkohP2T5dfPjkhWCNWkke1o/wwQ/EhelNarZibTWwFzBRMMiwfS5mLjoZZE/EK5uSJ/EkYPFW6M4k2SxLSOzqIqBrJCuJwJJbnz7nlr+G3eDhOcwOdOYm78yhR970uhLRHCEGDMOOvQmT2BXwQ
 AYhhVI5g
 Rv9EihviXd7wpF3tn1JziroK9AXv9aNsPzR1/qvR0QQFLzUV061pIxpO2WO3FAPiwCLfkNXqnYZTVSz7crXMbGpjLAlOyZH203Xk0Icmo3WJwLFnnxc3ByU8uaNvhMz1VxyKRAg0unLas5QTyKkVLsnuLu0OosNAdsPh6wlVM+Rm63+GZiObO64OZna/3+UxfC/hS9vqouj8X7T+0Lzjono+D5K/EliGc4acfnFBnORHv6gv/zOHYkLVO9VIunDDURaTY
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
 mm/khugepaged.c | 100 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 19 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 64605a72ac2b..dba747442461 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -84,6 +84,10 @@ static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start,
+		struct collapse_control *cc, int order);
+
 #ifdef CONFIG_SYSFS
 static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
 					 struct kobj_attribute *attr,
@@ -1452,7 +1456,11 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, cc, order);
+			if (cc->scan_file)
+				ret = collapse_file(mm, collapse_address, cc->scan_file,
+						cc->scan_pgoff + offset, cc, order);
+			else
+				ret = collapse_huge_page(mm, collapse_address, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1460,6 +1468,13 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
 				collapsed += nr_ptes;
 				fallthrough;
 			case SCAN_PTE_MAPPED_HUGEPAGE:
+				/*
+				 * Return SCAN_PTE_MAPPED_HUGEPAGE to call
+				 * collapse_pte_mapped_thp() if the page cache
+				 * already holds the PMD folio.
+				 */
+				if (order == HPAGE_PMD_ORDER)
+					last_result = ret;
 				goto next_offset;
 			/* Cases where lower orders might still succeed */
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
@@ -1493,7 +1508,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
 		 * any smaller order enabled. When at the smallest order
 		 * we must always move to the next offset.
 		 */
-		if (order > collapse_min_mthp_order(NULL) &&
+		if (order > collapse_min_mthp_order(cc->scan_file) &&
 		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
@@ -2237,7 +2252,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 				if (++nr_none > max_ptes_none) {
 					result = SCAN_EXCEED_NONE_PTE;
-					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+					count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
+							MTHP_STAT_COLLAPSE_EXCEED_NONE);
 					goto xa_locked;
 				}
 
@@ -2247,6 +2263,19 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
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
@@ -2330,6 +2359,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/*
+		 * If the folio order is greater than the collapse order, there is
+		 * no need to continue attempting to collapse.
+		 */
+		if (folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out_unlock;
+		}
+
 		if (folio_mapping(folio) != mapping) {
 			result = SCAN_TRUNCATED;
 			goto out_unlock;
@@ -2552,10 +2590,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.  A
-	 * caller that wants the PMD mapped now is told to go and do that.
+	 * Remove pte page tables for PMD-sized THP collapse, so we can
+	 * re-fault the page as huge.
 	 */
-	retract_page_tables(mapping, start);
+	if (is_pmd_order(order))
+		retract_page_tables(mapping, start);
 	if (cc->policy.install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
@@ -2606,10 +2645,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 }
 
 static enum scan_result collapse_scan_file(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
 	struct file *file = vma->vm_file;
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2619,10 +2659,19 @@ static enum scan_result collapse_scan_file(struct vm_area_struct *vma,
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
 	unsigned long failed_pfn = -1;
+	unsigned long nr_pages;
+	pgoff_t pgoff;
 
 	present = 0;
 	swap = 0;
 	collapse_scan_reset(cc);
+	/*
+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
+	 * scan all pages to populate the bitmap for mTHP collapse.
+	 */
+	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
+		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
+
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
@@ -2690,7 +2739,17 @@ static enum scan_result collapse_scan_file(struct vm_area_struct *vma,
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
+		bitmap_set(cc->eligible_ptes, pgoff, nr_pages);
+
 		folio_put(folio);
 
 		if (need_resched()) {
@@ -2706,7 +2765,8 @@ static enum scan_result collapse_scan_file(struct vm_area_struct *vma,
 
 	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
 		result = SCAN_EXCEED_NONE_PTE;
-		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+		count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
+				MTHP_STAT_COLLAPSE_EXCEED_NONE);
 	}
 
 	/*
@@ -2721,6 +2781,8 @@ static enum scan_result collapse_scan_file(struct vm_area_struct *vma,
 		 */
 		cc->scan_file = get_file(file);
 		cc->scan_pgoff = start;
+		cc->scan_orders = enabled_orders;
+		cc->scan_unmapped = swap;
 	}
 
 	trace_mm_khugepaged_scan_file(vma->vm_mm, failed_pfn, file, present, swap,
@@ -2778,7 +2840,7 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	if (vma_is_anonymous(vma))
 		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
-	return collapse_scan_file(vma, addr, cc);
+	return collapse_scan_file(vma, addr, cc, orders);
 }
 
 /*
@@ -2796,23 +2858,21 @@ enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
-	pgoff_t pgoff;
-
-	if (!file)
-		return mthp_collapse(mm, addr, cc);
-
-	cc->scan_file = NULL;
-	pgoff = cc->scan_pgoff;
 
 	/* The scan found the PMD folio in place: nothing to collapse */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		goto retract;
+
 retry:
-	result = collapse_file(mm, addr, file, pgoff, cc, HPAGE_PMD_ORDER);
+	result = mthp_collapse(mm, addr, cc);
+	/* Just return the results for anonymous folio collapse. */
+	if (!file)
+		return result;
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
+		pgoff_t pgoff = cc->scan_pgoff;
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
 
@@ -2821,6 +2881,8 @@ enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 		goto retry;
 	}
 retract:
+	cc->scan_file = NULL;
+	VM_WARN_ON_ONCE(!file);
 	fput(file);
 
 	/*
-- 
2.47.3


