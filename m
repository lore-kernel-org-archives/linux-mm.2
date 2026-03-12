Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBC8106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676946B00C3; Thu, 12 Mar 2026 17:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E5E6B00C4; Thu, 12 Mar 2026 17:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530186B00C5; Thu, 12 Mar 2026 17:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B13C6B00C3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:17:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EF0D1B7EEE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:17:15 +0000 (UTC)
X-FDA: 84538671630.11.AADAFB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FBCDA0002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:17:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYZmjqS3;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jkac9UhPWn2jj6zopFbckpYOo9eF8211ZONhJMEgss=;
	b=fNs9uCgx9x0+EZ9JIczg/1bJEPx0A/b6JYRmpPtQxuTAAZStQisL6Z7tH0OeR6qA+5UtK+
	J/Ll7xgm5K7a30hHNGcwawNzF8S1UEkMuOhL48Ndc4rrtafwU2agfvyi7/o0t2Z0RJwmGi
	NtrtKCZSSHNA3NuixM4LVDt42GWw7Nk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350233; a=rsa-sha256;
	cv=none;
	b=1NSSTksmQi7bcNO0lcGGTNQQkAVDNFxVG7+u8qNMFn2QfSQqnB90NMsMyVDO1pmGifTm/0
	sIQtyhOYzfaKjobzODpKd2r5278Or3Jq2lrLwOAIk3e5eHPk0l1hVzn8rE7/jfHHc8ymU2
	qWZtto9yNihFYHbWecm4Cb5QCvxWXEM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYZmjqS3;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59F1A60142;
	Thu, 12 Mar 2026 21:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077BDC4CEF7;
	Thu, 12 Mar 2026 21:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773350232;
	bh=SwAKyaACG6/Nu8KsQQ7/gnIrUN4D+lqR8H7BYj/Gywk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CYZmjqS39gmuILDMykVsCM318kwN8XIivLqBOf+V1XhsS0MOFvv+EUplvntUOcXgS
	 JDKtG36WimmoNaBo6GnrFLOH2k3Xl5cd2Mg2IkjX/Dqee8T7De2bZobs17XzppMuck
	 k5wY+CnT/PBlmYy7XQVEhqneMaKS35TrGUOjGivxDYj0so/m/+QEcCPgAAEO83Lgpb
	 553QHiMuKIxBI4ZfbIZb0S+QaVRnDlE7vu5vIL33OjZyPS2VawAWJMYXDXasGJapKM
	 eVxQY7wXeBitH4qdoBsDlkwoDIGAVPicB+mDH4Sd68z2JT5DoQ1b6CoLBx41J7RpkN
	 +pbaLFux/zhbQ==
Message-ID: <fa626160-3996-4689-bc56-f53efe95f614@kernel.org>
Date: Thu, 12 Mar 2026 22:16:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 10/13] mm/khugepaged: Introduce mTHP
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
 <20260226032605.234046-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032605.234046-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FBCDA0002
X-Stat-Signature: ktn41feq694ozrsm77w5pi1iok4pwxes
X-HE-Tag: 1773350233-941277
X-HE-Meta: U2FsdGVkX18ClsMueHKT/Ay4W4jj4gtp3GrHV/fe66dHNddfQgiNSorFdNNiDKMVCvkxBeGWMkB3FPeVx6zkOI/gcdx1bLZiW6k9LPuQABGw842SBqHNtTHOlamnCBscz9R6hbTYAvhm4sFvW+rJnjectLFYFPPY4AAl0nPHJuYQTsRopEp8OdVjPkFpYkk0YvS7Uly7IOxIs8bEgmfsHkLVdxfaIXRgTZ8R7aZssLP+kEgKMD8Z2adz/ibYrnJvRFluLGh4dV/rOs8Clw7h/8/2sLceoqap0zt4vLw3yuTzSpivcrYYykVtVjdNUuThu+dkEkYlkwsWLVW4Y0oBJ0cqe3HWWJotM4/vsJbbMExC/hXbcQus3POU+VGGDsozXmWNy8w+Sw7KINs5o/IzGDPLHXOPDokTaIZAdXhAghplO3gTIWzlSb4Dfbcaard/TcGW57mzK3D/B58qvSH0LIvPgmTashyHKOSniMl84b1KJdkObP1Sbf1Qcdl/GfzX+8H5Q0EQlqc3+usn6IDDa8yqxlrS0PU64EoVZJr1bUUcI4bFxgMOeFTclEXui+hMHA+LQKXg+dqhE67Ur8GwtQ8MexFcdq7BalqZkf26Jk8vzfA78qRiXZnKHk6PW+duURaSfX6yh9JGAPGAhNqgqijox9xqP8EvpLFuZ/0eLUNW22lPakEWBwmqTjqbcHx7tAOQp2WgqznJuohxaVatlNvyG1Y8EeSN3vLLHQtHm/wY5uczFS8wQlKWhP2tGpmxY47zmlFIHnOPF5ztyzmvjPza9gsAm5MFGT6hKGya5AtyNnoBM7/8zYGux6S23zyV1qMQ6CsR/y2LNufM3m+2LkD6LOuSp2eEUidc1eOPIgK5fSKceTYAuXiLir0C+PRhLsPBgPX3H5Lom+flB3Gib3LIf0jWW1rA/3wm0DlfDjoWwcZkpaZEACaBSMIIcPS35JtXlwQjYHcuAshSXY3
 ko/KZTNz
 e7G3rtPtyC5Fb9NtEzlepwkYo+0WNguB0Yw8WH6pIFfy1rDfIWoQjULDh2rMcK2taMgAjJfvjX74Flx0QFcrVsZH2SkykKYqxMIPFd4Yb8lHvVStiHATVUhC8aoKhYP5Df5Sdi8wW9j8eYlVHp6eXrqhWqn+MqYHbEoT6u9J3AFPHc/jxJHSQCqFH5/TuvoT0N9U+8Nhjv1l6+7P7UVguwWi4eGfffjwSUx1Jh40vhiW2MCyBDJywceakhykE1K7BVcRR4MbQGUJHVdgyN/CoHTiyw74aAMBg0M+404x8JBVzgNGi2F27jzou5QhHObl6QcZ91LIo4L6IQhz0/lyjKIplx3mjOzwnaebqWdU+14TluQ+H94FI4ZFSvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:26, Nico Pache wrote:
