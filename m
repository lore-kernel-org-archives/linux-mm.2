Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1B5C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2A56B007B; Sun, 26 Jul 2026 18:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAC76B0088; Sun, 26 Jul 2026 18:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9206B008A; Sun, 26 Jul 2026 18:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 463E26B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B987B1A05C7
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:21 +0000 (UTC)
X-FDA: 85032355002.23.8CB2132
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65CA9180002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pf4G/tgH";
	spf=pass (imf06.hostedemail.com: domain of 31YhmaggKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=31YhmaggKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104599;
	b=sai/OPZr0Gn6La2+TpAF7qIP95AbzD3k6TOIijf4nf9iUAL69uRClhiILSVcObYf1LMN6i
	D2m9nwNQBKgqCj4M0XK1rDd13DVGyTSxO6qQ8UIXyL5GMuVKyePpZYg3FS3UmBc6sUXtm5
	63F1M8mDTxTAzSrn6pC8oE4PCQlZ8oE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pf4G/tgH";
	spf=pass (imf06.hostedemail.com: domain of 31YhmaggKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=31YhmaggKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fwocm4J1xb4aAoTRcXan73TN/g7WJcRC9N0tu2ikDlA=;
	b=uWxm6Cg1UB6/i1RkI6fcqRwLMSfxbrr6ngZeHtIAEbZj2fYzjSz8xg++3z+dPmxVgurfjc
	cKn5jHu7uW8WE1a05BWaXFfVwWN9YUwrVXEUITaXTtNaFRklozdaFIu4Z86zkdNvrDpSbL
	ZnoCqWa+h2vmqT5A56ymuj7nRVvQv64=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49554715277so19766795e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104598; x=1785709398; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Fwocm4J1xb4aAoTRcXan73TN/g7WJcRC9N0tu2ikDlA=;
        b=pf4G/tgHarhLJ81UM+3KIxr+nZ08cNF5R7mxEnv895GRe/gPNVIx5+sV9AN5bAV6Dl
         qMdDKJRwLOzBfGt9Br4F91zdY7vOuTHcHxWfj8jec8GpIzNcW0/9ydn0duQGtHVoXc47
         3KcIyCyrkHH1f4fvimxot11kRJGz4NyWNaJ0qaK/6wvGTXWx7SDx1EN3NmJ8brO5wUJb
         4xW5zVD1h0KNUdptOdV/ayN62J8gjTAuoIsguf9hJdGV16L5UVeS469Q1EY2qU6s+vE3
         UWrclsxnAVYBS3emd1ZJt4ARZUJK01Z8gCOnss95LxHsgGbMW7dJFAobzAmo+E5VG59z
         rXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104598; x=1785709398;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fwocm4J1xb4aAoTRcXan73TN/g7WJcRC9N0tu2ikDlA=;
        b=kUztANeqss3dqZ9kaYEVRpS7N0pArRLwjxHsJ8Mks78w4oKvf+k+ovCYoWDc4wTlSU
         rN0msNzpN+aUvnJq308D6BnZTO2BX50pubj+dzGpqtrbGehIt5UuuH++gG7r90rW6Oh4
         y5jD4g1tItU6N8aduKKUsUeQtfnUbrIBSuJe8I3WjfrTY/5KB61KW9cgGIUZCmA/uSNu
         ivHzC8r9DILpZEvR0KVpEGql8CZIN3ecwIOwz74U+/qMKhxue4w0ZqoEXJsSrd1AWvFj
         ZDJJNVjw/Po66bgy3Kjiiiwq+OEwbuehmnwPtKzjAtILgsXLzn9ls3ROohy7bP20tN7y
         WdZw==
X-Gm-Message-State: AOJu0Ywn5+frnHps9+2rJcRi5N7YXoqAdZpvey87UA5XebXvXxDO9dcp
	2kuSrmpDwO/E55mDKq+e4IEzFzFVJEfejqACl13I3M3M/rF9os2UnIrd2hPug8pXCD44XPXi4X0
	BBY1o7IgqjX4eGA==
X-Received: from wmnf20.prod.google.com ([2002:a05:600c:43d4:b0:493:c274:1b7b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3512:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-496b56c57e4mr77318215e9.10.1785104597733;
 Sun, 26 Jul 2026 15:23:17 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:33 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAKuIZmoC/23PwW6EIBQF0F8xrEvDe4iiq/5H0zQID4fEEUfUt
 JnMvxd1MWkyywvhcO+dJZoDJdYWdzbTFlKIYw7yrWD2YsaeeHA5MxRYCQDkk+np2wxDtHwdr2a
 ayPGmLD0pV3dKWZZfTjP58HOon185X0Ja4vx7fLLBfnp6iOqltwEXnLQW2ghpXVV99DH2A73be
 GU7uOETkSheI5gR1J2HzqnSl/APeZw1Z7qtefNydn1ObovDrqHiPg4h8hO3A5lxnRIXniQ0ndZ gsc2TstaZRDzb17C0hQK0GqkRlSe0+1RJUtS2bhQ4JfNFA6JTdS7y+AMB/mg4hAEAAA==
X-Change-Id: 20260112-page_alloc-unmapped-944fe5d7b55c
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Subject: [PATCH v3 00/26] mm: Add ALLOC_UNMAPPED and AS_NO_DIRECT_MAP
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1mu8e76ysoc4fr9ycm4aerp3pore7tjz
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65CA9180002
X-Rspam-User: 
X-HE-Tag: 1785104599-345247
X-HE-Meta: U2FsdGVkX1+bnWYBALBjNPQ2DTWHZGBW2BrGzP5yQUjfcZWD6rvyRDHk6H4/SdvXYeXcZxLztvows1WmxGLXpgRO5gySiK4zKtYLDjlj/LEbVc9udAAUo3IgbkoT5rizRwFuSCqa01Du2tX7RhtlYp4wIIWxga6Q+itFtsZVYK24I8X5y4W0QH+doziOB4/yG0qV9VJAgNfuyI+JbTig7+Tohr1il4Gs5oXpqJnygC+jYhTGy+bXB5rHATUTxqeJdrrepyyBbc3PqbwGRlqywhrgS/UFv9uNsM84llDjLE2XqGbVZvzyzT6LorTOQ6bCD0Ioj7aPnuu7BHdUqR/fxhiGEnuGuVUEQNlsAbornqz1lH8Xz+JjEp4c1MGp+CUlT+HJCvPq71jrbiBhwnnGaWGwUUP8kjRxDWr7R5wzZX9uwiL3iuUA60Rk3/rfonsFEHOQ9++7AaDgGt7CuWwhKDLJv67Jpeaazl2X3G8CzD/WEwz5TpmEZbm4wQg4AMmlGsgwrfUAdAx0Ne+m3kKMQtrzcatDj/zCltNfC6C7ZjZFDURbq/+9GPloC8H2G0z0EhRBYoPJpA4JZ8y5sCyq8HCGhDR5p1VmaePZO1GAxJVBfxborJwe4y9QzOPMc0+yOueoR0JWGn23HTxpAZBFp5WBbx8p/tkj80rMii5bo6qk++Z7fA/srHu+zHePnstekv76Sc/bRP+V7NJHr9wT+CnxjQu+NZzX8QaGd9YHY6JObqUFEup1aM8iUjEHqmtnkiydkF+rVCXOCadCwNqnmlLUZqkLVP4N4NqoXD4xLZvBvxiSlRaDfqAGTyVKNL/Gi3Oeba98L5szd9/fB0943IBQtloX59BIntKluwXycTgRKV9N2hwPkZdMrBwnXqTmVgoM2gxNfJn/R0wlCuHhDV5dXRkd1qmd91okeOymaDzBRylWhMpCeJt0N7vaXad4Dp20486UZbli/BaL3SK
 vlLlzRhu
 JSiYC8YPHqlPCMDCNwqN3SjKuw9HZtf/ZGCcME1QWD4cgNXXc4ZIYkhHwIEovjunHxrV7q8QHE4TIZ17cI9k6oy6GyE4FAXXlZ5iYHg3zR68H2tWBXSbCGBh/PBel8LZImtO0oiqsyiZvXvbK0io8or5YwtUrcuqMRCEUGGbaZXR0B9CtDMZ5e8gHbKaR5ZB7u03+jy5MwAqaktyH2W9ZS4l7EkRNAKWw3mqGCbjtYLseIAxnDGIyP03CGzyUg1/n7aB/XccBGD9IR7Y1ARGufpwaq3vkK6H0h5/KwqtKXDZs7oGZli/efPyJ+bW5cwjax6yV/NoVcPi/bS1c+So0E9F1TK9CX8T5K0w9M+X2edn0tiqfCLGrE1JIPm7CUEPkF4BKP5vJBWTpPs6JxU9xR01AHUqgeCbtV+PIvYSYwiwkhNvOlu8aFXZbPc97zzgdJAAdlcuWOejXD2AWI6NMo07Y6RL83Zr25omBi4ouINd6k3kltFisBfmdoenBDTuZTR4Gg/naSt5D8dKHKD3hVrblboBjIK8IWPBFizK8pLyuVHG703YpBaB3Bp10yCm8iK/XV3yt9lC8zAlEnb6/wfv1DFNwLLECFC/9Halbzo7YB7z5oKY/uT4Z1+2YNm69UKEd/dtPn09cnyHVPUzsfhGuq9l2Hn3CcToA+f053mpij+QqS6c9CKwTdHXDXkhopwJZVTxTCpNVUzSC0MigOv5r8JXM29wz43m+PWWe5R3ZSIYMi/lS+gPlnMp38I6RXDLQn/ctreVbybi06ELac3o4CFxTLxp9RpB8whmycdw3PDyAXf1cZmGYzJYMecVW7a30FqQr3+ZV78ro7xnyaRC9WhtgydJLpGbnIEwL/ypoR7xmynGYmdq/7FgTtbZq1/xCkN9ODll5pq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on mm-new, plus this series:
https://lore.kernel.org/all/20260716-folio-alloc-cleanups-v1-0-5363b8e92d33=
@google.com/

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

   So, ALLOC_UNMAPPED serves as a Trojan horse to get the page allocator
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
devices that could be remediated by ALLOC_UNMAPPED [2]. It seems also
likely to be a key step towards dropping execmem as a distinct
allocation layer.

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
(In this series, unmapped allocation is only supported for unmovable
allocations, but that's just to save space in datastructures: the
implementation is supposed to be fully generic, eventually allowing
reclaim and compaction for the unmapped pages).

Previous iterations have proposed this as a GFP flag, but this bit space
is very limited, so in this version it is instead an ALLOC_ flag, which
also means the unmapped allocation is limited to the mm/ tree.

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
overloading, this extension is done by adding a new concept on top
of the migratetype: the _freetype_. A freetype is basically just a
migratetype plus some flags, and it replaces migratetypes wherever the
latter is currently used as to index free pages.

The first freetype flag is then added, which marks the pages it indexes
as being absent from the direct map. This is then used to implement the
new ALLOC_UNMAPPED flag, which allocates pages from pageblocks that have
the new flag, or unmaps pages if no existing ones are already available.

.:::: Design: Introducing the "mermap"

Sharp readers might by now be asking how ALLOC_UNMAPPED interacts with
__GFP_ZERO. If pages aren't in the direct map, how can the page
allocator zero them? The solution is the "mermap", short for "epheMERal
mapping". The mermap provides an efficient way to temporarily map pages
into the local address space, and the kernel uses these mappings to
zero pages.

Using the mermap securely requires some knowledge about the usage of the
pages. For the secretmem (and later, guest_memfd) unmapping usecase,
that means when the kernel makes these special allocations, it is only
safe because the pages will belong to the current process. In other
words, the use of the mermap potentially allows that process to leak the
pages via CPU sidechannels (unless more holistic/expensive mitigations
are enabled). This specialness means that we want to avoid the allocator
itself using the mermap. Therefore, ALLOC_UNMAPPED is incompatible with
__GFP_ZERO and it's up to the user (which, for now, just means the page
cache) to deal with zeroing.

Since this cover letter is already too long I won't describe most
details of the mermap here, please see the patch that introduces it.

But one key detail is that it requires a kernel-space but mm-local
virtual address region. So... this series adds that too (for x86). This
is called the mm-local region and is implemented by "just" extending and
generalising the LDT remap area.

.:: Outline of the patchset

- Patches 1 -> 3: Prep + introduce AS_NO_DIRECT_MAP (slow)

- Patches 4 -> 8: Prep + introduce mm-local region for x86

- Patches 9 -> 12: Prep + introduce mermap

- Patches 13 -> 15: Introduce freetypes

  - Patch 13 in particular is the big annoying switch-over which changes
    a whole bunch of code from "migratetype" to "freetype". In order to
    try and have the compiler help out with catching bugs, this is done
    with an annoying typedef. I'm sorry that this patch is so annoying,
    but I think if we do want to extend the allocator along these lines
    then a typedef + big annoying patch is probably the safest way.

- Patches 16 -> 25: Introduce ALLOC_UNMAPPED

- Patch 26: Adopt ALLOC_UNMAPPED, making AS_NO_DIRECT_MAP fast

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

.:::: Hacky bits: ALLOC_NOBLOCK

The mapping/unmapping logic only happens when the new ALLOC_NOBLOCK flag
is set, but this is probably more restrictive than necessary. (Maybe
only unmapping needs to be restricted, and only on certain platforms).

.:::: Hacky bits: Zeroing with AS_NO_DIRECT_MAP

AS_NO_DIRECT_MAP is incompatible with __GFP_ZERO. In previous
iterations, the allocator worked around this by zeroing internally via
the mermap, but this produced a leaky abstraction where page_alloc users
have to manage the mermap TLB flushing themselves.

For now, I've solved this by just having AS_NO_DIRECT_MAP imply zeroing,
both after alloc _and_ before free. This is what secretmem does, but it
probably isn't what other AS_NO_DIRECT_MAP users would want. So either
we'll need new flags, or to change the design so that the zeroing
happens elsewhere.

.:: Performance

In [4] is a branch containing:

1. (A previous version of) this series.

2. All the key kernel patches from the Firecracker team's "secret-free"
   effort, which includes guest_memfd unmapping ([0]).

3. Some prototype patches to switch guest_memfd over from an ad-hoc
   unmapping logic to use of __GFP_UNMAPPED (the old name for
   ALLOC_UNMAPPED), plus direct use of the mermap to implement write()).

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

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v3:
- The big one: Dropped __GFP_UNMAPPED, instead now it's ALLOC_UNMAPPED.
- Tweaked mermap API - migrate disable now handled by caller.
- Dropped support in the allocator for zeroing unmapped pages. For now
  the pagecache handles this.
- Added missing logic to zero pageblocks before re-mapping them.
- Switched to expand() in __rmqueue_direct_map()
- Fixed rmqueue_mode usage in __rmqueue_direct_map()
- Rebased onto various preparatory series, in particular:
  https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@goog=
le.com/
  https://lore.kernel.org/all/20260715-spin-trylock-followup-v3-0-fc4d246f7=
05d@google.com/
  https://lore.kernel.org/all/20260629-gfp-pessimisation-v2-1-311ece6a8637@=
google.com/
  https://lore.kernel.org/all/20260513-page_alloc-unmapped-prep-v1-0-dacdf5=
402be8@google.com/
  (This also fixes various flags plumbing bugs that were in v2).
- Fixed various boring bugs in the mermap KUnit tests
- Moved migration disabling from __mermap_* internal functions into
  mermap_* API functions, to make KUnit tests easier.
- Split up x86 mm-local creation into 3 commits for easier review
- Fixed flags confusion in __apply_to_page_range(). (I described the
  prior patch as "complete rubbish" but actually I was over-reacting)
- Various other coding trivialities
- Link to v2: https://lore.kernel.org/r/20260320-page_alloc-unmapped-v2-0-2=
8bf1bd54f41@google.com

Changes in v2:
- Adopted it for secretmem
- Fixed mm-local region under KPTI on PAE
- Added __apply_to_page_range() mess
- Added fault injection for mermap_get(), fixed bug this uncovered
- Fixed various other silly bugs
- Link to v1 (RFC): https://lore.kernel.org/r/20260225-page_alloc-unmapped-=
v1-0-e8808a03cd66@google.com

---
Brendan Jackman (23):
      x86/mm: split out preallocate_sub_pgd()
      x86: move PAE PMD preallocation defines to header
      x86/tlb: Expose some flush function declarations to modules
      x86/mm: introduce mm-local region
      x86/mm: move LDT remap into mm-local region
      mm: Create flags arg for __apply_to_page_range()
      mm: Add more flags for __apply_to_page_range()
      x86/mm: introduce the mermap
      mm: KUnit tests for the mermap
      mm: introduce freetype_t
      mm: move migratetype definitions to freetype.h
      mm/page_alloc: add support for freetypes with no freelist
      mm: add definitions for allocating unmapped pages
      mm: encode freetype flags in pageblock flags
      mm/page_alloc: separate pcplists by freetype flags
      mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
      mm/page_alloc: introduce ALLOC_NOBLOCK
      mm/page_alloc: implement FREETYPE_UNMAPPED allocations
      mm: Minimal KUnit tests for some new page_alloc logic
      mm: Split out NR_FREE_PAGES_BLOCKS_[UN]MAPPED
      mm/page_alloc: always direct compact for unmapped allocs
      mm: plumb alloc flags into some alloc funcs
      mm: add fast path for AS_NO_DIRECT_MAP

Nikita Kalyazin (2):
      set_memory: add folio_{zap,restore}_direct_map helpers
      mm/secretmem: make use of folio_{zap,restore}_direct_map

Patrick Roy (1):
      mm: introduce AS_NO_DIRECT_MAP

 Documentation/arch/x86/x86_64/mm.rst    |   4 +-
 MAINTAINERS                             |   1 +
 arch/x86/Kconfig                        |   3 +
 arch/x86/include/asm/mermap.h           |  23 +
 arch/x86/include/asm/mmu_context.h      | 120 ++++-
 arch/x86/include/asm/page.h             |  32 ++
 arch/x86/include/asm/pgalloc.h          |   3 +
 arch/x86/include/asm/pgtable_32_areas.h |   9 +-
 arch/x86/include/asm/pgtable_64_types.h |  18 +-
 arch/x86/include/asm/pgtable_types.h    |   2 +
 arch/x86/include/asm/tlbflush.h         |  43 +-
 arch/x86/kernel/ldt.c                   | 124 +----
 arch/x86/mm/init_64.c                   |  44 +-
 arch/x86/mm/pgtable.c                   |  70 +--
 include/linux/freetype.h                | 178 +++++++
 include/linux/mermap.h                  |  65 +++
 include/linux/mermap_types.h            |  44 ++
 include/linux/mm.h                      |  13 +
 include/linux/mm_types.h                |   6 +
 include/linux/mmzone.h                  |  90 ++--
 include/linux/pageblock-flags.h         |  10 +
 include/linux/pagemap.h                 |  43 ++
 include/linux/secretmem.h               |  18 -
 include/linux/set_memory.h              |  15 +
 include/linux/vmstat.h                  |  10 +
 kernel/fork.c                           |   6 +
 lib/buildid.c                           |   8 +-
 mm/Kconfig                              |  48 ++
 mm/Makefile                             |   3 +
 mm/compaction.c                         |  69 ++-
 mm/filemap.c                            | 203 ++++++--
 mm/gup.c                                |   9 +-
 mm/internal.h                           |  86 +++-
 mm/khugepaged.c                         |   2 +-
 mm/memory.c                             | 122 +++--
 mm/mempolicy.c                          |  31 +-
 mm/mempolicy.h                          |  24 +
 mm/mermap.c                             | 375 +++++++++++++++
 mm/migrate.c                            |   2 +-
 mm/mlock.c                              |   2 +-
 mm/page_alloc.c                         | 814 +++++++++++++++++++++++-----=
----
 mm/page_alloc.h                         |  68 ++-
 mm/page_isolation.c                     |   8 +-
 mm/page_owner.c                         |   7 +-
 mm/page_reporting.c                     |   4 +-
 mm/secretmem.c                          |  56 +--
 mm/show_mem.c                           |   4 +-
 mm/tests/mermap_kunit.c                 | 258 ++++++++++
 mm/tests/page_alloc_kunit.c             | 243 ++++++++++
 mm/vmscan.c                             |  49 +-
 mm/vmstat.c                             |   3 +-
 51 files changed, 2781 insertions(+), 711 deletions(-)
---
base-commit: 512c82e906fe2c26023e307c7951d53e90910b57
change-id: 20260112-page_alloc-unmapped-944fe5d7b55c
prerequisite-change-id: 20260716-folio-alloc-cleanups-0fe319b881c2:v1
prerequisite-patch-id: ac8409ce11a2239c4b9876596b9c2381d67ae660
prerequisite-patch-id: 686bc2e87ed379040d6e80a7383aca8f4569c4a4
prerequisite-patch-id: ba2fd1bb866c06586e303081ce7f555dae716799

Best regards,
-- =20
Brendan Jackman <jackmanb@google.com>


