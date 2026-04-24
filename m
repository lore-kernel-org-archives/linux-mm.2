Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A78FDEE5E
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 03:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2486B00A4; Thu, 23 Apr 2026 23:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2833D6B00A5; Thu, 23 Apr 2026 23:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172936B00A6; Thu, 23 Apr 2026 23:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F36186B00A4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:14:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 250A41A0C08
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:14:58 +0000 (UTC)
X-FDA: 84691982676.23.D6B83A3
Received: from smtp186.sjtu.edu.cn (smtp186.sjtu.edu.cn [202.120.2.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id B9D6380002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:14:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b="jl35am/A";
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf02.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777000496; a=rsa-sha256;
	cv=none;
	b=fkYVA518MK8tccaRMaygGsiWX3jW/dkFJ4CO1TmMrL8BLJc+OhHmBpWqiJO1VOya2SM4r8
	ZBLVbyPQ5fiBlON4kVOoZDS6O8tiq1YAGFsGXKcoQiSb5uYVc4ecvJS5+1mQsIWdfzw+cB
	M2SB5QLOkizGpbDFOzqHiTvBy2KfDkw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b="jl35am/A";
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf02.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777000496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFPdl9GfLiKoz1LcnPyH1kI6Wfk4/80gGk7Izw4pBPk=;
	b=Hri7mj+QKI2kBLFuK3rmHlKYh4rYAXOEzT8VRsrg7/SPmFMf3wVG1KerpnoClqtrbhf2Ia
	bOOhKcSQflj+ShdttgJW/gTR79zCqpEar70flNBptbD5tW75rCoBzuYsDr5v7W4gj9HZz0
	S4mq7o4Gi3w0Hqx2zo8kc/k7/tAkB0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1777000489;
	bh=W++Xowgx77JKFlnjRViqybtmnhU+fIz2BoMIlWT0MTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jl35am/AImuqxCCWBV1VA6kkI5AkprfA+wB5mb620xjQvOmQAd4RG8A/oB1eg9P2c
	 Yvj3137vCg8aotsrYo6E3Pei+RBurSgaEpFwUDDucQFA1ExS+GwFwH/XeiJrFWuERP
	 oUKqTv2DqWlgc2J0fR1QtSJECFU8ha3v9JaWtF6wB+Y6/Kg2BtJrXOHRZMKTybQIIZ
	 w4ihhWhOXP0SSsm9u25ydO7FJpPpeCaLMlfOabSEQTCz+n0aIYhqvGQjZrLUhOJaSy
	 ZGy9O75LLy1+um63r5HZhjjii3WXfSNUGvei7Erp3a1WmNONuUGNgYq6hx34X6kgbL
	 D82dOBEeLMa0Q==
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp186.sjtu.edu.cn (Postfix) with ESMTPS id D05522FF4E5;
	Fri, 24 Apr 2026 03:14:49 +0000 (UTC)
Received: from dynamic.ipv6.sjtu.edu.cn (unknown [10.180.122.86])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 75E0A37C921;
	Fri, 24 Apr 2026 11:14:49 +0800 (CST)
From: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Subject: [PATCH v2] mm/vmscan: add balance_pgdat begin/end tracepoints
Date: Fri, 24 Apr 2026 11:14:18 +0800
Message-ID: <20260424031418.174597-1-b.suvonov@sjtu.edu.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
References: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9D6380002
X-Rspamd-Server: rspam12
X-Stat-Signature: jh66sp3kftznw5po583gjwagbjbz57uj
X-Rspam-User: 
X-HE-Tag: 1777000494-87937
X-HE-Meta: U2FsdGVkX18su9TTRnBdp0Ut3n48vcNyuZxhAGXBfFtFSpdfG262sRdpAhC2JXjj2KY9rK7sAUsWwrQaB4RP/PN1jy717Vs4lB59sY6EHLgvGcBPCMltMBRYtJ4DhnIyWBdyttIIe2vmQko/U3krS9N1IwJ3AICfuwjIlVROKa9PDr3ksxt8pQT1BFM0GwFv0oz+ryAQHlpoWQAt84RHIqzYekAjNCulMHw6KzVDi5cUfGVBZH3pFAO0vfEn1g3iQK8scmqxYkrd84kwy+6OeeBOZBbVOxrGlOyQV1AAeoElKF+E34g2GbyypAavGuT/ivXmGve6zah1vTECj1IQg4jBXa3ZrYa6e/PZUi9eOMPNaOqi3KHT9uIWSf4J8o3//Ddgc2g6TLrXFGHCs2nUJeOwOOrZnM/Q5t8xto0bWsT+C0FgJrsbAZPWFcmJ/FhbVq4sa0XPCC3T/74claHuwmgS1jst4pPgpPinnoRDVqoMHojmT/ZcjATKoV7gx0unIH8JvS+nOQBTlUNISPhiBAive8BrRGWcjRegt1pECcYcR8DEfjC7b0xijMqR+KIElopE8S0IFmaIZzgcBCRlh8jthnLOeyD0UQJ4hBZEUITCixc8v8v5kKKeHXugmk4qUn10J1ueeTvCLdn2AFK/yrKrNyHhIqZLWoV1u6v7CdfLWu9kwuNognaTTo21eYc896bbJSxzsBKlTwAn2uJURMWd7VUV56b6/5q5vxfxlcTB7rZF7ZvQGfVBA12aZ5QTeCDjCLmGqsZ3Rj+zur8uJwIBCcHJnX4S9g1MQPei+Ko8f//lb7RfWjh9YkFbqpmt3vSsv32m9LX6pKwJZIt4m4lWjm0MqFbM87oalauKjB26Wycjmx8XJMeuNOB+YAbft8wrEAfIEvnPnOS1NcoL9Z1YOGSEs3UKtA731N9rkDqGPGY/2XBMnn1ZbNA5ghJ9qLKnXPjuY6jH0ofrrhD
 q4T0/J/t
 EAR8ZqNsc572SrvZt8Jl4pHD8JqDQwvM6ljyA8B3y57e0L3h6xv/wCVMCx0+UC7aSi8UhLlHatSQ5EYh25h0nikoAJtw3GXbQsgQLCIE3obluFw/wExkS5qDO/LiMr0AmreljSVxDESrHVE6wh9TVCAJ/POlE+gZTIiE6Uti7jZ014zRAyMyfHYCRPQ7mu2pJNM/drgKKvDc7TpvR58I0orEhKNNUtEipRLPXoE13G6UTvN3hZ1opRN3uTYf8Tfe6hCPpxeFs8A7jkGN2yjoJAo4LKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vmscan has six main reclaim entry points: try_to_free_pages() for
direct reclaim, try_to_free_mem_cgroup_pages() for memcg reclaim,
mem_cgroup_shrink_node() for memcg soft limit reclaim, node_reclaim()
for node reclaim, shrink_all_memory() for hibernation reclaim, and
balance_pgdat() for kswapd reclaim.

All of them, except for shrink_all_memory() and balance_pgdat(), already
have begin/end tracepoints. This makes it harder to trace which reclaim
path is responsible for memory reclaim activity, because kswapd reclaim
cannot be identified as cleanly as other reclaim entry points, even
though it is the main background reclaim path under memory pressure.
There may be no need to trace shrink_all_memory() as it is primarily
used during hibernation. So this patch adds the missing tracepoint pair
for balance_pgdat().

The begin tracepoint records the node id, requested reclaim order, and
the requested classzone bound (highest_zoneidx). The end tracepoint
records the node id, the reclaim order that balance_pgdat() finished
with, the requested classzone bound, and nr_reclaimed. Together, they
show the requested reclaim order and classzone bound, whether reclaim
fell back to a lower order, and how much reclaim work was done.

The end tracepoint also records highest_zoneidx even though it does not
change within a balance_pgdat() invocation. This keeps the end event
self-contained, so users can analyze reclaim results directly from end
events without depending on begin/end correlation, which is less
convenient when tracing is filtered or records are dropped. It also
makes it straightforward to relate nr_reclaimed and the final reclaim
order to the requested classzone bound.

Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
---
v2:
- explain why highest_zoneidx is kept in the end tracepoint

 include/trace/events/vmscan.h | 52 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  5 ++++
 2 files changed, 57 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 4445a8d9218d..b4bf7b8def1f 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -96,6 +96,58 @@ TRACE_EVENT(mm_vmscan_kswapd_wake,
 		__entry->order)
 );
 
+TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
+
+	TP_PROTO(int nid, int order, int highest_zoneidx),
+
+	TP_ARGS(nid, order, highest_zoneidx),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(int, highest_zoneidx)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->highest_zoneidx = highest_zoneidx;
+	),
+
+	TP_printk("nid=%d order=%d highest_zoneidx=%-8s",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->highest_zoneidx, ZONE_TYPE))
+);
+
+TRACE_EVENT(mm_vmscan_balance_pgdat_end,
+
+	TP_PROTO(int nid, int order, int highest_zoneidx,
+		 unsigned long nr_reclaimed),
+
+	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(int, highest_zoneidx)
+		__field(unsigned long, nr_reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->highest_zoneidx = highest_zoneidx;
+		__entry->nr_reclaimed = nr_reclaimed;
+	),
+
+	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->highest_zoneidx, ZONE_TYPE),
+		__entry->nr_reclaimed)
+);
+
 TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 	TP_PROTO(int nid, int zid, int order, gfp_t gfp_flags),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..b2d89ed69d22 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7121,6 +7121,8 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		.may_unmap = 1,
 	};
 
+	trace_mm_vmscan_balance_pgdat_begin(pgdat->node_id, order,
+					    highest_zoneidx);
 	set_task_reclaim_state(current, &sc.reclaim_state);
 	psi_memstall_enter(&pflags);
 	__fs_reclaim_acquire(_THIS_IP_);
@@ -7314,6 +7316,9 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
+					  highest_zoneidx, sc.nr_reclaimed);
+
 	/*
 	 * Return the order kswapd stopped reclaiming at as
 	 * prepare_kswapd_sleep() takes it into account. If another caller
-- 
2.53.0


