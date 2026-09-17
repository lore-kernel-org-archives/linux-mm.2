Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412BAC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CFE6B008A; Thu, 17 Sep 2026 01:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0736B008C; Thu, 17 Sep 2026 01:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE876B0096; Thu, 17 Sep 2026 01:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E752D6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:29:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36E9A80234
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:29:49 +0000 (UTC)
X-FDA: 85222127298.21.D92B8C5
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B65C1C0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:29:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvVHEflY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789622987;
	b=H+zFxsBD/VbCihMuoFXtkcsWSWjdg2aew2pgx668rYLVhzJgwi89ydw/mf1AlxnwljEDRR
	FFtla3rjwV7rDPE++UDdjKqRTaB5Pwlx5u47ZYMQxIZaSbnh91RmzckQcor+keanwIHVJc
	dnt1x4OXMyYORuoBNPl/grmZzV7B0Zo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvVHEflY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789622987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r+W2BgF0JXvbhEnB5mATNx7NuZIAwz407+caeqGwqIQ=;
	b=Q6CsibLMXS/QyAoeGBIjlUf87MkL5xZE7I8TjCcUhGfBP4FlfMly0cDVJNIMVGuRjIojDl
	Rtr225W5bQ8oZtryluepkrublLyRzbKqu5YULgQETIeVaLfIsrtZEOx4G+Hn7DF1Hna1Nt
	+lg+z+Qk35HhU/LG9yf4c60oTQUrxlc=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39b5b07ec78so308644a91.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789622986; x=1790227786; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r+W2BgF0JXvbhEnB5mATNx7NuZIAwz407+caeqGwqIQ=;
        b=HvVHEflYNTe1cVNrfmEpuNpGgx4oBxYScQV16TMTF/zReLPqhJP3avWI3GV3jF8yjF
         4WeqHaFjBDDXB4YAiSdEh2GPqImkSWR5eCkPonuHgtTZ2Upkib9GGU0qk7Km3UWcocml
         OpVa6T746ZykeMoz9iQkbdAwpK6QW7ucneCH6d3Bwv2dc0TxUICoZUhbO4HCwQk9U72w
         WIAxMOsikOMKDh8xC4KbarLfCHjFYec5HRFHgCegDfdCoMy79FRSDcQDKyIAfKdhhmwh
         Vccvle2zVYjqrbf8rCHuyRwASYPYml1l53fTjBXPsSLvjeUtrVlvvWtIC6dJW53PcPyS
         Ny1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789622986; x=1790227786;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r+W2BgF0JXvbhEnB5mATNx7NuZIAwz407+caeqGwqIQ=;
        b=bUyxauX3ezjwx8riFCOomytX6ZKFe07nw5J8/KLf5XlTv46I4G/TbV/CloSEKocYTJ
         x7p2Qg5vCfEpn42g99hIFc50pV7SDRE8TANd3UUb3Q/Ev8zj/Q2hz2jgjZFnP9kMRFAq
         f5VyC35ao7yozanpvWjJP4GQrjs9KIImqvDVc6vmyJh7GMxuOqPql3RuApjWQy5wdInp
         geKATV4Co30Mxt3HzlbD/M3HKoBhY30CUXvYfdE5nr77IJMCvgU7z/6jm81bMM2BzK3+
         MPpmHO9wHbyOOwQLGPOERd9qP/oIP2gQuW2M7DujY+US+BW7IoGYLLN06hxwyvlxNwOO
         3qJw==
X-Forwarded-Encrypted: i=1; AKwUvBxjnxxOTgFYPeSuoEu0207bn2O8gi4UCTi7X9DKjnHzwZ7/Q6qTJryaNK8nq6pcy1AtWkrKnsxw3Q==@kvack.org
X-Gm-Message-State: AFuF++lzG/O+EdZHTYiKpOkTBMT35/ToYTQ9GPClfAmHjERPPkBY8OVX
	yZanWwAD/Xu5Kj7BapesT9/7X26jhpp3/lvDfKK07N+zMR7otXHLv6Ys
X-Gm-Gg: AYBFou0KW/dvcIPdO2lEoetw3fNlZNUjDvEKPHsN1HWndR85CIuPxR62ovlZB3IobtY
	b38gTfZ9KT72JlVH6IjWYylN1gNTl7xkHMdYuk2CgkhVtBrKHV1g0fQJhKTJYsrSi767AYwmJ5p
	YlDEdt1+EPQSmQEgvsU2931Owk3rl8hAzTwOtK/SHdg5gXDyfJbHSIf/MCqy7E4Uk2FKXtGHyHS
	JJhyxUp+U8rz6ZLTxN0bjcZxTDgvY6BjCCGGkXq23ej3Zqp4xkbAwD9drCe6khiuqV0wqA+EH8b
	cIJiMqGp5WAqzbsHi2wvZCf+F4pFbuZdqH8QekK0UkpWPm6TNwoFYLRjAAsEV9K5o08MRsAgyGU
	CyqlHTZUBFUxYIl8V4txS6r5zn23b4SMqIBRbaCL7CSaKLKrlcOwPT90Md8kdv/FyPkzy3COICI
	Jw7cSJE8Kmlsj6dBsRcMvjJhV3CLHi+JNJrYf+Fuq0AgE2niSkvXr964uUqEOsY1oViJjpdodwb
	SX8YyM4rHWCeQJtxorpM2loVnQ=
