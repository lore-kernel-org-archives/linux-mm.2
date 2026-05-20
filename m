Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0C9CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EBC6B00C5; Wed, 20 May 2026 11:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898E46B00C6; Wed, 20 May 2026 11:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715716B00C8; Wed, 20 May 2026 11:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 462C16B00C6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E26C1834
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:08 +0000 (UTC)
X-FDA: 84788111016.18.A47EB25
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id 127BA1A0029
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="CsZ0AD/7";
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/TcUjtUKEbuTDWUw2WODukw7GuJFX0QHxyJ5ij3iHs=;
	b=Bp3OkuYpXOmIHFhdWSjp1V45EaQqKZucc4jeiCZFYGWe7/Oj8MqHSOuctiEZMPUQ5afIKI
	RZxVLX1oEOYvs48KOiTkzjf6Ue2tST+7fUi+DEe9jeEx9UrSGr7DCS/zRpwo09Yiwp7Jx8
	OPhUlsOihzlQd/g1vWl1Z86DNFHZdxY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="CsZ0AD/7";
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289266; a=rsa-sha256;
	cv=none;
	b=tAm+9yD3NWMf0DDAuYaTMbMdIrsWLadV41o2owoB6uaIzjv6TyWLuzT5L6dn/SS3WnAyYF
	E+ZrE7EO4giPfJu3JO2lhKF9bBp4G2dPnpSwJ6WLiSJPfD7W1W4Ec+JFD/eoP9m8qRPG5U
	SYNlg7uMuzmDUZDLPbpOo/xcls1oSEk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I/TcUjtUKEbuTDWUw2WODukw7GuJFX0QHxyJ5ij3iHs=; b=CsZ0AD/7/nkVIebM6aFXUIh0WP
	gYNLJZCd88R656ND3hZKlDVSzcJRAEFEItdfAR0mLXc3Z85VwGkFpmak0wwTNKNakDAEw2EZtWvJG
	H5S6LOHgukPjCFbwCpMlhbOEGNaU2qn/NQMPtoCQpcruE6gS2Q65HlnR4iQNTOhzNFcIdHrsWshnA
	TOuBSp0z9Bv6CpJ1syP08XxKUu9M/B7U4z5C0wXWsLpz+SAeO7TWkQmwX+KUeQbIjSI09L4z2r4Xx
	YYub66NbhXWoqeT7R0juZoIRPHk78zPkIr7+huOwOigtDlf18hBDJnAFllXJtp8kFnO5naRGUIBNy
	9KnYhsWA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3Ewm;
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
Subject: [RFC PATCH 26/40] mm: page_alloc: refuse fragmenting fallback for callers with cheap fallback
Date: Wed, 20 May 2026 10:59:32 -0400
Message-ID: <20260520150018.2491267-27-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 127BA1A0029
X-Rspam-User: 
X-Stat-Signature: x9xwkc5uyo3zwbsfpdyee41mazgp6ska
X-HE-Tag: 1779289265-661131
X-HE-Meta: U2FsdGVkX1/PxLg36D5PKsLjnZY31hln7voyyp+JS45xGFE/SUPpb4sFw5W0+ZkVIzvyb3NBtAAMMwTF+M0vDTT21A1sAYcPjzsjw54u4Ytdb8xjZXXTGi4LOKauVPwSqNY6s0oOGqWG5D28VNt7s8vSA3OwfNrZRKzRFQQiNS9UpzGbBmxPbA+M7DhZSXZW9p0bOtmsXDxLc16sQ8YFJv5Bn0puQC1xqZ5/LSxnxl+11FUvEi4wYL2VfnQqIZiU2wEUkszFKGgjssSitS3WqmRrI/v+A7AhAOyr2ABYK6ebQkjtA4HcNfHVZx4sD3z6WbbHv1dqL8HRteVM+GstFS7WBhVfaYmrq5IEttcd4ZxiGZx3eHsEVE5+z/6gSLwZAifltaPN23EPilgendQhclm1LqI9zqY/DtuUQ0AebprgrV7m57zjKVpVaAPKvQn+GuUER64/dlTj9dcy4HOiTlxWOk6IFdQNuOZ31wIznTGZ2770CHh3Mta1PLPyetS63Z6yjkAGfN8piG6Uuq45z1qMmgi5DRlwDI33pqFbx7VQog9mAh53CdTqMveXcKpffQXhHok26nNUl3Lg1ATXocLxrseEWm0cEk2hNmMFzQD2u8fIg4eKHBX9/6y+o6mnUO6xZwiFTP2Ut/P76QzATEp8IYB68we6spJ8Zcj2ZFlrn2DLk7g1NHlMwVerrwhbmM40mp/Ijasc5W148KwI5UdX6+Fmmy6cVtEoRNBRuJexc6h0ffb/wltqVj0CUoeFLWrp2+62sMeM91Ri8DK1eRMRh6B0Xi0ssoUCIqY5m2xpBLoPsaI6SK1CtkqG8T1kTRrfspqvjtMTfvEFH4N0qxITPOU4Zo1OUh54r/Tu0Ir/gw9WAelNUO/rTg89HscoSVOxc8J7iyriK6tJiQ3pBG7T5YwJ3GLkQNuUGF2EdxYVSo3OCPJLyvMP0tJXOTc+pej7ZM4vMRXiHGl0+2A
 aXmcvOHe
 tDl/VaVn3P424XaAhlFzTiqBXrJh3qlEN0JuYgYc1/+JWMCUHzju0UAaiDsc2dnJiEJ+sa8j1USbYuQIfOcRNPIURoxW73txRd9pTcsPCjCDmlgryykfLcpqNhNozaGfDwkJKEQzkQ28danIJwlK1mI7HfBo6etrXhF+PnLUlJbjd8rfBOQ4YgfQ+3NMKKJDKyGlBVKT85sP0JAI+K4XFZXIO5fdm5GamV6nmcBAr+tvvY0jwJqJ8XmWHQeRw7la8/lE/piAzw+JI/N8+0ezRTOsFa3e9+/eqkC/8L+sq0eYYGyF/Tw0C983Kp72/PzF97Ot7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coarse bail-out gate in get_page_from_freelist's slowpath retry,
