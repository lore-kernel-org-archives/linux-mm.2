Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB58DF54ABA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1086B008C; Tue, 24 Mar 2026 09:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BE66B0095; Tue, 24 Mar 2026 09:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B916B0098; Tue, 24 Mar 2026 09:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B556D6B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:35:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B62FD326B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:55 +0000 (UTC)
X-FDA: 84581054670.20.A0A7807
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id B13151C0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AayArib7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774359353; a=rsa-sha256;
	cv=none;
	b=ygZhRk1wEQSnHWb8d4q3bXfEYpv4dbo+pwc/gAy+5Htffix9Z8OvqVUG0MK/WChhruditf
	4J6ZuA2nytH7yaiy7zzrq2FaINv/qKnAZSPELsIdnLFkpFrGJgCLkyVUq5kYa4R8fyiq0J
	P4t/nZqfvHC9GcZru5/ZBr7CXFlmzv0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AayArib7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tl9+LzFXBdP+4KnjhxY6rTBK4U2c+5065k9R9N0zOcs=;
	b=4Vor0lbB3DjgPPZGtuahFKy9+zakhkMDRQuYHZyk6tjjQX/Vmd/4bZcY6H8v9fo0wSt91X
	N5DvgTqbt1mecpOf6k+xvXbqupoeHwiKk96lxmkVasHKN4bREHbE7UxznTQHpjAM6/dXqa
	mSGiGIcZ7LBfQN8PwDecitXJYz8xF4c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8DD41476;
	Tue, 24 Mar 2026 06:35:46 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 631F53F836;
	Tue, 24 Mar 2026 06:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774359352; bh=FdPEpz6EFJ63WqRLpryyN8wswLSM6aHq79JMVMg2gdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AayArib77pQvSoRcwiVSPDoEdDASWCTlbW58Tcjd0Wb3Os8krKJIpAL8rQnDCu630
	 iKqXeahQR77bw+Ug1VhNr10HEVUbC1JGyEoOxf8S15hZqtKHceZeYaVYVP3Eo5MB15
	 nXsqG3pxU6bkvyycUSMi7AhDL80csZevaj3o8w44=
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
Subject: [PATCH v3 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Tue, 24 Mar 2026 13:35:32 +0000
Message-ID: <20260324133538.497616-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324133538.497616-1-usama.anjum@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1rqdqhegjybgtz1ejhpdz6r5kq7skyr7
X-Rspamd-Queue-Id: B13151C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774359353-556438
X-HE-Meta: U2FsdGVkX18GTogT5HXSd5kXrN1IOr7vHviWeTdd9WNLc9YC4uGbi4CaIShbxfuTciInU8cAEr55lGkvLzfAT7rGe2hkLtkHm9C00OvuUsv6JLFn+ZLJV9LV4M45iv/ppdXvkas9oW6khPl8kASK4qJOZCqvpbGQGLp/ZAJ5Tb87asOargrqmhd22MB2jYEt9wD/HftwKiPzcZhWvZe/3l1YQlCOLt0ApQ6yqmyZb/bv91Sp2W5FQVgnBMKtNxEQzjJ3Vgh+VSgxZn9vMkykVZaNnX23Oi4c4WY+DuirDpR9WbTocK/kySHU7bfd0QdU3w8WsFIY64ihIrgsFoRNCVNqJgOW0XGp83PikkgTZgJL+mDdO59QhuCTPJky7gRz9MddnfNt63/b6q4JujtM0uZGex7r73wcMICG9XSziaxvPd4K4UdWj2YjUqe8jegWjMz8XdwG8sddNegDwWE6//EbMRj7mUv/rNSJDXBUxdG1kktXNtQb7yRCZMmDSKcJ14LG1MiP0ubIfczvQeowItj5kEgIYR+tFn0dVOt2fF/ATfvGnFtA6DGODgtQbQxuFZh55nYMFqFazfmpCkTcBk4Wc37dJrc93SeRQy5akEe6Y774e/vAnioQ+WIMYfr3h/rJRGupwBPDmgrFZpC2d12o8N/uULZgy9/okpVUR34yYOUcBKcrob3BugFJCjg3EhDE6VG1LO2oBqnywgqLXvmqGpilmuwTJJ0817tJOwOuFtDhme0al2e57+l4OboPNKg4OzVveV+FvKoiAas6yThjB59Uc5BFeXQcLymPg872u4k4JSQtJeU8WT2CMzqmB/T2ZYRs3CTI0WcVq8lt0DT/8vBjIfHWIQdD0nCpLvpGFoBTfNNNcDcNOWhrAaMs3LNgVkigYd0MI4XBed5NGTv4XN0hKbQ5kBkJ/RVgxfSq5d+fEGmo20iusJHdfaYrpH16+pdA9pPwbdPtTG8
 LU0YKBoU
 FaE/IrjE5SWJK8QlcZVsZmPnhIrSUQgyXD1uTAIqlyeSXkDV4nUiURPj7wpcalZHTnSJ+50jiNzUjbRfXNHUiztEbTyz9+jm4vazYA9qGSSNFuI6JEjFpVkFYlhe1cw0Qe85j1cG9QSkspzMkTGrHxGXr+wfgoXY/nwalKBzseB9QOcXqTfIjVWT+AeXHsCFO5M0N9rCK+7IFpGrJD6XnDJ0nA9onIyOXRD81MR/la9HZiwrii67ENzPCfvAPMFtVkpduzfCJdzTPC2jW+jgzuSfYuaW5UDlcbh6w2OPExgvzkxW/EnxtQDoJAH4HPjiEoTKXxatN2qdNSpxjxXnIcR2one+bYhnblEr+H4LL9/uGCD4=
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

Made-with: Cursor
---
 include/linux/gfp.h |  2 +
 mm/page_alloc.c     | 97 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 2 deletions(-)

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
index 75ee81445640b..eedce9a30eb7e 100644
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
@@ -1310,6 +1313,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
+	if (fpi_flags & FPI_PREPARED)
+		return true;
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	trace_mm_page_free(page, order);
@@ -6784,6 +6790,94 @@ void __init page_alloc_sysctl_init(void)
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
+		order = min_t(unsigned int, order, ilog2(nr_pages));
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
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
+void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+	struct page *page = pfn_to_page(pfn);
+	struct page *start = NULL;
+	unsigned long start_sec;
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
+	 * vice versa. Break batches at section boundaries since pages from
+	 * different sections must not be coalesced into a single high-order
+	 * block.
+	 */
+	for (i = 0; i < nr_pages; i++, page++) {
+		VM_WARN_ON_ONCE(PageHead(page));
+		VM_WARN_ON_ONCE(PageTail(page));
+
+		can_free = put_page_testzero(page);
+		if (can_free && !free_pages_prepare(page, 0))
+			can_free = false;
+
+		if (can_free && start &&
+		    memdesc_section(page->flags) != start_sec) {
+			free_prepared_contig_range(start, page - start);
+			start = page;
+			start_sec = memdesc_section(page->flags);
+		} else if (!can_free && start) {
+			free_prepared_contig_range(start, page - start);
+			start = NULL;
+		} else if (can_free && !start) {
+			start = page;
+			start_sec = memdesc_section(page->flags);
+		}
+	}
+
+	if (start)
+		free_prepared_contig_range(start, page - start);
+}
+EXPORT_SYMBOL(__free_contig_range);
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
@@ -7330,8 +7424,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
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


