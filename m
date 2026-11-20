Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D36606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TRdRpYf/
Received: by kanga.kvack.org (Postfix)
	id 3C6A46B05FB; Fri, 20 Nov 2026 03:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D866B05FD; Fri, 20 Nov 2026 03:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4116B05FE; Fri, 20 Nov 2026 03:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE6746B05FB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 773D81A0E01
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:51 +0000 (UTC)
X-FDA: 85454897262.14.A7A0B1C
Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80E6F180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TRdRpYf/";
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165129;
	b=tIOWmiulr1nXu/4KnB6GDgF/vI3ynataNyzaZt22KU6k3nBJ//ZRcJ+NKzpxA9aekyMJ5Z
	JDvAHcX3mlTAlo3W+0+QCoCGho+Nq8m82blvvqxfCpxTrd9anC1f6ju1i8Y0iZgUL/iDa4
	g0k+VJPgRO+la6rVi5QkP9WG5OkownU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/f13GSRKpL9hcVOayTduLhuGXEEXbt5XkW1uxkUYiQ=;
	b=OGyLTWos0ymsVMGZV6/2ERWyj+z4kVnRhGNnACb/zkv4+Nr+41j6azj2d6JAiXdOOMwgEe
	/ZUkiFd1RoAbhI3eOGZ8DFjXr0zpV5D9qIWyULSYCxmRnYND2bNbstemfUSnHiE1AUSgiM
	JlpOTZCGc071BwDU2I5dyhpRC4MO6LQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TRdRpYf/";
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UWxGv/aFEYMm3r+U1AHD3V/0QKj1BAFW/1FdGOR3Yn4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165128; v=1; x=1795769928;
 b=TRdRpYf/sHpzGsWeAAqFbYA2kPJvRmpmLb+nLdz0wh/p31Io8iOhjg1+6wkEG84vLPYh/XnB
 COnbBTCNJ/Z8dfnEIuj7rxupU7pWtu1JD0w2geaLKUQabK2zX8+R/L4Fz3gGGdcsecWqpT72tmf
 Y2cJLTvCqxpTDnCPh99a700Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 08c761eb0ce07d35;
	Fri, 20 Nov 2026 08:58:48 +0000
X-Mizu-Trace-ID: 08c761eb0ce07d35
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 4/4] mm/mglru: count PUD subtrees skipped by the PUD-level filter
Date: Fri, 20 Nov 2026 16:58:06 +0800
Message-ID: <20261120085806.781225-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261120085806.781225-1-baoquan.he@linux.dev>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gcjsgw39nagt99hh6i7j4a9mn5yyfq9e
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 80E6F180002
X-HE-Tag: 1795165129-530752
X-HE-Meta: U2FsdGVkX18B34M1Nxco8TxPOCQjWrxyGiHqOkVkaiSskhehNK/OyH+x6ZLtf4i5H9oopVT3gb9tTKZsB/ovaKF6TBklindrj+RQAc90sk/nfzjI3ZxUDKUCqQykNzzyk6NlHXPEufrqVIa2u7FLH98X2U2Fx3OHupo+5vKIMRBTpDRlQjxvHP+4SJQCil3Ao1WC0E3D5VCPT6ONNbwBgIHQK2QH+lI7RbRDfgJ+sGiFf3KQI86CfUzo09jdeCq50t63i83oeIWNuWHhseAwWi31uhTUMuR1FpLQff+zxiimFMTyiI+w8hL5/Ua3IFfLAZDDR0WFtAwp8pIXiy4nNGPYMhWUtgn6+R1tv/wifYYaoAmYTFPWxDwgz9GRv+hmSsFyya5UfOnIJFsw1z/r7miNAtWuAFgrILY7gUbqwKlFF0tKDCACuvOo0U/q4snNu3tQjEgw8vL5gQ8gSpEt3g7mFJW7P0hzuKmLwB48/7SzhR+OCH9btROcEs/B05auYBqR7ovQB0HoEcV96exu2Hq7bkgMTVbyVOdRLjqxveddNezxun/PTWb70u8Fb0Od66/JQk5wEUy83fnpWgOJdIfY1Ogq/scROdBkM3OpKLmvG6LcRbDqt/q/UrBnMrpF+Q7NPm3EwG/XxHxd3iIpRaHi4TILigmJ/rWKBR7adwGTGae5btWqdgSN9DRr4hZe+7k2ZDqg6WtKIX++6Ad09svE7l6jZsFHqHAB+1OVijLB1RhBcH/CBxr+MnDrHupsGQN8uk/AdzrKpCeyUeryn/fbxLvAZDZqN0eGkRrXjw+TOLPvzhhFhBqsOr/4wdkwUu90yPec/HZjdBXfL/cCfMyhPMv2zXw9RkMDMomCHq3mYfqT1I4ql9eHx1QvymDKaKUwmlIdqKgT1iMvjHQDedXeN6X/nrwsNJPEQJsn9dQclk0/kg/qe3m0TNdSUZPHaeeympopKacCQCIRzmO
 yU/PJyGq
 1mqKJEl5+tJtAD1SBb8Q94djtJRHUk0oKg90ISei5+cvRBO3dwoFG+w36sGvitcqw3N7Zyb1/7dTJm8wwnVTiG3n/1NZS9kFey8bIJkXpHTn3j6cAMoywvnh81d1p2JpPxeKYY6GlxjrF9EGhmRH1JaPY5DqWhW1+H8wrmkEh6wm7h55f1WoUbhxKqsBsaGhlk0sxmNO5MxeFrQPtBUlZmQt4rAVZ2/DST64XzWZVYQIxAU28tlReztvesjO7Bc2DjDLhtyjuUnYbheHVRXcYUtOLs7NhOOpRB8jYHZv/U8BZfXtVXGBp1HVxe01HTSYuLk1/OTVXsOSI7jKD6Mzqe/+GUEsicoGu/CV6gPIYv0JiKkNP/hQcMczro9c0VBptuLFKGuVXy168Ma9j6mKHIpExInmi1KDyylX80iPhLKIwB1Fc0KmtYXuEWokgfqsWLuEb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add MM_PUD_EMPTY_SKIPPED, incremented in walk_pud_range() whenever a PUD
