Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C4C2CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD7F6B00B3; Fri,  1 May 2026 17:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94886B00B5; Fri,  1 May 2026 17:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81186B00B3; Fri,  1 May 2026 17:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDBCD6B00B3
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 845AA8A2C0
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:23 +0000 (UTC)
X-FDA: 84720079206.26.B3C2684
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4E5A04000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7+EWpuE;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsonO9P0pN7KN7rpoN8oPbpCNlFocNqMD8ZNl/+bQq4=;
	b=szOjCtdebbHnp/JN9JiBTg4yroRc8jyL+4FzZ0LdP9XUdnQZAeQ1yohkC3pm3/TBGM6GtX
	pki0d1vqfJ+X/qOAdaP9GS58njToDskXW/qUhlu2lEZ8gCDNA/nRo05gnO1YRqQvHi1aIL
	TdjGxr+E/raT2RREEdtRJyVI1EBFoag=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7+EWpuE;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669461; a=rsa-sha256;
	cv=none;
	b=zuouzUc+l4kw2i0kPogzHeMtwCjb9ih02tkNHj9M4RSNy7Du8UTdoJI4pRXGTp29TmcYLQ
	4lExnH04TbWJK3g7pXvTXPvgygHcEnHMKiySVeTebBQRG0wLuG0/dB5uxE2fq1L4A3gBDM
	hTxz0jfDZDQJY3XLnZJkUw3obpQf2SI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86E9844569;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67E3BC2BCB8;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=9bXLr8DWOxGjog7CVEQ5YwCoruTB5F+PQs0K9k/GJFo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r7+EWpuErCrOya0sV1kyeAzHASSkfmQlVbh+udt5YtToGeyv/eMeS4NAZTuQVu9zm
	 IN6VT9NAHiQkfX27XqdT4xnHA9kbYSQO3qlgWc2st25o6hZDmrUppmTzj1jMrrTOv6
	 wlw/eVAA/tKo03bHbTe2dBS5SLbe8b+0PHogFuE/zetbcQFmgtcaJgXzoqR7r/36AS
	 B7eL+t7pb9HHPjUimJjyeO8VoWIdEFKGgXJDvSkL8+YNHEVE4YKLD3WEjQFoZ9Scvt
	 +zUVnepCOhZXKMewrQAuDOk9hutQ5juR7nCqcam3SDsqGXKV7+k1H2IhpjBWuY1pDi
	 oohcoaVnL87NA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4E6CCFA13;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:16 +0800
