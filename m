Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E41CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F4C6B008A; Wed, 20 May 2026 11:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0616B00BE; Wed, 20 May 2026 11:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2824B6B008A; Wed, 20 May 2026 11:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10A8D6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1F481C025E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:03 +0000 (UTC)
X-FDA: 84788110806.03.C1906A8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E3B61C002C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hOpQGzKJ;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V73fGF4L85rQyR6G/fi/9PDMTPCkAr5GDPqZo9IXQjg=;
	b=Ho7QMRbjC58pSsB5eMolKZrman4O2053EsCeKzZQBHxhU685lnsmJxzqLEPyIunhkzogzR
	D8KeqkZR7SWNvxLE+5PQqdMRwOUIbA2wWPWk4k6sEtkk4H+a/lZBN98se+rZ2Fw/aWMcEL
	oeEVbX1By3hRjij/s9XqeDQimHz3ydw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289261; a=rsa-sha256;
	cv=none;
	b=DCuv0DDC+eKO+cPNlczgZO9BylyKqi7s3yZFZ9R90FeUnuXfyz9FpwcicVNSn5MRx8RZUQ
	Gqa2P5S/OdLuPGSaI75t3JcgA5YbJVOJUO+wU6IEzZpbNpjv0JBeH6IXKTAwXsHpAhtYop
	rV+O6YYROZVdSCcM5m/IHpDvKxpNPOA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hOpQGzKJ;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=V73fGF4L85rQyR6G/fi/9PDMTPCkAr5GDPqZo9IXQjg=; b=hOpQGzKJeYN1l7DrULohp+i2G3
	4msBWr6gPA6KazkCeDd1ojsNgMK/ljBfcImp9tctWWMEHLCfWjIqjV18ouZhKskUSQuJGjeV4LFRa
	QMvLTL4NJyZgbx/18bnSdxNnxfdNPyl8yvyrd3t+pZjvhnuwB6S1edYd6Esf5HSlPYsiKvMuDgDPv
	xoCnC/Qq+MuLBQKvK+BzECiUUhnF9E6ZjFEDxdEqDFJVXpV/fATxij7xqpLd7pRLuXM2stEBBt2XF
	IV+07L2v3lcp07smH9SSNWh1h8GhTLmCAZo/FN21M0/+K3vFirc22Lut0frUhRZLOOIvdL7P4ePNI
	rDYqqyAg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3mye;
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
Subject: [RFC PATCH 31/40] mm: page_alloc: per-(zone, order, mt) PASS_1 hint cache
Date: Wed, 20 May 2026 10:59:37 -0400
Message-ID: <20260520150018.2491267-32-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E3B61C002C
X-Stat-Signature: g7athjrj871hsjm678ihenrk81xanee3
X-Rspam-User: 
X-HE-Tag: 1779289260-408294
X-HE-Meta: U2FsdGVkX18URjqEpItN0P2zSAxfJsWmoWfbZqOljQNokFzNjg7bb32BxNYGlynez1FSKYwAH5Y9t+iEqx9OUpWkWllpJYrdESPbul/Vq1X0YrITCZwueoARwKZ/ChhvUZ1lbhAcWK17QG1uxyEU134PRNDemqNGFqD1Ws0+ERTji6Um+ndZfGesfczeD5euyZE8gGP+G3p6hUbYePkcKynI/fPiHDg6O4kZlaGMYOSxOltJ5MZCp6s4SXHmtU0I6c4M1a8iwju6xgWXzgy/FOUImu9rqPAgm5MNjeA5bi/239lNtizioP7cO089e+C5nqWT9Y98YwErn46KIKZkqIj9BivCJxURlHqvADB0m5HTE8Z3GOWrvpHCgxvWjgp1qmBhVWteRPnkUz54lrx5GOOPmOpfCmyPf3vQws+GDshyE8ORna3sgLwjLNgcQ8n/63zeWPLXKdVKBnlO85WArK+dbijLT8vmeqqsRF42thAF2LstqJ1i9487C81H3KxzSn1HiOOEt2Vxf/ICzzMP2xQXtxEKymcunNWnokx+5ybkuQpQQzbFNFXAtiv0w97G8GDCBFB/JaR1aznKM7FxWNHAF3GHwnqoJT9SY+gjgoCUmEyVinEOKzVWp8HUNB3RJd6zPkWjsEB2Qg2MlcMllFeUGuJ4BVD5fXFI3Dbf3NtKBSMhL1JLvf8lwCgsHROytN08AnlJdPM++eLoD2x2PlQUR75mdkYIMmIJ59SXxyl7jZd24KW4/Fll4jWCa4DDqOtY4QhU5EoGQh0sNR0Uoy7oWo9HMP1EnomLn37vpMQXBCPCbnDNSR6s03gJIAnsXsqJuWDM5pKqG1+3fRRYlMrmRcVChY8P+eBZ9ixpvFfgNWQZoUuXfGyrKnN8qXkDd9FSfk/VpP6Mfm/lw83si7n58k1DyMvC6v7Rp0cdyYyMgN5PHD8iLMupKq25hhMVyA+NVkWNpcolcAZaJGT
 dJcGvGuN
 6/I19w65cSvn1YM1Vxy7l96FLJI0iTvgTJa2bgMBaaGm3kvVZSYFjBBkI3ewoZR3lIg8WW8Njkn0Tgi3QAwEQ+qz9DP/aEVj1mfV2JyPb2nehDKX+6cO4ujlvNiy1jVIhlaoyjstHmBOf2SIFak6ucAjlol1OIXxc9w4I5o4o/iwPmeZotRGOYRZ89obBySjrC1kOPUvPV4guuoJPHf17NfCLsqxA7XAPZtU3N6wllxZP6/KlOrFI089QchzGibcPrr80y/xElUX9AHVyeYeb0xGgpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PASS_1 of __rmqueue_smallest walks &zone->spb_lists[cat][full]
