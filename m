Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398ACC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917FD6B0184; Mon,  5 Jan 2026 11:17:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886856B0187; Mon,  5 Jan 2026 11:17:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7353B6B0188; Mon,  5 Jan 2026 11:17:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61C986B0184
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:17:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BD951601F4
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:17:58 +0000 (UTC)
X-FDA: 84298416636.20.3001F25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B73B18000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:17:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VTqmywUFm3OWBmZcYGPOE+NugJGr79ts8PRWDS7cN5Y=;
	b=QOKY/od8tEciEfLSRKI1qaPsVoAG5THpgtzrzg6OGWIpbtStd1GzgaF+ajClLyztj2ptaD
	u+M8QKfRjF3V9vTQoCUVaXJhx4tokj4ry0v2i7GicJ8LlUnbF6cFjNzoNlOvPMAi4zCiMp
	vf60F/tYKs9iWsMnetz2jTNMtvEzQZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629876; a=rsa-sha256;
	cv=none;
	b=IMSuk8fkY2bMx7JvVOnPSpe4M3QMukN3I7Vo2dQslNDAN1uUQ/z8uI4yjesV4IXxfhKWQs
	5LiM3XxCIKd8H8bW7TLxUYXfck5mRoqqlYteDmqM0GPCVBZPWM6xlT5F/F9r8a+aQ6kzU2
	/KHyd4NT2cfGETVcsbCeSYiJyzdIv0g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A850E497;
	Mon,  5 Jan 2026 08:17:48 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A34023F6A8;
	Mon,  5 Jan 2026 08:17:53 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] mm/page_alloc: Optimize free_contig_range()
Date: Mon,  5 Jan 2026 16:17:37 +0000
Message-ID: <20260105161741.3952456-2-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260105161741.3952456-1-ryan.roberts@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e7g7r69o661bn5a9xgbsqsgs1d9dkbot
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B73B18000F
X-Rspam-User: 
X-HE-Tag: 1767629876-119813
X-HE-Meta: U2FsdGVkX18Ho3HEs4I7HR1XNOhuIBoDgcEpY1HvzFCPoPQKBOXoJOSm9qgJP5Iqfl983JKtfVAdaWJVlHCYuMSCf0cFULvac/bTmtAffQ8YPZ4Z+4F8X62VtsviaLOZLW4222M7hGETp4xg6YSG9Jnl/vTDY2gOwNns2+oQJRC1dMXCV0HJJJm20JTCUQ4BkF8nFv7R+sc6zLQfLUTyv3n8uKOKXiVsv/BMcoHjI5fzXfyR9TCg2wueM7irZJA/BX/AiCULKql+lJxsqcxaLYbYLkFTAqJO/4KEpoiqG5YLtovaRqqqPSBSC9APpMUZqKiWLU+j0ermyy34BUqKtLe6BueA8hBAgOZb9HJetaOLFY8X4FfpBT+KqFhbkrzKQg4dQwe4Gx0dtD+oo8Q1GKDrlAjDLkpJAHeONAWQXK4WHqIZmvdCXPbAdCbjDnznipchCV95NhhBCYJgIht/l0FWlnwjTJeo8XDa+TnM9oWHY/3IXNK5dPDR6AUjju6MZtt1lHESHglqwOMyxXY+x6itTbpU83QS+DKZTsTbbgfh0qd06M1XZUvWZnkr104aKhSGO4K55EBEE6EsAyMOAfx1phH19CcFX0/MId7EcSY8buzCrBtibPd8aTV0vhtRQMIZX/ONPMamiL3ZUNPTZCYf5m0nCUZ6jXXcer/tVLIShv0jZ+JhzKMaCUbryl3Y3K9KOH41l36f0MFw1yDZHZXfp5velbttsQzkHK1kN6fOBqWRm/fYchM+Bd71StOlexBYX2qxzsNs0XVCvqUdj64OfJDKEDi/8kfFgEvfk85KVKZh5BgnqsF4Wy0rAaGe7BEFs76YXl/zgQia9a6rQTkQuZ7rBNK/taPl0TP5zCtnRtAwCd5q1ROIQRJHClaAaaCcZQ3T3wcVlUMGlePe4yitFfDQxYNHQOk+mBb0z4ZChC88eoEsJLgHDCbIX/Dm8tDw52iC4iq1FuGD9Bt
 yV8JhBa7
 SBY9a69hQoTtuxa/4IkqzGz1u5KRNaMHIVuJOm9xRWXLSU+i+zfZCWFYUzhxheGFlNlLX8g+swiv5MpRxjxc4K6e8PulJbQUFhtSor6JLg+7P84oqvGepkYZDSBMWOjoXZd77aD3dYL9x/2SvV6WEtBS8d084VqzU1eiVAbCl8bx1u8cnfxpMkWCRjVJEtdMTH26346e5WGzLFvr9hIn6WsX1Yju+DtvVfN9AhqyeeGbKNDgS9M2tPvPcX0Je5NDDloHtlghKSBK8xHfPq/vdNkj1yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

