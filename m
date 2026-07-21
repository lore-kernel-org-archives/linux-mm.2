Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DD2C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE8D6B009B; Tue, 21 Jul 2026 04:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E566B009D; Tue, 21 Jul 2026 04:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAFC6B009E; Tue, 21 Jul 2026 04:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2C406B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14FA41A0429
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:12 +0000 (UTC)
X-FDA: 85012083744.15.A0F55A1
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf22.hostedemail.com (Postfix) with ESMTP id BA534C0004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qH3c7lcs;
	spf=pass (imf22.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryQ2hwYYW7NAQIt/JNDlICEsgqwe1CEogCM860IyUNg=;
	b=5eBmRV9gLmVVF5sh4qrX5066eqHxtc8pXLjKTY2kipCToCl6SlXV6Ufflx3vKismctZxfu
	8HHaYG6lrKCMdXLeQgOiym22QooiKcW/MpS/bTFnVEZaasELra/ycSJFJP6ddZXS7j6GnY
	mD28hEPmsy6CPQhBsDYrlnjNNbYu9MI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621950;
	b=g08jZKq7xe+T5w1fmeQ/rYJXRcJ3DYYzTBX24RBG5axRELxgDGSZtq6riMoAY03UmTgYpV
	hfd7msKOY1GGnoi1pOQrS5xX+MJmWVzV9gUubimeTaBlYyfgyH1du75zSGsNSiw5hVneoj
	PnfUNd9pP4FmRgFA/3wblPzoVPOFYyw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qH3c7lcs;
	spf=pass (imf22.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ryQ2hwYYW7NAQIt/JNDlICEsgqwe1CEogCM860IyUNg=;
	b=qH3c7lcsfFjYw49OQabDNUJT2ZxQ1jtMXnuVY9bAFODAodjmQJbgh38aXMYg/vkRkcelmDB67
	R5FNqmvz17qI//XAueLpCbe9h80ZoSszPs/WZGAFu4BJCf7vZEAGh4SMWZcDi7nuRJBqswvAMkq
	9FadGLfqBPE5Es0GMqCTm2Q=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h495p3XnYznTbk;
	Tue, 21 Jul 2026 16:09:34 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 5934240572;
	Tue, 21 Jul 2026 16:19:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:05 +0800
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
Subject: [PATCH v17 07/15] arm64: ptrace: Pass thread flags to trace enter/exit
Date: Tue, 21 Jul 2026 16:18:50 +0800
Message-ID: <20260721081858.1169276-8-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Queue-Id: BA534C0004
X-Stat-Signature: 5tsst7anpwths938o4fy5mc8ojd8xosy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784621949-485546
X-HE-Meta: U2FsdGVkX1+FFC83J3Ar6d8oUIE4blt236i9nHamfmn6BIM0bFZAI2RlI/pOuLzB9v39OCzdsMehjDTsTvGYhHXfHGex11O38CvfRbhT/IV+uMHdt52gnq2Vsj0sXH4iwEHiE16vhh1chAIdy6YglVaBLmbjhwKK7ypny6HMonAvRbMTrxUwIEiWJsDALOIvWdR3uFM/limdKmBqJuFVKGdMVcEPb+KV6GixgtVMqa2gVFVzunc9sEjPOduVCo5kpn2CPjN05CA6z1sn2qW/auTvz2fXCN82sCCCjTkm/xCeTIDzpfyy76qZW5sDX250aT1932jfdjEuiq/YPgTDN/d5CpcrGt5NFQUX6LytGlRFBygNJEqkNAuQ/UCw4eiKMVwi9hyKPxmUhomWh31SvF83yV8va+TQA3usubftWXFlI+JAbKCUymQjr7M1NoqwCqcnyhJGqiGrCj8UCBwOIb9qT0LG/d1PUUt/i3J2VlYCtpm/b1AdX7d+j+TsVZNBvvGZ/PHbovuUNYrAk/k9HnAVIH4GIy1xLU7DR5iJPrvScMu8MO2C5cVTYbKqwBtR5g6qkmQb8mPHjZbXwmu1bSj5XW3EIHuNbrxWMMT1sfrh4Ncv/8oAOQFEAIOBY/I6OU8R7XqFSRQ6rYg8eWosYTrVv8KWI1uLjHAHFbrlUjDTEkduuff/5h9k1+HYz0PahBI/JpSeD6scsoWcwLl8SIeHLtjbuFC74T62UFGVL7QuUe69TyMkk973IBBNupVUl0XIMDwo0HCwwYpb1bGj02PphLEgn7IExhSOFRMteUu8BxGAx4VnOOugqF20PsRtNV9PyHl6dMEIsWqHJIly00dErDDP96VcqS+cBi6vPizVadtqAhY0Id0p0AUEm12n75pApVFRqn1zyymgr59epelKlOroniHaKTWxu5g6CSKKR7D4WTDq4wBRnpAkjki7saQ2oohJ/UVSRLIXaOq
 AJXtNmgR
 CA68RmxEQPhsuGB7DU45sbGTDUWDF0zxcaiPL0UJ+5x31fSqdciyPV4ZIJg8oR5sOfrMJco6A1EG9e5BJDwcpd+HF24dGNqkJLldNB0QwSoob9FrpbaLL6zl0LmiM5CF7TCjWoxoFth7K6l/OO7msB9rLGUObY856tXtTjbWS0WmpB44pLgqPH5enYwaxyGEuOHLlY34UEoT4WEzROraR76VxHorvL7Ewa9bP14Jk2aTsALcQtrWaqNFo+dRLTi1ATtjUXV+rQ3B7Dux0vfCks5YhpClyGEJsV1a/iKBWhHmTuiE0F9BM/TThnABkYqZUVTat3unM/rPACFpHzctlS2KhoMyBYUnvUkaewdbbnzwEH/L7eqCCgyJ0cAP8AgB5+ahJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the reading of thread flags from inside arm64_syscall_trace_enter()
and syscall_trace_exit() to their callers.  This aligns the function
signatures with the generic entry framework, where the caller
is responsible for supplying the flags.

In el0_svc_common(), the flags are now passed directly to the tracing
functions, and re-read before the enter/exit path to reflect any updates.

No functional change intended; this is a preparatory step for
converting arm64 to the generic entry infrastructure.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h |  4 ++--
 arch/arm64/kernel/ptrace.c       |  6 ++----
 arch/arm64/kernel/syscall.c      | 11 +++++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index d1dabdcde41c..696739f5a250 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -120,7 +120,7 @@ static inline int syscall_get_arch(struct task_struct *task)
 	return AUDIT_ARCH_AARCH64;
 }
 
-int arm64_syscall_trace_enter(struct pt_regs *regs);
-void syscall_trace_exit(struct pt_regs *regs);
+int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags);
+void syscall_trace_exit(struct pt_regs *regs, unsigned long flags);
 
 #endif	/* __ASM_SYSCALL_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index a7091333a9e9..18fa29ae1425 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2469,9 +2469,8 @@ static inline void syscall_enter_audit(struct pt_regs *regs)
 }
 #endif
 
