Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B40CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394016B00C4; Wed, 20 May 2026 11:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D136B00C7; Wed, 20 May 2026 11:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F9D6B00C5; Wed, 20 May 2026 11:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F14786B00C3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB17740365
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:07 +0000 (UTC)
X-FDA: 84788110974.15.9B13E27
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id B4DFA40025
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VqGgf3CY;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJCxp07sL7BPWTjtROCBl4DjRFWKw8FYiTrUwOD4HTE=;
	b=VI6UsQYch8rvaZbSzdrwPxn+vZauJqk19Rwfgyhbl8KThJof/kw1+nC2zHng2FbAIsRZyr
	ekEDGDwTf64qFaQafpr2B3o8KvjcweeRSyQNB/EFwT8gnlynwTsaN3sa6v+oh+1MP1ZkKw
	4wRfvnsfhJi0LxeG6D9XghJBQO2hZ/c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VqGgf3CY;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289265; a=rsa-sha256;
	cv=none;
	b=TvMeLxybuavIrRFHmDUJNErLCxbm64NFFOZeQR1ZkuiFxWypGAco6kxFNtfSQ6HeeCzXVG
	2tR6A9BKbhhN3QgTKTsnMJ4AEYOXp+WIau2VD2EQozAQyP0Es19IppK7sE392VZz6x8+PF
	dULxJegi9GtqYvNoMzZL5iBkDeg6vmE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AJCxp07sL7BPWTjtROCBl4DjRFWKw8FYiTrUwOD4HTE=; b=VqGgf3CYnn1QkSOi48utoihLVp
	2Nt49IpyBwvK7MZ9NrmXi5+v98uTWMgl+Fx1mWYEToCnWViHIOLWgpDIp0vD57uWY+IqpVWGIYBRp
	9gOq1dun1P6u0nygaz2bQdnPavZxCHzklGabauxFIqm+N5YkZt9Cv+GMMalLk6oK16HDSMAcGNsX9
	yy5pjq5mBjWHe2gXDX7eTgqVBO0/mo8egdHPQHaUwbrn2IaUCGsoaEoh8Gj3KEuZJ+B8IphUZk+2t
	btaCTXumll7bBJ9VKR01cogQI5QapqgGPL5F07qDN68ncHTEBcudQv0THwfZmGRBne+rGb85W6vJV
	0hDt/yPw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0Dyy;
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
	Johannes Weiner <hnaz@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 02/40] mm: page_alloc: per-cpu pageblock buddy allocator
Date: Wed, 20 May 2026 10:59:08 -0400
Message-ID: <20260520150018.2491267-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4DFA40025
X-Stat-Signature: zbyt1s5e5wz8c5h5h8kuqyuetaoigmbt
X-HE-Tag: 1779289265-497761
X-HE-Meta: U2FsdGVkX1/luy5d6gF3WD5UH27B3F5Ap88dPyN+fTxeD54fGSpSvl0cJJ6hLblJ9OqNmHG3kh7OmUxnImFZgp2ugcYilty1PdjDEg+Ig/itQH7dNu4LS2TxtkMF6i+5iG55AKbIOQG8bNH4sdc8rwiE/dNFPkpwr+8wGZpXMjnRHqjJ/+xqnrE9n1NORRVwogwSHnHhca69Wwps6/4Zig1aiDFbecpXA9A0Si8WAzaGtS3Rm4YIzNWAPCiufMwd4thvusCgeq6MexJgsWD/HB/tIXXp076xWNFXTNQ1HOPUW4l7kneP3Gk0XUr/FedgEw5R/iFli13jK7/UsIjtK+VcLiPjRvNuMGKKIxuTuz9ZIn6qlKIuPh5UPH/A3p/nqe5NJtSu3GNv1xa2Sa50WG0i9orS1Xqfjb0QIfNy3ihkLZUVK1NWhijmNFJbvsSBDrJ4YchaqKZmVYAxiRtaT64djiXRoA4O1rSXY6qUUaQH7B2ILT+6TZk29xk2NEaSkzf4So34JQbXH6PuN5yrEx18IX1Ll9i7JvDMAk52xphfFKBSGammHVsx/LGZQiPXiGp5TfX7ikTp/RDR/gFUWA0390mno2kt6BkqDd0be080q51qJbZMRlt4H/Rk6nG6jfqZ/IyAviH6VOlIhTI6QV9IWJwvG1GuNK536A9Z3sNXbCO1GP6Wz4rfY7m0lMedjZIh5yBiQDUE/m6BzINTxyXIxpIVC8rEZju97STtZgfNEAb30QI3CivijdZz6D3dN2pV/WA8M9BiBhdO9CeOKO+oRS6jYfzkFUpMiAzkYJJk643ElownWWvWtKOCl1YlSbeyxGRftNZNxabZmE8wPgGUtoVG3Pc8+9F4FMNsJbJQM++39Zz+RLtsmMNZ3/cf3g/xSAK5U3p/ZDJfy0rLI2c7ClFhwk5V+YkOXRlDkyq66Okoe28WLbmLHQA2a6JAAvj2kKBZmgVeCeywpXh
 4r41gXwf
 /LnIqH6bVvMuDIEJAujZvBA0vUFkiPi4Bt5fSqo7/wdmOVmphEFzCgImz2p2xTBfuZ8HLYygWgllIiPSX+Jbha+KC/SFk4Qc7U9kRjx2zoVgJX2itF1I0s+KV6TKMZvgfI8sjkXYHdL496dv1/lf8QZa/Z3fU+NgusMDFRZiGpGb2QCHVFBmHV5RHMIgQsf9uKt6DPk1Q7DEzBOR0SdcKWuNGmxBqTze+87/1BBtPfWVMq23rlMsVI0OqBqzaUl9/J+j8OMUKVxFPyW1H2hAqPqSriMJ6f3AKH1vF0544xk1KYPfzieAK4H1koEDz67rfgm+GuP3pcrHVkwOtyjHOT6AoBzBSqrPvL7NqD+zieSx5aT48JGUVA9Iys5GvLNvdx1ew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <hannes@cmpxchg.org>

