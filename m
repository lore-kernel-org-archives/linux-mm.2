Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68207C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166946B008A; Fri, 25 Sep 2026 05:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117F36B008C; Fri, 25 Sep 2026 05:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005CD6B0092; Fri, 25 Sep 2026 05:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3836B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:54:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55450A6B25
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:54:01 +0000 (UTC)
X-FDA: 85251823482.20.E919DD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A1DEE1C0008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:53:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8ZDK5na;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iORfQRpdmua/2oyfl3m4bgYIdZbcptDocYCCchh5uWA=;
	b=PxsMb3THwlrqGmLjJV4LwmBQdWoHhOmBbPDQxqZ0afg+1G5xZfTqIw8lgPcDalGYpmWSyC
	bnOvBWZlKA/mCTNYokakksFXyoxfN9YILL5x94W9rh+prA1ZGu3Pggp52nIZGybDssVYKQ
	CU9x1aXl5F+WifSyOy2a8LDrUG3Ktwg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330039;
	b=w3hrcu2SU3otRhU1KA6AKszvhZ59xhXNud2T1BK93+uiLINiKpEMb9R8M4Ljz1g1NDSpIF
	4Rfe7Usp32tlTLgcrY0+t0P6Vx2xHz8WNnZYUB0USIoj3k9wNZ6VCv7/BuABh++lpyc9kd
	iEpEqJVBOSw92q8QY17bcksXmeH0AK8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8ZDK5na;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6B6460136;
	Fri, 25 Sep 2026 09:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C441F000FF;
	Fri, 25 Sep 2026 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330038;
	bh=iORfQRpdmua/2oyfl3m4bgYIdZbcptDocYCCchh5uWA=;
	h=From:Date:Subject:To:Cc;
	b=N8ZDK5na50t75eghfhmiqS84rEozeKaa+Y705ZwXDElfCfEO8kelojddF3v9bI1ao
	 WWyIU1YDFv3Q/Cqju0XM79MZrKS+YLVxXalw0plxWsjAQNyJQyg1R4DggMrGm+nwYI
	 7mn2dGgMYErdNIdr6UvQk2DZA9laazpOHY5Da5BZkomc+GcmjTcmitOGLqK7/dhjKu
	 G8hMN60PdMXKYZeJh8qw2XJBbtzhYEK4NEsJwLrMuxyewrx3VOfaxkwDYScoEDh9/z
	 P0r706kxkFDL4t7tnrM8Xa6Ylk2cBDlvarn3LyrS+8dUa2ydup3rcdM4BtuxmKreXw
	 /yU+vvTdwBkRw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Fri, 25 Sep 2026 12:53:46 +0300
Subject: [PATCH] arch, mm: promote DEBUG_WX to CHECK_WX
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMyw6CMBBFf4XM2om0iVL8FeOijwHGhEKmiBjCv
 9vq8tzcc3ZIJEwJbtUOQisnnmIGdarADzb2hBwyg671tW71BQML+QVHO+Oa1e6D7w2dUS5Y07S
 NUZDVWajj7Ze9P/6cXu6ZxdIqD2cToRMb/VCmSbjneB5tWkjgOL4gIN0ImAAAAA==
