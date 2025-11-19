Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965EDCF3955
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1FCB6B0005; Wed, 19 Nov 2025 11:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7046B0096; Wed, 19 Nov 2025 11:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AEC6B00C7; Wed, 19 Nov 2025 11:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C10ED6B0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:24:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BDB41A059D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:24:42 +0000 (UTC)
X-FDA: 84127880004.14.10F4CA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C7D874000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:24:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q91IXr/F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763569480; a=rsa-sha256;
	cv=none;
	b=eIDFj1ctNVzlYGq7d8brZYdcR4rvyC0LZ8pOp2h+2w8WaT93s/OXiCc3UvXaSheRfewebz
	w02We274k2d+JLkH9OSvuZhh1ES2KclcbwTYbXUgRR3cW0csFu81Siph0ksieMdQ40fXQf
	UemxCQNhKqVmbZ3Nv1X8+aNfYRqQ4ek=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q91IXr/F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763569480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ock3HuqFZFInVYV1pAYFAUP+/cD+AaIgpUa3EDpJ8L0=;
	b=UgmoSN1ljD2mcDiKtOIt6K7R0JG2VA7dNRsnLTv5OuCfQkEREh1pPk79Jh9Vv40JHSNXr0
	urt7DCpfG5i1BjZSfZO7tXYm0dVPRxcfvLKrKXRJikd6y7MDVSGcOXizx65Q+aW0HXTlTL
	/2RqbVm08beFIV6nPfbu2RLOZIktips=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28ED060171;
	Wed, 19 Nov 2025 16:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11197C4CEF5;
	Wed, 19 Nov 2025 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763569479;
	bh=k3LKx2x4kEPnJQVwGRf0BS2K3uQDuHJQ6+W82NgmB4U=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=q91IXr/FpjdsiUfmpoyz/2nEsOf60mmtnyRCeNB86rSzln+6XviST7nII7FsP/XcK
	 wLlmNZgEqFAJ7ypIFNyzrd2D4eNzeW9BoAm7mLjh8+Zg3nsJMb97OoUcXVWs+XvKg9
	 yDYmczcFZeERuo0q3WC9xt46q9vQCW8sI3TwG/oI/8DZB6uusSZJ8YIqiE+TL7lvB+
	 ts1ws3T4/eZlTPMEAYX//AniaoBqPGuiRu1Gf//Hy1IF/oyfJvjCPYrG6E2+QKrLu4
	 I93h1QyDa+3rw9uSNLp6wKIDlQywPu3emfYacThDvf5mOL6dU0T6oghzj+IZ0gdjLu
	 HtnKa42PoijKg==
Date: Wed, 19 Nov 2025 09:24:35 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
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
    =?ISO-8859-15?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Andreas Hindborg <a.hindborg@kernel.org>, 
    Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
    Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
    richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
    kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
    evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
    samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v23 21/28] riscv: kernel command line option to opt out
 of user cfi
