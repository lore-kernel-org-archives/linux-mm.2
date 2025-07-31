Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05629C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF796B00A8; Thu, 31 Jul 2025 19:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FF36B00A9; Thu, 31 Jul 2025 19:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749A16B00AA; Thu, 31 Jul 2025 19:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61A6F6B00A8
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29A911A0AF3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:58 +0000 (UTC)
X-FDA: 83726129676.12.B6B6AA4
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B3112000A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=O8TknLLY;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6drP593z29xMI89gvu5M+jS4WxL01Scui7bONmNuleg=;
	b=ZfyR9XGqV6M6fqKBhUeOOqYS929Jb4UPQzJvub3mYdD3zSDQhssltuB3Iob+nvV0S2ceO0
	C3FHuSN+d3zb3Byw8btmNtzaDaOk2J0J6cRr7hKwBXF/0yKb8A3MsHuYj6Q/d219WV/vEq
	EryTRnboW1dZzFvQT9IJy3tEY0KLZe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003996; a=rsa-sha256;
	cv=none;
	b=7MMnstaC6G2xM7jh2RXdjyEFRlQ2xXSLzOVYn298uqLGYvmB3xIWPP5+DSpZzKZr1SYShC
	kSAVlcGx0M98DqmGeT99YnZkQbK3X/qBpuvqI0MR0kpbnovYWCeuBNbOdagnsxFdu//ycu
	3ANlAhSrWAOVDL6OADrfegj35jeaXyE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=O8TknLLY;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b3f80661991so1934849a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003995; x=1754608795; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6drP593z29xMI89gvu5M+jS4WxL01Scui7bONmNuleg=;
        b=O8TknLLY1NR2nH7LFTml3WeVPjiZX6odoKwbiq5gM7mKqh476dKKaP/vzaSpxuObuC
         j9A9vEcLOkk72v4/oYCGAIZX2Ir/0H0TzV/bwBMdICQbnShTQD9oHogU8AJ+hmUVsdGT
         SpdI85tQLiZMJAOW175HsZX15/GVOjOlpD5tG7AHd27tKeLkZS6HpSFdkrgmB75oErGw
         F2V/yLIlV4PmENOqQhZ/OqZ0GyrbF3ZZZjP4MoIlYS1qz92b7UFWBjQ3YWaAhDlAStku
         OCqoWAGoqr0bBYeNQo7Jk6HQD2fi0oS1h2iVXReKK9XHD8WqOacIiVq7nIxRJnTXU5Ak
         dk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003995; x=1754608795;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6drP593z29xMI89gvu5M+jS4WxL01Scui7bONmNuleg=;
        b=lXzJywe3i5MFdaci9nONhfQg/3vqgGl9TB0D3OqWq2MY+EJ6i+O7nxNEDx48ieWPDn
         fuSGQfPdOVHW49a6iecaBTddcUosEwoIjvfZCA7YxLEucAOTbUM43fUZZffHXDrb/+Hq
         BTxQl+PEDWQvxLpws2rd6cONXLE+dfyfos8UcYysYNWZPBDC6SbaohqRRFaPpzMm8+Bl
         K2npusjzrnYmkA6UEQLNgsUe4Cc5QRGXDyLkv8ww6g2/Gw/VCmwqskJ+ECZLupHxZW8Y
         UeLv5+n/sab6TD8+ztDyhCQJjQ/YIq0VZjvx/pHtKb0ZLLxWvDJ7XGrLukg1eIq6oo/x
         Zecg==
X-Forwarded-Encrypted: i=1; AJvYcCV50uvoYnvm1Z1QrYvaaK0671StgvMdalxi2YM/VuvBhwKHR+SA/Be/eShMSqU2VFN3LPnExnwGZQ==@kvack.org
X-Gm-Message-State: AOJu0YyNQKBI2SWcTwKM35urlWEBUHjQaem2cWCG8y4tm9FSne26OUwa
	5E6L3UZfjqLK99Ey81EfifBTeWwiuFSfmnzlPj7RzfeGAEFR3ZslAFrQrZTS3N1u/Bs=
X-Gm-Gg: ASbGncvIWFOT/VjXqqjwG48LESAxSQCLnE4WyW1fk9/eU7Qsi4yPz8t71YC28qaB1o+
	44KW8atQpzuWRoYH5AXBXBVHmhDJcuEaDZMqgRJBsUjC8I3hXDtfKXHizHxieGbsis+thJhWH0c
	UT6TLDJr8bg7+Mk4eN1jLVnF1BWyFeIWr2q+Q83l4Cvrgv+xdier0BNTjxjgzvUB8YrfxPfMhqX
	c9ytlRn/9PkEVctyolyjQnVV290rzqbJWDJLybdye0JXdgBUN6q/Am4pZBdNlbKp+XKhByoGc13
	+oTgKs6AskeRSpAORQwKjoGiZpUdsYGdoBtOluLTK1CkcSy5Wv/dxGNErDnCBokLgcAZrTXGxEb
	Cm8bYIxoTG68uzdt1QOyNZuyIm4hgEF2G
