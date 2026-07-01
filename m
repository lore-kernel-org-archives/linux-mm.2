Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C32C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB946B00AC; Wed,  1 Jul 2026 08:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2F86B00AD; Wed,  1 Jul 2026 08:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3B36B00AE; Wed,  1 Jul 2026 08:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 369476B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:31:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACD391A0216
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:31:26 +0000 (UTC)
X-FDA: 84940143372.06.0649C47
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7912A180017
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:31:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ersdgPRU;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782909084;
	b=tRhiHWEvW7Wz7NcINkyZtPa2xXgWfWP1Uuye6RefmQ/FgRFT8QwDcAMdIOiRi8QuWAqDaA
	Sw1nMLzASHNfqSPvlyeMV+yEopJLIWrwhcbniQor4I3vvWPEVX+ell19kFSj5GjKq4PrwW
	8eC4/RRUwffU0udTAhxZKTTh5rY1v+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782909084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ozOi0zP0YCo4gvcHiUBENrr8lFpLj6Il3tmgGkxOaM=;
	b=jAXuJ5xzWJmJrESD0b00Y+VKcKvAYPQFkUkf3hA1lVrE3PpJ7oWLWL3oFzMjB92uyWUvYy
	YcIMb3cxHGf3qldNwrWU9/N1rAPVVSKlIyXHZrB+cHD4ggLtyMrHcBn3Z0jYnR0U9KuoGd
	CilnwaGneR2onl8Dk5/raLG94O0fZ7Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ersdgPRU;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ca265d6ca1so4158915ad.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 05:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782909082; x=1783513882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ozOi0zP0YCo4gvcHiUBENrr8lFpLj6Il3tmgGkxOaM=;
        b=ersdgPRU/MQy0Qn71jWmdvX92Jp6tUrUPxonqVAsnA8CY6OL/kcWlAdb2Mxgi40+J9
         eu9FKPF39RLzszi0nv16/GCsTi3nwJkDDWJ00PBMP8azWmsQYPUC0ilib1QiOCp0idtk
         dhgA2fvM3C4Lo0ZoDka4l+ajI1CVUrJB+Wq8E/miwev3lz54lZ/U+L4MImfjv/tc/k86
         z9opDHg5Fg+MoSShbOXlu3DPPvaBulXtilUhZmvFi/jPUok/Drc+0sUEp5RsNYcT8xWW
         n9vVMpbSEMCo+eW95Dxa7EUD2UEP8JIshIiPTDLJSFF9IZ15V0j65z0DGnEezWq/Zwem
         ZDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909082; x=1783513882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2ozOi0zP0YCo4gvcHiUBENrr8lFpLj6Il3tmgGkxOaM=;
        b=rKWOZyzLLflu6XmWn7byJCsRHQP/xiZTywaSJZV+EK9H7HpdLI6SmgcziEtWZaTepL
         cdh4BQ6dgxb8Nnrxov0f5qak8gte4rM9PkrgpflWY4COJhptXgjbF0DxyOYKycFg+pfW
         lrkWzoGVNABWDZ4sWYFrwObjtrSZvmOnXIwLuXQR8S3Sprsy+UzCIlO+mPMCZ1NLJczm
         mv1FAxdW/tcMediyFIPgwgorP5vahoutJxUKWyAtXQrfZ5l04sH04kx5b9saz9F6HC3Y
         n3wCm4NyGB/air9PViP71piTKgtL03qv+g45l+ADKsoXCnJlhx7pXJlbETDPCcKQ19GR
         c1fQ==
X-Forwarded-Encrypted: i=1; AHgh+RpAoTEc3ZZUAaIBO4Pd6UPfU1dPfE2BKnf4Q95sQmlMTOf6AmYIAJRNqUkoAc/FOuOyct7bDDuwmg==@kvack.org
X-Gm-Message-State: AOJu0Yx1LoysUzTlTtNqdWt2Jv5ooYQVrY60dR0C3tTDDw/nQss3alR3
	Y10GFrV8U+93Cyq+575EY/9vSvHeaVCtiLLE8N9MGVG3UNywfBVnR4Usq6rHcn8GHIk=
