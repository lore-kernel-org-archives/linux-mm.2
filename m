Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E73CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6BF8E0072; Wed, 15 Oct 2025 14:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66B68E006F; Wed, 15 Oct 2025 14:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9AD8E0072; Wed, 15 Oct 2025 14:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7AAA8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 745E8B780B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:21 +0000 (UTC)
X-FDA: 84001148322.23.E624A3C
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92E871A0014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YQtxjZsh;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
	b=DHDTX74Cwxv5y3YOf7gwFiWNlNT2Vd/4cIQBOJGv14BMyFAaGjyTjafzNjVohpKCLMzq1n
	PwoV6PzggtlTqm0fRG/Eub1R0Sb4wtGr9A94skXB+80vtKVYMhrfGpryWkm2wOmKvoO+d4
	S+X9m9qQ6WyK6s/jUTZumP7YVHdlaVw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YQtxjZsh;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552059; a=rsa-sha256;
	cv=none;
	b=rUPArjtrzyek11Ziz6FQHuJFtaRMLRPc/c1mOBjnKtTJUSbsi2u5WoO+9gB8YofIQaaqRo
	ka7OegzpmfDTkS+P9fWfR37h9kFme9aqMnFkgie1ksrSEaFODrMSWLwAXGQEpsX22yJMCk
	zJThcTk+YsUJnD20VfhOoNXiznTpVCI=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27ee41e0798so107620175ad.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552058; x=1761156858; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
        b=YQtxjZsh25vrDuVHQDpdPK15ESyZtwY607vLmLzmf5q5Qtxjo/x4sfuvMsaOylc0cr
         XVJU4fAXBerklMbtXJmtT9BGLf5T2aT78FEIpf+hgrxXJBqXpgieEEBPiuVCVEkBr8Uc
         UVzL7hEd0UtAUCOiMsulqp18+WF1/AJUs7/8/J4ppwiuIc8cgpmt2Tf39vDoffivcGQd
         2On0vJgDUzBF3WL7NcmCbYeNbcXiA5Dv5dx8JlG3ZCGLGOFqIHoqGUbjYUPzi3c3wZge
         Cj4nYtTDed+IpnF3+JAQ//tf+kNUu/AFsfwQsrJA51xEao74A98XHPx8+x4goB9VXxvd
         hjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552058; x=1761156858;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
        b=QTSxumkfCmGlRpO2WSALvQ2KlH8zS8Wy7baaZ5Rg5masOWyIQpRA6Sn5PZ8FWsX4/5
         j4gH0ZqRIIScS+ay9Zdtn7rKkIdYc8FMHA/XWa4kXISKCJdE/HZPk7JfOcykTUKj0XGI
         v9OJ5f0/larbDHtYfs/bC1iXhBatmzZMCz37+JteSIuhfeQiK8O9+tZ9H/1Nwb3bqFQG
         2bPXjLAcfEA9fOZhRFIfiexyhdfK6nm0/4n0F+EJFLP3GR7a7Uj32BTGQxojbzJ5/jUS
         ZtS57+hGQFqHQya4j8BvV9Jn1Ftrk9WjXv/9HMBT3Rpabg95DUeCN+H0z53T9bncWWqQ
         Okbg==
X-Forwarded-Encrypted: i=1; AJvYcCWsq0bJOxZIRficShI+4D3wywt6Jbw0HMbCakpbRRhhu/wOJto5jiA/cT9gEVeJMAMh7SwQQLfmKA==@kvack.org
X-Gm-Message-State: AOJu0YyBjkxSCDWFI/Ow4354JlE9Pm1sBpoS3Q5AigY2+Z27pzB3WK18
	11kHBDTJXg39Toqin0qo4Uz5FmXBKIPZ/+PGkGkCEySZq7QaFp/IL5XIJJ5OFE5WsyorkVynUhO
	Tm9Oj
X-Gm-Gg: ASbGncvTIQwjWrNZN0o+E69c6JM68xVr46mbzMAxft+ZgGNUOLqTbxPsNmI1pEAmO+J
	2rlPgYXPS/8Cv0T/wW7gIw9RNL3sjhHUck+dNORixZpGEQ8T4WZvkxRW3m89gIP5wSikLZSp1Aq
	01FIdZ/4nCFZIE2j+SdTEyCHVAc9C6UgKjOnHZiPLKH+G23FzVWh7eB9DbTd2xo3SCWL/K1TN8u
	vIBZU0PV6qf1o0BsiZQOCK11YKoDBBVxt81TjbVsjLAwvEfc9w8XwhABjGJt6GeSNq8n/nvOpU3
	nDP4633PBI2aFfyP4XbO/6NDScogUeXZk1rwcn/9kP+Jzh0YIf8SMWCB6geZWn4NzI9J8x43jKR
	su32BrPHdkyhCDzKgsRGixBEWkNChKoE0PrqgjV4KJ+rY1nTVR9g=
