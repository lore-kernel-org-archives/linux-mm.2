Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A267F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45CA6B0096; Fri,  6 Mar 2026 07:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23856B0098; Fri,  6 Mar 2026 07:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90E06B0099; Fri,  6 Mar 2026 07:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC3A6B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:31:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46F3F1A0583
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:31:26 +0000 (UTC)
X-FDA: 84515573772.12.69A0F18
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3676E1C0010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:31:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4NZoO0TaH3hdYVkJJEqp2KwRAzSltEsw1OyozGtr6DA=;
	b=Io9XxlJhIYfuO7liD9mMlWovBOObA2CysUfKizGfb5xDHIUVAaVO9Wc4lAcOq6fWpjiVab
	AeUXdNhuemiziG0JQEiTX48QcYq6zvSnC7T/F5neLLtXPgx66sCbKumYeOsUvN6z3gRElf
	tqSostAlN9vA73pGJdzaQJnZGU3TphY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800284; a=rsa-sha256;
	cv=none;
	b=5RrwSuOJsHYhLHJL7SOMI5wOMgfCB6yyZHQJDkf/LiM6zLfvLc3Kni75prhxsFhG/hVB5v
	R18A4VvzLTsrnq3+ECgbxCEbKNMbZK4oGeW3G0vba4CjaTCKgpfnkO3QzbJQRCX+aWLWNZ
	HIOIei+VSTPDJx3oMed8mY4GUZx7loI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E396F497;
	Fri,  6 Mar 2026 04:31:16 -0800 (PST)
Received: from [10.57.57.141] (unknown [10.57.57.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 257313F694;
	Fri,  6 Mar 2026 04:31:17 -0800 (PST)
Message-ID: <d6db1cc9-6df5-43d7-92b3-bd60707d9538@arm.com>
Date: Fri, 6 Mar 2026 13:31:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
 <daac1fce-e3a1-4be3-a016-ca0fcfc5f851@arm.com>
 <DGUZ17MAFAMD.30IHZ1KYDRM5E@google.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <DGUZ17MAFAMD.30IHZ1KYDRM5E@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3676E1C0010
X-Stat-Signature: gu45h4rtra1tgcss77ocqr9xrpwcuga6
X-Rspam-User: 
X-HE-Tag: 1772800284-671482
X-HE-Meta: U2FsdGVkX18BO4Nz+0G/gyIdocnXxHgrM5MBfbF6wW5ri6NviyJt8U/5yFeBfTXxipfsc5M8xi3U2MC7QAdfUZIxLfHo60mmlewH0B/MfcLUODRpCwY9kikJuMovmDIGaUnvlvivwwP2vBH6yP13/whmBgqSRDhNCdm/zdp/4flgZHych92lRDHiyB4mmpH9rmel0ABBiwIO8XyQjECCuxlAT6EhhoVYIu9SbpY1CBDeUS1cjjUXm+4kcsZdCjfRTOdvAIqBZE5mt41nJXmaLv2pLBMYTkoAOCCIio0cCuDZqRwfALIG2BWnubYG3JDXFMudLmxZN8X1OEO5A4tjI/RKULbmbJbOMwOaT8z7j9z6XMNkpVH6csx5XJytS8/rzUQfIM37yTpm4EWoGbYic9pZE9gShO33KgTjBFOTkehRKLjzHnzfu1IY6GoIfBqzxAQrm9p2hu8Pct5DUimenDAL3+SfddOYBOn8Mn+p7ZwxfrkhaeaScl2Wo3YtUIxoLgfP3zp9XC4f87bD8qgkGYERsnQHx4vcEpJVlPivzfiJfbVlRM6gimi5SNDvd3390RxPo/aZ00ze/2VrIuUXVPJkfhjAVYLBORW6yTLTrw+z32pyAj/Zf98qqCXXfpJAr7CONGSgTu2AL4SqQfwX22NLJxokMXo/cTz/ScvcegoxAGP50oWmt4noytx+1cuekx7zoVYWB/gvRIXWvQj494Kwto67Ua/Rt3CH6KOIKcoMhit3Nw6o3mq3V+Dzw/UHZ0+4NYnaKv5iunE4r7sTbnfo/03w5v14+YQgWRLkpUPyyjeGKBuwbb/4z6+0gFGrh1I484tBN4MpVT7lbb7zs2wBedPW3iTb5m1j4QU+UOG5+AbqCR51LbI0OefKAeXxl3TCgMhE5vbISHe+XsbsNH58tnVA6CMJhnAzmSKbMVZbyUnSuB3HCc8wXA/zgcEjAjxkYFW2IskQiWrMy2z
 Q/FwYXzO
 XH+H6ue33xv1qIYLquqU41gf24n7l+NYKqr35Qw0OJIcsVamawcH+/ndSwe1WfanDJ526A1Cqt+SVEIfPPkbg4DPjEOweXRIXQCMHIN56/aKPxfdBz/csV+r3P496IiF7eWn30S9z4PmzwHPdB/5Vbz9h4pfiY0F0JUDD2EKX7qB4JhRprbsYOjizuihZEsqL0vxXUA3YZBWX3poDC675bi+/mfCd501kj6AbNJkedp3Eh6VxrtVbOnkVgPlaWQVd1EbeuHINgAHIhluQBzXqEA6t3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/03/2026 16:58, Brendan Jackman wrote:
> On Thu Mar 5, 2026 at 2:51 PM UTC, Kevin Brodsky wrote:
>> [...]
>> This approach seems very interesting to me, and I wonder if it could be
>> applied to another use-case.
>>
>> I am working on a security feature to protect page table pages (PTPs)
>> using pkeys [1]. This relies on all PTPs being mapped with a specific
>> pkey (in the direct map). That requires changing a mapping attribute
>> rather than making it invalid, but AFAICT this is essentially the same
>> problem as the one you're trying to solve.
> Yeah, I think so:
>
> 1. The fragmentation issues seem exactly the same.

I believe so.

> 2. The TLB flushing issues are probably also basically the same, I
> assume you need to flush the TLB when you convert a page to use for
> pagetables, and without allocator integration that can happen pretty
> often and in hot paths. Correct?

Indeed. Up until v5 [2] no special allocator was used - the pkey was set
at the page level every time a PTP was allocated or freed. Clearly
suboptimal, and doesn't work at all if large mappings are used due to
the risk of recursion.

>> There are however extra challenges with mapping PTPs with special
>> attributes. The main one, which you mention in patch 17, is that
>> splitting the direct map may require allocating PTPs, which may lead to
>> recursion.
>>
>> [1] introduces a dedicated page table allocator on top of the buddy
>> allocator, which attempts to cache PMD-sized blocks if possible. It
>> ensures that no recursion occurs by using a special flag when allocating
>> PTPs while splitting the direct map, and keeping a reserve of pages
>> specifically for that situation (patch 15 and 24). 
> Right, and actually just today someone pointed out mm/execmem.c to me, I
> think execmem_cache_populate() is basically doing the same thing
> (although it's also creating a separate virtual mapping).

Ah interesting I didn't know about that cache. It does have
similarities, and the motivation seems similar too.

>> There is also special
>> handling for early page tables (essentially keeping track of them and
>> setting their pkey once we can split the direct map).
>>
>> Do you think that this freetype infrastructure could be used for that
>> purpose, instead of introducing a layer on top of the buddy allocator? 
> Yes!!! 100% definitely, my code certainly solves all your problems...

Almost ;)

>> I
>> expect that much of the special handling for allocating PTPs can be kept
>> separate. Ensuring that protected pages are always available to split
>> the direct map may be difficult though... This is deeply embedded in the
>> allocator I proposed.
> ...Oh, hm, well, um, good point. Thinking aloud a bit...
>
> The way this series dodges the question is (copying from the code
> comments in patch 17 for convenient reading):
>
> 1) - The direct map starts out fully mapped at boot. (This is not really
>  *   an assumption" as its in direct control of page_alloc.c).
>  *
> 2) - Once pages in the direct map are broken down, they are not
>  *   re-aggregated into larger pages again.
>  *
> 3) - Pagetables are never allocated with __GFP_UNMAPPED.
>  *
>  * Under these assumptions, a pagetable might need to be allocated while
>  * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
>  * allocation. But, the allocation of that pagetable never requires
>  * allocating a further pagetable.
>
> In other words, we might need to allocate while we allocate (which is
> fine because I have to do locking shenanigans anyway due to x86 TLB
> shootdown requirements), but there's no further recursion after that.
>
> Can we come up with an analogue for protected PTPs? Point 3) is
> the inflexible one, and we obviously can't say "PTPs are never allocated
> as PTPs". But if we invert it and _also_ invert point 1) I think we get
> something that works in principle:
>
> 1) The direct map starts out _fully protected_ (i.e. we treat everything
>    as if it's a pagetable at first).
>
> 2) We assume the direct map doesn't get reaggregated once we've broken
>    things down to serve PTP allocations
>
> 3) PTPs are always PTPs...
>
> But... this is a bit silly, since what it means is we'll then go through
> ~all the pagetblocks in the system (except the ones that _are_ actually
> used for PTPs) and flip their pkey, breaking down the physmap to
> pageblock granularity as we go. And... if we're gonna do that, we might
> as well just say the physmap has to be at pageblock granularity to begin
> with.

