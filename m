Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4A4CCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328D16B00B9; Thu, 30 Apr 2026 17:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA0B6B00BC; Thu, 30 Apr 2026 17:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8656B00BD; Thu, 30 Apr 2026 17:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08FAC6B00B9
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:36:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A990E120107
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:36:33 +0000 (UTC)
X-FDA: 84716531466.27.E403128
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0647F1C0014
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:36:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=EhCHmZfv;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777584992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf9reZHgSHYNVIk6lg9DWjojuUVoE5Unv6DtuPNPWzM=;
	b=DkVSCJxdmCBGL5IKkErLrZI12IU0hlYHveaesHl18z8ZS510VLM9HkQd4M5adjb8rmHuMc
	PHbcXHItJ+dDvk3iSbOweQLZ7uMhUd/rJBnGU6U9mEnY66QqzTG72BQB8rVN7KajLrz/9O
	tgQmwvW7S5fpmxySRQ+INAQ80tfqP7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777584992; a=rsa-sha256;
	cv=none;
	b=Scb02TP5aDtAQKFI3oip9gHsaviTA/Awf0kWI8T8cmmyqENC+b5qRbhXWkH3ReE60Tj775
	vG6h784uhPoajR1eHCr8cSbABFcO6nXfjTfgHAyr/v6s5eeNuu7L0V5iBwweyOLsCGP1W9
	5F7wysAZomM7azQT/mFafLBQuSXMOjM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=EhCHmZfv;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zf9reZHgSHYNVIk6lg9DWjojuUVoE5Unv6DtuPNPWzM=; b=EhCHmZfvKOaoXulpv4/AskEX44
	zA5DDsl31PJqXlxrNfGZWEZQ4YobqdVNx2cXAuCcXElgvvrWTlpxUgTHqJfpho4uVmYIhL5O05XY7
	332gHM79S5LUKeKt/bJ/Kf/lmZdlGVVnQ0jPG7QzGME7PVT8RdKjZ38boZ7L/yNCjcUKaJZ69GbGA
	WSozUole/i4geGl5o4BZoNt780GY3eKaIABybCSL1Ds+JT4yDoJTimPcIcegCZjNHdsU6yhFKgrqf
	SE75y+YoWinxCKKRr2pjTwEoiICT8ehRyNup6JF9XLz6HDKJcgWr6rP8cxSIjvuLEuhzz7mVzYYWO
	Tr5mGaFQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-0AjO;
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
Subject: [RFC PATCH 26/45] mm: page_alloc: prevent UNMOVABLE/RECLAIMABLE mixing in pageblocks
Date: Thu, 30 Apr 2026 16:20:55 -0400
Message-ID: <20260430202233.111010-27-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0647F1C0014
X-Stat-Signature: 165muku1r3kc1nnh9nmpwkfuy115aoek
X-Rspam-User: 
X-HE-Tag: 1777584991-332259
X-HE-Meta: U2FsdGVkX18ksDPdMyVLCdpVEDcS6mzS4uCap1E9Ik9xbx7Tw4iS3EDWApRdY6l5rMIQ4OXYXEl18kgb48YSGz03ttxG6NwsTCZhBSegbL+8Dmzf3pGp7YSF9mti+2+SzRHJ+1gq7xBS1WOnjNYcjhmQbHtixcGjfyJ+V47gMf1Zrc9spy5mjm/hzxUMwzPKCYIMwd+hbtQsz6+fERqsXNvUDUhywKapDmWoJX8haXF0GQc0KqM48UBtJJg0wGbuOrF7D0u+NqjQ0SmRmi6NGDfBafuLjLmhrbPPIccVrPa9JDGG8GvT2qUcklxwI5CqMNF86Zix55oc7w6pyFU265zaekP5+x29yEOmSQh8MOmwjKD6KwzA7/zNUZ9+YlTa/Z1ydCCEK1xcvTwMul/db0bgYZjx3mdrdDdIJL6zW27WH0Brs9hmM8tuqfmyDzcit36O6vbtbMiLaoSFQSO9pwEIwfRfab+XxxCx+t1im0KOWS//EcByxjTs6QhDsUKmdGDLlinY0uzA2NkJktUNANTwctJ0pLvoPK36tIfMmDrBCeGS5DEQFogmjo0eMlVMoVnsmfBRDqJVq29J673SPHZW2qXS3iaCnBFkA5BSjMVkzpMEVrNplTe0rqTcHJl4Q4Kb7dQTRebCX2uGDtUJLQke0xFm49yWznxx+byZp307YLsdH63T7BVPhwpO0YGOMsJ22jahWPYblRFXf9MZYhfqR4oub6SbDW5ammG3A/j/xH1k0rYdCljtwIjALI0X+/tJKfGcqo1fp6YTkQM1m6VnnY1wGoo7jBja58DwIxAWBYCTqZQWP2uljyMUtykh/iQp5WU7RrBtQ5rgp+M6nF56RFLo1MfDxkICfuozAFYFph4GhVO/6t6n9dAXS+qs/U+hP3zimWcGASVxm6ru7TowSii4O6IesbzwyVPzZ8ZzLjZ//SSfjweOjKihFG0Cqa9Kaw86sRt2Gxnxsf2
 V6jDH1Z9
 N+jez2g9VOvDjtz1PYaVkDicpQgnqyeyq2rL+S/quqDyEFsoO5w2UaBidXLf7Whwoy5MKdoQI3Rx8keViohM73DSnDrxa9KRewxW7dXdYIP6WOcvwS80mnh2NPCD+cK3tlJMngM5GcuLMYSnO4tlguJRQ/eWFJbO72tpm+QA4bGx5PphEZpE1H3Zx0fJFS7gcuz2LlXLD39ZsiHv0Hi0/XviJHq4Chcmd3r6nj4NhB+VDlQqA/sOU4Ikb0hpwcGugbD21qP4WikMzczHYF8BTnvkufg33O03D9dX9NSLpAoxNCRWKdTnnPJwDHPFM8pGmh4ME5PfeSogq0vYjj5KOk4NRXvBlq0FbziaIsnL7Nt7ej2e+eIDabqL1Y+LRXSg4DXLWrpNMNdKQ/CXUhe1mgOIK9VgTNTbo/YKD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Summary:
