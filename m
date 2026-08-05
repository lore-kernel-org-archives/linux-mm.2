Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A07C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DAA6B00A6; Wed,  5 Aug 2026 03:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8148A6B00A9; Wed,  5 Aug 2026 03:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72AE56B00AA; Wed,  5 Aug 2026 03:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D45A6B00A6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:54:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D36951A035A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:24 +0000 (UTC)
X-FDA: 85066453248.12.7F0AA6D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5AB4DC0009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AoC3OVWl;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Dy0TRGL3n4s1aM02P+TwJL4y7iAJ4YkyqwwdxQaTLI=;
	b=q8SQXV6p14tOhYKHIWgyz0KRuIdLA3gFI2s0tG47gT5zzuSytajPKagdj1aT4ZxV2jy7u6
	xdp24TrDdEW2BiX4ekihnEB4Liz5ek+ijsOH2aCLr+HZpwIzyDARSbpDjNgQwVF5aEfyty
	G0bysox2xq5M4YNbYY0k8JyUhN14r3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916463;
	b=7ZxE3vqjsbuHWbOO29C6QV7TF+q0AAkM/TowPFZ4izEZQjGDer0kZa8oYOgC+DRQIfqt+C
	dEGY47n9hqH+hMeG8AaJXlec2aGZtHuMKrJYXq1bV8HRSc8AQb2AYYqfzk0KCYsgue2dFP
	R6niImBSoNk68DsiGbomnWgZ7Nt1XwI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AoC3OVWl;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Dy0TRGL3n4s1aM02P+TwJL4y7iAJ4YkyqwwdxQaTLI=;
	b=AoC3OVWlDqOuR0z8wqrCJCfGHI4NpcOpWGnvGnMNmLw6tDLDqWM5X1qByg7ZBZDk7Eg7Nr
	sgbL9dsduN4zSGhnGnbysHLo0lCfSIyCuwW4hL5tjdf47c4oAoR6wOpeH5UR9sBiCgjXSI
	qPR8I3N5cWLQIDuWEKpTAMQYIY2biMM=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 03/10] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
Date: Wed,  5 Aug 2026 15:53:26 +0800
Message-ID: <20260805075336.3579395-4-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5AB4DC0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fu7aehp58gukhqwhiksn1mkxanzirq1u
X-HE-Tag: 1785916461-445359
X-HE-Meta: U2FsdGVkX1+Y8eIVrFBz/zwratNHyXWVq3XwnYGX/0DeVRZp/sV06tQ2624CH1OVr3Q/G5lh9B3hBc+nrHiTcWQhfGHI63SBcQBqO9UE1RwQlf/5dCmHPCG7ZneLxrlppOXUEGZJyzZD6/F6QYZ3kivl1/0LfeFDQLdibcXw4oiNgszNlVIIbDyJkAh7qNUMiUv7PLNSRXndhlkgwZJxpaakHhxZYl8mmaudiZhO3YmVE3OiDXW5x+0mnOBG1NbRrCGeLQbJJgB9wpQRm8obTEYfWzbDx9NCTrb38+i87iGI2tpklQztHdcabjasKxCk6JI0fCgRjJ6QzE6ovL96eRKqm6n0xrBFmjsGj4uVzSRiwr+IcGoZKlKYF5vXNGVy9aXfioK6Jn0gyUQusj3YnQN3JQoCPeYtY+huGRWW4Rg3Y257mnEyXR2N3LEoDHbeaTah3+ZIhsvyqDe49DdS1x8ltFEFfK7zfQdQrsEfg/wuiYAl2AK3TGrfEiT2Mk5Y4rr0FWDbFH0yS7xomYK6lf+/AEnl8naSePWlbVuFFRXtt6tltp3ySooksthcqezt+oHq3QOj14cp7SnUlqojviG90GS0X2k9l/zfq+pPPtA5NeFVlTqdq01odNtU49y1Kw3uuQ9w0EBgZPwtGUq2o5Ytd86KplhDSWDFGkB5I86HVrIJl8NyjTXVh1sdToIFyWlPiu6UkQ2ec53VQ/vB9J8y5x3W+Wy0hxG/C+vxNguQui0qHOpYZK1oy6iCAOlLUKW21ASONM9seIxNZie7qh/ZGoIIVtcdFBmZ4WJiEIZwBbboYN96j9Tek4wd3LeYvjUxe/7PnwUYrQ9sG6rcLQU3M5hYJH5OAvmXUl8F2PI7vZsRshlPstgjdcmzys0AUFe9jAzSTbbQjgQ9J2Lk6i0K4CRo7ck6H+1Q296XHbIt8I/0zfhGJBUXlByESrU/gRMlXK5Lgj5tTDlsI9b
 i3WUlAl/
 UX9u4c/l/OZQdx+QT8oJKYWZcEWWPGUFipP95iQHwZWUyizqP7D3OgIfLnMUixYgYDbhh/nKeD64SsxVJ1dSUjF3fswQmcXBv+XlI7RYwtEjEzVUlioaG++0vb0r581o75NYjG7XcbYUQCIpWtwmLVMLnv1z3re02kWP5O5fOUgfdfcfDslePOp+CG6GbEjaN1g7+9ieWMOFEfF8pKHFTZTTRluINKjKElZLXXH118Jcxn77/ke0xiqN7JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement dynamic cluster_info array growth for xswap devices using a
