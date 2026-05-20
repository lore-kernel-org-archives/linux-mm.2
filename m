Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154A0CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991446B00B9; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B006B00B8; Wed, 20 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C0C6B00BA; Wed, 20 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 457A86B00B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8EDA160A69
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:01 +0000 (UTC)
X-FDA: 84788110722.19.39B4F13
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id C902F100009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jTECLLiP;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VRttkw1lb8yL2Eo96Ndyc3llIaCXL78G0HM2bDGbJI=;
	b=KEwENyM4IAnPNFp3qJESroiN4gDs3A6SgLtEzBHoq7mEUz/awQadzwu8beaz8sFxyKn52K
	ukcc+LXx4RjUKTzIVvpB+86JQfdYYv7XYzf1nrX3Uo7/HKQAMtsVs+aEWxtHjIbrrX8gYE
	ZAgr5B1ueyqw3POyFYAPFONDzukYo2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289259; a=rsa-sha256;
	cv=none;
	b=8PwKr7GOiCIuc8BhEBgJjyrG96RSKpy+7JpSFox7diqGxuJQG4+gA6GPxCJbHuHbxHe+WY
	r1pGIqbxkRzr3jGmKMDMsa4p4VLLMTfExt0hxt16f14QDdgl3XjSm5sJdKL+c9pT40JSX7
	R84FS3GxKV4Shv5gH8IxzjpgMN3MMx0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jTECLLiP;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0VRttkw1lb8yL2Eo96Ndyc3llIaCXL78G0HM2bDGbJI=; b=jTECLLiPMmNc8gdxA7G0IoHJna
	TOOys13yPQIA8pYEkJg7CokWyQsLyjNLCiSIecDg7uWw81/e2YB+frRWlnxBNh8R+9QkAba5Vgl/j
	dWKf7Suduc1mR4rVOVhq80Zmq0+nGGR/dZKDARObghWBMUi+htFVK4Clgf9KFvkgjaIOHX7caedjJ
	Qx9sl5Fu+jWGJYI9+1RxSsrLI2/Pub5njPgA67xKUhbkrVrT1M/Vmquz7WZp97zLFJ3U0zkHjugM3
	JYTTERJHd0NrfQdS8XsPqFGnyqCP6zPU9TB/ux9/rCNXQkzX9SmWY+hBtMS/wPQSHLH4p8B05e17M
	pt4eGeOg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-073F;
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
	Johannes Weiner <hnaz@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 01/40] mm: page_alloc: replace pageblock_flags bitmap with struct pageblock_data
Date: Wed, 20 May 2026 10:59:07 -0400
Message-ID: <20260520150018.2491267-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C902F100009
X-Stat-Signature: iqymwaozsh883dmu399txkd8jbycf37e
X-Rspam-User: 
X-HE-Tag: 1779289259-537593
X-HE-Meta: U2FsdGVkX189REYvSJqO3nGO7wwDYBodi70TLa5ZQDxmYyPhbjQP8y86flqWDnhk936BwDy2g9T1HyYsNbbUDw+3ncEwjir1ATmRLS6anix+WbBKx+9OoxpGvZRwgCjtXyFK83p3vSFoy1jRp2Cq4zPNG34WhzcF3tWcwJkn7mvGCiPanPyjXuvJ08UhxAgwpMKd76EKECUs5GtIvAuyY+a2Ewyf3knlwNTRADgHqD459iaDrMYOwiRyxq1OQ8NVvGOWQkUgLWNDvFPH6JMnGuyuf97Zqs0Vv8GDiDxy7QI6Upq/aH2F8nHzfXIq8fWfO6N9uRRT9ajjAUfYx8oupubB6S12hKtqx4bwQaT8OTGKkiwM24QZezpapxrF3P9Wspn/iI23B+HrfbeEmmGjYUoXqFWLZZ16J/Rcir4bA/dAnpKpMEv45GU6l0BPDzvoh1UCZRGnoR1GiDEt8beafPJir1FoapSUKLesAPsoSkYHr4Cu2IgXoPF4CPIeoJqJKce9U+b1wwUOEFWb/o3jKbMC2DSsh23YE83qfBu1AC3XXKWqceRukIgtDwtsvxmrtmWgHhaYVc7anP8VsDDdwXrmdG52POUKm8Y6mY5i/1LMA7J6NULJT1MBV7dOS9XabVuYph2oN1xp38JAdtSRCFQGFJL+16+KcF1tHWV3WtDjghXsdK29aP8FSTvmHnD+cxupU3mayi9YHWHGMICto+nhRWjiDYVIXrA2yfWp2wdzgdUGznMoxZRTgkh0Q8fs+VJZChziVinnv38E5aMWaObEwiZbvs8a/5JZICdhzQPwArFpr5jyShAyvFX+E2kJI/0f/A5Zcunx0Ft4Tzt9Ft4APhpN65nothM2B35H8tFoujKe7v6+HgFMcRydAEJXOaBy0m2bEyUVZGgIdxzqeHmnsEZwjKBlS87ogEyAoBbIefRMu2HsgZfTLWyeRZ2Tnq4aihUW0DC7CbWYid1
 W7jjHru4
 Di0phREN7NhueAoVGQdTR0HzbbHK6qCfHzjK/67NpcQInZ9oHPBtFBf7NZKop2FkxvNAgM+e9Gbdiy4y42i+IqPGN4BeMfaq/MS+WBT/S/YUNT5QgyavhZ+wSwRXLR92LC1O5th1mfUSftyNH7ZmvZvAtPLE2UwJOggw/TU9/7xk3hOAI1F1IMTSHCbwqF1r2hsQB68WGfB/Nh+qV2WwACPSnBuU5oqtzp8l0hdvVRaTCD6s8eldfp53irNUmC45yQMt6mnWw+dD8NSP6BkTJMZME+MsNR++7P6mwFH+yX6ZfuTbd53D6zfSq4BNbh7pHCwjQny7Li2E4zJ8RlLhu9dsBDdTLYMBLBzyJ3jYGo6MDCuaHqJnOBFSzP+H1q+FdLQ8I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <hannes@cmpxchg.org>

