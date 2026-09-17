Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AEFBC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 12:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5085D6B0092; Thu, 17 Sep 2026 08:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4930F6B0093; Thu, 17 Sep 2026 08:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35ADE6B0095; Thu, 17 Sep 2026 08:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04BCB6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:17:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73A621A033D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:17:51 +0000 (UTC)
X-FDA: 85223155542.29.52F5B30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B64A1120006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:17:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Njx07hck;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789647469;
	b=gLzJph9IPw/vMSSeHBU0uf1hP+gBu5Ts5qTjKnLiVidLzZrtKMV3RNaVhNoT6rex+Nv6vK
	zRaA8rncFvq6Z72nVWMmI1ZryBYNOye7ti3UM2sHdwOfUB4lzQbst2OOAU8J6vQCXzqQLN
	wnBow2J+SuDvskOLKb+pdFXnvnaV7OE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Njx07hck;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789647469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOOzTPdyID81NX0koAIo9zSwLIv7kFZJDzGrlHzgqSw=;
	b=BynjaEE51LJaMqyMo92BaQYMchgkNAzqptXN2WDzBPF+l6qPCglO6zIwNcopHup4r1A+ae
	dP3R++C299tADi17g9x3QBfmOENGEnZe503Ht4rNy04vVTQkps/W/CLVvt2shtGCAjc0tS
	W0HWBpsI3QuJT5F14rIZo9pYFQ9tEXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 392BD601EF;
	Thu, 17 Sep 2026 12:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABF81F000FF;
	Thu, 17 Sep 2026 12:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647468;
	bh=AOOzTPdyID81NX0koAIo9zSwLIv7kFZJDzGrlHzgqSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Njx07hck84rGiz/f7uEQpowoJ1UK2pk/RdC7+xZNWVVVIPIgZXU6wen3Q3TH0hiFy
	 fPcgf4mFQ0eYKlUEC9+P5piru04E4s/KxgUAqs8YOhWGrzizJjAN3zPZd837aWodPw
	 CwM6BuSKlEMi0OGNds9P/r+aEGjMkT3lKdZsDSkdqU6bTTj8FFPyQtQTeH69tVbmJ7
	 8K7noJolv/8QY4r+GOTgRaETMMkCShiFi32aHVnRQv5cITzTyQosmQ4UVO8qk5etdW
	 UprNPUuzv9da1PeSdNv49zEFsWW+bvdmOHAq/tRZ5heYgP1o3qG305lLkFtzLvNmX3
	 TDhizqOwqcvRg==
Message-ID: <493ef264-eab3-4be3-a80e-357f01ae1b37@kernel.org>
Date: Thu, 17 Sep 2026 14:17:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
 leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B64A1120006
