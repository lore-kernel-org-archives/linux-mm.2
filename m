Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E14FD5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F8C6B008C; Mon, 15 Dec 2025 20:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647A66B0095; Mon, 15 Dec 2025 20:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE4B6B0093; Mon, 15 Dec 2025 20:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 358796B008C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:48:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C74BF1316C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:48:19 +0000 (UTC)
X-FDA: 84223649118.01.B3BFF3E
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF2251C0003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:48:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q2hRQ33m;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765849697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPaduSWe86itOLJLDO9/qRxhQFQa/4nam9IeEV1MY2g=;
	b=61QMyYU79MHxe6PBiNEfbembA4VlTD9Fy6YsTmoHQB9e9gHPP0un+llnfD+otBJ9hapiCc
	EA9pQNhZsh91V49A/Y0Om0T26H3bzNinbd/uXdTBBwaMmlc2/67wDbDIofWaaGREsfC2TY
	WJlwcB1v/X4cXiqDiECDR0FbWqLQqqc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q2hRQ33m;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765849697; a=rsa-sha256;
	cv=none;
	b=ZZMOqnRZQeKtq7XzZ/ru7asnwSXo04ep3N30T71jAeoxCdUnZ06vi063biCK2SxuVvIRpv
	uy07+64X4EnySlmxIFhCDn9Q0hU8ZIAnvzKmX0TyWgpJ1JVyluP9Tv7Y7atv6Mhyg5jcsK
	rdlN8KrMhjRGyunwPLfD2o35xuErVxo=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so5072499b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765849697; x=1766454497; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oPaduSWe86itOLJLDO9/qRxhQFQa/4nam9IeEV1MY2g=;
        b=Q2hRQ33mnuSF6QH+GwGpUG9jeAx/iLWDnFOpRTWMBRzNPjksaTUipQHoMtI260cAgH
         +602oaT2wU24vpQsn8cm7MR/H09/GhJeacsId+lfsd72UDZwlQHlJ7QNxp5UIhjK8uNJ
         PDOyYt1t8oEPJ+nfYZ2bGw4oipQReJFy45fwLzVYbusRULXoyn5u22Q/IRHRQ6w6V732
         m782aiq/jKUmjwM0SMP1bGMGNHj0B3DQuoU/8V11B57oyemz8dP9rKPlBW4GxwlGT6ai
         nwGnDiXmOgwl/nSCNis+WvHC0pF3dqgPMJwQqqseRBPbyMiL70vEy42WRFnB1I6i1aWY
         JwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765849697; x=1766454497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oPaduSWe86itOLJLDO9/qRxhQFQa/4nam9IeEV1MY2g=;
        b=jBSzotkZZ8vD7GCdb+1c3zje8+81OCAq7tjU81wt2+lFD+mCHV2RsdEUgYplRcbIx8
         BMv4rrZlNV0pmzn8/y49fY7ck9cwiC6j/GV//SGWKoOCoITfl1JaHgTZzMDcDf5nadsU
         yR3+BiUBy1UM7wrkCd68GXQ4asA9ceTiW13TzTNsKQx01Qa4bTf+mpwHvvxADXcTqhqq
         T+Yn7EDmCdnVxMLL9ZZ1MlxDWQOxfiKZpXwwz+Nv7UqOQpuZusd9NhMtlKN0grPIUwlz
         Nl8Jov3fIATj7kzdy7upWFqdKC6J7oVc5YThgqXYCQJUNZfK/FvHJiMQKDyFSXZGeIMw
         iprA==
X-Forwarded-Encrypted: i=1; AJvYcCXG6e3wjvR/aGA95zbK2AEJZWTNPDhYkGuWqHAVaNleXLtcmvBlkmNkT6LM34ShYNLiXwtz8coKkw==@kvack.org
X-Gm-Message-State: AOJu0YwQgiO2YbYVMsyM3H9p7REoJRNnLPLlNePemkmoXeZE6cOysJX0
	vtt+6u1V8GwBXMTzOQLtNfiVbMLo3nN0DvfmMufabGAgOaQsRL5pVoyEA7QdRtpmkIs=
X-Gm-Gg: AY/fxX6IXhXH6K0lGAqxcyBDjO8/dvpeis0eGrUJjpXPu2D82wpUnLUPzmvTlY0vF7k
	FN3XoAfTRsC64NupnnWXndcsaj9BJICaShVDVIyAj94exetTtc1mhJ370cdUxAIquqrxXJsT82J
	f/DbOs5BTY9q1f7ptFE8eYfqch9VuJ9iwro50hvA3Oba5+wZBiMe3itppcHLtPnpBVm7OJPyx3C
	eOVoWfIrIDjB+jMTt72gAEN3Hs5B5megAIrHdkdTjcwQOgVz3yfD4g/8Z6+RKnR2vEmPq3i1k6e
	rYmKgaME/n4Exhr8e2UkJY9xEfJtNagPk1/VfSBMiEB8ydq401SLcB0lWLGpwu1Mzq0M0VaCXTF
	I7E+TrbFjZkXreQFtfPwWm22/2/VRiqZNwRCI+HGstmpmj0z4stH/1JPvU1vVdat4rwFJNGEzm1
	f57kCLY22nX8jqPXObgmN80IrQ/TbbARxLiWtzSR56u/lB
