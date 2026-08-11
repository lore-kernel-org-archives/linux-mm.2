Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD56C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFAE6B007B; Mon, 10 Aug 2026 23:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6E66B008A; Mon, 10 Aug 2026 23:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD826B0095; Mon, 10 Aug 2026 23:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93DD46B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:59:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15636A0352
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:59:37 +0000 (UTC)
X-FDA: 85087634394.26.5C5BFFF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id CFF141C0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:59:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NHxquKxs;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786420775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSI0U8pt55LTplJXVUrbY5Dvk4IrUWdS2aGBJhbKkKI=;
	b=A9zqUiZtlCeET0vFAIqh3hybqQ0Libkq1kkl4fs0WJhmNpGSZ/G0GqAcjSm48XN7jJjt91
	tUFWSoYMstkTMnqJFiU/cnR1fTyaGEcVbHKccKy3mtjq3VRSktoZZ42kF+bPWcVJirmssU
	OmE1iZGibSc1kZw1TQExIY9kFRRqlkk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786420775;
	b=6IPZd32wUBBSmmjWbWWjo6Rz9uy5cJifghVDZd+JhsL2+iiRQzAOziaZO8+VetsiVP63Ab
	zeqPfvof3mIRkSI9qHJYFaEdVv3WswQEpQQtjXfgXh1I73vT21T8fE5eyO9iDr0g4ySC+T
	/pALj6fd4SMuzjSJK26lBTBsmwoC2aU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NHxquKxs;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <47182b7a-b388-4aff-bb22-1da35d9993cd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786420773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mSI0U8pt55LTplJXVUrbY5Dvk4IrUWdS2aGBJhbKkKI=;
	b=NHxquKxscLo2W9S4Kaz7DdecEYMK2FNZijF8s9zr7Sf0B4VSiC5/7Qjj+h5l1y3LrsypmB
	l/geyEkC2jM+YEROH5/OYeZMaDu9zckmOrpOzGsiuVqfdrB5yYjaOK5BI2O6MWSaNaPMU9
	oC7+7DUP3Z2qjI3MuL0zJNTTfk8n6+M=
Date: Tue, 11 Aug 2026 11:58:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
To: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
 <20260804035535.2846016-11-songmuchun@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260804035535.2846016-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CFF141C0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: n4jgcaq5u44q5rifqyhmstqmq375urb8
