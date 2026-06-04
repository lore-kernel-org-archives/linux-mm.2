Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE2FCD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E146B0005; Thu,  4 Jun 2026 10:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17AE6B0088; Thu,  4 Jun 2026 10:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF396B008A; Thu,  4 Jun 2026 10:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8D796B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:15:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DB1E1A07C4
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:15:09 +0000 (UTC)
X-FDA: 84842427138.08.679BA76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA233C001B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:14:59 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780582500;
	b=gAUnwZB2jiqQEHkcfaku1Wu5tOJ/9XKl3KbDYNxactPYzaRw2NmRACWoeL/PtdqdnIO8SD
	+1A7PnzWCmUlJRWlGh8UtPFu+tcSk9Il2ZgUMtbOt/fcy1WQOZ3gbcppbzq8ndSvsfsyw+
	MrdYyLmUVGT/TqhqhZhGztSpfrQVdH8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfkfMw8R;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780582500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TeCSwFcY1TICi/h5cWubzeJu2VOClK7cfXnsPuqg2g=;
	b=pCYDaMAZlbDhnZXrhVvPyM+9pQIptcGHlnZlw9QLIdMDnP9bw7S6XEt+gt7yv+LwgaGAta
	lhV+18xNbXn8ekzR8XorH/jCG0FBSAAwMXr7YW7EIq7Jo0PUiXkPETo4cojBjwNa2t0jpu
	mHBMPo3dB2mmMA7/l94f49IhSVE6SFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EE864363C;
	Thu,  4 Jun 2026 14:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9551F00893;
	Thu,  4 Jun 2026 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780582499;
	bh=6TeCSwFcY1TICi/h5cWubzeJu2VOClK7cfXnsPuqg2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RfkfMw8RJYbykieKNqD4yxk+UT80GwdmNIJWlMckRjjROvNZQ73OO8q2Qnipt0mU5
	 h+kAHecvkhkPphRCrgGEbxd/JIDRPky1zSeh9g2zMcP7GfXJjvODXgPU18/6pZlLUQ
	 +tSxgTmy9Sz/2BatXKztyCgMq2RBY96FSra9EpTA2z9uwavAtrYFozNdkXZxTTbiAh
	 eHbPvuk5Tg6BMpLCPzI8WbiHLRHiuc/0RmX3tH9ZNBZmgaDdjPYD0IDyBySrfrxQKP
	 AxprmnAi1JtLGvVRXlFtpMqwKt9lcNAAld6vQhqih995H7FiSY40Gt6YTU+9H5fkb8
	 YAwLsayRQfxrQ==
Date: Thu, 4 Jun 2026 15:14:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, 
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	Usama Arif <usama.arif@linux.dev>, usamaarif642@gmail.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <aiGFIrg8_vZZxnPg@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
 <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
 <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org>
 <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
