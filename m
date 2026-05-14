Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047B1CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515796B0088; Thu, 14 May 2026 05:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6566B008A; Thu, 14 May 2026 05:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBA76B008C; Thu, 14 May 2026 05:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F86E6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:41:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C87FC1608BB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:40 +0000 (UTC)
X-FDA: 84765533160.23.1167CA4
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA2F9C000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRE+fCki;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nxjbBO6XBWohQRwRzUkPRE1mQeaWFxMCb2Cc9RW2UPo=;
	b=CkWd87cYtRS+NJ4inFLTcoN0DsOCPPaXzgRGp+pCo76dgEnDt0jfin4ZKn0l3UkMAfmWD5
	vykUL7TBT2uhFIQcHL8ZHJ1hrDLNuVEcmkOfEOGE8KvyhPpTVjDjmoX0BFNTRxi72DqfZ7
	nP+I4+QZzvF8cHcYcKu2wX3CCWgMPI4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRE+fCki;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751699; a=rsa-sha256;
	cv=none;
	b=BjMkjkHB0VtzFzqTZbBmAHRMlgHS0z+fI0o1Gk3XX/69D9A7R4fKaIZUh6WuUc5GJt17pX
	fTQGBQRmQtsKnZPhgx4D0ImrJmQ6ACUtq6BAp8pf7KJVkdFL8IHRdz6Uu+wkAvAFGc7OCJ
	1NeUZURhfKZxEcgAH8jeHFTliA650L8=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c8021c8c42fso3370564a12.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751697; x=1779356497; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nxjbBO6XBWohQRwRzUkPRE1mQeaWFxMCb2Cc9RW2UPo=;
        b=pRE+fCkidfZmHV3e0J89oCbt+17ki0CiTTUARW9kIRqkCAmpOxwjdJPiht1rAjEvT8
         I+UvECyHWefbY8Vg6mo3R54vU5kBiXYk06350C9lWCdsjsH/ZqMigwN1Y2QVESzZBO2a
         WsRpK9F3wk1cfI43XGPKcnsVE5CEQO7WBGETK8HGLsvdaCQpMgpl3SpZFAx9Rg3Gbtbt
         Rsx+E1RinLoPLITsdt+cLbDTJOixhIn/5zrkBaQHYFyTtVxpzqlaxN6foCGKJxfbNQHj
         FXko+zhewetWkdO57DCNXUy2JydHMgn6rlnHLvJOi2D8YdUgckHM32oDxDMN50it1Gfn
         p7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751697; x=1779356497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxjbBO6XBWohQRwRzUkPRE1mQeaWFxMCb2Cc9RW2UPo=;
        b=buYMYSPllHbq6Y0H9EiEhYP/SucBIBurytFUG8Q51Mg8L6c08m/AC1Edlm2kKCrbhV
         CHrjryzRlOcyfaTCoAHsnhbYT/Ob7EvDIZnvnx4vv1kbK0nYa8jfpGvlb/d1cVGp4QMG
         ItZ02uWvy8hmhSHHXF9UHP/WW6FD+7Ew9lHmZMzMq4u4MaKzIR/7UQxG8F3hUDZXv7O2
         IAjvfMYVqwLPztJx+XBx/OToJ1Fx4H/cTiwnS1hMjXyc0Q3o6gXw/r75bujHLQyyEznk
         rB7XFRBxaZNGooVlyMCEAtDZ6rVgKx0DebVOZiQTp/7eNyQvT4SKqBFODMrf9dz6yJNS
         F4HA==
X-Gm-Message-State: AOJu0YwOXBuv8/nyTNFmJDl4JEyi89mT6S+LUdS2wGhwPV5IQID61INO
	6j9d+XBnnbgpMEIJpjhEESsO96edjh9el1fucTbIqZiWQwxLxmoFDKIHNC04b1kQ4Mo=
X-Gm-Gg: Acq92OEOzKDmPohaGwvIEDIXRJkIXwraEn9r6D8/wsKm+g0Lcm3PAw1at/HgTDgEUrZ
	8LRvtpLCvwAZ9WEK8rX22qA+hoAvBkbmzcRzb6gdFOgIO7YpWeZ7msOtZDG5pRe5scg+Q/tTNNJ
	lio1IxmhZGvfY0ElupmUueUGXJRo6UR8H5EbjwaHJXpokAMYP59S56Sq3OpV6fGkSeQ7DP7ltwF
	DTwgmvyKYHhnQwnXFndKGhXXeKeSgdzts/Sqt2AVyS1xNSGT1mKyC6R8LhZ/i5u1ofXw2JyMXUN
	LJWhj+Db9UosFniFuSahw7eyDn+feuAY3kgiWGFMPhwkFBaKwU5HFNk5q4zdsBBwHMVncgRKuPy
	LzAZkzGcDF6HJyeMk6less/A9DStneCSmfFZwWoyQuLFKTff2viULISO4NDLMKy56KcLOBq44C4
	qJr+jID4fonlJY5MjdMwWEBqvT7icwiRFwh6riObmMFgItZQ==
