Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB08D767CB
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAA06B0088; Fri, 19 Dec 2025 06:23:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97176B0089; Fri, 19 Dec 2025 06:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEE06B008A; Fri, 19 Dec 2025 06:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF5DC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:23:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E65813B3EA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:23:11 +0000 (UTC)
X-FDA: 84235984182.04.F63A4B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 54EBF1C000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:23:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766143388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ob6fS+QaUkhvBXHICre+FnkFDNjMgjxsX8N/j4kSxzo=;
	b=HjL5cN5xtS11vWtz50AiB07uS2rwE/WRGamiEKy6i3lt9GsGYvNdK7zCAz4hcm8TcuhRqB
	hL4fq3FauNywuqHPrxkemyviUe91Dx2smk6UODm/jNKAkh4M2mHQmqFOSNfsjSSnQE03dl
	7ctcOkMk3TcKvuehd0Kgh2vcQFcOiYg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766143388; a=rsa-sha256;
	cv=none;
	b=HlwOhVIHTK7jIqvVych4I6oaoH4tQNb5gMFH5/359/wjDDauHlVQn+DW1BuXMOYZcANX+n
	HDlkAsvmvUkcWjcJwG0FPHqlBl/Wv4xCpqAjECwiADx2OQOwwveU9ZCjRPalHWyN7wksqq
	T8v5CSt8J7VGXSOz0fdbwyF0TYunuDk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79737FEC;
	Fri, 19 Dec 2025 03:23:00 -0800 (PST)