returning NULL to keep atomic-shape allocations from tainting clean
SPBs, would break early-boot in QEMU: cred_init's slab cache create
reaches the slowpath with gfp = __GFP_COMP (gfp_allowed_mask =
GFP_BOOT_MASK strips __GFP_RECLAIM from GFP_KERNEL during boot), has
no fallback path, and panics when a coarse gate refuses the
allocation.

Add a finer-grained refusal anchored in __rmqueue, where the SPB-aware
free-list walk already runs:

  - Add ALLOC_HIGHORDER_OPTIONAL, set in gfp_to_alloc_flags() for two
    shapes:

      1. Explicit fallback declaration: __GFP_NORETRY without
         __GFP_RETRY_MAYFAIL. Used by THP, slab high-order refill,
         skb_page_frag_refill on full sockets, etc.

      2. Atomic-context shape: no __GFP_DIRECT_RECLAIM, no
         __GFP_NOMEMALLOC, no __GFP_NOFAIL. Catches GFP_ATOMIC,
         GFP_NOWAIT, including ALLOC_HIGHATOMIC consumers (which still
         get a second crack at the dedicated MIGRATE_HIGHATOMIC reserve
         in rmqueue_buddy after __rmqueue returns NULL).

    __GFP_MEMALLOC and __GFP_NOFAIL never get the flag -- they must
    succeed even at the cost of fresh-SPB taint.

  - Add struct spb_tainted_walk to record what __rmqueue_smallest's
    Pass 1 saw on the SB_TAINTED list (any free pages, any free PB,
    below-reserve pageblock count). Thread it through the function's
    new fourth argument; non-walking call sites pass NULL.

  - In __rmqueue, allocate the walk on the stack for callers with
    ALLOC_HIGHORDER_OPTIONAL set on a non-movable, non-CMA migratetype.
    Force *mode back to RMQUEUE_NORMAL on every call so rmqueue_bulk
    Phase 3 can't reuse a memoised RMQUEUE_CLAIM/STEAL state to skip
    the gate across iterations.

  - After __rmqueue_smallest returns NULL, check the walk: if a tainted
    SPB has free pages or a free pageblock that could absorb this
    allocation after evacuation, return NULL and bump
    SPB_HIGHORDER_REFUSED. Skip RMQUEUE_CLAIM and RMQUEUE_STEAL
    entirely (both can taint clean SPBs). The slowpath will eventually
    drop NOFRAGMENT and let the allocation proceed only for the
    callers that lack ALLOC_HIGHORDER_OPTIONAL -- i.e. the truly
    must-not-fail consumers.

  - Before falling through to Pass 3 (empty SPBs) inside
    __rmqueue_smallest, kick queue_spb_evacuate() when the walk saw a
    tainted SPB below its reserve threshold, so future allocations
    have a movable-evicted home in an already-tainted SPB.

  - Add SPB_HIGHORDER_REFUSED vm event counter (events, not refused
    allocations: a single high-level alloc that retries can be counted
    multiple times across per-zone attempts).

