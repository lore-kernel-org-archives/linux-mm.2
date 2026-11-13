Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE03260A263D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Spus7ydt
Received: by kanga.kvack.org (Postfix)
	id D1FB66B05BA; Fri, 13 Nov 2026 03:50:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF71C6B0612; Fri, 13 Nov 2026 03:50:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D1D6B0614; Fri, 13 Nov 2026 03:50:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 961286B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:50:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12FBD120240
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:30 +0000 (UTC)
X-FDA: 85429474620.03.330FD9D
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02377A0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Spus7ydt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4seY1bfdJRdNuGWbVqJrL/nhHuxt0I+JvshzPPsBIU=;
	b=sZ7MYIxZzE3+9cNSI0c9Mujeqna0bEaz1O7QbmxPXhm5vseFzZImIHxFGKLX8Av1neV4Q3
	60RQGFnUFxdILNsHhw/uZpmmQGwKpq9jfYZhylIJfjbW7Waf/3GmW3Oez6PehwsScVanwq
	jiRXH5JHNnjLmmMaUuO7GIEVVart69g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559828;
	b=Fxoq2wSYAIBW4p4BopuTEUmJg3giFPOh5HBNh3y1KMSi7JOiQVzUgB4tRdbEbsmY8uiMj6
	Ufu3eDvfTYZkMZgoODFR/+EaewbO41n4G09EvYXr/sXMtNbIcSwPKPPnVEQ3J0UoiRE0A4
	fDq/7jOcs64RqcHaH/2PeATGkUNyyGY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Spus7ydt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OpOlJjKeN76PPhsp2vVKYcBlOdY7KZSKZkyAfppf/OY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794559826; v=1; x=1795164626;
 b=Spus7ydt/4EbUAIV8MFR4ENy3YZmG7/vZ1EsI+ycg9YlO8BY/bfzOidm8b8VPmKSo+ycQ6ae
 13o2K2vPaua5mQ1IsZnGWJ9MGxgzgoMl5N1IbiO6mc07E2vl5BcxdV+/4vvc8rSteIuZfI1ny/r
 mBlFYYgOw9iyeWWrdQKzn9aQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id cd6d10ca7f07a972;
	Fri, 13 Nov 2026 08:50:19 +0000
X-Mizu-Trace-ID: cd6d10ca7f07a972
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 2/4] mm/mglru: add PUD-level Bloom filter state and generic helpers
Date: Fri, 13 Nov 2026 16:49:51 +0800
Message-ID: <20261113084953.412919-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261113084953.412919-1-baoquan.he@linux.dev>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zb8xjqkhdathmtf8wtdigpmpcj6uic9u
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02377A0006
X-HE-Tag: 1794559827-982897
X-HE-Meta: U2FsdGVkX1/1zqN2W6U0G74eAU8cmq9EbOfsv39dInzzgMqV7Pde6+8SuTNsfO8bq5kDxmYCGXoMpPPJ8Nt/B1e8sI7WOeSYtKP+q0NkbR0mypWCsChBxkHq2QdeVh7EnWfPiEULPlN0TasTTYtmfUabzHvn+HS6R1DHkjHXjiOCRLj8AE5k9EmQBO7J3XsXCHFLmyQw6YLn48wgJP+ERT+ZOaNKyFYJ0Aw7bvObgPBcU6I7PWrZ2AUhaNKk3jR4bQha5acI+znXxJh/yFbigG9lg8i9Mdu46HdxGik6ISAYs5X/nUJg2ZtiWu0YJsbtWfjjS0u6MGblBFplkIfJ5HWlfThk4INiw/SnuJqGVxqKRPZaHexbr5L4fGnrDvM6MPX4OyoB7a/3mGadcw3iDDxAYkrFTSZoJrt6UJU4uY5VRSp7dMh1PMF75FhAAgrx/T6tjD0C66sA9ujVVhCKPXATzP+IlU34PiJ0sdGCCVhMlUPfjxfvfNJVhk7qdMMSDsqFk9IA7cP+NDA5ehY84bkKby8l1wGeif/Xr+sWlVN8rh73cym6HT/LeukEO5htoj3T/kEkBXoulaCihAFaGjh8BKn1wl1wWfmN5VZ/dn6vgMrjnYWgej5ASU7SuSDvx6kVBRbNVtVgx+zASlJ0YVzO1xTbG68imDpgbyJQnO2qm2r3ULf2w/FQ5Bn2EEXlFSlVIvFywAvf9UGYslO1Jd1kdZTwhzpbLxoMKfWEitoyd+IpoKWE74loO0latsZNBjfwBblNX7GGuWA1gBfAKvOtLpUj4a7T5ZOSK0+1gixsuVJuS00YIBUq59vn1N3dH5S0IvlYAzmOzPyIfCz8IYdNPDR346r+Cr2ZGqtTI/V5eGCh39uCqjBe7SusrcF6LSvFPqilE50rkkDQgGHrcv29i3aB8PXaMUQM+3MnFGLROAI9XobAwdZsZS/oZD0KVhZtLofQap8cLJKjd5R
 UY02NC49
 q8p8zpBNvTXOCToo9/PnyKR1x7yXTmNJhumgwAjSdSjRCuBDhe2FTAA7gmpuGHf5PMYFBBrlhLS4E48Nwe/BL96xdal9QLT5Kxh9wrT0Dy9aarKU7H7qNrvXicPWfjyxW5p2LV34PHldGvuti37zyg/ZPwL16We/vDT13Ss8oVol5WQfXt1axDQqiOnyPxcRwVrotsSrP7e9+My+dt/C+8zccpKhxIcNM2IHrUQhBrszcJq4=
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

