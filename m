Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BCBC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E896B014C; Wed, 29 Jul 2026 10:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A4A6B014D; Wed, 29 Jul 2026 10:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2356B014E; Wed, 29 Jul 2026 10:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40AEE6B014C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19D8A80673
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:12 +0000 (UTC)
X-FDA: 85041734064.05.A7E8A13
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F9F7C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ela3iW+S;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PEiTB/8lc/6YgHJzKlRIRpp0zlrro6/WPnLlwBeIvlE=;
	b=wmmR9U8aGCu2sJ4HFLqXa6V9ed/XRE+JQ7h24eYEc0lG1thGcmKDM4YDKZlRgfP4eqEUy/
	xMPV48ftOvpDtUZI6bqYzb6hrRkxhfeCM2dZ51BsEdanyi+HRMRlP3YbNLL1Y5s/yQY9PN
	8LGLjeN1RuKw/9B814TtMDGvql/g/wU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ela3iW+S;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327910;
	b=JaRTW8YkvSwDuXqui3mt+Y6xJoFlRGpAhNPyjEMICNMMkgm3JmWHLqGYPLHI10MEHmjPlV
	G7roCcqLNlS0nbuZULt1jW7yOB+Py0K5wRWwD3oHtAw3Atrp6sWa+E/j8/5hL0Bn87Cvqp
	IqR0WzhBIXvBo8LERIWy04Gjg7sCOCs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 334521688;
	Wed, 29 Jul 2026 05:25:03 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AB8913F66F;
	Wed, 29 Jul 2026 05:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327907; bh=+wV2iFKlxT1dk8O4Kz2PUZUFQc+SrHcTLxbdDzD5R+c=;
	h=From:To:Cc:Subject:Date:From;
	b=Ela3iW+SNbSty+K3TyEW+oC9SvkSxgSnhYsF1m8pTXvEsZXKthEY/mEZ4xttaDllR
	 FtaI0w5MRrQxDN7tH4luB50hdr2asTTikX69hT9l+tS+EtIY4hx3Z1ePJGkw4YvlhP
	 sAEvY+b3zcKxWQs5RWizzW1HL84GHWoN6ZKTgIoQ=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/17] arm64/mm: Enable 128 bit page table entries
Date: Wed, 29 Jul 2026 17:54:35 +0530
Message-ID: <20260729122452.3797443-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5F9F7C0002
X-Stat-Signature: ij74dfek6qhm3ic9889cez6ak6bxrokq
X-HE-Tag: 1785327910-697943
X-HE-Meta: U2FsdGVkX19NOOgE2e5XBAXCZyZB3VQVLx5Dmjcl7maE08d4ZaUsdQNxayD4na8Q6llMDl8NqPcvZvG2l+7qpoM2ThDZ0cd/DV3lLgidvuFn97agvLsKn0tCmezOY8GSpWozxCv7rUWQB39UNNGDcsPywTgoyuNlRQ3XiSnIQpvAnmBO3p/wHIDQ5O0DDuz5TnhRFhz9rz6w/PEmhPyj0GI97DpDRyqrqgImlPpARmz9rZpedXbRzcVub9Ox0VoeM5seyhqdk2rzFT3/MMtjdt+IY9xqVl79R6riEVPgxWdHskxwLv/SYW7WRZwxlxXe1i2LZr1mTXBLKZfkznJNDtm0JJoyGPqww6CTQ4di0122qi7ldNt9KOft6UflFNXdwWyDG9YX3NEua+CjRLp6mqIFmLHllagoR3di9bw/NjKW83Ak/WfzhoF7EIvbQRppHaGK2FjEuSbVb+GHMDlwR3PQKLYUwwPrZ+cKa6W3npuupryWJGXftLoiX0A0vWe3c6X2jtY3mBfi/4aehp1MWBPBr1bmrWYrdAD+RLEEJLWcYqEObhu/V/jbQXfoRN0LONVkAEfZi+ZgWYFz0YoV1nAV0y+qhcAWr1Nrm65vD4rpSKEXxUT8PR+7kDwmrOngig0jhJhjbXz60ekwEg7D2YBzzRA+pVMXga/KOA3Ivng7YHxkjFsLxF1jU2Drd8AGAtf10JF1WOuiMbcQN4UTcNeKglCNZvCWoHQ06xI9XZhdyuukbzICP3aR12VvyCF3LV6IKTLYRDkxghpoG2s0n4282KEtVBLpkz/NEVsnqi89tfpt62J8x073uQmu4hgEGJyjBGIUfUplJpy8Ij/5MhAqos655pOd7abXirKSDElOU8GxrtG9XsDUoI3T+kmWQtNeIpP5ucG1PHvM+DKpe2TWchQpLJ9XeQEaw6tVZNp2iK7/8G2MU2SX0mHQd4Sa5iX0lsPpOnjLf235ioG
 1ZTJIeiO
 dR1dIaXnVaKchJHsfsH/7FcZDHhutulvaWCc2BQZ4Ltyfv+tzHeRa1uuFxg0II0KmzWvQGEJ1p6VAopHmPlPrVdStB6Edqfdg7mtNpffh+4de8zUDit8f8ZZmAZxXIYHBWOdLIM/E7NjgWA0oYq3EiEuWhHp++eXqTxvKEcVY0vMYwQYaWBoRSLGE7XWvaVlBIRQDixfLIBYp4n/Q4g+olsh1/4+cLa+u+hYqg/TPLU/QZK43dP3tDGUnEfBYKMuaIETS62mvQre9aVcmByk5QXXf1NISPQc3Vz2qZqRAIBoVwa17INZ9rNHl0fI5fzyxOauEJaQi2ElfjI2T7xOjSUY/q7IxvI3nwyCBxVjhbBgtr2W3zl8TNqDn3WMpB/0xsiBuAVA8h9deFqjSAp8zW37YVqUB1Uk4OySQ0wYGYX107TX3xxjT2Cc1putb55YU+UZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
