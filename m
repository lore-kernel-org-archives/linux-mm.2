Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1610CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6F76B00DD; Wed, 13 May 2026 11:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE5E6B00DE; Wed, 13 May 2026 11:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4FD6B00E0; Wed, 13 May 2026 11:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACAC6B00DD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:44:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF601C0656
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:44:03 +0000 (UTC)
X-FDA: 84762817566.16.03D67BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0993718000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:44:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h9+6z/QX";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778687042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0cOfOwO80Z4xvOTroiIfIYI7FCDcYhsjHNAmCY7ojk=;
	b=060JBVZXqLTHwwlA5reIMwWMi7v6NGwumxrdMjfBMlSMSDHmOpQLcSplJMF4hqBLBwCWAS
	dCO/2HYrZyxrp5XCi/TLvcT4HiHp9RiJDaQipZ+BYkR64mBXwmdozDhOXPPMGbnc3wT+mC
	MmtbBpMnUtDDZcII0n8qiCW3pN3GVKw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h9+6z/QX";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778687042; a=rsa-sha256;
	cv=none;
	b=2Pnnao0LLEncPYqqUDKAzky2QzWYe+L3kCfdJcneEnSVjYFCdqQdJOg6rfpOySgwfg4uzE
	f9BmeNxnkiTJiwZUSALvvWztPyzDojmZYZLSb5oUk1rhR0SJzwVX0CwiMIx346nGqd2she
	9xhiiTHOakIraGT4W9FcIBOb8BiZq+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02238401D8;
	Wed, 13 May 2026 15:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE604C19425;
	Wed, 13 May 2026 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778687040;
	bh=QN3lkpWX6/RaYjZoXh5Y8X/VI8sqvCkTxCQQVxzTQ88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h9+6z/QXmvdkS7AIqu0WCQcRRM0QN7p2yKk+LlFb/wgisYuz7QgCx0EWkXYT1eoFG
	 NExuRCo17IiKDXlTT4LATSwPAKNHF+WXUOMrdm4oWew278uemlzTnBBZFN0xgJ4/hF
	 i25q5PuISjab56cfnMCrUT9nYJHLB0684ghfzuzRnB9yKK0tkzrm44JrseAFKrAeJa
	 l13wu5eW/ZzRYQ4ougprDm8q0NJZsMaSH28kP86/6yeCkAcgeoiu+hi2eTs3zV+REG
	 5pAMOt1OtmYy5zXBGwvHIbUFcUNjnpagpEJx1IoXPLYhoiiUWKQv9nX/2FvCbbL8Jx
	 Iv9Bo4E0TLmIA==