VM_SPARSE vmalloc area:

1. xswap_map_clusters(): Allocate physical pages and map them into
   the pre-reserved VM_SPARSE KVA region via vm_area_map_pages().

2. xswap_unmap_clusters(): Unmap pages from the VM_SPARSE area via
   vm_area_unmap_pages() (used by the error/teardown paths, shrink
   comes later).

3. setup_swap_clusters_info() xswap path: Use get_vm_area(VM_SPARSE)
   for the cluster_info array, lazily mapping only the initial chunk.

4. free_swap_cluster_info(): Refactor to take swap_info_struct*.
   For xswap, unmap all clusters and free_vm_area().

5. swapoff: Remove snapshot locals; move p->max/p->cluster_info
   clearing after free_swap_cluster_info().

The grow path runs in the swap allocation context which may have
PF_MEMALLOC set during reclaim, so avoid consuming emergency reserves
by using __GFP_HIGH | __GFP_NOMEMALLOC on alloc_page() and
kmalloc_array(), switching to vm_area_map_pages_gfp(), and wrapping
the entire allocation block with memalloc_noreclaim_save() to prevent
recursive reclaim from internal page table allocations.

Concurrent grow operations race on vm_area_map_pages(), triggering
WARN_ON(!pte_none) in the vmap page table walk.  Add a per-device
mutex (xswap_lock) held across xswap_map_clusters and
xswap_unmap_clusters to serialize page table modifications.  The
shrink path is already deferred to a workqueue so it does not contend
with itself.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 256 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 245 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 970232f6359d..536b0e989c48 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -252,6 +252,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
 	unsigned long		nr_clusters;	/* total cluster count for xswap */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 08c49d5bea84..37c5dca153bc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,6 +49,24 @@
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
+#endif
+
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
@@ -3041,20 +3059,47 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
 	BUG_ON(si->flags & SWP_WRITEOK);
 
+#ifdef CONFIG_XSWAP
+	/*
+	 * xswap clusters beyond nr_clusters_mapped have been unmapped
+	 * by the shrinker and their vmalloc pages are no longer
+	 * accessible.  Only iterate over currently mapped clusters.
+	 */
+	if (si->flags & SWP_XSWAP)
+		end = min(end, READ_ONCE(si->nr_clusters_mapped) *
+			  SWAPFILE_CLUSTER);
+#endif
+
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
 	}
 }
 
-static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
-				   unsigned long maxpages)
+static void free_swap_cluster_info(struct swap_info_struct *si)
 {
+	struct swap_cluster_info *cluster_info = si->cluster_info;
+	unsigned long maxpages = si->max;
 	struct swap_cluster_info *ci;
-	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
+	int i, nr_clusters;
 
 	if (!cluster_info)
 		return;
+
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		/* Unmap all mapped clusters and free the VM_SPARSE area */
+		if (si->nr_clusters_mapped > 0)
+			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		free_vm_area(si->cluster_vm);
+		si->cluster_vm = NULL;
+		si->nr_clusters = 0;
+		si->nr_clusters_mapped = 0;
+		return;
+	}
+#endif
+
+	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	for (i = 0; i < nr_clusters; i++) {
 		ci = cluster_info + i;
 		/* Cluster with bad marks count will have a remaining table */
@@ -3093,11 +3138,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3189,10 +3232,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3200,7 +3239,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3564,6 +3605,139 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	return maxpages;
 }
 
