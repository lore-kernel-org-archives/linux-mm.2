Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E9CCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023016B009E; Thu, 30 Apr 2026 16:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16E16B009F; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF5D6B00A1; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7E806B009E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75EA64010B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:58 +0000 (UTC)
X-FDA: 84716346036.01.7B6CAF6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA8BB40006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=MAqOOQ7O;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xX/mkCHwO29sG7vopIl8Hd063axwve4DEVWMGwjEO+E=;
	b=M9MnjoZG4JsD23onx0HLFsoV+x/yOcCsixuidN/5HpSFvKw2dhRzKifdbaithxiSgsdNBJ
	VuD8UA26AKRYiuzG5PI7U57WHBY7F8R8Els9D+AVg2MvPVOENagTmSkeOfxGxe/RpEN3va
	d8joVBygwe0nJagcTF/yY7IxJjy1SQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580576; a=rsa-sha256;
	cv=none;
	b=MedXwy6hEmssfGM1U3ASUT8JyFynNtDlnoOZntV0vxbCRp2thmukOdU8l3ywMsuOU8znrQ
	guSWtXAuXmzueoegZn1iie8g8UPxvRGjwdSa6/W3e+DupSpViVAyJrOXp/UdMLIm5apl6S
	fVV66A2g3YIyO0XPMHWu8C9T8MhZZSI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=MAqOOQ7O;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xX/mkCHwO29sG7vopIl8Hd063axwve4DEVWMGwjEO+E=; b=MAqOOQ7OZPSPwZq5LxCsf3VEEA
	uqduWpLVDO5EJLerJ91M8uQtOmUU9ItJA4pfmqOHNdqbsDtGhLEa8fXUoDmEz4WmPn9KPMLIYRXxf
	Oq3Q2sTcijqnP/n/c+VOMwG814401RXGMCU9nOjTIC1BQGOh6Rdx/xCKSoqLz2d9B1zMXV/EcH/3L
	nOuXjI6N+QMafSjmGT07dUVbnNPOvu4JinHAU+Xbmkd3UP97bTGz9bO2ZZ3O+1UwTkJdZqhIVpT2A
	T2J+YNwlVy4kCao21t9BPD0l2l8FkwzfG5w7mFXhClJqBcYU1vDoJDSMACI+g0o8FmBe6PvIZn1db
	SsrBc9qQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3crQ;
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
Subject: [RFC PATCH 18/45] mm: page_alloc: superpageblock-aware contiguous and higher order allocation
Date: Thu, 30 Apr 2026 16:20:47 -0400
Message-ID: <20260430202233.111010-19-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA8BB40006
X-Stat-Signature: 3ado3yzzo5p7ig6precruxan1uieiy8f
X-Rspam-User: 
X-HE-Tag: 1777580576-161826
X-HE-Meta: U2FsdGVkX19M6UAsU8uhlwsc+UYQol1Kz+7XJWUZAk8/ofTEiBa3TU9m9pKgz/asZoITAW9ImV42aR1AKJEtxSAzGZf/wbdccroKtkeBqN7ltkfet7iAZtRfs2O3fuy1CNcTeaSZs9zQ/rfvGrqJDsa1xsCQBUeui84K+DI1+aaiqgsHtzj+/ZR+VNJeg8b7j/NZLtoi86ubaxJNdITIU0AXe5wg28BySWeBQo76cFQJ/ztL0vkZFLX8NGgkY3wDsrJIq0LdzY1FDMGs5v4WT8LcQdEvpLUZ7J+In7BlwsWa/qLDExIqeTAUR5aV2BklihzBFq4HopOu0Dj3qHE6XXF6Qs0lTMo0DGlo5z3BHJnVBu+xzH/q6rqAI9RckKRRu4l0OLxSD2djMafnQI6kaIH0yX4+NnJW4JnG40Npj/6KyVESgEBucaNJNliNTQnbk1ysdN3KXMORUpDiaKdzcKWYE16+8aLevOdw9vkoeqFBHfrw+boUTYBh8frm3KkgdVnPcbsyTfpBcHw1RGfjyXbeddim++GDOiKeyd9k4WY2fPAKwq/aXWQQ5KSJTL2EH6ZxOPlJqdR6myGFPKRXZ/JvMTIQHI0cn7qhh6hG4u2t6nCWD7QcjG4+VFf8P5AISHsrpfz8WKDfk0/n9/Mrh/4+oDn1yCcnubjC0W4ahTXSeLYwk3FfGwmExJGq54c6mvTGbfUh/lqmJlzB5YWIntR5rAdJlvrBX0CNoIJVt2Oj1M7rnEGMM36N8fyhASfaWNMFDNqGdawuWluetB3IzyGD83QQTPK4CJ7s+WagF2Klh+oa3g/FoAGCrJSsmKXGauZPEbm8LECbl0uo/R3EfnPSw0RtRy3FHRMcQrL24hYanweoOjf/EB2Ph5m8s1QTiryo9pdDaA2cKOkaVn4jlAGr5e0nylg0SysuoeBnT0d8vix6eEsuVq0ozfhQ+XNK99OIxJgbkW69uLHKW9k
 2+HMcUKF
 //qzuxV3WZxazX+E6lLqncRKsYS+/Dpmrqi4Jrwu86M1Wv+c+dIe0NmKpp6f+O0PzkyUqwdP7niplQi1JNaa4FlcKZpG9ADLnoHT37sn8Aq0b1FBoTQGnKw2Djqr2QTX3s8ElqEK4ceapuAx+GYgBZGzOSqTjaXTD5fK2CIcrgbnE/hkx+ezBmQYA08DEM5ctr2jz7Yns+HzZ7m0wOs4hIvy0rDODJroLSEBMJ3T/DVHWGIRYFEjWtez19aI0dSMnEuO5c/XOHHvY97mnJUaCcSrHtRnjWWmQWz/1hNfqf/ATUjhCX+djXnDI9xqMb9z9+c0aMDmb7/fl5THUFLbrhR1wxo0dSKaHoEK71GmWIAxxJiH8gHyiI5LoPuCPkzaTyx6QeblsR4EGfpMEAjqHfYFWNmdZKi+lLZEh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Add superpageblock-aware contiguous page allocation that leverages SPB
