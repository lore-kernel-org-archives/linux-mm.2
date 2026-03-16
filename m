Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9D1F46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A7A6B01F1; Mon, 16 Mar 2026 07:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5B46B01F3; Mon, 16 Mar 2026 07:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE376B01F4; Mon, 16 Mar 2026 07:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0571F6B01F1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:32:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFB9E56D4E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:34 +0000 (UTC)
X-FDA: 84551713428.27.28BB70A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0BE961C000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773660753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Bd5Eez89rGGjV7uqX6qJkNuaT2RAvlaD+HC4Kl9H04=;
	b=gQZhawF4MG2D57bjxUGBdDmX/E7XN1j5pcxTDVhuhR8REQWOdwMUjtTVa/xsNAuDn4tB4v
	elj7/7CGPLQ6Np12bJI7IxwX5AgBMCZuOBP5BvVTy137CodM0xpbRNkTgq5U7k5czoE4yJ
	3iBPHhBj0fYfIhyGohXLc1i9VeRtOEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773660753; a=rsa-sha256;
	cv=none;
	b=5dMk3Y5b/KTF14jC7gM7ufb+W7CbCsbzKfsxBYqAGo9SkLDbmwRKeYr2ULzaF8YbjS46b2
	Yq/Ad9tgHcRves43BysIWfOGHId3BQC6+E5eJr4db6tFCXFax1QM0eu1mr5hQslcUzjbVS
	PjmItL8TjItLxTZbxxXVi+00JlOhhC8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E556114BF;
	Mon, 16 Mar 2026 04:32:25 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8484D3F778;
	Mon, 16 Mar 2026 04:32:29 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	usama.anjum@arm.com
Subject: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Mon, 16 Mar 2026 11:31:42 +0000
Message-ID: <20260316113209.945853-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316113209.945853-1-usama.anjum@arm.com>
References: <20260316113209.945853-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0BE961C000A
X-Stat-Signature: syqnffsbat4xkt3me5smou1izaoujpma
X-Rspam-User: 
X-HE-Tag: 1773660752-456022
X-HE-Meta: U2FsdGVkX18BDaXscfxOlWXjy6DXKIWllD82OPJPfUxugTkFFOo/ft6XG2JbagkSlMQJgSOCjfJL9JdLVWlRFb+IjCcvWKOpx+1ZZG46APirxfvRXjI3G+P37pzNeXI38vzxVx8DT66RvbepAuaDswaHhvPL76XOHbMlqsRce0kuXXaO18Xuoh1ernIGDutViUNnxyxphcbxd77vzH2dMC2v1uYPzYihwIOLxLdnXG9nICfBvY8jVZf3PZqXmtDuVI01UY55u3MmpubhG4vULDE824TLXMU+yY4XyWE6jiTaq+EfT9NlmIRBVwKWC6FH5j85amECLqr8rZYgoFWpyVFDBpwOHpHwuGIjttDq9NcRTcPi4oedNTeU+6SXgP2pyxYaylEtW7oimCGGihUBS0+csOvwMydgigEs6u+q8BLcQ4XzHs5kBDJFPZApPBnbPw5ht+eH7Iu2vxSb1Dq3BA+QcB5tqhThQmI1bvmhVA+7QCXa3JVfvowrBy9XAg4v7XEZaGpJo4F/jYsS8dO0qzRmB/RozU+ZxsM9kUgvwv3Mw0vJRJM36KqrreuXcYcIH/zyidf7AyaEJAs5WoWGcrq/N3UOqNV//ioOy0l/qKjsU9eTc6Z1NOFr8/iUVfyVOS8eNdD0fjZHanWLFXTqJw6Y87yOBcHmE4tz5d9OhE3HZBgzhrYZ7obYWDRKadN9Slq9MknG3AFbXCaC7o+lkIpIfofG/2YQL9wKmyNPzRkZWtu6Y/poq+mawYSyNr0iSfm9mCFqBiyqpfids0hKm2qeBDZI2VT2gwT0zncLq5MifI1AXK92nqwIgJRMBSYeH2gArzuvzPjUiFq8Qu2n8LsxlJZkzq6QxRQf3E4BF+a1lxcF/1jEZyPm1IcyUYF3tJmWVntWuT7tVoi2FM3OEMLBzqpV0w6BRWV0BeTNcuqzet6tuLncuLiVRFNpxaNahIa+bFyBzHEta0EWdCA
 Qt11V70E
 adE76T4bOL+/iZJ02y4A26SBd0djMbIOIORpOCbSpB9/1gSSoLGq79qawYVcqI0MztLN/4C1QvzHdkMmDD2q49VAyc2dYsHdhk+HvGGQTDRVSgBU8dqBLl+3xOviLi4DD9b4Mi/qjcLCzSMm0iK0OVkJzfddj9i64Yji6MKlkwFsHoJadausOdyBBqvoTUZNdsNqR4S61+DlYn/OYcXBYZazHzIYaBDTYK7rGkYafQbEdtJrLrV8/kY7wSA5nMX+1VSY75rmZm6MUBgB0DLTgfWWnBw==
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

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
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
 mm/page_alloc.c     | 110 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f82d74a77cad8..96ac7aae370c4 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
+unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages);
+
 DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
 
 #endif /* __LINUX_GFP_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75ee81445640b..6a9430f720579 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -91,6 +91,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * free_pages_prepare() has already been called for page(s) being freed.
+ * TODO: Perform per-subpage free_pages_prepare() checks for order > 0 pages
+ * (HWPoison, PageNetpp, bad free page).
+ */
+#define FPI_PREPARED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1310,6 +1317,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
+	if (fpi_flags & FPI_PREPARED)
+		return true;
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	trace_mm_page_free(page, order);
@@ -1579,8 +1589,10 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
-		free_one_page(zone, page, pfn, order, fpi_flags);
+	if (!__free_pages_prepare(page, order, fpi_flags))
+		return;
+
+	free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -6784,6 +6796,93 @@ void __init page_alloc_sysctl_init(void)
 	register_sysctl_init("vm", page_alloc_sysctl_table);
 }
 
+static void free_prepared_contig_range(struct page *page,
+				       unsigned long nr_pages)
+{
+	while (nr_pages) {
+		unsigned int order;
+		unsigned long pfn;
+
+		pfn = page_to_pfn(page);
+		/* We are limited by the largest buddy order. */
+		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
+		/* Don't exceed the number of pages to free. */
+		order = min(order, ilog2(nr_pages));
+		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
+
+		/*
+		 * Free the chunk as a single block. Our caller has already
+		 * called free_pages_prepare() for each order-0 page.
+		 */
+		__free_frozen_pages(page, order, FPI_PREPARED);
+
+		page += 1UL << order;
+		nr_pages -= 1UL << order;
+	}
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
+ * Returns the number of pages which were not freed, because their reference
+ * count did not fall to zero.
+ *
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
+unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+	struct page *page = pfn_to_page(pfn);
+	unsigned long not_freed = 0;
+	struct page *start = NULL;
+	unsigned long i;
+	bool can_free;
+
+	/*
+	 * Chunk the range into contiguous runs of pages for which the refcount
+	 * went to zero and for which free_pages_prepare() succeeded. If
+	 * free_pages_prepare() fails we consider the page to have been freed;
+	 * deliberately leak it.
+	 *
+	 * Code assumes contiguous PFNs have contiguous struct pages, but not
+	 * vice versa.
+	 */
+	for (i = 0; i < nr_pages; i++, page++) {
+		VM_WARN_ON_ONCE(PageHead(page));
+		VM_WARN_ON_ONCE(PageTail(page));
+
+		can_free = put_page_testzero(page);
+		if (!can_free)
+			not_freed++;
+		else if (!free_pages_prepare(page, 0))
+			can_free = false;
+
+		if (!can_free && start) {
+			free_prepared_contig_range(start, page - start);
+			start = NULL;
+		} else if (can_free && !start) {
+			start = page;
+		}
+	}
+
+	if (start)
+		free_prepared_contig_range(start, page - start);
+
+	return not_freed;
+}
+EXPORT_SYMBOL(__free_contig_range);
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
@@ -7327,11 +7426,14 @@ EXPORT_SYMBOL(free_contig_frozen_range);
  */
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
+	unsigned long count;
+
 	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
 		return;
 
-	for (; nr_pages--; pfn++)
-		__free_page(pfn_to_page(pfn));
+	count = __free_contig_range(pfn, nr_pages);
+	WARN(count != 0, "%lu pages are still in use!\n", count);
+
 }
 EXPORT_SYMBOL(free_contig_range);
 #endif /* CONFIG_CONTIG_ALLOC */
-- 
2.47.3


