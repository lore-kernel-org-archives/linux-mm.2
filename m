Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9D8D339BD
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD14D6B0031; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8EE6B0062; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDC46B007B; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93A536B0031
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A8F31391EC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:00 +0000 (UTC)
X-FDA: 84186286800.07.449EACC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4BA5620002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0gOSTRF;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960118; a=rsa-sha256;
	cv=none;
	b=LAq3IkvyRP6VMd9HLv6NzO/FobWBGYPowk5WdzyaWkkI7Xf6C68JGsOuVqXUDKscAxS+W3
	hG8gPbzvfZai8HlqD49KJdXXFIajr+sH0wQWbLbjTKY8mANjCl/1VAa442BcD20dTUfwOF
	cfiNmzm/x2po/vz+zDTtG2JreqdnO30=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0gOSTRF;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vj1RhNAky83ImtAZbsOQhsg5a1z4AXSOGLkmHIbTUew=;
	b=sbwrAm9XTsle3lG7zMCr6CYeEQlidzoqMZ4ZHWDvJOjDGAhgDF/kSM14bbHJlw9TV8/eE9
	WOVep6/Lzq8FoIXwlr+EGhQVyqHpx8XLUwnUav9ViDRWvM0siC8bc+o3L5Hbw3lte7TPpH
	9WrdKKScuGB5PPryRQVyLeXLpsxXLhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FC2544584;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36C76C4AF0B;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=90T9j19woMM9Op8OSN5I1WP0v5lIdLoenKbGZcEa7eI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h0gOSTRFig9sOCG914dp0VHtmF/JbVcpDPYBCXAE/W6ExVUZf0W9yT42EA/IgVF1f
	 jXOWfjwoE/kQEYreI83Zo+xaMlQXJTokpga+R69h42tcXo8MFRcdJGpbcwOKLzQSGi
	 8BYS8s7/DywzyBJIpP9uIvFpKf6anu2fj3HnKevKHTxDbxmMW3Q3/aV9K6CFSucvZW
	 d3ojBxC2zZLc431t5Xslorn5e19vbZYoGujR1fiQXcX94W2bWHzpjC2p/CpDJX+L56
	 aFeoMiKEin98DQ4nsg4ouVRP/pl6s9xlwH9Ga0tTcdCVMB90C7TjcQ9QN578V1+HP/
	 F1iKRha+sy/Gg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27999D339AE;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:52 -0800
Subject: [PATCH v25 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-14-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=5844;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=wFkoKafNuhuo5Khjoh4DbWfgN2zX7rAU3xJ3b3Vz/iA=;
 b=juTB4csLgazOAiBvQQNt+REQ4u6jrENg4VpC7dKmjXLCBZVpd49chYzUvzyDMCUt8yo4t0Bn/
 6orii7VomtTA2SfPbK/901ynwttXOfenDnTzWBu1VSPHpGdJXZYAPF9
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 4BA5620002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pgxjiicg5kca9cohrihgqd17cm63a7x9
X-HE-Tag: 1764960118-486552
X-HE-Meta: U2FsdGVkX1+CfIsmMKlgoamzTHLEgIotNDwR/qmlKdTARblFPKyx8nE7upmVYIv5AjmdVpacTPHOLVW1kqoCraRj6WSMR5H2dsZM6bUI2V1PVxPYteUXuv6SR9k9H74zcnene/QCmsfn0zIXAeC/agRqWrL4q6uwHKaUBXaAHL+KAlVyF/rQAopaQ401r3xuPGJWyAV+LIKXIaWcBcRJ1WkndxIUbXjAw6Ebi2Jb0OhXx5b36evy3PwLBaKYX2AGoRiq4OH4xmneh9Xe0sCMmQVDiipLIKYiz8Hm0CTuuA5WW8XAb/bQ+3GP42APkXJx+iRgTn0sXTuMbifHl9iDMHuNguIXznUKWeZJNNBn4PLr9PqOcdBP47g7yqT3endNXk3atx0nKT2/7NDRjZ0gfQzY3jcjK9jPwMvfBJoWHJMTqKJgiCtweORSOLmW7Decr8xFRPrle3bWfbIFB0Fvm/6PFfa6XPSCndpdSOhLLfiLR2iyRt/NegFYdzljK3+bds4Zlr2er4F5RWE4gUM1x9mh7S+DVkydvr8c1zR79TSjQ/5aG02yNBuRZMmVxneV/nIdc57igHCavxxMnz36FmHy7NrqN+NTxsiM5bm6OkT11pyfPJeoN52ktrj8lPFJ/spUc9RWJRMC1ptohxZz+5aNI0Pl8BsfDxprSQfwpKLg/dTlNMu5XKk+Wvd5QbsH/jRJIbpikIU9qo8niRa69+uWXCdRMf2wGCQFG9A8cvo0KcRXpDKq0w27UhOSmVl9kZXT46HFMT6fcZuK6f378GMqsXtlQggb9zwcAAwJeIs1+ZZBm/KH4HiXC8jxvzzJolzgx66P+x2SM8fpuLqa8nSaOBSqL49wStbUz8TKwxlizXAJCIsmNGAo2wprpDDU5Z33yegu+8Fr+VRHvyMW0mRw5zgCp0A88nCm9bKiKc2iOBH7P8R/jCdJFotxioVYOBui96HcT6oSH+nmbGM
 3/Tvmq1K
 xoBk6nqvl4A+VAgM81L3B4yXVHI7jaAIRIn0Gl6AWMd6aHuklo16IRKDGtDRBcuaYn2XOKSvWqwMpIfY0lEAZjUmSx39NgHSALc5khkAvCWLCnQFupurf2kgtQS/E7oiAyBZ0yjDOJlKreBCtju6AS1EX2Fs+8RMMBr37nX9nW4LBaNx5xfRV2vLXL607fRLW+yXZZsmNjAwFmYRl1oMDXdSJPGif1QyVLrELzE8JUc8D+/5SeyM+sdvtscXzkvXko6hCmnybpY7hBkP+L6bTe7OQ19GMcHc2XqELvJSti4qcuS4+KchzDm9wC3NKwPQO1SJSJikE+9nszi6ygAZLAQuxtzKfZAxK9b/xBGs/wLEGUHCKx1929STwacy5/2Yc3tgZiQ4lo+h+ktOrAlSS6pPZR7uUjtIbrJlJnTaqAd8KNWODz4FmHK+Zzf+1nDdkA4ndMZqZeXPhbfqDnuMB0xw/YzK6fFiE2IaglGpAwz2LySyA2uhotI/y4FxWE2mI+D+bSL1rGHc7ZYivFihU3yHnMGAt9kyLZl5ZDBBKZJMd6sCmt7/SOoAyD01kl8NnC+BTbvrgVW9IHRXWydaDv4QWgGEw1TF41pQ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

prctls implemented are:
PR_SET_INDIR_BR_LP_STATUS, PR_GET_INDIR_BR_LP_STATUS and
PR_LOCK_INDIR_BR_LP_STATUS

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
index 0b77b812e4d7..a384ce9ed25c 100644
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
@@ -370,3 +399,53 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 
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



