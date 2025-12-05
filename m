Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EA3D339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98816B0281; Fri,  5 Dec 2025 13:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F8A6B0283; Fri,  5 Dec 2025 13:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BAF6B0284; Fri,  5 Dec 2025 13:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7629B6B0281
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 437FF1335D8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:56 +0000 (UTC)
X-FDA: 84186286632.02.D708831
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 371FA160017
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GgK1WET2;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960114; a=rsa-sha256;
	cv=none;
	b=QUtdlywCflKVV0axwXwTCE2t5QyengE0+dfxcZde2wAPClO7eTaIq89S++TVmiRGb7P+9m
	6MBIC81adr/XHOGXeheLM8Md8/OE2e+vMHeZav5Mk7DCklIlSOIn3RDwAeIufQHJMAcFg+
	QEeCb/csqjhagLvI6ennJsnkbKUnsLk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+ZDTU30ZQGI9mS3UAkx/DiohnbiAAGl2kR4n8ojFoQ=;
	b=2ladENiXepVRJjhCWknqtrl3tNaOFon5FuRrqqHS4tnDzODN2dsbe25f2fevHyCF7kS29D
	1HHihkWoIcBfBtIpDL0k6K99RRt/TyHlgJ0AyDHcPYw5JLO9uIZpzddaW1yNmqk5vFXTAu
	SEyiMt1IBNYpuKJWYrYGeUooK2iUNLs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GgK1WET2;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A686F44425;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E013C4AF68;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=vGt6In+217AGJUZ3daQuh5/lKq7QCYpyZ3cg9p1d1Mc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GgK1WET2GaPPFg7eqLx0cHCj6rBkW++Szvyv0ZyrBOBpz6bxCH3Liu8w46Qtz+2/y
	 MXKWTMO9yABA2mPTNVPnovuWYFMY1kdisrtzgOwH5iXpP4njyM1iKCUl0LeFoaj6m7
	 Sf0+wHsi+F691XU12B+oMxoZkkXMAOt/5wQJ5wNB4O8AaBs83WzUZTGjR9fqGZpYtg
	 eJOGPZPbTU6epVKhqsMSLu3nyck7v3dkceG69c0DbQb4omqQshfbD0nC0evZSP7vkY
	 6PcuRTpAcEV1UXBRV+WIv7VqB0pQnfEyvXXIABfLyIJOM4+wnlYejQC7S/87WUUXr9
	 Ntwd5bnD5SqzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417FCD339B2;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:43 -0800
Subject: [PATCH v25 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-5-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=5639;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=mAV3hY87u/VPuMTejtLxOd8WgAb63pEhw7mYXdwweG4=;
 b=CaMGwq6wKUlDQuTqGLl09yAUmVKykAqRX3orD+GlwSqi+l/DN3FChTz4ewzCh4XqEsEBWtSzX
 eE3pzt3WCt4AzlslEvr4LF2ULDudkknf6oO0eoOsD0diCCcubZvbJd1
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 371FA160017
X-Stat-Signature: ht5xcz7f5um3d8czz6c99ukwyijihds1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764960114-832596
X-HE-Meta: U2FsdGVkX1/fU+UhwVQybUApIJTsjTJhJ3vFG9DC5f+/TaWdw4XppEoqGpse7ig/kLBIpvZ3FvNvaSdrBenkpIe9yOYNlvlmWmL2jqy8920pEcujvhzIs2xagI90MbAQQGQlMvYb4HCuCzy9V9mw5/zFHJB4oOqzNCF1FxL8dIB0v+R5lbo7Qq5QE4936baFTjDW1fEu+AHmSpmJ1dWVXqx8h+4ZDXn7piAijqx5ufCXUdCttBrcNTV4KNgwyFsWGsax3lsaxDCiCbuzzRjjftJ0fTU7NiRzOG8iGBq7R9K6199fuo9OA/I7EJM5zGHB3zAADowPhppRRghkBQBjCzoc6pYIogwtTqP2gCu8N+dHv0+D071ArtDdMdGgO7eaOubGiJw5f30kKmL/uYqGNZWPLYmWanjlQ/k6rYsuyKxzYYEvErRlmoQm2AvmnmzQuxpmn/zfKK/NLqnxEcZJh8ippA8lrTLNMj+UK2U8uzPeSeplHzISUVSOVxJM49FIzz2PRHqShNy3BLalvzS1h8XOkX7Fk4SNCenwG0kZ3/z2E2ouZ2GBY+D8dEUBBg4pa4+TrmjMBKFuuC6PgbgviEhk+Y0bpgvdSE+277uleWEJqBVt/p9hv+QkjIgh8LCig5jSTDKbkJq3uaC6djzF9gS9BBXQ1Fs2ATQoQ8JZJCmQ2SfJLNgHfSxXJtXk245Jb+pQ1k8VEtbUy+TNRJiZa4hEZEpOzeHP+67foYXVfM1bWEdUoblEUJmHKoMLAa6gwFwuBNruJKKx5iTwbuWBwILgSOSlM5fdlc7Vkmvz5R8g9G6hyS/yVWmgUwx22pwMGzyYAwiLsVJyX2s888YLcj0kVU72ECoE+Z7WJd7corafj+ZWIPw6inTNRMbHyjcrYhrIBALuguP1f3i7kPpksDW5C7mt223mlnsG/4wcodb7OqCaVtLfzyqcX7BSh5cRw4val8X/osBjsSnvcd/
 HwhS35Cp
 ZEEAHUWgLhgtwoM4Sp9Ixlcv8PgCkyYJCeeu0ALL6mqOGe5N48zmvb44uo/lnHRu+BchOX/+in/6tjOjBuqcQjAyeMp7D1/cwR/Ky7Ga/3XVJUzmTT8Wg2N8kBvkmMBNyg4ot1vvn153xqVGwGbXVQThFbSkPlvMC+MlZ/qJri6DTAskXbzxvTbAtSKuwLh6W3D0scBCWyuzCRXp0dm16NjxH1mhEx+eJ934URVz6RkphNcUgRFdtZXTa1t9hI8fZhD0bm1z4MCZKHFGLumb50FIKdTSdjLd2nYmnns8g51JoByDfDEBBHgpfPne97iZHbPWicVWpB9nvk60wtZ+hZZZ+1KurbaBao37YUf3gIlK1BEgg4SyQkAh9D1zPweckJ0dxKm7w8kZAC2UUAaUdkJBGdQyEB4UkDmk5bBIs5vqGCOSN0LHAf7tq7XRD/ZBHaN2fCFavjZsWHo5aU8lmNY3sEu5FqdV40zpqJJEQXzwhHPrwsWaSRjdeaIe6bPsD4GuYVBrR6CiBVHA+O1bwvUSuYRjC/osRhSpB+8ZftH96oIBcVGIk7fSjAdW0Ji7it49vvPd1oIoZ7YS4JJKFG9O1BFtD5vz7uVQPtbTVFA8eunAOG3bDsrBhuZw9T0GVvvN4sChk/8dT7Ac=
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



