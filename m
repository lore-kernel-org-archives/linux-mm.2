Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F21CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89EC96B00BC; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0726B00B9; Wed, 20 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6976B00BB; Wed, 20 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56D866B00B9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26B0E1C0606
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:02 +0000 (UTC)
X-FDA: 84788110764.03.AEAD864
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id 48C7CC0013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=gIUAUZ5c;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXenHoeHOgHgeBlGRM9WW9ffCAAzTAUJFryLoW48gj8=;
	b=siTMSKoaAbpHyjLDR+lHWKHrinBB4y6Suo6CEncWUQaCxOeevli7WAiigOGdzFPaMpxKMX
	4ah1MhIQnimKBm04K1cYYHuJClHMvtqhUbpTH4rbaFwIvD5jTcbILQqr/nswqeHLvRji37
	A9XalwABLA6oSoGZMDSvs6pGfYQm8IQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289259; a=rsa-sha256;
	cv=none;
	b=UR1KxsPAEPuMNBmOffl1SQUJNmh/Ws8mfd7C0PfMQuFsZGro6/V+Urb2a7dBymKa9XEIhD
	8oceXJNm+j9ru6/8ScYzkXqZ/ewU456hw71IfB0ZXlmNfzHLj2Qz8cHv5CwnNPRBswwbvl
	/dVu8KFwHMlNabJ9y3MEi1sFAnYsPzw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=gIUAUZ5c;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aXenHoeHOgHgeBlGRM9WW9ffCAAzTAUJFryLoW48gj8=; b=gIUAUZ5cFcoJFrjGwzCASCJMZ4
	1ZmNU3h/vNkDRRDZ8A6jQKCTOv4ZPYWl5auCHT2uJ7smyBOTLCuSFPsxfqyen9Dq8fdm2fAPg7cPP
	R5SVfSCJSYWi0oWRCfqueFIakOKKVhmIWiTTT5SzdBBN3+xk57i+cx3fMgujoWTZUBY+6i3Txq/TD
	3tZG2ZiHbbuHj7y6iT1lm73KI2wVc/GMQdFet1FC5V84ch6dNAooa55/I5w9qPAPdAhq8xhrfWB8c
	y3xXFoTFrAc+7euEuq6cFCdy50fWdTfOPMfHbhosphsifXr6F+au+6nvtH1vUMOmAGe5jfk6WF2BZ
	6Pj8DQKg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1wKR;
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
Subject: [RFC PATCH 16/40] mm: compaction: walk per-superpageblock free lists for migration targets
Date: Wed, 20 May 2026 10:59:22 -0400
Message-ID: <20260520150018.2491267-17-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48C7CC0013
X-Stat-Signature: wttassxgi1k3x67h8i8yjmsrzobchfzh
X-Rspam-User: 
X-HE-Tag: 1779289259-651619
X-HE-Meta: U2FsdGVkX1/1GsgbC9WO4rn3cDBjiGy+l5I2o56NSsCahjven7cRAkVM49EQhApTSy7pf/J/UFw+NbCEMrHlWGdLZzrPa/iwKj/FkEOV65CqtM6NZ31I2+KwKbEAv9WtowmgodxbrzDqonL21sgL+02rZ0ci4sYmJiBUlumonrxfPdAqZCARRKNwuloI0QRMn3oEMflq5KKy8cRcDg/yh5Zln2qvvFdTY843M05g9aKcIRySD1UX0dmuQmTKxjDCBAlSc9h4Fbtlth3Ma9OAJ1bvUsugodZ6j2aoDuO14HZADRvnR6cFLmeShzXQZkhXX3xRx8rqa2lNVvoiTeVK5GbHXfr2R8qGnhjG+IPKY+S1vwU8JCYjr3vQ8qahPGQSoRr8O/TBbR1VMyBYVPoVtNRgr/Le+4S2SMi6AJYieZyQAqQLdkCFkvexxOiKQYY9yhxR6elT9xE85UOgtK2Ef5jHEUm6PVoHDVU0o5d+TD8RwQrIQ1gybH+LsfxKS0NG04fm6nW5Tb2AX6yvSbIYQU1Jdh8zSFI8x2/JmgMwBikBIay+9B621HZIMFG8J5YTbzo+L+niU7GalzyBpkQOo+2ZQcQR0/aqfDFkNfnm17FtaNU9eKWadBiMkWoxzLJ38pyQhZcTh8bpM5wB+b8oTGxKugdgmXLLmUXLoIdgaKOjJRDUYZui2Z2NCcEpI8VAVHnNKwgP28FZqmnVTk/EFai0t2SmEC1LmF3QZQQtIRku5YmCd6990X2D/5rEWw32a8lQpApYoI5MGDbuB+aNG2r4P+Wc5qxnoQ8ITPQbNSj+QuzcUP4rT+9ko2I6tWEHmEpnzzcPHetbHtN8kry6GW7+qDfBA6pMsyP98Ddp2k0ZT+pA4pl5NXQP1sMS2+KwCw5GcPlciIm5XwYvv7RSW31RQLqZeKuBqWyKr5YoziTF3f8AdEsgxehO9d4Gw2fmUgrRcJnM5nHgik62yg+
 4buScFII
 3SQmLfuLvgUnU7IU1eRIfYjIGa1X5lHAr8dgEmAIUCp9prY2BfneV70/h/2IQsnSvyqJeJNcqO1po0/v6SUy2iwXGvmYSdu8/t1ydy8OifvhjFMEwS5KHBOnnIG2NvZM8wLPi+u5MYOvA0dWla9ZoCTvsE0GaFwC20fIWqTvusYj08ArSiS/1GtHPwRjT38YOnndG53q1THhXYwQ0tgX+9X5OiaJpqPhPxTpTdQq4vpXyWbjAdiZ1m1vznxDZFE1kudLNjq00f3LfPetpQ4dB8EH5xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Free pages live on per-SPB free lists
