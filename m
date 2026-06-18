Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AF8CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D4C6B00A4; Thu, 18 Jun 2026 04:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216196B00A8; Thu, 18 Jun 2026 04:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D096B00A9; Thu, 18 Jun 2026 04:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9306B00A4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80ACF1406AC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:37 +0000 (UTC)
X-FDA: 84892404954.04.3D72B62
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id ADE654000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SnI6ARlS;
	spf=pass (imf27.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ytp+bdNRdXUdbPQ9Ezf0ymEFpvBnhLVGkSee+aNNB40=;
	b=pDZSQfj5Pv/34gpV1J3uSTu0p/BNwXHAEDFTLRsu4tzR51fNHzg0ZC2xHIY+fobREqFls9
	VN9lwPZGSESzrTMkC8ok82jyN9EihQHggRdT6wULyZ0G/jLTdnqHACfs3CUOFk+G/eq1NW
	3RX94rFvK82R7pRWsKfAleayN/pQD8k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SnI6ARlS;
	spf=pass (imf27.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772455;
	b=45zR6SNsRVjuEFvoXZ/Qmfyb7V0z1z1BtY63zssJJrvQy1R/LZf8FxbnATF1Hc61P+neuX
	mBKF8WK0YvQreBpoN2iGfNF+kVZp/T6s5ehxRieRL2mhQklrtgHZGLg9QmdrVDQKkdhe/w
	JivQ6BPB2Ujb6jf2O4wfldoNfS7Nu14=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-37c8e7c8137so303008a91.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772454; x=1782377254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ytp+bdNRdXUdbPQ9Ezf0ymEFpvBnhLVGkSee+aNNB40=;
        b=SnI6ARlSz7OTGXz/Ea4ig1TBGgOQh8EcvGSX2i14Xuu7MSMnVAjqn7wtcuOYW3SbzQ
         hisEtZSy+goVSrzI42x0uZ8ahr6F6LhHRCaKa724Yy3DxW+uqMATsDGDNXVi6qge9W3v
         +CuDY3Xr2Nj3u1gi1qg80OsImzSkLs97PrA4u7Kqaz/UizIeR4HSdzDXsC270ezZCOTr
         +oSerXWmeMXb6N4iTCXhM4vYVh01JlUL/gIQTrzid3otaHjeP+sf3zVNWm39SsbaayHf
         8NsNByAuFyluC3T5SHZalkukg8ZbQtNFb9P/TKggkZD03XoRyg8vcrOxDK7lzdYonjk4
         uL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772454; x=1782377254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytp+bdNRdXUdbPQ9Ezf0ymEFpvBnhLVGkSee+aNNB40=;
        b=FjAjjxL/Ji2lXbtYFsz2avUHgfeg8w4ay1NDhHokoHaPGYw4zCIUkP490NegZtNIo2
         0r0w7lTZRuHVK5If2YJOQo+Y1kNodZlswuHMVojtjZVsGM7NX+AnnVV532lcA3ttX3aq
         TepYPmCi9pt9YVRDM5INEpX4VI6sJiccGLzDhvA8ZmMvSYUUpIArsXx2pyOKOH2hvymk
         UbNN/0x6NTGX2c6RXqNE5t3B/LhY1urxOyhecAeLPPMNvERVG7R3iXsiIhfYkZIZGpxr
         EYnztiVyRiG7WXTh5twrX79nqvZt4mTsCvDLE4PsAHmg2VyYcIcOYxy9mSTT5zpzc2dZ
         ba+g==
X-Gm-Message-State: AOJu0YymMHdW3epUKizrc48Ue2A/BaRCLCzSZsy19Xz0H17r8q7Guwnl
	FsqBz9ZwGgVxdyEP95u+kL5aGIbb3nfbbTT/j1AgavHcAPeHtKNG/3138NGa0w==
X-Gm-Gg: AfdE7ckoS2LF+Kqg1hEpRYKR+3x0YNRrfI1vlNuaJpLFbR0bhsmJbjxDwGv5Aoi+vjc
	pypZC0p3mIuGlU4+g4ISeU5JHBPmATRRaE+Pa2fzXhRhvySlyvdsvNpAO8ojyJ9Q3POknR61YQh
	s/97fdxUC5umyPJJkAFAGeDcNvMxRQSPrn3O+E6X9fibNCrIWyoTfGaQ0Vlc5jlty2owpOIRa3q
	VWxcCaDiKPI0sXTldXRGlz6A/77up8LSiDTe58AI3I6WZC3XxOhB0mfFKrC6bCqFCNXlrHtE8yY
	gp9qnz4iSeqmgTZsznhWzom2Z3S3Q3pTlJrC1B73on6Tn7jmBaSR13+UaMzojPTjxJ5ErVwMGCJ
	+UZymluJaPEQNlcfORQ//FIIeKUcqpYpBsikQ9A9el2sboSzj1TPBMsEnwQnrxrxs+GtjV7sUJP
	YFB05UWhE+kCk3RAgla6rWligvUob0wJIayvI=
X-Received: by 2002:a17:90a:c2cc:b0:35b:9894:f6f9 with SMTP id 98e67ed59e1d1-37c9e9d41a7mr6843844a91.18.1781772454417;
        Thu, 18 Jun 2026 01:47:34 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:47:33 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Thu, 18 Jun 2026 16:47:20 +0800
Message-Id: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ADE654000C
X-Stat-Signature: mj55t9r67797ygp33d1ddxj3n6an7kh8
X-Rspam-User: 
X-HE-Tag: 1781772455-77260
X-HE-Meta: U2FsdGVkX1/I8yJ2Wse224hXhcl0lXojliCgXEuclQZ4aax+AC3Pd0vne9AUwFfScn/L7ZiLZKAZQVD01T3Q0LRd3HF7qdWM/1SsQNS2DtOCKIl6iN+Pq4jBCg7gy3DsxDrd1dYJOUre68zHd2rIB3CfAvr66ubbufcgcHGbIFTxDr9IwZJ3ZVIZ56N+1DbupG9Kr8DzAEtJHvqo46k34MKkBbKavocerG1uVIOQ6QGvhmJ1y2jwEWKnaNHUOZ1AD9+7Ba+fBVnuSd352SwX2CjitX6EZXrS/29k0kIRnxO90jouFt146fjlsL2Hg1GDAjIlAUFZahlYnoD3vwCrbdvKyy0RdSZphv0sPnOunG6FXYiF7i6IwVzu7F59rNsGz9fIn+EzH3SCGb0K74DRM7avlJ+u7v6lpSkMSct/tpGn8osvY97IgMIYE2aF+gm/szejPNIBqzOFSJZ5G1AckQgOh7o9a+NyqHtgKiktjlDItwub3aSoQ8DcRbonwplHWyNDaLQs1xej35I1DJwhPmu06AJqHcKAdoWUlmJdWegogaXWxT060LopBCgB1YcGiBOatWAFWdxuisJYg9VWAVSWqayNfOlE0Zf82IQCqKKOK28cR+ft+EZvnz/Knf67W0JVKmYKXUEF4azRvZEchKuxzmUB5HwIG6o+PsEAkvdd8ZFxoBk06Taf/NuCI3LS/gXxMKKKgxQ8MlTG78Aeau6dnCD5kwLwMQpb1Oyw/1odRpOOtp/VAP5WidmcPrrJKtrtnlqK4je106lrytGAHXejflK5bLoxxLT2GwHcrbmIMQCYNgD2bjYSufHG/57yL89us7T8GLoItwxU2fRQZrSdkaZR09oiRJk8KQi06VYgLMGizU7/pDv68fS4xbzyuLCISK1tRmF7Fts0Q5XKafRGvq14hzI575II5xabn4SAhgCEc/CBCMwKoBHMJ3wUULT2p6Wtdw6uAndwUsn
 Tw2fD3hH
 GgmhhacIMkcOUZM/RwsAtzuxE70RXZdFV3PZqhY/JaLh+d1C/m5zXcL81jhSaTe62hdjpkyGNmGX84UwWucA19JapVs4xDzp0QIwvrzR/T3XtKC4Jtey/jITTKfVNzPJIghyBJlnV4EBKirw55AoFLrvyx5ItXyX7OQbzkyKGyRTQpQm3BMu8usO3hUiUgodqd4/ldn2n861IxoPOofGOUQVkd4ZGX5r6DCKpZAEsK6E+SKa3fVbpktkb0qdfYeysl3r2+E6jJ+Q8yUYY/jXBjYKGF6VshYJqVdQp2Ov2JnwCcTJTeYMvsFT1ZnKgMDG/6j/FnmvpWum6W5zfLLsm1LHssG3UKeuLpXEX2mAlEmUpHvaGTvHJu1KvFBhW0rR0GVrZFRO7wwK2dT4dAOOTtGf0H77GCS1TGthCX9KjNcWNUVkqu7+twckk0A==
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
mapping logic between the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings. This prepares for the next patch.

Patch 4 extends the page table walk path to support page shifts other
than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
mappings. The function is renamed from vmap_small_pages_range_noflush()
to vmap_pages_range_noflush_walk().

Patches 5-6 add huge vmap support for contiguous pages, including
support for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
the performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53us)
* vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

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

Wen Jiang (1):
  mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic

 arch/arm64/include/asm/vmalloc.h |   6 +-
 arch/arm64/mm/hugetlbpage.c      |  10 ++
 mm/vmalloc.c                     | 247 +++++++++++++++++++++++++------
 3 files changed, 213 insertions(+), 50 deletions(-)

-- 
2.34.1