X-Received: by 2002:a05:6a21:3294:b0:39c:787:f197 with SMTP id adf61e73a8af0-3af822881d3mr8281874637.36.1778751697073;
        Thu, 14 May 2026 02:41:37 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:41:36 -0700 (PDT)
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
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: [PATCH v2 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Thu, 14 May 2026 17:41:01 +0800
Message-Id: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z1uo7aiamann9is99zhnwg1hdbepijqf
X-Rspamd-Queue-Id: EA2F9C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778751698-363203
X-HE-Meta: U2FsdGVkX19Ut6cVP97lWOfbv3f8faW0c4JeIt2RhRsLh/Gaf6qwIE9/uJqg7XpZnQ0afEva0Jfj5Prx3SEuVIJ2p2KLEsHkhffldS2Y0TsqSBUeFebGQeD2Mb6s/X32JcJVYUceG9L+6A+irKjx+MShfLnELy5vcDZ+bfZoVhEZdOAgOwE53kPfFj5ozWDF4DpBhZGx46nCHtaaSfY671nZ2I2XALyMLg88b0ucQd2ROtrkJRBPLKGmKgim9gWZfBh3G73ndkE2DzM6z/q+6iNvkss5y+A+Zzz9QVQdpacBgTijADmMFDkNbqh8IPUioEsB7wLYsCr4v7TtBSKw5kh58RKa52q0Jmj2o70O5XsLHyGI+WJYVDtpz+ArvEF4tAueshtD8mU4mCtbJYLhjXogNu2PdTY0nG/e4veZHwAjUEawJPI16L0Oc0S7WxTdcY9ULJ9En1BfJjYUUE7QphbfJDaUSz29rH1+cYRETboXbrl7RPqDxSI1smpgJ6hjhJBe3X6IA4UxK+3WZfrTwQN0VMZQLT+J/X5fq9Xo2vWYxvq0xK0A+Vihn6yWLxiPZJpw08E9cNovg2GcNI3BvFRu7DPsrazphoL5KeJLszpCOhOEelq+xRNuirCoobekfZ68iY9ogiosA5FybGF+5ZOaF1AenT9+jilgWtc4gVJD9g99UWfUx9QHr3xx4sdo17prOLFyDPnjtMMnV9i991bUWHiCzEGrZtsJBmdhelLQMT6CcOdIaX0v7CZJFSMv+q0W5v/90xS2ata7UzhG3VpxMjjOidxBKuSdXvRuP3F3lf+ZMIaGNXEuLGOh6bracwTyZP5MHinNe3wCy+laaO9oRzJjctNF6zILK4KfhIz/kwj+dVSEStFKHeD1/EYTXfTEepuopxjbJMcbOlR/f5Rq75SsBShBkeNdS0LSlDNNaY1slrokG6j7A3uR029t5qClCtlF3Cw8h/tkZ1I
 siO3aPmj
 mSpyPQPWExfziCigo2IzMyftsz0TgoX5KPWERca6Uxeo849PLWRnbUkqv5zz3bCc6VTnzUaBOWLIkagBZIO9JtzgM1rEeUQBNxYL70nM5KXTkzogqw9VXaIlHShVNf4lHX8U/5pcTRnq/MTOi4GAEn/FDnip3+y5ERtHlqxegv0+dqRwLQk/bIKUV9Iw3nsOSFS14k4JLAu0bF3XqptNqdfoSckx6LLq+AJgtMrXoMQNVbkRN9I2gGQ4xGmNpglvOryRFPXsDsVz12DhTkyk1aDIeJnFe/4C5lmCUVLzSq73RSAJGDyC6wbECBB++0RgWdiM+xPhp3c7XDdvSUHcqLCfJOyzhCQWD6treFWl1VqODJ5PwD1riBvdyZPJUf+gkyh3gtAgMvyKB/VjgoXRAL40LzcOioqxICSSmpMWd5a+vSWnvlONdtEEgmzZ9MY5CBJRgf95Zc4R/rVE=
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

Patches 5-7 add huge vmap support for contiguous pages, including
support for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
the performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35× faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42× faster (5.00 us -> 3.53us)
* vmap(100MB) with order-8 pages: 8.3× faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

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

Barry Song (Xiaomi) (6):
  arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
    setup
  arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
    CONT_PTE
  mm/vmalloc: Extend page table walk to support larger page_shift sizes
    and eliminate page table rewalk
  mm/vmalloc: map contiguous pages in batches for vmap() if possible
  mm/vmalloc: align vm_area so vmap() can batch mappings
  mm/vmalloc: Stop scanning for compound pages after encountering small
    pages in vmap

Wen Jiang (1):
  mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic

 arch/arm64/include/asm/vmalloc.h |   6 +-
 arch/arm64/mm/hugetlbpage.c      |  10 ++
 mm/vmalloc.c                     | 221 ++++++++++++++++++++++++-------
 3 files changed, 189 insertions(+), 48 deletions(-)

--
2.34.1