X-Google-Smtp-Source: AGHT+IGzTcK0GQdDHWDc84GkfZRUKvzQE5Swvz7V+RF2ivmLzz7B3JVRHUd5vbMOjVrfu57/Zc/agw==
X-Received: by 2002:a17:902:b18f:b0:269:6052:3536 with SMTP id d9443c01a7336-290273ffc80mr262320115ad.45.1760552058053;
        Wed, 15 Oct 2025 11:14:18 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:17 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:47 -0700
Subject: [PATCH v21 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-15-6a07856e90e7@rivosinc.com>
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
X-Stat-Signature: 85ci5jkmcrjws7nrxi7iqgqssy5f9j9f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92E871A0014
X-HE-Tag: 1760552059-444517
X-HE-Meta: U2FsdGVkX19XymtkSXvvAg6Rn1e84AMRrhULYqEezxUik2rldS+ZIeoe73QeJ0q4qFS4CbT5SdUut3BlPkzKN5FQk9d1rNB/uDdNd+pkqWhQ9CMmVKt6f7seNei582/yx5F++X8D4gH0CxNCl2K3dGZDV7hwpw7vKlqWa/yfVDZThpjgaiEv7YVQYKttXz5Pnru7Qzy06x/FSh4Oo7I4ZHQN2ecCl/ARaabMLo4hZJr1JggGuQd2NaoutjkZpAFqYTTg9xwYpbz0w0Yt/8/4A8H/jxjBmpEPMgIoI0X3HNI5GcDfJsLSNTASQK21qug+6pcp/WeRVX75ibD4lcdDFmeVYmyFrUAGesGho6CBX5R10SqW2UN7YtOjMsClY9efXxWbrpMtXCSOQ5V1DRP4CffzOCsGdoryjyCuBnRbBENxz55MvpJHvMZ89GaLc1+foUTzsf1kX/HIaHe+8XvQk5+bDPeRVS4FfkUgUrNUBp3qHwiBXRAbO5riOR+vv+yz9kvRw3fto0jDRBGfORDAq/E6UvBKcPfjmuWd/xr3wOJT7FHWzgoQg0zgvOAnkrx9HS0Fx24WO1OXKzpPArdt9Yqp9Xs/btAEizdFfQ7rE9NgqpLLUaWIBpSml1/LsVtSj+AFwXv46GMazZjxq4VMKbS3zGLJ3CVmHiHIpoNma/ToXzQF02gaaNBOOcNLYzQlGASt4l3UFHDlN97IQaaQOsV877Dy29rmllt1PDQ8uJvBfDXZ3qibWUd12C6X4an0MBLzM/DJjh21bziqwdyNj7Fe0T14dtcIusE5Wg1Pt51iD2cXKriGSR9Eyb2wJEslY32JfacCWAjnhGrp8+edQN5z1vcNrjEu2O6bJUqDzTOm/FxfuPO55pdI84XrV2Lw0NxORQ59/cLg/8zbVOD19OJb6ugqeQFH4V8c360arpxkzIUOhw9M5EnKr9W8dbOsfgwWn2pjzbNe+XP9d+9
 vB7E9Sqi
 OuXZDwpzvgie6hGZlibWwZv3dxbvekivMcOgXW1MUhZ9Urv3yq7RPbudCp/DufLIg2A2tcsvZz090Sj/ZSITTUU0dI00RbNz8T35peWoNWjdRGQvRiVHri5Kxncc3UtyHXzFp6HJPL8XDeg0IAgHijRatyy+dX6yyOywrrbcm66hI+TaJHUUg0QK6w/9QEuUrSQ8PUjZD+Ub6i/OhuTGNNoTURBqqOvu+V+luJXd2ZpDuCMiqY0M048ktpR5hcQZdSNYFW2TFhTmFeorS6CE7hA+fr5esbb4mW6jfsG8IrimSyK1CKS73X7b0/FnAJJE/3WEJq7ooY/7Os3IT9yAbwRBjc+AF4jkg9xqJXhEB+dk1mEQ7TgAVkFYinahls0GBZYy2zv4TecaAYlkK3xNvGM+gRo/wdKYkbAhIOLSUA1IrEVM/oyT4Ism6VK7oA/IZ2nGbL9H29AWqFXMnhNT6RMGb6lqJp8Coc1ig
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zicfiss / zicfilp introduces a new exception to priv isa `software check
exception` with cause code = 18. This patch implements software check
exception.

Additionally it implements a cfi violation handler which checks for code
in xtval. If xtval=2, it means that sw check exception happened because of
an indirect branch not landing on 4 byte aligned PC or not landing on
`lpad` instruction or label value embedded in `lpad` not matching label
value setup in `x7`. If xtval=3, it means that sw check exception happened
because of mismatch between link register (x1 or x5) and top of shadow
stack (on execution of `sspopchk`).

In case of cfi violation, SIGSEGV is raised with code=SEGV_CPERR.
SEGV_CPERR was introduced by x86 shadow stack patches.

To keep uprobes working, handle the uprobe event first before reporting
the CFI violation in software-check exception handler. Because when the
landing pad is activated, if the uprobe point is set at the lpad
instruction at the beginning of a function, the system triggers a software
-check exception instead of an ebreak exception due to the exception
priority, then uprobe can't work successfully.

Co-developed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/asm-prototypes.h |  1 +
 arch/riscv/include/asm/entry-common.h   |  2 ++
 arch/riscv/kernel/entry.S               |  3 ++
 arch/riscv/kernel/traps.c               | 54 +++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/arch/riscv/include/asm/asm-prototypes.h b/arch/riscv/include/asm/asm-prototypes.h
index a9988bf21ec8..41ec5cdec367 100644
--- a/arch/riscv/include/asm/asm-prototypes.h
+++ b/arch/riscv/include/asm/asm-prototypes.h
@@ -51,6 +51,7 @@ DECLARE_DO_ERROR_INFO(do_trap_ecall_u);
 DECLARE_DO_ERROR_INFO(do_trap_ecall_s);
 DECLARE_DO_ERROR_INFO(do_trap_ecall_m);
 DECLARE_DO_ERROR_INFO(do_trap_break);
+DECLARE_DO_ERROR_INFO(do_trap_software_check);
 
 asmlinkage void ret_from_fork_kernel(void *fn_arg, int (*fn)(void *), struct pt_regs *regs);
 asmlinkage void ret_from_fork_user(struct pt_regs *regs);
diff --git a/arch/riscv/include/asm/entry-common.h b/arch/riscv/include/asm/entry-common.h
index b28ccc6cdeea..34ed149af5d1 100644
--- a/arch/riscv/include/asm/entry-common.h
+++ b/arch/riscv/include/asm/entry-common.h
@@ -40,4 +40,6 @@ static inline int handle_misaligned_store(struct pt_regs *regs)
 }
 #endif
 
