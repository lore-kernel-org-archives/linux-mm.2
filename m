Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8102C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DD86B0121; Mon, 17 Aug 2026 20:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDDB6B0122; Mon, 17 Aug 2026 20:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913DB6B0123; Mon, 17 Aug 2026 20:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C29D6B0121
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:49:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02E58A2AA9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:49:37 +0000 (UTC)
X-FDA: 85112557236.18.C432E6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 48C831C0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:49:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1DrblM9;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787014176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClssdD91oq/MStCE+y61oU2BRmlqfB32tzgOC4Y7hqg=;
	b=iulRJo28dDCGuwlZ1iW9vzJ4pn2Ru/2FuX/luDTX622Zia47ahedVT9tJ+nNQQhvrS2b8Y
	ujKnX5Icc3Tdol8SjIp42EJK+Xtfu3tlmtk3LSyxEV+5sYzObUTLNpbBEWJrbkQzRHVqYF
	pf5icEAtxlsZFYvXBnnrF+OStsMfYZo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1DrblM9;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787014176;
	b=GQnZCafAd6ihG27fwxqqXxQHH5J91o5UyeBWK4nSPv+PC4fKtyKMrVfQb4dFEwyfbIEWUc
	JWEG+AVV7jDxxOgQ3MPpxdeyLSYhEkr30JU+024sLHWqIFx2zGJW/hBlXd0XQB0MhQk+PF
	8bKvRjv7n/ijebA5ymkFK6COtMtJopI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6700240760;
	Tue, 18 Aug 2026 00:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611391F000E9;
	Tue, 18 Aug 2026 00:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787014175;
	bh=ClssdD91oq/MStCE+y61oU2BRmlqfB32tzgOC4Y7hqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1DrblM9L1RfFyBf5bUrSxDMsRf+HElRT4kC8IeYcvkT/zoJrLYvtavyFy06hjGBz
	 UNR7SuVQ/5buJCqkwKcb8ZfuL9eynueKEWfpQoKcrFz4R23NpSVzIGfyXOFvmMhK0c
	 70RcXww3NH4HutBf4jd3Rn+6wsc3/f7odF+ZGjO7U/5kFThgp0SnYmWLfk+V4GVRfn
	 xFAcEWahrFxTUXdKW4uoqWyNxyyvqOjo9caGfW1jR/Tfy31if8nJRbzEklGNY3rYbT
	 eYCpM7sMJ4EDXArPIr3ESoor6yxjq5DeXsM5EtRxzaBSjazHpMOE+/jz562nCe8P7O
	 WWLUeO7qv1M2g==
Date: Tue, 18 Aug 2026 00:49:33 +0000
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
Message-ID: <aoOrrgLgW53etM5C@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anzinNUA6ZASDnvA@google.com>
 <DKPLICBIHQMP.2HPKI7JZXSUFV@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKPLICBIHQMP.2HPKI7JZXSUFV@linux.dev>
X-Stat-Signature: dpzpnjsjoduzdepco4xu87qp5sfnkxqw
X-Rspamd-Queue-Id: 48C831C0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787014176-990444
X-HE-Meta: U2FsdGVkX1/dkrieFyLpnLUr+MKO7Q5P3//w8hD5BzlC1gUh6//qSVFXFYTpXZnkRUWrgskjRwzPjzxivgrbK6tTpnJ8snVGIo5U0uH/oER4vEVw1qWHb8+n27gMTfOa9n1A6SZCrhn3RZ2QkKp/5xd7WDQLVMEfx+MHgQibfJO4fWqH2O0xYW5F5qDYiUYBY+4yHb5VQp4YdqR6SqsU3hdoozNDExrbaJGgw3hhKe6Nyj0vci5mVuO9xSVRaeahEniTg+/KMZZEpy5ILe6c76R+smzemTrFeOdibjKmC1qgWeL+5yZkwck2ckBYa9Lm/s6KbkPK9NuIu2EQ8fUmk8yk6C0/yhck2Eq4EhHygYz99O2SrWbSqSq4G2YB+RyPiSLKLQ4KoCQCBEPs0F9shfv2+OmxWWjm05DCc0aQK1qd0SufBNeW9+MtBIr4vMyb1CldM5K9zqiCszRDlG16w8/vOKlBFx+piEGjskrigB0xHW/A0ekIF328x6hL4Ss1FuBUHHvUY24vtB3I4vFA3ELNuqX/VglZpZb3RIfkTAniZ+gyjcFt1gXkOIUdAe/FcvDfetAzQZ+JawmDvcl9oANZWfLep/jsD6wQ8NmYzBKKo0/SA4adKxvfG4LfGO5QvZfU1XE8eyyz97QYFi9spul6OUzrjukpLN1VBX6gDXxtBxlJSDx4/EvXRE520JaoaK1V3n1yt8oJ5jOVvDVUuZ0jS7F2BvkZ/MfhRSVOhpkaj2pc9B6ttPyZPbJDOzYO33HLksqO8cJMVaOFCjjXUBtfKQhAYWYOCudhBAcT7x9fRmlehYEJHoP96aWO3Ssby2pSEHf/8oonkljXNG1/HZxZHa9IRGMdmoMu3/9E1qfxP8JaWc88GvpUXp/eShEbnrny+jw150lrV0DbQKmzW03taD/08m6xTAhJHSZpqRj4CgWGt/cc4b2Hs0jW5sfxNkrDRlsAgPXNoumEqZn
 SimqETSD
 i/iA7WSA0HtENDcC4NXOxOcN6ONE+yicTBqqsNI6EpV1Xy8ZG8wDhYPsIg65kn7r1a2bFQmhtxmo9kdG4mOzJISuT0tbIgMxUfEI+CFxpBjfrJShHJG5/w+X6HBXTuA4HMwmabv0BJf8bScgAfiasQK22ApP5eiLpWc/lN/avokBSxrsaGjD9JTiTDZpZgzicqxdZapIH2qVWmgXU772ig7p8s4Kj+7Wq0j/lR8eaLhJufCBG/uYvl+2ZCm3JxeAJHj2tm798XqHbA4RcIHk/OexN0F3AzPbuPjRsGPEzv1Lx86WQq04Wn3Ejm4apD6LwMY95oc2BisNbxgC4jhbySjmztw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 03:43:18PM +0100, Brendan Jackman wrote:
> On Wed Aug 12, 2026 at 10:26 PM BST, Yosry Ahmed wrote:
> > [..]
> >>  static __always_inline
> >>  struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >>  			   unsigned int order, unsigned int alloc_flags,
> >> @@ -3433,13 +3580,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >>  			 */
> >>  			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
> >>  				page = __rmqueue_smallest(zone, order, ft_high);
> >> -
> >> -			if (!page) {
> >> -				spin_unlock_irqrestore(&zone->lock, flags);
> >> -				return NULL;
> >> -			}
> >>  		}
> >>  		spin_unlock_irqrestore(&zone->lock, flags);
> >> +
> >> +		/* Try changing direct map, now we've released the zone lock */
> >> +		if (!page)
> >> +			page = __rmqueue_direct_map(zone, order, alloc_flags, freetype);
> >
> > Is it intentional that this is called outside __rmqueue() and doesn't
> > cover pcplists refills through rmqueue_bulk()?
> >
> > IIUC, we will never change a pageblock to unmapped to refill the
> > pcplists, so the unmapped pcplists can get filled in two ways:
> > (a) When unmapped pages are freed.
> > (b) When a pageblock is converted here (in rmqueue_buddy()), if the
> >     allocation only consumes part of it, the new allocation might move
> >     the rest into the pcplist through rmqueue_bulk().
> >
> > Does this mean that unmapped pcplists are less effective in serving
> > allocations? There is a tradeoff here because converting a pageblock to
> > unmapped is expensive, so maybe this is the right choice to make, I am
> > just wondering if this was intentional and/or if we tried it a different
> > way.
> 
> Yeah I think this is all aligned with how I envisaged this working. I
> have been assuming that changing pageblocks only happens:
> 
> 1. When botting / changing between different kinds of workload.
> 
> 2. When the system is quite distressed by memory pressure.
> 
> I think in both cases, proactively flipping a block just to refill
> pcplists is unhelpful?

I guess it depends on what context we refill in the pcplists in. If we
are already holding the zone lock it might be worth a refill to avoid
holding it again to do it later? I am not sure. We can probably punt on
this until we have numbers.

> 
> > Actuall, THPs are not covered by scenario (b) above if the pageblock
> > size is the same as THP size, as the converted THPs are always consumed
> > by the allocation, so the THP pcplist will only be filled when THPs are
> > freed.
> >
> > I wonder if this would cause a problem for THP-heavy workloads (e.g.
> > guest_memfd using THP, or any THP usage with ASI).
> 
> And again it doesn't feel right to proactively flip a block just to
> create a pcplist. The cost of a pcplist miss is basically a bit of
> cacheline contention while the cost of flipping a block is pretty high,
> it seems well worth risking the former to avoid the latter.

Zone lock contention can be a big problem. But yeah we probably
shouldn't make a decision without some numbers.

> 
> > The other thing (that I probably mentioned elsewhere) is that kcompactd
> > does not produce unmapped pageblocks, so it seems like THP allocations
> > will mostly hit this code path and convert a pageblock to unmapped.
> 
> Yeah, I think making kcompactd produce unmapped blocks is a nice
> standalone optimisation series and it can probably wait until someone
> has a workload they can share the performance improvements from.

Yup.

> 
> > Actually, if we do bulk conversion to unmapped (e.g. in kcompactd) we
> > could batch the TLB shootdowns as well, but that should probably be done
> > separately.
> 
> Oh, that's a good point though, coz that would also interact nicely with
> pcplists. In theory we could allocate several contiguous pageblocks,
> flip them with a single amortised flush, and then use that to refill
> pcplists. But yeah this still feels like far future optimisations if and
> when we actually knew it helped.

Agreed.

