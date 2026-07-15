Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DE5C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC6D6B009B; Wed, 15 Jul 2026 01:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD626B009D; Wed, 15 Jul 2026 01:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3566B009E; Wed, 15 Jul 2026 01:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E78D76B009B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:09:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02C2DC0512
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:09:06 +0000 (UTC)
X-FDA: 84989831934.12.8ACE20F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4FAA220004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:09:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avbaHuBa;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784092145;
	b=kAeru+jrCXQIGpyHvpjNGFYbrxenYVmHrovvc6+LHgDdk5CKoRIu3pIyGHfQFeQvDdZ+wL
	6sOU1Ml/sbjrV3rrgRVxis75qSVGYUZUf6K/ZKIytDshfoSuIJKC3f4XIC5z1xRE2wMlt4
	RzUYTvsokH+cQM/KACd7cAmYCJkd5mQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avbaHuBa;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784092145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXsIe+s/izyZb3xk3q8kB8cuaxb7juXb0oxgCx96/dU=;
	b=nMFQaNeQCdAsSySkVH+piyEzBptXRu4AOB9X/rfYeyYaO7SVld8ZZFHuk0bEvCuY0NipIB
	8IDRy5eOynNDMh3Mq+ytwq9dWaWenDp0nY9KG3bfJAsl7r3Q0eexcVFa16geuvZ7hixYHi
	5UtAAp3wlFCkAeUahiqdzRptZCnWp5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE362601E0;
	Wed, 15 Jul 2026 05:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5591F000E9;
	Wed, 15 Jul 2026 05:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784092144;
	bh=sXsIe+s/izyZb3xk3q8kB8cuaxb7juXb0oxgCx96/dU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=avbaHuBagRYFZ0ED2jdwYoXj7vRg4EgdHjdkVEvOhgAZvCS279Egi79LBh3mNRM6t
	 OBpQKpY3ujj4v40peGnipOaBLQWPFNJFt5vqnBlCUg7WRK1ovqNB2g3ABRCYj/8nG8
	 SFuX67nTi1/H18O+d9OY9uPbmS6dPnBqbKT4z0CgxHAO7upFpqdEdn1B/nz5IGprRS
	 X218ZWPJLQUJP+izl6j+w9D6/AwvNGu0Btg0hRpwidVldQmcE0N1u39APOExEW3UyE
	 wG8xIdS9Hn8fZudZnCyR2ccFVUpjNrgKwB+OvyedaDoTfYuWudGC03NDaSKewMODci
	 5VCryPKzkG2ug==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/17] mm/sparse-vmemmap: support section-based vmemmap
 optimization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
 muchun.song@linux.dev
