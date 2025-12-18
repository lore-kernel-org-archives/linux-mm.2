Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32029D6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9546B0088; Thu, 18 Dec 2025 06:53:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994256B0089; Thu, 18 Dec 2025 06:53:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896536B008A; Thu, 18 Dec 2025 06:53:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 774E06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:53:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D3745D694
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:53:06 +0000 (UTC)
X-FDA: 84232430772.14.D61CB20
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 391E6100006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:53:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058784; a=rsa-sha256;
	cv=none;
	b=keEXUHo6alIex2YM28r7XbVj4Slo5V9fFfdDgXvK3sGYOoVPb9ZVxWilabsw9QPThS/vbz
	1mgWM4G2I+zQtmuoNqgCT+sVz2O8QXrtZppS66H+hmHlcbxrdzYN7atTy+acmv0JCS2BQx
	om1090jQeC9TkOif/+3GJPNR3r1RN5M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf3CbMcGSDoJ4GguZzNghJ3CMAdbe4/V5G76ipw4dxM=;
	b=Cp+9haElrGzB6rs/EihtuFf9j3w7iKGIS7iQ6yOzvc2XNSyq5AlfV5EuJ+g1suKiZJhB3R
	BNWlAYkFap5SyGCDEyofH+eebsL0KyQU7xf+7lQz8RiKVLWi8BPdtPyMvG9YiyRkeqKBh/
	jFviIc8rxNF6BtTq4JgUKznDY4UXG0Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41150FEC;
	Thu, 18 Dec 2025 03:52:56 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 580F73F762;
	Thu, 18 Dec 2025 03:53:02 -0800 (PST)
Message-ID: <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com>
Date: Thu, 18 Dec 2025 11:53:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 391E6100006
X-Stat-Signature: rkmrccfdi61bpkwanej67eao4f97wwgh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766058784-989858
X-HE-Meta: U2FsdGVkX19WlHs/Lnmfq0QZPihUZhaCTKjeZ0Xl9Bwj1lnqsTI/hqdLwBx7M+E1YBGfAzu3w9VD1ggOktZWGibtpf2knX/pm2r1fVuOmgO9nDir+DXY2AIbsF4zQaX70fco9EE+qQ+2CMCkNbt1KBUJIiKZ0HHnmMugy5O82sRGTQgMgVrU2YCsKC3YnkaCQkyQc33ggp6SK2AvoiepvJX8JtmoxK5vTKdFox5tGTdEVozfYcQ4aTcsq/Hyo2f9xYr17zXfbAhEv029swfpHvT0Rmtd8p6dUv5DKexgaE97Tv2g4l0JmMOT8kozUpeH5tVpja+3lpeINNl66hJ396m/taOS2BQLjNEcWjGbPk9PWa1x4pQT8Fj40Yadux0cVzsGgXMt/S/NZjiJ0CV/IL309fzw7yxsv0EqhMfGjAvMwp2PDBoVx9fX2xHIqQ5qSE/bhZ8LsLeGWf3OAkgVWCacmL0GTVq7PS3yAFcvR+0Irvacn/XD9izzhlRm/I0DBmxOL7IKJWvk+/e7duh5uFbHA8N6wZUPXIQBA4W1dt79MbDk2LeBKN+5oxJhMjMzSYObtBU35rj9EnTchMkhSlPGIvYFl1l5HHHKAZTtYyJz3bdhbubEiAhUZgpASP8NXey9Zj5HvA0zWPPTxThbXCT3qFZpnkpwwSqM280uiLgyqcGthTOu63Lgy/5yQP4RIGHbw8wlSq1laJTmdaoRJdE99N5QhfpV5Lguyp/OyDO6LsZ+MXRbYRy/rDHDYaIbWyOGEpG/EoY+UrkVQuCjI0c404npKWeW+Wae9D/od6+UyWfdM2yF/6w9WbIEMX6DJdKS2ZL+EUeVbYKX+P5dVSds8ATMilCa2dPx/nOx1FhbkS5d42hHAbFdRzvDMtdpQIASCKTm+i6S8JmFeLQKez24u24GRfJncpsnPW0aayfy3JE72gOcwnjROs7xWUjmlfYYnfukTCvdv/SZV1e
 XujI6cJO
 2x/W56HyKh3MnKzvcu6tgYJREUiunyojjAaTcRtQ978M/tcA5o1X1ZvM/9O8ZIfzrwD0+LaZNJg/q3PvsQIu0PnLlVD0Rfu08I/5cxS43HNKugqLExnrPJlLx+rYA5NjX9G6J1BACYKV+NmRq2o8x6A8zyndqRwiXlV2vZkqHSPJLzBAOK2jIFbQcGZvy4/l85Pt/2hu26EY8PBayzYiTRkFXh7FdsXiDHfwQpl5r2iO/QGWLgvIaJYPlakNrlMWQgr/TGGMuJpF21qdh6RRnGWV7/K4OUrzuXAOgRTfS83/7lCTEjE0og/surKdLnJmcy5jdZukB58/tIqZR4mS6yYFWVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/12/2025 04:55, Dev Jain wrote:
> 
> On 17/12/25 8:50 pm, Ryan Roberts wrote:
>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>>> Introduce a module parameter to enable or disable the large-order
>>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>>> default so far, but users may explicitly enable them at runtime if
>>>>> desired.
>>>>>
>>>>> High-order pages allocated for vmalloc are immediately split into
>>>>> order-0 pages and later freed as order-0, which means they do not
>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>>> can affect performance.
>>>>>
>>>>> However, when the PCP caches are empty, high-order allocations may
>>>>> show better performance characteristics especially for larger
>>>>> allocation requests.
>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>>> else try large order, else fallback to order-0" Could that provide the best of
>>>> all worlds without needing a configuration knob?
>>>>
>>> I am not sure, to me it looks like a bit odd. 
>> Perhaps it would feel better if it was generalized to "first try allocation from
>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>> to lowest order"?
>>
>>> Ideally it would be
>>> good just free it as high-order page and not order-0 peaces.
>> Yeah perhaps that's better. How about something like this (very lightly tested
>> and no performance results yet):
>>
>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>> memory leaks when running mm selftests...)
> 
> Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
> arm64/mmu.c already does this - it computes order from size and passes it to
> __free_pages().

Hmm that looks dodgy to me. But I'm not sure I actually understand what is going
on...

Prior to looking at this yesterday, my understanding was this: At the struct
page level, you can either allocate compond or non-compound. order-0 is
non-compound by definition. A high-order non-compound page is just a contiguous
set of order-0 pages, each with individual reference counts and other meta data.
A compound page is one where all the pages are tied together and managed as one
- the meta data is stored in the head page and all the tail pages point to the
head (this concept is wrapped by struct folio).

But after looking through the comments in page_alloc.c, it would seem that a
non-compound high-order page is NOT just a set of order-0 pages, but they still
share some meta data, including a shared refcount?? alloc_pages() will return
one of these things, and __free_pages() requires the exact same unit to be
provided to it.

vmalloc calls alloc_pages() to get a non-compound high-order page, then calls
split_page() to convert to a set of order-0 pages. See this comment:

/*
 * split_page takes a non-compound higher-order page, and splits it into
 * n (1<<order) sub-pages: page[0..n]
 * Each sub-page must be freed individually.
 *
 * Note: this is probably too low level an operation for use in drivers.
 * Please consult with lkml before using this in your driver.
 */
void split_page(struct page *page, unsigned int order)

