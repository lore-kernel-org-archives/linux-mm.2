Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A350BCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80906B00AF; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972186B00B0; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F2E6B00B1; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5013C6B00B0
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EDC7120170
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
X-FDA: 84716346498.06.5EBEB60
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21C7DC0003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AjtLOeBm;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwPlb+Xplv4fDZcxIw9EYiar5WEKWlmzR0GREvO3N3k=;
	b=V5e5ntQwJwdlxafMuLP+JWt6YWVY/V1XKaavlOG+vutD1ro3j5GEucBdi4Uvakv1sUzFmf
	s+eSJ1oWIFB94mP8VbTkkas5OlMHS0xgh6cQNp9YMiQteA6ZoKQJzPExMRoDmEZc0G2obn
	q2DYogazEc1dmFpnZeORaYl/9wljkqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580587; a=rsa-sha256;
	cv=none;
	b=2GRmWhNBpyc3aZgOp8I7HprOKjmZgs2qBSsWEXHXZcvcFj1CC5Q1m5NnSVcA2OkTl8hKw5
	VxglOAj0eel89R0/Rpb5NC3lQjBfhX2rkLf9L2YgI1siprKbltF5xgkUEPDkefjXfyrFsG
	EzW8lV3uMR5D8wUbug1I5N/r7BaB1Go=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AjtLOeBm;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cwPlb+Xplv4fDZcxIw9EYiar5WEKWlmzR0GREvO3N3k=; b=AjtLOeBmWtYybCuUwuBOua56AS
	R/7kyemu2mYAjuo09zC5ACye6CPK3pwWnfjiHDpmq/Ic+aY3i/oSac3SsbrYTbPb04waXRZ1OIw4c
	KxViDNEDns/EWaxYJ6IV204vE4RhiAhfVVT8HZZFlNaKyf9/f89A8Wr7Tzl7UfQe8cjgpjjw2SkVS
	BqNZ5hNej0vVCKHOqtblclrLTnKxu2G7CqLGHuJ2Q50tpCG78fJ+6zrpp9xTjF3txYy3moF8XZ4RQ
	TT9cHVbSA/HEaHchz6PAzsevf3FZlmJP3cW5YK7iwMhGA65BkUItpLNLuE1X+C5ht/v7KPhk8NYvJ
	hKkSsz6Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-1r2t;
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
	Johannes Weiner <jweiner@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 01/45] mm: page_alloc: replace pageblock_flags bitmap with struct pageblock_data
