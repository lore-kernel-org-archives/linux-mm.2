Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F92C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A8C6B00A1; Thu,  6 Aug 2026 06:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302B16B00A4; Thu,  6 Aug 2026 06:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0F86B00A5; Thu,  6 Aug 2026 06:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9C0C6B00A1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:30:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F9721406E7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:45 +0000 (UTC)
X-FDA: 85070476050.22.64735D3
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C9768000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AALSpgv9;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786012243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VUdggW3N9zgY8xRMku8UMg3OxZse8GK4YwNvg6yDQA=;
	b=pSrE7Grxzdjus4D33E08S4DWjPAzKHjAWiRDuAXqEHY9TF+HU8O3WCcbr4qz+CxdPvWrF0
	jGjjwHX1GTwTjyAFVW/jo9Y1oTlMHRuy6BQs8O4OX321jMwdixUMh/MlKP7fSWrP0GBLzZ
	ROXFP12vOpgHn6MphC1CfSyd3jjADVQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786012243;
	b=af+Qlg+RgO+N4fGPlxVmY4K/EbDIeuyCdL4E5XiUEwyzJ4xllYD9U5GF5X/r1yVKZ6TXml
	8v05QNVQk4PuLoVLCOIsBcs1MKV8oANzFxj6YywAaqy3IVZck404qqfikM/FHODFPzDrte
	mj9FsvCnzUEXNjhAX+BbJsS8S/Ys3mM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AALSpgv9;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0VUdggW3N9zgY8xRMku8UMg3OxZse8GK4YwNvg6yDQA=;
	b=AALSpgv9x9R8r4vHpZkojK5MStUVCAvLVa66ayJ+q+q1vyDt4TVnb/+jKUlWuHFgM6Hp8b
	ks9AL2SpjuEE4MxrfNvRSw+1eSn1GlsXwUZ+NSbo0b3ZpTCXdRiytv7z7ctIRX4KMx7w70
	hw3kULL9cCamdu9CrtV19qlosN2IwsQ=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 3/6] mm/mglru: skip empty PUD subtrees during aging
Date: Thu,  6 Aug 2026 18:29:57 +0800
Message-ID: <20260806103003.3924438-4-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-1-baoquan.he@linux.dev>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5raw15e3ui4h8jr7oafnz6ahc6mh3yzf
X-Rspamd-Queue-Id: 9C9768000C
X-HE-Tag: 1786012243-829049
X-HE-Meta: U2FsdGVkX18KYAWPX3X2/FVVEEiooeTNgMFPALys1NluauMhcCkam9Zz9L5fMtANTUEp0Z8d7pv0O5o7dE476w52MyNeI5zF24KTSLL+EYT8GRq+Jf2TJP/r/t9tP0vc+HFYQpXVrdVzFLepWBwQcLcdfVKQUzVfQTWOtnckDPPiYy6briPb7A0wTC9kVPqyzloHL5Mpueri2veQ7ptmhnbVPP9kgTiIohE4DPsjfMNocGD4D0VSMSIn9Wnub7SIE0H+e7jTYUh+DoWd3PY7XiwxynRTo82FG8K+psUBVxaOFqt7BnDDhiyedePQ/Js1W+SuC9s+kceKbjpPiaXwZ7ckp7g8xoKs+F+C4Pyp+6DUvSKAwsJY6ZcEh8QiLQT6+/nmW0JA1PyOVNrMX3w6vfiNG4BkSVYMQBbZAW78K9Bt8XcO+obrCfviL5R4aJyMMExOvEAqvFWTOJEdIZ3aQVRnVr6Aa7acWKFSvIwARupxWR3NYvxBx4z10va2VfC0Eef91oaiD1I48RHZJEyYrf/tqSaMI9Ev0usJZvzG2H4H44YNSWCJCdlEPOVwTuYFC6S5QDK+RaL9pAt2iKmX5RyXw2C2NvolYGuArRVx9l5BnqbzkaFEOOCgy4aDwd1UFb62xL8+SxsrABzRVgw84rcmH3FvTYmmIe4qMXMO+K7lcZJcIVAIGtIU3+dw701TLqHz9GbMM0yyjTLlt2v2A/RMdpcyczesGjKBwVS+wqQqMMNY2gchn2qTwViUSYjVgCflb4AkFgsS3YoJb39o42Y8w5F2lozhb7IJB+MTozEoILttbAGHSicSYB5Cr8ehT5mXvDypHWmzqezauJ5ptyYk0kXEFn5kc4CqT/CFilLiQOi+YyvTU5DyZScqXKO8T5Vn3b9MKKAkzsMVtnE8o8rjdWG00ij7KPSPzCQHYZ8e5Tw7WQCIa2hSgYi3PsC5NzZLHo4jm8rsob3HWZ5
 dD8yQC/l
 UutVE/BP9KjuN7Ys7l1hwmRDpF8OfTP6eLVTujx4te/Us5SAHGCV2VpWwOuGnvXydlMJQhhR3L3Gm5nBj4ymq5nemCqpl4TthSzW3x3S0jRCMihvzFiyYGxsZrWXMGD/vXQgd150MbAYeLd1veztcl06+Kp793KnFRm/HD8YBXxCuou3NrMm59phh3pkdSKVzw5fCmmR4xPFwVnOSumCbm5WMEq37CT+3kfqE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The aging walk descends every present PUD and iterates all 512 of its
