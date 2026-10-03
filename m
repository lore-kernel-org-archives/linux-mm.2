Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF975CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B968E6B00AA; Fri,  2 Oct 2026 20:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46776B00AF; Fri,  2 Oct 2026 20:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34BF6B00B0; Fri,  2 Oct 2026 20:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71CBE6B00AA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E445FA78E0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:32 +0000 (UTC)
X-FDA: 85279438944.19.FD50AEF
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0822F40005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gPnyiTBv5TsGXs9PmBtzJlrJ0YAGokAQftqOJQhvJwI=;
	b=Z0VzrgiXvc+avUi4lR1+ZGPgiERvi6rqCioW1K17TlqwtOK21RhtT25WM+PRCcZDU+5Pdz
	uzN23tamplP5NUVprWO6xxVJPum1jrb2duh+BkE0rLkhU2pMZQ1amWYF/mNfhuAE7z0cI5
	gg8WxaQqEFvBC67Oc+fE4O9fKkVqAvY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987551;
	b=BU3nxfSrG5+VBI1A/N9wbvwzRYZ+7sk25YEQ4ZZImeH7XJgPulaRUt8sdx6BqeuPWLV+G7
	WnsVzHVxyynYypIuewqTIcseqAXcYzCZlzxEy4Y/hJtVfQ02MbkCw/jZ/yMysQBHwxoYYB
	KCvT81fUZcmHa1Lx9xaWZAuOkxvKQCU=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ccd8864debaf321a;
	Sat, 03 Oct 2026 00:32:29 +0000
X-Mizu-Trace-ID: ccd8864debaf321a
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 06/14] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Sat,  3 Oct 2026 08:31:28 +0800
Message-ID: <20261003003136.750633-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0822F40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: a8fzhawpbtqojj48339ayhzgq16oujrf
X-HE-Tag: 1790987550-146526
X-HE-Meta: U2FsdGVkX1/i8idPKRgHQtG8fgTSxwOuyS7o5vEgkuMdULRPevCs+Xycyy4BFK3vOppCbJFDcQ8UEF4WSfaIdHn1tCDrh5GLqnc0UtJBdCaIf4IIeu5PTQz+j+QZd9YFP0nM4OJd5fZVvhVf5oTeVtVTB67+X9D9/EwC+2tYT8a8Mx91hBtzy+iWgB5K/eCFsin966HVd+YBxiaVjUOmmLXIwsH2jzNp1CaZAUHl8+PjyKJtbpt/fR7LRs2Nzx41wSlYWwi7kmsQtiQhnNxKQ+XF7MNF7Hbhczh+MTSiCERu6RJaOP0Y+WG+ile1KhpbyTuJXPBVtKVpsTemkNirNyTZIJDFQY1+Ha3KpZjtqcbUh8EjrqDKVOo6IdZDGirmUuR4zdAvM7EvjVijXzvVDTfOhbjO6C0tIWiZxw4/EzmKKdpotUydzH7ww+7WXoPSD1LVXR2vRgq0q0Kr9SG6gJt4zwluqfYhIOH3ygfODb5iwVjHr9DXnF/BaB4syGuhiSk46UI1O6EO8cgtdiF5wRvPBFUvUqihvzr1GhsP5anbozHXflltF9oqXzqMcM+1URK5id7ul+uT5OgCPlR/NtvvYH6aziv7aWoUBjsVW3LI16nxZ12YwLOgZR0LfCT+8dYpUhVjMIBLIxdBgwWga9Xc+vxmNxIzZG7Ir/vag9JUVj5FlTp739+Zli1kdj3y/zHDl8NFrgEmm+Yjidq27uS+QRY6gRdH5QWh8ZeqtDNjie+5XHiqwlXyzjgJPPaN9xFprVHLuSWEQVL28kqj47QsypeEY6wXjnvaZwu0IY5CwOYGu7eLnBsB8BsnUusRDCls/EZM8Avb4JDNHyyvMSU/dXErMfiHswUIkS7wKk9V0vHWk/dshX93Z1Sbn9IwQctOiBWxp2O+mqSV8ziUK56OF7rQllnCazbryVm4sIFjwwCO3iusr5ema7zC37i9DKfVdMzlpk8W3yAJ8Mh
 S8Co2igK
 K6eElf4A2T/vWbvBmtQSZsrYT49N1kqmFRnDNLy96zmJsdw7jftyb96Gp1HHyosPQMoBQOuVLdmmz/YoSpXIck/rpcNWO4assIZQpcFZZgyBgJijurQCAd2rOjuhTBMb4/VZxX6hR5oHEe51Ru+ttRCQbXucZuv3FFcDwksnlzcomHk2C+meIbVwBbh8iouRUmAYjsbI0LDZIFK7efBlGceiySpCoegXphKPXNG2I4Uw8VTQv6O1FSNBxcW79pMNGRrR6ZP/S6l+fedrF/II/fa03CnVZCOA3L+LS/zvrQ7a0AVqF06zdCJkfE5w4+AR51+EQGdMm2bs/duU7dBAmnplLCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a cluster becomes entirely free, the mapped range may now have a
free tail that nothing is using. Reclaim it: unmap the tail clusters
from the cluster_info VM_SPARSE area.

Only reclaim once the mapped range is at most 50% in use. Growth is
demand driven, so reclaiming on a smaller dip would only map the same
clusters again, and every unmap costs an RCU grace period.

Stop at 70% in use rather than at the end of the free tail. Unmapping
the whole tail would leave the range all but full, and the grow, which
starts at 85%, would be straight back for it; 70% is far enough below
that the workload has to do real work before the grow can fire. Keep at
least one chunk of free tail, so the next allocation has somewhere to
land.

