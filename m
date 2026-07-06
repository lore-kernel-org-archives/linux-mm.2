Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C509C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36936B009F; Mon,  6 Jul 2026 13:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EE16B00A0; Mon,  6 Jul 2026 13:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFA26B00A1; Mon,  6 Jul 2026 13:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A02006B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:49:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03E3740178
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:48:59 +0000 (UTC)
X-FDA: 84959087640.21.7F5BC12
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20515120002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:48:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wc6bZgW5;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCCRHCmLvdbcAURw7jcKOt3kGEc4cp06cbgZ4xf9Nyw=;
	b=WjOmZhCeXR9hpx6FfdpD4gW4ypjOpZGabnZB2CnXitqmv1hdZWNApSHNESuxF1Y6fKkYV9
	qTKbHhPLgD8mlB0ly+qZ22nhkJ3px93oWEb7y1VQRXIwdMxMeMm0Gt1XyLkQCawcMt+vRU
	S/RLVm6STWS6jMKXNlg53Z9d/bZ7M+U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wc6bZgW5;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360138;
	b=OP8Vf2d9ZrwQwQkLxfRMgVJWHivSFIFU4nR9wwvB4D6KPYn3RWF1/5nFY3azqcT83t6dNV
	4EdGPMYWRKsgeCiFphJNc4nto/ylxi/D4gvJAB+PTs3htmHuC0SuhfMQjcNAKV9009MhL2
	8EuDpN0IFToIE/1F9VHriYXDY16VuJE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783360135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCCRHCmLvdbcAURw7jcKOt3kGEc4cp06cbgZ4xf9Nyw=;
	b=wc6bZgW5190SvA4eFAwPWabmThpexuvv39bdAlL5nF1Ju843slF8E/SMDGWWCxOIY0htfk
	UxH0dr3zqoSgtJwPVv40Vh0ZgeaNMb0IP9+2bSSMEMcB4aUTSUUYMIh/1Y7OjevhQm0ldq
	ZJtRmgQ4l7PN9wQF/tmwAJiQ6Q+sdDg=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 5/8] mm/khugepaged: Refactor the PTE state checks into a helper
Date: Mon,  6 Jul 2026 10:48:48 -0700
Message-ID: <20260706174849.939490-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-6-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20515120002
X-Stat-Signature: 3wdnzzyt5beooutyp3au4r4nqbb3sfpf
X-HE-Tag: 1783360137-849739
X-HE-Meta: U2FsdGVkX1+tdH+nkJtsMWMBvW6ZKohThM3GUO5jOgMvprD50huhgZtlx2CZDroR7zsBafz5mfl716Gog2kNegvI8BeCaq3XU4hB1r2tz6jPfQdNOdTWodQ7CLcObB0RCupx3u6VcXDfXWyqfq0UI8/EjAupyZLaM83xgvES7dOZ2c7YeXFwU6i7xFjbMS9JeSpgbFiqI4O+cidsXaURpNjuYJM9LWtObiI3AHfDZSXyoQbcMd7cXw/ueSo3OCjUULPSpwWmsDGO4B40edyxgF0U7St8MzGfwqMwzP+WrAh+cTdv5BC7n4dDrGSp/iP3c/39odSJsAcyTCUW4bLPE3YKHUIgT3DDi33xe+2QLtICYfZEiX7aD66ZBJb6bV3jst59MZLGfDVB4Z1UWx58OcjBZOfWBLKM+d7t9bZQsLip7cWDXBEvLDlrA8hKDmFSuIWFgYon/w8rYULrn5ov4bPuwC+nYAC6R5BhJIpZF15fElwxip7p0sztTKILqVRY3mEV1GgFtFv5iI174xUmDrIH52+HabqrKxsf2QT+wm70yyBByB3W1LwJiIVs4Gy+pJDNkX2Y3oSlMZUhgh4CMsPJ7Er57oRdKNyJddQOg/5zQa3KF3Yd+O0mD2lptAzdDsjthwBhp2q4CTaqDxlqSG3KlO6Rh7dIWy/F/tnDF3ILmmm/uK3BF1hVvE26mxYPJQg60Uczvj+USfHF8aAsjnX8E3PkIhqw93kLHKh+ClqxltfNb8ysQFj1Z8vKQabpwam437mbz8GpzXNILfFPyxAK2VGzPoFedfyK82MZO68i9EVuHxWqP6NpimX/6m1aT17EopAfwSnf0+rS7xGE4bCubf8whjdNPPVpm+g4ScE6m3PVn9bF6wA5jUXLQNT3a2rRTt1x8IPM2Beb+CDqeim7rL47nobJc6B/N+V0Gzun4fW0KYOaEujHVAvbVLnpBos9WEbnvmlQOTAC+SU
 PCpD9br4
 MLmp230npACtqhhrYmNfnfP1GDlBzXilaszEApflRbYRnIoYmKLDf1FTBMCyjYQVSBE3HpAxMApGQQymLeZUgIRFp4dofaQK0hZLZbeAf3O9OY72yf6yJZhbpi5utdmVynHEa4DEf7C8JeYwxHkikFlfiues+/UMJ/PmroSFRLFQjQARPK2D7LeVcddy5aJdzmcrKXTuMW0J3OD0sBLCC1fq3KhoBXgyLFkpFcQhso9HBmrpB2tW2iBlwlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:52 -0600 Nico Pache <npache@redhat.com> wrote:

> For anonymous collapse, the collapse_scan_pmd() and
> __collapse_huge_page_isolate() functions share a large portion of their
> logic. These functions both check the state of the PTEs and verify the
> following:
> 	- max_pte_* values are not exceeded
> 	- uffd is not active
> 	- lazyfree properties
> 	- non-anonymous
> 
> Merge these checks into a helper collapse_check_pte() to reduce code
> duplication. We also add a helper struct for this function called
> pte_check_context which allows us to pass the required parameters in a
> clean and elegant manner.
> 
> A helper function is also introduced pte_check_fail() to provide a clean
> interface to set the pte_check_context failure results and return
> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
> collapse_check_pte function.
> 
> Two slight modifications are done to the original functionality. We now
> warn (instead of crash) if the anon test fails, and we leverage the
> vm_normal_folio function instead of page->folio, this should be
> functionally equivalent.
> 
> No other functional changes intended.
> 
> This patch is heavily based off work done by Lance Yang, but modified to
> deal with conflicts and feedback received during the review cycle [1].
> 
> [1] https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 295 +++++++++++++++++++++++++-----------------------
>  1 file changed, 155 insertions(+), 140 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 676f75773a6c..c4ea2dc1591b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -63,6 +63,12 @@ enum scan_result {
>  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
>  
> +enum pte_check_result {
> +	PTE_CHECK_SUCCEED,
> +	PTE_CHECK_FAIL,
> +	PTE_CHECK_CONTINUE,
> +};
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>  
> @@ -117,6 +123,20 @@ struct collapse_control {
>  	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>  };
>  
> +struct pte_check_context {
> +	struct collapse_control *cc;
> +	struct vm_area_struct *vma;
> +	unsigned int order;
> +	struct folio *folio;
> +	int none_or_zero;
> +	int shared;
> +	int unmapped;
> +	enum scan_result result;
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +};
> +
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> @@ -700,74 +720,130 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
>  	count_mthp_stat(order, mthp_event);
>  }
>  
> +/*
> + * pte_check_fail() - A simple helper to set the pte_check_context result and
> + * return PTE_CHECK_FAIL.
> + */
> +static enum pte_check_result pte_check_fail(struct pte_check_context *ctx,
> +		enum scan_result result)
> +{
> +	ctx->result = result;
> +	return PTE_CHECK_FAIL;
> +}
> +
> +/*
> + * collapse_check_pte() - Check if a PTE is suitable for collapse
> + *
> + * Check if a PTE is suitable for collapse based on the following criteria:
> + * - max_pte_* values are not exceeded
> + * - uffd is not active
> + * - lazyfree properties are not present
> + * - only anonymous pages are present
> + *
> + * a helper struct pte_check_context is used to pass and store relevant
> + * information between the collapse_check_pte() function and the caller.
> + *
> + * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
> + *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
> + *         PTE_CHECK_CONTINUE if the scan should continue to check the next PTE.
> + */
> +static enum pte_check_result collapse_check_pte(pte_t pteval,
> +		unsigned long addr, struct pte_check_context *ctx)
> +{
> +	if (pte_none_or_zero(pteval)) {
> +		if (++ctx->none_or_zero > ctx->max_ptes_none) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
> +					MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +			return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
> +		}
> +		return PTE_CHECK_CONTINUE;
> +	}
> +	if (!pte_present(pteval)) {
> +		if (ctx->unmapped == -1)
> +			return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
> +		if (++ctx->unmapped > ctx->max_ptes_swap) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
> +					MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +			return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
> +		}
> +		if (pte_swp_uffd_wp_any(pteval))
> +			return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
> +		return PTE_CHECK_CONTINUE;
> +	}
> +	/*
> +	 * Don't collapse if any of the small PTEs are armed with uffd
> +	 * write protection. Marking the new huge pmd as write protected
> +	 * could bring userfault messages that fall outside of the
> +	 * registered range.
> +	 */
> +	if (pte_uffd_wp(pteval))
> +		return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
> +
> +	ctx->folio = vm_normal_folio(ctx->vma, addr, pteval);
> +	if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->folio)))
> +		return pte_check_fail(ctx, SCAN_PAGE_NULL);
> +
> +	/*
> +	 * If the vma has the VM_DROPPABLE flag, the collapse will
> +	 * preserve the lazyfree property without needing to skip.
> +	 */
> +	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
> +	    folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
> +		return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
> +
> +	if (folio_maybe_mapped_shared(ctx->folio)) {
> +		/*
> +		 * TODO: Support shared pages without leading to further
> +		 * mTHP collapses. Currently bringing in new pages via
> +		 * shared may cause a future higher order collapse on a
> +		 * rescan of the same range.
> +		 */
> +		if (++ctx->shared > ctx->max_ptes_shared) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
> +					MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +			return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE);
> +		}
> +	}
> +
> +	if (!folio_test_anon(ctx->folio)) {
> +		VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);
> +		return pte_check_fail(ctx, SCAN_PAGE_ANON);
> +	}

