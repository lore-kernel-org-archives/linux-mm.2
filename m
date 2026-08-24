Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C68C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755296B00A1; Mon, 24 Aug 2026 03:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CF56B00A2; Mon, 24 Aug 2026 03:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643026B00A3; Mon, 24 Aug 2026 03:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43A5B6B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:39:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D49F0A048B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:24 +0000 (UTC)
X-FDA: 85135362648.07.E504C1A
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D68DC0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNf+yPkYuK8+qDMs3eklGYYOdkeyam0ZTXOFEGRjmBY=;
	b=mTTwBdXAsje78wYIhyDBpOoG/Btn0kal3tbQ3DFr2BrIzeq+tMpFJGVJVbIrsqUM/ARTom
	I2/QmzlVC9FFhg/jXm/YDXnQefZADHxufqnBRiImEaQjX093fqiYV0C20/VnMapgBBJnkD
	YjYLyj0SpGmoKb3WKAzCh6aCQd7S0b8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557163;
	b=VDfsZzqrAzrq9+EXoZvL2dNOaelUgo0AiCz+OSazO2+d4uV6XxRQTDz3WUW21iCOc6jbpP
	rsJYhS0Jzl2s9kA5H4z+EDiWVpuwodpqkP5yfaFFLNVgnDnoIQp7hAgPfgluRhj3YaKJeF
	ijgOj8IaphxroWX8v5JOcurQBBiWCHA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id b0d833f464dec23e;
	Mon, 24 Aug 2026 07:39:21 +0000
X-Mizu-Trace-ID: b0d833f464dec23e
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
Subject: [PATCH 9/9] mm/mglru: count PUD subtrees skipped by the PUD-level filter
Date: Mon, 24 Aug 2026 15:38:06 +0800
Message-ID: <20260824073806.629593-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d6kdhhqag5hmacy6oh99bzbrer1c1i6i
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D68DC0003
X-HE-Tag: 1787557162-39087
X-HE-Meta: U2FsdGVkX18S1HK+mnDN6dTymiK04RvUYg84U+78RA9EcahYZ/ldFHu79Z5stH5mMgxcbQKAROa+G6H9u14jImhqODOUEL5FC2ohUyCWwcCmS0x7mgcHeS1QPHn5NXDhsv6X206wh1OCuOgz8GiKCa3RqCZNNcyqcsC6FpsnzwtIWAEhy+NmKPd02f8z5l73o52UeC9ys8V4LHeZj/bgSj9S/FpXAMEK8sy5dZO2SmmfeHZPXqPyuSN+VKIL6IeF8FB2nmuB6XJRe+gMy9Zs0+wyQHrwtOisi+Gt8Jk1MBEV14Wms73GubkDBZT8zat+q6vDeW3ajAQuh+YWzC12T61CqhRp2+FrjrbloLjks5e96DhRSJ1CTUa8Qa7HpFgedu+iNpjunjpq48ujZrR4wnf3mwFBY8sCdieSwMjxH6KSiIklVqTEm/ovSM5KHUS5s/zmBH3Wo/u8IRjxYoZYuEZXlATl+vkhoqWU3urSwOemSXO1q+EqqNt7AYGez++ZFyLfXShdv79KJEy+uiCzJqJ8AaM9MxaJXGVn2CnDhS3LE1Dr5eAtHx7uFSzn7Aafk1HXK7LdEpynfyy/66PsgCfXWrmu6gtwHxSdb3/NxmMXgv4wm/Y6759GI3pHQTpsR/c9nqkHosdEbphmDbxWLlUESpcCTA5p2O0ExC2M6t3QFbogJHsSlwme2ifVNAYSoiC6pzQWB7fn5qHqEnE9qAWZpa4XLYg8XhCAihmkK0CN06NKzCn17CVtpq9UYhnlr3WD+MqF5t1x8Gy9GO5hoeKJ+fI3pD+clTM0wIceA90cowDbgERLqmXGurZx0WtwPWcUv7Xuqqn2bEc9/r9zsKjdpe3+p7z+bZWSpql1y/B+8vrxnvnoY64ztODNMlLgni9MnoX6+l7e2Y+Vb/ieCy9+8wpmsrSmRC9u5IIkYEfvNUvoUEsQ6DftFIv2fyAvsFrEtZCfGDD4fVWzuzv
 FmzS12H5
 XJthK4VYmFmn9rETwCzgln5uu1RiIWTPMs8UZEJ0VCadQLWCcklvxI+ebTXyLjj7IpVAndL1tUBtV5s4C7gyVFtde/NetAq9fPEO/Esum+RUoB1y2EjdgXuo/P0DYQp/4KJxjjHgsqfOIdmJT0B5+uTUeP5/7GSn4DPXty0WSeEali3ytifiUDeJ3+LfEKJCfU9c4oAp8c8CMtISSSCGkB/it9kIlio7qB9coFiww4/IMHks1xMdoTob2GrWjcLtU9iSPgFa/Sc0L7M8iwkFXWT8R+defau+KhT68GncpUPKWliT18jZYtLLqzaxtL16fwJyKMLxbIXRHxyucxiuK3kqlp2+SJeB8Z7GyLM099+4gbxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add MM_PUD_EMPTY_SKIPPED, incremented in walk_pud_range() whenever a PUD
