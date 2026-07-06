Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7774C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34556B00A1; Mon,  6 Jul 2026 08:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4FE6B00BF; Mon,  6 Jul 2026 08:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD146B00C0; Mon,  6 Jul 2026 08:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72FBB6B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:30:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBCAAC1FBC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:30:10 +0000 (UTC)
X-FDA: 84958284180.24.23E04D9
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf23.hostedemail.com (Postfix) with ESMTP id D87BC140009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:30:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KyjCfUEN;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783341009;
	b=kBOl+AqMB9IVwGw296TmwfkTo7PEDdB0gC1IPkM9hljr3clHuOx4wb3vp7mswsMW61McgO
	FM4+tGu9m1EHDoNwkDoxqrdvZK1YWDDMsjf7tMpwU5scYyJ3Q+RVse/EqAt9IgVjqy9ydi
	nyizSyVijxGUI9jDk4fUTXAP67T6vl0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KyjCfUEN;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783341009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwpWL13umWWq1oBS96uhWgzcc1jW1yQ90AlZ0npNfAM=;
	b=6yRPP3GqusenIN7yoAtFp6ifPVTcWIcUXb7G0pZWHWe1Kh0qVXbgUix1LW8NyAWBesL3tb
	ie93RuYm8omQskMybhvOZL7NubDoqY7Gv+7CBWjojUyp/SSUCCciE9DOm1HKndRDzJ4kT9
	oAq877Vi9VjAJgxxzDsMvJWB2t5m4rA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783341006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kwpWL13umWWq1oBS96uhWgzcc1jW1yQ90AlZ0npNfAM=;
	b=KyjCfUENI+peTJMPak9YYu+iyti8hLKje28TF/FYcAYPs/IcUNIbHs+nRWUciJV5YNs4gU
	Lmx6pHC6Sk8ozVEk147GI3tK7V7tmsK8lZRsub/PP/qk7rAeEGJeGIV2ggKen6/5xhAe84
	LAGzioMYh5ZRrNTSVuN8lYs4VHmC78Q=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/1] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon,  6 Jul 2026 05:28:26 -0700
Message-ID: <20260706122954.3552990-2-usama.arif@linux.dev>
In-Reply-To: <20260706122954.3552990-1-usama.arif@linux.dev>
References: <20260706122954.3552990-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D87BC140009
X-Stat-Signature: dtc8r1kewm76zt56u9o6y3b7tyxbf6wa
X-HE-Tag: 1783341008-279444
X-HE-Meta: U2FsdGVkX1/yJtQwG+SxGP9XkjULAkoMmWIc2t6H6lvy7MxMbcHCFzAqyRvpj95p3yGL1MP5rWhfXkSgfqvKutke60frABdv6POyiiPmqrGKuYx4ILvRu0lKDjKsi+3x5D2VAljf+4HmcSumjXxjefZe69OvDM7FS9P5b+6I342L5YtIXvtHzwWCAqEopOZc0NGUIyqryEfQG2PAQfrLtU9EHUHZhr39LV4BET+dHxpJCjSShOPkVxYjvzVb3PhOtXonpcX9KA3igdCrwMq7k/3Ph/7TK5O0b1BVzjdSYI4V+IwvgQJWjAydnQ1XAXW1s9AON7s5wyN8MCh5GF6q+0ejIlz7SZ13G/0OBWBMOZ/sWelxQ1nyEL9BD6jXpgBIxfOSvfkCCvGGngPPg9lXJmUVQa+Pevik7MKFe9wauUNeOacDULJC3kOzcLD+kUP4e5v74dnKFCII1gq9HVqFbRlLwhLAFHmgZNTilH8MyjfyOOxTt7PZcPMSKFiIjm2yFbaBRZ/LLWKtAy3zlAoJVKr2aHTLu17K/sHLIdICFIXRZIoaAi6W6g6CDHA+BkFr/qavTAYSEOMIOCEOHkK0cukSwOEwelyKvjYUpVDFR8gb0HZWy03KQIsKp17QoBHHXggmDmjFsP9vXw5+5BNJq2xyXLiMkbF760DnO5HtRqdXeveqEmpy9gW+vOW3mshk5d/o1Ct3Rije/uE6AZbCLBIhb+5fUjgbwwm/1JOLiQtCDAXBHUN4/Dw77e3E9Xr/1I9RKizMhDNDQhl1AxEHnBVkJVO9vPJPW9UwYSyfQh/Y4LCyRhT0PHqbsZx+IhXNoItxru/MHkuSIRHkRRuowhPJxNIi4n1y76ZVCX9txWUKufCPEZDdSGTyENIPbbzbN8C3eOkjKkr62cc2GlI494fola12BCZUlMz6uQ36+uytD8ARFrz+1vjjt33Um2g3icIEQ9/jprQgTBkJ+iG
 omKOQ4HF
 9cUiyDAfQ8WDsmeshCsG7yRq4pw7jb6Whk/6kaM/C9RUC2cqr4mJrmbBq3vc2s8WZU+1jMxMgKx7gvq/BCUyZ+DWeFwr/3l2HaxbGhtSJuD/rnpdhG8y+DgtuzjxvOgOQNEg78rhRxUSHN2aONClvfT/Q9+UckNyOAwdcc0epQxEhksLd6x+GpxSnM0EG8MKQvRmMiOKZz0iwAcNMS9K+nU4s821Vpd9vWYzYcGNPi2hXv3UvxsZovRJPMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anon/file scan balance in get_scan_count() is driven by two scalars
