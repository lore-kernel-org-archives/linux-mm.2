Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73153C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5836B009F; Mon,  6 Jul 2026 04:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555BB6B00CE; Mon,  6 Jul 2026 04:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4455E6B00D8; Mon,  6 Jul 2026 04:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1891C6B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:43:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BD1A1C7B6B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:43:52 +0000 (UTC)
X-FDA: 84957713904.05.AB02294
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id D4CE41A0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:43:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R7uVCrqd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327430;
	b=g4OFMxui+iUX+YpSSsLwajhwS92qbBa5sNPdaoLVsM7j/42qyEtCaMeh56QxqZ+cGzbgO2
	a1IC+DCwqk4rWg3ww3FWmh6y8CGKlkzLqtiftP/BgGgPNEqgtlgtK5JD8kuZBW2Y14RfXw
	C/o0HiCLlWERxJPkw39YG5yK8rLxmRo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R7uVCrqd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=itR8BbvSOUPvqHuUaLoncjOsPFlKikq0KEUNB8ftVG8=;
	b=FhTYKhrpZFfs15QOx75aiu9ebb1oe1tsYVJzGPxsijBdxkXlYpYfaN86OzwO56vyRjrz77
	4EV2ZNVR4aJTGLiSkupN60cPyoOgXznVxQQyx26fPoxy2acgFLgrM9Sqx0vW1tuugwcJ1m
	Q39kUaHZF/c5+2pmRawzlU+/NO0bOMY=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3811074a8c5so1892041a91.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327430; x=1783932230; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=itR8BbvSOUPvqHuUaLoncjOsPFlKikq0KEUNB8ftVG8=;
        b=R7uVCrqdchTzPGxCjtB76MDL133JD6NR1aOTCGYacw0K4nVgrsAolfLjjHQFoAh21E
         DFHnXxeUqhdUKgmnjJmEayo/eRCM+7vNLURuHeKapSdFNXUF772Nds9JJ1HFiLDWDi4W
         Ici5RXVM/+iclsNbIgMETopJXYOScQ+p/AXMD462yXh2mYb7P4JK+g8FjmcUFnIzra0b
         HhG944Gep5L9sxymgI0Cgndx+06tzvqZB/18FjClZrmQpryRvwxhMqaRIlpC6A1K7L/d
         /bhcJO3MZBfN8X7HDQTFbGLev57xdlmniy6u1eXdOEzqjCkeWa2lhso1h4yYa6wnsWcy
         CVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327430; x=1783932230;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=itR8BbvSOUPvqHuUaLoncjOsPFlKikq0KEUNB8ftVG8=;
        b=pUtw+rY5uAUM0yYCa/JTBkwuaZKEqhWpRuwgqqSV2CE7XjxsjKkq/hvaY3PtQJt7Om
         FwMxUBBo9tTCMAVEjTc1DMOI7lQnogQJAsmI2n2CDcWjCiwTYQkjZdUAZtu+BuXrjqZB
         5RYMfHEqv86PSsCgB1L5THLPX5nKGZRkh25CeGg2CJzxR/2PStGtNa8BM9xCaK2lhdtV
         OJH48YFgQZ9i9uESfECEWATEBSONQS+rNM66XUHh5wAE777KWZHfdg8R2Iqv7AcxYu6B
         BjHn2k+pC49nxuze68vBT8yYI6jIVAq6TiLRGR8cYJtjw39BRkrSI/s56kaybX4k7oXn
         8kXA==
X-Forwarded-Encrypted: i=1; AHgh+RpIS6eYuNZnzo3H5qQdyQEsZ13GIk74o1cuOmccldk+7BT8dF/Jzvq6lR2IiW5hT2U6gdBt124WEA==@kvack.org
X-Gm-Message-State: AOJu0YzKcnCEq4e8WRlrEtTcmYkCLTtOKVhyKgBtb+0eMcjHZ+iTA0T3
	6YcmqAjNP1HJptQXGp3ZDeCN+ZPzkC5nbKe6+8knWTTV/emxF2Qx9ph7
X-Gm-Gg: AfdE7cmU3ovbbWPSbjATbW4aqcVgu2GqDxK0iaDtm7qFcfjj+Ko/I8csyvONEBNKnEm
	mTfhOq4kiozEUeWWGDhIiuY6Kls9sX3LOVziwhvRf8/z0PL2SyJEHFoQGTXYngJT67EpGsOS+7g
	Uec9Zo4ZRLZtdcJe28vhds9QE7BMs3/hg0ldpSHTZjPunryS034I/G9G4fvLjkhJycZPyzzj0VT
	qLnV83X4JhXjtf7XTxrVpvfc/iIk7fqa2z/dn/GtVpc2Y0dkgnkj4Ul3I9vKk6Ytd+v16Y274Ov
	JcD6paNseeaxBN4gXFWB4cDRcdarZ2zd9gnVoWQLpUoJBy4rniX1eDHarT/aJsluCzE3RUTITzL
	l4/uriaTpAKt3BVO5DukTo6e3cEEnsl/t3gPGndlsqwMtWDpwpPfv9R91DddO28k8LDTIXChmLH
	sUajrN/HAZfjU2ndJx2gicz+SnuQ3+MR7T9Ic=
