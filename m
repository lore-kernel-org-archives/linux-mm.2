Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488C5C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60DCD6B00A6; Thu, 27 Aug 2026 05:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4856B00A7; Thu, 27 Aug 2026 05:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521F76B00A9; Thu, 27 Aug 2026 05:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5096B00A6
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7D1B12038E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:18 +0000 (UTC)
X-FDA: 85146568836.15.EE34740
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC39B2000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kuWZ8NaNv+X3vurfXxvgQyCfW4ka/+nAUvcukPQHh5g=;
	b=1HfxRYfSdtZ1DlmS7Ugf7n9Oqorjy+YK2CmQqwRXBLwH9ipBU4MYcifXx1wX7k8zb222K5
	6POYNz3dOjNJnNzsbpaa2lHXBxtmZZetXkY84eMCRhkFhBdjrc4L1ThtfMUEen3a8KYHwF
	nkmMtfW4Iv0182vrXsdVdQ8NTeOTv8I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823977;
	b=XUIa5jqfEoZ8rLfKde41CH8Rd1qO/w9CX4mw+y3zoQ3kXY8QN6yFMgCA00aCrcPNrUgVBe
	V/AJaD8jaFD0cRYEmaIo0yK+avxnQeyKnmtqQBV3XZUFBjnDY1Z6HOsgcwQyRE6SQurzpi
	hOwnMJHzGtKnnWZGnz7kb9BPKN+wH8c=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 79c451e103023864;
	Thu, 27 Aug 2026 09:46:10 +0000
X-Mizu-Trace-ID: 79c451e103023864
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 10/16] mm, swap: add nr_free_tail for O(1) xswap shrink detection
Date: Thu, 27 Aug 2026 17:45:00 +0800
Message-ID: <20260827094509.1016740-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z691589jbxaimsmyctqbhaij7mupdmm5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC39B2000F
X-Rspam-User: 
X-HE-Tag: 1787823976-610340
X-HE-Meta: U2FsdGVkX1+UG1S16S913+rChpbemxbRudIKk5/i8GqiJ+ez8/MPj3HtSuCrdrojMp3RdhfH/L2+d3x1eNCTkQ7RXslZ1hyqnZuEgtPc8pQQ++PdL3TjbkfFuTZdrInUMiMwtC3w8hscKhvQzT5x7bS3Xt2ZgKjqa6NtZIoAJK2qk/8HTDs+vI/gwZiTZWHalYNCvNDBW2ZnKtf0a6do9GT5e6DQmTms/d+vZaRndV41unPtJgaGpdRrnXAGSG0Cn2fy6Hyr4dxt2tRTd/cIMZOKKfN3Ouh5pKrL4lTCXKwpf7jygG1rPe8vV4XKI8lFIW2fU16TaDUIIybo7cR/wvtAJVlp7K1fQKoXsxm5aRktLCepqkj0dasBhxxUckFiolWMZr2cYgfDVgwlxQs+1Bk7hjhxmLjREq7qSuPAuF88PQlQkcZI826hS3/GVTUDAoGy9Jeq1QckAH/mb8YW5Gm0gOYBKaidkigRLY36Z65JUYhLAFHAWSlMf2UbGYhq1DJIpK6qNEEvZFHkws0IrC0zEvOlxQ9LOVHw5PiXLztBSVmP5pNzJyirBP826XgCoRMCoBULR5+iMhIeq0sfvHpPZ0slO7izg2nswCDEdzrvKUl8c5XwA2pnMmMgt3LckbsN6v3OEiTtlv1HyQVn3lI+QAdr/Pci/JG+GZ45GBt7/AkfKm5ZDJ64XlZLQlvgu/nVl5pzsTCTYUaCSk9NspLOqfRnxcKJ0hnvxGG5JZXUlOlm67DuGhIR50tuSZPteuBHi5FcVa7Ikdhsysq+U45tipxkC03Fax+5Ytcf91cNkvTYu8TAI8v8yvP6H3SWvZuY5vT0e1ykP+YAJCb9Ps/9AG6ked82on8o+zjIe2Mdtu+zooj58stzMAo1i0LTNoqndlj+qPNSP18ylkegBX1nQJgHJrJwMGbIYxUvIio2BRVxYU9eMjbrMMbskvAYrcMszHn4LQd1/aXGMvR
 5ImUbb7+
 nzwr6DJ5rsXtK2T9LJOoGAiChhl4bV1XDaNZQumN/wzeOnqBhQDyml85Y+VUQHpBH6hGEdeB0KjQ27f0vmg4asVaYocKPBCDe6QLz0t707HYMxagrC59tM0Ix1JjnyKb8crxCoiap5N6/4Zkzg268upPTF6TSv2UZcl7cm0Dw5+dksuWeA+sm5OHTiDMPE/3yIYRcLmKrtO6tgyuraWY3zqKHY+5xxCJgm+tPHkOCAZTfNmXMUe7qrEzzwEpvEMkvLc7QkojSyAmmBEVyDQfhUiMV5/74gfoaUnsgBxDHI1uq/ouJAeJjSC9Mt5UPXwkaTWqFq0T9xgXixEZx5T8McEc667CYJfaFrCHIHiUVa4AUryTdTQit96COvA==
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

3. Grow path: nr_free_tail += added - only the clusters actually
   added to the free list extend the tail; a concurrent grower that
   lost the race added none.

xswap_try_shrink() simplifies to a threshold check:
  if nr_free_tail >= XSWAP_GROW_CLUSTERS -> unmap

Setup initializes nr_free_tail = nr_clusters_mapped - 1 (all but
cluster 0 are free at the tail).

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 128 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 112 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c2744fa8a009..fea0005b9f51 100644
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
index 0fe4834eadde..5235c6d07ab2 100644
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
@@ -3918,37 +3925,124 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
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


