Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA55CFEA83B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609FA6B0092; Wed, 25 Mar 2026 06:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1456B0093; Wed, 25 Mar 2026 06:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F78A6B0096; Wed, 25 Mar 2026 06:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E54F6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:05:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F108D16086A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:05:51 +0000 (UTC)
X-FDA: 84584154102.24.DA91BF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A6B940005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:05:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wkhj7On3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774433150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9Af6/8CgHvFueVcgZbSFHji9sy2vetbkaL62Ux2BPc=;
	b=WTplhgFcaGnmwwf7Y+b/YDQa/Gc6ZG2JHUP4+t/ojREXjCNotL14B8FYBAhwcc02Uu9g7H
	XLrZ9FYX7H8UeMV4qZ+zr1sbFFT0bQy18XASS8i+kYURGVekO5udDW2KRcWPOyB3AFX+eO
	2nwCqJUvid5STWPkELxDPnzGu3cCP8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774433150; a=rsa-sha256;
	cv=none;
	b=XydXQWdUI5e486/yWebAYcFJoBf8EgdYj87O+B6CUboad5Qc0BDHSZV175w+6VYzyVZYVo
	QQRqkOxMMk9OAyUhsmkXXPd4+u7SsmdxEJIjABrJmuRbCPF7980bMaLUM1val+7rOepWMO
	chRqgBp/vuOF2hCQ+pSgVyNt/3Q5LtU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wkhj7On3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37CF2434E3;
	Wed, 25 Mar 2026 10:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3B4C4CEF7;
	Wed, 25 Mar 2026 10:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774433149;
	bh=RjaFN880HNwg7jZYg0XdvF9nTzidczdw40HtNEhgMlc=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Wkhj7On3GBGI1qyHmXm3FvywOQc4s4909x4u4jCO+60vvQKlTnnomLh3OAwv/43Oz
	 Orcn73sHQ3g8Zc0/Ef49BM2oVpi0ERt8tRs4x2tGA4MjcHJwkdJ2UpYtINImMROXgU
	 3DMSqqDQ/g+Rv6fcEEsNi5J/wsxXvk7tN5iNXc0XScAtRlDUv1B5LDaFsNDdDn3J3G
	 82nK1PZHsAYKwJMqRYsy5PsjnrLChXIMWz9l3E6+/DS78/UkFR6SDNHWrpATZodGVN
	 9dofOPv78NCtuGKSDsgoeYH6vLShcO9+gvTaZXxkRvU1T9qv9aifsCSvnFOXSLjzux
	 bqnZCqwCc6H0Q==
Message-ID: <e5d4e527-5e81-4713-a145-c87100973bea@kernel.org>
Date: Wed, 25 Mar 2026 11:05:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324133538.497616-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A6B940005
X-Stat-Signature: gtki75jrie71pppko87judp5nu83kfz6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774433149-912411
X-HE-Meta: U2FsdGVkX1+0P6vsqD5p0MHgZSBh0YoBW2da4R5xNLGCuSkhHAiuxvo6JYVTvorm1UsxhSFgVqEIbb1finLSbdLMXn3z/bKwe593dMCYfImqKe9oPi7WWfFniz+JOGlatHvi/84kO+c36YbpE08YJ652E4gFmyy21OxbHab6Wtal831mDdTNSVMqlEzyTuUSL2ZnClCkvH9ANRYj0Ki7Ap/HS9f75ejMhIMWd/2cALnYwzCCiunz3RbfjOcWmO5gXGSWIms8rzHWS5FJaycjUBwd7sHLDvTUssAxGqo+C+jdT0h0pOTqs3SSyCGuO1Mx/blY2tsk5yBjLVVyNhj5W/5ThMLoHe+x3kwFLFyq6YObBR19zAD4QPsRLmY1norW4Kme0uR7RHKEY5IRn1wpP5GBBSl5FG5kxU64ty/c37ZUR8yZeoda7Eqiad/Io3pmO626gkjgflTuc981BiI9XAqhKQUtKuNDpuX+9C7AU+wvTHy+iRC3jJd1CshrBM5Jb3UDo7T00RXcLzEEUryCq2Cl1cJaJ2fiOEkq+T4fbWfG1ikfotAgHv9TpTF3mweo8b85oxQ7i078bmTHSuhee7yzakI7lZf6o6O+GuH7/Ym8OtxNNCSkrAUYctFjef/DV+Bi3wMj7GtsIymhOzJ1D675SNlcFSYhRD31jZO+NywZ0L5wpxu+qmfw8c1I0CX1fKDyn9ORxLB8HrD5WSFCYcfSf5ngijkMTOu+55piNCzn+VAyPtPktQVomDv7xrb976W+XwFJWJ9pz3CbCeQuaMqnIx3dipGCq+EZ2XGQt2ofvOqi4CjMzAgI857RPN84QgZMaA9+7ZLn/K7N+38Q61Sg9STgju5Y6ybTLcfoBzEhmYeHt4YbQSP0iRSTfQ7wY3YL4M9Zhlw36vMjyNJmgkJRfEtwn6cLEbBY3NS/uHhgJH+iR5EBlx5wSwWDkEF0fZ21/ZDwPcTryPjaIHT
 Mltrv/XY
 Tgg12gL19P7livgjzRW9F8m+gI4RIgrPGcB2vfx7kxAtKNFw0qrUSpEqf/bKgn/ChtanOXVIyvoYfG6eXJDp9h66pJlYqhW0EmSNmQ67m+5hmNCXaw8u9/RIFahPZnAvcwu8+OVxMsixe1a2piFYt4PMMPIQsXg9/1S2R2Z0VAOoaKl96Wx/40onKIJyOiHQDQBC4AKl6arrSSTPwCbzlQCMqT7RTAjaDfceSsX/YKt2riBgZ6a9VV4ErD7PWS2KBLvfP9+WpmzXLDcQ+YvaogvuwY0fZVKtaJ3EA9KBybhamF3SPtwE6sQl/dlYD+8vahQ07n+8buuQWtHA564Bw6Y6OK4FgPE9TBZH7yMKW/NUHN63O2ifdeliSaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 14:35, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> must immediately split_page() to order-0 so that it remains compatible
