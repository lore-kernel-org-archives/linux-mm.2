Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA48CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2481F8E001D; Mon, 20 Oct 2025 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8CA8E0016; Mon, 20 Oct 2025 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8438E001D; Mon, 20 Oct 2025 16:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E01FF8E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:23:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDB631A02AB
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:08 +0000 (UTC)
X-FDA: 84019616856.09.C1B5F91
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3598140005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Yh9Wk8F2;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991786; a=rsa-sha256;
	cv=none;
	b=LAEUPo6gTUhf1QMxnfP76WzAZaK8a6pST8ivURtpNyUibxwJ2ff6q1L23KRm+qz9Itgadn
	nNSJsfiIcTamWXs2XCjBdc83uOlDPL/lQNzhMoJb9IQY/r+FD81CunHKY5QBmE+qhDMesq
	9bDfMmU6Riy1D3PvbVXjpiSxQi8LP8U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Yh9Wk8F2;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onJTLyAT2VPRFnCvpohSuEDJCgAog1RY1q0ATUvr2yY=;
	b=coGdXJz5GhKoqQHKx6kQf5TtvE7EPSlSo1De/ZjYDUokl2SjO/cAQ+ZDZcxFzrjSzL28L9
	D/0oBXeFw5iWchcdySjGSSYj58XlIGFJckkbj0wc9cuvUp9etNgjkz+gHY5m3RYnSWWhCu
	bQdRuyfAwdWphkeSXY8jpKcOTinoKx0=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-79ef9d1805fso4430953b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991786; x=1761596586; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=onJTLyAT2VPRFnCvpohSuEDJCgAog1RY1q0ATUvr2yY=;
        b=Yh9Wk8F2pkyEY58uEaciFwJkhMiSooynfale5tmISiK214uEMKpR5GUfqu/GO2yXPf
         eBDNI3OodWxH+unXJSQYiVBbor6nmVgIMEZBP3zrC7rGEr6kqw0AhqGl9dlr476fBQv0
         0z64hb0jg7AAvOgg4jd3wT2zwOTLK1oAKK8Z72RHCJ6cXTLawDuyo+Ji1OQQrVKOq+Lj
         x/5c48KjTpw7xU3hng7nvSlMa1eIo7JtUwIZFz5E8nG7xVRaYSOPIolQ8EvzMBg/mmEn
         rtsYiRjv3MAsv+PCOxvRL3B0IHxBw3VZYS9b41nLiMn6Lpzd4vs0DlRLRAplK/gSMUjh
         rIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991786; x=1761596586;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onJTLyAT2VPRFnCvpohSuEDJCgAog1RY1q0ATUvr2yY=;
        b=gGSdWp0HBce25AQXDDuZLUiVbDm6aePu/klSOJGeVlqLIKbhoal63YozmKuJV1oWr6
         Ld69QO20uDL38PHWdr8tNMwmP/XmpLl+zApdCjAQC93ygOfSVyg032FO5l2Q64LX78wp
         1FcJWlk78jXF4mjNiG7Yno4ywAgJD3kPkQRU8YFM39w6P1ZG9J93PLwq9rLgdW4rVSzO
         J2fW7X3w8aiPMhhUFeKLJ/QpftvbuLrWWi3mmACSuNeub9kiMP8tT+aSkhENLU4p2qIg
         1GbJcKssONK107bBrId49riYcSrlie/Ji0t4issa0G3SDl3GoLfe8XsMSARFXpwQTsa5
         k9qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoNsC2AJgZ5A11eDavaKDwXOd7cZDC/yBI3hgsRRqZbiB9AxoOhgisxlCHk4st5/Z37NllLsQ9RA==@kvack.org
X-Gm-Message-State: AOJu0Yw5UWfiM3oluTyjWmtmWxdYjyYuU/oUy84TxZMECxAt8sDWH46S
	GRPME40xVsGgrw45pa030ve5Gdy5Dw3ciCu3HlU0eEX9qBXl4IaXqPbLK8Rfqv4LmZOYJMucLrz
	X0J5l
X-Gm-Gg: ASbGncsdZUKkrB2mhnMG66dUCVKuD3SrKh0o/ovqtK8qtRPz5ISNq9nQgvjr9EVJRMo
	yMztPColo+ukrNJNbBXDAFElk3I1klaxMA7X2gzyke+iM9lqOCOndVsBLiKyae6uEQnkj7AYgJN
	mRX7iK+KrHhqrqHJdvVRAPfI5c5jUSUo9AmIsX/vf+tQnq2W5yShuYIm6m+rM0IrOjUe8QdAY78
	hIlFko3PZssKofv/lEPNJkhotS38bzPDRzYqxpFrY9T29agl8AnzIE+C0g1G5OY2zRNwGEmO32w
	VjJiH+jVoIZFOjtbmii98mobGzapUL2Xya/IbKcLXAZ2wXljsjdECchMhEUWLfk0rtHcaVkXvPq
	PPn6+deh6iBJwfgRl0tkdCLUAh9Bpv27cTzgabO2834XnATl2OSrwD4YeCypQiKqIqO94IWQDZp
	nLN50UD5XL0CkU6yLtJyLK
