Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58B7C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E9B6B009B; Sun, 13 Sep 2026 03:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35AB6B009D; Sun, 13 Sep 2026 03:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C046B009E; Sun, 13 Sep 2026 03:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A73206B009B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:50:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2E25A5394
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:43 +0000 (UTC)
X-FDA: 85207967166.12.21CC58D
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0742340002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285842;
	b=aBYnPfmb3gzTv2yt5q4QfLD7+G7K5PRjlIcJ6NzSV6Dp8KL7KHlgywGdjZkgcgUiAzanCx
	Ht8RxOEeT7+7fukItmpSlAv/RDHKjANQ23tO0MWnQgrzazndjSa3eTH8RUh4lJfb1H7fOW
	peMen/bLDaRBehyksuiS2eonvaMj9o4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KR4CxppA5UP1GCT1kOmw4Rz89aPHLD7DAzQB9cvIirc=;
	b=PltLsw+nK+oqNFWGkEDyKo1CMkqEy0sdESaMk1QDzb68/QS5WMlwE0HSeTL4sHd1w2IXUJ
	zGJi79Tq5AMsvx5jKqCqOfOFDqPgm8i56e6rf9PZYzvipbbik0X+qYBbd9lhRlabu/mZB4
	/TxORDO1ZLdT80ziIRNK+HSzUU3QVEw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 27d66f78b1c12bbf;
	Sun, 13 Sep 2026 07:50:40 +0000
X-Mizu-Trace-ID: 27d66f78b1c12bbf
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
Subject: [PATCH v2 04/12] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
Date: Sun, 13 Sep 2026 15:50:06 +0800
Message-ID: <20260913075014.1732524-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0742340002
X-Stat-Signature: xp6r1hzjrigf45roy9p4sqc8s6mmcd41
X-Rspam-User: 
X-HE-Tag: 1789285841-235459
X-HE-Meta: U2FsdGVkX1+5KU82G4MLoV3T2jSQKEQAUf2wcfisniQFsDwPX2iEHGWBmF5E3dTIvpw8bKrOQIvLOfoP3Rn+eyxRLhv/IVBuM+WtguNQVRWtKmGMkPyW/8X8/tgWqdSuz2Bp6lgyB+/jViBc26HGxl25fkYPOXIiI3qLN7tciGfJNNhcPvemV8EFo3DlsDrru3fz/Dzq3RwIDOTXnM+Y1UZlRaQ91VSYT4FqCrEwJS3JTDGoA0SP3uDrxElD3q4TJD461Yd+UubEaxfbdB/jNSzxBq5njVGxPASx5FVF9XoWZjRWr5Fnu0/fdrnA/zWfKnQ+kjVKno+yiF8r0xITpQ9mrSMoAJWO3MU+THllEmLatu2xF41vMzM3wOFr1pE6FuJtvUOAEqt7qVal+nW4htlESA0E/EDfw7XcWM2cyx+mDvCi75Ay7xwz5M/Xx0XFAZGj4ZgVTXfwCTpb+aNuPfSTuJC/0Wkn4r/z0AZ/qlEnNAgUxTjJck+MLeSxCOxDf9+QnZmhBYaDB+5SmjpM7LN/pQtjBLwEAqnOjNV3aw2ob2t+UJAr18QtbhXTwkXUSDePPGiy0H6AMFdKLUVMiv8dDLc/biQrlga34PKXUo16Z2jtbDAMmrG7tXjoRLh0rCV0MZbsPhL5xK/3vL0Sj1cqEBIvgIAcDNKWS2RdWeuWOnJboVD9TuF2VBbacj3kak9S3X3v2X2WnlRDYq8dSx51enF0PKh8lt8kCsvHlSJBSFekbNj+doOLtmmGvNcpUe1JhR5jOE9hz8xARmW98JeJbtvA7+a1fBQfjOaywnVqnGsFduoCWTaDa/osw3PiiWtvskVKfPktrDoAAFtnyl2NFq42XiQ7UJIZgK5LZu1Tkh1ZuLfgb9PZjIHXQJc7vvH8QvyNZORrVrmuBZmPqzpjjKTBNJC+aqtVHVSAsr3pK0nVWZkNqLX78dkg7CzFN89YL43sKGuMabdg7s6
 u2fFA6EF
 6eniaWJUZRAQV0Cm+mYKgGuIddG6vgN1TnSfkek25KO6ZkoMmcm3ec+rHa4py4Y2ajqh2GlMxGT2Zsb8Cyt5+nHyJbVDNlBRA1iHO5TszjisoyiVdkD/DCnQZMH1T4gQPHjtzb1vXDrBmfZTTYICk837fn5uh038wKh/AXzW4PXHLR/gi5qgYhsAGXkKehSuYjWjNUAARlCuwOBjsgd0w5QCe8gFIAq6zDWsVeLzYf/iLuTy54w3YUYThcljWVTV8+g7H27fsvyNcp+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement dynamic cluster_info array growth for xswap devices using a
VM_SPARSE vmalloc area. The cluster_info array is backed by a sparse
vmalloc region that is populated lazily in chunks: physical pages are
allocated and mapped on demand as swap usage grows, and the mapped
tail is unmapped again on the error/teardown paths. Only an initial
chunk is mapped at device setup, and every access is bounded to the
currently mapped range.

