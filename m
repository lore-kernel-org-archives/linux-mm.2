Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF92DD4117A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E71F6B008C; Thu, 15 Jan 2026 07:38:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE5E6B0092; Thu, 15 Jan 2026 07:38:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4D46B0096; Thu, 15 Jan 2026 07:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03B466B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:38:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC02F13A858
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:23 +0000 (UTC)
X-FDA: 84334151286.05.B67D181
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06E78C000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=FAfQLMKN;
	spf=pass (imf22.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrCywMgmAMKu0qlSlnYCkzHJvrHK6AYgpW9R5wGTiNQ=;
	b=wkLej1vF9ydeEpDVeCA+Z4dWpqd87RJCKSfNktzc7Q+XUgL8yH12m1wnGIpVXhWPYDt70v
	Ql2tzgYHthqBlmSBizVm6HYoEJBf8SH1Fo53Jd9gHCu/Ei5ukHMIummhCZYeK+QvsTGLl7
	hdMVw7UVb8tN4rc1frl8n4BduY8TijM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=FAfQLMKN;
	spf=pass (imf22.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768480702; a=rsa-sha256;
	cv=none;
	b=LYDf++65Gu4kp3oaRiZ7Lidg8UMH7Wy4qHOKEJUiRFgjjDPtkXrTyDwKW/uIkTaJszOYua
	8EZjHS4O+Qnm8MKyHY7ZRUhovE+SC4IEMQTLXdrflitbPJfzdm7kVqLXwH3FtwJ16AUK8g
	p0lXxREO9EBZX37deXAbLgHrQuxGO1c=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [20.107.46.209])
	by linux.microsoft.com (Postfix) with ESMTPSA id 72F8720B716F;
	Thu, 15 Jan 2026 04:38:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 72F8720B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768480699;
	bh=UrCywMgmAMKu0qlSlnYCkzHJvrHK6AYgpW9R5wGTiNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAfQLMKNMMSyabwx3KR9LeQhR8LB5jESvqyRhpHus5uZTlM0TFMWjlHe0wphUGWkI
	 iSG+OJVSfGZQnah/dWVWUahKblhCbksjHbk2WJaBJd3TmY0foAN/0m3joztFJ0sdwv
	 YdB7EWWHNvp5cAxhAW+2YrLbX6PkMbBi6WzuNxTs=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v4 2/3] mm: vmscan: add cgroup IDs to vmscan tracepoints
Date: Thu, 15 Jan 2026 04:38:08 -0800
Message-Id: <20260115123809.2257-3-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115123809.2257-1-tballasi@linux.microsoft.com>
References: <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260115123809.2257-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06E78C000C
X-Stat-Signature: h8kz8nf4ips9xr1ne5a1qgs8zf5nc746
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768480701-398324
X-HE-Meta: U2FsdGVkX1+FV1BS7OBfmK5cZp3AZp9IKm5etiOxcohqxIw1sUvi96E1RuUYedmvgZfJo/l/JCpUCePnSU3myclFLUgWx6vqrl9ncO7yiHPuDrX4MQD4+lWi1TPLs59wREtTMUzHCYnyD+DWdZb9AOqfzC7JMSYx9S5NbS1GyKalsZduGjryOlTRXmye4GRGeYvt6mcEXm2cm4sohIL9yvSsQ2E/vWrNftvk/SVxAlJooWZROR/YV0591xenQj06mvEv2/slSunxzw/myn0WvxjChK8lQK7KDdDltel5Es8yUxhFE6QTSoTMtr5KRkLU4cNB00/yrX4a5EWO6+vX2LiKQRkYT7XbFud93Aq5s7Ni376Tdiv4ceaZtrff7WvkJtnl+iKC6KFRhooAQEPEg+3tAwQ30eKSffus1+EEYDPQkUU4QCfNAVKC0yId9eNQm10WUjl9yE5RE3scm/b5rYOs4j2+elcYBf/u2AWfEO9HkXIm8LxfKBCXKcHHrMYt0cpbDkrwN0YJCoHBmewkmdqnhHFv8dPG4RuYiv2clyB2jzHFYRmePHOfQlfvByBOWkjSyL05CkGd6X+y3+wOClvOvz6muewm4UPnr7VqVRTt2xKrtYl9iJ1ceryJL90OOfRnyJSekiu4Z60e49sq0/iMK+WA9CdozsIWt3ESrHFEzaTKJdWW62LLctoETfjFKh/3GhrB7hJ7NX0ZjW9x3E36/RG+3bXL1SJaK47WxRK8g4niwcEbXeiqj05TEzaC6QvRfRMsPEAr/HtVSB1L57xm/pdJvlkYqD7fHGHTdMStBbvxK6/OWUKwVHsZE6exQ6jZ1oO57RwcTeimk2EDDwnWMsItETNd6Zq5n6HAhtJ9P2YS8E4viHh4hLav4HajyYMvhL8G+ucE6wEg3vSTKJhh5dUKdpVVeaTtCqT9aSsY7iRu/yN+hidgrByCJKufrmdsVfH3XDNQID5LCI5
 LA+8ot3f
 tCnTz0fHQYX5xO74lSf9yJxv8FULk5qc7zyHqMU9yFPkaJBAcCVSRJxvr55lRsvcAI3GjT6BSj0sFWspjvdTYpKPM3gdvhwYIoEgXKsOF6ve1Saxxb29AXAU8L78PTKmag0RvZXdAXEgijAqsRa5cDhLMOgKhdSNT0VnrsbtSTT7ayLQzGItg1ZflMya0zvTxLeZuOo3LLm4DZyXPVd55WOHD2PvAjL0eLuOyEWlRbfdIbzcN3/jsejG2xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory reclaim events are currently difficult to attribute to
