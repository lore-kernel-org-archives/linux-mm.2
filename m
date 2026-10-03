Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E465CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504B76B009E; Fri,  2 Oct 2026 20:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5616B009F; Fri,  2 Oct 2026 20:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A48E6B00A1; Fri,  2 Oct 2026 20:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 079C96B009E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92E03A78E2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:05 +0000 (UTC)
X-FDA: 85279437810.27.1CB110A
Received: from mta0.migadu.com (out-93.mta0.migadu.com [91.218.175.93])
	by imf21.hostedemail.com (Postfix) with ESMTP id 647011C0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.93 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0DzgDYeMZb74EVVZ08wSQGhRH5NoIX9IGkZghhfphfk=;
	b=NikwHbn7zeHvOJHuMlcucEGi7wW1aZPclGl5ClqLvGQSXA13lFDhtj+lhEghXvrxqOgFf3
	O3aiF/TijnOJC7C6ZLH00N6oL2+R5Ep3wNsNb6sKtajv2b9tx3ToSZl0e6FfLcaQ+t03IN
	G/qn+Uour1E+JJZWQ2lcbk/STcCFkbQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.93 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987523;
	b=Fb6YS0593knrY+yADLP3lwR5QBoU143PArjiA0UZD4oEchrb/ztuGNt+iOav1Suf1+g44T
	bPfqAzTtlPVWJ0aFZ+ZqliAfWXAE9dygvJYxMphxBPKOSoLCguN96+IM/bOUWqJFvIUIVV
	f/VdKyzFR4PcQ0zMeVBpfIwJv4jjlrQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 2fb0e5f78057f12f;
	Sat, 03 Oct 2026 00:32:02 +0000
X-Mizu-Trace-ID: 2fb0e5f78057f12f
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
Subject: [PATCH v4 03/14] mm, swap: back the cluster_info array with a sparse VM_SPARSE area
Date: Sat,  3 Oct 2026 08:31:25 +0800
Message-ID: <20261003003136.750633-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ww1a8fr91xrqbwusktejd5y6a5etiujb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 647011C0002
X-HE-Tag: 1790987523-479803
X-HE-Meta: U2FsdGVkX1+0awcJpgVAZh1+WSJl4dQXmve2Dj9BEq4iAZTkYVjJdeUzNh0Z1HOJJrVnjmyz8rBuztCtGHdwGEu4k0ASUyP90P3TzKEWYUN6AZPP8+JrAcCZgSGWMtKvoByDK/+MNHp/wjLujRfPtCVoK3fqwEi5VYnsxdbKkIJSh2u4KGwqDW+TW3bhsyFl0B60RVkUhqAQmmqUj39rkYuHArh5fjrJeKaYUEjeQQCE9MZp+a0LAf/N+ZJ7TMfwjHIgopA2uKMxJXPswCAMJFdRsHURXvWAaX3InP6VLrR0jE+DLFqdAg6lKokXMUK36QVR+j31JgYRpHnXxoJLGWAJmBLLvGDF26x58FFsMWCzQ0ztj0XfRWJxyrjhbnG+E8jhFyUqjLMYuZGMzbjMziu4JMXZlRyRigsTICvVLfo0pGtvjDuait65rPB68+IBIpj4x1QNQtjr7nWJzdvhudm3rWqadt544o36M2/R82JaBtuQVA30v5xIK15uIVnhk2tkEdJcpfxLMvjBZwnG2vGjjbrF7Vsr5JSPl1eMaMYsA4Y8o62pfeQcQ9LLciIXM/ysL9oJ2ucApSgvVv61k2PKrLy8HSrwaFaVvzOsnqtlN4k4uawADv1+D8KDFA5FUaKaQTzeirGSNvpsIFGABGW03okdmxkhFT8+ORm+EXN2uh9TSXeKmueDGsRnxTkodKHBBjFS8TBGXz6UN+SW4iFb7KfblD18gDorL1F2vNJyH/8ocB3dgENjK8vcH0wrgIR9wyEn/hQS6Q2zZrqtbm3vSEqDDLYiXS2r84QwOLrRiJOOoESyTSFYhBju37McejWG7P5rdvOKLuoqr7mtVxOINxqz+ABNXj5nD2UyIwJtmaIyyIUJm4L+wf4rKvHZFJtucPUAoE5/k9UdnBP4+48EP8jQjKv2cdgBkDwkCojweRs5Pw3VMtc7iXQEUWB2WEIh7N0TiY/Jz3hJf4f
 knQawNlo
 hkIWdEsI+mbVTUC4Oz5iz6r0jDRuYnMKB8AH94CVF0edOfgBm9rM/54sT7DM4zXlYdiiXzLxt7JjRjkw0z8M4iE+FQcRxN/2Ppd8moqg4Wji48phNKj4btuCF9PmOSYqDbAKNtVfCLAPSGRIuZ+QdA4IG9VYExm8VEovMcidukx0KoSj5O5f/j7zU1IcAAyoEV8Eo4VS3BeXg3kI/d2lyGGnwZtFXcoZU4zuG0bsGDhIFfLZg/HLu0DGedRjAonw8QeeXDatN6859JU8OhSFD/3TbbyoSpZdaLpEs99VCv+NRFRXW6NlBkecZvCv9z+4o8yEN/2OowSlEWBHJo+9Wji8uPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap device has no backing storage, so its size is not fixed up