The existing PMD-level code now goes through the generic
test/update/reset_bloom_filter() helpers.

No behavior change yet; the PUD-level filters are populated and used by
the next patch.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mmzone.h | 10 ++++++--
 mm/vmscan.c            | 58 +++++++++++++++++++++++++++++-------------
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a49efd9b74ed..1f086ef3a00e 100644
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
index 98037a562ab6..9dbb3f477d7d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2798,6 +2798,10 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
  * walk_pmd_range(); the eviction also report them when walking the rmap
  * in lru_gen_look_around().
  *
+ * A second, coarser pair of filters sits one level up. The filters are
+ * indexed by level: BLOOM_FILTER_PMD for the PMD-level filters above, and
+ * BLOOM_FILTER_PUD for the PUD-level pair.
+ *
  * For future optimizations:
  * 1. It's not necessary to keep both filters all the time. The spare one can be
  *    freed after the RCU grace period and reallocated if needed again.
@@ -2823,14 +2827,13 @@ static void get_item_key(void *item, int *key)
 	key[1] = hash >> BLOOM_FILTER_SHIFT;
 }
 
-static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-			      void *item)
+static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(filters[gen]);
 	if (!filter)
 		return true;
 
@@ -2839,14 +2842,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
 	return test_bit(key[0], filter) && test_bit(key[1], filter);
 }
 
-static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-				void *item)
+static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(filters[gen]);
 	if (!filter)
 		return;
 
@@ -2858,12 +2860,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 		set_bit(key[1], filter);
 }
 
-static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+static void __reset_bloom_filter(unsigned long **filters, unsigned long seq)
 {
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = mm_state->filters[gen];
+	filter = filters[gen];
 	if (filter) {
 		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
 		return;
@@ -2871,7 +2873,25 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->filters[gen], filter);
+	WRITE_ONCE(filters[gen], filter);
+}
+
+static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
+			      unsigned long seq, void *item)
+{
+	return __test_bloom_filter(mm_state->filters[level], seq, item);
+}
+
+static void update_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
+				unsigned long seq, void *item)
+{
+	__update_bloom_filter(mm_state->filters[level], seq, item);
+}
+
+static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
+			       unsigned long seq)
+{
+	__reset_bloom_filter(mm_state->filters[level], seq);
 }
 
 /******************************************************************************
@@ -3114,7 +3134,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	spin_unlock(&mm_list->lock);
 
 	if (mm && first)
-		reset_bloom_filter(mm_state, walk->seq + 1);
+		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3771,7 +3791,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
+		if (!walk->force_scan &&
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -3782,7 +3803,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -4417,8 +4438,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
-				    pvmw->pmd);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
+				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
@@ -5981,6 +6002,7 @@ void lru_gen_init_memcg(struct mem_cgroup *memcg)
 void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 {
 	int i;
+	int level;
 	int nid;
 	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
 
@@ -5998,9 +6020,11 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
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


