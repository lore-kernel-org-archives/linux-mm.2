Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B94DD41D74
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E55C6B0028; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE296B0029; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176226B002B; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8EEE6B0028
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA426C01A9
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:15 +0000 (UTC)
X-FDA: 84207856110.11.73F6E30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AB8FA16000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tN25kedp;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473673;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYQCaogP1Esx6vaJsC/4o2UG7lEx16aXFTaBTkgr6JM=;
	b=N4bS50yqLjB9E3Fa8P3zx7tL9V+3vP5Tw55zg+0zDi01NQJ64oDfwSp/M0y1ZNMqtYcpiW
	J76WGXOcjLXA5FzJzbonpal9AeQuWLrbUPhBHJWTBpA7h3tZSdmIPqp+0v0+bELDtJkNe1
	LXSU1/xkLW8Oiaiu0UBZWYmViMTJtHA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tN25kedp;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473673; a=rsa-sha256;
	cv=none;
	b=ZwUNFq9jAIqTmANTxCRIq+I7H6bvDOLHcJIzPdeXKygpQC4crzU4fvZ/usgWNgDZAGqvKz
	wpBgOWlDyX8Ts13uZFbCGBrAtSaYzHJ+6m23IK6N2pQIe3aOSSqjYnLveEziDDQsF3W0A/
	H7zDf41P3Ktyb+h59Txy3Sc4WfvXc1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C80F444F7;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1CBBC2BCFF;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=YQg+XVHKEI/+k3SQ8JtN+2+b+t7JDDMJ08bQo4q+FJs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tN25kedpKxCi+6MaXleTBK1/skuWFmyppRKSZTPRz0mK0XFm6lOe5xTwJuxPUftwP
	 2SzKfTMOtFi56P5Q+wIJnWCOPAQg9ZLsUYJJ57FijaISXbm24lMCjXBYioG6l9BVOX
	 CqRz4LaLU7hCk3oHfgF4moKyu4SSXzovFpdhVvxPLOy6cFl6/QBFDYYGh7LejhYyzn
	 RXX9mGVqrbInzWrPTeJphBUHB5F11z2aFEUjvoq5G3eVBYFFvaqciLwkgUkoHgkLDg
	 DKtveHgLZ4zp7Hj+mtvuGKLnfrmLyAIK6gxv8cJVmckXrRU9IJccV5TF7o3gQItotH
	 Koys7htWKT2NA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92930D41D6D;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:45 -0800