The order folio_maybe_mapped_shared() and !folio_test_anon() check is flipped
from what it was. Can we keep original ordering? The commit message says
no other functional change inteded, but this could result in different collapse
even counters getting incremented.


> +	return PTE_CHECK_SUCCEED;
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
> -	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
>  	const unsigned long nr_pages = 1UL << order;
> -	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
> -	pte_t *_pte;
> -	int none_or_zero = 0, shared = 0, referenced = 0;
> +	pte_t *_pte, pteval;
> +	int referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
> +	enum pte_check_result pte_check;
> +	struct pte_check_context ctx = {
> +		.cc = cc,
> +		.vma = vma,
> +		.order = order,
> +		.unmapped = -1, /* don't check swap PTEs */
> +		.max_ptes_none = collapse_max_ptes_none(cc, vma, order),
> +		.max_ptes_shared = collapse_max_ptes_shared(cc, order),
> +	};
>  
>  	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {
> -		pte_t pteval = ptep_get(_pte);
> -		if (pte_none_or_zero(pteval)) {
> -			if (++none_or_zero > max_ptes_none) {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
> -						MTHP_STAT_COLLAPSE_EXCEED_NONE);
> -				goto out;
> -			}
> -			continue;
> -		}
> -		if (!pte_present(pteval)) {
> -			result = SCAN_PTE_NON_PRESENT;
> -			goto out;
> -		}
> -		if (pte_uffd_wp(pteval)) {
> -			result = SCAN_PTE_UFFD_WP;
> -			goto out;
> -		}
> -		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -			result = SCAN_PAGE_NULL;
> -			goto out;
> -		}
> -
> -		folio = page_folio(page);
> -		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> -
> -		/*
> -		 * If the vma has the VM_DROPPABLE flag, the collapse will
> -		 * preserve the lazyfree property without needing to skip.
> -		 */
> -		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
> -		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> -			result = SCAN_PAGE_LAZYFREE;
> +		pteval = ptep_get(_pte);
> +		pte_check = collapse_check_pte(pteval, addr, &ctx);
> +		if (pte_check == PTE_CHECK_FAIL) {
> +			result = ctx.result;
>  			goto out;
>  		}
> +		if (pte_check == PTE_CHECK_CONTINUE)
> +			continue;
> +		folio = ctx.folio;
>  
> -		/* See collapse_scan_pmd(). */
> -		if (folio_maybe_mapped_shared(folio)) {
> -			/*
> -			 * TODO: Support shared pages without leading to further
> -			 * mTHP collapses. Currently bringing in new pages via
> -			 * shared may cause a future higher order collapse on a
> -			 * rescan of the same range.
> -			 */
> -			if (++shared > max_ptes_shared) {
> -				result = SCAN_EXCEED_SHARED_PTE;
> -				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
> -						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> -				goto out;
> -			}
> -		}
>  		/*
>  		 * TODO: In some cases of partially-mapped folios, we'd actually
>  		 * want to collapse.
> @@ -844,13 +920,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		result = SCAN_LACK_REFERENCED_PAGE;
>  	} else {
>  		result = SCAN_SUCCEED;
> -		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> +		trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
>  						    referenced, result, order);
>  		return result;
>  	}
>  out:
>  	release_pte_pages(pte, _pte, compound_pagelist);
> -	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> +	trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
>  					    referenced, result, order);
>  	return result;
>  }
> @@ -1616,24 +1692,30 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr,
>  		bool *lock_dropped, struct collapse_control *cc)
>  {
> -	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
> -	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
> -	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>  	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte, pteval;
>  	int i;
> -	int none_or_zero = 0, shared = 0, referenced = 0;
> -	enum scan_result result = SCAN_FAIL;
> -	struct page *page = NULL;
>  	struct folio *folio = NULL;
> +	int referenced = 0;
> +	enum scan_result result = SCAN_FAIL;
>  	unsigned long addr;
>  	unsigned long enabled_orders;
>  	spinlock_t *ptl;
> -	int node = NUMA_NO_NODE, unmapped = 0;
> +	int node = NUMA_NO_NODE;
> +	enum pte_check_result pte_check;
>  
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>  
> +	struct pte_check_context ctx = {
> +		.cc = cc,
> +		.vma = vma,
> +		.order = HPAGE_PMD_ORDER,
> +		.max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER),
> +		.max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER),
> +		.max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER),
> +	};
> +
>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		cc->progress++;
> @@ -1649,7 +1731,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	 * scan all pages to populate the bitmap for mTHP collapse.
>  	 */
>  	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
> -		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
> +		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>  
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
> @@ -1665,81 +1747,14 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  
>  		cc->progress++;
>  
> -		if (pte_none_or_zero(pteval)) {
> -			if (++none_or_zero > max_ptes_none) {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
> -						MTHP_STAT_COLLAPSE_EXCEED_NONE);
> -				goto out_unmap;
> -			}
> -			continue;
> -		}
> -		if (!pte_present(pteval)) {
> -			if (++unmapped > max_ptes_swap) {
> -				result = SCAN_EXCEED_SWAP_PTE;
> -				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
> -						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> -				goto out_unmap;
> -			}
> -			/*
> -			 * Always be strict with uffd-wp
> -			 * enabled swap entries.  Please see
> -			 * comment below for pte_uffd_wp().
> -			 */
> -			if (pte_swp_uffd_wp_any(pteval)) {
> -				result = SCAN_PTE_UFFD_WP;
> -				goto out_unmap;
> -			}
> -			continue;
> -		}
> -		if (pte_uffd_wp(pteval)) {
> -			/*
> -			 * Don't collapse the page if any of the small
> -			 * PTEs are armed with uffd write protection.
> -			 * Here we can also mark the new huge pmd as
> -			 * write protected if any of the small ones is
> -			 * marked but that could bring unknown
> -			 * userfault messages that falls outside of
> -			 * the registered range.  So, just be simple.
> -			 */
> -			result = SCAN_PTE_UFFD_WP;
> -			goto out_unmap;
> -		}
> -
> -		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -			result = SCAN_PAGE_NULL;
> -			goto out_unmap;
> -		}
> -		folio = page_folio(page);
> -
> -		/*
> -		 * If the vma has the VM_DROPPABLE flag, the collapse will
> -		 * preserve the lazyfree property without needing to skip.
> -		 */
> -		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
> -		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> -			result = SCAN_PAGE_LAZYFREE;
> -			goto out_unmap;
> -		}
> -
> -		if (!folio_test_anon(folio)) {
> -			result = SCAN_PAGE_ANON;
> +		pte_check = collapse_check_pte(pteval, addr, &ctx);
> +		if (pte_check == PTE_CHECK_FAIL) {
> +			result = ctx.result;
>  			goto out_unmap;
>  		}
> -
> -		/*
> -		 * We treat a single page as shared if any part of the THP
> -		 * is shared.
> -		 */
> -		if (folio_maybe_mapped_shared(folio)) {
> -			if (++shared > max_ptes_shared) {
> -				result = SCAN_EXCEED_SHARED_PTE;
> -				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
> -						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> -				goto out_unmap;
> -			}
> -		}
> +		if (pte_check == PTE_CHECK_CONTINUE)
> +			continue;
> +		folio = ctx.folio;
>  
>  		/* Set bit for occupied pages */
>  		__set_bit(i, cc->mthp_present_ptes);
> @@ -1781,7 +1796,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	}
>  	if (cc->is_khugepaged &&
>  		   (!referenced ||
> -		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
> +		    (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
>  	} else {
>  		result = SCAN_SUCCEED;
> @@ -1792,13 +1807,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
>  		result = mthp_collapse(mm, start_addr, referenced,
> -				       unmapped, cc, enabled_orders);
> +				       ctx.unmapped, cc, enabled_orders);
>  		/* mmap_lock was released above, set lock_dropped */
>  		*lock_dropped = true;
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> -				     none_or_zero, result, unmapped);
> +				     ctx.none_or_zero, result, ctx.unmapped);
>  	return result;
>  }
>  
> -- 
> 2.54.0
> 
> 

