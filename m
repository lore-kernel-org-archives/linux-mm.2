Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579E1CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7016E6B00A7; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B6A6B00A9; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FAC6B00A8; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 331796B00A6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEFC6120159
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:05 +0000 (UTC)
X-FDA: 84716346330.03.957A5E2
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5E79A4000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BoZodtr1;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iau1uajHmWm3rM+qXHG8UrUzgUxSiM6Prt/eiG7YJr4=;
	b=8YFlPBu1NOvGhKDj7SkKgxg8tVjWILHlEu/PMnyzEDLFjJcLlCfijaBcKvBy0s+kkpmUh9
	jYtHceMz3vZZnPBGrX6wBPCnvfsVu/x/dYTnkHZ4n+PfoGXWs+pxfsE6Jis86ysP74BsCO
	s3Bjhq1mASeEDKkgSCumLqduEP7Kxz8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580584; a=rsa-sha256;
	cv=none;
	b=gKtQ/Z9C5+ns1JfimSQIriLKsL0NO9ZVl3eQJtFFayuFIPk7U+c2RPK1ps+a/1zfNU1O++
	N9254bFKjSSBYYbsiMsTLhktIcFPbt/hauzY0oqJmV1jZswTdj9WnKSWcePC5zXYNu9Ox4
	ydMqJ/MJkJGGRrD5TDKkC3Yt9ky7eEI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BoZodtr1;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Iau1uajHmWm3rM+qXHG8UrUzgUxSiM6Prt/eiG7YJr4=; b=BoZodtr1BzcAILrwsHeb1JWkMh
	blWzOA7IiciiN6HZrQaXFcvKW9t6ZZKXcFiqmbr0sQY1IW7X8oUNsbgPfHByzQO2kRTayCJKlUFNA
	ZjECZ49RJNKA5/T81whh/hsjPnwElaIJKVIQgEVU0Tp0RkSwthvVhV2WVAdozu5OmVvsL1GdL5yKh
	jeeOmNl6RusaxAWpgL7cP5Rl7dRM7dVii+EvBt4wuVJFUfipHM/W6eTfri+LSfv50xSGWsopc7P9k
	u3qype7v76M22UF83ayNNIHqqLafnubK4gn2z2PQ4yTHO8sj9AQKQM4im1Lm/UKMCWoHoCMMhqymp
	AP9+De5w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-4BcX;
	Thu, 30 Apr 2026 16:22:41 -0400
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
Subject: [RFC PATCH 24/45] mm: page_alloc: targeted evacuation and dynamic reserves for tainted SPBs
Date: Thu, 30 Apr 2026 16:20:53 -0400
Message-ID: <20260430202233.111010-25-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E79A4000E
X-Stat-Signature: zw5u84sp1h44zwxpgwxkhqm1s7w51913
X-Rspam-User: 
X-HE-Tag: 1777580584-651716
X-HE-Meta: U2FsdGVkX19E2VeRzVBbqtVJlHo3CCV8JXKIKEU4arm3gMZig90e+ThlgAl0Vwv9bwZo9Lknq6VnoQ9ky9jRMT5ZEqR0rn12pu3SAZg8lRYOJIfuz6Jc+5cg2pLTFYdLKIP2JZOplR7B3EXYp4Fb+o9JN6Fq3eEhFuVDaJslGX6AQxdce7k/rndZRvd2dxDmMMexXOsuwxqzDi4AVlm20oYjbVe+360s+Sr+EHuHF35jXG7OlUkPRJXHONBkW4q7qbcUaKsyF3q29/3BcCSsyodJvTNT3mBNozuvTRLoEUFNr5G+bFTurA/HXKcSeAn47uEX9LGqIXvSLfeWYxS+g3ykpuj4+JYhaRjEdqHHD+uu/kUBgCSstK8CkgfzkFEwWjlXi/s1+K9sSIRNPmpINzfHvUnAhcFUNqD8eiLbGruw8ni3koAJRk8FP2ND1EhEwRn0rUR3kq/sZ7oLwsDxEPRA7pzg3KxEw/UcKn+VpSFMDKRUNeLDklS5B+lZhtPTW/hiYTLbIygnxJfAGf+2LPgsr+bqhvSHMW3a5wOEfc9P1jbn21OJYpN8m9VgIZ4Zwp9Fy82dUcB/DH+01p6VAYxr1rTmf+Bqt11caelBvvZFrxrp0gWigfysqWGHNkgIaLHoLMGWcMs9dt27cwlrnRGG70LHnjg51PF8BQrNWbNt8qqNpxbt79fG3gsVPT7Lq4uqb7LALAMDcn1Rl2kq+bGfGvst/7INBJwfHlqYr2V/uflztfP8B0qHmw+RW/PGiLA9PbzXK17J/MUFBL0ZeverV3cSOgPqVDzU5B8BM7vKoRvz1lkxZFJYRNNMpUw8U4ARMoJ4yvkQbcWcfroguKsZzMdXGqpz6n2ugESSwfSfYleK+STsR1rCyzVHUYC/shTGpNa+it62mWifnnjvLZ0xr7vyhIQXb0EgMEVtGvsv7RxMd38xSGICaNJBoomF/RPzJxmpeFDgVgu/901
 +HoP/cG+
 w+eRxJqqgtOi8gyqmUr4Qev9a0EUnUl51RdtbWepYrjkUGopRebPc42P57r5qOEpQDHr0PYbDKiGqjFuyS2r+DRRBRV4t0/+oDXuguqD7xIMEWsFrfXtzQpysif4JbbwDny9pju0lhzB73uFfKGgRhm7tWMQ2PYjCwHv9Odq9ulv/RypWLvLFccFLz4S6w6GMhqPhh/QyDeyqPbTbHBtP5/Sn74xVs/LmhnG9LwEuO1QhKiMOJ58+08uK6Sb/jbytd6aAJjwnB0wzmZFNl+ti3a2jQuOC1wiwgxZ/AVwq4BK9EFnV/ACrEhge81lyOir0bebgU0dNF1vFYAaw6FW0IzIdGfAvGU9iWtn0r4cTok0F2T/Vl5Z+0LtTDKyXjnoF4vGL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Reduce tainted superpageblock proliferation with two changes:

1. Dynamic SPB_TAINTED_RESERVE: scale the movable steering reserve with
   SPB size (~3% of pageblocks, minimum 4). For a 512-pageblock SPB this
   gives 16 reserved pageblocks instead of the previous flat 4, triggering
   async defrag 4x earlier and keeping more headroom for unmovable claims.

2. Two-phase targeted evacuation before NOFRAGMENT drop: when the slowpath
   is about to drop ALLOC_NOFRAGMENT for unmovable/reclaimable allocations,
   first try evacuating movable pages from tainted SPBs to create free
   pageblocks. Phase 1 evacuates movable pages from pageblocks already
   labeled as the desired migratetype (buddy coalescing). Phase 2 evacuates
   entire MOVABLE pageblocks to create free whole pageblocks that Pass 2
   can claim for the desired migratetype. This avoids tainting clean SPBs
   in many cases where existing tainted SPBs have reclaimable capacity.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 176 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 125 insertions(+), 51 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f4298fc2727..493db531b869 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2675,8 +2675,16 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
  * fewer than this many free pageblocks, ensuring that unmovable claims
  * always find room in existing tainted superpageblocks instead of spilling
  * into clean ones.
+ *
+ * Scale with SPB size: reserve ~3% of pageblocks (minimum 4).
+ * For a 512-pageblock SPB this gives 16 reserved pageblocks.
  */
-#define SPB_TAINTED_RESERVE	4
+#define SPB_TAINTED_RESERVE_MIN	4
+
+static inline u16 spb_tainted_reserve(const struct superpageblock *sb)
+{
+	return max_t(u16, SPB_TAINTED_RESERVE_MIN, sb->total_pageblocks / 32);
+}
 
 /*
  * On systems with many superpageblocks, we can afford to "write off"
@@ -2988,7 +2996,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				 * with few free pageblocks to reserve space
 				 * for future unmovable/reclaimable claims.
 				 */
-				if (sb->nr_free <= SPB_TAINTED_RESERVE)
+				if (sb->nr_free <= spb_tainted_reserve(sb))
 					continue;
 				for (current_order = order;
 				     current_order < NR_PAGE_ORDERS;
@@ -3552,7 +3560,7 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					&sb->free_area[order];
 
 				if (movable && cat == SB_TAINTED &&
-				    sb->nr_free <= SPB_TAINTED_RESERVE)
+				    sb->nr_free <= spb_tainted_reserve(sb))
 					continue;
 
 				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
@@ -3601,7 +3609,7 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					&sb->free_area[order];
 
 				if (movable && cat == SB_TAINTED &&
-				    sb->nr_free <= SPB_TAINTED_RESERVE)
+				    sb->nr_free <= spb_tainted_reserve(sb))
 					continue;
 
 				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
