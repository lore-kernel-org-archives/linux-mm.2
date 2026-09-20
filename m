Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0121EC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE546B0098; Sun, 20 Sep 2026 03:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5D46B0099; Sun, 20 Sep 2026 03:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAF36B009B; Sun, 20 Sep 2026 03:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82C736B0098
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01245A03D4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:17 +0000 (UTC)
X-FDA: 85233294594.01.3CC28A4
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1545E40004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nugYhni9zmKELzfck/3U45p0ZanhTWkXuq6xsYvKb/U=;
	b=dtR4ciOmx9p2GJtqoKFRbeyXQ9FvV1DH4IoQ9jx4+PfzePY4wWj1Azuou3r1ftZpfls9rn
	D0uCPFwtneTCoahcK6TuGcmhaFqRZ5rcjAHSHYbeaYbLd9Z5o+ZV5JuYCX+osmqQJD5Km0
	LZxCE/C+yw3gXq7HYTVcwGYY6mlCLtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888876;
	b=KUibP5xgt7VHnRR//tsR2aFU5lS1FoWTZV7NSn3KWl+UIVmDhr3tknCsMldPbFbz7aliTb
	80Hv4jgeIgD613E3WOk3pXbtcrtQBMSEGN+TvL89hIWk67NWjTuXbl5q105AVa6h1Ys+f+
	m8w16rk26GuFDISY6viIFlcVd4lXi9U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 33b92abfa14ff38e;
	Sun, 20 Sep 2026 07:21:14 +0000
X-Mizu-Trace-ID: 33b92abfa14ff38e
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
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 04/17] mm, swap: add a physical backend for xswap slots
Date: Sun, 20 Sep 2026 15:20:30 +0800
Message-ID: <20260920072043.430390-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1545E40004
X-Stat-Signature: u5b9h7ex3opmizb1coo94cfniaghmh7i
X-HE-Tag: 1789888875-785924
X-HE-Meta: U2FsdGVkX18YatU5dp0Y2zisPr0AgRT4uABqPmRj2WSj38oyeDAGNzbZtCEByDgJ0k+e6cw2DnIi1WUjJSb+uq3Jnnm/7iJ/7DW/s/Nb2LowpjbzCDEuaWkmTeJ8DOSKN/RXTrKblFRN/9tU+uAOxwl9Z/+bvCzjat454x08hUBqNsw7vSrN7gzcgGBD58qpGQeJ4A0NBVd2d04tIR7HVcC2P7y1jel9pB5Wad+s3gP3riTXnO8Y0men13IkHL8h3O4+BJndPe8zJL/ok6cCM/UbIshf5NNl4OIvF/mYyYZ4wtHim1DNKsyuQPtk8iOLdXQvRLewX1J53SEkBopkVRU/DjDjhM6iyoxKcROxhUiBwBuMUd4bYT8UQrpKXp5grP6xkiGmB25lWfGYqgy8lvnEfhWUkAXj5R3wHxYTewiOE5Zn0DVf0EXvLxnt6yRiQ5iOVhn0ZzmPQBZHcPOoDeiWIsiDEB5grRu1K4hpb8im6pytbqwELSDAFtEDLJxkMlzq31TUrl2UgKSeJuqncBl++0K9q6IYH/HHNvcJf1liszZwBPz1nczlKsWDPgWX10bo0HxESkO9IYZazUiERCUPosoowlHGBhcfzFYwAcgohVLbVTbBMcmgemdW0f0Z/e0wk751QD686hTe/NndykSEAmVVQh8cwvCwSTEAd4rEckk7l+GKZNvdINTD5oe4oT3+Gar0cTc/97Z/Vd6VvuTeX8HwJ9yAiIl0lOz35CRdBq9ug8immCcjW2VA3hOv5HT8O9tKVS9AvYtSnFd7wDPamVrvf3UFXnixSr2yWmc1/Sp0lkjE8rxhV4hNbpTgMC6cjx8J+d2fCb/HEGdIDSaZfh1In0NempI35jtZ9gseDQDn4h8cxjr1uArg2o9j7t5VCZthhXIaxMVCQ1TM1Y3yB73zAWtDrW99eoGZdbaGTFNtplSMvX6EVt5Qcndp96bwMdDWNetyyHx8tdi
 DvXmbqwJ
 PhS8l/42XiQa9/Lxt5IPDCvQbnwDxwH7Kbm7wEOOfGCqYFowTcvMWMIYp0s2xakdR2L6eXxnIr/5vVpC36r77++EGKqPlXcLmBNunIgG6IyzdX1m3Bo5TD+563ltWSDCfHy7kr3jF071z2a8dI0nXL5eeyt6Ji14LhUF9e8fUyRSuI8u0tfRr6PThEYAHL8BWNsn70D9HHElwNUUt/g79PmSvQrdlI2+wLqNg5uiKKHi0v0hBykHc5hm8+r8Zove+imqjNQyJ4z14Cj8P6JnY60Vtc4HypwP1PQH8Ylaq0eYb2lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap slot keeps its data only in the zswap pool. When the pool
drops the entry, the data is gone. So give each xswap slot a physical
backend on the highest-priority real swap device. Each backend is
recorded in ci->xs_table[], which is allocated on first use. Zero
means no backend.

Freeing an xswap slot also releases its physical slot. But the record
can be out of date, so first check that the physical slot still points
back to this xswap entry. It may have been freed and given to another
entry.  That entry's data must not be dropped.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swap.h     |  24 +++++
 mm/swapfile.c | 286 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 310 insertions(+)

diff --git a/mm/swap.h b/mm/swap.h
index 14b8c6b9d468..30b67915c459 100644
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
index 69ffa9a7a646..7b44458472a1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -73,6 +73,11 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 static void xswap_try_shrink(struct swap_info_struct *si);
 static int xswap_dev_kobj_add(struct swap_info_struct *si);
 static void xswap_dev_kobj_del(struct swap_info_struct *si);
+static void xswap_free_phys_slot(struct swap_info_struct *si,
+				 swp_entry_t entry, swp_entry_t phys);
+static void xswap_release_slot_backend(struct swap_info_struct *si,
+				       struct swap_cluster_info *ci,
+				       unsigned int slot);
 
 static int xswap_create(int prio);
 static int xswap_destroy(int type);
@@ -2164,6 +2169,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
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
@@ -3066,6 +3076,69 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
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
+	if (!ci->count)
+		free_cluster(si, ci);
+	else
+		partial_free_cluster(si, ci);
+	swap_cluster_unlock(ci);
+
+	swap_range_free(si, offset, 1);
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
@@ -3973,6 +4046,211 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
+static void xswap_free_xs_table(struct swap_info_struct *si, unsigned long idx)
+{
+	struct swap_cluster_info *ci = &si->cluster_info[idx];
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
@@ -4135,6 +4413,14 @@ static int xswap_unmap_clusters_locked(struct swap_info_struct *si,
 	unsigned int noreclaim_flags;
 	int i;
 
+	for (unsigned long idx = start_idx; idx < start_idx + nr; idx++) {
+		struct swap_cluster_info *ci = &si->cluster_info[idx];
+
+		spin_lock(&ci->lock);
+		xswap_free_xs_table(si, idx);
+		spin_unlock(&ci->lock);
+	}
+
 	if (vm_start >= vm_end) {
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 		return 0;
-- 
2.54.0


