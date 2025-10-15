Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C15CCD19E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7318E0068; Wed, 15 Oct 2025 14:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F418E0005; Wed, 15 Oct 2025 14:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12EC8E0068; Wed, 15 Oct 2025 14:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1BBE8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:13:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2EAB16027A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:57 +0000 (UTC)
X-FDA: 84001147314.21.6BE65FC
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id B163816000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OQrfV9XO;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552035; a=rsa-sha256;
	cv=none;
	b=wtlRaR20ug1toRI6FIVZ8kYJ7QuE+9ff8aHD/rPTwiFI5UupxnQrj8Kkwm3Ce6dPxo2fD3
	ZaMqC0LKlVJotnZ9uU9YYnA7KPiVhtrd0HLHCY8HlI+EYIQfFjOt0p+/ggJZuI91nTzk7q
	kRnfv1AKuiO/WooXXQ8zYJI1PYsq15k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OQrfV9XO;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
	b=fTKoEkbpNdYrD5nQnFSr72s0yiPT8o03QtLZNMznhpm4Cqok+RMKql2rp4YtwGoUZhEl36
	bscyHQ2Dg18SwFKFnfwhhkZiq0nkwV8Y2Ih59OjrquSy6Fhm+T9XpI2gAEEiihc63u4ZJA
	a0wC5dgEFlKFd0hEiY2tJ62aKQjc/xA=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b550a522a49so5719057a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552034; x=1761156834; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=OQrfV9XOEE1QmfK1SBFdnaJl9PqZbAMzPJRdHFRtaHAm0XMzk19YjdymwxLRmfQ/Tf
         B4Q2BV90Vhgb3xVOfLLegtmXuUbNKiXbxeJop79zNI8HFCbKSgOJdRpp9XJqMjtEXd9s
         s5akpxS2cF/HHkQpdN4VXQT54lYryyG0SiIbqafVGQYKd9G32np8zR4qcaLfzPUknE8M
         5uzjt047NO7LgCKvWzFot3M2grXSfbmTYHQiSpkDfEmk9bT3kW5GpVAwhOrubjKN6rXk
         c3Plr4f2PaZOn34JQTbtDxRLPT92fbWaA2+soD7Su53Cw+AJVauR450dFARvYOm6st6H
         tK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552034; x=1761156834;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=BWN2Wf1jHsRvBVUJoDTjRTKQGmQvxfyvNNy/1qlvRR9dG9V/0PrX9KPZJ1iwEiwOb1
         h/rBHJtOINReH3U2tYUgL2spXjMxHEy6ZhV2Vpu3RTLb8b//Emw1SCWMM914RMTOb8FJ
         uTQUIAPKBQu2EuHlSbiXS+KPOUhtyx302/lzm8VJYtxOrVbLQTBRJmL3Ouj2Rw7093Lz
         So5ocLPkae5AaN07015p7QFZj0aMiSYZTI3tJokiFjL7BCJyTQz8Hc2d1lqDxZXPs9mG
         nxfzTFuAmA+eChh79O2NiO4XQfZy8h9AwjxVIzzL+9hHJU+UeioMlClSy0BWnSd+KFc+
         ugng==
X-Forwarded-Encrypted: i=1; AJvYcCX6RJCBy7N+op7DQWdPRxVz/MumNHT7ZAYlR1enfRvPuZA3gC2lgBVRCj5Jwe9legLAfLI+KLr0dA==@kvack.org
X-Gm-Message-State: AOJu0YyyBf2QHhcG0+YjwAhZ43ZD3YRWyIjiFwfNk430mPgNmTzOr48l
	NGMnL0AxtNLmjulVMwAnDc4660TcEHkt6GGUc35VfmJowwOFZ+oPKM6yTQLno2Jg9zh+BSgEagM
	DSwop
X-Gm-Gg: ASbGncsg3UBy14WR7eH6B958HJ37LD8xB2uq6yarmeIqmhDVRiyBt3+b29+OhILc3hT
	4Uwz7FnXm784Jg/VIFhvXL9bZcpXm8tNemtJAENmni3HyjPjWvoPDBFaiSDL2AJSvuPFCNrRM3x
	rHhkYCVK2kUOJ+JKG/gfbUkeiNaYGRL1BPTbZI2MwhmzEQDrcAZrTZTdzGpEQKO8hpEe1tW7DiZ
	xbADWBb2JftDYkMbavHJNG88V/fi/p00tY8uF4BVcnOhNPiDcl/39VeF7DWVGdzb+F63+5E68QE
	5Q9SEbzK9YCvcfpKkMPtG5cBZxlFACLXUPUOIsNhrSkL/AsrXQmza7OYM68VWOPN1OTGx0b7uQm
	5qCpQvqrQYJZUhAnInrMfZA2k8lDQDiP/7ciPvYsaQUQasZRjeWjAGN+kxDagaCwOaJ5S2RJccs
	gYw11CAtuTAyLkWnZCzAJb