+bool handle_user_cfi_violation(struct pt_regs *regs);
+
 #endif /* _ASM_RISCV_ENTRY_COMMON_H */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 036a6ca7641f..53c5aa0b6a16 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -495,6 +495,9 @@ SYM_DATA_START_LOCAL(excp_vect_table)
 	RISCV_PTR do_page_fault   /* load page fault */
 	RISCV_PTR do_trap_unknown
 	RISCV_PTR do_page_fault   /* store page fault */
+	RISCV_PTR do_trap_unknown /* cause=16 */
+	RISCV_PTR do_trap_unknown /* cause=17 */
+	RISCV_PTR do_trap_software_check /* cause=18 is sw check exception */
 SYM_DATA_END_LABEL(excp_vect_table, SYM_L_LOCAL, excp_vect_table_end)
 
 #ifndef CONFIG_MMU
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 80230de167de..d939a8dbdb15 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -366,6 +366,60 @@ void do_trap_ecall_u(struct pt_regs *regs)
 
 }
 
+#define CFI_TVAL_FCFI_CODE	2
+#define CFI_TVAL_BCFI_CODE	3
+/* handle cfi violations */
+bool handle_user_cfi_violation(struct pt_regs *regs)
+{
+	unsigned long tval = csr_read(CSR_TVAL);
+	bool is_fcfi = (tval == CFI_TVAL_FCFI_CODE && cpu_supports_indirect_br_lp_instr());
+	bool is_bcfi = (tval == CFI_TVAL_BCFI_CODE && cpu_supports_shadow_stack());
+
+	/*
+	 * Handle uprobe event first. The probe point can be a valid target
+	 * of indirect jumps or calls, in this case, forward cfi violation
+	 * will be triggered instead of breakpoint exception. Clear ELP flag
+	 * on sstatus image as well to avoid recurring fault.
+	 */
+	if (is_fcfi && probe_breakpoint_handler(regs)) {
+		regs->status &= ~SR_ELP;
+		return true;
+	}
+
+	if (is_fcfi || is_bcfi) {
+		do_trap_error(regs, SIGSEGV, SEGV_CPERR, regs->epc,
+			      "Oops - control flow violation");
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * software check exception is defined with risc-v cfi spec. Software check
+ * exception is raised when:-
+ * a) An indirect branch doesn't land on 4 byte aligned PC or `lpad`
+ *    instruction or `label` value programmed in `lpad` instr doesn't
+ *    match with value setup in `x7`. reported code in `xtval` is 2.
+ * b) `sspopchk` instruction finds a mismatch between top of shadow stack (ssp)
+ *    and x1/x5. reported code in `xtval` is 3.
+ */
+asmlinkage __visible __trap_section void do_trap_software_check(struct pt_regs *regs)
+{
+	if (user_mode(regs)) {
+		irqentry_enter_from_user_mode(regs);
+
+		/* not a cfi violation, then merge into flow of unknown trap handler */
+		if (!handle_user_cfi_violation(regs))
+			do_trap_unknown(regs);
+
+		irqentry_exit_to_user_mode(regs);
+	} else {
+		/* sw check exception coming from kernel is a bug in kernel */
+		die(regs, "Kernel BUG");
+	}
+}
+
 #ifdef CONFIG_MMU
 asmlinkage __visible noinstr void do_page_fault(struct pt_regs *regs)
 {

-- 
2.43.0