Message-ID: <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
Date: Wed, 13 May 2026 17:43:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED
 allocations
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0993718000C
X-Rspam-User: 
X-Stat-Signature: wg57yte9uha54g6mof1trwdgfzgz9tss
X-HE-Tag: 1778687041-992287
X-HE-Meta: U2FsdGVkX19XSZ7gaGBmUzBXDw75zo/Tlsu+HAc3rmngybaxDcxbtjMMRvmI+a2zryqR/t63Y7P5OWHZjpszJO5g1rLLJMsS3yG8C64W27t8Gb7rOakjcbnBoMVl9Mnu257hp8SnDR9GzsXzj4S4RdHHyAzemjdHtPJiFLsXlnbrqWumC7ImYx5RmFFIAFM3Jjw073KMwYbD5akojhIhoVe+f5ANjZIZTrdexn3mqf/UCayJ5DGZ+FM0p/i5FYSFTGJEFo15aDS2SN+p+eS5/3U0I+86Myx21AvWG+xPqEsFxzsNtTWqyLog1yNV+QQZsJZ1Mjn6EeJJTI5Sh/Xz87m47XwjXlvGEzkry1jFmbuYgOzVvqWx1+byNF3FtdqFX6mHeAqeinNRAJ2BHYCcWd07+skhr+JerHu7b8HI+iM9MIDYdSEghRWuGp0bBzeFB4bILDtBZdC46+aX9zmpElsAfdt4dOXM3y1MiS2eEO4N/Sc4yWCqCy80jI/Hegew5zILf4mMKt9N2uERAZJR7xfUOMfoDHRm5wVRQonoOdR8tBaPoRWiev/xbkWY9GsrPRZgHfqds1o3Gi8aolef1ibvn4IbEgVcjFB8emEo8pEmz8Lq5HfbP4xIX+N7kx8MaJzh3YuoDmMlRR+iGNxRuS9TJRidf9OUtghH4E7fRIVhjAfNI2muwZ/JY+c3Kk2E5ehATVGrxiP21hOQl0WCHAPx9j5p3O4rSjM5tcGPCq+SEkPLSnCLkgLxFixfcLMmlyuvU1plj5mWhyYHCzOjsU73rLgM38/6zjxKwoo60RPHB50dor71P+qeP7M8rV+Dpd/iXrbaps3P9GBCc5JoN3RPaftrvRIB5pfXq5gbb1w4oWi/5YhxFcSVdmK4h6EMj1FlYRGKp68LE55QYNij2+le+tPxBg+W36kQ3/E0YpHB0NUT0la1igjPex5wtKq4UHhkN10aFlXEv6GdNYh
 1kUCBnia
 qMF3d8mK1UdlMmUbytnvZTQL9fVoTsh7bhwDGyJQpoae0/HfKZWbZFnhFv3p9Cf1drSSmFbTW3z9ZV1sDNT9Q64eXW5fneez84MUxTX3pqzHOypdTWZK/iRVPMI1Z78TSZRoH9PVJqXCb/6/jr7qMPY8tPYyldap5x1nABPE1tGOXpJjKhacKq44A3DncKqD/P7KUHpU35RtMxmVLKOzDRrJgh2nZw0C58u6HSV5P9V/D8z4EMmAcjUkWz/GbObV+Y1IEUFx3F/+IPPoJDHjrWOWafAU4kKaTHl1dVV5UQ5rY25jCDM2dlDOlGqwr8uFCXyiQFkHejOQGOsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> Currently __GFP_UNMAPPED allocs will always fail because, although the
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
>  - Because the main usecase of this feature is to protect against CPU
>    exploits, when a block is mapped it needs to be zeroed to ensure no
>    residual data is available to attackers. Zeroing a block with a
>    spinlock held seems undesirable.

Did I overlook something or this patch doesn't do this whole block zeroing?
Or is it handled by set_direct_map_valid_noflush itself?

>  - Updating the pagetables might require allocating a pagetable to break
>    down a huge page. This would deadlock if the zone lock was held.
> 
> This makes allocations that need to change sensitivity _somewhat_
> similar to those that need to fallback to a different migratetype. But,
> the locking requirements mean that this can't just be squashed into the
> existing "fallback" allocator logic, instead a new allocator path just
> for this purpose is needed.
> 
> The new path is assumed to be much cheaper than the really heavyweight
> stuff like compaction and reclaim. But at present it is treated as less

Uhh, speaking of compaction and reclaim... we rely on finding a whole free
pageblock in order to flip it. If that doesn't exist, the whole
get_page_from_freelist() will fail, and we might enter the
reclaim/compaction cycle in __allow_pages_slowpath(). But since we might
ultimately want an order-0 allocation, there won't be any compaction
attempted, because that code won't know we failed to flip a pageblock. And
the watermarks might look good and prevent reclaim as well I think? We
should somehow indicate this, and handle accordingly. Might not be trivial.
Or maybe reuse pageblock isolation code to do the migrations directly in
__rmqueue_direct_map?

