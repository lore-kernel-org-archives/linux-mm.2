Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EBEACCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA0E8E006E; Wed, 15 Oct 2025 14:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885588E006F; Wed, 15 Oct 2025 14:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F2B8E006E; Wed, 15 Oct 2025 14:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57FBF8E006E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24E86118BD1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:14 +0000 (UTC)
X-FDA: 84001148028.14.E1893AF
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4169914000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A2hkJCGN;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
	b=GsOSjmjTUBTgDDg1+EZY1GkUsf7XFV5qPc7KextDojOm31sZXzoTDY0r07z9PC/f94/urD
	kI+OhHk5BjOZ5C4N2xUMPHkK5oLznuizAtdGAPrY+3ihzgT+GJZnbTLVk+2SOkINtuYMHw
	8XWe8GR35WoqCSx8uW3TdxuwB90JWp0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A2hkJCGN;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552052; a=rsa-sha256;
	cv=none;
	b=DNMRxCU1grXDJ0gr1OkYAnRHUEDbBNrPKBpgOIE08jSdRgR2uiGTE9F8Yc515g+vslSf1b
	1Zjk/bFVzJpLJ8HVVKmEiEXftecNVk+JmCXcDwYftCX+RGC7AKO11En+7Jzs0YSPhuic+j
	4NK6J18nDs8ghtXddQPSyrKovUWPRg0=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-26983b5411aso47565885ad.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552051; x=1761156851; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=A2hkJCGNrlxjtHIMauua2YTlQQifrnhxniNi6IbMavMhWCzY4rUK4BmxztyB9x5xus
         pHiu8D5JfsWbkOd1Foe8U8iyEG+yLYOo5IJWhiJiWLVaH3pQctlp/ZrPWCTcJ1RK/od1
         JxzFt6+JHfZX+PWHfHJ5DJIgjpF7uuMgY927jN646AWlcQZR82AMkhWrZFZnqLVLbVbm
         MTiop1+CSc6/chXY5Ci5dGn66G1TcdgHcsmk0SjoBak990jbk5ETbWV508u5M37bxX+/
         uavvEQOLmM5myaRtWFjNeQZjYE9F4U681ZvuSAJc0hy3D40HK44AKeAwEEzFAQzPCMJX
         maKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552051; x=1761156851;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8Y+4xiTK5mTni2vvSY1onztmzVgzR7f1DB/I4yf/kY=;
        b=Bhwx8yCBnlsDx+/8vljWsBnUAQknFAFSY12rIlaGb8WXXiq5vJRh7wB1xNT0EKIZ13
         /j0ODbcd6teJH1wcUAnIuCXjCNfLX8U+9W617aViWOpwQUD5rNF42naJdPiqauQi7HMa
         TGmaVJmTa71V0huCE7XxOTyNLc6IWGUVss2NORnpy/TV56GMlAWd1+z1QN+lIbL1x3Bp
         g+2EJbg3M3V8xUDBwrpolp8ntYzoL3vcZxY37W1YCxdFNK7eRBo2s7CHB912v/nSSitH
         dVNMRj3zjgJmz8uyofB6NgwDRoMa4wGW7+eM6yKPQnirgS+sZA7EtMRuVTIO0t/+eE+J
         btDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDIJBbcx9fTdlAA3vf6kQFuoNJynxPMgR2bNs4t+O/H81aO8BC9N+ZfM97ulbxPA7JpXXsCSbvqQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8mELR/Mj4Sua5Cy6gDMRoJ64A7BdimInu9aIdHTifgcmiv2tX
	gmGI5ltieLOsp97mmp5XK2sI9kZgPf7GiayU7Y9GNeSnUMDFN+HIZHFTuVYJATWu+lXM1wWSJGS
	7900N
X-Gm-Gg: ASbGncv/cX6wdvOZVNHtsSJEYCUvVxPBOsX3F79ipL13HYkGadQFGeIVCzE/ozXGpAp
	kxAjaYLm3ZQtYrq+ymhZNT8Ul1+C6yAlCEh/4N5kKHJD3AsfBwhvv4mbBR7iuAxe5xjZl1RefxH
	+TygewNjWmGrQZNhdOutrMFW31BMsY0ywRI1TFGvxIJhT0H7cSrsHmXwwL5HujMWEuVxlycwoGj
	Op0oGqapd6tT1jcSx+gXMD+Wgu6sOZS7uO+mco3b603xjB2EdDY1ocCsm6CEA4aS/bL8MOt2BSg
	PjfiJwqe60cONa1Du6YexzKe+xhBcUYM5eyegaej+c1L5em6vGi7lkmMTPCiCoVWiDeEPJ1BCbL
	67QHEvloVe6RldGeJEhMhkz0nub+8uMTfYW0cnlb5p2p7aP15jdVMydjaLbj590dy7Izw+2ke
