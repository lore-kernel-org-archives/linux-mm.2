Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190AAC4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0316C6B00A4; Tue, 21 Jul 2026 04:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E316B00A5; Tue, 21 Jul 2026 04:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61546B00A6; Tue, 21 Jul 2026 04:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFF36B00A4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00AC3A0459
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:22 +0000 (UTC)
X-FDA: 85012084164.27.AA5A667
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5EA340006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=17j3JqfB;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aoqKVccsrHLgQ9VNsY6Oa6KnpX+y7UKI6ZcuKj/c97I=;
	b=fEbZ3EYJ+ITRHU9F/j97kOUoj0SfRp3Rq2Zu0OtspG4suUfmBxQwcjyvE9PlsUcp5iHD45
	lLTw+JU+qAAS8XTrNvLMjpIp14DhPLis97dl3K+ck5hWjLmoF0tB1YeOXQQ40HgrVerPzZ
	x7a+n7g35yXrxS40Si2nigdRViUbdcI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=17j3JqfB;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621960;
	b=mRsXBBX7IdS1Xfn54kA2HrwidkPv/MCuAZYf2a6av18fjVcVkmdrTb1M11TLrF76tm9B85
	FivDovGbH2BcNgFkiU6UpD60X9unCYkohvWw1UWtCvq4QrMhGsNNo+sm1gC7N5bLrazpXF
	K9evenXmtpRksHizfJ5xIkDBW9XVpNI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aoqKVccsrHLgQ9VNsY6Oa6KnpX+y7UKI6ZcuKj/c97I=;
	b=17j3JqfBDHRcDUwEcusDBhCtdSqmtpzKLUkptdBx4Am6KoznmfMlGWc2qTcr/ZXDlCR1tDAlm
	BfTaDSIA6b/+xf7kLr8+vaurIgnM2x1G+E2Y6aNhoyui7YOly/e+MMcehpUP7FOBemgqerQ09Hz
	L3vvZVvVWa+biLpZ6Fiuamc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h49656hKxz1prKd;
	Tue, 21 Jul 2026 16:09:49 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 0316640575;
	Tue, 21 Jul 2026 16:19:14 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:12 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<linusw@kernel.org>, <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>,
	<yeoreum.yun@arm.com>, <anshuman.khandual@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <broonie@kernel.org>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <liqiang01@kylinos.cn>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v17 13/15] arm64: entry: Convert to generic entry