Having to change the pkey of every pageblock when allocating it for
anything but page tables seems rather unreasonable... And in case of
memory pressure, where fragmentation is high, we may not have any
protected pageblock left. The allocator I proposed falls back to order-2
allocations if necessary (which is sufficient to replenish the page
reserve even if PMD+PTE pages are allocated for splitting).

> (Could we do that? Maybe - Mike Rapoport has previously argued that
> physmap fragmentation is not a very big deal, so I guess the question
> is whether we're ready to really lean into that analysis, it would be
> quite painful if it turned out to be wrong).
>
> Another potential "dodge": Is it really important that the PTPs are
> always protected from the very moment they are created?
> Coz this feature still seems pretty useful even if there's an awkward
> fallback case where, under specific memory pressure patterns, we
> temporarily use unprotected pagetables to set up protected pagetables.
> That still makes exploiting a pagetable overwrite an order of magnitude
> harder than before, right? Similar to how there's probably ways to
> exploit bugs if you can get them to race with the intended pagetable
> update paths that flip the pkey register, or if you can get a ROP chain
> to flip that register for you or whatever.

I considered this - I agree that having page tables unprotected inside a
small window may be acceptable, considering that this is hardening and
not bullet-proof isolation. That said, I'm not sure it helps all that
much. You'd need a mechanism to defer setting the pkey for those PTPs.
Once you decide to set the pkey, you may very well end up splitting the
direct map again, deferring new PTPs... This could go on, and every time
fragmentation increases. I think it is really desirable to have that
reserve of pages so that splitting the direct map does not become
recursive (whether deferred or not).

- Kevin

[2]
https://lore.kernel.org/linux-hardening/20250815085512.2182322-1-kevin.brodsky@arm.com/