X-HE-Tag: 1780582499-131162
X-HE-Meta: U2FsdGVkX1/wnz6QyFMLZ+vjEgbLhzCcMKGb0xeGPzt6uOhvXlgeLkgpUCqDTHUJVT6EQmtIUgjhcx8fZZ4Cho/fT4kUscMcoIyL2b7y7Wm7KnD+UmIYxXGIIQMEPEaHLd2njU2KaFSaaHe/FPZsLSxGbXhNjl81+N1dvcvBKMkA6FGDXs6G+4hui/NQl7iY09OFFi5a24J1uPRYUdzOlfQu7mb8y6ozltFiu9KhVctsoBst3JYxIr8UD0o8BIMi0/5L5D8i7+zyvQVJsu/UO+3CeSIJ9UPO0ZWPUpPzzzV84Rm/G1BOEdu7NE1P402aIeR6rfdQoK7Qt1w5ELBgGagCuj9hNoTJg3PUd3cD5/9wDfK1nQTpAJshqrA5fGko5zA2RZXvytXpQgbsZUSaYoXd3zU5w+JnJCkcR+8QzrdKVgb0lL8OyXp+VmGZuPtj1ZrAIzhs1yL1Ka6tsY+1bnAvafa2qssDq4cBGDSCMu7JRG4xbQb/Z/YKlBqbxveNerZZTYQuINo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 11:23:35AM -0600, Nico Pache wrote:
>
>
> On 6/1/26 7:15 AM, David Hildenbrand (Arm) wrote:
> >>>
> >>> Reading this, it is unclear why exactly do we need the stack.
> >>
> >> So I looked into your items below. It seems logical, and I think it
> >> works the same way; however, your method seems slightly harder to
> >> understand due to all the edge cases and more error-prone to future
> >> changes (the stack holds implicit knowledge of the offset/order that
> >> must now be tracked in the edge cases).
> >>
> >> Given the stack is 24 bytes, I'm not sure if the extra complexity is
> >> worth saving that small amount of memory. Although we would also be
> >> getting rid of (3?) functions, so both approaches have pros and cons.
> >
> > I consider a simple forward loop over the offset ... less complexity compared to
> > a stack structure :)
> >
> >>
> >> I will implement a patch comparing your solution against mine and send
> >> it here, then we can decide which approach is better.
> >
> > Right, throw it over the fence and I'll see how to improve it further.
>
> Ok heres what the diff looks like on top of my V19.
>
> you can access the tree here https://gitlab.com/npache/linux/-/commits/mthp-v19?ref_type=heads for easier review.
>
> So far I have no problem with this approach it appeared cleaner than i thought. Did some light testing. Gonna throw it more through the ringer tomorrow.
>
>
> From 9496c5d17eba7f6d04820d78c7c6f1592a58888a Mon Sep 17 00:00:00 2001
> From: Nico Pache <npache@redhat.com>
> Date: Tue, 2 Jun 2026 10:26:18 -0600
> Subject: [PATCH] convert from stack to forward loop
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 96 ++++++++-----------------------------------------
>  1 file changed, 15 insertions(+), 81 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 498eba009751..6de935e76ceb 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -100,28 +100,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
>  #define KHUGEPAGED_MIN_MTHP_ORDER	2
> -/*
> - * mthp_collapse() does an iterative DFS over a binary tree, from
> - * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
> - * size needed for a DFS on a binary tree is height + 1, where
> - * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
> - *
> - * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
> - * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
> - */
> -#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
> -
> -/*
> - * Defines a range of PTE entries in a PTE page table which are being
> - * considered for mTHP collapse.
> - *
> - * @offset: the offset of the first PTE entry in a PMD range.
> - * @order: the order of the PTE entries being considered for collapse.
> - */
> -struct mthp_range {
> -	u16 offset;
> -	u8 order;
> -};
>
>  struct collapse_control {
>  	bool is_khugepaged;
> @@ -137,7 +115,6 @@ struct collapse_control {
>
>  	/* Each bit represents a single occupied (!none/zero) page. */
>  	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
> -	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
>  };
>
>  /**
> @@ -1458,50 +1435,14 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	return result;
>  }
>
> -static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
> -				     u16 offset, u8 order)
> -{
> -	const int size = *stack_size;
> -	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
> -
> -	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
> -	stack->order = order;
> -	stack->offset = offset;
> -	(*stack_size)++;
> -}
> -
> -static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
> -						 int *stack_size)
> -{
> -	const int size = *stack_size;
> -
> -	VM_WARN_ON_ONCE(size <= 0);
> -	(*stack_size)--;
> -	return cc->mthp_bitmap_stack[size - 1];
> -}
> -
>  /*
>   * mthp_collapse() consumes the bitmap that is generated during
>   * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>   *
>   * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
> - * page. A stack structure cc->mthp_bitmap_stack is used to check different
> - * regions of the bitmap for collapse eligibility. The stack maintains a pair
> - * of variables (offset, order), indicating the number of PTEs from the start
> - * of the PMD, and the order of the potential collapse candidate respectively.
> - * We start at the PMD order and check if it is eligible for collapse; if not,
> - * we add two entries to the stack at a lower order to represent the left and
> - * right halves of the PTE page table we are examining.
> - *
> - *                         offset       mid_offset
> - *                         |         |
> - *                         |         |
> - *                         v         v
> - *      --------------------------------------
> - *      |       cc->mthp_present_ptes         |
> - *      --------------------------------------
> - *                         <-------><------->
> - *                          order-1  order-1
> + * page. We start at the PMD order and check if it is eligible for collapse;
> + * if not, we check the left and right halves of the PTE page table we are
> + * examining at a lower order.

Yeah this is not good enough sorry, before there was some kind of explanation of
the algortihm, just because you can explain the _code_ more simply, that's not
very useful.

I had to sit down and spend quite a bit of time to figure out how the actual
output looks so I think that should be explained.

>   *
>   * For each of these, we determine how many PTE entries are occupied in the
>   * range of PTE entries we propose to collapse, then we compare this to a
> @@ -1517,26 +1458,20 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>  {
>  	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
>  	enum scan_result last_result = SCAN_FAIL;
> -	int collapsed = 0, stack_size = 0;
> +	int collapsed = 0;
>  	bool alloc_failed = false;
>  	unsigned long collapse_address;
> -	struct mthp_range range;
> -	u16 offset;
> -	u8 order;
> +	unsigned int offset = 0;
> +	unsigned int order = HPAGE_PMD_ORDER;
>
> -	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
>
> -	while (stack_size) {
> -		range = collapse_mthp_stack_pop(cc, &stack_size);
> -		order = range.order;
> -		offset = range.offset;
> +	while (offset < HPAGE_PMD_NR) {
>  		nr_ptes = 1UL << order;
>
>  		if (!test_bit(order, &enabled_orders))
>  			goto next_order;
>
>  		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
> -
>  		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>  						      offset + nr_ptes);
>
> @@ -1553,7 +1488,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>  				collapsed += nr_ptes;
>  				fallthrough;
>  			case SCAN_PTE_MAPPED_HUGEPAGE:
> -				continue;
> +				goto next_offset;
>  			/* Cases where lower orders might still succeed */
>  			case SCAN_ALLOC_HUGE_PAGE_FAIL:
>  				alloc_failed = true;
> @@ -1581,15 +1516,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>  		}
>

