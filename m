Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DADED339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC016B0255; Fri,  5 Dec 2025 13:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17F96B0257; Fri,  5 Dec 2025 13:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A276B0258; Fri,  5 Dec 2025 13:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7E36B0255
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 41C951A02AA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:17 +0000 (UTC)
X-FDA: 84186274914.20.2820BE4
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C29E40013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JfAzjpT9;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959835; a=rsa-sha256;
	cv=none;
	b=smQh4crej5BS107JVdnN0e5q8Hr99esnoVD0lGX8mixs5mWpC/QVDZtpmAZjDvgYcm+uje
	UFv7c5VnO6lg9PTCtfwm344ZFA/5vNs0grG2VBDQ76uDJiHzZPL8l78SCoGF6+ADfPbG7j
	gB4RlKDXJwei6IBfcCIBkxou1ZoGD28=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JfAzjpT9;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAn4eyifcNxkK4OJtkwndj7H0VvpEsY65F3VIiHjxfM=;
	b=QpHFKN7G6ed5yGRm33MPY6kzmqyCigbpFEFRjCmiT65gJsuxshPT3H09vqlGMm69MpspdY
	GBxIZLQ+3o2/vNwBiL3HbedxtbpTlkJvHKvaGdGFyrPigOyuVhgvRcOk9ah9PJY/fM33HT
	9Owg2W0uZRItWzdqhc+TyKCeFZb+06U=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-bc09b3d3b06so1401371a12.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959834; x=1765564634; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sAn4eyifcNxkK4OJtkwndj7H0VvpEsY65F3VIiHjxfM=;
        b=JfAzjpT9DcLxE8CLDPHFq9t2Oe2svmjcz0pUXaFbf+kJBI3AV0pzlzYJOA0T99wTHb
         JO7ssI/Eireh2zW0FEpzPvc+naUw++TyId7+VTuPs59GlJSUtnZToX4Seoz3juUyCd0d
         LDgg1uQZNJQBccuzJ0LaYKTWL5d7ji4OrSB+vQyuMr094a+iq/KAijcOGnv2iNg0o/Ff
         DAFfsrKYMBA0BU4Bgajz6ITOCCIyMCyIWkRSfN8jlhBwlVMr+9pZhfToxJtMz7ZqNT1T
         SOcA3SzKfwUlemLMryAkIuFFCYcs7CE+ZBsJhJkPmiAuBGC4S6kQ1F2zogSRYa55tnRF
         eyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959834; x=1765564634;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sAn4eyifcNxkK4OJtkwndj7H0VvpEsY65F3VIiHjxfM=;
        b=welkrcLw4FuarU/YYrpWUqQk8QhXC8QA3WYhFcLiEKXSvhdjfv1qyfu3uLmjp71zxA
         xY/3A71XMob+UIl20zZ4kzmZvP1Bdwy0tX68/PKcYxVm4Yr7sIhG0Rk34QXnjYOcpmio
         V1LUz4in99hg4cjowQWdp0rDq4oy9P3Ayb9WfmdnxpVwsztiKJhF3Bgg9dkt2Y8fTpiE
         KBmCS/gzBLtX2YeaHNNHXq3j15gLfqq7rMrP9h3QRn0VUAMgNfJEmww8ixgsuOSpfGES
         +J10XzVj856a/zFGuQHRHgN6CujSl7fdPMbvMgIo+djyPp209WOlk6jh6nPH/r+U+9uQ
         p1sA==
X-Forwarded-Encrypted: i=1; AJvYcCVmIr0O9dgjxlA8eraTKLnI/484HxuZFv+A0SfxaVsJjKcz+UudDHFSjBv4JPt7rv8Xx7g/ZMyzig==@kvack.org
X-Gm-Message-State: AOJu0YyafB6CG2nt5eqW/DFXV40PC91rA3Ap4jGM/5MN4xNCxKM5Lt/D
	wpMVy3KnvMjIX5ObE8E+hoJZkGHR69GZINQG3V28zxUfmRS3ddIko3wM8XSfKuZVCbA=
