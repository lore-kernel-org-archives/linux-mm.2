Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B487C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24556B00A6; Tue, 21 Jul 2026 04:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC466B00A7; Tue, 21 Jul 2026 04:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E398D6B00A9; Tue, 21 Jul 2026 04:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABA3B6B00A6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C3B21C03ED
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:26 +0000 (UTC)
X-FDA: 85012084332.18.DA3C589
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf28.hostedemail.com (Postfix) with ESMTP id CEAD0C0006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XNnIFRMh;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8T3SbzD1h+RgSp3yBQ/VbQfpUd/mcH1iQ870xzewBhQ=;
	b=eq+T/FLlBke/1q6VgkktBcv9l+WrR7revEJRSVZ83rZBSlWYTLUKWTZlMznmfcLKEZNqx7
	WVhpfErTel0CbYIhxJ0CpY0pXl1R1ikBVO0F9LwcRCuHjrgnlYMPBlq5mJPGV4u1a1fFq4
	eYUMdp8EO0OIL9bjl/xGz8iYiXlaWfo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XNnIFRMh;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621964;
	b=vzdPs0+rLvdh6JcaS3w6WuCRndPRQ0fJX9kE3qFUj52wXy7D4b1dJlS4ets9BX6JY7XfFV
	p24kqI6WYYSn22efNEBr3Xpnovw5p5xTwhuy79Z6xAhBNFoKMbH673LRwekjPS+oTjJFc8
	w6EF07j1j4QgwhomC6/hYoit818/hDs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8T3SbzD1h+RgSp3yBQ/VbQfpUd/mcH1iQ870xzewBhQ=;
	b=XNnIFRMhLmbS0Tcl8aE6LZenU8BsoDEY6QOkftUcpa7z7s+VnU17Cr98KYYZhKBoc/TeTLBYJ
	cYKb6NhZyrS/KyaTkTf+1CuzVhHPFiRuYJ8JWHgqegmov+ixGsMN1tOUVymJNqorgoOMFcjMbUw
	o+pE6tIVdpI+Hv9ncW4JRq4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h495y0V3dz12LDF;
	Tue, 21 Jul 2026 16:09:42 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 7DFD040537;
	Tue, 21 Jul 2026 16:19:16 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:15 +0800
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
Subject: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso to the kernel
Date: Tue, 21 Jul 2026 16:18:58 +0800
Message-ID: <20260721081858.1169276-16-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Queue-Id: CEAD0C0006
X-Rspamd-Server: rspam01
X-Stat-Signature: tsnprqez9zzq9q8cfonbzpcr3ui8ekg9
X-HE-Tag: 1784621963-118867
X-HE-Meta: U2FsdGVkX18yb2MncQSU1Y+mYZXgbm1Di+hUioLQO/DutcenJowwLjsqF7v3K4cCXmRTZVD7/mgLZE5xfzPhD5NFgyZbhiIX2x7Ko9UXwczwaED9LBQFRoPpm9QRMvt7bHlaOtjEE7xnS7Y7zm7Jhz22N9UuocVwneBujwJ7dTkL0ybhA0AxjE9KqyZXPahGl4ZJ2SAuwisXt9vfpIABJAGjl7f1Z7lUVMjFzR6VSyYc2Uy1ObaPdo/gasYvj4Arl132AJqUnPe64rrQ6PjKTU2sgneNvPe0qugrWy4Xgxi5Nht4+Lf4s/xRl5hVv4GyUBfuk49EwIfIoMa2TtSbk3CLrLblgehD6UOKCksINcTlx/hn5RGEddgsfg+xKdXD5GUzPxpPZljb0PkFWz6qtJmCZInOYEg+Zmw6K92VxmZXIZvQPr39X5ggN7CPnFYJK+2HYAAUHqqu7AixN4uOhzt18dLvxh5XDdavOS4U60IEw4ZwRwyX5LisxQinoRcjsADDjn+jbsI6vIBUq0hhx22tgfzjBdd6+D1l9xgQM2sfFMRCDKrbgItj57u3BBf/tE9ymbO4D984rTXkHqoS3F/459E1NV7w1hgmZO8/zpqjpnL9CI+fmXYwzFw1uH7LnmKAqwmkpyWAtWKvHFdh27vjtaNZNzqf4bnya/fDb0EekEpouk8DS6be86AoRlzAAKb9tdoU5SjKrKzYt2LSvbxWO52bZUanju80iuXQD/9seq1ctlUN8nik6GSU5o10/2xyOpfh4Y11xgWpgKj6c3NOuf2Np0dSiF6K0IcG+8Tib3Zi1Do7615rShcvijTKds5nJEQrajGUzeKsBq/ba5qqQ3YfOdrDZOyX7XvaZrYgNuWM8GBh/I92yNiAoPB1vwbs25zc1rUTT4yEo3+qk3LFvr8CyG50FqsqSIl7EpCdt+tz5tqD3Xr8JqJZCrVWqUjFZD7PhvPI6wR5p63
 MbRYfTKc
 YPwh7rNutzXSXe+a+qfEQ+tguSyJlcl5mNtcV2AjlzqQeWQJL4+OQgCMaApHPxj11WRJ/DH7k0mB1UditUBTJk7j9PJ4/cK+8wkDy9KbTKhCxABJ7JvUg3+dxgbo12PiRxn1hA1JUCx2EPLGq+qyaIR1dqJAX1k+jCnGmH3d90rA1zsVid9g8p7tnH7K/z+T1nHfwb3CmCLQZnn8Sxa3KILpmC2Y5PPk0pK1A0bXpRCTroTcwWL9VrRYEQ2iTSqyOac/LHKcKtl0L4/jTlFis1IkKYXY7W9mj47BfuKIaWJtCnbhSyBp9fmoeXA27A1XIVGK2z6HBi7y7b2iRh7PRaSWiqEvUMLiKIys/Xg748gpmX5Frvg/ly4G4xfg7XJ0094qu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Syscall User Dispatch (SUD) must not intercept the signal trampoline
