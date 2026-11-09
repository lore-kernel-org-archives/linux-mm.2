Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C34606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HzXCYn9e
Received: by kanga.kvack.org (Postfix)
	id 083856B05C0; Mon,  9 Nov 2026 00:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AD86B05C1; Mon,  9 Nov 2026 00:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3BC6B05C2; Mon,  9 Nov 2026 00:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C05E76B05C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61CEDC05A1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:12 +0000 (UTC)
X-FDA: 85414520184.16.A64B870
Received: from mta1.migadu.com (out-165.mta1.migadu.com [95.215.58.165])
	by imf30.hostedemail.com (Postfix) with ESMTP id D8C5580003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HzXCYn9e;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.165 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3UFqlD1TFmjJCwgL5tSxyi3wQ9tXt9xXYoF+UX/60A=;
	b=nE+sSYXcKsLl5/wuonK+oSEhEKtdPCHb0x6k5s9gFU9S3rrO+drbZp/4i2uOQA0a5lyiSU
	x3ctEajPM4kVmB9XMKrbZcPWMllx2x0oizqOQ3F3ln2eGlkdMqkOsj0IniP48waBZm/MWm
	ta0Iw+H/2I+P72P1Cil9gy1Mu9xl+sI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203770;
	b=qoiNHBKWe1dg2Ppkr6Y6jZ1OYS2l6e95l18woFBwXRcx2XZA7Gp41vASoj3GPuH5+qCi+R
	b4GATAScf90pOrssZFn90Tpx2AdLteMA2R3qCZlXU6RvLvJzZb72CFO7fFobcDd4QCJfCh
	9I259PEDLPcenEI19/0FMaXyLzbdCPM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HzXCYn9e;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.165 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OF83+fcPJVloecqy+7k3LSEYtGZ3TgilD3z7GhpDFqI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203767; v=1; x=1794808567;
 b=HzXCYn9ed/CSifcz2HrbMsY7yB/DAJ7qIDmKUjEEVv5mdxJ+2LyuV/ynhA/JjjFWlnwiJO/n
 BAFlcaDaMcRL4WDpaMwHPu7TioCTwkgJNLBOfb0Q8maDjuZ1ieLwVc3XQY9yDBerp6G9xORbH7X
 0II7TfvfjPCnij7tusLyMqbw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 040407fe406acb30;
	Mon, 09 Nov 2026 05:56:07 +0000
X-Mizu-Trace-ID: 040407fe406acb30
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 04/19] mm, swap: use a VM_SPARSE cluster array for xswap devices
Date: Mon,  9 Nov 2026 13:54:40 +0800
Message-ID: <20261109055455.536925-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8C5580003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hwft15rhamyybceo1rbnggognzbt94jf
X-Rspam-User: 
X-HE-Tag: 1794203768-677689
X-HE-Meta: U2FsdGVkX188etIDCrg3t6ZA9jiGFwTHHa+R3HjG2BmcvEZIsen9ZkHF7lsWANv5YYSqUQ0RKcVsGd5ztp215n6Z57eqa0lj8gq8Ak4rILRw74hujEiXNJGG1Qqgz4zlivlTONqx6MC9HwUxNiW1B3qYWrjJUQlaLLupATFe5zDRyxsxIZQeqazIBFtOOXn37hnHl6RznMrmXTnYwZ7fVGOd2iFbBWygI6JZoSCsY/vOq54x+pdhWj2LYV9nlECvmYaCfFM7SAJYw1dGKKeGx6C/MzgNIn0OT82s7RSdmelWFUxuw7s4+5fpZUF6Y7hqKpJpJaswyzNXy+EG5TqlrFAHn6NXGJ2BiBE95czh03Cp2jiB3TLG5NI3J7L9OGjXr68944c+vc0kvuVZDIUaOX5PoqTTv6EphCvG+TolNULKKy3z8tKZbAP3Kr9S2IGP2Q5fJv9XNWmjLdX+ImNKV78+M/UnKTZ1kTWQ/xUD/shJOHcYF+khfJFM6wleepqKB7Y++1o/WxD31VBLhG+EavS9gEv4bSVvDxTCjl9wO8x5cLxzUDBiS0PUZ5ad32n9/aBnP7GzM+DbexLf40+G4Epa7sYe9JV97QVJy/w9lXTBri4V4RLN+5CEhGj0yOethq7mAh52kI8OEGW2M5lpb4lJwyTuHnlkKbSXxlqkovLofV0lZOv5IWOiwtsF+RDq9lsli98xBGzt7mjBhVBQHNdTxlYxUWeYUPbgKs4qfYbHMfgY9S0nQeI8bRKdlyM6wqpXLGyQxy5XVR64m7h1r+sVWcb9bDPprRhWS/1C7kQS+GsDdGiqXx35ea4xBz6SKZq+sbQLIg5bSH7fkCnvAxL8ykaHdxOOAk+pZDDY6mS/pxd3SfiXyNbP64V/SjKByIVc7Vm1GcD2XMhnxl58g6/6wqP39dLD+N3MAZfYTXA7q2bFyVJQzqzm44wHbysuyW7ZiGhAHNxErA4LKag
 OROwX7NF
 LAATvwOtbIvA0xH6iUFIoDxy+C9EWGfJvkPMrfcslefg7fF6A70M6k/vhR6rBV1n/ZQNWfjg4Uuk2DJPpxgsgG9utQl/KW+xS4xYpEgefi16RA4idH4mceYohzsSbH0wimtL1X9ZgXnDYVefhdleG/S7/1jJ2W3E5Gp1onhRAvuuf7ybFUe6C3Vz3G6lUubqQDpDcNd1hXXOU4r8AeBPy8Nvmbp4NN/pqecKjUmOqZTeQOuOs/cghVikYb1QY0naw7HK5Bor2JYrsxFG3tZjr61qQGBuHcx4t35wEIVytXrLUq7ku72viskgWmSSigS6p7CJvuK3Yg4IZC0YAbz+/f/FlyDrGyVrz+WD6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

