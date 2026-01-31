Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7FFD79769
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 12:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974576B0092; Sat, 31 Jan 2026 07:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9282E6B0093; Sat, 31 Jan 2026 07:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8419E6B0095; Sat, 31 Jan 2026 07:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 740396B0092
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:56:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE82B5B668
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:29 +0000 (UTC)
X-FDA: 84392257698.19.496191C
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80C18180004
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m6ggH9RzcmNIe2P4W14E/c04VVi+75V5EZljYko0VLA=;
	b=qe8GD+QRh0R3QLhGO1OUcMtF/nnwQvT0nbJaL+GWymAQz2dZewoZkxYZKiT+G3Dmf0fLVq
	cbLSNQAiVwAMpDIv8abHyijw7Y2yXZ6g45ga2qk/m8jt+IB7tbXMZZiFR2QVSD0tW45ENX
	PwHBv9hKmXmf2QFCW3gAJDEPpl2LjYo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769864188; a=rsa-sha256;
	cv=none;
	b=lGGr/bNQjUR3hyrXxsFMJK2KJsUYnUpPv4k7RMHFl/G8uscO0TLCHeoBdNwEC0Qa72m2gS
	Leq1mErQG61KCHwv73mxSNVl901UUEwroZJrEo09ZabdIiaJMaGJWmYv2XCGc0ClK2Bg9i
	5QSrpuhmbWzeq1bnzrnWdj8lSxlRTQo=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Jan 2026 21:56:20 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH v3 4/5] mm, swap: change back to use each swap device's percpu cluster
Date: Sat, 31 Jan 2026 21:54:53 +0900
Message-Id: <20260131125454.3187546-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260131125454.3187546-1-youngjun.park@lge.com>
References: <20260131125454.3187546-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80C18180004
X-Stat-Signature: x31uitei8z59e53czejtst5r1x9srutj
X-Rspam-User: 
X-HE-Tag: 1769864187-504415
X-HE-Meta: U2FsdGVkX1//7SLd88zpMYCnc5TjnIIwsczduUsuEyFWSymtDYTqmOq6118MoVlLak7X//kpCNJhrOXiyRmwyedFHZCGUq+CLS+w4Gp45EDyIpWkqDr4ABnypVZwRaKseKM+e4auoKa3JViUm2hjI9bS5xz/XBZA87YYqFDLS0+UX+4A1ATrcgFaQjoFNc8HN+wIRjOlYsqzymOkSPnJAaOKnldKik3EGc8YaAT/j64c9GKAFD2lYx6+yzAOgpCnct/6/NmCCD7DA1Ve/6qrMvKBZF/PbabKqy91rA+dATRljTSvBUPSzS1q8TyelZtu1auX3cd8itqsppxt8nilye0pp09/B2wAv+XgPU0rRgI78wHVydKA/E5EUDGx/oAXcL57hguvQML4X4c5KX2dUDZjDKdjSlfiiQ3+30Yxd9WhsXq5lm9sWoObR65VRPirZbHJG8IHb4SO/SQgDZto6ZnAgve4nwJMlZTuuetk0ZeS0st2XYmOwFVYLzEDVrSZoVBICIF5+dIJnue1YGuh7zRFN++Cz8KJVot2ZTyeDc4HiMYxjD16ioyNj4cSs9lG0ij95bd00gzD4GY4LC4bJnxwcgpDfOAk58XTbGYqZUM+MVEKg1OAqojCsFvQuDShv7yktHZp99yAkZx7v5WNTrx14LL4VSFqoNPRLnf+DyySBxZDRncf8RJHEM0C5pEq5H2QER5tICk7/yWluZdxRPG+j6n/kv6RoGZaG9W25hu/BZmuEoW/UGmMxUMacT6yMZZfz0hxRvewX/l3IuNITl6Uvwo8VeEQ7sC5e6nnTGmOmLw7/TuWnlwNCM70CY+l9VSVJSyenfap9nxwzSmmlHs/myXssfeFQDMS2czS6+auJWSyvI6LT06EkmsB0dD6DPWyLmmaDxG5i7pmdT4r6MkvjpJPJVNZkqK0Y/Ziz2i/HayhCsbgT/75VPUiuQWln+tdIvJjmEuCX0riSMH
 B0pgXLHl
 a+zrEDcfcisSlcBGs+QUxJC23TDfxr5nfVBl/tByxTNMU0BFKOvvcVgiNlV1Uts77SSWS0M+3rQ8YzY4pC/EmM0OcoSeDRXbwdQZreVejmGi3hl+ikZhoBHuGiQXZLGV0kZW2ZQyy8pqNgzRzJQpuKnn//2oXHEMbrIe3ivFrtQMinVEybWuikkmPOdnjqHdV1Mgtgbn+UHYK9pM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
