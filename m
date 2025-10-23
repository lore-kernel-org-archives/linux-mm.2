Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194B7CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F7B8E0029; Thu, 23 Oct 2025 09:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86B98E0002; Thu, 23 Oct 2025 09:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DDE8E0029; Thu, 23 Oct 2025 09:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9DF98E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:26:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7555EBD0A9
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:26:07 +0000 (UTC)
X-FDA: 84029452374.26.FF98E22
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8685E10000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:26:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cuDmYR51;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
	b=UEJJiTafsoMBOtBc5a5xpKdWfVY0Clw6eAMf3FoD7E0GRDdW7cOwo8EwP1NoOjvmH2rJuV
	NkA1lRsxuozRzIkHMHdD4qYYeAUW6QBDiQYwkFBGLaIqSbt+2d+CbaPr1BnJOnwV6kZXyH
	/677MieWUZH88xqVlJDJ2gPlnGwGR+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225965; a=rsa-sha256;
	cv=none;
	b=R5dRunKtC2iMgKCwVz958hWVOC0lacC36yPswZ5rcfuqmlLSxsbKrq581z5dB9HO6vDW4b
	IoC7nVpUQTAAjO4I9artevlDpgmbS/eZHWo0FXOvEATLeaWhQGDAutekJjv4KPm4ep6u0t
	6KJdz/ZTCzo/kTCsVBum8vlJqnAe/NY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cuDmYR51;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b6cf3174ca4so538530a12.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225964; x=1761830764; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=cuDmYR51fPy9n5PrQ4MTvSKlBYRqajkYr0O2N/clmdjwPKsHlg6ItNtRNSwPeIZf0K
         vxMjNQFYD9KE6zgTe2NmxlcaTGWst8678JNezwlEGzmEQrVOSnsPKU0p2dn71j/j3ajx
         G/LYmJ/C1gpbm5HWu900B4vffUfy9EysQUPZDYie7OFju8GLiiH5vWZgn4Apwfa4/dy6
         A1qsFNHRB0RvDTeOqPi4yrTPEeSTqTvLJsBHm/WIndBEM+WnVixMsA5rTCS4dcvCd7RX
         L0FFLUEcvYO3Sq/F0aWp2+OqKCKYB/1raijSAOegILmQhmAOjtoiptHbJiqsBtK670ZJ
         j17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225964; x=1761830764;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=gEe75J1a6s6Y1XtO4pm76tS4G63/j9w+NJAOLPqeZSkpfg8/a6UWJMlDfJXsKEFys8
         XQ7zl4LgQZOnBya6r92RxZctavSdjhzhaYw9m9TWyuKnblyqdgHCZuJmHNrrWDwSNR57
         GjHrZuzTdApAsQeBeon5PzsQizrWlt3bWkgdBHt79dRjJFGpqI5FODhvP5MfM0fRF/J2
         bsm79hJLmG7ZWkZQ8E6KDvVL+xIjyfUnvFSNSNrlupZ7o0OZI77DLQM57bvQEOQZRYUQ
         ov/j0UmNJxhUgDjew0hiRnfge9aVWM1/b9LB60000aO4xiJxcfE0EQLLnpSsUsgH3w++
         2KGA==
X-Forwarded-Encrypted: i=1; AJvYcCXF4sf5HL1aSxjGz9vK+uBDHjN95gJJgIRdUsl3rZLXXN7WNi/Ti4driV+zv3mDIu7BxeXLYKTjBA==@kvack.org
X-Gm-Message-State: AOJu0YxAd9LwLJZ20xa74xz/xm7hTvDrUsJreLdlgyur3GUovYwK+51Z
	o94LkWdyvuQfzecrOG0hm7V5wBHhpgmq/TzkfcEeLJxJYiUEgxId/pUtrZyJDdG72aY=
X-Gm-Gg: ASbGncu+fvP9SHYo+nOblnn4K8c2Rnet/0X5xmEcKVU2oNiSu//bU5m3pTXbyYM4fpZ
	dJsi3m0SUZI0w/BQbvkJHIzyecC4fiddDPHbDfU+kV1xZG05g5eoAXSgCdrR1PyY/+EIEwVuT2d
	i5N8p3s3ZUHoMIzIGlmBQVJqeuxYPp/IvMQuBAC+Fw58q1/aYJUWzQjjAFH8iiVSSR7ex0+wlkY
	o3dXyHncY7MbgTXMhqWfh7kqA63bmIM4DnueJ6uIGOo+VSn4Y57AF/DlE+1VjpBuJTFS0WyZ8sz
	9cojOXrVWC4GCBx3h7QhBDLzc33EzjFWbudIapUotla+rPbS03el6KXSk2ydktM34y5m8RXZPi2
	mvJgxpb9Zd0kPOTSQFriqVPn5jQevJr61XqXr5CdANnUQRsgccZjvIBxDSLR+dPeNc1sjj+VMzG
	CYLVrgFJaNHiEi9AYm7WPb
