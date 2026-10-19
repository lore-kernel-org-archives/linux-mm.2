Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BEDCCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB656B00B0; Mon, 19 Oct 2026 00:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893206B00B2; Mon, 19 Oct 2026 00:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D02A6B00B5; Mon, 19 Oct 2026 00:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3AE6B00B0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:24:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A92B8160623
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:24:01 +0000 (UTC)
X-FDA: 85338083082.30.1671129
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DAB6A0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:23:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q7Gk/ubP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792383839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvEEvtNEZtom6TvDKFG1FrbojC1t+GHbLBSJ3gDTOu0=;
	b=MxzV2ayyQlqezZxSEF7ZH9BoPmqcuBf8j+4FsqPLj5m3qWrTz7XMec18QDyTJs+scSBl5e
	YLOIaXcFs8vNBz7WhoXSdsXTUfRDdRHbgai2mhG4zBYYjEeRWXVJ/K+y3cPmWHH1FRk6J7
	Vn8BINUo82V/MTruvKCvppUHLD5BsyM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q7Gk/ubP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792383839;
	b=CUpO8tXzkiRUW9lZzF51iUcAKnMdUwcCmhPywfZNJGU8rdNr5YiCh7vIurX6lbJLYc87tZ
	6ryfc76pfqdnOfAlnrfrJd7UCOGG9OWCaKSqu35JtrDGjoVjEnv8mCA1pxwri5QOC2H0mS
	qOwHRVIBZCUTfum6JTX+UwJGbofYDrQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=elfS6hA1ITVBtYwoie8MpKvEU/DpLK0c0+p5hdG0PyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383836; v=1; x=1792988636;
 b=q7Gk/ubPKXqh94A+MDNly4IXXIFaLWQqnp8TN63faMB5Htau+o/MpF2skWTMvJIC5fL0aU4o
 Lcj9Pj3cOeTvLvfkoDKJYA9AP5ebTuZx3D7AYSjaEI66cdYO8JGqFbYiCtuYbZnwOE9FsXHl3fx
 Qn+zN4OXJjP26mDg3qfm7uLY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9cc758eab229d476;
	Mon, 19 Oct 2026 04:23:56 +0000
X-Mizu-Trace-ID: 9cc758eab229d476
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
Subject: [PATCH v4 7/9] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
Date: Mon, 19 Oct 2026 12:23:06 +0800
Message-Id: <20261019042308.2372396-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DAB6A0003
X-Stat-Signature: rh7kzwjmwcwmhytxhbkc81jj5x8bf7t4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792383839-223133
X-HE-Meta: U2FsdGVkX1/dAr+ws5V2Rib41RYmqODiu9bdjjPPLPQUCOu3zYgDEZzNwimnfEm2+zKz9AyEyQcL4z16aCCyQ7VoiFqyV9LR42fh5frM/R/4fFuBKa+FOQCgAGeHJcJJ0hIUwMjnR9iiQtrxNaX7Zbsdn8E3MsoCTrRpd9GiXc/+6FL7D9avERgI0SQtRQ9urFN+got9M7V30DTHRoG5Ire1zZl1QNyeFxxOSEMhctRMsojlDbJDvAdthcZZxrMIkZ1+s46riYDLMlaMA5ORCe1BdNXDv+EdvZWMq3dSJNudZwbKvcfh2nHFP77gnF+RDwWzmENPjezqGWIKWqFirgQctd14dsFALWdpA8uDpKc5ZcQ87ZXNJwBWwwpbNcrEEx5SUUiG6xo9OX807itgYkqo6Z7WMzZSajpNMM7S0um8DPS0x+e9b8H1u/7JDqAtpVxFD5SHoZITO9M99WMrX5vdVHyfTZtVzz9WHc9IjR6mfaFXMEqo3nVucuAUEMlOLFYOhmUYxpZZEDYXkFscjVHNMPQXvjFLOQQkg9BHPC2qJiMFJgtGGwEtmlgwwwp3eEdzk//y2lbgx83as2+uAXF1nyfCG9iwodSBFy99gNgXbNq3b8WiU0LMVOAT0vWncqRLZtOFDBe8bmhIfiu0oviCtUgnmfnXvos5XFTSlB9u8KOq9SBz0fCsTozl67jzJQMKymCgzA2VxfFCtpITbmHFF24fVigtzHNf5H9l3gd4TztEc80AAzEk0hhqFdITzEcmyj25UO+0D7mRkZDwJzWF07rWw71kbCShMbPuCd6EJRgnhFN533+scc5AzIYFpQPJeCyQpAjpMp1h+9XXvwQkUtwgkUHDdB/ssFnvyRMlQobXwwgnZNHFiN9g+ny/OTBA30xiaxDwhHfIzsogIvcH+odt5zeK3UdInBPNoMwWKfF5zL9M9mp/e9kWR9WDPEQSdmuC2ALQ5rvObyr
 VSxu7DfK
 citIHw8B0rc20HnmSUOPWiSQPv1MdKy5p5VkARDYT1cJqAmOGCTkgHJPhZZBWI+enrMYGQGy0WzSsSBc41Z+XtPJ6lMweiLfWGlVclMKyBmuFKxjD3wfJ70vIC0hOMt3qa3LJLvZmA5c+KIsNFF3zQtrQx5dwbHfKb4g9/6deuAYeSO3xsDGbYh9Fyo1WwjB+UUKJeRF1jWaBm9zKFAAujcfn0HcCQH78vPR/cfKmOgXs6hCduvoveNKE3eo4/ovG2yehKZqr7wy7iHfuJE6tW7PM/vLknkP3ZWYrHgRtM4hAJcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

balance_pgdat() passes sc.order and sc.nr_reclaimed to
mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
struct scan_control instead and read the fields out in TP_fast_assign,
consistent with the other reclaim tracepoints. highest_zoneidx stays a
separate argument: it is a balance_pgdat() parameter, and
sc.reclaim_idx may differ from it by the time the end event fires.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 9 ++++-----
 mm/vmscan.c       | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 54168ad45f6e..b2ad83e5f25e 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -124,10 +124,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
 
 TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
-	TP_PROTO(int nid, int order, int highest_zoneidx,
-		 unsigned long nr_reclaimed),
+	TP_PROTO(int nid, struct scan_control *sc, int highest_zoneidx),
 
-	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+	TP_ARGS(nid, sc, highest_zoneidx),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -138,9 +137,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
+		__entry->order = sc->order;
 		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_reclaimed = sc->nr_reclaimed;
 	),
 
 	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4bb00371a67f..5d699decaa28 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7402,8 +7402,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
-	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
-					  highest_zoneidx, sc.nr_reclaimed);
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
 
 	/*
 	 * Return the order kswapd stopped reclaiming at as
-- 
2.34.1


