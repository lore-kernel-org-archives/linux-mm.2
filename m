Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C80CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E7A6B00C7; Wed, 20 May 2026 11:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122726B00C8; Wed, 20 May 2026 11:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04FE6B00C9; Wed, 20 May 2026 11:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D70336B00C7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 980C51A0364
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:15 +0000 (UTC)
X-FDA: 84788111310.04.F534441
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id C900080025
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=I34VUAdR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RO0fqhIiurFpA3oc5oMi5WLVFRVYBJxY3P6Jo+KfnbU=;
	b=NFUGgfk7AnwUOATZ2VCkuaC6jg4T3geVIwCqnD7NCy5fvNBZYxTqWuA2oi5uhv6Piag14B
	VDTTRcP1QRddUccaMfoRzyY49IEU5Ty+FRLFFlhjf89oozT3qRYRokMqOVON+e/XbjJZ8O
	vzhfCR/YjvGeuCUJS90iez3QAyXQnWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289273; a=rsa-sha256;
	cv=none;
	b=DZZWFRd+74PQI2EP8OqjmoTO6gYNQjg7nrtKzMPaxSVpQ/8ZljAqY7pnYLnDfjKX40Z2aZ
	cyuOYN5i7BiXakZUliQIRVOAgwwNmhQ0MIrXee9TAxtejLsPvQj68oSpnN9LFfyYAZRk8J
	HRFd8KFmFgLs3n8Mn2yLhf4yQKjSUoM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=I34VUAdR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RO0fqhIiurFpA3oc5oMi5WLVFRVYBJxY3P6Jo+KfnbU=; b=I34VUAdR1fM0HfWYXNiLy5zOT4
	dghLCG68qzPKa8W1nLPURpxd/GN8aPN4neypltU/BXe6gSEJg9aoz8EPwtQNU3yC90dVbJXz0hnkg
	FawS4yZZDIH+Q/NApgZa8joLu4A2DG0yn5hV0ii3O2hHAMi1YLihEv71qezcBLZhrprLfbXFJSoF/
	P9QqPrV097bmwPbxU7wclsVzSK9GYS6X5b+Ms5Xtff0djQ1cifxXU0hS3nwGVlQPUL0bt1oekbBlm
	Nicbn9LtJ+1nzfAp5B7sQanJWc8ctGXtT4Tr5+HDV0mgEM3+6/ozHicHJ4rnhf82lgi5xETPB6Tqy
	qnNKocVA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1ouG;
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
Subject: [RFC PATCH 15/40] mm: page_alloc: add background superpageblock defragmentation worker
Date: Wed, 20 May 2026 10:59:21 -0400
Message-ID: <20260520150018.2491267-16-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C900080025
X-Stat-Signature: 6ka7gfdiqko4j66445n5tdnbqhbjjgnp
X-Rspam-User: 
X-HE-Tag: 1779289273-170380
X-HE-Meta: U2FsdGVkX183lYbh49+HqOM2hteJkIja4ySrB5f3cP2MrwsjV+AU+TldS04Me8oXxWR92kpg31CqWH6cG0DPGVaQGC774fkWObrbg9MmL4RYMfTAOa1ujAjxzBaLrtiz0DFRlJ4rpC5YJspdB4bY3DW8bS55OcvkGbJvIeW+0KqwCIqtvMtHtn8rrwpVTk9yexjbIuAUw5zaIHdbKaGBNpR8lk7sJI5zVT6CsMRCFK707MhZTxGZ3/xIKp9zrVQtTx2L1/pukYPFzEFUjgxZ7UlDLUj1yXiA2vGV6eyKQy2cMbu6ozwP6S+7oP8CaM+fg1geprztoqML44my+GvEfkQZqx3CJC8iykQ5QOazpuG+DdmGVZuTZXkePqOgO0xANhQpdMBjJJ126og/TyW/Mu+mXSAy8ryia8y6TvihqWC2EcNwuIKieT/ZYGYvhx4ovHvpjCTTSm29gIOookOiXc03ZbhpoDJKWiQLSI8VC3Ym5zeSk51E+tTMdLZJGgdVE9N+8DQpl01Pwrag9Qs4ihk0EzK1njuTwRQNWcjV/xqSM9xSvVfHe8AizBSF4+MX52Ewx4nFcH/KCj4zJ0J3RPSqeF6ix0ptQERKSBr391+TwUsyjsm7acD8LqLgYCILzuOAIhVBue+9v/rOdO08tDkjdvchQ6rFyDlSZennhhx9mSuJKECYTS88M308VZG33boA5FfpzSUTBU65F3UyNvV73Zocgp7FNxaFP9ZAF7u3dNIlXDUnSl618RqYHmqj+k8rPacAoSoEelB54IpG6m6LmxXKNfa5W3ZzPnHZ1kZ/gKflHhKGm6Bz2ttjXqpkR3/S2LwvPWm+xhRSo+kJH3YG29rXGaVqlpMdczzJQ/oPH0S5gvbVdWnCJRk2bzsi214nFcq23brIcX2ed8vAtGehX0w3uR13Lue5yddgb4mHeA3uSoREU3w0cuQyF4TF21xxc3FEky6HttnixR9
 v9lopctj
 K88qsojILRANe5Iu6Mv2+ugORolzRSW6Saqd5oPQPL9wYr/o2XvbvvxXDA4a/W+mlcefBkvf+ujz6S3K5x2tkoF/8hMxlzotfB72hWNMMgzS4NHso7Gb/LBnf2teHwKVr959Rdi/0euGd9osin7w7K0rp4X07ZkH3TFuZcoHPRnzXw2Zirn9zgy8ktvfCVQnzlhloc2JLniUje+7y/ev77Dn04H/okwy6P6KfPy0oJC6wclDf+gdhIpNaYfPpwIkqkblU4HbLmkz2mEaS6AtZmo4/zSzIiZPla9U1CydkjX7io64VZxLLTjrxEqDZjeiUMu5gYnuA7YFhSD+UYgILjIWCWS5z4hb2WhPyYZXCBX0eu+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an event-driven background worker that evacuates movable pages