X-Google-Smtp-Source: AGHT+IHSHhFiDofheEjB31cD7iHH7i9OsHDZfn7XLmotrZ1ZDXi21vk18KkxwZGcj6OI1Isc19SQPA==
X-Received: by 2002:a17:903:2309:b0:272:c95c:866 with SMTP id d9443c01a7336-290c9cb6305mr349108695ad.20.1761225964134;
        Thu, 23 Oct 2025 06:26:04 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:26:03 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:41 -0700
Subject: [PATCH v22 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-12-1d53ce35d8fd@rivosinc.com>
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
X-Rspamd-Queue-Id: 8685E10000C
X-Rspamd-Server: rspam02
X-Stat-Signature: opbpaghuh9r5rqeugdkg6rxux13swsyx
X-HE-Tag: 1761225965-393574
X-HE-Meta: U2FsdGVkX194Iqto+tyNIcTggQ92M1jb6G0PNESCf0gKIm4p9rGQrW0up2J/ESrdP8Hd6U41ZbuHHPi68cb+f2qgTZS5/nNBKnQ3En23cLv+Td7cDQgT0iffiUFfsHtJAza632PwLLVPJcy5rXamYYNEsYtXODsxXXz1EKD/k8ASoFgULHGy47Ngv2swUnoOhTPsKwGDxNlpXzolv3MptPBoeuR5EvFa7p5ZmRiEibTFjF9lQ5hUGfOEq5Q35kSI1zmJf4T9W8OM2M8BeV3/q/oLRp4H9o5k5ZTLwT6PTQ5A4m8zSfwH2f6DIxT/66RKpYf0XRLjBYkQFQrCycH7nfVKI8hu0Ajwe/Rf+sCErVcj7BFy48cc8zu79y/ylGW+khYh3NT4Pj/2gqwAECnmHTKS6Dii8n6JQ2Wh1PV3bPzcEEP31PQVgDtCwgILWON1AaAwlCQ4NBpWjlGOjB30+gTlnifxqxIXRWkSn8Ghgk1cfKvW7/JJSM6gSGOmrM789k3Q+0oizdP0XbhRvhiJ0dE3a0gtUcwgTUyw9yVwDvb92k1m7LwYBen+LbWcS+nCAxXjrN1A8HvQMEq1dKwaKNoZAP6A+cjhTZd5F91JV94leneaxmsKTq89/GmzIrqBY+aExTBd0dPud4CGh5kVyhfURiRPldkCKUKbGvCxakLqdYhWzojV+aoqCu2R5QlLaUimk2HO4x5pS0zHUOsHCWoOdznrU57jm1ZbjvITT3QsqRY449Mk3gQImbP95oUQ92Xun2LhMLagsWFGBEq7sYccAH3Cp2UCDyNuERAyoP0SuECrzHJierWXit2q3tdFJtPLBxSvkMdhSZCxnerfUpyAfuxqnVR6gTdmTcysa+Pymv3VJNVfbzL2A69gNTc+dXZA+tWeEk1XpZ1mDEG0Ir6FTSF5tQDKQQjZBqYBWmtgFS4+NMKlygJsBQnskXEv6/lHmEaT7Y4cBAb/J2h
 Jzz0aXtQ
 b2KrZ/aUzae4YjLGkrJikbSMzCY+tIdiyCx4psiciN5JZzoLTFEDlGhnCoYd7WtPu7N33yCt1Fo1M+HznNrKlCDTz494xoOPsbVEQOJToTxO3KNvr8+XiW8FcsniuHzfS+fLsiyKmfL1z12/91X38xL6+HR6VTjsVlN0pcAkIcpeFnBrBoPve3Eirz9DrUHGZSzJMcItjqflT1QwgLY9mM3/jf3sAN3UTAf7n72u42UsRH5xao1qgpix6RIZCQSDsP/a8ctXIWDNf5MCXxdSDsOAWsCgdj2hx2UsDCJwrj5JOB5Kba88UgI9NQ3iCuO7LFjd+BxYONn6j5ohnYIztfI9yUM4PLKUx5nrBLxucmx16r7pIJVaLz4avlY+TmTPbcsGtx42ZDzJuk6KtNc8QwqkUGcTWWZ9W+qX+EAeX26eHkhEb9/m3iha0XA==
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


