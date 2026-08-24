Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46ED6C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD326B0092; Mon, 24 Aug 2026 03:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B1D6B0095; Mon, 24 Aug 2026 03:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8396B0096; Mon, 24 Aug 2026 03:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 103CF6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:38:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 763001A047E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:27 +0000 (UTC)
X-FDA: 85135360254.19.21078E3
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6C4C340003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557105;
	b=A0jT8eh1/NpE756prGO7SUIpCSh7dTIoDprPNBL93cztqj/Kibi4QmTrGN9HevqFb75lKs
	PVDbjHIVQW3fK5F3oB5TGWG0ANa/zDZtuDLfJU/QoR9Sq/WolWbVYxZXuB5ZkgAq4Y9hXF
	6PqkoqDLflhOkE3f+jpLIhkWZQp4Uz8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evAv1rWEFIswx61KI6byHqi0X+LMw48i1pgysYzpoxg=;
	b=VJZiNIwWKRq5WqC5liE5xwBuTnTwiLiISXuicxET26i0G1A1PdjsaGf4Yaaj4JvaVDj6DL
	sPUGXEwzSUjyyASwIh+GIk4y/szIWcRF8fDZQZl2j2V3reT4xu2VcmGJWWGJPgi9LRX0fb
	h3KIqkC9YaJUEVpUx/BOClvT1jNJBP8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 213410d7eff453d0;
	Mon, 24 Aug 2026 07:38:24 +0000
X-Mizu-Trace-ID: 213410d7eff453d0
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 1/9] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Date: Mon, 24 Aug 2026 15:37:58 +0800
Message-ID: <20260824073806.629593-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C4C340003
X-Rspam-User: 
X-Stat-Signature: zt9u51fsjjh5ozq5nosny7coscyae7hr
X-Rspamd-Server: rspam06
X-HE-Tag: 1787557105-988376
X-HE-Meta: U2FsdGVkX1+5uhNZTMEKgONq6tkgxi5j75bbP8oAOITnGxzA81wV4vWGKHpZ/zplMxAzYprqKKYrpVdixhR3VJH2du0GkOAu2T/NliWcmq8EapQLxOR97eL4ZJPfFJOgfWTMvi6bu8Cq+THjoRbWknxfjlBQldNf0FG3XxqHXzZhbWlVmE3NXdKlHGWx1XusRvmMSIjOy8lsV6+ERlAYo7Fcu6IuqE+3N6RAlgaqSPEBSAjuDAJfUmxgnyHEC6vfVtREGaoU256RhzSV/vuN3RRjQ40C8eMMxrOtFdKG1SFVvJCGyze1QXBRHYKGqztHpWyIBC2Uz2VW9783X5wkC9SFo4sxgtvifwcni5owKfoMxJm2IbbeJmz1iLU1Yhagc/mj1dEKoNyD08dfTACu8488xTMFYwAkIazAqrpZ9ibge56yd8PoUI4gD3CTRZKL2/eLJNjykn7o+a0n3WUK5f3/UgrTz+ZfukPZTQqvzzVqrpgQ/kpXwqQZgPOQUJ0+lbV/hsILZYeNfHE8ERXYuTNW7FTuEYo5F2XaM6ZPuGcGvQ4di7rjeprGrYdbeQR/eLBg+NxnDecrKRj95zmmfzhQApGyu+SgYsNz3Qp15YbcBeU9TKzZC4HllvKMYLwIRNKxvKmDzqky0I1kaiW53aZqQQGLWM+k/6sjppr/XV3+u3tzyKVTnkUg5L6JnSx2FshTd3WRb6CxrIlI39Vly0Bl3Q7HT1PzaW6gPJxgRUblxAJifUzcmWDKBDfGxBEs6h0B40CSnbQdujNrJbNqQbiW//ZjOmE3Oe+K67VXhhKZDkwEFXKF7ZqBPTrvMdvNBE7EupbwdKYVQdJcTUcXcsZDGMiSEuufSNCM+TdQ5EBCBq1A8w15G4cikmswCLhcqm7XxCzCk0tNGtAdScU6Kl4leDi+13cChBM6+F2R1kKMvBs95TEtkI0BYzyDTXXUgCXJB6Z5ltTZyDQUY3Q
 TS3lXMNf
 eeDPq/ZZTXX6rsxVVxIcwTSIm9S1VqyNXe2l22sP0ppsLhXJbMYddcJiJlLWHr5Uc3xpeGayLMVRQyIrbmQwv4zmbozZW7IGljrAIADRo6u3MILKxVgi0zPrz5w3We673TpkG4aREqiisiR1gt57v8kva8MEzh49pA1UYDGhCFlvWBF7J/Lkjaj39s/PU9ivJ4rVo5Sah++sjqltPfYvbcearYD0jPUQ9g0q+CBNfEteOH+tK/BrKFOnfQ3x+UUdyXx/eMZvySx4JGgu+E6eQ8Ei/15DJtwLFfb+sE6eEc3fXcACLoHL29AP8DGF/eikMHPvv2sffi4XTlwFN4rb4zsyJP0BLDve9jLmJHGeGv+7w8AwWZR4tRoSSEY4mtznttKtimsUEQRlCOM0R0Shl+ZjlXBqRw3uoYPp+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add per-walk counters to measure empty aging walks which traverse
