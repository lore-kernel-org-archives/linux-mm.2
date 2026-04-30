Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C39FCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7FD76B00B0; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58CC6B00B1; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DE36B00B3; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86ED56B00AF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DB421401F1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
X-FDA: 84716346498.19.FF53336
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id DEA61180002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=h6l4cB1B;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tlOv0nNsq54GUdi748Zc/6a+4iI5BH58CvAkY8PjmE=;
	b=R1fXn8jhzYVd7LDXNU9yBqBin0ZS8KY5WF0+K+nT4KyaKGRqAyDCXy3UucmNwuQcWGB0Gu
	yx5lvDu+GdlLFEMW7JHIvL4gAJ9+bk+dWgjIA6D0tzNx8KU3UY3kMXQwlTGia7B7L0+Tx5
	KG3oRzrs/biwMuGN+VnpgmXcBDDTivQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=h6l4cB1B;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580587; a=rsa-sha256;
	cv=none;
	b=HDwOXhPLMKFgzAh+IlJQ92BYJwIRgRCpNF10k3aMFATl4rjnmTZUx8WaUm2RVkZzpBLV8h
	dBjci6DinEfRJquTbv91GUXnzw+pOoyyxruNr0oZLyP3LIa6yrYuPuW2qPR1+UWeBMJp7M
	H6YdSRdYrPH5dQXXQCSsn8mHKUXnv/k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7tlOv0nNsq54GUdi748Zc/6a+4iI5BH58CvAkY8PjmE=; b=h6l4cB1Bv3SN2U1TDtr0iQBKHK
	XMa3HpU/1rYP4ibAQUXUcIWifnxcl0MtCpwK9HkzkB3EaYZPWVcfi3KHQZQmxjfp/825unW4dYCIs
	XDu6j5MoqSkIXsJlfktwbf1jd5Ls1gphyFfGSJwozqI1c+PKT49GW4UKPFuui/PdfgF15H0L88PDe
	GYDySP6QpjSNSFga77JVBy0GF2+TrYrskAClZc3hrTb2oizcsmWdvbgZSrvIjOJ7+Y3J0SOLzGOju
	oldQTYhFGsiySxL5iSlnzREKZzrbbnlsNXriWCQdYnIwNCETXJ/ZGWOrubB2Lmx6OtdJpxK9z64A7
	BlYXVdig==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-1xE3;
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
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 02/45] mm: page_alloc: per-cpu pageblock buddy allocator
Date: Thu, 30 Apr 2026 16:20:31 -0400
Message-ID: <20260430202233.111010-3-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DEA61180002
X-Stat-Signature: 3tsm4z6ocby64w3bwfkgmztfexon95z6
X-HE-Tag: 1777580586-335364
X-HE-Meta: U2FsdGVkX1/ZqfgtFxztNEVkl8ivza2Dz6PA6AXawBtvRrYIXCxhbuiDU08b1B+fcOuYX+i96XrF74WP0MtEY2zECAgrBhIPQ7GRK716qSj37HlKh/Qe9MwpoltnIgt3qOjTwCY5161k1JhM9issmq5X6EDX5Infu8vjx0BXY06pDaazF/JqLa9dhyhoePB6QLA5yZesu9KAHpJJbGl8BpOvudkYtZ4Emo2hyHbRo11WYbZ7TQo/y8nxIHSLYlJz5+FixbyjbfO5TMAkV2k4RNJJeXwXIxiX2f1jepYVfPYk+MaBRmd5yngMlY6Dn6SGU0fE2rpcSmHoF9pxSqX/6iWNhgh7RnqeRJHUD7d3D1F/rAXtJAXIkGK3GsTUuMggF74/Z4M5sPFF92X06yo9hQp+k5CX/XGH9VGpLr/HK/KeYCYMJHLMaDDIuyl3NSywI2gozZipy/fGHjdkIImiIP9jhWHaw8CLsgvf2YIdgBsalLHFRcv2iw6gf+zXBHx0lj2V7n0WNbxyibvQTHn+DI292qQ1jMpakJm+BbU72ErWzgJZPpCSJuzEJrwxlybnWGk2LyG4xEOtyLyXCT2/V+M+2IV9B3MXrPBnKwKvEXW27z/483Z4BPTfyM/MnUje9WYJAh2+XppkxG0GGlVPyZ5IuAfwqZx5eYE+nCxU0SOjELmb93nLlkix3uQXLwsGFu3/YwpUESL8EHH8n37KVRZX3V0dTNX9orrpy11MBJBpf+MY+MroaXVDWinZCnykzaa5rJIEUBz3zhDMkSKG+uj7BxyyFva7FnvWVO3SfpuLkEmKfIw/YSMN/dBonpJ0XBWlWYylyjn9qwfH441xY+/yyyCnL1JPVzjked/l1Uxe2dWimsz2Hg0W+pQLsWU7rECA5NTyyLAdUJWIX2FXulsDZIwGJ719wyHoVHNRz1CCwRE+JAotUJzms2ghRKMER0xVK9Y/c/8loxVI0eV
 1D85kFhn
 T7oR4/PDmGuxKllA+DsOSNwOsNtKTgUJ2tQA5Ga5tXWV4FU01PAvuwdc03JDIQZ3pAcQMhnfLnU5BLk1kD9NPQDvXluFQUsByhfp36QmSo8/stj0tPmULp0T6bAKSQw4kaZMvXL9Cu0UDUnatB9xJvUMyORkTQfRjeo05f+0x/XqOpemzMMwdALvHkom5cX17KTeMzHkOsuyXcwm6Lc6yUUuY5jgVIi2Kxev4MjvVcRmLQsOND/4jpubNQkY+lKiig0qdPT6pPBp6oeifeVgE1OR/YqyAlLqHQLG+zyBeL7+vLQfKA99fQDQPJvHPIfrNtsB2Iefm/DcEyIbOYGK/5uCWjcc7bhJnZ5G9kXdkJtDb7ePH4EstNAeQ6PsYMJsYiuJR
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

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h     |  23 +-
 include/linux/page-flags.h |   9 +
 mm/debug.c                 |   1 +
 mm/page_alloc.c            | 705 +++++++++++++++++++++++++++++--------
 4 files changed, 575 insertions(+), 163 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2f202bda5ec6..a59260487ab4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -714,17 +714,10 @@ enum zone_watermarks {
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
@@ -737,9 +730,13 @@ enum zone_watermarks {
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
@@ -755,6 +752,9 @@ struct per_cpu_pages {
 #endif
 	short free_count;	/* consecutive free count */
 
+	/* Pageblocks owned by this CPU, for fragment recovery */
+	struct list_head owned_blocks;
+
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[NR_PCP_LISTS];
 } ____cacheline_aligned_in_smp;
@@ -1900,6 +1900,9 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
 
 struct pageblock_data {
 	unsigned long flags;
+	int cpu;			/* PCP ownership: owning cpu + 1, or 0 for zone-owned */
+	unsigned long block_pfn;	/* first PFN of pageblock */
+	struct list_head cpu_node;	/* per-CPU owned-blocks list */
 };
 
 struct mem_section_usage {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..6798f78ef677 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -934,6 +934,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_pcp_buddy		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1002,6 +1003,14 @@ static __always_inline void __ClearPage##uname(struct page *page)	\
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
index 45519be08c9b..c0aa39fa2f61 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -414,6 +414,22 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
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
@@ -427,16 +443,7 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
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
@@ -520,6 +527,8 @@ void __meminit init_pageblock_migratetype(struct page *page,
 					  enum migratetype migratetype,
 					  bool isolate)
 {
+	unsigned long pfn = page_to_pfn(page);
+	struct pageblock_data *pbd;
 	unsigned long flags;
 
 	if (unlikely(page_group_by_mobility_disabled &&
@@ -538,8 +547,11 @@ void __meminit init_pageblock_migratetype(struct page *page,
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
@@ -625,19 +637,7 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
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
@@ -646,25 +646,14 @@ static inline int pindex_to_order(unsigned int pindex)
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
-	if (order == HPAGE_PMD_ORDER)
-		return true;
-#endif
-	return false;
+	return order <= pageblock_order;
 }
 
 /*
@@ -697,6 +686,91 @@ static inline void set_buddy_order(struct page *page, unsigned int order)
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
@@ -937,6 +1011,21 @@ static inline void __free_one_page(struct page *page,
 
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
 
@@ -986,6 +1075,10 @@ static inline void __free_one_page(struct page *page,
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		/* Clear owner also when we merge up. See above */
+		if (order == pageblock_order)
+			clear_pcpblock_owner(page);
 	}
 
 done_merging:
@@ -1421,17 +1514,24 @@ bool free_pages_prepare(struct page *page, unsigned int order)
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
@@ -1439,8 +1539,45 @@ static void free_pcppages_bulk(struct zone *zone, int count,
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
 
@@ -1458,19 +1595,31 @@ static void free_pcppages_bulk(struct zone *zone, int count,
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
@@ -1478,6 +1627,45 @@ static void free_pcppages_bulk(struct zone *zone, int count,
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
@@ -1487,6 +1675,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
 	VM_WARN_ON_ONCE(PageBuddy(page));
+	VM_WARN_ON_ONCE(PagePCPBuddy(page));
 
 	if (order > pageblock_order)
 		order = pageblock_order;
@@ -2482,28 +2671,162 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
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
@@ -2516,11 +2839,13 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
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
@@ -2551,7 +2876,7 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
 		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
-		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp);
 		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 		todo = true;
 
@@ -2576,7 +2901,7 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
 		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain, pcp);
 		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	}
 }
@@ -2598,7 +2923,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 			int to_drain = min(count,
 				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
 
-			free_pcppages_bulk(zone, to_drain, pcp, 0);
+			free_pcppages_bulk(zone, to_drain, pcp);
 			count -= to_drain;
 		}
 		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
@@ -2792,21 +3117,15 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
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
-static bool free_frozen_page_commit(struct zone *zone,
+static void free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
+		unsigned int order, fpi_t fpi_flags, bool owned)
 {
-	int high, batch;
-	int to_free, to_free_batched;
-	int pindex;
-	int cpu = smp_processor_id();
-	int ret = true;
+	int high, batch, to_free;
 	bool free_high = false;
 
 	/*
@@ -2816,9 +3135,15 @@ static bool free_frozen_page_commit(struct zone *zone,
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
@@ -2844,41 +3169,15 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
 		 */
-		return true;
+		return;
 	}
 
 	high = nr_pcp_high(pcp, zone, batch, free_high);
 	if (pcp->count < high)
-		return true;
+		return;
 
 	to_free = nr_pcp_free(pcp, batch, high, free_high);
-	while (to_free > 0 && pcp->count > 0) {
-		to_free_batched = min(to_free, batch);
-		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
-		to_free -= to_free_batched;
-
-		if (to_free == 0 || pcp->count == 0)
-			break;
-
-		pcp_spin_unlock(pcp, *UP_flags);
-
-		pcp = pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags);
-		if (!pcp) {
-			ret = false;
-			break;
-		}
-
-		/*
-		 * Check if this thread has been migrated to a different CPU.
-		 * If that is the case, give up and indicate that the pcp is
-		 * returned in an unlocked state.
-		 */
-		if (smp_processor_id() != cpu) {
-			pcp_spin_unlock(pcp, *UP_flags);
-			ret = false;
-			break;
-		}
-	}
+	free_pcppages_bulk(zone, to_free, pcp);
 
 	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
@@ -2897,7 +3196,6 @@ static bool free_frozen_page_commit(struct zone *zone,
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
-	return ret;
 }
 
 /*
@@ -2908,9 +3206,11 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 {
 	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
+	struct pageblock_data *pbd;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
+	int owner_cpu, cache_cpu;
 
 	if (!pcp_allowed_order(order)) {
 		__free_pages_ok(page, order, fpi_flags);
@@ -2928,7 +3228,8 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	 * excessively into the page allocator
 	 */
 	zone = page_zone(page);
-	migratetype = get_pfnblock_migratetype(page, pfn);
+	pbd = pfn_to_pageblock(page, pfn);
+	migratetype = pbd_migratetype(pbd);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(zone, page, pfn, order, fpi_flags);
@@ -2942,15 +3243,45 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
-	if (pcp) {
-		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
-						order, fpi_flags, &UP_flags))
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
+		if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
+			free_one_page(zone, page, pfn, order, fpi_flags);
 			return;
-		pcp_spin_unlock(pcp, UP_flags);
+		}
 	} else {
+		spin_lock_irqsave(&pcp->lock, UP_flags);
+	}
+
+	if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
+		spin_unlock_irqrestore(&pcp->lock, UP_flags);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+		return;
 	}
