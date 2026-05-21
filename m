Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88FACD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 02:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841CC6B0088; Wed, 20 May 2026 22:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA6A6B008A; Wed, 20 May 2026 22:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BA36B008C; Wed, 20 May 2026 22:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA8F6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:36:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0A4C1A02A2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:36:53 +0000 (UTC)
X-FDA: 84789864306.09.32E18DB
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0025240003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:36:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGemM7YO;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779331012; a=rsa-sha256;
	cv=none;
	b=j+OnqAVAWKWeuScumqPpIUBKSOSMfrygnG6QJwM+WeqWFi0ZYzwEvC1qp9V75P8b9KdPYx
	CAIxMyTIpAnEInh4MBmVbk/4JNODYW/b+6yg77dgOmlWhh3AGH5yt0v6+ay201PvZtlCeH
	N+NmWGmFLCyrr+U74kKE2aCdJc+1Ulk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGemM7YO;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779331012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Avh3E+vYvcraVHbYESBY7YcLl+tulAKrqfXLmy+0klM=;
	b=nhlcJ+9OsFZ7b4HV9NQ1D1bidj4LiWa8Qkfi8r3VzefhzltGjeQJqcTwa4w6Ijc3XYmOdv
	i5YFGXcnQ0y6+6xNRv7sxzsgsddeyDx7yQMVXptUQskHvWzeuQeQ+kx5IXw69gNI3X3k78
	8u7W8sZFZFQTGkRv302xPPIkYmz62cU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-83975e992e1so2193203b3a.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 19:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779331011; x=1779935811; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Avh3E+vYvcraVHbYESBY7YcLl+tulAKrqfXLmy+0klM=;
        b=VGemM7YO/++aR/qpZdxRO2bEQeRxe4bkuP4AU26WrgIp1CANIhiPeNbe8zYfF0YtFa
         mHPeDXO2LA8bDgf448GzmePJ+5yAfSZq0KmitTp4Wb3dJqacL868nDb00iEuMV1fm57s
         mQPg7CCS0+yTzzwI+ybNAYQGFR2HOYbQxm9gkGw9fbsinFs8jjHf0mbSPuj4/GXju/Ko
         ePOQxS8LKQWRs3+/6hjclICoaSMjLfKd9lUqsUgKoG8IcolqAXyofjQW1SY/Bm0MsUbW
         us/gOi+MslV586YcVlnRwbKrSeUN/R2eUSyxiv6OqMrJ8CRSKyUbc4aA7qojaK3+iOC1
         TaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779331011; x=1779935811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Avh3E+vYvcraVHbYESBY7YcLl+tulAKrqfXLmy+0klM=;
        b=MezBOvuOuJzpdO8CLoixv0Y/AILIjTHG7eT67YsGqKCcR2HheCK9OICVDbi3xOfkm/
         1oxQNAvyTTAC7j2dHGODe1ehrebDcxuz6il3Ke1T89LVJxSuZTpxsHsg61EJRB2N1ry6
         I29wVfMpSwtigGNxeEpWZVnx4yUP6ifVCrcpp55h54KRfcs+P5XTXuBvz+4b7NTMFCVi
         trh7yM4PZ/libEsMwrwnL0wW5iavh4rT+iTencFxIrBv6MyGlwnGvEPi1vBfgVjnLwtM
         OyH0xUrB4cIOWMNMGQtF6Y8SVJGl7+MeygWuBGxNtYOFHB6OiJuoEjhBLoYbOmNJ3lAU
         bIUg==
X-Forwarded-Encrypted: i=1; AFNElJ/7qMEQo6BGwwihIFX6EjZMgnOOCPUXNXdYR1M2Zehdix2xYOhD20elxYGY9r6umGQUDn9KQvF3wg==@kvack.org
X-Gm-Message-State: AOJu0Yw77qy04v80ke2cXmt/Znt/e6YfVTN7ZRivnRISwDdrsPvoicii
	L1s0YNn7ufycjC5nrhYjFDAxxpsekFhf+aXRmwpYSWxpTtyxe4YO+NC1
