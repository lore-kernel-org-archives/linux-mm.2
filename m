Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6761CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C616B00A9; Wed, 20 May 2026 11:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C986B00AA; Wed, 20 May 2026 11:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4176B00AB; Wed, 20 May 2026 11:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07DA56B00A9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBC44402F7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:53 +0000 (UTC)
X-FDA: 84788110386.06.D7FA026
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF56810000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=SfRF7MLY;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbmaVyF/aGay1UdLwoY7Lt8blnO3tO+P/LpIkjcJR/U=;
	b=w5s43m6N9RdHRaqqpS2i/GfwI1ysezyqSD7vVEmJ7Nvm0Q8cSJpWA27FUiFWhDtfRUKOn9
	D18BeZzUpWxkvx8jKGjR8gxPkJ0l2/va3PlsU8xfKspzQGvk1rzXOC46fUxxhF0g89rLaY
	K4krjOXGA1Vh/cINxD0YJuO0nEy+Rkw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=SfRF7MLY;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289251; a=rsa-sha256;
	cv=none;
	b=kdtS/UOdh+W7FpXiBGRr0eDKNfjJ2hkdSKp7lfTanCQ1Z7N3pQ10ZerpUrZMqS54P8Oh2G
	jI2Fr74K0slAcnRwPWDRqY8LDh4rbpcrILZr3Kf18Q+IG+jRBaRt1G22SRevqIw/mRy47n
	UMqdMUYuIY5YNnos6rtRI6UlDdncnSI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FbmaVyF/aGay1UdLwoY7Lt8blnO3tO+P/LpIkjcJR/U=; b=SfRF7MLYk9xj5qBGEvpHO0ldSU
	QQS3xxzy06qwE4Ajgkm4BCl84Q+axWwqlquuDIS5DL+K1lZGtcbkGyMCMhjAofxJe0QhYNk9jvxjK
	DtwclI6+uVf5qEtukidxaD8hgZpHkRi3ZSxz2zDUmxhL9AG+R9XqQ5auVkciIkCdFBwK/9FAr9A/4
	TwzdLjm9yzyNKSLNQapuGpJ/aAHAjIkK+dFV9MUzYu7GYGS6dEiNkD4+2tm3nJuSZvjMnYHOaRCQG
	uwi5qccxPGKPwXC7Uh+Xdvxd1GlA73SCYNjxtlHb8jcQwUBwFJf5Gv1crIN89PCMOUVzJp1gfOIvk
	p6rFBL7w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2y1s;
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
Subject: [RFC PATCH 24/40] mm: page_alloc: prevent UNMOVABLE/RECLAIMABLE mixing in pageblocks
Date: Wed, 20 May 2026 10:59:30 -0400
Message-ID: <20260520150018.2491267-25-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF56810000F
X-Rspamd-Server: rspam06
X-Stat-Signature: 1fzzhwxagbxeji94qzfrgqzqowj1ba9o
X-HE-Tag: 1779289251-277919
X-HE-Meta: U2FsdGVkX19JW1HYhBf6p7QHyb/fZ8wyDpUu6lGPW1NtdYHBvyb6EDT0IA1LZJ92i7043hExIh4Sg7JhgLz545pMcPiAvDNTvvtiEnck7Y/kLcHx9VQLjgL6Pwln8poBbPoADEkyFLDKUSrQxhK2hLSN1fhWvmEjzUTIzE+SJ5j49DaRTCAsf5QCorVuIaA1F1Ct1vNVxXcOYhZk6uaWQ6QQCVoHaXzXia+Wdt6zomMm9A/+ulJYuXg+OieyH3afg73mdkJCFeEZ6FSBU1tcOBiRMKx6S2xT5ypSOe0PkU/a59cfXTN3ZnA/iHgvNAkt9BfAHcMIwqtLb15msDa63i5FvgePJlojO8gKRpkXmgL2k4TQP2ryA8Rf8kRmVMFmurk7tf+QoCyf4kgWB7Bc6wdIzSKyUL92S3j/afG/lT6XoRA6phWsj77sWCsh7Vw5Vv81b7ZLtZx0iU8jg7GjiS0k0O+A9VMfdU7r+cjbSjDyev5ggm9GUkJWCWffGK3lZvimFiLuYh6ghBUYgaXakgKeFTrqULzGXEDDR41BAZQQEQREHM8GdC9EQS6C8sp7P4NhOABFHzTS92KL5uhdwCdGeqApIfocCwnH9udUnY/NelRqYGW6myCs85dJhLzlJmwfO/azi6r/N68jNpKJXXnhBlcpCXsVkaWo91kz9uiO2AuzCLKWVQzznJpgIrMC4ra2We8AFrpBHeuLkscA+uR38bBlsXtPAdlAq/HI9SK9KVTuqt4nvQKIdTxVC6Dk1/jsfbjHUvrrGg5PvPFub2duF2XaVew5DbVNCVADDSNJGiowxF/HeFwGTCszRkQxM1DhQgsuyPz25OEU1HQgl73TLkUSs9btaC8YvASvfCbv/BzdVPWwpw41p6wzF5jEBLV1u6RGzh1dFRYTRP52Z7pfQmx3zM/iAqqQWzbipbo+duj/QQIfEpBOKLhtE5J/5DlFcJj4Pguo+oadry2
 I8aqzisV
 3yYXuEFTb+RQDoUdLG3xrRDK6DuZBapgHoDfUfdc8fko9CPapYNOecXLTQp1xXqwvj1VOOK8OfcVYXxEVtXJYy7IjkUo+oqwNWgIyvUZxoMtnTKcoxw7pxeIgqv0LNfavUO7d2DNrg7BsQ5qchXLupxeQEzBpQwxbHH64cnFAsPrnbCLWjmtBD4TNyfyme5Pqkg8RImIbat0Cxfeev91vWaIzP5JwJ7uiakREPylWf2R5dDRmcL1gqx8opPnZ/KiDwKpxn1gy9pca65CLGbB0y5KjKXJCnDm3ddlNqFqAaU/SDROZR4FUJKNguPOHLduGi6q2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Existing mixed PBs from before this change won't unmix; the win
