Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04D9C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721616B009B; Mon, 28 Sep 2026 07:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1A16B009D; Mon, 28 Sep 2026 07:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9476B009E; Mon, 28 Sep 2026 07:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2456B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:47:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69B94C015D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:54 +0000 (UTC)
X-FDA: 85262996868.06.36F4EC4
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	by imf17.hostedemail.com (Postfix) with ESMTP id 497114000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F3ZW+rsz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NU/EFn7o3Qjkg0Inhzp9SUapLrosGcMRS4VSBGUgbEs=;
	b=0RjT5nIyJlgFw99ASFtX049YNaJ8yyNdRqoVpFPVBqjKCcOgZOvDma+W/nhfWnrkccknzm
	6B3g3ICJb1FYK/ltu51aloDncdzU6zmUCzSLte5aytDg1sE9KnJ+KHPBhpRMzjpjylZPhY
	a67lJYbp36imog2svvEJU9VLU9BiR2A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F3ZW+rsz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596072;
	b=YHSBWQ0GabUyFBf0I5dkZCBJMY3jLa/O/golbqj+SiL+UKtJPKXAyZ2XUtKFr7zyuOoCuV
	86H+sl8vtcfJ7+SrFXCLwFZHNfnByFnbPN6/jhI5b0p+9BMnOnUzTJgCSRh/OPQj7kLBNa
	TmzdZwiydC0wfnuNt0wbrfpWXaYeU1A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ek1OWISUGqkYd+H0TrfvJZ4VqKQtagJKfzlU40JVbIM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596071; v=1; x=1791200871;
 b=F3ZW+rszsTNLXtPvJ5akQ3ok/ihY8pXZUPtfnqREdW6XnIXqS38NlzoTqwFcmaLiZU88N7//
 bBWDecWV86CgcSFOe4rq/pktpSTGzSZ074thg3BzAqOX2PY4F1h0T7OsRC7DZB1BTH35R42Ivvc
 sG60QGltWq38vBld4jC5YaY8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7a1937eb9caf0482;
	Mon, 28 Sep 2026 11:47:50 +0000
