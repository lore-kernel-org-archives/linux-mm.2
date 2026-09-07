Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7516CC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001066B00AC; Sun,  6 Sep 2026 23:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B976B00AE; Sun,  6 Sep 2026 23:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8986B00AC; Sun,  6 Sep 2026 23:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A96A46B00AC
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A7F7A4B79
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:11 +0000 (UTC)
X-FDA: 85185590742.25.266E3B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93F4C140002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jIx0Z0Tr;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753069;
	b=j/35/jBs61Ep0E6/2nfge8mcV9Ee/+zf5suuVLEoAoE2JDUEy3YQPsoQtxUiRI2xpFgVPe
	3eHuF2tyQXk6c7GF3KknxZDG/TFAORxMwn+Lk5qHFyyb/oZfQz184gVdBAPNkgj7/7Hv+6
	AKjvfeOkchyv5+N4Ur8IWcQrHibvq+o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jIx0Z0Tr;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7km8gdPVOwm6xqW6+X3yEpvWjU6VGe44t3Rn37ZYL/0=;
	b=bHwUGbX8mg2tHUvOWuOD7FZN3woL6D+ntOX4Ryn0i3BNfeD0wk4rPshYwIInso04sQa6yE
	66qocPl0NhNvEI1TiTgEY1n2rw0vQGn/ZblUKPpkT5RiodUv1/u5Xo5yAQ2dPb5B1PtV2O
	Is5oiQaOchpF1MKNbicXop3RANi2XNQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B0A61477;
	Sun,  6 Sep 2026 20:51:05 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2245D3F7B4;
	Sun,  6 Sep 2026 20:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753068; bh=F6JIj5gZR+GM7/gf47zeVXEmc1PSYBWbUbC7eU2p0MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIx0Z0Trzn7fRx4Bb+jxB0bvIXRfkF/yODXZit+fDkD4wfxfzbJ6ESMOs/yxlG+tD
	 ocyhHabSN7XO3ZConckCDV5pFpYLcTCw7+ABBT+rpWgikPPLAVIuLZDnftBv0DDQYr
	 mM9nkrmbIRKmyQCUL7Ghe59JwOKma2OrowJnFZ4g=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 09/14] arm64/mm: Enable 128 bit translation
Date: Mon,  7 Sep 2026 09:20:24 +0530
Message-ID: <20260907035030.2839978-10-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yq4fquteup8in6nnmmu4shuk8jwp3b3b
X-Rspamd-Queue-Id: 93F4C140002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788753069-801210
X-HE-Meta: U2FsdGVkX19kiywVZlPokL0zu97v4P96hiN0B3jDWvQ0Myxt87hCrroyy5M8tFhDL6f/i6YE826hPurnn7/giQd5tiBU060V+8YwYYIh3g2ymlW/qxird+iyLdgj4cG03i5juCrh0kJ8lTa+aHbCVT5y7W66kcyGUKbvg4mp6USvLpwNssbTmUe4oYDx7ahPdZaol+OFdCwpchxyow1kDNcIBGM646ToQ24ITzm6B2Q84uwWSBWEhjA8kHeJLwhssjbFpRVLKmKLU+2Essgf1o/7hdP6IB2353+pPaLZV2qXI8oxXL/yX8Q/ZYupvit22XhhjZrrK7JXjSb6wm/0jQcc5oDZUR40UKUJhzcrHS0x6F5HbSiCHHNFiYIn8DzPhc8OEDXasv1qF0sUFb796sTzL/A/fawJ64PalcibuBAa6/SB+YGxP66FCg9Ehra2O+EcRdrfCbf4mqMghyeYGKP5W/D9R/3IP9BBsaIodN5nP4rZQ5Mpg+vBajN5z8+lC+Ayr36s5dEkyrHxjIzYsVFD90nnLov7zLmDVTUSICmfB7djzLEaQ5mm+SE8UuVGJ4DRszEfimsYXPWbU62TZIVMf4ldkaSlGDSz98LFdbTPir/A8Z4clonrMl3FFOEI0UHGS9wnfnm/nnLnIuM5AONBDENtYUUDauCynKXWiLWbRWfr9auwCPdXy0ll5e4ivfGQl06vcXQY3ERYWbuj+bpTNP9JXVjfQJBOESqjMYF1PKnSFwuz0TYUyCLZ4upk9jsYfdGMjLuxVIVbVXakSTezE6PDnVBfJKJ/zXERLQGaJjm4SRP+o75Qlyp0ICUKN+RA9yOk7TTn4COamgf1MbGm78mlWEmskV51Mm6kQHi17obsXYC2f4U1m9mnjRWTGE1SjTYVUhO+MktyjfFAUPuOmDQZLObuDoWHG1nTxu0s1YI7w7/apeQWpFrD0HqupxKDnAb6Pjme7kUgmpb
 nPMzkjxe
 oYLr8VZQ9DfmzPx0WHw8usuXZhaCWLno114zmH1TBmv3REQsA1GflPb66n4p1/V6X5kY9vYBYCmt5o25XXZGRTstzU+i4IgC1UIAyCF1ySZ7VhRvhssijyEnB+qs73sMN6GIpwTCcHZ5qFxcOlNePBRc4HX6MNfuSemvDgiaBOgtKa5k3miExtUkE00d+RAEw/pvNo9OJ0t8vtf5QXYUrTloXVQ3NKK88/V/6U/Z69gdzVBqfnCRW/vLyXFnlDcI2+1etzyAQ2v+OGz4N3TGas+IFHuHKq3iyaUdNlt17SJhAivC0ehSitjsI8coJE3cpfU59H/BVTtBULZCkAgwiXbdQoKRfh/rNVhTqX0bfKWIPN588UUlFXPZCNA==
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
index 4e8889961b15..faf16ffb0528 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -548,7 +548,30 @@ alternative_else_nop_endif
 
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


