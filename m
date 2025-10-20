Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECFCCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75CB8E002C; Mon, 20 Oct 2025 16:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E268A8E000E; Mon, 20 Oct 2025 16:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FB38E002C; Mon, 20 Oct 2025 16:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACA128E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:54:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A1C1B7EC5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:12 +0000 (UTC)
X-FDA: 84019695144.26.E05CF30
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8358F40005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VCJopeIs;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993650; a=rsa-sha256;
	cv=none;
	b=BQpO4Ja/P/EMdnlw4z9cNHe6cy71Q9B0Nc8tdu2aZPYi2ReGJ8zEz2EgnkfwYI0aZlhLjC
	hLd+/2Y4U9noPUyniMgPhXKMkvEi3xubP3gYXj3xFlSfcdgk+kZ544lb9rxTJdhDoByiat
	skT/MsKmyfLSYok5zE9FkZhzWIhmx/k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VCJopeIs;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
	b=hm5yNJuKmq2XeIquwuBQvZKOW6ZU+ZYvJO69ADzNZkX92z3PkOEaZHxAz8e2Ba5hCouQrn
	zniW+eqW+tcGmpS6th1TzX6yfORvcsDzchZK3Ag8vhQjCrxjKELHcDj5bUI3DVe2+lwcal
	q1NcyC9QxARMLkdOPlb2/paPnIOvnyI=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so4364453b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993649; x=1761598449; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
        b=VCJopeIs4CcR24aVFcjDSzyFVU8HjPyAallukveypmOwEFzv3NqnGWHx7kVR5O5uZD
         cclSCL3Byuc9bNV7A4k8R3oMJktoIvCpUPpLY/ncPI14Gd0H8Z+EBOV0eh6dO7A8nvfd
         XTe9r+d33g2aFCDgfWy5C+GalgJLAsvRC0xXyZofaO8QRbJ03dJk3a94eAYXbbjASeMC
         Z73JyGimvxeyFl9vXcMJ0Uk2dDJRhjGGh37G3IMdlUSesjnW9SNRQAnOinTXmapee6zD
         BNmBK7UUG9lvfxNdrJh2BQqyar6UG9lv2QyxDejRRrf4xYxswZ92t7mEqnvHIegUydcO
         ldVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993649; x=1761598449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
        b=mDsAQipNEYZmvEYurDWC17Y2wwvbXlQ8dkIhizAEMjRcQMRceHb0UGbX/+R1r5oYgD
         KhY2w8flRSgyG89w4bxTTdJwF+ao6Zy/qLwExU55aSlRkOZbCW/h7p80BRYyfxWFujDc
         4Ox9iwlUxjespR1xWeepuvqkfn2Dg2+Rr/WkweFWND/5xj+yGN6uqEyzw6V5Ab21+Yen
         JxJso0Cnh85sNvnRESiPc1ioKQ3WOeLT9mZHqjIk9UyTVE8SLhwpY65Dc244BJuhPvc+
         LU6AAvl2abzexw6YO5+M+Ae+v4YAyE57KNIoycz+uWXksxPHVp9gahCVj133OImX7czC
         OX9w==
X-Forwarded-Encrypted: i=1; AJvYcCWlT4FMI4UgcMyj3JIciUfVVBVpnQ/1Ek0U57MMD8wmjselikvJ1oGLrF2/knBcMNrZv4M2NiWWUA==@kvack.org
X-Gm-Message-State: AOJu0Yzft1afO8hL+Do5XYI9sotCefDMnJ4yWH4vWYqEDOuKVSezs9Hx
	whIkRtQ3MbDVr1knA1AUKm5/rZbfdr2Pinu8lTX7BOvM1EZztcd/vN0GPdZAeF2YeGM=
X-Gm-Gg: ASbGncsUSGCpoCVhNGb2UEV0O6qYHLqqX4XQrjPGPfCjl5bfY3Ty8EJ/1I6gXV+VEJm
	l+jk5wRiOxvH7sS77W1iUeGJgHAfob69aLSk/Fvtn4zABN1GlYiz16ujy2NdmST65zTJrDEZOK2
	/0hqNphvZXenytET38WQcbqwOVLh4//fobLdb7CxjZcpP49EcmiNxHnkxoQOs3Y1x/OMv7+ZiDR
	m/GlQptpWZMIvFMsrPyKHGg86QOPZs4LT66kI3IH0+4nxBdakrqdsp7wGaXI3L+L0GTmIR67mwX
	SQ7b3KD/T5Xy+q+lrqkQNneCP9XNCgZZJBeR7UArbNMkwu+lfdgP2YJhAcXwvrnuDoNrRndWhqB
	SWgJkJnTpYrzKOzSG+ImolOpWp4tBWU8VLMSNA+SkFKJQxmTczFAdY7FoEkHBjvwddUHw/KdFwL
	GDltoCubADfw==
