Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA489C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724AF6B0125; Mon, 17 Aug 2026 20:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5E36B0126; Mon, 17 Aug 2026 20:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5786B0127; Mon, 17 Aug 2026 20:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31DEC6B0125
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:55:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBDD6C09E1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:55:58 +0000 (UTC)
X-FDA: 85112573196.30.CDEA312
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id ED5A140005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:55:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAnFOCrs;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787014557;
	b=QO4c3o4gUn79PuCWS3vf4s//Sj02FORWiDPXYze2HBVoyiEvsT578PfI3sxGLig3YD8xm4
	nSf+RBKnE0n/nUFPTkglOLDL0AuBXgyXEJTv4RRnsR4LuStUfiuUZdeg9fa7Duy2PSZ6Gm
	3I6EKOBTPKYPqzmKR+DECA9iA20AlWo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAnFOCrs;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787014557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=822anQ6V2pFJxV3J/pyPbt95JgcT2z7Mv+mmnIRM7r8=;
	b=o2/ykes3mHLElMB/v/pbmzPDk+wA553keyg22yN0INcb1I5EYNxnmval3NnVZu1T9LKya3
	L8x8glLmfvJxC/xvvVn4e+hYPFHLiIGqvpzOuSUyhKvpIelufzXCmuCOuoN+t2CGHoEKns
	jQ+rKtAilPUSGRwoZxwaUigQYl92XQ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CB904385C;
	Tue, 18 Aug 2026 00:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C6D1F000E9;
	Tue, 18 Aug 2026 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787014555;
	bh=822anQ6V2pFJxV3J/pyPbt95JgcT2z7Mv+mmnIRM7r8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BAnFOCrsGbiqPxHNFDh7Jz+59C0+i4VzYx81GlGcvUPCXQA147o1RyrY6zkHm3gZo
	 aOzZXDwQTvpT/rUMI3rclVQ2hC/JkKRE3mvai2Yah9wEl1YR3JBWp4GCp5mfloGBPQ
	 sbCliKRfy//ez30QQY2/TWKmP7MX9pH+39oUQMxIIsoLjuni7Y3tIk1jHUTg/f4xOO
	 alW+BOe54vyfNArwWgE7JIankDSzbso4yXZrzv2VO3bs4JdKdlUg9SM43aoFaXIjwK
	 4hzrwpsP5yRdtp83CQWr5sgfgdjwkkG1vcfIKIpPxqwKDsCZLQ5VDDdZJ/u1G751WG
	 d2T8EALaKBTuQ==
Date: Tue, 18 Aug 2026 00:55:53 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
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
Message-ID: <aoOsiMyfWbkCbV8F@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJ45UK0MWvskzlK@google.com>
 <DKPL6YQLP6NT.1747A5QR1D8VH@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKPL6YQLP6NT.1747A5QR1D8VH@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED5A140005
