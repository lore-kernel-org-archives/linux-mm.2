Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419E7C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D918E00C7; Thu, 24 Jul 2025 19:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D78D8E007C; Thu, 24 Jul 2025 19:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7536B8E00C7; Thu, 24 Jul 2025 19:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 569738E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CACD14056E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:29 +0000 (UTC)
X-FDA: 83700772218.04.8F92809
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E92C100005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=dk9JMCDI;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cR/QY88sdxyw3B/3rrgSlLa8+7hhea91nQDWrYR/AlU=;
	b=a89E1FFB8H5tqUjQggWJWm9K6oG7I+O8uYQvHldm9/dcYBeQmYuuiGZChGzHjdL6pshwHz
	RMTTZzaCw56i+/gkiTAP0bbhpj7EBHNB7B82xkoO3zKYyMmOE/jJCZ16dTAacvkthDR0wi
	Dzz06YjJodA2LozcE31hTMWLi5WSQIo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=dk9JMCDI;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400247; a=rsa-sha256;
	cv=none;
	b=J0rC5HQBVrab4CnVfu0gHN3HcMun8QW5nsTJ8bl4SQyc/N+jzu1oSLV5a0lP1tnKHj9a0I
	WzpXTuVRVH05JCKsZCBHioKKcpZwuzfuReE190MWEKmrtbDpuMdQ/5IGQ03MpAND/tgvzn
	JUSwiCmOpNEmn3eA6qpgnL8z84H2Sh4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-235ea292956so14161615ad.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400246; x=1754005046; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cR/QY88sdxyw3B/3rrgSlLa8+7hhea91nQDWrYR/AlU=;
        b=dk9JMCDIVs742TgJo97XKFIYSSEIQnEVKIBBx2sFgD5lo4YZIzEwP+4fU6nY3Xpw0s
         CtJBZsmlX0UQzUFA9hk4dcGGXdEe/JHjVpLrVtMP8Xbuc5tNW0ZzqQngIV3CLJUhNEBO
         jVJfq0zan465UqA5X95NXIcIICTEWnWaRoKI3ol6MVqNiyBwVEJpHgOBi/VFfu6bCeI0
         UwOA4AQbM96izY8YrCNmZl1dzhH+eBa+3WLpzFZl6iimh/rAex6GBZMbc7O6Z2HccH4p
         tTsn6Es1KEhaYXl8pRiqeLsfSK7lX6V7SkMnXnxvv+TLyeF9maqofBjV1fbYf8fJPlPx
         Q9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400246; x=1754005046;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cR/QY88sdxyw3B/3rrgSlLa8+7hhea91nQDWrYR/AlU=;
        b=xUg64VUKBI8HcyTlwT3BrrPNGsv2nXPC9Hk4UN6FolAHWol9Z0jQ8RkrSHqPeYIPJy
         d+uFDmX2VJG5LFHkcRK8HCHrkiVsSOo2/v/dlyEMbWSlR/ry6fkhWE/B6wQ4q15pQVBB
         oCIBTKRDn5GPFHmNbEPXPsSQsGu0wDfPs2OFhspnmG8mfb7DBDLklJ7YBFExoPMQJT2r
         13n0kYY1TQFLumX2qo/b8bn0+2hNiuIYAqINsKJdYA8PMN021MJ7h902NJe6dd5hXn0N
         Soul7DYVDhjDRRFrs6URxZOz99m+MWkD3d2ZQftw6GG1f3f1aRPfvGt6yx+oW0aUxz05
         iX0A==
X-Forwarded-Encrypted: i=1; AJvYcCUItlEPCrxIAZbM0nodKMZs+LERXaKQR32TB6epLt0fys11GOvOr+KReolvoX6Tu94mucTlIJVj1w==@kvack.org
X-Gm-Message-State: AOJu0YyBJziU9JfMFMFytHZdaRW2vM3PNPYrS8Y0Se7MPB8W2e+rIqmk
	pbrX0wqeA41+QR1DhNcMUGWSWL7tMA/fsmS0GfCkAueBwwApXOM47sY5O+Xo3tQ0mANWMlBISIV
	iteOJ
