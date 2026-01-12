Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2B8C9EC90
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031E16B0088; Mon, 12 Jan 2026 08:25:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21856B0089; Mon, 12 Jan 2026 08:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DB96B008A; Mon, 12 Jan 2026 08:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB3436B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:25:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76D1CC0241
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:25:02 +0000 (UTC)
X-FDA: 84323382444.22.B71B9DF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8B047C0002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:25:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768224300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2yUQt2HRkdugDfzoFIi6vMvVIrBF5/UYiSl7OKUnRuo=;
	b=ONwn3D/H9wrN1EpPMOHRTWFk7qT8jGc3koBW9fvixqrj1zMgEa8WEFeBgt6LkCXZAEARys
	bUUl2slxxw++wI9SS9KpWjM/pVVYNU2Aml2iQyLcRTXG+ANaX8fzz65IFPecfk9L1CA34M
	Yv09sTeZPoB5tmXn7tq0/iUKyUL/3/0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768224300; a=rsa-sha256;
	cv=none;
	b=YPWZtmoPEbtxvgZXz/79gmccm3IkrA1DiFnSZPNOPwcejDkZngvGl/X/0WBWohZB/0ZHMu
	kkfS4CSoXBrhp5OFTgENBTmlFV4JLZNx1/uBS/JkVW6x2p0N5D23NlNtMZEJFJAhi09prb
	l3lGavcuVPC/bTF9SX2YWsVvH1s2t2Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0061B497;
	Mon, 12 Jan 2026 05:24:53 -0800 (PST)
Received: from [10.57.95.123] (unknown [10.57.95.123])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A19D3F694;
	Mon, 12 Jan 2026 05:24:57 -0800 (PST)
Message-ID: <89dfd2d0-cf28-41c7-be9f-b49963e77aa5@arm.com>
Date: Mon, 12 Jan 2026 13:24:55 +0000
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
 <280a3945-ff1e-48a5-a51b-6bb479d23819@arm.com>
 <700A6B2B-9DD1-4F8D-8A38-17FC8BA2F779@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <700A6B2B-9DD1-4F8D-8A38-17FC8BA2F779@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B047C0002
X-Stat-Signature: rpsbchccs4g7q7fagad8xjx3k9d4csjz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768224300-17208
X-HE-Meta: U2FsdGVkX1/uQYtlDpPvo7MwREG6tVOYo7HHGsJaaS05rzs89eu/Omi0pcOpdlceC7TjAQVniNy8y8hxmN0KVR8vx4plbRtnX6G0/BIsYQM8B60ETORQqpZWtYhmLpY8VLEemeAPuRiGDtxWAYCUyMky2MdrJwhmIFdOCqCqwbkpG1Babayt7Cs68LYxiKd1ek/ttWoHC87bmgriSLU0OUbLQ0Tbz5YBNwwHuS/TQsbLsvcYrnkfAoUALiWCLLeJG0Uka7ZHVnh1d3VDBwCaNVzspoUzPrlwNG+2cxO+QAJ9qGU3xvn0t1vttRmirRxqFnaxqfj/hSzgjld0SMdrAdRAwP9SwFDBVkISJrcS3J8dWH0aCwYCPh1OZXmWrAkFn98/ANcOkxcsM+cojGa8Gflsego0C8fInfJT5LhsTXz//eXRb9mD+F8WlGujD8nuTAStRwZ+OxNkmT0O79LhJOH/EY/Nkuk0eDyf5tiBqTqM5cpDxWfrHEuxiSuLYCurOyLAOUy/T/5dI2xZOA7wI6bPdkKui++w2iNFZl0/Gk7MWj17XQoeBHGS/FRidZx2AeQ6dRWVArz5TVg3Rq5XB0gWfF/H2dSC8vjh3GlFPlnqF7Bj8f0a5qCOP4N95delJzZi/Jt/Y9rO4VGxwGcuhnOsSIxu4nle0Cq6s5lW+J5oKJvTX6+uQ7uQr1seYvuwU5zu3fqPtscPdDcozwfuKhccvceNSyPA0tUf6S3a1D/diWK5yRMrSxJvFmZVnfJCE6H9Df0KZYX53kK1UQr+QZIxGrcLGdpU8pQuqpca7HYmdDLPTsPiVBFAlh8bH+JXBAVoZ4cn5t4EiBXQDwWzRbTivaZmxS+1K3eZVPkk/VQqBGcTWQrnhVdMLi3qVPYUFItq0ioiO+p+EI1Ii7TZzCwVfqmnt2Cg0cSPCTL28m03z10VvKdd/ttIEUok60AG0eI4PJzdJ6+QEMHUAuE
 O5xD5P+R
 MwEXwE5sW3u2rSmefeaLQe2c11RJyClrTjjGsPPd5hnDDYYMRaeoxbQ5mRo8ItLoB2FtIYDX/K4MnqPrR3ZdbC3rNn8xREqCAPZML+JXF5K4Cj/yS0PTQ7eQxUDC14rhhFADhbSF5z/wIXD30NbdfnpELRuKN+kYGkEB8s86dHAeRGbOSpO/JY95G2zQFbxh3WpzMBic3XsdMGvFZA2RttCfyx9PmIWlpM8eVpx+Q+sauv/CsRubDAi9AO7TOk0yNPbFfyWunztRv7AxfB+v0gloiXPjxYbR3+f1c4LraYA1ef7ygBTN1cV8LSaqWrZXbhJWD0m0GYKPlRWsgppi10x0U7MR+bO061WRr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

