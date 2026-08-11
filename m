Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E3BC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44A96B0092; Mon, 10 Aug 2026 23:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE036B0093; Mon, 10 Aug 2026 23:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8963A6B0099; Mon, 10 Aug 2026 23:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57C096B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:54:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA5AF1402FF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:54:53 +0000 (UTC)
X-FDA: 85087622466.17.42DD10A
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 519FAC0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:54:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w1A4cF1f;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786420491;
	b=mlOiQTKHG5NbetOwp7mrqlpxuQHwpEAMmLnKjRiqtS36yAHqcnVQ0x2v9UoKHsZ3IKteOu
	7Ch98uLBEwGGn+/rSx2Hh2vkVEselWFQGvnaY43dj0EasjvRBmEVXInSpBiy+QBu0mQs3o
	ALAz/X1izhYPxjgCwxXsK7rsYqSZeT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w1A4cF1f;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786420491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h++gKGUxf7+qc/liRn7LTfNJx/qIABDK+t8W5xxWiqI=;
	b=iZ8EBJjJKP7Ev0AFlWY+ZmGf7n8BAbWvrHmdhIez8q6bY26PGlbJpbvUFvtkq/pbodDewZ
	gZKON0BwKsrlu/tOrY+PDPHcqk+M8vyH54Zfe+KqkDGMsN63iBA/srNakfvBmCY+nxjy3L
	iSMzWWHSBMk6qIgI3mgJvtw3NGSshCU=
Message-ID: <ed3f653b-ad13-40a2-831f-74e810437d98@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786420487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h++gKGUxf7+qc/liRn7LTfNJx/qIABDK+t8W5xxWiqI=;
	b=w1A4cF1fo1wuCLEDnWwOvUX8Brrb9eDy8QF62ZlGufZEhxztIDXs0/opGTTLX9RkjYKfcU
	bHdGYTKJz2NneJQPyuA/YnHt/p9jJQLrk9JoRn5gjb8GAI61KQsya7Ezw0f0/1xBms2N+G
	SolTLaj+oIgqbnTe6GNIdauh64sokfI=
Date: Tue, 11 Aug 2026 11:54:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 08/17] mm/sparse-vmemmap: support section-based vmemmap
 optimization
To: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
 <20260804035535.2846016-9-songmuchun@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260804035535.2846016-9-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 519FAC0006
X-Stat-Signature: r1hunb1b7di41qo4gf8spm7kusnjtuy3
X-Rspam-User: 
X-HE-Tag: 1786420489-942044
X-HE-Meta: U2FsdGVkX1/9vFCNJb7RfRgmHZmvvVioamgRXKHYRoNOmGxHpjxQcwF2dF/XqO0l0Lqw6im/CEEaZ79JTTP5Va3Uih4OL5FrdEQYVyosqPxMFzDjmh+wpMlyM8XcXZPkx+4aAwrWm/qvqDVO2Wv8DhT6wY0PKwGkpTgS0SsuY4s9sLSWMjVheAqkqGHIakFpjtu0mloKdGxdKUpH0TMfo0Z2ZZajrKzcbi2NHKep46nEzbyZTtYhNywlEGref41GIcO8RWitnlURILy4zsDuJoWOzOLQ9/awvv5VeKQx8Yrc0H1RlSD91q6Pl39sLzrgnW3rJOQBhE2pLUID8ykREj9ruOBrGaf6Are7Z/L5qxJsjHSjH0zWR7WdHMt7clN4woQQmFLca5DmEyDTUP3Ka5PfPqToa5oQw7IMQHYMWjZi0qr2gruvzAZpPLZCQ5Eorr0rv/Yzqaw7oaAI0fbjCn5P2j5gr/nfhmJW8xv7FUL9XzlbaiPCNrl627YDRns8vjn9zUSNgOrPGxROpXPih5Ewj9fsK/zj9+pMcL9S+OCfXfgbuPOz/F6QY69hedfh2e3leJoXBP9GQ8MdKim7t/nzXBxRldXI0TwNKOXgiotXNpXyW31ucWlR5K3ic1QT3P4bV+Fniwd1TWToWOBTQKit+R4KNSnX2eet/W6r6nMh8TAvBFIldBgJ7HiNk0G6DFEZTMPK1fDp50m30s48QjXFOZ+YLSnH65ft7qkGnFty/7q+3s16dAWtpNJjsh47FiIPQN9zO5B2KcrkLlTZ/zGTW/v1YwxSy3528xDBXezaccs4HErD6dmP1FfPjWtsiI5q5G5aAE7TTSpb+xzOWTEBrJXSrRbZsjPl243I9+0O1FsCSqamXHGqQ1YUN/zqZqQgp1OH0jtrCGrR+miJKwU6ypKhB8OnGzP+t7bWh86LNYhzJXYrjuxBlANh5poqVwdND2N1/FBsZR3r7GY
 KhhHZ65G
 FZBEVhABmjcZkg0Ud9ai/T8S5CLtLzgJw5ke8Or1s7oK2KCtyx4CdzDrhiaXefZue92oDpBlso56zp0gQD1IfVp/d+rFO7qnWB2D9WsI4SXGvuuFRxMfsVPqf+MJoBzKcZ/+oNmUe+utR09IS9KG/31gwqpTcS4L+3Ws64G6k1qFM76s6KQzDNoMjVtV+XRYUtsa1as5rCwzyyBXYEu0X7zD0TTaEywxytEbausyV8JdrTExTMfHkSrc5CnZThxoTIY1WMmggMc1OyhZSDfrieTKBC2Q3PA04CVxoKkkw0cg++8Rg1P1WqEfFFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/4 11:55, Muchun Song wrote:
> Teach sparse-vmemmap population code to use the compound page order
> when deciding whether a vmemmap page can be optimized.
>
> With this information, the common sparse-vmemmap population path can
> allocate or reuse shared tail vmemmap pages directly instead of relying
> on HugeTLB-specific handling.
>
> This centralizes vmemmap optimization logic in the sparse-vmemmap code,
> based on section metadata, and prepares for sharing the same mechanism
> across different users of vmemmap optimization, including HugeTLB and
> DAX.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Keep vmemmap accounting and population logic in sparse-vmemmap.c
>    (suggested by Mike Rapoport)
> - Move vmemmap_get_tail() before its first use instead of adding only a
>    forward declaration in the previous patch (suggested by Mike Rapoport)
> - Simplify the PMD path handling for HVO-covered sections
> ---
>   mm/sparse-vmemmap.c | 36 ++++++++++++++++++++++++++++++------
>   mm/sparse.c         |  4 ++--
>   mm/sparse.h         |  7 +++++++
>   3 files changed, 39 insertions(+), 8 deletions(-)
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index b770fe2428fd..b69a7af76858 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -186,6 +186,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
>   
>   	return tail;
>   }

Sashiko said there is a data race for store to zone->vmemmap_tails[idx]
between hugetlb_vmemmap.c and here. This is another false positive. There
couldn't be any concurrency during system startup, and after startup,
since HVO cannot be applied via memory hotplug at this time, there isn't
any either.

The other two reports are also based on issues that occur during the memory
hotplug phase, so they are false positives as well.

Muchun,
Thanks.
> +#else
> +static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
> +{
> +	return NULL;
> +}
>   #endif
>   
>   static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> @@ -193,12 +198,24 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   				       unsigned long ptpfn, unsigned long flags)
>   {
>   	pte_t *pte = pte_offset_kernel(pmd, addr);
> +	unsigned long pfn = page_to_pfn((struct page *)addr);
> +
>   	if (pte_none(ptep_get(pte))) {
>   		pte_t entry;
> -		void *p;
> +
> +		if (pfn_vmemmap_optimizable(pfn) && ptpfn == (unsigned long)-1) {
> +			unsigned int order = pfn_to_section_order(pfn);
> +			struct zone *zone = pfn_to_zone(pfn, node);
> +			struct page *page = vmemmap_get_tail(order, zone);
> +
> +			if (!page)
> +				return NULL;
> +			ptpfn = page_to_pfn(page);
> +		}
>   
>   		if (ptpfn == (unsigned long)-1) {
> -			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +
>   			if (!p)
>   				return NULL;
>   			ptpfn = PHYS_PFN(__pa(p));
> @@ -217,7 +234,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   		}
>   		entry = pfn_pte(ptpfn, PAGE_KERNEL);
>   		set_pte_at(&init_mm, addr, pte, entry);
> -	}
> +	} else if (WARN_ON_ONCE(pfn_vmemmap_optimizable(pfn)))
> +		return NULL;
>   	return pte;
>   }
>   
> @@ -406,6 +424,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>   	pmd_t *pmd;
>   
>   	for (addr = start; addr < end; addr = next) {
> +		unsigned long pfn = page_to_pfn((struct page *)addr);
> +		const struct mem_section *ms = __pfn_to_section(pfn);
> +
>   		next = pmd_addr_end(addr, end);
>   
>   		pgd = vmemmap_pgd_populate(addr, node);
> @@ -421,7 +442,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>   			return -ENOMEM;
>   
>   		pmd = pmd_offset(pud, addr);
> -		if (pmd_none(pmdp_get(pmd))) {
> +		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
>   			void *p;
>   
>   			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
> @@ -439,8 +460,11 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>   				 */
>   				return -ENOMEM;
>   			}
> -		} else if (vmemmap_check_pmd(pmd, node, addr, next))
> +		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
> +			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
> +				return -ENOTSUPP;
>   			continue;
> +		}
>   		if (vmemmap_populate_basepages(addr, next, node, altmap))
>   			return -ENOMEM;
>   	}
> @@ -648,7 +672,7 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>   	}
>   }
>   
> -static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
>   		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>   {
>   	const struct mem_section *ms = __pfn_to_section(pfn);
> diff --git a/mm/sparse.c b/mm/sparse.c
> index ca9875f568d3..24555a32a5d9 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -315,8 +315,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>   							nid, NULL, NULL);
>   			if (!map)
>   				panic("Failed to allocate memmap for section %lu\n", pnum);
> -			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
> -							   PAGE_SIZE));
> +			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
> +								       NULL, NULL));
>   			sparse_init_early_section(nid, map, pnum, 0);
>   		}
>   	}
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 6ad190ec48cf..f8f852f9f8a2 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -105,8 +105,15 @@ static inline void sparse_init(void) {}
>    */
>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
>   void sparse_init_subsection_map(void);
> +int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
>   #else
>   static inline void sparse_init_subsection_map(void) {}
> +static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{
> +	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> +}
>   #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>   
>   #endif /* __MM_SPARSE_H */


