Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E163CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF5E56B00BA; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80866B00B8; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF556B00B9; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75F2A6B00BA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73F89C09E7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:11 +0000 (UTC)
X-FDA: 84716346582.02.AA73F02
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB9D41A0015
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=B8urToHm;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5woKGpFtMZpXLGak87d5nknUpZPzOF8tgzHqPV/fek=;
	b=a4w25PP145PnOjT0mo7Ok0ASP13KKd1JW6r1fObVp89WFmaXLLVl+iWz13/QXBeJurXYGA
	XOmZVVAgFy5t8Obx9ZSXgy9+i1n5ZZmXHUrha2xa/p+nU0CQ0jYKZZnrBPrRROdF6O2PnV
	keZb/0xyeSWPn66fxQmcPjAzF/05s+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580589; a=rsa-sha256;
	cv=none;
	b=WwZj9918t6sUctLDkkTJbkfgPJXkyOyJbK4z7kQnNbJpHmZGbzmEqdCc+5DgbCEw0t+Ckv
	vx72sGayeU3y3Gptj5+4rOHCIEZE2YiQBqoIKUieWug6+Tx/lkfErGCQtCOw7zKRZXEr1+
	i+JPkVUB35P3TqHFCll3apyznrheLEI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=B8urToHm;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k5woKGpFtMZpXLGak87d5nknUpZPzOF8tgzHqPV/fek=; b=B8urToHm5ZW6esCYWa3AnNuy4t
	j3sBY8BvY+v/30RHH5pgT8XxuXqzyUxJkH4eGX9zhXhDeMtGck7ss16yZ2Ki9F8IqgBtIg0K4BcwN
	K51OHgVbxef4Ep52Y61SNz+fjTpnxYeRL05udZ0Hi/j0yZWsiU/Ew1Qk+JfKtzCjT1b/ic2p5M6Lp
	oBn/G6egLy7yXWahF9i7i9Gh6hS6tZV23XLLlE/jIHjLM59/ftJEnXY4G2OlYQKxrCzxPAWjVx9qJ
	1m4ESgrv0QA/6x0UO584ot9dgOAhX/78lLqL5hQF/dVN9l+1WCaJSHGq7Oq4/iAtSXH0p913Fb2Si
	tjl7c9zQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-0gVj;
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
Subject: [RFC PATCH 27/45] mm: trigger deferred SPB evacuation when atomic allocs would taint a clean SPB
Date: Thu, 30 Apr 2026 16:20:56 -0400
Message-ID: <20260430202233.111010-28-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB9D41A0015
X-Stat-Signature: xyedxyw59cm8e1rsn3swkyi53dn3yw7j
X-Rspam-User: 
X-HE-Tag: 1777580589-931070
X-HE-Meta: U2FsdGVkX182BJcO4ecePAgMT3cDNPZn1FIoDTNRzTAzcKAaeYdmysLDujVUlRC9sR7aW4lbGGpjW5CMGclFRH8nik23CW0uNwAHJtIZP6oMSBo70YiSDI6HqCAmFm8oPfxsJygrn9DarB9ziFuKiosHJMoZuviBXVVkBdzixVPjIPFDW0aJsj1VamwafOFhVq6kNSSeueDcTJTSXqxXKWHVrVWni9O6TtxrT32MiVg2uYMP/diHtpVa/mel7dALFkoqGdienq85O4NArLLDpqxKdPagidbRWRa6/0nHnCE2+6sbX0fzh1WOLnKBaXn78/8Mh/VG++xpOfqLygKc27DN/dUAcOBsFeITZYBFGfOVyBhzc/z2Rtwd/vsttBsblIpyPrTPPXOYl5aPbpae4AFSizflBGv+L3fxvF1i6zW4d2QQcHjik/pcwoftgqFxsMQTmWFwhDs5ritGW/eevs4uqcqvnZ+t06hL1yBUQyh4WRVPW3wF+hVrzMDGO6N/vy9yRryASLOrGnMZ3S2kmDJjBPZsVjdkADlrdwPnU6+tQI34nwdj44ik4G49+MkXuZ6r22ccJz3s+P6N7wmbaanJthN2f1/7xgtqIU/KrIlLB6WPhJRcWRle2gDJrFugQ7B5cOU4xm8WyL8dRCUz53EcDrDK9M/YypCeNC2bms2TqCbCVc7XyxAPrjhm2zGJwVclkcfVOyYhffAg6yuBg/o39M+S+F5DynbeKLhpOjAT0E8F0D/ZCSu4VSlbtYkN3eSUWD5Q1JkMVHRYwCsqXZ0tmaexIcjdqOcSdEYUdeJleyfDOydGlYkF/n7AgPhLcZ0EqjDTB7sRycq33W9FHtRFTcPOP6PFgdyUjeL5epsfTZ3awDy7yovcs1wZbw9ctUa2J84dh/zIqZpXARXdjtLUaAOx8QKGvUUnRAttv8kFURzvqDpmVX4pI5+Si+JrONnn9XlsihoUQSUD5/v
 M3WRsTC1
 GAXhA8gvuZuHPuRXwnta668Ea5S5xZZKwC/rWgIcUOL3VIHqKVY7tJbmPb3jZF/69/v7bKYx/S+17UYLbdD6dkAev0at9KipXmF2q9neoNPdJ+N6xqNEcZLaI+hDNMmQ0FkFCfc1XbsI5Sr7JjxwK68e8pHM+/ZADz2o2sm+xgJ/bAmLgqXFgHl79prqNomCknz9Qc9LlwdhvaTJ3gkeEasTdh1r95qzApsnplFZJod7syqthKaeRlUg/nNjwLWyf4mpvPcxe/dUaIMMbesV8ZXbZURF+TCM1I3H3pW09VWpORbxY//JnqGxNzBQ3RV46PRROHuAFyor+75ATcbEico44WoxMPSOJZqxPjaFMHZ5+MTUz19jiqT8DEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Hook queue_spb_evacuate() into __rmqueue_claim() so that whenever a
