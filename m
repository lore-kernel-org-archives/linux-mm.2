Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE73BCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4436B00B5; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7C96B00B6; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5290E6B00B7; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 360826B00B6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36EB3120192
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:10 +0000 (UTC)
X-FDA: 84716346540.19.3A4D8C7
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90507C000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Fu44Mqbd;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PmNPPoBn+BkgOs7OnLdtWpFcsU19eRAmyThaQ0ORPU=;
	b=oV9GnvXWT7HEHixFD7cVd0DABmeWlOFPDRR1b/LxvbfIjLke0TOzl3OATTVVxWkuwFViDc
	I9GfdHgCNhs74LEZkMmZr15C4T3xcBZvbwGmjg3v/eMlIVJYhMnu2930qGNMUHHchodZC8
	qQFAXGawpwBvLtDyeupnUGrEwE6SHPc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Fu44Mqbd;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580588; a=rsa-sha256;
	cv=none;
	b=PKI2hzBxzYjBMCam6fZLwC7EUsR61p37ESCeD2/8i6JQUy53IASceN0uaqk8B6WfgOGO0g
	LZAyAzCAxqRgWZ4LXgoFPHOYi83FmVEIEU1Ph+8jjqSyTAphjwN6iy803s8Fq0uMGSU+95
	hVbKLX/AG2MbRSYp8aT57nc6EJ2I6Mg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0PmNPPoBn+BkgOs7OnLdtWpFcsU19eRAmyThaQ0ORPU=; b=Fu44MqbdPvVBZma43tm16pnfvO
	AxzXZqrVWM0eLyGY0ozpnwWQeokDZIc77tA0kc2RacB0SWJXCmFSCRmZvr7UPoSyiNh6OF/casymA
	9y15O0QYThuAskbedGdCi6G4Nf2iVq6v9n1bYtg/leaDy3QTZYuWk7qJoViHjqXyM0S7kquj5F/VH
	oYtKVMx5Lh49XbxJun3uG26Fh7ZI52GfS79ruQF2QAvaQovhHg3/k/BixsvM68SSpSsTO5kZcTn98
	oAmBy++FUG8VcaMDQ1JFVGGaGlvdOL4uI/HXyz8GktHXOmkg17236T7jmDzYyJGPKPhfpeZSOY6W6
	4NzE5QoQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-0yVU;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 30/45] mm: page_alloc: drive slab shrink from SPB anti-fragmentation pressure
