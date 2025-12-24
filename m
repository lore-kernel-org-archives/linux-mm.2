Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA663E74913
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21AE6B0005; Wed, 24 Dec 2025 00:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF3F6B0088; Wed, 24 Dec 2025 00:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2296B008A; Wed, 24 Dec 2025 00:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5926B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:05:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4331C1630
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:05:15 +0000 (UTC)
X-FDA: 84253175790.03.8879E98
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id E175F20005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:05:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766552714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MkixSAhRxEVhX5M563rXharhRiWWamTV8SfoJKxI6V4=;
	b=GnJAZ0HZbohnNkfh/u90pUvg+XnZueuMNFgee8ni9ItdY7a0wc8IGk+s+JYD8tZ0X3O8Gu
	5swetLrYjxqrZ13Er3psnSGAhjbVNYF26Dv3+fzhaZmaIYj/R+Cngehzguq0KvzY8XJ2k3
	mS+916JtWO4vUIxY+GZyl+f5uoGYG94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766552714; a=rsa-sha256;
	cv=none;
	b=3zi/oGHKUSjr/LSKYN/zW/p2Sn5oV8MA4zbLtrqMhdvA2hIYcrbjL1F8j/+XVqDsEo9Dh6
	OilgQafTEOihlADxrfXo6dm62PTEPk1SuiciktzwfsShpb8mYMBxkEL320SiymncNsp7Cp
	zlNaK1TjbRiDdW/rf6V0cKZCj/RFiiI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD602339;
	Tue, 23 Dec 2025 21:05:05 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 830543F73F;
	Tue, 23 Dec 2025 21:05:07 -0800 (PST)
Message-ID: <19e28edb-87b1-4e4d-accc-2219f717aa51@arm.com>
Date: Wed, 24 Dec 2025 10:35:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND RFC PATCH 1/2] mm/vmalloc: Do not align size to huge size
To: Uladzislau Rezki <urezki@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 shijie@os.amperecomputing.com, yang@os.amperecomputing.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, npiggin@gmail.com, willy@infradead.org,
 david@kernel.org, ziy@nvidia.com
References: <20251212042701.71993-1-dev.jain@arm.com>
 <20251212042701.71993-2-dev.jain@arm.com> <aUkv51yk8lgzW9jv@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aUkv51yk8lgzW9jv@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yr6cczisyuwwmfxw9d1fxt1pt7ewm568
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E175F20005
X-Rspam-User: 
X-HE-Tag: 1766552713-250122
X-HE-Meta: U2FsdGVkX1/3I/rWymqaHv4rGPuYPC3cD2YFxpdt4qIgXJY4mzZBnUw6AK0PJSWoAyBkzHd+U2+3QIYiPS96gm3Gu/jCQIxXVFbKqYQupi4xzDJwQspuJFjF+oZA/lLm1WfEdQeVUgFZUc4skyZkDOZobsVeJ7asEIZ8xQe2FSNGZHcW3sk6kC69MppoJpyBBE72pe2OjYX/YIrAd9pdG+9GymuK+C5bm4K7g6bRhqzL6uWlC1qebgExdNuqlEN7OkGBNZTtTCQmujLS3fuVu9Ajsr7QicFjukQHKqlgD8BocCUZ4hoq5vkjy52Rm6S6L6fPQyf5HEWrbKmQNaEG0iuF/61cLRMiFbjR6ozLfj7bNrLRyFvLbyHPhO/b0Fx4stT2IbMTNIXf9jORdh0bLTU8NHSdZ2w4YoACSoK3JcZjDl+agpqGesuiIh5gYrVCCnodrWaQqBGA91L9y+6EE8q0ERUXhzgO5TT1Rjt8IcA2/dHifwy7fFL0Nw5KXlCFbnyH/Qww2VbDLf9yWbhDA+cdNC//KID+2rsukjuAkt/TZDyDdrhGYuGoMWP+yECw/U6NEX+wDf6pHCsrveMtenz14j8cHQ2GLt3YoWxN1XDLfj17LceiIFMRcXlusuN5lUpOOEiPlNb2XWXz1aaKZMtxWQiLDXjbnL8qxR9W7vKSyXOIahuFHH6BRdNgfR4aH1Bug94tv18IR0JKZ9YQcooO/mjNUpRztRsWU206nrVZ+tHEMaJVHhioLvAGOIn3bJO9wxTdYAYXzuo4SBeXlAPF8XcxcUieia6uSMP7sXshNTsK1BR0Z6sbgAklr9atSUGlUNsMe5/9H/98MVY4BoS7KUtZmpf2gv0cTvTJnQ4y41KuFAAM8ESqG6Lmm93sF1i2EDwcIOn4/b9TIyoF8FR+6wT7HJdDk0OJZxzDyZoH2RhlR6Elsk+l9kMgo3JbRasdrRwOD3Xgp3Fza62
 z0ndUsSh
 b6ImaE4ZrYPmGAaUGehFso7DADrAxN9jiZ+g8fE8gaXX9HMD7ph0dA9D5f3xdEjocCI5inklYy8FN67/k0+RBKqVsTLwKesL4BsUC/hBNyxJgtKe8oddSZ6JBHNpSkVwqpsR4LREIvRga6w65HadF+Q6LF3MQOuC9O5ogUUzIe0O5yydTSBT6KkusV6XHukrfzj2hS0h1VCOaErU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/12/25 5:17 pm, Uladzislau Rezki wrote:
> On Fri, Dec 12, 2025 at 09:57:00AM +0530, Dev Jain wrote:
>> vmalloc() consists of the following:
>>
>> (1) find empty space in the vmalloc space -> (2) get physical pages from
>> the buddy system -> (3) map the pages into the pagetable.
>>
>> It turns out that the cost of (1) and (3) is pretty insignificant. Hence,
>> the cost of vmalloc becomes highly sensitive to physical memory allocation
>> time.
>>
>> Currently, if we decide to use huge mappings, apart from aligning the start
>> of the target vm_struct region to the huge-alignment, we also align the
>> size. This does not seem to produce any benefit (apart from simplification
>> of the code), and there is a clear disadvantage - as mentioned above, the
>> main cost of vmalloc comes from its interaction with the buddy system, and
>> thus requesting more memory than was requested by the caller is suboptimal
>> and unnecessary.
>>
>> This change is also motivated due to the next patch ("arm64/mm: Enable
>> vmalloc-huge by default"). Suppose that some user of vmalloc maps 17 pages,
>> uses that mapping for an extremely short time, and vfree's it. That patch,
>> without this patch, on arm64 will ultimately map 16 * 2 = 32 pages in a
>> contiguous way. Since the mapping is used for a very short time, it is
>> likely that the extra cost of mapping 15 pages defeats any benefit from
>> reduced TLB pressure, and regresses that code path. 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/vmalloc.c | 38 ++++++++++++++++++++++++++++++--------
>>  1 file changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index ecbac900c35f..389225a6f7ef 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -654,7 +654,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>>  {
>> -	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>> +	unsigned int i, step, nr = (end - addr) >> PAGE_SHIFT;
>>  
>>  	WARN_ON(page_shift < PAGE_SHIFT);
>>  
>> @@ -662,7 +662,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>  			page_shift == PAGE_SHIFT)
>>  		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>>  
>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> +	step = 1U << (page_shift - PAGE_SHIFT);
>> +	for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
>>  		int err;
>>  
>>  		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>> @@ -673,8 +674,9 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>  
>>  		addr += 1UL << page_shift;
>>  	}
>> -
>> -	return 0;
>> +	if (IS_ALIGNED(nr, step))
>> +		return 0;
>> +	return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
>>  }
>>  
> Can we improve the readability?
>
> <snip>
> index 25a4178188ee..14ca019b57af 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -655,6 +655,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>                 pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
>         unsigned int i, step, nr = (end - addr) >> PAGE_SHIFT;
> +       unsigned int nr_aligned;
> +       unsigned long chunk_size;
>
>         WARN_ON(page_shift < PAGE_SHIFT);
>
> @@ -662,20 +664,24 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>                         page_shift == PAGE_SHIFT)
>                 return vmap_small_pages_range_noflush(addr, end, prot, pages);
>
> -       step = 1U << (page_shift - PAGE_SHIFT);
> -       for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
> -               int err;
> +       step = 1U << (page_shift - PAGE_SHIFT); /* small pages per huge chunk. */
> +       nr_aligned = ALIGN_DOWN(nr, step);
> +       chunk_size = 1UL << page_shift;
>
> -               err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> +       for (i = 0; i < nr_aligned; i += step) {
> +               int err = vmap_range_noflush(addr, addr + chunk_size,
>                                         page_to_phys(pages[i]), prot,
>                                         page_shift);
>                 if (err)
>                         return err;
>
> -               addr += 1UL << page_shift;
> +               addr += chunk_size;
>         }
> -       if (IS_ALIGNED(nr, step))
> +
> +       if (i == nr)
>                 return 0;
> +
> +       /* Map the tail using small pages. */
>         return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
>  }
> <snip>

