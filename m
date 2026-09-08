Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D649FC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCF56B0092; Tue,  8 Sep 2026 05:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D3B6B0095; Tue,  8 Sep 2026 05:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCAFC6B009B; Tue,  8 Sep 2026 05:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCA976B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:10:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B20DA4A4F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:10:25 +0000 (UTC)
X-FDA: 85190024010.01.A049C58
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40CB120003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:10:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AYRFJTBT;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858623;
	b=AkYeisADKPyUUyD66qWGXS50dwmolHcAGRseoAvbeCvIDuBnGDjvP/HwVD30XiJ+QfmBG6
	D/+j6PFCqlWGMMdby9opwH657M7u2bJ9COFtH1I2RyyCrkF3dOj+YkZVxDhp8+lY1SmO98
	r2n9SFdFUC2MJ4qxitnQndPOz498Exs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AYRFJTBT;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRXgI53iZJVJF7ZG0s8MRMI+roCGiNdA7rcbUkFE4g8=;
	b=u8N73hkBBTkwmTjwEdg83HDNtJp5wQ8/ADL0zX2wahhPbVqPswm1JGRz/GWtWyquTatZeR
	Nfcx6urUXAeseUWpdS+0Yqw7dVt9I/eGtHGUKOWEnk9pEHKzP4OrDhGWCr/1dz/xHcU0DH
	l5uQ/c6J+I0dguHyolj3mPL1bnk6D0Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cEdVml3tdgAFLckXNxgJNh/xEbh5hOuVY3ofUnolJE8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788858621; v=1; x=1789463421;
 b=AYRFJTBTMRErdeMA1CK3kR4CwMN3MLFW8wukqG73SrltUt0t3nDf8atZSSCuJqh4goXkg0R2
 pLm75rX89KeS87wxNYQWnIeb/a8f1J1Q63wrL9U4gqZeDjgEiHZd6NJsd+aonlJuEfPYdynTdNI
 SAhqWMvbSEs+VmI90yrdjE0A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 375bf685a1d0cbc9;
	Tue, 08 Sep 2026 09:10:05 +0000
X-Mizu-Trace-ID: 375bf685a1d0cbc9
X-Migadu-Flow: FLOW_OUT
Message-ID: <f2f1f7e4-539f-4385-a28b-1fde074cdeca@linux.dev>
Date: Tue, 8 Sep 2026 17:09:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] mm/sparse-vmemmap: drop the extra tail page from
 device DAX reservation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-10-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260908030335.96549-10-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 6n7pg3f3tnitmeuokf47ygyofotfngnb
X-Rspamd-Queue-Id: 40CB120003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788858623-243233
X-HE-Meta: U2FsdGVkX1+4istojaSJNU1mSE6+f09MxSVETKEUH4JO0y7Qq/uIhdFcKWo7qK/EMBWWR++CxRszOErE54h1QlnNy06/j+QonoIiWYaUkrMqjYCDP4o21SYIeIDD35dose7AxK0FwgrGgPWs86eau1/dnO7KMBjSuuU7u8vVytU2Co1wI+gpx8lWFwSfv1iUWUwhSUtA1qw1O2d44TqS92Khoia/w52TKABX4wNAONFNOQArtcy3Bfqyqx++JbdOOdW8WqKGTnEjoBNk4uGRKpydswE4LHlsmRimHzQm2oZ8rqXc/Aw4hsBX+3kry5ujSuiomE7h2MO5n715k6I/nmVPYx94gB+1EqlkNIuA9TP0ozY3IoQSNa00ga9xO19aTgJmMxK5ZdKXFdvjGX3CQeg/Lr+DQCpqV4EEOBIwZl+9i1e1Xsidnk9TUNv1sCli/9fsed4K9Krw2iHCAHzjW76nV14aYEwHbyZBziEWQeITdOLUH2CQsnkj4/9mUk/zNFUnCVwsT68lKzvePU9D7bwU2A0tTyVmcES98WIMCqQy7MCHIPnL1KwCJ5+t27BncqKFSL+SnP/XjHcIgC4zb+mjICqN3Hi9cKKG6aN8paBy0cA84u2v2+mrg1pgRUk01Emy/f4Pkv21Q1uPQ2N08sieHBsa4qCwz1nOCe3z122S7hOESvyTqn4UWK5i5Y+GKuc1QlXxg8y5IhriFXH59BxvcCi35qNRmGRBCjo6o0NTEj36/Tf47hO1Dr2gOVFF5ovZXBuLmZPgopbQhAVc/q+4lvTZ00Qd7fIiJ5doVIWfutENbw3mZtBZZ11kf6+TUHSvlfCSbveFko80JWQIICVHsrhbntPr+VVvzwfw9YKSv/BjYnPyyNqCZIHXvbHTSrfoPxgbL4r58CD4D95iuz46TL3okWD2HmLuMtoOeZ3ME5JICLv+2KyIGiVOdfIFh11DBjoWyyuNiig7HlD
 euy230Nz
 vfGLCNBP3Qifux5ANZff0uzQIhMrnSDjnIi/lOjeivj9N3yZozySQ843LBzstEUo+vz7NVRafPEwL7/44IkdhskyG1qDGQ49h9KIuzKFZ2qp33w4WMqV6mncWawSie5Pvx/3KRIiXKfFTFS4o1jwSidYlQiCXAH88eMAgl/KdZNpW511qiUd+ZQFnmoPF1RnpWTqpZSwHMsdeal4KI5VqbXxx5PrnSwmeLQ3L1+ZLi6wsN7sBcqRpTbjyCYJcqgkaWnvKEccPueaFqdKX0Xjcpp3cSaJ6Zzy/Xm7fKworWngTIoLLyJnAxBkrG98QlY2pphm+BHIwQYccIDLztf4Lijh02nTDHT6DnjVxSRFTZSkA0cw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 11:03 AM, Muchun Song wrote:
> The device DAX vmemmap population still reserves one extra tail vmemmap
> page after the head page.
> 
> Drop that extra reservation and let the shared tail page cover all tail
> vmemmap pages after the head page, so DAX follows the same reservation
> model as HugeTLB.
> 
> This reduces the reserved vmemmap pages for optimized DAX mappings to
> one and removes the now-unneeded first-tail population from the generic
> and powerpc paths to simplify the code as well.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   arch/powerpc/mm/book3s64/radix_pgtable.c | 46 ++----------------------
>   include/linux/mm.h                       |  3 +-
>   mm/mm_init.c                             |  2 +-
>   mm/sparse-vmemmap.c                      | 13 ++-----
>   4 files changed, 7 insertions(+), 57 deletions(-)

Looks like sashiko's response [1] is a false positive.

[1]. 
https://sashiko.dev/#/patchset/20260908030335.96549-1-songmuchun%40bytedance.com

__SetPageReserved() in vmemmap_shared_tail_page() marks the struct page
entries stored inside the shared vmemmap backing page, i.e. the metadata
templates that later represent DEV-DAX tail pages. It does not mark the
struct page of the backing page itself.

On hot-remove, free_vmemmap_pages() is called with pte_page(*pte), which
is the backing page. That page is not reserved, so the teardown goes
through __free_pages(), not free_reserved_pages().

Right?

If so:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index 831c231a4a18..e7e751c48dd2 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -1218,39 +1218,6 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
>   	return 0;
>   }
>   
> -static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int node,
> -							 struct vmem_altmap *altmap,
> -							 struct page *reuse)
> -{
> -	pgd_t *pgd;
> -	p4d_t *p4d;
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> -
> -	pgd = pgd_offset_k(addr);
> -	p4d = p4d_offset(pgd, addr);
> -	pud = vmemmap_pud_alloc(p4d, node, addr);
> -	if (!pud)
> -		return NULL;
> -	pmd = vmemmap_pmd_alloc(pud, node, addr);
> -	if (!pmd)
> -		return NULL;
> -	if (pmd_leaf(*pmd))
> -		/*
> -		 * The second page is mapped as a hugepage due to a nearby request.
> -		 * Force our mapping to page size without deduplication
> -		 */
> -		return NULL;
> -	pte = vmemmap_pte_alloc(pmd, node, addr);
> -	if (!pte)
> -		return NULL;
> -	radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
> -	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
> -
> -	return pte;
> -}
> -
>   int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   					      unsigned long start,
>   					      unsigned long end, int node,
> @@ -1297,7 +1264,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   		if (!pte_none(*pte)) {
>   			/*
>   			 * This could be because we already have a compound
> -			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
> +			 * page whose retained vmemmap page was mapped and
>   			 * this request fall in those pages.
>   			 */
>   			next = addr + PAGE_SIZE;
> @@ -1318,16 +1285,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   					return -ENOMEM;
>   				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
>   
> -				/*
> -				 * Populate the tail pages vmemmap page
> -				 * It can fall in different pmd, hence
> -				 * vmemmap_populate_address()
> -				 */
> -				pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
> -				if (!pte)
> -					return -ENOMEM;
> -
> -				next = addr + 2 * PAGE_SIZE;
> +				next = addr + PAGE_SIZE;
>   				continue;
>   			}
>   
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2ebe87e7654..969594074fd2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5167,7 +5167,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
>   }
>   #endif
>   
> -#define VMEMMAP_RESERVE_NR	2
>   #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
>   static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
>   					  struct dev_pagemap *pgmap)
> @@ -5187,7 +5186,7 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
>   	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
>   	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
>   	 */
> -	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
> +	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
>   }
>   /*
>    * If we don't have an architecture override, use the generic rule
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7a2e58d631c2..629420a83891 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1056,7 +1056,7 @@ static inline unsigned long compound_nr_pages(unsigned long pfn,
>   	if (!section_vmemmap_optimizable(ms))
>   		return pgmap_vmemmap_nr(pgmap);
>   
> -	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
> +	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
>   }
>   
>   static void __ref memmap_init_compound(struct page *head,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 0201877a7f80..e655d9d1348f 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -136,7 +136,6 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
>   {
>   	const struct mem_section *ms = __pfn_to_section(pfn);
>   	const int order = section_order(ms);
> -	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
>   	const unsigned long pages_per_compound = 1UL << order;
>   
>   	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
> @@ -147,13 +146,13 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
>   
>   	if (order < PFN_SECTION_SHIFT) {
>   		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
> -		return vmemmap_pages * nr_pages / pages_per_compound;
> +		return VMEMMAP_OPTIMIZATION_PAGES * nr_pages / pages_per_compound;
>   	}
>   
>   	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>   
>   	if (IS_ALIGNED(pfn, pages_per_compound))
> -		return vmemmap_pages;
> +		return VMEMMAP_OPTIMIZATION_PAGES;
>   
>   	return 0;
>   }
> @@ -521,17 +520,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   		if (!pte)
>   			return -ENOMEM;
>   
> -		/* Populate the tail pages vmemmap page */
> -		next = addr + PAGE_SIZE;
> -		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
> -		if (!pte)
> -			return -ENOMEM;
> -
>   		/*
>   		 * Reuse the shared page for the rest of tail pages
>   		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
>   		 */
> -		next += PAGE_SIZE;
> +		next = addr + PAGE_SIZE;
>   		rc = vmemmap_populate_range(next, last, node, NULL,
>   					    page_to_pfn(page), flags);
>   		if (rc)