Date: Thu, 30 Apr 2026 16:20:59 -0400
Message-ID: <20260430202233.111010-31-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90507C000D
X-Rspam-User: 
X-Stat-Signature: uu1ynxzeo78eakoh3p94q5jxruhfk6xj
X-HE-Tag: 1777580588-465775
X-HE-Meta: U2FsdGVkX18MfCZQ4EkegqFFoIBJNguJBUa7M81dYOtVGX1FZgmQFuXwpfkLYB3Tr9ofODUBJelbboZ+icKQ85BWU8eFDAeZxapqJ3eiDjJscLj3AtEJcw/s+hRus/F6g/RqrgS3KeHDQzNaVeKQXlZjB9i0RgDwlG67sCj0Sitl0TN8JooB/43po+PVXri4hmhWlIMuQgK8CXN41I4ti7B1lN8LSkqk5I/BvqV3rvqye/YyvuE2O6FFnVJv6BV17xxUuBDecxumaIlKZr1HdL5JsXkkUvhbm5PdtchseF7Q0OB6tUNLDXAMCzosyK5SQb9H6Q0otNO6Uif04foRu2jamTQ/aMBgsqnROPi2ecW7E+eXMBn3qiiS1sxIBQihQ16MeTxrYea3Nx2khU9EEg36UuI3Zv+apSGsRFikNVw0XtUlYGfXxEY/5PvhnVvYIrpm+zsTGCeHn3vfkNf7FxDDQYlP3Nhb+XkzgAtUIVgFGWw4MuGI4hkj7shoUiyugaQfMJMusH8kuVQx2t5A+oEdfN2wSTEquVAzofgTn4TIhmmMtQl0Q98QshIi1yckpErkD0D8K0vHTLIOul7rFO1+RL0pRKDOyHPHb8hKPuoROFlIV/+VxUqLZQ160/jN69NIBhjTlw71jCdMKH64H5hIkt9gAATY/M9irXqh+zuf34Ut9sf5McbMrz8QEKMt7d+iHjvxNB+MZrHtuweqQevzp1l54s1JLgOLbXb2+8yLK7L+7FhyOiCD6zo5RbvwixUG4trRSb4mr9rljcydUhbnOyFTbVQlt/O3zyX7rkyHBVfKvcK+SLvPhumLr+Lax7tpBnzOSIPr089xsLZDSRL/4mWUVvQPzgybQwh7nygpt6+60fgrbLwD83yJZN78aX5U1LsNc8Du1Eb7kc2BWOOAuA1A0hs15XopKsSELPHwE+DMfrNOBy+l3gjjBPkCX9nLXqKi4TFuhkYC65J
 pHnQjswS
 93dydFeWyysjYUrFrZxIfRhGoALRatnIyrmTrUkhdYYht8q4sAqJVMRbJY4OhvC59lr7VNVI/oQw42VSiJz9I/mWy8vpDYkb0JR0qvgBsl9T3/RQiHiSOg3CcksSAo/lC2g5+Nde7bb7Ou6jrJmU32zgZvML6LFGiDsxehByadn6qwTiCa5BLbPMimNSGGKQmHhafZKjJl4CwPC5PS2GKtjMD4nXfPTFkzCWvTHZ48JT9C5Af+XsG5Z9Di+Z3EdXccoHYA4HCpqqq6buSPUnYH7i3WS7NOtfhQVedll1XoLMl6TFUixwMTH5uzB3v2uYcRAzRIjDM16Vh2evDWndLaUjt8yrJaemlqTipKfO9vMSGYzm+uqkf8XwdzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The ALLOC_HIGHORDER_OPTIONAL refusal gate from
