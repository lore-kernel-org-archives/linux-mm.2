Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B20CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234256B009D; Wed, 20 May 2026 11:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CC96B00C7; Wed, 20 May 2026 11:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7136B00C8; Wed, 20 May 2026 11:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC4016B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81834140381
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:13 +0000 (UTC)
X-FDA: 84788111226.07.D54E8EC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5DBF21C0028
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=F6LDqZW9;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHYjlMPvi7UC1C03e8wV8+JVskmYtHQ3HvKwnbe2S4c=;
	b=y4U+I5PZnTfHNKjAxgycVnOhCfB+UrmFhD7236vU6H/A0hxnZ3zv0N4XYdug4bSzltHupb
	5iWWnv7CxoYo/5l46bdovG1q5RN/SrcsWYIylWEJyGyxyr8LYQ5QUigqlcuERur+ZVXYRS
	ivj4fNmy8lAC3rRfF4VHkF/Bn4smTbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289271; a=rsa-sha256;
	cv=none;
	b=BUto0JnaH9RriQ5OFRIGAvX5AgIoBQqzRxNvyXAEBvM4Lcso5sRLUEWuIvMNQ8JkPYpTzm
	GjxQcWrvvnClAnHScDf7p9Y2hN4MLcfsRit5j0W4Ajd7il3T98l0JIHaXfnc0Po7bv7+qB
	uqUoEDp8/cg05QcrOxj2Srts213Wp0U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=F6LDqZW9;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lHYjlMPvi7UC1C03e8wV8+JVskmYtHQ3HvKwnbe2S4c=; b=F6LDqZW9WKo8AuZ0Wx1FP19NLq
	Q56bn3lHB1LJE/3kmY0eaKmrmA8d1PBmDGu7mfSPgHDDg5mQsoIKGz2Tod2Aek0vig4SKrPfHNibb
	SQ6/kumer9nIezo9qpmY30bb3th1p9L6kw00mjEJJFVVMzPCAofmL+EYHFwifyUTTO+3txRWAOoOb
	/iOan3D04hh6ZxHoGytO+sIcm0YsHhWTSuPIcsLV4tIvRc/4IXyTkwcp8qAkGnPMNwq6xSmsUoo4X
	C8A+0w99CMfHdOGFmO5hwiLUmFu6slzSyg4Y6hIKXeXAHkGMI4irR+QrNGXIGZZXR6yxT08j7EAG0
	NqkKLCzQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1eWy;
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
Subject: [RFC PATCH 14/40] mm: page_alloc: add per-superpageblock free lists
Date: Wed, 20 May 2026 10:59:20 -0400
Message-ID: <20260520150018.2491267-15-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DBF21C0028
X-Rspamd-Server: rspam04
X-Stat-Signature: 9oiwz73neq9tpgem9e84gsdew5ra7zat
X-HE-Tag: 1779289271-82697
X-HE-Meta: U2FsdGVkX19K9MgNJ5icP7fEP6RVHID71g1lwcIYiukl37nS/cZMVbBTiTz0Lsr38yalIEzzHmpGJr1KlYqAXUWxEDAFXJz2Fa83I9BvPLH5SwhDU/XDDS2pitXSddx41GwuDcc+t353kgJfOGVmqjhodG7AqMWjnGrAUn1ZNH+ZEfxCWInWZz6z783JPB7fVUTrFW3EqywI8VxF4vfing4i6+DxbfKNkHApUyvBHqguBH1uVvGriTK0ovRb/E9YkjctGuMK5Hq3a0kDmOpAjh9lrCl9AP2odO40fM4lUYFkiZZQxme8G2kaA6igEQDjJPsRsGKoOyqXIl9uOjmK9NWsaWgfwJVQXOwjqNRokJ8JLusJIj/4OGfMI9yF9agbABE6T6AhqNDJYKoqQkUvdGXmkY331JZyyjA62HY7aYU/YNGgmVu7GiaPUjawod+YMygnc6veOwqWCTNSCngvV3hOLwGzBPPVJQA8uyLg7lU6uEO5+qYxkNKkKGOcRMp6ZVfsH8W8ZUlIW2hIUFutVvYYSvnLVA1pCcYvhJ15gxL2nlHYK5U/6rnbILvYQhAmpApwvt0B/RlW6chSMn3s1ke0MlKWtrcAcTKW4MKK5rEaxR18QCOxgem7ZqSCRtcBPs/Ntsq8hZdC9hrw6a+5nCA3xsWQQUiXawmthgYB+b4nHTW/ykrgYzH8rDJPJnJKOl7r0+RBlEexKT/fZ8cKUqy55ztPDTobKN+gBoX20I/rTJUnY5fW4w4nettZ8mTyeLhb6iorhHVlo+1dC7f+jfcxsggae1PfIYga6x2vm9WzBfnikqaqEMgTmRfxIZVJPq8//2+C3acp+h0UIHC+Dvd1vhVQQ6RLh8zf1ma6CbNHghSvB2tdsyYt6Zc1CkLa0h9lDGw36i2PMtHUJtqeY7etet5PPD02HZTiG06fM06UHDK2HCryBkFkabL4wBjIVMKJhUjoGWxQV4+7ZM6
 yuH70wvF
 4iAk2pL4M/acAbeAWE5zin23S64qbkvoIpAwPJQX06gPqSCEzZKwBFLLwvYhcgGGqMxWWEHsktjdgRzoGEHD/K4fcOVBh4k5IZljjFYoHfMNPsFxTnu923xp9cMEgIG6XpFpdX4JWjk+R58WABhGy9gxyOzgnSA7Ge6hn+UoR6VBVxlS5S0CdazHpJNs+keIXL0mWfNqKNIoNaiiJwiIvCx4cs0vYncKSTaO1wki5m5OYajVQ1Piq9WYS7OlICjsYlAPYOHmtLWLAkVvRBB30HKVQFa096JPvywB8fAnS5/qj0qS+l9FMmQJTNmjyeOaRUJTjYvRRtpxP+qH3S4aEW+5XP/j5xBiprgJbQMpgnGKVM2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Per-superpageblock free lists keep allocation steering effective at every
order: all pages belonging to a superpageblock are tracked on its own
free_area[NR_PAGE_ORDERS], not on the zone-level free_area.  This lets
__rmqueue_smallest target a specific SPB by category/fullness without
walking the whole zone.

Sub-pageblock-order frees route to the containing SPB's free list via
__free_one_page; whole-pageblock and higher orders likewise.  PCP refill,
buddy coalescing, and migratetype steering all consult the per-SPB
free_area.

Memory-hotplug correctness.  Once the resize loop in
resize_zone_superpageblocks() may be invoked on a previously-empty zone
(memoryless NUMA node receiving its first online memory, CXL hot-add
into a zone with no prior pages), two latent bugs surface:

  - The SPB list heads (zone->spb_empty and the spb_lists[cat][full]
    matrix) are initialized only by setup_superpageblocks(), which is
    __init and runs only at boot.  Hot-add into a previously-empty zone
    invokes init_one_superpageblock() with zero-initialized list_heads,
    and the inlined list_add_tail() NULL-derefs walking ->next->prev.
    Factor list-head init out of setup_superpageblocks() into
    init_zone_spb_lists(), call it from resize_zone_superpageblocks()
    on the first-time path (zone->superpageblocks == NULL); subsequent
    resizes skip it.

  - The resize loop copies struct superpageblock entries to a newly
    kvmalloc()'d array but does not fix up the embedded
    free_area[order].free_list[mt] list_heads.  Pages on those lists
    have buddy_list.prev/next pointing into the *old* array's list
    heads, so as soon as the swap takes effect, __rmqueue_smallest
    walks pointers into freed memory.  Extend the per-SPB list_replace
    pass to walk all NR_PAGE_ORDERS * MIGRATE_TYPES free lists too.

