Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B006ECD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20496B00A2; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7DB6B00A4; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C546B00A6; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE8E6B00A2
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A64E120192
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:04 +0000 (UTC)
X-FDA: 84716346288.03.4018D2C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 771A82000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ol+PQ6Ql;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6pEoJN7N/BKBpNIE8VUNRZpC0OasGcB9R9R8csX/+8=;
	b=XP/mMq8tT0WjSGXZBD0JdoaigTNUbUeZ7fr0kO7t2rlntfEvU8zOTt2rFlHV/1UYG6/8z0
	92o+jZCVTkub57tTtmCEWRRMBsqEKCvZgfFLN8CLumewV+nTPIJZz/IuW06PM6aYPOU0Zs
	j+vLw3VIT9/lHFH/bEitGDbfdvh2nWA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ol+PQ6Ql;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580582; a=rsa-sha256;
	cv=none;
	b=8eyz9SQr6pJVEBdR/xLnPttZJYNyEDCstZvBuiSorHob4V8b/IBO9PwzmpJwNlToQU1U62
	mHP8fB/OI4NvFQZ3TZRP7aTKJH7m2NIS/J5D/RQwJDq+hu3gfNN0yac8ehTSqZjEfcfe5E
	kaiHRbhAoBEllxleCKKXuZjtgYbPX3U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M6pEoJN7N/BKBpNIE8VUNRZpC0OasGcB9R9R8csX/+8=; b=Ol+PQ6QlqJFM6+GW1lMN+o23gW
	6dOX9gDxTIJdtam4XCJ+cVX0IvPCtWc+N1P0e1MmFEhwL0RxgbwUBRaRvIdolXxkPqxvVzXrhq82f
	M4En2qJIyCSahFEuCNU/RwAqGBuagLnHFWCvsSRhqQVgI36tk3wNANaYxEfJktufejP1IGGaDMkgt
	F03lyU0/gcH4usS5qIiwUc26/VhxeE+Pufa7BxC5PDqhhPZysJ9+Ca1l9oFXYpiovYe4AoqhzypTB
	fIRBceHAKJ9IwnULF3eMXehw8n7GDz6TRZoIbPpPSmblACVAOk0B0O7u0DzYIQuit9HIyIDyZ0BZj
	m17lGcJQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2yo4;
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
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 12/45] mm: page_alloc: steer pageblock stealing to tainted superpageblocks
Date: Thu, 30 Apr 2026 16:20:41 -0400
Message-ID: <20260430202233.111010-13-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 771A82000A
X-Stat-Signature: 36wgotpzw9i8auzgks6k1e51b5uof8ue
X-HE-Tag: 1777580582-692089
X-HE-Meta: U2FsdGVkX1/b6GwDPnS9zA7pA/ZA1C7+svnbwJVo0QiLUJHWXsoqZB58ZhzCAvxk/5Mfp9zqMfxB4xiwKnyNEgJ4zQD/oJgl0VWA92aB++PZcM63QamdH9/T+IkNybaVhBCSHvAj3wg/Rn2RrcdaX0P/FjlbgXJ/XHMH+eiPf0hZjBgxHrOzBrSIRQ4HcKaums3N8XBjsoer4I83fYdhcOgG0tJmR9phroomSFbSeamcarpOdfosbV0YfcPuds8yp92p8K6X8dvAd9znAZoBwTtb5a2qLblaF3oFjYZ6YpcgumGk9R2L9XlGon0wXUFhuRo9lyEC8pEgyi/JwjaROwZttxXm/bbAC82ZRpMe7Y58rlZ5zuCIzTaC1/s4KY2hS4uEkERGPa9LwhJL5lnk3VVtdAqFiJ5juuXy0C5b4n3/UZTxdJO4uz448GYS7Qrk1iifqQzyuNKN+M8zRv5/sC9/yJB2+t9KhQxUisdawqSKmnODdw1xucyNjYLEN2uwag2Uy/U4E44d3pxku/THtwLv+Bxc8NPQ3+4SUey6kq+t28t0+fHj6IcG4ivd74ngU6cOH+r8YKqX31Y8rplOo0mkcudUidtXMN/JReLAnkrz4iFzx1nvWiTP81JqvRCpD755twK5ir89h3WoTsvZP6qd3U5WPLnVpg+tYbflB44ZcfzqfPVuP6FZq5Ix4R14Ohqti2QLHBHH8s50lXV16OvjsyXUS+TH1t4RYwvPyUiz6bZxie6vVd5hZ/1lJl/hSTS0s4P60fMPR5Xc5SJkfD9ZmltAKGTHAlAmG/kWPTm0T+XbHleMHcRgRoINlLxRbzAiEnLsENvSAKJh3xJn0msBIuloMm6IqX5HzmCwSTv5Y8SmvNRiXeiy4dYj4XMoZUbhh/ljt98yJzp1i5WS2yQGz67YHOJkFoDUt5uX07cW3+2CSSmWXvsiQB+9xDmcTPtyVIvxnHW6RK6E+ek
 zIjBUsiK
 5VU/UxnBDWagX6bqbhT6/2PvG1DtmHJ0vQNW+SAgrUMZxfBIAIIsDFiRPkaJ6kLvv65GvE2rZx3NTLxBWzyu15SNfPo5KeraNlBysXzC4AbKNUn2nXamgrGFLQQGLydEeA4tnhWd+SdW6bheVZWGHdUAVFiuSQK/MEIZ8ERIZFEwVHkN2HbCbHI+IPcFwvCrueM+PH8S+Xq+ynWe1EfUjz+xdnXlSR+Q3Ka+hmu2eQUiElN6hvceydKFiYjHEoxMVEZZyI9fFxqWNVQq3dVSXLz8nQ0lHb+BFxmqTDve163rgKpHoCw62H7EyqbcaIQLTfz4CAWla8/fvI2JgkbO+4hPz2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

