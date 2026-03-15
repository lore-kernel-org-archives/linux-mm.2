Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27244F30285
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C116B009F; Sun, 15 Mar 2026 16:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639656B00C2; Sun, 15 Mar 2026 16:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538466B00C3; Sun, 15 Mar 2026 16:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40DDF6B009F
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:36:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E55641D5A9
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:36:56 +0000 (UTC)
X-FDA: 84549456432.22.34C37A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4AED680011
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:36:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=js0b9oKF;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773607015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTuedTSSThiwGAsxZrOO5RZBn5rFRbyTuECg2p2IDyA=;
	b=qgmXcCuo8W4mjIAxzy17nrXEaDJ317LfqYxvFh/5ux73Sl4GE6MNpZw6SJctkty6qR4d+O
	A9mk2coKveTrLD82SdvFtRPM7Q3XUyWD5hzeewqwuidiSXue8PqgLy5lQZBhAeMQJIoPvZ
	V4SCSsByR5Z5BLk0YTxYccQXutObMmY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=js0b9oKF;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773607015; a=rsa-sha256;
	cv=none;
	b=kiVLi22YmMdJxSgUVMksqSpB8LZG2XinVqSmfn6cZ/zDJqLsNHunxhmU9kH1nvbqlZpxhE
	crQqUDU8cSNSNo03EOCncf3PgY1Num3maBrr4sTwifhNI97h3WE1UJSd6mjC7enU2Sd4mK
	f6y675FdN9OHPG2ORUf8WO3FkpFsrfo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9351F6183B;
	Sun, 15 Mar 2026 20:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF5BC4CEF7;
	Sun, 15 Mar 2026 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773607014;
	bh=fylH2F6Q3TWkBt7kBP6ifbZuZ+BJ5lqmGt2yIxZdfXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=js0b9oKFkQ41n1WGxLExWtor9uaHW8hKqcbTbH/Myn19UVRUzEhAJZlbuphM1wL4s
	 j+Bk5uVzvwlbMhdc3e5LGHyhWLwPhmAfC9ZPaF6ebEtHDYAu4zXkJaVQU9T7nUUTpV
	 gn9PJSLn4lOxA1t3GKFbWXT+jBPRaG/nn/6twMyhyDJp3zavKeVIpWUjY2H6aAT3Lk
	 +vSbJBza8BRdyjM7lzF2BNrp2nsmSNjpsmmlHDOHZbvAGKZGYmoj4M9MVA+Ye+0fJy
	 90w8cfbDuLw+PivtrA0N5cO4OEXQXq4+CBTK2/nnolO+kEGXUu+T7XVK3ABXoBQMgU
	 jmMWHrInP7akA==