The early-boot SB_TAINTED list is empty, so the walk records nothing,
the refusal does not engage, and __rmqueue falls through to
RMQUEUE_CLAIM which taints the first SPB normally (the first taint is
unavoidable). cred_init's slab create succeeds, boot succeeds.

Tested in a 16 GB QEMU VM under combined sb-stress + UDP-loopback +
fork/mmap storms (~480s); 2 tainted Normal SPBs out of 13 (boot
baseline 1, +1 during stress); 11 clean SPBs distributed movable load;
no kernel BUG, oops, hang, or panic.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/vm_event_item.h |   5 ++
 mm/internal.h                 |   1 +
 mm/page_alloc.c               | 115 ++++++++++++++++++++++++++++++++--
 mm/vmstat.c                   |   1 +
 4 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..4a8513d5fc3e 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -76,6 +76,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		CMA_ALLOC_SUCCESS,
 		CMA_ALLOC_FAIL,
 #endif
+		SPB_HIGHORDER_REFUSED,	/*
+					 * refused fragmenting fallback to keep
+					 * a clean SPB clean when a tainted SPB
+					 * still has free pageblocks
+					 */
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
 		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
diff --git a/mm/internal.h b/mm/internal.h
index e6d61dbc18d9..f52575202a96 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1512,6 +1512,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 #define ALLOC_NOFRAG_TAINTED_OK	0x1000 /* NOFRAGMENT, but allow steal from tainted SPBs */
+#define ALLOC_HIGHORDER_OPTIONAL 0x2000 /* caller can fall back to a lower order */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dfbfed056bbb..e4ecddb428c3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2799,9 +2799,21 @@ static struct page *try_to_claim_block(struct zone *zone, struct page *page,
 		  int block_type, unsigned int alloc_flags,
 		  bool from_tainted_spb);
 
