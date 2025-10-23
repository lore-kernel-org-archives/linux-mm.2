Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E744CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F078E0011; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D1E8E0005; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3608E0011; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23FE18E0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6AB988EDC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:14 +0000 (UTC)
X-FDA: 84029969268.27.E33B173
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AD35F12000E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAxVi5Ai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238272;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toOH26MNNXZ/a0jLqJFpe7lgGdGx+eWeglSa86Jq3P4=;
	b=hxgte+qC2GmvXYMbKBihTXNbXFkNxxXWHj6bzkf4MaR/Cz72/jRZkWDx+8zmNM41lL5XGw
	LAdeNVNPnnanUrc1R8r4Cqw7Ns+YUjgCXRgGRKHg3CpPLl7aGAblRd3IcMHhoXHd7O6/u7
	mrpz2W9SvaD1WuFe12WJQsjwIB5M6uE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238272; a=rsa-sha256;
	cv=none;
	b=UfK4mJRGs7S3Z71eB6HAxUrwJMa13Rj6vta2nl7jlD8Wwlg/oYFs3W0X2WA/1wbA1vU7f+
	b0L4lNF9PwP4L8cq7pQxrWmxTZG89G1jBEtRsD1/2/W19HLMN6j+ySiF+zr9a8YHg077kP
	cpn3jbo1zk3zdb9HDf2t7kSQbFzBC6M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAxVi5Ai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C95D4B008;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03D80C2BCC7;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=n7BCrIGqPEF5Gu8aeVOZniEvqQ3EM2NnS8zUD7EU50Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mAxVi5Aixn588ZT6qSp5CJ26KUCTjwA200zOGcu6XkIrpnczMj3NhJ8+hEfO/Fky3
	 Aqp3OwQYIOtzhPmKnar+UZQooTVobDGsTumEhw8kOgc/2D2guv8u2A5isIv7W8DvW0
	 wcwllgcDTpibl+zc3NYTDL6T1EJ++/ki3mD8uakflM/seG/BKCLaYV8OWBjd3PV6pz
	 41FCdxC1oDMLk5JcqCU/ITTxvHviO3LZpEnKoZsveQtf9NDEanDo6k998umMUyDu9k
	 ZlMfnjWr0q4ms0+kCniYI9zSEg05AGacjXCGYj1DBrEXY982vWcCbwfqODGw0uQqvQ
	 PY4dDvRUCOteA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DCCCCD1BE;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:10 -0700
