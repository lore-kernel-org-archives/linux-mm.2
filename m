Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6E8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE3C6B008C; Tue, 14 Jul 2026 08:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5116B0098; Tue, 14 Jul 2026 08:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC1F6B00B0; Tue, 14 Jul 2026 08:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EFFD6B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:44:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C9361C02EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:44:40 +0000 (UTC)
X-FDA: 84987351120.10.3ECFAD5
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id A6E6540007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:44:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vfw4wVy4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784033079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SL2BuBErJSR+msyoMlTQpeX2tgyYFMJLBrTouVN+o3E=;
	b=eSWXGZLPNGhwNNpLESIyMK0myOzKzsaYh+9S4p2b68QFdLuNT4CRE+bwEJ68Y25FMOxXPz
	tWI9lRP8PHRB5dGGtHZUkxNgPkT6P8+0/RRdZ4Y+BrnFT53REGlpOJ+NtJ3cc097aK/suG
	YsgjqrTk/ZZ2fFmwkmRD05zXcAz56Gk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vfw4wVy4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784033079;
	b=7daS7KdbdlejuAn1SxCxR5CgTZBDx0LszciZW7pBe9AWh63BaHILOU49K9RZAHzTaxGVfm
	mubEa00RzABNQweEjxrD41m08KLfJCcuUdpG0GV+Ud1pw2rRvAIXQoaU9v7FXzLW216vQR
	aqp5DC9zY6V583d2T8YIrb27et98wQw=
Message-ID: <25a94af5-1dbe-4ab4-b47d-fb49987bfcd4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784033076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SL2BuBErJSR+msyoMlTQpeX2tgyYFMJLBrTouVN+o3E=;
	b=Vfw4wVy4dFED07nvt6oOpMkXirev2Y5GMxKO5ot6QfOqKJyPHMsdi4giItxcH80oClK6xP
	5UglsrKFeXrW34PiHzsomYxK4+ifqhq3VTgN8mGFL/rnG6aQRdHl6tSw7NIPegyx5yPDDI
	RbSVA//0HtXp7v6qjpAxaIHb4J6CP6g=
Date: Tue, 14 Jul 2026 13:44:03 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chrisl@kernel.org, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com,
 kernel-team@meta.com
References: <20260713163443.3562378-1-usama.arif@linux.dev>
 <20260713163443.3562378-3-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260713163443.3562378-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6E6540007
X-Stat-Signature: xhae61uzxerkh87cixx451rzme3k8w9u
X-HE-Tag: 1784033078-935560
X-HE-Meta: U2FsdGVkX1+a+97RnoLEpKtbpNyAjFxq4cR98KXu39TGZ3FYWCrXQAejOpHqSQvdl4ovacRzpKnldw0Ms5jeFHJFWLjciKmaaldbuInSuQGoS4Yjkho6EpGkghD9wuHLYl1EKWYw9m/1rGvNVATtwQHnZ9PpCuwkhnLhh9vCfoXOWhmv3plSovEJ/4iXcN/mkHOi7dVZsnLk7Lto1hKHbpLLahHNT1H+5JvbXU+815QKpCYwgQpcCh9qmNt68Q2q2x9d9GXh+1fdm9pj7iKw7KPPnEEv3pjAPByAZYqEb3hM49vMJM712PLBw/D1D1NQuS8asKp4m01EBxXJ25d3HqCKKZ5rRL7ZLhFRO749a7DGyNHbj1hAd2mPB3aYUI7zVJwdJq+QFl96+vV5VKSTDgRVOEwLiYqpHrDptcoKYPfJrBG6pVRQdguiqd4ZdgvaUHMhIsGXtzgmJ0fW4esti0QTemi0InS1d54TT6d6MhSut6osTEwvSOLh6eov4jQ4vQh9FZqFZs0RxqYN8rxhU0kgHekOaTzKCZMwBrEgipO2WgAMKfkKzQtePngkM2ARG49zKjYDzn12wHNDysFQ8+qotSy/WZTIoINwCFyeY47GryRN5juJ9KLHsniUSX5hSEA2Lz6NTS8uU8DIu68X+BmaKosX307EhJDeSttpNPc9lPuOESv31ux5N8Tbd79+0kcWk6paQyvFHVSaNliWNb2fcgSwr/covAJd3Ujnh0sSvqJ4EOk8g3gmOLbBZpO2xt6sC0ahzILcyGTIT4fnsyrwzTgFn1r66zCYy/76SAlXf2GeJv0lQ+CjjZTz7HIi4+yJSapi7BhyDaTwEvcJYS/D2gmU5Q8qPZb5GECq/Kr+sC3cXTm+UqNL041a2U06W3j7NdM6qcNP4m51FeVTXwEJyo7vommfHtUFxl974JjRu8E46Oyvh7oyQzPSfpY0D7iVtttiPiHYQTl49Xd
 voBAJqmZ
 rLrv2O5rawA9tpRF1S5xXD1WaQQPLpiERIsIFjM3mdKHg1kS134JXRJcLJ6bvFa4aIWVOlbQTMVHuvC+K9GyzLXWvtBIbvTglXpzNn+IB8zOgTSKGOZ2INb+ybOuDsJgK/aodTfv86L4NkY+LYhuVT+EcZGli4cv+Pjc25AY+uA2LGiuH9vokTnZoOEWW9Knr7FyJMjHX9sLPxS5CIboUcqy3/OU+9dTH9o49shNHX5rMIBGDDkb1qy6aA8HabtGy/R4M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/2026 17:34, Usama Arif wrote:
> The anon/file scan balance in get_scan_count() is driven by two scalars
> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> producer under lruvec->lru_lock. The acquisition sites for cost work
> specifically are:
> 
>   - shrink_inactive_list() re-takes lru_lock at function exit purely
>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
>     nr_reclaimed). One acquisition per inactive shrink.
>   - shrink_active_list() does the same with (0, nr_rotated). One
>     acquisition per active shrink.
>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
>     purely to record the refault cost. One acquisition per refault.
>   - prepare_scan_control() takes lru_lock just to snapshot the two
>     scalars into sc->{anon,file}_cost.
>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
>     re-acquires lru_lock on each ancestor to propagate the update,
>     adding O(memcg-depth) acquisitions per producer call.
> 
> This hurts because lru_lock is already a heavy contention point on
> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> and folio_add_lru() takes it. The cost work itself is trivial (two
> scalar bumps and one comparison), but it contends with and causes
> contention for actual LRU manipulation. The parent_lruvec() walk also
> multiplies cost-update overhead by memcg hierarchy depth.
> 
> Replace the producer-side accumulators with a read-side accumulator fed
> from per-LRU vmstat counters. The old producer formula was:
> 
>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Add explicit node_stat counters for the producer-local inputs:
> 
>   PGRECLAIM_PAGEOUT_{ANON,FILE} - reclaim-driven pageout submissions
>                                   (formerly stat.nr_pageout, weighted
>                                   by SWAP_CLUSTER_MAX).
>   PGROTATE_{ANON,FILE}          - reclaim-driven rotations, bumped from
>                                   both shrink_inactive_list (by
>                                   nr_scanned - nr_reclaimed) and
>                                   shrink_active_list (by nr_rotated),
>                                   unweighted.
> 
> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> lru_note_cost_refault() used to bill.
> 
> In prepare_scan_control() the raw cost signal is recomputed lock-free of
> lru_lock from monotonic counters:
> 
>   now = (PGRECLAIM_PAGEOUT_X + WORKINGSET_RESTORE_X) * SWAP_CLUSTER_MAX
>         + PGROTATE_X
> 
> The delta against a per-lruvec prev_cost[] snapshot is folded into
> cost_accum[]. Since one vmstat delta can cover many producer events
> between reclaim passes, halve cost_accum[] until the total is back
> within the lrusize/4 bound instead of halving only once.
> 
> Moving accumulation and decay to the reclaim side also improves the cost
> model across reclaim gaps. With producer-side decay, events that happen
> while reclaim is idle still age each other before reclaim ever samples
> the costs. If a workload refaults a large anon set and then a smaller
> file set before reclaim runs again, the later file activity can age the
> earlier anon activity out of the cost model. The new scheme observes the
> whole between-reclaim delta and decays anon and file proportionally, so
> the scan-balance history better represents what happened since the last
> reclaim pass.
> 
> A dedicated per-lruvec spinlock, cost_lock, serialises the prev_cost
> RMW, the accumulator update, and the halving check against concurrent
> reclaimers in the same memcg+node.
> 
> Hierarchy aggregation is now implicit in the vmstat accounting. The
> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> existed only because anon_cost/file_cost were private lruvec fields. With
> the cost expressed as lruvec vmstats, rstat propagates the underlying
> counters through the memcg hierarchy and prepare_scan_control() consumes
> the same ratelimited rstat view as the surrounding reclaim heuristics.
> 
> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> cost_accum[] instead of the removed lruvec anon_cost/file_cost fields.
> The reported values only refresh when prepare_scan_control() runs and
> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> they express is unchanged.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/mmzone.h | 11 +++++--
>  include/linux/swap.h   |  3 --
>  mm/memcontrol-v1.c     |  4 +--
>  mm/memcontrol.c        |  4 +++
>  mm/mmzone.c            |  1 +
>  mm/swap.c              | 69 ----------------------------------------
>  mm/vmscan.c            | 72 ++++++++++++++++++++++++++++++++++++------
>  mm/vmstat.c            |  4 +++
>  mm/workingset.c        |  5 ---
>  9 files changed, 82 insertions(+), 91 deletions(-)
> 

The patch will need the below fixlet so that the counters keep incrementing
for MGLRU as well. The counters themselves are not actually used by MGLRU,
so this is just for observability. This was reported by sashiko, Thanks
Andrew for pointing this out!


From 0fd35b49112cc0d689741f04c485283e6dce3326 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Tue, 14 Jul 2026 05:18:16 -0700
Subject: [PATCH] [fixlet] mm/vmscan: increment pgreclaim_pageout_* and
 pgrotate_* for MGLRU

/proc/vmstat and per-memcg memory.stat expose pgreclaim_pageout_*
and pgrotate_* directly (memcg_node_stat_items in memcontrol.c
forwards them per-memcg). Without this fix they stay at 0 whenever
reclaim runs through MGLRU, misreporting observability.

Under pure MGLRU the scan-balance signal itself is not consumed (both
prepare_scan_control() and get_scan_count() are short-circuited on the
MGLRU paths, and MGLRU's own type/tier selection comes from
read_ctrl_pos() on lrugen->{avg_refaulted,avg_total,refaulted,evicted},
not from anon_cost/file_cost), so this fix is about observability.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/vmscan.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 279f78b7a0e4..2da36374bb4a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4867,7 +4867,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
-	int isolated = 0, type, type_scanned;
+	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	unsigned long total_reclaimed = 0, total_pageout = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4879,6 +4880,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
+	nr_isolated = isolated;
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4891,6 +4893,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	total_reclaimed += reclaimed;
+	total_pageout += stat.nr_pageout;
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
@@ -4944,6 +4948,13 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (total_pageout)
+		mod_lruvec_state(lruvec, PGRECLAIM_PAGEOUT_ANON + type,
+				 total_pageout);
+	if (nr_isolated > total_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
+				 nr_isolated - total_reclaimed);
+
 	return scanned;
 }
 
-- 
2.53.0-Meta




