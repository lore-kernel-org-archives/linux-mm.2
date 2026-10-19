Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF5ACCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 03:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8976B0106; Sun, 18 Oct 2026 23:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F646B0107; Sun, 18 Oct 2026 23:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7956F6B0108; Sun, 18 Oct 2026 23:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8986B0106
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:53:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96C1780607
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:46 +0000 (UTC)
X-FDA: 85338006852.14.D58BF59
Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD24D20002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DOhYQEVI;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792382024;
	b=xJEvYj4nap070v7sNx8nchYZPCvVMZ5lRE1uqJAx177XQSg55w4DYROZJCLrpi9HHWDXvH
	ulZXr08SC1lFVu6NUhkMvDXRmeHIdYVjHdruid8UPdKY85tCrcxhF8EaEZE2F6l3xdmpbY
	HwRkZlmtt2SHFFPoqYFoxdpGrqDDCio=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DOhYQEVI;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792382024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gK5LMOJfdTQeYkYwSMNTfN+H2lIQyFYhEZj0uRRXmBo=;
	b=qvKsfRUXnvERaX/f2C9p67Pox0wzQhV2/Dq0WS/gNiOkEcPjC6tMoE7yFaxQQV+HdJ+xtj
	da6BbUfM5PCJ7lh07JSm4zmpCbLUaIgQtwZ4Y2dRfuLshkyaKEeU9C0PlMd1aXyg88dUBh
	PTRbMBjpCiVYQb4JZln2mXO2NVOWRpE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Vcxvr/qaW7PDnOXJbF3Nyf0hUX2HYPQGMERHgFWI0EY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792382023; v=1; x=1792986823;
 b=DOhYQEVIK6uoGJJBJkGThlqWnZvqo6wucO1tK6quYc84H21xMGpHknVNq8vL3M5fgCnTxl7q
 HSKPjeXj8LltMg28TVshGv6dxToX7FUcJkJJoNPUC4FUiGabGaIrQ0J483t5WA98cpFWBVrIAsp
 rueAPEor9IDeS0bMVupYmVq0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 577f89e16abcb16c;
	Mon, 19 Oct 2026 03:53:43 +0000
X-Mizu-Trace-ID: 577f89e16abcb16c
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
Subject: [PATCH v4 5/9] mm/vmscan: pass scan_control to the LRU isolate/shrink tracepoints
Date: Mon, 19 Oct 2026 11:52:48 +0800
Message-Id: <20261019035252.2357900-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD24D20002
X-Rspam-User: 
X-Stat-Signature: ng5frj1amjy3gn1d4ne68wdxngk8ur3m
X-HE-Tag: 1792382024-518643
X-HE-Meta: U2FsdGVkX1//ERXPkCFH7X9EYcoUChZ0B4bT7tNmHbugVmlueFPZiimpFSETr+sACuf5dl5gA02oVNEbXNpZ1PYeeauqXvOKU7OqDrlWGY6MQjEexjj/wTuRhLNkCeFqgB+Gyq3BhgrpqOBtbws1II5+YtXSHhLlT3AU6h23jTc/4OPvEuJ+SmtMVlZawgBg3xp1R2vYeprBi7mGA9FCaEXoJvRsaxZbBx2W6VQamgT8JC0ln1+vd/6cR/l9rHd0N6g6pxMpOljhmss6GVAwnJbEVy8ws4DP9QGaod2KJ6Gp5VEiiyf0ASFLJGDabM12/C1bjnPJ1bbdhuAU/jKE82+iOjMB4Uv53+kP78PNQ+p4bi85YBVHsbgWEy1BUp4Y5eYWHhJsdohkezCKq9lhrj0y0qL6Y6ZcH0++Kk3eKp06z1WztZ9SvrvZ8BayFkkXBO5O9y3k/Z1VQXglUhqm/5sNNMtTgj8HoNthxDFAfVdXBBIERY6IbZ1dU8rsWDaCyICU+mjtNFmZL2rXzYO3U39HLDcslQhy4usPbldmiAkENR7zatK3ZHyo5E8YxHErk+LaA3bNw2ryogFC58d4h3Vaa7UeCRKHD1TB8lylce5R6ZgHUNw0YiMCQ86oUv7mB1Jm6tUKNZam0SmjHPM4omgZl836ZU80nmwT1m0LBlPxSq/2c6O8deoJDjoiHzy2SzOnznKxoCAPYP2HD96EIr+PdxUkzeXxBpzuCGOaXNbvq2bvJcq8tnPiHa5oGNsaGDfpBRsgwjvDzC+QUJmiYyfGa2aP2PNNCyOwcfpE4MFNAJ5qO2/UC4hQZP1LCUwV7Pqock0nrMFanuJv6eZ6undD/0vC4hwCJKKHgq1UhcByvsirD6hcAdI9Lg1i+UVezcOJDLCATMvy52PUWnVnergrH/v6m9bAzJEgFhwwrK4ZPDUgwl/Q20AO0Jq6TtD1PJkE3IpVy6Fqe9vP2Ng
 hPK+s7e0
 SXZXV3ZnRfgNAh2/PBmdTRMkM+3Rzgd71W2vuhC76Y7vGiYliN8eEsFGLv3a3HxHSMSs3h4TainX312i/FdxFpiWk7u5t4yduDXqIavZmKTRqeUZu+ooEuaOCEf9+0CfQUHVRxVfgDp1Wghr70PV5uHFlWPcRx7M12+tKY8a8zFrueaJqs/GCFxEz81fkadff5Peb7J+JlppzmRGoYSGrlHveaTwzLPjxn25b2+1Bo3ygfCYIQENY1sk3R9h8UBXJPFYqXrgoqrXvdjZMwLUjMPR4h1yP+qmadQD/iOVDq+9Afyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

