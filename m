Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8025CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44926900219; Fri, 15 Aug 2025 04:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F98A8E0002; Fri, 15 Aug 2025 04:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33700900219; Fri, 15 Aug 2025 04:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D21D8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA1DE83A1B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:02 +0000 (UTC)
X-FDA: 83778384564.26.3EFFCED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 322D01A0004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9Uv6PMeEitsNbE3DZPwOTfx/f+eI4cUe3OB2+EV8DU=;
	b=kS3lJ+K/qh2wDU1j1apjumdpPpLTiBuQMvhj/xs+hkj/XPkfd6frwd8lB/+xSCs4/qasTq
	jSOL/60qLfLUpdvgPgxmRYIkewHPVdaojuTB3qt+i/Lk7DxP36Wezx350dH+OqVtI9kOeV
	/H3Dd792PC1YXutU89yEzEwJuNN+FvY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248161; a=rsa-sha256;
	cv=none;
	b=udfzEzQAuiCEnPMsIOjkh8T8snmuu8tXVeI1IaQg7SbOAmlUNlMnXpIfCY2FSHdUu6+9/M
	BhVd8s0NPNFA2zJAkIUEsjJQ9ud5JRx9BceJSM6AmWThdVklPJHHaHDyRdCcRwwbPX42BQ
	eo2BBpmhtyRuF+A968Cun9NZKUnX4Cs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B7B31E32;
	Fri, 15 Aug 2025 01:55:52 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D84FA3F63F;
	Fri, 15 Aug 2025 01:55:55 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 07/18] arm64: Reset POR_EL1 on exception entry
Date: Fri, 15 Aug 2025 09:55:01 +0100
Message-ID: <20250815085512.2182322-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gzr67ugr13nr7xpz6dp4agqsqzrxrsqn
X-Rspam-User: 
X-Rspamd-Queue-Id: 322D01A0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755248160-927258
X-HE-Meta: U2FsdGVkX1/dUmAfczQn9Kssi/rr9A3ltpqcqfxbVJxS9uN1JZ3LM7lhIJWd7wrNcfqZJxxnh3zUyWwovyRxegl4vEEqDjbdQWeOwdCI4Bjn2slAa5RJq8wZv/Qvx/yJ8k1HWT8CSwNb3PZfBU0Hr/8qOAwjz1P6nHHTz1Fzncf7YpWYsNI+Qd623ptWPkpQ1JLZlJFlnt6OKEhxnQKRKBK9nVsqGB8d/A/LGhG8wSRZ8RzXJ+eh49/M6fAteRaTaz+LVmz8g3iZLWS4ujaqSDZkjMLR7IONNZRY+4/FgluO/XKaKxAdl8uHmPP+D6dncwNRFbgh7tFTqdHfIgxbj+Eeri9YD3b3x4iWWZGS3bh06UUsv6qSGX0PT82zBfVfls1ju2tBRCAdQA6dhqmr6BZ9O2LXDFB7TeCAwvZpyT3y1W/BKDkcnFHTz5d0DxOwDpoG3UmGZS/nu/gTtNk/XDs/0D1Pccz48FlijzR0lWCjBUej3zgCtzRX52IEM3V1itAbxxhfXotd+TX0yPuV0s8ADqRrUzY0bJvAHWnSWtQPdyc636j876p44RbUjlJFrcbkj/liDzXxQW66RRuinjp8ApkVxXn5SOmXc+YJjTC7exh4CmyomGoNWvc1JeUGxO0g3pN0Z6/30L4st7IgmtW+RpQhpWoJ7J9CZDOP1jFXLzr6PMfnpeGbvBWWwI6e6rggV5BVuU2k4oNYzWqiZBeT72aufEUCnDXgyQCslNQnLJeZzUsD72csQAu2tPvHi+VfcSL59pEOS7GYxFVM4qrNEI6ez5AfaFV4mhFhBheMvItA3Hz7od96rwBTP/NI9seLm8dQwHt+O+BVxc0OWNrukHAOacYeZOtPlDsEy/ccdQJD8knsjlG7m87CJYLOCV+zGHvasH7TZfMKbTaXoR2ONtghVkECmzNAAjtY0RqaW66nN/QzCTdfqwpbhmhrMRSGXnNiVKMuidDLQo4
 jIQv0YXK
 ulNanzogD/e2SgFTikhUADgKfDnkYHR5ia2GWaEm2ndSvfCgkTux4Vv9P7ggqy9xK8J0rlnwzcTEFDqaxbCHMQt2jwsBBinpPJ62XsHB4XMkOaGkBmbSHzi/mDj4ZTdXfKoFHAyy6+P+TzTAz4keqadQ9QXk+Aq9pbUsyEBNO9MoWwWSGOJsXk/dY5qSesOIDDaPHZ0weLfHeBik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

