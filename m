Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B89CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668C46B000C; Sun,  7 Dec 2025 22:50:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640296B000D; Sun,  7 Dec 2025 22:50:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5561E6B000E; Sun,  7 Dec 2025 22:50:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 438C86B000C
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:50:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C39A613BEDC
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:55 +0000 (UTC)
X-FDA: 84194927670.28.758122A
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF7414000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IveQuWAx;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765165853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFr5RgkhvM6EE5Q/RHn3oG8Xllt/H7Gtrl4Nvhbq1ik=;
	b=EYOaGzimKBjDsR+O1mxIJm7YcRG9KoYMMkpeVuk2sRyQ6v3iChbUukdHLP+xVTvDsRSMam
	6nlGRWvzOBLpRdAzxQ7Gnv+o/E6dvL505IY405Oe8MJIAhOTAO++f++eZ9glCFBZazCMR8
	8jcgFekgR6QAHypQCQRVwPETs8ZluVo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IveQuWAx;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765165853; a=rsa-sha256;
	cv=none;
	b=eElz7Hctje0D2h/ntubYjw6tYPS+Pgc2u/VNDD0D6rUtNLRcehQI/cEpCuH35dX3VSSY8B
	oHK1sKi3tX8xhdvtlFo1A1jBXuQXRRRxaWzEENRxYRGAwK2x4wdH7iHzW7anbSiTxhqdCy
	LXuXB0bszKdoC5bBJq+sGZtnSxORzyc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-298287a26c3so52937395ad.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 19:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765165852; x=1765770652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFr5RgkhvM6EE5Q/RHn3oG8Xllt/H7Gtrl4Nvhbq1ik=;
        b=IveQuWAxTqJDd2Xy7yvVX0N8A5aUrz9admv/H8WDxtFRXGx84UrrEFKQUhf8acUBBA
         Z40N+kju5l1oSGvtnEZGzDvSHBW4lh+5IDHw/UasLWmwyl+8yzFHHCq57NXrtykbIPtE
         llV2E+XMTe1e8f6+izdZxawd+aPpeJlIFgZw8TgKJw8r57zmXESkkE9ausrRsmCMN27a
         txIkvnfNh/VCAjkEFcLLDnhER0eggJc9+jIeWsVgixO6F6aQQMbvKvAFItknvov4gadf
         OP7I3OwezG7LZ0KAcpxMvDNZBux9Xu8MaRy7dwkptLU+Y0ra3x3sSZaWCVGnHRAq0y7t
         LlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765165853; x=1765770653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xFr5RgkhvM6EE5Q/RHn3oG8Xllt/H7Gtrl4Nvhbq1ik=;
        b=IQVic3f7zcG5Nq+hAy39Q1nw0AGdefnXXBdl/lOsyN814sw6RqhSj06OyzEC+BuQFF
         Hhk0Otb2VbU3+YbEMm3PpNLewN3FtHAt6QEZET3tI0x8/7QpQfJwM+EF51Fx/XAwgNdV
         tIalHhtdBCduy+915FKnkDn0alvcLqTAG2jYbwggN+3x5QzECWx3V9qePhRfuya5T/xW
         OLHq2UJvVP/2fRIi0SJT2SSg17GyhKFnKnntKAZ2HiDB8teTpVmNbHOcNx+soGhSmN4c
         yoaWwWoNEikkr6y6WBiyJF9VVXuSDhV8DWhUMtCKVWFiPkcmgybhBaeyYKVMmj3j4Obp
         xuRg==
X-Forwarded-Encrypted: i=1; AJvYcCWkJJiw/6vsBgxYMi5vcDfFfi+KdRNDBDy/dDxuKo6tw70ooUCv6g1mBUiCdu8cBz+fW1fPmALbEQ==@kvack.org
X-Gm-Message-State: AOJu0YyHfApIMQUaX5YmFl/JNfnv1AuPdUh3tjO+RhGtvp6tR8gcjlOs
	garHHE/TgoIgQXefIWSS+D8WiUdk1A4VYyPUbaf1/FMDnVOxpvBS3qZloH0FbifRKm4=
