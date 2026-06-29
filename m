Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9FBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DEEC6B00CE; Mon, 29 Jun 2026 09:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A4C6B00D0; Mon, 29 Jun 2026 09:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2D16B00D2; Mon, 29 Jun 2026 09:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D420A6B00CE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B04D1680C3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:27 +0000 (UTC)
X-FDA: 84932976534.17.9521890
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf08.hostedemail.com (Postfix) with ESMTP id F394E160015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uYgu3UfW;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738445;
	b=8Qa+44KS79IyaliSSV5W/fNq2LwLqmRod6wnCL9hT+/WmhGrNCEujvsfXO6tmkUI/S+nkz
	tMWx/SXQ07J/BAK0sdSIqHhJZ14cW843yAkXdRKlIxIFrIWKDAR8G+QUVp7HKtV+ukZDh5
	1lU3dKFwZlhHDNQGGdfEHDdpD3N0BD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2rxNMcGBVERUB0xF8QBo+X+2UWtMpQIiDO4vuKAX14=;
	b=4aRB7XiZSggpD0PkP1X5WWNO7pvIv5HCc6KeI37QvBrsaQ+cI5qjBGxOzTmzT/8WX3JT6S
	Mvg8F7Uo8z3pSubTaQw692lAoRak7PHXh4xq0pbzH/c27d1350Oztf9RpU7WBKwJRlBgSp
	1txaHzaLb+SQH14jlKwI+DJWpdgU3p4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uYgu3UfW;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=y2rxNMcGBVERUB0xF8QBo+X+2UWtMpQIiDO4vuKAX14=;
	b=uYgu3UfWdnRZOQyVdMpV/f/i7+qFPm534ba8WeKtTwDLdknxr+v38yCdBqgJDbr5T97LlAyiO
	36HFiLpYTA5urvpW5Pve2SadknLYr45ROIKEL39p7hlgAfeRUbHYeYImN1vgaiI7CWGhaUZBHiK
	c0F9f3yI5f7bThtPms8OVmk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gpmYq5HDLzpSv2;
	Mon, 29 Jun 2026 20:58:55 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 472BC40538;
	Mon, 29 Jun 2026 21:07:20 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:16 +0800
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
Subject: [PATCH v16 10/18] arm64: ptrace: Extract syscall_exit_to_user_mode_work() helper
Date: Mon, 29 Jun 2026 21:06:08 +0800
Message-ID: <20260629130616.642022-11-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F394E160015
X-Stat-Signature: qnkh8yye6dw4bdrppqdgkrwjmx7qd3sh
X-HE-Tag: 1782738444-50591
X-HE-Meta: U2FsdGVkX18p92EFx2HbOAdFv7Xtf1qlv9BpXBmmns5/O2SBdJyIGAFmwohAWOhMmyswLPgJVISLw2nV1wGHYEjI+sCnKd615Ji7sgXzx2F0LF7Weq42N7QPeUd4J9ESHrf4E74vJ0wLBIuZ4fDqdIf0sCfgRru7Yce+SJ9sK/i7EMc8o4sUXKp9jnbDFGI4y61yxCYwzescWUiaMZ4a4Itl1H7sXPf1KY58gsfpMQtobfT56QeznYNXTGkGoVeqieAwy3qEkto/eFQvuq+HLCuiICio2o9UvM6g9uul9dlK/Yad/KkcSJ6P1MXrXnh6CbYj+C5WbY3aS/LGmCUOzfCx7DQJNEoXgBGUMqXIMlUooAFxwgo6cvqmZI0O4xaui3oMaxCUB1U2zh90hck4R4/9Gjxge53dKUJpTbRqTHeWqD5nUIzG4Dg0YHsHjc7pUCELwjNXMs/5y3rHNmYnc1DvmoHZ0G9C7RZVh9WjdBf2EdA4s+wYvDxPUAulrDoj269NM+XgCah+GjUTwSIakgHDnBMwsG1C6YDKKHbXTCzGspSegB4tZ+xQEN7KNM4ZJKSu19kwOkeoSB0ai/K84sNlgAKW3yRVsegzxCFY1vYP1aos2K9wEX1vMLexsLOW58PoQNI4IIZQKnpW92FHusJ2jeKkAQmuDSCR9egnetQU82ZOxvH3HyJeyEKJxYYu+o79NQN/EovwsSovOeZGbPYGdkpZ+UEYo9Jq55wwkijrF4j4d7jTYhPdCQuykocSz59tP7xWjGdjFnS3h5cp093/gt7vW9UwQeluU16JQe482eqNlOoyixrir2UMjNDcV4p+1YzP41eSsrFQ3kBFqvkiqhj9lMLtuvM/4B9L/e+fcZd4j/RqBEEOwG0Y8Ioh054mCklp6k+F6A8tmsCoAvYO+pf3QpCOoV5vyd47wBgj25Yr66jmmnaezJhTmwbeEG8FTigOh4oQ7MdwcsR
 nxt6vQ9q
 NW6rmcjNlrtIT74UhCr4l5R7buJLvNL7L880EoLKAoRHNPcHQwXDRfb9VupP55JCRMdcWIPw5Ux5gxoW+98t9xQqF7UMq0uous5Pxx8AV75a39D7HYNzaElGTdc7bU+dMslQK8qSa0vMEUaNDBmBMlTJ1eB9FfScPdCUyihjfgD7HPhV56CUXAZT/VVlZr3OtQ2m0ThBcH9WfUHm9qlzU38DNPDbuUJIiLzNHJimcPBezktrzNtVtmxrMuuq7g9T4yprIbTGxx+14ucvH8uwZPJXY987wFAM+DgdgrQzl2Y97oG0LP7MYXZY3BcULunug2LGDy0QFOfUIWoHN/1zvMEwFsWO5/zyvomxAfJD+Tsqpc1TtIXn8pOneJNMlf6fmg7Om7CkMQrHxBn1Ioh5hqfQ8+dFlKFFD+HzRe+Wq2w13Zo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for moving arm64 over to the generic entry code, extract
the core syscall exit tracing logic into a new inline helper,
syscall_exit_to_user_mode_work().

This new helper encapsulates the thread flags retrieval and syscall exit
processing, unifying the exit invocation paths across both the fast-path
bailout block and the slow-path trace_exit fallback in el0_svc_common().
This restructuring significantly streamlines the architecture for
the upcoming transition to the generic entry framework.

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h | 7 +++++++
 arch/arm64/kernel/syscall.c      | 9 +++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 8205af0be612..72461c22bb5e 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -123,4 +123,11 @@ static inline int syscall_get_arch(struct task_struct *task)
 int syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
 void syscall_exit_work(struct pt_regs *regs, unsigned long flags);
 
+static __always_inline void syscall_exit_to_user_mode_work(struct pt_regs *regs)
+{
+	unsigned long flags = read_thread_flags();
+
+	syscall_exit_work(regs, flags);
+}
+
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index f6e9aa132b09..6de1fe281d61 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -127,16 +127,13 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 */
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		flags = read_thread_flags();
-		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP) {
-			flags = read_thread_flags();
-			syscall_exit_work(regs, flags);
-		}
+		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
+			syscall_exit_to_user_mode_work(regs);
 		return;
 	}
 
 trace_exit:
-	flags = read_thread_flags();
-	syscall_exit_work(regs, flags);
+	syscall_exit_to_user_mode_work(regs);
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.34.1


