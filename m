Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E369DCD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5036B0095; Tue,  5 May 2026 02:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB5E6B0096; Tue,  5 May 2026 02:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA486B0098; Tue,  5 May 2026 02:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB0F6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:21:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEF1A8C558
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:21:27 +0000 (UTC)
X-FDA: 84732369414.20.B581BBD
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id CF816140013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:21:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JO0QmeJB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777962085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4znkv+W5vuAGwYDPrkKlG4HbKRGYXv2X7CusMf1hFi8=;
	b=0i0m2SeDtFPq0ZWkUkiZG4EuXcrqn4bXSmZNCC8Bw0GL6aCVZn8Q1f3fwLMTklRZR10aBf
	Nl6pzGSwaMBNMhRBve+q1HoAHgauumgVDX45htf9LwbDyuF3hkHyf0CbfnTrCCvvXoGdcR
	MjRo7Ya+imznMu415KH6ud5DwR1iqfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777962085; a=rsa-sha256;
	cv=none;
	b=rqZqbiSQ82AMz8k5i9hY9TNj9/E5CnZoU7W0U/sU6+SXwQyrxuOx65FlnmXvGWijYgrZbP
	0rp+d7YoigO4oA6aXof7RfHxJ0Fi8uXtkYW3Gsh9X7sKdIq6r2mmYsXfFGwbNCKTEmb0la
	yVAana0m1rF4MYma/bN8m+cjl6qG/oU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JO0QmeJB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so3527049b3a.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 23:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777962084; x=1778566884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4znkv+W5vuAGwYDPrkKlG4HbKRGYXv2X7CusMf1hFi8=;
        b=JO0QmeJBHbXlbpkhNA0Fq6VhEftLaUr3iDqv9mVxX3NQu8uFj2T9MURCnSfDNLFpTe
         FiwerRVm6nsGZ3qBIHHlFUB9jQe7ipdWL8reYNDJer1K9CB4cs5rLdSC/HKKab8p/dYE
         mfzCkB98AiXnIO72a9Rn/eRYrylApRQU2EKRe+YrrKHeOti6HRcXT3PVReGdR40Ub0cX
         Rxun2Imik3AMH3Jv5DW0jG1MOiezvhOV45cHZBeuSehpDPE9O25RbrTxN6A6fXqredzS
         MGyVm1phiK3OfOILB958MlH+iSg0JatOPG7fx4BrtD2sbl3Oe75zRzaE7DYvrPZyNB+3
         2iDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777962084; x=1778566884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4znkv+W5vuAGwYDPrkKlG4HbKRGYXv2X7CusMf1hFi8=;
        b=ENP+/EpObxxGXDr2CAFZvfCEsOD9DoINCJ3s9Gkb3JsFcWvl4G/slPkJX6KbmGlYyH
         LKGPE9LiqUfJkzurF60/CEU+Q/4jWoAIA4PJ5booK13xutsHdk2G8158UraQdgFNSGU7
         luCOauTT6C0F42a5v197MMgBLqyisU2hXdXihxBF7v8jMyU6xArjqv9lMbn4t0SPx+J6
         6ORhrijFE4n6VmCVHN4OObd2IvmEopmVm99w6dhyjVgfXd1E5OGBpMBkzCgiBFc7ILp0
         wbDGUbLtcUuVfYfe/lQJMR3Ixxbnq03tTGbLbfwKEpSg0xB/7W68eA4N4ir4++hp9Itb
         WVxA==
X-Forwarded-Encrypted: i=1; AFNElJ/qgJrE7wIh7QR2MPHAWymjcPdsWTY2JkTiHWjA+5LU6sGQxMkCKbi9ua2jhhTmxQtf3SKluZPNeA==@kvack.org
X-Gm-Message-State: AOJu0Yyi/EbJLKAMOFeuiE+R4EPZcu58XbmOrNHtBPC2N9h/V6979Odu
	QQiS5NrS+VnJkohbLtQ23QeeEQDxhFMP1Wx8pSq0d2uaYUkQYWJ67TguFn5GO6LtxVd4a5Kz05A
	bS7xN0ng=