arm64 platforms with FEAT_D128 enabled will now have two different memory
translation systems i.e VMSAv8-64 and VMSAv9-128.

FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
and virtual address range while also expanding available room for more MMU
feature bits for both HW and SW usage.

A new config option ARM64_D128 is being added thus enabling users to chose
between aforementioned memory translations regimes VMSAv8-64 (aka D64) and
VMSAv9-128 (aka D128) during the build time. If the ARM64_D128 built kernel
does not detect FEAT_D128 feature on the hardware, then it gets stuck with
with a new reason code CPU_STUCK_REASON_NO_D128. So ARM64_D128 built kernel
cannot fallback to D64 translation regime on unsupported HW.

READ_ONCE() on page table entries get routed via level specific pxdp_get()
helpers which platforms could then override when required. These accessors
on arm64 platform help in ensuring page table accesses are performed in an
atomic manner while reading 128 bit page table entries.

ARM64_[VA|PA]_BITS combinations for respective CONFIG_ARM64_XXK_PAGES are
now supported both on VMSAv8-64 and VMSAv9-128 memory translation regimes.
Although FEAT_D128 provided 52 bit VA and PA space along with skip levels
features are not supported currently.

Basic page table geometry has also been changed with VMSAv9-128, as there
are fewer entries per level as compared to VMSAv8-64. Please refer to the
following table for various leaf entry sizes including the cont entries.

------------------------------------------------
|           |       D64      |       D128      |
------------------------------------------------
| PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
-----------------------------|-----------------|
|     4K    |    2M  |  1G   |    1M  |  256M  |
|    16K    |   32M  | 64G   |   16M  |   16G  |
|    64K    |  512M  |  4T   |  256M  |    1T  |
------------------------------------------------

--------------------------------------------------------------------
|           |            D64           |             D128          |
--------------------------------------------------------------------
| PAGE_SIZE |   CONT_PTE  |  CONT_PMD  |   CONT_PTE  |   CONT_PMD  |
--------------------------|------------|-------------|--------------
|     4K    |     64K     |     32M    |     64K     |      16M    |
|    16K    |      2M     |      1G    |      1M     |     256M    |
|    64K    |      2M     |     16G    |      1M     |      16G    |
--------------------------------------------------------------------

Similarly arm64 kernel features such as KVM, KASAN and UNMAP_KERNEL_AT_EL0
are currently not supported as well.

This series applies on v7.2-rc5 but after applying the following patch that
standardized printing pgtable entries. There are no apparent problems while
running MM kselftests with and without CONFIG_ARM64_D128.

