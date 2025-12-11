Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C8DD41D75
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089F96B0029; Thu, 11 Dec 2025 12:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062C86B002A; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8E26B002B; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C11C56B0029
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 780F5C026F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:16 +0000 (UTC)
X-FDA: 84207856152.22.CC88AD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A29614001B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a27BpnQi;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473674;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlQQ1lwZwpu6Ws3gwMSrCJpERGfwQMD0RW3kstG0N8A=;
	b=ybAYo92uKXJ3RaZ/t+4R49PDJT3R318HlcjZ/tqVpDlPkIrDFm05zqM4MHL6TDiy0mEoDS
	llcS+IaO8w68IqJF98DEnAJScvcDKrH3AEKgcB/zk6tMUKW08VJ3g+KTnZAZdvpeY3CxBQ
	xWTuk09B83Wvn5ph4LjJ+c4gsVJGZe4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a27BpnQi;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473674; a=rsa-sha256;
	cv=none;
	b=GX2PE1EXTPx7w4BKiende0Tq2+rtvYvUTfBahPQekB/mm3QoCEYHGL6RDzPfInuBQ0rgmD
	n98/SH08lgtd6Q47neIziSAPI0Ryke2GHV07DJr+h8+Abi+qFfXPAuG/NeIyD1nTJ0Iq+S
	gzrH8bbV7tA9T+ZHZzK5hu/yjw2p48o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3037044439;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED848C4AF0F;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473668;
	bh=dLaEo1VUqpGIEKWjvIp0z+jSzzr8oMR192mInBArNmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=a27BpnQinVlTKxJamOrxwxyAqfHMMzOWnExp5t3CL/2niHVPw1o8te+L51ftXqHBJ
	 fjGQu/lh0U8Q9+ywZpgTfCFUv/TPbGcXp0GqoAIxgNr3kQAtBozlnt/II0MYDR3pzv
	 t2zzc+sqkDUHrwbOpd4i+qz8f5w/IaBXcFoy813tAtnLkwTiiLVrCuu3zsj13OL0vx
	 BvGFxdWxtkfmVN5d7r8BitFywVq1gIpCEsvFhjW8J3CoYSQP9vl0Rvvv45tU35n+Z0
	 NfY916VJc2G4cGuMaezMlIj+qoG4KLts0sxGOEfBDOswR9ZUZYlzQghnz2G5mM0GD0
	 0NrrzOD18oO5g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF978D41D6F;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:48 -0800
Subject: [PATCH v26 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-15-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=5605;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=uxYtYZWuRjKs5xN6hoIJWChsfRrv9L0dSJJNEkCzwzQ=;
 b=aGkh9n7UHXQoT5YuRm8hbUGJTbMb7gB3scx+EVxozOdGZtZHxKTZ6koi+8HO15cviIOiI1tUb
 vvgSx604iSqAvfXB0u4YXyJAWgk7Q4nED/UemLmfESnL6zOT2H7tr8d
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 6A29614001B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Stat-Signature: wuqozmo4haeotyfawzhcxkbygy5e3p1t
X-HE-Tag: 1765473674-523089
X-HE-Meta: U2FsdGVkX1/9QPXfv9jnzVm62weucPH9KpgtWRUc+Q5xIqn5yvARTjneHPY2N/sVYz7QYg3df/7jtrT82US3i5unHhyF5f8VRpIlSnLc/Shd8We2fJoVoGXeiJ/6/NHbes8ohZBhjHIwrvaKRFb1fAG0Y8fN3co5S35uFVz8gLA8LCOx7JOVHQlvZvkYmr2orIPEcBVlPg3cjdsCX331745q0hM5ewZiFQSqHoy1QqK9U4LLliO+GEZy+5bYx9PIpUyaiMUAXQ8yNF5iZQL6BaT/KHPAT/wOkNBQF90mNBe/y7HgW4n3DgXf+TmDS6naoLTQ3zdy3FgEPMbP+BgAP+8rd1kk8Oahr/FrvkowCZ8gzK/CkoVzniYYBHDIU5Hns44MjHxM+RjmOqqAEIzGdt5YL8DJpZM+seMHzsYWLBJVX4yuZN2MYNnglzRgvDJYbJb1ZgdRVQMkufLFK3LfeNf/286u4xMJP4AiouHuPNVUoDNesNqq0MD/5ojgaQvdY8fJPgdAS5TIFegslZkmlwi29WHXl1szvwbcjFnnXRehr5aOYbYh4x1+3cBUgoBfGc43P2glenV2FpUfq6jB7Uexo0kUNP5faul9vc6sgkVerDiQ0idfWgdV4GniRFqYCy1zeFk8VYUo0ZqljqON17XL33EE1kvL4/2yw6OcgbX00Si4P1dOxnsM0s2ZqHWqcg4hMp+4+s5PeI4OC6NgOzhyKQhFCjWa7GE9n1lGZnuLHdsIP4ouGACe3StfXTwzU8XaVjqH0fy1LVdj71CEMWwEGGf5UZ32p9f0Us86hQkvST40VUzvkBdvgyva4M4p67Gw0wn1apzxtDk5mI2ESkLbVTcc0arMpvVdvLxb3UWN4ZJu8KMkDHKWx0L6sWcWlIrCcQU66qNaVsJUR+tBxQ/lIWsV6IWH23jVzJ61fu6ipKr+sTITzg//+A6nqF7xZuW4GV+j4dHvhM/0JWb
 jYBDIn0o
 c65HMcPZJVQMCf5puau7KIaw2UjfmSR6KGahhSEn/gl4/qozr0iaQIKEvW+k7U4L1PKv2J4P2Iy6BrpRqICjBlFiUCOp1NG3Gc7qqD180Df3QvlwA8DJ9QKGKHmKRk4EgaoipFAxGjkOzMLlW3fUXx55oM3uf4AUqNoUu7aUJ8DTQFf/Ao78pE1+88maNSbkM+0tKxZe3HUwgbq4Igq4ulUtuYeKvRyb2GZVA/TteMRGbHXBMg6yqlZ2a3hkRnDxSStMeVKi2nHuMhTIR+/TBf829hSMUY7H8tL54R+ieri/BMd7dwxwUTV/RcOqXgoRdk5egUpqAFoooAZspv4ne0PPBKnRafMjF3k39W4H/iN6pRXxdMga0Xp7NgpVPtt5NLLw94QRG0vZZxdcr9jSv6S4DRljdkNNINhEBDzKa58gTtPNlikNsKSQIB1r9+wVoS4HBP7abHhdhV8oGJg6sRkrKibb0zgHOIMvkR8Ai98eOnzdDq2v6solVTOgilfWCg1wEJKUmNT3RDyxhx/G8NYlYQ1pIcoyuS21VFyIzV4HKSvHj9gynt48oHxxeXAqfWFJU0mwDsdFT5Bd59uOy2V7+AG4HmH8RmOxo
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

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



