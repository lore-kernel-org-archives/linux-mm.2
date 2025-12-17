Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D311D65C62
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E446B0088; Wed, 17 Dec 2025 10:20:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E768A6B0089; Wed, 17 Dec 2025 10:20:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3436B008C; Wed, 17 Dec 2025 10:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBEB46B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:20:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 631098B91F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:20:20 +0000 (UTC)
X-FDA: 84229324200.11.0B0D1F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2D7391C0003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:20:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765984818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DvvCEBOrt1MOIEG40xCf8aQbz6n5hOsoE8a7EfLHNH0=;
	b=yMf5AdZMwO4oSvA38DbXYJSb1wGmEqgCas6OW4UuWYRunigifeuJuIwmqpk1dyH0ccwzMB
	H+f68FkhggkH/4Q5p9tRQxUNkMxECJHw/2v6GebEtcDwyQWkkGfkCEp08rGIIXYWto+C7Q
	NbwM3dbWadw49WM/z5syXeMWgBP0FFc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765984818; a=rsa-sha256;
	cv=none;
	b=VsGBUaVXkpAfdcGuXF0b5Kcp71PezVc1jYZ+Yk03jM9DQ9B5sCyQfmFPehD9nKlZi4FXWi
	Hi64mlZtmwH4DsGU6761Xw1O5KlnGDa4X/wLjYCpH/JL8JQAqKoxUZ5BvJClFprLpvYsaN
	NTmV2AMobCx6kh9umXB+CyC0ujhSzG0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9738FEC;
	Wed, 17 Dec 2025 07:20:09 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C56C53F73F;
	Wed, 17 Dec 2025 07:20:15 -0800 (PST)
Message-ID: <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
Date: Wed, 17 Dec 2025 15:20:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUKb1bL7CUcCWi8V@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ergpzqkb5kohhx1izwg5msept15nz16x
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D7391C0003
X-HE-Tag: 1765984817-866242
X-HE-Meta: U2FsdGVkX1+4erO5p8cknxXT73DI3nlVRaOf2VuUGwnW5WR1t0654ZYdrFn62J9qDWiCV7NFVWb7Zd8tC9P0T48zEns9gMsKLCGTpF8fyZL9T2mNRr7kn612OLkMmvAD6hWQRI5EN/lgsvTnnAEoB5vXdG8Y3Lnfp/GVYKnIYqbppAwhYvpTXnVGBkbogOs7CNstKctnxqCYzXsugFBx6G2OVT5K1IBCbM6k7VVilgsTRev5ja0fEaVsZ7Z5cF6tVda9x6oRB803gIucs+48aowGMaPV3E2Kj4Rw5FCCHuZw3cwHP9Ru5g43GyiXkv9NuylnJPfDIIx9Q2fgvM0bMcXIQobISaB5P4k3G7FD4SGRl7nOjLQVk3tsXfHtLS39udFhz27tU2IjVTIcK4KD6Rp74DpLLN3d+Aj3ZEc+4XaCi5FZpvubVL9WnWRl11CAR3moul9c5HmbBBBkM+Umx8qd9YLvo4FEfLZJF2U8spWoaTHruv+W8bFmP/cHGPPdWqsjG8bDzUkmAeItq8iW/6/35MLHF+G+CHSRkAJkHhExnq3XLHZGTOFjQi2/58XvbjACUweiVPAcObyTkOiDrvXxPyYO7f0jwGcPdGYWMWYJ2UTlHBZzMJpTPJu0HiuKaKe85+nakllvBewS9RE1Y7ezSJmZqS+QFR0vxZawqyq4MArfalcFZlNnMtN+H/aXTzyCP9GXOGS4Ubl/YqSB1cBKHnKw9hmms/CwZKUt7J5JFBvwX+Ugj1wJKH++LNal+5J4Daowbut4r4/FsO1/kRExnfxsNhlSCKaXNJqbIteU1ghAY04Jam3K26/Mi0RcKSvAD9lEctGnmoaBB0icKsJEq4ZuEGqBVuEBjKmlva7vYnffM4HOXLk/P5KMu+HiiDsY1mDG7rmmwSclHmD6Ksp5jkYmq+yJP3JhJFZm8iyBm1BxT1O1nTLkGGlKh0aJKL/V4UN5dG7Mog8SP6H
 cMf8PxCW
 1v87yxNLcNkNOzYh4Oe2F6UQ8oepNw7hKgkYO6H8+4QbYs/QpTSe+qZsccAroMkbGI12+vv+qQBVMWN+xo6zczIqMngyMOgzkmBJ4Hf6rEi9yEkzNfOzjC8c4+bI+yxbY1HOuIQfsIY8gyH8ioRAg5NWQ8ldxqYok7twYhmzcOWPGbNgAKwTiOR9B4AJOi93mEi3MXu54lhY10WmnNGF/I8x5vrtnQXHwwRooSBi+81JPspzNH+ubxPJa9TxlMhGA1Y5AhI7CpiYhJToDZImqi1AWVNyXK1YTdF9JXc16GzHCVRfmSoaHvqgXfpSe573NcJwjfGR7FLXbMB0c6E8864oYYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 12:02, Uladzislau Rezki wrote:
>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>> Introduce a module parameter to enable or disable the large-order
>>> allocation path in vmalloc. High-order allocations are disabled by
>>> default so far, but users may explicitly enable them at runtime if
>>> desired.
>>>
>>> High-order pages allocated for vmalloc are immediately split into
>>> order-0 pages and later freed as order-0, which means they do not
>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>> can affect performance.
>>>
>>> However, when the PCP caches are empty, high-order allocations may
>>> show better performance characteristics especially for larger
>>> allocation requests.
>>
>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>> else try large order, else fallback to order-0" Could that provide the best of
>> all worlds without needing a configuration knob?
>>
> I am not sure, to me it looks like a bit odd. 

Perhaps it would feel better if it was generalized to "first try allocation from
PCP list, highest to lowest order, then try allocation from the buddy, highest
to lowest order"?

> Ideally it would be
> good just free it as high-order page and not order-0 peaces.

Yeah perhaps that's better. How about something like this (very lightly tested
and no performance results yet):

(And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
with a contiguous run of order-0 pages, but I'm not seeing any warnings or
memory leaks when running mm selftests...)

---8<---
commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
Author: Ryan Roberts <ryan.roberts@arm.com>
Date:   Wed Dec 17 15:11:08 2025 +0000

    WIP

    Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b155929af5b1..d25f5b867e6b 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);

+void free_pages_bulk(struct page *page, int nr_pages);
+
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..5f11224cf353 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
order,
 	}
 }

+static void free_frozen_pages_bulk(struct page *page, int nr_pages)
+{
+	while (nr_pages) {
+		unsigned int fit_order, align_order, order;
+		unsigned long pfn;
+
+		pfn = page_to_pfn(page);
+		fit_order = ilog2(nr_pages);
+		align_order = pfn ? __ffs(pfn) : fit_order;
+		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
+
+		free_frozen_pages(page, order);
+
+		page += 1U << order;
+		nr_pages -= 1U << order;
+	}
+}
+
+void free_pages_bulk(struct page *page, int nr_pages)
+{
+	struct page *start = NULL;
+	bool can_free;
+	int i;
+
+	for (i = 0; i < nr_pages; i++, page++) {
+		VM_BUG_ON_PAGE(PageHead(page), page);
+		VM_BUG_ON_PAGE(PageTail(page), page);
+
+		can_free = put_page_testzero(page);
+
+		if (!can_free && start) {
+			free_frozen_pages_bulk(start, page - start);
+			start = NULL;
+		} else if (can_free && !start) {
+			start = page;
+		}
+	}
+
+	if (start)
+		free_frozen_pages_bulk(start, page - start);
+}
+
 /**
  * __free_pages - Free pages allocated with alloc_pages().
  * @page: The page pointer returned from alloc_pages().
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..8f782bac1ece 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
+	struct page *start;
+	int i, nr;

 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3455,17 +3456,26 @@ void vfree(const void *addr)
 	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
 		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
-	for (i = 0; i < vm->nr_pages; i++) {
+
+	start = vm->pages[0];
+	BUG_ON(!start);
+	nr = 1;
+	for (i = 1; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];

 		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		__free_page(page);
-		cond_resched();
+
+		if (start + nr != page) {
+			free_pages_bulk(start, nr);
+			start = page;
+			nr = 1;
+			cond_resched();
+		} else {
+			nr++;
+		}
 	}
+	free_pages_bulk(start, nr);
+
 	if (!(vm->flags & VM_MAP_PUT_PAGES))
 		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
 	kvfree(vm->pages);
---8<---

> 
>>>
>>> Since the best strategy is workload-dependent, this patch adds a
>>> parameter letting users to choose whether vmalloc should try
>>> high-order allocations or stay strictly on the order-0 fastpath.
>>>
>>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>> ---
>>>  mm/vmalloc.c | 9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index d3a4725e15ca..f66543896b16 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -43,6 +43,7 @@
>>>  #include <asm/tlbflush.h>
>>>  #include <asm/shmparam.h>
>>>  #include <linux/page_owner.h>
>>> +#include <linux/moduleparam.h>
>>>  
>>>  #define CREATE_TRACE_POINTS
>>>  #include <trace/events/vmalloc.h>
>>> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>>>  	return nr_allocated;
>>>  }
>>>  
>>> +static int attempt_larger_order_alloc;
>>> +module_param(attempt_larger_order_alloc, int, 0644);
>>
>> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
>> Y/N as the value; that's probably more intuitive?
>>
>> nit: I'd favour a shorter name. Perhaps large_order_alloc?
>>
> Thanks! We can switch to bool and use shorter name for sure.
> 
> --
> Uladzislau Rezki


