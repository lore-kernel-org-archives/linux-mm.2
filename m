Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD495606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uwiASvFY
Received: by kanga.kvack.org (Postfix)
	id D06A56B05BC; Mon, 23 Nov 2026 03:58:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7456B05BD; Mon, 23 Nov 2026 03:58:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD0D6B05BE; Mon, 23 Nov 2026 03:58:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD6C6B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B04F1C4204
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:53 +0000 (UTC)
X-FDA: 85465783746.22.5EDEC3C
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38EB1120005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uwiASvFY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424331;
	b=0u+qFMqWWl6bKyoPRuGtwfGqqCGHTQBKkYnXZ/GDWQvYlzZV0TAKegtA0J1qTEuWNIJXT0
	9RVQOxt9+VU9q+llUA323n/5GHFz7LcquOB18QR3qU4wAaux8EKPldMbte5TYUJZAgMgCT
	c+vWQQdhhL8A4XsdqLeNse1fPQ7dpLU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fxx4Rgy9ksUxSUbEzmo56PzxrUZutwvDsgR9bgMmvEs=;
	b=aLsuJ/1WMFRYlErlgjD1zO6fIkDIR0HRHgGwa1D4A1wI1OFvzKXXYmNclHFiTg78MI4xGj
	5/WpRcVN9zqZBtlxYXQ+1+H04EVcBOXj0cE9/Cd6OCfAWwjNRsEEusqWISteMKy1cm5ReV
	A0NhFYH2U5rqXBuUOUi5WLVPATDmGi0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uwiASvFY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t4sCzqHR88Y25+J1YHaaE/fVXysL8JS23zXSw97o2Bo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795424329; v=1; x=1796029129;
 b=uwiASvFYObV6nuWxx4C+cQf/IwA2GztvvNMG8WiLy3D149+Knsl4C3ITK9y7kmzIe05mRNuV
 DkdRc1nwZsKqAiGX1yOuMJTfbLkU8DTWcRIjknc9VTEldd1OHZMNbkIM09GNVf70IYvTQIpXoUb
 mNkQpmUlTpXOC9lFsermrQcU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id fc889abbb2942364;
	Mon, 23 Nov 2026 08:58:49 +0000
X-Mizu-Trace-ID: fc889abbb2942364
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 4/4] mm/mglru: count PUD subtrees skipped by the PUD-level filter
Date: Mon, 23 Nov 2026 16:58:00 +0800
Message-ID: <20261123085800.981256-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261123085800.981256-1-baoquan.he@linux.dev>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a9kxwzskujg4cazqd69j463szof7frfi
X-Rspamd-Queue-Id: 38EB1120005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795424330-416457
X-HE-Meta: U2FsdGVkX18h5znpPVF50Bzj7En9nN+WvIVJ6WIaKxpWWg4b/G83PWzt89nYwupS6vt+4N0rod6CVg/GF1GecVjP822u4vA+qB3pzjtwsU98dolFrnurV809GdoqFbXIK/p/VJ4uBer6AM6Qg2kPHmopSTrLK1srWKEacgXo+6p4V3yL26lp79fO5W4N3k3S4KXlCxUeurssocr8Ta0YnjV9bhPrZtcSX4tciu9Ojf718xYZ3YkzYh+K3vddZrwjk22m7P36s2RveTIDW7l8oCojhz9dTEw3/qZPRqCuEbHm/zG6BivPRAnlHJipQWX4wSWUl/eGbMt7NjTixxRbKWzqQRKQE0hRgg8BC9zZJWAAuf22AH/a4see55+G/w2BblcXiVPZqsOfPe/oqHjNjw4j8tYZbhqVr6cSs7cwgwwqQxVXcZlpF2E5vazCCbqIPbgZaPWumg4PWj3pDVJSqrHWcg59JCyHHG42XU0J/dF1ZCoGp+hT7Sq5iujTNb3Q3zHNAsjUK0TlZ1eazAdgieRHgE8T53gyRexZyoLEQizEKNUOvEwYAXQyGBEBXlKE1pr+DdxuOgRMZYU5YbuhyFH7fzBpjgW65Ok7jtjJRuOhmgCUD6HwP3AxCTZrueTzaHfNhgRdjr5JyRy93oFqzYPr2ibkBlM9g3ji2Nu3XfyanB+f6MjC6qSGmnHrXuutxrJRs8VlbG8/kn9AgkZrsapRZn2Q+6/PQmLppQSB+5HNyV69aHNRmaxPMg5BZlqSg8rzFFepLOjdJFWFaQ3sMVaIgUZ4MVQue7NCN0YwCVM+4H1KaGTzD7DKduOFwOIrqxKx/5WoGa0XYOqJTSf+kKuFVlIvvUCAQar+vNvTrQ40+Y8YX5p49G5OP2XA1lJ9LQ03M9VsljdUXnh31Q4EvtIH47CQAk2i4wTHZTKsgx3CPJTTW1eZyqm2U4jAdpw8dX4cGb8VDCTVdEjNDjh
 5xy7Lm18
 u+x3FE13UEqgmfJFjVzqHgHibsr/55+TgUZQqbZPON08hO44H6MVZjNlF/eu18dTSewyMEbaMb6t1i5GW4IXfawZxP/K26zWPJujC10IqphzqmnLqvKGRz30ju0zvgn8s/12uFfS7KxWUsitR7XN2C2kNa4J5PDtgr1/6B7hQk/y8Pvx/h3SXfNxTDlfip/Npiws6mEqHIYARhE0FYMFbXOpPLweCuSGM82NpjV8WPlbiBvHxLgxfqJJ2+zTk9lgI/I5jVItA+xgaEDVbvZGH9AqKxE/XqnxtsFA2fXw3YcOqB9p51MIlQRzWLqytByGjqTCtquHPA5G+6FXXTBGDWp19femC/dTY9dsElT/sC8i7TwOE7Y/gYFNLIp3VY3F4nUNDJb/m/VirL79w2f5PBFpnfkkqTdqVhH53QIWMS0cb1fqn36s+DJzq7ZliFhKs018A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add MM_PUD_EMPTY_SKIPPED, incremented in walk_pud_range() whenever a PUD
