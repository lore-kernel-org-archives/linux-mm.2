Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79CAFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256406B00B3; Fri, 27 Feb 2026 12:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E3E6B00B5; Fri, 27 Feb 2026 12:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117976B00B6; Fri, 27 Feb 2026 12:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1D006B00B3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEF9F13BA52
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:05 +0000 (UTC)
X-FDA: 84490992810.15.747B519
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id F25E3160006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nk3K6VsTtGAe00QGUsySAx+qxNoxLJZRi61IfFi030Y=;
	b=G+X5Ec+X5IgaZe8OR/FIjhxzTMp/orrD+djsFDXdSTFY7y1UtvBit3eZrreu55JqP614F+
	1o2edc9u/f73ECQABEhcxPG12y54jV9eYPG6SE0Goh0tfXGbty1jDYBYXpv3owFg0Gfsv6
	GlYJOZiWhXW9yHGnmyRdtFQPIik+CW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215024; a=rsa-sha256;
	cv=none;
	b=rqrjYpSNLekpch0eCjmBCsvmcBvtclfrjcvUytNUloKKyrKL1jaWucduOdbZFeqHLRZERX
	+4cDmGpp7pDtV4/M3A0JGcK+9w9sQQriWa/Z7z96TXfto55LpMQg9W7wUU8oQIYOA97Et3
	JQDfgq+5VbUylmboJGxb7GjjQLLHM1Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0169814BF;
	Fri, 27 Feb 2026 09:56:57 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2AD73F73B;
	Fri, 27 Feb 2026 09:56:58 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 17/30] mm: kpkeys: Add shrinker for block pgtable allocator
Date: Fri, 27 Feb 2026 17:55:05 +0000
Message-ID: <20260227175518.3728055-18-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F25E3160006
X-Stat-Signature: 1ddksumpuka38yq85n8tjpk6o7u59ajp
X-Rspam-User: 
X-HE-Tag: 1772215023-195766
X-HE-Meta: U2FsdGVkX18ix+h1lBSSFXLSFFA9Hmhnvvjmacf4CKIKhdfAwWeNLg4LVnDnfLsehXR9dHkABB3uJPkXqc2J/knOAGPubZKPct1/+UdPYjUFNGkcoGS0sF+yzGxRcBeqSPxA6LpGeP7lRADXatq09TZp+8UtfjXXcjMghBW8yqfoP5rp5E4BtaWcv9lM2eL7QAPwIhTYoADIylnciUAb2hq8KfEDwikcOE8lkwZOxkDlez+ZJYk9/zk8InsKGeA+W2ZhitMPX3KfEi9x9oiTL3CJo1nZc/nNSQuzuR9HKkQzG9+7t9tTgopjQWTeGnN17/zlaX52buyIiUyLnVdORADVAgk+MEVkjbZXFSYnFSZtd8ftnmY0eafEb4o2KmvqTs2vj8VzdP9StR7hmD/6NC1d+VhA6JvF2vNCBewtb5mFr5NkuzjbTbQ1UcWyVuVB00Qu6hSMooVy7EoKiJFi1mSrUZyWkdqbJCgj6Q4EMsUUFo/PdP1zedfKlXfErjiKZU/KGddT6HzsbRU8I18RseA/X6+N9rb30xRnRt84AI2o9ojuxbacekWvIg+Sg3RFE5wW0TrTYNE7Fxry+D1DnSe54qgTyOBAOklJmEAfLm4Hw2VOu/1/4kSXfj9Y6Ga2J0i5GHTPU3iyzdH1xhu7XNTQ5rwyacVK57Vjzy7Rj663uMo5BGhsKWka5DV5+1ZadEZmvZI9TV7k6ZvuhnXKEMGL8WDXTBLEtaUIu/PXtv6rvzP8wl/nq6l56MOX6fx80jBfzbmU97FT0GpDJT2p5vHFJCjaq7HA+a2d8ZSnNKfz9EDRgZxGIR58n37DoPQEsJMVGIUHGRNFy5NRlNOLqcUIscARxVglzcZyznpUjU5GKKVaGZcSZ8TAfN/dszp8hr0Lm7M2WFFvRdG6oSWjh83CnP+NnF+FecAe+F5CDcJS4z1elvjc7ZT6p2rat7JSZJpsNuSqtCQrdJkz1aX
 nWiQcvJ3
 jnbi4DtnwWo9DHeTaQA/Oauval6xCIBXszmxwYl9MueCTDqEEsgh1JP+ujM4wLJfyE/qUhNBQch7hxpluNenSll4eFy1ebaqI6qeQWkWOYMZx2YPHRhsIptXpdQfOp4abERGSl8/MRf8h7VDsJglOu180QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The newly introduced kpkeys block allocator does not return freed
