Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67788CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4AE6B00B1; Wed, 20 May 2026 11:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982D76B00B2; Wed, 20 May 2026 11:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873E56B00B3; Wed, 20 May 2026 11:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE266B00B1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42D65C1865
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:59 +0000 (UTC)
X-FDA: 84788110638.13.D234618
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id 78AF720018
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ltbB5qd3;
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+pNIgKBYOMF9XTykE71T7SGn/qzSW7h0asRcRtULUM=;
	b=mb14WxtyIwm2W33rG/CgTzT5Hy5g2qT69deNnCXQfObIAdjLkyR1/LV11/bR+/WfZ3TEjG
	iCmJ73wEFz4J3BSIEw1brSjGcgd/MG/RUa40dCjk88fj1KUnBOF7cZcM5SKMgp5O+EdXsP
	pcHBd0GNLp6UiAXg9QoFNXjVBZevy+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289257; a=rsa-sha256;
	cv=none;
	b=8NhX9plbh5Vgq8b6vfjozBQlFFLRpvriR31ubY3z2fYM32kXRqx0SRGmlqPv0FtYBDw/RY
	3ot+/IV2YZUSR26H9KwkV3g2ix54ym4VDCy73aEXtF28agU6FdDRk3Fale13ckrMlQ1SqE
	6Keb+kmD1sfEkXAuC9gf45CgmWz0as0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ltbB5qd3;
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s+pNIgKBYOMF9XTykE71T7SGn/qzSW7h0asRcRtULUM=; b=ltbB5qd3Y5BdyzT1CztNk42OiQ
	y0urApjVkoRnFEpKAihu/PvTiKTtJjd3Yn4inEq83JzsVoy6n11JXOYFPM9CAtbszQb6NwAf2yYWw
	G88/7FcLQmhKyW1tSVYWlk8f4y543H3WOxeUMuapVI0+RCQYH5JOdg3icge57MPy7kq/PYGa+85qA
	2daw2m7KhirjMPySTP/R+YmvEE/NkNVnELa5IPRbQ8W923JQAO5rCaWcvueQUyH0Od6HVyWc1IO53
	tL0LLR//a7eZcIUk9T7x4izq5VPqUtwHrzCVyTeZPf27iQOUCNlKh6XYvkDRcolISEDCzMuXjq9fz
	KtYppxqg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2oiO;
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
Subject: [RFC PATCH 23/40] mm: page_alloc: targeted evacuation and dynamic reserves for tainted SPBs
Date: Wed, 20 May 2026 10:59:29 -0400
Message-ID: <20260520150018.2491267-24-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 78AF720018
X-Rspam-User: 
X-Stat-Signature: 7g5oqqucccihs3toebob939zfjyno3fx
X-HE-Tag: 1779289257-938604
X-HE-Meta: U2FsdGVkX1/DoKi1GVhUV0xjAni+xDHE/bAg1ETcuqiMOQVkgcSEDBaY7QqNA/h/wRsLI9g6iQbuCQJLVy2UEEtehVj0cbQ/y7CBpV0bNqlpiJPyPwMGyRYp+sKHrIeoYmTA8RGZjM9m58hFZzW8lzVKalHMaYROutAUq6mGOP+QiRceCR9EOon49kWh9A+HUdtRVpSRvMZGywiCsINGULV02jq+30V/fsoTVqjOrMAwvWH33gK8U5mRidZoAkAO/lKBCzDlKphQJ9l8pyuC5ZHiE4V8H0uPF2j5FKBafi91e1N4y2NiWm0T3fLpWmuEgsTrMKTJZsj96a0DeXpX8JZN3x05qdqIPOzGkf/IOT2OWjSK7x+2o2W1waW5d9xawfZsGFPC/RVYjCrM0vcgg0N2oQP1alGFM30TEoCRD6vex4FPoPI5G1aBZ7ZzNMuvxVamYQgRIIbE0lFrEFWj7Xp3hsu9e3OSrv60rKLzS6VhGDdmVEqi2zFYU7kLy/nYLlKQxpwWQtNUAKebDUVup3ILwwMdWgivJUJdXylYzTpTX6h4nAYyjeEZ8fMidbGY5l8ez8eWQv78hvyGkyKPYYHprFDBDD8Pk4Ey6FGm8VXljYfr3xmQ7wSZCm/IiciKgy/fkfkIYuvU1ztvDGc1XJrsD8sl7KO5hFgzdf0I4HM+8ACbdBfqg+UjBSx46lHbX2v84yuZKaFgqdvTRAateB1zvQRC9eefg6DklM7+qCqFcptC03dr79rH79kBchU0584KOg3txN6lum37nc5Ilt4dr0PYw7BRgEgcRfY7Bwr3DwaUVdCxV2oEXtq4qH4liXNNyKlNXzwnKZTZwibojmS+fAVCuNMaLgCdKTw4Vfbk3xKaOEr2JfT84WJ2bGsJjbkb8bInIbuHEw68CQHp6dDVPV5BphEKqtZHVxMnvCvdPD7ZAz3UjfSpcbMsAlxuVjfm3We5lz6sJqNSjJV
 72TqHsJ9
 uqGYGylZYvhYWU3WZY9VJT/VxXmUjxwv+/ElaOl1c1EVZEVWmqAbVAMC21cMvemeC39TVB6hQvVDlHFGTy4ETz8NSrva0EUcDmaReB41OT0BtMhk/RwobYZgR5n985y24oIKMYxMU8GVHnYuju11qe2yRg/Cbp0sCSCOdeOiOkz5ZYwziDSzDVuHqASnocdhEw4iJnQbmfAEu+b0JMWcFpPMfe2ML/HiOYgGFC2IV+ENtvzRSLXwzPX5un6zg6zmpAfg5v89QaMt/nfM4TusYBQNIZOSlUOO/sPqdrgiOuEsMv7M8xFKBRbNZGMVww0Zz9MOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reduce tainted-superpageblock proliferation with three changes:

1. Dynamic SPB_TAINTED_RESERVE.  Scale the movable-steering reserve
   with SPB size (~3% of pageblocks, minimum 4).  For a
   512-pageblock SPB this gives 16 reserved pageblocks instead of
   the previous flat 4, triggering async defrag 4x earlier and
   keeping more headroom for unmovable claims.

2. Targeted evacuation before NOFRAGMENT drop.  When the slowpath
   is about to drop ALLOC_NOFRAGMENT for an unmovable/reclaimable
   allocation, first try evacuating movable pages from tainted
   SPBs so the retry can satisfy via Pass 2 (claim_whole_block)
   without forcing __rmqueue_claim to taint a clean SPB.

3. Single-pass evacuation with a relaxed source-PB filter, sized
   for the slowpath.

Stack impact: sb_pfns[] grows from 32 bytes to 128 bytes -- trivial
for an 8K/16K kernel stack.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 334 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 219 insertions(+), 115 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e267390a5948..b4794ba7024f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2691,8 +2691,16 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
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
@@ -3005,7 +3013,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				 * with few free pageblocks to reserve space
 				 * for future unmovable/reclaimable claims.
 				 */
-				if (sb->nr_free <= SPB_TAINTED_RESERVE)
+				if (sb->nr_free <= spb_tainted_reserve(sb))
 					continue;
 				for (current_order = order;
 				     current_order < NR_PAGE_ORDERS;
@@ -3582,7 +3590,7 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					&sb->free_area[order];
 
 				if (movable && cat == SB_TAINTED &&
-				    sb->nr_free <= SPB_TAINTED_RESERVE)
+				    sb->nr_free <= spb_tainted_reserve(sb))
 					continue;
 
 				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
@@ -3631,7 +3639,7 @@ __rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
 					&sb->free_area[order];
 
 				if (movable && cat == SB_TAINTED &&
-				    sb->nr_free <= SPB_TAINTED_RESERVE)
+				    sb->nr_free <= spb_tainted_reserve(sb))
 					continue;
 
 				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
@@ -6744,9 +6752,33 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
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
@@ -8819,7 +8851,7 @@ static bool spb_needs_defrag(struct superpageblock *sb)
 	 */
 	if (spb_get_category(sb) == SB_TAINTED)
 		return sb->nr_movable > 0 &&
