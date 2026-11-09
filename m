Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC17606D801
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K54eP75t
Received: by kanga.kvack.org (Postfix)
	id 8999D6B05BE; Mon,  9 Nov 2026 00:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872716B05BF; Mon,  9 Nov 2026 00:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7875F6B05C0; Mon,  9 Nov 2026 00:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2226B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA9201C3EB4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:02 +0000 (UTC)
X-FDA: 85414519764.26.5C51CBC
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF87A80004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K54eP75t;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203761;
	b=D9h4058yBh6I32gVwYw8x9St1Gn0cQQWNAJG8GVrfvAvcuPEZ2MlXCvtH21LPVeLKsGoHY
	a0G3wUe1tq26qV1SQLUUMwyKKtjo74IvVd8SlPMhbiPaLoowAIPzr0JfjjB/9PmdPiM0ke
	lMuJ7jCe+SdeWcZfPXB8psvcMBRkkaI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K54eP75t;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYujfJJva9ewvxkSIVF90LpYUHC0ArQaaSuEcl9iuM0=;
	b=ZIxmmtA58k3LcNLeIOSNz7mRBJcedwTgDzVmqzRF1y/CwBvQ0vqdhk5NJ5z1Tre5ByfDYw
	22RvbkQNpIYphTsh9+o/O6houLC0UxpmD55Ea9Mo1/OCg6EdRVLBfuhdlYyaFQjxIxBhSL
	kym/V0NccRhXCO1F9LCBmRksvhcsfvA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1z4tONTNZj3MF0cFOK8R4Ji3R8IflIG6FbjM8iv86DA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203759; v=1; x=1794808559;
 b=K54eP75tk94wTNdiOjYtBwfluwnIdzyF2QfVPprFb+RJk07c5kk6CiEEawxkdyMoXepWkS7K
 EuP8zloRCLgc673CCfPyuIJyUAQtZ8m2g7tm13DgbEJsH9llVTadm+o7Ddv1LEfKA+dUs3ftrWn
 jTYG/2gXiZrkNLumrFDsM5KM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0caf9f1543e5b09e;
	Mon, 09 Nov 2026 05:55:59 +0000
