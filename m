Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1837F30285
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE21B6B00C4; Sun, 15 Mar 2026 16:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FA86B00C5; Sun, 15 Mar 2026 16:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EC96B00C6; Sun, 15 Mar 2026 16:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6D046B00C4
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:43:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BD891A0D2B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:43:30 +0000 (UTC)
X-FDA: 84549472980.04.24AEF23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C558F14000E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:43:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdiGqARE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773607408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOmcIPr8F5SSpHnNxlkVxqaam/mrQdLkjVV9/nKdGT4=;
	b=jQpq0BItJjkqDggkOVzwJ9S9yJqrBaaUSQhq+XIwcAKwninzZDKX5ccKsApa8DR63ri19J
	12QWyQQMcVLrHxRdIyr73LdygxENfLM8QgLf3BIqMdj2paRUBtUhO3lFHgaIsa/quYHwgl
	x9qW59ZraHfMcNjOuJ5HJaJR70bt10Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773607408; a=rsa-sha256;
	cv=none;
	b=yu3BlcrgUm4uirvQWW4uQn0Sf9TAvOsXzQhmtjFjh9IbxyF6Au+rKJlgdYiJyYiouJejN+
	Rdho1Bq1XtBGbU56PNB4btk7nZlv+2dDPqXXb1cxDltLX3+/VKPSGkMgg3isXHWMZdhzQX
	OmwcABtN4Tpr8JgHpVj+ZWPYd3jRRik=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdiGqARE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DBFF6183B;
	Sun, 15 Mar 2026 20:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B03AC4CEF7;
	Sun, 15 Mar 2026 20:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773607407;
	bh=jXznozhRbqcFV3cbvDd2PKTCzQcz4cxhMi4uZ7QQI9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tdiGqARE7zwg3/hRcoaSCYCx1G3DVBGoSBbaDRfFcoDrQqMxTPw1QzsYjeoNZTrrN
	 guf0C+alsDzElM8dGmRuZVVyjfn8B9AiI9qUTz+i6z5T91uXNGqO6PR7FELddww8E6
	 T+so9lN52oKYm11ZzGP5FAUf91UkCVjF2I37P7VBwvMPbqUe1TVojYVUfLWdj/IP8v
	 Jxl3QGbt4lV9srCrWEEloHeROtPdemrtXwPhrEFgJ6/oE1iLIEg0ZcntulKquXeJch
	 NNX7EEjWK6mcIhOr8ReV/WPDeGti3+9kyMznXnmTpdgPySH+rUitJOjIY68/Kkm0Oe
	 phYHVJnAQ2UIg==
Date: Sun, 15 Mar 2026 20:43:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH] Docs/mm: document Boot Memory
Message-ID: <0c981733-477b-496e-abe5-54eebaae04b1@lucifer.local>
References: <20260314152527.100295-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152527.100295-1-xaum.io@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C558F14000E
X-Stat-Signature: g4zncac487rqpgimgtrtmz8nsape4c7b
X-Rspam-User: 
X-HE-Tag: 1773607408-599937
X-HE-Meta: U2FsdGVkX19kTuue9A626e1RYyoOv5zRQ0YcSh9YBFihaavAuSuO0jQCbt/nXB75Y9VDvBe6GR7bF/kjTkFyoMIHZsJRUnlS7wZ0oxfrzrnE/5Z4cdKqqamUvzuiwMbM3J0VNovGddUDzWkX3mht30ohr4voGVhID2j4Qv/oeaRpJswD8RShQTNPDyKHGtRTltoasW57jY8Cc3c+7XUAtEcE3Pfhynu+l6QR3INN8DjdPALq0hePkdxcpsMy3ig1i95bqg852Xn7Ao2S+4R1XrdIdPMiLIsgiVmccFFHt+V/Bfl/DfJrBHBYDt/60MuCKo7fNH8Eqq1X7LlAdrt9U3+ekfuZqCdKbbW5SSmXX/hJX1a256tMZCBjRIdLIXzppPc4oanCp46wh3M1gUTBdfaIRoEdHYr9O3dLmOu/6jLFVL5xLL1EFMIKEzCqltN3JLUf4GlUvNP8Cgp1YmpJIChz4rnUqAFvvejP7+09DRDwSZHG+G2/EMJ/qTkcV/AiZl/0Bx0zwOVuK8JRV/EqmoWiD1V/HwajD4w9r1sS0iYV3wroTrD1etiLD4/e7mxmKZ7uKNLO+znuwC6mQrWIME1EwlCD0eDQYRw8PMA59jX3lKwE4f4tTPY7xOr/+6dBtdNhFQFHINd6LZCrxs+qU/2w1eXgwxV8RFCkD68oDMll65nB2J0bVy7gaCbBSnCSJfDKZaFH6mel3oV/nBosWYHXx4AGydmF25UyRlZAngacw37QKTYRjl6NdQ9Brksg8PQ3h24OCUv24PTRYbHXDE0B1JPMryoHXw25/oCD/MB+pAzH8Lu0kpHVreRXI7mONtTh/BQOPXwu7vV3jNPUGViWi3bji6Ewgrxf6ifcQd8ZgHotMIiM53T7k/ijJvtmfYjU5H+GYYv7194Fy5th3W6smLupm+6kA5JdXbDYvt3/afkkdrGSjWP9jlOyvAjhvdz9BjW0EBefNyPoVKa
 ZWoVirzu
 8yneV4Q2QMK9pC+JgXdRLSP5WgVDVGK9aA1qyTR3xrMIRxMflMr6j5aN8ygFETwEyVQjoEGmSD8sbIvWfk8XySM1jNPQmAc+SWZp0nk5ElrPAf/LhXz1ztR9DafM+uI3Unuxfst90Gs0/ahrx+z54sA2yzFPiwJUdEfQyumOx7W9BDLQPCEAdByzeQYU+/xosFtMKv9CS8Nxhdx2udH7yiht5g4YoPH2SiZnXD18xY9zSyKPiWDZpgRk/HyTV2KTzCGZeGYSGWmFJvSaSjG5uNND0ty5QwsUh0VLz9Esjikrlj+ee1WxBky5SPCyMYqT96d2SBRI7xg/kJik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK for being AI slop, again, obviously.

