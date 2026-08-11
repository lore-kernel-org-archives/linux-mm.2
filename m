Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E82C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D0B6B0098; Tue, 11 Aug 2026 16:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E836B009B; Tue, 11 Aug 2026 16:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B817B6B0098; Tue, 11 Aug 2026 16:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85FCA6B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB112A0231
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:22 +0000 (UTC)
X-FDA: 85090136124.11.1B7CEF3
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 123044000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nHgA5+SY;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDWP20iIxrMfICDaLl7H7nQinULjLOkDjQsbQNGYncg=;
	b=rzpmzjdop2t+Yr8qDADguhT9/zbLcl8WVgDievMgfdcTXIujex5wm5+sgkUhN9OYW4skIB
	kCc5pjoJOaExTp60+rcn1A70ymYIejpJX1BXEa9D2j3ggtt9Z+LPZw9Nuvqd0kldJ8Q1cr
	kOVRDM028DzOoR7yDEwkkSRGwPUhpoU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nHgA5+SY;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480341;
	b=Lrsv6rNKC1NOGUmOZJiC9W6pYt05Is1SV5rY7In31VDpgmBWl1NCtBPWx72nI1x+z+FaW/
	3ZUS5HQAHxzG36IDY/BiUFY7BE1+LiPPrMg3BdoH+IJdNdxiC5UI8Cln2RcFfQpvpAgegO
	8LhOwFypKrlRngMiWFLg5DaeL1mYFsU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDWP20iIxrMfICDaLl7H7nQinULjLOkDjQsbQNGYncg=;
	b=nHgA5+SYM16j2OtMexfEx2mAgozqWPUc+BgYMXWhfCjZY39sfhcIjgaKO+J/fP46aGFVXU
	DmF2PXcl/gvCk5FaZzVA9eJ61sIkBaC3lrVf3vC5TZI/PjBLfe5AosdjVe3wMuz2ONIb1w
	9LUndI7ySNQThqSIfNKz7oL9HOxc/1U=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] memcg: remove v1 soft limit reclaim
Date: Tue, 11 Aug 2026 13:31:56 -0700
Message-ID: <20260811203203.3456029-3-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zu1pz59ocusemz7iernnbogawzwmm3cn
X-Rspamd-Queue-Id: 123044000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786480340-179889
X-HE-Meta: U2FsdGVkX18H/tmP4+fFMeH8Kj7E8Iqik9oP9qUjzGSn5uyGinNq+k4q+nlidjfyigsMxfhLYSfW91dmYkWWmvhc68efOXMgcJxVyDsPLNLfQY/LAtbYqI9DIXrzYX9EDydku+bQ0MfI8s52XqGWGqpRLTJ2fLP2pbluLDvF1G87ErNsXRJSs4FPrl3nzWpaDXYkTOBR5vPE/v2O9eHheCdG+PSKE/q5gcXs9dCczx4yl3k2Aq8FUigeh8kCshHg1Wi/1u8N/17nq07hxJNivd6Dki5zEwL5zgnGe76x74c6bVk0Dz7R/hHMHuFNCTbp+xKI8R/PGQXHokbcP7A5TRKj2NJpK+xAiGYq1tp8WQX7xZuhcKc92nhV/FesDY40W4AXLk1cRjkV9FkWtPwqmQt1l+Q5itRrS9fCAWDxsbIYYpebNjgQU7sHK1mX/sKkMHI8wSn4cjOL7vNcUenS2/rQDgs3qpTUIEIIIY5B45NXxqsV3eHCADhVV/stftNmcPNvMGDGZUX9gkheqfWibVysHIFZ/LGnrH5kLdmSh3Z3g+eYUaWGDROWJ/TzP3GAVN484n3b7wvbleyRLykX5yPH+DvSq9sidF0F/t6WgLQwuOr8DkAxgrSieLAuIlNtbj73kgEy5tAiNViEVxLilroVAGz26Xt7snmqqfSKD9PFcXn6XV9RaNyG1UjGgTYTHiKmjEjOM7mtciyfKqGZ9DJkw0yqcwqh1BO5CmkkcyA+MVOMRiG0TmMbOIoUW6t7nRAAOlknjf/+a1KSp64kKxcfzqHwAs4AfbEu/L5sEBhRfsxuOyx1dvVHgd+uuZNu8S4wdVllJXeTYHpPgF0EnGfcUPtQvyoDeZWhk5gtLhmV1FmN2RKNe1IsUK4eUFHV3y/CqtN+Gm7wGIfJ86CNI2ggv47BCEgZNcLIB+3cXpeQ2nxS3iwyF6ygBxi0S/RXYmRPtxW1FqFd0SANz4/
 HvkNR4aP
 0Z2BK6SEbarhn9U0nIosJcLpwO5vVdTU9cUKjUeL90puBrQmn2oB4kW9keqOwXH9DhXKo9KRSHGvtAFwzz0OYN1PCpwrb6f5jCwWmkg2gJJRSiIPjVfyXy1cWZ4m4gD0ni8Yjt+3LookD7PkzlpRd7SFgZ6G02wl+d/dNe0n3u7YByrQ4OMX09feEG8ZAV+DhLDFXmm4yXzT0Oug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nothing can put a cgroup on the soft limit rbtree anymore, so the tree