linearly. Under steady workload on a 250 GB test system, the median
walk depth was ~50 SPBs and 20-57% of allocations visited 100+ SPBs.

Cache the SPB that last satisfied a PASS_1 alloc for each
(zone, order, migratetype) tuple, in two layers:

  - per-zone hint (zone->sb_hint[order][mt]) -- visible to all CPUs,
    serialized by zone->lock.
  - per-CPU hint indexed by zone_idx -- cache-hot, contention-free.
    Each slot stores (zone *, sb *) because zone_idx is per-pgdat
    (not globally unique on NUMA); the zone-pointer check on read
    prevents a cross-node SPB from being handed back to the wrong
    zone's accounting.

Stale hints are harmless: try_alloc_from_sb_pass1() returns NULL and
the standard list walk runs as before. On PASS_1 success both hints
are refreshed. spb_invalidate_warm_hints() clears both arrays from
resize_zone_superpageblocks() under zone->lock to prevent UAF across
memory hotplug-add.

Hint hits show up in tracepoint:kmem:spb_alloc_walk as the [0, 5)
bucket because n_spbs_visited stays 0; no new tracepoint needed.
Skipped for migratetype >= MIGRATE_PCPTYPES (HIGHATOMIC/CMA/ISOLATE
are already cheap or rare).

Measurement on the same test system with this commit applied:

  median walk depth:        ~50 SPBs   ->   ~5
  tail (>=100 SPB visits):  20-57%     ->   0.4%
  hint hit rate (n=0):                 ->   99%

