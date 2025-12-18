Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F23D6ACE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018B36B0088; Thu, 18 Dec 2025 06:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08996B0089; Thu, 18 Dec 2025 06:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0846B008A; Thu, 18 Dec 2025 06:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C99A16B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:12:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59292610F1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:12:21 +0000 (UTC)
X-FDA: 84232328082.10.0C79BD1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3004E18000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:12:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766056339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxZYvPI3yq0haOsX4v2VRxpp2T+1n3LMo7vnWtJ1+Zc=;
	b=s2ufBM1adkladrfhCVXw9qfEkzZfnayQVTjqVaOff2kV1coMxPRv8uv4gS5mAF1nODL7dN
	0m5UmitJq1x/1D3MTbsuWiWfUslfR6HAtPtGxOXVLdxLVcwpBHsbE7N0tyZ6Kh4YvVDQYt
	6bxmPUQ0KYxXJJBr0XqBueh/pEEIWp0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766056339; a=rsa-sha256;
	cv=none;
	b=D/QwJHW+0xbvpNl48K4D0iMOBKJypV8pdhc760AvxW83YphCU9ixzq0WlLXbErw6zMADzn
	3Psiz/eYa28OtW4GxDM5G6bOeAD75j2nryW18WM35ADhrsmij7U70QJBpY6xqPjqbln2XA
	jl2znZgbOmkwe2ewZxbO90ZZdDdjr9c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C158FEC;
	Thu, 18 Dec 2025 03:12:11 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A64A3F73F;
	Thu, 18 Dec 2025 03:12:17 -0800 (PST)
Message-ID: <37efa0a9-99bc-4099-ba64-2474f3f09aa2@arm.com>
Date: Thu, 18 Dec 2025 11:12:15 +0000
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
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com> <aUMDCSTewPSLCbYM@milan>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUMDCSTewPSLCbYM@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hid9yqhgecntrprk36psxet3usbytn4j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3004E18000E
X-HE-Tag: 1766056339-689860
X-HE-Meta: U2FsdGVkX18Xc8zyat8zgYI/HgGBe2esDMVkZ+OzxXesoqIaUqNOflWl7F8s5bvfAe3QUozpiamYr1feDAoHrH97e6TvgV7P0nhifmpElbRfPmThYTNTYl132wGUkbe6bivTWl4RBYDXhqfjinEalo3bt+X0CUzYrBf0A/ovjQ8/cng3mQ192DIllSWBqs1FvWVVe8n8rtDQ6qGlch8toP2Utat5tl6HNqV8KGIOKNkko1NBuLhQHwY3IwtJBOGqiTjRJgnjucnP+m/D1keq5vSfMjGXxSKqpeLKJiXNK2aHG+ZDmTJz17RZ/pSefXFqzQPTpQq1DjTucZPKrMW5dV0VpKcxJKLJrT0Ikpdl8SWVmZsgh1OShsK4g4Z7WY2PwKRbLt94O5JkjZ7LexedRzOQSlQhK4Yoor/lH6TFNXHveL/D+Cd28sUkTzBJd0GgjaKNUk477jLVAKozQceoOS11Wam1QtCaXibRKxCkxC+jRod2OrU+Xyi4yEynvVf/E8gfHeRxYIDZhMdroJU2FPhqAxBSyY0nY6R8CuGeIE9nRl/pg3EtkUoOUoUguoZm3ZSw+Ag2ZDwn8UUzk6caO0uW+6HMXZxS+FYIrBIxAw1TmL4sk11MdTtGWR1M++sGp2tzNAjFcHgzFnwUROf1tPUN8eifbjTe2qfctsRVh19kQO23aKuY9CMQwUroakAQfh9CPQwAhFcQFEtv4BOcHbDG401o4M+OzHRzo32x+2LsE+kx9zvH6PD5FwLuTtMz5N0k8YKdT2xOAiR2qVX6speYkrsvPHYZW+ADzAeEYjWx7YEx0pjdnDtVEzeExXxjX3PjufEnoTy2yeBcSaSihrrYPU05u97+tQJCgJpUqfyB+CfRByYFA8+cXnyA0f/wvH7bljJOhY/Vc6LHl9+vgUlZwzDqT3emHS4yrYbr9xKxYDBaZ6pyVh5oFHfE6xgNQZQdYUUsyGsVXrfvttu
 4pyxM7dj
 ukNaigjSvEdO34K5yTTrT92+PgSnmhbY4VyUTG0AR68jDa+bD86Ev60cguy3DGmi2DIHqLENY2mhemAp1HvjaXwC4GR1fzoGn9Pgne3FKF/+GRSJBZ9FJouL5wVF07VItGgrorZKAFQTOkID70CMkT6LHVmNejec1na2ng7Nv42ElV2KYqmID49wrukRCDTl2hKzCDhi4A6XPnTOGvmUSvOejIg/vkpuf0vP9ML/I64kJOMO+M+N7qKmrBGPitLrNz6j7tb24P9fB62HvBVYi6kGptBv5Hi3qsWy7RBnHftXIZJpIUkMGj6cA54DdRVmfbEvc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 19:22, Uladzislau Rezki wrote:
> On Wed, Dec 17, 2025 at 05:01:19PM +0000, Ryan Roberts wrote:
>> On 17/12/2025 15:20, Ryan Roberts wrote:
>>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>>>> Introduce a module parameter to enable or disable the large-order
>>>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>>>> default so far, but users may explicitly enable them at runtime if
>>>>>> desired.
>>>>>>
>>>>>> High-order pages allocated for vmalloc are immediately split into
>>>>>> order-0 pages and later freed as order-0, which means they do not
>>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>>>> can affect performance.
>>>>>>
>>>>>> However, when the PCP caches are empty, high-order allocations may
>>>>>> show better performance characteristics especially for larger
>>>>>> allocation requests.
>>>>>
>>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>>>> else try large order, else fallback to order-0" Could that provide the best of
>>>>> all worlds without needing a configuration knob?
>>>>>
>>>> I am not sure, to me it looks like a bit odd. 
>>>
>>> Perhaps it would feel better if it was generalized to "first try allocation from
>>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>>> to lowest order"?
>>>
>>>> Ideally it would be
>>>> good just free it as high-order page and not order-0 peaces.
>>>
>>> Yeah perhaps that's better. How about something like this (very lightly tested
>>> and no performance results yet):
>>>
>>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>>> memory leaks when running mm selftests...)
>>>
>>> ---8<---
>>> commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
>>> Author: Ryan Roberts <ryan.roberts@arm.com>
>>> Date:   Wed Dec 17 15:11:08 2025 +0000
>>>
>>>     WIP
>>>
>>>     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>> index b155929af5b1..d25f5b867e6b 100644
>>> --- a/include/linux/gfp.h
>>> +++ b/include/linux/gfp.h
>>> @@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
>>>  extern void free_pages_nolock(struct page *page, unsigned int order);
>>>  extern void free_pages(unsigned long addr, unsigned int order);
>>>
>>> +void free_pages_bulk(struct page *page, int nr_pages);
>>> +
>>>  #define __free_page(page) __free_pages((page), 0)
>>>  #define free_page(addr) free_pages((addr), 0)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 822e05f1a964..5f11224cf353 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
>>> order,
>>>  	}
>>>  }
>>>
>>> +static void free_frozen_pages_bulk(struct page *page, int nr_pages)
>>> +{
>>> +	while (nr_pages) {
>>> +		unsigned int fit_order, align_order, order;
>>> +		unsigned long pfn;
>>> +
>>> +		pfn = page_to_pfn(page);
>>> +		fit_order = ilog2(nr_pages);
>>> +		align_order = pfn ? __ffs(pfn) : fit_order;
>>> +		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
>>> +
>>> +		free_frozen_pages(page, order);
>>> +
>>> +		page += 1U << order;
>>> +		nr_pages -= 1U << order;
>>> +	}
>>> +}
>>> +
>>> +void free_pages_bulk(struct page *page, int nr_pages)
>>> +{
>>> +	struct page *start = NULL;
>>> +	bool can_free;
>>> +	int i;
>>> +
>>> +	for (i = 0; i < nr_pages; i++, page++) {
>>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>>> +
>>> +		can_free = put_page_testzero(page);
>>> +
>>> +		if (!can_free && start) {
>>> +			free_frozen_pages_bulk(start, page - start);
>>> +			start = NULL;
>>> +		} else if (can_free && !start) {
>>> +			start = page;
>>> +		}
>>> +	}
>>> +
>>> +	if (start)
>>> +		free_frozen_pages_bulk(start, page - start);
>>> +}
>>> +
>>>  /**
>>>   * __free_pages - Free pages allocated with alloc_pages().
>>>   * @page: The page pointer returned from alloc_pages().
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index ecbac900c35f..8f782bac1ece 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
>>>  void vfree(const void *addr)
>>>  {
>>>  	struct vm_struct *vm;
>>> -	int i;
>>> +	struct page *start;
>>> +	int i, nr;
>>>
>>>  	if (unlikely(in_interrupt())) {
>>>  		vfree_atomic(addr);
>>> @@ -3455,17 +3456,26 @@ void vfree(const void *addr)
>>>  	/* All pages of vm should be charged to same memcg, so use first one. */
>>>  	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
>>>  		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
>>> -	for (i = 0; i < vm->nr_pages; i++) {
>>> +
>>> +	start = vm->pages[0];
>>> +	BUG_ON(!start);
>>> +	nr = 1;
>>> +	for (i = 1; i < vm->nr_pages; i++) {
>>>  		struct page *page = vm->pages[i];
>>>
>>>  		BUG_ON(!page);
>>> -		/*
>>> -		 * High-order allocs for huge vmallocs are split, so
>>> -		 * can be freed as an array of order-0 allocations
>>> -		 */
>>> -		__free_page(page);
>>> -		cond_resched();
>>> +
>>> +		if (start + nr != page) {
>>> +			free_pages_bulk(start, nr);
>>> +			start = page;
>>> +			nr = 1;
>>> +			cond_resched();
>>> +		} else {
>>> +			nr++;
>>> +		}
>>>  	}
>>> +	free_pages_bulk(start, nr);
>>> +
>>>  	if (!(vm->flags & VM_MAP_PUT_PAGES))
>>>  		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>>>  	kvfree(vm->pages);
>>> ---8<---
>>
>> I tested this on a performance monitoring system and see a huge improvement for 
>> the test_vmalloc tests.
>>
>> Both columns are compared to v6.18. 6-19-0-rc1 has Vishal's change to allocate 
>> large orders, which I previously reported the regressions for. vfree-high-order 
>> adds the above patch to free contiguous order-0 pages in bulk.
>>
>> (R)/(I) means statistically significant regression/improvement. Results are 
>> normalized so that less than zero is regression and greater than zero is 
>> improvement.
>>
>> +-----------------+----------------------------------------------------------+--------------+------------------+
>> | Benchmark       | Result Class                                             |   6-19-0-rc1 | vfree-high-order |
>> +=================+==========================================================+==============+==================+
>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  (R) -40.69% |        (I) 3.98% |
>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |        0.10% |           -1.47% |
>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  (R) -22.74% |       (I) 11.57% |
>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  (R) -23.63% |       (I) 47.42% |
>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |       -1.58% |      (I) 106.01% |
>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  (R) -24.39% |       (I) 99.12% |
>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |    (I) 2.34% |      (I) 196.87% |
>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |  (R) -23.29% |      (I) 125.42% |
>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |    (I) 3.74% |      (I) 238.59% |
>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |  (R) -23.80% |      (I) 132.38% |
>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |   (R) -2.84% |      (I) 514.75% |
>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |        2.74% |            0.33% |
>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |        0.58% |            1.36% |
>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       -0.66% |            1.48% |
>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |  (R) -25.24% |       (I) 77.95% |
>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |       -0.58% |            0.60% |
>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  (R) -45.75% |        (I) 8.51% |
>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |  (R) -28.16% |       (I) 65.34% |
>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |       -0.54% |           -0.33% |
>> +-----------------+----------------------------------------------------------+--------------+------------------+
>>
>> What do you think?
>>
> You were first :)
> 
> Some figures from me:
> 
> # Default(3 pages)