X-Gm-Gg: AfdE7cmZ2Ri6Qn1Kdrr7y33VM1SDYcVtw6h4gERKYaduaWUZUyzXzpRAf46wE7J9OHJ
	amKwhW1zbeWIzBiDM2wO+A7DUiKee1mU7cT1eTAmFbWMTpGs84g7YP5f3oiVjgVGz53oUZ52tzh
	D2r+rB6WhfQ1KCZl70dG1H2RgLtIz6BGpyQG+d4tviWTcJPm8R+PErXz8bwncXon1W0oOKmALuq
	uJStWErSbek7zLXBLeNM9+zYsvkxNi9U/jCsStMpRGjhvNZhngb7GAj6J27QaTK9cqPKmKah46d
	Y6ZzO/X88hfQT2THEi82pEp8eyZEben0qKdEMeFG0Y3X7h9mxF4REueeU8Z+CWNcFtreTPOz68v
	H7b6FNSvsah4L1vuHvfYQ+vBmE//iu85uq/Q4Rl9O9dD5Nq0lgNVJQR9JXfvZBsR+ft8ss8Jk2g
	7UiYDFYnMPgzn0iVQb9XA+wzLwBUV4sjaBXEb3EWOTPWEriw==
X-Received: by 2002:a17:903:2308:b0:2c9:4163:269a with SMTP id d9443c01a7336-2ca44a05d89mr50978625ad.18.1782909081630;
        Wed, 01 Jul 2026 05:31:21 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca4bae1e2asm25166825ad.73.2026.07.01.05.31.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 05:31:21 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	cuiyunhui@bytedance.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	conor.dooley@microchip.com,
	tglx@kernel.org,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v6 3/3] riscv: store percpu offset into thread_info
Date: Wed,  1 Jul 2026 20:29:48 +0800
Message-Id: <20260701122948.57584-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260701122948.57584-1-cuiyunhui@bytedance.com>
References: <20260701122948.57584-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7912A180017
X-Rspam-User: 
X-Stat-Signature: depgn47n5bfet9ucnj85pbws8ktqh5bx
X-HE-Tag: 1782909084-391634
X-HE-Meta: U2FsdGVkX1/uY5Nud36y4oomKScC9KxpCuMHapZ6o+vHthF75NuUPl+zTj7LTiwz20L70jkpM+CpWgOxSgOAqb/H6l17jA0hBljPLpNVwtqLbCMXu5YzwEBP0vthgYIE8L/8A3fK7WPAsmxOF+xS7d/vgRbtEaqBOLKEXjeInMsWXTf0ePmvZVI5sEal806t21Pquq+2UJ7XhOb7/bRLkodhbTOEc0iPQpO7XXCbJQYqSQiLQ3bk0TcwZ5SZnEuBhAxDq7ceWOs8mjauYAzFGdgI7XVICChEagm+P2OQJrZZNM8eaSQ1VCq3PA5AO31Jmni2QPzHLlMpNSZHad5lkfhvzaYUvDwF9PGYd87XSHSbrqe3xM6hWCbue0Zq1GtANrzt6iYIZdCkFLpjb4xpKlSe4Bi/f6krZZzh46OA2lewT8a4uPSIJZIgsEL14YPgH2mePXKB4dOgdVHVpSqQ5GGPmSqb80ZZ7T5Tf6/cHtI8he+SxQu2gh0GXwrVMHXwsCuuRrC1OuNZWf7UIs8+vm/NhvWZyXq/9Rz4UngVeG/VarutuA500NW3BdLRBw3H8kt0u7k1WSUh4Px9F+TKCGukTaLZ8N1txIpKc9aia5Zq44mbpeYtB9dN/ThRqx8embsufLveSQH7iFnVrL44AqLS4oXYhvRdzcFcJGvrGE8dGLIOKv+WeWKvIX66+5Wgk+jeTxBjdsMI8JsqxBtreIIO/cqpRWFGUx4Euo1+GuzCxawVkp9xthyUQ3xeAqDU1nsZYBFxzsQiC1rYeJpuw3lPAp+MoPagwkhvlbDCmKRQlbcWpmEDZ0RZnZKRYxJ15hIC+KZIehfnB0zHTujtcpk70nHz606G0j2ywTbZO2XIJU2uKFgA1UxOMwAY+teFGRXAu7y+lOY4qihAeZHbO5GvGtgu1MPPQUA46eZQz63oLK5uIa7NxkNDKCrOTgyVvX2QUaLmdEEDYDvDCAz
 Y8j9GGBS
 caQ++01bgoagjNBqH+PVbBUSNDunUnTKo/9jF+qLaIc0nqrnjfQvdzOTK1SE30pimzGaKxkSz6WlaeoZyy+551sBuVESyPPzsbl15zmqUfHCOnf/SQVOSeSB8Sgs+RHimp8v8GfrAaQe6PTpbNa6ik54ei2aFyn43q0+MBlZgf5qvQsNNiWPRM250qy7gALAYwPUMKxbjjXdLckWs6VurXYfzIy2TWmYGaArke1pTLyAKrRTYM3A2sEaipF1ZQ9dGVsW1bF/jC4eDnT/kjSATw5m8HTn/vIFBqF9pZ/O1iSyR7Mh9FAwB5rdYK8yav/IPpfhcezpzLP0PuG/DgTKvjNz++SEHDogtDj3IHjvvEDa7Nqb/YaDVwe7OUICNvQWDmOXLx4i0lWPVVflDiDHRwbeyWXdV1el0SpeVJazH5TDy2QcXMEKfs85ond28w3Nsovzw+YLjfyT8X8er2C20eZd8xDFoD1tKXUaqjQsOyEumM1YQ4gbpPx5xa86U3K1TqPQoHOFlAJelWOhzvzD1STRoWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RISC-V percpu addressing currently derives the base offset from the CPU
