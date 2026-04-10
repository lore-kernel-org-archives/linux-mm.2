Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2009F45A08
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 19:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6E06B0088; Fri, 10 Apr 2026 15:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E681F6B008A; Fri, 10 Apr 2026 15:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B126B0092; Fri, 10 Apr 2026 15:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C0A446B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:12:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E5C91401D0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:12:29 +0000 (UTC)
X-FDA: 84643592418.15.0E8E7B0
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3743114000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:12:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=H7E0AoFD;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775848347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQjd2tzgI6oSJuNqIonNuY40hOoOZO4B1i4e3mkLOJw=;
	b=oWd7blN+ap3vuzTIxPFCqTnRG9xZnbg84RNBzCB0XmhnDGgApcP6SK/BBIjeumHXW7z4Lm
	RVQjnDKQxjhNOyF7rLwgFTqfRJvFUhLwXPu7HHDWYOzHQRtAsmg/5pdb/5LVe9FSlf7/6h
	hgUZfNtzXG9Du9gJ1DDkOqM84r+fLa4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775848347; a=rsa-sha256;
	cv=none;
	b=JbGVAGlqM9qBeeMhzBXdGEztbmpMXBdBPJzQbtt4wDRzr+k0Ee/XOS8jOucXLvRZmMT2ew
	u7NVcClarjHMmQLR3FRtkJpX/5fedws7+uhh+8kNYstpWU6L5OpvoSeKZmIvtj4b6Bn9bv
	dHZWGhqPflo3ThtkW7KyVbmL3E1593w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=H7E0AoFD;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8d4f78fc9f6so280067985a.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775848346; x=1776453146; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQjd2tzgI6oSJuNqIonNuY40hOoOZO4B1i4e3mkLOJw=;
        b=H7E0AoFD4T8vlSQtoKFaL5uTiIB2CCodlelpp1HXmDCDM7JHiK/ex+StXJjV+a3biS
         15ZYRm6aDjP2JaLha5oWjU52VpLWebXHc6B5tbtjmHEMBjthgGXoQ0Ie0JV6EYU7YElU
         e9ocUDyvmaL4d6l0V/dR04R1Kw2tfew23HTeJ4k2mWKwUU5iIW+Fp7INZGiwlBJUvccB
         3Hi8M9oOh/FUgvrrd7XNBskT6bshpLQh3jPhqI7YGo+QTXPbO6ljhJWDaaU2FOHfDj05
         UwT4jVkQD8joAgjM9nrvE+iKamKPNvA+d4DvJnjBTpAOSCJAo4ZDPRSZUBGj/nPgNN16
         7+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775848346; x=1776453146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQjd2tzgI6oSJuNqIonNuY40hOoOZO4B1i4e3mkLOJw=;
        b=SdXAo26IEAE4L902kCm3PdVDSv26TGuyR46rm4CL3x4K4BkCMfqbzGu76Yv9JxyRUV
         9/AWp9xIU4XZdYL5Nm6qLMRshNti43TcNpkXeWxQz+298gfmoJxH4DCyBe8jathKEdQt
         L9UDrMH3rOzWYjej2nCmdcM7n9q6ypwTvJEcyhSQr2fEaGh/SL4ZvaI2nxQSoNByiATm
         98Py1nlA52/iAM5j+AFY4l6HIBd+OrzyXXCJagYb0Wpm/4euhoZIQajX517Qp4X2B9B2
         jC9oaTmliyImYtbPpyL3jRJqTPEiATzd1CB/adamWKrBIDOYLb4DenVT8HHf76DDkfO5
         OLaA==
X-Gm-Message-State: AOJu0YxMSCPKN4l5VZkSW9b0W1yTrR6kxvJq6Xk76EJmFGd/glwkJ0ut
	4qz4Y07JUHriEVxOXwX0cm41xkl+uJHWxvZiLBoe2mwXJvcJT9iNmtcozjxosVabFEU=
