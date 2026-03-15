Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50FB4F30284
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9221C6B00C0; Sun, 15 Mar 2026 16:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF6E6B00C1; Sun, 15 Mar 2026 16:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB7A6B00C2; Sun, 15 Mar 2026 16:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A30B6B00C0
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:31:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CD0B5CC4C
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:31:42 +0000 (UTC)
X-FDA: 84549443244.20.B33750B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 58D9E20005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:31:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WwRzPuLl;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773606700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1OPbCxJSsCsxEhqRgNfTqZVmOAfOvwGnEk9VCZyTeE=;
	b=7zPb6Liovr8JoxkcvcDsADK3JNwXXQDe71LWybfXYF33e8Jipmyu6e3gJTVxY7NNPQRwBE
	TKu+ceHVyTk5tVLzHuqF15RSn0xioMl2pn5Rs4tmEU3TqaaZ2bL9tNYUaDWLyZ3jswo+0R
	Z/DECKL1Q+NqHbqvMrbFTnE8E3jnuqQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WwRzPuLl;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773606700; a=rsa-sha256;
	cv=none;
	b=PttPtWWYL3M2D2pQfYgXn8mk+dRKEM3xFENo2xNdpbOL5tDnZt3LQIEBTQpM7xJm/lHIRn
	9TjQKjJJBm7i/iECXBFt3XV/TUntbMktr0sRxkBDSesRYRjm2h35HDpYPvk3oM7spODpfn
	0mWmCeYsKbeee9pLHyMWOxaxZPucJL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 234DB4182F;
	Sun, 15 Mar 2026 20:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F0C4CEF7;
	Sun, 15 Mar 2026 20:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773606699;
	bh=Vbd5cPi6DGWcwTyjcTv64Xb+7YxCsKk+bXPAu3e423s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WwRzPuLlxeTz/W+gVhRV4mbUEhu6ulzYBLI6tIheDGHkjifenibuWYbhHtC1KdyCD
	 hJQYukTyf0Qd1ntLiKdk1PtMLfJkbYehGAXFz5aYCvqXtUdpisOZ44OAVKcoCmrDV0
	 nvVsNFvjjdE0OXwT1EQmbwseJkDbnm4yDDXYctQ3YiCLBI69k1VX3a+BXJXA1U3Mg6
	 7Bnj8MWA+c429prsbd8nMyzSSDXSxXM3QpKzavYS2KhVWJLRFA4J5Gl0xfESPQWl0W
	 UBv/1w8LW9UxEQWYrdxPqGNcVt2Zq1qOKKVkHAvJMKH/JjGFsC9Xh5jai1Gxn7/2Xi
	 5ihf2oAPShWGg==
