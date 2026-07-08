Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C9AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFAD6B00A6; Wed,  8 Jul 2026 04:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8156B00A7; Wed,  8 Jul 2026 04:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7006B00A9; Wed,  8 Jul 2026 04:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35D986B00A6
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:33:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B80A6169130
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:33:37 +0000 (UTC)
X-FDA: 84964945674.01.D320B8E
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5A0821A0008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:33:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PseGBrzB;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499616;
	b=vjIq+uTz2tFciX1ala6mUmRXcTZBTYuHPk0wstlTN/dIaD149WDpcQCNPHu4SrB3L+ZhMR
	LIBAKL1Z0nX+3MZ8/mwbzGADtePgZm+RciXMwHz3YNFmOQoJCf6K1jSJt0ohoS15G2rqBP
	vmQqvCDTo0tj27AobLNT9LUy2cM3M9s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PseGBrzB;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JW5JEUeCiCNPrgnC777UIjHkHnm2y4HPFsAEmIHgkEY=;
	b=ec00PsmuUoNmnT+tgOK6pUGPu9rJFxxQXP/GnmlkWtsReOfd7mlBKRgbiBZOo54rTnSOEn
	gd2+2to2hZTQb2WBiL01E0Epp7iVq3ee91BqOCZPEqMdLaB5mZIyhwLKkynhwKaCfwhSek
	9eovCz4NfMTObPKmtlV6lINHAcGnb4A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783499610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JW5JEUeCiCNPrgnC777UIjHkHnm2y4HPFsAEmIHgkEY=;
	b=PseGBrzBpqhFv8XQVBPlJV4PFWduubH1JFqJYJO2NUcbLNT30I4pfioNQhc1D1btSsPENG
	C8edf5nBm8uQGA0OBPUDrtvnDdGmWwu325owJ5UMpnLxLsiHD71Xl/pJBk3oab1BrbqVbm
	5EmADIW6yhL0cSxzBbUgM2FjdA0THiA=
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
Subject: [PATCH v11] mm: fix ASSERT_EXCLUSIVE_BITS by passing memdesc_flags_t by pointer
Date: Wed,  8 Jul 2026 16:33:08 +0800
Message-ID: <20260708083308.747930-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A0821A0008
X-Stat-Signature: seguatfnrmdpqxchdget4yhewafdd1hz
X-HE-Tag: 1783499614-507488
X-HE-Meta: U2FsdGVkX18FsEbfp+l4EkawFGpHGTI6HVPE+1c5wcTdBb5pndanrxO8S77ccU2QEGRo0kMVKngivlExyOE1eMMiis9BmexsEFpRXIbMYse7CN3WHWqgV1ZwZrkbm4jyC4YNzyyQ7wCixQcyj9SMCZ/K3RUSxM6DFd5bOwHj73h2AU1YcLLRbc3IeT+s9REJCLD9RLvOLIGqL+u3xWaETfr0Dsyp1j3ys9fs+idjxGmIIyVHdCsq8cN4iXnzPBwDn95zhqjfYOM+HmqY8CodeYB3otNFHujzdWNI9dGoFV4xGfbu2f1AonpcsqZejxxNv1y+KrkvTiMrztRSa4yuauqDSS7oLBFmxKb5NuF1EPWchcKZzhELBVIGBDKbqSVF9P3pahXDv7ACWuzr/xYSsm6rRtJ4LyW7Q+HW1uAliQrAEPoKBscY+eyNftf2jUl7FM8x7o7BPCHzKICwaAjKerJ/EmHH/hggpTsECnmG6PL07uqzLtq3sWc9KtqVYs1Bh6lHEcVPpPpgWnCYxHEroqGBpTF1B+fio1SmWEDnE9Ae1vC1GT0rtCqvfP2dfzsaB8kF1qrVONILymwDyDSynV17SBEYBGPoc7WdjwPdaTnLrCWCDlRg0eaOWuGzQL35in+0CJEYzGUFV0kVNeNPEF6r0ixgAFWmVfcNykN2L0FQNkJEF+QqjOAuMeFhgQJIKkq5DltT/zaIqBEbJeHqMcdcxTfQTcg5ink9K5dsvUo0Gd91QiSxyO9UPM+/c9pxC1w8TGECoHjXq7pTkCeniB+h4A8mv5pDNS0Lo0/y2PlxOj3hGr3MrY/8XTMFfsFPtFvEVcrd0OzO47Z+9PLuYMeDQM/v4c/M7aaEwiwO2yYOzMhtE5j0UttMytNScAdxC1EXpYPaBqM9ig0dYoo/l7+Dm63oUEVWzpPTu3wt/QOsVmeKmFtGdUwV+D9s1WlL2vXSq0A0aml3k3Gah0M
 njLzHLu+
 ekVd/CxvXwjMa/T801CdbxLZEbYNUxWOmJtGrx4ZlvoLtxIztfYBkK2TzCji4m1OajuvqWHDhZ2tCW5MivXoAQLmOfeMI85TRs0dniD91QCJ6xXC5ZPAHxhI8u3iODpJYcjoeqQEfIodnNzA5vlMi30k8nh2Lde9V+v+uG7heO3Dz0bnJfAlL+tC1JNFqoJfxzVeEo0REgvirr//RGYdrz5y8mv2GJhdTqyFMGEylC3a+l6TvgbEZwwFw3CCGtcp8YNmHfqCBywkOIIBMeA6tot5U3w==
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