Received: from [10.57.93.157] (unknown [10.57.93.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 697AE3F73F;
	Fri, 19 Dec 2025 03:23:06 -0800 (PST)
Message-ID: <3511036a-52d1-457c-85c4-6168791b1fc6@arm.com>
Date: Fri, 19 Dec 2025 11:23:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
 <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com> <aUSdmhB7au94SQOi@fedora>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUSdmhB7au94SQOi@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f1bngpg9ucizudcxk8ukxtoncqewumij
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54EBF1C000B
X-HE-Tag: 1766143388-701207
X-HE-Meta: U2FsdGVkX19KqtTr+2x4JVTILMlB1b2osE7O+Zx1Zpl39POO8StaU0cRmnNVTK2EAZ5l6yeow3oFX8WSvAObeBpF1Nm8xLBLJ3wugKAftonBC3AtZ/gBTHyNvHGhLKoWL57GHY8fYONhQk1nfan5jzjB49hNQqGLCQQjEaDL2V/Bb1OsfFlueL1dYTq7ZY7gyPCtjklWlHgn50GJjyTXz6ziuT8bL8/x9X+LkAIoPbawwnqYtwrIgUQpzNZb4n6VxxoKuHk54vfwe2B8cadzjroYHA+jNeO/c/rLJe1aD8Pby40vts5WcDENiZKZnuL8O31INuX6KamQx/3LSXAaoVvnSXimbVdBpWmGQNJtW8G0MGoSnJuauASo4yvqwOA/LUWPG4qDUxqxgR8FKsCCbHYhyUSuZ08AbN9vZf4UKhGhy6coUtvUNQK7MuKNMWO3VgorcPK/vXLNe5j3gM761rvsAhpQ6S3Mu5CeF7pkm7uu7+ZqpcvX4p43PzTcEFeCnGh/IrdtcG0zv1sD8bbC0DhpkNaljtwYLJyvecADltPD+FW32kqM/RVgsEMvZJ5BOhagP0QLqG+GyFRZui7Ymt5EseYlalp70TLvzb+6YbRGtgk/fr7h8k3qAkkPkHgw2vpi44haNW06Glb61ENTnFPiT1swAAYSha1jrGZVNNYpwvs+7QvwuVsoz5KY7aiV7kOHcaQWT4kzaClG73QycTLUMpenyScYhF7tU+3N07A/brcB2E1bgpbkWFaFiSvCDLSHaby+GdD9BOo3VP8y1vC8CO1T9iiYmNg1cSijKNuUixiATwj8Ce6YCr21nbRhgNmwdRcvQRvwhi7RHzCLP+vONBMCYxFnTj6Pi97dE4/GHlW92S9bExCkTwEBoYvb75rh9TrypA+M/qbAq763LLktlxrovH5b/zDecfDgJfDOY6zXElWZcr31086YT5uIqbaMtZIUrjMVTVIkQ8G
 0QmOAn29
 CljG4w+FyYtxWhIxZmdoHGfMPrv2DExhaRGJQqttnHLSwlve0pooGpyGQA0ESc15mbKDcvgYKPe70BCljwTYkjQ6DjNQe1lgc4OcspTaTToFXmSLJl36DucX5/8UMVWaqS73DOHxNg3J1Ke/3YiyzZUFAHstWNSNxzMKGua+C9f7/UyIzGjUaQ7PkE/qBCd9qFThmykYly594Hx63yKgLwiwA98j1CY1MY5ZpevEOup5TZCHsradgu4j/Ei3M/LZZ90C3rEmp2CJ/e+2noytSW9kCqeHQjJvp2rOGdc98ZjXxRU84DIy3iJTDR5A0ATQBxRBvwooypqba8puFVF+uPsQ+Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/12/2025 00:34, Vishal Moola (Oracle) wrote:
> On Thu, Dec 18, 2025 at 11:53:00AM +0000, Ryan Roberts wrote:
>> On 18/12/2025 04:55, Dev Jain wrote:
>>>
>>> On 17/12/25 8:50 pm, Ryan Roberts wrote:
>>>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>>>>> Introduce a module parameter to enable or disable the large-order
>>>>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>>>>> default so far, but users may explicitly enable them at runtime if
>>>>>>> desired.
>>>>>>>
>>>>>>> High-order pages allocated for vmalloc are immediately split into
>>>>>>> order-0 pages and later freed as order-0, which means they do not
>>>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>>>>> can affect performance.
>>>>>>>
>>>>>>> However, when the PCP caches are empty, high-order allocations may
>>>>>>> show better performance characteristics especially for larger
>>>>>>> allocation requests.
>>>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>>>>> else try large order, else fallback to order-0" Could that provide the best of
>>>>>> all worlds without needing a configuration knob?
>>>>>>
>>>>> I am not sure, to me it looks like a bit odd. 
>>>> Perhaps it would feel better if it was generalized to "first try allocation from
>>>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>>>> to lowest order"?
>>>>
>>>>> Ideally it would be
>>>>> good just free it as high-order page and not order-0 peaces.
>>>> Yeah perhaps that's better. How about something like this (very lightly tested
>>>> and no performance results yet):
>>>>
>>>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>>>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>>>> memory leaks when running mm selftests...)
>>>
>>> Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
>>> arm64/mmu.c already does this - it computes order from size and passes it to
>>> __free_pages().
>>
>> Hmm that looks dodgy to me. But I'm not sure I actually understand what is going
>> on...
>>
>> Prior to looking at this yesterday, my understanding was this: At the struct
>> page level, you can either allocate compond or non-compound. order-0 is
>> non-compound by definition. A high-order non-compound page is just a contiguous
>> set of order-0 pages, each with individual reference counts and other meta data.
>> A compound page is one where all the pages are tied together and managed as one
>> - the meta data is stored in the head page and all the tail pages point to the
>> head (this concept is wrapped by struct folio).
>>
>> But after looking through the comments in page_alloc.c, it would seem that a
>> non-compound high-order page is NOT just a set of order-0 pages, but they still
>> share some meta data, including a shared refcount?? alloc_pages() will return
>> one of these things, and __free_pages() requires the exact same unit to be
>> provided to it.
> 
> For high-order non-compound pages, the tail pages don't get initialized.
> They don't share anything, and its up to the caller to keep track of
> those tail pages.
> 
> Historically, we split the pages down to order-0 here to simplify things for
> the callers. See commit 3b8000ae185cb0 (stating some callers want to use
> some page fields).
> 
> Tail pages being uninitialized meant that when using page apis, we could
> easily hit 'bad' page states. Splitting to order-0, meant that each page
> is now completely independent, and *actually* initialized to an expected
> state.

Thanks for the explanation - consider my mental model of all of this to be
corrected!