from tainted superpageblocks when free space runs low.  Each super-
pageblock has its own work_struct, so defrag targets the specific
superpageblock that needs it rather than scanning the entire system.

Defrag is triggered from sb_update_list() when a tainted super-
pageblock drops below threshold: 1 or fewer free pageblocks, or less
than 2 pageblocks worth of free pages.  The worker evacuates movable
pageblocks until free space recovers: at least 2 free pageblocks or
3 pageblocks worth of free pages, or no movable pages remain.  Clean
superpageblocks (only free + movable) are never defragged; super-
pageblocks with no movable pages are skipped.

The worker calls evacuate_pageblock() directly from within its own
work_struct, so the older per-pageblock evacuate plumbing
(queue_pageblock_evacuate, evacuate_item, evacuate_pool,
evacuate_freelist, evacuate_item_alloc/free, evacuate_work_fn,
evacuate_irq_work_fn, pgdat->evacuate_pending,
pgdat->evacuate_irq_work, and their per-pgdat init in
pageblock_evacuate_init()) is no longer used and is dropped, along
with its sole remaining call site in try_to_claim_block().

Memory-hotplug correctness: this commit introduces the per-SPB
defrag_work / defrag_irq_work fields.  The resize loop in
resize_zone_superpageblocks() already runs init_zone_spb_lists() on
the first-time path and rewires per-SPB list heads after the kvmalloc
copy (from the previous commit), but the defrag work_structs need
their own init both for *copied* SPBs (the memcpy leaves them with
function pointers that reference the old array's per-SPB storage)
and for *newly allocated* SPBs (boot-time init via the
pageblock_evacuate_init late_initcall only walks SPBs that exist at
boot, so hot-added SPBs would otherwise have zero-initialized
defrag_work and crash on first defrag attempt).  Call
init_superpageblock_defrag(sb) right after init_one_superpageblock(sb)
in the new-SPB loop, and add it to the copied-SPB fixup loop as well.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  19 ++-
 mm/internal.h          |   2 +
 mm/mm_init.c           |  11 ++
 mm/page_alloc.c        | 325 +++++++++++++++++++++++++++++------------
 4 files changed, 259 insertions(+), 98 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 85846bb041a8..6cba69603918 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1034,6 +1034,23 @@ struct superpageblock {
 	 */
 	struct free_area	free_area[NR_PAGE_ORDERS];
 
+#ifdef CONFIG_COMPACTION
+	/* Background defragmentation work for this superpageblock */
+	struct work_struct	defrag_work;
+	struct irq_work		defrag_irq_work;
+	bool			defrag_active;
+	/*
+	 * Back-off state after a no-op defrag pass: defer the next attempt
+	 * until either nr_free_pages has grown by at least pageblock_nr_pages
+	 * or a cooldown elapses, so allocator hot paths cannot re-arm
+	 * defrag_work many times per second on an SB that cannot make progress.
+	 * defrag_last_no_progress_jiffies == 0 means the previous pass made
+	 * progress (or no pass has run yet).
+	 */
+	unsigned long		defrag_last_no_progress_jiffies;
+	unsigned long		defrag_last_no_progress_pages;
+#endif
+
 	/* Identity */
 	unsigned long		start_pfn;
 	struct zone		*zone;
@@ -1632,8 +1649,6 @@ typedef struct pglist_data {
 	struct task_struct *kcompactd;
 	bool proactive_compact_trigger;
 	struct workqueue_struct *evacuate_wq;
-	struct llist_head evacuate_pending;
-	struct irq_work evacuate_irq_work;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/mm/internal.h b/mm/internal.h
index 7091dc557f1f..c0dbc2e4b7f0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1102,9 +1102,11 @@ void init_cma_reserved_pageblock(struct page *page);
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
 #ifdef CONFIG_COMPACTION
+void init_superpageblock_defrag(struct superpageblock *sb);
 void superpageblock_clear_has_movable(struct zone *zone, struct page *page);
 void superpageblock_set_has_movable(struct zone *zone, struct page *page);
 #else
+static inline void init_superpageblock_defrag(struct superpageblock *sb) {}
 static inline void superpageblock_clear_has_movable(struct zone *zone,
 						    struct page *page) {}
 static inline void superpageblock_set_has_movable(struct zone *zone,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 92e5f396cbd7..ee5dcd89e31e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1726,6 +1726,14 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 		init_one_superpageblock(sb, zone,
 					new_sb_base + (i << SUPERPAGEBLOCK_ORDER),
 					zone_start, zone_end);
+		/*
+		 * Boot-time defrag work init in pageblock_evacuate_init()
+		 * is a late_initcall and only walks SPBs that exist at
+		 * that point. Newly hot-added SPBs need their work structs
+		 * initialized here, mirroring the reinit loop above for
+		 * copied SPBs.
+		 */
+		init_superpageblock_defrag(sb);
 	}
 
 	/*
@@ -1779,6 +1787,9 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 						list_replace(old_list, new_list);
 				}
 			}
+
+			/* Reinitialize defrag work structs (contain stale pointers) */
+			init_superpageblock_defrag(sb);
 		}
 	}
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b9c957fb4783..530ddc73e90a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -63,10 +63,6 @@
 #include "shuffle.h"
 #include "page_reporting.h"
 
-#ifdef CONFIG_COMPACTION
-static void queue_pageblock_evacuate(struct zone *zone, unsigned long pfn);
-#endif
-
 /* Free Page Internal flags: for internal, non-pcp variants of free_pages(). */
 typedef int __bitwise fpi_t;
 
@@ -709,8 +705,15 @@ static inline enum sb_fullness sb_get_fullness(struct superpageblock *sb,
  *
  * Called after counters change. Removes from current list (if any)
  * and adds to the appropriate list based on current fullness and
- * taint status.
+ * taint status. Also triggers background defragmentation if the
+ * superpageblock is tainted and running low on free space.
  */
+#ifdef CONFIG_COMPACTION
+static void spb_maybe_start_defrag(struct superpageblock *sb);
+#else
+static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
+#endif
+
 static void spb_update_list(struct superpageblock *sb)
 {
 	struct zone *zone = sb->zone;
@@ -727,6 +730,8 @@ static void spb_update_list(struct superpageblock *sb)
 	cat = spb_get_category(sb);
 	full = sb_get_fullness(sb, cat);
 	list_add_tail(&sb->list, &zone->spb_lists[cat][full]);
+
+	spb_maybe_start_defrag(sb);
 }
 
 /**
@@ -3311,11 +3316,6 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		if (sb)
 			spb_update_list(sb);
 
-		if ((start_type == MIGRATE_UNMOVABLE ||
-		     start_type == MIGRATE_RECLAIMABLE) &&
-		    get_pfnblock_bit(start_page, start_pfn,
-				     PB_has_movable))
-			queue_pageblock_evacuate(zone, start_pfn);
 #endif
 		return __rmqueue_smallest(zone, order, start_type);
 	}
@@ -8188,42 +8188,14 @@ void __init page_alloc_sysctl_init(void)
 
 #ifdef CONFIG_COMPACTION
 /*
- * Pageblock evacuation: asynchronously migrate movable pages out of
- * pageblocks that were stolen for unmovable/reclaimable allocations.
- * This keeps unmovable/reclaimable allocations concentrated in fewer
- * pageblocks, reducing long-term fragmentation.
- *
- * Uses a global pool of 64 pre-allocated work items (~3.5KB total)
- * and a per-pgdat workqueue to keep migration node-local.
+ * Pageblock evacuation: synchronously migrate movable pages out of a
+ * pageblock to consolidate fragmentation. Driven by the background
+ * superpageblock defragmentation worker (see below); has no per-pageblock
+ * scheduling infrastructure of its own.
  */
 
-struct evacuate_item {
-	struct work_struct	work;
-	struct zone		*zone;
-	unsigned long		start_pfn;
-	struct llist_node	free_node;
-};
-
-#define NR_EVACUATE_ITEMS	64
-static struct evacuate_item evacuate_pool[NR_EVACUATE_ITEMS];
-static struct llist_head evacuate_freelist;
-
-static struct evacuate_item *evacuate_item_alloc(void)
-{
-	struct llist_node *node;
-
-	node = llist_del_first(&evacuate_freelist);
-	if (!node)
-		return NULL;
-	return container_of(node, struct evacuate_item, free_node);
-}
-
-static void evacuate_item_free(struct evacuate_item *item)
-{
-	llist_add(&item->free_node, &evacuate_freelist);
-}
-
-static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
+static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn,
+			       bool force)
 {
 	unsigned long end_pfn = start_pfn + pageblock_nr_pages;
 	unsigned long pfn = start_pfn;
@@ -8241,8 +8213,14 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
 	};
 
-	/* Verify this pageblock is still worth evacuating */
-	if (get_pageblock_migratetype(pfn_to_page(start_pfn)) == MIGRATE_MOVABLE)
+	/*
+	 * Verify this pageblock is still worth evacuating.
+	 * Skip if it reverted to MOVABLE (steal was undone) -- unless
+	 * force is set (background defrag wants to clear movable pages
+	 * out of tainted superpageblocks regardless of pageblock type).
+	 */
+	if (!force &&
+	    get_pageblock_migratetype(pfn_to_page(start_pfn)) == MIGRATE_MOVABLE)
 		return;
 
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -8297,86 +8275,215 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
 		putback_movable_pages(&cc.migratepages);
 }
 
