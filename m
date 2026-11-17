Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C03606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lmoUkNUh
Received: by kanga.kvack.org (Postfix)
	id DED076B05BE; Tue, 17 Nov 2026 02:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC42A6B05BF; Tue, 17 Nov 2026 02:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01F86B05C0; Tue, 17 Nov 2026 02:06:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 782F96B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B42CCC0203
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:55 +0000 (UTC)
X-FDA: 85443728790.23.324739A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 06C5320005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lmoUkNUh;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hubkfbv3TdG729wINq07mWTnxSQFQXJfXvW7WLXo2fo=;
	b=mw+H3bHOTJeWLA6Kld61gOwkIyhPZavW4OFhyJbr/YVB+f/G+AJC+FHQ3i55Y0OLRzQMoM
	PM5WM67GsQG6yY3FhUiw7CS27uGSPpNOAcNO6c0y+bK6niIdYaE3KeOhiSmg9rHp/gPKjr
	0A/n1+0a0qPCIlm9lUnjizKSsrOW+xs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899214;
	b=fqhiP3yHoxaNbrqHKmOIe50ruDGQeLjUI/rfzcn3wAKiscMHCkpKQWdwfwjDlTjPeCYVv/
	29eBGjZlFjZ32NIpmm2t//VEoy4IV6Nd1RuIXqACdlH39B0jFwi2iNYfZ2kO+ZnZD57zDq
	GNMnDl3cnX2K/F/2U7+7NXe22NNYcsM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lmoUkNUh;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65EA41476;
	Mon, 16 Nov 2026 23:06:50 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D6CF3F882;
	Mon, 16 Nov 2026 23:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899213; bh=lmzjpvDjnEwgeYkHqnXkdPfrUHJQuklwB1LPf/587eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmoUkNUhg0FQFHl8YE2voeTe/jnebgbTlAA3DGZqy1XxcyjmGAKsVyD9TWG5sfnFV
	 Ed3bGf2Y+VoSJJ4PEkV5s/+4LI751g61X1hRbwpfH4RRxBvcodee7CnbrZcu9kR67A
	 G9lPa6E+MuwbrsPMG6V22MLYpAuifpTWnV0/hgdk=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 08/14] arm64/mm: Enable pgtable descriptor for FEAT_D128
Date: Tue, 17 Nov 2026 12:36:07 +0530
Message-ID: <20261117070613.1183243-9-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06C5320005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xrdrxwaqsmip866ikzratf1gzb638gtp
X-HE-Tag: 1794899213-92851
X-HE-Meta: U2FsdGVkX18lU8jT9+vZQPIQ4cUuf3HQDRv77P1+OiZE3iWZ1ub8CeRz9AHupoUPUldYfTwhd1aTHWcmKFVMc6i1zdTGu1YZyaqkGTrcxOu69UYBg66R8QGa3fyTuNgPYpBnmu4bKwvhcSeidbZA2oZzmeJ/qTBldB3v3CWC12eL7yRMc5BXMv0WHl51OoizM8zRtJwWUBq2I44dNihmCCAPIBgNU9WRGNMBCR3blp+/YnYdjEzOrOid1YVNYhNZq33tJSca+w95qGWBQ9HndhlZy0yJ7GrPYAp5wkUIFmtOKIAEiZQOJKYx5oIJ7S2+W+P8lHFQ/hFp8H6bWd0bvfQKmgMFOuc0xe6m7ubQlL+CL7Q7Ro9m6cgwqz2GBS9lRdiOePuCZPuvpciuFBD5w6n4pGqQ/h8ulGsZ70KCFBLbwL7TIcfXD+HbPs8ZI2a4rIftKVpX/n8DAhsALxWcLjOJXjWbMB1hX8rU2apHhB2nL9nDykU3P+NHYy9vqHmaiQtZmtTAspkLKzBvpNzt5HXby5SOGbnh5ewLJpGo5BIyRBhhj28uz9oQCE18GQqyjhjM9ApGe7WBfTJh4dSzQ1PZ8SvQRgI0BnvzZTjzVDLxDvv8PJkuycfkdnzg7If2GcSiSfbP2RpF0bMfS5Y8mOfeWVMgdeGylstBHalI3+nbr3QjlcHMeGbCFjoqELwc8aKpEK/veCMt2WTzVvbmf16G498tF9ZTDh3LFkWWeteqvuUPC63yszweO5Kxp2EbXBDTbPlq9N1fUBiVmLjOhmf6VEC8yL1VFkioC5YeLuhGsEEO68JB7XsDiHkhaJJ+yKNXfb2Cb0l1QOwwZf4GMTz9Lpu3EQZBfWcGtX3Z8Ts1nPHTdBHkA8++IOSI7SFVlgtUCdJLa3gcrxXDPzVmEgQkN7YOLrYfZDGS2ks0wKQ8/VIupNYWLyasZyS2tsQBp0I1SnSlY44sY1QT20a
 bkaF1YBr
 2DYiZpjqccxqH6knaCgv080rHy6I4hlTBi2EvGUMfbYr+itVUlFr0fr9f5t0Tsgo9+OGn+QvTxIVah6JzRbc+ipayBBslcmKVXaHcvE4g0/hhJ+X81/YJjkWXQTk6BOajbUx9hliSIY6OnSlN+mS1sOJK6r7owM8jSeJV6hConlM5tSH5OTVuTMzJiHOTeSDGMWWeKz7gPcC+Fw3FAmIulQEZhIvKufzLQMdESBIcwsPFvGpiO4vS3LwfkXHUmbkO6m9V+lNiG7N3xOkEz0Z6YM9z8UNYHL96hoTr1PZ3vg657WgWnyvx/o14ABsz9hAiltK4V/f2zpI+yKTZV7QhmH0ZVlk0BDHhKPCJ1+irj7vgiO3w+RN1xYvZMIddXXgItAiMAPlpQ2ws+OKU+ndK6aUarb0SM4a8mCv4IM2XKbidozg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 arch/arm64/include/asm/pgtable-prot.h  |  20 +++-
 arch/arm64/include/asm/pgtable-types.h |   4 +
 arch/arm64/include/asm/pgtable.h       |  52 +++++++++-
 arch/arm64/mm/proc.S                   |   2 +-
 6 files changed, 208 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 020670814bda6..93bbb9ec6b4c5 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -597,7 +597,7 @@ alternative_else_nop_endif
  * 	ttbr:	returns the TTBR value
  */
 	.macro	phys_to_ttbr, ttbr, phys
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 	orr	\ttbr, \phys, \phys, lsr #46
 	and	\ttbr, \ttbr, #TTBR_BADDR_MASK_52
 #else
