Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D80DCD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974466B00B4; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8384E6B00B2; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AAC6B00AF; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 481B86B00AF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10E60A017A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
X-FDA: 84716346498.08.8B6248D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59C08100002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ZxvDHkRo;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCIk5l/c6+i4Ogv4xsGctOwFttOXbLS3VhUaLeGIj3o=;
	b=bvIo5IYciB9RopaDSn7F5v/0fEkPiK/rxQOUhMtIKU8a6KXJ531BuJxuwsV381GehNMzKG
	/kjMFMtTY0OmuVEsKJNvRxaR4f0zvQwYl46ncF6Ix+O1ZUkRU5ObSJSmPZeC8kDDfK1MPe
	4xtuJPeM8sWyWQIZAC8b6AlqRrPwe1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580587; a=rsa-sha256;
	cv=none;
	b=KmdoTW8pS4WCyZaIj3PH4NDuDb2KjAd/kIZc3WddAmSDsffu5udO3WDzsvHIyTidQ6+9c6
	kw4pybWdJ3pH7wXgdtcSM9IhvrTn57qd8wQWKwuIdneAvz+xQYjjNVW8hhdJm0NKsX60ME
	zVU0z99rlw5eTL4BTv41oXDXpJya60E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ZxvDHkRo;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hCIk5l/c6+i4Ogv4xsGctOwFttOXbLS3VhUaLeGIj3o=; b=ZxvDHkRokdDVV+bCpRB2U1TK+9
	1z7kJM8BDrQJRdpNKfQVx1xqKoI2telpwpjmgcVMu/gvcgNdrSfcsnjR9HvR+DPfhOKR0VFsdg3iF
	qWvrB3ZYiTLWhDlreapHyMJh3OtD3UtJXEJrwkQDgJuy86kklnOn9aD3huZNETIrVOfYAzQTYxTBV
	HfofCVbqpKpyS3cacQREpqbFTQ/fjyngsARkrw5zeIx+xxO9c3KirgGn3mWPVCEnw63+gAmVEU3ZO
	lUIrbXVzYptR68vrd+0K5w3AyVKm9zANFPdAGmIWZySVjRvcdiZUSlw5v73DsVdw9VvPgraUspgqx
	wSYpGqmg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2a87;
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
Subject: [RFC PATCH 08/45] mm: page_alloc: track actual page contents in pageblock flags
Date: Thu, 30 Apr 2026 16:20:37 -0400
Message-ID: <20260430202233.111010-9-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59C08100002
X-Stat-Signature: e7geu44e48mdiarndd55o18sgijqumbi
X-Rspam-User: 
X-HE-Tag: 1777580587-222822
X-HE-Meta: U2FsdGVkX18Amu3J7uoo9m2Sy56nMSGnysCrK3CuV45iBpdUkTLe7wdVLqE6uVv8zNyO5ov/jxVc9UCFoXxdXLCSLkVsqTPd1ov+uRjJk+L5JRvNB8/Sk4GOiJYVZRw2J551XtUUhY1tfZzT7ISKUz2MZttJPolZdee+nwDUwEJqY9YbE0ETRNtKlP4iRNV3hzXNKjarMEiu7Mkh3sh8BSz5mJ3vFDFaExFdTpm2JJCZq+GK14gMAJ5l4ixw1oYry1mlPQzWcmn3c2u5r9AFQUn8h63W/O6gDFF+okNStOE4XIk63/V9m1P7fSBDxHKh05Fey2OQIsTGX0VwwMAdIQ18Y+dldkyDJqfcjK7oplMbNF+qDYiiFlA8/Js5Vr2Ld34Okdu35A0DZ/o748CJI6fBNVB2tYMsekyW8KFAdf+wvNIBDCSlJGPOaszMsr6KG2oeJS75tpnlncj0pLKyHckfRSErYq4U/ko2q+92KNyzRASW3HlKcch0UD2SOlLmBZxphjsRY4xmBIoP84tjXLqyODljRNly8YGe+68kdXlVhxRuAMk0h2itCHCZfQ8rX/UpWe3Jp6AsHHOp83fyIyVStSU8djbmKjTdDMVpkJ/0jA7NltQkn0v8PN4Ed+JIGlKKi3ZuG1MO3Ex6VTfd5bk8ZI/EEUP4sT8krDFtBuD+bEkS85KOB0alSBsVdZUwZusRV/yZQUUDMi2B7BdVeDpeKFLlPQU97fJ4+ntm4ZnwuJ8KLNAnHVWA3isGTtjzhx+sj/v24uJ/iVwGPLP7ZLZeT2que8HV4WCtYGz30BktjJOwQtiuh1XFnT5GajMaMkS5bASUAob1P7Fl88ZJD8da2vyAElODSrfF/a2++2yD5wU+gTK5uDeBCvs/ZjJeY6buO7ZwWOgiMkXk9YREpJR2uOKiHSvIcNg7Kgjxzjo1Dh9Db/OUcbqc/ZoUMg/WRHWM0ftG8LJa42tuO+f
 YN3ofmw2
 tmJJ533yxMIIA6dW4sLnWzHG/t6R6HkuQhORkrIn1zt4Z2Rc9iK9F0gsqy9dJLuvhg8HBzCCpG62pX5puoiCaTtwq/fDFwg2lWC/x8T4NCOBxbr7jY/q7VTucwu47I+LGmmitSanz0NLWx+6tV5K4xkxZF6hTh8TMIi1ptiI3DMzVNYy9SF+jRWvTONmJVpvmi/DJ1+5ae0fUfYa5G++yNKsD7AWbi6nR+HwTWCBEfrdGKxE/ndsqq+TNfde0cVSPK5VA1RfdyZigHApGHay5cRabTuUIJJ/mcrD8Thktl1lkfp7HRh4mOA1JaDX1HSN2hcjsmHSYK4mBPcRHs+oH9SQ+yD3EX0MM2zDzlFV6PqVtFOOAM4aopZ4IuWtbdgag+g5hLl7L/7zVrecTKfvehuDJ3KpGCQdDw3iW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Extend pageblock_data flags with PB_has_unmovable, PB_has_reclaimable, and