POR_EL1 will be modified, through the kpkeys framework, in order to
grant temporary RW access to certain keys. If an exception occurs
in the middle of a "critical section" where POR_EL1 is set to a
privileged value, it is preferable to reset it to its default value
upon taking the exception to minimise the amount of code running at
higher kpkeys level.

This patch implements the reset of POR_EL1 on exception entry,
storing the original value in a new pt_regs field and restoring on
exception return. To avoid an expensive ISB, the register is only
reset if the interrupted value isn't the default. No check is made
on the return path as an ISB occurs anyway as part of ERET.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 10 ++++++++++
 arch/arm64/include/asm/por.h    |  4 ++++
 arch/arm64/include/asm/ptrace.h |  4 ++++
 arch/arm64/kernel/asm-offsets.c |  3 +++
 arch/arm64/kernel/entry.S       | 24 +++++++++++++++++++++++-
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 3b0ab5e7dd22..79ae33388088 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -8,6 +8,14 @@
 
 #include <asm-generic/kpkeys.h>
 
+/*
+ * Equivalent to por_set_kpkeys_level(0, KPKEYS_LVL_DEFAULT), but can also be
+ * used in assembly.
+ */
+#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
+
+#ifndef __ASSEMBLY__
+
 static inline bool arch_kpkeys_enabled(void)
 {
 	return system_supports_poe();
@@ -46,4 +54,6 @@ static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
 
 #endif /* CONFIG_ARM64_POE */
 
+#endif	/* __ASSEMBLY__ */
+
 #endif	/* __ASM_KPKEYS_H */
diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index bffb4d2b1246..58dce4b8021b 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -10,6 +10,8 @@
 
 #define POR_EL0_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
 
+#ifndef __ASSEMBLY__
+
 static inline bool por_elx_allows_read(u64 por, u8 pkey)
 {
 	u8 perm = POR_ELx_PERM_GET(pkey, por);
@@ -38,4 +40,6 @@ static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
 	return (por & ~(POE_MASK << shift)) | (perms << shift);
 }
 
+#endif	/* __ASSEMBLY__ */
+
 #endif /* _ASM_ARM64_POR_H */
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 47ff8654c5ec..e907df4225d4 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -166,6 +166,10 @@ struct pt_regs {
 	u64 orig_x0;
 	s32 syscallno;
 	u32 pmr;
+#ifdef CONFIG_ARM64_POE
+	u64 por_el1;
+	u64 __unused;
+#endif
 
 	u64 sdei_ttbr1;
 	struct frame_record_meta stackframe;
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 30d4bbe68661..8ae5cc3c203b 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -75,6 +75,9 @@ int main(void)
   DEFINE(S_SYSCALLNO,		offsetof(struct pt_regs, syscallno));
   DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
   DEFINE(S_PMR,			offsetof(struct pt_regs, pmr));
+#ifdef CONFIG_ARM64_POE
+  DEFINE(S_POR_EL1,		offsetof(struct pt_regs, por_el1));
+#endif
   DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
   DEFINE(S_STACKFRAME_TYPE,	offsetof(struct pt_regs, stackframe.type));
   DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f8018b5c1f9a..0dd6f7fbb669 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -20,6 +20,7 @@
 #include <asm/errno.h>
 #include <asm/esr.h>
 #include <asm/irq.h>
+#include <asm/kpkeys.h>
 #include <asm/memory.h>
 #include <asm/mmu.h>
 #include <asm/processor.h>
@@ -277,6 +278,19 @@ alternative_else_nop_endif
 	.else
 	add	x21, sp, #PT_REGS_SIZE
 	get_current_task tsk
+#ifdef CONFIG_ARM64_POE
+alternative_if_not ARM64_HAS_S1POE
+	b	1f
+alternative_else_nop_endif
+	mrs_s	x0, SYS_POR_EL1
+	str	x0, [sp, #S_POR_EL1]
+	mov	x1, #POR_EL1_INIT
+	cmp	x0, x1
+	b.eq	1f
+	msr_s	SYS_POR_EL1, x1
+	isb
+1:
+#endif /* CONFIG_ARM64_POE */
 	.endif /* \el == 0 */
 	mrs	x22, elr_el1
 	mrs	x23, spsr_el1
@@ -407,7 +421,15 @@ alternative_else_nop_endif
 	mte_set_user_gcr tsk, x0, x1
 
 	apply_ssbd 0, x0, x1
-	.endif
+	.else
+#ifdef CONFIG_ARM64_POE
+alternative_if ARM64_HAS_S1POE
+	ldr	x0, [sp, #S_POR_EL1]
+	msr_s	SYS_POR_EL1, x0
+	/* No explicit ISB; we rely on ERET */
+alternative_else_nop_endif
+#endif /* CONFIG_ARM64_POE */
+	.endif /* \el == 0 */
 
 	msr	elr_el1, x21			// set up the return data
 	msr	spsr_el1, x22
-- 
2.47.0


