Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F52CCD1A7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358DA8E001C; Mon, 20 Oct 2025 16:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E35A8E0016; Mon, 20 Oct 2025 16:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1C38E001C; Mon, 20 Oct 2025 16:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06D7C8E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:23:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBB5D1A02CD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:06 +0000 (UTC)
X-FDA: 84019616772.10.CF437A1
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9FA2618000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=d7nB6nG6;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7w6XgX2UWMMwupGZQwAyz3bRlc0H0qh5/wjclMkiJY=;
	b=1hDMqdKbCAlUFBTs/btrYOiVh6pcqhe3dCFk5FBSAyQXZFsLXA4E8EOMKZhGXqpgtZXdW9
	4o0ET9z/UYJTXBJ/vlYn/wp7/QNPClUt4vycn/Fod1tRWlThjfBKqBgbUpQGXtSh7U/T1X
	SKs8cMVU40xbexUHl+qV9VCjX17/4Lo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=d7nB6nG6;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991784; a=rsa-sha256;
	cv=none;
	b=Y9MLEStvmoq1TI5sMN1n/m+Jji7Q4NDzkHFn9WGMsivvaQpAmvEVTANtOdCLvbBQPSdK9j
	XkIUH24AC6VDHIUU7n/Mraa26t9F+GKoi5AXtx3nCwg/Vcpj3oqG9SGjH0L3N/cTT+vgHs
	jZmYX602OZ3tJbgzKJQeeOV1jq1753A=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-781db5068b8so3714046b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991783; x=1761596583; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7w6XgX2UWMMwupGZQwAyz3bRlc0H0qh5/wjclMkiJY=;
        b=d7nB6nG63KxqcSO68SqQ9fI8ldKDNv1Dhf2Az0deMzXOWsdgzgNvSPPCjSQWMCEViW
         5OSCsV9Bf+V2vRxn0YOfXGVo+WaVcSJscsFQ2P1CdFFUMUahm/GicaJLrn8epmLCqV5I
         xU3Kt7xhF97g5Xv2tZ0wdWPKjePHn0xhDnde0B+yZ+ME7Af/Az7hJCS8NJ5uBMXhkfqm
         W+GUj5BH0OEvpx9cF6lBz+al0VUAbDBgUMtfkXtoH0OJXNaVWVVEtUcsf31ljURcoab4
         xqd29AVzhcyfuScap2seU9Au8AezuXrzh0oN7aojVCBc51cGqUwzybskHSuLBhuKn6cP
         DbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991783; x=1761596583;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7w6XgX2UWMMwupGZQwAyz3bRlc0H0qh5/wjclMkiJY=;
        b=fEGzFPN/mcgLp60bBbSwEPXCi6HgjHSozX0q+/im1xMq3hhHofKqVtL9DM+OGV7Kn5
         hkkLAyegkEJYXlRiQMfgF+tdaKAaQ63/DtTn7ax5zH4WmwVMFeiSgnGFgEQBbtQwFICk
         U2d0Oc8+7yjHzeQGdwH4VG9xlPMLNznOx2kNN9O41XFotfhAUL8J3fYXrOsHe5P1vrVM
         OlPI4Vf0uy9WfUxjhP5NTV75qhkL4gcAH+h4XH07Y66h/SdPur18wivEjcxtr0r8EzSy
         xWu7Bmd9nAiXHSTyBa9swvU9nZTu4u53sqw7agXhHJA88nB8WYyg9atlajM1Lz9z44Cz
         aQjA==
X-Forwarded-Encrypted: i=1; AJvYcCXqbc2rixszfBjZkFPvtrPQMLfxroBVmIJ2ZrPhAh6oP4/q0wwu3kHM/zp7oZmRFtY5AEFkdSpSMQ==@kvack.org
X-Gm-Message-State: AOJu0YxyBTNfDXvl4sEDkHthXZ99ZuJ6I2GXWfNLse7ADkF2isVVsj+M
	xr7eAPRp+tKjcEhSKuTAEsodOt3Gur7XSpgpmz/0S84gHu/I5KsLZUFZUdjPxOrk9RE=
