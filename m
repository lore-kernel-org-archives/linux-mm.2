Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F531099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F726B00A6; Fri, 20 Mar 2026 14:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6C66B00AF; Fri, 20 Mar 2026 14:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C256B00BD; Fri, 20 Mar 2026 14:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C59EE6B00A6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6872713A678
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:40 +0000 (UTC)
X-FDA: 84567264600.23.964F553
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 72A3E12000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U6Vtg3c0;
	spf=pass (imf29.hostedemail.com: domain of 3qJC9aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qJC9aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iuc/m4FnPQfSpDXrIyg5Pw17GU4sV/qEm/cxkEhEqKM=;
	b=yyaQC9KZ+wnohDTVieXoRCdXdt0bBblGVq0OFpHv8V0ImIFxmxHN5xj1r6Y7WYxTXWTE62
	7CHWtq2l9wWQ9Am8r9qHYLJWwgYGe2KgfGrdPwFWzJngujXp09DWCy3iB3sbYJG8O0Ywkk
	8V3POK5FTHZkEa1D8zMLRjgUMy9tzso=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U6Vtg3c0;
	spf=pass (imf29.hostedemail.com: domain of 3qJC9aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qJC9aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031018; a=rsa-sha256;
	cv=none;
	b=UQZcJWVZjGziGn/9fXHXg0WCE7RTMyirWoGf7DVxtgg9YaTJlm84Z9i/Lov3oxSNn10KhJ
	SN7S1IZe6yyjUWmrbgvhCxUWnWTw0HrUvf0dO1Mkb7tzr5is80zXaanvz1YI6MH5LwnVbk
	bCzGeWWnp2KWdJL/u7ZcLc1CsMwgUaw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fb29a8b8so16734595e9.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031017; x=1774635817; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iuc/m4FnPQfSpDXrIyg5Pw17GU4sV/qEm/cxkEhEqKM=;
        b=U6Vtg3c0BOYJnoaXtwGbVPmDaC1mVmpBzx8SB+c29V4cSvNMfk82hZ9V2ojeaKmIN1
         ZyZglwKCBIa6zu8mmpwPvVAW8PzjFL2mKp+j7Vj6eFjVIwoLJjTD2rMfhd7q3nQB2BSm
         gG7zOOvlTph1qmEEaSRSxVIM8gpOGFyuMwlYPKDgusqSEG8VTOwH0543D8JlByeindP2
         kk2V7IOGyr+vaBYGKYL0Y155KywN1nKVz75GFa7gtvwM5x8/gf54UFNUja7SEAB0iRcL
         0ECJ/z3S8+cHJC1ADeS7hEVr0r+Gzdy1uCfaGEI1avQClnQfrLhIbwLUgzebcIYXWP1P
         hYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031017; x=1774635817;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuc/m4FnPQfSpDXrIyg5Pw17GU4sV/qEm/cxkEhEqKM=;
        b=c9sr8/DFIHj+QVWsvuUPZE2Z4fuC+8L2dohCzZUiuBS9n9oXIwKgiQhCx8rfFc+rXy
         uvFReSPsUl0H4Ez3zkHkdl0EiaHQLw/JLcyDB58RyPJ7qQfOObqQJRO0Hs9afE9v/2oh
         g3MWSy7z9F4eFNMffLTg55/bWVfbC37XP1MVUvwpmGM/tnOqravmuWKsX1n77+r8ZVH2
         A1I4wt/wDrxfrC6X3qcyhdYUXMyfAu4M8kn6vtWjdhyFvlwYss8hcGKw8w4udlgYVKIM
         Rsmyb5y/IliosGM9v1nmuTEt1VMJfOe+/9Cs085RKmBZs6kyAPngdgsUQkOVd7LlYMTL
         /JSA==
X-Gm-Message-State: AOJu0YzPgexhVKv7mN00rTrrQ5ta/4K8d50bZ0kmA8BmLbIvqrIUlkfi
	YvT1dtty1bvoC24SmSlZnldH3sYg+BmOLrkGdd2bWQatTw8AcKIBGDkB4o8JMqw/KO2i7ig67RG
	O+0Ges3nVkv9aqA==
X-Received: from wmjv1.prod.google.com ([2002:a7b:cb41:0:b0:485:37cb:adc1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c167:b0:477:a1a2:d829 with SMTP id 5b1f17b1804b1-486fedc9a52mr59893705e9.13.1774031016463;
 Fri, 20 Mar 2026 11:23:36 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:24 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJ2QvWkC/22NQQ7CIBQFr9L8tRjAgujKe5jGIPxSkhYIaKNpe
 nexbl3OJG/eAgWzxwLnZoGMsy8+hgp814AZdHBIvK0MnHJJGeMkaYc3PY7RkGeYdEpoyaltexT
 2eBfCQF2mjL1/bdVrV3nw5RHzezuZ2df+epyLv72ZEUpQKao0PRgr5cXF6EbcmzhBt67rB6CXX Z23AAAA
X-Change-Id: 20260112-page_alloc-unmapped-944fe5d7b55c
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Subject: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nn369we4idmkxrpy1az9cohhesc44zkp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 72A3E12000D
X-HE-Tag: 1774031018-872765
X-HE-Meta: U2FsdGVkX1/bFF5rX26pwC2te+RcYK5R7uObHfPUaH76mXaAwi3yuzjw6Eu2qYKfEiikkaRV0YmSPT0KhyYILGhw4vcr6av7tvHFcZWNwuxkUQKx6dD4x+HcqpoYJbiDedOib9K6uwuSHVbRpdmZh2xWF3Ke/2/8Ebj73aLn/Dn01kVZw1VTNffVrtKA9L4p0XNlxaTLciW/2zhRtzddRCJQuZhsX88bFAQzXgyLjO4WBO81R1bi+6S0n9sbSRO6BCbtD0KfkTxn8ftBBNd6xh9bQuZte8VG6kjuQ0sbUGnbWq1CXA+s27zqANCY2bydnsXYmQdD3dDak5JCyU467ZJfMWs7WSGV1b/XJAqEkFG7T0drobGk4ffKKgW6nkm5ryC6jj/j0IMVSBZDqX6KwQyZKZXENUGY2QkjO+FqnMHEIxQATROtXUqLYFie0VUT6Xv3jTrECyh5aTU5j+Ms8fHoi96fDB4y24ImtfZ2LkERjhyd7ou5QlHg1V0m5UOIcWrg0PLBEXIQzNkrfWD2toNSBpubNbSM8DgKuO7/T0BDZTP6hG5RD4GaYDceoY49gtjMsLv9trA4zOLKI/P9fFR9m6+B2LolyK+06ENT/TZKgRJZmR2EWqTEG4IXOQ90Fr//sA1lW0MtK3HfFoMC4/RDomKfl/3wth5k/QlAIhXwxqvZ0QIK/274uCqHhWmR9wM8v3L+ItiNrsH7KQBw6SVS721aWcp6ChfpjSZD0Vu0juU+jDEjQD1TkZ2p8rvtayCzddo+4nY34UrDVMCpkTcRZRIAaS9Go4C56bj9HooFo/fQdlLGaZ0T3mJk/T7GLpRMKYeK48z9R3FROzGTtjYiqDDY/KQjtUcFUpVGNMTQ5XLQ81MGzfL8VdKVKIdI0paHqjxa2q5NCYO59yJAxcAfvd2VaMyZH7MCOwnuZB9W9etneeG4BXy8KOFxspExxFHKaA8lssG8ihoyrEo
 72YFwjWO
 EbV35CzVKDXLjIHCWbLs/rhb3ufhbD+zOCB/O7PyAoXOwFcjMHl0oVHMGDkhP2Zwp1LCAyQ7wR15LhuFxLR4u+wyyp5SqFpeE3nvcos1uYNFvMVCl7cEDvYjF6GxVfr4qGTwLmPfTWazZfFUu4hBga0todFnJPywuR+67EfENSS3hXMkH0nyR9wbibn5s56d04BUqa+d7Ul3iXIZzJpFSMaBOmbCciDI5dFmPOSPW2ctbrloshZCKcyPY73K7mYe9ZSg3Wk2hlGmyMqQ7c5ldMcvN64ZnEFINIH6Hz4gAbImHA/dSYf6WS/vKaCpIkYyod2zFIDfCfM66I7yvv5VSgXl+CJhjGEicRgAqeHGetOYRB0NZawzEy+NS4dq1AqDLuwLA0oi4DvNsdV8MmPu+imyV3/MKFPlCOKBmufhF0+WWp/HRd8GF2DmWm7FfnlQVjQdBERgS2coo3j9rUAXEpsoxgPEL62L1Kks9EqEGSNJucFUD0Vfb9BrbQckS1BDGK6RpFLI5tuyGiecdDEZymTAPFREwozLWbDrGiM2ycRseeecde0+Rt27Yj2VZlZDu2h3pnc2SId7UL+a7ed/3SXjqgt80rEVB9ybXlqrp0bVVvlJHNSXCdgeAnoi6UW8wFWD/qKYuIfiBs9F4dI3ViFPysvfrqBSTjCKOtUW+jw54kzRUh7FBUAdQtCHEUXtJQ4a4Nll+ZMLAk7vmBQsfxM4yzzcyIXK8GRR+miBh3ILVacXAjl9JL7bPgl5kvpb0v6kzQT0IZkr3+PL0m61Xyxtz0crIVdIF0sMUenICaMV6MIJ1YZpRR7TG0ZaGyiO6FyJr6ApYTG6xPEFOQbmj0w1gLwAteqMBO3q4dbw4d/zbFFwcXfgFtFvTxwig7Z7fqTZxu2FHq4IhSDH08hhZ7bTiGv9T/W2ez7YfNP97QaJJTpj3lHKtJXzz1CGmN7GLYmX93Yt4Wi7x8aah3eO+Xgx39mTE
 MBC+M9F6
 VJxC4MMg5+i/O4Yxzq3PRnsw7sUDV0k+cpSgqqH1JOCdXYt916+MkyZhjwCzQhdojP2W0C+x2HRL/lGv7cHe1E817QefTfFbbu7kJvYd59CrQTdL1xXt9ai/4eLeKTpg/IHGZqi7Y79CuregNLffQrGq8126mL32GNvLV6DM7ieNDPMStPqP2mxN5FjkBDwr8Mq4lYQiN8YiX3+qNWX+6id0vAqgUt+pL+1aO7ihUIY2jY1+tV8oOk3W9dfeR0r+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

.:: What? Why?

This series adds support for efficiently allocating pages that are not
present in the direct map. This is instrumental to two different
immediate goals:

1. This supports the effort to remove guest_memfd memory from the direct
   map [0]. One of the challenges faced in that effort has been
   efficiently eliminating TLB entries, this series offers a solution to
   that problem

2. Address Space Isolation (ASI) [1] also needs an efficient way to
   allocate pages that are missing from the direct map. Although for ASI
   the needs are slightly different (in that case, the pages need only
   be removed from ASI's special pagetables), the most interesting mm
   challenges are basically the same.

   So, __GFP_UNMAPPED serves as a Trojan horse to get the page allocator
   into a state where adding ASI's features "Should Be Easy".

   This series _also_ serves as a Trojan horse for the "mermap" (details
   below) which is also a key building block for making ASI efficient.

Longer term, there are a wide range of security techniques unlocked by
being able to efficiently remove pages from the direct map. This ranges
from straightforward nice-to-haves like removing unused aliases of the
vmalloc area, to more ambitious ideas like totally unmapping _all_ user
memory.

There may also be non-security usecases for this feature, for example
at LPC Sumit Garg presented an issue with memory-firewalled client
devices that could be remediated by __GFP_UNMAPPED [2]. It seems also
likely to be a key step towards dropping execmem as a distinct
allocation layer.=20

.:: Design

The key design elements introduced here are just repurposed from
previous attempts to directly introduce ASI's needs to the page
allocator [3]. The only real difference is that now these support
totally unmapping stuff from the direct map, instead of only unmapping
it from ASI's special pagetables.

Note that it's important that allocating unmapped memory be fully
scalable, in principle supporting basically everything the mm can do -
previous __GFP_UNMAPPED proposals have implemented it as a cache on top
of the page allocator. That won't do here because the end goal here is
protecting user data. That means that ultimately, the vast majority of
memory in the system ought to be allocated through a mechanism in the
vein of __GFP_UNMAPPED, so a really full-featured allocator is required.
(In this series, __GFP_UNMAPPED is only supported for unmovable
allocations, but that's just to save space in datastructures: the
implementation is supposed to be fully generic, eventually allowing
reclaim and compaction for the unmapped pages).

Because of the above, I'm proposing a new GFP flag. However the only
part of that I'm really attached to is that it's an interface to the
real page allocator. For now I still assume a GFP flag is the cleanest
way to get that but in principle I'm not opposed to
alloc_unmapped_pages() or whatever. Alternatively, there's some
discussion in [9] about how to get more GFP space back, which I'm happy
to help with.

.:::: Design: Introducing "freetypes"

The biggest challenge for efficiently getting stuff out of the direct
map is TLB flushing. Pushing this problem into the page allocator turns
out to enable amortising that flush cost into almost nothing. The core
idea is to have pools of already-unmapped pages. We'd like those pages
to be physically contiguous so they don't unduly fragment the pagetables
around them, and we'd like to be able to efficiently look up these
already-unmapped pages during allocation. The page allocator already has
deeply-ingrained functionality for physically grouping pages by a
certain attribute, and then indexing free pages by that attribute, this
mechanism is: migratetypes.

So basically, this series extends the concepts of migratetypes in the
allocator so that as well as just representing mobility, they can
represent other properties of the page too. (Actually, migratetypes are
already sort of overloaded, but the main extension is to be able to
represent _orthogonal_ properties). In order to avoid further

Because of these ambitious usecases, it's core to this proposal that the
feature
overloading the concept of a migratetype, this extension is done by
adding a new concept on top of migratetype: the _freetype_. A freetype
is basically just a migratetype plus some flags, and it replaces
migratetypes wherever the latter is currently used as to index free
pages.

The first freetype flag is then added, which marks the pages it indexes
as being absent from the direct map. This is then used to implement the
new __GFP_UNMAPPED flag, which allocates pages from pageblocks that have
the new flag, or unmaps pages if no existing ones are already available.

.:::: Design: Introducing the "mermap"

Sharp readers might by now be asking how __GFP_UNMAPPED interacts with
__GFP_ZERO. If pages aren't in the direct map, how can the page
allocator zero them? The solution is the "mermap", short for "epheMERal
mapping". The mermap provides an efficient way to temporarily map pages
into the local address space, and the allocator uses these mappings to
zero pages.

Using the mermap securely requires some knowledge about the usage of the
pages. One slightly awkward part of this design is that the page
allocator's usage of the mermap then "leaks" out so that callers who
allocate with __GFP_UNMAPPED|__GFP_ZERO need to be aware of the mermap's
security implications. For the guest_memfd unmapping usecase, that means
when guest_memfd.c makes these special allocations, it is only safe
because the pages will belong to the current process. In other words,
the use of the mermap potentially allows that process to leak the pages
via CPU sidechannels (unless more holistic/expensive mitigations are
enabled).

Since this cover letter is already too long I won't describe most
details of the mermap here, please see the patch that introduces it.

But one key detail is that it requires a kernel-space but mm-local
virtual address region. So... this series adds that too (for x86). This
is called the mm-local region and is implemented by "just" extending and
generalising the LDT remap area.

.:: Outline of the patchset

- Patches  1 ->  2 introduce the mm-local region for x86

- Patches  3 ->  5 are prep patches for the mermap

- Patches  6 ->  7 introduce the mermap

- Patches  8 -> 11 introduce freetypes

  - Patch 8 in particular is the big annoying switch-over which changes
    a whole bunch of code from "migratetype" to "freetype". In order to
    try and have the compiler help out with catching bugs, this is done
    with an annoying typedef. I'm sorry that this patch is so annoying,
    but I think if we do want to extend the allocator along these lines
    then a typedef + big annoying patch is probably the safest way.

- Patches 12 -> 21 introduce __GFP_UNMAPPED

- Patch 22 adopts __GFP_UNMAPPED as for secretmem.

.:: Hacky bits

.:::: Hacky bits: mermap pagetable management

As discussed in [8], I can't find any existing pagetable management code
that serves the needs of the mermap. I have responded to this with some
extensions to __apply_to_page_range(). Those extensions make it serve
the mermap's needs re avoiding allocation and locking. But they don't
offer an efficient way to preallocate empty pagetables in
mermap_mm_prepare(). For now I think the inefficient way fine but if a
workload emerges that is sensitive to the latency of mermap setup, it
will need to be optimised. I think that would best be done as part of
the general pagetable library I hope to discuss in [8].

.:::: Hacky bits: simplistic secretmem integration

The secretmem integration leaves the mmain optimisations on the table;
the security-required flushes of the mermap areas are implemented via
distinct tlb_flush_mm() calls. It should be possible to amortize the
mermap TLB flushes completely into the normal VMA flushing. However, as
far as I know there is no performance-sensitive usecase for secretmem.
So, I've just implemented the minimal adoption. This will at least avoid
fragmentation of the direct map, even if it doesn't reduce TLB flushing.
If anyone knows of a workload that might benefit from dropping that
flushing, let me know!

.:: Performance

In [4] is a branch containing:=20

1. This series.

2. All the key kernel patches from the Firecracker team's "secret-free"
   effort, which includes guest_memfd unmapping ([0]).

3. Some prototype patches to switch guest_memfd over from an ad-hoc
   unmapping logic to use of __GFP_UNMAPPED (plus direct use of the
   mermap to implement write()).

I benchmarked this using Firecracker's own performance tests [4], which
measure the time required to populate the VM guest's memory. This
population happens via write() so it exercises the mermap. I ran this on
a Sapphire Rapids machine [5]. The baseline here is just the secret-free
patches on their own. "gfp_unmapped" is the branch described above.
"skip-flush" provides a reference against an implementation that just
skips flushing the TLB when unmapping guest_memfd pages, which serves as
an upper-bound on performance.

metric: populate_latency (ms)   |  test: firecracker-perf-tests-wrapped
+---------------+---------+----------+----------+------------------------+-=
---------+--------+
| nixos_variant | samples |     mean |      min | histogram              | =
     max | =CE=94=CE=BC     |
+---------------+---------+----------+----------+------------------------+-=
---------+--------+
|               |      30 |    1.04s |    1.02s |                     =E2=
=96=88  |    1.10s |        |
| gfp_unmapped  |      30 | 313.02ms | 299.48ms |       =E2=96=88          =
      | 343.25ms | -70.0% |
| skip-flush    |      30 | 325.80ms | 307.91ms |       =E2=96=88          =
      | 333.30ms | -68.8% |
+---------------+---------+----------+----------+------------------------+-=
---------+--------+

Conclusion: it's close to the best case performance for this particular
workload. (Note in the sample above the mean is actually faster - that's
noise, this isn't a consistent observation).

[0] [PATCH v10 00/15] Direct Map Removal Support for guest_memfd
    https://lore.kernel.org/all/20260126164445.11867-1-kalyazin@amazon.com/

[1] https://linuxasi.dev/

[2] https://lpc.events/event/19/contributions/2095/

[3] https://lore.kernel.org/lkml/20250313-asi-page-alloc-v1-0-04972e046cea@=
google.com/

[4] https://github.com/bjackman/kernel-benchmarks-nix/blob/fd56c93344760927=
b71161368230a15741a5869f/packages/benchmarks/firecracker-perf-tests/firecra=
cker-perf-tests.sh

[5] https://github.com/bjackman/aethelred/blob/eb0dd0e99ee08fa0534733113e93=
b89499affe91

[6] https://github.com/bjackman/kernel-benchmarks-nix/blob/924a5cb3215360e4=
620eafcd7e00eb4e69e2ee93/packages/benchmarks/stress-ng/default.nix#L18

[7] https://lore.kernel.org/lkml/20230308094106.227365-1-rppt@kernel.org/

[8] https://lore.kernel.org/all/20260219175113.618562-1-jackmanb@google.com=
/

[9] https://lore.kernel.org/lkml/20260319-gfp64-v1-0-2c73b8d42b7f@google.co=
m/

Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Cc: rppt@kernel.org
Cc: Sumit Garg <sumit.garg@oss.qualcomm.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Wei Xu <weixugc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: yosryahmed@google.com
Cc: derkling@google.com
Cc: reijiw@google.com
Cc: Will Deacon <will@kernel.org>
Cc: rientjes@google.com
Cc: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: patrick.roy@linux.dev
Cc: "Itazuri, Takahiro" <itazur@amazon.co.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: David Kaplan <david.kaplan@amd.com>
Cc: Thomas Gleixner <tglx@kernel.org>

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Adopted it for secretmem
- Fixed mm-local region under KPTI on PAE
- Added __apply_to_get_range() mess
- Added fault injection for mermap_get(), fixed bug this uncovered
- Fixed various silly bugs
- Link to v1 (RFC): https://lore.kernel.org/r/20260225-page_alloc-unmapped-=
v1-0-e8808a03cd66@google.com

---
Brendan Jackman (22):
      x86/mm: split out preallocate_sub_pgd()
      x86/mm: Generalize LDT remap into "mm-local region"
      x86/tlb: Expose some flush function declarations to modules
      mm: Create flags arg for __apply_to_page_range()
      mm: Add more flags for __apply_to_page_range()
      x86/mm: introduce the mermap
      mm: KUnit tests for the mermap
      mm: introduce for_each_free_list()
      mm/page_alloc: don't overload migratetype in find_suitable_fallback()
      mm: introduce freetype_t
      mm: move migratetype definitions to freetype.h
      mm: add definitions for allocating unmapped pages
      mm: rejig pageblock mask definitions
      mm: encode freetype flags in pageblock flags
      mm/page_alloc: remove ifdefs from pindex helpers
      mm/page_alloc: separate pcplists by freetype flags
      mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
      mm/page_alloc: introduce ALLOC_NOBLOCK
      mm/page_alloc: implement __GFP_UNMAPPED allocations
      mm/page_alloc: implement __GFP_UNMAPPED|__GFP_ZERO allocations
      mm: Minimal KUnit tests for some new page_alloc logic
      mm/secretmem: Use __GFP_UNMAPPED when available

 Documentation/arch/x86/x86_64/mm.rst    |   4 +-
 arch/x86/Kconfig                        |   3 +
 arch/x86/include/asm/mermap.h           |  23 +
 arch/x86/include/asm/mmu_context.h      | 119 ++++-
 arch/x86/include/asm/page.h             |  32 ++
 arch/x86/include/asm/pgalloc.h          |  33 ++
 arch/x86/include/asm/pgtable_32_areas.h |   9 +-
 arch/x86/include/asm/pgtable_64_types.h |  18 +-
 arch/x86/include/asm/pgtable_types.h    |   2 +
 arch/x86/include/asm/tlbflush.h         |  43 +-
 arch/x86/kernel/ldt.c                   | 130 +-----
 arch/x86/mm/init_64.c                   |  44 +-
 arch/x86/mm/pgtable.c                   |  32 +-
 include/linux/freetype.h                | 147 ++++++
 include/linux/gfp.h                     |  25 +-
 include/linux/gfp_types.h               |  26 ++
 include/linux/mermap.h                  |  63 +++
 include/linux/mermap_types.h            |  44 ++
 include/linux/mm.h                      |  13 +
 include/linux/mm_types.h                |   6 +
 include/linux/mmzone.h                  |  84 ++--
 include/linux/pageblock-flags.h         |  16 +-
 include/trace/events/mmflags.h          |   9 +-
 kernel/fork.c                           |   6 +
 kernel/panic.c                          |   2 +
 kernel/power/snapshot.c                 |   8 +-
 mm/Kconfig                              |  43 ++
 mm/Makefile                             |   3 +
 mm/compaction.c                         |  36 +-
 mm/init-mm.c                            |   3 +
 mm/internal.h                           |  70 ++-
 mm/memory.c                             |  76 +--
 mm/mermap.c                             | 334 ++++++++++++++
 mm/mm_init.c                            |  11 +-
 mm/page_alloc.c                         | 788 +++++++++++++++++++++++-----=
----
 mm/page_isolation.c                     |   2 +-
 mm/page_owner.c                         |   7 +-
 mm/page_reporting.c                     |   4 +-
 mm/pgalloc-track.h                      |   6 +
 mm/secretmem.c                          |  87 +++-
 mm/show_mem.c                           |   4 +-
 mm/tests/mermap_kunit.c                 | 250 ++++++++++
 mm/tests/page_alloc_kunit.c             | 250 ++++++++++
 43 files changed, 2341 insertions(+), 574 deletions(-)
---
base-commit: b5d083a3ed1e2798396d5e491432e887da8d4a06
change-id: 20260112-page_alloc-unmapped-944fe5d7b55c

Best regards,
--=20
Brendan Jackman <jackmanb@google.com>


