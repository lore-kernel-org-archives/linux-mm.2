Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753F7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3036B0088; Thu,  3 Sep 2026 11:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453BF6B008A; Thu,  3 Sep 2026 11:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343616B008C; Thu,  3 Sep 2026 11:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08D896B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:46:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B32214059F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:46:29 +0000 (UTC)
X-FDA: 85172878098.08.FEDA1C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE179140012
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:46:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrsSshXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvtuy6huBs7QxtTxtr9G7+YTzTpQucZ/JdRFZvmmlOU=;
	b=7VP/R4lV8/vG8sumdcv2GYYJnuGj2qC+ybe0FPJ5YciWJ2CXfBXibp0NC4SqCD0+YbeATH
	g2qMHHlzSKI982+xoWa4IaFRhW3XoML2KPmANlkkGhj4zMdZH8PyZx2J4IN97lgjB15cTm
	K8KnEdPNFmQ+YyC5TYRE+I7QlMGNV+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450388;
	b=4G/hMf3UT9kPQWQqyyk00RppNJCaFzivyFnxmpmWoXcTDrJRnPcNWL0dUzVO3QvWP645zM
	XGvnUWbN4FY/ma472L/TugzkHriXBg6HfRGae6hflQWlMbhad0jN0Wd5lBQwBI4l6gbOh/
	m5XYljaXGvjdzqgutmJbiEQLIF3jdBE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrsSshXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7466560A54;
	Thu,  3 Sep 2026 15:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9591F00A3F;
	Thu,  3 Sep 2026 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450387;
	bh=bvtuy6huBs7QxtTxtr9G7+YTzTpQucZ/JdRFZvmmlOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LrsSshXHnCWaUcDt77DVY1qL1MfXSWLZCXdVUI25lmldx1Lz7tj9UI69Q5vnukpJK
	 em9BoxtW9nmH0Wwh3xNg3V8Y0NLsqz/1sxeYKXnGEejJSvFdoSXMHXKlJZ7tLca64p
	 0neBXfVW5sBqrgzdyyscV42oMZ9RpSxH/pYvMS13YCFiWu7PWfHZB0AajbVXkoJAGN
	 0l2NJmv3GL0Tj4+42k87hN/kR54sOeR0nh73vSKFpAHvrD3p+xLM0RD3mAv09n0hwb
	 gJRLPoRag0TiwxIpPTny0N7lpY8aQHRTOV1S2BExqLu1G5KcFH3+1U1px9lTdbRM8E
	 ZgDkbKpaRd9fw==
Date: Thu, 3 Sep 2026 16:46:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aplzo5Jsb6f1MdaM@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
 <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902183752.GP3004@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE179140012
