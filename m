Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2724CD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5291D6B00AA; Wed, 13 May 2026 00:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DACD6B00AC; Wed, 13 May 2026 00:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A726B00AD; Wed, 13 May 2026 00:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9066B00AA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D351740715
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:50 +0000 (UTC)
X-FDA: 84761163900.22.7F30214
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FD75C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VLdW1TBR;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FXL982J3jk1+peGc1AuWAHOMfyr2UALUtVp8Oqfv7E=;
	b=3o4op+E2yEOXWlvmTcjkfDWqYBPR3KbvyOtTMxaZ+U99R5Kmg5dBbZ1vM39GYLYc7g9s0z
	90yi/PyiFQcGMHqBCyv5xjFh9o3hBPgJGQXZbqavpHtTaMRPwBGBeviv4oUkp37XptI8+C
	m3Cpc9nMtBK1bZl6S22iG+a0Z0/7frQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VLdW1TBR;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647669; a=rsa-sha256;
	cv=none;
	b=W8dmVvhA9RfRZg1KH/MuwQXOLKoEiNvpjtHowICmjVteEtU/6uML9CNH3tmHB5YxBBs6IC
	oRjcACyzUQlHXdNPwuEZNQESRj3pv/xzbsVyHivamdifDFslHAkzK0Hgy+SPkDjPnWCKEe
	YhXwdHZuAtuAm7uOfTNv+fBqCTOTNIA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F8691595;
	Tue, 12 May 2026 21:47:43 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 86B363F905;
	Tue, 12 May 2026 21:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647668; bh=gULkjq9T0+l9V9DIl0GdWNgJA3VP9hpwG+ILUSBxVNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLdW1TBRm/hJZd9TIfv01SFwwoqPweUoZzjNVzNgXZoDqquA04J3i9jCwX5HVIuNe
	 DNkHjdAYAB9MeVIfqiNeBLDpmT8yDcD3VUh8cI21udREPOJuGdymOjw4lsb4NQ4OUm
	 4Wk5bY+XWCPc2amvf7zYOoRD0mPzNiVjjA5XVGBQ=
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
Subject: [RFC V2 14/14] arm64/mm: Add initial support for FEAT_D128 page tables
Date: Wed, 13 May 2026 10:15:47 +0530
Message-ID: <20260513044547.4128549-15-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FD75C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: 8bjzmjtbs4o4jz5rys4a4u7iqtwpdgd6
X-HE-Tag: 1778647668-456181
X-HE-Meta: U2FsdGVkX1+OqKkA06ljQi7Uxb2/Vz6D4nqPZF1SI9zFUIy6TrKfm0N4XkancriM2/7H0tBpgJwGB4mULAkSft+LpggZgfY5gxmpauiWBkajo+ZpUS4Nx4fu73tgnfsLOK7WnZyavRd2JU65ZtHT004QpS2Bote62QkuY6tLSrjtxREei6et1GVFdinfW3PdszvfvEbfyEzNq/1kQtZo9+tmBr6cGz9QCqzswdf6lagw3EuJWT6d/gO8zB0ieFhcSZft2m3x4+09XHHZQg6fDpXzuWFBeH3rl7V1vJfjMDN0WcTGqcGA1NJzI6G00MkFEsCoDvS246F8Rsp9aCroMYY47p8O9JKBq4I+fqUM3viQxxNS9JLy5PbjlzNFh5vq9Ii4JvHjOmvdGwVkZBsEA8fqCAdJltKh4xBO9aq5nv05bQ3/d078K89vpDDADTzow7kU+cgC9uKzQpIp2ZzvwmW1LtqhDY1/8fYZrwxh/oRVQG5o1Ahny4arysLorfhRpglexYlk6t6wsAW6mn8F2u07PdJmvFWSI/8YLl5WCkcaeEYWOmN6dgjDUb2RXiUQ7fr8Y4YWgyM4c/FdwuP+4Nqg+APf6sqUn1Zxi8FLMtc4Ao3+rrpW2AZa54S6lUZGhZ0F7V7fDm6BSklQ+M+wF7+l+ATQDp83GL9YOvT/MGxs6TtVFySBGJn5nqcPwvqeU0NYB2qf7qUwRsGsDA9Y6o6FpwCC9b6YgdfGWe8w6itQD/PeEeCsPCDZUF/EnON3lECdvhOBK+wxJz0/IraEMc7DyX3hZTNLYEr/zQZ0MYl/VKrXeytNOPc/5l2cMijgg4GoRZ6wFFJb/I2UwF4PjpCDbAW9aS3ZpDkHZi/tKUFGAOTyqgJ3EAIZ5R1cAupUQDJBEn/ywjR75hjTMrc+0g9PN54SPUYrlrdm2VAUo6IdeBC2F3FLVwRNUmB0qvV2MRXXbJ6lXRSO1cDePEU
 lAilEbw6
 /uq2ka1Ix800AIaL92z+x2Tb+LGV/FRypmf/mnubC36vJDnFh7HBce514m+YxrbIF6Mc08rvYRZgA10Y7cj+m24joGx5p8K46fooO6koGg9oXjPMgXCqbH3jmtwJEoGzt8v28NVhZwcmGlkm0DF0StwsMXIG+JzrlcwQ/Q2G2y+VPtdVjXhBrMTmtRQ+CNjVXCLXW2Yvh5m0OhZg9Vs3lSIZHRf1a4NSH0S+dbWFW0Q835C8BXmWSsW95NUELaKXCVr4fcg0yfAM8Edhfdyjio/Yo7jihMbCSoDSTb8vvxlXfbm067WESz4Z3lSCQ9FT589k0m9EUtC/rd2399OBQDu4Jslf2jGZOFEAVgPJd3badJTYL6XF2pDIuGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add build time support for FEAT_D128 page tables with a new Kconfig option