in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
producer under lruvec->lru_lock. The acquisition sites for cost work
specifically are:

  - shrink_inactive_list() re-takes lru_lock at function exit purely
    to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
    nr_reclaimed). One acquisition per inactive shrink.
  - shrink_active_list() does the same with (0, nr_rotated). One
    acquisition per active shrink.
  - workingset_refault() takes the lock via folio_lruvec_lock_irq()
    purely to record the refault cost. One acquisition per refault.
  - prepare_scan_control() takes lru_lock just to snapshot the two
    scalars into sc->{anon,file}_cost.
  - lru_note_cost_unlock_irq() itself walks parent_lruvec and
    re-acquires lru_lock on each ancestor to propagate the update,
    adding O(memcg-depth) acquisitions per producer call.

This hurts because lru_lock is already a heavy contention point on
memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
and folio_add_lru() takes it. The cost work itself is trivial (two
scalar bumps and one comparison), but it contends with and causes
contention for actual LRU manipulation. The parent_lruvec() walk also
multiplies cost-update overhead by memcg hierarchy depth.

Replace the producer-side accumulators with a read-side accumulator fed
from per-LRU vmstat counters. The old producer formula was:

  cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated

Add explicit node_stat counters for the producer-local inputs:

  PGRECLAIM_PAGEOUT_{ANON,FILE} - reclaim-driven pageout submissions
                                  (formerly stat.nr_pageout, weighted
                                  by SWAP_CLUSTER_MAX).
  PGROTATE_{ANON,FILE}          - reclaim-driven rotations, bumped from
                                  both shrink_inactive_list (by
                                  nr_scanned - nr_reclaimed) and
                                  shrink_active_list (by nr_rotated),
                                  unweighted.

WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
lru_note_cost_refault() used to bill.

In prepare_scan_control() the raw cost signal is recomputed lock-free of
lru_lock from monotonic counters:

  now = (PGRECLAIM_PAGEOUT_X + WORKINGSET_RESTORE_X) * SWAP_CLUSTER_MAX
        + PGROTATE_X

The delta against a per-lruvec prev_cost[] snapshot is folded into
cost_accum[]. Since one vmstat delta can cover many producer events
between reclaim passes, halve cost_accum[] until the total is back
within the lrusize/4 bound instead of halving only once.

Moving accumulation and decay to the reclaim side also improves the cost
model across reclaim gaps. With producer-side decay, events that happen
while reclaim is idle still age each other before reclaim ever samples
the costs. If a workload refaults a large anon set and then a smaller
file set before reclaim runs again, the later file activity can age the
earlier anon activity out of the cost model. The new scheme observes the
whole between-reclaim delta and decays anon and file proportionally, so
the scan-balance history better represents what happened since the last
reclaim pass.

A dedicated per-lruvec spinlock, cost_lock, serialises the prev_cost
RMW, the accumulator update, and the halving check against concurrent
reclaimers in the same memcg+node.