non-movable allocation is about to claim a pageblock from an empty or
clean superpageblock as a fallback (i.e. cat_search[c] is not
SB_SEARCH_PREFERRED), a deferred spb_evacuate_for_order() is scheduled
on the zone's pgdat workqueue.

The current allocation still proceeds and taints the clean SPB this
time, but the deferred evacuation creates free pageblocks inside
existing tainted SPBs so the next caller hitting the same trigger can
claim from the tainted pool instead of tainting another clean SPB.

Movable allocations are excluded because their preferred category is
SB_CLEAN; falling back from clean to tainted does not taint anything
new and so does not need the hint.

The trigger is gated by single-flight, throttle, and tainted-pool
precheck inside queue_spb_evacuate(), so it is safe to fire from this
hot path without storming the workqueue.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  18 ++++
 mm/page_alloc.c        | 189 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 206 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 765e1c5dc365..195a80e2f0ee 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1139,6 +1139,22 @@ struct zone {
 	unsigned int		compact_considered;
 	unsigned int		compact_defer_shift;
 	int			compact_order_failed;
+
+	/*
+	 * Atomic-context SPB evacuation deferral state.
+	 *
+	 * spb_evac_in_flight: bitmap indexed by
+	 *   migratetype * NR_PAGE_ORDERS + order, set on enqueue and
+	 *   cleared by the worker after spb_evacuate_for_order returns.
+	 *   Provides single-flight gating per (migratetype, order).
+	 *
+	 * spb_evac_last: jiffies of the last enqueue per migratetype,
+	 *   used as a 10ms throttle to prevent wakeup storms from
+	 *   concurrent atomic allocations.
+	 */
+	DECLARE_BITMAP(spb_evac_in_flight,
+		       MIGRATE_PCPTYPES * NR_PAGE_ORDERS);
+	unsigned long		spb_evac_last[MIGRATE_PCPTYPES];
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
@@ -1552,6 +1568,8 @@ typedef struct pglist_data {
 	struct task_struct *kcompactd;
 	bool proactive_compact_trigger;
 	struct workqueue_struct *evacuate_wq;
+	struct llist_head spb_evac_pending;
+	struct irq_work spb_evac_irq_work;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ceb1284a63ed..f0fdfe8c9a45 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -788,6 +788,8 @@ static struct page *spb_try_alloc_contig(struct zone *zone,
 					gfp_t gfp_mask);
 static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 				  int migratetype);
+static void queue_spb_evacuate(struct zone *zone, unsigned int order,
+			       int migratetype);
 #else
 static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
 static inline bool spb_needs_defrag(struct superpageblock *sb) { return false; }
@@ -802,6 +804,8 @@ static inline bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 {
 	return false;
 }
+static inline void queue_spb_evacuate(struct zone *zone, unsigned int order,
+				      int migratetype) {}
 #endif
 
 static void spb_update_list(struct superpageblock *sb)
@@ -3784,6 +3788,18 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 			if (!page)
 				continue;
 
+			/*
+			 * About to claim from an empty or clean superpageblock
+			 * for a non-movable allocation -- this taints a fresh
+			 * SPB.  Defer an evacuation pass over the tainted pool
+			 * so subsequent allocations can reclaim freed
+			 * pageblocks instead of repeating this fallback.
+			 */
+			if (cat_search[c] != SB_SEARCH_PREFERRED &&
+			    start_migratetype != MIGRATE_MOVABLE)
+				queue_spb_evacuate(zone, order,
+						   start_migratetype);
+
 			page = try_to_claim_block(zone, page, current_order,
 						  order, start_migratetype,
 						  fallback_mt, alloc_flags,
@@ -8728,6 +8744,168 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn,
 		putback_movable_pages(&cc.migratepages);
 }
 
+/*
+ * Atomic-context SPB evacuation deferral.
+ *
+ * When an atomic allocation in __rmqueue_claim is about to taint a
+ * clean superpageblock because the tainted pool has no free page at
+ * the requested (order, migratetype), schedule a deferred call to
+ * spb_evacuate_for_order. That frees pageblocks inside tainted SPBs so
+ * subsequent allocations can claim them instead of tainting more clean
+ * SPBs.
+ *
+ * Two-step deferral mirrors the pageblock-evacuate path: irq_work to
+ * leave allocator lock context, then queue_work to reach process
+ * context where spb_evacuate_for_order can sleep in migrate_pages.
+ */
+
+struct spb_evac_request {
+	struct work_struct	work;
+	struct zone		*zone;
+	unsigned int		order;
+	int			migratetype;
+	struct llist_node	free_node;
+};
+
+#define NR_SPB_EVAC_REQUESTS	64
+static struct spb_evac_request spb_evac_pool[NR_SPB_EVAC_REQUESTS];
+static struct llist_head spb_evac_freelist;
+
+static struct spb_evac_request *spb_evac_request_alloc(void)
+{
+	struct llist_node *node;
+
+	node = llist_del_first(&spb_evac_freelist);
+	if (!node)
+		return NULL;
+	return container_of(node, struct spb_evac_request, free_node);
+}
+
+static void spb_evac_request_free(struct spb_evac_request *req)
+{
+	llist_add(&req->free_node, &spb_evac_freelist);
+}
+
+static void spb_evac_work_fn(struct work_struct *work)
+{
+	struct spb_evac_request *req = container_of(work,
+						    struct spb_evac_request,
+						    work);
+	struct zone *zone = req->zone;
+	unsigned int order = req->order;
+	int mt = req->migratetype;
+
+	spb_evacuate_for_order(zone, order, mt);
+
+	/*
+	 * Clearing the in-flight bit lets a future caller hitting the
+	 * same (mt, order) re-enqueue evacuation.  Ordering between this
+	 * worker's SPB state changes and the future caller's
+	 * tainted_pool_has_free walk is provided by zone->lock taken
+	 * inside spb_evacuate_for_order and by the future caller.
+	 */
+	clear_bit(mt * NR_PAGE_ORDERS + order, zone->spb_evac_in_flight);
+	spb_evac_request_free(req);
+}
+
+static void spb_evac_irq_work_fn(struct irq_work *work)
+{
+	pg_data_t *pgdat = container_of(work, pg_data_t,
+					spb_evac_irq_work);
+	struct llist_node *pending;
+	struct spb_evac_request *req, *next;
+
+	if (!pgdat->evacuate_wq)
+		return;
+
+	pending = llist_del_all(&pgdat->spb_evac_pending);
+	llist_for_each_entry_safe(req, next, pending, free_node) {
+		INIT_WORK(&req->work, spb_evac_work_fn);
+		queue_work(pgdat->evacuate_wq, &req->work);
+	}
+}
+
+/*
+ * Walk tainted SPBs to check whether any has a free page at the given
+ * order and migratetype.  When this returns true, a clean-SPB claim is
+ * not pool depletion but a try_to_claim_block over-rejection: skip the
+ * deferred evacuation since it cannot help.
+ */
+static bool tainted_pool_has_free(struct zone *zone, unsigned int order,
+				  int migratetype)
+{
+	struct superpageblock *sb;
+	int full;
+
+	lockdep_assert_held(&zone->lock);
+
+	for (full = 0; full < __NR_SB_FULLNESS; full++) {
+		list_for_each_entry(sb, &zone->spb_lists[SB_TAINTED][full],
+				    list) {
+			struct free_area *fa = &sb->free_area[order];
+
+			if (fa->nr_free &&
+			    !list_empty(&fa->free_list[migratetype]))
+				return true;
+		}
+	}
+	return false;
+}
+
+/**
+ * queue_spb_evacuate - schedule deferred SPB evacuation from atomic context
+ * @zone: zone that just failed to find a free page in the tainted pool
+ * @order: requested allocation order
+ * @migratetype: requested migratetype (UNMOVABLE or RECLAIMABLE only)
+ *
+ * Caller must hold zone->lock; the tainted-pool walk asserts it.
+ *
+ * Single-flight gated per (zone, migratetype, order) and throttled to
+ * one enqueue per 10ms per (zone, migratetype).  Pool exhaustion
+ * silently drops the request; the next caller hitting the same trigger
+ * will retry.
+ */
+static void queue_spb_evacuate(struct zone *zone, unsigned int order,
+			       int migratetype)
+{
+	pg_data_t *pgdat = zone->zone_pgdat;
+	struct spb_evac_request *req;
+	unsigned int bit;
+
+	lockdep_assert_held(&zone->lock);
+
+	if (!pgdat->spb_evac_irq_work.func)
+		return;
+	if (order >= NR_PAGE_ORDERS || migratetype >= MIGRATE_PCPTYPES)
+		return;
+
+	if (time_before(jiffies,
+			zone->spb_evac_last[migratetype] + HZ / 100))
+		return;
+
+	bit = migratetype * NR_PAGE_ORDERS + order;
+	if (test_and_set_bit(bit, zone->spb_evac_in_flight))
+		return;
+
+	if (tainted_pool_has_free(zone, order, migratetype)) {
+		clear_bit(bit, zone->spb_evac_in_flight);
+		return;
+	}
+
+	req = spb_evac_request_alloc();
+	if (!req) {
+		clear_bit(bit, zone->spb_evac_in_flight);
+		return;
+	}
+
+	zone->spb_evac_last[migratetype] = jiffies;
+	req->zone = zone;
+	req->order = order;
+	req->migratetype = migratetype;
+	llist_add(&req->free_node, &pgdat->spb_evac_pending);
+	irq_work_queue(&pgdat->spb_evac_irq_work);
+}
+
 /*
  * Background superpageblock defragmentation.
  *
@@ -9202,7 +9380,12 @@ static void spb_maybe_start_defrag(struct superpageblock *sb)
 
 static int __init pageblock_evacuate_init(void)
 {
-	int nid;
+	int nid, i;
+
+	/* Initialize the global freelist of SPB evacuate requests */
+	init_llist_head(&spb_evac_freelist);
+	for (i = 0; i < NR_SPB_EVAC_REQUESTS; i++)
+		llist_add(&spb_evac_pool[i].free_node, &spb_evac_freelist);
 
 	/* Create a per-pgdat workqueue */
 	for_each_online_node(nid) {
@@ -9217,6 +9400,10 @@ static int __init pageblock_evacuate_init(void)
 			continue;
 		}
 
+		init_llist_head(&pgdat->spb_evac_pending);
+		init_irq_work(&pgdat->spb_evac_irq_work,
+			      spb_evac_irq_work_fn);
+
 		/* Initialize per-superpageblock defrag work structs */
 		for (z = 0; z < MAX_NR_ZONES; z++) {
 			struct zone *zone = &pgdat->node_zones[z];
-- 
2.52.0


