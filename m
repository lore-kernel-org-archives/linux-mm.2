Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E53E606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ExotY1oi
Received: by kanga.kvack.org (Postfix)
	id 7CC4E6B05B4; Sun, 22 Nov 2026 07:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A38F6B05B5; Sun, 22 Nov 2026 07:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0966B05B6; Sun, 22 Nov 2026 07:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29D3D6B05B4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92F2B1605CE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:10 +0000 (UTC)
X-FDA: 85462712580.03.DB9462A
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B54480002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ExotY1oi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351208;
	b=SlwTuwZLDo8UgWs1OXwvkmONfmqHx18nHQPzLV3ZUDLnVySagXS22Gq4I4kw54/IdSFyjN
	kEvVib5NciXoPeTRZZfZAnqHi9O82PH31wU8rBoV2EnFRAeUHIo+bl+pJVG5o6c+ZrLbAX
	vZhz8utHuCkYad98YUXRbncKXyS9NNU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBBVgvVNenWZBOiguDfU2Z0fCx1JK0UcLCVPe4+6boE=;
	b=KzgU5tBN8uVeSEff9ZcM1ge4zeOvN8eFliOS5Eghknb6wfnpDYw/898hek+CKapPGKv6Ch
	5KArtuB9ilRQa2KVDCamC6f9Ek+1Glnoa732xiKJiQqlmPz3p0x6aHxduKSmojSTHsBRW4
	T8R27aH7lvXaGA9aeC57Y0vn/Bstm4M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ExotY1oi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t8dNexkpfpO63QAtjHtgcWbqG6+WgxHV0278zBeSYhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351207; v=1; x=1795956007;
 b=ExotY1oieIebUfN9JkAshMGMVY3AnzdAxf9XkrCTDcVRw7in4CgmN27XzfittlkWQ/wDvN3a
 4e0cT+JWYIdMAJHQLjjfwH0SWzIBxH5Ordx4eAqCJvvcHfzseaJplIiewT3znFLkswWaoZ3EWN2
 rOvq7v2AZZcxrB/NX/pJdKms=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f2dc6aa7f95876d3;
	Sun, 22 Nov 2026 12:40:07 +0000
X-Mizu-Trace-ID: f2dc6aa7f95876d3
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 04/14] mm, swap: use a VM_SPARSE cluster array for xswap devices
Date: Sun, 22 Nov 2026 20:39:08 +0800
Message-ID: <20261122123918.3486916-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iy1bcobqxdd1ydd38opatiqj9gsku4ae
X-Rspamd-Queue-Id: 8B54480002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795351208-315041
X-HE-Meta: U2FsdGVkX1950V7E7ExvDyDFhJDUFJ8SxYwG4Tlnmq+OvxhFPrBagsaog5A+wfPvlyGhlT72JOS2brDXFX73xnnxBirPW0mfctyLET/JXQ6B8hd3CV1W29mmD05ENfI3rnBwidrpalBAP+JxExElvaobGzV8KA//mSolRUKGA9/BScEI5IHAh0TbKM3jDxp9ILJtWhOHF10wXEhDaxO8bQEgD1816xaqYLqPIsX5JxPCh9+bEujo31IqpIuP3hf5TFDp4pNEi6Ch/WgHognJRJ14sHkjVxl3zxO3nxuhGvUodwh/gR6iZKnYYqgzpJLGSv85WRZhec5Psim6H/VHUhlD0PWr+w9mwQ0XBjb12eKJacFK/9QcoQ0xuuHgorW9y8T0nTvdrj2wJc0VUgU8yiNJfCDFPH0quk23oLd0F9WyQ7wXnK2XA+W5FmptpAeTtlgals4J7aTAzMek+GE6vU+ktzEkw1y0Qca0E0FftLpj5WJnegCG7ayilMhwkbbf9S9Srswb8690wJF661dMKQ6ji4DUuSTjigcXA5tI4WT6M1iqK8WzaaUefB5j8c7gAuhi2nPVLz60pNMe/m/DosGMpKO8FswXfYFe2tLQ8J9Ul5+xnzcxVZVHX3CzBg/Xz9w3byUDGLninhvoInDH4F58unewl6sGmNrMZOgOd3SlacE0YzqhWPnQZvzE1N5XESsd/FWKV0suGrA/SIpmDXerflnrDOh0deaabwb+8MmYwKOYhmf0634/UbOqHq91SIxLeAn13DnbBTQViKYUDasU69E0eIHYCDWGYWQlWxkvD31ioy15k61PGNH4i5bZo82GLKFYEQmF6yjAjEgAymRxJyYAGpDwsN6s9FUkvRAUlmNEyKbmJcGKlBUe7BwTmnXSTuIDfOeenX05guJ6bpRRAerkGd5fPc904kzskQNMH5rexVZEnfHk6dpwdKTC9A188t0zf6unNfn3Two
 ebOKaXPy
 P8rHN8W8Mxo59iZbTltDfus/dPsJ2cGZ2CbYLlMmpHajs6Dty4wJw6YL+6gVCHXYVGyhyODQZjt98DAv/4D1I2E8bdMh0BU7k75iEQxaL3A/FrJqofPlBxG7My3PRsIeW6I3r42GBygeDDwj37AS/6x7RBiurr5laboRlBO1/ZiLCM8jL6/DDHkTV8NGoRiV9znsf0uwtfbCiGUjQN3SsRfd9llxKibQLVO/w+MI6fwq1kiGGC0vWzyKW6Mdx5AYpYfy1W0H+G0GwmltNd4hmu53+/fkYWv8TfojTetCrE4i7IpK6PtfMv0RXY4rv0BC5yaGpSnBGKNpGINS6tWRVVhFR2d13JpY/GEv2iJUkWXgvHiwJS56prE4KDzMWbPKwfScCUFB+XlIf15X7A8WLSlYG/gnB7i3mhaerwWzvWrs7iYd5uGELH8iENI4jtQTHTcqmYjRKFiqvCOATxmQxzwocUG898s8B2CGyo5fSSszm1Us5Xw96usU4TY8mec7yBVIsbmP9BxIbRziPBzq++yvL5fe87tYHZ4YA2mGtv+BY69Tw6t7snJcB+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add CONFIG_XSWAP and the per-device state for the sparse cluster array.

