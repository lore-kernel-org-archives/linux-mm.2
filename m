Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29494C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E165F6B008C; Thu,  9 Jul 2026 03:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED526B0092; Thu,  9 Jul 2026 03:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29B26B0093; Thu,  9 Jul 2026 03:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4AB66B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:38:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BA89140414
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:38 +0000 (UTC)
X-FDA: 84968435916.15.E946866
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 63EA3C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d0EgNeU9;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582716;
	b=KZjZXUILn+gLnb6/u6BP4BKuAcXRmgjQ3CIlC3yBQXqu4SAhG9g6Uec8VtXaozonv7f5dF
	HQrzFV7inf3m9dFtuGpD9dmQybtqaqiVjvPJ+Jrz/Ap8idd4sV3wMs/dthi92aTfVG8O87
	ws3IXXTqD+4pOAaOmDK8kLQ04QSgRfM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d0EgNeU9;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3jsvYVzwglzJMfEkbvRTmSIJAXcUa+wxxqNcA1GNkcI=;
	b=NuZikNGApJ7gp7fWz51L5O34V5SY79fK5ExMNgQQo9hlr9c4uOov4WwxtkxuJYtwPAJ7qZ
	ZHlY1B5FhSIesc718yLVLY6eaJMPxrjJRfOPccDLd8Q25yf80iqHSVXmBzBc1czNjlLTvK
	9Sq2Pg4hEaALcNkqDKk58+pSJBl79xU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8478fe07f0fso662832b3a.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582715; x=1784187515; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3jsvYVzwglzJMfEkbvRTmSIJAXcUa+wxxqNcA1GNkcI=;
        b=d0EgNeU9jliAZsnJuFF9swWdRyqwNHsdM6hfwbsekzZsuDj55ThkhtBt+J9ZH2j6Sr
         IuA+hROUqwjn07b4CyME9uZWI1AHIFtJxlOaitcjf1Fj2Iy9JQUM4jTODKLlO0cw49zw
         TrcJRwYjWiYU1aJFhITxEeU75UhcQBuo5SvEx3ZUTS5+DUhoZpKPc7TgP0nJTTgQQHm6
         ad5TsMepwhzDAxl3IIpQyrg8dV/vmmZsBM0Cz7XL2qVUAEPbP0XCxUA8dwCQgOTDXfLx
         +FnDQywZSdHuuUl7qRy3Wycp6zRREvKotptL+erBer64T+NoMJtbjzWbuIqnw0WgQiw1
         WxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582715; x=1784187515;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3jsvYVzwglzJMfEkbvRTmSIJAXcUa+wxxqNcA1GNkcI=;
        b=GLFtQOno3rT69Ux82xOTnH3Nrb1sFZLcLLQr8bUqFcBAf0g9VHns4QHbYi1zQ+GFBE
         45/Daxdr9qGAnyW7iHZKwsvhwi16yZIqTipsuz2zA9pD087RUNra+ZvC+rc5JzhSIZyR
         SPY8bN+2SI2n15TVOzi4A0Kx5jYyM/iqMadQmPY9VCVUFhSA8bVIMR0+hqvQ6dKUzrDN
         BRNWqB2zgdkal1yi8nn9jy2nBErAbauNvhys/EBINgF5s+gnHGW0xfkAKruLgKhLNKM0
         /jmAxgSK6w2zk8vZ7AIeHjJSRfre1dmCu9w7THCMzXeFKtHWrXrH6e4Yj3FSkzaMZktm
         EMOQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9lqeyvMGkwHGc9rMFh7F1pk3e5loiO72pNSXAe8I/qiXzQmAXvM5lauvwCb1u+doUSl//m70CAQ==@kvack.org
X-Gm-Message-State: AOJu0YyBHSR8h0XQYzV21OhvYuUvcnmanQRssYpZ+IrYYak4T0VtuvAN
	5Gm5+Q8UorezzDG8x6CiMRALRZm2d9lSm0clIXlBwR3Eb92ZbxKQDO7s
X-Gm-Gg: AfdE7cmGbbK3/bHO1QCS62Gm/3FbTLRLg0lHvegaF2RmVZMXPlPxeglRD/cLQ9QZJB/
	JgbVGgEnAdj7LwvjvKGoScWLfQOgwoDqFF7BxI9w1DbWCXsTvla4wA0ao/QZrL9d2zTQCYmdLal
	a6fOdlBXQPLNZtRngCa4yJOsr/6Kd9Abx8b/HbYoT9GygEdmJWR0rY7NtxQUPKHxbg3HU+DSpML
	pRBRYI2oZfiv2EneZ5fHtRiNBeIZAsireU9Wmq8Jo94tu4+TTADT9CmSUMDYgZ/FN5S8K8/8itb
	ay2vSIp/GEA2b4PMC73TGz+7GwyPil1mAdq83Np6lF8UesQcvLublN2d/Tk/Ydhqt+7tJqS+xDG
	Ey7UvQEJPWiotOOcqBtV0AmDuaiUevVlezmUd95+FOyMR0+EqopVNULg4bixxZjarK2bdmeVwg0
	67BTS3VTppIupZGqs2BBg5Zlvw6npNnHIwGxk=
