Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FF6CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C776B00A5; Wed, 20 May 2026 11:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66EE6B00A8; Wed, 20 May 2026 11:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D555D6B00A6; Wed, 20 May 2026 11:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C00EF6B00A3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BDEA40350
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:48 +0000 (UTC)
X-FDA: 84788110176.26.19873CB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id C50DB20015
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LWI2bTfW;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0aGX80HuR6xHObr34naZL4Dvo5p+JAOapg4ifN1i7w=;
	b=YIM5N8svMK32IMgptxH8CS6d3PWkSn3fnrAPZi50K5mKlRmSk7TjwfdiNYkqD2Ck5HLDsl
	yQhjJtsuH4IxRU3xWnhfqpNM3yh6VJn/WgxBMVuy2Mn0BoxlNMks8WNFIxIJn0jbi3dH86
	v9wZZlTW0Qh7Qxhmvw2Sd/m6FKfRUZ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LWI2bTfW;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289246; a=rsa-sha256;
	cv=none;
	b=Bv5KCRhM5uFpBaA+EqRMA4UjS1AdBHz0AZU38k439jNBk5qm8ZAErNn52bG4cTKOwHr4gi
	2o3+Tuu/JEq92Fuw3kqdhoO9hVzGf1TmXDTNOgaIzuiz1tL3xR7orzD1m0cI7VicKC9DM7
	nyfjZQwomwXl4kb8niC8mVSYcX5TIa0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X0aGX80HuR6xHObr34naZL4Dvo5p+JAOapg4ifN1i7w=; b=LWI2bTfW2IQSaDXqwrxhjngvUI
	vylm668SB0qOQj4/JK5yA+qFKLWgd69FPYkBloCaocxUew0TM2U2XfBc2R6KuFXxL2DRG2H4ffH3k
	jC36QHrhY0O3d87ncBpmUmuYFymOr3LZ/bUFvWWRcVF3FY0Wbmx5xRx8aOsy7OjVdAmtmIIWjd4jy
	oipwlRliXxeiUfz6xxD7qHV3Igfjqkg5JuWAzggmdw7+1njxpVo+gchiiiSCRqDXEgKa4ihuDnOK2
	V+2+chv5HwB2aJu5uB61Mv7RLrX0UB1/fYD7uEVwuAiEAZG0bPzr8te7cF6fJBwmv8JVRgyqo1f+D
	ctIEdSgg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1Lx0;
	Wed, 20 May 2026 11:00:28 -0400
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
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 11/40] mm: page_alloc: steer pageblock stealing to tainted superpageblocks
Date: Wed, 20 May 2026 10:59:17 -0400
Message-ID: <20260520150018.2491267-12-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C50DB20015
X-Rspamd-Server: rspam06
X-Stat-Signature: rbcsyx1jh111is3wzawbcp5jujxfa4rq
X-HE-Tag: 1779289246-844019
X-HE-Meta: U2FsdGVkX1/YQMz9DiA/yUpHXBq3dX78mSJLvNdrlk1Oc0iHqpyT1ggXzS1P0/ZN9Ks9sZy6lw+CC2FN7I8QSWWiTahL9qqqpvfjQ8QmA/8Fcpqm4egJ8e8BbnHYfou6FR55rrdgxg8+hdjpM9kFzAMQ8QJmAnZ5a6JEyio5uL9vp7cOSmQn1MYMXvi0PiHd5jRVHm/b0V5b2PF6JSYI9etN8ABybKnNd9P0QUJa84i2V5xM+98Rq77836eyRCYBZExW92tA9Np/MiS6NoWTgAAScpsZzqk0GDaub8fKRcf2IBcw3bfPwrJp9Zi297YeSNTaTYAw6paCCVGw6rOEqC/iPBqky4UNPT/xWaCb0E4lkCggJr0XFIsbkj/qLOB+I2CVciY4jrUmc850Lixo7PwgCzuEyHkgiPCth1OlDq3GtPtvXymkjlF84tDm8I1quYJrUQPi5Gyh0x0JOs98T5y7OvueUy3VIkJmdROcBkKWo461dI+yymprT+oYR38/6+psykwFo9G4SmF8/qyd6sHA3lmnlyXgkbiqy/gwZos9NU+v4/tzIPcOf/A0dljKoCkO+gaBRc01KfhZPjy7QRaLN6W6aOamIcJHdeFffeWie1/nLerPuiSdas26zlj0AlXThWjueAcHDRsUTgp0pu3BLbVSJWpv2bUED56R5uxRDCkGgcIar/5AGrfmhUXtkLi8FJZ503nB0QbJmMoumGhg6+YI+VEdZxLRLPrS90ZTJOIJB6woJrSsA7V9yUB/NIMma8SkBFXTp31Pmk6nFwjoovorkXdQhhhMhixjfiSeD3GYH+XWS55vUrP0XcKFr2ts+wJiqEcvjUlTVG4QQFSrljIncW5xhvVzWCcYn6SvIZoWmLkp5f5G8DaaMwPn6lq0ry90wagg+Vc8RGfmQMxfi+6AHAv15dX3qLGIXMmEHcH6Y29a6ubm6CE49iZb2xbedTFQBB9Dd65Dj4M
 usjRKLi0
 1tkEafCzeyi48xtt4qWw2T+1BK2J+F5H947jG+4SemkcommxFaI+4GBmbIS4E713O4FO/ZiF8xDbMWj2yWuydLy8Z/jvuVmpesGcA33xdUHFrJ/1AcAP6XBOX/e/SaN712NLJLGNhuVc0HGnVUjrSixNCugCrMb9qnhZgi4H6IrSydrioFUAhiGrFL16/Z4TlSNlgHnwgtRWzHV30FOuB/GDADsUoons96GFwb7a4g5/N/SyQ5ESDLuOqIb/pH2XfiEMW5hUH65fOcGIb199y0JM72Km3KHkxiFg1TuH+agy2bdzDbBHStLKzIuDIVKiO/hFo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the allocator needs to steal a movable pageblock for unmovable or
