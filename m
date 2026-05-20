Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CB9CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398326B00C0; Wed, 20 May 2026 11:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343ED6B00C2; Wed, 20 May 2026 11:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A416B00C3; Wed, 20 May 2026 11:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1190F6B00C0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF1721C108A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:06 +0000 (UTC)
X-FDA: 84788110932.07.3494FBA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id D17F8C0031
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Mn4fAAwI;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTAVpne4dz1fuDA8W/prd0eclefaTEcXKU8By+o+BtM=;
	b=B+msTyb0GnhAfYxwuqQL3Y8FnzpcuMItRGvxD22ViT3iRcU6xQav8laNfWZj5cQtToDa8d
	/vGfZ+nBT/lDhhm6PGkl6aTPbLoFTUVAYMovvh68xs0HZb6HZRImniL69gc3qTr+RaX1Eb
	AVcptIYiR84TDb6isF8kD7FhXzadkYE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Mn4fAAwI;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289264; a=rsa-sha256;
	cv=none;
	b=8BTOfHwTa5GqLqZfOcv7BU+/uWs5eVEkCJB15YjRhW5rCSGASglcaYyew2j2nWgynv6hAy
	BtcpKENKNliTj6plxTMo1Qb2kzTTkGRoJup42WK1cJThE9Xigm3b7lIrBY6URK0dvLTeL4
	ef3m7NQRhq6K9N09Ww/3bMO5r+NgAYA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oTAVpne4dz1fuDA8W/prd0eclefaTEcXKU8By+o+BtM=; b=Mn4fAAwIAh8xgfm/ll5osiycux
	VQrzGezEmAlD19+730RJd4EA++yroMkxIhd5KKvhYXEvyxpthOGyC8Ii2Bp1zOSzP5BFNplM91otp
	l6WFd6fJIb3HaqGin5SEWwADGn3fvJIu1mpde/joRSZCiQWl+GPFdLdTAf03BFbmi9mkH9pXkTdeh
	uUtTdIOV3pJbbAWgdQhSNGTFje6Epq3TSiOwaTjVniasxdY9PP7NcB4TaBAfKwgUOud0aUcilAFwv
	abcrM2aq+dAdjLrJeex4lXoCxaGk68oD1wLF6NEV6uWD5o+yTRwJ+svwDsy/F/hjRbhAD7DMmtOoo
	bOUXH7vg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-24o2;
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
Subject: [RFC PATCH 17/40] mm: page_alloc: superpageblock-aware contiguous and higher order allocation
Date: Wed, 20 May 2026 10:59:23 -0400
Message-ID: <20260520150018.2491267-18-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gicheteqgm5hurtdr8ni1b1nhxb6iw77
X-Rspamd-Queue-Id: D17F8C0031
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779289264-411300
X-HE-Meta: U2FsdGVkX1+4ZMQz2kjcgwkzhXXCH8zg33e4+RQ7v73xzaLIh5Aa2LTuWHHBzi3k9mLAWq1cL1bAROV8E063cp0hnPrO1TwvVS/4f7rojspfhhZnRKGQQXV6Q4UAJoUxqjGMJsrJlTnvTffj3M94aY6zRHxfC1IoysXtS391jf2kmb1CNffb/QqLyblwPAFV4qqUQ06QpDa1qClBLyvpHQ8iJ2x/GbD34ewwfKWI0T0gbGOUpSYpnqmccYtIarIy+/Kr77TGjKEwMN/CXvCBNaovmcJOpq8PdHuj9fU4pAnTCxnp5v1HV3sz/TTwUSqs6arfHCz0l7p/dxRe78p30aMeb0nqVMyS6+JOs2XKmIQnKCG8/jG+B7+nenszNbQR+GeIUSX9rBLRp+fJg8il4qytXOX39WxQpK6S2+3qfamwN5+/r+ikce+lKBwF7fRxIXmpNxmkI2QYDjUNS2icqbHhLy6z+u4ZeLdzk9CwOHRcKC9Pehscv01A0W+BLDJG9nsYxM8/u9lpQbYlxLaQ28p74SEUKOrdDkYuljFTXwXxKFOawuxbwBXrYyrPAxW/M1yqoQE0jFMjbK+Y1YK7iym62KIualYtlQ8kSYDOAV0nPtMJwELvxRO8HoPKiTBmG4ZZ1fypsMKEK2R00O6rkCsCRnJ9Z/J7VytUJ6fdPAIW0jd3o0HV9+MceqdM2cz1nEzQHzuCsR15uG7GrJDNK02zxbuI+U/gsE5Ez0IC1pwG/Sfz2cN0QecJZCckdVsC5QAVhSSqJYToiwf4kMzjV9mEnab/TudfYSRkrtMlwX5pWI/HBuVS2nlsfJgDKOUbQiKUeKI/uHUQzqEYB1anAHSMn/thdiNv1Dr+m/B5oM8B4duda72Jq2HC7PG41+ronY5xqYXwlN/s3LFhOpUcq2Gx5SpRE5who0FeDnSXHInpebtC3qYnyD/MyZJYv5B4IfmkT4TyYPImkDaHJF9
 2r1VRvK7
 Vv3UiA5ZeoCXEwSzecWObOc6MfvYUhwbV4Jt0RUpRHflU+BMmCSC/wF5RFlFH8+Yl7QrQs1LQduHT+qU3mIPUcevUYns3uEgPszOUkCEONLLavT6j7C/4OoX6nFtkXyGTo02PBYrNj5DjxWntaRqQ6th3SK8lH0l3p4sf0HyLjjEOC8VBpIbXNmlLphApPqWwIwd+XoW85Q+uJhcC4ENWygswk5l/FafCqYaA/y5ClBaANMGaKhqSuG6wh0yUF9+8H8+3aTthxdjWLaa868/oIf8Yujh6omF3LSujzL1NERN0muoNFnohAjNcBEJCJWRFFpXE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/page_alloc.c        | 484 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 479 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e7d760a689f9..a0124c170ac0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1020,6 +1020,7 @@ struct superpageblock {
 	u16			nr_movable;
 	u16			nr_reserved;	/* holes, firmware, etc. */
 	u16			total_pageblocks; /* zone-clipped total */
+	bool			contig_allocated; /* all pages held by contig alloc */
 
 	/* Total free pages across all per-superpageblock free lists */
 	unsigned long		nr_free_pages;
@@ -1107,6 +1108,7 @@ struct zone {
 
 	/* Superpageblock fullness lists for allocation steering */
 	struct list_head	spb_empty;	/* completely free superpageblocks */
+	struct list_head	spb_isolated;	/* fully isolated (1GB contig alloc) */
 	struct list_head	spb_lists[__NR_SB_CATEGORIES][__NR_SB_FULLNESS];
 
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3c11c8c5ce6a..b6a07bd72c0b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -710,8 +710,30 @@ static inline enum sb_fullness sb_get_fullness(struct superpageblock *sb,
  */
 #ifdef CONFIG_COMPACTION
 static void spb_maybe_start_defrag(struct superpageblock *sb);
+static bool spb_needs_defrag(struct superpageblock *sb);
+static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
+				  int migratetype);
 #else
 static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
+static inline bool spb_needs_defrag(struct superpageblock *sb) { return false; }
+static inline bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
+					 int migratetype)
+{
+	return false;
+}
+#endif
+
+#ifdef CONFIG_CONTIG_ALLOC
+static struct page *spb_try_alloc_contig(struct zone *zone,
+					unsigned long nr_pages,
+					gfp_t gfp_mask);
+#else
+static inline struct page *spb_try_alloc_contig(struct zone *zone,
+					       unsigned long nr_pages,
+					       gfp_t gfp_mask)
+{
+	return NULL;
+}
 #endif
 
 static void spb_update_list(struct superpageblock *sb)
@@ -722,6 +744,11 @@ static void spb_update_list(struct superpageblock *sb)
 
 	list_del_init(&sb->list);
 
+	if (sb->contig_allocated) {
+		list_add_tail(&sb->list, &zone->spb_isolated);
+		return;
+	}
+
 	if (sb->nr_free == sb->total_pageblocks) {
 		list_add_tail(&sb->list, &zone->spb_empty);
 		return;
@@ -872,6 +899,45 @@ void __meminit init_pageblock_migratetype(struct page *page,
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
@@ -4311,6 +4377,17 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 
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
 
@@ -5511,6 +5588,69 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
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
+				/*
+				 * spb_try_alloc_contig() returns a page that
+				 * has already been prepped by
+				 * alloc_contig_frozen_range_noprof() (either
+				 * via the __GFP_COMP head-prep branch or via
+				 * split_free_frozen_pages()->post_alloc_hook
+				 * for non-compound).  Do not prep again here:
+				 * a second prep_new_page() trips the new-page
+				 * sanity checks and double-applies KASAN tag
+				 * setup / init-on-alloc.
+				 */
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
@@ -8692,9 +8832,16 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 {
 	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	/*
+	 * __GFP_NOMEMALLOC is allowed: GFP_TRANSHUGE sets it, and the SPB
+	 * fast path that calls into here (spb_try_alloc_contig) does not
+	 * invoke the rest of the contig-alloc reclaim/compaction machinery
+	 * that would otherwise consult memalloc reserves, so accepting the
+	 * flag is safe and lets THP allocations through.
+	 */
 	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
 				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO |
-				  __GFP_SKIP_KASAN;
+				  __GFP_SKIP_KASAN | __GFP_NOMEMALLOC;
 	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
 	/*
@@ -8889,6 +9036,8 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	}
 done:
 	undo_isolate_page_range(start, end);
+	if (!ret)
+		superpageblock_contig_mark(start, end, true);
 	return ret;
 }
 EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
@@ -8983,6 +9132,287 @@ static bool zone_spans_last_pfn(const struct zone *zone,
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
+ *   1. Empty superpageblocks first -- no evacuation needed
+ *   2. Clean superpageblocks from almost-empty to full -- less evacuation work
+ *
+ * For pageblock-sized (2MB+) sub-superpageblock allocations:
+ *   1. Clean superpageblocks from fullest to almost-empty -- pack allocations
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
+	 * Walk clean superpageblocks fullest-first -- pack allocations into
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
+			/*
+			 * -EINVAL is a permanent gfp_mask incompatibility,
+			 * not a transient race; retrying is wasted lock-
+			 * acquire churn and would also fail on every other
+			 * candidate.  Give up immediately.
+			 */
+			if (ret == -EINVAL)
+				return NULL;
+		}
+
+		/*
+		 * Failed on this candidate -- rotate its superpageblock to the
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
@@ -9016,9 +9446,29 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
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
@@ -9113,6 +9563,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 	if (WARN_ON_ONCE(first_page != compound_head(first_page)))
 		return;
 
+	superpageblock_contig_mark(pfn, pfn + nr_pages, false);
+
 	if (PageHead(first_page)) {
 		WARN_ON_ONCE(order != compound_order(first_page));
 		free_frozen_pages(first_page, order);
@@ -9132,9 +9584,13 @@ EXPORT_SYMBOL(free_contig_frozen_range);
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
@@ -9677,6 +10133,15 @@ static int superpageblock_debugfs_show(struct seq_file *m, void *v)
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
@@ -9695,12 +10160,17 @@ static int superpageblock_debugfs_show(struct seq_file *m, void *v)
 		/* Per-superpageblock detail */
 		for (i = 0; i < zone->nr_superpageblocks; i++) {
 			sb = &zone->superpageblocks[i];
-			seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u free_pages=%lu\n",
-				   i, sb->start_pfn,
-				   sb->nr_unmovable, sb->nr_reclaimable,
-				   sb->nr_movable, sb->nr_reserved,
-				   sb->nr_free, sb->total_pageblocks,
-				   sb->nr_free_pages);
+			if (sb->contig_allocated)
+				seq_printf(m, "  sb[%lu] pfn=0x%lx: contig_allocated total=%u\n",
+					   i, sb->start_pfn,
+					   sb->total_pageblocks);
+			else
+				seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u free_pages=%lu\n",
+					   i, sb->start_pfn,
+					   sb->nr_unmovable, sb->nr_reclaimable,
+					   sb->nr_movable, sb->nr_reserved,
+					   sb->nr_free, sb->total_pageblocks,
+					   sb->nr_free_pages);
 		}
 	}
 	return 0;
-- 
2.54.0


