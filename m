Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF11AC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77626B00C1; Mon, 29 Jun 2026 09:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04126B00C3; Mon, 29 Jun 2026 09:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07466B00C5; Mon, 29 Jun 2026 09:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93CFB6B00C1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C2C9120673
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:13 +0000 (UTC)
X-FDA: 84932975946.18.44F6A1F
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf05.hostedemail.com (Postfix) with ESMTP id ACC9B10001B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ePDiSt5t;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738431;
	b=vJeBSiadZaFQxERH9N+objkWOmSvg9EICZzQPROeMoOZCpNtLq8wP1NN/V8DdkO3sidIFx
	BVTIKAJFTPCaaGU5T+vjWfTCvlAktk8hNCZPHrqW5PqwNA0mVTaSA7Ej6e4EfhjGJit5hU
	w4rhTFX/a0CjiJmYjRc23d5VCM/46dg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fA5Wgt44waousLvxM/KE/Y58BhIiuqbqwA7Wu0syjYw=;
	b=EslWyATlzS1F+miFy+o89vrDjEVkLN6Kg8QLtjAFhm83t8d7JwPaMh3uxg7j6gqOohijLU
	qiJZYZKex6B2084YjhWbJ8UGjnDudK1pSvoV4ag+dA5N7MT68x2fwupZBa5HV//9JYrfqW
	luK1hlTqzwUWa04k1v3m65W7RLn7Z1s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ePDiSt5t;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fA5Wgt44waousLvxM/KE/Y58BhIiuqbqwA7Wu0syjYw=;
	b=ePDiSt5tkHTSZWSUO1NBQeFQ3UWzgqWNmBaknlcBZBlBeJ3c8a/3n5gleY4HdYiY+vm8NlFUw
	wNVdN8N4kdf/m5kCfO/XylnIsoffFIF9XonrCZI/iAnE8MLGcZyIJhoPkDCf76SNds383A5YKf+
	I08o1kntyaEDe/Az0KLyxng=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXm449yz1K96y;
	Mon, 29 Jun 2026 20:58:00 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D55164057C;
	Mon, 29 Jun 2026 21:07:07 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:03 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <mark.rutland@arm.com>,
	<ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>, <linusw@kernel.org>,
	<yeoreum.yun@arm.com>, <song@kernel.org>, <james.morse@arm.com>,
	<anshuman.khandual@arm.com>, <broonie@kernel.org>, <liqiang01@kylinos.cn>,
	<pengcan@kylinos.cn>, <ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>,
	<sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>, <austin.kim@lge.com>,
	<jchrist@linux.ibm.com>, <arnd@arndb.de>, <thomas.weissschuh@linutronix.de>,
	<sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>, <jgross@suse.com>,
	<kas@kernel.org>, <x86@kernel.org>, <linux-alpha@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-csky@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-m68k@lists.linux-m68k.org>,
	<linux-mips@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linux-um@lists.infradead.org>
