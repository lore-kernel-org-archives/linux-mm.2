Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3809CCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 03:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB806B0104; Sun, 18 Oct 2026 23:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3366B0105; Sun, 18 Oct 2026 23:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9116B0106; Sun, 18 Oct 2026 23:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 859A16B0104
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:53:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06AA6120605
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:39 +0000 (UTC)
X-FDA: 85338006558.19.322AE36
Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D9A81A0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JkJGySxW;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792382017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAi0j1XsWXq6yK07r36mG75YAN/1gbhRfMECxYZCQn8=;
	b=1EnJW5JMBkwm0J0knD0UYvskL+JGkYJqgGHfrXniEHvVR3pFd3TBxMe87FaLjpo4XI4UhZ
	zMPSaE4A1tThGqFBUxr+7w4vx1Pln0flk2CFcYrf3Ob6+UqJ1MNHzp/M/ebKexxONWhmJU
	obJr6hazumDJrEkxVBk3haJ3WXF4PVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792382017;
	b=0NE67AkfJ1Gsmdj8/wsR3FDzUKz1X3nTv/a0dfb96wEiT8h93xNGmsTa67j+KIwGprrmUr
	vTC6gNV3uwAdiObOH+60BXnsofO4cZFiFRw2pBedj1cnATL/wMt4HN10cM8XtRmMu/DAa+
	gRNIiRmyjfHE7eCcEXPPsCta0Nh/wM0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JkJGySxW;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AtApVs4y/DcK1VhFwo4n+80r7AMWjpD6/0wGQReG9UU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792382015; v=1; x=1792986815;
 b=JkJGySxW1033tLQJ05zc0hVyiAF5hjwu8XR4jiTDr44uNfn0r3cbM6bA0pip529JAz6svpHf
 ZgbTzt0rjl4JFzZhNuqTwSRiBBSx1HR1pfzH5ImpYv+/ItjusZBstsCFWgZpBxhyOqjOh4Dqr4q
 CX4fGYWeuW1CcMMyzLVD7J1M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 356f95a479b725c2;
	Mon, 19 Oct 2026 03:53:35 +0000
X-Mizu-Trace-ID: 356f95a479b725c2
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 4/9] mm/vmscan: pass scan_control to the reclaim-begin tracepoints
Date: Mon, 19 Oct 2026 11:52:47 +0800
Message-Id: <20261019035252.2357900-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D9A81A0007
X-Stat-Signature: qo6wwcc9uaantounmjdisrhdbh5rnk4d
X-Rspamd-Server: rspam05
X-HE-Tag: 1792382016-16936
X-HE-Meta: U2FsdGVkX19avMUz0e28gBoAaOrmOOLnX8teUSGCe6DbGKJigEH3UORX8k3ZdjG1VaCXP9CjiGw32Hs4Fan0HCy0KUT2/HfiyKeYYTc0xw3wxVSniyWy+jZmUr/egAtB3lBq2RbOXmcp/cGEZKxTcyRf6+Ps7jLz/P+Fc3fdCmlgjFUfe/ZxkhstfZdWQhRyeEYQBHfasuT1dlj5qEIMna/ClVIpUInVCEFcvTzgosIR+vaR/5qeJQjx2U1GwYrBPdB4Z4HtFicZAkL2Y/5UggURGNENMOF4mvQxdWTOUcV2QN/xp4Q2gCvHg28pl/AGgj6b8Mmm1RIpT7L5lwMX2phHYT3hc5yMxgKFy6JbyRqL+5fm2kxIKaJRo3i+f+919ypmDEkusZYMkVdyQCmIXQvlDcvyBN3tkEHbh32p8/YmMtbxYkVm/GAitMkMGZhYoeeNnPB162IGz3pz9Emq/Z9Tz4+y/bMrEtgoTU/ChcmpuzqvS4cLlSqFvT0pIHa8jtDUZ8wGQa+AP/f3DdczfyKFFMSXrmnt0nix0sFH6JrPI4VScJTB6pYzzFGH5Hn4gcSutpoupQv9KW4TVSdIKNRpMn0I7RPccqT9SSN272YoyfXgVJlK8crg1KUnyiO5i8yprxLXK49krQn5tgRzUIAZnpg3xeXjZz5f9dIzgUhHuwrIhnTtQ2q8A19ME5mxB1a595LV1ge71/+lOTHCOlEiFT+HnXhjZzRg/sc8UaO7wq9YABxRWKCDDnpPDUHcyLYAMS+hkqTHf3h6gnLYoYCxrJchtvdMEJTmSyglnmQVnvbE2hIpIC8A2eAWt4G2Augk523Ajgud8WZWTsW2k5zeJ4K5aS8vBQi+YWKElIGwUtoRACJ36FN3X/jIa62yV/MpVMskCtd+hYU6PFTcJSzXO7Zm9cxrCU7PFwQ413RyPbRm1dmI9pjW1L2PEpLksd5oI4vczBhrQArp4vT
 V6IEX45z
 Mqvg6MphwO9gqCb1qhqCoAirXdk9+c9DCxP3bfd0gH3jpAuEkzWZKfFVDhkG5Hfr7EdlYBeprXRDT0idIsOlDdf+E0RMIF0zU2G5lHwwN+20gFBLIsEyDgKL73kOgrkaKUT3VxHkZ8wiVa01bXQjiRl97Jcbc7LyDADUdrq6imLfZrRVdYWM1ZwgEMSy17gCdydHb2gzjV6WPZUEQv2IhU3KOtr5V+fc1xjGERr9NURVTvQW7X/LQFheWCtx6dkZxmsNNwCWYV9wNC9VtUOvs4bJMtJKpmPHT7LZsqx329TuLdd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The reclaim-begin tracepoints describe the entry conditions of a reclaim
invocation, which struct scan_control already carries. Now that the struct
is visible from the trace header, pass sc directly and pick the fields out
in TP_fast_assign instead of spelling out gfp_mask and order at every
callsite.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 24 ++++++++++++------------
 mm/vmscan.c       |  7 +++----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 3917e1b62dfa..db4590356845 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -178,9 +178,9 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg),
+	TP_ARGS(sc, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
@@ -189,8 +189,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 	),
 
 	TP_fast_assign(
-		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
-		__entry->order		= order;
+		__entry->gfp_flags	= (__force unsigned long)sc->gfp_mask;
+		__entry->order		= sc->order;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
@@ -204,17 +204,17 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg)
+	TP_ARGS(sc, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg)
+	TP_ARGS(sc, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -551,9 +551,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
-	TP_PROTO(int nid, int order, gfp_t gfp_flags),
+	TP_PROTO(int nid, struct scan_control *sc),
 
-	TP_ARGS(nid, order, gfp_flags),
+	TP_ARGS(nid, sc),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -563,8 +563,8 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
-		__entry->gfp_flags = (__force unsigned long)gfp_flags;
+		__entry->order = sc->order;
+		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 	),
 
 	TP_printk("nid=%d order=%d gfp_flags=%s",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8b8f4049e278..e064354ea24f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6884,7 +6884,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
+	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -6925,7 +6925,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
+	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -7881,8 +7881,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	unsigned int noreclaim_flag;
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
-					   sc->gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
 
 	cond_resched();
 	if (!sc->proactive)
-- 
2.34.1