PB_has_movable bits to track the actual types of pages allocated within a
pageblock, independent of its intended migratetype.

The flags are set at steal time in try_to_claim_block(), avoiding overhead
on every allocation in __rmqueue_smallest():

1. Allocation / steal time: when try_to_claim_block() claims a pageblock,
set the PB_has_* flag corresponding to the allocation's migratetype. If
unmovable or reclaimable pages are being placed into a pageblock that
already has PB_has_movable set, queue async evacuation of the remaining
movable pages.

2. Full pageblock free: when buddy merging reconstructs a complete
pageblock in __free_one_page(), clear all PB_has_* flags since the block is
now empty.

3. Migration scan: when isolate_migratepages_block() completes a full
pageblock scan and finds no movable pages to isolate, clear PB_has_movable.
This consolidates the clearing for all callers: evacuate_pageblock(),
compaction, and alloc_contig_range().

This provides the foundation for superpageblock-level steering decisions:
knowing which pageblocks actually contain unmovable/reclaimable pages
allows directing future allocations to already-tainted regions, keeping
clean regions available for large contiguous allocations.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/pageblock-flags.h |  9 ++++
 mm/compaction.c                 | 17 ++++++
 mm/page_alloc.c                 | 93 +++++++++++++++++++++++++--------
 3 files changed, 98 insertions(+), 21 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e046278a01fa..21bfcdf80b2e 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -20,6 +20,15 @@ enum pageblock_bits {
 	PB_migrate_2,
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
+	/*
+	 * Track actual page contents independent of the intended migratetype.
+	 * Set at allocation time; cleared on full pageblock free or when
+	 * migration confirms no pages of that type remain.
+	 */
+	PB_has_unmovable,
+	PB_has_reclaimable,
+	PB_has_movable,
+
 #ifdef CONFIG_MEMORY_ISOLATION
 	/*
 	 * Pageblock isolation is represented with a separate bit, so that
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..cf2a5074c473 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -849,6 +849,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
+	bool movable_skipped = false;
 	int ret = 0;
 
 	cc->migrate_pfn = low_pfn;
@@ -1061,6 +1062,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					folio = page_folio(page);
 					goto isolate_success;
 				}
+				movable_skipped = true;
 			}
 
 			goto isolate_fail;
@@ -1229,6 +1231,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			unlock_page_lruvec_irqrestore(locked, flags);
 			locked = NULL;
 		}
+		movable_skipped = true;
 		folio_put(folio);
 
 isolate_fail:
@@ -1292,6 +1295,20 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!cc->no_set_skip_hint && valid_page && !skip_updated)
 			set_pageblock_skip(valid_page);
 		update_cached_migrate(cc, low_pfn);
+
+		/*
+		 * Full pageblock scanned with no movable pages isolated.
+		 * Only clear PB_has_movable if no movable pages were
+		 * seen at all. If movable pages exist but could not be
+		 * isolated (pinned, writeback, dirty, etc.), leave the
+		 * flag set so a future migration attempt can try again.
+		 */
+		if (!nr_isolated && !movable_skipped && valid_page &&
+		    get_pfnblock_bit(valid_page, pageblock_start_pfn(start_pfn),
+				     PB_has_movable))
+			clear_pfnblock_bit(valid_page,
+					   pageblock_start_pfn(start_pfn),
+					   PB_has_movable);
 	}
 
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 45c25c4fc7c0..d0a4de435842 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -972,6 +972,30 @@ static void change_pageblock_range(struct page *pageblock_page,
 	}
 }
 
