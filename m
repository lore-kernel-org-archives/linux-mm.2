Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F2FC43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044C56B00D0; Mon, 29 Jun 2026 09:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27A36B00D4; Mon, 29 Jun 2026 09:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC8A6B00D0; Mon, 29 Jun 2026 09:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 832CA6B00D0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03C9B140666
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:32 +0000 (UTC)
X-FDA: 84932976786.17.2D23C34
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C7001C000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=a269f39o;
	spf=pass (imf18.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738451;
	b=a/Db5s+hjU1S1wozMC/WBPo3ZiXn5ExJs6cXd550UrHOeXCmjFLbUGmv+UoVVjX+PWvgXQ
	TvoRZd84zyWOoy7EnM9+n+9uufr+s2WdePUlYn7/8zvd3enYpwwuB6yKzQnWI5RT3wlJ4J
	FH5x9Rzyt9FYHIVUu2cahxu9KodIFTI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBDPSugJUvIfnZFt1AXtvZwTdTLodNQ1FcaAm4R/gOE=;
	b=HZeFMq2pPEUhJLr3/GoQSSnlaxHIx1hnmt9ICf4NHodKrN0+x0RXZBsgl9xrn4blT1dsUn
	PvbLVVlh2cvgb6ndpKSlUx+qQT6Y/N6OCyTcK1XppORBh1fRgVEuZarm/h/DnXc9SKUusz
	ejwz+VcaWfIbG3hgyxWSt0gAjG/dHEw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=a269f39o;
	spf=pass (imf18.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qBDPSugJUvIfnZFt1AXtvZwTdTLodNQ1FcaAm4R/gOE=;
	b=a269f39ox2X1MkTEyXI82z8wRlh2JJbv7SBilR9vhgvdV6uTWvBdihcfse78JQYIlqynYIW5F
	E2XShrMwv0B62uSV2EBMVz/eH8zWz7eWC0+h8ubQLYc/rHkR7n0f5d0u1u+DXWnEfvHEbSxO0ei
	r7hDy9OeAn/yHuDDWTkavPM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gpmY16cFFz1prKM;
	Mon, 29 Jun 2026 20:58:13 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B76140579;
	Mon, 29 Jun 2026 21:07:24 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:20 +0800
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
Subject: [PATCH v16 11/18] arm64: ptrace: Align syscall exit work semantics with generic entry
Date: Mon, 29 Jun 2026 21:06:09 +0800
Message-ID: <20260629130616.642022-12-ruanjinjie@huawei.com>
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
X-Rspamd-Queue-Id: 7C7001C000D
X-Stat-Signature: h34h6zob5qaepttnu51eza7puzgnk454
X-HE-Tag: 1782738450-548264
X-HE-Meta: U2FsdGVkX19wiAF2G4DVqqP4JnHw462mYuVXc04coWs47pgOUSvT+axDoLIu95JI1MwGdTbsH+84UVut9ZpzfKOq6ACG9L18VY7HQulKToLdChtfQdt4l6J4hOdkAH8H6itzOHUNVRATPlpcgSgCj0osUPollEr8NuvL8kxLtothX4VaervqJ/VoAe1R3by1PJA08wPd96V5GspuafZiFm4XZtDyb0+FlqmVjX0hL1od8GCoWf0EyvVmBzsqjzJZERSVsQmrlM1ItYef1c9AF0LPDBaqwhTChnqJA8l6Pp0ZJXtp5wO77GoOJZCuqR0eABOcRo/PpjvxXo7OR2/DK/LJbRCe7DOzBTGFspzeRAGGHccDDUjiB1emybwBcCL9VJ4Etje5yS4Y2Drosaza+rmj70vb6eE15M9y5II/9Z2ANuDPEcs20HeuUiCDhuwhWHf31j6H6yNvwV4cHL9+/aw/6z5K6k3kFwDXEEkOi2N9uvXb/dPl5fL1Ep0o75J7BSS74482ZLrKzRE40TGy5IK2lbzZ0Apvvd9jyPNQIJ0qEjQYxBxbNmCtWZ2rp5GGW7LKSnjxQY9rUvCV5XPSyS2zEIhbKhY7ZwVTF3uyhBJCP+V7pDNXberyp76xE6JFjiBqiM52DIV63/q7LSdtThQpIIYAmEQH+YZfGl9ebT67oK1sPJkXcjNHoNyV6l7feNd6l1VytQCyBxxU4m45jPaLDFgR9g2kVLYurA3EIQiShxxY163qsiaaJRsb70IHyhoQ3Iwvnt7ZhKWsnOBEwGXuY/3hVn68cNO2g9Ds422dOoMewqZIQbYsDXog1CJy11j8oltfRjkOtAPXsjlVhhTKOWz7+qqQlemKjCkyQeVZx4iUhsKkN6F9ADvdwxons1pLkmnrKw9CB2LNXSpqxhq4aknbcQjCddwCyNzToXjeTu3J7zKCWLrvJl1iyop/63OanDJuoRUiaM3QimZ
 hVPNLTfi
 jm1LgbzAZ4glIkTsQa4xzCJorK3tDwceDA1Mz3UJTnRgc6NAmfhJTrRKujU7D02THNOMQSN/gAcjoO30JEjzv7csZc4vz6DtGJT1j6IWPcpNwMzQ2x+gkHUM+HTxIsr2Euspj8jJKLrC1nLNxZoCD2Wik2XmeoNwY52eqtVKWz6NyKrcECAjkaGwjS/nZQoTHQQfJ3/qnBt8vJ320LFVTIv0PsmxMh0csQrc+bBONjS2Rf/DCVVRa+k/tdSCmQ4Rl9R/0EtJmU0fVp3SZtMuqvor6WrZ6Ekn+6xH/nGRAZr7gi8x+MNlu1Nh4efIIFirT3urAFU++ercIEonSFX9TF4mv+G8kg9Av8blW3Ee8o8VH7OxnvDkAY7vPEr1zvzgItw5s84YEQRNMkQPMZ/La/qqhGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Streamline syscall_exit_to_user_mode_work() to align arm64's syscall
exit behavior with the generic entry framework.

[Rationale]
1. Unconditional RSEQ Execution: Relocate rseq_syscall() from the slow-path
   helper to the very beginning of syscall_exit_to_user_mode_work(). This
   ensures that RSEQ validation executes unconditionally across all exit
   scenarios, preventing it from being incorrectly bypassed on fast paths
   when CONFIG_DEBUG_RSEQ is active.

2. Centralized Exit Work Gating: Introduce the `_TIF_SYSCALL_EXIT_WORK`
   mask to aggregate exit thread flags and gate the execution of
   syscall_exit_work().

   Gating audit_syscall_exit() behind this exit-time check introduces
   no functional changes. The `SYSCALL_AUDIT` flag and its context are
   statically allocated via audit_alloc() at fork time and only freed via
   audit_free() at do_exit(). Since the flag remains persistent and static
   throughout syscall execution, checking `_TIF_SYSCALL_AUDIT` in the mask
   is fully equivalent to evaluating audit_context() inside
   audit_syscall_exit().

[Changes]
- Introduce the `_TIF_SYSCALL_EXIT_WORK` mask to bundle exit-specific
  flags.

- Relocate rseq_syscall() to run unconditionally on the outermost layer.

- Gate syscall_exit_work() via the new aggregated flag check to mirror
  the generic entry loop behavior.

No functional changes intended.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/syscall.h     | 6 +++++-
 arch/arm64/include/asm/thread_info.h | 3 +++
 arch/arm64/kernel/ptrace.c           | 3 ---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 72461c22bb5e..b982398f8765 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -8,6 +8,7 @@
 #include <uapi/linux/audit.h>
 #include <linux/compat.h>
 #include <linux/err.h>
+#include <linux/rseq.h>
 
 typedef long (*syscall_fn_t)(const struct pt_regs *regs);
 
@@ -127,7 +128,10 @@ static __always_inline void syscall_exit_to_user_mode_work(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
 
-	syscall_exit_work(regs, flags);
+	rseq_syscall(regs);
+
+	if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
+		syscall_exit_work(regs, flags);
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
index 9ebe3389451c..05ceb9f2d038 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -28,7 +28,6 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/regset.h>
 #include <linux/elf.h>
-#include <linux/rseq.h>
 
 #include <asm/compat.h>
 #include <asm/cpufeature.h>
@@ -2455,8 +2454,6 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 
 void syscall_exit_work(struct pt_regs *regs, unsigned long flags)
 {
-	rseq_syscall(regs);
-
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
-- 
2.34.1