Date: Tue, 21 Jul 2026 16:18:56 +0800
Message-ID: <20260721081858.1169276-14-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Queue-Id: D5EA340006
X-Rspamd-Server: rspam01
X-Stat-Signature: zfgpqk4b1q6a7z7cw3uo3jxzmj1heh5b
X-HE-Tag: 1784621959-905529
X-HE-Meta: U2FsdGVkX1+ZXHU+gNMcPvJ9yUzdaUSl1idZdbRyTAjhovkssmjaHfW8uF/I7sngwFRHZ6sBT+iTROaSceszGNYD+BtVyb//xmCaXlOUI2oO8V7nPAD1WHna1KxjRlUOroFhL5nvm0qCukPZnYnlnMKTi+mJzR8bSi2bJWfoARe8a2JNK+Ao7NNQqmxKM39pQ3Yn+mEql7p9WB9GSNS2vY6xyDfgqcu5HpQEtYY4i8rZglT/BB2pA7mq+QDlAx2s4NttfRCfq8u2lhhzvYOPII+bM8u+jPKHVayt4MvE2gb0M7cQYcx6je8qESoAGBkIeyk9UD8aJjIphWTKWMVEuf9x/e9J8qE/p16ozG4WTLbirhqbgBZOpUHT6OJb/QZuZX05KE2qEwCzwNhQuhqaCKgdyB8og5QPnq8Lern2ToNVZDS8oGH9TA7NB2ss1aVMHWh/qPLOU22bEy9FqQ5h3njfDDlE4o6slikhyJDoiEsIjChgmi27zo+AWUxgbn/ZV5SyHFBbQ8b4Ye2qYL+VkCJUuyFtUwiiAXW80AJ37RfeSIjBF+GAWNaRSCADGoBiYQeDh/6+fy4a3KIgKJEqWm4XZQ+pxM4jr/souVXwljx0w3Z5E7GN3LPQy6QCn3QUOhLSKcWe0RiOE/NTAkqGgtahD6IPz0s4XKaVHtElMdISGbJAj7d7i2H+PJUWstn3VgRjjztWIVSELjmg5p26CMJ8ED7KTmuTDWMD1YzoYiW0s7RfeWofZBXlZTQbFRi5l9PDoxPn/wKh3WaziM4YuG/15Z+LOCQRyEF0BbPUk0L6W3yW0HflFu5A9SZTZCIAMOI6DNPDI6Q6YJUJy+gq0h9OH6qS0rBtxgdJ05yfIogPQhrcoIe5QdVRqlikay68gBs/7RXuxpFjg2MVJmO/4RMsq0ONj3+kGoeim4yuwbpVSyGWnJWPrb12sy7mULoGjU138RyFL/y+XFYXXYl
 mUzoxYwC
 YFTfNJNaMT6+D1ZlqBVHyWEL1C2PvF27dM5IeagGjPeuzVE/Se0uDrvXxU64SZSTx7POJ6Zz2vnEGmZfkS4p0FKgQ+7ez39S4jar9w73g+KVirtuFuJKAmcdSsiAal5IelJSspsbi8E5wOCWA4Kil4S8pXR66GCauJjqYO8Vu0Fmgks8D70Q335rGbEiUsMO9Tq/Z/UOB88XjMJwMx9KY7EVLYEqDPXcvW2kv/GGs3c6jl9ivYugJOq+UPk9/lWtHyFwxzorepyEoqPM+3Sq5AnRkSEnbkXVNOb2aYb1IDyxuXYTXiBR6NFXVkr/2vkH3b8cYpFqyFV8HN+MIbP1C6eoptUOtFW3rgElqC7fKaopcyiHkJJOnv2wquf0Otn8X0pehNZ7yLKHhDYQe++zixNmCt/+lsjKB2aJtPkIIWjPIObe3iq7YH5h+yDi4R+YR3wIu2CIxoIPxD24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the generic entry framework for arm64 to handle system call
entry and exit. This follows the migration of x86, RISC-V, and LoongArch,
consolidating architecture-specific syscall tracing and auditing into
the common kernel entry infrastructure, making it easier to enable
advanced features on arm64, such as "Syscall User Dispatch" and "rseq time
slice extension" optimization.

[Background]
Arm64 has already adopted generic IRQ entry. Completing the conversion
to the generic syscall entry framework reduces architectural divergence,
simplifies maintenance, and allows arm64 to automatically benefit from
improvements in the common entry code.

[Changes]

1. Kconfig and Infrastructure:
- Select GENERIC_ENTRY and remove GENERIC_IRQ_ENTRY (now implied).

- Migrate struct thread_info to use the syscall_work field instead
  of TIF flags for syscall-related tasks.

2. Thread Info and Flags:
- Remove definitions for TIF_SYSCALL_TRACE, TIF_SYSCALL_AUDIT,
  TIF_SYSCALL_TRACEPOINT, TIF_SECCOMP, and TIF_SYSCALL_EMU.

- Replace _TIF_SYSCALL_WORK and _TIF_SYSCALL_EXIT_WORK with the
  generic SYSCALL_WORK bitmask.

- Map single-step state to SYSCALL_EXIT_TRAP in debug-monitors.c.

3. Architecture-Specific Hooks (asm/entry-common.h): Implement following
  arch function by porting the existing arm64 logic to the generic
  interface:
  - arch_ptrace_report_syscall_permit_entry()
  - arch_ptrace_report_syscall_exit()

4. Cleanup and Refactoring: Remove redundant arm64-specific syscall
  tracing functions from ptrace.c, including following key functions
  and related audit/step helpers:
  - arm64_syscall_exit_to_user_mode_work()
  - arm64_syscall_trace_enter()
  - arm64_syscall_exit_work().