-int arm64_syscall_trace_enter(struct pt_regs *regs)
+int arm64_syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 {
-	unsigned long flags = read_thread_flags();
 	int ret;
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
@@ -2506,9 +2505,8 @@ static inline bool report_single_step(unsigned long flags)
 	return flags & _TIF_SINGLESTEP;
 }
 
-void syscall_trace_exit(struct pt_regs *regs)
+void syscall_trace_exit(struct pt_regs *regs, unsigned long flags)
 {
-	unsigned long flags = read_thread_flags();
 	bool step;
 
 	rseq_syscall(regs);
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index b8d7d29a431b..e778aac6fab9 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -113,7 +113,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		 */
 		if (scno == NO_SYSCALL)
 			syscall_set_return_value(current, regs, -ENOSYS, 0);
-		scno = arm64_syscall_trace_enter(regs);
+		scno = arm64_syscall_trace_enter(regs, read_thread_flags());
 		if (scno == NO_SYSCALL)
 			goto trace_exit;
 	}
@@ -127,13 +127,16 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 */
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		flags = read_thread_flags();
-		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
-			syscall_trace_exit(regs);
+		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP) {
+			flags = read_thread_flags();
+			syscall_trace_exit(regs, flags);
+		}
 		return;
 	}
 
 trace_exit:
-	syscall_trace_exit(regs);
+	flags = read_thread_flags();
+	syscall_trace_exit(regs, flags);
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.34.1