X-Gm-Gg: ASbGncvH0fqtO1kQfApyRYrxoEbL+UhUykghP9wHaEVWbfo9aUWzzfOiofxuCcL0OiV
	AonJto37lHovildZL7IutoPYoPEMklFQMUxPqH3HBWjUKNzErRCmXZogH40IOqNjxO6mR5J+APO
	6KFKGIZGeQKi9TkQqWUs5GJeLDnbl6gqXzxHluP4TV3z23LTGkcPeGliSqyae6QxWhk9FDvIXSX
	UO/MSftxgWmNmnKO6A0DwKCWp93x2r8XKKQ1RTfGv4+BgwSrhW2vFDpbT3kgbQZZrVQBCS4oWOh
	pdY0JoIsmlzzRl/ZjfL1ndoUx52XXo9Axxkesj80XXc9uRXVVBrDIgZToULU4WnfHr91WBi4CuU
	DdN68cDg/ns7UX27YOR3Q+BxcPPt44XD6uqm0uB1tEbodtGjEQYXgrv7EhB7lKOXzBVXWnErmtK
	yiywqf6hwsCou64gw+HBmd
X-Google-Smtp-Source: AGHT+IG64Acxde938dcxABEZbefcI0gMEZLWKp4sV8uSZlEc78JPa42NKhLAawHgjmfRVmwABlx/2g==
X-Received: by 2002:a05:7300:680b:b0:2a4:3593:4678 with SMTP id 5a478bee46e88-2abc72014d8mr94602eec.20.1764959833888;
        Fri, 05 Dec 2025 10:37:13 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:13 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:58 -0800