In-Reply-To: <20260702093821.2740183-8-songmuchun@bytedance.com>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-8-songmuchun@bytedance.com>
Date: Wed, 15 Jul 2026 08:08:42 +0300
Message-Id: <178409212284.638342.13762174390974989494.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4FAA220004
X-Stat-Signature: h7pdy3x4beoqzwrjork7ggy5ncs8rwak
X-HE-Tag: 1784092145-417907
X-HE-Meta: U2FsdGVkX19ef1rXW6MuUzug1orqTKZLCdhVMu5231D0OmSpSAYnRZ33aZaQHONKRC04EoLzbWSxTbUcH5YyjeIdzVpAPP7b4ZW5lTEJmgL96H7i13HIiXuhXPTUXe4IOcUnGbdueL/wrZJWGLXY6m1j4maaleYqxF2eo3041PtTEHRSdjzsVnHICWjyXUGnxeHJ+yfwSXxC4t0UI13Uwn9uhkAgUvvLrdEBA+2M04edyN+7JTun97hdUC0MUkW3q2NljIKMt4+dcxqj9tacofXVtGK0oevuZBPZd7bYvKK+yI2DvJzh4dcWvybB8l0lUnZvvDUibt9z/OtLzLdL1jybhZhDcfWbiQ9Ta78vanTGCu753qjK14IfSOxNqvobHTCIsYcsqhzMoFhj47nn0kpTAyXM9SPV0dNZ6GccgMNgfUanR0IfyvaVpUP9N788qQEu3HoNZXa625LtTwmA0wov/pq8QLMXUHLUmM8POZbE0LjtXO4ACrhEOLG37a4Ig0hBWIhF25cAq4TGwg79vw+7+FO6xwt6rgs9WVLY6cUHm21yQtem4s/OT743SopS6DPkvyO6ldyy+cd4jXQAQ6D3RnrGBOAGmQmwo7n2O0XtfPU8pqEuzCU5I7uWrcIMjOjPUZjJw+Np5YmJL5O9iq2T0bTyM31GQGKEVj3wX72ruMRuh7wBRwKdj8oGV9cLKW4GkDrcpum2sNWyklTIF57CPIUhagRLnt8G1US3FffXMUY2/kYIZvod1J/lntZERhiHZrKcZlQepVEU05TPES/HlQ7uGdXlFTljGX3yfp2rK8NI2rMAzVGBrVybeVmKyqoOjddFQVlyv1uVQ1YgtdfeSyie+NE5JbH4o/9InqPZxpP/gDBpYNAGHJo0t8+db8eWxNVvNzTe3PU2aED5UrgZCmGFp0kzGGkMqUnE1UzkyDeODADDMqhomeFhyOcuLrrcuqpHS4LuI3yBsrr
 3IekD24j
 4uNmyHV+9Z65NvyCDKBjprNVA/CVO9lb8eeAEwIQyIPFlD4RCy4dyPEIjj3AfLmujzfgdYFJ/qNwI1aGZy4yHSmV4eebfX+5QIgap1Rehs9jhM09Xsj/wUZp9iPSe449Grv/iko3TRxrhzjAJxKhH7TleHIp8drgujuzXUQZatHNF4bpgxerZWzZ9q7CGiO+E1Fh1BvWLmlyxYBxI4Y9rFDTkfu1PPFY6+gCOB2jlxiopIuR7H8t6u/zjJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Teach sparse-vmemmap population code to use the compound page order
> when deciding whether a vmemmap page can be optimized.
> 
> With this information, the common sparse-vmemmap population path can
> allocate or reuse shared tail vmemmap pages directly instead of relying
> on HugeTLB/DAX-specific handling.
> 
> This centralizes vmemmap optimization logic in the sparse-vmemmap code,
> based on section metadata, and prepares for sharing the same mechanism
> across different users of vmemmap optimization, including HugeTLB and
> DAX.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 41a1ebbe5e85..41f6a584a52a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1148,7 +1148,7 @@ struct zone {
>  	/* Zone statistics */
>  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>  	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
>  	struct page *vmemmap_tails[NR_OPTIMIZABLE_FOLIO_ORDERS];
>  #endif
>  } ____cacheline_internodealigned_in_smp;
> diff --git a/mm/internal.h b/mm/internal.h
> index ebbab7421633..8ec8b447d75e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -993,6 +993,9 @@ static inline void __section_mark_present(struct mem_section *ms,
>  
>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  }
> +
> +int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);

What about !SPARSE_VMEMMAP case?

>  #else
>  static inline void sparse_init(void) {}
>  #endif /* CONFIG_SPARSEMEM */
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 99f59394feab..232f2a08afad 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -146,17 +146,49 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
>  			start, end - 1);
>  }
>  
> +static struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
> +{
> +	pg_data_t *pgdat = NODE_DATA(nid);
> +
> +	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
> +		struct zone *zone = &pgdat->node_zones[zone_type];
> +
> +		if (zone_spans_pfn(zone, pfn))
> +			return zone;
> +	}
> +
> +	return NULL;
> +}
> +
> +static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone);
> +

Maybe just move the entire function here?

