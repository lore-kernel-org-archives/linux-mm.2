Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38756D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAC96B0007; Mon,  8 Dec 2025 13:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963916B0008; Mon,  8 Dec 2025 13:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743336B000A; Mon,  8 Dec 2025 13:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64F1C6B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:14:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20BFD13A0E6
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:14:29 +0000 (UTC)
X-FDA: 84197103858.25.6A66CCB
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B93D40013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:14:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=JhiqhJM2;
	spf=pass (imf12.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765217667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InvdrRFrXQJFqVg8lDeFoDfygxUx+JgnbS36d8q94EE=;
	b=nt/EaN4zXBbxrtMV5+c4dJpgm6EuVzH0NeSWDnPVv04t1VML3oSX/OcqClU0FJmMYkreUO
	26AFTOtYkhYzcGD3v724rPxmkSCpkDULo4S6NdcmqyXV9+DHWDNs/lYVDpYcgu6VQhvL7J
	mmKv+BkkxdwSuTCfENKYyoHX2amogFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765217667; a=rsa-sha256;
	cv=none;
	b=lfpW16RGrmw38YqeYGxz50CRXMT86EkfGfhM9R5bMWMfojPsmZRCCDPsRsm0EzIzEHAI96
	sCUK9fwNrQdv9AiaG/v2MjNibuTkwkDjmo4rqpjZlnKzf4oArTB98bcVTlaytok/WmdpLB
	QNLXKiZ6BDGkX+7NuxlKsykbKkdLqCo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=JhiqhJM2;
	spf=pass (imf12.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.lan (unknown [52.148.138.235])
	by linux.microsoft.com (Postfix) with ESMTPSA id 072E32116043;
	Mon,  8 Dec 2025 10:14:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 072E32116043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765217665;
	bh=InvdrRFrXQJFqVg8lDeFoDfygxUx+JgnbS36d8q94EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhiqhJM2u5tzc5NRoGeTIykMccIi//sq5h+Nt1I9Lnag1yWsGdu4gbzgEkMVeNJ1b
	 DhZGFSgi/V1R11okSVyfih8Wcpm48KGwOnMosHes3gLWx8/RBBqy8tAziGrl/z4PdD
	 6j4rkoMg7uH9wPJvikQsvFc1awg4BGRMGqulXCeY=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Date: Mon,  8 Dec 2025 10:14:12 -0800
Message-Id: <20251208181413.4722-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251208181413.4722-1-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B93D40013
X-Stat-Signature: pqn8ycj43axtmk7ftqi789c6sfwtr47e
X-Rspam-User: 
X-HE-Tag: 1765217667-825507
X-HE-Meta: U2FsdGVkX19PYdxcr/5Mqi9I57HBux8WHoqKvJzQBF0wyit8IWuCKhy4T3m2A1dD6ua68ac1KSuS6r1R/2L/yGdX+SO4khuwYG2SlPhj6JMuRktH72exjscaX0tZWwqminOeTyJIHd/eTZK/hDmC28KVgKNd6RB636BDRhO10N7qlPlX6MDs4mH9HI7i+ipt5qyxzGkgiz9YXQG06068iiOuBNaNtUNnDDtdo3uhW9cEv5mMGPOLDtUsNMNtH747cQ3Um6O3589gzwuJoLHirhEblQlpgDqY6o9lx7ZFkOonxKfnf5UIZA0D9VDagO4RH0CmNxQBefKYgo+CMHBXfRjJ4Wp2cQu0mgiGH+/rdtSgQd6R6ILc85bAduyZ1hbh9vgVPCSjidOVC3AZ9bNCeai6eqU+SE/4yBpKz8X9uewuGpuEOuHkmimq+EY9RIsx/I0ze4LUlZBFszTsR2/gpfTOKrQ5PVukqfIubpv5jyEvtkaxdbeZpx/DjgKaTonqE8vr0rxuA59MAnEto1y4BFFbmLrokQW7coWjBIaR57K8/XSGu54puc/hDAxZARuA1aG6Mm2mgVz489MA9BvR7KUSx+sfuhbIiHG8SGP/hpc650dzeXuJJ/60wGguZcmquZMR82nFee5NDw44dLeAx02L1+HdCchuJIfyS2ksTdLUTL8ShCTm4UdAFU7qgAZev7x/zlBMHHOSZ7qKAGLpAu+lNBV+/drM7ZBmpojhGhJOkyNokHKAinN3sk1rnpi+q5hmBXRUkUo3+pr9AS07w9hAYGZvjp3iNU4/HsH0RDdN0D5ql9xbPZU/Xsm7UFU8s0ho+uOBGlzB8unffhiIIWAXrMd+1VZyvMvIoj1Wz3hrAP1eti2e9Vb7WlT8DwWjyCbwBuJHuEGBDqVbcUYEyQfaVJw43bPBrEFk/oXgt7YUbpLwuO1IUEVu5XsPqqYutHBO2VsUND9IEAEVEE/
 z5k2IIob
 5HiORcZTb8ugldsELgL7VGp0yAbVQel8Bfg1WBs9w3AosxK8T4HVEk+zq+PUcPc0Ii4BOoneU2umfwYMTllMrGneS7oe2CWhzbQ66G2N7i2+wm/nAqsyAwPeXxUoS3mI2SJevxNiuZbo1xTiDMZrYq/tKjjgTsc9kqurIcwDzx6m9B1e3k8qI0rzqdSyhz/dJWhg+bcCUlv/KDe0+nRRAKk/rLqsiuXj/y78AG7fInLPYVXFqO5CiVoSNsA==
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
 include/trace/events/vmscan.h | 65 +++++++++++++++++++++--------------
 mm/vmscan.c                   | 17 ++++-----
 2 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index d2123dd960d59..afc9f80d03f34 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -114,85 +114,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(int order, gfp_t gfp_flags, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags),
+	TP_ARGS(order, gfp_flags, memcg_id),
 
 	TP_STRUCT__entry(
 		__field(	int,	order		)
 		__field(	unsigned long,	gfp_flags	)
+		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->order		= order;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
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
+	TP_PROTO(int order, gfp_t gfp_flags, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(order, gfp_flags, memcg_id)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(int order, gfp_t gfp_flags, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(order, gfp_flags, memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(int order, gfp_t gfp_flags, unsigned short memcg_id),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(order, gfp_flags, memcg_id)
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
 
@@ -209,6 +216,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(struct shrinker *, shr)
 		__field(void *, shrink)
 		__field(int, nid)
+		__field(unsigned short, memcg_id)
 		__field(long, nr_objects_to_shrink)
 		__field(unsigned long, gfp_flags)
 		__field(unsigned long, cache_items)
@@ -221,6 +229,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->shr = shr;
 		__entry->shrink = shr->scan_objects;
 		__entry->nid = sc->nid;
+		__entry->memcg_id = sc->memcg ? mem_cgroup_id(sc->memcg) : 0;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 		__entry->cache_items = cache_items;
@@ -229,10 +238,11 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->priority = priority;
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
@@ -242,15 +252,16 @@ TRACE_EVENT(mm_shrink_slab_start,
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
 		__field(int, nid)
+		__field(unsigned short, memcg_id)
 		__field(void *, shrink)
 		__field(long, unused_scan)
 		__field(long, new_scan)
@@ -260,7 +271,8 @@ TRACE_EVENT(mm_shrink_slab_end,
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->nid = nid;
+		__entry->nid = sc->nid;
+		__entry->memcg_id = sc->memcg ? mem_cgroup_id(sc->memcg) : 0;
 		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
@@ -268,10 +280,11 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->total_scan = total_scan;
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
@@ -463,9 +476,9 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_node_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg_id)
 );
 
 TRACE_EVENT(mm_vmscan_throttled,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 258f5472f1e90..0e65ec3a087a5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -931,7 +931,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	 */
 	new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
 
-	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, shrinkctl, freed, nr, new_nr, total_scan);
 	return freed;
 }
 
@@ -7092,11 +7092,11 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(order, sc.gfp_mask);
+	trace_mm_vmscan_direct_reclaim_begin(order, sc.gfp_mask, 0);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, 0);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -7126,7 +7126,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.gfp_mask);
+						      sc.gfp_mask,
+						      mem_cgroup_id(memcg));
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -7137,7 +7138,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, mem_cgroup_id(memcg));
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -7171,13 +7172,13 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask, mem_cgroup_id(memcg));
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, mem_cgroup_id(memcg));
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -8072,7 +8073,7 @@ static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned in
 	fs_reclaim_release(sc.gfp_mask);
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed, 0);
 
 	return sc.nr_reclaimed >= nr_pages;
 }
-- 
2.33.8