+
+	free_frozen_page_commit(zone, pcp, page,
+				migratetype, order, fpi_flags,
+				cache_cpu == owner_cpu);
+
+	spin_unlock_irqrestore(&pcp->lock, UP_flags);
 }
 
 void free_frozen_pages(struct page *page, unsigned int order)
@@ -2971,6 +3302,7 @@ void free_unref_folios(struct folio_batch *folios)
 	unsigned long UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
+	int locked_cpu = -1;
 	int i, j;
 
 	/* Prepare folios for freeing */
@@ -3002,17 +3334,29 @@ void free_unref_folios(struct folio_batch *folios)
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
-				pcp_spin_unlock(pcp, UP_flags);
+				spin_unlock_irqrestore(&pcp->lock, UP_flags);
 				locked_zone = NULL;
+				locked_cpu = -1;
 				pcp = NULL;
 			}
 
@@ -3026,17 +3370,35 @@ void free_unref_folios(struct folio_batch *folios)
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
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
-			if (unlikely(!pcp)) {
+			if (!in_task()) {
+				if (unlikely(!spin_trylock_irqsave(
+						&pcp->lock, UP_flags))) {
+					pcp = NULL;
+					free_one_page(zone, &folio->page, pfn,
+						      order, FPI_NONE);
+					continue;
+				}
+			} else {
+				spin_lock_irqsave(&pcp->lock, UP_flags);
+			}
+			if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
+				spin_unlock_irqrestore(&pcp->lock, UP_flags);
+				pcp = NULL;
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
 				continue;
 			}
 			locked_zone = zone;
