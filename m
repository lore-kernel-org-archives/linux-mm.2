Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A271C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934316B007B; Wed,  5 Aug 2026 23:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E54B6B008A; Wed,  5 Aug 2026 23:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC806B0093; Wed,  5 Aug 2026 23:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFD6B6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:04:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E94FCA054C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:04:47 +0000 (UTC)
X-FDA: 85069352214.11.F39DC5A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9BFB3A0013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:04:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ImvMNWEs;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785985486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeFhF0M/SpcuVTAHQU+II4MEXYOvkh6h/IJxQ8sqVSw=;
	b=mprEj6J/loeeZtcarkUD3gw12nepblh8ENejHtIYrI6S61FORJk/dOMS5W3oVrTLDh+33K
	e3+xgQK9mk9yjCeCmtHeAAClDxWwesUv1kKJFDL7aElXT94Le612oBXcqbcVH7XvZu3dxz
	KhsMghLvbH0yd8M28QacvW1Yz8weOyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785985486;
	b=VEM3kRE8bHeCfDLilQUioN7YoCca7n0fhF3Lch4SXG6N+BmZGIGkCTe95Osnl9snPzVr5B
	bLyhhe3Hw++lPUG7RDU9j4E6SnxHWSDVAgSfhUvpFmXxurIoO1NX9YAB7Guk63oX+hV+vM
	mg3kxim1qGWsClMIDSNOeO2tyrZxNXc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ImvMNWEs;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <978060e0-a202-43b2-b84d-b1950b2d28c1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785985483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PeFhF0M/SpcuVTAHQU+II4MEXYOvkh6h/IJxQ8sqVSw=;
	b=ImvMNWEstqKdQmDiFyQsqTUlMnWbcUta+OkPhlvxqCD+SYalu73/Onx13vnKMC8bh4lRLN
	XTnBHwGoWSFTRhTdiLxOjgynzrMfVXuciNDCyVl4OQbDjmnaii4lRyYodZex+Oa/wojb2j
	eD+eU36NpVL08kXcswYlYOHBxe+cv84=
Date: Thu, 6 Aug 2026 11:04:35 +0800
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
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: roqom5ewgnk8oyd6au4gjca7kc4caggn
X-Rspamd-Queue-Id: 9BFB3A0013
X-HE-Tag: 1785985485-841131
X-HE-Meta: U2FsdGVkX1/zg4St+6GLWzz8aVhL2f3seZjDaV12acoF4IYw+OcIQ1tSxOrkm840hUeNr+z7HYISVSUn2bgTrZMW4ISIHp3Ys+VnZyUTmffPP7c/pUdojmkzCWX+hDcPA+63pHp6pZ79I0mjF/wZnH3BYM6PiD5PHQFzk8t0NVtyKuRBw4k4Q4xA+lf5Bt8eqkirmt/M+Q/tDYOPg+t4wU1W9m8tPTZETgQh07vJgGHoqFuEKvD5aGFa1DNwgvQGopSQyQ2R/z+2wxZAuq2Gm/pLraTScmjrCE+oEjbD0vmqPGh9Tj6p1rmtXXCOvKRf1bbRXDUJxkXlQz3Y8FYEYZSPOz5L4+zEtwSS6BiPqRlcPVTkikRPyVIdGgpbOXszECLWDcK2bPuerB4pj47DN/n5ITPlPo4o4rEF/cfGednfMaZj2BttprdqVQokD42iZ7x6jL0aLzvHjWr+bGmrxAmSk2id/4wBDNMg4gZiEu+2EwOEv4W9TC020ksOoreHMBK3fAPYGEAxCD6M26VHKLNCC7UwhT3qhS63PeVijISw7D0OwiUX0uf9iuO2whYWQ60CmYo7t1LA7C/agcX2PZoM3CwzxR3C5d3jVTIiolvjEDFhFLUNLrApNixVyA6mM5VTh4An12aV54vy02BHbSKfJUnq1MyLhff1qJdfuoXN3Hj0GMKzt6jcXYvGun9lpTy8PBshRwu4cATRAztwRSlRTr3H6inrEaRIpNhM9dXhX3WhwXUDhFmgInY2zCYUcO9QYiV+5wzQxRDwyA4ZA2PjzFkJSweRa7Vj0odxe51pOoTzgioNcSOYuP+xLrFA5XD9mCsr/XfchZ2BSC9PFnehzyw6c/HRi/pd25sE9ykShpdgbC+trdmCh7gfDGOgzL0jvrstZvBiolS6rH0F32b7ukTHXZlaj4IXw18HvKi5qgn1XKHo7nZC3fqcIUK+ftISZ+GPCyI51kjtHnI
 OSDNZ7tZ
 /uItn0jXVWoShdTlaqoTJbiYKNEYBr3rwGvL+KGrGEbwXxAb5Kf8u8yh2jjlfN7J/k35P6mTp3hbMmGADmo9WeKtvffSmvDzYmcWkrjxllzUQpr/k4VK8epCuoBDqtmD7JQNh+nQpPLQ6NreOlRGnPVB0gXe02uOB/aMOwiEqc6u10w8M3jTx66iJUZD+dQu0Cw+k/N0rAdFRUYiTVm1vWt/jontIyYBRAxjdimkkEKimUdQMQpuRnXVUYCZWXoz7wFZ5urdQ/s2nx4DelDYGC+OBQLrbMyIdi4//CiO29Vy29/feZGevRfvp5s/jN9WvJm+e14TpnHD8cuF3gnBVyoBJczb92ayff5Sp
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

The kernel test robot reported a compilation issue: when
CONFIG_MEMORY_HOTPLUG = n && CONFIG_SPARSEMEM_VMEMMAP=y,
section_nr_vmemmap_pages is undefined. This problem is easy to fix, and
I will move the entire function outside the CONFIG_MEMORY_HOTPLUG guard
in the next version.

Thanks.

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