Subject: [PATCH RFC 30/32] mm/mglru, workingset: apply refault-distance
 based re-activation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-30-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=9815;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=3SDg1UIwE2lOt/3QEIDXKbHVzTms1xk8wQaCfFECvFg=;
 b=IVyQkXaCapdKIeTGy01jKs/3iCm+Yy/0+bi99dDFnHITieJXGhW1YYpbViK7xMYWbGx8vZTm7
 ri+vMaIdqD0Ceelh1IhYMLmwcQ1jYrRjxSGiLndWjW7SCZTFXvN1zJV
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E5A04000B
X-Stat-Signature: gh5k5d9aq3mg68rkd1asrpxuxzkh6876
X-HE-Tag: 1777669461-791516
X-HE-Meta: U2FsdGVkX1+naEmoNqXZ9QC7XCGz+Cmo/MPXoFhovW8hhKWudaexAqx8lmrym3570rnMhmD/aBqNPZBalM1gjEFcywT4tUom1YeVUxZ3Idgbv5VeA2VkaPQEO/HjaCaEDBKJUzMCcB+M8amt9qWTA8VRHOUX6/wdMSAw9+C56mOeI4ZvwiYHD7xHvzCCA0gVyfkLX3tC6+v7tcGN82N87UGz0KIN9Dc3Nsrp8d8igKI6OmQPSCue1M/78fW+dEBEvBVekeEr7nluXJj/+dHmofphZ6dyOwv3Fmdk2WGBtYAcco9+XfxbysMzeylKywSa+WCkuOTkul0UgZf9YTkfpDwMi0fA+fVXqRXe7KkzmG4QvpLiOqJ39Jb1vjilbRbwErASeMqmDsQ6vHp4JTPjXwnCHDI/urQW2GZ67cQpmCPhszeadegj8fKw/cLJCO5Rss1mcONdpsrczsQMG5NuGVPlUVihgHrO6i5RbIF0x9CAS2NtcDiigfMVC6HE4x0k0oAuXjJxExLg8/BxB46+xng0fh61JATy+dvYVVDIAAUTvhgfVXU2m7yXxjHSqjN3fGGXxDQhLUS3iZYz4lPHn/J4a2iN4c7wZcj3wD1gQCzzu+V3pNVH2rkUY1m9Mj4sC0DELWF0vIZUHdfqKmodrOIqYPYE/d4T0sqmq0XA2oDbrH5q8+sOcZr2aHoftc/zeXXR/OAQYX1SaAPLf/ud2eEvo+k3dLWLTjlzQ3o53g8FI+lAyqLzWdy571+6pqSOovh3/VRanc8rySenoOt1G98U87HWDeHKZ5LqJh/Ke77SkXJLlLzWCWdGxy3yZMHtsjLmBmHFfb9acpKyJBOiQMSICIKzv92Zq5JrHE/TyA6JFgLxP51Wo2ZpSuEXVeRbtXXiidBU5vfTCQMkQgyypZqwMXZDK4bya0YwPvpRwMPV4jO6n67eeo/Xiwv/AzJ1ZaTevVdS4pJs58kQ/d/
 PgGWGFaS
 5kXTnRgNLC16Xg0+Rke/j4kCceJEMC80Y/LTtA2yMYcjki2o4Y362wI84L8i1pXefVlBBLMLIN+wgJJx3kJy6jwvGkcZ/5QNVN+oD+F/M4sC9/+sj78QI5kqykM8qDcUranS8is4HqV+erWwfxkugUY/L254QZhxecXenpAdY/58VMhoGY2IEXbKffoJ8LzZvvpSJ2cvu1j6QXwWcLtGf1D9Fqav1O8cR+ihH/siXmKckLB1LY09exul+y+QsvO9mOyiiGh2Zu7SL3BRn7Off+E9Tm+A7AZkEhwH+2Qox+5/QUP2if/tyKNSqSl3GOAlltdvDIpSSZI0TSepjfKNCpRwRT9OAq/jycBigOE6zuJ1Fa2b0xplOHWSezg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

I noticed MGLRU not working very well on certain workflows, which is
observed on some heavily stressed databases. That is when the file
page workingset size exceeds total memory, and the access distance
of file pages also larger than total memory. All file pages could stuck
on the oldest generation and getting read-in then evicted permutably.
Despite anon pages being idle, they never get aged. PID controller
didn't kickin until there are some minor access pattern changes.
And file pages are not promoted or reused.

Even though the memory can't cover the whole workingset, the
refault-distance based re-activation can help hold part of the
workingset in-memory to help reduce the IO workload significantly.

So apply it for MGLRU as well. The updated refault-distance model
fits well for MGLRU in most cases, if we just consider the last two
generation as the inactive LRU and the first two generations as
active LRU.

Some adjustment is done to fit the logic better, also make the
refault-distance contributed to page tiering and PID refault detection
of MGLRU.

NOTE: This also changed the meaning of workingset_* fields in
/proc/vmstat.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/workingset.c | 116 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 81 insertions(+), 35 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 5c52dd835a92..25a8eda233ef 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -190,7 +190,7 @@
  *                   /     LRU Eviction Info    \ / LRU Pack Info \
  *                  +----------------------------+----------------+-+
  * non-MGLRU:       |SC|   eviction timestamp    | NID | MCID | W |1|
- * MGLRU:           |SC|     seq number   | refs | NID | MCID | W |1|
+ * MGLRU:           |SC| refs|eviction timestamp | NID | MCID | W |1|
  *                   ^                              ^      ^    ^  ^
  *    Swap Count (anon only)  NUMA ID (NODES_SHIFT)-+      |    | XA_VALUE
  *          Memory Cgroup ID (MEM_CGROUP_ID_SHIFT) --------+    | mark
@@ -219,7 +219,9 @@
  * PG_referenced. But here we record PG_workingset separately (to reuse
  * pack_shadow).
  */
