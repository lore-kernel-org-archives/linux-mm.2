Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFADC624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D242A6B009E; Tue,  1 Sep 2026 02:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFBEA6B009F; Tue,  1 Sep 2026 02:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C388E6B00A1; Tue,  1 Sep 2026 02:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACBC96B009E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:38:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23C92140308
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:14 +0000 (UTC)
X-FDA: 85164238908.30.A148451
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	by imf25.hostedemail.com (Postfix) with ESMTP id D85AFA0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244692;
	b=xJSZYLvplB/6f9KQaP5tcSOiKVaolLEAAQ35F01eDb2uEYEJn38OW5TLgsQlNiYqGXsgbB
	5zdUsqb80mL/sfQDhHjH4E4l5jY9KtSkT03tAwLAwnaNMPE57pPmEGOkrtWUQOS3DVeEUR
	JgE7GVSlC2pbILyE3ya+vPDXkDcGd3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KsnWNZ8MqqluPo/ZINK3189FrYomm6gcMm40tdODspU=;
	b=Z6yz+pRbV8esmqlsIaWaEMsrTNUZHPCCGwb1a6APnNxMp8E0eIttsBU5MzqL/K6gqq5SO7
	WQlb3tuSUfFNau9JOHFSwndAl043PZbefU3zI+Iw2mP0faIZfxErz+Zq4kXFx7rVu/i2z8
	0AufCJtA7sM6R3+DwB8BsmIO+wwaPCY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 7ab83703cad38699;
	Tue, 01 Sep 2026 06:38:10 +0000
X-Mizu-Trace-ID: 7ab83703cad38699
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Date: Tue,  1 Sep 2026 14:37:52 +0800
Message-ID: <20260901063755.1519710-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D85AFA0006
X-Stat-Signature: iadb3pzusnsqi9nwhtrmjyuuq618acki
X-HE-Tag: 1788244691-741701
X-HE-Meta: U2FsdGVkX197h+Xv/50y6dBqaaw+GepUz8ndxga6ClsIbyObaG2fMbCTG52FcISpP4cTUKLBfyzjgKBrRZ0506W4V2SNgQBLrDbX1ugysqRpEb+yrhwcP6ekdUtJRHr94l5pDO4UPOLzZ4xnoK1Vd6RwknIqSkY7C6cBQ/1tjGQ/QoopnyDhXqbV0yOyFVRQjzbD+rBf6l42JYTn7XwdcCak6u8D6Fe83Z0WsaQbGqvab0CSTqMpewbt8lcMhoaa4epr69HW7vpeRTjiH+GXUp1L0bphETeJSH5dR6mpplXkf3n+/FltdUao61Dud5GqlzSC31RqHxB30Fx5IOQphGrIRnXHIJDZykppq1SivOOEgEANZfkezxpF4F66v57tas8IlXrK61abKxBJBVeqynXoDpnq9sW9P8GYo7zDF9uJ94hCQF9Lg2PcQks2UcZjJH8l/FetmtnVSSYQGphMOUksYxuG3x/kfsJjmlbYC0WewzGiSwWFYkx+a7b9n4WI43imuVz9jqL6S3VkYMv5ICUfPnYFq4S5I5FW8Ha9JsDv5e21yos9CSGj5Z+PgMmPgWvKTpDx88KC4bXCpXvW954DS3xkHCMKhaYCwl5CxfpWvJtnrAN93Z8tUe/1tUHhSdYtQ1cmyqxt1ugxfI0SzNf9qM1WVAR0XYRKh4eAzEFO5f2rnlwH5GPYzI9YC5YDK0MYjpSKnDtF/kN5mqEj9iw/kY/Cd3jkWwWOcefAVH3tgdF605m2tJm+6ycP9X9btJYDLBllQPKtAr7P2MgDzqK9GT1TaP15/9HqbjXPJH67R9EzNa6mV64efmilwZZtsQRgvVCCkn+xbFbFOHk27tje0LgljyM4RyHY+DsJMaRmOWcAiKngnvm0nONn//lFBPJb5e1Psh7XhffEwt+GnES6szAeELGGzfzpAQGcY+N5ITtgrC8MT8xZeTRJSsw58WwVuNEHfstQMXR5ukI
 MufROfNZ
 N6/vg5uBFLmlG5EWUUtM74Yd71KzAit1eqq5vMHnPoFpjAsTaXX0ukMe7K5yAfNxZbtQZ3IXJtrJmkd+yX0znGMSX5jH7dpIMAGHLcUukLGE5y76dUNaWSit+yqCHBcefhe3Tl1bhGRF0zCXSqGW9BAjPVfzxejdZWdtdd/WhBvmQEDAxYW4iGrROPuHXZsZtcVKfxH5dMpBoyvx9aLm2QXUgk9509tUAr/YBS36UhRWQ+HbQKf/W9UTyQeIpwG+Ps9XVt+40eAdfvWg=
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

  MM_LEAF_ASSOCIATED   - leaf entries whose folio is in this lruvec
  MM_WALK_TOTAL        - page-table walks completed
  MM_WALK_EMPTY        - walks that found no folio in this lruvec
  MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks

A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
debugfs lru_gen output ("TYFALWEE") exposes the new counters.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h        |  4 ++++
 include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c                   | 32 ++++++++++++++++++++++++++++----
 3 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..f75daa6cd02d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -595,6 +595,10 @@ enum {
 	MM_LEAF_YOUNG,		/* young leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
+	MM_LEAF_ASSOCIATED,	/* leaf entries whose folio is in this lruvec (node+memcg) */
+	MM_WALK_TOTAL,		/* page-table walks completed */
+	MM_WALK_EMPTY,		/* walks that found no folio in this lruvec */
+	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
 	NR_MM_STATS
 };
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b4bf7b8def1f..695d6fefc606 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -659,6 +659,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 		__entry->nid,
 		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
 );
+TRACE_EVENT(mm_vmscan_lru_gen_walk,
+
+	TP_PROTO(int nid, unsigned long seq, int leaf_total,
+		 int leaf_associated, bool empty),
+
+	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, seq)
+		__field(int, leaf_total)
+		__field(int, leaf_associated)
+		__field(bool, empty)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->seq = seq;
+		__entry->leaf_total = leaf_total;
+		__entry->leaf_associated = leaf_associated;
+		__entry->empty = empty;
+	),
+
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d",
+		__entry->nid, __entry->seq, __entry->leaf_total,
+		__entry->leaf_associated, __entry->empty)
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..55d43ab54459 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3588,6 +3588,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
+		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
+
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
@@ -3688,6 +3690,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
+		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
+
 		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
@@ -4109,8 +4113,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
 	do {
 		success = iterate_mm_list(walk, &mm);
-		if (mm)
+		if (mm) {
+			bool empty = false;
+
 			walk_mm(mm, walk);
+			/*
+			 * A walk that traversed page tables but found no folio
+			 * belonging to this lruvec (node+memcg) is pure waste.
+			 */
+			if (walk->mm_stats[MM_LEAF_TOTAL]) {
+				walk->mm_stats[MM_WALK_TOTAL]++;
+				if (walk->mm_stats[MM_LEAF_ASSOCIATED] == 0) {
+					walk->mm_stats[MM_WALK_EMPTY]++;
+					walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=
+						walk->mm_stats[MM_LEAF_TOTAL];
+					empty = true;
+				}
+			}
+			trace_mm_vmscan_lru_gen_walk(
+					lruvec_pgdat(lruvec)->node_id, walk->seq,
+					walk->mm_stats[MM_LEAF_TOTAL],
+					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
+		}
 	} while (mm);
 done:
 	if (success) {
@@ -5585,14 +5609,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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


