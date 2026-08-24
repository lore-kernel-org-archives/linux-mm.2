Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0599CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076716B0096; Mon, 24 Aug 2026 07:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026CD6B0099; Mon, 24 Aug 2026 07:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80256B009B; Mon, 24 Aug 2026 07:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFA646B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:10:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5607C1204A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:10:08 +0000 (UTC)
X-FDA: 85135893696.01.DEDC50E
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1396A180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:10:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EzyOSCUQ;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787569806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXWBt/ALPMpEd76o9QhClkprgZubHF3CQiskIy8Laog=;
	b=snycO20wn6fKiF/dJv64/dTEFRlgQUE4CrlQHa9IuN6vhGCD/dcCsWINL5CSqg9lIetTUc
	jya+cRYrL44TApeYU5GNgRtP+AiBL+6VFcZnbeI0y4NZA0FI5Gc8XQQsdRZ9R1uU7aIVGM
	N6izwtQK7kx4cGrUf+kTYmwOyo7H3OI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EzyOSCUQ;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787569806;
	b=dbuKVh7NbiK7kisXMnY+NvIB/yTYMHb7IGhK90PN995WXS+EHq6CXxgLAm+xBbzoO/9LRQ
	9G/4THe7kOvHJBzCpYRdbV3+nJeins3IBezYQtStDz+W5lJSCQ+Ntd463vCeQLNWHHBC4i
	q6eyeiH+L/OVWc5yhCqjYU9tB8P2q7g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MLoHlZQykALuphN6lnBx1ivPtGHUFJ0fv7fJkVRd95E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787569804; v=1; x=1788174604;
 b=EzyOSCUQpaFtXFd3pa/3J36wjPwKSd3ccFmd76ctK8rqjTQpID7ryHZeOvouhZK+wm3XZFAd
 MwLUTd5E4B1wGekW9ZMm7wini0WeJjBPNAb0CUFOpUi0bFZf6aJRsvy8G8KuAxKEHoR4LXYpav2
 /eSwIdRb9JTllmuE0BhFH1LA=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.67.158.60] (114.251.196.91)
	by smtp.migadu.com with ESMTPS id b9a820b2082c8157;
	Mon, 24 Aug 2026 11:09:54 +0000
X-Mizu-Trace-ID: b9a820b2082c8157
X-Migadu-Flow: FLOW_OUT
Message-ID: <cde94ead-445e-45bd-88b0-ac64b3ed6ace@linux.dev>
Date: Mon, 24 Aug 2026 19:09:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/17] mm/sparse-vmemmap: support section-based vmemmap
 optimization
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-9-songmuchun@bytedance.com>
 <178756196750.3606540.8562704442052486227.b4-review@b4>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178756196750.3606540.8562704442052486227.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1396A180009
