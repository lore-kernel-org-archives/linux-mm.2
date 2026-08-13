Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A25EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DD66B027E; Thu, 13 Aug 2026 06:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211A16B0280; Thu, 13 Aug 2026 06:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14EE16B0285; Thu, 13 Aug 2026 06:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D608C6B027E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 680DF1405C6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:30 +0000 (UTC)
X-FDA: 85095927420.20.4EE2DE8
Received: from mta0.migadu.com (out-93.mta0.migadu.com [91.218.175.93])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B61A120006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.93 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CWPd9ZDJxJ1RnlkkHAPyJL9rVOldyWCWlr5LLXIWefU=;
	b=qm55B4lqwwXHyiOwyTnr2b+R6AFYjf/PFTHeMrTo2HK2nhcxb5Fz5qTKiTCkryVJvvGAOj
	RwupcV3lsL6X/xTUkNjBnSEzj+AU6CyvM0N6mHAmPHjnljH2Ba/YJdillAblwVi9D7PQaJ
	ZBBaJqrtfjTD3A9hIehkm7n6n3jt78Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.93 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618228;
	b=HrhSVA8I8F0ECgTaQkaxlz44PDQWHj7X3G6psfYi3dePXwCC7tM3mGuyiawG6JrU2qZSXz
	IBh7sLEJoAew8kvVV4or7qOii3vS1J05W9HGl19UgpTidIsKxJq/YTjEFn2MQTo3ZO5QiR
	81qHMmqOA6GrDm4/HW8BGH/x7WKQNsg=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 7ecef4a0700bb19e;
	Thu, 13 Aug 2026 10:50:24 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 10/15] mm, swap: add nr_free_tail for O(1) xswap shrink detection
Date: Thu, 13 Aug 2026 18:48:49 +0800
Message-ID: <20260813104857.3450386-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x69x58couqrb3ca6cphtmyyu7dw1i6rw
X-Rspamd-Queue-Id: 7B61A120006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786618228-206691
X-HE-Meta: U2FsdGVkX195wugq9TuRbqs6dnoeI/o+n5YY6H1nu08yuQq74yG2Ptdo6fQSluQv8QV1ovNoEae/obIg+S7w/lBNo0z8ps8XWNqeFvoiz9Z0vdy559oQCJ/3HgWW/LpS1ih63KP75yq9FR5NDZ6xuNm2Ffz7F8ScmoeFRAqK4UMb8oPoT6Ihq/WJmf0htRoeVpY6CA4wJ9IIrXamcxRqc0yCkvyeAqEzuuLfWasq53uWjiwmPrkbp3B24Bkf0WVOnQxcX6DxFyhzSkUJ1VwwNAK8AJ5TgmOOYjMCTuxvQiJM02Bo4XzZxtdmKCH5/c1vMaaWVCF4CYx2pTjgRXiQATd8ci3k9XL8U1NTrLG8Wu6EItZwHMMLckYizWFSdZpIy/C9+ySTtIjlMZTTtdMHgRgw+IXJLVbMZUetP4JrWRCE8XDccBpJRJFmxv7QeD+4LadE3BAC+3Xehlfhnnwr0d6p2YtQj6F73YGtlInM1rHokPuwb17eoRx3CRU2t6/zaR03RIYkrBf4UF8rhlykCHM9kPUwkrhm4Nj40au4xs/G4DF6kMv7RhBtFMNavygGuQgNyP9Ly3SaPkjzzc78RR4it4n8myy2QBm8MNeOzkQS4mXTN7S8fcqglL0MW0MlYSNP4sWohvuZUb1fsz9i0LtApnZiNDSu5NbuuF773/Plv2k9FhpPnXTAgM7QRp/zrXYr1IhVy8rJfXRmYhReZHmA5M/xHse1jmzqd8yfdXM6CdKTZCiDFNbIyZmEQP2UXT+jGk5LrKmiGRXBBD85dxeNdlRRddio+2maIGCCu7o4NaOCCyD1lwO9dMHJIRzuBTx/K19SBTEEgYzrpTyrn9skfBAuGks44lUnQjSVmwfX1/7yvQ+m9HUilDs7q1RhishQqZwCH7t0LYuTYiE5suwt5s2r/xanU1b8mMzgG19rf0b4rgROP3+grA9nzmnnAioYluvA+ryRxKxQyv3
 izDivPCR
 aZw+TZTNURVj3XQjBqkwrmVMPEDTAGZbjiK1q2c5TilH+j5tTg1YrrWqTu7N/89nIxK443vlTzKqh9PWjk7Q3BcAtO6u40J8MGF0cyEvvsh100RbhHUtsBIsIXyuLh8rMtmuF9VTX9nFzEPs1qbFFQUy9a1zAd8AnVenKZBm/+MEIK0+yXOSrFb1r8evJVRVIudhSZx/B5915CAqfwAzg/ahjGKXyWep+iWP0DYboB31sewKJReAjgfGYhni8foEK9cqh0nT6jJYSTnbGNbO8TH9sMBdsX1495ztQQmszilk8Jl7OW94LQHoFRvOv8Lyo6H9vsFH+zIhEv0S13vFaYdQ3+cKbiO0HZoxf5Qu3GvKV6/tBIoHVOaSMvh4eZv7HPW8FBQpHZE0DtSU6s3Dvrp7xWnMKSheGJYCUha0NPAEAySIvr9y/lwZ+nYIyqmkmJwFjeSglOXZb08f4dqnN6d0iBneeQs3i5y80nEzOag4b5QrG7YsaK75EAqEO4APfhOL4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track contiguous free clusters at the tail of the mapped range in