X-Change-ID: 20260925-direct-map-verify-wx-b81bda879781
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Suren Baghdasaryan <surenb@google.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Vasily Gorbik <gor@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Stat-Signature: cqxsus94b5uhypn5qadcfyb8yjnm1x36
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A1DEE1C0008
X-HE-Tag: 1790330039-9059
X-HE-Meta: U2FsdGVkX189eFJ30kuB1889zBT6FTfc7DiK/o+0ux3dSP+5c8CaBgKKNAkOqGwvzFueFNYDNtaYDRs3FA7yJa2+/FLWYdwCp1sfIyrqcxg2xu7KOFBsYWKl5UCn0w2rA/GX9MNdON6ajmIo0+NCmoCyGbDA9EQWjDqcAQP+ldcuZ/TGyqQGLVi007UbJxtrGz6gqfFmi1i7hsESlua959pIToDs22eOUd1xxGRIPU+mg4Tfhx5NyoP/0R3m0YzVsX2U3rRcCQhYusxEOtn5Vy44XxiyUTvVS+up+8oTlXXYWofTy12V3M2U8iAlA0LQDQtb574D6ZaYnF6uk/64FWUwOqkx96Mn3YppAhwuL61L9iK2S8+XX/cRn9c6RL0eDAlzCcZMjBwcoFk0AOnCN+aK22rTsMMDQwEngajfa23SeQhI87oyThrgT5hHhoFSSBQdX7lYR4NL1IGCU5JqtHEweguMNSTH+wFjw0gbcuzxXF2+6lLNAu03xBnbt+fhHQMWfBTu3K14kiuHaxHWO+yk1NBKrt7RdP7gMOZG6YorchEloREjov5q26HRjWlqcwSkp9+tOpLGdhjZF4SNPx2J9AfYbAfA2p3dLVP/PG+DGRwai9YMZdDG1cYYck54XpKF4blaUDBL2lr7WP1zbJXoRbgNLxE9HQOhYapim3o1vdj268nJquP1u43WxMdziOjjNmxlQKMFRbgh64SEbuGdVT9xDSvExAtco3V8sw3VrPEBMR051zFfvwh6tXTIcGO/HDYy+jzDlpY+AEAE2GUHMfYMDq6ItkdEIJxskqhunFesOV7YJ71fs/8JW0r7aUUYJ++8zjZMFAm5NM7YsWlutId+BJGwHjNSG5gwHkgig9ZRHL41RWEAd2y8u5I+vR9wRE46+cLOKqa6bX1eLLU6gccmXpGRVs1UdJj71GqyjPSdVmFFnFIOMTgc2d5mFbviVZtCFkvdacM2xfu
 +KMDLlyY
 SmMtH1qMllYCoZ/I2KjB7qrBKWSUEO41sG4cYRDGUZr1oDWfE28HURbm9KoKIwf+NUqbDOuO7pdiip/b7+uAy3pOrUwPTfUBczxkywwuFRaFN5cmo0b4wsanJM3pZy14gtIsGGzPOW4jzd6I/cM0t9WDxRjpdz68U04kHjtockHpVm3W03XC4B9tco0yyuvH4I/xgHRviPwBIU2eWYJIEEOOSIVFKrWyCUaRGUr7eyfLM+NDohNtm+Ug20e/57+pCN+7q9dWWL8wdx2l7CV9LbNm8tGR5ABEq3SfsfNIa85vO03xOqLxm4S2/OXuwyWOtUqSuZEFOO2ZYJ3OyKfRdjUIU5KyFB8T3OzVq1b/64mU//DEQgcRzDtztk5LsiJY3PoZ9WQRlWuv3AtPucFHnwB4OgVKfr4GvdH9TAxsFFZo43xUYAo987PKmddthk87jmrpr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verification that the kernel does not have writable + executable
mappings is about detecting security risks rather than a pure debug
feature.

Major distribution configurations enable it in their kernels as well as
defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.

Rename relevant generic configuration options to use CHECK_WX and move
their definitions from mm/Kconfig.debug to mm/Kconfig.

For arm that does not widely enable it, only rename its variants of the
config options.

Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
the added size can be slightly reduced with churny updates of
architecture implementations of ptdump, the core functionality takes
most of the added size. It cannot be moved to .init.text because the
verification has to happen after init sections are freed.