X-Rspam-User: 
X-Stat-Signature: hfxihacb6mq7gm3xkkprdqu6m7ukqjqn
X-HE-Tag: 1789647469-372045
X-HE-Meta: U2FsdGVkX18uvjO5vc8DaQHviGnQM8zEM1eztOUWQMj3l5/fbQHH5EtfPOvj39XuWUTzTjA9DqZK/cuKA6ckg4bY2lCuh39iZxXKp9BQpWvGR+o5wULVIehM93E8WAjE8rNvmdhs/tHUp46BQOHLhHgOybfvwJFjMTj5R36D5TwESlg5DMjp1y+K77dynOwMRTN7Qr/ro696kvVnIknHMtLdHy3uO60ABZNMDm7ia5AAKGMG4SA1yxGvVdlSeRGlrnsk+WTq/QnxOnfUp3nUlLEs9bJG+baf0sl9c461w+Nz5iF9FYgKWf7EZmvEfPNptRvGzFa5Y1PcSlO4OAlelfuZb9KatojXvkOqr2HAYz1mSlD1r/G547kn+ThJ950BsdMCqT5s8ESXIWsUlTs/G8SrZfqt8VJFmmhNyWlJx87FGZq3oBFBAWkL6BJ0SeSh3bmeglrLhErphP5+dFyTe9F016eshzuXHN9cPzBN8t6mM+fzNKDax1zWIN+UNO/1ZKknYpj1Cbio8rx4QOTEC1mv38goCIOx1BJS7FCUvo/xjZgzYUypR6XFgPJR7PXzGyaY38vY83e7dUDJzMLrup4In4T+dsOTg5J32eD+TsfS4KIwGSYwyi3XBhby2cNwRdA/gRrQDRseJGOXYcwpmBj3NmNzXxGjtP6qlagcwYq3ue8rnbldQQycmtf6ULswy9rtW/E+29BlfRXSefkcqLkPal0nFxCV4FahBa6XSmJQlPzzP4DyR1d4cqfFIDotxKdhvdBAHcJm0FwHjQhkMX1DrU6jUcu7VKd9FQ+s/2PQhZm+YAGLXKKiCL7LVFL6T2b7s8A/IP3kECE9oeSGGZj1Kxls4QMxoq74PFIdwFZbuRYZez+lkG+LEIiYUEDPaVmO0NdYiwQyzXcOsQLeZoLtzQox9ZJKfKjjDI6IumR7dI+IuUKhnm/gGpkOE20EylBIjoWuB/FnxRSq40B
 arOmudzW
 tkjwMwPcYolMEj0LGKdUPcteGapQuM4h1g9ckpug/RDMmezLC/ZPeloBIsrNT6NCCsu6sqiJhYqvbeaVuX5ncRvqbXhYykR2XmopkZB72GpfOq93gVpMHjMJUyUfZPU/8sNm+xtYRZzZgqsviN9eVX5oX2uL/PjKM+AVObOzJ/K9Gan+/d3TedzXtxOkzzNW0pI+LPEigo4HKVkSLhkMgDZ/UH4YXpiMX3TTMoabitSWc93GTwNn9doizziL8XveUOTYMtQ8oKsJq/pbX7JNDIV/yYruK5KB88cM86cS7EXRj4HsePAYjl+EvrLVZVptmhwxahTwiiTftlCglpsaxbpuQ0YzBf+PyNSSlZrK6XmlhLEasopTtL9Ho/MAwfH5fXHc9nBQ2cqcTtK9eWijp1Fysjh0DVbDb+v0RuiluIdXDXmwOsuObykAAZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Le 17/09/2026 à 07:29, Wen Jiang a écrit :
> From: Wen Jiang <jiangwen6@xiaomi.com>
> 
> This patchset accelerates ioremap, vmalloc, and vmap when the memory is
> physically fully or partially contiguous. Two techniques are used:
> 
> 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
>     segments
> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>     layers
> 
> Besides accelerating the mapping path, this also enables large
> mappings (PMD and cont-PTE) for vmap, which are currently not
> supported.

This series doesn't apply. I tried to apply it on top of v7.2, v7.3-rc3 
and next-20260916

Can you tell how to apply it ?

$ LANG= b4 shazam -l 20260917052933.188679-3-jiangwenxiaomi@gmail.com
Grabbing thread from 
lore.kernel.org/all/20260917052933.188679-3-jiangwenxiaomi@gmail.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 11 messages in the thread
Analyzing 41 code-review messages
Checking attestation on all messages, may take a moment...
---
   ✓ [PATCH v8 1/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-2-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 2/10] powerpc/8xx: add pte_set_huge()
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-3-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 3/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge() for 
PTE-level block mappings
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-4-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 4/10] arm64/hugetlb: drop the init_mm special case in 
clear_flush()
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-5-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 5/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size() 
to batch multiple CONT_PTE
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-6-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 6/10] mm/vmalloc: extract vmap_set_ptes() to consolidate 
PTE mapping logic
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-7-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 7/10] mm/vmalloc: extend page table walk to support 
larger page_shift sizes and eliminate page table rewalk
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-8-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 8/10] mm/vmalloc: extract vm_shift() to consolidate 
mapping shift selection
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-9-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 9/10] mm/vmalloc: map contiguous pages in batches for 
vmap() if possible
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-10-jiangwenxiaomi@gmail.com
   ✓ [PATCH v8 10/10] mm/vmalloc: align vm_area so vmap() can batch mappings
     + Link: 
