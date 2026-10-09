Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC33BCA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04696B008C; Fri,  9 Oct 2026 13:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E5E6B0098; Fri,  9 Oct 2026 13:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955726B009B; Fri,  9 Oct 2026 13:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6746B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:00:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD1B91402CB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:00:35 +0000 (UTC)
X-FDA: 85303701630.22.A92EEE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0AAA740004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:00:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPBVQNEj;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565234;
	b=08nJblgmnAlIl55sn74Ba+sOSirhEYaphyyAcj8U7sC7rn3OVcckzi6WgM4ItjyhrT5slh
	izrq2143l/bveVP69bPn7GvPXbwwg/B0KAcn7rKGaU3fcWqi4JXmT0QyseNzWCp6Zi8rw+
	e+PE9U0BKmo2GQsyU+j7kZSoNMI5Fmg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPBVQNEj;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztyPoTsXQl2erL+nCDtIS3iAw5yK7s2FnhInIimetvY=;
	b=vV3zW7plVS3thaMQm/z1cwqBpjznVqWaCsMRYb3xzJhVN9lkQOQjP6Ix9OCk7L1XoEjYLj
	4wdBQIsOTtgZHbRxYdI4Y3B41yghSdYEMKP9AO5vOiNcSV0mhHsdaj/wOSuVQ67EmlTrqD
	c7vBKx0cWXBnfEd43v06vlyEmr8uSpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D36F640801;
	Fri,  9 Oct 2026 17:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8111C1F000FF;
	Fri,  9 Oct 2026 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565232;
	bh=ztyPoTsXQl2erL+nCDtIS3iAw5yK7s2FnhInIimetvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PPBVQNEjP1rpUk9athtUmv4P1WtB+86fpqSx6AnywR1TtsvYSJIFmJNxilRtHzu6e
	 fgQGXdRphhqRFLklVel6bYh6mpHunUliifxVYCBs+HAUBYHYMjbeas8wPR7ZsqJ/3V
	 7eFLqmJrb3o9bIyTjWzS5gtRj6YMUZSvkE1FTp1cIJPG7/2eAxipl58T6kYTuHqYw2
	 2aBWnqsCTriH0YTTyg9I5ATGBuVPFuG24npRcRxXy98EkvFS1hFqVdgoAMTbL1XWu1
	 ovV5WYF1EZtOHQLIlkOfsX/4VWk9KildRnDpshHtld1h/Kh1TJND71W4Folv/iGj2x
	 isfpdlTkTKlyQ==
Date: Fri, 9 Oct 2026 19:00:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] memblock: use binary search to locate candidate
 regions
Message-ID: <askdqgzm2Cbeo3SB@kernel.org>
References: <20261008190828.3221718-1-tarunsahu@google.com>
 <20261008190828.3221718-2-tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008190828.3221718-2-tarunsahu@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0AAA740004
X-Stat-Signature: tm6czth3t337ezx1xqr3dks7wokpyb8a
X-HE-Tag: 1791565233-312124
X-HE-Meta: U2FsdGVkX1/xEBekSy/qlD0S1OuwFywHbAMewjRBtWDvUSYc2O11FrkiQWEa/JtrIi+fGoKdAZ+rYr3QJI0PjNSEvLvD+TLU4X/riPaVy41upMyEKADLQe63HLu0hqHElid0Jy9EzOm8zHR/cWtRWPDmnJxbr+8GXZwgYiEe+uBQHmMfwxvdINGxGeUdW47LKhDRl4BTNsGxfIJVJ15vFXx9wvWSCMXHbeHVr3FOT01q2GgPNp3X4G0b/L84I1M+jYPvLNZwBtlNjMTX+j5QDK+eToHcmJgUAF78CZJd52qCRwyZfSmsoGeDHe3RjEeMbv4OnR9eKmELlIe3fOgblqjxaVhzOfRuOEDY7xMLWDBKclaQx0LZmQxxeFlip5AkQXAmE1t/O7/TJp5WH6dTbGrov1yumKyYwssDfBt6uBfjgbLSrj85CG0B+5qSPPMPGUxvb1BjoeElbZloHFUBS4tpoBdUZCwtreuaRY225LlFbrMP2Sbyd7ZGaa/FCnIqLXeaP8hdUT0NRIoon2lIMUcmFnGv+wYQAi+ODzH1Y5WNcaljr5Fx0B0jSG4qUhfQmQ+6g/o9o6rIo20hV1pwcbS5cVJr6KOdUZxGuJluDORW5n/BVRENl6bRFq1JkYrQ1bbFQ1M93+658IqyXpHJu4Z9nwdezMx9wzm5uPT4f5EGFCqjABwz3pV8NAWHkkP7WJjGMtCPS5qTH3VmKQBduZy4dyGEul/FBpccadwcYI4m4tA2/vw+CFiRs5A/q2Eny/SwzEgYVg0SYWIN+QSulwj+T1xKsP8RjVxnK4jfMCMSFgV/Vho9nl6xNjco7z6FymZ/+eSDFD3xN1Wh9T5T2YixO26XKAvQuRWaxl4n2cIyPg5YaQrJ6sMGsUT11V4OpnFBZUV8kLOQ69T0wNwC+xWi+gnfqRo/4+qnEj9qai5GN/PvAnfeajk+5Ry6Vbc3q7wtQEfPNkR5Lx3/r0I
 bilj818Q
 3qczlF1h9fBLHENrJkYHB1YGJE+8n7+Bs5J+ZNQij7OFLfaQmiTEgRqPdgft/QCzd2WfdOJGJWDc4nq6Yaa/HamPUhDc4+nQjSZZz8DFkARuPYTkrp+YuJwSmfIjAnUAMCrblnPFqRKjTV+QX7WPFxJGwzlG06mkjzHxBTsXDHmo+0866gugdH8G/k8DNtPS0HGtGKmHAH1KRhr7ANnny1M7XBWu8pOdpmMYgJJ0FaHfWDJM5lqY1hKL/9Q3nSZRLLdP0GKoldyD3vT8RFkgV+dUgqtVRVitgZ2ZvFhUC9HPlONw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 07:08:28PM +0000, Tarun Sahu wrote:
> Use binary search (memblock_bsearch_start) in memblock_add_range() and

The function name is __memblock_search now and I think you can drop it
altogether :)

> memblock_isolate_range() to locate candidate regions instead of linearly
> scanning from index 0.
> 
> Under heavy memory fragmentation (such as KHO page preservation registering

Comma instead of open parenthesis feels better to me.

> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
> 
> Using binary search reduces the candidate search complexity to O(log N)
> (from O(N)), cutting KHO memory retrieval time from ~268s to ~50ms.
> 
> memblock_search() open codes the same binary search, so reimplement it on
> top of the new helper.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  mm/memblock.c | 45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 59dda7d085f3..614d0a55dd70 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -586,6 +586,29 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
>  	type->total_size += size;
>  }
>  
> +/**
> + * __memblock_search - Find the first region index where rend > base
> + * @type: memblock type to search
> + * @base: base physical address of the candidate range
> + *
> + * Returns the first region index that could potentially overlap @base.

Return: for proper kernel-doc format AFAIR

> + */
> +static int __init_memblock __memblock_search(struct memblock_type *type,
> +						  phys_addr_t base)
> +{
> +	int mid, low = 0;
> +	int high = type->cnt;
> +
> +	while (low < high) {
> +		mid = (low + high) / 2;
> +		if (type->regions[mid].base + type->regions[mid].size <= base)
> +			low = mid + 1;
> +		else
> +			high = mid;
> +	}
> +	return low;
> +}
> +
>  /**
>   * memblock_add_range - add new memblock region
>   * @type: memblock type to add new region into
> @@ -644,8 +667,9 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	 */
>  	base = obase;
>  	nr_new = 0;
> +	idx = __memblock_search(type, base);
>  
> -	for (idx = 0; idx < type->cnt; idx++) {
> +	for (; idx < type->cnt; idx++) {


	for (idx = __memblock_search(type, base); ...

>  		struct memblock_region *rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
> @@ -821,7 +845,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  		if (memblock_double_array(type, base, size) < 0)
>  			return -ENOMEM;
>  
> -	for (idx = 0; idx < type->cnt; idx++) {
> +	idx = __memblock_search(type, base);
> +
> +	for (; idx < type->cnt; idx++) {

Same here or even

	for (int idx = __memblock_search(type, base); ...

>  		struct memblock_region *rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
> @@ -2062,19 +2088,10 @@ void __init memblock_mem_limit_remove_map(phys_addr_t limit)
>  
>  static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
>  {
> -	unsigned int left = 0, right = type->cnt;
> -
> -	do {
> -		unsigned int mid = (right + left) / 2;
> +	int idx = __memblock_search(type, addr);
>  
> -		if (addr < type->regions[mid].base)
> -			right = mid;
> -		else if (addr >= (type->regions[mid].base +
> -				  type->regions[mid].size))
> -			left = mid + 1;
> -		else
> -			return mid;
> -	} while (left < right);
> +	if (idx < type->cnt && addr >= type->regions[idx].base)
> +		return idx;
>  	return -1;
>  }
>  
> -- 
> 2.56.0.385.gd3acb90ef8-goog
> 

-- 
Sincerely yours,
Mike.

