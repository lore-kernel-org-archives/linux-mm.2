Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEE0CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE66F6B0088; Fri,  2 Oct 2026 05:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70D76B008A; Fri,  2 Oct 2026 05:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37386B008C; Fri,  2 Oct 2026 05:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AECF6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:09:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7B431605F4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:09:57 +0000 (UTC)
X-FDA: 85277114034.05.89BFFB9
Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1323440008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:09:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bZY7FAJm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mik9AYMOSPaxfVwqMTu8SN5nKsMYeOPF52nuTxTKmpQ=;
	b=nPFo0PoravftEtJRa2247jW73qkQ8FNyJfqPT/SxsHkHPcarCnUxkQRxLGA7fG/4gARwVg
	cQLgOQcwCXsf1OiW9LQxiaHCw3aMiaFg6txW6agfcwQi/wBdg5+ndZOh2WkmfB8ZXSumDc
	+r5VDwjwqX+yoWWu1hL8Z1DNi0ymTDQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bZY7FAJm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932196;
	b=PrEKgMSL1SmVxi2EtKDXnr3P+Yb8wZFPHXq6va2oCd5m0QfG1pPjESpS+3YLp70KJcrMdt
	oR9mR4x+Z7SqwF2RWZ84hcXtnPB5tbOeFrUUc4RQsgaBxVAFltQ/NWa8T+blJ0XwXau7Gd
	W/kTHa+duHBEpfW36n0Da2Ifc/FX/Og=
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7cadbe09dso1643120a12.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932195; x=1791536995; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mik9AYMOSPaxfVwqMTu8SN5nKsMYeOPF52nuTxTKmpQ=;
        b=bZY7FAJmHRm0kAL5KmlmfxIFcvzj4GuXqd+LhLLMI9ZksKpCVCCSLwm3kbuuKeghzL
         6wuz8P0TKePV6zI7PI3/JFk//ImPh1B4m6rNzblSlRtH0eoDrnggEogbJT8fqNfdxMP7
         eSWL3pJui7s01DOYyh3JiIRYTFHSKukotcdiXaEQKHdgrfBKgAgLizhVI1ixsU/j2cN6
         jNp52FdGUtzC1PSq/j6ccQLv9hhMu6MGxqFMv+jK4iF7vIalj+38KpZFvxbhWKscVxnS
         d6Bb6o2Tnn+QrGV/jyNghtpkNUWwnsLHLbta8K7ZYijp50+5+VqPMSh6D8pMImdU3paJ
         piaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932195; x=1791536995;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mik9AYMOSPaxfVwqMTu8SN5nKsMYeOPF52nuTxTKmpQ=;
        b=D5KosihQzep2kIFbLBQLRipUjN9ImYU089Vq6a/zgBUvkLcP7M6H5kQCdhJRyBJ1m5
         fUebuFB0nM7SjFVLoT3tf6ddNTutFmqz7AVhuneManhUTvhfbJRfQHH9qg3yWTStX80o
         IZJnahUXDelCXe37MsuPNFrltGTcDOIQTKR35VWr+NGg0XGfTDe9AS/Vlre8e0LUDWBQ
         axFZKsLrkzH0eYhSuO5ecJf0boYRlmXL58SiUgAE+zejkarO+nNrS6S8P3ieJ2hqANoC
         nSfcpCWstYcnwYs3Bhhc69lefMnkHWh09N61DraYXKQtWaaTkLg0cPv4pLjykxN7vMur
         pcBg==
X-Forwarded-Encrypted: i=1; AKwUvBz1Kzz11MiDoESopb2y6fmmAuhc9VglNcN6TBxDLLrpGls0QjJxi/xeKkXqpHjZUNJKzY+z7ZJb+Q==@kvack.org
X-Gm-Message-State: AFq9FYIaJGlxyuhrUbi+q+RO6++a1PjkuIgQ22rQPdldNanUPMFbDoCW
	kXoyFw2/dwLyBNqtnKM+aHfMeVjEXeguTsMiEcirshBSXLUo03k/ySNs
X-Gm-Gg: AYBFou2Qr1RAsRh3wy8lbYWZLzBGJrRV0u0T7JrHRCiO0kZZM1Np7uky7vh0F8x2wJD
	XeAXKiVHmsPWxc6oGdyExBqs9PyUCNtDLkz4rUEinhdzkSedJung898PCn67ChI7IZt96BpgmJ+
	n7zve3gl/719CqC+VWykDuK54rGU9RjJ0Q7HGveWILhhv/O/WZE4bKrgkGmGJV83mkJ0YYq6JwL
	wlJpqQa6JWrlU6PwrFTgKeUxd80t4Q3umSLmvrU4DlwesIBYXl79+2ZqwBnwj14AHzD7EWRnNcb
	vW4F/homtQC0pHbyG7pZz5yPddHg750+0rzd3+aNsbyNycNuhN6LV4ttT5Hq/Om6+R2TSuYG31W
	DzdThvTAOORewzuor2RpI54TuYglOdYcVW47nX0wb6HhzFcMqUNzRcg+MLtZnLvGWfl99J5jrIT
	DJksI1oDDUS4z6MJdbnA73Njhbk5awjGQRLwn80XrvtU4UjRvRKJCOrpo2Ak6Qv3UvWQ7InwvWR
	uDV0n7KOkh7YKEljsnsCQ==
