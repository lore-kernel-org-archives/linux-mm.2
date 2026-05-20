Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D96FFCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A40A6B00A7; Wed, 20 May 2026 11:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456216B00A8; Wed, 20 May 2026 11:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A766B00A9; Wed, 20 May 2026 11:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 247B06B00A7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA8761C020D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:51 +0000 (UTC)
X-FDA: 84788110302.27.85FF10E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2159240025
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=d76rjulT;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vullDLo/ir7bMpSdhQSH6gjcQ40j69FGPX0V2CPSNvM=;
	b=MHmyohtkZNW2W/Sw+lMbFS6oCybsK5PaD6cXD4BYJSBEVwW8wOvAE28oFD1ZMOiqRZ0Ygb
	hv4dMkfc1uhVyrk0tUrwuZxFtnWi/Hqvh3qOXPHwScL0aXnNVcUyC0agI4f1G8MAgLIS61
	b0pkAPsfgwqNuBGd7vDOz1A5d2gDwBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289250; a=rsa-sha256;
	cv=none;
	b=M/qbVJJE+at4RqICYyeox3SQ9sX1Q1pux7eDs6hoU/4c+UOKH1DiPjfkTTX0VHekO6piNi
	JwQVIhrjJ5cVu02GAqC7071HSpjxvSDLCMwhJGlIrzW65WdhjS8KOKeIzf/zU60wrEYJ22
	/Ht4H4EYaiCSD0cIvWEQypvWnc2ifoM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=d76rjulT;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vullDLo/ir7bMpSdhQSH6gjcQ40j69FGPX0V2CPSNvM=; b=d76rjulTzoVkULTv1OxRtTQ/MH
	6zAClVWWDPrRzpHsfUrw2PY/9PbgP3FCgbKptt5OaFuS1/epwjMwAN2unLyQPuuYawV8iiimc8iEu
	Zmq+8+NSvNWcnJnX1gH65XCm18nJAf6cCxuWxJyTJ7pfX9INUMzDTOWsixLwC/hK8ujDKQCsL+XPU
	+TfyUHgHWYDmkhyn8NeYAyB5jukI9PXnD7flRj+Hm9z0VRsVvuDDyO9hCvgkKb6OhkqLdR6FuJsyi
	0Z2GpE3qenZSfIcyUcJl+Wi5CLZOQA0nUx7m7W2WFQNnpmUeJ5dqW71lezIvcN3fabj4D0hw2Hlju
	dQbki8aw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-35zc;
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
Subject: [RFC PATCH 25/40] mm: trigger deferred SPB evac when atomic allocs would taint a clean SPB
Date: Wed, 20 May 2026 10:59:31 -0400
Message-ID: <20260520150018.2491267-26-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2159240025
X-Rspamd-Server: rspam04
X-Stat-Signature: pkxirf9cz4ttsnkgxipewdon6auhujax
X-HE-Tag: 1779289250-714641
X-HE-Meta: U2FsdGVkX18RE7lonQX7dRVOn64l8A0sPtcp9mnvql7NfmezkZCuhGlNb+PpnkxXNcaWyZA0LwUOELFmrpDGLArEUKYco03t/HbMm67tZ5uFkfNAF+D52pJy6phr8o4hQjI+o0hPIkvKMvr8my0DDDUdFnGSrsYN3NCtMqNBHb9CRdfdiP1c6EUX4axRjXZxnTpCQcmeStRHxYUzsn4Ke4pliaG48FHRO81bEL16jUxpn/O8hO8UrN4tGV6xNXz3s2IbQojIlxwobyXZ2qlM47ECLdGOIeyXCsQGnI4/PrkHKIHxcyOg0yeUXaO1zHuH5m3s59qAdp5UBgwDSaSTIrsatehHqnkhlYC9/j1HM8i+/8nGGkc4nCMn5uwfS1hOoYHpi5yujrr2OJ8qE+gYlr+IE3Db/HU8LpWmY9coQb8ZwYCiTlhAp9dzIGC/eOd3vwSIFTZTr1wHk39n+z4bHWOlY3xeMGU+BGVztamOR3lMPIsxperZQXsiirG2GSKzSONLzbY+Bb2TxRqYQfnet0+odFBcNTBVlyQibyx0E7kw2mM1StmsVEbCUjcmSW5KDhoxV3aHbgC/CaHoNjpRHz/8pzlR/yYaSuL2x7N12JCxj05sKqTC7PCDsoGCiLrKuAHfjW61aZEugI4OG0Ai2y0bsBDvlY1rRDEO1zqfR9UrcbmshTEgH2UhtvxKMvBxCOfUD4OjhTwsYAGAqvV1Q41pKeqkuviyaoPZi9kkuhkKa3EOXYtq3kFkerSeBRmJSejuMz0QWpiAr/+qSCbZUBMrNI+vSvY0ROH5PxmCg+zXNk00xuAmeJlWrO/8qRFGivf219fGb0vhVxljKkT5pbVeGUd2fBHuuFHF5ftlpQCD2JNfAfjRGSs+lU7VWEMNISyJVnKhzs67DYGFS8tEFBZ8u8Gy6aXa3cGtj3Bgu7T8H+mosbsxnLzA1d9/J7kA7IDC7ECGIc44ZoZ3ylI
 EVz1XpCW
 9U1RiPv3e8FarRjwlfUhEQez7WnCaypovJUB3ii5PDOF7nd4iSHlIBBYxA8m+3o8okt8wFy63fYuHUFSRP/U/0XPO5VVD4eJtTiVUyBY4An8egKSrycQ5Tjw5cSpO+UcrmZya+D8Gggo/R1fStaGQWhh50gq83tgzJDd/6n4nFSPr1yZ85vY2NMIL39qSQvugjzMPi2Kf/vTJnPjotUAmvwc9DYnezMKutViP9BS6fu56xDTwU6XtFpwRO9rK4uejfFA9V4MkZ/naLtagRF8iiN2mMQ46qWWACNGdvFIGB3jIewiBrL9vZnBx+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/page_alloc.c        | 198 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 215 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a0124c170ac0..db719335b32a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1236,6 +1236,22 @@ struct zone {
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
@@ -1652,6 +1668,8 @@ typedef struct pglist_data {
 	struct task_struct *kcompactd;
 	bool proactive_compact_trigger;
 	struct workqueue_struct *evacuate_wq;
+	struct llist_head spb_evac_pending;
+	struct irq_work spb_evac_irq_work;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 988cf6f27938..dfbfed056bbb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -741,6 +741,8 @@ static void spb_maybe_start_defrag(struct superpageblock *sb);
 static bool spb_needs_defrag(struct superpageblock *sb);
 static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 				  int migratetype);
+static void queue_spb_evacuate(struct zone *zone, unsigned int order,
+			       int migratetype);
 #else
 static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
 static inline bool spb_needs_defrag(struct superpageblock *sb) { return false; }
@@ -749,6 +751,8 @@ static inline bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 {
 	return false;
 }
+static inline void queue_spb_evacuate(struct zone *zone, unsigned int order,
+				      int migratetype) {}
 #endif
 
 #ifdef CONFIG_CONTIG_ALLOC
@@ -3800,6 +3804,18 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
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
@@ -8855,6 +8871,177 @@ static void evacuate_pageblock(struct zone *zone, unsigned long start_pfn,
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
+/*
+ * llist_del_first() requires single-consumer or external locking.
+ * queue_spb_evacuate() runs under zone->lock, but different zones
+ * hold different locks, so consumers race.  spb_evac_request_free()
+ * uses llist_add which is multi-producer-safe and stays lockless.
+ */
+static DEFINE_SPINLOCK(spb_evac_freelist_lock);
+
+static struct spb_evac_request *spb_evac_request_alloc(void)
+{
+	struct llist_node *node;
+
+	spin_lock(&spb_evac_freelist_lock);
+	node = llist_del_first(&spb_evac_freelist);
+	spin_unlock(&spb_evac_freelist_lock);
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
@@ -9118,7 +9305,12 @@ static void spb_maybe_start_defrag(struct superpageblock *sb)
 
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
@@ -9133,6 +9325,10 @@ static int __init pageblock_evacuate_init(void)
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
2.54.0