X-Google-Smtp-Source: AGHT+IGq1tjZWtQhKRKbnMgnlKR2obxbHUXs706wZEaM0LNbNkdcq+HNiaw0vmfCMXTy97ide8fzgQ==
X-Received: by 2002:a05:6a20:6a20:b0:320:3da8:34d7 with SMTP id adf61e73a8af0-369adebe03amr13055886637.22.1765849696602;
        Mon, 15 Dec 2025 17:48:16 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c963b53sm13632790a12.36.2025.12.15.17.48.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 15 Dec 2025 17:48:16 -0800 (PST)
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
Subject: [PATCH v3 3/3] riscv: store percpu offset into thread_info
Date: Tue, 16 Dec 2025 09:47:21 +0800
Message-Id: <20251216014721.42262-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20251216014721.42262-1-cuiyunhui@bytedance.com>
References: <20251216014721.42262-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 1yxnt95337qsaa7zjncx1kfnkwpe13db
X-Rspam-User: 
X-Rspamd-Queue-Id: DF2251C0003
X-HE-Tag: 1765849697-34685
X-HE-Meta: U2FsdGVkX18EKqLm0EA9aOBeG09dEgtvolngXmp2DP7kKdBt1C7vwFNT6n0xUV0bxl7Yj/FYFE33DkjNBDaT806k12ck3AbjL8NoYfsU+y9rGJ+gsTIvngOyrfd2Ck6/8jbz1xFja7nemMPEqvV58d72IL11nAowSg2Xqqujjmq8ZibTDBGzl9iXGtJpYY36vDxyhh+zCN7lDh67zvSYpzJTBDJwU4kqnQhrfZUUiFIQ1FXqRWoHFGquA5GC4NHT7RTwO/9RzJNl/8ahfSnNeGeExlsMtczvbR0hfnb4oUQQ4CzoiyUzYEHc3PQm20aiwqGcHb6CUvLtJNmklkM/5TYPu8KwgyGNr7YX4UcNyNfrv3Oulck9qOPn9Ta2tq3EOQVB8HBxA5lfuZUJL7t58iU+SdI07hSKc6J/jcWFza/GYAOBsmIDHhfAfGEeoSoYrF1FlbAbNOnhgW+orEoFG02HaDLhWjcPDQyV47pp+flVmb+Crkchz9sKja3vuUxWL5K1usJXaqnR29pnv+aaWL07XYXAfzI+JIFPfcWkEhAPP3cQpuqXTNF1S1QjeJk/ypW4OWIZq6bbStYJn8NuCg30j+SrM+jACzdu7ZBEDdBgKzh5VFDiDP8plEqI6tV50ZIx5FztrbK1lJXxuB9zS8s8vsi5CrDEHGnP8+qejJ8RWVBzXv5kka6Gga2hOHjSeQRBQux+RO6PKskGWpWbnyexyfU7eXi+A180O5XZ5CgXoPcTwIM6aLcKSiEimCdKY0NnrhdnjNJNrNweJTto/Cu522vp0xPiVpANi5GSdRtO4gIIZ/aJy1/g2U+qStInP/EprYv8ji6wDW+bdhYttujxSbClYnmxFZNLkgW9Qw+MFn5WRfpXXjJpoGZ/iN/I7Fg3/dn3MGSwbOWELeH7VPjziNVrfEwlZehgZPgEmyru5upaAyAe1/kGVzsI7GgL/N3zuBZ2ZTjztwfc3LB
 m7HkRNNR
 cZT1vDlrRH96I7Bz65BDnTswtUZ7F08aK925Te0mGcC/MTIaumXhf+Pn0gTr3jf0Qp5+Hdt+jgJdSU2dpO8UYfeVAuAdlLmEYuMGLoWWnTRkRzbOscAWJ1m6heBr8LRjSQVi8gh/eCVldyepA/ERpF89O4DqxW7Zx9lS0YUY+2vJdbwo1oq1TYRVp0CNz4hmgj3aaW8ycLJ2gU4pQoH12xwT5aC1WvXwvMXwEWxGDb51cl9Q8B7kbhBagydd8YHmLkIghEzUowjoPPQbyCKIsnez0CMIRiwDDD0iG67xoE95OvRXVJd8Q9CzsUYtgKhoN24Qgn6rCVTZs7Kv0FsVK80LQtO8eal6c5EHTioUKKmHY4w8qulvCFcQIH3YBMRVwL7GmIL3Q7n24K1mvMdPDh3a3pBs7jTUBLmbvyfIW0BHU6HlR1X+Om8GU3S2dr1q3BnUXxozWw+kyV5LlSkkMUn0htxcYIGOcrtyeyAjirT8XWrzsg1OgOyzkDo50nSYGTD5MfywpbkRe8pM=
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
index c5bacf6d864ee..35a63420a76a4 100644
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
@@ -239,6 +241,8 @@ _pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
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