X-Stat-Signature: tpakiyd8mdk4r5s6erdajnjntepodjib
X-Rspam-User: 
X-HE-Tag: 1787569805-571003
X-HE-Meta: U2FsdGVkX19OtwhHPt6W0g9+HBoyPTLpue+mbmoZinQ+0noNPC0TFxZ5FiIpREBhqJ15CgxjtF868f809mrp4TZVvXAXQJ4rWjK61Djf/dPtdxbNwRqfyjekth8hS6nuWb7KUVd6mlgyZpZXWC8mQeN2IZc7ZCFVhsIaIT8PbLL/Yb3fyEU5PwCQsEkeN9k+K5TWBc+7xtwCgwsl51PRDeWOB0fG+lnlFU0OelwqHPnmGJHpwHYVXJ+hYfKtMrEtRCa9fYUK8wBxx1zP9vhYTKHXCeiEqEC/+287/JqEUaubt2kDWCxkvjqoYCriDG9uh4g7YsEaVbrVPNXkO+uQatXTtt7zMM5WE7Y7kXoE6sgCYAGGUnJDpgdCjXKy6b3PvImlxZTGG8nE/X3ScISW0tDfMcAqm8Bn3kryaij2lzSzrC7QpPImRo3A9vGJaFnIKyHT+DnQoi1Iw98BmiWS4h89/PpH5eGLwaMwgENNsI8aab66gqQ26fAW27aUh4jBEFb903/ly+g02xha1WwjZjKkP4YhSJqVobM2Y+Uv+npoSyow6p6szIMEZ05ea7K+bgC2HVnT7pA8oq9CHnaO48emiX/JGWdd2EwJLlyr4O0t51JTOP6xagMfWst6mipBz+0r1S60P31fu6mnMyxu7T/O+we2hNCb+chZNENRsrIwOeRokpWTM+AmFyI+KPjze/LP+T6hP1kxzIZObgX0y2C+b9r5blyEzhedE1PMrEbrs8Sk39b9RQYnM/qH8E7wnClwvoRMoh5/s8U1uXFE2BTSDX4FGkBDOYLQbs7d/S2zxA8J5fCcF2eeuOhqq0lbep1YJMvKYY/5wN5lizyIF5w5Rd4fPsHRv3wI4bTsLHhc2XLf672IZ8MqnVR2QKsWQ0NFo/p5flyG1obFZOlAN7XhuWnd43zG6XpHIB6eo+rsv2urkOzTsnyoHmtGYyS1Cl8j3U1E4QsiBeV2Tyy
 pkQHsyq3
 /4x3xyWcklZak7ZliRrsjl9lndj5fXURBx16T4LjE3lP+nW1luPevpqZbeJYoGf2PRBqgEWB8dNQQvwLJjQmk0NgG86f99f7jjWnB/Bj2TvRQtG+1xVcsiQ7NVXmzkSL2QwqHwH76YRsGxBNYSaTlKGOzLbsqUvvL2hwKopDZzJXWFzbKz3BxucCQx/rQ/OrLnRxuDhnrViR1H7WLGF94bRClrxDpzKXdfID5g26pLGjURfN4a+SqbFlgCd7WvbAT7H9Qc54+qk/b/llx7AcGbjYB6KVyw6UgjadbTEJs8zCM5SqHvWk0sCsd1fQjE/z2EHSLICwCwqx4C10djXGbZVIQ1+a7LUNog0IULTdu7f44LpVtjRF3LOq9CzNhJOfD6+n2V0ULjvmt0bOx7JzZfVCSeR+OoWGAF3V4NsEbDtb1zaPZlgeyywDf0ojuopIj13eG4XA/mCCNXyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/24 16:59, Mike Rapoport wrote:
>> Teach sparse-vmemmap population code to use the compound page order
>> when deciding whether a vmemmap page can be optimized.
>>
>> With this information, the common sparse-vmemmap population path can
>> allocate or reuse shared tail vmemmap pages directly instead of relying
>> on HugeTLB-specific handling.
>>
>> This centralizes vmemmap optimization logic in the sparse-vmemmap code,
>> based on section metadata, and prepares for sharing the same mechanism
>> across different users of vmemmap optimization, including HugeTLB and
>> DAX.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index b770fe2428fd..737d50bdd3ef 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -186,6 +186,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
>>   
>>   	return tail;
>>   }
>> +#else
>> +static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
>> +{
>> +	return NULL;
>> +}
>>   #endif
>>   
>>   static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>> @@ -193,12 +198,24 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>>   				       unsigned long ptpfn, unsigned long flags)
>>   {
>>   	pte_t *pte = pte_offset_kernel(pmd, addr);
>> +	unsigned long pfn = page_to_pfn((struct page *)addr);
>> +
>>   	if (pte_none(ptep_get(pte))) {
>>   		pte_t entry;
>> -		void *p;
>> +
>> +		if (vmemmap_optimizable_pfn(pfn) && ptpfn == (unsigned long)-1) {
>> +			unsigned int order = pfn_to_section_order(pfn);
>> +			struct zone *zone = pfn_to_zone(pfn, node);
>> +			struct page *page = vmemmap_get_tail(order, zone);
>> +
>> +			if (!page)
>> +				return NULL;
>> +			ptpfn = page_to_pfn(page);
>> +		}
>>   
>>   		if (ptpfn == (unsigned long)-1) {
>> -			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>> +			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>> +
> What do you think about adding a helper function here, e.g something
> like

Better than mine. More clear.

>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 0aa0ab4f8b11..933b122f9937 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -191,6 +191,23 @@ static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zon
>   }
>   #endif
>   
> +static void * __meminit vmemmap_alloc_pte(unsigned long pfn, int node,
> +					  struct vmem_altmap *altmap)
> +{
> +	unsigned int order = pfn_to_section_order(pfn);
> +	struct zone *zone = pfn_to_zone(pfn, node);
> +	struct page *page;
> +
> +	if (!vmemmap_optimizable_pfn(pfn))
> +		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +
> +	page = vmemmap_get_tail(order, zone);
> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>   static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>   				       struct vmem_altmap *altmap,
>   				       unsigned long ptpfn, unsigned long flags)
> @@ -201,19 +218,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   	if (pte_none(ptep_get(pte))) {
>   		pte_t entry;
>   
> -		if (vmemmap_optimizable_pfn(pfn) && ptpfn == (unsigned long)-1) {
> -			unsigned int order = pfn_to_section_order(pfn);
> -			struct zone *zone = pfn_to_zone(pfn, node);
> -			struct page *page = vmemmap_get_tail(order, zone);
> -
> -			if (!page)
> -				return NULL;
> -			ptpfn = page_to_pfn(page);
> -		}
> -
>   		if (ptpfn == (unsigned long)-1) {
> -			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> -
> +			void *p = vmemmap_alloc_pte(pfn, node, altmap);
>   			if (!p)
>   				return NULL;
>   			ptpfn = PHYS_PFN(__pa(p));
>
>>   			if (!p)
>>   				return NULL;
>>   			ptpfn = PHYS_PFN(__pa(p));
>> @@ -217,7 +234,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>>   		}
>>   		entry = pfn_pte(ptpfn, PAGE_KERNEL);
>>   		set_pte_at(&init_mm, addr, pte, entry);
>> -	}
>> +	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
>> +		return NULL;
>>   	return pte;
>>   }
>>   
>> @@ -406,6 +424,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>   	pmd_t *pmd;
>>   
>>   	for (addr = start; addr < end; addr = next) {
>> +		unsigned long pfn = page_to_pfn((struct page *)addr);
>> +		const struct mem_section *ms = __pfn_to_section(pfn);
>> +
>>   		next = pmd_addr_end(addr, end);
>>   
>>   		pgd = vmemmap_pgd_populate(addr, node);
>> @@ -421,7 +442,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>   			return -ENOMEM;
>>   
>>   		pmd = pmd_offset(pud, addr);
>> -		if (pmd_none(pmdp_get(pmd))) {
>> +		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
>>   			void *p;
>>   
>>   			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
>> @@ -439,8 +460,11 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>   				 */
>>   				return -ENOMEM;
>>   			}
>> -		} else if (vmemmap_check_pmd(pmd, node, addr, next))
>> +		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
>> +			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
>> +				return -EOPNOTSUPP;
>>   			continue;
>> +		}
>>   		if (vmemmap_populate_basepages(addr, next, node, altmap))
>>   			return -ENOMEM;
>>   	}
>> @@ -620,6 +644,33 @@ void __init sparse_init_subsection_map(void)
>>   		sparse_init_subsection_map_range(start, end - start);
>>   }
>>   
>> +int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
>> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> +{
> Can we do all code movements in separate patches?

Yes.

> Maybe even move this to the previous patch and update the changelog to
> say "move code around in preparation ..."

Make sense. Will do next version.

Muchun,
Thanks.