X-Gm-Gg: ASbGncu75AXmY9QZOwj6l4bHQ1WU/vOmmHYW9maQX40YgNq7DnSx6Q6S0ZB7cWdOvjg
	CIHMwdpa2aCi/RdZwyJKGDGrJb21YdT8yFnC5pzJqWeFKMxtTPQzCmBySdCxJsUas8Hvyw5XwvW
	zvorwO2+dzblzZ9oAbHgdpU0QSEFDSdTtFwipIt7tMbSPZFhiRq5TuhEmfcE6Vk2xj6A69iyhWz
	sISwcxAhpH/TNUu/l7CdIrMS5HMjnhyTKqDSJ++CsQUsGUWrVIP6w1Nh5ZDNYkBFgFTEb6+Heee
	iFC7c5Jiy5kkQ8e8MzEOp85FAWxyVMU7uz/597fpUAASQQLXJCdMnrUtnF0VmRHyF38QMatrJzL
	rFBL+nel5om3cK13ypXBIN/DQOoYq7ImH
X-Google-Smtp-Source: AGHT+IFpPmZfsrgw5MGLmfyvQ9TeyCoMqEZ9ePbdOyQJB+JX01/i58SgR22VLSNFSyWsuZBztHnwLA==
X-Received: by 2002:a17:902:ce01:b0:235:1706:2002 with SMTP id d9443c01a7336-23f98083375mr117426355ad.0.1753400245784;
        Thu, 24 Jul 2025 16:37:25 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:25 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:37:02 -0700
Subject: [PATCH 09/11] riscv: scs: add hardware shadow stack support to scs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-9-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 37ksmqenkmt4g7egqjcaqyufmh1xn6ez
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E92C100005
X-Rspam-User: 
X-HE-Tag: 1753400247-87039
X-HE-Meta: U2FsdGVkX1/f/BXQ+6YkZrnnrzuRDvCUi0OTP12wQ0TzxlavPHDhIBP3K67G9BzdbBYJeF6kP5h3v1r6i28HsxI6JUjyPD37Ziqq5MxjgIvB6/jDf1UyRnwEDi2KVhe4rQBfHDCCmXVztonJnSlicvBLlYWrvKHfSdRUlnTle1QTPwZYp7r9p3U0zX2JcBTJgkXmrOBMADA+ArzVLcWGmdzkCkWA6UZ8nOlf86mh0OqK9Jlf9krPjLjTUBCTCTu3v4Uw9o2J3r7qqYqgDSAsHAtm5p3qJJTZ89z12UG+n1egE1zI+HNo5HVAqOo18HuEC1Q42UQxRRFK5L+A2DTSPiKmvtprsPEnNJh1aVQY/NCNCp3+2hqS0qdARCI3MsiVplqxg69fq7Bu05BRlDUXTgdVujZgGze/eAJzg3L1IrTatPxAHK7MWbGWu238EANziCSbH8qr39szPwTs5PSJ6HzHsIAiEvabcZkNxtPueKv2X1sbh40/jwup2hd+pF8FVFzZFEY0dHjhNJxU8rmvR9feNNj3LfYxQ2mLinSl9dSPgg/FFPdP91cCwudOZIYC0XGOwDUQVH4lkRm9TlFGxkAa2ghkhqx8F5AYp2M2/vduU3LGtSQbGziUCjk9zdT26wB2x5XkVkqWYMWJG8a5onYR1ONtAflL2IgjgZf+MEE09QJhKaoDzqZ6k9yugxugvuwtDD/mkvJxxbvdbNeAi8ULXAjM7jwsrl/2oFABRHdglrOwLL1hnq3oDxtN+VPCU0PhXe+5ep/N3JAUFW1h6LzN8wfRSjHtobBkhv+2TGK6GzWKhEQ74KCANyM+zjGyxWuj8TjL3fx0pOMAUG+kVSGe0lsQmHa0tfsqt91SmmEEXLgA6WXC8DAlPdvTjd1X3PjhIu8m+FPilrc4BFbc7P9fg/t4vkK3NrgGMe1ISs9wNQNRUjDgkhJTDwAL/9pg+TC1Da3NXUwfyZsZ3d0
 vWoh09qp
 Xd6ctiJCDeRs1G/lSk1OwMDGFEW38U9jyjm2ySgxrKbcm5XmculSKwmgpNwGLHofXD3RD/fTlJeawTLK4xipWHHUbANzJ3RP5tFp5a3ir8J5QNaBH4EwVKygl2ijCIf0rVqsHg39wybWtePmAr4GpAoVLVn2fyvbGAXbvhu/oP2vatGGnBMTaZ5YOBX4J4HgEupTeiRmhEwnC7ZvX5BM4ynL1wUZGLbAUyUBr+swmzP+HreMAJWScO+xnx8O8MgaAGbhg+ugMERv5wfmC1anMECk3IN2HXYMhrE2KcfQoR4xAFL3vlB7IBwcrYWaTfqSekqbfxJlZz6rRrfRmUOEgsEBzAG5aULkeXF0Sv6XFTOvu5T8NSYgg9g5TJdKR38JjuJZMeLbcOrrYvodxez6v/2x2tC2kw3xJUyXG5F9JpW98dXtK18ZUmreG7BgLH9n+CNG/2qQ2tolTGr0grrVz0ZCyyzj+Hn8KCFRxFn2Rcjes+bbvphtFB8fvjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding support for hardware support for shadow call stack on riscv. This
