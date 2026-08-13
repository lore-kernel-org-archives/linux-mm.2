Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E1BC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C86D6B0274; Thu, 13 Aug 2026 06:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879486B0490; Thu, 13 Aug 2026 06:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6066B0491; Thu, 13 Aug 2026 06:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5178A6B0274
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA8D81205C9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:43 +0000 (UTC)
X-FDA: 85095925446.15.A95447C
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	by imf21.hostedemail.com (Postfix) with ESMTP id E0CA41C0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618182;
	b=7gVnTr9evqyPURYvjuYGmbPxHOt2iOfIDTVHHIWY93B4V6TC9tSEI1nF08wqmGURv8ZxYS
	S2E6iLLMfxSxaj4rjhFJLxH2j/+HJuhbavb+LPDoY6hPh5XU+cWE6MAjzSyK354qEcnKJK
	7VZlG02fveoyu3hVZUhx2hthGnQQ1qA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVwIxTDdgaRXW9dGjlEE+9pL35K8f64kRXrTsRFs3Bs=;
	b=I0kU/d1x+MRJ0XeE5z8DixNfm+JWykVEhhsR+aBjYoC3L0F0ylap8cyHdktkN63FmOOKPy
	AW7nbmBIDRx0+BesTIu+xfqAkTiWi1pCb++h2O+26UEsilTZy7cqSeAQQR2b2atcNM/zzZ
	u5VudT3JHDtDVSVZTm0/t5rzjsqz38c=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 129c9ad13bee1b4c;
	Thu, 13 Aug 2026 10:49:40 +0000
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
Subject: [RFC v3 05/15] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
Date: Thu, 13 Aug 2026 18:48:44 +0800
Message-ID: <20260813104857.3450386-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0CA41C0009
X-Stat-Signature: jdh5tn3yhninkjfck48hoxdokfwcwrg5
X-HE-Tag: 1786618181-799804
X-HE-Meta: U2FsdGVkX191TVmCGvyZFtlIWRvkgzTmIhY0d2PT9pk2wIO1Gbf3bGCZzq1UVWeIu2jhz65WwPbgrZrqF/9hlxW8ODDGi+CVrQKbGhZP6tPkc8wOxxG4AegR9GeLRmxqp8tNmgjEzyV1A9dE7570ovFiorjWpRiBca2FnGFzup2z73qVEa7e2rRZqC+DkFWw/MlRN4qAZ81/RNrP86t0zHNUKN6iLNNfpFIm2fJwldxpf0AkaF+F2El2YYO7owkRb0K8EAddRbh1rEyx/n+4LhEKB8gcKaE5s/C0U8In+/Z4FN3GyPV8xcaFlgCDAfpDA2RIuzu0RN/CsrxQjal3TTQTyQnjC+Nz9oC2BIZFMC2nwq/qertlLm4hjVrXo5ZUIckY7HOtu41T/CVw6FkeWANzRH4sfg4o2q+A29mMQvHkQ/dFJ3IjlH/mr1rUU6/RuT0p7ADEshlDS2e+Rm7ApIqFFHkNosjJ61/l7TAQj8E8q6+wzTgk6qaIZ7cv20f+bhMtYyVcPo56VqwZPoenPk3Q3V2Rk9BMQblEaYbbWqtEY1GSmflKZTMlqoYcJt9m9JsZSnZhJJD+vWHEtgb6kjpt7XNeRxiqnV0dcw4sLzGFlctvow5wLmVj0eiN+iIzm5kZEbcTohB0nZlUpTvSw4I9IS8/NOjBr+k+KLmYE3qZmYSMjHlgvCZ+epzxqINhTffHYyv0gNygeFWVEDZpq5xy+eQBPFCpZjZDLGiwcivBxrmg7JYPbM4XRP6f/J7M+dTTr2LE+QlFQV16P9IETLG3ynqa6ypXIPUELKLg2dPnYYKkV7taaQthwIDKvMpE8kTVF+IBhDbZ2MtrKfXioG9KdCWGAwvsfcT9kE9UzGkMX+zB/o3ufiYxevGjKIMDV6kozNhK+PbP+qr3JY9zUDUt9+3SD1aTgBub+U1L6Frwd4cXFZBFq5cCIpcMvp9bjD45Tuv6617KSvFX/as
 41Qb18A8
 1e1WE1rq8sDNf+OQaE6vzg6jhUmgj++lz4Pc/HzUe3shsKwq/h71fwERXFgFqU/ICgUW/QlM+lcm8eA/20KiFwJiZigt2zi2QGq2foW8L57f1hohzzC8IkbncvPEWSrEK1kWLJRv9uaOqVQzpWzy+s12eTRwPEp+EaPHtivcWb+Ftyuvm39C/L2Vb6eu567Rlo5HcaNr3CoMRvBLPIIjWD5eu4By//huLF+w13GS5lEgQHLPoo/a0+ve748YQoN03Q9OxFTCxkuwR4m2LZuqrTpAVYqWB35olUGjP1aI7GsdGBauRhEl0zW7JY53ltziZ9ow96Dkq2fKZrAmzNkd2xjukr17Tp/0QM7qKMW5kdaj0c0gfPsl2r6fGZ9Y8yq1zvjlgTF+aHbH0o8vvn4wHiwH3BXN8aKk8V2Uw
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

4. free_swap_cluster_info() xswap path: Unmap all clusters and
   free_vm_area().  Built on the refactoring in the previous patch.

5. wait_for_allocation() xswap guard: Skip shrinker-unmapped clusters
   beyond nr_clusters_mapped.

The grow path avoids emergency reserves via __GFP_HIGH|__GFP_NOMEMALLOC
and wraps allocations with memalloc_noreclaim_save().  A per-device
mutex (xswap_lock) serializes concurrent map/unmap page table
modifications.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 257 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 256 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7ffc62a3b2d7..c824848c6cfc 100644
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
index 4ce30e9ecdf6..178c3b798f8e 100644
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
+static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
+#endif
+
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
@@ -2708,15 +2727,27 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2725,7 +2756,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 			cond_resched();
 	}
 
-	if (i == si->max)
+	if (i == end)
 		i = 0;
 
 	return i;
@@ -3041,6 +3072,13 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
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
@@ -3057,6 +3095,19 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 	if (!cluster_info)
 		return;
 
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
 	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	for (i = 0; i < nr_clusters; i++) {
 		ci = cluster_info + i;
@@ -3553,6 +3604,150 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
+	unsigned long npages;
+	struct page **pages;
+	unsigned long i;
+	int err;
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
+	/* Detect racing grower that already mapped these pages. */
+	if (apply_to_existing_page_range(&init_mm, vm_start,
+					 vm_end - vm_start,
+					 xswap_check_mapped, NULL)) {
+		i = npages;
+		goto fail_nounmap;
+	}
+
+	err = vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages);
+	if (err) {
+		/* -EBUSY: defensive, the page was already mapped. */
+		if (err == -EBUSY) {
+			i = npages;
+			goto fail_nounmap;
+		}
+		i = npages;
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
+/* Return 1 at first present PTE to signal range is already mapped. */
+static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
+{
+	return 1;
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
@@ -3562,6 +3757,64 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
-- 
2.54.0