https://lore.kernel.org/r/20260917052933.188679-11-jiangwenxiaomi@gmail.com
   ---
   ✓ Signed: DKIM/gmail.com
---
Total patches: 10
---
NOTE: some trailers ignored due to from/email mismatches:
     ! Trailer: Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
      Msg From: Barry Song <baohua@kernel.org>
NOTE: Rerun with -S to apply them anyway
---
Applying: arm64/mm: add pte_set_huge() and pte_clear_huge()
Patch failed at 0001 arm64/mm: add pte_set_huge() and pte_clear_huge()
error: patch failed: arch/arm64/mm/mmu.c:1872
error: arch/arm64/mm/mmu.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am 
--abort".
hint: Disable this message with "git config set advice.mergeConflict false"


Thanks
Christophe


> 
> Patches 1-4 decouple the PTE-level block mapping path from HugeTLB.
> Previously vmap_pte_range() installed cont-PTE mappings by reusing
> set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
> helpers gated by CONFIG_HUGETLB_PAGE. This made the feature silently
> unavailable on CONFIG_HUGETLB_PAGE=n kernels, and coupled mm/vmalloc.c
> to HugeTLB internals. Patches 1 and 2 add the arm64 and powerpc/8xx
> implementations of pte_set_huge()/pte_clear_huge(), which join the
> existing pmd/pud_set_huge() family. Patch 3 adds the generic fallbacks
> and converts mm/vmalloc.c over. Patch 4 then removes the now-dead
> init_mm special case from arm64's clear_flush().
> 
> Patch 5 extends ARM64 arch_vmap_pte_range_map_size() to batch multiple
> CONT_PTE blocks in one call instead of one at a time.
> 
> Patch 6 extracts a common helper vmap_set_ptes() that consolidates PTE
> mapping logic for the ioremap and vmalloc/vmap paths, handling both
> CONT_PTE and regular PTE mappings. This prepares for the next patch.
> 
> Patch 7 extends the page table walk path to support page shifts other
> than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
> mappings. The function is renamed from vmap_small_pages_range_noflush()
> to vmap_pages_range_noflush_walk().
> 
> Patch 8 extracts vm_shift() to consolidate vmalloc mapping shift
> selection for reuse in the batching path.
> 
> Patches 9-10 add huge vmap support for contiguous pages, including
> support for non-compound pages with pfn alignment verification.
> 
> On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> the performance CPUfreq policy enabled, benchmark results:
> 
> * ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
> * vmalloc(1 MB) mapping time (excluding allocation) with
>    VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53 us)
> * vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)
> 
> Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.
> 
> Large vmap() mappings were also tested by Leo Yan with ARM trace buffer
> units, including TRBE and SPE. These units use the CPU page tables for
> address translation when writing trace data to DRAM, so using larger
> vmap() mapping granules can reduce TLB pressure on the trace writer.
> 
> The TRBE test used a 1G CoreSight ETM AUX buffer. Across five runs on an
> isolated CPU, the average results were:
> 
> * dtlb_walk:       68.4 -> 59.4 (-13.16%)
> * l1d_tlb_refill: 155.8 -> 119.6 (-23.23%)
> * l2d_tlb_refill: 161435.8 -> 495.0 (-99.69%)
> 
> The SPE test used a 512M ARM SPE AUX buffer. Across five runs on an
> isolated CPU, the average results were:
> 
> * dtlb_walk:       1710.4 -> 1315.6 (-23.08%)
> * l1d_tlb_refill: 16000.0 -> 15950.2 (-0.31%)
> * l2d_tlb_refill: 4796.0 -> 2931.2 (-38.88%)
> 
> These results show that enabling larger vmap() mappings can materially
> reduce page table walks and TLB refills for large trace buffers.
> 
> Many thanks to Leo Yan for his testing efforts on ARM trace buffers.
> 
> Changes since v7:
> - v7's patch 1 (which extended the hugetlb helpers in
>    arch/arm64/mm/hugetlbpage.c) is replaced by pte_set_huge()/
>    pte_clear_huge(), split across patches 1-3 so that the arm64,
>    powerpc/8xx and generic changes can be reviewed and acked
>    independently: patch 1 is arm64 only, patch 2 is powerpc/8xx only,
>    patch 3 is the generic fallbacks plus the mm/vmalloc.c conversion.
>    hugetlbpage.c no longer gains the CONT_PTE batching hooks, and patch 4
>    additionally removes its now-dead init_mm special case. mm/vmalloc.c
>    no longer includes <linux/hugetlb.h>.
> - The generic pte_set_huge()/pte_clear_huge() fallbacks WARN_ON_ONCE()
>    instead of silently doing nothing. They only exist to keep the build
>    working on architectures without PTE-level block mappings, where they
>    are unreachable (patch 3).
> - Patch 5 (v7 patch 2): use round_down(size, CONT_PTE_SIZE) instead of
>    rounddown_pow_of_two(size), since pte_set_huge() takes the size directly
>    without an ilog2() roundtrip. This lets a single call span several
>    CONT_PTE blocks: a 768K (512K + 256K) ioremap is now 1.25x faster than
>    v7.
> - Patch 6 (v7 patch 3): vmap_set_ptes() now calls pte_set_huge() instead
>    of the hugetlb path.
> - Patch 9 (v7 patch 6): get_vmap_batch_order() takes pages+i instead of a
>    separate idx argument, and applies pfn alignment limit to scan length
>    rather than to the resulting order. Renamed idx/map_addr to
>    batch_idx/batch_start. Dropped Dev's Reviewed-by.
> 
> Changes since v6:
> - Add a clarifying comment about the reuse of hugetlb helpers
>    by non-hugetlbfs(vmalloc) mm code (patch 1)
> - Expand the arm64/vmalloc commit message and comment to clarify that
>    multi-CONT_PTE_SIZE values are vmalloc mapping spans, not HugeTLB
>    hstate sizes (patch 2)
> - Move the local steps variable change in vmap_pte_range() into the
>    vmap_set_ptes() extraction patch (patch 3)
> - Propagate vmap_pages_pte_range() errors through the upper
>    vmap_pages_*() levels instead of returning -ENOMEM for all failures
>    (patch 4)
> - Add a preparatory vm_shift() helper patch before the batching patch
>    (patch 5)
> - Guard the PFN alignment clamp in get_vmap_batch_order() against PFN 0
>    before calling __ffs() (patch 6)
> - Fix kmsan_vmap_pages_range_noflush() indentation in the batching path
>    (patch 6)
> 
> Changes since v5:
> - No code changes.
> - Pick up Reviewed-by and Tested-by tags from Dev, Leo and Uladzislau.
>    Many thanks!
> - Add TRBE/SPE large vmap() test results from Leo Yan to the cover
>    letter.
> 
> Changes since v4:
> - Move pgsize update before contig_ptes check (patch 1)
> - Use rounddown_pow_of_two instead of __fls in
>    arch_vmap_pte_range_map_size (patch 2)
> - Reword comment to avoid mentioning cont_pte and remove if in
>    vmap_set_ptes (patch 3)
> - Rename vmap_batched() to vmap_pages_range_batched() (patch 5)
> - Use batch_end as the batching cursor to avoid an unused start variable
>    (patch 5)
> - Check arch_vmap_pmd_supported before PMD mapping (patch 6)
> 
> Changes since v3:
> - Squash vmap_pte_range() loop variable fix into patch 4 (patch 3, 4)
> - Use shift >= PMD_SHIFT and fix *nr increment in
>    vmap_pages_pmd_range() (patch 4)
> - Pass page_shift directly without capping at PMD_SHIFT (patch 4, 5)
> - Add vm_shift() helper and pass pgprot_t to get_vmap_batch_order()
>    (patch 5)
> - Use min(order, __ffs(pfn)) for graceful pfn alignment degradation,
>    replacing IS_ALIGNED check (patch 5)
> - Remove irrelevant ioremap_max_page_shift early-exit (patch 5)
> - Add __get_vm_area_node_aligned_caller() wrapper, rename to
>    vmap_get_aligned_vm_area() (patch 6)
> 
> Changes since v2:
> - Use __fls instead of fls in arch_vmap_pte_range_map_size (patch 2)
> - Add WARN_ON checks in vmap_pages_pmd_range (patch 4)
> - Fix flush_cache_vmap to use saved start address instead of the
>    already-advanced addr (patch 5)
> - Rename __vmap_huge() to vmap_batched() (patch 5)
> - Add caller parameter and unroll while(1) loop (patch 5)
> - Squash patch 7 into patch 5 (stop scanning for compound pages after
>    encountering small pages)
> 
> Changes since v1:
> - Fix condition order and use PMD_SIZE instead of CONT_PMD_SIZE in
>    patch 1 (Dev Jain)
> - Squash patch 3+4 and patch 5+7 (Dev Jain)
> - Replace "zigzag" with "page table rewalk" in commit messages
>    (Dev Jain)
> - Rename vmap_small_pages_range_noflush() to
>    vmap_pages_range_noflush_walk() (Dev Jain)
> - Extract vmap_set_ptes() as a new patch to consolidate PTE mapping
>    logic between vmap_pte_range() and vmap_pages_pte_range(), handling
>    both CONT_PTE and regular mappings (Mike Rapoport)
> - Support non-compound pages in get_vmap_batch_order() by falling
>    back to physical contiguity scanning with pfn alignment check
>    (Dev Jain, Uladzislau Rezki)
> - In get_vmap_batch_order(), filter out orders that the architecture
>    cannot batch by checking arch_vmap_pte_supported_shift() directly.
>    This avoids overhead for orders 1-3 on ARM64 CONT_PTE with 4K
>    pages. (patch 5)
> 
> Barry Song (Xiaomi) (4):
>    arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple
>      CONT_PTE
>    mm/vmalloc: extend page table walk to support larger page_shift sizes
>      and eliminate page table rewalk
>    mm/vmalloc: map contiguous pages in batches for vmap() if possible
>    mm/vmalloc: align vm_area so vmap() can batch mappings
> 
> Wen Jiang (6):
>    arm64/mm: add pte_set_huge() and pte_clear_huge()
>    powerpc/8xx: add pte_set_huge()
>    mm/vmalloc: use pte_set_huge()/pte_clear_huge() for PTE-level block
>      mappings
>    arm64/hugetlb: drop the init_mm special case in clear_flush()
>    mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
>    mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
> 
>   arch/arm64/include/asm/pgtable.h             |   6 +
>   arch/arm64/include/asm/vmalloc.h             |   8 +-
>   arch/arm64/mm/hugetlbpage.c                  |   5 +-
>   arch/arm64/mm/mmu.c                          |  19 ++
>   arch/powerpc/include/asm/nohash/32/pte-8xx.h |   4 +
>   arch/powerpc/mm/nohash/8xx.c                 |  29 ++
>   include/linux/pgtable.h                      |  29 ++
>   mm/vmalloc.c                                 | 268 ++++++++++++++-----
>   8 files changed, 300 insertions(+), 68 deletions(-)
> 


