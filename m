Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A27FF30282
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6045D6B00BA; Sun, 15 Mar 2026 16:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2266B00BB; Sun, 15 Mar 2026 16:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A346B00BC; Sun, 15 Mar 2026 16:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 372FB6B00BA
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:20:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAD3A1B8F21
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:20:16 +0000 (UTC)
X-FDA: 84549414432.22.CC4C79C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4249040002
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:20:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cLgeMeqd;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773606015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnvxxYgDVdVewwsNocDBDv5enJp9cC85rSvUweeJZ/g=;
	b=Wke/MEBi7xhAZXjvZFsuIyoMNiAr/vAWLJEIR7obTYBtTLcyX77YREltPy+/LlGxDAko1O
	3dTf6t4yC3mEOmMtTvu0oWF03Ca3YeAuxJeN14Wu+Wiv76iyKsnI6zDD5/6vOGERVtilOt
	YjDgMC/L/SRn9q+bZNHegB6sCyTmLkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773606015; a=rsa-sha256;
	cv=none;
	b=UXBEOvSGity+EToMDKHtwTERv+jpUcP0VB14XVU+yniMRIvpdy0gVTcOHtLkLR6e/3RcIt
	+/dEEfGxXBlTe2hVWgqnmg0Pti1apLAZg6JJb44luVo+71tpU6SHDx+0uOFKLtJA9sUvol
	UuQw75Rd8MB4je17OPnIItxW7v/Fi00=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cLgeMeqd;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C36DE61841;
	Sun, 15 Mar 2026 20:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB184C4CEF7;
	Sun, 15 Mar 2026 20:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773606014;
	bh=ADS+D532xAxun/YgHvZWAlDeIQk/4CVDyRfYy5VQM1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cLgeMeqd0WyKkAZ6Q4pm5lvHiMmhL2Iy0sjF8d9kMcb0LroCLd8IhOEJC7A0WxtUN
	 UaB1K0Gp+1io06h/NX0H98DFY4I6bgTm27aopzxey71DUb5KBjHd5GI4wuRiD1SZkl
	 Pnr1crgkO+lJtZk27ZPSHAsg6CHT+tCqBjy4e2NnS6InpfEFGYPO4DfKcVukSUz401
	 2hwYQtCP1EzoI/zZ/xcuciMiwu8plo/Rfb9/qBV0Vz5QUCs0BA8SiRnGlgMIWu+2Rl
	 9cPyyPZe2Wu7SHoov0CVfU/jxNZcPKNFJYDQVQ5gM3K78DQC4MKRrEu6PKdn7eDtME
	 Ftu7U0V38dGbw==
Date: Sun, 15 Mar 2026 20:20:11 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document Swap
Message-ID: <9c842f9f-b039-45ad-a80d-3e48c8fd3ba5@lucifer.local>
References: <20260314152536.100531-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152536.100531-1-xaum.io@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4249040002
X-Stat-Signature: fx41q3gx93888q6u97damz9qagfu17k3
X-Rspam-User: 
X-HE-Tag: 1773606015-518555
X-HE-Meta: U2FsdGVkX19YffKvrfw+r2UsXaPU/Tp3JYpAChxwfMIWeHx3wlnflUlOR0t78PwmqsssZd7NsMGa1oFFHZyCsxzjmfC4qpekHNX7DkDwSZKPpkydf2X9BMe3nWbWslh3mUUmdzX1TmmgWiX/JpJVwoh3vGopnPc236xfffsi+xD47NatJYI/UiihR+JUUWL16rul2ABhLIbBB8+jVAXxJUlvUZOo/WMZw+PFAqi8p+y4KMrsshwRj54xeYrV+FrbyT2doiIYsW8ZZcMhd89R2wzzkU2Q+3vjSYMSh1S2zK+badihE6lNcugDSCEb5/X9DmkBnXnlkRIp8iz0Prinn0bppZpIKdK90R2+FS5oREXFpzTL1W/BNMXwfq33LvTeTcSAuLTlKWijWL+WZU44eGNpO+/EtK5xGBxqu8rDlz2p2lrbV9pvem2bmjh5AgooRGEK4xADN12So1hr2HWM4179HI2A13QaXV5wkALCDqphVf6Od2DKWLciBSEDw/Ba7L30G/+8xErowL8zlBcxC2orLzAR05LxrGDB5VwXPtJdAIjVzV5t3i4mib80uS0749DfMujffnHwXKm3mzXrk1XIrtG/twli3IyHgYy6lA3SHuPpWW24wFydoDgOQh4OQLqykSblp/VHOybC2hrgbtKLOObrwtLP0BXtFl1xeB0SGOvC6GkisK6Vhs9f69ZGWl84zCXZ974u5wH3/ooA2c0Tv293Owe8Df5HEV+KFXS1qivh5BJrTDz2Ccxpb1wC7cbOOf/BZYLVv2itH8V6s1+2KR0Wtv7EsgFV7uX2rfZO0x6AqjJpBym8rYfWEOLW4DnJwwBWwBZ3SOMtzPUL/xZVFx1dOjQ7XKKucB/jY+blDdhE02X2YUEsxGg6CyqODxcAcuhL90o0E5xn+C7biOD719KRCtEI0ZYvgTKpsxRJrSioyM4HoY66WpKVtRKEZ/49p+wKtg1MXtARzar
 6V1hv/fc
 vALSWoEaVNfCBqbvIgqwp6zOwkCyQQKKrbI4ICLlN8cBpphhdl7B3sILoRFCUV/EgrqU+dHfmhNr8B8GA94J00cLECoItCV2cNif7kRNm1BsGhpXv8MQSWV7A+LjDjx4Nw5Z0avwH84/E3zEPFgQ4I3S9LQh8coOmgWWyzbLt1KsFjXQCODKSeiqu4y5+mk7UQ7fdH15UCQhMOsQQKHILiTiqb3EYrf6pp9BjM25Lx4Dz9l6sH2F8wB/kXxDcIz2cDOpEkPtGFORR5EhJVVybOACJ1y2cohRhm3Yq5AZ7qKkLvrCCJt7HUxEWP7sCH3ogv5Pwjk5GFMUwwWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