+cc Mike, the 'boot memory' maintainer, who again I'm sure will be
overjoyed by this.

Reasons, as the rest:
- Worthless documentation
- Everything about patch screams 'zero effort, Claude did it all'
- Bad etiquette

On Sat, Mar 14, 2026 at 04:25:27PM +0100, Kit Dallege wrote:
> Fill in the bootmem.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.

I mean I'm belabouring the point, but this commit message is useless
noise. And it's frankly impolite for you to copy/paste this to every patch.

It's worse etiquette to send them all separately...

Common courtesy would be to take some effort to read the list a bit first to get a sense.

Or even to ask Claude about how commit messages generally look in the
kernel. Or how patch series work. Or who to cc. Or how well sending this
might be received...

You are also demonstrating no understanding of what you're writing about,
and have no track record to suggest you'll stick around to maintain it or
do anything other than dump it on us, get us to completely rewrite for you
and you take the credit...

So IOW, not very useful, nor wanted.

>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/bootmem.rst | 139 +++++++++++++++++++++++++++++++++++
>  1 file changed, 139 insertions(+)
>
> diff --git a/Documentation/mm/bootmem.rst b/Documentation/mm/bootmem.rst
> index eb2b31eedfa1..b20520f53603 100644
> --- a/Documentation/mm/bootmem.rst
> +++ b/Documentation/mm/bootmem.rst
> @@ -3,3 +3,142 @@
>  ===========
>  Boot Memory
>  ===========
> +
> +The kernel needs a memory allocator long before the page allocator is ready.

Why?

> +The memblock allocator fills this role, managing physical memory from the
> +earliest stages of boot until the buddy allocator takes over.  The
> +implementation is in ``mm/memblock.c`` and ``mm/mm_init.c``.

This is at least reasonable.

> +
> +.. contents:: :local:
> +
> +Memblock
> +========
> +
> +Memblock tracks physical memory as two arrays of regions: ``memory`` (all
> +usable RAM reported by firmware) and ``reserved`` (memory already allocated
> +or otherwise unavailable).  A free page is one that appears in ``memory``
> +but not in ``reserved``.  These two arrays, along with global state such as
> +the allocation direction and address limit, are held in a single
> +``struct memblock`` instance.

You're not saying what they are, what reserved mean, why they are separate
etc. - it is typical LLM-generated stuff.

I can't really see any demonstration of you having checked this because
surely you yourself are immediately confused by this?

And etc. etc. etc.

