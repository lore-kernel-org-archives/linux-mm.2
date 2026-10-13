Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C706CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574336B0099; Tue, 13 Oct 2026 09:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BAF6B009B; Tue, 13 Oct 2026 09:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4626A6B009D; Tue, 13 Oct 2026 09:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15C886B0099
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A499120A9C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:22 +0000 (UTC)
X-FDA: 85317646764.23.F496E6A
Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id 988CA100006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L5qa2ZgE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897260;
	b=OW2AGRtkFoRWTrRe4upkBtxMWTU5N087lz0iYtowtFG9OWTsRvVySJiA7MpxKa9LD2DQo7
	S2GQhle5vGVN2QhVniVkIhQNS6D9qdG3AZX47I7QIKahnMdJw0wzwxIUmIRWqVkeQM5Cli
	usqB5Vsl1Fk7U9e40zXEwAhuxsm7ud0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L5qa2ZgE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51Wj61dPnajUgpLkqZNJjWOb7G9/h4vFpYA7VHkJ+Ng=;
	b=7HH29VMVtUzgQHJrNK/2rM0rIUOXkZIqHlQlens+azizkOIzLs9uKgWKQkG7SwtyAo67RJ
	5aafZYuzqIkus/mTTZOarPcwoR3TyoRR0dKG47AWRVYGdnavy7c8z05neC3n+cCB5+cbAk
	VBwmfAIIsSfkFPIaqHzcJ3VJSrGxELI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tV/iG+K0Zh0tqFJNheDt0OFESsgf+YxPRqXcyE2fyew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897259; v=1; x=1792502059;
 b=L5qa2ZgEvHu2MYeWLSt+D+wfhd2sbsDNBw8on3/oUhPWi03NRK1Vgn+cRxMMF+ZMueYPBTdQ
 pA3iInFkuoM+ShrQySrtKGqyBACTcjPE/mdN688omzci7ppzjxbPfR4iIZCxHg+WDHQccT6I+Ly
 UBv8gOJffVXsiSP8ntKGvdlg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 030329b0fec174fc;
	Tue, 13 Oct 2026 13:14:19 +0000
X-Mizu-Trace-ID: 030329b0fec174fc
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 4/7] mm/vmscan: pass scan_control to the reclaim-begin tracepoints
Date: Tue, 13 Oct 2026 21:13:06 +0800
Message-Id: <20261013131309.2790253-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tdaf1optnrxay3szjnbf6cjbzmunu6xm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 988CA100006
X-HE-Tag: 1791897260-418281
X-HE-Meta: U2FsdGVkX18sndB5p9BD2vt2Jz0IqcFQxP0O1Fa8O1JcSkXXph7sTp8vrdW7YjVHgFapxGzgsFyaLcLrjn37DgSLVANAhK5nBxRbonS1GlUJNMdgiIeDSzHRG2zLUjcp3HkIyTQqQ0djUWPVaSoesyCT94RrAMdIHV3TeaONQaukEUesf4sKrxGzTOAN7qadysR7Z6g7VTwQ73EPdtIRxFGN+DVgXh2+IB2mvHgyk/Mf+9kr8Rjl0kUmy6ED/4Yi5JeP/8VLXNHw7SlqVKOr/oHCNBoLKq+q/2UJT1GVO+ZAuiTrLo7rfjsTjI0ZDFZg3u3l+Lqp9o4fbMgu3euI/Z6Z2GTjdR8BMwfbmzbVkFkm1teZfGaZOodxDGCQnALmm7URaD8Y7pE4cAiZQ3XAfye6XvkWgPBIvQiOFFtAatv9tXX/4TwyZUquU7rBDUJ4jNkudArE6gBc5/i4dxgHERGX/JG1t3ZJXODhXMSyMRpI4pbSr2zTWekzy87RktuGrleKYcATgqXbge0agv8CZcHW5owFvPX1RH6WYHCpXGBreiApMSEjbWYzMpZ23zmm2vAfz6hdzcrnGsnlaEpL/Nq3cN1WZknkI9ntL1SBukwTch3KqR+kU6m88btKNHbFIaRPVIXyIcQhlekw9DwcBfjSqtejk4atkqbArskE7LtNMy575wxzvwq5toDgM3udaBQrfTxfjT2t9h4yUJ3oHZ34DfeZJtAr8B01JxH3f2ACwrJgzJsCGXB8nz04HDqyrrDcqSQ6WVd4RxZLAKc9mIgXjqLZA2xt/N+aeyCThDqWsdAQFIir8NdxUbi9ZG2xbQ0TbihWY9VNW0l7ypFRkBTO3w8rPdhSzImQeJ5UG1POorKpWq4of6PEuhxjoyDF9MYZlJQURE05XUs+7uFteOArGKF0JI04GMmazd3TJJ4Bq8+cr475uZpixyb6iXL+GT8iAe8LvE67IP/7eiQ
 tPLHJo9i
 oDjC1xtszlAxqm9CWYPv8CCeLJaRMW1xI5zW1vPi/vOli3GnYDYgryB6CqaW1GLH0Oi2LIvOnvGHsKcQOB6Tha9ck2w1S7LzCknofEaIvglwUFN5NdpSSJvdY0fGPXyZRaARfs5EI/UMa2HKXYDvqVSpQnLJ9fD9q0AJSZOgCJSGAJPBYe0YYT7OKb9m9f3po7GQgAqBej+sjccp7C5JyssSfcgqJonpfGo602CfaE1zHTzMHeQcbjSStSJKfnYv5mera7OcgrLLs+0YBibnqQ2B0rK+q4n1XLv/nLx2NXiZmx0ilZCDeQD+kCQivZOgcNl08rHoVHykf08P/cTy/ArgZ1Hqc+JMC16FusRXpJppo/P1SC4MHQqWVsrA7S2FwkCq/sk3ak2qpMpSwAslP0btsLkbSOqSJ+LRvfbqeTlo4HGclkyy9fOfydhOfHF5rKhuRpBMEtz/Apmdxwv+xV+81m62TGDCKzSwJLp93DWAsy43vel89zRE32SdMLda87T6leFheOKW7Hnr/PllNFlbmUy7DmAHvivpQDNIlTb/n8XytzB5JUKcq8uL1brkPZHHIn0NcLdXdZIuYXIdPOELVKTnuOXBJtBVdXDREvBhNjMsOa/8/nmfGkOwj+Yy3id5E8hZGAHWMCnbkx5QDmAQp6OA8GEeXcq7Qv1ec3gyG48LM+xYnh7A+HcST5QU6uafWWxlcsYJ76hjYQ/YBT8MUYjlKhxfLbu7Sd/rYoByqD5RGPkkQX3ye++Ei0DA41SBTB96pA//lW/fiM8bdSqECyEXvbCGGbOLr/ZN4tYuDXwIe5FIq4KU/4wEkgXb27oUdHZN3/y9odeiRXIqC34j5h0SLpXZhaOPA8q5bBK5g3zz8GgiZzZ2CG33usVeMBB6M67OuWUEPn6scEeGRmj84r6eyZjTRXz/whwckWGWLwDMXDIezxIqPOCwJry77Y/i3BgMtCChQuvw8Aq74/78g5wdY
 3xcHenh8
 CL48UePb3sc3xcw/5ax9xXagSk+gYV37lHOCEbYoJA82vgqnG3mzPfq2DdI5SXThOuNfjGuicNI=
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
index ab118f6b32eb..2979d0d819a8 100644
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