Inside a tainted SPB, free pages of UNMOVABLE and RECLAIMABLE
allocations cannot be told apart by the buddy allocator's
compatibility heuristic (alike_pages == 0 between the two non-movable
types in try_to_claim_block). Once a pageblock holds in-use pages of
both, any sticky UNMOVABLE pinhole prevents the RECLAIMABLE pages
from coalescing into useful higher-order chunks when they drain back
to the buddy. The PB's free capacity is permanently capped at
order-1 dust regardless of how much of it actually returns. Sticky
recl pages (active dentries, locked btrfs eb folios, NOFS slab) are
unavoidable; the cost is paid in internal fragmentation.

Two paths in the page allocator create UNMOVABLE<->RECLAIMABLE
mixing today:

  1. try_to_claim_block() relabels a partial PB whenever the 50%
     threshold "free_pages + alike_pages >= pageblock_nr_pages/2"
     passes. For UNMOV<->RECL, alike_pages == 0, so the rule
     degenerates to free_pages >= 256. A PB with 256 in-use UNMOV
     pages plus 256 free pages passes and is relabeled RECL. Both
     PB_has_unmovable and PB_has_reclaimable are then set.

  2. __rmqueue_steal() takes a single foreign-type page out of a
     PB without relabeling the PB. A UNMOVABLE allocation stealing
     from a RECLAIMABLE-labeled PB sets PB_has_unmovable on top of
     the existing PB_has_reclaimable.

Tighten both paths:

  - Add noncompatible_cross_type() helper that detects the
    UNMOV<->RECL pair (MOVABLE may still mix with either since
    movable pages can be migrated out).

  - In try_to_claim_block(), require a fully-free PB
    (free_pages == pageblock_nr_pages) for any cross-type relabel,
    regardless of from_tainted_spb. The other-type bit inherited
    from the prior label is stale on a fully-free PB (no in-use
    pages of either type) so clear it during the relabel rather
    than leaving the PB visibly mixed in PB_has_* state.

  - In __rmqueue_steal(), pass a new SB_SKIP_CROSS_TYPE flag to
    __rmqueue_sb_find_fallback() so the cross-type fallback entry
    in fallbacks[] is skipped. Steal then falls through to the
    MIGRATE_MOVABLE second fallback instead of single-page-stealing
    into a foreign non-movable PB.