On large machines, zone->lock is a scaling bottleneck for page
allocation. Two common patterns drive contention:

1. Affinity violations: pages are allocated on one CPU but freed on
another (jemalloc, exit, reclaim). The freeing CPU's PCP drains to
zone buddy, and the allocating CPU refills from zone buddy -- both
under zone->lock, defeating PCP batching entirely.

2. Concurrent exits: processes tearing down large address spaces
simultaneously overwhelm per-CPU PCP capacity, serializing on
zone->lock for overflow.

Solution

Extend the PCP to operate on whole pageblocks with ownership tracking.

Each CPU claims pageblocks from the zone buddy and splits them
locally. Pages are tagged with their owning CPU, so frees route back
to the owner's PCP regardless of which CPU frees. This eliminates
affinity violations: the owner CPU's PCP absorbs both allocations and
frees for its blocks without touching zone->lock.

It also shortens zone->lock hold time during drain and refill
cycles. Whole blocks are acquired under zone->lock and then split
outside of it. Affinity routing to the owning PCP on free enables
buddy merging outside the zone->lock as well; a bottom-up merge pass
runs under pcp->lock on drain, freeing larger chunks under zone->lock.

PCP refill uses a four-phase approach:

Phase 0: recover owned fragments previously drained to zone buddy.
Phase 1: claim whole pageblocks from zone buddy.
Phase 2: grab sub-pageblock chunks without migratetype stealing.
Phase 3: traditional __rmqueue() with migratetype fallback.

Phase 0/1 pages are owned and marked PagePCPBuddy, making them
eligible for PCP-level merging. Phase 2/3 pages are cached on PCP for
batching only -- no ownership, no merging. However, Phase 2 still
benefits from chunky zone transactions: it pulls higher-order entries
from zone free lists under zone->lock and splits them on the PCP
outside of it, rather than acquiring zone->lock per page.

When PCP batch sizes are small (small machines with few CPUs) or the
zone is fragmented and no whole pageblocks are available, refill falls
through to Phase 2/3 naturally. The allocator degrades gracefully to
the original page-at-a-time behavior.

When owned blocks accumulate long-lived allocations (e.g. a mix of
anonymous and file cache pages), partial block drains send the free
fragments to zone buddy and remember the block, so Phase 0 can recover
them on the next refill. This allows the allocator to pack new
allocations next to existing ones in already-committed blocks rather
than consuming fresh pageblocks, keeping fragmentation contained.

Data structures:

- per_cpu_pages: +owned_blocks list head, +PCPF_CPU_DEAD flag to gate
  enqueuing on offline CPUs.
- pageblock_data: +cpu (owner), +block_pfn, +cpu_node (recovery list
  linkage). 32 bytes per pageblock, ~16KB per GB with 2MB pageblocks.
- PagePCPBuddy page type marks pages eligible for PCP-level merging.

[riel@surriel.com: fix ownership clearing on direct block frees]

Note (checkpatch-rationale): the two VM_BUG_ON(order >
PAGE_BLOCK_MAX_ORDER) assertions in __pcp_buddy_idx() and
__pcp_buddy_order() are intentional and should remain BUG()-class
rather than WARN_ON_ONCE(). Their result is used as an array index
into the per-CPU pageblock free lists; a violation means the caller
passed an invalid order and the index would corrupt adjacent state.
Both are VM_BUG_ON (compiled out unless CONFIG_DEBUG_VM=y) and
follow the established mm/page_alloc.c convention for invariants on
the buddy index domain (see neighbouring VM_BUG_ON(order >
PAGE_ALLOC_COSTLY_ORDER) call sites this patch replaces).

Signed-off-by: Johannes Weiner <hnaz@cmpxchg.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h     |  23 +-
 include/linux/page-flags.h |   9 +
 mm/debug.c                 |   1 +
 mm/page_alloc.c            | 668 ++++++++++++++++++++++++++++++-------
 4 files changed, 576 insertions(+), 125 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 935ddc78f636..f0eb16390906 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -802,17 +802,10 @@ enum zone_watermarks {
 };
 
 /*
- * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER. Two additional lists
- * are added for THP. One PCP list is used by GPF_MOVABLE, and the other PCP list
- * is used by GFP_UNMOVABLE and GFP_RECLAIMABLE.
+ * One per migratetype for page orders up to and including PAGE_BLOCK_MAX_ORDER.
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define NR_PCP_THP 2
-#else
-#define NR_PCP_THP 0
-#endif
-#define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
-#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
+#define NR_PCP_ORDERS (PAGE_BLOCK_MAX_ORDER + 1)
+#define NR_PCP_LISTS (MIGRATE_PCPTYPES * NR_PCP_ORDERS)
 
 /*
  * Flags used in pcp->flags field.
@@ -825,9 +818,13 @@ enum zone_watermarks {
  * draining PCP for consecutive high-order pages freeing without
  * allocation if data cache slice of CPU is large enough.  To reduce
  * zone lock contention and keep cache-hot pages reusing.
+ *
+ * PCPF_CPU_DEAD: CPU is offline.  Don't enqueue freed pages; fall
+ * back to zone buddy instead.
  */
 #define	PCPF_PREV_FREE_HIGH_ORDER	BIT(0)
 #define	PCPF_FREE_HIGH_BATCH		BIT(1)
