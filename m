Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3398BCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1B86B00AD; Wed, 20 May 2026 11:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9B66B00AE; Wed, 20 May 2026 11:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232A86B00AF; Wed, 20 May 2026 11:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3C26B00AD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC2C51C0CB0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:56 +0000 (UTC)
X-FDA: 84788110512.25.C8BD9A6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06868C0015
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IK62loQP;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWY/9Z0pSPkko20mW+Mqac0ySxLdrDURge4Q5L7V2go=;
	b=vLhTsep34R1h0UKlkF3e7ym+UZhb7H04wuJbvv/TgZpIfSLembFTFI59/URnpcNXNbXnCp
	cR05sSbE0KS95p1DXZzQlHx+PLXRwbWJ6pGQsSUsCladTKEyFv4r9Px3gNwGEufLIA2tel
	9LmonhN8M0plv635bkgsrhciQDD1X1c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IK62loQP;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289255; a=rsa-sha256;
	cv=none;
	b=0+VwNcvdGEzBU76tweHgcg2i2I24FqDXIRdmZG017XBJrHUWADldQK3I1qIn27SttoRi9C
	lDJL/UREZ3K0hJ0JBK/bWYv4TzlxHoYpMQW10mITG8gO2Pl27eHwCxCX/XHy44vfwbA5Li
	ESMZsdF+cGDvg9YyrJ6M9kf+mSGMHlc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nWY/9Z0pSPkko20mW+Mqac0ySxLdrDURge4Q5L7V2go=; b=IK62loQP49oPfNwokflVkxXfOo
	mElq46Ss0KHVp/j+YQT1L+D0WvdjTPcvsyR9coYN87gyH41otH1v+Pvdo6P7427D9//64R0+OeYd/
	vWY+ldU5pW+x1Cop4cRuC8zoN06N4FUCTIA1grRMwzQ7gZJupKaOE+judn8e7o1ss2LGN/c1svI5L
	7iOom7rrMiLtvuJvj8WG2aNd640hC/fRKju32RjICED7+pu31J9uGFy98XbBkZ+wXiaUb897CKZUu
	QkDAzdkxAo2SdpnbUDR/GPqWFzb1koiqHdVMS3pIDjFl8YlTnk2ynetBMHZT58OLwONQyGhueYRlP
	3TuaQwvQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3SC6;
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
Subject: [RFC PATCH 28/40] mm: page_alloc: drive slab shrink from SPB anti-fragmentation pressure
Date: Wed, 20 May 2026 10:59:34 -0400
Message-ID: <20260520150018.2491267-29-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06868C0015
X-Stat-Signature: 836d73xstgb9b1hmjigi1a8156x3toko
X-HE-Tag: 1779289254-831394
X-HE-Meta: U2FsdGVkX1/gX1CE1cH1+VwWBLHVQyWDy5QBIIsfAIzAb5BfUT2T6FMjcBLg5jSa76kTJIDNs2rFDLtjF+IlXQqrUihfP5S9hvA1bRyb6cAdh3WVkQ7fbIgdfb9zB3vBkUZLGFwYJ8HPRRFB5QVeFmuoKAq4GlvqOPFIiD0w1Wzpyig5ptYg2Y8+FTY04pV4Lu0J+YAIs/cpYgwJrzhxmfzEKVZJvatuh1kjtYMH0UAufnOpVVr7ixmb5gPuvm4Gl2vIP1VYWDZPwXyx11qutIv8ItOOFCjCdvVP3gWpIAOLVE/Utidj7+4QonYVFIVrQQSO/2OFmQX/UBBONfyJNdeTztcSw6nJiF25nDCaDHIeRplcn6sY3x78WSkMeJDRXjTuU4+FN96chlj3XfSyNHkci6GuugIKaAIrOkbFVbV3wBTq0GifimQ6C+qUhSufYT5NpJFZcXd5SDXcyIjh9GS9obWsh4Ypnw/BGyqMNS9WS98lHVBURLzetVJe9jgwvSc8YDNOnEEzsP6zKG6H2ax8DSTezgPKmQdO49Tl7lqQOsv/6BEWSJYEJIPeSWX2V+5BhG0eO5SPZbxY+QpC1B5uZMpcPdW85es/cw3DKfv5NZQiBbKl3H7m19xyAP6SuSBw1qbCKodR+mH+VUEjihINuXA0/r9rC+m/wSaEqjQ7/HesbqqU3wCKl+MueS4g1HQsuJA61VXPIRhtopRWhbQkFT+N9WUXyvph1Zd2Od1rHC/GAY6MZ8jdAAop6XrJ1TsOp4vIKg6EsEygZy1IiB2gbfwgSk1Hf/pjKlBWRbT8tfy9Xx5+5yKBho8v58zy/IVq7i8RjNWMRNe76kdYdZMJ48O77SscVnNt6beZFBC0T6qowN5okuhiUCoL8JKXUWy+G40lQ1oE1lkJU5GI0B2TQXACSWYPZvXX1SJNGU1JtqsnTufpUP+J80/wTk7d7RCwsn8nm6JNqUpDIPJ
 sCnrftbr
 +8DIzfcOZkrtKfrWrkQfwN6VPGYEHqBsEcna65GApdDOL9/cSbm3u3GO1IKbq28YkN3Prpv5MPNhAg1Vl2BTv/ZeSmuWz3BjsTcfOTKm1QLbuKpc73p50rhCwU4YUGjP/l2Hhb+lgGbjaE0uR/VctfqHIFXqifPpvBpcOGlIpTj1iD7H1htQpHCI2Eg4OQe/bc4D0ZOwZoNzJHsr1liIes2XGdr5Lj7n0MU4EG3k2RmDMwVecAxyB2SAVt1/Qr+sb+Wct7ikPzGnj+aUHCFkzL7VWDOSNTgWTd9KKsnSzz/WBKgF6RMGJWmE0YjQbQX/XW9GR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GFP_KERNEL slab callers (dentry/inode/page-table caches) have no
