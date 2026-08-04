Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD258C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F9B6B007B; Tue,  4 Aug 2026 19:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0636B0088; Tue,  4 Aug 2026 19:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07BA6B008A; Tue,  4 Aug 2026 19:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 763956B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:53:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A9EEA0317
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:53:23 +0000 (UTC)
X-FDA: 85065241086.17.8C68AEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6D9F0140007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:53:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iG8hn585;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785887601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tX26UcNQcpwpUpKUI2NES9lwWKY+4sm0L85R3xkQmIs=;
	b=cnmEcZE+QRpEGjWD+25eEwY2UqbH4IHQfEugVVhFlbsv6m4G9j/DDDjXT6KNbnG76eLcR9
	BWK2ZmGpxXT4qZsG+rcKt0UzE/IqC7Kpkttqwj0GVD1T/BP5vgsB1hwKEQ/aKVoRNVZdam
	9JKVVs21NXevOOCgeStLpYhbGQEAZIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785887601;
	b=0VQ+IitLgA+EdTwwKOOlCVYh24BfaroqbaOmv98IFS5EIyshibESVfSNsk/JwoJhy+MUPC
	XezNyiBSUIS/h2645IQ+hBoxngW5TXJN3r7pD5/l7wq/svxhnml9FTeGsu25+xI2b2YHyh
	JzDMx/laeUqlLLPaAQpR5cA7q4uckhw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iG8hn585;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C4A5407F2;
	Tue,  4 Aug 2026 23:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DFB1F00A3A;
	Tue,  4 Aug 2026 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785887600;
	bh=tX26UcNQcpwpUpKUI2NES9lwWKY+4sm0L85R3xkQmIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iG8hn585KZjy4uzOYteMLKfwvP9TDZPmFZcVX5eJFVwLKnl9TPstHf9Wm3UAVkn3c
	 hj3up0ugG7+ZX8Lrmmzt33db/0s9/G91PdHu8Uz7F12GCF+k7Eb7dGoQwJ/xAKXXEi
	 RBniR7/peOQTyLuoClZQPIZ5poNh5pivybeg6RroYjrbQaUN9x8WOh1kVqt+jwyjus
	 tMRqvIjclZoK7Yn/n1JMXfXm2AQntM7g1q1wHV1LnaP/dxdsRKmKdPTwLP9VmhEaFh
	 ymP+U+6defhJTs9+cCp6ZRZrHrN+J7zsM7Pa4aIxuwin16w/BFGX/jpxtyCK780CuH
	 djm33OTIc3NMg==
Date: Tue, 4 Aug 2026 23:53:18 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
Message-ID: <anJ45UK0MWvskzlK@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D9F0140007
X-Stat-Signature: 7jmh1uou8kso9q59jz4pwi6beq5ujrp6
X-HE-Tag: 1785887601-719714
X-HE-Meta: U2FsdGVkX19WD9ZiuwXTYI0SiiXhqmqdGn+aQpradWie07OkqO9oz/W0bffYKFEeEN8qRc0X0VQy6MWo5M5ZQDKx7DGrr1YIZzVFChYI2vx7GXGxFm2lJcXRSexvzsSrYtJkm6F+9kDEpy/B7g8fFtmQf+a/B9b6Jz8i1J7ZTszXDisRtsLoOKe51Ir35rjWBJHzkmbe8YHmUnZlFqDfy+v+h0lLAJsTDOiWCd23MqYRaY4kQ2ZlVzDwEQLqRyhixKqG76i9e0hOF8rikR4LtwmH49fWg6De5HJJaE7cywL+qXl6Ac4505PO6LPpMvRzhu1kKFvA6l1F09eggQjgUm3MvyR70LWIdpdgxnjD5uEz+LXJZOsjTRW5kNKIYSbEvN1UD5qH6QlVHhXDqgQW8455cc4qe0OLfFjgkANvM8NnCxmrcWWGepCC0xz136UIMNSg7/h4JTdkf4B6YoHVVshnxC/+DUhFuaKN7RGelYoIEJWlzJUBWuiw2uH/pY1gbycMCP6ITaT5yE1db28PQcrlVVWYeDOurj+O9ENkRYqOYlRcab3O0l83rTq/kZQ1kL1IEuMQNz5xQPW11ti2dbieQwYekIBAxRFDBPGJfPyJq4GHU7tsgmlL1u8Q86qmLQrOO//4ZftefW+elsABenSb6k/1JYrmB7cL7UpDPde+XVLIPSsOH+wZL+z3g5PioM78DMIJlNGLSpKGXxGUh8nrhdyC8yxCYUNRLnBVCxGYAHlIfHgd7Ey3MZ7tWUCP7NftxBIOuyqHvwkDQZFb96S8B03meYl1AkhmRb6lrRdrosv6gKyWx/NVW/YOOSmAuwuedSq3/HmAgKZj2D2VnD9kFSsdifL5HrH7HVmt9DwcBVSSra+j/UYlgRUQMSBhCwr0dMn2LO1STHaymE3xMVQNIBbJ8kVIw3oEQNnWaJelbPcpvjMj8R035VhpD9yv9BbWQlAJ31HhrveFB88
 ZNUPaaFc
 1LE18EPoYltNgS4Jya/OqHgOU81Rq5H7snwV3CIuseC3RqSiiF+ReN/kHg1Ls/RceglsM5tEW00AAfbnT3t+dZHhMfsjYQBF0DuPlg10dh2aL/3SygXB7boH2ESTKBgSuUIZCMcRIe0rFtgbEOFoRMuWEsFejSNmdWfI1M2jNAADrIF/n0yB3JEWul9FS/eg/crS3c2r7SJ3yb7NRDLf+8x6a3WmPzC+aUYUVCZAAste2v93CpoZ6znvBkHoDOX9kLspivSEDijKc1zKdyesr1rCmUBAS//KoxhhV9sJH70aC2kEHz7ukoaFEnlMhCrG+uq7ryifnwMUBYcoqo2/v2xl+hENs51EdIGaStOFKoxF9cVdyZwU+1uagZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
> +	}
> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> +	if (!page)
> +		return NULL;

IIUC we only try to change an entire pageblock here, but what if we
can't? If memory is fragmented enough that many pageblocks have few
unmapped pages in them, how do we serve a mapped allocation (e.g. a slab
allocation)?

We'll go into reclaim/compaction, but there's a chance we'll end up with
unexpected allocation failures or OOM kills even though we have free
memory, because unmapped memory is not movable or reclaimable (as of
now, at least).

The same could happen if many pageblocks have few mapped but unmovable
pages in them, and we make an unmapped allocation.

I wonder if we still need a fallback case where a pageblock contains a
mix of mapped and unmapped pages. We need to carefully handle such
pageblocks:
- For unmapped allocations, we need to unmap the relevant PTEs and
  potentially do a TLB shootdown (if they were previously mapped). Maybe
  we should always flush the TLB for simplicity for now.
- For mapped allocations, we need to map the relevant PTEs. No TLB
  shootdown should be needed.

Assuming unmapped allocations are always zeroed by the users on alloc
and free, we don't need to worry about zeroing pages either way.

We may want to track the number of unmapped pages in such page blocks to
now when it's fully mapped or fully unmapped and change its type, but
maybe this can be a followup if needed.