si->nr_free_tail, maintained across alloc/free/grow paths.  This
eliminates the backwards scan on every shrink check.

Three paths maintain the counter:

1. xswap_update_free_tail(): called on cluster free.  If the freed
   cluster is adjacent to the existing tail boundary, increment and
   extend backwards to include already-free clusters now connected.

2. xswap_trim_free_tail(): called on cluster allocation.  If the
   allocated cluster lies within the tail free region, truncate the
   count to end just before it.

3. Grow path: nr_free_tail += added — only the clusters actually
   added to the free list extend the tail; a concurrent grower that
   lost the race added none.

xswap_try_shrink() simplifies to a threshold check:
  if nr_free_tail >= XSWAP_GROW_CLUSTERS → unmap

Setup initializes nr_free_tail = nr_clusters_mapped - 1 (all but
cluster 0 are free at the tail).

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 128 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 112 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c824848c6cfc..e8e6ac5680ff 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -252,6 +252,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
 	unsigned long		nr_clusters;	/* total cluster count for xswap */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c954313bbf75..fa76b8c9bd2d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -71,6 +71,9 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
+static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx);
+static void xswap_update_free_tail(struct swap_info_struct *si,
+				    unsigned long freed_idx);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
 #ifdef CONFIG_SYSFS
@@ -701,6 +704,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 #ifdef CONFIG_XSWAP
+	xswap_update_free_tail(si, ci - si->cluster_info);
 	xswap_try_shrink(si);
 #endif
 }
@@ -1049,6 +1053,9 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
+#ifdef CONFIG_XSWAP
+	xswap_trim_free_tail(si, cluster_index(si, ci));
+#endif
 	swap_range_alloc(si, nr_pages);
 
 	return true;
@@ -3911,37 +3918,124 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
 }
 
 /*
- * Try to shrink the cluster_info tail: unmap contiguous free clusters
- * at the end of the mapped range.
+ * Maintain si->nr_free_tail, the number of contiguous free clusters at
+ * the tail of the mapped range.  Called when a cluster at @freed_idx is
+ * freed.  Provides O(1) shrink detection: if nr_free_tail is non-zero,
+ * the tail can be unmapped without scanning cluster_info[].
+ *
+ * Only increments when @freed_idx is the cluster immediately before the
+ * existing tail region.  Then scans backwards for already-free clusters
+ * now connected to the tail, bounded by XSWAP_GROW_CLUSTERS at a time.
  */