Again, you've not even bothered checking MAINTAINERS to see who
maintains/reviews swap to cc them, your commit message is cookie-cutter,
and you've demonstrated zero understanding of what you're writing about.

A quick glance suggests the 'documentation' is pointless handwaving
too. This is not worth maintainer time.

Also you've not even bothered to see how patches are sent and so have sent
all these documentation patches separately which SCREAMS 'I just got Claude
to do everything, and maybe I had a cursary glance at it'.

We do NOT want this thanks.

On Sat, Mar 14, 2026 at 04:25:36PM +0100, Kit Dallege wrote:
> Fill in the swap.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.
>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/swap.rst | 154 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 154 insertions(+)
>
> diff --git a/Documentation/mm/swap.rst b/Documentation/mm/swap.rst
> index 78819bd4d745..89a93cc081d4 100644
> --- a/Documentation/mm/swap.rst
> +++ b/Documentation/mm/swap.rst
> @@ -3,3 +3,157 @@
>  ====
>  Swap
>  ====
> +
> +Swap allows the kernel to evict anonymous pages (those not backed by a
> +file) to a swap device so that physical memory can be reused.  When the

This is useless tautology.

> +pages are needed again, they are read back in.  The swap subsystem spans

This is useless handwaving.

> +several files: ``mm/swapfile.c`` manages swap devices, ``mm/swap_state.c``
> +implements the swap cache, ``mm/page_io.c`` handles disk I/O, and
> +``mm/zswap.c`` provides an optional compressed cache layer.

Yeah who cares about page faults around swap, or softleaves (zero mentions)
or data structures or etc. etc.

I mean I won't go on.

> +
> +.. contents:: :local:
> +
> +Swap Entries
> +============
> +
> +A swap entry is a compact identifier that encodes which swap device to use
> +and the offset within that device.  When a page is swapped out, its page
> +table entry is replaced with a swap entry so that the kernel knows where to

'Page table entry'... At which level?

