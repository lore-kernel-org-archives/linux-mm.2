Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27FC606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rUz1yfxi
Received: by kanga.kvack.org (Postfix)
	id BF7C56B05DA; Mon,  9 Nov 2026 00:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF7C6B05DB; Mon,  9 Nov 2026 00:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0426B05DC; Mon,  9 Nov 2026 00:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75ED06B05DA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F25341205B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:31 +0000 (UTC)
X-FDA: 85414523502.20.84714F7
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf22.hostedemail.com (Postfix) with ESMTP id F40DBC0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rUz1yfxi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203850;
	b=wELLxHddSAcY3BwrRipNb8xOfrqRjdnezfvzYdLA4d+dE0yoMY+RLjU+gucF5w4w5Zi9s7
	5N8htMB4fVscSUGps1uyS5Aqe3/jmoRiVHTEJcM40WsksytSiiCEZ4gcJnR18pJZrJNPOx
	YiVzvFfJ47638Ll5orJxauG1xhQB22o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnOjQkGf+OqWoHyBwhap7n6DhGg6k/m4omFdcfbHAMc=;
	b=7+jx9LC7ehG6JkbYTgLpT9eQUFr6JgruutWiTiZ0+CNzOds5XjX9atr85sS3HLZ2WQwmpc
	rFVrFShNllCrW+db+MLiPQviZxOkxkS0Bd8LUdjwWGEmx4qCNNUQQagPLMxcGqdBU9xZry
	LV87p5qVUFqllmat3+GsMq9NPm6ceGA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rUz1yfxi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SvxFMe5L6XVKLRk84yM/lIlWCQm7moIqgkfiHpPq+OI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203848; v=1; x=1794808648;
 b=rUz1yfxiGKy2+cjIw13wXGuOyZMAr0JxZ9wRZZ1pV0LI3ufyD2JRJIrf15/jxYQjI9o+PAGF
 dbmdqFO4BBjvNuzZc1HYHq+EGBLBleskGr9/f9tbwyfv1XDEjfJY5VwPD8UhICRi1rRst7v4JSH
 v9ANynbc6WOx9ey0kdaDVYKc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 58a4f13153733a38;
	Mon, 09 Nov 2026 05:57:28 +0000
