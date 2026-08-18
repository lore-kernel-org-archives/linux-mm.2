Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAC0C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078386B0127; Mon, 17 Aug 2026 21:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F3A6B0128; Mon, 17 Aug 2026 21:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFC76B0129; Mon, 17 Aug 2026 21:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAD086B0127
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:01:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AAD71C1AB3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:01:21 +0000 (UTC)
X-FDA: 85112586762.06.6C186DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A00AF180010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:01:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKnLqSYG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787014879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QD5d267PH0IMQTt0pb3tQZChKremBcVsncH9JWPYf0=;
	b=Cm++CX+LSDwzGK6vSJyEN5avwS+a2aaIDU1yXUHHq8NrxGYdHZ0WXnRE/4Jj0UBAyWD+Ib
	7kikkMZIKOMsJBP0wQ9XlvsMEYNbu//Kb4KK4Lt+WXTZEpC+EMwDTw28Oq9/Hk61N4NVtD
	FtDqS56THBeJC52zrBW85w4sFy0gX4A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKnLqSYG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787014879;
	b=idmXSB8OXtAXbN5Z79SOCXxzNgh701ZmrgL0T7KC6ZowF4/cOLHJXGYfvGO+kbZ4zgqRi6
	LRU7AZNFD+2AivFG+06k6UfyyGVCfVKabc++qgbt4a2Q5m6ltl8W0PLuRD1Uo5mOHbQEca
	mscKqKC4naA1o1x8CoMrjEosH26of3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F07A601DE;
	Tue, 18 Aug 2026 01:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17081F000E9;
	Tue, 18 Aug 2026 01:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787014878;
	bh=+QD5d267PH0IMQTt0pb3tQZChKremBcVsncH9JWPYf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aKnLqSYGDe6Pt2Gz6AXtiX+qNyYEIoBO8XbsbQrp56ap0mXJ0rG65QGZiS3IPKo29
	 z8cbPpo2p045dfHPZyZ/B+2B1jc4M+iaw+MUuTNbfZuL88m6PWrpBlCpzDtxs1UGTQ
	 +6vfDHpVVHlHWfyiMrmFVkkx3XfHvfUFGpuFwBDv0pCXRbOq1KCdCjPD5/9brfymvz
	 ptO/glLoHVTl25cUT/Goq84B3fZsPXLtBowEIt8tGCIcMSXjaP0V7PlS4wm8U9wDfS
	 XRFkV0O+SSNKjRSldLb77tKWlERbudVShJ4d0d48aiRCqbi39GjXC5k/RCMNGrYpuo
	 V6daW+bEvGpDg==