-#define LRU_REFS_BITS ((LRU_REFS_WIDTH + 2) - 1)
+#define LRU_REFS_BITS		((LRU_REFS_WIDTH + 2) - 1)
+#define LRU_GEN_EVICT_BITS	(LRU_EVICT_BITS - LRU_REFS_BITS)
+#define LRU_GEN_EVICT_BITS_ANON	(LRU_EVICT_BITS_ANON - LRU_REFS_BITS)
 
 /*
  * Eviction timestamps need to be able to cover the full range of
@@ -230,6 +232,7 @@
  * evictions into coarser buckets by shaving off lower timestamp bits.
  */
 static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
+static unsigned int lru_gen_bucket_order[ANON_AND_FILE] __read_mostly;
 
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
 			 bool workingset, bool file)
@@ -392,7 +395,6 @@ static void *lru_gen_eviction(struct folio *folio)
 {
 	int hist;
 	unsigned long token;
-	unsigned long min_seq;
 	struct lruvec *lruvec;
 	struct lru_gen_folio *lrugen;
 	int type = folio_is_file_lru(folio);
@@ -403,16 +405,19 @@ static void *lru_gen_eviction(struct folio *folio)
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	unsigned short memcg_id;
 
-	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_BITS > LRU_EVICT_BITS_ANON);
+	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_BITS > LRU_GEN_EVICT_BITS_ANON);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
-	min_seq = READ_ONCE(lrugen->min_seq[type]);
-	token = (min_seq << LRU_REFS_BITS) | refs >> 1;
+	hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
 
-	hist = lru_hist_from_seq(min_seq);
+	token = refs >> 1;
+	token <<= type ? LRU_GEN_EVICT_BITS : LRU_GEN_EVICT_BITS_ANON;
+	token |= lru_eviction(lruvec, delta,
+			      type ? LRU_GEN_EVICT_BITS : LRU_GEN_EVICT_BITS_ANON,
+			      lru_gen_bucket_order[type]);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 	memcg_id = mem_cgroup_private_id(memcg);
 	rcu_read_unlock();
@@ -423,56 +428,87 @@ static void *lru_gen_eviction(struct folio *folio)
 /*
  * Tests if the shadow entry is for a folio that was recently evicted.
  */
-static bool lru_gen_test_recent(struct lruvec *lruvec,
-				unsigned long token, bool file)
+static bool lru_gen_test_recent(struct lruvec *lruvec, bool file,
+				unsigned long distance)
 {
-	unsigned long max_seq;
+	struct lru_gen_folio *lrugen;
+	unsigned long recent = 0;
+	int hist, tier;
 
-	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	max_seq &= BIT((file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON) - LRU_REFS_BITS) - 1;
+	lrugen = &lruvec->lrugen;
+	hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[file]));
+	for (tier = 0; tier < MAX_NR_TIERS; tier++)
+		recent += atomic_long_read(&lrugen->evicted[hist][file][tier]);
 
