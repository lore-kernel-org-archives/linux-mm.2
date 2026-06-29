Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11E5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9469A6B00B7; Mon, 29 Jun 2026 09:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DBF6B00B9; Mon, 29 Jun 2026 09:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7976B6B00BA; Mon, 29 Jun 2026 09:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48B156B00B7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:06:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD70D40690
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:06:54 +0000 (UTC)
X-FDA: 84932975148.02.1BEB442
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf07.hostedemail.com (Postfix) with ESMTP id 59E6840002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:06:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=K5W+RbBF;
	spf=pass (imf07.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738413;
	b=f4T/+ToqGISqsG04uQBKT2UABamg9a47X8U2Ylsqm2lKL+F8CNx2HL5hcrB1CMvKnhwTkq
	O4aVFvhywk4tqADrI04f2fzNZPbpZt1hCXkdsE5sdTEe+HcDpMunWxqYu7MhVZ0HbMLKKL
	VIW8KuvLdZJdFpJofoCI9eoOJ8GrgIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QajGHSeELTeFwAo2Vi+cAigxNZFa68v7esARJOfEGL8=;
	b=q8jaAmSxSclWR44JrpuBfz/lWgH4W7jDsWz8OvzJfDnFB7XWzwjnVWDx0Fyd3+i81vNFuM
	oFh349931pFNKi5uDJCHKgvrpafh/8QQpIXnfJ+j+6rUQdWA+RlunMyMn/swnlptduTtcd
	lrSbVWAd8lLybxFuf54H7RwimvV/T8k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=K5W+RbBF;
	spf=pass (imf07.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QajGHSeELTeFwAo2Vi+cAigxNZFa68v7esARJOfEGL8=;
	b=K5W+RbBF/b3OBpG5ddsT3bmnCLBLEzgyzzh300maR3q5Yzre6htvRd1h62EH0Qq8ZRLKiCyVR
	7x2r9MGY/Q4YnrsdD5+L1K+xmcJorhcRgEsexa89co6ktYK7W/JX4y7GLJ/9v16AQNEERwnh96q
	DwurhrJk6XJseic49PmwfnU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXL50GLzLm2Z;
	Mon, 29 Jun 2026 20:57:38 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3797E40572;
	Mon, 29 Jun 2026 21:06:47 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:06:42 +0800
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
Subject: [PATCH v16 02/18] syscall_user_dispatch: Introduce a weak fallback for arch_syscall_is_vdso_sigreturn()
Date: Mon, 29 Jun 2026 21:06:00 +0800
Message-ID: <20260629130616.642022-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 59E6840002
X-Rspam-User: 
X-Stat-Signature: 1tce4zrqw5cdktarnickcjw8ie6o3brf
X-HE-Tag: 1782738412-352138
X-HE-Meta: U2FsdGVkX1/MXuwWkK9RwbHAmA53NEgrW68FsPBOy4uWXYPqoIvdHYaKnQObZXjAnq++Z+4V8WDuijBcEy6kHKEVMA1BZ6ypXlpydBsc87V7D2aJCOs69ZAD03u1hgrfwbNP/8dDyaFadW5n19wkMqyWOY5Yh7ex2987CFoBz5HrUXQ4oBFhi8dYc8p8LMDdLTCsyOdFOxgs18Jg7amnOB9a9IlrMZ91G/3CiJ8xN1yy68vjotzfnT2YZMizsdZ44978XM6sJo2i2Yn/UqtZHGfD5kK1bTg2xGonPjawQQLzAFDY4rOk7cjKOyLXfUeuvLyREUYnqJwDDsQM6q5CQ8cnFTS3T2DOSmIiEku7qRNw36+8YiWgOlapN6MFkb4K5/Lrb4LmOsR0HB+eBHYPgXYXEFle4LnH3vFJDMeKuAPsbtNUXBsZYxS7i6FnKqcsSHiyJ5g76+fWNlfDZ4XHn+61cWD2gsvE953cmVOIsZFx5LEXJBAmUkjUBxaLkhEVTDRmLSpTVW02qKrdlZHWJlsx37mrGM/+cDMlQO58e7YzVjjun4916pZej5RrfDhjFppdWmQdOAdbD07x0mLKnVe+e3HmKHbWokKMyVk9/69Yjyqzu2K9f8y8YwDDkKUDzXOfreYpZHOXpCc0AHQJRvuqY2IaWMbgNRBbKyfxTh3gPUqfUNFP9h0h/p51a8Ab3VJp3MvCIfb0aUe5HUYittKRfbsAke48WUy6HyXBj1t7By3RnmqyM6GSD84oxZ/4F9UJlZKonHMCUGPLT1S8gnEEKA2vix5iOLk2/4NxdMYI0Edospx3xyK6KVC5hpW4W54EPoPce/uBBBzMN5eaaP4Io0mUdSBPcXP88Dr9lrhGKqWkr9UB32f+f9PZXBZ+dQCwC+7rhui4XLsMofpfkZ05JxcArS0eznuOaofg3jCZcL4KBL8rcLn4FUs/6uMoH3KXbWjxIKnGvCSefNH
 FecqklVP
 lWcen4dbS0efPVIGg7z1NvYVHkq4MMR/jb20lU84JoqSuMREcpKj27cc3SKGww0mrtMyPaSZQk2bKXzK36NZ6MLNI7npih+5fX1tet23uWRfJZfiR3sa2k7qpAew9G2aEaviy19T1w7R5A0HEtuUBhM5JXuc2nHtZgUillU33R/ZC4z0Wap/Sf8ePyF7QEkKWwf3ZlIIRZ7ODqmRdWX9f4Ec9I9vNHfuaR1AqeKXIdktI/0ktxkUvxriDpxLNvnLxyV+8BbokuXopQSrcxvmYpckJDWZPEwqXHjoOm0uor9xqr6RX0x/VOvbTed+pyD/Zqu1vnVqTv5UyUf6x5p+ue5mP4yQAui65tBFxVh9pBKKxNoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, multiple architectures (LoongArch, RISC-V, S390, Powerpc)
provide identical stubs for arch_syscall_is_vdso_sigreturn() that simply
return false. This results in redundant boilerplate code across the tree.

Introduce a default __weak implementation of
arch_syscall_is_vdso_sigreturn() directly in syscall_user_dispatch.c that
returns false. This allows architectures that do not utilize a vDSO
sigreturn to entirely drop their redundant inline definitions.

Architectures requiring a specialized check (such as x86) will continue to
override this fallback with their strong symbol definitions.

Clean up the redundant implementations in loongarch, riscv, s390
and powerpc.

Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/loongarch/include/asm/syscall.h  | 5 -----
 arch/powerpc/include/asm/syscall.h    | 5 -----
 arch/riscv/include/asm/syscall.h      | 5 -----
 arch/s390/include/asm/syscall.h       | 5 -----
 include/linux/syscall_user_dispatch.h | 1 +
 kernel/entry/syscall_user_dispatch.c  | 5 +++++
 6 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/loongarch/include/asm/syscall.h b/arch/loongarch/include/asm/syscall.h
index df8ea223c77b..946886794ced 100644
--- a/arch/loongarch/include/asm/syscall.h
+++ b/arch/loongarch/include/asm/syscall.h
@@ -85,9 +85,4 @@ static inline int syscall_get_arch(struct task_struct *task)
 #endif
 }
 
-static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
-{
-	return false;
-}
-
 #endif	/* __ASM_LOONGARCH_SYSCALL_H */
diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 834fcc4f7b54..4b3c52ed6e9d 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -139,9 +139,4 @@ static inline int syscall_get_arch(struct task_struct *task)
 	else
 		return AUDIT_ARCH_PPC64;
 }