Date: Tue, 18 Aug 2026 01:01:16 +0000
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
Message-ID: <aoOt7-tBEHp_3Bnt@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
X-Stat-Signature: s8htsnyzcpcqcr1ezwgrzco41tp8pg3p
X-Rspamd-Queue-Id: A00AF180010
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787014879-930778
X-HE-Meta: U2FsdGVkX19KYkbXixq0YIXXY82CEz8Satg0DJKhE2pAx8dOsyVXtrH38qTk1DcIAFzNICxrz1N4Rezr9Rdez8BCGPPyXiXncL7THI9SJYEeNfrONuXuLQVlHUI4Azi3HtTHjYqDXkmUkW3wyiNStSFsh99nH4G270v+Vnj4kJKBqvZ1lFd6rQ30FQU+8f8QFxoyu1RFs2HK0aP+SJz2NxKjUZxy27HYkSSyllgJzJWJGok6aO5fCot5emsKIW+nGBCKKwH7lWoITOSmAWiiYJazyhQh12P8cIYE3Wimzpn9GpZXXmPSkTweMBY/UTMz87DvKJKvGnJi4w5AGIkZonIlH24T4Jphx1To/KRy8RzgeXWYn0yDpzBPa3Q+L1r8dU9irC8rwKXXBdvkmny3xYribB7qs4qTXV5aT6GtktR0iBGtb+JNVRR1fzw8PQybvvg+EVZbcNmOltfL1ZXI43SOD5fGzzK2kDol6Ej/sLYCaorV1yHn1JS2Fpaqy5WS7u13KEwWVjkgaAmEzRajraEUF2VhQcp/UNmuylSfThpVm9lcAhuN11hM9y8PX1GKrHIUnh4+ud+ev+v8DXFEjnqgFGS1Fm7isrdbf79jkL2RD2E17pGEt4TBnqYdxw+8rKrX0mHNvPIrImtSvsihTH6MfQzqZltLsnYRztIWkq8Sm4JK4MDqTetQAsPjuN2vdtSWu/tvKXm+ru7NjF61O1c86JkCtWS5J62PJco0qbYP1nyqa4Cf2C6Z76kv+odIySKNpCNhtpH1QjjD/io8rrekjiroMj3c2qZ8Zn50AlFq9eQnm9cxqyzp2WV53xse1CP66OP9stuTh7flh8RIo4QbALJZtrVENirPaMnh8E7h1o+F5JTMzjNVIIitgIhpD1jz2H6Y6qk+AOwCGXII6TrUMukYyiDwxHKTp5A88smcHB5JtgGPNlz0TpFRboEaxs7XAtl4u3cQH/yFooG
 eX0tyvok
 hCId70MQ+6tbETPw+jbX6cn46HBLOSBdVmBirgvOMcV0+iMKGMbVEcfyZJraVRV7b5BDEXnb8ciiY47Ulaa0e3k1J8NFlNUKvZi5Epj5011RQnBXncFSpYrBDpgvK2xukuMlbxKvvlF0UTxHCd2X6q1Xbi/9ooYDJPD7y0ddAyjpiIfcK927qFWZscKPoNljRPNEGFxS0YWxenU8yobPa9whHdCQyVkXwYcr5JWgCMjboPqxHOFGvw9RoNPbeCZZvcLumnRKtzenJzgeUa6V+xc8tsvHqOSlvVUPsF/t/e8iizWVccsbciB2NuYacrVf0IK/66pLmANY//Q8XqaCPw7zFvLKPZLvPpDwq09/1tnzGajk=
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
> 
> This makes allocations that need to change sensitivity _somewhat_
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
> ---
>  mm/Kconfig      |   7 +-
>  mm/compaction.c |   8 ++-
>  mm/page_alloc.c | 214 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>  mm/page_alloc.h |  13 +++-
>  mm/page_owner.c |   6 +-
>  5 files changed, 215 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index aa5f041ce1a67..6a89cbf8e8c6e 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1527,9 +1527,10 @@ config MERMAP_KUNIT_TEST
>  
>  	  If unsure, say N.
>  
> +config PAGE_ALLOC_UNMAPPED
> +	bool
> +	depends on !HIGHMEM
> +
>  source "mm/damon/Kconfig"
>  
>  endmenu
> -
> -config PAGE_ALLOC_UNMAPPED
> -	bool
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 67b01af024e17..c9eb3947ffc79 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1393,6 +1393,9 @@ static bool suitable_migration_source(struct compact_control *cc,

There is a direct compaction check above the context lines:

	/*
         * Background compaction produces blocks for the zone at
         * large, with no particular allocation context. Allow all
         * block types, including CMA.
         */
        if (!cc->direct_compaction)
                return true;

>  	block_ft = get_pageblock_freetype(page);
>  	block_mt = free_to_migratetype(block_ft);
>  
> +	if (freetype_unmapped(get_pageblock_freetype(page)))
> +		return false;

..and I think this freetype_unmapped() check should be moved above it.
Otherwise kcompactd (for e.g.) won't check for unmapped pages and
crashes.

[..]

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

For a movable mapped allocation, ft_other will end up being movable
unmapped, which will immediately fail this check before trying to
convert a pageblock. This leads to premature OOM kills.

> +
> +	/*
> +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
> +	 * safe if the caller holds a lock (in case the other CPUs need that
> +	 * lock to handle the shootdown IPI).
> +	 */
> +	if (alloc_flags & ALLOC_NOBLOCK)
> +		return NULL;
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
> +	if (!page) {
> +		/* Fallback to changing a block's migratetype. */
> +		rmqm = RMQUEUE_CLAIM;
> +		page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);

IIUC, the first call to __rmqueue() will already try RMQUEUE_CLAIM. Is
this redundant?

