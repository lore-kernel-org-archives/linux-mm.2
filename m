Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5127F1061B00
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E21E6B008A; Mon, 30 Mar 2026 10:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9466B0095; Mon, 30 Mar 2026 10:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF646B0096; Mon, 30 Mar 2026 10:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7196B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:30:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02F721A0820
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:30:23 +0000 (UTC)
X-FDA: 84602964768.12.DB270C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37B80160008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:30:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/1qL4FW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881022; a=rsa-sha256;
	cv=none;
	b=HWL+F6l5U3/uEIULz/yltOCH9zHq7o/XwayM4DuJrtpGzdaHS9pSWlGcKPmIy1cYkDraTw
	juSfifpf60txZQ92963AyrWEIdESVuOeJ+2kpOLYQv0q5xJ56fFtTaJBIQuvJYOPAcEsCq
	F7kLDWxMzySNkrIYT1ZXrydXyozqerU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/1qL4FW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6oAJyghU+kcAD6Yrfejyl7I7RjgtT4Mm0hmtBsqENU=;
	b=UZwgXt0lfuWEnfsMnSDzluGEzk7EYNeraonBO7JqVecJUU7w6stAUxFSzBPL3yFOIm8ZyN
	mkljx3g1OBf1xi2cZ9qSe4s/VmEOYwjmQdc7obCdT7/o63NaeHRuUk3JHGPSUCKnKJT5ZL
	BmlL4nAcbso0SWmdWMDRLa5aoJE7gl4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 779DD600CB;
	Mon, 30 Mar 2026 14:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B67C4CEF7;
	Mon, 30 Mar 2026 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881021;
	bh=ZS3OUwwq2nYZzMP99yXm6JGeU6JJqt9zFp2EiybodHA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=V/1qL4FWFPEzripEDi0iH0l1RG9W3igBF+HtPx6qB12DGhLLVltF/+epnEB0XG4cN
	 A61LJ15IOYkyTTDd/hcTZNrcIndLgKJoQC1nQRzUR7t4bK6Q3eLdbKakpMX0EjXll5
	 va8pz8LDQmpt10KjudDGpKj4bVdc2j/+/9Js9RsH8TeO9OdXy0sEsRPIbMEbfOAWB9
	 VX9/BZqxXu2rS1k3fitd821mytXBQyW2rjwQpKf20EMS+mEPYuMGdClLFx9Wu7OgGI
	 J95rFWZsJuSukLCBxB8+WsIHQuPbzF8yQIJlZKNh8Ku9BfQkAKVp8qzWD+/avl/yn8
	 wYLTKOKFZYwdA==
Message-ID: <b8bac0eb-17cc-4e0d-b7f0-a8e7e0da0d67@kernel.org>
Date: Mon, 30 Mar 2026 16:30:15 +0200
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
X-Stat-Signature: tnwdyksb8qascp9icf77rioha1p5ftpj
X-Rspamd-Queue-Id: 37B80160008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774881022-402722
X-HE-Meta: U2FsdGVkX1+WF6GDaDAQvhbdseWrHg+hAfwiPO/Gwp0Qq1fI0K+GCih1XX3DfuW2YyjOmOCiOczs6Qi1b4qKrlds1FFKNfrnn6lqxxbikqg6ggjgcD5uJbNaXH3tP5MFue0zGaWnonKxL16QoD3SvPitJ8Z+b59lYxqOfzGbe9Bj6xQUK5bzltD1/rzin62PfkEuKsWIijGmUMaHuRq92Vy7tQsPEm3/SXA0Jh7yFN48nRJnO4KfsSbwrMg8N01v2746iaNxCY6Mbi1NJhxY/NU04BYzbLTaA7hDkPVFB354xD0EIbxynrjP/lnW1848NgrdKomvSerY1ODDHg/SN8LlMegBedkrn/7Hm/6fERdO9XQVwh+8b63Zjw2J2xKjBIq1jACQEU+nGLq6m1NC5uFZtoOVWL5yizAeeDE1fMNtQk6tJClQLBGcnN1WmZVuhUuh1If4KRTK6UUEhIp6s9o4uKIMu+ICOggWYkgdLeeno/bRql5h9z3HDm36eTPBCl+qV9wghRj8qBztQ1iIcnsNE43Q0FsRuomu3Ze2gJ3R6JN0+oF0zv9XkoHsr9hNesM7o2YCcAiy2rFQuCAPsAF9b9qEpxGgKi7UFVxeb2/HOvoHVtqH61Qc/KsxgGJmKWhjQi6XT8lMhXMHhbX/0zu61MwZUdqaJTEWxRjiwfGqlKpwC3igko+PyT/iI5V5ta55ktCrKLe4PGlaZDrI4QwLWlHM7YMOt3iGW/lKwOf6/5CqecKNPkVITO1b1bK14089HvimRjYm3DO8Zr+qIIKh3Ec37MNjzFXb4I1LpCdFmVSL7Rfyxmgcz0rxCngAcY12A6QO333oOaMmBMeoB839r4t8iiFITBNnzRQCCNIPUoYqtuNK1vxN/0jL2u/g3Ui+yz35iGmoXNCk7Nfw0+0Ehlc+sP7/B34PDJaKVRwQOQ3bVmj8sC+ZpXfqf8Mtvw7zI4oAUJrST52DXIR
 jQh+4Ux5
 gZ27pCg2h/EV8IudKGCIGPLmNOyC79yKLkoC35uNah7YIW7KRjRB+/bWj8vyM5ybTyC8jINWDmmzviq5q1HMCoCwzELaIcH12t/DkCKMzqehj584C++SbhiCfs/8BlZgVrUPiH1kM4ne4+uWtj6VqTXltPIE/Ea6Ia/zWigC13+PJw3KgmySS0x8pmaL8p9VxjF9xzGU5olRtzbnAheQFUcp3QZWwcOdA9kvnZnDChqzD/765zqbhrzd1r/vJGpQtbjN4/qvsIcgwVxOJQ0NajfsQq01j6OZwMx4+kOytUKPYGy7H5qrmEPLETEBf+Wy9cwy2GRU8di9/DXkVlAhskVDk2G9S1mGpvQxLyGdl2E+ECDZPtEE5pKpi8J2tugDxTkcN9o82ZsvY6kP5xxZKuhwFTVefSqYSKxzAguinpLKt+Muz7OwDN37crg==
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

Hm I noticed the function isn't static, but it should be, and this is a good
oportunity to make it so.

>  	bool compound = PageCompound(page);
>  	struct folio *folio = page_folio(page);
>  
> +	if (fpi_flags & FPI_PREPARED)
> +		return true;
> +
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  
>  	trace_mm_page_free(page, order);

...

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

I don't think the export is necessary for anything? Please drop.

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