metadata to find ranges of clean (all-free) superpageblocks, instead of
scanning all memory with alloc_contig_range(). The SPB metadata identifies
exactly which 1GB regions have only free pages, making CMA and large
contiguous allocations more targeted.

Track contiguous allocations in superpageblock metadata by marking fully-
covered SPBs with contig_allocated, moving them to the spb_isolated list so
they don't participate in allocation steering. Fix the iteration to use
ALIGN(start, spb_pages) to correctly handle non-aligned allocation
boundaries.

Hook superpageblock-aware allocation into __alloc_pages_direct_compact()
for THP/mTHP and high-order unmovable/reclaimable allocations. For movable
allocations at pageblock_order or above, try sb_try_alloc_contig() first.
For unmovable/reclaimable, evacuate movable pages from tainted
superpageblocks to create buddy coalescing opportunities. Both paths fall
through to traditional compaction if the SPB approach fails.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |   2 +
 mm/mm_init.c           |   1 +
 mm/page_alloc.c        | 452 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 450 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ba6f08295ff9..765e1c5dc365 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -923,6 +923,7 @@ struct superpageblock {
 	u16			nr_movable;
 	u16			nr_reserved;	/* holes, firmware, etc. */
 	u16			total_pageblocks; /* zone-clipped total */
+	bool			contig_allocated; /* all pages held by contig alloc */
 
 	/* Total free pages across all per-superpageblock free lists */
 	unsigned long		nr_free_pages;
@@ -1010,6 +1011,7 @@ struct zone {
 
 	/* Superpageblock fullness lists for allocation steering */
 	struct list_head	spb_empty;	/* completely free superpageblocks */
+	struct list_head	spb_isolated;	/* fully isolated (1GB contig alloc) */
 	struct list_head	spb_lists[__NR_SB_CATEGORIES][__NR_SB_FULLNESS];
 
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1f55ff3126a2..8e3c64d37254 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1601,6 +1601,7 @@ static void __init setup_superpageblocks(struct zone *zone)
 
 	/* Fullness lists steer allocations to preferred superpageblocks */
 	INIT_LIST_HEAD(&zone->spb_empty);
+	INIT_LIST_HEAD(&zone->spb_isolated);
 	for (cat = 0; cat < __NR_SB_CATEGORIES; cat++)
 		for (full = 0; full < __NR_SB_FULLNESS; full++)
 			INIT_LIST_HEAD(&zone->spb_lists[cat][full]);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 54b9a69bda10..8ce96db50c2f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -754,8 +754,26 @@ static inline enum sb_fullness sb_get_fullness(struct superpageblock *sb,
  */
 #ifdef CONFIG_COMPACTION
 static void spb_maybe_start_defrag(struct superpageblock *sb);
+static bool spb_needs_defrag(struct superpageblock *sb);
+static struct page *spb_try_alloc_contig(struct zone *zone,
+					unsigned long nr_pages,
+					gfp_t gfp_mask);
+static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
+				  int migratetype);
 #else
 static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
+static inline bool spb_needs_defrag(struct superpageblock *sb) { return false; }
+static inline struct page *spb_try_alloc_contig(struct zone *zone,
+					       unsigned long nr_pages,
+					       gfp_t gfp_mask)
+{
+	return NULL;
+}
+static inline bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
+					 int migratetype)
+{
+	return false;
+}
 #endif
 
 static void spb_update_list(struct superpageblock *sb)
@@ -766,6 +784,11 @@ static void spb_update_list(struct superpageblock *sb)
 
 	list_del_init(&sb->list);
 
+	if (sb->contig_allocated) {
+		list_add_tail(&sb->list, &zone->spb_isolated);
+		return;
+	}
+
 	if (sb->nr_free == sb->total_pageblocks) {
 		list_add_tail(&sb->list, &zone->spb_empty);
 		return;
@@ -916,6 +939,45 @@ void __meminit init_pageblock_migratetype(struct page *page,
 	}
 }
 
+#ifdef CONFIG_CONTIG_ALLOC
+/**
+ * superpageblock_contig_mark - Mark/unmark SPBs for contiguous allocation
+ * @start: start PFN of the contiguous range
+ * @end: end PFN (exclusive) of the contiguous range
+ * @allocated: true when allocated, false when freed
+ *
+ * Called after a successful contiguous allocation (or before freeing) to
+ * mark fully-covered superpageblocks as contig_allocated. This moves them
+ * to the spb_isolated list so they don't participate in allocation steering,
+ * and makes them visible in debugfs.
+ */
+static void superpageblock_contig_mark(unsigned long start, unsigned long end,
+				       bool allocated)
+{
+	struct zone *zone = page_zone(pfn_to_page(start));
+	unsigned long spb_pages = SUPERPAGEBLOCK_NR_PAGES;
+	unsigned long pfn;
+	unsigned long flags;
+
+	/* Only track full-SPB contiguous allocations */
+	if (end - start < spb_pages)
+		return;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	for (pfn = ALIGN(start, spb_pages); pfn + spb_pages <= end;
+	     pfn += spb_pages) {
+		struct superpageblock *sb = pfn_to_superpageblock(zone, pfn);
+
+		if (!sb)
+			continue;
+
+		sb->contig_allocated = allocated;
+		spb_update_list(sb);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+#endif /* CONFIG_CONTIG_ALLOC */
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -4240,6 +4302,17 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 
 void free_frozen_pages(struct page *page, unsigned int order)
 {
+#ifdef CONFIG_CONTIG_ALLOC
+	/*
+	 * If freeing a superpageblock-sized (or larger) range, clear the
+	 * contig_allocated flag so the SPB returns to normal allocation.
+	 */
+	if (order >= SUPERPAGEBLOCK_ORDER) {
+		unsigned long pfn = page_to_pfn(page);
+
+		superpageblock_contig_mark(pfn, pfn + (1UL << order), false);
+	}
+#endif
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
@@ -5408,6 +5481,60 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	if (!order)
 		return NULL;
 
+	/*
+	 * Superpageblock-aware contiguous allocation for movable high-order
+	 * allocations. Use superpageblock metadata to find clean ranges and
+	 * evacuate them via alloc_contig_frozen_range, bypassing the
+	 * blind compaction scanner entirely.
+	 */
+	if (order >= pageblock_order &&
+	    ac->migratetype == MIGRATE_MOVABLE) {
+		struct zoneref *z;
+		struct zone *zone;
+
+		for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+					       ac->highest_zoneidx,
+					       ac->nodemask) {
+			page = spb_try_alloc_contig(zone, 1UL << order,
+						   gfp_mask);
+			if (page) {
+				prep_new_page(page, order, gfp_mask,
+					      alloc_flags);
+				*compact_result = COMPACT_SUCCESS;
+				count_vm_event(COMPACTSUCCESS);
+				return page;
+			}
+		}
+	}
+
+	/*
+	 * Superpageblock-aware targeted evacuation for unmovable/reclaimable
+	 * high-order allocations. Instead of blind compaction, find
+	 * pageblocks of the right migratetype in tainted superpageblocks
+	 * and evacuate their movable pages to create buddy coalescing
+	 * opportunities.
+	 */
+	if (ac->migratetype == MIGRATE_UNMOVABLE ||
+	    ac->migratetype == MIGRATE_RECLAIMABLE) {
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
+				if (page) {
+					*compact_result = COMPACT_SUCCESS;
+					count_vm_event(COMPACTSUCCESS);
+					return page;
+				}
+			}
+		}
+	}
+
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
 	noreclaim_flag = memalloc_noreclaim_save();
@@ -9011,6 +9138,8 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	}
 done:
 	undo_isolate_page_range(start, end);