is always empty and both callers of memcg1_soft_limit_reclaim() are
guaranteed no-ops. Remove the reclaim pass from direct reclaim and from
kswapd, along with its implementation.

In shrink_zones() this leaves the global reclaim branch with a
last_pgdat check that is now redundant with the identical check right
below it, so drop it and move the explaining comment down to the check
that remains. That check could only ever fire once last_pgdat was set,
which implies first_pgdat had already been assigned, so skipping it does
not change which node consider_reclaim_throttle() gets.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h |  12 ---
 mm/memcontrol-v1.c         | 175 -------------------------------------
 mm/vmscan.c                |  39 ++-------
 3 files changed, 6 insertions(+), 220 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229..7b02f1b3bb88 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1927,10 +1927,6 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 /* Cgroup v1-related declarations */
 
 #ifdef CONFIG_MEMCG_V1
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					gfp_t gfp_mask,
-					unsigned long *total_scanned);
-
 bool mem_cgroup_oom_synchronize(bool wait);
 
 static inline bool task_in_memcg_oom(struct task_struct *p)
@@ -1951,14 +1947,6 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					gfp_t gfp_mask,
-					unsigned long *total_scanned)
-{
-	return 0;
-}
-
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
 	return false;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 05ef55cae4dc..b38b8d0f7f51 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -34,13 +34,6 @@ struct mem_cgroup_tree {
 
 static struct mem_cgroup_tree soft_limit_tree __read_mostly;
 
-/*
- * Maximum loops in mem_cgroup_soft_reclaim(), used for soft
- * limit reclaim to prevent infinite loops, if they ever occur.
- */
-#define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
-#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
-
 /* for OOM */
 struct mem_cgroup_eventfd_list {
 	struct list_head list;
@@ -233,174 +226,6 @@ void memcg1_remove_from_trees(struct mem_cgroup *memcg)
 	}
 }
 
-static struct mem_cgroup_per_node *
-__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
-{
-	struct mem_cgroup_per_node *mz;
-
-retry:
-	mz = NULL;
-	if (!mctz->rb_rightmost)
-		goto done;		/* Nothing to reclaim from */
-
-	mz = rb_entry(mctz->rb_rightmost,
-		      struct mem_cgroup_per_node, tree_node);
-	/*
-	 * Remove the node now but someone else can add it back,
-	 * we will to add it back at the end of reclaim to its correct
-	 * position in the tree.
-	 */
-	__mem_cgroup_remove_exceeded(mz, mctz);
-	if (!soft_limit_excess(mz->memcg) ||
-	    !css_tryget(&mz->memcg->css))
-		goto retry;
-done:
-	return mz;
-}
-
-static struct mem_cgroup_per_node *
-mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
-{
-	struct mem_cgroup_per_node *mz;
-
-	spin_lock_irq(&mctz->lock);
-	mz = __mem_cgroup_largest_soft_limit_node(mctz);
-	spin_unlock_irq(&mctz->lock);
-	return mz;
-}
-
-static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
-				   pg_data_t *pgdat,
-				   gfp_t gfp_mask,
-				   unsigned long *total_scanned)
-{
-	struct mem_cgroup *victim = NULL;
-	int total = 0;
-	int loop = 0;
-	unsigned long excess;
-	unsigned long nr_scanned;
-	struct mem_cgroup_reclaim_cookie reclaim = {
-		.pgdat = pgdat,
-	};
-
-	excess = soft_limit_excess(root_memcg);
-
-	while (1) {
-		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
-		if (!victim) {
-			loop++;
-			if (loop >= 2) {
-				/*
-				 * If we have not been able to reclaim
-				 * anything, it might because there are
-				 * no reclaimable pages under this hierarchy
-				 */
-				if (!total)
-					break;
-				/*
-				 * We want to do more targeted reclaim.
-				 * excess >> 2 is not to excessive so as to
-				 * reclaim too much, nor too less that we keep
-				 * coming back to reclaim from this cgroup
-				 */
-				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
-					break;
-			}
-			continue;
-		}
-		total += mem_cgroup_shrink_node(victim, gfp_mask, false,
-					pgdat, &nr_scanned);
-		*total_scanned += nr_scanned;
-		if (!soft_limit_excess(root_memcg))
-			break;
-	}
-	mem_cgroup_iter_break(root_memcg, victim);
-	return total;
-}
-
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
-{
-	unsigned long nr_reclaimed = 0;
-	struct mem_cgroup_per_node *mz, *next_mz = NULL;
-	unsigned long reclaimed;
-	int loop = 0;
-	struct mem_cgroup_tree_per_node *mctz;
-	unsigned long excess;
-
-	if (lru_gen_enabled())
-		return 0;
-
-	if (order > 0)
-		return 0;
-
-	mctz = soft_limit_tree.rb_tree_per_node[pgdat->node_id];
-
-	/*
-	 * Do not even bother to check the largest node if the root
-	 * is empty. Do it lockless to prevent lock bouncing. Races
-	 * are acceptable as soft limit is best effort anyway.
-	 */
-	if (!mctz || RB_EMPTY_ROOT(&mctz->rb_root))
-		return 0;
-
-	/*
-	 * This loop can run a while, specially if mem_cgroup's continuously
-	 * keep exceeding their soft limit and putting the system under
-	 * pressure
-	 */
-	do {
-		if (next_mz)
-			mz = next_mz;
-		else
-			mz = mem_cgroup_largest_soft_limit_node(mctz);
-		if (!mz)
-			break;
-
-		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
-						    gfp_mask, total_scanned);
-		nr_reclaimed += reclaimed;
-		spin_lock_irq(&mctz->lock);
-
-		/*
-		 * If we failed to reclaim anything from this memory cgroup
-		 * it is time to move on to the next cgroup
-		 */
-		next_mz = NULL;
-		if (!reclaimed)
-			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
-
-		excess = soft_limit_excess(mz->memcg);
-		/*
-		 * One school of thought says that we should not add
-		 * back the node to the tree if reclaim returns 0.
-		 * But our reclaim could return 0, simply because due
-		 * to priority we are exposing a smaller subset of
-		 * memory to reclaim from. Consider this as a longer
-		 * term TODO.
-		 */
-		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz, mctz, excess);
-		spin_unlock_irq(&mctz->lock);
-		css_put(&mz->memcg->css);
-		loop++;
-		/*
-		 * Could not reclaim anything and there are no more
-		 * mem cgroups to try or we seem to be looping without
-		 * reclaiming anything.
-		 */
-		if (!nr_reclaimed &&
-			(next_mz == NULL ||
-			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
-			break;
-	} while (!nr_reclaimed);
-	if (next_mz)
-		css_put(&next_mz->memcg->css);
-	return nr_reclaimed;
-}
-
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 				struct cftype *cft)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index be6bd26e8c57..032b14793d91 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6429,8 +6429,6 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	unsigned long nr_soft_reclaimed;
-	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
 	pg_data_t *last_pgdat = NULL;
 	pg_data_t *first_pgdat = NULL;