- Update el0_svc_common() in syscall.c to use the generic
  syscall_work checks and entry/exit call sites.

[Why this matters]
- Unified Interface: Aligns arm64 with the modern kernel entry standard.

- Improved Maintainability: Bug fixes in kernel/entry/common.c now
  apply to arm64 automatically.

- Feature Readiness: Simplifies the implementation of future
  cross-architecture syscall features.

[Compatibility]
This conversion maintains full ABI compatibility with existing
userspace. The ptrace register-saving behavior, seccomp filtering,
and syscall tracing semantics remain identical to the previous
implementation.

Additionally, since arm64 now does not select HAVE_GENERIC_TIF_BITS, there
is no functional change regarding rseq management, as those generic entry
pathways remain a no-op for this architecture."

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Tested-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/Kconfig                    |   2 +-
 arch/arm64/include/asm/entry-common.h |  77 +++++++++++++++
 arch/arm64/include/asm/syscall.h      |  14 ---
 arch/arm64/include/asm/thread_info.h  |  19 +---
 arch/arm64/kernel/debug-monitors.c    |   8 ++
 arch/arm64/kernel/entry-common.c      |   2 +-
 arch/arm64/kernel/ptrace.c            | 136 --------------------------
 arch/arm64/kernel/signal.c            |   2 +-
 arch/arm64/kernel/syscall.c           |   9 +-
 9 files changed, 95 insertions(+), 174 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..aea686dce3d5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -128,9 +128,9 @@ config ARM64
 	select GENERIC_CPU_DEVICES
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
+	select GENERIC_ENTRY
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IOREMAP
-	select GENERIC_IRQ_ENTRY
 	select GENERIC_IRQ_IPI
 	select GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD
 	select GENERIC_IRQ_PROBE
diff --git a/arch/arm64/include/asm/entry-common.h b/arch/arm64/include/asm/entry-common.h
index cab8cd78f693..2b053acbe10f 100644
--- a/arch/arm64/include/asm/entry-common.h
+++ b/arch/arm64/include/asm/entry-common.h
@@ -3,14 +3,21 @@
 #ifndef _ASM_ARM64_ENTRY_COMMON_H
 #define _ASM_ARM64_ENTRY_COMMON_H
 
+#include <linux/ptrace.h>
 #include <linux/thread_info.h>
 
+#include <asm/compat.h>
 #include <asm/cpufeature.h>
 #include <asm/daifflags.h>
 #include <asm/fpsimd.h>
 #include <asm/mte.h>
 #include <asm/stacktrace.h>
 
