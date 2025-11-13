Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80DECD4F3E
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB4B8E0026; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CE88E0020; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1325F8E0026; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDB8B8E0020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC07A13BA0F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:53 +0000 (UTC)
X-FDA: 84103736346.28.1CAA152
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BEF8B40007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=evpcXltl;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994631;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6u9QxdNqXq06+ImFyQCsEjxQqun/yR2QdJYrlH0OG4=;
	b=oeJJ/vsDTfWPFYH5ywsAGY6EyGjA3X9HC/Cvsfn5Q4cec8ixSFaGUgf0diiEEHs4jY4uXs
	s9eWqZDrVTMNQDmlveJfd9FbtRrU4JW5jup8nSv+T2SYPLreWZnB9D42uGv+4whxvpJZa8
	I9XuInFQQRpprInQameeDoeHZMaZ3Dg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=evpcXltl;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994631; a=rsa-sha256;
	cv=none;
	b=ILjpkoPDXgfdvSpdRH2WsFJhF0dAgNW2EmM73JxddnrrtEv2K21ElXq5ax5Zx3fBWCP9Xf
	fg19JdDcHwjQzCsAsVvc4EPM6Y2ipRg0oV5loFGknZyjNQfi4PtWPWTwdTSMml75lyNiHP
	nEOok5mfqKYQb0EYNSe+Q0S79+sO/uQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0B184470A;
	Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B54AAC4DDF8;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994624;
	bh=HKdxlKiYfC7gVn/aunooVBQmfCDOQtf8SuU7aFOYBAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=evpcXltldGuOs+GPB/LJs+gvJlh6iG7GC90+s2tUvB9RZJeGBu9ua/BumjcLMs2vD
	 0KFOYKtvg8/Ca8KMgBWvczHG/8rArAXlyyxj363CdDY8lKkpXp3dNwcauHRkEJ47x8
	 R5JPykb3yMNy6oRUZV3vZ1V8wWiqcCIiCDK/xR6W9c739SjesA6Hr7jlefuer79r12
	 dpUwAkH42Yn5ekKHIVMZtHhKsj3X2kAkkpe2JdbIoHeLojbUfLdoyVq0dvVLjH6RAR
	 egwmMRWmlcLalnnUssCKQP4rFqp4bRZZYCk78RIXf3bOddTJCkxFOReXD9E8W2nTcw
	 v1n0ZQXhtwaLg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9117ECD4F2F;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:19 -0800
