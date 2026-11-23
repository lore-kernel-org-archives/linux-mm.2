Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA57606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VzwXNCjd
Received: by kanga.kvack.org (Postfix)
	id AE32F6B05B7; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAFD6B05B8; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8536B05BA; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70B076B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F18911A07B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:34 +0000 (UTC)
X-FDA: 85465782948.05.1499CD2
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf30.hostedemail.com (Postfix) with ESMTP id E264E80007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VzwXNCjd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424313;
	b=a5T4qv+7cr0xwIy50kNMJYJfF1HG76R5OoVaMempC0I0011hjvwwaFH5lgGccWVO8scOsi
	T+a7HGQ/IIEFNI/vmWrDklDGNMP0enq5OfZLlF1TZaQHtfnGWsKkKXGrcBT0kTcJeLp0zM
	wGrTqOk8/5cMjXiW5V9NSDJNT/uKAxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEVkgjNwteQWXeEGGE/XbNqiDaZupu9T9ugvumTBAG4=;
	b=Nwd0Qw6l3i8YH7431J6dbnUe0zjHaTE9xY5pOCm1Jwlarcs055O1jb0iwwLphH/aWhH28D
	nPt0ZUCeklFiu4XFdTLSVZY2bipXRGwU4cT3shR2BoGwleKqGRKe2bwi2no2tM/b+G035L
	41T9VtDe0tZtJpHZ/Hde8WBujEfocvs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VzwXNCjd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gphQPS+W/QJD5pZPnxEe/GSlf9Pi+eZYPYuS7nN28bE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795424311; v=1; x=1796029111;
 b=VzwXNCjdi/jji9kw25xCUWmJ7zjT4NG6MvPjULeAn5kwe/duLUa+AL1abOV4n/7H4pEV4fi8
 3slftz+casREDJzPoUbkVARCC3pmi1k2xLRtJePjMY/T4q3EMqi8X5RT2MXMkcT+j+REpEDnhX0
 4EhO6K01Q3D060nNjgWsdZqY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 67cdf347499ef05d;
	Mon, 23 Nov 2026 08:58:31 +0000
X-Mizu-Trace-ID: 67cdf347499ef05d
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
Subject: [PATCH v5 2/4] mm/mglru: add PUD-level Bloom filter state and generic helpers
Date: Mon, 23 Nov 2026 16:57:58 +0800
Message-ID: <20261123085800.981256-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261123085800.981256-1-baoquan.he@linux.dev>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6y4fbe13qzg9dp5f9a1ugu8kb6eta1yh
X-Rspamd-Queue-Id: E264E80007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795424312-306230
X-HE-Meta: U2FsdGVkX1963TFhamljMPIMKRMh08d7wn1hqI1Q8sFRrf0N6D1sanH9aICFo4SsXtqqmh6eg7VuPiTjoPQo5MiVlsqE0Ew1d1jfblcR5XmVYD0ccYh5abZhAqtmYb9DE56KlQhAbP3vnU8fV1LEnIzZ3f3CZNm6ayVBIFyKLKQpP5AwVHnh+5vd5us2/CbheZXoo6vGue5nVU1iSNG586/ARm4aW7iHc7VGp8GUXgjcOuCdudlkvt6Au9CFxvJ4SJ+ra2FpdeJvQyrmyz8CLn87m37xJbn0rKC0Ct0WbA0rbLkT0axqGP8+Nw43WYzKfhmN/ivlTXZaUf883zq6wP5y0i+iHUNNgqrb7OodFKcOoGrLT22i5kLARoxI3adnvyF4h++dbyb0JwaUcf144tlhmxYTaR6NNdOUd0hG6Sym1Y9e+kyppLT3WZe1jYOz5zcQT0SS/UyamUl7NlQg6cDjnYdcPZAtfr0I2Gf2j76KGOYYTiFbfQQ4NoNMDkWMT99rL+wY3PVYfI53CXks8NmI4qCOYhnzCLavZVuMW2cxm8SZtPF3hWjd5+CPbkYCnUyGYV1Fb0cUVme23Ap0U0yo8C8c+TUiGAnLNdBPMYanrKI/BujU83cvi9hJ9u9UkduODZaReVfPx4IlXPfSfgkXBn3wRt07SfMXbsxvVc/GV7RIusXMFWuE0X/1IedLE+1IT0LLP/WDcYp756ZUAx3s3SiZ/u1blG+r6emfRuenAt0dTAqxrpT0D+RNse4/o3ZrAmB2986xVazrnsEOLuP6WzpgB/b/FqflLmNZZbJEbOkdcs0eY61mA3eYewk/fDEAMTk9wVOY9d2qcGf5dfEhwF7k9+bDXLm72nVe6y6/IoEqar3osio1IJvQZLvLhuSrYb4DF60B0eWc9qnQ2BZSwI1LvMd3Sst49HHrztgxj14KABGR7e2CkAOiPNRjpDpCY73u62b30oKfEpm
 HoMqTMWx
 jbRikVLOsaRKxC1A+JIeRR13Y4lIPyIeg/2RKl+/AwaOXStgc+zCODYqOrlBnar5iSu2tSMaWpbuh9aUCB3s5uZ4W4vzY5Kl6hkWKrLzqEpJjMER4V837Ftezf8NKhlKWl+mvqQatBpRwUt2kLKaH9ODlI6gr7LArH31rz2Qtzg2w9EF2DLcgRRZ4jFsdxycCnJZFAb8T4lsXD/PjIM0noAYbez4qqpe85ZM/ztNsZtrv8aYX1ZiY9EuHWDflULxqyYvC/2r+PP2SsIsYVQV7N/evNi0JF6nVAjEhDfm7obhby4IIG5PecFdNn3f+hcIkQ6fjKniQmzMgcVrL+N5N5r51bbWJsIKIT0NG/tuMnElhemKnyGXVbmaokpaDM2gig8Qre/ZAZz+1XcAK4l/DMQNV0wo6IxJ7WEtyJO8DCCs6A8T2Ph/kAQRtBwOYDbD0vcCR
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
index 8aabe0f23e60..f057c98d1f97 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -588,6 +588,12 @@ enum {
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
@@ -595,8 +601,8 @@ struct lru_gen_mm_state {
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
index a0cbbbb2ff00..7d20ee1b6c10 100644
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
@@ -3761,7 +3762,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
+		if (!walk->force_scan &&
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -3772,7 +3774,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -4434,8 +4436,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
-				    pvmw->pmd);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
+				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
@@ -6151,6 +6153,7 @@ void lru_gen_init_memcg(struct mem_cgroup *memcg)
 void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 {
 	int i;
+	int level;
 	int nid;
 	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
 
@@ -6168,9 +6171,11 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
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


