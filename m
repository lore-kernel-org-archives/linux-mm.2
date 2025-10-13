Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A777CCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F4E8E0095; Mon, 13 Oct 2025 17:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF438E0031; Mon, 13 Oct 2025 17:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70438E0095; Mon, 13 Oct 2025 17:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6778E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 736A1C0601
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:12 +0000 (UTC)
X-FDA: 83994449784.21.9B297FB
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F0AD1A0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=eNvnTbgt;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392570; a=rsa-sha256;
	cv=none;
	b=M6NkN5f/g5trpTIeK+yT91PBGmd5UR0temM0OsKnVUHZxd78iw6/0PjqJWYLDncGCjdcI8
	ts/XQyh7re9Db6BQzbmrcXNUXqIUU8KcP27bRWomhSDzMkOYOi6FKldsly/x9X/OLMhCk1
	D8oDWsALV87QYh8+a/KKkcLAaaKwOaQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=eNvnTbgt;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
	b=QESxdbNahB23fmoOv6+LIHlgwPinRUq/asxdUSjCEdp5ILk9HWwHye39NBZEuraMlDhp/j
	3IrBJ1IyykZWouYnZxek883Vl4V/iY/0NUVqYJb4rfGHNIySTNzkPlYqC7sJPNzi+Fd8SP
	lZDM+q61ftmPbbC1OC2aFIxuXWl1gT8=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3327f8ed081so5895957a91.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392569; x=1760997369; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=eNvnTbgtpw0f7FezuSYfl/eVaOMZtOTXCmEHbPTQVLfX7+vfCPQivYZw8Iyjb+rtot
         gFqQ5jT4ktXK0E1pWEZs2ZimYyiBeQ4YD2/jc9mGy6s07lsIjGlkhF7xiWjHyF9XaLJN
         KVsA4SrIehWz5d8JQSzKoW0zniL+4Zn3GnogiEiludGJ/Saj0uPtYkAnxs0m+aaQAUrJ
         X8DXppZKG4tVLdDDZjT+sGKq0WheRL8xDd1tcSPrgpt3Z2pXQwMPW45DReXyJtaK69gl
         qbwxFwWCoCo/FZL1KyYp3LCS+GtCQu0EOMO6KdR0f1zYkr1JUHs3RN6+CoEfEt/BmWuS
         7lRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392569; x=1760997369;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=HQCRG4+p7PyQvVb0EPuFRj+QbLmgdtgwEWVbeUxfbjVAcIfsqc14w5HH/EJtswvNLu
         zZFH8bsynVtVlGAq/eq6YPK2XCwFq+lox6h3du/BgqP9sa+CuYsz2WACGiKRWZ58WjnH
         BREKF7OtAQ2ropQfcfcbN4SAuhLYDzW2FjOfMGx9GKPTGYUgFwHA2p/k1QNuJ2ccSl6a
         2guCNHQ3QJ7VShVQK30NkW/SmuT5CtljV88WjSGbJTuM+Dfeq4eUfEz+pjVv6j0JTpNU
         Dus61pYvO+voUwcJon1a4aVLCMCjCN99/ZDDysVcG4DKOSaoqLW8WMl/erk0frDNAYeR
         nEwA==
X-Forwarded-Encrypted: i=1; AJvYcCU3YpjI6996pRdvB+/Tdi44Kqev3SxYdHKjjxe696sjYKdgjvZPMoMqWbMDsTTtAZ3t5M682b+24w==@kvack.org
X-Gm-Message-State: AOJu0YxHm7UVNFTd8ZNg7kO26l39mJtsR98ia863PDvmVl5BiXEc8zTS
	tKuh+4mDAWR/AHikA4qsoDdWaVJ7nVtbUJtvWMtCqORHcvXitHMG0ulFXj3l8+qMwdA=
X-Gm-Gg: ASbGncuzDeISSdCjoCWxNN4yXB9lLneMgbU1AkaH6Rbn26dzRSBNQgaHdzLKZ6TOf+s
	RoVfPbwjH7KYlBMGrn3HDJxi6WceoSdjxfGPM4vKyKVNsI0Icl4C68+L0aMrpE+umLFruoLRQXq
	Et2I9t/dbx20n/Ss5NlEqZ4kRhBLvi3NsTpUtoGFzs4ogkcsu2ME/ghqN9MIBnfxTf2L+aIDUz/
	b3QLeCUbIdWO58jRnA8oeJ2sDw+XcxflLL3m37dx33CihoA4XN1L6OODrqyxUoTxyQJRXJXzvMm
	AmvsKbhrC7GhrRcx7u8dEOdVv2zxhbZqd/mq9/xSvEg4xCET4pLnC5c673KsFFmE1rsLgu+0FAM
	qUzzXBsdMuKBCtWXLEscriozkOUZN9jV5iWkuVYvMo63q2Un00Ys=