> desirable than the mobility-related "fallback" and "stealing" logic.
> This might turn out to need revision (in particular, maybe it's a
> problem that __rmqueue_steal(), which causes fragmentation, happens
> before __rmqueue_direct_map()), but that should be treated as a subsequent
> optimisation project.
> 
> This currently forbids __GFP_ZERO, this is just to keep the patch from
> getting too large, the next patch will remove this restriction.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/gfp.h |  11 +++-
>  mm/Kconfig          |   4 +-
>  mm/page_alloc.c     | 171 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 170 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 34a38c420e84a..2d8279c6300d3 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -24,6 +24,7 @@ struct mempolicy;
>  static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
>  {
>  	int migratetype;
> +	unsigned int ft_flags = 0;
>  
>  	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
>  	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
> @@ -40,7 +41,15 @@ static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
>  			>> GFP_MOVABLE_SHIFT;
>  	}
>  
> -	return migrate_to_freetype(migratetype, 0);
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +	if (gfp_flags & __GFP_UNMAPPED) {
> +		if (WARN_ON_ONCE(migratetype != MIGRATE_UNMOVABLE))
> +			migratetype = MIGRATE_UNMOVABLE;
> +		ft_flags |= FREETYPE_UNMAPPED;
> +	}
> +#endif
> +
> +	return migrate_to_freetype(migratetype, ft_flags);
>  }
>  #undef GFP_MOVABLE_MASK
>  #undef GFP_MOVABLE_SHIFT
> diff --git a/mm/Kconfig b/mm/Kconfig
> index b915af74d33cc..e4cb52149acad 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1505,8 +1505,8 @@ config MERMAP_KUNIT_TEST
>  
>  	  If unsure, say N.
>  
> -endmenu
> -
>  config PAGE_ALLOC_UNMAPPED
>  	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
>  	default COMPILE_TEST
> +
> +endmenu
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 83d06a6db6433..710ee9f46d467 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -34,6 +34,7 @@
>  #include <linux/folio_batch.h>
>  #include <linux/memory_hotplug.h>
>  #include <linux/nodemask.h>
> +#include <linux/set_memory.h>
>  #include <linux/vmstat.h>
>  #include <linux/fault-inject.h>
>  #include <linux/compaction.h>
> @@ -1002,6 +1003,26 @@ static void change_pageblock_range(struct page *pageblock_page,
>  	}
>  }
>  
> +/*
> + * Can pages of these two freetypes be combined into a single higher-order free
> + * page?
> + */
> +static inline bool can_merge_freetypes(freetype_t a, freetype_t b)
> +{
> +	if (freetypes_equal(a, b))
> +		return true;
> +
> +	if (!migratetype_is_mergeable(free_to_migratetype(a)) ||
> +	    !migratetype_is_mergeable(free_to_migratetype(b)))
> +		return false;
> +
> +	/*
> +	 * Mustn't "just" merge pages with different freetype flags, changing
> +	 * those requires updating pagetables.
> +	 */
> +	return freetype_flags(a) == freetype_flags(b);
> +}
> +
>  /*
>   * Freeing function for a buddy system allocator.
>   *
> @@ -1070,9 +1091,7 @@ static inline void __free_one_page(struct page *page,
>  			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
>  			buddy_mt = free_to_migratetype(buddy_ft);
>  
> -			if (migratetype != buddy_mt &&
> -			    (!migratetype_is_mergeable(migratetype) ||
> -			     !migratetype_is_mergeable(buddy_mt)))
> +			if (!can_merge_freetypes(freetype, buddy_ft))
>  				goto done_merging;
>  		}
>  
> @@ -1089,7 +1108,9 @@ static inline void __free_one_page(struct page *page,
>  			/*
>  			 * Match buddy type. This ensures that an
>  			 * expand() down the line puts the sub-blocks
> -			 * on the right freelists.
> +			 * on the right freelists. Freetype flags are
> +			 * already set correctly because of
> +			 * can_merge_freetypes().
>  			 */
>  			change_pageblock_range(buddy, order, migratetype);
>  		}
> @@ -1982,6 +2003,9 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>  	struct free_area *area;
>  	struct page *page;
>  
> +	if (freetype_idx(freetype) < 0)
> +		return NULL;
> +
>  	/* Find a page of the appropriate size in the preferred list */
>  	for (current_order = order; current_order < NR_PAGE_ORDERS; ++current_order) {
>  		enum migratetype migratetype = free_to_migratetype(freetype);
> @@ -3324,6 +3348,119 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
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

Why not RMQUEUE_CLAIM? We want to change the migratetype to ours as well,
not just the unmapped flag?

> +	unsigned long irq_flags;
> +	int nr_pageblocks;
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
> +
> +	if (!can_set_direct_map())
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
> +	zone_lock_irqsave(zone, irq_flags);
> +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> +	zone_unlock_irqrestore(zone, irq_flags);
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
> +	 *   an assumption" as its in direct control of page_alloc.c).
> +	 *
> +	 * - Once pages in the direct map are broken down, they are not
> +	 *   re-aggregated into larger pages again.
> +	 *
> +	 * - Pagetables are never allocated with __GFP_UNMAPPED.
> +	 *
> +	 * Under these assumptions, a pagetable might need to be allocated while
> +	 * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
> +	 * allocation. But, the allocation of that pagetable never requires
> +	 * allocating a further pagetable.
> +	 */
> +	err = set_direct_map_valid_noflush(page,
> +				nr_pageblocks << pageblock_order, want_mapped);
> +	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
> +		zone_lock_irqsave(zone, irq_flags);
> +		__free_one_page(page, page_to_pfn(page), zone,
> +				alloc_order, freetype, FPI_SKIP_REPORT_NOTIFY);
> +		zone_unlock_irqrestore(zone, irq_flags);
> +		return NULL;
> +	}
> +
> +	if (!want_mapped) {
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
> +	zone_lock_irqsave(zone, irq_flags);
> +	for (unsigned int i = request_order; i < alloc_order; i++) {
> +		struct page *page_to_free = page + (1 << i);
> +
> +		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
> +			i, freetype, FPI_SKIP_REPORT_NOTIFY);
> +	}