X-Google-Smtp-Source: AGHT+IHh/UrUOY89GHtMFCf9Rpq/9P8bpcM0SZDwdlokV9lYi59u1PZSxoPSLk8u3SBzCNoLWXD20w==
X-Received: by 2002:a05:6a20:5493:b0:334:a124:4583 with SMTP id adf61e73a8af0-334a8576cdbmr21530106637.26.1760991785475;
        Mon, 20 Oct 2025 13:23:05 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:23:05 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:41 -0700
Subject: [PATCH v22 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-12-66732256ad8f@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3598140005
X-Stat-Signature: 8imce6b6qam988xxdenxfgy4ibhum11h
X-HE-Tag: 1760991786-501147
X-HE-Meta: U2FsdGVkX1/fuqIKukorOArhBNFSyLtfh27/JYmq/7p/p0txe7k43JoJPeCArMzH2BFCQURMR4fqMo29HqIiKAE80LIS+rqyV1ril6bQIuZyoPyRWsmsrgvaK2MC9+40GEYzhVb1EEUoJAwzOtdJZ+qVpfMq+M2/AtUGxkGzMi8CWfG/t737e31yR/us4h4e80K//Dw6WRzwi38Hk+UUlE9JrROXUtt5HbeOeJQHSUxkdTPC/JuJGjEkmAN5/GlugfShCyPmYTL/WdoLB5uV9lLjLrpYKZKQX9M4iRUbGttRCgNr+iPXHuuOHAA1CVlrNqxKyOiKWpmT4K1vya1IKuBJCD+P1bComFlfqDFBjekToOHIOixGVwTme4/f1xMZrCudDx1CLFfd35n+Xa/QO9cVI3H/hE5Lh9gVFpLsUXbrOqhhcNYGZ9aY5e4VNkjXfPkSOyK4puKrGBJiR/UvlyoSP0T7ZilR9klmT2purMl6AUHDl8Igswas6X4O7wZG65Nt1BJqkTvJAxzLU8CsGEeJ96wf+c+FBWE3NfGHH0HclEWGsspZhSzROtQMk+iP6Dz7kb4MjzXsUCZBjUP+QSxcj8OyDPU8ByqWkre8el+cDzVWCMaJgXyLWJfIiSGUf1pXYar8Ep0IyLKBTrx0/jda9czo+ad4DREO7AObZOCNY2PHlXOthXUTEBDP648+2oPRpNRyC3toDRs6xCcQ7odbm4A4FpJwY7pvHZzYBabVJIsliVJBEw2K0fRwhdYHbqTyYR12hseex40/nfyBrBo8LuDauJG7n4LFSkxBy6n4fBFj7uuvdXbodyhYctwpzJW9bfYynKpLMw7XOVIQ+MFuuj7sV7IZOXw5qJXJTK74PFCH32Wx5aiRwMEMlnnTdjr/O3Ke3DUie52kQBuhrutjjidr9OVdJzEtu5eNtTTVhSuBfH4ALj+4g9BNswdLZ+JV9OwKbjUkFN+z2SK
 sO/oZ2fF
 Kcy3fdx2CebWmY+e4RZB7tGv0Nzb0HIImiofSlyA/+riteDG0akbiYDfQtLhoRVDUuevUaljNuwh+jiA3cvAnwUHVNsl45+HabzcgA5Y7RNz1qyoOJI0CPM0pLmB0RSyiuTLQSlp7npoiEdI7xnoM0FjBTUGa+nrUWo34jUoFwLKLMZ1Iej7sG29MaKoocdj2my268yfjkVwCl6mLsvYpIYLLxE50MP/VNHdNFX5hAa1+nHnYWxPcIXo0/Wfw9NUxDJG84LUhpfDzVzfxWQLXcENFUHdjn4ciSTLDS96CRR4dymgTWquC38grrwhITvNL6KO4j1RXLGZe5aEIiI8rvq7gs462oX4PZ6fWVKTjlnpIZfc+scf7OFyrai3j5eM3P6RusI4mliKvTsSrs8tWRam4jfUezFLmt0ou1ZszaReXHb+0pXWPJFxFxw==
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
2.45.0