X-Mizu-Trace-ID: 58a4f13153733a38
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
Subject: [PATCH v5 17/19] mm, swap: add xswap shrink trigger and defer it to a workqueue
Date: Mon,  9 Nov 2026 13:54:53 +0800
Message-ID: <20261109055455.536925-18-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F40DBC0003
X-Rspamd-Server: rspam12
X-Stat-Signature: 8tk5ktf1z5o8s3zzhime6guw8ykjaw6h
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203849-540370
X-HE-Meta: U2FsdGVkX18CwMPjn7ZQcEJXGJsYc6PZUh2LMgzJGfyY1mlWUGk0A4vReT+M/xsWcAl+bBJICUEBCDzZSkDOHpKH6gt7yxQd8YYnKOP8QeMJTFSTzTnMg/PWbAqmoIIBiU9B0qcNMT9etdbKNiuy0aPPVGBetbx5nuK9UP4X5CqxxgVJheNE87V5BxCfenjmAvJtWgFgpwCu+Zo59khfJqO4z80Q33qkqFl/lWghb3UAP4IBgZhZVioWWG+kp2ZHIxafQjCpHDHBGy2bXhFPWmndsHOiW9ABYWc++lamhaVTSsHuRKpkm51JuqoCzrj5jdmi/KOWQ/SKp4N2ECu4vCk4NurQgmc+CJEPm8UQNDFAMHrUsA/9KMOUIMQt+34r/cFct3ZMpjjcU0uFhWGTT3A+ONbVC5/VNh1GXQj7LZbJ7c8kucn7XXcO5nS/JJwwtl9sPQhXYKSi1GCa+gHZE9MEJddQ0FDbU5a81hQaFjfJ9qUUwYjDDL/EWz/fgjTj2vXkqO3HxizzMJdiaElnfL7uJMo0pTtCo0sjlp2vuPHKOpZH5sIOfD8bBfEruRKeqEJghCFwpMF/Z6+3W+UoK1r9ls62PbArAxiCLxObotc+UjuNMpyC278YRxKoBXMzgoGYEHxfYo+1mDpSqUaAn/rnN4htc6WzlI+6JeCeRWEKx40s6tg6i3W2O0Q5SWJjJ+TigBwocExWIOCzqSIa9qg07weB/PZqchM/YsmoOtRcCug/YEKgqxVihVbSSKFTskBt+9tqjKQnNiWVteef9xCGpuYxYScjXkCVcW2WIFTqLeS/dPj7RWu39CupRcYd8fK4jj9PvyroH8v+HGf8faU05CtpISTSWJ1q7yQQ5nTPHFsqe53QSFt/DPP2ZEE0MH7OYVBGw+zVdfEt7ZXQazPSIN7OlIWOppYSPq3lya3C5xyuilmNPMWhGW59rvfICmZk2ML4qqz50bxD3bw
 l5lOhrb3
 lgbSPnVYuL4nJbSU+A8oxJ/bF1S8KFrQOOBtPuEDPuVAJOu+PGP8riMGoH6gf6AGMWCCKrRxCI4v+IMCOIu0jHI/xGRfXAfTrKIy5zYJdcMFpiKvsWFoxJ2nNxwDM38QceTchuHlmwAhdKhF7cQkqApk62Pqskq7BCQqi/GqBX1WixiU5LcX17keAKwLaRZgnwsbCiQe7r2Skgn6SkCW0FZ28x+BwyShIfv3V9LeTI48WEHNoP8M4mkcyNJpYVBibuKG4lfgK9DtYShn58TJumioKWI0hrNUNzhydHpvzoE/366zkICX0O/tQkhejuYcKW360YuHYrKT/06qHbM4jj/EOxD+ATgBVGQHj7tuHGJsnFssBLoOw2bTJSRFGAXXfaUPmRwm1Rjb50M0BgjlGYQYCQ8RmO7/12FnRpf8OPSo0teOLvSK0o0Y+JSmn7KZzG/LUvjuDVxqd1TvwfzkCx6YNxv7ZItzmzI2q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

The shrink cannot run directly from __free_cluster(), because that path
holds ci->lock.  xswap_try_shrink() takes xswap_lock and can sleep in
synchronize_rcu() and vm_area_unmap_pages().  __free_cluster() schedules
xswap_shrink_work instead, and teardown disables the work.

The shrink unmaps the free tail of the cluster_info mapping.  It costs
two RCU grace periods: one after draining the per-CPU cache and before
the tail is rechecked, and one inside the unmap helper.  The second one
is needed because a cluster can be allocated and freed between the
recheck and the unmap, and go back into the per-CPU cache.  xswap devices
are SWP_SOLIDSTATE, so the per-CPU cache is the only one that needs
draining.

The unmap helper takes a wait flag.  The shrink passes true.  Teardown
passes false because __swapoff() has already drained and waited.  The
create failure path also passes false because it has no readers.

