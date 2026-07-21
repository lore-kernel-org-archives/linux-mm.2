Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D348C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12D56B00A2; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA396B00A3; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD89C6B00A4; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 896616B00A2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1F1DA0454
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:18 +0000 (UTC)
X-FDA: 85012083996.25.2DAD3E7
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf26.hostedemail.com (Postfix) with ESMTP id 002D614000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Lm7Mwl8j;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lh7h7vTKaIOCDCwAfymzFileaKG83eBW/Fb4jfXmBeg=;
	b=0IL9kRifKDbih57RnzImPp964tZfTcpoonRLuVG/fGb89ZhaZd/wyAnfN6QJFB2ZFpB+IB
	Z9vC8VdKoLduNroBVnlP6wbDFo458AOYxmdZOpnNU9DvPjlKhY7atp28BaNXLxSU94EN1c
	p/lPzBBwesJnjQmkZvK4hD6IP5SgRQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Lm7Mwl8j;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621957;
	b=suMYIGZUNJOBe+dP3SYg8BuibbcNozy+YMoCVoa9eMvK1eXz24UQJFRY/X0G9wFiluH5Jw
	9t3fs4Il+JVGeSUuSUbkr84QUVZEVGRbeM5IHWs93N9EYlQKQD5Ar5EZ/JA9hzGbxfCSOz
	u2cmEg5Fw/QKig+DMzHN8Qvb62d79UA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Lh7h7vTKaIOCDCwAfymzFileaKG83eBW/Fb4jfXmBeg=;
	b=Lm7Mwl8j9+v+3+wqcv1x+wLel/grMZGJ5AVCHmpiG2UKw9qSdVW8pYoFHu3lJD6K8uKLPD2l/
	QjF0c10QOhrEPpryKHrTofiNFbrd0orxnAlQf36c1lydojOuE0E/YCKKyhQPH79D74plmQbUG4m
	sD956xUjMQX4X90PXrBkri8=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h49663K70zmV8f;
	Tue, 21 Jul 2026 16:09:50 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id A88E040588;
	Tue, 21 Jul 2026 16:19:12 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:11 +0800
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
Subject: [PATCH v17 12/15] arm64: ptrace: Make return type of arm64_syscall_trace_enter() bool
Date: Tue, 21 Jul 2026 16:18:55 +0800
Message-ID: <20260721081858.1169276-13-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Queue-Id: 002D614000E
X-Rspam-User: 
X-Stat-Signature: 4on3ubnao48ggg97zg7pqt31x1qx1k8w
X-Rspamd-Server: rspam04
X-HE-Tag: 1784621955-373336
X-HE-Meta: U2FsdGVkX1+G68OS8u0XI+cdztspS0RjYWl3+UEO4eAHW/ymqEXrvUT1vSnSdUNOKAF4uQH7zSEtbRBQxefY8mBeqRVaXdzoDpMzizyfCmdcEpuBvafs35bk2yhQy91X18WLoV1LfFxj3mMrlF3ltcPlu4is8Hrj8jSZffx+OfRzzzb07angLQK0FyfWj4xx+I2BGyi3cNzkDW5cTeANrh/fXc2HU/mGaDUUKh5Fid/LbD6k7NqN+F7tZY0/f20ApDOcV36QyhZ/iW0kmKIYEaFXo6HxQj6NCx0NKBd+Ubhp6EmitrWQ/+ZtTYjpYKPxeQ/NevpeCU8XAN2xgeJCktRhMEvxDv0u7YJqmclD1Ku3iIy0Z33ZG5Q2c+2M/PpzgugSwetveNNO9nSIH4F+G2BeE9L27g2gt5ZHvSVksxZ56+HEdsUIrK88/TVWPvixMo+cZi0WHBnb2+wWuvsFUkfYo5jWE2WE1qb8z49DutJcIOm+vatLGiAVDmonexrAEEWp8HkHw41DCPiijZtVvUaeWkISOQrYvkRs/PKDSmoDhmDWw0WTmyyuS9EUijAHhvENwGOrZAFsv7hCs7v27RFc4A9Atc9mr+li9T2aUk82mcsg55rmq699h3AQ4RaIrqi/A+0G95/8F3fXI79jH09jdlZNMVMINM2QLrew6Mnn/nook0B3yk5GKVBhUOijNpNOAwTvz9SacGbyfr1rRJiyPqAPIl2iHcqhkxm3jDtNtgHZAS0TtpWrfXR/KqtPxHQnbblFlLq3WzSTEA/83fwF7+3sWTtIWyuxXKCD5VdzBYwuykPSJ1ToDfmXi0QuvrSLlGr6lLMOySQa9fJWuiHH7fIppuI1CEu8aPo0xethw5c2hZHPzotv65sHDq21G65yqMwh2NI7/OxGHzf7ES6YIgV52WLj/JMkWz+xamrzBUxsiEf2HQOPzPpH2PVHoyRflGpXlz6uXybKohA
 YdvMTBtX
 Beuanu86WCSJcFMLctCSSiJNAs4MKDRXapQdi7qt4zSEvZs6xFCWHGkTav3mDgrlLwi2uyZXtpszaSxnsV/4xV+VbHGUtuqfwzuNsm1OSWBmh/QMdz81sYwc0cCni3KVEAxbevjSuzTpalMQmO84f6mpSEvEUG6WCrqD3pA+HAzGSeY6V+EgfcGXknzHzd5Cmxnx6CBWD7LLj6S03pPgE/uQzmISDCRoj44+yFXvX+nBoV7BgZ/07AlscIYNw1DtNgucFlAPbgKWH0mBSvfrGx/07ezvF6FK6zfaC80Cym610xQ/3MxirfWRsb9LegCsBoDeWFZYHspVAFxPo0UDfYWpElzbMxDQzmjQ+VpjV+pJDUzGI7NrVxFOYdMrsnd3aY5DG2ojVE/NcYb1HtfsQqngliU+lOeqcmFpOAhkdlVO5jH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for migrating arm64 to the generic entry infrastructure,