code, otherwise returning from a signal with a locked selector may
cause infinite recursion into the signal handler.

Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
to exclude these sigreturn syscalls from dispatch.

For native 64-bit tasks, check whether the current PC matches the 'svc #0'
instruction inside the vDSO sigreturn trampoline (defined in
arch/arm64/kernel/vdso/sigreturn.S as below).

	SYM_CODE_START(__kernel_rt_sigreturn)
		mov     x8, #__NR_rt_sigreturn
		svc     #0
	SYM_CODE_END(__kernel_rt_sigreturn)

For COMPAT tasks, verify that the instruction falls within the dedicated
'sigpage' range, since compat signal handlers use this architecture-
specific page (not the vDSO) for their return trampoline. This prevents
SUD from incorrectly dispatching syscalls issued during signal return.

Suggested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: kemal <kmal@cock.li>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/Kconfig                 |  1 +
 arch/arm64/include/asm/elf.h       |  1 +
 arch/arm64/kernel/vdso.c           | 16 ++++++++++++++++
 arch/arm64/kernel/vdso/sigreturn.S |  1 +
 arch/arm64/kernel/vdso/vdso.lds.S  |  1 +
 5 files changed, 20 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index aea686dce3d5..a41d2b593899 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -86,6 +86,7 @@ config ARM64
 	select ARCH_SUPPORTS_SCHED_SMT
 	select ARCH_SUPPORTS_SCHED_CLUSTER
 	select ARCH_SUPPORTS_SCHED_MC
+	select ARCH_SUPPORTS_SYSCALL_USER_DISPATCH
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index d2779d604c7b..a8b232c5c6d9 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -293,6 +293,7 @@ static inline int arch_check_elf(void *ehdr, bool has_interp,
 	return 0;
 }
 
+extern bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);
 #endif /* !__ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 592dd8668de4..37cdc7c72e15 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	return ret;
 }
+
+bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
+{
+	unsigned long landing_pad;
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
+
+		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
+	}
+#endif
+	landing_pad = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigreturn_landing_pad);
+
+	return regs->pc == landing_pad;
+}
diff --git a/arch/arm64/kernel/vdso/sigreturn.S b/arch/arm64/kernel/vdso/sigreturn.S
index 0e18729abc3b..8d2d413ff45e 100644
--- a/arch/arm64/kernel/vdso/sigreturn.S
+++ b/arch/arm64/kernel/vdso/sigreturn.S
@@ -73,6 +73,7 @@ SYM_CODE_START(__kernel_rt_sigreturn)
 	mov	x8, #__NR_rt_sigreturn
 //	PLEASE DO NOT MODIFY
 	svc	#0
+	SYM_INNER_LABEL(__sigreturn_landing_pad, SYM_L_GLOBAL)
 //	PLEASE DO NOT MODIFY
 //	.cfi_endproc
 SYM_CODE_END(__kernel_rt_sigreturn)
diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
index 52314be29191..da61d6fc6fe9 100644
--- a/arch/arm64/kernel/vdso/vdso.lds.S
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -112,3 +112,4 @@ VERSION
  * Make the sigreturn code visible to the kernel.
  */
 VDSO_sigtramp		= __kernel_rt_sigreturn;
+VDSO_sigreturn_landing_pad	= __sigreturn_landing_pad;
-- 
2.34.1


