Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD0FD35167
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49646B0088; Wed,  1 Apr 2026 06:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9526B0089; Wed,  1 Apr 2026 06:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F816B008A; Wed,  1 Apr 2026 06:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B09DA6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:16:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61930C749C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:47 +0000 (UTC)
X-FDA: 84609583254.19.5231BF4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 898CF20003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jqmpeQDu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+xbQfFmKEXOsY48OJgUxuTUtA+ItUkhf8vOLNqJl6s=;
	b=VNl2XIYh5a07PJdt2VU0T/od3oQwEW31k3mtyr2NS+EYQdvo8J9yLsHp2cKGVPhYnajnGL
	x8HBFRK4Xc/1uNCE+ZZJ9Rm4YHn2TjlmEw+VTCfWnFO22+jchHAPgU99sA+pf67BnvCmmn
	DXAqxljBirWIzkGyInPalA9vzauMDnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038605; a=rsa-sha256;
	cv=none;
	b=TV5BDfw8eDd5uW9Qk054054R1gwZbPX6mPwBN6sQrumOtfMvfB5K6mk+ehIFz6++g0aTGz
	jlryCwuDx7x+AQzIW40748/GbOG6nNN9QWvZbxawvSEC0XBiL3nI1vsLiJgSyg9ZatVK+h
	8+z64oHvRL214kpwMEzhRa3OLWIHxdw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jqmpeQDu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B3BE1D6F;
	Wed,  1 Apr 2026 03:16:38 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B6DC53F915;
	Wed,  1 Apr 2026 03:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775038604; bh=0JrPBbUEILKlkzzVRySmRRkXeTkDPPQrLu5lAYwrLqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqmpeQDuKTs1762cDsXeGSPGxFyE5mhGSUCCrOK5bDj8azFxqNAbrqPU9KxWeEpni
	 JoeSlgw3x+7TaqYG1qLZZTFBotmcGT32u/pJmU5lkuTfHQhRwjEjoysu5hgfms1GWb
	 M0B9QZE8jBV9c1FSlI+suZnUjXWPRJsSEvkRJOAg=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	usama.anjum@arm.com
