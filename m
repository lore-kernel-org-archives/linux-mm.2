Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290E5CCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93158E0071; Wed, 15 Oct 2025 14:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18578E006F; Wed, 15 Oct 2025 14:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFC78E0071; Wed, 15 Oct 2025 14:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A53358E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63486C022F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:19 +0000 (UTC)
X-FDA: 84001148238.02.69D13A4
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 642B4180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TuCNP1Xs;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
	b=7d0CJM2vx6a4k64mcqxUas84iUk95BpZTQw7jLx1B7lYDrQYtVThZAju7IEwygdnNohIB7
	GbIBUUp4lY+lkavGGQWjIFrg+sEVs8ivTBqS1apyzcussJd+019WNGCP57SsZB8I/bFY3s
	9i9JdVr6hhZ4HQaNlcGpVTMcx91EWpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552057; a=rsa-sha256;
	cv=none;
	b=xB920y+peRZiVaaRSZZkRnHJ3zfgZ6VM289H3kx8k1Vel4+Ldf1Pu6KNTMvAcOiN99dEf/
	oMv5aJf60VfA2VZcXwdbLbsIUVuSSA5xSV90EMFa7TNF9494WcHTLjr492qGUc3I/Exier
	FLaF1CAkf9WayIYHKwAFCNyvHyaK7dY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TuCNP1Xs;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-789fb76b466so6331605b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552056; x=1761156856; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=TuCNP1Xs1sA7rZVNqktr/xhvO3k8egKjHerF/L63+x3d+SzL1BxYALXu5M09WDc4WC
         ItyMBixqrCQGoQUR7NmO2f443rVXJAJwcvelWh9EN2I9WbxMbLNUDzl3QYwQElTrL52M
         hL81JWmI4dzvj/OTLFkBtn/fUc6jSVqBmjntQM3EnmJbmTKEXjcCeM/6qWXIsXnmcg4A
         /1YhavN0DhYyveL5xiPQWnm/1qViLxFuHH2dzY2Ahvhtq1PuUVouIDLsy76E7Lw7ohLq
         Tqmvo1bByBxz51CToPA51IBImBzAhe0epOliuEdpU5XUYZ997vZZMOy6zwfmsCLBfWiq
         xWHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552056; x=1761156856;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=n6WrDEnSw1W+deuon70uLhv90O9HtfSV40EYaGEZL0xP34vT5O4+y0QQYupSNIjJ/W
         3YdIzqOmH5qi08+6kCASpO2cJQ9AcBH7j71BBvvdXH6axLKzvuRF32q1QMKgJ36vDliU
         NMlEpCdwXUEmgUa9SivbClVLlHy4yKkwXWyqMGRqLuDgD7H0TORhWZYmKy60cESiDg+a
         h4+4ngr9iTwkex3heYTIAhG2ILMiOOeZ+6hMHnceobyV07lR+ztut1Od5M5kv9E1OePP
         AeO+Bqj+dosYjQgObcrp43u83IZE8hZV4ZEFoxQMoFC/ZG5STG45IMQV97m262RmPYQs
         Y7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX2D47lzH0HD5Px5rA8E44aLOGezap0Y77sS3dgIIqqTufcINH233ZA9ZJkTDfriHE7o3krx7/MA==@kvack.org
X-Gm-Message-State: AOJu0Yx0Tu31aYmB2wjYqLo4UqmXmcHljhA1Ttxh2GSMauavsRfXCyUi
	pJxbkH1jh5n6K/ZYPHnDr3gZ1drLyKRVTAFjSU24H6tIxRXBnkVIfBVeTuVX55rPMIyWyJq/ual
	IT/XP
X-Gm-Gg: ASbGncsoqKjTLOMwCXjlgUE84Ecfq60eofNF9yVnyFgzZ75EBl9RxTTEa0LPGX0lZtj
	EYeQK5O4NNUqvcWVNB37Gk7I7ylyFQ1kMdY4++5jXwKQfYcY7u9hmNGXAjY4PIlsACsjoZy8B0i
	s3mjFmJdRm4KMrfPu4710Fl+P6qvvFVI08lvV7dWPZv0mn55ZaBbPbBTn9+CH/wSZY7PAg+4qh+
	i4OARgM0+IqnknHidQOwZGcsC5lde2Y6dsgfzvW7cZJFB4Ulhd5hioNNF81CC89teJW8OG1x97A
	NQgHWuKfNI2nnTXk4YS8ELnD3mj1DnLDl7/Q/NOJg0f5Un4depppp/kCMPHoPB9ydwoF5asV871
	VRPFkaC76Xfj3xueOHlqhLFb9VJDrP1+toGOtLUD8E/OhQHMTfHePU2LAChPDq1FRiIxzksDx4A
	pZw+OIy8VZ0vYtoPmpIC8Q
