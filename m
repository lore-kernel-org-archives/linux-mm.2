Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C342CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2996B00AE; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BA66B00AB; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E216B00AE; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A12A6B00AA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BBE41C0559
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
X-FDA: 84716346414.01.10AC2E9
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id BEE6D1C0012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jDGv2Jkl;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+wya874kPYOQCuKyoHaIAZiAttEr8zwW2uypklBYts=;
	b=4nxffsZJcGcXz29yq1wrNprjm8IUk2ggds7FxW9yA7Sfmm33tbFn+c3bNbjOYnMOkUMre2
	v2pBNLANlFmRcxCVnkaNTr8Re12U4IB1R5lUw3PHnXEFpuo1KH8F2CgvH3+bKuhHqTa+Gu
	jR4dR0NKSJEWjx7M88FZ96rk8xszzIE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jDGv2Jkl;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580585; a=rsa-sha256;
	cv=none;
	b=aEiHPJlwIIc9M02b/kKDRcQ6e7e5ZAGeY9RcX/nHwph/sXGaT/QCHCeoZxNTFp89/6tXki
	soogGEu31uxYhwVfSaZRGvUMXcGrc0ejG2ORHSrvCcZULZZWUnxo8M7j4ugReg23lU0mcx
	YyZiYU6KN+wphjli8pK+R9X0/HEZVn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1+wya874kPYOQCuKyoHaIAZiAttEr8zwW2uypklBYts=; b=jDGv2JklOdsjUJtX9FqfdNw40x
	EdFO6ZT0PbY9GrQncG0/Ofe8jZljL8TkI2kXK07EG8Vy5mU6yTcdzYqWN88eAvVQ1RraaPvVk4Jkq
	v6JnkKlXahuGwF4Nj+mtgyjn0O6Skq2qpd6rxrHklKmF4yx+En9jGg6Te/eifNkxgq/G3QW4Yzbcq
	JdKdUan04cX/CItXoaw5oVj7e6ETWlnbAP77/NRMUlFg8IwTa8a3mx/00Zip+/KBbUiv/y/HoPcM2
	O9hBCeYwwdys9a4NEWrZ0M6uaKsg+3zsCXhJVY0yK/5+hzfFMNjl6/Ix3QavdjoOhGzmjvzHILyZR
	i+3hKBSw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1h4c;
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
Subject: [RFC PATCH 38/45] mm: page_alloc: per-(zone, order, mt) PASS_1 hint cache
Date: Thu, 30 Apr 2026 16:21:07 -0400
Message-ID: <20260430202233.111010-39-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BEE6D1C0012
X-Rspamd-Server: rspam06
X-Stat-Signature: ci3e4oy711r7gsdbgffqhizr43iaynxn
X-HE-Tag: 1777580585-389816
X-HE-Meta: U2FsdGVkX18ujYORuuAzJDZPzUqOZKyCUqpPa0Nr7Awvgnd7faKkEbUvwugjgQ9ygMmliEff0aeX2TnwDtTqi2Cpp5gTd9AXobelP01CtqlqLee7oByLnTFGa0VteneVk47HSWRSBxt4IB7c0MIlXxheLh9Viy53Mh6o/XyecQl00T1mhrJM/F2XmofpzuVGtvDGWK4UI6mI5RTNqiNfx9iBr1lXoACYfm8bsn5RbiK2rRgAVIuynz0bVU5vF8qw5/uqM2/u/KpH/z0simlRzkXlBiTlBn78CgzWKPESi2JCVo6KOf9Z8S9UsFLu9P1RKCWiKFUNJMzCUr7HLB6xKaPBL+x0lTTSdP/j1dIFBWH2ZH94kn3t3Q0wYNyJhZAEorBV6hwxYspyPVO8w2uSfa28THBU0JAkNad0baXGAd8Id9tO+Y4sRzfg3LeYa6B4z+F5g9qTuGwve4L3DQU+Bv6qkCfVdAyLOOoKrcDAhSsIV7IH1ZeghmoU46pPEOQ/psbAqVi3/Qm82ViwUCVs59UUP8rLCPLVAz0933Gkhk2/DNZupi7V+713nzRfqQMLDK7P6+ezb8klh4nHBDvgrKQoIoCss2yuSoWhUZ2Wa0ymC/UhPNa94nMp5MxYlzODgFThA8Zuu0kGweEHZsPR7iePX1pKkM/S0wXpD2Vpjf9BLfZBSa/QUW1GYmBVipsIawwYxVccP7iqx0sdPnptqiOzQ8+FNi8yWigAHuJix3C4W9cEJg+MmLV4Oo4aBwBlod4fueNRyCUyZfA1SBjbwTBVI5J0LKv50S6+EHGzHMFIJ0MrAfREwtd6Gxas54FdTG4m++6+GtB/652EyHOgS+j4MAN2V7v8HkYgguhaS0JfqKQ9C5IhyoxuE5yBlXe/uaHoBViyuPr1mjuCA/VXQaap5mDFI+wT9vLb7mw7cE6LxZ7V100kw9NuwsBk1b/2k6fSev3gt6m9ZlnxxzN
 jD4x04Vr
 8ytUDW/S4ou7agFIsSVX30Mg9+DnyySPVLPzfHTKOvQtcqb0ua9JBKHkkHaGAQMSkn0/3ahEioNGAqv0/+JjE1k9Mi8ncXpDTJgJpX30IZAxqKURibFgj5LuE4LEFc9KdWBBpxgcBWPDTkogvCzW6zTVXDxj7reBjRqFwuJZx+QU8rDcdoBeSR5NTloq5RfxQMWGb22cbfHGboLYBQrdKUHLskw8FQaZ40/w9igyPJPpj5eYE4fTg4A7SwPoFxpAct8bHW8/gyLew2MX78+2lBNKjKCvS+6kYcwy3Tehih5vQPV5sI8ZrgRRsGC4xaA6fFcW7u45lmSVwhP2NiF+kxMEaAmcfYq0YtYymFLr07rVRQZi2EJVLEwea8UcAdsbcO5bf9Y4frl6ty0DPh2KRCkBkLNpdK5lcthBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

