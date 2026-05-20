Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED11CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C906B00A2; Wed, 20 May 2026 11:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4D86B00A7; Wed, 20 May 2026 11:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F028A6B00A2; Wed, 20 May 2026 11:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCBB06B00A2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 859441C1040
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:48 +0000 (UTC)
X-FDA: 84788110176.18.3821AF4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98472100012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=niBp0Ap3;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6mviOc8XFuigX2Lo+UT1CyWuK4MX908sRC8mjB+IJ94=;
	b=cBfoeMJbKJexsMt2Sni7q/7WJHvBcWb9za6zCi6CrbypnMr296EXc6g/AefCPsz5Jwt/t1
	dQwNurATm1wCbAnlXO2FuAAdw5BFeNrakbGk3XgEMLLSZIz9/+kOCFh5pRnt6sX1ArqP8G
	U3VbNSmjiTxmri38m+wZlFBegdmUWhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289246; a=rsa-sha256;
	cv=none;
	b=sdIkDm0eFEvJyUgluU6n93+aUdxJ/k7vptF8wv4hUeRuyHTkM53OZPSveLvkoMtusx4rB1
	hgz8Ek16xsb+o4kFjeR2iwrfYSJjgiOoPlTsEPKW72YLCDHG5FndIQkzkiG6mJjGyxtGV/
	YMHyj51G37G4D9+HUUZA+7pk1IzCbSQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=niBp0Ap3;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6mviOc8XFuigX2Lo+UT1CyWuK4MX908sRC8mjB+IJ94=; b=niBp0Ap3VdEs+oGl1vCF0I66ew
	mT4tYL7RMYFEM4uy/y0rQNS5/XvSDG3ycZAikG+yyvMbAvgrYYH/rOazynbzIy19o1ZbwuW1L0g3g
	T2m7K84QXR+B7nDkNxyNpYiKmKEoNN6NZVWQMM3kDi4u+t2HhschXvC6waU1Xkv7hiwsYTyvqu33l
	Cc4KGbdmUrNpHDwJZWIi02On2IIUTXuBRQjbS8FYmfeekLBfB/EuMVy48LiVTa4pg8Kt3xF6z27Oo
	bBhYa7CeOhXMsFFstQpyOZx6sxqqENiUgQU1KeCHVKDQe+ZPFbK7BidG1BACKxTxZczhl8yvhj8W8
	eHYQGP4g==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0rHP;
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
Subject: [RFC PATCH 07/40] mm: page_alloc: track actual page contents in pageblock flags
Date: Wed, 20 May 2026 10:59:13 -0400
Message-ID: <20260520150018.2491267-8-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98472100012
X-Rspam-User: 
X-Stat-Signature: h7f56dk66t1qrsz98xa9e9a98m7n4eux
X-HE-Tag: 1779289246-707187
X-HE-Meta: U2FsdGVkX1+3udlnlxFJqKmcEdmK4Pdy2UGgPiQb/FKgCyAQVxhm3eLJNKRVxXJM3ciSQBy83Mfy3XDm64/0HBDWa77BC3QmXHmh1FgfTrb+n3ofvZwjfAbw7QRDJ4uAuA18F/AXpZfQ+PgUYS9Q6yhkXMSbtxHjJUtGQ3YO5qWZ+L/RXxHua1spftMgmMgL5v9xD2FoZT4BWS5mEfWizcuy00jb4IFj3SlnxmfX75tObLHjshxMw5RG7TDUkQQ1/YzhZ82rfeu117dXyYqAMTSbvHsUBQ90l/5DlaQpyJO4wRmqUcOv0ctreKnmwAy6XmqmCb9ZevFt0jkRMvoPHDmC7b4jBdi72rGXjn/SfnqNsGRvj8wvJ+OjV0awz3hjzMuawmlCwqKM+YOltQvLm3aSEKV6fFcS4H1rLwFRiHsYiVIsiykjsyYDIxaRDixsDnM44cujkjFXF7ffOzB79p3swEFhi/nuqtfQ5HwBgUbhiGPm28p8RsMae6IELkvYurALsN6wOoSC9bpFPQcnJrydQuAczH4eeF+cioKVynAsXSBx6g6nqRywHLGo/C9RwZrRFitTA/3W6UxKyowEwxHhH/uoTEAt51CtHyo/0jjOYSWFZ6LPNhO+NtpoUzK21w/rz9CdlBqDQEZSi8f6BFnSIjO+e6dfelYZOda/mnSrz80Aszv8dP4AiB2g9Orkes+Zso2AbBbXEoTTkgr+FSkVAeSVBrqRakuAXF2a5H/K87W5tfaFfQXtIT9rloXUW5wZD9zQoTNGR5ls/X/luhvSIkEmwux6izwrkUU6H+uqmZnVOCRy+pSowGc4ALSTurxMiddB3/iK7t/rTY0yfHe94jqMo5+PE6urrktFPzjsGwSlmu5HJjO43VJvwlQWDzGR2qF7S5VHO5/b/7iUBmHlFai7qic09+mfvCzZOnr60tAek4/96Sx2vYHpbO8yEm4CPBdbYNhWPwCvGLX
 NMWH59ao
 iDUXx6woztpCkwcZKLxKKJojYsR8uv0qtTzw4SzqR57cST3j19B/dMrrHH+hKfYY8RBJ0Gu9qQv9nYdHQe0RCVHL53gajRHfpQ/UjnPqmGs6XB88j1kuTFCnTFR4fPH4gMRpCbgX/3Hsz95qVaCisXDGIhLPzLZYaMD9MYZ9BLaHKizrSEyMRf7x2t/mEa3FLLvYhBFxiMroSatryuNTyjcipTAbyvVBGFL4XS7ltIgzyETP5bzMDd2c8Xoe0HCjknJfrYySYbNTCvGmwj/tgxzPy+4lKWQ+brlXEkuAA8AVv5fdgPuokqnvHD3s+FAD129L1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 3648ce22c807..e8ca651e2b07 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -867,6 +867,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
