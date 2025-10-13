Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1280CCD18F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3385E8E0031; Mon, 13 Oct 2025 17:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE448E009E; Mon, 13 Oct 2025 17:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183A18E0031; Mon, 13 Oct 2025 17:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E73618E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90AAA13B78A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:33 +0000 (UTC)
X-FDA: 83994450666.07.BA37E87
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C41420008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ds4qauNM;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392591; a=rsa-sha256;
	cv=none;
	b=ZCsup/lLF0hFmf4xqYkg/ofOuureEcVSieedr5bvvYIYfZRqZiha7Y+7Nt5FEfspoqMOem
	6EEdHTIHmgj7sNl4xJERrycHv0G4een6SrwnRnOnJTcIrBUid8GH1NFewh5wZ4HPP01/5Q
	GtVWK/1YGbdiXuwsH1lletY7kq0SMxA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ds4qauNM;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
	b=VT7BFrnzk4gtF9Bo8GuV1OO5eG+jl7U4ATmm/e/oW2ub7L9GLrCw8WMjCKDsw+N0J7R6DV
	VHOgZXHXOssgNTv3GfysAS5KXgSKTlIhVQvCzhJE75wPdP/PGrzG3pNiLjrEaqq0VhYBbK
	uDJkqI4JptPlBs2Gvi53MpO7hcTllhc=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b609a32a9b6so2769894a12.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392590; x=1760997390; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=ds4qauNM0jV4Pb7CMeBBQ49ubTqMCHMDgeuW53pG+hI2j4ZqruQoIU4xxSflVKKqVQ
         kfB9WOWQz+opNIdvoiI1vLaax6AdkWfLXmDbK06iMZaR6ElUXXFBtss9ICiHEB+rA1kb
         d2lsyvZZGlKBNI+0JqV+RRGQfMMfXvlGXPj/eokXOY98aYWoz9LXnMi+6bWWTDDLe5ig
         SQ52+sx65Yh3YgmiWNGz/29g5dZsJE090M/z8LexO6hJeK5xFKe7w1I62J9Qp4ujupkG
         WR/LlIPAmC6rgdXlCDK/aLgcl77mzFlwZEPLBLUWIG7YueeUdGYXbSZfs2jNtP3paCQ2
         5YlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392590; x=1760997390;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPN39yC27jDQNku8S8KBbMUIjGDGL61HkDgx51sdOyA=;
        b=iqhaAffnJWjs4cdB5BB481YWe/ept8q8paBg385F8U+3TjP93T3+eQAEyOkR2NM6A6
         e5GvN86M8ZrDEKRPf2/Oh1g/fBszcdNVmcv/1kb5O4GMC9udvznC/3T5DCnSPExteh5A
         6ku2UESkN4SHsqOvPk1vBMP5dA8SWL6oWPvCGduUdLTV3M2GOvLAjBD/fvtNZkHINVZ7
         ux+c+fXxEu+TG+rPcc05WcmfXhbNpLvoHH+Kp0j8FLr+b0g6Ec75AUlY1P5VwwSdhizJ
         DQ+P4ocY+z4wAai9BZW93FMbAzaVbKjIyz996mKGYxOLzD/0dO9lFry4duwIsxSMhR0a
         ETEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU79+L1cArxRb1AFAdfxe59CITYdocLeqKIqU7o39jXxsGrHAzsS0bmBlcsJna+SK7TyD0SKru6g==@kvack.org
X-Gm-Message-State: AOJu0Yy5sDy0kRmWkCNKOTb7FOEdeRUDS/HnwID+trdLnzTB7kTztrq1
	FAeAgfIm9CxQoxFXh3lFgGpnz8XwG26wmY6eS6a6LKPKCe8Y737sKueiebQiuIjnLgA=
X-Gm-Gg: ASbGncsubxonz1tqjwN85F3NO1VbZBtIX6X4FJm066WatEVpapdiWJ7KvYYBePTxWi8
	HvRgvSy508W0bLFlkX4dqstwkIuRM03yc0K4zFCqqbu8uKbEcHVuHkA9+4FyO3LV2nd5JVEIgiZ
	pVavjFbKuT2h6CUbPDfQeWc6dRe1WBqveSek6dn9GIJZtcd1rQ/PHRZVQiqQnpJBLh0+W+UbgfX
	0CkJA2nsDRD3Rg9s6Vub33iua71fyBumJtXhpYK3mvG7PAEdwTNi30MgvMhZ81yt2QXm96hUqbT
	AdN4CYAa3tB+Aq9dTSxQES4ueOuCeNIPOEtRtk8MknikFS+CA0/gKhBHPzLNLi8cgAPCgunzXKt
	gSCeiMyBHyiWdaiyf8kRAflgknOatyiBPkZ+d9eMxw4uf0Gt+HCqUXUdgw1JpGQ==