What is Default? I'm guessing it's the state prior to Vishal's patch?

> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 541868 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 542515 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 541561 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 542951 usec
> 
> # Patch(3 pages)

What is Patch? I'm guessing state after applying both Vishal's and my patches?

> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 585266 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 594301 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 598912 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 589345 usec
> 
> Now the perf figures are almost settled and aligned with default!
> We do use per-cpu-cache for 3 pages allocations.
> 
> # Default(100 pages)
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 5724919 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 5721430 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 5717224 usec
> 
> # Patch(100 pages)
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2629600 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2622811 usec
> fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2629324 usec
> 
> ~2x faster! It is because of freeing now occurs much more efficient
> so we spent less cycles on free path comparing with default case.
> 
> See below, perf also confirms that vfree() ~2x consumes less cycles:
> 
> # Default
> +   96.99%     0.49%  [test_vmalloc]        [k] fix_size_alloc_test
> +   59.64%     2.38%  [kernel]              [k] vfree.part.0
> +   45.69%    15.80%  [kernel]              [k] __free_frozen_pages
> +   39.83%     0.00%  [kernel]              [k] ret_from_fork_asm
> +   39.83%     0.00%  [kernel]              [k] ret_from_fork
> +   39.83%     0.00%  [kernel]              [k] kthread
> +   38.67%     0.00%  [test_vmalloc]        [k] test_func
> +   36.64%     0.01%  [kernel]              [k] __vmalloc_node_noprof
> +   36.63%     0.20%  [kernel]              [k] __vmalloc_node_range_noprof
> +   17.55%     4.94%  [kernel]              [k] alloc_pages_bulk_noprof
> +   16.46%    12.21%  [kernel]              [k] free_frozen_page_commit.isra.0
> +   16.06%     8.09%  [kernel]              [k] vmap_small_pages_range_noflush
> +   12.56%    10.82%  [kernel]              [k] __rmqueue_pcplist
> +    9.45%     9.43%  [kernel]              [k] __get_pfnblock_flags_mask.isra.0
> +    7.95%     7.95%  [kernel]              [k] pfn_valid
> +    5.77%     0.03%  [kernel]              [k] remove_vm_area
> +    5.44%     5.44%  [kernel]              [k] ___free_pages
> +    4.67%     4.59%  [kernel]              [k] __vunmap_range_noflush
> +    4.30%     4.30%  [kernel]              [k] __list_add_valid_or_report
> 
> # Patch
> +   94.28%     1.00%  [test_vmalloc]        [k] fix_size_alloc_test
> +   55.63%     0.03%  [kernel]              [k] __vmalloc_node_noprof
> +   55.60%     3.78%  [kernel]              [k] __vmalloc_node_range_noprof
> +   37.26%    19.29%  [kernel]              [k] vmap_small_pages_range_noflush
> +   37.12%     5.63%  [kernel]              [k] vfree.part.0
> +   30.59%     0.00%  [kernel]              [k] ret_from_fork_asm
> +   30.59%     0.00%  [kernel]              [k] ret_from_fork
> +   30.59%     0.00%  [kernel]              [k] kthread
> +   28.79%     0.00%  [test_vmalloc]        [k] test_func
> +   17.90%    17.88%  [kernel]              [k] pfn_valid
> +   13.24%     0.02%  [kernel]              [k] remove_vm_area
> +   10.90%    10.68%  [kernel]              [k] __vunmap_range_noflush
> +   10.81%    10.80%  [kernel]              [k] free_pages_bulk
> +    7.09%     0.51%  [kernel]              [k] alloc_pages_noprof
> +    6.58%     0.41%  [kernel]              [k] alloc_pages_mpol
> +    6.50%     0.30%  [kernel]              [k] free_frozen_pages_bulk
> +    5.74%     0.97%  [kernel]              [k] __alloc_frozen_pages_noprof
> +    5.70%     0.00%  [kernel]              [k] worker_thread
> +    5.62%     0.02%  [kernel]              [k] process_one_work
> +    5.57%     0.01%  [kernel]              [k] __purge_vmap_area_lazy
> +    4.76%     2.55%  [kernel]              [k] get_page_from_freelist
> 
> So it is nice :)
> 
> --
> Uladzislau Rezki