i.e CONFIG_ARM64_D128. When selected, PTE types become 128 bits wide and
PTE bits are mapped to their new locations. Besides the basic page table
geometry is also updated since each table page now holds half the number
of entries (aka PTRS_PER_PXX) as it did previously.

Since FEAT_D128 exclusively supports the permission indirection style for
page table entry permission management, given kernel compiled for FEAT_D128
requires both FEAT_S1PIE and FEAT_D128. If these architecture features are
not present at boot, the kernel panics just like it does when there is a
granule size mismatch.

TTBR0/1_EL1 and PAR_EL1 registers become 128 bit wide when D128 is enabled,
thus requiring MSRR/MRRS instructions for their updates. Because PA_BITS is
still capped at 52 bits, MRS/MSR instructions are currently sufficient for
the register accesses that basically operate on the lower 64 bits. Although
entire 128 bits for these registers get cleared during boot via MSRR.

Add support for TLBIP instruction for TLB flush macros with level hint and
address range operations. Although existing TLBI based TLB flush would have
been sufficient given PA_BITS is still capped at 52, but then it would have
lacked both level hint and range support.

This enables support for all granule size, VA_BITS and PA_BITS combination.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linu Cherian <linu.cherian@arm.com> (TLBIP instructions)
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V2:

- Updated ARM64_CONT_[PTE|PMD]_SHIFT both for 16K and 64K base pages
- Adopted TLBIP implementation to recent TLB flush changes
- Renamed __PRIpte as __PRIpxx per David
- Renamed all ptdesc_ instances as pxxval_ instead

 arch/arm64/Kconfig                     |  51 ++++++++-
 arch/arm64/Makefile                    |   4 +
 arch/arm64/include/asm/assembler.h     |   4 +-
 arch/arm64/include/asm/el2_setup.h     |   9 ++
 arch/arm64/include/asm/pgtable-hwdef.h | 137 +++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable-prot.h  |  18 +++-
 arch/arm64/include/asm/pgtable-types.h |   9 ++
 arch/arm64/include/asm/pgtable.h       |  56 +++++++++-
 arch/arm64/include/asm/smp.h           |   1 +
 arch/arm64/include/asm/tlbflush.h      |  68 ++++++++++--
 arch/arm64/kernel/head.S               |  12 +++
 arch/arm64/mm/proc.S                   |  25 ++++-
 12 files changed, 374 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..bc0bb4d08d10 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -276,6 +276,10 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS
 	def_bool CC_IS_GCC
 	depends on $(cc-option,-fpatchable-function-entry=2)
 
+config CC_SUPPORTS_LSE128
+	def_bool CC_IS_GCC
+	depends on $(cc-option, -march=armv8.1-a+lse128)
+
 config 64BIT
 	def_bool y
 
@@ -284,14 +288,18 @@ config MMU
 
 config ARM64_CONT_PTE_SHIFT
 	int
-	default 5 if PAGE_SIZE_64KB
-	default 7 if PAGE_SIZE_16KB
+	default 4 if PAGE_SIZE_64KB && ARM64_D128
+	default 5 if PAGE_SIZE_64KB && !ARM64_D128
+	default 6 if PAGE_SIZE_16KB && ARM64_D128
+	default 7 if PAGE_SIZE_16KB && !ARM64_D128
 	default 4
 
 config ARM64_CONT_PMD_SHIFT
 	int
-	default 5 if PAGE_SIZE_64KB
-	default 5 if PAGE_SIZE_16KB
+	default 6 if PAGE_SIZE_64KB && ARM64_D128
+	default 5 if PAGE_SIZE_64KB && !ARM64_D128
+	default 4 if PAGE_SIZE_16KB && ARM64_D128
+	default 5 if PAGE_SIZE_16KB && !ARM64_D128
 	default 4
 
 config ARCH_MMAP_RND_BITS_MIN