"cheap fallback" the ALLOC_HIGHORDER_OPTIONAL refusal gate can use to
return NULL, and reach __rmqueue_claim/_steal whenever the tainted-SPB
pool runs out of headroom.  Without an external pressure release valve,
sustained slab growth eventually drains the tainted pool, every clean
SPB starts absorbing one taint, and fragmentation grows until equilibrium
at a much higher tainted-SPB count than the workload memory-footprint
warrants.

The pageblock-evacuation worker (spb_evacuate_for_order /
queue_spb_evacuate) already runs from these pressure points, but it can
only consolidate movable pages out of tainted SPBs.  Slab content
stranded in tainted SPBs blocks free pageblocks from re-coalescing and
forces new taints when movable supply runs out.

Add a parallel slab-shrink mechanism that mirrors the evacuation
infrastructure: a per-pgdat irq_work that bridges from allocator-lock
context out to a workqueue, a pool of request descriptors, and
queue_spb_slab_shrink() with queue_work()-native single-flight semantics
(queue_work() absorbs per-alloc bursts at near-zero cost via test-and-set
on WORK_STRUCT_PENDING_BIT).  The worker calls shrink_slab() with the
zone's nid, walking node-local shrinkers from DEF_PRIORITY toward 0
until either no shrinker reports progress or a pageblock-sized batch of
objects has been freed.

Trigger sites:

  * Demand, alongside the existing queue_spb_evacuate calls:
    __rmqueue_smallest pre-Pass-3 when spb_tainted_walk reports
    saw_below_reserve; __rmqueue_claim when a non-movable claim is
    about to taint a clean SPB.

  * Supply, unconditional at the end of spb_evacuate_for_order:
    keeps headroom for the next burst when MOV supply runs out.

  * Proactive high-water, on the success paths of Pass 1
    SB_TAINTED / Pass 2 / 2b / 2c / 2d: when a non-movable
    allocation consumes from a tainted SPB whose nr_free_pages
    has fallen below spb_tainted_reserve worth of pages.
    Demand-trigger placement alone is too late -- tainted SPBs
    can keep absorbing pressure for tens of minutes before
    exhaustion, by which point the only option left is to taint
    a fresh SPB.

The proactive high-water and end-of-spb_evacuate_for_order triggers
share a helper, spb_react_to_tainted_alloc(), with the per-SPB defrag
worker -- since both pressure-release mechanisms apply to the same
tainted-SPB state, the helper invokes spb_maybe_start_defrag() alongside
queue_spb_slab_shrink() under the same high-water gate. The defrag
worker's own cooldown gate inside spb_needs_defrag() makes this cheap to
call from every relevant success path.

