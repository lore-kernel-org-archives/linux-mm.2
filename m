Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47733D6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20496B008C; Thu, 18 Dec 2025 06:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6C46B0092; Thu, 18 Dec 2025 06:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA266B0093; Thu, 18 Dec 2025 06:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4E36B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:57:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D3B08BEB1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:57:04 +0000 (UTC)
X-FDA: 84232440768.23.394ED20
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 514851C001E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:57:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ait55IKYgLaGVc3P/AOKctPiuy14wmUjxyLAGScS/0=;
	b=vO7i2P67pTF4ShyE5dTGHAhaiYUOG0/KXZJKG8zsgVO7Uti296eCIznapGqzfeLqsD5D1z
	YlXzhl5NEgQECCy4GgVk9zBFCtT5+BPUHFaDzlM1EeSbDQO47GVoUMZYAOB7xQWT1kSAg8
	F4E0I4KmjJ+xye+5lMYKHZV1lw01vMw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059022; a=rsa-sha256;
	cv=none;
	b=7HhRDH9n3BlnLVllfXZaJRcjJZmj4JSp+cfBNtU1vtsxoGc736LYUD6upsTUksdWZswr74
	1NYgjJbKkEaogzo7HX9JnF12kMwH1gXdTgN4aCI4E05s46hC5Rg7s79zLPASxkG38Sb+hW
	UmlxXWFWHnqzUyDGBscT5xfQY6gjKJ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CB0DFEC;
	Thu, 18 Dec 2025 03:56:54 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04BEB3F762;
	Thu, 18 Dec 2025 03:56:59 -0800 (PST)
Message-ID: <307a3cb2-64c6-4671-9d50-2bb18d744bc0@arm.com>
Date: Thu, 18 Dec 2025 11:56:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>, Uladzislau Rezki <urezki@gmail.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
 <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com>
In-Reply-To: <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o7zcts536zergb5kbnpjg4yfhsedqem9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 514851C001E
X-HE-Tag: 1766059022-378231
X-HE-Meta: U2FsdGVkX1+t/c2CKu54m3QprONrtMJ1RVx88csYMRQ9A4LwcGkSj15Pj1UpoaK+4KgM75dUyQJVq+G+F79GHasMkrTkcenI90M16RG4Zkf9EdnFcSapy1Z1dOV0KrnFa0ez2fDUXqv2o/+3oBJgC+NBotX+Wc08MR/CKbewYxuBZjdaTHYfIXBPXeT2mq+njFy8tQ1ADW+jqxt28m2JPZC20LHtbfeN8cB7vOKqf8wCF5HYCg1pcq7O2H24TWe2DoBmQ7+akKxYavadzmEuPm5T3WACKiZCAmF1UmW6ZYvWnPYMWIgfhUu+jKXjNOfAnb/36a9pNWc/wTSxiAmhwrAfJweEb6m2LN2Jp9zUsEYyvbP3j3J+9lL84k41iu9xGMVoGFPyqCSP599pv0+pQ7zlFHQlQwqtVhXH1uDhn4io7YkncbFTpdXdrFELkoH1zsBId2gP+8+E6Xu2T6v/aNUsfImArbHlG2FoQALWLvmQu70sFW1EmAi5ywc+tACqdfO9QeWombZPj8wWlLCx1rGQGVVvuwWYYovP7kCTTbr7G/cHxy/FkY+He+WAt0xjq6AoPr8T0+9bcKujG0hVKJr8escMNVUFX198/GHetQ6/CeFQoL2nFkZSdHQulOODMQRk8EWJz75BBFnLFg1Et8KDgUlYz+ciwU5qkJGM0as2OKzT5yFK3/8ArKx8J8riPEauLKPgHVUOYZDnvENWVTum1TVf2oBRgNZB7W+1KK3VL3O66LLya/PnhjgLMZ12+ZATKFe/2CX0NCdnzGoUMoTnHsvgamD0Ei93vcgvILpP4c6SQwh/g/krc/JIwCymrJjrW8ZL/TgEG4d7ciZ4ilZSOxjvjSCNPBQv1m8GdI8kDBXqLoca6VpXsnuZxo5tFcrY60O8I6u62BKZG3lgElHOQCe9sGEbONT5jdPYVHBHcqkH4jyTD/U+UVxQQrruoH0j+4/Fy2PdqGtvwCF
 qBK+tGz6
 9BeS+Wksuiu462L2c38/lVLIBV4SglccjuH4BIZsMlPq/iPo/KfPeWHrIQE9Ad/a9+W+BzTHJhBF3AR2914NmUVFt5G1cvPAej/Ohzjy8yjn19LvMhEXLa1ev8vSrcApkYfQnis0FxcpbF7N/RBxjrvqY6U2oj4xgxaKvTFmuO1GY03Gc8WjQR85lYFA3H07eKdnKO04SXBBTc0B0h5qZMfhFQLWK1bRdXDaH21i/hqvO6r11XiNaVusZis8YdpdEUT0V/XvFGI+tZLMysTVQSK5b3JWNVho3ez+045mD+lrFOt8UQ/NxE48+xkmc8/ipIBC6plndQI/4x4ETYNgo9tYEmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ David, Lorenzo, Matthew

Hoping someone might be able to explain to me how this all really works! :-|

