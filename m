Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E6C606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FO9lGa8+
Received: by kanga.kvack.org (Postfix)
	id 6587A6B064B; Thu, 19 Nov 2026 08:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6306E6B065C; Thu, 19 Nov 2026 08:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546B36B0664; Thu, 19 Nov 2026 08:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25CEF6B064B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:48:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1E4CC0AB7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:48:14 +0000 (UTC)
X-FDA: 85451997708.25.3347CB3
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9FC9140003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:48:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FO9lGa8+;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096093;
	b=GARDEqSO77i43DTLdEjw/rh8cXfy2lqn7iYl+mcs2jgqQQZdYwfhIhS1KYn+3xD+0S0Hsq
	epUacN5Y/qqm/H/BQiZrcAgefe1sA/hMzoBStDvHkf1lzARgBgxx9IS55yKG5aWdgJWEA5
	C8JODlYwPh4cifZa8ip2BV6Rq6t4V4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OYEwAAN0J4djNDrKsSMSqWk6wovRIhaJ5ABwOTSkfs=;
	b=cRIPmJ2TuTq4uwOW6AyVvkoXHKsoVfEs9KvDdDYA7G9WQA7rLnItkqWJdLJPsqbwTil662
	gTHbNgP+vpfEvsXqxIrQePzEA18bEe6dVgnoulupdUMu7MvMp1sZyfyh7bMlG8P522ZRIY
	794yTNawCPflHFBnvjPOc8TBDU+SP3Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FO9lGa8+;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DStc4arF3+lIub3RYlwgMGzHVQfEyR+cUqgy+QaQToo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795096091; v=1; x=1795700891;
 b=FO9lGa8+HtVE/oSYTZPV6FZ7aPNxqJvtrX1cuoe5yvnG9JSZ+YWDQAc2fSxEdBFHVbhcyC7t
 wdD/kpf8iahQKn+rwuu2b3h4eA1DMoctaORYhz5uFfxLuyPrPQnGmJNpJdrGZBeBD2UOdH/heQa
 Xxysm84Grw/euxK+RVismlbk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 00c7bec7af43a541;
	Thu, 19 Nov 2026 13:48:11 +0000
X-Mizu-Trace-ID: 00c7bec7af43a541
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
Date: Thu, 19 Nov 2026 21:47:39 +0800
Message-Id: <20261119134740.514632-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261119134740.514632-1-ridong.chen@linux.dev>
References: <20261119134740.514632-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9FC9140003
X-Rspam-User:
X-Stat-Signature: qnjdfrypgrnzf9nftuxu33xepe8xymiq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795096092-947364
X-HE-Meta: U2FsdGVkX19Q1fKE8DakXDkrorzHn1cpPPusNDIHj00pAQYZkzpHrAYF8wGJSMdLoE88Np7WTY3Hx5XqGnP/EmZ5gCFEQnDVI7WWpzUQw015Bv8Yh4AsZqutZ3mKdPT+CYl7my4ljUxP6sNTyoroaQY3hwgcCjjqWLxBlbv4udpA5PrMb+VPDvwafPFTx2JsGOr/KZBbjYWMp+Fdpzo4QkyqEDLhk/1mn7dU6j7wJEYXEUoFd1KQL0Fx91eSjzz/hK9n8hdDcsR9KDnXdp3oeQxal1TiiRtDNTlWZhhaUYi0XRO9Kq9okrtQSqEx1xWhmDyBPIA2nVaO3x4p/GvWk5HMbTC/ewBarTyTKn99TqaBO7Xu0zeKUmMeFBQuy/zrim4v7mgLP5XfMmjL3mnSY8pQ3c2aItPFpRAb/ouFgDvdvEUMg6Om7VQWebmYNvuShK9JeijQX9LZ0OTPqONsnSCK4x+YnfdtCDWprJRQsMaZbwF8FRYNXhFwd0+G1b6xJObrOWNaPKOATS2UOv0CnhOahNernSRys9Zn0pE0LvPOPvJ78cPrIfnpEDQ5jhjrA1ieufigT0JZxhQOe8/McgKA5hLtxNvwNRt3VdGUeH3mtvV/267fay5IhH9x6CYZ2/L8gKCNS+biv/yC3QR6fqxebPqoOaJPjztonkC5KrF79v31AbTmRCFlRfl8ckaxbJxhK1dtH9ECQZnyjqpjqUmoOEYA4PtTUYb+d9NEzRXWfG5Wu5VG4W5sSz7jznoAVZzJbyOA3Mi7X2rRZtCQJbo/OT3eE6JTJdtYLQ2rzfty+gziXiw5LGSSlv+/inWTi8bJJb204pWbqRgB/xH3TL+Ms2LsfrAoOFqtyatoP8xRFJDxGDdn9cYy3BHIjhwvoDqe6ALq0WHhT23ezdHanjQ8XUXtk/QfDDtHDHrrpzW8sl32Jyn9+rkGecDo7YbDQIl//DknLo/u7TvXzAt
 bCw2cMg5
 aBQUafpQhmg1AFdSGEBAH412uoTipfG6/fEwYTeBf/VPCj1mUOiH7Sqf7yJyI4g8QM5NO9mMV7UYmB7AR7gBAGwf0QrEUf5K917R7BMxG28AGY4epSF26JoqPmCjMqlzoXt7crJ/mqj4wMS4OshAd7Ke8qY5+ZBArVnD8SP4B0zc4J2Tg4sKM8iferhTtBE/O2agwyFUNrMnFwboDKrP22dMCWn9nPUzTkhWyMUmbRNh+XUZCqXnWW5DWdRFG42vm2zixj/lIdJSHx1nicsNjbktJdsuo84s0SqZBMc8GuYHQIGgdsOQ87M6C2OjExUgLboABBWmuunKZVjUtR8qBWXCyRr/5AZ+wlXicv4GUlyNhWIbCkXMj58Z7/gX7+4WnQK0PMPBiMNC6QsppZtAdxkjIrXzxlL+ZWu4SlNmYkFIbxcy8N/rzIQCBwR0S0c0FLK60WMJc9+208Bavaut8jdAfMWU7E0zxmVy/rRV+QaehBtFiD3PnbggkhQx0OjHKEvGt/QWgB6Vuf2g9qKpxl/SA1w==
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
generation is capped to, with -1UL meaning no limit on that side, and
drop the two wrappers. move_folios_to_lru() passes scanned_seq + 1 as
min_seq for rejected folios, as before.

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
 include/linux/mm_inline.h | 52 +++++++++++++++++----------------------
 mm/vmscan.c               | 11 +++------
 2 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6f4bc9a704f..69f69b9d8018 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -299,8 +299,7 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 }
 
 static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