Count shrink operations in xswap_shrinks.  Initialize the work in
xswap_create() so free_swap_cluster_info() can always call
disable_work_sync().  Using disable_work_sync() instead of only
cancel_work_sync() also rejects a schedule that read SWP_WRITEOK just
before swapoff.  Then no work stays pending when the swap_info is reused
and INIT_WORK() runs again.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 233 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 211 insertions(+), 23 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 29623c5138ab..1e552a8b421b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -247,6 +247,7 @@ struct swap_info_struct {
 	u64			xswap_id;	/* stable id, shown to userspace */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 	struct dentry		*xswap_debugfs;	/* mapped range and counters */
 	atomic_long_t		xswap_grows;	/* grow operations so far */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 097ed288b1ca..2e5383036fdc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -66,12 +66,13 @@
 
 #ifdef CONFIG_XSWAP
 /*
- * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
+ * xswap: dynamically grow and shrink the cluster_info array via a
+ * VM_SPARSE area.
  *
- * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
- * operation.  It is set to the number of cluster_info structs that
- * fit in a single page (at least 16), so that the vmalloc page table
- * overhead is proportional to the number of clusters mapped.
+ * XSWAP_GROW_CLUSTERS is the number of clusters to map/unmap in one
+ * grow/shrink operation: the number of cluster_info structs that fit in
+ * a single page (at least 16), so that the vmalloc page table overhead
+ * is proportional to the number of clusters mapped.
  */
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
@@ -82,6 +83,14 @@
 	max_t(unsigned long,						\
 	      ((XSWAP_UNMAP_BATCH_PAGES * PAGE_SIZE) /		\
 	       sizeof(struct swap_cluster_info)), 16)
+/*
+ * Shrink thresholds, as a percentage of the mapped range in use.  The stop
+ * point sits inside (SHRINK_WHEN, GROW_WHEN), so shrinking cannot leave the
+ * range in a state that wakes the grow up.
+ */
+#define XSWAP_SHRINK_WHEN	50
+#define XSWAP_SHRINK_UNTIL	70
+
 /*
  * Grow thresholds, as a percentage of the mapped range in use.  The target
  * sits above the point where the shrink starts looking (50%) and below the
@@ -100,6 +109,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
+static void xswap_try_shrink(struct swap_info_struct *si);
 
 static int xswap_create(int prio);
 static int xswap_destroy(u64 id);
@@ -866,6 +876,16 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	/*
+	 * Only xswap devices, and not while the device is being torn down.
+	 * A racing swapoff can still clear SWP_WRITEOK after this check;
+	 * the work function checks it again, so a late schedule is benign.
+	 */
+	if ((READ_ONCE(si->flags) & (SWP_XSWAP | SWP_WRITEOK)) ==
+	    (SWP_XSWAP | SWP_WRITEOK))
+		schedule_work(&si->xswap_shrink_work);
+#endif
 }
 
 /*
@@ -3515,6 +3535,8 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 	if (si->flags & SWP_XSWAP) {
 		unsigned long nr_mapped;
 
+		/* A late schedule must not be pending when the work is reinitialized. */
+		disable_work_sync(&si->xswap_shrink_work);
 		/*
 		 * Cluster 0 keeps the bad header slot, so it never empties
 		 * and __free_cluster() never frees its table.
@@ -3560,8 +3582,10 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 }
 
 /*
- * Called after swap device's reference count is dead, so
- * neither scan nor allocation will use it.
+ * Invalidate the per-cpu cluster cache for @si.  A caller that has not
+ * already killed @si->users and waited must follow with synchronize_rcu()
+ * before unmapping cluster_info, since a reader may already have loaded
+ * a cached offset.
  */
 static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 {
@@ -3570,11 +3594,7 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 
 	for_each_possible_cpu(cpu) {
 		pcp_si = per_cpu_ptr(percpu_swap_cluster.si, cpu);
-		/*
-		 * Invalidate the per-cpu swap cluster cache.  Any reader that
-		 * has already loaded an entry is waited out by the caller's
-		 * synchronize_rcu().
-		 */
+		/* Invalidate the per-cpu swap cluster cache for @si. */
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			cmpxchg(&pcp_si[i], si, NULL);
 	}
@@ -3681,6 +3701,15 @@ static int __swapoff(struct swap_info_struct *p)
 	struct file *swap_file = NULL;
 	int err;
 
+#ifdef CONFIG_XSWAP
+	if (p->flags & SWP_XSWAP) {
+		cancel_work_sync(&p->xswap_shrink_work);
+		/* Wait out a shrink racing us from the sysfs write path. */
+		mutex_lock(&p->xswap_lock);
+		mutex_unlock(&p->xswap_lock);
+	}
+#endif
+
 	wait_for_allocation(p);
 
 	set_current_oom_origin();
@@ -4317,9 +4346,13 @@ static unsigned long xswap_grow(struct swap_info_struct *si)
 	return nr_new;
 }
 