Date: Sun, 15 Mar 2026 20:31:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document Virtually Contiguous Memory Allocation
Message-ID: <9f4d7c12-a01f-4046-91fa-dd70c0d7a564@lucifer.local>
References: <20260314152532.100411-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152532.100411-1-xaum.io@gmail.com>
X-Stat-Signature: obgmpjuqysq5iimnn4w3tmbeioqqpbdq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 58D9E20005
X-HE-Tag: 1773606700-17861
X-HE-Meta: U2FsdGVkX18uwRdwLarZKV48EY0o4aPQjC3+yOCCy3vuBFuk2aT1/+0QRPN2WMfnUK0paJ3Kez82AG2mlt5Mi9lWqmX4QzFLSm/1ytzg72XsA7p31vgpQ+cz2ue7QMI+O5zynDJ3EcAPLANZ725Csb5eerY9SO5Z+bsh00BVl0bh+6DIMZAqnj1vGyWDc/aUKpMOybwy4W0j1JlKml3CTvfXi83qVp6Q7QsyY8xpGUFNem8uPYlIhYFN1+zVjDHJmSysNH2k4Ku9c0F39/9+Y6aF5fLDKPDZe87SnMRraKtyO3Jc7BbZb3BaLI7uiWdnqFOVVwbpEMrLpWEMyF0+NLWu3KdxcckHs9AcRCkATyIkrHhR3TAiYkCuQPTIQFPY5HRnkQCcxMGQmaSHL6oKbdnjhUJsrwjyy7oTkB16KeWdgdjpXAhc15c3fgSO58tVU+D4YcfWmospi3RF+wpWN8yNTeBaWZ48sOr47w6y+B8on3MqrVsRcaBCkfbNp6XTPCGAOgIcGmxH8Rhprmd0i1Vo1/2cD6ZtuKf5JgOYh05yMxx8//aeV1N394C8TMIX7zYtsFJ4qf/ecib9xjoGn/0OEuJg2fEShm0vadRJ+mCYErLbJgHMmpM4zYaVWxvt6/hplkh8GRG/RlHnzeb52InbgkB9IxRjAFotUSAaLN/PfzjAcPxqo2mdANicf2LYb+im31nlNpNQD4L3PQX1EbMHCGNFnnQCCKNKiZAbFqmm8aqk/5oZ/Jv7aROX7qggCKKmhny8HkH0iwyLz7MxZBr+zyXewNmMv4yPiVLHhMDDvljEL+hyPOgS1lI6yH1XtfPjMB4xsOrRlzIgtNhPglDwzSlXV6f6tMoq09mI1HdcsoFUvev9Q5muorJzBl00wLG4BwfVe9U/w3I0GSkVogxkYlEdG7EZRXjQvjEuZIcD32fQcsDb6XiP+ZR1YOr1EnB2qYHvZVdrxtGCCJJ
 KFJ36Uqr
 f0Fg87vI7HAbN4jHZekX5O7rctLG9qUgq/+zj1SNCOhcoE58I2Zs+WXoqonJIPGcpSXkRK690kMbqrsIg133H49+L7XTb2b9hm7rtg9W3WSRW+sHPLP7cW54FDl5lnlMszXTyu15B05yHqRYPhgFKFq/4AF+PjaZdA6YQMo7Pg8poz9nZYUWFG+W5YmiPSFm3QMMb90LPJ06SZavhbMPHhRqfpiVFo3sSvuR1qo7jup5m39aL5QDhtYHnAOf9l+lhacuzySRbUFMJ8nezyCh0pOG2kWda8e4NnBKJRaEH75V6hp+ae9zGW4dWvw6e4iv8IoiuM9gSbeh6sKqw07vWA8qjFlfZBqQkvCpAKWJ3WdqYlU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK because AI slop again obviously.

BTW we don't capitalise the first letter of subject lines. Even 5 minutes
glance at the mailing list would tell you that, and it's _yet more_
evidence for this being low-effort AI slop.

Even the patch subject line screams LLM-generated - and why are you
capitalising it as if vmalloc is abbreviated VCMA?...

Again you've not looked up who to cc- for this, you've got Claude to
generate a useless commit message so you demonstrate no understanding, the
documentation is pointless handwaving, etc.

On Sat, Mar 14, 2026 at 04:25:32PM +0100, Kit Dallege wrote:
> Fill in the vmalloc.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.
>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/vmalloc.rst | 128 +++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>
> diff --git a/Documentation/mm/vmalloc.rst b/Documentation/mm/vmalloc.rst
> index 363fe20d6b9f..2c478b341e73 100644
> --- a/Documentation/mm/vmalloc.rst
> +++ b/Documentation/mm/vmalloc.rst
> @@ -3,3 +3,131 @@
>  ======================================
>  Virtually Contiguous Memory Allocation
>  ======================================
> +
> +``vmalloc()`` allocates memory that is contiguous in kernel virtual address
> +space but may be backed by physically discontiguous pages.  This is useful

May be backed?...

> +for large allocations where finding a contiguous physical range would be
> +difficult or impossible.  The implementation is in ``mm/vmalloc.c``.

Is this the only time we use it?

Kernel stacks are vmalloc()'d but a grep shows 0 results.

Also kvmalloc() shows zero results.

This is just useless AI slop handwaving that would need a total rewrite by
maintainers, so what use is this 'contribution'?

> +
> +.. contents:: :local:
> +
> +How It Works
> +============
> +
> +A vmalloc allocation has three steps: reserve a range of kernel virtual
> +addresses, allocate physical pages (individually, via the page allocator),
> +and create page table mappings that connect the two.
> +
> +Virtual Address Management
> +--------------------------
> +
> +The kernel reserves a large region of virtual address space for vmalloc
> +(on x86-64 this is hundreds of terabytes).  Within this region, allocated

I love that you (read Claude) are vague about 'hundreds of terabytes', you
can literally see how much for 4 level and 5 level page tables...

Etc. etc.

