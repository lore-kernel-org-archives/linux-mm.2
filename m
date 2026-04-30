Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2000DCD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8766B00A1; Thu, 30 Apr 2026 16:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073726B00A5; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09416B00A2; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF5366B00A3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7946A1C0081
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:02 +0000 (UTC)
X-FDA: 84716346204.28.00C53AB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id CA55940002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=XowdH8CZ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unnSUcSeyu90hrVeSAwoGiiKpQvbbGUGgWqfn/6gO8I=;
	b=j02uAYsJlDagXGbukMVBJ1gFNtUfXPqTABX34wabHbTWTePVOsox9g5NtSifvrw4P+jLzj
	rcijD9l/mzZkcKlVAQLw+QblHUhsKgvpC8U97AxrchGAWmlcDPBNmVFTicD3DD/LE2utma
	Pt6onx4b9gOAn2ZqCVytt8B58ZDdDm8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580580; a=rsa-sha256;
	cv=none;
	b=TIc+wbnWrNpIWJowqXRLkAMlx1PashpuaxHoP3EP6Eqbjh1SJV+AVSl+Ik3RxTdV4+zvpd
	3v3IZmO2GNaR9a5+LNn9PtnT1qfdrZeB9CLw1z2LWNjtZFzQsr2Hx9dIXP+BVJalaexlWM
	lMA9aUH/gT3Zt4sPIn410E2ky5br6BU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=XowdH8CZ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=unnSUcSeyu90hrVeSAwoGiiKpQvbbGUGgWqfn/6gO8I=; b=XowdH8CZsFHswX/q4/fvPm62OK
	wYOzDL74hpUXMDtcFSw4gSewmhLV40+sW0VblfXSzeoyniqCF/p5J3xh+tns+GLJ2o5pS/MP36asS
	IB3sbsC5xsKkwG/kk4+aqwQ6ucmsPehQAotvwYRCib1tSKUXNAVDn//GSXsPekLnRQ4TsxBER3zGt
	SS67kVnAA9ujMLRu6CM6MSAKD8XVTFG+2asgzqjg/6WlDVZK7ri3zWczMBJYXjDRSAJmSKhtKnhbH
	YAm7gxOOYfNv0VEgYAEEhGIbSFPWmZthjIrJ/jrFndIS30QzGAxWozsfZXwdHgCC1sTeiLYcFQ9zr
	L3nKxkEg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2UE1;
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
Subject: [RFC PATCH 07/45] mm: page_alloc: async evacuation of stolen movable pageblocks
Date: Thu, 30 Apr 2026 16:20:36 -0400
Message-ID: <20260430202233.111010-8-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA55940002
X-Stat-Signature: ho6f98wxafj5pididd7fbzf8819bdxb9
X-Rspam-User: 
X-HE-Tag: 1777580580-825892
X-HE-Meta: U2FsdGVkX18MyeT0vPQx3fRUGrQS0zy0ocsz0YI13KZxOwli4vG+VghIG3ZvyKV7IqDTkbThFLjSQsurnjSQ1y4iOph15zVx7kbfIOpMUVz48Uw3KOrb/kdhUehmpQxDlQ/niagDMpzVyHfv3vKblhhonszYkLxtwlMkez0L0X9Kw2LdetAU4/MvRgcNJcwqCqToCUW9N07vKipKALJMkA24HpXXk0EKOaT7rqWyw2JEUoOYNcYHyWAUxEZgvvY/PxtGDL7TxFrd2kQmbJ1LLekmOZ1Fbo8tE9JOkb65fds7BEereNyeFtYjDZIfWGCigN+YGugQoxq5shuiRdm7nHBQTeWh0uiqwXQxQ8Gy0dh0td1pTpnBDEsI18LFT4zKOrWOigsuTdl0hWz/pl5BXY7iu8hp0BZ5boiWjaTNvwA7u+74nwkpAgGA/5LKdai8WqoeTlQOoW8vyXgzdDIydun0FcFzENhwEDV+bc13uuhDHNTDByM7c+2d0pjzZsLV21xDjtXcHYUE7tCc+wuJCEngOmVIxUmsGwOapoROuhRNYyF4mM/vcHR4rTuAArbr0CH6sez1kSLpuwD6kcHcMmACKiYUJ6wXKrv54IoqtqlC4SlnoMaxqNqmCvEWqVECnlhtrNBDtM/wLOsjxGoM6VJ/L5WYRbBLDQUwJmDP6jH7fn/Wn3gcsy/NDqxkZVDN6FEQjHNtQtifIu6t8MEL5yME3NojqKPaP2lX6FOEbRr7mnDAps663H8fJH5XL37elB9YVMWemat+PsTkqo17L0Uii8RgbJbcYpCemXoWLZPsqwLSYR91oEaoUrWfPJAWGDgyQwePzAjpx1Uuy3ZjNwv0OHc43D7E/O2P4+n+w2i4ReqfliOfI37xJ7/uqbIjfkQc0ubesBxfswt3Dqh+S1bkM152ymXjw/kaa1wUOV8oiYO87XoyrONulU33WgU1A2xWceb489WmBMH1hq1
 +TZh8d1G
 07hKvdycRmHFxzqMyJX6DEHHkO9ALTFpqqgTpJZPIpUVp+ybNg40h6bNkhPzFi/yrUd4NZKrylPc/554yRPa8vjFfibQS/kIEQr84uil8DkP3ho5MOXQBQQX4i7RB8KgzV3tQzwvqBnJcRs0fpBe7sRdIpsRrFdI7qaxZ3EnIbw3m5PrrIqIMEWedz2xstGfn7chfcKlAWr/D8n7yGf8clTNOA8Z1VVziTXN6m3PlrQdZW96Q2yx2aYZItcSJb4lhLbwTa+2t8Nv4wto/P9d6w1WXjDXa2bGFv980YnAKuW2xgXObe/lTSsqYMLtTr0bpaAUAhdO8KDoi5or9I4uPOTaKkotv5asqK0ZGMMFA+1YPIpjAjKH90R/nORv3D9tdixQBx1Wdnf9p6llwInFMAyKVj0tAE5hCz7SXboMCZq9idUNU3PQXLbzQLbH9kKNe3BHS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