The same critical section that copies struct contents and fixes up
list heads must run under zone->lock to prevent a concurrent allocator
from observing partial state; take the lock around the
copy+fixup+swap.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  10 +
 mm/compaction.c        |  36 +-
 mm/internal.h          |  10 +
 mm/mm_init.c           | 146 +++++--
 mm/page_alloc.c        | 853 ++++++++++++++++++++++++++++++++---------
 mm/vmstat.c            |  66 ++--
 6 files changed, 883 insertions(+), 238 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b8ada3d13a34..85846bb041a8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1021,9 +1021,19 @@ struct superpageblock {
 	u16			nr_reserved;	/* holes, firmware, etc. */
 	u16			total_pageblocks; /* zone-clipped total */
 
+	/* Total free pages across all per-superpageblock free lists */
+	unsigned long		nr_free_pages;
+
 	/* For organizing superpageblocks by fullness category */
 	struct list_head	list;
 
+	/*
+	 * Per-superpageblock free lists for all buddy orders.
+	 * All pages belonging to this superpageblock are tracked here,
+	 * keeping allocation steering effective at every order.
+	 */
+	struct free_area	free_area[NR_PAGE_ORDERS];
+
 	/* Identity */
 	unsigned long		start_pfn;
 	struct zone		*zone;
diff --git a/mm/compaction.c b/mm/compaction.c
index e8ca651e2b07..6d2aefdbc0c8 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -979,6 +979,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
 				}
+				/*
+				 * Skipped a movable page; clearing
+				 * PB_has_movable here would orphan SPB type
+				 * counters (debugfs invariant 1).
+				 */
+				movable_skipped = true;
 				goto isolate_fail;
 			}
 			/* for alloc_contig case */
@@ -1058,6 +1064,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
 				}
+				/*
+				 * Skipped a movable compound page; clearing
+				 * PB_has_movable here would orphan SPB type
+				 * counters (debugfs invariant 1).
+				 */
+				movable_skipped = true;
 				goto isolate_fail;
 			}
 		}
@@ -1083,6 +1095,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				movable_skipped = true;
 			}
 
+			/*
+			 * Non-LRU non-movable_ops page: still occupies the
+			 * pageblock, so clearing PB_has_movable here would
+			 * orphan SPB type counters (debugfs invariant 1).
+			 */
+			movable_skipped = true;
 			goto isolate_fail;
 		}
 
@@ -1320,12 +1338,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 * isolated (pinned, writeback, dirty, etc.), leave the
 		 * flag set so a future migration attempt can try again.
 		 */
