Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE78C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E46A6B007B; Tue,  4 Aug 2026 19:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4951B6B0088; Tue,  4 Aug 2026 19:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABBE6B0093; Tue,  4 Aug 2026 19:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC40C6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:41:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58F7B1202C9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:41:41 +0000 (UTC)
X-FDA: 85065211602.04.55D59EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C51C420006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:41:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwDcKFe5;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785886899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EUCMgHBanhRcpfI756++H/l3l8ZfGyKrWQyzXhKbkY=;
	b=iN2+rGnUQ9MjreR0u8kcEtgiFXLSgINgKeViP5F0yduXLyBM7Mtbs0WfxARattcDF4E6K2
	eWrURZ2yqzee8s5NyYF6FzuT0BErpyceh3PlSaLCxdMWxSkTSTz1wqhhxInpQWSlXDmH3l
	ybyt9mqJ5BZqmGsyfzhkPu75H7/3q7g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwDcKFe5;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785886899;
	b=ypBFhDmyIXgR4tX+udHGAx8srvnSt8BC/PFES8mgtxA27Bm3jzgCs97QHzn+eg8fAUPBOQ
	BwaBnDGa1KoMER6LUYqPae0mbd6Obdo06CL31sjNnHTgxAUmjb9eWIS+KWWQmhAgMiTUOD
	zfHBJb6qPBzXoRTAMUZpLG25RkaNex8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0216060052;
	Tue,  4 Aug 2026 23:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5E21F000E9;
	Tue,  4 Aug 2026 23:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785886898;
	bh=2EUCMgHBanhRcpfI756++H/l3l8ZfGyKrWQyzXhKbkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KwDcKFe58ufznJCPvjxMCvF7i7E2j8fGLj09mChK0reeO8Iml6E+/DNaZqGa6vz/P
	 G44jbZMvSbZ/dnNXUsZOAh43aDCsIYtd6Oocrmpues3F+LNyqAc0bFmlEMQZ9rBQYp
	 e/sxYQsDKPxjP7qQ5wNQwTrYskuM4vgR8HEoXV9SHYDLk9ryEqAkGU/IZm/E2Jysnr
	 67n1UxBR8fySD6NNGMTo57owUnIZXkz1ca4eVosHLT6blttfAcScUVKpM2XF4waWF0
	 TaspZrmX9L6crp1j1dk5UM2IKnq7sKEQa7lnyhH22vb8NW14yWYAXxAuKZqhEsVRbB
	 2WA37Q0SpG1ww==
