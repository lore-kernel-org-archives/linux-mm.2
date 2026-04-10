Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F85E99068
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A802C6B0005; Fri, 10 Apr 2026 05:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56E86B0089; Fri, 10 Apr 2026 05:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DF36B008A; Fri, 10 Apr 2026 05:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6336B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:48:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3738813AD81
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:48:29 +0000 (UTC)
X-FDA: 84642171138.04.BF087BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 679981C0011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:48:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I3RYK9gt;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775814507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lme30aOCS1/76P6mf921yZdqIPtJZwN1hIjevDnlwgs=;
	b=Wz3AZvvb2uBLsXkn9F9Ear42jErt+1hwTPQmJr98gWgMO+54OZsfTIiby7rtiXsVQfMwEP
	aIXEVaJ4Z0Kin97PsEEoAj/5i0oF8TnpQDeN/eQHYDUmnKaazE/o+xnVxocQvcTxdZCKrV
	KCyPMa6TlBQ3UhlZKkiXlnFMOdii5K0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775814507; a=rsa-sha256;
	cv=none;
	b=q2y0f8cK1zl+1WbG7NXcr4ceJO6cA1iwa74Yw14EXt16ykZr2DZlybHFD5ABMyRHTdeyka
	rfODwVf3jLNXW1pLgaFt5p0YUBzMP3+VBlVGLwprK04PrtMg+AAqbi+c+7Hwda4Qbi37xU
	qCgdg16iw6cMouz+ZeOjnEJKwK/Z3ps=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I3RYK9gt;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6132843455;
	Fri, 10 Apr 2026 09:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A531C19421;
	Fri, 10 Apr 2026 09:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775814506;
	bh=8tu+16d3tHNI6yjzRxCdUnNsYp8nx66rNOh6urCClKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I3RYK9gt5otmhKqTNux/rRBAXdV8c/vJAN7FNb+KJWHaFDnDFgdCxVbK9gbAfLhPx
	 dooXbneJaSH00noAe5YxTs9Ss8fCcY9UXTI1XKpMZ9UpEz43T+ExWL5aRvTk7uZx/W
	 nnbbv6CjUrqWwbc/6D/aBWFFIHIv6lCry2PGzB3e1qk1Q9PiiwMKP6DrurtB1Zm+0m
	 Vo6K2IiA4SuVQeelKK+5mIHbEiqBX13BHh5Wtgg7/e4B+QX8uT4j7wMwy2ma8Nze1A
	 rme/60pkbwZDgGZWe6mrc6w+uybrrProuDy+sjfxD7FS5LCxd7OAxi/C8ZwkHtsHXs
	 ljv6bw/A+OVoQ==
