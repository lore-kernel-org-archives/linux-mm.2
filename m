Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CE1C79FAD
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 17:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539596B01F5; Mon,  5 Jan 2026 12:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E02D6B01F6; Mon,  5 Jan 2026 12:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416A16B01F7; Mon,  5 Jan 2026 12:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCEA6B01F5
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:31:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3E5B57397
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:31:39 +0000 (UTC)
X-FDA: 84298602318.23.B3EDE6A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 943C0140007
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:31:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767634298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKrvq4fGp0Sqp9qMLobNd0UqwGzGinQoyQT8YwAbBlo=;
	b=hNuwT8YRva57HLswJbR4xb01ZpeiOOAxPaJsRNRZ/E8RZO/O1pSGm/PWw20syJavZaQ9Wc
	O/cvZsqrwMHL4YJx8VqTIgqXtQ6Id05KX3ppGT5LN+DN97SY95cKNohOE0JTH/WNKV+o2Q
	eA6NAJXZ5dgyUDxhznNn1jN/DxvjR0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767634298; a=rsa-sha256;
	cv=none;
	b=WYG3w911ymoTmBdQVaHctqk+tyzyob2gcMAXkXFPU01bL6rXmHBuWNpP3ggGyGKv1uCxwy
	PHGlnaYFJoyYvx6AYHk5dPftWkHf6jDPpUvTcFq2YSeyTL/LekhGvRLYgb0OZ8pi7YNtMB
	y+zn9m8gn/yjpxfNGWOXxV9KSDVpKgw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE946339;
	Mon,  5 Jan 2026 09:31:29 -0800 (PST)
