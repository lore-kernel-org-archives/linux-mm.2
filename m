Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BAECD13D2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D7F6B00CB; Thu, 30 Apr 2026 17:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF7F6B00CC; Thu, 30 Apr 2026 17:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD846B00CD; Thu, 30 Apr 2026 17:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A96DF6B00CB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:01:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0881F401DD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:01:34 +0000 (UTC)
X-FDA: 84716443308.22.34A6F9C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF9D2A000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:01:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=UVq5qj5S;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777582892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zBhVDNrR5Ch+aCKvy8krLQSQzpzJON2M9dIn3qUdX4=;
	b=eR08mF1XYJ6DdD7eANMY1XsS4d8zdLeakM6htgCt1lSkjKpoAUpc9tU75Ngn3/bU3hPYuK
	twv8cY6Z83JlwzUppDhS/ioXVdoU3kVa1LKsDmTEai0JNicWdJs8uwU6rlPbxw0x5q+M17
	Rw7/mPXrynl5J2tqxJwTYidPUJ2mh8Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=UVq5qj5S;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777582892; a=rsa-sha256;
	cv=none;
	b=FK6YjdkqSLopRxCtqxcfFk2bJ7yHSrtiGvGMzYst7GYt7SKHxk16i4vNQeWaP+oFsbonwX
	ntoXk9Pxf4S8m7albDrRxbgN2Xv2DcicIt29JYFVwjmPAjTMMw6WAZlIxcy/1dajUPWmll
	pSmXqMIXuQvr+lOoyapnFImYj2/n+LY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3zBhVDNrR5Ch+aCKvy8krLQSQzpzJON2M9dIn3qUdX4=; b=UVq5qj5S5w0oGWT+Xd+TVuSt77
	YshsfpovcFvIEZ+f1Bm1mrdH/Tffcn2NHLm+MLfMOUnFrhDkF6GvyzoXguLcD6KWbX1mrL4V1S6C/
	sbKwccMtmQjXQyqQJdgHcLKqzcBHwRyFunnvlnyGOU9Z6JYkJEjb8DvCRxPIMSL7azUw6Rn+yUdsc
	McPEMFKrHJ2k7eZnJasOiAei5PpFw197s7MfPdEuw/DCIp3Bw6HWQx/UAdFyKlpYxNOgnx3osr9An
	0nqQcOkWUyp1GiTEntlVZVAg/0O0sSs8xtgdVN54rRy/Gk5NsYjK2guPeYwTK34lF2d8az5PNrBPA
	YaAZTLkA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3VYw;
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
Subject: [RFC PATCH 17/45] mm: page_alloc: add within-superpageblock compaction for clean superpageblocks
Date: Thu, 30 Apr 2026 16:20:46 -0400
Message-ID: <20260430202233.111010-18-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF9D2A000B
X-Stat-Signature: kjsypue5idr5dbpd5cq1ks4n7jntxa5x
X-HE-Tag: 1777582891-343983
X-HE-Meta: U2FsdGVkX1/xWKNNRoK+za5z5pIUd4c0ybelmwCQ5DguCc4/qDlyFleJLDSEFr7BdlF2siJzQ1sD3znb/7Q/huWFRL20D62BP7OerY98JrpZi3u+L9bYfeKOwjNnuMw/VlLSaqfTnkESgAkgB8P60ZK9cG9X8JL7zovPF9uAQtSdq6i2dDBUffSyoSrWkjyWa/x7VRfi0FiJZyCK46uhArsbQZcZ9wKvdfm5S3i+3UTjXHyDQbdbfloDD4UxKgU12UQ0sBuIgz3dgeJh7tmJJ0AQnSBEGVFFXUG2c/h3v92igl74XVVcsVTGr1MADvWSCw1hsQS2YCm+zR1PVKS8krwsI96JU01fItcYFGQGvX0gwYclgvKyX28Mjy4oUPXKFxQgbbWXhWPgj7kJLYBxPiVSvMJAO5x2OvV9dL5Wp1vwlb23iMCb+QlfUmFS/ZDw2r3I50PiVbe7G75aXVlrlVvSWgfTDgQqjdgfyzKCmQh/5WhDU017AZ353ewK1b4yUFgS5yfqOn5uMuMC2Mxlzhi3OS21YgQ/M/1ZkfwPvuKnwmzHrsmJvFQWSeMkV+nOLdDbSXogmi94yiVQK3mpPUbH0nk3Yzolqcox8i1DfosRNpPuzMEGg8zU0nfBeysRUlHiKWfrGg2uSAT5gVth7qx/0qbnP3hbGD0HzfInAVUl2+NX9i0weYWdILLYhyqUinYuqSZBgko6RfZF6iRffdyd4ZDWYs7XCqb/q1iaIYH+DuzaA8/0FB03f0AqElqpRgIDmltetAjopQ5bRPuDQFmfogvvxw/JOb4G2emHheYUB8ETaBs3pYC91kyBKQ20yQaU9Lu6fOHhDUMtfga7MIfHoxnKB7KxiapIYEE0obmC5G6GKdMxm5pm1m+qR3ldeflNXcj2F4/2ssP/WthisyfysKqG1bznMSjzfJ3k/r9p+m/j3MWHVvRKdEIkGVPohj3qGdLmXkPfTa/ovg7
 6QBkYN3F
 SM9Z4BzIEDUyEGOMLs6eN5hw4b0PqAh3zN9XcnQntXsXlqiya6bKhUw9P1xyWX0ZKpFAmckDZ3OrkB9jr3RAATAA/iNAc5hnlo0D8UaWJKg/KfN2nqVfMR5Q1Zh0CbqmvFPGfZYeBYw1wOPEOxp4oqF1hqVL/GyWqDsbqxCb/v3Gn8PgdPIwRSB2Pp7lfvh2BiXyGyJG4A6ArwnXsX3D/foJAxFn+GkgIua7MO5kwQgC5Uv0/fq/hR5Z9EViviUxQ8BUWsmFGRZY3sbjRA96W2x0cdzDuyBrH9FSGXGyrIFA5WKGzji6ofajpTN5rWzs4ZYElYnAfUcnRMzfk54Ab4c6YrlA6OS1TFmlJKsHg74ocPxyJPPlb1TQPna6mrufZ6fEl7Rsqj/UR18Uscyz/E4STmHEFuQM9FUme
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Extend the superpageblock defragmentation framework to handle clean
superpageblocks in addition to tainted ones. While tainted superpageblock
defrag evacuates movable pages out to free up pageblocks, clean
superpageblock compaction migrates pages *within* the same superpageblock
to consolidate scattered free pages into whole free pageblocks.