This obviously needs some comments describing what you're doing here. I think
David said so too.

>  next_order:
> -		if ((BIT(order) - 1) & enabled_orders) {
> -			const u8 next_order = order - 1;
> -			const u16 mid_offset = offset + (nr_ptes / 2);
> -
> -			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
> -						 next_order);
> -			collapse_mthp_stack_push(cc, &stack_size, offset,
> -						 next_order);
> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
> +			(BIT(order) - 1) & enabled_orders) {

Wait, if I disable an order this changes the way we get mTHP doesn't it?

Let's say I disable order-4 but retain order-3 and order-2 for offset 0 we get:

9->8->7->6->5->5->6->5->5->7

And we simply can't get order-3 no?

This seems broken doesn't it? Maybe I'm missing something?


> +			order = order - 1;

order--?

> +			continue;
>  		}
> +next_offset:
> +		offset += nr_ptes;
> +		order = min_t(int, __ffs(offset), HPAGE_PMD_ORDER);

Also wouldn't, in the case where an enabled order check above skips an order--,
we could have offset=0 here and end up just looping around checking from (0,
HPAGE_PMD_ORDER) again? That also seems broken?

Also, what's __ffs(0)? Isn't it undefined? We shouldn't be relying on undefined
behaviour no?

https://elixir.bootlin.com/linux/v7.0.10/source/include/asm-generic/bitops/builtin-__ffs.h#L5
Says as much?

I guess we're assuming we're not going to get to 0 here, but that could do with
a comment or a VM_WARN_ON_ONCE() at least.

Also why aren't we making this a function?

static inline unsigned int max_order_from_offset(unsigned int offset)
{
	if (!offset)
		return HPAGE_PMD_ORDER;

	return __ffs(offset);
}

Though __ffs() works on unsigned long... probably... OK?

>  	}
>  done:
>  	if (collapsed)
> --
> 2.54.0
>
>
>
> >
> > [...]
> >
> >>>> +     bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
> >>>>       memset(cc->node_load, 0, sizeof(cc->node_load));
> >>>>       nodes_clear(cc->alloc_nmask);
> >>>> +
> >>>> +     enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
> >>>> +
> >>>> +     /*
> >>>> +      * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> >>>> +      * scan all pages to populate the bitmap for mTHP collapse.
> >>>> +      */
> >>>
> >>> You should note here, that we re-verify in mthp_collapse().
> >>>
> >>> But the question is, whether we should relocate the check completely into
> >>> mthp_collapse(), instead of conditionally duplicating it.
> >>>
> >>> What speaks against always populating the bitmap and making the decision in
> >>> mthp_collapse()?
> >>>
> >>> Sure, we might scan a page table a bit longer, but the code gets clearer ... and
> >>> I am not sure if scanning some more page table entries is really that critical here.
> >>
> >> Someone asked me to preserve the legacy behavior (PMD only). Although
> >> rather trivial, if you set max_ptes_none=0 for example, we'd still
> >> have to do 511 iterations for no reason if PMD collapse is the only
> >> enabled order rather than bailing immediately.
> >>
> >> I'm ok with dropping it, but I think its the correct approach (despite
> >> the extra complexity). @Usama Arif brought up this point here
> >> https://lore.kernel.org/all/f8f7bb71-ca31-46ee-a62d-7ddfd83e0ead@gmail.com/
> >
> > We talk about regressions, but I am not sure if we care about scanning speed
> > within a page table that much?
> >
> > After all, we locked it and already read some entries.
> >
> > Having the same check at two places to optimize for PMD order might right now
> > feel like a good optimization, but likely an irrelevant one in a near future?
> >
> > Anyhow, won't push back, as long as we document why we are special casing things
> > here.
> >
>

Thanks, Lorenzo

