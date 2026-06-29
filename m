Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F0FC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130D86B00B9; Mon, 29 Jun 2026 09:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1586B00BB; Mon, 29 Jun 2026 09:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D816B00BC; Mon, 29 Jun 2026 09:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4A166B00B9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC63C1C6D2A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:01 +0000 (UTC)
X-FDA: 84932975442.03.3E0D438
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41B0C140006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:06:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hZ9BR08f;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738420;
	b=VhVCdI2LBmcZubfFNpxoJ4JmdgXJUUd6wLUfbNZYQSY4IIMXU1xHUrdqxtdz658iObrCw0
	m0CNawYTY+Q+dveJpgIMKR5qh8CK/To+NhczQSFtSnpDFgQbzrByKd1Tjb7hwOONOyJuWD
	AdXvlbQW9WOVOKOeUbu6vJABycHCEmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr2HPmO7D5/aDiNbP0zE0sHPfXASvKefJL6yzC7Hl3c=;
	b=D5qGRGYgdEhnlDG97Nffpig9xzANmfJ7xN36h+Rv8Lf3jqiVYLioKiFK6JxTl+e+8Fp46S
	NERGn+T0xzbblGV5Yc0BPMQSmZ44ZJSPX9S0h7kcuolqxZeTdmZrDjCmuxeFtsC7DHYMmG
	uAr8jxsqkhjaaMeNzEF78lGmFB3d8ko=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hZ9BR08f;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wr2HPmO7D5/aDiNbP0zE0sHPfXASvKefJL6yzC7Hl3c=;
	b=hZ9BR08feDZ/G0mAHEtLpZCBmdn7O+fZzgAXw/cZbsF8BmlzWIpfpkw9L9tibOBimcEkfFCQf
	1wMZpzGWKrogPwhqjZUpc8t+rx8Ll0UutEmNBoioOiLfiAMT4KCn+bLVhYsCPV1f7qy0aWE3fwa
	xBagtZvIbk6CoZGSnJV5OTU=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXV5XYrzmV8L;
	Mon, 29 Jun 2026 20:57:46 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 7455240586;
	Mon, 29 Jun 2026 21:06:55 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:06:51 +0800
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
Subject: [PATCH v16 04/18] arm64: ptrace: Use syscall_get_nr() helper for syscall_trace_enter()
Date: Mon, 29 Jun 2026 21:06:02 +0800
Message-ID: <20260629130616.642022-5-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: bc3wo3mhxcr7sddbon1phkz5x81rrj51
X-Rspamd-Queue-Id: 41B0C140006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782738419-279334
X-HE-Meta: U2FsdGVkX1+AOVhSOTpvhb6FIBbTEzvrmYzi59xjnfj00N5Jv8m/z6sDEYRbnkBLxObWp+cspNeb1ROlGA92FciyYzYkC8+4gKIR9rt8RFyOo/n/TBQ2vBneLMNv5Qd7OY8zSCoDGgJD6ZULP8aGL5lASn/aaVHFjLa4bRnzDZ9is66lBzy9niXAvMKlJ0YYjdxV8k9JAt+kZGLSyJ7KYQWNzOxVbrqvHULkijbrls7LiKrEH/WWFSgFrfe6z3Eg8sU2cz0hL84YQXAhT62bY+mSkyu7tkzDndgrJpNmVTyK18v55wTNmyrkvP6gQ+Xuf7RcH/jFxYiH1Hy3xvG2gK5AcAA0RqalRKU9mnabxaRhrn7nGvUssOGmcx5FbXDUxFAUAMeZ09YwkowIAzuWER8Y0dsAzxYct1E0thj2xi+fqv4dInVlvYq6DUmO0pomdD5vZkMX+q3XPEvtMyAxVH20EJzhaAYVFLySKAzBcQtON8nYNVmzrD9l7DTXZwH13UZxlpgXE/wn/Z3IUhIGxrRYEwoP5sBvQfLAsea4OXM5AZZfYjdf8YxST8TepAEyAvWJwOul+GqfE4F02xz5Nku/PoJ0BCxYQxziI8bC8Mz8/l7acxYfNGAdkZ+AelsQb9SYomc63WN67xC2DIvEPtYYUYWxkkH4TuwWFswRyod8ahMTGuHcKDsVzGbq7a+M7fOsIh5CANCVuwLMCsHSz0ek9Cm7A7K1Tr2eZCxodjU63hhbPzeH3lOZfdw8epWi64Qn1vDLCScQyjyJ6GOEt6ZycRAv48X4kVa41bf9MCsqeMRCA+XFz/jy9v1pIFxSvUbnCslwcN9Afsiq9CAWxuBJrl1ri6ymT8YskbkPuyyZtra2P1biETI/k4l7ooBlwV8OXDhjmkXWuQjP0DUHgzs20SxxsCFgV/vQo9mEtywPHdfJTaQcYohP9WlUPqszcoaiugVSZYSD63ruTHn
 IRhoGUmz
 3PaM1Mc9ZVqo37rrm2WwoW+LL9BCGn9DY76nAzoujoAr4wYcAiw+OQcQIEq5l5Zie3ldcI+5Yl+XQBb+SSEDcZ+pb69tMCa2IYDvmRk11HfizFREWJuWasW8zOD3L0D40cDT5ei9xx7qk6tj+OgoVRjsW30NkHalYZ1gqYHrbPjI0Q6ZFb5dxDpFSbZ9YWgU4Mu25xvsvOI9Yesug7oOpQ+LAiPqIsDawNE4R1b6Gc+V/84ME9me/LTSA3guXaXZcA3lHG8JhDObqM8ZfCZMUNJnfiHjjtqBjBUmoVTwwTiJUZWqva2DlGGBadsQyi7Du8Jgsx0Fc6OWuPsiNZy7+vh9OsF0hQt/DcGxjGH5IspeAS99F84GDJDom/bL2zPMMrnH/6nU2m9ecSaMX95FXcbEJIws2eyhEHaWG64yAkMuuDWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use syscall_get_nr() to get syscall number for syscall_trace_enter().