A last-chance defrag walk runs just before the Pass 3 fall-through to a
clean SPB: list_for_each_entry over zone->spb_lists[SB_TAINTED] calling
spb_maybe_start_defrag() on each. This catches tainted SPBs that are
stuck in expired-cooldown state because no allocator activity recently
touched them (spb_update_list, the routine event-driven trigger, only
fires on bucket transitions).

Per-pgdat init (init_pgdat_spb_state) wires irq_work and work_struct
fields at boot via the pageblock_evacuate_init late_initcall and
lazily on the memory-hotplug path; without it the trigger sites'
`.func != NULL` gate would leave the mechanism inert system-wide.

shrink_slab is location-agnostic -- it doesn't know about SPBs -- but
since slab pages live in already-tainted SPBs (that is where they were
allocated), the freed pages naturally land back in the tainted pool,
restoring headroom without spreading the taint to clean SPBs.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h        |  12 ++
 include/linux/vm_event_item.h |   5 +
 mm/internal.h                 |   2 +
 mm/mm_init.c                  |   8 +
 mm/page_alloc.c               | 281 +++++++++++++++++++++++++++++++---
 mm/vmstat.c                   |   2 +
 6 files changed, 290 insertions(+), 20 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index db719335b32a..46eb5012d18b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1670,6 +1670,18 @@ typedef struct pglist_data {
 	struct workqueue_struct *evacuate_wq;
 	struct llist_head spb_evac_pending;
 	struct irq_work spb_evac_irq_work;
+
+	/*
+	 * SPB-driven slab reclaim: single work item per pgdat (shrink_slab
+	 * is node-scoped, so one work in-flight per node is the max).
+	 * queue_work() gives us single-flight semantics for free -- fresh
+	 * triggers no-op while a pass is in progress.
+	 *
+	 * irq_work defers the queue_work() call outside the allocator's
+	 * lock context to avoid pool->lock vs hrtimer_bases.lock inversion.
+	 */
+	struct irq_work spb_slab_shrink_irq_work;
+	struct work_struct spb_slab_shrink_work;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 4a8513d5fc3e..87c82f9d7fb7 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -81,6 +81,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 					 * a clean SPB clean when a tainted SPB
 					 * still has free pageblocks
 					 */
+		SPB_SLAB_SHRINK_QUEUED,	/*
+					 * queued a deferred slab shrink to
+					 * reclaim space inside tainted SPBs
+					 */
+		SPB_SLAB_SHRINK_RAN,	/* slab shrink worker ran a pass */
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
 		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
diff --git a/mm/internal.h b/mm/internal.h
index f52575202a96..9854d76ebf36 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1103,10 +1103,12 @@ void init_cma_reserved_pageblock(struct page *page);
 
 #ifdef CONFIG_COMPACTION
 void init_superpageblock_defrag(struct superpageblock *sb);
+void init_pgdat_spb_state(pg_data_t *pgdat);
 void superpageblock_clear_has_movable(struct zone *zone, struct page *page);
 void superpageblock_set_has_movable(struct zone *zone, struct page *page);
 #else
 static inline void init_superpageblock_defrag(struct superpageblock *sb) {}
+static inline void init_pgdat_spb_state(pg_data_t *pgdat) {}
 static inline void superpageblock_clear_has_movable(struct zone *zone,
 						    struct page *page) {}
 static inline void superpageblock_set_has_movable(struct zone *zone,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ee5dcd89e31e..af71ef8393c6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1695,6 +1695,14 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	if (!zone->superpageblocks)
 		init_zone_spb_lists(zone);
 
+	/*
+	 * Lazily initialize pgdat-level SPB state (evacuate_wq, evac llist,
+	 * shrink work). pageblock_evacuate_init() is a late_initcall and
+	 * only walks for_each_online_node, so a node that gets its first
+	 * memory via hotplug needs this here. Idempotent.
+	 */
+	init_pgdat_spb_state(zone->zone_pgdat);
+
 	alloc_size = new_nr_sbs * sizeof(struct superpageblock);
 	new_sbs = kvmalloc_node(alloc_size, GFP_KERNEL | __GFP_ZERO, nid);
 	if (!new_sbs) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ce8cd99dd283..6dadfe9d59d9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -743,6 +743,7 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 				  int migratetype);
 static void queue_spb_evacuate(struct zone *zone, unsigned int order,
 			       int migratetype);
+static void queue_spb_slab_shrink(struct zone *zone);
 #else
 static inline void spb_maybe_start_defrag(struct superpageblock *sb) {}
 static inline bool spb_needs_defrag(struct superpageblock *sb) { return false; }
@@ -753,6 +754,7 @@ static inline bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 }
 static inline void queue_spb_evacuate(struct zone *zone, unsigned int order,
 				      int migratetype) {}