X-Gm-Gg: AeBDievZ+qHl+mngnDdHzsMDQ7FPqpn/+vM5EergY7hP0TwJxfgN0oRADIR59HLh54J
	rgbXN+d05FnKgzqMu+mybSQpiArf9DVMtnr4radJ769bLynivCs3EuO3iobUJhinmKPq8sJ8wlk
	2S8P7sZGm61ZpJb8RkmNVr3bqpOqugnyc08JPhcnTlZrod5AlohCcmmGlBAHQNF8Fq494j7J8/j
	6V96/Q5grl+vWFu+NwZsquW+rVxQ8Qftb9+NIW7CMo6eu6cM8PeUjnw1uva+d+kgJuk/ELSKq47
	Je5r4vgP4i6/bE9v5+A4NPn6dlHPBeipwj6jiRNo22qCQL4AomZxRJXT4xkt5ddBnThhOTcmuJV
	FSwfCKzob0XzuPe+auxuk30c20yBjIaRa+d7snWbCFznw94dIVVd2Rc+DAbvbgNQWy4nAEIcVuL
	gQeQHj+BcaZiF3/U5NQSpLNqtoMqDkK8dN4qQi7LvIUAMmUuTfCObbIIXG12vxVB8x
X-Received: by 2002:a05:6a00:14ca:b0:82f:721f:10ea with SMTP id d2e1a72fcca58-8352d1bf331mr13120000b3a.18.1777962084168;
        Mon, 04 May 2026 23:21:24 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c8c10sm880738b3a.37.2026.05.04.23.21.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 May 2026 23:21:23 -0700 (PDT)
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
Subject: [PATCH v4 3/3] riscv: store percpu offset into thread_info
Date: Tue,  5 May 2026 14:20:26 +0800
Message-Id: <20260505062026.91724-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260505062026.91724-1-cuiyunhui@bytedance.com>
References: <20260505062026.91724-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF816140013
X-Rspamd-Server: rspam04
X-Stat-Signature: edqx4rmdh4meshkpr4uo1fmr7s74ptk9
X-HE-Tag: 1777962085-441971
X-HE-Meta: U2FsdGVkX18rz/nxuQ9YF9o9HPE4v8Mx5YYEzmOPpzm85uFL9Y+Hepa/17bOcavAD4qLbETU7+wRE+VHjOPn6c2AJlttjB58feXYxTLI4W8yu4BL8ffZW4+o2j+fzgX+wTaLYY5D0sUkWAMT44vFGPrz4SQ774VZ8+gZpq9Xm5MabQ9iExQ5sAM9jP5BM81kcQq8HJ0Dg0Pz2SfQLtrxrTYs1zc4AXL4ahXlTTvPaxRwktnw4/enNHDkTBan8ukxuqn3lXYuETVTQ7mu6V3kdTPow6Lm3WtdKuMSjkNRI7ZNaReE86zy6PFl5hJTulf8cFbTon76xag5xVIDV9IUwhFp0YmelIhkkNVZWAl3fss8PV4HonwDCVUjYQ6DitzFxOcogcVQIJbeGeBiBn3Y/r8cToUnJLip0A2m27rDfgq4V2sLwUHz/hR2z8ehMRFqQNakFhBxLTQyq1vfH7yH6B8PPCTaYVJ9dKstwfHWolsZ3VQEwhekKO/JaLOdn7O9hkKtjnlLJDwRfYj/RvPDuBcc73z8iSHLIQskhSZ8+Pa6ruwrSimspl4fhxCgoTIxSYPbFs6oM/aSLN+hG03JDZfpYvLrpNBDNinOp/W9iLAlHqIAiMC+TF8V9nfpNdzKvrHwOAF6gDvfuK1vupL88lWOOPYYNrzmxdo1Cn0kjaXQQiuQ/IWpf7YqKh2a8w4uBmp3r4g+yw4s5Yxqry9XW6TEJCrqJtuOuG1c0sNkxsdzroSo9/D4M7qbRjEt9ty/kOXmrHl3JNKiD4wmwVCuU9IOhI+trxH8tx8PQhWqDcxev3AuWC3lnu0Bg+GaftyXhGIgmSHAIEv3bIQ0RGI5mKUgqBWBWR1ILpZdBr9ve+NRGDCNQUUvMb2E2hitbCIObwimPZ2atlYhxAZhUndhvZBOblHEjNBGNNy++eeL2iGp3m881ZDIMq1zuaagxHBsnSmr3zTgHGwvWp+hH8j
 QTnoGDkT
 4pGM0+ZEMZkbuRoPVJ+0oWQZuoS3o4NaxNLHZwlcj2l9ER8VqSa0EouEZ7yeECVoTEnwH2kv//B1CU3Psn02huqPjxTi6J2B3U/v0oFKAlZ7P6Oda7FXifpIdUWNWIEpVfnq+5DPO3gUWz5uQMNb/lR06ExgaEt0U5PLiB+/Oo1b8ixmxvVAw+Io95HIEHHWBi5XWh/CwovPqO1OX6w6ew/IM0VqK6V3I93PS5UFl75mjEo+boNYXo+nBl5AEhndjGFyuVkmvnqATpAoTd2eHpCfMAPGW+0kVqqdI5aYlHQW664ghlrgjAKGDf93C8PMa0Lf6SWZ5Qtz6KB+cQRBapYN1IBXvwKW1sbcSUx6q7qVFOiITFeX4Pv5wOLsSKfm2akDI/a3SvWc7Z3lfDC9vc97ax6DOjoPq8/hE1fe/ufJMqLYDuz0e4UsGgB0nCXEQG2UYltly4hWZIgzxD5Rh0DovHKtBaRuRnqjMcnMOImeMDI2xLtGElL2a6yEgB7H9IfCw5HZduQkfYijHYwBkjY6EPbjrkMHXt8fsj1pAW63ALL6lyVVBuXQFTV+e2y2TiNR3duhjNODHMKCJoshoFkFWqje8essfkNyEv1WW87rpRqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally we planned to add a register for the percpu offset,