Hierarchy aggregation is now implicit in the vmstat accounting. The
producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
existed only because anon_cost/file_cost were private lruvec fields. With
the cost expressed as lruvec vmstats, rstat propagates the underlying
counters through the memcg hierarchy and prepare_scan_control() consumes
the same ratelimited rstat view as the surrounding reclaim heuristics.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/mmzone.h | 11 +++++--
 include/linux/swap.h   |  3 --
 mm/memcontrol-v1.c     |  4 +--
 mm/memcontrol.c        |  4 +++
 mm/mmzone.c            |  1 +
 mm/swap.c              | 69 ------------------------------------------
 mm/vmscan.c            | 67 ++++++++++++++++++++++++++++++++++------
 mm/vmstat.c            |  4 +++
 mm/workingset.c        |  5 ---
 9 files changed, 77 insertions(+), 91 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..0627622a5184 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,10 @@ enum node_stat_item {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGRECLAIM_PAGEOUT_ANON,
+	PGRECLAIM_PAGEOUT_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
@@ -763,9 +767,12 @@ struct lruvec {
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
 	 * increases, the reclaim scan balance tips toward the other.
+	 * Updated and decayed at prepare_scan_control() time; cost_lock
+	 * serialises that update.
 	 */
-	unsigned long			anon_cost;
-	unsigned long			file_cost;
+	unsigned long			prev_cost[ANON_AND_FILE];
+	unsigned long			cost_accum[ANON_AND_FILE];
+	spinlock_t			cost_lock;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6d72778e6cc3..d35a4761ebd7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -309,9 +309,6 @@ extern unsigned long totalreserve_pages;
 
 
 /* linux/mm/swap.c */
-void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
-		unsigned int nr_io, unsigned int nr_rotated);
-void lru_note_cost_refault(struct folio *);
 void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 765069211567..c7a52bb68f4c 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1988,8 +1988,8 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		for_each_online_pgdat(pgdat) {
 			mz = memcg->nodeinfo[pgdat->node_id];
 
-			anon_cost += mz->lruvec.anon_cost;
-			file_cost += mz->lruvec.file_cost;
+			anon_cost += mz->lruvec.cost_accum[WORKINGSET_ANON];
+			file_cost += mz->lruvec.cost_accum[WORKINGSET_FILE];
 		}
 		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
 		seq_buf_printf(s, "file_cost %lu\n", file_cost);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..3c068ebefd97 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -419,6 +419,10 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGRECLAIM_PAGEOUT_ANON,
+	PGRECLAIM_PAGEOUT_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 0c8f181d9d50..17139db4d291 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -78,6 +78,7 @@ void lruvec_init(struct lruvec *lruvec)
 
 	memset(lruvec, 0, sizeof(struct lruvec));
 	spin_lock_init(&lruvec->lru_lock);
+	spin_lock_init(&lruvec->cost_lock);
 	zswap_lruvec_state_init(lruvec);
 
 	for_each_lru(lru)
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..74b281778cbc 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -272,73 +272,6 @@ void folio_rotate_reclaimable(struct folio *folio)
 	folio_batch_add_and_move(folio, lru_move_tail);
 }
 
-void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
-		unsigned int nr_io, unsigned int nr_rotated)
-		__releases(lruvec->lru_lock)
-		__releases(rcu)
-{
-	unsigned long cost;
-
-	/*
-	 * Reflect the relative cost of incurring IO and spending CPU
-	 * time on rotations. This doesn't attempt to make a precise
-	 * comparison, it just says: if reloads are about comparable
-	 * between the LRU lists, or rotations are overwhelmingly
-	 * different between them, adjust scan balance for CPU work.
-	 */
-	cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated;
-	if (!cost) {
-		spin_unlock_irq(&lruvec->lru_lock);
-		rcu_read_unlock();
-		return;
-	}
-
-	for (;;) {
-		unsigned long lrusize;
-
-		/* Record cost event */
-		if (file)
-			lruvec->file_cost += cost;
-		else
-			lruvec->anon_cost += cost;
-
-		/*
-		 * Decay previous events
-		 *
-		 * Because workloads change over time (and to avoid
-		 * overflow) we keep these statistics as a floating
-		 * average, which ends up weighing recent refaults
-		 * more than old ones.
-		 */
-		lrusize = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
-			  lruvec_page_state(lruvec, NR_ACTIVE_ANON) +
-			  lruvec_page_state(lruvec, NR_INACTIVE_FILE) +
-			  lruvec_page_state(lruvec, NR_ACTIVE_FILE);
-
-		if (lruvec->file_cost + lruvec->anon_cost > lrusize / 4) {
-			lruvec->file_cost /= 2;
-			lruvec->anon_cost /= 2;
-		}
-
-		spin_unlock_irq(&lruvec->lru_lock);
-		lruvec = parent_lruvec(lruvec);
-		if (!lruvec) {
-			rcu_read_unlock();
-			break;
-		}
-		spin_lock_irq(&lruvec->lru_lock);
-	}
-}
-
-void lru_note_cost_refault(struct folio *folio)
-{
-	struct lruvec *lruvec;
-
-	lruvec = folio_lruvec_lock_irq(folio);
-	lru_note_cost_unlock_irq(lruvec, folio_is_file_lru(folio),
-				folio_nr_pages(folio), 0);
-}
-
 static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
