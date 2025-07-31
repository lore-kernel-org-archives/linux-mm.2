Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9DDC87FDA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D9C6B00AB; Thu, 31 Jul 2025 19:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD5C6B00AC; Thu, 31 Jul 2025 19:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795176B00AD; Thu, 31 Jul 2025 19:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634E16B00AB
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41C74114D33
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:04 +0000 (UTC)
X-FDA: 83726129928.07.91166BE
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AAB840007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=noL45Oms;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAHuKrnww+9qbIr6JM1qL6EAF5HbaPIujBY/570p1VA=;
	b=ZqpAke/2ItUGOy+0wRMvhIJO6BXPMkFQp2dVR0kDuoXMa5zCg9YAjBfJo086fYfqi42xRn
	VhLLWFshQ8nqhN3hNEYqz6TdaeUZIkAIs4JzEG6vTzEV4OWUGk248FiQTuWfmHnXkcxLii
	QR2WZdcp1z8RBXk2qc0TPGTiPkvC/I8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004002; a=rsa-sha256;
	cv=none;
	b=cZL2UbG8As23tlkZLtkJh2vPskMhJye1V71JkYbWtt8KPLuFa+MuM9Izp0GetCsIAUbXug
	ft9tN9vIs4hMZPhqM6VUZLgW4wyu0rut9RyIVQIg40q3mPO5suGhramS14r4AZlBP+tYIa
	6y9G4KAagnkEvugVjyPeNE7jr1jSlRs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=noL45Oms;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-313bb9b2f5bso1515330a91.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004001; x=1754608801; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAHuKrnww+9qbIr6JM1qL6EAF5HbaPIujBY/570p1VA=;
        b=noL45OmsbYMAxFFpIrRd2rnFcszjaHR+BRC1nrqrG8hXc3ZzBn/ENlggaTcqJep/x6
         j+9Ew5wMI6h8hTEtbWiuBbpIHUKR25q7hiQ8c8LPJt3K5Dd/CNrs5X2JxGG8LT83Re1W
         UcsT7hinuZt3U6w5mUdgGIQlwzVdZxK2KGlG6JcyRETSfkcug9+UZtGoJmpLOYfv1Tl6
         Zs4QhtEd1sDXq68E4zQ+fHPsXgepM09+e0Zso9q1oHFqJEm2hH7am9nh/ZazHjIxQswj
         diPcx5F7tGTpr0Uyrk5MCrCXysNlEV6lyBs0ElbHEgW4xb+Ioi2leFMfR0U1OnVE+8/h
         LbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004001; x=1754608801;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAHuKrnww+9qbIr6JM1qL6EAF5HbaPIujBY/570p1VA=;
        b=mTI7lneEyEmXnapwGplNvpbWtYvcokqXAHyfY66IOWyCArIYh6QMv/h2PIOHGvoGjC
         yPDu1mhOAy9znbrvt+oT5D4RK/5OdiEmg7dRDDKLJkhx8HDMzcx2mxN/zzIWY9ZdAmA3
         nRKuwEo/Rn1n8UBChScLnJ5+jODGM5kwXBYXBjTauu216G7P8dkcTBZAg1hTxwLmrahM
         YopHPpq+BrFZJAkjICPmz+W5s7E5jOUjbU4GkS/Bt6+5rGZPtBNwaOd1jpMJF5xkVTPJ
         Q/WLmyzSzrTcpILDUFqoVBBXwJPT/dvgMOsYEOy6r8qaVpAuvNnSPM2KWloYpwG8llv2
         heLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIpkXCI5v4ntYv1b/b/4j9QAlGNPouO4WtBVrksOo87NJN/ai7Kd0lxvrVdPiiJhDEQKVGTSHx+A==@kvack.org
X-Gm-Message-State: AOJu0YyTzkfhXDOUhB5mXdQFCsdcDyGhHXL75BQnPhuguQpUNzX9fS7T
	vp+gaN99O8F1QfxMPfvjdU4OzNC4S8IIcyRIuZv1sZcId7tEsHAGsc80npUzM7suZsc=
X-Gm-Gg: ASbGncuNm4dJqEJYLy9bQDcM/zVZS0yvesfw8VuFhblF35MRv++WgrpwBl5W0d/2PRr
	ibv5zgVRK/227lqNyLZgQ9PFlB4+kcdCCIrGkxfdsQafA7spa338wXcOTc1GkFG5iBmBmjcB0BO
	sEdZKHKMwf6ek9VdsWebc/PonZsj0c1ajgA1UdTg8lO3VHflbgnllnCYkOocFM8ZglPwLA+eyAZ
	uQHM9nikeQfRFtoL+3Rk1uepU8/sDrtLjfRP5Ogvz1U1FOW8l82okSzxFSDb8aQR1tTv+c9CJFz
	bbFA28lh33anwiS5o2Lvxu1mr/4p30bz5saJ5HhNbDnamrwn1ijQ5ElHn+GYI26S8yecPyzWshQ
	oilYb/xccUyg9Hk7yHOiVLCqHyfI6ePLC