rather than zone-level free_lists. Standard compaction's free-page
scanner needs to walk the per-SPB free lists to find migration targets;
without this, kcompactd would see "nothing free" even when SPBs hold
plenty of order-9 buddies.

Also wire superpageblock_set_has_movable() and the corresponding clear
calls into the migration-source-isolation and free-page-isolation paths,
so pageblock movability bookkeeping stays correct as compaction shuffles
contents around.

Fix the PB_has_movable check for zones whose start_pfn is not aligned
to pageblock_order (DMA32 with reserved memory at the bottom).

This is the compaction-side infrastructure for SPB-aware standard
compaction. Subsequent commits add the predicates that let kcompactd
skip useless tainted SPBs.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |   1 +
 mm/compaction.c        | 337 ++++++++++++++++++++++++++++-------------
 mm/page_alloc.c        | 135 ++++++++++++-----
 3 files changed, 330 insertions(+), 143 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6cba69603918..e7d760a689f9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1039,6 +1039,7 @@ struct superpageblock {
 	struct work_struct	defrag_work;
 	struct irq_work		defrag_irq_work;
 	bool			defrag_active;
+	unsigned long		defrag_cursor;
 	/*
 	 * Back-off state after a no-op defrag pass: defer the next attempt
 	 * until either nr_free_pages has grown by at least pageblock_nr_pages
diff --git a/mm/compaction.c b/mm/compaction.c
index 6d2aefdbc0c8..e4ba21072435 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -867,7 +867,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
-	bool movable_skipped = false;
+	bool movable_seen = false;
+	bool pb_cleared = false;
 	int ret = 0;
 
 	cc->migrate_pfn = low_pfn;
@@ -964,6 +965,26 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				goto isolate_abort;
 			}
 			valid_page = page;
+
+			/*
+			 * Clear PB_has_movable up-front. The scan below will
+			 * re-set it if any movable page is encountered. This
+			 * self-corrects stale bits left behind when movable
+			 * content was previously freed without the bit being
+			 * cleared (e.g. PB held both movable and unmovable
+			 * pages, so mark_pageblock_free was never reached).
+			 * A racing allocator that places a movable page in
+			 * this PB will set the bit too; both setters are
+			 * idempotent, so the bit ends up correctly set.
+			 */
+			if (pageblock_start_pfn(start_pfn) >=
+			    cc->zone->zone_start_pfn &&
+			    get_pfnblock_bit(valid_page, low_pfn,
+					     PB_has_movable)) {
+				superpageblock_clear_has_movable(cc->zone,
+								 valid_page);
+				pb_cleared = true;
+			}
 		}
 
 		if (PageHuge(page)) {
@@ -979,12 +1000,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
 				}
