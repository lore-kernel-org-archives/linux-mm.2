Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 795C3C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3596B009B; Tue, 25 Aug 2026 09:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88ACB6B009D; Tue, 25 Aug 2026 09:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7F86B009E; Tue, 25 Aug 2026 09:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 555CF6B009B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:12:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAAA7403E5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:12:52 +0000 (UTC)
X-FDA: 85139831784.17.7CAE939
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf29.hostedemail.com (Postfix) with ESMTP id A646B12000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:12:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eVH7+Tfs;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663571;
	b=HPVc3u1SfN8FEOLrQ6tJ40gmB+VCBCoc3dpdlXSAlcbfE7kN6dDQrZhzEoswTCUSwRTOJ8
	lm4d/WXuATXJCxBhsaiYafLas2IFwpZ1X0p3g6CcsugB/zozGcYQOODsH6wk4Gssr8D5Go
	nlukhFqo9/JT76xaeaNBny3jNcD6Fbo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eVH7+Tfs;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ms5NJx+E9o0WDeA8RbrRi2M8b/xNVY3j/zcZ36rZUqA=;
	b=oP2IUWhkoviDWJXk3aTV9ihKfG49LcrDmkwm31zGbGXZimImrNA7wZewwLkHwtsOrblOS2
	lA5G2wp0N/nUVhmaDC/yBTh46JTDVn//jHsVSZXUYKtCmfs+B1bz7xVkXaWkAGzd2HNXhw
	45btLTdYfQ/wy2dyLa6UzmPOzRnOzQ8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SyupUXu+xf0c5j4OJeekg8pSM7sTf9BYYYALL5PIKBA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787663569; v=1; x=1788268369;
 b=eVH7+Tfsfu1L/lmtoNI71ik+/jCieTHWZHAG9gr4sO+NczF+bJjUSNF50c1JwOtg8du03dSo
 cqwdsS+8eN5E2ztD2Ls2Q69LiXiGwSMuYQf+XEFuqWkFpQt5RWohKknxJ87dGpsbC+FDSk6sJaw
 RF6C/lIr0b8pIt0zHoV+Z02U=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id 7ee5856995299be2;
	Tue, 25 Aug 2026 13:12:49 +0000
X-Mizu-Trace-ID: 7ee5856995299be2
X-Migadu-Flow: FLOW_OUT
Message-ID: <83d8d1f2-6ca2-4c72-a494-23ce07bb4181@linux.dev>
Date: Tue, 25 Aug 2026 21:12:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-11-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A646B12000B
X-Stat-Signature: f1rt8nys5b1j9y13qjow5xikyc39rw3c
X-HE-Tag: 1787663570-416507
X-HE-Meta: U2FsdGVkX1/lqW5miAmvvXu2m0sVVfpvtg/C4EO3FtN4F4CadOBCwWTAe4AiidaFMP8h5nEy8Fr62K5HEHsiW36tEbmcq1RK1UPD8H8yTajaEBJ9IvirF+GuSvI/5k1B8D4oz5uc2X5lWxPfTiQn/JPxUkN/h/a9AYGLRWuyPz5O6x3/fsbARO83znrDXilP3K9+zGWhxmbsLByVxRK9ofEb6DrFFP8aDljJEGxX+jQpgNWbqC+ZGCmSGX8UwXMaX4m85GcWQbNJud1p1PeEg1J+3AYlnBpiQryEv6iGUGNaZ2RF6YzTTwBei+QD6X0TSLrMY/Ivv+QqUwH1eY/oZbDwMGQaWQ8K2175f4FM50nyt25Etrhjoso1arkmkX8wUV9rtwAe/aCtGoYqBRlihn/tUarP7bgMFJ+rFEWrgZd3dSYm3cwudSPTnsJC3eq+/MhG5UWwPCKJUOqG/AT0AOF0pyx2O/6MK6snyUGXLLx/hmUK9hyuIZyj2ZOufTpKNu27MeHgv4nf3qTIc2XO6VmDIKMpleXpJ6LGfTDTzKR6bcheTV4AZ2s+S3cSvqHiNzgOUdF2SHUMayOBOZwzNH2+bdumU4pkdkcMB2E0rygLNDMX5oR2kwi1vARXbafX/LV7RxrECo9aNm9q1y8aA2g3gxv68q9WDaQx/C77rI9j9ILoJalxJWQc1MnlsAh5bEpEQDgamPOEPHRNj3mAeuvXhVq2zqPLPwkkhmjZgvhtD9RlDNCYlk1Lpfn0koOwwLCgW16HIh/b83kKJoYbc8WczK8eaxHtU6mmXrKfLUeCeZnU9l1esuq3EhgQfavdAdGTs7jhiwigqs6qKpyTeHy1/iEp21YBpaVk/pDCced7H8QrJE/67zi5gf31ZA6EXi4iKDcPj6P3LbwWjSMY6ZyeWpNGlqjeF/QVWzr1pv4U7EUogLsRj/vQevzHUhRib68UFAf+wBBa8fFTsxG
 7GSfEAqo
 VTztKipsNZc8qJIudYZ8hwYdkHMI6vZd1k4PQw3hITA2P8e2LCwccu5m7wqu6UihV/C0SNgoXCoSGepGcJkLWlaE7O1S3MUdteaXvSpwKdieOVfI8OwAkk8zrK4RrIAsFeb/mljw+iUhCOkvzZyVy7vcyXpwHmNBh9jv5CDF1ejdDWYsVhIgxUQsgHEl2wCyLQS6l9kHFQDMvCeTN1pEk28Bwyj04gvItHAzVOIpZSuMdsdo/vB/QGLborrAd2f5rHzoJcySiJtIs0bG+EWhBJbTG6UrbzopWVZeQjujQwMZr97e7Tls4CvtwqJOv6XmeY5JX6Wwo6vHSxNZFvnJaQq9r8OT8vvZBnSLtlXQayTR+Pb1CN/kFDwe65IO/OwThGIh0o1BtEOYnIgHl6AB1lW8Oeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> HugeTLB bootmem vmemmap optimization still carries its own early setup