@@ -362,6 +370,16 @@ config FIX_EARLYCON_MEM
 
 config PGTABLE_LEVELS
 	int
+	default 4 if ARM64_D128 && ARM64_4K_PAGES && ARM64_VA_BITS_39
+	default 5 if ARM64_D128 && ARM64_4K_PAGES && ARM64_VA_BITS_48
+	default 5 if ARM64_D128 && ARM64_4K_PAGES && ARM64_VA_BITS_52
+	default 3 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_36
+	default 4 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_47
+	default 4 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_48
+	default 4 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_52
+	default 3 if ARM64_D128 && ARM64_64K_PAGES && ARM64_VA_BITS_42
+	default 3 if ARM64_D128 && ARM64_64K_PAGES && ARM64_VA_BITS_48
+	default 3 if ARM64_D128 && ARM64_64K_PAGES && ARM64_VA_BITS_52
 	default 2 if ARM64_16K_PAGES && ARM64_VA_BITS_36
 	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
 	default 3 if ARM64_64K_PAGES && (ARM64_VA_BITS_48 || ARM64_VA_BITS_52)
@@ -1483,7 +1501,7 @@ config ARM64_PA_BITS
 
 config ARM64_LPA2
 	def_bool y
-	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES
+	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES && !ARM64_D128
 
 choice
 	prompt "Endianness"
@@ -2176,6 +2194,29 @@ config ARM64_HAFT
 
 endmenu # "ARMv8.9 architectural features"
 
+menu "ARMv9.3 architectural features"
+
+config AS_HAS_ARMV9_3
+	def_bool $(cc-option,-Wa$(comma)-march=armv9.3-a)
+
+config ARM64_D128
+	bool "Enable support for 128 bit page table (FEAT_D128)"
+	depends on ARCH_SUPPORTS_INT128
+	depends on CC_SUPPORTS_LSE128
+	depends on AS_HAS_ARMV9_3
+	depends on EXPERT
+	depends on !VIRTUALIZATION
+	depends on !KASAN
+	depends on !UNMAP_KERNEL_AT_EL0
+	default n
+	help
+	  ARMv9.3 introduces FEAT_D128, which provides a 128 bit page
+	  table format, along with related instructions.
+
+	  If unsure, say Y.
+
+endmenu # "ARMv9.3 architectural features"
+
 menu "ARMv9.4 architectural features"
 
 config ARM64_GCS
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 73a10f65ce8b..4dedaaee9211 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -54,6 +54,10 @@ endif
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
 KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)
 
+ifeq ($(CONFIG_ARM64_D128),y)
+KBUILD_AFLAGS	+= -march=armv9.3-a+d128
+endif
+
 # Avoid generating .eh_frame* sections.
 ifneq ($(CONFIG_UNWIND_TABLES),y)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables -fno-unwind-tables
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index effae53e9739..b53b7f18c1bd 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -627,7 +627,7 @@ alternative_else_nop_endif
  * 	ttbr:	returns the TTBR value
  */
 	.macro	phys_to_ttbr, ttbr, phys
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 	orr	\ttbr, \phys, \phys, lsr #46
 	and	\ttbr, \ttbr, #TTBR_BADDR_MASK_52
 #else