Subject: [PATCH v6 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Wed,  1 Apr 2026 11:16:19 +0100
Message-ID: <20260401101634.2868165-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401101634.2868165-1-usama.anjum@arm.com>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 898CF20003
X-Stat-Signature: 6ows8iepxsd4s7jhsowdsqep5r66rtfw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775038605-554775
X-HE-Meta: U2FsdGVkX18JA3G+QG168R3tHtOMQRbkltdokFJiuKpyURufjR8wLdyM+XVWYMqzJblqL3ddUsjYKigLuC2lICppXRUO6pWLC5cKOlprWibM9nzGeZ2oydxxKM5bLsjzxwkglNQM18sQwuYkx5kO122hHsOP0X3Y6LJRBu3EwBeNjp1VCvql0BVMWPVjgtInz86uFOUUjRurB6cVwXZEyMJ2e5U/ENQCrutF6xue4ols2obEdeXtj+QpSCvBELuL7SYfWUvcAqzoMMVO2wGeMzJEtHFRL3fcVgEqC/AqcUb4mwc0or/dDXZ//vumlHHkwWitTPalBarYyYOSbOh8WYGeidO/3QbaHHqT/FtaIaz0d94mKFT1s0B7iz0/74MP0y2/zvCJWphUtNpeKu08bath0IjYbvrremw8+CMJRi5M0hFx/r1kSJjqcUFG0kIzeBe/AO6zqA+KWuiStrleQYfmkvuUj7I5PLVVqHWk+vRACbTqFh1++oa/wh2cIGJkJsbBVQwoCrAHYUeooF+3ryXIXv3RCwFlEfaYVwxr877bYrGDXurxo310nBlYevAGL8D+QmeN9s5c7T9F0dF4aHIGuFSGPjDcojk+tsZ0teLD4W9Oy556TNteP7rwgXT32ZPH/fR2+OnAMvBYXQ2TiAhOeNV3GqZrr50vHbdlbhGVGtBOZSf4veryd2Loo0EpdXb9GG5W3soqVdxMjDQtwCvYsN1zQpTPUDJfGrirZYom9OjWcJ98NurJ0skfeJ8moF2TqJ/z4ud5NsO10VnLWneOKJeoa+rvl97iv5aGKjrMQh31wzWCRR+nkkJEVTBhldYtG5ss1NXjkOqQrI35Jb6GfG6iulhH8ras+iax/yIpbv19sSTiqGKLEGJMolG3j4aHYUOThkhIaOJWWO4yJyosLRkuukk0Lmkw+N+maHTFrBl+TocaqEHmbKTH3Ql2R0wjlWqAWpqLOu6qq4b
 gT21n+KJ
 /A/XJKzg0YO/UfM7e2013aN2a5HSMZAr4BMl52odJY7rWUsrjWzBptIx55YkJ4EQSjJ1LB3OdkKm4kTIRAE3OoWtJ1volsIGTulOacyXL/0ycXl2nUln5pYCq3Vju5dES2WDBP8TG1RzvhX0BcvYnnCbL7cq054Nhkskbuz/FQ+yEjtHbAG2LAH734cdnSqghkAsarHaKIRABcu/6UZDFXT8GqO6F9wJseb7SMLeTz131ekDu8fk2Gb2jRZXitp2b+wJzjKGF7Xmcnh4LwqaBMISrOXGmwcHwl6Tm8Bqfs0VzkJzqfdB3VKdUzdtwr7wkjYxRDuDrHnmSKxl9WG3kBMsgmJ1Sh6a2HOAaslQlWJBAVZe2hbKamLVs7Vks/PgRei6B7nMLzT+9wc7shByzwb2yIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ryan Roberts <ryan.roberts@arm.com>

Decompose the range of order-0 pages to be freed into the set of largest
possible power-of-2 size and aligned chunks and free them to the pcp or
buddy. This improves on the previous approach which freed each order-0
page individually in a loop. Testing shows performance to be improved by
more than 10x in some cases.

Since each page is order-0, we must decrement each page's reference
count individually and only consider the page for freeing as part of a
high order chunk if the reference count goes to zero. Additionally
free_pages_prepare() must be called for each individual order-0 page
too, so that the struct page state and global accounting state can be
appropriately managed. But once this is done, the resulting high order
chunks can be freed as a unit to the pcp or buddy.

This significantly speeds up the free operation but also has the side
benefit that high order blocks are added to the pcp instead of each page
ending up on the pcp order-0 list; memory remains more readily available
in high orders.

vmalloc will shortly become a user of this new optimized
free_contig_range() since it aggressively allocates high order
non-compound pages, but then calls split_page() to end up with
contiguous order-0 pages. These can now be freed much more efficiently.

The execution time of the following function was measured in a server
class arm64 machine:

static int page_alloc_high_order_test(void)
{
	unsigned int order = HPAGE_PMD_ORDER;
	struct page *page;
	int i;

	for (i = 0; i < 100000; i++) {
		page = alloc_pages(GFP_KERNEL, order);
		if (!page)
			return -1;
		split_page(page, order);
		free_contig_range(page_to_pfn(page), 1UL << order);
	}

	return 0;
}

Execution time before: 4097358 usec
Execution time after:   729831 usec

Perf trace before:

    99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
            |
            ---kthread
               0xffffb33c12a26af8
               |
               |--98.13%--0xffffb33c12a26060
               |          |
               |          |--97.37%--free_contig_range
               |          |          |
               |          |          |--94.93%--___free_pages
               |          |          |          |
               |          |          |          |--55.42%--__free_frozen_pages
               |          |          |          |          |
               |          |          |          |           --43.20%--free_frozen_page_commit
               |          |          |          |                     |
               |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
               |          |          |          |
               |          |          |          |--11.53%--_raw_spin_trylock
               |          |          |          |
               |          |          |          |--8.19%--__preempt_count_dec_and_test
               |          |          |          |
               |          |          |          |--5.64%--_raw_spin_unlock
               |          |          |          |
               |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
               |          |          |          |
               |          |          |           --1.07%--free_frozen_page_commit
               |          |          |
               |          |           --1.54%--__free_frozen_pages
               |          |
               |           --0.77%--___free_pages
               |
                --0.98%--0xffffb33c12a26078
                          alloc_pages_noprof

Perf trace after:

     8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
            |
            |--5.52%--__free_contig_range
            |          |
            |          |--5.00%--free_prepared_contig_range
            |          |          |
            |          |          |--1.43%--__free_frozen_pages
            |          |          |          |
            |          |          |           --0.51%--free_frozen_page_commit
            |          |          |
            |          |          |--1.08%--_raw_spin_trylock
            |          |          |
            |          |           --0.89%--_raw_spin_unlock
            |          |
            |           --0.52%--free_pages_prepare
            |
             --2.90%--ret_from_fork
                       kthread
                       0xffffae1c12abeaf8
                       0xffffae1c12abe7a0
                       |
                        --2.69%--vfree
                                  __free_contig_range

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v5:
- Move page_to_pfn() outside the loop in free_prepared_contig_range()

Changes since v4:
- Move can_free initialization inside the loop
- Make __free_pages_prepare() static on reviewer's request
- Remove export of __free_contig_range
- Use pfn_to_page() for each pfn instead of page++

Changes since v3:
- Move __free_contig_range() to more generic __free_contig_range_common()
  which will used to free frozen pages as well
- Simplify the loop in __free_contig_range_common()
- Rewrite the comment

Changes since v2:
- Handle different possible section boundries in __free_contig_range()
- Drop the TODO
- Remove return value from __free_contig_range()
- Remove non-functional change from __free_pages_ok()

Changes since v1:
- Rebase on mm-new
- Move FPI_PREPARED check inside __free_pages_prepare() now that
  fpi_flags are already being passed.
- Add todo (Zi Yan)
- Rerun benchmarks
- Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
- Rework order calculation in free_prepared_contig_range() and use
  MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
  be up to internal __free_frozen_pages() how it frees them
---
 include/linux/gfp.h |   2 +
 mm/page_alloc.c     | 112 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 110 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f82d74a77cad8..7c1f9da7c8e56 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
+void __free_contig_range(unsigned long pfn, unsigned long nr_pages);
+
 DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
 
 #endif /* __LINUX_GFP_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75ee81445640b..fb4522ba51faf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/* free_pages_prepare() has already been called for page(s) being freed. */
+#define FPI_PREPARED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1301,8 +1304,8 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-__always_inline bool __free_pages_prepare(struct page *page,
-					  unsigned int order, fpi_t fpi_flags)
+static __always_inline bool __free_pages_prepare(struct page *page,
+		unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page);
@@ -1310,6 +1313,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
+	if (fpi_flags & FPI_PREPARED)
+		return true;
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	trace_mm_page_free(page, order);
@@ -6784,6 +6790,105 @@ void __init page_alloc_sysctl_init(void)
 	register_sysctl_init("vm", page_alloc_sysctl_table);
 }
 
