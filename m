Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDE6C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85446B0099; Wed, 16 Sep 2026 06:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C516B009B; Wed, 16 Sep 2026 06:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23CF6B009D; Wed, 16 Sep 2026 06:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A58766B0099
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:20:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A78FE120685
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:05 +0000 (UTC)
X-FDA: 85219229970.05.37B7732
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf30.hostedemail.com (Postfix) with ESMTP id 709A280006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554004;
	b=23F0y9PJssJUqVQvqEsAaELW+7UmRYAAVg8MKUc25Aq4F+mGF3ZKfxTaXMR0CmhUnwHdgU
	xIG2McX1LFjn9vH9bcx9aQgNLzBIhT3/TH+LBxiT26LT3nwMAhb5fp8gz9lgRF5hvhz4KN
	urN59cz6TPKLeFQMRpNxdnL9AJv4eQ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=inY74cwcYVx4uXYBKQWXZ3KJm6fVfgNJWAvYHvpL2cc=;
	b=Y5QN6Q67bOczE35iG+JWy5wqukaUonXvhnn7a9fdtlCP5nVVWBDeG7J28Fy+EJDNnEBFm+
	UZk40kh2cE6wBItYxazmmH7U69vmLpwiDrL1ECQOnVyE0h+6iZUVeKCCSKKrOZopGTMKkX
	3m04KWBDuKLO8q+rIHTlKOaqTzjF6g4=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 50ed61c3cd174dab;
	Wed, 16 Sep 2026 10:20:02 +0000
X-Mizu-Trace-ID: 50ed61c3cd174dab
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
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 04/14] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
Date: Wed, 16 Sep 2026 18:19:11 +0800
Message-ID: <20260916101929.149106-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 709A280006
X-Rspam-User: 
X-Stat-Signature: 6cpsrn17pnndwduqoi3ebpgjbtawhr9m
X-HE-Tag: 1789554003-967054
X-HE-Meta: U2FsdGVkX1/6Ax0x+HLdxAyvGGjKxA6WWF9dnrzpsYrAxcxXJiQp3DiWsJCgtt0vFvZk6JdwV0BHluwEa4qIy+C61+iyWk5lKx7AIGgKHk0GJ3NVDIrmW+UH4buRJcrg9PX8PA32QFrXRGgXYogTJnxlzNxcFGa0/kehI7/mQ+chzSTIy1uceuXPgYxXwi/BMS3X43L70vNk/2m0jCdZLHZQd2hROoyGDjA1SPHvkMwL8ZTCT5RLwJliQRm6c341OtZei19+AuCPWk5HLF+Wl1abPhICLq3gEyt2vmSMvnEt6C9nL9QIX0kbrbBzyASF9gs6PMPmvxXtG11ctbTBYFY7D3piWw9L/b+mP3nXlueEsnviUjI8q3YQnW8yCLSB3YqYSySlrXLJbo3IBQFiCIF1d88ItXUAC6nKqAWQJneIzftgZ6uf2Lv3fpe4p8qWJJ4zn8bJ6qFT9uIO3ls7KPskOP0bILKd4N0I3eF1Abgs4BXe0T5VN+PRwaVCwBKdMj7Wizq4tuMKEvYUbNVlJp05hQrQHHNue8kYg1jL62wycQipyLGIApIGQPbth1CHJNyUDP+K7kr7jTEChYV4i7ARFyHAUJtcuciHLOnikmtmYwTg9KB65UXtiq2CAZ2bicvsPs9PRi8I8lCvco8CSC+U7MurVaCZ0VKXGb6XYo8fzJwSbG2+amdj2FDKs8iMAmwDu5Z/NWennYRSxZ+WNzR9XrtVgVM1YJALf0BaASz0EnBT/wsI+g1og3XzlRViHZcYMD59WM/iTPdjuYw7M3UPtM9UBuKlpiiH6AlGwTt+9XfkeLLnmQseqqc3fHVstYL40fuhantl9gZF0REWIbInZ/3hoB/8/LCVTMLtnZtbbwund/r2nFnTCn1BLYLJNWR5ePomIM0fqOvkz90z+vVM/ZE8ja6fpjSqTLx6+vfPyJgP2g1LsKw70YGjpfv7JH2TuEE+zgEb70MtSjw
 v0FRWh9B
 WoU8c9Q5WZ7Dw9H3O//Cs+9/ODpU3h343A7WR5jjLZ3lvbvI9euBvJJvBXLowAC2BKzICEDm2gI25OS/qx2fhTWnwqvNah7oY636QPYWBWrEK9va9snMhsE8AqII2FQr5ICx1VItx6g98ZKlWq8uTqMI1/LMkozD3MCfKo/JvsRSU25KAxkYCF8fcmnxkvMgMj0OCk6UyZcdYnc/J80nfixdl/jnM5bTmQRBQ6qkzLDTMwEHAup9zp3OVtltZYavtLzgevcLnD/eguYEGKkhvQI8zcds1bt5YCvssM1WLHIL4wH1STyrFx+jFJ7SouxNHB93fVwDkrhtDoEOyKUovlNFJoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Back the cluster_info array with a sparse vmalloc area that is populated
lazily in chunks: pages are allocated and mapped as swap usage grows, and
unmapped again on error/teardown. Only an initial chunk is mapped at
device setup, and all accesses are bounded to the mapped range.

A per-device mutex serializes the map/unmap operations, and the grow path
rejects stale ranges and cleans up partial mappings on failure.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 321 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 313 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index b7882aac1eab..8c62a53667bb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,6 +246,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4b260f9760ac..dac5e0db0e94 100644
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
@@ -2797,10 +2816,24 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	struct swap_cluster_info *ci;
-	unsigned long i, end;
+	unsigned long i, cluster_end, end;
 	unsigned int ci_off;
 	unsigned long swp_tb;
 
+	end = si->max;
+#ifdef CONFIG_XSWAP
+	/* xswap may have shrunk and unmapped the cluster_info tail. */
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
@@ -2808,11 +2841,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2822,13 +2855,13 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2838,7 +2871,6 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
 	return 0;
 }
-
 static int try_to_unuse(unsigned int type)
 {
 	struct mm_struct *prev_mm;
@@ -3136,6 +3168,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
 	BUG_ON(si->flags & SWP_WRITEOK);
 
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		/*
+		 * Skip the shrinker-unmapped tail; pairs with the
+		 * smp_store_release() in xswap_map_clusters().
+		 */
+		end = min(end, smp_load_acquire(&si->nr_clusters_mapped) *
+			  SWAPFILE_CLUSTER);
+	}
+#endif
+
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
@@ -3147,11 +3190,41 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
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
@@ -3649,6 +3722,173 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
+		/*
+		 * -EBUSY means the range is already mapped; xswap_lock should
+		 * prevent it.  Fail instead of recording a mapping whose
+		 * cluster locks were not initialized.
+		 */
+		if (err == -EBUSY) {
+			WARN_ON_ONCE(1);
+			i = npages;
+			goto fail_nounmap;
+		}
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
+fail_nounmap:
+	/*
+	 * The mapping was not recorded: free our pages and fail so the
+	 * caller does not touch cluster_info for the range.
+	 */
+	while (i > 0) {
+		i--;
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+	kfree(pages);
+	memalloc_noreclaim_restore(noreclaim_flags);
+	mutex_unlock(&si->xswap_lock);
+	return -EBUSY;
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
@@ -3658,6 +3898,69 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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


