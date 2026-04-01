Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E851ED35170
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F62C6B0089; Wed,  1 Apr 2026 06:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CDAD6B008A; Wed,  1 Apr 2026 06:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AF36B0092; Wed,  1 Apr 2026 06:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBC56B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:16:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8EA15ABFC
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:50 +0000 (UTC)
X-FDA: 84609583380.11.BF0F2EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 439E1100005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J3ZvvhvS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038609; a=rsa-sha256;
	cv=none;
	b=3jsJUj4C+K10ljHF7/GOAXLCI5Dgat4ZVxMmyvDpShl5vH2zTCoF8VYNug7jzjQRiHBFGu
	hO8kpibQN/mJYw3GZ8pnXgqhodkUmj1jukgok9YsWboh8GouFvPlAoUptVMRRlHf5ROIbu
	BqcmQwOwywifU9B1ob8Nnqg3MRKtPQA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J3ZvvhvS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEVpL+mlD6MH/rTqszVkwdkbglwGP0fva6tVe5jlrL0=;
	b=p9sDNxcaO+h/MhRmKOwfbmIsCF+YuG+nBQexcTob/tUq0dU/W18dQujf22laIF2j0CrDPS
	HUsUp5iweGrUAX83u1H3jByJJ1BAdiFwRm35TPhR3eneoDe46dzCqbPVnua1Tof9l2X1XT
	i4DRJLfI4AJTj2+cZQ7uGs5BGpPQyRA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EF531D6F;
	Wed,  1 Apr 2026 03:16:42 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BE5113F915;
	Wed,  1 Apr 2026 03:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775038608; bh=JN9LORaGNR5ojKf5taVlBlY4Jfmvak7f5Q0huNC9Lxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3ZvvhvS5wYUqXMwy+7NYijG7V8U8N0NDsmuyJenhOfNbI8l9eBSxdkAeeRg2JbwO
	 m8VgEddfAHiltE68rHFMvilRC6Sv64l+BoIyAQ0yIOchzhzz7YOqqp4gMGGeVneb+m
	 7iQ7kcadOsArvnpyjFsn9pEtiCePhtQFliyRYVm8=
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
Subject: [PATCH v6 2/3] vmalloc: Optimize vfree with free_pages_bulk()
Date: Wed,  1 Apr 2026 11:16:20 +0100
Message-ID: <20260401101634.2868165-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401101634.2868165-1-usama.anjum@arm.com>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yyrddqugsne46mud945bqxz7fmtamfns
X-Rspamd-Queue-Id: 439E1100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775038609-917593
X-HE-Meta: U2FsdGVkX18YJscC5fhquPyg+OPSkIaLH15j6b5DyUdqszQLbgBNVQM0G50Ixr+UwWMO8w/DQb9ML7nlKBJZjoop4vHQNdUo0iObjBaf7fjiKzHS2GaO55l7Lm2foempoXNmJZQifAY8g/NyxctxfJ+mV+XgyA2FeqfrUlhOHhF4AOVb0FkFzJhU/jKw5lyILeXUH1UCvlbFTeATcNCLxBBcIAJqjqY+YBfvXDOvw1S9iH+Pna4MWb4mGKt6u7aX+ilXZfnZdeWhmKQVuQkZbublTaZuz3CFBvjgafqErwKcGCBuWpqkfdcgwTnOVRDRImRab9zGF8ayJLZg7AqlgYzEtJSTRMQ3WCr9RtlR3lgRPxwgV8R5wE/olhK+HtdiUCB7i4KcVEo1mhp7F/f1PqmrKVwRt/6UL6ZUAYG2yxn10uCa0Z/N6BD9d0++uq2POY2SyjXPmSC0sjbQb1+8jJG6Rkl1/ZOKRz2Yn+uf6fbNPGiPJJujQJNzp6tCP/2+WN5DYjmbZDgo/KF8R8h3mCacEltdSmRYt0t4UuWb8nYwCy126SOZkBvaj22jUTQ05URE6iZuRyo//VcmIS9VClpipCO9MWzVx6YoP/qUAIdAmfIf9UchErEgEigOeRKgoY78Y+CTJP6eZ6Q/1g0D7uJPwjlCUBMTuY8senATxF7uGPpoe6kR1iTNo17eLeLB1pesNHqjib/9v1WQbySG/+FVQxAnMlXOBTw0Thl5kNBuhzlcLfP2FdHxs+n2yJWxOGwtf7dGSpLm/I1sQuuIPrwgWK53Bu+5+qUabEZ7CuenK+2m1bmdO0UgVDkSx8Iriad7RGZYe25A9bgQVoayGU0vTPjzeTY/LQc4Tdk3wxwSClc33DG/gAaV+8Gvec9F7ln6FJvTDG5HdYuvy7Tk7skfn4q0rUmwy2HWalkfuAiIeLQPKmfLBaEN5aIFEFhudP+0IXCUa7f2Yv5xCaA
 tzv7C0bI
 bcsUTMJg/XWYQ7tU=
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
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v5:
- Change subject

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
index fb4522ba51faf..6568af69b5cdb 100644
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