X-Stat-Signature: kzkbtycn7xgp4wtdrbxyysnbhxp9iogt
X-Rspam-User: 
X-HE-Tag: 1788450387-965628
X-HE-Meta: U2FsdGVkX19o5EDlxT4HEAvX5Mh81x5iZGuFUIfyDPLlExCSo1MnJw7uq7+XIivZQLyMw11OX7WD1px78jl0O0BKLuMVG7LZIy+D5nwfI3WDgcpYOXPfx5al0+SHEKlxBFq9EK1HwcPn4IUQ92r+orFnDmB8qsiI1jtHrgsJ9spfCJ33iApVX8yOMZmZglGV+HtO2g3W3S/JphB9jfzd/rVHmKRX/c+JKYTGIZ0KhqeKAKTFYYyO6nBW2EpUmZPDR04o68Y8bFCtL0Tgjm6gKZOo9pDWuTaDdFgc4izXMBbwZD5cwW6KR2qiqBXOP0KTsoFR4and3oGHPXX/nJMqxgFWJ673SN2O4BAChAIhhJBZnxXugNzoyvA7GmjVKIvLJBdQ2cDnWqkjSUiyQei1090Zq7kv93k352czsLlOugjAXZ0MI94lDq9634Rq8pa7U46yf7HHQ7eEdW4G7v761sIn9QsmPMPzD1NNL1VfiyhsCT4am9JAYL2gE74ZhXeYin0zL06z+fq+frK5qNZSvOzLfTetTmkCC7Aa190SCuhEPfzrEclUA49j5mU4cwt4XGHUJxlkzd6/wxYPOvij7bRrYhQkwVM7qG1prLvD+tMgtxrAsQPqmIs92DIWmJsNNzppiQkJjgSUGHQj+jPolVO3QCgZg/xxGvwM+97bRdtYtsDCM9VVCgCDoTTG8UOd9GkXadBa7+ugSazxOgDepu7iUBaAVyfeu8s0c0NTMjIcJoa26m6EcQkVLE0/6zO0LIZWs/GB9WfIJB+VEHrxZ0GHIeDjtyqV+mzY1CrYXgowcGwgQIOXw/uwhZ23hrFtBGec45/m2xppHWVTLCJgrEEMoDFYSy/ULeZzWFSi2dExOP/4qZZn4KB+e3ynhQ61aFR1kEqtgtQv1Tzg05Fk8eh5VcBTefLxLTtd5Aa4jgD8nxbWH71JrU3crH+h9tOaHjq/2dVkxQf6rNBSH4d
 07bwezVk
 0BoDnQfA9zDzYjJI8ZUzyN/5Mp+FZh5zLZWEPcqjmJ2haGk6vIoDoRr9g9t/hDpTSs18d/yLVNB/ual3kp8BiLhFBitXjezAs5kCAGKuRNlGcP1pWuTE7h6Qk49KIe18PnDnG3QI30gYefEFrrhMCVYYEOY9k5eo0nfhUqWr4HQ2QMwb5FBOJo7IjhOO7c5RFfMje4K4MkJEpPK2vbDakX4MLTEO/fZm2+wRUA60gnY//PIGq04Ndt/LZhxVMC0I9/yg5PDVIaBIhkNCaS62ftuBiUAwVd794BnKDZ1XNx7V8Dv9fmRvTri9/+skRr45CQHBM74SYCAazNB4xEzdPbRFTRCJLrAk3ESreuc8YEsdlMnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 02:37:52PM -0400, Johannes Weiner wrote:
> On Wed, Sep 02, 2026 at 06:00:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
> > > Just to summarize my take from the subthread with Zi: the premise of
> > > this patch is to roll the regression dice on every THP setup out there
> > > because certain ARM configurations result in a questionable pageblock size.
> > >
> > > I'm not against carefully evaluating and testing out today's need for
> > > set_recommended_min_free_kbytes() in real world examples. But this is
> > > not that.
> > >
> > > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> > Well you don't have to listen to me any more as ex-THP M ;) but my 2
> > pence...
>
> I'll always listen to you, Lorenzo. <3

<3 ;)

>
> > Isn't every possible change to address this kind of issue subject to
> > exactly the same kind of constraint?
> >
> > I'd like to know what not rolling that dice looks like :) or what
> > constitutes 'careful evaluation'.
>
> Usama gave some great examples in his other email. I'm not really
> arguing to keep things out of tradition. But I think it's fair to say
> let's at least test the common 4k/2M THP setups under memory pressure
> before and after the change. Or be more specific about which changes
> obviated the additional pageblock reserves, and how.