@@ -6588,9 +6596,33 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	/*
 	 * Reclaim and compaction have been tried but could not free enough
-	 * pages in already-tainted superpageblocks. Drop NOFRAGMENT as a
-	 * last resort to allow claiming from clean/empty SPBs and stealing
-	 * across migratetype boundaries. This is better than OOM-killing.
+	 * pages in already-tainted superpageblocks. Before dropping
+	 * NOFRAGMENT, try targeted evacuation of movable pages from
+	 * tainted SPBs to create free pageblocks for unmovable claims.
+	 */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+	    (ac->migratetype == MIGRATE_UNMOVABLE ||
+	     ac->migratetype == MIGRATE_RECLAIMABLE)) {
+		struct zoneref *z;
+		struct zone *zone;
+
+		for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+					       ac->highest_zoneidx,
+					       ac->nodemask) {
+			if (spb_evacuate_for_order(zone, order,
+						  ac->migratetype)) {
+				page = get_page_from_freelist(gfp_mask, order,
+							     alloc_flags, ac);
+				if (page)
+					goto got_pg;
+			}
+		}
+	}
+
+	/*
+	 * Targeted evacuation could not free enough either. Drop
+	 * NOFRAGMENT as a last resort to allow claiming from clean/empty
+	 * SPBs. This is better than OOM-killing.
 	 */
 	if (alloc_flags & ALLOC_NOFRAGMENT) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
@@ -8688,7 +8720,7 @@ static bool spb_needs_defrag(struct superpageblock *sb)
 	 */
 	if (spb_get_category(sb) == SB_TAINTED)
 		return sb->nr_movable > 0 &&
-		       sb->nr_free < SPB_TAINTED_RESERVE;
+		       sb->nr_free < spb_tainted_reserve(sb);
 
 	/*
 	 * Clean superpageblocks: compact scattered free pages into whole
@@ -8720,7 +8752,7 @@ static bool spb_defrag_done(struct superpageblock *sb)
 	 */
 	if (spb_get_category(sb) == SB_TAINTED)
 		return !sb->nr_movable ||
-		       sb->nr_free >= SPB_TAINTED_RESERVE;
+		       sb->nr_free >= spb_tainted_reserve(sb);
 
 	/* Clean superpageblocks: stop when enough free pageblocks exist */
 	if (sb->nr_free >= 2)
@@ -9710,16 +9742,18 @@ static struct page *spb_try_alloc_contig(struct zone *zone,
 }
 
 /**
- * sb_collect_evacuate_candidates - Find pageblocks for targeted evacuation
+ * sb_collect_evacuate_candidates - Find tainted SPBs for targeted evacuation
  * @zone: zone to search (must hold zone->lock)
- * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE)
+ * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE),
+ *               or -1 to find any tainted SPB with movable pages
  * @sb_pfns: output array of tainted superpageblock start PFNs
  * @max: maximum candidates to collect
  *
- * Find tainted superpageblocks containing pageblocks of the desired migratetype
- * that also have movable pages to evacuate. Evacuating movable pages from
- * these pageblocks creates buddy coalescing opportunities for high-order
- * allocations of the desired migratetype.
+ * Find tainted superpageblocks with movable pages to evacuate.  When
+ * @migratetype is specified, only return SPBs that also contain pageblocks
+ * of that type (for coalescing within existing non-movable pageblocks).
+ * When @migratetype is -1, return any tainted SPB with movable pages
+ * (for freeing whole pageblocks via movable evacuation).
  *
  * Returns number of candidate superpageblock PFNs found.
  */