-/* Caller must hold si->xswap_lock.  Cannot fail. */
+/*
+ * Caller must hold si->xswap_lock.  Cannot fail.  @wait drains the per-cpu
+ * cluster cache and waits one RCU grace period before unmapping.
+ */
 static void xswap_unmap_clusters_locked(struct swap_info_struct *si,
-					unsigned long start_idx, unsigned long nr)
+					unsigned long start_idx, unsigned long nr,
+					bool wait)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
 				   (size_t)start_idx * sizeof(struct swap_cluster_info);
@@ -4348,14 +4381,16 @@ static void xswap_unmap_clusters_locked(struct swap_info_struct *si,
 		return;
 	}
 
-	/*
-	 * A per-cpu cluster cache can still hold an offset in this range.
-	 * Invalidate those references, then wait out the readers that have
-	 * already loaded one, so that nobody can dereference cluster_info
-	 * past this point.  swapoff() needs the same before it releases.
-	 */
-	flush_percpu_swap_cluster(si);
-	synchronize_rcu();
+	if (wait) {
+		/*
+		 * A per-cpu cluster cache can still hold an offset in this
+		 * range.  Invalidate those references, then wait out the
+		 * readers that have already loaded one, so that nobody can
+		 * dereference cluster_info past this point.
+		 */
+		flush_percpu_swap_cluster(si);
+		synchronize_rcu();
+	}
 
 	npages = (vm_end - vm_start) >> PAGE_SHIFT;
 
@@ -4398,7 +4433,11 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr)
 {
 	mutex_lock(&si->xswap_lock);
-	xswap_unmap_clusters_locked(si, start_idx, nr);
+	/*
+	 * The teardown caller has already drained and waited in __swapoff();
+	 * the create failure path has no readers.
+	 */
+	xswap_unmap_clusters_locked(si, start_idx, nr, false);
 	mutex_unlock(&si->xswap_lock);
 }
 
@@ -4413,6 +4452,153 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
 	*mapped_end = addr + PAGE_SIZE;
 	return 0;
 }
