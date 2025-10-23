Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8C2CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433938E001C; Thu, 23 Oct 2025 12:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE628E0019; Thu, 23 Oct 2025 12:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151018E001D; Thu, 23 Oct 2025 12:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F07C18E001C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B806213C1AF
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:20 +0000 (UTC)
X-FDA: 84029969520.10.76FC9F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9119C40009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjRGrY5r;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AATeDl9YyMVudh6PLHJFvEPLb82Zh/Ea4fdCbDIeF08=;
	b=QUJ45xyjiw7xTuvCGOe3FBp7LMyzKB6O7J1owJDztUeGejTBnOEQIDiTjVyPz6OJ+o5u9I
	gvkrvVp8Ma9irUpUH7wzY/7hc80/pjA/kJN9fQtP8BtR78f0yCtaajHf2fZEo21zO4m4vb
	3MrB8JmDJ8DSr5lG4J2iE3hIZ4Oxbeo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjRGrY5r;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238278; a=rsa-sha256;
	cv=none;
	b=ocD2SFxtIVwFiO1VSspbIATfC1gbcLWzCEk3emtZ9P4a2wHQ/r2tSNGcymi1qRiTDn7qS1
	HpH9OxdaQrkfNI7JcQTFBaL6Dv9gscQOgDPTyoi5R2gEJBCzOwQfOCjLM8N64sOImOi4aO
	wtGyzx9LYLP6lUXQjIuOviyRP3tDGPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E6E44B0AA;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D13AC2BC9E;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238271;
	bh=jITwKi6/QU94R2n/wVFjXlji4euY1SMuYxJ9iDKSgQM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cjRGrY5rdrpdl9QbSwxyKgLEeEkLy6o7mZplM98qZn+qTPYwRuHJw8bKaDfXtxCI7
	 7ROuRG2SOsJI+yOfMopTFajb458MySLBUW2AInF1sxUk+PhHNzZ7mVIgS/l3CZ/BVX
	 rP69p4bcQei5vJOGbKqsgsvlVwyWFI2RufqR0eCqefrK9rKwYjsjO5BjSk84uoz4Sg
	 UBjvPkfXxZEagSvlB0mcKAZe2XF3f6Qcfegnd1kF9w3cUUqpbyw/eAXo+EhBqXBYvA
	 xcK6ike13WJnMiOpIuCneySt/WYzn8s84ivPmjI5nZMyvlmrWtRPkxZiAoi0mh4EQ8
	 KfvpVtV47CH/w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6AFCCD1BC;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:19 -0700
Subject: [PATCH v22 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-14-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=5718;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=nTPZyNBNXm6/CcBEgex+4RYKED4Z+c7hR2hQbyF4T7Q=;
 b=jVEGpJ5fOHaE/PBKTfFkdz54GjVoFhiyMmL9dxcCE2pbGMmsR6LWmchxWivXqD7Y1A8ZEFV+P
 up4JZGQoAGrBGQjkLupb9lcggEEYPaHyP8i4XYaXAMXGEruAzHVGNPv
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: sqfn9ek14tsuqzhedh336smbydffz1tk
X-Rspamd-Queue-Id: 9119C40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238278-465694
X-HE-Meta: U2FsdGVkX18481NZf4VJ0Xh8nt+RhaAo++aVaUUNJFCOH1bkZCB92+6O1lF/WJujeCwq0DgwEJ9pC3AsnyW3bjaY3gl69psCUUiIzmh3cyw+7BdMR6OeiV3otBLlwZIwQEW38u0qgOdza28VmvPpNcUxqlQWeE8QlimpiMC8WYvOGg7aYillnoyMWa+lOa/7fuiICpu8B19JOOi4d4agIGFSIaK3BhAVhIYuxhlSv3MT7CutBgUft8XTRreyhB/R/Sfw7969OiFcN1LWbnEIICO/i5vEy0qbMkVInyIEZDpr5XQFX6BVwlExUqQit8BSSOxDU7dDByP/4bbzamE4SXXIecA4HHYkmNUE+vqpQsuq1k7YEXJ51zO4VT0FKDHZOZ5XZVCI81hV+FROI1ns8jH9Nn6pSriOgFipM4UhgsdWNxIJ/oC+jPD93MNwzfc+hetYpM0OuhF1WPs8yiEWy4ctsi0/EkQAac2MUguyh4m7VBkBWSxaLzqTEiOg16ZEtkEQgk5uLdL5iKd9kSNUKJJlLA496bLKCZ/on4rv5B7CuOA5BuDPhYrN+033ZS7s+JM8SBqypO61aP010k0SiTB4mD3Dl8Q+S1Z0sshvyyPPjowj/YPC/j+nh+9QpaI3L04r4bRDEfTvmr/eIXSHGBBiZBZULn/hgzjNms33XJyO7dK5ZFjpQ5+8KjiDOX5/aWbYCfF7ocDNG8JA7Ecj7R2ygi8SjCW+qF4X0rZ47/IbuSvJR+dnqGm5pIircNGOE6iqf1JVy0N2iFfSMSOVdwPv+fzbAAeMne3QBk9Dlreb8UALWcAbf2rrEJvaGV81lZ8UaBTbY69da08oqbF4xwV0YdbVQetT+99qWgqvtRbWpAuwOkL83BAT9Gty85ivzxpDojVz9FSJKo/FrRQ/H/1gVX3+/u+vIpOGhNV0EH1d4eW2QeqrgaZ5biYfGPAzf7QlQF2nu9Ji2Hqu5ci
 OtErR1Us
 T8q4DDW4wh54iBi59hQ6BCd+oDINyyByT6VgT0Pgkl9IgyrVjr8FAiBJF462MVRc0E2hiJbRhPqIE3pWtDNU6FtTMMcbgAd/NMBxc+ZvrbXKm+7rGf54SUTp+HttA1IdVR5HdrbQEUYKOTFFD40IAYCqoUjn61jLQuQ1uQMkWuZjBlp8H9UNOYvtbHVHaZ92KPxJKNTN65L6YHhMLI1R6gcL/Ae9X5fsAUGy82Esq7Xp25ffFu8KjsweD9SE7flMY8tGSe8E32D3KQNvcJ/3nEOa+R2Oq4L7kQ/mUP30jvlI2/FsBzU44NZFp5TwlIDTDKqUvaP2cVcIRoAlrkhMU0V9U8eRs+xBiJlinTl1Pz7oQtfKajEB1A6eAjYDbnEtbPuwouRfOJ/MpbSc4gaxm+MNJlB6AFJfuVLIYBz3YWg8Nh0Pkbxo5RYqxtlMYXRQ7Ec+oQVOchiUfxfGTPGJB9/s2qUuWgEN7r77dYydCxkPYT7MagcY+E0DxlmhBsy26PCANqhgszGUckdG2RCAxAT3lOlm1i+2kod1H
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