X-HE-Tag: 1786420774-682854
X-HE-Meta: U2FsdGVkX1/XRRM74Kpe2DEQW9hZKuQOu5G6/lcz4IxNba2M5G/ESbtlBZ/qVSj0u5CxqLcSCEMY5VroebMYlky/TWXKvxbI0UNmCl+F+jQv4TOX7WVhUPhxLBggAm4DZc06RlofsmP3bwv4nYpys9KHbwt8lz/rPYQYF0pyrMfKwfQ0g+DL8LfIOXiNkb2OBZC7CppL47je6cBtWCT/CMnLVGcdQ070EcwiXUEM/0hSfaPbynhA5FwLaDOQ2rhK9wN+UPPIx4nBUNUluBhSO6je4gPFblrjtbTWg8VPnfL5GFJUs0RCd+ueqKh27OseajLS6ZfBwXA5X7NhkcModiiWRiJWbvKl1fIlfA213ba4BUzUNZPoGaAv3J5kj/FSnHAmf3DhWsb2bXf/SZn5vxBczT2gzlg2bab4b1w9D/CYqTUUPFdVyYZundu5gBkJn0amBzsv8Ep/my5xRTXKY+K1neOXWF3qXpNGUZjt+xy7bBt8gEzjPfbX6bD8orPOrERrdZZoXr/16mn5dD7RwuL/6hdr1wYkUDgOZo1fKv3pTcw5MH+hDHQMLKtGgPDuLydQBbCbjy57VsG6s8zQVtozXN80+hYesAcvL7qeakGvXfFutotMnPkYrbTQGYANYMFgcCf6UTlHYnK5MaEVDXNparlWEXtt20wbbIuT7Kk++mPANisCFdl061cM2hFPptejksIYqsq0VW90up6yBvz8ueIOss9+SjztJXQHh8+J7GqVAqGEbfCCl5fItfKGW7OuCn2BaJkGG8qUW09UVMFpdcFnzzKqA/fpMnVRN8f7GCqYEp73J/woAy7MeXiNQMYfZUgKLFBawo3x31GKxO0nxVnXPE5cIT4CAMfleecsNxv6FZc2gep7TDnryigFUIQNFYcNEW0sgACw8dLvOx87ePQqgvJDOQSvZcccU20LnirUSM7HRi9njmAxITr3qOhLmidgKvcASkZd1CK
 BqmuyCBn
 AY70IIg4tFSK8X6wzZVhj/LhVnwHCjLPZw2tBPfmJflMtwMgf/tFmIMyln1QiuyG78ndGCrArSXHot4seBswgc97DX2ef9mm6dPKAa8HZFk/OMq9T35zBSlRYzQbk6I2xkb8ou406MWIHKz1wq2SCW5H+kLJDnu1ZQ2cKn10XBxUSQi53g4KVIsnacPTDA8g728Vi9657kZArbdm6XAgwhtKzu3aSkjkgLIqcqW9FK23V4potVFS6W7WBNsOR2BbBamcr5WTKu/wqZCQWWKZOZFHgSLivhAFyZ9qljwX1wXymodviIY56VGbG1i/Vmlq0D4BGTV5hIaPlyj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/4 11:55, Muchun Song wrote:
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
> index 7fabe6c66b4b..fd7dc85f58f3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5097,9 +5097,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
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
> index d212bbff4c83..7d8507aa4c5b 100644
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
> @@ -3137,6 +3138,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
>   	} else {
>   		list_add_tail(&m->list, &huge_boot_pages[nid]);
>   		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
> +		hugetlb_vmemmap_optimize_bootmem_page(m);
>   		/*
>   		 * Only initialize the head struct page in memmap_init_reserved_pages,
>   		 * rest of the struct pages will be initialized by the HugeTLB
> @@ -3297,6 +3299,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>   			 * this folio.
>   			 */
>   			folio_set_hugetlb_vmemmap_optimized(folio);
> +		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
>   
>   		if (hugetlb_bootmem_page_earlycma(m))
>   			folio_set_hugetlb_cma(folio);
> @@ -3340,31 +3343,6 @@ void __init hugetlb_bootmem_struct_page_init(void)
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

Sashiko suggested that removing the pmd_vmemmap_size alignment
check might cause a kernel panic on architectures where a vmemmap
PMD covers multiple memory sections (e.g., LoongArch with 64KB pages).
However, this is a false positive, because LoongArch does not support
gigantic HugeTLB pages and therefore does not rely on the section-based
vmemmap optimization infrastructure at all.

Muchun,
Thanks.

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
> index b69a7af76858..7759f9de748c 100644
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
> @@ -369,34 +367,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
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
> @@ -599,7 +569,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>    */
>   void __init sparse_vmemmap_init_nid_early(int nid)
>   {
> -	hugetlb_vmemmap_init_early(nid);
>   }
>   #endif
>   
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 16b9bd3070aa..bc4c58ef24a9 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -16,6 +16,24 @@ static inline unsigned int section_order(const struct mem_section *section)
>   	return section->order;
>   }
>   
> +static inline void section_set_order(struct mem_section *section, unsigned int order)
> +{
> +	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
> +	section->order = order;
> +}
> +
> +static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
> +					   unsigned int order)
> +{
> +	unsigned long section_nr = pfn_to_section_nr(pfn);
> +
> +	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
> +		return;
> +
> +	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
> +		section_set_order(__nr_to_section(section_nr + i), order);
> +}
> +
>   static inline unsigned int pfn_to_section_order(unsigned long pfn)
>   {
>   	return section_order(__pfn_to_section(pfn));
> @@ -26,6 +44,15 @@ static inline unsigned int section_order(const struct mem_section *section)
>   	return 0;
>   }
>   
> +static inline void section_set_order(struct mem_section *section, unsigned int order)
> +{
> +}
> +
> +static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
> +					   unsigned int order)
> +{
> +}
> +
>   static inline unsigned int pfn_to_section_order(unsigned long pfn)
>   {
>   	return 0;


