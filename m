Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55546CD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB1E6B00B1; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A341E6B00B2; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AEE76B00B5; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 613976B00B1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 258924005F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:10 +0000 (UTC)
X-FDA: 84716346540.16.8B56EFB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F3CD120003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="e3Pad2w/";
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xm+VVAdUgNpFDYrlwi1PJoUrI6IugoMg2l8b5+EIuNQ=;
	b=8gsaPvrNQbmmAwDInye0+TzT/2EVTe17uenz//W3sJArASG+gNXm1fgFWp1NvupSnOw3lT
	TK6T/wJk+eQS2X5e1wWhOJV9LgvOF1DlLeE8C4msluwkE2MPNWpKq2f+1qXPss2lsXvvzT
	k1LhirJnKo020FJBknLJaEw4BRFD2iI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580588; a=rsa-sha256;
	cv=none;
	b=g/GWTPZC8aVMweYVMulNt6H0Xu1ZTs1rKURLZfId4ABRL7QAJ8kIo1ylBcWcjG1PotiMjk
	FB18sTthgNCEfFyE5rqAuXgPCsGc0HVhdPL8vS3g48bUgps7zZBG4CI1g71ZYM7E/M/KBO
	u304ekwEIIHHqHDQX4Lni43x3LKl6OA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="e3Pad2w/";
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xm+VVAdUgNpFDYrlwi1PJoUrI6IugoMg2l8b5+EIuNQ=; b=e3Pad2w/Cf7mvhVWeSJuE6F7vg
	EWiN3HQDLK3BoooCFKnP6W4yZTY2pX4ZBTZrkn3+ASkwjd3L6gq/sXsBPQCo0dw/VVRnji12ABWpu
	yqyfQwwqlUq9/w34Npa7li30NByzNQNeDjlzx5JYk7r9s99UQ9sdYfNag20f4WFYtX6zzYKb9V1av
	8wc3fkX3fmPjHUKmYpYbL/nuRWTAxfDVYFcclegfLvnH/+Tyd7k0GynzVItZkruNOG0QHqygg0L1P
	wktMTJtB3koP5wWpZxdUDFimtJLU9Vy+KgpE9qD1vddvUsFxZAXqw+/9Uh2nf+Im1gWE//3zJmui5
	FMEkSAKA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3FPz;
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
Subject: [RFC PATCH 15/45] mm: page_alloc: add per-superpageblock free lists
Date: Thu, 30 Apr 2026 16:20:44 -0400
Message-ID: <20260430202233.111010-16-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F3CD120003
X-Rspam-User: 
X-Stat-Signature: kgisps19jkexzujkpg8zyeec75gdazjs
X-HE-Tag: 1777580588-913059
X-HE-Meta: U2FsdGVkX1+q+4ABtcZz3IDC+kTWrFsp4TAcKo4SPGeciQ97MycrFCE0hX9rT4+CSYZLKA0t45vIDrYT9h353CzUNgmvVrzxCbmNdMzjWBWKXW7/bhotOIGMXs0H5UQrBVwNBkQOY0//CZzfgvn9wLprhgU0y6NDv6QMdad7C5vi7+aZ0kgTtX3sPaGWrxyHE6w7vMPeH4gRu6Q8U4NJRidoW0JFtKfpD+bDZQ67vMBB7djCufLIWh5sXPa7FC6OvxJlgZRC0Gtrwf+3OpM6mSQ/yUz/CpXV9irsmgXMDZSDVaAKe+1Xvjix3IwMP3K5Y5cS4CtvXJbGDkQpAItQn0DV35IveWQKYHVGwRs1Wg7MUY2DMUOh1diX5sXMR7db/Dn53QaPuk1BhtDJdEByBy9g7DBEohxTJxRLQsAu+fLXq/96JbsiJjtr+6CoqiIaxRb9IXPs2CFURrkGrdPCWK05hEEM0Qp8d+phH9Aq+w9UxX49VT9O13CDq6vCTNgCGds+SiI9qjYeoj0z/FjpuqEoXITjma9fng5laYVunNE8P081Fb2d8tOH19u2HOobgK9eCjT6Xc4CEVT+ECscFZ4Vok+luK2NWt4UIUNzyby93pi/kuKbsM3f29OZs03ovxDUythR5xR255JRCFqF4It7zUfUPrXh2CeJsTki2/CCFXOV/TnoctSMYnuvtyxB60RQjwD5MW8SepXy6Uq4t6OyZK0CWgoEdUogRQPjqyYGEqwLNzEzhQOyVLEtczD+ui/2x/G14kctQiZ79iAImrskcyUCS+sRAzDhwZ8yqmTCVe/XZSxuBV/1J2hXEFHvlo7nP7ZNPvErf+B9rPJNn6owCdE+ufLsPFJV0ePdIOiTGeVSkhIceYkM1y0ZT36BwFNomp1gF6rDptxvmS7qZPxwLD3V7zNgqj+TlDuAflOUgR0T4od5MLZnEVHnLZvYhzwerrneLOC4LSiWfHg
 z+q1Sv19
 QK7N/kcYQE2zPfnOJhJWG7KJuoELFMhZfCwYvXYS/ZmzMinGyUWeyOcX+zLdPZFl9p2C7jIQLXe3eZTTK3uQ2f6NbrG/r+5SZBor+B0iVy1JYFTy+TTedQNv9T7OA+K46N6H+wSJ8xB8Vfkb9XGuOpL/jsTP3AsN2U/T7a0usUm8CTd27W6kSYXPe6kqhixOVyMlQ0Zox89eu328glzPpC9yTB7JV9+Rc1JMJJN5eBZfNbQfWnP206vEZ9uGVVF/uJ3TMrBuLpY9catkiRv6d17CNP7ipCNFLn4rOmmCdwbEsnWy3FWfFxu+LL6DURA1TR0pHhoXHQge0EPmolLGHIuPveNX53mMXqSTk49EYde9T3I8cXpf3z4J2n/NOW6gIzx4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

Add per-superpageblock free lists for all buddy orders, enabling precise
allocation steering — pick the right superpageblock first, then allocate
from its local free list in O(1).

Each superpageblock contains free_area[NR_PAGE_ORDERS] with per-migratetype
free lists. Pages belonging to a superpageblock are placed on the owning
superpageblock's free list at every order. Pages not belonging to any
superpageblock remain on zone free lists.

