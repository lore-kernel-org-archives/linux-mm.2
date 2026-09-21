Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5BCC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165236B00A4; Mon, 21 Sep 2026 07:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116106B00E5; Mon, 21 Sep 2026 07:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004166B00E6; Mon, 21 Sep 2026 07:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6F4D6B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:47:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E4A080157
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:47:02 +0000 (UTC)
X-FDA: 85237593084.01.7F06C4D
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 601C3100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:47:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jl4Nnb2D;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wD7aH8s4Vx6F3Bg2ctn/l3dnrBxZdyxRrNFFkTWr3MM=;
	b=lECDuKGg/jELBHoWDqEWSBFT+EteGGPcSMLoNePGpFPt5wU0JYV6L57pcXBW/YzQufy5n5
	DPuMDyBDI6b45YOF6bmK01sNYSMwN8OKTueulyj10y3vBCBtEXzyWl3i2H4h23/Gh+635d
	oc1dKGzFW1N6bbg9M702SufNWl5sPGQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jl4Nnb2D;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991220;
	b=GmIHCcBBKmFvWwBK+O5Jwzwh9Z1Uji3wdej0VH7yI6UZ1uJ99kPMOM1SlsNqHwBildLfKs
	la0NLAsKMly+Yfw0aEvvQ4j6vMmR89K55l0av803U3Qii+h/q/rz/JRoRcUP476speAykK
	2YI55OZoaZmvDJmgMvg3OiiRVdPHfNI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RS4wOY+QJioWn2TQk9dWx0Y0VJvp9GgHoELvPCPlwGQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991218; v=1; x=1790596018;
 b=jl4Nnb2Dy5EL9NNWbh8ffmRN3XuCFwvwlrenmQ6KQTBm3Mlk9b+FZWKMoGxQ7eSNSOiOz+3M
 vy70+G6di+SLND3geXfUSii8gl6236BWs+FPkMHhoNOyAuXyAFxlg6Q7lUuIpEnG9yRd+CVomBl
 9fJ/dhTUXVWrX3kWwgxPSWvg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f94b05048a23a332;
	Mon, 21 Sep 2026 11:46:58 +0000
