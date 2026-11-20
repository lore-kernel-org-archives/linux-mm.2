Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAA9606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CYfOO2Sr
Received: by kanga.kvack.org (Postfix)
	id 720E96B05F5; Fri, 20 Nov 2026 03:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1076B05F7; Fri, 20 Nov 2026 03:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E126B05F8; Fri, 20 Nov 2026 03:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4009F6B05F5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3A67120E03
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:21 +0000 (UTC)
X-FDA: 85454896002.29.910CEDB
Received: from mta0.migadu.com (out-76.mta0.migadu.com [91.218.175.76])
	by imf16.hostedemail.com (Postfix) with ESMTP id BBA0E180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYfOO2Sr;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165100;
	b=dlIjlzgdMvregue61+snCw+1TrXD7tlZakDKr5bwAFd+MYDZ8BXRPaMlk9X/6b+QUy0SLS
	ea9iXgXys7vdjBv86vodTZ3Ily7owWpZskaSkcqvunjnn890JSuDxVCva/D8C+TUvMBG5w
	mxxvOyIzxaM4zxwIeoYYRqE9HsKpzC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bax/U5tAK6MFKND51+7KIgCTcGG9l8X/xODSNXhEboQ=;
	b=gvhENmd8P7dBpWJVYa9ZJjRBBdEgeroIUZlGRzzZlektss3ssKXiKgqA9Hm/t11gYmX+jr
	a4O331lP8dFFObKAppx5HwkqVicE52QvcRmnf2gE8aPH2gX7RP58IHiGCctv0NzwJh7Sso
	uGCA8JcZdYiIL/E8lae2JkK+EEIBNxk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYfOO2Sr;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AYAH/TqlMiT9ARWUhQ4PinqFKp/jB3HVJClWXBTv9DQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165098; v=1; x=1795769898;
 b=CYfOO2Sros2ZqLvdm1HbJ2Zme4gktlJwYdcKf3rllEfwQHF/OZbzNkuuCLuiC7paEY9xSbpP
 rYaa7h/dTAQhMk/Y6fhuob6mH9BVMg1yRla42DqWAQyq736FjE1fRLguqwGhc3YcZDzo+ABtAG4
 yacnqpOGgnm6c8/f0s1cD0OA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5770758a43854674;
	Fri, 20 Nov 2026 08:58:18 +0000
