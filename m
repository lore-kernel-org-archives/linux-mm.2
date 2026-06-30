Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188B4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B42A6B00A6; Tue, 30 Jun 2026 02:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BFC6B00A7; Tue, 30 Jun 2026 02:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D286B00A8; Tue, 30 Jun 2026 02:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E43F56B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:32:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44B781A039B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:32:40 +0000 (UTC)
X-FDA: 84935610480.19.50C1149
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0BDCEA0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:32:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Td1Lrh6w;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782801158;
	b=ofdyK96dbLk8wjIp5bqdI3wwATMkxGKkEdSj8tEJBvqByK9lcaLPPaXDxZ64chjwScHzpj
	OG2rPsPaFPn+KMKHKUOd0i/pkxOWTvxVzLtUUgNAbR4IBiBs1pyx++MqJDYgr4Lm6ALly/
	7/IyHMHThyRJwylPLOA9X8N243UoGEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782801158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KjNfxEY8O5b1YS1IpfKgKUs7d5wF9xctyGq1gJiAwLQ=;
	b=QO5A0ZsmYXZCa7wGMs2Mq/AmeOgcMOZ98U6QvRGa/Lo5klw8P5w/Ox+GVrb15dK89AIFOr
	O1iulP3u/3SmSc09dATgCQ47JTeGAiKCAdF1Arf3cxPha65o85MVqjSSVK2rA+uQigx0xA
	xs3yjqUCqtaomtCs/AAgASPbJi6Vpd4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Td1Lrh6w;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782801155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KjNfxEY8O5b1YS1IpfKgKUs7d5wF9xctyGq1gJiAwLQ=;
	b=Td1Lrh6wryQOdq8Zhf9sDe/8DLzzlATuFn8LitsFOvSOkMiYjqGX5bJouNE/PXZ5h1fM6r
	5YkpDUClM+HBTtFX8Dc188LD+yPIwWycVP+2hQNsR05nVyRYcsKxVKnzdlr9Sd6ErzziEQ
	W/Y3ftiUTVSwaehM7yxoUsVxZKliSuU=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v8] mm: fix ASSERT_EXCLUSIVE_BITS by passing memdesc_flags_t by pointer
Date: Tue, 30 Jun 2026 14:32:16 +0800
Message-ID: <20260630063216.417897-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BDCEA0009
X-Stat-Signature: 1ycw4wusi316wneo9dn83pgrbtnacxkf
X-HE-Tag: 1782801157-399016
X-HE-Meta: U2FsdGVkX18t24yEJvm8GdzyYF9TmAXY9TnWD92tTCLnzuOzSbw+67ww8wF6Eb/D2PczKFH+g5v6ta4LcZrchAyzTvy/YuNWwkCrJxI0pkYFQtqtOhPwIWt3VOEMZ+hrljpSBVbup55uflb38QqGoQvUbXTSW/SlsQOULm6NsxpREEv9q5mUUgj5aJcRIk8Lo8SW50io1byshSkTmM7QeW4PyrBIWc5yVR1RkT++LLRyThElvSZO95XLOpL0v9RPxFLIae5atltK40LLElrXwiVha7ObR581KU+2u+PhRoKgxlOPLIupXyo5Sto+EwBbcqVlPGDrv3bDvoEork8H239SV8jd4U/67YbpZND7T3oE9JcIC6UhqdVyXMWvxatXm1sxYx5Fxoik8Ro5ddV5EsH1y7QGo2j4TGEtL9/Tv5KInyh/54GB/FG7zBb4zG2nxnPsqRrvH4Hm11sR6LHKQaAo9PgWqm36TLQIHj4LWXz0y3AZ/xgcyFKz9L2ymRrQv/IOd5ZIkZVDF2UvgbSX8sPAOwD89HCeSwx8IOy6rdidvByUc4OK9KfSnRCPUYjNOeJfJzOEGPVrb+gNDBoLOWAagC1yJzCwDcCNy1+45IT33MFgBSXhSFu80NfKD0M1MgH4+NMBFNjcbbDBdqCZlheYZZofydqbgSXszTT1ZZ5hmLJJ2nCb5ygxWuf7BtrUKrKUeH1sRkJH7Ej4qxAKfAz/60cCy/LZLBaU1oSjk19U1ZxCX6j0oyj0fN015OY/BpJICYi/TxYJ5f+ujARhhscqSYg7yEMmqgQ6VZjzXqEZ7q6Fzx2NP2rdvj6xP/YJoHc4jDchE0admpiwb5iebx34uj25lN3HVSYUeVmmgAz5NkB2y86CcXRhT5D6uf04jx0visY0Y9z2mUtcnMlw+rYxcqR8P9bLC0zJphU3JFwDMsqXN9/nUk3TC/vyrACcwJM3DW5wjYuenJd8+5p
 lW7GrIff
 y0nLfqNrjSuty26VMQomONwA6WEJkIuEzUom3Vr8X5OUiiwn4/fO0AnjnWClCRm4QhyL0NB3KVvt3Ar8l3ipqJIpIqATpsdw30TS2rJbjgpmnMhYS1rjQgly2BHsONFw10/a1yUhrWMyESHiDzJIYSaVzgqvpGO0WJ9OU6Q0YU8MyV1I0ZTDXhrwTBb0+KJlObpt0WP7sXzPzNx81o2UxCwBeiVZ+3wf5rRUZgMUDlo8BWoHOM55JuMAqzXYonMcv1OMWlnVjxJQ7OX1CmyNN0dNDrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The race is benign: nid/zone bits are set once at page init and never
