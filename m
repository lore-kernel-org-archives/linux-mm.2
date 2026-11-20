Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF9F606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ta+s3Er+
Received: by kanga.kvack.org (Postfix)
	id 8CF216B05F7; Fri, 20 Nov 2026 03:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FCA6B05F9; Fri, 20 Nov 2026 03:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BCD76B05FA; Fri, 20 Nov 2026 03:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C83E6B05F7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43B12160E4C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:40 +0000 (UTC)
X-FDA: 85454896800.03.D97D04F
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3DB9120007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ta+s3Er+;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165118;
	b=ND0lG+OmziwL+T+iPsc67TpUlowzmstYncQ1XXej8xjsUFOQcvuDf1nqRSNwjgaqklSXpn
	+gcMA2FVdPabTPLvnq80MgBB/ZFPuRWj3Nq2S/oULzcW8Fmdnz5BoeWSW1Q2Ut6DSAx8B8
	4N+IsrI/CAD3aTXkPYh2pJ5iIM+FRnQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuPSD3GupdY1UOkHbFpE0jggKIddGTwVd8Fo4O7dK18=;
	b=t9stmItoA/suwCk+eKG5W/NBDqHs4a1wlcrImghbaQwF0riFwfAZZsmo+y6HMMESTqd/ne
	sp+YmITQZJngVZc+/SDXM2yUfObHVvKm+5JAqioKtdZ35u6luUNLOLdvtbX/P7sYa6VGsn
	6v+L421zsazmZCTHo1DVeO7L0wn9qcI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ta+s3Er+;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ONc9EIP+v45mGhMaHos2kwDmsXcns+OpSu8Mmth1xjo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165116; v=1; x=1795769916;
 b=ta+s3Er+Sqq1/qaLPZJA0IpQvjkKYo7WcGgvHXzV24ZGZDxlW4Y/Vn7Jt8NDGrAqx67BLHdm
 T8biI2cVJaXfbu9u46BMFyWcDJr96wmUON5C8rFlaaEYOqSTMYTexDUzqmXdz5oqTGzmrPJ/EpY
 MDLjjvkAfS3Rtd2ycIzC0VC0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 3471ce2128c189fa;
	Fri, 20 Nov 2026 08:58:36 +0000
X-Mizu-Trace-ID: 3471ce2128c189fa
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
Subject: [PATCH 2/4] mm/mglru: add PUD-level Bloom filter state and generic helpers
Date: Fri, 20 Nov 2026 16:58:04 +0800
Message-ID: <20261120085806.781225-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261120085806.781225-1-baoquan.he@linux.dev>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k5bkbrucjeotyb65wro8pdm1d615nqkp
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DB9120007
X-HE-Tag: 1795165118-147605
X-HE-Meta: U2FsdGVkX1/dVShQsfczW2GCWVr1WJQ93FrjBpZw3i9ya97xVI4PtWpsqVV5HWg54+UKE6Qwpe8yP5LvjIr7++2g9D2ZkmuIVqRt5bNhmQq8eKRngN2f+hCfAeKIm8rZ7+c/R8MWOg6ik1aP1ZjPKHvy1/8pslaQoDmvKZE06BtT317IdoAktd0KgtZPPXoPQxlI0iVNVQoOQwulzOu8I3m67lMhRQ2swmGKA3bSQqKiumUxv2+HgC9dwFCFYevVPeFE4UjhOfPfO28uLFusYw5BK4Ijc6MHDy1kRdQCTIoH4MwZGohYJi+xM1zzolL5RBOTB2CqZhOCZdXyHHbwFh0yz1jgquQNtz7kSr3b6as/zJYy6KGxQAHpWfK+8M75okcfdqnwV6U+TdPPIrOroWuuYGBExdeRi0og1/y/dy14y1qu6hJMkm2NtYf6m1WI15eqO8Dt4BWiZuGJwMpgI7IhGvCObpsOJKkhcjdMI8NrcI+6cE6bQrw0GNPzy62000SByI/zIQivM8dnOT2758B3PxLbwCqWa1hbAFkdCdYA9nV+NmmHBu7zPLyP0BcgXtgW18SSF+2nllUhus45I0SOxv/wLxjZMFugPK+t1PuLrrWTVcM1H4VIBCIeHedZKvbYFSCZ0s429UcjPdbmI5f0eMoCqdrqlGpUTttDSWQa5ShiiDG7QivAZ8QFFJJTLHDjW0/7whvmGc6xjQv5e8XGvpEF4V9YDSaSp1DYlAfgwH8GI6QTkG7BaP5MPwDgtSyXlYOURJO1G3NV28/+oANx8QmzwxM7eAWeAW7lUeiPkRJM2WRfCYo5FdGEoYFWVKuK1rJGwTqWrIHqJqLYHWlF124GBzNuztN4WRw1uja7aa76aeY1teQg5xQBYFZte5QXcsMHQtP8BXo51yarpgQZmFgtg43gn8NWs0fswX8a7PdTHOrWJLoJ+iZh/r38eb4tDl23BKQCrXDAxTS
 vW97m7TJ
 sqOCSLT0R2dH2WZwP+dUX6PecZG8eaog79TT8YFH4VUZEWXO6AVpDFBRPNogEHTZaOCBzF+cMgCtgwMUosTcHGgCrx3qv3iYWNglvlNkuJIhosggi7utncdpcRb1Kmhhoz/ty3vhN+P/TF9b5pqzntuwHLXOcXfp3nQl+fAD2UOUQL3jKTSR4UZXjjpulc0oeRZYZ3E9r1X1deCxZvJMkzAtDoeIpPAzyuYNb/+tihCbL/Kav5VMOFuesF0JiPko/XxJKYICIfj5tejJTij07aUQB6qaJ3JVbrYRTiplRbATWArXRCGsIG+bKDnCgeewqh+VWKHR7vopGWJWriQfxpdOzftRwAP/clvbo603OBGFhFL3MqhyqQrVF7AUtShXQ+KuO+sH7Ier/DMWKtPoNVL9swv5OIfJXlyoO0nCnkFCYH6TjEEteQ+kCZu2ywyzE5pTeOvq4LdOLROduxlxQVHiG2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Generalize the Bloom filter state and helpers so that another filter
