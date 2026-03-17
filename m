Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47639FF6E85
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C786B0096; Tue, 17 Mar 2026 17:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C286B0098; Tue, 17 Mar 2026 17:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4536B0099; Tue, 17 Mar 2026 17:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 303646B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:36:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDCD78B4F6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:36:40 +0000 (UTC)
X-FDA: 84556864560.02.D6A66EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EBA331C0011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:36:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVj28gkB;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773783399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFCcbDlqi6RJBp0VD7QcipBI/IzdcFpXxadyLAtxcQk=;
	b=JGWVfa77ApXCXd2ejdIaM+Uzz4e3ap8vpLBypAqVk+Liql0w11/kiHcNvfb8SFewr28b7G
	UXGHsEAjWC+q7oMAX7o6G/e8ba2vFblmpx1BOXdvLU3JhT3zXFmuPpcZR1cls8fY6YjbJ8
	C1wVRHdujxjon+THhF6QHrbi/R1U8D4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVj28gkB;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773783399; a=rsa-sha256;
	cv=none;
	b=KYxJFn4Hk+v8bzmTWnaLbIfsuQqGsm62Etl+xqWP0fC7rUr8q795g0pNDRRZGRy3SeaGhO
	JR28J2o0tpG14lagJyV5O14Z2rzMa7hKHxJCHplLd2i2PaUtLimOKch3TQMyVqXOW1Togh
	QbN0VDqPLrJhsNSOdqUNHYhA8r+xKjE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 741E44035C;
	Tue, 17 Mar 2026 21:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ABAC4CEF7;
	Tue, 17 Mar 2026 21:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773783397;
	bh=GvzErCP+EwmpuPiPqZkXI64ntPzEiWSpFo75sPaAjuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVj28gkBBAReR7dihl56rqdaqR9TrbPkrql1maarWdV+dPvIPXuId+yD4XLBS+GqG
	 Fo9CCQWR7oOvc7fQwJI9E+TvwYZcP65dYPnUi+4+3wX6qW+rO7BKvT4mHd/1HYa9LZ
	 zxRkMF+ci5xm8pld5aC5tT8jtkWGu8evXXAN3DNIZA7W0DYsjn08SSc1hdM5SgMW7b
	 cbgM6xrcXWqbL+mYGXMSxSjwlxrKtAcsEzkZ+/o6rea8VIAC+B2UZP7yqAyyjmRcF9
	 seyjNd4vTQYZP38gV1yV+/aDTfvsnlPOghjT4MkQSgqRo5FUKPuWljK8QBsuEo3k5e
	 ARgFh+fKOHi0A==