+/*
+ * mark_pageblock_free - handle a pageblock becoming fully free
+ * @page: page at the start of the pageblock
+ * @pfn: page frame number
+ *
+ * Clear stale PCP ownership and actual-contents tracking flags when
+ * buddy merging reconstructs a full pageblock or a whole pageblock is
+ * freed directly. No PCP can still hold pages from this block (otherwise
+ * the buddy merge couldn't have completed), so the ownership entry would
+ * just cause misrouted frees.
+ */
+static void mark_pageblock_free(struct page *page, unsigned long pfn)
+{
+	clear_pcpblock_owner(page);
+
+	/*
+	 * The entire block is now free — clear actual-contents tracking
+	 * flags since no allocated pages remain.
+	 */
+	clear_pfnblock_bit(page, pfn, PB_has_unmovable);
+	clear_pfnblock_bit(page, pfn, PB_has_reclaimable);
+	clear_pfnblock_bit(page, pfn, PB_has_movable);
+}
+
 /*
  * Freeing function for a buddy system allocator.
  *
@@ -1017,19 +1041,14 @@ static inline void __free_one_page(struct page *page,
 	account_freepages(zone, 1 << order, migratetype);
 
 	/*
-	 * For whole blocks, ownership returns to the zone. There are
-	 * no more outstanding frees to route through that CPU's PCP,
-	 * and we don't want to confuse any future users of the pages
-	 * in this block. E.g. rmqueue_buddy().
-	 *
-	 * Check here if a whole block came in directly: pre-merged in
-	 * the PCP, or PCP contended and bypassed.
-	 *
-	 * There is another check in the loop below if a block merges
-	 * up with pages already on the zone buddy.
+	 * When freeing a whole pageblock, clear stale PCP ownership
+	 * and actual-contents tracking flags up front.  The in-loop
+	 * check only fires when sub-pageblock pages merge *up to*
+	 * pageblock_order, not when entering at pageblock_order
+	 * directly.
 	 */
 	if (order == pageblock_order)
-		clear_pcpblock_owner(page);
+		mark_pageblock_free(page, pfn);
 
 	while (order < MAX_PAGE_ORDER) {
 		int buddy_mt = migratetype;
@@ -1081,9 +1100,13 @@ static inline void __free_one_page(struct page *page,
 		pfn = combined_pfn;
 		order++;
 
-		/* Clear owner also when we merge up. See above */
+		/*
+		 * If merging has reconstructed a full pageblock,
+		 * clear any stale PCP ownership and actual-contents
+		 * tracking flags.
+		 */
 		if (order == pageblock_order)
-			clear_pcpblock_owner(page);
+			mark_pageblock_free(page, pfn);
 	}
 
 done_merging:
@@ -2469,15 +2492,32 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
 #ifdef CONFIG_COMPACTION
 		/*
-		 * A movable pageblock was just claimed for unmovable or
-		 * reclaimable use. Queue async evacuation of the remaining
-		 * movable pages so future unmovable/reclaimable allocations
-		 * can stay concentrated in fewer pageblocks.
+		 * Track actual page contents in pageblock flags.
+		 * Mark the pageblock with the type being allocated, and
+		 * if unmovable/reclaimable pages are being placed into a
+		 * pageblock that already has movable pages, queue async
+		 * evacuation of the movable pages.
 		 */
-		if (block_type == MIGRATE_MOVABLE &&
-		    (start_type == MIGRATE_UNMOVABLE ||
-		     start_type == MIGRATE_RECLAIMABLE))
-			queue_pageblock_evacuate(zone, start_pfn);
+		{
+			struct page *start_page = pfn_to_page(start_pfn);
+
+			if (start_type == MIGRATE_UNMOVABLE) {
+				set_pfnblock_bit(start_page, start_pfn,
+						 PB_has_unmovable);
+				if (get_pfnblock_bit(start_page, start_pfn,
+						     PB_has_movable))
+					queue_pageblock_evacuate(zone, start_pfn);
+			} else if (start_type == MIGRATE_RECLAIMABLE) {
+				set_pfnblock_bit(start_page, start_pfn,
+						 PB_has_reclaimable);
+				if (get_pfnblock_bit(start_page, start_pfn,
+						     PB_has_movable))
+					queue_pageblock_evacuate(zone, start_pfn);
+			} else if (start_type == MIGRATE_MOVABLE) {
+				set_pfnblock_bit(start_page, start_pfn,
+						 PB_has_movable);
+			}
+		}
 #endif
 		return __rmqueue_smallest(zone, order, start_type);
 	}
@@ -7212,6 +7252,17 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
 
 	if (!list_empty(&cc.migratepages))
 		putback_movable_pages(&cc.migratepages);
+
+	/*
+	 * Re-scan to let isolate_migratepages_block clear PB_has_movable
+	 * if no movable pages remain after evacuation.
+	 */
+	cc.migrate_pfn = start_pfn;
+	cc.nr_migratepages = 0;
+	INIT_LIST_HEAD(&cc.migratepages);
+	isolate_migratepages_range(&cc, start_pfn, end_pfn);
+	if (!list_empty(&cc.migratepages))
+		putback_movable_pages(&cc.migratepages);
 }
 
 static void evacuate_work_fn(struct work_struct *work)
-- 
2.52.0