Sorry for slow response - I had some other high priority stuff come in...


On 07/01/2026 03:32, Zi Yan wrote:
> On 5 Jan 2026, at 12:31, Ryan Roberts wrote:
> 
>> On 05/01/2026 17:15, Zi Yan wrote:
>>> On 5 Jan 2026, at 11:17, Ryan Roberts wrote:
>>>
>>>> Decompose the range of order-0 pages to be freed into the set of largest
>>>> possible power-of-2 size and aligned chunks and free them to the pcp or
>>>> buddy. This improves on the previous approach which freed each order-0
>>>> page individually in a loop. Testing shows performance to be improved by
>>>> more than 10x in some cases.
>>>>
>>>> Since each page is order-0, we must decrement each page's reference
>>>> count individually and only consider the page for freeing as part of a
>>>> high order chunk if the reference count goes to zero. Additionally
>>>> free_pages_prepare() must be called for each individual order-0 page
>>>> too, so that the struct page state and global accounting state can be
>>>> appropriately managed. But once this is done, the resulting high order
>>>> chunks can be freed as a unit to the pcp or buddy.
>>>>
>>>> This significiantly speeds up the free operation but also has the side
>>>> benefit that high order blocks are added to the pcp instead of each page
>>>> ending up on the pcp order-0 list; memory remains more readily available
>>>> in high orders.
>>>>
>>>> vmalloc will shortly become a user of this new optimized
>>>> free_contig_range() since it agressively allocates high order
>>>> non-compound pages, but then calls split_page() to end up with
>>>> contiguous order-0 pages. These can now be freed much more efficiently.
>>>>
>>>> The execution time of the following function was measured in a VM on an
>>>> Apple M2 system:
>>>>
>>>> static int page_alloc_high_ordr_test(void)
>>>> {
>>>> 	unsigned int order = HPAGE_PMD_ORDER;
>>>> 	struct page *page;
>>>> 	int i;
>>>>
>>>> 	for (i = 0; i < 100000; i++) {
>>>> 		page = alloc_pages(GFP_KERNEL, order);
>>>> 		if (!page)
>>>> 			return -1;
>>>> 		split_page(page, order);
>>>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>>>> 	}
>>>>
>>>> 	return 0;
>>>> }
>>>>
>>>> Execution time before: 1684366 usec
>>>> Execution time after:   136216 usec
>>>>
>>>> Perf trace before:
>>>>
>>>>     60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_from_fork
>>>>             |
>>>>             ---ret_from_fork
>>>>                kthread
>>>>                0xffffbba283e63980
>>>>                |
>>>>                |--60.01%--0xffffbba283e636dc
>>>>                |          |
>>>>                |          |--58.57%--free_contig_range
>>>>                |          |          |
>>>>                |          |          |--57.19%--___free_pages
>>>>                |          |          |          |
>>>>                |          |          |          |--46.65%--__free_frozen_pages
>>>>                |          |          |          |          |
>>>>                |          |          |          |          |--28.08%--free_pcppages_bulk
>>>>                |          |          |          |          |
>>>>                |          |          |          |           --12.05%--free_frozen_page_commit.constprop.0
>>>>                |          |          |          |
>>>>                |          |          |          |--5.10%--__get_pfnblock_flags_mask.isra.0
>>>>                |          |          |          |
>>>>                |          |          |          |--1.13%--_raw_spin_unlock
>>>>                |          |          |          |
>>>>                |          |          |          |--0.78%--free_frozen_page_commit.constprop.0
>>>>                |          |          |          |
>>>>                |          |          |           --0.75%--_raw_spin_trylock
>>>>                |          |          |
>>>>                |          |           --0.95%--__free_frozen_pages
>>>>                |          |
>>>>                |           --1.44%--___free_pages
>>>>                |
>>>>                 --0.78%--0xffffbba283e636c0
>>>>                           split_page
>>>>
>>>> Perf trace after:
>>>>
>>>>     10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_fork
>>>>             |
>>>>             ---ret_from_fork
>>>>                kthread
>>>>                0xffffbbd55ef74980
>>>>                |
>>>>                |--8.74%--0xffffbbd55ef746dc
>>>>                |          free_contig_range
>>>>                |          |
>>>>                |           --8.72%--__free_contig_range
>>>>                |
>>>>                 --1.56%--0xffffbbd55ef746c0
>>>>                           |
>>>>                            --1.54%--split_page
>>>>
>>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>> ---
>>>>  include/linux/gfp.h |   1 +
>>>>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
>>>>  2 files changed, 106 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>> index b155929af5b1..3ed0bef34d0c 100644
>>>> --- a/include/linux/gfp.h
>>>> +++ b/include/linux/gfp.h
>>>> @@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>>>>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>>>>
>>>>  #endif
>>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>>>
>>>>  #ifdef CONFIG_CONTIG_ALLOC
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index a045d728ae0f..1015c8edf8a4 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>>>  /* Free the page without taking locks. Rely on trylock only. */
>>>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>>>
>>>> +/* free_pages_prepare() has already been called for page(s) being freed. */
>>>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>>>> +
>>>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>>>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>>>> @@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>>>>  	unsigned long pfn = page_to_pfn(page);
>>>>  	struct zone *zone = page_zone(page);
>>>>
>>>> -	if (free_pages_prepare(page, order))
>>>> -		free_one_page(zone, page, pfn, order, fpi_flags);
>>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>>> +		if (!free_pages_prepare(page, order))
>>>> +			return;
>>>> +	}
>>>> +
>>>> +	free_one_page(zone, page, pfn, order, fpi_flags);
>>>>  }
>>>>
>>>>  void __meminit __free_pages_core(struct page *page, unsigned int order,
>>>> @@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>>>>  		return;
>>>>  	}
>>>>
>>>> -	if (!free_pages_prepare(page, order))
>>>> -		return;
>>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>>> +		if (!free_pages_prepare(page, order))
>>>> +			return;
>>>> +	}
>>>>
>>>>  	/*
>>>>  	 * We only track unmovable, reclaimable and movable on pcp lists.
>>>> @@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>>>>  }
>>>>  #endif /* CONFIG_CONTIG_ALLOC */
>>>>
>>>> +static void free_prepared_contig_range(struct page *page,
>>>> +				       unsigned long nr_pages)
>>>> +{
>>>> +	while (nr_pages) {
>>>> +		unsigned int fit_order, align_order, order;
>>>> +		unsigned long pfn;
>>>> +
>>>> +		/*
>>>> +		 * Find the largest aligned power-of-2 number of pages that
>>>> +		 * starts at the current page, does not exceed nr_pages and is
>>>> +		 * less than or equal to pageblock_order.
>>>> +		 */
>>>> +		pfn = page_to_pfn(page);
>>>> +		fit_order = ilog2(nr_pages);
>>>> +		align_order = pfn ? __ffs(pfn) : fit_order;
>>>> +		order = min3(fit_order, align_order, pageblock_order);
>>>> +
>>>> +		/*
>>>> +		 * Free the chunk as a single block. Our caller has already
>>>> +		 * called free_pages_prepare() for each order-0 page.
>>>> +		 */
>>>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>>>> +
>>>> +		page += 1UL << order;
>>>> +		nr_pages -= 1UL << order;
>>>> +	}
>>>> +}
>>>> +
>>>> +/**
>>>> + * __free_contig_range - Free contiguous range of order-0 pages.
>>>> + * @pfn: Page frame number of the first page in the range.
>>>> + * @nr_pages: Number of pages to free.
>>>> + *
>>>> + * For each order-0 struct page in the physically contiguous range, put a
>>>> + * reference. Free any page who's reference count falls to zero. The
>>>> + * implementation is functionally equivalent to, but significantly faster than
>>>> + * calling __free_page() for each struct page in a loop.
>>>> + *
>>>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>>>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>>>> + * can be freed with this API.
>>>> + *
>>>> + * Returns the number of pages which were not freed, because their reference
>>>> + * count did not fall to zero.
>>>> + *
>>>> + * Context: May be called in interrupt context or while holding a normal
>>>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>>>> + */
>>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>>> +{
>>>> +	struct page *page = pfn_to_page(pfn);
>>>> +	unsigned long not_freed = 0;
>>>> +	struct page *start = NULL;
>>>> +	unsigned long i;
>>>> +	bool can_free;
>>>> +
>>>> +	/*
>>>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>>>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>>>> +	 * free_pages_prepare() fails we consider the page to have been freed
>>>> +	 * deliberately leak it.
>>>> +	 *
>>>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>>>> +	 * vice versa.
>>>> +	 */
>>>> +	for (i = 0; i < nr_pages; i++, page++) {
>>>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>>>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>>>> +
>>>> +		can_free = put_page_testzero(page);
>>>> +		if (!can_free)
>>>> +			not_freed++;
>>>> +		else if (!free_pages_prepare(page, 0))
>>>> +			can_free = false;
>>>
>>> I understand you use free_pages_prepare() here to catch early failures.
>>> I wonder if we could let __free_frozen_pages() handle the failure of
>>> non-compound >0 order pages instead of a new FPI flag.
>>
>> I'm not sure I follow. You would still need to provide a flag to
>> __free_frozen_pages() to tell it "this is a set of order-0 pages". Otherwise it
>> will treat it as a non-compound high order page, which would be wrong;
>> free_pages_prepare() would only be called for the head page (with the order
>> passed in) and that won't do the right thing.
>>
>> I guess you could pass the flag all the way to free_pages_prepare() then it
>> could be modified to do the right thing for contiguous order-0 pages; that would
>> probably ultimately be more efficient then calling free_pages_prepare() for
>> every order-0 page. Is that what you are suggesting?
> 
> Yes. I mistakenly mixed up non-compound high order page and a set of order-0
> pages. There is alloc_pages_bulk() to get a list of order-0 pages, but
> free_pages_bulk() does not exist. Maybe that is what we need here?

This is what I initially started with; vmalloc maintains a list of struct pages
so why not just pass that list to something like free_pages_bulk()? The problem
is that the optimization relies on a *contiguous* set of order-0 pages. A list
of pointers to pages does not imply they must be contiguous. So I don't think
it's the right API.

We already have free_contig_range() which takes a range of PFNs. That's the
exact semantic we can optimize so surely that's the better API style? Hence I
added __free_contig_range() and reimplemented free_contig_range() (which does
more than vfree wants()) on top.

> Using __free_frozen_pages() for a set of order-0 pages looks like a
> shoehorning. 

Perhaps; that's an internal function so could rename to __free_frozen_order(),
passing in a PFN and an order and teach it to handle all 3 cases internally:

 - high-order non-compound page (already supports)
 - high-order compound page (already supports)
 - power-of-2 sized and aligned number of contiguos order-0 pages (new)

> I admit that adding free_pages_bulk() with maximal code
> reuse and a good interface will take some effort, so it probably is a long
> term goal. free_pages_bulk() is also slightly different from what you
> want to do, since, if it uses same interface as alloc_pages_bulk(),
> it will need to accept a page array instead of page + order.

Yeah; I don't think that's a good API for this case. We would spend more effort
looking for contiguous pages when there are none. (for the vfree case it's
highly likely that they are contiguous because that's how they were allocated).

> 
> I am not suggesting you should do this, but just think out loud.
> 
>>
>>>
>>> Looking at free_pages_prepare(), three cases would cause failures:
>>> 1. PageHWPoison(page): the code excludes >0 order pages, so it needs
>>>    to be fixed. BTW, Jiaqi Yan has a series trying to tackle it[1].
>>>
>>> 2. uncleared PageNetpp(page): probably need to check every individual
>>>    page of this >0 order page and call bad_page() for any violator.
>>>
>>> 3. bad free page: probably need to do it for individual page as well.
>>
>> It's not just handling the failures, it's accounting; e.g.
>> __memcg_kmem_uncharge_page().
> 
> Got it. Another idea comes to mind.
> 
> Is it doable to
> 1) use put_page_testzero() to bring all pages’ refs to 0,
> 2) unsplit/merge these contiguous order-0 pages back to non-compound
>    high order pages,
> 3) free unsplit/merged pages with __free_frozen_pages()?

Yes, I thought about this approach. I think it would work, but I assumed it
would be extra effort to merge the pages only to then free them. It might be in
the noise though. Do you think this approach is better than what I suggest
above? If so, I'll have a go.

> 
> Since your example is 1) allocate a non compound high order page,
> 2) split_page(). The above approach is doing the reverse steps.
> Does your example represent the actual use cases?

Yes; vmalloc() will allocate the highest orders it can then call split_page()
because there are vmalloc memory users that expect to be able to manipulat the
memory as order-0 pages.

Thanks,
Ryan

> 
> 
> Best Regards,
> Yan, Zi


