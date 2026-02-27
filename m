Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42FDFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AD66B0096; Fri, 27 Feb 2026 12:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB816B0098; Fri, 27 Feb 2026 12:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7876B0099; Fri, 27 Feb 2026 12:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25A696B0096
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE13D5B6F5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:18 +0000 (UTC)
X-FDA: 84490990836.12.5CAD4ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 370BB2000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ksVWQ1ZWHXJ73fAwFe1u5hfLOgELKdw0SQJbIT8MUXw=;
	b=06NLbJFKVNCBHxeNemb83kHXGPYc2f9OcWcq6tVrpWlpn9uPwjQrP+NUfa/9rnxqfgKA45
	lkvU7HRB6LcQu+OngUXCAJgjPOlJ+4Ouz8ITyQXLXo7Fxnazc36HtWPDhaIVccOCY23Kty
	xkCDNjGDMdhKSk7UmUggM4BCAg5hzZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214977; a=rsa-sha256;
	cv=none;
	b=C44RTUqpaCJo5jtGnRkb7JKuiXTXDraOWV66MmW89HnMY65YE8FZuf5wTchWpYHPr2Dgq9
	8f7mrh7+qRNOCvxI3hYadd2rZmt693vteQD2+mJlNo0knk5k+FomZWAgG+CMtMRYBsXttb
	075sngX8/MyJow6ab4yqL7t3o/CB9Cw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19704176B;
	Fri, 27 Feb 2026 09:56:10 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2FBF3F73B;
	Fri, 27 Feb 2026 09:56:11 -0800 (PST)
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
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 07/30] arm64: Reset POR_EL1 on exception entry
Date: Fri, 27 Feb 2026 17:54:55 +0000
Message-ID: <20260227175518.3728055-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 370BB2000D
X-Stat-Signature: q43ughtjzao984kajf9j7hednfrau7ue
X-Rspam-User: 
X-HE-Tag: 1772214977-205909
X-HE-Meta: U2FsdGVkX196fFz2QS9c8OroCpo7nBKszan6fjGYqRYG7acrGznZ5GV4KOgxGqQ2a+t6G19gEU6HcZAElS6Yo/r3e7PZ5tSOdGDtwhR/sxQ57x/0ougaIGEPbgY4Eq0yt12XfmTKSpfR8wA7A9i7HO/2vtZoSyF45dJhST2jNAOhYB4hxjQVpfgZYJ7A/mSLWWEhFXBvQxAmee7VYpjs6odcHIshD8dlW1MeYbvFLAVQPfHU7r1smBHJYrEEMF3QUMEKmyDH4fz2ko/jk9+wIIM4G695Uge0H0/Kt4dHDlhTqnO/8eTrq2Ifw3/jFvdy3fk9QC5So2BEwwCQlXeTqO2YmYUpHpLPCQmrz8PgS+9nXpr1NoOPU5xQZ8S/NF8WsyRgbO5+8LEHpcn7foKVrIN2zWrJb5VemRSXu0wbLheVLAvGeN346vzSL2q7ZS7lGkm9GjbpSL1YUM67H72BGvcRncDfJbngpFh8+hXFGi2og3rzLiNFRxuDduIjMu7rhc2/N8BdxbdpXFZZh47iXLHknzG0d52Y1bk91+SYpKSZ4KN6qvS5sA8yD0pL34ewoLzl50fC4R2y1u9Ssc1JH1d1DhPiXyMAOuBPs3j2zMIYD8ggrea0ukycGyI9ngkF1HS1LNJLKdtsLKRDrWvGbUHPXA0z6xCgQhhv9VJ4pcnw1nPehs6yPF065vz1YBrSXk1ajkd+sSu+8hKzsgDD8tDjYkuVViHPIuJdTJu0+YwwwxcckQOFIk+9dmaIv1ZHX5+sfnhzgDFdzSn1iS9CbjHohkIm2A89VfAQATAks8HLHBJgRkSJAwzDLqh6wtjsdtUPPHbrqx6697HuXQ90CSQxedF26OlgayYEq0K10jH3U3AARE6rnkJuRCPehfIbox3ZfKbmHq+bIpI5hQhrGnHChAb4ZkUpA+zKE4aT+d2rSF9VGeGc7H9Ifip0St52zhYtzl1thxKRLiSuqEB
 jJSUKI43
 F2nI9Q/Ze5P1WZz7oOrxNKJWDdkcaQxb6cPQ0GWyiScMO4Pib1Zb4ISHX+nGehyp81qLo7ujZESy/roxgbnFI1squ6mimQSHuDEMwGclveBxKQxOHg/vJ/xaNRj4TeUKbsfO/3iP+/FEot14Zx12JObM+u6SAYdrXt94QzWl5wsGAcSwEaHibwn4d+CBdNoMGby7xz3liK2ccIao=
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
index 39582511ad72..1a258617ab89 100644
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
index b6367ff3a49c..30b4d0636f58 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -76,6 +76,9 @@ int main(void)
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
2.51.2


