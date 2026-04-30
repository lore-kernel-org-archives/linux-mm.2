Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B088CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92C06B009B; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5086B0099; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7196B0098; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78ABF6B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A198C037B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:57 +0000 (UTC)
X-FDA: 84716345994.16.F71B9B8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 79A211C0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HSsjUtxs;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gpq7iVC3YJDB67xhJzrLFiyNyhJnXmyyuQJ4fGwG900=;
	b=DcqPjcdFCpDNX7SDIq+kbt/V/vjKX6X3cGLoTtULijHaoorN9wlCjmxil6MBwayRPWhez8
	twzoXxJi5n0O3RPMyO7ANPPex174gnVEooQQy1edSqNVGlQs4PI6gf/8cXFz0WgN/ZUqJE
	i15LIWf+xgQywlH+eXvTu3uA8Mkj4As=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HSsjUtxs;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580575; a=rsa-sha256;
	cv=none;
	b=2VWa3TI+X4pYGj8Kaj6AbkesPpXbSaTXaGGVn+JWoFW5OktDY5ri1LEIMYbjS7EUjOr8Yt
	CbxpqurWz1fR54uoH4C8w8CtqiKzYzhNgZJuMw90fJT//kewMctDjnLBJRrOvS9gTQyyoL
	8zy4ZkWCkRajplAFMXTR+2ah3Hq1jZ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Gpq7iVC3YJDB67xhJzrLFiyNyhJnXmyyuQJ4fGwG900=; b=HSsjUtxsRrHo6JtuFsWOtMlTi5
	ax6rGVTV4GSwJ7xiBJ62HO6s4Sqxo9ho85hazEwAbGNi4Sw3n1kpMTrFM21BPaXPF1Mhqt7t4CqBb
	HnG86h/PdVgWT08fcCT/iDe4M8se70le8uzv6FBEkGv/CdWg7RioIgQ36I2jsVEGxRTxF0axRiTQF
	mycYEX+a2UxmA9c1t6d6ev6ksbz6MN2ikNoaHToEY3eVpbAce8PI9oZV/4l+BXV8VlD1Tl5PD4A8F
	hx7L8QsQB//ZOTbL1cH+gZ754LIEm9lKkPsqyiIKzm/PlhrJML91EJ3tOgbxLF0fbeCykLMEmh223
	BZOQZMnQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3pCf;
	Thu, 30 Apr 2026 16:22:40 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 20/45] mm: page_alloc: aggressively pack non-movable allocations in tainted SPBs on large systems