Subject: [PATCH v23 21/28] riscv: kernel command line option to opt out of
 user cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-21-b55691eacf4f@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=8589;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=OqYE0aMrH8X+SVsss7+/Q6PJ1Oaq1SqU4KVOCl6loKg=;
 b=2u+gmgpLTJTfsoL0qsTGga4/vCriFKPHXeaaejCnNhks5UsnpInFjQY6bWQ/h4au0xIK3Wpd+
 XbHoSfxIrfFB121Z4C8QsAfufi3SN1UWrBgM9S0kQWnI57UQZiF0DXB
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: BEF8B40007
X-Stat-Signature: c56a9rtph1q9ix5n541hxf1pp1yh8f9e
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762994631-463321
X-HE-Meta: U2FsdGVkX18HVRQ1yyo2QjgzPeXIiIPdoPdCAmhyZN1LSHl3CjO32u91nfPn0YX4tWn5dPhw5n9R2/ZAKhvQJRvJlgnEbioWZTR+1tAkJaibFTC8baC0wtF7ojrvDpPG5MujSl7cOVpDI6SU71ARkSe4aavRp4STyIW0JETMuxo6Gk+8F7cPFQ6HoZkwwpKwHhVYgCFJibozRxGdruImMLRlMec2CeSTLmpqZkr7Ha3hovQyEqDrnCEZFwCjfqYLg4nsQna6DfxCYGx7MkICmOXx2x9N3a0NfgMTelTk6oU9BtcqhtUdAZW5oCbvn+Us41ieCExTc5FNCNGPauiUwsBBjZVeBDk0fKQn5iEsJRgFyF6aTGcW9wbQDBiB52vv79a/QYpkcderMZY+SJxgeyyKzJptHKAN9LauUZ0mNaEDxf6ugU/mosEqhvkJydsAeH+2BHIhaeHqOE0gWPJ1ASFfuJRWmKrZ0MOQNnSsbPIBghcpem4XRoJ5OOFYZoqdPaKZ4IBSLD+xuKdYUJARmVTM54nQw1kE477rl7LunoyvWrzsokUD8gSSvmZwFkWs6N5ataef5a1ILLY/pbzO+G57u3e1MIN0/3jVQ+sbiHwibWjOQMlugV36zfy9KnIbTe/mn+HWBdaoGxuaFdz3I5VhW8yNLNPQEqY6H4MoxKY08SL2SGcEbuxu1KdF0KxoI9d36kC3iDSCB98XqHO82ceQs+Wh4YmMknu8Cap+GtNGFk59AF2kvzuEUtI2p0WKQp3nNNM/y6ka+RRqozZzSXBfeKTpGGD55BPVVN2GlloMKTvdblWOMA3QufFQz5wZ2KN3GwPpNZFrpUeKWmPP96ya++ZDZIZgI4Z4vIYQh5aYHZdHYXuAphgd3lSYvJsEv7bmYQvpJkLBs22B2P1UN1+axB8bjQL3QeUsKQTKYN/w5ZBkoLqz2b6kIVAJWOIYi250GOexm0qH6V1pehr
 syYbC6VL
 bEYCbqXUWvgiqgF+6wqV83l3KA6pjvuEmcg5Gp3bT+NugZBiBmRA6Y4ka97Ty0GQxDKNaNzwpkiqL68SfH/fZkqQkELEcD7hdpL5cxZZQsCpZp5C5Y3/LFaT3sXiqq/Us6y5NTj+BUeKYN3EObBk5VFe9JTHzk1yEMqjVnurF/X9SEVaTL7D0GaQcX3TBFFuBoKfIXPNO5mWpHLWjkFvslaHHScfjQb8NzjlZFSP3NyNNH458hzb1DKdEAsH7rUfrLDaL2rpuRtesVCMYxYg2TGDWz5MCga1byzZ527CnhbsljOKsiwG1H8AZ1zx+/Y8sfa4+ycWk/iN963yM6n60LKqqhXt7Im+clqPzgDUZ3RyQt2zzxHWQDEX9TQbWjJj4MhcXB96XcICNxz1DyCwtp/3qKVnMkqF1Gm+b54WK9px/t845Vb4f5JGDucoRwm19cK4rX2pWHRxtxb18u47AdEMYWEJ/iWwxZ9J1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

This commit adds a kernel command line option using which user cfi can be
disabled. User backward cfi and forward cfi can be enabled independently.
Kernel command line parameter "riscv_nousercfi" can take below values:
 - "all" : Disable forward and backward cfi both.
 - "bcfi" : Disable backward cfi.
 - "fcfi" : Disable forward cfi

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++
 arch/riscv/include/asm/usercfi.h                |  7 +++
 arch/riscv/kernel/cpufeature.c                  |  9 +++-
 arch/riscv/kernel/usercfi.c                     | 59 ++++++++++++++++++++-----
 4 files changed, 70 insertions(+), 13 deletions(-)

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
index ec4b8a53eb74..451bfa607745 100644
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
@@ -83,6 +87,9 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #endif /* CONFIG_RISCV_USER_CFI */
 
+bool is_user_shstk_enabled(void);
+bool is_user_lpad_enabled(void);
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 17b9e77bafc3..4d99e55abf81 100644
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
 
+extern unsigned long riscv_nousercfi;
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
index 7f01befabd11..3ca8b9be28e7 100644
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
 
@@ -506,3 +508,38 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 
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
+		pr_info("riscv user cfi disabled via cmdline"
+			"shadow stack status : %s, landing pad status : %s\n",
+			(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI) ? "disabled" :
+			"enabled", (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI) ?
+			"disabled" : "enabled");
+
+	return 1;
+}
+
+__setup("riscv_nousercfi=", setup_global_riscv_enable);

-- 
2.43.0