reclaimable allocations, prefer pages from already-tainted superpageblocks.
This concentrates contamination in superpageblocks that are already impure,
preserving clean superpageblocks for future 1GB hugepage allocations.

In __rmqueue_claim, after finding a candidate page on the free list, check
if it belongs to a clean superpageblock. If so, do a bounded scan
(SPB_SCAN_LIMIT=8) of the same free list looking for a page from a
tainted superpageblock instead. This is a best-effort optimization:
if no tainted alternative is found, the original page is used.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 100 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c0f86a30b5c7..a17c4cd9a788 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2327,6 +2327,9 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 		clear_page_pfmemalloc(page);
 }
 
+/* Bounded scan limit when searching free lists for tainted superpageblock pages */
+#define SPB_SCAN_LIMIT 8
+
 /*
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
@@ -2694,6 +2697,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
+	struct superpageblock *sb;
 #ifdef CONFIG_COMPACTION
 	struct page *start_page;
 #endif
@@ -2726,7 +2730,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 				clear_pfnblock_bit(pb_page, pb_pfn, PB_all_free);
 				superpageblock_pb_now_used(pb_page);
 			}
+			__spb_set_has_type(pb_page, start_type);
 		}
+		/* Single list update after all pageblocks processed */
+		sb = pfn_to_superpageblock(zone, page_to_pfn(page));
+		if (sb)
+			spb_update_list(sb);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
@@ -2771,29 +2780,24 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
 #ifdef CONFIG_COMPACTION
 		/*
-		 * Track actual page contents in pageblock flags.
-		 * Mark the pageblock with the type being allocated, and
-		 * if unmovable/reclaimable pages are being placed into a
-		 * pageblock that already has movable pages, queue async
-		 * evacuation of the movable pages.
+		 * Track actual page contents in pageblock flags and
+		 * update superpageblock counters so the SPB moves to
+		 * the correct fullness list for steering.
 		 */
 		start_page = pfn_to_page(start_pfn);
