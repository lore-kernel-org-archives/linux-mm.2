Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46408D5E15A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAC36B0089; Tue, 16 Dec 2025 09:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75466B008A; Tue, 16 Dec 2025 09:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1F96B008C; Tue, 16 Dec 2025 09:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88AFE6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:03:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 351CE1406C1
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:03:32 +0000 (UTC)
X-FDA: 84225501864.19.94EA36D
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id D1C84160023
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:03:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=h3DzlrXK;
	spf=pass (imf08.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765893810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InvdrRFrXQJFqVg8lDeFoDfygxUx+JgnbS36d8q94EE=;
	b=uKed9X0bXhewMY+9lF1+dZ/INaZUuaK5i/P2NKFNFjwpe566nJ7+P/GiDi/+crTdpeTA/V
	HUrxk4/sh9Y+w4o58CiFbyiMfYfepQ86WiF4drAU+a2ZuWylMt7lSU04Rs66RxbttUjTq4
	OmfkDsk3tMZZMVexv8jYWWGyzEYYoRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765893810; a=rsa-sha256;
	cv=none;
	b=KA+p+jsVRdl9K8DzeNaCEOK5M0/1auC0ZgIwnPMXzJcAzB3n5CEeFWsXfoSFTGy8qeHsIt
	CSYrjKobxcA86pNHwQ8eq3KcytLwGw3buTSDoaOP97wJGEflJl1xJ+FqKXafuYxRpuosKh
	cqm1phV0peX7iyhd/njPxeVfAMnaeJs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=h3DzlrXK;
	spf=pass (imf08.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [40.68.199.203])
	by linux.microsoft.com (Postfix) with ESMTPSA id BF667200D652;
	Tue, 16 Dec 2025 06:03:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BF667200D652
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765893808;
	bh=InvdrRFrXQJFqVg8lDeFoDfygxUx+JgnbS36d8q94EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3DzlrXKYcBqZyrL8w1eUpybZSaMOWave9betCetAwflEOpZLs9OUzMbhPSYJs+T1
	 ZAS/s5H59bqUJgbNDt+5x7wfR7eij9W6e1ZwfTbRB7x80f4uoxQv1keNTL12DzU9O3
	 SBVpKEIE8eVeHZ73kVHb23Y9UXpBkxpxaPdsex0I=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Date: Tue, 16 Dec 2025 06:02:51 -0800
Message-Id: <20251216140252.11864-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251216140252.11864-1-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
 <20251216140252.11864-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: huajuefq3w78xm9mgqay7p53d89qeqk9
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1C84160023
X-Rspam-User: 
X-HE-Tag: 1765893809-921556
X-HE-Meta: U2FsdGVkX18CZ/2+L7LCWW8WiRgCb9m99zV/J3LT4+ANgANSjGDBjtfrGx5Z+cJ3kqsOO4+BgpyFshe/iF7Rry5/N3Br6u3FaK8zEGtp0T13zrwnZNM6q5skYIa+bJNgcdNDPI5W1pWiIEt7rXypSrv3ttPx5x6+zZlvAU7Y85QVHtcWSBwdgQ5xo2XkMmpIi/awiZgNB/VQ+yzpKclDvXa0+czIlc3LZ6lcUcZommTuyDd6hpfEHyD29tkQSZdLn8QjUKccaQkSLTqOYqPBMqxNj+Dkz49+F4fpg5oHq1hMOZdeGgveH4r3zcoQ4lmLnWLOjRTdoOoaj6BkfLfWTw0Yfz1hFiXM6DFCqdBnUyB2Xu35rqh+RpaOjC5u2B1AGZC6kChqNtbKdDaYzEfBqhUVQJgSWWbL0+M2dOuVhxiFShSzAsytB6rBkV2R68msiXQTDYR7rvnxBf7mo7L/D+dzGjq9vNvVMf437dE4D+7i/H4GPi0cWoLtE0tfkOK2CzgF3HuBg3lXyPEyNIm62VhNC3bUiXOKMc68yx4tGOx5Dd0pq69b79lQuYpXXGIWeNpUsG3v0DARL9OwQ8zXnTRGqJfooFY3QLSIi21NCMx3L9SH5Lid59ZCp7xmfZo2rUjR57NQY97N1vGBWKBcMiumfJzw8IDJE/nvTHab+4flmfFDyt+WnX9feua9Xtw3T33KA5IxO2w7pFmiievGppHrjnxQxXhNxSz3f+bpdELtnqrXNJznhFqeL8KrmfPBXP88ypcw07qQ9+gWIPfhErqbWi9q12KdyRmOD7DU/7RH6VhI+hbm3/y0XwSXlGH/wPauRb+rpwU60BuPBhTEiLxTyuhhEJNy8sZbd3yLGtiIUlVXNghcx/wz1KwbNN1y79QiNur+JNBdjr83oqmXvSpcp9Q+JLAh6VyJgeLx2kvMYTbdH22NUx539JBSCPBIXq+D0Cs1IqQsGMpaoLl
 rgfZgwOk
 1oC/w7dUSCEbgZIi83RUUEN7mGzyM5+NDmb75KpT5oeueD+EgX2r44/dtuO2w3jgQKuChQlTnIcZPNztTzgbeaLdAlQESjFhmzKb3OaNpx5ciP5XziZzUHmAHStp6lk0iycGFl/xU30sFOLyiQXEZERO+P9r+IwoskEdgax54L0t9hh/takCkcEP8b7Zwx+h1acjDF0kxc2MFEM1NlJgYik04G+WREXndvWfyix0jIPrPJwjofZqQ3sErUns5WQw/n2zwj4D5vwMy5FT5hK8glrcMYRoOf3yp2dAm
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


