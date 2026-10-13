Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 003CDCA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D596B009B; Tue, 13 Oct 2026 09:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1553E6B009D; Tue, 13 Oct 2026 09:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043E16B009E; Tue, 13 Oct 2026 09:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFB6D6B009B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25489140BA7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:34 +0000 (UTC)
X-FDA: 85317647268.10.4C63571
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf07.hostedemail.com (Postfix) with ESMTP id 294AD40006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pEQbzK8L;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897272;
	b=rrPZnGX08V7FB0CuUhJ31jhQPJ5bhpZ/oKkc59LJjvRKcbZPqDKMZGprRAw7hzhcjZmTXe
	fwxPxnvsRXlwVe5UHFdWx5UUlLZs3wwaHOv2uePh03MkmDVO9GYFrWK1Z9rxEjwh1+4QbP
	cVwROKKcmOGS8Jp0Iv9WME6HyTOQvFo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pEQbzK8L;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Huhf+4Xh/OxxomSbkLJ0LtVo3jvvpZ9iDxm53hApXlo=;
	b=ovwnUyb/JK2NW8MmxssAhHRiEI9a2866xIiCikwfhwbpl6PRkGRSBBo7wOWuxC7f/Slcl4
	sck7Q8/IIx53hSclSfR62uw/ZPkDAYMJXb0QP94Czkp+Gavfdh3oDnS5iMKtKFRsAvY0jF
	5Z0N6QecICCtWKhU8vWrqgmMidTuwF0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6bPuePUhI/PVXzKlEerl1qF6JNpRJcuQN+73ZZFRPbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897271; v=1; x=1792502071;
 b=pEQbzK8LQsTYL0NQ1jy/BRSvQGwA8BUOzBm3AeOk6CO3T/vf+JeoWsLLMWjH1Q7QH7pL3UX6
 RgNgFZ8YEosNXPZUzs0TaDyNRjIhveoWGWLic8ap/hsvPPz6NuqppnyO04xDQQudLUl/S2v/fD6
 Bcld3b19JT04uJ3P4860rvk4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 924dac319db54da7;
	Tue, 13 Oct 2026 13:14:30 +0000
X-Mizu-Trace-ID: 924dac319db54da7
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
Subject: [PATCH RFC v3 5/7] mm/vmscan: pass scan_control to the LRU isolate/shrink tracepoints
Date: Tue, 13 Oct 2026 21:13:07 +0800
Message-Id: <20261013131309.2790253-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 294AD40006
X-Stat-Signature: u7hqwg7955i4adu46zcuwyom6hoc6cgk
X-HE-Tag: 1791897271-198595
X-HE-Meta: U2FsdGVkX18IG0TRVUWYKF+bm6SohqEhzv3H9FLFWNwH+6tiKRfSYxlrZHsPdT22A3L4z1YCynlGeRzNWa/AL3lC//aXp6A6QlryGHhPh6Wn9tqB/VCRovWTrszLeiXrNYpD3CYoaQtaIBjDZ7xQw9Zrun57ueU3EgusZrJIf5dhRsoU7Mzwl1rJ+AMUNRlUCGbmeBcb+P/aDwz7SElKUVn5EAmw55XXl8jk6eXTCehwCKEDR612CDf4/fipMjsJl/88OT3+5D8RROCQm2ZDYoxDoBPoId9DElfF5jrZBHjVnYeTDlmdIJ3b5/8NAoYOL5EMxIAbeGk7hVQvXxcnm7EJ0DjVRUo1TkqYWcD0nNdzJXKM+pJ6oR5VW8jVNEGADFrsHLjeY3SNlN8OgwMXMLl9v4+auZFN88rnVUX7civ/A1Wzbz1piCvIQ4iDO+ravJhAsrah5BbIVWNS/EDCIYaMZyL3M4i9revWAcug9qm39JkGsI6rN73tKIeEtR0KFdB7IBnLL7UG1FlZkjEMPRXW1dS3gzhJAq7t9WPk0AOb4rGiU+eqDgsx5RyrN9VwdDhswaPXh2jsUdjnFJ76A43UIvern77pxZo8PeTAgdO+rFeVySdc/xrbHYSaotwneuOu3qs+8oxHW1k5BVOiV4tJUMnEPqj2WM+ZM54hv7Z58C7oMDsKWFW04NEhxcdBEdrmsUHXZwqlyPJDsMF1cwsxxh+8t0SKrh2sulk2eB9E7kRkdixLd+AOlT8HirLjq62dR3sbzsxdG26GyeBz35gPritG8h4IrNknOmYIfmAHEof2M+gyTLLl3/blYrn9wu9BRQOO1VDAh4T1oaElqkkWoCbkSLXXWxcNqfrfxn0DYA5h+f/L9IY9ltkEgXopg8nT/zkCWMFFndGT1VITsgh5fZJbbU7aUW5qGFd36I8g1diYSRXP5j1yLdmnQqa5/wkdyBs7H9cU+Dy5mkr
 PRziWdMR
 RESb8M39e/pdDEHz3Ox00EzqJ/e3In0rbPVU9tVbmekFxftjwvzDDXy4x7BZ7kJwgMaprsYCb/NWbNciCZqatpCW+uMtsHgVQ4cerp3ZWz3V3Kxgnd5+9tfMQwfQ+AmuY9fHPvfFo5CQgwlcUvsqrRZfrPYh3AstY0zZdZM1X2QqyeHQaTlRS+ml3/IP/DIZDqIwkd8Q5WwIVeUHzckMXuriOVd3ORp4yp1CSQveFW9RoE4PsaF5kcb6uqx8xP+sYJygDiQzsE4XEAjFuapBPSgdrfYwmoA2/Tu5qdmW+4oec+h5Kz5r9+7hboONxSW40KLN78+ZquoX1UprLvmDO5+nxe1uJegvuAycFBqq+G9KeBkpUH6jpgpOtjYHnZEeBno0n4UZSEtTCgCpZ757nzQ7GXMxaJgpaXeyUw+oY1y0E9t1S2yTZ31YfL4/+WSGL/nOoUR4Vv2cOAobxzrSqXYGQ1AOFVfWOuo2JLz+OAcRipEqMYt0//jUrB87CMKuv76Qq4p1LlN225tt3Dfer4CKrXkSkG7SI6lLlWnw4NYG9goX6E+s8g7ytxtXuBiS6iENnkd4Y+LMmMVLpyQP3i8sWuKYVV4jFw5UqYBwqsOd2OmNApJelS+plvJGg2iJO7cLksvnvLxeUT0NstuWH1Vf7/u0fBYE1tHjfPWo6pmLiC1128U7Qs6nvbgX6kunAqSSEQnhrlcBQNKI0XndOWbQLhnNhv66/0F8/OFiEHW2fWUnfAU8pNZaY7k/J0HXA8JUz+gmT/x+lX6bK6quGabSFJfA6asFaMvQakHWL6dV/VWr+5w8L3hBZGlt5srhlMgqnyYHROwFNqz26UJ7gic24FYj+eb6Bx6stLIVF8LAKDLbdYoC48wmO2vcZimwCl7GvV3HCopnByV8rxSukj4kSFFbBWJUkm88NDXBSNLXa/ABF6RLzHHo6kGsAFEHEF62Hyl8Zsim0M8lf66RwANl9t2XD
 UAFIcMwl
 B5xB1tb2sk720K2CC/wkyipcveVwMKEu1rHf68nau0tPRTm7HKYoSI0Fu+UxaijMWfXBHDzUYQk=
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
index 28561fda83b3..aa27cb9524bb 100644
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
index 2979d0d819a8..c25ba910149d 100644
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