+enum ptrace_syscall_dir {
+	PTRACE_SYSCALL_ENTER = 0,
+	PTRACE_SYSCALL_EXIT,
+};
+
 #define ARCH_EXIT_TO_USER_MODE_WORK (_TIF_MTE_ASYNC_FAULT | _TIF_FOREIGN_FPSTATE)
 
 static __always_inline void arch_exit_to_user_mode_work(struct pt_regs *regs,
@@ -54,4 +61,74 @@ static inline bool arch_irqentry_exit_need_resched(void)
 
 #define arch_irqentry_exit_need_resched arch_irqentry_exit_need_resched
 
+static __always_inline unsigned long ptrace_save_reg(struct pt_regs *regs,
+						     enum ptrace_syscall_dir dir,
+						     int *regno)
+{
+	unsigned long saved_reg;
+
+	/*
+	 * We have some ABI weirdness here in the way that we handle syscall
+	 * exit stops because we indicate whether or not the stop has been
+	 * signalled from syscall entry or syscall exit by clobbering a general
+	 * purpose register (ip/r12 for AArch32, x7 for AArch64) in the tracee
+	 * and restoring its old value after the stop. This means that:
+	 *
+	 * - Any writes by the tracer to this register during the stop are
+	 *   ignored/discarded.
+	 *
+	 * - The actual value of the register is not available during the stop,
+	 *   so the tracer cannot save it and restore it later.
+	 *
+	 * - Syscall stops behave differently to seccomp and pseudo-step traps
+	 *   (the latter do not nobble any registers).
+	 */
+	*regno = (is_compat_task() ? 12 : 7);
+	saved_reg = regs->regs[*regno];
+	regs->regs[*regno] = dir;
+
+	return saved_reg;
+}
+
+static __always_inline bool arch_ptrace_report_syscall_permit_entry(struct pt_regs *regs)
+{
+	unsigned long saved_reg;
+	bool permit;
+	int regno;
+
+	saved_reg = ptrace_save_reg(regs, PTRACE_SYSCALL_ENTER, &regno);
+	permit = ptrace_report_syscall_permit_entry(regs);
+	if (!permit)
+		forget_syscall(regs);
+	regs->regs[regno] = saved_reg;
+
+	return permit;
+}
+
+#define arch_ptrace_report_syscall_permit_entry arch_ptrace_report_syscall_permit_entry
+
+static __always_inline void arch_ptrace_report_syscall_exit(struct pt_regs *regs,
+							    int step)
+{
+	unsigned long saved_reg;
+	int regno;
+
+	saved_reg = ptrace_save_reg(regs, PTRACE_SYSCALL_EXIT, &regno);
+	if (!step) {
+		ptrace_report_syscall_exit(regs, 0);
+		regs->regs[regno] = saved_reg;
+	} else {
+		regs->regs[regno] = saved_reg;
+
+		/*
+		 * Signal a pseudo-step exception since we are stepping but
+		 * tracer modifications to the registers may have rewound the
+		 * state machine.
+		 */
+		ptrace_report_syscall_exit(regs, 1);
+	}
+}
+
+#define arch_ptrace_report_syscall_exit arch_ptrace_report_syscall_exit
+
 #endif /* _ASM_ARM64_ENTRY_COMMON_H */
diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index f19d4a8824ba..e3e716575846 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -120,18 +120,4 @@ static inline int syscall_get_arch(struct task_struct *task)
 
 	return AUDIT_ARCH_AARCH64;
 }
-
-bool arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
-void arm64_syscall_exit_work(struct pt_regs *regs, unsigned long flags);
-
-static __always_inline void arm64_syscall_exit_to_user_mode_work(struct pt_regs *regs)
-{
-	unsigned long flags = read_thread_flags();
-
-	rseq_syscall(regs);
-
-	if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
-		arm64_syscall_exit_work(regs, flags);
-}
-
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 56a2c9426a32..3f621ba0f961 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -46,6 +46,7 @@ struct thread_info {
 	u64			mpam_partid_pmg;
 #endif
 	u32			cpu;
+	unsigned long		syscall_work;   /* SYSCALL_WORK_ flags */
 };
 
 #define thread_saved_pc(tsk)	\
@@ -68,11 +69,6 @@ void arch_setup_new_exec(void);
 #define TIF_UPROBE		5	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	6	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
-#define TIF_SYSCALL_TRACE	8	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
-#define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
-#define TIF_SECCOMP		11	/* syscall secure computing */
-#define TIF_SYSCALL_EMU		12	/* syscall emulation active */
 #define TIF_PATCH_PENDING	13	/* pending live patching update */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
@@ -94,27 +90,14 @@ void arch_setup_new_exec(void);
 #define _TIF_NEED_RESCHED_LAZY	(1 << TIF_NEED_RESCHED_LAZY)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_FOREIGN_FPSTATE	(1 << TIF_FOREIGN_FPSTATE)
-#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
-#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
-#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
-#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_SVE		(1 << TIF_SVE)
 #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_TSC_SIGSEGV	(1 << TIF_TSC_SIGSEGV)
 
-#define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
-				 _TIF_SYSCALL_EMU)
-
-#define _TIF_SYSCALL_EXIT_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-				 _TIF_SYSCALL_TRACEPOINT)
-
 #ifdef CONFIG_SHADOW_CALL_STACK
 #define INIT_SCS							\
 	.scs_base	= init_shadow_call_stack,			\
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 29307642f4c9..c53683839155 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -385,11 +385,19 @@ void user_enable_single_step(struct task_struct *task)
 
 	if (!test_and_set_ti_thread_flag(ti, TIF_SINGLESTEP))
 		set_regs_spsr_ss(task_pt_regs(task));
