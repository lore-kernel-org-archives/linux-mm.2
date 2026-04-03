Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 550C6E85389
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9E46B0099; Fri,  3 Apr 2026 15:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03D46B009D; Fri,  3 Apr 2026 15:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850D76B009E; Fri,  3 Apr 2026 15:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5D46B0099
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:45:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30D07139441
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:45:42 +0000 (UTC)
X-FDA: 84618274524.04.354AC57
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B2D31C0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:45:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GA14Biow;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZDKS+2UEWGGUQvutFTKKX7aGJWc4H9jBwlNlNV8t0Y=;
	b=BNN8eZkB7+As0ec7Ro0fTMhlsvhASjeWQ48CPJcjLcLKZXX8O3LEH9GPwMiaRPMxrI82nS
	Nqn3hArF1UMVOHqmR5wvUxHZQ9rLIpS727r8P1HKo8xhwySi+HgFvPEumhMtTc4UNo8LIl
	FGBsLP7H56xCViS139EuoTu4vn1VP94=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GA14Biow;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245540; a=rsa-sha256;
	cv=none;
	b=hDNcemLyV3APW3uw8A1f9EOdBCJA/P0V4nNWBOvbbLudqLc5tQRizH3gSCgNRnIu8fBPRe
	eDWgMVcCGQocB5VbzvbRnwmVZbFqIj2QDkdtpEFtTdhgv5EwwxlFsv1rj8DTVY9lsogo3c
	OKAvUm5zoey9WuoHsyM1VdyKQqPpI+w=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a15ebb3abbso32334276d6.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 12:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775245539; x=1775850339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZDKS+2UEWGGUQvutFTKKX7aGJWc4H9jBwlNlNV8t0Y=;
        b=GA14BiowoDLDEjeyqPsIIqPj2rD9PbnwoorPjPw1OZrcH4Z1KcnrMj6Ne7NQjYjUw4
         nepdCYWkaBJCNtsA8tJ1MUUmGdH+MZPr8EGypqN1KRh6bWa/aLrJoZ5JOgz3h5+eaKUv
         j6RCH1apcgxvfz5IpI0PNP2WMGC9cOta6D+LB+axY7I2KSGLiVfwwy4QX+dtYky+8rGS
         ma+pU7wblVoc6P668SDe/W8ZmUsnjAuEgNWhMIGlh+S8voYVNVDWerXB43xC6NMiiM69
         YjObLdI0j5vv/8L7ThXMxwDOvNsdvNRLJqoCJpFkZ1Zkxi+G9i0ZztnRQeyj5AN50Qep
         1D+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245539; x=1775850339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NZDKS+2UEWGGUQvutFTKKX7aGJWc4H9jBwlNlNV8t0Y=;
        b=U2iS5Ljh6hMqa/rjJPdU+BAB8BSUNo/ssEiffyznULP8gCF1ma4KHtv59fF0mm7P11
         Tp4+j6Y+E1gpJcZevSDU/+R7X5U3CPLvNfFcqf3LRGmNaJh7xb/aXFq2w6OvNfxcFRVy
         5uqRGvEsL8YPehgfZxKg/araRUekZcRpBBJeuoQ+e6bSFpjY6GHdVdHkVxlP0jsA6bWn
         KOtM0uhmrjKJgcN/KZs/2qacbPdJ6WOb4JjTnUq5ZyZA5ttSs3os970RI5d70hRalItY
         wKvY3EZAYRkW5b80BIOxWSK22ePOf+w78SmYU1SPbtsv3WzoNE5PsiOgSSzjz1mKivue
         lTww==
X-Gm-Message-State: AOJu0YyqEvvc0E18+2xHFzCx5BhxI3lFkR8Lb/kEd2ev7baqFozVKf5i
	1qaUBlCKJH86HeRRo4B0vFCkXtbXDIBVO6RzjT0E4PH7qTWUq855ANwk4c7MDwMCt6iJJTbnBub
	BTw07
X-Gm-Gg: AeBDievR6zbltp5FjTIybLyPOWAY8NlPYcV3soFOPjjeAv3U26+oEC8JbRN/BYS22kT
	k3WNxaQ54pVePjWuJy+werqRHUJtrAZ6lzeOQf7RxDKOY67IOlOC9j3mCUiUqnwsCfA/gc6ISzv
	F1Di7OXKdp26wiKELFlTKNM2X9pdAXDuUZZezG2q5MC94viBSFR19UPZQmAIsfo3ydnxz5XZyap
	C1+GuCPQR03Nt+i7JXQYkcB7p+yQLTiH3ergX/QI+iDtuwkMn6SRdkPIhyKVuy2aOedgCb+XXCD
	M2H7e3O1e1cvRrT2lHMBPYLeFUZEo5Bhu1vPsAj0jJOXaoHunUDs3jxxWXlvwaYktHCDCBVd79d
	L9i4J2KU6b3M1fhLX89jdANllqgFMv/6dZOjovfvEU8cI4IdBv8g63NlaQZczNo3OquoISz//z1
	JBkW/fFjv9bhAH8KLl+Hei3g==
