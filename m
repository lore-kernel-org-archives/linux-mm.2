Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B99CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC7D6B0098; Mon, 28 Sep 2026 07:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3AD6B0099; Mon, 28 Sep 2026 07:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6146B009B; Mon, 28 Sep 2026 07:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81C356B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:47:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B9611601A3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:40 +0000 (UTC)
X-FDA: 85262996280.22.99EE99E
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2966D40002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AO6/Qt+s";
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wh3eHsyROjpgzIt5e5+4RclebsmA35QP7s5hgqYgL0w=;
	b=xHMBSPtQLjwqSMfCjVkU4MaSXp5xHnm8xTZ2QnJydITrfcbxIA9sgJAgJlDpOHp+j6rGJI
	DvATAS4esMf+myHfe1KQuOLXkmxhMG8uxJSEOz9wTD65TorRF6tWHEo28icLUDAGlywh2T
	a62NcgX60Xqx3ANfE3a4zgdOo8ElzNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596058;
	b=TNiyD7E2wn7LxEL4gu3OMCk8uCyoCjvx1x6O9ptGP2ZdnjHsIMaAllYAsN0V8GXWNYKS6Z
	bXOt23obQBG7NX3jAQnUjLQQR2dREIJYtwRhzZhjeBpCxj6jMO1niDfb3dL3rvEL3OifqB
	tfbH+DqpYBrhjRkGtzUrf50V1HrSEz0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AO6/Qt+s";
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2ujtuvz8o2Cp7N7qQ7PelJhq0ebMgD0lcl5ObFFnDtY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596057; v=1; x=1791200857;
 b=AO6/Qt+s9nVMe6C2QfIsJKwvqWVBLh8QcY73jBUoKwXWWI9CmCyXIyIh0S8YDSokCbTvvmUN
 q7Fyd+LEQSVk6zBSzPsbCqT1SZcIEPTetpKg9p49vSnqZO9Gny6wYcBM3VboQWIuJ8r1j2GbK+L
 CARTcU49Tl+TAW8yQeLDWYSA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 72fbe1077ee4d1cd;
	Mon, 28 Sep 2026 11:47:36 +0000