X-Google-Smtp-Source: AGHT+IG4LjfUDohZLnLSo7lCYfj2WTS2/5mQ4d3B6uwh0g3AMw9ydijD1oq4L6QlSNqNyXKLM/ozHg==
X-Received: by 2002:a17:903:247:b0:266:3098:666 with SMTP id d9443c01a7336-290273449c5mr307286085ad.32.1760552055799;
        Wed, 15 Oct 2025 11:14:15 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:15 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:46 -0700
Subject: [PATCH v21 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-14-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: 14arrw1khi8d4pxhoqnaouyxwtfern8b
X-Rspam-User: 
X-Rspamd-Queue-Id: 642B4180008
X-HE-Tag: 1760552057-199572
X-HE-Meta: U2FsdGVkX18NyTUhXw1iY6Xjht1HxNnkgzwZ9QQP7BR/4OOCmVau4ebg2Y/zCnASKtOEGsdo246CDadqBrnFWhWZvJLMzTc/2UXH5qCqwDXcTNPcWDhWgnBb9Fj01g4QIq6tdXuoF0PKv5EDg71vNYizmgVR+AVwTNAFqF3fO35I/c8mvaWdwoMFnBwXBHGUaKlagTsxcFK39LXy5DFSPo0ATfvf2MHv4tBw2mIVLEV2WLmvgoRdZOvjk+VS4hTDjJEhuxTEjhBa3WvxvEqrGPlSC4st26sBG+TQMwIg3zoKKAzxKlxuroVfIbTNPVytwyWHThI0zShsfolvFr6blS4Niwp8gsasPe+OOeZMPW66TSOHCXYT0nzR/2J287Fd6FEojjHmTYzlRfaJYPHHUkuHcP1RrYUqJSp83PoE4OnHPrzebGrF5p9BvQ3clYCD7aSodHVf+VWFeCCSNa+KZ8eVQ6/KECLotLiVlivfLmyW6O3w86OwZsiJ6wU83K4wL3q/OGknxMOmHVhisF8VFzHvCxbBMNornwT605PUG57Oh/dGctAtvBN4C735Q1pN8QAXl8DD7F0I6whabtjtXHz3NXMzYldkYz+nBmQ3oLMtzYBLE+r1vYClLk0jd4SUTnwu5OdqWbowusoy1bZuC+T0N3WGRWrj+w32kpkwlEmIftuc8BNrMCAs1AFPyv0mKfGikDfdvSvy5ej0mbOU1lBRekNUoDkpibVIHNUMYh77DcdhTViCiLhSDQVU8+28QTn0NU+0hRPuTW13kPCKNai8KP1o1OhVcbkCuRNUok7YKJPHOOwAL4qBfJYP3KwmnNLIVeHYL3CKuQ0ilV2HPL7Fkm+ybASf5eMnRWkn8fxuLeocjVhTuYW47XCcfY4su5BBHjzCFHjTCc1b6bvILko2spDjPMnCEsgC02UnGDGvpQMjCzRzOD1V/ZvIJl6QvXpwzhojdqU0un7dbXV
 Ec6ctkKs
 1X8CBC7KjSbSWIeCMm+IZdtHmjq4hl7uiTTCb+L8yAENtkZ4gyKc0yoicdJtJ2EX6g4ChCPkQ+7xqeNaiHPWV2o1RwSEFYaP5w1AEgSVbaGwYpFBUEMbiMc89kX1wjqxyBIzpTausx2daVoE86rtayKHuUiDl6Rs08eX1LfNQ6nz5Uetbz8ufeHps/2So2Z0k/uqGZU+Rcn6buUCjsIB3ICuqntYV+Hwc1C1iSSA+UmchZ+/VGswVhzigmKeuyIc/jXVZAUej6jDYM/CADrJhtNjQIzO9FF8RpgBDtrV5r7M8rnAthv5t9dfCrSBsTm7yg2BJ0z7C2Q0Rp8W+ltMFxhEfQ0JsvY2qpfk3Gdp8FZS2b4GySzDtXxToC+g1FVbur8TeG/IpwK77SwVnPm2sGDGcApy52hMLzQ0t75XM3dWo8QkBk0Hv//u/WdHkqiDYXqCU5B4rvfA7eknqCPW7MUIfUVSPNeSAI7+8
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


