Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49047106ACE8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4B06B00B1; Thu, 12 Mar 2026 16:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575CC6B00B4; Thu, 12 Mar 2026 16:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458136B00B6; Thu, 12 Mar 2026 16:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 328E76B00B1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:33:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8DD68B61A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:33:09 +0000 (UTC)
X-FDA: 84538560498.24.697DBF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id EF3C580003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:33:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hVZPbifh;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1SYKUK3h9HQxJj/SrC73vsf1D1uzzxPrV73nJRh4Rg=;
	b=iEcfEWBFvJnH8LwrfpWOwLwV1yRdLsZ09eryorA3Uz1V9xTPvtzD4UJhhocfZRz7QZ7aQa
	hNXzHBbdyZL8kSj+/+VG9GNviXyzOJX6bOwIlQdIVEzF2CQdtd8q6jOL+8kbixBcrWUivQ
	RfI6QRUKp/p9Jg9MWd8Elc9GcTl+ok8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hVZPbifh;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347588; a=rsa-sha256;
	cv=none;
	b=H2lCmPK89UMls+xTdxEC5NssSrNsGs3BtZh4oNE8tdie7L1tPO5A4vREeEm81RTF/+dJRE
	iUGuOm5YywQSVr4sTKO9nB7jEZkqkWtgVNtZlvN+tpvXP4YyhYLTQ4TfAfCIxiKEI5FDq9
	fMlefxS0f04tM4etWTqtT95yeR/n18Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8DF540C36;
	Thu, 12 Mar 2026 20:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09615C4CEF7;
	Thu, 12 Mar 2026 20:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347586;
	bh=2+L+ZS0AMTFpKwucUPi74qcF8QC5ORqWGhEsI3ZCutY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hVZPbifhlSYK3PAbAHd3TVP//vQbkBtqOH9hLQsUhjNwKQfbiZRM9yOwLyJSB41eB
	 HOxiTiZTnwNQqNNgvbaevJgElfxVnVqMVPErijY9k3BdEWWBMHLGjutXjn9bBmv8hH
	 5Il9g+YJHQVc9lbjY+Etk5qy4hJI0eeDaQXqPs4UEi1JLdtPuEbcZhhlm4L5afh80A
	 D+lPiM3+9qsEW30LcSsD8xoqvGa0uOO4exeLRAUW7Lf4+wg/l9cd5qrUkV+UtFYM4E
	 772YxTEUn1R+wWbyliZZ9x6htmTIshibPlNaFOHBIx4XeuAgMUzUtAyG4O0p3Chz98
	 pVIAf4ioHazGQ==