@@ -636,7 +636,7 @@ alternative_else_nop_endif
 	.endm
 
 	.macro	phys_to_pte, pte, phys
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 	orr	\pte, \phys, \phys, lsr #PTE_ADDR_HIGH_SHIFT
 	and	\pte, \pte, #PHYS_TO_PTE_ADDR_MASK
 #else
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 587507a9980e..fd8ae6e239e9 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -78,6 +78,15 @@
 	cbz	x0, .Lskip_hcrx_\@
 	mov_q	x0, (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 
+#ifdef CONFIG_ARM64_D128
+	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
+	ubfx	x1, x1, #ID_AA64MMFR3_EL1_D128_SHIFT, #4
+	cbz	x1, .Lskip_d128_\@
+
+	orr	x0, x0, HCRX_EL2_D128En		// Disable MRRS/MSRR traps
+.Lskip_d128_\@:
+#endif
+
         /* Enable GCS if supported */
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 72f31800c703..16fb74c47b74 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -7,7 +7,11 @@
 
 #include <asm/memory.h>
 
+#ifdef CONFIG_ARM64_D128
+#define PTDESC_ORDER 4
+#else
 #define PTDESC_ORDER 3
+#endif
 
 /* Number of VA bits resolved by a single translation table level */
 #define PTDESC_TABLE_SHIFT	(PAGE_SHIFT - PTDESC_ORDER)
@@ -97,6 +101,137 @@
 #define CONT_PMD_SIZE		(CONT_PMDS * PMD_SIZE)
 #define CONT_PMD_MASK		(~(CONT_PMD_SIZE - 1))
 
+#ifdef CONFIG_ARM64_D128
+
+/*
+ * Hardware page table definitions.
+ *
+ * Level -1 descriptor (PGD).
+ */
+#define PGD_SKL_SHIFT		109
+#define PGD_SKL_MASK		GENMASK_U128(110, 109)
+#define PGD_SKL_TABLE		(_AT(pgdval_t, 0) << PGD_SKL_SHIFT)
+
+#define PGD_TYPE_TABLE		_AT(pgdval_t, (PTE_VALID | PGD_SKL_TABLE))
+#define PGD_TYPE_MASK		_AT(pgdval_t, (PTE_VALID | PGD_SKL_MASK))
+#define PGD_TABLE_AF		(_AT(pgdval_t, 1) << 10)	/* Ignored if no FEAT_HAFT */
+#define PGD_TABLE_PXN		_AT(pgdval_t, 0)		/* Not supported for D128 */
+#define PGD_TABLE_UXN		_AT(pgdval_t, 0)		/* Not supported for D128 */
+
+/*
+ * Level 0 descriptor (P4D).
+ */
+#define P4D_SKL_SHIFT		109
+#define P4D_SKL_MASK		GENMASK_U128(110, 109)
+#define P4D_SKL_TABLE		(_AT(p4dval_t, 0) << P4D_SKL_SHIFT)
+#define P4D_SKL_SECT		(_AT(p4dval_t, 3) << P4D_SKL_SHIFT)
+
+#define P4D_TYPE_TABLE		_AT(p4dval_t, (PTE_VALID | P4D_SKL_TABLE))
+#define P4D_TYPE_MASK		_AT(p4dval_t, (PTE_VALID | P4D_SKL_MASK))
+#define P4D_TYPE_SECT		_AT(p4dval_t, (PTE_VALID | P4D_SKL_SECT))
+#define P4D_SECT_RDONLY		(_AT(p4dval_t, 1) << 7)		/* nDirty */
+#define P4D_TABLE_AF		(_AT(p4dval_t, 1) << 10)	/* Ignored if no FEAT_HAFT */
+#define P4D_TABLE_PXN		_AT(p4dval_t, 0)		/* Not supported for D128 */
+#define P4D_TABLE_UXN		_AT(p4dval_t, 0)		/* Not supported for D128 */
+
+/*
+ * Level 1 descriptor (PUD).
+ */
+#define PUD_SKL_SHIFT		109
+#define PUD_SKL_MASK		GENMASK_U128(110, 109)
+#define PUD_SKL_TABLE		(_AT(pudval_t, 0) << PUD_SKL_SHIFT)
+#define PUD_SKL_SECT		(_AT(pudval_t, 2) << PUD_SKL_SHIFT)
+
+#define PUD_TYPE_TABLE		_AT(pudval_t, (PTE_VALID | PUD_SKL_TABLE))
+#define PUD_TYPE_MASK		_AT(pudval_t, (PTE_VALID | PUD_SKL_MASK))
+#define PUD_TYPE_SECT		_AT(pudval_t, (PTE_VALID | PUD_SKL_SECT))
+#define PUD_SECT_RDONLY		(_AT(pudval_t, 1) << 7)		/* nDirty */
+#define PUD_TABLE_AF		(_AT(pudval_t, 1) << 10)	/* Ignored if no FEAT_HAFT */
+#define PUD_TABLE_PXN		_AT(pudval_t, 0)		/* Not supported for D128 */
+#define PUD_TABLE_UXN		_AT(pudval_t, 0)		/* Not supported for D128 */
+
+/*
+ * Level 2 descriptor (PMD).
+ */
+#define PMD_SKL_SHIFT		109
+#define PMD_SKL_MASK		GENMASK_U128(110, 109)
+#define PMD_SKL_TABLE		(_AT(pmdval_t, 0) << PMD_SKL_SHIFT)
+#define PMD_SKL_SECT		(_AT(pmdval_t, 1) << PMD_SKL_SHIFT)
+
+#define PMD_TYPE_MASK		_AT(pmdval_t, (PTE_VALID | PMD_SKL_MASK))
+#define PMD_TYPE_TABLE		_AT(pmdval_t, (PTE_VALID | PMD_SKL_TABLE))
+#define PMD_TYPE_SECT		_AT(pmdval_t, (PTE_VALID | PMD_SKL_SECT))
+#define PMD_TABLE_AF		(_AT(pmdval_t, 1) << 10)	/* Ignored if no FEAT_HAFT */
+#define PMD_TABLE_PXN		_AT(pmdval_t, 0)		/* Not supported for D128 */
+#define PMD_TABLE_UXN		_AT(pmdval_t, 0)		/* Not supported for D128 */
+
+/*
+ * Section
+ */
+#define PMD_SECT_USER		(_AT(pmdval_t, 1) << 115)	/* PIIndex[0] */
+#define PMD_SECT_RDONLY		(_AT(pmdval_t, 1) << 7)		/* nDirty */
+#define PMD_SECT_S		(_AT(pmdval_t, 3) << 8)
+#define PMD_SECT_AF		(_AT(pmdval_t, 1) << 10)
+#define PMD_SECT_NG		(_AT(pmdval_t, 1) << 11)
+#define PMD_SECT_CONT		(_AT(pmdval_t, 1) << 111)
+#define PMD_SECT_PXN		(_AT(pmdval_t, 1) << 117)	/* PIIndex[2] */
+#define PMD_SECT_UXN		(_AT(pmdval_t, 1) << 118)	/* PIIndex[3] */
+
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define PMD_ATTRINDX(t)		(_AT(pmdval_t, (t)) << 2)
+#define PMD_ATTRINDX_MASK	(_AT(pmdval_t, 7) << 2)
+
+/*
+ * Level 3 descriptor (PTE).
+ */
+#define PTE_SKL_SHIFT		109
+#define PTE_SKL_MASK		GENMASK_U128(110, 109)
+#define PTE_SKL_SECT		(_AT(pteval_t, 0) << PTE_SKL_SHIFT)
+
+#define PTE_VALID		(_AT(pteval_t, 1) << 0)
+#define PTE_TYPE_MASK		_AT(pteval_t, (PTE_VALID | PTE_SKL_MASK))
+#define PTE_TYPE_PAGE		_AT(pteval_t, (PTE_VALID | PTE_SKL_SECT))
+#define PTE_USER		(_AT(pteval_t, 1) << 115)	/* PIIndex[0] */
+#define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* nDirty */
+#define PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
+#define PTE_AF			(_AT(pteval_t, 1) << 10)	/* Access Flag */
+#define PTE_NG			(_AT(pteval_t, 1) << 11)	/* nG */
+#define PTE_GP			(_AT(pteval_t, 1) << 113)	/* BTI guarded */
+#define PTE_DBM			(_AT(pteval_t, 1) << 116)	/* PIIndex[1] */
+#define PTE_CONT		(_AT(pteval_t, 1) << 111)	/* Contiguous range */
+#define PTE_PXN			(_AT(pteval_t, 1) << 117)	/* PIIndex[2] */
+#define PTE_UXN			(_AT(pteval_t, 1) << 118)	/* PIIndex[3] */
+#define PTE_SWBITS_MASK		_AT(pteval_t, GENMASK_U128(100, 91))
+
+#define PTE_ADDR_LOW		(((_AT(pteval_t, 1) << (55 - PAGE_SHIFT)) - 1) << PAGE_SHIFT)
+
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
+#define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
+
+/*
+ * PIIndex[3:0] encoding (Permission Indirection Extension)
+ */
+#define PTE_PI_MASK	GENMASK_U128(118, 115)
+#define PTE_PI_SHIFT	115
+
+/*
+ * POIndex[3:0] encoding (Permission Overlay Extension)
+ */
+#define PTE_PO_IDX_0	(_AT(pteval_t, 1) << 121)
+#define PTE_PO_IDX_1	(_AT(pteval_t, 1) << 122)
+#define PTE_PO_IDX_2	(_AT(pteval_t, 1) << 123)
+#define PTE_PO_IDX_3	(_AT(pteval_t, 1) << 124)
+
+#define PTE_PO_IDX_MASK		GENMASK_U128(124, 121)
+#define PTE_PO_IDX_SHIFT	121
+
+#else /* !CONFIG_ARM64_D128 */
+
 /*
  * Hardware page table definitions.
  *
@@ -211,7 +346,9 @@
 #define PTE_PO_IDX_2	(_AT(pteval_t, 1) << 62)
 
 #define PTE_PO_IDX_MASK		GENMASK_ULL(62, 60)
+#define PTE_PO_IDX_SHIFT	60
 
+#endif /* CONFIG_ARM64_D128 */
 
 /*
  * Memory Attribute override for Stage-2 (MemAttr[3:0])
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 212ce1b02e15..aadc577511d6 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -13,10 +13,15 @@
 /*
  * Software defined PTE bits definition.
  */
-#define PTE_WRITE		(PTE_DBM)		 /* same as DBM (51) */
+#define PTE_WRITE		(PTE_DBM)		 /* same as DBM (51 / 116) */
 #define PTE_SWP_EXCLUSIVE	(_AT(pteval_t, 1) << 2)	 /* only for swp ptes */
+#ifdef CONFIG_ARM64_D128
+#define PTE_DIRTY		(_AT(pteval_t, 1) << 91)
+#define PTE_SPECIAL		(_AT(pteval_t, 1) << 92)
+#else
 #define PTE_DIRTY		(_AT(pteval_t, 1) << 55)
 #define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
+#endif
 
 /*
  * PTE_PRESENT_INVALID=1 & PTE_VALID=0 indicates that the pte's fields should be
@@ -28,7 +33,11 @@
 #define PTE_PRESENT_VALID_KERNEL (PTE_VALID | PTE_MAYBE_NG)
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+#ifdef CONFIG_ARM64_D128
+#define PTE_UFFD_WP		(_AT(pteval_t, 1) << 94) /* uffd-wp tracking */
+#else
 #define PTE_UFFD_WP		(_AT(pteval_t, 1) << 58) /* uffd-wp tracking */
+#endif
 #define PTE_SWP_UFFD_WP		(_AT(pteval_t, 1) << 3)	 /* only for swp ptes */
 #else
 #define PTE_UFFD_WP		(_AT(pteval_t, 0))
@@ -131,11 +140,18 @@ static inline bool __pure lpa2_is_enabled(void)
 
 #endif /* __ASSEMBLER__ */
 
+#ifdef CONFIG_ARM64_D128
+#define pte_pi_index(pte)	(((pte) & PTE_PI_MASK) >> PTE_PI_SHIFT)
+#define pte_po_index(pte)	((pte_val(pte) & PTE_PO_IDX_MASK) >> PTE_PO_IDX_SHIFT)
+#else
 #define pte_pi_index(pte) ( \
 	((pte & BIT(PTE_PI_IDX_3)) >> (PTE_PI_IDX_3 - 3)) | \
 	((pte & BIT(PTE_PI_IDX_2)) >> (PTE_PI_IDX_2 - 2)) | \
 	((pte & BIT(PTE_PI_IDX_1)) >> (PTE_PI_IDX_1 - 1)) | \
 	((pte & BIT(PTE_PI_IDX_0)) >> (PTE_PI_IDX_0 - 0)))