X-Mizu-Trace-ID: 5770758a43854674
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
Subject: [PATCH 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Date: Fri, 20 Nov 2026 16:58:03 +0800
Message-ID: <20261120085806.781225-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261120085806.781225-1-baoquan.he@linux.dev>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BBA0E180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bd5mwtmsygayyqno6rhcompd7uc8xcm3
X-HE-Tag: 1795165099-473463
X-HE-Meta: U2FsdGVkX18Ca8xApPLzOtiod7L+q0AAo48wB+p40d8J3qmJyWwoJiyna1Mn/YtLxkA4wucIb5eQrtmrwjsaAH8o3zAXXfpUGB7A7zqjWe9jiIXdWVhKFZSYN05ESgzpeNrbxIpO9vLVOBRKanyhtiOjD8nUACbqzwskICwVSJXDSUO5/SPn6w/K/R32xzopJ1UCnxkNwAr2n5y7BbY30KJgJJWRHNkVKxOQjn5xwgzcOv5QR7GTz5+BRIX0PCMCSGspmruBZMj7egwopnENbhIUA/crPnxdFdEcSA0kcK9OCZEDxt2c1PHwky1/A44+zDc6sbKkRpRorTqbITlSzQ+/n/TSUxYByPgifQbal5RGQBJPWeWpOe0CPrYrj1Sm1dRmV/S5LMWTA0wHj8Hn/FCVPl4lVjGohIUPUkQUsh6b1gJD/5X25VJlyfhCbKla+jiMcvj9FOb6vjPydHmDb7R4q8JI9hX/zC1a82jzi6332hbJKtRHptvEMDCunZ+0OHQ/NNhZ+8dMM15qa4EqiSocjF0hX8u3TsCKmVM9Y3VNIKmPZwnX8ltFcDlTdGdhimXdF4yGK8gphfsI0yQhIwYn0t51p/M5STdCFQw/+WfJcNiZzoGFTj2CPm7iC7KBQTrx1cgil9eA2zuyUtKZJbx0wChmnSlbNmyRa/2FDILxoSzolkOhaIvV2iGRfRVf+f64vwmV5uaTRykqJeTHdiZHZHdJEZhVk3XxCxkSLYuXGUekRhuiN7PQpBVbTnwD1w3lSSh2l68lIJvIuUQhC2q9WsyeBrzaPJ+Lo9qBQKMe+gnIpC9EuHc2auaELMcgHL9nQSOkL40r9PXvV7vTVt+MDbiU8jre1vyzRHDmxcQvZlv4g4K5pXE9otSIKDpu7Hi4j3ajjyvs+i6QAxqjNBqZC/IuSHXmWEOWPdgTdZ6yRh9Uo+l6jDZTyTXzLq8CMFl5WQHY39xgb2tdINj
 tlvMxw0e
 +4g4fqMK1NFIGc4Y6Pv/AbD7uaTMqUwabFgsEX/ikriwSRQNEQYzd9OLGu3UG2grNLbMuwU6SbZgH7GXsBFfjyS8k1Sfn54NKJubfCNCRDziqob5zov7pzDf6WGCLFLH5OX0M2fb9cKMLyzwiYpLmxd8PtOU9Q2eqee+Dz+TBExiHxs+NjvvxfwXmxDgFFeOU6/T05TLZY1xpgPKhRNYcdnV4fj//n5GGHGy3FB6Ar8tROQ1m2oitz4G21zjmKAVspGcOVrZAS5EwP3QPmbka4p2qCJbVD2b/fYXAPb7c1VlBicUPGx5bCdLs1G5218Gjei9gbKRibhWQMRHAsvi/uibnp+WUW5RrQ8bDhu3PwE7QxZpfSVI+vH0Vn2H+vc0rj5DLjeobGdfdwxJMbfpM+YdIB0t4Je5QpaPmLk20/gKvPK9Z+3L2sneeDvdk0HchclHd8NbvhqoOjf773W+e+YmK9si7n9UMyRKtZluhnjR/GhtSeTYmYPU6b3HbQgH/hpMv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

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

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  4 ++++
 mm/trace_vmscan.h      | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c            | 34 ++++++++++++++++++++++++++++++----
 3 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2ad0cff795..902f4877fd0c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -579,6 +579,10 @@ enum {
 	MM_LEAF_YOUNG,		/* young leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
+	MM_LEAF_ASSOCIATED,	/* young leaf entries whose folio is in this lruvec */
+	MM_WALK_TOTAL,		/* page-table walks completed */
+	MM_WALK_EMPTY,		/* walks that found nothing young for this lruvec */
+	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 9dafdb5bd3ce..9366416faf5a 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -508,6 +508,34 @@ TRACE_EVENT(mm_mglru_aging,
 		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
 		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
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
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..36e0946bf2cc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3584,6 +3584,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
+		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
+
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
@@ -3591,6 +3593,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 						   max_nr, FPB_MERGE_YOUNG_DIRTY);
 			total += nr - 1;
 			walk->mm_stats[MM_LEAF_TOTAL] += nr - 1;
+			walk->mm_stats[MM_LEAF_ASSOCIATED] += nr - 1;
 		}
 
 		if (!test_and_clear_young_ptes_notify(args->vma, addr, cur_pte, nr))
@@ -3682,6 +3685,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
+		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
+
 		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
@@ -4158,8 +4163,29 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
 	do {
 		success = iterate_mm_list(walk, &mm);
-		if (mm)
+		if (mm) {
+			bool empty = false;
+
 			walk_mm(mm, walk);
+			/*
+			 * A walk that traversed page tables but found nothing
+			 * young for this lruvec (node+memcg) is pure waste:
+			 * the PUD-level filter will skip it next generation.
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
@@ -5804,14 +5830,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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
2.52.0


