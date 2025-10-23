Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8674CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4708E0022; Thu, 23 Oct 2025 09:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854308E0002; Thu, 23 Oct 2025 09:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A71B8E0022; Thu, 23 Oct 2025 09:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3A18E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13B431A0B42
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:51 +0000 (UTC)
X-FDA: 84029451702.22.24D16E4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 162F4C0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=a3cp6fii;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225949; a=rsa-sha256;
	cv=none;
	b=MIlY2AFt6Ne4C2kSDpD6cuY6D3tQEXON9r5tXx3H6m/eHkRWIVw5jOFC/xcGvixH80upLG
	Gi2bF7SaSezWyFJJHFz+4gGfiKLawg4/z0Ag8EpYrIc2z/2VZH1+XJ62ISvH3O+yUC2l11
	S+smllFjJTtVbeMSHVuf1kRuUsGMZ2A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=a3cp6fii;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
	b=I1OSLRMcY0qZ+INmH1uwEo+YNe/PodPA2sgZ/ZxsN5B5F+ouQrBVYD9wgS/w9xTBZbG9bY
	E8XzhkQSjdtqahGzTQnz/VhPkumoHt+1EYrF+tryS9tXKcYE3dD3Xcu3Q0rLaGwrY9NxML
	5hxcn0lK7wt8GfNy3uR4CIsamnZhDA0=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-28a5b8b12a1so8351785ad.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225948; x=1761830748; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=a3cp6fiiKExRB6G2a7GTSfBDm6WWo0sgkEqngziPgqhFgZ6L8jngxyjLn9Z2oo/sg1
         5qUWYZyCZqyapjpKosgQyybRohxWBIAIRfHbglqXN31CQ2jPfcSKuAphfU+rsT6+jbA/
         LKcxgOkklq5ivdkXBIjZdnmdrpcxy0/nYlAwXB1BZL11JtfCG72UZPWZ7QLv+OAbmMj3
         X/CaDKJoTI+sXKGtcpOxwoBQbGQlfH7eEz8hRYb2Qwha+pul5hO651ahuBlxwTbFY94M
         xaxBzSjIIM1mPHuyn3Y+4qVCi3SHi8VTv800g+LWECRaL4WWupBLh60+o1+SkIxuMfH9
         LZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225948; x=1761830748;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=bFnYCjwN0vWq1BGMFdvgJqCTiIjX/RAcraYA2YYCHlMQxHcliruBMNkRF4FFzPirR3
         5milDAMDJ0xw8QHW7v1zEaV1HIccyLX7/0n4EJjSQAhHhneITWB0oqmqXCQtRyXBq802
         cn6aQVqZEkv4uRgmQE/CRcKGz16a0A0PiGz2jS5R5Q8Pn1k6hun2qQOTk04/+Vc4uPja
         jN28IjQR9yr8U56YyPwSBGL1eGwdHk3GNmF8oyYGLCsMl4X4VxxAqxjYLnYz2mZ57li9
         98msX0GQR/6f1Us3OEQxeu/WapTL/wVFcVKSPZ2PbE+r+S0diofBGH0GVa12szO4aw8Z
         VgCQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1DHus6Ses03x4scY4yPeMsef4sLK7fDB0tYACACKaFNozL69cQVw8z4rn1wOcZVtodaKkP3bDkQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0tWZ7zV9+Sow4l/h3I6uheQIbmoZFSp2rMJL2aSSuJ9FyFMBT
	cVVPBOQBX4wsNNQek4mdW50lNmN5BjsiQJYhU+SEw56YD7QVDjybdKcO5FAlyRWPnFI=
X-Gm-Gg: ASbGnctE7e218gnTGz8bUQHzSGRmaBOa/IDJZwV0euRfUxNeb4vl7MwNyUn6J/iIWsn
	AwvbGp0bmSLpk4NPO+TLeCShRUI0EgYouh5shMQtG2nFlMcpzTLGoWpXdo3K3QoRSmYP+78OU8t
	o9bndw9mZoyRf/hnkTcqloohqhVFPjkuJxY6tQiCcv2wlwjnn7lKJ46l5ixoYlsbQGylDHtPx9K
	yd+j6QZmMCn5ADqijBh8+9hs1FqYHePmkoIggOnTPLoNp2IJQd96otavn6WvjjPwn5gbBUonEKq
	/3h/SGadXNJzCgUM9b7ccBX58YxrltFHRMwjRK3+zq6NraHBDS/fx610E92I3ym/azZjDvhgesZ
	t1KDONwjqvQ0laTpG6tA5PZiZ4XL2AFFJ1Kz+DXXPmLOCYqRLbjIorry6uKvJ4Mzi5HME442Z1S
	1A7UdtrCVkOCcGfE0NPYt+
