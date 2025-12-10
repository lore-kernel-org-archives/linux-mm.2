Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94044D3C546
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 13:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9D06B0006; Wed, 10 Dec 2025 08:21:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690666B0007; Wed, 10 Dec 2025 08:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579F76B0008; Wed, 10 Dec 2025 08:21:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 459846B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:21:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2D6F5948C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 13:21:28 +0000 (UTC)
X-FDA: 84203623056.29.1A876FA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id C4BE6120015
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 13:21:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765372887; a=rsa-sha256;
	cv=none;
	b=cMpbrhauqkrwARyLuGigSBXI4ZMDOoCtkdgC3cwqhTEZbVWO4a98rtW2YjZwzUVRd7eBZm
	7XbRjrVVzY6TMmAaRxTSuHL/Fq1j1Ynen1Lb4t6RurJeL0pEoRbzBE4ia9B4vHfOnBTIsR
	rwivc0U/F+Zjs0nUtOcVsAI6AtvtYKo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765372887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OK40klnmTnIf2yIdbIncWE7q5KQZ3Y+JJsAWa117nf8=;
	b=Zp4DgGVZw4GfNfewDfOUaJd+sGlyw7/fPWO8p3aiCG4RR3am88fkdZ7yf+fGffuVphjwkE
	3+DunOZLCYg9UFgyTBE01DdsmYYD/KCGH2ypoOER7rewaK5JYuRQ3dD4tI9g9DdXFSoW6G
	J9Mgp913SUF+h9hERnr6gSZPssTCEn0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A720175D;
	Wed, 10 Dec 2025 05:21:18 -0800 (PST)