On 18/12/2025 11:53, Ryan Roberts wrote:
> On 18/12/2025 04:55, Dev Jain wrote:
>>
>> On 17/12/25 8:50 pm, Ryan Roberts wrote:
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
>>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>>>> else try large order, else fallback to order-0" Could that provide the best of
>>>>> all worlds without needing a configuration knob?
>>>>>
>>>> I am not sure, to me it looks like a bit odd. 
>>> Perhaps it would feel better if it was generalized to "first try allocation from
>>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>>> to lowest order"?
>>>
>>>> Ideally it would be
>>>> good just free it as high-order page and not order-0 peaces.
>>> Yeah perhaps that's better. How about something like this (very lightly tested
>>> and no performance results yet):
>>>
>>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>>> memory leaks when running mm selftests...)
>>
>> Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
>> arm64/mmu.c already does this - it computes order from size and passes it to
>> __free_pages().
> 
> Hmm that looks dodgy to me. But I'm not sure I actually understand what is going
> on...
> 
> Prior to looking at this yesterday, my understanding was this: At the struct
> page level, you can either allocate compond or non-compound. order-0 is
> non-compound by definition. A high-order non-compound page is just a contiguous
> set of order-0 pages, each with individual reference counts and other meta data.
> A compound page is one where all the pages are tied together and managed as one
> - the meta data is stored in the head page and all the tail pages point to the
> head (this concept is wrapped by struct folio).
> 
> But after looking through the comments in page_alloc.c, it would seem that a
> non-compound high-order page is NOT just a set of order-0 pages, but they still
> share some meta data, including a shared refcount?? alloc_pages() will return
> one of these things, and __free_pages() requires the exact same unit to be
> provided to it.
> 
> vmalloc calls alloc_pages() to get a non-compound high-order page, then calls
> split_page() to convert to a set of order-0 pages. See this comment:
> 
> /*
>  * split_page takes a non-compound higher-order page, and splits it into
>  * n (1<<order) sub-pages: page[0..n]
>  * Each sub-page must be freed individually.
>  *
>  * Note: this is probably too low level an operation for use in drivers.
>  * Please consult with lkml before using this in your driver.
>  */
> void split_page(struct page *page, unsigned int order)
> 
> So just passing all the order-0 pages directly to __free_pages() in one go is
> definitely not the right thing to do ("Each sub-page must be freed
> individually"). They may have different reference counts so you can only
> actually free the ones that go to zero surely?
> 
> But it looked to me like free_frozen_pages() just wants a naturally aligned
> power-of-2 number of pages to free, so my patch below is decrementing the
> refcount on each struct page and accumulating the ones where the refcounts goto
> zero into suitable blocks for free_frozen_pages().
> 
> So I *think* my patch is correct, but I'm not totally sure.
> 
> Then we have the ___free_pages(), which I find very difficult to understand:
> 
> static void ___free_pages(struct page *page, unsigned int order,
> 			  fpi_t fpi_flags)
> {
> 	/* get PageHead before we drop reference */
> 	int head = PageHead(page);
> 	/* get alloc tag in case the page is released by others */
> 	struct alloc_tag *tag = pgalloc_tag_get(page);
> 
> 	if (put_page_testzero(page))
> 		__free_frozen_pages(page, order, fpi_flags);
> 
> We only test the refcount for the first page, then free all the pages. So that
> implies that non-compound high-order pages share a single refcount? Or we just
> ignore the refcount of all the other pages in a non-compound high-order page?
> 
> 	else if (!head) {
> 
> What? If the first page still has references but but it's a non-compond
> high-order page (i.e. no head page) then we free all the trailing sub-pages
> without caring about their references?
> 
> 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
> 		while (order-- > 0) {
> 			/*
> 			 * The "tail" pages of this non-compound high-order
> 			 * page will have no code tags, so to avoid warnings
> 			 * mark them as empty.
> 			 */
> 			clear_page_tag_ref(page + (1 << order));
> 			__free_frozen_pages(page + (1 << order), order,
> 					    fpi_flags);
> 		}
> 	}
> }
> 
> For the arm64 case that you point out, surely __free_pages() is the wrong thing
> to call, because it's going to decrement the refcount. But we are freeing based
> on their presence in the pagetable and we never took a reference in the first place.
> 
> HELP!
> 
>>
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
>>>
>>>>>> Since the best strategy is workload-dependent, this patch adds a
>>>>>> parameter letting users to choose whether vmalloc should try
>>>>>> high-order allocations or stay strictly on the order-0 fastpath.
>>>>>>
>>>>>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>>>>> ---
>>>>>>  mm/vmalloc.c | 9 +++++++--
>>>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>>>> index d3a4725e15ca..f66543896b16 100644
>>>>>> --- a/mm/vmalloc.c
>>>>>> +++ b/mm/vmalloc.c
>>>>>> @@ -43,6 +43,7 @@
>>>>>>  #include <asm/tlbflush.h>
>>>>>>  #include <asm/shmparam.h>
>>>>>>  #include <linux/page_owner.h>
>>>>>> +#include <linux/moduleparam.h>
>>>>>>  
>>>>>>  #define CREATE_TRACE_POINTS
>>>>>>  #include <trace/events/vmalloc.h>
>>>>>> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>>>>>>  	return nr_allocated;
>>>>>>  }
>>>>>>  
>>>>>> +static int attempt_larger_order_alloc;
>>>>>> +module_param(attempt_larger_order_alloc, int, 0644);
>>>>> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
>>>>> Y/N as the value; that's probably more intuitive?
>>>>>
>>>>> nit: I'd favour a shorter name. Perhaps large_order_alloc?
>>>>>
>>>> Thanks! We can switch to bool and use shorter name for sure.
>>>>
>>>> --
>>>> Uladzislau Rezki
> 


