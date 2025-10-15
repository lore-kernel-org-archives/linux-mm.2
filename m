Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDAC7CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB808E0011; Wed, 15 Oct 2025 04:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2931F8E0002; Wed, 15 Oct 2025 04:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0818E0011; Wed, 15 Oct 2025 04:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8448E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA9C9140BC9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:11 +0000 (UTC)
X-FDA: 83999671182.09.31D7496
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B2AA1C000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sIunMov0D4cAh3NWLlfGoDvkKo6/ouQfl7dX2jhJDdQ=;
	b=hhIqcuJPLN6hYvT3+rm+kvGXxhLxdL5qR+E6I1AGreglJjelwJU7YZzmjT4LyjWvSiF7SM
	NZpO1Fd67L5KC/AtcKK/V6K5B0o/ARF9I3953KUHeQpcQVP/uQHZd6KQyBYePu5zfE9F8I
	qAXIfuDKIPy9J0O+ryQaFPP5YgcZH5M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516890; a=rsa-sha256;
	cv=none;
	b=8UJr678xBseAFD7Fe+jqGj6F48WbDREed+PdhIYmoJlxzpv2ITG3G1+URfAJZCs2nnmyrt
	yxs+If4hSZuDOTMuoDpsQqPPs+av/AEs1JHBFg8d2NZ16eznpYN1E+KGT0ivr0uej/bQYw
	gEiQTM0EMrsVUg1daPqHtJ3LR9E6ijo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82ADC22FA;
	Wed, 15 Oct 2025 01:28:01 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 801C23F66E;
	Wed, 15 Oct 2025 01:28:04 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v3 05/13] mm: introduce CONFIG_ARCH_LAZY_MMU
Date: Wed, 15 Oct 2025 09:27:19 +0100
Message-ID: <20251015082727.2395128-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6bzkqxpctkamrsa61dbb1kn49ahjb3ko
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2B2AA1C000F
X-HE-Tag: 1760516889-147265
X-HE-Meta: U2FsdGVkX19w4tRbGTcNj8Hqbj/A+M+tWpf8N7Q5saqhnVleGY6h+MGSz1pVi8s4bjc8VhnWa6DimDLIydG89GFV/vlJKPZMg+sr5Sw08xUsFMfWNue2JJ9ksiBLYD33WUdilKp7kY3XnWRzydgLqRtFk0csDentT0JXR8W3FPbqv2UU56h6rAHsggQMUnBYkYMwbIt1O9Ct2jJ1NV+nqhfufBteVikgVWeenh8LGcXlEM4ilTdYD7opiWvfm743631Kfrhv6QJ2aQmkB4G8FyVuHTcz4yDFnCJcLJtLjJTnxtYbhqImvx9UEnpakymkFJEunJVrSS5Lbg5JVei8wobvXwPA63WWlIdeAaMQYmZ7UPjkpmbWKV08KHClJz27ro2ms61Vs+x/d9I12TmWwwfkI0KYAovsEosOefOaTq229CQuMjb62/h7s8Fm1b6FoPDCEKYc0EPa4rGR1qxALivE4E6P2j0czJH7FTQU1k5vy1FAWkTsrkqnYN9LIe9l4dyRYiWlsi8KnraozZilFVb51xkILofIMWA9M5EwQ0ZVnQC0dNuK7p2XMRMKIoC9V3TGIX04o+zr5G++FygssCfHodUYo+56PCQZ/cC5ifFaLhL0kxD5QumI2cPowU/9c6zDySUTwGJAjyldJ+rRNE+JNeSaAgGAYCT6uVk/Dq+c9RWsUgbmXktzUFxqAtbnO8/Q6KVT99x83vi0/L8dZEXUA4XecriTmtZUHmt72ZBz3FIjCo77fdo1pmzZ6swxVsFf2BPZ4A21dy+Lp4tfsjGvFkYwRFNHw9JU32+JRnd51EX08p1aYbKcrk9vug1bkCt/NB62JxfndVgEcYW3m3x6AiKYV1mTzwqlZQIzvO7DYfCnmEtTdHaN0GHDan3rE+Kz7PeDEVhPU9AxQodhV5srVGEkz1SZywzrfTMcp1INhr5Lg07rZqQKHkWMKpcypH7mKoWqceYsyfoRPMY
 kgz+3Xe1
 SJelqOaNxvtpW3kb+k4Lj25tCYLooFa2XrIRQ82s4foQteGmMC7jQ5lzPxu6oXZyKT7NvECoGTvr7gev2CNh58syyg+/FhDf52TUfpl/ERjD36FKFImebInncqQY2rDHOE6Mbqwpyx28N95QVLfkPKJ9GBPA/2fNqHGIo6qMu/+AqeKp3OJc8Z01azQYe+J0Lw2x+iVE1I2BqpyA=
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

This patch introduces CONFIG_ARCH_LAZY_MMU and has each arch select
it when it implements lazy_mmu helpers.
__HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
relies on the new CONFIG instead.

On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
selected. This creates some complications in arch/x86/boot/, because
a few files manually undefine PARAVIRT* options. As a result
<asm/paravirt.h> does not define the lazy_mmu helpers, but this
breaks the build as <linux/pgtable.h> only defines them if
!CONFIG_ARCH_LAZY_MMU. There does not seem to be a clean way out of
this - let's just undefine that new CONFIG too.

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
 mm/Kconfig                                         | 3 +++
 12 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6663ffd23f25..12d47a5f5e56 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -122,6 +122,7 @@ config ARM64
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
 	select ARCH_HAS_UBSAN
+	select ARCH_LAZY_MMU
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa89c2e67ebc..e3cbb10288c4 100644
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
index 7704dbe8e88d..623a8a8b2d0e 100644
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
index 7b527d18aa5e..a5e06aaf19cd 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -93,6 +93,7 @@ config PPC_BOOK3S_64
 	select IRQ_WORK
 	select PPC_64S_HASH_MMU if !PPC_RADIX_MMU
 	select KASAN_VMALLOC if KASAN
+	select ARCH_LAZY_MMU
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a630d373e645..59f17996a353 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -112,6 +112,7 @@ config SPARC64
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
+	select ARCH_LAZY_MMU
 
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
index fa3b616af03a..85de037cad8c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -804,6 +804,7 @@ config PARAVIRT
 config PARAVIRT_XXL
 	bool
 	depends on X86_64
+	select ARCH_LAZY_MMU
 
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index db1048621ea2..80b3b79a1001 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -11,6 +11,7 @@
 #undef CONFIG_PARAVIRT
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
+#undef CONFIG_ARCH_LAZY_MMU
 #undef CONFIG_KASAN
 #undef CONFIG_KASAN_GENERIC
 
diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index e7ea65f3f1d6..af74d09b68bc 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -24,6 +24,7 @@
 #undef CONFIG_PARAVIRT
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
+#undef CONFIG_ARCH_LAZY_MMU
 
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
index 32e8457ad535..124d5fa2975f 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -231,7 +231,7 @@ static inline int pmd_dirty(pmd_t pmd)
  * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
  * and the mode cannot be used in interrupt context.
  */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#ifndef CONFIG_ARCH_LAZY_MMU
 static inline void arch_enter_lazy_mmu_mode(void) {}
 static inline void arch_leave_lazy_mmu_mode(void) {}
 static inline void arch_flush_lazy_mmu_mode(void) {}
diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..2fdcb42ca1a1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1372,6 +1372,9 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config ARCH_LAZY_MMU
+	bool
+
 source "mm/damon/Kconfig"
 
 endmenu
-- 
2.47.0