> +and free ranges are tracked by ``struct vmap_area`` nodes organized in two
> +red-black trees — one sorted by address for the busy areas, and one
> +augmented with subtree maximum gap size for the free areas.  The augmented
> +tree allows free-space searches in O(log n) time.
> +
> +Each allocated area also has a ``struct vm_struct`` that records the
> +virtual address, size, array of backing ``struct page`` pointers, and flags
> +indicating how the area was created (``VM_ALLOC`` for vmalloc,
> +``VM_IOREMAP`` for I/O mappings, ``VM_MAP`` for vmap, etc.).
> +
> +Guard Pages
> +-----------
> +
> +By default, each vmalloc area is surrounded by a guard page — an unmapped
> +page that causes an immediate fault if code overruns the allocation.  This
> +costs one page of virtual address space (not physical memory) per
> +allocation.  The ``VM_NO_GUARD`` flag disables this for internal users that
> +manage their own safety margins.
> +
> +Huge Page Support
> +-----------------
> +
> +On architectures that support it, vmalloc can use PMD- or PUD-level

Yeah no need to mention what PMD or PUD are...

> +mappings instead of individual PTEs, reducing TLB pressure for large
> +allocations.  ``vmalloc_huge()`` requests this explicitly.  The decision
> +is per-architecture: each architecture provides callbacks
> +(``arch_vmap_pmd_supported()``, ``arch_vmap_pud_supported()``) to indicate
> +which levels are available.
> +
> +Even when huge pages are requested, the allocator falls back to base pages
> +transparently if the physical pages cannot be allocated at the required
> +alignment.
> +
> +Lazy TLB Flushing
> +-----------------
> +
> +Unmapping a vmalloc area requires a global TLB flush (IPI to all CPUs) to
> +ensure no stale translations remain.  To amortize this cost, vmalloc defers
> +the flush: page table entries are cleared immediately but the TLB
> +invalidation is batched across multiple frees.  The flush is forced when
> +the free area needs to be reused or when ``vm_unmap_aliases()`` is called
> +explicitly.
> +
> +Per-CPU Allocations
> +-------------------
> +
> +The per-CPU allocator uses vmalloc internally to obtain virtually
> +contiguous backing for per-CPU variables across all CPUs.  It allocates
> +multiple vmalloc areas with specific size and alignment requirements in a
> +single call, ensuring that each CPU's copy is at a consistent offset from
> +the per-CPU base.
> +
> +vmap and Temporary Mappings
> +===========================
> +
> +Besides vmalloc (which allocates both virtual space and physical pages),
> +the subsystem provides two related mechanisms:
> +
> +- **vmap/vunmap**: maps an existing array of ``struct page`` pointers into
> +  contiguous kernel virtual space.  This is used when pages have already
> +  been allocated (e.g., by a device driver) and just need a contiguous
> +  kernel mapping.
> +
> +- **vm_map_ram/vm_unmap_ram**: lightweight temporary mappings for
> +  short-lived use, with lower overhead than full vmap.
> +
> +Freeing
> +=======
> +
> +``vfree()`` can be called from any context, including interrupt handlers.
> +When called from interrupt context the actual work (page table teardown,
> +TLB flush, page freeing) is deferred to a workqueue.  This is safe because
> +the virtual address range is immediately removed from the busy tree, so no
> +new mappings can be created in the freed region.
> +
> +Page Table Management
> +=====================
> +
> +vmalloc maintains its own kernel page tables to map virtual addresses to
> +the backing physical pages.  On allocation, page table entries are created
> +at the appropriate level (PTE, PMD, or PUD depending on huge page support).
> +On free, the entries are cleared.
> +
> +The page table setup must handle architectures where the kernel page tables
> +are not shared across all CPUs.  On such systems, a vmalloc fault mechanism
> +lazily propagates new mappings: when a CPU accesses a vmalloc address for
> +the first time and takes a fault, the fault handler copies the page table
> +entry from the reference page table (init_mm) into the CPU's page table.
> +
> +NUMA Awareness
> +==============
> +
> +By default, vmalloc allocates physical pages from any NUMA node.  The
> +``vmalloc_node()`` and ``vzalloc_node()`` variants prefer a specific node,
> +which is useful for data structures that are predominantly accessed from
> +one node.  The pages are still mapped into the global kernel virtual
> +address space, so they remain accessible from all CPUs regardless of
> +which node they were allocated from.
> +
> +KASAN Integration
> +=================
> +
> +When KASAN (Kernel Address Sanitizer) is enabled with
> +``CONFIG_KASAN_VMALLOC``, vmalloc allocates shadow memory to track the
> +validity of each vmalloc region.  The shadow memory is itself vmalloc'd
> +and mapped lazily.  This allows KASAN to detect out-of-bounds accesses
> +and use-after-free bugs in vmalloc'd memory, which is particularly useful
> +for catching bugs in kernel modules (whose code and data are vmalloc'd).
> --
> 2.53.0
>
>
>

