Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2804CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0671A8E0012; Wed, 22 Oct 2025 19:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018978E000D; Wed, 22 Oct 2025 19:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E705D8E0012; Wed, 22 Oct 2025 19:30:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D88A28E000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:30:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94262C09CA
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:07 +0000 (UTC)
X-FDA: 84027345654.09.6782303
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7F08120004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Kv0AAtxx;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175805; a=rsa-sha256;
	cv=none;
	b=DXwWb+LR9P5VkFwGtNfmtLDLC3M5WBRWD7Nw8NqciWQ7xW70tUyceqrlznarc85aBr2MiR
	RHcjyVxqMjA0ewRBRjJ9yHHR6wSK6UWZipyClz5dqOwSYb9rjmUnlwCYJUQV1p5gv5x+Ga
	yRuXZJn9be6yHrsmTTq5pHt5aIVny94=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Kv0AAtxx;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
	b=q9VirP2c5lHVd83UVv2AC4ujJBYJov5PPzmBeYL/3TygNYMtcSLHFAAjLM5zmM8YxFMJd3
	DNHA5ljFlSILIt95XTtQCKsoao0gkcjez788vWY4F1tZvtJYVS8oLiLet0oXmot/Ba3fTQ
	w+LUS34KGQbYoFmgSRaqMgc98pPyxsM=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7835321bc98so148760b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175804; x=1761780604; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=Kv0AAtxx0im2CDJ/BNgPVijcvXivQ8syz5150OXgjmWu428uTvK6985xS3K8aTzf+d
         p7hDlQ5udz27PSX+zrLuv1SoiVu0uePEXSXlluIUlnpiH/VHd6ye3+Ey9DAF8k6HNLdK
         QD0lQDJgZ6MvGSn4W3fd/SBbUk1mknfsQkjG12sT/bD5vDcT9WoT93szHedepPHzl2cG
         XKJl4G+Y/JtTf+2IGZUh/y2lvEWIJGua+Y7rcZlpi5n/2dhiIQ5EFhdSB4WMOb6ijN0O
         AcKV5zvtWtjVHJTBlCYoEtwqvsDJ5WbgjNORjqlSL4PcEW+woJkXAZDbfoaEqOj9J+hq
         IS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175804; x=1761780604;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=qhz1G9A8VWnk52D+dQqcYpbSK6on3w3j2F0KK4+EYeuBmxj5YIBT/mgo9LV6KbP4Y+
         ukSm1CISiMRd79XuDCQxzGy1YFyuQ1sd9wXOlo6/kQb3odTIn+pWsB2r5ZDwy3VgpwQa
         /UXnOK7JWZ+Pgg+jxj6i2kTwyi9uMHFtF33BToB2zu7uYYBKce2QP0RunLSAzBTznq1u
         MZxu0PoYwnRNDrEKz4DhqfUuptKgctbTY7jtL5xm8rRmWvoOCpuII6hfJQDwpU5glvUA
         JKIUfaVPwIcP5s57ybJABRF+Ox2zyWiTG/6+vBAlJa9H9/cy8LUbNC4MIOvbksKDqZU+
         Cy0w==
X-Forwarded-Encrypted: i=1; AJvYcCVZIZb+J0yH4Xse3XU5JPPkglNwFstu6vu3R9mUkbD3pVh82tqHMttNz6Cgz+jA5fpDX3STfTaw3Q==@kvack.org
X-Gm-Message-State: AOJu0Yx/FV+FgMUpQaV9OhoN7+pwDIGL9hz80HCjlYbJuGr6hG1hm5o0
	B64eGkJWmU8dvwXdBK26+Gish/tjfqoGbs1GIK+nvEI1Oa6lAjXSUVU64rQlExNk250=
X-Gm-Gg: ASbGncvwIYsQKRhN3kdh4aRfEnDWo7539m0dEN7uPoMfFBtWjj1k+RcaKWgA2yQnphu
	l484zAdV+ytB752zgxvTz2z6TyU/lPiC/NPL6SXYRfDl95U6cCp1TxeiDkAphKc8Sg8G8af8zVL
	PgmtYDSsGls4JFL5IS5+30GTn+p76C5TLFqK7ihwiQcW21vp5OfceRxCDy4qEfvlNSeEGX2qJde
	9gbB7IePK7L3ZicdGZFvt+wtr1TB1fg2FRZSfzgBwV0TK+1ltSqiUyQpk6ZwTFeeUPtIZY/7dwz
	rH/vQf/oQFDJbDqVq6QeyI7UMpz6b94y1EVb/0FRvFeT1sZgio1YTE0CvYNKC0lgTE8xpSTxrFl
	69OtDC9Cd4z8IaTbDr1HK8sT9ygkQYIKN1HoJKbARZHXeajqFEJlYX8ck1+UscK2O10BN5mngLy
	yHzIvR6ohPBlmnnXVetVeq