+/*
+ * Snapshot of tainted-SPB state observed while __rmqueue_smallest walks the
+ * free lists. Lets the caller (currently __rmqueue) decide whether to refuse
+ * a fragmenting fallback when an existing tainted SPB could absorb the demand
+ * once it is evacuated.
+ */
+struct spb_tainted_walk {
+	bool saw_free_pages;	/* tainted SPB has any free pages, any order */
+	bool saw_free_pb;	/* tainted SPB has at least one free pageblock */
+	bool saw_below_reserve;	/* tainted SPB has nr_free <= spb_tainted_reserve */
+};
+
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
-						int migratetype)
+				int migratetype, struct spb_tainted_walk *walk)
 {
 	unsigned int current_order;
 	struct free_area *area;
@@ -2850,6 +2862,20 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 		list_for_each_entry(sb,
 			&zone->spb_lists[cat][full], list) {
+			/*
+			 * Snapshot tainted-SPB capacity before the
+			 * nr_free_pages skip: an SPB with a free pageblock
+			 * but nothing on the requested-MT freelist still
+			 * counts as "could absorb this allocation after evac".
+			 */
+			if (walk && cat == SB_TAINTED) {
+				if (sb->nr_free_pages)
+					walk->saw_free_pages = true;
+				if (sb->nr_free)
+					walk->saw_free_pb = true;
+				if (sb->nr_free <= spb_tainted_reserve(sb))
+					walk->saw_below_reserve = true;
+			}
 			if (!sb->nr_free_pages)
 				continue;
 			/* Try whole pageblock (or larger) first for PCP buddy */
@@ -2975,6 +3001,16 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		}
 	}
 
+	/*
+	 * About to fall through to Pass 3 (empty SPBs) or Pass 4 fallback,
+	 * which risks tainting a clean SPB. If the tainted-SPB walk above
+	 * showed that some tainted SPB is below its reserve threshold of
+	 * free pageblocks, kick deferred evacuation so future allocations
+	 * have a movable-evicted home in an already-tainted SPB.
+	 */
+	if (walk && walk->saw_below_reserve)
+		queue_spb_evacuate(zone, order, migratetype);
+
 	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
 		if (!sb->nr_free_pages)
@@ -3098,7 +3134,7 @@ static inline bool noncompatible_cross_type(int start_type, int fallback_type)
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
 					unsigned int order)
 {
-	return __rmqueue_smallest(zone, order, MIGRATE_CMA);
+	return __rmqueue_smallest(zone, order, MIGRATE_CMA, NULL);
 }
 #else
 static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
@@ -3573,7 +3609,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (sb)
 		spb_update_list(sb);
 #endif