allocation fast path").

Because in the newly introduced swap tiers, the global percpu cluster
will cause two issues:
1) it will cause caching oscillation in the same order of different si
   if two different memcg can only be allowed to access different si and
   both of them are swapping out.
2) It can cause priority inversion on swap devices. Imagine a case where
   there are two memcg, say memcg1 and memcg2. Memcg1 can access si A, B
   and A is higher priority device. While memcg2 can only access si B.
   Then memcg 2 could write the global percpu cluster with si B, then
   memcg1 take si B in fast path even though si A is not exhausted.

Hence in order to support swap tier, revert commit to use
each swap device's percpu cluster.

Suggested-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  17 +++--
 mm/swapfile.c        | 149 +++++++++++++++----------------------------
 2 files changed, 62 insertions(+), 104 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1e68c220a0e7..6921e22b14d3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -247,11 +247,18 @@ enum {
 #define SWAP_NR_ORDERS		1
 #endif
 
-/*
- * We keep using same cluster for rotational device so IO will be sequential.
- * The purpose is to optimize SWAP throughput on these device.
- */
+ /*
+  * We assign a cluster to each CPU, so each CPU can allocate swap entry from
+  * its own cluster and swapout sequentially. The purpose is to optimize swapout
+  * throughput.
+  */
+struct percpu_cluster {
+	local_lock_t lock; /* Protect the percpu_cluster above */
+	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
+};
+
 struct swap_sequential_cluster {
+	spinlock_t lock; /* Serialize usage of global cluster */
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
@@ -277,8 +284,8 @@ struct swap_info_struct {
 					/* list of cluster that are fragmented or contented */
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
+	struct percpu_cluster	__percpu *percpu_cluster; /* per cpu's swap location */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
-	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
 	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e04811e10431..4708014c96c4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -118,18 +118,6 @@ static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
 atomic_t nr_rotate_swap = ATOMIC_INIT(0);
 
-struct percpu_swap_cluster {
-	struct swap_info_struct *si[SWAP_NR_ORDERS];
-	unsigned long offset[SWAP_NR_ORDERS];
-	local_lock_t lock;
-};
-
-static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
-	.si = { NULL },
-	.offset = { SWAP_ENTRY_INVALID },
-	.lock = INIT_LOCAL_LOCK(),
-};
-
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -477,8 +465,10 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
 	lockdep_assert_held(&ci->lock);
-	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
-
+	if (si->flags & SWP_SOLIDSTATE)
+		lockdep_assert_held(this_cpu_ptr(&si->percpu_cluster->lock));
+	else
+		lockdep_assert_held(&si->global_cluster->lock);
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
 
@@ -494,9 +484,10 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * the potential recursive allocation is limited.
 	 */
 	spin_unlock(&ci->lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
 
 	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
 
@@ -508,9 +499,9 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
+	local_lock(&si->percpu_cluster->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_lock(&si->global_cluster_lock);
+		spin_lock(&si->global_cluster->lock);
 	spin_lock(&ci->lock);
 
 	/* Nothing except this helper should touch a dangling empty cluster. */
@@ -622,7 +613,7 @@ static bool swap_do_scheduled_discard(struct swap_info_struct *si)
 		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
 		/*
 		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster could be
+		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
 		 * pointing to it, or ran into by relocate_cluster.
 		 */
 		list_del(&ci->list);
@@ -953,12 +944,11 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
-	if (si->flags & SWP_SOLIDSTATE) {
-		this_cpu_write(percpu_swap_cluster.offset[order], next);
-		this_cpu_write(percpu_swap_cluster.si[order], si);
-	} else {
+	if (si->flags & SWP_SOLIDSTATE)
+		this_cpu_write(si->percpu_cluster->next[order], next);
+	else
 		si->global_cluster->next[order] = next;
-	}
+
 	return found;
 }
 
@@ -1052,13 +1042,17 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (!(si->flags & SWP_SOLIDSTATE)) {
+	if (si->flags & SWP_SOLIDSTATE) {
+		/* Fast path using per CPU cluster */
+		local_lock(&si->percpu_cluster->lock);
+		offset = __this_cpu_read(si->percpu_cluster->next[order]);
+	} else {
 		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster_lock);
+		spin_lock(&si->global_cluster->lock);
 		offset = si->global_cluster->next[order];
-		if (offset == SWAP_ENTRY_INVALID)
-			goto new_cluster;
+	}
 
+	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
 		/* Cluster could have been used by another order */
 		if (cluster_is_usable(ci, order)) {
@@ -1072,7 +1066,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-new_cluster:
 	/*
 	 * If the device need discard, prefer new cluster over nonfull
 	 * to spread out the writes.
@@ -1129,8 +1122,10 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_unlock(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
 
 	return found;
 }
@@ -1311,41 +1306,8 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
-/*
- * Fast path try to get swap entries with specified order from current
- * CPU's swap entry pool (a cluster).
- */
-static bool swap_alloc_fast(struct folio *folio)
-{
-	unsigned int order = folio_order(folio);
-	struct swap_cluster_info *ci;
-	struct swap_info_struct *si;
-	unsigned int offset;
-
-	/*
-	 * Once allocated, swap_info_struct will never be completely freed,
-	 * so checking it's liveness by get_swap_device_info is enough.
-	 */
-	si = this_cpu_read(percpu_swap_cluster.si[order]);
-	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
-		return false;
-
-	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
-		if (cluster_is_empty(ci))
-			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
-		swap_cluster_unlock(ci);
-	}
-
-	put_swap_device(si);
-	return folio_test_swapcache(folio);
-}
-
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_entry(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
 	int mask = folio_tier_effective_mask(folio);
@@ -1362,6 +1324,7 @@ static void swap_alloc_slow(struct folio *folio)
 		if (get_swap_device_info(si)) {
 			cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
+
 			if (folio_test_swapcache(folio))
 				return;
 			if (folio_test_large(folio))
@@ -1521,11 +1484,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
-
+	swap_alloc_entry(folio);
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
@@ -1944,9 +1903,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * Grab the local lock to be compliant
 			 * with swap table allocation.
 			 */
-			local_lock(&percpu_swap_cluster.lock);
 			offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);
 		}
@@ -2750,28 +2707,6 @@ static void free_cluster_info(struct swap_cluster_info *cluster_info,
 	kvfree(cluster_info);
 }
 
-/*
- * Called after swap device's reference count is dead, so
- * neither scan nor allocation will use it.
- */
-static void flush_percpu_swap_cluster(struct swap_info_struct *si)
-{
-	int cpu, i;
-	struct swap_info_struct **pcp_si;
-
-	for_each_possible_cpu(cpu) {
-		pcp_si = per_cpu_ptr(percpu_swap_cluster.si, cpu);
-		/*
-		 * Invalidate the percpu swap cluster cache, si->users
-		 * is dead, so no new user will point to it, just flush
-		 * any existing user.
-		 */
-		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cmpxchg(&pcp_si[i], si, NULL);
-	}
-}
-
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -2855,7 +2790,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
-	flush_percpu_swap_cluster(p);
 
 	destroy_swap_extents(p);
 	if (p->flags & SWP_CONTINUED)
@@ -2884,6 +2818,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
+	free_percpu(p->percpu_cluster);
+	p->percpu_cluster = NULL;
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	vfree(swap_map);
@@ -3267,7 +3203,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	int err = -ENOMEM;
+	int cpu, err = -ENOMEM;
 	unsigned long i;
 
 	cluster_info = kvcalloc(nr_clusters, sizeof(*cluster_info), GFP_KERNEL);
@@ -3277,14 +3213,27 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
-	if (!(si->flags & SWP_SOLIDSTATE)) {
+	if (si->flags & SWP_SOLIDSTATE) {
+		si->percpu_cluster = alloc_percpu(struct percpu_cluster);
+		if (!si->percpu_cluster)
+			goto err;
+
+		for_each_possible_cpu(cpu) {
+			struct percpu_cluster *cluster;
+
+			cluster = per_cpu_ptr(si->percpu_cluster, cpu);
+			for (i = 0; i < SWAP_NR_ORDERS; i++)
+				cluster->next[i] = SWAP_ENTRY_INVALID;
+			local_lock_init(&cluster->lock);
+		}
+	} else {
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
 				     GFP_KERNEL);
 		if (!si->global_cluster)
 			goto err;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
-		spin_lock_init(&si->global_cluster_lock);
+		spin_lock_init(&si->global_cluster->lock);
 	}
 
 	/*
@@ -3565,6 +3514,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
+	free_percpu(si->percpu_cluster);
+	si->percpu_cluster = NULL;
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;
-- 
2.34.1


