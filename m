Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B3DC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5FC6B014B; Wed, 29 Jul 2026 10:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F1C6B014C; Wed, 29 Jul 2026 10:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E706B014D; Wed, 29 Jul 2026 10:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 755FF6B014C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFCB980674
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:09 +0000 (UTC)
X-FDA: 85041736458.21.8B6CB66
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0314040007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ARmSwBGI;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4l4BnHw2qxdGwPOYqvmq1M1eVyFgdQYVQytkZNWLp0=;
	b=Pcl5W+g9eGIRZUerAbWyWwzzdBsSsF7mGU1UMudI0RK3uhFAyIJSblye0PNdnr7bvsJQ2F
	GHKA1ZIPbuE8MhUICQcoQ8eThPFat+qyeQY6bpBY6X8cIWvb/1hzNIxha8cRv8zNYiBnDg
	gJUh0j9McvlkjQ51YsDQdWJT8WgDQTo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ARmSwBGI;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327968;
	b=BWLNkaNqV9FQ9rVocG6oQbEq+NaUTQUtOGaHBBXo3UJLb7PMfLyvyUzVSUSS1biOI5wq2U
	od4O4iWlxxXhtzOJhRoFjS4N+FOcOT4K2h9y3v+xa0w3yCPTRKf+AEWJCv1z+RarjmFOIS
	JAdpyIAMyI+A9odNwboQtA2UQ10k7G4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EE001688;
	Wed, 29 Jul 2026 05:26:03 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 98C3B3F66F;
	Wed, 29 Jul 2026 05:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327967; bh=9pt9F5ahtzBd14pRQkxk5jUbTZPc89HybW3uEpB8nXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARmSwBGIrIjCTEepXWQvMyZHVXkAUESDhoa2ujc1AaA1CnmQ7bexwD4ti0KAPJMEM
	 TRKBTwFJ5EhUmuw6deN8IGfSU0Pd0uFAkLHBf65GI07C4mrnAEqGzzl2Y/Hh6mcqL0
	 bjgV3dzF5X+Ih/+wshUqRLsMTktj3pyW3cx3hiiE=
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
Subject: [PATCH 14/17] arm64/mm: Enable 128 bit translation
Date: Wed, 29 Jul 2026 17:54:49 +0530
Message-ID: <20260729122452.3797443-15-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0314040007
X-Rspam-User: 
X-Stat-Signature: qoetoh7346zf4mh7nmjppng5jrxzaw8w
X-Rspamd-Server: rspam04
X-HE-Tag: 1785327967-111607
X-HE-Meta: U2FsdGVkX1/6gSZdNdhv/cccP0MytaT6SdzkKfe8GQff2XQlFmqpd7/pKC5pE5IxaJe0i2Uz8lOZtpzKHYjkPw2Ar0G6N70wdPsAStZnDuzDuxbhsoB2H30F/LuKaySSMs4daLThunIk/BxqmAe6ESnKX7JAq23r72Rc04LOj2PB01Fk4speNUA6MT2wcaYVfy+bs7X4t6kpXIe8xdh2HsGJFu4dZny620gVRag4tcbuoNA/VVNY29dkSUZdpzb7TyjABSC/S7vOmlKliu/c7xdcJ1z/qUl27etmBrf9X3xgm3ZOzHUYXmO3KX4jdrYV/xi4iZ0MGXAP/aTUGZmlG4Zgyf28BQp4pj10KMJepYv7Hif9MT37OLwf6SX/lOPho9GEDxXF3MGJNQEvEoJcaH7c+wUSoqqW3KO8ogZCXqOkyRlZi08Pkqc1qM+Uz1+RRUoD+9QC/8QgWZlzvruDs8/GBnzz9ksrYU2DouSIpSmByOCqGLXGDYFttbt2UFohp4gkKq9N6rQExvZo4du0R1aGn4S3TXQbrOTUa3GnJmDnj4GshaOunGjxPgEzy6ij/zG30VNP1dCcqdzY7g+kZlF0JJI2Ma7yA6QJRLWXfwHf10pxM0XvmURub/b6xPQw0urATmuYz2nVrZ7m2y5lU42g7aqcaFuT6ETf8jASHsIK298/aINQT+o8kA68BUUz0SOXyQ9w9gH9OiI5bj9iBJLUy7MxRa0nmni38KCVkHfw6KvHexxoSNHgCQ0YBiHLyP1cHcVV81wse8FQ5Icr2l7qFWtyXvMRDae8P9nW3ZXFFCU8MyBNYjg11y4zGM36Qo581FupAQSSfuQs8IVMg0xVEfWvi/E1cb76l6zF52y93/M0drHXN1KnIydif6bwOFAo1hktjFiYAH/ETiuxTmDf0x7jJPB+chIbtv5TWBQUHxNNtxSk5kuZLNCs/ratdxLr0anj14ezoR5GH2U
 VoiWhhiY
 oorLv3pz2gZnawY5MMcn1ufiXqloVzAwmKbUbA3RBvYv51sTra1fVWXu6SVeUELf2m0BiyTw72/+OeAgoWSNcT4wGJPT/fWEcL99CebOY5G6Teiqry0JqFII7N3medwUjQ4+CM0ZFz5cJyxIy/redepSWQzyu14eBesXSkJW7ymhU1WQ8t+H5rQ+Zfincz9Q5C/YcfPaqem+WuHr7D4hgJpowve5wdeJ0kDyfPLlCcIcCqtnntDj2KMopDwZ67Ka8HZFAppy+bLqdgXt2BDrGrcGux78Wg/pO5HkE4wbwThDoDPirt9uCFDbgW7EgFt0PMZxvnRX79S2h86Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All required changes to page table geometry and descriptor are now in place
for D128 translation to be enabled.

Since FEAT_D128 exclusively supports the permission indirection style for
page table entry permission management, given kernel compiled for FEAT_D128
requires both FEAT_S1PIE and FEAT_D128. If these architecture features are
not present during boot, the kernel panics just like it does when there is
a granule size mismatch. So added a new stuck CPU debug identifier for such
scenarios called CPU_STUCK_REASON_NO_D128.

TTBR0/1_EL1 and PAR_EL1 registers become 128 bit wide when D128 is enabled,
thus requiring MSRR/MRRS instructions for their updates. Because PA_BITS is
still capped at 52 bits, MRS/MSR instructions are currently sufficient for
the register accesses that basically operate on the lower 64 bits. Although
entire 128 bits for these registers get cleared during boot via MSRR.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/Makefile                |  4 ++++
 arch/arm64/include/asm/el2_setup.h |  9 +++++++++
 arch/arm64/include/asm/smp.h       |  1 +
 arch/arm64/kernel/head.S           | 12 ++++++++++++
 arch/arm64/mm/proc.S               | 23 +++++++++++++++++++++++
 5 files changed, 49 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 6b005c8fef70..12a6e62520e9 100644
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
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..331e94381dd0 100644
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
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 10ea4f543069..1dd675d2b84d 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -22,6 +22,7 @@
 
 #define CPU_STUCK_REASON_52_BIT_VA	(UL(1) << CPU_STUCK_REASON_SHIFT)
 #define CPU_STUCK_REASON_NO_GRAN	(UL(2) << CPU_STUCK_REASON_SHIFT)
+#define CPU_STUCK_REASON_NO_D128	(UL(3) << CPU_STUCK_REASON_SHIFT)
 
 #ifndef __ASSEMBLER__
 
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
index 6db62d56e97e..5c8bfd56a781 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
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