Looking over the sub-thread (correct me if I'm wrong) the issues seem to be:

- 512 MB pageblocks become unmoveable quicker than expected

- When trying to convert a pageblock in try_to_claim_block() 256 MiB is required
  to be of the desired migratetype, and this is difficult to achieve vs. 1 MiB
  (yes clearly :)

- AI training checkpointing was a problematic workload - big latency spikes and
  timeouts. Tonnes of unmoveable memory, order-0 allocations falling back to
  MIGRATE_MOVABLE (ugh), exhibiting try_to_claim_block() symptoms above.

I hear all of this, and to be clear - this kind of real-world data, at scale, is
the kind of thing we should base decisions on more than anything else.

Reality > theory every time (and the more you look into the kernel you more you
realise it's a tower of heuristics anyway, especially in classical reclaim :)

I guess what you're trying to say here is the only way in these circumstances to
make headway would be to have more memory reserved.

But is that the right conclusion? Aren't you still screwed once those reserves
are chomped up?

Or are you saying the increased watermark levels gets you effective
kcompactd/kswapd sooner?

The TL;DR for me is - you have a workload that's broken already with larger
pageblock size - maybe you could test that with/without this patch and see if it
really does help?

Anyway it seems to me all of this is essentially a (valid!) critique of
assumptions backed into the page allocator code.

Which is again what I think about this change - we need a short-term fix of
_some kind,_ and a longer term fix in compaction, page alloc, reclaim.

>
> > It feels like in certain areas we paint ourselves into a corner where
> > everybody's too scared to change anything until we're sure nobody in the
> > world is broken*.
>
> I'm fine with calculated risks, actually. A bit more surprised that
> Michal was so readily on board with this :)
>
> > And so we continue to ride the merry-go-round of proposals/rejections
> > indefinitely.
> >
> > All the while regressions in tip kernel are a regular occurrence (yes we
> > don't want that, but they happen), and they are resolved as they arise.
> >
> > I wonder if we aren't limiting ourselves by thinking this way.
> >
> > Michal's proposal was that the original code was written _long_ before
> > improvements in the compaction algorithm and fails to account for those.
> >
> > It seems odd to retain the same constraints given the rest of the kernel
> > has changed.
>
> That's a great motivation to take a closer look at whether we still
> need it. I'm not attached to anything that's plausibly shown to be
> unnecessary.
>
> But I think there are levels of argument quality:
>
> 1. This code is old as in time
> 2. This code is old as in the surroundings have changed
> 3. This code is not needed due to sha1, sha2, sha3 supplanting it thusly: ...
> 4. This code is not making a difference in represenative tests
>
> The patch is at 2 and I would really prefer we get to 3 or 4. That's
> not the same as saying we should stop making changes.

1 nearly always implies 2 because computers become radically different over
time (cache hierarchy + latencies, memory model, I/O bandwidth etc.)

3 feels like a totally different category - there's just no heuristic in mm
that would match that.

and 4 I think is the crux of it - we lack any such agreed-upon
'representative tests' and I fear that getting them might be an impossible
problem (TM) as people will argue endlessly about what's representative and
what's not.

(I'm reminded of discussions at LSF about MGLRU and how exactly we decide
classic vs. MGLRU - Kairu had some nice ideas - but it's another of those
'will we ever agree on this?' situations).

>
> And honestly, while we tend to claim we want 4 for everything, we're
> happy many times to roll the dice at 3 - iff the story is specific and
> plausible. And I believe that touches on your footnote ;)

I really feel 3 is a different class of problem. When would that apply to a
heuristic?

>
> But let's talk about plausible. Because I'm reading what
> set_recommended_min_free_kbytes() does, along with its comments, and
> can't help but think that this still applies in the current world.

Hmm really? The calculation is:

	min_pages = nr_zones * nr_pblock_pgs * (2 + MIGRATE_PCPTYPES ^ 2)

But __setup_per_zone_wmarks() does:

	tmp = min_pages * (managed pages) / (total lowmem pages)

Looking at an x86 box:

dma    3840	<- give an extra nr_pblock_pgs * (2 + MIGRATE_PCPTYPES ^ 2) pgs
dma32  592222   <- give an extra nr_pblock_pgs * (2 + MIGRATE_PCPTYPES ^ 2) pgs
normal 15682190 <- give an extra nr_pblock_pgs * (2 + MIGRATE_PCPTYPES ^ 2) pgs

So you end up with 6 * nr_pblock_pgs + 3 * MIGRATE_PCPTYPES ^2 but 96.3% of
that goes to ZONE_NORMAL, which is now arbitrarily bumped up by a factor of
~3 for... what reason? And dma/dma32 get tiny fractions (more understandable).

So that definitely doesn't make sense.

Many arm64 machines only have one zone and solve things that way, but
that's effectively by mistake (the algorithm says scale by zone irrelevant
of further scaling).

