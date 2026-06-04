Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5E9CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766BA6B0093; Thu,  4 Jun 2026 10:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EA76B0095; Thu,  4 Jun 2026 10:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B3A6B0096; Thu,  4 Jun 2026 10:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5806B6B0093
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:45:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFD73A00F9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:45:55 +0000 (UTC)
X-FDA: 84842504670.23.65B716C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92741C0018
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:45:46 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780584346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJYCgZSQTNkh6hxE/kJ6+MhW48xihgOg6aoHCWlS+KE=;
	b=SKFgEBfmCHewIV2ktDMAio9B0l8meO44dGSaYVJmIY0YYte74I0s71ev/ft1qFEPwDi08h
	9uTWhJ9Ff9bKaMYgqPm4mx2lXQb0byKC12hmuP9wKPhrkQAEYJYOHDCcHlVUVIol6VA8FF
	MYmMHRhwGZGUgYnh1cJtH06VK0T5f8E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFpgmwNn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780584346;
	b=7CedOJxQ5Jd/swVo84eRPmZyDFs43yt4Sl5rspxaIMyeLLfI4ztXRkMD8ip+4Kp51q6xtx
	yZBC6yK+Zd4qeA78hVUDf7UYk/b4U7PIK5AsI10U3ipx3S7UiH+F18m0FoBQrkfBR3kDgp
	76dpBahibjYjoDYL5/4sRtMKbKOI8Ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC293444D5;
	Thu,  4 Jun 2026 14:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937411F00898;
	Thu,  4 Jun 2026 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780584345;
	bh=BJYCgZSQTNkh6hxE/kJ6+MhW48xihgOg6aoHCWlS+KE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZFpgmwNndGWbwB/VyMmHZmh0HhYvBN95OsGVg6UaRXkVs6q9z36cTa+1OqCx+fEo3
	 XV/gSux4cXuKvhWvEpOKkGguVK2Qng475SE16iiiRwtnsY+2yl5/LRltjNx//9Ghpi
	 Pl3jPwD23z7YBKvlCmv5MIE5mDHJVRYlHZjALvre1eQlqQNOdCHRTT09CiFdIkrwi6
	 W6tSZN494rTjUsCWQaciqDtpdo49bW4T4Tk5xuLOofyWgCasNEc2KMWc1vY9BggWpS
	 ha8VxHLMxZdWE9xg0ADq8wUvUvJQYKpWHieYUut43LWi15niI7NHj6j7vRJUwxC6os
	 flYea9MTZmtQQ==