+static inline void queue_spb_slab_shrink(struct zone *zone) {}
 #endif
 
 #ifdef CONFIG_CONTIG_ALLOC
@@ -2706,6 +2708,47 @@ static inline u16 spb_tainted_reserve(const struct superpageblock *sb)
 	return max_t(u16, SPB_TAINTED_RESERVE_MIN, sb->total_pageblocks / 32);
 }
 
+/*
+ * High-water threshold for proactively kicking the slab shrinker. When a
+ * non-movable allocation consumes from a tainted SPB whose total free
+ * pages have fallen below spb_tainted_reserve worth of pages, queue a
+ * shrink so we start freeing slab memory before the SPB is exhausted.
+ *
+ * Compared against nr_free_pages rather than nr_free (whole pageblocks):
+ * sub-pageblock allocations and fragmented free space don't move the
+ * pageblock count, but they do consume the SPB's freeable capacity, and
+ * we can't assume slab reclaim will produce whole pageblocks either.
+ */
+static inline bool spb_below_shrink_high_water(const struct superpageblock *sb)
+{
+	return sb->nr_free_pages <
+		(unsigned long)spb_tainted_reserve(sb) * pageblock_nr_pages;
+}
+
+/*
+ * spb_react_to_tainted_alloc - kick reclaim machinery on a tainted-SPB alloc.
+ *
+ * Called from each PASS_1/2/2B/2C/2D success path after a successful
+ * allocation against a tainted SPB. If the SPB is below its shrink
+ * high-water mark, queue the SPB-driven slab shrink and try to start
+ * the per-SPB defrag worker. Both have their own cooldown gates inside,
+ * so this is cheap to call on every such allocation.
+ *
+ * Skips quickly when the SPB is not tainted (e.g. movable allocation
+ * landing on a clean SPB) or when the high-water mark hasn't been
+ * crossed.
+ */
+static inline void spb_react_to_tainted_alloc(struct superpageblock *sb,
+					      struct zone *zone)
+{
+	if (spb_get_category(sb) != SB_TAINTED)
+		return;
+	if (!spb_below_shrink_high_water(sb))
+		return;
+	queue_spb_slab_shrink(zone);
+	spb_maybe_start_defrag(sb);
+}
+
 /*
  * On systems with many superpageblocks, we can afford to "write off"
  * tainted superpageblocks by aggressively packing unmovable/reclaimable
@@ -2891,6 +2934,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				page_del_and_expand(zone, page,
 					order, current_order,
 					migratetype);
+				if (cat == SB_TAINTED)
+					spb_react_to_tainted_alloc(sb, zone);
 				trace_mm_page_alloc_zone_locked(
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
@@ -2910,6 +2955,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page_del_and_expand(zone, page,
 						order, current_order,
 						migratetype);
+					if (cat == SB_TAINTED)
+						spb_react_to_tainted_alloc(sb, zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -2955,6 +3002,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page = claim_whole_block(zone, page,
 						current_order, order,
 						migratetype, MIGRATE_MOVABLE);
+					spb_react_to_tainted_alloc(sb, zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -2992,6 +3040,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						0, true);
 					if (!page)
 						continue;
+					spb_react_to_tainted_alloc(sb, zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -3075,6 +3124,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							opposite_mt);
 						__spb_set_has_type(page,
 							migratetype);
+						spb_react_to_tainted_alloc(sb, zone);
 						trace_mm_page_alloc_zone_locked(
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
@@ -3146,6 +3196,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							MIGRATE_MOVABLE);
 						__spb_set_has_type(page,
 							migratetype);
+						spb_react_to_tainted_alloc(sb, zone);
 						trace_mm_page_alloc_zone_locked(
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
@@ -3163,9 +3214,34 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	 * showed that some tainted SPB is below its reserve threshold of
 	 * free pageblocks, kick deferred evacuation so future allocations
 	 * have a movable-evicted home in an already-tainted SPB.
+	 *
+	 * Queue slab shrink alongside evacuation: even when movable evac
+	 * succeeds, shrinking slab in parallel keeps headroom available
+	 * for the next burst, when the movable supply may have run out.
 	 */