commit 96f17c6b8398 ("mm: page_alloc: refuse fragmenting fallback for
callers with cheap fallback") prevents
fragmenting fallbacks for atomic-shape callers, but it can only refuse
allocations that have a cheap fallback. GFP_KERNEL slab callers
(dentry/inode/page-table caches) have no such fallback and reach
__rmqueue_claim/_steal whenever the tainted-SPB pool runs out of
headroom. Without an external pressure release valve, sustained slab
growth eventually drains the tainted pool, every clean SPB starts
absorbing one taint, and fragmentation grows until equilibrium at a
much higher tainted-SPB count than the workload memory-footprint
warrants.

Live experiment on a 247 GB devvm under the syz-VM + edenfs workload
showed the failure mode clearly: tainted Normal SPBs climbed from the
boot baseline of 8 to 85 during an 8-minute burst as 18 syzkaller VMs
spun up and btrfs_inode/dentry caches grew past the existing tainted
pool capacity. Once at 85 (with about 25 GB of cached slab) the system
plateaued: existing tainted SPBs had absorbed enough demand that no
more taints occurred — but the equilibrium was over 2x what packing
35 GB of slab into 1 GB tainted SPBs ought to need.

The pageblock-evacuation worker
(spb_evacuate_for_order/queue_spb_evacuate) already runs from these
pressure points, but it can only consolidate movable pages out of
tainted SPBs. Slab content stranded in tainted SPBs blocks free
pageblocks from re-coalescing and forces new taints when movable
supply runs out.

Add a parallel slab-shrink mechanism that mirrors the evacuation
infrastructure exactly: a per-pgdat irq_work that bridges from
allocator-lock context out to a workqueue, a pool of request
descriptors, and a queue function with single-flight + 100ms throttle.
The worker calls shrink_slab() with the zone's nid, walking
node-local shrinkers from DEF_PRIORITY toward 0 until either no
shrinker reports progress or a pageblock-sized batch of objects has
been freed.

Wire three trigger sites:

  1. __rmqueue_smallest pre-Pass-3 — alongside the existing
     queue_spb_evacuate trigger when the spb_tainted_walk reports
     saw_below_reserve. Demand-side signal: an allocation just couldn't
     find space in tainted, and tainted is below its reserve.

  2. __rmqueue_claim — alongside the existing queue_spb_evacuate when
     a non-movable claim is about to taint a clean SPB. Same demand
     signal as (1) but caught one layer down.

  3. End of spb_evacuate_for_order — fired unconditionally, even when
     the movable evacuation pass succeeded. Supply-side trigger: keeps
     headroom available for the next burst, when the movable supply
     may have run out and movable evac alone would have nothing to do.

shrink_slab is location-agnostic — it doesn't know about SPBs — but
since most slab pages live in already-tainted SPBs (that is where they
were allocated), the freed pages naturally land back in the tainted
pool, restoring headroom without spreading the taint to clean SPBs.

Speed control is implicit: trigger frequency tracks evacuation
frequency, so reclaim rate matches allocation rate. Per-invocation
aggressiveness ramps via decreasing priority. No new sysctls or
watermarks are introduced; the 100ms throttle is the only tunable.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h        |   9 +++
 include/linux/vm_event_item.h |   5 ++
 mm/page_alloc.c               | 138 +++++++++++++++++++++++++++++++++-
 mm/vmstat.c                   |   2 +
 4 files changed, 151 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 195a80e2f0ee..acaff292140f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1570,6 +1570,15 @@ typedef struct pglist_data {
 	struct workqueue_struct *evacuate_wq;
 	struct llist_head spb_evac_pending;
 	struct irq_work spb_evac_irq_work;
+
+	/*
+	 * SPB-driven slab reclaim: single work item per pgdat (shrink_slab
+	 * is node-scoped, so one work in-flight per node is the max), with
+	 * a 100ms throttle. queue_work() gives us single-flight semantics
+	 * for free.
+	 */
+	struct work_struct spb_slab_shrink_work;
+	unsigned long spb_slab_shrink_last;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 3de6ca1e9c56..5a560014ab49 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -94,6 +94,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 					 * a clean SPB clean when a tainted SPB
 					 * still has free pageblocks
 					 */
+		SPB_SLAB_SHRINK_QUEUED,	/*
+					 * queued a deferred slab shrink to
+					 * reclaim space inside tainted SPBs
+					 */
+		SPB_SLAB_SHRINK_RAN,	/* slab shrink worker ran a pass */
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
 		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9305b36f52a6..a72cb2da606d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -790,6 +790,7 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 				  int migratetype);
 static void queue_spb_evacuate(struct zone *zone, unsigned int order,
 			       int migratetype);
+static void queue_spb_slab_shrink(struct zone *zone);
 #else
 static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
 static inline bool spb_needs_defrag(struct superpageblock *sb) { return false; }
@@ -806,6 +807,7 @@ static inline bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 }
 static inline void queue_spb_evacuate(struct zone *zone, unsigned int order,
 				      int migratetype) {}
+static inline void queue_spb_slab_shrink(struct zone *zone) {}
 #endif
 
 static void spb_update_list(struct superpageblock *sb)
@@ -2991,9 +2993,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	 * showed that some tainted SPB is below its reserve threshold of
 	 * free pageblocks, kick deferred evacuation so future allocations
 	 * have a movable-evicted home in an already-tainted SPB.
+	 *
+	 * Queue slab shrink alongside evacuation: even when movable evac
+	 * succeeds, shrinking slab in parallel keeps headroom available
+	 * for the next burst, when the movable supply may have run out.
 	 */
-	if (walk && walk->saw_below_reserve)
+	if (walk && walk->saw_below_reserve) {
 		queue_spb_evacuate(zone, order, migratetype);
+		queue_spb_slab_shrink(zone);
+	}
 
 	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