In-Reply-To: <20251112-v5_user_cfi_series-v23-21-b55691eacf4f@rivosinc.com>
Message-ID: <fe83a3cc-e8fb-e15b-4673-8caaf1ab39b8@kernel.org>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com> <20251112-v5_user_cfi_series-v23-21-b55691eacf4f@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: C7D874000A
X-Rspamd-Server: rspam07
X-Stat-Signature: iohrermp959cz7bp78e6yoickk9nxu9i
X-Rspam-User: 
X-HE-Tag: 1763569480-863981
X-HE-Meta: U2FsdGVkX18Cq3NT/f7UY4P6ApckofAfiKH2o/r6eb6vjQEkgtF8q9+xeBc2TePnAeVX9wWum4UpbqO3eRfTT3ub3508vDGZlyAApjHmlngvH5bDtAVWkrN+GuC3czcECCMZCFqs0LhjnWtIuGhKHVULkjYKfe1W0Sg4CAuCbRnF23JpBgfB20M7YPZ5ddvO53VYx7k475C5JYsG3YsMQNVlA9aogPSeBLy9dto9h95/NIKlN6YUAJn2LrtV2l1vxMSkVX/QIZjA/akpG9X/tgpuJsMY2EGHIDtklW+DU0v87Bwj6xs0NzI61Ap4uc2KGl01tGBLRr4zUnxgS2RI6Sa5YO+lX3oRPIWmEC+4kZzL6dnysD3+IeM+lki5/rbNS7GURvNylaSckshjEuwur8LDweUIlCOXAbtk96htK7ptovROm2oUCP8HjhO0A+DIFN8yiff+KT7Eo4CcTCY5BmWGUzeeZVsj8rHtUUdoIivbp40AAwKNYrB/I1EWwR4+BzG4WRpoRsMNqMGxaPRDSgIhU4/WT1QFy5w0Vw7yytKfC9ruWRutZekeihPQa/y+96GIlM8Ve8uW6TIwgOxgElLWm4kV4yFjGDsmf0abDSwHIBoetZJQ9bMP+QAkJNpkGvynokNfhVFeeXxY/rdVnuMv4U+YMJm6oesEMQyloPSbnkh61MGy+29riFjHzdsclCPmnOhztoF+Cz67nx820m0LBStstwZiowJmUL+XU2QGd+mV1Urd/Um9MAHieehU/PJc0elRgHiGqic7XF4pivazbUcWTfrlmw3sK1lVGRmM35I9KdK9rE80hiwoVFHEzb0aeA5vTkGQoSmwEEAURXRoz/hB1rBWkhoFmNSiMeDEIYvc3XCscuRhRQY+iORNkBhN6rwq051YB/9Kb1+/NkCpDuDYXJYmBg4BsKqurWzKbQy6oCicoTHbzzk3FAGmezs0GDtoyU5VSrGdn4h
 8hMqTkk1
 ZOZ+g7vxVLtI5yptvX+rU+NehF/yTFtsyGu5exrhhtzyoisi5/HcVjjXrIg43gaX+hb9Fa6ugka2gZLxxa+WL5HkguFFWpSNEzaaNuiwDuIiW8vyhIipyzmOOOoljzJbTgvQKbYCWhTZfgWM4ICF9kbBkAp3ycIjQvpWH8LF3nttVIGsdti9+FhqamXLpdH7cu7cRC+il7LK4MELesdkouINcnbVB7uPTnHSx/FC2Bkdc1QB6edkei2ZNwQ+/pMHAW8yC6+iEo+u497yuuR9P6XBMI2oo3a+B9KYfxZ1b4Bh70SbLr9jlDqBFEMiOXt4fRwo0zl/j5v2inVWm61kwTtfnyfbl8/1B3PYCVpphrPSG5VSng6/M54SfvTRFr1vVHvbMb2vX6XY/VPHFZyh5kkIzUwwi6EUn8sZbwT6lzqxlF6yuPOD9iI14zJnUFvzwp15i7kAKhSrn+l7+CC2O4mZX9sp6L1c1eMEISwRs12T7kBctOU9KdaQY4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025, Deepak Gupta via B4 Relay wrote:

> From: Deepak Gupta <debug@rivosinc.com>
> 
> This commit adds a kernel command line option using which user cfi can be
> disabled. User backward cfi and forward cfi can be enabled independently.
> Kernel command line parameter "riscv_nousercfi" can take below values:
>  - "all" : Disable forward and backward cfi both.
>  - "bcfi" : Disable backward cfi.
>  - "fcfi" : Disable forward cfi
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>

I fixed the checkpatch warnings on this patch and cleaned up the patch 
description slightly; see below.


- Paul

From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 12 Nov 2025 16:43:19 -0800
Subject: [PATCH v23 21/28] riscv: add kernel command line option to opt out of user cfi

This commit adds a kernel command line option to disable part or all of
user cfi.  User backward cfi and forward cfi can be controlled independently.
Kernel command line parameter "riscv_nousercfi" can take the following values:
 - "all" : Disable forward and backward cfi both
 - "bcfi" : Disable backward cfi
 - "fcfi" : Disable forward cfi

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Link: https://patch.msgid.link/20251112-v5_user_cfi_series-v23-21-b55691eacf4f@rivosinc.com
[pjw@kernel.org: fixed warnings from checkpatch; cleaned up patch description]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  8 +++
 arch/riscv/include/asm/usercfi.h              |  9 +++
 arch/riscv/kernel/cpufeature.c                |  9 ++-
 arch/riscv/kernel/usercfi.c                   | 58 +++++++++++++++----
 4 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..453127ef8746 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6453,6 +6453,14 @@
 			replacement properties are not found. See the Kconfig
 			entry for RISCV_ISA_FALLBACK.
 
+	riscv_nousercfi=
+		all	Disable user cfi ABI to userspace even if cpu extension
+			are available.
+		bcfi	Disable user backward cfi ABI to userspace even if
+			shadow stack extension is available.
+		fcfi	Disable user forward cfi ABI to userspace even if landing
+			pad extension is available.
+
 	ro		[KNL] Mount root device read-only on boot
 
 	rodata=		[KNL,EARLY]
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index ec4b8a53eb74..7495baae1e3c 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -5,6 +5,10 @@
 #ifndef _ASM_RISCV_USERCFI_H
 #define _ASM_RISCV_USERCFI_H
 