subtree is skipped by the filter. Like other counters accumulated
per walk, shown in debugfs lru_gen output (the "S" column of TYFALWEES)
and via the mm_vmscan_lru_gen_walk tracepoint, so the avoided cost
by the filter can be measured directly.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h        |  1 +
 include/trace/events/vmscan.h | 10 ++++++----
 mm/vmscan.c                   | 13 ++++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 64eb010624b2..a039df84f907 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -599,6 +599,7 @@ enum {
 	MM_WALK_TOTAL,		/* page-table walks completed */
 	MM_WALK_EMPTY,		/* walks that found no eligible folio */
 	MM_LEAF_TOTAL_EMPTY,	/* leaf entries scanned by empty walks */
+	MM_PUD_EMPTY_SKIPPED,	/* PUD subtrees skipped by the PUD-level filter */
 	NR_MM_STATS
 };
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index c7c2034715b6..923fbdb20de6 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -662,9 +662,9 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 TRACE_EVENT(mm_vmscan_lru_gen_walk,
 
 	TP_PROTO(int nid, unsigned long seq, int leaf_total,
-		 int leaf_eligible, bool empty),
+		 int leaf_eligible, bool empty, int pud_skipped),
 
-	TP_ARGS(nid, seq, leaf_total, leaf_eligible, empty),
+	TP_ARGS(nid, seq, leaf_total, leaf_eligible, empty, pud_skipped),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -672,6 +672,7 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__field(int, leaf_total)
 		__field(int, leaf_eligible)
 		__field(bool, empty)
+		__field(int, pud_skipped)
 	),
 
 	TP_fast_assign(
@@ -680,11 +681,12 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__entry->leaf_total = leaf_total;
 		__entry->leaf_eligible = leaf_eligible;
 		__entry->empty = empty;
+		__entry->pud_skipped = pud_skipped;
 	),
 
-	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_eligible=%d empty=%d",
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_eligible=%d empty=%d pud_skipped=%d",
 		__entry->nid, __entry->seq, __entry->leaf_total,
-		__entry->leaf_eligible, __entry->empty)
+		__entry->leaf_eligible, __entry->empty, __entry->pud_skipped)
 );
 
 #endif /* _TRACE_VMSCAN_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index cc41d3692bd5..fa437b187a05 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3868,8 +3868,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			continue;
 
 		/* Skip a subtree whose 512 PMDs all failed the PMD-level filter last gen */
-		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i))
+		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i)) {
+			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
+		}
 
 		if (walk_pmd_range(&val, addr, next, args))
 			update_pud_bloom_filter(mm_state, walk->seq + 1, pud + i);
@@ -4213,7 +4215,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			trace_mm_vmscan_lru_gen_walk(
 					lruvec_pgdat(lruvec)->node_id, walk->seq,
 					walk->mm_stats[MM_LEAF_TOTAL],
-					walk->mm_stats[MM_LEAF_ELIGIBLE], empty);
+					walk->mm_stats[MM_LEAF_ELIGIBLE], empty,
+					walk->mm_stats[MM_PUD_EMPTY_SKIPPED]);
 		}
 	} while (mm);
 done:
@@ -5698,14 +5701,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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
2.54.0