X-Gm-Gg: ASbGncsYCnd6zf8UhedfkswYmhiafYg4ucSlnxChU1Nb8XwwlK5tQrCcZARUKUHMAZo
	y+LiaY9VSQ2JDu+MBctigUrFI/XXByZY3jfYBPOI8qG0yHBgGgYngeIjdOk9AQuJunq5E/M6EJv
	CDoBBEVZBtRb4ILZ8HAo+KR7kvyBJ9bCwWBhqOY8GtYs0YwP9S96KrsEvVrJb8qWyQ1VDqayyQv
	Yk8DM88VO69/UeiDsNXxrYiUbHs09t6/kTp+rXF1956N8cvZ9dAWGz651RCSjHBm7ZEQxpSTo9r
	hsDGKzUmToHKyTEPRN21+VTxhRxyxst1CuRuIxa4WuaGBOxB5pkDtaVJsg0UBFrCQP6tG+u0+XL
	zQqbN0YkvxwpKoBpQ893fa4AjLrHHVrhExyB+sASlB3SpJct9FCQ85Cmcxay8uBXw4/RYLIgN7m
	wpD7m+udLaJHg645dhlYze
X-Google-Smtp-Source: AGHT+IGSOt48zZzt0KDrwcUdLzxuWs9VM9+XH31Jo3Q1rMTdv+CyB1oa3q90xhM2i9O2q+BO4YLDLQ==
X-Received: by 2002:a05:6a20:5493:b0:334:912f:acfa with SMTP id adf61e73a8af0-334a864aafdmr18463787637.56.1760991783199;
        Mon, 20 Oct 2025 13:23:03 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:23:02 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:40 -0700
Subject: [PATCH v22 11/28] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-11-66732256ad8f@rivosinc.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FA2618000F
X-Stat-Signature: 8iewxje68xzhqxxd8qpaswrutya3kt54
X-Rspam-User: 
X-HE-Tag: 1760991784-346231
X-HE-Meta: U2FsdGVkX197lHRZdT5TSt317i8vk9qMk/N58xTivYwIukKzJRtwEAy91Q9PGEYy+UF/aWS/jy4JkSVLCAKekbVw+wg7mMaexHlELPD4sLC5Ap133EqIKQMrJYm2JGZwk64NzGdsS6M6Mwu2SGjMvv1NAQ9Xd12JC9CuR47lHRuz9E9/8NCenL5+9C7xM44vAKIfSdFvju12bAya1tSYbopUZrMf5pwghmFVT0r+hSpvKrmciKGOgTLpNRomn5ctsQMr/66mlKi94yiZ035hmr5i2RS1+vq30KRmwGBIe1WP1zXompb4PqXNfORuaKvPdFfU5BGmTsfyelMh1JZr/DyKYuDjVNnSjXbwcq7U3Vju2ySQDcuPim9fvnFio2sz6y6RZq1PACYPUgssMUAddEDWk3J9ctUu4wUtqRit4KQFoo+tNGmT4cxcjq0l4usiDHWFWE7fH9Vgmd1rdrfzokcLXajt8mj30Y+Mrn0zRQ46AHSEuEHCWDvKaDc2EOVW3QhaRen7SmS+PMNsT20vX4HkJ4m5DZPL9B+layvPe1c9zdCpPvsntoqn4vSzTgCPbtF/drkfSiONOL7PqyoXPtgwhjdBX6dpan7JAc5VnVC5BE4RF3TOvZCvkzq8MuXoXZiZX5f8zO8SqHj4NL1Z3/LHFVfQThzeEjRVeXRKSo1uvKBFjhpPd75iy3PXCp6jQ6oqHKNftl95wYZ0W3aqvbl+zl+TmIoCyAGhcYSgswsrtcJWxJ2yJysGpiDBFolBC6V7hhbjEqucGQyEs8tdQLpVbwYPP3eU1ktXSkVrHU7H0lU1QWsl1tVVXzb2sh6DbaYy0H27EOPzBSXEoE1g70j3gkPQ5sBVYaZyDTbAIq6XnH2hoozh5R/KybwvLz97lGSUBIdoSn4XRGBN0oeZ+cCGKSAQrpVlt4pZU8u/oWc3PEHXPHqQwgoR+OHk31kHI63QdMkIxFkF5LK3N6m
 hA5xSeWA
 kG29miu8kU2lNpi7y5MSCgB5G6NXVa161+AAdUSZde11E8R6eoKAPaV6pGSmIX+vFW6HaOFkmsncXb0cHq3P2xA/bZZX7I9p9hUBticawjtf5wyqc4LMvCdewi6L8PqfaGHr6ZHGZa3rmZtV56syxFRlwbkJKAkK2xUW1bvHT/BWYiiDOvALGcBODWjfuvg02m3n0+jtm2zgTiWyng3EdM+cLZpyApCysEJP+1Yc1rJPGNFQFsKyDlFkHv5lQkYAo9/qVmMziLgfWbDMVykTaZza10drXp/LdLBMEIX+mFVbR09clDyMaWDgdjH7X5Ea2q8RToVV/Psu+6UtZsd+LwCnjfT+c0aVBpPGnTFvwHJBzjXnZ3jPyEmPstQV/9nmhCznALZku2EPH3ZadhNycOOoidyKsaSB2qW/1lqkf9ou4tLsIB49zFTCL6zoliBelrznFQ4DOr8RVI8i8pBejEMeYQC6RHEf4/alf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userspace specifies CLONE_VM to share address space and spawn new thread.