+static void free_prepared_contig_range(struct page *page,
+		unsigned long nr_pages)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	while (nr_pages) {
+		unsigned int order;
+
+		/* We are limited by the largest buddy order. */
+		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
+		/* Don't exceed the number of pages to free. */
+		order = min_t(unsigned int, order, ilog2(nr_pages));
+		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
+
+		/*
+		 * Free the chunk as a single block. Our caller has already
+		 * called free_pages_prepare() for each order-0 page.
+		 */
+		__free_frozen_pages(page, order, FPI_PREPARED);
+
+		pfn += 1UL << order;
+		page += 1UL << order;
+		nr_pages -= 1UL << order;
+	}
+}
+
+static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
+		bool is_frozen)
+{
+	struct page *page, *start = NULL;
+	unsigned long nr_start = 0;
+	unsigned long start_sec;
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++) {
+		bool can_free = true;
+
+		/*
+		 * Contiguous PFNs might not have contiguous "struct pages"
+		 * in some kernel configs: page++ across a section boundary
+		 * is undefined. Use pfn_to_page() for each PFN.
+		 */
+		page = pfn_to_page(pfn + i);
+
+		VM_WARN_ON_ONCE(PageHead(page));
+		VM_WARN_ON_ONCE(PageTail(page));
+
+		if (!is_frozen)
+			can_free = put_page_testzero(page);
+
+		if (can_free)
+			can_free = free_pages_prepare(page, 0);
+
+		if (!can_free) {
+			if (start) {
+				free_prepared_contig_range(start, i - nr_start);
+				start = NULL;
+			}
+			continue;
+		}
+
+		if (start && memdesc_section(page->flags) != start_sec) {
+			free_prepared_contig_range(start, i - nr_start);
+			start = page;
+			nr_start = i;
+			start_sec = memdesc_section(page->flags);
+		} else if (!start) {
+			start = page;
+			nr_start = i;
+			start_sec = memdesc_section(page->flags);
+		}
+	}
+
+	if (start)
+		free_prepared_contig_range(start, nr_pages - nr_start);
+}
+
+/**
+ * __free_contig_range - Free contiguous range of order-0 pages.
+ * @pfn: Page frame number of the first page in the range.
+ * @nr_pages: Number of pages to free.
+ *
+ * For each order-0 struct page in the physically contiguous range, put a
+ * reference. Free any page who's reference count falls to zero. The
+ * implementation is functionally equivalent to, but significantly faster than
+ * calling __free_page() for each struct page in a loop.
+ *
+ * Memory allocated with alloc_pages(order>=1) then subsequently split to
+ * order-0 with split_page() is an example of appropriate contiguous pages that
+ * can be freed with this API.
+ *
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
+void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
@@ -7330,8 +7435,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
 		return;
 
-	for (; nr_pages--; pfn++)
-		__free_page(pfn_to_page(pfn));
+	__free_contig_range(pfn, nr_pages);
 }
 EXPORT_SYMBOL(free_contig_range);
 #endif /* CONFIG_CONTIG_ALLOC */
-- 
2.47.3