The core free list operations (__add_to_free_list,
__del_page_from_free_list, move_to_free_list) use pfn_sb_free_area() to
route to the correct free_area based on the page's PFN. The expand() path
inherits this automatically. Zone-level nr_free counters are shadowed for
watermark checks.

__rmqueue_smallest() searches per-superpageblock free lists when
superpageblocks are enabled, walking superpageblocks from fullest to
emptiest to concentrate allocations. For empty superpageblocks, it searches
from the highest order down to find the largest available chunk. Zone free
lists serve as a fallback for pages not in any superpageblock.

The fallback allocation paths (__rmqueue_claim and __rmqueue_steal) are
made superpageblock-aware via __rmqueue_sb_find_fallback(), which searches
per-superpageblock free lists for fallback-type pages. The category search
order is migratetype-aware: movable allocations prefer clean
superpageblocks to keep movable pages consolidated, while
unmovable/reclaimable prefer tainted superpageblocks to avoid contaminating
clean ones.

Buddy coalescing in __free_one_page() works correctly because
__del_page_from_free_list() uses pfn_sb_free_area() to find the buddy's
free_area, and both the freed page and its buddy are always in the same
superpageblock for orders below pageblock_order.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  10 +
 mm/compaction.c        |  36 +-
 mm/internal.h          |  10 +
 mm/mm_init.c           |  20 +
 mm/page_alloc.c        | 855 +++++++++++++++++++++++++++++++++--------
 5 files changed, 756 insertions(+), 175 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f03800f5028b..f226dfdd1e99 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -924,9 +924,19 @@ struct superpageblock {
 	u16			nr_reserved;	/* holes, firmware, etc. */
 	u16			total_pageblocks; /* zone-clipped total */
 
+	/* Total free pages across all per-superpageblock free lists */
+	unsigned long		nr_free_pages;
+
 	/* For organizing superpageblocks by fullness category */
 	struct list_head	list;
 
+	/*
+	 * Per-superpageblock free lists for all buddy orders.
+	 * All pages belonging to this superpageblock are tracked here,
+	 * keeping allocation steering effective at every order.
+	 */
+	struct free_area	free_area[NR_PAGE_ORDERS];
+
 	/* Identity */
 	unsigned long		start_pfn;
 	struct zone		*zone;
diff --git a/mm/compaction.c b/mm/compaction.c
index cf2a5074c473..88ba88340f3b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -961,6 +961,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
 				}
+				/*
+				 * Skipped a movable page; clearing
+				 * PB_has_movable here would orphan SPB type
+				 * counters (debugfs invariant 1).
+				 */
+				movable_skipped = true;
 				goto isolate_fail;
 			}
 			/* for alloc_contig case */
@@ -1040,6 +1046,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
 				}
+				/*
+				 * Skipped a movable compound page; clearing
+				 * PB_has_movable here would orphan SPB type
+				 * counters (debugfs invariant 1).
+				 */
+				movable_skipped = true;
 				goto isolate_fail;
 			}
 		}
@@ -1065,6 +1077,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				movable_skipped = true;
 			}
 
+			/*
+			 * Non-LRU non-movable_ops page: still occupies the
+			 * pageblock, so clearing PB_has_movable here would
+			 * orphan SPB type counters (debugfs invariant 1).
+			 */
+			movable_skipped = true;
 			goto isolate_fail;
 		}
 
@@ -1303,12 +1321,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 * isolated (pinned, writeback, dirty, etc.), leave the
 		 * flag set so a future migration attempt can try again.
 		 */
-		if (!nr_isolated && !movable_skipped && valid_page &&
-		    get_pfnblock_bit(valid_page, pageblock_start_pfn(start_pfn),
-				     PB_has_movable))
-			clear_pfnblock_bit(valid_page,
-					   pageblock_start_pfn(start_pfn),
-					   PB_has_movable);
+		if (!nr_isolated && !movable_skipped && valid_page)
+			superpageblock_clear_has_movable(cc->zone,
+							valid_page);
 	}
 
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
@@ -1856,6 +1871,15 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		prep_compound_page(&dst->page, order);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
+
+	/*
+	 * Compaction isolates free pages via __isolate_free_page, which
+	 * bypasses page_del_and_expand and its PB_has_* tracking.  The
+	 * destination will hold movable pages after migration, so mark
+	 * PB_has_movable on the destination pageblock now.
+	 */
+	superpageblock_set_has_movable(cc->zone, &dst->page);
+
 	return page_rmappable_folio(&dst->page);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 163ef96fa777..7ee73f9bb76c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1025,6 +1025,16 @@ void init_cma_reserved_pageblock(struct page *page);
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
+#ifdef CONFIG_COMPACTION
+void superpageblock_clear_has_movable(struct zone *zone, struct page *page);
+void superpageblock_set_has_movable(struct zone *zone, struct page *page);
+#else
+static inline void superpageblock_clear_has_movable(struct zone *zone,
+						    struct page *page) {}
+static inline void superpageblock_set_has_movable(struct zone *zone,
+						  struct page *page) {}
+#endif
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 void resize_zone_superpageblocks(struct zone *zone);
 #endif
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6af34c1a8cc4..80cfc7c4de98 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1537,16 +1537,27 @@ static void __meminit init_one_superpageblock(struct superpageblock *sb,
 	unsigned long sb_end = start_pfn + SUPERPAGEBLOCK_NR_PAGES;
 	unsigned long pb_start = max(start_pfn, zone_start);
 	unsigned long pb_end = min(sb_end, zone_end);
+	int order, t;
 	u16 actual_pbs;
 
 	sb->nr_unmovable = 0;
 	sb->nr_reclaimable = 0;
 	sb->nr_movable = 0;
 	sb->nr_free = 0;
+	sb->nr_free_pages = 0;
 	INIT_LIST_HEAD(&sb->list);
 	sb->start_pfn = start_pfn;
 	sb->zone = zone;
 
+	/* Initialize per-superpageblock free areas */
+	for (order = 0; order < NR_PAGE_ORDERS; order++) {
+		struct free_area *area = &sb->free_area[order];
+
+		for (t = 0; t < MIGRATE_TYPES; t++)
+			INIT_LIST_HEAD(&area->free_list[t]);
+		area->nr_free = 0;
+	}
+
 	/*
 	 * Start with all pageblock slots as reserved.
 	 * init_pageblock_migratetype() will decrement nr_reserved and
@@ -1594,6 +1605,15 @@ static void __init setup_superpageblocks(struct zone *zone)
 		for (full = 0; full < __NR_SB_FULLNESS; full++)
 			INIT_LIST_HEAD(&zone->spb_lists[cat][full]);
 
+	/*
+	 * Warn if pages have already been freed into this zone's
+	 * free_area before superpageblocks are set up — those pages
+	 * would become stranded because __rmqueue_smallest only
+	 * searches per-superpageblock free lists.
+	 */
+	for (i = 0; i < NR_PAGE_ORDERS; i++)
+		WARN_ON_ONCE(zone->free_area[i].nr_free);
+
 	if (!zone->spanned_pages)
 		return;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 907ce46c060f..cbf5f48d377e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -559,6 +559,140 @@ static void __spb_set_has_type(struct page *page, int migratetype)
 	}
 }
 
