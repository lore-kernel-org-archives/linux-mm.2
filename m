Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52131606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PM2NILaN
Received: by kanga.kvack.org (Postfix)
	id 71FBB6B0966; Wed, 25 Nov 2026 04:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D07C6B0968; Wed, 25 Nov 2026 04:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFB26B0969; Wed, 25 Nov 2026 04:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35AF16B0966
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:41:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADF85C0E43
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:41:21 +0000 (UTC)
X-FDA: 85473148362.05.28AEBA4
Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6AE72000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:41:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PM2NILaN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599680;
	b=MLTamWMvKieYMuVxCDcnEJWMr36u0GymudDCAI2mHCwinkBCKXNCq8yt2bfIKBcoYlpu0H
	Ooxm1vQjpd0QOu0GObc2gvLJORtsaNl7z3NyuEb9fIIBn6C5ioasUqPZkyOZuz0Yv7a8+o
	nHFpCZWzwSkcPpCk2IR9J7Yi5X4CpSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WD/4g3U2g5hDKnSA98bMMiVyzkxPmmFKQJW8PrZci/g=;
	b=KJA4/GnkxQF7+HkNgQqtklyD51TCBeKqXnIQTOzPLO0jB1df9UCBmTQ6YEcWh/iyt+mJUq
	qfcEh6txSzbQpq+ji+bgfyOK4TXXJGhP9MsidouDWVkTbhUjjTAex2JuobA7J/sPUHnH58
	6wBxW2Pfl9mD9lfiGeriCOhxr+WTnqg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PM2NILaN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZDPO1rwIdBXWX2xskG/rZHT8jTWOZ0L3BIhuz0/FwNU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795599678; v=1; x=1796204478;
 b=PM2NILaNq1rVJJwrl0n6J/ny3xk9YLLmtviR1cj8y6VVqjvgSXdr0epM480HMtFnNWJhqLCZ
 6fZoLh5m+Ot4NnqVXgWUXCPWibU7di8i+91FpEELpbS5gesdW/BIcBEPliw/S7aTlt6NH9RpqAv
 SigmIhei3mFMvSUYgUFwQBgA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b0ce701aeff6c561;
	Wed, 25 Nov 2026 09:41:17 +0000
X-Mizu-Trace-ID: b0ce701aeff6c561
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
Subject: [PATCH v3 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
Date: Wed, 25 Nov 2026 17:40:55 +0800
Message-Id: <20261125094056.3973331-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125094056.3973331-1-ridong.chen@linux.dev>
References: <20261125094056.3973331-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6AE72000C
X-Stat-Signature: m8y1g1fkgzzxxy3xofxzefyp9izw457t
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795599679-240687
X-HE-Meta: U2FsdGVkX19jwpio3TX/7nRRUE0e2t8XCGWinb0N8DDuDqdZSn1aoCZceNYztPBfGerOCCUOP4C8lysOMe1vTAHevtnDxHH8ioN+fEV33sdIYVsjIGHVCJBwtR4Pgq8hx19fR9vo3JM7rrk6fsLMF+e9OekjgxlbvapDM0Qk/kXASeTvStsre1pzaDzeVilH307NqvTvUzOBQTcmeZc3W+ang7zR5EJ0UsQlbHpnXfw4wEwRKtHg7gtwgsglgwnPB9CyjbM+ZdpK+jXayAeVzt/sLnWrXQGCIwz/Hx7eBYtHzOjlkLE/K11wKc/+E3S0q5Cz/u63fDoRwP/CKdimFClAxDeS0Kqi26L9Zp1SZsKXnmRqjq2idMJODQdOPkjc5GDnUH0xg6VrlXXyHLox8JJVP5aAwiIdpTdIuLcR/Cy+3WkhC+FTS8t6W5mlj0M1mT1akdswYQNeGYMXxfKYvsrnDVJnMBvfmYJL+RypL7ZQpg7TGOKi9WPlxxbkRwdM/tTZUf/uGdnZ5vc0uyQ4a8KLpzV5feAOf9ggYflHU2+L6NDvXpGAI5KKg0zQ1zzs5Sz9bxH65BgLRdHbg/iFr+C4T3/7Lo61Q8uZpg0dgurdTnGny4B/Xm6uMis/FhVhGLi+sGk1wOTq0vkxQT6V6qXbdx5zUrsHdApg2MQjOYebnGatAbC6kZEBPkrgvsa2NFr6Gt+kHKL09JOXxzOScNETtEHrwllz2hteqUBzx7U8lH9e1SFUjksMWVJefK9NjSWGXU7CQHu7OPKnPk4YRQ0xOKFOu8ZnK6ikGcxk+n+48Q0DbDS5g4daGkKNv7Qf45r7o913h0nK/gPzP3ueMPt0W6yDmqvXEjmwoBzgTNSwLPgHMoTllV9PBPHFtAEI3hjrG9y+HBCMQ3NFqXMFU1O+bW8gGwDHLmpVOq7k/3NtSXajfWKT1AXVgu+pMDSLVrFNSvPYgaHKlgPfbNp
 Um6qZSXG
 1HY5M5ikdUMaS6tQn2agSq7UDlCsHFTd5J1/DXXSX4EqC8NzY6TR4PF+nIurRWq8C+3CD0atnBIMuYPHdRseuCe/Sr+pwBe2HemOZCurN1KHau7/xvMR6YGLg7Q6gLtyVMQTLFJiMXD2tcWdu0vFkPkKZxUzh+3sIzdNlvJjuNuFULT+YyUqASo1t1uXAHLzrQ0z6jlhoKjTnfs1pAeJccBY0UVruGY/Mpjn2t9RJ3jtMhjDCmw9/aJ5R+gJ5y7Kz7PkPH9mAHbBz6oLKmGcsgmBBkuEkFXvJSa2u8T/qaAL0PNgaX2y94yx0SmQhaHv3SAlf1e8vJO1NAng5df1BPc/eETeqi7pZ/II45OR5QJEoEviaYQUNtkmwghrgA8TSkMLiwvKQxDxt2MZcfjD2bV+52AYlrNjKyXLVWgX30S5/P5QYDqKGYXlLF9CREuv+HlFU68PQvuaGFcbkBP5nysySdee86+gxLBVlaHGEVrA2Exy9rLmUzROZHb1C8iHoWT12mpyC04C5SVIFwdaa1pOjqg==
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

Also rename "reclaiming" to "tail". With MGLRU, the tail of the LRU is
the tail of the oldest generation, so when tail is true,
lru_gen_add_folio() now picks min_seq[type] itself, and
lru_gen_folio_seq() no longer needs the argument.

This does not change behavior. The old reclaiming branch in
lru_gen_folio_seq() also resulted in min_seq[type]. It was only skipped
for active folios, and none of the callers that pass true add an active
folio.

max_seq has no user yet. The next patch uses it in lru_deactivate().

No functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mm_inline.h | 55 ++++++++++++++++++---------------------
 mm/vmscan.c               | 12 ++++-----
 2 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 573b68ffbc63..148b230fb5c0 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -121,6 +121,10 @@ static inline int lru_get_gen_flags(unsigned long flags)
 	return gen - 1;
 }
 