-static void evacuate_work_fn(struct work_struct *work)
+/*
+ * Background superpageblock defragmentation.
+ *
+ * Evacuate movable pageblocks from tainted superpageblocks to consolidate
+ * contamination. Triggered on-demand when a tainted superpageblock runs
+ * low on free space, rather than running on a fixed timer.
+ *
+ * Goals for tainted superpageblocks:
+ * - At least 2 free pageblocks if movable pageblocks still exist
+ * - Or 3 pageblocks worth of free pages while movable pages remain
+ * - Skip superpageblocks with no movable pages (nothing to evacuate)
+ */
+
+/* Target free space: 3 pageblocks worth of free pages */
+#define SPB_DEFRAG_FREE_PAGES_TARGET	(3UL * pageblock_nr_pages)
+
+/**
+ * spb_needs_defrag - Check if a superpageblock needs defragmentation
+ * @sb: superpageblock to check (may be NULL)
+ *
+ * Returns false for NULL, non-tainted, or clean superpageblocks.
+ * A tainted superpageblock needs defrag if it has movable pages that can
+ * be evacuated AND free space is running low (1 or fewer free
+ * pageblocks, or less than 2 pageblocks worth of free pages).
+ */
+/*
+ * Cooldown between defrag attempts that made no progress, in seconds.
+ * Long enough to keep the allocator hot path quiet on saturated SBs;
+ * short enough that a freshly-freed pageblock isn't ignored for long.
+ */
+#define SPB_DEFRAG_NOOP_COOLDOWN_SECS	5
+
+static bool spb_needs_defrag(struct superpageblock *sb)
 {
-	struct evacuate_item *item = container_of(work, struct evacuate_item,
-						  work);
-	evacuate_pageblock(item->zone, item->start_pfn);
-	evacuate_item_free(item);
+	if (!sb)
+		return false;
+
+	if (spb_get_category(sb) != SB_TAINTED)
+		return false;
+
+	/*
+	 * Back off if the previous pass made no progress: do not retry until
+	 * either the cooldown elapses or free pages have grown by at least a
+	 * pageblock's worth (a hint that there might be new material to
+	 * consolidate or evacuate).
+	 */
+	if (sb->defrag_last_no_progress_jiffies &&
+	    time_before(jiffies, sb->defrag_last_no_progress_jiffies +
+				 SPB_DEFRAG_NOOP_COOLDOWN_SECS * HZ) &&
+	    sb->nr_free_pages < sb->defrag_last_no_progress_pages +
+				pageblock_nr_pages)
+		return false;
+
+	/*
+	 * Tainted superpageblocks: evacuate movable pages to concentrate
+	 * unmovable/reclaimable allocations.  Migration targets are
+	 * allocated system-wide, so no internal free space is needed.
+	 * Maintain the tainted reserve so unmovable claims always
+	 * find room in existing tainted superpageblocks.
+	 */
+	return sb->nr_movable > 0 &&
+	       sb->nr_free < SPB_TAINTED_RESERVE;
 }
 
 /**
- * evacuate_irq_work_fn - IRQ work callback to drain pending evacuations
- * @work: the irq_work embedded in pg_data_t
+ * spb_defrag_done - Check if defrag target has been reached
+ * @sb: superpageblock being defragmented
  *
- * queue_work() can deadlock when called from inside the page allocator
- * because it may try to allocate memory with locks already held.
- * Use irq_work to defer the queue_work() calls to a safe context.
+ * Stop defragmenting when the superpageblock has enough free space
+ * or there are no more movable pages to evacuate.
+ */
+static bool spb_defrag_done(struct superpageblock *sb)
+{
+	/*
+	 * Tainted superpageblocks: keep evacuating movable pages until
+	 * the reserve of free pageblocks is restored, or until there
+	 * are no more movable pages to evacuate.
+	 */
+	return !sb->nr_movable ||
+	       sb->nr_free >= SPB_TAINTED_RESERVE;
+}
+
+/**
+ * spb_defrag_superpageblock - evacuate movable pages from a tainted superpageblock
+ * @sb: the tainted superpageblock to defragment
+ *
+ * Find any pageblock with movable pages (PB_has_movable) and evacuate
+ * them, leaving only unmovable, reclaimable, and free pages behind.
+ * Stop when the free space target is reached.
  */