+	if (!ret)
+		superpageblock_contig_mark(start, end, true);
 	return ret;
 }
 EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
@@ -9105,6 +9234,279 @@ static bool zone_spans_last_pfn(const struct zone *zone,
 	return zone_spans_pfn(zone, last_pfn);
 }
 
+/*
+ * Maximum superpageblock candidates to collect for contiguous allocation.
+ * Collected under zone->lock, then tried without it.
+ */
+#define SPB_CONTIG_MAX_CANDIDATES 4
+
+#ifdef CONFIG_COMPACTION
+/**
+ * sb_collect_contig_candidates - Find superpageblock ranges for contiguous alloc
+ * @zone: zone to search (must hold zone->lock)
+ * @nr_pages: number of contiguous pages needed
+ * @pfns: output array of candidate start PFNs
+ * @max: maximum candidates to collect
+ *
+ * For superpageblock-sized (1GB) allocations:
+ *   1. Empty superpageblocks first — no evacuation needed
+ *   2. Clean superpageblocks from almost-empty to full — less evacuation work
+ *
+ * For pageblock-sized (2MB+) sub-superpageblock allocations:
+ *   1. Clean superpageblocks from fullest to almost-empty — pack allocations
+ *      to preserve empty superpageblocks for 1GB
+ *   2. Empty superpageblocks as last resort
+ *
+ * Returns number of candidates found.
+ */
+static int sb_collect_contig_candidates(struct zone *zone,
+					unsigned long nr_pages,
+					unsigned long *pfns, int max)
+{
+	struct superpageblock *sb;
+	int full, n = 0;
+
+	lockdep_assert_held(&zone->lock);
+
+	if (nr_pages >= SUPERPAGEBLOCK_NR_PAGES) {
+		/* 1GB+: empty superpageblocks first (no evacuation needed) */
+		list_for_each_entry(sb, &zone->spb_empty, list) {
+			if (sb->total_pageblocks < SUPERPAGEBLOCK_NR_PAGEBLOCKS)
+				continue;
+			pfns[n++] = sb->start_pfn;
+			if (n >= max)
+				return n;
+		}
+		/* Then clean superpageblocks, almost-empty first (less work) */
+		for (full = __NR_SB_FULLNESS - 1; full >= 0; full--) {
+			list_for_each_entry(sb,
+					    &zone->spb_lists[SB_CLEAN][full],
+					    list) {
+				if (sb->total_pageblocks <
+				    SUPERPAGEBLOCK_NR_PAGEBLOCKS)
+					continue;
+				pfns[n++] = sb->start_pfn;
+				if (n >= max)
+					return n;
+			}
+		}
+		return n;
+	}
+
+	/*
+	 * 2MB+ sub-superpageblock allocations.
+	 * Walk clean superpageblocks fullest-first — pack allocations into
+	 * partial superpageblocks to preserve empty ones for 1GB use.
+	 * Pick one candidate per superpageblock for diversity.
+	 */
+	for (full = SB_FULL_75; full < __NR_SB_FULLNESS; full++) {
+		list_for_each_entry(sb, &zone->spb_lists[SB_CLEAN][full], list) {
+			unsigned long pfn, sb_end;
+
+			sb_end = sb->start_pfn +
+				(unsigned long)sb->total_pageblocks *
+				pageblock_nr_pages;
+			pfn = ALIGN(sb->start_pfn, nr_pages);
+
+			if (pfn + nr_pages <= sb_end) {
+				pfns[n++] = pfn;
+				if (n >= max)
+					return n;
+			}
+		}
+	}
+	/* Empty superpageblocks as last resort for 2MB */
+	list_for_each_entry(sb, &zone->spb_empty, list) {
+		unsigned long pfn = ALIGN(sb->start_pfn, nr_pages);
+		unsigned long sb_end = sb->start_pfn +
+			(unsigned long)sb->total_pageblocks *
+			pageblock_nr_pages;
+
+		if (pfn + nr_pages <= sb_end) {
+			pfns[n++] = pfn;
+			if (n >= max)
+				return n;
+		}
+	}
+	return n;
+}
+
+/**
+ * spb_try_alloc_contig - Superpageblock-aware contiguous page allocation
+ * @zone: zone to allocate from
+ * @nr_pages: number of contiguous pages needed (>= pageblock_nr_pages)
+ * @gfp_mask: GFP mask for allocation
+ *
+ * Use superpageblock metadata to quickly find suitable ranges for contiguous
+ * allocation, avoiding the brute-force PFN scan. Each candidate is tried
+ * twice to handle transient failures (e.g., temporary page pins, racing
+ * allocations), then falls through to the next candidate.
+ *
+ * Returns: page pointer on success, NULL on failure.
+ */
+static struct page *spb_try_alloc_contig(struct zone *zone,
+					unsigned long nr_pages,
+					gfp_t gfp_mask)
+{
+	unsigned long pfns[SPB_CONTIG_MAX_CANDIDATES];
+	unsigned long flags;
+	int nr_candidates, i;
+
+	if (nr_pages < pageblock_nr_pages)
+		return NULL;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	nr_candidates = sb_collect_contig_candidates(zone, nr_pages,
+						     pfns,
+						     SPB_CONTIG_MAX_CANDIDATES);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	for (i = 0; i < nr_candidates; i++) {
+		int attempts;
+
+		for (attempts = 0; attempts < 2; attempts++) {
+			int ret;
+
+			ret = alloc_contig_frozen_range_noprof(pfns[i],
+					pfns[i] + nr_pages,
+					ACR_FLAGS_NONE, gfp_mask);
+			if (!ret)
+				return pfn_to_page(pfns[i]);
+		}
+
+		/*
+		 * Failed on this candidate — rotate its superpageblock to the
+		 * tail of its list so the next call tries fresh candidates.
+		 */
+		spin_lock_irqsave(&zone->lock, flags);
+		{
+			struct superpageblock *sb =
+				pfn_to_superpageblock(zone, pfns[i]);
+			if (sb) {
+				struct list_head *head;
+
+				if (sb->nr_free == sb->total_pageblocks)
+					head = &zone->spb_empty;
+				else
+					head = &zone->spb_lists
+						[spb_get_category(sb)]
+						[sb_get_fullness(sb, spb_get_category(sb))];
+				list_move_tail(&sb->list, head);
+			}
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+	return NULL;
+}
+
+/**
+ * sb_collect_evacuate_candidates - Find pageblocks for targeted evacuation
+ * @zone: zone to search (must hold zone->lock)
+ * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE)
+ * @sb_pfns: output array of tainted superpageblock start PFNs
+ * @max: maximum candidates to collect
+ *
+ * Find tainted superpageblocks containing pageblocks of the desired migratetype
+ * that also have movable pages to evacuate. Evacuating movable pages from
+ * these pageblocks creates buddy coalescing opportunities for high-order
+ * allocations of the desired migratetype.
+ *
+ * Returns number of candidate superpageblock PFNs found.
+ */
+static int sb_collect_evacuate_candidates(struct zone *zone, int migratetype,
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
+			bool has_matching;
+
+			if (!sb->nr_movable)
+				continue;
+
+			if (migratetype == MIGRATE_UNMOVABLE)
+				has_matching = sb->nr_unmovable > 0;
+			else if (migratetype == MIGRATE_RECLAIMABLE)
+				has_matching = sb->nr_reclaimable > 0;
+			else
+				continue;
+
+			if (!has_matching)
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
+/**
+ * spb_evacuate_for_order - Targeted evacuation of movable pages from
+ *                         unmovable/reclaimable pageblocks
+ * @zone: zone to work on
+ * @order: allocation order that failed
+ * @migratetype: desired migratetype (MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE)
+ *
+ * Instead of blind compaction, use superpageblock metadata to find pageblocks
+ * of the right migratetype in tainted superpageblocks and evacuate their
+ * movable pages. This creates buddy coalescing opportunities within
+ * the pageblock, enabling higher-order allocations.
+ *
+ * Returns true if evacuation was performed (caller should retry allocation).
+ */
+static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
+				  int migratetype)
+{
+	unsigned long sb_pfns[SPB_CONTIG_MAX_CANDIDATES];
+	unsigned long flags;
+	int nr_sbs, i;
+	bool did_evacuate = false;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	nr_sbs = sb_collect_evacuate_candidates(zone, migratetype,
+						sb_pfns,
+						SPB_CONTIG_MAX_CANDIDATES);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	for (i = 0; i < nr_sbs && !did_evacuate; i++) {
+		unsigned long pfn, end_pfn;
+
+		end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
+		for (pfn = sb_pfns[i]; pfn < end_pfn;
+		     pfn += pageblock_nr_pages) {
+			struct page *page;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			/* Superpageblocks can straddle zone boundaries. */
+			if (!zone_spans_pfn(zone, pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			if (get_pfnblock_migratetype(page, pfn) != migratetype)
+				continue;
+
+			if (!get_pfnblock_bit(page, pfn, PB_has_movable))
+				continue;
+
+			evacuate_pageblock(zone, pfn, true);
+			did_evacuate = true;
+			break;
+		}
+	}
+	return did_evacuate;
+}
+#endif /* CONFIG_COMPACTION */
+
 /**
  * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
  * @nr_pages:	Number of contiguous pages to allocate
@@ -9138,9 +9540,29 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
+	struct page *page;
 	bool skip_hugetlb = true;
 	bool skipped_hugetlb = false;
 
+	/*
+	 * First pass: superpageblock-aware search. Use superpageblock metadata
+	 * to quickly find suitable ranges, avoiding the brute-force PFN
+	 * scan. For 1GB allocations this walks spb_empty then
+	 * spb_lists[SB_CLEAN]; for 2MB+ it finds evacuatable pageblocks
+	 * in clean superpageblocks.
+	 */
+	if (nr_pages >= pageblock_nr_pages) {
+		zonelist = node_zonelist(nid, gfp_mask);
+		for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					       gfp_zone(gfp_mask), nodemask) {
+			page = spb_try_alloc_contig(zone, nr_pages, gfp_mask);
+			if (page)
+				return page;
+		}
+	}
+
+	/* Second pass: brute-force PFN scan (existing fallback) */
+
 retry:
 	zonelist = node_zonelist(nid, gfp_mask);
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
@@ -9235,6 +9657,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 	if (WARN_ON_ONCE(first_page != compound_head(first_page)))
 		return;
 
+	superpageblock_contig_mark(pfn, pfn + nr_pages, false);
+
 	if (PageHead(first_page)) {
 		WARN_ON_ONCE(order != compound_order(first_page));
 		free_frozen_pages(first_page, order);
@@ -9254,9 +9678,13 @@ EXPORT_SYMBOL(free_contig_frozen_range);
  */
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
+	unsigned long end = pfn + nr_pages;
+
 	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
 		return;
 
+	superpageblock_contig_mark(pfn, end, false);
+
 	for (; nr_pages--; pfn++)
 		__free_page(pfn_to_page(pfn));
 }
@@ -9794,6 +10222,15 @@ static int superpageblock_debugfs_show(struct seq_file *m, void *v)
 		if (empty_count)
 			seq_printf(m, "  empty: %d\n", empty_count);
 
+		{
+			int isolated_count = 0;
+
+			list_for_each_entry(sb, &zone->spb_isolated, list)
+				isolated_count++;
+			if (isolated_count)
+				seq_printf(m, "  contig_alloc: %d\n", isolated_count);
+		}
+
 		for (cat = 0; cat < __NR_SB_CATEGORIES; cat++) {
 			for (full = 0; full < __NR_SB_FULLNESS; full++) {
 				int count = 0;
@@ -9812,11 +10249,16 @@ static int superpageblock_debugfs_show(struct seq_file *m, void *v)
 		/* Per-superpageblock detail */
 		for (i = 0; i < zone->nr_superpageblocks; i++) {
 			sb = &zone->superpageblocks[i];
-			seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u\n",
-				   i, sb->start_pfn,
-				   sb->nr_unmovable, sb->nr_reclaimable,
-				   sb->nr_movable, sb->nr_reserved,
-				   sb->nr_free, sb->total_pageblocks);
+			if (sb->contig_allocated)
+				seq_printf(m, "  sb[%lu] pfn=0x%lx: contig_allocated total=%u\n",
+					   i, sb->start_pfn,
+					   sb->total_pageblocks);
+			else
+				seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u\n",
+					   i, sb->start_pfn,
+					   sb->nr_unmovable, sb->nr_reclaimable,
+					   sb->nr_movable, sb->nr_reserved,
+					   sb->nr_free, sb->total_pageblocks);
 		}
 	}
 	return 0;
-- 
2.52.0


