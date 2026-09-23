Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A63C8C98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E5F6B008C; Wed, 23 Sep 2026 02:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6426B0092; Wed, 23 Sep 2026 02:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761696B0093; Wed, 23 Sep 2026 02:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 556A56B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:28:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8539C0544
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:43 +0000 (UTC)
X-FDA: 85244048526.24.ED38C30
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A4A616000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=etwtRLU1;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZuSLF0hkxQHLte/AAueOTAnFcUBu56imXlI7BP0ZEbY=;
	b=GKisCLCBPN8Jdx0VsA9H/ytMz5wCnRMdAo8jy6oqNkxMiyW08YGA8syQnDRNkutY8euZu+
	GpWwtZ9eVDeKRay7a1VaAalj0y/THVt/vRzTOwn/oSXp6twLVdh5fo/WPWBhWDiMh2WPUn
	CNCC660OapZBqZOzl0Cy5sj595ipYoU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=etwtRLU1;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144922;
	b=GPqyUkscV4zKPZUyuxMdMoUnjSzA8yxZwLmF/pJvhpi+orZro/ufVc2Qu6Z+3mt7nukAx0
	wyid8+MmajOC6gVjrbpeLnIyF+myRtNgl50YdtNuR33BFAqNaKJeg8yX642oIkN/PWsFX4
	5x2q2n+Gkk9i/HTn6IuQixCrVwjZNro=
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2df4aa80a73so3557935ad.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144921; x=1790749721; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZuSLF0hkxQHLte/AAueOTAnFcUBu56imXlI7BP0ZEbY=;
        b=etwtRLU1qbNxX1FG9RsvuqRB3lo4Lar1yG7wvXTXi7LVwnZadGFFj1QtiDZeMEJ/gX
         C90Nn6qmSqWkLSTj5lmPR2xBpNLbsdZDWje2aAMZVHX9y0FrWgAO+yD1whQLKuwf0fPU
         6wH7bBE/eKlF6Qts/ypIqDIVm12f35A8epHVnm0i42650hTV755HB2IvV0nXkVV+IR2Q
         LJx97Vc5UhEE2s0Kw1q/Jg16ngBpDL4L9UVK0lGBqupY1RHw4hmWCjgVatZVl0MehcRC
         1Z2MgOprCncd0NLdWMz1Km3izm4ia1XD0s4/UIWMDHlI0zS16pe7fFSkCRIZkzn0wxUp
         Vgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144921; x=1790749721;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZuSLF0hkxQHLte/AAueOTAnFcUBu56imXlI7BP0ZEbY=;
        b=tLV6wMGdZRWWbHkS1uC+lcb0vvDFAz+vs3MEnM7Jw8bsD2vjpdEx8CRS9k63lbfqso
         XSieUjtYXu43JPATY8mfze59lhr7GmEa/EhfubUKW6+8ACQKKioX0oJckB10Ni3TH43a
         RjM/Vvs6VFmml/AvfKcG+vCvC+LC/wvWddhI9C8IGVrx0fqUKa8eleWAT64BYVNavUTC
         Ol95ZbUUpLuush4wVwWo1Nkvcn/mBsC+ElIt769phIXgvWoH3VG+ZfSYrP0Fs+BdG/8/
         lHMjew82biJ20UyWjZSPJRFXhKig/Rtf6Af9JFMQgeimXho3VXYBRsJVUaBpwXUQyUIz
         diTg==
X-Forwarded-Encrypted: i=1; AKwUvBy8pFxv/R1PK3JPuhw9utL+VzXaT6udqPOtdPqAVI75puk+7W/44uFB/Hd+rPvn+wNOf3w+aWG6rg==@kvack.org
X-Gm-Message-State: AFuF++ni8+F+F7SjBc196EZ61wkhkdCA4VzBmRGutirHyXZr6cV1WdEv
	dGtd3N8GWEBwg9DUSTDJKclk9BfC6d+cNvD27+QMdKjhDSNB6dm8xg/B
X-Gm-Gg: AYBFou070IgbhQ/KfgXnkX+ypqVvbwf1PaNgyMSvJj+rTJUFqBDEjzYu6FcC0lTBlTY
	S2Ezw/nyWgNwvJRZ1nvGlGYxaYQB0RE9XL6D8lc5wqO/Y4sOzsl5Pg94aY0OsMCMlFo5WspP0Op
	+kKsHaRhwxwKPOszaljqIr9hJh5JdDU4IkIU/4q9zMpL/ZWnmJ48ZH3m7N0Wt0ButvDXhNam1y4
	QQEbzEE92+sxiMAz+bvL5ClVsxnavlV6qANYmtasdZW21HWMpPvA28ECAoakz798idmg0CE+qfI
	twqbN7SPtny492ahELrYfmJlmHHjAgW0uQ1xICn4fxZ6A7cENPH4ugylN+R2LIO/GeELPNMxVqa
	PDXwr002sYSXqTg/e80w+93xLlKncNs28D9NKbKutkZSXuhc3e0VU2g6ecM+XuLO7RGZhfKQZxe
	O61X10MqGotA/Sok0J6kJ18LxS7XrYzkgOfAGnkycIcuL2Dw/c6MDHU7zBfBv/KlbFAnEKXTCw+
	+nRIyZycoalBw/KydA+tw==
