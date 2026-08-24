Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8E4C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21936B009F; Mon, 24 Aug 2026 03:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8B16B00A0; Mon, 24 Aug 2026 03:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D236B00A1; Mon, 24 Aug 2026 03:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 900AB6B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:39:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20F10120424
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:10 +0000 (UTC)
X-FDA: 85135362060.01.06728A9
Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	by imf16.hostedemail.com (Postfix) with ESMTP id 35740180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOg1ZhnxEZnHo3M3oArfD2yyqEboP+XpsQwYpngu9MA=;
	b=1fvDunFbIIgd6BlQ/j9/G2/+dhrpi80BQorupN9akGE1cfodPfNqZPdQUQs0QuhaksYNVj
	CAvpznQaPn24PNoSSu7oPtmVE+DHL06zdgMCem7n3oEefRYMPBUpIeepZNUXBFkEoin3UJ
	HFaHX+aATziVWdO9cGnZcOaxdFp5uME=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557148;
	b=u3seHLmU+c9TewPmmdC1WERzRgFxTwx6Mp79+Nil8PWWyKcBK80qOmWuxO2D08Nd737uqZ
	alhgVrJ9wjN7OlW5K1PZpK68vp4iqJ29WjIMsQPPymR5t7Sjz0EfmBnR21eNGasoDw3Jj0
	DbszXl++n8oDpgaDXySKsrixeCdqJ40=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id b854645ab578d865;
	Mon, 24 Aug 2026 07:39:07 +0000
X-Mizu-Trace-ID: b854645ab578d865
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
Subject: [PATCH 7/9] mm/mglru: skip PUD subtrees during aging
Date: Mon, 24 Aug 2026 15:38:04 +0800
Message-ID: <20260824073806.629593-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35740180003
X-Stat-Signature: bkfjme7tit5f61838w7q1gkmh67gwwhc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787557148-424608
X-HE-Meta: U2FsdGVkX18zO8AhesgEPHMFdpl7Pw78tgOS6sZSHBvSHdI+HB0ac5qL7tcqe5AJAmREDVcn8nVpxY5vRB5f9RcX53gcHj7jW42axPEJl9WgRVcjvEmjdP8FUZygfLI0UlV6W8KoKWJG/QreHLXqTZgbANq2Tp0dWG51hv6ZurMLteKvHE+LYeBXkQnubV4vT+CRzIsZaM96DGcwsDEUbFuFAyl2Frm2F9q4PTdcSTHQg2KTJjAaXjZ6jg2GEimjxU/KrtL7unFuz6tyfCuqWifzWN9ryPvOyL6iqymhyLtSHbEkfWtYanARke1qNlMMIDn3bdbMCzQ1WPHJbAOJhfNNjhRiaDQmGPfgY0wzpkwtE7FAgFGJ6sSwpQIRW1pdTvRxyrh9XFzPqk910sM85fiq8SNJM52YF0c/+OvhDGtYa+2YL/FIaT7ePlmiu2VG97+rMQT6E4Y5efcbfDNPNRKUOFbOtIy221gJqGTXkfHN11FvGfeSlBjwjBJDkVkfqZcG3orAWCAPkQ9RsWTlfOyuwfQoQLET2gJ1sVmGDVxL73ZuWT7pJXkjODqUfajkgx4ZoooHolRrY9/d/f8dK4QzwZQdesWb6ibcysqN/V/9bvlfnX+dKTmRkFGQDBtYvpiIGFMhoPfBolTTPQsThDJ225cGIoR9steRca97rk5cMYr5fMNJU3NiifWDIevNlE2NtCc3J6raW3pUOiR3dLagY9DBfEmAqVzxBNSMbfacknBsd1pPdue8KETBCyn2hHkbhY/LXOtVf03q7iGmEfwRk2/SiBzZE34E3gi0ZYF1r/0Gu2Jm0eY0XxZ7BsNXWJrg3cPbgDuU7+K7eFliJLVIH5C5zWaThInGYxfZ5dDQ68muAghxWPnmMpntCb37KmJegwii8qoc7jYaCbUvQnTysnJ4Ldxs8bykaNI+aoW6GzY5NnNOG4vee9DIr70pXaMfGCEFHXLoEFCHAdK
 HSUgBnC3
 koPmu2AHMXxKKIweWgYQS2czYQZHbkO1wuGPcRuhNDLZem//H5C6uQAnS8c2rDCrvi1uaKWboHz1GbgpxISseF9/BfBW1EtCnW1L/dIAHX02/cAUXf+C7btS1AhqJYj1MaobIEkqemuUtpJsmpqIch/Pg+ZbOMx5JP9guTY9RkmU+pFYvykUIpG445zjd8arebPXBzMbeS64bFjDTOh1kbBhRUSQAvdPySylCvSjGYWv7VlN6GL5taRw9+B1uVoo3Gs3sy8rxr2KUMaaa0N6PNRcFcNIHMBJMQYxFG1iuSEQyp2W032fWFeoN3fXzjVEGCnAjlS2l387SsjLDXeZRvVXvp5rHed9keJB62O0bbj6fUxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The aging walk into present PUD and iterates all its 512 PMDs, testing the
