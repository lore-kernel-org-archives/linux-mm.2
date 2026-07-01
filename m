Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA71C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6B66B00AE; Wed,  1 Jul 2026 00:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296B86B00AF; Wed,  1 Jul 2026 00:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137816B00B0; Wed,  1 Jul 2026 00:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDA9A6B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:22:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5742A1401A0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:22:04 +0000 (UTC)
X-FDA: 84938910168.28.02B122A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 859F880002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:22:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eYBvUkve;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782879722;
	b=vak2cHQa9+POpNa9HxqN5mXt00taxZOjz8iG13aOEjOZJWV1wQS2uRjZ2qdGzmu8zLWzcw
	WpeiB5UsKEUDHVtkqj4Q45zbDMGZIuZXPDDLXmg5/RJYxr1PbBSkWUNxZxaufqvqbEUifX
	Q0i2biFfTylryfB6aDoVfWqeSxe9W1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782879722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9bF4nwkw8I9o5/dk7AxDL3xS1dNrudcJthGETtRQoU=;
	b=jVkZeVWgz1TxaqNCaUEadHw/J3k1K7lV98Zzwoked4CItfwOKyeyIfFgxGlyH66xK8GY+3
	PRFK9xUmP04BDhTIba3Pi+CuIMCdwRk0zcCOk5lJaUz1gpskzx2iAQAu9DPL1wfIcw2Kq9
	yI0A6kZvtxEHvo8hueH0e8pfw4h35Cc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eYBvUkve;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c9b1edf2bdso1247795ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782879719; x=1783484519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y9bF4nwkw8I9o5/dk7AxDL3xS1dNrudcJthGETtRQoU=;
        b=eYBvUkve4oN8tdgQaMUCjUR4ku/lK3hBa+Ss+Dqu9i1LFBCnEb30ctRV4SqLLj5UVS
         FKSSS0jo1c8/cjPpUv+lTWyIJ3MdynrGGVAMVyEQ9F4vOvPXm0bUrPNAJdHzEORMd4Kb
         E9Vzw8HvVocURr9pD1CCsuu1caOUMoDx31UdGXBENjhRFX5GHjOuGDrggp6t0/VT8pth
         NAePqbwKa9MidGDlw7CuihqMVxjVg9A+co8ZZ4Q8kdZPEa4vaY3o4ZF1HjKGwOk22q7e
         wSYVfmPqdYQBvqJHce0rr8pUUyYCFB9p6XF/wkKfFiZ+yaShWcN+DWAUniTxSec8p+gQ
         nuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782879719; x=1783484519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y9bF4nwkw8I9o5/dk7AxDL3xS1dNrudcJthGETtRQoU=;
        b=Zwl+D+P7WYygmzwVtj9+IkFtG6L+oxbvwrVKIYMfASB5WaQedxXCtUCjYZlr9C9+nI
         yFNz/bKCuTV3DJzl6QHDTA1ioZNSjVp19R/Nd7Ubz2mxhATSLVtP2QLUzqqTECjig09q
         MVNODGgkYQqtijfM905OCx3QaaK7sNWIApj8JZNCV5LvPNV+qUxRFviluAqWbjqQ5dWt
         nrMvxc1tN0d05nPBrrdhvSm+6+yO6fpcfq8b7mWlSQLZNTMq2arOLhA9pSMF1xAQaE+s
         uYG8IXXMo+TyUd/WJMHKW/+k+BGMd6bbIzH8S1twYDcWIGeqzvk8dpdsiXNog/Nj9ZTj
         s0FA==
X-Forwarded-Encrypted: i=1; AHgh+Row9Vs5QFCL0Ru/Xtl4RDGo5ffiS4O+oJE40kzGQAv8qSO3GCUmz0dB2NATxemerwDVAUYS4wNAhA==@kvack.org
X-Gm-Message-State: AOJu0YzNbrQn8HzBesyyQwTe5FzFA+ZPsi39Q9RCcYMBUy6fSOfVMk87
	qQ2UZV+7uHfbdGHwmrRubxB86fxaYj8DNwFugvr1W6/c0+it6ybFb/th2ddtPchYWZQ=
X-Gm-Gg: AfdE7ck7z7jW3NRKHjCJDQqWa3ooUUlFHTzwVTWHstK8jd2NyToUTQB7EhgHeZ7Ij2o
	7ZiPXsJZwDVU/sQ9an8VeJ+cOhGnn3Jonnr6mRyFRBOO83ItygJLgorONimvl1y0O5UjzutDweD
	Ug7x4UZTI1Asbv1MEuBk1lzVCT6ftjP5iyhO/rxr4QVrVlTJp1w0uHjqbu2mpTotXc6ZipV2GW1
	QJeJtwEPeB/5HFWN9oHzvkf8Hnin+P9KYHCnQEkmjXnePN+R5b/XJo+HnWGlQzX1chrqdJr2oyF
	Dx7TL+gM6wyQtHtl06z5Sd2BOYiYD0moLHbthU7NYY5XAAdl0xOcHkOxKZ0Ddz6QrCqBpdzbIlH
	hJBzYkkDCVWXT2WmY5h+P7M8vsPXnc8cC31P2Y1yMeZ1DjX7I/YO4TmMpB5bazwmHBJeCPwV1uo
	3NqcIKZlX8dW/Id+CB4PxCXxFO6OGn2yJya5mk17gQYhFXV2Js6nNPb7RW