X-Google-Smtp-Source: AGHT+IH/IZlQmFbYzH1tpF+086LHoydbkYwxOOv0+TN6qxTG9GQyVIDfPZ3vjiAejZnUjsjGWe/i+A==
X-Received: by 2002:a17:903:2c03:b0:269:87a3:43b8 with SMTP id d9443c01a7336-290272155c2mr298422905ad.4.1760552034239;
        Wed, 15 Oct 2025 11:13:54 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:53 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:37 -0700
Subject: [PATCH v21 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-5-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Stat-Signature: 11183qbi9y41qbnbuu5eqj9df4qgjg5f
X-Rspamd-Queue-Id: B163816000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760552035-99673
X-HE-Meta: U2FsdGVkX19mT2aU4zEq4SvZDfaDtAkRKK3ShTGkJE6rAmREfDGV8umHMJSGkbwLqjTV0bn3JFuQVYtlThwMdBZyKU34xDtia4mHhf3TB90g6WgR5kU0y/vqUjHsS5ZIU5HegBJFFbXRWwbkzLU70YL394gmUOxxWfyNnyFemEX3aGGqfEuFSlM159S4UPBVMAA9lvMxIVHwTwcfBZ6a5psqoPGdtPp486E8FksTw0hmWcr8mdvDKWC2E+/Zvh22VjKY8EYOWj0cd3gU956bCMXLMFoiVWzQ2GHsoBjz2oKImn/QEOUt/wn7GgZt03c1MZU9oeVKMCIH9zETpzqA1I1oZHdQh7CO5v8AU/JBNUmFdh+8b7K91uzizmuflOPmxP1IvEEOwLVTmCixNnaMqQnigDlqoCdTM8JOvRkOcrMGlgd0Jjc3zApqfx37+v4rsfYvbE9og+1REvfg0li+nWe+6aWEe0MTVkO8DNkJKC7d+4TUzsmQQYIDzJ31G+bnusQABF7PRwpPxhEWgM2+AW7mDl20N2gVwgoN7oPHrx2q9eY4gMMmnhcfb8w4JMKvdImkvvu5R+0xMAsOOABb3WTVTpyp8LAFrKBXpZA/3ZbmAe651Fv0jkWtISvmmcT8L5z5f4thy0gVCaOW5ZOh/oMHq/Nv4htNCpnj75c5yDksMrjTXvekQD1R+DKAyLP352YJHABlkDixkZfd1FZQ9GKHtYpCSJEP1jdLAwVOX4ppEpQYZmC0ngg/Djq9COpFjtt5Tcs2yw7GoaxZ7jG/7oPFPsNSNyu8J0BoExecLF2U2gInSntcieIgm5Bf6R0dO72ChNaRysSEOVY+Gvnb/Ca8JiCJOVDomlzm6O3GIIzPaiuYbrrvIboCpY3X6bfnBS9yZn7ccP3YqO377RDwAILxQLfKK5L0MWdP0lfbGGrY/6sALWVM++pSh6Ut+rJ/H8EvwOD+nzg7/TJb3Xj
 P2BQSFaW
 g1BU+BrcuhBiSovpWm2HXLGQI9qEQ2cUkGXTmeE5CRLTotpUmDSAYuQ2IwGf1of/Fhu6FDH3i/vcZRLglxtCY/P01O8HYJsC4PkhR1a/Ia0Wd5oOdJV/M89DDFHk9M8UTQj1hvM3sLlvXSBsYau9CVviFNwTSAUvz49+Ik7ap4PgqHTZgQDW8f+g2MjHNWJvhTIww3bMJbSnV9DgqFx9Cmx+5UMPmtPX9HfVjpgRjSlSmaXUL5ucn5zz1PZQlfQ39YppLVFEJAuljBhhGIpeu+Y4MfocxGnCwQ4RFzSwq/dtrHqwEiu7YPtTZwZOvwRbv6NcLOLNf/yMz5EBstKgyMdMG+uoSfR/GkdBQSlAtRoaNOa4INuQ31Mkz4ClKhV9eBnEkYPuIzNyb1mkpT4Wxg8DG5FTu7HvjIzBzT5Dfm4Yu+QhAsdIehlVhTYuzwqj4KFAskcuRPWX5qb9JTiv4D3vQYsVLJuH0UPHeJelXMWcLfqdT6oYcocmk/rfOSah1kfNe8OBDz0DxkAK86nHM7c55sQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