PMD-level Bloom filter on each. Add a coarser PUD-level filter
(pud_filters) one level up:
 - walk_pmd_range() now reports whether it found any young leaf entries,
 - and walk_pud_range() records that in the PUD filter and,
 - on subsequent generations, skips the whole 1GB subtree when the filter says
   it had none last generation.

The double-buffered filter flips with each new iteration, and the existing
eviction feedback (lru_gen_look_around()) keeps hot regions marked, so newly
hot or migrated-in pages are re-checked promptly rather than suppressed
indefinitely. force_scan walks bypass the PUD test, so manual aging and newly
added mm's always rescan and re-populate the filter.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/vmscan.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 062504f287da..7a6c15be1c2a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2817,6 +2817,8 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
  * walk_pmd_range(); the eviction also report them when walking the rmap
  * in lru_gen_look_around().
  *
+ * A second, coarser pair of filters (pud_filters) sits one level up.
+ *
  * For future optimizations:
  * 1. It's not necessary to keep both filters all the time. The spare one can be
  *    freed after the RCU grace period and reallocated if needed again.
@@ -2908,6 +2910,23 @@ static void reset_pmd_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned l
 	__reset_bloom_filter(mm_state->pmd_filters, seq);
 }
 
+static bool test_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+				  void *item)
+{
+	return __test_bloom_filter(mm_state->pud_filters, seq, item);
+}
+
+static void update_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+				    void *item)
+{
+	__update_bloom_filter(mm_state->pud_filters, seq, item);
+}
+
+static void reset_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+{
+	__reset_bloom_filter(mm_state->pud_filters, seq);
+}
+
 /******************************************************************************
  *                          mm_struct list
  ******************************************************************************/
@@ -3158,8 +3177,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	spin_unlock(&mm_list->lock);
 
-	if (mm && first)
+	if (mm && first) {
 		reset_pmd_bloom_filter(mm_state, walk->seq + 1);
+		reset_pud_bloom_filter(mm_state, walk->seq + 1);
+	}
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3744,10 +3765,11 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	*first = -1;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
+	bool young = false;
 	pmd_t *pmd;
 	unsigned long next;
 	unsigned long addr;
@@ -3784,8 +3806,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
-			if (pfn != -1)
+			if (pfn != -1) {
 				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				young = true;
+			}
 			continue;
 		}
 
@@ -3795,6 +3819,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 				continue;
 
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			young = true;
 		}
 
 		if (!walk->force_scan && !test_pmd_bloom_filter(mm_state, walk->seq, pmd + i))
@@ -3806,6 +3831,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
+		young = true;
 
 		/* carry over to the next generation */
 		update_pmd_bloom_filter(mm_state, walk->seq + 1, pmd + i);
@@ -3815,6 +3841,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return young;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
@@ -3825,6 +3853,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -3838,7 +3867,12 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		/* Skip a subtree whose 512 PMDs all failed the PMD-level filter last gen */
+		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i))
+			continue;
+
+		if (walk_pmd_range(&val, addr, next, args))
+			update_pud_bloom_filter(mm_state, walk->seq + 1, pud + i);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -6027,6 +6061,8 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
 			bitmap_free(mm_state->pmd_filters[i]);
 			mm_state->pmd_filters[i] = NULL;
+			bitmap_free(mm_state->pud_filters[i]);
+			mm_state->pud_filters[i] = NULL;
 		}
 	}
 }
-- 
2.54.0