X-Mizu-Trace-ID: 7a1937eb9caf0482
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
Subject: [PATCH RFC v2 5/7] mm/vmscan: pass scan_control to the LRU isolate/shrink tracepoints
Date: Mon, 28 Sep 2026 19:46:22 +0800
Message-Id: <20260928114625.3609130-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3sxizti7hm9pn5f1gfmcndh6ppy8g8in
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 497114000A
X-HE-Tag: 1790596072-68683
X-HE-Meta: U2FsdGVkX1+RjM2FCX7ao9OGbjfKmgJIf/8wPbQbAm0348Te9rJSCNwTFTQ6HpvPDeMhR5Eret8qE8JGgLtpGGSon1KQpM5w7JCBeIIplgu/AGHVtRxCEj7Q16PXyRVJyLzMLz9h6h26sSIDkRh8flzyoc2OckXik54NVTDS3YLk+q8DiFeJh+7aOCf0wixKNhVi7UY1APAJ76G1mS4pRgOcv4KdqoPfcBENIn/W3IHgXNnM7teHsUOqNf236PXka7fSYdkxrjM2gy5ttu6/aH1eZKqHn6bL2qJuLjy/plPPj6flSeAgC4IrBtOOYmOZO7j/oR9ML3gKMa/4paOMEbOKs3z14hw7M/WNurLZgiVteA+u/jWMxspr/ttL7DOoHQOG3fq6n+WHa2eTtbUEX+7SkjrrYvPiBSbCaQnwIwP6qH88IguL/kDLKOwlvpYuriYXj959PxEDQf2BO1md8fhbWlPD7nidE+d8L7wKkRyr7/UqX43Gb58jQ19L4mK/J3IY6WYGkV0hfdOZJvMygudqj8/1cw1LNNJY5iMPrG5eykdc/rv2jqwPkHgKCaCrKQlckySlXm4LDfLezr4iOhgOe9qN/fKPxZQM6pCG58xwlYfKiI7X/D2pcR/nDSSMkJT6S8lCMaOLtkb6pa34jt9x1Hjsx3B5sw/WOPsRi8z8T6SrmAzRbRDuhtLMg3SfEAsWpar2K9+YBqm+nFMAnWQDmWkZL8rbaPGJDVec9ix33iF2yWDaUDwNMqPwlIi6rxFGiJJGrrIeQ4l4zB0fv8IeDki1c0bPr8RXkrVA8g4zKDy9RlaCHQLN/G9ypbS6q+DWKSrpNsP8c34yAxvMpKN44MuWDLU03KrP4JRJ1IaUrBD9JpYyd/V0+84OeJSNxjkFGxK/LUVzArKNhHh9n0DBBLwcTkBkTZzYXHSxW1m+p/65CmAKJ+FvL5acIN2oGcMOoVuF6OFiR2thKNj
 urFF0+a+
 ews5ZaOuaczzKsB7vjcjI3MJtEmsNFdt0qWbaDv+qmOwcamhTc38Me4mv9OUBh9HAijrOPs0mar/tlqf1dBssWqiWMlL12jLFRUpemv5ctk2INnPzISq+XSD7bpGz0BCtGbWa1KWbEbNQRyLSh3NT5/9LBBnx+DTFlbHRXzPFqiMP9SvIUPiM/ToMlMLgtxewB8x5QYsdh7dB3+cNAMXzmVvDx2gpI/yvNeau6qarl03Ag/iSDE43m17wwRCBPX6hvmsZj4fJww+A9OgFYJWRvLydqZ0E171ntZs7jKrXRmUvzEed62gVngUc01rrT49JIrisM63r6+0Pune12e0DzeOeHVYFkYLIn340hRyUlp9GN6TJKn9QZvo4pJ7xFFuuO1oFtqSSmlC0QPPmQspa2u+hvfYCMJ8tfG87Q3TsieTNJsnqLkX/9f2XmkGBO++FaqkY78fotP5Wq6TPfAnDvTLCJsCU4GP5xW10H/vAQx8jrfMIGXB8lMC1MIuRvOvdx9z7Jfxqhc76/bR9Nx8Qf7Vhher/3UqcwH83iau/tGESkuMnqs/kHx69I9SHghI32glKXmlNT5IC2E7whb20AsSqvhSgyMp4v3ffjpe/tjMbcOJcFmu9bjlXu1uGWg4wJzexfbwn9XsgODS/+NXzP2dzi8MtxPLDYWlaQ6u77fJJJ1VHmD6FLz1Dw25dvRb9OMyRFqXMe0CIApdlN9nXAlCOKAUtVumpsz99IMCqA5e1sGOM/0xtqmD6QC244Q4QJCH9krRF/ufSR+77IPtK+l+YvcJGHYLmQLbBD8Z9BKLnIlPtW0oAYGfukBUXPSzEVEg6IKmqRncTiZEA6F8kcDiW/IAA3AHQvwK6vSoJBd3R5NSJfMFuL2UBC9L8iGTJGfgr57ElmenYLOx+cpeJMwLgv86vnW9EMq0TtCPerZl/LR+zMoI/xigsYGVnBvga14gmQxVNSpAaHICZX3otOeKWxy7v
 ogWNf+ou
 b5iB0uv+sXjFPcp7W6CrHxMTYNbgJKDgmOSpTI7DyhRKal72kkYf7Cbhwi3Iy3+UPQVV8Ua8wOg=
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

The exported event format is unchanged.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 31 +++++++++++++++----------------
 mm/vmscan.c       | 14 +++++++-------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 28561fda83b3..9b4a86fff37c 100644
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
+		  unsigned long nr_scanned,
+		  unsigned long nr_skipped,
+		  unsigned long nr_taken,
+		  int lru),
 
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
index 2fed83738b4b..030f14740cbc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1764,7 +1764,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		}
 	}
 	*nr_scanned = total_scan;
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
@@ -2053,7 +2053,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+			nr_scanned, nr_reclaimed, &stat, sc, file);
 	return nr_reclaimed;
 }
 
@@ -2160,7 +2160,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-			nr_deactivate, nr_rotated, sc->priority, file);
+			nr_deactivate, nr_rotated, sc, file);
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
@@ -4850,9 +4850,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4991,7 +4991,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			type_scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-- 
2.34.1