> path, including pre-populating optimized mappings before the generic
> sparse-vmemmap code runs.
> 
> Now that the section-based vmemmap optimization can derive HugeTLB
> vmemmap deduplication from section metadata, HugeTLB only needs to mark
> the bootmem huge page range with the appropriate order. The generic
> sparse-vmemmap population path can then allocate and map the shared tail
> vmemmap pages without any HugeTLB-specific early population code.
> 
> Do that by setting the section order when a bootmem huge page is
> allocated and dropping the dedicated pre-HVO helpers and related
> special-casing.
> 
> This removes duplicate early setup logic and switches HugeTLB to the
> section-based vmemmap optimization path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v3:
> - Use the order-based helper for the bootmem vmemmap-optimized check
> 
> v2:
> - Collect Acked-by from Mike Rapoport
> ---
>   include/linux/hugetlb.h |  1 -
>   include/linux/mm.h      |  3 --
>   mm/hugetlb.c            | 30 ++------------
>   mm/hugetlb_vmemmap.c    | 90 +++--------------------------------------
>   mm/hugetlb_vmemmap.h    | 14 +++----
>   mm/sparse-vmemmap.c     | 31 --------------
>   mm/sparse.h             | 27 +++++++++++++
>   7 files changed, 42 insertions(+), 154 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 16c4c4caa126..fe28f98e1b22 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -171,7 +171,6 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
>   
>   extern int movable_gigantic_pages __read_mostly;
>   extern int sysctl_hugetlb_shm_group __read_mostly;
> -extern struct list_head huge_boot_pages[MAX_NUMNODES];
>   
>   void hugetlb_bootmem_struct_page_init(void);
>   void hugetlb_bootmem_alloc(void);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..441bd39eab73 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5159,9 +5159,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>   			       int node, struct vmem_altmap *altmap);
>   int vmemmap_populate(unsigned long start, unsigned long end, int node,
>   		struct vmem_altmap *altmap);
> -int vmemmap_populate_hvo(unsigned long start, unsigned long end,
> -			 unsigned int order, struct zone *zone,
> -			 unsigned long headsize);
>   void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
>   			  unsigned long headsize);
>   void vmemmap_populate_print_last(void);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 04e6c4244cd6..fbb0c83bea79 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -52,6 +52,7 @@
>   #include "hugetlb_cma.h"
>   #include "hugetlb_internal.h"
>   #include "mm_init.h"
> +#include "sparse.h"
>   #include <linux/page-isolation.h>
>   
>   int hugetlb_max_hstate __read_mostly;
> @@ -59,7 +60,7 @@ unsigned int default_hstate_idx;
>   struct hstate hstates[HUGE_MAX_HSTATE];
>   
>   __initdata nodemask_t hugetlb_bootmem_nodes;
> -__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
> +static struct list_head huge_boot_pages[MAX_NUMNODES] __initdata;
>   
>   /*
>    * Due to ordering constraints across the init code for various
> @@ -3139,6 +3140,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
>   	} else {
>   		list_add_tail(&m->list, &huge_boot_pages[nid]);
>   		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
> +		hugetlb_vmemmap_optimize_bootmem_page(m);
>   		/*
>   		 * Only initialize the head struct page in memmap_init_reserved_pages,
>   		 * rest of the struct pages will be initialized by the HugeTLB
> @@ -3299,6 +3301,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>   			 * this folio.
>   			 */
>   			folio_set_hugetlb_vmemmap_optimized(folio);
> +		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);