When the page allocator steals a movable pageblock for unmovable or
reclaimable allocations (via try_to_claim_block), the remaining movable
pages in that block can prevent future unmovable/reclaimable allocations
from being concentrated in fewer pageblocks, leading to long-term memory
fragmentation.

Add a lightweight asynchronous evacuation mechanism: when a movable
pageblock is claimed for unmovable/reclaimable use, queue a work item to
migrate the remaining movable pages out. This allows future
unmovable/reclaimable allocations to be satisfied from the now-evacuated
block, keeping those allocation types concentrated and reducing
fragmentation.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |   4 +
 mm/page_alloc.c        | 223 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 227 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5d1869fd2708..2ab45d1133d9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -22,6 +22,7 @@
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/local_lock.h>
+#include <linux/irq_work_types.h>
 #include <linux/zswap.h>
 #include <asm/page.h>
 
@@ -1440,6 +1441,9 @@ typedef struct pglist_data {
 	wait_queue_head_t kcompactd_wait;
 	struct task_struct *kcompactd;
 	bool proactive_compact_trigger;
+	struct workqueue_struct *evacuate_wq;
+	struct llist_head evacuate_pending;
+	struct irq_work evacuate_irq_work;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5cc5edaf8111..45c25c4fc7c0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
+#include <linux/irq_work.h>
 #include <linux/jiffies.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
@@ -51,6 +52,7 @@
 #include <linux/lockdep.h>
 #include <linux/psi.h>
 #include <linux/khugepaged.h>
+#include <linux/workqueue.h>
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
@@ -59,6 +61,10 @@
 #include "shuffle.h"
 #include "page_reporting.h"
 
+#ifdef CONFIG_COMPACTION
+static void queue_pageblock_evacuate(struct zone *zone, unsigned long pfn);
+#endif
+
 /* Free Page Internal flags: for internal, non-pcp variants of free_pages(). */
 typedef int __bitwise fpi_t;
 
@@ -2409,6 +2415,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
 
+	/*
+	 * Don't steal from pageblocks that are isolated for
+	 * evacuation — that would undo the work in progress.
+	 */
+	if (get_pageblock_isolate(page))
+		return NULL;
+
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
@@ -2454,6 +2467,18 @@ try_to_claim_block(struct zone *zone, struct page *page,
 			page_group_by_mobility_disabled) {
 		__move_freepages_block(zone, start_pfn, block_type, start_type);
 		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
+#ifdef CONFIG_COMPACTION
+		/*
+		 * A movable pageblock was just claimed for unmovable or
+		 * reclaimable use. Queue async evacuation of the remaining
+		 * movable pages so future unmovable/reclaimable allocations
+		 * can stay concentrated in fewer pageblocks.
+		 */
+		if (block_type == MIGRATE_MOVABLE &&
+		    (start_type == MIGRATE_UNMOVABLE ||
+		     start_type == MIGRATE_RECLAIMABLE))
+			queue_pageblock_evacuate(zone, start_pfn);
+#endif
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
@@ -7089,6 +7114,204 @@ void __init page_alloc_sysctl_init(void)
 	register_sysctl_init("vm", page_alloc_sysctl_table);
 }
 
+#ifdef CONFIG_COMPACTION
+/*
+ * Pageblock evacuation: asynchronously migrate movable pages out of
+ * pageblocks that were stolen for unmovable/reclaimable allocations.
+ * This keeps unmovable/reclaimable allocations concentrated in fewer
+ * pageblocks, reducing long-term fragmentation.
+ *
+ * Uses a global pool of 64 pre-allocated work items (~3.5KB total)
+ * and a per-pgdat workqueue to keep migration node-local.
+ */
+
+struct evacuate_item {
+	struct work_struct	work;
+	struct zone		*zone;
+	unsigned long		start_pfn;
+	struct llist_node	free_node;
+};
+
+#define NR_EVACUATE_ITEMS	64
+static struct evacuate_item evacuate_pool[NR_EVACUATE_ITEMS];
+static struct llist_head evacuate_freelist;
+
+static struct evacuate_item *evacuate_item_alloc(void)
+{
+	struct llist_node *node;
+
+	node = llist_del_first(&evacuate_freelist);
+	if (!node)
+		return NULL;
+	return container_of(node, struct evacuate_item, free_node);
+}
+
+static void evacuate_item_free(struct evacuate_item *item)
+{
+	llist_add(&item->free_node, &evacuate_freelist);
+}
+
+static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn)
+{
+	unsigned long end_pfn = start_pfn + pageblock_nr_pages;
+	unsigned long pfn = start_pfn;
+	int nr_reclaimed;
+	int ret = 0;
+	struct compact_control cc = {
+		.nr_migratepages = 0,
+		.order = -1,
+		.zone = zone,
+		.mode = MIGRATE_ASYNC,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+	};
+	struct migration_target_control mtc = {
+		.nid = zone_to_nid(zone),
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+	};
+
+	/* Verify this pageblock is still worth evacuating */
+	if (get_pageblock_migratetype(pfn_to_page(start_pfn)) == MIGRATE_MOVABLE)
+		return;
+
+	INIT_LIST_HEAD(&cc.migratepages);
+
+	/*
+	 * Loop through the entire pageblock, isolating and migrating
+	 * in batches. isolate_migratepages_range stops at
+	 * COMPACT_CLUSTER_MAX, so we must loop to cover the full block.
+	 */
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
+					    alloc_migration_target, NULL,
+					    (unsigned long)&mtc, cc.mode,
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
+static void evacuate_work_fn(struct work_struct *work)
+{
+	struct evacuate_item *item = container_of(work, struct evacuate_item,
+						  work);
+	evacuate_pageblock(item->zone, item->start_pfn);
+	evacuate_item_free(item);
+}
+
+/**
+ * evacuate_irq_work_fn - IRQ work callback to drain pending evacuations
+ * @work: the irq_work embedded in pg_data_t
+ *
+ * queue_work() can deadlock when called from inside the page allocator
+ * because it may try to allocate memory with locks already held.
+ * Use irq_work to defer the queue_work() calls to a safe context.
+ */
+static void evacuate_irq_work_fn(struct irq_work *work)
+{
+	pg_data_t *pgdat = container_of(work, pg_data_t,
+					evacuate_irq_work);
+	struct llist_node *pending;
+	struct evacuate_item *item, *next;
+
+	if (!pgdat->evacuate_wq)
+		return;
+
+	/*
+	 * Collect all pending items first, then queue them.  Use _safe
+	 * because evacuate_work_fn() may run immediately on another
+	 * CPU and free the item before we follow the next pointer.
+	 */
+	pending = llist_del_all(&pgdat->evacuate_pending);
+	llist_for_each_entry_safe(item, next, pending, free_node) {
+		INIT_WORK(&item->work, evacuate_work_fn);
+		queue_work(pgdat->evacuate_wq, &item->work);
+	}
+}
+
+/**
+ * queue_pageblock_evacuate - schedule async evacuation of movable pages
+ * @zone: the zone containing the pageblock
+ * @pfn: start PFN of the pageblock (must be pageblock-aligned)
+ *
+ * Called from the page allocator when a movable pageblock is claimed
+ * for unmovable or reclaimable allocations. Queues the pageblock for
+ * background migration of its remaining movable pages. Uses irq_work
+ * to defer the actual queue_work() call outside the allocator's lock
+ * context.
+ */
+static void queue_pageblock_evacuate(struct zone *zone, unsigned long pfn)
+{
+	struct evacuate_item *item;
+	pg_data_t *pgdat = zone->zone_pgdat;
+
+	if (!pgdat->evacuate_irq_work.func)
+		return;
+
+	item = evacuate_item_alloc();
+	if (!item)
+		return;
+
+	item->zone = zone;
+	item->start_pfn = pfn;
+	llist_add(&item->free_node, &pgdat->evacuate_pending);
+	irq_work_queue(&pgdat->evacuate_irq_work);
+}
+
+static int __init pageblock_evacuate_init(void)
+{
+	int nid, i;
+
+	/* Initialize the global freelist of work items */
+	init_llist_head(&evacuate_freelist);
+	for (i = 0; i < NR_EVACUATE_ITEMS; i++)
+		llist_add(&evacuate_pool[i].free_node, &evacuate_freelist);
+
+	/* Create a per-pgdat workqueue */
+	for_each_online_node(nid) {
+		pg_data_t *pgdat = NODE_DATA(nid);
+		char name[32];
+
+		snprintf(name, sizeof(name), "kevacuate/%d", nid);
+		pgdat->evacuate_wq = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+		if (!pgdat->evacuate_wq) {
+			pr_warn("Failed to create evacuate workqueue for node %d\n", nid);
+			continue;
+		}
+
+		init_llist_head(&pgdat->evacuate_pending);
+		init_irq_work(&pgdat->evacuate_irq_work,
+			      evacuate_irq_work_fn);
+	}
+
+	return 0;
+}
+late_initcall(pageblock_evacuate_init);
+#endif /* CONFIG_COMPACTION */
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
-- 
2.52.0