Date: Thu, 4 Jun 2026 15:45:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <aiGOvIR9sfm91cvT@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-12-npache@redhat.com>
X-HE-Tag: 1780584346-873332
X-HE-Meta: U2FsdGVkX18OUtZvwpB/995mxrcPSHPLztBAuGWkA6h2Pjvd2id8l34d2uc3U0vUFf81pB0+8f6NqVk9KqK+rEkrx7ZFGIUZdt8r/Wyik3mCFoHhJj+lT2noPbIpluiFytNIhrfW14mH1OmhH7PYp2hgzj7BwSDKLq2qpupK58BjEsi96GrKrpvXR1uU/FegwlYnuhGjIS5U//FmtCCHMV6ftvh6sxSfahXsyT/NA2nQK6WDUdQ+XIw+tItTn6GXQYnsl0BNpNOVoExo4XIYGii1K+022hIZglfVrsaaLrOErHmyChz0TcZhG4UpVej1blW9GLSqLRAMDCLkx+k3N/Ib9UoPGLzunmC5tt61Rg5AlDBU5xTHKHfo7f/GEgK88gO3Bl8yHRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
> Enable khugepaged to collapse to mTHP orders. This patch implements the
> main scanning logic using a bitmap to track occupied pages and a stack
> structure that allows us to find optimal collapse sizes.
>
> Previous to this patch, PMD collapse had 3 main phases, a light weight
> scanning phase (mmap_read_lock) that determines a potential PMD
> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> phase (mmap_write_lock).
>
> To enabled mTHP collapse we make the following changes:
>
> During PMD scan phase, track occupied pages in a bitmap. When mTHP
> orders are enabled, we remove the restriction of max_ptes_none during the
> scan phase to avoid missing potential mTHP collapse candidates. Once we
> have scanned the full PMD range and updated the bitmap to track occupied
> pages, we use the bitmap to find the optimal mTHP size.
>
> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> and determine the best eligible order for the collapse. A stack structure
> is used instead of traditional recursion to manage the search. This also
> prevents a traditional recursive approach when the kernel stack struct is
> limited. The algorithm recursively splits the bitmap into smaller chunks to
> find the highest order mTHPs that satisfy the collapse criteria. We start
> by attempting the PMD order, then moved on the consecutively lower orders
> (mTHP collapse). The stack maintains a pair of variables (offset, order),
> indicating the number of PTEs from the start of the PMD, and the order of
> the potential collapse candidate.
>
> The algorithm for consuming the bitmap works as such:
>     1) push (0, HPAGE_PMD_ORDER) onto the stack
>     2) pop the stack
>     3) check if the number of set bits in that (offset,order) pair
>        statisfy the max_ptes_none threshold for that order
>     4) if yes, attempt collapse
>     5) if no (or collapse fails), push two new stack items representing
>        the left and right halves of the current bitmap range, at the
>        next lower order
>     6) repeat at step (2) until stack is empty.
>
> Below is a diagram representing the algorithm and stack items:
>
>                             offset   mid_offset
>                             |        |
>                             |        |
>                             v        v
>           ____________________________________
>          |          PTE Page Table            |
>          --------------------------------------
> 			    <-------><------->
>                              order-1  order-1
>
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order mTHP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will
> satisfy the promotion condition once again. This issue is prevented via
> the collapse_max_ptes_none() function which imposes the max_ptes_none
> restrictions above.
>
> We currently only support mTHP collapse for max_ptes_none values of 0
> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>
>     - max_ptes_none=0: Never introduce new empty pages during collapse
>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>       available mTHP order
>
> Any other max_ptes_none value will emit a warning and default mTHP
> collapse to max_ptes_none=0. There should be no behavior change for PMD
> collapse.
>
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.
>
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 181 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 172 insertions(+), 9 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 64ceebc9d8a7..d3d7db8be26c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -99,6 +99,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> +/*
> + * mthp_collapse() does an iterative DFS over a binary tree, from
> + * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
> + * size needed for a DFS on a binary tree is height + 1, where
> + * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
> + *
> + * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
> + * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
> + */
> +#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
> +
> +/*
> + * Defines a range of PTE entries in a PTE page table which are being
> + * considered for mTHP collapse.
> + *
> + * @offset: the offset of the first PTE entry in a PMD range.
> + * @order: the order of the PTE entries being considered for collapse.
> + */
> +struct mthp_range {
> +	u16 offset;
> +	u8 order;
> +};
> +
>  struct collapse_control {
>  	bool is_khugepaged;
>
> @@ -110,6 +134,12 @@ struct collapse_control {
>
>  	/* nodemask for allocation fallback */
>  	nodemask_t alloc_nmask;
> +
> +	/* Each bit represents a single occupied (!none/zero) page. */
> +	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
> +	/* A mask of the current range being considered for mTHP collapse. */
> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
>  };
>
>  /**
> @@ -1411,20 +1441,137 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	return result;
>  }
>
> +static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
> +				     u16 offset, u8 order)
> +{
> +	const int size = *stack_size;
> +	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
> +
> +	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
> +	stack->order = order;
> +	stack->offset = offset;
> +	(*stack_size)++;
> +}
> +
> +static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
> +						 int *stack_size)
> +{
> +	const int size = *stack_size;
> +
> +	VM_WARN_ON_ONCE(size <= 0);
> +	(*stack_size)--;
> +	return cc->mthp_bitmap_stack[size - 1];
> +}
> +
> +static unsigned int collapse_mthp_count_present(struct collapse_control *cc,
> +						u16 offset, unsigned int nr_ptes)
> +{
> +	bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +}
> +
> +/*
> + * mthp_collapse() consumes the bitmap that is generated during
> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> + *
> + * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
> + * A stack structure cc->mthp_bitmap_stack is used to check different regions
> + * of the bitmap for collapse eligibility. The stack maintains a pair of
> + * variables (offset, order), indicating the number of PTEs from the start of
> + * the PMD, and the order of the potential collapse candidate respectively. We
> + * start at the PMD order and check if it is eligible for collapse; if not, we
> + * add two entries to the stack at a lower order to represent the left and right
> + * halves of the PTE page table we are examining.
> + *
> + *                         offset       mid_offset
> + *                         |         |
> + *                         |         |
> + *                         v         v
> + *      --------------------------------------
> + *      |          cc->mthp_bitmap            |
> + *      --------------------------------------
> + *                         <-------><------->
> + *                          order-1  order-1
> + *
> + * For each of these, we determine how many PTE entries are occupied in the
> + * range of PTE entries we propose to collapse, then we compare this to a
> + * threshold number of PTE entries which would need to be occupied for a
> + * collapse to be permitted at that order (accounting for max_ptes_none).
> + *
> + * If a collapse is permitted, we attempt to collapse the PTE range into a
> + * mTHP.
> + */
> +static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
> +		unsigned long address, int referenced, int unmapped,
> +		struct collapse_control *cc, unsigned long enabled_orders)
> +{
> +	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> +	int collapsed = 0, stack_size = 0;
> +	unsigned long collapse_address;
> +	struct mthp_range range;
> +	u16 offset;
> +	u8 order;
> +
> +	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> +
> +	while (stack_size) {
> +		range = collapse_mthp_stack_pop(cc, &stack_size);
> +		order = range.order;
> +		offset = range.offset;
> +		nr_ptes = 1UL << order;
> +
> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		max_ptes_none = collapse_max_ptes_none(cc, vma, order);
> +
> +		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
> +							       nr_ptes);
> +
> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> +			int ret;
> +
> +			collapse_address = address + offset * PAGE_SIZE;
> +			ret = collapse_huge_page(mm, collapse_address, referenced,
> +						 unmapped, cc, order);
> +			if (ret == SCAN_SUCCEED) {
> +				collapsed += nr_ptes;
> +				continue;
> +			}
> +		}
> +
> +next_order:
> +		if ((BIT(order) - 1) & enabled_orders) {
> +			const u8 next_order = order - 1;
> +			const u16 mid_offset = offset + (nr_ptes / 2);
> +
> +			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
> +						 next_order);
> +			collapse_mthp_stack_push(cc, &stack_size, offset,
> +						 next_order);
> +		}
> +	}
> +	return collapsed;
> +}
> +
>  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr,
>  		bool *lock_dropped, struct collapse_control *cc)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>  	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
>  	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
> +	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> +	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>  	pmd_t *pmd;
> -	pte_t *pte, *_pte;
> -	int none_or_zero = 0, shared = 0, referenced = 0;
> +	pte_t *pte, *_pte, pteval;
> +	int i;
> +	int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr;
> +	unsigned long enabled_orders;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
>
> @@ -1436,8 +1583,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> +	bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */
> +	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
> +		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;

Hmm, this is a bit odd, what if the user set max_ptes_none = 0?

I assume we handle the 0/511 thing elsewhere?

> +
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
>  		cc->progress++;
> @@ -1445,11 +1603,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> -	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, addr += PAGE_SIZE) {
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		_pte = pte + i;
> +		addr = start_addr + i * PAGE_SIZE;
> +		pteval = ptep_get(_pte);
> +
>  		cc->progress++;
>
> -		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -1529,6 +1689,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			}
>  		}
>
> +		/* Set bit for occupied pages */
> +		__set_bit(i, cc->mthp_bitmap);
>  		/*
>  		 * Record which node the original page is from and save this
>  		 * information to cc->node_load[].
> @@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	if (result == SCAN_SUCCEED) {
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
> -		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc, HPAGE_PMD_ORDER);
> -		/* collapse_huge_page will return with the mmap_lock released */
> +		nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
> +					     unmapped, cc, enabled_orders);

I guess mthp_collapse() also does PMD collapse if only PMD is enabled?

It feels like this name is a bit confusing then :)

But I guess we can do a follow up to think of a better name possibly.

> +		/* mmap_lock was released above, set lock_dropped */
>  		*lock_dropped = true;
> +		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.54.0
>

Thanks, Lorenzo