X-Google-Smtp-Source: AGHT+IH7vMO3EbFgAJuyrBlH6R5eG6dOu5eBz76tDBcW6kTLLn9DPkLPS6BBiyL1MRPWuHCbkg5baA==
X-Received: by 2002:a17:90b:4d01:b0:313:aefa:b08 with SMTP id 98e67ed59e1d1-320da5e9cb0mr5144663a91.16.1754003994931;
        Thu, 31 Jul 2025 16:19:54 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:54 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:22 -0700
Subject: [PATCH v19 12/27] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-12-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B3112000A
X-Stat-Signature: sgk3855jmc3frawo4856sgqk76q3t4i8
X-Rspam-User: 
X-HE-Tag: 1754003996-261923
X-HE-Meta: U2FsdGVkX1/JQLhnajWRa0T9H20aBgSt2Sptqf3PFKKoCiFCKWN+iCyWpL5Nl+GJIal7AyR/BIgs1Hh6Gps9uxrxUfoEKYDijOArS9gVabxVo0wkKhuW0d5leywBFYh7Nn3g3xwnVnJTcTB2R+jmRqAVbgJUMuLzUiIORSBD3W9Zkt3ewFiqIHUy1YAEMY9f1WQ2LE9awrH5fuJ3kASb/iY/6ZbLAEyHtsOJjWI2pA7FcrWmj06NY7+pLr2lFrwQXVOLSlzJI/hwV/Q+rMZ4/Jpj7AZOCQFn2BwHY3whcb1yUUZq4B9dMr+YrX7QuDEgtl6CJYBo+SyrT6uGr2eMrylZjYEeZ35O9XRoJRDW+LnzndhlUFP+20DoBgbwb9XHpBKbov8uZVvLNhUB6M/W3tRBocXmEy0iBNP3qv3IFCnlYKeZEobhhsDrn4N/wz0cVdjjBN7muLUvUI4Tmoy6tNT6MDrlpsxrYFv2eiU7ffC9Hd96N0CmXv+qLxgExtpbRVhtVaPApqMwzcxrEK8CTRUoQzBUnnSq25JUrEGeYiZrjLDaFEEfTtEIUmnW/ruKQvFYNS7MRVhzOKAlgcwl14RWIGZ9mzi3lsmzSDZQ1S0jYygMIfevR94Z+iz14Imm78WI2VdAburPC2XOmL/YC3My0y4lbgBbM0mwVRUinU4zjacdZhjH067in5DkZUh678N6iV6VjnGE18MbMUenIIWFVHN+ZX2xL7pmx4w18xzuUU4FTHrqzoMBkIfJPPLLxa0XQBWFPVnL7/Q41+6wtmxq1M0jTAXgiioTexeGeEfkIY024MJl1Cy+BCMJhW296kD9Ekqit9pYwxa+3BlWsFufTFx7Y+M9qntncm2kpXaktDmTILiCIrDYB46CUdj36+gAdSErLYMf91TYelQozeBjYieOF5zGj7FSOBoEY8dB6V/G9rsEIFJ22HS1r41PfSQEgejgJXVpgCofKn6
 WTGlH4X1
 VzUBmI7bowjBST8Ce6ssrR7GRpJWbyu9/NFxZ2w6PjPqMifrIZBNSs9nV2Rk++gO33zQXNnLSY9VknDMbmfWE3MOLFkbEefkvuZMO9RUjn1DzUXa49mBlXmKHy9SiDliPJ4jgYk3j9YRmGoooL8lNLCyYdOwWCTwxJ2PQeuJT0ETX2fD30dbi3g7xnvvZINPjMGys6W6guIAV3CmPMsqTDYMO5Wm1jQ+JwuarlYrMvv04TcKTjZqol3QAGt+nZIKRiBHtgRHBgnvitVGc500f9ZhDuTjnkCZE0jQ/1C7x+L65I6ngQ1dhDLHkOQ8Rsg2Ko4kF3BGtMwRljpYx7IFOHRdhIltFoln6MZsgFJ8kw41QxCt+m7wf66BzTBmICObO8AXvdDnYmz8oVs4pvUHvcxXce9ZpbR9kcAViMUpuWioQRPlV+GBg7m72xb3QholGf+LRVXVH+GEl57XWsxxrNxkquFKruga+RrefDEAOJ4U5IqD47bfgkvF6MvZ4Zxz5vYYNcLc7hEP77kUmFgrrLavWvv7m2C2bkP2iLoGncwvGaU0=
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
index 0c81cc9a2b6d..f747ad469c7c 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -7,6 +7,7 @@
 
 #ifndef __ASSEMBLY__
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
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 2d009cfc09e8..a449218f174f 100644
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