And then the arbitrary 5% rule - it's mostly irrelevant for modern systems,
and a 64 KiB page size system is likely to run significant RAM (my 16 KiB
page system with 352 MiB min_kbytes would need < 8 GiB to get capped.

So I honestly think that sucks too.

And also - MADV_COLLAPSE can get you THP _even with all the
/sys/kernel/mm/transparent_hugepage knobs turned off_, i.e. with no
additional reserves. So turning it on/off on based on the knobs seems
broken in itself, at least partly.

I guess Michal can expand on why he feels that perhaps even the
nr_pblock_pgs * (2 + MIGRATE_PCPTYPES ^2).

Now that's not to say the non-THP heuristic isn't open to scrutiny too :)

>
> The compaction aid is/was always incidental. Yeah it would suck if
> that is/was (still) an implicit dependency, but ridding us of that
> could be a more deeper-reaching change than you would want to make to
> fix that pressing reserves issue with 64k pages.

I don't think it is incidental?

How else do you get huge pages under memory pressure? It feels like
compaction + defrag are intimately linked to THP.

>
> The fallback avoidance reasoning OTOH still seems cogent to me. The
> mechanism it references is about passive fragmentation avoidance by
> giving the allocator placement options, before compaction gets
> involved. That makes sense in how I understand page_alloc.c today.

See above.

I guess we have to answer whether the heuristic in
calculate_min_free_kbytes() suffices vs. set_recommended_min_free_kbytes()...

That's not to say we couldn't just change calculate_min_free_kbytes() to a
sensible heuristic.

I guess the v2 hard cap wasn't desirable, but since the heuristic already
caps regardless of the rest of the arithmetic maybe:

- Cap to a hardcoded max reserve value [v2 of this series]
- Cap to a bigger % of free memory?

Are short-term options here?

And on the 'changes are outlandish' side of things, well the vast majority
of users are at 4 KiB base page size, 2 MiB PMD - so maybe we could retain
the exact same values you have now in that case, and get experimental with
bigger page sizes?

Would that then carry less risk in your view?

>
> > Perhaps a compromise would be to put the ability to disable this behind a
> > config option or maybe a kernel arg? Of course that becomes something of a
> > uAPI... but at least it gives the option to constrian this for those who
> > want it.
>
> I can't force you to engage with the idea of capping the pageblock
> instead. But I'm still kind of dying to know what the reluctance is ;)
> And I apologize if I missed any prior arguments on this specifically.

Because fragmentation avoidance, compaction and the highatomic/boost reserves
are all at the granularity of page blocks, so a PMD spanning several pageblocks
is not given any help at all.

The underlying problem is that "THP == PMD" is a fiction at 64 KiB.

A 512 MiB PMD is not a useful default unit, so both the pageblock size and
the reserve derived from it are sized for something nobody wants.

You can't have it both ways:

1.  Complain the defaults reserve too much on 64 KiB while THP defaults to
    madvise/always for a 512 MiB PMD you'll never use, with no effort to set mTHP
    sizes instead.

2. "Fix" it by shrinking pageblocks below PMD, keeping the reserve whose sole
   purpose is PMD THP allocation while removing its ability to serve that
   purpose.

Really the issue is that actually PMD THP is _not_ the primary need here. For
most normal uses at 16 KiB page it's dubious at best, at 64 KiB page size it's
ludicrous.

What we want to do is to stop treating PMD as the unit-of-measure everywhere
instead of hacking stuff in. Kiryl's work on THP promises us this.

(Note that it's not as simple btw as saying 'oh mTHP is available for 64
KiB page size, let's reduce reserves to scale to mTHP sizes' - you require
mappings and alignment at PMD size even with mTHP, so it's still useless :)

We want to account for the fact we want defragmentation for:

- PMD THP at smaller page size
- mTHP
- page cache large folios
- drivers-wanting-higher-order allocations

So I think the long-term solution is to stop pretending and to do this.

Also we have this weird thing of CONFIG_TRANSPARENT_HUGEPAGE gating large
folio stuff in general.

Oh and as noted above MADV_COLLAPSE can get you huge pages even when all
the knobs at /sys/kernel/mm/transparent_hugepage are switched off - so
_without_ any additional reserves :)

I feel the short-term solution is to attack the issue where it exists - the
uptick in reserves taking a pragmatic approach. And long term the above.

Anyway a request:

can you actually run the problematic workloads with and without this patch and
tell us whether you see a meaningful regression?

Let's get some data for this :)

--
Cheers, Lorenzo