Date: Tue, 17 Mar 2026 21:36:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 10/13] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <26db2d1e-7e44-4dd1-9544-d6e4b5b7cee1@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032605.234046-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226032605.234046-1-npache@redhat.com>
X-Stat-Signature: 4sphb6p9rgrj35ht3ctyusm75ojqcoc5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EBA331C0011
X-HE-Tag: 1773783398-860558
X-HE-Meta: U2FsdGVkX182r3UJk3WFMNlCU0lUgCqP9RrNMEMq8aaBU06EFHHgv+wO9QvWXi7nda1ysY9E0Atg6k3PnoLGrOYNNim/0MLgJnTxkWvzadUNS5Sb5XJ7+e6WPEoU6rKAPxzyhLsoNCw5lOpFj+ktdy3SR5lkb552enlwUTvtzeFe+2GA6E/xcnvrEa9BKzbRE/xMRqdrm31pGgDjXyv2Vpj+gShGQX4WG3NgJBvuDUXrgsx1sVZ+X889WnxjQ0EwG7+Azk5yP/+pxFGXUpIlpr4Ce+WIs3EB2ZS4Jv1ktmoY9wAYYwW1uqAO2okycnaJUm4xYWR+xwouDK1Ud4bZ8draaRAMvUxRTK39UHU8D0oeXJh3MJfrEZNNc/wRcSO/7LTmvrPprlaF0On/WS+Ew65WqJ+X0+mv8Sl51xCGCelRGIEWYCtwR6URG4Dx6AAFHKhE+OkSxwkAGJ2T73HXtrdOINtI1cOCPY8gEpqtWrFsqKX1R/iJiMPI7svkjwlIBpsSUv+ifGw8f7t6L80cN8o8P2g3qiLiRkRbwwPtY1qCY9K2mqWoReQxKn+YKbGPLef9YUzFUJepI1Qk7igM8yzA5O/TSeroJj56e60E+aW++biBZVD8P1j0mxzThE6BIwPDVjy9ncQrPArmLpcg1BITBkIVZs2ouoU1KFN+STZAGwK3O8ucAoTkPhoXb+quhlMaC6PLyFKUekJG6SILTuaeTylhrzlcviSHrTFjswek1iD7H5irX6i+lrAQhUkhbdBxZgPA/DdqJ3FjA6H5JfAcOk0fCtrG+t8BxqF8jnCEuQfyI7MZI2J1IYZOCreUqXT84eSsQ7F37qGEK2a7dAJys/QReO3F1l1jYPLL+9FyOCoSOG59eZA1zC7XJ4lGcCu29RMRErvZAxB5XwoiAmhbUmcLrEOAnlYKsgMLGuHkebxldNhN2Ofo560++aE9XTFsUlURgpLzDpA6lbD
 ycGSEoFe
 AxGAgu7vgLFip0kmDV1PEowWnSP4iN4DM5WFuXT/o/fgYXAckxr0LKCr17l91H5oAWniY5kkzkgIhCzgxOP0//dS3AHj5VDcK1scKibk4wDw0iaI+vaISaLMLNUQp2P1KmN9/EvukvouD69dIpIQQVGBilvFN4tGx82bcZtQZ5GY17NhZLWRZcAXF6fgLldvAcqw919bb54QQb8vAcNHmvRN8sQB6fyqgAQGBXEcmAPExnrJKA6u5zq54AK+x/3R+8Fp0ZHxbmtxn6PMRsVx0lFj1af382ERj4zJZUP2yKOMc3cj668ruiJ/6vV16TorUcEsY2ixXgo/9mHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:26:05PM -0700, Nico Pache wrote:
> Enable khugepaged to collapse to mTHP orders. This patch implements the
> main scanning logic using a bitmap to track occupied pages and a stack
> structure that allows us to find optimal collapse sizes.
>
> Previous to this patch, PMD collapse had 3 main phases, a light weight
> scanning phase (mmap_read_lock) that determines a potential PMD
> collapse, a alloc phase (mmap unlocked), then finally heavier collapse

-> an alloc phase

> phase (mmap_write_lock).
>
> To enabled mTHP collapse we make the following changes:
>
> During PMD scan phase, track occupied pages in a bitmap. When mTHP
> orders are enabled, we remove the restriction of max_ptes_none during the
> scan phase to avoid missing potential mTHP collapse candidates. Once we
> have scanned the full PMD range and updated the bitmap to track occupied
> pages, we use the bitmap to find the optimal mTHP size.

Right bu reinstate it later right? :) Though now simpler as we have only two
modes.

>
> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> and determine the best eligible order for the collapse. A stack structure
> is used instead of traditional recursion to manage the search. The

Maybe worth saying due to limited kernel stack size.

> algorithm recursively splits the bitmap into smaller chunks to find the
> highest order mTHPs that satisfy the collapse criteria. We start by
> attempting the PMD order, then moved on the consecutively lower orders
> (mTHP collapse). The stack maintains a pair of variables (offset, order),
> indicating the number of PTEs from the start of the PMD, and the order of

Probably worth saying the stack is kept in the collapse_control now?

Having nitted all this, thanks for writing this up much appreciated :)

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
>                            offset       mid_offset
>                             |         |
>                             |         |
>                             v         v
>           __________________^_________________ <-- I think better as -
>          |          PTE Page.Table            |
>          -------------------.------------------
> 			    <-.-----><------->
>                           ^ .order-1  order- <-- not sure
                            . .            if I accidentally
                            . .       deleted or missing :P
                            . .
			    . .. Doesn't line up with..|
			    .this......................|
                                       ^
                                       |
                                       |
That's nice, but as a connoisseur of the ASCII diagram, a few nits :)

I also wonder if the offset, mid-offset is correct to put there?

Because you start off with:

(0, HPAGE_PMD_ORDER)

       offset
          |
          |
          v
          |------------------------------------|
          |                 PTE                |
          |------------------------------------|
	  <------------------------------------>
	                1 << order

