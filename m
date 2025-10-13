Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8B2CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B4B8E009C; Mon, 13 Oct 2025 17:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CB58E0031; Mon, 13 Oct 2025 17:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FFD8E009C; Mon, 13 Oct 2025 17:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29D818E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E88591A04FA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:28 +0000 (UTC)
X-FDA: 83994450456.28.A78CF4A
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A36AA0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="O/Ziqj3Q";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
	b=2IqPwC75X8F7FevjFxdudv+frUEcBiyXBlwaA/eQ+T0KmFEsk6pIwG8QtiO71CfYl32vop
	K5mMw2N9Fy658KcAFY6UKlkiIgtdR6FnHJTC5CkWEnkIuaF+65A1sytF+X4L1xEWCt1Ls0
	ZKlFGT68TeK+waOHGHzjqaiBktKz1Zo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="O/Ziqj3Q";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392587; a=rsa-sha256;
	cv=none;
	b=CTlmTX+pFsIkj1VZBrUAAusNXos2EeN2ysBIvXNhamRdrSYbsh/k6Tw6C0OMcVsUetX8aC
	zQRYRbUuQ+5QruTjGcuDmCvzi+w7E63aBH14tCJXRRs3y+Ekk/mYl6yggar1PEXkgnHdkt
	E8rOGz/AKt6QOSHsX3y4AlUhzYPfvT0=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32ee4817c43so3732920a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392586; x=1760997386; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=O/Ziqj3QJlmIl6wiku/3NFn2EMLsV8zUo3swF19+/QTaHklprtKP8D76UW8Wt1yAbM
         glCpGUwz3OLRENAFheI5vq9Nwe4qrmzmGuTsqU5XgpKQ0A/JpDe20tg+jYbUnPh1wYep
         sOA+pqPxKzGXM7Sd7XaSb4Uoblx+nYKN0Wq1U7egrkGIgvgnfVwFPJE3a5GDtoOIi6wt
         UaC1Ib/comSfK8o00gP/v9C2CFhSUMLoo1HacEe720gfqqcw25E3uL9oX/80DkarneN9
         KiVlYRJ31VZ8D08LNgXQlA2IonrA8pAyZuHJlRHs5jhmi3SjcjKbaybHz4JtpZdZeRp3
         l3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392586; x=1760997386;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=mNPpx0C9rIavcYrF2JzAlaNIK/237iw/runoHLR8UfUMg1COPO+N1DWfNI9R27nNzE
         oCM8UZtZRtVy2Pb7Xl0REMYRv5mwvmRjLfo/E0RzkfhmHH8nWX2b75NzCH1sjbYVpvWm
         SVnyu8hlm6DT8+EudTD4f+ZWzjt/6syaVw7u5VgnRp8WFE9JwChFzwWOfhF8CS+atwZ5
         669luKoNoPpyy92UaDry9mXPeJ1e9OzvXgB3dB0QWYfQwcxM+v33GGvC0049iLJ8BzvK
         jWUzO2+6s6YT643COC+oP0fFOZGJ+N6hgkzRbj6VE0Fkxq+1BSKNwdR62shfSJhOtHTO
         JAQw==
X-Forwarded-Encrypted: i=1; AJvYcCUa941De96lLm7gXl9tovx4GAdJnj2r1nUVcj3poIn814Zt974eIPd8yw6PzaVhUCVUKcb8X+ZMLw==@kvack.org
X-Gm-Message-State: AOJu0YyPM1TBugmNdA8xhX7VGNXzTOm8+gDY+0ihT4GASM1obu2Hn+97
	bVACyAjtdQM+q4z0CnNsVJtJ9dd94D9Aj14edIIosWZSnwfXXYX9Kcl5yMl0HT1JZCg=
X-Gm-Gg: ASbGncugPYgb1HUx/Epi/P9ogD+QCbmkUyxxBSa2noi0bVGfCoe1LDxM53LopXW/RDt
	NVzsJH8HIkVJz73X3YrezwfXuVXYN1N/JUAVPWRu6s7AxD5MbchHVOokwnu0c5yS3uynLsn7WSN
	HgGa8F66tb293JZU6VIUDqyhhDpcUIuhkRNOgtlYBIQANGqe82j3HTjUjmuwcmZWxJlExiRG2l9
	t6+3y6vEDy41SX2VNaLAWMfzpXCztwVz7TzJp0xyRTjuaKN5ujz4Yeprc3+/lT2v0gjLjN8Aetf
	XIrNnCW3LfcsDxUSmUXDLH6SLO/qYrSAzQ1dAcNDUxhX7ajUdm8FRPhTubudWi+RRRvIEc1uwOV
	6iLoY+9c+8HgsTzAQTzVtZWdgtba1DiqKVQtA3r/2d1MNWXOBbu6/Hh5OYubYOw==