> +
> +Each region is a ``struct memblock_region`` recording a base address, size,
> +NUMA node ID, and a set of flags:
> +
> +- **HOTPLUG**: memory that may be physically removed at runtime.
> +- **MIRROR**: memory with hardware mirroring for reliability.
> +- **NOMAP**: memory that should not be directly mapped by the kernel
> +  (e.g., firmware-reserved ranges that are usable but not mappable).
> +- **DRIVER_MANAGED**: memory whose lifecycle is managed by a device driver.
> +
> +Region Management
> +-----------------
> +
> +Firmware and architecture code populate the arrays early in boot.
> +``memblock_add()`` registers a range of usable RAM.  ``memblock_reserve()``
> +marks a range as taken — this is used for the kernel image itself, device
> +tree blobs, initrd, and other early allocations.
> +
> +When regions are added, overlapping ranges are merged automatically.
> +Internally, ``memblock_add_range()`` handles insertion, overlap detection,
> +and merging in a single pass.  If the region array is full, it is doubled
> +in size — using memblock itself to allocate the new array.
> +
> +``memblock_remove()`` deletes a range from the ``memory`` array (used when
> +firmware reports memory that turns out to be unusable).
> +``memblock_phys_free()`` removes a range from ``reserved``, making it
> +available for allocation again.
> +
> +Allocation
> +----------
> +
> +Memblock allocation scans the ``memory`` array for a range that does not
> +overlap ``reserved``, respecting NUMA node affinity and a configurable
> +address limit (``memblock.current_limit``).
> +
> +The search can run in two directions:
> +
> +- **Top-down** (default): allocates from the highest available address.
> +  This keeps low memory free for devices with addressing limitations.
> +- **Bottom-up**: allocates from the lowest available address.  Used on
> +  some architectures during early boot to keep allocations predictable.
> +
> +Once a suitable range is found it is added to ``reserved``.  The main
> +allocation functions are ``memblock_alloc()`` for virtual addresses and
> +``memblock_phys_alloc()`` for physical addresses.  Both support NUMA-aware
> +variants that prefer a specific node.
> +
> +Iteration
> +---------
> +
> +Memblock provides iterator macros for walking memory ranges:
> +
> +- ``for_each_mem_range()`` iterates over free ranges (memory minus
> +  reserved).
> +- ``for_each_reserved_mem_region()`` iterates over reserved ranges.
> +- ``for_each_mem_pfn_range()`` iterates by page frame number, which is
> +  used heavily during page and zone initialization.
> +
> +These iterators handle the subtraction of reserved regions from memory
> +regions internally, presenting the caller with a simple sequence of
> +available ranges.
> +
> +Transition to the Page Allocator
> +================================
> +
> +Once the buddy allocator is initialized, memblock releases its free pages
> +via ``memblock_free_all()``.  This walks all free ranges and hands each
> +page to the buddy allocator.  After this point memblock is no longer used
> +for allocation and its data structures can be freed (on systems that
> +support it, the memblock arrays themselves are returned to the page
> +allocator via ``memblock_discard()``).
> +
> +Named Reservations
> +------------------
> +
> +The ``reserve_mem`` kernel command line parameter allows firmware or boot
> +loaders to reserve named memory regions that persist across kexec.  These
> +are tracked separately and can be looked up by name at runtime with
> +``reserve_mem_find_by_name()``.
> +
> +Page and Zone Initialization
> +============================
> +
> +``mm/mm_init.c`` bridges memblock and the page allocator.  Its primary
> +responsibilities are determining zone boundaries and initializing
> +``struct page`` for every physical page frame.
> +
> +Zone Topology
> +-------------
> +
> +The function ``free_area_init()`` is called by architecture code to set up
> +nodes and zones.  It calculates zone boundaries based on architectural
> +constraints (which address ranges can be used for DMA, which are always
> +mapped, etc.) and kernel command line parameters:
> +
> +- ``kernelcore=`` sets the amount of memory that must be in non-movable
> +  zones.
> +- ``movablecore=`` sets the amount of memory to place in ``ZONE_MOVABLE``.
> +- ``movable_node`` allows entire NUMA nodes to be treated as movable.
> +- ``kernelcore=mirror`` restricts non-movable memory to mirrored regions.
> +
> +These parameters control the boundary between ``ZONE_MOVABLE`` and the
> +other zones, which in turn affects how much memory is available for
> +transparent huge pages, memory hot-remove, and CMA.
> +
> +Struct Page Initialization
> +--------------------------
> +
> +Every physical page frame needs an initialized ``struct page`` before the
> +page allocator can manage it.  On small systems this is done synchronously
> +during boot.  On large systems with hundreds of gigabytes of RAM, this
> +initialization can take a significant amount of time.
> +
> +With ``CONFIG_DEFERRED_STRUCT_PAGE_INIT``, only pages in the boot node's
> +lower zones are initialized during early boot — enough to get the system
> +running.  The remaining pages are initialized in parallel by worker threads
> +(via the padata framework) before they are first needed.  This can save
> +several seconds of boot time on large NUMA systems.
> +
> +Each page is initialized by setting its flags, reference count, and links
> +to the owning node and zone.  Pages in memory holes or ``NOMAP`` regions
> +are marked as reserved and are never handed to the page allocator.
> --
> 2.53.0
>
>
>