-		if (start_type == MIGRATE_UNMOVABLE) {
-			set_pfnblock_bit(start_page, start_pfn,
-					 PB_has_unmovable);
-			if (get_pfnblock_bit(start_page, start_pfn,
-					     PB_has_movable))
-				queue_pageblock_evacuate(zone, start_pfn);
-		} else if (start_type == MIGRATE_RECLAIMABLE) {
-			set_pfnblock_bit(start_page, start_pfn,
-					 PB_has_reclaimable);
-			if (get_pfnblock_bit(start_page, start_pfn,
-					     PB_has_movable))
-				queue_pageblock_evacuate(zone, start_pfn);
-		} else if (start_type == MIGRATE_MOVABLE) {
-			set_pfnblock_bit(start_page, start_pfn,
-					 PB_has_movable);
-		}
+		__spb_set_has_type(start_page, start_type);
+		if (block_type != start_type)
+			__spb_set_has_type(start_page, block_type);
+
+		sb = pfn_to_superpageblock(zone, start_pfn);
+		if (sb)
+			spb_update_list(sb);
+
+		if ((start_type == MIGRATE_UNMOVABLE ||
+		     start_type == MIGRATE_RECLAIMABLE) &&
+		    get_pfnblock_bit(start_page, start_pfn,
+				     PB_has_movable))
+			queue_pageblock_evacuate(zone, start_pfn);
 #endif
 		return __rmqueue_smallest(zone, order, start_type);
 	}
@@ -2847,6 +2851,38 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 			break;
 
 		page = get_page_from_free_area(area, fallback_mt);
+
+		/*
+		 * For unmovable/reclaimable stealing, prefer pages from
+		 * tainted superpageblocks (already contaminated) to keep clean
+		 * superpageblocks clean for future 1GB allocations.
+		 */
+		if (start_migratetype != MIGRATE_MOVABLE &&
+		    zone->superpageblocks && page) {
+			struct superpageblock *sb;
+			struct page *alt;
+			int scanned = 0;
+
+			sb = pfn_to_superpageblock(zone, page_to_pfn(page));
+			if (sb && spb_get_category(sb) == SB_CLEAN) {
+				list_for_each_entry(alt,
+						    &area->free_list[fallback_mt],
+						    buddy_list) {
+					struct superpageblock *asb;
+
+					if (++scanned > SPB_SCAN_LIMIT)
+						break;
+					asb = pfn_to_superpageblock(zone,
+							page_to_pfn(alt));
+					if (asb && spb_get_category(asb) ==
+					    SB_TAINTED) {
+						page = alt;
+						break;
+					}
+				}
+			}
+		}
+
 		page = try_to_claim_block(zone, page, current_order, order,
 					  start_migratetype, fallback_mt,
 					  alloc_flags);
@@ -2867,6 +2903,7 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 static __always_inline struct page *
 __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 {
+	struct superpageblock *sb;
 	struct free_area *area;
 	int current_order;
 	struct page *page;
@@ -2881,6 +2918,27 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 
 		page = get_page_from_free_area(area, fallback_mt);
 		page_del_and_expand(zone, page, order, current_order, fallback_mt);
+
+		/*
+		 * page_del_and_expand recorded PB_has_<fallback_mt> for the
+		 * source free list type. Also record the actual allocation
+		 * type so evacuation and defrag can find these pages.
+		 *
+		 * For example, a MOVABLE allocation stealing from an
+		 * UNMOVABLE free list must set PB_has_movable so the
+		 * pageblock is visible to evacuate_pageblock() and
+		 * spb_defrag_tainted(). __spb_set_has_type is idempotent:
+		 * it only increments the SPB counter on the 0->1 bit
+		 * transition.
+		 */
+		if (fallback_mt != start_migratetype) {
+			__spb_set_has_type(page, start_migratetype);
+			sb = pfn_to_superpageblock(zone,
+						   page_to_pfn(page));
+			if (sb)
+				spb_update_list(sb);
+		}
+
 		trace_mm_page_alloc_extfrag(page, order, current_order,
 					    start_migratetype, fallback_mt);
 		return page;
-- 
2.54.0


