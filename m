Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78885EF99C2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 18:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9526B0005; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3B06B008A; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DED6B0092; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 931436B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F3F51A0638
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:54 +0000 (UTC)
X-FDA: 84440237028.09.4E0CFD1
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83C6D1A000B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bYtqJEkX;
	spf=pass (imf19.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771006552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDyWFdIJtNhC5hDziRtEOk+Pt3OXel3vxA48TpqXHRE=;
	b=imeouyutuCSSlo+3n3dmSIwQDcXl+HsUUYiD0w4yUMY65qGo1DCFueFtFffzFuXnQoFPAe
	Ac8gliKI6it6C7iMFKkwxUz1BLNhEwzdjRYCVLLj2dTdx4LCMU1cR1X1Xlp/WGVWCeR0zw
	SS3cNn9H3Ci68qi5cGxb1iBFRwJR4RQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bYtqJEkX;
	spf=pass (imf19.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771006552; a=rsa-sha256;
	cv=none;
	b=m+CLHhKHLZLwVH0jZG1oliV8gaYw36KRuRD+ZVkB+7t8xJdEisGFUjNseoxGRRGF+WAamQ
	uk/c/dg98qaSflVuqVrH5rEdoxsg13jYteWaWJ2yb+bt8GrUpG1L+dibzV0g7COA7lTkya
	Ln6AG+n3l3UeKFnWojWZTaKrRPN1GMo=
Received: from LAPTOP-U3CCR7C6.lan (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0DFD520B7168;
	Fri, 13 Feb 2026 10:15:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DFD520B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771006550;
	bh=VDyWFdIJtNhC5hDziRtEOk+Pt3OXel3vxA48TpqXHRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYtqJEkXBGlVOv6wRzFS4T/sDQRFf+Mc1WWPhh7D2B6ObnAjg4nm+KTDY8+ppzkfy
	 ypPuBE0Ae/gFBZ5eHY2SSJxQD49wgOKJgDomaRP6xw875/DKBqfjVvPdcjxVPuuZgw
	 qOo6MznpgqQTjS2ID7kNyrbRYPmLgl5N8ydiG6qk=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v6 2/3] mm: vmscan: add cgroup IDs to vmscan tracepoints
Date: Fri, 13 Feb 2026 10:15:36 -0800
Message-Id: <20260213181537.54350-3-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260213181537.54350-1-tballasi@linux.microsoft.com>
References: <20260122182510.2126-1-tballasi@linux.microsoft.com>
 <20260213181537.54350-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a1tk5s8h6sykeq6759818uydujqo7u9c
X-Rspamd-Queue-Id: 83C6D1A000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771006552-669322
X-HE-Meta: U2FsdGVkX18vo4mn/Kphtn/h072Hc4mM/qN4dWbKU2A2javOMs7vyOeQuRV7YFRr3r3P2gVFCvVMxWDOxWAbJQDr2A75ELrsBdsWZUiPG1xr8r3ZF4EE9p4xs5DkzcyoCrlFcRd7lD9lzfKswWMvrLBM8YWRj3u1m3MPW3e12F2gHbJYOSf4KjgWmL5Qgk2YONto7+TXmGy2llolTQ3CT28MAXeF/rF7Ud/bfrdp0bisWp+8IOe5HVZljBPbUzoUHilZdLDGaIbIntvL3Z49fveQZK6H1sDdbuRiuJt7J/POf7dQ71bJCeZpJ40jQnjRr9d18b19kc07QLMLaXO1/gNSYIzP5pbFYUgEq+ZVjwe5GDArZoHAv1gpq2b0gBhhRK18Si1ZOCpR8npRpYYct1JHFeTnvQaMatGu87O3oAv17bH1caIl+b4hi7rUFC+SBw7UeIoTXPSipGl15BbBGqA1+697DaylxObNz5qRMRZbKsIxd5L7C/aKCxTjsK7kj8dFQCGm3bfKjB1d0UjY5CElryDQtYIyq+uNw5/ONMO+V27ZDhhVYcTMXJ8PCpHKPdcu0KKJ2Lh5/m2sv5SWCUPfQFnxWD35tUWUfFDxKxfRyu22UtjtAORG+ZxaTM4TL36EDMjrHspKgPqdwCWAoWBvczv3XqyW88LWEyHiQjKAzaBQL8Uk6czDJdBulnY+xBcmZecXDhMHQfg1G4Hxag1Wrz1q5q/iSpcZT8eKv18WhitZEh6ntqwW0s6sp0jggCcEFzszURG44mdPMJ6MXBIlpAVVVshfICrm/L+XwTd+LcFunie1Twij2SWcQl0nbjWaawpquCutSp8Hmu6NSAKfDe6TuSPs56maNbYfOXgiZtECfBzCJ6iqJ37QW1kmXM7U8lTlfIEfJKDKofj1735bQmDhBjvsTptjEMXYHgNIHfDt/XEsOnXzUE9NOK/TWT5px/ULW373T8LfXG1
 +bmdOIOq
 orbBHTPaLkwS2w3hrzyY74H0zS62+cBuAsQ1T8AxoAkJsEtg2ngJz+xgQ3o3Z8L0yTRz6RxwZWaebNL0sA8A0jj+5a88JI61uka2P3rplz1T9MK6MrkPxMTAF0+1wVdcllyAl+M+T0ID6puRMosOTbS3gXMNCEkETEK11rN0rfTNJRtqKOG+tQ7kWY+yY7dxzrmQxra2q/JilScFgH3CL9SkQuoMt4Z+wAE4TUroZqwmFsax8zCdNmH3oxyIPUu78yuXC
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
index 490958fa10dee..1212f6a7c223e 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -114,85 +114,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags),
+	TP_ARGS(gfp_flags, order, memcg),
 
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
+		__entry->memcg_id	= mem_cgroup_id(memcg);
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
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed),
+	TP_ARGS(nr_reclaimed, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	u64,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
+	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+		__entry->nr_reclaimed,
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -200,39 +207,42 @@ TRACE_EVENT(mm_shrink_slab_start,
 	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
 		long nr_objects_to_shrink, unsigned long cache_items,
 		unsigned long long delta, unsigned long total_scan,
-		int priority),
+		int priority, struct mem_cgroup *memcg),
 
 	TP_ARGS(shr, sc, nr_objects_to_shrink, cache_items, delta, total_scan,
-		priority),
+		priority, memcg),
 
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
+		__entry->memcg_id = mem_cgroup_id(memcg);
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
+		long unused_scan_cnt, long new_scan_cnt, long total_scan, struct mem_cgroup *memcg),
 
 	TP_ARGS(shr, nid, shrinker_retval, unused_scan_cnt, new_scan_cnt,
-		total_scan),
+		total_scan, memcg),
 
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
+		__entry->memcg_id = mem_cgroup_id(memcg);
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
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 
 TRACE_EVENT(mm_vmscan_throttled,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689a..ddf784f996a59 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -410,7 +410,8 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	total_scan = min(total_scan, (2 * freeable));
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
-				   freeable, delta, total_scan, priority);
+				   freeable, delta, total_scan, priority,
+				   shrinkctl->memcg);
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -461,7 +462,8 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	 */
 	new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
 
-	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan,
+				 shrinkctl->memcg);
 	return freed;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 614ccf39fe3fa..9d512fb354fcd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6603,11 +6603,11 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(order, sc.gfp_mask);
+	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, 0);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, 0);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -6636,8 +6636,9 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.gfp_mask);
+	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
+						      sc.order,
+						      memcg);
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -6648,7 +6649,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -6684,13 +6685,13 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, memcg);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -7642,7 +7643,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	delayacct_freepages_end();
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed);
+	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, 0);
 
 	return sc->nr_reclaimed;
 }
-- 
2.33.8