X-Received: by 2002:a05:6a00:a228:b0:847:904c:8452 with SMTP id d2e1a72fcca58-84842fd47edmr5989663b3a.38.1783582715184;
        Thu, 09 Jul 2026 00:38:35 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:38:34 -0700 (PDT)
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
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Thu,  9 Jul 2026 15:38:17 +0800
Message-Id: <20260709073823.6643-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63EA3C0009
X-Stat-Signature: grrwcp1r3zuh9hzhiu6stubui9hdp9wf
X-HE-Tag: 1783582716-737888
X-HE-Meta: U2FsdGVkX18pTKtGEXeLagkMPzZ0ujUDcPJz+nZOx95RG/YvN/5o2mLstmEuTnQFFOmtn7xK3RV8YFNweWI8wvmZub8uGVef3gInQ4FG2PyI7nMfrzmc4M9IUuGtLsKQvAtMs5IEXwkF4/TNLXFRLWW4oJPjX8ucatFpPH0knfxO8DEWyC6Nqi9wKEYcaB2eOjzJtDDUEXkL0Pmo0vIG2W4uUotlb7fZu4giTlhyqce36mzai5nh2EwgjpDFTgRF6JNgTDn8WqyRaS512kHsWpDfPpAVJ0+Uciml8vq5k5G3RGEOMZmtnr5daeeHNnmIxX1LRIEsuriDAighe/BKI4jt8CyuTj6AZ5b7qYQDWd7szuEqT6D8cLl6ATs4DRPSO64nTrC4ZtyHLneGKgDxLZz/xcQyRzYNH5gNhbNeeTdd8acATupi6izO1eIHfbt+g9AwTN/Cuo7h8nufs2F0nZ70w9VJn5lazLChm2qXbD8vT2Aj8DisM+CjQhzpB74I6Zjgd1jkRiJu7RpcNAHDIOe5CehuFpS8ckcO0k9ETPbT3SXhn7d8MVZJ0DX0Eknb32/FQT/Co3wx0CIECZuvsImnuoj2RZLnkA/U87Is3hrkFPpVAc9MZsN2GsPsY0YYv2sekUbUcSp7BNc/DdlRLHlHqYtCSqE4VZhkERYchSbsiEfNJ8wLvVa2lwMs6Se1QT9Rc0q/ZMgB9mcfz+DBU1xXAbt6JVq+InELKe9LoOY/9HlYepjEevEgFDp2r+xmKqrBdXA5PZDwVZa0CfQEXqF0gGvw5amO1vPvvAK1FIkSo7ANFZFRULDk/whyeKRnTGlr/QVPMTwOOK616bOr3pqjHehUT27AjJLMrQxVFm/g/fhO6ryg/6KHsThClEJIMjVqLG+aNEdQSsgd6qMnb2jZ/jO/5/CFQIlMFI16/CZ0Q4KL7PzNukSVasqrhjeJIHR1JkiEHW8HDOJtXUF
 6wuV9ijN
 qsXNwwUo6IA207Bpwb8Nado9s47cJUAVtnSxqRL7KN6jeovsUT66UdZqsh7VGjZIkvd9GGRTyWHEVkr7pJ9txt974R6WW+XrZSDHbaHqoNK1fGS9ANmFqS1WPH6YAtqtBss82EtboZilOGVZ+sHNxDsxAtg+puRhtckH7ezP79+2aZ9fGm9mSbZxsvSQob3b/YsiVOxHn4QpoKr4oOYP25PEMMYC/4CdNtiuXOYsvLSxVWpIHme4dLvdVAzXD7NfM4MuqzXPVh08enbFkb51K2IWBhxdvllRvorBqSvHjcJVihhxxkXedVrZB7xt8gqBzz5cSyBcL49gw+oTgvieef0M1AslSFqSsczpcUc2BSGuGhIIeOly/q5ZtRt2kHEhdH1qWIIQMWpp4FhCnY+Xh99osts3IovWN7behI1fMjyT0G1spTVNa7xavYg==
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

Wen Jiang (1):
  mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic

 arch/arm64/include/asm/vmalloc.h |   6 +-
 arch/arm64/mm/hugetlbpage.c      |  10 ++
 mm/vmalloc.c                     | 243 ++++++++++++++++++++++++-------
 3 files changed, 209 insertions(+), 50 deletions(-)

-- 
2.34.1


