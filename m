Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C4BD358C8
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 06:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1869A6B0088; Thu, 29 Jan 2026 01:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134CE6B0089; Thu, 29 Jan 2026 01:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036C76B008A; Thu, 29 Jan 2026 01:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E54276B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:54:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82121160916
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:54:27 +0000 (UTC)
X-FDA: 84384087774.24.BB701E7
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 883C74000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:54:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n5geKtvs;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769669665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4JRgDeBr4jab+v0AQMoJMPJjVR8MkEaj+rH1zUeTz4=;
	b=wlrG5njPUZLmPNYIvyCPLzoIlTO1Sn5jl9yZM7X//+wf9oAv4lTSGa8JqdWsSYHDaGrzxW
	dRoMC9qTWsK9+SgGi7GqzJ11n1wG+hhtYG5aIDCxnuryfM9YIGVzPRQlrkZt7TsNtnhiLB
	6DcU1+QucoQ43pv2TiVRnvL6Q3MUB/k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n5geKtvs;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769669665; a=rsa-sha256;
	cv=none;
	b=tRSpwp0AEfH5EKYZaD6cLdGwqfj9N2rtuxqMY+e+Q4RIAC/P3j66j5yF25lDgWQXU8oiU6
	ncW3N2UvoSkOsOqzWsM44OL6UPeS6cvPJ/OqlG2eRXpu9tjLTY32Gp/A6CEvEnHcUw3K4e
	0KVmLzHsICd5b6sTDL6ZnR0P0sGWPJ4=
Message-ID: <0db8c993-a525-438f-9d7b-94f63bfa0aa4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769669662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i4JRgDeBr4jab+v0AQMoJMPJjVR8MkEaj+rH1zUeTz4=;
	b=n5geKtvskBt5UeHtUN3tjKwhwYQQWLClgpDulimgfAcl+2JC++CzR0HifKg5bhU1Jcjsp5
	j+4xd+xIwQHvnZDELrYAHClQ62HxwFa6zJbY2EgtbaVxX5Rlrx3nJYrdjqq/V5wJ1C7J8N
	aKBzpwi/wUAI7cpkGYqzoCq6dJaN4Ys=
Date: Thu, 29 Jan 2026 14:54:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv5 11/17] mm/hugetlb: Remove fake head pages
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <20260128135500.22121-1-kas@kernel.org>
 <20260128135500.22121-12-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260128135500.22121-12-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: qh5uh5d9ugafk3ckyo5beidotwcfk1ij