An xswap device does not have to allocate cluster_info for its whole
address space at once.  Create the array as a VM_SPARSE | VM_ALLOC area,
which reserves the whole range but lets vmalloc allocate and track the
backing pages, and map only the first chunk at setup.  The map helper
extends the mapped range as clusters become visible, and a failed grow
leaves the previous backing in place.

Setup, free and the two cluster_info scans must change together; free
uses vfree(), which drops the mapping and the pages together.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   6 ++
 mm/Kconfig           |   9 ++
 mm/swapfile.c        | 203 +++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 209 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9073d29377d8..4a30cf7ee186 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -242,6 +242,12 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
+#ifdef CONFIG_XSWAP
+	struct vm_struct	*cluster_vm;	/* VM_SPARSE | VM_ALLOC area */
+	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
+	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct mutex		xswap_lock;	/* serialize map/unmap operations */
+#endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
diff --git a/mm/Kconfig b/mm/Kconfig
index 18c0beafd4b8..a8707bbd8d62 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -122,6 +122,15 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
        default ""
 
+config XSWAP
+	bool "Extendable (virtual) swap device"
+	depends on SWAP && 64BIT && ZSWAP
+	help
+	  Adds support for extendable swap devices (xswap) that decouple
+	  PTE swap entries from physical backing storage. The cluster_info
+	  array is backed by a sparse vmalloc area that is mapped lazily
+	  in chunks, avoiding static pre-allocation overhead.
+
 config ZSMALLOC
 	tristate
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 35a079f2bb76..de2feaa2a628 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,6 +49,15 @@
 #include "internal.h"
 #include "swap.h"
 
+#ifdef CONFIG_XSWAP
+/*
+ * Clusters mapped per grow: one page worth of cluster_info, so the
+ * vmalloc page table overhead stays proportional to the mapped range.
+ */
+#define XSWAP_GROW_CLUSTERS \
+	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
+#endif
+
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
@@ -1983,6 +1992,20 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto put_out;
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		/* Pairs with the release store in xswap_map_clusters(). */
+		unsigned long mapped = smp_load_acquire(&si->nr_clusters_mapped);
+
+		/*
+		 * xswap maps cluster_info lazily.  A stale entry can point
+		 * past nr_clusters_mapped; reject it before anything
+		 * dereferences cluster_info.
+		 */
+		if (offset / SWAPFILE_CLUSTER >= mapped)
+			goto put_out;
+	}
+#endif
 
 	return si;
 bad_nofile:
@@ -2863,10 +2886,27 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2874,11 +2914,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2888,13 +2928,13 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2904,7 +2944,6 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
 	return 0;
 }
-
 static int try_to_unuse(unsigned int type)
 {
 	struct mm_struct *prev_mm;
@@ -3202,6 +3241,14 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
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
@@ -3213,11 +3260,38 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
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
+		vfree(si->cluster_info);
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
@@ -3715,6 +3789,54 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	return maxpages;
 }
 
+#ifdef CONFIG_XSWAP
+static int xswap_map_clusters(struct swap_info_struct *si,
+			      unsigned long start_idx, unsigned long nr)
+{
+	/* vm_area_grow_pages() takes an offset into the area, not an address. */
+	unsigned long vm_end = PAGE_ALIGN((size_t)(start_idx + nr) *
+					  sizeof(struct swap_cluster_info));
+	unsigned int noreclaim_flags;
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
+	/* Prevent recursive reclaim during page table allocation. */
+	noreclaim_flags = memalloc_noreclaim_save();
+	/* __GFP_ZERO: cluster_info pointer fields must start NULL. */
+	err = vm_area_grow_pages(si->cluster_vm, vm_end,
+				 GFP_KERNEL | __GFP_ZERO |
+				 __GFP_HIGH | __GFP_NOMEMALLOC);
+	memalloc_noreclaim_restore(noreclaim_flags);
+	if (err) {
+		mutex_unlock(&si->xswap_lock);
+		return err;
+	}
+
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	/*
+	 * Publish the new mappings and cluster lock initialization before
+	 * the count; walkers without xswap_lock use smp_load_acquire().
+	 */
+	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+}
+#endif /* CONFIG_XSWAP */
+
 static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    union swap_header *swap_header,
 				    unsigned long maxpages)
@@ -3724,6 +3846,69 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	int err = -ENOMEM;
 	unsigned long i;
 
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		unsigned long size = PAGE_ALIGN(nr_clusters * sizeof(*cluster_info));
+		struct vm_struct *vm;
+
+		vm = get_vm_area(size, VM_SPARSE | VM_ALLOC);
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
+		err = xswap_map_clusters(si, 0, min_t(unsigned long,
+					XSWAP_GROW_CLUSTERS, nr_clusters));
+		if (err)
+			goto err_free_vm;
+
+		/* xswap: only cluster 0 slot 0 is bad */
+		err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
+		if (err)
+			goto err_free_vm;
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
+err_free_vm:
+		vfree(si->cluster_info);
+		si->cluster_vm = NULL;
+		si->cluster_info = NULL;
+		si->nr_clusters_mapped = 0;
+		return err;
+	}
+#endif /* CONFIG_XSWAP */
+
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
 	if (!cluster_info)
 		goto err;
-- 
2.54.0


