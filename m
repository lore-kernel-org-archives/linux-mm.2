Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9FCCCF2D1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BED6B015B; Mon, 19 Jan 2026 05:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49B66B015C; Mon, 19 Jan 2026 05:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55B16B015D; Mon, 19 Jan 2026 05:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C139D6B015B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:04:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F5D71AEFF9
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:04:49 +0000 (UTC)
X-FDA: 84348279498.04.98CA727
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55BFB100008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:04:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N0NixxpQ;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768817087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUNED7yQden5fHwfN8ygPWiFWPP27Jsmq8Hxbg5NmZg=;
	b=KE4vKzfWyMTrt8CLVhqe8VzLT1nwIXvliKj5gCPlUksJl8JqHFcXLgbkC56wpZdfKQWlSL
	MaPqYkgL1zj8ow+lGs3DrirQnfVUOoLreeGBD4mddg0fHFb4IHmrPPXGYmO5iteCjJrrq2
	nZEmarQpSWOqACWfDyZ5jPUkvO5flhA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N0NixxpQ;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768817087; a=rsa-sha256;
	cv=none;
	b=n6o9sSWKcfPC8hmlSSEd2bYFgIRVmNasgmQiUwUZK+iCX8E2f4QGY5MDhdF8oneBkllujF
	b0SxWDXvb7eVtn1g4PndywbKnULfoLup8vdkY1VkaevI3VTDHyGFzuvLyEjkA0pEqmds98
	dAYB7+DLJGj/e6jcfUDCuAAYEPOdg/M=
Message-ID: <72e04317-913e-4db1-89ed-61727bbdd01e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768817085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUNED7yQden5fHwfN8ygPWiFWPP27Jsmq8Hxbg5NmZg=;
	b=N0NixxpQv1IqkZwRuDJ7HY9UUptTOiWRN42UCn0GtoHa2evInlAFSLO34y6UtO/4LZtCE4
	UQq618rtfMtT1ZsW+KxENeBAs7ou3bapu5r+4AfPoBzGDMflRu5n+cMFzfy8xWgXx09kOw
	gFOX5n/10f0COmg6MLGAYQy6LLD/KJw=
Date: Mon, 19 Jan 2026 18:04:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 09/15] mm/hugetlb: Refactor code around vmemmap_walk
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-10-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260115144604.822702-10-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 1hufiiamzzha9djhymw3ippo6rx7ojnd
X-Rspamd-Queue-Id: 55BFB100008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768817087-795918
X-HE-Meta: U2FsdGVkX1/BM611QrSaFKrIe2N3h07kkAUPlhRvJtQeAeGeZ5kwdmyaml8To40geWEkXiw/cBGP/RT0727tJ36ZJN18Q9MQQSl3jCZCEJ4M29dUV9NPyHD52MQP3lxo3TlSCXqFH1buFUqaW529wtdkrvwG+uLovpsvlStjz4K+ttyc9S47186CexmNrreiUSbEeh9AP9JI75TbM5hvxVkmSzNTCogho5T9OZPWookQG74FePtGrcPxpsmtuOmfHIvaP1NYkYBVqAF6R8bO4GLAUCIXv9C2nAHdedYrwGibYgG0pYXwfykYxZbkebV4GM4uh+qDpWGQ6HbLNNtYPw1i8V+1uhAKrFIJ6diMNh7VnI+wHhj7VLnEQc4lNdNK68XHa9Z0PxEJs7HcAfWJSHjWTQ5Ty4SVc7vte4b/qdG5t6GJhbr4Z3gpdNwKpcZFbsKsJ0NKy5mppMU/Ce+jrgoB+EegIFxnEggkcCm6As5tl350LAVJwgqbbhQLdZn7fBwIYTLBApm6Y/uVw4z5GxNhGIETMwpExyRgLMZLhd206Frop+wilNyKGhDH7jyKjflyyBmt4KIju2CGfryN5d4EKVTLlj76PH+mKb5lI3k+cTZ8I57TzJlSF25MxRTBqe7RJaJhL573T8w+ZtqPGVmOtpF/wntt9pq1ctSVnjOOxmEgLz4Shbc5VdjAbyxtEFwaYoCS2t67F4JnfKnd1D5k1dooTaYPGeviwY10C4FOCyD+UV+e4N/GWrQH5koEsuBCBsk3d8IHknWndzB9TCYxDiF5V3xMFIvtYzjW+S57a8QsPJIAtg5tOCPXbgzEhZDAV5odibe5MjjcRO3+7nuFNYurYD9/v0rmyGGatM3RirEFIqoymt27gEE/IOU0IZiQlBh7tj/BCjtyewgMPinjmRb2xL4L8RDxtmhza04hPreyskDL1DzuNnjiA4seTRiwIVQHd1cTgjhN+og
 dmasFAs9
 GK836K8NzzOVcFYoPKasxxC6q+9OTnnmFYHzZpHu8SUlNdbvneEnrvkbJ6kAAOgml8kZVfOecqzrFNMfwyrk7ugjLojvg/L98bD0of9tVTxjjcBWQZPuUvA8UAcnNjRV5WZ/AcA8tijPXEOqLIwnue0amlnUcO3Uskz3yZEFRkkhQR6boLiPG1Db2NQdJGHXkBm7ESMpTvHZf6kWQpGz941L2zvqIY+Wyu+1yQLIQP6maW+aunkkCIPHNi7jYnLwpqde5mlRxvVXc7QvjJmByUsrDBzBxitAbM64rb11jOgtTYz19zBic1kGfGcaf6zvWoDTToQ5HVE0GI0cXI2WHMZitTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/15 22:45, Kiryl Shutsemau wrote:
> To prepare for removing fake head pages, the vmemmap_walk code is being reworked.
>
> The reuse_page and reuse_addr variables are being eliminated. There will
> no longer be an expectation regarding the reuse address in relation to
> the operated range. Instead, the caller will provide head and tail
> vmemmap pages, along with the vmemmap_start address where the head page
> is located.
>
> Currently, vmemmap_head and vmemmap_tail are set to the same page, but
> this will change in the future.
>
> The only functional change is that __hugetlb_vmemmap_optimize_folio()
> will abandon optimization if memory allocation fails.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   mm/hugetlb_vmemmap.c | 198 ++++++++++++++++++-------------------------
>   1 file changed, 83 insertions(+), 115 deletions(-)
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba0fb1b6a5a8..2b19c2205091 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -24,8 +24,9 @@
>    *
>    * @remap_pte:		called for each lowest-level entry (PTE).
>    * @nr_walked:		the number of walked pte.
> - * @reuse_page:		the page which is reused for the tail vmemmap pages.
> - * @reuse_addr:		the virtual address of the @reuse_page page.
> + * @vmemmap_start:	the start of vmemmap range, where head page is located
> + * @vmemmap_head:	the page to be installed as first in the vmemmap range
> + * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
>    * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
>    *			or is mapped from.
>    * @flags:		used to modify behavior in vmemmap page table walking
> @@ -34,11 +35,14 @@
>   struct vmemmap_remap_walk {
>   	void			(*remap_pte)(pte_t *pte, unsigned long addr,
>   					     struct vmemmap_remap_walk *walk);
> +
>   	unsigned long		nr_walked;
> -	struct page		*reuse_page;
> -	unsigned long		reuse_addr;
> +	unsigned long		vmemmap_start;
> +	struct page		*vmemmap_head;
> +	struct page		*vmemmap_tail;
>   	struct list_head	*vmemmap_pages;
>   
> +
>   /* Skip the TLB flush when we split the PMD */
>   #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
>   /* Skip the TLB flush when we remap the PTE */
> @@ -140,14 +144,7 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
>   {
>   	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
>   
> -	/*
> -	 * The reuse_page is found 'first' in page table walking before
> -	 * starting remapping.
> -	 */
> -	if (!vmemmap_walk->reuse_page)
> -		vmemmap_walk->reuse_page = pte_page(ptep_get(pte));
> -	else
> -		vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
> +	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
>   	vmemmap_walk->nr_walked++;
>   
>   	return 0;
> @@ -207,18 +204,12 @@ static void free_vmemmap_page_list(struct list_head *list)
>   static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
>   			      struct vmemmap_remap_walk *walk)
>   {
> -	/*
> -	 * Remap the tail pages as read-only to catch illegal write operation
> -	 * to the tail pages.
> -	 */
> -	pgprot_t pgprot = PAGE_KERNEL_RO;
>   	struct page *page = pte_page(ptep_get(pte));
>   	pte_t entry;
>   
>   	/* Remapping the head page requires r/w */
> -	if (unlikely(addr == walk->reuse_addr)) {
> -		pgprot = PAGE_KERNEL;
> -		list_del(&walk->reuse_page->lru);
> +	if (unlikely(addr == walk->vmemmap_start)) {
> +		list_del(&walk->vmemmap_head->lru);
>   
>   		/*
>   		 * Makes sure that preceding stores to the page contents from
> @@ -226,9 +217,16 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
>   		 * write.
>   		 */
>   		smp_wmb();
> +
> +		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
> +	} else {
> +		/*
> +		 * Remap the tail pages as read-only to catch illegal write
> +		 * operation to the tail pages.
> +		 */
> +		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
>   	}
>   
> -	entry = mk_pte(walk->reuse_page, pgprot);
>   	list_add(&page->lru, walk->vmemmap_pages);
>   	set_pte_at(&init_mm, addr, pte, entry);
>   }
> @@ -255,16 +253,13 @@ static inline void reset_struct_pages(struct page *start)
>   static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
>   				struct vmemmap_remap_walk *walk)
>   {
> -	pgprot_t pgprot = PAGE_KERNEL;
>   	struct page *page;
>   	void *to;
>   
> -	BUG_ON(pte_page(ptep_get(pte)) != walk->reuse_page);
> -
>   	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
>   	list_del(&page->lru);
>   	to = page_to_virt(page);
> -	copy_page(to, (void *)walk->reuse_addr);
> +	copy_page(to, (void *)walk->vmemmap_start);
>   	reset_struct_pages(to);
>   
>   	/*
> @@ -272,7 +267,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
>   	 * before the set_pte_at() write.
>   	 */
>   	smp_wmb();
> -	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
> +	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
>   }
>   
>   /**
> @@ -282,33 +277,29 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
>    *             to remap.
>    * @end:       end address of the vmemmap virtual address range that we want to
>    *             remap.
> - * @reuse:     reuse address.
> - *
>    * Return: %0 on success, negative error code otherwise.
>    */
> -static int vmemmap_remap_split(unsigned long start, unsigned long end,
> -			       unsigned long reuse)
> +static int vmemmap_remap_split(unsigned long start, unsigned long end)
>   {
>   	struct vmemmap_remap_walk walk = {
>   		.remap_pte	= NULL,
> +		.vmemmap_start	= start,
>   		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
>   	};
>   
> -	/* See the comment in the vmemmap_remap_free(). */
> -	BUG_ON(start - reuse != PAGE_SIZE);
> -
> -	return vmemmap_remap_range(reuse, end, &walk);
> +	return vmemmap_remap_range(start, end, &walk);
>   }
>   
>   /**
>    * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
> - *			to the page which @reuse is mapped to, then free vmemmap
> - *			which the range are mapped to.
> + *			to use @vmemmap_head/tail, then free vmemmap which
> + *			the range are mapped to.
>    * @start:	start address of the vmemmap virtual address range that we want
>    *		to remap.
>    * @end:	end address of the vmemmap virtual address range that we want to
>    *		remap.
> - * @reuse:	reuse address.
> + * @vmemmap_head: the page to be installed as first in the vmemmap range
> + * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
>    * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
>    *		responsibility to free pages.
>    * @flags:	modifications to vmemmap_remap_walk flags
> @@ -316,69 +307,40 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
>    * Return: %0 on success, negative error code otherwise.
>    */
>   static int vmemmap_remap_free(unsigned long start, unsigned long end,
> -			      unsigned long reuse,
> +			      struct page *vmemmap_head,
> +			      struct page *vmemmap_tail,
>   			      struct list_head *vmemmap_pages,
>   			      unsigned long flags)
>   {
>   	int ret;
>   	struct vmemmap_remap_walk walk = {
>   		.remap_pte	= vmemmap_remap_pte,
> -		.reuse_addr	= reuse,
> +		.vmemmap_start	= start,
> +		.vmemmap_head	= vmemmap_head,
> +		.vmemmap_tail	= vmemmap_tail,
>   		.vmemmap_pages	= vmemmap_pages,
>   		.flags		= flags,
>   	};
> -	int nid = page_to_nid((struct page *)reuse);
> -	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
> +
> +	ret = vmemmap_remap_range(start, end, &walk);
> +	if (!ret || !walk.nr_walked)
> +		return ret;
> +
> +	end = start + walk.nr_walked * PAGE_SIZE;
>   
>   	/*
> -	 * Allocate a new head vmemmap page to avoid breaking a contiguous
> -	 * block of struct page memory when freeing it back to page allocator
> -	 * in free_vmemmap_page_list(). This will allow the likely contiguous
> -	 * struct page backing memory to be kept contiguous and allowing for
> -	 * more allocations of hugepages. Fallback to the currently
> -	 * mapped head page in case should it fail to allocate.
> +	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
> +	 * call which failed.  These are pages which were removed from
> +	 * the vmemmap. They will be restored in the following call.
>   	 */
> -	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
> -	if (walk.reuse_page) {
> -		copy_page(page_to_virt(walk.reuse_page),
> -			  (void *)walk.reuse_addr);
> -		list_add(&walk.reuse_page->lru, vmemmap_pages);
> -		memmap_pages_add(1);
> -	}
> +	walk = (struct vmemmap_remap_walk) {
> +		.remap_pte	= vmemmap_restore_pte,
> +		.vmemmap_start	= start,
> +		.vmemmap_pages	= vmemmap_pages,
> +		.flags		= 0,
> +	};
>   
> -	/*
> -	 * In order to make remapping routine most efficient for the huge pages,
> -	 * the routine of vmemmap page table walking has the following rules
> -	 * (see more details from the vmemmap_pte_range()):
> -	 *
> -	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
> -	 *   should be continuous.
> -	 * - The @reuse address is part of the range [@reuse, @end) that we are
> -	 *   walking which is passed to vmemmap_remap_range().
> -	 * - The @reuse address is the first in the complete range.
> -	 *
> -	 * So we need to make sure that @start and @reuse meet the above rules.
> -	 */
> -	BUG_ON(start - reuse != PAGE_SIZE);
> -
> -	ret = vmemmap_remap_range(reuse, end, &walk);
> -	if (ret && walk.nr_walked) {
> -		end = reuse + walk.nr_walked * PAGE_SIZE;
> -		/*
> -		 * vmemmap_pages contains pages from the previous
> -		 * vmemmap_remap_range call which failed.  These
> -		 * are pages which were removed from the vmemmap.
> -		 * They will be restored in the following call.
> -		 */
> -		walk = (struct vmemmap_remap_walk) {
> -			.remap_pte	= vmemmap_restore_pte,
> -			.reuse_addr	= reuse,
> -			.vmemmap_pages	= vmemmap_pages,
> -			.flags		= 0,
> -		};
> -
> -		vmemmap_remap_range(reuse, end, &walk);
> -	}
> +	vmemmap_remap_range(start, end, &walk);
>   
>   	return ret;
>   }
> @@ -415,29 +377,27 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
>    *		to remap.
>    * @end:	end address of the vmemmap virtual address range that we want to
>    *		remap.
> - * @reuse:	reuse address.
>    * @flags:	modifications to vmemmap_remap_walk flags
>    *
>    * Return: %0 on success, negative error code otherwise.
>    */
>   static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
> -			       unsigned long reuse, unsigned long flags)
> +			       unsigned long flags)
>   {
>   	LIST_HEAD(vmemmap_pages);
>   	struct vmemmap_remap_walk walk = {
>   		.remap_pte	= vmemmap_restore_pte,
> -		.reuse_addr	= reuse,
> +		.vmemmap_start	= start,
>   		.vmemmap_pages	= &vmemmap_pages,
>   		.flags		= flags,
>   	};
>   
> -	/* See the comment in the vmemmap_remap_free(). */
> -	BUG_ON(start - reuse != PAGE_SIZE);
> +	start += HUGETLB_VMEMMAP_RESERVE_SIZE;

 From the @start comment above this function, we can see that the @start
address is the starting address for the remap operation we want to perform.
However, the modification here does not conform to the semantics here.
Therefore, I suggest letting the caller __hugetlb_vmemmap_restore_folio()
pass the correct parameters itself.

The reason we previously used the reuse address here is that the
initialization of ->reuse_page was inside vmemmap_pte_entry. Now,
->reuse_page has been removed in your patch.

>   
>   	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
>   		return -ENOMEM;
>   
> -	return vmemmap_remap_range(reuse, end, &walk);
> +	return vmemmap_remap_range(start, end, &walk);
>   }
>   
>   DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
> @@ -454,8 +414,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>   					   struct folio *folio, unsigned long flags)
>   {
>   	int ret;
> -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> -	unsigned long vmemmap_reuse;
> +	unsigned long vmemmap_start, vmemmap_end;
>   
>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
>   	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
> @@ -466,18 +425,16 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>   	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
>   		synchronize_rcu();
>   
> +	vmemmap_start	= (unsigned long)folio;

(unsigned long)&folio->page？The folio is the metadata for contiguous pages,
while the page is our optimization target. Although their values are the
same now, their semantics are different.

>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> -	vmemmap_reuse	= vmemmap_start;
> -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
>   
>   	/*
>   	 * The pages which the vmemmap virtual address range [@vmemmap_start,
> -	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
> -	 * the range is mapped to the page which @vmemmap_reuse is mapped to.
> +	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
>   	 * When a HugeTLB page is freed to the buddy allocator, previously
>   	 * discarded vmemmap pages must be allocated and remapping.
>   	 */
> -	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
> +	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
>   	if (!ret) {
>   		folio_clear_hugetlb_vmemmap_optimized(folio);
>   		static_branch_dec(&hugetlb_optimize_vmemmap_key);
> @@ -565,9 +522,9 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   					    struct list_head *vmemmap_pages,
>   					    unsigned long flags)
>   {
> -	int ret = 0;
> -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> -	unsigned long vmemmap_reuse;
> +	unsigned long vmemmap_start, vmemmap_end;
> +	struct page *vmemmap_head, *vmemmap_tail;
> +	int nid, ret = 0;
>   
>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
>   	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
> @@ -592,18 +549,31 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	 */
>   	folio_set_hugetlb_vmemmap_optimized(folio);
>   
> +	nid = folio_nid(folio);
> +	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
> +
> +	if (!vmemmap_head) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	copy_page(page_to_virt(vmemmap_head), folio);
> +	list_add(&vmemmap_head->lru, vmemmap_pages);
> +	memmap_pages_add(1);
> +
> +	vmemmap_tail	= vmemmap_head;
> +	vmemmap_start	= (unsigned long)folio;

Ditto.

>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> -	vmemmap_reuse	= vmemmap_start;
> -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
>   
>   	/*
> -	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
> -	 * to the page which @vmemmap_reuse is mapped to.  Add pages previously
> -	 * mapping the range to vmemmap_pages list so that they can be freed by
> -	 * the caller.
> +	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
> +	 * Add pages previously mapping the range to vmemmap_pages list so that
> +	 * they can be freed by the caller.
>   	 */
> -	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
> +	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
> +				 vmemmap_head, vmemmap_tail,
>   				 vmemmap_pages, flags);
> +out:
>   	if (ret) {
>   		static_branch_dec(&hugetlb_optimize_vmemmap_key);
>   		folio_clear_hugetlb_vmemmap_optimized(folio);
> @@ -632,21 +602,19 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
>   
>   static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
>   {
> -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> -	unsigned long vmemmap_reuse;
> +	unsigned long vmemmap_start, vmemmap_end;
>   
>   	if (!vmemmap_should_optimize_folio(h, folio))
>   		return 0;
>   
> +	vmemmap_start	= (unsigned long)folio;

Same here.

>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> -	vmemmap_reuse	= vmemmap_start;
> -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
>   
>   	/*
>   	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
>   	 * @vmemmap_end]
>   	 */
> -	return vmemmap_remap_split(vmemmap_start, vmemmap_end, vmemmap_reuse);
> +	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
>   }
>   
>   static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,