is for PBs created after.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 108 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 83 insertions(+), 25 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b4794ba7024f..988cf6f27938 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3073,6 +3073,23 @@ static int fallbacks[MIGRATE_PCPTYPES][MIGRATE_PCPTYPES - 1] = {
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
@@ -3450,11 +3467,10 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		   bool from_tainted_spb)
 {
 	int free_pages, movable_pages, alike_pages;
-	unsigned long start_pfn;
 #ifdef CONFIG_COMPACTION
-	struct page *start_page;
 	struct superpageblock *sb;
 #endif
+	unsigned long start_pfn;
 
 	/*
 	 * Don't steal from pageblocks that are isolated for
@@ -3512,32 +3528,48 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
-		start_page = pfn_to_page(start_pfn);
-		__spb_set_has_type(start_page, start_type);
-		if (block_type != start_type)
-			__spb_set_has_type(start_page, block_type);
-
-		sb = pfn_to_superpageblock(zone, start_pfn);
-		if (sb)
-			spb_update_list(sb);
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
+	 * PB_has_<block_type> bit is stale -- there are no in-use pages
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
@@ -3561,6 +3593,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 #define SB_SEARCH_EMPTY		(1 << 1)
 #define SB_SEARCH_FALLBACK	(1 << 2)
 #define SB_SEARCH_ALL		(SB_SEARCH_PREFERRED | SB_SEARCH_EMPTY | SB_SEARCH_FALLBACK)
+/*
+ * Skip UNMOVABLE<->RECLAIMABLE cross-type fallback. Used by the steal
+ * path to prevent landing single foreign-type pages into a PB labeled
+ * with the other non-movable type -- a steal does not relabel the PB
+ * so cross-type stealing creates permanent mixing.
+ */
+#define SB_SKIP_CROSS_TYPE	(1 << 3)
 
 static struct page *
 __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
@@ -3597,6 +3636,10 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					int fmt = fallbacks[start_migratetype][i];
 					struct page *page;
 
+					if ((search_cats & SB_SKIP_CROSS_TYPE) &&
+					    noncompatible_cross_type(start_migratetype, fmt))
+						continue;
+
 					page = get_page_from_free_area(area,
 								       fmt);
 					if (page) {
@@ -3618,6 +3661,10 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 				int fmt = fallbacks[start_migratetype][i];
 				struct page *page;
 
+				if ((search_cats & SB_SKIP_CROSS_TYPE) &&
+				    noncompatible_cross_type(start_migratetype, fmt))
+					continue;
+
 				page = get_page_from_free_area(area,
 							       fmt);
 				if (page) {
@@ -3646,6 +3693,10 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					int fmt = fallbacks[start_migratetype][i];
 					struct page *page;
 
+					if ((search_cats & SB_SKIP_CROSS_TYPE) &&
+					    noncompatible_cross_type(start_migratetype, fmt))
+						continue;
+
 					page = get_page_from_free_area(area,
 								       fmt);
 					if (page) {
@@ -3782,11 +3833,18 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype,
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
2.54.0