Message-ID: <45f3a5ba-9f61-4ee7-bc9a-af50057c0865@kernel.org>
Date: Fri, 10 Apr 2026 11:48:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Rik van Riel
 <riel@surriel.com>, linux-kernel@vger.kernel.org
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <20260403194526.477775-3-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260403194526.477775-3-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 679981C0011
X-Stat-Signature: ogigsynurnysguwd63m65yfeynik9nba
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775814507-494138
X-HE-Meta: U2FsdGVkX18VdCMK6wL6/6S4EJ3DWav/0JNI1srA/BvgCofxlgG6Pa9AyYX6ePCpdqdVgnrodWSRpC5ORgkbqxBnK4EOYYQesVh9x2L1MF6gSXJjlVs/bs4UVFptSM+DQUJbX6c5Z4wNwQ9KzAKCJ16WpFJUFpaYktbrHut1kXgk5qpsVyknXkjIoq9a+2DW5+dke0G+iNmTddSTqIQ8dIUCE8XMWBk2tsvY1EnMHHBsNVaYcnT2khmvqT/ta/y0KdsLsTleOlwhWYFGNm0rLk1KPNpTiNPWB8K+0rAeJx8W0ObnSEdgQs04CpC/bOOeRWKS47CqZKhXPj3t6bFFfb0Z4yD7W898aUMAoqIpYyY+SQbKL0kB32cLPkF4FeoJ31fpFqMdFkd4i0SToASwmmrvrg++AP7vvLjJtZ7OuEzKNjoOlhLUemoXEMb5xKZd6M0jXTy/O7P3hj5ckQLww0aDqkd9Pdlquvq+ekEwQHfUi7Z3t60kAs1pu+Ter3U3NGrMF8PwHa3NIIANeKU8tJk4jhfPUIdP8632oo9RkRCNlB6GcNZ771CAFoeqYn3Fv3OjHhrd9QDMrLbObRI0W9mtP7kaYI0tacF6hAJwj7gPJYPvY4lrheDK/FFOiMhsq8ehUtmw+uYOgaUyUZAdx6hFNGf4xy9Ngy5+1MDsKEblEslC7uuQXGciL8YQ5glP5yJ9e4dRQCgOYLaggWukASgww3LSYoUHd35YFtXk3b4wXkNqLSa+bzdI9cYPxcdffOvv4l7tXgyzN/vVWcWqD2sDOgEh8wTwot+SUFPqk+WjBNvsU69dMNrRP1xCtjsm7SqaeST0MA/E3Pz75dQF7Pt6sLD3kTkJRJ0+KD9+rEivnmR29LR63mxyuPLMWtOPntVOUZCk/6g69V/CGhbfzRQDHH5a5d3Rv9HyYZWgVEY0uus4HnpeoOI92C2cKSG/HKgfTXFjWKBJJvydEsX
 ygHeodtv
 5YFTzF5JLdaVArqelOzPRec5rrmvTrSmSZyOoYQ5A3yCzZNIB7MCicqpdlYz4Xv/5FzZ7nPD6JmsKOkFwqWWRIIiEO+xFn1EPeMMCrRCBO5cou8OeV8GGRraT24Lu0oRTOXES3LagvgrfYaygoTrXiSqrxVD81GEwC4G66fTZ8r1wbP6qXkhX+NFwT4822fBAuV8eSZoEGYms7DRfY9f08LL4CBEyTQKrqYu4g9CDrtdPJ3hhNs+U6Hh+iQRxxz72jZvrAhWRvuIq+xuihbpQO4T+8QsdEl5t+eUq00uUvvxL3iAODZoOXi2x3XN4uSD22YnQBI4f36pFjH0fqLmi2kh09uron6Xju1o+bgpnFYPEOrOHwMxO9tDpHtIPRVjpKgM2MYoCIJOBO+DYQZszAz+1+YFnTsfdqonw/HOVxJ5jxA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/3/26 21:40, Johannes Weiner wrote:
> On large machines, zone->lock is a scaling bottleneck for page
> allocation. Two common patterns drive contention:
> 
> 1. Affinity violations: pages are allocated on one CPU but freed on
> another (jemalloc, exit, reclaim). The freeing CPU's PCP drains to
> zone buddy, and the allocating CPU refills from zone buddy -- both
> under zone->lock, defeating PCP batching entirely.
> 
> 2. Concurrent exits: processes tearing down large address spaces
> simultaneously overwhelm per-CPU PCP capacity, serializing on
> zone->lock for overflow.
> 
> Solution
> 
> Extend the PCP to operate on whole pageblocks with ownership tracking.

Hi Johannes,

interesting ideas, as usual from you :) I'll try to point out some things
that immediately came to mind, although it's not a thorough review.

> Each CPU claims pageblocks from the zone buddy and splits them
> locally. Pages are tagged with their owning CPU, so frees route back
> to the owner's PCP regardless of which CPU frees. This eliminates
> affinity violations: the owner CPU's PCP absorbs both allocations and
> frees for its blocks without touching zone->lock.

Details differ a lot of course (i.e. slab has no buddy merging) but I can
see some parallel with SLUB's cpu slabs and these "cpu owned pageblocks".
However SLUB moved into the direction of today's pcplists with replacing
that with sheaves, and this is moving in the opposite direction :)

> It also shortens zone->lock hold time during drain and refill
> cycles. Whole blocks are acquired under zone->lock and then split
> outside of it. Affinity routing to the owning PCP on free enables
> buddy merging outside the zone->lock as well; a bottom-up merge pass
> runs under pcp->lock on drain, freeing larger chunks under zone->lock.
> 
> PCP refill uses a four-phase approach:
> 
> Phase 0: recover owned fragments previously drained to zone buddy.

Note this is done using pfn scanning under zone lock. Is there a risk of
defeating the short lock hold time goal?

> Phase 1: claim whole pageblocks from zone buddy.
> Phase 2: grab sub-pageblock chunks without migratetype stealing.
> Phase 3: traditional __rmqueue() with migratetype fallback.
> 
> Phase 0/1 pages are owned and marked PagePCPBuddy, making them
> eligible for PCP-level merging. Phase 2/3 pages are cached on PCP for
> batching only -- no ownership, no merging.