X-Google-Smtp-Source: AGHT+IGGeyByVZi9LlLT0fNwxqrlXTExffsSyaDXWOINMagHvH+bUAZMmRvtjq0TzyLk0jeTa9n2rg==
X-Received: by 2002:a17:902:cf0b:b0:269:4759:904b with SMTP id d9443c01a7336-290ccacf11dmr325073985ad.58.1761225947927;
        Thu, 23 Oct 2025 06:25:47 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:47 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:34 -0700
Subject: [PATCH v22 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-5-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Rspam-User: 
X-Stat-Signature: diu8s6bo7amn3ompnkfgtatdc3bueyxc
X-Rspamd-Queue-Id: 162F4C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761225948-916564
X-HE-Meta: U2FsdGVkX18VcfwD9lmF87I5OHXhRsFGCnqbCvzPJIpNz7RKSImkOFkSq906Spalo4WKeTOfvqpt1E+wJVjnm6M9b6K/ACw8ymvi3B63IdQezvQbSOR6HrDbbvOZzbq0tBIf+7pZWxrlz8S8XDNamGrCm64AQ+ydtPhwcmN4bCTtGNnCTWnUgR0Ef0Bn7lcxX91r/VdV3sp1czH23/BbciLj3pYGuaS0O3j89pA0WzjpBnRGtK8AY0cDC2nCWK0YKoF8iys9GR3fBnDHaiJke7UvPmuuS4/XSJTGwjPoQ4lu8gy237WAiE8hdZR54S2aDyZZ5axBxQq7lJgM8z+DzABYbn+AALvDTualo+gBxXoktDWVJHfMFljPlYtDAd6kS+UjubCbriAjNkQ1fWmwaeUiucpOZfw+SRQzo5SOqieKruCnRYzQPWFoCTVvqHx/6rPR7WCl7ZmBaEYGchjYRsi2VtMYmrAm0oqcCTAwRPJ2QUYVLlXZZ8JjNLFSSAaNtmPrRtPyqEHailmy6sDVTSb7yIqoVG7WNbXyto0AYyt2Q/SthIbXt1vxcFnPmKj3+LSmPFgNdFVp+r6qC2GNvcKJY5kgAlqVVNtHL+UdOlDqHtdCHgWe1yq438Tfxk0hsq+o1pqpZX2gKjFPO6fH0HhgjFw2zMfhez1vri9ZczGeOAMLMTpl68jhr4fM7Hk99MFiwsQYiKq/NDdp5Fj0V4XaGcEbfAbPrTQ2pt02aeOMcdMFKNfewbQpkiqa+LaOJcvku5PGr/kelI9Avjn35G5pi+aoXFF+NVm2R1LrR3FrY8AdXDsu/3YPTfATuCJSnnZCa+o1CLEiUONoiXbAfpcb8OvpHSJCSjeFQmMUN5mj6yw9vdByKDDmCptKb8W1PKT0BOxHr9X9ve9ZygUAr/uvMHQXl/nenURp2cjly7ZhyHuc+m2JfPa9NifK5XSww+QLEAXVapUEBhJnBWX
 k48RhehF
 D6/SDULMvt/8KFSjrt+CCRs+baK/bv9S7cy2NLBjE1UG8aRXXrTd/8XhN6Em97vLMEo0MF9F84HFeQHinKjbUBUqWl+mA/VIhkMhCiYLVWX2GLzpnJstC516BxgeeppwNXB06M0qze4gXTU0AEirZNWIzlqNOGyy07Mw2SasSyq0kRrPCdxgPVCIfXlPUSIqFUTzYdiRAXZzU+Y+eSP3T5SRS4cAFvy7U3rWjaB4R8wwjlz1mX4S7XA1wW9kORHEAhL4vOLgS6vCDNkfj6H7PXJZNpNlHB39RTkKuLicHcc4m3LgK9B54Dem0RL9Z1ybKC3vBDytoU25JcKyo/NaF7a36YSxB9tCF6rX77bHaURwbUCN43SW3EEWus/re2vPjl7C1mlFp2mJUjmE0xxnSn6u4mpY+7QowtehohwkELzS+6tG71iTJADJcIBYvR/7ITO11+jP/yZxEmuNsW9D2Nn6Mlt9u7nXfHa3OrD2W9NMGBDkO9zB4Eq+7TFmhXlumejjewo+D2EaPdrisbZxEId2LYw==
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


