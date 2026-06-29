Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D736C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1A56B00C6; Mon, 29 Jun 2026 09:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AC66B00CA; Mon, 29 Jun 2026 09:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC3E6B00CC; Mon, 29 Jun 2026 09:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC1E86B00C6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66EB1167DFA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:17 +0000 (UTC)
X-FDA: 84932976114.29.95DABE6
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf12.hostedemail.com (Postfix) with ESMTP id 322EC4000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5r9SSkPh;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738435;
	b=b0sHNrVzN6zSJ7+U53+RBb3coM2P8ifxxSmzyvzuFLnt7DL8WYTqrhGtZ1LMqRR/+jz4yW
	fQpu88ewQrISxk5U9YiowmoGmo8BW6EaoE+L8ca7s3zlvgUpdn2aqj7SRT+EUChaSA9P4m
	AwQi4uI9H69pGxY0sZKzwVVFhNjVen0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WK9b55yDjfgKALMIB3dXIqbFEV/adpD7U43KczXZSbI=;
	b=A2TDFfZRjl6fHzNSdkcI/G0bF5hBH2BoYcYqEDc0s77vO8ijdUI+Fle45PKiwDNrdXxpsu
	P+eFHrANH4oYCPlvW8VTpzFEoIw9rvWFncMd20ZMjECASuLeAuHJc3H/FSxpBvoLgOsYfa
	0vwQcrxC52c5v2SC73EIDJ9E8y4L+dg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5r9SSkPh;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WK9b55yDjfgKALMIB3dXIqbFEV/adpD7U43KczXZSbI=;
	b=5r9SSkPhSJM+TUVUtDxFeqfR0FpN+rGhuFe4Ds3LUJPxltv0/ryIWjDbPj3Y93z7deCMef16s
	mM6/QColletGGHa9mCAFGvC/1CjjGDvUb2UwrkYSHmT0hYQAWhUDzv5kbjECPcIDw66hJQfVEyf
	uR911NIjJ8GyTRXwJEur6gQ=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXr51cpz1K99M;
	Mon, 29 Jun 2026 20:58:04 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id F3C874057C;
	Mon, 29 Jun 2026 21:07:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:07 +0800
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
Subject: [PATCH v16 08/18] arm64: ptrace: Rename syscall_trace_exit() to syscall_exit_work()
Date: Mon, 29 Jun 2026 21:06:06 +0800
Message-ID: <20260629130616.642022-9-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 322EC4000C
X-Stat-Signature: bx7e71hwjyqp55hpnnh9uz3c8tjfmhdm
X-HE-Tag: 1782738435-864499
X-HE-Meta: U2FsdGVkX19Za07ZgpO6gKxWF0ZC5f7aQ9MLmQES+iaaTYlU8Mw0tqidxvGTRncBdBZqiJdy9polGelFXq5MTGQ0CZ7YSQapZD7cxdHO9/r96jaZqkN6oxXLOnLgK46UHjHLPT8u+jvyrCOAlMaToDGy9dgvGZ9VI2AobwbJj2B+0Cb4QraUByR2oz3pXz6nS9WW2Eyasl0TBiG2Y3t9Q6O1Q+r3DzItfjnuyfjnjEcvlwhcW0AUPf57UHxo9mfeogNzUfhLFLA+2+n18bI5Ss8xk4FLogK2Fy9jSKhTPbYksukbHMNMm25PTgkd+5pkCdQs80cPtuQ6bs1cGKlW4U5kc7ghdPbZhoZv3dkr3xc/X39R3NMRogjiJ3xvfJbm9wOmS6OHBsTzDV+YW3NOBTX7ss1n+8RNYiEx25O6yClT4Yfbk3yHsvhQufzl+O2N9gUSmGGeHz2OBtsFnnBU/oz2SH9MpchLC3wP6XdWKfuYuBzyTCpFW3imTRpLNZcBmacTjdIGispIENCCSNQWAUlSXGWNNPU3261Bn1OhQ9pUqW5bzPvfnppYFzNViE55n+dUgSPxk3B+uk3EtqnFTFDy43t+4qwdrm/IGhJMBrNtQ4E7kaHIToVimjz+EvCLjiAcQADOnQ9qquJdJDLBzoJKKYPf58BZAWw3+62BdX3zfEW7zoM+T6GkpFRI0iH/Lky6MnXYwvQTJOlLRl6eb4+pGTSzBb2cqR/9I9Yu/jymqqMUwO/juvINvsY6qNaDvUAGvXpJegdo9/sM/Q98BpVfsonUDBQz2fzWgrutaoDambJ6Gls/OhftnnTVcAh0rxuHsIzgT4RGdtojFig7HR8u49ihTQmCndoAImBrRxrjHp4Kn+JJsQdFxUNt0wC8ZQU+8w/SzK7gOXSLBlmTkvg+Q7iWrA9cFnUCc8EajapTShEh5B4nO0Wtd+1YFivSAKZtyPdYW1WdD5cTDsB
 SZKpNnJp
 wgc2Nx9hW8y9nxjHn9+EbkTHJFdF+TWAYF0fAWPqv6AxMgAP6qL2+G9zwtDChCyjG987XtBh5Ec9G+97g8gnK2OWvHnhXL5qlbkjG+cw4KZBen+6SIJTLQ7D6YlDSW/MYXjXdoa8GfLtuw1Wmf9a9cB24H5q0P4Vnnwp8JFzum+vW/s4L/Tjf8uCSJ9judqlKy/H3bp9DiQ+2Pf7v7gd6u0+ntpUzw736KO2p6vWx/+ktZtE3ASjpQq2+BUTiBxpv9erZLWoizVE4/pZFQdrAgEJdhp7XwW2RcKawFXQhcCWD3CLTWPmMN/qczZA1W89CvGInKslKW6rx+d8IX5vXvrPTnxB+yFrXn7GJtWcpGrRvFW7n/yOgqkAeDaqTq9wmxrAMk1GnWuFH38w34D1IQs14jVrrbJT+/zM6YDVKTlICbb8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for moving arm64 over to the generic entry code, rename
syscall_trace_exit() to syscall_exit_work(). The renamed function checks
and prevents illegal system calls inside user-space rseq critical
sections, while also handling tracing, auditing, and ptrace reporting.

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h | 2 +-
 arch/arm64/kernel/ptrace.c       | 2 +-
 arch/arm64/kernel/syscall.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 30b203ef156b..8205af0be612 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -121,6 +121,6 @@ static inline int syscall_get_arch(struct task_struct *task)
 }
 
 int syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
-void syscall_trace_exit(struct pt_regs *regs, unsigned long flags);
+void syscall_exit_work(struct pt_regs *regs, unsigned long flags);
 
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index bc08c93c69c5..9ebe3389451c 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2453,7 +2453,7 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 	return syscall;
 }
 
-void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
+void syscall_exit_work(struct pt_regs *regs, unsigned long flags)
 {
 	rseq_syscall(regs);
 
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index c8e116397cfd..43ffb74162c5 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -133,7 +133,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 
 trace_exit:
 	flags = read_thread_flags();
-	syscall_trace_exit(regs, flags);
+	syscall_exit_work(regs, flags);
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.34.1


