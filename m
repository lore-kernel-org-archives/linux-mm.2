Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA22CCD1AD
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7223B8E002B; Mon, 20 Oct 2025 16:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E2C8E000E; Mon, 20 Oct 2025 16:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463048E002B; Mon, 20 Oct 2025 16:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28C448E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:54:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E46B2160289
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:09 +0000 (UTC)
X-FDA: 84019695018.09.DB623F5
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 25B2220003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="M4G6B/vZ";
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
	b=k5BiG5+pRVWKA8+jTGYjl3z0v0XVhO/rlnOewdcYd5rS1EIlWUUteDRk2GteXebEKCvgfI
	TATLcEE3Q5XJu4r1n/OcGKCW3CLkQbQCIzLGWNdg81z0ectuJC/yR85XHQ/x3UFvjuB4lV
	yDPe+7DaQrO34uMAks9+n8FQbGBbPIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993648; a=rsa-sha256;
	cv=none;
	b=jzHtY0hWrGL+3kths87qXLYnLD38b/ay4wpYL/CzKxxDN5rxKXWxvfcXmNdLz2kblmZXnk
	gSD2WU0YQHsgmB22Rxzf1/fdWA8XmVsOdk+ynKUJSis89fLU8M+RuKd8LXtrds6yKmBqkL
	HSgOzCXWkAlGjpOZFfjfkfcnDlcL+YI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="M4G6B/vZ";
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-78f3bfe3f69so4198626b3a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993647; x=1761598447; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=M4G6B/vZxnn76eVrQJvAkmL2qDJcpt/VGQwhIkQZz3AXsVuJ5KrY3QHLXGWzehncMe
         xAo5URAHlrakSp7JtXSxcU28lk1TN5OKDl+fOMTEotzqItic65ZCbwT7dCJsQyR/OeTJ
         /2m4an1DRUcPBjvnjxGT/0VQmX+5yYp/VUZzV1J/MvXy+iUS3M4z7Kq6lJUwaVMrYIFU
         Zxh1RIlgk3vyBjBBPakJT8Vip7V+qg7YInJJjvzz2nH7WRJ2SB04r+l3ERzq8yxe1yTp
         et8t4JBQXZrHkiIKfjw5xgpZNTKb43ggKnO4yK7G5+r84LXLzeuGx250fVYYeysEzb2z
         1lCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993647; x=1761598447;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=lu+XDR4fHhFEjjHQIkBQ7fT4pbayCJTR5MzbNBXfXGipjoFjVo5UDmVOEti3Uumypy
         1AfnHmE4WpyNrUNrLDgaa8RiRMMyg6v8nqxV5Jgx5OH5j7W7W0sX2NGqIUMuSGKvom/B
         M+eYdBGSt32NLu6bs129L1AjI3tH1DxsCTfGzHTw6eXxnYLk0ZR5TB0f0/LEoPPeqITX
         BieFi7r1T0t+FG3Cs/04dleBeSpvrmxU7CBpXR/7wyaSqJCsFbXgTDF7aVQ+jnwyqz6D
         iPvvabrU1e4ouHn1LkgeQ/AEg++C7rjPUN5b/ino0/Hj4D0CS51bC4ABCTm0u+NixTf8
         6Slw==
X-Forwarded-Encrypted: i=1; AJvYcCUxsyCLgyN7DUhgBP/w16fS7vhQIk6DQ1P40qUP/0BOq6FdnewYXb85l473U/x4wRsYLMTkw0DG/g==@kvack.org
X-Gm-Message-State: AOJu0Yw9y3nm9o4JKCQjgs3/Ws7pE8nkj2mTecFh4tJ+9dcZ3LcOuszb
	SX8++EGiAhlFdR9RZMdv/QT0C/x/8kF49bsLlmlr07BlRthiuEV3mQW1Hxy8CTJYB8E=