@@ -606,7 +606,7 @@ alternative_else_nop_endif
 	.endm
 
 	.macro	phys_to_pte, pte, phys
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 	orr	\pte, \phys, \phys, lsr #PTE_ADDR_HIGH_SHIFT
 	and	\pte, \pte, #PHYS_TO_PTE_ADDR_MASK
 #else
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 1ee1a6d9db6d4..16fb74c47b742 100644
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
index 590ef4328f12f..e71f2e3444481 100644
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
-#define PTE_UFFD		(_AT(pteval_t, 1) << 58) /* userfaultfd tracking */
+#ifdef CONFIG_ARM64_D128
+#define PTE_UFFD		(_AT(pteval_t, 1) << 94) /* userfaultd tracking */
+#else
+#define PTE_UFFD		(_AT(pteval_t, 1) << 58) /* userfaultd tracking */
+#endif /* CONFIG_ARM64_D128 */
 #define PTE_SWP_UFFD		(_AT(pteval_t, 1) << 3)	 /* only for swp ptes */
 #else
 #define PTE_UFFD		(_AT(pteval_t, 0))
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
index 2f2f5527930f5..83160f8a19fda 100644
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
index bd31211624d4d..e1aba9c8f4061 100644
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
@@ -272,7 +316,7 @@ static inline bool por_el0_allows_pkey(u8 pkey, bool write, bool execute)
 	(((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER)) && (!(write) || pte_write(pte)))
 #define pte_access_permitted(pte, write) \
 	(pte_access_permitted_no_overlay(pte, write) && \
-	por_el0_allows_pkey(FIELD_GET(PTE_PO_IDX_MASK, pte_val(pte)), write, false))
+	por_el0_allows_pkey(pte_po_index(pte), write, false))
 #define pmd_access_permitted(pmd, write) \
 	(pte_access_permitted(pmd_pte(pmd), (write)))
 #define pud_access_permitted(pud, write) \
@@ -1588,11 +1632,15 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
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
index 99aacf03367da..f590c81ef0c76 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -250,7 +250,7 @@ SYM_FUNC_ALIAS(__pi_idmap_cpu_replace_ttbr1, idmap_cpu_replace_ttbr1)
 
 	.macro	pte_to_phys, phys, pte
 	and	\phys, \pte, #PTE_ADDR_LOW
-#ifdef CONFIG_ARM64_PA_BITS_52
+#if defined(CONFIG_ARM64_PA_BITS_52) && !defined(CONFIG_ARM64_D128)
 	and	\pte, \pte, #PTE_ADDR_HIGH
 	orr	\phys, \phys, \pte, lsl #PTE_ADDR_HIGH_SHIFT
 #endif
-- 
2.43.0