Memory cost: ~320 B per zone + ~2.6 KB per CPU
(MAX_NR_ZONES * NR_PAGE_ORDERS * MIGRATE_PCPTYPES * sizeof(slot)).

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  11 +++
 mm/internal.h          |   2 +
 mm/mm_init.c           |   8 ++
 mm/page_alloc.c        | 173 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 194 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 46eb5012d18b..c9c248d5b14e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1111,6 +1111,17 @@ struct zone {
 	struct list_head	spb_isolated;	/* fully isolated (1GB contig alloc) */
 	struct list_head	spb_lists[__NR_SB_CATEGORIES][__NR_SB_FULLNESS];
 
+	/*
+	 * PASS_1 fast-path hint: most-recent SPB that satisfied a
+	 * (order, mt) PASS_1 allocation. Stale hints are harmless -- the hint
+	 * try-alloc just falls through to the standard list walk on miss.
+	 * Sized for [0..NR_PAGE_ORDERS) x PCPTYPES; HIGHATOMIC/CMA/ISOLATE
+	 * skip the hint (already cheap or rare). Invalidated by
+	 * spb_invalidate_warm_hints() when the SPB array is resized
+	 * (memory hotplug add).
+	 */
+	struct superpageblock	*sb_hint[NR_PAGE_ORDERS][MIGRATE_PCPTYPES];
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
diff --git a/mm/internal.h b/mm/internal.h
index 9854d76ebf36..3a847dcfb03f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1119,6 +1119,8 @@ static inline void superpageblock_set_has_movable(struct zone *zone,
 void resize_zone_superpageblocks(struct zone *zone);
 #endif
 
+void spb_invalidate_warm_hints(struct zone *zone);
+
 struct cma;
 
 #ifdef CONFIG_CMA
diff --git a/mm/mm_init.c b/mm/mm_init.c
index af71ef8393c6..19a338ed1bdf 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1837,6 +1837,14 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	zone->superpageblock_base_pfn = new_sb_base;
 	zone->spb_kvmalloced = true;
 
+	/*
+	 * Invalidate PASS_1 hints under zone->lock so that no
+	 * concurrent allocator (also entering __rmqueue_smallest under
+	 * zone->lock) can dereference an old SPB pointer that is about
+	 * to be freed below.
+	 */
+	spb_invalidate_warm_hints(zone);
+
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6dadfe9d59d9..116d9cc0a493 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2854,6 +2854,109 @@ struct spb_tainted_walk {
 	bool saw_below_reserve;	/* tainted SPB has nr_free <= spb_tainted_reserve */
 };
 
+/*
+ * PASS_1 fast-path hint: most-recent SPB this CPU successfully
+ * allocated from for a given (zone, order, migratetype). Combined with
+ * the per-zone zone->sb_hint[][], this lets PASS_1 skip the linear walk
+ * of spb_lists[cat][full] in the common case. Stale hints are
+ * harmless -- the try-alloc just falls through to the standard list walk
+ * on miss.
+ *
+ * The slot stores both the zone pointer and the SPB pointer because
+ * zone_idx(zone) is per-pgdat (not globally unique on NUMA), so two
+ * nodes' ZONE_NORMAL share the same array index. The zone-pointer check
+ * on read prevents a cross-node SPB from being handed back to the wrong
+ * zone (which would corrupt per-zone NR_FREE_PAGES accounting).
+ */
+struct spb_warm_hint_slot {
+	struct zone		*zone;
+	struct superpageblock	*sb;
+};
+struct spb_warm_hints {
+	struct spb_warm_hint_slot slot[MAX_NR_ZONES][NR_PAGE_ORDERS][MIGRATE_PCPTYPES];
+};
+static DEFINE_PER_CPU(struct spb_warm_hints, spb_warm_hints);
+
+/**
+ * spb_invalidate_warm_hints - drop all cached hints into @zone
+ * @zone: zone whose SPB array is about to change
+ *
+ * Called from memory hotplug paths that resize zone->superpageblocks
+ * (and therefore invalidate every SPB pointer for @zone). Must be
+ * called with zone->lock held; the lock serializes against any CPU
+ * doing a hint read inside __rmqueue_smallest (also under zone->lock),
+ * so callers see either pre-invalidation state (old SPB pointers,
+ * still-valid old array) or post-invalidation state (NULL slots) --
+ * never a half-state with stale pointers into a freed array.
+ */
+void spb_invalidate_warm_hints(struct zone *zone)
+{
+	enum zone_type zidx = zone_idx(zone);
+	int cpu, order, mt;
+
+	lockdep_assert_held(&zone->lock);
+
+	memset(zone->sb_hint, 0, sizeof(zone->sb_hint));
+
+	for_each_possible_cpu(cpu) {
+		struct spb_warm_hints *h = per_cpu_ptr(&spb_warm_hints, cpu);
+
+		for (order = 0; order < NR_PAGE_ORDERS; order++) {
+			for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+				if (h->slot[zidx][order][mt].zone != zone)
+					continue;
+				h->slot[zidx][order][mt].zone = NULL;
+				h->slot[zidx][order][mt].sb = NULL;
+			}
+		}
+	}
+}
+
+/*
+ * Try to allocate from a single SPB using PASS_1 semantics:
+ * whole pageblock first (PCP-buddy friendly), then sub-pageblock.
+ * Returns the page on success, NULL on miss. Caller is responsible
+ * for hint updates and shrinker queueing.
+ */
+static struct page *try_alloc_from_sb_pass1(struct zone *zone,
+					    struct superpageblock *sb,
+					    unsigned int order,
+					    int migratetype)
+{
+	unsigned int current_order;
+	struct free_area *area;
+	struct page *page;
+
+	if (!sb->nr_free_pages)
+		return NULL;
+
+	for (current_order = max(order, pageblock_order);
+	     current_order < NR_PAGE_ORDERS;
+	     ++current_order) {
+		area = &sb->free_area[current_order];
+		page = get_page_from_free_area(area, migratetype);
+		if (!page)
+			continue;
+		page_del_and_expand(zone, page, order,
+				    current_order, migratetype);
+		return page;
+	}
+	if (order < pageblock_order) {
+		for (current_order = order;
+		     current_order < pageblock_order;
+		     ++current_order) {
+			area = &sb->free_area[current_order];
+			page = get_page_from_free_area(area, migratetype);
+			if (!page)
+				continue;
+			page_del_and_expand(zone, page, order,
+					    current_order, migratetype);
+			return page;
+		}
+	}
+	return NULL;
+}
+
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				int migratetype, struct spb_tainted_walk *walk)
@@ -2875,6 +2978,58 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	};
 	int movable = (migratetype == MIGRATE_MOVABLE) ? 1 : 0;
 