> 
>> vmalloc calls alloc_pages() to get a non-compound high-order page, then calls
>> split_page() to convert to a set of order-0 pages. See this comment:
>>
>> /*
>>  * split_page takes a non-compound higher-order page, and splits it into
>>  * n (1<<order) sub-pages: page[0..n]
>>  * Each sub-page must be freed individually.
>>  *
>>  * Note: this is probably too low level an operation for use in drivers.
>>  * Please consult with lkml before using this in your driver.
>>  */
>> void split_page(struct page *page, unsigned int order)
>>
>> So just passing all the order-0 pages directly to __free_pages() in one go is
>> definitely not the right thing to do ("Each sub-page must be freed
>> individually"). They may have different reference counts so you can only
>> actually free the ones that go to zero surely?
>>
>> But it looked to me like free_frozen_pages() just wants a naturally aligned
>> power-of-2 number of pages to free, so my patch below is decrementing the
>> refcount on each struct page and accumulating the ones where the refcounts goto
>> zero into suitable blocks for free_frozen_pages().
> 
> Frozen pages are just pages without a refcount. I doubt this is the
> intended use, but it should work: you're effectively handling the
> refcount here instead of letting the page allocator do so.

Yep, agreed. thanks.

> 
>> So I *think* my patch is correct, but I'm not totally sure. 
> 
> I haven't looked at your patch yet, but I do like the idea of freeing
> the pages as larger orders together. My only concern is whether page
> migration could mess any of this up (I'm completely unfamiliar with that).

I'm not sure I see where migration comes into the picture. We have the struct
page pointers, so nothing can migrated, surely? This is vmalloc memory we are
talking about so it's all unmovable, right?

> 
>> Then we have the ___free_pages(), which I find very difficult to understand:
>>
>> static void ___free_pages(struct page *page, unsigned int order,
>> 			  fpi_t fpi_flags)
>> {
>> 	/* get PageHead before we drop reference */
>> 	int head = PageHead(page);
>> 	/* get alloc tag in case the page is released by others */
>> 	struct alloc_tag *tag = pgalloc_tag_get(page);
>>
>> 	if (put_page_testzero(page))
>> 		__free_frozen_pages(page, order, fpi_flags);
>>
>> We only test the refcount for the first page, then free all the pages. So that
>> implies that non-compound high-order pages share a single refcount? Or we just
>> ignore the refcount of all the other pages in a non-compound high-order page?
> 
> We ignore the refcount of all other pages - see __free_pages():
> 	 * This function can free multi-page allocations that are not compound
> 	 * pages.  It does not check that the @order passed in matches that of
> 	 * the allocation, so it is easy to leak memory.  Freeing more memory
> 	 * than was allocated will probably emit a warning.
> 
>> 	else if (!head) {
>>
>> What? If the first page still has references but but it's a non-compond
>> high-order page (i.e. no head page) then we free all the trailing sub-pages
>> without caring about their references?
> 
> I think this has to do with racy refcount stuff. For non-compound pages:
> if we take a reference with get_page() before put_page_testzero()
> happens, we will end up ONLY freeing that page once the caller reaches
> its put_page() call. So we're freeing the rest here to prevent leaking
> memory that way.

Yeah this makes sense now that I understand that the "tail" pages never got
initialized. Feels odd that get_page() should be allowed on the "head" page
though for this type of user-managed non-compound high-order page, but I won't
worry about that.

> 
>> 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
>> 		while (order-- > 0) {
>> 			/*
>> 			 * The "tail" pages of this non-compound high-order
>> 			 * page will have no code tags, so to avoid warnings
>> 			 * mark them as empty.
>> 			 */
>> 			clear_page_tag_ref(page + (1 << order));
>> 			__free_frozen_pages(page + (1 << order), order,
>> 					    fpi_flags);
>> 		}
>> 	}
>> }
>>
>> For the arm64 case that you point out, surely __free_pages() is the wrong thing
>> to call, because it's going to decrement the refcount. But we are freeing based
>> on their presence in the pagetable and we never took a reference in the first place.
>>
>> HELP!
>>
>>>
>>>>
>>>> ---8<---
>>>> commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
>>>> Author: Ryan Roberts <ryan.roberts@arm.com>
>>>> Date:   Wed Dec 17 15:11:08 2025 +0000
>>>>
>>>>     WIP
>>>>
>>>>     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>
>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>> index b155929af5b1..d25f5b867e6b 100644
>>>> --- a/include/linux/gfp.h
>>>> +++ b/include/linux/gfp.h
>>>> @@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
>>>>  extern void free_pages_nolock(struct page *page, unsigned int order);
>>>>  extern void free_pages(unsigned long addr, unsigned int order);
>>>>
>>>> +void free_pages_bulk(struct page *page, int nr_pages);
>>>> +
>>>>  #define __free_page(page) __free_pages((page), 0)
>>>>  #define free_page(addr) free_pages((addr), 0)
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index 822e05f1a964..5f11224cf353 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
>>>> order,
>>>>  	}
>>>>  }
>>>>
>>>> +static void free_frozen_pages_bulk(struct page *page, int nr_pages)
>>>> +{
>>>> +	while (nr_pages) {
>>>> +		unsigned int fit_order, align_order, order;
>>>> +		unsigned long pfn;
>>>> +
>>>> +		pfn = page_to_pfn(page);
>>>> +		fit_order = ilog2(nr_pages);
>>>> +		align_order = pfn ? __ffs(pfn) : fit_order;
>>>> +		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
>>>> +
>>>> +		free_frozen_pages(page, order);
>>>> +
>>>> +		page += 1U << order;
>>>> +		nr_pages -= 1U << order;
>>>> +	}
>>>> +}
>>>> +
>>>> +void free_pages_bulk(struct page *page, int nr_pages)
>>>> +{
>>>> +	struct page *start = NULL;
>>>> +	bool can_free;
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < nr_pages; i++, page++) {
>>>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>>>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>>>> +
>>>> +		can_free = put_page_testzero(page);
>>>> +
>>>> +		if (!can_free && start) {
>>>> +			free_frozen_pages_bulk(start, page - start);
>>>> +			start = NULL;
>>>> +		} else if (can_free && !start) {
>>>> +			start = page;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (start)
>>>> +		free_frozen_pages_bulk(start, page - start);
>>>> +}
>>>> +
>>>>  /**
>>>>   * __free_pages - Free pages allocated with alloc_pages().
>>>>   * @page: The page pointer returned from alloc_pages().
>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>> index ecbac900c35f..8f782bac1ece 100644
>>>> --- a/mm/vmalloc.c
>>>> +++ b/mm/vmalloc.c
>>>> @@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
>>>>  void vfree(const void *addr)
>>>>  {
>>>>  	struct vm_struct *vm;
>>>> -	int i;
>>>> +	struct page *start;
>>>> +	int i, nr;
>>>>
>>>>  	if (unlikely(in_interrupt())) {
>>>>  		vfree_atomic(addr);
>>>> @@ -3455,17 +3456,26 @@ void vfree(const void *addr)
>>>>  	/* All pages of vm should be charged to same memcg, so use first one. */
>>>>  	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
>>>>  		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
>>>> -	for (i = 0; i < vm->nr_pages; i++) {
>>>> +
>>>> +	start = vm->pages[0];
>>>> +	BUG_ON(!start);
>>>> +	nr = 1;
>>>> +	for (i = 1; i < vm->nr_pages; i++) {
>>>>  		struct page *page = vm->pages[i];
>>>>
>>>>  		BUG_ON(!page);
>>>> -		/*
>>>> -		 * High-order allocs for huge vmallocs are split, so
>>>> -		 * can be freed as an array of order-0 allocations
>>>> -		 */
>>>> -		__free_page(page);
>>>> -		cond_resched();
>>>> +
>>>> +		if (start + nr != page) {
>>>> +			free_pages_bulk(start, nr);
>>>> +			start = page;
>>>> +			nr = 1;
>>>> +			cond_resched();
>>>> +		} else {
>>>> +			nr++;
>>>> +		}
>>>>  	}
>>>> +	free_pages_bulk(start, nr);
>>>> +
>>>>  	if (!(vm->flags & VM_MAP_PUT_PAGES))
>>>>  		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>>>>  	kvfree(vm->pages);
>>>> ---8<---
>>>>
>>>>>>> Since the best strategy is workload-dependent, this patch adds a
>>>>>>> parameter letting users to choose whether vmalloc should try
>>>>>>> high-order allocations or stay strictly on the order-0 fastpath.
>>>>>>>
>>>>>>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>>>>>> ---
>>>>>>>  mm/vmalloc.c | 9 +++++++--
>>>>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>>>>> index d3a4725e15ca..f66543896b16 100644
>>>>>>> --- a/mm/vmalloc.c
>>>>>>> +++ b/mm/vmalloc.c
>>>>>>> @@ -43,6 +43,7 @@
>>>>>>>  #include <asm/tlbflush.h>
>>>>>>>  #include <asm/shmparam.h>
>>>>>>>  #include <linux/page_owner.h>
>>>>>>> +#include <linux/moduleparam.h>
>>>>>>>  
>>>>>>>  #define CREATE_TRACE_POINTS
>>>>>>>  #include <trace/events/vmalloc.h>
>>>>>>> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>>>>>>>  	return nr_allocated;
>>>>>>>  }
>>>>>>>  
>>>>>>> +static int attempt_larger_order_alloc;
>>>>>>> +module_param(attempt_larger_order_alloc, int, 0644);
>>>>>> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
>>>>>> Y/N as the value; that's probably more intuitive?
>>>>>>
>>>>>> nit: I'd favour a shorter name. Perhaps large_order_alloc?
>>>>>>
>>>>> Thanks! We can switch to bool and use shorter name for sure.
>>>>>
>>>>> --
>>>>> Uladzislau Rezki
>>