The key components:

- spb_needs_defrag() and spb_defrag_done() now handle both categories: both
  use the same nr_free < 2 and nr_free_pages thresholds, with tainted SBs
  additionally checking nr_movable.

- spb_defrag_superpageblock() becomes a dispatcher that calls either
  spb_defrag_tainted() (existing evacuation logic) or
  spb_defrag_clean() (new compaction logic).

- spb_defrag_clean() scans pageblocks in the superpageblock,
  skipping fully-free (PB_all_free) and PCP-owned pageblocks, and calls
  compact_pageblock_in_spb() on candidates.

- compact_pageblock_in_spb() uses the same isolate/migrate loop pattern as
  evacuate_pageblock(), but with a custom migration target allocator
  (alloc_spb_compaction_target) that allocates pages exclusively from the
  superpageblock's own free lists.

Also make the compaction code superpageblock-aware:

- Search per-superpageblock free lists instead of zone free lists for
  migration targets, since with SPBs enabled all pages live on per-
  superpageblock free lists.

- Fix PB_has_movable check for zones with non-aligned start PFNs by using
  zone_start_pfn for pageblock boundary checks.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |   1 +
 mm/compaction.c        | 272 ++++++++++++++++++++++----------
 mm/page_alloc.c        | 343 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 501 insertions(+), 115 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 61fe939e7c0f..ba6f08295ff9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -942,6 +942,7 @@ struct superpageblock {
 	struct work_struct	defrag_work;
 	struct irq_work		defrag_irq_work;
 	bool			defrag_active;
+	unsigned long		defrag_cursor;
 	/*
 	 * Back-off state after a no-op defrag pass: defer the next attempt
 	 * until either nr_free_pages has grown by at least pageblock_nr_pages
diff --git a/mm/compaction.c b/mm/compaction.c
index 88ba88340f3b..0e9b4b3ca59b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1321,9 +1321,19 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 * isolated (pinned, writeback, dirty, etc.), leave the
 		 * flag set so a future migration attempt can try again.
 		 */
-		if (!nr_isolated && !movable_skipped && valid_page)
-			superpageblock_clear_has_movable(cc->zone,
-							valid_page);
+		if (!nr_isolated && !movable_skipped && valid_page) {
+			unsigned long pb_pfn = pageblock_start_pfn(start_pfn);
+
+			/*
+			 * start_pfn may not be pageblock-aligned when the
+			 * zone start is not aligned (e.g. DMA zone at PFN 1).
+			 * Skip the PB_has_movable update if the pageblock
+			 * start falls below the zone.
+			 */
+			if (pb_pfn >= cc->zone->zone_start_pfn)
+				superpageblock_clear_has_movable(cc->zone,
+								valid_page);
+		}
 	}
 
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
@@ -1577,45 +1587,70 @@ static void fast_isolate_freepages(struct compact_control *cc)
 	for (order = cc->search_order;
 	     !page && order >= 0;
 	     order = next_search_order(cc, order)) {
-		struct free_area *area = &cc->zone->free_area[order];
-		struct list_head *freelist;
-		struct page *freepage;
+		struct list_head *freelist = NULL;
+		struct page *freepage = NULL;
 		unsigned long flags;
 		unsigned int order_scanned = 0;
 		unsigned long high_pfn = 0;
 
-		if (!area->nr_free)
+		if (!cc->zone->free_area[order].nr_free)
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
-		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
-			unsigned long pfn;
-
-			order_scanned++;
-			nr_scanned++;
-			pfn = page_to_pfn(freepage);
-
-			if (pfn >= highest)
-				highest = max(pageblock_start_pfn(pfn),
-					      cc->zone->zone_start_pfn);
-
-			if (pfn >= low_pfn) {
-				cc->fast_search_fail = 0;
-				cc->search_order = order;
-				page = freepage;
-				break;
-			}
 
-			if (pfn >= min_pfn && pfn > high_pfn) {
-				high_pfn = pfn;
+		/*
+		 * With superpageblocks, free pages live on per-SPB free
+		 * lists rather than zone-level free lists.  Iterate all
+		 * SPBs to find candidate pages.
+		 */
+		{
+			struct zone *zone = cc->zone;
+			unsigned long si, nr_spb = zone->nr_superpageblocks;
+
+			for (si = 0; !page && order_scanned < limit; si++) {
+				struct free_area *area;
+
+				if (nr_spb) {
+					if (si >= nr_spb)
+						break;
+					area = &zone->superpageblocks[si].free_area[order];
+				} else {
+					if (si > 0)
+						break;
+					area = &zone->free_area[order];
+				}
 
-				/* Shorten the scan if a candidate is found */
-				limit >>= 1;
+				freelist = &area->free_list[MIGRATE_MOVABLE];
+				list_for_each_entry_reverse(freepage,
+							    freelist,
+							    buddy_list) {
+					unsigned long pfn;
+
+					order_scanned++;
+					nr_scanned++;
+					pfn = page_to_pfn(freepage);
+
+					if (pfn >= highest)
+						highest = max(
+						    pageblock_start_pfn(pfn),
+						    zone->zone_start_pfn);
+
+					if (pfn >= low_pfn) {
+						cc->fast_search_fail = 0;
+						cc->search_order = order;
+						page = freepage;
+						break;
+					}
+
+					if (pfn >= min_pfn && pfn > high_pfn) {
+						high_pfn = pfn;
+						limit >>= 1;
+					}
+
+					if (order_scanned >= limit)
+						break;
+				}
 			}
-
-			if (order_scanned >= limit)
-				break;
 		}
 
 		/* Use a maximum candidate pfn if a preferred one was not found */
@@ -1624,10 +1659,24 @@ static void fast_isolate_freepages(struct compact_control *cc)
 
 			/* Update freepage for the list reorder below */
 			freepage = page;
+
+			/*
+			 * high_pfn page may be on a different SPB's list
+			 * than the last one scanned; fix up freelist.
+			 */
+			if (cc->zone->nr_superpageblocks) {
+				struct superpageblock *sb;
+
+				sb = pfn_to_superpageblock(cc->zone,
+							   high_pfn);
+				if (sb)
+					freelist = &sb->free_area[order].free_list[MIGRATE_MOVABLE];
+			}
 		}
 
 		/* Reorder to so a future search skips recent pages */
-		move_freelist_head(freelist, freepage);
+		if (freelist && freepage)
+			move_freelist_head(freelist, freepage);
 
 		/* Isolate the page if available */
 		if (page) {
@@ -2021,47 +2070,77 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 	for (order = cc->order - 1;
 	     order >= PAGE_ALLOC_COSTLY_ORDER && !found_block && nr_scanned < limit;
 	     order--) {
-		struct free_area *area = &cc->zone->free_area[order];
-		struct list_head *freelist;
 		unsigned long flags;
 		struct page *freepage;
 
-		if (!area->nr_free)
+		if (!cc->zone->free_area[order].nr_free)
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
-		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry(freepage, freelist, buddy_list) {
-			unsigned long free_pfn;
 
-			if (nr_scanned++ >= limit) {
-				move_freelist_tail(freelist, freepage);
-				break;
-			}
+		/*
+		 * With superpageblocks, free pages live on per-SPB free
+		 * lists.  Iterate all SPBs to find candidates.
+		 */
+		{
+			struct zone *zone = cc->zone;
+			unsigned long si, nr_spb = zone->nr_superpageblocks;
+
+			for (si = 0; !found_block && nr_scanned < limit; si++) {
+				struct free_area *area;
+				struct list_head *freelist;
+
+				if (nr_spb) {
+					if (si >= nr_spb)
+						break;
+					area = &zone->superpageblocks[si].free_area[order];
+				} else {
+					if (si > 0)
+						break;
+					area = &zone->free_area[order];
+				}
 
-			free_pfn = page_to_pfn(freepage);
-			if (free_pfn < high_pfn) {
-				/*
-				 * Avoid if skipped recently. Ideally it would
-				 * move to the tail but even safe iteration of
-				 * the list assumes an entry is deleted, not
-				 * reordered.
-				 */
-				if (get_pageblock_skip(freepage))
-					continue;
-
-				/* Reorder to so a future search skips recent pages */
-				move_freelist_tail(freelist, freepage);
-
-				update_fast_start_pfn(cc, free_pfn);
-				pfn = pageblock_start_pfn(free_pfn);
-				if (pfn < cc->zone->zone_start_pfn)
-					pfn = cc->zone->zone_start_pfn;
-				cc->fast_search_fail = 0;
-				found_block = true;
-				break;
+				freelist = &area->free_list[MIGRATE_MOVABLE];
+				list_for_each_entry(freepage, freelist,
+						    buddy_list) {
+					unsigned long free_pfn;
+
+					if (nr_scanned++ >= limit) {
+						move_freelist_tail(freelist,
+								   freepage);
+						break;
+					}
+
+					free_pfn = page_to_pfn(freepage);
+					if (free_pfn < high_pfn) {
+						/*
+						 * Avoid if skipped recently.
+						 * Ideally it would move to
+						 * the tail but even safe
+						 * iteration of the list
+						 * assumes an entry is deleted,
+						 * not reordered.
+						 */
+						if (get_pageblock_skip(freepage))
+							continue;
+
+						move_freelist_tail(freelist,
+								   freepage);
+
+						update_fast_start_pfn(cc,
+								      free_pfn);
+						pfn = pageblock_start_pfn(
+								free_pfn);
+						if (pfn < zone->zone_start_pfn)
+							pfn = zone->zone_start_pfn;
+						cc->fast_search_fail = 0;
+						found_block = true;
+						break;
+					}
+				}
 			}
 		}
+
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 	}
 
@@ -2348,32 +2427,57 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 	/* Direct compactor: Is a suitable page free? */
 	ret = COMPACT_NO_SUITABLE_PAGE;
 	for (order = cc->order; order < NR_PAGE_ORDERS; order++) {
-		struct free_area *area = &cc->zone->free_area[order];
+		struct zone *zone = cc->zone;
+		unsigned long si, nr_spb = zone->nr_superpageblocks;
 
-		/* Job done if page is free of the right migratetype */
-		if (!free_area_empty(area, migratetype))
-			return COMPACT_SUCCESS;
+		/* Zone-level nr_free is maintained even with SPBs */
+		if (!zone->free_area[order].nr_free)
+			continue;
 
-#ifdef CONFIG_CMA
-		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
-		if (migratetype == MIGRATE_MOVABLE &&
-			!free_area_empty(area, MIGRATE_CMA))
-			return COMPACT_SUCCESS;
-#endif
 		/*
-		 * Job done if allocation would steal freepages from
-		 * other migratetype buddy lists.
+		 * With superpageblocks, free pages live on per-SPB free
+		 * lists.  Check all SPBs for a suitable page.
 		 */
-		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
+		for (si = 0; ; si++) {
+			struct free_area *area;
+
+			if (nr_spb) {
+				if (si >= nr_spb)
+					break;
+				area = &zone->superpageblocks[si].free_area[order];
+			} else {
+				if (si > 0)
+					break;
+				area = &zone->free_area[order];
+			}
+
+			/* Job done if page is free of the right migratetype */
+			if (!free_area_empty(area, migratetype))
+				return COMPACT_SUCCESS;
+
+#ifdef CONFIG_CMA
+			/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
+			if (migratetype == MIGRATE_MOVABLE &&
+				!free_area_empty(area, MIGRATE_CMA))
+				return COMPACT_SUCCESS;
+#endif
 			/*
-			 * Movable pages are OK in any pageblock. If we are
-			 * stealing for a non-movable allocation, make sure
-			 * we finish compacting the current pageblock first
-			 * (which is assured by the above migrate_pfn align
-			 * check) so it is as free as possible and we won't
-			 * have to steal another one soon.
+			 * Job done if allocation would steal freepages from
+			 * other migratetype buddy lists.
 			 */
-			return COMPACT_SUCCESS;
+			if (find_suitable_fallback(area, order, migratetype,
+						   true) >= 0)
+				/*
+				 * Movable pages are OK in any pageblock. If we
+				 * are stealing for a non-movable allocation,
+				 * make sure we finish compacting the current
+				 * pageblock first (which is assured by the
+				 * above migrate_pfn align check) so it is as
+				 * free as possible and we won't have to steal
+				 * another one soon.
+				 */
+				return COMPACT_SUCCESS;
+		}
 	}
 
 out:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07d2926ffb3d..54b9a69bda10 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8199,17 +8199,23 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn,
  * - Skip superpageblocks with no movable pages (nothing to evacuate)
  */
 
-/* Target free space: 3 pageblocks worth of free pages */
-#define SPB_DEFRAG_FREE_PAGES_TARGET	(3UL * pageblock_nr_pages)
+/*
+ * Target free space for clean SPB internal compaction: at least a quarter
+ * of the superpageblock must be free before we attempt to consolidate
+ * scattered free pages into whole free pageblocks. Below this threshold
+ * the work-to-payoff ratio is poor — we walk the whole SPB and migrate
+ * a handful of pages without producing a usable free pageblock.
+ */
+#define SPB_DEFRAG_FREE_PAGES_TARGET	(SUPERPAGEBLOCK_NR_PAGES / 4)
 
 /**
  * spb_needs_defrag - Check if a superpageblock needs defragmentation
  * @sb: superpageblock to check (may be NULL)
  *
- * Returns false for NULL, non-tainted, or clean superpageblocks.
- * A tainted superpageblock needs defrag if it has movable pages that can
- * be evacuated AND free space is running low (1 or fewer free
- * pageblocks, or less than 2 pageblocks worth of free pages).
+ * For tainted superpageblocks: defrag is needed when there are movable
+ * pageblocks that can be evacuated AND free space is running low.
+ * For clean superpageblocks: compaction is needed when free pages are
+ * scattered (plenty of free pages but few whole free pageblocks).
  */
 /*
  * Cooldown between defrag attempts that made no progress, in seconds.
@@ -8223,9 +8229,6 @@ static bool spb_needs_defrag(struct superpageblock *sb)
 	if (!sb)
 		return false;
 
-	if (spb_get_category(sb) != SB_TAINTED)
-		return false;
-
 	/*
 	 * Back off if the previous pass made no progress: do not retry until
 	 * either the cooldown elapses or free pages have grown by at least a
@@ -8246,16 +8249,30 @@ static bool spb_needs_defrag(struct superpageblock *sb)
 	 * Maintain the tainted reserve so unmovable claims always
 	 * find room in existing tainted superpageblocks.
 	 */
-	return sb->nr_movable > 0 &&
-	       sb->nr_free < SPB_TAINTED_RESERVE;
+	if (spb_get_category(sb) == SB_TAINTED)
+		return sb->nr_movable > 0 &&
+		       sb->nr_free < SPB_TAINTED_RESERVE;
+
+	/*
+	 * Clean superpageblocks: compact scattered free pages into whole
+	 * free pageblocks.  Needs internal free space as destination.
+	 */
+	if (sb->nr_free >= 2)
+		return false;
+
+	if (sb->nr_free_pages < SPB_DEFRAG_FREE_PAGES_TARGET)
+		return false;
+
+	return true;
 }
 
 /**
- * spb_defrag_done - Check if defrag target has been reached
+ * spb_defrag_done - Check if defrag/compaction should stop
  * @sb: superpageblock being defragmented
  *
- * Stop defragmenting when the superpageblock has enough free space
- * or there are no more movable pages to evacuate.
+ * Stop when the superpageblock has enough free pageblocks, when free
+ * pages drop too low to be worth continuing, or (for tainted
+ * superpageblocks) when there are no more movable pages to evacuate.
  */
 static bool spb_defrag_done(struct superpageblock *sb)
 {
@@ -8264,49 +8281,311 @@ static bool spb_defrag_done(struct superpageblock *sb)
 	 * the reserve of free pageblocks is restored, or until there
 	 * are no more movable pages to evacuate.
 	 */
-	return !sb->nr_movable ||
-	       sb->nr_free >= SPB_TAINTED_RESERVE;
+	if (spb_get_category(sb) == SB_TAINTED)
+		return !sb->nr_movable ||
+		       sb->nr_free >= SPB_TAINTED_RESERVE;
+
+	/* Clean superpageblocks: stop when enough free pageblocks exist */
+	if (sb->nr_free >= 2)
+		return true;
+
+	if (sb->nr_free_pages < SPB_DEFRAG_FREE_PAGES_TARGET)
+		return true;
+
+	return false;
+}
+
+static void spb_clear_skip_bits(struct superpageblock *sb)
+{
+	unsigned long pfn, end_pfn;
+	struct zone *zone = sb->zone;
+
+	end_pfn = sb->start_pfn + SUPERPAGEBLOCK_NR_PAGES;
+
+	for (pfn = sb->start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+
+		if (!pfn_valid(pfn))
+			continue;
+		if (!zone_spans_pfn(zone, pfn))
+			continue;
+
+		page = pfn_to_page(pfn);
+		clear_pageblock_skip(page);
+	}
 }
 
 /**
- * spb_defrag_superpageblock - evacuate movable pages from a tainted superpageblock
+ * spb_defrag_tainted - evacuate movable pages from a tainted superpageblock
  * @sb: the tainted superpageblock to defragment
  *
  * Find any pageblock with movable pages (PB_has_movable) and evacuate
  * them, leaving only unmovable, reclaimable, and free pages behind.
  * Stop when the free space target is reached.
  */
-static void spb_defrag_superpageblock(struct superpageblock *sb)
+static void spb_defrag_tainted(struct superpageblock *sb)
 {
-	unsigned long pfn, end_pfn;
+	unsigned long pfn, end_pfn, start_pfn, cursor;
 	struct zone *zone = sb->zone;
+	bool wrapped = false;
 
 	if (!sb->nr_movable)
 		return;
 
-	end_pfn = sb->start_pfn + SUPERPAGEBLOCK_NR_PAGES;
+	start_pfn = sb->start_pfn;
+	end_pfn = start_pfn + SUPERPAGEBLOCK_NR_PAGES;
 
-	for (pfn = sb->start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+	cursor = sb->defrag_cursor;
+	if (cursor < start_pfn || cursor >= end_pfn) {
+		cursor = start_pfn;
+		spb_clear_skip_bits(sb);
+	}
+
+	pfn = cursor;
+
+	while (pfn < end_pfn) {
 		struct page *page;
 
 		if (spb_defrag_done(sb))
-			return;
+			goto out;
 
 		if (!pfn_valid(pfn))
-			continue;
+			goto next;
+
+		if (!zone_spans_pfn(zone, pfn))
+			goto next;
 
 		page = pfn_to_page(pfn);
 
-		/* Skip pageblocks without movable pages */
 		if (!get_pfnblock_bit(page, pfn, PB_has_movable))
-			continue;
+			goto next;
 
-		/* Skip if fully free — nothing to evacuate */
 		if (get_pfnblock_bit(page, pfn, PB_all_free))
-			continue;
+			goto next;
+
+		if (get_pageblock_skip(page))
+			goto next;
 
 		evacuate_pageblock(zone, pfn, true);
+next:
+		pfn += pageblock_nr_pages;
+		if (pfn >= end_pfn && !wrapped) {
+			spb_clear_skip_bits(sb);
+			pfn = start_pfn;
+			wrapped = true;
+		}
+		if (wrapped && pfn > cursor)
+			break;
+	}
+out:
+	sb->defrag_cursor = pfn;
+}
+
+/*
+ * Within-superpageblock compaction: migrate pages from partially-used
+ * pageblocks into free space within the same superpageblock, consolidating
+ * scattered free pages into whole free pageblocks.
+ */
+
+struct spb_compaction_control {
+	struct superpageblock	*sb;
+	struct zone		*zone;
+};
+
+/*
+ * alloc_spb_compaction_target - allocate a migration target page from
+ * within the same superpageblock's free lists.
+ *
+ * This is a custom migration target allocator that restricts allocations
+ * to the superpageblock being compacted, ensuring pages stay within the SB.
+ */
+static struct folio *alloc_spb_compaction_target(struct folio *src,
+		unsigned long private)
+{
+	struct spb_compaction_control *scc =
+		(struct spb_compaction_control *)private;
+	struct superpageblock *sb = scc->sb;
+	struct zone *zone = scc->zone;
+	int src_order = folio_order(src);
+	int order = src_order;
+	int migratetype = MIGRATE_MOVABLE;
+	struct free_area *area;
+	struct page *target;
+
+	spin_lock_irq(&zone->lock);
+
+	area = &sb->free_area[order];
+	target = get_page_from_free_area(area, migratetype);
+	if (!target) {
+		/* Try to split a higher-order block within this SB */
+		for (order = src_order + 1; order < NR_PAGE_ORDERS; order++) {
+			area = &sb->free_area[order];
+			target = get_page_from_free_area(area, migratetype);
+			if (target)
+				break;
+		}
+	}
+
+	if (target)
+		page_del_and_expand(zone, target, src_order, order, migratetype);
+
+	spin_unlock_irq(&zone->lock);
+
+	if (!target)
+		return NULL;
+
+	prep_new_page(target, src_order, __GFP_MOVABLE | __GFP_COMP, 0);
+	set_page_refcounted(target);
+	return page_rmappable_folio(target);
+}
+
+static void free_spb_compaction_target(struct folio *folio,
+		unsigned long private)
+{
+	folio_put(folio);
+}
+
+/*
+ * compact_pageblock_in_spb - migrate pages from a partially-used pageblock
+ * into free space within the same superpageblock.
+ *
+ * Similar to evacuate_pageblock() but uses the within-SB allocator
+ * so pages stay inside the superpageblock being compacted.
+ */
+static void compact_pageblock_in_spb(struct superpageblock *sb,
+				    struct zone *zone,
+				    unsigned long start_pfn)
+{
+	unsigned long end_pfn = start_pfn + pageblock_nr_pages;
+	unsigned long pfn = start_pfn;
+	int nr_reclaimed;
+	int ret = 0;
+	struct compact_control cc = {
+		.nr_migratepages = 0,
+		.order = -1,
+		.zone = zone,
+		.mode = MIGRATE_SYNC_LIGHT,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+	};
+	struct spb_compaction_control scc = {
+		.sb = sb,
+		.zone = zone,
+	};
+
+	INIT_LIST_HEAD(&cc.migratepages);
+
+	while (pfn < end_pfn || !list_empty(&cc.migratepages)) {
+		if (list_empty(&cc.migratepages)) {
+			cc.nr_migratepages = 0;
+			cc.migrate_pfn = pfn;
+			ret = isolate_migratepages_range(&cc, pfn, end_pfn);
+			if (ret && ret != -EAGAIN)
+				break;
+			pfn = cc.migrate_pfn;
+			if (list_empty(&cc.migratepages))
+				break;
+		}
+
+		nr_reclaimed = reclaim_clean_pages_from_list(zone,
+							&cc.migratepages);
+		cc.nr_migratepages -= nr_reclaimed;
+
+		if (!list_empty(&cc.migratepages)) {
+			ret = migrate_pages(&cc.migratepages,
+					    alloc_spb_compaction_target,
+					    free_spb_compaction_target,
+					    (unsigned long)&scc, cc.mode,
+					    MR_COMPACTION, NULL);
+			if (ret) {
+				putback_movable_pages(&cc.migratepages);
+				break;
+			}
+		}
+
+		cond_resched();
+	}
+
+	if (!list_empty(&cc.migratepages))
+		putback_movable_pages(&cc.migratepages);
+}
+
+/**
+ * spb_defrag_clean - compact a clean superpageblock internally
+ * @sb: the clean superpageblock to compact
+ *
+ * Scan pageblocks in the superpageblock looking for partially-used ones.
+ * Skip fully free pageblocks and pageblocks recently marked unsuitable
+ * by the pageblock_skip bit; PCPBuddy-cached pages within an otherwise
+ * compactable pageblock are skipped per-page by isolate_migratepages_block().
+ * Migrate pages from the best candidate into free space within the same
+ * superpageblock.
+ */
+static void spb_defrag_clean(struct superpageblock *sb)
+{
+	unsigned long pfn, end_pfn, start_pfn, cursor;
+	struct zone *zone = sb->zone;
+	bool wrapped = false;
+
+	start_pfn = sb->start_pfn;
+	end_pfn = start_pfn + SUPERPAGEBLOCK_NR_PAGES;
+
+	cursor = sb->defrag_cursor;
+	if (cursor < start_pfn || cursor >= end_pfn) {
+		cursor = start_pfn;
+		spb_clear_skip_bits(sb);
+	}
+
+	pfn = cursor;
+
+	while (pfn < end_pfn) {
+		struct page *page;
+
+		if (spb_defrag_done(sb))
+			goto out;
+
+		if (!pfn_valid(pfn))
+			goto next;
+
+		if (!zone_spans_pfn(zone, pfn))
+			goto next;
+
+		page = pfn_to_page(pfn);
+
+		if (get_pfnblock_bit(page, pfn, PB_all_free))
+			goto next;
+
+		if (get_pageblock_skip(page))
+			goto next;
+
+		compact_pageblock_in_spb(sb, zone, pfn);
+next:
+		pfn += pageblock_nr_pages;
+		if (pfn >= end_pfn && !wrapped) {
+			spb_clear_skip_bits(sb);
+			pfn = start_pfn;
+			wrapped = true;
+		}
+		if (wrapped && pfn > cursor)
+			break;
 	}
+out:
+	sb->defrag_cursor = pfn;
+}
+
+/**
+ * spb_defrag_superpageblock - defragment a superpageblock
+ * @sb: the superpageblock to defragment
+ *
+ * Dispatch to the appropriate defrag strategy based on superpageblock
+ * category: evacuate movable pages from tainted superpageblocks, or
+ * compact scattered free pages within clean superpageblocks.
+ */
+static void spb_defrag_superpageblock(struct superpageblock *sb)
+{
+	if (spb_get_category(sb) == SB_TAINTED)
+		spb_defrag_tainted(sb);
+	else
+		spb_defrag_clean(sb);
 }
 
 static void spb_defrag_work_fn(struct work_struct *work)
@@ -8357,10 +8636,12 @@ static void spb_defrag_irq_work_fn(struct irq_work *work)
  * @sb: superpageblock whose counters just changed
  *
  * Called from counter update paths (under zone->lock). If the
- * superpageblock is tainted and running low on free space, schedule
- * irq_work to queue defrag work outside the allocator's lock context.
- * The irq_work handler is set up by pageblock_evacuate_init();
- * before that runs, defrag_irq_work.func is NULL and we skip.
+ * superpageblock needs defragmentation — either evacuation of movable
+ * pages from a tainted superpageblock, or internal compaction of a
+ * clean superpageblock — schedule irq_work to queue defrag work outside
+ * the allocator's lock context. The irq_work handler is set up by
+ * pageblock_evacuate_init(); before that runs, defrag_irq_work.func
+ * is NULL and we skip.
  */
 static void spb_maybe_start_defrag(struct superpageblock *sb)
 {
-- 
2.52.0