-				/*
-				 * Skipped a movable page; clearing
-				 * PB_has_movable here would orphan SPB type
-				 * counters (debugfs invariant 1).
-				 */
-				movable_skipped = true;
+				/* HugeTLB page is movable content. */
+				movable_seen = true;
 				goto isolate_fail;
 			}
 			/* for alloc_contig case */
@@ -1064,12 +1081,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
 				}
-				/*
-				 * Skipped a movable compound page; clearing
-				 * PB_has_movable here would orphan SPB type
-				 * counters (debugfs invariant 1).
-				 */
-				movable_skipped = true;
+				/* THP/compound page is movable content. */
+				movable_seen = true;
 				goto isolate_fail;
 			}
 		}
@@ -1088,19 +1101,21 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					locked = NULL;
 				}
 
+				/* movable_ops page is movable content. */
+				movable_seen = true;
 				if (isolate_movable_ops_page(page, mode)) {
 					folio = page_folio(page);
 					goto isolate_success;
 				}
-				movable_skipped = true;
 			}
 
 			/*
-			 * Non-LRU non-movable_ops page: still occupies the
-			 * pageblock, so clearing PB_has_movable here would
-			 * orphan SPB type counters (debugfs invariant 1).
+			 * Non-LRU, non-movable_ops page (slab, pgtable,
+			 * reserved, ...): not movable content. Do NOT mark
+			 * the PB as having movable pages; if it had no other
+			 * movable pages, the up-front clear of PB_has_movable
+			 * stays in effect.
 			 */
-			movable_skipped = true;
 			goto isolate_fail;
 		}
 
@@ -1113,6 +1128,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (unlikely(!folio))
 			goto isolate_fail;
 
+		/*
+		 * LRU folio reference acquired: this PB definitely
+		 * contains movable content. Mark it now so any abort
+		 * before isolate_success/isolate_fail_put still
+		 * triggers the post-loop PB_has_movable re-set.
+		 */
+		movable_seen = true;
+
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
@@ -1266,7 +1289,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			lruvec_unlock_irqrestore(locked, flags);
 			locked = NULL;
 		}
-		movable_skipped = true;
+		/* Page was LRU; treat as movable content even though we couldn't take it. */
+		movable_seen = true;
 		folio_put(folio);
 
 isolate_fail:
@@ -1330,17 +1354,31 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!cc->no_set_skip_hint && valid_page && !skip_updated)
 			set_pageblock_skip(valid_page);
 		update_cached_migrate(cc, low_pfn);
+	}
+
+	/*
+	 * PB_has_movable was cleared up-front when this PB was first
+	 * entered. Re-set it unless a complete scan of the pageblock
+	 * proved no movable content exists. Re-setting is required on:
+	 *   - any partial scan (low_pfn != end_pfn): we can't conclude
+	 *     the PB is movable-free without seeing every PFN
+	 *   - nr_isolated > 0: pages may fail migration and return to
+	 *     this PB, so the bit must persist
+	 *   - movable_seen: hugeTLB/THP/movable_ops/LRU content was
+	 *     observed, even if it could not be isolated
+	 * The set is idempotent (a racing allocator may set it too).
+	 */
+	if (pb_cleared && valid_page &&
+	    (low_pfn != end_pfn || nr_isolated || movable_seen)) {
+		unsigned long pb_pfn = pageblock_start_pfn(start_pfn);
 
 		/*
-		 * Full pageblock scanned with no movable pages isolated.
-		 * Only clear PB_has_movable if no movable pages were
-		 * seen at all. If movable pages exist but could not be
-		 * isolated (pinned, writeback, dirty, etc.), leave the
-		 * flag set so a future migration attempt can try again.
+		 * start_pfn may not be pageblock-aligned when the zone
+		 * start is not aligned (e.g. DMA zone at PFN 1). Skip
+		 * the update if the pageblock start falls below the zone.
 		 */
-		if (!nr_isolated && !movable_skipped && valid_page)
-			superpageblock_clear_has_movable(cc->zone,
-							valid_page);
+		if (pb_pfn >= cc->zone->zone_start_pfn)
+			superpageblock_set_has_movable(cc->zone, valid_page);
 	}
 
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
@@ -1557,6 +1595,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
 	unsigned long low_pfn, min_pfn, highest = 0;
 	unsigned long nr_isolated = 0;
 	unsigned long distance;