Subject: [PATCH v22 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-5-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=5573;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=R6UcK7O0yzGwyniKw/erlt2J+KJFzK3qt2jdwKTD2UE=;
 b=P3In58fAPn2b+Yc+zI4bwyTOWKO5OakinXHCHRb4p0ZM6TLJheA5BLTjNtR/NE8m5uRcs356W
 cDlDmB0hlwzDMKTiF+NRjq1f8m2ch4W/ya7frtSzfh82yxwztowwUES
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam01
X-Stat-Signature: wjboqtyzh7kcb6tjwhr6i9zfkpqpor37
X-Rspam-User: 
X-Rspamd-Queue-Id: AD35F12000E
X-HE-Tag: 1761238272-742652
X-HE-Meta: U2FsdGVkX1+yoi05yKG9ZqyKmN/Hia2tVHgSRn/+m2ery2/JYQG7x9QdMIWLOLbosuo3MYgg1KUCqNW9gDYDAY1U+vEXLRabuNPVNraJxDOmBALJdFVfrWBPV2LKktVxMeTPoWgtiPWcuROGVmi1cBXUV8mQuqs1uKOJBQfD+3iGLL1al7nAsMMRiRNQ+/RBIMymBV3hovqP7jnjHzL5pHj2AwRfXXIBHQ2OOhzTyVlrGFYr3tkg0Xmir6GiYLxnW0Y8q49pY6Hh6MkNKIHuiXG5zfTeq258Os/LXZng9bfxJ8PYvyWQiNMegmi43CqBX4cDgN+y8W/DGJejGxGkXqdhPhFZB/BbmMyYl6V/M9Jf8eA3Of0QF1v4DG/aE5wObm2+Pf3+QGf9n+PuXHBU4E+zM53sMmEEhkMfOiczZiaPfbxrEC5IJmsvTvA0aWHQZsQD2FXx4MnagWuNFql1VVf9BDD9Nr+jr7k1s8axX4rLjP/Rc9LbLScjFF1z1BdvdZKf+OLOrj1VNkZvM44PkCTuGkzhz3eR9uwPSaTSj5+TnnV97mI72hcbJKYkcNmMwicv3KQgk4jVWYR5iVYKHMPr0HSI0JDn3C6MfH01pdYqw/eAF8vQwU7PrdgNpBuvxOhvdQTlayWvj6eUQYG+HYKFfi9fsBg0SKrb7YfcrIGzQCICPn46KGcXw2VN8r2Bnmc8Z7HxUApP7JP3CiOYiDlbx/xq/FYCOP/7+RU93bUmGmXUVqtaeBV4lqlyzaEhVpgMZ85M9T10ojFMzdvdSwzLyh6D10khAzT64EBf41rqJWEQLhOI6EY+X9iAtpaaxqzuHYrADYK/1Um3GtF3Di/bvoPSsmYJZHgBjZhiyzl3xJl33s+LoQZdJF42Am99hJKn8rLQk5Y0krSGmMzaH/4PuJHnDN/LgVCM2Lbmm8qIItHEjEHreL9q6TuPWA/xoU8oKbgb8RaouMEGFZ5
 6FubI/CQ
 KS5MRE3n8WW0WrtGaF1IT2dtCMqoKFXW6eaGpmaqLHNeVQ9y7dl6nnbOxO8aWNV+7bopSOPPmRoOuXmn3cQweyHFEwOh/PC6JU5PGBuGlSPyOHMV2uIs99QDvUNIgrwBNOse20gqVWmzf6pNH4xNer1DQIBvbILuQ2bJdhw2ZX8H2rgJ7oXYthXXEeVe8cBsgfa057w3Sys1vsDkj4/KcU+qem3uFUH2WK+QNgkfsS0cWNb8CIRa3MLscSabHOJiR3xThyEbjgY6BWkgUmDV1wCpX64LGLjoof5YWcbUrAX3vhdit7Dh310A3MBn6ZAJGEUIl/CoVnvfj2qhU8lKZBwgr+P8BWoUOxGk+APKSbPbc/B5masdxgHB4opQbex9I0g2rBZk2vYaDpGPv5kRkDZfGW77LeW7Skv3tTDU0N9DigAo4zj1XURiT1DuhpzsJ+xudgg6WL0D4ZIopKawtMdaRt1OPHWYpZFcHT10ozu1d1gtUCwtghnn0ba988p9nU2/U6QyqfYek1X88cynbQ947BOkMCCRo32bcjRxkJHsn6txVEPWxGzrWK6gzOXBtgMJJqDPgtPHnzYg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Carves out space in arch specific thread struct for cfi status and shadow
stack in usermode on riscv.

This patch does following
- defines a new structure cfi_status with status bit for cfi feature
- defines shadow stack pointer, base and size in cfi_status structure
- defines offsets to new member fields in thread in asm-offsets.c
- Saves and restore shadow stack pointer on trap entry (U --> S) and exit
  (S --> U)

Shadow stack save/restore is gated on feature availiblity and implemented
using alternative. CSR can be context switched in `switch_to` as well but
soon as kernel shadow stack support gets rolled in, shadow stack pointer
will need to be switched at trap entry/exit point (much like `sp`). It can
be argued that kernel using shadow stack deployment scenario may not be as
prevalant as user mode using this feature. But even if there is some
minimal deployment of kernel shadow stack, that means that it needs to be
supported. And thus save/restore of shadow stack pointer in entry.S instead
of in `switch_to.h`.

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/processor.h   |  1 +
 arch/riscv/include/asm/thread_info.h |  3 +++
 arch/riscv/include/asm/usercfi.h     | 23 +++++++++++++++++++++++
 arch/riscv/kernel/asm-offsets.c      |  4 ++++
 arch/riscv/kernel/entry.S            | 31 +++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index da5426122d28..4c3dd94d0f63 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -16,6 +16,7 @@
 #include <asm/insn-def.h>
 #include <asm/alternative-macros.h>
 #include <asm/hwcap.h>
+#include <asm/usercfi.h>
 
 #define arch_get_mmap_end(addr, len, flags)			\
 ({								\
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 836d80dd2921..36918c9200c9 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -73,6 +73,9 @@ struct thread_info {
 	 */
 	unsigned long		a0, a1, a2;
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	struct cfi_state	user_cfi_state;
+#endif
 };
 
 #ifdef CONFIG_SHADOW_CALL_STACK
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
new file mode 100644
index 000000000000..4c5233e8f3f9
--- /dev/null
+++ b/arch/riscv/include/asm/usercfi.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2024 Rivos, Inc.
+ * Deepak Gupta <debug@rivosinc.com>
+ */
+#ifndef _ASM_RISCV_USERCFI_H
+#define _ASM_RISCV_USERCFI_H
+
+#ifndef __ASSEMBLER__
+#include <linux/types.h>
+
+#ifdef CONFIG_RISCV_USER_CFI
+struct cfi_state {
+	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
+	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
+	unsigned long shdw_stk_base; /* Base address of shadow stack */
+	unsigned long shdw_stk_size; /* size of shadow stack */
+};
+
+#endif /* CONFIG_RISCV_USER_CFI */
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 7d42d3b8a32a..8a2b2656cb2f 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -51,6 +51,10 @@ void asm_offsets(void)
 #endif
 
 	OFFSET(TASK_TI_CPU_NUM, task_struct, thread_info.cpu);
+#ifdef CONFIG_RISCV_USER_CFI
+	OFFSET(TASK_TI_CFI_STATE, task_struct, thread_info.user_cfi_state);
+	OFFSET(TASK_TI_USER_SSP, task_struct, thread_info.user_cfi_state.user_shdw_stk);
+#endif
 	OFFSET(TASK_THREAD_F0,  task_struct, thread.fstate.f[0]);
 	OFFSET(TASK_THREAD_F1,  task_struct, thread.fstate.f[1]);
 	OFFSET(TASK_THREAD_F2,  task_struct, thread.fstate.f[2]);
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index d3d92a4becc7..8410850953d6 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -92,6 +92,35 @@
 	REG_L	a0, TASK_TI_A0(tp)
 .endm
 
+/*
+ * If previous mode was U, capture shadow stack pointer and save it away
+ * Zero CSR_SSP at the same time for sanitization.
+ */
+.macro save_userssp tmp, status
+	ALTERNATIVE("nops(4)",
+		__stringify(				\
+		andi \tmp, \status, SR_SPP;		\
+		bnez \tmp, skip_ssp_save;		\
+		csrrw \tmp, CSR_SSP, x0;		\
+		REG_S \tmp, TASK_TI_USER_SSP(tp);	\
+		skip_ssp_save:),
+		0,
+		RISCV_ISA_EXT_ZICFISS,
+		CONFIG_RISCV_USER_CFI)
+.endm
+
+.macro restore_userssp tmp, status
+	ALTERNATIVE("nops(4)",
+		__stringify(				\
+		andi \tmp, \status, SR_SPP;		\
+		bnez \tmp, skip_ssp_restore;		\
+		REG_L \tmp, TASK_TI_USER_SSP(tp);	\
+		csrw CSR_SSP, \tmp;			\
+		skip_ssp_restore:),
+		0,
+		RISCV_ISA_EXT_ZICFISS,
+		CONFIG_RISCV_USER_CFI)
+.endm
 
 SYM_CODE_START(handle_exception)
 	/*
@@ -148,6 +177,7 @@ SYM_CODE_START(handle_exception)
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
+	save_userssp s2, s1
 	csrr s2, CSR_EPC
 	csrr s3, CSR_TVAL
 	csrr s4, CSR_CAUSE
@@ -243,6 +273,7 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	call riscv_v_context_nesting_end
 #endif
 	REG_L a0, PT_STATUS(sp)
+	restore_userssp s3, a0
 	/*
 	 * The current load reservation is effectively part of the processor's
 	 * state, in the sense that load reservations cannot be shared between

-- 
2.43.0