overlap with PG_locked.  However, ASSERT_EXCLUSIVE_BITS() inside
memdesc_nid/zonenum() was checking a by-value copy of the flags word,
not the live page->flags, so it failed to annotate the real access.

Change memdesc_nid(), memdesc_zonenum(), memdesc_section(), and
memdesc_is_zone_device() to take a const memdesc_flags_t * and update
all callers to pass &page->flags / &folio->flags, so
ASSERT_EXCLUSIVE_BITS() operates on the actual shared word.

Guard the ASSERT_EXCLUSIVE_BITS() calls in memdesc_zonenum() and
memdesc_section() under ZONES_WIDTH != 0 / SECTIONS_WIDTH != 0 to avoid
a zero-mask check on configs where the corresponding field is absent.
Under CONFIG_NUMA=n, stub out page_to_nid() and folio_nid() as plain
"return 0" instead of reading page->flags when NODES_MASK is 0 and the
check can never fire.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v8:
According to the comments of Andrew, include kcsan-checks.h in mm.h.
Incorporate David's patch that switch memdesc_nid(), memdesc_zonenum(),
memdesc_section() and memdesc_is_zone_device() to take a const
memdesc_flags_t * instead of using a per-accessor macro/call-site hack.
Update all callers accordingly and extend the same exclusive-bits check
to memdesc_section() and memdesc_is_zone_device(), guarded by
SECTIONS_WIDTH != 0 / reusing ZONES_WIDTH != 0 to avoid zero-mask checks
on configs without the corresponding field.
v7:
According to the comments of Sashiko, restrict the memdesc_nid() macro
to CONFIG_NUMA, keeping a plain "return 0" static inline stub otherwise,
and re-add a local page pointer in page_to_nid() to avoid evaluating
PF_POISONED_CHECK(page) twice.
v6:
According to the comments of David, turn memdesc_nid() from a static
inline function into a macro so ASSERT_EXCLUSIVE_BITS() can check the
caller's page->flags/folio->flags directly.
v5:
According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
ZONES_WIDTH != 0 (for zonenum).
According to the comments of David, avoid calling
PF_POISONED_CHECK(page) twice in page_to_nid().
According to the warning of lkp, switch the CONFIG_NUMA=n
page_to_nid()/folio_nid() stubs from macros to static inline functions.
v4:
According to the comments of Andrew and Sashiko, set
page_to_nid()/folio_nid() as static inline stubs returning 0
under CONFIG_NUMA=n.
v3:
According to the comments of Andrew and Sashiko, move
ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
into the page/folio call sites.
v2:
According to the comments of David, remove useless comments and use
ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
page_to_nid().

 include/asm-generic/memory_model.h |  2 +-
 include/linux/mm.h                 | 40 ++++++++++++++++++++++++------
 include/linux/mm_inline.h          |  4 +--
 include/linux/mmzone.h             | 26 ++++++++++---------
 mm/page_alloc.c                    |  6 ++---
 mm/slab.h                          |  2 +-
 mm/sparse.c                        |  2 +-
 7 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index efa6610acbc7..f8404bc7773c 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -53,7 +53,7 @@ static inline int pfn_valid(unsigned long pfn)
  */
 #define __page_to_pfn(pg)					\
 ({	const struct page *__pg = (pg);				\
-	int __sec = memdesc_section(__pg->flags);		\
+	int __sec = memdesc_section(&__pg->flags);		\
 	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..315d8917f8e7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -37,6 +37,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kcsan-checks.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2286,23 +2287,45 @@ static inline int page_zone_id(struct page *page)
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-int memdesc_nid(memdesc_flags_t mdf);
+int memdesc_nid(const memdesc_flags_t *mdf);
 #else
-static inline int memdesc_nid(memdesc_flags_t mdf)
+#ifdef CONFIG_NUMA
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
 {
-	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
+	ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
+	return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
+}
+#else
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
+{
+	return 0;
 }
 #endif
+#endif
 
+#ifdef CONFIG_NUMA
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	const struct page *p = PF_POISONED_CHECK(page);
+
+	return memdesc_nid(&p->flags);
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
-	return memdesc_nid(folio->flags);
+	return memdesc_nid(&folio->flags);
 }
+#else
+static inline int page_to_nid(const struct page *page)
+{
+	return 0;
+}
+
+static inline int folio_nid(const struct folio *folio)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_NUMA_BALANCING
 /* page access time bits needs to hold at least 4 seconds */
@@ -2541,12 +2564,13 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
-static inline unsigned long memdesc_section(memdesc_flags_t mdf)
+static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
-	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
+	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
+	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
-static inline unsigned long memdesc_section(memdesc_flags_t mdf)
+static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	return 0;
 }
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a8430a7ae054..efcddb9925ad 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -650,7 +650,7 @@ static inline bool vma_has_recency(const struct vm_area_struct *vma)
 static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
 {
 	struct page *cur_page = pages[0];
-	unsigned long section = memdesc_section(cur_page->flags);
+	unsigned long section = memdesc_section(&cur_page->flags);
 	size_t i;
 
 	for (i = 1; i < nr_pages; i++) {
@@ -660,7 +660,7 @@ static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
 		 * In unproblematic kernel configs, page_to_section() == 0 and
 		 * the whole check will get optimized out.
 		 */
-		if (memdesc_section(cur_page->flags) != section)
+		if (memdesc_section(&cur_page->flags) != section)
 			break;
 	}
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..e60dad546ca6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1272,31 +1272,33 @@ static inline bool zone_is_empty(const struct zone *zone)
 #define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
-static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
+static inline enum zone_type memdesc_zonenum(const memdesc_flags_t *flags)
 {
-	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
-	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+#if ZONES_WIDTH != 0
+	ASSERT_EXCLUSIVE_BITS(flags->f, ZONES_MASK << ZONES_PGSHIFT);
+#endif
+	return (flags->f >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
-	return memdesc_zonenum(page->flags);
+	return memdesc_zonenum(&page->flags);
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
 {
-	return memdesc_zonenum(folio->flags);
+	return memdesc_zonenum(&folio->flags);
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
+static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
 {
 	return memdesc_zonenum(mdf) == ZONE_DEVICE;
 }
 
 static inline struct dev_pagemap *page_pgmap(const struct page *page)
 {
-	VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(page->flags), page);
+	VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(&page->flags), page);
 	return page_folio(page)->pgmap;
 }
 
@@ -1311,9 +1313,9 @@ static inline struct dev_pagemap *page_pgmap(const struct page *page)
 static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 						     const struct page *b)
 {
-	if (memdesc_is_zone_device(a->flags) != memdesc_is_zone_device(b->flags))
+	if (memdesc_is_zone_device(&a->flags) != memdesc_is_zone_device(&b->flags))
 		return false;
-	if (!memdesc_is_zone_device(a->flags))
+	if (!memdesc_is_zone_device(&a->flags))
 		return true;
 	return page_pgmap(a) == page_pgmap(b);
 }
@@ -1321,7 +1323,7 @@ static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 extern void memmap_init_zone_device(struct zone *, unsigned long,
 				    unsigned long, struct dev_pagemap *);
 #else
-static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
+static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
 {
 	return false;
 }
@@ -1338,12 +1340,12 @@ static inline struct dev_pagemap *page_pgmap(const struct page *page)
 
 static inline bool is_zone_device_page(const struct page *page)
 {
-	return memdesc_is_zone_device(page->flags);
+	return memdesc_is_zone_device(&page->flags);
 }
 
 static inline bool folio_is_zone_device(const struct folio *folio)
 {
-	return memdesc_is_zone_device(folio->flags);
+	return memdesc_is_zone_device(&folio->flags);
 }
 
 static inline bool is_zone_movable_page(const struct page *page)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..020a97ca018e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6904,15 +6904,15 @@ static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages
 			continue;
 		}
 