+	/*
+	 * PASS_1 fast-path: try per-CPU then per-zone hint SPB before the
+	 * linear list walk. The hint stores the SPB that last satisfied a
+	 * PASS_1 alloc for this (zone, order, migratetype). On hit, we
+	 * skip the entire spb_lists walk. Skip for HIGHATOMIC/CMA/ISOLATE
+	 * -- those paths are already cheap (atomic-NORETRY skip) or rare.
+	 */
+	if (migratetype < MIGRATE_PCPTYPES) {
+		enum zone_type zidx = zone_idx(zone);
+		struct superpageblock *cpu_hint = NULL, *zone_hint;
+		struct spb_warm_hint_slot *slot;
+
+		slot = this_cpu_ptr(
+			&spb_warm_hints.slot[zidx][order][migratetype]);
+		/*
+		 * Validate slot->zone == zone: zone_idx is per-pgdat, so
+		 * on NUMA the same slot index is shared by every node's
+		 * zone of this type. Without this check, a hint written
+		 * from one node would be returned to allocations on
+		 * another node and corrupt the wrong zone's accounting.
+		 */
+		if (slot->zone == zone)
+			cpu_hint = slot->sb;
+		if (cpu_hint) {
+			page = try_alloc_from_sb_pass1(zone, cpu_hint,
+						       order, migratetype);
+			if (page) {
+				spb_react_to_tainted_alloc(cpu_hint, zone);
+				trace_mm_page_alloc_zone_locked(page, order,
+				    migratetype,
+				    pcp_allowed_order(order) &&
+				    migratetype < MIGRATE_PCPTYPES);
+				return page;
+			}
+		}
+		zone_hint = zone->sb_hint[order][migratetype];
+		if (zone_hint && zone_hint != cpu_hint) {
+			page = try_alloc_from_sb_pass1(zone, zone_hint,
+						       order, migratetype);
+			if (page) {
+				spb_react_to_tainted_alloc(zone_hint, zone);
+				slot->zone = zone;
+				slot->sb = zone_hint;
+				trace_mm_page_alloc_zone_locked(page, order,
+				    migratetype,
+				    pcp_allowed_order(order) &&
+				    migratetype < MIGRATE_PCPTYPES);
+				return page;
+			}
+		}
+	}
+
 	/*
 	 * Search per-superpageblock free lists for pages of the requested
 	 * migratetype, walking superpageblocks from fullest to emptiest
@@ -2940,6 +3095,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
 					migratetype < MIGRATE_PCPTYPES);
+				if (migratetype < MIGRATE_PCPTYPES) {
+					struct spb_warm_hint_slot *slot;
+
+					zone->sb_hint[order][migratetype] = sb;
+					slot = this_cpu_ptr(&spb_warm_hints.slot
+					    [zone_idx(zone)][order][migratetype]);
+					slot->zone = zone;
+					slot->sb = sb;
+				}
 				return page;
 			}
 			/* Then try sub-pageblock (no PCP buddy) */
@@ -2961,6 +3125,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					if (migratetype < MIGRATE_PCPTYPES) {
+						struct spb_warm_hint_slot *slot;
+
+						zone->sb_hint[order][migratetype] = sb;
+						slot = this_cpu_ptr(&spb_warm_hints.slot
+						    [zone_idx(zone)][order][migratetype]);
+						slot->zone = zone;
+						slot->sb = sb;
+					}
 					return page;
 				}
 			}
-- 
2.54.0