X-Mizu-Trace-ID: 0caf9f1543e5b09e
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
Subject: [PATCH v5 03/19] mm, swap: add VM_SPARSE cluster-array helpers for xswap
Date: Mon,  9 Nov 2026 13:54:39 +0800
Message-ID: <20261109055455.536925-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF87A80004
X-Stat-Signature: ugm5myxt3a5ahczc9o1h81mwztk8t9pe
X-Rspam-User: 
X-HE-Tag: 1794203760-467148
X-HE-Meta: U2FsdGVkX1/LYjs4duANUOtHCDCpA6o+H/DYzU41fT0jm5klcmsmwfABYEG/erbNRB1HpndFXZpfvM8xrltW3bkR19HNeBzyQE0sDO1aW/7TKbLEzZP0A6qxk+57jqRPVZS4dBOmb1+wYdKIJDiGc3hQ+4P1F9A0UjyVMExRMN1ryma0sYdDQebP5AAE9dWTG321ETt1V1f/z6PFdB1EbQ4v8HxlwOf8LJS5RO4ABxP5MFs6V1WBElpJqloknj3uAtpi9ky4NdppgpdEi1MZAu/wzshhZ5tA4IeOrmhftniEOIJIQ1M0a7X93UoiRQicHRTuriSb7aoqltVoIyFxQkyVALi8NCTiOFkHfEI91oAIfnmAgn9SHFXmICHTIq+yNFtsN17bUuy0y76FdmUGgQ1Qp7RMkkwQeu+/MSBA87n70qScccYf4ZnGbkDp+R96CCPPxuFpTnnGvngS1BaryGbNdnvjrhwQ+c+YrljCt1sPwoKfgqnfMQb5pyM61hGnmY+IY5tNe+vzaVVkI+LtiajZMCYOVo9UiBu8Ngu4hwr3EP1l295S7UrhgiundXnkbMsECxIHqgrZPa01XdQvfHfH6SiwJQzcW2GOiXUxh8bGqTlZ4dyD+ECyj9Es8pkvR4Anc2lInlxxzobyqiwxpE9DUlqanAG4sOD8K/LX1GWHFhClw8DBcn2nT4LbOVgF/F9tZhSkYWyKfdbJ4wwCxfzFdNssu+Nm3elVcr2+a/VYajlARwduXyR2POENi4oIVdCwJn2Pgb3zb89pGDixgTU2c082aJX9guamyoldK/LJjXr1jerz8KsHbbPmLJBbpdBiplbfKBJHMWkKBqmjPH3omXJVk0Zu6j4SzNkhw4yz1Z8bbYDl56P/Ge8G6JjeZaR81Ni3cpLCcYmj0sTHGEulyro3oSWbX2a5qeP2T4Agw2pwOuXBrOwRcgcM08MakDgdvTQQ6hbvE1Sxelo
 +kVMzQbI
 Nd6yMTPH5we8Kd6DHldTaNbAOTJHh3xUFgI/yGlU06C1vstdCshcEg6lSfpZ+oibCSbReEtaly39fl7WF/s5dcKglOTclvv6u+fx364cUorj+zvj7IC5x0/TUGEjAus0EezpJzfjO8TbqWl5GJ2rc3Qv9BNz1Dm9+F5E5VQKFFEr61pWekLkHC/FwtX1OzoTWgZnKG5m1smUt3K+dbbdtuYrV5UnqC1/UCHSVqpSW4s9bcoSgB+BuXze6ArVoTNLTQmGt/FfLzcwMmTPujbaAnFiWvuq2lvmErv/B/XpvmvXWikNvrc7ZvBZpzATNwmaAVdXakkn3uw2up7ts9kfRscgVJXZsQ+2KMYNj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add CONFIG_XSWAP and the state needed for a sparse cluster_info array:
cluster_vm, nr_clusters_max, nr_clusters_mapped and xswap_lock.

Also add the helpers that map and unmap chunks of the VM_SPARSE area,
plus the callback that finds the already-mapped prefix. The helpers
have no callers yet; the next patch adds them into setup/free and the
walkers.

Unmap collects the backing pages before the PTEs go away and frees them
after, so it cannot fail and its callers need no retry loop. If the
collection array cannot be allocated, it falls back to a bounded batch
with a stack array.

They are marked __maybe_unused for this intermediate step so a
CONFIG_WERROR=y build does not warn about the missing callers.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   6 ++
 mm/Kconfig           |   9 ++
 mm/swapfile.c        | 231 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 246 insertions(+)

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
index afff1b25b543..9bdb905a66ef 100644
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
+	  array is backed by a sparse vmalloc area that is mapped lazily
+	  in chunks, avoiding static pre-allocation overhead.
+
 config ZSMALLOC
 	tristate
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 619bd5305120..afd0e8718544 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,6 +49,21 @@
 #include "internal.h"
 #include "swap.h"
 
+#ifdef CONFIG_XSWAP
+/* Batch size for the fallback unmap; keeps the stack array small. */
+#define XSWAP_UNMAP_BATCH_PAGES		16
+#define XSWAP_UNMAP_BATCH_CLUSTERS					\
+	max_t(unsigned long,						\
+	      ((XSWAP_UNMAP_BATCH_PAGES * PAGE_SIZE) /		\
+	       sizeof(struct swap_cluster_info)), 16)
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
@@ -3662,6 +3677,222 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	return maxpages;
 }
 
