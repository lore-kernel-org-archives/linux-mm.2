Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DED0606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gTNA05D6
Received: by kanga.kvack.org (Postfix)
	id 44E016B05B3; Thu, 26 Nov 2026 22:11:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BEC6B05B4; Thu, 26 Nov 2026 22:11:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B506B05B5; Thu, 26 Nov 2026 22:11:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E867E6B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:11:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A9201201AB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:11:36 +0000 (UTC)
X-FDA: 85479423792.05.511B0A6
Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52B7E100005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:11:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gTNA05D6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795749094;
	b=GgivXawVgyURJyivMgXER3CewDvkPeWEct/TBi04ZOfx8tcUtywJrGJac+jOzmXunRgb2Z
	pWhL5whzucIahepj6MJEQzzZRrUZU1jFI/WwrgmN/PKAlj+w49LvDuzoG8tW/DpKEgPmzE
	ixVrMSNykEVIQ9PgY/qV55EBcDlIeZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795749094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIx9xbtl7hIRvYwSkHgSNzI8jHo5yBjg0nA8Xx4wMqg=;
	b=4+OTwBbpAMPGyGlhd1ZGal/4VKJE7c5W4BLqjpRBujOMuVIirUXBaS/3t7ShbxASc4qGQ8
	XWBct8dM6CjUjnqqfkakjbG058uBQs3+2qwajwLTxlqb9vjivwoBBf4++SvScLqU+xFQYN
	A5wAMlNuTsWoYvBi2YWhSMiBn8f4cD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gTNA05D6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rZ7/hUl/DusnRMK4AeYI599+PqJY2F40D1Os5A07SMs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795749091; v=1; x=1796353891;
 b=gTNA05D6HYBrjrb0fLroJM0+N60IUKKcmHZ5dOC9Oda4CxxHuz55mpudjzb89wTZfAGth430
 1bzrXfmSVw3sNP1m8lNtfWlnrA2CLESGb7yXfOyaFzCxp+LJx/HoM7rIzXNzl1wLEkqm75S+0hG
 h3aYexiEMT71f4h+4DhxaYpg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fab21b75f2b5478a;
	Fri, 27 Nov 2026 03:11:31 +0000
