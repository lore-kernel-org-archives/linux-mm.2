Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7185CCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57B16B00B7; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0E76B00B9; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95C16B00B7; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6462D6B00B8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36F401A0182
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:12 +0000 (UTC)
X-FDA: 84716346624.10.8CB8F94
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 07E6F20013
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LOX0SZsH;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYJxISyVeFiMcvnpB40rCD/tf2jhRteBWAzRBOwDM/E=;
	b=08SuVd5gJS8W/qRZHYl8X3UTDdsCiX3OBWq7H3TSL5XqUboHbW4ZvR/0Ffs8YC2CRwaOU8
	0v4YKKXGsrMjRYzJXSWhtXdbl9fuqFLXk9mm2F6x8o12+hGCsA+FyVOMUGpCiASIBnVZXK
	GUwT9sdW3y7p2NO47vW+zcxKG/BFNCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580589; a=rsa-sha256;
	cv=none;
	b=sXp7kL7JgXYcJBnXk5SMdGckl3yQEcfFctqn/sRJg/9GA/buGrdGDes6pAk8eaBLT/Fs9C
	JSOEtJQ3mpIXS9sdkY0F0qCmvOrvg6HjpXUDRBpk6DB2wNPHpgXsKiJVdNGJStB8nUCleo
	FdQ7Klxn9QL+KMgsTm8QbvxNiAXszsE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LOX0SZsH;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qYJxISyVeFiMcvnpB40rCD/tf2jhRteBWAzRBOwDM/E=; b=LOX0SZsH6Wxxi3RWNtU8w8onfl
	O7JmJU9R+t83zWRbiC2nvLR9/kchVKRWx20Tdx9QzuKfokToQZwV9+gqJ3wyfWr1X2UySkOkXyJZ4
	Un/UdNrplf6F5PEcFmCjLWIhgHR30jdHsTD3sJGoIJY+80AMUJ01tAQhM3xlBtnXKiLBcDkBhcE6+
	ynePKEnbqo+cPFksXfL6Ohpwoh6GpJ1A4nCIg/FuAZCoxw5KuftdYynLEgqy7hWFjtOiZ43vlum0+
	MrAO80c1nnTzQ+bqhNez0+WUrWZWn6q/ZAVRGJg21R61j6PrZnNYYAT7LVgIy8VFz+aPYDM0fi6o+
	vEDO80HA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-0sDm;
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
Subject: [RFC PATCH 29/45] mm: page_alloc: refuse fragmenting fallback for callers with cheap fallback
Date: Thu, 30 Apr 2026 16:20:58 -0400
Message-ID: <20260430202233.111010-30-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07E6F20013
X-Rspam-User: 
X-Stat-Signature: 43ahyf7ctwy6ia34ogj3yi9y49o3kfcg
X-HE-Tag: 1777580588-999420
X-HE-Meta: U2FsdGVkX18Gx7AYErRsQoix1LAkEHxDrOO0Nl1wyk+B1ScnZ6Wi/QvWzAdEvLcNZ0W+BAQxU671bSJ8gK4z9CoYv5Wpk5zRKbN0vpe6Ny2mOJmw0wyESsxxY8dABxjL6g3+/8CNiP8qlMDV7YExeX/Zw20an9YosVmWmuFfgNS9pBA3541H5yOrhL1E8jThvZyBhYyH8j8xJvammZA5N+koBHkYO/7iOF+RwAPxVQfDJrR6YY8gL3s8HZkWhiNFUbQq+IX/B6UnNW7JmqNYkxIzsBcz/wAJZGL1EA7yvO20+Z84aE6AqVO/C7n7eQ2K9ogbXAJWH4sYD8HavkUnrkEb06T0mBTpAIzG5XpYdR/ReuzDYzhLxIKOVREb4R3eZ6MPr0DdeyJtBE2Zl79xkbh6PvQXuslUetoiUGCTP+Pw+/ei3/lQ2Lvwk8tBNe6moIaVeFhNcA/0/0qKFOoAdYuJaeM4EzsvoWeMsEq5TjQDBNTli/UcfFt35hIJI0QESDyzgewmdF/CWfieUx77RXPr5bae4/aS/bIWQjSeEtjA3Q/sPLq2RtqSmWwwRyqoQXIH2mSbLkpuvBtNMmMMJl+r3MY5TIMs6NkIv8Ppm0DyNX0OFblPj5UErco+1ausyhUSqCNGAvXr+LJQ0n3FJc6rXolENYR9zQ8Tr2EUP05fOf/4jycE/iLE9/2vHW8jzC4EMOeFMfEtTKOynGkrgZciGYankQP3zgG5MWCSEWNV5C4O1YLu+m2WK1janmBpkKYM3zW8/AoPiWKgwxGS3GtGd8TQ2s993d14Am8zcCR9KlRM5BY+Z4+Uicatane+Cywgx48YNRISiLWV51EKN2KqICy/Q7SlJehPj1SGNyK2QhYYHdS2q9cPAJoXZyUTIbyVl//e3zryGvj15FZYdhdk9NWNXHxvw/NasEomM5d+uqTW9q3z+3oF9j3gtUKK+ik+tpAbX+VjREmLD9X
 U3Tss5Nw
 VraYMr/GegEC+i/rutwffalRVlLhsh/NNtGb02l/eDJBeg6Q2YwyyHes8gEymmWGL4ct+dBHcWO14F/xx5T16AN+v5ZybeLOxRYSWyfdpnuOquMmo5q8/+G+s7L5+GtpIh91Z3xih5rhEyuodcTdz8POEGZRbDbRaKVKsVb6e3IIylDYZi4CMAW/WtsurBjwXSkAMGjNtpesQx/wryfBEfEqLPfUHp0nB9TEAHs1ZgaqxVPy3ZUk8ji/8BNBEc9I5c/mFIDZIN+r6daEMUv6v9/VeolnB1lHw7e0ATla/XGB5Ruylx2O24E72531u2XkqkpVNR/FS60nxbzYZ+0Cgk4gS3nzMcjyjTwHTdYABHk+9tGeM5HBJ2Iq5IRgagdgCqUC4J6v8+2MDoFiYi6QJRnidwQw/oIfrdF2w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The two reverted bail-out gates from commit 2550578e3408 ("mm:
page_alloc: refuse to taint clean SPBs for best-effort allocations") and
commit 3d5f94a1bbe2 ("mm: page_alloc: gate clean-SPB taint bail-out on
ALLOC_HIGHATOMIC")
returned NULL from get_page_from_freelist's slowpath retry to keep
atomic-shape allocations from tainting clean SPBs. That gate broke
early-boot in QEMU: cred_init's slab cache create reaches the slowpath
with gfp = __GFP_COMP (gfp_allowed_mask = GFP_BOOT_MASK strips
__GFP_RECLAIM from GFP_KERNEL during boot), no fallback path, and
panicked when the gate refused the allocation.

Replace the gate with a finer-grained refusal anchored in __rmqueue,
where the SPB-aware free-list walk already runs:

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

    __GFP_MEMALLOC and __GFP_NOFAIL never get the flag — they must
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
    callers that lack ALLOC_HIGHORDER_OPTIONAL — i.e. the truly
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
index 22a139f82d75..3de6ca1e9c56 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -89,6 +89,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
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
index f641795688af..71e39414645f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1414,6 +1414,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 #define ALLOC_NOFRAG_TAINTED_OK	0x1000 /* NOFRAGMENT, but allow steal from tainted SPBs */
+#define ALLOC_HIGHORDER_OPTIONAL 0x2000 /* caller can fall back to a lower order */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a09660a06ed3..9305b36f52a6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2783,9 +2783,21 @@ static struct page *try_to_claim_block(struct zone *zone, struct page *page,
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
@@ -2834,6 +2846,20 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
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
@@ -2959,6 +2985,16 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
@@ -3082,7 +3118,7 @@ static inline bool noncompatible_cross_type(int start_type, int fallback_type)
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
 					unsigned int order)
 {
-	return __rmqueue_smallest(zone, order, MIGRATE_CMA);
+	return __rmqueue_smallest(zone, order, MIGRATE_CMA, NULL);
 }
 #else
 static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
@@ -3557,7 +3593,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (sb)
 		spb_update_list(sb);
 #endif
-	return __rmqueue_smallest(zone, order, start_type);
+	return __rmqueue_smallest(zone, order, start_type, NULL);
 }
 
 /*
@@ -3904,8 +3940,29 @@ static __always_inline struct page *
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
@@ -3932,9 +3989,22 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
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
+		 * drop the packet, etc.) — better that than tainting fresh
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
@@ -4973,7 +5043,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			spin_lock_irqsave(&zone->lock, flags);
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
-			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+			page = __rmqueue_smallest(zone, order,
+						  MIGRATE_HIGHATOMIC, NULL);
 		if (!page) {
 			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
@@ -4986,7 +5057,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
-				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+				page = __rmqueue_smallest(zone, order,
+							  MIGRATE_HIGHATOMIC,
+							  NULL);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
@@ -6302,6 +6375,36 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
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
+	 * fail) are excluded — they must succeed even at the cost of taint.
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
index 32027b8c0526..8a6c9120d325 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1385,6 +1385,7 @@ const char * const vmstat_text[] = {
 	[I(CMA_ALLOC_SUCCESS)]			= "cma_alloc_success",
 	[I(CMA_ALLOC_FAIL)]			= "cma_alloc_fail",
 #endif
+	[I(SPB_HIGHORDER_REFUSED)]		= "spb_highorder_refused",
 	[I(UNEVICTABLE_PGCULLED)]		= "unevictable_pgs_culled",
 	[I(UNEVICTABLE_PGSCANNED)]		= "unevictable_pgs_scanned",
 	[I(UNEVICTABLE_PGRESCUED)]		= "unevictable_pgs_rescued",
-- 
2.52.0