Date: Thu, 30 Apr 2026 16:20:30 -0400
Message-ID: <20260430202233.111010-2-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 21C7DC0003
X-Stat-Signature: 33myhr6ny4cgdwyyaz6b4enyjg6ceg1n
X-Rspam-User: 
X-HE-Tag: 1777580586-956084
X-HE-Meta: U2FsdGVkX19XuHQfhBMRMRbrahHeSlUAn+xJRPIFlU8dgIZDVVH6aIOZMqe1zIEtcW7ewHWihKDY4gaFLBla3oq/0hYb9axpaOZf+veJLTZvl0WtaiAcpJape06q6mMV4dy3wDGdu385ukEHivn0aIDILkjapTdXcWrLvEXZsfaY/uwg9WeajccmEM6OqnwKzjKOTrIsGjuavussEv0aygvENCw5dBl7pN2Uo10Yz0dh2rhAe2IPYx75VCTKsjo92Rarot8bwwJ51zQumtx0+5V6u/JqwWiASxlcIgKXC8Io9ODArlvS4iwYw5AyK5oq5tiVPkUqIHXD1NbksxnAWyj3Zzm1+PDd8uqLxoaggwI4Iiz7fJZtPlBU+PMrtyTUkIHCKooX3F6h/ZYvMgtZgrgzBFZ+xtq6Hi9RT37V+3b7NWqD77yuBMNU3JuWPmMY+1Fsbb9AiKoWchcYOM3IVDMibqWQdn6m9HIFXwW+JqGJsFjnQ7DlW15Vk2fc9o7IS3kWghmpssvabuq3dm/T6iMM6z7iWueXhTNyzCKvtPNyVN2fl4FWQ9pakdnqBESrkRWMJUyF1BzmzKLvwj7GtK0oobAXgeVUtOytlYy5htACaziF1ek26/8s1voyj/Cd2yC6n/Iw9zF/FaRglJgq/m40gyQ6YQqjHrQQ1lbfMrj+UjOA9F9CXSTA1fxwYqM27+05hv0m9dXPCgNhlP0dyzwNnxQ5XsGSfzyBYU/jmqg6vopqhf+hXcLiySlBKzEU5w5LJrbDiuquDEZDotC//qHmKqx+quaYzPSZkWCxJfXF+C28tN1RZgrs5I1rqLWDoP2DzPJqA44G48zotwJ3158iSJbIxxtFX4XeDen9B7Y6FG3DDBHYH2wN29jWxRDKsY0Uf6bN64wT7bqULi0QmuA6fPAhMpBp7qei7ZS6Pf7X7UCp1MaB4GOUZtptGnQqleiWgSevtt9J6lbX37N
 Ck5QUlyt
 Ss7f0hlHkYZ9/TKpose3Ui79VJouPll5Zpl1085tL1sGSRJDDzrvlJs4aYoucLERfq21wRemVFUtrEMPplLDYYmY93doBEHZYbg+OPSsSeulvQ5M7xNu37hU5xMglMHHCMmR8STxNfacBDK4o9x1oTWH/aopUXygvFGqMXu5HY8OK65aFVRcApdtlwmNSQ+kI+ndm/TB9iOajW267yQZNj2/hiZWuCPul80ZkGrAloBHElX3Bh0jwRd07LtRW2eZb9mVEjYo9Pskg7jjhfw2coHstSNj9h1Ju7Ft8HTktDLvpopNJ2R5QSuRrYTfKedJLOC2XJmmk0nhH5+aBDFMgOQQHBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <jweiner@meta.com>

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
index 3e51190a55e4..2f202bda5ec6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -916,7 +916,7 @@ struct zone {
 	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
 	 * In SPARSEMEM, this map is stored in struct mem_section
 	 */
-	unsigned long		*pageblock_flags;
+	struct pageblock_data	*pageblock_data;
 #endif /* CONFIG_SPARSEMEM */
 
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
@@ -1866,9 +1866,6 @@ static inline bool movable_only_nodes(nodemask_t *nodes)
 #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
-#define SECTION_BLOCKFLAGS_BITS \
-	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
-
 #if (MAX_PAGE_ORDER + PAGE_SHIFT) > SECTION_SIZE_BITS
 #error Allocator MAX_PAGE_ORDER exceeds SECTION_SIZE
 #endif
@@ -1901,13 +1898,17 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
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
 
 void subsection_map_init(unsigned long pfn, unsigned long nr_pages);
@@ -1960,9 +1961,9 @@ extern struct mem_section **mem_section;
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
index cb0af847d7d9..bb0e0b8a4495 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -787,6 +787,23 @@ static inline struct page *find_buddy_page_pfn(struct page *page,
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
index df34797691bd..f3751fe6e5c3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1467,36 +1467,31 @@ void __meminit init_currently_empty_zone(struct zone *zone,
 
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
index 2d4b6f1a554e..45519be08c9b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -359,52 +359,18 @@ static inline bool _deferred_grow_zone(struct zone *zone, unsigned int order)
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
 
 
@@ -421,18 +387,14 @@ static unsigned long __get_pfnblock_flags_mask(const struct page *page,
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
@@ -446,15 +408,10 @@ static unsigned long __get_pfnblock_flags_mask(const struct page *page,
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
@@ -493,18 +450,13 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
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
@@ -516,15 +468,10 @@ static void __set_pfnblock_flags_mask(struct page *page, unsigned long pfn,
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
@@ -536,15 +483,10 @@ void set_pfnblock_bit(const struct page *page, unsigned long pfn,
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
index b5b2b6f7041b..c9473b9a5c24 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -298,7 +298,8 @@ static void __meminit sparse_init_one_section(struct mem_section *ms,
 
 static unsigned long usemap_size(void)
 {
-	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
+	return (1UL << (PFN_SECTION_SHIFT - pageblock_order)) *
+		sizeof(struct pageblock_data);
 }
 
 size_t mem_section_usage_size(void)
-- 
2.52.0


