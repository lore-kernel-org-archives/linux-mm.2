Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDCCCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1606B0093; Fri, 22 May 2026 01:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51E66B0095; Fri, 22 May 2026 01:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A406A6B0096; Fri, 22 May 2026 01:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCB16B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:31:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ED3B1C0394
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:31:56 +0000 (UTC)
X-FDA: 84793934232.15.C7CEB12
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 633E41A0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:31:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A4XstrO4;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WSsZqaAWHj+v1vpsCxKzKu7IVzLHCQIKTgP9zE3Hky4=;
	b=gdpX3dSw21U4hGg+Li4Uz4Dd9giCpAbT2SuXFCXBSLMFnUCpQHbR9gVrcS1lpnheiOjsf5
	WCazCgxpGKi79PAkSqxHo5PWA+w3bg1w1/HLbakGPsSD3HNfzAkVcXvu00WQYvRkAZzN5l
	H85W2nYsxYXSwxTnbRanPZABPaXNzYM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A4XstrO4;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427914; a=rsa-sha256;
	cv=none;
	b=oOj9vXbNsBuuZ+ui3qSYAbUCgRtCyD56QMtTP63hr8sYNOP3ORE9lUQw6NLIyqfNSdkQJT
	GRUxu/QiTDcJWQaAC0uVyuyd5tfS3EbXS1xq2uWE/gCKgaDX7nRBbxn/PLPz2cBFg7hdX+
	irggeXLKBC2mrdsqYhTqoCF4T18fzcY=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36900945df5so3516234a91.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427913; x=1780032713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WSsZqaAWHj+v1vpsCxKzKu7IVzLHCQIKTgP9zE3Hky4=;
        b=A4XstrO49vCLBi8T55RC5eFAhowdv8BFtOFaWZhcu0lKYmBGJ5WAg0dwmjgl347eZt
         yisJOaTCTKtayytHVf4KTSYYWj7B8LafbrSs2YetpeIDHxVdpkX2IdMxdwMjyglaGBsg
         n2xXVd7iBtSEbRA8IXYQPFKCAxmJgSkYExLDSnFjgQIulD1igkQ86tMzBBUHunZzkKYk
         9/cjBM90EUup706QvLsFtxJgmZWqIqw9Ju7g2N9zsgnbPigF8NUOSLLkW2G1f1P9VGZJ
         NnS76G3E+MUA55Zh/WmgiDJGl0Ik0FhtGpA+xhSj5LHQIJVZO2JdtcU0jC4bR3LcqcQ5
         k9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427913; x=1780032713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSsZqaAWHj+v1vpsCxKzKu7IVzLHCQIKTgP9zE3Hky4=;
        b=RFk9j73eK1NW2UY1wWAD/FKomS9puF11ijliUPxzANxhOtUiPpLixoJjAA11YNM0c1
         74BKYKU5aA0Px2IniO7yjlrcTZk8JA8bS51Df7lNBOXf9mD9VFau169MJ9z2OPbunbNC
         qgQFg11roOiNb/nSl8k+GHy+4l0IC20Sad3s8ULU6wmVHy39wv4qOLu2p5NK9mAvWMHp
         KGyc3hbtwv5x4nrUvKtZZAPcn+NAucwkTcHfqzFMl1T3x2vCAXEWSp4qwKIGWOVq9jA5
         y0i9d6sP66+mzruYg+FJUdlhBPJVyCWVLS4FyVNWg9hgWpFaVrnpQ9L/qItsnNm1ZzK7
         caRg==
X-Gm-Message-State: AOJu0YzPPFPyTXNkiUe4pbUoK5rZ1IMxI+45zrzICj+3U/iEnuMmTlBA
	X/A1SSDxT5B57O8p7u6+96jIHzjKdkMDnCIXBgqZgx1HPonY3URqZqrdhOq919Lg
X-Gm-Gg: Acq92OEoN8KcAEHwHHWp4sQpGcuBMMgEgRkrzwLFbCbBlQPJccym41FzlPhb26qVrS+
	FAtMGy+PkPQFxhjycxY5Hk97GCG4NxgVUN3bY0n9ZCT/VLsyp2EiBfmLIotMx+s/I4Q3hFWl0Ck
	JZiwPJKd3GsTeNeq6q7gdub4jSQGoKOSZgGlcQXDYYeqFe5VreiNqJ9+WcSjXKGjVCmxI5NxZg3
	x81lrx7UzUZesSoCqqQf72NenreJ0Jp9y8cOstkefAPxkrV3t1vOUtuH5n7wcMy+AWFItIyNO+e
	JeXHWi2k8PTHXgTJ/ZvDnm94BrtWWNXxgnVEwet1zejEsvR3eaO9tFPALydhVCkUtpNsDIiLX8/
	fmdwNAPm7xnqjkWhew5qMxs+MutWB4nPozEWck3ZtC9Rd/wVfz4jiRId4JztXUiPLLShsJ4ke5i
	bfvYv9afHvJm9tF66ZyX2Ji77mZMs2R3luJ1Bw31Iidi6E6VjPXh4=
