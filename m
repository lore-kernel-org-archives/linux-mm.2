Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8ED3C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE016B0088; Thu, 24 Sep 2026 11:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F2C6B008A; Thu, 24 Sep 2026 11:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85966B0096; Thu, 24 Sep 2026 11:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8048E6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:26:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C38FC03B5
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:26:19 +0000 (UTC)
X-FDA: 85249032078.22.34A8DB4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02ACD180007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:26:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l6n9ELTV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790263577;
	b=T1OdsqOJaE6KIjpBL7SebhzGN75n9S1zB/i+Czd+/6m1/H8fCnHj9E/Rnt0O2W0GVNp0pI
	JLMc3yf9B9SZYeTz93jIAzd/Xr/CjN8fYzryvMkFrNS1/vkykhKGCQz96gga3M4IjQINAv
	HLzkGGX+eLYtcRsiEEW8y6B6uB2LA6Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l6n9ELTV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790263577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBA8WUUDk0qcKaw11Oj0h76VJLKac2jdxEolUBxlMHY=;
	b=uMQBj9//UOufu45BNqKKyvnbxpVLD1Kz+CjNt6OtSrVX5Xye9kGhKchb+uGSL7Kie/AVCZ
	LdUwNM5wZRHM31ChPlBw6NQqTSgwNNVFyEgFbXN6oqxvGY4D3DBFhZDEhHedsYJYT/S0Al
	dwq+hjWMZ7ylXeLRRtngZ3ihL2VxTnE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55C7B1476;
	Thu, 24 Sep 2026 08:26:12 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30A883F86F;
	Thu, 24 Sep 2026 08:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790263575; bh=B+Qpq0mGaw3xi25XZVIMrbmAYpvPUbmJS4mCwVTqyrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l6n9ELTVe2ZkaCPB8nIwz5Sc7JZOs68VmMkYvZCShdny6ZjohUe8b19JXSchJMYF4
	 uO3QIiF/YMJxoSE0UMYdLjyadb9nHTaDBWegle8Ib7Io9p8Jy5sXqC9NrROZxTUzzZ
	 GNcyquiJ6/sK6Y7PClYCIdP05QXcDxGvwxBTKEdQ=
Message-ID: <9547761f-7688-4351-b172-9e9d5fa28b15@arm.com>
Date: Thu, 24 Sep 2026 16:26:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] iommu/iova: convert from rbtree to maple tree
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux.dev, liam@infradead.org, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, ashok.raj@oss.qualcomm.com, jgg@ziepe.ca,
 kyle@mcmartin.ca
References: <20260818152505.1057922-1-riel@surriel.com>
 <20260818152505.1057922-2-riel@surriel.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260818152505.1057922-2-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ha1pp7zy4x8ho7zkmpwms1g5ikesygxh
X-Rspam-User: 
X-Rspamd-Queue-Id: 02ACD180007
X-HE-Tag: 1790263576-96790
X-HE-Meta: U2FsdGVkX1+hTjjdK6AXiwu0Qr1wAwKzp1hohtZuBSEebYZBYdYLqkCqkrdU9nVZwyX9KS8Ab9c1ueph0mE7gVJCiboyhDqiQbIJ/cDKx4sR9BJ0pKIz1YN8Cd4qnMKYVU2vPBzsGypzWpkTLqA3GJg4zERjWS0MClRM8q0qLICSArp9BAUhQLKgIfUhS/6GLU0T631P4BMFA/OXBFx93kANyuweEOc9ICzeMPpOcv8zIVtRN4c3zuvCaxplX3t2PN3ArPAi3ReKjkv1HhYDyBXoAH48cviwnqMgZyGjt27NGJuY3a+aCDrtR8imZf/2CLEJYtp2E9lsNX5+Dp/oKHCmhPgrSQpuh7KRHX0EJUw9dKhufOzBujJmh2mgCLFgKZXFvWUk6J3WXweXwp8R9MxmyLqUWNxVx6gaz1h+c7H+22sL78EzzA6lxQoPQ1PXOYlVu09yraroVsAdkniagm4+oV/xtUXlp6cXI7I1rCiKnZxzpE1QQ4p3Fj3xYhH1B6cESWAp7Wt+4xcWGyugDUsfLn38EkINHx3NWFfjDezA4dlL5F/99Ys7uM1ZGJPBjiD6gk7NL5zXmQ0HFcP/g+B4exZzi022ueiX3ApYISqrq09bvEhtKvgg4vLLprsFRC9X+Zx5i5l4bavxeDwLpOMLgAUPzvy0DOYlHpYMa3Fqr3ftiyGfjpYwaPHv92xsQTMPsjJ0U+cW7iTONSZEiI643rYU6KlozoLsbirTVRm8aYXOOZVYoV+FXrvXFLgjAZRimZiTOi9IGwhkB4ItVHAy4MGaV/v9Nm4aSZ6y/X+5h8kfZmLq1oii5UmMAfZII/8kJJi4aP+eJkDLSZFUzXmQthYfZMqYX6gJAr98yRfaR8GpDRs5VGS0IaCbb6mOT40ZynAjRYNxVnsskT8pfwH/CoKnZKevhtDhl9PdntTvhNekpdu7MtDU2KWmWXkIZsIegydcMab4AiydfCc
 jmreNSVx
 QJaKs4SCTFtNreDZL+ueUWjAKVP6cXqZ+Sq+G551Ay5oNsj0eyRnEXLj6/7vkv1QMdIWhdT+8HpXUFubNGi++y+xCOk6MNCcE+/Lw4fnP4b5zpxuN0NHoxSQ/4KVn8VLLvIaUE7lkyDvOWWkFugA0U1C870rBNHtZbBzOT4g9sN7d4NFD6K5kpMdpFrFjJbH+1Vhk69qYLabQHKNnJ4/MLt31VCUBwfVn16Dqq9ByzswdPX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/08/2026 4:25 pm, Rik van Riel wrote:
