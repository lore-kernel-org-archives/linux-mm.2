Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACF8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F88C6B013E; Mon, 13 Jul 2026 12:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D00A6B013F; Mon, 13 Jul 2026 12:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697B76B0140; Mon, 13 Jul 2026 12:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33D206B013E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:35:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8B2D401F8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:35:01 +0000 (UTC)
X-FDA: 84984302802.03.6C5EDF7
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id EFEF54000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:34:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PoyTRAdl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960500;
	b=YGNaQhiJnWKapdDiOFyn+Rxk+rgiJPP7jzCl1RDlF6yv1wqIUd6h7qYTbgvxaSGdlYy4NT
	XZeyvgksyQuIlsNvHFeSEkwcZ4PKXuvTOP4sECfwiow+wc/hSVI56kMTmDO2NFLGlCyuU5
	Noy6aabZY47kXVEj0zz+jpOICyxMGME=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PoyTRAdl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+WURyDogfE9BgLQhSv6f/8vc6G9zcHDTCSmutvErc4=;
	b=02Ob4Zz1oTYjZTmbGmtQTcoDg1DIIt21Ru3N2CWkivlaLqrwjWn2bveabyFB+xCekGAYh8
	lxDrf13HHc8wS7EHG9MceQO0o8XGMNzK0RADGYs2kbQ6Rz4iDjXon3oMktKjDjsknhpS40
	7QPIqZXcHfGTC8216q3oXIgs6VOsBoM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783960498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g+WURyDogfE9BgLQhSv6f/8vc6G9zcHDTCSmutvErc4=;
	b=PoyTRAdlwyICsbS8gl4+HMG0dzCn2BmBvEq4COuXj2P19XM/YXOTPPfqY9oeidLRr2EoaS
	6DbWvxHgZgCi+DcFUQDGyXFeg7gYYifqVszzGRLknosFB5QoCO8jdLAfc6Y3RpbHXDDqHy
	ITjY1roEnZmNFBgyiC3qrCdluwWylLk=
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
Subject: [PATCH v2 2/2] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon, 13 Jul 2026 09:34:17 -0700
Message-ID: <20260713163443.3562378-3-usama.arif@linux.dev>
In-Reply-To: <20260713163443.3562378-1-usama.arif@linux.dev>
References: <20260713163443.3562378-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EFEF54000B
X-Rspam-User: 
X-Stat-Signature: y9zwpbtpxma7u5a5mgt6r89e6ig1chid
X-Rspamd-Server: rspam03
X-HE-Tag: 1783960499-37960
X-HE-Meta: U2FsdGVkX1/yJqa8cvkhhPYkeTUgpfh4XgRVCdaxsK6Rxa90SjHIn8QzjWlrZcEn+L507w72dHUx4+k65mfHa6f45TngE935FnSoDsB1U8ZWarNUnYKQna9I90U66iAt/49JDXEWMYpxUKlpHBQMX4qjVwUAMpy9ZLCvL99MDnGRWGIbfdzVUBwRl+AH9UpFF1xNsVfar9d5So6dsQQuwqBtDzkJ01nTq0sUqwrgv3G22a0PIlXmn9pUit1TsjPsIliFM9nJNa3kycFhvG5u0gnwjnOZRTcW0CfBqI6cyFRr6Q9rQLXrFzQdA5kprIFwh1Mu5rFZqEKJYH2IXf/jsQ6hCDpzfJ7WfIHqVM5WDCAkJw+K1JMWmEHIwQEyoRYkDifAQDGdK7lxJ1akF2PChvWIsLzr0CJJzIuWunWNHimvv76Z+YVE+4Yd7uQsMh2Q5v2k/atPxuk/eL41XUnEHpfE/3GXj78EAXEQ/Yc3PsSX9eX7ym3O/ZbyjeqNLrjEpBlFH7656mM+mccwPbxYgkTdamqE0z8hhwUUteXlZRP0pDoVf9w73wRePW2Gc3fGbkWP2eVfFA3Rc61342lI05Un2KOzadTK3hhQST64t/qSgRyLMu5qZzz5SRAmQ5m6H+34TLwezBkpG2asnWSzOwf3GcaFbxcXAhjpoXe+WVmPl3us6DYC0ylQ1qwETzPqiBDXTy0QLaoXRkbPv2Iw/UzOLcuLqNTkeiC4prBXyFJPxh5Eci+TVTiiIUjzKn33vTfbDDhOGQ57qnDlLu032fdIz9+boDpX4W5JCrFCK35/kNHh31UzDFQC4JbVtBWmyrlbwysURSccpWrfl3sZBJNFfQpqX6kaZirSwJVqmy0VvVWIGigISybY6loGBI+ulzqoaFDg4Wp85z1//YDUkyri/W9BPjdjQuep1foN8FsMcUURVpubHA6gVsRpI6E5sXBonfPj62kEKDEo0Dr
 V7NwiSp8
 jEfWcbgq0lMsUhLDfvA20CmtYqjkac6d8BCHCq4XIXH0wevcebcKslWl1x4jVufsPCk8bSE/QxJXDSlMyPpDeAxid55s48REU3v1GjlrC3H/+UczitWbR60h4+d4NYdU2yIoBGTeEvq/5rSkJwm1RuPtFuSdbsmTtiZlCdFGRS4G8ydc43ooJXKVVB3F0bwDp5HjhyFyUHHciN9Q0sa2oBhae68MHc7gPoj204wIhZ2YrDdZpJK2BvP5mfA==
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

memcg-v1's memory.stat anon_cost/file_cost is now sourced from
cost_accum[] instead of the removed lruvec anon_cost/file_cost fields.
The reported values only refresh when prepare_scan_control() runs and
are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
they express is unchanged.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/mmzone.h | 11 +++++--
 include/linux/swap.h   |  3 --
 mm/memcontrol-v1.c     |  4 +--
 mm/memcontrol.c        |  4 +++
 mm/mmzone.c            |  1 +
 mm/swap.c              | 69 ----------------------------------------
 mm/vmscan.c            | 72 ++++++++++++++++++++++++++++++++++++------
 mm/vmstat.c            |  4 +++
 mm/workingset.c        |  5 ---
 9 files changed, 82 insertions(+), 91 deletions(-)

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
index b4a357c5f7e0..c12d9ea7f393 100644
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
index e8a90911bf88..279f78b7a0e4 100644
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
@@ -2303,12 +2306,61 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
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
+	 * Use lruvec_page_state_monotonic() so the unsigned subtraction
+	 * `now - prev_cost[f]` yields the correct delta across a signed-long
+	 * wraparound of the underlying counter (a real hazard on 32-bit that
+	 * the clamp in lruvec_page_state() would otherwise turn into a huge
+	 * spurious delta).
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
+		now = lruvec_page_state_monotonic(target_lruvec, PGROTATE_ANON + f) +
+		      (lruvec_page_state_monotonic(target_lruvec,
+						   PGRECLAIM_PAGEOUT_ANON + f) +
+		       lruvec_page_state_monotonic(target_lruvec,
+						   WORKINGSET_RESTORE_BASE + f)) *
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
index c4364f0eb08a..db80efe0a6d2 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1300,6 +1300,10 @@ const char * const vmstat_text[] = {
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


