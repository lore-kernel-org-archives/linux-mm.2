Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5E2CD13D2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C206B00C5; Thu, 30 Apr 2026 17:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415196B00C6; Thu, 30 Apr 2026 17:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8186B00C7; Thu, 30 Apr 2026 17:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3626B00C5
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:11:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FF951A01E3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:11:33 +0000 (UTC)
X-FDA: 84716468466.14.6BECA90
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7D90A0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:11:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S3Q84uTs;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777583492; a=rsa-sha256;
	cv=none;
	b=zTqzrjgqKAJ0vEpZMhazoiNoMzeGUGrGStP/gNfiw9sHSTVcDaMEW0Np+XlqeSWsckaocS
	XuPVHLciPFWab3Rd0Oghpw1X9l0sSsA/IEKckbso+iGXgPZoQoST5k9YNG2YUWGlDsO3mN
	LHcFZB+cBaD88CKDXn9UMTqS40f+h6Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S3Q84uTs;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777583492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PD7yz2P9n7w+TkYRu6/Qo4yUZbiVReNQNEOFlyrg3M=;
	b=Qhk58A8wBfLBZS8pG/2tha15natiHYj9TVAukM4LW0GEZ/GDp5YcssmMHTVyaDhwx1XzV4
	l7EXV86GREN+fYbJzcwAuENrJ8LmOViW2dzA9UiV3C58Napdi3Ftq8zohocWxlTMTvRrs0
	aACRz14wk+EsSuCUEPJ30zoSag6vvPM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+PD7yz2P9n7w+TkYRu6/Qo4yUZbiVReNQNEOFlyrg3M=; b=S3Q84uTs7XZ7mGI1EOrb/FsrbB
	IkjZXnJto0jv9ufuaPGZWXV0lSZuSBNhk8K7T/6WeRWoVD8dJWhzpoTAlciOjHK/mIG51TmtFbh3c
	PNDZvczcKyiyIpkWZyf1Df5L3Y2DSuSP10ov4KLmwgG4Sa8JteLrkU23kKtn63bh+ws4CM1k3yqMO
	J2pl8tEMccU+D3xPOBs8cC2xMJdW6hpUg6Bmd92yF7LLdWQCeKVL0jzfEPgTRzBwuF7VqyP41rVBM
	9CYxDqgi8k1fyJk/xHnIT7dto8eZ+PDqgf8LTtig7KcONrXwsP5Yl5u1aU+uFlTnPLX2FV7Bulsti
	jmmPlgOA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3OQC;
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
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 16/45] mm: page_alloc: add background superpageblock defragmentation worker
Date: Thu, 30 Apr 2026 16:20:45 -0400
Message-ID: <20260430202233.111010-17-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9q8pk3wm7a5yd16g6a4adf6mhi897ok8
X-Rspam-User: 
X-Rspamd-Queue-Id: D7D90A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777583491-984350
X-HE-Meta: U2FsdGVkX1+fa5dpdUpu5PUmsy6Azn1vjAHQQpNZZ4Pwrgn7YRhvz7fdik8Bi7SD0Aw/1jvg47YLfarGFopChXuLXFCImHPOnX9lrBIP9V3rWOj6676VC+CO2DkKDAa4XnLTOYcJWCVLt2NOOCGMCyXRj4XBH6ZHx6SDsALk0ApIaJPfq30CUo3Vxk9cWqVNCYVC3lT4sgTzzEj9npweM5UIsvgAbOlLK6BvLv9iwHkeEq8xuYYWUhafmsaslymRHXsXLHxa+/xXSZZ+beIEWfzdmwPhD96F2ZH+X4GLnqtkaKmfcqX1D4Owiswvq7gokcZ/1zaEDikWXplJyocb1zUaET63Jp8L4/VNUvtORrtroiKiP+c797GgqOmz6A5FQZuya8NojUpKXJyblt+t03XKySIQ+H/nXbvVxlaAmy86qIwbc0XHokgr9Fd2RlySe126oSfE40Drri9pxGukv3cw4QhiCyHfGdu8NNtLjPcb5ETahrsIQxER/H/c+STk5WJguwPUJPFM/pBVamA/t3WlGR3SeaUBY8bPXYm6XyhY8sCHfQtFaK8qpFTLGEuU5+rC5i1in+3ffDJo0EWkddhrFQEjPOH5DAOX5/Oe88AgVvdZkwGmMMW8rsH7MWVT7jizOXboiXx0odMMNX9OGb1psefrVBtBsqqR7VTy9O1Ms1d4TUl6bxBrwlJl/LW8LthUIoA4ot/Vffkg5kuveSoLcXVcJyA4ZqNaWPbdvz1u1UaRYA2q9bwn3ZoZXw/Yc4NcQN/yQ9fRsIuRjqA65vqhY3iA/aGNWw3hIJ5/VYdq1LB6EmhNC7p2IFqbteBst1nGOalbliW1jSgYzAAIIjCFTM6YJr8FhXZavqEtR0lpmtmQvPXOgR/UdxppKHbQt6eCf10ka4rXE3JeGUoJjngNd2dW6555MV5BvH5AEpQpLbvKhopSXX3pT13KIFrUTGyUZLOgOYA13q+7AuC
 8Hy5m5Vh
 cWKMifj8IY49CHNax3BNBy1eQxziCGJDkEC6i7SvmQEIJ75ROirz7JCx2zdua8O1vaw4GC8MCY3YPFOLO+LpTzZzJAQGnw/NiiVLPxuG6RuHX3je3o87IUJmZ0v4e0UOrZDKAtDH1Nf3u6dmeEeEK35XI/FMlji3iNwSSwOzFyZ9anNV+tHu+wtqVT7xJpm9w/VKF5QiQf58c09XhPtEPlgVJg+ckH7QVqk4CKLLy/M2r+4DNaSFiXo/we0CPc4dPcytfHjH6LIXw2vEbZvqWt9JcPTZtYUrReHvB/7TsCnxjcW/GUsuQaL44yiKUWbXOATKh+XouKC/IT5SiIj0c8vBQuvKJJxHYyLBI8Cn75jHr+0FHSD5hCL8L7nfN7djk1sTgp+hpBI/IajSS5cFxPsdAYoOnMAeDwCI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