-static void xswap_try_shrink(struct swap_info_struct *si)
+static void xswap_update_free_tail(struct swap_info_struct *si,
+				   unsigned long freed_idx)
 {
+	unsigned long nr_mapped, nr_tail, tid, i;
 	struct swap_cluster_info *ci;
-	unsigned long last, idx;
 
 	if (!(si->flags & SWP_XSWAP))
 		return;
-	if (READ_ONCE(si->nr_clusters_mapped) <= 1) /* keep cluster 0 */
+
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	nr_tail = READ_ONCE(si->nr_free_tail);
+
+	/* Protect against concurrent shrink that races past us */
+	if (nr_tail >= nr_mapped)
+		return;
+
+	tid = nr_mapped - nr_tail - 1;
+
+	/* Only the cluster immediately before the tail region counts */
+	if (freed_idx != tid)
 		return;
 
-	/* Find the last non-free cluster from the tail */
-	last = READ_ONCE(si->nr_clusters_mapped);
-	while (last > 1) {
-		idx = last - 1;
-		ci = &si->cluster_info[idx];
-		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+	nr_tail++;
+	WRITE_ONCE(si->nr_free_tail, nr_tail);
+
+	/* Extend: include already-free clusters now connected to the tail */
+	for (i = 1; i < XSWAP_GROW_CLUSTERS; i++) {
+		nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+		nr_tail = READ_ONCE(si->nr_free_tail);
+		if (nr_tail >= nr_mapped - 1)
+			break; /* reached cluster 0 */
+		tid = nr_mapped - nr_tail - 1;
+		ci = &si->cluster_info[tid];
+
+		if (READ_ONCE(ci->count) ||
+		    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
 			break;
-		last = idx;
+		nr_tail++;
+		WRITE_ONCE(si->nr_free_tail, nr_tail);
 	}
+}
 
-	if (last == si->nr_clusters_mapped)
-		return; /* nothing to shrink */
+/*
+ * Trim si->nr_free_tail when a cluster in the tail region is allocated.
+ * @idx: index of the cluster being allocated.
+ */
+static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
+{
+	unsigned long nr_mapped, nr_tail, tail_start;
 
-	/* Only unmap if we can free at least one full page of clusters */
-	if (si->nr_clusters_mapped - last < XSWAP_GROW_CLUSTERS)
+	if (!(si->flags & SWP_XSWAP))
 		return;
 
-	xswap_unmap_clusters(si, last, si->nr_clusters_mapped - last);
+	/*
+	 * nr_clusters_mapped and nr_free_tail are read locklessly;
+	 * concurrent updates may cause nr_free_tail to be trimmed
+	 * slightly less than ideally, which is harmless.
+	 */
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	nr_tail = READ_ONCE(si->nr_free_tail);
+	tail_start = nr_mapped - nr_tail;
+	if (idx >= tail_start)
+		WRITE_ONCE(si->nr_free_tail, nr_mapped - idx - 1);
+}
+
+/*
+ * Try to shrink the cluster_info tail.  Uses si->nr_free_tail which
+ * is maintained incrementally during alloc/free — no scanning needed.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	unsigned long start_idx, nr_unmap, i;
+	struct swap_cluster_info *ci;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+	if (si->nr_free_tail < XSWAP_GROW_CLUSTERS)
+		return;
+
+	nr_unmap = round_down(si->nr_free_tail, XSWAP_GROW_CLUSTERS);
+	start_idx = si->nr_clusters_mapped - nr_unmap;
+
+	/*
+	 * Verify the tail clusters are still free before unmapping.  Count the
+	 * contiguous free run first, then detach it in a second pass once the
+	 * whole run is confirmed long enough.  Detaching while counting would
+	 * leave a partial run off the free list if it proved too short to unmap.
+	 */
+	spin_lock(&si->lock);
+	for (i = start_idx; i < si->nr_clusters_mapped; i++) {
+		ci = &si->cluster_info[i];
+		if (ci->flags != CLUSTER_FLAG_FREE)
+			break;
+	}
+	nr_unmap = i - start_idx;
+	if (nr_unmap < XSWAP_GROW_CLUSTERS) {
+		spin_unlock(&si->lock);
+		return;
+	}
+
+	for (i = start_idx; i < start_idx + nr_unmap; i++) {
+		ci = &si->cluster_info[i];
+		list_del_init(&ci->list);
+		ci->flags = CLUSTER_FLAG_NONE;
+	}
+	spin_unlock(&si->lock);
+
+	xswap_unmap_clusters(si, start_idx, nr_unmap);
+	si->nr_free_tail -= nr_unmap;
 }
 #endif /* CONFIG_XSWAP */
 
-- 
2.54.0