This aligns arm64's internal tracing logic with the generic
entry framework.

[Changes]
1. Use syscall_get_nr() helper:
   - Replace direct regs->syscallno access with
     syscall_get_nr(current, regs).
   - This helper is functionally equivalent to direct access on arm64.

2. Re-read syscall number after tracepoint:
  - Re-fetch the syscall number after trace_sys_enter() as it may have
    been modified by BPF or ftrace probes, matching generic entry behavior.

[Why this matters]
- Aligns arm64 with the generic entry interface.
- Makes future migration to generic entry framework smoother.
- Properly handles syscall number modifications by tracers.
- Uses standard architecture-independent helpers.

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
 arch/arm64/kernel/ptrace.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index ac15b81a71b5..863083de37c3 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2410,6 +2410,7 @@ static void report_syscall_exit(struct pt_regs *regs)
 
 int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 {
+	long syscall;
 	int ret;
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
@@ -2422,13 +2423,23 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 	if (!secure_computing())
 		return NO_SYSCALL;
 
-	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-		trace_sys_enter(regs, regs->syscallno);
+	/* Either of the above might have changed the syscall number */
+	syscall = syscall_get_nr(current, regs);
 
-	audit_syscall_entry(regs->syscallno, regs->orig_x0, regs->regs[1],
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT)) {
+		trace_sys_enter(regs, syscall);
+
+		/*
+		 * Probes or BPF hooks in the tracepoint may have changed the
+		 * system call number as well.
+		 */
+		 syscall = syscall_get_nr(current, regs);
+	}
+
+	audit_syscall_entry(syscall, regs->orig_x0, regs->regs[1],
 			    regs->regs[2], regs->regs[3]);
 
-	return regs->syscallno;
+	return syscall;
 }
 
 void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
-- 
2.34.1