X-Google-Smtp-Source: AGHT+IFm99DbiMQ5jolArZ6QqpjKU+XufrXSouepQn1PIXybTWCLhhNN3phtgALmQo31CDavUotcRg==
X-Received: by 2002:a17:90b:4b8e:b0:32d:e309:8d76 with SMTP id 98e67ed59e1d1-33b516fc477mr30058339a91.10.1760392585669;
        Mon, 13 Oct 2025 14:56:25 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:25 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:04 -0700
Subject: [PATCH v20 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-12-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
X-Rspamd-Queue-Id: 0A36AA0007
X-Stat-Signature: c6yfnqmeipwk354o4xpq8qoob1pazsrk
X-Rspam-User: 
X-HE-Tag: 1760392586-262191
X-HE-Meta: U2FsdGVkX192uFeDLdotf3TlL9YSofga6ZdBV9JfVwlW/lxz53n8b84TZRwl2QLttYMd5qGw3xU8UcSRX8XV0VoU40D5Hk2OYG57JUj1pzpIVj0GY8duvVaLzhM2ImsupkdzBgXK9tvp8MuGapLzU5NaUbfL5acLfHA3yHm6zptmh/VAbaTQi6auKj9qtI1p31LJhl4Bv+2WhQ0SDWc+CkyotNLw4FhM+rk+G3Gs0GIaeiTVla2FGKfuOYo+FchPs/q8whJe5Om3NrjHkiOKE0l4lVkjBHTtwZRvliHv5qM1mEOokolb6CzYiqcX4pp1BC5VDk21nHnZMpoYuR1bF7sPdj2eryS8u5ZHqwVeslZ8QyWhNGmO1TPhYPLd5IJrgxV5uWEdjZ3q7ttw3xa3Yp4w6MKMD0rU4pDqqvHYGLYOICq8tT2cnenYMeC9eMrIX9fikicf2y1ShYFu+0E70+JLgOl2x6eqJc9t508FaNxy7hn587dMPySipD+4zmhHzkUaaG3F7qLm+7DWCpimOaUjsjrp0wer1Z2d/AHruLUuAiEQFAQsEDEioaUdNCc7lPhYkqgtO3O7MFX2A13v8TrL4+DUn9lHm1UScFlLSILp/utzxxUeEc6pBjQfhkXw29iFeX9R+rCChCQbc1NTyHABwi0UDPKlZkoxRJnnSM9nLG/fQ+DVfiiB7afWn0cOHZUoSbvCWxc0jkzJh7h44C8hI3Aujs0XSM0DDrR4/cMxZrxVFDpyLOZdFxKk6kfTsycrJO7rAbzOcpVyk/niuXnBEyBlDS1ioy5noVbXvM0qmK2UESyTRyvnZT+MrfCe43HwRMJ0ZIuwSTg6qGC4jOmuNE58Cr15q8K8Y/SbuMf4Lyu0zaet3YIlHgh0k70cPk8LfShrMyQlNFX7CewvquhIXoG1fOrbRET+6hlfHoODtPtgOmAzG3htJIGebr4v+O0z3dI8m5zVkKU/08h
 N0sYaUNN
 9Iu1Nuw7sPIjO8t2iQTAuQPboTA29siIqlAoYCHSVd9VL8iE9CyBmpyYlBUgYTWCSz9d5Adqyb/OhDKUxAkva0rvSX3fRji7QqH4rww6NhzADMlZE2NWOF0I8lGtSAO8Ac07+Tn+SMP7lLZKmSFQ9G3/KFk5WVHduS+BG6rAWY9nd0f2RsOMlmASHn6irRlkpIWBZTDjWlv2HfKcwBViJzHXrixPJy/ovK9YwgU84zV397e8pvrMQCzpJAkiN4m9ioANDVuvjaLXQqofaT/i5gmHvlo+w43mVFlRlt1ErVZz2Z2AHdZBlhKqy3Auuh7XthnnmXae553sy57hS+MKOKoTFMT8xySIiqZf0KCv76Da46MIvfNV8fDFgoAKHC2G7EJwfAdQrDnLCMekmpA5yzIUzQowWegwIAx4MS6ITWSG2+d/FJP22VqI/5w==
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