Add an event-driven background worker that evacuates movable pages from
tainted superpageblocks when free space runs low. Each superpageblock has
its own work_struct, so defrag targets the specific superpageblock that
needs it rather than scanning the entire system.

Defrag is triggered from sb_update_list() when a tainted superpageblock
drops below threshold: 1 or fewer free pageblocks, or less than 2
pageblocks worth of free pages. The worker evacuates movable pageblocks
until free space recovers: at least 2 free pageblocks or 3 pageblocks worth
of free pages, or no movable pages remain.

Clean superpageblocks (only free + movable) are never defragged since they
don't need it. Superblocks with no movable pages are skipped since there is
nothing to evacuate.

[v19 fold] Drop the now-dead per-pageblock evacuate plumbing
(queue_pageblock_evacuate, evacuate_item, evacuate_pool, evacuate_freelist,
evacuate_item_alloc/free, evacuate_work_fn, evacuate_irq_work_fn, plus
pgdat->evacuate_pending and pgdat->evacuate_irq_work). The new
background superpageblock defragmentation worker introduced here calls
evacuate_pageblock() directly from within its own work_struct, so the
async per-pageblock work-item pool, the irq_work indirection, and their
per-pgdat init in pageblock_evacuate_init() are no longer used.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  19 ++-
 mm/internal.h          |   2 +
 mm/mm_init.c           |  87 +++++++----
 mm/page_alloc.c        | 317 ++++++++++++++++++++++++++++-------------
 4 files changed, 301 insertions(+), 124 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f226dfdd1e99..61fe939e7c0f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -937,6 +937,23 @@ struct superpageblock {
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
@@ -1532,8 +1549,6 @@ typedef struct pglist_data {
 	struct task_struct *kcompactd;
 	bool proactive_compact_trigger;
 	struct workqueue_struct *evacuate_wq;
-	struct llist_head evacuate_pending;
-	struct irq_work evacuate_irq_work;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/mm/internal.h b/mm/internal.h
index 7ee73f9bb76c..02f1c7d36b85 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1026,9 +1026,11 @@ void init_cma_reserved_pageblock(struct page *page);
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
index 80cfc7c4de98..1f55ff3126a2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1668,6 +1668,7 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	size_t alloc_size;
 	unsigned long i;
 	int nid = zone_to_nid(zone);
+	unsigned long flags;
 
 	if (!zone->spanned_pages)
 		return;
@@ -1690,6 +1691,37 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 		return;
 	}
 
+	/* Initialize new superpageblocks (not from old array) first, outside lock */
+	if (zone->superpageblocks) {
+		old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
+			     SUPERPAGEBLOCK_ORDER;
+	} else {
+		old_offset = 0;
+	}
+
+	for (i = 0; i < new_nr_sbs; i++) {
+		struct superpageblock *sb = &new_sbs[i];
+		bool is_old = false;
+
+		if (zone->superpageblocks &&
+		    i >= old_offset &&
+		    i < old_offset + zone->nr_superpageblocks)
+			is_old = true;
+
+		if (is_old)
+			continue;
+
+		init_one_superpageblock(sb, zone,
+					new_sb_base + (i << SUPERPAGEBLOCK_ORDER),
+					zone_start, zone_end);
+	}
+
+	/*
+	 * Take zone->lock for the copy+fixup+swap to prevent concurrent
+	 * allocations from traversing free lists while we relocate them.
+	 */
+	spin_lock_irqsave(&zone->lock, flags);
+
 	/*
 	 * Copy existing superpageblocks to their new position.
 	 * The old array covers [old_base, old_base + old_nr * SB_SIZE).
@@ -1703,39 +1735,42 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 		       zone->nr_superpageblocks * sizeof(struct superpageblock));
 
 		/*
-		 * Fix up list_head pointers that were self-referencing
-		 * (empty lists) or pointing into the old array.
+		 * Fix up all list_head pointers: both the SPB category list
+		 * and every free_area[order].free_list[migratetype]. Pages on
+		 * buddy free lists have buddy_list.prev/next pointing at the
+		 * old array's list heads — those must be updated to point at
+		 * the new array.
 		 */
 		for (i = old_offset; i < old_offset + zone->nr_superpageblocks; i++) {
 			struct superpageblock *sb = &new_sbs[i];
+			struct superpageblock *old_sb =
+				&zone->superpageblocks[i - old_offset];
+			int order, mt;
 
-			if (list_empty(&sb->list))
+			/* Fix up sb->list (zone category/fullness list) */
+			if (list_empty(&old_sb->list))
 				INIT_LIST_HEAD(&sb->list);
 			else
-				list_replace(&zone->superpageblocks[i - old_offset].list,
-					     &sb->list);
-		}
-	}
-
-	/* Initialize new superpageblocks (slots not covered by old array) */
-	for (i = 0; i < new_nr_sbs; i++) {
-		struct superpageblock *sb = &new_sbs[i];
-		bool is_old = false;
+				list_replace(&old_sb->list, &sb->list);
+
+			/* Fix up all free_area list heads */
+			for (order = 0; order < NR_PAGE_ORDERS; order++) {
+				for (mt = 0; mt < MIGRATE_TYPES; mt++) {
+					struct list_head *old_list =
+						&old_sb->free_area[order].free_list[mt];
+					struct list_head *new_list =
+						&sb->free_area[order].free_list[mt];
+
+					if (list_empty(old_list))
+						INIT_LIST_HEAD(new_list);
+					else
+						list_replace(old_list, new_list);
+				}
+			}
 
-		if (zone->superpageblocks) {
-			old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
-				     SUPERPAGEBLOCK_ORDER;
-			if (i >= old_offset &&
-			    i < old_offset + zone->nr_superpageblocks)
-				is_old = true;
+			/* Reinitialize defrag work structs (contain stale pointers) */
+			init_superpageblock_defrag(sb);
 		}
-
-		if (is_old)
-			continue;
-
-		init_one_superpageblock(sb, zone,
-					new_sb_base + (i << SUPERPAGEBLOCK_ORDER),
-					zone_start, zone_end);
 	}
 
 	/*
@@ -1774,6 +1809,8 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	zone->superpageblock_base_pfn = new_sb_base;
 	zone->spb_kvmalloced = true;
 
+	spin_unlock_irqrestore(&zone->lock, flags);
+
 	/*
 	 * The boot-time array was allocated with memblock_alloc, which
 	 * is not individually freeable after boot.  Only kvfree arrays
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf5f48d377e..07d2926ffb3d 100644
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
 
@@ -753,8 +749,15 @@ static inline enum sb_fullness sb_get_fullness(struct superpageblock *sb,
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
@@ -771,6 +774,8 @@ static void spb_update_list(struct superpageblock *sb)
 	cat = spb_get_category(sb);
 	full = sb_get_fullness(sb, cat);
 	list_add_tail(&sb->list, &zone->spb_lists[cat][full]);
+
+	spb_maybe_start_defrag(sb);
 }
 
 /**
@@ -3297,12 +3302,6 @@ try_to_claim_block(struct zone *zone, struct page *page,
 			sb = pfn_to_superpageblock(zone, start_pfn);
 			if (sb)
 				spb_update_list(sb);
-
-			if ((start_type == MIGRATE_UNMOVABLE ||
-			     start_type == MIGRATE_RECLAIMABLE) &&
-			    get_pfnblock_bit(start_page, start_pfn,
-					     PB_has_movable))
-				queue_pageblock_evacuate(zone, start_pfn);
 		}
 #endif
 		return __rmqueue_smallest(zone, order, start_type);
@@ -8100,42 +8099,14 @@ void __init page_alloc_sysctl_init(void)
 
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
@@ -8153,8 +8124,14 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
 	};
 
-	/* Verify this pageblock is still worth evacuating */
-	if (get_pageblock_migratetype(pfn_to_page(start_pfn)) == MIGRATE_MOVABLE)
+	/*
+	 * Verify this pageblock is still worth evacuating.
+	 * Skip if it reverted to MOVABLE (steal was undone) — unless
+	 * force is set (background defrag wants to clear movable pages
+	 * out of tainted superpageblocks regardless of pageblock type).
+	 */
+	if (!force &&
+	    get_pageblock_migratetype(pfn_to_page(start_pfn)) == MIGRATE_MOVABLE)
 		return;
 
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -8209,86 +8186,206 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
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
  */
