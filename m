Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC993D65C7B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 17:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8ECC6B0005; Wed, 17 Dec 2025 12:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11D36B0089; Wed, 17 Dec 2025 12:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08456B008A; Wed, 17 Dec 2025 12:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD6D56B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:01:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 427C48B4EC
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:01:25 +0000 (UTC)
X-FDA: 84229578930.08.A09B75C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4D36940026
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:01:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765990883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0NC0fbl8xjoMve3P0ozuqRy+osvd9wlilouQC/PDFs=;
	b=r3Sghsv4iKEcLLnKuUKwO74Gny4e+JQ+I0kqvfrpJv1NeGsi6QGTOmmwN0I5xhmfe8ExUD
	bWzeFgY/6kpPrFl9/jkjb+sxxuEBDddxRlLZRF+RQy7z5Wqut9VnpAaq7NBd81JP4ynG5l
	vQq86VFXrVcmGqlrDvynl6iycaBbvh8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765990883; a=rsa-sha256;
	cv=none;
	b=uw9dNXvyrsSwPuIusmJcQQ0DAO+d5rqixA9ocIJIVWugWZs8b2bmYnEAiF6kgOBF0OBs3N
	4GkvS6MhKBTT5Q/HKry9xFTFKcgkB3byQn4m3YPO2uTKfcwwvp8hpy/a/9M2C1K+gAEiP/
	KvsRXXLVE4UVgz328PgMSUeJXB7IPdM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51F19FEC;
	Wed, 17 Dec 2025 09:01:15 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BE793F73F;
	Wed, 17 Dec 2025 09:01:21 -0800 (PST)
Message-ID: <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
Date: Wed, 17 Dec 2025 17:01:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
In-Reply-To: <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D36940026
X-Stat-Signature: eqa8f3nwdoubs46ax59xaqu7x54ux1qr
X-HE-Tag: 1765990883-297549
X-HE-Meta: U2FsdGVkX18MaIE53iRTj/aubsG2VGma9TaP07H4ly1FaWSnQGGpCzSqK5TlUHpIdFi9bZ2YDfIGIuWXSfe3M2tQTq9dMHgNs0c7MhRbre7GrLHiyT45pT5te0H0JRiivGGeH5PFqeS3hOzNiGD40jtCY65GFIccmMJb7kWZyFgBb68101FchZI3XrQeKKG6HBd8+z88H8uIQerYGMlIChmREzrLktTgzpIzU8H0E9eII/oLOEs0FEGphSdCgAwt9aD5LG2E4fpvfdNn9oot6NPvn321tjfUywhmO0+SviFHvUmcEGTHmRAnI4+Tgd5hfkMDjs2zMu0tE4vHDQ16SI8VdNXDu8BD8NG2xMOsySzZ8SSA+HwbzzEun5dNsLNlpc4Ln5gTdVEseRhyhQDGpTvhVFytdiRtU1SQUWZspt0zNdX2rPd3wrJVGRcec3pYTmolpdGhaD2j5M1v0+3FxO08txFj4cvLY7nH7yc4k6UyxtMi1O0iSd8H978aC6Tvf8Cqjf1584VKP0o38UM8f02rFhFm/+I/kRU6XB9c5lnlILhN3q2Z8OG/3Sq4Zdte6axwyC+fqpoOnKvZBTx4ZAe3CFTAGwGe4CBSEz3ZnZN+EQjLJb4H0LXNNc3S4N0jwoxCsrrRM65gSs0ttsl2ipzA703VUv4n/S7yuvfaQHWVWsft8V95wJmpKtRpsCggCKcSpVx4Z7jL6GpfjZd/VDrNMucfqyrpQU4ZJIRf/NXH7X1Ji17Qj9lDDBXu3R8VG8MpDTP8SfTnTScHetMwPG4fsJIrWIMKRWuwglfadaQa0wFEGr+Avt3EycV8kzVdvB8pHEKW8tBuM52ajkrc8HJWtCzg9Vno0hfGjzhZQoF0JyGrfJb9qxAMsODiyu8g2BXnQxso1V+db8a4efECwICbNTtypO99BdEXAaP7xrXUVQCR2uGDtqB7GoxcBP+JN8IzIo3ZoCEWdFcMqF6
 tr+d/ltH
 SBtzAINSN+/qPvl+B7F0PlwEkPFqGea2m0C3xfIunWmFJzMR3BkwahsLDlhk4VptFU+bHonvgT1eYQQvQLGBhJGAB0lOVNjtpGPKr4Hwd+fxx2Js3nMQLSXeh/UFzcDpYCQXe+xhII42s0BTV17u02SW4hQtOSYbOSrnZkAmSdmizx8KEt4RPfQ5q+15PaJ2vxdg1EP5yaILYNj8LOypq/KmuW23jjM0M/6gzNkwt/I8XDDuPn9kxB9/h+OcSIaqeTTqljDXXzonnG9JoshovHykdrt1KGq59a8QmWiR78YeCohnxH2Xicr49foyiHxRvhbbkM9rlDyrWoQuCmViIO4A25w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 15:20, Ryan Roberts wrote:
> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>> Introduce a module parameter to enable or disable the large-order
>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>> default so far, but users may explicitly enable them at runtime if
>>>> desired.
>>>>
>>>> High-order pages allocated for vmalloc are immediately split into
>>>> order-0 pages and later freed as order-0, which means they do not
>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>> can affect performance.
>>>>
>>>> However, when the PCP caches are empty, high-order allocations may
>>>> show better performance characteristics especially for larger
>>>> allocation requests.
>>>
>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>> else try large order, else fallback to order-0" Could that provide the best of
>>> all worlds without needing a configuration knob?
>>>
>> I am not sure, to me it looks like a bit odd. 
> 
> Perhaps it would feel better if it was generalized to "first try allocation from
> PCP list, highest to lowest order, then try allocation from the buddy, highest
> to lowest order"?
> 
>> Ideally it would be
>> good just free it as high-order page and not order-0 peaces.
> 
> Yeah perhaps that's better. How about something like this (very lightly tested
> and no performance results yet):
> 
> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
> memory leaks when running mm selftests...)
> 
> ---8<---
> commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
> Author: Ryan Roberts <ryan.roberts@arm.com>
> Date:   Wed Dec 17 15:11:08 2025 +0000
> 
>     WIP
> 
>     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index b155929af5b1..d25f5b867e6b 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
>  extern void free_pages_nolock(struct page *page, unsigned int order);
>  extern void free_pages(unsigned long addr, unsigned int order);
> 
> +void free_pages_bulk(struct page *page, int nr_pages);
> +
>  #define __free_page(page) __free_pages((page), 0)
>  #define free_page(addr) free_pages((addr), 0)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..5f11224cf353 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
> order,
>  	}
>  }
> 
> +static void free_frozen_pages_bulk(struct page *page, int nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned int fit_order, align_order, order;
> +		unsigned long pfn;
> +
> +		pfn = page_to_pfn(page);
> +		fit_order = ilog2(nr_pages);
> +		align_order = pfn ? __ffs(pfn) : fit_order;
> +		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
> +
> +		free_frozen_pages(page, order);
> +
> +		page += 1U << order;
> +		nr_pages -= 1U << order;
> +	}
> +}
> +
> +void free_pages_bulk(struct page *page, int nr_pages)
> +{
> +	struct page *start = NULL;
> +	bool can_free;
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++, page++) {
> +		VM_BUG_ON_PAGE(PageHead(page), page);
> +		VM_BUG_ON_PAGE(PageTail(page), page);
> +
> +		can_free = put_page_testzero(page);
> +
> +		if (!can_free && start) {
> +			free_frozen_pages_bulk(start, page - start);
> +			start = NULL;
> +		} else if (can_free && !start) {
> +			start = page;
> +		}
> +	}
> +
> +	if (start)
> +		free_frozen_pages_bulk(start, page - start);
> +}
> +
>  /**
>   * __free_pages - Free pages allocated with alloc_pages().
>   * @page: The page pointer returned from alloc_pages().
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..8f782bac1ece 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
>  void vfree(const void *addr)
>  {
>  	struct vm_struct *vm;
> -	int i;
> +	struct page *start;
> +	int i, nr;
> 
>  	if (unlikely(in_interrupt())) {
>  		vfree_atomic(addr);
> @@ -3455,17 +3456,26 @@ void vfree(const void *addr)
>  	/* All pages of vm should be charged to same memcg, so use first one. */
>  	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
>  		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
> -	for (i = 0; i < vm->nr_pages; i++) {
> +
> +	start = vm->pages[0];
> +	BUG_ON(!start);
> +	nr = 1;
> +	for (i = 1; i < vm->nr_pages; i++) {
>  		struct page *page = vm->pages[i];
> 
>  		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		__free_page(page);
> -		cond_resched();
> +
> +		if (start + nr != page) {
> +			free_pages_bulk(start, nr);
> +			start = page;
> +			nr = 1;
> +			cond_resched();
> +		} else {
> +			nr++;
> +		}
>  	}
> +	free_pages_bulk(start, nr);
> +
>  	if (!(vm->flags & VM_MAP_PUT_PAGES))
>  		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>  	kvfree(vm->pages);
> ---8<---

I tested this on a performance monitoring system and see a huge improvement for 
the test_vmalloc tests.

Both columns are compared to v6.18. 6-19-0-rc1 has Vishal's change to allocate 
large orders, which I previously reported the regressions for. vfree-high-order 
adds the above patch to free contiguous order-0 pages in bulk.

(R)/(I) means statistically significant regression/improvement. Results are 
normalized so that less than zero is regression and greater than zero is 
improvement.

+-----------------+----------------------------------------------------------+--------------+------------------+
| Benchmark       | Result Class                                             |   6-19-0-rc1 | vfree-high-order |
+=================+==========================================================+==============+==================+
| micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  (R) -40.69% |        (I) 3.98% |
|                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |        0.10% |           -1.47% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  (R) -22.74% |       (I) 11.57% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  (R) -23.63% |       (I) 47.42% |
|                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |       -1.58% |      (I) 106.01% |
|                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  (R) -24.39% |       (I) 99.12% |
|                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |    (I) 2.34% |      (I) 196.87% |
|                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |  (R) -23.29% |      (I) 125.42% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |    (I) 3.74% |      (I) 238.59% |
|                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |  (R) -23.80% |      (I) 132.38% |
|                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |   (R) -2.84% |      (I) 514.75% |
|                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |        2.74% |            0.33% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |        0.58% |            1.36% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       -0.66% |            1.48% |
|                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |  (R) -25.24% |       (I) 77.95% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |       -0.58% |            0.60% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  (R) -45.75% |        (I) 8.51% |
|                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |  (R) -28.16% |       (I) 65.34% |
|                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |       -0.54% |           -0.33% |
+-----------------+----------------------------------------------------------+--------------+------------------+

What do you think?

Thanks,
Ryan

> 
>>
>>>>
>>>> Since the best strategy is workload-dependent, this patch adds a
>>>> parameter letting users to choose whether vmalloc should try
>>>> high-order allocations or stay strictly on the order-0 fastpath.
>>>>
>>>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>>> ---
>>>>  mm/vmalloc.c | 9 +++++++--
>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>> index d3a4725e15ca..f66543896b16 100644
>>>> --- a/mm/vmalloc.c
>>>> +++ b/mm/vmalloc.c
>>>> @@ -43,6 +43,7 @@
>>>>  #include <asm/tlbflush.h>
>>>>  #include <asm/shmparam.h>
>>>>  #include <linux/page_owner.h>
>>>> +#include <linux/moduleparam.h>
>>>>  
>>>>  #define CREATE_TRACE_POINTS
>>>>  #include <trace/events/vmalloc.h>
>>>> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>>>>  	return nr_allocated;
>>>>  }
>>>>  
>>>> +static int attempt_larger_order_alloc;
>>>> +module_param(attempt_larger_order_alloc, int, 0644);
>>>
>>> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
>>> Y/N as the value; that's probably more intuitive?
>>>
>>> nit: I'd favour a shorter name. Perhaps large_order_alloc?
>>>
>> Thanks! We can switch to bool and use shorter name for sure.
>>
>> --
>> Uladzislau Rezki
> 