@@ -6472,35 +6470,17 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 				sc->compaction_ready = true;
 				continue;
 			}
-
-			/*
-			 * Shrink each node in the zonelist once. If the
-			 * zonelist is ordered by zone (not the default) then a
-			 * node may be shrunk multiple times but in that case
-			 * the user prefers lower zones being preserved.
-			 */
-			if (zone->zone_pgdat == last_pgdat)
-				continue;
-
-			/*
-			 * This steals pages from memory cgroups over softlimit
-			 * and returns the number of reclaimed pages and
-			 * scanned pages. This works for global memory pressure
-			 * and balancing, not for a memcg's limit.
-			 */
-			nr_soft_scanned = 0;
-			nr_soft_reclaimed = memcg1_soft_limit_reclaim(zone->zone_pgdat,
-								      sc->order, sc->gfp_mask,
-								      &nr_soft_scanned);
-			sc->nr_reclaimed += nr_soft_reclaimed;
-			sc->nr_scanned += nr_soft_scanned;
-			/* need some check for avoid more shrink_zone() */
 		}
 
 		if (!first_pgdat)
 			first_pgdat = zone->zone_pgdat;
 
-		/* See comment about same check for global reclaim above */
+		/*
+		 * Shrink each node in the zonelist once. If the zonelist is
+		 * ordered by zone (not the default) then a node may be shrunk
+		 * multiple times but in that case the user prefers lower zones
+		 * being preserved.
+		 */
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
@@ -7161,8 +7141,6 @@ clear_reclaim_active(pg_data_t *pgdat, int highest_zoneidx)
 static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 {
 	int i;
-	unsigned long nr_soft_reclaimed;
-	unsigned long nr_soft_scanned;
 	unsigned long pflags;
 	unsigned long nr_boost_reclaim;
 	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
@@ -7268,12 +7246,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		 */
 		kswapd_age_node(pgdat, &sc);
 
-		/* Call soft limit reclaim before calling shrink_node. */
 		sc.nr_scanned = 0;
-		nr_soft_scanned = 0;
-		nr_soft_reclaimed = memcg1_soft_limit_reclaim(pgdat, sc.order,
-							      sc.gfp_mask, &nr_soft_scanned);
-		sc.nr_reclaimed += nr_soft_reclaimed;
 
 		/*
 		 * There should be no need to raise the scanning priority if
-- 
2.53.0-Meta