front: the cluster_info array does not have to cover the whole address
space at once. Back it with a VM_SPARSE area that is populated lazily in
chunks, so only an initial chunk is mapped at device setup and the rest
is mapped on demand.

Add CONFIG_XSWAP, which depends on SWAP && 64BIT && ZSWAP (xswap devices
are backed by zswap) and on SYSFS (currently the only way to create one),
and the fields this needs:
- cluster_vm: the VM_SPARSE vm_struct backing the array
- nr_clusters_max: total number of clusters in the address space
- nr_clusters_mapped: number of clusters currently mapped
- xswap_lock: serializes map/unmap

The two cluster_info walkers, find_next_to_unuse() and
wait_for_allocation(), both walk up to si->max today. Bound them to
nr_clusters_mapped instead, so they stay inside the mapped range.

The grow path rejects stale ranges and cleans up a partial mapping on
failure.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   6 +
 mm/Kconfig           |   9 ++
 mm/swapfile.c        | 296 +++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 302 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9073d29377d8..382a578140b5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -242,6 +242,12 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
+#ifdef CONFIG_XSWAP
+	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
+	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
+	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct mutex		xswap_lock;	/* serialize map/unmap operations */
+#endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
diff --git a/mm/Kconfig b/mm/Kconfig
index acefc994d9a8..39927b5c75ac 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -122,6 +122,15 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
        default ""
 
+config XSWAP
+	bool "Extendable (virtual) swap device"
+	depends on SWAP && 64BIT && ZSWAP && SYSFS
+	help
+	  Adds support for extendable swap devices (xswap) that decouple
+	  PTE swap entries from physical backing storage. The cluster_info
+	  array is backed by a sparse vmalloc area that grows and shrinks
+	  on demand, avoiding static pre-allocation overhead.
+
 config ZSMALLOC
 	tristate
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 13ec5c0f3c2f..767d3f46877f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,6 +49,25 @@
 #include "internal.h"
 #include "swap.h"
 
+#ifdef CONFIG_XSWAP
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
+static int xswap_map_clusters(struct swap_info_struct *si,
+			      unsigned long start_idx, unsigned long nr);
+static void xswap_unmap_clusters(struct swap_info_struct *si,
+				 unsigned long start_idx, unsigned long nr);
+static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
+#endif
+
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
@@ -2799,10 +2818,27 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2810,11 +2846,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2824,13 +2860,13 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2840,7 +2876,6 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
 	return 0;
 }
-
 static int try_to_unuse(unsigned int type)
 {
 	struct mm_struct *prev_mm;
@@ -3138,6 +3173,14 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
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
@@ -3149,11 +3192,41 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
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
+		/* Unmap all mapped clusters and free the VM_SPARSE area */
+		if (si->nr_clusters_mapped > 0)
+			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
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
@@ -3651,6 +3724,148 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	return maxpages;
 }
 
