Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE39DF588D2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A643C6B0088; Mon, 20 Apr 2026 09:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15376B0089; Mon, 20 Apr 2026 09:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9039A6B008A; Mon, 20 Apr 2026 09:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 772FE6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:56:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E79AE56A7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:56:08 +0000 (UTC)
X-FDA: 84679083216.14.3F52E4B
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id E551E14000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:56:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vLaTKWNN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776693366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRj72wK+FCQB3Q8xdRrZNsXn0FIfDJ87LTYopLumO9A=;
	b=1SFYiFN5+X46bGE9fh/j88XR2o8W3e6rThfiYv3zR6P7CrF2fyG8ZtBtZ7LvqDnfIh3OyQ
	fcl/kwXnNzcRtNFubxPM6xDX3XnTo0c/A7fNzK/p7bCSEuIAxtcZCaHPsb2p/qPBB3v7bs
	OfUgidsdsaXvpN6QWRt9ANIxvpdoDWg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vLaTKWNN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776693366; a=rsa-sha256;
	cv=none;
	b=NI9rueSaQJsGnMhDhjPDIJP/W97nDYOhUgOF9Swifg4kPax+VwvmHzrBMSNBWbTMeJuRy0
	cCh9nRRtqqR36f0CzP1pC5okXN1sM7ccRLKVEUYOCszoKHXDZoEAt2BfE7NLOGnZtJ/eIp
	wAwcPCNSaj+pqgJwi7HpJnERIgY7KFM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776693363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRj72wK+FCQB3Q8xdRrZNsXn0FIfDJ87LTYopLumO9A=;
	b=vLaTKWNNU6/vG2fZehdj+5Nz+ewgUOFxb0ZpxRe/OFBJIZe+Zs0uk9TbH9AbMSl/0MT/oz
	3DyN97FMaNdil2vqX2i+OiHo6dTbulwv6e5Vh2NWUFi6qF8FgRZ3nV++jvj0Gc6dmCDZ3H
	DFxO0c3WxF+agDrZ5qIwyAFlWhsuLoY=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 04/13] mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Mon, 20 Apr 2026 06:55:53 -0700
Message-ID: <20260420135554.27067-1-usama.arif@linux.dev>
In-Reply-To: <20260419185750.260784-5-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E551E14000F
X-Stat-Signature: iqnofkhjoptb41pf1dixcmi9ifuuxmh5
X-HE-Tag: 1776693365-273151
X-HE-Meta: U2FsdGVkX1+Yo8m86anue7VdJPgVwCcV6SFijquAoMi++IBimhocEmQ9NPmDbsLEjx6UTA4hULa+VPEkk2GUnVKw1BuET0fKZLBgMXhNvFeOzhwVWIlPBDeQo+DjaTgjD/W1Ix+Z7KVcgUcwALmRSvqXIZ9XwNsovniIux4HtsyCVVGc/n4JNlz1DxCngY7rSNJuoigE7tFqidZ9gstEwpbsPBDOW9MlKiiVWl/TtK8rGTyy99InkAdI+csm+VydPcxOjTefxh0B861pLIBueU6ncCznwb/kV+RyBcmZwjvpzVEzk0qe4at1+BCv7jN9NYa8Va7WvFFHpj2AbxF7si9bY3PtvHqylEE2cpgXw8Tr32AoVq3F0z0TZwSOsbl8hReEdp7cnogt9Bh3zun8eY3FKyVmEpSaIWKiuKGSdHCrH2vNFsZoWj0YrGK2gMIlsP3ZabvWmxDbEtzeBYR7jgutCyxbnKKFUQ0zjO1fxKZ+8AKsBR3S6ZTuedIp5SN9vhGLiJsvJsAW0lihzS6tTYAZ5MepKVJgo/XJlNWm6AAPnxGB+vwZuPwW7Ax/evBFttawm53mulz0rDlsFPtDUk6ezwQdd/8NilzBfSB5bMdQv9IqQFA7z6Dq3NCm/ISnv+KwQ9k/HhVARXFLiioxQq1jq8EDRF7kz4/buQWEY+m4GsvclydWX8VNGa2+Jcr+UESJWKlK8UqpF92InlKyE5dUylxCu4dbXx4w7s5qRRkFO7oCJXt/79Pw1y3KXBefCI5cO3bd8OS8Lz7XgHYa5NFdNKQ1DJKwEBzUunAKu9r+FodBXGex8envNKwDPxzqAFdh/Jiz6jFGqEd1p769KIntACNdlltqpCDpZHJWY5byL88uylKIMe9TfSqNKOGkW0nq1Ib0fuUAFnbhKSsLZDaLDypqjAmbfajagY+nlZImw/XjFflDDuaMx1RCVI/6YZMCy0H6KQ9G1SLitsH
 D3BnAym9
 XEu+OaX+3RF4PKqv15+tP9lwdjRTwhAkvrPGWVuQiAFMz82gHT4iNbvXJhdslxRKoe7yXdSJvicY9bNyGMRDTSf8tqstPUi3NLeIwCmHalDoxHLUL3eZbxzbVMMKyCnECAp/ITVax6QQiTmPIHWc3hi9lRHkTKxRdViP2efVGakRCjzkkXCNjGb/2Qj+5Tbpyp/k0dI1EWrFw/4UehZLEkyb++rbOMcgpTNU6khHI2TaQRByaVeTY3gg2+mkfUYJma0X1ETgreteaoze1p9eygdBILIhJc7pP5aKCTvUc1BdLqErq247WcNNliI5AEfPybNdJ4MYCppcMATpngHAcv+eH5nI17uJlQ6Wv8Jfp0jr6eRMmcr7M7TP4JhHiiL55QkjA2xvOM13AeQobktXBD3w9Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:41 -0600 Nico Pache <npache@redhat.com> wrote:

