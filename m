Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC24FF513A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B6A6B0088; Tue,  7 Apr 2026 22:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC7E6B0089; Tue,  7 Apr 2026 22:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2266B008C; Tue,  7 Apr 2026 22:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC4106B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EE2513BE55
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:35 +0000 (UTC)
X-FDA: 84633862950.01.B7F5074
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0656040008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bGlckLx1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NsrZbLl1QzZTc/sVfW1bjaWTpzc/m8nfU9cBBbRPadA=;
	b=EMVJWwadsLRUsOIa9WZwzpKD6zq4HMjqKyDUgTj5SnZ78YV3qwnj2qguf4ECo+VpYHFseo
	n8OFK4pnALgkaOIonvZbuKvvtLmJ+EN9T0c7NVr0gur343ebZe+6TDVuS1Qho0/fKqc1Kl
	W54nfHWWpbAnCjkeKrG3AeB0QbmvwMo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616694; a=rsa-sha256;
	cv=none;
	b=euONFROf8ogtPWDCvBKiu/63hjZw16lC8t4YjkL2oootlVuWQuoVYKTYQMDjCsTdtCf4SE
	wjrnlWJ+I4S5zie9AAlnwPDjKrco+FRwSCdsDm2gDKf+4DIMXWolZ1ke/ib44dqbDb40AJ
	S4Y3MIG5RmRfMeYupohDmCNalV6RtP8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bGlckLx1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BEBB6012B;
	Wed,  8 Apr 2026 02:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20871C116C6;
	Wed,  8 Apr 2026 02:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616692;
	bh=ZAYGoVOU/xBKdOabvdM+YHz4qLCWVs6z32hXbsZWLKI=;
	h=From:To:Cc:Subject:Date:From;
	b=bGlckLx1cBnsEHrKYQQDWFEGJw8n34hukhP7o/9LIps1uAhfRIBIc7D1zccT9fcDY
	 xmornJxJwwxJMSez+qRcwgSuvHPbPEnmHd1j0BeVr/H1FgTNIGOfoGgOIqQr9oR9hs
	 V5CSoZMm80LxqS5Y7C1/smRaUcFTy9oDpk5DtKA2AaSIFSPYF5ZGCFKM7Tk3miJcNj
	 GAh5hGPrnTeQsmrx434opxdiD94Qw3c0lAjUjJQY6j6CxuPU92j3euAsVqip4o030U
	 2kdXk1l0R4FW4SzBxRqGqUrR5qyoVeBUSd8a+Op0pA8z3Fe3kbraGYLqq+CwLz6DB6
	 bi9uYsaXIzyMQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 0/8] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Wed,  8 Apr 2026 10:51:07 +0800
Message-Id: <20260408025115.27368-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0656040008
X-Stat-Signature: c1fejwy367phj37rixzuquwfgonaubxn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775616693-93282
X-HE-Meta: U2FsdGVkX1+pWogLMYp7SwHGyeK1U8SL1PN8YrLu/W4Tx97deh33DiRQiKJbXnEIaEnnDm9hheVbuom+NBeTKAlUmf3jwpSY35H9XPwnrf1nZV3uFamQWMc5kS3+Dqaar6T3RenNjl9l1nuLeqavlVANmgPvuQ0eUjiyKayvMjtPhoxHfdY+GA6WR+MAKjKOVPqkHezFt9MTr7+626onDwCPqb7gjkTajPpm4IaanuO+Iz6Ouwj2KeCwJY8CDyBuIX8XQz8f5nWW5BO6LnIocbafvOXup4EWIEt9IanDr87FlhyB2s1Qp/u+m0VMF+uFPJknmmGaZZ8FuqqV8gr3mBMq4Ov+FPNGoY+K3OdZE3abhcmeepiGTSWCf1hq9hRf/+Fq2dQ9WwDLvjMGKr0o9Vo4qLeclbbUESs9Jzs9RpIaumIodsY1HMWOFxhDyNeYLdNP3r68/x6G4D9ZJ7W9K9YP5Uf13nKj7JFT8FF2BAw/WrNebw/x92ijZsshht5LUkbvgsiKs1QaLxq4Kw4Fh3OelM+W+FrJEfqJ1SoT1Goa3KEIviHieM21c7QgxMNkOc0dWP5VQSfjX9HrhM0don6jLNS1xs5IYV4IopgEP1TRj6gyQmIE5yKrEnlQxLzlzAhsi7aXVS4POr+hcAU4iX+tjmtjGHiDxGn2BjU+Es77pyhy5PxTz2TWcEDmsWVipH7FLmTsASpi8JO/ot0ZsJgdg5Glem2j4uEt3x0gdG+WpovDSUuapa1XA8NjpvkgAbZ6HWBkmks4HJSOd4w0VPNh/0G8TeUafqiQTV662rGn97VyjTVFKnoK2/oLsIVB5AdQB2hyqBLdrQcFPWZVJ7eqEkikC5gXqoyqUBdn3xZZHDAR/fTY65TZX/IpiC3lU0N1Qy65koImjhfDtBGWGgaIgqp1m01lhhVPfzbCNcrl3xQfBAZ7ITxUcvlbfIdnij4so5lb0Le7b6Eky0p
 QdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset accelerates ioremap, vmalloc, and vmap when the memory
is physically fully or partially contiguous. Two techniques are used:

1. Avoid page table zigzag when setting PTEs/PMDs for multiple memory
   segments
2. Use batched mappings wherever possible in both vmalloc and ARM64
   layers

Patches 1–2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
CONT-PTE regions instead of just one.

Patches 3–4 extend vmap_small_pages_range_noflush() to support page
shifts other than PAGE_SHIFT. This allows mapping multiple memory
segments for vmalloc() without zigzagging page tables.

Patches 5–8 add huge vmap support for contiguous pages. This not only
improves performance but also enables PMD or CONT-PTE mapping for the
vmapped area, reducing TLB pressure.

Many thanks to Xueyuan Chen for his substantial testing efforts
on RK3588 boards.

On the RK3588 8-core ARM64 SoC, with tasks pinned to CPU2 and
the performance CPUfreq policy enabled, Xueyuan’s tests report:

* ioremap(1 MB): 1.2× faster
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.5× faster
* vmap(): 5.6× faster when memory includes some order-8 pages,
  with no regression observed for order-0 pages

Barry Song (Xiaomi) (8):
  arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
    setup
  arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
    CONT_PTE
  mm/vmalloc: Extend vmap_small_pages_range_noflush() to support larger
    page_shift sizes
  mm/vmalloc: Eliminate page table zigzag for huge vmalloc mappings
  mm/vmalloc: map contiguous pages in batches for vmap() if possible
  mm/vmalloc: align vm_area so vmap() can batch mappings
  mm/vmalloc: Coalesce same page_shift mappings in vmap to avoid pgtable
    zigzag
  mm/vmalloc: Stop scanning for compound pages after encountering small
    pages in vmap

 arch/arm64/include/asm/vmalloc.h |   6 +-
 arch/arm64/mm/hugetlbpage.c      |  10 ++
 mm/vmalloc.c                     | 178 +++++++++++++++++++++++++------
 3 files changed, 161 insertions(+), 33 deletions(-)

-- 
2.39.3 (Apple Git-146)