X-Gm-Gg: Acq92OFqN96+6QhIWnzK7BU0PwnM20rixG4ihl+9WyAiivHjxkCtiymRkPrDOousU3N
	+WRIyqGoYuOfaKtDGJFm6bi7Qh9KQ09YMxKQ9bh6sk1uA1ObC150nCvaj5Cac+mJJ82nKlifk8X
	UomzVgQjOGeZHfu2fji5270raRh4uPmDZRqjW44qAa5eyWtIKfbWVvGl9oB5cBbZv10UQrHLE8i
	Cw/gC+dBlpnb+BUaXW/uuhUoyCPXO0j0Ueb1qjMhkigm4Z+5EdzfjDC4v5jPWh0WUsQJOcKSWXd
	o8W/rBvJLZHsRO7PKMt57mUF5UHkbRT8VBr+ocQbMFNmXzGiTD312MJF2CUq00/D+2ypGlBKuy+
	zcMDLZWDZ/Pp2+2gy8TpszWWz8u/r2jjR7zTKN2ss7hjVcKJ6p1noJkghtJrLa/iWRgiGJDqt95
	Arf/VoDpbDOElOEvWGRJGpfHrTHmngz/LiZujXYw==
X-Received: by 2002:a05:6a00:4655:b0:838:6d43:9488 with SMTP id d2e1a72fcca58-8414ae00ed3mr932635b3a.32.1779331010434;
        Wed, 20 May 2026 19:36:50 -0700 (PDT)