Received: from [10.1.38.150] (XHFQ2J9959.cambridge.arm.com [10.1.38.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D273A3F5A1;
	Mon,  5 Jan 2026 09:31:34 -0800 (PST)
Message-ID: <280a3945-ff1e-48a5-a51b-6bb479d23819@arm.com>
Date: Mon, 5 Jan 2026 17:31:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm/page_alloc: Optimize free_contig_range()
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-2-ryan.roberts@arm.com>
 <A10AC2A5-416C-4820-AF9B-D3B6946E3346@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <A10AC2A5-416C-4820-AF9B-D3B6946E3346@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ezdzd7nupe5u4mmpnmqa3kufzb7is483
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 943C0140007
X-HE-Tag: 1767634297-976145
X-HE-Meta: U2FsdGVkX18ddh8F5sxwJxHKsPOZ2K5ZI4z3jGK2PiIMXqtRniW6B5E3mv8kyp3pT04/tr47KmNYtinsfK+fWeMAQBIwRI4Ldht+FvijIPqaRK6mlA7+lDPRlNm7Guf1FKwzUt1mlV4Q5OZ76UAyQslmTe6D5B8TECxQvDHEnuybs/2cNzGryedn1LmgzQ+OJ+t8+7Q8BPP/vkwKKJdqUy8FIG5l9jAoJT8Z1LMhyxz5aGcr9i3zSMbYdUtDYUoLJEveczFu0D88Ph8J/5Wseie8M9OeOHkExVKbsFKbvfrTGC+Gd05QX0NZrmPoY+zUc1rno6HC7udT5LtJASV5j/1MaaZr4kSfTFvWdXV9wmD2Ys/ZrB1GGcmsVCLVwLPaE4nMEv+t7c77lZGMWIiJHfQwg43jM2t5eH5tPu3+6d87h+ytaxnIAA6q3WvaeLbGmRb2b1GRQJht+9Z6QPBN1kC49JEP7GmZtJRCX00YoJZBwwufxjMAxgLdmFs4V7Qei7ztPpag5k074S3dwzPalwqi0toQhgsfShgWONizjBzQLWXtVoKvuKLaxAc9+Cc5QDVYMvon0TvGB3P41YSvbf06AWtHsvZ5sw9kCHscEhB3YQhCo56lgpBlvTAbd28QOEpwgmZEemd/gIb7hTMhPMWBob6FFE06R//uldlPW8cVjT8FEDzH4lm7/+ZL+oMkMHEOWsDwxr7hLi7nzvSCh9oU/4y3EZzzP07TXlWt/xApoT756pOYqUxI2IlIOSz3wYa7a95vZX9Vcq4M8qpZe690weIBaEp5gJGxEX2GMKRjD5Oo0tEH4VC+xachyuAEifClIsdoVV7+WtX8lOGCXm7CFVgSNe3OZ1p/O6ZkYtms3eosZUpu6MZ2mgiFQpu3F/g3PyGgWH1LV9Ue9C6MAOYUo+/jlqFlKDbTvPmJQZ60924RhVulmNh7bUzmb85QwkaFsMEqJxry49peRie
 DwjPFYOe
 /5eP0YDBTBdT0BBMTYtssZstM6QPB2bR7fVkiPdDp07YMfuPcW8WEqbfvZcDAtLt/x+nJKbzJ9m9BGnL//zl1OjAIJS8SFT1xoJTWtiNBz5c0sZv9fIjuGFm1h7X76HrWWMa4sAKCSDJ744FTTmUnYMR1oMhUKukuqu37P1bPrbbDcRyxNNZGZEfTFG4rqDhiAvuezFcnBFuI8PmRqFPCwgBeiVndXz+oHND6vLpV8nyTxioQ6erG4DrbAm1KAqIHXqhxraRtC0k24t3XlO34LH7CnNPV4yBeEkYJG//lYt7nkECZwL1Ww8PdiIPEsuB+WFI5vTTk8l2iK8EuY8WzgzbI4vuC7Zv7PmcbTFLC7bbDuHatMA7Q5VuMEmZhQ0T1IKZBg9DubcwIFuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/01/2026 17:15, Zi Yan wrote:
> On 5 Jan 2026, at 11:17, Ryan Roberts wrote:
> 
>> Decompose the range of order-0 pages to be freed into the set of largest
>> possible power-of-2 size and aligned chunks and free them to the pcp or
>> buddy. This improves on the previous approach which freed each order-0
>> page individually in a loop. Testing shows performance to be improved by
>> more than 10x in some cases.
>>
>> Since each page is order-0, we must decrement each page's reference
>> count individually and only consider the page for freeing as part of a
>> high order chunk if the reference count goes to zero. Additionally
>> free_pages_prepare() must be called for each individual order-0 page
>> too, so that the struct page state and global accounting state can be
>> appropriately managed. But once this is done, the resulting high order
>> chunks can be freed as a unit to the pcp or buddy.
>>
>> This significiantly speeds up the free operation but also has the side
>> benefit that high order blocks are added to the pcp instead of each page
>> ending up on the pcp order-0 list; memory remains more readily available
>> in high orders.
>>
>> vmalloc will shortly become a user of this new optimized
>> free_contig_range() since it agressively allocates high order
>> non-compound pages, but then calls split_page() to end up with
>> contiguous order-0 pages. These can now be freed much more efficiently.
>>
>> The execution time of the following function was measured in a VM on an
>> Apple M2 system:
>>
>> static int page_alloc_high_ordr_test(void)
>> {
>> 	unsigned int order = HPAGE_PMD_ORDER;
>> 	struct page *page;
>> 	int i;
>>
>> 	for (i = 0; i < 100000; i++) {
>> 		page = alloc_pages(GFP_KERNEL, order);
>> 		if (!page)
>> 			return -1;
>> 		split_page(page, order);
>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>> 	}
>>
>> 	return 0;
>> }
>>
>> Execution time before: 1684366 usec
>> Execution time after:   136216 usec
>>
>> Perf trace before:
>>
>>     60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_from_fork
>>             |
>>             ---ret_from_fork
>>                kthread
>>                0xffffbba283e63980
>>                |
>>                |--60.01%--0xffffbba283e636dc
>>                |          |
>>                |          |--58.57%--free_contig_range
>>                |          |          |
>>                |          |          |--57.19%--___free_pages
>>                |          |          |          |
>>                |          |          |          |--46.65%--__free_frozen_pages
>>                |          |          |          |          |
>>                |          |          |          |          |--28.08%--free_pcppages_bulk
>>                |          |          |          |          |
>>                |          |          |          |           --12.05%--free_frozen_page_commit.constprop.0
>>                |          |          |          |
>>                |          |          |          |--5.10%--__get_pfnblock_flags_mask.isra.0
>>                |          |          |          |
>>                |          |          |          |--1.13%--_raw_spin_unlock
>>                |          |          |          |
>>                |          |          |          |--0.78%--free_frozen_page_commit.constprop.0
>>                |          |          |          |
>>                |          |          |           --0.75%--_raw_spin_trylock
>>                |          |          |
>>                |          |           --0.95%--__free_frozen_pages
>>                |          |
>>                |           --1.44%--___free_pages
>>                |
>>                 --0.78%--0xffffbba283e636c0
>>                           split_page
>>
>> Perf trace after:
>>
>>     10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_fork
>>             |
>>             ---ret_from_fork
>>                kthread
>>                0xffffbbd55ef74980
>>                |
>>                |--8.74%--0xffffbbd55ef746dc
>>                |          free_contig_range
>>                |          |
>>                |           --8.72%--__free_contig_range
>>                |
>>                 --1.56%--0xffffbbd55ef746c0
>>                           |
>>                            --1.54%--split_page
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  include/linux/gfp.h |   1 +
>>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
>>  2 files changed, 106 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index b155929af5b1..3ed0bef34d0c 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>>
>>  #endif
>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>
>>  #ifdef CONFIG_CONTIG_ALLOC
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a045d728ae0f..1015c8edf8a4 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>  /* Free the page without taking locks. Rely on trylock only. */
>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>
>> +/* free_pages_prepare() has already been called for page(s) being freed. */
>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>> +
>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>> @@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>>  	unsigned long pfn = page_to_pfn(page);
>>  	struct zone *zone = page_zone(page);
>>
>> -	if (free_pages_prepare(page, order))
>> -		free_one_page(zone, page, pfn, order, fpi_flags);
>> +	if (!(fpi_flags & FPI_PREPARED)) {
>> +		if (!free_pages_prepare(page, order))
>> +			return;
>> +	}
>> +
>> +	free_one_page(zone, page, pfn, order, fpi_flags);
>>  }
>>
>>  void __meminit __free_pages_core(struct page *page, unsigned int order,
>> @@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>>  		return;
>>  	}
>>
>> -	if (!free_pages_prepare(page, order))
>> -		return;
>> +	if (!(fpi_flags & FPI_PREPARED)) {
>> +		if (!free_pages_prepare(page, order))
>> +			return;
>> +	}
>>
>>  	/*
>>  	 * We only track unmovable, reclaimable and movable on pcp lists.
>> @@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>>  }
>>  #endif /* CONFIG_CONTIG_ALLOC */
>>
>> +static void free_prepared_contig_range(struct page *page,
>> +				       unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned int fit_order, align_order, order;
>> +		unsigned long pfn;
>> +
>> +		/*
>> +		 * Find the largest aligned power-of-2 number of pages that
>> +		 * starts at the current page, does not exceed nr_pages and is
>> +		 * less than or equal to pageblock_order.
>> +		 */
>> +		pfn = page_to_pfn(page);
>> +		fit_order = ilog2(nr_pages);
>> +		align_order = pfn ? __ffs(pfn) : fit_order;
>> +		order = min3(fit_order, align_order, pageblock_order);
>> +
>> +		/*
>> +		 * Free the chunk as a single block. Our caller has already
>> +		 * called free_pages_prepare() for each order-0 page.
>> +		 */
>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>> +
>> +		page += 1UL << order;
>> +		nr_pages -= 1UL << order;
>> +	}
>> +}
>> +
>> +/**
>> + * __free_contig_range - Free contiguous range of order-0 pages.
>> + * @pfn: Page frame number of the first page in the range.
>> + * @nr_pages: Number of pages to free.
>> + *
>> + * For each order-0 struct page in the physically contiguous range, put a
>> + * reference. Free any page who's reference count falls to zero. The
>> + * implementation is functionally equivalent to, but significantly faster than
>> + * calling __free_page() for each struct page in a loop.
>> + *
>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>> + * can be freed with this API.
>> + *
>> + * Returns the number of pages which were not freed, because their reference
>> + * count did not fall to zero.
>> + *
>> + * Context: May be called in interrupt context or while holding a normal
>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>> + */
>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	struct page *page = pfn_to_page(pfn);
>> +	unsigned long not_freed = 0;
>> +	struct page *start = NULL;
>> +	unsigned long i;
>> +	bool can_free;
>> +
>> +	/*
>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>> +	 * free_pages_prepare() fails we consider the page to have been freed
>> +	 * deliberately leak it.
>> +	 *
>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>> +	 * vice versa.
>> +	 */
>> +	for (i = 0; i < nr_pages; i++, page++) {
>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>> +
>> +		can_free = put_page_testzero(page);
>> +		if (!can_free)
>> +			not_freed++;
>> +		else if (!free_pages_prepare(page, 0))
>> +			can_free = false;
> 
> I understand you use free_pages_prepare() here to catch early failures.
> I wonder if we could let __free_frozen_pages() handle the failure of
> non-compound >0 order pages instead of a new FPI flag.

I'm not sure I follow. You would still need to provide a flag to
__free_frozen_pages() to tell it "this is a set of order-0 pages". Otherwise it
will treat it as a non-compound high order page, which would be wrong;
free_pages_prepare() would only be called for the head page (with the order
passed in) and that won't do the right thing.

I guess you could pass the flag all the way to free_pages_prepare() then it
could be modified to do the right thing for contiguous order-0 pages; that would
probably ultimately be more efficient then calling free_pages_prepare() for
every order-0 page. Is that what you are suggesting?

> 
> Looking at free_pages_prepare(), three cases would cause failures:
> 1. PageHWPoison(page): the code excludes >0 order pages, so it needs
>    to be fixed. BTW, Jiaqi Yan has a series trying to tackle it[1].
> 
> 2. uncleared PageNetpp(page): probably need to check every individual
>    page of this >0 order page and call bad_page() for any violator.
> 
> 3. bad free page: probably need to do it for individual page as well.

It's not just handling the failures, it's accounting; e.g.
__memcg_kmem_uncharge_page().

> 
> I think it might be too much effort for you to get the above done.

Indeed, I'd prefer to consider that an additional improvement opportunity :)

> Can you leave a TODO at FPI_PREPARED? I might try to do it
> if Jiaqi’s series can be merged?

Yes no problem!

> 
> Otherwise, the rest of the patch looks good to me.

Thanks for the quick review. I'll wait to see if others chime in then rebase
onto mm-new at the ~end of the week.

Thanks,
Ryan

> 
> Thanks.
> 
> 
> [1] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@google.com/
> 
>> +
>> +		if (!can_free && start) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = NULL;
>> +		} else if (can_free && !start) {
>> +			start = page;
>> +		}
>> +	}
>> +
>> +	if (start)
>> +		free_prepared_contig_range(start, page - start);
>> +
>> +	return not_freed;
>> +}
>> +EXPORT_SYMBOL(__free_contig_range);
>> +
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>  {
>> -	unsigned long count = 0;
>> +	unsigned long count;
>>  	struct folio *folio = pfn_folio(pfn);
>>
>>  	if (folio_test_large(folio)) {
>> @@ -7266,12 +7365,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>  		return;
>>  	}
>>
>> -	for (; nr_pages--; pfn++) {
>> -		struct page *page = pfn_to_page(pfn);
>> -
>> -		count += page_count(page) != 1;
>> -		__free_page(page);
>> -	}
>> +	count = __free_contig_range(pfn, nr_pages);
>>  	WARN(count != 0, "%lu pages are still in use!\n", count);
>>  }
>>  EXPORT_SYMBOL(free_contig_range);
>> --
>> 2.43.0
> 
> 
> Best Regards,
> Yan, Zi