> generalize the order of the __collapse_huge_page_* and collapse_max_*
> functions to support future mTHP collapse.
> 
> The current mechanism for determining collapse with the
> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
> raises a key design issue: if we support user defined max_pte_none values
> (even those scaled by order), a collapse of a lower order can introduces
> an feedback loop, or "creep", when max_ptes_none is set to a value greater
> than HPAGE_PMD_NR / 2.
> 
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
> 
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes:
> 
> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>   available mTHP order.
> 
> This removes the possiblilty of "creep", while not modifying any uAPI
> expectations. A warning will be emitted if any non-supported
> max_ptes_none value is configured with mTHP enabled.
> 
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.
> 
> No functional changes in this patch; however it defines future behavior
> for mTHP collapse.
> 
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 124 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 88 insertions(+), 36 deletions(-)
> 

Small nits. Most might not need change.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f42b55421191..283bb63854a5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -352,51 +352,86 @@ static bool pte_none_or_zero(pte_t pte)
>   * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>   * @cc: The collapse control struct
>   * @vma: The vma to check for userfaultfd
> + * @order: The folio order being collapsed to
>   *
>   * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
> - * empty page.
> + * empty page. For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the
> + * configured khugepaged_max_ptes_none value.
> + *
> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> + * of 0 or (KHUGEPAGED_MAX_PTES_LIMIT). Any other value will emit a warning and
> + * no mTHP collapse will be attempted
>   *
>   * Return: Maximum number of empty PTEs allowed for the collapse operation
>   */
> -static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
> -		struct vm_area_struct *vma)
> +static int collapse_max_ptes_none(struct collapse_control *cc,
> +		struct vm_area_struct *vma, unsigned int order)
>  {
>  	if (vma && userfaultfd_armed(vma))
>  		return 0;
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> -	return khugepaged_max_ptes_none;
> +	if (is_pmd_order(order))
> +		return khugepaged_max_ptes_none;
> +	/* Zero/non-present collapse disabled. */
> +	if (!khugepaged_max_ptes_none)
> +		return 0;
> +	if (khugepaged_max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
> +		return (1 << order) - 1;
> +

There are 2 reads of khugepaged_max_ptes_none here.
A concurrent sysctl write between reads can yield "0 then non-zero" or "LIMIT
then mid-value".

Would be good to just snapshot once at the start of the function and use that
value?

> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
> +		      KHUGEPAGED_MAX_PTES_LIMIT);

IMO, warn_once can get lost quickly in dmesg. Maybe pr_warn_ratelimited?

Not sure what others opinions are..

> +	return -EINVAL;
>  }
>  
>  /**
>   * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
>   * @cc: The collapse control struct
> + * @order: The folio order being collapsed to
>   *
>   * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>   * shared page.
>   *
> + * For mTHP collapses, we currently dont support collapsing memory with
> + * shared memory.
> + *
>   * Return: Maximum number of shared PTEs allowed for the collapse operation
>   */
> -static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
> +static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
> +		unsigned int order)
>  {
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> +	if (!is_pmd_order(order))
> +		return 0;
> +
>  	return khugepaged_max_ptes_shared;
>  }
>  
>  /**
>   * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
>   * @cc: The collapse control struct
> + * @order: The folio order being collapsed to
>   *
>   * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>   * swap page.
>   *
> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> + * khugepaged_max_ptes_swap value.
> + *
> + * For mTHP collapses, we currently dont support collapsing memory with
> + * swapped out memory.
> + *
>   * Return: Maximum number of swap PTEs allowed for the collapse operation
>   */
> -static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
> +static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
> +		unsigned int order)
>  {
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> +	if (!is_pmd_order(order))
> +		return 0;
> +
>  	return khugepaged_max_ptes_swap;
>  }
>  
> @@ -590,18 +625,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
> -		struct list_head *compound_pagelist)
> +		unsigned int order, struct list_head *compound_pagelist)
>  {
> +	const unsigned long nr_pages = 1UL << order;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
> -	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
> -	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
> +	int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
> +	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
> +
> +	if (max_ptes_none < 0)
> +		return result;

Would a dedicated SCAN_INVALID_PTES_NONE make more sense here instead
of SCAN_FAIL?

>  
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
> @@ -734,18 +773,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
> +	const unsigned long nr_pages = 1UL << order;
> +	unsigned long end = address + (PAGE_SIZE << order);
>  	struct folio *src, *tmp;
>  	pte_t pteval;
>  	pte_t *_pte;
>  	unsigned int nr_ptes;
>  
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> @@ -798,13 +837,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
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
> +	const unsigned long nr_pages = 1UL << order;
>  	spinlock_t *pmd_ptl;
> -

Shouldn't remove the newline above?

>  	/*
>  	 * Re-establish the PMD to point to the original page table
>  	 * entry. Restoring PMD needs to be done prior to releasing
> @@ -818,7 +855,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  	 * Release both raw and compound pages isolated
>  	 * in __collapse_huge_page_isolate.
>  	 */
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> +	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>  }
>  
>  /*
> @@ -838,16 +875,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>   */
>  static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> -		unsigned long address, spinlock_t *ptl,
> +		unsigned long address, spinlock_t *ptl, unsigned int order,
>  		struct list_head *compound_pagelist)
>  {
> +	const unsigned long nr_pages = 1UL << order;
>  	unsigned int i;
>  	enum scan_result result = SCAN_SUCCEED;
> -

Same here?

>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iteration.
>  	 */
> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +	for (i = 0; i < nr_pages; i++) {
>  		pte_t pteval = ptep_get(pte + i);
>  		struct page *page = folio_page(folio, i);
>  		unsigned long src_addr = address + i * PAGE_SIZE;
> @@ -866,10 +903,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
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
> @@ -1040,12 +1077,12 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>   */
>  static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
> -		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
> -		int referenced)
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		pmd_t *pmd, int referenced, unsigned int order)