Subject: [PATCH v25 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-12-8a3570c3e145@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=7555;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=UB7DB8iQ68E73LowKHzcTBS0aUXVgW818RL3xhZs1m8=;
 b=jY0Ye8tXm1M4GhO/ew1+Un49NiTb6fE7NaK3Ij5c8XKnBwpoNcxgCErmIAEWbbf2epzEabR5p
 7GGuUVjsjyWDNVTDVqywxntigfck96T1EyVj/8Rjqko1kY7v6dZv7XA
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C29E40013
X-Rspamd-Server: rspam10
X-Stat-Signature: 9m5abgwgxki6gqhhyt6h15a45zpks1jh
X-HE-Tag: 1764959834-581844
X-HE-Meta: U2FsdGVkX1+W1Ox25Nc02CPAA6th4tzLLVFPOTParVe1TPXjEWg8UTEahfkhWhCG84Mdy8GrteEGFxt2KuXhp0f1YVVDU2WoB8NcCsIoHeFyWLDJFrkf83tLkvwUK+LJygU3InBfub1HJMIppcjVKDs9uuZp+4Nm+IoMkyBzqnjmypEsX4POUWTXUNt0yA4gxm7XctigHgW79AawakNTYojKY/uSbQOr8nUhbhlCKgtkf0xA/+Bt95XQceSpKBZ9y3ByEf4q9Vur4+FI9CUX1uPfoV+IaCBrLwdvaZgIEcB5bgE/0uvFt9cYJMKSmzUv5IHXzw4nk9SpxP+Dit2A8SVbyslKZW3XhX4FU5JlKtstcuTqUzw2teVl5fJ+XZLBfx9vQO/fOHkoIY/IlIawd3FWDs7/YmwBv4C+mxnbvfimpfof1vNFhwT+WwiH40MjtWE95tjKR8kR07fwJZiuu1ZCe36aT/KwhEVMFrPgoh83bBdwGx7paYXUPGZSvCthQt0/4SbzjBxBRfg1N5HsqBpIwhJV/hFsfVKjF1cVYkqw1W5YdaNRTDwGcnL3l/KE58qhdDF+zYJgUUl1K2r9HDvRUO0guTSksQl6jtJTx/qMWxXSo2DnglkQaPCc1AwlRjowHoyCfRldLEFqxuoMbvYeMRW3LwJj9Jh2U5Ia+ErB6oPb3nY6P8xxDP0Dt/YGE1hTBlEcOT0q3ECQ+DCKfAhj0trlFMyPN6NbG1boxRyr0AqaLUtd00mIy9sy7LczzLtOXGW8kPWfTdtk5Rgospm0xNL4LTpMUxl4n2Y7ojvPNjipnhKA9yVUQDiZZi77p74JVdVqJ1WSdlZwGNun3Lpzki3IlGScq5JTia2HUXUBjNE1d4eQ4xPQ3odMx9Tzkm3CiIiImiLhKEWZ4uOeRO6Goq1FlbmKQczS4YKTzCPNDbiQtYTiVHjLEC8uG7SIRYhuyYIgdt+M1Z+D1a0
 m2KyGTf8
 lhqVVguNotEAdlMNDu11KCkTfD7r59beTbwmJUGIv4MmAAvQZQk2tNVh9t4UxUuBOVfiYyw8HFpoEYOhYwO7ftHHtYfBcGVSTOxplwR59G8KQKwxvuELZ/3gQ3PquwutExB87gj0FPxt8pk8yIDxwKFSScaQKmorYevihozA/mYUWVPTmkAuh1bwrfOBcXcYMJ32J4sd2fMKYeiYrH9P7X/tZeK72p4ITx15SC1qfb0O4UT8JwRh67qf+N05pFd/RE/pDUtf0dyryLP8GgSe8EpA1gtRKkzWiuVRivukpgs+3phsTIJeuLI2wh6hAImqwZXz3HPrA0IsvE4vtByth0AWNWZC3EncwHqeAxdC5O831zEWQ7Bt4Hm1+fTCAXfoqnpO/NIcKJsijVooOWfewR3XICXLOLcOi5pOsVbtrwahzGESCUg+dloNG7oUgVKtCaVXgTvSTzU1+rXO3sTMdZCCknwybR622JGOABFdBDxzfwTL8xknTBDxgF5bunF7EYDbw9vdZPuNS/8aAwLGCthhb1+xXrplwYwOb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement architecture agnostic prctls() interface for setting and getting
shadow stack status.

prctls implemented are PR_GET_SHADOW_STACK_STATUS,
PR_SET_SHADOW_STACK_STATUS and PR_LOCK_SHADOW_STACK_STATUS.

As part of PR_SET_SHADOW_STACK_STATUS/PR_GET_SHADOW_STACK_STATUS, only
PR_SHADOW_STACK_ENABLE is implemented because RISCV allows each mode to
write to their own shadow stack using `sspush` or `ssamoswap`.

PR_LOCK_SHADOW_STACK_STATUS locks current configuration of shadow stack
enabling.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h |  16 ++++++
 arch/riscv/kernel/process.c      |   8 +++
 arch/riscv/kernel/usercfi.c      | 110 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index a16a5dff8b0e..d71093f414df 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -7,6 +7,7 @@
 
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
+#include <linux/prctl.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -14,6 +15,7 @@ struct kernel_clone_args;
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
+	unsigned long ubcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -26,6 +28,12 @@ void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned
 unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
 void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
 bool is_shstk_enabled(struct task_struct *task);
+bool is_shstk_locked(struct task_struct *task);
+bool is_shstk_allocated(struct task_struct *task);
+void set_shstk_lock(struct task_struct *task);
+void set_shstk_status(struct task_struct *task, bool enable);
+
+#define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
 #else
 
@@ -41,6 +49,14 @@ bool is_shstk_enabled(struct task_struct *task);
 
 #define is_shstk_enabled(task) false
 
+#define is_shstk_locked(task) false
+
+#define is_shstk_allocated(task) false
+
+#define set_shstk_lock(task) do {} while (0)
+
+#define set_shstk_status(task, enable) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 72d35adc6e0e..a137d3483646 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -156,6 +156,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->epc = pc;
 	regs->sp = sp;
 
+	/*
+	 * clear shadow stack state on exec.
+	 * libc will set it later via prctl.
+	 */
+	set_shstk_status(current, false);
+	set_shstk_base(current, 0, 0);
+	set_active_shstk(current, 0);
+
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
 
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 872e0c52e034..0b77b812e4d7 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -24,6 +24,16 @@ bool is_shstk_enabled(struct task_struct *task)
 	return task->thread_info.user_cfi_state.ubcfi_en;
 }
 