+#ifdef CONFIG_XSWAP
+static int xswap_map_clusters(struct swap_info_struct *si,
+			      unsigned long start_idx, unsigned long nr)
+{
+	unsigned long start_addr = (unsigned long)si->cluster_info +
+				   (size_t)start_idx * sizeof(struct swap_cluster_info);
+	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
+	unsigned long vm_start = PAGE_ALIGN(start_addr);
+	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	unsigned int noreclaim_flags;
+	unsigned long mapped_end;
+	unsigned long npages;
+	struct page **pages;
+	unsigned long i;
+	int err;
+
+	mutex_lock(&si->xswap_lock);
+
+	/* Refuse a stale range: the boundary moved since the caller read it. */
+	if (start_idx != READ_ONCE(si->nr_clusters_mapped)) {
+		mutex_unlock(&si->xswap_lock);
+		return -EAGAIN;
+	}
+	if (start_idx + nr > si->nr_clusters_max) {
+		mutex_unlock(&si->xswap_lock);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Page-granular mapping can cover clusters past the previous chunk.
+	 * Find the already-mapped prefix and map only the rest.
+	 */
+	mapped_end = vm_start;
+	if (vm_start < vm_end)
+		apply_to_existing_page_range(&init_mm, vm_start,
+					     vm_end - vm_start,
+					     xswap_mapped_end, &mapped_end);
+	if (vm_start >= vm_end || mapped_end == vm_end)
+		goto mapped;
+	vm_start = mapped_end;
+
+	npages = (vm_end - vm_start) >> PAGE_SHIFT;
+
+	/* Prevent recursive reclaim during vmap page table allocation. */
+	noreclaim_flags = memalloc_noreclaim_save();
+
+	pages = kmalloc_array(npages, sizeof(*pages),
+			      __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+	if (!pages) {
+		memalloc_noreclaim_restore(noreclaim_flags);
+		mutex_unlock(&si->xswap_lock);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < npages; i++) {
+		/* __GFP_ZERO: cluster_info pointer fields must start NULL. */
+		pages[i] = alloc_page(__GFP_HIGH | __GFP_NOMEMALLOC |
+				      GFP_KERNEL | __GFP_ZERO);
+		if (!pages[i])
+			goto fail;
+	}
+
+	err = vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages);
+	if (err) {
+		i = npages;
+		goto fail;
+	}
+
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	kfree(pages);
+	memalloc_noreclaim_restore(noreclaim_flags);
+
+	/*
+	 * Publish the new mappings and cluster lock initialization before
+	 * the count; walkers without xswap_lock use smp_load_acquire().
+	 */
+	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+
+mapped:
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	/* Publish the advanced count. */
+	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+
+fail:
+	/* Clear PTEs vm_area_map_pages() may have left before freeing pages. */
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+	while (i > 0) {
+		i--;
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+	memalloc_noreclaim_restore(noreclaim_flags);
+	kfree(pages);
+	mutex_unlock(&si->xswap_lock);
+	return -ENOMEM;
+}
+
+static void xswap_unmap_clusters(struct swap_info_struct *si,
+				 unsigned long start_idx, unsigned long nr)
+{
+	unsigned long start_addr = (unsigned long)si->cluster_info +
+				   (size_t)start_idx * sizeof(struct swap_cluster_info);
+	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
+	unsigned long vm_start = PAGE_ALIGN(start_addr);
+	unsigned long vm_end = PAGE_ALIGN(end_addr);
+
+	mutex_lock(&si->xswap_lock);
+
+	if (vm_start >= vm_end) {
+		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+		mutex_unlock(&si->xswap_lock);
+		return;
+	}
+
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
+	/* TODO: free backing pages via page table walk or tracking bitmap */
+
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+	mutex_unlock(&si->xswap_lock);
+}
+
+/* Track the end of the run of pages that is already mapped. */
+static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
+{
+	unsigned long *mapped_end = data;
+
+	if (!pte_present(ptep_get(pte)))
+		return 0;
+	*mapped_end = addr + PAGE_SIZE;
+	return 0;
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
@@ -3660,6 +3875,69 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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