X-Google-Smtp-Source: AGHT+IHExrIKQmYZRXmEHW1R5StaL4DmvT/MuC4GpEcXuEyw29FHr0BJOW+f7JIbKdoS8h8nStvW6w==
X-Received: by 2002:a17:903:3847:b0:24a:fab6:d15a with SMTP id d9443c01a7336-29027240d1bmr305950505ad.20.1760392590322;
        Mon, 13 Oct 2025 14:56:30 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:29 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:06 -0700
Subject: [PATCH v20 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-14-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: wsm5w8o68ucyigraj9kywxzw8ggh9c4u
X-Rspamd-Queue-Id: 8C41420008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760392591-581987
X-HE-Meta: U2FsdGVkX18vn0Z+i4Cx09tw0jSrShb9gsbBQq5OSlcQ6qtGXsdmfvOw41WjFOb523sfH/BKksYjejiwg3i0pfXQQhSaSEQl3WR/aOa4KG9cT3QmjBN/nOOGJSQhG8gSQ13KcNfiN4pS52HLb1WBiXOg8Nv168WGu2BG916XRGyJ0KcrO5EP1YgXaoBC3vUO0og6SGK5I9mv1N7bwwYmgmD1mdD5sOis1VvXoa7VxE33fgf+BG35UEY5+4xCPV55qbJWLHTfLDwaM3GzhfhktLsrG6r8oBs6aQxLrpBFUWrJ3LU7G+0+QnZUxasYC6T7WoGBMIlc9HwfIYgbocw6HlNCo3VQzE9p8KmFxOo0+G0POeYqrDAUyAC1f7B8SBAPd0P2USGM08XwOAwUs+lufk5KD8uo1Al/jiFJDO9Zc4BlQXGEHDg9O2i+FO7TRM62ED4OzVsaIwTEeSIadkwEtL1pGMxSFn146E06/1c3sTpYvXwO/Rd2Sg0okWQUb5a5rtUzO/oaG869NE6uxW7XmTjOOXA4WjU3FaYozdP6IIzJ5Cm4AOirs4btROVkqoiE+Xi9rIZHezimY7VGVUkdbVfCwvp4LGSd/Y8Nl84ySbhEBGztHyDTyk9GzssgvUSHJOMrsd27RfWXslR7i0eNiSZgnwoOXsYvweX0zf97czRRiB+HKsRVzJPXZW+Can+PicvDeGnggSWdiMA2TGkGBfKlXVV9qCba3dDHkDLhjnZh3B7aStlez8P8p1FQxrIvgd+lLg65KI2l8TcTMT0jkdPkzQDfbNtjWf3b5Dob2pDXDwx7/fY0DnQ/3Mx+JfLZq+wLPGHyFhRcxPjGMLFJ1HlCEkTAaoamCHaWP3IZY+6hLswQ1U8ay8ygIWo1AgiwvL516yat0LJMmAmGxSXzk3wIE+O1PKNWNtOuOt3PFg3snERIcrEoBB8HZAsaQ+qlHSPZHM4YFwrqpYmWlC/
 ZdB07EOS
 Kj+XFYDwSVTivWy6Sf8nTe63udJ3S/eDyHttCBEkS1rKxK3LxnO0eE7GWcLLFp27Irk0QAhZkAjgmNSwCNYychsPSMZ91T+ZbFhuJVKG8vFdr9U4mbgFn+K+zI+Ge2ZeSVoEDKnsY7od6DvL3daWk2XGjZ3yD0qmnqURM/pA61J889pW4s6woN1Gimo0SQIsAIvdDpoO3wUAOaOH79q+ktuqmW783tO92pi0F89jSGNwA+chAm4afD1ZHytfuuGi8/ouHl739VsAaLbFW+vNh6aJL6+T+3kyCzRRS3TAllctGTNwkfIRXKpA2MrvFA2+LRXQS3JtzwQGGqT3kFSuWWSX7nmCnCWJuGCMxSIQYC7INP74RsrcMntYjTl5BaEsirbGrYVe1fjSmqthk4e1tbAYJwIOarYpFEziaIChuP+lJUWVghbNQciWfjA==
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


