Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8494CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D78A8E0014; Mon, 20 Oct 2025 16:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECEF8E0002; Mon, 20 Oct 2025 16:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D868E0014; Mon, 20 Oct 2025 16:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 411208E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEBAF5839E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:51 +0000 (UTC)
X-FDA: 84019616142.11.60EF472
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF53D40017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HNJAkyCe;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf11.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmXOZQ62j3QRaIvranq25arWdnxAPtQ6fIpADhvgWuw=;
	b=2fOX1VKpffadyyjlX5z9XvZTL1v6Ulc7sLQuo2x3HmRKJoG9qO34syV83JpRyfRG1leDRX
	JsTQXgSdMglbYOaBjUmKykHDTMtmcTSPbvLpztWj9VDzVnKoaijlH86Ezw/K/zEHCreBKt
	z5nVJUIKnltvdpwi6yKa7AqsEg8nVqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991770; a=rsa-sha256;
	cv=none;
	b=bxnpy5AnolAC2rHlMpXebRm6j+mf/qIqx2DdiwpWmXd5m7t29jAUaJcmsm4KlqVbheqYXh
	rzawAWkUCFXYwFVC1Y23PqccE1DJYD+JR5Dkd+qqKU2REZ2QabhNZmU4R4b2sOYtvASqTl
	r+hVJ+9DtuX2opKGp945MNrNW7GWOG4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HNJAkyCe;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf11.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-33bb090aa78so4088072a91.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991769; x=1761596569; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kmXOZQ62j3QRaIvranq25arWdnxAPtQ6fIpADhvgWuw=;
        b=HNJAkyCeeJpX1JDvHV9oDfUBVoPQ9zFnaxFmJFjn6eUAieVFXwx7cSxzAkxtluxya4
         LCrktYC2le1XoD60XOf7dIJB35ClPRcD81sbZLE8zZzar57jY+p2WbC9s6/1uwofI+9K
         sUfBdx8FI6X8Q9po24gRX8+0F4Uzg4u3FM+jMyFT2dhMqvdLZ6DeeDIg86KQoKF3TJ/r
         4e/mL6smP8G0lrCecrfqHe8cm18JO2+jWrrQbEUmdIXwRh6JA8eBAIvt1t8p1qq5VYme
         xa0HCdXokkx7PCh9VQMZjKeGfGG0Teh999WutIQi0f9He1YTTJ2bX1m967HkaqnT62pz
         qpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991769; x=1761596569;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmXOZQ62j3QRaIvranq25arWdnxAPtQ6fIpADhvgWuw=;
        b=M6rWIFDwaN4X+DbfAE67RzDVzo6OdG1UrPKeri7CgdYoS1+M8KvXumSTvIYH2GNf19
         m3lYzWso094kurAftCGYJ+ng0nmC2bQnEa46KmJHRGZBm5RMDZ43MElELLSiLdpadpxu
         nEDIzkjhhwOs104LaCP+ef7R720Ujh9ee50T2OwJnvybQg0iUz+MX4XZMfE6OQKGT0nj
         TYh6AtPx2VTiDt0Bt9EDLj8hh9Fo/ktOfQ2ET/6nv26vw9sRqXe31dnsTJjcOA6Fsjm3
         h2k//iCGsUDbhztdJsaxRuw2WXbqV1Xq+8Wv6Pj/SRx1oQqNXrS5tU2lLhL5nzziBIlM
         q2dA==
X-Forwarded-Encrypted: i=1; AJvYcCWimD8Rocb5BLdVid8U3MTM97qbojBOvn5yx1HLm+6lX9BwyYykuCG7/zL964gAs6aqL4AhVC9C4g==@kvack.org
X-Gm-Message-State: AOJu0YwY+NHRsw8CksRFeh/vA5TKJ0br1OrXBbHdT19QS3Uz1yFQL0CE
	P3KIJk9pnvcTbPsdK4WIOj3RkP1nnzG66FvtGzrEC8vI2XY72AXnchDetYHgGh9SrA0=
X-Gm-Gg: ASbGncsYYiFN5OFTVClkwu52C9ZMLzd3mgpUNuQGVsaiUp7l6mQR0DMXzU23eIdgc8z
	T8NtCf4p6ke+KcNKE4RF9mJ4U298PE4k7QNu/VaDBbpS812ZGNK/mq7pLatrifFhbJKEXMGqotG
	hh5UyH+HifVoCU0gyjkJImHELj6sU1V4KQl1VfL2kGyrTHeYYgHVh48x0Yj0kjV8pml5qOrwsAs
	/D/Bq9f8Vyc2S47JE07eEZucdhOoE+iF2hXNExv6G14WoOC/HRAwtVwlHigN35cvvTeQC+L3k3/
	Hpe3N03FofTCtqZrab9c2X105g8EQKgxM2s/AFXyVzcSg8NROuUCGjqzUiaxx2BCepZ2Roh02W4
	UuVbtelDVJTR4LJLGCKZxkxf1DqruWswn2Leik/W7e+f2NAvv/OPUkP72AJigcD9CGOaGnvf1+7
	Ma8vJUb3A5n9lD9Hhg4D+d