-
-static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
-{
-	return false;
-}
 #endif	/* _ASM_SYSCALL_H */
diff --git a/arch/riscv/include/asm/syscall.h b/arch/riscv/include/asm/syscall.h
index 8067e666a4ca..987c9a78806f 100644
--- a/arch/riscv/include/asm/syscall.h
+++ b/arch/riscv/include/asm/syscall.h
@@ -112,11 +112,6 @@ static inline void syscall_handler(struct pt_regs *regs, ulong syscall)
 	regs->a0 = fn(regs);
 }
 
-static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
-{
-	return false;
-}
-
 asmlinkage long sys_riscv_flush_icache(uintptr_t, uintptr_t, uintptr_t);
 
 asmlinkage long sys_riscv_hwprobe(struct riscv_hwprobe *, size_t, size_t,
diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index 4271e4169f45..5f310caad1fc 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -89,11 +89,6 @@ static inline int syscall_get_arch(struct task_struct *task)
 	return AUDIT_ARCH_S390X;
 }
 
-static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
-{
-	return false;
-}
-
 #define SYSCALL_FMT_0
 #define SYSCALL_FMT_1 , "0" (r2)
 #define SYSCALL_FMT_2 , "d" (r3) SYSCALL_FMT_1
diff --git a/include/linux/syscall_user_dispatch.h b/include/linux/syscall_user_dispatch.h
index 3858a6ffdd5c..73d69e02807d 100644
--- a/include/linux/syscall_user_dispatch.h
+++ b/include/linux/syscall_user_dispatch.h
@@ -10,6 +10,7 @@
 
 #ifdef CONFIG_GENERIC_ENTRY
 
+bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);
 int set_syscall_user_dispatch(unsigned long mode, unsigned long offset,
 			      unsigned long len, char __user *selector);
 
diff --git a/kernel/entry/syscall_user_dispatch.c b/kernel/entry/syscall_user_dispatch.c
index d89dffcc2d64..acf545774d37 100644
--- a/kernel/entry/syscall_user_dispatch.c
+++ b/kernel/entry/syscall_user_dispatch.c
@@ -32,6 +32,11 @@ static void trigger_sigsys(struct pt_regs *regs)
 	force_sig_info(&info);
 }
 
+bool __weak arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
+{
+	return false;
+}
+
 bool syscall_user_dispatch(struct pt_regs *regs)
 {
 	struct syscall_user_dispatch *sd = &current->syscall_dispatch;
-- 
2.34.1