Date: Thu, 30 Apr 2026 16:20:49 -0400
Message-ID: <20260430202233.111010-21-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 79A211C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: i6uc4gnsoimr4zry9x33gksruw3h9xj1
X-HE-Tag: 1777580575-812600
X-HE-Meta: U2FsdGVkX18d1DUZlXo7fCr5i2e0EC39mB909xSkvAs1rCwxxxDUEfl0zT3KswaCRCwMtfXZAdU8ERfINVGWeuUvowaL9ry6Pdb5tt8ZtZIflU8xs+vVg8T/jpiQ3xOXjOnXYHSCmwEiNZLbh+bP4nZPqbvCZaEW3GauPjpMFLG8c6+tV9Lee/ZvMBJSS4y8IBzWY1lZPayrVuyBOs78vtTNz5bPzLZWJu3Ia7tQzpjbLZEMGtKOD+dkonm2d6/ubV8ynvJBf7R5BML2Kmi7fvIZufEHX0V+QRwgl8okZKhrLZB5BMFdDGTXwr1G/FTrHJsfhCEMKOJN15JD1/5dpEq85n2FCeI0D72CTQ1sv8q9ftmxB0HpUdA7pzEwJYN2KI4MhqZhZ+rAFO7Smx7TL/NdeXyfFaq4Y93gydST7yWBQAfBu+uGvFOZwgo7FCDeF7OrKyttiiwa4SR1JeXr9b3v1ySbNJmhIJZHGOvrwwj2ZI332IJk/rO/RyTBfrH+t5dokInTc4/C3dKsN0xmg+/ht4bSthv6EgVyeRFGcSl4jhW7xQ51+NAmGi9jlcuhDQl7ylpsvMvlzV3u/6wOU40nBV4ZdMM7HzptuUSouRdDAX1xhSz/r8z/dpBVILn0Y6FJ6x86dQzTST/kShSgi3tv09ez0t9fm8BvvMc62QD3LdJRPbupJm7pVlKVSkNwPuRvIo+iZp7vNBI8c3oKtABaybA7wiCEA0jBCGXm7pLHAf5Pacv8AEfANskW4p07t9oeoWYDFhAKxCkRKjU8t+oavP3n0UHHBSREmqmrGbEq1MIX1kr4v2H9qNisjisYm0Szq6nk8jSEAfGNhhv556grleUcWlHF7wpK3rJxIzh2qXz6I+fEJh0bF3bme9UFVJJY2oBfqe4ktaodpKAfYot6uCFsJKsvOVmFvnMtZjMhmBc6vvoDkYW0nSRQwIrDKgVVebpkfvTrEmng4el
 xzLQ4gh3
 R2VXOxTXxTPZBHrUvyC5jKLbYKc7AlAY2TT9sLvcrP9wLWwA1YdFbA8iRL+lwn5gUlTu1sCqNJgFxWlZNHzcrbRxQed9ni8E81kzn/SP8oEh/hT2jcBZicjnhcEg9m0eLL5XR46fqikJoYNAtPjuDSY+UNwvjYu8s2+6wZXvwhmjmNSi/fmSpLJb3vvWqAnJw+1Yf9Uth5z7Vzuz5sB+uUjk8dGYmIxas6gPmU0FgLXLnGLiY6V2XQww2mrKVgkxWaIcipsYQljFQ3AcFV9dcLTiE8qRpb4fZAKBX4omK96KfK7Rss9144+2v8k+3YKKazHmK3LojVX6Rji0Y5vXTLWxW0PclRjZ0Aozd2n9YGL4aOWnnrzdO5ExYS6qcjrvy76CHXjB5lz+CgefLucYynJZOvdxrTp1ShIPG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

On systems with many superpageblocks, sub-pageblock MOVABLE fragments
within already-tainted SPBs were being skipped by __rmqueue_claim()
due to the ALLOC_NOFRAGMENT pageblock_order floor. This caused the
allocator to fall through to clean SPBs, tainting them unnecessarily.

Introduce SPB_AGGRESSIVE_THRESHOLD: on systems with more than 8
superpageblocks, relax the min_order floor for the preferred category
(tainted SPBs) so non-movable allocations consume free space there at
any granularity. On small systems, preserve the pageblock_order floor
to protect MOVABLE capacity within tainted SPBs.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 13bc57592cd5..215b7d6b95d2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2643,6 +2643,24 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
  */
 #define SPB_TAINTED_RESERVE	4
 
+/*
+ * On systems with many superpageblocks, we can afford to "write off"
+ * tainted superpageblocks by aggressively packing unmovable/reclaimable
+ * allocations into them — even sub-pageblock fragments — to keep clean
+ * superpageblocks clean for future 1GB hugepage and contiguous allocations.
+ *
+ * On small systems (few superpageblocks), each SPB represents a large
+ * fraction of total memory. Aggressively claiming sub-pageblock movable
+ * fragments from tainted SPBs would destroy MOVABLE capacity that the
+ * system can't afford to lose, with little benefit since there are too
+ * few SPBs to meaningfully separate movable from unmovable anyway.
+ *
+ * This threshold controls the crossover: above it, prefer concentrating
+ * non-movable allocations in tainted SPBs at any granularity; below it,
+ * only claim whole free pageblocks from tainted SPBs.
+ */
+#define SPB_AGGRESSIVE_THRESHOLD	8
+
 /**
  * sb_preferred_for_movable - Find the fullest clean superpageblock for movable
  * @zone: zone to search
@@ -3555,6 +3573,7 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 {
 	int current_order;
 	int min_order = order;
+	int nofrag_min_order = order;
 	struct page *page;
 	int fallback_mt;
 	static const unsigned int cat_search[] = {
@@ -3568,9 +3587,18 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 * Do not steal pages from freelists belonging to other pageblocks
 	 * i.e. orders < pageblock_order. If there are no local zones free,
 	 * the zonelists will be reiterated without ALLOC_NOFRAGMENT.
+	 *
+	 * Only apply this restriction to empty and clean superpageblocks.
+	 * Claiming within already-tainted superpageblocks does not cause
+	 * new fragmentation, and skipping them wastes free space that
+	 * could prevent tainting clean superpageblocks.
+	 *
+	 * When ALLOC_NOFRAGMENT is set, skip empty and clean superpageblocks
+	 * entirely to avoid tainting them. The slowpath will try reclaim and
+	 * compaction first, and only drop ALLOC_NOFRAGMENT as a last resort.
 	 */
 	if (order < pageblock_order && alloc_flags & ALLOC_NOFRAGMENT)