-	if (walk && walk->saw_below_reserve)
+	if (walk && walk->saw_below_reserve) {
 		queue_spb_evacuate(zone, order, migratetype);
+		queue_spb_slab_shrink(zone);
+	}
+
+	/*
+	 * Last-chance defrag trigger before tainting a fresh clean SPB.
+	 * Walk the tainted-SPB list and try to wake the per-SPB defrag
+	 * worker on each. Catches SPBs that are stuck in expired-cooldown
+	 * state because no allocator activity has touched them recently
+	 * (the routine event-driven trigger from spb_update_list only
+	 * fires on bucket transitions, not on every alloc). Once the
+	 * cooldown has expired, spb_maybe_start_defrag() will requeue
+	 * work; otherwise the gate inside spb_needs_defrag() no-ops
+	 * cheaply. Bounded by nr_tainted_spbs and only runs when we are
+	 * already on the slow path of fragmenting the clean pool.
+	 */
+	for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+		list_for_each_entry(sb,
+			&zone->spb_lists[SB_TAINTED][full], list) {
+			spb_maybe_start_defrag(sb);
+		}
+	}
 
 	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
@@ -4001,12 +4077,17 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 			 * for a non-movable allocation -- this taints a fresh
 			 * SPB.  Defer an evacuation pass over the tainted pool
 			 * so subsequent allocations can reclaim freed