+#ifdef CONFIG_XSWAP
+static int __maybe_unused xswap_map_clusters(struct swap_info_struct *si,
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
+struct xswap_page_data {
+	struct page **pages;
+	unsigned long nr;
+	unsigned long max;
+};
+
+static int xswap_collect_page(pte_t *pte, unsigned long addr, void *data)
+{
+	struct xswap_page_data *xpd = data;
+	pte_t pteval = ptep_get(pte);
+
+	if (!pte_present(pteval))
+		return 0;
+	if (WARN_ON_ONCE(xpd->nr >= xpd->max))
+		return 0;
+	xpd->pages[xpd->nr++] = pte_page(pteval);
+	return 0;
+}
+
+/*
+ * Free the backing pages mapped in [vm_start, vm_end) and clear the PTEs.
+ * @pages must have room for @max pointers.
+ */
+static void xswap_unmap_range(struct swap_info_struct *si,
+			      unsigned long vm_start, unsigned long vm_end,
+			      struct page **pages, unsigned long max)
+{
+	struct xswap_page_data xpd = {
+		.pages	= pages,
+		.max	= max,
+	};
+	unsigned long i;
+
+	apply_to_existing_page_range(&init_mm, vm_start, vm_end - vm_start,
+				     xswap_collect_page, &xpd);
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+
+	for (i = 0; i < xpd.nr; i++)
+		__free_page(pages[i]);
+}
+
+/* Caller must hold si->xswap_lock.  Cannot fail. */
+static void __maybe_unused xswap_unmap_clusters(struct swap_info_struct *si,
+				 unsigned long start_idx, unsigned long nr)
+{
+	unsigned long start_addr = (unsigned long)si->cluster_info +
+				   (size_t)start_idx * sizeof(struct swap_cluster_info);
+	unsigned long end_addr = start_addr +
+				 (size_t)nr * sizeof(struct swap_cluster_info);
+	unsigned long vm_start = PAGE_ALIGN(start_addr);
+	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	struct page **pages;
+	unsigned int noreclaim_flags;
+	unsigned long npages, idx;
+
+	mutex_lock(&si->xswap_lock);
+
+	if (vm_start >= vm_end) {
+		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+		mutex_unlock(&si->xswap_lock);
+		return;
+	}
+
+	npages = (vm_end - vm_start) >> PAGE_SHIFT;
+
+	if (npages <= totalram_pages()) {
+		/* Reclaim here would re-enter xswap_map_clusters() and its lock. */
+		noreclaim_flags = memalloc_noreclaim_save();
+		pages = kvmalloc_array(npages, sizeof(*pages),
+				       GFP_KERNEL | __GFP_NOMEMALLOC);
+		memalloc_noreclaim_restore(noreclaim_flags);
+		if (pages) {
+			xswap_unmap_range(si, vm_start, vm_end, pages, npages);
+			kvfree(pages);
+			goto out_store;
+		}
+	}
+
+	/* No memory for the array, or too large: unmap in bounded batches. */
+	for (idx = start_idx; idx < start_idx + nr; idx += XSWAP_UNMAP_BATCH_CLUSTERS) {
+		unsigned long batch = min(start_idx + nr - idx,
+					  XSWAP_UNMAP_BATCH_CLUSTERS);
+		unsigned long addr = (unsigned long)si->cluster_info +
+				     (size_t)idx * sizeof(struct swap_cluster_info);
+		unsigned long bstart = PAGE_ALIGN(addr);
+		unsigned long bend = PAGE_ALIGN(addr + (size_t)batch *
+					       sizeof(struct swap_cluster_info));
+		struct page *batch_pages[XSWAP_UNMAP_BATCH_PAGES + 1];
+
+		if (bstart < bend)
+			xswap_unmap_range(si, bstart, bend, batch_pages,
+					  ARRAY_SIZE(batch_pages));
+	}
+out_store:
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+	mutex_unlock(&si->xswap_lock);
+}
+
+/* Track the end of the run of pages that is already mapped. */
+static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
+{
+	unsigned long *mapped_end = data;
+
+	/* The mapped range is a prefix, so the first hole ends it. */
+	if (!pte_present(ptep_get(pte)))
+		return 1;
+	*mapped_end = addr + PAGE_SIZE;
+	return 0;
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
-- 
2.54.0