-		if (!nr_isolated && !movable_skipped && valid_page &&
-		    get_pfnblock_bit(valid_page, pageblock_start_pfn(start_pfn),
-				     PB_has_movable))
-			clear_pfnblock_bit(valid_page,
-					   pageblock_start_pfn(start_pfn),
-					   PB_has_movable);
+		if (!nr_isolated && !movable_skipped && valid_page)
+			superpageblock_clear_has_movable(cc->zone,
+							valid_page);
 	}
 
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
@@ -1873,6 +1888,15 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		prep_compound_page(&dst->page, order);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
+
+	/*
+	 * Compaction isolates free pages via __isolate_free_page, which
+	 * bypasses page_del_and_expand and its PB_has_* tracking.  The
+	 * destination will hold movable pages after migration, so mark
+	 * PB_has_movable on the destination pageblock now.
+	 */
+	superpageblock_set_has_movable(cc->zone, &dst->page);
+
 	return page_rmappable_folio(&dst->page);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 6a089bc4aa09..7091dc557f1f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1101,6 +1101,16 @@ void init_cma_reserved_pageblock(struct page *page);
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
+#ifdef CONFIG_COMPACTION
+void superpageblock_clear_has_movable(struct zone *zone, struct page *page);
+void superpageblock_set_has_movable(struct zone *zone, struct page *page);
+#else
+static inline void superpageblock_clear_has_movable(struct zone *zone,
+						    struct page *page) {}
+static inline void superpageblock_set_has_movable(struct zone *zone,
+						  struct page *page) {}
+#endif
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 void resize_zone_superpageblocks(struct zone *zone);
 #endif
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2dc73d8a8d6c..92e5f396cbd7 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1523,16 +1523,27 @@ static void __meminit init_one_superpageblock(struct superpageblock *sb,
 	unsigned long sb_end = start_pfn + SUPERPAGEBLOCK_NR_PAGES;
 	unsigned long pb_start = max(start_pfn, zone_start);
 	unsigned long pb_end = min(sb_end, zone_end);
+	int order, t;
 	u16 actual_pbs;
 
 	sb->nr_unmovable = 0;
 	sb->nr_reclaimable = 0;
 	sb->nr_movable = 0;
 	sb->nr_free = 0;
+	sb->nr_free_pages = 0;
 	INIT_LIST_HEAD(&sb->list);
 	sb->start_pfn = start_pfn;
 	sb->zone = zone;
 
+	/* Initialize per-superpageblock free areas */
+	for (order = 0; order < NR_PAGE_ORDERS; order++) {
+		struct free_area *area = &sb->free_area[order];
+
+		for (t = 0; t < MIGRATE_TYPES; t++)
+			INIT_LIST_HEAD(&area->free_list[t]);
+		area->nr_free = 0;
+	}
+
 	/*
 	 * Start with all pageblock slots as reserved.
 	 * init_pageblock_migratetype() will decrement nr_reserved and
@@ -1561,6 +1572,22 @@ static void __meminit init_one_superpageblock(struct superpageblock *sb,
 	}
 }
 
+/*
+ * Initialize the per-zone SPB list heads. Called from boot
+ * (setup_superpageblocks) and from memory hotplug
+ * (resize_zone_superpageblocks) the first time SPBs are set up
+ * for a zone.
+ */
+static void __meminit init_zone_spb_lists(struct zone *zone)
+{
+	int cat, full;
+
+	INIT_LIST_HEAD(&zone->spb_empty);
+	for (cat = 0; cat < __NR_SB_CATEGORIES; cat++)
+		for (full = 0; full < __NR_SB_FULLNESS; full++)
+			INIT_LIST_HEAD(&zone->spb_lists[cat][full]);
+}
+
 static void __init setup_superpageblocks(struct zone *zone)
 {
 	unsigned long zone_start = zone->zone_start_pfn;
@@ -1568,17 +1595,22 @@ static void __init setup_superpageblocks(struct zone *zone)
 	unsigned long sb_base, nr_superpageblocks;
 	size_t alloc_size;
 	unsigned long i;
-	int cat, full;
 
 	zone->superpageblocks = NULL;
 	zone->nr_superpageblocks = 0;
 	zone->superpageblock_base_pfn = 0;
 
 	/* Fullness lists steer allocations to preferred superpageblocks */
-	INIT_LIST_HEAD(&zone->spb_empty);
-	for (cat = 0; cat < __NR_SB_CATEGORIES; cat++)
-		for (full = 0; full < __NR_SB_FULLNESS; full++)
-			INIT_LIST_HEAD(&zone->spb_lists[cat][full]);
+	init_zone_spb_lists(zone);
+
+	/*
+	 * Warn if pages have already been freed into this zone's
+	 * free_area before superpageblocks are set up -- those pages
+	 * would become stranded because __rmqueue_smallest only
+	 * searches per-superpageblock free lists.
+	 */
+	for (i = 0; i < NR_PAGE_ORDERS; i++)
+		WARN_ON_ONCE(zone->free_area[i].nr_free);
 
 	if (!zone->spanned_pages)
 		return;
@@ -1619,8 +1651,10 @@ static void __init setup_superpageblocks(struct zone *zone)
  * the full zone span, copies existing superpageblocks (fixing up list heads),
  * and initializes new superpageblocks for the added range.
  *
- * Must be called under mem_hotplug_lock (write).  No concurrent
- * allocations can occur since the hotplugged pages are not yet online.
+ * Must be called under mem_hotplug_lock (write).  The hot-added pages
+ * themselves are not yet online, but allocations on previously-online
+ * pages within the same zone can still race the superpageblock-array
+ * swap; the function takes zone->lock for that critical section.
  */
 void __meminit resize_zone_superpageblocks(struct zone *zone)
 {
@@ -1634,6 +1668,7 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	size_t alloc_size;
 	unsigned long i;
 	int nid = zone_to_nid(zone);
+	unsigned long flags;
 
 	if (!zone->spanned_pages)
 		return;
@@ -1648,6 +1683,18 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	    new_nr_sbs == zone->nr_superpageblocks)
 		return;
 
+	/*
+	 * First time superpageblocks are being set up for this zone
+	 * (memory hot-added to a previously-empty zone, e.g. CXL bringing
+	 * a memoryless node online): the SPB fullness/category list heads
+	 * are still zero-initialized from the zone struct allocation.
+	 * setup_superpageblocks() runs only at boot via __init, so do that
+	 * piece of init here for the hotplug path. Subsequent calls for
+	 * the same zone will skip this -- superpageblocks is non-NULL.
+	 */
+	if (!zone->superpageblocks)
+		init_zone_spb_lists(zone);
+
 	alloc_size = new_nr_sbs * sizeof(struct superpageblock);
 	new_sbs = kvmalloc_node(alloc_size, GFP_KERNEL | __GFP_ZERO, nid);
 	if (!new_sbs) {
@@ -1656,6 +1703,37 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
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
@@ -1669,39 +1747,39 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 		       zone->nr_superpageblocks * sizeof(struct superpageblock));
 
 		/*
-		 * Fix up list_head pointers that were self-referencing
-		 * (empty lists) or pointing into the old array.
+		 * Fix up all list_head pointers: both the SPB category list
+		 * and every free_area[order].free_list[migratetype]. Pages on
+		 * buddy free lists have buddy_list.prev/next pointing at the
+		 * old array's list heads -- those must be updated to point at
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
-
-		if (zone->superpageblocks) {
-			old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
-				     SUPERPAGEBLOCK_ORDER;
-			if (i >= old_offset &&
-			    i < old_offset + zone->nr_superpageblocks)
-				is_old = true;
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
@@ -1740,6 +1818,8 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	zone->superpageblock_base_pfn = new_sb_base;
 	zone->spb_kvmalloced = true;
 
+	spin_unlock_irqrestore(&zone->lock, flags);
+
 	/*
 	 * The boot-time array was allocated with memblock_alloc, which
 	 * is not individually freeable after boot.  Only kvfree arrays
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1b619304864a..b9c957fb4783 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -515,6 +515,140 @@ static void __spb_set_has_type(struct page *page, int migratetype)
 	}
 }
 
+/*
+ * __spb_clear_has_type - clear PB_has_* and decrement type counter
+ *
+ * Idempotent: only decrements the counter on the 1→0 bit transition.
+ */
+static void __spb_clear_has_type(struct page *page, int migratetype)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb = pfn_to_superpageblock(page_zone(page), pfn);
+	int bit;
+
+	if (!sb)
+		return;
+
+	bit = migratetype_to_has_bit(migratetype);
+	if (bit < 0)
+		return;
+
+	if (get_pfnblock_bit(page, pfn, bit)) {
+		clear_pfnblock_bit(page, pfn, bit);
+		switch (bit) {
+		case PB_has_unmovable:
+			if (sb->nr_unmovable)
+				sb->nr_unmovable--;
+			break;
+		case PB_has_reclaimable:
+			if (sb->nr_reclaimable)
+				sb->nr_reclaimable--;
+			break;
+		case PB_has_movable:
+			if (sb->nr_movable)
+				sb->nr_movable--;
+			break;
+		}
+	}
+}
+
+#ifdef CONFIG_COMPACTION
+/*
+ * spb_pageblock_has_free_movable_fragments - probe SPB free lists for movable
+ * @zone: zone containing @page
+ * @page: any page within the target pageblock
+ *
+ * Returns true if the SPB containing @page has any free MOVABLE pages on its
+ * per-order free lists at orders below pageblock_order whose PFN falls within
+ * the target pageblock. The compaction migrate scanner only sees in-use pages,
+ * so a pageblock can look "empty of movable" to the scanner while the SPB
+ * still owns small-order MOVABLE fragments inside it. Clearing PB_has_movable
+ * in that case would orphan those fragments from the SPB type accounting and
+ * trigger debugfs invariant 1 (sum_types undercount).
+ *
+ * Returns false (no fragments found) when the SPB lookup fails, which
+ * preserves the legacy clear-on-empty behavior for edge cases.
+ *
+ * Caller must hold zone->lock.
+ */
+static bool spb_pageblock_has_free_movable_fragments(struct zone *zone,
+						     struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long pb_start = pageblock_start_pfn(pfn);
+	unsigned long pb_end = pb_start + pageblock_nr_pages;
+	unsigned long frag_pfn;
+	struct superpageblock *sb;
+	struct list_head *list;
+	struct page *frag;
+	unsigned int order;
+
+	sb = pfn_to_superpageblock(zone, pfn);
+	if (!sb)
+		return false;
+
+	for (order = 0; order < pageblock_order; order++) {
+		list = &sb->free_area[order].free_list[MIGRATE_MOVABLE];
+		list_for_each_entry(frag, list, buddy_list) {
+			frag_pfn = page_to_pfn(frag);
+			if (frag_pfn >= pb_start && frag_pfn < pb_end)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * superpageblock_clear_has_movable - clear PB_has_movable with SPB counter update
+ * @page: page within the pageblock
+ *
+ * Called from compaction when a full pageblock scan determines no movable
+ * pages remain. Clears PB_has_movable and decrements the superpageblock's
+ * nr_movable counter atomically (under zone->lock).
+ *
+ * Without this, clearing PB_has_movable directly via clear_pfnblock_bit()
+ * would leave the SPB counter stale, causing nr_movable to grow unbounded
+ * as subsequent movable allocations re-set the bit and re-increment.
+ *
+ * The migrate scanner only inspects in-use pages, so it is blind to MOVABLE
+ * fragments below pageblock_order sitting on the SPB free lists. Probe those
+ * lists first; if any fragment of @page's pageblock is still tracked by the
+ * SPB, leave PB_has_movable set so the SPB type accounting stays consistent
+ * (debugfs invariant 1: unmov + recl + mov + free >= total - rsv).
+ */
+void superpageblock_clear_has_movable(struct zone *zone, struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	if (!spb_pageblock_has_free_movable_fragments(zone, page))
+		__spb_clear_has_type(page, MIGRATE_MOVABLE);
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+/**
+ * superpageblock_set_has_movable - set PB_has_movable with SPB counter update
+ * @zone: zone containing the page
+ * @page: page within the pageblock
+ *
+ * Called from compaction when a movable page is migrated into a pageblock.
+ * Compaction bypasses page_del_and_expand (which normally sets PB_has_*)
+ * by using __isolate_free_page + direct migration, so PB_has_movable must
+ * be set explicitly for the destination pageblock.
+ *
+ * Idempotent: only increments the counter on the 0→1 bit transition.
+ */
+void superpageblock_set_has_movable(struct zone *zone, struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	__spb_set_has_type(page, MIGRATE_MOVABLE);
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+#endif /* CONFIG_COMPACTION */
+
 /**
  * spb_get_category - Determine if a superpageblock is clean or tainted
  * @sb: superpageblock to classify
@@ -585,7 +719,7 @@ static void spb_update_list(struct superpageblock *sb)
 
 	list_del_init(&sb->list);
 
-	if (sb->nr_free == SUPERPAGEBLOCK_NR_PAGEBLOCKS) {
+	if (sb->nr_free == sb->total_pageblocks) {
 		list_add_tail(&sb->list, &zone->spb_empty);
 		return;
 	}
@@ -1023,12 +1157,41 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 			   zone->nr_free_highatomic + nr_pages);
 }
 
+/**
+ * pfn_sb_free_area - Get the correct free_area for a page at given order
+ * @zone: the zone
+ * @pfn: page frame number
+ * @order: buddy order
+ *
+ * Returns the per-superpageblock free_area if the page belongs to a valid
+ * superpageblock. Otherwise returns the zone free_area (for zones where the
+ * superpageblock setup failed).
+ */
+static inline struct free_area *pfn_sb_free_area(struct zone *zone,
+						 unsigned long pfn,
+						 unsigned int order,
+						 struct superpageblock **sbp)
+{
+	struct superpageblock *sb = pfn_to_superpageblock(zone, pfn);
+
+	if (sb) {
+		if (sbp)
+			*sbp = sb;
+		return &sb->free_area[order];
+	}
+	if (sbp)
+		*sbp = NULL;
+	return &zone->free_area[order];
+}
+
 /* Used for pages not on another list */
 static inline void __add_to_free_list(struct page *page, struct zone *zone,
 				      unsigned int order, int migratetype,
 				      bool tail)
 {
-	struct free_area *area = &zone->free_area[order];
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb;
+	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
 	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
@@ -1041,6 +1204,13 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 		list_add(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
 
+	if (sb) {
+		/* Keep zone-level nr_free accurate for watermark checks */
+		zone->free_area[order].nr_free++;
+		/* Track total free pages per superpageblock */
+		sb->nr_free_pages += nr_pages;
+	}
+
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
 }
@@ -1053,7 +1223,8 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 static inline void move_to_free_list(struct page *page, struct zone *zone,
 				     unsigned int order, int old_mt, int new_mt)
 {
-	struct free_area *area = &zone->free_area[order];
+	unsigned long pfn = page_to_pfn(page);
+	struct free_area *area = pfn_sb_free_area(zone, pfn, order, NULL);
 	int nr_pages = 1 << order;
 
 	/* Free page moving can fail, so it happens before the type update */
@@ -1077,6 +1248,9 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 static inline void __del_page_from_free_list(struct page *page, struct zone *zone,
 					     unsigned int order, int migratetype)
 {
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb;
+	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
         VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
@@ -1090,7 +1264,14 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	list_del(&page->buddy_list);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
-	zone->free_area[order].nr_free--;
+	area->nr_free--;
+
+	if (sb) {
+		/* Keep zone-level nr_free accurate for watermark checks */
+		zone->free_area[order].nr_free--;
+		/* Track total free pages per superpageblock */
+		sb->nr_free_pages -= nr_pages;
+	}
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
@@ -1146,33 +1327,44 @@ static void change_pageblock_range(struct page *pageblock_page,
 	}
 }
 
-/*
+/**
  * mark_pageblock_free - handle a pageblock becoming fully free
  * @page: page at the start of the pageblock
  * @pfn: page frame number
+ * @migratetype: pointer to the caller's migratetype variable (may be updated)
  *
- * Clear stale PCP ownership and actual-contents tracking flags when
- * buddy merging reconstructs a full pageblock or a whole pageblock is
- * freed directly. No PCP can still hold pages from this block (otherwise
- * the buddy merge couldn't have completed), so the ownership entry would
- * just cause misrouted frees.
+ * Clear stale PCP ownership and actual-contents tracking flags, mark the
+ * pageblock as fully free for superpageblock accounting, and reset the
+ * migratetype to MOVABLE so the page lands on free_list[MIGRATE_MOVABLE].
+ * Non-movable allocations must go through RMQUEUE_CLAIM to reuse it,
+ * which properly handles PB_all_free and superpageblock accounting.
  */
-static void mark_pageblock_free(struct page *page, unsigned long pfn)
+static void mark_pageblock_free(struct page *page, unsigned long pfn,
+				int *migratetype)
 {
 	clear_pcpblock_owner(page);
 
 	/*
-	 * The entire block is now free -- clear actual-contents tracking
-	 * flags since no allocated pages remain.
+	 * Clear PB_has_* bits and decrement corresponding SPB type
+	 * counters. Use __spb_clear_has_type (no list update) to avoid
+	 * bouncing the SPB between lists; pb_now_free's spb_update_list
+	 * handles the final reclassification.
 	 */
-	clear_pfnblock_bit(page, pfn, PB_has_unmovable);
-	clear_pfnblock_bit(page, pfn, PB_has_reclaimable);
-	clear_pfnblock_bit(page, pfn, PB_has_movable);
+	__spb_clear_has_type(page, MIGRATE_UNMOVABLE);
+	__spb_clear_has_type(page, MIGRATE_RECLAIMABLE);
+	__spb_clear_has_type(page, MIGRATE_MOVABLE);
 
 	if (!get_pfnblock_bit(page, pfn, PB_all_free)) {
 		set_pfnblock_bit(page, pfn, PB_all_free);
 		superpageblock_pb_now_free(page);
 	}
+
+	if (*migratetype == MIGRATE_UNMOVABLE ||
+	    *migratetype == MIGRATE_RECLAIMABLE ||
+	    *migratetype == MIGRATE_HIGHATOMIC) {
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		*migratetype = MIGRATE_MOVABLE;
+	}
 }
 
 /*
@@ -1205,6 +1397,7 @@ static inline void __free_one_page(struct page *page,
 		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
+	unsigned int orig_order = order;
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
@@ -1217,18 +1410,31 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-	account_freepages(zone, 1 << order, migratetype);
+	if (order >= pageblock_order) {
+		int i, nr_pbs = 1 << (order - pageblock_order);
 
-	/*
-	 * When freeing a whole pageblock, clear stale PCP ownership
-	 * and actual-contents tracking flags up front, and mark it
-	 * as fully free for superpageblock accounting.  The in-loop
-	 * check only fires when sub-pageblock pages merge *up to*
-	 * pageblock_order, not when entering at pageblock_order
-	 * directly.
-	 */
-	if (order == pageblock_order)
-		mark_pageblock_free(page, pfn);
+		for (i = 0; i < nr_pbs; i++) {
+			int pb_mt = get_pfnblock_migratetype(
+					page + i * pageblock_nr_pages,
+					pfn + i * pageblock_nr_pages);
+			mark_pageblock_free(page + i * pageblock_nr_pages,
+					    pfn + i * pageblock_nr_pages,
+					    &pb_mt);
+		}
+		/*
+		 * After mark_pageblock_free, non-CMA sub-pageblocks are
+		 * MOVABLE. CMA pageblocks retain their CMA type so pages
+		 * land on the correct free list for CMA allocations.
+		 * ISOLATE pageblocks must stay ISOLATE so that
+		 * account_freepages() correctly skips them -- otherwise
+		 * NR_FREE_PAGES gets incremented for isolated pages.
+		 */
+		if (!is_migrate_cma(migratetype) &&
+		    !is_migrate_isolate(migratetype))
+			migratetype = MIGRATE_MOVABLE;
+	}
+
+	account_freepages(zone, 1 << order, migratetype);
 
 	while (order < MAX_PAGE_ORDER) {
 		int buddy_mt = migratetype;
@@ -1285,8 +1491,29 @@ static inline void __free_one_page(struct page *page,
 		 * clear any stale PCP ownership and actual-contents
 		 * tracking flags.
 		 */
-		if (order == pageblock_order)
-			mark_pageblock_free(page, pfn);
+		if (order == pageblock_order) {
+			int old_mt = migratetype;
+
+			mark_pageblock_free(page, pfn, &migratetype);
+			/*
+			 * mark_pageblock_free may convert migratetype to
+			 * MOVABLE. Transfer the accounting done earlier so
+			 * nr_free_highatomic doesn't leak.
+			 *
+			 * We transfer 1 << orig_order pages -- the amount
+			 * credited by this __free_one_page call. Buddies
+			 * consumed during merging may also have HIGHATOMIC
+			 * credits from their own frees; those are not tracked
+			 * here. In practice HIGHATOMIC reserves are small and
+			 * short-lived, so any residual drift is minor.
+			 */
+			if (old_mt != migratetype) {
+				account_freepages(zone, -(1 << orig_order),
+						  old_mt);
+				account_freepages(zone, 1 << orig_order,
+						  migratetype);
+			}
+		}
 	}
 
 done_merging:
@@ -2163,20 +2390,42 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						struct page *page, int low,
 						int high, int migratetype)
 {
+	struct superpageblock *sb;
 	int nr_pages = 1 << high;
 
 	/*
 	 * If we're splitting a page that spans at least a full pageblock,
-	 * the allocated pageblock transitions from fully-free to in-use.
-	 * Clear PB_all_free and update superpageblock accounting.
+	 * each constituent pageblock transitions from fully-free to in-use.
+	 * Clear PB_all_free and update superpageblock accounting for ALL
+	 * pageblocks in the range, not just the first one.
 	 */
 	if (high >= pageblock_order) {
 		unsigned long pfn = page_to_pfn(page);
+		unsigned long end_pfn = pfn + (1 << high);
 
-		if (get_pfnblock_bit(page, pfn, PB_all_free)) {
-			clear_pfnblock_bit(page, pfn, PB_all_free);
-			superpageblock_pb_now_used(page);
+		for (; pfn < end_pfn; pfn += pageblock_nr_pages) {
+			struct page *pb_page = pfn_to_page(pfn);
+
+			if (get_pfnblock_bit(pb_page, pfn, PB_all_free)) {
+				clear_pfnblock_bit(pb_page, pfn, PB_all_free);
+				superpageblock_pb_now_used(pb_page);
+			}
+			__spb_set_has_type(pb_page, migratetype);
 		}
+		/* Single list update after all pageblocks processed */
+		sb = pfn_to_superpageblock(zone, page_to_pfn(page));
+		if (sb)
+			spb_update_list(sb);
+	} else {
+		/*
+		 * Sub-pageblock allocation: set PB_has_<migratetype> for
+		 * the containing pageblock. Idempotent: only increments
+		 * the counter on the first allocation of this type.
+		 */
+		__spb_set_has_type(page, migratetype);
+		sb = pfn_to_superpageblock(zone, page_to_pfn(page));
+		if (sb)
+			spb_update_list(sb);
 	}
 
 	__del_page_from_free_list(page, zone, high, migratetype);
@@ -2330,6 +2579,15 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 /* Bounded scan limit when searching free lists for tainted superpageblock pages */
 #define SPB_SCAN_LIMIT 8
 
+/*
+ * Reserve free pageblocks in tainted superpageblocks for unmovable/reclaimable
+ * allocations.  Movable allocations skip tainted superpageblocks that have
+ * fewer than this many free pageblocks, ensuring that unmovable claims
+ * always find room in existing tainted superpageblocks instead of spilling
+ * into clean ones.
+ */
+#define SPB_TAINTED_RESERVE	4
+
 /**
  * sb_preferred_for_movable - Find the fullest clean superpageblock for movable
  * @zone: zone to search
@@ -2369,38 +2627,38 @@ static struct page *__rmqueue_from_sb(struct zone *zone, unsigned int order,
 				      int migratetype, struct superpageblock *sb)
 {
 	unsigned int current_order;
-	unsigned long sb_start = sb->start_pfn;
-	unsigned long sb_end = sb_start + (1UL << SUPERPAGEBLOCK_ORDER);
 	struct free_area *area;
 	struct page *page;
-	int scanned;
 
-	for (current_order = order; current_order < NR_PAGE_ORDERS;
+	/*
+	 * Search the superpageblock's own free lists for all orders.
+	 */
+	for (current_order = order;
+	     current_order < NR_PAGE_ORDERS;
 	     ++current_order) {
-		area = &zone->free_area[current_order];
-		scanned = 0;
-
-		list_for_each_entry(page, &area->free_list[migratetype],
-				    buddy_list) {
-			unsigned long pfn = page_to_pfn(page);
+		area = &sb->free_area[current_order];
+		page = get_page_from_free_area(area, migratetype);
+		if (!page)
+			continue;
 
-			if (pfn >= sb_start && pfn < sb_end) {
-				page_del_and_expand(zone, page, order,
-						    current_order,
-						    migratetype);
-				return page;
-			}
-			if (++scanned >= SPB_SCAN_LIMIT)
-				break;
-		}
+		page_del_and_expand(zone, page, order, current_order,
+				    migratetype);
+		return page;
 	}
+
 	return NULL;
 }
 
 /*
  * Go through the free lists for the given migratetype and remove
- * the smallest available page from the freelists
+ * the smallest available page from the freelists.
+ *
+ * When superpageblocks are enabled, search per-superpageblock free lists first,
+ * falling back to zone free lists for pages not in any superpageblock.
  */
+static struct page *claim_whole_block(struct zone *zone, struct page *page,
+		  int current_order, int order, int new_type, int old_type);
+
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
@@ -2408,14 +2666,179 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	unsigned int current_order;
 	struct free_area *area;
 	struct page *page;
+	int full;
+	struct superpageblock *sb;
+	/*
+	 * Category search order: 2 passes.
+	 * Movable: clean first, then tainted (pack into clean SBs).
+	 * Others: tainted first, then clean (concentrate in tainted SBs).
+	 */
+	static const enum sb_category cat_order[2][2] = {
+		[0] = { SB_TAINTED, SB_CLEAN },  /* unmovable/reclaimable */
+		[1] = { SB_CLEAN, SB_TAINTED },  /* movable */
+	};
+	int movable = (migratetype == MIGRATE_MOVABLE) ? 1 : 0;
 
-	/* Find a page of the appropriate size in the preferred list */
-	for (current_order = order; current_order < NR_PAGE_ORDERS; ++current_order) {
+	/*
+	 * Search per-superpageblock free lists for pages of the requested
+	 * migratetype, walking superpageblocks from fullest to emptiest
+	 * to pack allocations.
+	 *
+	 * For unmovable/reclaimable, prefer tainted superpageblocks to
+	 * concentrate non-movable allocations into fewer superpageblocks.
+	 * For movable, prefer clean superpageblocks to keep them homogeneous.
+	 *
+	 * Search empty superpageblocks between the preferred and fallback
+	 * category passes to avoid movable allocations consuming free
+	 * pageblocks in tainted superpageblocks (which unmovable needs for
+	 * future CLAIMs), and vice versa.
+	 */
+	for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+		enum sb_category cat = cat_order[movable][0];
+
+		list_for_each_entry(sb,
+			&zone->spb_lists[cat][full], list) {
+			if (!sb->nr_free_pages)
+				continue;
+			for (current_order = order;
+			     current_order < NR_PAGE_ORDERS;
+			     ++current_order) {
+				area = &sb->free_area[current_order];
+				page = get_page_from_free_area(
+					area, migratetype);
+				if (!page)
+					continue;
+				page_del_and_expand(zone, page,
+					order, current_order,
+					migratetype);
+				trace_mm_page_alloc_zone_locked(
+					page, order, migratetype,
+					pcp_allowed_order(order) &&
+					migratetype < MIGRATE_PCPTYPES);
+				return page;
+			}
+		}
+	}
+
+	/*
+	 * For non-movable allocations, try to reclaim free pageblocks
+	 * from tainted superpageblocks before looking at empty or clean
+	 * ones. Free pageblocks in tainted SBs have pages on the MOVABLE
+	 * free list (reset by mark_pageblock_free), so the search above
+	 * misses them. Claim them inline to keep non-movable allocations
+	 * concentrated in already-tainted superpageblocks.
+	 */
+	if (!movable && !is_migrate_cma(migratetype)) {
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				if (!sb->nr_free)
+					continue;
+				for (current_order = max_t(unsigned int,
+						order, pageblock_order);
+				     current_order < NR_PAGE_ORDERS;
+				     ++current_order) {
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, MIGRATE_MOVABLE);
+					if (!page)
+						continue;
+					if (get_pageblock_isolate(page))
+						continue;
+					if (is_migrate_cma(
+					    get_pageblock_migratetype(page)))
+						continue;
+					page = claim_whole_block(zone, page,
+						current_order, order,
+						migratetype, MIGRATE_MOVABLE);
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
+		}
+	}
+
+	/* Empty superpageblocks: try before falling back to non-preferred category */
+	list_for_each_entry(sb, &zone->spb_empty, list) {
+		if (!sb->nr_free_pages)
+			continue;
+		for (current_order = max(order, pageblock_order);
+		     current_order < NR_PAGE_ORDERS;
+		     ++current_order) {
+			area = &sb->free_area[current_order];
+			page = get_page_from_free_area(area, migratetype);
+			if (!page)
+				continue;
+			page_del_and_expand(zone, page, order,
+				current_order, migratetype);
+			trace_mm_page_alloc_zone_locked(page, order,
+				migratetype,
+				pcp_allowed_order(order) &&
+				migratetype < MIGRATE_PCPTYPES);
+			return page;
+		}
+	}
+
+	/*
+	 * Pass 4: movable allocations fall back to tainted SPBs.
+	 * Non-movable allocations must NOT search clean SPBs here;
+	 * stale migratetype labels create phantom non-movable free
+	 * pages in clean SPBs that would cause unnecessary tainting.
+	 * Let __rmqueue_claim and __rmqueue_steal handle non-movable
+	 * fallback with proper ALLOC_NOFRAGMENT protection.
+	 */
+	if (movable) {
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			enum sb_category cat = cat_order[movable][1];
+
+			list_for_each_entry(sb,
+				&zone->spb_lists[cat][full], list) {
+				if (!sb->nr_free_pages)
+					continue;
+				/*
+				 * Movable falling back to tainted: skip SBs
+				 * with few free pageblocks to reserve space
+				 * for future unmovable/reclaimable claims.
+				 */
+				if (sb->nr_free <= SPB_TAINTED_RESERVE)
+					continue;
+				for (current_order = order;
+				     current_order < NR_PAGE_ORDERS;
+				     ++current_order) {
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, migratetype);
+					if (!page)
+						continue;
+					page_del_and_expand(zone, page,
+						order, current_order,
+						migratetype);
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
+		}
+	}
+
+	/*
+	 * Zone free lists: all pages should be on superpageblock lists.
+	 * Finding a page here means zone hotplug added memory without
+	 * setting up superpageblocks for the new range.
+	 */
+	for (current_order = order;
+	     current_order < NR_PAGE_ORDERS; ++current_order) {
 		area = &(zone->free_area[current_order]);
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
 
+		WARN_ON_ONCE(zone->superpageblocks);
 		page_del_and_expand(zone, page, order, current_order,
 				    migratetype);
 		trace_mm_page_alloc_zone_locked(page, order, migratetype,
@@ -2761,6 +3184,8 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
  *
  * Handle the PB_all_free → used transition, change the pageblock
  * migratetype, split the block down to @order, and return the page.
+ * Used by both the claim fallback path and __rmqueue_smallest when
+ * reclaiming free pageblocks from tainted superpageblocks.
  */
 static struct page *
 claim_whole_block(struct zone *zone, struct page *page,
@@ -2772,11 +3197,6 @@ claim_whole_block(struct zone *zone, struct page *page,
 
 	VM_WARN_ON_ONCE(current_order < order);
 
-	/*
-	 * Clear PB_all_free for pageblocks being claimed.
-	 * This path bypasses page_del_and_expand(), so we
-	 * must handle the free→used transition here.
-	 */
 	for (pb_pfn = page_to_pfn(page);
 	     pb_pfn < page_to_pfn(page) + (1 << current_order);
 	     pb_pfn += pageblock_nr_pages) {
@@ -2827,6 +3247,16 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (get_pageblock_isolate(page))
 		return NULL;
 
+	/*
+	 * Never steal from CMA pageblocks.  CMA pages freed through
+	 * PCP may land on the MOVABLE free list (PCP caches the
+	 * allocation-time migratetype), making them visible to the
+	 * fallback search.  Stealing would corrupt CMA by changing
+	 * the pageblock type away from MIGRATE_CMA.
+	 */
+	if (is_migrate_cma(get_pageblock_migratetype(page)))
+		return NULL;
+
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order)
 		return claim_whole_block(zone, page, current_order, order,
@@ -2893,10 +3323,134 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	return NULL;
 }
 
+/*
+ * Search per-superpageblock free lists for a page of a fallback migratetype.
+ * Sub-pageblock-order free pages live on superpageblock free lists, not zone
+ * free lists, so __rmqueue_claim and __rmqueue_steal need this helper to
+ * find fallback pages at those orders.
+ *
+ * For unmovable/reclaimable allocations, prefer tainted superpageblocks to
+ * keep clean ones clean for future large contiguous allocations.
+ * For movable allocations, prefer clean superpageblocks to keep movable
+ * pages consolidated and superpageblocks homogeneous.
+ *
+ * @search_cats: bitmask controlling which categories to search.
+ *   bit 0: search the preferred category (tainted for unmov, clean for mov)
+ *   bit 1: search empty superpageblocks
+ *   bit 2: search the fallback category (clean for unmov, tainted for mov)
+ * All bits set (0x7) gives the original behavior.
+ */
+#define SB_SEARCH_PREFERRED	(1 << 0)
+#define SB_SEARCH_EMPTY		(1 << 1)
+#define SB_SEARCH_FALLBACK	(1 << 2)
+#define SB_SEARCH_ALL		(SB_SEARCH_PREFERRED | SB_SEARCH_EMPTY | SB_SEARCH_FALLBACK)
+
+static struct page *
+__rmqueue_sb_find_fallback(struct zone *zone, unsigned int order,
+			   int start_migratetype, int *fallback_mt,
+			   unsigned int search_cats)
+{
+	int full, i;
+	struct superpageblock *sb;
+	/*
+	 * Category search order: 2 passes.
+	 * Movable: clean, tainted.  Others: tainted, clean.
+	 */
+	static const enum sb_category cat_order[2][2] = {
+		[0] = { SB_TAINTED, SB_CLEAN },  /* unmovable/reclaimable */
+		[1] = { SB_CLEAN, SB_TAINTED },   /* movable */
+	};
+	int movable = (start_migratetype == MIGRATE_MOVABLE) ? 1 : 0;
+
+	/* Pass 0: preferred category */
+	if (search_cats & SB_SEARCH_PREFERRED) {
+		enum sb_category cat = cat_order[movable][0];
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+					    &zone->spb_lists[cat][full], list) {
+				struct free_area *area =
+					&sb->free_area[order];
+
+				if (movable && cat == SB_TAINTED &&
+				    sb->nr_free <= SPB_TAINTED_RESERVE)
+					continue;
+
+				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+					int fmt = fallbacks[start_migratetype][i];
+					struct page *page;
+
+					page = get_page_from_free_area(area,
+								       fmt);
+					if (page) {
+						*fallback_mt = fmt;
+						return page;
+					}
+				}
+			}
+		}
+	}
+
+	/* Empty superpageblocks: between preferred and fallback */
+	if (search_cats & SB_SEARCH_EMPTY) {
+		list_for_each_entry(sb, &zone->spb_empty, list) {
+			struct free_area *area =
+				&sb->free_area[order];
+
+			for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+				int fmt = fallbacks[start_migratetype][i];
+				struct page *page;
+
+				page = get_page_from_free_area(area,
+							       fmt);
+				if (page) {
+					*fallback_mt = fmt;
+					return page;
+				}
+			}
+		}
+	}
+
+	/* Pass 1: fallback category */
+	if (search_cats & SB_SEARCH_FALLBACK) {
+		enum sb_category cat = cat_order[movable][1];
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+					    &zone->spb_lists[cat][full], list) {
+				struct free_area *area =
+					&sb->free_area[order];
+
+				if (movable && cat == SB_TAINTED &&
+				    sb->nr_free <= SPB_TAINTED_RESERVE)
+					continue;
+
+				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+					int fmt = fallbacks[start_migratetype][i];
+					struct page *page;
+
+					page = get_page_from_free_area(area,
+								       fmt);
+					if (page) {
+						*fallback_mt = fmt;
+						return page;
+					}
+				}
+			}
+		}
+	}
+
+	return NULL;
+}
+
 /*
  * Try to allocate from some fallback migratetype by claiming the entire block,
  * i.e. converting it to the allocation's start migratetype.
  *
+ * Search by category first, then by order within each category, to avoid
+ * claiming clean/empty superpageblocks when tainted ones still have space
+ * at smaller orders.
+ *
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
@@ -2905,11 +3459,16 @@ static __always_inline struct page *
 __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 						unsigned int alloc_flags)
 {
-	struct free_area *area;
 	int current_order;
 	int min_order = order;
 	struct page *page;
 	int fallback_mt;
+	static const unsigned int cat_search[] = {
+		SB_SEARCH_PREFERRED,
+		SB_SEARCH_EMPTY,
+		SB_SEARCH_FALLBACK,
+	};
+	int c;
 
 	/*
 	 * Do not steal pages from freelists belonging to other pageblocks
@@ -2920,65 +3479,34 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 		min_order = pageblock_order;
 
 	/*
-	 * Find the largest available free page in the other list. This roughly
-	 * approximates finding the pageblock with the most free pages, which
-	 * would be too costly to do exactly.
+	 * Find the largest available free page in a fallback migratetype.
+	 * Search each superpageblock category across all orders before
+	 * moving to the next category, so that smaller blocks in tainted
+	 * superpageblocks are preferred over larger blocks in empty/clean
+	 * ones.
 	 */
-	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
-				--current_order) {
-		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, true);
-
-		/* No block in that order */
-		if (fallback_mt == -1)
-			continue;
-
-		/* Advanced into orders too low to claim, abort */
-		if (fallback_mt == -2)
-			break;
-
-		page = get_page_from_free_area(area, fallback_mt);
+	for (c = 0; c < ARRAY_SIZE(cat_search); c++) {
+		for (current_order = MAX_PAGE_ORDER;
+		     current_order >= min_order; --current_order) {
+			if (!should_try_claim_block(current_order,
+						    start_migratetype))
+				break;
+			page = __rmqueue_sb_find_fallback(zone, current_order,
+						start_migratetype,
+						&fallback_mt, cat_search[c]);
+			if (!page)
+				continue;
 
-		/*
-		 * For unmovable/reclaimable stealing, prefer pages from
-		 * tainted superpageblocks (already contaminated) to keep clean
-		 * superpageblocks clean for future 1GB allocations.
-		 */
-		if (start_migratetype != MIGRATE_MOVABLE &&
-		    zone->superpageblocks && page) {
-			struct superpageblock *sb;
-			struct page *alt;
-			int scanned = 0;
-
-			sb = pfn_to_superpageblock(zone, page_to_pfn(page));
-			if (sb && spb_get_category(sb) == SB_CLEAN) {
-				list_for_each_entry(alt,
-						    &area->free_list[fallback_mt],
-						    buddy_list) {
-					struct superpageblock *asb;
-
-					if (++scanned > SPB_SCAN_LIMIT)
-						break;
-					asb = pfn_to_superpageblock(zone,
-							page_to_pfn(alt));
-					if (asb && spb_get_category(asb) ==
-					    SB_TAINTED) {
-						page = alt;
-						break;
-					}
-				}
+			page = try_to_claim_block(zone, page, current_order,
+						  order, start_migratetype,
+						  fallback_mt, alloc_flags);
+			if (page) {
+				trace_mm_page_alloc_extfrag(page, order,
+					current_order, start_migratetype,
+					fallback_mt);
+				return page;
 			}
 		}
-
-		page = try_to_claim_block(zone, page, current_order, order,
-					  start_migratetype, fallback_mt,
-					  alloc_flags);
-		if (page) {
-			trace_mm_page_alloc_extfrag(page, order, current_order,
-						    start_migratetype, fallback_mt);
-			return page;
-		}
 	}
 
 	return NULL;
@@ -2992,19 +3520,23 @@ static __always_inline struct page *
 __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 {
 	struct superpageblock *sb;
-	struct free_area *area;
 	int current_order;
 	struct page *page;
 	int fallback_mt;
 
+	/*
+	 * Search per-superpageblock free lists for fallback migratetypes.
+	 * Superpageblocks are always enabled for populated zones.
+	 */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
-		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, false);
-		if (fallback_mt == -1)
+		page = __rmqueue_sb_find_fallback(zone, current_order,
+					start_migratetype,
+					&fallback_mt,
+					SB_SEARCH_PREFERRED | SB_SEARCH_FALLBACK);
+
+		if (!page)
 			continue;
 
-		page = get_page_from_free_area(area, fallback_mt);
 		page_del_and_expand(zone, page, order, current_order, fallback_mt);
 
 		/*
@@ -3239,33 +3771,11 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 		goto out;
 
 	/*
-	 * Phase 2: Zone too fragmented for whole pageblocks.
-	 * Sweep zone free lists top-down for same-migratetype
-	 * chunks. Avoids cross-type stealing and keeps PCP
-	 * functional under fragmentation.
-	 *
-	 * No ownership claim or PagePCPBuddy - these are
-	 * sub-pageblock fragments cached for batching only.
-	 *
-	 * Stop above the requested order -- at that point,
-	 * phase 3's __rmqueue() does the same lookup but with
-	 * migratetype fallback.
+	 * Phase 2 was removed: it swept zone free lists for sub-pageblock
+	 * fragments, which are always empty when superpageblocks are enabled.
+	 * Phase 3's __rmqueue() -> __rmqueue_smallest() properly searches
+	 * per-superpageblock free lists at all orders.
 	 */
-	for (o = pageblock_order - 1;
-	     o > (int)order && refilled < pages_needed; o--) {
-		struct free_area *area = &zone->free_area[o];
-		struct page *page;
-
-		while (refilled + (1 << o) <= pages_needed) {
-			page = get_page_from_free_area(area, migratetype);
-			if (!page)
-				break;
-
-			del_page_from_free_list(page, zone, o, migratetype);
-			pcp_enqueue_tail(pcp, page, migratetype, o);
-			refilled += 1 << o;
-		}
-	}
 
 	/*
 	 * Phase 3: Last resort. Use __rmqueue() which does
@@ -4367,10 +4877,19 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
-			struct free_area *area = &(zone->free_area[order]);
+			struct free_area *area;
+			struct superpageblock *sb;
 			unsigned long size;
-
-			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
+			unsigned long i;
+
+			page = NULL;
+			/* Search per-superpageblock free lists */
+			for (i = 0; i < zone->nr_superpageblocks && !page; i++) {
+				sb = &zone->superpageblocks[i];
+				area = &sb->free_area[order];
+				page = get_page_from_free_area(area,
+							       MIGRATE_HIGHATOMIC);
+			}
 			if (!page)
 				continue;
 
@@ -4501,29 +5020,20 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 	if (!order)
 		return true;
 
-	/* For a high-order request, check at least one suitable page is free */
+	/*
+	 * For a high-order request, check at least one suitable page is free.
+	 * Zone free_area nr_free is shadowed -- it includes pages on
+	 * per-superpageblock free lists. A non-zero nr_free means the allocator
+	 * will find pages on superpageblock lists even if zone list heads are
+	 * empty.
+	 */
 	for (o = order; o < NR_PAGE_ORDERS; o++) {
 		struct free_area *area = &z->free_area[o];
-		int mt;
 
 		if (!area->nr_free)
 			continue;
 
-		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
-			if (!free_area_empty(area, mt))
-				return true;
-		}
-
-#ifdef CONFIG_CMA
-		if ((alloc_flags & ALLOC_CMA) &&
-		    !free_area_empty(area, MIGRATE_CMA)) {
-			return true;
-		}
-#endif
-		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
-		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
-			return true;
-		}
+		return true;
 	}
 	return false;
 }
@@ -8991,11 +9501,12 @@ static int superpageblock_debugfs_show(struct seq_file *m, void *v)
 		/* Per-superpageblock detail */
 		for (i = 0; i < zone->nr_superpageblocks; i++) {
 			sb = &zone->superpageblocks[i];
-			seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u\n",
+			seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u free_pages=%lu\n",
 				   i, sb->start_pfn,
 				   sb->nr_unmovable, sb->nr_reclaimable,
 				   sb->nr_movable, sb->nr_reserved,
-				   sb->nr_free, sb->total_pageblocks);
+				   sb->nr_free, sb->total_pageblocks,
+				   sb->nr_free_pages);
 		}
 	}
 	return 0;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7b48b84287a7..9133254b6b87 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1575,41 +1575,51 @@ static int frag_show(struct seq_file *m, void *arg)
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
+	unsigned long counts[MIGRATE_TYPES][NR_PAGE_ORDERS] = { };
+	bool overflow[MIGRATE_TYPES][NR_PAGE_ORDERS] = { };
+	unsigned long sb_idx, nr_sbs = zone->nr_superpageblocks;
 	int order, mtype;
 