> Enable khugepaged to collapse to mTHP orders. This patch implements the
> main scanning logic using a bitmap to track occupied pages and a stack
> structure that allows us to find optimal collapse sizes.
> 
> Previous to this patch, PMD collapse had 3 main phases, a light weight
> scanning phase (mmap_read_lock) that determines a potential PMD
> collapse, a alloc phase (mmap unlocked), then finally heavier collapse
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
> is used instead of traditional recursion to manage the search. The
> algorithm recursively splits the bitmap into smaller chunks to find the
> highest order mTHPs that satisfy the collapse criteria. We start by
> attempting the PMD order, then moved on the consecutively lower orders
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
>                            offset       mid_offset
>                             |         |
>                             |         |
>                             v         v
>           ____________________________________
>          |          PTE Page Table            |
>          --------------------------------------
> 			    <-------><------->
>                              order-1  order-1
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
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order (m)THP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will
> satisfy the promotion condition once again. This issue is prevented via
> the collapse_max_ptes_none() function which imposes the max_ptes_none
> restrictions above.
> 
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.
> 
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---


[...]


>  /**
> @@ -1361,17 +1392,138 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	return result;
>  }
>  
> +static void mthp_stack_push(struct collapse_control *cc, int *stack_size,
> +				   u16 offset, u8 order)

Nit: indentation. Same for other functions.

Wondering if you'd want to call these functions

collapse_mthp_*

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
> +
> +static unsigned int mthp_nr_occupied_pte_entries(struct collapse_control *cc,
> +						 u16 offset, unsigned long nr_pte_entries)

s/pte_entries/ptes/ ?

> +{
> +	bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_pte_entries);
> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, HPAGE_PMD_NR);
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
> +
> + * If a collapse is permitted, we attempt to collapse the PTE range into a
> + * mTHP.
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

"nr_ptes" ? Any reason for that to be an unsigned long?

> +	u16 offset;
> +	u8 order;
> +
> +	mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> +
> +	while (stack_size > 0) {
> +		range = mthp_stack_pop(cc, &stack_size);
> +		order = range.order;
> +		offset = range.offset;
> +		nr_pte_entries = 1UL << order;
> +
> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		if (cc->is_khugepaged)
> +			max_ptes_none = collapse_max_ptes_none(order);
> +		else
> +			max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
> +
> +		if (max_ptes_none == -EINVAL)
> +			return collapsed;

With the previous suggested rework, you could likely make this

	max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
	if (max_ptes_none < 0)
		return collapsed;

> +
> +		nr_occupied_ptes = mthp_nr_occupied_pte_entries(cc, offset, nr_pte_entries);
> +
> +		if (nr_occupied_ptes >= nr_pte_entries - max_ptes_none) {
> +			int ret;
> +
> +			collapse_address = address + offset * PAGE_SIZE;
> +			ret = collapse_huge_page(mm, collapse_address, referenced,
> +						 unmapped, cc, mmap_locked,
> +						 order);
> +			if (ret == SCAN_SUCCEED) {
> +				collapsed += nr_pte_entries;
> +				continue;
> +			}
> +		}
> +
> +next_order:
> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
> +			const u8 next_order = order - 1;
> +			const u16 mid_offset = offset + (nr_pte_entries / 2);
> +
> +			mthp_stack_push(cc, &stack_size, mid_offset, next_order);
> +			mthp_stack_push(cc, &stack_size, offset, next_order);
> +		}
> +	}
> +	return collapsed;
> +}
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
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
>  
> @@ -1384,8 +1536,21 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>  
> +	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */
> +	if (cc->is_khugepaged && enabled_orders == BIT(HPAGE_PMD_ORDER))
> +		max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER);
> +	else
> +		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
> +

I assume that code to change as well. If you need help figuring out how
to make it work, please shout.

[...]

-- 
Cheers,

David