X-Google-Smtp-Source: AGHT+IGUaINT3sa79WISIy/eLZ+hkAOyOwADyHTku6BZCvJw9SjQaU2SzGHZctxGHYC+zUUXdUn7sA==
X-Received: by 2002:a17:90b:2fcc:b0:32d:d5f1:fe7f with SMTP id 98e67ed59e1d1-33bcf89380bmr17749555a91.15.1760991768726;
        Mon, 20 Oct 2025 13:22:48 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:48 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:34 -0700
Subject: [PATCH v22 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-5-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: 9ibrrfmf1pruxbfp3awfe8d676boxwdd
X-Rspam-User: 
X-Rspamd-Queue-Id: DF53D40017
X-HE-Tag: 1760991769-648882
X-HE-Meta: U2FsdGVkX1/enz9s0Nf4J5aEOmSGM7StUOoAHDAKE+T5FU0B7IujQ5b+qeXmjUAUKzrifLGk1ARSjl+oUGa2Z0hFS2cVyrCqlc1h8l7kfou63pPuM4GVg/+J04E21Cbf9HghQSrnT2ZvxehPuV4mBZTPnBEpsf473AmQYDO3ZeeDwXhgWLdFKrOZ11N5MZ1NYAs4Cv2njbFRPSuA0a8lHudmCTzntNM7GdqdZFa2NIY40tWfshC4/+wYzTfZxnzt46r3DznFad6iR0e7dngYCt22MX+hpciwZl1zlCUjK44/SZb4MTaDpQrMpiXuyTycMoMxI0KhrVCEyPKZoTwMlifosomAMIqDcpN0gvbN9KBP9o9rKO+0G0N1Ls5SMNbCVQ+zRIulym/QLN1qlBBXPp1/Xv/dciQuSISh4cidGFMUorjJc3yXt/frjEXB4beL6Lq9kqhFc836gaBZZ5nGEN7fa0K3b11ToKgzBvBUIAJ3akn3eeD/gUOo5jOpRRP950GA9h4kT8xGxJxlDQsz7zd8w6ApOvfS3AE4gahY5GeUMFK7id0mTn+gUbxd4X65aCCv5m/kVLLw6SQmiHcXWsLdv9tMuqoa6TToQf2N4B6rJnDx784bam8h68H/k76tlCJYInIYhXgFP/ikouZ38WN/Gkn5Sx/29f5CE/I48KRQtPdtVDzuQ6aVfL9Jt1kmrCLcDZydmYVPugwU3Kb0A7uYid1eNuhCUQGcc3UM+V2MZRpQhetGutNybndkPla+KssMoBE6Ig0YvHCQ3MydRjmZQnsQr3TIDqXv7jOTxeoU/5JIQ4UWsLiMgvKNfCDpc8I30El3A2VDX9024WptM+Yr6nVb7cVIjnPXWu1P6iKXs70xqEB0Gd1uuOpmpHeLqpKYVunwva1NfxJLKM2qfpZyirMmmmL2L/dIIEpH3HLrkIeQP0Akxa6ROV0GaihrWj6DNW4E2RnlHtGE2QS
 hcoL1pyA
 Bn6UXd5vaMHp+CQIc6p70vnZ9pDc0yO0CWSTJ3HGnaX+56KER1XggsHBFgaubWUkaNuqH88rB+2iSn/5LTTXncEmfyZoev9mjPb4EHQOrzZjO2y6yAVUWfcKifQ9E5Z77Uod+P2yJvsRaKftrR4hZz2iFafKH9Ms0URFK0niu85xJbyYZbYYhjko9knYhefH7VEsPNqHQfucHb8jouVaSO251yfY4DWJ9Ez7g1bOkyXjWBWDD7NrF+zISveH/J1Tw0d6laBhtXD/RBL1VP76SkJRs+QGfX7XJKtQLyNIgaYWIfMdkMYrk8k0Rk1snH5JpReh1prlNBLxARVFHfTld7uRW7uM8DfKDsyeJGEkZY2Detg6ku/apJEVpW1qvsvzsqBz+z3vAB+BfAdsvtIm7OHZ/kxGiDfYWuLsPAku5Qm8CxVGgCmnnJRLyH9fgdEAs4bgMU+/riID/BAi9Y48ggb8l04c3x8tkUjAps4Ex16Lvfw+MNfdczpcfs8jcqnOK4QbVjhUUuT+ANy0=
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
2.45.0


