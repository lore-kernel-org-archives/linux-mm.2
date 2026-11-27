Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E28606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ew5IZXJ+
Received: by kanga.kvack.org (Postfix)
	id 9E3D16B05B5; Fri, 27 Nov 2026 01:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9944A6B05B6; Fri, 27 Nov 2026 01:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883656B05B7; Fri, 27 Nov 2026 01:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603856B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:16:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6E348021D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:53 +0000 (UTC)
X-FDA: 85479890706.18.5A45ABE
Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id E880A18000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ew5IZXJ+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795760212;
	b=DZOFc5hB/5YHH+09HMYmmfqO2NsVK5SU/gQdmGzccB42FJEYNQjz2ZAaGOn+zX3MdIi1/N
	0FmZygcRlOIixVF3GWXFGyw+lEQwhCKMDN+c3jCvQ8QlBvb63/QeCLuQK7KO0RBsV0pw3z
	mHFrZH4T/m6gqCRtIrb14+uSmF8510s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795760212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMpknirTzilq7h6a7FkR25bKFUaDTK7BBu11s+J4/Fc=;
	b=6kbA2apla5HvvsiKE0gDQzuFJNxMUlmKBeATwPptAFNpmExctANIPDQHo5qVnZTjOWU6/n
	OfyYRzVepKPxStFDBxjVhELUMvC9jFn6Aj2s1SH6IzAsYQqtAwvcgiQIPVn48f1oFW11nu
	Fd+WNvhcwDs/sf1fWjSN+ke1V+xkLDE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ew5IZXJ+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rwYOG662er7eQMhEMYX7b+pHycck8iYCnL9B46tA1b8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795760210; v=1; x=1796365010;
 b=ew5IZXJ+DsS0/s98+HB49UDc12yKDDrw2rSCS4+RW9VNPihazD5Eo1xeZniSqSIARaKdwd8h
 fc9CzwiigiNdekjcF2D6vdN7w8rosBSLeSV45GNjIkWSIsRhGju4uHC4hQx3Aq9UFk/CAbGWkgo
 IWkfDtGXizj0aBvTejTq0XOI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4960c7b95f88177c;
	Fri, 27 Nov 2026 06:16:50 +0000