+#define pte_po_index(pte)	FIELD_GET(PTE_PO_IDX_MASK, pte_val(pte))
+#endif
+
 
 /*
  * Page types used via Permission Indirection Extension (PIE). PIE uses
diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
index 920144ec64dc..09b34d2eeb9a 100644
--- a/arch/arm64/include/asm/pgtable-types.h
+++ b/arch/arm64/include/asm/pgtable-types.h
@@ -11,8 +11,13 @@
 
 #include <asm/types.h>
 
+#ifdef CONFIG_ARM64_D128
+#define __PRIpxx		"016llx%016llx"
+#define __PRIpxx_args(val)	(u64)((val) >> 64), (u64)(val)
+#else
 #define __PRIpxx		"016llx"
 #define __PRIpxx_args(val)	((u64)val)
+#endif
 
 /*
  * Page Table Descriptor
@@ -20,7 +25,11 @@
  * Generic page table descriptor format from which
  * all level specific descriptors can be derived.
  */
+#ifdef CONFIG_ARM64_D128
+typedef u128 ptdesc_t;
+#else
 typedef u64 ptdesc_t;
+#endif
 
 typedef ptdesc_t pteval_t;
 typedef ptdesc_t pmdval_t;
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3cbc95025e76..1749a849e032 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,18 +84,64 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#ifdef CONFIG_ARM64_D128
+#define pxxval_get(x)							\
+({									\
+	typeof(&(x)) __x = &(x);					\
+	union __u128_halves __v;					\
+									\
+	asm volatile ("ldp %[lo], %[hi], %[v]\n"			\
+		: [lo] "=r"(__v.low),					\
+		  [hi] "=r"(__v.high)					\
+		: [v] "Q"(*__x)						\
+	);								\
+									\
+	*(typeof(__x))(&__v.full);					\
+})
+
+#define pxxval_set(x, val)						\
+({									\
+	typeof(&(x)) __x = &(x);					\
+	union __u128_halves __v = { .full = *(u128*)(&(val)) };		\
+									\
+	asm volatile ("stp %[lo], %[hi], %[v]\n"			\
+		: [v] "=Q"(*__x)					\
+		: [lo] "r"(__v.low),					\
+		  [hi] "r"(__v.high)					\
+	);								\
+})
+#else
 #define pxxval_get(x)		READ_ONCE(x)
 #define pxxval_set(x, val)	WRITE_ONCE(x, val)