which would speed up percpu variable R/W and reduce access
instructions. After discussion [1], it’s now stored in thread_info.

[1] https://lists.riscv.org/g/tech-privileged/topic/risc_v_tech_arch_review/113437553?page=2

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/asm.h         | 6 +-----
 arch/riscv/include/asm/percpu.h      | 4 ++++
 arch/riscv/include/asm/switch_to.h   | 8 ++++++++
 arch/riscv/include/asm/thread_info.h | 3 ++-
 arch/riscv/kernel/asm-offsets.c      | 1 +
 arch/riscv/kernel/smpboot.c          | 7 +++++++
 arch/riscv/net/bpf_jit_comp64.c      | 9 +--------
 7 files changed, 24 insertions(+), 14 deletions(-)

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
index 3b26fe45e70f4..84612d672105d 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -7,7 +7,9 @@
 
 #include <asm/alternative-macros.h>
 #include <asm/cpufeature-macros.h>
+#include <asm/current.h>
 #include <asm/hwcap.h>
+#include <asm/thread_info.h>
 
 #define PERCPU_RW_OPS(sz)						\
 static inline unsigned long __percpu_read_##sz(void *ptr)		\
@@ -275,6 +277,8 @@ _pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
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
index af827448a609e..fbf53b66b0e06 100644
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
index 8b628580fe118..41463a8400f6c 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -209,6 +209,11 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
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
@@ -234,6 +239,8 @@ asmlinkage __visible void smp_callin(void)
 	mmgrab(mm);
 	current->active_mm = mm;
 
+	__my_cpu_offset = per_cpu_offset(smp_processor_id());
+
 #ifdef CONFIG_HOTPLUG_PARALLEL
 	cpuhp_ap_sync_alive();
 #endif
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 2f1109dbf105b..177c19216013e 100644
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


