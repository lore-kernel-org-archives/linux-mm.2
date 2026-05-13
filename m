Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA3CCD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03E56B0005; Wed, 13 May 2026 00:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB55E6B008A; Wed, 13 May 2026 00:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB436B008C; Wed, 13 May 2026 00:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE346B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C1BD1A0716
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:14 +0000 (UTC)
X-FDA: 84761159868.10.8285872
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96E0B80005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qANEcTeU;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uMfTa9s7P+Vwc9gAJlqbhpdF2L+yd3y/frV0OQ/azyE=;
	b=NSkHO9HSry3Z1tIjaQt1SiFWtlVriJ12YlJVwcSKSUWfQj9Zl3Vc6WxaOhO0jlxDSogzcx
	jWaYgJtsatNTqgd4n6ck61F88agxItaZNIWugPYnX7bDxVXEHQ/DzaGYQj2e7Wej7lCQ2g
	An5Y24CyQPkZylHCQ5pTSZWDkuvVKzA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qANEcTeU;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647572; a=rsa-sha256;
	cv=none;
	b=yfbY+QWHQWSUXsJAlZxB2zx1zpmhJ8b3NbEo49O3H3dfxZ40Yay9A4kScOA94ZfL00m9F+
	swnDLooa6DIirJFMJHPohUic4lXmdjE3FppDr+s9P/Hkn+vx0Bu8Klqgge288kiUQvePVz
	+0jBgwkbML0fkBb0f840NX4H8EYKjXI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 783F2153B;
	Tue, 12 May 2026 21:46:06 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D50B43F7B4;
	Tue, 12 May 2026 21:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647571; bh=Ar7XRjBBDowNlfF/xcbZsfZm2D+LS6KtydMQMhNZaVg=;
	h=From:To:Cc:Subject:Date:From;
	b=qANEcTeU/Dcys3FkZw/b/PRPRE2ynTMco1ZYTgX/Ai0vu7esyMOaPI9mrj3ZGiakP
	 2etoVXei2M3NDfELKQUUmNoCEjD8EgVoZdQHsihQ6wyobTh12gCNMVdSGrOb/qqJTB
	 FF92cNEl94pedZ9CX146Cn2Zgf/i7Ml/SXhmhQ0Q=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V2 00/14] arm64/mm: Enable 128 bit page table entries
Date: Wed, 13 May 2026 10:15:33 +0530
Message-ID: <20260513044547.4128549-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: atrk5hxwrtus1zsjhu347kbzoaoarb4p
X-Rspamd-Queue-Id: 96E0B80005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778647572-361274
X-HE-Meta: U2FsdGVkX195+RsW3ldS3itcLOu2lwyd/RJR5CvecgbguaTOVKGlGl7ko7ecGAcwGBlnPJ5juMSBxEV/BPmZduqPS7mu3Vxgj6NQeOKT5TKXhv66RTuX8mJLEaXyBXe2zN/pSWd7JVtlUBU30DdMSYHZOnP11uNuv5Xc7FfmmnKEV5ElTrY3CwOBGBi1tdJ8fjB0Mx3KOWx5XeW8maezEZbB7G5LoOcP3cmj0nZ3mRPM30FCV1P90za9vo5cCKuBeYuJ40xbY8h+FUinGDEMmOSjhkET0ySet/3q59kuysh1HkEQa865p45dBEcXHafr2JfbTKr1HLDgcl2zGhbFNDtKKrXhOREbuKz4e4/oX+72sD18P5AGQ6r4irgZqeBYT4QDYoHVBmja1CfWASUtzGV0vQqvbXy7p7FbxtQJXmXyGg89B1VNIn3EKgdeTlr4K0FS51b7EHXqmg53YhqEssMarGZst4HckzkoSjFW3bF3mM1TKSUSAGLw7J1Zs2J1oB7/jOL15Mvk8t01DPWNIc8VnlyeCIABy6/zd9SM+4mXOERkcPLb+piNL0b1TALSBkrcGVFi8gxqhRZNGc+jCQJwtVJChi8bOyFaYd60FD7JaLjQJVByKh/7gTQma9MdOZIrLtbuXU11RM9xwBL78woqEBd8JBW8yIj84LrcFa9GY0FJ59w+/k4yIxAFFnvdHB8KX4ySYkna/vRnxEEzLoa4dMh6VhsC8VT+szvKGC7IOSyzzKNDV6P/y6P9ZbVbZb2+4r5oBWlP3B71Nmb1cQrQB0Vw6OhDdh+Yd8pjwM8n9EkXUW3ZSH0haZKqCNsysUEKxNib3xjSEGZlPKeQJwXWsmhOCsODhptzQvVRgSv+jh2pcYsDyEhXGEiTNbBlpShhHaJCit0ihU6my7W6UgqqWswpmdtiuZreg3AEzC21j1zib5c2Jbfgiq/eD+gxfHYfBBO0YERb7AKKdKh
 aFOgfvFe
 clORcVc1gBIleCsoRr1TfEKioasS5sGxxKcOX+zH6EY2NC1GO/IKzSj3as+qk5jJDm7GqIJXRqJYFOUZ7JNo9xO18wirqxUzTSB/EQcbKZ0/zUKzsvjIs/tf8pux7EhYn5TXwmbJigM98M6jGdCZCzXfKtcF6g8nGy2jS1YUglusdE4Gi+sxQtIVYU3vPepN6WKycEhE/3o7Wa4W5uLG7efnWHRvR+DWcae+8oF8+DERmjrCiWzZS7rjOE3lUl+B7HMVds3XglhTxcI3OjtLM0rg5nQu/bywqJP6A+KXGQ3iJJZQxUaJDdTp2SNLS6dxbZE+OQY6EeS6YKgAGpN6/XmGMQnUz8yvMDuWMY7g9czGiZMg65m/BD0VMfyymwQQSrodHX2Pf73GLNIzY9QU6wMDigkq9rFop2ihIPPQcehR5kNlDXWUWRZy7rrGQa/7sDIA8z7JmRJiUbWfSvYMxjH0MLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
