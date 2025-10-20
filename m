Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB43CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5ED98E001E; Mon, 20 Oct 2025 16:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35CC8E0016; Mon, 20 Oct 2025 16:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C108E001E; Mon, 20 Oct 2025 16:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 845668E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:23:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 612231A02B4
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:13 +0000 (UTC)
X-FDA: 84019617066.04.E730A84
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D84E80002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DvbQHHN8;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCkPPrp9gQEUL0ggbSzTHBQGf1uIlxDvndQy0b8riqo=;
	b=CGXYtYPnOlciM9dXqrxaXZxeWTAPaJfEurMQNy5KttUnpNuDeN4E/TGaAiWyTRHgFqqjDz
	loHcKgssI4B5idxLa7DM+Jxf5YC/7jGjeHlbRYa2yJOW6A4akmNsClDmQPpnQOPjPA+YKC
	1oeruoPvIUON/ksLNbxGyM9WEPHHmhY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DvbQHHN8;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991791; a=rsa-sha256;
	cv=none;
	b=jua+6hlNwkg/zyOyQwr9GURVifwsWIKHtsQdtr17CkGQlPx717u6fXBE/o/LH2yKoMSrwk
	vR9UKCtbeL3wwwcjFjBqew1uj8gE7EV6m+Rz3asUG3vYvSLVwDNxZ40MF3BWpcqd/PmEys
	vIBsLZNd4ouXv/7OYpHXP4GnkvXYHfM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-782023ca359so4680254b3a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991790; x=1761596590; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCkPPrp9gQEUL0ggbSzTHBQGf1uIlxDvndQy0b8riqo=;
        b=DvbQHHN8WEynapNEJIv1bjHbX21/RQpoaJt9nXjt/zzqUWdbSt3JeqiCxjqV4gdCq/
         D1yDsZoTkweTUBjV+SWQkMX9HwU259ZjDcfdB/nxpyXsW9JHz1/C6fYWeQflJzmcbSjk
         9+ZCquqrBcMzNSQnBsK2HOoMoI0O2rcdHln+nkreMBowQQSUwo1Cy8vzGqKsGS8K8eDn
         kkcQGDCqcfwykp1tcS+b62Zptzc50kCc5aU+S5uYO7ZZzDK7ki9bBLcDYEMpTvYo9MT9
         PrUuENPMAq1tk2tSEujGuMwOSjYx0zOc4WtpCG4wiaJANTarUGwhnN5y4wJk9UJ9tTBP
         0gfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991790; x=1761596590;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCkPPrp9gQEUL0ggbSzTHBQGf1uIlxDvndQy0b8riqo=;
        b=cZDoPPpyvn/ZluphnEEIT1yhh6ZRG1aJRoKKZ64p++cfLnRtl0+CCH/WroLAkm+K3l
         ud4KXh2RWvTCNyq8b4jOCb9grkv3zsL/QXe4Zwbp6wvP/QUItj0qMpSVhaOxjhJRktLx
         52ai5yHFAm+MAWZlbH1pm7uR9Cu/mkPHx+XuRE42seJ7Rk/OGTDhNonx7Ku+nqMLleOc
         og3+Vq5T4Q00cZJp6hHqCWoVTTDirwetRPj6bEV5awT+X/XPUiyNU7f21NK8uzXoZVZ0
         eU9QtV1KAoUHTyH+DGEGA5NSfvhoS2rmJ6pNn2ISRy8akD3kXcHdEOW0yg5S7dkluxDL
         6fhA==
X-Forwarded-Encrypted: i=1; AJvYcCXmuGaHsy4rdTp00fFMUP0m5qUVUj9T+cT6pW/504io+pQ/z2qu43k/mfdCKXytHzSkLN7Pvf9GCA==@kvack.org
X-Gm-Message-State: AOJu0YyIrYEvVprjRYjsdjVEOtxY4ED3Cl9SPJI5ZxEC/0GrqyuCrNyI
	cuqOg37ItqzBtm8VdqVlu2wfn12tQwn9nT3J5OzaIve7K4O3rha92sbnrG5ZO9VJR3g=
X-Gm-Gg: ASbGncsWKJ8svmkg5KZryix694uYhqHZQunSlKt9VG/OVv6ZCsRR5K/w2w5P7HpZ1t2
	mz0nTUIQJYPSrYXqPGr66tQB6xbvbRZJfwGJOMzVe7E0XxIj/e0LyUuB4tVykjzyAnOhQ46MBxR
	ux4snQnKWEQ9V6TXaKtw4+jDsevhP0sVm7QLDjfXgSHnTFXgNPlbL5cjsjlv4dOgW2HfM+dltPt
	fvI/Vk4n1OrPs8GGSeKxXcAtlVELv9grTzur1wCOiYUl9297PcXU+Bfeq2C/S0/tQhiy+ofYyB6
	72Va3y4r/5o3okrmnOlb8iB24dBm5b+sd/5yTOmLXvzDNn+RNzaaZMGuMvsBgo2hD4tDbLmImug
	oVuyuJrC6NB27LM5gVDgWToDa8XfjQPA0SvbiKcmsD4rPmCtY8tuy3W7PPMGNb2lvfyxe3h+fcQ
	IzS7UF1brFv6OSTLT8ZOQq
