Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12897CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4AE6B02B4; Mon,  1 Jun 2026 04:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165496B02B5; Mon,  1 Jun 2026 04:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EDD6B02B6; Mon,  1 Jun 2026 04:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E10FF6B02B4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:11:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 925BD1A05AF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:11:45 +0000 (UTC)
X-FDA: 84830624970.24.E23C6A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ADF0A20002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:11:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpxAmjyn;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780301503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSNftbJGsnq3TNPMWpL6UTmgHOG/97W41Dl/dBBTsAc=;
	b=vnCtfCGa+JYLToJtbKaTpdWmOCQtUliaMkuE6B7I8Ra4vRg/wmcpKCvRULlT3R95eyOy1C
	Gulzyfe8RSzfLLlye6gU3gqT4ZWF3fx5Afm8vXqI3e2wi2RiSdR4fpOH7SnmFq7Qo7SQZi
	xF2A4vfrbxmeSXLEedsl2SHUf+lJkMg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpxAmjyn;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780301503; a=rsa-sha256;
	cv=none;
	b=fcDMQ1LMODzeiVy9Bc/Epdu5ifmH6+z9UyqESRBBeW9tJ+dt2tR2QjWVzKV8Zk8x4kM2/b
	5suWm5fI08pNmro5mlA7cYHlXEmubsyi9s5oNr9Mij4JYic5Bar/nT31G56cjtuW41M9dJ
	4XDMsAgjnVAoMONMQsSDUgCEXLDaL90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98602415F7;
	Mon,  1 Jun 2026 08:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3511F00893;
	Mon,  1 Jun 2026 08:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780301502;
	bh=GSNftbJGsnq3TNPMWpL6UTmgHOG/97W41Dl/dBBTsAc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SpxAmjynIub96TJvoj67kov8rxbMelB4zuLMfXb2A1zqzT69Kp8SyJ8GUxCOrkE37
	 sJkmtXZs+sLZ2kczrGJpIT1qUFMQtIJx7P6EmS2W92BViMvQnXBaPNUmyzZsYGIvJv
	 1qAUIvbGw4QOi6wCsAaR5UHU/V5l61qXjvdp1uXHKcK9mVHgIlNRNoSugCjPRbF2oU
	 7Z1UYSmm4IPIwD3MZcGwgMnWN7eYcW/imgcUALaeK8BY3A48qY091v8RcjyyEYAgKN
	 ik1kB/igNJmlLbSulVBcJ0VQBgZ+NG9Avc1bT4IvlTUn9T/TpMBjsnUJoHjhtz5dWD
	 cfpNP4CS9JoFg==