X-Received: by 2002:a17:90b:280a:b0:39d:fcbe:fdcf with SMTP id 98e67ed59e1d1-39e1e2659a8mr13162798a91.1.1789622986129;
        Wed, 16 Sep 2026 22:29:46 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:29:44 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v8 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Thu, 17 Sep 2026 13:29:23 +0800
Message-Id: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B65C1C0004
X-Stat-Signature: yodh8hdym9f95hm58hwnh5z65ye4aokd
X-HE-Tag: 1789622987-277998
X-HE-Meta: U2FsdGVkX19V6AAfCxKcHa3YCkEi7VtDoNdGpY2ozi7fSRGyOMRy7rODNCjbDu8lXLWk3i+Jm4MZ72Wz97PE2SamAZgFbKuR0+WnYdr0e+51o0jbrYvUmwVXFIfL7Xbr4bYFZSp7kfsmC/SZbjzMfm4hts44hqzCWHlSlTigo8ZU8BI0R0kYjk2pvWbDaD9EZP4bqMRB9ZniVsMbhPq0Uic1JUsAx0HVv6n8/gU54Cdfy/yEvKraCoHJ3hfW8If/yTQkzEkisYxIpX2RgKxi/sMZHjnJVfRj+WVngdlYgHszskwqGD6/QgOzGugKbqZUKYy6w8+vcnOvJjUAeWDF6pezSR5xh/Z8yobg4dACWmvClGx4RdE88XUT4emJmTY0zmOL4+mm3yikiAvcD9RsAhEEQmtWzv5uaVKdgPZWmewiLMR8yeFNZIWBXBN1K6IM456I7679pGNltoDc+PKiouGUQAt9aTNlW9Ey66YxMhrjv0HaQLRvGaWb7rfFOItYdVtIEr9sJeiQ4j1Q0JzY0KLMY/RY5Jzc4uF2by9qbD97d5+8AumqeJCCWNa1SUaNmvhiOeMwT8A+50GvkmZeipRdwd7HvpfsL7sbCTlxCeBEHBmrzFqJbpI02k66X7rO9msv6sb9nZTIX+2hgP2T+jNmr2LcyyzbYvKX984Xxdzd6QTeqoos/8hYlbKsJnq10t4Y1EgT+EhLgSGN17ALk8+sxomejg/FA31o3imacyPlDiqSxMKHqB5o/zT+upus9lTzUZc4MmhoPj/a0/f5dBXR4pC1LrruvpMZKQO0l7cm0yNAclLqBW5WdoBg0MDiI3z+Ytg7dqLrSyl9zziFpoRJetr+3OG8TTuEJ1KkrJWJnO+ae/kchTvWJmHoO+PRJoGDIhdh5e85BvBwx8AHFpqijDvCq0XXYmuaSTYqSJu2U6mgNWYVvYbWKe/fwFCRUSSA/S46vYAKEqtxWfL
 ULeav4Dx
 rfo/0IHhpdu1u7EB8twv9GmTxzPd8QVQNheuImj/7czKra0Yxe9aQQrDJIIevZUolER7lA3LlQ/pkXsFD+PYlY75we7RvG0fryst6pT8KgmlIVjNwz/IbqH0QWWlBOrmkyz5rBMG8am2nUAs4q8RNJH2DrsI868PTDpXZhNYk2lWyUaQNEperuXR2dOJKi5QqD4CAGqV22nLwEjFOiLLdFFaRL64Mv5CGh0asBHaRwKBl0tbCOWkfVng1O6BDOeilhd1K4PNOxT7dkp5HPV0ihUerUzWDDcyjxJgwKVBrRepecACtfnzmAAePTcxm107WLN6Q7Py1EE/AW3+fHCgB4HnI1OWqT8ZghFgIgleAVBvfQ2x5p+CwJlqd5O3tppOzgvan/6vLdzAMF2uAVH54Z2bxUQr8AkztUeWZyJEOkU3VcyIQimBNfScpBMsc6A5R0pxbY6tSaWL+BrSB7YiKQUaMpoHN5BsDcaePVmVihdOImKxckU3dAa+E/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

