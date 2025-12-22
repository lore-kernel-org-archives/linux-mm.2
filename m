Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50AEEE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 05:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A762A6B0088; Mon, 22 Dec 2025 00:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23F26B0089; Mon, 22 Dec 2025 00:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9051C6B008A; Mon, 22 Dec 2025 00:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF2E6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:55:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10D2E13BF5F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:55:16 +0000 (UTC)
X-FDA: 84246044232.10.F576CA9
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id 035B94000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:55:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b7swFmx7;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766382914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrIiaXvFV2Kj5IoCYVW/HtbsF4Zdh/yGxf27rjutQo8=;
	b=YRF6Cr6uvXKUzc8Vv9F1JDmPFw6ZgW90n1EXOk/BpjzRtxDYYWcbFFZbZgQDMDQcIVfJYz
	axAgkcbALRZScg9KG4wNjYJzZgx+PlYE2Z9t0yh/u8+gmBGKvaqkJfvWZNL3C+Ptst/Loq
	i772XCkc5o5u0H/WPGoZ1sZsgEuQ9wI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b7swFmx7;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766382914; a=rsa-sha256;
	cv=none;
	b=R2YQ3g24XFnis5lzBkAtgXHQyZZWDLD/zwlg3TPoM7NOUrX4OpIXdGPD4iQswAM0R44y2/
	mmV4+dID8IQTeLGCn17TwLvvKMk3Wt9dKYR3eLG/3tZ/eUScKOEnicTxUxRRVWN/nMrA70
	rXlwmFcVAyeURp3yp0ao4XS7nQhQWQg=
Message-ID: <027c07cd-e2cf-4b00-be21-54faa5cbaead@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766382910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hrIiaXvFV2Kj5IoCYVW/HtbsF4Zdh/yGxf27rjutQo8=;
	b=b7swFmx7jZZu1RNS37wuC6fLBhswNqLq3vycI9jnH5+V8qV5SwFZ0hnTsVanemkuGSabD2
	g3J0oHnTLsl//mK/k65R1mR9Kl+Euo4GMI/YZ6P5ky5/LEJktkz86qs7MySb1ocRj+Mc3y
	MVwmeC5aLDDY1l9H5ka5monA2iK5smQ=
Date: Mon, 22 Dec 2025 13:54:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv2 08/14] mm/hugetlb: Refactor code around vmemmap_walk
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
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-9-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-9-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 035B94000A
X-Stat-Signature: normi4sqo96xttjmnxewkr5hm9ypms44
X-Rspam-User: 
X-HE-Tag: 1766382913-553550
X-HE-Meta: U2FsdGVkX19J+3Y7r8UXCRsyqu/XLgIEF8Ajrg8CclC9vUqJXqJGsR7OTT+/EB/MH0ThkxJdeObLqnESp9paFMVL3T/8B+D4Jz0HMAI8zKM0PqHxnFkZn5fCERJ57zWPjfjkykoRF0FL47sfqgWYkbRxBqHEjiZWAoLS6JyC7mmHgRF3AAGYa5MxgGOb63Iu2vLDUXoktUHhwF+8ukIVg+l93iDqaWBA0gyH71ryZWm1tAQdLx7+lKPrJu4fMdvEXAQFFHq7QBE1geou8fif07DTkGUwsEA0OnDrK3XM3X8nJ7CLRZiX/xM/WX85DqCkbU4zpH8PhKt6UoNSHmzA26feW4X0yINep117fbX19Be6EVzbwAxgYzIH00N1q+60Bg64/l8g2v2HpL5ttchNdfKHVZgnIDM+1QdiaaOnMppi7brHtW7AEfjDphPlNlFUH5W7sWEgzUd3ov1fxFUmF7p3R/917qJiI7A9EzHX0yyxZQwlZsGUPfeFVpQtOLGJRfoZQrLuY/EPKNJA4fhtP8ftYZ4YjR5jNdCzuz0Lt1kcMILyjA+AqhDaVicerx7fJN/Jg9fag7SDcdk+rA66QFy/+iIbUxGUAaXUBr3GUoN2FlH55QwpIE3R3ZOEJ8If1/cgKBkmFQrjTSLPAtxtHcjFBWCxKY/ejz63rdYixfdGWdwI6b5Hnk0eeOTQGm09gd1t/rqJWwSG01Lm3pl9ioMbOeQctzvo6PPAgaxEfgDwHsCh+DmGGK6/ryWnYEjJmRQBkZp/FOO5T3GIXgAdlrrBd+dLEze5y6I49TvVzptyxtyBtNxdG+wN9FMgImD4rlaEn2yofvH3Zj3103h/+6wrK8ISQyiLa7pzF+p7Q1nQ9e0jUuYyKLTat9d5Lou3JE5W9gvdhiRey1PuZTEKO3mHs0Klr3Rs5jPjnG3t69OhsCB6/vOMj2zhjMrOKvC6TUPS0Qm6NkV88h6pTNo
 2eA5KsYF
 Ohse70w4/YPsOPQ400Mn+x4guwhKDxZZHyCB6Q7xyykUtc5o9SMPHMld6wi4EvSbBeDR5RZOjVWD6w8TYzEBlGwrarD1SCAL/0Nw+9JtMGbC1d2F/vQMKLn/MybXnrXS8hRzSowhHYDEVoLAJBKyxrM7ilvGPQQjWNy2WyzEPq+FkhA5CU23coouDFPulN2B/khbkqhOGHE8slm/Sej+X312uEqEzsQlvMVAl1LhwQ6cZeAPaq1CjxwOVoou9DuntfEmy0eaiga5FBcLAOaAiYi71KnTbxHwKWvTmU9WbjE0oFhmwZip4FEl3jBC5AH3VRfQxGZILWoZJ/KNnlKL2w7OhBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 23:09, Kiryl Shutsemau wrote:
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
> index ba0fb1b6a5a8..d18e7475cf95 100644
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
> +	vmemmap_remap_range(start + PAGE_SIZE, end, &walk);

The reason we previously passed the "start" address
was to perform a TLB flush within that address range.
So he startaddress is still necessary.

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

Why did you choose to change the gfpmask (previous is
GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN)?

> +
> +	if (!vmemmap_head) {
> +		ret = -ENOMEM;

Why did you choose to change the allocation-failure
behavior? Replacing the head page isn’t mandatory;
it’s only nice-to-have.

> +		goto out;
> +	}
> +
> +	copy_page(page_to_virt(vmemmap_head), folio);
> +	list_add(&vmemmap_head->lru, vmemmap_pages);
> +	memmap_pages_add(1);
> +
> +	vmemmap_tail	= vmemmap_head;
> +	vmemmap_start	= (unsigned long)folio;
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