X-Google-Smtp-Source: AGHT+IFz6cledTMbV49TO08T+rqodeEl58AWRmiSDmYFeBReCaaqovq9eFWYfhcFro47tdfqTOM9Iw==
X-Received: by 2002:a17:90b:1d0a:b0:332:50e7:9d00 with SMTP id 98e67ed59e1d1-33b51118f31mr34968691a91.11.1760392569318;
        Mon, 13 Oct 2025 14:56:09 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:08 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:55:57 -0700
Subject: [PATCH v20 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-5-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: aowkwznesuzf1nmfrxshh49xkm51g4ko
X-Rspamd-Queue-Id: 7F0AD1A0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760392570-635702
X-HE-Meta: U2FsdGVkX1+WavQqiESj9x6xaP9MJg6ZvyCxW+dd9VpLDhmTh/O1I3HYMh+EeVBzrDSMVncsFetXzX2uscCQtWJkcVa7oxcAUzLnquaBIbXJWgDUWVZBp1vOkdLn6954iQHoJNbF+6etQGkEJozAmYjfJ1Jn3dtDjZuLTxX+0hPwrkK8SD+XfrjsAa8lUZZWG4iKgVOFyo89JkO5lZq5EqScKpfcZfEF1vgai4djs2KyT1/+mMslp/uWxv/veuFtBkWhZglbGiF2z0wNiTH9S+mAFHowc8+WaAmBErpXyHwzu9RDTDp//+Fg3y96qk5YkCdaG+G5h9j67azqbdLxT5hCDZP0A6DlRfIsBV6DOiWNkLKbvKr0LHIeoE6pdTv8VgdXZw8lKcQnqEWT31d/O42PnQdzrgCLOnIoef10YusKzS4UjnmuApoiVTC2H1rBq9kChIIuNe4DydClYZbUvprfJarUwB0jzklvi5bvi9UenLPfyiq+39XYDzZrOrfKN9iBOXw4vhdq9MdHMsM2z/eNceqMwztPfyKtrzYLXtrJ/irH0sR/ZpzFlg61a+7rXMfw80Ms6n3jI20rEb5A6+iVcJnpbSj5PjRXLIIQldcWqSK1P9NrY6PcmZYykcxxJFTU6v/zOLmoI0Vb0Yb7wtlATZGZHkVQ5yzwxjxt2tcvVjvnR5lmRMLYr+qnIFVtnmkJH4t74U2W/eLj0HYDx0wTVQt5N5jBMrtyvnYPbCRgWKW5vNjhXChSvCVRgYpCpIKEJAtDP4qY1O/XC2/0aEGxfjhuFFvoR6di/Da+tYPQhBxYCnMJgKoEvfUaFrBEyFpIHlGFXD6QxjamsBb7gOJ7r4lHgriP9VKLVRBVH7+74xGZLIhbVVMPGl9pVZEWug4eHotBKElgO4VnOGupernuoZ/tzZ/dq6C03r2A5hrOK3a/o+588MBg6Uj3zEnhPcCPgoBIiSooJ/MtXOx
 yeQDertk
 1qADzMqOx6rYnfEYN0KaAaQPo7865RYk1JlSmpJHdLMHYFmo3XWBTA6MJ2Vyx0Z9VvBn9hHWopc/oVdKGye+VRgF6Pac2bEbkmYXrv4k/dOMWDqM+FqY4mno8ksWlLcbxNgR6XXQ0ZnoUJa/9G7o45hVXQ9YfUCn+WUVAx+WIUtTEchcjm8iR2A9JcLrP84uQp9UvsNQDyt/fBn7QgoxKXL+gs1uAMkCCmJOscCFi/GQkHpnRohatiMRTBxsnTNwexUKU6M6vvhbG57i0BtYo6rnLqcDxdUt+F0DwUitVmo4EokpH7yleXSKsiUEnuA8evy7aC6fBJu0nvBuYWUe3rN74UlerXUaickGceyGK7BTghIDZhF2JbnG8q5Y2X/CeRtkh0DaYXbR96gZsVhuEFBoiKs5xtjVemU1x7iC9mB3z9mbH+cCitsVDqEhCer/xxReIGUUF8pB8oVY+yTHEA/2IvGXGnBcncxWu5y1VrVqnCiodf8bdj3VKDKeV5HFsGhX29KUpF3G0+3s=
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