@@ -9734,20 +9768,22 @@ static int sb_collect_evacuate_candidates(struct zone *zone, int migratetype,
 	for (full = 0; full < __NR_SB_FULLNESS; full++) {
 		list_for_each_entry(sb, &zone->spb_lists[SB_TAINTED][full],
 				    list) {
-			bool has_matching;
-
 			if (!sb->nr_movable)
 				continue;
 
-			if (migratetype == MIGRATE_UNMOVABLE)
-				has_matching = sb->nr_unmovable > 0;
-			else if (migratetype == MIGRATE_RECLAIMABLE)
-				has_matching = sb->nr_reclaimable > 0;
-			else
-				continue;
+			if (migratetype >= 0) {
+				bool has_matching;
 
-			if (!has_matching)
-				continue;
+				if (migratetype == MIGRATE_UNMOVABLE)
+					has_matching = sb->nr_unmovable > 0;
+				else if (migratetype == MIGRATE_RECLAIMABLE)
+					has_matching = sb->nr_reclaimable > 0;
+				else
+					continue;
+
+				if (!has_matching)
+					continue;
+			}
 
 			sb_pfns[n++] = sb->start_pfn;
 			if (n >= max)
@@ -9757,17 +9793,56 @@ static int sb_collect_evacuate_candidates(struct zone *zone, int migratetype,
 	return n;
 }
 
+/*
+ * Evacuate pageblocks of the given migratetype within a range.
+ * Returns number of pageblocks evacuated.
+ */
+static int evacuate_pb_range(struct zone *zone, unsigned long start_pfn,
+			     unsigned long end_pfn, int migratetype, int max)
+{
+	unsigned long pfn;
+	int nr_evacuated = 0;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+
+		if (!pfn_valid(pfn))
+			continue;
+
+		if (!zone_spans_pfn(zone, pfn))
+			continue;
+
+		page = pfn_to_page(pfn);
+
+		if (get_pfnblock_migratetype(page, pfn) != migratetype)
+			continue;
+
+		if (!get_pfnblock_bit(page, pfn, PB_has_movable))
+			continue;
+
+		evacuate_pageblock(zone, pfn, true);
+		if (++nr_evacuated >= max)
+			break;
+	}
+	return nr_evacuated;
+}
+
 /**
  * spb_evacuate_for_order - Targeted evacuation of movable pages from
- *                         unmovable/reclaimable pageblocks
+ *                         tainted superpageblocks
  * @zone: zone to work on
  * @order: allocation order that failed
  * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE)
  *
- * Instead of blind compaction, use superpageblock metadata to find pageblocks
- * of the right migratetype in tainted superpageblocks and evacuate their
- * movable pages. This creates buddy coalescing opportunities within
- * the pageblock, enabling higher-order allocations.
+ * Two-phase evacuation to create free space in tainted superpageblocks:
+ *
+ * Phase 1: Evacuate movable pages from pageblocks already labeled as
+ * @migratetype. This creates buddy coalescing opportunities within
+ * existing non-movable pageblocks.
+ *
+ * Phase 2: Evacuate entire MOVABLE pageblocks from tainted SPBs.
+ * When fully evacuated, these become free whole pageblocks that
+ * __rmqueue_smallest Pass 2 can claim for the desired migratetype.
  *
  * Returns true if evacuation was performed (caller should retry allocation).
  */
@@ -9779,40 +9854,39 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 	int nr_sbs, i;
 	bool did_evacuate = false;
 
+	/* Phase 1: coalesce within existing non-movable pageblocks */
 	spin_lock_irqsave(&zone->lock, flags);
 	nr_sbs = sb_collect_evacuate_candidates(zone, migratetype,
 						sb_pfns,
 						SPB_CONTIG_MAX_CANDIDATES);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	for (i = 0; i < nr_sbs && !did_evacuate; i++) {
-		unsigned long pfn, end_pfn;
-
-		end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
-		for (pfn = sb_pfns[i]; pfn < end_pfn;
-		     pfn += pageblock_nr_pages) {
-			struct page *page;
+	for (i = 0; i < nr_sbs; i++) {
+		unsigned long end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
 
-			if (!pfn_valid(pfn))
-				continue;
-
-			/* Superpageblocks can straddle zone boundaries. */
-			if (!zone_spans_pfn(zone, pfn))
-				continue;
+		if (evacuate_pb_range(zone, sb_pfns[i], end_pfn,
+				      migratetype, 3))
+			did_evacuate = true;
+	}
 
-			page = pfn_to_page(pfn);
+	if (did_evacuate)
+		return true;
 
-			if (get_pfnblock_migratetype(page, pfn) != migratetype)
-				continue;
+	/* Phase 2: evacuate MOVABLE pageblocks to create free whole pageblocks */
+	spin_lock_irqsave(&zone->lock, flags);
+	nr_sbs = sb_collect_evacuate_candidates(zone, -1,
+						sb_pfns,
+						SPB_CONTIG_MAX_CANDIDATES);
+	spin_unlock_irqrestore(&zone->lock, flags);
 
-			if (!get_pfnblock_bit(page, pfn, PB_has_movable))
-				continue;
+	for (i = 0; i < nr_sbs; i++) {
+		unsigned long end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
 
-			evacuate_pageblock(zone, pfn, true);
+		if (evacuate_pb_range(zone, sb_pfns[i], end_pfn,
+				      MIGRATE_MOVABLE, 3))
 			did_evacuate = true;
-			break;
-		}
 	}
+
 	return did_evacuate;
 }
 #endif /* CONFIG_COMPACTION */
-- 
2.52.0