decouple the decision to execute the syscall from the syscall number
itself. The ptrace and seccomp now returns a boolean flag rather than
overloading NO_SYSCALL (-1).

Changes:
- arm64_syscall_trace_enter() returns bool:
  - false: abort syscall execution
  - true: proceed, with syscall number reread from regs
- If we decide to execute the syscall, reread the syscall number
  and check if it is NO_SYSCALL again. Because when a tracer sets
  the syscall number to -1 and provides a custom return value in x0,
  this avoids calling invoke_syscall() which would overwrite the custom
  value with -ENOSYS by sys_ni_syscall().

Behavioral impact (unchanged):
- User-issued syscall(-1): unchanged, returns -ENOSYS.
- Tracer skip with custom x0: unchanged, returns custom x0
- Tracer skip without setting x0: unchanged, returns original
  argument (garbage)
- Normal syscalls and seccomp rejects: unaffected

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h | 2 +-
 arch/arm64/kernel/ptrace.c       | 8 ++++----
 arch/arm64/kernel/syscall.c      | 6 +++++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 7cc872fde019..f19d4a8824ba 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -121,7 +121,7 @@ static inline int syscall_get_arch(struct task_struct *task)
 	return AUDIT_ARCH_AARCH64;
 }
 
-int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
+bool arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
 void arm64_syscall_exit_work(struct pt_regs *regs, unsigned long flags);
 
 static __always_inline void arm64_syscall_exit_to_user_mode_work(struct pt_regs *regs)
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 10ead67b4eaf..b2b28dcb2826 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2468,14 +2468,14 @@ static inline void syscall_enter_audit(struct pt_regs *regs)
 }
 #endif
 
-int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
+bool arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 {
 	int ret;
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
 		ret = report_syscall_entry(regs);
 		if (ret || (flags & _TIF_SYSCALL_EMU))
-			return NO_SYSCALL;
+			return false;
 
 		/* ptrace might have changed thread flags */
 		flags = read_thread_flags();
@@ -2484,7 +2484,7 @@ int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 	/* Do the secure computing after ptrace; failures should be fast. */
 	if (unlikely(flags & _TIF_SECCOMP)) {
 		if (!__seccomp_permit_syscall())
-			return NO_SYSCALL;
+			return false;
 	}
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
@@ -2493,7 +2493,7 @@ int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 	if (unlikely(audit_context()))
 		syscall_enter_audit(regs);
 
-	return syscall_get_nr(current, regs);
+	return true;
 }
 
 static inline bool report_single_step(unsigned long flags)
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 3488afd45d20..72c6e8b7ab21 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -108,7 +108,11 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		 */
 		if (scno == NO_SYSCALL)
 			syscall_set_return_value(current, regs, -ENOSYS, 0);
-		scno = arm64_syscall_trace_enter(regs, read_thread_flags());
+		if (!arm64_syscall_trace_enter(regs, read_thread_flags()))
+			goto trace_exit;
+
+		/* Reread the syscall number as it might have been modified */
+		scno = syscall_get_nr(current, regs);
 		if (scno == NO_SYSCALL)
 			goto trace_exit;
 	}
-- 
2.34.1