an mm's page tables but find no folio for the current lruvec (node+memcg).
These are common on multi-NUMA node systems because lru_gen_use_mm() marks
an mm for all nodes at every context switch.

New counters (accumulated in mm_state->stats[]):

  MM_LEAF_ELIGIBLE    - folios belonging to this lruvec
  MM_WALK_TOTAL       - page-table walks completed
  MM_WALK_EMPTY       - walks that found no eligible folio
  MM_LEAF_TOTAL_EMPTY - leaf entries scanned by empty walks

A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
debugfs lru_gen output ("TYFALWEE") exposes the new counters.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h        |  4 ++++
 include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c                   | 30 ++++++++++++++++++++++++++----
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..229d27fbfb54 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -595,6 +595,10 @@ enum {
 	MM_LEAF_YOUNG,		/* young leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
+	MM_LEAF_ELIGIBLE,	/* folios belonging to this lruvec (node+memcg) */
+	MM_WALK_TOTAL,		/* page-table walks completed */
+	MM_WALK_EMPTY,		/* walks that found no eligible folio */
+	MM_LEAF_TOTAL_EMPTY,	/* leaf entries scanned by empty walks */
 	NR_MM_STATS
 };
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b4bf7b8def1f..c7c2034715b6 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -659,6 +659,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 		__entry->nid,
 		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
 );
+TRACE_EVENT(mm_vmscan_lru_gen_walk,
+
+	TP_PROTO(int nid, unsigned long seq, int leaf_total,
+		 int leaf_eligible, bool empty),
+
+	TP_ARGS(nid, seq, leaf_total, leaf_eligible, empty),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, seq)
+		__field(int, leaf_total)
+		__field(int, leaf_eligible)
+		__field(bool, empty)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->seq = seq;
+		__entry->leaf_total = leaf_total;
+		__entry->leaf_eligible = leaf_eligible;
+		__entry->empty = empty;
+	),
+
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_eligible=%d empty=%d",
+		__entry->nid, __entry->seq, __entry->leaf_total,
+		__entry->leaf_eligible, __entry->empty)
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..92cb83a78971 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3588,6 +3588,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
+		walk->mm_stats[MM_LEAF_ELIGIBLE]++;
+
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
@@ -3688,6 +3690,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
+		walk->mm_stats[MM_LEAF_ELIGIBLE]++;
+
 		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
@@ -4109,8 +4113,26 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
 	do {
 		success = iterate_mm_list(walk, &mm);
-		if (mm)
+		if (mm) {
+			bool empty = false;
+
 			walk_mm(mm, walk);
+			/* A walk that traversed page tables but found no folio
+			 * belonging to this lruvec (node+memcg) is pure waste. */
+			if (walk->mm_stats[MM_LEAF_TOTAL]) {
+				walk->mm_stats[MM_WALK_TOTAL]++;
+				if (walk->mm_stats[MM_LEAF_ELIGIBLE] == 0) {
+					walk->mm_stats[MM_WALK_EMPTY]++;
+					walk->mm_stats[MM_LEAF_TOTAL_EMPTY] +=
+						walk->mm_stats[MM_LEAF_TOTAL];
+					empty = true;
+				}
+			}
+			trace_mm_vmscan_lru_gen_walk(
+					lruvec_pgdat(lruvec)->node_id, walk->seq,
+					walk->mm_stats[MM_LEAF_TOTAL],
+					walk->mm_stats[MM_LEAF_ELIGIBLE], empty);
+		}
 	} while (mm);
 done:
 	if (success) {
@@ -5580,14 +5602,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxx";
+		const char *s = "xxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFA";
+			s = "TYFALWEE";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfa";
+			s = "tyfalwee";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.54.0