X-Gm-Gg: AeBDiev+a+YpnBDkWmxaxHRhs91uYxoLxQm5vOhr9o+PV/CPAcpZKh2Ih1Ymk2GNvJ/
	WhTJPFb9FH5REFbHYDmPo2zBADpbtBqRqt1yNqI8eSijMTHNBBFvMxzu1d/zyWJUrVBBpADXsiJ
	RWcMUU9EDoNy+9uEA1DJ9UNMQNDF6EWPp5Ij97bHr/G1mcnRQJ1h9zsNRChpRdxvEXbst3Vn/6U
	ZK61V7i0O2nuRsm99UrYfcYRyRkDA6kyZcWLhM9lwt/ydQf7nFedEsGZqCJOBphVyGaktJGbXnR
	OBQj8WIb7eCXsekcOp+H4R5b/TS3KGJ9WMXTcPwqBkNHtlKcvaGAkZy4jTKgLLR3N+3duwkb/Up
	YV1NVzFjx5B4esDy+Y98FMfs2We6GK6U9Up0FFhlwZ45hQ2LrP8NSyAbWiGLboU4o8f7sMX48pm
	Wrc1s6u+oO6TOeOyqc2ehMhg==
X-Received: by 2002:a05:620a:19a7:b0:8cd:942e:82d7 with SMTP id af79cd13be357-8ddcd8f6b1fmr591533185a.24.1775848345948;
        Fri, 10 Apr 2026 12:12:25 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8dead5143b3sm101934585a.3.2026.04.10.12.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 12:12:24 -0700 (PDT)
Date: Fri, 10 Apr 2026 15:12:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
Message-ID: <adlLlARgYNL_T5hq@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <20260403194526.477775-3-hannes@cmpxchg.org>
 <45f3a5ba-9f61-4ee7-bc9a-af50057c0865@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45f3a5ba-9f61-4ee7-bc9a-af50057c0865@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: ykfzxq41gj3tu1fsu1f65uu36ax19ohi
X-Rspamd-Queue-Id: 3743114000B
X-Rspam-User: 
X-HE-Tag: 1775848347-189004
X-HE-Meta: U2FsdGVkX1+LQAwIqrwBPidBDxAJFN3israb4JLnJzyvK4CSox5eG9UnknIKh3+2QnNCNuUhtvvXjScgYwA2uv0KFBqi0wFHKVN4KcIWb5mNezAJFl4tlPeJ8utpMCTO2vzcHClcYO9v45m5+DJwWQJdbj6IjUHv96PYP6RCVdgz3ZWCIqXyqIixPniGbZNxqg7K0KivfGSXqDImMuPOnMmtclV6FqJz1ryAUZmh5YtpwS9DztKE16rbaTVj9nOJpMVWkjGm52h2vzuNSNP0XX7o+mB/jgxKISVKjLx2gvTavGzSnZO575EZBimrdUzFsM/FzC+19LE9r5Dxwm5PO7SbgqY9BJhgaHstFnQ+juYs0KDBPiM/WzGyxSa1bmUkQwpaFvkiNuBu7z6Zpr2Kv+U9gJCXQmCBH6C/PQQlXmuqQYZXTYrZMgPwVdA9b3vBpGpGFlt/eP74ML4xmcG0jrsL8yBvRbV7QL7AM3vL89bFPsaicbamW0AnlP3faPn7rkRDHAO9KYwDaYlgs60RPMWJekQ1+L/AkxnVj7sC2EFRdYhUPCN3w9zpT5ycVeHR9aP60XKmg6yLhwEbiANZ7SxjMPH2poZi1pn3/++bD5Nj47172piSyxEzSxBoDrdbhgOWDUDEc3zxWX/JUeDIExl4JaLWUaaC7iRh2Lmi3Fa6+K/vVjw+sjMpAyhcVDe+qTrdIq1lw1NqOO2HEU8J9CVrhHJVd/7Vfd6R4Uld8AJ94bw/Ul9rkvtwLl71ksCH6v30t3a6DM6GjDgsvq4FDJUOv5pkMDiazkeU95q8m00thVjHtcgL7CBL2Yi+OImBLuuFblIgCrBdBuUky5jO5JZp0w0QLknwFY76uw68DksnTDS3laKbFeh5EuKsLo7Oo11+SFmIWsiY9Y7xfN6G3Dgr4YSiX+8LSrRj8nNbH49v7f6YdYz2l44IZVbfD1LuoPfd9Ygc1Cclf98nLYG
 NAE7UJXG
 lVdCA5KNgHSGYYsZ1EXQtd9sFjk+/9C2Ae8WjMlHNGC2UObzzkWaq69sZAf0UuxD3tfWWetl6mreQOyRv25cymtA0a1XSNiQ0vv271VZouHXutZ9wkghxC6uugUcS5dFC8tVPSRZTUUz/XqZFvet4YLKfFjH8PJDaDia1iNHNiU8j1mW4mnfnfY7xsJSU+wHh6U+VMdDUzHeAgKhsUtYu0+Xgd/WIQHixR6HiJzk5MlX/YJmiNGEWf18X+DZmAH2G4fohFRmbqtj/BJrd7bOBQVRICojnQQbltW7wVpVcl2Cz40Cc6OKTIzPMuJalCI7aE7MudWoDCIutmW/QVJ00e00WZ2bYUBGB4ZJxaj780ab7k7jE2bhu0/SxG/37nKfK+toytYIGA0rfxy/BZ8YV0/gxDPBgawW9SaIoeOVASDhu1Jt471do85sOWwAC1vXbKpnwzxLUnnbHD3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Vlastimil,