page table pages (PTPs) to the buddy allocator, but instead caches
them, so that:

1. Future allocation requests can be quickly serviced, without
   calling alloc_pages() or set_memory_pkey().

2. Blocks are not needlessly split, since releasing a single page to
   the buddy allocator requires resetting the pkey for just that
   page, splitting the PMD into PTEs.

We cannot however let this cache grow indefinitely. This patch
introduces a shrinker that allows reclaiming those cached pages.

Like the rest of the allocator, the primary objective is to minimise
the splitting of blocks. Each shrinker pass (call to
pba_shrink_scan()) attempts to release all free pages within a given
block, or cached pages that do not lie inside a block managed by the
allocator.

In order to choose which block to shrink, we need to know how many
free pages a block contains. The approach taken here is to store
that value in the head page of each managed block and update it
whenever a page is allocated or freed. Other pages in the block are
also marked with a flag. This simplifies the shrinker pass, and the
associated overhead should be minimal.

We then scan all cached pages and find the "emptiest" block, i.e.
containing the most free pages. If a block is completely empty, then
we release it right away as that can be done without splitting.
Otherwise, we pay the price of splitting the block if we consider it
has enough free pages (and there are not enough non-block free
pages).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

Much of patch is up for debate, with various thresholds that would
deserve to be tuned. Tracking blocks seems like a good idea to reduce
fragmentation, but it's unclear how much that helps in a real-life
scenario. Feedback welcome!

---
 mm/kpkeys_hardened_pgtables.c | 287 ++++++++++++++++++++++++++++++++++
 1 file changed, 287 insertions(+)

diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 223a0bb02df0..dcc5e6da7c85 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -143,6 +143,7 @@ void __init kpkeys_hardened_pgtables_init_late(void)
 #define PBA_NR_RESERVED_PAGES	4
 
 #define BLOCK_ORDER		PMD_ORDER