Replace the packed pageblock_flags bitmap with a per-pageblock struct
containing its own flags word. This changes the storage from
NR_PAGEBLOCK_BITS bits per pageblock packed into shared unsigned longs,
to a dedicated unsigned long per pageblock.

The free path looks up migratetype (from pageblock flags) immediately
followed by looking up pageblock ownership. Colocating them in a struct
means this hot path touches one cache line instead of two.

The per-pageblock struct also eliminates all the bit-packing indexing
(pfn_to_bitidx, word selection, intra-word shifts), simplifying the
accessor code.

Memory overhead: 8 bytes per pageblock (one unsigned long). With 2MB
pageblocks on x86_64, that's 4KB per GB -- up from ~0.5-1 bytes per
pageblock with the packed bitmap, but still negligible in absolute terms.

No functional change.

Signed-off-by: Johannes Weiner <hnaz@cmpxchg.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h | 15 ++++----
 mm/internal.h          | 17 +++++++++
 mm/mm_init.c           | 25 +++++--------
 mm/page_alloc.c        | 84 +++++++-----------------------------------
 mm/sparse.c            |  3 +-
 5 files changed, 50 insertions(+), 94 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..935ddc78f636 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1004,7 +1004,7 @@ struct zone {
 	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
 	 * In SPARSEMEM, this map is stored in struct mem_section
 	 */
-	unsigned long		*pageblock_flags;
+	struct pageblock_data	*pageblock_data;
 #endif /* CONFIG_SPARSEMEM */
 
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
@@ -1957,9 +1957,6 @@ static inline bool movable_only_nodes(nodemask_t *nodes)
 #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
-#define SECTION_BLOCKFLAGS_BITS \
-	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
-
 #if (MAX_PAGE_ORDER + PAGE_SHIFT) > SECTION_SIZE_BITS
 #error Allocator MAX_PAGE_ORDER exceeds SECTION_SIZE
 #endif
@@ -1992,13 +1989,17 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
 #define SUBSECTION_ALIGN_UP(pfn) ALIGN((pfn), PAGES_PER_SUBSECTION)
 #define SUBSECTION_ALIGN_DOWN(pfn) ((pfn) & PAGE_SUBSECTION_MASK)
 
+struct pageblock_data {
+	unsigned long flags;
+};
+
 struct mem_section_usage {
 	struct rcu_head rcu;
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
 #endif
 	/* See declaration of similar field in struct zone */
-	unsigned long pageblock_flags[0];
+	struct pageblock_data pageblock_data[];
 };
 
 struct page;
@@ -2049,9 +2050,9 @@ extern struct mem_section **mem_section;
 extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
 #endif
 
-static inline unsigned long *section_to_usemap(struct mem_section *ms)
+static inline struct pageblock_data *section_to_usemap(struct mem_section *ms)
 {
-	return ms->usage->pageblock_flags;
+	return ms->usage->pageblock_data;
 }
 
 static inline struct mem_section *__nr_to_section(unsigned long nr)
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..c8404cb00b08 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -808,6 +808,23 @@ static inline struct page *find_buddy_page_pfn(struct page *page,
 	return NULL;
 }
 
+static inline struct pageblock_data *pfn_to_pageblock(const struct page *page,
+						      unsigned long pfn)
+{
+#ifdef CONFIG_SPARSEMEM
+	struct mem_section *ms = __pfn_to_section(pfn);
+	unsigned long idx = (pfn & (PAGES_PER_SECTION - 1)) >> pageblock_order;
+
+	return &section_to_usemap(ms)[idx];
+#else
+	struct zone *zone = page_zone(page);
+	unsigned long idx;
+
+	idx = (pfn - pageblock_start_pfn(zone->zone_start_pfn)) >> pageblock_order;
+	return &zone->pageblock_data[idx];
+#endif
+}
+
 extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone);
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..1bc909da9c13 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1453,36 +1453,31 @@ void __meminit init_currently_empty_zone(struct zone *zone,
 
 #ifndef CONFIG_SPARSEMEM
 /*
- * Calculate the size of the zone->pageblock_flags rounded to an unsigned long
- * Start by making sure zonesize is a multiple of pageblock_order by rounding
- * up. Then use 1 NR_PAGEBLOCK_BITS worth of bits per pageblock, finally
- * round what is now in bits to nearest long in bits, then return it in
- * bytes.
+ * Calculate the size of the zone->pageblock_data array.
+ * Round up the zone size to a pageblock boundary to get the
+ * number of pageblocks, then multiply by the struct size.
  */
 static unsigned long __init usemap_size(unsigned long zone_start_pfn, unsigned long zonesize)
 {
-	unsigned long usemapsize;
+	unsigned long nr_pageblocks;
 
 	zonesize += zone_start_pfn & (pageblock_nr_pages-1);
-	usemapsize = round_up(zonesize, pageblock_nr_pages);
-	usemapsize = usemapsize >> pageblock_order;
-	usemapsize *= NR_PAGEBLOCK_BITS;
-	usemapsize = round_up(usemapsize, BITS_PER_LONG);
+	nr_pageblocks = round_up(zonesize, pageblock_nr_pages) >> pageblock_order;
 
-	return usemapsize / BITS_PER_BYTE;
+	return nr_pageblocks * sizeof(struct pageblock_data);
 }
 
 static void __ref setup_usemap(struct zone *zone)
 {
 	unsigned long usemapsize = usemap_size(zone->zone_start_pfn,
 					       zone->spanned_pages);
-	zone->pageblock_flags = NULL;
+	zone->pageblock_data = NULL;
 	if (usemapsize) {
-		zone->pageblock_flags =
+		zone->pageblock_data =
 			memblock_alloc_node(usemapsize, SMP_CACHE_BYTES,
 					    zone_to_nid(zone));
-		if (!zone->pageblock_flags)
-			panic("Failed to allocate %ld bytes for zone %s pageblock flags on node %d\n",
+		if (!zone->pageblock_data)
+			panic("Failed to allocate %ld bytes for zone %s pageblock data on node %d\n",
 			      usemapsize, zone->name, zone_to_nid(zone));
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..fcff0083d5d4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -315,52 +315,18 @@ static inline bool _deferred_grow_zone(struct zone *zone, unsigned int order)
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
-/* Return a pointer to the bitmap storing bits affecting a block of pages */
-static inline unsigned long *get_pageblock_bitmap(const struct page *page,
-							unsigned long pfn)
-{
-#ifdef CONFIG_SPARSEMEM
-	return section_to_usemap(__pfn_to_section(pfn));
-#else
-	return page_zone(page)->pageblock_flags;
-#endif /* CONFIG_SPARSEMEM */
-}
-
-static inline int pfn_to_bitidx(const struct page *page, unsigned long pfn)
-{
-#ifdef CONFIG_SPARSEMEM
-	pfn &= (PAGES_PER_SECTION-1);
-#else
-	pfn = pfn - pageblock_start_pfn(page_zone(page)->zone_start_pfn);
-#endif /* CONFIG_SPARSEMEM */
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
-}
-
 static __always_inline bool is_standalone_pb_bit(enum pageblock_bits pb_bit)
 {
 	return pb_bit >= PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
 }
 
-static __always_inline void
-get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
-			   unsigned long **bitmap_word, unsigned long *bitidx)
+static __always_inline unsigned long *
+get_pfnblock_flags_word(const struct page *page, unsigned long pfn)
 {
-	unsigned long *bitmap;
-	unsigned long word_bitidx;
-
-#ifdef CONFIG_MEMORY_ISOLATION
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
-#else
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-#endif
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
-	bitmap = get_pageblock_bitmap(page, pfn);
-	*bitidx = pfn_to_bitidx(page, pfn);
-	word_bitidx = *bitidx / BITS_PER_LONG;
-	*bitidx &= (BITS_PER_LONG - 1);
-	*bitmap_word = &bitmap[word_bitidx];
+	return &pfn_to_pageblock(page, pfn)->flags;
 }
 
 
@@ -377,18 +343,14 @@ static unsigned long __get_pfnblock_flags_mask(const struct page *page,
 					       unsigned long pfn,
 					       unsigned long mask)
 {
-	unsigned long *bitmap_word;
-	unsigned long bitidx;
-	unsigned long word;
+	unsigned long *flags_word = get_pfnblock_flags_word(page, pfn);
 
-	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
 	/*
 	 * This races, without locks, with set_pfnblock_migratetype(). Ensure
 	 * a consistent read of the memory array, so that results, even though
 	 * racy, are not corrupted.
 	 */
-	word = READ_ONCE(*bitmap_word);
-	return (word >> bitidx) & mask;
+	return READ_ONCE(*flags_word) & mask;
 }
 
 /**
@@ -402,15 +364,10 @@ static unsigned long __get_pfnblock_flags_mask(const struct page *page,
 bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
 		      enum pageblock_bits pb_bit)
 {
-	unsigned long *bitmap_word;
-	unsigned long bitidx;
-
 	if (WARN_ON_ONCE(!is_standalone_pb_bit(pb_bit)))
 		return false;
 
-	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
-
-	return test_bit(bitidx + pb_bit, bitmap_word);
+	return test_bit(pb_bit, get_pfnblock_flags_word(page, pfn));
 }
 
 /**
@@ -449,18 +406,13 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 static void __set_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 				      unsigned long flags, unsigned long mask)
 {
-	unsigned long *bitmap_word;
-	unsigned long bitidx;
-	unsigned long word;
-
-	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
+	unsigned long *flags_word = get_pfnblock_flags_word(page, pfn);
+	unsigned long word, new_word;
 
-	mask <<= bitidx;
-	flags <<= bitidx;
-
-	word = READ_ONCE(*bitmap_word);
+	word = READ_ONCE(*flags_word);
 	do {
-	} while (!try_cmpxchg(bitmap_word, &word, (word & ~mask) | flags));
+		new_word = (word & ~mask) | flags;
+	} while (!try_cmpxchg(flags_word, &word, new_word));
 }
 
 /**
@@ -472,15 +424,10 @@ static void __set_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 void set_pfnblock_bit(const struct page *page, unsigned long pfn,
 		      enum pageblock_bits pb_bit)
 {
-	unsigned long *bitmap_word;
-	unsigned long bitidx;
-
 	if (WARN_ON_ONCE(!is_standalone_pb_bit(pb_bit)))
 		return;
 
-	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
-
-	set_bit(bitidx + pb_bit, bitmap_word);
+	set_bit(pb_bit, get_pfnblock_flags_word(page, pfn));
 }
 
 /**
@@ -492,15 +439,10 @@ void set_pfnblock_bit(const struct page *page, unsigned long pfn,
 void clear_pfnblock_bit(const struct page *page, unsigned long pfn,
 			enum pageblock_bits pb_bit)
 {
-	unsigned long *bitmap_word;
-	unsigned long bitidx;
-
 	if (WARN_ON_ONCE(!is_standalone_pb_bit(pb_bit)))
 		return;
 
-	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
-
-	clear_bit(bitidx + pb_bit, bitmap_word);
+	clear_bit(pb_bit, get_pfnblock_flags_word(page, pfn));
 }
 
 /**
diff --git a/mm/sparse.c b/mm/sparse.c
index effdac6b0ab1..f77d6d9fa62f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -216,7 +216,8 @@ static void __init memblocks_present(void)
 
 static unsigned long usemap_size(void)
 {
-	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
+	return (1UL << (PFN_SECTION_SHIFT - pageblock_order)) *
+		sizeof(struct pageblock_data);
 }
 
 size_t mem_section_usage_size(void)
-- 
2.54.0