+	unsigned long si, nr_spb;
 	struct page *page = NULL;
 	bool scan_start = false;
 	int order;
@@ -1594,45 +1633,66 @@ static void fast_isolate_freepages(struct compact_control *cc)
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
+
+		/*
+		 * With superpageblocks, free pages live on per-SPB free
+		 * lists rather than zone-level free lists.  Iterate all
+		 * SPBs to find candidate pages.
+		 */
+		nr_spb = cc->zone->nr_superpageblocks;
+		for (si = 0; !page && order_scanned < limit; si++) {
+			struct free_area *area;
+
+			if (nr_spb) {
+				if (si >= nr_spb)
+					break;
+				area = &cc->zone->superpageblocks[si].free_area[order];
+			} else {
+				if (si > 0)
+					break;
+				area = &cc->zone->free_area[order];
 			}
 
-			if (pfn >= min_pfn && pfn > high_pfn) {
-				high_pfn = pfn;
+			freelist = &area->free_list[MIGRATE_MOVABLE];
+			list_for_each_entry_reverse(freepage,
+						    freelist,
+						    buddy_list) {
+				unsigned long pfn;
+
+				order_scanned++;
+				nr_scanned++;
+				pfn = page_to_pfn(freepage);
+
+				if (pfn >= highest)
+					highest = max(
+					    pageblock_start_pfn(pfn),
+					    cc->zone->zone_start_pfn);
+
+				if (pfn >= low_pfn) {
+					cc->fast_search_fail = 0;
+					cc->search_order = order;
+					page = freepage;
+					break;
+				}
 
-				/* Shorten the scan if a candidate is found */
-				limit >>= 1;
-			}
+				if (pfn >= min_pfn && pfn > high_pfn) {
+					high_pfn = pfn;
+					limit >>= 1;
+				}
 
-			if (order_scanned >= limit)
-				break;
+				if (order_scanned >= limit)
+					break;
+			}
 		}
 
 		/* Use a maximum candidate pfn if a preferred one was not found */
@@ -1641,10 +1701,24 @@ static void fast_isolate_freepages(struct compact_control *cc)
 
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
@@ -1985,6 +2059,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 	unsigned long distance;
 	unsigned long pfn = cc->migrate_pfn;
 	unsigned long high_pfn;
+	unsigned long si, nr_spb;
 	int order;
 	bool found_block = false;
 
@@ -2038,47 +2113,73 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
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
+		/*
+		 * With superpageblocks, free pages live on per-SPB free
+		 * lists.  Iterate all SPBs to find candidates.
+		 */
+		nr_spb = cc->zone->nr_superpageblocks;
+		for (si = 0; !found_block && nr_scanned < limit; si++) {
+			struct free_area *area;
+			struct list_head *freelist;
+
+			if (nr_spb) {
+				if (si >= nr_spb)
+					break;
+				area = &cc->zone->superpageblocks[si].free_area[order];
+			} else {
+				if (si > 0)
+					break;
+				area = &cc->zone->free_area[order];
 			}
 
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
+			freelist = &area->free_list[MIGRATE_MOVABLE];
+			list_for_each_entry(freepage, freelist,
+					    buddy_list) {
+				unsigned long free_pfn;
+
+				if (nr_scanned++ >= limit) {
+					move_freelist_tail(freelist,
+							   freepage);
+					break;
+				}
+
+				free_pfn = page_to_pfn(freepage);
+				if (free_pfn < high_pfn) {
+					/*
+					 * Avoid if skipped recently.
+					 * Ideally it would move to
+					 * the tail but even safe
+					 * iteration of the list
+					 * assumes an entry is deleted,
+					 * not reordered.
+					 */
+					if (get_pageblock_skip(freepage))
+						continue;
+
+					move_freelist_tail(freelist,
+							   freepage);
+
+					update_fast_start_pfn(cc,
+							      free_pfn);
+					pfn = pageblock_start_pfn(
+							free_pfn);
+					if (pfn < cc->zone->zone_start_pfn)
+						pfn = cc->zone->zone_start_pfn;
+					cc->fast_search_fail = 0;
+					found_block = true;
+					break;
+				}
 			}
 		}