+			locked_cpu = cache_cpu;
 		}
 
 		/*
@@ -3047,15 +3409,13 @@ void free_unref_folios(struct folio_batch *folios)
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		if (!free_frozen_page_commit(zone, pcp, &folio->page,
-				migratetype, order, FPI_NONE, &UP_flags)) {
-			pcp = NULL;
-			locked_zone = NULL;
-		}
+		free_frozen_page_commit(zone, pcp, &folio->page,
+				migratetype, order, FPI_NONE,
+				cache_cpu == owner_cpu);
 	}
 
 	if (pcp)
-		pcp_spin_unlock(pcp, UP_flags);
+		spin_unlock_irqrestore(&pcp->lock, UP_flags);
 	folio_batch_reinit(folios);
 }
 
@@ -3278,28 +3638,24 @@ static inline
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
@@ -3311,7 +3667,6 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			int migratetype, unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
-	struct list_head *list;
 	struct page *page;
 	unsigned long UP_flags;
 
@@ -3326,8 +3681,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -5013,7 +5367,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
-	struct list_head *pcp_list;
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
@@ -5108,7 +5461,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */
@@ -5117,8 +5469,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags, pcp);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5993,6 +6344,7 @@ static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonesta
 	spin_lock_init(&pcp->lock);
 	for (pindex = 0; pindex < NR_PCP_LISTS; pindex++)
 		INIT_LIST_HEAD(&pcp->lists[pindex]);
