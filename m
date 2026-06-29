Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A38C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBE26B00BB; Mon, 29 Jun 2026 09:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2D26B00BD; Mon, 29 Jun 2026 09:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4637B6B00C0; Mon, 29 Jun 2026 09:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 012656B00BB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB613405FC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:06:59 +0000 (UTC)
X-FDA: 84932975358.06.342B6D0
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8892BC0015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:06:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="obS3f4t/";
	spf=pass (imf22.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738418;
	b=PLU5LYPrAaTeuaKr6kpi8jxQhmmSC6JqqmwIyNmdBUP6AhZL62niAhpRfoU0cGsypQ8oZV
	ihcVfy8U3R8ugzjyGyNe7jWNH1iL8NT1Aq3K0H2PaXObcjUOwZaCcEEWXvlmpkc7AdmZT/
	AuiANS3syXoGoryArUBlwYTS35EI8Lw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tgd8psQEJ0paMoFyhOqZDvuVvnTBva24LYJw5z0Xdw=;
	b=u9xXfzwya0WwelXlIA8j/XPe4Iv/V4XJvePpVHEChLHAe9YkAu4QoNwGiCFOPfp4J0jwCd
	I/OSGmpF2XK/4of2+kWE4QACARkRlN9XopCabjrtaIGlzB8010MEcuwBP8XQL+XrM4DUX1
	4SVI+lKoIBjBIlDxBo6Qx0hsV7UpgJc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="obS3f4t/";
	spf=pass (imf22.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2tgd8psQEJ0paMoFyhOqZDvuVvnTBva24LYJw5z0Xdw=;
	b=obS3f4t/Ekl9z/a/IDOrh1hP+eobkVYySkiX1b4nRKIGKUjwYNdeXqhPgqRDKjsdtlCpqmeah
	kFZXl4F2UaNIWX2ZKGvz+WWmGTLHxKiT4eIpFSMjifYhBYWT2dPpgX0Q9k4qXSG3boHoHWrzaD8
	5I3q5Yw/kqi1eZkFX8mJEv4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXq1Rgkz1T4gT;
	Mon, 29 Jun 2026 20:58:03 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 532E62025F;
	Mon, 29 Jun 2026 21:06:51 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:06:47 +0800
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
Subject: [PATCH v16 03/18] arm64: ptrace: Pass thread flags to syscall_trace_enter/exit()
Date: Mon, 29 Jun 2026 21:06:01 +0800
Message-ID: <20260629130616.642022-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Stat-Signature: gsapfoy39tyjospn1xbxj8eawfnyisyj
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8892BC0015
X-HE-Tag: 1782738417-178712
X-HE-Meta: U2FsdGVkX19hlhZQPVjvjM/w1Y/r9zriYRiEI4udrk5QPm7nG7TMdMYvq+hZA8VkVyv8BvdLDYmpNbnKF2Oyac5Pw+VlgM4lPjvxrRzewwS2fISZSsmNBFEZvucpCgtfIuAjjS0pFr8FaJjQZrSw2+F1a58NE/nK2XaUz8eEekqW4NLsEj3mwfQ/+Byjg1h2Vn3aTGx9MWKFTj7i4ScSI6S6+I5wAsoukduRu40lKzpcUis0FiEE7DxADMxwCkoBjjMb/E237OBAwbpSEbXuYc7V+27A4BgW91j/oq3rrC2R4RxSAEpS13zLGKYWFx/iu3MzLHW81Ok80P05i4XV7mb3fPJfT+d/db+b6S2dXm9EXQhNbN6Mk5965oTZ5+sBuS4/QO9mMTeRscRaaIcTWOvBP2TnZhgsOyFiaVAdioFrPAzqZr9Wl/7AXBcI+xR8bOS0mLbtgz0ja6frKPHVrDDEZ3nIooa8hOE70/LcDwYd2iY/dsB6eijubpSH6GT7vfL7OPZs6m8OVQmndV+MWqCe+6QRB+MUp/kiZbtvX4Q5dNGwhHxpfn1y0ubshpJ4ZHfm4dZzmNYzgxAjW1+9a2rj+2Vfd/zaxDbjvB4dfbFXQyd42P4jAUZIKuGrUYeQkNA1fXWJkUM1UkzYRlMfiaGa651MVtArtqm7xoQAs+9O2VcQneVJc4AmrNIGpdDtqkFGbCTnL8FTic3mJbpUL0An3qMuBwTvQwcbxW4nda/loe+5rfmqY8gDlBP0IIdSQgH+dX6VbwHB5fYGjWRG0cpFZN/alEJica4Dhvdc8OIhQB2sKQn9xzOfE4knffgX67ENFfFrzFNGkWZtG5Kb+kUsZ0QTDr2l+sdFsC99PX9TNNVPqqNbfN4Vu4tWfjL085/nlhsmwRAZSWCFyUL9MQ8uc0jQsPDgnI8bcqcjXvUARUNzI6j28TYNiXub4Jce68XDwwvcOvNiiZkf/2Z
 SKnF+RXP
 uXeqcb1y1oAC9jb6ARHO7hUJNCp1svI74STygvHe8ppw9O2C8aMkXX0SuYtSF+s4v68tZSXF+X12aaep2OfcFpEj/ea6FcB6tta77GT7wtbQvu8yLBmhOFjHXmTOmPAgXavV51BpM0RvYQUeKzsmEY3TanjcUXnehzwmxhXPBgd10OX/vHTkKfNTioGZb1wxyNL/ZdG952wCZtl/vyj2TNfDKFW6z2uQ+/QkXmSd2ovzVT1jbpPjeOlCjApZ5eaNe4BuhqKrF30UTqSDAO60V/d3Lj+z2EF2CqGrTjIIJDe4xIivHdMY1k4jwKArBiW7ZYGs5wXRsxUgYOjHPa1qZfk+5DGhUXWl40SSL60ucKCv5O/7UleBTenOPzOt7Ht6rxuTH11vCELC6K6adzOC28P3po3lyvga8zZVQJuAZGsTpjGORd0t/lBS02DDh+JSYM50CC5pl/NHCcX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor syscall_trace_enter() and syscall_trace_exit() to move thread
flag reading to the caller. This aligns arm64's syscall trace enter/exit
function signature with generic entry framework.

[Changes]
1. Function signature changes:
   - syscall_trace_enter(regs) → syscall_trace_enter(regs, flags)
   - syscall_trace_exit(regs) → syscall_trace_exit(regs, flags)

2. Move flags reading to caller:
   - Previously: read_thread_flags() called inside each function.
   - Now: caller (like el0_svc_common) passes flags as parameter.

3. Update syscall.c:
   - el0_svc_common() now passes flags to tracing functions and
     re-fetches flags before entry/exit to handle potential TIF
     updates.

[Why this matters]
- Aligns arm64 with the generic entry interface.
- Makes future migration to generic entry framework smoother.

No functional changes intended.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h | 4 ++--
 arch/arm64/kernel/ptrace.c       | 7 ++-----
 arch/arm64/kernel/syscall.c      | 5 +++--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 5e4c7fc44f73..30b203ef156b 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -120,7 +120,7 @@ static inline int syscall_get_arch(struct task_struct *task)
 	return AUDIT_ARCH_AARCH64;
 }
 
-int syscall_trace_enter(struct pt_regs *regs);
-void syscall_trace_exit(struct pt_regs *regs);
+int syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
+void syscall_trace_exit(struct pt_regs *regs, unsigned long flags);
 
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 2ca6fab39a37..ac15b81a71b5 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2408,9 +2408,8 @@ static void report_syscall_exit(struct pt_regs *regs)
 	}
 }
 
-int syscall_trace_enter(struct pt_regs *regs)
+int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 {
-	unsigned long flags = read_thread_flags();
 	int ret;
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
@@ -2432,10 +2431,8 @@ int syscall_trace_enter(struct pt_regs *regs)
 	return regs->syscallno;
 }
 
-void syscall_trace_exit(struct pt_regs *regs)
+void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
 {
-	unsigned long flags = read_thread_flags();
-
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 358ddfbf1401..c8e116397cfd 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -113,7 +113,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		 */
 		if (scno == NO_SYSCALL)
 			syscall_set_return_value(current, regs, -ENOSYS, 0);
-		scno = syscall_trace_enter(regs);
+		scno = syscall_trace_enter(regs, read_thread_flags());
 		if (scno == NO_SYSCALL)
 			goto trace_exit;
 	}
@@ -132,7 +132,8 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	}
 
 trace_exit:
-	syscall_trace_exit(regs);
+	flags = read_thread_flags();
+	syscall_trace_exit(regs, flags);
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.34.1