Could expand() be used here?

> +	zone_unlock_irqrestore(zone, irq_flags);
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
> @@ -3331,8 +3468,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  {
>  	struct page *page;
>  	unsigned long flags;
> -	freetype_t ft_high = freetype_with_migrate(freetype,
> -						       MIGRATE_HIGHATOMIC);
> +	freetype_t ft_high = freetype_with_migrate(freetype, MIGRATE_HIGHATOMIC);
>  
>  	do {
>  		page = NULL;
> @@ -3357,13 +3493,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 */
>  			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
>  				page = __rmqueue_smallest(zone, order, ft_high);
> -
> -			if (!page) {
> -				zone_unlock_irqrestore(zone, flags);
> -				return NULL;
> -			}
>  		}
>  		zone_unlock_irqrestore(zone, flags);
> +
> +		/* Try changing direct map, now we've released the zone lock */
> +		if (!page)
> +			page = __rmqueue_direct_map(zone, order, alloc_flags, freetype);
> +		if (!page)
> +			return NULL;
> +
>  	} while (check_new_pages(page, order));
>  
>  	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
> @@ -3587,6 +3725,8 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
>  static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
>  						bool force)
>  {
> +	freetype_t ft_high = freetype_with_migrate(ac->freetype,
> +					MIGRATE_HIGHATOMIC);
>  	struct zonelist *zonelist = ac->zonelist;
>  	unsigned long flags;
>  	struct zoneref *z;
> @@ -3595,6 +3735,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
>  	int order;
>  	int ret;
>  
> +	if (freetype_idx(ft_high) < 0)
> +		return false;
> +
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
>  								ac->nodemask) {
>  		/*
> @@ -3608,8 +3751,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
>  		zone_lock_irqsave(zone, flags);
>  		for (order = 0; order < NR_PAGE_ORDERS; order++) {
>  			struct free_area *area = &(zone->free_area[order]);
> -			freetype_t ft_high = freetype_with_migrate(ac->freetype,
> -							MIGRATE_HIGHATOMIC);
>  			unsigned long size;
>  
>  			page = get_page_from_free_area(area, ft_high);
> @@ -5109,6 +5250,10 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	ac->nodemask = nodemask;
>  	ac->freetype = gfp_freetype(gfp_mask);
>  
> +	/* Not implemented yet. */
> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)
> +		return false;
> +
>  	if (cpusets_enabled()) {
>  		*alloc_gfp |= __GFP_HARDWALL;
>  		/*
> 