When the allocator needs to steal a movable pageblock for unmovable or
reclaimable allocations, prefer pages from already-tainted superpageblocks.
This concentrates contamination in superpageblocks that are already impure,
preserving clean superpageblocks for future 1GB hugepage allocations.

In __rmqueue_claim, after finding a candidate page on the free list, check
if it belongs to a clean superpageblock. If so, do a bounded scan
(SB_SCAN_LIMIT=8) of the same free list looking for a page from a
tainted superpageblock instead. This is a best-effort optimization:
if no tainted alternative is found, the original page is used.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 103 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 82 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed0919280dd6..d795f41975c1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2308,6 +2308,9 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 		clear_page_pfmemalloc(page);
 }
 
+/* Bounded scan limit when searching free lists for tainted superpageblock pages */
+#define SPB_SCAN_LIMIT 8
+
 /*
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
@@ -2704,6 +2707,14 @@ try_to_claim_block(struct zone *zone, struct page *page,
 				clear_pfnblock_bit(pb_page, pb_pfn, PB_all_free);
 				superpageblock_pb_now_used(pb_page);
 			}
+			__spb_set_has_type(pb_page, start_type);
+		}
+		/* Single list update after all pageblocks processed */
+		{
+			struct superpageblock *sb =
+				pfn_to_superpageblock(zone, page_to_pfn(page));
+			if (sb)
+				spb_update_list(sb);
 		}
 
 		del_page_from_free_list(page, zone, current_order, block_type);
@@ -2749,31 +2760,27 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
 		{
 			struct page *start_page = pfn_to_page(start_pfn);
+			struct superpageblock *sb;
 
-			if (start_type == MIGRATE_UNMOVABLE) {
-				set_pfnblock_bit(start_page, start_pfn,
-						 PB_has_unmovable);
-				if (get_pfnblock_bit(start_page, start_pfn,
-						     PB_has_movable))
-					queue_pageblock_evacuate(zone, start_pfn);
-			} else if (start_type == MIGRATE_RECLAIMABLE) {
-				set_pfnblock_bit(start_page, start_pfn,
-						 PB_has_reclaimable);
-				if (get_pfnblock_bit(start_page, start_pfn,
-						     PB_has_movable))
-					queue_pageblock_evacuate(zone, start_pfn);
-			} else if (start_type == MIGRATE_MOVABLE) {
-				set_pfnblock_bit(start_page, start_pfn,
-						 PB_has_movable);
-			}
+			__spb_set_has_type(start_page, start_type);
+			if (block_type != start_type)
+				__spb_set_has_type(start_page, block_type);
+
+			sb = pfn_to_superpageblock(zone, start_pfn);
+			if (sb)
+				spb_update_list(sb);
+
+			if ((start_type == MIGRATE_UNMOVABLE ||
+			     start_type == MIGRATE_RECLAIMABLE) &&
+			    get_pfnblock_bit(start_page, start_pfn,
+					     PB_has_movable))
+				queue_pageblock_evacuate(zone, start_pfn);
 		}
 #endif
 		return __rmqueue_smallest(zone, order, start_type);
@@ -2828,6 +2835,38 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
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
@@ -2848,6 +2887,7 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 static __always_inline struct page *
 __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 {
+	struct superpageblock *sb;
 	struct free_area *area;
 	int current_order;
 	struct page *page;
@@ -2862,6 +2902,27 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 
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
2.52.0