The from_tainted_spb=true caller of try_to_claim_block() is
unaffected because it hardcodes block_type=MIGRATE_MOVABLE. The
claim_whole_block() branch (current_order >= pageblock_order) is
also unaffected: it requires PB_all_free, so the PB is fully free
of any prior type.

Test Plan:
Bare-metal devvm with the existing 4 stuck tainted SPBs (sb[2,15,
36,51] in Normal). Build and reboot. Compare per-order free
distribution in newly tainted SPBs against pre-patch baseline:
today o0/o1 dominate, target meaningful (>10%) free at order >= 3
in pure-RECL SPBs created post-patch. Watch for tainted SPB count
growth past ~12 (3x current baseline) — the fully-free constraint
on cross-type claims will taint fresh SPBs more often, and a
runaway count means the cost was misjudged. Watch dmesg for
allocation failures and kswapd CPU stays under 2 cores. Existing
mixed SPBs from before this change won't unmix; the win is for
SPBs created after.

Reviewers:

Subscribers:

Tasks:

Tags:

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 111 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 85 insertions(+), 26 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 67cc8165ab1f..ceb1284a63ed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3057,6 +3057,23 @@ static int fallbacks[MIGRATE_PCPTYPES][MIGRATE_PCPTYPES - 1] = {
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE   },
 };
 
+/*
+ * UNMOVABLE and RECLAIMABLE allocations should not share the same
+ * pageblock. Their free pages are interchangeable on the buddy free
+ * lists (alike_pages == 0 between them), so once a PB holds both
+ * types the buddy can no longer tell them apart and any sticky
+ * UNMOVABLE pinhole prevents the RECLAIMABLE pages from coalescing
+ * into useful higher-order chunks when they drain back. MOVABLE may
+ * mix with either, since MOVABLE pages can be migrated out.
+ */
+static inline bool noncompatible_cross_type(int start_type, int fallback_type)
+{
+	return (start_type == MIGRATE_UNMOVABLE &&
+		fallback_type == MIGRATE_RECLAIMABLE) ||
+	       (start_type == MIGRATE_RECLAIMABLE &&
+		fallback_type == MIGRATE_UNMOVABLE);
+}
+
 #ifdef CONFIG_CMA
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
 					unsigned int order)
