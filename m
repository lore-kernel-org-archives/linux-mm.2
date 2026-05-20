Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FE5CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9686B00B0; Wed, 20 May 2026 11:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A316B00B1; Wed, 20 May 2026 11:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629F96B00B2; Wed, 20 May 2026 11:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49D0F6B00B0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 072FA160B1F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:58 +0000 (UTC)
X-FDA: 84788110596.26.BF8B020
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C3EE14000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CkS1ZzHB;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Bzuf5BwIhqsSiCqnGbY9Gcb4BHhoBzW49U2aIagYW8=;
	b=tk8B2O31RO3o4UNP9T7rvR1KKKexi6NKjfSvy/dEOZdN41QG5YZGH2DMCDAgnhZiY37SuP
	WqlZ6sHEmEprYOaNKzcxj2mIe99U7WA6a+qI6U8pcRljFhE8AMDNYcW8tz5/5KstwODJp8
	2EZgo0Gp8pEbulP28PpDekrl98ChzBM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CkS1ZzHB;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289256; a=rsa-sha256;
	cv=none;
	b=T/osALer9SVDo00Bo64MlsjaX9gk1dsKDoUrnkKZR2RDudVRacjAfN62gQiJ60/v2RLLFc
	hstvXAhjP27cRXxcYwIoQxt135h4692XPAr+y1l1ulRWqjqi6l2Qab1nmAByK+cmO3C//F
	SRyg5WFvYLUaw4YlRlY/1kPGOzseS18=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4Bzuf5BwIhqsSiCqnGbY9Gcb4BHhoBzW49U2aIagYW8=; b=CkS1ZzHB+SVk/g4C3fgrjki9LM
	3wC4dwpHnuXCizhek6TI0mRnX1ViB0uIDK0LboknXITq5LdMskd5WDgqC3lVb9Dul9OSvNXvL1Imk
	dPo4XGBb3fMFA2npkznCZJ3+wYkSDa6AVMHdQFj0neXry8asN2P+NGMkpREVibLkv51HKg1Xcxdev
	pmlrz4Vom3kVeYeeLd4wt3EI/feN6uFQ14Xkf0MtyrMZNJz0eJg/wtI7khTMKDUaijeFlSf9ccWBA
	lN1OIx91/TyzUfvtEt7NFdfw62cH/+dBA+RJhrK7Psdmeo8KokiDUaFOJoMtwQswOhu8xQ6agtS9v
	crEimvVA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0xr4;
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
Subject: [RFC PATCH 08/40] mm: page_alloc: superpageblock metadata for 1GB anti-fragmentation
Date: Wed, 20 May 2026 10:59:14 -0400
Message-ID: <20260520150018.2491267-9-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ej9yizzz967y8ij4q31e1pip5i3uxtjq
X-Rspamd-Queue-Id: 2C3EE14000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779289255-491725
X-HE-Meta: U2FsdGVkX1+4m/ip+2DP1blp/ezlhzNblqE8ifueiHkhYjpuKD5XTVZHXSPb/WoeO/H2hFzyRsCV6HJB6WDvDrN1XNsBifpGg+EbThQQWTya4W+eGKORxpqwdEem4wKdjBqT44NOIq7jRw1njXEwPqHYnPYC2fFflmfMn2OG6/AjfnxcNQCFl7rQHVpq1LdUY4Nsw7ESzhTteUQuTrogJEl9nREqC3V2WQBQZOzcZaATm8dTyYTXuoHD3dnymHYKH1eoaQ3X80cvzhsGrwzXfBtoQKzv7SoH7AWnXbY5BA2G3w2GAJdw0P4OJQxAP00AahaDZpTdBsjHzFPV55+JmRiJTUzvQsA6STFLsnQYrP28Fo2v4OJ5/q/JIsjckSQ2grVQJF7eISgqMzXeW+/Q15gCNYUry6YBs6XpBPQHsLkxjVlB4QFmYmMLLRYPIpkPwzEdVmWtZbiyhWa6EttNn/s52SGTePoUwX6T5vxyDX84igr51GxLy6EoAvMW6gwFy1SGz4VKS+SOYqraNukTiZaX0GM8SO/KV2P1Gdly9/qrFnw4nI7Y0TLiu1WvrFKUuxMlNEi/Nt1lFbUUtxH13p2cpYYLSYAD9JcmPVkvmacTwt5+ct0WmGQLMNN/XJPW0U7bmurY5QE21QrZ0dONWqNQAoPL1fpUa/qImQZ18yZiEwHMjcXwdpKN6o2U4Sn7BdxgjpXrBGZkTuBTWeIT6LPipeBQ4yEWcNWZy1dpTn6yqtxfLA7XTX+gJCKLxVJ9Xjq897KbczbgpwSvtg31N4WBRj4NJ0wDJ1+8FidmIN5fmRQ7WwRa5eoWCv1e8JqmYDQNPkgSqHjqheKZZ58pz66YU/elTRrXzjR8Ycl0I6fP3AEbK8vb+nUBNHcSDelD7wI6YPLWKybfPRwKNASFRS8fWV7mSNOps9nQJs5UqgsQGCDMQxqrdphySN+uJ3tBEIvh4HGbZsCZoCCba0C
 zgXyRvKu
 z1W1yNzj96gKyFho5pu014qSX2EJyMthiZJSp7UBe2UDPw8Wm9yAmMJCWUI9/HX7vvltjY/SGFdXgoYx8x/QpCEmb5Yqv6m9Tp2aixIr3jCS/hIHotl+8oFSBGGHq9XR1j41zbj4fkBWHNZPPRT2XTSLtU1Cq3jr+J65SFcZwVFvpdgI7tIDMm88bdvhxhPu8h9rivOD0gxopILJVosst6KilulJKzxp5Hk0TgNe+pQA7RfI2ffif6cuVAmyYh9FrV/RyevOF9e7l6e9zqDCN68082UAn3h5GPEtaME7VnubyiQXBGbTv8Cjv5JufC5uOsKkB8MWI0Lapycn683mXGMVUBZZRHRkgNv8S
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
index 90498bbbf60b..e3eac971a76a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -974,6 +974,43 @@ enum zone_type {
 
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
 
@@ -1016,6 +1053,11 @@ struct zone {
 	struct pageblock_data	*pageblock_data;
 #endif /* CONFIG_SPARSEMEM */
 
+	/* Superpageblock array for 1GB anti-fragmentation tracking */
+	struct superpageblock	*superpageblocks;
+	unsigned long		nr_superpageblocks;
+	unsigned long		superpageblock_base_pfn; /* 1GB-aligned base */
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
@@ -1159,6 +1201,21 @@ struct zone {
 #endif
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
index 47a222e49fc9..de02a6087c21 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1503,6 +1503,95 @@ static void __ref setup_usemap(struct zone *zone)
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
@@ -1611,6 +1700,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
 			continue;
 
 		setup_usemap(zone);
+		setup_superpageblocks(zone);
 		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23108cdcbbec..b9b7d54a869c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -457,6 +457,62 @@ void clear_pfnblock_bit(const struct page *page, unsigned long pfn,
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
@@ -490,6 +546,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct pageblock_data *pbd;
+	struct superpageblock *sb;
 	unsigned long flags;
 
 	if (unlikely(page_group_by_mobility_disabled &&
@@ -513,6 +570,14 @@ void __meminit init_pageblock_migratetype(struct page *page,
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
2.54.0