-static void evacuate_irq_work_fn(struct irq_work *work)
+static bool spb_defrag_done(struct superpageblock *sb)
 {
-	pg_data_t *pgdat = container_of(work, pg_data_t,
-					evacuate_irq_work);
-	struct llist_node *pending;
-	struct evacuate_item *item, *next;
+	/*
+	 * Tainted superpageblocks: keep evacuating movable pages until
+	 * the reserve of free pageblocks is restored, or until there
+	 * are no more movable pages to evacuate.
+	 */
+	return !sb->nr_movable ||
+	       sb->nr_free >= SPB_TAINTED_RESERVE;
+}
 
-	if (!pgdat->evacuate_wq)
+/**
+ * spb_defrag_superpageblock - evacuate movable pages from a tainted superpageblock
+ * @sb: the tainted superpageblock to defragment
+ *
+ * Find any pageblock with movable pages (PB_has_movable) and evacuate
+ * them, leaving only unmovable, reclaimable, and free pages behind.
+ * Stop when the free space target is reached.
+ */
+static void spb_defrag_superpageblock(struct superpageblock *sb)
+{
+	unsigned long pfn, end_pfn;
+	struct zone *zone = sb->zone;
+
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
+		/* Skip if fully free — nothing to evacuate */
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
+	/* Allow new defrag requests for this superpageblock */
+	sb->defrag_active = false;
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
+
+	if (pgdat->evacuate_wq)
+		queue_work(pgdat->evacuate_wq, &sb->defrag_work);
+}
 
-	if (!pgdat->evacuate_irq_work.func)
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
@@ -8297,14 +8394,40 @@ static int __init pageblock_evacuate_init(void)
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
2.52.0