+	INIT_LIST_HEAD(&pcp->owned_blocks);
 
 	/*
 	 * Set batch and high values safe for a boot pageset. A true percpu
@@ -6228,7 +6580,45 @@ static int page_alloc_cpu_dead(unsigned int cpu)
 
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
+		unsigned long flags, zflags;
+		struct per_cpu_pages *pcp;
+
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+
+		pcp_spin_lock_maybe_irqsave(pcp, flags);
+		pcp->flags |= PCPF_CPU_DEAD;
+		pcp_spin_unlock_maybe_irqrestore(pcp, flags);
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
+		pcp_spin_lock_maybe_irqsave(pcp, flags);
+		spin_lock_irqsave(&zone->lock, zflags);
+		INIT_LIST_HEAD(&pcp->owned_blocks);
+		spin_unlock_irqrestore(&zone->lock, zflags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, flags);
+	}
 
 	/*
 	 * Spill the event counters of the dead processor
@@ -6257,8 +6647,17 @@ static int page_alloc_cpu_online(unsigned int cpu)
 {
 	struct zone *zone;
 
-	for_each_populated_zone(zone)
+	for_each_populated_zone(zone) {
+		struct per_cpu_pages *pcp;
+		unsigned long flags;
+
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+		pcp_spin_lock_maybe_irqsave(pcp, flags);
+		pcp->flags &= ~PCPF_CPU_DEAD;
+		pcp_spin_unlock_maybe_irqrestore(pcp, flags);
+
 		zone_pcp_update(zone, 1);
+	}
 	return 0;
 }
 
-- 
2.52.0