This patchset accelerates ioremap, vmalloc, and vmap when the memory is
physically fully or partially contiguous. Two techniques are used:

1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
   segments
2. Use batched mappings wherever possible in both vmalloc and ARM64
   layers

Besides accelerating the mapping path, this also enables large
mappings (PMD and cont-PTE) for vmap, which are currently not
supported.

Patches 1-4 decouple the PTE-level block mapping path from HugeTLB.
Previously vmap_pte_range() installed cont-PTE mappings by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This made the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels, and coupled mm/vmalloc.c
to HugeTLB internals. Patches 1 and 2 add the arm64 and powerpc/8xx
implementations of pte_set_huge()/pte_clear_huge(), which join the
existing pmd/pud_set_huge() family. Patch 3 adds the generic fallbacks
and converts mm/vmalloc.c over. Patch 4 then removes the now-dead
init_mm special case from arm64's clear_flush().

Patch 5 extends ARM64 arch_vmap_pte_range_map_size() to batch multiple
CONT_PTE blocks in one call instead of one at a time.

Patch 6 extracts a common helper vmap_set_ptes() that consolidates PTE
mapping logic for the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings. This prepares for the next patch.

Patch 7 extends the page table walk path to support page shifts other
than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
mappings. The function is renamed from vmap_small_pages_range_noflush()
to vmap_pages_range_noflush_walk().

Patch 8 extracts vm_shift() to consolidate vmalloc mapping shift
selection for reuse in the batching path.

Patches 9-10 add huge vmap support for contiguous pages, including
support for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
the performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53 us)
* vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Large vmap() mappings were also tested by Leo Yan with ARM trace buffer
units, including TRBE and SPE. These units use the CPU page tables for
address translation when writing trace data to DRAM, so using larger
vmap() mapping granules can reduce TLB pressure on the trace writer.

The TRBE test used a 1G CoreSight ETM AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       68.4 -> 59.4 (-13.16%)
* l1d_tlb_refill: 155.8 -> 119.6 (-23.23%)
* l2d_tlb_refill: 161435.8 -> 495.0 (-99.69%)

The SPE test used a 512M ARM SPE AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       1710.4 -> 1315.6 (-23.08%)
* l1d_tlb_refill: 16000.0 -> 15950.2 (-0.31%)
* l2d_tlb_refill: 4796.0 -> 2931.2 (-38.88%)

These results show that enabling larger vmap() mappings can materially
reduce page table walks and TLB refills for large trace buffers.

Many thanks to Leo Yan for his testing efforts on ARM trace buffers.

Changes since v7:
- v7's patch 1 (which extended the hugetlb helpers in
  arch/arm64/mm/hugetlbpage.c) is replaced by pte_set_huge()/
  pte_clear_huge(), split across patches 1-3 so that the arm64,
  powerpc/8xx and generic changes can be reviewed and acked
  independently: patch 1 is arm64 only, patch 2 is powerpc/8xx only,
  patch 3 is the generic fallbacks plus the mm/vmalloc.c conversion.
  hugetlbpage.c no longer gains the CONT_PTE batching hooks, and patch 4
  additionally removes its now-dead init_mm special case. mm/vmalloc.c
  no longer includes <linux/hugetlb.h>.
- The generic pte_set_huge()/pte_clear_huge() fallbacks WARN_ON_ONCE()
  instead of silently doing nothing. They only exist to keep the build
  working on architectures without PTE-level block mappings, where they
  are unreachable (patch 3).
- Patch 5 (v7 patch 2): use round_down(size, CONT_PTE_SIZE) instead of
  rounddown_pow_of_two(size), since pte_set_huge() takes the size directly
  without an ilog2() roundtrip. This lets a single call span several
  CONT_PTE blocks: a 768K (512K + 256K) ioremap is now 1.25x faster than
  v7.
- Patch 6 (v7 patch 3): vmap_set_ptes() now calls pte_set_huge() instead
  of the hugetlb path.
- Patch 9 (v7 patch 6): get_vmap_batch_order() takes pages+i instead of a
  separate idx argument, and applies pfn alignment limit to scan length
  rather than to the resulting order. Renamed idx/map_addr to
  batch_idx/batch_start. Dropped Dev's Reviewed-by.

Changes since v6:
- Add a clarifying comment about the reuse of hugetlb helpers
  by non-hugetlbfs(vmalloc) mm code (patch 1)
- Expand the arm64/vmalloc commit message and comment to clarify that
  multi-CONT_PTE_SIZE values are vmalloc mapping spans, not HugeTLB
  hstate sizes (patch 2)
- Move the local steps variable change in vmap_pte_range() into the
  vmap_set_ptes() extraction patch (patch 3)
- Propagate vmap_pages_pte_range() errors through the upper
  vmap_pages_*() levels instead of returning -ENOMEM for all failures
  (patch 4)