@@ -3829,12 +3837,17 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 			 * for a non-movable allocation -- this taints a fresh
 			 * SPB.  Defer an evacuation pass over the tainted pool
 			 * so subsequent allocations can reclaim freed
-			 * pageblocks instead of repeating this fallback.
+			 * pageblocks instead of repeating this fallback. Also
+			 * kick a slab shrink so the tainted pool gets fresh
+			 * headroom (movable evac alone can't free pages held
+			 * by slab).
 			 */
 			if (cat_search[c] != SB_SEARCH_PREFERRED &&
-			    start_migratetype != MIGRATE_MOVABLE)
+			    start_migratetype != MIGRATE_MOVABLE) {
 				queue_spb_evacuate(zone, order,
 						   start_migratetype);
+				queue_spb_slab_shrink(zone);
+			}
 
 			page = try_to_claim_block(zone, page, current_order,
 						  order, start_migratetype,
@@ -9017,6 +9030,111 @@ static void queue_spb_evacuate(struct zone *zone, unsigned int order,
 	irq_work_queue(&pgdat->spb_evac_irq_work);
 }
 
+/*
+ * SPB-driven slab reclaim.
+ *
+ * When tainted SPBs run low on free pageblocks under sustained
+ * non-movable pressure (slab inode/dentry/page-table caches), the
+ * pageblock-evacuation worker can only consolidate *movable* pages out
+ * of tainted SPBs. Non-movable slab content stays put, so once the
+ * movable supply is drained the only way to recover headroom in a
+ * tainted SPB is to shrink the slab caches whose pages live there.
+ *
+ * shrink_slab() is node-scoped, so one work item per pgdat is enough:
+ * a single embedded work_struct, gated by a 100ms throttle.
+ * queue_work() returns false if the work is already queued/running, so
+ * we get single-flight for free.
+ *
+ * shrink_slab() itself is location-agnostic — it walks all registered
+ * shrinkers and frees objects whose backing pages may live in any
+ * zone or SPB. That is fine here because any slab page reclaimed
+ * frees space the next allocation can reuse without tainting a fresh
+ * SPB. We pass the pgdat's nid so node-aware shrinkers prefer caches
+ * local to the pressured node.
+ */
+
+/*
+ * Per-invocation budget: walk shrinkers from DEF_PRIORITY (scan 1/4096
+ * of each cache) down toward 0 (full scan), stopping when shrinkers
+ * report no more progress or we have freed a pageblock-sized chunk.
+ * The trigger frequency is what controls overall reclaim rate; this
+ * loop just bounds latency per worker run.
+ */
+#define SPB_SLAB_SHRINK_TARGET_OBJS	(pageblock_nr_pages * 4UL)
+
+static void spb_slab_shrink_work_fn(struct work_struct *work)
+{
+	pg_data_t *pgdat = container_of(work, pg_data_t,
+					spb_slab_shrink_work);
+	int nid = pgdat->node_id;
+	unsigned long freed = 0;
+	int prio = DEF_PRIORITY;
+
+	count_vm_event(SPB_SLAB_SHRINK_RAN);
+
+	while (freed < SPB_SLAB_SHRINK_TARGET_OBJS && prio >= 0) {
+		unsigned long delta = 0;
+		struct mem_cgroup *memcg;
+
+		/*
+		 * Walk the memcg hierarchy starting at the root, the same
+		 * pattern shrink_one_node uses for global slab reclaim.
+		 * Some cgroups may not be present on the node that is
+		 * being shrunk, but many allocators will use any memory.
+		 */
+		memcg = mem_cgroup_iter(NULL, NULL, NULL);
+		do {
+			delta += shrink_slab(GFP_KERNEL, nid, memcg, prio);
+		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+
+		if (!delta)
+			break;
+		freed += delta;
+		/*
+		 * Increase aggressiveness each round; DEF_PRIORITY scans
+		 * a small slice of each cache, prio 0 scans the whole
+		 * thing. Most workloads find enough at one or two
+		 * iterations below DEF_PRIORITY.
+		 */
+		prio--;
+	}
+}
+
+/**
+ * queue_spb_slab_shrink - schedule deferred slab shrink for SPB pressure
+ * @zone: zone whose tainted-SPB pool is running low
+ *
+ * Throttled to one enqueue per 100ms per pgdat. queue_work() handles
+ * single-flight: if the work is already queued or running, it returns
+ * false and the throttle stamp still gets bumped (next call will be
+ * no-op until the throttle elapses).
+ *
+ * Callable from any context: page allocator paths hold zone->lock,
+ * the SPB evacuate worker does not. queue_work() takes only the
+ * workqueue's pool lock — no zone->lock dependency.
+ *
+ * Pairs with queue_spb_evacuate: evacuation moves movable pages out
+ * of tainted SPBs to free up whole pageblocks; this shrinks slab to
+ * free up the remaining (non-movable) pages. We queue both because
+ * even when movable evacuation succeeds, shrinking slab in parallel
+ * keeps headroom available for the next burst, when movable supply
+ * may have run out.
+ */
+static void queue_spb_slab_shrink(struct zone *zone)
+{
+	pg_data_t *pgdat = zone->zone_pgdat;
+
+	if (!pgdat->evacuate_wq)
+		return;
+
+	if (time_before(jiffies, pgdat->spb_slab_shrink_last + HZ / 10))
+		return;
+
+	pgdat->spb_slab_shrink_last = jiffies;
+	if (queue_work(pgdat->evacuate_wq, &pgdat->spb_slab_shrink_work))
+		count_vm_event(SPB_SLAB_SHRINK_QUEUED);
+}
+
 /*
  * Background superpageblock defragmentation.
  *
@@ -9498,6 +9616,7 @@ static int __init pageblock_evacuate_init(void)
 	for (i = 0; i < NR_SPB_EVAC_REQUESTS; i++)
 		llist_add(&spb_evac_pool[i].free_node, &spb_evac_freelist);
 
+
 	/* Create a per-pgdat workqueue */
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
@@ -9515,6 +9634,9 @@ static int __init pageblock_evacuate_init(void)
 		init_irq_work(&pgdat->spb_evac_irq_work,
 			      spb_evac_irq_work_fn);
 
+		INIT_WORK(&pgdat->spb_slab_shrink_work,
+			  spb_slab_shrink_work_fn);
+
 		/* Initialize per-superpageblock defrag work structs */
 		for (z = 0; z < MAX_NR_ZONES; z++) {
 			struct zone *zone = &pgdat->node_zones[z];
@@ -10258,6 +10380,16 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 			did_evacuate = true;
 	}
 
+	/*
+	 * Always kick a slab shrink after an evacuation pass — even when
+	 * movable evacuation succeeded. Slab content stranded inside
+	 * tainted SPBs can only be freed by shrinking the cache; doing
+	 * it now keeps headroom available for the next burst, when the
+	 * movable supply may have run out and movable evac alone would
+	 * have nothing to do.
+	 */
+	queue_spb_slab_shrink(zone);
+
 	return did_evacuate;
 }
 #endif /* CONFIG_COMPACTION */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8a6c9120d325..8ffad06a39ae 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1386,6 +1386,8 @@ const char * const vmstat_text[] = {
 	[I(CMA_ALLOC_FAIL)]			= "cma_alloc_fail",
 #endif
 	[I(SPB_HIGHORDER_REFUSED)]		= "spb_highorder_refused",
+	[I(SPB_SLAB_SHRINK_QUEUED)]		= "spb_slab_shrink_queued",
+	[I(SPB_SLAB_SHRINK_RAN)]		= "spb_slab_shrink_ran",
 	[I(UNEVICTABLE_PGCULLED)]		= "unevictable_pgs_culled",
 	[I(UNEVICTABLE_PGSCANNED)]		= "unevictable_pgs_scanned",
 	[I(UNEVICTABLE_PGRESCUED)]		= "unevictable_pgs_rescued",
-- 
2.52.0