+
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 	}
 
@@ -2292,6 +2393,7 @@ static bool should_proactive_compact_node(pg_data_t *pgdat)
 static enum compact_result __compact_finished(struct compact_control *cc)
 {
 	unsigned int order;
+	unsigned long si, nr_spb;
 	const int migratetype = cc->migratetype;
 	int ret;
 
@@ -2364,33 +2466,56 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 
 	/* Direct compactor: Is a suitable page free? */
 	ret = COMPACT_NO_SUITABLE_PAGE;
+	nr_spb = cc->zone->nr_superpageblocks;
 	for (order = cc->order; order < NR_PAGE_ORDERS; order++) {
-		struct free_area *area = &cc->zone->free_area[order];
+		/* Zone-level nr_free is maintained even with SPBs */
+		if (!cc->zone->free_area[order].nr_free)
+			continue;
 
-		/* Job done if page is free of the right migratetype */
-		if (!free_area_empty(area, migratetype))
-			return COMPACT_SUCCESS;
+		/*
+		 * With superpageblocks, free pages live on per-SPB free
+		 * lists.  Check all SPBs for a suitable page.
+		 */
+		for (si = 0; ; si++) {
+			struct free_area *area;
+
+			if (nr_spb) {
+				if (si >= nr_spb)
+					break;
+				area = &cc->zone->superpageblocks[si].free_area[order];
+			} else {
+				if (si > 0)
+					break;
+				area = &cc->zone->free_area[order];
+			}
+
+			/* Job done if page is free of the right migratetype */
+			if (!free_area_empty(area, migratetype))
+				return COMPACT_SUCCESS;
 
 #ifdef CONFIG_CMA
-		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
-		if (migratetype == MIGRATE_MOVABLE &&
-			!free_area_empty(area, MIGRATE_CMA))
-			return COMPACT_SUCCESS;
+			/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
+			if (migratetype == MIGRATE_MOVABLE &&
+				!free_area_empty(area, MIGRATE_CMA))
+				return COMPACT_SUCCESS;
 #endif
-		/*
-		 * Job done if allocation would steal freepages from
-		 * other migratetype buddy lists.
-		 */
-		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
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
index 530ddc73e90a..3c11c8c5ce6a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8288,17 +8288,13 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn,
  * - Skip superpageblocks with no movable pages (nothing to evacuate)
  */
 
-/* Target free space: 3 pageblocks worth of free pages */
-#define SPB_DEFRAG_FREE_PAGES_TARGET	(3UL * pageblock_nr_pages)
-
 /**
  * spb_needs_defrag - Check if a superpageblock needs defragmentation
  * @sb: superpageblock to check (may be NULL)
  *
- * Returns false for NULL, non-tainted, or clean superpageblocks.
- * A tainted superpageblock needs defrag if it has movable pages that can
- * be evacuated AND free space is running low (1 or fewer free
- * pageblocks, or less than 2 pageblocks worth of free pages).
+ * Defrag here is the per-SPB tainted-pool evacuation worker. Clean SPBs
+ * are handled by standard compaction (kcompactd) and do not return true
+ * from this predicate.
  */
 /*
  * Cooldown between defrag attempts that made no progress, in seconds.
@@ -8312,14 +8308,11 @@ static bool spb_needs_defrag(struct superpageblock *sb)
 	if (!sb)
 		return false;
 
-	if (spb_get_category(sb) != SB_TAINTED)
-		return false;
-
 	/*
 	 * Back off if the previous pass made no progress: do not retry until
 	 * either the cooldown elapses or free pages have grown by at least a
 	 * pageblock's worth (a hint that there might be new material to
-	 * consolidate or evacuate).
+	 * evacuate).
 	 */
 	if (sb->defrag_last_no_progress_jiffies &&
 	    time_before(jiffies, sb->defrag_last_no_progress_jiffies +
@@ -8330,21 +8323,24 @@ static bool spb_needs_defrag(struct superpageblock *sb)
 
 	/*
 	 * Tainted superpageblocks: evacuate movable pages to concentrate
-	 * unmovable/reclaimable allocations.  Migration targets are
-	 * allocated system-wide, so no internal free space is needed.
-	 * Maintain the tainted reserve so unmovable claims always
-	 * find room in existing tainted superpageblocks.
+	 * unmovable/reclaimable allocations.  Maintain the tainted reserve
+	 * so unmovable claims always find room in existing tainted
+	 * superpageblocks.
 	 */
-	return sb->nr_movable > 0 &&
-	       sb->nr_free < SPB_TAINTED_RESERVE;
+	if (spb_get_category(sb) == SB_TAINTED)
+		return sb->nr_movable > 0 &&
+		       sb->nr_free < SPB_TAINTED_RESERVE;
+
+	/* Clean SPBs: kcompactd handles consolidation; nothing to do here. */
+	return false;
 }
 
 /**
- * spb_defrag_done - Check if defrag target has been reached
+ * spb_defrag_done - Check if defrag should stop
  * @sb: superpageblock being defragmented
  *
- * Stop defragmenting when the superpageblock has enough free space
- * or there are no more movable pages to evacuate.
+ * Only meaningful for tainted SPBs.  Clean SPBs never reach this from
+ * the SPB defrag worker (spb_needs_defrag returns false for them).
  */
 static bool spb_defrag_done(struct superpageblock *sb)
 {
@@ -8353,49 +8349,112 @@ static bool spb_defrag_done(struct superpageblock *sb)
 	 * the reserve of free pageblocks is restored, or until there
 	 * are no more movable pages to evacuate.
 	 */
-	return !sb->nr_movable ||
-	       sb->nr_free >= SPB_TAINTED_RESERVE;
+	if (spb_get_category(sb) == SB_TAINTED)
+		return !sb->nr_movable ||
+		       sb->nr_free >= SPB_TAINTED_RESERVE;
+
+	/* Clean SPBs should not be handled here. */
+	return true;
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
 
-		/* Skip if fully free -- nothing to evacuate */
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
 	}
+out:
+	sb->defrag_cursor = pfn;
+}
+
+/**
+ * spb_defrag_superpageblock - defragment a tainted superpageblock
+ * @sb: the superpageblock to defragment
+ *
+ * Tainted SPBs are evacuated by spb_defrag_tainted.  Clean SPBs are
+ * handled by standard compaction (kcompactd) and never reach this
+ * dispatcher (spb_needs_defrag returns false for them).
+ */
+static void spb_defrag_superpageblock(struct superpageblock *sb)
+{
+	if (spb_get_category(sb) == SB_TAINTED)
+		spb_defrag_tainted(sb);
 }
 
 static void spb_defrag_work_fn(struct work_struct *work)
@@ -8455,10 +8514,12 @@ static void spb_defrag_irq_work_fn(struct irq_work *work)
  * @sb: superpageblock whose counters just changed
  *
  * Called from counter update paths (under zone->lock). If the
- * superpageblock is tainted and running low on free space, schedule
- * irq_work to queue defrag work outside the allocator's lock context.
- * The irq_work handler is set up by pageblock_evacuate_init();
- * before that runs, defrag_irq_work.func is NULL and we skip.
+ * superpageblock needs defragmentation -- either evacuation of movable
+ * pages from a tainted superpageblock, or internal compaction of a
+ * clean superpageblock -- schedule irq_work to queue defrag work outside
+ * the allocator's lock context. The irq_work handler is set up by
+ * pageblock_evacuate_init(); before that runs, defrag_irq_work.func
+ * is NULL and we skip.
  */
 static void spb_maybe_start_defrag(struct superpageblock *sb)
 {
-- 
2.54.0