patch enables scs_* macros to use zicfiss shadow stack pointer (CSR_SSP)
instead of relying on `gp`.

Since zicfiss based shadow stack needs to have correct encoding set in PTE
init shadow stack can't be established too early. It has to be setup after
`setup_vm` is called. Thus `scs_load_init_stack` is noped out if
CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK is not selected.

Adds `arch_scs_store` that can be used in generic scs magic store routine.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/asm.h |  2 +-
 arch/riscv/include/asm/scs.h | 48 +++++++++++++++++++++++++++++++++++---------
 arch/riscv/kernel/entry.S    | 14 ++++++-------
 arch/riscv/kernel/head.S     |  4 ++--
 4 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index a8a2af6dfe9d..256aff523dd4 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -110,7 +110,7 @@
 	REG_L \dst, 0(\dst)
 .endm
 
-#ifdef CONFIG_SHADOW_CALL_STACK
+#if defined(CONFIG_SHADOW_CALL_STACK) && !defined(CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK)
 /* gp is used as the shadow call stack pointer instead */
 .macro load_global_pointer
 .endm
diff --git a/arch/riscv/include/asm/scs.h b/arch/riscv/include/asm/scs.h
index 0e45db78b24b..e70e6ef14bc5 100644
--- a/arch/riscv/include/asm/scs.h
+++ b/arch/riscv/include/asm/scs.h
@@ -9,46 +9,76 @@
 
 /* Load init_shadow_call_stack to gp. */
 .macro scs_load_init_stack
+#ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
 	la	gp, init_shadow_call_stack
 	XIP_FIXUP_OFFSET gp
+#endif
 .endm
 
 /* Load the per-CPU IRQ shadow call stack to gp. */
-.macro scs_load_irq_stack tmp
+.macro scs_load_irq_stack tmp tmp1
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	load_per_cpu \tmp1, irq_shadow_call_stack_ptr, \tmp
+	li \tmp, 4096
+	add \tmp, \tmp, \tmp1
+	csrw CSR_SSP, \tmp
+#else
 	load_per_cpu gp, irq_shadow_call_stack_ptr, \tmp
+#endif
 .endm
 
 /* Load task_scs_sp(current) to gp. */
-.macro scs_load_current
+.macro scs_load_current tmp
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	REG_L	\tmp, TASK_TI_SCS_SP(tp)
+	csrw CSR_SSP, \tmp
+#else
 	REG_L	gp, TASK_TI_SCS_SP(tp)
+#endif
 .endm
 
 /* Load task_scs_sp(current) to gp, but only if tp has changed. */
-.macro scs_load_current_if_task_changed prev
+.macro scs_load_current_if_task_changed prev tmp
 	beq	\prev, tp, _skip_scs
-	scs_load_current
+	scs_load_current \tmp
 _skip_scs:
 .endm
 
 /* Save gp to task_scs_sp(current). */