-	return abs_diff(max_seq, token >> LRU_REFS_BITS) < MAX_NR_GENS;
+	return distance <= recent;
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
 {
 	bool recent;
-	int hist, tier, refs;
 	bool workingset;
-	unsigned long token;
+	int hist, tier, refs;
 	struct lruvec *lruvec;
 	struct lru_gen_folio *lrugen;
 	int type = folio_is_file_lru(folio);
 	int delta = folio_nr_pages(folio);
+	unsigned long token, distance, total;
 
-	lruvec = try_unpack_get_lruvec(shadow, &token, &workingset, false);
+	lruvec = try_unpack_get_lruvec(shadow, &token, &workingset, true);
 	if (!lruvec)
 		return;
 	if (lruvec != folio_lruvec(folio))
 		goto out_put;
 
-	recent = lru_gen_test_recent(lruvec, token, type);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
 
-	if (!recent)
-		goto out_put;
-
 	lrugen = &lruvec->lrugen;
-
 	hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
-	refs = ((token & (BIT(LRU_REFS_BITS) - 1)) << 1) + workingset;
-	tier = lru_tier_from_refs(refs);
 
-	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
+	distance = lru_distance(lruvec, token,
+				type ? LRU_GEN_EVICT_BITS : LRU_GEN_EVICT_BITS_ANON,
+				lru_gen_bucket_order[type]);
+	recent = lru_gen_test_recent(lruvec, type, distance);
+
+	total = lruvec_page_state(lruvec, NR_ACTIVE_FILE) +
+		lruvec_page_state(lruvec, NR_INACTIVE_FILE);
+	if (!type || mem_cgroup_get_nr_swap_pages(lruvec_memcg(lruvec))) {
+		total += lruvec_page_state(lruvec, NR_ACTIVE_ANON) +
+			lruvec_page_state(lruvec, NR_INACTIVE_ANON);
+	}
+
+	/* Return if it's neither recently evicted nor fits workingset. */
+	if (!recent && distance > total)
+		goto out_put;
 
-	/* see folio_add_lru() where folio_set_active() will be called */
-	if (lru_gen_in_fault())
+	token >>= type ? LRU_GEN_EVICT_BITS : LRU_GEN_EVICT_BITS_ANON;
+	token &= (BIT(LRU_REFS_BITS) - 1);
+	refs = (token << 1) + workingset;
+	tier = lru_tier_from_refs(refs);
+
+	/* Set refault as active. */
+	if (distance < total / 2) {
+		folio_set_active(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+	}
 
+	/* Restore reference count. */
 	if (refs) {
 		folio_set_lru_refs(folio, refs);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	}
+
+	/*
+	 * If it's recently evicted, update the recent gen's counter. Else,
+	 * update the global counter, increase total too to avoid having
+	 * a refault rate > 1.
+	 */
+	if (recent) {
+		atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
+	} else {
+		atomic_long_add(delta, &lrugen->avg_total[type][tier]);
+		atomic_long_add(delta, &lrugen->avg_refaulted[type][tier]);
+	}
 out_put:
 	put_lruvec(lruvec);
 }
@@ -484,8 +520,8 @@ static void *lru_gen_eviction(struct folio *folio)
 	return NULL;
 }
 
-static bool lru_gen_test_recent(struct lruvec *lruvec,
-				unsigned long token, bool file)
+static bool lru_gen_test_recent(struct lruvec *lruvec, bool file,
+				unsigned long distance)
 {
 	return false;
 }
@@ -551,15 +587,16 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	unsigned long distance;
 	bool recent;
 
+	lruvec = try_unpack_get_lruvec(shadow, &eviction, workingset, flush);
+	if (!lruvec)
+		return false;
+
 	if (lru_gen_enabled()) {
-		lruvec = try_unpack_get_lruvec(shadow, &eviction, workingset, false);
-		if (!lruvec)
-			return false;
-		recent = lru_gen_test_recent(lruvec, eviction, file);
+		distance = lru_distance(lruvec, eviction,
+					file ? LRU_GEN_EVICT_BITS : LRU_GEN_EVICT_BITS_ANON,
+					lru_gen_bucket_order[file]);
+		recent = lru_gen_test_recent(lruvec, file, distance);
 	} else {
-		lruvec = try_unpack_get_lruvec(shadow, &eviction, workingset, flush);
-		if (!lruvec)
-			return false;
 		distance = lru_distance(lruvec, eviction,
 					file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON,
 					bucket_order[file]);
@@ -850,6 +887,15 @@ static int __init workingset_init(void)
 	pr_info("workingset: timestamp_bits=%d (anon: %d) max_order=%d bucket_order=%u (anon: %d)\n",
 		LRU_EVICT_BITS, LRU_EVICT_BITS_ANON, max_order,
 		bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_ANON]);
+#ifdef CONFIG_LRU_GEN
+	if (max_order > LRU_GEN_EVICT_BITS)
+		lru_gen_bucket_order[WORKINGSET_FILE] = max_order - LRU_GEN_EVICT_BITS;
+	if (max_order > LRU_GEN_EVICT_BITS_ANON)
+		lru_gen_bucket_order[WORKINGSET_ANON] = max_order - LRU_GEN_EVICT_BITS_ANON;
+	pr_info("workingset: lru_gen_timestamp_bits=%d (anon: %d) lru_gen_bucket_order=%u (anon %d)\n",
+		LRU_GEN_EVICT_BITS, LRU_GEN_EVICT_BITS_ANON,
+		lru_gen_bucket_order[WORKINGSET_FILE], lru_gen_bucket_order[WORKINGSET_ANON]);
+#endif
 
 	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						    SHRINKER_MEMCG_AWARE,

-- 
2.54.0