https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/

Changes in V1:

- Rebased on v7.2-rc5
- Pulled in new standardized pgtable entry print patch
- Added standardized pgtable entry print on arm64 platform
- Added KASAN related pgdp_get() changes missing earlier
- Renamed pxxval_get/set() as ptval_get/set()
- Renamed ptval_cmpxchg_relaxed() and ptval_xchg_relaxed()
- Renamed tlbi_args_t as tlbi_arg_t per Ryan
- Split final D128 enablement patch into four separate ones
- Updated all commit messages as required

Changes in RFC V2:

https://lore.kernel.org/all/20260513044547.4128549-1-anshuman.khandual@arm.com/

- Dropped some patches that were merged upstream and rebased on v7.1-rc3
- Updated commit message for the 5-level fixmap change per David
- Moved pxdval_t definition inside generic page table header
- Dropped _once from pgprot_read/write() per Mike
- Updated ARM64_CONT_[PTE|PMD]_SHIFT both for 16K and 64K base pages
- Renamed __PRIpte as __PRIpxx per David
- Added abstraction for tlbi_op
- Adopted TLBIP implementation to recent TLB flush changes
- Moved back all helpers back from arch/arm64/mm/mmu.c into the header
- Moved arm64 pgtable header READ_ONCE() replacements later in the series
- Renamed all ptdesc_ instances as pxxval_ instead
- Updated all commit messages as required and suggested
- Restored print format in __print_bad_page_map_pgtable() per Usama

Changes in RFC V1:

https://lore.kernel.org/linux-arm-kernel/20260224051153.3150613-2-anshuman.khandual@arm.com/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Linu Cherian <linu.cherian@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (15):
  mm: Add read-write accessors for vm_page_prot
  arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
  arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
  arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
  arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
  arm64/mm: Route all pgtable reads via ptval_get()
  arm64/mm: Route all pgtable writes via ptval_set()
  arm64/mm: Route all pgtable atomics to central helpers
  arm64/mm: Override read-write accessors for vm_page_prot
  arm64/mm: Standardize printing for pgtable entries
  arm64/mm: Enable fixmap with 5 level page table
  arm64/mm: Enable pgtable geometry for FEAT_D128
  arm64/mm: Enable pgtable descriptor for FEAT_D128
  arm64/mm: Enable 128 bit translation
  arm64/mm: Make ARM64_D128 selectable

Linu Cherian (2):
  arm64/mm: Add an abstraction level for tlbi_op
  arm64/mm: Enable TLBIP instruction based TLB flush

 arch/arm64/Kconfig                     |  51 ++++++-
 arch/arm64/Makefile                    |   4 +
 arch/arm64/include/asm/assembler.h     |   4 +-
 arch/arm64/include/asm/el2_setup.h     |   9 ++
 arch/arm64/include/asm/pgtable-hwdef.h | 137 ++++++++++++++++++
 arch/arm64/include/asm/pgtable-prot.h  |  18 ++-
 arch/arm64/include/asm/pgtable-types.h |   4 +
 arch/arm64/include/asm/pgtable.h       | 188 +++++++++++++++++++------
 arch/arm64/include/asm/smp.h           |   1 +
 arch/arm64/include/asm/tlbflush.h      | 138 ++++++++++++------
 arch/arm64/kernel/head.S               |  12 ++
 arch/arm64/mm/fault.c                  |  31 ++--
 arch/arm64/mm/fixmap.c                 |  24 +++-
 arch/arm64/mm/hugetlbpage.c            |  10 +-
 arch/arm64/mm/kasan_init.c             |  18 +--
 arch/arm64/mm/mmu.c                    |  81 ++++++-----
 arch/arm64/mm/pageattr.c               |   8 +-
 arch/arm64/mm/proc.S                   |  25 +++-
 arch/arm64/mm/trans_pgd.c              |  14 +-
 include/linux/mm_types.h               |  40 ++++++
 include/linux/pgtable.h                |  14 ++
 mm/huge_memory.c                       |   4 +-
 mm/memory.c                            |  42 +-----
 mm/migrate.c                           |   2 +-
 mm/mmap.c                              |   2 +-
 25 files changed, 668 insertions(+), 213 deletions(-)

-- 
2.43.0


