Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65F2C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 14:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915056B0099; Sat, 19 Sep 2026 10:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6056B009B; Sat, 19 Sep 2026 10:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5756B009D; Sat, 19 Sep 2026 10:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 587A76B0099
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:01:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B464380281
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:01:21 +0000 (UTC)
X-FDA: 85230673962.04.914183E
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92D9C100002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:01:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eIsV+EbB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789826479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHxim9R0CqQXtxjguN9DDW8Ut57tysjqxGZKFfVZIaM=;
	b=XMSiFiuU10fN8bemJgNgD/EKfcYaEmAWTJRmu8kTM+7iUQBDuoVyKqnfeRiWp0hwZka+hY
	uoa527U6kqnjP6LKohje0MxVo+4FnBY0hWlhzJljpx/o3+N0RLUzGCGLhOapSvxTbculcx
	cnQl3KMjFvkVaRPmCMcPRYk/JRrr414=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789826479;
	b=58rcKxRkhy8FRRKVlF0wTjSmGpNug/1/CciRm1WVvrMt26ffyVjRDfyMPWzW5YltDswPoW
	eQqzlIiO//lbyYyVf/oTYfDrB51VuF7PaHX6E1dVO7DnWuc0NyMTa16ojszeVQJa1gqm5p
	ATSH+6qbraZiskgV8HyRSVOD5lMFRKk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eIsV+EbB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rYDj48Z/2aku9l9SlVwNnxYms0Re8ox444qqDkUqQQg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789826476; v=1; x=1790431276;
 b=eIsV+EbBfLzgzTw8ptsZ7hwCnYC0quMp+ykEoo0LCBgIszEKcmbz5l8n6uuvaMzfNOBjk150
 RvK9a/Wp4ngrAI4QRnqU+R/bRlI5Wu9z1bP5QQpLd8MpfMj4wMgnE2hPHlfm/xYAwCRb71DN7Vn
 pzFWj5Z8Fn1g8BxacqeRTjjQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8aee96b0eadcf8c2;
	Sat, 19 Sep 2026 14:01:16 +0000
X-Mizu-Trace-ID: 8aee96b0eadcf8c2
X-Migadu-Flow: FLOW_OUT
Message-ID: <186ee2ba-daf3-4120-a3e3-101cac1ff5a1@linux.dev>
Date: Sat, 19 Sep 2026 22:01:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-2-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260913083734.86802-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 92D9C100002
X-Stat-Signature: stj6tgbhehkkdg1ug6jk9hrawp6k81rf
X-HE-Tag: 1789826479-432803
X-HE-Meta: U2FsdGVkX18lQocJt7eScgPbEPD0zDQoMeV6ZIgpYNTd3c608i50iGysZBc+KhHmPcSjHSW029S5MRqgeuLtwIjBOHyU4eZ3kNj9+Jsa/Ck3ByKxNufDnstGlvXKRkMjeTEpe/Bxq91TwNEkFu0a1UFMBY1FRgmdX+g3G0eibRmoHrO9Suu/PhOjQtbDjIoY8qYdL2joRkwPXynWMH5eUn0ABxad5YfZNO6qcoOc/lNkMSA4GJWKFMFqN4aT2dT0yNgyA9erSTNCXIcEv1/6cksniJ8HL06abqYekgf2J4y9O23A9gilXNp0NBwHigHyZW+tJpYlEjhcJ8NQ/4nh2VuDEoBEvjoinSv+OjQeeKW85vf4xemJ367W0IWcg3L4cTGb350Al4V1lb4cucRe76xmoiKrc0PuFqe9VOvxGB4nVVgtGdNJD50QJ2eGFlmvGxwzy56T0xoiP3tYOyM8xs5zmrPsLXCsNZ/NE4DX+fD6RzCy5bIPNDDzfQ3HOkNHdO5JUMVK2FgGV296wP87l6Cyts7hTWMILCK8Y9jklBbxtnM3HPndiuCIIVAxBjAD79cafRTk3D1OaAWfAe0UgFdHVoRx44Oc592JMCNimBgMNpy5ah5nZGYINuEiNVlvsJGdU2q9u6qeJWW9S2uDSzdBq/6GQ3eNvWk6QO9g9313IXBW6G3xOlRZ/JWQAXKuThaNlFfF+URXZ8H7s48VgDHeS6ZDXadix7IPRuW3ZOkdRGV9FKmS1ShbEaEaIokckSIqxAwp3LrBo2pllhshvfqlbffs9prbVgKJNdpZtThF8siJRfZwIewjnNEMezPy2FRTrTUa2N1mmgjHwX7+6yftfwfMpXd3m+znf1OvttGcMrKgJRUFMfLYsBPGeL8Zz2iaa9DRdeb3iXgNxEDxa5w5MIaCk5+3HxUHDPBHr/cpTroQVYl6lXfmHcA4lo349mG2INV8NRXhDp+kHqt
 Sh8MFkVH
 s+FvOQYgvz28oLpUCrHVGXk/pwg3QJqe6xWRUmucDWFKacuJYN6YBEnTD9T3eRiITEbt8AsjeeW5AMIFcw93ELPLi9Jweq3+lsyGGrunUdHs0ApNv1yCLGgIpRA26/4SYAe5ZyycZAQeOYXLQyUQaruLkjnSZ7237Tv2WCUJvOtzH1MTv2CBtQ+916FRDJaVvidlnQXPdSBdoHq68IRXGvGl47jdtXXSnKt5DQaL1NB1r8IkPBqRMBtmJb4/jPpfNaRhoh5BNugGd/ruHFnmJLPHQ2x/pBhmpj5ROj4IKT3/5/e2oEKk1ZUl1L3KNRIF4Gsu9Euq38FLBoVATafa2+jjp5eQUvdxMOrva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/26 4:37 PM, Muchun Song wrote:
> VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in two
> places: it keeps allocations on the normal path and takes a reference when
> a backing page is supplied for reuse.
> 
> After Device DAX switched to the common per-zone shared tail page, both
> conditions can be determined locally. DAX supplies ptpfn for every shared
> tail mapping and requests an allocation only for compound head mappings,
> whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
> selects the correct allocation path.
> 
> When ptpfn is supplied, the caller is reusing an existing backing page.
> Once the slab allocator is available, take a reference for each reused

Does the availability of slab mean the buddy allocator is already being
used? Could there be a window where the buddy allocator is functional
but slab hasn't become available yet?

> mapping to balance the release performed by vmemmap_free(). Early mappings
> are backed by memblock/reserved memory and do not need page reference
> accounting.
> 
> Remove VMEMMAP_POPULATE_DAX and the flags argument from the vmemmap
> population helpers.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 36 +++++++++++++-----------------------
>   1 file changed, 13 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 96506f594924..878d29a4e862 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -32,12 +32,6 @@
>   #include <asm/dma.h>
>   #include <asm/tlbflush.h>
>   
> -/*
> - * Flags for vmemmap_populate_range and friends.
> - */
> -/* Vmemmap population for ZONE_DEVICE compound pages */
> -#define VMEMMAP_POPULATE_DAX		0x0001
> -
>   #include "internal.h"
>   #include "mm_init.h"
>   #include "sparse.h"
> @@ -208,7 +202,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
>   }
>   
>   static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
> -		struct vmem_altmap *altmap, unsigned long flags)
> +		struct vmem_altmap *altmap)
>   {
>   	struct zone *zone;
>   	struct page *page;
> @@ -218,7 +212,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
>   	 * Device DAX still relies on vmemmap_populate_compound_pages() for
>   	 * head/first-tail allocation and tail-page reuse.
>   	 */
> -	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
> +	if (!vmemmap_optimizable_pfn(pfn))
>   		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>   
>   	zone = pfn_to_zone(pfn, node);
> @@ -230,8 +224,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
>   }
>   
>   static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -				       struct vmem_altmap *altmap,
> -				       unsigned long ptpfn, unsigned long flags)
> +		struct vmem_altmap *altmap, unsigned long ptpfn)
>   {
>   	pte_t *pte = pte_offset_kernel(pmd, addr);
>   	unsigned long pfn = page_to_pfn((struct page *)addr);
> @@ -240,7 +233,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   		pte_t entry;
>   
>   		if (ptpfn == (unsigned long)-1) {
> -			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
> +			void *p = vmemmap_alloc_pte(pfn, node, altmap);
>   
>   			if (!p)
>   				return NULL;
> @@ -255,7 +248,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   			 * and through vmemmap_populate_compound_pages() when
>   			 * slab is available.
>   			 */
> -			if (flags & VMEMMAP_POPULATE_DAX)
> +			if (slab_is_available())
>   				get_page(pfn_to_page(ptpfn));
>   		}
>   		entry = pfn_pte(ptpfn, PAGE_KERNEL);
> @@ -318,8 +311,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>   
>   static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
>   					      struct vmem_altmap *altmap,
> -					      unsigned long ptpfn,
> -					      unsigned long flags)
> +					      unsigned long ptpfn)
>   {
>   	pgd_t *pgd;
>   	p4d_t *p4d;
> @@ -339,7 +331,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
>   	pmd = vmemmap_pmd_populate(pud, addr, node);
>   	if (!pmd)
>   		return NULL;
> -	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
> +	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
>   	if (!pte)
>   		return NULL;
>   	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
> @@ -350,15 +342,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
>   static int __meminit vmemmap_populate_range(unsigned long start,
>   					    unsigned long end, int node,
>   					    struct vmem_altmap *altmap,
> -					    unsigned long ptpfn,
> -					    unsigned long flags)
> +					    unsigned long ptpfn)
>   {
>   	unsigned long addr = start;
>   	pte_t *pte;
>   
>   	for (; addr < end; addr += PAGE_SIZE) {
>   		pte = vmemmap_populate_address(addr, node, altmap,
> -					       ptpfn, flags);
> +					       ptpfn);
>   		if (!pte)
>   			return -ENOMEM;
>   	}
> @@ -369,7 +360,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
>   int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>   					 int node, struct vmem_altmap *altmap)
>   {
> -	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
> +	return vmemmap_populate_range(start, end, node, altmap, -1);
>   }
>   
>   /*
> @@ -498,7 +489,6 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   	unsigned long size, addr;
>   	pte_t *pte;
>   	int rc;
> -	unsigned long flags = VMEMMAP_POPULATE_DAX;
>   	struct page *page;
>   	unsigned int order = pfn_to_section_compound_order(start_pfn);
>   
> @@ -508,14 +498,14 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   
>   	if (reuse_compound_section(start_pfn, pgmap))
>   		return vmemmap_populate_range(start, end, node, NULL,
> -					      page_to_pfn(page), flags);
> +					      page_to_pfn(page));
>   
>   	size = min(end - start, (1UL << order) * sizeof(struct page));
>   	for (addr = start; addr < end; addr += size) {
>   		unsigned long next, last = addr + size;
>   
>   		/* Populate the head page vmemmap page */
> -		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
> +		pte = vmemmap_populate_address(addr, node, NULL, -1);
>   		if (!pte)
>   			return -ENOMEM;
>   
> @@ -525,7 +515,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   		 */
>   		next = addr + PAGE_SIZE;
>   		rc = vmemmap_populate_range(next, last, node, NULL,
> -					    page_to_pfn(page), flags);
> +					    page_to_pfn(page));
>   		if (rc)
>   			return -ENOMEM;
>   	}