> +find the data on a subsequent fault.  Swap entries are also used internally
> +as keys into the swap cache.
> +
> +Swap Devices
> +============
> +
> +A swap device is a disk partition or file registered with the ``swapon()``
> +system call.  Each device is described by a ``swap_info_struct`` that holds
> +the device's extent map, cluster state, and per-CPU allocation hints.
> +
> +The kernel maps virtual swap offsets to disk locations through a tree of
> +``swap_extent`` structures.  For raw partitions the mapping is trivial
> +(one extent covering the whole device); for swap files the mapping follows
> +the file's block layout on disk.
> +
> +Cluster Allocation
> +------------------
> +
> +Swap space is allocated in clusters (groups of contiguous slots, typically
> +32 pages).  Each cluster tracks which slots are free and whether it has
> +pending discards.  Per-CPU hints point to the most recently used cluster
> +so that allocations from the same CPU tend to land in the same cluster,
> +improving spatial locality for both SSDs and spinning disks.
> +
> +When a cluster is full, the allocator scans for a new one.  Under heavy
> +swap pressure, it may also reclaim slots from full clusters if the pages
> +they reference have since been freed or swapped back in.
> +
> +TRIM / Discard
> +--------------
> +
> +For SSD-backed swap, the kernel can issue discard (TRIM) commands when
> +swap slots are freed.  This is batched per-cluster: once all slots in a
> +cluster are free, a single discard is issued for the entire range.  This
> +avoids the overhead of per-page discards while still informing the device
> +that the blocks are unused.
> +
> +Swap counts
> +-----------
> +
> +Each swap slot has a reference count tracking how many page table entries
> +point to it (due to ``fork()`` and copy-on-write).  For slots referenced
> +by very many processes, a continuation mechanism extends the counter
> +beyond its inline capacity.
> +
> +Swap Cache
> +==========
> +
> +The swap cache keeps recently swapped-in (or about to be swapped-out)
> +pages in memory, indexed by their swap entry.  This serves several
> +purposes:
> +
> +- **Deduplication**: when multiple processes share a swapped page (via
> +  ``fork()``), only one copy is read from disk; subsequent faults find
> +  the page in the swap cache.
> +- **Write coalescing**: if a page is modified and swapped out again before
> +  the previous write completes, the swap cache absorbs the update without
> +  issuing a new write.
> +- **Readahead**: when one page is swapped in, adjacent swap entries are
> +  speculatively read to exploit spatial and temporal locality.
> +
> +The swap cache is implemented as a per-cluster array of pointers
> +(the "swap table"), providing O(1) lookup by swap entry.
> +See also Documentation/mm/swap-table.rst.
> +
> +Readahead
> +---------
> +
> +Swap readahead pre-fetches pages from swap before they are faulted in.
> +Two strategies are used:
> +
> +- **Cluster readahead**: reads a window of swap entries around the faulting
> +  entry, betting on spatial locality in the swap device.
> +- **VMA readahead**: uses the virtual address layout to predict which swap
> +  entries will be needed next, which is more effective when the access
> +  pattern follows the process's address space layout rather than the swap
> +  device layout.
> +
> +``vm.page-cluster`` controls the readahead window size (as a power of two).
> +
> +Compressed Swap (zswap)
> +=======================
> +
> +zswap (``mm/zswap.c``) is an optional write-behind compressed cache that
> +sits between the reclaim path and the swap device.  When reclaim evicts a
> +page, zswap attempts to compress it and store the compressed data in a
> +RAM-based pool (using the zsmalloc allocator).
> +
> +If the page is faulted back in before the pool fills, no disk I/O occurs —
> +the page is decompressed directly from memory.  This is significantly
> +faster than reading from even an SSD.
> +
> +Pool Management
> +---------------
> +
> +Each zswap pool pairs a compression algorithm (lzo, lz4, zstd, etc.) with
> +a zsmalloc memory pool.  Per-CPU compression contexts avoid lock
> +contention during compression and decompression.
> +
> +When the pool reaches its size limit (controlled by
> +``/sys/module/zswap/parameters/max_pool_percent``), the oldest entries are
> +evicted: zswap writes them out to the backing swap device, falling back to
> +the normal swap I/O path.  An LRU list tracks entries for this purpose.
> +
> +Writeback
> +---------
> +
> +zswap writeback decompresses the page, allocates a swap slot, and writes
> +the uncompressed page to the swap device.  This is the slow path —
> +ideally most pages are either faulted back in from the compressed cache
> +or freed without ever reaching disk.
> +
> +Zero-Filled Pages
> +=================
> +
> +``mm/page_io.c`` maintains a bitmap (``swap_zeromap``) tracking swap slots
> +that contained zero-filled pages.  When such a page is swapped in, the
> +kernel returns a zeroed page without performing any I/O.  When a zero
> +page is swapped out, the bitmap bit is set instead of issuing a write.
> +This optimization is significant for workloads that allocate large amounts
> +of memory that is never written to.
> +
> +Swap I/O
> +========
> +
> +``mm/page_io.c`` handles the mechanics of reading and writing pages to
> +swap.  The I/O path checks three layers in order before falling through to
> +disk:
> +
> +1. The zero page bitmap — if the slot is known to be zero-filled, return
> +   a zeroed page (read) or set the bit (write) with no I/O.
> +2. zswap — if enabled, attempt to store/load the page in the compressed
> +   cache.
> +3. Block I/O — submit a bio to the swap device, using the swap extent
> +   tree to map the slot to a disk sector.
> +
> +For swap files (as opposed to raw partitions), the I/O follows the
> +filesystem's block mapping rather than issuing direct device I/O.
> --
> 2.53.0
>
>
>