mm_vmscan_lru_isolate, mm_vmscan_lru_shrink_inactive and
mm_vmscan_lru_shrink_active spell out reclaim state (reclaim_idx, order,
priority) as individual arguments, all of which the caller already holds
in struct scan_control. Now that the struct is visible from the trace
header, pass sc directly and pick the fields out in TP_fast_assign.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 31 +++++++++++++++----------------
 mm/vmscan.c       | 14 +++++++-------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index db4590356845..b1b329039e14 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -350,15 +350,14 @@ TRACE_EVENT(mm_shrink_slab_end,
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
-	TP_PROTO(int highest_zoneidx,
-		int order,
-		unsigned long nr_requested,
-		unsigned long nr_scanned,
-		unsigned long nr_skipped,
-		unsigned long nr_taken,
-		int lru),
+	TP_PROTO(struct scan_control *sc,
+		 unsigned long nr_requested,
+		 unsigned long nr_scanned,
+		 unsigned long nr_skipped,
+		 unsigned long nr_taken,
+		 int lru),
 
-	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
+	TP_ARGS(sc, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
 
 	TP_STRUCT__entry(
 		__field(int, highest_zoneidx)
@@ -371,8 +370,8 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 	),
 
 	TP_fast_assign(
-		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->order = order;
+		__entry->highest_zoneidx = sc->reclaim_idx;
+		__entry->order = sc->order;
 		__entry->nr_requested = nr_requested;
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
@@ -466,9 +465,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat, int priority, int file),
+		struct reclaim_stat *stat, struct scan_control *sc, int file),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, file),
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, sc, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -498,7 +497,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		__entry->nr_activate1 = stat->nr_activate[1];
 		__entry->nr_ref_keep = stat->nr_ref_keep;
 		__entry->nr_unmap_fail = stat->nr_unmap_fail;
-		__entry->priority = priority;
+		__entry->priority = sc->priority;
 		__entry->reclaim_flags = trace_reclaim_flags(file);
 	),
 
@@ -517,9 +516,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
-		unsigned long nr_referenced, int priority, int file),
+		unsigned long nr_referenced, struct scan_control *sc, int file),
 
-	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, sc, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -537,7 +536,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__entry->nr_active = nr_active;
 		__entry->nr_deactivated = nr_deactivated;
 		__entry->nr_referenced = nr_referenced;
-		__entry->priority = priority;
+		__entry->priority = sc->priority;
 		__entry->reclaim_flags = trace_reclaim_flags(file);
 	),
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e064354ea24f..5d5eee757c61 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1759,7 +1759,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		}
 	}
 	*nr_scanned = total_scan;
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
@@ -2048,7 +2048,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+			nr_scanned, nr_reclaimed, &stat, sc, file);
 	return nr_reclaimed;
 }
 
@@ -2155,7 +2155,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-			nr_deactivate, nr_rotated, sc->priority, file);
+			nr_deactivate, nr_rotated, sc, file);
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
@@ -4844,9 +4844,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				scanned, skipped, isolated,
-				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
+				    scanned, skipped, isolated,
+				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4988,7 +4988,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			type_scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-- 
2.34.1