With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
still leaving users targeting small kernels the possibility to opt-out.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm/Kconfig.debug               |  2 +-
 arch/arm/configs/aspeed_g4_defconfig |  2 +-
 arch/arm/configs/aspeed_g5_defconfig |  2 +-
 arch/arm/configs/shmobile_defconfig  |  2 +-
 arch/arm/include/asm/ptdump.h        |  2 +-
 arch/arm64/Kconfig                   |  2 +-
 arch/powerpc/Kconfig                 |  2 +-
 arch/powerpc/configs/ppc64_defconfig |  2 +-
 arch/powerpc/mm/ptdump/ptdump.c      |  2 +-
 arch/riscv/Kconfig                   |  2 +-
 arch/s390/Kconfig                    |  2 +-
 arch/s390/configs/debug_defconfig    |  2 +-
 arch/s390/configs/defconfig          |  2 +-
 arch/s390/mm/dump_pagetables.c       |  2 +-
 arch/x86/Kconfig                     |  2 +-
 arch/x86/configs/x86_64_defconfig    |  2 +-
 arch/x86/include/asm/pgtable.h       |  2 +-
 include/linux/ptdump.h               |  2 +-
 kernel/configs/debug.config          |  2 +-
 mm/Kconfig                           | 41 ++++++++++++++++++++++++++++++++++++
 mm/Kconfig.debug                     | 39 ----------------------------------
 21 files changed, 60 insertions(+), 58 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 366f162e147d..abcf14f10276 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -17,7 +17,7 @@ config ARM_PTDUMP_DEBUGFS
 	  kernel.
 	  If in doubt, say "N"
 
-config ARM_DEBUG_WX
+config ARM_CHECK_WX
 	bool "Warn on W+X mappings at boot"
 	depends on MMU
 	select ARM_PTDUMP_CORE
diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
index f86dd4ce7d0d..2c9d5a644ae9 100644
--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -249,7 +249,7 @@ CONFIG_DEBUG_INFO_REDUCED=y
 CONFIG_GDB_SCRIPTS=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
-CONFIG_ARM_DEBUG_WX=y
+CONFIG_ARM_CHECK_WX=y
 CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_PANIC_TIMEOUT=-1
diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index 45b937419dbd..1327a09e163a 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -300,7 +300,7 @@ CONFIG_DEBUG_INFO_REDUCED=y
 CONFIG_GDB_SCRIPTS=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
-CONFIG_ARM_DEBUG_WX=y
+CONFIG_ARM_CHECK_WX=y
 CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_PANIC_TIMEOUT=-1
diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
index 6f9696e9fe17..cc22e22b989e 100644
--- a/arch/arm/configs/shmobile_defconfig
+++ b/arch/arm/configs/shmobile_defconfig
@@ -225,4 +225,4 @@ CONFIG_CMA_SIZE_MBYTES=64
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_FS=y
-CONFIG_ARM_DEBUG_WX=y
+CONFIG_ARM_CHECK_WX=y
diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
index 46a4575146ee..5039cb75fb53 100644
--- a/arch/arm/include/asm/ptdump.h
+++ b/arch/arm/include/asm/ptdump.h
@@ -32,7 +32,7 @@ void ptdump_check_wx(void);
 
 #endif /* CONFIG_ARM_PTDUMP_CORE */
 
-#ifdef CONFIG_ARM_DEBUG_WX
+#ifdef CONFIG_ARM_CHECK_WX
 #define arm_debug_checkwx() ptdump_check_wx()
 #else
 #define arm_debug_checkwx() do { } while (0)
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..7e120fb21c58 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -11,7 +11,7 @@ config ARM64
 	select ACPI_MCFG if (ACPI && PCI)
 	select ACPI_SPCR_TABLE if ACPI
 	select ACPI_PPTT if ACPI
-	select ARCH_HAS_DEBUG_WX
+	select ARCH_HAS_CHECK_WX
 	select ARCH_BINFMT_ELF_EXTRA_PHDRS
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2580e27e4328..7c1fe5b4cd41 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -130,7 +130,7 @@ config PPC
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
-	select ARCH_HAS_DEBUG_WX		if STRICT_KERNEL_RWX
+	select ARCH_HAS_CHECK_WX		if STRICT_KERNEL_RWX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_MAP_DIRECT 		if PPC_PSERIES
 	select ARCH_HAS_DMA_OPS			if PPC64
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 1eb8e3457e8b..5c33f0bba0e3 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -393,7 +393,7 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_PAGE_OWNER=y
 CONFIG_PAGE_POISONING=y
 CONFIG_DEBUG_RODATA_TEST=y
-CONFIG_DEBUG_WX=y
+CONFIG_CHECK_WX=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_DEBUG_VM=y
 # CONFIG_DEBUG_VM_PGTABLE is not set