X-Stat-Signature: p9kz5qji47otqxhy5me6c7m3qieaktrg
X-HE-Tag: 1787014556-230793
X-HE-Meta: U2FsdGVkX193txugzP8jAUF19UbJRN8BtTjbnxQgxF5PbAytse4CAiNcGSJ/Y1D3l3o0leJxulit+iJEDwWRtK74ECgPPH0tNTtYty4aUymR4Qa/+yUfybkHKvYCO49hjShqcy3jPBWXVTrU7aC6v80PpVlD2YZPync97Oat+s3i5CtiZTa1vVpllSbkeVP2rbUkU6UXZlgqs23sflSIMEzrvq33MgH/79mywhf8iz7uj6p68Wu2JntO0kLJl2slhKwgayPB2pTyXDOqMQ6ysD2OmvKxUvxqZ0SU1pAcQpZdAGmO5t5nKbV9cZmVntW6f0PgtM5lMCo0zpGLTeInO/9SLh3RsxXgYkYFP2myXBrSimAowlq9rtk/mdVc+FMpTN7Rpzr/r8hd3CqpLxEiL/k5eQlNGR8alVkPH6TA7ePy0qS9JljLMzrX9dKDKTpVqJzYvVYNkRaWLx57Np9RjIHknreECxikS3cr1woS7oFZ1Z6r39SOq66s7S+XuKu8N2e3QIQ0z/spQ7idPHhVWGCgJGbPg5lFnIpFJFwJqeHnmRk5BpWn/5OxA8xD/fuMGmsys34PFaXpX16jDfyI1nl3txBg1Q8SSvcNBF1ZQSfWtU+D2u2f/A17GeTI43x9xofMwj0tMs5Ez6R+sMFakuiNyHpkaaRam1bcp5yxruo4on5/5rogDw9jLczmzwCx4chEND9dKXi/Yi40vU+olvbEra76Nuo++vzkr5zFpT12NAQxoEKUE0WivV/QerVTII9np/qc8g2MFloV/+K2j80Royh6eV74HYFT3IQpGjlOJmKmefKk1y0Vnmdsg28+4TebuP6K0bn8dmJYBgAhpHd76O/aGsKSzLEyRAQvkHV8u4F4SQJFcnzUlpyPIp1FU5KvAQDWIgTai+Md3yb9RRJ397nGwS6W5Uk+uT4LJ5GEu/n5r3y0VY2MWrU5T8TIdH2vnSYa2k0gbCJn5E2
 mdFq9NKT
 IjIP9Re8cRbIoExCLk2mxg7sKh8+q/2KksBp6tVveT/bZ697FVdH2on7fZlFeG/zx3kc55WNh/k5ON7PO7zExrK/GPb9wEXgP790QjZ/J2CKMu+/lDNQhxVeXV/GaDBhaNdyFnCGNq6hHc0SNo4lEE6vWKP/55FSBefW9l07sDoMYiE1llcRGafB7Tx41hSw1VdQyZKlqRDwmVzcsIo86IuGf9SDNef6E4M9XmgYU69tVPBCDWRnYPhubfrCCFxAj/P733VI3VzHZEKee8INeELvy8DdTQ7CrHW0BEI4ZPhGLU9soHz0hUdbXcFxgy+W3ujfg2M6rSQ+VE3KnV8D3+b9H2JmC6KINSML2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 03:28:26PM +0100, Brendan Jackman wrote:
> On Wed Aug 5, 2026 at 12:53 AM BST, Yosry Ahmed wrote:
> >> @@ -3400,6 +3426,127 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
> >>  #endif
> >>  }
> >>  
> >> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> >> +/* Try to allocate a page by mapping/unmapping a block from the direct map. */
> >> +static inline struct page *
> >> +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
> >> +		     unsigned int alloc_flags, freetype_t freetype)
> >> +{
> >> +	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
> >> +	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
> >> +						  ft_flags_other);
> >> +	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
> >> +	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
> >> +	unsigned long irq_flags;
> >> +	int nr_pageblocks, nr_freed;
> >> +	struct page *page;
> >> +	int alloc_order;
> >> +	int err;
> >> +
> >> +	if (freetype_idx(ft_other) < 0)
> >> +		return NULL;
> >> +
> >> +	/*
> >> +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
> >> +	 * safe if the caller holds a lock (in case the other CPUs need that
> >> +	 * lock to handle the shootdown IPI).
> >> +	 */
> >> +	if (alloc_flags & ALLOC_NOBLOCK)
> >> +		return NULL;
> >> +
> >> +	if (!can_set_direct_map() || alloc_flags & ALLOC_NOLOCK)
> >> +		return NULL;
> >> +
> >> +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
> >> +
> >> +	/*
> >> +	 * Need to [un]map a whole pageblock (otherwise it might require
> >> +	 * allocating pagetables). First allocate it.
> >> +	 */
> >> +	alloc_order = max(request_order, pageblock_order);
> >> +	nr_pageblocks = 1 << (alloc_order - pageblock_order);
> >> +	spin_lock_irqsave(&zone->lock, irq_flags);
> >> +	/* First try a block that already has the right migratetype. */
> >> +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> >> +	if (!page) {
> >> +		/* Fallback to changing a block's migratetype. */
> >> +		rmqm = RMQUEUE_CLAIM;
> >> +		page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> >> +	}
> >> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> >> +	if (!page)
> >> +		return NULL;
> >
> > IIUC we only try to change an entire pageblock here, but what if we
> > can't? If memory is fragmented enough that many pageblocks have few
> > unmapped pages in them, how do we serve a mapped allocation (e.g. a slab
> > allocation)?
> >
> > We'll go into reclaim/compaction, but there's a chance we'll end up with
> > unexpected allocation failures or OOM kills even though we have free
> > memory, because unmapped memory is not movable or reclaimable (as of
> > now, at least).
> >
> > The same could happen if many pageblocks have few mapped but unmovable
> > pages in them, and we make an unmapped allocation.
> 
> Yeah, although just to be clear: those unmovable/unreclaimable pages
> are _already_ un{mov,reclaim}able, ALLOC_UNMAPPED doesn't change that.
> So in the situation where they prevent compaction, we were already
> somewhat in trouble re memory pressure. It's just that, with
> ALLOC_UNMAPPED, the allocation failures can start hitting us for
> lower-order allocations whereas before they only mattered for
> higher-order ones.