> alloc_iova() looks for free space by walking the rbtree linearly.
> On production workloads at Meta, enough CPUs have ended up in that walk
> at the same time to trigger soft lockups.
> 
> Index the iova ranges in a maple tree instead. Its gap search makes
> alloc_iova() O(log n).
> 
> __alloc_and_insert_iova_range() asks mas_empty_area_rev() for the
> highest free range below limit_pfn. Alignment is handled by rounding
> up the allocation size, prioritizing speed over address space waste,
> with the thought that many iova requests on a system will be similar
> in size, and reuse the same holes.
[...]
>   static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>   		unsigned long size, unsigned long limit_pfn,
>   			struct iova *new, bool size_aligned)
>   {
> -	struct rb_node *curr, *prev;
> -	struct iova *curr_iova;
>   	unsigned long flags;
> -	unsigned long new_pfn, retry_pfn;
> +	unsigned long new_pfn;
>   	unsigned long align_mask = ~0UL;
> -	unsigned long high_pfn = limit_pfn, low_pfn = iovad->start_pfn;
> +	unsigned long search_size = size;
> +	MA_STATE(mas, &iovad->mtree, 0, 0);
> +
> +	if (size_aligned) {
> +		unsigned long align = 1UL << fls_long(size - 1);
>   
> -	if (size_aligned)
>   		align_mask <<= fls_long(size - 1);
> +		search_size = size + align - 1;
> +	}

Perhaps it's a bit too much of a cool trick, but I think technically we 
could just do "search_size = size + ~align_mask" unconditionally.

However, either way I do worry somewhat about the increase in 
fragmentation and premature failures once the space starts to fill up. 
Say for simplicity we have a start_pfn of 0 and limit_pfn of 4 - with 
the current code we can successfully allocate a size of 1 (to IOVA 3) 
followed by a size of 3 (to IOVA 0), or even in the opposite order for 
the same result, whereas with this workaround we couldn't ever allocate 
the 3 either way if its search_size has to be 7.

AFAIK there are real-world use-cases where the usable IOVA space is 
relatively small compared to the sizes of some of the buffers being 
mapped, such that packing density matters (i.e. media stuff in mobile 
SoCs), so if at all possible it would be good if maple tree itself could 
be improved to support searching for a free range with a particular 
alignment (either explicit, or implied natural alignemnt of the size) 
rather than having to bodge it this way. Unfortunately we also can't 
just relax the general DMA API guarantee that DMA addresses are 
naturally-aligned to the mapping/allocation size, as who knows how many 
devices that might break.

> -	/* Walk the tree backwards */
> -	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);

FWIW I'm not much of a fan of the implicit scoped-cleanup stuff in 
general, but this seems like an instance where using guard() to simplify 
all the early returns might be worthwhile.

Thanks,
Robin.

> +	spin_lock_irqsave(&iovad->iova_lock, flags);
> +	/* No 32-bit request this large can fit until the hint is cleared. */
>   	if (limit_pfn <= iovad->dma_32bit_pfn &&
>   			size >= iovad->max32_alloc_size)
> -		goto iova32_full;
> -
> -	curr = __get_cached_rbnode(iovad, limit_pfn);
> -	curr_iova = to_iova(curr);
> -	retry_pfn = curr_iova->pfn_hi;
> -
> -retry:
> -	do {
> -		high_pfn = min(high_pfn, curr_iova->pfn_lo);
> -		new_pfn = (high_pfn - size) & align_mask;
> -		prev = curr;
> -		curr = rb_prev(curr);
> -		curr_iova = to_iova(curr);
> -	} while (curr && new_pfn <= curr_iova->pfn_hi && new_pfn >= low_pfn);
> -
> -	if (high_pfn < size || new_pfn < low_pfn) {
> -		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
> -			high_pfn = limit_pfn;
> -			low_pfn = retry_pfn + 1;
> -			curr = iova_find_limit(iovad, limit_pfn);
> -			curr_iova = to_iova(curr);
> -			goto retry;
> -		}
> -		iovad->max32_alloc_size = size;
> -		goto iova32_full;
> +		goto alloc_fail;
> +
> +	if (mas_empty_area_rev(&mas, iovad->start_pfn,
> +				 limit_pfn - 1, search_size)) {
> +		/* Only real exhaustion sets the hint, not a failed store. */
> +		if (limit_pfn <= iovad->dma_32bit_pfn)
> +			iovad->max32_alloc_size = size;
> +		goto alloc_fail;
>   	}
>   
> -	/* pfn_lo will point to size aligned address if size_aligned is set */
> +	/* The gap is search_size wide, so alignment cannot pass start_pfn. */
> +	new_pfn = (mas.last - size + 1) & align_mask;
> +
>   	new->pfn_lo = new_pfn;
> -	new->pfn_hi = new->pfn_lo + size - 1;
> +	new->pfn_hi = new_pfn + size - 1;
>   
> -	/* If we have 'prev', it's a valid place to start the insertion. */
> -	iova_insert_rbtree(&iovad->rbroot, new, prev);
> -	__cached_rbnode_insert_update(iovad, new);
> +	mas.index = new->pfn_lo;
> +	mas.last = new->pfn_hi;
> +	if (mas_store_gfp(&mas, new, GFP_ATOMIC))
> +		goto alloc_fail;
>   
> -	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +	spin_unlock_irqrestore(&iovad->iova_lock, flags);
>   	return 0;
>   
> -iova32_full:
> -	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +alloc_fail:
> +	spin_unlock_irqrestore(&iovad->iova_lock, flags);
>   	return -ENOMEM;
>   }