+
+	/*
+	 * Ensure that the generic entry code triggers a trap once stepping
+	 * out of a system call prior to executing any user instruction,
+	 * as the generic entry code does not natively check for TIF_SINGLESTEP.
+	 */
+	set_task_syscall_work(task, SYSCALL_EXIT_TRAP);
 }
 NOKPROBE_SYMBOL(user_enable_single_step);
 
 void user_disable_single_step(struct task_struct *task)
 {
 	clear_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP);
+	clear_task_syscall_work(task, SYSCALL_EXIT_TRAP);
 }
 NOKPROBE_SYMBOL(user_disable_single_step);
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index ceb4eb11232a..9eac76804bd9 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/context_tracking.h>
-#include <linux/irq-entry-common.h>
+#include <linux/entry-common.h>
 #include <linux/kasan.h>
 #include <linux/linkage.h>
 #include <linux/livepatch.h>
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index b2b28dcb2826..8bdee1805c93 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -8,7 +8,6 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
-#include <linux/audit.h>
 #include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
@@ -18,7 +17,6 @@
 #include <linux/smp.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
-#include <linux/seccomp.h>
 #include <linux/security.h>
 #include <linux/init.h>
 #include <linux/signal.h>
@@ -37,13 +35,9 @@
 #include <asm/mte.h>
 #include <asm/pointer_auth.h>
 #include <asm/stacktrace.h>
-#include <asm/syscall.h>
 #include <asm/traps.h>
 #include <asm/system_misc.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/syscalls.h>