Date: Tue, 4 Aug 2026 23:41:36 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
Message-ID: <anJylMTl6GeM8OHx@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
X-Stat-Signature: 44jeqboast3ncx4398yd9jow1fpyc8bd
X-Rspamd-Queue-Id: C51C420006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785886899-931240
X-HE-Meta: U2FsdGVkX19t8/IzYn2WlmF0zESAf7DBbdkMQ/MfrsXYl9t3PDuopqfjwLqjgNkKhct8Gh4jCUvgDtqh+fHbOE9omwQhVyGl/9HIU1tEj+oUFZ92gFonch+ylzPQkJD4UXlAQNnlQaasRJKermWev8kOvqIr+07dHV0f1uyDc+d5St82SLNhNw8VBVQTXMbTDTSC6OK1B5qRXTX9zUE7c91LlPwO1sZw22gc9Wp2LcY8N1qNkmYh1vPxlc3mgqaZ+nyuocUq8uF5rlII4PIjJKGkd5gMzFgt/V7nMtI+85JpHm5O3UQHE+QgypnIAWNIfyl2lDw6XL497hMLHxSn6lAZvlj8Od8WlXB4qlTdXuVeWdHGtl1vw81bBiXK2EROM+ehRYsTrTsURPfAXUqrXL9+eMxc9hp81eltU2Je2HLQvME7dPXl5ksllfsJElrPwqnSmpUthkE2WP+18gnJN5hM5F+miu/XQDHgr8cws25F5HkOE/eG68Y66DvQumpdBOI4gwsQGwxDJQGyV+pnM8Sn36nkUBNM8Vam6y4lRPQAQoN9Uu4mJ/Q1KcjySY3pht1gtqiUqmexcpfpEKCR1SzFqJ/1e0QDi+fvlQpRX/bijlpM5seAGAkJIO6QQvRhdvgomvCGQpK0hy83/kYN+w8BV148wU+m8uNFY+kdzoKjbi7JnzFBIYaCmnnP3HaxwFExMKB8QlP/kV/hP9ZBc5MlRKd4vQGGlV3N6WnjOQdML8rkus+JvM7oI9zPPKko5IArjz+KopYSdaUmY6vyFC316+2jJDcseXDY3GT6mG5UVKtgAIaZpK0auPitqlQpvOoaD8BU1vClbo7OqPwlQhjxuwYmbZuuSJjo68fz7JvXhrGe09+BChA0mWFkhi9Uj31omRH9Kcyyjd8GRjYsy26wd8miu0/i8una2Wm/NWS05iQGxPqgJwo8KLqwVm0XUFvPrJfg8rOP2eEo+rt
 bHN+O3hA
 SHwF938yM2pzyw1zFcu9tcbjHMlHmZN3z7cPoWlz11/zuR8+/wtxzehVBC3VUU8g+jw9ZM1tQtkcRBsYbLGGzHHSqZBSAgctPlIPAtO7FI8f9le59H30PNob+d8fdr7T4TAjohc34j/GIRh0lfJSdNtvRjSgK4udyRskrrmggsRfbKJFyi/WCg+5M7iqoPT8zJtJbR/a9lXz24T0jYELgynRNYanK2N/9K2PH3UI+fWOu2Aj+nxoPocbNq1mdORqW2CtRhHav25K1Tlf5lMmwnYIkZsCbmo5QmJIPyq9LQf3T/csw8928duAGcEjX8UdACDg6dkBuRH1PN/AlFUFcYHZ3lYq618/Z/uGtRlcbmTOV8GQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:54PM +0000, Brendan Jackman wrote:
> Currently FREETYPE_UNMAPPED allocs will always fail because, although the
> lists exist to hold them, there is no way to actually create an unmapped
> page block. This commit adds one, and also the logic to map it back
> again when that's needed.
> 
> Doing this at pageblock granularity ensures that the pageblock flags can
> be used to infer which freetype a page belongs to. It also provides nice
> batching of TLB flushes, and also avoids creating too much unnecessary
> TLB fragmentation in the physmap.
> 
> There are some functional requirements for flipping a block:
> 
>  - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.
> 
>  - Updating the pagetables might require allocating a pagetable to break
>    down a huge page. This would deadlock if the zone lock was held.

We also need to zero unmapped/sensitive pages before mapping them again,
but seems like the current approach is to differ this to the caller,
which makes sense. The only annoying part is that
want_init_on_{free/alloc}() now silently skip the zeroing for those
pages.

We should document somewhere that the users of ALLOC_UNMAPPED are
responsible for zeroing memory before freeing it?

The current users currently always zero the pages on allocation as well,
I am not sure if this should also be a general requirement, or perhaps
only if want_init_on_alloc() is set?

> 
> This makes allocations that need to change sensitivity _somewhat_

s/sensitivity/direct mapping status (or sth)?

> similar to those that need to fallback to a different migratetype. But,
> the locking requirements mean that this can't just be squashed into the
> existing "fallback" allocator logic, instead a new allocator path just
> for this purpose is needed.
> 
> The new path is assumed to be much cheaper than the really heavyweight
> stuff like compaction and reclaim. But at present it is treated as less
> desirable than the mobility-related "fallback" and "stealing" logic.
> This might turn out to need revision (in particular, maybe it's a
> problem that __rmqueue_steal(), which causes fragmentation, happens
> before __rmqueue_direct_map()), but that should be treated as a subsequent
> optimisation project.
> 
> Adding alloc_flags to gfp_freetype() requires moving it to
> mm/page_alloc.h so it can refer to ALLOC_UNMAPPED. It was already only
> used in internal mm code.
> 
> Now that unmapped pageblocks actually exist, exclude them from
> migration. Migrating unmapped pages via the mermap should be possible
> but that's something to be added later when needed.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
[..]
> @@ -3400,6 +3426,127 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
>  #endif
>  }
>  
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +/* Try to allocate a page by mapping/unmapping a block from the direct map. */
> +static inline struct page *
> +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
> +		     unsigned int alloc_flags, freetype_t freetype)
> +{
> +	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
> +	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
> +						  ft_flags_other);
> +	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
> +	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
> +	unsigned long irq_flags;
> +	int nr_pageblocks, nr_freed;
> +	struct page *page;
> +	int alloc_order;
> +	int err;
> +
> +	if (freetype_idx(ft_other) < 0)
> +		return NULL;
> +
> +	/*
> +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
> +	 * safe if the caller holds a lock (in case the other CPUs need that
> +	 * lock to handle the shootdown IPI).
> +	 */
> +	if (alloc_flags & ALLOC_NOBLOCK)
> +		return NULL;