X-Mizu-Trace-ID: fab21b75f2b5478a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
Date: Fri, 27 Nov 2026 11:11:09 +0800
Message-Id: <20261127031110.1034854-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127031110.1034854-1-ridong.chen@linux.dev>
References: <20261127031110.1034854-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52B7E100005
X-Rspam-User:
X-Stat-Signature: mtp5bunx4jfyg9kh3f8nr8rjqpot1ria
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795749094-891248
X-HE-Meta: U2FsdGVkX1+8p6Zumgi2NTVrOo7Cax6IrRPigVNdFrhwokLeFYN3sMs1v1o8hrZFlsteJGOAO0CcN88KPAGtieYoTySzQdx41cufyKnbcO2izfxjsL99xcce+o2+KGgM34sQgiS0RxxbnirPHivFW4n2XWCtFjKRLtEx86KpR5lgi8JMBWyH3d5PIFhU8diMQnjFCDy0QGzvHUAiukKx/spHsjiwGQKrDEEnhOmWn52C42xbfKrt0ht43a3rsojJGdXH2TuKuDIWwZXomTTRA+T/cLrpUXjAZE1WJNmJi8KCqa73CRtDUhClMxbJuJ5QG9UEf4rHfM8B41MbM4HLi2Q03czsPci/iVaUHmbwtf2Nnbqu1Br5WXtXw7rWpLC2DFuuQetgfRFtgfnCLnOwHlP4W1WVGMljgPDDz+azenWLRIi5Yhkhx9pBOOaui+VOmDch+E7yR9cqdEZA+tW9ux0sKI7ZYAvqN9D6e8Y2LzRFmndb6Q5+V3TDJ9B9qnnNIigFkDaS8gZFu/i7ujK2OOcRMB8Cxx5ed3Lw+EH1Ht/EGjM9HL3HhlUM41hItwQPf01VTeFQ0FaEV9s1g+Ovt44/bnlnuuNMuDnldz7mBdKjRjM/7qGg5gZ8tvq2mYIWQubczAf0/gw71B2gp3SlvuwpBikYoPFIn2LmaaQvHmzSk6OgMzyAZbhd4XnjXyAP8R4/U6MK74hlM1i4x1YGWRIOEuV/7648WWJA20VgF9TjCbtv5c/EqbxI1TGCKnnzNKXuAolUoPzHltw3zLhGGm5pn0PxJrETBSF0makHrhFxEMrlD3+I05EyLbpG+5XYj8tSbP6A2uc2dw4yQosVgDo0+CrWPNGezP5wLdbbqbzT18JNOWTacVMbRZL6lcYktb6HCbkyH0CX5XkzVGZygt+zsnxATqRxJFuEaSbDqpmxIbN2N6jOE168BMtk0QpAOrx7TgIC3VSqEAfZUMc
 9Z1TVeXf
 HtloMarwj0nlRzjYd1noEURKtgLk9lwkNoc4iow5Tr1+ig+bivIc0RUbsVOyam7qeOm3e5ltEK63RqR3VT+6pdXxWB44lPp1NSN14SxV8jNA7mUyCcJs45nypYAFc5egpTMBuUYcyvavuzzITGh6CVcjxPaIS5wFBwQ1W7EyPUY0Z4MvOuLKFC0Y1q7yF6KRIp7yB3flQ9DA9k5YWMCrpO0Y1DGi/lQPGSmNUACBYahJRx67nCmV8OAVRHYZIvzJuwfYGv3CpjtZ3p53FmpkTYVl6PNshhX6uTEr3kEujGXsVUTwIEUcn+Ogi7X+ZUCqOBMV1oZFV+HMfIuqz3VqmQ+oTzJCKj6ylB3TTITlRt/hSjIj/v152p1mj1eueX1VIV+ePXNCECky5fwgZd7g0rh1KM6ozTCecS9mjlY2sn1fbyFdOSipmxJlDOYiUZokUQmXjlPthkPQX4T2I9xRjZT3UWEsFOFYsYSTA4G/W9NNBiAukBZKssufiqim9PvHjZhyQb7QE3sf2hw4TNaekB5EObxJ2by2T0U4XDDNNIX477y5hizCOqs6nxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_add_folio() and lru_gen_add_rejected_folio() are wrappers around
__lru_gen_add_folio(), which can only raise the generation picked by
lru_gen_folio_seq(), through scanned_seq. There is no way for a caller
to lower it, e.g. to put a folio into the oldest generation without
also adding it to the tail.

Let lru_gen_add_folio() take a range [min_seq, max_seq] that the target
generation is capped to, and drop the two wrappers. MIN_SEQ_UNBOUNDED (0)
and MAX_SEQ_UNBOUNDED (ULONG_MAX) mean no limit on that side. They leave
the seq unchanged when capped to, so no special case is needed for them.
move_folios_to_lru() passes scanned_seq + 1 as min_seq for rejected
folios, as before.

Also rename "reclaiming" to "tail", and make it only pick which end of
the list the folio is added to. The generation is now only decided by
lru_gen_folio_seq() and the range, so lru_gen_folio_seq() no longer
needs the argument. The two callers that add to the tail of the oldest
generation, lruvec_add_folio_tail() and fill_evictable() for inactive
folios, pass min_seq[type] as max_seq instead.

This does not change behavior. lru_gen_folio_seq() never returns a seq
below min_seq[type], so capping it to min_seq[type] gives min_seq[type],
which is what the old reclaiming branch resulted in. That branch was
only skipped for active folios, and none of the callers that pass true
add an active folio.

No functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mm_inline.h | 57 +++++++++++++++++++--------------------
 mm/vmscan.c               | 16 ++++++-----
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 0a055a3fe210..27c7bba542bc 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -106,6 +106,10 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 	return lru;
 }
 
+/* no limit on that side of the seq range for lru_gen_add_folio() */
+#define MIN_SEQ_UNBOUNDED	0UL
+#define MAX_SEQ_UNBOUNDED	ULONG_MAX
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -299,8 +303,7 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 }
 
 static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
-					      const struct folio *folio,
-					      bool reclaiming)
+					      const struct folio *folio)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
@@ -320,8 +323,6 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 */
 	if (folio_test_active(folio))
 		gen = MIN_NR_GENS - folio_test_workingset(folio);
-	else if (reclaiming)
-		gen = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
@@ -332,8 +333,14 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
-		unsigned long scanned_seq, bool reclaiming)
+/*
+ * Cap the seq to [min_seq, max_seq], see MIN_SEQ_UNBOUNDED and
+ * MAX_SEQ_UNBOUNDED for no limit. tail only picks which end of the list
+ * the folio is added to.
+ */
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+				     unsigned long min_seq, unsigned long max_seq,
+				     bool tail)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -347,9 +354,9 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	if (folio_test_unevictable(folio) || !lrugen->enabled)
 		return false;
 
-	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
-	if (scanned_seq != -1UL)
-		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
+	seq = lru_gen_folio_seq(lruvec, folio);
+	seq = max(seq, min(min_seq, lrugen->max_seq));
+	seq = min(seq, max_seq);
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
@@ -357,7 +364,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
-	if (reclaiming)
+	if (tail)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 	else
 		list_add(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -365,17 +372,6 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	return true;
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
-{
-	return __lru_gen_add_folio(lruvec, folio, -1UL, reclaiming);
-}
-
-static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
-		unsigned long scanned_seq)
-{
-	return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
-}
-
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	unsigned long flags;
@@ -429,13 +425,9 @@ static inline bool lru_gen_in_fault(void)
 	return false;
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
-{
-	return false;
-}
-
-static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
-		unsigned long scanned_seq)
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+				     unsigned long min_seq, unsigned long max_seq,
+				     bool tail)
 {
 	return false;
 }
@@ -459,7 +451,7 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, false))
+	if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, MAX_SEQ_UNBOUNDED, false))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
@@ -475,8 +467,13 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, true))
+#ifdef CONFIG_LRU_GEN
+	/* the tail of the LRU is the tail of the oldest gen */
+	if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
+			      READ_ONCE(lruvec->lrugen.min_seq[folio_is_file_lru(folio)]),
+			      true))
 		return;
+#endif
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 621214442f14..3f1c9e79bbcc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1916,7 +1916,8 @@ static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
+		else if (seq == -1UL ||
+			 !lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, false))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -5515,10 +5516,11 @@ static bool fill_evictable(struct lruvec *lruvec)
 		while (!list_empty(head)) {
 			bool success;
 			struct folio *folio;
+			unsigned long max_seq;
 
 			/*
 			 * lru_gen_add_folio() uses list_add_tail() rather
-			 * than list_add() when reclaiming is true.  Match
+			 * than list_add() when tail is true.  Match
 			 * its ordering to avoid cold/hot inversion.
 			 */
 			if (active)
@@ -5532,11 +5534,11 @@ static bool fill_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
 
 			lruvec_del_folio(lruvec, folio);
-			/*
-			 * Borrow reclaiming=true to place inactive folios in
-			 * the older gens.
-			 */
-			success = lru_gen_add_folio(lruvec, folio, !active);
+			/* inactive folios go to the tail of the oldest gen */
+			max_seq = active ? MAX_SEQ_UNBOUNDED :
+				  READ_ONCE(lruvec->lrugen.min_seq[type]);
+			success = lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
+						    max_seq, !active);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)

base-commit: 3d27e49eb905a5119e78fbe3d3890f376d15c728
-- 
2.34.1


