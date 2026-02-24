Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84785EFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18A56B0088; Tue, 24 Feb 2026 00:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6916B0089; Tue, 24 Feb 2026 00:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5076B008A; Tue, 24 Feb 2026 00:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76C006B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:12:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 220ACC1AD0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:28 +0000 (UTC)
X-FDA: 84478179576.15.3008C29
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7FE6640002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=7gNEbc28FnhE+qvo3ZUlRepOk3rzAuT09rgN9l47M/4=;
	b=SlkpHSi28TwM722hBr+sGFF1AZ1f0MEJvUlr+n7IK3zsZ4DRiNUSN8HxEuSkxQvKVI4FLq
	2g5CD6rWltBPmlIpw1W3tmJDxlWl80ZER/Vw2EgvRjVNDCFMKNQikSgKKYzS90rMpOTApD
	P8bPnVlNIb9VlsikjhKj+KYW1AL+NLo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909946; a=rsa-sha256;
	cv=none;
	b=jOrYPDfy0hJA1+b+HKBoFufJd1nH8qAFzBvmoRL8iN3/gQi/Q0nPQWA/s6FN5AE+rGts5r
	tPiLTDqbNFKl6P55fVJ0rJktqjpNZp82O2n30ZQRa7SFqCQhQqtMxQh8OsG6qcyiI0dSf+
	Q9zTtBc7vpzv1ZnydywK+XDZ+iSPPzs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C37E339;
	Mon, 23 Feb 2026 21:12:19 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 380143F7BD;
	Mon, 23 Feb 2026 21:12:20 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V1 00/16] arm64/mm: Enable 128 bit page table entries
Date: Tue, 24 Feb 2026 10:41:37 +0530
Message-ID: <20260224051153.3150613-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xbbfx75jo96cjgd6o6q8e74pa4hps91g
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FE6640002
X-Rspamd-Server: rspam01
X-HE-Tag: 1771909946-111106
X-HE-Meta: U2FsdGVkX19Oadm6y+HPLTvxXXB5dlU6arYWXKiHbQABlDemlOEKw0nlYYpHY5Opf/+VwUJ78cBay/8TknS1180YuetJE5kc7jxHHbzk26OsFP4IeQhK4linxsrnVJQjO2SflklpJy1lkMYfVDSNZC1vD8H+9I3lh6MtAXV/XcBt2iq1T1HP66Or/cOPfXyR8dQQ5Ut2Tu3j+/kBRSX5wEhxhHtGAUo9KDdblI9Zurq6htc2EWwgxcnCOHNBFyfVnV8n7SQbm7YCiW8js5TTnFl6BMgIlwR2Ni3PnXrgPAa9nuGKnlqdXSL50nuITRSNGA7P1WZ0YDQYnglCWL0X9/gs02fONSkbstGbeT8GSUBa8HZHbZfs+E+ApJWrDMo1m58Z2zW/g4fuytgm3QPyql3YgXBP4EubZrFFk2KMtxjrmlC4X1z257kwCbBaETN00CEbwM+P8xT6+N53lel80mT3RUvA6wVpEBbt4lgI2xk/AcCD10Zjul22anjWwJeLJ1aIWnMeDDrPGVDhEfOyc0EzRa/IxcVp9wvyCFF3fwxv8f20CN6oSwLhOi+zALV2VXlEjImbo0Nwdb2wV/A5LGx0mEbkywaomEc1cmnmPOxw3yYRhhJnR6nAeKMuWczdEPspmKtFCGlpBVAItRWxb80u5ENlcdRA7VxOPaVf9G2TH4TzjNrl8R5r43B29VxEFX8nMHrF8ZGhNvPsBG4IyBTsBARGkM1Jd5ePVhnSjIjaZ4X4QHD6cyiWGxE6i76zLu2hIU29ktghknJ+pd4r6n+Wd3nqjFkcdlVpOVQ/nqIB2U+JB67l4coTJEWHpncPdJiLjE62krQht5XGUirINlS3EDEYYKydD0JbOQGRl7ZeXh3LZ5cvuJM5hOw32nyhrHrsWiAvML12gXcCH5qEocCiZ237V7pqKtwzxqnNWPkWL6keOkP3Sctiw1XbF1yMoO/MaTEmETWkV8oK6kl
 TaM8ICKi
 BzorRrrIASBW/2Ar6BSyBO1iDC3roQe4ruxRH9dyrXvmUS5/I8WTg9WCLuyK+7YOsGurd+hGf9jcZ3lJk/+CLzw9dxqnHQLo/2XT4+HWgpuu55knhTRgwXMUjMrkLdF3WR/X7K1ltnrV5YelcJIrQvIONFBUCcdd0mWg4WIunALSyWjRpLqvX1VrTT8WEJuhhN2Gl6BkUlgvNWd9WEQkFWtPST3YjrY7/elELE8Zx8CnH3zCe8nN/vvM1BzR1vAIPzEvRIz1eLmBO8WeHM2NPdY5tCesEgP9e7LJFjMyGFsbS5jK/cc9TV3AYK4cw/FTefcG2DsQ2sL1sM8cSCCGHU3UAe4q9Cny9btz4bFvzNBZvuNP8tFnUde3jMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Basic page table geometry has been changed with D128 as there are now fewer