The mapping is hardened against concurrency and failure: partial map
failures clear their PTEs before freeing, stale grow ranges are rejected.
The grow path avoids emergency reserves via __GFP_HIGH|__GFP_NOMEMALLOC
and wraps allocations with memalloc_noreclaim_save(). A per-device
mutex (xswap_lock) serializes concurrent map/unmap page table modifications.
find_next_to_unuse() bounds its scan by the mapped range and wraps with >=
so a shrunk bound cannot spin forever.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 286 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 285 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 09ecef1b5e90..ad2311310032 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -252,6 +252,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 25bdb2f2fe0a..5140b3f846b2 100644
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
@@ -2716,15 +2735,27 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
+	unsigned int end = si->max;
 	unsigned long swp_tb;
 
+#ifdef CONFIG_XSWAP
+	/* xswap may have shrunk and unmapped the cluster_info tail. */
+	if (si->flags & SWP_XSWAP) {
+		unsigned long mapped_end;
+
+		mapped_end = READ_ONCE(si->nr_clusters_mapped) * SWAPFILE_CLUSTER;
+		if (mapped_end < end)
+			end = mapped_end;
+	}
+#endif
+
 	/*
 	 * No need for swap_lock here: we're just looking
 	 * for whether an entry is in use, not modifying it; false
 	 * hits are okay, and sys_swapoff() has already prevented new
 	 * allocations from this area (while holding swap_lock).
 	 */
-	for (i = prev + 1; i < si->max; i++) {
+	for (i = prev + 1; i < end; i++) {
 		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
 					i % SWAPFILE_CLUSTER);
 		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
@@ -2733,7 +2764,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 			cond_resched();
 	}
 
-	if (i == si->max)
+	if (i >= end)
 		i = 0;
 
 	return i;
@@ -3049,6 +3080,13 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
 	BUG_ON(si->flags & SWP_WRITEOK);
 
+#ifdef CONFIG_XSWAP
+	/* Skip shrinker-unmapped cluster tail. */
+	if (si->flags & SWP_XSWAP)
+		end = min(end, READ_ONCE(si->nr_clusters_mapped) *
+			  SWAPFILE_CLUSTER);
+#endif
+
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
@@ -3065,6 +3103,18 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 	if (!cluster_info)
 		return;
 
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		/* Unmap all mapped clusters and free the VM_SPARSE area */
+		if (si->nr_clusters_mapped > 0)
+			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		free_vm_area(si->cluster_vm);
+		si->cluster_vm = NULL;
+		si->nr_clusters_mapped = 0;
+		return;
+	}
+#endif
+
 	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	for (i = 0; i < nr_clusters; i++) {
 		ci = cluster_info + i;
@@ -3562,6 +3612,174 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	return maxpages;
 }
 
+#ifdef CONFIG_XSWAP
+static int xswap_map_clusters(struct swap_info_struct *si,
+			      unsigned long start_idx, unsigned long nr)
+{
+	unsigned long start_addr = (unsigned long)si->cluster_info +
+				   (size_t)start_idx * sizeof(struct swap_cluster_info);
+	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
+	/* Round to page boundaries for vm_area_map_pages(). */
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
+	 * Mapping is page granular, so an earlier chunk can have mapped
+	 * past its own clusters up to the end of a page.  Find how much
+	 * of this range is already there and map only the rest; a range
+	 * that is covered entirely was mapped by a concurrent grower.
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
+		/* -EBUSY: defensive, a concurrent grower got there first. */
+		if (err == -EBUSY) {
+			i = npages;
+			goto fail_nounmap;
+		}
+		i = npages;
+		goto fail;
+	}
+
+	/* Initialize spinlocks for newly mapped clusters */
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	kfree(pages);
+	memalloc_noreclaim_restore(noreclaim_flags);
+
+	/*
+	 * Pairs with READ_ONCE() in shrink/grow paths.
+	 */
+	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+
+mapped:
+	/* Every page of the range is already mapped; account for it. */
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	/* Pairs with READ_ONCE() in shrink/grow paths. */
+	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+
+fail_nounmap:
+	/*
+	 * The concurrent grower already mapped the range, initialized the
+	 * cluster spinlocks and advanced nr_clusters_mapped.  It may still
+	 * be holding those locks while adding clusters to the free list, so
+	 * do not touch them here; just free our unused pages.
+	 */
+	while (i > 0) {
+		i--;
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+	kfree(pages);
+	memalloc_noreclaim_restore(noreclaim_flags);
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
+	/* Round to page boundaries for vm_area_unmap_pages(). */
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
+	/* Pairs with READ_ONCE() in shrink/grow paths. */
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+	mutex_unlock(&si->xswap_lock);
+}
+
+/* Track the end of the run of pages that is already mapped. */
+static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
+{
+	unsigned long *mapped_end = data;
+
+	*mapped_end = addr + PAGE_SIZE;
+	return 0;
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
@@ -3571,6 +3789,70 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
+		/*
+		 * Cluster 0 holds the header slot and the last one holds the
+		 * holes past si->max; both have slots marked bad, so they are
+		 * not entirely free.  The clusters in between are.
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