diff --git a/arch/powerpc/mm/ptdump/ptdump.c b/arch/powerpc/mm/ptdump/ptdump.c
index 0d499aebee72..3451351b756b 100644
--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -191,7 +191,7 @@ static void note_prot_wx(struct pg_state *st, unsigned long addr)
 	if (!pte_write(pte) || !pte_exec(pte))
 		return;
 
-	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
+	WARN_ONCE(IS_ENABLED(CONFIG_CHECK_WX),
 		  "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",
 		  (void *)st->start_address, (void *)st->start_address);
 
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d6c2dbf8455c..05e33d4d5efa 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -29,7 +29,7 @@ config RISCV
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEBUG_VM_PGTABLE
-	select ARCH_HAS_DEBUG_WX
+	select ARCH_HAS_CHECK_WX
 	select ARCH_HAS_DELAY_TIMER
 	select ARCH_HAS_ELF_CORE_EFLAGS if BINFMT_ELF && ELF_CORE
 	select ARCH_HAS_FAST_MULTIPLIER
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 4b51bc6e8948..11b76f2b0f80 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -92,7 +92,7 @@ config S390
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
-	select ARCH_HAS_DEBUG_WX
+	select ARCH_HAS_CHECK_WX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_OPS if PCI
 	select ARCH_HAS_ELF_RANDOMIZE
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 3dae71474333..68d53c0bc8db 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -841,7 +841,7 @@ CONFIG_DEBUG_PAGEALLOC=y
 CONFIG_SLUB_DEBUG_ON=y
 CONFIG_PAGE_OWNER=y
 CONFIG_DEBUG_RODATA_TEST=y
-CONFIG_DEBUG_WX=y
+CONFIG_CHECK_WX=y
 CONFIG_PTDUMP_DEBUGFS=y
 CONFIG_DEBUG_OBJECTS=y
 CONFIG_DEBUG_OBJECTS_SELFTEST=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 6f5722634b4d..8e5cfc695121 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -820,7 +820,7 @@ CONFIG_DEBUG_INFO_DWARF4=y
 CONFIG_GDB_SCRIPTS=y
 CONFIG_DEBUG_SECTION_MISMATCH=y
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_WX=y
+CONFIG_CHECK_WX=y
 CONFIG_PTDUMP_DEBUGFS=y
 CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_PANIC_ON_OOPS=y
diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
index 89badbe72ae7..a23a0bd4d8a8 100644
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -86,7 +86,7 @@ static void note_prot_wx(struct pg_state *st, unsigned long addr)
 	 */
 	if (addr == PAGE_SIZE && (nospec_uses_trampoline() || !cpu_has_bear()))
 		return;
-	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
+	WARN_ONCE(IS_ENABLED(CONFIG_CHECK_WX),
 		  "s390/mm: Found insecure W+X mapping at address %pS\n",
 		  (void *)st->start_address);
 	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..170cfcb06174 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -110,7 +110,7 @@ config X86
 	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN
-	select ARCH_HAS_DEBUG_WX
+	select ARCH_HAS_CHECK_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAVE_EXTRA_ELF_NOTES
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 269f7d808be4..e6896aeb77d8 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -263,7 +263,7 @@ CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_WX=y
+CONFIG_CHECK_WX=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_SCHEDSTATS=y
 CONFIG_BLK_DEV_IO_TRACE=y
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d551120a7c88..16f4e8ddda65 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -41,7 +41,7 @@ void ptdump_walk_user_pgd_level_checkwx(void);
 #define pgprot_encrypted(prot)	__pgprot(cc_mkenc(pgprot_val(prot)))
 #define pgprot_decrypted(prot)	__pgprot(cc_mkdec(pgprot_val(prot)))
 
-#ifdef CONFIG_DEBUG_WX
+#ifdef CONFIG_CHECK_WX
 #define debug_checkwx_user()	ptdump_walk_user_pgd_level_checkwx()
 #else
 #define debug_checkwx_user()	do { } while (0)