@@ -3434,6 +3451,9 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		   bool from_tainted_spb)
 {
 	int free_pages, movable_pages, alike_pages;
+#ifdef CONFIG_COMPACTION
+	struct superpageblock *sb;
+#endif
 	unsigned long start_pfn;
 
 	/*
@@ -3492,35 +3512,48 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * allocations. Inside a tainted SPB the protection is unnecessary:
 	 * fragmentation has already been accepted at the SPB level, and
 	 * relabeling is much cheaper than tainting a fresh clean SPB.
-	 */
-	if (from_tainted_spb ||
-	    free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
-			page_group_by_mobility_disabled) {
-		__move_freepages_block(zone, start_pfn, block_type, start_type);
-		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
-#ifdef CONFIG_COMPACTION
-		/*
-		 * Track actual page contents in pageblock flags and
-		 * update superpageblock counters so the SPB moves to
-		 * the correct fullness list for steering.
-		 */
-		{
-			struct page *start_page = pfn_to_page(start_pfn);
-			struct superpageblock *sb;
-
-			__spb_set_has_type(start_page, start_type);
-			if (block_type != start_type)
-				__spb_set_has_type(start_page, block_type);
+	 *
+	 * UNMOVABLE<->RECLAIMABLE cross-type claims override these rules:
+	 * once mixed, sticky pinholes of one type prevent the other from
+	 * coalescing into useful higher-order free chunks even after drain.
+	 * Only relabel a fully-free PB in that case, regardless of whether
+	 * the SPB is tainted.
+	 */
+	if (noncompatible_cross_type(start_type, block_type)) {
+		if (free_pages != pageblock_nr_pages)
+			return NULL;
+	} else if (!from_tainted_spb &&
+		   free_pages + alike_pages < (1 << (pageblock_order-1)) &&
+		   !page_group_by_mobility_disabled) {
+		return NULL;
+	}
 
-			sb = pfn_to_superpageblock(zone, start_pfn);
-			if (sb)
-				spb_update_list(sb);
-		}
-#endif
-		return __rmqueue_smallest(zone, order, start_type);
+	__move_freepages_block(zone, start_pfn, block_type, start_type);
+	set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
+#ifdef CONFIG_COMPACTION
+	/*
+	 * Track actual page contents in pageblock flags and update
+	 * superpageblock counters so the SPB moves to the correct
+	 * fullness list for steering.
+	 *
+	 * For cross-type UNMOVABLE<->RECLAIMABLE relabel (which by the
+	 * predicate above only fires on a fully-free PB), the inherited
+	 * PB_has_<block_type> bit is stale — there are no in-use pages
+	 * of that type. Clear it so the resulting PB is unmixed.
+	 */
+	__spb_set_has_type(pfn_to_page(start_pfn), start_type);
+	if (block_type != start_type) {
+		if (noncompatible_cross_type(start_type, block_type))
+			__spb_clear_has_type(pfn_to_page(start_pfn), block_type);
+		else
+			__spb_set_has_type(pfn_to_page(start_pfn), block_type);
 	}
 
-	return NULL;
+	sb = pfn_to_superpageblock(zone, start_pfn);
+	if (sb)
+		spb_update_list(sb);
+#endif
+	return __rmqueue_smallest(zone, order, start_type);
 }
 
 /*
@@ -3544,6 +3577,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 #define SB_SEARCH_EMPTY		(1 << 1)
 #define SB_SEARCH_FALLBACK	(1 << 2)
 #define SB_SEARCH_ALL		(SB_SEARCH_PREFERRED | SB_SEARCH_EMPTY | SB_SEARCH_FALLBACK)
+/*
+ * Skip UNMOVABLE<->RECLAIMABLE cross-type fallback. Used by the steal
+ * path to prevent landing single foreign-type pages into a PB labeled
+ * with the other non-movable type — a steal does not relabel the PB
+ * so cross-type stealing creates permanent mixing.
+ */
+#define SB_SKIP_CROSS_TYPE	(1 << 3)
 
 static struct page *
 __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
@@ -3580,6 +3620,10 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					int fmt = fallbacks[start_migratetype][i];
 					struct page *page;
 
+					if ((search_cats & SB_SKIP_CROSS_TYPE) &&
+					    noncompatible_cross_type(start_migratetype, fmt))
+						continue;
+
 					page = get_page_from_free_area(area,
 								       fmt);
 					if (page) {
@@ -3601,6 +3645,10 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 				int fmt = fallbacks[start_migratetype][i];
 				struct page *page;
 
+				if ((search_cats & SB_SKIP_CROSS_TYPE) &&
+				    noncompatible_cross_type(start_migratetype, fmt))
+					continue;
+
 				page = get_page_from_free_area(area,
 							       fmt);
 				if (page) {
@@ -3629,6 +3677,10 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					int fmt = fallbacks[start_migratetype][i];
 					struct page *page;
 
+					if ((search_cats & SB_SKIP_CROSS_TYPE) &&
+					    noncompatible_cross_type(start_migratetype, fmt))
+						continue;
+
 					page = get_page_from_free_area(area,
 								       fmt);
 					if (page) {
@@ -3765,11 +3817,18 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype,
 	/*
 	 * When ALLOC_NOFRAG_TAINTED_OK is set, only steal from tainted
 	 * SPBs to avoid tainting clean ones. Otherwise search all categories.
+	 *
+	 * Always skip UNMOVABLE<->RECLAIMABLE cross-type fallback. The steal
+	 * path takes a single page without relabeling its PB, so a cross-type
+	 * steal would land an UNMOVABLE page in a RECLAIMABLE-labeled PB
+	 * (or vice versa) and create permanent mixing. Falling through to
+	 * MIGRATE_MOVABLE (the second fallback) is preferable.
 	 */
 	if (alloc_flags & ALLOC_NOFRAG_TAINTED_OK)
 		search_cats = SB_SEARCH_PREFERRED;
 	else
 		search_cats = SB_SEARCH_PREFERRED | SB_SEARCH_FALLBACK;
+	search_cats |= SB_SKIP_CROSS_TYPE;
 
 	/*
 	 * Search per-superpageblock free lists for fallback migratetypes.
-- 
2.52.0


