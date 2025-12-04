Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADBF2D2A522
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC0D6B00C6; Thu,  4 Dec 2025 15:04:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E296B00C7; Thu,  4 Dec 2025 15:04:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7C56B00C8; Thu,  4 Dec 2025 15:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94BF26B00C6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F8B3C03AD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:12 +0000 (UTC)
X-FDA: 84182865144.24.6D3969C
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C300180016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MeIAcxcf;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rt0jdB72FgYkFDTp6M8fR06cHnWx1hT7i1x1jwJM8U=;
	b=PwXvMh4LYcNdKyoLnz6pC+bjrxeFe/UgAOpO3SnWy8COez2OcN+JkYT2MJtG7WmqloI0pH
	I0atyzi7jAx6IGyOGSpqA1CQP7eY3/hJrOshceSETqKFFhCvkHsxyVV5kP67STZS8VlJFF
	CzrUgzvLApZxBzF2NQWUE4a2EO9nY/4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MeIAcxcf;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878650; a=rsa-sha256;
	cv=none;
	b=n5R3NnCJPXlk80doRY1isKDed/mbkxGqTA2cEFdk/lnAeDGFoXYuW+2w7NNVMsKeGsVqrB
	vCEZdMv4wfyaS3c0k13BrKbEZwWLg9sVZHxGfyrPXw8SkrisB0it69AAgYq47xoSmReXAj
	0Mv6BOyMa/geARf75DI5tJ67wkw8mUs=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so1074654b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878649; x=1765483449; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5rt0jdB72FgYkFDTp6M8fR06cHnWx1hT7i1x1jwJM8U=;
        b=MeIAcxcfdfGvHsXdww7Ihw2RGOkU3U9uMejKgOs0GaOqz1QaRQuZ+NG7HneU+O0CYq
         BjkcSdm5du5eRO70aYrGE2YQomPBnrENKGMrk7bciY/xiBu0532sf+Ce39CgvW9QK50j
         oVYc1JLVsgPGSDXB5bYPoio3EpYM88cL09l6vAq3A5TZ+VJd0iK/IZ8AUQO64V8WSf9U
         uimzD/dKGdxpFk9UIJNXLQfQQFpTZh6p4Bzkm+Km/tvX+Ulbnq754W2GPkKKRfjvZc2U
         vDAGz/wv5dmfBswlK0ILa2wxHr/XCQqDATfhnlvm9ltvf/s29O9W2qjjRmFn9rFj0o4V
         WY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878649; x=1765483449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5rt0jdB72FgYkFDTp6M8fR06cHnWx1hT7i1x1jwJM8U=;
        b=QtdNJIzP42DhjguQX5pOBThZ8PySpVareZFlq8DGhJOvg9o1gMxy4Ngst9xa1waOw2
         M2jsFJCHR40jpPKF8v9zZhmSffVyeaCk4wJoJobFFMDjYdlu5thmUSwcg9W4qAYayxLL
         FFfmve0bdb7RcfOlFxMHqKvq80FWteMzIISruuxeRDZOkiFzPX94sKN+loK//nNVr5mR
         TLP9KZ2b/nUmOHz7N+jtdJDY6ZwZSpaWnQ9pjXymuslcsOFnzO5d+sxwLQKqWDEx6qo3
         Lts5ZCsFKWd74hrChhI/02DMjxhm6Qj3tWA1mvOc7Rr7rF/ez7IPDViZ6UaYZLwR2y6r
         Uo4A==
X-Forwarded-Encrypted: i=1; AJvYcCVnvj21irgi4DToDivSX2zFN//2/t5Grdhf5+BmUijFl3K+iCbLD1JYEmQpNkrE4tYp9XqR1ncduQ==@kvack.org
X-Gm-Message-State: AOJu0YwLbF3W9baHCL/FZAg1yCaRNRndL59tP0gCv5gUQt3rfWOgVUbD
	9o1KRtBXtpi2K9MjpgZlKyp5TKc/eZXdTs3a9mHD6/UV3m3rfEqeXLaN07EZghSL3qsnW/lP6q/
	24A9R
X-Gm-Gg: ASbGncsIWGM90JHhNe3YFucAoahWi85j7fZV/dM80/P0M42Zb8B+GaC62KJ/bOvrt82
	fuuSgQ3qYCSrNmeYNggK4Rt/48YIuOJfZRDN5EMZ5pENFe3KI8zTxA6PYDlinBWgrzhOgrUC9mo
	CPN+Cy+9d2ctveIjcFH4moXUlSxmXbyUfBC8qXgaoL0i2ecZVLUb/1UxbbckvM9pJJMK66yTDPD
	dsMueYfWpioiSpL92BywZ2pGp7YoiZXY7jI4/6jtcFRCe73N4UyobkXfoLuUSpdHLM02DwtqXEj
	2SGUXCM/SHmz6tdxTrvx4OJ5pqM4+BVuBpewOYzAR8d8EBTTxEb1pwuxyjoxz6lpDES+m9fsXqD
	bkjyx8aOWkeE172VKFO7nDpA7RTOYZE8lD8WHL1e0KQZgtYCVsgV7Ggk4nTGzYaya+ityL4V0HA
	jgxrKjxae70KS7nq1M4Um/
