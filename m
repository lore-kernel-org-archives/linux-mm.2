Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D86CA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD3D6B009B; Fri,  2 Oct 2026 20:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE4C6B009D; Fri,  2 Oct 2026 20:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D758C6B009E; Fri,  2 Oct 2026 20:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A323E6B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3BFBE407A6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:48 +0000 (UTC)
X-FDA: 85279507656.06.E82D289
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B1C020005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989186;
	b=o2Fyteel/Q7t+qt5SPf86VA6Z0BiHBWm4OhX5VGoY7ou2VKBH1U2Pxs/kBHPA+Yr1Bd1jP
	qbfR3rw00vn0YuDrGYYBVLg6qz4i0CS6/ZHoZnUof55qwkVrBDe61y+yoO/yIQLs7LCBh+
	J4M7cGn+OZa78YyrjfLW95owwVXtNSA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wAnEQwJLXdjh3JtwW7Di3lp2WfguhTJmODclyjaVpY0=;
	b=8i0wyvKm30MMV7WFeJjlIpcBlO/f0CYTnnD0Y6ZTTzB9UvexC86uPIg0hN1by1fp7rFnfr
	pIJ4+ml89jYdNbnFNsYRQWMH/dGvvVmMXeB62j0ogYwsObzDOAZUzDXpWmm/LAcoZsDlN4
	SE2t6VUlCpm27BbMSrXPcBCgXN11buI=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 60736324dbb4ef40;
	Sat, 03 Oct 2026 00:59:44 +0000
X-Mizu-Trace-ID: 60736324dbb4ef40
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
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 04/12] mm, swap: add a physical backend for xswap slots
Date: Sat,  3 Oct 2026 08:58:52 +0800
Message-ID: <20261003005900.909710-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: g17uwznb4gqiuq3zp9yuwyt933nfpr9h
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B1C020005
X-HE-Tag: 1790989185-715673
X-HE-Meta: U2FsdGVkX1+//jNsAAS/xryrZk315NEwOKTWBa1FNihYBdsyEGPojzqwFkajOUoLuXbRHVZzXktWh4EzNfDJ3Sk5KUqKZdzII6EQwPtZmKFPNTljpwlsCmschCQmlNkTb8cm5ekBtO6rnzKSnoi7hwTwPRVansnR+M5XKlBz+mIQfjBJb1X3CcBmxrd+XX9Vvv0CjKhT4f3t67nsWtJXk3iLUQ8rkp4vuXZLD2aBvJFjgtmXtHTTl+LelXDi433DzqWEQnRNIth1QhnEjIjcCAHWM5SM+wqychDkO8jppq8qncA4RwYob43W37bdTqoq5SjIZ0xkx84K3jZaMJ/NXpSlJyjiHLqonj0l0E+j23L52C91HPTfIGQzwrHjQMpTU5Q7sQy6/Tt6M7y3fJwQyHikxNCzEHKsxJ+VzO2aHz5Za9L2Pwda7N56ywJ1MD0vTALWhEZNYyLP4kOJAJdCcIRFH8PTLKlownco9xiVtA/iY9j0JG4RFdfQflxNF6J+TptAjydldW9ZjXwT6X319dXi5fpSXkRh7sXgEoxgedPaG4EjV6rQBjghinLBOedcTTQbu7eEXwYbZsD3I+LAw8vSafbuAzevv4UvMOi6x9w+joEkGzvPu+BWFu+TAJv9Y+HQCnkuH5ZKmRU0Eg47xb7uFr7MXsbznP6j5OtgazDAgZfRjBxF9Iy65p9TX4XfvE/YgaSC7O+soePzRqAKJsP99mGuolS0RI3HDPujPaM2XxHn5UotrTyNEuY9Z/piPp8BVghRLBLYdum2t6SNhOgaMoWUeGHNU17hPFU97uuvOqDdHSt7/mJSQpZE3z7VQvvGat7TbHWU+AoOixRO9OdiPvZFWl/MlBuW5Tys7roNdRlTlRnVtGHvJzLZPUVaj4mUkV44FGqdszdYZNyXBJToKQugHMwM3Va40b4PuHPou81meIVNzRwivpIUHZevd2ZKuw22RlDpOzSBuV5
 MIVgIYBJ
 xtLeCI+TWrW2cT+gB/Q48PXyfHAz5GaGYhYVw+bWCI44TaJeu6kEiZpQyvunTLsGxyJ7gBy5CjJ988o7RUnXFHLh6EqMssUn1s7FE539o6vRf4R4X9Ov9e8Xe4OCR/hUDMT4KC3xlGGpzAUTydP/KnNejLUw8Fy5B7CI7ojEXBjXeQlo2h6QnUqzT7oGFvAFAnBiZvvozo8kFuu0ZzBr9fPZ9zjGRlMc9I2ePJ1Mm5cXziMRR6qP/IvaTm1DhJQVXcc+hZeS5NFA23W8FrNjenJFu5VxtJPxn8HFZCuBTjW18dzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap slot holds its data only in the zswap pool. There is no