+#define CMDLINE_DISABLE_RISCV_USERCFI_FCFI	1
+#define CMDLINE_DISABLE_RISCV_USERCFI_BCFI	2
+#define CMDLINE_DISABLE_RISCV_USERCFI		3
+
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/prctl.h>
@@ -13,6 +17,8 @@
 struct task_struct;
 struct kernel_clone_args;
 
+extern unsigned long riscv_nousercfi;
+
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
@@ -83,6 +89,9 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #endif /* CONFIG_RISCV_USER_CFI */
 
+bool is_user_shstk_enabled(void);
+bool is_user_lpad_enabled(void);
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 106f6bcde5c8..b220fec9a239 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -28,6 +28,7 @@
 #include <asm/vector.h>
 #include <asm/vendor_extensions.h>
 #include <asm/vendor_extensions/thead.h>
+#include <asm/usercfi.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -45,6 +46,8 @@ struct riscv_isainfo hart_isa[NR_CPUS];
 
 u32 thead_vlenb_of;
 
+unsigned long riscv_nousercfi;
+
 /**
  * riscv_isa_extension_base() - Get base extension word
  *
@@ -277,7 +280,8 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 				const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI))
 		return -EINVAL;
 
 	return 0;
@@ -286,7 +290,8 @@ static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
 				const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI))
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 33c955d56eb3..d7a973c58943 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -17,6 +17,8 @@
 #include <asm/csr.h>
 #include <asm/usercfi.h>
 
+unsigned long riscv_nousercfi;
+
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
 bool is_shstk_enabled(struct task_struct *task)
@@ -59,7 +61,7 @@ unsigned long get_active_shstk(struct task_struct *task)
 
 void set_shstk_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
@@ -89,7 +91,7 @@ bool is_indir_lp_locked(struct task_struct *task)
 
 void set_indir_lp_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
@@ -259,7 +261,7 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
 	unsigned long aligned_size = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EOPNOTSUPP;
 
 	/* Anything other than set token should result in invalid param */
@@ -306,7 +308,7 @@ unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
 	unsigned long addr, size;
 
 	/* If shadow stack is not supported, return 0 */
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return 0;
 
 	/*
@@ -352,7 +354,7 @@ void shstk_release(struct task_struct *tsk)
 {
 	unsigned long base = 0, size = 0;
 	/* If shadow stack is not supported or not enabled, nothing to release */
-	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+	if (!is_user_shstk_enabled() || !is_shstk_enabled(tsk))
 		return;
 
 	/*
@@ -381,7 +383,7 @@ int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *st
 {
 	unsigned long bcfi_status = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* this means shadow stack is enabled on the task */
@@ -395,7 +397,7 @@ int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
 	unsigned long size = 0, addr = 0;
 	bool enable_shstk = false;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* Reject unknown flags */
@@ -448,7 +450,7 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 				  unsigned long arg)
 {
 	/* If shtstk not supported or not enabled on task, nothing to lock here */
-	if (!cpu_supports_shadow_stack() ||
+	if (!is_user_shstk_enabled() ||
 	    !is_shstk_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -461,7 +463,7 @@ int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *sta
 {
 	unsigned long fcfi_status = 0;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is enabled on the task or not */
@@ -474,7 +476,7 @@ int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
 {
 	bool enable_indir_lp = false;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is locked and further can't be modified by user */
@@ -498,7 +500,7 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 	 * If indirect branch tracking is not supported or not enabled on task,
 	 * nothing to lock here
 	 */
-	if (!cpu_supports_indirect_br_lp_instr() ||
+	if (!is_user_lpad_enabled() ||
 	    !is_indir_lp_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -506,3 +508,37 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 
 	return 0;
 }
+
+bool is_user_shstk_enabled(void)
+{
+	return (cpu_supports_shadow_stack() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI));
+}
+
+bool is_user_lpad_enabled(void)
+{
+	return (cpu_supports_indirect_br_lp_instr() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI));
+}
+
+static int __init setup_global_riscv_enable(char *str)
+{
+	if (strcmp(str, "all") == 0)
+		riscv_nousercfi = CMDLINE_DISABLE_RISCV_USERCFI;
+
+	if (strcmp(str, "fcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_FCFI;
+
+	if (strcmp(str, "bcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_BCFI;
+
+	if (riscv_nousercfi)
+		pr_info("riscv user cfi disabled via cmdline - shadow stack status : %s, landing pad status : %s\n",
+			(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI) ? "disabled" :
+			"enabled", (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI) ?
+			"disabled" : "enabled");
+
+	return 1;
+}
+
+__setup("riscv_nousercfi=", setup_global_riscv_enable);
-- 
2.48.1