diff --git a/include/linux/ptdump.h b/include/linux/ptdump.h
index 240bd3bff18d..acc51a85652c 100644
--- a/include/linux/ptdump.h
+++ b/include/linux/ptdump.h
@@ -33,7 +33,7 @@ bool ptdump_check_wx(void);
 
 static inline void debug_checkwx(void)
 {
-	if (IS_ENABLED(CONFIG_DEBUG_WX))
+	if (IS_ENABLED(CONFIG_CHECK_WX))
 		ptdump_check_wx();
 }
 
diff --git a/kernel/configs/debug.config b/kernel/configs/debug.config
index 307c97ac5fa9..ac878669c193 100644
--- a/kernel/configs/debug.config
+++ b/kernel/configs/debug.config
@@ -50,7 +50,7 @@ CONFIG_DEBUG_NET=y
 # CONFIG_DEBUG_PAGEALLOC is not set
 # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
 # CONFIG_DEBUG_RODATA_TEST is not set
-# CONFIG_DEBUG_WX is not set
+# CONFIG_CHECK_WX is not set
 # CONFIG_KFENCE is not set
 # CONFIG_PAGE_POISONING is not set
 # CONFIG_SLUB_STATS is not set
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..ffbc641cc31f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1511,6 +1511,47 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config ARCH_HAS_CHECK_WX
+	bool
+
+config CHECK_WX
+	bool "Warn on W+X mappings at boot"
+	default STRICT_KERNEL_RWX
+	depends on ARCH_HAS_CHECK_WX
+	depends on ARCH_HAS_PTDUMP
+	depends on MMU
+	select PTDUMP
+	help
+	  Generate a warning if any W+X mappings are found at boot.
+
+	  This is useful for discovering cases where the kernel is leaving W+X
+	  mappings after applying NX, as such mappings are a security risk.
+
+	  Look for a message in dmesg output like this:
+
+	    <arch>/mm: Checked W+X mappings: passed, no W+X pages found.
+
+	  or like this, if the check failed:
+
+	    <arch>/mm: Checked W+X mappings: failed, <N> W+X pages found.
+
+	  Note that even if the check fails, your kernel is possibly
+	  still fine, as W+X mappings are not a security hole in
+	  themselves, what they do is that they make the exploitation
+	  of other unfixed kernel bugs easier.
+
+	  There is no runtime or memory usage effect of this option
+	  once the kernel has booted up - it's a one time check.
+
+	  If in doubt, say "Y".
+
+config ARCH_HAS_PTDUMP
+	bool
+
+config PTDUMP
+	bool
+
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 15dca19dd07d..75b44e4a6e36 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -180,45 +180,6 @@ config DEBUG_RODATA_TEST
 	help
 	  This option enables a testcase for the setting rodata read-only.
 
-config ARCH_HAS_DEBUG_WX
-	bool
-
-config DEBUG_WX
-	bool "Warn on W+X mappings at boot"
-	depends on ARCH_HAS_DEBUG_WX
-	depends on ARCH_HAS_PTDUMP
-	depends on MMU
-	select PTDUMP
-	help
-	  Generate a warning if any W+X mappings are found at boot.
-
-	  This is useful for discovering cases where the kernel is leaving W+X
-	  mappings after applying NX, as such mappings are a security risk.
-
-	  Look for a message in dmesg output like this:
-
-	    <arch>/mm: Checked W+X mappings: passed, no W+X pages found.
-
-	  or like this, if the check failed:
-
-	    <arch>/mm: Checked W+X mappings: failed, <N> W+X pages found.
-
-	  Note that even if the check fails, your kernel is possibly
-	  still fine, as W+X mappings are not a security hole in
-	  themselves, what they do is that they make the exploitation
-	  of other unfixed kernel bugs easier.
-
-	  There is no runtime or memory usage effect of this option
-	  once the kernel has booted up - it's a one time check.
-
-	  If in doubt, say "Y".
-
-config ARCH_HAS_PTDUMP
-	bool
-
-config PTDUMP
-	bool
-
 config PTDUMP_DEBUGFS
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL

---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260925-direct-map-verify-wx-b81bda879781

--
Sincerely yours,
Mike.