-			 * pageblocks instead of repeating this fallback.
+			 * pageblocks instead of repeating this fallback. Also
+			 * kick a slab shrink so the tainted pool gets fresh
+			 * headroom (movable evac alone can't free pages held
+			 * by slab).
 			 */
 			if (cat_search[c] != SB_SEARCH_PREFERRED &&
-			    start_migratetype != MIGRATE_MOVABLE)
+			    start_migratetype != MIGRATE_MOVABLE) {
 				queue_spb_evacuate(zone, order,
 						   start_migratetype);
+				queue_spb_slab_shrink(zone);
+			}
 
 			page = try_to_claim_block(zone, page, current_order,
 						  order, start_migratetype,
@@ -9301,6 +9382,133 @@ static void queue_spb_evacuate(struct zone *zone, unsigned int order,
 	irq_work_queue(&pgdat->spb_evac_irq_work);
 }
 
+/*
+ * SPB-driven slab reclaim.
+ *
+ * When tainted SPBs run low on free pageblocks under sustained
+ * non-movable pressure (slab inode/dentry/page-table caches), the
+ * pageblock-evacuation worker can only consolidate *movable* pages out
+ * of tainted SPBs. Non-movable slab content stays put, so once the
+ * movable supply is drained the only way to recover headroom in a
+ * tainted SPB is to shrink the slab caches whose pages live there.
+ *
+ * shrink_slab() is node-scoped, so one work item per pgdat is enough:
+ * a single embedded work_struct. queue_work() returns false if the work
+ * is already queued/running, so we get single-flight for free -- fresh
+ * triggers no-op until the in-flight pass completes.
+ *
+ * shrink_slab() itself is location-agnostic -- it walks all registered
+ * shrinkers and frees objects whose backing pages may live in any
+ * zone or SPB. That is fine here because any slab page reclaimed
+ * frees space the next allocation can reuse without tainting a fresh
+ * SPB. We pass the pgdat's nid so node-aware shrinkers prefer caches
+ * local to the pressured node.
+ */
+
+/*
+ * Per-invocation budget: walk shrinkers from DEF_PRIORITY (scan 1/4096
+ * of each cache) down toward 0 (full scan), stopping when shrinkers
+ * report no more progress or we have freed a pageblock-sized chunk.
+ * The trigger frequency is what controls overall reclaim rate; this
+ * loop just bounds latency per worker run.
+ */
+#define SPB_SLAB_SHRINK_TARGET_OBJS	(pageblock_nr_pages * 4UL)
+
+static void spb_slab_shrink_work_fn(struct work_struct *work)
+{
+	pg_data_t *pgdat = container_of(work, pg_data_t,
+					spb_slab_shrink_work);
+	int nid = pgdat->node_id;
+	unsigned long freed = 0;
+	int prio = DEF_PRIORITY;
+
+	count_vm_event(SPB_SLAB_SHRINK_RAN);
+
+	while (freed < SPB_SLAB_SHRINK_TARGET_OBJS && prio >= 0) {
+		unsigned long delta = 0;
+		struct mem_cgroup *memcg;
+
+		/*
+		 * Walk the memcg hierarchy starting at the root, the same
+		 * pattern shrink_one_node uses for global slab reclaim.
+		 * Some cgroups may not be present on the node that is
+		 * being shrunk, but many allocators will use any memory.
+		 */
+		memcg = mem_cgroup_iter(NULL, NULL, NULL);
+		do {
+			delta += shrink_slab(GFP_KERNEL, nid, memcg, prio);
+		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+
+		if (!delta)
+			break;
+		freed += delta;
+		/*
+		 * Increase aggressiveness each round; DEF_PRIORITY scans
+		 * a small slice of each cache, prio 0 scans the whole
+		 * thing. Most workloads find enough at one or two
+		 * iterations below DEF_PRIORITY.
+		 */
+		prio--;
+	}
+}
+
+/**
+ * spb_slab_shrink_irq_work_fn - IRQ work callback to safely queue slab shrink
+ * @work: the irq_work embedded in pg_data_t
+ *
+ * queue_work() can create a lock ordering issue when called from inside
+ * the page allocator under hrtimer_bases.lock (via debug_objects_fill_pool
+ * allocations during hrtimer re-enqueue), because pool->lock depends on
+ * hrtimer_bases.lock through the scheduler path. Use irq_work to defer
+ * the queue_work() call to a safe context, matching the pattern used by
+ * spb_evac_irq_work_fn and spb_defrag_irq_work_fn.
+ */
+static void spb_slab_shrink_irq_work_fn(struct irq_work *work)
+{
+	pg_data_t *pgdat = container_of(work, struct pglist_data,
+					spb_slab_shrink_irq_work);
+
+	if (pgdat->evacuate_wq &&
+	    queue_work(pgdat->evacuate_wq, &pgdat->spb_slab_shrink_work))
+		count_vm_event(SPB_SLAB_SHRINK_QUEUED);
+}
+
+/**
+ * queue_spb_slab_shrink - schedule deferred slab shrink for SPB pressure
+ * @zone: zone whose tainted-SPB pool is running low
+ *
+ * Single-flight via queue_work(): if the work is already queued or
+ * running, it returns false and we no-op. There is no time-based
+ * throttle -- the rate at which fresh shrink runs can fire is bounded
+ * by how fast the worker completes (one full pass freeing up to
+ * SPB_SLAB_SHRINK_TARGET_OBJS objects).
+ *
+ * Callable from any context: the irq_work deferral ensures that
+ * queue_work() runs outside the allocator's lock context, avoiding
+ * pool->lock vs hrtimer_bases.lock ordering issues.
+ *
+ * Pairs with queue_spb_evacuate: evacuation moves movable pages out
+ * of tainted SPBs to free up whole pageblocks; this shrinks slab to
+ * free up the remaining (non-movable) pages. We queue both because
+ * even when movable evacuation succeeds, shrinking slab in parallel
+ * keeps headroom available for the next burst, when movable supply
+ * may have run out.
+ */
+static void queue_spb_slab_shrink(struct zone *zone)
+{
+	pg_data_t *pgdat = zone->zone_pgdat;
+
+	if (!pgdat->spb_slab_shrink_irq_work.func)
+		return;
+
+	/* Defer queue_work() to irq context to keep pool->lock acquisition
+	 * out of the allocator's lock context (avoids pool->lock vs
+	 * hrtimer_bases.lock inversion via debug_objects_fill_pool).
+	 * No throttle here: queue_work()'s built-in single-flight semantics
+	 * absorb per-alloc bursts at near-zero cost. */
+	irq_work_queue(&pgdat->spb_slab_shrink_irq_work);
+}
+
 /*
  * Background superpageblock defragmentation.
  *
@@ -9562,6 +9770,42 @@ static void spb_maybe_start_defrag(struct superpageblock *sb)
 	}
 }
 
+/**
+ * init_pgdat_spb_state - allocate evacuate_wq and initialize SPB work structs
+ * @pgdat: node being initialized
+ *
+ * Idempotent: returns immediately if pgdat->evacuate_wq is already set
+ * (a previous call succeeded). Best-effort: if alloc_workqueue() fails,
+ * pgdat->evacuate_wq stays NULL and SPB defrag/shrink for this node is
+ * disabled (the runtime callers all check for NULL evacuate_wq).
+ *
+ * Called from pageblock_evacuate_init() at boot for every online node, and
+ * lazily from resize_zone_superpageblocks() when memory hotplug brings up
+ * a node whose pgdat-level SPB state was never initialized (because the
+ * node was empty at boot -- late_initcall only walks for_each_online_node).
+ */
+void init_pgdat_spb_state(pg_data_t *pgdat)
+{
+	char name[32];
+
+	if (pgdat->evacuate_wq)
+		return;
+
+	snprintf(name, sizeof(name), "kevacuate/%d", pgdat->node_id);
+	pgdat->evacuate_wq = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+	if (!pgdat->evacuate_wq) {
+		pr_warn("Failed to create evacuate workqueue for node %d\n",
+			pgdat->node_id);
+		return;
+	}
+
+	init_llist_head(&pgdat->spb_evac_pending);
+	init_irq_work(&pgdat->spb_evac_irq_work, spb_evac_irq_work_fn);
+	init_irq_work(&pgdat->spb_slab_shrink_irq_work,
+		      spb_slab_shrink_irq_work_fn);
+	INIT_WORK(&pgdat->spb_slab_shrink_work, spb_slab_shrink_work_fn);
+}
+
 static int __init pageblock_evacuate_init(void)
 {
 	int nid, i;
@@ -9571,22 +9815,14 @@ static int __init pageblock_evacuate_init(void)
 	for (i = 0; i < NR_SPB_EVAC_REQUESTS; i++)
 		llist_add(&spb_evac_pool[i].free_node, &spb_evac_freelist);
 
-	/* Create a per-pgdat workqueue */
+	/* Initialize per-pgdat SPB workqueue and work structs */
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		char name[32];
 		int z;
 
-		snprintf(name, sizeof(name), "kevacuate/%d", nid);
-		pgdat->evacuate_wq = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
-		if (!pgdat->evacuate_wq) {
-			pr_warn("Failed to create evacuate workqueue for node %d\n", nid);
+		init_pgdat_spb_state(pgdat);
+		if (!pgdat->evacuate_wq)
 			continue;
-		}
-
-		init_llist_head(&pgdat->spb_evac_pending);
-		init_irq_work(&pgdat->spb_evac_irq_work,
-			      spb_evac_irq_work_fn);
 
 		/* Initialize per-superpageblock defrag work structs */
 		for (z = 0; z < MAX_NR_ZONES; z++) {
@@ -9596,12 +9832,8 @@ static int __init pageblock_evacuate_init(void)
 			if (!zone->superpageblocks)
 				continue;
 
-			for (j = 0; j < zone->nr_superpageblocks; j++) {
-				INIT_WORK(&zone->superpageblocks[j].defrag_work,
-					  spb_defrag_work_fn);
-				init_irq_work(&zone->superpageblocks[j].defrag_irq_work,
-					      spb_defrag_irq_work_fn);
-			}
+			for (j = 0; j < zone->nr_superpageblocks; j++)
+				init_superpageblock_defrag(&zone->superpageblocks[j]);
 		}
 	}
 
@@ -9798,6 +10030,15 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 			did_evacuate = true;
 	}
 
+	/*
+	 * Always kick a slab shrink after an evacuation pass -- even when
+	 * MOV evacuation succeeded. Slab content stranded inside tainted
+	 * SPBs can only be freed by shrinking the cache; doing it now keeps
+	 * headroom available for the next burst, when the MOV supply may
+	 * have run out and evac alone would have nothing to do.
+	 */
+	queue_spb_slab_shrink(zone);
+
 	return did_evacuate;
 }
 #endif /* CONFIG_COMPACTION */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 0be1b969f493..5fd9a150d0a5 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1389,6 +1389,8 @@ const char * const vmstat_text[] = {
 	[I(CMA_ALLOC_FAIL)]			= "cma_alloc_fail",
 #endif
 	[I(SPB_HIGHORDER_REFUSED)]		= "spb_highorder_refused",
+	[I(SPB_SLAB_SHRINK_QUEUED)]		= "spb_slab_shrink_queued",
+	[I(SPB_SLAB_SHRINK_RAN)]		= "spb_slab_shrink_ran",
 	[I(UNEVICTABLE_PGCULLED)]		= "unevictable_pgs_culled",
 	[I(UNEVICTABLE_PGSCANNED)]		= "unevictable_pgs_scanned",
 	[I(UNEVICTABLE_PGRESCUED)]		= "unevictable_pgs_rescued",
-- 
2.54.0


