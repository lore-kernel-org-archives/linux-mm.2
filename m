Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89CBAF46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84A56B01F3; Mon, 16 Mar 2026 07:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97016B01F5; Mon, 16 Mar 2026 07:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99C46B01F6; Mon, 16 Mar 2026 07:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B86D86B01F3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:32:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 688401B6EF1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:37 +0000 (UTC)
X-FDA: 84551713554.23.748E00A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2C1116000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773660756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kDqR65hAW1c80WgsRrCEx44SuKKYXFhoHOKFaWdxIhk=;
	b=kcpC76zp0+MVnGznsPovDHwez8K37m9mY8WWQu2YU1JiebAmc4cvSyXODp7Q+dGO+JwhFc
	9jo2pLExjFEdlS7fLNSyHo4dbOP0gEnl9ZgUt64/JTiH4jphYWKuaJxQRXj+n9V1t5UQhS
	/vsO8shAv6dRgIsEnAvq+i1RZGH+hlg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773660756; a=rsa-sha256;
	cv=none;
	b=Y9VTrZirm1kKtzAnEHvOd/MlpvzQNsgljFFSRjoX5vyW/AcnwUi9vwAcqcIOXuoyzfIahh
	bQc5fFMgkbvJgW/XxKf50FHWV/qLPaoudxkv4fD932e9Q9wK7b3UKYUgBejmGu4YMo4yfG
	4tKuRAzcicerfnbbcIrCv4+aT6w3EhU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A58EB1477;
	Mon, 16 Mar 2026 04:32:28 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 492693F778;
	Mon, 16 Mar 2026 04:32:32 -0700 (PDT)
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
Subject: [PATCH v2 2/3] vmalloc: Optimize vfree
Date: Mon, 16 Mar 2026 11:31:43 +0000
Message-ID: <20260316113209.945853-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316113209.945853-1-usama.anjum@arm.com>
References: <20260316113209.945853-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2C1116000E
X-Stat-Signature: u76maowhw3f873oqt6jg6x1ra33qcytr
X-Rspam-User: 
X-HE-Tag: 1773660755-751395
X-HE-Meta: U2FsdGVkX1/bmClsl1I/wF8llzl7yqudKBCurNEApO6TC6i7KloHypTklTndgcZgt+wER+NpmgGHIENHI6GarLjP1WHvizV8f5ixQzOOnuKe53Lm17kslBGOh+UUv5OnRaTYGjZhWQDyl26l921PXFcMYFM8tVIDEXgtNBKS+Wr5qNgeT09J7zqtyCSHwsvKp/5jAu91swTfmgZjEBsdEkl9Ea7yBtBgzE34zKcvEIuQMOA4SOIZEMPoQz6nOZ5/hUinvpYXECsZ1mEMJwR6PzrNJgh8e9jxhhtcGkUd9J7t9FPEYPpZzfxdeoE55D1W89TXfDcLO6+mkKXHPUrxsAcEcQ28xxsGAcU7whe6x9mvFzLF7lgoDbWKwTJ9uCNQB2zIgUQKb9o6DtXava0P+FEbW1dJf5j8kcltz1rOT0P/T+4lHK0kO1u+xDXoa0aYJSQ4TWyETDylyPSD727Kbf93Y8yS6Tmgy9jm1Fmgjc5Z22Eo9y/YnuStCI14IaDrQJCxsp4yGp/KwW1c1l9jKDRxuyOErY4TIILTPWpxD22wAufpwjH5R60yqBIxjWn0vxIdG4vVuy5iRUXgNAHTNvKIAOIl94idoJZifRE8gcYd3Me2sG6tbxcm15A8w+cVfvmF0ZgpMpullaDW4KLyAm4FdR/Ue3j73dmNRp1KsjcCQ8cCfhJk2supfpZMI+FYom49cekAMvoiqVUSmqDASJ14iL8IunoXIIHNthoTWU6A1Dlk7NJ7bwfLu4UA/kYiw8jSeryWHRMVnF6qXjAKArIBHvQD/hoOq7pPP/F55l2IgX7lfESxl91cEVNd19Sj+RVS1Ingxx+gHGw0mC1Vx7RJxU5QMsvDkQRi8SXnH0LcCVl9spCDtCsP9gMiPc6bLUjloVyzhAf6AGNgNW7vfHbRCuLVfG1w
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

So let's do exactly that; use the new __free_contig_range() API to
batch-free contiguous ranges of pfns. This not only removes the
regression, but significantly improves performance of vfree beyond the
baseline.

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
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Rebase on mm-new
- Rerun benchmarks
---
 mm/vmalloc.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a6..8b935395fb068 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3459,18 +3459,34 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
+
+	if (vm->nr_pages) {
+		bool account = !(vm->flags & VM_MAP_PUT_PAGES);
+		unsigned long start_pfn, pfn;
+		struct page *page = vm->pages[0];
+		int nr = 1;
 
 		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
+		start_pfn = page_to_pfn(page);
+		if (account)
 			mod_lruvec_page_state(page, NR_VMALLOC, -1);
-		__free_page(page);
-		cond_resched();
+
+		for (i = 1; i < vm->nr_pages; i++) {
+			page = vm->pages[i];
+			BUG_ON(!page);
+			if (account)
+				mod_lruvec_page_state(page, NR_VMALLOC, -1);
+			pfn = page_to_pfn(page);
+			if (start_pfn + nr == pfn) {
+				nr++;
+				continue;
+			}
+			__free_contig_range(start_pfn, nr);
+			start_pfn = pfn;
+			nr = 1;
+			cond_resched();
+		}
+		__free_contig_range(start_pfn, nr);
 	}
 	kvfree(vm->pages);
 	kfree(vm);
-- 
2.47.3