+#define	PCPF_CPU_DEAD			BIT(2)
 
 struct per_cpu_pages {
 	spinlock_t lock;	/* Protects lists field */
@@ -843,6 +840,9 @@ struct per_cpu_pages {
 #endif
 	short free_count;	/* consecutive free count */
 
+	/* Pageblocks owned by this CPU, for fragment recovery */
+	struct list_head owned_blocks;
+
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[NR_PCP_LISTS];
 } ____cacheline_aligned_in_smp;
@@ -1991,6 +1991,9 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
 
 struct pageblock_data {
 	unsigned long flags;
+	int cpu;			/* PCP ownership: owning cpu + 1, or 0 for zone-owned */
+	unsigned long block_pfn;	/* first PFN of pageblock */
+	struct list_head cpu_node;	/* per-CPU owned-blocks list */
 };
 
 struct mem_section_usage {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..96b4735f50a0 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -924,6 +924,7 @@ enum pagetype {
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
 	PGTY_netpp		= 0xf9,
+	PGTY_pcp_buddy		= 0xfa,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -992,6 +993,14 @@ static __always_inline void __ClearPage##uname(struct page *page)	\
  */
 PAGE_TYPE_OPS(Buddy, buddy, buddy)
 
+/*
+ * PagePCPBuddy() indicates that the page is free and in a per-cpu
+ * buddy allocator (see mm/page_alloc.c). Unlike PageBuddy() pages,
+ * these are not on zone free lists and must not be isolated by
+ * compaction or other zone-level code.
+ */
+PAGE_TYPE_OPS(PCPBuddy, pcp_buddy, pcp_buddy)
+
 /*
  * PageOffline() indicates that the page is logically offline although the
  * containing section is online. (e.g. inflated in a balloon driver or
diff --git a/mm/debug.c b/mm/debug.c
index 77fa8fe1d641..d4542d5d202b 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -56,6 +56,7 @@ static const char *page_type_names[] = {
 	DEF_PAGETYPE_NAME(table),
 	DEF_PAGETYPE_NAME(buddy),
 	DEF_PAGETYPE_NAME(unaccepted),
+	DEF_PAGETYPE_NAME(pcp_buddy),
 };
 
 static const char *page_type_name(unsigned int page_type)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fcff0083d5d4..a3448a97bab2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -370,6 +370,22 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
 	return test_bit(pb_bit, get_pfnblock_flags_word(page, pfn));
 }
 
+/*
+ * Extract migratetype from a pageblock_data pointer. Callers that
+ * already have the pbd can avoid a redundant pfn_to_pageblock().
+ */
+static __always_inline enum migratetype
+pbd_migratetype(const struct pageblock_data *pbd)
+{
+	unsigned long flags = READ_ONCE(pbd->flags) & MIGRATETYPE_AND_ISO_MASK;
+
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (flags & BIT(PB_migrate_isolate))
+		return MIGRATE_ISOLATE;
+#endif
+	return flags & MIGRATETYPE_MASK;
+}
+
 /**
  * get_pfnblock_migratetype - Return the migratetype of a pageblock
  * @page: The page within the block of interest
@@ -383,16 +399,7 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
-	unsigned long flags;
-
-	flags = __get_pfnblock_flags_mask(page, pfn, mask);
-
-#ifdef CONFIG_MEMORY_ISOLATION
-	if (flags & BIT(PB_migrate_isolate))
-		return MIGRATE_ISOLATE;
-#endif
-	return flags & MIGRATETYPE_MASK;
+	return pbd_migratetype(pfn_to_pageblock(page, pfn));
 }
 
 /**
@@ -476,6 +483,8 @@ void __meminit init_pageblock_migratetype(struct page *page,
 					  enum migratetype migratetype,
 					  bool isolate)
 {
+	unsigned long pfn = page_to_pfn(page);
+	struct pageblock_data *pbd;
 	unsigned long flags;
 
 	if (unlikely(page_group_by_mobility_disabled &&
@@ -494,8 +503,11 @@ void __meminit init_pageblock_migratetype(struct page *page,
 	if (isolate)
 		flags |= BIT(PB_migrate_isolate);
 #endif
-	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  MIGRATETYPE_AND_ISO_MASK);
+	__set_pfnblock_flags_mask(page, pfn, flags, MIGRATETYPE_AND_ISO_MASK);
+
+	pbd = pfn_to_pageblock(page, pfn);
+	pbd->block_pfn = pfn;
+	INIT_LIST_HEAD(&pbd->cpu_node);
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -581,19 +593,7 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(!is_pmd_order(order));
-
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
-	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	VM_BUG_ON(order > PAGE_BLOCK_MAX_ORDER);
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -602,25 +602,14 @@ static inline int pindex_to_order(unsigned int pindex)
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	VM_BUG_ON(order > PAGE_BLOCK_MAX_ORDER);
 
 	return order;
 }
 
 static inline bool pcp_allowed_order(unsigned int order)
 {
-	if (order <= PAGE_ALLOC_COSTLY_ORDER)
-		return true;
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (is_pmd_order(order))
-		return true;
-#endif
-	return false;
+	return order <= pageblock_order;
 }
 
 /*
@@ -653,6 +642,91 @@ static inline void set_buddy_order(struct page *page, unsigned int order)
 	__SetPageBuddy(page);
 }
 
+/*
+ * PCP pageblock ownership tracking.
+ *
+ * Ownership rules:
+ * - Whole pageblocks acquired by rmqueue_bulk() Phase 1 are owned, meaning
+ *   all frees will be routed to that PCP.
+ * - Draining a whole pageblock back to the zone clears PCP ownership.
+ * - Draining a partial block (due to PCP thresholds or memory pressure) puts
+ *   the block on the pcp->owned_blocks list. A later refill will attempt to
+ *   recover it in Phase 0.
+ * - Whole pageblocks can assemble on the zone buddy due to PCP bypasses,
+ *   e.g. during lock contention. __free_one_page() clears stale ownership.
+ * - Phases 2/3 refill with fragments for pure caching - if there are not
+ *   enough blocks or pcp->high restrictions. They do not participate
+ *   in ownership, affinity enforcement, or on-PCP merging.
+ *
+ * PagePCPBuddy means "mergeable buddy on home PCP":
+ * - Set when Phase 0/1 restore or acquire whole pageblocks.
+ * - Propagated to split remainders in pcp_rmqueue_smallest().
+ * - Set on freed pages from owned blocks routed to the owner PCP.
+ * - NOT set for Phase 2/3 fragments or zone-owned frees.
+ * - The merge pass in free_pcppages_bulk() only processes
+ *   PagePCPBuddy pages, ensuring it never touches pages on
+ *   another CPU's PCP list.
+ *
+ * We store the owning CPU + 1, so the default value of 0 in those
+ * arrays means no owner / zone owner (and not CPU 0).
+ */
+
+static inline void clear_pcpblock_owner(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct pageblock_data *pbd = pfn_to_pageblock(page, pfn);
+
+	pbd->cpu = 0;
+	list_del_init(&pbd->cpu_node);
+}
+
+static inline void set_pcpblock_owner(struct page *page, int cpu)
+{
+	pfn_to_pageblock(page, page_to_pfn(page))->cpu = cpu + 1;
+}
+
+static inline int get_pcpblock_owner(struct page *page)
+{
+	return pfn_to_pageblock(page, page_to_pfn(page))->cpu - 1;
+}
+
+static inline void set_pcp_order(struct page *page, unsigned int order)
+{
+	set_page_private(page, order);
+}
+
+static inline unsigned int pcp_buddy_order(struct page *page)
+{
+	return page_private(page);
+}
+
+static void pcp_enqueue(struct per_cpu_pages *pcp, struct page *page,
+			int migratetype, unsigned int order)
+{
+	set_pcp_order(page, order);
+	list_add(&page->pcp_list,
+		 &pcp->lists[order_to_pindex(migratetype, order)]);
+	pcp->count += 1 << order;
+}
+
+static void pcp_enqueue_tail(struct per_cpu_pages *pcp, struct page *page,
+			     int migratetype, unsigned int order)
+{
+	set_pcp_order(page, order);
+	list_add_tail(&page->pcp_list,
+		      &pcp->lists[order_to_pindex(migratetype, order)]);
+	pcp->count += 1 << order;
+}
+
+static void pcp_dequeue(struct per_cpu_pages *pcp, struct page *page,
+			unsigned int order)
+{
+	list_del(&page->pcp_list);
+	__ClearPagePCPBuddy(page);
+	set_page_private(page, 0);
+	pcp->count -= 1 << order;
+}
+
 #ifdef CONFIG_COMPACTION
 static inline struct capture_control *task_capc(struct zone *zone)
 {
@@ -893,6 +967,21 @@ static inline void __free_one_page(struct page *page,
 
 	account_freepages(zone, 1 << order, migratetype);
 
+	/*
+	 * For whole blocks, ownership returns to the zone. There are
+	 * no more outstanding frees to route through that CPU's PCP,
+	 * and we don't want to confuse any future users of the pages
+	 * in this block. E.g. rmqueue_buddy().
+	 *
+	 * Check here if a whole block came in directly: pre-merged in
+	 * the PCP, or PCP contended and bypassed.
+	 *
+	 * There is another check in the loop below if a block merges
+	 * up with pages already on the zone buddy.
+	 */
+	if (order == pageblock_order)
+		clear_pcpblock_owner(page);
+
 	while (order < MAX_PAGE_ORDER) {
 		int buddy_mt = migratetype;
 
@@ -942,6 +1031,10 @@ static inline void __free_one_page(struct page *page,
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		/* Clear owner also when we merge up. See above */
+		if (order == pageblock_order)
+			clear_pcpblock_owner(page);
 	}
 
 done_merging:
@@ -1390,17 +1483,24 @@ bool free_pages_prepare(struct page *page, unsigned int order)
 }
 
 /*
- * Frees a number of pages from the PCP lists
- * Assumes all pages on list are in same zone.
- * count is the number of pages to free.
+ * Free PCP pages to zone buddy. First does a bottom-up merge pass
+ * over PagePCPBuddy entries under pcp->lock only (already held by
+ * caller). Only pages marked PagePCPBuddy (owned-block pages on
+ * their home PCP) participate in merging; non-owned pages (Phase
+ * 2/3 fragments) are skipped and drain individually.
+ *
+ * Then drains pages to zone under zone->lock, starting with
+ * fully-merged pageblocks via round-robin. When those are exhausted,
+ * falls through to smaller orders. Draining a pageblock-order page
+ * disowns the block.
  */
 static void free_pcppages_bulk(struct zone *zone, int count,
-					struct per_cpu_pages *pcp,
-					int pindex)
+				struct per_cpu_pages *pcp)
 {
 	unsigned long flags;
 	unsigned int order;
 	struct page *page;
+	int mt, pindex;
 
 	/*
 	 * Ensure proper count is passed which otherwise would stuck in the
@@ -1408,8 +1508,45 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	 */
 	count = min(pcp->count, count);
 
-	/* Ensure requested pindex is drained first. */
-	pindex = pindex - 1;
+	/* PCP merge pass */
+	for (order = 0; order < pageblock_order; order++) {
+		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+			struct list_head *list;
+			struct page *page, *tmp;
+
+			list = &pcp->lists[order_to_pindex(mt, order)];
+			list_for_each_entry_safe(page, tmp, list, pcp_list) {
+				unsigned long pfn = page_to_pfn(page);
+				unsigned long buddy_pfn = __find_buddy_pfn(pfn, order);
+				struct page *buddy = page + (buddy_pfn - pfn);
+				unsigned long combined_pfn;
+				struct page *combined;
+
+				if (!PagePCPBuddy(page))
+					continue;
+				if (!PagePCPBuddy(buddy))
+					continue;
+				if (pcp_buddy_order(buddy) != order)
+					continue;
+
+				/* Don't corrupt the safe iterator! */
+				if (buddy == tmp)
+					tmp = list_next_entry(tmp, pcp_list);
+
+				pcp_dequeue(pcp, page, order);
+				pcp_dequeue(pcp, buddy, order);
+
+				combined_pfn = buddy_pfn & pfn;
+				combined = page + (combined_pfn - pfn);
+
+				__SetPagePCPBuddy(combined);
+				pcp_enqueue_tail(pcp, combined, mt, order + 1);
+			}
+		}
+	}
+
+	/* Ensure pageblock orders are drained first. */
+	pindex = order_to_pindex(0, pageblock_order) - 1;
 
 	spin_lock_irqsave(&zone->lock, flags);
 
@@ -1427,19 +1564,31 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		order = pindex_to_order(pindex);
 		nr_pages = 1 << order;
 		do {
+			fpi_t fpi = FPI_NONE;
 			unsigned long pfn;
-			int mt;
 
 			page = list_last_entry(list, struct page, pcp_list);
 			pfn = page_to_pfn(page);
 			mt = get_pfnblock_migratetype(page, pfn);
 
-			/* must delete to avoid corrupting pcp list */
-			list_del(&page->pcp_list);
+			/*
+			 * Owned fragment going to zone buddy: queue
+			 * block for recovery during the next refill,
+			 * and keep it away from other CPUs (tail).
+			 */
+			if (PagePCPBuddy(page) && order < pageblock_order) {
+				struct pageblock_data *pbd;
+
+				pbd = pfn_to_pageblock(page, pfn);
+				if (list_empty(&pbd->cpu_node))
+					list_add(&pbd->cpu_node, &pcp->owned_blocks);
+				fpi = FPI_TO_TAIL;
+			}
+
+			pcp_dequeue(pcp, page, order);
 			count -= nr_pages;
-			pcp->count -= nr_pages;
 
-			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
+			__free_one_page(page, pfn, zone, order, mt, fpi);
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
@@ -1447,6 +1596,45 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
+/*
+ * Search PCP free lists for a page of at least the requested order.
+ * If found at a higher order, split and place remainders on PCP lists.
+ * Returns NULL if nothing available on the PCP.
+ */
+static struct page *pcp_rmqueue_smallest(struct per_cpu_pages *pcp,
+					 int migratetype, unsigned int order)
+{
+	unsigned int high;
+
+	for (high = order; high <= pageblock_order; high++) {
+		struct list_head *list;
+		unsigned long size;
+		struct page *page;
+		bool owned;
+
+		list = &pcp->lists[order_to_pindex(migratetype, high)];
+		if (list_empty(list))
+			continue;
+
+		page = list_first_entry(list, struct page, pcp_list);
+		/* Save before pcp_dequeue() clears it */
+		owned = PagePCPBuddy(page);
+		pcp_dequeue(pcp, page, high);
+
+		size = 1 << high;
+		while (high > order) {
+			high--;
+			size >>= 1;
+			if (owned)
+				__SetPagePCPBuddy(&page[size]);
+			pcp_enqueue(pcp, &page[size], migratetype, high);
+		}
+
+		return page;
+	}
+	return NULL;
+}
+
 /* Split a multi-block free page into its individual pageblocks. */
 static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
@@ -1456,6 +1644,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
 	VM_WARN_ON_ONCE(PageBuddy(page));
+	VM_WARN_ON_ONCE(PagePCPBuddy(page));
 
 	if (order > pageblock_order)
 		order = pageblock_order;
@@ -2451,28 +2640,162 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 }
 
 /*
- * Obtain a specified number of elements from the buddy allocator, all under
- * a single hold of the lock, for efficiency.  Add them to the supplied list.
- * Returns the number of new pages which were placed at *list.
+ * Obtain a specified number of elements from the buddy allocator, all
+ * under a single hold of the lock, for efficiency.  Add them to the
+ * freelist of @pcp.
+ *
+ * When @pcp is non-NULL and @count > 1 (normal pageset), uses a four-phase
+ * approach:
+ *   Phase 0: Recover previously owned, partially drained blocks.
+ *   Phase 1: Acquire whole pageblocks, claim ownership, set PagePCPBuddy.
+ *            These pages are eligible for PCP-level buddy merging.
+ *   Phase 2: Grab sub-pageblock fragments of the same migratetype.
+ *   Phase 3: Fall back to __rmqueue() with migratetype fallback.
+ *   Phase 2/3 pages are cached for batching only -- no ownership claim,
+ *   no PagePCPBuddy, no PCP-level merging.
+ *
+ * When @pcp is NULL or @count <= 1 (boot pageset), acquires individual
+ * pages of the requested order directly.
+ *
+ * Returns %true if at least some pages were acquired.
  */
-static int rmqueue_bulk(struct zone *zone, unsigned int order,
-			unsigned long count, struct list_head *list,
-			int migratetype, unsigned int alloc_flags)
+static bool rmqueue_bulk(struct zone *zone, unsigned int order,
+			 unsigned long count,
+			 int migratetype, unsigned int alloc_flags,
+			 struct per_cpu_pages *pcp)
 {
+	unsigned long pages_needed = count << order;
 	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
+	struct pageblock_data *pbd, *tmp;
+	int cpu = smp_processor_id();
+	unsigned long refilled = 0;
 	unsigned long flags;
-	int i;
+	int o;
 
 	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags))
-			return 0;
+			return false;
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 	}
-	for (i = 0; i < count; ++i) {
+
+	if (!pcp || count <= 1)
+		goto phase3;
+
+	/*
+	 * Phase 0: Recover fragments from owned blocks.
+	 *
+	 * The owned_blocks list tracks blocks that have fragments
+	 * sitting in zone buddy (put there by drains). Pull matching
+	 * fragments back to PCP with PagePCPBuddy so they participate
+	 * in merging, instead of claiming fresh blocks and spreading
+	 * fragmentation further.
+	 *
+	 * Only recover blocks matching the requested migratetype.
+	 * After recovery, remove the block from the list -- the drain
+	 * path re-adds it if new fragments arrive.
+	 */
+	list_for_each_entry_safe(pbd, tmp, &pcp->owned_blocks, cpu_node) {
+		unsigned long base_pfn, pfn;
+		int block_mt;
+
+		base_pfn = pbd->block_pfn;
+		block_mt = pbd_migratetype(pbd);
+		if (block_mt != migratetype)
+			continue;
+
+		for (pfn = base_pfn; pfn < base_pfn + pageblock_nr_pages;) {
+			struct page *page = pfn_to_page(pfn);
+
+			if (!PageBuddy(page)) {
+				pfn++;
+				continue;
+			}
+
+			o = buddy_order(page);
+			del_page_from_free_list(page, zone, o, block_mt);
+			__SetPagePCPBuddy(page);
+			pcp_enqueue_tail(pcp, page, block_mt, o);
+			refilled += 1 << o;
+			pfn += 1 << o;
+		}
+
+		list_del_init(&pbd->cpu_node);
+
+		if (refilled >= pages_needed)
+			goto out;
+	}
+
+	/*
+	 * Phase 1: Try whole pageblocks. Fast path for unfragmented
+	 * zones. Claim ownership and set PagePCPBuddy so these pages
+	 * are eligible for PCP-level merging.
+	 *
+	 * Only grab blocks that fit within the refill budget. On
+	 * small zones, pages_needed can be less than a whole
+	 * pageblock; skip to smaller blocks or individual pages to
+	 * avoid overshooting the PCP high watermark.
+	 */
+	while (refilled + pageblock_nr_pages <= pages_needed) {
+		struct page *page;
+
+		page = __rmqueue(zone, pageblock_order,
+				 migratetype, alloc_flags, &rmqm);
+		if (!page)
+			break;
+
+		set_pcpblock_owner(page, cpu);
+		__SetPagePCPBuddy(page);
+		pcp_enqueue_tail(pcp, page, migratetype, pageblock_order);
+		refilled += 1 << pageblock_order;
+	}
+	if (refilled >= pages_needed)
+		goto out;
+
+	/*
+	 * Phase 2: Zone too fragmented for whole pageblocks.
+	 * Sweep zone free lists top-down for same-migratetype
+	 * chunks. Avoids cross-type stealing and keeps PCP
+	 * functional under fragmentation.
+	 *
+	 * No ownership claim or PagePCPBuddy - these are
+	 * sub-pageblock fragments cached for batching only.
+	 *
+	 * Stop above the requested order -- at that point,
+	 * phase 3's __rmqueue() does the same lookup but with
+	 * migratetype fallback.
+	 */
+	for (o = pageblock_order - 1;
+	     o > (int)order && refilled < pages_needed; o--) {
+		struct free_area *area = &zone->free_area[o];
+		struct page *page;
+
+		while (refilled + (1 << o) <= pages_needed) {
+			page = get_page_from_free_area(area, migratetype);
+			if (!page)
+				break;
+
+			del_page_from_free_list(page, zone, o, migratetype);
+			pcp_enqueue_tail(pcp, page, migratetype, o);
+			refilled += 1 << o;
+		}
+	}
+
+	/*
+	 * Phase 3: Last resort. Use __rmqueue() which does
+	 * migratetype fallback. Cache the pages on PCP to still
+	 * amortize future zone lock acquisitions.
+	 *
+	 * No ownership claim or PagePCPBuddy - these fragments
+	 * drain individually to zone buddy.
+	 *
+	 * Boot pagesets (count <= 1) jump here directly.
+	 */
+phase3:
+	while (refilled < pages_needed) {
 		struct page *page = __rmqueue(zone, order, migratetype,
 					      alloc_flags, &rmqm);
-		if (unlikely(page == NULL))
+		if (!page)
 			break;
 
 		/*
@@ -2485,11 +2808,13 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 * for IO devices that can merge IO requests if the physical
 		 * pages are ordered properly.
 		 */
-		list_add_tail(&page->pcp_list, list);
+		pcp_enqueue_tail(pcp, page, migratetype, order);
+		refilled += 1 << order;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return i;
+out:
+	spin_unlock_irqrestore(&zone->lock, flags);
+	return refilled;
 }
 
 /*
@@ -2519,7 +2844,7 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
 		pcp_spin_lock_nopin(pcp);
-		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp);
 		pcp_spin_unlock_nopin(pcp);
 		todo = true;
 
@@ -2543,7 +2868,7 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
 		pcp_spin_lock_nopin(pcp);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain, pcp);
 		pcp_spin_unlock_nopin(pcp);
 	}
 }
@@ -2564,7 +2889,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 			int to_drain = min(count,
 				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
 
-			free_pcppages_bulk(zone, to_drain, pcp, 0);
+			free_pcppages_bulk(zone, to_drain, pcp);
 			count -= to_drain;
 		}
 		pcp_spin_unlock_nopin(pcp);
@@ -2758,19 +3083,16 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
 }
 
 /*
- * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
- * pcp's watermarks below high.
- *
- * May return a freed pcp, if during page freeing the pcp spinlock cannot be
- * reacquired. Return true if pcp is locked, false otherwise.
+ * Free a page to the PCP and flush excess pages if necessary.
+ * Works for both local and remote PCP - caller handles locking.
+ * @owned: page is from a PCP-owned block (eligible for merging).
  */
 static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags)
+		unsigned int order, fpi_t fpi_flags, bool owned)
 {
 	int high, batch;
 	int to_free, to_free_batched;
-	int pindex;
 	int cpu = smp_processor_id();
 	int ret = true;
 	bool free_high = false;
@@ -2782,9 +3104,15 @@ static bool free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(migratetype, order);
-	list_add(&page->pcp_list, &pcp->lists[pindex]);
-	pcp->count += 1 << order;
+	/*
+	 * Only set PagePCPBuddy for pages from owned blocks -- those
+	 * are on their home PCP and eligible for buddy merging.
+	 * Zone-owned pages are cached on the local PCP for batching
+	 * only; the merge pass skips them harmlessly.
+	 */
+	if (owned)
+		__SetPagePCPBuddy(page);
+	pcp_enqueue(pcp, page, migratetype, order);
 
 	batch = READ_ONCE(pcp->batch);
 	/*
@@ -2820,7 +3148,13 @@ static bool free_frozen_page_commit(struct zone *zone,
 	to_free = nr_pcp_free(pcp, batch, high, free_high);
 	while (to_free > 0 && pcp->count > 0) {
 		to_free_batched = min(to_free, batch);
-		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
+		/*
+		 * pindex=0: SPB-aware free_pcppages_bulk scans all PCP
+		 * lists; we don't track a single pindex hint here because
+		 * pcp_enqueue distributed the page across the PCP buddy
+		 * lists per migratetype.
+		 */
+		free_pcppages_bulk(zone, to_free_batched, pcp);
 		to_free -= to_free_batched;
 
 		if (to_free == 0 || pcp->count == 0)
@@ -2863,6 +3197,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
+
 	return ret;
 }
 
@@ -2873,9 +3208,11 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 				fpi_t fpi_flags)
 {
 	struct per_cpu_pages *pcp;
+	struct pageblock_data *pbd;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
+	int owner_cpu, cache_cpu;
 
 	if (!pcp_allowed_order(order)) {
 		__free_pages_ok(page, order, fpi_flags);
@@ -2893,7 +3230,8 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	 * excessively into the page allocator
 	 */
 	zone = page_zone(page);
-	migratetype = get_pfnblock_migratetype(page, pfn);
+	pbd = pfn_to_pageblock(page, pfn);
+	migratetype = pbd_migratetype(pbd);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(zone, page, pfn, order, fpi_flags);
@@ -2907,15 +3245,45 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-	if (pcp) {
-		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
-						order, fpi_flags))
+
+	/*
+	 * Route page to the owning CPU's PCP for merging, or to
+	 * the local PCP for batching (zone-owned pages). Zone-owned
+	 * pages are cached without PagePCPBuddy -- the merge pass
+	 * skips them, so they're inert on any PCP list and drain
+	 * individually to zone buddy.
+	 *
+	 * Ownership is stable here: it can only change when the
+	 * pageblock is complete -- either fully free in zone buddy
+	 * (Phase 1 claims) or fully merged on PCP (drain disowns).
+	 * Since we hold this page, neither can happen.
+	 */
+	owner_cpu = pbd->cpu - 1;
+	cache_cpu = owner_cpu;
+	if (cache_cpu < 0)
+		cache_cpu = raw_smp_processor_id();
+
+	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
+	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
+		if (!spin_trylock(&pcp->lock)) {
+			free_one_page(zone, page, pfn, order, fpi_flags);
 			return;
-		pcp_spin_unlock(pcp);
+		}
 	} else {
+		spin_lock(&pcp->lock);
+	}
+
+	if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
+		spin_unlock(&pcp->lock);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+		return;
 	}