On Fri, Apr 10, 2026 at 11:48:21AM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/3/26 21:40, Johannes Weiner wrote:
> > On large machines, zone->lock is a scaling bottleneck for page
> > allocation. Two common patterns drive contention:
> > 
> > 1. Affinity violations: pages are allocated on one CPU but freed on
> > another (jemalloc, exit, reclaim). The freeing CPU's PCP drains to
> > zone buddy, and the allocating CPU refills from zone buddy -- both
> > under zone->lock, defeating PCP batching entirely.
> > 
> > 2. Concurrent exits: processes tearing down large address spaces
> > simultaneously overwhelm per-CPU PCP capacity, serializing on
> > zone->lock for overflow.
> > 
> > Solution
> > 
> > Extend the PCP to operate on whole pageblocks with ownership tracking.
> 
> Hi Johannes,
> 
> interesting ideas, as usual from you :) I'll try to point out some things
> that immediately came to mind, although it's not a thorough review.

Thanks for taking a look!

> > Each CPU claims pageblocks from the zone buddy and splits them
> > locally. Pages are tagged with their owning CPU, so frees route back
> > to the owner's PCP regardless of which CPU frees. This eliminates
> > affinity violations: the owner CPU's PCP absorbs both allocations and
> > frees for its blocks without touching zone->lock.
> 
> Details differ a lot of course (i.e. slab has no buddy merging) but I can
> see some parallel with SLUB's cpu slabs and these "cpu owned pageblocks".
> However SLUB moved into the direction of today's pcplists with replacing
> that with sheaves, and this is moving in the opposite direction :)

Let me think about this more. I've not attempted a deeper comparison
with slub, but rather followed the data on painpoints in the current
buddy / pcp allocator dynamics.

> > It also shortens zone->lock hold time during drain and refill
> > cycles. Whole blocks are acquired under zone->lock and then split
> > outside of it. Affinity routing to the owning PCP on free enables
> > buddy merging outside the zone->lock as well; a bottom-up merge pass
> > runs under pcp->lock on drain, freeing larger chunks under zone->lock.
> > 
> > PCP refill uses a four-phase approach:
> > 
> > Phase 0: recover owned fragments previously drained to zone buddy.
> 
> Note this is done using pfn scanning under zone lock. Is there a risk of
> defeating the short lock hold time goal?

This is part of a larger question, let me take a stab below.

> > Phase 1: claim whole pageblocks from zone buddy.
> > Phase 2: grab sub-pageblock chunks without migratetype stealing.
> > Phase 3: traditional __rmqueue() with migratetype fallback.
> > 
> > Phase 0/1 pages are owned and marked PagePCPBuddy, making them
> > eligible for PCP-level merging. Phase 2/3 pages are cached on PCP for
> > batching only -- no ownership, no merging.
> 
> > However, Phase 2 still
> > benefits from chunky zone transactions: it pulls higher-order entries
> > from zone free lists under zone->lock and splits them on the PCP
> > outside of it, rather than acquiring zone->lock per page.
> 
> I think this particular benefit could be possible to do even today without
> the other changes. Should we try it first?