X-Received: by 2002:a17:90b:4e8c:b0:37f:eaf9:4682 with SMTP id 98e67ed59e1d1-38280d9a4d4mr9682881a91.14.1783327429729;
        Mon, 06 Jul 2026 01:43:49 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:43:49 -0700 (PDT)
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
	shanghaoqiang@xiaomi.com,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: [PATCH v5 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Mon,  6 Jul 2026 16:42:26 +0800
Message-Id: <20260706084232.177786-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4CE41A0005
X-Rspam-User: 
X-Stat-Signature: gmeaiug388hyx1z9dmdpjxrzqzdiy9kd
X-Rspamd-Server: rspam03
X-HE-Tag: 1783327430-352573
X-HE-Meta: U2FsdGVkX1+3wDWPD5LEppXM7neF6echxOwOz4FRMmGggWn0NtCo1VT90y4vnnetGVF0pzJWb40G2cSFOWCAOnI8DMHJOgo0U7Z78k2h8DnhCU/r1fryCmiRLFXw3eQDLN+mj8+RFtax1UEkmuJ6DCGS0PQFe9ZB7ojygNxwJ0b9G2vbAG7N19ZCNaa61Q8jPGJg85jo2j9eEfbdAxaFFB+rZiCNVABXW/35TjLgqgKj93YxMFIhZ3qq2Nd8iXqmOpl1heqv/AqoY+gqzUGHSTv0ZuhI6SdSPNf7Nb8H8OvBFKNp5cXVuVxBl2lzOq6uiDOE1cGEtod0RPlvqgm2gKiwOqhrBfjvWxVQtR1rJA6zFBtJ4HpKay4DE8YnYejYqH21A3wXJUU/u1OleANgjiXgZVK/5Vpt3uVtkgwd9+Y8Qatvm+zYgh753K8l34s1tuzQkWwnVJgqC0dOFnun6X5JNnTyqvTRtOak+svUk6jFPtA4NqhC9q89wM22xMW7x6RkmDnGzzYpFUPk+JcgHwjg7ZchuLe1opY4P/F5ufzVVpOjOoy4A2syh5QDfvEn3SUHrM2DsX/poVnM8taGzP2CflIbYG0KWmkc+tsyE/Ykhtq8Tk/YYYlKp9NLF/sqzv+OVQ7ISOmrh7/d17EUZcdhenc5MaqNxG+3qaeAH/WeT6/6v0Q0Idr1wb6yqVJq79ROboRgTbS0V+WJgNQbuwcTTWMGMPL3NAMWLaUJRRSKURAovpBJ0XfxOmDb5N4swnV3VzI+mlMCH6PzWOlQewQPOknfOWprEntKjDO078a2cvJd+6MfXMW9dF9sg9XDvVmC8eMCpadYPPqQUbHKCLSs1vsoUzi/llDhH2r/PQOE4L6nZGlvEVAHmunzrREmE0UDHSnZrgMIAoprSw23JrlPGgkUwq0qeU3GiroP1zXXIEU4nQMs9GMkGtSHX89myqPe3qWayEqy0+4gvA+
 zps2FwaO
 FQxH6bobBKrB9p/zlhMC9/0XtkwgGdqJpOyH7nGgmv9Lg2XoLRsh+cBZVf2qd3Hml4Mio6ttFGat9bXkqZzvlKPO2Z51TzFW4QHjkL6bVWBGW+nYtPTVZG26cozotd4To8yDgGnc8/Wd6L3dMtO1kiZaWDqZND3kcoA5G14FtNlOP5J07t+vZY5UTaQnJOs5wDTq8jEjzmwrUZRCO6zBWDjCMPbQizikiNYdeZzWhtZeOJ6NiLPqDO+0tMgDEK/FlHFDZ8ZWyUdmBnwMsiaK9OoCZb6EPBSEhGKafl36ZiVkAFC1Zf5v6rT6nVilOO8JfiIrq2TuAXdDwGjA9hOzv16dQ8Ug+ju+A4OJXAMG7yd/32m/UK/Z/g51yCy0G8HgyrqNT2ZUZtsT7nlR4GaLoGK+Var+faECVKZa2tWntz2JRqo2bMvMuPi+3nA==
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