X-Gm-Gg: ASbGnctzigikMJgWqUfgD81zl851lBQ0KsipWUwbD4j6y7aqae/Eyi3P0Z6k7MsEsvZ
	X6jM2LHpiT9reoQ0D4locsIwhHMa1G5sBcuawBm1xeVqQIEhlNWatnw3mzveBMUtV0zrF7X7Wi5
	UInQ5mixFf5vL8J3zXV6CjZATxSJ6AudpD/yKxuP2QeWx0WdkDSC+z8SVxnb1J3fO/+jCivvqGC
	8NKrLfTqpIoQ19gsbRZrI1gM0QQEqCsY1K/88/Z/0CQpVbSw/9b9sLBDBUa6WtxjYk6CyZWRET8
	R4OD95vFSoFGjS2VZci7nfTZvw+jQdCVvsG6uCqAC+oU9qOr7mTR8MAiHzJij+K4qCnWqz5GP1J
	UQzdja470ccnfFvRMSIfbk9G6kzs006QUTY/0akZCJwpWh/0p2T1gaPPX9NJO5TfE8nI4QonUbK
	X3KQob90ldEWEUyhsiEig3vd7TTlXgV2yrD46ssOd98K6h
X-Google-Smtp-Source: AGHT+IGvReM+D+IE845FajcK0U2ifqJXm74OcYy9I6WIlw3gQeLkhNJjnOwLKfKhujYanWqb2gK1OA==
X-Received: by 2002:a17:903:15ce:b0:299:dea1:e791 with SMTP id d9443c01a7336-29df56772d0mr53566285ad.12.1765165852442;
        Sun, 07 Dec 2025 19:50:52 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6d96sm108871275ad.102.2025.12.07.19.50.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Dec 2025 19:50:52 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	andii@kernel.org,
	andybnac@gmail.com,
	apatel@ventanamicro.com,
	ast@kernel.org,
	ben.dooks@codethink.co.uk,
	bjorn@kernel.org,
	bpf@vger.kernel.org,
	charlie@rivosinc.com,
	cl@gentwo.org,
	conor.dooley@microchip.com,
	cuiyunhui@bytedance.com,
	cyrilbur@tenstorrent.com,
	daniel@iogearbox.net,
	debug@rivosinc.com,
	dennis@kernel.org,
	eddyz87@gmail.com,
	haoluo@google.com,
	john.fastabend@gmail.com,
	jolsa@kernel.org,
	kpsingh@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux@rasmusvillemoes.dk,
	martin.lau@linux.dev,
	palmer@dabbelt.com,
	pjw@kernel.org,
	puranjay@kernel.org,
	pulehui@huawei.com,
	ruanjinjie@huawei.com,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	sdf@fomichev.me,
	song@kernel.org,
	tglx@linutronix.de,
	tj@kernel.org,
	thuth@redhat.com,
	yonghong.song@linux.dev,
	yury.norov@gmail.com,
	zong.li@sifive.com