number and __per_cpu_offset[]. Cache the current CPU percpu offset in
thread_info so percpu accesses can load it directly.

Keep the cached value up to date for the boot CPU, context switches and
secondary CPU bringup. Initialize secondary idle tasks before they start
running so early percpu accesses use the secondary CPU offset rather than
inheriting the boot CPU value.

Link: https://lists.riscv.org/g/tech-privileged/topic/risc_v_tech_arch_review/113437553?page=2
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/asm.h         | 6 +-----
 arch/riscv/include/asm/percpu.h      | 4 ++++
 arch/riscv/include/asm/switch_to.h   | 8 ++++++++
 arch/riscv/include/asm/thread_info.h | 3 ++-
 arch/riscv/kernel/asm-offsets.c      | 1 +
 arch/riscv/kernel/smpboot.c          | 8 ++++++++
 arch/riscv/net/bpf_jit_comp64.c      | 9 +--------
 7 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index e9e8ba83e632f..137a49488325e 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -91,11 +91,7 @@
 
 #ifdef CONFIG_SMP
 .macro asm_per_cpu dst sym tmp
-	lw    \tmp, TASK_TI_CPU_NUM(tp)
-	slli  \tmp, \tmp, RISCV_LGPTR
-	la    \dst, __per_cpu_offset
-	add   \dst, \dst, \tmp
-	REG_L \tmp, 0(\dst)
+	REG_L \tmp, TASK_TI_PCPU_OFFSET(tp)
 	la    \dst, \sym
 	add   \dst, \dst, \tmp
 .endm
diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index 34483253e946f..52926c27f1f00 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -9,7 +9,9 @@
 #include <asm/alternative-macros.h>
 #include <asm/cmpxchg.h>
 #include <asm/cpufeature-macros.h>
+#include <asm/current.h>
 #include <asm/hwcap.h>
+#include <asm/thread_info.h>
 
 #define PERCPU_RW_OPS(sz)						\
 static inline unsigned long __percpu_read_##sz(void *ptr)		\
@@ -279,6 +281,8 @@ _pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
 })
 #endif
 
