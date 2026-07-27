Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C7CC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569336B0093; Mon, 27 Jul 2026 10:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FCC6B0096; Mon, 27 Jul 2026 10:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456986B0098; Mon, 27 Jul 2026 10:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14F736B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:05:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E2941A0761
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:31 +0000 (UTC)
X-FDA: 85034729262.27.7110E60
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id C1DDD40005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wjtPSBIa;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uEo1e+vGx2zs8kPTNH+ramCCQasH1b8qI7oEtehR6E=;
	b=AQ+XNkBM5pU8tQ8/vXPwsumjmyC3ZKvyp/FkhrpqwCCH43/vpYPZMcA6eJicLdwHdEExol
	o08sl2YuXCj57+6cV1xL/Q8Y2dLveZaVqWyWNkiobC07zQczrgjw6YWhuPMsBJXuYaNOjm
	Vafqz0dkKbHq2Ducz2PDYYEHK7wKIr0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wjtPSBIa;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161130;
	b=AaJJgmucG/7hymp3bz14vS8cBFWzlYG98Firf9I4gyKNUZu+hMEHRNJdKIJ5JCmAor3rPN
	MzqiS4cWrccZ5SHGRRSmDHdH9jl0DrixyW3HbI/WRLSXgLHmAE2XuCiwe431HToyAq96IS
	hBmzpalP5DjYTVntcdEq86rB0VbV0sk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uEo1e+vGx2zs8kPTNH+ramCCQasH1b8qI7oEtehR6E=;
	b=wjtPSBIaddYoRxKSKM0THym/43wzoheX+gyQbND7I00rQ6g8bAahn+10w3XVvGLege34BJ
	cNNEPUXywRziW56TD/2COlpHFTXW/NqK8iu2aaDBdwthUC9D/mEMWFe80Z8CvGHvh3OKr4
	niVXrD86KrSF/zpHCyhYQwHkU/abEKk=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
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
Subject: [RFC PATCH 03/11] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
Date: Mon, 27 Jul 2026 22:04:54 +0800
Message-ID: <20260727140503.1060918-2-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C1DDD40005
X-Rspam-User: 
X-Stat-Signature: 4crpkic5t19im5diojdh9jwh378r7bhc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785161129-667888
X-HE-Meta: U2FsdGVkX183oxPKVCeSufGRkB2HE4d+YvsRZMhoEler9QD6GP4krTS7INCqAsMSw+k3nAYp69YC0rOLFD61NOI5bBYmx40f6ABC28KgYkKqKddEX4sC+SBAkEV+NATC7NPkOR1zwMf+Z0go9J8uYL9r3X/SNI+pqh+Et0xiPGb3MIk5aINrK9S+Y8URIEuwyV4AX0+0e0D+Vo8YuUI2L0Mc0nZIAtN+n17FVbHy6ZrT4IDzp4oWPkANdpGDFn6KdpMY0m8AZiY2K775f4K0fDSXgxQUPeX5nbMHeun+aVfjt7rT7HL4/KZlWzyBD/G70yfOzSrKHW2KSTSwxD1Meywv2U/6RcK6pWf/HT8yn1bT7PLXgP652XbORip70U0jCE64ZbCcycJ1ApXj1vmMGJK7KW5n1z/4ut+n7cEbayhGrxTL7bkj5fEV8QAvHOaXAEQcx1EV7oHAamJM66GgG6OcEbanh6rnhOOcGQMoeAxfzgziEvHK21OQNFoeqFJOoEQooht/hEAMmZPxDHp8EYpqQXtfkZNp8RPA0LdOMUdYEK7NfO6dhGNVY/jZlK9jtcDDqAPhrAK0z7aUpgHjv1Ne0ByqHYmBCzBbjb1JyPMzcec7vsrCpZxcCNUp00YyEoh+R1TDshMYToHxL29+kzfLwpeSm8VGdaXTyMoVRW9LV8wDDF//q8TYJJjdLXSf4Xnab3jNXD777ku0kWmoYh1fx0fShdSPz9TOyabAw4l440YNLAZ2+ELu6Vy4OqmIbWwZTebx1AiiGBVTBg/DBqK2kgHaLoiRxKrXg6W0JdrLnTcaDOp42KvPovesQPljCWv8dwmRpdf8brWkpPWSQopuQQnTAW8//lPB8w/1Z+UT/llOLJC7ZZR0hJP8diYv73dCkvmmAly9x8/6GF6dbyORuhr89hBTAdJtRsxZVtS4C1e3bC3dAYjHckCG+Xm4g4r8JTsqk3fxbnkDkmc
 yC9+OpO2
 iNKdOx4KlWjrlrfh68/d0n9ne+ew0X4RqyNF/DlAPkt5K9WFVTwERyYGcn1iTrHkLfOm2UZ47nEdtv0uVIBWeqx4hyhyOjh6WALvDR7r4ZrohfnfeJ/yPzYsmgwr3I7ihwFAzCZewFFLIYbw7PvDpl5FkQcpf1IEHV9UxkDS5X+9FzNALCq4nE2HfGbBDGgvHssz5SVoBBFNK8JvsRx8Vjcz2m+SL+1mBqK8BfBJvYXkbdVnOxx10mw3JDQ==
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

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 228 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 216 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 143088dae07d..6d9c95ed09bd 100644
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
 
@@ -3564,6 +3605,112 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
+	unsigned long npages;
+	struct page **pages;
+	unsigned long i;
+
+	if (vm_start >= vm_end) {
+		/* All requested clusters fall within already-mapped pages. */
+		for (i = start_idx; i < start_idx + nr; i++)
+			spin_lock_init(&si->cluster_info[i].lock);
+		WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+		return 0;
+	}
+
+	npages = (vm_end - vm_start) >> PAGE_SHIFT;
+
+	pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	for (i = 0; i < npages; i++) {
+		/*
+		 * __GFP_ZERO is critical: cluster_info structs contain pointer
+		 * fields (extend_table, zero_bitmap, memcg_table, table) that
+		 * must start as NULL.  Without zeroing, stale data from a
+		 * previous user of the page would look like valid pointers.
+		 */
+		pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
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
+
+	/* Initialize spinlocks for newly mapped clusters */
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	/*
+	 * Pairs with READ_ONCE() in shrink/grow paths.
+	 */
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+	return 0;
+
+fail:
+	while (i > 0) {
+		i--;
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+	kfree(pages);
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
+	if (vm_start >= vm_end)
+		goto out;
+
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+	/*
+	 * vm_area_unmap_pages() only clears PTEs; it does not free the
+	 * physical pages.  Walk the page table to find and free them.
+	 */
+	/* TODO: free backing pages via page table walk or tracking bitmap */
+	/*
+	 * Pairs with READ_ONCE() in shrink/grow paths.
+	 */
+	out:
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
@@ -3573,6 +3720,63 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
@@ -3640,7 +3844,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3852,7 +4056,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