Indeed I can do this.

>
>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -3197,7 +3199,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>>  	unsigned long requested_size = size;
>>  
>>  	BUG_ON(in_interrupt());
>> -	size = ALIGN(size, 1ul << shift);
>> +	size = PAGE_ALIGN(size);
>>  	if (unlikely(!size))
>>  		return NULL;
>>  
>> @@ -3353,7 +3355,7 @@ static void vm_reset_perms(struct vm_struct *area)
>>  	 * Find the start and end range of the direct mappings to make sure that
>>  	 * the vm_unmap_aliases() flush includes the direct map.
>>  	 */
>> -	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
>> +	for (i = 0; i < ALIGN_DOWN(area->nr_pages, 1U << page_order); i += (1U << page_order)) {
>>
> nr_blocks?
>
>>  		unsigned long addr = (unsigned long)page_address(area->pages[i]);
>>  
>>  		if (addr) {
>> @@ -3365,6 +3367,18 @@ static void vm_reset_perms(struct vm_struct *area)
>>  			flush_dmap = 1;
>>  		}
>>  	}
>> +	for (; i < area->nr_pages; ++i) {
>> +		unsigned long addr = (unsigned long)page_address(area->pages[i]);
>> +
>> +		if (addr) {
>> +			unsigned long page_size;
>> +
>> +			page_size = PAGE_SIZE;
>> +			start = min(addr, start);
>> +			end = max(addr + page_size, end);
>> +			flush_dmap = 1;
>> +		}
>> +	}
>>  
>>  	/*
>>  	 * Set direct map to something invalid so that it won't be cached if
>> @@ -3673,6 +3687,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>>  	 * more permissive.
>>  	 */
>>  	if (!order) {
>> +single_page:
>>  		while (nr_allocated < nr_pages) {
>>  			unsigned int nr, nr_pages_request;
>>  
>> @@ -3704,13 +3719,18 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>>  			 * If zero or pages were obtained partly,
>>  			 * fallback to a single page allocator.
>>  			 */
>> -			if (nr != nr_pages_request)
>> +			if (nr != nr_pages_request) {
>> +				order = 0;
>>  				break;
>> +			}
>>  		}
>>  	}
>>  
>>  	/* High-order pages or fallback path if "bulk" fails. */
>>  	while (nr_allocated < nr_pages) {
>> +		if (nr_pages - nr_allocated < (1UL << order)) {
>> +			goto single_page;
>> +		}
>>  		if (!(gfp & __GFP_NOFAIL) && fatal_signal_pending(current))
>>  			break;
>>
> Yes, it requires more attention. That "goto single_page" should be
> eliminated, IMO. We should not jump between blocks, logically the
> single_page belongs to "order-0 alloc path".
>
> Probably it requires more refactoring to simplify it.

I can think about refactoring this.

>
>>  
>> @@ -5179,7 +5199,9 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>>  
>>  	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>>  
>> -	for (nr = 0; nr < v->nr_pages; nr += step)
>> +	for (nr = 0; nr < ALIGN_DOWN(v->nr_pages, step); nr += step)
>> +		counters[page_to_nid(v->pages[nr])] += step;
>> +	for (; nr < v->nr_pages; ++nr)
>>  		counters[page_to_nid(v->pages[nr])] += step;
>>
> Can we fit it into one loop? Last tail loop continuous adding step?

I don't see any other way.

>
> --
> Uladzislau Rezki

