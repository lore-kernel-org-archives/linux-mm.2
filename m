Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53638CCD1AD
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D155D8E0029; Mon, 20 Oct 2025 16:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4A28E000E; Mon, 20 Oct 2025 16:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC8A8E0029; Mon, 20 Oct 2025 16:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87CBE8E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:54:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 508891DF43B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:05 +0000 (UTC)
X-FDA: 84019694850.29.952322C
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 509754000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=e7L58ApU;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
	b=SUrhdaD8RKmZHQJlwmprtv9hbUamDqyDewJNW7FQmrm+LgGySVBZxZUKVjThLG4yR3XS+X
	i0dmu0j3VuhbnreKtGuXVGrqf7Usl1VbjyRjP05/5lf/L5qwn5sxUlMDLar/yBRM6NVyc0
	r+eMZLWU5hiV3qo5GY17zMAc7R8fKwg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=e7L58ApU;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993643; a=rsa-sha256;
	cv=none;
	b=EO8kG6wm/EBbaK16cgr69Cqqhlqoc8lwnI/yQaI2lvm0ZUWm7J61ofp/9tZooqoPLk9ZTf
	109AHsFSPG4wnTISOZO4qBNEGUJkneG3rciF+s4MSCWrvr9VHh9GKFZof6C2eolF/2TJRP
	cNrO6bkskizYu47cpn8h5HQQrnHyhdo=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-79ef9d1805fso4455988b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993642; x=1761598442; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=e7L58ApUW8Xvor9CDn+F1b7FWIgVpgqrgGV0r1EELpfxm2bzUpBwysDo8Gt+i9hmPy
         Rg0bdc8/sB5yhXc0m9AhDMWIITQPPrFEl06/BWKxkJ3qiKZBH0a1o6/h2A53pmC++tRu
         D7b+cgBrLqu137/YYAOMvFREFzp4ZRBTd5J1ZYn7NAA79/zXUfe27ckDvApeOjET0E9f
         HV+tBWqhguMn1p0G9ary5d4z4dz6nv1D9aIZjpfTVMc6hncZpJnLT7N3fQPLQbOY3fAj
         iNZlOgSBzRUXdVKwEZxYAyTdsoyWT8uT5hY1ahbx2b9OD0XyVrL1TiyzOM49V9bga89A
         wY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993642; x=1761598442;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=aQSf4YqQ7AHhUIiD7L7Fv1T+yYsJ208GCXjV3SSb/TUruIuDCjU/u/mogbLFxWXIVM
         JU5bz+8iPsmD+srBpSSWCu0xpdsuRae16g8s5RiWLeqqy9v2iKGPAPEDiEWP7D7fVG5W
         XAsgnLVyktcLSGpsZP7GHwFXc5Fzub7t/VKawbAlpcg7GlW7Ym7JjKdONjLEw/nFMoJN
         hjd1ThMF6IKFW4pfR/6eGonRFoJJQ4UaZ0BX02/MxJOfBeqh2TXvcYgQVMVbkW/SZ8s3
         m1I883h91ir5wpycx/dDB30Y06GMAZqc+baWCB0A9L7OI5uX3gpV8yPc+hLi3Eom6vjV
         dodg==
X-Forwarded-Encrypted: i=1; AJvYcCVzyRjLJ2et4fpdCHrVm89wPBmoTKk/Edoy0oMWHRA32P0Swoqnn+Nfgw7G2oHm1S9PTxpcmuAVvg==@kvack.org
X-Gm-Message-State: AOJu0YwGUcNnEm2Yg+vOsU/Ki1TEeYNg6vYADi8l+gd5aeGhggDZgshZ
	SM70vQRF7nQCTGajzt/oTuiGyDvLs0xrI49KNi4MGRJIiYV9svr3dUlOzOy+jue60Tw=
X-Gm-Gg: ASbGncvhZASL5S6+2bqF7d/pCwq29wDWsm5/03RVBwyMnTd08vp1nAyjDCAoem2I/Gr
	paHfLsXMymQRWuB6xja4fS29mIawJozTL7nd3GR4tAMgnW1cXyhHOY8qlMY5qGkdPKRKpbkGSOs
	eifWzGl8hPquKWPv8O24XJJx1v7benwrItFJOoB9d0GCkJMrZJx26XY6sxbAAsdubzg/n0GHrnK
	NQ1lbllzKsjkglxETDFVulwBSSu9WG5EVnGVRIQxVYYNSvNNJNZo+4Hkvbp9oAkpxUIjcxXYy3+
	Z8Jt2IvbmMsLrc5BMrFDSlWWga2VM1Yj88A57n7Tv5gcyeEuFcpKDJPlhUTt3BYnCHAVFhNIcr+
	rErK3K3bqL7SvwfvlpO4xfc7NnZQS8bX8pm5CUE1/46RHTUyC+CPcpEZyrC6wCb/ZMVrTOvlaLf
	tYezaR3KgMeg==