Should we only check this if !want_mapped? IIUC we only need a TLB
shootdown when unmapping.

> +
> +	if (!can_set_direct_map() || alloc_flags & ALLOC_NOLOCK)
> +		return NULL;
> +
> +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
> +
> +	/*
> +	 * Need to [un]map a whole pageblock (otherwise it might require
> +	 * allocating pagetables). First allocate it.
> +	 */
> +	alloc_order = max(request_order, pageblock_order);
> +	nr_pageblocks = 1 << (alloc_order - pageblock_order);
> +	spin_lock_irqsave(&zone->lock, irq_flags);
> +	/* First try a block that already has the right migratetype. */
> +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);

IIUC, this is called after __rmqueue() will have already failed in the
caller with request_order (a potentially smaller order), so why are we
trying this again here?

> +	if (!page) {
> +		/* Fallback to changing a block's migratetype. */
> +		rmqm = RMQUEUE_CLAIM;
> +		page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> +	}
> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> +	if (!page)
> +		return NULL;
> +
> +	/*
> +	 * Now that IRQs are on it's safe to do a TLB shootdown, and now that we
> +	 * released the zone lock it's possible to allocate a pagetable if
> +	 * needed to split up a huge page.
> +	 *
> +	 * Note that modifying the direct map may need to allocate pagetables.
> +	 * What about unbounded recursion? Here are the assumptions that make it
> +	 * safe:
> +	 *
> +	 * - The direct map starts out fully mapped at boot. (This is not really
> +	 *   an "assumption" as it's in direct control of page_alloc.c).
> +	 *
> +	 * - Once pages in the direct map are broken down, they are not
> +	 *   re-aggregated into larger pages again.
> +	 *
> +	 * - Pagetables are never allocated with ALLOC_UNMAPPED.
> +	 *
> +	 * Under these assumptions, a pagetable might need to be allocated while
> +	 * _unmapping_ stuff from the direct map during an ALLOC_UNMAPPED
> +	 * allocation. But, the allocation of that pagetable never requires
> +	 * allocating a further pagetable.
> +	 */
> +	err = set_direct_map_valid_noflush(page,
> +				nr_pageblocks << pageblock_order, want_mapped);
> +	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
> +		set_direct_map_valid_noflush(page,
> +				nr_pageblocks << pageblock_order, !want_mapped);
> +		spin_lock_irqsave(&zone->lock, irq_flags);
> +		/* Important: free using _old_ freetype. */
> +		__free_one_page(page, page_to_pfn(page), zone,
> +				alloc_order, ft_other, FPI_SKIP_REPORT_NOTIFY);
> +		spin_unlock_irqrestore(&zone->lock, irq_flags);
> +		return NULL;
> +	}
> +
> +	if (want_mapped) {
> +		/* Exposing formerly-protected data; scrub it. */
> +		clear_highpages_kasan_tagged(page, nr_pageblocks << pageblock_order);

Shouldn't all unmapped memory be zeroed on free? If we solidify this
assumption we can probably drop this here (and maybe replace it with an
assertion)?

> +	} else {
> +		unsigned long start = (unsigned long)page_address(page);
> +		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));
> +
> +		flush_tlb_kernel_range(start, end);
> +	}
> +
> +	for (int i = 0; i < nr_pageblocks; i++) {
> +		struct page *block_page = page + (pageblock_nr_pages * i);
> +
> +		set_pageblock_freetype_flags(block_page, freetype_flags(freetype));
> +	}
> +
> +	if (request_order >= alloc_order)
> +		return page;
> +
> +	/* Free any remaining pages in the block. */
> +	spin_lock_irqsave(&zone->lock, irq_flags);
> +	nr_freed = expand(zone, page, request_order, alloc_order, freetype);
> +	account_freepages(zone, nr_freed, free_to_migratetype(freetype));
> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> +
> +	return page;
> +}
> +#else /* CONFIG_PAGE_ALLOC_UNMAPPED */
> +static inline struct page *__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
> +				unsigned int alloc_flags, freetype_t freetype)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_PAGE_ALLOC_UNMAPPED */
> +
>  static __always_inline
>  struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			   unsigned int order, unsigned int alloc_flags,
> @@ -3433,13 +3580,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 */
>  			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
>  				page = __rmqueue_smallest(zone, order, ft_high);
> -
> -			if (!page) {
> -				spin_unlock_irqrestore(&zone->lock, flags);
> -				return NULL;
> -			}
>  		}
>  		spin_unlock_irqrestore(&zone->lock, flags);
> +
> +		/* Try changing direct map, now we've released the zone lock */
> +		if (!page)
> +			page = __rmqueue_direct_map(zone, order, alloc_flags, freetype);
> +		if (!page)
> +			return NULL;
> +
>  	} while (check_new_pages(page, order));
>  
>  	/*
> @@ -3660,6 +3809,8 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
>  		return;
>  
>  	ft_high = freetype_with_migrate(ft, MIGRATE_HIGHATOMIC);
> +	if (freetype_idx(ft_high) < 0)
> +		return;

Does this belong in "mm/page_alloc: add support for freetypes with no
freelist"?

>  	if (order < pageblock_order) {
>  		if (move_freepages_block(zone, page, ft, ft_high) == -1)
>  			return;
> @@ -3975,13 +4126,15 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
>  }
>  
>  /* Must be called after current_gfp_context() which can change gfp_mask */
> -static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
> +static inline unsigned int alloc_flags_cma(gfp_t gfp_mask, unsigned int alloc_flags)
>  {
>  #ifdef CONFIG_CMA
> -	if (free_to_migratetype(gfp_freetype(gfp_mask)) == MIGRATE_MOVABLE)
> -		return ALLOC_CMA;
> +	if (free_to_migratetype(gfp_freetype(gfp_mask, alloc_flags)) == MIGRATE_MOVABLE)
> +		alloc_flags |= ALLOC_CMA;
>  #endif
> -	return ALLOC_DEFAULT;
> +	alloc_flags |= ALLOC_DEFAULT;
> +
> +	return alloc_flags;
>  }
>  
>  /*
> @@ -4770,7 +4923,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
>  	} else if (unlikely(rt_or_dl_task(current)) && in_task())
>  		alloc_flags |= ALLOC_MIN_RESERVE;
>  
> -	alloc_flags |= alloc_flags_cma(gfp_mask);
> +	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
>  
>  	if (defrag_mode)
>  		alloc_flags |= ALLOC_NOFRAGMENT;
> @@ -5085,7 +5238,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  
>  	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
>  	if (reserve_flags)
> -		alloc_flags = alloc_flags_cma(gfp_mask) | reserve_flags |
> +		alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags) | reserve_flags |
>  				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);

Should we pass in ac->alloc_flags here to maintain equivalent
functionality, maybe this:

		alloc_flags = alloc_flags_cma(gfp_mask, ac->alloc_flags) |
				reserve_flags | (alloc_flags & ALLOC_KSWAPD);

>  
>  	/*
> @@ -5307,7 +5460,11 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	ac->highest_zoneidx = gfp_zone(gfp_mask);
>  	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
>  	ac->nodemask = nodemask;
> -	ac->freetype = gfp_freetype(gfp_mask);
> +	ac->freetype = gfp_freetype(gfp_mask, *alloc_flags);
> +
> +	/* Not implemented yet. */
> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)

Nit: Add more parentheses for readability?
	
	if ((freetype_flags(ac->freetype) & FREETYPE_UNMAPPED) && (gfp_mask & __GFP_ZERO))

> +		return false;
>  
>  	if (cpusets_enabled()) {
>  		*alloc_gfp |= __GFP_HARDWALL;