+/* no limit on that side of the seq range for lru_gen_add_folio() */
+#define MIN_SEQ_UNBOUNDED	0UL
+#define MAX_SEQ_UNBOUNDED	ULONG_MAX
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -353,8 +357,7 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
 }
 
 static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
-					      const struct folio *folio,
-					      bool reclaiming)
+					      const struct folio *folio)
 {
 	int age;
 	bool workingset = lru_refs_is_workingset(folio_lru_refs(folio));
@@ -375,8 +378,6 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 */
 	if (folio_test_active(folio))
 		age = MIN_NR_GENS - workingset;
-	else if (reclaiming)
-		age = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
@@ -387,8 +388,14 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
-		unsigned long scanned_seq, bool reclaiming)
+/*
+ * Cap the seq to [min_seq, max_seq], see MIN_SEQ_UNBOUNDED and
+ * MAX_SEQ_UNBOUNDED for no limit. With no limit and tail set, the folio is
+ * added to the tail of the oldest gen.
+ */
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+				     unsigned long min_seq, unsigned long max_seq,
+				     bool tail)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -406,9 +413,12 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	if (folio_test_unevictable(folio) || !lrugen->enabled)
 		return false;
 
-	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
-	if (scanned_seq != -1UL)
-		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
+	if (tail)
+		seq = READ_ONCE(lrugen->min_seq[type]);
+	else
+		seq = lru_gen_folio_seq(lruvec, folio);
+	seq = max(seq, min(min_seq, lrugen->max_seq));
+	seq = min(seq, max_seq);
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
@@ -422,7 +432,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	__update_lru_size(lruvec, lru, zone, delta);
 
 	/* for folio_rotate_reclaimable() */
-	if (reclaiming)
+	if (tail)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 	else
 		list_add(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -430,17 +440,6 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
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
@@ -495,13 +494,9 @@ static inline bool lru_gen_in_fault(void)
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
@@ -595,7 +590,7 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, false))
+	if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, MAX_SEQ_UNBOUNDED, false))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
@@ -611,7 +606,7 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, true))
+	if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, MAX_SEQ_UNBOUNDED, true))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81797b71228f..907d81185c36 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2165,7 +2165,8 @@ static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
+		else if (seq == -1UL ||
+			 !lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, false))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -5722,7 +5723,7 @@ static bool fill_evictable(struct lruvec *lruvec)
 
 			/*
 			 * lru_gen_add_folio() uses list_add_tail() rather
-			 * than list_add() when reclaiming is true.  Match
+			 * than list_add() when tail is true.  Match
 			 * its ordering to avoid cold/hot inversion.
 			 */
 			if (active)
@@ -5736,11 +5737,8 @@ static bool fill_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
 
 			lruvec_del_folio(lruvec, folio);
-			/*
-			 * Borrow reclaiming=true to place inactive folios in
-			 * the older gens.
-			 */
-			success = lru_gen_add_folio(lruvec, folio, !active);
+			success = lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
+						    MAX_SEQ_UNBOUNDED, !active);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)
-- 
2.34.1


