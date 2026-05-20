Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C60CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CBB6B00A1; Wed, 20 May 2026 11:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149636B00A3; Wed, 20 May 2026 11:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0590D6B00A1; Wed, 20 May 2026 11:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05D56B00A1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF8FC8CD3D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:47 +0000 (UTC)
X-FDA: 84788110134.22.814639D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D15318001D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Y76r9bMo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wlnd9k10K1fagsrmIWt7MyygubkQyWXShAgLjFuCo0=;
	b=Un0zYmeFkJUvEjhXBpI9YwBh7WAkUJmm3vIiAX77zUqC7+hV/lyGktncW31MRghw9jxz8C
	aklOZVngWKhVFt1EX2u/2ZcB/GgQ56HQjfEqstSxu5uFgxb1FMQWiiUgSIJv/fdVl3FpyC
	FinexTrz9gbq6xCkFO2fbgSklqsfhAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289246; a=rsa-sha256;
	cv=none;
	b=8dlFWo5EF72I/pX3KHkQRlwiQ1VMV+DP7RR6jb3UrUIhoZnhbC6l0xay+mQ7r0kZ9JnZXm
	9ZINSUvSYzg3tS16aF79De6VdG29P+7HLxJqqhYwUfQbH7YLyxsHD0LTXuepGIQ/wsci+H
	6ru56914jT8WiyzBR7u2WS3PRSdSZEg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Y76r9bMo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1wlnd9k10K1fagsrmIWt7MyygubkQyWXShAgLjFuCo0=; b=Y76r9bMom3LGgcPyxMuHW2xdIx
	x55SShjWwJ1GYSQxZFZr3wSAdPsmrlvjg5qFZj7P0kxyzoeL4Cv73Cpdr2O7+r/SKCX0r7EPTG4g4
	cIU5SUqHMGYF7o8eSvC8KhFisYPW8FFyN5lVNhTw2guUPV+KvlB7IDxip51mKezOn2Ps8uJTYkFoV
	zjIenPQJkniML5TeaI31AJvwrSDZ4UQ01FQjyO2lwK3WMpyZUrAZwWuuauO1reA386veoVUYmQMOC
	wt1GITzoFwJHM/KOlXxEQcUfPQrvbd2jMy3GnZMbJXRzL24e4RbSPJCUG3ySPoblhJoronfMo9mRu
	FsDmPlqw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0jGZ;
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
Subject: [RFC PATCH 06/40] mm: page_alloc: async evacuation of stolen movable pageblocks
Date: Wed, 20 May 2026 10:59:12 -0400
Message-ID: <20260520150018.2491267-7-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D15318001D
X-Rspamd-Server: rspam04
X-Stat-Signature: 741hwcmod6oztebpc8ojkrrmsi98odyi
X-HE-Tag: 1779289245-740526
X-HE-Meta: U2FsdGVkX1+uA8InftN9JxA2bNu6F/ncMgwbQXU6+HzMmyX5zsGSsWTmGH4cuns6T1BTaEvp+To7vhPV65FeKgHCDmqlX848ALlNbzgeLs7dhmtpClJ30Z0VdcZS0iGOG5G65qAKd6joH10o/ufS8QIVs+VkJXCg0+SW2yLmJi8wTc3kMJq0oqcOEovgxAG/38AmWY+50+uLIN1rtoM55MMQSwRcVVYuPBUSXILH6zwZl+/Y1xCh3r/P35Oel0MoT/b+2wRyVfa4NKD/RMnEcNWQUmGafqV8tN1kFdgE7OKfoD27Xo4BjG1dvMwQqxEj257/scI9so4IPBGhTP/LGnuUYlw0oA60hAdoabZCv/LO0cdXbzHHSD696bv6xc1mnEPHWE55LanhVfX7YhUg856ENEVOOSFR111Srf8OGKuUOJDvBy8IBw1XgmnadA2kcrM66RV13PG9f6LxH1R0821yadT9QR1AouKfu9Q7pz6Q+0HSPZWbM+whETMgMZhyCMYxyaKw6A+ofoa7f/MPj7IXajnqMTGQpNpqkeuaEAWveLhKlwp5nAGty1hFa/QRMKzvgayFcECpC14tq6POKp3xP8QuXlhwPahtVf4cb78HBypJ4GpChfAd8VJugVLE02ZbbWQGXblTOXuV2gi1wReXhHbqTazmE2gZR3y3j/Xm7H4jfGgXe2HcDBF22nwnOEsYAGvP6l4Du0+HuGI4NhTAaPiVKYOiS51ICVZezqPOloJn+C6xn4/7j2hyfM2CrxH9elUh/BJq/Jiedy5XnumnL0wvbO/fGD/eTTJos70G7xgCN0gL0VVX/N+T0sNG9Ssz9gHFSkEhHSYvNw4vZMy6g42X+O2r+MCC5wyWlEC5pltlklhhDXx9vp+TvDeOSCh02dlC8/Z9+nqSswTX15SV2SFIIghsgJel75NsERDWLL9m1WAoQdANYPVFLZAC9SO+VRrh3v+pM8uSFCj
 GlaM56eL
 xoJLcnojlObO4p0wLMy/+/+BuLGtX/7KW9lG3x74iXZmaRQTih9w9Gd/OQP0oe3aVmGgrUuwolH7s7pCcYvXTVLaVq6N6rVOoGQPBQSZJ1fWnE058lcFa7089Bta7tqHJmiHIW8Qguvji91udqmLWakZp4hvlMduq8p0GCQwWP0JC5d9/vvPaD3LIiS+x/Mj6LQ9ckASyaXRFKhx66alg/KWwtYpevQ2vZmJi+0iZWNMwiCN0ApOsnbFEKmcI/o6RZw85R0PeRe7gCTADfWnAfAo+OwrkA2473AMMqMDik8j15GTuHMevumfIBUMCKh1fkoN3GUfXnHv2fTDF9yjWIc2JWCQgNe3W+xkO3ie9+Pq/TdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 13e29b2ebb86..90498bbbf60b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -22,6 +22,7 @@
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/local_lock.h>
+#include <linux/irq_work_types.h>
 #include <linux/zswap.h>
 #include <linux/sizes.h>
 #include <asm/page.h>
@@ -1540,6 +1541,9 @@ typedef struct pglist_data {
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
index 6e01e58aca54..0f3d734bd296 100644
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
 
@@ -2428,6 +2434,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
 
+	/*
+	 * Don't steal from pageblocks that are isolated for
+	 * evacuation -- that would undo the work in progress.
+	 */
+	if (get_pageblock_isolate(page))
+		return NULL;
+
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
@@ -2473,6 +2486,18 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
 
@@ -7184,6 +7209,204 @@ void __init page_alloc_sysctl_init(void)
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
2.54.0