> However, Phase 2 still
> benefits from chunky zone transactions: it pulls higher-order entries
> from zone free lists under zone->lock and splits them on the PCP
> outside of it, rather than acquiring zone->lock per page.

I think this particular benefit could be possible to do even today without
the other changes. Should we try it first?

> When PCP batch sizes are small (small machines with few CPUs) or the
> zone is fragmented and no whole pageblocks are available, refill falls
> through to Phase 2/3 naturally. The allocator degrades gracefully to
> the original page-at-a-time behavior.
> 
> When owned blocks accumulate long-lived allocations (e.g. a mix of
> anonymous and file cache pages), partial block drains send the free
> fragments to zone buddy and remember the block, so Phase 0 can recover
> them on the next refill. This allows the allocator to pack new
> allocations next to existing ones in already-committed blocks rather
> than consuming fresh pageblocks, keeping fragmentation contained.

So this reads like there could be multiple owned blocks (is there any
limit?) with only a bunch of free pages each, increasing my concern about
pfn scanning under zone lock.

> Data structures:
> 
> - per_cpu_pages: +owned_blocks list head, +PCPF_CPU_DEAD flag to gate
>   enqueuing on offline CPUs.
> - pageblock_data: +cpu (owner), +block_pfn, +cpu_node (recovery list
>   linkage). 32 bytes per pageblock, ~16KB per GB with 2MB pageblocks.
> - PagePCPBuddy page type marks pages eligible for PCP-level merging.
> 
> [riel@surriel.com: fix ownership clearing on direct block frees]
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>


>  /*
> @@ -2907,9 +3205,11 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  {
>  	unsigned long UP_flags;
>  	struct per_cpu_pages *pcp;
> +	struct pageblock_data *pbd;
>  	struct zone *zone;
>  	unsigned long pfn = page_to_pfn(page);
>  	int migratetype;
> +	int owner_cpu, cache_cpu;
>  
>  	if (!pcp_allowed_order(order)) {
>  		__free_pages_ok(page, order, fpi_flags);
> @@ -2927,7 +3227,8 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  	 * excessively into the page allocator
>  	 */
>  	zone = page_zone(page);
> -	migratetype = get_pfnblock_migratetype(page, pfn);
> +	pbd = pfn_to_pageblock(page, pfn);
> +	migratetype = pbd_migratetype(pbd);
>  	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
>  		if (unlikely(is_migrate_isolate(migratetype))) {
>  			free_one_page(zone, page, pfn, order, fpi_flags);
> @@ -2941,15 +3242,45 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  		add_page_to_zone_llist(zone, page, order);
>  		return;
>  	}
> -	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
> -	if (pcp) {
> -		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
> -						order, fpi_flags, &UP_flags))
> +
> +	/*
> +	 * Route page to the owning CPU's PCP for merging, or to
> +	 * the local PCP for batching (zone-owned pages). Zone-owned
> +	 * pages are cached without PagePCPBuddy -- the merge pass
> +	 * skips them, so they're inert on any PCP list and drain
> +	 * individually to zone buddy.
> +	 *
> +	 * Ownership is stable here: it can only change when the
> +	 * pageblock is complete -- either fully free in zone buddy
> +	 * (Phase 1 claims) or fully merged on PCP (drain disowns).
> +	 * Since we hold this page, neither can happen.
> +	 */
> +	owner_cpu = pbd->cpu - 1;
> +	cache_cpu = owner_cpu;
> +	if (cache_cpu < 0)
> +		cache_cpu = raw_smp_processor_id();
> +
> +	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
> +	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
> +		if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
> +			free_one_page(zone, page, pfn, order, fpi_flags);
>  			return;
> -		pcp_spin_unlock(pcp, UP_flags);
> +		}
>  	} else {
> +		spin_lock_irqsave(&pcp->lock, UP_flags);

Hm was it necessary to replace the pcp trylock scheme with
spin_lock_irqsave() here?

> +	}
> +
> +	if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
> +		spin_unlock_irqrestore(&pcp->lock, UP_flags);
>  		free_one_page(zone, page, pfn, order, fpi_flags);
> +		return;
>  	}
> +
> +	free_frozen_page_commit(zone, pcp, page,
> +				migratetype, order, fpi_flags,
> +				cache_cpu == owner_cpu);
> +
> +	spin_unlock_irqrestore(&pcp->lock, UP_flags);
>  }
>  
>  void free_frozen_pages(struct page *page, unsigned int order)

