Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08411C79FA4
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60ACD6B0178; Mon,  5 Jan 2026 11:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC896B017A; Mon,  5 Jan 2026 11:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5192B6B017B; Mon,  5 Jan 2026 11:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 367806B0178
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:05:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE5F457391
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:05:19 +0000 (UTC)
X-FDA: 84298384758.28.4E5FA11
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id DEE4220003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:05:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=MWuhD8hI;
	spf=pass (imf13.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rI0TvHgUv293a0UICu/+AtOCRmV6zkuUTLQ0CV2rzpw=;
	b=eEs2DZBRVquOV6LgdehRcP8wt7wwzta11O1hyZ0wQmCrB0BhRKL2t8YGQvElx/uhltiJdu
	bh0ghcQpfMl3Q5v+Psack5GzXGqgwYDmbYZZukqbJPk/u5AWMYLiF3pr7KdYicwgXGTY8F
	nOAvIObxUINGc9waBEE8YRRjBHLJAWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629118; a=rsa-sha256;
	cv=none;
	b=vM2uPFLxjHhLRhKnM0mfON1oOx3Cgiv9Ujja/bIHrdosJz7rs1uTu9f5mXscj96O0gERF5
	ucBDkz39AgooetJN+rR2sUuLccf5gUE4IkKkXJ9j8WWKKZ2fkeSxCeLo/BO/LtGMycpryA
	5UTt0kqiKcq38NAmE4YgYXH9XiDL2+E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=MWuhD8hI;
	spf=pass (imf13.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [108.142.230.59])
	by linux.microsoft.com (Postfix) with ESMTPSA id DD35D21260D8;
	Mon,  5 Jan 2026 08:05:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DD35D21260D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1767629116;
	bh=rI0TvHgUv293a0UICu/+AtOCRmV6zkuUTLQ0CV2rzpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWuhD8hISYwGkyIY9yc+wREPaoy+iYjQcBOz9xqtN5sk5pMu7PiSW3UdYPxxaPgYZ
	 ZzpTZ/LocJTZssPGPFZcLa1qNo0HOigK/L4rc1QUkCfLtkOCpwaMZGm7WgbizqrOYo
	 WoiHZGubuDwp4pHpPJyWkFg0pdTdbyYUEU+82pBU=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v3 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Date: Mon,  5 Jan 2026 08:04:22 -0800
Message-Id: <20260105160423.23708-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105160423.23708-1-tballasi@linux.microsoft.com>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qarn61o1xuh7prsbt4kk9z547i1zjibi
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEE4220003
X-Rspam-User: 
X-HE-Tag: 1767629117-388925
X-HE-Meta: U2FsdGVkX1+D+vcwWV4/wWrhQrbfVZ2eins8pV3REzqnij6y0VsGeUTBSrmxzTxE5zunK2WetmF1aG6gmRzUsivu2khRb6+tEiwlYHs612P+L2tFD6UB4EmX5PZdx7cNQHlFTYD7zG21Y//8ES83zzE/0CmsJylsqwFzQtOb0Qhz3CzXiBbCCGFvfqNocmahbGzgGNPv6YhJ638K9yWCHtsbm5wN+T6V0zv+MaOPEdDJpptF5nwZITFSuYMM7/9qHsuOaT8SmnNIffRM/D0fGwYGLWKV43YVo2thbk2rsiEiavs1nhP8Q9QQqSw7/H7PUS6KZU++dDPxOnIbO25S9wvSgPjPEZGeefjNtRNnv+kDG1lnsqWmrWt3VF/bN6ZwEYC3kVrmXrZf5APtus40c6ltCX7bZRQQMax1aJ56Juw3BRB/NO9onvIOq6APADLn6UZC4O9I7Ml1WqG8aovbmBBBB3j7cwEoEY57p3WzoP32C5TXqTRxTQYa/1LhV6W3cov7SvUGMahOIj/HhMZwQ274w4ppFxt04yjFL1wZu8cP2aQEr/zXM5EP9Tw1kblDzmiDqkqdqarT35FGLjdWOwNjC4goDgKmmi8DmOO+DaLXeyEX3Wlxu3Yggcbd7/9un9prxxQrK0jaC3g4FE+H9Vaq5cI8QAnAQTDBrFbYav9rYlttsH9VpbsKUQwILhaW2Yd7AXwSl9X1up5kmolLqphPKNM5La5dyUXsRbKaBMP2O3UoMvYLrZoP1pAeNjFh7PaFE7ffcqbTPlDptAOkbSw5IU+d+hAycSxHhV2QRpO0KB0D+2idMcGltSpTLcpOhaEbOufhZ2QPeCF+pPSMoacqhfhcLaUiDPrdltKtVW7a30cNAsIBGR+AKk/aQcnHKSuR3snuznUom1Ei8oOoioBcZlkeErewkv6G9LEzk29LbiSZE2Wqo13wG/oHeGoQAFaaFnkOzJBm9jfuLtO
 VCf1CoH4
 0l49Vyobr9HNxUAxz+eWmPfhCiDlk2QcdHunabJbozHOn1SHFhT85ktLIX+dTf9q8I2nOveALavY8zIWK+3L327/485pF+xKG8jCX4gsYkpw7uXp4ClhimNq7J9DcTl/Kp8i8zTZadTMqNocGzNn1riII/UQBl5afCI6MSdldNkZuC2ArKM/ZrLSHKoTOzxCgdn3KdwQjKw8NlvNrNrTMPVKuhdMYowWasbW5SUElmfJoiXRsYXaMeBexUtsiq92cCVBFQpnqoVNu/8klHqeaZ3z6kMWcjjPg799g
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
 include/trace/events/vmscan.h | 79 ++++++++++++++++++++---------------
 mm/shrinker.c                 |  2 +-
 mm/vmscan.c                   | 17 ++++----
 3 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 490958fa10dee..93a9a9ba9405d 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -114,85 +114,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags),