second copy anywhere, so once the pool drops the entry the data is
gone. Give xswap slots a physical backend they can be written out to:
a slot on the highest-priority real swap device.

The backend is recorded per slot in ci->xs_table[], an array of
SWAPFILE_CLUSTER unsigned longs that is allocated on first use. If a
cluster only ever holds zswap-only slots, xs_table[] is never
allocated. Zero means "no backend".

Freeing an xswap slot releases its physical slot. The release checks
that the physical slot still belongs to this xswap entry. If it belongs
to another one, the record is stale. That slot was freed and handed out
again. Then the slot may by belong to another entry, whose data must not
be dropped.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swap.h     |  24 ++++
 mm/swapfile.c | 317 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 339 insertions(+), 2 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index fcde284b16b4..838dac4282f6 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -58,6 +58,9 @@ struct swap_cluster_info {
 	u8 order;
 	atomic_long_t __rcu *table;	/* Swap table entries, see mm/swap_table.h */
 	unsigned int *extend_table;	/* For large swap count, protected by ci->lock */
+#ifdef CONFIG_XSWAP
+	unsigned long *xs_table;	/* Physical backend per slot, lazily allocated */
+#endif
 #ifdef CONFIG_MEMCG
 	struct swap_memcg_table *memcg_table;	/* Swap table entries' cgroup record */
 #endif
@@ -470,4 +473,25 @@ extern const struct swap_ops swap_bdev_ops;
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
+#ifdef CONFIG_XSWAP
+swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot);
+swp_entry_t xswap_backend_alloc(swp_entry_t entry);
+void xswap_backend_free(swp_entry_t entry, swp_entry_t phys);
+#else
+static inline swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci,
+					     unsigned int slot)
+{
+	return (swp_entry_t){};
+}
+
+static inline swp_entry_t xswap_backend_alloc(swp_entry_t entry)
+{
+	return (swp_entry_t){};
+}
+
+static inline void xswap_backend_free(swp_entry_t entry, swp_entry_t phys)
+{
+}
+#endif /* CONFIG_XSWAP */
+
 #endif /* _MM_SWAP_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index dd18aad7cfd9..20a9192c39de 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -101,6 +101,13 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 static void xswap_try_shrink(struct swap_info_struct *si);
+static void xswap_free_phys_slot(struct swap_info_struct *si,
+				 swp_entry_t entry, swp_entry_t phys);
+static void xswap_release_slot_backend(struct swap_info_struct *si,
+				       struct swap_cluster_info *ci,
+				       unsigned int slot);
+static void xswap_free_xs_table(struct swap_info_struct *si,
+				struct swap_cluster_info *ci);
 
 static int xswap_create(int prio);
 static int xswap_destroy(int type);
@@ -826,6 +833,14 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
 	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
