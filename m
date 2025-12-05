Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2974D339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8006B6B0062; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762E26B007B; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B55A6B0088; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49C4D6B0062
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1715EB7BC8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:01 +0000 (UTC)
X-FDA: 84186286842.11.C5E9975
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 140F6160018
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iAxiXLo7;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960119; a=rsa-sha256;
	cv=none;
	b=meZFqgSeqx50Q3ewqQZhTGTL8YhgV1T0GYKQLAsX41kJi3g3zNabyTlkiWxMkRabFZgqNj
	3kQGj3T4QCU2YyWPJ9KGzs84OobHlh4nqMvU0vqIzazBqcxahiOTOOST2JsKlIlJPS+kPt
	IN/3VALnIiQ7OhxGnpCQfG6/CzHCiwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9Ax69h6dy/2WXXuJccFyPwZFaQnLuwOVOpvNrT9Kw8=;
	b=JC+LY40DCgTxl9mj71NZ44qBpa4BkGYybVWvPe2830KDDOVQ2QVRGYAoZAv0LjxcaA45KR
	h5suAxiJQQBqVls9og0jdQDx2OmDD7dPDQeOwODisK8ldqCh3fxG5inUeK70EDqvJTsOuG
	C7nBNbcL83VG0jkVsVfe6MrwRgyh3io=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iAxiXLo7;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8450445A7;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E26CC2BCC9;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=HdNiZJqM6D0VyTTwRtYP1mVmu0G8OaSHRfodSNYlNJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iAxiXLo7P2d1RH4Ja0xOnS5NbkRsHXeCdw3XoDzi62PEpqjuZQS4N+HJGNHu6vvVq
	 +mB85a+v68lgCWgKln8OgAw8BTPPbQCFS3p5EJWvjIViXMF9tWHMf7hFLJ8JPOEcyM
	 H2sOe/h3ukP0grYYEPo+/w6LyQ4nxrgTPMoQvquT0Sizdnjy5I47Yv3Dvla3GKQoiF
	 4JJ+UMCrSBjisTnAP4TiF38v/Tqwg8bN4R8d1vIHIyMWcEWlTgG3OVtDKcC+Chzy+X
	 LqroJAVlMcvabzgjHzuWMTXIHxG1eUG//DmCk4Dc011n1pHE4YE4jnMnOn6RUvy7Ya
	 aTth9cXLX9i5w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFB3D339B9;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:53 -0800
Subject: [PATCH v25 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-15-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=5652;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=pDv4J86Pof3YK1pZH0o5q7LZtPnnQoynOcq+79RnSA4=;
 b=FA0dwWAf+SlsTvEyCwkwWI2vi3Xk4w4ZSLWYO5Izu2jboLX6nm3cXc/b/icI33DeXyCpdVvws
 KyYb+7CWqiiATUA5TOiKUOAg+oAmRsA1Mi4AWS/kc4fk/15UGfdF4Fv
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 140F6160018
X-Stat-Signature: jndy51zs1dy9skjontr3bctb1ddk4qdt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764960118-358713
X-HE-Meta: U2FsdGVkX19+EJvAQyTR33Z1L2NVtj65jfuz9GSKANv1xXKIjuc+WeWExQ0ZgeaHSrZ9IMIJBWyO30AcggYoeJ8EoR03XbRzihs3lxcHS7hUV0NulFAvxpDLil6z29ft/DZMyOD7VgHjBRsDVcCYfvrUb6kGVnU5n0icWY76zYzOhcGXF9uJKCb8vU1brbsVS8UVd5v3gs1O+jk4bnvrXCjXBw1znL/rbYK/V2MmYPYPU4T2L9pjn0PaK3nqpIaM9R0bNK87tgBFaTvMK5nIMjxSYagJ2Xo673EE+LbZuhpSDCbX+dWnB2x1GwhXCxuMbU+hCBRJ8u/I+WACFJLFer8FKFspr55uD/ypG7tGHVyCKaxHD84QoCz/OqVQgZoW2eAxLKr2ocZBjgG96V/YMJBekhHixEnthG3Y0R6iVXXseUtdZxC4hoq9GWpXwmuYkAGjvXAqNyszgd/1b7oo247zPDERUnymq2NEgFG0iiyI/e8E7KLen6WB6JSs+Tm9XsUsKnppgxLLFpe9WvQKf6y2DukFDkmq5CSAFkGyfulUeGWsRjqLMbhv3OWF4+ACE1qArXQVE+DfBmUZOTn4C1B7cdnUZgXcNT1TcmOPPUWgZ+1sANrUTOR/ckl8+yM9Qift6gr6mHesd1iAijJ96rtJIWgWZaaCSy4SAH9GrJhqGXKEVlU1/FCWg9J3CBF2s/aaaQ0HMO1aVjgVFGwmqIGREa7x7BbZXtV9h8plUdGjQUi21QaEKFKvkd6GviTgCJX098O/+oFCNV9WMDixkJo94sMYM+kKHphgO669HBofJ2kFW/x1GF0/6QkVyhdIJpdOJXUZplJrJUkC1uZe41rz3684sKKyJ4t2wp3JnQYblIH8lPlWDkNFwjExcGf1YsLM4VUV5bpaa3f/qe7OiXMJKtCA35CMHzDr540Ga0zIZHI1H54VPy8dd+nXEvQKURUyAPU1XGTpYX4Mqhd
 pinav2kj
 zbILc2Tb6XXq4F34ZgFePOnsUQhU0nqX63ad/wK1rkAmpS+F+Z6MaHd6H7HyzPkLk0OpORRpJCl0LQRiyiQRkB1gV3zbtLRfs3QNCpefSvFd/RCNWGJYr/OC24BVGBIpeye99G2DLWDXJgxq6iEUdjhvKHxygMT1ZtpBKmtQiMOKNI+sNRGP0Yvlde0xnhBznL/p2bLC4roRmlCydjG0TBHKUG8QN5grIfU2HXZuul9XLA7YbH8MoRVyHZnW03nYP/kovod4mGUo0r0wQLM/KogfWEv3lQ6F235VXSPo/BkUiaWE7am9g5bdFHw570LARfm5MUR+8do7eTENPYwxBMYWtnqwt6l7g6JGe+GfiVdofO0MtQTROQ+s4Zd3bGI1Q4DSYyTCV6l+mkJyxYXI6lB8s1pjgfT1UfobvvdqBAr8NN0zZStP4iHAktmhR/2g/v4V0aIZiQ3eVgG40Cvc9qpASOY+OmdLuooO7r7thVSi0IklDNsn3VNH1akNL/1EXbCX6PX4Gmp4adULSIfEUtad/D9RB1123Ddb8nClOMUXaMUjze8THNOcroq1HvRu5nsHoBz1JoFomDlixEWpHSkRGhsAO4MXVzmJJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