X-Google-Smtp-Source: AGHT+IFeAiK1pEjnzeQ76oKm8s3fmG8FE4Cb0oIxKjxN+P2vkwg0OCkygP5H08wijF/1nv8wkzENEQ==
X-Received: by 2002:a05:6a21:6da1:b0:262:da1c:3bfb with SMTP id adf61e73a8af0-334a84854b9mr19250556637.7.1760991790129;
        Mon, 20 Oct 2025 13:23:10 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:23:09 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:43 -0700
Subject: [PATCH v22 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-14-66732256ad8f@rivosinc.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D84E80002
X-Stat-Signature: et88pt4abj6b4j7p664dj3ritpq3cth8
X-Rspam-User: 
X-HE-Tag: 1760991791-492697
X-HE-Meta: U2FsdGVkX19PDPuBjWfIF7leS3hPEK3CKU6A7SEBzTcqb44+zj8aoGC87nEsAHbbcnEGFOnkbgPuHyKQt0kll+Mb0kQdY4BPAfgqyPfJfbzFAqAQ2s3QMJcAytl77UuoFmISVdfw4YoyUgFq/BJRe4jPpCMYxW0XG4dezm0Q8UYjtM04ki2S8V2ovL7ZQHnm7gSzTfgUWDBDNZCFQ1w7G/tepYTg0F7nUjlcGdIE7qM0p0gnqyQnWP8VatKBHGrS0YG2uN0s05D5C295Nmv/WT900buDzdY4VsjK4OPUVxLyO1vL1oUlCQdMUe3NKy7gI8Hj0ncHFFeV5ZFAs9yBEYPa6FLy0kJnAFtetMSGQJoF3L2J+KZbHqpeoPLCBT8iIBkc5DaC19Zi3w0zwNIB2VSsWZBDcw2LnE7y84ALY6du74lzEYkn/7+H1FmKFmXdA0o8v93zMlaw7znmWPx+xpIgcElgo8ISYE3bWCULO40/nFso6Tl2reAlvYXn4XtgLkc4Ju6PiaF4bWnrwyc9ElSkqAxLfjemNjAL6NS5Q/wh/5YgQ9wI+XglEJViKWvWOZ6rLDnvhDtCRKmDSbOVFObjjq6rdXLMIJi+sUINMqrCr/AmjQ3E4621HRRT8ybP2ezxfPIcJ5T4uBHLN9zevzFClkkz2/AD94qWsPRNWWIUtPpKL2RoQVaZkstVoJmKQeCQW+awSzsfDJK8LlfcGXCO2dw1wAjYGmjKGVOsabIlmuUZEGZHGlpEVF8kLxrib3y7KQVkT85QcoUHbIMwMjjxU6+Jv3vpmC2F3oh/cjbIXeUm099PWOx2jleoTCXAR4Li+NEnWsotQzUuH5xnNEC91KVlCu6iDUGAn62MxLBWmaPShF458ECQa0ve+Pr/0m23vw6vzVfPkIjIiW57m7nfbiZOiNTw/KJkQD2exXEC++2uODImOZU1lVYrn9rI4agmWB8Pdoyzg7HJ655
 HZIt3tb1
 Ad58SsJYvj7no0PhNau8FeKHkfMz6pThOdYPAUiF8AOvrtFPDa+GWVs1NYeVKtl5Mqz1o0S9Cs4qjp3zp2asHOpnGO1osaH29zrGuD/VyHBTiT8uc0QRzE674YV1lLCcthx97biRgodTvCl2lPAboOfjeWhjaWG2zG6vS1dgy6gyAq+EgSQ0n6m/RHZ/20r8pOspJXhkA5d552nCIyPPNPqcyJ54sSIlV+0v11JkO2hK1qYYiiIgwO/mxhZbrVaV8XomQuhu41VDO2B4c95Z4kZou6UZ4XGuuOgLBFvfMCXTPHf/JwlJrSJNX96JXIYYlINvoOrW9rmIY1aPwqoKaw/3DEoa3JXS9hqKuTQZZaxyHJK5oth1sR2TZd0xkYTf/6cUkUgw6zIemR1omPwbr9fw5PbyK/YQhDJO+GcRnS4c1nql2ey1ZS0wZQXPvEk1//xU1rYUBYJqjEn8rmPPNoikCOr1wrJdmGYRPhL2IlxWwH3b7rG2fmy7vaTnPW1gGcglv
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
2.45.0


