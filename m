Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE114D3515F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5198D6B0005; Wed,  1 Apr 2026 05:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0076B0088; Wed,  1 Apr 2026 05:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D786B0089; Wed,  1 Apr 2026 05:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3196B6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:07:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C06CE1B867F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:07:36 +0000 (UTC)
X-FDA: 84609408912.14.C6FCCC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC766180004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:07:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CQ9qN/q9";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CQ9qN/q9";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775034455; a=rsa-sha256;
	cv=none;
	b=PZIAJsILp9okTU6boNzkzOaqmdheBVdlJxZ3j1+32tA6YZ9LqDw1IlHaXJaAaG9QEaqORP
	1C71+cMj/CbpfAmWTqd0R7Lpa0UsDJRw+odGFl7mvs4QG0dE3e3RYHGc22TY+jKDfQIM6u
	Y3FfbP2meHRDQXRpHNaly6T2d0lLb34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775034455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Au0W8p0anXBwQRw2VDaI7GC5Qu7bLo+qw2kp9GkG+qI=;
	b=b5b2QXDRL7aDxoO99SDtX5sPi4ozXf8pTxqKcIat1hSY/GdT/xh+N292Nou22Phf2r01v5
	mRmjqNGVD86YNpZkPU5LkfKbOcC3sUxdlkoBiPL6QfA7KAUR7639/8Cs1vOljrckdew8nl
	E407tFPI/KVHPTSSnvbm7twVt3mKt70=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F008A4068F;
	Wed,  1 Apr 2026 09:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DABC4CEF7;
	Wed,  1 Apr 2026 09:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775034453;
	bh=Ai0SUn3D0BgOXKunw85YnznITvntYENkG+BT90h3JJw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=CQ9qN/q9y4FNLLtzCh9t3G0lfNYLNTTQbKnGgiICdJXULSK1z6Yx6WMQBAqlTLp+X
	 owAXSJYhv1dl7eWTLwfo58G+DhR71jcau28Jc/wBXytG+cip8u7hZqtgCXamzxlitF
	 CRm94ybj4QV4kSjoVcMq2K6Er5F0mSqK0EMp87IkyWqhnj86kzU675WNUSEaAD0lTm
	 yTVmjnCXLgx+n620nMFTdYkgSrno6oGnSixsdiFUTehKaXt9K3JRhrI+VEj8XHQ6bC
	 jF0SV8GBkhlH4TJe9n+ZHZI6N6QPO/YQNRn64G6FNHHhxGtmNK0+EK9gcVpyg9g+Fr
	 apLueOKG/2e+g==
Message-ID: <f61e0fa6-a716-405f-bce9-a2bf4ef0c045@kernel.org>
Date: Wed, 1 Apr 2026 11:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] mm/page_alloc: Optimize free_contig_range()
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260331152208.975266-1-usama.anjum@arm.com>
 <20260331152208.975266-2-usama.anjum@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260331152208.975266-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC766180004