X-Rspam-User: 
X-Rspamd-Queue-Id: 883C74000A
X-HE-Tag: 1769669665-775322
X-HE-Meta: U2FsdGVkX194mQ51twFglIsTrbB1iTp1G1jcQvDuqQF5HPob7E00Q/UKq/da56NfpQIgX/SmFvOl5+CNY8Ftq5hXEHIVcYsvA2kZyPkf4W1oU2DtT9x9xgyxxR8o2K1VbPXl+q7pJBOhk/YVCdSjQYU6M1tTm5FgYm7QCiNZyqdq74bAqs6vKTeRSOrD9GiFb4nlXcHVmfMH6wjUHupIix9lBGxQ3h8vnoXK7ez0anN/N4hlaXu8xTl1zzG4EyNDpfBj8xjer09ry62yxRHzRlCKKV4Q9CJl85hRR217psVm7bgACVUwlpeybNV74NkmFS/5zPrXV1GGPATamSjbrF+c0YJIgwl+fBTkZb0VcUq2qQT53K1ppgs0X6KahuZRsTCBo/jFtrjCQ+U1jxx3bjOzf9grU/506ddxTomlCYvRfeU3p1HkQ40j3Opzl4Osw+x/ZDhm/dx5Iuixa2qD3xqL6YkAVU6LsztS8KwvVkEpwOltaDHG4BJVTOpoG6KQ8A2CT7lzTgW/16EKIf26p88QJeYSBN4ka0EXsAWJ2B+tTOi+lguWs3TBefoQ6177Xu3Ns7mi01NuRAkcmrByScMzgvt32/VkV5URoUn0Sv/ocUITnTbjoU/foO5MHmE2IS8ctSxE3erjsZQVLdD4dYzaGz0aio2sRNwSA2jrZ/RXsI0xgYTJ+ka1X4thVX4etSXRZchWUSw1dKFautk5eKWADNjs3Gyp2F1Xyiqp49/DnZMcw941qKoWEAzjc3NzalYdIEwrdIg3IX7PlE3VlGKF4el2mTTPJCmhvsL6d/1fPaGrnap2CS3fKOKIsmHZCGqbPNUjdOtstRufJaG3aNsxQbAE2V0hZbQ5w3DqwlC474LLV/FR9jSl0h4DyO3UO2D3gWIAcNVcupDeKFyFy9pohRNshMRvNk10zEig3Iq5UzNrNSdJhnVL5Ag6rYL9+Fj3x7rd+p/uAa8sjI7
 als6JsdS
 rm0YHzLOTI2Nn5YV2fsCsbJK4DBcO7ialcadN+8UQC2ZJqIwFDQBomFJtWKHkaAQJ3uhjBNRl+iuOsc14AQjrmeOFsdTV3ZhO3R8GIGR33m4fU/2/GtA4hPspoWutLjaairQi1KIDgXUuED7G2W7KLLBgZD0QAHT3LRGuxJMayjgGTEpz/aFtAKzV0OV/x6Tnah8L/gPEdseVd3xdlZLrzPAEmtmFYW5nroR5YxPCNLUan3HH3bF4HAgFWIWWLJxhV82f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/28 21:54, Kiryl Shutsemau wrote:
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
>
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
>
> Allocate a single page of initialized tail struct pages per NUMA node
> per order in the vmemmap_tails[] array in pglist_data. All huge pages of
> that order on the node share this tail page, mapped read-only into their
> vmemmap. The head page remains unique per huge page.
>
> Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
> compile-constant as it is used to specify vmemmap_tail array size.
> For some reason, compiler is not able to solve get_order() at
> compile-time, but ilog2() works.
>
> Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
> <linux/pgtable.h> which generates hard-to-break include loop.
>
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   include/linux/mmzone.h | 18 +++++++++++++++--
>   mm/hugetlb_vmemmap.c   | 36 ++++++++++++++++++++++++++++++++--
>   mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
>   3 files changed, 86 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 192143b5cdc0..698091c74dbb 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -81,13 +81,17 @@
>    * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
>    * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>    */
> -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> +#ifdef CONFIG_64BIT
> +#define MAX_FOLIO_ORDER		(ilog2(SZ_16G) - PAGE_SHIFT)
> +#else
> +#define MAX_FOLIO_ORDER		(ilog2(SZ_1G) - PAGE_SHIFT)
> +#endif
>   #else
>   /*
>    * Without hugetlb, gigantic folios that are bigger than a single PUD are
>    * currently impossible.
>    */
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> +#define MAX_FOLIO_ORDER		(PUD_SHIFT - PAGE_SHIFT)
>   #endif
>   
>   #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> @@ -1402,6 +1406,13 @@ struct memory_failure_stats {
>   };
>   #endif
>   
> +/*
> + * vmemmap optimization (like HVO) is only possible for page orders that fill
> + * two or more pages with struct pages.
> + */
> +#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
> +#define NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
> +
>   /*
>    * On NUMA machines, each NUMA node would have a pg_data_t to describe
>    * it's memory layout. On UMA machines there is a single pglist_data which
> @@ -1550,6 +1561,9 @@ typedef struct pglist_data {
>   #ifdef CONFIG_MEMORY_FAILURE
>   	struct memory_failure_stats mf_stats;
>   #endif
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];

We should record "struct page" instead of pfn, I'll explain below.

> +#endif
>   } pg_data_t;
>   
>   #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index a39a301e08b9..f5f42b92dd7d 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -19,6 +19,7 @@
>   
>   #include <asm/tlbflush.h>
>   #include "hugetlb_vmemmap.h"
> +#include "internal.h"
>   
>   /**
>    * struct vmemmap_remap_walk - walk vmemmap page table
> @@ -505,6 +506,34 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
>   	return true;
>   }
>   
> +static struct page *vmemmap_get_tail(unsigned int order, int node)
> +{
> +	unsigned long pfn;
> +	unsigned int idx;
> +	struct page *tail, *p;
> +
> +	idx = order - VMEMMAP_TAIL_MIN_ORDER;
> +	pfn = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
> +	if (pfn)

You’ve assumed that a valid PFN can never be zero, but that
isn’t guaranteed.  If we store the `struct page` pointer
instead, the issue disappears: its virtual address is never
NULL.

Moreover, we only convert back and forth with pfn_to_page()/page_to_pfn();
we never dereference any member of the structure, so we don’t
have to care whether `struct page` has been initialized yet
during early boot (it is safe for us to get page in sparse-vmemmap.c).

> +		return pfn_to_page(pfn);
> +
> +	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> +	if (!tail)
> +		return NULL;
> +
> +	p = page_to_virt(tail);
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, NULL, order);
> +
> +	pfn = PHYS_PFN(virt_to_phys(p));
> +	if (cmpxchg(&NODE_DATA(node)->vmemmap_tails[idx], 0, pfn)) {
> +		__free_page(tail);
> +		pfn = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
> +	}
> +
> +	return pfn_to_page(pfn);
> +}
> +
>   static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   					    struct folio *folio,
>   					    struct list_head *vmemmap_pages,
> @@ -520,6 +549,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	if (!vmemmap_should_optimize_folio(h, folio))
>   		return ret;
>   
> +	nid = folio_nid(folio);
> +	vmemmap_tail = vmemmap_get_tail(h->order, nid);
> +	if (!vmemmap_tail)
> +		return -ENOMEM;
> +
>   	static_branch_inc(&hugetlb_optimize_vmemmap_key);
>   
>   	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
> @@ -537,7 +571,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	 */
>   	folio_set_hugetlb_vmemmap_optimized(folio);
>   
> -	nid = folio_nid(folio);
>   	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
>   	if (!vmemmap_head) {
>   		ret = -ENOMEM;
> @@ -548,7 +581,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	list_add(&vmemmap_head->lru, vmemmap_pages);
>   	memmap_pages_add(1);
>   
> -	vmemmap_tail	= vmemmap_head;
>   	vmemmap_start	= (unsigned long)&folio->page;
>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
>   
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 37522d6cb398..23abd06f1a4e 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -378,16 +378,45 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
>   	}
>   }
>   
> -/*
> - * Populate vmemmap pages HVO-style. The first page contains the head
> - * page and needed tail pages, the other ones are mirrors of the first
> - * page.
> - */
> +static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
> +{
> +	unsigned long pfn;
> +	unsigned int idx;
> +	struct page *p;
> +
> +	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
> +	BUG_ON(order > MAX_FOLIO_ORDER);
> +
> +	idx = order - VMEMMAP_TAIL_MIN_ORDER;
> +	pfn =  NODE_DATA(node)->vmemmap_tails[idx];
              ^
Why you added a space here?

> +	if (pfn)
> +		return pfn;
> +
> +	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +	if (!p)
> +		return 0;
> +
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, NULL, order);
> +
> +	pfn = PHYS_PFN(virt_to_phys(p));
> +	NODE_DATA(node)->vmemmap_tails[idx] = pfn;
> +
> +	return pfn;
> +}
> +
>   int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>   				       int node, unsigned long headsize)
>   {
> +	unsigned long maddr, len, tail_pfn;
> +	unsigned int order;
>   	pte_t *pte;
> -	unsigned long maddr;
> +
> +	len = end - addr;
> +	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);
> +	tail_pfn = vmemmap_get_tail(order, node);
> +	if (!tail_pfn)
> +		return -ENOMEM;
>   
>   	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
>   		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
> @@ -398,8 +427,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>   	/*
>   	 * Reuse the last page struct page mapped above for the rest.
>   	 */
> -	return vmemmap_populate_range(maddr, end, node, NULL,
> -					pte_pfn(ptep_get(pte)), 0);
> +	return vmemmap_populate_range(maddr, end, node, NULL, tail_pfn, 0);
>   }
>   
>   void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,


