Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D4BCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7856B009D; Fri, 26 Jun 2026 05:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF776B00C3; Fri, 26 Jun 2026 05:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5B56B00C4; Fri, 26 Jun 2026 05:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 709EB6B009D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:10:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBDE88D972
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:10:05 +0000 (UTC)
X-FDA: 84921491970.07.1ADD91D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1DCBB120003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:10:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAPd9NEG;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465004;
	b=4qB+Wk0QH8QCfHJWrSLp/TeOn5O9pI+kpgnMlTpGSr8BnK5QzcgAVCddLlag8F2HDokVzA
	ICTwuWSbGLPzhoaOX6TMDG/wbNJ0NI8f0n5eQntE7hYAWeEYemysmCKPyxpY9nmc/VTXtY
	TU3Sw9cI9LLF5gDT8Hit0lRdo7ckpm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qgh7jq8hOPxIw6IuMTb/wxIsRLpeLI/zJPgah7TR+dk=;
	b=QkE8puei15xgLZCq64j1TGr5N320iffy7DoVl7QUXyOFAZU0BCrB3cbdlFT9+8wypBPAMv
	4/joVYsP5x8YgWgRBiG9MO7lkeGeB2o6HavV2FKFAcD7sxscoTAMPXtVnNt8wrWG1283L5
	5NFWOM5BrJ0tBWoqd5b1sLNoJF8xB1E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAPd9NEG;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4643043F70;
	Fri, 26 Jun 2026 09:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AF91F000E9;
	Fri, 26 Jun 2026 09:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465003;
	bh=Qgh7jq8hOPxIw6IuMTb/wxIsRLpeLI/zJPgah7TR+dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NAPd9NEGGHGh3n6TeiTjy3pksVrolG9U+WluqwXZObPngFxHsNc7itjOCBAunxJpQ
	 4CopfFPzsC5G9dk8hwsVqD3hgponoSpbLiPZvB4ZEPH2SeRoumMnM06jDL4plhpW/Q
	 PDuqr03gdxc7Y5ODOB87pWpTX70hwNj6Jsdg0j5mUHVIf1b3KvASHz6+Fy8TTF8Hyq
	 Kh8RoAwSsfbuRCQoMRLK7R857Dgwf2oqjptFP9cfOAW7u3E8Ayrk+lETq5TX3poF/2
	 0C4mR7nlVZ9RLKJqcJq47Ch/9fxmNnywCoUSFkegEVBERBFnO+tOryfWxv2BgJwofh
	 Tp8uIgOdYx6OQ==
Message-ID: <e46ba0c9-6a24-45e5-99f8-b4f454887f50@kernel.org>
Date: Fri, 26 Jun 2026 11:09:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: Leon Hwang <leon.hwang@linux.dev>, Hui Zhu <hui.zhu@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
 <925c8686-9ff6-44c1-9780-63bd7cd8a1c3@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <925c8686-9ff6-44c1-9780-63bd7cd8a1c3@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1DCBB120003
X-Stat-Signature: bjes8k15xwbhawthzgdnpfp9ubkrnz4u
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782465003-557256
X-HE-Meta: U2FsdGVkX1/sTJWIgEeJnOtLw6yXNfj5d+7hX2fR3g+9LWigxdyI3LkKvo3wFDO9VvNv1DnDa7wpheY4FNwJDlKq9L5KUawfnslrt7dIp47OU/7+N8QKjVT20HL88uct3OE3P8dFoJwiolFkugybDcXLr+F9H8k2Vg95NtFw3JBgPNgHvp5KeqDVN73LKTjChy4xhgyChU5CXoTIOtf+d8I55fU1f3C8es0hh502Itcv2YRfGCYP6WZLr/QbXCl6yhAeHl3Ly7iHfx9fTxaxsKrAbI54zMbMnG+hVXc+dEpH32oL6hkw0Z2nXBfdqUi3tZ2Fow4z/5Y4I3HWK7pB/foWeFCPwg1U36DXG0pohdV3/BMt7pXXx4zCrSP7/cZczUVH83w/MYW3FLZApVoDe9x0BRmQ/FIsf8bEc1EVXQ55wO3shrJKaHwsT/4y93o0Pk1o9ZQ3AGVLrucEUIiEp9bFRQBgXMJR1l+A6VNqHOo8p82dSJc6Ac1sZEBGt7psu1PqVtKY/3O4fF+L9G1psppyPa3nAcnUjFvlS+8IyAm0nMQN/PxN7A+fjuBtS/wvp3//b7COJxRDYGf7KRlG5+NfIFslR7Lfkax9g5SMK6K0vjHeQq1kmXTGrMIT4RdFN0z6uInhUbZFV9T7io+/WI5a8FuSjH2N7SMlP4benTzynvTK9jHwBuNa7LjIWMtgtBd6BBtbBRvpHufU32nQr8USPkTlLF5289J4q53KFhM/ej74qgMLUrP9Y4qrYk7OIWAb6m80ZqS7zkGkN1lpsjFUWoLd1X0ElYH90rBW73CkOBBRtD+vB1QfeX0wTuF20EwoKzPLkURTLO8brpKO4QazKFrKFMoOmj9kdQqAdNMUuEPixnIavk3qzVDWzY9Vgz1cfEUjzIrst2egzscXBlIyJXGRcNeve88PTVJZr7+xfHRYdsoJwl3xRxA1+afOqWQwgoz1Si31zT6V3bq
 0R8k3DpD
 j5jxbKmspf7qk1+Uwe24/xPR41qWy2XYANZtudxT6FI1vTmLIkUxZU6lx/M9xCnCAxo905E1TVUc/VCLtd1L3k3QZa3za0XWm4xEbcGIbHa0RTIznkBpy2pWLwv54jQXBO4lNMaLQlUT06u+RVPYT4WQglBfoMIG7xRGnrAWRBm6ou2Yhrv5u/x1hQcw8FPD8dGq1v8MGcG0VDmOI+QdDzqeYoXuIi2FsDi0QDA/edZVI7QaB9Jq9oupuVUE0PgN8VKPKbXl4dQczUqdK7+vx1TPcUDF102o9Yf06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>  