+#ifdef CONFIG_XSWAP
+	/*
+	 * An empty cluster can still hold records. Give them back first:
+	 * swap_cluster_free_table() frees the table the owner ID comes from.
+	 */
+	if (si->flags & SWP_XSWAP)
+		xswap_free_xs_table(si, ci);
+#endif
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -1072,6 +1087,12 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		/*
+		 * A pointer-tagged slot backs an xswap entry, not a cached
+		 * folio, so it can't be reclaimed here. Reject the range.
+		 */
+		if (swp_tb_is_pointer(swp_tb))
+			break;
 		if (swp_tb_get_count(swp_tb))
 			break;
 		if (swp_tb_is_folio(swp_tb))
@@ -1836,6 +1857,14 @@ static void __swap_cluster_put_entry(struct swap_cluster_info *ci,
 
 	lockdep_assert_held(&ci->lock);
 	swp_tb = __swap_table_get(ci, ci_off);
+	/*
+	 * A pointer-tagged slot has no count of its own. Putting one would
+	 * corrupt the reverse mapping, so never touch it here.
+	 */
+	if (swp_tb_is_pointer(swp_tb)) {
+		VM_WARN_ON_ONCE(1);
+		return;
+	}
 	count = __swp_tb_get_count(swp_tb);
 
 	VM_WARN_ON_ONCE(count <= 0);
@@ -1944,8 +1973,8 @@ static int __swap_cluster_dup_entry(struct swap_cluster_info *ci,
 
 	lockdep_assert_held(&ci->lock);
 	swp_tb = __swap_table_get(ci, ci_off);
-	/* Bad or special slots can't be handled */
-	if (WARN_ON_ONCE(swp_tb_is_bad(swp_tb)))
+	/* Bad, pointer-tagged and other special slots can't be handled */
+	if (WARN_ON_ONCE(swp_tb_is_bad(swp_tb) || swp_tb_is_pointer(swp_tb)))
 		return -EINVAL;
 	count = __swp_tb_get_count(swp_tb);
 	/* Must be either cached or have a count already */
@@ -2257,6 +2286,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		 */
 		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
 
+#ifdef CONFIG_XSWAP
+		if (ci->xs_table && ci->xs_table[ci_off])
+			xswap_release_slot_backend(si, ci, ci_off);
+#endif
+
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
 		if (!SWAP_TABLE_HAS_ZEROFLAG)
@@ -3164,6 +3198,71 @@ static unsigned long find_next_to_unuse(struct swap_info_struct *si,
 
 	return 0;
 }
+
+#ifdef CONFIG_XSWAP
+/*
+ * Free the physical slot @phys and clear its reverse mapping. @entry is the
+ * xswap entry that recorded @phys. The slot is only freed while it still
+ * says it belongs to @entry: our record can go stale, and @phys may by then
+ * have been handed to another xswap entry, whose data must not be dropped.
+ *
+ * free_cluster()/partial_free_cluster() require the cluster lock.
+ */
+static void xswap_free_phys_slot(struct swap_info_struct *si,
+				 swp_entry_t entry, swp_entry_t phys)
+{
+	struct swap_cluster_info *ci;
+	unsigned long swp_tb;
+	unsigned int offset = swp_offset(phys);
+
+	ci = swap_cluster_lock(si, offset);
+	if (!ci)
+		return;
+
+	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	if (!swp_tb_is_pointer(swp_tb) ||
+	    xswap_rmap_to_entry(swp_tb).val != entry.val) {
+		/* Already freed, or recycled for another xswap entry. */
+		VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb) &&
+				!swp_tb_is_pointer(swp_tb));
+		swap_cluster_unlock(ci);
+		return;
+	}
+
+	__swap_table_set(ci, offset % SWAPFILE_CLUSTER, null_to_swp_tb());
+	ci->count--;
+
+	/* The slot must not be allocatable before its invalidate hooks run. */
+	swap_range_free(si, offset, 1);
+
+	if (!ci->count)
+		free_cluster(si, ci);
+	else
+		partial_free_cluster(si, ci);
+	swap_cluster_unlock(ci);
+}
+
+/*
+ * An xswap slot being freed may still own a physical slot. Drop it, or the
+ * physical space and its reverse mapping leak. Caller holds the xswap
+ * cluster lock; the physical cluster lock is only ever taken below it.
+ */
+static void xswap_release_slot_backend(struct swap_info_struct *si,
+				       struct swap_cluster_info *ci,
+				       unsigned int slot)
+{
+	swp_entry_t entry = swp_entry(si->type, cluster_offset(si, ci) + slot);
+	struct swap_info_struct *psi;
+	swp_entry_t phys = { .val = ci->xs_table[slot] };
+
+	WRITE_ONCE(ci->xs_table[slot], 0);
+
+	psi = swap_type_to_info(swp_type(phys));
+	if (psi)
+		xswap_free_phys_slot(psi, entry, phys);
+}
+
+#endif /* CONFIG_XSWAP */
 static int try_to_unuse(unsigned int type)
 {
 	struct mm_struct *prev_mm;
@@ -4062,6 +4161,212 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 }
 
 #ifdef CONFIG_XSWAP