+#ifdef CONFIG_XSWAP
+static int xswap_map_clusters(struct swap_info_struct *si,
+			      unsigned long start_idx, unsigned long nr)
+{
+	unsigned long start_addr = (unsigned long)si->cluster_info +
+				   (size_t)start_idx * sizeof(struct swap_cluster_info);
+	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
+	/*
+	 * vm_area_map_pages() requires that start and end be page-aligned.
+	 * If start_addr falls within a page that was already mapped by a
+	 * previous batch (grow path), round it up to skip the already-mapped
+	 * partial page.  Always round end_addr up so the vmap page table walk
+	 * terminates correctly (the walk loop exits when addr == end, and addr
+	 * advances by PAGE_SIZE each iteration).
+	 */
+	unsigned long vm_start = PAGE_ALIGN(start_addr);
+	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	unsigned int noreclaim_flags;
+	unsigned long npages;
+	struct page **pages;
+	unsigned long i;
+
+	mutex_lock(&si->xswap_lock);
+
+	if (vm_start >= vm_end) {
+		/* All requested clusters fall within already-mapped pages. */
+		for (i = start_idx; i < start_idx + nr; i++)
+			spin_lock_init(&si->cluster_info[i].lock);
+		WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+		mutex_unlock(&si->xswap_lock);
+		return 0;
+	}
+
+	npages = (vm_end - vm_start) >> PAGE_SHIFT;
+
+	/*
+	 * Prevent recursive reclaim: vm_area_map_pages() internally
+	 * allocates page tables with GFP_PGTABLE_KERNEL, which lacks
+	 * __GFP_NOMEMALLOC.  memalloc_noreclaim_save() ensures those
+	 * allocations cannot recurse into swap by disabling __GFP_FS/IO.
+	 */
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
+		/*
+		 * __GFP_ZERO is critical: cluster_info structs contain pointer
+		 * fields (extend_table, zero_bitmap, memcg_table, table) that
+		 * must start as NULL.  Without zeroing, stale data from a
+		 * previous user of the page would look like valid pointers.
+		 */
+		pages[i] = alloc_page(__GFP_HIGH | __GFP_NOMEMALLOC |
+				      GFP_KERNEL | __GFP_ZERO);
+		if (!pages[i])
+			goto fail;
+	}
+
+	if (vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages)) {
+		i = npages; /* free all pages on failure */
+		goto fail;
+	}
+
+	kfree(pages);
+	memalloc_noreclaim_restore(noreclaim_flags);
+
+	/* Initialize spinlocks for newly mapped clusters */
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	/*
+	 * Pairs with READ_ONCE() in shrink/grow paths.
+	 */
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+
+fail:
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
+	/*
+	 * Round to page boundaries: start up (skip partial page that may
+	 * contain clusters still in use before start_idx), end up so the
+	 * entire range is covered.  vm_area_unmap_pages() operates on
+	 * whole pages.
+	 */
+	unsigned long vm_start = PAGE_ALIGN(start_addr);
+	unsigned long vm_end = PAGE_ALIGN(end_addr);
+
+	mutex_lock(&si->xswap_lock);
+
+	if (vm_start >= vm_end) {
+		mutex_unlock(&si->xswap_lock);
+		goto out;
+	}
+
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+	/*
+	 * vm_area_unmap_pages() only clears PTEs; it does not free the
+	 * physical pages.  Walk the page table to find and free them.
+	 */
+	/* TODO: free backing pages via page table walk or tracking bitmap */
+	mutex_unlock(&si->xswap_lock);
+
+out:
+	/*
+	 * Pairs with READ_ONCE() in shrink/grow paths.
+	 */
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
@@ -3573,6 +3747,64 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
+		si->nr_clusters = nr_clusters;
+		si->cluster_info = cluster_info;
+
+		/* Map the initial chunk (at least cluster 0) */
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
+		/* Mark mapped clusters: cluster 0 has 1 bad slot, rest free */
+		for (i = 0; i < si->nr_clusters_mapped; i++) {
+			struct swap_cluster_info *ci = &cluster_info[i];
+
+			if (i == 0) {
+				ci->flags = CLUSTER_FLAG_NONFULL;
+				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
+			} else {
+				ci->flags = CLUSTER_FLAG_FREE;
+				list_add_tail(&ci->list, &si->free_clusters);
+			}
+		}
+
+		mutex_init(&si->xswap_lock);
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
@@ -3640,7 +3872,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3859,7 +4091,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	free_swap_cluster_info(si->cluster_info, si->max);
+	free_swap_cluster_info(si);
 	si->cluster_info = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
-- 
2.54.0


