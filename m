Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B767C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9598E6B0092; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92ED16B0093; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B6F6B0095; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51EBE6B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B454F40420
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:07 +0000 (UTC)
X-FDA: 85012083534.02.9146046
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf27.hostedemail.com (Postfix) with ESMTP id E06914000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=B5ChWWiN;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HSLbto3uyLQMSOtOiFXSF4hVL3Y+JNati3DGw3f2Nl8=;
	b=BGg1bPDe6d6qMSGY/Jyyphy8b/8Nhkdn+Ec8a7+80KbE5csMi1KmeFUVa9uxL5GoKIXjk0
	VTsG2AG7P0mb1GXsWUI3DuIZnWSwOixE7+wn1aCA4pNy9SjyXXTqD9H1UrjxGDMRNh4JEr
	lJbeqQQtySY+xGyxEnUJDByk/6eyTyE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=B5ChWWiN;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621946;
	b=myF6ZPDJUIDT22qhNEjtsf38FG28kaCPmHxc0L9rv+3JSWohdoEU2Xb/uq8lWLwVGZ4ABy
	LIGo3rxLiqxnNmy3+X5NneMJi7we2zGI/JjQDUHpA0SjTPPStE0iH3fhO0b/DEGgWcXmyc
	L6VXFUscHb49a89cShQ4Xcm+Mr7gbQ4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HSLbto3uyLQMSOtOiFXSF4hVL3Y+JNati3DGw3f2Nl8=;
	b=B5ChWWiNH0o3tSTdzs0xy+QmDu5mxyMJzYpsb8P89oo2gDZbvxxQMGU/vEef2fVHTe6LEsJxN
	ILMMJhzjg79sEw0Gr4EH7LYMyfLoGZ7F7B7XaGKhgV2wYkjfXfTV+uNncj2CDFtQmfcjRC7w8LZ
	a4cM+nARIJ5ChyMypW9OdWU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h495n2FNwz1prKd;
	Tue, 21 Jul 2026 16:09:33 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 662E94057F;
	Tue, 21 Jul 2026 16:18:57 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:18:56 +0800
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
Subject: [PATCH v17 00/15] arm64: entry: Convert to Generic Entry
Date: Tue, 21 Jul 2026 16:18:43 +0800
Message-ID: <20260721081858.1169276-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E06914000A
X-Stat-Signature: uqpf7y7s4chp7cmjbndn5sx3jrbnj1n7
X-HE-Tag: 1784621944-946338
X-HE-Meta: U2FsdGVkX19gut2rqxk+q3MkZ5v/H1bsT6fZF1geaEGyXcg83e0tFMxc0kPcYsLGV8qCJGfIYjBSDwi42jHjTe1CX/jwYQdiIzN+kEvKULyV7263QDgsueuKYDXsxgcR1lIs++onvR5HyP4wsG7IPE9SzcymXp8v66ZUxLlrqRbRFdRYnBqMAYfTg5/gduRYYJklmhs7woE14xMbM6k/Xabd+23c91Zc+Hna+boHkpVesFcbQWCdl+eScoKU7u429z8f5PG+IgM/5x/C9OhXP/ppVNezTw0vtMDi5bAFLSkYQFhcrUdS2qVRtsoMF5//3DcdXGz+ZaygiSbVJ7hFfFXxXaooaZCh1UZ9gyw1rlkZtnJ2DgH9+RngLlJMGFgXFD6AXxvUbT1QEEXIk6k+fBUh4XmtYBGVZstNd6YOQxMZfppLkGHU54rKlHNKVPMdClQtu93gxfLUzDE0EvJvK+HihPN0wvrnGn+uLtcWk4ZgHVcTJ+z/1Sb1ZExv4E0DemQg5aN81F+azYAHe8K1+rbRNc2vlZ4smDAQIe50fIAh33XlJpqpQYwW4Iny1iy1o2UYw6diRSuSgHBqy/l9uBG561rNm5+e7WJc0SOMy7ZmHJTY/p90ZMjicw90dPM8Em4SDzSBO0ptI/LPZ6YKWr9/HmNZ7ZSAu4wCyYC1xNaXQrOVDh9COMFwChkEEkBa2UQRPMOdi5qfb8ZpDXwcp4CyaMK+4c89hCpy381lwRh43xNKHA3jFz1uQyarbgrU9CYu0FCtEw3YRyyVYBkAvwF7Z4eEWKxUdRitI9QpQiXWZLd4k0blo56iLC4vSUZiT1sZK21uNrr8CcpEQLF6x3RtBdBX/xA7HbDhc8wMcciCWm/IvMWGSiQNYEzPAiO5KIPA3K+OSK8oDY8vpGHHXH8ak4Ipr7XIPWOX23095ec9m15e7zZcUhGt6n858hiF0zILTUHpSoaK2RO9MY3
 jWWCo6dF
 oeFQQzCkZPwnR7oEShu5abu23gSHuvR5fmlQvpreK5FoNhDfkPs/pjSXk/R/lT0zAFbU6swiI4uoE7f3KTs6W8XXVUy+smP+FrZPpgnlgtBaew8V/1p8MTpyPw31IOXDB944Kxek/U1WwEcUlZKrHjW8kGW2yHfuVMWpVppc8nLLXpIlcyj6YcVuviJtm88K2jehkENYKEuQoRBebFiDcOJDidcr11/oWxWizXvAA8Ivzbrryd3W8Rk4xtViioIa8UawtKPWE51qkASHG3J8bam7X041sq5HU93c2WeZ5bcQQVvWG+wh4nbMmlFQiOnZz8KuJ5GmJOJ2Q0eI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the 17th iteration of the patch series. I would like to express