X-Received: by 2002:a17:902:da84:b0:2df:9556:6848 with SMTP id d9443c01a7336-2e49a7cdc51mr19275955ad.4.1790932194557;
        Fri, 02 Oct 2026 02:09:54 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:09:54 -0700 (PDT)
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
Subject: [PATCH v10 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Fri,  2 Oct 2026 17:09:37 +0800
Message-Id: <20261002090947.869220-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zs6bo1ep7yn5b18nghxratqpdms4kz7n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1323440008
X-HE-Tag: 1790932195-271557
X-HE-Meta: U2FsdGVkX1+mfwhkVcHCYQFjB4YaQ0pACtl5LeiiFfDe8HHT5oRLej/mfCybajnTa8vpWvjzl9V89VNN23H3unofoWxQSfmwOod+nnAGMbt9/h5AQrvcUl4EL0uARLeZFI95xOGiozDRh3nwhFcRvxDeY4MfgBK8Hc7znfGwIvlg4quivts6kWWwYzg/M1aW21C9m8drnzEomJEGBGb0V93pgk1ZsgLDld2qbqKsJnQ6l5ubEZ8JQLpfdbNRrdrvPifW+E8nKU8OH0fkn6oFjXdvFQBbpk80arD0QOkELjvRJU50UqfDXd/do0KOxrMafsb6YY7fxDvghToIjomQw+YHH/Hd9Vl+VQTK60KKWNuef7VCe0Lyq4rmfMlu7tqMI4AQ5cotFsYtlltU4R/1e0EZs47stV5WP8BGiT4pHDjx1bGR9jGxgFqRLPeddkFmUYdwXFw5sqM1oXNFpjKKK37QQRF3L8r2u9Qu7M3zOKzMyy5rg7goaraB5uF0JGI4daHmeFPCK4y6YFdTy+vuNA7nATPg1XMniKo14pgNqf8mktFWabcHSUD5vZAhvLjxdEjvr8FhLZHeljnTnX9+hBUUitUUEvSry0od1/KDaIWZywAFpbVu5migvRKhQTZ8jSqgr0QmFxT+fI1yrENK3xqJqIn1oAnL1xRpl2x5ChcValmqAsKqRjcISQ/IALY+5KEjagTBr6ofFT0lF8yuOWPHua/DDlLj/gPD8tCf/1I6aDt2Q952xF16f0UgtvucIyEsECqFQ2bnNIZOh617Vs2vmtbqcZV850AG814Hl/N2DUr2fgai7+qIBhigyZPBW2rOwBpre/WYB8DaJgb3wQL5pDsgLISpzzBdN1wFSwz8QEMz2OHfZzCiehqAQJV0UxOzmmibk0GMBD93EhfoQ0lt6OCE//Bl8L/pGbF6cX4kKiNLGJiANkSe1PkHX5zpeS/rlQji4zRQHpvk/dJ
 8PwTFRvV
 t1b8aY+ndIMY9woyC1grGUPHtTb1iI0ZEiAF3EfWHnAu3KnXNXNwrmEftLsRQ4z3wzjVgAuTptxMeMmyhDPEQpKqz8/0bLZsBHWWOAB5rvLqHxPg2GjXIBypYTZI3t+zPFoKZW4e06DYLovLd9kjqFyou+zELiTYJc7q27Kj/pLKOrePzb2XlopEj/O1O9h2+tSpdkb8xMxo1+W/pBajmU9fFLXzCFrXm6HaV54zBZoJF1BcU27dbdVEg4kU8kOiSCihzp7qc7/B0uBr5s0cWSTKdkHoi2chjKBM+EXozkPTWtUC6vA2XagwffT4k4RQFmu+k4/sX7liMKlocIQVhxDU+kc+3KPZrGcQl3Z/Xw7sP/O2wnBfmHwvaGr271lAAatBzDf2LVomcc69nvbpU1S5GoqG82eEgg/PIT0Agp3/EsfYIsppdggY/gQ==
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

Changes since v9:
- Add a VM_WARN_ON() for pte_valid() in pte_set_huge(). (patch 1)
- Update the comment in arch_vmap_pte_range_map_size() to reflect
  the new batching behavior. (patch5)
- Drop the PMD_SIZE cap in arch_vmap_pte_range_map_size(). (patch 5)
- Rename steps to nr_pages in vmap_pte_range() and
  vmap_pages_pte_range(), and use 1U for the PMD page count.
  (patches 6, 7)
- Rename get_vmap_batch_order() to get_vmap_mapping_order(). (patch 9)

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
 arch/arm64/include/asm/vmalloc.h             |  12 +-
 arch/arm64/mm/hugetlbpage.c                  |   5 +-
 arch/arm64/mm/mmu.c                          |  23 ++
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |   4 +
 arch/powerpc/mm/nohash/8xx.c                 |  29 ++
 include/linux/pgtable.h                      |  29 ++
 mm/vmalloc.c                                 | 268 ++++++++++++++-----
 8 files changed, 305 insertions(+), 71 deletions(-)

-- 
2.34.1