Message-ID: <8a4568de-e0f9-471b-bc94-1062d4af3938@kernel.org>
Date: Thu, 12 Mar 2026 21:32:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032347.232939-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032347.232939-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EF3C580003
X-Stat-Signature: x5iyqo5xe4ima5ck416mp8a4atk5szt8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773347587-172169
X-HE-Meta: U2FsdGVkX19Nd9OtPc0yThaG9QuYdP3iRj6IjqmHPe23WMU7Wl3oiwp42orJk01onEoeMV/TyRWxXbr1sQ25itaC4ebn3zrKsiv0pbK2JcwPdzVUFOodw67DK3MOLXVVL53GlF1qwMLuQ85zu7t5c7pJML8Cel7mqCfqKSboC3IdVCd0yQumLDwMCAeYNJZMhPG62QHpctnxif9Y+fyQCja7Mdwu/12dQdXhr7Ox3tvLE/glTyOeak4V7c7sSh425BKbQgTanp6YDKlVywykKGEcmHxopi4w3jZXK3fQnU8NJ6yIxFlZTsiIGixg4kw3YSEQHb12yo8XwGBu7wvFDXIHFGuK422HGTk9PokLO1ejMW6IdbnQ6SnHNIzxNTPWQApzhir3Tk3n+MlXhr1P5VQVrInlQlcF51x2czaVPufFp1V6LVo9FIoXIh7bexZUzeifjKKweXgjemG9oGDeN0ZAMkim1OgHwFoJ+OEuvYzFLVzeH5LNUesKq5GhJkf/Gyb98XLjLKclNC1zDuf7NBWffXu4la6Q7fGkH9FarAgcTU22JylV/w/sGxyTAEWjqeTtPNPjd5lhngNvNh/RhJC/RkOnHegUi2uioj6DgyrMOxxKa3OGSnaH9k4cKFLHtVfK1f4Giff/F/h5ljaSMr2AyAxMfBiObG1ggQKCBRSJGc49OW4yw3veWSHlNoUG/lfkIN33zNYrpMP4wQtrJCZsnGpeopkqJG+sCuIffHYt6rTYdxllc112NCMqMuZFPMCOJPzCxDS0sUMRxwwZpr3khmuUS4GxPwocjqp9z4evG93AYcAlSeSTVpiAgYcE+mrzqkoblUhn3+H9EoM4i0verExm6Z9HVFFicQPpp+l5YuCJTROliOqjO/6HN/3s2eO06tRYvTM28LCC95pJvGdPhNBtDbXC043mvx2s02R4ahktomLDNRhJVc/+OJNj+YdwpHtaHu/pRknE5Eo
 cwpyySsU
 Tg/+CPE9AnzCgjepIL0GwtWmy/Yw6y4VKsxYqOzi2brQZ1Ervh3X83L2srIWFO3hqp+HWLaUv9nn0IpsNUuRR7yeRY1JWk09q9ofT2e1+y9o5pZyf+wIwEjpwCUnEA64nu2HeTj/3m5mqyiDIXBqXJiZnogrPGzU4VjtWsVc3WCt/Jul8MG+4+luUc+zUOk9we7/i3/92AHhXZB748Ky0VkEc7o3watZ7a9KNe62EnMRssd4izzM82W+mXML2GEPBB+V89nRn92Ldcsa4X2/APC/4fZ5y9dXtMexlpDTMbCOE0Tiqnp8i6uECp7JwTwgSRxT+hYVtEEfP0yMjprl9gefZ6t/O6rblktvMcAoCA4vjx/Gro73SYnD6qMtLWFDFBlEbcZGgMwZojnqUmoVYlItByJjww5JF1l44AWOzmZc59PScYIgxJKu7lxoD8PbRiS3BIoLqsQORebYHkTUj1amBl5jJuTtonJqBvPp/l5heMV1oMwLVxH8Ef5J9ZORnBUnUVVcZu6BYDZfljNCd0D8ghw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:23, Nico Pache wrote:
> generalize the order of the __collapse_huge_page_* functions
> to support future mTHP collapse.
> 
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.
> 
> No functional changes in this patch.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 73 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 47 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a9b645402b7f..ecdbbf6a01a6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -535,7 +535,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
> -		struct list_head *compound_pagelist)
> +		unsigned int order, struct list_head *compound_pagelist)
>  {
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
> @@ -543,15 +543,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
> +	const unsigned long nr_pages = 1UL << order;
> +	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);

It might be a bit more readable to move "const unsigned long
nr_pages = 1UL << order;" all the way to the top.

Then, have here

	int max_ptes_none = 0;

and do at the beginning of the function:

	/* For MADV_COLLAPSE, we always collapse ... */
	if (!cc->is_khugepaged)
		max_ptes_none = HPAGE_PMD_NR;
	/*  ... except if userfaultf relies on MISSING faults. */
	if (!userfaultfd_armed(vma))
		max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);

(but see below regarding helper function)

then the code below becomes ...

