Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188671061B01
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8176A6B009B; Mon, 30 Mar 2026 10:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDE26B009D; Mon, 30 Mar 2026 10:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B156B009E; Mon, 30 Mar 2026 10:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 624E26B009B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:28:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A318C210E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:28:01 +0000 (UTC)
X-FDA: 84602958762.22.48FD44D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 801071C000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:27:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOxoe8rO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774880879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBC0Lzs9ZIRR/QkruNsoieyKWcX0uJiSgc3mCVV24Oo=;
	b=TOm2+oyhefqxd9tV5RQHlRHZykUNhIxamCYhbxnPdOpEXcQE6/8gdLJbz9eDbsG1GH9iO3
	7y/2Urad1XUtdNoY+E2ANnY9gKTmgV0xjl2UY5Z8Fn+G4v4nntNmtYNNM+F2nOBGR942se
	I6a7ABdUjKdwZ2vRg1ZlkX3+d7AAb+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774880879; a=rsa-sha256;
	cv=none;
	b=VS/MpVYtn4SGmwN2g8n9t1bAyQdLrUrITAmLuoj9/3IWIhvpMmugrDNWTpOB6WxP+ULE/K
	qP09oMpWG6A64X16VCFKlbasLd4Fd6Ni0IgEe5SiL7aUnwLjoCSpbPSAm5xccK0YMi1NtE
	CkVcVJs42zLSk4g3O1FJEehIH+hDFOs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOxoe8rO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB37F60054;
	Mon, 30 Mar 2026 14:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913D5C4CEF7;
	Mon, 30 Mar 2026 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774880878;
	bh=DxOkyepqlRTRHob2py0zHTG/daww2DOCWW3Kz3YEkOk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=UOxoe8rOMowhIGLCLfxX4c4eG4vSpFprLoYzYNaqyxJ7B8q2hQSKShHTqqWQpohn0
	 WMTE79Vf25Z6ywgzhO/ee8rN1VkLSg11RqPvIU4tCx4RYFy+SGlhLA+FYrNjF9qdH+
	 bvc5Rvw9Q4T4Zps7hmzlWT4DN5K9j5nkt/vl3nCM4jjmHr65QSNef/PcGyFPn9yAic
	 CmkM0/zBW3/7bp3ZrRE1TDjW99DgbSqaG8DqU7JxBvZ9c/ati2Cqrv5ba105aQHEpE
	 tzkh3Rg6tgK2RvGMa5jNNAzN45DP/HcMFQFb43EMGpjYqo2hYHwmUGRI8IOPnibYmi
	 cfv6OOq3QBC7w==