-		if (start && memdesc_section(page->flags) != start_sec) {
+		if (start && memdesc_section(&page->flags) != start_sec) {
 			free_prepared_contig_range(start, i - nr_start);
 			start = page;
 			nr_start = i;
-			start_sec = memdesc_section(page->flags);
+			start_sec = memdesc_section(&page->flags);
 		} else if (!start) {
 			start = page;
 			nr_start = i;
-			start_sec = memdesc_section(page->flags);
+			start_sec = memdesc_section(&page->flags);
 		}
 	}
 
diff --git a/mm/slab.h b/mm/slab.h
index 281a65233795..9ded319495a0 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -179,7 +179,7 @@ static inline void *slab_address(const struct slab *slab)
 
 static inline int slab_nid(const struct slab *slab)
 {
-	return memdesc_nid(slab->flags);
+	return memdesc_nid(&slab->flags);
 }
 
 static inline pg_data_t *slab_pgdat(const struct slab *slab)
diff --git a/mm/sparse.c b/mm/sparse.c
index 16ac6df3c89f..8e3847764513 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -43,7 +43,7 @@ static u8 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
-int memdesc_nid(memdesc_flags_t mdf)
+int memdesc_nid(const memdesc_flags_t *mdf)
 {
 	return section_to_node_table[memdesc_section(mdf)];
 }
-- 
2.43.0


