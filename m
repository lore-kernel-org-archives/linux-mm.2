Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287CBC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BC9A6B007B; Wed,  5 Aug 2026 12:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293F76B008A; Wed,  5 Aug 2026 12:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1A86B0092; Wed,  5 Aug 2026 12:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF8456B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:13:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89E9B1A053E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:13:46 +0000 (UTC)
X-FDA: 85067711652.01.5CD6586
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC1DB40010
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:13:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LwE9Ssc7;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785946424;
	b=DFeyTXEEZzsPtcHeX1e8a7a/2amxzGBynxRZ7YmVYOA9pWXjIubfZ32O33V51SqabzfYJx
	nH+4HwyCtK8halryxUkn3ozzaqM21SWsMLWZpxk5hlxUa6IF7mmOBce9oQ/aJjh8eIuLHz
	1xvfN+Y5Wnt+60XfvrtEV0evKOYpZJI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LwE9Ssc7;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785946424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eYBpoqNwloACWjZhH6XeQ0/8lHsE54iws5L+x+3vnY=;
	b=nJBwOI1A21jIpWu94YfR56NE5veLh4VJyw8Q/NeXqVDTzvtDDRroBEaB30N1+xoDF5najh
	fOzeJJ6IyquKX811itRk2drf8q/8fa17sNEQZXzTrDZpwyoNo+mTIwf+ms2uPEf3J7JpAn
	t+pQTPQOUW+Qk7Qozcz2B70dYqAU8g0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D93EB60A8A;
	Wed,  5 Aug 2026 16:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71AE1F00A3A;
	Wed,  5 Aug 2026 16:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785946423;
	bh=/eYBpoqNwloACWjZhH6XeQ0/8lHsE54iws5L+x+3vnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LwE9Ssc7FnrWv0iWaiX/6hQWqrsO+oocgsIWD/UZN5mviHYAiMmdgSg7Vdhavv/3Q
	 orZ+q8XnbVBCW1meEcof+2ZpBDXvgf4GPII9PTvga0APIW5qjbD4k+hrkyDGMSQlTp
	 TTYjiZLYMPDJHTeHaaXyE0bHVmDEL0KbI6GbDskZwiCRMIBiN62syi3812rgklkRXt
	 Dv5FiBWDniQaQ34oqAeDRqPgW9DJ8DXUBQJQn3ewTnittTOS9tz4D8yMqN1EM/qPel
	 xzI4dHXOgWkY/kJwF7Y0uyrHtJ7QsGrRCxyMdSAq9LsXBF99eIsd/GUImGmMeX2bfn
	 GC7wEb1P24kaA==
Date: Wed, 5 Aug 2026 16:13:41 +0000
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
Message-ID: <anNhEOvuI8wuExjW@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJ45UK0MWvskzlK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anJ45UK0MWvskzlK@google.com>
X-Rspamd-Queue-Id: CC1DB40010
X-Stat-Signature: jxpe7wza7b6dn41f16769wmf6pnsoojb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785946424-30336
X-HE-Meta: U2FsdGVkX1+FGXBwaFE+gniVDk6Rfzfhm9suKOZjug4rs9QkctCF6sn2gWzxkNde7ALOGGTf+na/1UkxmwRpm1Z30M8K9JPlVtp6bl4fJNPY2WzuvLUl+Q5y2pK2N4n+fZj4Cif3YNb8Mthn5MvUzX34ktG7rIYXGxUBtIDEDEjePuJdyReBhZcO6a0K5a7/RRtQ28oz9sA6ZAqCjHv/Tcmot5xW5bWPFDzdscuezDMSSCz/G+0PW8//SiR+4aGX/uAKqIDUD3aLu8T07Qy47ZTFHSwXXsA3qzvwuREGhNb26oE21rBwrhjyN9DS5jXCwN9eBQK9KwOFsd2V/BTm/GOl3+WLdsYJc2gl0K0eldyA2sUczeQNf8L5yncrbi/iNvaXfKyPd81ml3uaxsINs76YrtOO1+3MtwHo4RVDSzHvkrKphxati6pVq8LurkAcpGqpBLHqbS1Qb1Aql7cSavRH+d1ddnSpDyHeaa8xvxEmfnDuXpkkTvlw8dOLjmzQB4/lSbDeGR6I+HKGpbPo7rKhkOis+t14RClrb4KQ1E81ABJ9h6ku3hHw5qDWsBYGCbhhIUeSDju6OVu+htz5ZdgVZijLDSGqyw/nEBbte4oP/gld4BFusyCLxw0GKwCVCgbW1C58yLlHheIcac7itiRq796ExjCWl4XKbGza2fNjpIhaW6ypXf7KcpaELUTAIAtjakaynGwCd31P+/OFGZEF6pu8Ie9uqrIo/f+GOOMOV++kKvq3tWfNkl0OoWs6cpJMBa4SRjIogMys0oSlj9kGGoRDtxRUGRpCWOOcFbdAgQC6addPo/VoGMuNUf/EZhKEXzXZGLNE3TofeBSYpeR02+w/Sy29k8vnbSxi6YAsgEBa3bbiLnONLEqhPLu9IrJCQM3FLSDCHIWkpRe09dkDpVZ0dcD9Swomg13+Jy7MYagUsE6c6wwtegED/DjpRlGQM4HaclIzdC7AW9+
 dEXF4c2X
 i7Kr7UuHWX8uocxJeCqObq7kbIBNGqWNdd/TUtpFi8Dqocrint2dBbGTq/Poy1mgIxWLx4k+a1N5ySF4iqZbq8TFhqPYk01wXnXBhyGw338QTVxXzrzD2DIdF4qp+r39PyJoXRqR+MdBgMMK8ruuackJf+4fVlEZwriIFpGcSpx944K56yoIbfj5IP3mlLcR0ChakzRjvH3EvGHI3MxbtYJIkBrmM95VFkwwf9hgd1e6Sp7byDOg29nPaLlBlEf+vgMr+jMTUafblTmZSmC6XIKqfMnyl0FiDrw0wn9fTeBJrQXtrbSyYop54XchV/RKbrdA6uOfe3LBxnhSGGipmURWP46B96BT3PBiRokoy0/ka7fkBAsBL5qLqDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 11:53:18PM +0000, Yosry Ahmed wrote:
> > @@ -3400,6 +3426,127 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
> >  #endif
> >  }
> >  
> > +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> > +/* Try to allocate a page by mapping/unmapping a block from the direct map. */
> > +static inline struct page *
> > +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
> > +		     unsigned int alloc_flags, freetype_t freetype)
> > +{
> > +	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
> > +	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
> > +						  ft_flags_other);
> > +	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
> > +	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
> > +	unsigned long irq_flags;
> > +	int nr_pageblocks, nr_freed;
> > +	struct page *page;
> > +	int alloc_order;
> > +	int err;
> > +
> > +	if (freetype_idx(ft_other) < 0)
> > +		return NULL;
> > +
> > +	/*
> > +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
> > +	 * safe if the caller holds a lock (in case the other CPUs need that
> > +	 * lock to handle the shootdown IPI).
> > +	 */
> > +	if (alloc_flags & ALLOC_NOBLOCK)
> > +		return NULL;
> > +
> > +	if (!can_set_direct_map() || alloc_flags & ALLOC_NOLOCK)
> > +		return NULL;
> > +
> > +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
> > +
> > +	/*
> > +	 * Need to [un]map a whole pageblock (otherwise it might require
> > +	 * allocating pagetables). First allocate it.
> > +	 */
> > +	alloc_order = max(request_order, pageblock_order);
> > +	nr_pageblocks = 1 << (alloc_order - pageblock_order);
> > +	spin_lock_irqsave(&zone->lock, irq_flags);
> > +	/* First try a block that already has the right migratetype. */
> > +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> > +	if (!page) {
> > +		/* Fallback to changing a block's migratetype. */
> > +		rmqm = RMQUEUE_CLAIM;
> > +		page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> > +	}
> > +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> > +	if (!page)
> > +		return NULL;
> 
> IIUC we only try to change an entire pageblock here, but what if we
> can't? If memory is fragmented enough that many pageblocks have few
> unmapped pages in them, how do we serve a mapped allocation (e.g. a slab
> allocation)?
> 
> We'll go into reclaim/compaction, but there's a chance we'll end up with
> unexpected allocation failures or OOM kills even though we have free
> memory, because unmapped memory is not movable or reclaimable (as of
> now, at least).
> 
> The same could happen if many pageblocks have few mapped but unmovable
> pages in them, and we make an unmapped allocation.
> 
> I wonder if we still need a fallback case where a pageblock contains a
> mix of mapped and unmapped pages. We need to carefully handle such
> pageblocks:
> - For unmapped allocations, we need to unmap the relevant PTEs and
>   potentially do a TLB shootdown (if they were previously mapped). Maybe
>   we should always flush the TLB for simplicity for now.
> - For mapped allocations, we need to map the relevant PTEs. No TLB
>   shootdown should be needed.
> 
> Assuming unmapped allocations are always zeroed by the users on alloc
> and free, we don't need to worry about zeroing pages either way.
> 
> We may want to track the number of unmapped pages in such page blocks to
> now when it's fully mapped or fully unmapped and change its type, but
> maybe this can be a followup if needed.

(I should have probably mentioned that this was surfaced, at least to
me, an internal discussion with Junaid)

