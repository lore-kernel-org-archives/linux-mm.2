Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89738CCD188
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44F98E0058; Wed,  8 Oct 2025 21:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6A48E0002; Wed,  8 Oct 2025 21:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9485D8E0058; Wed,  8 Oct 2025 21:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 768F08E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:59:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E0B611A94C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:04 +0000 (UTC)
X-FDA: 83976917808.10.E9E67BF
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E455140002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="ap4vXN/r";
	spf=pass (imf23.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975142; a=rsa-sha256;
	cv=none;
	b=BnM0DTDnRO/ahnSoZH8VOjP/O6SXs2pPtkVWG+ttgucV7EFfEe1gC6W8kgM+5FFA9tVtVp
	lS3lgYfy97ud7yzJSYjzcYWYBuuUKxy7jCZ0eiAxBnSji+jzB71OhiQoKInG8/zCFlyhvI
	y7Ul+etdAVuTeKIQnkN59Dq6+B8d3bA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="ap4vXN/r";
	spf=pass (imf23.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9q1+NRseWKfUTLpTRf8HDVLHy+6zl45nVa2e8q797C8=;
	b=wnP6/C6b7VOZEslTDqkMO4+dD4OGJegvapTedxjRKEyoekD58XaSZbA1HV1KOkimIW+oKg
	9Z7NmthXAlt3RzhOefs2HgoVDiZsJtb3/rIjWcxggXSc9eH3GKjfz288eMQO3M55dc6I9v
	kDtjP3tWxO8ZWqnDPFlpU+AlDx4jw3A=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so6247875ad.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975141; x=1760579941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9q1+NRseWKfUTLpTRf8HDVLHy+6zl45nVa2e8q797C8=;
        b=ap4vXN/rk/5XzedM1/+XG416GRMNSOSTcnhcadd+QK4ZxbnEwcXPAZkv1seegoFs4x
         JNnO4yjLNDQYoYBTaOkcO4BX7IR1zWJq1Z4qZwnJeUIHahc5sjuHu/zJOSUkCyUt79AL
         MKf7Qvawp0e1SQQai3xZ+dYY6thdMj6NZLWdzQABrKG1j/CBMKrRYlgICZGAlr8pQjuK
         yQHf5gzIQ/Fy0CM3T1nYG7tMLCGLmKliuVwnopkU1aYJrg8mf4PrY+TFUtA2Iub9m98e
         l4+znGp6gYHwCHSUK3XX+sGtLNNQEhkybpbyDyJi3yjRF6dJ8kFc5vzxGKsH2dKVimCB
         XXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975141; x=1760579941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9q1+NRseWKfUTLpTRf8HDVLHy+6zl45nVa2e8q797C8=;
        b=nv3b4wXvMFqXDQJkIIiyFqSCBJEeed6P2UbTIXmlPijvufKBeoDa8GV3EE8A7Ik+IX
         EBIfE2i2YWMuHCdgDxZDs59FpiMa0tufvASgGfqUewo+qINGVf3jF/f0fFAkKNEfvOBT
         pS+bcN/I0alGD1AGW447z6CvAwQojBIi/zLWWd/zOJnP2j6k+br5i7CEoHZRx8gyvgk5
         p+6DVshYq9BwjSBH2KGHCTdjTRx4gwj0qblW8wgyj87SRVBhdirXaTxA2DnHFYjkUmM0
         JX9uJ4gDJUhHuRXNmbheR2XlxyoLjspHzMOenWs6iMWItmrWyjQ4sUpgpkF6Z+QFH5Pz
         w1Yg==
X-Forwarded-Encrypted: i=1; AJvYcCU0RF6Oyf6Ol9zUiJTYEMX7Kwj2aCiHX/dEYH68ajBdDs2IcgxllG7kn1cVEuSUDk5K4CbjRLKpoQ==@kvack.org
X-Gm-Message-State: AOJu0YwVdFmpW12cGtyzOBqDfcsk1KH0ezZf4qLCmOkdeVRvWHRT9lHq
	QfsKP3Oy0++DPQYGAKNFin3JRTmN2PE0yG9/WsLdcSvj/vtMohuD+9XeAs8n7rSPmVQ=
X-Gm-Gg: ASbGncuv+AmncOaAaX+XtljZOKWvZSLfFuiIGjsJaM51IThL9sVqHzrNlTcPACpCO5w
	axJ4JxlWmlCUsBC7TQAOAVHZgh02VWLhr6Uzbva0nw82tiVX/YB87kH8LZdJu8MNoW3CE+wTGpm
	OSxOCanltWWYHkBmwvLrZ3U+qGvDo8JiGt8AyxH77BVwszlvvrczB92RA4VbwpOgk/hztpCUcgl
	Yoyz59899W7ePaiJOVeWo/FUQf3frVp+B8SM2NCkmVEng9Hbz45IlZTnEFBnzhnxczkw3qtmoJJ
	nrP0NUeCqeP5WsvopKj7TUY1dawo32yPxWaELjmQJlBANl7zB73hA5I3MPl4UHlHNBhqdfPPSyg
	On9Dz0ZaG1EIHAqcQ1D29VEiTYJgWolemAccyyq73JykmUQu1i0VdV7jtFdPZKbadDJ5L
X-Google-Smtp-Source: AGHT+IGHPU9/iVX5Ud8D5Es3cH4G+7xlgwuzFWFaCEYVHmYTlH0i4nMQlJ1VHDlSvFYfFYRC22It8g==
X-Received: by 2002:a17:903:1a90:b0:269:d978:7ec0 with SMTP id d9443c01a7336-290272c19bdmr71839945ad.28.1759975140781;
        Wed, 08 Oct 2025 18:59:00 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:59:00 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 16/18] riscv: mm: Use physical memory aliases to apply PMAs
Date: Wed,  8 Oct 2025 18:57:52 -0700
Message-ID: <20251009015839.3460231-17-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tyiw5auteq8fso8fwc53yi7xpgwfoi9b
X-Rspamd-Queue-Id: 0E455140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1759975141-426235
X-HE-Meta: U2FsdGVkX19cFkD09+Z2HZVRdCR6V9vm6AVcvSpRPkNx5+UyINZBTgKRZdMCb9wDWz6JmokoEmAGbDP/z4YijI/TWAicSPKN23lWVTkaLS2wbcZL+GzzPhl5JMBQN9yazeBT/hWMOc+DY8qOKJgav4wJfTI3ptmppZ+P1TynDW3xdlR5xcjtSS0DKz0uWVJYBylEpUfPjrSWUzS3JvgsOEh2/slwvQ319Z2gvNPQl4jg30uwcqmWlyJBJJ46KFYRoZQoR6aZBuauwKpeuz7Qq/Rcjvywr5jF/B8e4Sl+OipgyXQ0i0b+0CKue5qrsTooM2nkx9ExXZAQeEiOyGYkBLsEINDZATEnbjyHiSF2R244dE/dj2r6Fd2ipyRLyfmw8nWDs8AsR3PoeJ7N8CZBnh6kLSUheZfoRr/h89kZ/LRqnfgxKYyUItsrihB6sKvqZ+nJZCl4Df4hsFCPoD7dsLZuiNAmqiPXle89eYeKZTD/eBJX0dv1SAlS/0jka1WgGX0uYUTm1Qp2ioE85QIB0pQqwFFxlHEjRLefk0oXhgGTxBfvg+UXgjoZmEA8UOG9X3vpoPAfVYlfJi+/Y9XzNiEUZyEM8zCCB9EuPVbal2fWwTS8axoQcRqiiq4L9azoBwI3FTuP83EcCWDqvqblc1NmJ+jy+wxAoYsqlHeTSzsFVGtWcu+bzh87fDILtR8GdFQf0mqgDF0l5hu7kCXd3tgvYAhlMTgxMt+ytQlAwj0RRXrMO7+Aa2DqRiKoNsC3T1/UYZ52HBzN6GmzNTzMJ14c3kh1h6H6o4u8XXXWV03HK8GE+Zo/qGPU+qnJxkESIqOplYSTpQoiuaBdN7kgdFs6RnZ6kijCWD1sOaec7PIpA7Gqlv4eJTjau5JaGFBGJfoIyL8YschusUfro64/o+Jk5CpaCTCRLyf6u0xjpoEEQmVvwvl3888+UjG4BGG55bQJyox8p3G90jdMSf7
 pMxevc3u
 boLelp7PA1yFlJeESA+lCSDTicVSeWNvwdR8+0uuXBR5YBeAwbsMJ2waKwNEY+O/ZSyvvv68QaF5kXP4tNdOJotizH5d5idy4z2eiiyCVduvT+4TNrZ3mTsuBSvi6bCnzYoEE+xIGEWgdwPkbys96BZKZ1WJXYb2bY0sagSPWn3nlj51fsLhEQelMbcl0fAq+GGLvoDi32z4GIcmUh4+bycO29n4zqiaFQ1qJ9/65y/Wal78wbIdEtVqM7LlVghWUhq88+16buInP9nIRF8eV3y4qREWrOKCN8tUVJ/jgZbO/uTJKCmO0hT0ESzDeMvRrnZrqbqKheQTRJ80y2R/Aw9WBhfIbTYm8Ebe78pUmVOkapN2cGuYWbrlJpvzCw5uw25BI6WCE0lqknD5HzNkRCU1S7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On some RISC-V platforms, RAM is mapped simultaneously to multiple
physical address ranges, with each alias having a different set of
statically-determined Physical Memory Attributes (PMAs). Software alters
the PMAs for a particular page at runtime by selecting a PFN from among
the aliases of that page's physical address.

Implement this by transforming the PFN when writing page tables. If the
memory type field is nonzero, replace the PFN with the corresponding PFN
from the noncached alias. Similarly, when reading from the page tables,
if the PFN is found in a noncached alias, replace it with the PFN from
the normal memory alias, and insert _PAGE_NOCACHE.

The rest of the kernel sees only PFNs from normal memory and
_PAGE_MTMASK values as if Svpbmt was implemented.

Memory alias pairs are determined from the devicetree. A Linux custom
ISA extension is added to trigger the alternative patching, as
alternatives must be linked to an extension or a vendor erratum, and
this behavior is not associated with any particular processor vendor.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - Put new code behind a new Kconfig option RISCV_ISA_XLINUXMEMALIAS
 - Document the calling convention of riscv_fixup/unfix_memory_alias()
 - Do not transform !pte_present() (e.g. swap) PTEs
 - Export riscv_fixup/unfix_memory_alias() to fix module compilation

 arch/riscv/Kconfig                    |  16 ++++
 arch/riscv/include/asm/hwcap.h        |   1 +
 arch/riscv/include/asm/pgtable-64.h   |  44 +++++++--
 arch/riscv/include/asm/pgtable-bits.h |   5 +-
 arch/riscv/include/asm/pgtable.h      |   8 ++
 arch/riscv/kernel/cpufeature.c        |   6 ++
 arch/riscv/kernel/setup.c             |   1 +
 arch/riscv/mm/Makefile                |   1 +
 arch/riscv/mm/memory-alias.S          | 123 ++++++++++++++++++++++++++
 arch/riscv/mm/pgtable.c               |  91 +++++++++++++++++++
 arch/riscv/mm/ptdump.c                |   6 +-
 11 files changed, 290 insertions(+), 12 deletions(-)
 create mode 100644 arch/riscv/mm/memory-alias.S

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 51dcd8eaa2435..72c60fa94c0d7 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -890,6 +890,22 @@ config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
 	  versions of clang and GCC to be passed to GAS, which has the same result
 	  as passing zicsr and zifencei to -march.
 
+config RISCV_ISA_XLINUXMEMALIAS
+	bool "Use physical memory aliases to emulate page-based memory types"
+	depends on 64BIT && MMU
+	depends on RISCV_ALTERNATIVE
+	default y
+	help
+	  Add support for the kernel to alter the Physical Memory Attributes
+	  (PMAs) of a page at runtime by selecting from among the aliases of
+	  that page in the physical address space.
+
+	  On systems where physical memory aliases are present, this option
+	  is required in order to mark pages as non-cacheable for use with
+	  non-coherent DMA devices.
+
+	  If you don't know what to do here, say Y.
+
 config FPU
 	bool "FPU support"
 	default y
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a3..6c6349fe15a77 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -107,6 +107,7 @@
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
 
+#define RISCV_ISA_EXT_XLINUXMEMALIAS	126
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
 #define RISCV_ISA_EXT_MAX		128
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 60c2615e46724..34b6f4ef3aad8 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -95,7 +95,8 @@ enum napot_cont_order {
 #define HUGE_MAX_HSTATE		2
 #endif
 
-#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || \
+	defined(CONFIG_ERRATA_THEAD_MAE)
 
 /*
  * ALT_FIXUP_MT
@@ -105,6 +106,9 @@ enum napot_cont_order {
  *
  * On systems that support Svpbmt, the memory type bits are left alone.
  *
+ * On systems that support XLinuxMemalias, PTEs with a nonzero memory type have
+ * the memory type bits cleared and the PFN replaced with the matching alias.
+ *
  * On systems that support XTheadMae, a Svpbmt memory type is transformed
  * into the corresponding XTheadMae memory type.
  *
@@ -127,22 +131,35 @@ enum napot_cont_order {
  */
 
 #define ALT_FIXUP_MT(_val)								\
-	asm(ALTERNATIVE_2("addi	t0, zero, 0x3\n\t"					\
+	asm(ALTERNATIVE_3("addi	t0, zero, 0x3\n\t"					\
 			  "slli	t0, t0, 61\n\t"						\
 			  "not	t0, t0\n\t"						\
 			  "and	%0, %0, t0\n\t"						\
 			  "nop\n\t"							\
 			  "nop\n\t"							\
+			  "nop\n\t"							\
 			  "nop",							\
-			  __nops(7),							\
+			  __nops(8),							\
 			  0, RISCV_ISA_EXT_SVPBMT, CONFIG_RISCV_ISA_SVPBMT,		\
+			  "addi	t0, zero, 0x3\n\t"					\
+			  "slli	t0, t0, 61\n\t"						\
+			  "and	t0, %0, t0\n\t"						\
+			  "beqz	t0, 2f\n\t"						\
+			  "xor	t1, %0, t0\n\t"						\
+			  "1: auipc t0, %%pcrel_hi(riscv_fixup_memory_alias)\n\t"	\
+			  "jalr	t0, t0, %%pcrel_lo(1b)\n\t"				\
+			  "mv	%0, t1\n"						\
+			  "2:",								\
+			  0, RISCV_ISA_EXT_XLINUXMEMALIAS,				\
+				CONFIG_RISCV_ISA_XLINUXMEMALIAS,			\
 			  "srli	t0, %0, 59\n\t"						\
 			  "seqz	t1, t0\n\t"						\
 			  "slli	t1, t1, 1\n\t"						\
 			  "or	t0, t0, t1\n\t"						\
 			  "xori	t0, t0, 0x5\n\t"					\
 			  "slli	t0, t0, 60\n\t"						\
-			  "xor	%0, %0, t0",						\
+			  "xor	%0, %0, t0\n\t"						\
+			  "nop",							\
 			  THEAD_VENDOR_ID, ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
 			  : "+r" (_val) :: "t0", "t1")
 
@@ -150,9 +167,9 @@ enum napot_cont_order {
 
 #define ALT_FIXUP_MT(_val)
 
-#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_RISCV_ISA_XLINUXMEMALIAS || CONFIG_ERRATA_THEAD_MAE */
 
-#if defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || defined(CONFIG_ERRATA_THEAD_MAE)
 
 /*
  * ALT_UNFIX_MT
@@ -160,6 +177,9 @@ enum napot_cont_order {
  * On systems that support Svpbmt, or do not support any form of page-based
  * memory type configuration, the memory type bits are left alone.
  *
+ * On systems that support XLinuxMemalias, PTEs with an aliased PFN have the
+ * matching memory type set and the PFN replaced with the normal memory alias.
+ *
  * On systems that support XTheadMae, the XTheadMae memory type (or zero) is
  * transformed back into the corresponding Svpbmt memory type.
  *
@@ -170,7 +190,15 @@ enum napot_cont_order {
  */
 
 #define ALT_UNFIX_MT(_val)								\
-	asm(ALTERNATIVE(__nops(6),							\
+	asm(ALTERNATIVE_2(__nops(6),							\
+			  "mv	t1, %0\n\t"						\
+			  "1: auipc t0, %%pcrel_hi(riscv_unfix_memory_alias)\n\t"	\
+			  "jalr	t0, t0, %%pcrel_lo(1b)\n\t"				\
+			  "mv	%0, t1\n\t"						\
+			  "nop\n\t"							\
+			  "nop",							\
+			  0, RISCV_ISA_EXT_XLINUXMEMALIAS,				\
+				CONFIG_RISCV_ISA_XLINUXMEMALIAS,			\
 			  "srli	t0, %0, 60\n\t"						\
 			  "andi	t0, t0, 0xd\n\t"					\
 			  "srli	t1, t0, 1\n\t"						\
@@ -234,7 +262,7 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 
 #define ALT_UNFIX_MT(_val)
 
-#endif /* CONFIG_ERRATA_THEAD_MAE */
+#endif /* CONFIG_RISCV_ISA_XLINUXMEMALIAS || CONFIG_ERRATA_THEAD_MAE */
 
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index 18c50cbd78bf5..4586917b2d985 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -38,7 +38,8 @@
 #define _PAGE_PFN_MASK		GENMASK(31, 10)
 #endif /* CONFIG_64BIT */
 
-#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || \
+	defined(CONFIG_ERRATA_THEAD_MAE)
 /*
  * [62:61] Svpbmt Memory Type definitions:
  *
@@ -54,7 +55,7 @@
 #define _PAGE_NOCACHE		0
 #define _PAGE_IO		0
 #define _PAGE_MTMASK		0
-#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_RISCV_ISA_XLINUXMEMALIAS || CONFIG_ERRATA_THEAD_MAE */
 
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
 #define _PAGE_NAPOT_SHIFT	63
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 03b5623f9107c..f96b0bd043c6d 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1110,6 +1110,14 @@ extern u64 satp_mode;
 void paging_init(void);
 void misc_mem_init(void);
 
+#ifdef CONFIG_RISCV_ISA_XLINUXMEMALIAS
+bool __init riscv_have_memory_alias(void);
+void __init riscv_init_memory_alias(void);
+#else
+static inline bool riscv_have_memory_alias(void) { return false; }
+static inline void riscv_init_memory_alias(void) {}
+#endif /* CONFIG_RISCV_ISA_XLINUXMEMALIAS */
+
 /*
  * ZERO_PAGE is a global shared page that is always zero,
  * used for zero-mapped memory areas, etc.
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 743d53415572e..1449c43eab726 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -1093,6 +1093,12 @@ void __init riscv_fill_hwcap(void)
 		riscv_v_setup_vsize();
 	}
 
+	/* Vendor-independent alternatives require a bit in the ISA bitmap. */
+	if (riscv_have_memory_alias()) {
+		set_bit(RISCV_ISA_EXT_XLINUXMEMALIAS, riscv_isa);
+		pr_info("Using physical memory alias for noncached mappings\n");
+	}
+
 	memset(print_str, 0, sizeof(print_str));
 	for (i = 0, j = 0; i < NUM_ALPHA_EXTS; i++)
 		if (riscv_isa[0] & BIT_MASK(i))
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index f90cce7a3acea..00569c4fef494 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -353,6 +353,7 @@ void __init setup_arch(char **cmdline_p)
 	}
 
 	riscv_init_cbo_blocksizes();
+	riscv_init_memory_alias();
 	riscv_fill_hwcap();
 	apply_boot_alternatives();
 	init_rt_signal_env();
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index b916a68d324ad..b4d757226efbf 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -33,3 +33,4 @@ endif
 obj-$(CONFIG_DEBUG_VIRTUAL) += physaddr.o
 obj-$(CONFIG_RISCV_DMA_NONCOHERENT) += dma-noncoherent.o
 obj-$(CONFIG_RISCV_NONSTANDARD_CACHE_OPS) += cache-ops.o
+obj-$(CONFIG_RISCV_ISA_XLINUXMEMALIAS) += memory-alias.o
diff --git a/arch/riscv/mm/memory-alias.S b/arch/riscv/mm/memory-alias.S
new file mode 100644
index 0000000000000..e37b83d115911
--- /dev/null
+++ b/arch/riscv/mm/memory-alias.S
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 SiFive
+ */
+
+#include <linux/bits.h>
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/pgtable.h>
+
+#define CACHED_BASE_OFFSET	(0 * RISCV_SZPTR)
+#define NONCACHED_BASE_OFFSET	(1 * RISCV_SZPTR)
+#define SIZE_OFFSET		(2 * RISCV_SZPTR)
+
+#define SIZEOF_PAIR		(4 * RISCV_SZPTR)
+
+/*
+ * Called from ALT_FIXUP_MT with a non-standard calling convention:
+ *	t0 => return address
+ *	t1 => page table entry
+ *	all other registers are callee-saved
+ */
+SYM_CODE_START(riscv_fixup_memory_alias)
+	addi	sp, sp, -4 * SZREG
+	REG_S	t2, (0 * SZREG)(sp)
+	REG_S	t3, (1 * SZREG)(sp)
+	REG_S	t4, (2 * SZREG)(sp)
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+	REG_S	t5, (3 * SZREG)(sp)
+
+	/* Save and mask off _PAGE_NAPOT if present. */
+	li	t5, _PAGE_NAPOT
+	and	t5, t1, t5
+	xor	t1, t1, t5
+#endif
+
+	/* Ignore !pte_present() PTEs, including swap PTEs. */
+	andi	t2, t1, (_PAGE_PRESENT | _PAGE_PROT_NONE)
+	beqz	t2, .Lfixup_end
+
+	lla	t2, memory_alias_pairs
+.Lfixup_loop:
+	REG_L	t3, SIZE_OFFSET(t2)
+	beqz	t3, .Lfixup_end
+	REG_L	t4, CACHED_BASE_OFFSET(t2)
+	sub	t4, t1, t4
+	bltu	t4, t3, .Lfixup_found
+	addi	t2, t2, SIZEOF_PAIR
+	j	.Lfixup_loop
+
+.Lfixup_found:
+	REG_L	t3, NONCACHED_BASE_OFFSET(t2)
+	add	t1, t3, t4
+
+.Lfixup_end:
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+	xor	t1, t1, t5
+
+	REG_L	t5, (3 * SZREG)(sp)
+#endif
+	REG_L	t4, (2 * SZREG)(sp)
+	REG_L	t3, (1 * SZREG)(sp)
+	REG_L	t2, (0 * SZREG)(sp)
+	addi	sp, sp, 4 * SZREG
+	jr	t0
+SYM_CODE_END(riscv_fixup_memory_alias)
+EXPORT_SYMBOL(riscv_fixup_memory_alias)
+
+/*
+ * Called from ALT_UNFIX_MT with a non-standard calling convention:
+ *	t0 => return address
+ *	t1 => page table entry
+ *	all other registers are callee-saved
+ */
+SYM_CODE_START(riscv_unfix_memory_alias)
+	addi	sp, sp, -4 * SZREG
+	REG_S	t2, (0 * SZREG)(sp)
+	REG_S	t3, (1 * SZREG)(sp)
+	REG_S	t4, (2 * SZREG)(sp)
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+	REG_S	t5, (3 * SZREG)(sp)
+
+	/* Save and mask off _PAGE_NAPOT if present. */
+	li	t5, _PAGE_NAPOT
+	and	t5, t1, t5
+	xor	t1, t1, t5
+#endif
+
+	/* Ignore !pte_present() PTEs, including swap PTEs. */
+	andi	t2, t1, (_PAGE_PRESENT | _PAGE_PROT_NONE)
+	beqz	t2, .Lunfix_end
+
+	lla	t2, memory_alias_pairs
+.Lunfix_loop:
+	REG_L	t3, SIZE_OFFSET(t2)
+	beqz	t3, .Lunfix_end
+	REG_L	t4, NONCACHED_BASE_OFFSET(t2)
+	sub	t4, t1, t4
+	bltu	t4, t3, .Lunfix_found
+	addi	t2, t2, SIZEOF_PAIR
+	j	.Lunfix_loop
+
+.Lunfix_found:
+	REG_L	t3, CACHED_BASE_OFFSET(t2)
+	add	t1, t3, t4
+
+	/* PFN was in the noncached alias, so mark it as such. */
+	li	t2, _PAGE_NOCACHE
+	or	t1, t1, t2
+
+.Lunfix_end:
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+	xor	t1, t1, t5
+
+	REG_L	t5, (3 * SZREG)(sp)
+#endif
+	REG_L	t4, (2 * SZREG)(sp)
+	REG_L	t3, (1 * SZREG)(sp)
+	REG_L	t2, (0 * SZREG)(sp)
+	addi	sp, sp, 4 * SZREG
+	jr	t0
+SYM_CODE_END(riscv_unfix_memory_alias)
+EXPORT_SYMBOL(riscv_unfix_memory_alias)
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 604744d6924f5..de79a2dc9926f 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -1,8 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <asm/pgalloc.h>
+#include <dt-bindings/riscv/physical-memory.h>
+#include <linux/bitfield.h>
 #include <linux/gfp.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
+#include <linux/of.h>
 #include <linux/pgtable.h>
 
 int ptep_set_access_flags(struct vm_area_struct *vma,
@@ -160,3 +164,90 @@ pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 	return old;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+#ifdef CONFIG_RISCV_ISA_XLINUXMEMALIAS
+struct memory_alias_pair {
+	unsigned long cached_base;
+	unsigned long noncached_base;
+	unsigned long size;
+	int index;
+} memory_alias_pairs[5];
+
+bool __init riscv_have_memory_alias(void)
+{
+	return memory_alias_pairs[0].size;
+}
+
+void __init riscv_init_memory_alias(void)
+{
+	int na = of_n_addr_cells(of_root);
+	int ns = of_n_size_cells(of_root);
+	int nc = na + ns + 2;
+	const __be32 *prop;
+	int pairs = 0;
+	int len;
+
+	prop = of_get_property(of_root, "riscv,physical-memory-regions", &len);
+	if (!prop)
+		return;
+
+	len /= sizeof(__be32);
+	for (int i = 0; len >= nc; i++, prop += nc, len -= nc) {
+		unsigned long base = of_read_ulong(prop, na);
+		unsigned long size = of_read_ulong(prop + na, ns);
+		unsigned long flags = be32_to_cpup(prop + na + ns);
+		struct memory_alias_pair *pair;
+		int alias;
+
+		/* We only care about non-coherent memory. */
+		if ((flags & PMA_ORDER_MASK) != PMA_ORDER_MEMORY || (flags & PMA_COHERENT))
+			continue;
+
+		/* The cacheable alias must be usable memory. */
+		if ((flags & PMA_CACHEABLE) &&
+		    !memblock_overlaps_region(&memblock.memory, base, size))
+			continue;
+
+		alias = FIELD_GET(PMR_ALIAS_MASK, flags);
+		if (alias) {
+			pair = NULL;
+			for (int j = 0; j < pairs; j++) {
+				if (alias == memory_alias_pairs[j].index) {
+					pair = &memory_alias_pairs[j];
+					break;
+				}
+			}
+			if (!pair)
+				continue;
+		} else {
+			/* Leave room for the null sentinel. */
+			if (pairs == ARRAY_SIZE(memory_alias_pairs) - 1)
+				continue;
+			pair = &memory_alias_pairs[pairs++];
+			pair->index = i;
+		}
+
+		/* Align the address and size with the page table PFN field. */
+		base >>= PAGE_SHIFT - _PAGE_PFN_SHIFT;
+		size >>= PAGE_SHIFT - _PAGE_PFN_SHIFT;
+
+		if (flags & PMA_CACHEABLE)
+			pair->cached_base = base;
+		else
+			pair->noncached_base = base;
+		pair->size = min_not_zero(pair->size, size);
+	}
+
+	/* Remove any unmatched pairs. */
+	for (int i = 0; i < pairs; i++) {
+		struct memory_alias_pair *pair = &memory_alias_pairs[i];
+
+		if (pair->cached_base && pair->noncached_base && pair->size)
+			continue;
+
+		for (int j = i + 1; j < pairs; j++)
+			memory_alias_pairs[j - 1] = memory_alias_pairs[j];
+		memory_alias_pairs[--pairs].size = 0;
+	}
+}
+#endif /* CONFIG_RISCV_ISA_XLINUXMEMALIAS */
diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index ed57926ecd585..ba5f33a2c2178 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -140,7 +140,8 @@ static const struct prot_bits pte_bits[] = {
 		.clear = ".",
 	}, {
 #endif
-#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || \
+	defined(CONFIG_ERRATA_THEAD_MAE)
 		.mask = _PAGE_MTMASK,
 		.set = "MT(%s)",
 		.clear = "  ..  ",
@@ -216,7 +217,8 @@ static void dump_prot(struct pg_state *st)
 		if (val) {
 			if (pte_bits[i].mask == _PAGE_SOFT)
 				sprintf(s, pte_bits[i].set, val >> 8);
-#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || \
+	defined(CONFIG_ERRATA_THEAD_MAE)
 			else if (pte_bits[i].mask == _PAGE_MTMASK) {
 				if (val == _PAGE_NOCACHE)
 					sprintf(s, pte_bits[i].set, "NC");
-- 
2.47.2


