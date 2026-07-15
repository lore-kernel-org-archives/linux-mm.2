Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930ACC4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545546B00A4; Wed, 15 Jul 2026 10:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C816B00A6; Wed, 15 Jul 2026 10:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDCE6B00A7; Wed, 15 Jul 2026 10:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 054D26B00A4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:34:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFC9E16016F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:25 +0000 (UTC)
X-FDA: 84990888570.14.414CF2C
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3ECA16000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HA+mCMX7;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117304;
	b=oTZ2CTtZdR032VrqZYmlhiwMw7Ic827e8ZX31at3UoA2v0vMAWsNnUk7cTsdnBiV/hMt2/
	/XxHy7f+5rBToAs2l4Y9TqICq8Rnxi8ALyHYE+gWSwfuUEhF7HPsYhnGqljSbqsibzZ7gn
	4LmRbuqvQlJamigxbMvQc8eGfZiTg6A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HA+mCMX7;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vzsH/LHbJwPhcS/F03MRPLO6wWkth0B2xmqisYYr6kQ=;
	b=Hat+06txcHXXdSKpDnFpNM+SIALFumXreC65XUqr/xRUP5/FBY0H8WYDkTy+QORcU/9lPq
	pYfZj9M9hKFgUPkF7AeLYF7QSt+mB9JKAWj/NA7GTzRioBNnAYulAJFJ4jSxqIZ4PigPeJ
	SADH/psJVVLjHa9xtk0KANwVmyS4cIo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cc6dd436c6so24142355ad.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117303; x=1784722103; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vzsH/LHbJwPhcS/F03MRPLO6wWkth0B2xmqisYYr6kQ=;
        b=HA+mCMX7JJZf088kjQNaxH5rjZ5Fcz60aalzoDVoxYahQKE2ZxjXfZJilYo1wlpW2e
         XUd1/5vTLxAtyH+rJa6TUd5yjkeotwMHImRtMlfPjRBif3fZzzTmaEyDmrYw0/IbZNeT
         JTEh/hoyUsWl/yL6uadg5xrgR+xfPlfoTXBybpkF4VPQCR3MrG8cgsrQxaq32pdTOFqY
         KcrpOnWLMvdbe+dKrycwdeBwQdPVMKvc6glI5dss0a84vit36vjX6DWcCfAxtctvxf8s
         tmytIfGWyCEPrl8JdWBHyglI3DXyPzxMLQfd+uto3miTwfW7ccm2y8Tdly0l3yUHQC8q
         J89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117303; x=1784722103;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vzsH/LHbJwPhcS/F03MRPLO6wWkth0B2xmqisYYr6kQ=;
        b=OcN0Fk6om61TUVj/bfDxI6t4gMBPj4QOj18ws5Dq/F6Q0QyuYUro7HUhj45Bn98u5Z
         hHvIbrUJ1Ep5TC3yPk0nIhd00rkERwLPyrsI5ldCrQZS2F//XqhXqVBkgEMN+6WGZF0I
         gKd90Vg8uH1e6Q4bqhZngQvk0u2U3gVWC47oyL5WU6yMlRTzNDkfXnLdQhEjMMKrdrzc
         FBQy2qcb2I1DB4r+QfYrtv5zy6L+0QEpr3Wd5QIkgeG/G34oJzSRfaHHLz7h+ZQ6mX+x
         X6MJHckDedF2FK+ULT5JMjigO3RhGT1N9x2kdsZJw6A2DpaEtU4AJUdNXWMMiW1UIc9g
         yaGg==
X-Forwarded-Encrypted: i=1; AHgh+RoM3zYAG+24Ssb/GNFGrEBazT4+8jjm9lTiRhFWrWH8ITns44cNA3ioZ2rZLJltZNHo3AHahdiOzA==@kvack.org
X-Gm-Message-State: AOJu0Yy4DzB8OxnETikp7fpYGG8wLWg7WKSgbRe2Z2itTpTW7b7VdnQP
	UmfogiDdtdmq3aCQNSYMqqnflpkhCS0xTTgZss5Y2NofxkI1HaCDgHlc
X-Gm-Gg: AfdE7cnDGHxYX//V2hkdemBv6wP8W5X9SvjsZwEFWVjRJkv4tzyUbagxxf35uKUKh9I
	9z4YslU0M0ITNgdhMONFoDq85nrhKTNuGXTDiu3Z90NmAE+2DuPZO2z9e+5DDoGPVBMht3zRcM/
	ZDe3PzoWD6HZokr6QCxgSde3EaotVEzdFebVYq5taGhl/7P5I3hgAfEfGrF/jWjIJzcmaJwJNcN
	ZXAxAqS1Vmwlv1INyvZn/nx2idKExgevyUZ3FZsrpWjkyxPORNsDhLYnTZl+6EhlEptUn7LTgKp
	YBeX0KUZkfy0IJK3XE7FI44SEsZ+ur1a56Iqtr+p7T+Acu2avmAxgBzvTkVOEey2ALEItMACODX
	sU8+dbFRZI5MoQdHZEYlsIA84PdyGv5RtkKD998oFytaiut+39vpN8irI7+A6mX8GFdAQdcjP2d
	vd71+bbyWfMPrx7TkSlMmyRFvsj9+tYZ5iLSU=