+#endif
 
 static inline ptdesc_t pxxval_cmpxchg_relaxed(ptdesc_t *ptep, ptdesc_t old,
 					      ptdesc_t new)
 {
+#ifdef CONFIG_ARM64_D128
+	return cmpxchg128_relaxed(ptep, old, new);
+#else
 	return cmpxchg_relaxed(ptep, old, new);
+#endif
 }
 
 static inline ptdesc_t pxxval_xchg_relaxed(ptdesc_t *ptep, ptdesc_t new)
 {
+#ifdef CONFIG_ARM64_D128
+	union __u128_halves r = { .full = new };
+
+	asm volatile(
+	".arch_extension lse128\n"
+	"swpp %[lo], %[hi], %[v]\n"
+		: [lo] "+r" (r.low),
+		  [hi] "+r" (r.high),
+		  [v] "+Q" (*ptep)
+		:);
+
+	return r.full;
+#else
 	return xchg_relaxed(ptep, new);
+#endif
 }
 
 #define pmdp_get pmdp_get
@@ -160,7 +206,7 @@ static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
 #define pte_ERROR(e)	\
 	pr_err("%s:%d: bad pte %" __PRIpxx ".\n", __FILE__, __LINE__, __PRIpxx_args(pte_val(e)))
 
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 static inline phys_addr_t __pte_to_phys(pte_t pte)
 {
 	pte_val(pte) &= ~PTE_MAYBE_SHARED;
@@ -271,7 +317,7 @@ static inline bool por_el0_allows_pkey(u8 pkey, bool write, bool execute)
 	(((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER)) && (!(write) || pte_write(pte)))
 #define pte_access_permitted(pte, write) \
 	(pte_access_permitted_no_overlay(pte, write) && \
-	por_el0_allows_pkey(FIELD_GET(PTE_PO_IDX_MASK, pte_val(pte)), write, false))
+	por_el0_allows_pkey(pte_po_index(pte), write, false))
 #define pmd_access_permitted(pmd, write) \
 	(pte_access_permitted(pmd_pte(pmd), (write)))
 #define pud_access_permitted(pud, write) \
