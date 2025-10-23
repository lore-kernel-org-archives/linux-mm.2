Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F40CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6A68E001D; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458F48E0019; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3480A8E001D; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 075148E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E47EC0C13
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:21 +0000 (UTC)
X-FDA: 84029969562.20.DDE7DF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6C132140005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VpHjf79W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238279;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUJDTdpommSU3AQCmCpeVpPgs31SjSTjJ62gKwluv2U=;
	b=hty9+6IFqlpYU4/243UDlS/dFB908a5JePlQHWhlsFg6UJ/u0dywzum9TO895Ieq9DzakB
	pTW896qXDkQz2wax15pKNHgWyP0DWWoUlj0SQEn3fu8fvbpaOLaD4FuO8LLaypUxVLQqzO
	/OicRHBCp+TEt8zCxT9voISpGqQHTjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238279; a=rsa-sha256;
	cv=none;
	b=YWGaaXE3lkBiiuxm9QRNzdq3b2hKmt6r/jz053c2/D8Z4E2bS4TPB1jIfY160a24bb8Smh
	E3wGZIXJ815lZttIbxgqFXFMjC6mRdKcw/waP9sElNTxan9v5lRi9xwFBGPjgNEM2CJshH
	2uw93CRwU4MrcGTBXunJM7VXEF0A/rw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VpHjf79W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 969814AFFB;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 657AEC2BCB5;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238271;
	bh=PQvU5xoVu9xdabKrvJjMn/h8KvGLMR4b4TqTR/qjjvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VpHjf79W1Nd1DGg4M/OK+I1qWqE68LELXZTxP6ouvId65DRQMMccPJN7zI5VR2NE8
	 GmphBxw7dpFZpKIYZGXWh3ZdMhbrdyTavu7ULGl6pL0pzaanmixzvYW2gDPPRDHI6L
	 CVqsh9kjGXe1hBei4gwAYicv4DUm7h1+0hR4hD1LytCtRnSyRsbMS+BP/U1GzIAQVZ
	 LHJ+EMe5hhrYVsBBq41cxk8LPcngJb5ImWe9jUuTp7ASXEEc0qlopvvoMQ1uF+Bi/1
	 pqbDXSQTiKBT+vORMMSS5o/vHmsoQ7foWn94mGgWSlNS5sriqj5rXCnIl3oszr5jOm
	 Nj9mBotTZ9x0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AB2CCF9E5;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:20 -0700
Subject: [PATCH v22 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-15-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=5526;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=cLWo2uhDyVt9R1FCZMW60Uodtrv8YQrfhgpUR4+sGS4=;
 b=ShYWs2ZFBHyYvh+a2IqZjOc7Eu6Ff3RNZVEK9nlVPjLL3zscDmC0bX3g7Q18htFuN8JIPS2oC
 M3nPHqw++taALlxHiLalac0BGKjR/bvH5JjUj0WeM+l3EmZ2ypyS/Fj
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C132140005
X-Rspamd-Server: rspam02
X-Stat-Signature: ibdsgkj6iebz91poesiqib7s565r9u8e
X-HE-Tag: 1761238279-138936
X-HE-Meta: U2FsdGVkX18VnB4F+wbtDcul5oLAsgvKQWfEA1xavFfRyHPGBZlDS7UMnPm11EtnM0sNtVV2HShG1uMNv5KDG2soJMHk+ZCES8cyrpDcBxULnlkty+F4/DY3JejZxJVyYTlY/GJiA52eekhh3Lhsd22Gjv74iK9sL7h2FfeVaxBrsVT7mCQQ3R1VV5Gjvinsexg5/5vqouT8kGajZlnBRpgNuqnNMELxa1Ic8DhVBoTAxQYYOPxpblDLRufkuvES7gLr4A9u3Kc9sZbmrPQ4H2htuvOn8ghRNhAuW9YXK06L097XpGObPDKQ+ZoWx6wLsSvjZjjQYlSbK9G0w0qkd0i/nIfyiCajk3tsRLGOqFtzw+r+608qDo0JKTLKKkSfQO4LDhUto6CcmI++y61FPx6Ydo/rFhWz+j2ziiVFaoxJ8+ccBJV4q1wifmesItguV9vkPFBduYeoGiu6Qhs5fbjNZmiRG5gtlT3rNOZe8bMdlu/jIZ4qF5b1Lb+p1Wg/Z1NpgGCeQvKG1wsEshIQM2YbT4WYg4UFW818pzn2zzjrPHioqnK7UULGSwQCIogdYkm8mZx1p8Wzlw1FWAUylZUhq00d/xervCPTDPI+oyAaQq/iLBFNDjLkqb4XLDVhJdHd9dG2ipiHCtePnWBmjLq8wqtkuD80FNy2LfuEKKHT0nvCJWu6okCl70NQDMifgwZa2owXeRoldYWgSbaKkPgXAOM6SMirRoCLSfbxpRdVnaG0E4aitpAmUarnIqZ6y/3P+XXiqyWf7oEtPlUuUyPtFKw44pVI1C8JQAESWPigz4nY6ZNbBG953tvnI5Mwlpow7QMXKUyWSpni18VtN6qIWtVJ7aUAB9gdemAk2bk67eXFAlrc55Ut5WgAwZ9gGbcVdCld4ffKwenzld9HzxBf/qq2nlnG7kTVTATaqp/5Pvtp4pkkBlTC9iMDka6T2LvJhj2TEVSSyQaMtF2
 zhBTaSTN
 KiZRg0cq5kOUJ36oXV3oU9NYq0XOoehgYQ0NVxBai3twfgQfGj1MN7B9h+1Qvvu4ELmoFCE/Ou8flUGMMllwCCF9/o5RZdPyFsdGPo0uLg5XzX5x6/mbfUxF0PIg3qq8paO+mRYWYhptBOCIST0uMxYUFDzPjLkVkNlWi4qW4K2J7bbQjmULoGQj+zsOe4R9mnb4UrHeZmnO/vQD2/P487RBZ13uCn//ArC1x9yCijq5el1GcjKBnMaTNnr6PRvEzBzvUmQCb6KkJ2kD45NK/V8d1Id0FoGSWcZpF580Fkdy8BOTlqgqxvP2ZE+tLutuQeyhoaHBjAGiDio49+tIjOQ8HhCCSDHzRVWMFjEB2G2uAb9TFZSwshddNLrsfLP9GM90O9WwQT1T5G6pSQMsH31yy0XDS682MPQBkCfT5EbY4NMU0M1RhmKmRjT/YdrjmYIFK3tuAbqDncRyAj+p0096Ars0vcHACpHaWuy0NKpupgy5eV80M+dolVPLDeRUqQeuD3lIpteegBv27+Sa3zeNGUK+KsE3/egl9
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