+
+	if (free_frozen_page_commit(zone, pcp, page, migratetype, order,
+				    fpi_flags, cache_cpu == owner_cpu))
+		spin_unlock(&pcp->lock);
+	/* If commit returned false, pcp was already unlocked (migration or
+	 * trylock failure inside the batched-free loop). */
 }
 
 void free_frozen_pages(struct page *page, unsigned int order)
@@ -2935,6 +3303,7 @@ void free_unref_folios(struct folio_batch *folios)
 {
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
+	int locked_cpu = -1;
 	int i, j;
 
 	/* Prepare folios for freeing */
@@ -2966,17 +3335,29 @@ void free_unref_folios(struct folio_batch *folios)
 		struct zone *zone = folio_zone(folio);
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = (unsigned long)folio->private;
+		struct pageblock_data *pbd;
 		int migratetype;
+		int owner_cpu, cache_cpu;
 
 		folio->private = NULL;
-		migratetype = get_pfnblock_migratetype(&folio->page, pfn);
+		pbd = pfn_to_pageblock(&folio->page, pfn);
+		migratetype = pbd_migratetype(pbd);
+		owner_cpu = pbd->cpu - 1;
+		cache_cpu = owner_cpu;
+		if (cache_cpu < 0)
+			cache_cpu = raw_smp_processor_id();
 
-		/* Different zone requires a different pcp lock */
+		/*
+		 * Re-lock needed if zone changed, page is isolate,
+		 * or target CPU changed.
+		 */
 		if (zone != locked_zone ||
-		    is_migrate_isolate(migratetype)) {
+		    is_migrate_isolate(migratetype) ||
+		    cache_cpu != locked_cpu) {
 			if (pcp) {
-				pcp_spin_unlock(pcp);
+				spin_unlock(&pcp->lock);
 				locked_zone = NULL;
+				locked_cpu = -1;
 				pcp = NULL;
 			}
 
@@ -2990,17 +3371,34 @@ void free_unref_folios(struct folio_batch *folios)
 				continue;
 			}
 
+			pcp = per_cpu_ptr(zone->per_cpu_pageset,
+					  cache_cpu);
 			/*
-			 * trylock is necessary as folios may be getting freed
-			 * from IRQ or SoftIRQ context after an IO completion.
+			 * Use trylock when not in task context (IRQ,
+			 * softirq) to avoid spinning with IRQs
+			 * disabled. In task context, spin -- brief
+			 * contention on a per-CPU lock beats the
+			 * unbatched zone->lock fallback.
 			 */
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-			if (unlikely(!pcp)) {
+			if (!in_task()) {
+				if (unlikely(!spin_trylock(&pcp->lock))) {
+					pcp = NULL;
+					free_one_page(zone, &folio->page, pfn,
+						      order, FPI_NONE);
+					continue;
+				}
+			} else {
+				spin_lock(&pcp->lock);
+			}
+			if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
+				spin_unlock(&pcp->lock);
+				pcp = NULL;
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
 				continue;
 			}
 			locked_zone = zone;
+			locked_cpu = cache_cpu;
 		}
 
 		/*
@@ -3012,14 +3410,16 @@ void free_unref_folios(struct folio_batch *folios)
 
 		trace_mm_page_free_batched(&folio->page);
 		if (!free_frozen_page_commit(zone, pcp, &folio->page,
-				migratetype, order, FPI_NONE)) {
+				migratetype, order, FPI_NONE,
+				cache_cpu == owner_cpu)) {
 			pcp = NULL;
 			locked_zone = NULL;
+			locked_cpu = -1;
 		}
 	}
 
 	if (pcp)
-		pcp_spin_unlock(pcp);
+		spin_unlock(&pcp->lock);
 	folio_batch_reinit(folios);
 }
 
@@ -3249,15 +3649,15 @@ static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 			int migratetype,
 			unsigned int alloc_flags,
-			struct per_cpu_pages *pcp,
-			struct list_head *list)
+			struct per_cpu_pages *pcp)
 {
 	struct page *page;
 
 	do {
-		if (list_empty(list)) {
+		/* Try to find/split from existing PCP stock */
+		page = pcp_rmqueue_smallest(pcp, migratetype, order);
+		if (!page) {
 			int batch = nr_pcp_alloc(pcp, zone, order);
-			int alloced;
 
 			/*
 			 * Don't refill the list for a higher order atomic
@@ -3273,18 +3673,14 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 			if (alloc_flags & ALLOC_HIGHATOMIC)
 				return NULL;
 
-			alloced = rmqueue_bulk(zone, order,
-					batch, list,
-					migratetype, alloc_flags);
+			if (!rmqueue_bulk(zone, order, batch, migratetype,
+					  alloc_flags, pcp))
+				return NULL;
 
-			pcp->count += alloced << order;
-			if (unlikely(list_empty(list)))
+			page = pcp_rmqueue_smallest(pcp, migratetype, order);
+			if (unlikely(!page))
 				return NULL;
 		}
-
-		page = list_first_entry(list, struct page, pcp_list);
-		list_del(&page->pcp_list);
-		pcp->count -= 1 << order;
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3296,7 +3692,6 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			int migratetype, unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
-	struct list_head *list;
 	struct page *page;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
@@ -3310,8 +3705,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp);
 	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -4989,7 +5383,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
-	struct list_head *pcp_list;
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
@@ -5084,7 +5477,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */
@@ -5093,8 +5485,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags, pcp);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5969,6 +6360,7 @@ static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonesta
 	spin_lock_init(&pcp->lock);
 	for (pindex = 0; pindex < NR_PCP_LISTS; pindex++)
 		INIT_LIST_HEAD(&pcp->lists[pindex]);
