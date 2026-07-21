Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE11CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030526B009F; Tue, 21 Jul 2026 04:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008546B00A0; Tue, 21 Jul 2026 04:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87236B00A1; Tue, 21 Jul 2026 04:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B27C26B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10F9040422
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:14 +0000 (UTC)
X-FDA: 85012083828.23.040223E
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf29.hostedemail.com (Postfix) with ESMTP id C178A120007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sAofdY2I;
	spf=pass (imf29.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QxA3A4Lku8P85vsrBtlRJY6PRJUh7rKUMzSolSOZ7Q=;
	b=Kzvqg8CZAhgdNscj2h7OTBVppKX+FxEBxdmkBnxsSAj8/YbGAcJUpY6JunyLUbkoLCYtov
	IOTRVSxgtitH1V1loNtCd3EdIcUSn3TmjkKx02IJ+GCTYt0PPyc21by7MOP7diZmBq5xER
	t9RV3GAouNi8B04QK20O6p4E7Yn0iUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621952;
	b=K+LmCnj17Lo+6WVZ4vwr2GtRmSjaEjdVCOEYVW+ywsHQsZthNZXIpjqauhy0hIJkdZXOfu
	SShtA6f1+mXAnfC2RhTsR0xj09ss24tP2u8riuR5mbGGDJ+Uew1hFtpqNK3mQ3wlRseVmn
	25UEATuyvabFSaktms6zn8HY/sftyZw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sAofdY2I;
	spf=pass (imf29.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4QxA3A4Lku8P85vsrBtlRJY6PRJUh7rKUMzSolSOZ7Q=;
	b=sAofdY2IKh0/KeQIkE/McIKJ7buYpbDXIJnFGUR4J91mP3ltT98U8AQn2BPXnDdggl0XH5MJs
	sasq/18WBek/bgc4/F8TR74WJPXTIuEiW8vYbceJJZ8/uV3wvoZEQ5IuKxEbjqVlMs6s9+I7WG8
	2PrrfSIF0xeKQvSnVXBaxcs=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h495s0BC9znTbk;
	Tue, 21 Jul 2026 16:09:37 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D73A340580;
	Tue, 21 Jul 2026 16:19:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:07 +0800
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
Subject: [PATCH v17 09/15] arm64: ptrace: Align syscall exit work semantics with generic entry
Date: Tue, 21 Jul 2026 16:18:52 +0800
Message-ID: <20260721081858.1169276-10-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C178A120007
X-Stat-Signature: uhjtx5iidj36dugpaw69ucm7jiud3ki3
X-Rspam-User: 
X-HE-Tag: 1784621951-616404
X-HE-Meta: U2FsdGVkX18QaWjGTKf2UjPjvv9pq2tgm3elEfMgR3yjOG7o4nEn6HSBtKXeWs2TCZ6uxxF2IR9DB4HMHE8/urmf1OFHyRm8An6Lf7GOPeDx4teaiQywcu0bd4R/z3TtUGbY/+GzG8GvKOAc3+2yPXfAGWHwxBlCTQ/jLNRlFqr+M78pIm4H7ZpxhM9weWbUw0yiWHWLPxe2trVAajSDm4E7KO6ljX/AEsHnLMsKTyipVm+XfXa9ArP9OrWuyfRtvtfW4kUjzDI7XBVHi7H7iT09ULrmSSYDQv/jhghWJgRxU8kSNH7gKSqRhSxHWpfNdPxgfVWBUlMM+l7fBycbr6xYisdKrPhuTYGPM9o2Nkbzs+dC5SxRWCtDyidX7HWxd5VwR1O09tWHiJKNrhyiMDscV31LhF2wM2jHREdQPd2awc8Y1bEvr8JW4o8pbnGncSedWpCxemnk39EheB012mfVjUS0YUVfZe4n8Vyb1NxXZIAm7TFlcGvoXePV6WM5/kI6xmNJppA3PqzO8lLR1ysYN9Wt5Db8EVdSakilw+BroqKHYcd/Rps5AKamUPqL5Za7hX1elK5k7KyDNbqIfNqLjXNzgz0BOJp9wEoSWZYr1O8+fphRC1zZZObq9FCfCJKDSOE4Xypf0boTseaTsGR2999C2MqH/vsvyo57scReY6S9wBkn3gKg/DONxAdgxnyaUBtaSWMP+4xJilzS51oFvlesf8yD+PZhptl2ZWdpaiZozADyU6sCxJAHV8Q3+AgAVpKrgXAqeYJfh+mQADUD3l8woyxe+jcMdLynQvZAsB7g7FDFbkjsibQhhYDlmui/32eOUzZhqPjhOBRfsAT0+66K0W1jZKkpj+OkGM8Zc0/k/eDwqbEb0D8fBjnXonbs2L/f3nKUZ7RfJ1hWLIWavp05OUfTc/RHvtgVV2YPUwgFezT/FrId58r5Jqd8xY33MsLmCBJ2fWArJyG
 fgMY/+Bx
 xTos3lS/f2Winv3RFa/E//8CI/apT5QWKuwym6CH2SjH5ZVMofeR6U3Fft1WYROoAxn0qQHu9TEb6z74RJ4IgDg++JyZSEatZmd5U1hxuEgD8yTzUSu0Cwd+NCBmLe3LIZvwK7f64gxL5epTlmTevf4ie+/PWUsCDus6GsUUPibM4YFtyzYgGoB0mhJGilJ7ZUke1Jo8GlvMMaENrivRiojeeAXJquFEGDSvXr4gQVgLsaKbuMpPsrP/opT4H0SkX9oWxV0/wCoEZhZrYoXV2tqvKIR+HScDF0sYkrzncpQxApRZ+QU+HyFRk1KRwQKZUOxvSQXiRr+n8dXdiN26tgnaNGObZmAf8uMY9qZk4m+5obUvlpctGVVDMiav2wfqIqy+o/W2AgMTsomj0nn8JT8X9UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the syscall exit path to better match the generic entry
framework. Specifically:

- Introduce `_TIF_SYSCALL_EXIT_WORK` to aggregate exit-time thread
  flags (trace, audit, tracepoint).

- Rename `syscall_trace_exit()` to `arm64_syscall_exit_work()` to
  better reflect its role.

- Move `rseq_syscall()` out of `arm64_syscall_exit_work()` and into
  `arm64_syscall_exit_to_user_mode_work()` so that it runs
  unconditionally on all exits, consistent with generic entry.

- Gate `arm64_syscall_exit_work()` behind the new flag check,
  mirroring the generic entry exit's pattern.

Gating audit on `_TIF_SYSCALL_AUDIT` is equivalent to the previous
`audit_context()` check: the audit context and flag are statically
allocated at fork and freed at exit, remaining stable throughout
syscall execution.

No functional changes intended.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h     | 8 ++++++--
 arch/arm64/include/asm/thread_info.h | 3 +++
 arch/arm64/kernel/ptrace.c           | 5 +----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 3e4672ab4a4f..7cc872fde019 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -8,6 +8,7 @@
 #include <uapi/linux/audit.h>
 #include <linux/compat.h>
 #include <linux/err.h>
+#include <linux/rseq.h>
 
 typedef long (*syscall_fn_t)(const struct pt_regs *regs);
 
@@ -121,13 +122,16 @@ static inline int syscall_get_arch(struct task_struct *task)
 }
 
 int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
-void syscall_trace_exit(struct pt_regs *regs, unsigned long flags);
+void arm64_syscall_exit_work(struct pt_regs *regs, unsigned long flags);
 
 static __always_inline void arm64_syscall_exit_to_user_mode_work(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
 
-	syscall_trace_exit(regs, flags);
+	rseq_syscall(regs);
+
+	if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
+		arm64_syscall_exit_work(regs, flags);
 }
 
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 5d7fe3e153c8..56a2c9426a32 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -112,6 +112,9 @@ void arch_setup_new_exec(void);
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
 				 _TIF_SYSCALL_EMU)
 
+#define _TIF_SYSCALL_EXIT_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
+				 _TIF_SYSCALL_TRACEPOINT)
+
 #ifdef CONFIG_SHADOW_CALL_STACK
 #define INIT_SCS							\
 	.scs_base	= init_shadow_call_stack,			\
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 18fa29ae1425..10ead67b4eaf 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -28,7 +28,6 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/regset.h>
 #include <linux/elf.h>
-#include <linux/rseq.h>
 
 #include <asm/compat.h>
 #include <asm/cpufeature.h>
@@ -2505,12 +2504,10 @@ static inline bool report_single_step(unsigned long flags)
 	return flags & _TIF_SINGLESTEP;
 }
 
-void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
+void arm64_syscall_exit_work(struct pt_regs *regs, unsigned long flags)
 {
 	bool step;
 
-	rseq_syscall(regs);
-
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
-- 
2.34.1