So with this feature arm64 platforms could have two different translation
systems, VMSAv8-64 and VMSAv9-128 could selectively be enabled.

FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
and virtual address range while also expanding available room for more MMU
management feature bits both for HW and SW.

This series has been split into two parts. Generic MM changes followed by
arm64 platform changes, finally enabling D128 with a new config ARM64_D128.

READ_ONCE() on page table entries get routed via level specific pxdp_get()
helpers which platforms could then override when required. These accessors
on arm64 platform help in ensuring page table accesses are performed in an
atomic manner while reading 128 bit page table entries.

All ARM64_VA_BITS and ARM64_PA_BITS combinations for all page sizes are now
supported both on D64 and D128 translation regimes. Although new 56 bits VA
space is not yet supported. Similarly FEAT_D128 skip level is not supported
currently.

Basic page table geometry has also been changed with D128 as there are fewer
entries per level. Please refer to the following table for leaf entry sizes.

                    D64              D128
------------------------------------------------
| PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
-----------------------------|-----------------|
|     4K    |    2M  |  1G   |    1M  |  256M  |
|    16K    |   32M  | 64G   |   16M  |   16G  |
|    64K    |  512M  |  4T   |  256M  |    1T  |
------------------------------------------------

                         D64                        D128
--------------------------------------------------------------------
| PAGE_SIZE |   CONT_PTE  |  CONT_PMD  |   CONT_PTE  |   CONT_PMD  |
--------------------------|------------|-------------|--------------
|     4K    |     64K     |     32M    |     64K     |      16M    |
|    16K    |      2M     |      1G    |      1M     |     256M    |
|    64K    |      2M     |     16G    |      1M     |      16G    |
--------------------------------------------------------------------

From arm64 kernel features perspective KVM, KASAN and UNMAP_KERNEL_AT_EL0
are currently not supported as well.

This series applies on v7.1-rc3 and there are no apparent problems while
running MM kselftests with and without CONFIG_ARM64_D128. Besides this has
been built tested on other platform such as x86, powerpc, riscv, arm and
s390 etc.

Changes in RFC V2:

- Dropped some patches that were merged upstream and rebased on v7.1-rc3
- Moved pxdval_t definition inside generic page table header per Mike
- Restored print format in __print_bad_page_map_pgtable() per Usama
- Renamed __PRIpte as __PRIpxx per David
- Dropped _once from pgprot_[read|write]() callbacks per Mike
- Moved back all helpers back from arch/arm64/mm/mmu.c into the header
- Renamed all ptdesc_ instances as pxxval_ instead
- Moved arm64 pgtable header READ_ONCE() replacements later in the series
- Updated commit message for the 5-level fixmap change per David
- Updated ARM64_CONT_[PTE|PMD]_SHIFT both for 16K and 64K base pages
- Added abstraction for tlbi_op
- Adopted TLBIP implementation to recent TLB flush changes
- Updated all commit messages as required and suggested

Changes in RFC V1:

https://lore.kernel.org/linux-arm-kernel/20260224051153.3150613-2-anshuman.khandual@arm.com/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Linu Cherian <linu.cherian@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (13):
  mm: Abstract printing of pxd_val()
  mm: Add read-write accessors for vm_page_prot
  arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
  arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
  arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
  arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
  arm64/mm: Route all pgtable reads via pxxval_get()
  arm64/mm: Route all pgtable writes via pxxval_set()
  arm64/mm: Route all pgtable atomics to central helpers
  arm64/mm: Abstract printing of pxd_val()
  arm64/mm: Override read-write accessors for vm_page_prot
  arm64/mm: Enable fixmap with 5 level page table
  arm64/mm: Add initial support for FEAT_D128 page tables

Linu Cherian (1):
  arm64/mm: Add an abstraction level for tlbi_op

 arch/arm64/Kconfig                     |  51 +++++++-
 arch/arm64/Makefile                    |   4 +
 arch/arm64/include/asm/assembler.h     |   4 +-
 arch/arm64/include/asm/el2_setup.h     |   9 ++
 arch/arm64/include/asm/pgtable-hwdef.h | 137 ++++++++++++++++++++
 arch/arm64/include/asm/pgtable-prot.h  |  18 ++-
 arch/arm64/include/asm/pgtable-types.h |  12 ++
 arch/arm64/include/asm/pgtable.h       | 169 ++++++++++++++++++++-----
 arch/arm64/include/asm/smp.h           |   1 +
 arch/arm64/include/asm/tlbflush.h      | 138 ++++++++++++++------
 arch/arm64/kernel/head.S               |  12 ++
 arch/arm64/mm/fault.c                  |  20 +--
 arch/arm64/mm/fixmap.c                 |  24 +++-
 arch/arm64/mm/hugetlbpage.c            |  10 +-
 arch/arm64/mm/kasan_init.c             |  14 +-
 arch/arm64/mm/mmu.c                    |  65 +++++-----
 arch/arm64/mm/pageattr.c               |   8 +-
 arch/arm64/mm/proc.S                   |  25 +++-
 arch/arm64/mm/trans_pgd.c              |  14 +-
 include/linux/pgtable.h                |  25 ++++
 mm/huge_memory.c                       |   4 +-
 mm/memory.c                            |  25 ++--
 mm/migrate.c                           |   2 +-
 mm/mmap.c                              |   2 +-
 24 files changed, 624 insertions(+), 169 deletions(-)

-- 
2.43.0


