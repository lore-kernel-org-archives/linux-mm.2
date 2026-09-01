Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC1CC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E843C6B00A5; Tue,  1 Sep 2026 02:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34DB6B00A6; Tue,  1 Sep 2026 02:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71406B00A7; Tue,  1 Sep 2026 02:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38696B00A5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:38:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3792D1A01D6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:22 +0000 (UTC)
X-FDA: 85164239244.30.0180BC6
Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC6891A0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STUcAFlOXyy5fwd4fXHid0o0iQ7qTWwVbHyGl8/QfH8=;
	b=0ITgrswr3VkUABtW6Sbj3VJK2bgif8dbqWNRQGJhx05LT1JkEDiCg/TQC0VEm/PLvp6HP4
	mR/dc8JPK/YCTiHs/ZbN8np9M16+Pw44ayAnmHSa6FkqjIUuEtZIfmAqoRVP0dmDKHmkah
	R0oNgmFM96976f4AhFcIsum+UWjJytk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244700;
	b=VcIa7C2RM9dAcyvv+kn+3ivl74akPbASxMwZi+ilUWhY6W1Ol2RwDNLmM/CozKXJAvBBqi
	OnIDa+aYp1D8Vk6Fw3ZhCli4Q9zauWGrUEEY46srWa8wxUi/nISU26ueaEd7byOE4gPpRc
	KiCVlDoHkz/2nyCHjNvpHDaIZt+c+7E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id ccbaff89a2db72de;
	Tue, 01 Sep 2026 06:38:18 +0000
X-Mizu-Trace-ID: ccbaff89a2db72de
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 2/4] mm/mglru: add PUD-level Bloom filter state and generic helpers
Date: Tue,  1 Sep 2026 14:37:53 +0800
Message-ID: <20260901063755.1519710-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC6891A0006
X-Stat-Signature: otgsi6abakd6wo5ze4row9mouexx7hdx
X-HE-Tag: 1788244699-453530
X-HE-Meta: U2FsdGVkX1+itzdMbgYwV8XJbT+z8jb4b/rNZgJMAxGO5JY/KMn57k9QFgOMhQWLuB64XIOlRveQGKL6i4/TmyHE1tciewGhM21qlVFn1B+CI2s2+gZT59qCQ/TX2Z7/2OmnfkF74buHHFdezW1vXc/qRP83kzuHmBFy4SJXzo4kiVJnkehWEtVgA31gnxovh36mis3klE7WPwH7AEg0orK4Nxs/8MXCvYM99QUc0AEKFP+ujuo3r6zKrwNqIICUA/3L4TRhw/j9sz8fqcyyDiS/3SGUxDd0zms0HuAXl33xQfvdwf3B4l0yVk2d33G4HpElHmjPgozzA+0/Y29qtxV1HJYB7xWxVrgaKxxWNNFG9CW6ifvLX1M5b57Dfx42eRFRZlzUGt4NUacGMDy750ZfoI22kYs9/oMNBLgm5SLyR7qWUVlDXyIXi+77g6pv4aQBGGQnIN15vyPWOAxDYIuaukr7l+poK5wvS38f4VbAaKmgPW4O6/l2sMEcufOguRFpmw6FrnUBb5hV7p0AtkuXSoufspQWCxm40u6folf/l6Uq49BQGHasupqvE6IKReP2opb8Nseb4SeiZI40vM0R/w0ULGAr9bE6C6pjWDiD4dDPh2yn8/0Dj3R2MqF6une9E2rHM7i1Dawhc9FBJqWAPpxs1NE9oyDpX7M0kMIZqkUZjtd84KTDrjKTM04D+dp+IdEFF5DY2bcN0tMrcBTCbvOG4ToWQNk/K/twaTI7iZgJhH67HIZn3CuE+WjGc7fWsxYJfoET6M+5xc3yC40U8up/5ObbNy71DwMLqb/En5Za+j9bo99g2scDqoOB2Di3HKUh/LUjzIQnA8OGU2wv7OHXGxr8xf0FxDTqX7OJre/Dd19Kr+nDRVPgHf7hI+JLBlYpbf8ZaQMasVr9qaXuYmFJpZmZxXJedyxaHIIlcMnpppPMLUo4rJr10+PQ0KDADbxAO+zfxlrQu7h
 u0xvneQW
 zwo645SewSC/W/i3qokMhHuPNJ+y0EjeVIuNSLR1pwhOW2zQDG66suOJPezGE/L/giiK8Hu0hGy/TGHKGyyeP2tz7sR1ikC/HXUF6RcvFFPtiUNDQ7rLEy4sEXZNCJEvLe1kaQudQJPgG/sgkKE/2pQweTYTK6VR8O4I2vmNJ91G4v7smNtLjDdOx2h6XTnZ5LZF3rHsZqikrfC1WhKevo4pM7qtFMF2bm+f8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename the existing PMD-level filter array (filters -> pmd_filters) and
add a second, coarser pair of PUD-level Bloom filters (pud_filters).
The PUL filsters operate at 1GB (PUD) granularity, whose 512 PMDs would
all fail the PMD-level filter - a general suppression of unnecessary page
table walks. Cross-node empty walks are the most visible case: a foreign
mm's PUDs have no young entries for this lruvec, so the entire PMD
iteration is pure waste.

Generalize the Bloom filter helpers (test/update/reset_bloom_filter ->
__test/update/reset_bloom_filter) to operate on a generic filters array,
and add thin wrappers (test/update/reset_pmd_bloom_filter) that pass the
PMD-level array, so the PUD-level pair can reuse the same hash,
double-buffering and reset.

No behavior change yet; the PUD filters are populated and used by later
patches.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  6 ++++--
 mm/vmscan.c            | 45 ++++++++++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f75daa6cd02d..faf28d35065d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -612,8 +612,10 @@ struct lru_gen_mm_state {
 	struct list_head *head;
 	/* where the last iteration ended before */
 	struct list_head *tail;
-	/* Bloom filters flip after each iteration */
-	unsigned long *filters[NR_BLOOM_FILTERS];
+	/* PMD-level Bloom filters flip after each iteration */
+	unsigned long *pmd_filters[NR_BLOOM_FILTERS];
+	/* PUD-level Bloom filters flip after each iteration */
+	unsigned long *pud_filters[NR_BLOOM_FILTERS];
 	/* the mm stats for debugging */
 	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 55d43ab54459..cd09c5b8af8c 100644
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
 
-	filter = READ_ONCE(mm_state->filters[gen]);
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
 
-	filter = READ_ONCE(mm_state->filters[gen]);
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
 
-	filter = mm_state->filters[gen];
+	filter = filters[gen];
 	if (filter) {
 		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
 		return;
@@ -2890,7 +2888,24 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->filters[gen], filter);
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
@@ -3133,7 +3148,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	spin_unlock(&mm_list->lock);
 
 	if (mm && first)
-		reset_bloom_filter(mm_state, walk->seq + 1);
+		reset_pmd_bloom_filter(mm_state, walk->seq + 1);
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3771,7 +3786,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
+		if (!walk->force_scan && !test_pmd_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -3782,7 +3797,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+		update_pmd_bloom_filter(mm_state, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -4383,7 +4398,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
@@ -5946,8 +5961,8 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 			continue;
 
 		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
-			bitmap_free(mm_state->filters[i]);
-			mm_state->filters[i] = NULL;
+			bitmap_free(mm_state->pmd_filters[i]);
+			mm_state->pmd_filters[i] = NULL;
 		}
 	}
 }
-- 
2.54.0