X-Mizu-Trace-ID: 4960c7b95f88177c
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 2/4] mm/mglru: add PUD-level Bloom filter state and generic helpers
Date: Fri, 27 Nov 2026 14:16:28 +0800
Message-ID: <20261127061630.11290-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261127061630.11290-1-baoquan.he@linux.dev>
References: <20261127061630.11290-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fmhgb15k81e1q6aaqopksxr1u8yynf6d
X-Rspamd-Queue-Id: E880A18000F
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795760211-958530
X-HE-Meta: U2FsdGVkX1+/JLdz0BnV3cFI8K4/IJqXzFfNAdLy8/BLnU/V2dkS9iy9Civzyj6RPP1IAa/Cfcuvx4/Qhrpenq9TTdvNMwy3XrF4xwm3CJICyBIFlZ6ZGZ4HBZGzv93zUMvIz+XeJDfnoCSSFBwlUeADsqsgw+rCWwTroUgVASc67ggv7nr5oika3+YSFBnlAL3Rx1sxbcygWOwH+1jbIVqNYybpNOKpvYf5pubgS0YiGr7VHY02PS+kwjNUvL5rygwgTHkIM4kqmxPMghfCNWcLLupZ2EO/DRMsZ1Yy2VKGeRdTAADZU1dqG8rK+W4YPaWtIvkd0N3Dk+OcmAqgTy8kwRhFljLSJKSfidk34eQaeNRJes8bY7SVXS4ZShnNjqqkrAoabIcyZEjtEhSW/UphIjeTovD63XP3MOXsllBke/BXq2CFNknCtYLCQSW5vjSvWV0yOwLVC38s5HJX7MpPDA+1PLNmjzE4f1jeTPh+33BSWSbl9pXFX5gulJUyr7Bqvj4PWzTmITwE8D1eYEXUwIdGz77qJ2HPLAXzB6ILwVTQKz8u84NCmjeQa8qUnDC8FUBPf60PaobBwUOklWx9ucN8Tg8wyT5eNA//3XpfHxm9hlNTm5RR1XdjwIhsYMt4fzxG2hI2Arghv6Buos42+Gq52rtnkh7ZrE/65gJwcJpT+uOZKLBC5+veDD5xecz5XsxNLKhcLA9+ZyLO0w0dBUiG5cwD/TBbf+1ceagJjMI+xsdqxFYFRZO6OqWr+2Mq1Zy4PI/wYpPa+cumIdhbD2akxnDFwJeHscupKcDazzdNx9pUkMN7Qg/2jZ7nRXnulIH9ISm6s7P8x80Xw34d3+x7vDiUU21Ud7GnKC9m+li8fyTg5NMuTbmPo+kXcP4RXp6furc7+Y0EKCLNt1KImGgs8f/YxuYKSMr15KCw5a+LmC0AIDZP4k8dD6HrzEsleenT33mXsY4HbWc
 hnq6XLTk
 G+i77w3DtWXhT+Paen/GLLwsoEn/VSZwK9AS06/5wSFWWFpaFu/aUQtIf94WL23uytFN53N8f0oJVJIegyXac+KgJxj3fPEQU/B9lifrkixQxiiWtSBjP1/kdtG8dkEGNtETG3KY8NTSS3kjQvxnZF8kWlmpRgY4D3I6VKUiMkRMNQ+9Lp3WhiSU9StSXKCZwiOcZztM3CbdhRP8KRjlfXh7c8eK9yq2sie71uylFdFbAAvVA34e9jCuRgaGe9eBv4kGtwPTfJgHtHljeWhemdAjQroSAxT7UDM44ymYHh4CzH25wrEiynp2CoFkP4jfvAEOJkDNuDCDOzdWjxlTsOy/Z+qXu7KvIvC9oN2LxRu1AfwDRNMS3TobCQ0PhjW/NnYcTCqgjJ4QXgbuMRDyxVjsvTMZk04jM+QsqMLixSWLiYh9n7jKfZKdOU1Y9wFqmgxvN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Generalize the Bloom filter state and helpers so that another filter level
can reuse the same hash, double-buffering and reset logic.

Replace the PMD-level filter array with a two-dimensional filters array
indexed by level, and add BLOOM_FILTER_PUD and BLOOM_FILTER_PMD. The
PUD-level filters work one level up: when all PMDs under a PUD fail the
PMD-level filter, the whole PMD iteration can be skipped. Cross-node
empty walks are the case where this wastes the most time.

test_bloom_filter(), update_bloom_filter() and reset_bloom_filter() take
the level and use mm_state->filters[level][gen] directly.

No behavior change yet, and no PUD-level bitmap is allocated.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h | 10 ++++++++--
 mm/vmscan.c            | 39 ++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 12cba15a02fa..98b60cd6b534 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -640,6 +640,12 @@ enum {
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
@@ -647,8 +653,8 @@ struct lru_gen_mm_state {
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
index c755d4914d76..9861cc35062f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3068,14 +3068,14 @@ static void get_item_key(void *item, int *key)
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
 
@@ -3084,14 +3084,14 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
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
 
@@ -3103,12 +3103,13 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
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
@@ -3116,7 +3117,7 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->filters[gen], filter);
+	WRITE_ONCE(mm_state->filters[level][gen], filter);
 }
 
 /******************************************************************************
@@ -3359,7 +3360,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	spin_unlock(&mm_list->lock);
 
 	if (mm && first)
-		reset_bloom_filter(mm_state, walk->seq + 1);
+		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
 
 	if (*iter)
 		mmdrop(*iter);
@@ -4010,7 +4011,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
+		if (!walk->force_scan &&
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -4021,7 +4023,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -4651,8 +4653,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
-				    pvmw->pmd);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
+				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
@@ -6357,6 +6359,7 @@ void lru_gen_init_memcg(struct mem_cgroup *memcg)
 void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 {
 	int i;
+	int level;
 	int nid;
 	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
 
@@ -6374,9 +6377,11 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
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