PASS_1 of __rmqueue_smallest walks &zone->spb_lists[cat][full]
linearly. Under steady workload on a 247 GB devvm, the median walk
depth was ~50 SPBs and 20-57% of allocations visited 100+ SPBs.

Cache the SPB that last satisfied a PASS_1 alloc for each
(zone, order, migratetype) tuple, in two layers:

  - per-zone hint (zone->sb_hint[order][mt]) — visible to all CPUs,
    serialized by zone->lock.
  - per-CPU hint indexed by zone_idx — cache-hot, contention-free.
    Each slot stores (zone *, sb *) because zone_idx is per-pgdat
    (not globally unique on NUMA); the zone-pointer check on read
    prevents a cross-node SPB from being handed back to the wrong
    zone's accounting.

Stale hints are harmless: try_alloc_from_sb_pass1() returns NULL and
the standard list walk runs as before. On PASS_1 success both hints
are refreshed. spb_invalidate_warm_hints() clears both arrays from
resize_zone_superpageblocks() under zone->lock to prevent UAF across
memory hotplug-add.

Hint hits show up in tracepoint:kmem:spb_alloc_walk as the [0, 5)
bucket because n_spbs_visited stays 0; no new tracepoint needed.
Skipped for migratetype >= MIGRATE_PCPTYPES (HIGHATOMIC/CMA/ISOLATE
are already cheap or rare).

Measurement on the same devvm with this commit applied:

  median walk depth:        ~50 SPBs   ->   ~5
  tail (>=100 SPB visits):  20-57%     ->   0.4%
  hint hit rate (n=0):                 ->   99%