Right? Trying to get the PMD sized one, then:

(offset=0, order=HPAGE_PMD_ORDER -1)
(mid_offset=HPAGE_PMD_NR >> 1, order=HPAGE_PMD_ORDER -1)

       offset           mid_offset
          |                  |
          |                  |
          v                  v
          |------------------------------------|
          |                 PTE                |
          |------------------------------------|
	  <------------------><---------------->
	       1 << order          1 << order

And etc.

So probably worth making that clear.

>
> We currently only support mTHP collapse for max_ptes_none values of 0
> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>
>     - max_ptes_none=0: Never introduce new empty pages during collapse
>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>       available mTHP order

Probably worth slightly expanding on what introducing 'new empty pages'
entails in practice here.

>
> Any other max_ptes_none value will emit a warning and skip mTHP collapse
> attempts. There should be no behavior change for PMD collapse.

Maybe worth saying we are doing this for the time being as it avoids issues
with the algorithm tending towards PMD collapse etc.?

>
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order (m)THP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will

I think it's confusing mentioning this here, probably better to move it
uabove.

> satisfy the promotion condition once again. This issue is prevented via
> the collapse_max_ptes_none() function which imposes the max_ptes_none
> restrictions above.
>
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.
>
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.

Overall a great commit message and THANK YOU so much for that excellent
description of the algorithm, much appreciated!

>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 189 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 180 insertions(+), 9 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2fdfb6d42cf9..1c3711ed4513 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -99,6 +99,32 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> +/*
> + * The maximum number of mTHP ranges that can be stored on the stack.
> + * This is calculated based on the number of PTE entries in a PTE page table
> + * and the minimum mTHP order.
> + *
> + * ilog2(MAX_PTRS_PER_PTE) is log2 of the maximum number of PTE entries.

I think this line is superfluous and can be removed :)

> + * This gives you the PMD_ORDER, and is needed in place of HPAGE_PMD_ORDER due
> + * to restrictions of some architectures (ie ppc64le).

Hm this is vague, why exactly?

> + *
> + * At most there will be 1 << (PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER) mTHP ranges

Maybe worth moving this around and saying 'the absolute most number of mTHP
ranges we can encounter is 1 << (PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER),
but due to some architectures restricting the number of pointers per PTE,
we have to derive the actual maximum from MAX_PTRS_PER_PTE'

And then add a paragraph on why arches do this (if it's just PPC, just
replace arches with PPC) etc.

> + */
> +#define MTHP_STACK_SIZE	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))

I think it'd be nice to have a separate define for ilog2(MAX_PTRS_PER_PTE),
maybe MAX_ORDER_PER_PTE?

> +
> +/*
> + * Defines a range of PTE entries in a PTE page table which are being
> + * considered for (m)THP collapse.

Probably we can drop the parens :)

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
> @@ -107,6 +133,11 @@ struct collapse_control {
>
>  	/* nodemask for allocation fallback */
>  	nodemask_t alloc_nmask;
> +
> +	/* bitmap used for mTHP collapse */

This is still super vague. Also you have 2 bitmaps here :)

Something like:

	/* Each bit set represents a present PTE entry  */
> +	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
	/* A mask of the current range being considered for mTHP collapse */
> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];

This time no heart attack as I know this is not on the stack (despite a
misunderstanding on a series where somebody did seem to want to try to do
that recently to reintroduce a coronary event :P)

