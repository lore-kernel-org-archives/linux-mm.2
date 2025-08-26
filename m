Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9840CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50958E00C5; Tue, 26 Aug 2025 06:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28A68E00A8; Tue, 26 Aug 2025 06:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E458E00C5; Tue, 26 Aug 2025 06:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C05D68E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:46:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3FDF21DE3BC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:46:14 +0000 (UTC)
X-FDA: 83818579068.24.14FFF6A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E53A40008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:46:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756205172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9psFt/Yy9/q5Gaj5Xh49YriPzaysEXZb7xyINMu8P/Y=;
	b=352743H697g9a3SWujCn6IcA/L9FNQxIlYpg1joODrO8xUUAcMr9/hTrQ07Bgbbu8p1Kwp
	aE8PP99JxT9GR1N4GpyG0efqi7C/0YR6UMp1iU4aWrUgIAu/zft324p5ZED26cH45D5tOH
	DVlEukGhLmpnf7pdzOKcAKM/LiHj0lY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756205172; a=rsa-sha256;
	cv=none;
	b=p+dlwOedlzHRGnNTCYCcCl01k6Mu0sjIv2LBII+fY5DQXBuNfz2mmIuz39TBpOzSxCqPIF
	IKp837lEtlnLX6feo5lsOSeIzJv/H6fKbIRi/89s6U7lyXw2M+Z2jlpbKUZdSUHbWQuLxH
	66Q/ti+xR93g8cg46UUXXIcOOr0uUQc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AD2A1A00;
	Tue, 26 Aug 2025 03:46:01 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93FC13F694;
	Tue, 26 Aug 2025 03:46:01 -0700 (PDT)
Date: Tue, 26 Aug 2025 11:45:58 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page
 ranges
Message-ID: <aK2QZnzS1ErHK5tP@raptor>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-22-david@redhat.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E53A40008
X-Stat-Signature: w71bc1u17uscdwuzn6ffe6tezh19msnd
X-Rspam-User: 
X-HE-Tag: 1756205170-681173
X-HE-Meta: U2FsdGVkX19odxc/nB0ZFWeOmxUT9Yk7LzCU226vqWea097EaW48zc3iFLC1k2FNcBEMJHCTPdcKsTqoCK0NyGReufaY9V8HifmH+Qh7iVEa3u6Yfffu4EbjddtuipwRPp9paER3OTvTLw2iNoyarj7luVfhuGjk9ZcTQbE7FrzcCCFC93nFJgAHphiEGvAft5lTzDbS66B+b/79YcIn0lF9B2AYp09imink3Ru+i1cmJg4J/IkBd4R9GvoFKbJ2ds8F3h6I0G3hRoEfoL70vTM2IVy60yJp65CkzM5qhiiHi+SdFLjOba73pSDmKySlqDPfRSSG5a3k8S1R4C+HnOH3w4LfnE8+CZmXjh6d2MtWDnMsXasDN0AcyB8bgzH1JZZo0J7mUTYj7W+izuH9fnNQQVt/5udfM7hWV6MmkBdtuZ4EIC2pZERToPZ7OK+fgC3+gF53YBvgh1tvnRBMap4OL9u0hd1EaHea5MRm/dJEb4Jnlmjg6o1osZTnkMIx12NWiQHxb6ZzSPY89PS5mKSWsVUCHlxym6Ms56BLfXczm0zkCsXvwQoSvskdXFBqyMgYJTC3f6HW49vmuQneGmk1QaaMcjzDUxuhImkeXOjCLZnJ+BWOAGEjzBCi9dwi0q5c/IFHwhe7B03h9nSKG1KfcCJ1W7if/U84iwkrCSFiF8kF6GlWPvpEpK81VOTcRCBoIZddhAPB1Ab1UlWwI7vdJdM7jlwCI67zNtMbagULgW2DltwAwAgVcESM9DaSqHBuk19e2a+UPpPss2Wf3/LGAdebWGk96HtVBc1F+T2tXrW6rmp60nDZhwLqqJ/8mrnfekhSeT2zRcto9eLGtWPx0g7sGWtWFWCUDyd6DsKOW8btAgzABARpcnR6C6kjWzO1Z186+tQz00EWRkMEgZVOQB8K4MyAc1jugR0q5Oe32sE0qW3GpvOnInT+Fa8mlk0xw4/kIxAbN60IwuL
 8mG5x8Ko
 fpTEtLa9FLWYYWJ8IzNDc2hm5xKv4IubG5a7xLHTebM5CKmF50IDef4vLBGlkI18kTdG/UHxIJ2jYyDoOQ80TPqOHVI6ouXMrMss0V27o16opmZWxNGU8uoQWh4mQmKiTZC4VMvDvz8NS7RiPfK8dp0FdZjlg5t0GKvjM1oa1EAAUCmB/bvoavL0Fw/97l44QudMmdp2KD2WTX4tY7yYBqla1bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, Aug 21, 2025 at 10:06:47PM +0200, David Hildenbrand wrote:
> Let's disallow handing out PFN ranges with non-contiguous pages, so we
> can remove the nth-page usage in __cma_alloc(), and so any callers don't
> have to worry about that either when wanting to blindly iterate pages.
> 
> This is really only a problem in configs with SPARSEMEM but without
> SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
> cases.
> 
> Will this cause harm? Probably not, because it's mostly 32bit that does
> not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
> look into allocating the memmap for the memory sections spanned by a
> single CMA region in one go from memblock.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h |  6 ++++++
>  mm/cma.c           | 36 +++++++++++++++++++++++-------------
>  mm/util.c          | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ef360b72cb05c..f59ad1f9fc792 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve_kbytes;
>  extern unsigned long sysctl_admin_reserve_kbytes;
>  
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
>  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>  #else
>  #define nth_page(page,n) ((page) + (n))
> +static inline bool page_range_contiguous(const struct page *page,
> +		unsigned long nr_pages)
> +{
> +	return true;
> +}
>  #endif
>  
>  /* to align the pointer to the (next) page boundary */
> diff --git a/mm/cma.c b/mm/cma.c
> index 2ffa4befb99ab..1119fa2830008 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  				unsigned long count, unsigned int align,
>  				struct page **pagep, gfp_t gfp)
>  {
> -	unsigned long mask, offset;
> -	unsigned long pfn = -1;
> -	unsigned long start = 0;
>  	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
> +	unsigned long start, pfn, mask, offset;
>  	int ret = -EBUSY;
>  	struct page *page = NULL;
>  
> @@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  	if (bitmap_count > bitmap_maxno)
>  		goto out;
>  
> -	for (;;) {
> +	for (start = 0; ; start = bitmap_no + mask + 1) {
>  		spin_lock_irq(&cma->lock);
>  		/*
>  		 * If the request is larger than the available number
> @@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  			spin_unlock_irq(&cma->lock);
>  			break;
>  		}
> +
> +		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
> +		page = pfn_to_page(pfn);
> +
> +		/*
> +		 * Do not hand out page ranges that are not contiguous, so
> +		 * callers can just iterate the pages without having to worry
> +		 * about these corner cases.
> +		 */
> +		if (!page_range_contiguous(page, count)) {
> +			spin_unlock_irq(&cma->lock);
> +			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
> +					    __func__, cma->name, pfn, pfn + count - 1);
> +			continue;
> +		}
> +
>  		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
>  		cma->available_count -= count;
>  		/*
> @@ -821,29 +835,25 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  		 */
>  		spin_unlock_irq(&cma->lock);
>  
> -		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
>  		mutex_lock(&cma->alloc_mutex);
>  		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
>  		mutex_unlock(&cma->alloc_mutex);
> -		if (ret == 0) {
> -			page = pfn_to_page(pfn);
> +		if (!ret)
>  			break;
> -		}
>  
>  		cma_clear_bitmap(cma, cmr, pfn, count);
>  		if (ret != -EBUSY)
>  			break;
>  
>  		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
> -			 __func__, pfn, pfn_to_page(pfn));
> +			 __func__, pfn, page);
>  
>  		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),

Nitpick: I think you already have the page here.

>  					   count, align);
> -		/* try again with a bit different memory target */
> -		start = bitmap_no + mask + 1;
>  	}
>  out:
> -	*pagep = page;
> +	if (!ret)
> +		*pagep = page;
>  	return ret;
>  }
>  
> @@ -882,7 +892,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>  	 */
>  	if (page) {
>  		for (i = 0; i < count; i++)
> -			page_kasan_tag_reset(nth_page(page, i));
> +			page_kasan_tag_reset(page + i);

Had a look at it, not very familiar with CMA, but the changes look equivalent to
what was before. Not sure that's worth a Reviewed-by tag, but here it in case
you want to add it:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Just so I can better understand the problem being fixed, I guess you can have
two consecutive pfns with non-consecutive associated struct page if you have two
adjacent memory sections spanning the same physical memory region, is that
correct?

Thanks,
Alex

>  	}
>  
>  	if (ret && !(gfp & __GFP_NOWARN)) {
> diff --git a/mm/util.c b/mm/util.c
> index d235b74f7aff7..0bf349b19b652 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1280,4 +1280,37 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
>  {
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
>  }
> +
> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/**
> + * page_range_contiguous - test whether the page range is contiguous
> + * @page: the start of the page range.
> + * @nr_pages: the number of pages in the range.
> + *
> + * Test whether the page range is contiguous, such that they can be iterated
> + * naively, corresponding to iterating a contiguous PFN range.
> + *
> + * This function should primarily only be used for debug checks, or when
> + * working with page ranges that are not naturally contiguous (e.g., pages
> + * within a folio are).
> + *
> + * Returns true if contiguous, otherwise false.
> + */
> +bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
> +{
> +	const unsigned long start_pfn = page_to_pfn(page);
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +	unsigned long pfn;
> +
> +	/*
> +	 * The memmap is allocated per memory section. We need to check
> +	 * each involved memory section once.
> +	 */
> +	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
> +	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
> +		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
> +			return false;
> +	return true;
> +}
> +#endif
>  #endif /* CONFIG_MMU */
> -- 
> 2.50.1
> 
> 

