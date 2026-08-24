Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A12C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2038A6B009D; Mon, 24 Aug 2026 03:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185F86B009F; Mon, 24 Aug 2026 03:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074E26B00A0; Mon, 24 Aug 2026 03:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE3206B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:39:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D070160477
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:01 +0000 (UTC)
X-FDA: 85135361682.04.4DD4974
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7822CC000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qq5xBeJv1JeLERBDQQCJd7goLSe3eRusHem/h4VHA1A=;
	b=1C8+DHsxZp8SMWPK6y3kExQ1xCF0YEJ9pPLg6K59N0bsg8RGI4Eqbgb8kbu1WWF9K/maCf
	V9HgYZ2E2rNXHVH9YeDB5D0YmimppNlRz83j2bxPW1F+Oco6oYVGvg4PT4uUylxAfuvbTG
	g5Q7v+61qErzUE/9MunQOjNhuoQNTo0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557139;
	b=36N0dYHqjzocMRVFayrSMkoUsexRSagnmDOa7AUpTN7MgSODlsublnU+TWz/KLt4b/pSUr
	7MjEj0t3/RDfvwxVzwKjPu/JwqwDq6QkO7ydug+s9JJ1k7zEhaGETtBcfhJ50GaF5UELZV
	1LQb8iSWOXEcndvUO+M/8Th4N7pRBhY=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 8c39e84324b5293c;
	Mon, 24 Aug 2026 07:38:58 +0000
X-Mizu-Trace-ID: 8c39e84324b5293c
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
Subject: [PATCH 6/9] mm/mglru: refactor Bloom filter helpers for two filter levels
Date: Mon, 24 Aug 2026 15:38:03 +0800
Message-ID: <20260824073806.629593-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7822CC000B
X-Rspamd-Server: rspam07
X-Stat-Signature: xsx5sodbj51bdgu4cx7cbkqkcdycdhy7
X-HE-Tag: 1787557139-419109
X-HE-Meta: U2FsdGVkX18r+bt5cYhczaBqphIvdJn/xKWVqN7DxPK5Hp4OONRADsS51tT9av261PiNRgpm3my9XvZecULuLpRfeNhgrmIaI6Uv1YMvRiq4lxfg4Vx/s2tpLeKrUSUNyq8KN76kEOYf+asLtwdMSm/DcTfTPumy+sANk/Vadfznxzu8zfkwHsTIdiG/W7UMa29KQ9GEeBy8JLBXhWzFyLEcYld70MJs1ecQUmvZGCTvXWPfksXxEWwKBnV7/t0m8gfI/VKPNjmDRjODsmYsvXavWKGMi8l2bVyB0ja4Iow95FpjQhM9o268qL6q0KR2Ag1/4FQMFpq9lFAae7U1RRaajQRDzHO++Wl//f3pN3SHSjj3S+/OIr4kbTuiE6SFNNXUpeCsRRrGPRoQOT8O1Ap/s8B8/rB4bQnpZXkRyIN4rhR3ggfqZdyjbTNgFdXIUsNoPzqSBW0/MwIK73Xj56mWp5jR5ngQpRZPpEV742crISXSfNjYlO49sg7zYt5F8iQm3YMoo8ju5DrzHdq3sFpywMaGzphfsB63TWJuAKYPi2ilHarDARMokRpDZNaGAMqzAluj+h9a50EgmvT62bvZq2vKNyhidNXEvb6OAk73JQcDF7T8OIPIAwBliYVDql7TcbrUsJE5xJAU5EOiND2h9JiVZ0cDihRduP4zATSLl+f3jr2AB577U8WnWNTzMylRAbH+dNSQjhkKXjSzOJL9FISEYkQTi5ZhI3tr3RLiWhXIgHxrxCpX3GYDDTP6KpUSfq4K6JZGYekucogOWB+W7Jpg89Doy4ifFl/UNNEKIcT/zSd7o37T6dRkhfv1uBXfhxjzvCIFO0Y9d2a+e4h1V/G1V6O7z6E/9t1tQm+T9sBAMAQSwCxcZmW5YSX1yO09DgtToEdkBbTyekaeP7GlpwzZ/cFUMhs2lK8jqksypBsayPyn9IdoeNF3tKyUSFi7UN3TsKmwojHozMb
 0pfvt1EI
 onBU+t7tJKis9Khz7Cz3mq5wFEWqZ1UIy5yAR9G6OzbspokejxgW9Lb9wrvvzq/f7tMU9wpStMDTq5yLNETcIzCgb/yls/z/PmvMJNu22BqZul49iRcvQb1dGofX/5hGJLNlmYu+KllEFCMrcTl6mgswYJpXwxbY846bkTbxnmNOEf6vqi+xn9wOzKTotW5sDhGCieC5MbUcsfM+U0fR8fjyx5p/+k4NWD7tknWOzp/15xQWitn8713CmezIUq5bysAEYlFm7FTeG4imEfNikrNhWE3R1/E8DFJ90ZSPWTGCOSBxUh0iBjRL1Kr3Y9VuLNIg29BShMgiR6+mbTUpvOdeKqtm2Dscs1eCA7V7muREunF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split functions test/update/reset_bloom_filter() into __ prefixed helpers
that operate on a generic filters array, and wrappers
(test/update/reset_pmd_bloom_filter()) that pass PMD-level mm_state->pmd_filters
as parameter. Then PUD-level filter pair can reuse the same hash,
double-buffering and reset. no behavior change yet.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/vmscan.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 912cbf86c7ff..062504f287da 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2842,14 +2842,13 @@ static void get_item_key(void *item, int *key)
 	key[1] = hash >> BLOOM_FILTER_SHIFT;
 }
 
-static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-			      void *item)
+static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->pmd_filters[gen]);
+	filter = READ_ONCE(filters[gen]);
 	if (!filter)
 		return true;
 
@@ -2858,14 +2857,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
 	return test_bit(key[0], filter) && test_bit(key[1], filter);
 }
 
-static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-				void *item)
+static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->pmd_filters[gen]);
+	filter = READ_ONCE(filters[gen]);
 	if (!filter)
 		return;
 
@@ -2877,12 +2875,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 		set_bit(key[1], filter);
 }
 
-static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+static void __reset_bloom_filter(unsigned long **filters, unsigned long seq)
 {
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = mm_state->pmd_filters[gen];
+	filter = filters[gen];
 	if (filter) {
 		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
 		return;
@@ -2890,7 +2888,24 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->pmd_filters[gen], filter);
+	WRITE_ONCE(filters[gen], filter);
+}
+
+static bool test_pmd_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+			      void *item)
+{
+	return __test_bloom_filter(mm_state->pmd_filters, seq, item);
+}
+
+static void update_pmd_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+				void *item)
+{
+	__update_bloom_filter(mm_state->pmd_filters, seq, item);
+}
+
+static void reset_pmd_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+{
+	__reset_bloom_filter(mm_state->pmd_filters, seq);
 }
 
 /******************************************************************************
@@ -3144,7 +3159,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	spin_unlock(&mm_list->lock);
 
 	if (mm && first)
-		reset_bloom_filter(mm_state, walk->seq + 1);
+		reset_pmd_bloom_filter(mm_state, walk->seq + 1);
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3782,7 +3797,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
+		if (!walk->force_scan && !test_pmd_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -3793,7 +3808,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+		update_pmd_bloom_filter(mm_state, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -4422,7 +4437,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
-- 
2.54.0