X-Mizu-Trace-ID: 72fbe1077ee4d1cd
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v2 4/7] mm/vmscan: pass scan_control to the reclaim-begin tracepoints
Date: Mon, 28 Sep 2026 19:46:21 +0800
Message-Id: <20260928114625.3609130-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zx6gqqpyrksctncnrcrer3y49j9jssew
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2966D40002
X-HE-Tag: 1790596057-258051
X-HE-Meta: U2FsdGVkX1+tPzKdmciP4WN6xLzPRT2erutUbmNX8p2RL5/gDv5RYrwWLBSswfjrhmEWJDEqLhdYQrlbgL+yfZBUTdQeD5zmefJ/wROn7j60pBYzzTkbeIW9iZl4V4DguXMlqItf0OdC9DtFByY/i2xt9ICmCsyITGqE1JDcq43DRRkJMdvKjcVYYje23PBBTAgBoxs7OcoJfrdzrENRX3RyDvFZjAZf2yKtlSgJkACrpH2l33uQ5i2TTfT+p67so6HlwGQSlKf+Qi+tvjGobxUbFGYF/VA8T0Ejie37y63d5zaHKb3Y9byRnyTzJu0ndLMpw9xcrkqoUPEuAqcBARlVDx3YutsISJpfaquyvn50kUsg8z6eZ76Y483iCRUP5KLShnvM4X5Jtoe1iQpViETRJrUKQCoZ1lFqu/QnSrxIFNHG67KWv33+SrXIuwrhwUpVOxTVcXRRdgpE0WvUI6GwYEgZ1qkdMZav7yVHJP4HWjOSauFmzdwU3OkX7Tx3mFoGr66sw4w8RM9iw3lCyaUjg8BIXBUDtcW25bMnicgyeFL3w5zwikHBgsW7tkVVX3KnIKxZSsQvNFHPAMGJSqx+RVgWNc3NmAzPFNGnzrhZSXY/guoMSzWBXCC2bHUOMXaNAxwOtAzfNcOnhhPFqnQsTWDKyI82D7NlHpGk2TM6BuGITPfa7N8O2+dLtn8pRxInTFsTJegpQsXvsdIX7DXpZnsY8P0otCAl5xo1Q6E+kd6vudpZArJTqxHpZ4Qin1Z852E3V5ktL5r5tW9sNAXCMgLY9aRXIXWxGYZlqOQ4gXvzGk21RRdCILbil3rrCvKsp96hcDbLsc6Vtgvt0lnvMQ/Rn+lBxrxogU4ziGXcteIxO93/Yo6igWGdEOQwF1jyZdOdDQMPcVtGRk55k1FU5vzjAygloEYONHcfYTBJyFXAVOEmA+2BRgE+N/L/mpY/gCXQzZfETAPJVlP
 F5xqR153
 tcDmEUQiPdpynPR2EOMFLuIolB1x0/pw+Z9ekVApPWLSuF6NOgrjrWIJmgUjGXhRG+yL+q0XvBL0AABDmS9GTbrRKugJCcWOT3xSXY4wAPz6gDsb4TCeZT6m0lgIwZ398cgbTWYbkGp1vTXOgHeFCSc7hI56b5kl/WfMIpyLULWj5PbmDsVdi91DduuPGF4i+w2xrogzvidfEi3UffejKHs94r79MLSDQBozhcbJBm2RNTYJJuD07aiOqyqmgs3UXPz+w36AUHDSK7vubfCdLC+Y+cEajgPHzQfe/Uc9JRRXh4xr0Fo3OEAXLL3NZx9NRju62Q0YNxkRDWY0DwwEizA7XWFqZtysrFyWo8uuzLWQB2lE9jOTiT4g/GU+q27JNXbB9daLDl6dde/RrSrCRGttkOzHibilrXxyOls6SYhUPeFPUxVviv0Rg/7jDRVkYM7EwP+5k+yssF/byJYiVBgy91r0niLEvzYhNGPio++vrkqIVgS2DMyrbjgzJDqQDzxamZrCH/bgp/pm6OEwuMaO1uVCWsUF56EBffrb7o6VvQ1v/ypPvigFGgreLZcjwXD2XoCXFlRsoi7iydoeE0aDQERHTu9lRDrgkuWcbAcahSjpV3WtwoZfjEc3mm/0vl5Hg1uKiQt5DJ21Crsxpzo2K4/KTx+43SKXDpxJbxKA9RhEsAhN9q0/706EzsJ9Y+weeGecYafvDPbktJ5hcl5jKro1yP7N19lHrl6S0lMqOJE+wXjkss3BmtEbnyN+dy5IVNKGjulDIQtzl26jtZ8ccYAq5eMDi+IJkYwBLsqI9FM/wgBx+rW+PQniXOZ4Ty3aDWneLTckYugf9bEhpcCDbbfnONh0YK2rj9kUC8DwOVUWHhNYJzYjM0HP0CRLgw4jMtWMQn2R/wB4zlbxZLWm2C8Vr9prahG5VAhvX7lbXfCqspWqUSzkNLodxlIXh+KWr5k+iJuBd7xk+ZKIOPg3Coj1h
 GEnriU7C
 lcdQDvLsEaDVpEV3CjQxkt8aYb9Cu/1/2h4gj+TNtJy2GI3PTzmduEDOc2HaI/yM9DIq7jvKX5w=
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
callsite. The exported event format is unchanged.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 24 ++++++++++++------------
 mm/vmscan.c       |  7 +++----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 91fb1c30dd46..28561fda83b3 100644
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
index 2fd9b42f89d8..2fed83738b4b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6885,7 +6885,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
+	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -6926,7 +6926,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
+	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -7882,8 +7882,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	unsigned int noreclaim_flag;
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
-					   sc->gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
 
 	cond_resched();
 	psi_memstall_enter(&pflags);
-- 
2.34.1