X-Google-Smtp-Source: AGHT+IEAEUh/3+mrUCxkToDhGHSlb/GHtZlnKma+EKr+w9z8siQQ/d7o2nfGdhsNfZVMtYmFlpLXaA==
X-Received: by 2002:a05:6a20:939d:b0:250:1407:50a1 with SMTP id adf61e73a8af0-334a85763b5mr18020677637.24.1760993642111;
        Mon, 20 Oct 2025 13:54:02 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:54:01 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:41 -0700
Subject: [PATCH v22 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-12-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 509754000B
X-Stat-Signature: mhx1xc3jjoxkm5qg8gfwwo7kb3jxi84u
X-Rspam-User: 
X-HE-Tag: 1760993643-10441
X-HE-Meta: U2FsdGVkX1/4jMb/bWnELv4poMj9GzSe59xqx4rf08JwRh9kdbiqj/0BYFpQigvk9AO0hIcxp9FAia32QtqPn9hnNp0v3NxsoBd5KguaXRaNDNeEXtiAZq/Wv1zwX2ul6n3W+7sPe8SJdmlag2UDCIXuuPqEr+RdA2vFhRVp5Hcjtc1Z2AtnT2FJWwfUdB9Mu7CaS+W6G59+H6l44PSwEU379gjn0vKns/qAFttbDbfjJZYffsNfGLV5oHGjjcufKJwL3UHBKqnA/zI4Rsw9mfLcE4hzN6VlmJzap2nLGg+9qtB3XQwbn9ovsEn59UcKgW4gyOhHRL7Zja0tHOjfdSQU3tynKumh0kdB0/7Yok8HgnTU3Cml5vj8PayJ+Y9OqWbK7uvhHmM1QOyR0JYsmzMJSv17JPyQ1NP8lTucpJTg15+z9ypY+HZhFhX5X61ehPgnGRoqYfFWTLj0RKVHF8pwfKloPkgLz+x1mu6GoE3aNSv7cyrR+Vm5V5IsTQ1r61p/+rY5oZPEbCPGZONDt865M23j+Pz+9UMtEu9e3sIBxInD6fxWjNvtnEFP6RICJFZzk9o2gzrWI3VXOSbvDZeT60pmlQ3eopJ/W4tlI6DGbn/jYqSS7XC6PXKqodvpkt9z0H4kB0kW8C4hKoGDTY0sEuZIE9DfrWi5lZPOVyG+pWjHkyTLjlrZnDplRBZ7FHhcxqHHzw4EcF0kyh2YqGHQkHZ/aecIz3NHEH4POMsgMpYUlFPYZjQOtQauXP+HWfx6I0w28MKkUnUho/z0mfE0m6ZIw8Ogr71Cuh0+hVTRGhyCTuhJmmKt2uNph3m8eibYS6TPHnOwzThj7Y5LGnh/AfdqiVp8LJIvi43Iqc4PqiDEOqrtP21cvlpprYT9BF22Lvykon5KGmNKYTL7fH1kcTz+PB8ApzDcdpGoYxAkfbpV744wwFMtAva7mkHSVBiKgRZVoJjZauRhCuK
 sdBDo0F6
 L6UoGr62BtT0/dtE95nj/lsWgGXlvv7yoHB0thBJvDIR0YBbzAyM1SuLK4oEHuxNnqOCIIcKHWuxjfRWhIUnPhZKJT3syCckru28IGoGZnKMSnLU9lspXRQBKogw8aDBtsweNb2bdNlsqmtcP72++SQaxXGdNQp9/YwzqwcuZiAhHFFOlpYU2lBzoj3UuF+0aAos4J9z7nhc35NCfNbClz+Tt9xFzlTXSQG74hRo+AydZ1mh9UtfULgGa6XddCrdMAZBlhpWJxnno5p9pqsgZtbvmQ4B3yCQlBLaCFOf2MjcS3noK/pcTmBYmYS8SN/t5lYdIbMRl2nPswCBC3VwwKGx/+kK2/MT8oz4xnCAx4ZaXmsSAnKoU5XewGFpfQovN3M9QgQcjrRNQICMJ9t7tvUtp+HrGoCSi28+6jAUsLjLgqrqjQkdwXReAYg==
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