X-Google-Smtp-Source: AGHT+IFQiplFD3cnvOVGv/lALEamNQE0ND/mDtJIZ3BTVfFP+ZyRUM5ke0pQSPyv+hvgA4S1XpYFVw==
X-Received: by 2002:a17:902:c94f:b0:271:479d:3ddc with SMTP id d9443c01a7336-290273748efmr411984755ad.15.1760552050741;
        Wed, 15 Oct 2025 11:14:10 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:10 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:44 -0700
Subject: [PATCH v21 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-12-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4169914000A
X-Stat-Signature: 58h764m8dn6ytgufg7g4riqtw7swifhd
X-Rspam-User: 
X-HE-Tag: 1760552052-827189
X-HE-Meta: U2FsdGVkX19R/wjbAjIUeLduk/QaK82CKJnewvnNPltsjIkJZOh84X135vyZ5GHYeUOMtZ6PK7dOyCf8muc7Qy5ZkqVKkCjpv6rbnF8sMVhctgyssPJ6Lc+8AO67hrQYK1d0agOlcNe0bkcv+P7/QEFthLzepbfk3Xaietc1Flh1VwBUUDUjCyhhNs5HToBNNUBtmZBMwVaha5hRQvLvRsdkJbkfvZ4pzQmDuBB6JE3kHb/xCxsCfNO0TfPsSWWaG8vAlqvTmZ9sbv89kyarYUqwsmMvC/cKB8loO1br1UdaZplsXsBHKdlg9Mf7dBDg+TSjC213//zBlxL85HKEnOgjR54y0IXPQnqEVIciBbUsrJUP8Mr+P46X6Iqry3o4YS34767hbnqjcV/qnZzKqGnBIcrY3Lt65cygogsZ2Zx0bmPlgzH66vu2JOI+h8urxoC4S+eRAaoIVDgvR2CKHUvvatwGItYkyIZEOmgfB/hW2WYGEKxQuQIiebXQvz+RMpgG6H/DVP/spoiCHlkC6+WNls8y1DotoERwhjMqdQUMvJg31awvBDa6TFQBqA1yIO0I3DezqWsC1unzwzrlC4obFfvw/mbOXrv/6pGX9qnpl8VxEzVFEgd/pAAEdCl3UtslAvuIdFVcQJ/4gLoDWpBx0PWc0p4pAmWZYtVV7FaHamCF9Hqgb5FSxgtiazJcNiFApAtA/znFjwO+7PPH8YMzVmJypLq5aCAg1niUC9SfWCvMUP+3x5iaEZj/fcbAiqM7JxxyQDUl1zDohT1gGBdieXXg5rE8ARuHvJk1LiFcVzAX/FL0ExXk0zbjyhBfr15voeTMvNhyleGLfeuQL/TqWce8lxQxMIGNgLuHusbHwzaRSnrNEeky4nfChWQjwPzJDKUrcLqQZZME5zJ/HeNPIQT01afFeBvfE0HQOy9qVUoaFMVy+UZpleCCEV1x5OWWn4bmvgde5TmuACl
 A8JAKV6W
 PNm2GI7j/5ztKI3hlLe6Judji1RkXthiHt9Bi34V1OKhBEyBaJNCiJhPm5olsio+AE7dED9M3MmW4dH+vVuds/1HKvfxD0vGH7be6E3ga/lshkjkfpaFb/CfIY+xFxVwu/qIka75bG1TPhebNSq5jRWd5O7M14eUs1rq3M83srziw+v1k+8Rx9sUjKyDc5P7husZSZfg+SRgjAPCPzxt/3CKJCLyaiYqevKuEo6tOHm9Rue0nVP+/0EGMCw/ydxTpN0D5ztvEoSy0X46vHgdT+R9P2PoCfQy+2B0A4Aq13GzOFN7zOWhkLAckhj+RjgtG8dq5XaXvkkBze+tho2wbfoZf7g9ER6OV2WqHtoN2Y5uT9i4fCkCwc4XvlYQVRWQ0VOGyArqHJlf3HbvyOHHUVw0dUrCBagxmpwOcXaX4E0etnoVVRaab58tfXQ==
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