Received: from localhost.localdomain ([155.254.122.137])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c5be71sm21376355b3a.39.2026.05.20.19.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 19:36:50 -0700 (PDT)
Date: Thu, 21 May 2026 10:36:15 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <8f9834db-8981-4eb1-ae46-94908943da3d@gmail.com>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-12-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511185817.686831-12-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0025240003
X-Rspamd-Server: rspam03
X-Stat-Signature: 4caq9yuew9unuprzfwtxxk3seqpq514o
X-HE-Tag: 1779331011-630626
X-HE-Meta: U2FsdGVkX19PIenPe9pmeEVXF4S4UCjV6C+A2J2rTyztrmSymPg0rvlwP4qcgoOHbL5m6xmBoZMzuAgNcTSJamSMvO/Ys9kKK430LJCOb2ZDKN3Jce/gNOLaVWy50UbSOdox7/RiK/tuqJq1F92uwaSUIzCGVQxBj+bZlKh4B/qtuqs6e9MypjHcvet2kAaT8LIbQ6SOGRtTffGU5rVkM8j7YUi7+kSbAf7XR1q8BziZVXe/+PgN4g5Vc/qtgAVJ2HAVpcjjmyVOn7grRtP33ihcjqsW+0vJWn9TTdZjj+HEP2PD53jnyZH0JDHuqCJBhX9LE16RFqigX75wyVc9iW1tymFjMoFnwnWPaoW6rjdhYTmiC4Yb0Zf3cNLT0t3c8ty9SjZsWz44g+joLtyhGL1GMdNO+D/BoWidQgMi+bwY688uLVPwb8pV1IuFQ80sD8++Gogo4nkpw/9S6CNCwvEU1KjEQL9TOE75uKiSsJZpudd/q5t7AE48FUWiCZ+Qij960FpEJsL8oUl1/KFZXWOmpf4XK6El98+MoJdX35W2b7821MKn+USH/92wv/QPOvlNzlHBH2Q4A7vXUdiKlb11EEEdWMdxh3S2ZNXtPZIzbOBopbiq/i6ep85XkgjjowvORpcdD2FT8BNS3ziX/MuD7R5FD5eOKuPbKXAdglxoF4t6Rt0sZT2XHTjtRdil2zKd4S7Qy+xqaA/I3fsvNIS4LyF4KuAx5nT65e5UOH0h9PYnwAdPRIz/2faID1h6vRMDazAK/OAYiImBb1BkJzYXuVlQO4y/Y0JwUlzsFaRlyF9c9VKV6H/4DYCtTwHepEfRqA9JebQxDDTvp0VI5X4+rfReztr03VrXRoEs12Q7kQquYXG/2sEELBqyhZUMVEjcHdKHhcse2w26zJ76+oOHSpItpFzH8LHt4HKg6iqK8PYCU+4qXlyy5dBAjxyFl6JWbqOK9M3wpX8qO6T
 vpTdSg8K
 8YtUveA/GIcBIb9Tk21S+B8yGsLvCk5rjNNqv7EWd3cBdgXfmyH6HJ05892PpsXom2aXnAe74ojQiTVCO7oeKnbub3vbNG5vpCkLjFWSPL16TGw4N2WdcrzlXCaCGeSyN6WNBNXzZNDTBBLA/22soGIdOh6XW44I66GzVmyvHXOZH5qqNt/FViqi5wrNOUks9iPdhpMg9ixpoOf4DIf/qSJfC8vbPWqosZpxvGXcdTR+ip0wpUhNyA4EJX2jbxnGgtyr2xHq0T6n0JIly4K85itkAe+ET0R8Vy06tUokaXoCuXSIzrNDuXaS7jxiA7tNzMmTQ6LBG2oRPHb79A11EJkJ9zGFWGWYNA1GwHMeE0hCgY6n1F0M8m/q1RkzT3frebYBy/0DlwLn/bySzc2nYbpIehG53tODEgMems92BXzoHkTJlSVVnxcw1G2smbrMI6iQjIAXTMaUI3Iqg1Pv2LMr2VABUzGfxI4mk2Ns9LvfozU14Bl8+Q27ZX5V9Lb+7oc9T+ACD8iGPLjXX+VItn9YXqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
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
> Any other max_ptes_none value will emit a warning and skip mTHP collapse
> attempts. There should be no behavior change for PMD collapse.
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
>  mm/khugepaged.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 174 insertions(+), 8 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 3492b135d667..39bf7ea8a6e8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -100,6 +100,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
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
> @@ -111,6 +135,12 @@ struct collapse_control {
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
> @@ -1404,20 +1434,140 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
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
> +static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		unsigned long enabled_orders)
> +{
> +	unsigned int nr_occupied_ptes, nr_ptes;
> +	int max_ptes_none, collapsed = 0, stack_size = 0;
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
> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
> +
> +		if (max_ptes_none < 0)
> +			return collapsed;
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
> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {

Hi Nico, thank you very much for your contributions to this series.

I found a minor issue, for MADV_COLLAPSE, if collapse_huge_page() fails
for some reason (e.g. allocate folio), it goes to next_order and
continues splitting to the next small order. However, enabled_orders
only supports HPAGE_PMD_ORDER, so it keeps runing the split operations
without any effective work until KHUGEPAGED_MIN_MTHP_ORDER is reached
before exiting. For khugepaged, e.g. setting only 2MB to always, also
same phenomenon.

This does not affect the overall functionality of mthp collapse, just
redundant.

The redundant operations can be easily skipped with the following
modification. If I miss some thing, please let me know. Thanks!

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1a25af3d6d0f..fa407cce525c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1574,7 +1574,7 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
 		}

 next_order:
-		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
+		if ((BIT(order) - 1) & enabled_orders) {
 			const u8 next_order = order - 1;
 			const u16 mid_offset = offset + (nr_ptes / 2);

--
Cheers,
Vernon

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
> -	const int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> +	int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>  	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
>  	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
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
> @@ -1429,8 +1579,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
> +
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
>  		cc->progress++;
> @@ -1438,11 +1599,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
> @@ -1522,6 +1685,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			}
>  		}
>
> +		/* Set bit for occupied pages */
> +		__set_bit(i, cc->mthp_bitmap);
>  		/*
>  		 * Record which node the original page is from and save this
>  		 * information to cc->node_load[].
> @@ -1580,10 +1745,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	if (result == SCAN_SUCCEED) {
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
> -		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc, HPAGE_PMD_ORDER);
> +		nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
> +					      cc, enabled_orders);
>  		/* collapse_huge_page will return with the mmap_lock released */
>  		*lock_dropped = true;
> +		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.54.0
>
>

