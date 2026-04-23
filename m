Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237B1F589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7A06B008C; Thu, 23 Apr 2026 08:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BFBA6B0092; Thu, 23 Apr 2026 08:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCD16B0093; Thu, 23 Apr 2026 08:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA1C6B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:24:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDC81120135
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:24:01 +0000 (UTC)
X-FDA: 84689737482.21.F13C9E9
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 229F514000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:23:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uSs8sNFM;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWGjHpC/HwB7fOZCannKHZudf6pNBvZv4RwdF493nao=;
	b=1KdSgOoR91kgtsTuJ3+UNF+0ZiEywu79/jIKSi4ASgjL3+uBB9Y+r6VjT9gQPo90UNi1Da
	iW4EGIeJHJXLbhAf4XATXFOiyF2lrL+j7yuzi8kB1p15ayRgwdOraJaw5KkosK3ymUJkGo
	9/ZMn88xjnQMONnm+XHdBvXkmzp6r8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947040; a=rsa-sha256;
	cv=none;
	b=lx10x87pSfpMxxQOpushUDTPWQO8wZRrDPuXHZSJjin5/LM0dRCkaiwkzFUmnDVcljc+jK
	zNCgw0hIcTDwp1IpJk1vqYMpxMZbPrtmn4FWL6vru8FFn3zC/fn0ZpY8KZSoAFUpuV5gtV
	vyFglXyOEvqnjoXHy78GN7qBwsSZcm0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uSs8sNFM;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776947038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aWGjHpC/HwB7fOZCannKHZudf6pNBvZv4RwdF493nao=;
	b=uSs8sNFMQgoMF4PGSAmwJQVHn2QRYj6ZOrMD/xzKqULAsofXXIyqFRkoCEqJpc6kHTPuy+
	wS+PJOTfcHpfVRZ2dyYuva66+OmWPGg6SpaKwckqm4od1thLjqxVqjoUPI4BcmktBBsOt4
	1KyNGBLHpLboCw9PogA/xes+z33JDAA=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/paddr: prefetch struct page of the next region
Date: Thu, 23 Apr 2026 20:23:37 +0800
Message-ID: <20260423122340.138880-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260423122340.138880-1-jiayuan.chen@linux.dev>
References: <20260423122340.138880-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p3o3145cpd6zs3ke8qcm7fa6ixyyfneu
X-Rspam-User: 
X-Rspamd-Queue-Id: 229F514000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776947039-841615
X-HE-Meta: U2FsdGVkX185SIGejRqXlplZkaSq/VGgG/sI39VxKNz5qI6uzxP/B1eSoEIgTaIglpcl35EWFCmLp++ER+pISJSXj3YVB1VJxx/151mQ7/lhYH7Zd/wkVNtG4LL5w9bs7sVyMGv+he/y2yHCFm6SyKQYbQVA/2ZcOg33sbQOMBlcbLbmVCEybEyChVKlPaFsbEvUJ37pnvgsC+EFy9nHYhD3EO3bBj9tzj6zQgz93fakEEfbHUYsde+S3Jn4qjOZbju9P07bjYYiIuorznutx+TlybZdXk16eo0UHY/lGLcRZWE5R9XaLGWTGBkQ4I2lJUZ62Trjnmvo6xXBI9cFXCj6DZY2+NGU+wYactwcnnAkHiOdZMslmOUIXeGqPk//lvdxh7uWfuJAjPzAzTV43eWgkVrY5RHC9HzrZVEW0m4uRayQ2nfLMj3vGhz4W1VL/J3VsUU+Lc1GzKXFEH+6ojSs0m+KqlKfMJpN+Clw64/XAYwMG9HXa7+So98wRHFAUQMccJmSw8Upi6t29/cl7GYnvGETOnjFHdWCSswujHGlZR3JDLthjP1op6xruObScEK+sd/6q68R3/C6DR2NDSEFD4pLVN9hT8YhpB5U9AsaYDheaVMQw4aO39lwSDj0P7aTv2mwCmOiTrTRsOPUP+s1vXttLz+galH5DxCZb5iIg8T8AWSAeYHXiRfXqHGg/6M6G1sEZGDxopFK4IdZbY6/ByCJc6xNkdt+G/v3q0Q8COuQYehj6W9IxB1n206WG4tig2Q6Z4m9+hqbXvpI5H23uGjkiNjkxWIyzaGJmJpTm5MZT9AjhPpvDBA7dleYenxcgQg+eyCtxrTKs9BpSQoXiPMWOSbCphAy5xBaA1IJGp09xTiSkzz5jVkpYwo0Nd4GouI5QLfv7yMj1F83tOVwb9cYERhDVZTIuufHBvlBt3tET467/CSp2zZ9Du+CKMa8lusjYj/As4NRgRU
 Z92JlAM3
 d8SWlasElnFG17oWVlFeI1TR05LUwt+jBY+P6TAGCworb+8x0YWm+C9tcRzbokPHI6TgWAp95uRqyvP1frzGbCYgdzXFLsKRtJFr6XPYCB9Tu9XoJXrDodHt9mWPkLZnW8Euv0AGRfRLLeoEBiuFG3eUlM73aJgz95Dj0KYB1Wc35Lwq89ZcJrf0o4mwMOcc3Zs0WsrDemNDmXS6S+1pbAM7G5P9N+P7cmUU7qEOmFBzxba/dZmU3BGV74R/COyNmwmE43NDdnFnzBWSOmAuxY0Jz7/Q5mGe5pQehqu/FtsFANDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