-		       sb->nr_free < SPB_TAINTED_RESERVE;
+		       sb->nr_free < spb_tainted_reserve(sb);
 
 	/* Clean SPBs: kcompactd handles consolidation; nothing to do here. */
 	return false;
@@ -8841,7 +8873,7 @@ static bool spb_defrag_done(struct superpageblock *sb)
 	 */
 	if (spb_get_category(sb) == SB_TAINTED)
 		return !sb->nr_movable ||
-		       sb->nr_free >= SPB_TAINTED_RESERVE;
+		       sb->nr_free >= spb_tainted_reserve(sb);
 
 	/* Clean SPBs should not be handled here. */
 	return true;
@@ -9077,6 +9109,184 @@ void init_superpageblock_defrag(struct superpageblock *sb)
 	INIT_WORK(&sb->defrag_work, spb_defrag_work_fn);
 	init_irq_work(&sb->defrag_irq_work, spb_defrag_irq_work_fn);
 }
+
+/*
+ * Maximum tainted superpageblock candidates per spb_evacuate_for_order call.
+ * Collected under zone->lock, then evacuated without it. Larger than the
+ * contig-allocation candidate cap because evacuation runs from the slowpath
+ * after reclaim/compaction failed: we need a meaningful chance of freeing a
+ * non-MOV-claimable pageblock before the slowpath escalates to dropping
+ * ALLOC_NOFRAGMENT (which lets __rmqueue_claim taint clean SPBs). Sized to
+ * scan a meaningful fraction of a typical tainted-pool population.
+ */
+#define SPB_EVACUATE_MAX_CANDIDATES 16
+
+/*
+ * Maximum pageblocks to evacuate per candidate SPB inside
+ * spb_evacuate_for_order. Each evacuation triggers page migration which is
+ * O(pages_per_pageblock) wall-clock cost, so this caps per-call latency.
+ * Bumped from 3 to 8 to free more capacity per slowpath escalation pass.
+ * Combined cap: SPB_EVACUATE_MAX_CANDIDATES * SPB_EVACUATE_MAX_PB_PER_SB
+ * pageblocks per call (16 * 8 = 128 = 256 MiB on x86 max migration budget).
+ */
+#define SPB_EVACUATE_MAX_PB_PER_SB 8
+
+/**
+ * sb_collect_evacuate_candidates - Find tainted SPBs for targeted evacuation
+ * @zone: zone to search (must hold zone->lock)
+ * @sb_pfns: output array of tainted superpageblock start PFNs
+ * @max: maximum candidates to collect
+ *
+ * Walk the per-zone tainted SPB lists and collect the start PFNs of
+ * superpageblocks that still hold movable pages, up to @max entries.
+ * The caller (spb_evacuate_for_order) drops zone->lock before actually
+ * evacuating each candidate.
+ *
+ * Returns number of candidate superpageblock PFNs found.
+ */
+static int sb_collect_evacuate_candidates(struct zone *zone,
+					  unsigned long *sb_pfns, int max)
+{
+	struct superpageblock *sb;
+	int full, n = 0;
+
+	lockdep_assert_held(&zone->lock);
+
+	for (full = 0; full < __NR_SB_FULLNESS; full++) {
+		list_for_each_entry(sb, &zone->spb_lists[SB_TAINTED][full],
+				    list) {
+			if (!sb->nr_movable)
+				continue;
+
+			sb_pfns[n++] = sb->start_pfn;
+			if (n >= max)
+				return n;
+		}
+	}
+	return n;
+}
+
+/*
+ * Evacuate MOV content out of any pageblock in the given range that has it.
+ *
+ * The previous version filtered on the source pageblock's migratetype tag,
+ * which made evacuation blind to MOV stragglers living in PBs whose tag did
+ * not match the current allocation's requesting type:
+ *
+ *   - PASS_2C / PASS_2D borrows set PB_has_<requesting_mt> on a MOV-tagged
+ *     PB without changing the tag. The borrowed pages return to the MOV
+ *     free list when freed, so a MOV-tagged PB can host non-MOV PB_has bits
+ *     and MOV content simultaneously.
+ *
+ *   - When __spb_set_has_type adds a non-MOV bit on a PB, the PB tag is not
+ *     re-evaluated. PBs accumulate has-bits over time without their tag
+ *     necessarily reflecting current content.
+ *
+ * Drop the migratetype tag filter and accept any PB with PB_has_movable set.
+ * Skip only the cases whose semantics forbid touching them here:
+ *   - MIGRATE_ISOLATE     under quarantine
+ *   - CMA                 own allocator
+ *   - MIGRATE_HIGHATOMIC  reserve, evac would race the reservation logic
+ *
+ * Returns number of pageblocks evacuated.
+ */
+static int evacuate_pb_range(struct zone *zone, unsigned long start_pfn,
+			     unsigned long end_pfn, int max)
+{
+	unsigned long pfn;
+	int nr_evacuated = 0;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+		int pb_mt;
+
+		if (!pfn_valid(pfn))
+			continue;
+
+		if (!zone_spans_pfn(zone, pfn))
+			continue;
+
+		page = pfn_to_page(pfn);
+
+		if (!get_pfnblock_bit(page, pfn, PB_has_movable))
+			continue;
+
+		pb_mt = get_pfnblock_migratetype(page, pfn);
+		if (is_migrate_isolate(pb_mt) ||
+		    is_migrate_cma(pb_mt) ||
+		    pb_mt == MIGRATE_HIGHATOMIC)
+			continue;
+
+		evacuate_pageblock(zone, pfn, true);
+		if (++nr_evacuated >= max)
+			break;
+	}
+	return nr_evacuated;
+}
+
+/**
+ * spb_evacuate_for_order - Targeted evacuation of movable pages from
+ *                         tainted superpageblocks
+ * @zone: zone to work on
+ * @order: allocation order that failed
+ * @migratetype: requesting migratetype (informational; the evacuation
+ *               loop itself is migratetype-independent)
+ *
+ * Collect tainted superpageblocks with movable content under zone->lock,
+ * then drop the lock and walk each candidate's pageblocks, evacuating
+ * any PB that has PB_has_movable set and does not have a special tag
+ * (ISOLATE, CMA, HIGHATOMIC). PBs that are pure MOV become empty whole
+ * pageblocks for Pass 2 / claim_whole_block on retry; mixed PBs lose
+ * their MOV stragglers so future allocations of the dominant type stop
+ * competing with MOV residue.
+ *
+ * Returns true if evacuation was performed (caller should retry allocation).
+ */
+static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
+				  int migratetype)
+{
+	unsigned long sb_pfns[SPB_EVACUATE_MAX_CANDIDATES];
+	unsigned long flags;
+	int nr_sbs, i;
+	unsigned int attempts = 0;
+	bool did_evacuate = false;
+
+	/*
+	 * Single-pass evacuation: collect candidate tainted SPBs (anything
+	 * with MOV content), then walk each one's pageblocks evacuating MOV
+	 * content from any non-special PB. evacuate_pb_range filters by
+	 * PB_has_movable, so this is a no-op on PBs that have no MOV content.
+	 *
+	 * Two effects accumulate:
+	 *   - PBs that are pure MOV become empty -> free MOV pageblock,
+	 *     claimable by Pass 2 / claim_whole_block on the retry.
+	 *   - PBs that are mixed (e.g., UNMOV + MOV stragglers) lose the MOV
+	 *     stragglers, so future allocations of the dominant type can use
+	 *     the PB without competing with the MOV residue.
+	 *
+	 * The previous two-phase design tried to do these separately and
+	 * filtered evacuation by source PB tag. That left MOV content
+	 * stranded in PBs whose tag did not match either phase, and gave up
+	 * after one phase even though the other phase could have helped.
+	 */
+	spin_lock_irqsave(&zone->lock, flags);
+	nr_sbs = sb_collect_evacuate_candidates(zone, sb_pfns,
+						SPB_EVACUATE_MAX_CANDIDATES);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	for (i = 0; i < nr_sbs; i++) {
+		unsigned long end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
+		int n;
+
+		n = evacuate_pb_range(zone, sb_pfns[i], end_pfn,
+				      SPB_EVACUATE_MAX_PB_PER_SB);
+		attempts += n;
+		if (n)
+			did_evacuate = true;
+	}
+
+	return did_evacuate;
+}
 #endif /* CONFIG_COMPACTION */
 
 #ifdef CONFIG_CONTIG_ALLOC