-	return __rmqueue_smallest(zone, order, start_type);
+	return __rmqueue_smallest(zone, order, start_type, NULL);
 }
 
 /*
@@ -3920,8 +3956,29 @@ static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	  unsigned int alloc_flags, enum rmqueue_mode *mode)
 {
+	struct spb_tainted_walk walk = { };
+	struct spb_tainted_walk *walkp = NULL;
 	struct page *page;
 
+	/*
+	 * Track tainted-SPB state for non-movable, non-CMA callers that
+	 * signaled they have a cheap fallback (atomic shape or explicit
+	 * NORETRY). We use that to refuse a fragmenting CLAIM/STEAL when a
+	 * tainted SPB still has free pageblocks waiting to be evacuated.
+	 *
+	 * Force *mode back to RMQUEUE_NORMAL so the walk + refusal check
+	 * runs on every call. rmqueue_bulk Phase 3 chains many __rmqueue
+	 * calls reusing *mode; without this reset, a single successful
+	 * RMQUEUE_CLAIM/STEAL on the first iteration would let every
+	 * subsequent iteration skip the case RMQUEUE_NORMAL block and taint
+	 * additional clean SPBs unchecked.
+	 */
+	if (migratetype != MIGRATE_MOVABLE && !is_migrate_cma(migratetype) &&
+	    (alloc_flags & ALLOC_HIGHORDER_OPTIONAL)) {
+		walkp = &walk;
+		*mode = RMQUEUE_NORMAL;
+	}
+
 	if (IS_ENABLED(CONFIG_CMA)) {
 		/*
 		 * Balance movable allocations between regular and CMA areas by
@@ -3948,9 +4005,22 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 */
 	switch (*mode) {
 	case RMQUEUE_NORMAL:
-		page = __rmqueue_smallest(zone, order, migratetype);
+		page = __rmqueue_smallest(zone, order, migratetype, walkp);
 		if (page)
 			return page;
+		/*
+		 * Refuse to fragment a clean SPB when a tainted SPB already
+		 * holds free pages or a free pageblock that could absorb
+		 * this allocation after evacuation. The caller has a cheap
+		 * fallback (lower-order retry, vmalloc, single-page fragment,
+		 * drop the packet, etc.) -- better that than tainting fresh
+		 * capacity. Pre-Pass-3 evac trigger in __rmqueue_smallest
+		 * already kicked deferred eviction.
+		 */
+		if (walkp && (walk.saw_free_pages || walk.saw_free_pb)) {
+			count_vm_event(SPB_HIGHORDER_REFUSED);
+			return NULL;
+		}
 		fallthrough;
 	case RMQUEUE_CMA:
 		if (alloc_flags & ALLOC_CMA) {
@@ -5073,7 +5143,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			spin_lock_irqsave(&zone->lock, flags);
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
-			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+			page = __rmqueue_smallest(zone, order,
+						  MIGRATE_HIGHATOMIC, NULL);
 		if (!page) {
 			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
@@ -5086,7 +5157,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
-				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+				page = __rmqueue_smallest(zone, order,
+							  MIGRATE_HIGHATOMIC,
+							  NULL);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
@@ -6435,6 +6508,36 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
 
+	/*
+	 * Mark callers that have a cheap fallback if the page allocator returns
+	 * NULL, so __rmqueue can refuse to taint a clean SPB when an existing
+	 * tainted SPB still has free pageblocks waiting to be evacuated.
+	 *
+	 * Two shapes qualify:
+	 *
+	 *  1. Explicit fallback declaration: __GFP_NORETRY without
+	 *     __GFP_RETRY_MAYFAIL. Used by THP, slab high-order refill,
+	 *     skb_page_frag_refill on full sockets, etc.
+	 *
+	 *  2. Atomic-context shape: no __GFP_DIRECT_RECLAIM, no __GFP_NOMEMALLOC,
+	 *     no __GFP_NOFAIL. These callers (GFP_ATOMIC, GFP_NOWAIT, including
+	 *     ALLOC_HIGHATOMIC consumers) have implicit fallbacks: drop the
+	 *     packet, demote the slab order, return ENOMEM up the slowpath,
+	 *     retry from process context with GFP_KERNEL, etc. ALLOC_HIGHATOMIC
+	 *     callers also get a second crack at the dedicated MIGRATE_HIGHATOMIC
+	 *     reserve in rmqueue_buddy after __rmqueue returns NULL.
+	 *     Tainting a 1 GiB SPB to satisfy any of them is a long-lived
+	 *     fragmentation event for short-lived data.
+	 *
+	 * __GFP_MEMALLOC (reclaim recursion) and __GFP_NOFAIL (declared cannot
+	 * fail) are excluded -- they must succeed even at the cost of taint.
+	 */
+	if ((gfp_mask & __GFP_NORETRY) && !(gfp_mask & __GFP_RETRY_MAYFAIL))
+		alloc_flags |= ALLOC_HIGHORDER_OPTIONAL;
+	else if (!(gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_NOMEMALLOC |
+			       __GFP_NOFAIL)))
+		alloc_flags |= ALLOC_HIGHORDER_OPTIONAL;
+
 	return alloc_flags;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9133254b6b87..0be1b969f493 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1388,6 +1388,7 @@ const char * const vmstat_text[] = {
 	[I(CMA_ALLOC_SUCCESS)]			= "cma_alloc_success",
 	[I(CMA_ALLOC_FAIL)]			= "cma_alloc_fail",
 #endif
+	[I(SPB_HIGHORDER_REFUSED)]		= "spb_highorder_refused",
 	[I(UNEVICTABLE_PGCULLED)]		= "unevictable_pgs_culled",
 	[I(UNEVICTABLE_PGSCANNED)]		= "unevictable_pgs_scanned",
 	[I(UNEVICTABLE_PGRESCUED)]		= "unevictable_pgs_rescued",
-- 
2.54.0