+	/*
+	 * Free pages live on per-superpageblock free lists. Walk the SPBs,
+	 * accumulating per (migratetype, order) counts. The 100000 cap per
+	 * cell limits time under zone->lock; this is a debugging interface,
+	 * knowing there is "a lot" of one size is sufficient. zone->lock is
+	 * dropped between SPBs, so concurrent memory hotplug may produce
+	 * inconsistent counts -- acceptable for a debug-only interface.
+	 */
+	for (sb_idx = 0; sb_idx < nr_sbs; sb_idx++) {
+		struct superpageblock *sb = &zone->superpageblocks[sb_idx];
+
+		for (order = 0; order < NR_PAGE_ORDERS; order++) {
+			struct free_area *area = &sb->free_area[order];
+			struct list_head *curr;
+
+			for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+				if (overflow[mtype][order])
+					continue;
+				list_for_each(curr, &area->free_list[mtype]) {
+					if (++counts[mtype][order] >= 100000) {
+						overflow[mtype][order] = true;
+						break;
+					}
+				}
+			}
+		}
+		spin_unlock_irq(&zone->lock);
+		cond_resched();
+		spin_lock_irq(&zone->lock);
+	}
+
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
 		seq_printf(m, "Node %4d, zone %8s, type %12s ",
 					pgdat->node_id,
 					zone->name,
 					migratetype_names[mtype]);
-		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
-			unsigned long freecount = 0;
-			struct free_area *area;
-			struct list_head *curr;
-			bool overflow = false;
-
-			area = &(zone->free_area[order]);
-
-			list_for_each(curr, &area->free_list[mtype]) {
-				/*
-				 * Cap the free_list iteration because it might
-				 * be really large and we are under a spinlock
-				 * so a long time spent here could trigger a
-				 * hard lockup detector. Anyway this is a
-				 * debugging tool so knowing there is a handful
-				 * of pages of this order should be more than
-				 * sufficient.
-				 */
-				if (++freecount >= 100000) {
-					overflow = true;
-					break;
-				}
-			}
-			seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
-			spin_unlock_irq(&zone->lock);
-			cond_resched();
-			spin_lock_irq(&zone->lock);
-		}
+		for (order = 0; order < NR_PAGE_ORDERS; order++)
+			seq_printf(m, "%s%6lu ",
+				   overflow[mtype][order] ? ">" : "",
+				   counts[mtype][order]);
 		seq_putc(m, '\n');
 	}
 }
-- 
2.54.0