X-Gm-Gg: ASbGncsM+lVG7hbyKwW50RIEFm3Kx5tF7ToSTffsJK+mPZaWQtZrbZJqLJIZioC6GQd
	ne0O+IMSPMH4Qjtq0Gy2dW6Jhnjdx4ZKQv5Xl0hqt0okgphmfFn71ghewsZ1BNDXiLaozMFAsOA
	0k3S9ZqrZagodNXFxa2mobqPFk5lBXldEiMarD52wmpFKI6spoKq6EKRmhllgN28WukvgTU5cIi
	D/t5rI9JCkFvLnmTVgvl+mo/1yls2+yFNA9O7HHFH6qdu4Ei3njrwo0m4u6QsOvjF4tbxS2izsw
	LNXeB9lxkle08amyVOXKg6VmMB6FwrxQP0zk5IrJ6tlfDb7bj9iy29W5r3lyyoXUnUQu0v/0sR/
	Ggk4CmOOQUnLHt9VgCuwb8KK3Dswotd/lKewI6jHfqp22SkdPSDLcWoBdLTqfPPd7nFJzOIi5X4
	YZRm2WCD4EHFiklKD89jQro3HsJX6GNTI=
X-Google-Smtp-Source: AGHT+IHELvcZp4uqH+5ni7YX25rEy5pD5GWVdcR48OgwD2pYcBJY7R6nrbQBAf8YTTrlXckn1bZQaQ==
X-Received: by 2002:a05:6300:149:b0:334:a9b7:b461 with SMTP id adf61e73a8af0-334a9b7b47fmr17918005637.3.1760993646987;
        Mon, 20 Oct 2025 13:54:06 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:54:06 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:43 -0700
Subject: [PATCH v22 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-14-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Server: rspam05
X-Stat-Signature: hcjryn1shfqi4kticuan1doo4eezfr4x
X-Rspam-User: 
X-Rspamd-Queue-Id: 25B2220003
X-HE-Tag: 1760993647-415103
X-HE-Meta: U2FsdGVkX1/+cmrV+Tb6KkAiqR5yFWlV6R8jod21LCweju/KJhkIecGZOqpslQQAwK0XDg4/NKdftvs63Kne3+3qB+PD2lqe8G7ouR7QTywo+Fst32GG+YRVlzu1FioFFOFoEbOAmWnLMdvLb9DxSux2TkCWzU52N853W2PuEdg4ixqbTP6Ff2keOKUgQt26h/6bMtOtXzAtSEsOpZZcwf3+elQeZXuhIFRB8WLJbD93IqsojRdNytaEJYJso/pDhJSs/oaqDxbwkPSe8hG7d6xditWMcbBGxE0CuZK9EJ0dEF+n6ZpiNuvMGVr/cg+dtydmgT8aA3NrkgH6l3zQkXUZWZ6tZRiiI0KnM2FFHhY/rE36P0Z3OCde/JSF3/Oz2BKeol9PbC9MW3R0wsbkYrZ0HbCTJPw4sqjQQ17OT/3UqzfEzrrtfDF0hb6CCXe+gLNCPGDKD2jDPs+M7NhcOCsoq1mpfbFNe+JLdrHqzDOXn82xxLIyLVR6evIDFx/pyXwN82oOnf1sY64KrbXtZ/PZnFuqmAxfvTTLb+ywonht6wz9DTirEAH374BAb471em+Zt5ZvoS0EwAlFQgEezfnKmlgj7EF4o1asyIB04UQ1p0DnR0SFFhEOSBQCmrBofLcsYjBxGrsR+OZLtehAkpC7J5veErjlFu2H5RMnBfQ9+YjTnZN+trm1MRFS3mBH0Eyz8QNxhX1GIyT2WE6aLWwj4SWh218j6RiJmQRD0zjsdxbGjB0JBlVIbDjHvfZMnubMw6iKLZgt6FKu/MXymQoKjhkBXKk5bnrDO5LghSlRYfU4lyiHqJp2QIIHC17OXP6xAKL6lbiq/VkYuiVz0UI1tVpe1TCUril4dCz9ujJaXLc3tts8OxrsEbTwTm/RAW9BvvJPeoVh01fmuuGwkIBag2nhekMvQ6amThWtzh0uozSauMPfhZ2t9Wk42ty9WusbJfrNeurojmnbFTW
 nwEgDbAc
 d6frUSdP8ke36GS/jL5rp+QHXd1WcoYkQz26cnJ83yEiNqTVBvKYoF2bGgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prctls implemented are:
PR_SET_INDIR_BR_LP_STATUS, PR_GET_INDIR_BR_LP_STATUS and
PR_LOCK_INDIR_BR_LP_STATUS

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h | 14 +++++++
 arch/riscv/kernel/entry.S        |  4 ++
 arch/riscv/kernel/process.c      |  5 +++
 arch/riscv/kernel/usercfi.c      | 79 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index d71093f414df..4501d741a609 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -16,6 +16,8 @@ struct kernel_clone_args;
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
 	unsigned long ubcfi_locked : 1;
+	unsigned long ufcfi_en : 1; /* Enable for forward cfi. Note that ELP goes in sstatus */
+	unsigned long ufcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -32,6 +34,10 @@ bool is_shstk_locked(struct task_struct *task);
 bool is_shstk_allocated(struct task_struct *task);
 void set_shstk_lock(struct task_struct *task);
 void set_shstk_status(struct task_struct *task, bool enable);
+bool is_indir_lp_enabled(struct task_struct *task);
+bool is_indir_lp_locked(struct task_struct *task);
+void set_indir_lp_status(struct task_struct *task, bool enable);
+void set_indir_lp_lock(struct task_struct *task);
 
 #define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
@@ -57,6 +63,14 @@ void set_shstk_status(struct task_struct *task, bool enable);
 
 #define set_shstk_status(task, enable) do {} while (0)
 
+#define is_indir_lp_enabled(task) false
+
+#define is_indir_lp_locked(task) false
+
+#define set_indir_lp_status(task, enable) do {} while (0)
+
+#define set_indir_lp_lock(task) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 8410850953d6..036a6ca7641f 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -174,6 +174,10 @@ SYM_CODE_START(handle_exception)
 	 * or vector in kernel space.
 	 */
 	li t0, SR_SUM | SR_FS_VS
+#ifdef CONFIG_64BIT
+	li t1, SR_ELP
+	or t0, t0, t1
+#endif
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index a137d3483646..49f527e3acfd 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -163,6 +163,11 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	set_shstk_status(current, false);
 	set_shstk_base(current, 0, 0);
 	set_active_shstk(current, 0);
+	/*
+	 * disable indirect branch tracking on exec.
+	 * libc will enable it later via prctl.
+	 */
+	set_indir_lp_status(current, false);
 
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 08620bdae696..2ebe789caa6b 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -72,6 +72,35 @@ void set_shstk_lock(struct task_struct *task)
 	task->thread_info.user_cfi_state.ubcfi_locked = 1;
 }
 