Memory cost: ~320 B per zone + ~2.6 KB per CPU
(MAX_NR_ZONES * NR_PAGE_ORDERS * MIGRATE_PCPTYPES * sizeof(slot)).

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  11 +++
 mm/internal.h          |   2 +
 mm/mm_init.c           |   8 ++
 mm/page_alloc.c        | 180 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 201 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68892e40cd4e..298cff01160c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1014,6 +1014,17 @@ struct zone {
 	struct list_head	spb_isolated;	/* fully isolated (1GB contig alloc) */
 	struct list_head	spb_lists[__NR_SB_CATEGORIES][__NR_SB_FULLNESS];
 
+	/*
+	 * Stage 5 PASS_1 fast-path hint: most-recent SPB that satisfied a
+	 * (order, mt) PASS_1 allocation. Stale hints are harmless — the hint
+	 * try-alloc just falls through to the standard list walk on miss.
+	 * Sized for [0..NR_PAGE_ORDERS) x PCPTYPES; HIGHATOMIC/CMA/ISOLATE
+	 * skip the hint (already cheap or rare). Invalidated by
+	 * spb_invalidate_warm_hints() when the SPB array is resized
+	 * (memory hotplug add).
+	 */
+	struct superpageblock	*sb_hint[NR_PAGE_ORDERS][MIGRATE_PCPTYPES];
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
diff --git a/mm/internal.h b/mm/internal.h
index 71e39414645f..c84d7acb9342 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1041,6 +1041,8 @@ static inline void superpageblock_set_has_movable(struct zone *zone,
 void resize_zone_superpageblocks(struct zone *zone);
 #endif
 
+void spb_invalidate_warm_hints(struct zone *zone);
+
 struct cma;
 
 #ifdef CONFIG_CMA
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 8e3c64d37254..3a57cc4f3b48 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1810,6 +1810,14 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	zone->superpageblock_base_pfn = new_sb_base;
 	zone->spb_kvmalloced = true;
 
+	/*
+	 * Invalidate Stage 5 PASS_1 hints under zone->lock so that no
+	 * concurrent allocator (also entering __rmqueue_smallest under
+	 * zone->lock) can dereference an old SPB pointer that is about
+	 * to be freed below.
+	 */
+	spb_invalidate_warm_hints(zone);
+
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d621e84bf664..2f5d3ba1c0ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2814,6 +2814,110 @@ struct spb_tainted_walk {
 	bool saw_below_reserve;	/* tainted SPB has nr_free <= spb_tainted_reserve */
 };
 
+/*
+ * Stage 5 PASS_1 fast-path hint: most-recent SPB this CPU successfully
+ * allocated from for a given (zone, order, migratetype). Combined with
+ * the per-zone zone->sb_hint[][], this lets PASS_1 skip the linear walk
+ * of spb_lists[cat][full] in the common case (~78 SPBs visited per
+ * order-0 MOVABLE alloc on the build-403 baseline). Stale hints are
+ * harmless — the try-alloc just falls through to the standard list walk
+ * on miss.
+ *
+ * The slot stores both the zone pointer and the SPB pointer because
+ * zone_idx(zone) is per-pgdat (not globally unique on NUMA), so two
+ * nodes' ZONE_NORMAL share the same array index. The zone-pointer check
+ * on read prevents a cross-node SPB from being handed back to the wrong
+ * zone (which would corrupt per-zone NR_FREE_PAGES accounting).
+ */
+struct spb_warm_hint_slot {
+	struct zone		*zone;
+	struct superpageblock	*sb;
+};
+struct spb_warm_hints {
+	struct spb_warm_hint_slot slot[MAX_NR_ZONES][NR_PAGE_ORDERS][MIGRATE_PCPTYPES];
+};
+static DEFINE_PER_CPU(struct spb_warm_hints, spb_warm_hints);
+
+/**
+ * spb_invalidate_warm_hints - drop all cached hints into @zone
+ * @zone: zone whose SPB array is about to change
+ *
+ * Called from memory hotplug paths that resize zone->superpageblocks
+ * (and therefore invalidate every SPB pointer for @zone). Must be
+ * called with zone->lock held; the lock serializes against any CPU
+ * doing a hint read inside __rmqueue_smallest (also under zone->lock),
+ * so callers see either pre-invalidation state (old SPB pointers,
+ * still-valid old array) or post-invalidation state (NULL slots) —
+ * never a half-state with stale pointers into a freed array.
+ */
+void spb_invalidate_warm_hints(struct zone *zone)
+{
+	enum zone_type zidx = zone_idx(zone);
+	int cpu, order, mt;
+
+	lockdep_assert_held(&zone->lock);
+
+	memset(zone->sb_hint, 0, sizeof(zone->sb_hint));
+
+	for_each_possible_cpu(cpu) {
+		struct spb_warm_hints *h = per_cpu_ptr(&spb_warm_hints, cpu);
+
+		for (order = 0; order < NR_PAGE_ORDERS; order++) {
+			for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+				if (h->slot[zidx][order][mt].zone != zone)
+					continue;
+				h->slot[zidx][order][mt].zone = NULL;
+				h->slot[zidx][order][mt].sb = NULL;
+			}
+		}
+	}
+}
+
+/*
+ * Try to allocate from a single SPB using PASS_1 semantics:
+ * whole pageblock first (PCP-buddy friendly), then sub-pageblock.
+ * Returns the page on success, NULL on miss. Caller is responsible
+ * for tracepoints, hint updates, and shrinker queueing.
+ */
+static struct page *try_alloc_from_sb_pass1(struct zone *zone,
+					    struct superpageblock *sb,
+					    unsigned int order,
+					    int migratetype)
+{
+	unsigned int current_order;
+	struct free_area *area;
+	struct page *page;
+
+	if (!sb->nr_free_pages)
+		return NULL;
+
+	for (current_order = max(order, pageblock_order);
+	     current_order < NR_PAGE_ORDERS;
+	     ++current_order) {
+		area = &sb->free_area[current_order];
+		page = get_page_from_free_area(area, migratetype);
+		if (!page)
+			continue;
+		page_del_and_expand(zone, page, order,
+				    current_order, migratetype);
+		return page;
+	}
+	if (order < pageblock_order) {
+		for (current_order = order;
+		     current_order < pageblock_order;
+		     ++current_order) {
+			area = &sb->free_area[current_order];
+			page = get_page_from_free_area(area, migratetype);
+			if (!page)
+				continue;
+			page_del_and_expand(zone, page, order,
+					    current_order, migratetype);
+			return page;
+		}
+	}
+	return NULL;
+}
+
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				int migratetype, unsigned int alloc_flags,
@@ -2836,6 +2940,64 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	};
 	int movable = (migratetype == MIGRATE_MOVABLE) ? 1 : 0;
 