level can reuse the same hash, double-buffering and reset logic.

Replace the PMD-level filter array with a two-dimensional filters array
indexed by level, and add BLOOM_FILTER_PUD and BLOOM_FILTER_PMD. The
PUD-level filters operate at PUD granularity and generalize the
suppression one level up: when all PMDs under a PUD fail the PMD-level
filter, the whole PMD iteration can be skipped. Cross-node empty walks
are the most visible case: a foreign mm's PUDs have no young entries for
this lruvec, so the entire PMD iteration is pure waste.

test_bloom_filter(), update_bloom_filter() and reset_bloom_filter() take
the level now and use mm_state->filters[level][gen] directly.

No behavior change yet. No PUD-level bitmap is allocated in this patch;
the next patch fills and uses them for the first time.

Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h | 10 ++++++++--
 mm/vmscan.c            | 39 ++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 902f4877fd0c..a3a13a77ca8e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -589,6 +589,12 @@ enum {
 /* double-buffering Bloom filters */
 #define NR_BLOOM_FILTERS	2
 
+enum bloom_filter_level {
+	BLOOM_FILTER_PUD,
+	BLOOM_FILTER_PMD,
+	BLOOM_FILTER_LEVELS,
+};
+
 struct lru_gen_mm_state {
 	/* synced with max_seq after each iteration */
 	unsigned long seq;
@@ -596,8 +602,8 @@ struct lru_gen_mm_state {
 	struct list_head *head;
 	/* where the last iteration ended before */
 	struct list_head *tail;
-	/* Bloom filters flip after each iteration */
-	unsigned long *filters[NR_BLOOM_FILTERS];
+	/* Bloom filters flip after each iteration, indexed by level */
+	unsigned long *filters[BLOOM_FILTER_LEVELS][NR_BLOOM_FILTERS];
 	/* the mm stats for debugging */
 	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 36e0946bf2cc..a4c64a190391 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2819,14 +2819,14 @@ static void get_item_key(void *item, int *key)
 	key[1] = hash >> BLOOM_FILTER_SHIFT;
 }
 
-static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-			      void *item)
+static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
+			      unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(mm_state->filters[level][gen]);
 	if (!filter)
 		return true;
 
@@ -2835,14 +2835,14 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
 	return test_bit(key[0], filter) && test_bit(key[1], filter);
 }
 
-static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-				void *item)
+static void update_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
+				unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(mm_state->filters[level][gen]);
 	if (!filter)
 		return;
 
@@ -2854,12 +2854,13 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 		set_bit(key[1], filter);
 }
 
-static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
+			       unsigned long seq)
 {
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = mm_state->filters[gen];
+	filter = mm_state->filters[level][gen];
 	if (filter) {
 		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
 		return;
@@ -2867,7 +2868,7 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->filters[gen], filter);
+	WRITE_ONCE(mm_state->filters[level][gen], filter);
 }
 
 /******************************************************************************
@@ -3110,7 +3111,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	spin_unlock(&mm_list->lock);
 
 	if (mm && first)
-		reset_bloom_filter(mm_state, walk->seq + 1);
+		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3766,7 +3767,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
+		if (!walk->force_scan &&
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -3777,7 +3779,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -4436,8 +4438,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
-				    pvmw->pmd);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
+				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
@@ -6153,6 +6155,7 @@ void lru_gen_init_memcg(struct mem_cgroup *memcg)
 void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 {
 	int i;
+	int level;
 	int nid;
 	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
 
@@ -6170,9 +6173,11 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 		if (!mm_state)
 			continue;
 
-		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
-			bitmap_free(mm_state->filters[i]);
-			mm_state->filters[i] = NULL;
+		for (level = 0; level < BLOOM_FILTER_LEVELS; level++) {
+			for (i = 0; i < NR_BLOOM_FILTERS; i++) {
+				bitmap_free(mm_state->filters[level][i]);
+				mm_state->filters[level][i] = NULL;
+			}
 		}
 	}
 }
-- 
2.52.0