X-Received: by 2002:a05:6214:1947:b0:8a7:14f5:4552 with SMTP id 6a1803df08f44-8a714f5470cmr65276626d6.30.1775245538932;
        Fri, 03 Apr 2026 12:45:38 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a597acf5dbsm53958766d6.49.2026.04.03.12.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:45:37 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	linux-kernel@vger.kernel.org,
	Johannes Weiner <jweiner@meta.com>
Subject: [RFC 1/2] mm: page_alloc: replace pageblock_flags bitmap with struct pageblock_data
Date: Fri,  3 Apr 2026 15:40:34 -0400
Message-ID: <20260403194526.477775-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403194526.477775-1-hannes@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B2D31C0007
X-Stat-Signature: epniwadrzst7rs46cj3au484re1pggge
X-Rspam-User: 
X-HE-Tag: 1775245540-509482
X-HE-Meta: U2FsdGVkX18DFaDo0F6Fg7U2p+wfvgxSowLkNaLh9PdE3BtZGbJH83r+0c61GwP8VCJCTI2Zy+wm7B92bkFejZdEakGjkvxaycME+YRdZY2tjvBhhubqBeLbMxBDWSjpyztD8G7lSoqRAov3zWnNgX+L/KUpayPZ1E1HwIbZyLUCroeOaw9mBEtsq/apX+8CpzrnGAoefvspwLFdwVNNOJroc07GkSKW7njlXzAAt0a8UZSQgXuICkO0W5B6q1hrW6hJDAI/wTZ5IeU9G60Jjgp+lGiyzIsRiPXwGZN631JLRbHhrM+kr2QdVuupA7Um1IDRahQkCAX8frG7Y3oyi++HkrwfHH+5A+GormimsIBmQOfwvWUhEtFe7+KgBH8BOEvbfHbmEDIdm413M6QsMmcVIeGEM0eUujGSH8KFGdLKBzn+rHjA0/ehaG5zeztCzE/r8aYCw1kraBs1x3fPQzPoMxCgQ2+hP7xgBDae0k67Iab0Pi+TaEuX7V9xL7AJxO5zQlGBZ7WfSCH+2erKWzMnKPeMbcK2jjR3VqbF5foZx/7ulo5Z5PhvNFf+1D7ONBRpFAitz8y6z0gxsMivgJ7ZtxjCVGLrJG4JA9Qnvh93uKyIwmjfn5tiIKcW/cx5vZ5tqJ0nlP/GCCRNR2GGwlvF4lw6kjpdyCzTeZ2H0ZcnkUjYw3RD1qKqEGTtlA9FhcUTmOsOjilnODY8Y2G5r+wXQrOy08et9B5UqXiEzmHHD+sYKdtqWwBJ5XI91B6uW9tLvbWzRlsuSDxA0ADB+z83bh10ZS7yDewEftIQd8A/tjuConMr9r5y7QUh9+CEwnp9MsRvoDSnw3aB7VwtnJzKsNb7YaIWYO1guHUyXt6GWvq1e1/KFom9U6gjP7qPoPbMUMfYxAaLCF0eOySkS+cjM1zXDIS6SxhjmRZTsZ9Fht6EWZokKy6gaNZSdyG/ms7ti3W2VFKKKXgO6/a
 jT9f55e6
 j+euCcJTPjsMDlICEtj0JqEZn8n1hGsk4tVn6p2dEnB0bahs63RW6azyS9qI9hECvWHjv5Zea+zqkKHQ=
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

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mmzone.h | 15 ++++----
 mm/internal.h          | 17 +++++++++
 mm/mm_init.c           | 25 ++++++-------
 mm/page_alloc.c        | 81 ++++++------------------------------------
 mm/sparse.c            |  3 +-
 5 files changed, 48 insertions(+), 93 deletions(-)

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
index 2d4b6f1a554e..900a9da2cbeb 100644
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
@@ -493,18 +450,12 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 static void __set_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 				      unsigned long flags, unsigned long mask)
 {
-	unsigned long *bitmap_word;
-	unsigned long bitidx;
+	unsigned long *flags_word = get_pfnblock_flags_word(page, pfn);
 	unsigned long word;
 
-	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
-
-	mask <<= bitidx;
-	flags <<= bitidx;
-
-	word = READ_ONCE(*bitmap_word);
+	word = READ_ONCE(*flags_word);
 	do {
-	} while (!try_cmpxchg(bitmap_word, &word, (word & ~mask) | flags));
+	} while (!try_cmpxchg(flags_word, &word, (word & ~mask) | flags));
 }
 
 /**
@@ -516,15 +467,10 @@ static void __set_pfnblock_flags_mask(struct page *page, unsigned long pfn,
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
@@ -536,15 +482,10 @@ void set_pfnblock_bit(const struct page *page, unsigned long pfn,
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
2.53.0