`clone` allow userspace to specify a new stack for new thread. However
there is no way to specify new shadow stack base address without changing
API. This patch allocates a new shadow stack whenever CLONE_VM is given.

In case of CLONE_VFORK, parent is suspended until child finishes and thus
can child use parent shadow stack. In case of !CLONE_VM, COW kicks in
because entire address space is copied from parent to child.

`clone3` is extensible and can provide mechanisms using which shadow stack
as an input parameter can be provided. This is not settled yet and being
extensively discussed on mailing list. Once that's settled, this commit
will adapt to that.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/mmu_context.h |   7 ++
 arch/riscv/include/asm/usercfi.h     |  25 ++++++++
 arch/riscv/kernel/process.c          |  10 +++
 arch/riscv/kernel/usercfi.c          | 120 +++++++++++++++++++++++++++++++++++
 4 files changed, 162 insertions(+)

diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/asm/mmu_context.h
index 8c4bc49a3a0f..dbf27a78df6c 100644
--- a/arch/riscv/include/asm/mmu_context.h
+++ b/arch/riscv/include/asm/mmu_context.h
@@ -48,6 +48,13 @@ static inline unsigned long mm_untag_mask(struct mm_struct *mm)
 }
 #endif
 
+#define deactivate_mm deactivate_mm
+static inline void deactivate_mm(struct task_struct *tsk,
+				 struct mm_struct *mm)
+{
+	shstk_release(tsk);
+}
+
 #include <asm-generic/mmu_context.h>
 
 #endif /* _ASM_RISCV_MMU_CONTEXT_H */
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index 4c5233e8f3f9..a16a5dff8b0e 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,9 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 
+struct task_struct;
+struct kernel_clone_args;
+
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
@@ -16,6 +19,28 @@ struct cfi_state {
 	unsigned long shdw_stk_size; /* size of shadow stack */
 };
 
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
+				       const struct kernel_clone_args *args);
+void shstk_release(struct task_struct *tsk);
+void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size);
+unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
+void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
+bool is_shstk_enabled(struct task_struct *task);
+
+#else
+
+#define shstk_alloc_thread_stack(tsk, args) 0
+
+#define shstk_release(tsk)
+
+#define get_shstk_base(task, size) 0UL
+
+#define set_shstk_base(task, shstk_addr, size) do {} while (0)
+
+#define set_active_shstk(task, shstk_addr) do {} while (0)
+
+#define is_shstk_enabled(task) false
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 31a392993cb4..72d35adc6e0e 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -31,6 +31,7 @@
 #include <asm/vector.h>
 #include <asm/cpufeature.h>
 #include <asm/exec.h>
+#include <asm/usercfi.h>
 
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
@@ -226,6 +227,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
+	unsigned long ssp = 0;
 	struct pt_regs *childregs = task_pt_regs(p);
 
 	/* Ensure all threads in this mm have the same pointer masking mode. */