Date: Sun, 15 Mar 2026 20:36:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] Docs/mm: document Page Allocation
Message-ID: <9b8a1636-ab8a-46ce-98d9-fc68d774e969@lucifer.local>
References: <20260314152530.100357-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152530.100357-1-xaum.io@gmail.com>
X-Stat-Signature: 3cs76d6xdn7zu8ggnee6f35jco6jzkmx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AED680011
X-HE-Tag: 1773607015-330595
X-HE-Meta: U2FsdGVkX1/8srHL28R2K/EtUHHIKZ5ATi7dS7kCFJYGGOBjC1HQfWHBm874v2rDa+uHhVtJHISTvxxPeryAPe2AMOlrSvILjJyZF5UrLOkMOUwjnoawOUrKlFFyUGo98AItE1rSrr+DeZNfQmDJrbtyBEvBordTMnYGfbxM1YphWjMtSmLxE3dzvHIKJjmRFR0Pl+Cbb5RhL4XPGFYzyIsSPkIvmcVi/1dzD5XzGtDEhx/RZstZBhb/OLK8UXBlYWZAf4lXnR9X9dvE+O1zfHzzw+KjUNcIdLJ0w+bmTz+Uq4SEcJegTCGIdEe10GSMiVXO6Clw36QGvbxXPZalAp30SADFYyVY/d8zRnnQgYTW0OpEylpWpWIDBa8qj6rQalQF7+t/+D6nViGtNqwgahQrmwm6la7sGptQ0i7XZSRuG830L82+M1/RPKrBRzQbZN7wV4ntp0MW/vhoIEQasC0Bsoxs0GYlNkXcqmA6Vc/2TF0Z/GDwlhYjBGX1YTuD39NsUSDVKx6IW96yREXihUFVMSE8jP2a2pbpEmtFo97vCkoldxzSFWgSITRAfAcg2Hz1jNo/3yx5fHOUOShSdP1T5ouOPlBjEnwTajqHQ1rNEdJwwgY+7vZfBUTfn6txQ1OFvIcUEy5Fkb+Kq61A+iftoIkYAF9y9jdgTxd6qRpBSzBxLkIzSWKifSdow6sZc4TJWoRs7XJ35D0q251ngSXctaZ/LYT6kzUM71vAA1mk/HfLK4dVX7p/ML+6YWW3lxiwweAVyzCHVz0eQmvV7a0OP/5HTqhP1J7U3siEVzNGRb5oj0rdE3JNylX+4N95GDW4uwEKlzVh9UMgzUR2kl+pW5QTW0imoAmLUZr7wfyiZ7rCaYgsins2727ow2nu+LUtzIR3ZE/ANHknJNA1BNEQkxBE6K1bUpJiLvcA87pDXbn5U2f4TGsLlcbKtK0AABAqPpYMZIJOeGiJUm8
 sfcniGF+
 VfEUGaENfLzy//ZOtxbV56xzEtnq/V2IjmgGbUcyQTyrbUivb8Cgt1uO8zI6T8zmCxCZVb5mzjeNz4MouJBFM6geatkV/aGawKthyCoUmg4zCuHGkf2UYfNMw0N5Ludy9OPfE9BB2mXtF+aN9sb8s51qs4oMlF3AtQ4uMvFnE3lvgwrGbL7j5X/I2g81FzfAdOcto5Bl+a90/TgPZYAm88gySv4zQUWDQsFNStk4R5i/FwT5T7MVQmG0dQivFIyfCBeVfZVrwnznBiXkHlDeCyKGTUvv/fr0XlffJy3YPg4t0x/w9q5nACwsZRANPA1gbSsmKkPlh5oN7FnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

Because AI slop obviously, please don't send this kind of stuff.

This time I will +cc the page alloc maintainer for you, who I am sure will
be overjoyed by this...

Same reasons as the rest, I'm already annoyed you didn't bother to put this
in a series even. If you didn't lazily get Claude to do everything, you're
doing a very good job at seeming like you did.

On Sat, Mar 14, 2026 at 04:25:30PM +0100, Kit Dallege wrote:
> Fill in the page_allocation.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.
>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/page_allocation.rst | 219 +++++++++++++++++++++++++++
>  1 file changed, 219 insertions(+)
>
> diff --git a/Documentation/mm/page_allocation.rst b/Documentation/mm/page_allocation.rst
> index d9b4495561f1..4d0c1f2db9af 100644
> --- a/Documentation/mm/page_allocation.rst
> +++ b/Documentation/mm/page_allocation.rst
> @@ -3,3 +3,222 @@
>  ===============
>  Page Allocation
>  ===============
> +
> +The page allocator is the kernel's primary interface for obtaining and
> +releasing physical page frames.  It is built on the buddy algorithm and
> +implemented in ``mm/page_alloc.c``

Page frames... Which are? And how is that useful

Primary? So what's the secondary, or tertiary, etc.  'interface' for
'obtaining' and 'releasing' (hint: we use other words for these) 'page
frames' (hint: we don't really refer to these as page frames) ?

.
> +
> +.. contents:: :local:
> +
> +Buddy Allocator
> +===============
> +
> +Free pages are grouped by order (power-of-two size) in per-zone
> +``free_area`` arrays, where order 0 is a single page and the maximum is
> +``MAX_PAGE_ORDER``.  To satisfy an allocation of order N, the allocator
> +looks for a free block of that order.  If none is available, it splits

Nope. Alot are in PCP lists. Claude mentions this below but you're already
hand waving in a way that's actively unhelpful.

> +higher-order block in half repeatedly until one of the right size is
> +produced.  When a page is freed, the allocator checks whether its "buddy"
> +(the adjacent block of the same order) is also free; if so, the two are
> +merged into a block of the next higher order.  This coalescing continues
> +as high as possible, rebuilding large contiguous blocks over time.

This is such a useless abbreviated description of the buddy allocator as to
be frankly worthless.

> +
> +Migratetypes
> +============
> +
> +Each pageblock (typically 2MB on x86) carries a migratetype tag that

Ha! You (read; Claude) don't even define what a pageblock is or what it's
for... as if people ought to 'just know', somehow...