-static void evacuate_irq_work_fn(struct irq_work *work)
+static void spb_defrag_superpageblock(struct superpageblock *sb)
 {
-	pg_data_t *pgdat = container_of(work, pg_data_t,
-					evacuate_irq_work);
-	struct llist_node *pending;
-	struct evacuate_item *item, *next;
+	unsigned long pfn, end_pfn;
+	struct zone *zone = sb->zone;
 
-	if (!pgdat->evacuate_wq)
+	if (!sb->nr_movable)
 		return;
 
+	end_pfn = sb->start_pfn + SUPERPAGEBLOCK_NR_PAGES;
+
+	for (pfn = sb->start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+
+		if (spb_defrag_done(sb))
+			return;
+
+		if (!pfn_valid(pfn))
+			continue;
+
+		page = pfn_to_page(pfn);
+
+		/* Skip pageblocks without movable pages */
+		if (!get_pfnblock_bit(page, pfn, PB_has_movable))
+			continue;
+
+		/* Skip if fully free -- nothing to evacuate */
+		if (get_pfnblock_bit(page, pfn, PB_all_free))
+			continue;
+
+		evacuate_pageblock(zone, pfn, true);
+	}
+}
+
+static void spb_defrag_work_fn(struct work_struct *work)
+{
+	struct superpageblock *sb = container_of(work, struct superpageblock,
+					     defrag_work);
+	u16 nr_free_before = sb->nr_free;
+	unsigned long flags;
+
+	spb_defrag_superpageblock(sb);
+
 	/*
-	 * Collect all pending items first, then queue them.  Use _safe
-	 * because evacuate_work_fn() may run immediately on another
-	 * CPU and free the item before we follow the next pointer.
+	 * If this pass produced no new free pageblocks, arm the no-progress
+	 * cooldown so spb_needs_defrag() rejects re-arms until either time
+	 * passes or nr_free_pages grows enough to suggest new material to
+	 * work on.  Use jiffies | 1 so the field is never accidentally zero.
 	 */
-	pending = llist_del_all(&pgdat->evacuate_pending);
-	llist_for_each_entry_safe(item, next, pending, free_node) {
-		INIT_WORK(&item->work, evacuate_work_fn);
-		queue_work(pgdat->evacuate_wq, &item->work);
+	if (sb->nr_free == nr_free_before) {
+		sb->defrag_last_no_progress_jiffies = jiffies | 1;
+		sb->defrag_last_no_progress_pages = sb->nr_free_pages;
+	} else {
+		sb->defrag_last_no_progress_jiffies = 0;
 	}
+
+	/*
+	 * Allow new defrag requests for this superpageblock.  Clear under
+	 * zone->lock to match the read/set sites in spb_maybe_start_defrag();
+	 * without this a missed re-arm window exists on weakly-ordered arches
+	 * when the worker retires just before the next allocator caller checks
+	 * defrag_active.
+	 */
+	spin_lock_irqsave(&sb->zone->lock, flags);
+	sb->defrag_active = false;
+	spin_unlock_irqrestore(&sb->zone->lock, flags);
 }
 
 /**
- * queue_pageblock_evacuate - schedule async evacuation of movable pages
- * @zone: the zone containing the pageblock
- * @pfn: start PFN of the pageblock (must be pageblock-aligned)
+ * spb_defrag_irq_work_fn - IRQ work callback to safely queue defrag work
+ * @work: the irq_work embedded in struct superpageblock
  *
- * Called from the page allocator when a movable pageblock is claimed
- * for unmovable or reclaimable allocations. Queues the pageblock for
- * background migration of its remaining movable pages. Uses irq_work
- * to defer the actual queue_work() call outside the allocator's lock
- * context.
+ * queue_work() can deadlock when called from inside the page allocator
+ * because it may try to allocate memory with locks already held.
+ * Use irq_work to defer the queue_work() call to a safe context.
  */
-static void queue_pageblock_evacuate(struct zone *zone, unsigned long pfn)
+static void spb_defrag_irq_work_fn(struct irq_work *work)
 {
-	struct evacuate_item *item;
-	pg_data_t *pgdat = zone->zone_pgdat;
+	struct superpageblock *sb = container_of(work, struct superpageblock,
+					     defrag_irq_work);
+	pg_data_t *pgdat = sb->zone->zone_pgdat;
 
-	if (!pgdat->evacuate_irq_work.func)
+	if (pgdat->evacuate_wq)
+		queue_work(pgdat->evacuate_wq, &sb->defrag_work);
+}
+
+/**
+ * spb_maybe_start_defrag - Trigger defrag if a superpageblock needs it
+ * @sb: superpageblock whose counters just changed
+ *
+ * Called from counter update paths (under zone->lock). If the
+ * superpageblock is tainted and running low on free space, schedule
+ * irq_work to queue defrag work outside the allocator's lock context.
+ * The irq_work handler is set up by pageblock_evacuate_init();
+ * before that runs, defrag_irq_work.func is NULL and we skip.
+ */
+static void spb_maybe_start_defrag(struct superpageblock *sb)
+{
+	if (!spb_needs_defrag(sb))
 		return;
 
-	item = evacuate_item_alloc();
-	if (!item)
+	/* Don't pile up work items; one defrag pass per superpageblock at a time */
+	if (sb->defrag_active)
 		return;
 
-	item->zone = zone;
-	item->start_pfn = pfn;
-	llist_add(&item->free_node, &pgdat->evacuate_pending);
-	irq_work_queue(&pgdat->evacuate_irq_work);
+	if (sb->defrag_irq_work.func) {
+		sb->defrag_active = true;
+		irq_work_queue(&sb->defrag_irq_work);
+	}
 }
 
 static int __init pageblock_evacuate_init(void)
 {
-	int nid, i;
-
-	/* Initialize the global freelist of work items */
-	init_llist_head(&evacuate_freelist);
-	for (i = 0; i < NR_EVACUATE_ITEMS; i++)
-		llist_add(&evacuate_pool[i].free_node, &evacuate_freelist);
+	int nid;
 
 	/* Create a per-pgdat workqueue */
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		char name[32];
+		int z;
 
 		snprintf(name, sizeof(name), "kevacuate/%d", nid);
 		pgdat->evacuate_wq = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
@@ -8385,14 +8492,40 @@ static int __init pageblock_evacuate_init(void)
 			continue;
 		}
 
-		init_llist_head(&pgdat->evacuate_pending);
-		init_irq_work(&pgdat->evacuate_irq_work,
-			      evacuate_irq_work_fn);
+		/* Initialize per-superpageblock defrag work structs */
+		for (z = 0; z < MAX_NR_ZONES; z++) {
+			struct zone *zone = &pgdat->node_zones[z];
+			unsigned long j;
+
+			if (!zone->superpageblocks)
+				continue;
+
+			for (j = 0; j < zone->nr_superpageblocks; j++) {
+				INIT_WORK(&zone->superpageblocks[j].defrag_work,
+					  spb_defrag_work_fn);
+				init_irq_work(&zone->superpageblocks[j].defrag_irq_work,
+					      spb_defrag_irq_work_fn);
+			}
+		}
 	}
 
 	return 0;
 }
 late_initcall(pageblock_evacuate_init);
+
+/**
+ * init_superpageblock_defrag - initialize defrag work structs for a superpageblock
+ * @sb: superpageblock to initialize
+ *
+ * Called during boot from pageblock_evacuate_init() and during memory
+ * hotplug from resize_zone_superpageblocks().  Safe to call multiple times
+ * on the same superpageblock (reinitializes work structs).
+ */
+void init_superpageblock_defrag(struct superpageblock *sb)
+{
+	INIT_WORK(&sb->defrag_work, spb_defrag_work_fn);
+	init_irq_work(&sb->defrag_irq_work, spb_defrag_irq_work_fn);
+}
 #endif /* CONFIG_COMPACTION */
 
 #ifdef CONFIG_CONTIG_ALLOC
-- 
2.54.0