my sincere gratitude to everyone who has contributed to the reviews
and testing across the previous versions, which helped significantly
refine this work.

Currently, architectures such as x86, Riscv, Loongarch and S390 use
the Generic Entry, which significantly eases maintenance burden
and improves code elegance. Given that arm64 has already successfully
adopted the Generic IRQ Entry in commit b3cf07851b6c ("arm64: entry: Switch
to generic IRQ entry"), it is now the right time to completely convert
arm64 to the Generic Entry infrastructure.

The objective of this series is to bring arm64 in line with other major
architectures, reducing duplicated boilerplate code and simplifying the
sharing of future improvements in entry/exit paths, such as "Syscall User
Dispatch" and "rseq time slice extension" optimizations.

This patch set is rebased on "core/entry". It contains the foundational
updates required for arm64. Following the suggestion from Linus Walleij,
these patches are being submitted separately for inclusion via
the arm64 tree.

Tested successfully on "Kunpeng HIP09" using the following test cases:
 - stress-ng: CPU, Virtual Memory, Syscall, and Interrupt stress tests.
 - hackbench: Evaluated in both thread and pipe modes.
 - kselftests (ptrace): get_syscall_info, set_syscall_info, peeksiginfo.
 - kselftests (breakpoints): breakpoint_test_arm64.
 - kselftests (arm64/abi): syscall-abi and ptrace.
 - kselftests (arm64/fp): fp-ptrace, sve-ptrace, and za-ptrace.
 - kselftests (vDSO): vdso_test_getrandom.
 - ptrace stress test: tracing stress-ng system calls under load.
 - Pseudo-NMI load test using perf.

Changes in v17:
- Rebased on core/entry.
- Make return type of arm64_syscall_trace_enter() bool.
- Use vdso label for arch_syscall_is_vdso_sigreturn() to make it more
  clear as Thomas suggested.
- Update the rework of audit_syscall_entry().
- Prefix these functions with arm64_ to clearly distinguish arch-specific
  logic when switching to the generic entry framework.
- Merge some related patches to make it clearer, and adjust the patch
  sequence so that bugfix patches come first.
- Update the commit message.
- Link to v16: https://lore.kernel.org/all/20260629130616.642022-1-ruanjinjie@huawei.com/

Changes in v16:
- Rebased on v7.2-rc1.
- Convert __secure_computing() to return boolean as Thomas suggested.
- Introduce a weak vesion for arch_syscall_is_vdso_sigreturn()
  to simplify the code.
- Split out the implementation of arch_syscall_is_vdso_sigreturn()
  into a separate patch to facilitate reviewing.
- Break down the syscall_exit_to_user_mode_work() refactoring into
  5 smaller, bite-sized patches for easier review and justification.
- Update the comment and commit message as Ada suggeted.
- Clarify patch titles and align title prefixes for consistency.
- Collect Reviewed-by and Tesed-by.
- Link to v15: https://lore.kernel.org/all/20260511092103.1974980-1-ruanjinjie@huawei.com/

Changes in v15:
- Rebased on v7.1-rc1 and Mark's fix patch in [1].
- Solve issues Sashiko AI pointed out, "Fix potential syscall truncation
  in syscall_trace_enter()".
- Make syscall_exit_to_user_mode_work() __always_inline to keep
  the fast-path performance as Sashiko pointed out.

Changes in v14:
- Initialize ret = 0 in syscall_trace_enter().
- Split into two patch sets as Linus Walleij suggested, so this patch set
  can be applied separately to the arm64 tree.
- Rebased on arm64 for-next/core branch.
- Collect Reviewed-by and Acked-by.
- Link to v13 resend: https://lore.kernel.org/all/20260317082020.737779-15-ruanjinjie@huawei.com/

Changes in v13 resend:
- Fix exit_to_user_mode_prepare_legacy() issues.
- Also move TIF_SINGLESTEP to generic TIF infrastructure for loongarch.
- Use generic TIF bits for arm64 and moving TIF_SINGLESTEP to
  generic TIF for related architectures separately.
- Refactor syscall_trace_enter/exit() to accept flags and Use
  syscall_get_nr() helper separately.
- Tested with slice_test for rseq optimizations.
- Add acked-by.
- Link to v13: https://lore.kernel.org/all/20260313094738.3985794-1-ruanjinjie@huawei.com/

Changes in v13:
- Rebased on v7.0-rc3, so drop the firt applied arm64 patch.
- Use generic TIF bits to enables RSEQ optimization.
- Update most of the commit message to make it more clear.
- Link to v12: https://lore.kernel.org/all/20260203133728.848283-1-ruanjinjie@huawei.com/

Changes in v12:
- Rebased on "sched/core", so remove the four generic entry patches.
- Move "Expand secure_computing() in place" and
  "Use syscall_get_arguments() helper" patch forward, which will group all
  non-functional cleanups at the front.
- Adjust the explanation for moving rseq_syscall() before
  audit_syscall_exit().
- Link to v11: https://lore.kernel.org/all/20260128031934.3906955-1-ruanjinjie@huawei.com/

Changes in v11:
- Remove unused syscall in syscall_trace_enter().
- Update and provide a detailed explanation of the differences after
  moving rseq_syscall() before audit_syscall_exit().
- Rebased on arm64 (for-next/entry), and remove the first applied 3 patchs.
- syscall_exit_to_user_mode_work() for arch reuse instead of adding
  new syscall_exit_to_user_mode_work_prepare() helper.
- Link to v10: https://lore.kernel.org/all/20251222114737.1334364-1-ruanjinjie@huawei.com/

Changes in v10:
- Rebased on v6.19-rc1, rename syscall_exit_to_user_mode_prepare() to
  syscall_exit_to_user_mode_work_prepare() to avoid conflict.
- Also inline syscall_trace_enter().
- Support aarch64 for sud_benchmark.
- Update and correct the commit message.
- Add Reviewed-by.
- Link to v9: https://lore.kernel.org/all/20251204082123.2792067-1-ruanjinjie@huawei.com/

Changes in v9:
- Move "Return early for ptrace_report_syscall_entry() error" patch ahead
  to make it not introduce a regression.
- Not check _TIF_SECCOMP/SYSCALL_EMU for syscall_exit_work() in
  a separate patch.
- Do not report_syscall_exit() for PTRACE_SYSEMU_SINGLESTEP in a separate
  patch.
- Add two performance patch to improve the arm64 performance.
- Add Reviewed-by.
- Link to v8: https://lore.kernel.org/all/20251126071446.3234218-1-ruanjinjie@huawei.com/

Changes in v8:
- Rename "report_syscall_enter()" to "report_syscall_entry()".
- Add ptrace_save_reg() to avoid duplication.
- Remove unused _TIF_WORK_MASK in a standalone patch.
- Align syscall_trace_enter() return value with the generic version.
- Use "scno" instead of regs->syscallno in el0_svc_common().
- Move rseq_syscall() ahead in a standalone patch to clarify it clearly.
- Rename "syscall_trace_exit()" to "syscall_exit_work()".
- Keep the goto in el0_svc_common().
- No argument was passed to __secure_computing() and check -1 not -1L.
- Remove "Add has_syscall_work() helper" patch.
- Move "Add syscall_exit_to_user_mode_prepare() helper" patch later.
- Add miss header for asm/entry-common.h.
- Update the implementation of arch_syscall_is_vdso_sigreturn().
- Add "ARCH_SYSCALL_WORK_EXIT" to be defined as "SECCOMP | SYSCALL_EMU"
  to keep the behaviour unchanged.
- Add more testcases test.
- Add Reviewed-by.
- Update the commit message.
- Link to v7: https://lore.kernel.org/all/20251117133048.53182-1-ruanjinjie@huawei.com/

Jinjie Ruan (15):
  arm64: ptrace: Skip syscall exit reporting for
    PTRACE_SYSEMU_SINGLESTEP
  arm64: ptrace: Rework audit_syscall_entry()
  arm64: ptrace: Open-code seccomp check in syscall_trace_enter()
  arm64: ptrace: Rename and clean up syscall_trace_enter()
  arm64: ptrace: Protect rseq_syscall() from tracer PC modifications
  arm64: syscall: Rework the syscall exit path in el0_svc_common()
  arm64: ptrace: Pass thread flags to trace enter/exit
  arm64: ptrace: Extract arm64_syscall_exit_to_user_mode_work() helper
  arm64: ptrace: Align syscall exit work semantics with generic entry
  arm64: syscall: Use exit-specific flags check in el0_svc_common()
  arm64: syscall: Simplify el0_svc_common() syscall exit path
  arm64: ptrace: Make return type of arm64_syscall_trace_enter() bool
  arm64: entry: Convert to generic entry
  arm64: Inline el0_svc_common()
  arm64: vdso: Expose sigreturn address on vdso to the kernel

 arch/arm64/Kconfig                    |   3 +-
 arch/arm64/include/asm/elf.h          |   1 +
 arch/arm64/include/asm/entry-common.h |  77 +++++++++++++++++
 arch/arm64/include/asm/syscall.h      |   5 +-
 arch/arm64/include/asm/thread_info.h  |  16 +---
 arch/arm64/kernel/debug-monitors.c    |   8 ++
 arch/arm64/kernel/entry-common.c      |   2 +-
 arch/arm64/kernel/ptrace.c            | 115 --------------------------
 arch/arm64/kernel/signal.c            |   2 +-
 arch/arm64/kernel/syscall.c           |  34 +++-----
 arch/arm64/kernel/vdso.c              |  16 ++++
 arch/arm64/kernel/vdso/sigreturn.S    |   1 +
 arch/arm64/kernel/vdso/vdso.lds.S     |   1 +
 13 files changed, 122 insertions(+), 159 deletions(-)

-- 
2.34.1