Unmapping fewer than four chunks is not worth the RCU grace period, so
leave the range alone in that case.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 108 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 45050f8a2ed8..b8572f301d31 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -60,12 +60,13 @@
 
 #ifdef CONFIG_XSWAP
 /*
- * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
+ * xswap: dynamically grow and shrink the cluster_info array via a
+ * VM_SPARSE area.
  *
- * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
- * operation.  It is set to the number of cluster_info structs that
- * fit in a single page (at least 16), so that the vmalloc page table
- * overhead is proportional to the number of clusters mapped.
+ * XSWAP_GROW_CLUSTERS is the number of clusters to map/unmap in one
+ * grow/shrink operation: the number of cluster_info structs that fit in
+ * a single page (at least 16), so that the vmalloc page table overhead
+ * is proportional to the number of clusters mapped.
  */
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
@@ -88,6 +89,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
+static void xswap_try_shrink(struct swap_info_struct *si);
 
 static int xswap_create(int prio);
 
@@ -716,6 +718,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	xswap_try_shrink(si);
+#endif
 }
 
 /*
@@ -1083,6 +1088,9 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON(!cluster_is_usable(ci, order));
 
+	/* ci is used without ci->lock; an xswap unmap waits for this. */
+	rcu_read_lock();
+
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
 
@@ -1111,6 +1119,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
+	rcu_read_unlock();
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -1154,6 +1163,9 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
 	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+		/* As in alloc_swap_scan_cluster(). */
+		rcu_read_lock();
+
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1178,6 +1190,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
+		rcu_read_unlock();
 		if (to_scan <= 0)
 			break;
 
@@ -1502,11 +1515,17 @@ static bool swap_alloc_fast(struct folio *folio)
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
+	 *
+	 * The cached offset indexes si->cluster_info, which xswap can
+	 * unmap; cover both the read and the use with RCU.
 	 */
+	rcu_read_lock();
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!si || !offset || !get_swap_device_info(si)) {
+		rcu_read_unlock();
 		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1518,6 +1537,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	}
 
 	put_swap_device(si);
+	rcu_read_unlock();
 	return folio_test_swapcache(folio);
 }
 
@@ -2308,8 +2328,11 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	/*
 	 * Try the local cluster first if it matches the device. If
 	 * not, try grab a new cluster and override local cluster.
+	 *
+	 * Same RCU requirement as swap_alloc_fast().
 	 */
 	local_lock(&percpu_swap_cluster.lock);
+	rcu_read_lock();
 	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
 	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 	if (pcp_si == si && pcp_offset) {
@@ -2319,6 +2342,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		else
 			swap_cluster_unlock(ci);
 	}
+	rcu_read_unlock();
 	if (!offset)
 		offset = cluster_alloc_swap_entry(si, NULL);
 	local_unlock(&percpu_swap_cluster.lock);
@@ -4019,6 +4043,15 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		return;
 	}
 
+	/*
+	 * A per-cpu cluster cache can still hold an offset in this range.
+	 * Invalidate those references, then wait out the readers that have
+	 * already loaded one, so that nobody can dereference cluster_info
+	 * past this point.  swapoff() needs the same before it releases.
+	 */
+	flush_percpu_swap_cluster(si);
+	synchronize_rcu();
+
 	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
 	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
 	/* TODO: free backing pages via page table walk or tracking bitmap */
@@ -4037,6 +4070,75 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
 	*mapped_end = addr + PAGE_SIZE;
 	return 0;
 }
+
+/*
+ * Automatic reclaim: leave one chunk of the free tail mapped as slack, so
+ * that the next allocation has somewhere to land, and only unmap once
+ * several chunks can go, so the unmap is worth the RCU grace period it
+ * costs.
+ */
+#define XSWAP_SHRINK_SLACK	XSWAP_GROW_CLUSTERS
+#define XSWAP_SHRINK_MIN	(XSWAP_GROW_CLUSTERS * 8)
+
+/*
+ * Try to shrink the cluster_info tail: unmap contiguous free clusters
+ * at the end of the mapped range.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	struct swap_cluster_info *ci;
+	unsigned long nr_mapped, last, keep, idx;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	if (nr_mapped <= 1) /* keep cluster 0 */
+		return;
+
+	/*
+	 * Reclaim on our own, but only once the mapped range is at most
+	 * SHRINK_WHEN in use: growth is demand driven, so reclaiming on a
+	 * smaller dip would only map the same clusters again, and every
+	 * unmap costs an RCU grace period.
+	 */
+	if (swap_usage_in_pages(si) * 100 >
+	    nr_mapped * SWAPFILE_CLUSTER * XSWAP_SHRINK_WHEN)
+		return;
+
+	/* Find the last non-free cluster from the tail */
+	last = nr_mapped;
+	while (last > 1) {
+		idx = last - 1;
+		ci = &si->cluster_info[idx];
+		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+			break;
+		last = idx;
+	}
+
+	if (last == nr_mapped)
+		return; /* nothing to shrink */
+
+	/* Below `last` has to stay mapped: the free ones in between are
+	 * not part of the tail, and unmapping them orphans what is above.
+	 */
+	if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
+		return;
+
+	/*
+	 * Stop at SHRINK_UNTIL rather than at the end of the tail, or the
+	 * range comes out full enough for the grow to be woken.
+	 */
+	keep = DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
+			    XSWAP_SHRINK_UNTIL * SWAPFILE_CLUSTER);
+	if (keep < last + XSWAP_SHRINK_SLACK)
+		keep = last + XSWAP_SHRINK_SLACK;
+
+	if (nr_mapped < keep + XSWAP_SHRINK_MIN)
+		return;
+
+	xswap_unmap_clusters(si, keep, nr_mapped - keep);
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
-- 
2.54.0