An xswap device does not have to allocate cluster_info for its whole
address space at once. Back it with a VM_SPARSE area and map it in
chunks. At setup, map only the first chunk. The grow path maps more
chunks when they are needed.

Setup, free, and the two cluster_info scans must change together. If
only setup changes, free would free the wrong object, and the scans
would read cluster_info entries that are not mapped yet.

The map helper rejects a stale start_idx and cleans up a partial mapping
if it fails. The grow path added later depends on this check.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 152 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 141 insertions(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index afd0e8718544..00c7b398bafe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -50,6 +50,17 @@
 #include "swap.h"
 
 #ifdef CONFIG_XSWAP
+/*
+ * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
+ *
+ * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
+ * operation.  It is set to the number of cluster_info structs that
+ * fit in a single page (at least 16), so that the vmalloc page table
+ * overhead is proportional to the number of clusters mapped.
+ */
+#define XSWAP_GROW_CLUSTERS \
+	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
+
 /* Batch size for the fallback unmap; keeps the stack array small. */
 #define XSWAP_UNMAP_BATCH_PAGES		16
 #define XSWAP_UNMAP_BATCH_CLUSTERS					\
@@ -2825,10 +2836,27 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	struct swap_cluster_info *ci;
-	unsigned long i, end;
+	unsigned long i, cluster_end, end;
 	unsigned int ci_off;
 	unsigned long swp_tb;
 
+	end = si->max;
+#ifdef CONFIG_XSWAP
+	/*
+	 * An xswap device maps its cluster_info in chunks as it grows, so
+	 * the tail past nr_clusters_mapped has nothing behind it.
+	 */
+	if (si->flags & SWP_XSWAP) {
+		unsigned long mapped_end;
+
+		/* Pairs with the smp_store_release() in xswap_map_clusters(). */
+		mapped_end = smp_load_acquire(&si->nr_clusters_mapped) *
+			     SWAPFILE_CLUSTER;
+		if (mapped_end < end)
+			end = mapped_end;
+	}
+#endif
+
 	/*
 	 * No need for swap_lock here: we're just looking
 	 * for whether an entry is in use, not modifying it; false
@@ -2836,11 +2864,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * allocations from this area (while holding swap_lock).
 	 */
 	i = prev + 1;
-	while (i < si->max) {
+	while (i < end) {
 		ci = __swap_offset_to_cluster(si, i);
-		end = min_t(unsigned long,
-			    ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWAPFILE_CLUSTER,
-			    si->max);
+		cluster_end = min_t(unsigned long,
+				    ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWAPFILE_CLUSTER,
+				    end);
 
 		/*
 		 * An empty cluster has no slot in use, so skip it whole.
@@ -2850,13 +2878,13 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 		 * enough, unlike in every other cluster_is_empty() caller.
 		 */
 		if (!READ_ONCE(ci->count)) {
-			i = end;
+			i = cluster_end;
 			cond_resched();
 			continue;
 		}
 
 		ci_off = i % SWAPFILE_CLUSTER;
-		for (; i < end; ci_off++, i++) {
+		for (; i < cluster_end; ci_off++, i++) {
 			swp_tb = swap_table_get(ci, ci_off);
 			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
 				return i;
@@ -2866,7 +2894,6 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
 	return 0;
 }
-
 static int try_to_unuse(unsigned int type)
 {
 	struct mm_struct *prev_mm;
@@ -3164,6 +3191,14 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
 	BUG_ON(si->flags & SWP_WRITEOK);
 
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		/* Pairs with the smp_store_release() in xswap_map_clusters(). */
+		end = min(end, smp_load_acquire(&si->nr_clusters_mapped) *
+			  SWAPFILE_CLUSTER);
+	}
+#endif
+
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
@@ -3175,11 +3210,43 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 	struct swap_cluster_info *cluster_info = si->cluster_info;
 	unsigned long maxpages = si->max;
 	struct swap_cluster_info *ci;
-	int i, nr_clusters;
+	unsigned long i, nr_clusters;
 
 	if (!cluster_info)
 		return;
 
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		unsigned long nr_mapped;
+
+		/*
+		 * Cluster 0 keeps the bad header slot, so it never empties
+		 * and __free_cluster() never frees its table.
+		 */
+		/* Pairs with the smp_store_release() in xswap_map_clusters(). */
+		nr_mapped = smp_load_acquire(&si->nr_clusters_mapped);
+		for (i = 0; i < nr_mapped; i++) {
+			ci = &cluster_info[i];
+			spin_lock(&ci->lock);
+			if (cluster_table_is_alloced(ci)) {
+				swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
+				swap_cluster_free_table(ci);
+			}
+			spin_unlock(&ci->lock);
+		}
+		/*
+		 * free_vm_area() drops the mapping without freeing the
+		 * pages, and the unmap helper handles an empty range.
+		 */
+		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		free_vm_area(si->cluster_vm);
+		si->cluster_vm = NULL;
+		si->cluster_info = NULL;
+		si->nr_clusters_mapped = 0;
+		return;
+	}
+#endif
+
 	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	for (i = 0; i < nr_clusters; i++) {
 		ci = cluster_info + i;
@@ -3678,7 +3745,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 }
 
 #ifdef CONFIG_XSWAP
-static int __maybe_unused xswap_map_clusters(struct swap_info_struct *si,
+static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
@@ -3824,7 +3891,7 @@ static void xswap_unmap_range(struct swap_info_struct *si,
 }
 
 /* Caller must hold si->xswap_lock.  Cannot fail. */
-static void __maybe_unused xswap_unmap_clusters(struct swap_info_struct *si,
+static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
@@ -3902,6 +3969,69 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	int err = -ENOMEM;
 	unsigned long i;
 
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		unsigned long size = PAGE_ALIGN(nr_clusters * sizeof(*cluster_info));
+		struct vm_struct *vm;
+
+		vm = get_vm_area(size, VM_SPARSE);
+		if (!vm)
+			goto err;
+
+		cluster_info = vm->addr;
+		si->cluster_vm = vm;
+		si->nr_clusters_max = nr_clusters;
+		si->cluster_info = cluster_info;
+
+		/* Must be initialized before xswap_map_clusters() locks it. */
+		mutex_init(&si->xswap_lock);
+
+		if (xswap_map_clusters(si, 0, min_t(unsigned long,
+					XSWAP_GROW_CLUSTERS, nr_clusters)))
+			goto err_free_vm;
+
+		/* xswap: only cluster 0 slot 0 is bad */
+		err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
+		if (err)
+			goto err_unmap;
+
+		INIT_LIST_HEAD(&si->free_clusters);
+		INIT_LIST_HEAD(&si->full_clusters);
+		INIT_LIST_HEAD(&si->discard_clusters);
+		for (i = 0; i < SWAP_NR_ORDERS; i++) {
+			INIT_LIST_HEAD(&si->nonfull_clusters[i]);
+			INIT_LIST_HEAD(&si->frag_clusters[i]);
+		}
+
+		/*
+		 * Cluster 0 holds the header slot, which is marked bad, so it
+		 * is not entirely free.  si->max is cluster aligned, so no
+		 * cluster holds a slot past the end of the device.
+		 */
+		for (i = 0; i < si->nr_clusters_mapped; i++) {
+			struct swap_cluster_info *ci = &cluster_info[i];
+
+			if (ci->count) {
+				ci->flags = CLUSTER_FLAG_NONFULL;
+				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
+			} else {
+				ci->flags = CLUSTER_FLAG_FREE;
+				list_add_tail(&ci->list, &si->free_clusters);
+			}
+		}
+
+		return 0;
+
+err_unmap:
+		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+err_free_vm:
+		free_vm_area(si->cluster_vm);
+		si->cluster_vm = NULL;
+		si->cluster_info = NULL;
+		return err;
+	}
+#endif /* CONFIG_XSWAP */
+
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
 	if (!cluster_info)
 		goto err;
-- 
2.54.0