+	TP_ARGS(gfp_flags, order, memcg_id),
 
 	TP_STRUCT__entry(
-		__field(	int,	order		)
 		__field(	unsigned long,	gfp_flags	)
+		__field(	int,	order		)
+		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
-		__entry->order		= order;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
+		__entry->order		= order;
+		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("order=%d gfp_flags=%s",
+	TP_printk("order=%d gfp_flags=%s memcg_id=%u",
 		__entry->order,
-		show_gfp_flags(__entry->gfp_flags))
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg_id)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg_id)
 );
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
 
-	TP_ARGS(nr_reclaimed),
+	TP_ARGS(nr_reclaimed, memcg_id),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
+	TP_printk("nr_reclaimed=%lu memcg_id=%u",
+		__entry->nr_reclaimed,
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -208,31 +215,34 @@ TRACE_EVENT(mm_shrink_slab_start,
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
+		__field(unsigned short, memcg_id)
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
+		__entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
 	),
 
-	TP_printk("%pS %p: nid: %d objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,
@@ -242,36 +252,39 @@ TRACE_EVENT(mm_shrink_slab_start,
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
-	TP_PROTO(struct shrinker *shr, int nid, int shrinker_retval,
+	TP_PROTO(struct shrinker *shr, struct shrink_control *sc, int shrinker_retval,
 		long unused_scan_cnt, long new_scan_cnt, long total_scan),
 
-	TP_ARGS(shr, nid, shrinker_retval, unused_scan_cnt, new_scan_cnt,
+	TP_ARGS(shr, sc, shrinker_retval, unused_scan_cnt, new_scan_cnt,
 		total_scan),
 
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
+		__field(unsigned short, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->nid = nid;
 		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
-		__entry->retval = shrinker_retval;
 		__entry->total_scan = total_scan;
+		__entry->nid = sc->nid;
+		__entry->retval = shrinker_retval;
+		__entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
 	),
 
-	TP_printk("%pS %p: nid: %d unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
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
+	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 TRACE_EVENT(mm_vmscan_throttled,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689a..e3b894c20bec8 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -461,7 +461,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	 */
 	new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
 
-	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, shrinkctl, freed, nr, new_nr, total_scan);
 	return freed;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3df..3ac9f45461795 100644
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
+						      cgroup_id(memcg->css.cgroup));
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -6687,7 +6688,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, cgroup_id(memcg->css.cgroup));
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -6723,13 +6724,13 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, cgroup_id(memcg->css.cgroup));
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, cgroup_id(memcg->css.cgroup));
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


