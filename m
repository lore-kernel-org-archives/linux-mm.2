Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22F4C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3162A6B009D; Tue, 21 Jul 2026 04:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2789A6B009E; Tue, 21 Jul 2026 04:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6F76B009F; Tue, 21 Jul 2026 04:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB8956B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AC7980406
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:13 +0000 (UTC)
X-FDA: 85012083786.07.92AC9E8
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3849B40005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LWCZLEU1;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621951;
	b=FpzVw4C8AdRuw25uw/e62fTkNAHT7IHwTxFu5ZYNM9l11P1ZQEik2wr+R2hS+488puowRT
	9tP64MepTyBpzSfi1agtflGPXaTofMk0iD6ggDGGNi6GQqK8O/5zKIra57BU8SDz6RcUDi
	mBUmaqtq6iBixDxoZkhToll0oRXzKx8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LWCZLEU1;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CiaahaToFppmPwVd7Pwi+Vc5vJveVZoN1kPcfp1lAo=;
	b=AeLH9Ou8O0Jo7KM72d+x91/uaubSC7qKnDjeuvlkNI3I1xMvPpJc9YHGgZiPiaaVYQj75T
	YTc2BGICP3ZHJLx99qhdij17J3kOpwMjghSVxGrqyN23Wp57sSQGW3Nw1Dl4p41wpSbscM
	9cVHynGs64hj2zQ4mZzUjqlEKZQAr1o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2CiaahaToFppmPwVd7Pwi+Vc5vJveVZoN1kPcfp1lAo=;
	b=LWCZLEU1eUmaXto6Kc69xnIQX0Fgk1EFVFHhc2Drd1C0ZJ/EAGWWeXcLAdS37X/tP+sbEhnoy
	oXC41rxyPpwFuKPyPMy5eacS49vlt4IdFvEhMnMI+k2ZkjFzXhpggeXcWyiorWSEzypfjBmgiA0
	xPvHbptfWpKid8BLd73p7kE=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h496140NBzLlWC;
	Tue, 21 Jul 2026 16:09:45 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 90EC940565;
	Tue, 21 Jul 2026 16:19:07 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:06 +0800
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
Subject: [PATCH v17 08/15] arm64: ptrace: Extract arm64_syscall_exit_to_user_mode_work() helper
Date: Tue, 21 Jul 2026 16:18:51 +0800
Message-ID: <20260721081858.1169276-9-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3849B40005
X-Stat-Signature: hazf5kns1qcqr7pia3gigk71smn6yca3
X-Rspam-User: 
X-HE-Tag: 1784621950-457470
X-HE-Meta: U2FsdGVkX18BkDKyfwPHurXwd4wtvLrcicckG56Z2qx5z+CZItWpTN0N+SSeS96AgwZpWQHNLndhure9e64EM52Lha634PiqKzP5mxsYce4lUbdFU+HoUKFw/VWq2Vi2gVp4CE5pl5e+B2fzdttuafVnwSdj0om9/J3naFxirhtAogOcXi0wrn0/DDfxm+8UeFg51w+5dva5fVZ/bunMX3rPkD5lkuUHZ6D5CkGbkOosgeY81WHQ0CaPzCR0qLagQ4+jPI41E/v7Q4x4GmlDHisRk0+zz9W0yT4TKBAeDLEzwuGlOm/51RsvhdSE0xoeSaanwcBCsvk7dscnjDf0WK6w6L830mnD6ay/Oaqd24OEnsAZfSRJEz3O6uStjdDLHgUclPyDx2iFVnafxpMDcGNIJj/rEFf0O6u4lY/p2rhB3yrcs91R+OiJ9n+WYRvDzoSX1AB6l6vfy0N1kT/DSO1nlEcwQq9MO5YO5q3enLjN6GGgPtAmRWrm9KvyG9L46ub9dzWTfQjkxuuzvcjIGItq+Cjq6eU2A3F6PmzPAp83jZDRpTnbj2P58EyZvFaHsiGgGP7HrW6q5lw+1t2AJoNE0en6owaTgi+iRcXf8kwEPH/7kir0H+NRvaZt4e7dY/3W9+U17wnFbkUi+boXuvtNGiRJ7Ql+tZhTeX3viKErwi7pOOnLhAbX8RDWBvTODrDGYGKYyrVIak3b2F38bnDDZsYQJrn5AEaD3VgssklAAahZvH7FYQwr1N4XcOsl+Pi4DyChKFKEpnOQpBcADUrkSOQ+CywsOQd1fN3E8Lohj9tv5dS0TmN5Aw2Dopl3ovtqoiwI1ZRgiq5UAwD5dC3UluyBHWfGwZkHtfYE71WrwNNy+2XDkywIydM/lDzc6870YnvqJ1pLkM4qMJwgaCUOS+2f917eJRwGI+pyNreKzbXORoBIvVgw5V2kdK/xkvi5zK5xEMKdSIjqTKg
 wFdfeRF/
 +nHW6OTqpd0AiifVInjhQKVGzh8vv/jp2+4+KZvQ+QjQ4qfJ7diHyynvZutVP0GkouP14yWZ2xlcZqvOOH5h7VMNIutHS4tvRtxnCMiiG/7VKJn8wgUXKHzfbculTokqcYpSQq2gKKFEWHOMZw0vNhFtkpZIifUgSflJK19FlgfpeN0iVwZ+XfF4R63iOCpQk+dSzK/vagx/ZZ2wqP9YuD8mvysl35oXgDLecj7Z98cVc3aWlz4Gpn/Snkt6fBHS9iKyF9zU+d4X/DVik+HuG4zggm7Mg0hSdgbpWy+N8qoDeOP55Y5PWopFB1E8kI8F3cXU1CnKPlIK/xZMBFrXBPpSgmmz1keU/4VhNqs4dqaOlIH+yvUy7B6pSJM4IP5nJQ9iNSOG23jTyE7cyCOpe92ri40Lh0KDEYm5BOjwN4UdLuLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper arm64_syscall_exit_to_user_mode_work() that
encapsulates the re-reading of thread flags and the call to
syscall_trace_exit().  Use it in el0_svc_common() to replace
the open-coded instances, removing the duplicated flags read
and making the control flow simpler.

This aligns the arm64 exit path with the pattern expected by the
generic entry infrastructure, which uses a similar
syscall_exit_to_user_mode_work() callback.

No functional changes intended; this is a preparation step for converting
arm64 to the generic entry infrastructure.

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
index 696739f5a250..3e4672ab4a4f 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -123,4 +123,11 @@ static inline int syscall_get_arch(struct task_struct *task)
 int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
 void syscall_trace_exit(struct pt_regs *regs, unsigned long flags);
 
+static __always_inline void arm64_syscall_exit_to_user_mode_work(struct pt_regs *regs)
+{
+	unsigned long flags = read_thread_flags();
+
+	syscall_trace_exit(regs, flags);
+}
+
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index e778aac6fab9..0061fc63e7ba 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -127,16 +127,13 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 */
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		flags = read_thread_flags();
-		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP) {
-			flags = read_thread_flags();
-			syscall_trace_exit(regs, flags);
-		}
+		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
+			arm64_syscall_exit_to_user_mode_work(regs);
 		return;
 	}
 
 trace_exit:
-	flags = read_thread_flags();
-	syscall_trace_exit(regs, flags);
+	arm64_syscall_exit_to_user_mode_work(regs);
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.34.1