PMDs, testing the PMD-level Bloom filter on each. For a process whose
memory lives only on other NUMA nodes, every PUD of this lruvec fails
the PMD test, so the whole PMD iteration is pure waste - and on
multi-socket systems these cross-node walks are common because
lru_gen_use_mm() marks an mm for all nodes at every context switch.

Add a PUD-level Bloom filter (pud_filters) one level up. walk_pmd_range()
now reports whether it found any young leaf entries; walk_pud_range()
records that in the PUD filter and, on subsequent generations, skips the
whole 1GB subtree when the filter says it had none last generation.
The double-buffered filter flips with each new iteration, and the
existing eviction feedback (lru_gen_look_around()) keeps hot regions
marked, so newly hot or migrated-in pages are re-examined promptly
rather than suppressed indefinitely.

force_scan walks bypass the PUD test, so manual aging and newly added
mm's always rescan and re-populate the filter.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/vmscan.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a397c62b2e5d..74edfe2a747d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2816,6 +2816,13 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
  * walk_pmd_range(); the eviction also report them when walking the rmap
  * in lru_gen_look_around().
  *
+ * A second, coarser pair of filters (pud_filters) sits one level up. It
+ * remembers which 1GB PUD subtrees had young leaf entries, so walk_pud_range()
+ * can skip whole subtrees whose 512 PMDs would all fail the PMD-level test —
+ * e.g. the page tables of a process whose memory lives only on other NUMA
+ * nodes (cross-node empty walks). It mirrors the PMD-level filters: populated
+ * by walk_pmd_range()/lru_gen_look_around(), flipped by reset_pud_bloom_filter().
+ *
  * For future optimizations:
  * 1. It's not necessary to keep both filters all the time. The spare one can be
  *    freed after the RCU grace period and reallocated if needed again.
@@ -2907,6 +2914,23 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 	__reset_bloom_filter(mm_state->filters, seq);
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
@@ -3146,8 +3170,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	spin_unlock(&mm_list->lock);
 
-	if (mm && first)
+	if (mm && first) {
 		reset_bloom_filter(mm_state, walk->seq + 1);
+		reset_pud_bloom_filter(mm_state, walk->seq + 1);
+	}
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3728,10 +3754,11 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
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
@@ -3790,6 +3817,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
+		young = true;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
@@ -3799,6 +3827,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return young;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
@@ -3809,6 +3839,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -3822,7 +3853,20 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		/*
+		 * Cross-node empty walk suppression. A 1GB PUD subtree whose
+		 * 512 PMDs all failed the PMD-level Bloom filter last generation
+		 * found no young leaf entries for this lruvec, so skip the whole
+		 * PMD iteration instead of re-checking every entry. This mirrors
+		 * the PMD-level filter one level up and mainly cuts the cost of
+		 * walking page tables of processes whose memory lives only on
+		 * other NUMA nodes.
+		 */
+		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i))
+			continue;
+
+		if (walk_pmd_range(&val, addr, next, args))
+			update_pud_bloom_filter(mm_state, walk->seq + 1, pud + i);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
-- 
2.54.0