+	/*
+	 * Stage 5 PASS_1 fast-path: try per-CPU then per-zone hint SPB
+	 * before the linear list walk. The hint stores the SPB that last
+	 * satisfied a PASS_1 alloc for this (zone, order, migratetype).
+	 * On hit, we skip the entire spb_lists walk (n_spbs_visited stays
+	 * 0, which shows up as the [0,5) bucket in the spb_alloc_walk
+	 * tracepoint histogram). Skip for HIGHATOMIC/CMA/ISOLATE — those
+	 * paths are already cheap (atomic-NORETRY skip) or rare.
+	 */
+	if (migratetype < MIGRATE_PCPTYPES) {
+		enum zone_type zidx = zone_idx(zone);
+		struct superpageblock *cpu_hint = NULL, *zone_hint;
+		struct spb_warm_hint_slot *slot;
+
+		slot = this_cpu_ptr(
+			&spb_warm_hints.slot[zidx][order][migratetype]);
+		/*
+		 * Validate slot->zone == zone: zone_idx is per-pgdat, so
+		 * on NUMA the same slot index is shared by every node's
+		 * zone of this type. Without this check, a hint written
+		 * from one node would be returned to allocations on
+		 * another node and corrupt the wrong zone's accounting.
+		 */
+		if (slot->zone == zone)
+			cpu_hint = slot->sb;
+		if (cpu_hint) {
+			page = try_alloc_from_sb_pass1(zone, cpu_hint,
+						       order, migratetype);
+			if (page) {
+				if (spb_get_category(cpu_hint) == SB_TAINTED &&
+				    spb_below_shrink_high_water(cpu_hint))
+					queue_spb_slab_shrink(zone);
+				trace_mm_page_alloc_zone_locked(page, order,
+				    migratetype,
+				    pcp_allowed_order(order) &&
+				    migratetype < MIGRATE_PCPTYPES);
+				return page;
+			}
+		}
+		zone_hint = zone->sb_hint[order][migratetype];
+		if (zone_hint && zone_hint != cpu_hint) {
+			page = try_alloc_from_sb_pass1(zone, zone_hint,
+						       order, migratetype);
+			if (page) {
+				if (spb_get_category(zone_hint) == SB_TAINTED &&
+				    spb_below_shrink_high_water(zone_hint))
+					queue_spb_slab_shrink(zone);
+				slot->zone = zone;
+				slot->sb = zone_hint;
+				trace_mm_page_alloc_zone_locked(page, order,
+				    migratetype,
+				    pcp_allowed_order(order) &&
+				    migratetype < MIGRATE_PCPTYPES);
+				return page;
+			}
+		}
+	}
+
 	/*
 	 * Search per-superpageblock free lists for pages of the requested
 	 * migratetype, walking superpageblocks from fullest to emptiest
@@ -2902,6 +3064,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
 					migratetype < MIGRATE_PCPTYPES);
+				if (migratetype < MIGRATE_PCPTYPES) {
+					struct spb_warm_hint_slot *slot;
+
+					zone->sb_hint[order][migratetype] = sb;
+					slot = this_cpu_ptr(&spb_warm_hints.slot
+					    [zone_idx(zone)][order][migratetype]);
+					slot->zone = zone;
+					slot->sb = sb;
+				}
 				return page;
 			}
 			/* Then try sub-pageblock (no PCP buddy) */
@@ -2924,6 +3095,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					if (migratetype < MIGRATE_PCPTYPES) {
+						struct spb_warm_hint_slot *slot;
+
+						zone->sb_hint[order][migratetype] = sb;
+						slot = this_cpu_ptr(&spb_warm_hints.slot
+						    [zone_idx(zone)][order][migratetype]);
+						slot->zone = zone;
+						slot->sb = sb;
+					}
 					return page;
 				}
 			}
-- 
2.52.0