Subject: [PATCH v16 07/18] arm64: ptrace: Protect rseq_syscall() from tracer PC modifications
Date: Mon, 29 Jun 2026 21:06:05 +0800
Message-ID: <20260629130616.642022-8-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACC9B10001B
X-Rspam-User: 
X-Stat-Signature: gu8ouzta3ybmset4ncoz6uwmdy53sq5z
X-HE-Tag: 1782738430-275121
X-HE-Meta: U2FsdGVkX198PM6EBkAqihOsKYpiv4Dus0Ikv2/CkoYWprR9SedI1+W9YW5NjOTb8HbHBq0m5oGuP6IRlnk5P7tU/jtckGZYh27ATvbkuRpPmzVl2HSsQyVdNeiCvuASSVzuUez7PbjlbY1xg9DWd9wf0L+yY+x+z8RKFHSJNBrKFiAg37WXqifwiZj2ouoFgVX/TBYPJ4bEUgECgYHr0j9aDktvMNjIa9u2nBGbXI1CYxqcXWyVjYGMB6RB8QTqHMcdTb2PKWZj9isLLtjHw6l1qeV5EIkbOTTuwiT0xi4ZF5s06Y7LUrYiexF3mbKglCdyThfyOjFpw+4d1b7TF64k4EZ6EKBXAVTmdGXMFDYKgV1ZV+if8huqwTcKf6lXI/x4HeBPxQp+FoSDTSD3WMaK5jbgQp6Uh8zqxOc2YN4E8mbotM44OJdzbFdzeuMm3s+arq2grqooQVAeqw0ToQ9VvenD1u5yBxqUXgh+6yBkYTuIBlThc4VPQL+ZOb4ixkP8dPwWH5P02zC3+ChnxGrQIh4euAC4x794wCepqMonCwJgOdq4N1no8tli2DJJ/MkVi161oh5Mms8mGQlsDox0AXkk55YP1bqVeSTOLd4r/zAy2Fy6bQfIprc+34M2f4c6TYmGBudyDL6b+hSTHce0NX7hSLOGYBw+pMZZzJSZW+UWwMyjxrU0C3QSqzMEdAVa6YEHZ3cZf0OgNuOCxP6Zq/nK88S1uvuqHfvXcRC5WpX/82mWx1jiTw6YYSSYj+XGwA4OddxoNiyG8mrU5k8rhAD5JDT6Fb5syM0Ak99JeZn4w6Mtb5Rn18VvFFo5VKCt8GOzDMEHDcskvRMfISGNraGsOwiDSh06J3B3B2UkcJAG0yd3ZpyRqXRxnCO0Y4v8xdkcUWz3YCyR5d1/LN3ryKYI1W/4oH1cSi1pkhp5m2c9hwG86KIchPPEmUCMqX6Rhv2SqSIzRCShkE0
 kRGT2AUH
 R4xfCWWHKeFAwBoflmPrpqF4L5Iw9En/r94DDwYvn164VaEIGDRylG7UDwqnUCB10ygG0fRE3rS3vUVVQBglC66KNDpTa6S6lUilMANKNkTNtS60gd7dibmgIPs03VqM/8mW0vGQwV1/9boEoWk1+PBREb+frXB3KnB2QcTVu5XYInPA3jSOLv3RQKbN81TTNKmBEdOGHCPe8PFvnKCROLA4juPdiDLQqu0O3KhhwdtEaaFtiszpFRc750IQw036HH/xplxz26cb976j7i7N06IyFve/EyxQCU7Pw0hMSF3LctgO7FG8F7qn15xbeKMOJWUiS1eE/6Gb5Bd2OloLoIM/jFTR86emtL3eSN4l7Ey2IP8H8nbNw2XdAxRF6kWkwIT3IXVA2/hAsdb8KnIOAmqx9t4biyylajfZorhsXF1waKes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the rseq_syscall() check earlier in the syscall exit path to ensure
it operates on the original instruction pointer (regs->pc) before any
potential modification by a tracer.

[Background]
When CONFIG_DEBUG_RSEQ is enabled, rseq_syscall() verifies that a system
call was not executed within an rseq critical section by examining
regs->pc. If a violation is detected, it triggers a SIGSEGV.

[Problem]
Currently, arm64 invokes rseq_syscall() after report_syscall_exit().
However, during report_syscall_exit(), a ptrace tracer can modify the
task's instruction pointer via PTRACE_SETREGSET (with NT_PRSTATUS). This
leads to an inconsistency where rseq may analyze a post-trace PC instead
of the actual PC at the time of syscall exit.

[Why this matters]
The rseq check is intended to validate the execution context of the
syscall itself. Analyzing a tracer-modified PC can lead to incorrect
detection or missed violations. Moving the check earlier ensures rseq
sees the authentic state of the task.

[Alignment]
This change aligns arm64 with:
- Generic entry, which calls rseq_syscall() first.
- arm32 implementation, which also performs the check before audit.

[Impact]
There is no functional change to signal delivery; SIGSEGV will still be
processed in arm64_exit_to_user_mode() at the end of the exit path.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index ae71cadbd4df..bc08c93c69c5 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2455,6 +2455,8 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 
 void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
 {
+	rseq_syscall(regs);
+
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
@@ -2462,8 +2464,6 @@ void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
 
 	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
 		report_syscall_exit(regs);
-
-	rseq_syscall(regs);
 }
 
 /*
-- 
2.34.1