@@ -1164,8 +1097,6 @@ void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int
 
 	child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-	parent_lruvec->anon_cost += child_lruvec->anon_cost;
-	parent_lruvec->file_cost += child_lruvec->file_cost;
 
 	for_each_lru(lru)
 		lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..136e43a2a39a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2043,10 +2043,13 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
+	if (stat.nr_pageout)
+		mod_lruvec_state(lruvec, PGRECLAIM_PAGEOUT_ANON + file,
+				 stat.nr_pageout);
+	if (nr_scanned > nr_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file,
+				 nr_scanned - nr_reclaimed);
 
-	lruvec_lock_irq(lruvec);
-	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
-					nr_scanned - nr_reclaimed);
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
@@ -2152,9 +2155,9 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	if (nr_rotated)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
-	lruvec_lock_irq(lruvec);
-	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
@@ -2303,12 +2306,56 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
 
 	/*
-	 * Determine the scan balance between anon and file LRUs.
+	 * Determine the scan balance between anon and file LRUs from per-LRU
+	 * vmstat counters. The raw cost per side is:
+	 *
+	 *	PGROTATE	   - reclaim-driven rotations, bumped from both
+	 *			     shrink_inactive_list and shrink_active_list
+	 *			     (CPU work).
+	 *	PGRECLAIM_PAGEOUT  - reclaim-driven pageout IO.
+	 *	WORKINGSET_RESTORE - refaults of previously-workingset pages.
+	 *
+	 * The two IO terms are weighted by SWAP_CLUSTER_MAX to reflect the
+	 * higher cost of an IO over a rotation.
+	 *
+	 * Reads are lock-free per-cpu sum collations, rstat-aggregated up
+	 * the memcg hierarchy by mem_cgroup_flush_stats_ratelimited() above.
+	 *
+	 * The delta against prev_cost is folded into cost_accum, which is
+	 * halved on both sides until their sum is within lrusize/4.
+	 * cost_lock serialises concurrent reclaimers in the same memcg+node.
 	 */
-	spin_lock_irq(&target_lruvec->lru_lock);
-	sc->anon_cost = target_lruvec->anon_cost;
-	sc->file_cost = target_lruvec->file_cost;
-	spin_unlock_irq(&target_lruvec->lru_lock);
+	spin_lock(&target_lruvec->cost_lock);
+	for (int f = 0; f <= 1; f++) {
+		unsigned long now, delta;
+
+		now = lruvec_page_state(target_lruvec, PGROTATE_ANON + f) +
+		      (lruvec_page_state(target_lruvec,
+					 PGRECLAIM_PAGEOUT_ANON + f) +
+		       lruvec_page_state(target_lruvec,
+					 WORKINGSET_RESTORE_BASE + f)) *
+				SWAP_CLUSTER_MAX;
+		delta = now - target_lruvec->prev_cost[f];
+		target_lruvec->prev_cost[f] = now;
+		target_lruvec->cost_accum[f] += delta;
+	}
+	unsigned long lrusize =
+		lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
+		lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
+		lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
+		lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
+	unsigned long cost_limit = lrusize / 4;
+
+	while (target_lruvec->cost_accum[WORKINGSET_ANON] > cost_limit ||
+	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit ||
+	       target_lruvec->cost_accum[WORKINGSET_ANON] +
+	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit) {
+		target_lruvec->cost_accum[WORKINGSET_ANON] /= 2;
+		target_lruvec->cost_accum[WORKINGSET_FILE] /= 2;
+	}
+	sc->anon_cost = target_lruvec->cost_accum[WORKINGSET_ANON];
+	sc->file_cost = target_lruvec->cost_accum[WORKINGSET_FILE];
+	spin_unlock(&target_lruvec->cost_lock);
 
 	/*
 	 * Target desirable inactive:active list ratios for the anon
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..2dfed5e9b64d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1289,6 +1289,10 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
+	[I(PGRECLAIM_PAGEOUT_ANON)]		= "pgreclaim_pageout_anon",
+	[I(PGRECLAIM_PAGEOUT_FILE)]		= "pgreclaim_pageout_file",
+	[I(PGROTATE_ANON)]			= "pgrotate_anon",
+	[I(PGROTATE_FILE)]			= "pgrotate_file",
 	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723a..7ac2b88c80ae 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -584,11 +584,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 	/* Folio was active prior to eviction */
 	if (workingset) {
 		folio_set_workingset(folio);
-		/*
-		 * XXX: Move to folio_add_lru() when it supports new vs
-		 * putback
-		 */
-		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
 out:
-- 
2.53.0-Meta