Received: from [10.57.90.205] (unknown [10.57.90.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA3453F762;
	Wed, 10 Dec 2025 05:21:24 -0800 (PST)
Message-ID: <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com>
Date: Wed, 10 Dec 2025 13:21:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Content-Language: en-GB
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251021194455.33351-2-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C4BE6120015
X-Rspamd-Server: rspam10
X-Stat-Signature: 8fxe4oicwtpqqjrrhky7itwbrshcpseh
X-HE-Tag: 1765372886-341891
X-HE-Meta: U2FsdGVkX18MY+HQHV+cVbyhIORTlqVXM/lzkZbNII7zq0E5quMSttMyg6iQAwIbhib01TQBwV5Lyj4OcNAhL4w3/S0FgXbfY9dRyELofe6LJqpAUfWXrMrasr2e0gcXnLfm7NSF2CrAggwUCYqKhJCEvGGR0C/XaC37LQ8IOwmNT9EP77gI4jxaVMsO2suA8AW/zfyRE1ZqCovM1h2rzNRbNgAY7GRpDVkogKTQ6iCfvSMGc+1wIoUoww2BZWjxA6RBEDc6Ixewdf5o1OSDTHgDhFhZhXPoqDMPImZ4kmUQOlqt8g0NUmbHCx16H+B/MIj5mKnq1ItvXc0UxZ51DK2C27GEvjouQ7vhJOtYWreyEnl1jKEsiidVMfcrEiQ/JEFvhl55UXdW7yAI8bhJO+KDHZMRNAlOJROaDR9taCQhbRgMnxz8P34mvTkQ1DD29eNI1c2IJrDSaWk+4yaDF1F985qnzPWJjM7w9X4ROYA1JlwJ4S/Z+Lo/tiO+9jGeooPD+qwyJoSFyUIxkqa4Oq7qlYUpNlyDMkfah1ZRWgA2XLOqeHh7zadlt/EsH13J6VAED7493Yn3tjGg+FtepnOCG628rwa3VvegQSNeheH+dI1r0Y44OHb/j7yspzGbGqCf16dOGdHy6FOPaoB55n0Oi4WbHuWkwVOn2n3WblWxEPTMHNH2Zp2W+6KCw4WFiB4riAnLjfeL6HsGnB4at3uIRQhdeiRqVbqhM4dv6yX5WviBWCNQRU9mrHn3QgB114cE61v2YtPwl//dM5Asbm5zV4KWatPw3M27b/vd0G0xXwrnuyFFvUI9LE0XmE4TvjrH+FaaxZNqtKQA/auJZpHyDqZ+py6MyseRQehJAN1yh+KOm1ld1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,


On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> allocator. Rather than making requests to the buddy allocator for at
> most 100 pages at a time, we can eagerly request large order pages a
> smaller number of times.
> 
> We still split the large order pages down to order-0 as the rest of the
> vmalloc code (and some callers) depend on it. We still defer to the bulk
> allocator and fallback path in case of order-0 pages or failure.
> 
> Running 1000 iterations of allocations on a small 4GB system finds:
> 
> 1000 2mb allocations:
> 	[Baseline]			[This patch]
> 	real    46.310s			real    0m34.582
> 	user    0.001s			user    0.006s
> 	sys     46.058s			sys     0m34.365s
> 
> 10000 200kb allocations:
> 	[Baseline]			[This patch]
> 	real    56.104s			real    0m43.696
> 	user    0.001s			user    0.003s
> 	sys     55.375s			sys     0m42.995s

I'm seeing some big vmalloc micro benchmark regressions on arm64, for which 
bisect is pointing to this patch.

The tests are all originally from the vmalloc_test module. Note that (R) 
indicates a statistically significant regression and (I) indicates a 
statistically improvement.

p is number of pages in the allocation, h is huge. So it looks like the 
regressions are all coming for the non-huge case, where we want to split to 
order-0.

+---------------------------------+----------------------------------------------------------+------------+------------------------+
| Benchmark                       | Result Class                                             |     6-18-0 |   6-18-0-gc2f2b01b74be |
+=================================+==========================================================+============+========================+
| micromm/vmalloc                 | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  514126.58 |            (R) -42.20% |
|                                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |  320458.33 |                 -0.02% |
|                                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  399680.33 |            (R) -23.43% |
|                                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  788723.25 |            (R) -23.66% |
|                                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |  979839.58 |                 -1.05% |
|                                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  481454.58 |            (R) -23.99% |
|                                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |  615924.00 |              (I) 2.56% |
|                                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         | 1799224.08 |            (R) -23.28% |
|                                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         | 2313859.25 |              (I) 3.43% |
|                                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         | 3541904.75 |            (R) -23.86% |
|                                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         | 3597577.25 |             (R) -2.97% |
|                                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |  487021.83 |              (I) 4.95% |
|                                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  344466.33 |                 -0.65% |
|                                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  342484.25 |                 -1.58% |
|                                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     | 4034901.17 |            (R) -25.35% |
|                                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |  195973.42 |                  0.57% |
|                                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  643489.33 |            (R) -47.63% |
|                                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        | 2029261.33 |            (R) -27.88% |
|                                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |   83557.08 |                 -0.22% |
+---------------------------------+----------------------------------------------------------+------------+------------------------+

I have a couple of thoughts from looking at the patch:

 - Perhaps split_page() is the bulk of the cost? Previously for this case we 
   were allocating order-0 so there was no split to do. For h=1, split would 
   have already been called so that would explain why no regression for that 
   case?

 - I guess we are bypassing the pcpu cache? Could this be having an effect? Dev 
   (cc'ed) did some similar investigation a while back and saw increased vmalloc 
   latencies when bypassing pcpu cache.

 - Philosophically is allocating physically contiguous memory when it is not 
   strictly needed the right thing to do? Large physically contiguous blocks are 
   a scarce resource so we don't want to waste them. Although I guess it could 
   be argued that this actually preserves the contiguous blocks because the 
   lifetime of all the pages is tied together. Anyway, I doubt this is the 
   reason for the slow down, since those benchmarks are not under memory 
   pressure.

Anyway, it would be good to resolve the performance regressions if we can.

Thanks,
Ryan

> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> 
> -----
> RFC:
> https://lore.kernel.org/linux-mm/20251014182754.4329-1-vishal.moola@gmail.com/
> 
> Changes since rfc:
>   - Mask off NO_FAIL in large_gfp
>   - Mask off GFP_COMP in large_gfp
> There was discussion about warning on and rejecting unsupported GFP
> flags in vmalloc, I'll have a separate patch for that.
> 
>   - Introduce nr_remaining variable to track total pages
>   - Calculate large order as (min(max_order, ilog2())
>   - Attempt lower orders on failure before falling back to original path
>   - Drop unnecessary fallback comment change
> ---
>  mm/vmalloc.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index adde450ddf5e..0832f944544c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3619,8 +3619,44 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		unsigned int order, unsigned int nr_pages, struct page **pages)
>  {
>  	unsigned int nr_allocated = 0;
> +	unsigned int nr_remaining = nr_pages;
> +	unsigned int max_attempt_order = MAX_PAGE_ORDER;
>  	struct page *page;
>  	int i;
> +	gfp_t large_gfp = (gfp &
> +		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
> +		| __GFP_NOWARN;
> +	unsigned int large_order = ilog2(nr_remaining);
> +
> +	large_order = min(max_attempt_order, large_order);
> +
> +	/*
> +	 * Initially, attempt to have the page allocator give us large order
> +	 * pages. Do not attempt allocating smaller than order chunks since
> +	 * __vmap_pages_range() expects physically contigous pages of exactly
> +	 * order long chunks.
> +	 */
> +	while (large_order > order && nr_remaining) {
> +		if (nid == NUMA_NO_NODE)
> +			page = alloc_pages_noprof(large_gfp, large_order);
> +		else
> +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> +
> +		if (unlikely(!page)) {
> +			max_attempt_order = --large_order;
> +			continue;
> +		}
> +
> +		split_page(page, large_order);
> +		for (i = 0; i < (1U << large_order); i++)
> +			pages[nr_allocated + i] = page + i;
> +
> +		nr_allocated += 1U << large_order;
> +		nr_remaining = nr_pages - nr_allocated;
> +
> +		large_order = ilog2(nr_remaining);
> +		large_order = min(max_attempt_order, large_order);
> +	}
>  
>  	/*
>  	 * For order-0 pages we make use of bulk allocator, if