>>  static inline enum zone_type folio_zonenum(const struct folio *folio)
>>  {
>> +#if ZONES_WIDTH != 0
>> +	ASSERT_EXCLUSIVE_BITS(folio->flags, ZONES_MASK << ZONES_PGSHIFT);
>> +#endif
>>  	return memdesc_zonenum(folio->flags);
>>  }
>>  
> 
> Better to factor out a common macro alongside a comment for these two '#if'?

Yes.

And while looking at it, doesn't memdesc_section have similar problems? And
there are other callers of memdesc_zonenum we wouldn't handle. So the
macro approach is only partially helpful I thing.

Maybe we should just pass by reference and fixup all callers? Ends up the cleanest.

Untested:

From fb9b4e8c1d0419b960dc0cd4738d19d80d1fe14f Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 26 Jun 2026 11:06:39 +0200
Subject: [PATCH] mm: fix KASAN memdec_flags checks for zone/node/section

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/memory_model.h |  2 +-
 include/linux/mm.h                 | 23 +++++++++++++++--------
 include/linux/mm_inline.h          |  4 ++--
 include/linux/mmzone.h             | 24 ++++++++++++------------
 mm/page_alloc.c                    |  6 +++---
 mm/slab.h                          |  2 +-
 mm/sparse.c                        |  2 +-
 7 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index efa6610acbc79..f8404bc7773c2 100644
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
index 485df9c2dbddb..3111e4a6c9c4c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2286,22 +2286,28 @@ static inline int page_zone_id(struct page *page)
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-int memdesc_nid(memdesc_flags_t mdf);
+int memdesc_nid(const memdesc_flags_t *mdf);
+#elif defined(CONFIG_NUMA)
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
+{
+	ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
+	return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
+}
 #else
-static inline int memdesc_nid(memdesc_flags_t mdf)
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
 {
-	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
+	return 0;
 }
 #endif
 
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	return memdesc_nid(&PF_POISONED_CHECK(page)->flags);
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
-	return memdesc_nid(folio->flags);
+	return memdesc_nid(&folio->flags);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -2541,12 +2547,13 @@ static inline void set_page_section(struct page *page, unsigned long section)
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
index a8430a7ae0544..efcddb9925add 100644
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
index ca27121871475..19e709d7a13de 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1272,31 +1272,31 @@ static inline bool zone_is_empty(const struct zone *zone)
 #define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
-static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
+static inline enum zone_type memdesc_zonenum(const memdesc_flags_t *flags)
 {
-	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
-	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+	ASSERT_EXCLUSIVE_BITS(flags->f, ZONES_MASK << ZONES_PGSHIFT);
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
 
@@ -1311,9 +1311,9 @@ static inline struct dev_pagemap *page_pgmap(const struct page *page)
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
@@ -1321,7 +1321,7 @@ static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 extern void memmap_init_zone_device(struct zone *, unsigned long,
 				    unsigned long, struct dev_pagemap *);
 #else
-static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
+static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
 {
 	return false;
 }
@@ -1338,12 +1338,12 @@ static inline struct dev_pagemap *page_pgmap(const struct page *page)
 
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
index ee902a468c2f5..020a97ca018e9 100644
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
index bf2f87acf5e3a..1ae8e6084ba32 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -155,7 +155,7 @@ static inline void *slab_address(const struct slab *slab)
 
 static inline int slab_nid(const struct slab *slab)
 {
-	return memdesc_nid(slab->flags);
+	return memdesc_nid(&slab->flags);
 }
 
 static inline pg_data_t *slab_pgdat(const struct slab *slab)
diff --git a/mm/sparse.c b/mm/sparse.c
index 16ac6df3c89fa..8e38477645131 100644
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


-- 
Cheers,

David