+#define BLOCK_NR_PAGES		(1ul << (BLOCK_ORDER))
 
 /*
  * Refilling the cache is done by attempting allocation in decreasing orders
@@ -226,6 +227,68 @@ static void __ref register_early_region(struct page *head_page,
 	pba_early_region.order = order;
 }
 
+/*
+ * Private per-page allocator data. It needs to be preserved when a page table
+ * page is allocated, so we cannot use page->private, which overlaps with
+ * struct ptdesc::ptl. page->mapping is unused in struct ptdesc so we store it
+ * there instead.
+ */
+struct pba_page_data {
+	bool in_block;
+	u32 block_nr_free; /* Only used for the head page of a block */
+};
+
+static struct pba_page_data *page_pba_data(struct page *page)
+{
+	BUILD_BUG_ON(sizeof(struct pba_page_data) > sizeof(page->mapping));
+
+	return (struct pba_page_data *)&page->mapping;
+}
+
+static void mark_block_cached(struct page *head_page, struct page *cached_pages,
+			      unsigned int nr_cached_pages)
+{
+	page_pba_data(head_page)->in_block = true;
+	page_pba_data(head_page)->block_nr_free = nr_cached_pages;
+
+	for (unsigned int i = 0; i < nr_cached_pages; i++)
+		page_pba_data(&cached_pages[i])->in_block = true;
+}
+
+static void mark_block_noncached(struct page *head_page)
+{
+	for (unsigned int i = 0; i < BLOCK_NR_PAGES; i++)
+		head_page[i].mapping = NULL;
+}
+
+static struct page *block_head_page(struct page *page)
+{
+	unsigned long page_pfn;
+
+	if (!page_pba_data(page)->in_block)
+		return NULL;
+
+	page_pfn = page_to_pfn(page);
+
+	return pfn_to_page(ALIGN_DOWN(page_pfn, BLOCK_NR_PAGES));
+}
+
+static void inc_block_nr_free(struct page *page)
+{
+	struct page *head_page = block_head_page(page);
+
+	if (head_page)
+		page_pba_data(head_page)->block_nr_free++;
+}
+
+static void dec_block_nr_free(struct page *page)
+{
+	struct page *head_page = block_head_page(page);
+
+	if (head_page)
+		page_pba_data(head_page)->block_nr_free--;
+}
+
 static void cached_list_add_pages(struct page *page, unsigned int nr_pages)
 {
 	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
@@ -248,6 +311,7 @@ static void __refill_pages_add_to_cache(struct page *page, unsigned int order,
 					bool alloc_one)
 {
 	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
+	struct page *head_page = page;
 	unsigned int nr_pages = 1 << order;
 
 	if (alloc_one) {
@@ -255,6 +319,9 @@ static void __refill_pages_add_to_cache(struct page *page, unsigned int order,
 		nr_pages--;
 	}
 
+	if (order == BLOCK_ORDER)
+		mark_block_cached(head_page, page, nr_pages);
+
 	guard(spinlock_bh)(&pba->lock);
 
 	cached_list_add_pages(page, nr_pages);
@@ -309,6 +376,56 @@ static struct page *refill_pages_and_alloc_one(void)
 	return __refill_pages(true);
 }
 
+static unsigned long release_page_list(struct list_head *page_list)
+{
+	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
+	unsigned long nr_freed = 0;
+	struct page *page, *tmp;
+
+	/* _safe is required because __free_page() overwrites page->lru */
+	list_for_each_entry_safe(page, tmp, page_list, lru) {
+		int ret = 0;
+
+		ret = set_pkey_default(page, 1);
+
+		if (ret) {
+			guard(spinlock_bh)(&pba->lock);
+			cached_list_add_pages(page, 1);
+			break;
+		}
+
+		__free_page(page);
+		nr_freed++;
+	}
+
+	return nr_freed;
+}
+
+static unsigned long release_whole_block(struct list_head *page_list,
+					struct page *block_head)
+{
+	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
+	unsigned long nr_freed = 0;
+	struct page *page, *tmp;
+	int ret;
+
+	/* Reset the pkey for the full block to avoid splitting the linear map */
+	ret = set_pkey_default(block_head, BLOCK_NR_PAGES);
+
+	if (ret) {
+		guard(spinlock_bh)(&pba->lock);
+		cached_list_add_pages(block_head, BLOCK_NR_PAGES);
+		return 0;
+	}
+
+	list_for_each_entry_safe(page, tmp, page_list, lru) {
+		__free_page(page);
+		nr_freed++;
+	}
+
+	return nr_freed;
+}
+
 static bool cached_page_available(gfp_t gfp)
 {
 	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
@@ -337,6 +454,7 @@ static struct page *get_cached_page(gfp_t gfp)
 		return NULL;
 
 	cached_list_del_page(page);
+	dec_block_nr_free(page);
 	return page;
 }
 
@@ -409,6 +527,7 @@ static void pba_pgtable_free(struct page *page)
 	guard(spinlock_bh)(&pba->lock);
 
 	cached_list_add_pages(page, 1);
+	inc_block_nr_free(page);
 }
 
 static int pba_prepare_direct_map_split(void)
@@ -464,3 +583,171 @@ static void __init pba_init_late(void)
 		set_pkey_pgtable(pba_early_region.head_page,
 				 1 << pba_early_region.order);
 }