> with users that want to access the underlying struct page.
> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> allocator") recently made it much more likely for vmalloc to allocate
> high order pages which are subsequently split to order-0.
> 
> Unfortunately this had the side effect of causing performance
> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> benchmarks). See Closes: tag. This happens because the high order pages
> must be gotten from the buddy but then because they are split to
> order-0, when they are freed they are freed to the order-0 pcp.
> Previously allocation was for order-0 pages so they were recycled from
> the pcp.
> 
> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> that it also frees that order-3 page to the order-3 pcp, then the
> regression could be removed.
> 
> So let's do exactly that; use the new __free_contig_range() API to
> batch-free contiguous ranges of pfns. This not only removes the
> regression, but significantly improves performance of vfree beyond the
> baseline.
> 
> A selection of test_vmalloc benchmarks running on arm64 server class
> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> large order pages from buddy allocator") was added in v6.19-rc1 where we
> see regressions. Then with this change performance is much better. (>0
> is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement):
> 
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> +=================+==========================================================+===================+====================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> 
> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v2:
> - Remove BUG_ON in favour of simple implementation as this has never
>   been seen to output any bug in the past as well
> - Move the free loop to separate function, free_pages_bulk()
> - Update stats, lruvec_stat in separate loop
> 
> Changes since v1:
> - Rebase on mm-new
> - Rerun benchmarks
> 
> Made-with: Cursor
> ---
>  include/linux/gfp.h |  2 ++
>  mm/page_alloc.c     | 23 +++++++++++++++++++++++
>  mm/vmalloc.c        | 16 +++++-----------
>  3 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 7c1f9da7c8e56..71f9097ab99a0 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  				struct page **page_array);
>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>  
> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
> +
>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>  				unsigned long nr_pages,
>  				struct page **page_array);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index eedce9a30eb7e..250cc07e547b8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  }
>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>  

Can we add some kerneldoc describing call context etc?

> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
> +{
> +	unsigned long start_pfn = 0, pfn;
> +	unsigned long i, nr_contig = 0;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		pfn = page_to_pfn(page_array[i]);
> +		if (!nr_contig) {
> +			start_pfn = pfn;
> +			nr_contig = 1;
> +		} else if (start_pfn + nr_contig != pfn) {
> +			__free_contig_range(start_pfn, nr_contig);
> +			start_pfn = pfn;
> +			nr_contig = 1;
> +			cond_resched();
> +		} else {
> +			nr_contig++;
> +		}
> +	}

Could we use num_pages_contiguous() here?

while (nr_pages) {
	unsigned long nr_contig_pages = num_pages_contiguous(page_array, nr_pages);

	__free_contig_range(pfn_to_page(*page_array), nr_contig_pages);
	
	nr_pages -= nr_contig;
	page_array += nr_contig;
	cond_resched();
}

Something like that?

> +	if (nr_contig)
> +		__free_contig_range(start_pfn, nr_contig);
> +}
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..e9b3d6451e48b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3459,19 +3459,13 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
>  
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
> +		for (i = 0; i < vm->nr_pages; i++)
> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>  	}
> +	free_pages_bulk(vm->pages, vm->nr_pages);
> +
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }


-- 
Cheers,

David