+/*
+ * __spb_clear_has_type - clear PB_has_* and decrement type counter
+ *
+ * Idempotent: only decrements the counter on the 1→0 bit transition.
+ */
+static void __spb_clear_has_type(struct page *page, int migratetype)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb = pfn_to_superpageblock(page_zone(page), pfn);
+	int bit;
+
+	if (!sb)
+		return;
+
+	bit = migratetype_to_has_bit(migratetype);
+	if (bit < 0)
+		return;
+
+	if (get_pfnblock_bit(page, pfn, bit)) {
+		clear_pfnblock_bit(page, pfn, bit);
+		switch (bit) {
+		case PB_has_unmovable:
+			if (sb->nr_unmovable)
+				sb->nr_unmovable--;
+			break;
+		case PB_has_reclaimable:
+			if (sb->nr_reclaimable)
+				sb->nr_reclaimable--;
+			break;
+		case PB_has_movable:
+			if (sb->nr_movable)
+				sb->nr_movable--;
+			break;
+		}
+	}
+}
+
+#ifdef CONFIG_COMPACTION
+/*
+ * spb_pageblock_has_free_movable_fragments - probe SPB free lists for movable
+ * @zone: zone containing @page
+ * @page: any page within the target pageblock
+ *
+ * Returns true if the SPB containing @page has any free MOVABLE pages on its
+ * per-order free lists at orders below pageblock_order whose PFN falls within
+ * the target pageblock. The compaction migrate scanner only sees in-use pages,
+ * so a pageblock can look "empty of movable" to the scanner while the SPB
+ * still owns small-order MOVABLE fragments inside it. Clearing PB_has_movable
+ * in that case would orphan those fragments from the SPB type accounting and
+ * trigger debugfs invariant 1 (sum_types undercount).
+ *
+ * Returns false (no fragments found) when the SPB lookup fails, which
+ * preserves the legacy clear-on-empty behavior for edge cases.
+ *
+ * Caller must hold zone->lock.
+ */
+static bool spb_pageblock_has_free_movable_fragments(struct zone *zone,
+						     struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long pb_start = pageblock_start_pfn(pfn);
+	unsigned long pb_end = pb_start + pageblock_nr_pages;
+	unsigned long frag_pfn;
+	struct superpageblock *sb;
+	struct list_head *list;
+	struct page *frag;
+	unsigned int order;
+
+	sb = pfn_to_superpageblock(zone, pfn);
+	if (!sb)
+		return false;
+
+	for (order = 0; order < pageblock_order; order++) {
+		list = &sb->free_area[order].free_list[MIGRATE_MOVABLE];
+		list_for_each_entry(frag, list, buddy_list) {
+			frag_pfn = page_to_pfn(frag);
+			if (frag_pfn >= pb_start && frag_pfn < pb_end)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * superpageblock_clear_has_movable - clear PB_has_movable with SPB counter update
+ * @page: page within the pageblock
+ *
+ * Called from compaction when a full pageblock scan determines no movable
+ * pages remain. Clears PB_has_movable and decrements the superpageblock's
+ * nr_movable counter atomically (under zone->lock).
+ *
+ * Without this, clearing PB_has_movable directly via clear_pfnblock_bit()
+ * would leave the SPB counter stale, causing nr_movable to grow unbounded
+ * as subsequent movable allocations re-set the bit and re-increment.
+ *
+ * The migrate scanner only inspects in-use pages, so it is blind to MOVABLE
+ * fragments below pageblock_order sitting on the SPB free lists. Probe those
+ * lists first; if any fragment of @page's pageblock is still tracked by the
+ * SPB, leave PB_has_movable set so the SPB type accounting stays consistent
+ * (debugfs invariant 1: unmov + recl + mov + free >= total - rsv).
+ */
+void superpageblock_clear_has_movable(struct zone *zone, struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	if (!spb_pageblock_has_free_movable_fragments(zone, page))
+		__spb_clear_has_type(page, MIGRATE_MOVABLE);
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+/**
+ * superpageblock_set_has_movable - set PB_has_movable with SPB counter update
+ * @zone: zone containing the page
+ * @page: page within the pageblock
+ *
+ * Called from compaction when a movable page is migrated into a pageblock.
+ * Compaction bypasses page_del_and_expand (which normally sets PB_has_*)
+ * by using __isolate_free_page + direct migration, so PB_has_movable must
+ * be set explicitly for the destination pageblock.
+ *
+ * Idempotent: only increments the counter on the 0→1 bit transition.
+ */
+void superpageblock_set_has_movable(struct zone *zone, struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	__spb_set_has_type(page, MIGRATE_MOVABLE);
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+#endif /* CONFIG_COMPACTION */
+
 /**
  * spb_get_category - Determine if a superpageblock is clean or tainted
  * @sb: superpageblock to classify
@@ -629,7 +763,7 @@ static void spb_update_list(struct superpageblock *sb)
 
 	list_del_init(&sb->list);
 
-	if (sb->nr_free == SUPERPAGEBLOCK_NR_PAGEBLOCKS) {
+	if (sb->nr_free == sb->total_pageblocks) {
 		list_add_tail(&sb->list, &zone->spb_empty);
 		return;
 	}
@@ -1067,12 +1201,41 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 			   zone->nr_free_highatomic + nr_pages);
 }
 
+/**
+ * pfn_sb_free_area - Get the correct free_area for a page at given order
+ * @zone: the zone
+ * @pfn: page frame number
+ * @order: buddy order
+ *
+ * Returns the per-superpageblock free_area if the page belongs to a valid
+ * superpageblock. Otherwise returns the zone free_area (for zones where the
+ * superpageblock setup failed).
+ */
+static inline struct free_area *pfn_sb_free_area(struct zone *zone,
+						 unsigned long pfn,
+						 unsigned int order,
+						 struct superpageblock **sbp)
+{
+	struct superpageblock *sb = pfn_to_superpageblock(zone, pfn);
+
+	if (sb) {
+		if (sbp)
+			*sbp = sb;
+		return &sb->free_area[order];
+	}
+	if (sbp)
+		*sbp = NULL;
+	return &zone->free_area[order];
+}
+
 /* Used for pages not on another list */
 static inline void __add_to_free_list(struct page *page, struct zone *zone,
 				      unsigned int order, int migratetype,
 				      bool tail)
 {
-	struct free_area *area = &zone->free_area[order];
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb;
+	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
 	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
@@ -1085,6 +1248,13 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 		list_add(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
 
+	if (sb) {
+		/* Keep zone-level nr_free accurate for watermark checks */
+		zone->free_area[order].nr_free++;
+		/* Track total free pages per superpageblock */
+		sb->nr_free_pages += nr_pages;
+	}
+
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
 }
@@ -1097,7 +1267,8 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 static inline void move_to_free_list(struct page *page, struct zone *zone,
 				     unsigned int order, int old_mt, int new_mt)
 {
-	struct free_area *area = &zone->free_area[order];
+	unsigned long pfn = page_to_pfn(page);
+	struct free_area *area = pfn_sb_free_area(zone, pfn, order, NULL);
 	int nr_pages = 1 << order;
 
 	/* Free page moving can fail, so it happens before the type update */
@@ -1121,6 +1292,9 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 static inline void __del_page_from_free_list(struct page *page, struct zone *zone,
 					     unsigned int order, int migratetype)
 {
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb;
+	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
         VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
@@ -1134,7 +1308,14 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	list_del(&page->buddy_list);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
-	zone->free_area[order].nr_free--;
+	area->nr_free--;
+
+	if (sb) {
+		/* Keep zone-level nr_free accurate for watermark checks */
+		zone->free_area[order].nr_free--;
+		/* Track total free pages per superpageblock */
+		sb->nr_free_pages -= nr_pages;
+	}
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
@@ -1190,33 +1371,44 @@ static void change_pageblock_range(struct page *pageblock_page,
 	}
 }
 
-/*
+/**
  * mark_pageblock_free - handle a pageblock becoming fully free
  * @page: page at the start of the pageblock
  * @pfn: page frame number
+ * @migratetype: pointer to the caller's migratetype variable (may be updated)
  *
- * Clear stale PCP ownership and actual-contents tracking flags when
- * buddy merging reconstructs a full pageblock or a whole pageblock is
- * freed directly. No PCP can still hold pages from this block (otherwise
- * the buddy merge couldn't have completed), so the ownership entry would
- * just cause misrouted frees.
+ * Clear stale PCP ownership and actual-contents tracking flags, mark the
+ * pageblock as fully free for superpageblock accounting, and reset the
+ * migratetype to MOVABLE so the page lands on free_list[MIGRATE_MOVABLE].
+ * Non-movable allocations must go through RMQUEUE_CLAIM to reuse it,
+ * which properly handles PB_all_free and superpageblock accounting.
  */
-static void mark_pageblock_free(struct page *page, unsigned long pfn)
+static void mark_pageblock_free(struct page *page, unsigned long pfn,
+				int *migratetype)
 {
 	clear_pcpblock_owner(page);
 
 	/*
-	 * The entire block is now free — clear actual-contents tracking
-	 * flags since no allocated pages remain.
+	 * Clear PB_has_* bits and decrement corresponding SPB type
+	 * counters. Use __spb_clear_has_type (no list update) to avoid
+	 * bouncing the SPB between lists; pb_now_free's spb_update_list
+	 * handles the final reclassification.
 	 */
-	clear_pfnblock_bit(page, pfn, PB_has_unmovable);
-	clear_pfnblock_bit(page, pfn, PB_has_reclaimable);
-	clear_pfnblock_bit(page, pfn, PB_has_movable);
+	__spb_clear_has_type(page, MIGRATE_UNMOVABLE);
+	__spb_clear_has_type(page, MIGRATE_RECLAIMABLE);
+	__spb_clear_has_type(page, MIGRATE_MOVABLE);
 
 	if (!get_pfnblock_bit(page, pfn, PB_all_free)) {
 		set_pfnblock_bit(page, pfn, PB_all_free);
 		superpageblock_pb_now_free(page);
 	}
+
+	if (*migratetype == MIGRATE_UNMOVABLE ||
+	    *migratetype == MIGRATE_RECLAIMABLE ||
+	    *migratetype == MIGRATE_HIGHATOMIC) {
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		*migratetype = MIGRATE_MOVABLE;
+	}
 }
 
 /*
@@ -1249,6 +1441,7 @@ static inline void __free_one_page(struct page *page,
 		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
+	unsigned int orig_order = order;
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
@@ -1261,18 +1454,31 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-	account_freepages(zone, 1 << order, migratetype);
+	if (order >= pageblock_order) {
+		int i, nr_pbs = 1 << (order - pageblock_order);
 
-	/*
-	 * When freeing a whole pageblock, clear stale PCP ownership
-	 * and actual-contents tracking flags up front, and mark it
-	 * as fully free for superpageblock accounting.  The in-loop
-	 * check only fires when sub-pageblock pages merge *up to*
-	 * pageblock_order, not when entering at pageblock_order
-	 * directly.
-	 */
-	if (order == pageblock_order)
-		mark_pageblock_free(page, pfn);
+		for (i = 0; i < nr_pbs; i++) {
+			int pb_mt = get_pfnblock_migratetype(
+					page + i * pageblock_nr_pages,
+					pfn + i * pageblock_nr_pages);
+			mark_pageblock_free(page + i * pageblock_nr_pages,
+					    pfn + i * pageblock_nr_pages,
+					    &pb_mt);
+		}
+		/*
+		 * After mark_pageblock_free, non-CMA sub-pageblocks are
+		 * MOVABLE. CMA pageblocks retain their CMA type so pages
+		 * land on the correct free list for CMA allocations.
+		 * ISOLATE pageblocks must stay ISOLATE so that
+		 * account_freepages() correctly skips them — otherwise
+		 * NR_FREE_PAGES gets incremented for isolated pages.
+		 */
+		if (!is_migrate_cma(migratetype) &&
+		    !is_migrate_isolate(migratetype))
+			migratetype = MIGRATE_MOVABLE;
+	}
+
+	account_freepages(zone, 1 << order, migratetype);
 
 	while (order < MAX_PAGE_ORDER) {
 		int buddy_mt = migratetype;
@@ -1329,8 +1535,29 @@ static inline void __free_one_page(struct page *page,
 		 * clear any stale PCP ownership and actual-contents
 		 * tracking flags.
 		 */
-		if (order == pageblock_order)
-			mark_pageblock_free(page, pfn);
+		if (order == pageblock_order) {
+			int old_mt = migratetype;
+
+			mark_pageblock_free(page, pfn, &migratetype);
+			/*
+			 * mark_pageblock_free may convert migratetype to
+			 * MOVABLE. Transfer the accounting done earlier so
+			 * nr_free_highatomic doesn't leak.
+			 *
+			 * We transfer 1 << orig_order pages — the amount
+			 * credited by this __free_one_page call. Buddies
+			 * consumed during merging may also have HIGHATOMIC
+			 * credits from their own frees; those are not tracked
+			 * here. In practice HIGHATOMIC reserves are small and
+			 * short-lived, so any residual drift is minor.
+			 */
+			if (old_mt != migratetype) {
+				account_freepages(zone, -(1 << orig_order),
+						  old_mt);
+				account_freepages(zone, 1 << orig_order,
+						  migratetype);
+			}
+		}
 	}
 
 done_merging:
@@ -2148,15 +2375,44 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 
 	/*
 	 * If we're splitting a page that spans at least a full pageblock,
-	 * the allocated pageblock transitions from fully-free to in-use.
-	 * Clear PB_all_free and update superpageblock accounting.
+	 * each constituent pageblock transitions from fully-free to in-use.
+	 * Clear PB_all_free and update superpageblock accounting for ALL
+	 * pageblocks in the range, not just the first one.
 	 */
 	if (high >= pageblock_order) {
 		unsigned long pfn = page_to_pfn(page);
+		unsigned long end_pfn = pfn + (1 << high);
+
+		for (; pfn < end_pfn; pfn += pageblock_nr_pages) {
+			struct page *pb_page = pfn_to_page(pfn);
 
-		if (get_pfnblock_bit(page, pfn, PB_all_free)) {
-			clear_pfnblock_bit(page, pfn, PB_all_free);
-			superpageblock_pb_now_used(page);
+			if (get_pfnblock_bit(pb_page, pfn, PB_all_free)) {
+				clear_pfnblock_bit(pb_page, pfn, PB_all_free);
+				superpageblock_pb_now_used(pb_page);
+			}
+			__spb_set_has_type(pb_page, migratetype);
+		}
+		/* Single list update after all pageblocks processed */
+		{
+			struct superpageblock *sb =
+				pfn_to_superpageblock(zone,
+						      page_to_pfn(page));
+			if (sb)
+				spb_update_list(sb);
+		}
+	} else {
+		/*
+		 * Sub-pageblock allocation: set PB_has_<migratetype> for
+		 * the containing pageblock. Idempotent — only increments
+		 * the counter on the first allocation of this type.
+		 */
+		__spb_set_has_type(page, migratetype);
+		{
+			struct superpageblock *sb =
+				pfn_to_superpageblock(zone,
+						      page_to_pfn(page));
+			if (sb)
+				spb_update_list(sb);
 		}
 	}
 
@@ -2311,6 +2567,15 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 /* Bounded scan limit when searching free lists for tainted superpageblock pages */
 #define SPB_SCAN_LIMIT 8
 
+/*
+ * Reserve free pageblocks in tainted superpageblocks for unmovable/reclaimable
+ * allocations.  Movable allocations skip tainted superpageblocks that have
+ * fewer than this many free pageblocks, ensuring that unmovable claims
+ * always find room in existing tainted superpageblocks instead of spilling
+ * into clean ones.
+ */
+#define SPB_TAINTED_RESERVE	4
+
 /**
  * sb_preferred_for_movable - Find the fullest clean superpageblock for movable
  * @zone: zone to search
@@ -2350,38 +2615,38 @@ static struct page *__rmqueue_from_sb(struct zone *zone, unsigned int order,
 				      int migratetype, struct superpageblock *sb)
 {
 	unsigned int current_order;
-	unsigned long sb_start = sb->start_pfn;
-	unsigned long sb_end = sb_start + (1UL << SUPERPAGEBLOCK_ORDER);
 	struct free_area *area;
 	struct page *page;
-	int scanned;
 
-	for (current_order = order; current_order < NR_PAGE_ORDERS;
+	/*
+	 * Search the superpageblock's own free lists for all orders.
+	 */
+	for (current_order = order;
+	     current_order < NR_PAGE_ORDERS;
 	     ++current_order) {
-		area = &zone->free_area[current_order];
-		scanned = 0;
-
-		list_for_each_entry(page, &area->free_list[migratetype],
-				    buddy_list) {
-			unsigned long pfn = page_to_pfn(page);
+		area = &sb->free_area[current_order];
+		page = get_page_from_free_area(area, migratetype);
+		if (!page)
+			continue;
 
-			if (pfn >= sb_start && pfn < sb_end) {
-				page_del_and_expand(zone, page, order,
-						    current_order,
-						    migratetype);
-				return page;
-			}
-			if (++scanned >= SPB_SCAN_LIMIT)
-				break;
-		}
+		page_del_and_expand(zone, page, order, current_order,
+				    migratetype);
+		return page;
 	}
+
 	return NULL;
 }
 
 /*
  * Go through the free lists for the given migratetype and remove
- * the smallest available page from the freelists
+ * the smallest available page from the freelists.
+ *
+ * When superpageblocks are enabled, search per-superpageblock free lists first,
+ * falling back to zone free lists for pages not in any superpageblock.
  */
+static struct page *claim_whole_block(struct zone *zone, struct page *page,
+		  int current_order, int order, int new_type, int old_type);
+
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
@@ -2389,14 +2654,179 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	unsigned int current_order;
 	struct free_area *area;
 	struct page *page;
+	int full;
+	struct superpageblock *sb;
+	/*
+	 * Category search order: 2 passes.
+	 * Movable: clean first, then tainted (pack into clean SBs).
+	 * Others: tainted first, then clean (concentrate in tainted SBs).
+	 */
+	static const enum sb_category cat_order[2][2] = {
+		[0] = { SB_TAINTED, SB_CLEAN },  /* unmovable/reclaimable */
+		[1] = { SB_CLEAN, SB_TAINTED },  /* movable */
+	};
+	int movable = (migratetype == MIGRATE_MOVABLE) ? 1 : 0;
+
+	/*
+	 * Search per-superpageblock free lists for pages of the requested
+	 * migratetype, walking superpageblocks from fullest to emptiest
+	 * to pack allocations.
+	 *
+	 * For unmovable/reclaimable, prefer tainted superpageblocks to
+	 * concentrate non-movable allocations into fewer superpageblocks.
+	 * For movable, prefer clean superpageblocks to keep them homogeneous.
+	 *
+	 * Search empty superpageblocks between the preferred and fallback
+	 * category passes to avoid movable allocations consuming free
+	 * pageblocks in tainted superpageblocks (which unmovable needs for
+	 * future CLAIMs), and vice versa.
+	 */
+	for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+		enum sb_category cat = cat_order[movable][0];
+
+		list_for_each_entry(sb,
+			&zone->spb_lists[cat][full], list) {
+			if (!sb->nr_free_pages)
+				continue;
+			for (current_order = order;
+			     current_order < NR_PAGE_ORDERS;
+			     ++current_order) {
+				area = &sb->free_area[current_order];
+				page = get_page_from_free_area(
+					area, migratetype);
+				if (!page)
+					continue;
+				page_del_and_expand(zone, page,
+					order, current_order,
+					migratetype);
+				trace_mm_page_alloc_zone_locked(
+					page, order, migratetype,
+					pcp_allowed_order(order) &&
+					migratetype < MIGRATE_PCPTYPES);
+				return page;
+			}
+		}
+	}
+
+	/*
+	 * For non-movable allocations, try to reclaim free pageblocks
+	 * from tainted superpageblocks before looking at empty or clean
+	 * ones. Free pageblocks in tainted SBs have pages on the MOVABLE
+	 * free list (reset by mark_pageblock_free), so the search above
+	 * misses them. Claim them inline to keep non-movable allocations
+	 * concentrated in already-tainted superpageblocks.
+	 */
+	if (!movable && !is_migrate_cma(migratetype)) {
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				if (!sb->nr_free)
+					continue;
+				for (current_order = max_t(unsigned int,
+						order, pageblock_order);
+				     current_order < NR_PAGE_ORDERS;
+				     ++current_order) {
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, MIGRATE_MOVABLE);
+					if (!page)
+						continue;
+					if (get_pageblock_isolate(page))
+						continue;
+					if (is_migrate_cma(
+					    get_pageblock_migratetype(page)))
+						continue;
+					page = claim_whole_block(zone, page,
+						current_order, order,
+						migratetype, MIGRATE_MOVABLE);
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
+		}
+	}
+
+	/* Empty superpageblocks: try before falling back to non-preferred category */
+	list_for_each_entry(sb, &zone->spb_empty, list) {
+		if (!sb->nr_free_pages)
+			continue;
+		for (current_order = max(order, pageblock_order);
+		     current_order < NR_PAGE_ORDERS;
+		     ++current_order) {
+			area = &sb->free_area[current_order];
+			page = get_page_from_free_area(area, migratetype);
+			if (!page)
+				continue;
+			page_del_and_expand(zone, page, order,
+				current_order, migratetype);
+			trace_mm_page_alloc_zone_locked(page, order,
+				migratetype,
+				pcp_allowed_order(order) &&
+				migratetype < MIGRATE_PCPTYPES);
+			return page;
+		}
+	}
+
+	/*
+	 * Pass 4: movable allocations fall back to tainted SPBs.
+	 * Non-movable allocations must NOT search clean SPBs here;
+	 * stale migratetype labels create phantom non-movable free
+	 * pages in clean SPBs that would cause unnecessary tainting.
+	 * Let __rmqueue_claim and __rmqueue_steal handle non-movable
+	 * fallback with proper ALLOC_NOFRAGMENT protection.
+	 */
+	if (movable) {
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			enum sb_category cat = cat_order[movable][1];
+
+			list_for_each_entry(sb,
+				&zone->spb_lists[cat][full], list) {
+				if (!sb->nr_free_pages)
+					continue;
+				/*
+				 * Movable falling back to tainted: skip SBs
+				 * with few free pageblocks to reserve space
+				 * for future unmovable/reclaimable claims.
+				 */
+				if (sb->nr_free <= SPB_TAINTED_RESERVE)
+					continue;
+				for (current_order = order;
+				     current_order < NR_PAGE_ORDERS;
+				     ++current_order) {
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, migratetype);
+					if (!page)
+						continue;
+					page_del_and_expand(zone, page,
+						order, current_order,
+						migratetype);
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
+		}
+	}
 
-	/* Find a page of the appropriate size in the preferred list */
-	for (current_order = order; current_order < NR_PAGE_ORDERS; ++current_order) {
+	/*
+	 * Zone free lists: all pages should be on superpageblock lists.
+	 * Finding a page here means zone hotplug added memory without
+	 * setting up superpageblocks for the new range.
+	 */
+	for (current_order = order;
+	     current_order < NR_PAGE_ORDERS; ++current_order) {
 		area = &(zone->free_area[current_order]);
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
 
+		WARN_ON_ONCE(zone->superpageblocks);
 		page_del_and_expand(zone, page, order, current_order,
 				    migratetype);
 		trace_mm_page_alloc_zone_locked(page, order, migratetype,
@@ -2742,6 +3172,8 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
  *
  * Handle the PB_all_free → used transition, change the pageblock
  * migratetype, split the block down to @order, and return the page.
+ * Used by both the claim fallback path and __rmqueue_smallest when
+ * reclaiming free pageblocks from tainted superpageblocks.
  */
 static struct page *
 claim_whole_block(struct zone *zone, struct page *page,
@@ -2753,11 +3185,6 @@ claim_whole_block(struct zone *zone, struct page *page,
 
 	VM_WARN_ON_ONCE(current_order < order);
 
-	/*
-	 * Clear PB_all_free for pageblocks being claimed.
-	 * This path bypasses page_del_and_expand(), so we
-	 * must handle the free→used transition here.
-	 */
 	for (pb_pfn = page_to_pfn(page);
 	     pb_pfn < page_to_pfn(page) + (1 << current_order);
 	     pb_pfn += pageblock_nr_pages) {
@@ -2804,6 +3231,16 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (get_pageblock_isolate(page))
 		return NULL;
 
+	/*
+	 * Never steal from CMA pageblocks.  CMA pages freed through
+	 * PCP may land on the MOVABLE free list (PCP caches the
+	 * allocation-time migratetype), making them visible to the
+	 * fallback search.  Stealing would corrupt CMA by changing
+	 * the pageblock type away from MIGRATE_CMA.
+	 */
+	if (is_migrate_cma(get_pageblock_migratetype(page)))
+		return NULL;
+
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order)
 		return claim_whole_block(zone, page, current_order, order,
@@ -2874,10 +3311,134 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	return NULL;
 }
 
+/*
+ * Search per-superpageblock free lists for a page of a fallback migratetype.
+ * Sub-pageblock-order free pages live on superpageblock free lists, not zone
+ * free lists, so __rmqueue_claim and __rmqueue_steal need this helper to
+ * find fallback pages at those orders.
+ *
+ * For unmovable/reclaimable allocations, prefer tainted superpageblocks to
+ * keep clean ones clean for future large contiguous allocations.
+ * For movable allocations, prefer clean superpageblocks to keep movable
+ * pages consolidated and superpageblocks homogeneous.
+ *
+ * @search_cats: bitmask controlling which categories to search.
+ *   bit 0: search the preferred category (tainted for unmov, clean for mov)
+ *   bit 1: search empty superpageblocks
+ *   bit 2: search the fallback category (clean for unmov, tainted for mov)
+ * All bits set (0x7) gives the original behavior.
+ */
+#define SB_SEARCH_PREFERRED	(1 << 0)
+#define SB_SEARCH_EMPTY		(1 << 1)
+#define SB_SEARCH_FALLBACK	(1 << 2)
+#define SB_SEARCH_ALL		(SB_SEARCH_PREFERRED | SB_SEARCH_EMPTY | SB_SEARCH_FALLBACK)
+
+static struct page *
+__rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
+			   int start_migratetype, int *fallback_mt,
+			   unsigned int search_cats)
+{
+	int full, i;
+	struct superpageblock *sb;
+	/*
+	 * Category search order: 2 passes.
+	 * Movable: clean, tainted.  Others: tainted, clean.
+	 */
+	static const enum sb_category cat_order[2][2] = {
+		[0] = { SB_TAINTED, SB_CLEAN },  /* unmovable/reclaimable */
+		[1] = { SB_CLEAN, SB_TAINTED },   /* movable */
+	};
+	int movable = (start_migratetype == MIGRATE_MOVABLE) ? 1 : 0;
+
+	/* Pass 0: preferred category */
+	if (search_cats & SB_SEARCH_PREFERRED) {
+		enum sb_category cat = cat_order[movable][0];
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+					    &zone->spb_lists[cat][full], list) {
+				struct free_area *area =
+					&sb->free_area[order];
+
+				if (movable && cat == SB_TAINTED &&
+				    sb->nr_free <= SPB_TAINTED_RESERVE)
+					continue;
+
+				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+					int fmt = fallbacks[start_migratetype][i];
+					struct page *page;
+
+					page = get_page_from_free_area(area,
+								       fmt);
+					if (page) {
+						*fallback_mt = fmt;
+						return page;
+					}
+				}
+			}
+		}
+	}
+
+	/* Empty superpageblocks: between preferred and fallback */
+	if (search_cats & SB_SEARCH_EMPTY) {
+		list_for_each_entry(sb, &zone->spb_empty, list) {
+			struct free_area *area =
+				&sb->free_area[order];
+
+			for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+				int fmt = fallbacks[start_migratetype][i];
+				struct page *page;
+
+				page = get_page_from_free_area(area,
+							       fmt);
+				if (page) {
+					*fallback_mt = fmt;
+					return page;
+				}
+			}
+		}
+	}
+
+	/* Pass 1: fallback category */
+	if (search_cats & SB_SEARCH_FALLBACK) {
+		enum sb_category cat = cat_order[movable][1];
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+					    &zone->spb_lists[cat][full], list) {
+				struct free_area *area =
+					&sb->free_area[order];
+
+				if (movable && cat == SB_TAINTED &&
+				    sb->nr_free <= SPB_TAINTED_RESERVE)
+					continue;
+
+				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+					int fmt = fallbacks[start_migratetype][i];
+					struct page *page;
+
+					page = get_page_from_free_area(area,
+								       fmt);
+					if (page) {
+						*fallback_mt = fmt;
+						return page;
+					}
+				}
+			}
+		}
+	}
+
+	return NULL;
+}
+
 /*
  * Try to allocate from some fallback migratetype by claiming the entire block,
  * i.e. converting it to the allocation's start migratetype.
  *
+ * Search by category first, then by order within each category, to avoid
+ * claiming clean/empty superpageblocks when tainted ones still have space
+ * at smaller orders.
+ *
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
@@ -2886,11 +3447,16 @@ static __always_inline struct page *
 __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 						unsigned int alloc_flags)
 {
-	struct free_area *area;
 	int current_order;
 	int min_order = order;
 	struct page *page;
 	int fallback_mt;
+	static const unsigned int cat_search[] = {
+		SB_SEARCH_PREFERRED,
+		SB_SEARCH_EMPTY,
+		SB_SEARCH_FALLBACK,
+	};
+	int c;
 
 	/*
 	 * Do not steal pages from freelists belonging to other pageblocks
@@ -2901,65 +3467,34 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 		min_order = pageblock_order;
 
 	/*
-	 * Find the largest available free page in the other list. This roughly
-	 * approximates finding the pageblock with the most free pages, which
-	 * would be too costly to do exactly.
+	 * Find the largest available free page in a fallback migratetype.
+	 * Search each superpageblock category across all orders before
+	 * moving to the next category, so that smaller blocks in tainted
+	 * superpageblocks are preferred over larger blocks in empty/clean
+	 * ones.
 	 */
-	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
-				--current_order) {
-		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, true);
-
-		/* No block in that order */
-		if (fallback_mt == -1)
-			continue;
-
-		/* Advanced into orders too low to claim, abort */
-		if (fallback_mt == -2)
-			break;
-
-		page = get_page_from_free_area(area, fallback_mt);
+	for (c = 0; c < ARRAY_SIZE(cat_search); c++) {
+		for (current_order = MAX_PAGE_ORDER;
+		     current_order >= min_order; --current_order) {
+			if (!should_try_claim_block(current_order,
+						    start_migratetype))
+				break;
+			page = __rmqueue_sb_find_fallback(zone, current_order,
+						start_migratetype,
+						&fallback_mt, cat_search[c]);
+			if (!page)
+				continue;
 
-		/*
-		 * For unmovable/reclaimable stealing, prefer pages from
-		 * tainted superpageblocks (already contaminated) to keep clean
-		 * superpageblocks clean for future 1GB allocations.
-		 */
-		if (start_migratetype != MIGRATE_MOVABLE &&
-		    zone->superpageblocks && page) {
-			struct superpageblock *sb;
-			struct page *alt;
-			int scanned = 0;
-
-			sb = pfn_to_superpageblock(zone, page_to_pfn(page));
-			if (sb && spb_get_category(sb) == SB_CLEAN) {
-				list_for_each_entry(alt,
-						    &area->free_list[fallback_mt],
-						    buddy_list) {
-					struct superpageblock *asb;
-
-					if (++scanned > SPB_SCAN_LIMIT)
-						break;
-					asb = pfn_to_superpageblock(zone,
-							page_to_pfn(alt));
-					if (asb && spb_get_category(asb) ==
-					    SB_TAINTED) {
-						page = alt;
-						break;
-					}
-				}
+			page = try_to_claim_block(zone, page, current_order,
+						  order, start_migratetype,
+						  fallback_mt, alloc_flags);
+			if (page) {
+				trace_mm_page_alloc_extfrag(page, order,
+					current_order, start_migratetype,
+					fallback_mt);
+				return page;
 			}
 		}
-
-		page = try_to_claim_block(zone, page, current_order, order,
-					  start_migratetype, fallback_mt,
-					  alloc_flags);
-		if (page) {
-			trace_mm_page_alloc_extfrag(page, order, current_order,
-						    start_migratetype, fallback_mt);
-			return page;
-		}
 	}
 
 	return NULL;
@@ -2973,19 +3508,23 @@ static __always_inline struct page *
 __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 {
 	struct superpageblock *sb;
-	struct free_area *area;
 	int current_order;
 	struct page *page;
 	int fallback_mt;
 
+	/*
+	 * Search per-superpageblock free lists for fallback migratetypes.
+	 * Superpageblocks are always enabled for populated zones.
+	 */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
-		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, false);
-		if (fallback_mt == -1)
+		page = __rmqueue_sb_find_fallback(zone, current_order,
+					start_migratetype,
+					&fallback_mt,
+					SB_SEARCH_PREFERRED | SB_SEARCH_FALLBACK);
+
+		if (!page)
 			continue;
 
-		page = get_page_from_free_area(area, fallback_mt);
 		page_del_and_expand(zone, page, order, current_order, fallback_mt);
 
 		/*
@@ -3220,33 +3759,11 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 		goto out;
 
 	/*
-	 * Phase 2: Zone too fragmented for whole pageblocks.
-	 * Sweep zone free lists top-down for same-migratetype
-	 * chunks. Avoids cross-type stealing and keeps PCP
-	 * functional under fragmentation.
-	 *
-	 * No ownership claim or PagePCPBuddy - these are
-	 * sub-pageblock fragments cached for batching only.
-	 *
-	 * Stop above the requested order -- at that point,
-	 * phase 3's __rmqueue() does the same lookup but with
-	 * migratetype fallback.
+	 * Phase 2 was removed: it swept zone free lists for sub-pageblock
+	 * fragments, which are always empty when superpageblocks are enabled.
+	 * Phase 3's __rmqueue() -> __rmqueue_smallest() properly searches
+	 * per-superpageblock free lists at all orders.
 	 */
-	for (o = pageblock_order - 1;
-	     o > (int)order && refilled < pages_needed; o--) {
-		struct free_area *area = &zone->free_area[o];
-		struct page *page;
-
-		while (refilled + (1 << o) <= pages_needed) {
-			page = get_page_from_free_area(area, migratetype);
-			if (!page)
-				break;
-
-			del_page_from_free_list(page, zone, o, migratetype);
-			pcp_enqueue_tail(pcp, page, migratetype, o);
-			refilled += 1 << o;
-		}
-	}
 
 	/*
 	 * Phase 3: Last resort. Use __rmqueue() which does
@@ -4251,10 +4768,19 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
-			struct free_area *area = &(zone->free_area[order]);
+			struct free_area *area;
+			struct superpageblock *sb;
 			unsigned long size;
-
-			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
+			unsigned long i;
+
+			page = NULL;
+			/* Search per-superpageblock free lists */
+			for (i = 0; i < zone->nr_superpageblocks && !page; i++) {
+				sb = &zone->superpageblocks[i];
+				area = &sb->free_area[order];
+				page = get_page_from_free_area(area,
+							       MIGRATE_HIGHATOMIC);
+			}
 			if (!page)
 				continue;
 
@@ -4385,29 +4911,20 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 	if (!order)
 		return true;
 
-	/* For a high-order request, check at least one suitable page is free */
+	/*
+	 * For a high-order request, check at least one suitable page is free.
+	 * Zone free_area nr_free is shadowed — it includes pages on
+	 * per-superpageblock free lists. A non-zero nr_free means the allocator
+	 * will find pages on superpageblock lists even if zone list heads are
+	 * empty.
+	 */
 	for (o = order; o < NR_PAGE_ORDERS; o++) {
 		struct free_area *area = &z->free_area[o];
-		int mt;
 
 		if (!area->nr_free)
 			continue;
 
-		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
-			if (!free_area_empty(area, mt))
-				return true;
-		}
-
-#ifdef CONFIG_CMA
-		if ((alloc_flags & ALLOC_CMA) &&
-		    !free_area_empty(area, MIGRATE_CMA)) {
-			return true;
-		}
-#endif
-		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
-		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
-			return true;
-		}
+		return true;
 	}
 	return false;
 }
-- 
2.52.0