X-Google-Smtp-Source: AGHT+IGITqjfmzWEeQlPFYZt/Blqpt3anuEJYNIJBbv7j+NDOPU2d5XpMbrZuqrXio/lQTzz2bbznw==
X-Received: by 2002:a17:90b:4cc1:b0:31e:d929:5ca5 with SMTP id 98e67ed59e1d1-31f5dd8ca97mr10141692a91.1.1754004001133;
        Thu, 31 Jul 2025 16:20:01 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:00 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:24 -0700
Subject: [PATCH v19 14/27] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-14-09b468d7beab@rivosinc.com>
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
X-Stat-Signature: m1az87rjkw5byr1jfny5cdmmijaekw8z
X-Rspamd-Queue-Id: 5AAB840007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754004002-223014
X-HE-Meta: U2FsdGVkX1+UZhVcj2joYJCvtwdHeH/EerIKImefs/UUj4+byePmDCc37AtYBm+Z8HvdgCAZMrv9sDq7vwP6wk2YUTMF5TzqIDs0bzYb5wbGrdwozepyQCPRuTMALti7JcIGW85KaHNTUuww1YeWM9U6KZ8/mIb3auqg+62/G47zpwQ5wAsVfdmHUcbeab8C1MLiHCeHX/mjt4L8/iJL/V5+7yrdXQDTmkYiGQ7UhHrzO7wId3ellBKYUtB88TyKBcTV8dk2T8yZu6JAaqUnHoSxlpnOFgvPq9yYz5CKpCk8+rUmZS+zgmXqFTzRFS4I93BDOoKVLUKqQTqGeaGbM2PRXfCqnXmHjO4S9VrjjYno4k1hhD8uw1IOQuFb31LfQQECQy4VoYU4WrvlniAz4wJAL6zz02nPgvTDK2LIknzs/B5T9ARQr8TV3Al6r6pHGcdC2PKaPyR938FaDn1mrqcltnfuo0bRhWcPZYzvkyR8okgUvxssq/vm4tt2rGS2YFnCxA1sWCjEdnpLK1qi7YL0hZxziZgyur/Z6Oy+kHWHV27iRF0+dzHpj6FzO7uAAdkXpMgV8E1ysBq5/J+isYiXDIdeQ4Sn1RcY2mO4gaDGfs5JT/7EoDC7X4FHVfukaeXXf/NYFWIv7JrYx5Uzf7v2M12Lis5t3yJKGTuSrgEhZn8lMQsZhLS3VCDObagjzbB9d6rB3fzgpCAwG3+RDt9cS5uBRXRpvqklG37HJT9K116651JAzuwvRY/50MB+Rut8pNKR9V+Ep2BnAuC0QZW/WPS3yLAxtDXue8pEVi75H9m5DCO7RQbOfZpgd41SnpsQCt/Ng9rxF/paehPZwqpUJlagblDt538QB0UwuOhj7tSI9A2z/aBM47362CT8fxy3l9DzwIlQwzJ3NuAxF2C2kkMvWESVR6tCGRgxpPnWNbCRHkGi31lo2uo7rUPZuMcvt+hwKY2/YJpG+67
 gvG1bSTT
 oX+ja9Dq0GCXmdZyprEDPuKH6yLjuG7n/76ycLd4WwpOOqwTgwB8mmtZA62wHJrMm3pz+YRZ8knaUzXPos3i3ZbGw5uW5TYlxWeQhKK/XjV9ME+4er3IQ5fRzpkvHEqfNg0igQ2oDKWRd78AY4S930zcdxh2Pn1uKStIRU3WhH+6bJXB0jEzlqcw8ScvDbp13FXUNrvQ7iNC8eL+twRLOLQpfMeHRjcwSxfQ5ixWkuf2Xiv+Gpj6IjPWbG37Snfj7eBWg2VqPxlYl/PMQZV6QFb5dOZal8Fr4T+6RoKf8zZ77ku/LDGrMybTK87PEqScrq7Hb92VDmQC88zjM8aQnz4RYa7fHSjOAwMRJ9cDEJMSLZsVzOa5jqNlKE/gM0NIa8IvsDsaRvYcHHwRSDSDiyjHWoxqVIulsGTsgL1O9m6KXdnTqQzP1Np093GHyGP8qIlb2T8lQG0DU+pXnopBJQSbLqweN1wPCoOLlQWz0O2/iXSQpDCbfOD4y4bKkjAVni0Sx08jHHDFr1QeC/5XeKRrHIf6Y2wFfilaqakXfoKXr/+A=
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
index f747ad469c7c..98820d93c6e1 100644
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
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 3513ade7a4f2..633d66b5ae71 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -173,6 +173,10 @@ SYM_CODE_START(handle_exception)
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
index a449218f174f..91db51413fab 100644
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