-.macro scs_save_current
+.macro scs_save_current tmp
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	csrr \tmp, CSR_SSP
+	REG_S	\tmp, TASK_TI_SCS_SP(tp)
+#else
 	REG_S	gp, TASK_TI_SCS_SP(tp)
+#endif
 .endm
 
 #else /* CONFIG_SHADOW_CALL_STACK */
 
 .macro scs_load_init_stack
 .endm
-.macro scs_load_irq_stack tmp
+.macro scs_load_irq_stack tmp tmp1
 .endm
-.macro scs_load_current
+.macro scs_load_current tmp
 .endm
-.macro scs_load_current_if_task_changed prev
+.macro scs_load_current_if_task_changed prev tmp
 .endm
-.macro scs_save_current
+.macro scs_save_current tmp
 .endm
 
 #endif /* CONFIG_SHADOW_CALL_STACK */
 #endif /* __ASSEMBLY__ */
 
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+#define arch_scs_store(ss_addr, magic_val)	do {				\
+	asm volatile ("ssamoswap.d %0, %2, %1"					\
+					: "=r" (magic_val), "+A" (*ss_addr)	\
+					: "r" (magic_val)			\
+					: "memory");				\
+	} while (0)
+#else
+#define arch_scs_store(ss_addr, magic_val) do {} while (0)
+#endif
+
 #endif /* _ASM_SCS_H */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 3f0890b9c0b9..800a5ab763af 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -199,7 +199,7 @@ SYM_CODE_START(handle_exception)
 	load_global_pointer
 
 	/* Load the kernel shadow call stack pointer if coming from userspace */
-	scs_load_current_if_task_changed s5
+	scs_load_current_if_task_changed s5 t0
 
 #ifdef CONFIG_RISCV_ISA_V_PREEMPTIVE
 	move a0, sp
@@ -260,7 +260,7 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	REG_S s0, TASK_TI_KERNEL_SP(tp)
 
 	/* Save the kernel shadow call stack pointer */
-	scs_save_current
+	scs_save_current t0
 
 	/*
 	 * Save TP into the scratch register , so we can find the kernel data
@@ -382,8 +382,8 @@ SYM_FUNC_START(call_on_irq_stack)
 	addi	s0, sp, STACKFRAME_SIZE_ON_STACK
 
 	/* Switch to the per-CPU shadow call stack */
-	scs_save_current
-	scs_load_irq_stack t0
+	scs_save_current t0
+	scs_load_irq_stack t0 t1
 
 	/* Switch to the per-CPU IRQ stack and call the handler */
 	load_per_cpu t0, irq_stack_ptr, t1
@@ -393,7 +393,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	jalr	a1
 
 	/* Switch back to the thread shadow call stack */
-	scs_load_current
+	scs_load_current t0
 
 	/* Switch back to the thread stack and restore ra and s0 */
 	addi	sp, s0, -STACKFRAME_SIZE_ON_STACK
@@ -440,7 +440,7 @@ SYM_FUNC_START(__switch_to)
 	REG_S s0, TASK_THREAD_SUM_RA(a3)
 
 	/* Save the kernel shadow call stack pointer */
-	scs_save_current
+	scs_save_current t0
 	/* Restore context from next->thread */
 	REG_L s0,  TASK_THREAD_SUM_RA(a4)
 	li    s1,  SR_SUM
@@ -463,7 +463,7 @@ SYM_FUNC_START(__switch_to)
 	/* The offset of thread_info in task_struct is zero. */
 	move tp, a1
 	/* Switch to the next shadow call stack */
-	scs_load_current
+	scs_load_current t0
 	ret
 SYM_FUNC_END(__switch_to)
 
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 59af044bf85c..366e15a9280a 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -184,7 +184,7 @@ secondary_start_sbi:
 	REG_S a0, (a1)
 1:
 #endif
-	scs_load_current
+	scs_load_current t0
 
 #if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
 	li a7, SBI_EXT_FWFT
@@ -367,7 +367,7 @@ SYM_CODE_START(_start_kernel)
 	REG_S a0, (a1)
 1:
 #endif
-	scs_load_current
+	scs_load_current t0
 
 #if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
 	li a7, SBI_EXT_FWFT

-- 
2.43.0