-		min_order = pageblock_order;
+		nofrag_min_order = pageblock_order;
 
 	/*
 	 * Find the largest available free page in a fallback migratetype.
@@ -3580,6 +3608,31 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 * ones.
 	 */
 	for (c = 0; c < ARRAY_SIZE(cat_search); c++) {
+		/*
+		 * When avoiding fragmentation, do not search clean/empty
+		 * superpageblocks for fallback pages. Tainting a clean SPB
+		 * is the worst outcome — better to fail and let the slowpath
+		 * try reclaim and compaction in already-tainted SPBs first.
+		 */
+		if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+		    cat_search[c] != SB_SEARCH_PREFERRED)
+			continue;
+
+		/*
+		 * For the preferred category (tainted SPBs for non-movable),
+		 * search all orders down to the allocation order on systems
+		 * with enough superpageblocks that we can afford to write off
+		 * tainted ones. These SPBs are already tainted, so sub-pageblock
+		 * stealing doesn't cause additional fragmentation.
+		 *
+		 * On small systems, keep the pageblock_order floor to preserve
+		 * MOVABLE capacity within tainted SPBs — see comment at
+		 * SPB_AGGRESSIVE_THRESHOLD.
+		 */
+		min_order = (cat_search[c] == SB_SEARCH_PREFERRED &&
+			     zone->nr_superpageblocks > SPB_AGGRESSIVE_THRESHOLD) ?
+			    order : nofrag_min_order;
+
 		for (current_order = MAX_PAGE_ORDER;
 		     current_order >= min_order; --current_order) {
 			if (!should_try_claim_block(current_order,
@@ -3850,8 +3903,18 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 	 * For movable allocations, prefer pageblocks from the
 	 * fullest clean superpageblock to pack allocations and
 	 * preserve empty superpageblocks for 1GB hugepages.
+	 *
+	 * For non-movable allocations, force ALLOC_NOFRAGMENT so
+	 * __rmqueue cannot steal a whole pageblock out of a clean
+	 * SPB. Stealing is the worst possible outcome for a bulk
+	 * refill: a single network or slab burst can taint dozens
+	 * of clean pageblocks. Phase 2 will adopt sub-pageblock
+	 * fragments from tainted SPBs before Phase 3 falls back to
+	 * the original alloc_flags (which may eventually steal at
+	 * the requested order, a much smaller fragmentation event).
 	 */
 	while (refilled + pageblock_nr_pages <= pages_needed) {
+		unsigned int p1_alloc_flags = alloc_flags;
 		struct page *page = NULL;
 
 		if (migratetype == MIGRATE_MOVABLE) {
@@ -3861,11 +3924,14 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 			if (sb)
 				page = __rmqueue_from_sb(zone, pageblock_order,
 							 migratetype, sb);
+		} else if (!is_migrate_cma(migratetype)) {
+			p1_alloc_flags = (p1_alloc_flags | ALLOC_NOFRAGMENT) &
+					 ~ALLOC_NOFRAG_TAINTED_OK;
 		}
 		if (!page)
 			page = __rmqueue(zone, pageblock_order,
 					 migratetype,
-					 alloc_flags, &rmqm);
+					 p1_alloc_flags, &rmqm);
 		if (!page)
 			break;
 
-- 
2.52.0


