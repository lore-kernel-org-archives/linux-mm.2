Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627DD606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Kch0reNo
Received: by kanga.kvack.org (Postfix)
	id 736406B05C1; Tue, 17 Nov 2026 02:07:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DCF6B05C2; Tue, 17 Nov 2026 02:07:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCD46B05C3; Tue, 17 Nov 2026 02:07:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207EF6B05C1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E548160369
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:59 +0000 (UTC)
X-FDA: 85443728958.25.6B86774
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D303F180009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Kch0reNo;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GdWJ+4Id4z33+RoWCqd0KwoFHBmdUzYTQ6UQcKAIZM=;
	b=g6G/BjTlYZJcS9hLXEViuozjoTnFZQ8zlQWd+QqtTTfFnV8sZKPZA77NxNnHPoL+A8+Zul
	6vdyWF7cOy4DT+Rxf+GF1h3VdLO1Hpk+30GfW5WFlmkXKglIIWgJ4V4s4YuJ5t9Ivq8JF2
	qTN+ztqfp3q2vgJTELT/CdSGgySLhSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899218;
	b=muybkA7DiHFMahBak1oZ7HeEThTyc+NTOefD1gyeBOBmDqtMq7DH+xn7uojJpPf7o1eYro
	LzUHnHloK/BHR0g4Ilf95HTpoi8N2YiREqhj+soBTWgZDqFjnx/amaWn/QaGtD5kPATjfx
	8wXC7ZbUiwhlm0uve9hWt1QlX4i68HY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Kch0reNo;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 346C61688;
	Mon, 16 Nov 2026 23:06:54 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CB013F763;
	Mon, 16 Nov 2026 23:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899217; bh=BcOxWukpbMeXAwuC47qEZOmWBfEKNbcmLsaev3cliIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kch0reNo4Q2h3nyBQ5xywdpv0kiENciGUJ+jRq0GqOXdfGRhY50YvDZQZ1oPXlCH9
	 67h/6nf0obemjEZz19y+lW7xMyuLLRoSBu0jHJiSeFr2Jskyadvv2ypZ+98kDrOj2B
	 7MzaoXaES49DCijqF8ljJLGj04fguTo5GDLCHIIc=
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
Subject: [PATCH V3 09/14] arm64/mm: Enable 128 bit translation
Date: Tue, 17 Nov 2026 12:36:08 +0530
Message-ID: <20261117070613.1183243-10-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iy46u3t988wy9mgowbkn4mdr8zyqawjh
X-Rspam-User: 
X-Rspamd-Queue-Id: D303F180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794899217-731154
X-HE-Meta: U2FsdGVkX1+N8+mEfZG/daoHrOTjhhqYdF3lwpCE8thuiqmVlVzF7XvoDp+gYyDDEJ3c+qCZdZZvyLeKbTt9APoP9nsDoftO+sysjtRyKUcNtLuLV3dDCGlvk7cFxgQ6uzihoWUNgIsFz6/L3WDEtvzNVmptJUJ1zxvuj/uU23fbO+QPBqPcuJWCNg7k4lvGr2U4M9Sb8HiwfpSM82CkFdMbPRwgsAhTScAiZmloHAHW3wpG9qq4QAaaTv1EmE9PW5OvUFWkJmgv2v5SI/DWZIynN+nzkwaGjpt1dEcRExsTlYHzK96FX2ayN0lNfnOaQOEhPZX9bLx8SOoiGeNZqNmJm60B3wkfx8qVz6wXdOyuNOHQpJB7iljzp/lal4L9OVzm7M9l9V+L1U41mvpt/z9H+BQMWICRyl3+J7MrlGJjb5a5jlwRQ0gemfgGqJS1tVNIatlguiti3nM4smneeCR4A+weSvS5oW3cg6QaNuNO2DxpH8c7eLa1iAnUDaIYZ/u4JXx07mfaDTB38U9basvIUXloXC2z8Q3jP4lKOJClN89n0RF8Ld7rj3L7bm3H/XuuezLVdYZcPN446b3xVaPBSxinzspxNvpRa41iUQ5orzlLt/o5nNBGlgPxGSRpzZSb6bl32EzVN5k7yFCyJxBL4t5c2wriPmmLkrVRYVSTvvTQWJ2GRHolfPOzQWigp9PVz2bS1IE2QqA6MoQlfGw5aGH5X/q6GwYZR2fuTowjIdvefLVEoK1VW2uhlcTr4LYGAzF+ifndwvxB+SHwLW7sQMIwNOkrED4EteMq9tv/4RvcWnkX0To4pDQwvPf3RC1tJWkteTkoe8CFSHNHasTsnMuAK6pcZxuX8dA/pfxaqMgHFKlXX0/8SAiG19Y48f9MuJtEQCwSDGfZnv1PfAjZg15aV+EdGXQxcsUIih1seImc6CvNuH6gOvY8s+Xf1Mr6orIgQmiiIzlBz7Z
 DvbrMrrn
 tPJyz+dPKMOxm538XrMnaxJOHjXkDw7mMQ2fb55QCyp/+f38b9rYdEfj5MALiSGDSSa0Sq2orV1QYxvW2e3Sy9HwS3jNP1PeuYU7HiB+ol45kJaVhljXhpZqRynJMkT80fVr6gdG2YWXf+hPs0LbEZyJbG8MYV0wH5xUQNDNiinBZJsIW3iSnE749MR5O/4J/bM2MIPjcx5qwcli2hvhgLqH86coSBujbxeJZCyJHF/vy0PArcWkHKCwRM4999BUfGzMtFSTrqUT6NciMg68zxAnXTxSuZ3bcLX0BxMD5y0qae/uRlYNPkDWujmfhcINQ9e1GdqdMp5srH/PqcDTS9zyuJtA2nk8qxjtVwdUfFiXJDc4Kda60whiwwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index ed28f94be428e..ce4e3277bc28c 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -57,6 +57,10 @@ endif
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
index 12a5001812911..127356b1fdf43 100644
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
index 10ea4f5430690..1dd675d2b84d1 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -22,6 +22,7 @@
 
 #define CPU_STUCK_REASON_52_BIT_VA	(UL(1) << CPU_STUCK_REASON_SHIFT)
 #define CPU_STUCK_REASON_NO_GRAN	(UL(2) << CPU_STUCK_REASON_SHIFT)
+#define CPU_STUCK_REASON_NO_D128	(UL(3) << CPU_STUCK_REASON_SHIFT)
 
 #ifndef __ASSEMBLER__
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d6ba3c0af8119..8eaef9f01a3c2 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -504,6 +504,18 @@ SYM_FUNC_START_LOCAL(__no_granule_support)
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
index f590c81ef0c76..b93ad7a4366ba 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -576,7 +576,30 @@ alternative_else_nop_endif
 
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


