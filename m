Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BBFCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8570F8E002B; Thu, 23 Oct 2025 09:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808D68E0002; Thu, 23 Oct 2025 09:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFE08E002B; Thu, 23 Oct 2025 09:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 498928E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:26:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 244F9129BF1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:26:12 +0000 (UTC)
X-FDA: 84029452584.27.965F789
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id E87A014000E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:26:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OS5JxTvL;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225970; a=rsa-sha256;
	cv=none;
	b=Z45kl5HNdYxIJdq7sm2Hc2VoxYgm6AKzlQ+BkNeVa5nRlWAJB2rXA5dRivJ0J6JhugkGIH
	/rON29jEa1oi9G/houwB5/kcIQSqCGdefg/KA5F8khBEuX4SzCbxilSaHgPZOPUUtlm2Ou
	l1ysPUkk7Tq/rVgkR6tcPh7S30lL9nI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OS5JxTvL;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
	b=Pr6e4SIUcK0wbG/wy/NHSfHUS11tqHcF4EYnvIn2prlD/X2PDGpRRC5dcfLM8ORZkoDIYp
	1jSb5af9oSQWVWumLmSe2aisQ7Yw8Wjh4X9lfH6r6bMzxGvTxjq3hZ/ApNkx7p0CAGaQT2
	BrsUfjXS4VhN07qJqyg8hvmu8sBTqSQ=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7a26ea3bf76so1100536b3a.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225969; x=1761830769; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=OS5JxTvLayF4RYru7kCzIv4Fl7S2/yxGp0Zeaainq7ldziNwaOw1UUtcV/dcEY6D7i
         Z3/jIWTAt7ZSrN6ctIoWnDV9WUrBzdYwtMHy+944IzlJziGah0jKlcNU+dfBcihCxwc7
         WVfZwk6NEeOnnvtTJtD5TZQM/BulH1u/RODr7A7mKZwvB66CHMDM+0P4ojUBLPX9+jB0
         OQ4cs91kI8YtTDgthi6xyw+ivGAE0HuThpIWtgRem203clNauSiYum0loybSTRhOxW2S
         ZqpbLs/In5JaV/rChWM/hNGg66NYy4NuX7Pp7Pc4Dby7E40DwVyhvoWrW6MitW0LAwth
         pg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225969; x=1761830769;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=LS8ttkni/tJbXgKW30UOFz4P26yGNqacJDujf+M8mGFp1TSfaO75rILV44VzXV7SH2
         lIzavfV9qIvO3ioYgwomdMdwRD1BKzars48gS48Eeuv5UeGZgOAJFKvBDgBmxqZu3MER
         hQzGlZ2AAlbCwJWLNa4f8YU1ynGlZYHaIYhuuPpvbyJJNIgKKuHHIuUds61hdQhonBEa
         aUFFTpsZC8Z2I3HPpwFF/W7A+lyePWno6KVYV1vwFh6n9H+JdZEZUGL0vdFbqMNWNxP4
         qXtn+im/4nDRs6NIK+O7U/pvGHZPCIDbZ1FMT4IKGJ23UBcarnVIqNjQVEz7xHUR2po3
         bYHw==
X-Forwarded-Encrypted: i=1; AJvYcCX8HK1xG0GqRsY06dLlwt1LqPGMwhBCuMaOKR2AMILGArPVnNS/ESIFOiORgqT9FRW9We9+ckCaMA==@kvack.org
X-Gm-Message-State: AOJu0YwgsR7962Mr83HD5tAPISlYW+UnZKzpwGav901PImERDtuCGxoN
	YLBVsoRK0TuPPP/iztNL7u0h2rnvQEtPHWlY2xj1zKWkUtxT/i0yxGbUUH/kR64SKis=
X-Gm-Gg: ASbGncsZVkxKEaYBYuuz+rhybUfCfkbELJi+vOKSTFNrwfykjsNvVACSk1ZA7nX24Dg
	7Z9Dxr40oTVQTblBUVPGPnHDjURws9RVryhtgr8Qo1C2UwAmzahWmDNS2AATIvqMFDH2rW5XzCv
	gPYEKZXbtefp1MbkH3SIfieIYvXnVm2BIJR9I3MQhOxY3JWK/SMKAPQ/e2bX+ga7UQjxL+7ZZ6W
	KY+YUeTsdv3zWZyf5sztxPVpY6xlkFzTcT+vscQk1g9+gLxvn081Cb0m2HIb5aoUdD+HnzQv5/j
	grOc+VyS+MH4OxkK9G5ZjFrtCctpbdNkVZnnidHZ70uhmXSZh9aPfh/Sm8GGVzzNgC0ihq1wYGk
	3RlT/YonZefw+z0zYBthlnS56xaxAB0aFeJgBoPTMhKYUOGZAFhseSGXAJlcTZoeW+ib+rOQe1S
	iumm2rInLKqdL6jpKcutHw
