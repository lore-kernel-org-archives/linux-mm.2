Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2ABC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF936B0093; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FDC6B0095; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD496B0096; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7326B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD967A0462
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:08 +0000 (UTC)
X-FDA: 85012083576.01.6DE1195
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf31.hostedemail.com (Postfix) with ESMTP id 81A4920003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="M+/Ejxxn";
	spf=pass (imf31.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTcYvhfX5GMjsoEzyZU2Oo3ewF8hCnSfBncHN/B9G88=;
	b=HTcqg++naNFLvyuza1HAYGp6etrQnUAALua2u6TIEGLkhwK4RfP1Cjhc9leaPOZAUYoKnF
	tMdRuN7v/Y1ESvTxDxC2tSEkjf13JjD5x6+gREHjZ+KoN9IeVpsK2fCAOuYA1wivjGM/JZ
	kzpbOB9Uw6DKkpA/HOoSO6KkE+3MQ8U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="M+/Ejxxn";
	spf=pass (imf31.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621947;
	b=b8WgYuPehCtsf7CiVitlXMoQxHgRq1WdjJvvVyIAF3RYDR8PvzWWSHMcVJCXh4jMcGDALr
	WdwkzyEvGfr0PtXtAikHinBVZIqG14dHicdHmT0aTRrKMVantKi8AHFuCqkSKCL6ClgS/h
	p3w0rB9PfK1PcMQqYWtMCgg0fIm+uXk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sTcYvhfX5GMjsoEzyZU2Oo3ewF8hCnSfBncHN/B9G88=;
	b=M+/EjxxnR3B3nd+Kkfpm6YBuhFPSbx3W3mFYbVp6f8m+lWlQY8QcgZgFmSjHJNp0qg7lwvxRG
	Jc5lfx+2FQq9RH+YI34FRV3yute6HvqR9CJDWDX9EEVufGdXHadisBEE14ejlF9f4Kw1IunrzL2
	Vhtl20PtMtMHF537dvCQKjg=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h495k4RQMznTVd;
	Tue, 21 Jul 2026 16:09:30 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 77FD040586;
	Tue, 21 Jul 2026 16:19:02 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:01 +0800
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
Subject: [PATCH v17 04/15] arm64: ptrace: Rename and clean up syscall_trace_enter()
Date: Tue, 21 Jul 2026 16:18:47 +0800
Message-ID: <20260721081858.1169276-5-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 81A4920003
X-Stat-Signature: jakuu9xsfqynhc1czy686u5uf68e7k48
X-HE-Tag: 1784621946-412682
X-HE-Meta: U2FsdGVkX19iUnXgD95Cdz9KngLl8Vg/HQ2VXRrzW5xE4HGh5mDcGwVTGa5ciQQlGOwMpL8k+xuLvp8fVUCLkRXzoDrq/lr8mPDRTQvFvIs1c68vWL5EO2jtm9d6UU6oRX8wvr3icY7zgY8tMcJwORHlGmhMwBlyeaW2xJwODdyBubtBdpb7t9GzQw0ZGmALQYBMvMyoGEUwdKkIxpVrcgWwssMzhr0Bz01V5c5POcRNtljUZpdZ044OwvNtX8iPRTiRcnbaU3oNwKXMs0moBrvUqzI2flSoYDQDrNJV6276Ip+fDcL7Dpqh0EUD7JRuMf6YykdeD/eKFn7xJCfjopI87r9UPpHpfVjXVyJnYwY1pybGX1AMJ5eMv1ut665l+5Mc8N6u/DcJ+L7crtRnE5KCm6w4Zrtl1KJISQ4LzFyKrI9IBPW41WPanLzuP+G35bZ8bAmqcV3USPNA0f9pHviMYq3BasIhaiHavcgdFUeMqPjarkIrT8SMkLH0XtYQ+6e/AXbzZqvFjIslI47SLqkjeYJknuVzy4KK7X+PBM9rL/aGIcblVR7ZRUeKn457JxPJK5Zze44hekaYhM1IljD/zUTflZG1VVOtwNItUwTLG4pgB+qtNkERzOSGWbQtYWxeSSC2SKhTjUc67enbmTS/2aVvfLXVJjrCAN7zAS8oIyQ5VblqmtCcAF8Tq9Gh/2oiepc1A4ZmEe8heYGG+QKAGpbFZfHEiY++YxBJOMXmCSLQ3NtWsYA6ebgJmNrBmgadfnI8yGfqwaYY7hW9LPYZjL3PKQfnNyplTXrC8RJcPpWCsOb7tKw7ggRCzO6i6N15mFzeDBqlpDx1kzyfz7vPZ3rhAiOMNxCBUHW5Y/B39qjg4qqx1e2ofEhWiO/RaRLxh912odYkDnqCaMfA0VA6CZFWX5VsGFWFpv36U9wm1d/WQZX32rhii2kUU8xzauYjwGIc15jm9sZJdOM
 RaSxIbCm
 mvdTJNxcJq6KrW5RGL1F/8amp1ALQRcNB2dmXOtR481khITP73XaPxVdRwihJdh3K59R0tHHOq6oAwblhqb11ak5i2AENXBSJmfyxu/xZLhBNdPa9WPeICaEi0PKput7FQuuez4rwvoXIeBWpRDg9+pRYhOMGhLFEhgFaupCS6iWeJiaBXWv+B6WXCTTUgDRnouKF+JWJIWijcILtHZl/bRrzCV9UfDDMijGeS945VQLs0kO2K6DyfD0sLEpyWORxbz4Nhkt1x2ygqk14l2YIrqqBhniRTvPWc2Wb0wnGlr5Jbit2Zs+b1pHXSsTDkg0TeCk1c+ZDmJoOgo1P0yQ2jO1tCvtSNDg0EOpUDl6LLKq56lwr8gvSmilxunT9RLBwSY+MsnBOrS8dNqlUxiHz0PJb0IYUsEkbmT25i2+SE/TiREw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename syscall_trace_enter() to arm64_syscall_trace_enter() to avoid
name collisions and clarify the boundary when arm64 eventually switches
to the generic entry infrastructure.

In addition, replace direct accesses to regs->syscallno with the standard
syscall_get_nr() helper for both trace_sys_enter() and the return value.
This decouples the tracing logic from architecture-specific struct pt_regs
layouts, aligning the implementation with the generic entry pattern.

No functional changes intended; this is a preparation step for
converting arm64 to the generic entry infrastructure.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h | 2 +-
 arch/arm64/kernel/ptrace.c       | 6 +++---
 arch/arm64/kernel/syscall.c      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 5e4c7fc44f73..d1dabdcde41c 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -120,7 +120,7 @@ static inline int syscall_get_arch(struct task_struct *task)
 	return AUDIT_ARCH_AARCH64;
 }
 
-int syscall_trace_enter(struct pt_regs *regs);
+int arm64_syscall_trace_enter(struct pt_regs *regs);
 void syscall_trace_exit(struct pt_regs *regs);
 
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index cd0607ec70ef..4c7dba12629c 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2469,7 +2469,7 @@ static inline void syscall_enter_audit(struct pt_regs *regs)
 }
 #endif
 
-int syscall_trace_enter(struct pt_regs *regs)
+int arm64_syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
 	int ret;
@@ -2490,12 +2490,12 @@ int syscall_trace_enter(struct pt_regs *regs)
 	}
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-		trace_sys_enter(regs, regs->syscallno);
+		trace_sys_enter(regs, syscall_get_nr(current, regs));
 
 	if (unlikely(audit_context()))
 		syscall_enter_audit(regs);
 
-	return regs->syscallno;
+	return syscall_get_nr(current, regs);
 }
 
 static inline bool report_single_step(unsigned long flags)
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 358ddfbf1401..3e78e159b2a1 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -113,7 +113,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		 */
 		if (scno == NO_SYSCALL)
 			syscall_set_return_value(current, regs, -ENOSYS, 0);
-		scno = syscall_trace_enter(regs);
+		scno = arm64_syscall_trace_enter(regs);
 		if (scno == NO_SYSCALL)
 			goto trace_exit;
 	}
-- 
2.34.1


