Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95612D41D6B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2276B002A; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7CB6B002C; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474726B002A; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0316B002A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0A43B7A0B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:17 +0000 (UTC)
X-FDA: 84207856194.07.5E62499
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFAA980014
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bjOvZVm7;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473676;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vj1RhNAky83ImtAZbsOQhsg5a1z4AXSOGLkmHIbTUew=;
	b=ilkD5W2H4oK6LsDx6eQoeHKNk0Zt1ahejCSfktUMGEkDzABz5FcITNQ4217DR+c/oWtlNE
	C0qg6NvzmS4HCxzJe7T9z/O7nPqXUJjo2qNfxSt3QgmAvopCCEBPsDQT56VDCm4Xm/dyXV
	5s2EOBQry9YoNT7NiMXAPKCKtDfjVj8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bjOvZVm7;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473676; a=rsa-sha256;
	cv=none;
	b=ZXlXE+nQdwqafDI/14HwNsL3DSDNTeB+tI4tOcwY/rIWI7PUpojkIgdE3vlAlAuonW9Xqz
	MZZrnHI2R9XaFrnyUJxfJ7Eoj1jDmsrvSRA8nhB/D1zMV2553jk7jagqfbDnE1KX42X5HT
	7+ez47pKyl9fHaFa9fh4jaBym9CWYyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7179444519;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9F50C2BC86;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473668;
	bh=90T9j19woMM9Op8OSN5I1WP0v5lIdLoenKbGZcEa7eI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bjOvZVm7pr79RiolSeGndjB+jOX3zTxcKlHydvF+gmzWO+S2qmBrW4/B4Z5HBAbuD
	 ss8qgeclg98J5lAk/O5WsSI8Q89JbHvRuFUfYhE8D0pAivp5pAl/hn+B52jRlKrYNh
	 HZeGBc8tT7Q05C1l2PRBqPoSCa3nsFzNCS5dsAQ2b8u4+odoZK+1wVhpSx1dgUfDep
	 ipeNRRBtSI+gIW5tDViM0QgIjdj2h1cT2wPorz3qd80I5LN6iPWNOfa3O7JY3GRELx
	 WaxWlY1wxJe2bGEfkr+z6DwL48FjYbfhiO5Fk4KWl9672PYPVxha06v+915dBy0xLv
	 q67OilZr94I+A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D15D41D6B;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:47 -0800
Subject: [PATCH v26 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-14-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=5844;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=wFkoKafNuhuo5Khjoh4DbWfgN2zX7rAU3xJ3b3Vz/iA=;
 b=KNp9Df1Xy3jjdBJ66JMCtZKCAlsxxgs14113q7TFnm++4BGOo+0whVLyN1ucgVBUeyaapTI2f
 JMx65ciy1GNA9RXeAYm70vHEy/W8CAwkhtBuTW5HzfJJl7q+t5H3mQ2
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFAA980014
X-Stat-Signature: igqwm7rt1sztwgdtxtnoh6ufg6hehnko
X-Rspam-User: 
X-HE-Tag: 1765473675-748101
X-HE-Meta: U2FsdGVkX1/qcX6mUiGVBHzo9AwWhlLk91v8o/emyDcrgnGuykNDuvs0FiuL5SF0TDHAXwJjQkF1PxmNpL0p6idhYGo3cuuBO15FrkQtJW7H2vGaQc+1e2B20boB2qWxpWW0wvqFhobZceU0GCstqsDvFZSiCSlXsu2bguDToW1XUkkvbBBW+dah8Di3O7qpJrPZSKvMhHjFlh2YWUSUbb+ntg1CJri+TfS8zlhp7xGcyKpiYtvllOgyosaEdhXuZnuMU4HgoSp8fg1/ylu0stuGPZxpvC6brBV1eIQJ8AhG89xBoQa8ERfSOVKtMXUEC9kO/LbtX9uEDO7rPVJBeTCrCNgDmrLhPjpPY2stDPpaUumi2U/vU96ryjZkyqmpDWuQzk12/1OTG3Dn4LcnN1Z7QuQ2ZYTCL8GxXbRvcjLpygxDTriglvLZv+IkmATvnAhsb+WLcFjS5YZ24dXockN5wZwQOJjLmxD2EkOml7qRxxepKAtxb7eJGSHZRPsps2qKF9ssSp4ARdtGzQxmHYNpLj3rDd20AUztuZlaifLfikgaiujfhvm2MJqALDnh5DgpQmvHroHufK1USrQQR9p039sMQqlHUmlPdWWk2iyiUTPpN1iYISJRur5e7mD3yt2J9QyivtFR3283MyBOdpIMvhE3Wa8jT8xSlat3cD2t4YFz20Gtn0zXh3r9JH0bicCv5W29nVOSCBnotVsq1a7Myh9AgPZYPx5XKVVOKHOcV0lNZQkMKD0wdnBhEliEVOEC0JVyTIIEZ3G3yViO4UJ1eqYUedBsCT8bZ+tSQgiaB8D0Y/FWj5gYTv/LOvbGhPrzrnY9HRbHZCu6I1wIrIkmBs9HCSKuwcOETOtLHX999flpxemoV/9/B7MPb7iuPQuEKecXQCYki48Mg4FQASeFx9qeIJbP8oh2hind86HdAGQh/1gZv5UMFaugolix9uiv8/1srrtl30nC7u2
 og3Bn2Ib
 EqoZzs9eVsZFoX0dLT6seSqZNCEvro11rNJfu5PRYYP1pfco6HSRv74NvpvLmBjfalsc6AlDFdsrN28imwGkJ03hdsKixEIZlFruXGe9kET+YIvLojo/OiGVRqd2zPLEUqdrZYtrT1+ljGLzVAJ0v4HB8JL5nJZfwwkZrTRkUR+nEywjSymMDTURBT+FO9A8Yry2iFTgacjMYEKzZJiZY5nYcS9nKTxDfR1A4wWm/WwwruKYHa8t8Ji8xxfnRWu61getX5KWh8KCjw+Zwha/nFNhg58+yANtnNlj9B11DgPMRq9gtUumcM+tkX5A3MBFVzwYYhZSvjmuAOVj+hWIxOoeZSb/oGPhBVqfE4Uwd6iHm7yfxJP6EK9WYRJSr7uMeQerqiXcqNCslGHwJwWJwfSW6TZ3Mocua2sKVPEa+CE6WCAVP1D5O7QZf1+54JfVaoQFRztuxxq9wj+1SnGlUmczyy2Cm3KmCNg7uU4DJbbI4xSu6v2s6naZ65MI/UpY819JzM6o8ctOsUWarXs77WEqyAWh8TwvgWMktyOAA7b50XQ/khjmmR0RhfuvLMNex1Y1xp0/YeIIyUKJUeba/i3KVRo8bYJtlK0X8
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