>  static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>  				       struct vmem_altmap *altmap,
>  				       unsigned long ptpfn, unsigned long flags)
>  {
>  	pte_t *pte = pte_offset_kernel(pmd, addr);
> +	struct page *page = (struct page *)addr;
> +	unsigned long pfn = page_to_pfn(page);
> +	unsigned int order = section_order(__pfn_to_section(pfn));
> +
>  	if (pte_none(ptep_get(pte))) {
>  		pte_t entry;
> -		void *p;
> +
> +		if (page_vmemmap_optimizable(page, order) &&
> +		    ptpfn == (unsigned long)-1) {
> +			struct zone *zone = pfn_to_zone(pfn, node);
> +
> +			if (WARN_ON_ONCE(!zone))
> +				return NULL;
> +			page = vmemmap_get_tail(order, zone);
> +			if (!page)
> +				return NULL;
> +			ptpfn = page_to_pfn(page);
> +		}
>  
>  		if (ptpfn == (unsigned long)-1) {
> -			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +
>  			if (!p)
>  				return NULL;
>  			ptpfn = PHYS_PFN(__pa(p));
> @@ -175,7 +207,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>  		}
>  		entry = pfn_pte(ptpfn, PAGE_KERNEL);
>  		set_pte_at(&init_mm, addr, pte, entry);
> -	}
> +	} else if (WARN_ON_ONCE(page_vmemmap_optimizable(page, order)))
> +		return NULL;
>  	return pte;
>  }
>  
> @@ -320,7 +353,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
>  	}
>  }
>  
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
>  {
>  	struct page *p, *tail;
> @@ -348,6 +380,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
>  	return tail;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>  				       unsigned int order, struct zone *zone,
>  				       unsigned long headsize)
> @@ -402,6 +435,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  	pmd_t *pmd;
>  
>  	for (addr = start; addr < end; addr = next) {
> +		unsigned long pfn = page_to_pfn((struct page *)addr);
> +		struct mem_section *ms = __pfn_to_section(pfn);
> +
>  		next = pmd_addr_end(addr, end);
>  
>  		pgd = vmemmap_pgd_populate(addr, node);
> @@ -417,7 +453,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  			return -ENOMEM;
>  
>  		pmd = pmd_offset(pud, addr);
> -		if (pmd_none(pmdp_get(pmd))) {
> +		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
>  			void *p;
>  
>  			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
> @@ -435,8 +471,19 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  				 */
>  				return -ENOMEM;
>  			}
> -		} else if (vmemmap_check_pmd(pmd, node, addr, next))
> +		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
> +			const struct mem_section *start_ms;
> +			unsigned long align = max(1UL << section_order(ms), PAGES_PER_SECTION);
> +
> +			/* HVO-covered sections must not use PMD mappings. */
> +			start_ms = __pfn_to_section(ALIGN_DOWN(pfn, align));
> +			if (!IS_ALIGNED(pfn, align) && section_vmemmap_optimizable(start_ms))
> +				return -ENOTSUPP;
> +
> +			/* PMD mappings end HVO coverage for this section. */
> +			section_set_order(ms, 0);

The whole pmd block here becomes really hairy. 
I'd suggest splitting it out to a helper function and reducing the
amount of nested ifs with early returns where possible.

>  			continue;
> +		}
>  		if (vmemmap_populate_basepages(addr, next, node, altmap))
>  			return -ENOMEM;
>  	}
> @@ -642,36 +689,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>  
> -static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> -		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> -{
> -	const struct mem_section *ms = __pfn_to_section(pfn);
> -	const unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
> -	const unsigned long pages_per_compound = 1UL << order;
> -	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
> -
> -	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
> -	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
> -
> -	if (vmemmap_can_optimize(altmap, pgmap))
> -		vmemmap_pages = VMEMMAP_RESERVE_NR;
> -
> -	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
> -		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> -
> -	if (order < PFN_SECTION_SHIFT) {
> -		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
> -		return vmemmap_pages * nr_pages / pages_per_compound;
> -	}
> -
> -	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
> -
> -	if (IS_ALIGNED(pfn, pages_per_compound))
> -		return vmemmap_pages;
> -
> -	return 0;
> -}
> -
>  static struct page * __meminit populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap)
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 9457a4d6a6fc..3e96478a63e0 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -284,6 +284,36 @@ static void __init sparse_usage_fini(void)
>  	sparse_usagebuf = sparse_usagebuf_end = NULL;
>  }
>  
> +int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{

I don't think moving this to sparse.c is a good idea, let's keep vmemmap
code in sparse-vmemmap.c

-- 
Sincerely yours,
Mike.


