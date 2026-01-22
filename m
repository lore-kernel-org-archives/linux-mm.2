Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7DFC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF636B010E; Thu, 22 Jan 2026 03:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014C36B010F; Thu, 22 Jan 2026 03:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85A06B0110; Thu, 22 Jan 2026 03:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9976B010E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:08:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3944A1401D2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:08:36 +0000 (UTC)
X-FDA: 84358873032.12.CAFEF71
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69ACE4000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:08:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cZQtlG3/";
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769069314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhK7lOPBb/DUFBF0iE4JwY1SUH06ZO3BrkL1fE4vwkc=;
	b=xDrBRh4qM0VuRWVGg2Q5VPGyAeatYd+NSSkkNOAqAUBGqjo5jeXwV55DvaFm+YBWZOUxLk
	FRxo+3mEomBwfR0YqCyB93VtAppjeAwOxfQUK0Yc5cSCKYQcctWTY3hsMbNxohU2YCqJE9
	61vylGS5L0PPMEGp1eTGBtijMp7H92w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cZQtlG3/";
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769069314; a=rsa-sha256;
	cv=none;
	b=Whmezu7wVK6nUA3nSj28Ib7zcgvp+ApRMdNUt0lQjgi8uj/VSo1WtiKOpcfBIfwIQGNPO1
	sL6qcGqPIuklySO80l4j23gydMKYkc5VSoDUKqlXSmmE1PMmbuDPO3w5OaS7scSkTJ4JeX
	HjaCsUiXZNqFY5j/YUUy1l66ztem4ws=
Message-ID: <118d506b-797b-47d3-a411-e708963c018e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769069311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhK7lOPBb/DUFBF0iE4JwY1SUH06ZO3BrkL1fE4vwkc=;
	b=cZQtlG3/V0LVRJbMWxkC8AFLxmsNzPRkvEZlIOz+Z5/VJzCLZlwj7Sp95kb1F61o2+2/MV
	QmkWwT/1FrsBcoObOQjzt6b4XBFw7Y9k15/kTe/FNP6uaZzGo5r2VFH3kGacHEFEEuTP5k
	cGcoEzk+NnLto6DbUjWhq2YGbJd+XBk=
Date: Thu, 22 Jan 2026 16:08:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv4 08/14] mm/hugetlb: Refactor code around vmemmap_walk
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
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-9-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260121162253.2216580-9-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: w58auez9kzczwresq1ednourc31o1t93
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 69ACE4000F
X-HE-Tag: 1769069314-646547
X-HE-Meta: U2FsdGVkX18vC3wdybNuMgIVqHrKEz7vkbmYGTYJiO27YHzp1HLUJu6+LODzkXd68qNecA2OFB435o5U96nlKWLD6gtr18SFroWWSxo0kyBxkY1iG1FW4hm9L8RjL6VznmCr30lYsglVHOlZNYy0UvNVSv8uqlGUidXTQhieNP/82zsCWWAkwAzr3FZA1NGXTT04jBxD04k9OuztR6e5J2TzO0x+AYhVRiQBUxq9eiCYoq9SDIpEniogUv8zZ9vGKiLT6eJNw5qrk54dEuoeTOonVxJGVApd8VYVpqrsX2iAtx/ihzCTRp5l+KFSFU5HhvZgfQQGH6G5RxyKSudAoMszoMrQCtsyjp2suxpa/WSAMvFZ4G9q1TwjgYrbrMvjw1CkXJzrG6TKhOU2kJbD2zrl0E3glTu8aL0VAK8QYGtGLzuUe/X+Y1gKlzEfe9unZMi2OYHuGmvMPqhBNxzrI+dF1UIz28UatgQMteQMmSQC7DRh8YjFGoZ4EdwdaUf8bUE2j0kCSw4lG9EMXKULec4Ro1ZLk82otGcIPODaLz59WsEuTLdnLVNquGo2by+V+EnRe+Nfx/KEfObAlDy1DealY/YNFCkkt85OlUGvrXynJ5D7v/VhzHkZwhx2dcGLwzQt8xqIj98cO130sh/yhQvOGW6235naZV6n2kinpq0o4Q8AofPHjnBuSXTE6sle0YrucI8ZdyTg+OYLyqt2+MGgiJI1DcjVdu0UKpBLvFxj/MT9FI30lyYL26o0MOE/EB2tI12FadBXMAqKQV1gbJXTqUU/OWgLgfZbT+mKWLyE+ejhiKtIYUWPRg+JXKyWnzS0gI3xl4/cdsDgu2TvzLkiyJwSpmBOsQ/XgN6A91ERVu0B/Hm4k/4nXs7yDFtuBYBolWX4s+Hgiy14hdewjdILaTg00F0beokxFOUayIY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/22 00:22, Kiryl Shutsemau wrote:
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
>   mm/hugetlb_vmemmap.c | 200 ++++++++++++++++++-------------------------
>   1 file changed, 84 insertions(+), 116 deletions(-)
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba0fb1b6a5a8..a51c0e293175 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -24,8 +24,9 @@
>    *
>    * @remap_pte:		called for each lowest-level entry (PTE).
>    * @nr_walked:		the number of walked pte.
> - * @reuse_page:		the page which is reused for the tail vmemmap pages.
> - * @reuse_addr:		the virtual address of the @reuse_page page.
> + * @vmemmap_start:	the start of vmemmap range, where head page is located

For vmemmap_remap_alloc case, @vmemmap_start is not head page address.
Now I am considering if @vmemmap_start is needed.

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

We can replace this check with

     vmemmap_walk->nr_walked == 0 && walk->vmemmap_head

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

And you've remoed walk->vmemmap_start in the next patch, so we
no longer need the ->vmemmap_start field.

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
> @@ -415,29 +377,25 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
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
> -
>   	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
>   		return -ENOMEM;
>   
> -	return vmemmap_remap_range(reuse, end, &walk);
> +	return vmemmap_remap_range(start, end, &walk);
>   }
>   
>   DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
> @@ -454,8 +412,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>   					   struct folio *folio, unsigned long flags)
>   {
>   	int ret;
> -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> -	unsigned long vmemmap_reuse;
> +	unsigned long vmemmap_start, vmemmap_end;
>   
>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
>   	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
> @@ -466,18 +423,18 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>   	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
>   		synchronize_rcu();
>   
> +	vmemmap_start	= (unsigned long)&folio->page;
>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> -	vmemmap_reuse	= vmemmap_start;
> -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
> +
> +	vmemmap_start += HUGETLB_VMEMMAP_RESERVE_SIZE;
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
Do not need a new line here.
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
> +	vmemmap_start	= (unsigned long)&folio->page;
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
> +	vmemmap_start	= (unsigned long)&folio->page;
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


