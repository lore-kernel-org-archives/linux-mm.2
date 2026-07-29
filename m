Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240C4C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBFF6B014D; Wed, 29 Jul 2026 10:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694A96B014E; Wed, 29 Jul 2026 10:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581B16B014F; Wed, 29 Jul 2026 10:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D99D6B014D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72FBF80687
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:05 +0000 (UTC)
X-FDA: 85041736290.07.0D8487F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0F3610000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mjfJ6XVk;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAdBoG8Pkwhf4aRaTxRuLg3VdqgldPsFE1gft3Hy/Sw=;
	b=WHhx/bYhL07EIhqziSPLVEzYzDYMpgxECFvrJ8A9TDKqRG3hD04UtGtpwUMU66ANjXaUXx
	+M4OWV+ruV3Cmg+IM1giGvF6bJL4Mx0FuedrxgYPvuLVGY0c0yfUo/OTQLnI4AtdiMQreZ
	00oP7ty6NaZ8bE+kQMldEqihvMaHtkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327963;
	b=G+3ViZc/PwjERfA1CznSTHL5Z6QTbu4cm774/l/0d2DSF7f2NEkGvGhiP9918mCadIl24a
	73jJgJ1ebVcMgMW/30AyS+NtFk/bDkuhfpbUeCiUr4bKNCJxxR4l1IZurGm/qDvCpde70a
	PTPaczZSCAjkBbdmTyI30azQHJGiOwI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mjfJ6XVk;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0DB81688;
	Wed, 29 Jul 2026 05:25:58 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 76AE73F66F;
	Wed, 29 Jul 2026 05:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327963; bh=biUHq+9m9Bbjnls77vCIUMQVhENoT4EWMuElJIEsyq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjfJ6XVkOIUDXoEGnYrxFzadFpU1nG9LJdB6DCM9ujX2orb4cVtXVVtnZNnD4L1C3
	 mQblXNG8AawEhcTDAG4r8OQgGk7DX0AUvUAI+PU1rFcaJO4Dl1RlpM7gEWrl+vKpIq
	 nJKuMjiT3GZr5I4f94qa9IbhVimv4cbvogFEkADg=
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
Subject: [PATCH 13/17] arm64/mm: Enable pgtable descriptor for FEAT_D128
Date: Wed, 29 Jul 2026 17:54:48 +0530
Message-ID: <20260729122452.3797443-14-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0F3610000A
X-Stat-Signature: xcwtj9iw73se9fsugwnrnsminzp4p147
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785327963-607989
X-HE-Meta: U2FsdGVkX187/+5D4MGWJV1nqJjsBKC0Vu6AGzQCJvZxPOZfkJq3/V4GjnwDff83z5QZyuPAkaxadesDG0gRHczNpMrIaqQ9hngDIKrkFiy9+mHoyE0ijLXsmhB/fB+jv19G3vjGcjBnD7STl9P21wAICDKCN7tQCxfcUbZTi2miBB0xACsE0+JNHhjO+0qR9WpJ91/RHBUZnaupyp5Ac8eBcOV/tevgi2KNFyzG0k2Hw06Fcg2uf5GxLnjKtT1Kf1av/bNm9Dv712lJ7DWwCK1hLcUwLZyyBGXsJS/NJyPTJD4zjb0BbzW9FDW59rOGKKSfJgU0ch6IinxQGhJKeSRWAZBH7NZUeOkuCTd8jPVEd7wlBng6oztMEs6441g8Z1EQi3A0jO0VQjpxgMMIjRKgZgFZ3F3jguSKZ3A2UanxlUAphIGpW/joX0jkQ5Aj+ukBSKhLoTx0c++Vzlfx43L6+M+vaJPTPCr//cszwM7Lp2blAyL9ZDbtias63NXbN9xwurZ0+44m7GIcDCaZ5ZGAXn0yzq0pBPeOM8Uq63I++wEZ0B8Q3fKKUM1KSMbJzd8t0LploJZh/gRXeSsI+H4maS5smXHtVYR+iZpSLYtLDL/5EVnYRTKcXGHkr5usw2eYd40mUio9BMABvzJ7/S4HiE4KSyCk99936O2kfE4V//aCJCyRVerPKXDAlhHz4O2ipf55TGWIOw63NBxW3HwIie24TB+j627R5DBv3+oue+YwZYo0m5bkjeAID5tombWSYpyXnFe6eyV9oij7RKjglCu2zRKQksJKXy0qsd3C6PvxVqTxeFIYygXI5zs+7+N3f8CCXBmz/qwdScVJPNukj6u7IhRf+92dl4/RO39dOIp8LcwPbqEP3ZJMtgZnykfVTz5k4DFTCCvzuKaWrhGTIdoJ2KtWOV8dl6qpNnbrY64dEoJYwaS/rGwQEPlpeH4ti23H8+4nQTH9TXd
 vdUtFlif
 c8ks0W1GAiUUGuJw86Karkzb4RBemfsgPOmIV4KKeKi4LuO+Ch309pFLBZ+t1esE8kWaU3dbGSUitLppwmAzzMBwrIqcsdgb/Ii12iGFvstSbZ8SWtYNlL9eNzWxATyBmGEJ/R3+FKx9l9eWYvygjAn3xaHqMa2X8ybQjAqjgcJrtqC5MxomXhgtrNK0VnsBuPQTHKEoj3WU7yPi+ZDUBK+YXSiz5jWnntyArG1qJoUUNxb34NjFvfEADibcVIGIPo/8ekNdwjd8w8qHhuR66Pig7+Z8hycZQDQgXROPJtUXBaBmiTvMCrnMnVVnfudli+wbxjaAJVrE6PTbZ9x7HEiUXv/FkWF+15XzAG1693W3WPFQ3WFBA7Uwwug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable pgtable descriptor fields and related accessors for FEAT_D128. First