X-Google-Smtp-Source: AGHT+IHkhpOHWlBgDScLCO9cWcSbBp7U47616726QSwyOPf8K5or840bOUH3V2O7++QsjKHvru9lOA==
X-Received: by 2002:a17:902:f691:b0:290:a32b:909b with SMTP id d9443c01a7336-290cbb49987mr324481725ad.44.1761225968653;
        Thu, 23 Oct 2025 06:26:08 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:26:08 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:43 -0700
Subject: [PATCH v22 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-14-1d53ce35d8fd@rivosinc.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E87A014000E
X-Stat-Signature: 4y3bsskg4fx73qzd5fp4udxkfotmic5x
X-HE-Tag: 1761225969-23074
X-HE-Meta: U2FsdGVkX1/tbjENLQMwsBbBj+2CM8MU0yJQ/8g5gWBN1UCe4+BjXIleWHdKhrjjWjmqO3aF/JxKgpbjcPq/owy/Un4zGChol4FVVPewGCTcWuZfjT6+E+OeeNWPIwzfr/VQkS7VYdGpKSOp4sX49GDiIjElfnIFtIPfKHextd+a5jk/JPfSjo666g9oMbYCBWkX76J+y/lJjB6cu4ZQaFWnpXldU78MyXsB59rwLe9/1uaeoTKEIoFsWaVB24lbEtN8g/d5f3M0Rt8cDo7/p7+XEzZ4Zan0VJTHYUvge5PiVWwZ1lDMOS5jI18YHuvfJIAbaT6GTDSwhSJp/DUPsnA1JxhUIUUqRbh/8a/cPAlPdqO+CxLhEFRxZBVaJvWHAMIR0tAiN/5ZXLH1QCL2aOyqrujDYKW2jyeyXJHvMTKxULsaXIMA81DK4xvrHVfFFOkJYJ5pv1wF+u7ZxlMFbSImmvAiXjiivvVNOYb7OU6zv/L+9E8Gtvw6TJ9l6/rTIdK/EXykixENKpcloqxgOL6xYMovn1uO7IWBkODh6RpSjLZl6UaCItq2dlfaW6pEsls32h9PUiSDnuFH7MUwHGWTAD6cL8EAxr24IB1hDG9SjIswgF8pvSEFnDPmFCJv/9bISxWHQCM0pU39gBsl4CidTtBfspuq8Y9lIHmNvS/uP/yS81zxXdMR3l+yun64ENsTwxtpLdQvhwngd3PAv+jCuoTLEdwnpitGaUfRwqL8GOlaawRZas09Sk1ZRNqyYO6GFj87hWjWFGUuqc/zQ0wqfL3uCYmY08b06BmNw6vnQCpU6UDj9kHN1sbKGZZgLRa4UxqfFcCl1L4x9QdPkyFtrbmeQUqgrQhbmKBvu17l6XflCMWBGPnph4Bs+x9aitNXy729sYS6Sprq83jrro6Rm2SrTES7e4zSsxyiJOZn7vfNEQtRqnNc0H8JsfintEbtMiEnZp3wIFBw2yS
 yHwLwoLm
 0stnlIUWOFsANgV4vCAkoxx9x7VEpLRAyEb0wKO5C9wpWSHyFCYHbn7fiKW8aClLRuL6q+0pTrH16ar8n0muVRFF4X8oHtmU49xwKTB/p0gaIxa9KSwM62dfYL43sNapxSD6I32kZxZY2cLHeIcjpSV3B3dGAtSzOLh9Ws4mTyj2stV3yYOBlyz1xUYPeT/OinxAJNujRtp4RTozzghvarCw8DSaKKeCz+vBLSlR7441Oj/5AT4UXERgcRXySTQ3+ozDEznoAgvhqcUWoNY0KO7OrRLSydBPehd6bkysVVyyXAK6xa3800WeKJJ+rFpka18/mCLABP/nmQH3hhwzrHOU6AI8eDDyV8BuIrW1gdqxhqf1qOkfQabb+sh9xHmPzwm7Yf/DhyKpBcweuC3bLGOkVO9NqBe4dfrpiBLTvCPYRsoPTLnr1PomfQIE1iH8JPeUUxeAEIvGU70IbcCINJ1w8d9DcEWL+OYJt
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