X-Received: by 2002:a17:902:d552:b0:2cb:2b53:559f with SMTP id d9443c01a7336-2ce9f3a4910mr175721715ad.35.1784117302761;
        Wed, 15 Jul 2026 05:08:22 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:22 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: [PATCH v7 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Wed, 15 Jul 2026 20:08:06 +0800
Message-Id: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3ECA16000D
X-Stat-Signature: ngtjhckf384ei7e3iy8fto6r86ye4edz
X-HE-Tag: 1784117303-611128
X-HE-Meta: U2FsdGVkX1/R1Gx+Mtous7NycTzZdSfkhEkfYBPUDuQRMniGqrI3KKJaIgm9hMXIU6To4PWeNOQ8d/PuPjqEY8j4KXR+O5dNaEDAnswYaC0Gra8qgO8JgECF1onDR4ofE4uxzd/9DXjp+Mrf7b6L0wP/taycxt3+mZpQlHAd3MP6baKkJUx3hd++AkLy7qyaSx5ZFXHlAUgmrKUsj+eWSslwND3Xt9UNg6+mxLNiuyWZO3XpJC1Eyn2QRGWQEaLbHBaqPKHYRAujJma1eKcYhfJrTmrTT1YfjPt6XRl51HjOKSl/llBCm0CkEdB0ynM6QkTB2shbl0SPEyCAWdo1UfpZJwYqUvWYlRJeWgvAINwQiCViiS5r0i1AJ+rAdn78qo7abC9VkDZ9PMHweLZQYPE6+I0I7cMlZxvVg6fYPGQg12LvQs7zAaCmmbfNSYbLw2xL4ArFVrotWWx6ZQAsDeNqPrjcd8sWOL9YnyuCIukVsme78IC5ljfrdOXgB4NoXEILqDcezyAUotS59EKCY+Ccr/a+fwmCLm+pU74qbTfZFXv6I3XTEsBJQhQTdfGFw/tuE2UgXxxfCpGQ95dFMkC/IodmTmuHzUtZoHYV4Q69JyK2MGkZsRwYTO4wxPmJxNPitcNbRfHcVEIhWPeOFjjE/5DmOLrdJiKWZcrGUC5Ghrn1Hox7BXyAL+P7zzdekwoItuNktZ0Eppq2bkPnn9lyxYXZji26sgPFYv22vawtH6M//hndGPmbOrNwq01nEIzUdQqgGfOGDhiUTpj3o5wj1FjGri+tvwKgU5hqOkiqP3d5XtaMOBcLTN6YRl9ncR6B716QFfoJQGX5w3g3TDVvDUiSSAhN1N0lSl4JaiKIi2VjZIhLt/G4Ykc8utusg0KnIGCBTV6bMyfLZNgofoDFUCZtzAuVNJ265NrweI59ESnG9/D4jX8oNLEjt+vvruNXl9wiBVjwlFSeDbA
 CR9Uhnxr
 Fb9K8qzGxqG+f5Q/53MVMMNrsrVyDXb8SBMjHS7b643kEw+Jt/y5dkcxmfVqO31vTyhWQ9iASuLjSari1hRmmJ3ucsX8L/vg0coA1/58/viJ7GU/PDqkpu4BrzMzs7SfI7PDKomFar+lEDMWxAUAjsZ+7CkP0XylPf463rruvlGo6szJQR6UFkxlfN0zVkNQ8LzqYzjJ/UyRSNE04RAgF2weRoJ28N4CLEG0RfekQNsRVQun5gK2Tspw1jWxtjqNjKIG2xWq7JnxkZQYbsbZAiQqDSAe7hhQYBFnEfmBbT8t6EQi/0BPjmAIJ9LeBH7EBuLRaeEzOgBaUYjLV4kJyHz+xtMubGTXtoi5F2kKC/KXUn4VtDKRVzpaIQd5hBKLEN22N/poA4ImVHe04Kont2G58uzJ9xIPyqwp+STUrsH77BB0Jg7pc6QnmbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset accelerates ioremap, vmalloc, and vmap when the memory
is physically fully or partially contiguous. Two techniques are used:

1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
   segments
2. Use batched mappings wherever possible in both vmalloc and ARM64
   layers

Besides accelerating the mapping path, this also enables large
mappings (PMD and cont-PTE) for vmap, which are currently not
supported.

Patches 1-2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
CONT-PTE regions instead of just one.

Patch 3 extracts a common helper vmap_set_ptes() that consolidates PTE
mapping logic for the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings. This prepares for the next patch.

Patch 4 extends the page table walk path to support page shifts other
than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
mappings. The function is renamed from vmap_small_pages_range_noflush()
to vmap_pages_range_noflush_walk().

Patch 5 extracts vm_shift() to consolidate vmalloc mapping shift
selection for reuse in the batching path.

Patches 6-7 add huge vmap support for contiguous pages, including
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

Barry Song (Xiaomi) (5):
  arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
    setup
  arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
    CONT_PTE
  mm/vmalloc: Extend page table walk to support larger page_shift sizes
    and eliminate page table rewalk
  mm/vmalloc: map contiguous pages in batches for vmap() if possible
  mm/vmalloc: align vm_area so vmap() can batch mappings

Wen Jiang (2):
  mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
  mm/vmalloc: Extract vm_shift() to consolidate mapping shift selection

 arch/arm64/include/asm/vmalloc.h |   8 +-
 arch/arm64/mm/hugetlbpage.c      |  15 ++
 mm/vmalloc.c                     | 264 ++++++++++++++++++++++++-------
 3 files changed, 229 insertions(+), 58 deletions(-)

-- 
2.34.1