Again, you're proactively wasting our time with this, it's not wanted or
helpful.

And etc. etc. etc. the whole document would need to be thrown away and
rewritten, and we could choose to do that ourselves without your 'help',
thanks.

> +describes the kind of allocations it serves:
> +
> +- **MIGRATE_UNMOVABLE**: kernel allocations that cannot be relocated
> +  (slab objects, page tables).
> +- **MIGRATE_MOVABLE**: user pages and other content that can be migrated
> +  or reclaimed (used by compaction and memory hot-remove).
> +- **MIGRATE_RECLAIMABLE**: caches that can be dropped under pressure
> +  (page cache, dentries).
> +- **MIGRATE_CMA**: reserved for the contiguous memory allocator;
> +  behaves as movable when not in use by CMA.
> +- **MIGRATE_ISOLATE**: temporarily prevents allocation from a range,
> +  used during compaction and memory hot-remove.
> +
> +When a free list for the requested migratetype is empty, the allocator
> +falls back to other types in a defined order.  It may also "steal" an
> +entire pageblock from another migratetype if it needs to take pages from
> +it, changing the pageblock's tag to reduce future fragmentation.  This
> +fallback and stealing logic is a key mechanism for balancing fragmentation
> +against allocation success.
> +
> +Per-CPU Pagesets
> +================
> +
> +Most order-0 allocations are served from per-CPU page lists (PCP) rather
> +than the global ``free_area``.  This avoids taking the zone lock on the
> +common path, which is critical for scalability on large systems.
> +
> +Each CPU maintains lists of free pages grouped by migratetype.  Pages are
> +moved between the per-CPU lists and the buddy in batches.  The batch size
> +and high watermark for each per-CPU list are tuned based on zone size and
> +the number of CPUs.
> +
> +When a per-CPU list is empty, a batch of pages is taken from the buddy.
> +When it exceeds its high watermark, excess pages are returned.
> +``lru_add_drain()`` and ``drain_all_pages()`` flush per-CPU lists when
> +the system needs an accurate count of free pages, such as during memory
> +hot-remove.
> +
> +GFP Flags
> +=========
> +
> +Every allocation request carries a set of GFP (Get Free Pages) flags,
> +defined in ``include/linux/gfp.h``, that describe what the allocator is
> +allowed to do:
> +
> +Zone selection
> +  ``__GFP_DMA``, ``__GFP_DMA32``, ``__GFP_HIGHMEM``, ``__GFP_MOVABLE``
> +  select the highest zone the allocation may use.  ``gfp_zone()`` maps
> +  flags to a zone type; the allocator then scans the zonelist from that
> +  zone downward.
> +
> +Reclaim and compaction
> +  ``__GFP_DIRECT_RECLAIM`` allows the allocator to invoke direct reclaim.
> +  ``__GFP_KSWAPD_RECLAIM`` allows it to wake kswapd.  Together these form
> +  ``GFP_KERNEL``, the most common flag combination.
> +
> +Retry behavior
> +  ``__GFP_NORETRY`` gives up after one attempt at reclaim.
> +  ``__GFP_RETRY_MAYFAIL`` retries as long as progress is being made.
> +  ``__GFP_NOFAIL`` never fails — the allocator retries indefinitely,
> +  which is appropriate only for small allocations in contexts that
> +  cannot handle failure.
> +
> +Migratetype
> +  ``__GFP_MOVABLE`` and ``__GFP_RECLAIMABLE`` select the migratetype.
> +  ``gfp_migratetype()`` maps flags to the appropriate type.
> +
> +Allocation Path
> +===============
> +
> +Fast path
> +---------
> +
> +``get_page_from_freelist()`` is the fast path.  It walks the zonelist
> +(an ordered list of zones across all nodes, starting with the preferred
> +node) looking for a zone with enough free pages above its watermarks.
> +When it finds one, it pulls a page from the per-CPU list or buddy.
> +
> +The fast path also checks NUMA locality, cpuset constraints, and memory
> +cgroup limits.  If no zone can satisfy the request, control passes to
> +the slow path.
> +
> +Slow path
> +---------
> +
> +``__alloc_pages_slowpath()`` engages increasingly aggressive measures:
> +
> +1. Wake kswapd to begin background reclaim.
> +2. Attempt direct reclaim — the allocating task itself reclaims pages.
> +3. Attempt direct compaction — migrate pages to create contiguous blocks
> +   (for high-order allocations).
> +4. Retry with lowered watermarks if progress was made.
> +5. As a last resort, invoke the OOM killer (see Documentation/mm/oom.rst).
> +
> +Each step may succeed, in which case the allocation is retried.  The
> +``__GFP_NORETRY``, ``__GFP_RETRY_MAYFAIL``, and ``__GFP_NOFAIL`` flags
> +control how far down this chain the allocator goes.
> +
> +Watermarks
> +==========
> +
> +Each zone maintains min, low, high, and promo watermarks that govern
> +reclaim behavior:
> +
> +- **min**: below this level, only emergency allocations (those with
> +  ``__GFP_MEMALLOC`` or from the OOM victim) can proceed.  Direct reclaim
> +  may be triggered.
> +- **low**: when free pages drop below this level, kswapd is woken to
> +  begin background reclaim.
> +- **high**: kswapd stops reclaiming when free pages reach this level.
> +  The zone is considered "balanced."
> +- **promo**: used for NUMA memory tiering; controls when kswapd stops
> +  reclaiming when tier promotion is enabled.
> +
> +The min watermark is derived from ``vm.min_free_kbytes``.  The distance
> +between watermarks is scaled by ``vm.watermark_scale_factor``.
> +
> +Watermark boosting temporarily raises watermarks after a pageblock is
> +stolen from a different migratetype, increasing reclaim pressure to
> +recover from the fragmentation event.
> +
> +High-Atomic Reserves
> +--------------------
> +
> +The allocator reserves a small number of high-order pageblocks for atomic
> +(non-sleeping) allocations.  When a high-order atomic allocation succeeds
> +from unreserved memory, the containing pageblock is moved to the reserve.
> +When memory pressure is high, unreserved pageblocks are released back to
> +the general pool.
> +
> +Compaction
> +==========
> +
> +Memory compaction (``mm/compaction.c``) creates contiguous free blocks for
> +high-order allocations by relocating movable pages.  It runs two scanners
> +across a zone: one walks from the bottom to find movable in-use pages, the
> +other walks from the top to find free pages.  Movable pages are migrated
> +to the free locations, consolidating free space in the middle.
> +
> +Sync modes
> +----------
> +
> +Compaction operates in three modes:
> +
> +- **ASYNC**: skips pages that require blocking to isolate or migrate.
> +  Used in the allocation fast path and by kcompactd.
> +- **SYNC_LIGHT**: allows some blocking but skips pages under writeback.
> +- **SYNC**: allows full blocking.  Used when direct compaction is the
> +  last option before OOM.
> +
> +Deferral
> +--------
> +
> +When compaction fails for a given order in a zone, it is deferred for an
> +exponentially increasing number of attempts to avoid wasting CPU on zones
> +that are too fragmented.  A successful high-order allocation resets the
> +deferral.
> +
> +kcompactd
> +---------
> +
> +Each node has a kcompactd kernel thread that performs background
> +compaction.  It is woken when kswapd finishes reclaiming but high-order
> +allocations are still failing due to fragmentation.  kcompactd runs at
> +low priority to avoid interfering with foreground work.
> +
> +Capture Control
> +---------------
> +
> +During direct compaction, the allocator uses a capture mechanism: when
> +compaction frees a block of the right order, the allocation can claim it
> +immediately rather than racing with other allocators on the free list.
> +
> +Page Isolation
> +==============
> +
> +``mm/page_isolation.c`` supports marking pageblocks as ``MIGRATE_ISOLATE``
> +to prevent new allocations from those ranges.  Existing free pages are
> +moved out; the caller then migrates all in-use pages away.  Once the range
> +is fully evacuated, it can be used for a contiguous allocation or taken
> +offline.
> +
> +This mechanism is used by:
> +
> +- **CMA** (contiguous memory allocator): reserves regions at boot for
> +  device drivers that need physically contiguous buffers.  The reserved
> +  pages serve normal movable allocations until a CMA allocation claims
> +  the range.
> +- **Memory hot-remove**: isolates a memory block before offlining it.
> +- **alloc_contig_range()**: general-purpose contiguous allocation used
> +  by gigantic huge pages and other subsystems.
> +
> +The isolation process must handle pageblocks that straddle the requested
> +range boundaries, compound pages (huge pages, THP) that overlap the
> +boundary, and unmovable pages that prevent evacuation.
> --
> 2.53.0
>
>
>