Will probably find out in later reviews, but there is tracepoint in __collapse_huge_page_swapin.
Would be good to add order in that tracepoint if you are adding order here?

>  {
>  	int swapped_in = 0;
>  	vm_fault_t ret = 0;
> -	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>  	enum scan_result result;
>  	pte_t *pte = NULL;
>  	spinlock_t *ptl;
> @@ -1077,6 +1114,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
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

Would it be good to introduce this in the patch that activates it? No strong
preference btw. Just that its dead code in this patch itself.

> +			pte_unmap(pte);
> +			mmap_read_unlock(mm);
> +			result = SCAN_EXCEED_SWAP_PTE;
> +			goto out;
> +		}
> +
>  		vmf.pte = pte;
>  		vmf.ptl = ptl;
>  		ret = do_swap_page(&vmf);
> @@ -1196,7 +1246,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
>  		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced);
> +						     referenced, HPAGE_PMD_ORDER);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1244,6 +1294,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>  	if (pte) {
>  		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> +						      HPAGE_PMD_ORDER,
>  						      &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
> @@ -1274,6 +1325,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>  					   vma, address, pte_ptl,
> +					   HPAGE_PMD_ORDER,
>  					   &compound_pagelist);
>  	pte_unmap(pte);
>  	if (unlikely(result != SCAN_SUCCEED))
> @@ -1318,9 +1370,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	unsigned long addr;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
> -	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
> -	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
> -	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
> +	int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> +	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
> +	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>  
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>  
> @@ -2371,8 +2423,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	int present, swap;
>  	int node = NUMA_NO_NODE;
>  	enum scan_result result = SCAN_SUCCEED;
> -	unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
> -	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
> +	int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
> +	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>  
>  	present = 0;
>  	swap = 0;
> -- 
> 2.53.0
> 
> 