+bool is_indir_lp_enabled(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ufcfi_en;
+}
+
+bool is_indir_lp_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ufcfi_locked;
+}
+
+void set_indir_lp_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_indirect_br_lp_instr())
+		return;
+
+	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_LPE;
+	else
+		task->thread.envcfg &= ~ENVCFG_LPE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_indir_lp_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ufcfi_locked = 1;
+}
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -371,3 +400,53 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 
 	return 0;
 }
+
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long fcfi_status = 0;
+
+	if (!cpu_supports_indirect_br_lp_instr())
+		return -EINVAL;
+
+	/* indirect branch tracking is enabled on the task or not */
+	fcfi_status |= (is_indir_lp_enabled(t) ? PR_INDIR_BR_LP_ENABLE : 0);
+
+	return copy_to_user(status, &fcfi_status, sizeof(fcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	bool enable_indir_lp = false;
+
+	if (!cpu_supports_indirect_br_lp_instr())
+		return -EINVAL;
+
+	/* indirect branch tracking is locked and further can't be modified by user */
+	if (is_indir_lp_locked(t))
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_INDIR_BR_LP_ENABLE)
+		return -EINVAL;
+
+	enable_indir_lp = (status & PR_INDIR_BR_LP_ENABLE);
+	set_indir_lp_status(t, enable_indir_lp);
+
+	return 0;
+}
+
+int arch_lock_indir_br_lp_status(struct task_struct *task,
+				 unsigned long arg)
+{
+	/*
+	 * If indirect branch tracking is not supported or not enabled on task,
+	 * nothing to lock here
+	 */
+	if (!cpu_supports_indirect_br_lp_instr() ||
+	    !is_indir_lp_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_indir_lp_lock(task);
+
+	return 0;
+}

-- 
2.43.0


