Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA8F8CD4F37
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F278E0021; Wed, 12 Nov 2025 19:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FA18E0020; Wed, 12 Nov 2025 19:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AFF08E0021; Wed, 12 Nov 2025 19:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D99E8E0020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19F5E160761
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:51 +0000 (UTC)
X-FDA: 84103736262.24.43103C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 225F4160004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mwmrBpzB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994629; a=rsa-sha256;
	cv=none;
	b=mp2PmNm+fBEiVgYYOq5Z5wL1l6yhTDFN38fSfBF7QGnIMk11j/Az3O1hipE1kZWwQ3OVKo
	OqYCBVNSTbNhqO57EwlryjLJdu+opuxAo8GZzkWzszWICYrL5zaITVfB1GsURHGp2psbg6
	/Hncs6DX5HVFlgATudjhvt/NDmUpjjM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mwmrBpzB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994629;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUJDTdpommSU3AQCmCpeVpPgs31SjSTjJ62gKwluv2U=;
	b=8fZ9gSBpJDb1M3cho5M17GER79kIE07OJGX92vzTW2VEyEcnzgaMy8a8KKnJsp0Clj5nZ+
	VaHV+jKmlPWevRQ9Qsjts1hwbS2/d2kZNY1VV0EOvPPhJATeBaacKtq7JkS44n9KkgYWH1
	zhZPuphTL41YF0QCG0VinE/4Sdz4h4w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1F8B4475D;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25D1DC4DDEE;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994623;
	bh=PQvU5xoVu9xdabKrvJjMn/h8KvGLMR4b4TqTR/qjjvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mwmrBpzBW+ZRPgwr8NllA3OJwMC1/fKRIUBjlPykyoxvozaKbsg6htk3B0bBel8YI
	 dWp3BoQ2CtJQ020LUKXfkCF1oElPDOUT5DUGk5mG1pwuWhMCSskxxXzDuCFgKThmpw
	 GyMycMdonnWeZTYCSLGa3H9zmBlNFJU7n8CtUC/2pnHszboG9/N7QeOWwAGA8AKQEe
	 OsBCMQpPI3XEk7x3QyTV5sSSwDJl9BOIXOqhfG11GjLKjxCqRVjEfv4n3VXSfCmuu0
	 NrppEnLytf/POG6dMUQ+s5msrGMKIJ6/ESmo8dnGNMFnhk01oNMdYnyLKC96rNN3+7
	 fBecstjKRNsJQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128ADCD4F2C;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:13 -0800
Subject: [PATCH v23 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-15-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=5526;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=cLWo2uhDyVt9R1FCZMW60Uodtrv8YQrfhgpUR4+sGS4=;
 b=0IWzTUPlCPWP94aRPQZl0/SMvoqegy5kbzuSP8wgqYEFdiubZNvtG9J70Ljgz3W7N9ftKywlC
 abT6AX8WQg7BzIPaActUQuppYuj7snYSCkUEK3aJgvp3yPgATA9suFm
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 225F4160004
X-Stat-Signature: 4xg1pb6kexuqo4yi8texcidnczo7a3bd
X-Rspam-User: 
X-HE-Tag: 1762994628-216837
X-HE-Meta: U2FsdGVkX19DtOxzoilVIKucGmZAE5pOqx2uJ6DGYk7TBDY/qM4H3JwC0aIxW6zLDWYs8F40OaYTMgtwmbN1VwsASb6wNsY9iIT/LQQ6hb8+5ySOvR2aRPRh+tYuApHuAuS3NSH+hEx5kvzC2cs5pYRMPmiBhnvCFPzN9rCp2V4YW+8L1+g7s85jBWmZqf+bpHKDWW9AR2x5b/dyVHH5fhFeIn2iYxS+GjQ9wa/6i9xTcMRrj212GRwvQSGpaZGWNUPP3y9M2bzOk3H2eiZghQb0gyITju0WFybUkCTS8+8ZZeuSDShbEVT6HBIHS8+wesUV1ibnLBVgR51NQtQiciw3tLaiBHAyJmnB21ITORKKWjFlBvTT7gCnCpS0BOyOBnWscn+IdiQ0H9ht0/IIJcho1c96m5eWL9BeeZQ3reiXdp4jttAyCoVTF1jOZ6x8lxl07gpOE3KjwKQAkdgo02Hnt816k3K+9uXQjFmsSXVKiPIWDsmcvGe8IbgHJ3WtKz0UFKYQ7RjeXAk3mCbZg4f6l5GBjdZRuT6drHVGnxhZ0CXaz1dM2aNv0mEx4wXP6FwDDkU8sUqwXe316nPTsacbHR/jgeuPEqTs7GazB0BHBuUMFHJYPd93RxlUE3JcjXiEMyqe+Wt6aTx30Bi3uDQ2S/pNxKaqetH0sKba0Ua+oU2aAKe++8mr2h7Ma0wA/QfGaMXyYrn+NcgSDZyOZUIkxoBQ9qN+zkCqhMpPufTH/IgH9L7VSFuorv+aJeN+LgOr24F06sWLykirZ0BZ4yaFOitd6LW6Fj5vUYPMv4/xkD+Xju825MqbRyjDlJxGzCSgyeT8dS0kc2PXldmaVJHmFuHAYoUkPi0EJxjNQM83cIYZsdWvEscwsyaHcO9OMNv46eFAYj4oh/KS3+F7Q7IJe8I/PehSis5YitbamBEn9lXdl0SM/04+VdvFs3yNV2/8mfkGi7Qn4teb8wL
 ZuIzUN9n
 wnouCaiKfn7zEltsQSOwWhkEFzJeXDx6prxawWupVa1y8EK/oFScdaVtkPSntTNoivQCrYqIOYorSEr4+2icj/4bYxS3pCMFjvPy7IZSvChL+vaSChlV3ozA8Mk7E8kHNifTZMvp7TjGlYf1o0s9O9ncIYhG/PScJe6MzvX2gFrmKQ377mKPVYIZ00MZrtVcRvoJCZDlU/Imo9AYg4lhc58QE/Ja6BQj8JzBeHtacMcT3fKlGHtbqvt23WKINLmpZ24i7/XDNxi9cusBKkfRPec8Ik7aChafRWB7Ls4j5PfMqpxN07sWvZrKCkshjpmPW9tof9qVNeRj7MSYrb7amlbeM8T9N3PQwpZ8gOGvgDD7n8XECKw2g3RAemWBDJHxgXlaw+8Yagro4bi8U7G8qvO4ix3PbKvUoAOisSoHUYpw+1ec68Z4p+42LM8xYPu93TyLaMfP6ThONfybYXjf+N6s7CG667aerlW7WqXAbpLTL38kfwMKiCrMv+ZgOCRLyMCVI1xnhGrtUrDYe3+5Vyg1rBa1MnAO/pNYs
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