+	INIT_LIST_HEAD(&pcp->owned_blocks);
 
 	/*
 	 * Set batch and high values safe for a boot pageset. A true percpu
@@ -6167,7 +6559,45 @@ static int page_alloc_cpu_dead(unsigned int cpu)
 
 	lru_add_drain_cpu(cpu);
 	mlock_drain_remote(cpu);
-	drain_pages(cpu);
+
+	/*
+	 * Mark the dead CPU's PCPs so concurrent frees don't
+	 * enqueue pages on them after the drain. Set the flag
+	 * under pcp->lock to serialize with trylock in the free
+	 * path. Stale ownership entries in pageblock_data are
+	 * harmless: frees check PCPF_CPU_DEAD and fall back to zone,
+	 * and rmqueue_bulk will reclaim the blocks for live CPUs.
+	 */
+	for_each_populated_zone(zone) {
+		unsigned long zflags;
+		struct per_cpu_pages *pcp;
+
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+
+		pcp_spin_lock_nopin(pcp);
+		pcp->flags |= PCPF_CPU_DEAD;
+		pcp_spin_unlock_nopin(pcp);
+
+		drain_pages_zone(cpu, zone);
+
+		/*
+		 * Drain released all pages. Reinitialize the
+		 * owned-blocks list -- any remaining entries are
+		 * stale (fragments that merged in zone buddy and
+		 * cleared ownership, but weren't removed from
+		 * the list because __free_one_page doesn't hold
+		 * pcp->lock).
+		 *
+		 * Hold zone lock to prevent racing with other
+		 * CPUs doing list_del_init on stale entries
+		 * from this list during their Phase 1.
+		 */
+		pcp_spin_lock_nopin(pcp);
+		spin_lock_irqsave(&zone->lock, zflags);
+		INIT_LIST_HEAD(&pcp->owned_blocks);
+		spin_unlock_irqrestore(&zone->lock, zflags);
+		pcp_spin_unlock_nopin(pcp);
+	}
 
 	/*
 	 * Spill the event counters of the dead processor
@@ -6196,8 +6626,16 @@ static int page_alloc_cpu_online(unsigned int cpu)
 {
 	struct zone *zone;
 
-	for_each_populated_zone(zone)
+	for_each_populated_zone(zone) {
+		struct per_cpu_pages *pcp;
+
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+		pcp_spin_lock_nopin(pcp);
+		pcp->flags &= ~PCPF_CPU_DEAD;
+		pcp_spin_unlock_nopin(pcp);
+
 		zone_pcp_update(zone, 1);
+	}
 	return 0;
 }
 
-- 
2.54.0