I think that's actually a big deal. Especially for kernel allocations.
For example, allocation failures in the reclaim path can be pretty
detrimintal. Higher-order alloactions are usually expected to fail in
some cases, but order-0 allocations, especially from the kernel, are
assumed to almost always succeed.

> 
> How much worse is that? I'm not sure - my understanding from working
> with GCE people was that if fragmentation prevents allocating hugetlb
> pages for guest memory, yes in theory the system can fall back to base
> pages, but in practice the perf hit from doing that is intolerable, i.e.
> successful higher-order allocations are basically a hard requirement in
> the real world already. Is that unique to GCE or are other workloads
> like that too? I don't really know :/
> 
> The OTHER thing, trying to see this as zoomed-out as possible, is that
> the "unmapped pages are un{mov,reclaim}able" thing is hopefully very
> temporary? I'm pretty sure we want at least compaction for guest_memfd
> [0]. If we extend ALLOC_UNMAPPED into any other areas I also expect that
> to be the same. Secretmem is... well, whatever. So I think the "real"
> fix is to support compaction.

We'll still always have unmovable or unreclaimable pages. Even with ASI,
some userspace memory may be pinned or mlocked. The fact that some
memory can simply be un-allocatable by the kernel is.. scary, especially
without watermark awareness (see my other response to patch 24).

> 
> [0]: https://lore.kernel.org/all/20260805-shivank-gmem-migrate-v3-9-00d8bdec4e1d@amd.com/
> 
> > I wonder if we still need a fallback case where a pageblock contains a
> > mix of mapped and unmapped pages. We need to carefully handle such
> > pageblocks:
> > - For unmapped allocations, we need to unmap the relevant PTEs and
> >   potentially do a TLB shootdown (if they were previously mapped). Maybe
> >   we should always flush the TLB for simplicity for now.
> > - For mapped allocations, we need to map the relevant PTEs. No TLB
> >   shootdown should be needed.
> >
> > Assuming unmapped allocations are always zeroed by the users on alloc
> > and free, we don't need to worry about zeroing pages either way.
> >
> > We may want to track the number of unmapped pages in such page blocks to
> > now when it's fully mapped or fully unmapped and change its type, but
> > maybe this can be a followup if needed.
> 
> ... However, yes this might be unavoidable despite what I said above.
> This was also DavidH's feeling when I chatted to him a few months back.
> The hard parts of it are a) the tracking as you hinted at and b) in the
> general case that means allocating pagetables. 

I am considering a simple-ish scheme to avoid per-page tracking and
potential TLB shootdowns in the freeing path (which prompted async
freeing internally).

What if we just always map pages in such tainted/mixed pageblocks when
they are freed? If they are already mapped, nothing to do. If unmapped,
we map them and zero them. No TLB shootdown required.

We also shouldn't ever need to allocate. If the pages were previously
unmapped, we should have already allocated any necessary page tables.
Right?

Zeroing on free may still be bad, but not prohibitive, and hopefully
this is only a fallback. We'll need to figure out where this fallback
fits (e.g. before or after reclaim/compaction).

> 
> So yeah I think it's probably doable but I _really_ want to avoid doing
> it in this series if we possibly can.

Yeah I am trying to figure out whether the issue is theoretical enough
that we can do it in a follow up.

