Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBCDCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038C78E0035; Wed, 12 Nov 2025 20:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6ACE8E002F; Wed, 12 Nov 2025 20:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1DF8E0035; Wed, 12 Nov 2025 20:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9364F8E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CBCB1A073C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:32 +0000 (UTC)
X-FDA: 84103896744.14.0DB4EF4
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 836124000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=mjzzywD5;
	spf=pass (imf04.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOtRFITo02H4IQSZeZ1BamFbY19pkW2KaAlb2iNDjWw=;
	b=LjGeeFZO5ZndK8pzGQTfIwsg00mMJtjCKtfJnFEXD0NLMzlKq0sbulUPNhlRYCJfj/1nPo
	D/p3tVCC5oMZLEt+46KxTbCCkfVy7q73ANDsY52UOxA6RmTPKxCG5w3PJzuEwCTdFOlrqN
	DoSLDrvANswPbaTImQ8KmrHGHa9DefI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998450; a=rsa-sha256;
	cv=none;
	b=Lq2Yn3nF2eo+jOB/CK3G60UEDk/ONFHgVJs45pKXfv/3xvI2j/Lm1NH4Xf6G1mPl7V7I0u
	I0wp0mQUP+UCeBZ3iFbOzW/vyai/gcTqMBrduRGjXiw4i9hM+dHNxFuQnQTt3SYxEM8Y7A
	YFOUUBEDWPSSRJyV/RW5vdjOs3RwHF0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=mjzzywD5;
	spf=pass (imf04.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-297d4a56f97so2458695ad.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998449; x=1763603249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOtRFITo02H4IQSZeZ1BamFbY19pkW2KaAlb2iNDjWw=;
        b=mjzzywD5qNvOHTa1ayVS5VQ9OX2ISSSQY1M16a70d2ovhk0PHadeKP7zDpEakKiSIx
         3zUo/vxWMkM91kuKIeTpT/aLPN1dW5Q/k865Y+Cvxl7fiM+nSbbdB+kKPbpJf3Dyx/md
         TVkGgnaOpuOhyfX/P+0Tyrcdwcfb9/b9alb2eONrVu7q3vaA6ugrlGVHJ0UJQWBJjEUh
         xgRFMzMdPwp/UsUbNf6f/SOTshjtGuCMkuxt5xI/NIAHRiV1aj7fzHAodiIIQo6kcYXQ
         pv57nDRydiskBp8e+Etgl3ZiGmDgOEDuUQ3HBgWEMqTzb3lxiBTV80KRN15lQiP9uzav
         lgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998449; x=1763603249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HOtRFITo02H4IQSZeZ1BamFbY19pkW2KaAlb2iNDjWw=;
        b=hhdfwddk9lOkSH050BSPx/PNY9hO5lvgHeTM9kU5lKh4q0N6i9xht8oNEwswRyeRUn
         uVDDLwtqonpHWYgd1CyGds6y3Px1ai94iWt35naGArMtz9PyNnf4LFxxNY7x7hQX+wfu
         EtZHvWFVfZPFdv/vU32EFerrSIMN4Q1h0OFA1TKenxzvSpsfRVr4b8tCbg9w7TfZhHg5
         OjA7zTgQNGKsnJbLLc2ieEMqlIJxM8wEFgtwPoHXZkTjTaEatCyuEaTpu5CSWtz0SovN
         wHd/ZA9rjCaO5R8+/Xd1kpCpPmN+q2ROM0Cz2QzfGKL5O9MYHIpJcj/T+wAJ0B6tHicj
         XzBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxpM1rUchtJuru1PIFV3fJug8syRliRO4I8R8aDeGSQXn9vgLNeCOPG51Uw4ckdWbHopJCetQIGQ==@kvack.org
X-Gm-Message-State: AOJu0YzzZNXz1SXHYCgcwfzWhQmRUgH7FiXxkeyGBOb2TxY4bUaq2ADD
	StAXADt3EkXVs9QFmiwKYZS8vJQp/4+3aZ3nrwUo369I62QbscCs5HV+AZzUlJ1pVM8=
X-Gm-Gg: ASbGnct6z4al2LnM6Q95twX/7DzuGt07WGcPsJc9OoWrDdqBliRj5XHhfYMwA6AA7N/
	WMYmWK6HvpyTrXQ+3NjOPq0IB93TEyS3NLlL7yOL5buiAd7mqASHUHhCDAl5MT+c7wAh5Ew7Fgc
	WQGCHcIbU/Qz9JPTweB4dMc2P9snTFCFp7phhKf3LJ3qR24iMFV3GslaJ53Me9H9oy5DbRp5liE
	jB7TJizyE7WX/LsP96uXPyWZx3yHsFzdZilYETEz6yJn0VXSRccj5LIXanRhuF700PNv24NXYD6
	ZyD0BMOUM6+NJUc2EEHp/xNG75cA9BhfVZjJsoMyjHBe/joqxZeFKthHy7Z/BZLPoXRX0tu9T19
	9pwcGB6+pTn92m3e12UaOIlbN11XlTdTLVI9f8522uzuBXPpIQNHOTij8MkormXHEc5L9wQT9bl
	J74qCKXK4zmYvFKe3qAHFf3Q==
X-Google-Smtp-Source: AGHT+IGSKyxeN0VSp7kzP7NfJ86/9I9ANN0lDslbNbt/QqR2hftPu3Zqd6k0IFT90ar8rvdWpbD7XQ==
X-Received: by 2002:a17:902:f788:b0:298:49db:a9c5 with SMTP id d9443c01a7336-2984edd243amr57875185ad.43.1762998449290;
        Wed, 12 Nov 2025 17:47:29 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:29 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 20/22] riscv: mm: Use physical memory aliases to apply PMAs
Date: Wed, 12 Nov 2025 17:45:33 -0800
Message-ID: <20251113014656.2605447-21-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ojmw6pkthxmrauey8iamxn8jrj134ubr
X-Rspam-User: 
X-Rspamd-Queue-Id: 836124000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1762998450-955078
X-HE-Meta: U2FsdGVkX18bix8KakNXIaznpf/PjZD9bEhQ4wgLL6NgNilIqmlKnKh+bECF/GkPiEcORQpNHhktnwHIaZ0zv1fzqcSSLf0lL3cGWsQepAN2G4oWMQXS5+6GOEOFlW/30kXEtJ6sWqRMfMzUb4MRbALkTuVbJOtPDh45l7DRJmoCBI/IW6ZNg+6YCca/SZER9urNAUohj4qrD0P/jWUIMJLRTWG8gDUXy3iI/JCkYEYlU8A3GYeSUW3SGxiImcWEcmgCV/sc9KegLTgdHFDdaLZ42GEMH9cP3o5mUVpqh5WRdccaDzDL29drqmn32PVziVCWeqe9L389xwHwjy4UbKClUJWWoDB/wXJx08WTeypadhvig3vzMiPQYQec4ZtAYcm1jubMY+OgxwX8Jl1N91wCTN9SH9iJRnqeT/N5/Is8rS8RHZrdQ8at4IA8hz9pgZ10PvNg8MDSDz33oKWM9Lv2RelQXGco5OnEZmQPF814piU6fXPuL1L+GMj5ImxY89Kij6qKY6l6eItInjIUtpvbOrRV/JlqE/2oxNmpLoF5vtHdaMp602Q7q9uPSWuovEg3I8H+3a8Qp4TyCIZ+wtJH6x5HoPsji2C6+0kMUPLT463+s7ElYJmgVcVakUm7+bR+f5Y59CmhR/3iGWhixATIOdsxC1kpJTn0/TTLaOb3RGly2cKZAREutUPRmxNHDEhG3dO4ZUCmVE5IjzGAomYMTyN2EYUBsKfS/mdCN/dtmyAQzOS9Xb7cS+i/MtHKbiZnkYSs/IApFLAbQDpBn3o/FaaUH0MoB0xDcq7stMwl8KcVccZLOqaiKygMMJvMHahwbLYHuDoc17IjJPnsczq2R5Y1BXEvrW1BgvpDg6TVfGAhEw+cQuicEC3FEsJ/8n+g+/XmaB1NHZpgQBZmL2vCMvLzQLjhM0/5mLTomI5flo3f5OqkY/KkucX3+g1+auR5lGrP3FJlFwgTEe/
 7o7wpZcu
 s0p6NsVL2wv8Xp4X88FJXetX7gvP2Cl0zmcX0+IbpGHcOccFsrZLmqMdT8ZdY/hk+oxTNS5q7XURYaURqprjCfEatSAItmEkzSJgywuIBRrTxG+W6RpV2DStrLOrjL3E2kMOloPBK88jWU/6rPUH+MF3uW6BnzU5z4I5DiRnO0O9eQEgjYYko10kj7wTF43dIcylWsjQ+JGdokyXHO3fOXlfblqf/D9Kx0Zf1dCMq+7B2SSXAERwFkQkh3qgSYQ0FPX8sHpcTNdfO//PBFhrpYn0Fu+VKJhhCN7bLomhj7sfY5Ab0Vc0BlSmOI1YHCG6h8aeGv7YY19EIqjl49Lf9aeCO3PUpDZLxsll534T4DK8Fj2/XGUIfH8hOoUPFMLnCs6lkhxJo32ZnVQfIVVf65FcKEg==
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

Changes in v3:
 - Fix the logic to allow an alias to be paired with region entry 0
 - Select DMA_DIRECT_REMAP

Changes in v2:
 - Put new code behind a new Kconfig option RISCV_ISA_XLINUXMEMALIAS
 - Document the calling convention of riscv_fixup/unfix_memory_alias()
 - Do not transform !pte_present() (e.g. swap) PTEs
 - Export riscv_fixup/unfix_memory_alias() to fix module compilation

 arch/riscv/Kconfig                    |  17 ++++
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
 11 files changed, 291 insertions(+), 12 deletions(-)
 create mode 100644 arch/riscv/mm/memory-alias.S

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index cf5a4b5cdcd4..21efa0d9bdd4 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -877,6 +877,23 @@ config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
 	  versions of clang and GCC to be passed to GAS, which has the same result
 	  as passing zicsr and zifencei to -march.
 
+config RISCV_ISA_XLINUXMEMALIAS
+	bool "Use physical memory aliases to emulate page-based memory types"
+	depends on 64BIT && MMU
+	depends on RISCV_ALTERNATIVE
+	default y
+	select DMA_DIRECT_REMAP
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
index affd63e11b0a..6c6349fe15a7 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -107,6 +107,7 @@
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
 
+#define RISCV_ISA_EXT_XLINUXMEMALIAS	126
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
 #define RISCV_ISA_EXT_MAX		128
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index fa2c1dcb6f72..f1ecd022e3ee 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -97,7 +97,8 @@ enum napot_cont_order {
 #define HUGE_MAX_HSTATE		2
 #endif
 
-#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || \
+	defined(CONFIG_ERRATA_THEAD_MAE)
 
 /*
  * ALT_FIXUP_MT
@@ -107,6 +108,9 @@ enum napot_cont_order {
  *
  * On systems that support Svpbmt, the memory type bits are left alone.
  *
+ * On systems that support XLinuxMemalias, PTEs with a nonzero memory type have
+ * the memory type bits cleared and the PFN replaced with the matching alias.
+ *
  * On systems that support XTheadMae, a Svpbmt memory type is transformed
  * into the corresponding XTheadMae memory type.
  *
@@ -129,22 +133,35 @@ enum napot_cont_order {
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
 
@@ -152,9 +169,9 @@ enum napot_cont_order {
 
 #define ALT_FIXUP_MT(_val)
 
-#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_RISCV_ISA_XLINUXMEMALIAS || CONFIG_ERRATA_THEAD_MAE */
 
-#if defined(CONFIG_ERRATA_THEAD_MAE)
+#if defined(CONFIG_RISCV_ISA_XLINUXMEMALIAS) || defined(CONFIG_ERRATA_THEAD_MAE)
 
 /*
  * ALT_UNFIX_MT
@@ -162,6 +179,9 @@ enum napot_cont_order {
  * On systems that support Svpbmt, or do not support any form of page-based
  * memory type configuration, the memory type bits are left alone.
  *
+ * On systems that support XLinuxMemalias, PTEs with an aliased PFN have the
+ * matching memory type set and the PFN replaced with the normal memory alias.
+ *
  * On systems that support XTheadMae, the XTheadMae memory type (or zero) is
  * transformed back into the corresponding Svpbmt memory type.
  *
@@ -172,7 +192,15 @@ enum napot_cont_order {
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
@@ -236,7 +264,7 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 
 #define ALT_UNFIX_MT(_val)
 
-#endif /* CONFIG_ERRATA_THEAD_MAE */
+#endif /* CONFIG_RISCV_ISA_XLINUXMEMALIAS || CONFIG_ERRATA_THEAD_MAE */
 
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index 18c50cbd78bf..4586917b2d98 100644
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
index 8b622f901707..27e8c20af0e2 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1113,6 +1113,14 @@ extern u64 satp_mode;
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
index 72ca768f4e91..ee59b160e886 100644
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
index b5bc5fc65cea..a6f821150101 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -357,6 +357,7 @@ void __init setup_arch(char **cmdline_p)
 	}
 
 	riscv_init_cbo_blocksizes();
+	riscv_init_memory_alias();
 	riscv_fill_hwcap();
 	apply_boot_alternatives();
 	init_rt_signal_env();
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index b916a68d324a..b4d757226efb 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -33,3 +33,4 @@ endif
 obj-$(CONFIG_DEBUG_VIRTUAL) += physaddr.o
 obj-$(CONFIG_RISCV_DMA_NONCOHERENT) += dma-noncoherent.o
 obj-$(CONFIG_RISCV_NONSTANDARD_CACHE_OPS) += cache-ops.o
+obj-$(CONFIG_RISCV_ISA_XLINUXMEMALIAS) += memory-alias.o
diff --git a/arch/riscv/mm/memory-alias.S b/arch/riscv/mm/memory-alias.S
new file mode 100644
index 000000000000..e37b83d11591
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
index 604744d6924f..45f6a0ac22fa 100644
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
+		if (flags & PMR_IS_ALIAS) {
+			int alias = FIELD_GET(PMR_ALIAS_MASK, flags);
+
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
index 763ffde8ab5e..29a7be14cca5 100644
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