So section->order is only used during initialization. Is it ever
accessed later at runtime? If not, can we just skip zeroing it out?

>   
>   		if (hugetlb_bootmem_page_earlycma(m))
>   			folio_set_hugetlb_cma(folio);
> @@ -3342,31 +3345,6 @@ void __init hugetlb_bootmem_struct_page_init(void)
>   		.max_threads	= num_node_state(N_MEMORY),
>   		.numa_aware	= true,
>   	};
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> -	struct zone *zone;
> -
> -	for_each_zone(zone) {
> -		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
> -			struct page *tail, *p;
> -			unsigned int order;
> -
> -			tail = zone->vmemmap_tails[i];
> -			if (!tail)
> -				continue;
> -
> -			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
> -			p = page_to_virt(tail);
> -			/*
> -			 * prep_and_add_bootmem_folios() can access pageblock
> -			 * flags on bootmem HugeTLB pages, so initialize the
> -			 * shared tail struct pages here before bootmem folios
> -			 * start using them.
> -			 */
> -			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
> -				init_compound_tail(p + j, NULL, order, zone);
> -		}
> -	}
> -#endif
>   
>   	padata_do_multithreaded(&job);
>   }
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index c48fcea076a5..7293706b532f 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -18,8 +18,7 @@
>   
>   #include <asm/tlbflush.h>
>   #include "hugetlb_vmemmap.h"
> -#include "internal.h"
> -#include "mm_init.h"
> +#include "sparse.h"
>   
>   /**
>    * struct vmemmap_remap_walk - walk vmemmap page table
> @@ -706,95 +705,18 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
>   	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
>   }
>   
> -#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
> -
> -/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
> -static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
> +void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
>   {
> -	unsigned long section_size, psize, pmd_vmemmap_size;
> -	phys_addr_t paddr;
> -
> -	if (!READ_ONCE(vmemmap_optimize_enabled))
> -		return false;
> -
> -	if (!hugetlb_vmemmap_optimizable(m->hstate))
> -		return false;
> -
> -	psize = huge_page_size(m->hstate);
> -	paddr = virt_to_phys(m);
> -
> -	/*
> -	 * Pre-HVO only works if the bootmem huge page
> -	 * is aligned to the section size.
> -	 */
> -	section_size = (1UL << PA_SECTION_SHIFT);
> -	if (!IS_ALIGNED(paddr, section_size) ||
> -	    !IS_ALIGNED(psize, section_size))
> -		return false;
> -
> -	/*
> -	 * The pre-HVO code does not deal with splitting PMDS,
> -	 * so the bootmem page must be aligned to the number
> -	 * of base pages that can be mapped with one vmemmap PMD.
> -	 */
> -	pmd_vmemmap_size = (PMD_SIZE / (sizeof(struct page))) << PAGE_SHIFT;
> -	if (!IS_ALIGNED(paddr, pmd_vmemmap_size) ||
> -	    !IS_ALIGNED(psize, pmd_vmemmap_size))
> -		return false;
> -
> -	return true;
> -}
> -
> -/*
> - * Initialize memmap section for a gigantic page, HVO-style.
> - */
> -void __init hugetlb_vmemmap_init_early(int nid)
> -{
> -	unsigned long psize, paddr, section_size;
> -	unsigned long ns, i, pnum, pfn, nr_pages;
> -	unsigned long start, end;
> -	struct huge_bootmem_page *m = NULL;
> -	void *map;
> +	struct hstate *h = m->hstate;
> +	unsigned long pfn = PHYS_PFN(__pa(m));
>   
>   	if (!READ_ONCE(vmemmap_optimize_enabled))
>   		return;
>   
> -	section_size = (1UL << PA_SECTION_SHIFT);
> -
> -	list_for_each_entry(m, &huge_boot_pages[nid], list) {
> -		struct zone *zone;
> -
> -		if (!vmemmap_should_optimize_bootmem_page(m))
> -			continue;
> -
> -		nr_pages = pages_per_huge_page(m->hstate);
> -		psize = nr_pages << PAGE_SHIFT;
> -		paddr = virt_to_phys(m);
> -		pfn = PHYS_PFN(paddr);
> -		map = pfn_to_page(pfn);
> -		start = (unsigned long)map;
> -		end = start + hugetlb_vmemmap_size(m->hstate);
> -		zone = pfn_to_zone(pfn, nid);
> -
> -		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
> -					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
> -			panic("Failed to allocate memmap for HugeTLB page\n");
> -		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
> -
> -		pnum = pfn_to_section_nr(pfn);
> -		ns = psize / section_size;
> -
> -		for (i = 0; i < ns; i++) {
> -			sparse_init_early_section(nid, map, pnum,
> -					SECTION_IS_VMEMMAP_PREINIT);
> -			map += section_map_size();
> -			pnum++;
> -		}
> -
> +	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
> +	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
>   		m->flags |= HUGE_BOOTMEM_HVO;
> -	}
>   }
> -#endif
>   
>   static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
>   	{
> diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
> index 7ac49c52457d..20eb03df542a 100644
> --- a/mm/hugetlb_vmemmap.h
> +++ b/mm/hugetlb_vmemmap.h
> @@ -9,8 +9,7 @@
>   #ifndef _LINUX_HUGETLB_VMEMMAP_H
>   #define _LINUX_HUGETLB_VMEMMAP_H
>   #include <linux/hugetlb.h>
> -#include <linux/io.h>
> -#include <linux/memblock.h>
> +#include "internal.h"
>   
>   /*
>    * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
> @@ -27,10 +26,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
>   void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
>   void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
>   void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
> -#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
> -void hugetlb_vmemmap_init_early(int nid);
> -#endif
> -
> +void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
>   
>   static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
>   {
> @@ -76,13 +72,13 @@ static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
>   {
>   }
>   
> -static inline void hugetlb_vmemmap_init_early(int nid)
> +static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
>   {
> +	return 0;
>   }
>   
> -static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
> +static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
>   {
> -	return 0;
>   }
>   #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
>   
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 8d39196f6d93..e48758805a8f 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -32,8 +32,6 @@
>   #include <asm/dma.h>
>   #include <asm/tlbflush.h>
>   
> -#include "hugetlb_vmemmap.h"
> -
>   /*
>    * Flags for vmemmap_populate_range and friends.
>    */
> @@ -404,34 +402,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
>   	}
>   }
>   
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> -int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
> -				       unsigned int order, struct zone *zone,
> -				       unsigned long headsize)
> -{
> -	unsigned long maddr;
> -	struct page *tail;
> -	pte_t *pte;
> -	int node = zone_to_nid(zone);
> -
> -	tail = vmemmap_get_tail(order, zone);
> -	if (!tail)
> -		return -ENOMEM;
> -
> -	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
> -		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
> -		if (!pte)
> -			return -ENOMEM;
> -	}
> -
> -	/*
> -	 * Reuse the last page struct page mapped above for the rest.
> -	 */
> -	return vmemmap_populate_range(maddr, end, node, NULL,
> -				      page_to_pfn(tail), 0);
> -}
> -#endif
> -
>   void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>   				      unsigned long addr, unsigned long next)
>   {
> @@ -634,7 +604,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>    */
>   void __init sparse_vmemmap_init_nid_early(int nid)
>   {
> -	hugetlb_vmemmap_init_early(nid);
>   }
>   #endif

This turns into a no-op function and can be removed right away. I see
you already drop it in patch #11, anyway.

Besides that, LGTM, so:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