subtree is skipped by the filter. Like other counters accumulated
per walk, shown in debugfs lru_gen output (the "S" column of TYFALWEES)
and via the mm_vmscan_lru_gen_walk tracepoint, so the avoided cost
by the filter can be measured directly.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  1 +
 mm/trace_vmscan.h      | 10 ++++++----
 mm/vmscan.c            | 13 ++++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 59963fbee255..1b5aef2cbd22 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -583,6 +583,7 @@ enum {
 	MM_WALK_TOTAL,		/* page-table walks completed */
 	MM_WALK_EMPTY,		/* walks that found nothing young for this lruvec */
 	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
+	MM_PUD_EMPTY_SKIPPED,	/* PUD subtrees skipped by the PUD-level filter */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 9366416faf5a..a56c7e5f2fd1 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -511,9 +511,9 @@ TRACE_EVENT(mm_mglru_aging,
 TRACE_EVENT(mm_vmscan_lru_gen_walk,
 
 	TP_PROTO(int nid, unsigned long seq, int leaf_total,
-		 int leaf_associated, bool empty),
+		 int leaf_associated, bool empty, int pud_skipped),
 
-	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty),
+	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty, pud_skipped),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -521,6 +521,7 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__field(int, leaf_total)
 		__field(int, leaf_associated)
 		__field(bool, empty)
+		__field(int, pud_skipped)
 	),
 
 	TP_fast_assign(
@@ -529,11 +530,12 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__entry->leaf_total = leaf_total;
 		__entry->leaf_associated = leaf_associated;
 		__entry->empty = empty;
+		__entry->pud_skipped = pud_skipped;
 	),
 
-	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d",
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d pud_skipped=%d",
 		__entry->nid, __entry->seq, __entry->leaf_total,
-		__entry->leaf_associated, __entry->empty)
+		__entry->leaf_associated, __entry->empty, __entry->pud_skipped)
 );
 
 #endif /* CONFIG_LRU_GEN */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2cd3f28f7428..e3616f400014 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3841,8 +3841,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 
 		/* Skip a subtree that had nothing young for this lruvec last gen */
 		if (!walk->force_scan &&
-		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key)) {
+			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
+		}
 
 		if (walk_pmd_range(pud + i, addr, next, args))
 			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
@@ -4223,7 +4225,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			trace_mm_vmscan_lru_gen_walk(
 					lruvec_pgdat(lruvec)->node_id, walk->seq,
 					walk->mm_stats[MM_LEAF_TOTAL],
-					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
+					walk->mm_stats[MM_LEAF_ASSOCIATED], empty,
+					walk->mm_stats[MM_PUD_EMPTY_SKIPPED]);
 		}
 	} while (mm);
 done:
@@ -5905,14 +5908,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxxxxxx";
+		const char *s = "xxxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFALWEE";
+			s = "TYFALWEES";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfalwee";
+			s = "tyfalwees";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.52.0