+
+/*
+ * Automatic reclaim: leave one chunk of the free tail mapped as slack, so
+ * that the next allocation has somewhere to land, and only unmap once
+ * several chunks can go, so the unmap is worth the two RCU grace periods
+ * it costs.
+ */
+#define XSWAP_SHRINK_SLACK	XSWAP_GROW_CLUSTERS
+#define XSWAP_SHRINK_MIN	(XSWAP_GROW_CLUSTERS * 8)
+
+static void xswap_shrink_work_fn(struct work_struct *work)
+{
+	struct swap_info_struct *si = container_of(work,
+			struct swap_info_struct, xswap_shrink_work);
+
+	if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+		return;
+	xswap_try_shrink(si);
+}
+
+/*
+ * Try to shrink the cluster_info tail: unmap contiguous free clusters
+ * at the end of the mapped range.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	struct swap_cluster_info *ci;
+	unsigned long nr_mapped, nr_tail, keep, nr_unmap, start_idx, i;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+
+	mutex_lock(&si->xswap_lock);
+
+	/* A swapoff raced us and is about to walk this mapping. */
+	if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+		goto out_unlock;
+
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	if (nr_mapped <= 1)	/* keep cluster 0 */
+		goto out_unlock;
+
+	/*
+	 * Reclaim on our own, but only once the mapped range is at most
+	 * SHRINK_WHEN in use: growth is demand driven, so reclaiming on a
+	 * smaller dip would only map the same clusters again, and every
+	 * unmap costs two RCU grace periods.
+	 */
+	if (swap_usage_in_pages(si) * 100 >
+	    nr_mapped * SWAPFILE_CLUSTER * XSWAP_SHRINK_WHEN)
+		goto out_unlock;
+
+	/*
+	 * Count the free clusters at the tail of the mapped range.  Scanned,
+	 * not tracked: the count must be exact to size the unmap, and an
+	 * incremental count falls behind on out-of-order frees.
+	 */
+	nr_tail = 0;
+	while (nr_mapped - nr_tail > 1) {
+		ci = &si->cluster_info[nr_mapped - nr_tail - 1];
+		if (READ_ONCE(ci->count) ||
+		    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
+			break;
+		nr_tail++;
+	}
+	if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
+		goto out_unlock;
+
+	/*
+	 * Stop at SHRINK_UNTIL rather than at the end of the tail, or the
+	 * range comes out full enough for the grow to be woken.  Below the
+	 * tail everything stays mapped, and one chunk of tail with it.
+	 */
+	keep = DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
+			    XSWAP_SHRINK_UNTIL * SWAPFILE_CLUSTER);
+	if (keep < nr_mapped - nr_tail + XSWAP_SHRINK_SLACK)
+		keep = nr_mapped - nr_tail + XSWAP_SHRINK_SLACK;
+
+	if (nr_mapped < keep + XSWAP_SHRINK_MIN)
+		goto out_unlock;
+
+	nr_unmap = rounddown(nr_mapped - keep, XSWAP_GROW_CLUSTERS);
+	if (!nr_unmap)
+		goto out_unlock;
+	start_idx = nr_mapped - nr_unmap;
+
+	/*
+	 * An allocation can enter a cluster from the per-cpu cache without
+	 * going through the lists, so drain the cache first.  xswap devices
+	 * are SWP_SOLIDSTATE, so the per-cpu cache is the only cache.  Only
+	 * then do the checks below hold: a cluster taken from a list takes
+	 * si->lock, which is what the check holds.
+	 *
+	 * The unmap helper below drains the cache and waits again: a cluster
+	 * can be taken and freed between this recheck and the unmap, putting
+	 * it back in the per-cpu cache.
+	 */
+	flush_percpu_swap_cluster(si);
+	synchronize_rcu();
+
+	/*
+	 * Only shrink a run that reaches the mapped end; otherwise
+	 * truncating nr_clusters_mapped would orphan the active tail.
+	 * move_cluster() takes si->lock under ci->lock, so ci->lock is
+	 * taken with trylock here to avoid the reverse order.
+	 *
+	 * With si->lock held, the writes below need no ci->lock: a FREE
+	 * cluster leaves the free list only in isolate_lock_cluster(),
+	 * every move_cluster() caller holds ci->lock (the trylock above
+	 * catches one), a FREE cluster's count is 0 and only falls, and
+	 * the drained cache holds no FREE cluster.
+	 */
+	spin_lock(&si->lock);
+	for (i = start_idx; i < nr_mapped; i++) {
+		ci = &si->cluster_info[i];
+		if (READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
+			break;
+		if (!spin_trylock(&ci->lock)) {
+			spin_unlock(&si->lock);
+			goto out_unlock;
+		}
+		spin_unlock(&ci->lock);
+	}
+	if (i != nr_mapped) {
+		spin_unlock(&si->lock);
+		goto out_unlock;
+	}
+
+	for (i = start_idx; i < nr_mapped; i++) {
+		ci = &si->cluster_info[i];
+		list_del_init(&ci->list);
+		WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
+	}
+	spin_unlock(&si->lock);
+
+	/*
+	 * A cluster can be taken and freed between the recheck above and the
+	 * unmap, putting it back in the per-cpu cache.  Drain and wait again.
+	 */
+	xswap_unmap_clusters_locked(si, start_idx, nr_unmap, true);
+	atomic_long_inc(&si->xswap_shrinks);
+
+out_unlock:
+	mutex_unlock(&si->xswap_lock);
+}
+
+/* Not an interface: how far the mapped range has moved, for testing. */
 static ssize_t xswap_debugfs_read(struct file *file, char __user *buf,
 				  size_t count, loff_t *ppos)
 {
@@ -4674,6 +4860,7 @@ static int xswap_create(int prio)
 
 	INIT_WORK(&si->discard_work, swap_discard_work);
 	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
+	INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 
 	/* Cluster-aligned, so no cluster holds a slot past si->max. */
 	maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
-- 
2.54.0