-					      const struct folio *folio,
-					      bool reclaiming)
+					      const struct folio *folio)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
@@ -320,8 +319,6 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 */
 	if (folio_test_active(folio))
 		gen = MIN_NR_GENS - folio_test_workingset(folio);
-	else if (reclaiming)
-		gen = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
@@ -332,8 +329,13 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
-		unsigned long scanned_seq, bool reclaiming)
+/*
+ * Cap the seq to [min_seq, max_seq], -1UL means no limit. With no limit and
+ * tail set, the folio is added to the tail of the oldest gen.
+ */
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+				     unsigned long min_seq, unsigned long max_seq,
+				     bool tail)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -347,9 +349,14 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	if (folio_test_unevictable(folio) || !lrugen->enabled)
 		return false;
 
-	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
-	if (scanned_seq != -1UL)
-		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
+	if (tail)
+		seq = READ_ONCE(lrugen->min_seq[type]);
+	else
+		seq = lru_gen_folio_seq(lruvec, folio);
+	if (min_seq != -1UL)
+		seq = max(seq, min(min_seq, lrugen->max_seq));
+	if (max_seq != -1UL)
+		seq = min(seq, max_seq);
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
+	if (lru_gen_add_folio(lruvec, folio, -1UL, -1UL, false))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
@@ -475,7 +467,7 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, true))
+	if (lru_gen_add_folio(lruvec, folio, -1UL, -1UL, true))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..19e06574ea00 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1916,7 +1916,8 @@ static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
+		else if (seq == -1UL ||
+			 !lru_gen_add_folio(lruvec, folio, seq + 1, -1UL, false))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -5516,7 +5517,7 @@ static bool fill_evictable(struct lruvec *lruvec)
 
 			/*
 			 * lru_gen_add_folio() uses list_add_tail() rather
-			 * than list_add() when reclaiming is true.  Match
+			 * than list_add() when tail is true.  Match
 			 * its ordering to avoid cold/hot inversion.
 			 */
 			if (active)
@@ -5530,11 +5531,7 @@ static bool fill_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
 
 			lruvec_del_folio(lruvec, folio);
-			/*
-			 * Borrow reclaiming=true to place inactive folios in
-			 * the older gens.
-			 */
-			success = lru_gen_add_folio(lruvec, folio, !active);
+			success = lru_gen_add_folio(lruvec, folio, -1UL, -1UL, !active);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)
-- 
2.34.1