@@ -1128,6 +1174,8 @@ static inline bool pgtable_l4_enabled(void) { return false; }
 
 static __always_inline bool pgtable_l5_enabled(void)
 {
+	if (IS_ENABLED(CONFIG_ARM64_D128))
+		return true;
 	if (!alternative_has_cap_likely(ARM64_ALWAYS_BOOT))
 		return vabits_actual == VA_BITS;
 	return alternative_has_cap_unlikely(ARM64_HAS_VA52);
@@ -1639,11 +1687,15 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
 
+#ifdef CONFIG_ARM64_D128
+#define phys_to_ttbr(addr)	(addr)
+#else
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define phys_to_ttbr(addr)	(((addr) | ((addr) >> 46)) & TTBR_BADDR_MASK_52)
 #else
 #define phys_to_ttbr(addr)	(addr)
 #endif
+#endif
 
 /*
  * On arm64 without hardware Access Flag, copying from user will fail because
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 10ea4f543069..1dd675d2b84d 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -22,6 +22,7 @@
 
 #define CPU_STUCK_REASON_52_BIT_VA	(UL(1) << CPU_STUCK_REASON_SHIFT)
 #define CPU_STUCK_REASON_NO_GRAN	(UL(2) << CPU_STUCK_REASON_SHIFT)
+#define CPU_STUCK_REASON_NO_D128	(UL(3) << CPU_STUCK_REASON_SHIFT)
 
 #ifndef __ASSEMBLER__
 
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 361d74ef8016..7831759b98e1 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -41,6 +41,25 @@
 
 #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
 
+#ifdef CONFIG_ARM64_D128
+#define __tlbip(op, arg) do {		\
+	asm (ARM64_ASM_PREAMBLE		\
+	".arch_extension d128\n\t"	\
+	"tlbip " #op ", %0, %H0\n"	\
+	: : "r" (arg.full));		\
+} while (0)
+
+#define __tlbip_user(op, arg) do {		\
+	if (arm64_kernel_unmapped_at_el0()) {	\
+		arg.low |= USER_ASID_FLAG;	\
+		__tlbip(op, (arg));		\
+	}					\
+} while (0)
+
+#endif
+
+#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
+
 #define __tlbi_user(op, arg) do {						\
 	if (arm64_kernel_unmapped_at_el0())					\
 		__tlbi(op, (arg) | USER_ASID_FLAG);				\
@@ -162,9 +181,15 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
+#ifdef CONFIG_ARM64_D128
+typedef union __u128_halves tlbi_args_t;
+#define __tlbi_wrapper(op, arg)		__tlbip(op, arg)
+#define __tlbi_user_wrapper(op, arg)	__tlbip_user(op, arg)
+#else
 typedef u64 tlbi_args_t;
 #define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
 #define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)
+#endif
 
 typedef void (*tlbi_op)(tlbi_args_t arg);
 
@@ -211,17 +236,28 @@ static __always_inline void ipas2e1is(tlbi_args_t arg)
 	__tlbi_wrapper(ipas2e1is, arg);
 }
 
-static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
-					      u16 asid)
+static __always_inline void __tlbi_update_level(u32 level, u64 *arg)
 {
-	u64 arg = __TLBI_VADDR(addr, asid);
-
 	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) && level <= 3) {
 		u64 ttl = level | (get_trans_granule() << 2);
 
-		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
+		FIELD_MODIFY(TLBI_TTL_MASK, arg, ttl);
 	}
+}
+
+static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level, u16 asid)
+{
+#ifdef CONFIG_ARM64_D128
+	union __u128_halves arg;
+
+	arg.low = FIELD_PREP(TLBI_ASID_MASK, asid);
+	__tlbi_update_level(level, &arg.low);
+	arg.high = addr >> 12;
+#else
+	u64 arg = __TLBI_VADDR(addr, asid);
 
+	__tlbi_update_level(level, &arg);
+#endif
 	op(arg);
 }
 
@@ -507,19 +543,33 @@ static __always_inline void ripas2e1is(tlbi_args_t arg)
 	__tlbi_wrapper(ripas2e1is, arg);
 }
 
-static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
-					 u16 asid, int scale, int num,
-					 u32 level, bool lpa2)
+static __always_inline u64 __tlbi_range_args_encode_comm(u16 asid, int scale, int num, u32 level)
 {
 	u64 arg = 0;
 
-	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
 	arg |= FIELD_PREP(TLBIR_TTL_MASK, level > 3 ? 0 : level);
 	arg |= FIELD_PREP(TLBIR_NUM_MASK, num);
 	arg |= FIELD_PREP(TLBIR_SCALE_MASK, scale);
 	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
 	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
 
+	return arg;
+}
+
+static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
+					 u16 asid, int scale, int num,
+					 u32 level, bool lpa2)
+{
+#ifdef CONFIG_ARM64_D128
+	union __u128_halves arg;
+
+	arg.low = __tlbi_range_args_encode_comm(asid, scale, num, level);
+	arg.high = addr >> 12;
+#else
+	u64 arg = __tlbi_range_args_encode_comm(asid, scale, num, level);
+
+	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
+#endif
 	op(arg);
 }
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 87a822e5c4ca..4ad8047963ad 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -505,6 +505,18 @@ SYM_FUNC_START_LOCAL(__no_granule_support)
 	b	1b
 SYM_FUNC_END(__no_granule_support)
 
+#ifdef CONFIG_ARM64_D128
+SYM_FUNC_START(__no_d128_support)
+	/* Indicate that this CPU can't boot and is stuck in the kernel */
+	update_early_cpu_boot_status \
+		CPU_STUCK_IN_KERNEL | CPU_STUCK_REASON_NO_D128, x1, x2
+1:
+	wfe
+	wfi
+	b	1b
+SYM_FUNC_END(__no_d128_support)
+#endif
+
 SYM_FUNC_START_LOCAL(__primary_switch)
 	adrp	x1, reserved_pg_dir
 	adrp	x2, __pi_init_idmap_pg_dir
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 22866b49be37..5c8bfd56a781 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -215,7 +215,7 @@ SYM_FUNC_ALIAS(__pi_idmap_cpu_replace_ttbr1, idmap_cpu_replace_ttbr1)
 
 	.macro	pte_to_phys, phys, pte
 	and	\phys, \pte, #PTE_ADDR_LOW
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 	and	\pte, \pte, #PTE_ADDR_HIGH
 	orr	\phys, \phys, \pte, lsl #PTE_ADDR_HIGH_SHIFT
 #endif
@@ -541,7 +541,30 @@ alternative_else_nop_endif
 
 	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
 	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1PIE_SHIFT, #4
+#ifdef CONFIG_ARM64_D128
+	cbnz	x1, .Lcheck_d128
+	bl	__no_d128_support
+.Lcheck_d128:
+	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
+	ubfx	x1, x1, #ID_AA64MMFR3_EL1_D128_SHIFT, #4
+	cbnz	x1, .Linit_d128
+	bl	__no_d128_support
+.Linit_d128:
+	/*
+	* Although the lower 64 bits in TTBRx_EL1 registers are now
+	* being used it is prudent to clear out the entire 128 bits
+	* just in case the kernel receives non-zero value in higher
+	* 64 bits from the EL3 which might corrupt the page tables.
+	*/
+	mov	x4, xzr
+	mov	x5, xzr
+
+	msrr	ttbr0_el1, x4, x5
+	msrr	ttbr1_el1, x4, x5
+	orr	tcr2, tcr2, #TCR2_EL1_D128
+#else
 	cbz	x1, .Lskip_indirection
+#endif
 
 	mov_q	x0, PIE_E0_ASM
 	msr	REG_PIRE0_EL1, x0
-- 
2.43.0