expand ptval_t as 128 bits, add all D128 specific pgtable descriptor fields
and update accessors like ptval_get/set() and ptval_xchg_relaxed(). Also do
ensure that ARM64_PA_BITS_52 specific handlings are not applicable for D128
which does not follow PA bits folding mechanisms as in FEAT_[LPA|LPA2].

Although all the above changes gets enabled only with CONFIG_ARM64_D128.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/assembler.h     |   4 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 133 +++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable-prot.h  |  18 +++-
 arch/arm64/include/asm/pgtable-types.h |   4 +
 arch/arm64/include/asm/pgtable.h       |  52 +++++++++-
 arch/arm64/mm/proc.S                   |   2 +-
 6 files changed, 207 insertions(+), 6 deletions(-)

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
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 1ee1a6d9db6d..16fb74c47b74 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -101,6 +101,137 @@
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
@@ -215,7 +346,9 @@
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
index 2f2f5527930f..83160f8a19fd 100644
--- a/arch/arm64/include/asm/pgtable-types.h
+++ b/arch/arm64/include/asm/pgtable-types.h
@@ -17,7 +17,11 @@
  * Generic page table descriptor format from which
  * all level specific descriptors can be derived.
  */
+#ifdef CONFIG_ARM64_D128
+typedef u128 ptval_t;
+#else
 typedef u64 ptval_t;
+#endif
 
 typedef ptval_t pteval_t;
 typedef ptval_t pmdval_t;
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ed5ea7d31c0a..9e7d891597cc 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,18 +84,62 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#ifdef CONFIG_ARM64_D128
+#define ptval_get(x)							\
+({									\
+	typeof(&(x)) __x = &(x);					\
+	union __u128_halves __v;					\
+									\
+	asm volatile ("ldp %[lo], %[hi], %[v]\n"			\
+		: [lo] "=r"(__v.low),					\
+		  [hi] "=r"(__v.high)					\
+		: [v] "Q"(*__x)						\
+	);								\
+	*(typeof(__x))(&__v.full);					\
+})
+
+#define ptval_set(x, val)						\
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
 #define ptval_get(x)		READ_ONCE(x)
 #define ptval_set(x, val)	WRITE_ONCE(x, val)
+#endif
 
 static inline ptval_t ptval_cmpxchg_relaxed(ptval_t *ptep, ptval_t old,
 					      ptval_t new)
 {
+#ifdef CONFIG_ARM64_D128
+	return cmpxchg128_relaxed(ptep, old, new);
+#else
 	return cmpxchg_relaxed(ptep, old, new);
+#endif
 }
 
 static inline ptval_t ptval_xchg_relaxed(ptval_t *ptep, ptval_t new)
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
+	return r.full;
+#else
 	return xchg_relaxed(ptep, new);
+#endif
 }
 
 #define pmdp_get pmdp_get
@@ -157,7 +201,7 @@ static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
 	__flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, 2,	\
 			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
 
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 static inline phys_addr_t __pte_to_phys(pte_t pte)
 {
 	pte_val(pte) &= ~PTE_MAYBE_SHARED;
@@ -268,7 +312,7 @@ static inline bool por_el0_allows_pkey(u8 pkey, bool write, bool execute)
 	(((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER)) && (!(write) || pte_write(pte)))
 #define pte_access_permitted(pte, write) \
 	(pte_access_permitted_no_overlay(pte, write) && \
-	por_el0_allows_pkey(FIELD_GET(PTE_PO_IDX_MASK, pte_val(pte)), write, false))
+	por_el0_allows_pkey(pte_po_index(pte), write, false))
 #define pmd_access_permitted(pmd, write) \
 	(pte_access_permitted(pmd_pte(pmd), (write)))
 #define pud_access_permitted(pud, write) \
@@ -1637,11 +1681,15 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
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
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 22866b49be37..6db62d56e97e 100644
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
-- 
2.43.0