X-Received: by 2002:a17:902:e550:b0:2ca:320:f74b with SMTP id d9443c01a7336-2ca7e6b7beemr1619545ad.21.1782879719331;
        Tue, 30 Jun 2026 21:21:59 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c73a9csm24450865ad.21.2026.06.30.21.21.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Jun 2026 21:21:58 -0700 (PDT)
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
Subject: [PATCH v5 3/3] riscv: store percpu offset into thread_info
Date: Wed,  1 Jul 2026 12:20:41 +0800
Message-Id: <9146018e3348234ea5c10b245aa5531f172d0f6a.1782877663.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1782877663.git.cuiyunhui@bytedance.com>
References: <cover.1782877663.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 859F880002
X-Stat-Signature: xhi446bwbae86wqxbb8esjfpwmiu8prb
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782879720-451918
X-HE-Meta: U2FsdGVkX1/FKg84y+1GP8zyGYtEEXtczi5RzB6BXdWNPZtydMtPNuHIcRk1WAg1AUEo+jKhpNoya89GLP/ZW9N4XcNoofsKg6TpoFWb/cs2RtafyNHsNL6dHu831FjCyYJPsuEs25NNU3AArbVWedes7JFS4qdWrxZKJG0jWPfhH7iC3+j39+XG19BxecakgSj09XoiTtIHiNq8WdBRbA/SGKOEOaeBQ9K9VSMVtevgqPvUCkL2pybTv73aX14rG1PAEuW11dS6Yd1VXpYjFQc3GOfaB9RpnmG1E//a/GF/QPX4GyXnEmNFuWPdn8Jl1pRLbI78UDIWv66qCExEq2X4gV1tf0mRe7hWxMUJe8F2h4n9XUEXGV19dMg96ktVPd9xfDzy4xSAsc9Xav8W0ao2KyVS2wmBcG92DsR+15Wm7IuojHjYrmZrDqiM+1MOiWL2/wziYouv7X/kSyPJyTXsbufd+3xMF70e04gniJ5WePpz4CotHLtRfL+5SNt9VqXeFMcqD9k583sZ7i2kAEUPVzXV0gS7NCWxvhxMT7gGIxHtHfo40Y4dcNHA3gk+4pqBC0QLlBnaQzJkJsfcz7GO5kRvu5TJPo0mNcYYARUUfCR2ah4bKdmSylDi67LRC+TpPRUPJcSLa6B9E9ekESGLHVIAG3MAGjoXO90Fh7QgxzhnEPdc2aa/IuLkUW668p8RD+md+CJMVWdjc45kVauCCGv/PovByYdvzOPCaIWLYkd+LGdJe5cIRPxyrQoEYkwp8PWCjt39PIIXlw3EFYbVxAAnQvG/ySAshbM3mWzAWfWQFFyTGXDSNqvutqftDu89/mJ+RpG4RNoUprvAlYBpOGTgtO9BwJaVn+iQxPDJoGacl4DrUWYasT1uOaZ1XQcxXfrMPBW7wPIOadYkfamIu8DchisZoI38RWeahm6wvnxqnWbGIglgzoUg9cYb8yngRi3e7Ie461aOvJU
 xu//NHaY
 /X1MXapKfjOyaGuF/k+zMGLseCyrTgPIC2GFGKX33Jcik0ye9H2PN4uVgwTlaYjbr6PucGiwKli+SzO/SNE1IaEzm1pNVsmd07dJzrAdfteOj4GLI5TlsjXiyIIHpPP3s21Ndap5/BUiZLhFRDCPwDGd/m8FCgRVyO7taY0J9Jwg1BFBaev2CILVuynWMl6ErkqFoZYaVbS38TNjuc4FQzftuQUyrwmBJpS/VkaAFWBuaBSAszc8d0qy52PhSvGetBSKaxZN3rWvCgYdfIWCPzZOmuGNv6/MmqP+fGRf9IzJoWB2J+EKI7KG0/72E46x54B9FJuPMEV7ofoyQ+gdy3cO4IGAifvbQgLrkQpuIodTCIfNrgwiCRBe9KgW2ayQj8RtUEuQb3ICoOHZCQF5ba0607boE7dojwJvTONNmwfQgvz+PNhsId62e+JxjVWWGxMRUKvweBfhQuKxh68LDepqHByJgGMYY8i9HaaGgF2vatFW0ylmv7hS7Tk2ccX56PzyJmUgtKusw9nfmQqRg1iUklw==
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
index 46f1901d3bb88..dad975b55d0c3 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -8,7 +8,9 @@
 
 #include <asm/alternative-macros.h>
 #include <asm/cpufeature-macros.h>
+#include <asm/current.h>
 #include <asm/hwcap.h>
+#include <asm/thread_info.h>
 
 #define PERCPU_RW_OPS(sz)						\
 static inline unsigned long __percpu_read_##sz(void *ptr)		\
@@ -278,6 +280,8 @@ _pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
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


