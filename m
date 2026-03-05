Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157E0F3D319
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 15:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B816B0005; Thu,  5 Mar 2026 10:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4293B6B0088; Thu,  5 Mar 2026 10:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C3C6B0089; Thu,  5 Mar 2026 10:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 247916B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:58:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB8641601DB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:58:41 +0000 (UTC)
X-FDA: 84512467242.04.612B522
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F09D10000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:58:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rp0LBweu;
	spf=pass (imf14.hostedemail.com: domain of 3LqipaQgKCHkgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3LqipaQgKCHkgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772726320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3V7M4a9Y5QPWB0hu53eAcqPdtXJEAUrJLWxVZTKOBw=;
	b=DKEhAPS++cDfOOiy7ZWnOR7Hh/nXNWRlH1laLR4lQbTw6DJgPEINNrCnfhvCLB9EFOwR6/
	zqH2v3w/kLAYzCfGO8KMzwZv2DVe/ZZvg5nvth6H9TV8SLCpcmibh7PjOLJtRSk60aBIc7
	3MWVC9K9a+btk7jjzGAC6ulW1bWTZYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772726320; a=rsa-sha256;
	cv=none;
	b=YVXf4C7WlZ5oHWAXh7oFEOBzwUPXcD1EcsOA4flz8AcpBwTExkattYiJqDFyf4rW1HgQi0
	9uJLToRq7h+q0OwF5dU1rsYLcrnZQWSEnvjagpFTWuePbik4WphJN+JipBbIs0sJM2fY9X
	fHyvY9CWro9ZyBCBjP5+LwJzEhzzTSs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rp0LBweu;
	spf=pass (imf14.hostedemail.com: domain of 3LqipaQgKCHkgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3LqipaQgKCHkgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483a24db6ecso99219975e9.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 07:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772726318; x=1773331118; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k3V7M4a9Y5QPWB0hu53eAcqPdtXJEAUrJLWxVZTKOBw=;
        b=Rp0LBweukYWY2wPACYpXBAdJ8F/UQPdzxGo26DuNSkkSH9Ba7EkKIyidEf/yKw3CZ2
         FjZ6cwxBcKLluFigZVD4WfduyY4x3woDmePQbd9g3EiGA42RANSZ1AwfxPb11aIGkNpA
         i154pfwEjC+0gozqnjxjR1KncOaLb9QiZqn72FN5Ykj55M76vLmeJYZWGALUMGVxKmHO
         zziwDbEYXsMaWZoufR3Pfob+WAvJi4QUgJ8oZ/g5+eVf0pQEDruNJuKkDB6hwyG/PsS4
         SSkryEOok4Qes5v8IAKqudE96Z7aV8dhmcjedJQYQhHJ+9jByaZTT9DpJUcPnsprOgRr
         /VEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772726318; x=1773331118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k3V7M4a9Y5QPWB0hu53eAcqPdtXJEAUrJLWxVZTKOBw=;
        b=Fr2sJo8RbEFdpqVXTHeC8F7jECv4jmu7V9nSp24jrOFKHykSOaWiD5tCLG6Ch3xs4y
         EOMMoS1cdLU5aBQ6kYK/ho2b74c1vGh1XABNcBhwiSZiKY8yjazAl8so37pNVtg8i1D8
         ts9ojQFOIoeu+14gVMahdG4BVNd9i072AIDnjhBa8X3JV+J/o3Bcnh7ru/T7+IYFqr9W
         8zsz/E4oIlMIqtGr4Gt2TROkxQeVF1OOX9mUcz4kictCaA+9C/yzf8lOTxay7CoXsTJG
         sCCWuL1/6iQzQcO3LvgCygFm0LIpZiuniQ8LnpeKulT0OSkkd0nyhTSHAWn8xnovONDQ
         Yktw==
X-Gm-Message-State: AOJu0Yyka8HpYtMWt4SNHKjDI6EsvAbo3RugXdGeHo8iRKIeGjiAa0D7
	h5f4frnZhUWRSBEVHtBQFp/4YSrRTQ9TWoj9b2eKd8UF7NTwQXgGN3L7TKJqESwarZx4CxrMtYg
	aRJYt7074BcJcmQ==
X-Received: from wmbg9.prod.google.com ([2002:a05:600c:a409:b0:483:7827:ade4])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34c6:b0:483:71f7:2782 with SMTP id 5b1f17b1804b1-48519855f27mr113892325e9.12.1772726318086;
 Thu, 05 Mar 2026 07:58:38 -0800 (PST)
Date: Thu, 05 Mar 2026 15:58:37 +0000
In-Reply-To: <daac1fce-e3a1-4be3-a016-ca0fcfc5f851@arm.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com> <daac1fce-e3a1-4be3-a016-ca0fcfc5f851@arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DGUZ17MAFAMD.30IHZ1KYDRM5E@google.com>
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F09D10000D
X-Stat-Signature: bfhom61nap4pynp4mijbd1ppt8ttynhw
X-Rspam-User: 
X-HE-Tag: 1772726319-747141
X-HE-Meta: U2FsdGVkX1/HK/ZAlU9sEpKLzleqnMLMLNXLAaHZRqst3Y7Vb9gSMwu+L+GvO+E+BOdK4RABPqV5EIOCsUCzlgApLRS/5qoFY304YpgzdBsbV72Cjhv2xSkwxs/w0A0elvN4Ty2Ll8vTzrWxejM76YWFIWooFJ1qlGIErMyfxFn+rWAKi3zW7mz8OFiBjdDp242iMClSFHC7cfRPAcxQfl11rzDYaV+NOUkfHJ9/aXRUBlDIneqKHKKcjWcr5qNrhmbvFLjbgrrlCGKEKgNcANGHCZLBIwjb5UweBse/ZAKJm6iTTenm9AUXhFJQmjTiaZ3HpPpzfMDNwd3AXJPVi+mb03nqwyvypnKiE3temi13PJ82/awneDBZ7+Fqi1IXdXG5sUPeeckOSpF+K/3yIDKbmp+w0Lnp2L4nYCS39MYUhmIafnR8Vv3hEx9pwpS9XWMd7W+YLZ9WB8zMG6ie6Ie3W3oYkrGMLKX5sDgKjBCsHUP0rUPzF5GtqWw4YnVEYpsLQujw0pT2yqg5jEIvKT8I6FU4h7z1P6naU8/QHBKPPmbkrEr2rgCV1b8WqobZvV7aC7j23TPCx7Z2Mu/slMKSK8G7J/JQ4iNCjZcRe80nXnSjNEaSbFZqjyBNbbN4dtyNOaWImknyoN7JKpuHevjKPQYUoCi0ul38U/yR7W4/W5qNKOQnLWSLlK5TYPSy2/tc5xyyInTbm3Qw2HH5KIZFXGbY3gShy0s/nfZpFlpTL83h7XOJL0+pGUq13AJyyctIZ8arl5VAdqxuDi5zs7GkoSqjQIJxYJ/XTuZzfuuL4GQKJkB2hnf/md1NjXj8tKuncmLf0+RHU6ewER5Y4RA0ci2xbfBCyEd7/qItGU2sXkUQE6WEt1nZNUPi1qRkoRJVfkW3zhGAuL/WhEmF/0jzIq0/pm0o9wuUVK2hRvR2gpJEm1ez700fvvftjNkVEPAgGUmw13G+2GhC+3x
 faEw+wFJ
 dDIA6ex2zcbcKfzcKYWSYFIpmXt9eghI2GRiO9EneI+FtXuUHzO1R+1BHZXnGpw8BeoDnGpKmay2xvTzh3/4fRYpH43slh4MTZxXRyiCK0FzjZ67bqQ0B1oQQtx/NvvJKsnl7oWR7KWfhKucLiQ6M9snhQ9gWNlhH1Ku/y7lHS927JFFqx/+mng7I3eG3XBFiOyk8Bj67tkLEs+zM//loK4FnSyrvwpRcwQN5ZUItXmb0++kTbK1LRpyZxaAuOXDa2Cr16PKFsCuG2xR7NNsvQjbsnrogckGIg7J+GpUEEr2xZ1zKDcFhfsAbomJ6JVxMLXVcZ08cQ3cyNI6rNlk95YW1r0HVNqBZMqRMg+fnWMTxzihX6uognYcc3CQTAT7DJxz6ejIGKmdI4At+afZf7O1uBdajjTqNegZL3iIrH8x3avHwzgFjIHMlHoXItNqa0Ixgwa6hH2vEYDJmrAiMFQPgI8GMbnwaJ9j1OtCsUU12Hxj5z0vgTKItgY0/GIWudnfJg/VJM3Mn9xksmvevtKX7w3lUO9pp+/g0CUImGMCHixDZ+rLdbJ5vCUR3tlUb9OLCVAi0J2jHzHbR0VcTzZmm96v5OqS/un1q2khtHcQWJHLNu198glFyRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Mar 5, 2026 at 2:51 PM UTC, Kevin Brodsky wrote:
> On 25/02/2026 17:34, Brendan Jackman wrote:
>> .:::: Design: Introducing "freetypes"
>>
>> The biggest challenge for efficiently getting stuff out of the direct
>> map is TLB flushing. Pushing this problem into the page allocator turns
>> out to enable amortising that flush cost into almost nothing. The core
>> idea is to have pools of already-unmapped pages. We'd like those pages
>> to be physically contiguous so they don't unduly fragment the pagetables
>> around them, and we'd like to be able to efficiently look up these
>> already-unmapped pages during allocation. The page allocator already has
>> deeply-ingrained functionality for physically grouping pages by a
>> certain attribute, and then indexing free pages by that attribute, this
>> mechanism is: migratetypes.
>>
>> So basically, this series extends the concepts of migratetypes in the
>> allocator so that as well as just representing mobility, they can
>> represent other properties of the page too. (Actually, migratetypes are
>> already sort of overloaded, but the main extension is to be able to
>> represent _orthogonal_ properties). In order to avoid further
>> overloading the concept of a migratetype, this extension is done by
>> adding a new concept on top of migratetype: the _freetype_. A freetype
>> is basically just a migratetype plus some flags, and it replaces
>> migratetypes wherever the latter is currently used as to index free
>> pages.
>>
>> The first freetype flag is then added, which marks the pages it indexes
>> as being absent from the direct map. This is then used to implement the
>> new __GFP_UNMAPPED flag, which allocates pages from pageblocks that have
>> the new flag, or unmaps pages if no existing ones are already available.
>
> This approach seems very interesting to me, and I wonder if it could be
> applied to another use-case.
>
> I am working on a security feature to protect page table pages (PTPs)
> using pkeys [1]. This relies on all PTPs being mapped with a specific
> pkey (in the direct map). That requires changing a mapping attribute
> rather than making it invalid, but AFAICT this is essentially the same
> problem as the one you're trying to solve.

Yeah, I think so:

1. The fragmentation issues seem exactly the same.

2. The TLB flushing issues are probably also basically the same, I
assume you need to flush the TLB when you convert a page to use for
pagetables, and without allocator integration that can happen pretty
often and in hot paths. Correct?

> There are however extra challenges with mapping PTPs with special
> attributes. The main one, which you mention in patch 17, is that
> splitting the direct map may require allocating PTPs, which may lead to
> recursion.
>
> [1] introduces a dedicated page table allocator on top of the buddy
> allocator, which attempts to cache PMD-sized blocks if possible. It
> ensures that no recursion occurs by using a special flag when allocating
> PTPs while splitting the direct map, and keeping a reserve of pages
> specifically for that situation (patch 15 and 24). 

Right, and actually just today someone pointed out mm/execmem.c to me, I
think execmem_cache_populate() is basically doing the same thing
(although it's also creating a separate virtual mapping).

> There is also special
> handling for early page tables (essentially keeping track of them and
> setting their pkey once we can split the direct map).
>
> Do you think that this freetype infrastructure could be used for that
> purpose, instead of introducing a layer on top of the buddy allocator? 

Yes!!! 100% definitely, my code certainly solves all your problems...

> I
> expect that much of the special handling for allocating PTPs can be kept
> separate. Ensuring that protected pages are always available to split
> the direct map may be difficult though... This is deeply embedded in the
> allocator I proposed.

...Oh, hm, well, um, good point. Thinking aloud a bit...

The way this series dodges the question is (copying from the code
comments in patch 17 for convenient reading):

1) - The direct map starts out fully mapped at boot. (This is not really
 *   an assumption" as its in direct control of page_alloc.c).
 *
2) - Once pages in the direct map are broken down, they are not
 *   re-aggregated into larger pages again.
 *
3) - Pagetables are never allocated with __GFP_UNMAPPED.
 *
 * Under these assumptions, a pagetable might need to be allocated while
 * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
 * allocation. But, the allocation of that pagetable never requires
 * allocating a further pagetable.

In other words, we might need to allocate while we allocate (which is
fine because I have to do locking shenanigans anyway due to x86 TLB
shootdown requirements), but there's no further recursion after that.

Can we come up with an analogue for protected PTPs? Point 3) is
the inflexible one, and we obviously can't say "PTPs are never allocated
as PTPs". But if we invert it and _also_ invert point 1) I think we get
something that works in principle:

1) The direct map starts out _fully protected_ (i.e. we treat everything
   as if it's a pagetable at first).

2) We assume the direct map doesn't get reaggregated once we've broken
   things down to serve PTP allocations

3) PTPs are always PTPs...

But... this is a bit silly, since what it means is we'll then go through
~all the pagetblocks in the system (except the ones that _are_ actually
used for PTPs) and flip their pkey, breaking down the physmap to
pageblock granularity as we go. And... if we're gonna do that, we might
as well just say the physmap has to be at pageblock granularity to begin
with.

(Could we do that? Maybe - Mike Rapoport has previously argued that
physmap fragmentation is not a very big deal, so I guess the question
is whether we're ready to really lean into that analysis, it would be
quite painful if it turned out to be wrong).

Another potential "dodge": Is it really important that the PTPs are
always protected from the very moment they are created?
Coz this feature still seems pretty useful even if there's an awkward
fallback case where, under specific memory pressure patterns, we
temporarily use unprotected pagetables to set up protected pagetables.
That still makes exploiting a pagetable overwrite an order of magnitude
harder than before, right? Similar to how there's probably ways to
exploit bugs if you can get them to race with the intended pagetable
update paths that flip the pkey register, or if you can get a ROP chain
to flip that register for you or whatever.