+	bool movable_skipped = false;
 	int ret = 0;
 
 	cc->migrate_pfn = low_pfn;
@@ -1079,6 +1080,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					folio = page_folio(page);
 					goto isolate_success;
 				}
+				movable_skipped = true;
 			}
 
 			goto isolate_fail;
@@ -1246,6 +1248,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			lruvec_unlock_irqrestore(locked, flags);
 			locked = NULL;
 		}
+		movable_skipped = true;
 		folio_put(folio);
 
 isolate_fail:
@@ -1309,6 +1312,20 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
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
index 0f3d734bd296..23108cdcbbec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -928,6 +928,30 @@ static void change_pageblock_range(struct page *pageblock_page,
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
+	 * The entire block is now free -- clear actual-contents tracking
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
@@ -973,19 +997,14 @@ static inline void __free_one_page(struct page *page,
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
@@ -1037,9 +1056,13 @@ static inline void __free_one_page(struct page *page,
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
@@ -2433,6 +2456,9 @@ try_to_claim_block(struct zone *zone, struct page *page,
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
+#ifdef CONFIG_COMPACTION
+	struct page *start_page;
+#endif
 
 	/*
 	 * Don't steal from pageblocks that are isolated for
@@ -2488,15 +2514,29 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
+		start_page = pfn_to_page(start_pfn);
+		if (start_type == MIGRATE_UNMOVABLE) {
+			set_pfnblock_bit(start_page, start_pfn,
+					 PB_has_unmovable);
+			if (get_pfnblock_bit(start_page, start_pfn,
+					     PB_has_movable))
+				queue_pageblock_evacuate(zone, start_pfn);
+		} else if (start_type == MIGRATE_RECLAIMABLE) {
+			set_pfnblock_bit(start_page, start_pfn,
+					 PB_has_reclaimable);
+			if (get_pfnblock_bit(start_page, start_pfn,
+					     PB_has_movable))
+				queue_pageblock_evacuate(zone, start_pfn);
+		} else if (start_type == MIGRATE_MOVABLE) {
+			set_pfnblock_bit(start_page, start_pfn,
+					 PB_has_movable);
+		}
 #endif
 		return __rmqueue_smallest(zone, order, start_type);
 	}
@@ -7307,6 +7347,17 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
 
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
2.54.0


