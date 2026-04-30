Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D13CCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017C96B00D1; Thu, 30 Apr 2026 16:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B236B00D3; Thu, 30 Apr 2026 16:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9286B00D4; Thu, 30 Apr 2026 16:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC156B00D1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:41:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7269DC0621
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:41:33 +0000 (UTC)
X-FDA: 84716392866.02.E54B580
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCEE912000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:41:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JjUY0tte;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777581691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8DIKV9rBDBiwpuAd2RdEQZcq/dmsaCdW4sLNt7Chuw=;
	b=cfP+Bh6CF0ePuYWl8iq7MV5SJepxPJzSBviQNqtNXN3oyh8IeSldIwWLN333exYzsm3wHN
	8bwZg5IGb84Vtf6lyyG01iDxJQ2tOJf56D0RckF3Oa3U5OssoW5qBl3mhdaq3XsHbOVDJr
	Q3M9Udfrg4uKdoGZEo4j9Wt/8hwfgwY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JjUY0tte;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777581691; a=rsa-sha256;
	cv=none;
	b=b7pJWIi9h7uoF1I/I4jxx6G1/7//UZsRh4Iz4S/pcXCI5eeDJ+D/Xvu5H0lJ9FP0mHtBBX
	IrRGvAPEfrklQvp/fA7GU+yQWEyVWiLHBVMnDYnu36mu98X6mLCND5u0p9fwbdIBKZu3Xu
	H6/cz+U6IWTCfSJim30dUR/8UkUsrp8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f8DIKV9rBDBiwpuAd2RdEQZcq/dmsaCdW4sLNt7Chuw=; b=JjUY0tte4sX6THLExLCyxVcOHc
	7cyuFNo8tjjbkgBzN1B+1b78+LrEEsFYsQLgU1YMMj9lgsgUPTz8eAojaQII+66pXVMzZT4SzxzMZ
	zcZXqQbfDqqE46KYJ+fwjYlztxEgJ3j7jytwXv/GE9gdgzD81ay0a1CbV2EhcNnPb/7PVypOOLXXU
	JmTxvRtX/yGXu/Ra+qUbUTirkd+ikGrHXD2jULVN8XBwlqbP7WDhPIwJYgIUOH9VrHF1C8cnmVjgW
	dX69c3unJY93ycTT2PxnIFiUIxTbDG5pSJHLy3Z+9eJNiO+ftwBKzKJqjTmSUXXIcbEskpunPJgIk
	wkMXHjWg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2gCi;
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
Subject: [RFC PATCH 09/45] mm: page_alloc: introduce superpageblock metadata for 1GB anti-fragmentation
Date: Thu, 30 Apr 2026 16:20:38 -0400
Message-ID: <20260430202233.111010-10-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ihhn1j173c7agk44cpexju31z97okgb
X-Rspamd-Queue-Id: CCEE912000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777581691-573136
X-HE-Meta: U2FsdGVkX198ekLXAQQ37VGcCD8HjLHoo5ByxdIu0jKGjlECEIakhYVK6ulZAMd3osh3DYYsnnpt5edKDyrQKqAlrAkUkPdyF5rfokfBMLnEh+XWfa+QQb0Bwx9GVzRFTbwT52VD4Lb5eqrgyigJ8b3yMmKZJxmrol0uE0jwXLZsZaBUaLXMRdNMxOZI7TMil82Md91fZHxp48F+0zh7In5yQ9/I5vfQBYkVSxEU+6vh01QgTthGRfQhUwqeyWGH53dIezwGUjqr2zER0pasr24rVC2dWc5eK5jmxD3MqPmcKPv3oSaKw/eqLbRoALA9HyiN8xA4tUGWgml8UV4Ed1lEWP+juGnzsASVn0RxwCOzF/5audeBjvpZrc6ONz+bjTIqpOAvfBf4lQFTkljT73kppgqPL24x2ff5i/5Adf9m2MRKtmPAcsWpfYX9/Kph1TOd4ibL/ttSRqVpE9CwzALAC4QOGq9ru3pStxLtMM1uou4u4hP7S2XVjZFxGr9LKXstnz8pEW1JtYEiMfM7GohU2d6//fnmFU7KLzRbkjkwxOZMrLXX51hp3gUqi3uLPYxeL0efIcj31H1a+iozr00/daaOEHo1vZkuzQtd5vaKMKGdqOLUZXnowlfSJymaUrcGN4KA/Bb1ZTXZQFGD6vtBjg417A3IRNtY+uE2aL3Csxn9R5lG7tU7BupO7RkyigXu9sw1LClYdrIOcz1WCcI/GntujEyxZc3VGvSOExZ3mHZWkLx1nEi424IzROmpcv/gYt1mUUSbAalUCLPkSz37CDdVg4bbK47AhotcRyBKCYYKrKEK861B86Ufn6lZvkVPRXaLe1jm1WzHr0ZTCVj4MvyWTRnDI1W2PFZ1Gq/YQso6PIlCBEuelJIAHqbYazTDVIJJ++Pxy5xwDgThS+AHX/8ipdI/u2hoIu7cJOt1Ej3x2r6uC0RYidCGksgKx/OPaNqSuJljdMbpTXO
 7on2E4uA
 DWZA8nIniXSbHNAH1lfAltOlxzuBeTsU5AnU3jU98GWoONNgbbyZMwXtT/kulXIpOZfNyTUi8OVdcxqLOm+yHQNmeYFc8Xjpld6Vdl83bHxyO8AtA6BSFKOfs3O1VbKXbmyqoCzy6TwVmARdY7FaGGoNU+WdMVspO1lgbE02wo9zh/w7HoJPnmfWYN1dCfOGj2mvOIy7D06J3WSQ+UPtzARxQMk4dMB9IO83eM+vHxSHdLStVeYK7HlVNRUalM31jiBTZsIyIZkXn3slVMMU0ikC3q6oVfGhbY4SMi2iIvIudBcYYr8WJJbf7OYmduaOsoM36DXNF/AyQq0Y2+y2zJp5LoTcqq9aULd9H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a 1GB (PUD-sized) "superpageblock" data structure to track
