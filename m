Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFEDD339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E77B6B0246; Fri,  5 Dec 2025 13:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF9F6B0249; Fri,  5 Dec 2025 13:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5646B024A; Fri,  5 Dec 2025 13:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5536B0246
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C735413A43D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:03 +0000 (UTC)
X-FDA: 84186274326.02.7C1988D
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA477140006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="D1/kAF92";
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rt0jdB72FgYkFDTp6M8fR06cHnWx1hT7i1x1jwJM8U=;
	b=oVSe/AuvK3Eo8fPRiEN7fY5nKmmWxiEzpDHUx4Gj2HofCuXtnb2Uz5eB5vVo7qaEYoS2Xo
	wMsOC2F/Nhfd0hxeUoTo/y/dw8TyASuQIjvBVYTSnETe7dsw2evvOu0WFwBi+nVM65U18a
	QG28sFM1LCbYytxSb+beftlPzKIIjLg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959821; a=rsa-sha256;
	cv=none;
	b=A/ciyaQXI4iTh10LLRLmZ/rm0hpcaaeRyriL8gu9pEB2QYZU6dFZtg+HZfOg8qJIPGVH8u
	tmvptioUzO943Odl1jaEkiID6ZUV8Liy0NVYk2VhUwjNElISX0uPeu3+CA2RSxQkK+KGJX
	PzokTq+LpIdnMLfl9lKRgx3bqf/Iq5E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="D1/kAF92";
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b553412a19bso2097152a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959820; x=1765564620; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5rt0jdB72FgYkFDTp6M8fR06cHnWx1hT7i1x1jwJM8U=;
        b=D1/kAF92nsSXTSnR+MypmLNddWJJaCRys2GVmkqzzVgRBlKSJ79CI9itNclxEcMqaS
         U+0Op2JipGgzK6dgz2Kuw6Qe9bpuqSddpqA8PxOZjYloN+x/CvunZmpmTx4mDcMnEiJj
         QzAZOqhWskYo7x+WunUWg4Ir55jG2bYjCL9HRB8Zb84Ii3Y5rCWgabUN3xfwE15SGdNS
         C0n7olTXtWaTNq9NOuJd/ILkBIOUPYGE1EAeAMu0MXco6xnkzQS7BnxdKHASvwz8LiNN
         gpHVPqiKJXguZGgxRYj6HBxLlxULrB7sGdmqzeQ1kVxc/3QDwWRorrlsZedwssWMnamK
         Jtng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959820; x=1765564620;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5rt0jdB72FgYkFDTp6M8fR06cHnWx1hT7i1x1jwJM8U=;
        b=VqjNosXtSTK+xCP4lc26Vp8qYnP+oiCPeaRLLX/8lLK25V8Z3LhVDcXaJPip4Vvth6
         ju+M+DywbdYqEtM2SDzEMig3HxUsVNL/d9vUB1UPTxWz7PWjtH/8xVr0CfWhRj7HvtnK
         TLffYVWwzEwCHxcJrH671D9OUFOGO0fo6oryQChRPzzSC/zztdAfTj+lzN2M8M+JLWBI
         OIx3a0iF3j84T9T/5Y8HPPF2T1ZFTGnfcbnQB/K8wcsVddBNCY9ihGpFuRv/UW4S3tTO
         l6O05ALIDhlXDAzgqTdgsr4McJqNftQlDemN+yYPXO4qRC+9/j648pV243hTCKQrQk30
         +59g==
X-Forwarded-Encrypted: i=1; AJvYcCVElgcTPoUXj8NOYY8JqA2zzLld6EjfmMyu1q9i5Is+hovZbmjCczfp6kvXaKPLR/bH7VZt/7v66A==@kvack.org
X-Gm-Message-State: AOJu0Yw+9I4Cjtb2GG2ue71B+3Qmor0hskoYCpi6QVPfZ/N6m/FdUKlu
	av8d3xz23BH4pksirROTi8SmR2waOoy0ztFh3R3qROcj7lutwM7UsxtjO4l5+IChToU=
X-Gm-Gg: ASbGnctaY//E0jgL8y6SnQMMafevdU2hBNvS1gdckIhn2ATgyJBBVfT8kjNvyGwFClA
	FKIDaZ6IpJyKxM7LbNSRulWe4gEb1eYppLEuSi40gF2QWE/i3yxfhr/R5OEniWmHwnaOcAc7r9f
	z5pFBx2DnH7YKe0o6RHznezFPybBLAOREhzgejMw3SDg3u6MM8D7+lDvoQ10DQMC/0TlvAgBX5c
	UNv4s+g6q4cQ0YEwtbgzNshRB3EFQvtVVCYkJOQsZYFHfADxmJvO2/wvNPvK4JMZ8A9mLK3IAVm
	OTBYpD1nenAVfGWLBIoSXrz3b+wqeGNqcBZYYivZGgB2GlYLmEmziRfiMzXhIUrIwZbzEQVuWYJ
	vex/BMChCZoQ6d2v+S3IVmybMbPO2KspYzH/toOsj68lu0dhiGSY+3lngm+IW+8e9VOBnXE9Yvu
	n+LIT6fytNLQ4bSlpctaUkInQLPdIYuSI=