subtree is skipped by the filter. Like the other per-walk counters it is
shown in the debugfs lru_gen output (the "S" column of TYFAWEES) and in
the mm_vmscan_lru_gen_walk tracepoint, so the avoided cost can be measured
directly.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  1 +
 mm/trace_vmscan.h      | 10 ++++++----
 mm/vmscan.c            | 13 ++++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 07e6c887e21a..a1437728180d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -582,6 +582,7 @@ enum {
 	MM_WALK_TOTAL,		/* page-table walks completed */
 	MM_WALK_EMPTY,		/* walks that found no young leaf for this lruvec */
 	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
+	MM_PUD_EMPTY_SKIPPED,	/* PUD subtrees skipped by the PUD-level filter */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index b0c2af65c1ea..5a78b8ca3dac 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -511,9 +511,9 @@ TRACE_EVENT(mm_mglru_aging,
 TRACE_EVENT(mm_vmscan_lru_gen_walk,
 
 	TP_PROTO(int nid, unsigned long seq, int leaf_total,
-		 int leaf_young, bool empty),
+		 int leaf_young, bool empty, int pud_skipped),
 
-	TP_ARGS(nid, seq, leaf_total, leaf_young, empty),
+	TP_ARGS(nid, seq, leaf_total, leaf_young, empty, pud_skipped),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -521,6 +521,7 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__field(int, leaf_total)
 		__field(int, leaf_young)
 		__field(bool, empty)
+		__field(int, pud_skipped)
 	),
 
 	TP_fast_assign(
@@ -529,11 +530,12 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__entry->leaf_total = leaf_total;
 		__entry->leaf_young = leaf_young;
 		__entry->empty = empty;
+		__entry->pud_skipped = pud_skipped;
 	),
 
-	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_young=%d empty=%d",
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_young=%d empty=%d pud_skipped=%d",
 		__entry->nid, __entry->seq, __entry->leaf_total,
-		__entry->leaf_young, __entry->empty)
+		__entry->leaf_young, __entry->empty, __entry->pud_skipped)
 );
 
 #endif /* CONFIG_LRU_GEN */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 517f5fbecdbf..56e18ffd3383 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3836,8 +3836,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 
 		/* Skip a subtree that had nothing young for this lruvec last gen */
 		if (!walk->force_scan &&
-		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key)) {
+			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
+		}
 
 		if (walk_pmd_range(pud + i, addr, next, args))
 			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
@@ -4221,7 +4223,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			trace_mm_vmscan_lru_gen_walk(
 					lruvec_pgdat(lruvec)->node_id, walk->seq,
 					walk->mm_stats[MM_LEAF_TOTAL],
-					walk->mm_stats[MM_LEAF_YOUNG], empty);
+					walk->mm_stats[MM_LEAF_YOUNG], empty,
+					walk->mm_stats[MM_PUD_EMPTY_SKIPPED]);
 		}
 	} while (mm);
 done:
@@ -5903,14 +5906,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxxxxxx";
+		const char *s = "xxxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFAWEE";
+			s = "TYFAWEES";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfawee";
+			s = "tyfawees";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.52.0