+#define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
+
 #include <asm-generic/percpu.h>
 
 #endif /* __ASM_PERCPU_H */
diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 0e71eb82f920c..733b6cd306e40 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -88,6 +88,13 @@ static inline void __switch_to_envcfg(struct task_struct *next)
 			:: "r" (next->thread.envcfg) : "memory");
 }
 
+static inline void __switch_to_pcpu_offset(struct task_struct *next)
+{
+#ifdef CONFIG_SMP
+	next->thread_info.pcpu_offset = __my_cpu_offset;
+#endif
+}
+
 extern struct task_struct *__switch_to(struct task_struct *,
 				       struct task_struct *);
 
@@ -122,6 +129,7 @@ do {							\
 	if (switch_to_should_flush_icache(__next))	\
 		local_flush_icache_all();		\
 	__switch_to_envcfg(__next);			\
+	__switch_to_pcpu_offset(__next);		\
 	((last) = __switch_to(__prev, __next));		\
 } while (0)
 
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 55019fdfa9eca..f10ba62b61016 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -53,6 +53,7 @@
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int                     preempt_count;  /* 0=>preemptible, <0=>BUG */
+	int			cpu;
 	/*
 	 * These stack pointers are overwritten on every system call or
 	 * exception.  SP is also saved to the stack it can be recovered when
@@ -60,8 +61,8 @@ struct thread_info {
 	 */
 	long			kernel_sp;	/* Kernel stack pointer */
 	long			user_sp;	/* User stack pointer */
-	int			cpu;
 	unsigned long		syscall_work;	/* SYSCALL_WORK_ flags */
+	unsigned long		pcpu_offset;
 #ifdef CONFIG_SHADOW_CALL_STACK
 	void			*scs_base;
 	void			*scs_sp;
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index a75f0cfea1e9f..20d46c28fdde9 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -38,6 +38,7 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_SUM, task_struct, thread.sum);
 
 	OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
+	OFFSET(TASK_TI_PCPU_OFFSET, task_struct, thread_info.pcpu_offset);
 	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
 	OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
 	OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index f6ef57930b50a..7876854d16279 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -191,6 +191,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 	tidle->thread_info.cpu = cpu;
+	tidle->thread_info.pcpu_offset = per_cpu_offset(cpu);
 
 	ret = start_secondary_cpu(cpu, tidle);
 	if (!ret) {
@@ -208,6 +209,11 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 }
 #endif
 
+void __init smp_prepare_boot_cpu(void)
+{
+	__my_cpu_offset = per_cpu_offset(smp_processor_id());
+}
+
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 }
@@ -233,6 +239,8 @@ asmlinkage __visible void smp_callin(void)
 	mmgrab(mm);
 	current->active_mm = mm;
 
+	__my_cpu_offset = per_cpu_offset(smp_processor_id());
+
 #ifdef CONFIG_HOTPLUG_PARALLEL
 	cpuhp_ap_sync_alive();
 #endif
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index c03c1de16b79a..eab93d5258e9e 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1395,15 +1395,8 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			if (rd != rs)
 				emit_mv(rd, rs, ctx);
 #ifdef CONFIG_SMP
-			/* Load current CPU number in T1 */
-			emit_lw(RV_REG_T1, offsetof(struct thread_info, cpu),
+			emit_ld(RV_REG_T1, offsetof(struct thread_info, pcpu_offset),
 				RV_REG_TP, ctx);
-			/* Load address of __per_cpu_offset array in T2 */
-			emit_addr(RV_REG_T2, (u64)&__per_cpu_offset, extra_pass, ctx);
-			/* Get address of __per_cpu_offset[cpu] in T1 */
-			emit_sh3add(RV_REG_T1, RV_REG_T1, RV_REG_T2, ctx);
-			/* Load __per_cpu_offset[cpu] in T1 */
-			emit_ld(RV_REG_T1, 0, RV_REG_T1, ctx);
 			/* Add the offset to Rd */
 			emit_add(rd, rd, RV_REG_T1, ctx);
 #endif
-- 
2.39.5


