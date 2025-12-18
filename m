Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEEFD66BB3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 04:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1836B0088; Wed, 17 Dec 2025 23:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74B16B0089; Wed, 17 Dec 2025 23:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80F26B008A; Wed, 17 Dec 2025 23:55:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 931B56B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:55:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3538E60E5B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:55:54 +0000 (UTC)
X-FDA: 84231379428.20.A69D15A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 151D4A0006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:55:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766033752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lTP4/pC7O4ZRmjf8v09zc3/G5DEJNShooxS83M3u2Ko=;
	b=X80rWFDb5un6dnzLAIyAHGLm3u2UUAhPaAurRaHWE7XdF+BEvciLbulVRBKg98VzgYTPMJ
	AorS7fXaNv2jcdYT4LDStXSRBhUvj+os38kPu9BVx7BltMa8EcjeaqoQc7FD1N8yWb6Fwf
	2LvdBt1S6+Qk2pqxLxBVh0aQ1f9+PuM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766033752; a=rsa-sha256;
	cv=none;
	b=x/kcNKea0HvFlJn3LkJuOlmNjCsC7+JPG+UHyrsLIkODvKlw/3gdYXFimQR8YgUBtjkFlt
	kyaS2Xn5NFn6OO0yiO3Z8guQY+ra9f11Kzkv11/AyZPwS1hL1YeModiTcZRk0zTcM9v1ie
	XYuRd+WHBYn5PF0ThusCUIUtfbsr3XE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C65DEFEC;
	Wed, 17 Dec 2025 20:55:43 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0FFC3F762;
	Wed, 17 Dec 2025 20:55:48 -0800 (PST)
Message-ID: <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
Date: Thu, 18 Dec 2025 10:25:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
To: Ryan Roberts <ryan.roberts@arm.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 151D4A0006
X-Stat-Signature: 5qu6o5kpi7a7fpubr984wjq8abq8kxpk
X-Rspam-User: 
X-HE-Tag: 1766033751-646439
X-HE-Meta: U2FsdGVkX1/Wvq74pBbMpLgC/hgzvW6ln2MxD36pTIerGwKEJKyXAhR9ZABxbvweAcdq8ga8DHv7s4ErCi25qR2gnkC6++397r7nVlg06VCbAHwP8NgYzSAHiMiRgTB4TlaU9fNsc0vHNkIiz+BcqRnGRJjA8+gkpylBdnPu7DyZQAswRi/Wc7DTQLNRB2oalsi7ugtNiz7J+HICUMJJTDj3mG5H01u1p8J2xVGgDRkyEsyBwfJmDDToAPZOS/XuCIAFLZcrqAoQI9R2/5zPmFnkg9sgFc0EzKBgYuo4x/0uR9JV/XS3/zbd0D74t4pcEQ4YWigiRdWNej9ITRokS2Y6/ZUU7Bz4bJ2D4dBxNwy/HBPc8jHAkUN4lgE1F5r/tSJo2RnNheYT/efSnoKER9wgh+bHLxMEk1BahNjG1y+rQ8r+T23btcEIVGiPRMlaWAhOMd4zioRfNmB94Z3kvNwDEsK74pFy2LwdkvAkBj+WL+hBdDNClA4C3VcSv6KO6tXUC5gWH4+n7s2jFV4gDhC38tEodZDyUrDfxtiV0aXm8yqA0dE9+b/DpBE62P7tV12DB1oucIDgjez+Sn4vd6WTryJYAdfX6zpPP/szd2ESW7igqcPJ3psOCN7XjiyYwmPNgam5DlBb6R6q1YEkEdb/qiE1IR0lFRY9htaT/ibA0ZVKLPql9u8TUG5PileZ89qoiHhmzvH1kyhjp3MiTFcTs/LZzs8+N+74MSsVpD2tQ2wEm3Kk0NIVJ3N+scslHS0bbI2T0VM+T8BO+bJvgdV4K1er1VXhzONefJ32X0mYbMISCYovU4tpcUUE7mbH5gSVgAteQbeCEw6evAUTYQVZhsn3o2Ob/9xQjMsq1XbeTmWOsa/b1YnGhHO1Lz3Ia/rSBo7oefpMFttOvxs7EiOOLtkvRRsVuGcSZnz7gwySfaIZ6zfOKu0iAGqphXSZuu916fzXgIT5bhlIBaF
 nE3xXoCu
 EflBzcscRDy1cNPWUOa/JLgDLbRAujRhEjiIHK7+tJNXbWUVSGhNlL8vt2O8pesXIQgOJo8/WUZsbb6ouVuP1cZJFfH9pIH8IpzPdRwGmkMhRCo+DSk2Eu/AKK5Sdc1nAxpMtKcWGEGQy3VfEqz8W/XUg4qg7Eroj5HQMt/tSyJ35DzVZ+mZUOTp20GYrqsRuj6kLu6McdQjmSsx5FOD1GKRm4syuCj2fet1Q0mwlC3ojabtITxwokJr5WCGIJW5hMVM3GHTZu1QSaNZT+9+Kn/aFdVPtiN7vRORQY6lseJ7zt53d4MnZkcHan2Ip4na6FmvoQFYxmJU3d8MhOXu9agLJrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/12/25 8:50 pm, Ryan Roberts wrote:
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
>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>> else try large order, else fallback to order-0" Could that provide the best of
>>> all worlds without needing a configuration knob?
>>>
>> I am not sure, to me it looks like a bit odd. 
> Perhaps it would feel better if it was generalized to "first try allocation from
> PCP list, highest to lowest order, then try allocation from the buddy, highest
> to lowest order"?
>
>> Ideally it would be
>> good just free it as high-order page and not order-0 peaces.
> Yeah perhaps that's better. How about something like this (very lightly tested
> and no performance results yet):
>
> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
> memory leaks when running mm selftests...)

Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
arm64/mmu.c already does this - it computes order from size and passes it to
__free_pages().

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
>
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
>>> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
>>> Y/N as the value; that's probably more intuitive?
>>>
>>> nit: I'd favour a shorter name. Perhaps large_order_alloc?
>>>
>> Thanks! We can switch to bool and use shorter name for sure.
>>
>> --
>> Uladzislau Rezki