Subject: [PATCH v2 3/3] riscv: store percpu offset into thread_info
Date: Mon,  8 Dec 2025 11:49:44 +0800
Message-Id: <20251208034944.73113-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20251208034944.73113-1-cuiyunhui@bytedance.com>
References: <20251208034944.73113-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5aiz4gf4ptn1jntxxgkfyhupkp83bqie
X-Rspamd-Queue-Id: BF7414000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765165853-410116
X-HE-Meta: U2FsdGVkX1/z0TlAp5F/WNq+DooppfdjjUV7j9NvxSw5/eUcIH43yr6KtZsKnM0MATq0Ih9ENLNrIFMqV2X4dP05CtlYWP3YVLKq6995lqvjYJYEnEjORXyyZhlzUMnjh7Oj1+Vrtmm6ZkO+rTKEG7Ty7vOpcmwnV0o0Ce1JwsaMdlIiMFC/ofOxug4K9Qhh7/XeNeNhI5slYDFbashiNgRLfUKq76THVJZ++LtA2gMsCJl3soQoyRkuIE952hc80r6W0b8wb1cLQriR6qt+vUbB0RptUkaNEFxafx2UO02ZfxkVA2GHZjP3JJBf2iFvRD13m71WRg4MtCX13FtKBB8+t9HcmL5DCclkW8vdr18ukT+cJrTp5Pg9+qNd7QrqRxgnjWNE/o0VVem4034pD0gHeJKyiYh0EI0VdkIvBgBje6VlsqgdKJXR+Ajq3y+e6jyuM9VmG7AZ6vFQlJisbnJUnqxaOFflQrcN9sjIMoWQATb2lYs7BZzTdz2ymFrTL0neP0txTWdAGDFpDDzYhveqZauMxk3hZVnYcYT6102Di20J6ZjeeEMUnj8ZhI1WLN0KsV+Jm/NbFd1/ksRmbKbaKyXWZRwSApmgs6NkHFOe+jR3N0Ok8aR08ROeV1N+pg0QKZyDDPLL1l6ckxoG+EW84uIsBW38JUIeYf5Wie3KpSQqCEeitAos0qvfrPH5FctS8/x1jM6AEd8K4tLn4iOaCN/H5CiRxVzKmxc0M3Pj9Tivrz4Bed60sDOugz8UJDSnN4DcNHYJGtppugbUtXgeSzcO1Fq77/JOoqYta0ZhpSvY0CVHn0qKwb24DyFZ4uhvbHOdRHHbttFEbDnHOaV7472sMtM/ysmtYQ6GcYAwCLQI35jxspiXy5Vo/Q9WHlPBeXXNFivfcPhQaRb9bI+2mrtqNiC0Q4JeuyBttgLi4KKiO1ums4aV3ZhRA/wZTQ4qs7C0Skc+dE0efmu
 RM1s/7d2
 vO7Gui7Sk1UQvvXx9OvKGosAwnrmj2Xu5cEpeN/xLi+iUzTBUUABRx8eo48NSJT6q0j/XXVA6a5JNKB/Dsn6E+/xkJ7YLX6zP1/4f2QJLV/YrpwpbRULpBWxb6vDfARFi6/LKmGCnyXtnsE4AVTXcuctRF9nG0TdzqnjdlFdnbhAQPp3M4BPvOsMtTQO3CfmyCpFqn+dsxDveB7tJcy5x/mq1u8+fIhv9q+h74vV3xza4EO+IyAqU70s+HzmeoBVmpaYUXW7YfrqYaYKoEdB8ZwKGrAJRbaEZDZxgtZrtLW2CBRbKFy4BsE11K0dTBW1fRC0a52g+DnyLE0nVSI9msW7pA+vdbiuLPpZq3ieBSkDdrFETgUsPazDF5gCgk50KqL6zHA0u+7Z3qK1qZxIpxPOMwcul9r/DfrqtOaca4eUaWAvhspCUEm85nrYSnB2PCiW4FYr7HNwKji4dFk2ius+sT7i/DKaeOTjTnUkdzF3jdgXBoiv/bKbt1rOuOhlqT53nvT/HOMr5C3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 arch/riscv/include/asm/thread_info.h | 5 +++--
 arch/riscv/kernel/asm-offsets.c      | 1 +
 arch/riscv/kernel/smpboot.c          | 7 +++++++
 arch/riscv/net/bpf_jit_comp64.c      | 9 +--------
 7 files changed, 25 insertions(+), 15 deletions(-)

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
index b173729926126..18e282dded626 100644
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
@@ -233,6 +235,8 @@ _pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
 	ret__;								\
 })
 
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
index 36918c9200c92..8d7d43cc9c405 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -52,7 +52,8 @@
  */
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
-	int                     preempt_count;  /* 0=>preemptible, <0=>BUG */
+	int			preempt_count;	/* 0=>preemptible, <0=>BUG */
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
index d85916a3660c3..9e95c068b966b 100644
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
index 5f9457e910e87..4a492a6a1cc1e 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1345,15 +1345,8 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			if (rd != rs)
 				emit_mv(rd, rs, ctx);
 #ifdef CONFIG_SMP
-			/* Load current CPU number in T1 */
-			emit_lw(RV_REG_T1, offsetof(struct thread_info, cpu),
+			emit_lw(RV_REG_T1, offsetof(struct thread_info, pcpu_offset),
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