X-Google-Smtp-Source: AGHT+IG6Qd+s5Dj47uH44Ehn2d/9x7xSJZVYXnhJSJXZveA+y+4wfxtpu4SpIgXoRP2hVp8DJJ8v/Q==
X-Received: by 2002:a05:7300:bc99:b0:2a4:53f2:339b with SMTP id 5a478bee46e88-2abc71dc4e1mr128069eec.21.1764959820420;
        Fri, 05 Dec 2025 10:37:00 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:36:59 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:51 -0800
Subject: [PATCH v25 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-5-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=5639;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=OCuz7V+M7YoLMlr9nykYwyPpo3rzVIx8l7pyFIqF6qo=;
 b=pKTVmXD0+ULu0yFH+CmJh88VOWgsUQ3haPocycMyt7OhDBkvHe02JbFz1qcHdH7rUWnzwJi2L
 TcZTvS+AIVNBYytpAH0d/BPJQyme520Nt/E3cTgzP8qinAQbh1au8Al
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA477140006
X-Stat-Signature: nr4d1foj7mjy1664xotritq5pyjsh1dh
X-Rspam-User: 
X-HE-Tag: 1764959821-778037
X-HE-Meta: U2FsdGVkX18dLZUf8xZ0+Jp3feVgCTioKJ+7axwkPOZh+VtSi6I1Y+aqEhadUg7Lomq7U7nFsOSb37kyoQ+14QXdJhcRqX1IS4a2BBGmHq6kBwiC/Gp0K2tg9awCxJYIX5vK2LOG90xiw1sosrVu4swy1w8fQ/bqENKPYk6RXqhrPXyFfEN0AnGaprsZDU4m9gzeTSiFunalaNLCF6Z15Q8C/xCQ3p7ti+DVNdVXz6DBnYlFH9nAOdjRK9Czkhy01CBEsL6nw+S76ZEScniJbRidx2r1G5YrdFbF+/d/Kd6zyf806AaxcN5jXq3PE8Devck6cVS6kdD1eeqtNn+kaxrXKw1Vw3l/mIBb67HyjZ3iH36KLW9JqhBIGxh6ijoWI/L/AHOaEZ9sxAmKQISv8IXFeYxQ0z0fyljWfIrcbV1Mzi15OIVr2qVS9Yfti3X7pl9o0Mh3aW9InAj9ZMgZNGtQf6YUiuuvgFaEJss9h14m+0T4bDFMMs4Dtbg82bErx4iuUytjw722Eomw78zipFPwK6RKCaFLeMDt7ZflZJMlyG/8/5ve9P5FxjyPwrjDpDFiyvNe8KiQww7M/X21sP+i+hGIW+m+u+6xJnc/ehQMCDKGcHCKRx/CtVCmDHtRlQMeBU0mUYjaAh7VMaA6Rp2kHiDEdnscTxYfxBHfR19v9yO7N6XGGqtecHbmGGzCfl6Gujcuf40llS8tqkvKc/iyPkb+OJyv0ivAG9azNeWbVIB3Qs9cbBi+04H1Rot2lx7OeIdKRlVOYCUWKd3C5ED/OIHW6djELWOug2kBsUN0OTNH5GphQwdhJWAT3iRroTsj5djJsApyvWQ1rXApzJUThD7KcP0g/TrI8QQ+Ijokf4puYOveLSIBUCtSpAp4lwt19cRMZNOFx6t6aztIrWwknZmwNOPV27cN+8PvlHWxP92Gx4OXvsp4BqiA6gJ6BCDWVOTd6Fx81NWLXWc
 vAwuUdhv
 HJP79vtDiQFAf9s+XcIS86mLVTX/QzBryHY8Gp3fx4gJotbMJZqvodg8OZ7NwErbMw2ERWyb7Sf9uJv3V8OPgWHNIJHytIumR4alSryw8ZPOMWEt0HrrinML7IzcQlMMS0d/fzrDweLPC0IyQdtewqxnwQ3Sxs6KR4eHywV0m2auWs3nnZ3me5J9pHizcv2jZ4XebjthrzVQqbmxfofE+nNmS92FnJUCpmgumP46htVgOBk6P2oX/HR/0PAJPekA9GiVukbgmsaegZhB4OoAvj3q7fH0YJwBvqCCiWEpntyORPHinsTRNNUpIEF5vLfGyBmPUJxB/eaZU/z+YvPxBrRlg4BCx0yHFSlCHLas/cNbvmR+wmOF56DqIxx/LXvezlrfGzcQ40LI8pdX3ayWEnYOaxv7sebw87bO2bLQjKxnvuh9MPcCnIxyQpYW4E9zWDw00wTnBm3v2ERG0gDNY+hk0D5MrLk6JpwxKqEXTIQ74gjU+8j2ZFZo9q1z4eIzPuayqaBLLWxQGK+vfETUDxwBwRJnl8ECY5JqsK8OfJsPjBDctUG7oBg9SaaUrNR+6xu3iH1CB93DdEi4=
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
2.45.0