pageblock composition at a coarser granularity, enabling future steering of
unmovable/reclaimable allocations into already-tainted superpageblocks and
preserving clean superpageblocks for 1GB hugepage allocation.

Each superpageblock groups SUPERBLOCK_NR_PAGEBLOCKS pageblocks (512 on
  x86_64 with 2MB pageblocks) and maintains:
- Counts of pageblocks by migratetype (nr_free, nr_unmovable,
  nr_reclaimable, nr_movable, nr_reserved)
- A list_head for future organization by fullness category
- Identity (start_pfn, zone pointer)

Superblock counters are maintained by hooking into
init_pageblock_migratetype(). Memory holes and firmware-reserved regions
are tracked as reserved pageblocks by initializing all slots as reserved
during setup and decrementing as init_pageblock_migratetype() claims them.

The superpageblock array is allocated per-zone during boot via memblock. At
~48 bytes per superpageblock (~12KB for a 256GB system), the overhead is
negligible.

This is pure bookkeeping with no allocation behavior change.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h | 57 ++++++++++++++++++++++++++
 mm/mm_init.c           | 90 ++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c        | 65 ++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2ab45d1133d9..a0e8ce4b7b79 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -877,6 +877,43 @@ enum zone_type {
 
 #define ASYNC_AND_SYNC 2
 
+/*
+ * Superpageblock: 1GB (PUD-sized) region for anti-fragmentation tracking.
+ *
+ * Groups pageblocks to steer unmovable/reclaimable allocations into
+ * already-tainted superpageblocks, preserving clean superpageblocks for 1GB
+ * hugepage allocation.
+ *
+ * SUPERPAGEBLOCK_ORDER derived from PUD geometry:
+ *   x86_64: PUD_SHIFT=30, PAGE_SHIFT=12 → order 18 → 1GB
+ *   Each superpageblock contains SUPERPAGEBLOCK_NR_PAGEBLOCKS pageblocks
+ *   (512 on x86_64 with 2MB pageblocks).
+ */
+#define SUPERPAGEBLOCK_ORDER	(PUD_SHIFT - PAGE_SHIFT)
+#define SUPERPAGEBLOCK_NR_PAGES	(1UL << SUPERPAGEBLOCK_ORDER)
+
+/*
+ * SUPERPAGEBLOCK_NR_PAGEBLOCKS depends on pageblock_order which may be
+ * variable (CONFIG_HUGETLB_PAGE_SIZE_VARIABLE).
+ */
+#define SUPERPAGEBLOCK_NR_PAGEBLOCKS (1UL << (SUPERPAGEBLOCK_ORDER - pageblock_order))
+
+struct superpageblock {
+	/* Pageblock counts by current migratetype */
+	u16			nr_free;
+	u16			nr_unmovable;
+	u16			nr_reclaimable;
+	u16			nr_movable;
+	u16			nr_reserved;	/* holes, firmware, etc. */
+
+	/* For organizing superpageblocks by fullness category */
+	struct list_head	list;
+
+	/* Identity */
+	unsigned long		start_pfn;
+	struct zone		*zone;
+};
+
 struct zone {
 	/* Read-mostly fields */
 
@@ -919,6 +956,11 @@ struct zone {
 	struct pageblock_data	*pageblock_data;
 #endif /* CONFIG_SPARSEMEM */
 
+	/* Superpageblock array for 1GB anti-fragmentation tracking */
+	struct superpageblock	*superpageblocks;
+	unsigned long		nr_superpageblocks;
+	unsigned long		superpageblock_base_pfn; /* 1GB-aligned base */
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
@@ -1059,6 +1101,21 @@ struct zone {
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
+static inline struct superpageblock *pfn_to_superpageblock(struct zone *zone,
+						   unsigned long pfn)
+{
+	unsigned long idx;
+
+	if (!zone->superpageblocks)
+		return NULL;
+
+	idx = (pfn - zone->superpageblock_base_pfn) >> SUPERPAGEBLOCK_ORDER;
+	if (idx >= zone->nr_superpageblocks)
+		return NULL;
+
+	return &zone->superpageblocks[idx];
+}
+
 enum pgdat_flags {
 	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
 					 * many pages under writeback
diff --git a/mm/mm_init.c b/mm/mm_init.c
index b3f83452de72..1fb62342d1c6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1517,6 +1517,95 @@ static void __ref setup_usemap(struct zone *zone)
 static inline void setup_usemap(struct zone *zone) {}
 #endif /* CONFIG_SPARSEMEM */
 
+/**
+ * init_one_superpageblock - initialize a single superpageblock
+ * @sb: superpageblock to initialize
+ * @zone: owning zone
+ * @start_pfn: start PFN for this superpageblock
+ * @zone_start: zone start PFN (for clipping)
+ * @zone_end: zone end PFN (for clipping)
+ *
+ * Zero counters, compute the zone-clipped pageblock count.
+ * Used by both boot-time setup and memory hotplug resize.
+ */
+static void __meminit init_one_superpageblock(struct superpageblock *sb,
+					      struct zone *zone,
+					      unsigned long start_pfn,
+					      unsigned long zone_start,
+					      unsigned long zone_end)
+{
+	unsigned long sb_end = start_pfn + SUPERPAGEBLOCK_NR_PAGES;
+	unsigned long pb_start = max(start_pfn, zone_start);
+	unsigned long pb_end = min(sb_end, zone_end);
+	u16 actual_pbs;
+
+	sb->nr_unmovable = 0;
+	sb->nr_reclaimable = 0;
+	sb->nr_movable = 0;
+	sb->nr_free = 0;
+	INIT_LIST_HEAD(&sb->list);
+	sb->start_pfn = start_pfn;
+	sb->zone = zone;
+
+	/*
+	 * Start with all pageblock slots as reserved.
+	 * init_pageblock_migratetype() will decrement nr_reserved and
+	 * increment the appropriate counter for each real pageblock.
+	 * Holes and firmware-reserved regions stay counted as reserved.
+	 *
+	 * Only count pageblocks that fall within the zone's span.
+	 * The first and last superpageblocks may extend beyond the
+	 * zone boundaries.  Use round-up division because a partial
+	 * pageblock at the zone boundary still gets initialized by
+	 * init_pageblock_migratetype().
+	 */
+	actual_pbs = (pb_end > pb_start) ?
+		     ((pb_end - pb_start + pageblock_nr_pages - 1) >>
+		      pageblock_order) : 0;
+	sb->nr_reserved = actual_pbs;
+}
+
+static void __init setup_superpageblocks(struct zone *zone)
+{
+	unsigned long zone_start = zone->zone_start_pfn;
+	unsigned long zone_end = zone_start + zone->spanned_pages;
+	unsigned long sb_base, nr_superpageblocks;
+	size_t alloc_size;
+	unsigned long i;
+
+	zone->superpageblocks = NULL;
+	zone->nr_superpageblocks = 0;
+	zone->superpageblock_base_pfn = 0;
+
+	if (!zone->spanned_pages)
+		return;
+
+	/*
+	 * Superpageblocks must be 1GB (PUD) aligned. Align the base down
+	 * and the end up to cover all 1GB regions the zone spans.
+	 */
+	sb_base = ALIGN_DOWN(zone_start, SUPERPAGEBLOCK_NR_PAGES);
+	nr_superpageblocks = (ALIGN(zone_end, SUPERPAGEBLOCK_NR_PAGES) - sb_base) >>
+			 SUPERPAGEBLOCK_ORDER;
+
+	alloc_size = nr_superpageblocks * sizeof(struct superpageblock);
+	zone->superpageblocks = memblock_alloc_node(alloc_size, SMP_CACHE_BYTES,
+						zone_to_nid(zone));
+	if (!zone->superpageblocks) {
+		pr_warn("Failed to allocate %zu bytes for zone %s superpageblocks\n",
+			alloc_size, zone->name);
+		return;
+	}
+
+	zone->nr_superpageblocks = nr_superpageblocks;
+	zone->superpageblock_base_pfn = sb_base;
+
+	for (i = 0; i < nr_superpageblocks; i++)
+		init_one_superpageblock(&zone->superpageblocks[i], zone,
+					sb_base + (i << SUPERPAGEBLOCK_ORDER),
+					zone_start, zone_end);
+}
+
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
@@ -1625,6 +1714,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
 			continue;
 
 		setup_usemap(zone);
+		setup_superpageblocks(zone);
 		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0a4de435842..a3837a30a7eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -501,6 +501,62 @@ void clear_pfnblock_bit(const struct page *page, unsigned long pfn,
 	clear_bit(pb_bit, get_pfnblock_flags_word(page, pfn));
 }
 
+/*
+ * Map migratetype to PB_has_* bit index. Returns -1 for types that
+ * don't have a tracking bit (e.g. MIGRATE_ISOLATE).
+ */
+static inline int migratetype_to_has_bit(int migratetype)
+{
+	switch (migratetype) {
+	case MIGRATE_UNMOVABLE:
+	case MIGRATE_HIGHATOMIC:
+		return PB_has_unmovable;
+	case MIGRATE_RECLAIMABLE:
+		return PB_has_reclaimable;
+	case MIGRATE_MOVABLE:
+#ifdef CONFIG_CMA
+	case MIGRATE_CMA:
+#endif
+		return PB_has_movable;
+	default:
+		return -1;
+	}
+}
+
+/*
+ * __spb_set_has_type - set PB_has_* and increment type counter
+ *
+ * Idempotent: only increments the counter on the 0→1 bit transition.
+ */
+static void __spb_set_has_type(struct page *page, int migratetype)
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
+	if (!get_pfnblock_bit(page, pfn, bit)) {
+		set_pfnblock_bit(page, pfn, bit);
+		switch (bit) {
+		case PB_has_unmovable:
+			sb->nr_unmovable++;
+			break;
+		case PB_has_reclaimable:
+			sb->nr_reclaimable++;
+			break;
+		case PB_has_movable:
+			sb->nr_movable++;
+			break;
+		}
+	}
+}
+
 /**
  * set_pageblock_migratetype - Set the migratetype of a pageblock
  * @page: The page within the block of interest
@@ -534,6 +590,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct pageblock_data *pbd;
+	struct superpageblock *sb;
 	unsigned long flags;
 
 	if (unlikely(page_group_by_mobility_disabled &&
@@ -557,6 +614,14 @@ void __meminit init_pageblock_migratetype(struct page *page,
 	pbd = pfn_to_pageblock(page, pfn);
 	pbd->block_pfn = pfn;
 	INIT_LIST_HEAD(&pbd->cpu_node);
+
+	/* Transition from reserved (boot default) to initial migratetype */
+	sb = pfn_to_superpageblock(page_zone(page), pfn);
+	if (sb) {
+		if (sb->nr_reserved)
+			sb->nr_reserved--;
+		__spb_set_has_type(page, migratetype);
+	}
 }
 
 #ifdef CONFIG_DEBUG_VM
-- 
2.52.0


