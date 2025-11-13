Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FC2CD4F4B
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A548E0024; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884858E0020; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8AC8E0024; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48C218E0020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E748160751
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:52 +0000 (UTC)
X-FDA: 84103736304.28.BA45197
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 213FE120004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0PxUrdx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994630; a=rsa-sha256;
	cv=none;
	b=4JyX6keQK9tcZqby9c4Y2Sg0Kzmg6RvivtOdHh3EbEc9SaYZdaNq+9ZposOsZrccDXTaSM
	dO/jojtnyDwxv5V6omU+47cfjlVZml+ATMQIcyJlIOEbcQjUKMmFo5w1CRVLhtVnw1nKXe
	XK1cEVe2sNYSZVV84haXWUe5tQwdRu0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0PxUrdx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994630;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvvMqEwD96nP7JIHpNe4W+P05Y0k+BVtovNZvMqdjHk=;
	b=4PcOLmZpcrJEYFiVd+zOJId8CyxS9My1Dv2d2xoWuXO798B86g3qkUxBYc0lWi1rz83hts
	1EXPN1mgJHQGN1DPcItS3FFl43ILIB8vYnoZzQcphHXDC6Ew32xVNA65CCw5ZoHlmodLZn
	6+tK1W66cG8BedjoVo/P2ioggf+yq0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B629E4475E;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 189EAC2BCB7;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994623;
	bh=vMYayqG7i34xaYjkz9IFwg9slehT42ee2ag10Gs3R/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U0PxUrdx037U/egN3S2eJTn6KoURkN1kfa/foZnVQrBMeD3Euag1YM2tedey/XhF7
	 TKM7JRIGEJ4iJzO6WgCdbhEGj0NH557viwr5G5FR2XomDc0WmTAMYQJ1uH6ubMGm9X
	 fr6J8N2KLl8niRiY8c13Ge+lYwlGxYg2rIkex14UJn8ruhnkHXflEJ5slFpqUPMCRA
	 i2PyGvEQaeprZ/sALcxa/nUXgM4LQtLzngoXteJOPsOP63zCfGsOdMbnIlesbM4ZAW
	 Ik/USVblBcyBrVqwy7jFD5pHQezgWW7pQ+XnlEnpGxmePewtx4bJguQQU35BSEeKez
	 fLH/vEPHEv7cg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF49CCD4F2D;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:12 -0800
Subject: [PATCH v23 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-14-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=5718;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=yFCOzn/pyDccak0xANk/vKLfOoWrfQcAvujrS/kNvhE=;
 b=EtFDJebpS2KNv9z97B4rIrgMJUXPW+AdSiq3o/RzvI757+wbuWYnE+/AHC45WEAhwOxJkPmyB
 EbAKcn3BonDBKpWXk8YBfDoiK5UgJbXTHakpPuQADinZKtfH6iLtPd1
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 213FE120004
X-Stat-Signature: ujjfbxiqjb7q5d88jqic45yeetskennz
X-HE-Tag: 1762994629-162207
X-HE-Meta: U2FsdGVkX1/4fWqMhMRXOmOE/AB49foe56+V+v0w+p3WPbcvZ/o7krZ2K2ypP7vMmGrwSt0be2+ym5HVmD/PdeJckK7PUgqBsv9BRNAHBgPvy7egNUQgz6jLhV+5+yD+7K3c1RfFYtUDhJLiBEnkVRwtm0qxq8KGwz8SS6VfTVghsQST+N5XJtavsYH0OdOOmr1m1U5LPa7xkj/GdDkRVGEdtCc3FzkFVoYf6NFfhUrmUzLG/dzJY1NBB5WkqoEPL7DgwM+PVH0sWG4cWN63lQf1v1c5WAvda5OBiDZr0XlSXIVcUqeRpTvWDGZVLrRz+i+AvfjU4WD889iWPu8CdwN+PwMTi9BzCpHQ5hey9l57/yuk2mTVX72V+EHLSkglwCKK8HVwzmHFdZ/+/D+GFYvhbkRIdcka1etSJiku2OQv8LGJ9ptcyJPhNFPqyMvr4OCzEy1pIVWpX0/BghQlP5E5tJuknoKfeGnc/fccPB9h39zc1RGkPuRkNxW87oYf+tJ8R1M0OaSEPPtgnEYUrp9cOunwyizx3k+7jyWpnjcJhXG+FM7mqsDNNjbOrxAP7if9syiK19v7b1A6ky6+Ra7fWsccECqACI52TUimGiYw819M0UQacNL3LXSkgO0qlNAu7nYOQJefvSWW2uYRqvmTlNxYW/TN/u3u0uI6+rd8aFC/ssQBqWLe//IllPM2QUd51yrmgrXvIzhCIrBv5T6QHbbFMAqihZWZDoGPn3MNJM+q8WaEjIuHsDKdgtdknB9wfqPqGLVUVGsEyUfRmUfoUsK8TqRrU9VK8DulcNP1iPS6nqoeHPYmZRZY96btWJlg61WxoNV/f/U4XvuzY1MnZDYSHvW5M6hUai0XgGOtIWIJermPzPpqBaXfbBmG0MqBM4vlK4ueoSF5vvdDZm+3OHfOotnb0dUQeXjATOEuiMrhYpybWe/zAEfIDWxmiilwrSPBqcmk5rIgJHG
 4l8wH0pu
 Tq4LX3b6suLmqTdz31Mfj01h8w4l0VXq+IgXMPv5cKUvpvsInCj/fw3e31MZoTM/fa4609Ic5q2OMRFkZH/RsjSfH4A2maSN0XnoS0pyXAUyB5Z99nADfuF5UGC+NNZ0uc1RKdGqXgw+l7ye7bCxxkjib5Qp8UB88K/L+R6Ni5Gx7ndlVocnye6WoHAr/euw9vJXL2TACTWbBBmDuj0O4XhROpgffynrKXqQ5aT9m9dVwrmq+rT+M6piHPo/inrSmYlE+R2Kc+QNZ8fabZJmONse4nwm/9VtmgyF2LZFvoheQLNQ2yNdt32KBqcbt/H1zDSsIDqO0RKz5JLBUOP3SUGrPSKuazKB3uosxmag9H1/Rz2UUsNWMIk1zFGhmSDO+spt5GyQS4fAE70cSTjYn/JSAJW6cCBrNNpLNZIaLCZ44jbVqIahc0Bi698HpS10Y6Dt3qmLYhPDCyf5c6dbKfA1gaLLL3EkyKRctD/G58hg67B2omSrCQkjPRw==
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