In paddr mode with large nr_regions (20k+), damon_get_folio() dominates
kdamond CPU time.  perf annotate shows ~98% of its samples on a single
load: reading page->compound_head for page_folio().  DAMON samples a
random PFN per region, so the access pattern scatters across the
vmemmap with no locality that hardware prefetchers can exploit; every
compound_head load misses to DRAM (~250 cycles).

Issue a software prefetch for the next region's struct page one
iteration before it is needed.  In __damon_pa_prepare_access_check(),
the next region's sampling_addr is picked eagerly (one iteration ahead
of where its mkold will run) so the prefetched line is usable, and the
first region of each epoch is handled with a one-off branch since it
has no predecessor to have pre-picked its addr.  damon_pa_check_accesses()
just prefetches based on sampling_addr already populated by the
preceding prepare pass.

Two details worth calling out:

  - prefetchw() rather than prefetch(): compound_head (+0x8) and
    _refcount (+0x34) share a 64B cacheline.  The subsequent
    folio_try_get() / folio_put() atomics write _refcount, so bringing
    the line in exclusive state avoids a later S->M coherence upgrade.

  - pfn_to_page() rather than pfn_to_online_page(): on
    CONFIG_SPARSEMEM_VMEMMAP the former is pure arithmetic
    (vmemmap + pfn), while the latter walks the mem_section table.  The
    mem_section lookup itself incurs a DRAM miss for random PFNs, which
    would serialize what is supposed to be a non-blocking hint - an
    earlier attempt that used pfn_to_online_page() saw the prefetch
    path's internal stall dominate perf (~91% skid on the converge
    point after the call).  Prefetching an unmapped vmemmap entry is
    safe: the hint is dropped without faulting.

Concurrency: list_next_entry() and &list == &head comparisons are safe
without locking because kdamond is the sole mutator of the region list
of its ctx; external threads must go through damon_call() which defers
execution to the same kdamond thread between sampling iterations
(see documentation on struct damon_ctx and damon_call()).

Tested with paddr monitoring, max_nr_regions=20000, and stress-ng-vm
consuming ~90% of memory across 8 workers: kdamond CPU further reduced
from ~50% to ~40% of one core on top of the earlier damon_rand_fast()
change.

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/damon/paddr.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b5e1197f2ba2..99bdf2b88cf1 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -10,6 +10,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/pagemap.h>
+#include <linux/prefetch.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
@@ -48,10 +49,29 @@ static void damon_pa_mkold(phys_addr_t paddr)
 	folio_put(folio);
 }
 
+static void damon_pa_prefetch_page(unsigned long sampling_addr,
+				   unsigned long addr_unit)
+{
+	phys_addr_t paddr = damon_pa_phys_addr(sampling_addr, addr_unit);
+
+	prefetchw(pfn_to_page(PHYS_PFN(paddr)));
+}
+
 static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
+					    struct damon_target *t,
 					    struct damon_region *r)
 {
-	r->sampling_addr = damon_rand_fast(ctx, r->ar.start, r->ar.end);
+	struct damon_region *next = list_next_entry(r, list);
+
+	/* First region has no predecessor to have pre-picked its addr. */
+	if (r->list.prev == &t->regions_list)
+		r->sampling_addr = damon_rand_fast(ctx, r->ar.start, r->ar.end);
+
+	if (&next->list != &t->regions_list) {
+		next->sampling_addr = damon_rand_fast(ctx, next->ar.start,
+						      next->ar.end);
+		damon_pa_prefetch_page(next->sampling_addr, ctx->addr_unit);
+	}
 
 	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, ctx->addr_unit));
 }
@@ -63,7 +83,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(ctx, r);
+			__damon_pa_prepare_access_check(ctx, t, r);
 	}
 }
 
@@ -106,11 +126,16 @@ static void __damon_pa_check_access(struct damon_region *r,
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
-	struct damon_region *r;
+	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
+			next = list_next_entry(r, list);
+			if (&next->list != &t->regions_list)
+				damon_pa_prefetch_page(next->sampling_addr,
+						       ctx->addr_unit);
+
 			__damon_pa_check_access(
 					r, &ctx->attrs, ctx->addr_unit);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-- 
2.43.0


