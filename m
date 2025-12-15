Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92318D5B17E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B1D6B0010; Mon, 15 Dec 2025 10:04:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B696B0011; Mon, 15 Dec 2025 10:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3CB86B0012; Mon, 15 Dec 2025 10:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8F756B0010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 932B313554B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:13 +0000 (UTC)
X-FDA: 84222025986.06.89FE45F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD6F21C001D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EEqXsUcJNX1FcbTINZAFLtrsNhnIjFtm60kiHQxHBIQ=;
	b=z8UV1Y86Rg97YUKv4V9RSHSyJHh7nRfSsXbvhgyely6/5nhI5MSGEw1CCQQfEEAXr9VnXN
	AJpEbbsLJ5IBaSOmI62NjFzAimVTnDs5Ucc6dxDHhZEm0wquH6BFm30X3vRl22eJOYb1o6
	OZORzD0BNmFmdAicwDEc6MTN5cXVuWo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811052; a=rsa-sha256;
	cv=none;
	b=E1hdD/DKRHVe+r7WxWP5uUuI7mAfm9qT1a34mJ0kn8vk1GfzxECxzmSJupaPCS8bv8iI82
	nHiHutCyTpR/LzVBDyCSy5CSYQ/ANbcrH7qc4t3iLMwG8I57IqKsVWg2bhswdn2+30zSkg
	ZaXMfN8aKYJIusFgmKKAbQDODthNFtc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD0151691;
	Mon, 15 Dec 2025 07:04:03 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAB283F73B;
	Mon, 15 Dec 2025 07:04:05 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v6 06/14] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
Date: Mon, 15 Dec 2025 15:03:15 +0000
Message-ID: <20251215150323.2218608-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD6F21C001D
X-Stat-Signature: zk98z3sppkmx8hbpe4ypsqic34ezxemx
X-HE-Tag: 1765811051-290193
X-HE-Meta: U2FsdGVkX1+j4VRywcd0e/RiNT+HjpgFt8nuwoYS0EIyo9KDThHEnVvc99RCodc0bxE7jWhA706/3YAkrYNsavgNwLD9WsTYn2ZMso40wik0dcZevH0jk6QhSG4kZULKShyUiz3Cygh642CBqGuKaEFMRrCuz36Q1Ihtaz0a5A63oDL5e6jlqb7YaMe6Rk/E7olda60Tr5/hTeOTgGoBQxCoqiCGfde3F8lm2SWdPDma+cEYpVAfZ/kn6siNMyJPZg4NT9nzLQASzxAaA9wFY/SXysga56PHRrewdBYBOOjggpcEoFeOreLUyLkHIfr5ro7QZdP5+6DHuJovIvqPf2y5XvM6nv2LOXFPGsJsj5TWH0puoKdsarLmHIY70FN+oVZvJJr4fiAXH4ISVRNkmA5R4lU6AGpEEMB8tM2YTz+4hOJKsY50cEJbyGr/oidtzRkUh78Sl8ZINlYy31K3p32rnQibn2KCauXkYAaAF910hzE/9HAxX+bM9Sx2ai3qiIJiUFkstPWLB2jdxjheCoAS5LnQBoMYQXHjpHsVgASUAJ4+Iqcgn3LMApcXO6vK38gmC3VfvwJxYynxrNm9G+8xel3JiG7U9ghivMmYqEWGq1O9u5tbx9OQXJ1la5SAJ+qrW6qOsSz4C4NwPcCbCaMNz+TpoZKvYcx/+GtHQc+jO9MS4q59+QcRSK4/hYiq8zagc6ycPcJ8r0mzoAkdAqfaqX6lr97uq1389WQHTVUvRi9mXLrqSLitqnOgw4EA6PsIz0JsFuY9sz9pNfag9xRTMnstl+R8ve1FGlrbfG7dhNilPIfbdEE5lfMd9NVAjxHouZUbSmyxQU/5KZmVF/kOk9rHaBL9l7EaoF/GRSkQjXGHkTQaFyQ8HSEBVdX5RDwE5W8AINfcbb8F9WdHjMhCGp3ILQ/fnHSPn80+cGpOybRiCfhwZkoYOZqRs+jqabAiE4x2hbV65viW1jk
 S10C0rT1
 tY04BRZcgypM3dzbfYktex4U6xv2ozzA7/oSxQaQSJ7dOez7S6CCDw+zmlcBrthwPk+AAhEH7TDVUJ00hPZbglkvnxvOasFkSclVKvQPDfIdBxSz+UYZhcfwVHtIfzuImSnV/oPgBstqpVPWBLs7J6vtF4W7Vlu0RrAtfIAb5T+MgAl3Xz8/y8Ew+cMhAdMG3805A5oA8ov0nqs1U9/5wgQPKz11zDODjuww627sx6xyehv+V+bJFYIU+HVz7pZgYTzRThuZQ69nTqeKUPlJgN1ijW22+kiOJM1EsSWdypAvUtq8TtgKDqRGsSbNT/voiY6Vy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures currently opt in for implementing lazy_mmu helpers by
defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.

In preparation for introducing a generic lazy_mmu layer that will
require storage in task_struct, let's switch to a cleaner approach:
instead of defining a macro, select a CONFIG option.

This patch introduces CONFIG_ARCH_HAS_LAZY_MMU_MODE and has each
arch select it when it implements lazy_mmu helpers.
__HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
relies on the new CONFIG instead.

On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
selected. This creates some complications in arch/x86/boot/, because
a few files manually undefine PARAVIRT* options. As a result
<asm/paravirt.h> does not define the lazy_mmu helpers, but this
breaks the build as <linux/pgtable.h> only defines them if
!CONFIG_ARCH_HAS_LAZY_MMU_MODE. There does not seem to be a clean
way out of this - let's just undefine that new CONFIG too.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig                                 | 1 +
 arch/arm64/include/asm/pgtable.h                   | 1 -
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 2 --
 arch/powerpc/platforms/Kconfig.cputype             | 1 +
 arch/sparc/Kconfig                                 | 1 +
 arch/sparc/include/asm/tlbflush_64.h               | 2 --
 arch/x86/Kconfig                                   | 1 +
 arch/x86/boot/compressed/misc.h                    | 1 +
 arch/x86/boot/startup/sme.c                        | 1 +
 arch/x86/include/asm/paravirt.h                    | 1 -
 include/linux/pgtable.h                            | 2 +-
 mm/Kconfig                                         | 7 +++++++
 12 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 93173f0a09c7..3fb4603c0e16 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD
+	select ARCH_HAS_LAZY_MMU_MODE
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 64d5f1d9cce9..f7d66c261347 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -80,7 +80,6 @@ static inline void queue_pte_barriers(void)
 	}
 }
 
-#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	/*
diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 2d45f57df169..565c1b7c3eae 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -24,8 +24,6 @@ DECLARE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
 
 extern void __flush_tlb_pending(struct ppc64_tlb_batch *batch);
 
-#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 4c321a8ea896..f399917c17bd 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -93,6 +93,7 @@ config PPC_BOOK3S_64
 	select IRQ_WORK
 	select PPC_64S_HASH_MMU if !PPC_RADIX_MMU
 	select KASAN_VMALLOC if KASAN
+	select ARCH_HAS_LAZY_MMU_MODE
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a630d373e645..2bad14744ca4 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -112,6 +112,7 @@ config SPARC64
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
+	select ARCH_HAS_LAZY_MMU_MODE
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 925bb5d7a4e1..4e1036728e2f 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -39,8 +39,6 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
-#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
 void arch_flush_lazy_mmu_mode(void);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80527299f859..2427a66cb0fe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -808,6 +808,7 @@ config PARAVIRT
 config PARAVIRT_XXL
 	bool
 	depends on X86_64
+	select ARCH_HAS_LAZY_MMU_MODE
 
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index fd855e32c9b9..4f86c5903e03 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -11,6 +11,7 @@
 #undef CONFIG_PARAVIRT
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
+#undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 #undef CONFIG_KASAN
 #undef CONFIG_KASAN_GENERIC
 
diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index e7ea65f3f1d6..b76a7c95dfe1 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -24,6 +24,7 @@
 #undef CONFIG_PARAVIRT
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
+#undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 
 /*
  * This code runs before CPU feature bits are set. By default, the
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index b5e59a7ba0d0..13f9cd31c8f8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -526,7 +526,6 @@ static inline void arch_end_context_switch(struct task_struct *next)
 	PVOP_VCALL1(cpu.end_context_switch, next);
 }
 
-#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	PVOP_VCALL0(mmu.lazy_mode.enter);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 1abc4a1c3d72..d46d86959bd6 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -235,7 +235,7 @@ static inline int pmd_dirty(pmd_t pmd)
  *
  * Nesting is not permitted and the mode cannot be used in interrupt context.
  */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#ifndef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void) {}
 static inline void arch_leave_lazy_mmu_mode(void) {}
 static inline void arch_flush_lazy_mmu_mode(void) {}
diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af8..62073bd61544 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1464,6 +1464,13 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config ARCH_HAS_LAZY_MMU_MODE
+	bool
+	help
+	  The architecture uses the lazy MMU mode. This allows changes to
+	  MMU-related architectural state to be deferred until the mode is
+	  exited. See <linux/pgtable.h> for details.
+
 source "mm/damon/Kconfig"
 
 endmenu
-- 
2.51.2