I'll experiment with that in isolation. I would expect it to help in
the allocation paths.

That said, the worst congestion we've seen were all triggered by the
freeing paths. Faults and allocations tend to be more spread out over
time. It's the frees that happen in CPU-bound avalanches of order-0.

> > When PCP batch sizes are small (small machines with few CPUs) or the
> > zone is fragmented and no whole pageblocks are available, refill falls
> > through to Phase 2/3 naturally. The allocator degrades gracefully to
> > the original page-at-a-time behavior.
> > 
> > When owned blocks accumulate long-lived allocations (e.g. a mix of
> > anonymous and file cache pages), partial block drains send the free
> > fragments to zone buddy and remember the block, so Phase 0 can recover
> > them on the next refill. This allows the allocator to pack new
> > allocations next to existing ones in already-committed blocks rather
> > than consuming fresh pageblocks, keeping fragmentation contained.
> 
> So this reads like there could be multiple owned blocks (is there any
> limit?) with only a bunch of free pages each, increasing my concern about
> pfn scanning under zone lock.

Yes, it's a concern right now, and needs more work.

The list is built from PCP fragments on drain, and fully consumed on
refill (migratetype mismatch aside, need to fix). That caps the list
at pcp->high_max - pcp->batch blocks in the worst case (when there is
only one free page in each block).

Those last free pages can get stolen by another CPU before the next
refill, resulting in a PFN walk worst-case of (pcp->high_max -
pcp->batch) * pageblock_nr_pages.

Some ideas I need to try out:

- First I think we can bound the zone->lock hold period easily by
  cycling the lock after each block.

- We could maintain a free counter in pageblock_data to terminate the
  scan early if no buddies remain.

- We might be able to hard limit the PFN scans to 2x or 4x
  pages_needed, then fall through to grabbing individual pages. We
  shouldn't get new blocks while there are unrecovered partial blocks,
  or it would defeat the point of recovery (runaway consumption of new
  blocks pinned by a couple of long-lived allocations). The dynamics
  this would add are a bit harder to reason about.

> > @@ -2941,15 +3242,45 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
> >  		add_page_to_zone_llist(zone, page, order);
> >  		return;
> >  	}
> > -	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
> > -	if (pcp) {
> > -		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
> > -						order, fpi_flags, &UP_flags))
> > +
> > +	/*
> > +	 * Route page to the owning CPU's PCP for merging, or to
> > +	 * the local PCP for batching (zone-owned pages). Zone-owned
> > +	 * pages are cached without PagePCPBuddy -- the merge pass
> > +	 * skips them, so they're inert on any PCP list and drain
> > +	 * individually to zone buddy.
> > +	 *
> > +	 * Ownership is stable here: it can only change when the
> > +	 * pageblock is complete -- either fully free in zone buddy
> > +	 * (Phase 1 claims) or fully merged on PCP (drain disowns).
> > +	 * Since we hold this page, neither can happen.
> > +	 */
> > +	owner_cpu = pbd->cpu - 1;
> > +	cache_cpu = owner_cpu;
> > +	if (cache_cpu < 0)
> > +		cache_cpu = raw_smp_processor_id();
> > +
> > +	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
> > +	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
> > +		if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
> > +			free_one_page(zone, page, pfn, order, fpi_flags);
> >  			return;
> > -		pcp_spin_unlock(pcp, UP_flags);
> > +		}
> >  	} else {
> > +		spin_lock_irqsave(&pcp->lock, UP_flags);
> 
> Hm was it necessary to replace the pcp trylock scheme with
> spin_lock_irqsave() here?

It's beneficial.

Before, this would only be contended with preemption; the trylock was
needed to avoid a deadlock.

After, we can have contention when freeing to a remote PCP that's
busy. But giving the page back to that owning PCP is still the best
destination for it. A trylock with a zone buddy fallback means a
zone->lock cycle now AND for a single page AND increases the odds of a
zone->locked refill later (since that page leaves the PCP economy).

What *might* work is an llist on that PCP, leaving it to the next
successful PCP holder to drain. But that means more work under the
pcp->lock on the allocation and drain side, so it could be a wash.