X-Mizu-Trace-ID: f94b05048a23a332
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
Subject: [PATCH RFC 4/4] mm/vmscan: pass scan_control to the reclaim-begin tracepoints
Date: Mon, 21 Sep 2026 19:46:06 +0800
Message-Id: <20260921114606.3871820-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921114606.3871820-1-ridong.chen@linux.dev>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3foobxbz5jpsogb5mbdwh7g1crcwfh58
X-Rspamd-Queue-Id: 601C3100002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789991220-821095
X-HE-Meta: U2FsdGVkX184T1+vuMrPuWryOHdX9HK3rWBPcaMok2m2/k3NXgXacH8SrEtMscI8bCwHQY6HjVic+kN2dfaJQoeNzhHOC+o70Ujc01jj9qXg5AoNAPvf+XVOvg0GApFaCjtM6DAViD5KIiVS04ijzPbLP+xj3Nf4Bo3FUpKTVXgKSoZRDb6ctXfD5lebb6GGzCMthp9w5htgzlfhcv8DM6KrmMGk17YntxoGFpoBgfVx7vuzroJFO/8lODKpbMMQfzMY4tITMF6Hr6llSDCeM6iaQw4usXIbZKvWRZSgB+I3OGTgz42wB/jcL7o3seHdywFVW6xLJWg7KWgfevmAxslfywUUtO2cU6/51PWDRo0YIEPaKQ03sT2S+sgh0A9o1Qb1bxKDjlpXg39kDyLe3ls7XeSVRYkNYuwAFCPbeSG9t+rYAqUotwX3NtwUs7aeiJ+YICHqljw7TrLRcUQdrSYyseszwj9keCkK28PyK9I3Mv6d5KKyoB7mx/2koc3kVU+jlEFtlnXVDgp3PpcwfJXVUUb+V0ahQZvFWmzFV7Jg2cYOSZ48oWSsZ50Bit5e45tV89jtw9qVhuONA5rmTEurIQ4KkXJ40aILkqbSFp7R3bGxvB0Cfbbuq2cvwxGlpPj2OpqF/qa3cGEUT0bZ3TXBq/bSRTvqK9QW7gbdd7LMBB4yVAnx//STSR9NSdspYjbH3Rf9tIUj/sEWlz40GxGn6uoyLBYhk1ZX4j2I1fb8RL8+0//PfpidGZoNTX39L9Zq09yZYX5dsVHAIxPeFC64elVxfr6JU31MMUtvCi1/9YsxdZ2SuxOVPqHn+HjM/Xq5LB2sR9ShhwZNRTl5O0sezL7kguZ5ugzbypSM4n3jm80DJ3lEEUnSiRq4YPoQgpe6RqXubXirWcM8iVsJqMqGsh2BheXEhdYN9vwiNrkQLXzJB7rCM/il5Q+Eq14CmU8yBZgWHpHiLmBnrE0
 LHeYuQQz
 9/hTACNxyIhqQxw7hDvRDPp6UIEE4kvCxwvI1P5c1yzU43ZKqrPehOLJRM/rQXxnGtzEnghOlVStNGrxhy/dYMVKYyy8Ir7bzilE2zVS4MsMTPGdByvjOON7gc9kO2SioWWfVBsMQ5BtfNkv3YDJYZ7xs+eJqPMa/gtrVqNlTZpIdKxDFOletPv1zt9HsYB63OaM38EvazFFtteoU6PcWEL31J2Bxq+mgLOBr91ZcwqCJKjkVtsQ3B8Msu9klPt/5i380Vm0gvEsCrG3JgnPzlVMlE3fifOvH/eObp0/oZSNye8pCtzCHLHISJYR/QiPw4tBSlvHb9+YO1+r4tZL7bttuX3f7dmnvOABOxSXWftRyEnIaMkw6UvHycUUD9c83qaDlQu1uOTyuzXttgEkrzUyRndy1/wHkTU+PiYwNzZIXM2soavUJnmBc0VOJeb1TcFrjKhSerZxraHQB5xGiMqWevPrGGVDlyX9kzpKvunBgUx7gsGhC9qEg4yGDeFqv3nw+x7BdrpqDrA/wn1YIlRFBFK/Ck49WRUlKUcrnezkAbaiTCMJda0OzP5T5tjYVCjUpnQ0duBJwFTBDcbPSakWafhqAAO4JRW2WjvMRa95ZDpooZQGti4j0+fStN9cdADVYvQDfYLMi3U2ANTvOkAiITGITcNDqYcDH4+ybipkZkTqoPMMMuO260bY/9FRTHy88a8aqpx6otqUooqjr6vQ7HiZdVqsopiVb/cX0SNhqEPum3DBYTxRqByuXBXZcwbK+BPMMpTBzCsz35P3myYEJuDdPQphihiZptFp/Qaj/yI7xPPy2rX7sF5/TAmK1es0X5deNzfD+4k4t1a5oa5YAsT5d9N7OeM4xDB0T+zfpobZhVQkBZLclV9UbzkAJw1eriuXDm01+I/kU4/y/mvO6krk3HRm7MeBcbflhh+M7hX7TKqqTjFDq4nDl3f+FR/dpln1KAmhd5Et2OEhrTYYl9MEZ
 d2nZxyit
 ul/yt5LXrCjHaZTMDoa3BTUcLaMseWGNNBbc9wu2UwEzdJ+vbomlCZGBf7Nx48sDEy8hFUnieKI=
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
index c8ac5d4e4043..c9f16267c0a2 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -291,9 +291,9 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg),
+	TP_ARGS(sc, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
@@ -302,8 +302,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 	),
 
 	TP_fast_assign(
-		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
-		__entry->order		= order;
+		__entry->gfp_flags	= (__force unsigned long)sc->gfp_mask;
+		__entry->order		= sc->order;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
@@ -317,17 +317,17 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
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
 
@@ -664,9 +664,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
-	TP_PROTO(int nid, int order, gfp_t gfp_flags),
+	TP_PROTO(int nid, struct scan_control *sc),
 
-	TP_ARGS(nid, order, gfp_flags),
+	TP_ARGS(nid, sc),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -676,8 +676,8 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
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