>  };
>
>  /**
> @@ -1361,17 +1392,138 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	return result;
>  }
>
> +static void mthp_stack_push(struct collapse_control *cc, int *stack_size,
> +				   u16 offset, u8 order)
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
> +static struct mthp_range mthp_stack_pop(struct collapse_control *cc, int *stack_size)
> +{
> +	const int size = *stack_size;
> +
> +	VM_WARN_ON_ONCE(size <= 0);
> +	(*stack_size)--;
> +	return cc->mthp_bitmap_stack[size - 1];
> +}


I know I love helper structs, but I wonder if we chouldn't have a broader
stack object like:

struct mthp_stack_state {
	struct mthp_range *arr; // assigned to cc->mthp_bitmap-stack
	int size;
};

And just make these functions like:

static void mthp_stack_push(struct mthp_stack_state *stack)
{
	struct mthp_range *range = &stack->arr[stack->size++];

	VM_WARN_ON_ONCE(stack->size >= MTHP_STACK_SIZE);
	range->order = order;
	range->offset = offset;
}

static struct mthp_range mthp_stack_pop(struct mthp_stack_state *stack)
{
	struct mthp_range *range = &stack->arr[--stack->size];

	VM_WARN_ON_ONCE(stack->size <= 0);
	return *range;
}

I also fold some other cleanups into that, I think e.g. *stack-size--,
followed by using size (which we copied first) - 1 indexed into the array
is overwrought.

> +
> +static unsigned int mthp_nr_occupied_pte_entries(struct collapse_control *cc,

This name is a bit overwrought. pte_count_present()? I think we maybe don't
even need a mthp_ prefix given the params should give context?

> +						 u16 offset, unsigned long nr_pte_entries)

This line is super long, can we just put the 2nd line 2 tabs indented?

> +{
> +	bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);

Why are we zeroing HPAGE_PMD_NR bits, but mthp_bitmap_mask has
MAX_PTRS_PER_PTE entries?

I thought the comment above was saying how MAX_PTRS_PER_PTE can be <
HPAGE_PMD_NR right? So couldn't this be problematic on ppc?

We should be zeroing the same number of bits as is defined for the bitmap.

> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_pte_entries);
> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> +}

We could pass in a stack_state pointer if we add pointers to
cc->mthp_bitmap_mask and cc->mthp_bitmap to the struct:

static unsigned int pte_count_present_top(struct stack_state *stack)
{
	struct mthp_range *range = stack->arr[stack->size - 1];

	VM_WARN_ON_ONCE(!stack->size);

	/* set up mask for offset, range */
	bitmap_zero(stack->mask, MAX_PTRS_PER_PTE);
	bitmap_set(stack->mask, arr->offset, 1U << arr->order);

	/* Hamming weight of mask & bitmap = count of PTE entries in range. */
	return bitmap_weight_and(stack->bitmap, stack->mask, MAX_PTRS_PER_PTE);
}

Which could also simplify the calling code a lot, which then could pop
afterwards, leaving this to read the top of the stack.

Then again, you use order, nr_pte_entries elsewhere so could be:

static unsigned int pte_count_present(struct stack_state *stack,
		struct mthp_range *range) { ... }

Instead?

> +
> +/*
> + * mthp_collapse() consumes the bitmap that is generated during
> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> + *
> + * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.

Probably worth dropping the (!none/zero) bit for clarity.

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
> +
> + * If a collapse is permitted, we attempt to collapse the PTE range into a
> + * mTHP.

So this is pretty much the same as the commit message and obviously my
comments are the same here as for there :)

But again thanks for doing this!

> + */
> +static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		bool *mmap_locked, unsigned long enabled_orders)
> +{
> +	unsigned int max_ptes_none, nr_occupied_ptes;
> +	struct mthp_range range;
> +	unsigned long collapse_address;
> +	int collapsed = 0, stack_size = 0;
> +	unsigned long nr_pte_entries;
> +	u16 offset;
> +	u8 order;

I hate to now be the one saying it since somebody got me OCD about it
before, and it doesn't really matter and is a nit, but like reverse xmas
tree would be nice :P

> +
> +	mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> +
> +	while (stack_size > 0) {

I think we can be kernel-y and make this:

while (stack_size)

As going < 0 would be a bug anyway right?

> +		range = mthp_stack_pop(cc, &stack_size);
> +		order = range.order;
> +		offset = range.offset;
> +		nr_pte_entries = 1UL << order;

See above idea for using stack state type and just reading off top of stack
in calculation.

> +
> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		if (cc->is_khugepaged)
> +			max_ptes_none = collapse_max_ptes_none(order);
> +		else
> +			max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;

Hm, should we even be executing this loop at all for MADV_COLLAPSE? Could
we just separate that out as its own thing that just does a PMD-sized entry
and simplify this?

But then hmm you use order, nr_pte_entries elsewhere so maybe could just
pop range and pass that in with stack_state ptr?

> +
> +		if (max_ptes_none == -EINVAL)

Shouldn't we rather do something like IS_ERR_VALUE(max_ptes_none)?

> +			return collapsed;

> +
> +		nr_occupied_ptes = mthp_nr_occupied_pte_entries(cc, offset, nr_pte_entries);
> +
> +		if (nr_occupied_ptes >= nr_pte_entries - max_ptes_none) {

Be nicer to have nr_ptes_entries - max_ptes_none pre-calculated as a value,
e.g. min_occupied_ptes?

> +			int ret;
> +
> +			collapse_address = address + offset * PAGE_SIZE;
> +			ret = collapse_huge_page(mm, collapse_address, referenced,
> +						 unmapped, cc, mmap_locked,
> +						 order);

My kingdom for a helper struct here :)

> +			if (ret == SCAN_SUCCEED) {
> +				collapsed += nr_pte_entries;
> +				continue;
> +			}

I guess we don't care about which flavour of scan failure happens here?

> +		}
> +
> +next_order:
> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
> +			const u8 next_order = order - 1;
> +			const u16 mid_offset = offset + (nr_pte_entries / 2);
> +
> +			mthp_stack_push(cc, &stack_size, mid_offset, next_order);
> +			mthp_stack_push(cc, &stack_size, offset, next_order);

All this could be a helper function, like:

static void push_next_order_range(struct stack_state *stack, u8 order,
		u16 offset)
{
	const u8 next_order = order - 1;

	mthp_stack_push(stack, offset, next_order);
	offset += (1 << next_order);
	mthp_stack_push(stack, offset, next_order);
}

> +		}
> +	}
> +	return collapsed;
> +}