Subject: [PATCH v26 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-12-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=7555;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=j8/8VvndI2qVQcHHX8TNZcByjmD2v9rRKoH3o+WjKYE=;
 b=6dvQoYs0cH4e+t7/RWF8cVBCFHzvlhJ3C5M5pCcAxUrmbJzxdbyC5n9rZYVBFgXfXGYEYLvRD
 69UxWHtuoqRBDJmz2u4Ib6OKR1Uv623mT72hkPX+Wbbn52goHslbkrS
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: k5yzzjw84u5rq7p8a8381z6yy4j6q4ko
X-Rspam-User: 
X-Rspamd-Queue-Id: AB8FA16000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1765473673-81549
X-HE-Meta: U2FsdGVkX18ctSQyq4xW5cZBAvP3kNh7h+VBZkBQDbOapRnJq77a1kOdqOHe/l8ygrlzbk3C5D8b+JxcwGqNFiD9fQhnHU/CX10KUjqaQRgbfE/DJOMes7f/N7GiSS+h2OkmJNiTJYt3oJKKgC5WWfVvHjaxg1eoWlKq6PJ7FoWWvwuIt05a8JBG4KU3n44i8Agd7y1IVipH5IyelATK43tIWWgpvJhQa25pFLQ5Hgp5daKCEEDcjEaRyRDzRZZoa/b/UEcLvj29vmGYqLDLcV04NAPkwW/V72fKUntSxdyGj5QHpCIXY5D16Ysqe4eQF3X5M5q5UrZj2qTgooASJ7QaAwvHYff4ZNTwqm4o1Z4WYMSvBYya2oQgZPg+XhQgesH2J9eO1P3qL1rT3KaPUA/mo9SvrKs3ek4zuvKscAQbv7O+z3HPbHTw4EIQ7yy4Vji9QJX3xyQWidBrpHi7eU3h9TyjhkvWwVjvxpp7hMB2TG0Z9WPcanrA3bQDD5Z5xGsm8yYBQgiLEi1a1Fw68oAHf3OYZxOVgT3V+QRdLoe6nlaxApL0TK4LlL6cWaLaROfcl8v0wS6dw5izzYd5Yqex07fTjZvKAQ9JHyToI4LgSzTFBHuBVcDkKLteIJNkuaBDkjCeO4d4k8N/bQqhcmBl7hjNS4O3iCgZx2gyov8wJGSGxqvE4JGNuP+6T7iaJ+eKMiUyfbi+nyY9pYghcMMdafOxyltNtqcFqrCceNV10pTvm3V8y6fIqXecd1cavzGtuSF39Y48FlgcZiWFrh5zXlMBQrP1btGPzARi17tpXClZGMbdatJ9qtfY6cQIVU9ZNksJPVZZjZWtXravGTYenV5KR4VQFsmxLtUOQ4ylMKABkVl/dLPJkK/1aaV26w4Dr+Usa9dUnntzGDcFvrIcVFgev0kOI0Nds9ak3172Msura742l4mqejb6k4kOIk0VHSshiE4WAdotUf9
 8kOTSp/V
 eInOpAtisnHN338E1SeRmH10ERZxj0jvOfaUtBUzf0eLjQNBmNby1/+IvZXuhnbGUp5a0WKp2cgipaNYvHyWMjpSpoAUnA6t8ULzNTHGJZ+feFssAr4qn6XFFRf5sZH9xQpuby1+z1VgZFpJ1SbxiW50yVy26JxBWJOLZzHwenobMLVtA0ckxu8esw749sIXZ2zybD3vOks2i8ofL5fp11pj6XjuBhHuGpVymPtyJ1cKOEQBCRnDAi0pBNAKBxUqjO8AcBy6V3NtS3vRyGcbn8bK8l9opLoC1PtPTh/vZ9Ixi4JC6nEd03jMkuFip5N3QDgGruqpOW5bbff2lz+IRNLw45PZl8FJsT9R7JJdw1hyoudYflem9fRe0Z3a3TOrxVc19aocrO7gABXT07swDuqn8NwlFKq2uEexbMvzEAM5BXcNURDkpzeOUM+Gi79YQWCNbd3CiDTlWYPDLifw2X+KYzfkZclOpwMNF/dSui4oVoq4gK6O7csYomF4yNYgFUXorsx9qoYTuBecK+7vpJYsJP1DI0ed6t9JvYXgdcXq2ztjvKkMtfF9t31h0FVJVUkg2VCxtSivZYjEnCnuH+wVJDhkTre/alQMp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Implement architecture agnostic prctls() interface for setting and getting
shadow stack status.

prctls implemented are PR_GET_SHADOW_STACK_STATUS,
PR_SET_SHADOW_STACK_STATUS and PR_LOCK_SHADOW_STACK_STATUS.

As part of PR_SET_SHADOW_STACK_STATUS/PR_GET_SHADOW_STACK_STATUS, only
PR_SHADOW_STACK_ENABLE is implemented because RISCV allows each mode to
write to their own shadow stack using `sspush` or `ssamoswap`.

PR_LOCK_SHADOW_STACK_STATUS locks current configuration of shadow stack
enabling.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h |  16 ++++++
 arch/riscv/kernel/process.c      |   8 +++
 arch/riscv/kernel/usercfi.c      | 110 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index a16a5dff8b0e..d71093f414df 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -7,6 +7,7 @@
 
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
+#include <linux/prctl.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -14,6 +15,7 @@ struct kernel_clone_args;
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
+	unsigned long ubcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -26,6 +28,12 @@ void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned
 unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
 void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
 bool is_shstk_enabled(struct task_struct *task);
+bool is_shstk_locked(struct task_struct *task);
+bool is_shstk_allocated(struct task_struct *task);
+void set_shstk_lock(struct task_struct *task);
+void set_shstk_status(struct task_struct *task, bool enable);
+
+#define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
 #else
 
@@ -41,6 +49,14 @@ bool is_shstk_enabled(struct task_struct *task);
 
 #define is_shstk_enabled(task) false
 
+#define is_shstk_locked(task) false
+
+#define is_shstk_allocated(task) false
+
+#define set_shstk_lock(task) do {} while (0)
+
+#define set_shstk_status(task, enable) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 72d35adc6e0e..a137d3483646 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -156,6 +156,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->epc = pc;
 	regs->sp = sp;
 
+	/*
+	 * clear shadow stack state on exec.
+	 * libc will set it later via prctl.
+	 */
+	set_shstk_status(current, false);
+	set_shstk_base(current, 0, 0);
+	set_active_shstk(current, 0);
+
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
 
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 872e0c52e034..0b77b812e4d7 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -24,6 +24,16 @@ bool is_shstk_enabled(struct task_struct *task)
 	return task->thread_info.user_cfi_state.ubcfi_en;
 }
 