-
 struct pt_regs_offset {
 	const char *name;
 	int offset;
@@ -2388,136 +2382,6 @@ long arch_ptrace(struct task_struct *child, long request,
 	return ptrace_request(child, request, addr, data);
 }
 
-enum ptrace_syscall_dir {
-	PTRACE_SYSCALL_ENTER = 0,
-	PTRACE_SYSCALL_EXIT,
-};
-
-static __always_inline unsigned long ptrace_save_reg(struct pt_regs *regs,
-						     enum ptrace_syscall_dir dir,
-						     int *regno)
-{
-	unsigned long saved_reg;
-
-	/*
-	 * We have some ABI weirdness here in the way that we handle syscall
-	 * exit stops because we indicate whether or not the stop has been
-	 * signalled from syscall entry or syscall exit by clobbering a general
-	 * purpose register (ip/r12 for AArch32, x7 for AArch64) in the tracee
-	 * and restoring its old value after the stop. This means that:
-	 *
-	 * - Any writes by the tracer to this register during the stop are
-	 *   ignored/discarded.
-	 *
-	 * - The actual value of the register is not available during the stop,
-	 *   so the tracer cannot save it and restore it later.
-	 *
-	 * - Syscall stops behave differently to seccomp and pseudo-step traps
-	 *   (the latter do not nobble any registers).
-	 */
-	*regno = (is_compat_task() ? 12 : 7);
-	saved_reg = regs->regs[*regno];
-	regs->regs[*regno] = dir;
-
-	return saved_reg;
-}
-
-static int report_syscall_entry(struct pt_regs *regs)
-{
-	unsigned long saved_reg;
-	int regno, ret;
-
-	saved_reg = ptrace_save_reg(regs, PTRACE_SYSCALL_ENTER, &regno);
-	ret = !ptrace_report_syscall_permit_entry(regs);
-	if (ret)
-		forget_syscall(regs);
-	regs->regs[regno] = saved_reg;
-
-	return ret;
-}
-
-static void report_syscall_exit(struct pt_regs *regs)
-{
-	unsigned long saved_reg;
-	int regno;
-
-	saved_reg = ptrace_save_reg(regs, PTRACE_SYSCALL_EXIT, &regno);
-	if (!test_thread_flag(TIF_SINGLESTEP)) {
-		ptrace_report_syscall_exit(regs, 0);
-		regs->regs[regno] = saved_reg;
-	} else {
-		regs->regs[regno] = saved_reg;
-
-		/*
-		 * Signal a pseudo-step exception since we are stepping but
-		 * tracer modifications to the registers may have rewound the
-		 * state machine.
-		 */
-		ptrace_report_syscall_exit(regs, 1);
-	}
-}
-
-#ifdef CONFIG_AUDITSYSCALL
-static inline void syscall_enter_audit(struct pt_regs *regs)
-{
-	long syscall = syscall_get_nr(current, regs);
-	unsigned long args[6];
-
-	syscall_get_arguments(current, regs, args);
-	__audit_syscall_entry(syscall, args[0], args[1], args[2], args[3]);
-}
-#endif
-
-bool arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
-{
-	int ret;
-
-	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
-		ret = report_syscall_entry(regs);
-		if (ret || (flags & _TIF_SYSCALL_EMU))
-			return false;
-
-		/* ptrace might have changed thread flags */
-		flags = read_thread_flags();
-	}
-
-	/* Do the secure computing after ptrace; failures should be fast. */
-	if (unlikely(flags & _TIF_SECCOMP)) {
-		if (!__seccomp_permit_syscall())
-			return false;
-	}
-
-	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-		trace_sys_enter(regs, syscall_get_nr(current, regs));
-
-	if (unlikely(audit_context()))
-		syscall_enter_audit(regs);
-
-	return true;
-}
-
-static inline bool report_single_step(unsigned long flags)
-{
-	if (flags & _TIF_SYSCALL_EMU)
-		return false;
-
-	return flags & _TIF_SINGLESTEP;
-}
-
-void arm64_syscall_exit_work(struct pt_regs *regs, unsigned long flags)
-{
-	bool step;
-
-	audit_syscall_exit(regs);
-
-	if (flags & _TIF_SYSCALL_TRACEPOINT)
-		trace_sys_exit(regs, syscall_get_return_value(current, regs));
-
-	step = report_single_step(flags);
-	if (step || flags & _TIF_SYSCALL_TRACE)
-		report_syscall_exit(regs);
-}
-
 /*
  * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487D.a.
  * We permit userspace to set SSBS (AArch64 bit 12, AArch32 bit 23) which is
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 38e6fa204c17..093eebb9d764 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -8,8 +8,8 @@
 
 #include <linux/cache.h>
 #include <linux/compat.h>
+#include <linux/entry-common.h>
 #include <linux/errno.h>
-#include <linux/irq-entry-common.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/freezer.h>
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 72c6e8b7ab21..4a13108defb0 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -2,6 +2,7 @@
 
 #include <linux/compiler.h>
 #include <linux/context_tracking.h>
+#include <linux/entry-common.h>
 #include <linux/errno.h>
 #include <linux/nospec.h>
 #include <linux/ptrace.h>
@@ -58,6 +59,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 			   const syscall_fn_t syscall_table[])
 {
 	unsigned long flags = read_thread_flags();
+	unsigned long work;
 
 	regs->orig_x0 = regs->regs[0];
 	regs->syscallno = scno;
@@ -90,7 +92,8 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		return;
 	}
 
-	if (unlikely(flags & _TIF_SYSCALL_WORK)) {
+	work = READ_ONCE(current_thread_info()->syscall_work);
+	if (unlikely(work & SYSCALL_WORK_ENTER)) {
 		/*
 		 * The de-facto standard way to skip a system call using ptrace
 		 * is to set the system call to -1 (NO_SYSCALL) and set x0 to a
@@ -108,7 +111,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		 */
 		if (scno == NO_SYSCALL)
 			syscall_set_return_value(current, regs, -ENOSYS, 0);
-		if (!arm64_syscall_trace_enter(regs, read_thread_flags()))
+		if (!syscall_trace_enter(regs, work, scno))
 			goto trace_exit;
 
 		/* Reread the syscall number as it might have been modified */
@@ -119,7 +122,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 
 	invoke_syscall(regs, scno, sc_nr, syscall_table);
 trace_exit:
-	arm64_syscall_exit_to_user_mode_work(regs);
+	syscall_exit_to_user_mode_work(regs);
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.34.1