X-Google-Smtp-Source: AGHT+IHYOy9BtJp3r3jw6+ozvhwnrlz3LPVqvEs0++iAN+GnPEMwjPpAbTHG2yZDwsEUmLG43qvKSQ==
X-Received: by 2002:a05:6a20:394b:b0:2ea:41f1:d53a with SMTP id adf61e73a8af0-334a8620170mr30162238637.41.1761175804328;
        Wed, 22 Oct 2025 16:30:04 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:30:03 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:38 -0700
Subject: [PATCH v22 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-12-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Stat-Signature: 3qthy86qj5of1ggrty5gz6q4ks34f8z3
X-Rspamd-Queue-Id: B7F08120004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761175805-406162
X-HE-Meta: U2FsdGVkX1/NbItjL5JtAosb2PBesEFy1Bw+tPR3BJh5AEmGxWfP7Wg005VrEHAGqtKN6GzIfKpHiVrKu0KEwiYpXuAJFTsqRBT6WTnGun+zJjsO/cy1t7aWDtDqPUr4cogPOfI6Rwgf2q/LOL3imhl2fbKUBBhVhipXkR9ZzpsBOreTkdqfQ/CDhofITqUnMJziLaUIYrR4y4njiDpKi0vhY/c8X9bVI4Tf+brOpZ1IY6M+2tHhzSmisUj8r3RyzBUtAQLNXzU9I8G5xXf/qKUlg65iq/FCOAatBtipnVNkaconAQpbVTLEcWg5C+33RYmdH78uNaM0LjZM4lp9tDauKprNrNe+WVaBHms1JCYwDdxqZdadMbSXyUp3T9+hYxSM6qTsbEGjkWxUGhygrkN7OrPsDqJj83lLi6ROyvea6oQ9pX7ocf4gnlokv+8yT7gHg3fz95OAWrenWR0Uqga2MpMTfA1BWXFgsardWGD1zJuaysy5Tx7+jrUcI1czAtIljBIiDucXZ569FMehuu1v5KFcXflCAgtAXGGr5Zs8aI966EZpROV8shJIXmM27ZEVxBXMc2VO7ktB7NvaaVCzpUSSeDZotXACC5Bc1ouv0xHso1XfWO9zEpqK1vxuq3V5ICTeiynfNcQpN4x16GAczJeY5AnyjzIdwOZhXiPq5Wj+7cLrFPO5jFBm2cjhRADAJ5ArDvQ2Dk9QVNE5sPg8solDsjgX6Y8nmHrjEBEFj9beBSz0T0MMidXnbeIvWrrB+EueTE8w2PmXOQID++X1xa5x0mxtwImjo9baT14fIm3C5FRKjd0S2D1FPqP0cmq6FdkX4ryxuRhId2C6CwrddnICWJ9BjJ8oj+mCS+JQpw1ZkIaeK4MM7t8YwXjo6JmW2Mum7Mtar8t0xtxH39gF7bJOP1hB1IfKSQpoFYrGiDMgLkWqJxO7HK23CtqsKdS4gYqCQJ5oksnJjg2
 5+7Bw7u0
 DxhZY6om+s92Gsz9iAn3jsKY4T6SkDT5VSiZZy+A781Qd4EY6Sk9vn3ZXGH7zMVvn2I5vJRdS0zq7QfQGidhnaUU3nAhakP7GL8DNnMpeAAw7wQUw28PUJx4ItS7nDmFlRhpJDsL0ybxzLuxFaQQiu/qAyUeM8/xKoZ472G9ZEnXUuXY91HfaosgXaZptYyDwhzrRBtAg69iFkQvma61ibXMxh99HCXrIKxgGJs+5DtztKg6EhUZgjnr9zHyUY3PlzSr1alY6diZu68xZQ0JRYjAIL+0wYeykWp5bgzuMy8/8fDw5IJJBF7AJecISjFK2hyaxlzVs91lBU1ImXCu3jIr5ltZ8LBENLliy9jFgtZ/tU79K3l74V1MdA8HLy0rboyJn4zDUto1QKvNuHzUudEigRwBVIaEsKfRZuU7mopVrjycCWXvQ4QdG5w==
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
index ec3d78efd6f3..08620bdae696 100644
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
@@ -261,3 +291,83 @@ void shstk_release(struct task_struct *tsk)
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
2.43.0


