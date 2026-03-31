Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F70109B489
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F071C6B0098; Tue, 31 Mar 2026 11:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF7A6B0099; Tue, 31 Mar 2026 11:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BEB6B009B; Tue, 31 Mar 2026 11:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE3286B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:22:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42987C3F3B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:25 +0000 (UTC)
X-FDA: 84606724650.26.6D74248
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60FDDA0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="K+gpd3C/";
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8mi2VEvepnnhco04aSwdylM8vrvNWwEDThvfLxS/DY=;
	b=1tzBRRc73T7o/RzBfzVxekpFh9I59iFGa3dinb4m4Phw4ClGPERXz6y4NwLOdnHoMudd8K
	AZxBlZnbvruRwfHmHU+6Plc2mJkexPwAK2yNtiCdxXVpkIG9zXW0J+EJECBizx8m3oL8Y4
	t6fz8K5wJhreo62FCRre+Qvcw32MVzU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="K+gpd3C/";
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970543; a=rsa-sha256;
	cv=none;
	b=LiYYnyS2pNADgAw+1GTtcda8F53Ht/wFTeWKIW2vJz+4lcNNiTGGQ4d9ROIkSF77Cf8Rw3
	N+J4CdQS1CIQuNPcU1iycMiQmXNur932eDGQUaQDf/pno8592PyHEQji9rctL6P5R39JQ+
	+wwGEnBAjhLPkOxx5l9MkI+z8urdErk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93BD82379;
	Tue, 31 Mar 2026 08:22:16 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E796C3F641;
	Tue, 31 Mar 2026 08:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774970542; bh=iw1cxYLgBxaWuZ82GU5UhvU0kTfhXs28b6E9rhswUCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+gpd3C/xi7jagrUlr50F6fqL3URe0IuH7gOdWrdNxeuN9lQGWTZqu1J59tg7QfTV
	 uI/SKAf7hqv85jN3ZoFwtouCMCoLdwF7UcjfPSqUY1rCJGse2OgBkyA9a6mLddxuS2
	 5/pQzgtWuwxVPyVJIq820RY/KQvfnXLvFZEI1I4s=
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
Subject: [PATCH v5 2/3] vmalloc: Optimize vfree
Date: Tue, 31 Mar 2026 16:22:00 +0100
Message-ID: <20260331152208.975266-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152208.975266-1-usama.anjum@arm.com>
References: <20260331152208.975266-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60FDDA0002
X-Stat-Signature: ozd84kmtzyq6ir7gzubnybnc1gtr4zd6
X-Rspam-User: 
X-HE-Tag: 1774970543-864532
X-HE-Meta: U2FsdGVkX1+TSNvs1xBymF6jXHWL1F6ToLavUE23rwF/+epHjrhAAnoxumvmrTwDuuHjODoIQNP/h1EfKWyZ4ljtWzLigF9fbR+JS0WOEE0mlykFdJClxramD7GVmVeEAC8yZU4JiOAXL8qXlY8d4N1LzavfreF6vENpeL4oAsXKojhfqdE9Gz1goDYXVAyF9K/+FKm/o0+KoBrjaVR+9MYWG02AOyQLMy8RA3MFiyRVBQBezD2o9WLgf5uBvDGf+tKlegXhSW8n7TrxURVOoFXA1tlrBFAs7Y2Ob0Jq+C4zvttgXtMK2p0YFMCt5y9wAarqpUN35oCO3tugXfYG7y1kQ9nRhx3wPZsklHYKXxVUZwiEDkRKoLuabT+llXb0veN5tY67ReDrbEQmbwrXsDv6NiKl9yP05JpzvGYCnc4AYXYvpvL47ywwsQQtFtX3Lkopws2kAwGwPVDrCto8V6lAqWgY0su0ny+nF13s26SMKM5dGPR5P+431mM2lhCaUNbOCeQlgZ1L5g8vCRCNuSAr8JctKFhFq2RR1UoRw+Jh131ZwyCf6Q5gXAXFJjk2D7oopvmu/e9Ll0Eydg/cuO9ndTDUOGoeTf85jvcwFhc2cd6VDxh2dXZCOAJqfP4P3zIcuyOgguVS6qm5LZBye+TaBZusg1T/k3vJy2HDt8aO3oh2s22YOU0rF30ggGsFdXupLwdz8PofLgYagnGn7tJJ9J7WM4yEWgLW5vWgOb+tewgqV3XMmWXedX5nxODQ7cXYitpXka9zH5g3rQpVL4Q8x0Cu0hGQ8osteYQSu+EeR+4Jl+fJaFSn9ATYUj2+TnTc6Rkk3YJNOvldUCkNQ48WXJScDMd5Dp02XB786Ee1/fI9pi3L6k0h2wRxGfIJiwr38OfIYVwV8rwUl7hObMeYOgJOoUK1hcTZKg3Tp1TbX4ykfvEETaB8B2MtkrSODut8yWJZHXcVDSIo8j9
 o0DEWmxz
 3InClkEfXqoWhkBCe6jPTVnEDKk7tKCqpRdJA0miANPlXbklFDojtEdJuZst6so1t5LjUl6nNuGRTL0GPQ6HDHTZnXmmXnpIvAZ9D+ey4Mx9j79SLU7gVRYVxhJKv3ua1jpFCcLm7osPpgN8O01ojlzTGwGzxhG7KWDQFHAP4KOD/awEjRsksbT8+ws36p9OwIZlJGxHYaS9l9rJaRUwJsC0JzA5OuZlXAKsKzngnKsnXFzb6f4/9v5WED/EimWvfD2hXl9yX9u8mUgkbq7WhCH5uJtggPlIvGrWXdsHo0AwMd8fBMIc105+di5Jh8CAg0x31
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ryan Roberts <ryan.roberts@arm.com>

Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
must immediately split_page() to order-0 so that it remains compatible
with users that want to access the underlying struct page.
Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
allocator") recently made it much more likely for vmalloc to allocate
high order pages which are subsequently split to order-0.