So just passing all the order-0 pages directly to __free_pages() in one go is
definitely not the right thing to do ("Each sub-page must be freed
individually"). They may have different reference counts so you can only
actually free the ones that go to zero surely?

But it looked to me like free_frozen_pages() just wants a naturally aligned
power-of-2 number of pages to free, so my patch below is decrementing the
refcount on each struct page and accumulating the ones where the refcounts goto
zero into suitable blocks for free_frozen_pages().

So I *think* my patch is correct, but I'm not totally sure.

Then we have the ___free_pages(), which I find very difficult to understand:

static void ___free_pages(struct page *page, unsigned int order,
			  fpi_t fpi_flags)
{
	/* get PageHead before we drop reference */
	int head = PageHead(page);
	/* get alloc tag in case the page is released by others */
	struct alloc_tag *tag = pgalloc_tag_get(page);

	if (put_page_testzero(page))
		__free_frozen_pages(page, order, fpi_flags);

We only test the refcount for the first page, then free all the pages. So that
implies that non-compound high-order pages share a single refcount? Or we just
ignore the refcount of all the other pages in a non-compound high-order page?

	else if (!head) {

What? If the first page still has references but but it's a non-compond
high-order page (i.e. no head page) then we free all the trailing sub-pages
without caring about their references?

		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
		while (order-- > 0) {
			/*
			 * The "tail" pages of this non-compound high-order
			 * page will have no code tags, so to avoid warnings
			 * mark them as empty.
			 */
			clear_page_tag_ref(page + (1 << order));
			__free_frozen_pages(page + (1 << order), order,
					    fpi_flags);
		}
	}
}

For the arm64 case that you point out, surely __free_pages() is the wrong thing
to call, because it's going to decrement the refcount. But we are freeing based
on their presence in the pagetable and we never took a reference in the first place.

HELP!

> 
>>
>> ---8<---
>> commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
>> Author: Ryan Roberts <ryan.roberts@arm.com>
>> Date:   Wed Dec 17 15:11:08 2025 +0000
>>
>>     WIP
>>
>>     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index b155929af5b1..d25f5b867e6b 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
>>  extern void free_pages_nolock(struct page *page, unsigned int order);
>>  extern void free_pages(unsigned long addr, unsigned int order);
>>
>> +void free_pages_bulk(struct page *page, int nr_pages);
>> +
>>  #define __free_page(page) __free_pages((page), 0)
>>  #define free_page(addr) free_pages((addr), 0)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 822e05f1a964..5f11224cf353 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
>> order,
>>  	}
>>  }
>>
>> +static void free_frozen_pages_bulk(struct page *page, int nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned int fit_order, align_order, order;
>> +		unsigned long pfn;
>> +
>> +		pfn = page_to_pfn(page);
>> +		fit_order = ilog2(nr_pages);
>> +		align_order = pfn ? __ffs(pfn) : fit_order;
>> +		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
>> +
>> +		free_frozen_pages(page, order);
>> +
>> +		page += 1U << order;
>> +		nr_pages -= 1U << order;
>> +	}
>> +}
>> +
>> +void free_pages_bulk(struct page *page, int nr_pages)
>> +{
>> +	struct page *start = NULL;
>> +	bool can_free;
>> +	int i;
>> +
>> +	for (i = 0; i < nr_pages; i++, page++) {
>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>> +
>> +		can_free = put_page_testzero(page);
>> +
>> +		if (!can_free && start) {
>> +			free_frozen_pages_bulk(start, page - start);
>> +			start = NULL;
>> +		} else if (can_free && !start) {
>> +			start = page;
>> +		}
>> +	}
>> +
>> +	if (start)
>> +		free_frozen_pages_bulk(start, page - start);
>> +}
>> +
>>  /**
>>   * __free_pages - Free pages allocated with alloc_pages().
>>   * @page: The page pointer returned from alloc_pages().
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index ecbac900c35f..8f782bac1ece 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
>>  void vfree(const void *addr)
>>  {
>>  	struct vm_struct *vm;
>> -	int i;
>> +	struct page *start;
>> +	int i, nr;
>>
>>  	if (unlikely(in_interrupt())) {
>>  		vfree_atomic(addr);
>> @@ -3455,17 +3456,26 @@ void vfree(const void *addr)
>>  	/* All pages of vm should be charged to same memcg, so use first one. */
>>  	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
>>  		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> +
>> +	start = vm->pages[0];
>> +	BUG_ON(!start);
>> +	nr = 1;
>> +	for (i = 1; i < vm->nr_pages; i++) {
>>  		struct page *page = vm->pages[i];
>>
>>  		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		__free_page(page);
>> -		cond_resched();
>> +
>> +		if (start + nr != page) {
>> +			free_pages_bulk(start, nr);
>> +			start = page;
>> +			nr = 1;
>> +			cond_resched();
>> +		} else {
>> +			nr++;
>> +		}
>>  	}
>> +	free_pages_bulk(start, nr);
>> +
>>  	if (!(vm->flags & VM_MAP_PUT_PAGES))
>>  		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>>  	kvfree(vm->pages);
>> ---8<---
>>
>>>>> Since the best strategy is workload-dependent, this patch adds a
>>>>> parameter letting users to choose whether vmalloc should try
>>>>> high-order allocations or stay strictly on the order-0 fastpath.
>>>>>
>>>>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>>>> ---
>>>>>  mm/vmalloc.c | 9 +++++++--
>>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>>> index d3a4725e15ca..f66543896b16 100644
>>>>> --- a/mm/vmalloc.c
>>>>> +++ b/mm/vmalloc.c
>>>>> @@ -43,6 +43,7 @@
>>>>>  #include <asm/tlbflush.h>
>>>>>  #include <asm/shmparam.h>
>>>>>  #include <linux/page_owner.h>
>>>>> +#include <linux/moduleparam.h>
>>>>>  
>>>>>  #define CREATE_TRACE_POINTS
>>>>>  #include <trace/events/vmalloc.h>
>>>>> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>>>>>  	return nr_allocated;
>>>>>  }
>>>>>  
>>>>> +static int attempt_larger_order_alloc;
>>>>> +module_param(attempt_larger_order_alloc, int, 0644);
>>>> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
>>>> Y/N as the value; that's probably more intuitive?
>>>>
>>>> nit: I'd favour a shorter name. Perhaps large_order_alloc?
>>>>
>>> Thanks! We can switch to bool and use shorter name for sure.
>>>
>>> --
>>> Uladzislau Rezki


