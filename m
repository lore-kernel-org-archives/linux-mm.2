Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684D2D41D6D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460246B000A; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320FA6B000E; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126256B000D; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE41A6B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC56DC0135
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:10 +0000 (UTC)
X-FDA: 84207855900.23.F49DB88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BA332180008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EE2hWZ5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473668; a=rsa-sha256;
	cv=none;
	b=wc5JK6l30cSntywJgzV5UnGFJ4vQV8LrrEJFP3ukgyk29+eY+a0Bk5xyPdRdCOnzoTPPSP
	birU6GQasPwdiC0F7KWPyYv9JeyLWtpojH6vOWSX03tdCxaUOp0PW9dKfntc1iqcmjMmeU
	wIj/ULsI8Rtd396G7WsrRvwprX/yNZg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EE2hWZ5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473668;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+ZDTU30ZQGI9mS3UAkx/DiohnbiAAGl2kR4n8ojFoQ=;
	b=tCdXgd/aZGyf/hbb5VRbIOl2ePb93Up7J1fO8/FuAo7jFtq6yfDrzcq2r0Lv0s1bC78XOM
	M3KXaozSya/HPbzl6I/FMt3sGVv0kEivxYfGM0H+24AKEM2mutJNxuOEpY5YPdEkrnj1NU
	5uLY9DsjznUf4TMJPKMpaHSxHmVv/fw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77973601B0;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0FF3C2BCF5;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=vGt6In+217AGJUZ3daQuh5/lKq7QCYpyZ3cg9p1d1Mc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EE2hWZ5PMU0uEzvIDFgKXsa6ggAJANPFBPmE8Qyhx55d9cfmrufPkXDc+XYKMk7GZ
	 UsUcV9bLp9TJ/P6HzRxbD68SfC4YGeDT9uxC8V+HVADw9RuYiysZW9zT+TPXyiTP8q
	 VuAkDjxt9orR6dQxpVejQ14mXp0/TWuH6xc/htYAVscUrf6eUo+XySVGjXxY7kRLir
	 RAdWJGth+YlPnv0fSyFURHLL41rba3d8DhC4KVvHNJmckD+JU7+f7V4T09sa7D8VzW
	 gYcfvPAYHjeFaEAoQBJ0vQOUuDts7eFCxneTjKBpxpgysu07mpvjWTY3HdE2O8KQuv
	 O/l28wcswB+Aw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD56D41C15;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:38 -0800
Subject: [PATCH v26 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-5-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=5639;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=mAV3hY87u/VPuMTejtLxOd8WgAb63pEhw7mYXdwweG4=;
 b=AAQ4wJso7SYTBtbMOMPHx0SUABDNp55Me4hDl/ssX/sOaicMQcTgXe+S6zc4Ia7IwEXugRBhh
 dXxjKQigt+uCIrH6rlhF/U4L9/ciIkgVlOLbK70DJpr9YridJh870nT
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Stat-Signature: s16z7xaf7rm6h1iyuc6w699sdj9oxw6s
X-Rspamd-Queue-Id: BA332180008
X-HE-Tag: 1765473668-610910
X-HE-Meta: U2FsdGVkX18b8u7M4ER3Br4MH2dE8wTmLSfLfW1D0Tlkhl6fAF1nHyew4hOpcaAzGSRpzwgxMSverguPoPKoIyzZqEKbl5k7oIDLfixbttuxmRmSvJlogkr8M9gKXssF3o6IKY5EOf49ubIsK4KLzqpbt/rrPT471Gog+s76DRHpKPWixDPah9TM1qmYvWnOe88+3+/f0ltK1xdHw0Xq4OgR5RrXzh1MCIAuP/S2yKGgNPYBnpIv4ICQRB3LWOv+5bezuOb2L0HDNOnBI+GYJDhTOhXnwfmgA0pKlc1rU/WglwVS240Ma93cQCAbAjRIHqWeuaBKGavJwnXI9QE3kuJkju0J7y2fYSRMLiJV48n3dsgPj2kd5rn8qkf4nUUihvDbF2UIcRCeKk/gw+Xj46c/r/lDcw/NAmPqM+qWEUG9rX9oO5IoIoEFjN68c+sL78mqk5m67AOgBCp9c3qone6Zs+tdeI4kCNXf0lUw4YIEeXfwoUBQiXmo5oz/f26aKedLdYgNQU2M+xOomjSVFAuGdv9f8SamY8wF3RscgEM9riJDK5cPCHOEBiAWz592woP2GdYlTgcGTEmYTfn+YVF5jwMJhTyRYQct6d5hjtjLUs+lUrgYR/6uSlQ1LRLVdBGhRq3m2lSZ6QMUPeJ/vuzpztWWmQTlwrd6w2xrVZv2JXpvXS8iYulvkM+v/WSZxCB+l34yoAtYitHbug4H1r8naknJ1JuW9eyhiUsYh8iKT1+hDjI3qY3WcD0dB34ARq/hDw+ganvxvEI1Vvk1xOMHFAHDcLVyZ+LjhsFPE99jrpPLCXLziEHtQnjn8hY/bbckUR7ZPT+tlYt/yK97O7apH0nSuTeetHGklx1tqQW6TaFR/o/uNKUT7a5XTGGWWnir8CcTy2xLlVj+UuwG6IUXbE5eBagrdpCqpcw5x/SzHukAi7PqOSfjEY8DYUshrEvlfYjWXSCeuaHSWLo
 xOjkncdc
 sLrP6ltCwiVQ/tmVhV8Qq5pG8XEkXQ+ey/9HgCEW9P1ATjLYxTFGDS8pPQTLKmvXf08MSkR8rUfbjlfGBXxEDi56gea50CnhxEUh0+B47ZKmnYvWLXW8pR7Yemlc5mcZLtjE4JpHVzOV63QnJZbgLlJ/NCECRnYoSR4wBi63fYb3k9ehOrHJcGusjC0HXZ2jt8rka1RCs/OttwHxzh3xEHiSns4anwDH5jPTXrBbMzEmqxGpPtXTPgBdUTbtZqzjklFtWppzzG0lCu0W9/E9QQW0x5eKw2gtxWFDDKFZUUxq6TmNjEe2harMl3h1EZeyofpQ7LdOuQDhoF3aXlwu+LCB+guZ1Gro9hI/ptQU8tFfDqgVgI0x42qhyf9BzL+w3PygWGdEBFp0lbdI81YiCVtKOklWVATlYU+8eNlf5A5rmn7gfW70fdL7W+gIeGLy01FPub3kx9GcwDyTjlcu5L7qUucvUnTQnWpchReq66moQzoT/9JPk7SSt88/n/pt/osbvRpMGzNIN04Q+r3olU6CabqB2EKlvzfAr9ySvEM4fCdqB8Po11lYKclVx7bSQLPLG2Ne6a6o6toRTC8vuJPjczRYgATQSvD4dwY2zasdOZkw2Wv5T/kPlgWvU313A0g8RZvmSBj4jCGU=
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
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



