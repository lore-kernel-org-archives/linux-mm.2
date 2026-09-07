Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958A6C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641A46B009B; Sun,  6 Sep 2026 23:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618A16B009D; Sun,  6 Sep 2026 23:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555CB6B009E; Sun,  6 Sep 2026 23:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 222CC6B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:50:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A07C6A0643
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:37 +0000 (UTC)
X-FDA: 85185589314.11.B357336
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC6E7180002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J0YxXEd2;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753036;
	b=3IR+aCPkG4Q6ttvXqx13VkgEOP6XSfIUNojXWechgIthC5I1BWOFXqhu93wLgWfEwVqlAs
	fDmvYe1zGXUfEiJFgh/LW6d68DxL4qMQhF42mkKKp8qis0SAqZvkpVBX0HLX1SZIZvu3fB
	beMyFOGLBm/zc2h+ZOS2Wa3IjI1QVPA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J0YxXEd2;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oftKBnvFXPM4KBgo1m7BRIBNO3Roicg3HTjmKHls52o=;
	b=IPHpkcMsVGh0vNJ5pZN35xEUt5j5PvKR283ZtCPQhg/TE3gtt3U3vZuYxKdNKta/d009XP
	7ljxE1Z+w/6xAEj7bNkg2Z9n7h3A8isAS4wfz4TBvQ/NvUvxwc0dATKn1iZFZaNbUF45Yv
	80Evd/cV7CnXZr1C/vRngBUzM8Owl6Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEF071477;
	Sun,  6 Sep 2026 20:50:30 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4EA53F7B4;
	Sun,  6 Sep 2026 20:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753034; bh=m7UMdM2SRbuccPembWy84uOyw6JbSLr0s0XQ/MQsJgc=;
	h=From:To:Cc:Subject:Date:From;
	b=J0YxXEd2rh401zmKMFaHqWeQhT9IrOjzwOPmcTMhD40rPbL5S54cllUwidhQ+bqVC
	 mkLkt+LJP9SL6nNU6YbNfunVLFQAHZqLw4GXFcOCeZyBiLwQdNUWD6TcINPpwRLkvf
	 mC9EV1rhngUh/D2OwClLeh+ABZbAsP88fYcUP4K0=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 00/14] arm64/mm: Enable 128 bit page table entries
Date: Mon,  7 Sep 2026 09:20:15 +0530
Message-ID: <20260907035030.2839978-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC6E7180002
X-Stat-Signature: 4rk7zjap9r99ube8xywh7e5zmddxjsxt
X-HE-Tag: 1788753035-261547
X-HE-Meta: U2FsdGVkX1/I2NvIqxSPl2RV2TMcz64cmwdadwatxL2mLGeTgD9WBR0b5HrNC5WIrOyMwlT8Bub1cNTid3k4+7C+J68G6zyYULKaEBolpMLuyuDwEuO36RGYm9sV0qutCLU6qG7JqabpTzs1LlQUwaltXRX/IfbfwldXAZsSF/Ep5dEHVSmTSWAEEnB9Tmi7aeI9DZNaytZk7WOAPLgbh0n0Oce+iq1rMggHD/4PqsTojy5Edxf1hQFn4T0vZvxFYyQZOQAr5Wqw5o/LwCFu5JswMBkXy0cUHvBvGvfWg8aoQDcZBQ5SSjbs1DO0VpAIJicCnDo4Rh43uC7DurdLLgpkjqUQv1FYYCsD2+dXDzuhKxUMmzyDQcxNYeFIJDyBFiTVhX29hZhm3H+TSuOTaQLXJoZpZt/SFQEJKLsh6V5FC8Pmg7sXfCFL+LYjOEwR8BfH1b1szUNYTTdQsr9snvdA9Nk870ghuKke6P4TE6TR5E6MSr1X1UeaTzoCltIk664obSDXKrXGNowqTSuWg33ZGRUQKeChgiKuKg8otYhfjXLPIHh8af7zQIZ0zy2f4HQhJfbChlKXacs/JIUswfZM77dvuoZyqecFEM5GPCDB/gO91KxaB+xdvlHMRzYDOZ4oa+y+icOhajuYe9PN/9e4v5rC2fKXHBsOzssR4M5WJ9phTh+5vP8+9L5WOkjD2nD4GE7SF9IzUvJVwRkoISh8nETw6xypTsKyseDTxHcxubpZuj/SMVR6VGHqt1aUk/2nIxMpfQjly1dGxhak/LJIlGPbHdgbP+JaNZmLX17YPoGlNUCihg2OvZTInp7TABWQ3+L6+0xiQgoG9bDUf9uDmrLFDPJtDNDH8jOaBebGhaRyO6v8GPotTKm//Fwy4d8rH2cr9tCFFK0cF6TAaNRfwuqcNlbkKzHKGeQEHUXN9k7l9cNRPRkbAhMnXPu+BSuPYMhe8/pIpmlLDSJ
 ymukWWew
 MtGjWYiOK+uokJeoFRxxwf/uBaJuH9ky4gfnmSXgt1hJxW5+UUN/XFdbojcyNaEntE0yQ0+p26/2Zl7d2Ir82aIOdgrbsmKJz4c4f95SOKKyiprAtCpS/ysfuvSKYopGLiacOJiH5tirPkGAiU9yvN8s7QIskTgGejGcnc3zSrIjfc57C6Gt1xYYzNSLS31M0Ape3FVF+3V5fkWz9opMgqVT9O5PjPV2H5gJbmYcYRxkfj7OucC0VpGtiRt8N+E+ImKlHSksuP44vNgxA19Xq1o7DpUlPnKq2SrR/dBU62+WJpqe/vtOVHH7Ot2UoZ1bNap1PqHEZekm5uzR5G8QN05Ceo9e1RG3nlDUrY6puPcyJX+N4K6BLdTt2RHVaU2odTITvf/5Hg3r02twEbw8BYHmtfW8RQ1VvZTXIvgWe+uW+tLnggbWMaXFJHGHoiiUDs89RQGTtBNMlxw+O4Het2HE7HhqSD6M+7hUlYl7+HglT6wVUI1XlneHzyQ==
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
cannot fallback to D64 translation regime on unsupported HW. Besides config
ARM64_D128 is only available with CONFIG_EXPERT.