+bool is_shstk_allocated(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+bool is_shstk_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_locked;
+}
+
 void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
 {
 	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
@@ -42,6 +52,26 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+void set_shstk_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_shadow_stack())
+		return;
+
+	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_SSE;
+	else
+		task->thread.envcfg &= ~ENVCFG_SSE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_shstk_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ubcfi_locked = 1;
+}
+
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -260,3 +290,83 @@ void shstk_release(struct task_struct *tsk)
 	vm_munmap(base, size);
 	set_shstk_base(tsk, 0, 0);
 }
+
+int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long bcfi_status = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* this means shadow stack is enabled on the task */
+	bcfi_status |= (is_shstk_enabled(t) ? PR_SHADOW_STACK_ENABLE : 0);
+
+	return copy_to_user(status, &bcfi_status, sizeof(bcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
+{
+	unsigned long size = 0, addr = 0;
+	bool enable_shstk = false;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_SHADOW_STACK_SUPPORTED_STATUS_MASK)
+		return -EINVAL;
+
+	/* bcfi status is locked and further can't be modified by user */
+	if (is_shstk_locked(t))
+		return -EINVAL;
+
+	enable_shstk = status & PR_SHADOW_STACK_ENABLE;
+	/* Request is to enable shadow stack and shadow stack is not enabled already */
+	if (enable_shstk && !is_shstk_enabled(t)) {
+		/* shadow stack was allocated and enable request again
+		 * no need to support such usecase and return EINVAL.
+		 */
+		if (is_shstk_allocated(t))
+			return -EINVAL;
+
+		size = calc_shstk_size(0);
+		addr = allocate_shadow_stack(0, size, 0, false);
+		if (IS_ERR_VALUE(addr))
+			return -ENOMEM;
+		set_shstk_base(t, addr, size);
+		set_active_shstk(t, addr + size);
+	}
+
+	/*
+	 * If a request to disable shadow stack happens, let's go ahead and release it
+	 * Although, if CLONE_VFORKed child did this, then in that case we will end up
+	 * not releasing the shadow stack (because it might be needed in parent). Although
+	 * we will disable it for VFORKed child. And if VFORKed child tries to enable again
+	 * then in that case, it'll get entirely new shadow stack because following condition
+	 * are true
+	 *  - shadow stack was not enabled for vforked child
+	 *  - shadow stack base was anyways pointing to 0
+	 * This shouldn't be a big issue because we want parent to have availability of shadow
+	 * stack whenever VFORKed child releases resources via exit or exec but at the same
+	 * time we want VFORKed child to break away and establish new shadow stack if it desires
+	 *
+	 */
+	if (!enable_shstk)
+		shstk_release(t);
+
+	set_shstk_status(t, enable_shstk);
+	return 0;
+}
+
+int arch_lock_shadow_stack_status(struct task_struct *task,
+				  unsigned long arg)
+{
+	/* If shtstk not supported or not enabled on task, nothing to lock here */
+	if (!cpu_supports_shadow_stack() ||
+	    !is_shstk_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_shstk_lock(task);
+
+	return 0;
+}

-- 
2.45.0