This significiantly speeds up the free operation but also has the side
benefit that high order blocks are added to the pcp instead of each page
ending up on the pcp order-0 list; memory remains more readily available
in high orders.

vmalloc will shortly become a user of this new optimized
free_contig_range() since it agressively allocates high order
non-compound pages, but then calls split_page() to end up with
contiguous order-0 pages. These can now be freed much more efficiently.

The execution time of the following function was measured in a VM on an
Apple M2 system:

static int page_alloc_high_ordr_test(void)
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

Execution time before: 1684366 usec
Execution time after:   136216 usec

Perf trace before:

    60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_from_fork
            |
            ---ret_from_fork
               kthread
               0xffffbba283e63980
               |
               |--60.01%--0xffffbba283e636dc
               |          |
               |          |--58.57%--free_contig_range
               |          |          |
               |          |          |--57.19%--___free_pages
               |          |          |          |
               |          |          |          |--46.65%--__free_frozen_pages
               |          |          |          |          |
               |          |          |          |          |--28.08%--free_pcppages_bulk
               |          |          |          |          |
               |          |          |          |           --12.05%--free_frozen_page_commit.constprop.0
               |          |          |          |
               |          |          |          |--5.10%--__get_pfnblock_flags_mask.isra.0
               |          |          |          |
               |          |          |          |--1.13%--_raw_spin_unlock
               |          |          |          |
               |          |          |          |--0.78%--free_frozen_page_commit.constprop.0
               |          |          |          |
               |          |          |           --0.75%--_raw_spin_trylock
               |          |          |
               |          |           --0.95%--__free_frozen_pages
               |          |
               |           --1.44%--___free_pages
               |
                --0.78%--0xffffbba283e636c0
                          split_page

Perf trace after:

    10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_fork
            |
            ---ret_from_fork
               kthread
               0xffffbbd55ef74980
               |
               |--8.74%--0xffffbbd55ef746dc
               |          free_contig_range
               |          |
               |           --8.72%--__free_contig_range
               |
                --1.56%--0xffffbbd55ef746c0
                          |
                           --1.54%--split_page

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 include/linux/gfp.h |   1 +
 mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 106 insertions(+), 11 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b155929af5b1..3ed0bef34d0c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))

 #endif
+unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);

 #ifdef CONFIG_CONTIG_ALLOC
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a045d728ae0f..1015c8edf8a4 100644
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
@@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);

-	if (free_pages_prepare(page, order))
-		free_one_page(zone, page, pfn, order, fpi_flags);
+	if (!(fpi_flags & FPI_PREPARED)) {
+		if (!free_pages_prepare(page, order))
+			return;
+	}
+
+	free_one_page(zone, page, pfn, order, fpi_flags);
 }

 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		return;
 	}

-	if (!free_pages_prepare(page, order))
-		return;
+	if (!(fpi_flags & FPI_PREPARED)) {
+		if (!free_pages_prepare(page, order))
+			return;
+	}

 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
@@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 }
 #endif /* CONFIG_CONTIG_ALLOC */

+static void free_prepared_contig_range(struct page *page,
+				       unsigned long nr_pages)
+{
+	while (nr_pages) {
+		unsigned int fit_order, align_order, order;
+		unsigned long pfn;
+
+		/*
+		 * Find the largest aligned power-of-2 number of pages that
+		 * starts at the current page, does not exceed nr_pages and is
+		 * less than or equal to pageblock_order.
+		 */
+		pfn = page_to_pfn(page);
+		fit_order = ilog2(nr_pages);
+		align_order = pfn ? __ffs(pfn) : fit_order;
+		order = min3(fit_order, align_order, pageblock_order);
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
+	 * free_pages_prepare() fails we consider the page to have been freed
+	 * deliberately leak it.
+	 *
+	 * Code assumes contiguous PFNs have contiguous struct pages, but not
+	 * vice versa.
+	 */
+	for (i = 0; i < nr_pages; i++, page++) {
+		VM_BUG_ON_PAGE(PageHead(page), page);
+		VM_BUG_ON_PAGE(PageTail(page), page);
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
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned long count = 0;
+	unsigned long count;
 	struct folio *folio = pfn_folio(pfn);

 	if (folio_test_large(folio)) {
@@ -7266,12 +7365,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 		return;
 	}

-	for (; nr_pages--; pfn++) {
-		struct page *page = pfn_to_page(pfn);
-
-		count += page_count(page) != 1;
-		__free_page(page);
-	}
+	count = __free_contig_range(pfn, nr_pages);
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
--
2.43.0