X-Google-Smtp-Source: AGHT+IHGpQHddB5sxCYVtwMvVdQqjHPAln54HNNO7bKPhU/7dn7Cl8v6zBf3s/ntgCCJMXu3exqBhw==
X-Received: by 2002:a05:7022:624:b0:11b:9386:8273 with SMTP id a92af1059eb24-11df64ba5b3mr2947118c88.48.1764878648684;
        Thu, 04 Dec 2025 12:04:08 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:08 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:54 -0800
Subject: [PATCH v24 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-5-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=5639;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=OCuz7V+M7YoLMlr9nykYwyPpo3rzVIx8l7pyFIqF6qo=;
 b=b8r9igiD4ynXeis91deJbyeeBM6fzG41NGp/M4GT91KFi+gCS4eHyXKZr/h5M595QqxNx5WTr
 WaeUkYp/7EdAn9bCZmqP2TI35rjksp6E2X2VXE//iK7fME0IqqtGENj
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 2C300180016
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nr857qsxxzzhs9r5wofsg43prwhuf6su
X-HE-Tag: 1764878649-819205
X-HE-Meta: U2FsdGVkX18LGrXaZn5tVW2sVr9/KYcmcoQ9yf253D5v/QtUCmFQpw+7MG195yXdmjU1d8k39/rlUP1vuXpF927kyon1CjCPzDqIFmdkjzPdQSrpFJOl1v5E72Plma/qJRipar4Guvsh3wscPNgS+KevN+vPkK25dUa46g6oObmWxEAUhcBw6E8z6tCT2vdrSO/b3ulTxKoRiBN3hQ7uJdRhl1LWDLw0pVhNRMZyPJnwCwzC7SJ0Z1jtALnMZyIpnGN0hRfsHkJ9TuN50BYo+oSbQfZYRRRF6CWu9TON2OnZ/r/V3nHj97VNKT7XHOAq0O/dxi76BS7EMULvQwRyqf7vGDyJ75hYeu9cI/ySnlwbXfzKF0K1IRSIpSYT5o26mHFurlVdA66OMme7JGQOvufPorfPdCyXzJWYaj/ojfyL6K33cQA5mO2ac/mxhJMz9mNVhbt6RNyRGIGCdZH/fTsPmmsMYGTdJk5Nwa+QVzS45gH8L7ctSFboK+wlud3KYSU5KrMY9rcGggB9FFsZxdazGN2Jkfsd1VZM1Iha3M7vDoIFAbEIfmm1fpHixkg91ujoluzVP0t9XnbS/0nAsBquQ2FUMgKxwulRmbQkLY0g9oNOMaabCC85WUwycIWhI3TwXhMp4nhBoRWLJaMCgxmj4lOOBSZbjWrfVa7Q8N7x+dy6UlrfEe0i5Lw8aYJ+dGIAiGnW0sfuxGkFAauLEes8OveeF09+2HTGbkw/vO0slXkCeNTiCW4NtlLQFX4zAzi92LHWrUj3ZaU9C3aPdo6KRKZl2zn/uOcjRl4s4Qx2LLPgU+PHLz3H0lU18T1tNjtUxlbclsXK0gtRnv6L95sTwCdAlVxQ6to+Pgl5InZchu3ycp3IR3ui2mquJhjNkdtJKUdOvFi9qGsdHxTY7w9SVoCxPO1UDMtTtBQqir5/k3wpR/E5kTzlLurR0soqjong7DJWgJyP4RyZIVt
 OaWRHd8T
 6wEXon7SAn67bkBBW7S4vpSaUOAc32a9we25LTHnb/jdfvaTaeCOCcKjvjCvQdKXnRxkT8kUi8oEtnrzXnEc3bdZx0ItJwlXuAtdyTSyXteNGe1n8CZ7BLhCziOc1HVlN8eUKtEZDlfTS6q5FIXV1pY5skH8/4lwJDQVsyQrMHDvbrXVilYiqHMRt6koM9Rq2dynCDoE82QRftM6w4/u5CFTCe6qg6rBdFg+PLU5/GvFbwPxwjCjJ072+p+maP5LhLGXCwW+jelS+EHMT5r7gNcD3Fkguk2IYDmZJyE4+rbSFn8j5X4LbxR8TG91lpLk2KM9vRHQzViSC+ZJxprzx63nVwDmc6tv1dYggkllHiRDBe0xf1JP0baGq+l7A7GuOwlXCXw0zqeTPvKZ6kI/nPPW0AcqSsJ0VsT4dhlA5qIlTTgfwLuwUJyL7pKUuLdfzVOe8THK5w2dw7sNDJMC7bVM9smHSaVvXHifnT19vOOZeob5f9s29ou1aJjtw+hMO5oq8NjaWM+MUk/2WFkgFuYac3XmW/VCLDd4fnpbYrzbWrrBQfhYmyI3T3TG7DUxiQSLL1XBiZLrFqAg=
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