Overall MUCH more understandable thanks for that!

> +
>  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>  		unsigned int *cur_progress, struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> -	int none_or_zero = 0, shared = 0, referenced = 0;
> +	int i;
> +	int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
> +	unsigned int max_ptes_none;
>  	struct folio *folio = NULL;
>  	unsigned long addr;
> +	unsigned long enabled_orders;

Kinda hate how much state we're putting here throughout function scope, but
can address that in follow up cleanups I guses.

>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;

>
> @@ -1384,8 +1536,21 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> +	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);

Again, shouldn't this be MAX_PTRS_PER_PTE?

Be nicer to separate into a helper function esp if you have a stack_state
object, to initialise it separately rather than having a random open-coded
bitmap_zero() here.

>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);

Too long line :) please keep to max 80, with some small exceptions going
over by like 1 or 2 chars.

> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */
> +	if (cc->is_khugepaged && enabled_orders == BIT(HPAGE_PMD_ORDER))

Isn't BIT(HPAGE_PMD_ORDER) the same as HPAGE_PMD_NR?

> +		max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER);
> +	else
> +		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
> +

Coudl we separate this function into a helper struct please, rather than
piling on more open coded stuff?

>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
>  		if (cur_progress)
> @@ -1394,17 +1559,18 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> -	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, addr += PAGE_SIZE) {
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		_pte = pte + i;

(Still hate this underscore b.s. but it's legacy stuff we should deal with
separately)

> +		addr = start_addr + i * PAGE_SIZE;
> +		pte_t pteval = ptep_get(_pte);

Err you're declaring a type under 2 just-assignments? That's not kernel
style :)

Should be:

<type decls>
newline
<everything else>

> +
>  		if (cur_progress)
>  			*cur_progress += 1;
>
> -		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||

Why are we dropping this?

> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			    none_or_zero <= max_ptes_none) {
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -1478,6 +1644,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			}
>  		}
>
> +		/* Set bit for occupied pages */
> +		bitmap_set(cc->mthp_bitmap, i, 1);

Again, let's use a helper for this kind of thing rather than open
coding. The stack_state object will help.

>  		/*
>  		 * Record which node the original page is from and save this
>  		 * information to cc->node_load[].
> @@ -1534,9 +1702,12 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> -		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc, mmap_locked,
> -					    HPAGE_PMD_ORDER);
> +		nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
> +					      cc, mmap_locked, enabled_orders);
> +		if (nr_collapsed > 0)

if (nr_collapsed) is more kernelly :)

> +			result = SCAN_SUCCEED;
> +		else
> +			result = SCAN_FAIL;

I mean maybe we can just use a ?: assignment here like:

result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;

?

>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.53.0
>

Overall we're much much closer now to having this series in, sorry for
delays etc. in review but now I've (finally) got to review everything and
David has had a look too on both series we are honing in on completion!

Cheers, Lorenzo