X-Received: by 2002:a17:903:2b0f:b0:2bd:63dc:b7ad with SMTP id d9443c01a7336-2beb05a227emr21130695ad.2.1779427913092;
        Thu, 21 May 2026 22:31:53 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:31:52 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
	jiangwen6@xiaomi.com
Subject: [PATCH v3 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Fri, 22 May 2026 13:31:40 +0800
Message-Id: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bbai8xag9kstymjx1dt5eyo73ezf39c4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 633E41A0004
X-HE-Tag: 1779427914-859917
X-HE-Meta: U2FsdGVkX18ZOYMbUkBcLodEQPTchFzX++1WliGlTALwAeHIKxmTRG3AZyKK/9fOEkOOQXaCi3VCRWNdpzqOWLsvmYxdM3CsEmGBfM1JM4qxOHOk27L0xHek34oDAsCd2Ta8SS6c1bDOQbaOFpQqDUtReXSAHZdZE99/5CTlCfV/YO9nTa+ldt1BhBO2Py99J1gAxZgLpsKnMp9rzlTC1N8L2DK+QTSX7gg0F+/p726o/M/sUSWI8PDE8ZbkZ8WsKGIfl3InlqEW5QK/5SqmKpfJzMVkodyQ8fF1qpZPi0QIQ3l+99JH1KD35NQ+X5hSdFoQ7KD9YO9rmmwHrPM7FOsheQ40dEGbf31wfWsnRUGWvvaTn/9LFyvEDAVJeJDWviZyraHa5b5WnTZsAD7btT2elN1R1thlJl0pWaTIyT+oWKIrvGPNng3zIOe1+noemwbf9/vpaiGV27OXBHYt7j/l8+OvsYg8W/BGJcr9rOFyYE93tEJwXOX1u7Cfd/p/yMGEhEyQSFgyUHPkjXAdFYINudcqD70z4nafc1LsL5ILXdLUYd9sZXBxrYecg32WECmIBEQg43arQ5a71RgIarG8xRSt1GYSs1y9tcJLrUUCl5ME8XGxuip5l09V1kJy/LqEK6CgIdAfe+EmVWiUjakV6i8UWiIjQiR2E1oHaqkTkO+6WEqWfrJMN9SnU81QJoyrkLGhiJ1eJnLceLGG0Byc81GgTU62b7GxjzdQmu2oVPynzB7bRzrJO5FvUKTU2mZ2eeAOQelZpw2OcMzkWpIsyVeV3aqzCOoqdjMO1IC9htvDp8B64a7WeAehHIaknA6ZhX2jtGtQ1JLCrOKtM+Oq/uAWu37VfDEwSKSDORG3FcRE8sbobNdQ16eLQBTvleYYNpAuj0lA04TIvfBpRuvoENNyaqHpyygOwKBYiGH1zWVb7QyhCjUiC/TCMTpYmjNSoeDYXAwGGZ878Qg
 SMov6Zmn
 wvy+0a+DQBoZ+rGQyVbBGEnbOJzlBIGp1X1HCHwwPuEV5vZ9nN/Lj2AjzFr2IQOy69wh2rxPO4xzUlUvdpTmrhKydmcytexB5mx33coIfYTkywK5ghOaJO8lD6vqhNTtlE1CsojfH5Opks5G+pScjKjhPle7Kmzwl9uGPXURAu+46Zze5M0Ob2y4dUWL5evw9Msg/PQNxgfOCmGsKPojUWhd4Y12JovI/xekK4Smdv6vMIJPyO83J7FZQszTmxjAiwuRmvlF1N6HyyusxIt5681LC9I4Cxe4PzLqetsh35bP/XyXG7Lekevd+fGmTVIvoQHlWT6nLKNTKQg5NpDU4Lc/uTDF1lBPqyt3nu5NB9l8PjQnu94FVQKkSa1/qYuJgNTbO7yXzAN+T4G8eV38bV/OyacFmUVPg4ZjIfDAtRdMurPYgAgr0SL7qP5HUBiNPYAkfjYDZmOcM9JvrayMv8JP1ipgIfxvSAx/Rv451lh2yB+WOt5JR+5AkeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: jiangwen6 <jiangwen6@xiaomi.com>

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
 mm/vmalloc.c                     | 235 ++++++++++++++++++++++++-------
 3 files changed, 201 insertions(+), 50 deletions(-)

-- 
2.34.1