>  
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			     none_or_zero <= max_ptes_none)) {

...

	if (none_or_zero <= max_ptes_none) {


I see that you do something like that (but slightly different) in the next
patch. You could easily extend the above by it.

Or go one step further and move all of that conditional into collapse_max_ptes_none(), whereby
you simply also pass the cc and the vma.

Then this all gets cleaned up and you'd end up above with

max_ptes_none = collapse_max_ptes_none(cc, vma, order);
if (max_ptes_none < 0)
	return result;

I'd do all that in this patch here, getting rid of #4.


>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -585,8 +587,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> +			/*
> +			 * TODO: Support shared pages without leading to further
> +			 * mTHP collapses. Currently bringing in new pages via
> +			 * shared may cause a future higher order collapse on a
> +			 * rescan of the same range.
> +			 */
> +			if (!is_pmd_order(order) || (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared)) {

That's not how we indent within a nested ().

To make this easier to read, what about similarly having at the beginning
of the function:

int max_ptes_shared = 0;

/* For MADV_COLLAPSE, we always collapse. */
if (cc->is_khugepaged)
	max_ptes_none = HPAGE_PMD_NR;
/* TODO ... */
if (is_pmd_order(order))
	max_ptes_none = khugepaged_max_ptes_shared;

to turn this code into a

	if (shared > khugepaged_max_ptes_shared)

Also, here, might make sense to have a collapse_max_ptes_swap(cc, order)
to do that and clean it up.


>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>  				goto out;
> @@ -679,18 +687,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  }
>  
>  static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> -						struct vm_area_struct *vma,
> -						unsigned long address,
> -						spinlock_t *ptl,
> -						struct list_head *compound_pagelist)
> +		struct vm_area_struct *vma, unsigned long address,
> +		spinlock_t *ptl, unsigned int order,
> +		struct list_head *compound_pagelist)
>  {
> -	unsigned long end = address + HPAGE_PMD_SIZE;
> +	unsigned long end = address + (PAGE_SIZE << order);
>  	struct folio *src, *tmp;
>  	pte_t pteval;
>  	pte_t *_pte;
>  	unsigned int nr_ptes;
> +	const unsigned long nr_pages = 1UL << order;

Move it further to the top.

>  
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> @@ -743,13 +751,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  }
>  
>  static void __collapse_huge_page_copy_failed(pte_t *pte,
> -					     pmd_t *pmd,
> -					     pmd_t orig_pmd,
> -					     struct vm_area_struct *vma,
> -					     struct list_head *compound_pagelist)
> +		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> +		unsigned int order, struct list_head *compound_pagelist)
>  {
>  	spinlock_t *pmd_ptl;
> -
> +	const unsigned long nr_pages = 1UL << order;
>  	/*
>  	 * Re-establish the PMD to point to the original page table
>  	 * entry. Restoring PMD needs to be done prior to releasing
> @@ -763,7 +769,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  	 * Release both raw and compound pages isolated
>  	 * in __collapse_huge_page_isolate.
>  	 */
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> +	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>  }
>  
>  /*
> @@ -783,16 +789,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>   */
>  static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> -		unsigned long address, spinlock_t *ptl,
> +		unsigned long address, spinlock_t *ptl, unsigned int order,
>  		struct list_head *compound_pagelist)
>  {
>  	unsigned int i;
>  	enum scan_result result = SCAN_SUCCEED;
> -
> +	const unsigned long nr_pages = 1UL << order;

Same here, all the way to the top.

>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iteration.
>  	 */
> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +	for (i = 0; i < nr_pages; i++) {
>  		pte_t pteval = ptep_get(pte + i);
>  		struct page *page = folio_page(folio, i);
>  		unsigned long src_addr = address + i * PAGE_SIZE;
> @@ -811,10 +817,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
>  
>  	if (likely(result == SCAN_SUCCEED))
>  		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
> -						    compound_pagelist);
> +						    order, compound_pagelist);
>  	else
>  		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> -						 compound_pagelist);
> +						 order, compound_pagelist);
>  
>  	return result;
>  }
> @@ -985,12 +991,12 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>   */
>  static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
> -		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
> -		int referenced)
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		pmd_t *pmd, int referenced, unsigned int order)
>  {
>  	int swapped_in = 0;
>  	vm_fault_t ret = 0;
> -	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>  	enum scan_result result;
>  	pte_t *pte = NULL;
>  	spinlock_t *ptl;
> @@ -1022,6 +1028,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  		    pte_present(vmf.orig_pte))
>  			continue;
>  
> +		/*
> +		 * TODO: Support swapin without leading to further mTHP
> +		 * collapses. Currently bringing in new pages via swapin may
> +		 * cause a future higher order collapse on a rescan of the same
> +		 * range.
> +		 */
> +		if (!is_pmd_order(order)) {
> +			pte_unmap(pte);
> +			mmap_read_unlock(mm);
> +			result = SCAN_EXCEED_SWAP_PTE;
> +			goto out;
> +		}
> +

Interesting, we just swapin everything we find :)

But do we really need this check here? I mean, we just found it to be present.

In the rare event that there was a race, do we really care? It was just
present, now it's swapped. Bad luck. Just swap it in.

-- 
Cheers,

David