- Add a preparatory vm_shift() helper patch before the batching patch
  (patch 5)
- Guard the PFN alignment clamp in get_vmap_batch_order() against PFN 0
  before calling __ffs() (patch 6)
- Fix kmsan_vmap_pages_range_noflush() indentation in the batching path
  (patch 6)

Changes since v5:
- No code changes.
- Pick up Reviewed-by and Tested-by tags from Dev, Leo and Uladzislau.
  Many thanks!
- Add TRBE/SPE large vmap() test results from Leo Yan to the cover
  letter.

Changes since v4:
- Move pgsize update before contig_ptes check (patch 1)
- Use rounddown_pow_of_two instead of __fls in
  arch_vmap_pte_range_map_size (patch 2)
- Reword comment to avoid mentioning cont_pte and remove if in
  vmap_set_ptes (patch 3)
- Rename vmap_batched() to vmap_pages_range_batched() (patch 5)
- Use batch_end as the batching cursor to avoid an unused start variable
  (patch 5)
- Check arch_vmap_pmd_supported before PMD mapping (patch 6)

Changes since v3:
- Squash vmap_pte_range() loop variable fix into patch 4 (patch 3, 4)
- Use shift >= PMD_SHIFT and fix *nr increment in
  vmap_pages_pmd_range() (patch 4)
- Pass page_shift directly without capping at PMD_SHIFT (patch 4, 5)
- Add vm_shift() helper and pass pgprot_t to get_vmap_batch_order()
  (patch 5)
- Use min(order, __ffs(pfn)) for graceful pfn alignment degradation,
  replacing IS_ALIGNED check (patch 5)
- Remove irrelevant ioremap_max_page_shift early-exit (patch 5)
- Add __get_vm_area_node_aligned_caller() wrapper, rename to
  vmap_get_aligned_vm_area() (patch 6)

Changes since v2:
- Use __fls instead of fls in arch_vmap_pte_range_map_size (patch 2)
- Add WARN_ON checks in vmap_pages_pmd_range (patch 4)
- Fix flush_cache_vmap to use saved start address instead of the
  already-advanced addr (patch 5)
- Rename __vmap_huge() to vmap_batched() (patch 5)
- Add caller parameter and unroll while(1) loop (patch 5)
- Squash patch 7 into patch 5 (stop scanning for compound pages after
  encountering small pages)

Changes since v1:
- Fix condition order and use PMD_SIZE instead of CONT_PMD_SIZE in
  patch 1 (Dev Jain)
- Squash patch 3+4 and patch 5+7 (Dev Jain)
- Replace "zigzag" with "page table rewalk" in commit messages
  (Dev Jain)
- Rename vmap_small_pages_range_noflush() to
  vmap_pages_range_noflush_walk() (Dev Jain)
- Extract vmap_set_ptes() as a new patch to consolidate PTE mapping
  logic between vmap_pte_range() and vmap_pages_pte_range(), handling
  both CONT_PTE and regular mappings (Mike Rapoport)
- Support non-compound pages in get_vmap_batch_order() by falling
  back to physical contiguity scanning with pfn alignment check
  (Dev Jain, Uladzislau Rezki)
- In get_vmap_batch_order(), filter out orders that the architecture
  cannot batch by checking arch_vmap_pte_supported_shift() directly.
  This avoids overhead for orders 1-3 on ARM64 CONT_PTE with 4K
  pages. (patch 5)

Barry Song (Xiaomi) (4):
  arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple
    CONT_PTE
  mm/vmalloc: extend page table walk to support larger page_shift sizes
    and eliminate page table rewalk
  mm/vmalloc: map contiguous pages in batches for vmap() if possible
  mm/vmalloc: align vm_area so vmap() can batch mappings

Wen Jiang (6):
  arm64/mm: add pte_set_huge() and pte_clear_huge()
  powerpc/8xx: add pte_set_huge()
  mm/vmalloc: use pte_set_huge()/pte_clear_huge() for PTE-level block
    mappings
  arm64/hugetlb: drop the init_mm special case in clear_flush()
  mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
  mm/vmalloc: extract vm_shift() to consolidate mapping shift selection

 arch/arm64/include/asm/pgtable.h             |   6 +
 arch/arm64/include/asm/vmalloc.h             |   8 +-
 arch/arm64/mm/hugetlbpage.c                  |   5 +-
 arch/arm64/mm/mmu.c                          |  19 ++
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |   4 +
 arch/powerpc/mm/nohash/8xx.c                 |  29 ++
 include/linux/pgtable.h                      |  29 ++
 mm/vmalloc.c                                 | 268 ++++++++++++++-----
 8 files changed, 300 insertions(+), 68 deletions(-)

-- 
2.34.1