@@ -9655,112 +9865,6 @@ static struct page *spb_try_alloc_contig(struct zone *zone,
 	return NULL;
 }
 
-/**
- * sb_collect_evacuate_candidates - Find pageblocks for targeted evacuation
- * @zone: zone to search (must hold zone->lock)
- * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE)
- * @sb_pfns: output array of tainted superpageblock start PFNs
- * @max: maximum candidates to collect
- *
- * Find tainted superpageblocks containing pageblocks of the desired migratetype
- * that also have movable pages to evacuate. Evacuating movable pages from
- * these pageblocks creates buddy coalescing opportunities for high-order
- * allocations of the desired migratetype.
- *
- * Returns number of candidate superpageblock PFNs found.
- */
-static int sb_collect_evacuate_candidates(struct zone *zone, int migratetype,
-					  unsigned long *sb_pfns, int max)
-{
-	struct superpageblock *sb;
-	int full, n = 0;
-
-	lockdep_assert_held(&zone->lock);
-
-	for (full = 0; full < __NR_SB_FULLNESS; full++) {
-		list_for_each_entry(sb, &zone->spb_lists[SB_TAINTED][full],
-				    list) {
-			bool has_matching;
-
-			if (!sb->nr_movable)
-				continue;
-
-			if (migratetype == MIGRATE_UNMOVABLE)
-				has_matching = sb->nr_unmovable > 0;
-			else if (migratetype == MIGRATE_RECLAIMABLE)
-				has_matching = sb->nr_reclaimable > 0;
-			else
-				continue;
-
-			if (!has_matching)
-				continue;
-
-			sb_pfns[n++] = sb->start_pfn;
-			if (n >= max)
-				return n;
-		}
-	}
-	return n;
-}
-
-/**
- * spb_evacuate_for_order - Targeted evacuation of movable pages from
- *                         unmovable/reclaimable pageblocks
- * @zone: zone to work on
- * @order: allocation order that failed
- * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE)
- *
- * Instead of blind compaction, use superpageblock metadata to find pageblocks
- * of the right migratetype in tainted superpageblocks and evacuate their
- * movable pages. This creates buddy coalescing opportunities within
- * the pageblock, enabling higher-order allocations.
- *
- * Returns true if evacuation was performed (caller should retry allocation).
- */
-static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
-				  int migratetype)
-{
-	unsigned long sb_pfns[SPB_CONTIG_MAX_CANDIDATES];
-	unsigned long flags;
-	int nr_sbs, i;
-	bool did_evacuate = false;
-
-	spin_lock_irqsave(&zone->lock, flags);
-	nr_sbs = sb_collect_evacuate_candidates(zone, migratetype,
-						sb_pfns,
-						SPB_CONTIG_MAX_CANDIDATES);
-	spin_unlock_irqrestore(&zone->lock, flags);
-
-	for (i = 0; i < nr_sbs && !did_evacuate; i++) {
-		unsigned long pfn, end_pfn;
-
-		end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
-		for (pfn = sb_pfns[i]; pfn < end_pfn;
-		     pfn += pageblock_nr_pages) {
-			struct page *page;
-
-			if (!pfn_valid(pfn))
-				continue;
-
-			/* Superpageblocks can straddle zone boundaries. */
-			if (!zone_spans_pfn(zone, pfn))
-				continue;
-
-			page = pfn_to_page(pfn);
-
-			if (get_pfnblock_migratetype(page, pfn) != migratetype)
-				continue;
-
-			if (!get_pfnblock_bit(page, pfn, PB_has_movable))
-				continue;
-
-			evacuate_pageblock(zone, pfn, true);
-			did_evacuate = true;
-			break;
-		}
-	}
-	return did_evacuate;
-}
 #endif /* CONFIG_COMPACTION */
 
 /**
-- 
2.54.0