+
+/* Shrinker */
+
+/* Keep some pages around to avoid shrinking causing a refill right away */
+#define PBA_UNSHRINKABLE_PAGES		16
+/* Don't shrink a block that is almost full to avoid excessive splitting */
+#define PBA_SHRINK_BLOCK_MIN_PAGES	(BLOCK_NR_PAGES / 8)
+
+static unsigned long count_shrinkable_pages(void)
+{
+	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
+	unsigned long nr_cached = READ_ONCE(pba->nr_cached);
+
+	return nr_cached > PBA_UNSHRINKABLE_PAGES ?
+		nr_cached - PBA_UNSHRINKABLE_PAGES : 0;
+}
+
+static unsigned long pba_shrink_count(struct shrinker *shrink,
+				      struct shrink_control *sc)
+{
+
+	return count_shrinkable_pages() ?: SHRINK_EMPTY;
+}
+
+static bool block_worth_shrinking(unsigned long nr_pages_target_block,
+				  unsigned long nr_pages_nonblock,
+				  struct shrink_control *sc)
+{
+	/*
+	 * Avoid partially shrinking a block (which means splitting it) if
+	 * we can reclaim enough/more non-block pages instead, or if we would
+	 * reclaim only few pages (below PBA_SHRINK_BLOCK_MIN_PAGES)
+	 */
+	return nr_pages_nonblock < nr_pages_target_block &&
+		nr_pages_nonblock < sc->nr_to_scan &&
+		nr_pages_target_block >= PBA_SHRINK_BLOCK_MIN_PAGES;
+}
+
+static unsigned long pba_shrink_scan(struct shrinker *shrink,
+				     struct shrink_control *sc)
+{
+	struct pkeys_block_allocator *pba = &pkeys_block_allocator;
+	LIST_HEAD(pages_to_free);
+	struct page *page, *tmp;
+	unsigned long nr_pages_nonblock = 0, nr_pages_target_block = 0;
+	unsigned long nr_pages_uncached = 0, nr_freed = 0;
+	unsigned long nr_pages_shrinkable;
+	struct page *target_block = NULL;
+
+	sc->nr_scanned = 0;
+
+	pr_debug("%s: nr_to_scan = %lu, nr_cached = %lu\n",
+		 __func__, sc->nr_to_scan, pba->nr_cached);
+
+	spin_lock_bh(&pba->lock);
+	nr_pages_shrinkable = count_shrinkable_pages();
+
+	/*
+	 * Count pages that don't belong to any block, and find the block
+	 * with the highest number of free pages
+	 */
+	list_for_each_entry(page, &pba->cached_list, lru) {
+		struct page *block = block_head_page(page);
+		unsigned long block_nr_free;
+
+		if (!block) {
+			nr_pages_nonblock++;
+			continue;
+		}
+
+		block_nr_free = page_pba_data(block)->block_nr_free;
+
+		if (block_nr_free > nr_pages_target_block) {
+			target_block = block;
+			nr_pages_target_block = block_nr_free;
+		}
+
+		/* We will free this block, so no need to continue scanning */
+		if (nr_pages_target_block == BLOCK_NR_PAGES)
+			break;
+	}
+
+	if (nr_pages_target_block == BLOCK_NR_PAGES) {
+		/*
+		 * If a whole block is empty, take the opportunity to free it
+		 * completely (regardless of the requested nr_to_scan) to avoid
+		 * splitting the linear map. If nr_pages_shrinkable is too low,
+		 * we bail out as we would have to split the block to shrink it
+		 * partially (and there is nothing else we can shrink).
+		 */
+		if (nr_pages_shrinkable < BLOCK_NR_PAGES) {
+			spin_unlock_bh(&pba->lock);
+			pr_debug("%s: cannot free empty block, bailing out\n",
+				 __func__);
+			goto out;
+		}
+
+		sc->nr_to_scan = BLOCK_NR_PAGES;
+	} else if (block_worth_shrinking(nr_pages_target_block,
+					 nr_pages_nonblock, sc)) {
+		/* Shrink block (partially) */
+		sc->nr_to_scan = min(sc->nr_to_scan, nr_pages_target_block);
+	} else {
+		/* Free non-block pages */
+		sc->nr_to_scan = min(sc->nr_to_scan, nr_pages_nonblock);
+		target_block = NULL;
+	}
+
+	list_for_each_entry_safe(page, tmp, &pba->cached_list, lru) {
+		struct page *block = block_head_page(page);
+
+		if (!(nr_pages_uncached < sc->nr_to_scan &&
+		      nr_pages_uncached < nr_pages_shrinkable))
+			break;
+
+		if (block == target_block) {
+			list_move(&page->lru, &pages_to_free);
+			nr_pages_uncached++;
+		}
+	}
+
+	pba->nr_cached -= nr_pages_uncached;
+	sc->nr_scanned = nr_pages_uncached;
+
+	if (target_block)
+		mark_block_noncached(target_block);
+	spin_unlock_bh(&pba->lock);
+
+	if (target_block)
+		pr_debug("%s: freeing block (pfn = %lx, %lu/%lu free pages)\n",
+			 __func__, page_to_pfn(target_block),
+			 nr_pages_target_block, BLOCK_NR_PAGES);
+	else
+		pr_debug("%s: freeing non-block (%lu free pages)\n",
+			 __func__, nr_pages_nonblock);
+
+	if (nr_pages_target_block == BLOCK_NR_PAGES) {
+		VM_WARN_ON(nr_pages_uncached != BLOCK_NR_PAGES);
+		nr_freed = release_whole_block(&pages_to_free, target_block);
+	} else {
+		nr_freed = release_page_list(&pages_to_free);
+	}
+
+	pr_debug("%s: freed %lu pages, nr_cached = %lu\n", __func__,
+		 nr_freed, pba->nr_cached);
+out:
+	return nr_freed ?: SHRINK_STOP;
+}
+
+static int __init pba_init_shrinker(void)
+{
+	struct shrinker *shrinker;
+
+	if (!pba_enabled())
+		return 0;
+
+	shrinker = shrinker_alloc(0, "kpkeys-pgtable-block");
+	if (!shrinker)
+		return -ENOMEM;
+
+	shrinker->count_objects = pba_shrink_count;
+	shrinker->scan_objects = pba_shrink_scan;
+	shrinker->seeks = 0;
+	shrinker->batch = BLOCK_NR_PAGES;
+	shrinker_register(shrinker);
+	return 0;
+}
+late_initcall(pba_init_shrinker);
-- 
2.51.2