@@ -245,11 +247,19 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		p->thread.s[1] = (unsigned long)args->fn_arg;
 		p->thread.ra = (unsigned long)ret_from_fork_kernel_asm;
 	} else {
+		/* allocate new shadow stack if needed. In case of CLONE_VM we have to */
+		ssp = shstk_alloc_thread_stack(p, args);
+		if (IS_ERR_VALUE(ssp))
+			return PTR_ERR((void *)ssp);
+
 		*childregs = *(current_pt_regs());
 		/* Turn off status.VS */
 		riscv_v_vstate_off(childregs);
 		if (usp) /* User fork */
 			childregs->sp = usp;
+		/* if needed, set new ssp */
+		if (ssp)
+			set_active_shstk(p, ssp);
 		if (clone_flags & CLONE_SETTLS)
 			childregs->tp = tls;
 		childregs->a0 = 0; /* Return value of fork() */
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 0b3bbb41490a..ec3d78efd6f3 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -19,6 +19,41 @@
 
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
+bool is_shstk_enabled(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_en;
+}
+
+void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
+{
+	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
+	task->thread_info.user_cfi_state.shdw_stk_size = size;
+}
+
+unsigned long get_shstk_base(struct task_struct *task, unsigned long *size)
+{
+	if (size)
+		*size = task->thread_info.user_cfi_state.shdw_stk_size;
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
+{
+	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
+}
+
+/*
+ * If size is 0, then to be compatible with regular stack we want it to be as big as
+ * regular stack. Else PAGE_ALIGN it and return back
+ */
+static unsigned long calc_shstk_size(unsigned long size)
+{
+	if (size)
+		return PAGE_ALIGN(size);
+
+	return PAGE_ALIGN(min_t(unsigned long long, rlimit(RLIMIT_STACK), SZ_4G));
+}
+
 /*
  * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
  * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
@@ -141,3 +176,88 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 
 	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
 }
+
+/*
+ * This gets called during clone/clone3/fork. And is needed to allocate a shadow stack for
+ * cases where CLONE_VM is specified and thus a different stack is specified by user. We
+ * thus need a separate shadow stack too. How does separate shadow stack is specified by
+ * user is still being debated. Once that's settled, remove this part of the comment.
+ * This function simply returns 0 if shadow stack are not supported or if separate shadow
+ * stack allocation is not needed (like in case of !CLONE_VM)
+ */
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
+				       const struct kernel_clone_args *args)
+{
+	unsigned long addr, size;
+
+	/* If shadow stack is not supported, return 0 */
+	if (!cpu_supports_shadow_stack())
+		return 0;
+
+	/*
+	 * If shadow stack is not enabled on the new thread, skip any
+	 * switch to a new shadow stack.
+	 */
+	if (!is_shstk_enabled(tsk))
+		return 0;
+
+	/*
+	 * For CLONE_VFORK the child will share the parents shadow stack.
+	 * Set base = 0 and size = 0, this is special means to track this state
+	 * so the freeing logic run for child knows to leave it alone.
+	 */
+	if (args->flags & CLONE_VFORK) {
+		set_shstk_base(tsk, 0, 0);
+		return 0;
+	}
+
+	/*
+	 * For !CLONE_VM the child will use a copy of the parents shadow
+	 * stack.
+	 */
+	if (!(args->flags & CLONE_VM))
+		return 0;
+
+	/*
+	 * reaching here means, CLONE_VM was specified and thus a separate shadow
+	 * stack is needed for new cloned thread. Note: below allocation is happening
+	 * using current mm.
+	 */
+	size = calc_shstk_size(args->stack_size);
+	addr = allocate_shadow_stack(0, size, 0, false);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
+	set_shstk_base(tsk, addr, size);
+
+	return addr + size;
+}
+
+void shstk_release(struct task_struct *tsk)
+{
+	unsigned long base = 0, size = 0;
+	/* If shadow stack is not supported or not enabled, nothing to release */
+	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+		return;
+
+	/*
+	 * When fork() with CLONE_VM fails, the child (tsk) already has a
+	 * shadow stack allocated, and exit_thread() calls this function to
+	 * free it.  In this case the parent (current) and the child share
+	 * the same mm struct. Move forward only when they're same.
+	 */
+	if (!tsk->mm || tsk->mm != current->mm)
+		return;
+
+	/*
+	 * We know shadow stack is enabled but if base is NULL, then
+	 * this task is not managing its own shadow stack (CLONE_VFORK). So
+	 * skip freeing it.
+	 */
+	base = get_shstk_base(tsk, &size);
+	if (!base)
+		return;
+
+	vm_munmap(base, size);
+	set_shstk_base(tsk, 0, 0);
+}

-- 
2.45.0