+bool is_shstk_allocated(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+bool is_shstk_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_locked;
+}
+
 void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
 {
 	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
@@ -42,6 +52,26 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+void set_shstk_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_shadow_stack())
+		return;
+
+	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_SSE;
+	else
+		task->thread.envcfg &= ~ENVCFG_SSE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_shstk_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ubcfi_locked = 1;
+}
+
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -260,3 +290,83 @@ void shstk_release(struct task_struct *tsk)
 	vm_munmap(base, size);
 	set_shstk_base(tsk, 0, 0);
 }
+
+int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long bcfi_status = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* this means shadow stack is enabled on the task */
+	bcfi_status |= (is_shstk_enabled(t) ? PR_SHADOW_STACK_ENABLE : 0);
+
+	return copy_to_user(status, &bcfi_status, sizeof(bcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
+{
+	unsigned long size = 0, addr = 0;
+	bool enable_shstk = false;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_SHADOW_STACK_SUPPORTED_STATUS_MASK)
+		return -EINVAL;
+
+	/* bcfi status is locked and further can't be modified by user */
+	if (is_shstk_locked(t))
+		return -EINVAL;
+
+	enable_shstk = status & PR_SHADOW_STACK_ENABLE;
+	/* Request is to enable shadow stack and shadow stack is not enabled already */
+	if (enable_shstk && !is_shstk_enabled(t)) {
+		/* shadow stack was allocated and enable request again
+		 * no need to support such usecase and return EINVAL.
+		 */
+		if (is_shstk_allocated(t))
+			return -EINVAL;
+
+		size = calc_shstk_size(0);
+		addr = allocate_shadow_stack(0, size, 0, false);
+		if (IS_ERR_VALUE(addr))
+			return -ENOMEM;
+		set_shstk_base(t, addr, size);
+		set_active_shstk(t, addr + size);
+	}
+
+	/*
+	 * If a request to disable shadow stack happens, let's go ahead and release it
+	 * Although, if CLONE_VFORKed child did this, then in that case we will end up
+	 * not releasing the shadow stack (because it might be needed in parent). Although
+	 * we will disable it for VFORKed child. And if VFORKed child tries to enable again
+	 * then in that case, it'll get entirely new shadow stack because following condition
+	 * are true
+	 *  - shadow stack was not enabled for vforked child
+	 *  - shadow stack base was anyways pointing to 0
+	 * This shouldn't be a big issue because we want parent to have availability of shadow
+	 * stack whenever VFORKed child releases resources via exit or exec but at the same
+	 * time we want VFORKed child to break away and establish new shadow stack if it desires
+	 *
+	 */
+	if (!enable_shstk)
+		shstk_release(t);
+
+	set_shstk_status(t, enable_shstk);
+	return 0;
+}
+
+int arch_lock_shadow_stack_status(struct task_struct *task,
+				  unsigned long arg)
+{
+	/* If shtstk not supported or not enabled on task, nothing to lock here */
+	if (!cpu_supports_shadow_stack() ||
+	    !is_shstk_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_shstk_lock(task);
+
+	return 0;
+}

-- 
2.43.0