Guard the ASSERT_EXCLUSIVE_BITS() call in memdesc_zonenum() under
ZONES_WIDTH != 0 to avoid a zero-mask check on configs where the zone
field is absent.  memdesc_section() needs no such guard, since
SECTIONS_WIDTH is never 0 wherever SECTION_IN_PAGE_FLAGS is defined.
Under CONFIG_NUMA=n, memdesc_nid() itself is stubbed to "return 0"
instead of reading page->flags, since NODES_MASK is 0 and the check
can never fire; page_to_nid()/folio_nid() now just call memdesc_nid()
unconditionally and rely on that stub, instead of duplicating the
CONFIG_NUMA split at each call site.

Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changelog:
v11:
According to the comments of David, simplify page_to_nid() to pass
&(PF_POISONED_CHECK(page)->flags) directly.
v10:
According to the comments of David, drop the redundant CONFIG_NUMA split
in page_to_nid()/folio_nid() and remove the SECTIONS_WIDTH != 0 guard
around ASSERT_EXCLUSIVE_BITS() in memdesc_section().
v9:
Add the SECTIONS_WIDTH check to memdesc_section.
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
 include/linux/mm.h                 | 26 ++++++++++++++++++--------
 include/linux/mm_inline.h          |  4 ++--
 include/linux/mmzone.h             | 26 ++++++++++++++------------
 mm/page_alloc.c                    |  6 +++---
 mm/slab.h                          |  2 +-
 mm/sparse.c                        |  2 +-
 7 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index fd74de50b054..c6b4eafaf4cb 100644
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
index 2101e5205fc0..3dca9497ae03 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -37,6 +37,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kcsan-checks.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2286,22 +2287,30 @@ static inline int page_zone_id(struct page *page)
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-int memdesc_nid(memdesc_flags_t mdf);
+int memdesc_nid(const memdesc_flags_t *mdf);
 #else
-static inline int memdesc_nid(memdesc_flags_t mdf)
+#ifdef CONFIG_NUMA
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
+{
+	ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
+	return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
+}
+#else
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
 {
-	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
+	return 0;
 }
 #endif
+#endif
 
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	return memdesc_nid(&(PF_POISONED_CHECK(page)->flags));
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
-	return memdesc_nid(folio->flags);
+	return memdesc_nid(&folio->flags);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -2541,12 +2550,13 @@ static inline void set_page_section(struct page *page, unsigned long section)
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
index 242ec3cb8b52..0507193b3ae3 100644
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
index 8a5c93fe1c41..a63733dac659 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6998,15 +6998,15 @@ static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages
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
index 324213d8bdcb..058ef9300367 100644
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