specific cgroups, making debugging memory pressure issues
challenging.  This patch adds memory cgroup ID (memcg_id) to key
vmscan tracepoints to enable better correlation and analysis.

For operations not associated with a specific cgroup, the field
is defaulted to 0.

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
---
 include/trace/events/vmscan.h | 83 ++++++++++++++++++++---------------
 mm/shrinker.c                 |  6 ++-
 mm/vmscan.c                   | 17 +++----
 3 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 490958fa10dee..20160e79eb0d7 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -114,85 +114,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, u64 memcg_id),
 
-	TP_ARGS(order, gfp_flags),
+	TP_ARGS(gfp_flags, order, memcg_id),
 
 	TP_STRUCT__entry(
-		__field(	int,	order		)
 		__field(	unsigned long,	gfp_flags	)
+		__field(	u64,	memcg_id	)
+		__field(	int,	order		)
 	),
 
 	TP_fast_assign(
-		__entry->order		= order;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
+		__entry->order		= order;
+		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("order=%d gfp_flags=%s",
+	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
 		__entry->order,
-		show_gfp_flags(__entry->gfp_flags))
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, u64 memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg_id)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, u64 memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, u64 memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg_id)
 );
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, u64 memcg_id),
 
-	TP_ARGS(nr_reclaimed),
+	TP_ARGS(nr_reclaimed, memcg_id),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	u64,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
+	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+		__entry->nr_reclaimed,
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, u64 memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, u64 memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, u64 memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -200,39 +207,42 @@ TRACE_EVENT(mm_shrink_slab_start,
 	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
 		long nr_objects_to_shrink, unsigned long cache_items,
 		unsigned long long delta, unsigned long total_scan,
-		int priority),
+		int priority, u64 memcg_id),
 
 	TP_ARGS(shr, sc, nr_objects_to_shrink, cache_items, delta, total_scan,
-		priority),
+		priority, memcg_id),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
 		__field(void *, shrink)
-		__field(int, nid)
 		__field(long, nr_objects_to_shrink)
 		__field(unsigned long, gfp_flags)
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
 		__field(int, priority)
+		__field(int, nid)
+		__field(u64, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
 		__entry->shrink = shr->scan_objects;
-		__entry->nid = sc->nid;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 		__entry->cache_items = cache_items;
 		__entry->delta = delta;
 		__entry->total_scan = total_scan;
 		__entry->priority = priority;
+		__entry->nid = sc->nid;
+		__entry->memcg_id = memcg_id;
 	),
 
-	TP_printk("%pS %p: nid: %d objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,
@@ -243,35 +253,38 @@ TRACE_EVENT(mm_shrink_slab_start,
 
 TRACE_EVENT(mm_shrink_slab_end,
 	TP_PROTO(struct shrinker *shr, int nid, int shrinker_retval,
-		long unused_scan_cnt, long new_scan_cnt, long total_scan),
+		long unused_scan_cnt, long new_scan_cnt, long total_scan, u64 memcg_id),
 
 	TP_ARGS(shr, nid, shrinker_retval, unused_scan_cnt, new_scan_cnt,
-		total_scan),
+		total_scan, memcg_id),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
-		__field(int, nid)
 		__field(void *, shrink)
 		__field(long, unused_scan)
 		__field(long, new_scan)
-		__field(int, retval)
 		__field(long, total_scan)
+		__field(int, nid)
+		__field(int, retval)
+		__field(u64, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->nid = nid;
 		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
-		__entry->retval = shrinker_retval;
 		__entry->total_scan = total_scan;
+		__entry->nid = nid;
+		__entry->retval = shrinker_retval;
+		__entry->memcg_id = memcg_id;
 	),
 
-	TP_printk("%pS %p: nid: %d unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
 		__entry->total_scan,
@@ -504,9 +517,9 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_node_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, u64 memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 TRACE_EVENT(mm_vmscan_throttled,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689a..ccfbe3fb3b378 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -410,7 +410,8 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	total_scan = min(total_scan, (2 * freeable));
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
-				   freeable, delta, total_scan, priority);
+				   freeable, delta, total_scan, priority,
+				   mem_cgroup_id(shrinkctl->memcg));
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -461,7 +462,8 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	 */
 	new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
 
-	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan,
+				 mem_cgroup_id(shrinkctl->memcg));
 	return freed;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3df..9a3cd975a9f30 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6642,11 +6642,11 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(order, sc.gfp_mask);
+	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, 0);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, 0);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -6675,8 +6675,9 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.gfp_mask);
+	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
+						      sc.order,
+						      mem_cgroup_id(memcg));
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -6687,7 +6688,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, mem_cgroup_id(memcg));
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -6723,13 +6724,13 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, mem_cgroup_id(memcg));
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, mem_cgroup_id(memcg));
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -7675,7 +7676,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	delayacct_freepages_end();
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed);
+	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, 0);
 
 	return sc->nr_reclaimed;
 }
-- 
2.33.8