ARM64_[VA|PA]_BITS combinations for respective CONFIG_ARM64_XXK_PAGES are
now supported both on VMSAv8-64 and VMSAv9-128 memory translation regimes.
Although FEAT_D128 provided 52 bit VA and PA space along with skip levels
are not supported currently.

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

Besides arm64 kernel features such as KVM and UNMAP_KERNEL_AT_EL0 are not
supported currently. This series applies on v7.3-rc1 after applying these
two following patch series posted earlier.

- arm64 standardized printing for pgtable entries [1]
- READ_ONCE() to pxdp_get() conversion series [2]

There are no apparent problems while running MM kselftests with and without
CONFIG_ARM64_D128 being enabled on various pgtable geometry configurations.

[1] https://lore.kernel.org/linux-arm-kernel/20260901065454.1906343-1-anshuman.khandual@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20260903060657.2717457-1-anshuman.khandual@arm.com/

Changes in V2:

- Rebased on v7.3-rc1
- Enabled KASAN on D128 - dropped !KASAN dependency from CONFIG_ARM64_D128
- Split out pgtable printf standardization into a separate series
- Split out READ_ONCE() conversion into separate series
- Added d128.config for testing ARM64_D128 enabled kernels in CI environment

Changes in V1:

https://lore.kernel.org/all/20260729122452.3797443-1-anshuman.khandual@arm.com/

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

Anshuman Khandual (12):
  mm: Add read-write accessors for vm_page_prot
  arm64/mm: Route all pgtable reads via ptval_get()
  arm64/mm: Route all pgtable writes via ptval_set()
  arm64/mm: Route all pgtable atomics to central helpers
  arm64/mm: Override read-write accessors for vm_page_prot
  arm64/mm: Enable fixmap with 5 level page table
  arm64/mm: Enable pgtable geometry for FEAT_D128
  arm64/mm: Enable pgtable descriptor for FEAT_D128
  arm64/mm: Enable 128 bit translation
  arm64/mm: Relax KASAN shadow alignment for FEAT_D128
  arm64/mm: Make ARM64_D128 selectable
  arm64/configs: Add d128.config

Linu Cherian (2):
  arm64/mm: Add an abstraction level for tlbi_op
  arm64/mm: Enable TLBIP instruction based TLB flush

 arch/arm64/Kconfig                     |  50 ++++++++-
 arch/arm64/Makefile                    |   4 +
 arch/arm64/configs/d128.config         |   6 ++
 arch/arm64/include/asm/assembler.h     |   4 +-
 arch/arm64/include/asm/el2_setup.h     |   9 ++
 arch/arm64/include/asm/pgtable-hwdef.h | 137 ++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable-prot.h  |  20 +++-
 arch/arm64/include/asm/pgtable-types.h |   4 +
 arch/arm64/include/asm/pgtable.h       | 142 +++++++++++++++++++++----
 arch/arm64/include/asm/smp.h           |   1 +
 arch/arm64/include/asm/tlbflush.h      | 138 ++++++++++++++++--------
 arch/arm64/kernel/head.S               |  12 +++
 arch/arm64/mm/fault.c                  |   2 +-
 arch/arm64/mm/fixmap.c                 |  18 +++-
 arch/arm64/mm/kasan_init.c             |   4 +-
 arch/arm64/mm/mmu.c                    |   4 +-
 arch/arm64/mm/proc.S                   |  25 ++++-
 include/linux/pgtable.h                |  14 +++
 mm/huge_memory.c                       |   4 +-
 mm/memory.c                            |   2 +-
 mm/migrate.c                           |   2 +-
 mm/mmap.c                              |   2 +-
 22 files changed, 520 insertions(+), 84 deletions(-)
 create mode 100644 arch/arm64/configs/d128.config

-- 
2.43.0