X-Stat-Signature: ycbgjx5kqudeaek5xppzy69j3jfi1qam
X-Rspam-User: 
X-HE-Tag: 1775034454-877139
X-HE-Meta: U2FsdGVkX1+6vpUGYiBywZhGAAIlVuoLNhO3bsZOBnAM0xS+ReLa9YR7IvpD223gYJKQgnHOkqWZ28D5OA7PKLAYc3ICyNyqMGnDgNKbjCoubtHZ6apvVCAgvhpEHBUnlMy3W0S1NT+84YgMEhpH8Rz6BP3N1sAUjgz/y/jVxKrEekpMhM0wRQldJC3j4sLedaYJRwJ2QehSHV2A4x/bcApZ03eR/DaYEk+ssO+LtvtTBX7DBVbKPAcMbhzXdOIxSZoNsxLLPmF0QicNqYfVzNnqN552zRxa6vE84IlgHfMy/EBO4JWeFnJbFXH5EWNfIMYXwydEZnYkDEJ0Gel8VFWtdDg9KWhlzfbonaFirkFVwWYUOcBqzycsiumJ7+P34GPHUD0gZnbL4Ayl/sGPAdfzdOp+QnmzZ0NNevOLq8liv1I42RKIwbBRHy0XCr0WSMTHnudRYc59DnzVo/dUJAHxTDVWvah77lprTgKCPmuuxb90kbCRLIhOumFjxQmeq1Q6T77ArWb/0tIhJhOPUsSBvZqOkGwvvNjD3PDk9PhdahogVLfEGDhbw7UYKy/FEOMjssDn+7gcFsMcR3qYEV7khkyds391ljygHTW5oq0MBKTxotEhs22LW/B1Ybp6uxtaw8DaVPK8jqiawdzp22Q//Q3Xr+/EoiMH79RRwC6UKiF4iaDAFauKSOqRtAktHbPeg0jOATIumhfSjpzvzkyFLobxcEtDkRNg3MhM/oOt4IQ9Gkv7W0jRpC89Z4nkTu0h8wN1yKG1oxe0EVCkTnwJoChe93HxM9lDkYEEsNXXFiuT0xsY9MqSBrUrjV4nE+0AIWULIc+AOgsRMqX5PrNVlahLKytpSj/Nczh/k2zxY5i/UgH9IbCA+9qHzsm1AEFzpqhgZG6Q3C/7XoWB6sRVo9HejCxTe3Ypq9+AMR2cIVm8CnzEChW6d/OP2ZrWtDV/kTmEyZNJphkA4YP
 5AFp854y
 Y+rzbHvpMJp1pqDVWWGw5rsuxJfYJtMQilu+hmox+8bGkojo3096zg7u1SCb2e2g+0CTAfYa8d7hOro2tgf6oJcXm3t2sV75t2JpOJENXnuyFBaIS/sXR4I9VsawCo1Tja+5bAslhkQLZFTFkDDSv+Ic5lxrHwLb3SyDdVRlUFvkbSQyHqjS1ugi+uqff45tMZKE7nEXTC/QCyPRtTTu+7Oj4psFYmbq47x/N8TEIc8gsBvB1N3MX5eXIpkukuBT9T4+1jfRSKVVMFNgYnJeHacWc5MD5RaSe+kJK4xtalZmJPEe+6b84NdR7R2gDOWR9dBSrznhnP5hiYw28XoP79owZOFkGW24xgH7OBY5fgT/4HTd24b+eEvmUH3+TCkZJR4BjBx5fUOwPzr6fJy6j+vxeuxEt/Sn2FyAxo7U4lVw4BMoCc6w9ZbZT0kML3Q7WCiHUUpa1rcLDdpaZ2lQeVkRoog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 17:21, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Decompose the range of order-0 pages to be freed into the set of largest
> possible power-of-2 size and aligned chunks and free them to the pcp or
> buddy. This improves on the previous approach which freed each order-0
> page individually in a loop. Testing shows performance to be improved by
> more than 10x in some cases.
> 
> Since each page is order-0, we must decrement each page's reference
> count individually and only consider the page for freeing as part of a
> high order chunk if the reference count goes to zero. Additionally
> free_pages_prepare() must be called for each individual order-0 page
> too, so that the struct page state and global accounting state can be
> appropriately managed. But once this is done, the resulting high order
> chunks can be freed as a unit to the pcp or buddy.
> 
> This significantly speeds up the free operation but also has the side
> benefit that high order blocks are added to the pcp instead of each page
> ending up on the pcp order-0 list; memory remains more readily available
> in high orders.
> 
> vmalloc will shortly become a user of this new optimized
> free_contig_range() since it aggressively allocates high order
> non-compound pages, but then calls split_page() to end up with
> contiguous order-0 pages. These can now be freed much more efficiently.
> 
> The execution time of the following function was measured in a server
> class arm64 machine:
> 
> static int page_alloc_high_order_test(void)
> {
> 	unsigned int order = HPAGE_PMD_ORDER;
> 	struct page *page;
> 	int i;
> 
> 	for (i = 0; i < 100000; i++) {
> 		page = alloc_pages(GFP_KERNEL, order);
> 		if (!page)
> 			return -1;
> 		split_page(page, order);
> 		free_contig_range(page_to_pfn(page), 1UL << order);
> 	}
> 
> 	return 0;
> }
> 
> Execution time before: 4097358 usec
> Execution time after:   729831 usec
> 
> Perf trace before:
> 
>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>             |
>             ---kthread
>                0xffffb33c12a26af8
>                |
>                |--98.13%--0xffffb33c12a26060
>                |          |
>                |          |--97.37%--free_contig_range
>                |          |          |
>                |          |          |--94.93%--___free_pages
>                |          |          |          |
>                |          |          |          |--55.42%--__free_frozen_pages
>                |          |          |          |          |
>                |          |          |          |           --43.20%--free_frozen_page_commit
>                |          |          |          |                     |
>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>                |          |          |          |
>                |          |          |          |--11.53%--_raw_spin_trylock
>                |          |          |          |
>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>                |          |          |          |
>                |          |          |          |--5.64%--_raw_spin_unlock
>                |          |          |          |
>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>                |          |          |          |
>                |          |          |           --1.07%--free_frozen_page_commit
>                |          |          |
>                |          |           --1.54%--__free_frozen_pages
>                |          |
>                |           --0.77%--___free_pages
>                |
>                 --0.98%--0xffffb33c12a26078
>                           alloc_pages_noprof
> 
> Perf trace after:
> 
>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>             |
>             |--5.52%--__free_contig_range
>             |          |
>             |          |--5.00%--free_prepared_contig_range
>             |          |          |
>             |          |          |--1.43%--__free_frozen_pages
>             |          |          |          |
>             |          |          |           --0.51%--free_frozen_page_commit
>             |          |          |
>             |          |          |--1.08%--_raw_spin_trylock
>             |          |          |
>             |          |           --0.89%--_raw_spin_unlock
>             |          |
>             |           --0.52%--free_pages_prepare
>             |
>              --2.90%--ret_from_fork
>                        kthread
>                        0xffffae1c12abeaf8
>                        0xffffae1c12abe7a0
>                        |
>                         --2.69%--vfree
>                                   __free_contig_range
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit below:

> @@ -6784,6 +6790,103 @@ void __init page_alloc_sysctl_init(void)
>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>  }
>  
> +static void free_prepared_contig_range(struct page *page,
> +		unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned long pfn = page_to_pfn(page);

Sorry for not noticing earlier. I now realized that because here we are
guaranteed to be restricted to the same section, we can do page_to_pfn()
just once outside the loop and then "pfn += 1UL << order;" below?

> +		unsigned int order;
> +
> +		/* We are limited by the largest buddy order. */
> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
> +		/* Don't exceed the number of pages to free. */
> +		order = min_t(unsigned int, order, ilog2(nr_pages));
> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
> +
> +		/*
> +		 * Free the chunk as a single block. Our caller has already
> +		 * called free_pages_prepare() for each order-0 page.
> +		 */
> +		__free_frozen_pages(page, order, FPI_PREPARED);
> +
> +		page += 1UL << order;
> +		nr_pages -= 1UL << order;
> +	}
> +}
> +
> +static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
> +		bool is_frozen)
> +{
> +	struct page *page, *start = NULL;
> +	unsigned long nr_start = 0;
> +	unsigned long start_sec;
> +	unsigned long i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		bool can_free = true;
> +
> +		/*
> +		 * Contiguous PFNs might not have contiguous "struct pages"
> +		 * in some kernel configs: page++ across a section boundary
> +		 * is undefined. Use pfn_to_page() for each PFN.
> +		 */
> +		page = pfn_to_page(pfn + i);

Hm ideally we'd have some pfn+page iterator thingy that would just do a
page++ on configs where it's contiguous and this more expensive operation
otherwise. Wonder why we don't have it yet. But that's for a possible
followup, not required now.

> +
> +		VM_WARN_ON_ONCE(PageHead(page));
> +		VM_WARN_ON_ONCE(PageTail(page));
> +
> +		if (!is_frozen)
> +			can_free = put_page_testzero(page);
> +
> +		if (can_free)
> +			can_free = free_pages_prepare(page, 0);
> +
> +		if (!can_free) {
> +			if (start) {
> +				free_prepared_contig_range(start, i - nr_start);
> +				start = NULL;
> +			}
> +			continue;
> +		}
> +
> +		if (start && memdesc_section(page->flags) != start_sec) {
> +			free_prepared_contig_range(start, i - nr_start);
> +			start = page;
> +			nr_start = i;
> +			start_sec = memdesc_section(page->flags);
> +		} else if (!start) {
> +			start = page;
> +			nr_start = i;
> +			start_sec = memdesc_section(page->flags);
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, nr_pages - nr_start);
> +}
> +