Message-ID: <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
Date: Mon, 1 Jun 2026 10:11:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
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
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-12-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hg64ds5ckziqaqyamn15kk3a4hhj9mbt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADF0A20002
X-HE-Tag: 1780301503-768360
X-HE-Meta: U2FsdGVkX1+qJ8rQiC0/Xp/y030UzwMy0queuBoNmbfGrZLK30LEIYKMpviV8Ekvp2g1JN2a9B+sYR9acgc4iJiHHo0U6OhZZnKltIIEb6PwzQC62qKFwv9Fm3v9xp9ld5eVC7lzDZLX9X7xiRqjBcl1mNyUqeowJIVau3wsOyYSUzC2UOoS57wDuEW60DsI3d+3HstthVhcHmrXHt7L8kHqtDLQtTv6HqRjHGSfI0k+rkw7U4Tq08ZarnggWAMMKoTOqIR/pHo42F+ehl00AJZOhDlVZSPWTvI9rh9hZfV6oYRRVtbzdPdNUe0u6clvgVOzkPcjeK2V+l6fH6ZAS0rpKluDnkUDTrB/a95Y1ftOfseeePDR1J5Qy13B8gu0ezP5E/o5cKJS2kl9YibckTOOTGQP8KYgu90wn7qvS9NwLcwrECeWYUiL5McFocb93RrBGtrnsPjypQhFNciacu6ewEFJ4x5cG/UFyQnsnB6IPQ2ZQcWH6Uv2hrjon3RvWGWKqXZTM0tDPO9QqPZcHzKmVR8cSD+341vyaeiKxZYF5Haw+dXwgjbFiyXC8Xc5P7aT329GscspMYCQD2GTJUCHZnVZFDjpcf6XQdWVHU8UJNTNY3bDR+R4aa09yB0b3x54XSRjz78Y2sR0mG+j9WPJKGwNMYPABCIJ1XQoARWH8e9xnM7v7RwFCk7dt9wtF8zF/ikqto8sx5Lrck7YMpEd/AXhjIhl1kt7TzDbtyzBHfjMu5IvQBmFRXb33JrL2rJfjy8OuTf3uNDVBkOnt1z0WTc3dRfousXsr5EMGGQNISOzarHXWDpbVizMQnnHb/bv6+ilhxS0yre5GlcRqomfBsAziezFSgpUWPgJZfucV6d6d37QkriyA0YoGI5VXOnbnxDFjL0MkPNJmLfNoSwCaFHixYnHrjUz0f3WKMKCPXmJC03xbIr8QZvJjlNyerYJ+l9oMzMTXKeBacV
 tICZtYJO
 u1n4T8zuujsMqzaNV21AfJNxyASmE6PX5q+UOySY6I6XPTAy4Lk0EgLU5EJuG9aWPaUfyNl4EZ+iIk3zYld/QzvnNCQBz3R1lsgEWv0tmM1yiA5hXBb5MmAqYOPrixbVVGVjS3ltXatkfWBiBzFdCjDSTnGWyBAR4/2wqOFnCAUjCGBwVlTLd3yCzXflezjt3KiHUz9RMfphrQYOnULBvK38KWxZ4hslUkURDT8wOjKJnesGPRVRvc/xqffTl5RRTsY5yYOivV4lJJptXZiEeKtLO7jBu1TL2fBi0lWLT6xTM7pwTIeMQEI4oh+SDuLwwLVYUiv8r/uBduCmIN9/teAtyO5pRA68j601Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 17:00, Nico Pache wrote:

Finally time for the core piece :)

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


Reading this, it is unclear why exactly do we need the stack.

Why can't you work with offset + cur_order?

Initially,

	offset = 0;
	cur_order = HPAGE_PMD_ORDER;

If collapse succeeded, advance to next range.
If collapse failed, try next smaller order, keeping offset unchanged.

	if (failed && cur_order > KHUGEPAGED_MIN_MTHP_ORDER) {
		/* Try next smaller order. */
		cur_order = cur_order - 1;
	} else {
		/* Skip to next chunk. */
		offset += 1 << cur_order;
		cur_order = max_order_from_offset(offset);
	}

Of course, handling disabled orders. max_order_from_offset() is rather trivial
(natural buddy order, capped at HPAGE_PMD_ORDER).

What's the benefit of the stack?

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

I was confused there for a second why you mention ilog2, when it's really "We
cannot use HPAGE_PMD_ORDER.".

Best to simplify to:

"Note that we cannot use HPAGE_PMD_ORDER, because it is variable on some
architectures".

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

This should just be called something like "present_ptes"

> +	/* A mask of the current range being considered for mTHP collapse. */
> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];

This is really just a temporary bitmap used for collapse_mthp_count_present()
only. Either rename it, or better, avoid it completely.

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

You really just want to count the number of set bits? You don't need a temporary
bitmap for that.

Assume you want to check an order-2 (4 bits), bitmap_weight_and() would check
all bits ...

I'd suggest starting simple here, and avoiding the temporary bitmap.

Can we simply use bitmap_weight_from(cc->mthp_bitmap, offset, nr_ptes)?

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

You should note here, that we re-verify in mthp_collapse().

But the question is, whether we should relocate the check completely into
mthp_collapse(), instead of conditionally duplicating it.

What speaks against always populating the bitmap and making the decision in
mthp_collapse()?

Sure, we might scan a page table a bit longer, but the code gets clearer ... and
I am not sure if scanning some more page table entries is really that critical here.


> +	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
> +		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
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
> +		/* mmap_lock was released above, set lock_dropped */
>  		*lock_dropped = true;
> +		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;

As Lance says, this error handling likely needs some thought.

-- 
Cheers,

David