Message-ID: <3b2380d1-e4ca-4e44-b67c-06780354f806@kernel.org>
Date: Mon, 30 Mar 2026 16:27:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm/page_alloc: Optimize free_contig_range()
Content-Language: en-US
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
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-2-usama.anjum@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260327125720.2270651-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 801071C000E
X-Stat-Signature: fissknqy9e36497g16aygk3sycsts8qx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774880879-495323
X-HE-Meta: U2FsdGVkX1/8bLpKSxUTNPshibm/gcMVYUwBDDAVFkzysN4fmPECEkika2Dq6bamSEc46IsAU8PcsDQtR2FQjThdTwrq8vdh0hBha6d3I97jtVlYkzkAQoEW+3dZ25bAD/M7NRdfb8s3xyFgBRKxXOw9i02hABgxsWtvdxkN8SMiRTHYCVXxDRIZhWXCPvehKDEZcok4MbFBdG/hhUI38HDnVJJ2OK5EWD3XAod938BirRB+2WM37VGfhzvhMinW/CMLZkUlLcUcg3DJduy2SOsiKTj1DYiAF22gWH98gEWCyUSggxP+BjNIv+WGtU9OetXaHTW2TyUjktMw9w0f13ykreogzjKmHZhrn7gFS4Ud7Jh8SsRWdPQfV3Yd5oR1cp3hqfEWdgm0ZCGGCg12/an7wpV7k3dgx/ch3AOi6ggwYTrW21OlwGNJzmpQB8H5uqrQREtgUOzCKa+nEc4kA9/hF43n+UPshIFFM0+Lerj0A6FEV2Y7FtFaJSUdpy74dNgKF5r7R9dc36cQc7/jYiewC1YYkwF4OpypmZvVoLogI54nD06INUZDntqfFdhPLt40+pXOBlY2K6iGeu+5igO1eHT2pgm+kX1+K3R3zBrV93rK1I+SkurzGVhzYkT4Bw+YAVWwKRdhZke0hsI1XB1embvvQoUOgBq0HtlUTma+aXD4G8GgG4Oaht1bT8+VJMa92KBSy6HIum7n7Ysv3ONFj0fFmMrVhSZtLz/f5TZqEDwV1LoxQslZ45WUGS+w90zNeD246pS9I+xdvGi1pIG7ULgRBT//6Rwa9aC6SAKtA5OKvkxTeZiSzpyGQhm7soBLtlgbUE1uajvOB32DEnjoGM7Dn9b566Pd6ZGGCzstm419GZS0nO6BW2hg5wPHAq9d43Uws7GbAs404WAPTZ7LtcCImnmA6hpzjkYHMjg7V79RAstda3lN8PN+eX7xdjQEpMWmy18fO9XWHXm
 id8cxLkz
 T2fBljH25sibtJHeZ4odq7UoKN1bSTBHeMGmvOrDE4qFsijSoT1fF4R4HBBZmGqzYN1S7FpXtoxN7jFhfgKdEe9p1TbeFkr38PVUNAizAzZv5aJDWDWHkEw5GLNcabMpyhvo9KhTcQUpoJjPAJ+Wr421s/vjYPMnCPeM4NvrlhbCAIWcN0bc5slfqkNrLGZYODc7yKV8DNzKgvtTxLljhngzxy42j9SPguRvIAl9KbIizvoefDLm/2Ex2eNdf5rRpj9dt9CeX6rtZtJE/dkomKo/o2qnX+45TE03ZpuM2LLfiVMW8STvXsYGdvtWdhrVr5Cq/mz+bRUVxMdcuXtHoCH0gCQ13HK+TKAFvNG7tpXjU/yehGrLNX6/7KNOTcybgT1pccYxhJAA89KKSKJyEGl3EUNhIFsRJnEgRPiGsnKAUC5NM3DKEwR4OQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 13:57, Muhammad Usama Anjum wrote:
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
> ---
> Changes since v3:
> - Move __free_contig_range() to more generic __free_contig_range_common()
>   which will used to free frozen pages as well
> - Simplify the loop in __free_contig_range_common()
> - Rewrite the comment
> 
> Changes since v2:
> - Handle different possible section boundries in __free_contig_range()
> - Drop the TODO
> - Remove return value from __free_contig_range()
> - Remove non-functional change from __free_pages_ok()
> 
> Changes since v1:
> - Rebase on mm-new
> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>   fpi_flags are already being passed.
> - Add todo (Zi Yan)
> - Rerun benchmarks
> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
> - Rework order calculation in free_prepared_contig_range() and use
>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>   be up to internal __free_frozen_pages() how it frees them
> ---
>  include/linux/gfp.h |   2 +
>  mm/page_alloc.c     | 103 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 103 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index f82d74a77cad8..7c1f9da7c8e56 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>  #endif
>  
> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages);
> +
>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>  
>  #endif /* __LINUX_GFP_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 75ee81445640b..18a96b51aa0be 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>  /* Free the page without taking locks. Rely on trylock only. */
>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>  
> +/* free_pages_prepare() has already been called for page(s) being freed. */
> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
> +
>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>  static DEFINE_MUTEX(pcp_batch_high_lock);
>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
> @@ -1310,6 +1313,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  	bool compound = PageCompound(page);
>  	struct folio *folio = page_folio(page);
>  
> +	if (fpi_flags & FPI_PREPARED)
> +		return true;
> +
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  
>  	trace_mm_page_free(page, order);
> @@ -6784,6 +6790,100 @@ void __init page_alloc_sysctl_init(void)
>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>  }
>  
> +static void free_prepared_contig_range(struct page *page,
> +				       unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned int order;
> +		unsigned long pfn;
> +
> +		pfn = page_to_pfn(page);
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
> +				       bool is_frozen)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	struct page *start = NULL;
> +	unsigned long start_sec;
> +	bool can_free = true;
> +	unsigned long i;
> +
> +	/*
> +	 * Contiguous PFNs might not have a contiguous "struct pages" in some
> +	 * kernel config. Therefore, check memdesc_section(), and stop batching
> +	 * once it changes, see num_pages_contiguous().

num_pages_contiguous() starts with an array of struct page pointers,
presumably all valid, and determines if they are from the same section.

> +	 */
> +	for (i = 0; i < nr_pages; i++, page++) {

Here we do page++ and then trust it to be a valid struct page pointer and
use that to check if it's valid. But if struct pages are discontigous, we
might crash on the first dereference? The section checks below won't help in
this case AFAICS.

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
> +				free_prepared_contig_range(start, page - start);
> +				start = NULL;
> +			}
> +			continue;
> +		}
> +
> +		if (start && memdesc_section(page->flags) != start_sec) {
> +			free_prepared_contig_range(start, page - start);
> +			start = page;
> +			start_sec = memdesc_section(page->flags);
> +		} else if (!start) {
> +			start = page;
> +			start_sec = memdesc_section(page->flags);
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, page - start);
> +}
> +
> +/**
> + * __free_contig_range - Free contiguous range of order-0 pages.
> + * @pfn: Page frame number of the first page in the range.
> + * @nr_pages: Number of pages to free.
> + *
> + * For each order-0 struct page in the physically contiguous range, put a
> + * reference. Free any page who's reference count falls to zero. The
> + * implementation is functionally equivalent to, but significantly faster than
> + * calling __free_page() for each struct page in a loop.
> + *
> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
> + * order-0 with split_page() is an example of appropriate contiguous pages that
> + * can be freed with this API.
> + *
> + * Context: May be called in interrupt context or while holding a normal
> + * spinlock, but not in NMI context or while holding a raw spinlock.
> + */
> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	__free_contig_range_common(pfn, nr_pages, false);
> +}
> +EXPORT_SYMBOL(__free_contig_range);
> +
>  #ifdef CONFIG_CONTIG_ALLOC
>  /* Usage: See admin-guide/dynamic-debug-howto.rst */
>  static void alloc_contig_dump_pages(struct list_head *page_list)
> @@ -7330,8 +7430,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
>  		return;
>  
> -	for (; nr_pages--; pfn++)
> -		__free_page(pfn_to_page(pfn));
> +	__free_contig_range(pfn, nr_pages);
>  }
>  EXPORT_SYMBOL(free_contig_range);
>  #endif /* CONFIG_CONTIG_ALLOC */