Unfortunately this had the side effect of causing performance
regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
benchmarks). See Closes: tag. This happens because the high order pages
must be gotten from the buddy but then because they are split to
order-0, when they are freed they are freed to the order-0 pcp.
Previously allocation was for order-0 pages so they were recycled from
the pcp.

It would be preferable if when vmalloc allocates an (e.g.) order-3 page
that it also frees that order-3 page to the order-3 pcp, then the
regression could be removed.

So let's do exactly that; update stats separately first as coalescing is
hard to do correctly without complexity. Use free_pages_bulk() which uses
the new __free_contig_range() API to batch-free contiguous ranges of pfns.
This not only removes the regression, but significantly improves
performance of vfree beyond the baseline.

A selection of test_vmalloc benchmarks running on arm64 server class
system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
large order pages from buddy allocator") was added in v6.19-rc1 where we
see regressions. Then with this change performance is much better. (>0
is faster, <0 is slower, (R)/(I) = statistically significant
Regression/Improvement):

+-----------------+----------------------------------------------------------+-------------------+--------------------+
| Benchmark       | Result Class                                             |   mm-new          |  this series       |
+=================+==========================================================+===================+====================+
| micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
|                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
|                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
|                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
|                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
|                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
|                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
|                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
|                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
|                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
|                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
|                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
+-----------------+----------------------------------------------------------+-------------------+--------------------+

Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v4:
- Use num_pages_contiguous() instead of raw loop

Changes since v3:
- Add kerneldoc comment and update description
- Add tag

Changes since v2:
- Remove BUG_ON in favour of simple implementation as this has never
  been seen to output any bug in the past as well
- Move the free loop to separate function, free_pages_bulk()
- Update stats, lruvec_stat in separate loop

Changes since v1:
- Rebase on mm-new
- Rerun benchmarks
---
 include/linux/gfp.h |  2 ++
 mm/page_alloc.c     | 28 ++++++++++++++++++++++++++++
 mm/vmalloc.c        | 16 +++++-----------
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 7c1f9da7c8e56..71f9097ab99a0 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				struct page **page_array);
 #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
 
+void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
+
 unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
 				unsigned long nr_pages,
 				struct page **page_array);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e8c79ea62f1c..9218fda8842a6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5175,6 +5175,34 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 }
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
+/*
+ * free_pages_bulk - Free an array of order-0 pages
+ * @page_array: Array of pages to free
+ * @nr_pages: The number of pages in the array
+ *
+ * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
+ * run are released with a single __free_contig_range() call.
+ *
+ * This assumes page_array is sorted in ascending PFN order. Without that,
+ * the function still frees all pages, but contiguous runs may not be
+ * detected and the freeing pattern can degrade to freeing one page at a
+ * time.
+ *
+ * Context: Sleepable process context only; calls cond_resched()
+ */
+void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
+{
+	while (nr_pages) {
+		unsigned long nr_contig = num_pages_contiguous(page_array, nr_pages);
+
+		__free_contig_range(page_to_pfn(*page_array), nr_contig);
+
+		nr_pages -= nr_contig;
+		page_array += nr_contig;
+		cond_resched();
+	}
+}
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a6..e9b3d6451e48b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3459,19 +3459,13 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
 
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			mod_lruvec_page_state(page, NR_VMALLOC, -1);
-		__free_page(page);
-		cond_resched();
+	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
+		for (i = 0; i < vm->nr_pages; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
 	}
+	free_pages_bulk(vm->pages, vm->nr_pages);
+
 	kvfree(vm->pages);
 	kfree(vm);
 }
-- 
2.47.3