+/* The physical slot backing @slot, or zero. */
+swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot)
+{
+	unsigned long *xs = READ_ONCE(ci->xs_table);
+
+	if (!xs || !xs[slot])
+		return (swp_entry_t){};
+
+	return (swp_entry_t){ .val = xs[slot] };
+}
+
+/* Cluster lock held. xswap never unmaps a cluster below the mapped prefix. */
+static unsigned long *xswap_xs_table_locked(struct swap_cluster_info *ci,
+					    gfp_t gfp)
+{
+	unsigned long *xs = ci->xs_table;
+
+	if (xs)
+		return xs;
+
+	/* The owning entry is pinned, so the cluster survives the relock. */
+	if (gfp & __GFP_DIRECT_RECLAIM) {
+		spin_unlock(&ci->lock);
+		xs = kcalloc(SWAPFILE_CLUSTER, sizeof(*xs), gfp);
+		spin_lock(&ci->lock);
+	} else {
+		xs = kcalloc(SWAPFILE_CLUSTER, sizeof(*xs), gfp);
+	}
+
+	if (!xs)
+		return NULL;
+	if (cmpxchg(&ci->xs_table, NULL, xs)) {
+		kfree(xs);
+		xs = ci->xs_table;
+	}
+	return xs;
+}
+
+/*
+ * 4K per cluster, and this runs in reclaim, so it has to be able to sleep.
+ */
+static bool xswap_slot_set_backend(struct swap_cluster_info *ci,
+				   unsigned int slot, swp_entry_t phys)
+{
+	unsigned long *xs = xswap_xs_table_locked(ci, GFP_KERNEL | __GFP_HIGH |
+						  __GFP_NOMEMALLOC);
+
+	if (!xs)
+		return false;
+	WRITE_ONCE(xs[slot], phys.val);
+	return true;
+}
+
+/*
+ * Drop the table of cluster @idx and every backend it still records. The
+ * cluster is going away, so nothing else will: the physical slots would stay
+ * allocated and their reverse mappings would keep pointing at an xswap entry
+ * whose cluster_info is about to be unmapped. Caller holds ci->lock.
+ */
+static void xswap_free_xs_table(struct swap_info_struct *si,
+				struct swap_cluster_info *ci)
+{
+	unsigned long *xs = ci->xs_table;
+	unsigned int slot;
+
+	if (!xs)
+		return;
+
+	for (slot = 0; slot < SWAPFILE_CLUSTER; slot++) {
+		if (xs[slot])
+			xswap_release_slot_backend(si, ci, slot);
+	}
+
+	kfree(xs);
+	ci->xs_table = NULL;
+}
+
+/* Order-0 slot from @si, no folio attached; goes through the per-CPU cache. */
+static unsigned long xswap_alloc_slot_local(struct swap_info_struct *si)
+{
+	struct swap_cluster_info *ci;
+	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
+
+	local_lock(&percpu_swap_cluster.lock);
+	if (this_cpu_read(percpu_swap_cluster.si[0]) == si) {
+		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+		if (pcp_offset) {
+			ci = swap_cluster_lock(si, pcp_offset);
+			if (cluster_is_usable(ci, 0))
+				offset = alloc_swap_scan_cluster(si, ci, NULL,
+								 pcp_offset);
+			else
+				swap_cluster_unlock(ci);
+		}
+	}
+	if (offset == SWAP_ENTRY_INVALID)
+		offset = cluster_alloc_swap_entry(si, NULL);
+	local_unlock(&percpu_swap_cluster.lock);
+
+	return offset;
+}
+
+static swp_entry_t xswap_alloc_phys_slot(void)
+{
+	struct swap_info_struct *devs[MAX_SWAPFILES], *si;
+	int nr = 0, i;
+
+	/*
+	 * Snapshot the candidate devices in priority order. swap_info
+	 * structs are never freed, so the pointers stay valid; liveness is
+	 * re-checked below.
+	 */
+	spin_lock(&swap_avail_lock);
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
+		if (si->flags & SWP_XSWAP)
+			continue;
+		if (nr == MAX_SWAPFILES)
+			break;
+		devs[nr++] = si;
+	}
+	spin_unlock(&swap_avail_lock);
+
+	for (i = 0; i < nr; i++) {
+		unsigned long offset;
+
+		if (!get_swap_device_info(devs[i]))
+			continue;
+		offset = xswap_alloc_slot_local(devs[i]);
+		put_swap_device(devs[i]);
+		if (offset && offset != SWAP_ENTRY_INVALID)
+			return swp_entry(devs[i]->type, offset);
+	}
+
+	return (swp_entry_t){};
+}
+
+/* Reverse mapping: record @entry as the owner of physical slot @phys. */
+static void xswap_install_rmap(swp_entry_t phys, swp_entry_t entry)
+{
+	struct swap_info_struct *si = swap_type_to_info(swp_type(phys));
+	struct swap_cluster_info *ci;
+	unsigned long off = swp_offset(phys);
+
+	if (!si)
+		return;
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		__swap_table_set(ci, off % SWAPFILE_CLUSTER,
+				 xswap_entry_to_rmap(entry));
+		swap_cluster_unlock(ci);
+	}
+}
+
+swp_entry_t xswap_backend_alloc(swp_entry_t entry)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_cluster_info *ci;
+	unsigned long off = swp_offset(entry);
+	swp_entry_t phys;
+	bool recorded = false;
+
+	phys = xswap_alloc_phys_slot();
+	if (!phys.val)
+		return phys;
+
+	xswap_install_rmap(phys, entry);
+
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		recorded = xswap_slot_set_backend(ci, off % SWAPFILE_CLUSTER, phys);
+		swap_cluster_unlock(ci);
+	}
+
+	if (!recorded) {
+		/* The backend is unrecorded, so the data would be unreachable. */
+		xswap_backend_free(entry, phys);
+		return (swp_entry_t){};
+	}
+
+	return phys;
+}
+
+/* Undo xswap_backend_alloc(): the zswap copy is still in place. */
+void xswap_backend_free(swp_entry_t entry, swp_entry_t phys)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_info_struct *psi;
+	struct swap_cluster_info *ci;
+	unsigned long off = swp_offset(entry);
+
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		unsigned int slot = off % SWAPFILE_CLUSTER;
+		unsigned long *xs = ci->xs_table;
+
+		if (xs && xs[slot] == phys.val)
+			WRITE_ONCE(xs[slot], 0);
+		swap_cluster_unlock(ci);
+	}
+
+	/* xswap_free_phys_slot() clears the reverse mapping. */
+	psi = swap_type_to_info(swp_type(phys));
+	if (psi)
+		xswap_free_phys_slot(psi, entry, phys);
+}
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr)
 {
@@ -4285,6 +4590,14 @@ static void xswap_unmap_clusters_locked(struct swap_info_struct *si,
 	unsigned int noreclaim_flags;
 	unsigned long npages, idx;
 
+	for (unsigned long idx = start_idx; idx < start_idx + nr; idx++) {
+		struct swap_cluster_info *ci = &si->cluster_info[idx];
+
+		spin_lock(&ci->lock);
+		xswap_free_xs_table(si, ci);
+		spin_unlock(&ci->lock);
+	}
+
 	if (vm_start >= vm_end) {
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 		return;
-- 
2.54.0