entries per level. Please refer to the following table for leaf entry sizes

                    D64              D128
------------------------------------------------
| PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
-----------------------------|-----------------|
|     4K    |    2M  |  1G   |    1M  |  256M  |
|    16K    |   32M  | 64G   |   16M  |   16G  |
|    64K    |  512M  |  4T   |  256M  |    1T  |
------------------------------------------------

From arm64 kernel features perspective KVM, KASAN and UNMAP_KERNEL_AT_EL0
are currently not supported as well.

Open Questions:

- Do we need to support UNMAP_KERNEL_AT_EL0 with D128
- Do we need to emulate traditional D64 sizes at PUD, PMD level with D128

This series applies on upstream kernel v7.0-rc1.

There are no apparent problems while running MM kselftests with and without
CONFIG_ARM64_D128. Besides the series has been built on other platform such
as x86, powerpc, riscv, arm and s390 etc.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Linu Cherian <linu.cherian@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (15):
  mm: Abstract printing of pxd_val()
  mm: Add read-write accessors for vm_page_prot
  mm: Replace READ_ONCE() in pud_trans_unstable()
  perf/events: Replace READ_ONCE() with standard pgtable accessors
  arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
  arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
  arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
  arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
  arm64/mm: Route all pgtable reads via ptdesc_get()
  arm64/mm: Route all pgtable writes via ptdesc_set()
  arm64/mm: Route all pgtable atomics to central helpers
  arm64/mm: Abstract printing of pxd_val()
  arm64/mm: Override read-write accessors for vm_page_prot
  arm64/mm: Enable fixmap with 5 level page table
  arm64/mm: Add initial support for FEAT_D128 page tables

Linu Cherian (1):
  arm64/mm: Add macros __tlb_asid_level and __tlb_range

 arch/arm64/Kconfig                     |  39 ++++-
 arch/arm64/Makefile                    |   4 +
 arch/arm64/include/asm/assembler.h     |   4 +-
 arch/arm64/include/asm/el2_setup.h     |   9 ++
 arch/arm64/include/asm/pgtable-hwdef.h | 137 ++++++++++++++++++
 arch/arm64/include/asm/pgtable-prot.h  |  18 ++-
 arch/arm64/include/asm/pgtable-types.h |  12 ++
 arch/arm64/include/asm/pgtable.h       | 193 ++++++++++++++++++-------
 arch/arm64/include/asm/smp.h           |   1 +
 arch/arm64/include/asm/tlbflush.h      | 112 ++++++++++++--
 arch/arm64/kernel/head.S               |  12 ++
 arch/arm64/mm/fault.c                  |  20 +--
 arch/arm64/mm/fixmap.c                 |  24 ++-
 arch/arm64/mm/hugetlbpage.c            |  10 +-
 arch/arm64/mm/kasan_init.c             |  14 +-
 arch/arm64/mm/mmu.c                    | 113 +++++++++++----
 arch/arm64/mm/pageattr.c               |   8 +-
 arch/arm64/mm/proc.S                   |  25 +++-
 arch/arm64/mm/trans_pgd.c              |  14 +-
 include/linux/pgtable.h                |  21 ++-
 kernel/events/core.c                   |   6 +-
 mm/debug_vm_pgtable.c                  |   4 +-
 mm/huge_memory.c                       |   4 +-
 mm/memory.c                            |  31 ++--
 mm/migrate.c                           |   2 +-
 mm/mmap.c                              |   2 +-
 26 files changed, 674 insertions(+), 165 deletions(-)

-- 
2.43.0