X-Received: by 2002:a17:903:3b8f:b0:2dd:7ede:4c0e with SMTP id d9443c01a7336-2df69d2146emr13851875ad.12.1790144920724;
        Tue, 22 Sep 2026 23:28:40 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:28:39 -0700 (PDT)
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
Subject: [PATCH v9 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Wed, 23 Sep 2026 14:28:22 +0800
Message-Id: <20260923062832.479455-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49gur8g7sbptgh4u5c8nga9ec6npjap5
X-Rspamd-Queue-Id: 0A4A616000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790144921-339148
X-HE-Meta: U2FsdGVkX1+Ik0g4dl7yoZGmpVbjhJbxmt2wDRGShjnZRXDsuHg0O6uHaNhzYZsUgMQKEkezbSA2mUb/MHQ4PnEpwpIbVTB5wzLa3dvp8JPcJpxIcMieTL3cu6JeqTu6kpiPrt6wZKVY9tfDOF54d1Q90bqQk/VzKZitGWBuQpRg4hyVF0uUu7EKOthFKdnt52oZaPVT8t73sjUZrlPRZTSNdYIzj1CIN4S47Yix9KABzNV4sBr1A+fuExoiJN/SeQrUpexzC45G3bxZ+Xo6LeoDW5X6TlP6/gxqpknCzd9ViJHgMSuFuRcLxyXaGWCCjiAc7kqXLLa9X5Lb1MJeoVr6bkUwvSj76cXmUUltayjGicQ/kpdbORR//J7Gfy8vROUauyOH8R5UiL3JrOofxaFPGgJU7gGG/wW3tE3brs5XKr8IUJk95KcScqNW3z/Qw4g2eYntW368rbF7UUZRmZiG+XN4gLZfw2IhvyLScEq1sAYjvbihqlXZrQnjZM3HwYMIhbUrr2m22gQI2jLmSFiTxdTZ8UUkiEsPx26ahiMkJRzvu1ZCV9atjZ9ddozjhvq+sKp2sVp4AG0T/CLia4SLANOFBCz/Qq8wi8//sX/gWNZVB/bVkt2donWKPIQtuv1KDiGuKIjwLDX5d194fIqeR9UbLdX/9RSXiOnP+oRJhqNvTfPBc6jMAvPUhF9Gez5VahOjv1Mx2sMrQLqXkgNZKPB0uPlGJzb+lrTfRvKuEyDsiG51IiD6hKj9kK5lAKgQaiEiol65+XtSPcG6+pQlzTjMZaqYzfoKwGEjwU0OI26az4WpojrvpTTOVm8Get/iuE+M/5esw0WNIazMYYQLlB9ZEZvTnq7vx1onJjzuU3MbL64eah+Ef1FA1MjJ3VKl1NTz/NX+AcFHc9GAc9qy54CHH1af9vxZKfii6kwKQQIRCVfTytmL4UsRsKsQz6koOY64i6iMAJibAsZ
 HF/mzpsV
 14O2WhMuERiAkDDUoMyEeBaNINUIJCC/jiIMIGYO3gHKB77uqRyCtKc1XehLRYTW+7W61ntb3YVY+s+S7SxlI9g1wKSRoNbQ/HfwVkGmlZXwfw4lF3OMnxyE/+7aVTXiwz+Tit1Y91QSJ3whm/TPCP/HiwpnkYonP0A/1aeFGiT9CDbOMOLdXJ5ZmHWKUn3ilN+2AvCmYu9XjUyuTqvdScrf3M3K1ufWI34NLCKPSgkGCZQW1LDRlASkRMNeF3BRA4iZhoatgCMb5OUCfH6UI5gH3+J4df4IgLxuRakMq8VxKRYBCuEpWbgzJgM4NCKLXsWu1P8mAUsY8T0Tl48EwRhgaT51pBVPFMvazCTUpxET7OKr/veoH4nWFyyf0rQDkfX1e5g91REwWgxcfYANjjoemWCNUDdVxbqKdsu/VFo0/S43odTDNj0GRZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Changes since v8:
- Rebase onto v7.3-rc4.
- Rename new_pte to pte in pte_set_huge(). Add a
  VM_WARN_ON for addr alignment. (patch 1)
- Use BUILD_BUG() instead of WARN_ON_ONCE in the
  generic pte_set_huge()/pte_clear_huge() fallbacks. (patch 3)

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
 arch/arm64/mm/mmu.c                          |  20 ++
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |   4 +
 arch/powerpc/mm/nohash/8xx.c                 |  29 ++
 include/linux/pgtable.h                      |  29 ++
 mm/vmalloc.c                                 | 268 ++++++++++++++-----
 8 files changed, 301 insertions(+), 68 deletions(-)

-- 
2.34.1