X-Google-Smtp-Source: AGHT+IFB+7tddu1swN+FPZnDNP9flYF+7I5jbpUR/5BtNJV0VX/Du8+wNTTID+AK6UwLh+2SCOPFPQ==
X-Received: by 2002:a05:6a00:638a:b0:77f:9ab:f5 with SMTP id d2e1a72fcca58-7a210f95542mr14528712b3a.14.1760993649214;
        Mon, 20 Oct 2025 13:54:09 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:54:08 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:44 -0700
Subject: [PATCH v22 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-15-9ae5510d1c6f@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8358F40005
X-Stat-Signature: cysdhgtwf4enysbmgm3fjc8opid617wh
X-HE-Tag: 1760993650-831104
X-HE-Meta: U2FsdGVkX1+TSRFIxH+Qen4BOzMSYIgSFiwFq8HU4aINggaZlNhLNLbXsSkCS9xMXx52ibhIGdq8zdB9Ve6GiUo8TR4oNJomDFS7WMNXunPzg5jxdVU0uhVOLYEVqUIzZm+Fp+bDzk84uAiUsTKuUoQbPkr2Ebk23AbWCGIbAOUdLrXxHjnnP2f1Ge7TvGmnRKjLwR5xDtj0cTF1VBjqnocrdw+YsEcCyThO4wWOukozcqQRXolKRsy/q+xOeIHaiMvw+wMGB1FoWJbp7tX1LQoDVyHuTcMUMcxODG6Of43XoLvT+zJ2Me/9R0ON/7E1qNFDDiqeo5fn2o4G7lPqVEQNzeb2BKcoY9jv4TbtpbnAIZh4pk6MR3s7oCQOuAUN+YwU8FpLq8Wnfob/5WUK/Bv6inGR0L7POPv1fmBmwD55y6ooIK4GDN9awkL7hqJsHRwAlE6peVMsxlyh/HduzUqmEoQyyMMneZXUIz7Otx4mRo2p3VGxqga8Mq3gpYffjblYjmbb/4WlfmM3dxyf/1t+kQlph1Q8GDzJnMgkdaGkp77aT7RQp77iTdtWoWXICK04kx0eXwEBz+UGO2I3mPHzv9Y4Y849LikVziPRIFnuETCEgSmJst4lO0Ae8oPxU2j2SOcWPyjDUYNpLJC4yCXSGQ5ZbT+yJ7HsH/z+WW7iCMLlwB+NJY22kt5NuRAdT/wiSOWnGZ+ljqP+dUx1VvUnyF91kOwv+BaotE9ICxq+Qgqy9RDQ/vwdi02xgCIEiL5r3U8twPp53Dr0cQpKD0JxcIk8Z+Uuqf+LgIKdOSC5frhg9okLvJU3qE0AFcWZ/rjgccYbxZII7gMHP3uG3lA9keuRi6AjP8e7J97hPwno0q5/GmYDWR+Ef6GDRBUFsPl8H2mJePQP1uXOzL+fMeV1dyr84Rd3h1Lnxc4MqaZh8FoNSb1ZiEWLjgqz7rJhE/BtQ96miGgi74bz59Z
 b9Pm2dc/
 XiliAzYx7SeLp4jy7Ms/j2XPlKcEdrDg9nAomSZ0nix9bABqN+O08TODstfknckDp58QXUJ4DT6aVfRdrPkI5HCqHbMVXKwfdIDlkJXDJkOdt2qKttkRy4JDjAIsBC57EvIHgpGUpbcCspVYo0sl/wQUT5ZAezIukSYtTAxlc60MmDQzyZMz6erAeLdD6GIyAbDfP8M8jxwS9xZwLi4kDFOXS75RPCKHrqPcPD3R0Ubf+oHSqG07i2bu01ofV7qJzxFJLgw/v7TeitenDGCmj/ku71XT6cS+HxGa0/FwVzaRFu6eepaDiI0oCUDbn5/8oOldF7NygGg+HBJbGMokH+nFBQXZ0kDlEGwB+FS6gt/pRF7t9rWTs0ZgezYsRo2rfJhQNmfJPwbvZVZ+6UuNgnpeAIO+AD/SzyBzlZd+IUZL/OJ2v07Qxdli0f5QBIpU5SSDCP7O1B21yMoMPDd0Zh9gHwYL0zjaxOly+
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


