Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A40C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066236B00B7; Fri,  3 Jul 2026 08:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D886B00B8; Fri,  3 Jul 2026 08:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95756B00B9; Fri,  3 Jul 2026 08:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4A3E6B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:29:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BF7F120524
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:45 +0000 (UTC)
X-FDA: 84947396730.27.0D58214
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5068820002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Km3TTjQN;
	spf=pass (imf31.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081783;
	b=gmcBv2DAg1E+TtmWdRBj3TWUql9DZffiW9zNLRfLAPUcJ0vxKqnffkVOQTRmAT34Go+FnC
	W6aSJMk0lcEvTrHm3iL+3FZVVaz4YlY3j/W+Z1xa/fD0On4uPQUf/WgfW454nIMW9sfgk2
	Ob9URV1M+IF+m5QgQ+zq2x+xwl+gmKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWymMkKQ8Nzs1dbNd9FV2sO0HsdChXyI0jaB18RfcJ8=;
	b=b3a0bwMT2VBhBSyat96S3fBSMPnw6FeXbVj84dJISulUjGuoMgY7BTbHJ1oBZnoZth5Clb
	a+BbcHwMNYLMVgve9E//+GveAAm4ZpkKddJmIck7q6lHOuh3+fx1cQVDoAoBb1hNo4VcuY
	8Qe6Q1tOKDl4ml1LkdN5PL9rNEexRHc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Km3TTjQN;
	spf=pass (imf31.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8475eca3a66so620491b3a.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1783081782; x=1783686582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xWymMkKQ8Nzs1dbNd9FV2sO0HsdChXyI0jaB18RfcJ8=;
        b=Km3TTjQNp9xYEfbf6zj7ZR8Qwej80dLoK1S/c8q0aaQq//SUfiPNF4jzm/MHyoe9Ud
         KAXuy9pecDUWxgE9qjmkJMHmmsRW4IuMMjs8VHG4VShiFgM0b4XuR4E12JS0JXrN1Fis
         jnpCaC5BDRuCh7c1MZruL3Xf/ellwJa/UKxpoj9JLAW56lk8o3Q+zXYb6MO+K1QYBbp8
         7vC9U+DrQsYoD1ehnppHYl4VCbPV71KF2Pmck0NVvwHX1Tdsz0djYCJkEKVdNvFcNNQi
         pEah/mBMqW/P6YVfG+hnf+RRCwLmJIsbf+9MMYoI53H+2RFrvlkTnYwxSJTnvU++tR6w
         7/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081782; x=1783686582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xWymMkKQ8Nzs1dbNd9FV2sO0HsdChXyI0jaB18RfcJ8=;
        b=EWw3pHE7i9p7JFbZtQwEarm0k3fQQtPp08idiPxPH7Ke0JlRNWGRpMJGlN6VeZf/tn
         RHIvw329N2wqYr7xKaseZFUkZ+KTk+50JgRsRIn2ULBwfJIzhweoHhN9Oajy3bf4fbuj
         NH1ov3BLTmHL5XC5CXweISrRpMZnL50A2FaxOBXInl/0THrYSvGWNZNXpqYPSgzyeQc1
         YFmAfJjuK3UD0PKOkRFlIRT62b9xLuOUHMxXvlPjnUlwmnrVMkDUpZtOxmnZUbkVaAhj
         Pw4u6+6kRmLCI4eEnrsHTYDad/14nCYt+9z1FAgtkHYq3V0CATuTuMaWKEgxt3+37w/h
         4Z7Q==
X-Forwarded-Encrypted: i=1; AFNElJ9LpsNBlZ1TC3sCq3WqjjyJY0/Z34kSvDKdviO/9yWez8LrTYjatyPgk6A6pLN9vv1DENG/leME+w==@kvack.org
X-Gm-Message-State: AOJu0YzEfJwshSSuQ7mMAPVsKL7guChD836zCzR9ai/viGKuBADqIBg2
	/2yyPVzqQvbvccRofbb0KAVFUldkxywtA0/XSGMOeb8pb2svUN/awIUVK9mZkcofRLU=
X-Gm-Gg: AfdE7clwcNXYp2U+QqnquwOXFEgmHXUZSDN+qcjFP5rNXLh3RNAEKbFSGdIWW4u36ns
	hWZUvVUaiM7UZtCs5QmGefNBcRyfto97VfDgQqtchnrAWj7K39xTjWm92R+52WSN0pG6hOnRDvA
	1HyMeOhhnbdwhU2wsyQ6IQKnu8Nx5h2GBkrHjpUS1qWpek5i7dqVwfJDec/3GvnoCuU9Zzf448G
	5jW5hQ80vJEDhg8KDFhE7hKmBDhg6S5lmRoo3PLGK8g1vxRUEOpH61XBmHUR8hKYsepWCktUg79
	/TIGgd9E6Waj33puOG9UEfTA8ejUQb+gNwbzzB+Md1PcK9Nd1cnPvriMNYl0x91MyKLR5DnBgjQ
	m1BPkTXTBcXx0wAbwvEUiMbwSfSwlwLZAPsej2znFI+mdHPUZ04RDkteMLbj9SaD2eX9SLxzlco
	+PZk3SrGdQ5eBt1jQX78R6NkjVZ1Cl1+PdWKUcaVMUz4z7YMU0r4o=
X-Received: by 2002:a05:6a20:3d8b:b0:3b4:7758:e397 with SMTP id adf61e73a8af0-3bff407cf53mr12548308637.16.1783081781880;
        Fri, 03 Jul 2026 05:29:41 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8f3d74ccsm2705551a12.9.2026.07.03.05.29.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Jul 2026 05:29:40 -0700 (PDT)
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
Subject: [PATCH v8 3/3] riscv: store percpu offset into thread_info
Date: Fri,  3 Jul 2026 20:28:32 +0800
Message-Id: <20260703122832.15984-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260703122832.15984-1-cuiyunhui@bytedance.com>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5068820002
X-Rspam-User: 
X-Stat-Signature: 3grsbd7tmi5sp9rkfhsskmypxfhy8ugz
X-HE-Tag: 1783081783-336408
X-HE-Meta: U2FsdGVkX1/po6H93vpWeGzkx+jtT3Ovyax3/53bw78T4vhI8NfPeE/N5FGrzsrnTK4S9b3JWzeJ7qhQGjU4hJQresCT2RxYGVt6KSkRfe7O7sdgM3RkHOPssYdsscthJIyGfzVK8SpRYI8u9wN34extHLqDziEd0tI2+2JfQihxx5kB8OkLfy9mizsOXpJyY5SiNs0ooRVxnqCTZwkR65BjsEi7ZlFdAvw09cRqLBjg5GF4iUMdiEYko87MCqCT0WTk1TvaRbGT0vLZAxcKR26vOPxOT4bcecXXwgi+8rW4d7reyx3oSgL0QSBmA6NtDuoCCyUjct6nTeSPJyGOuSvMbwrRDzQ1RBHlzQaKqkZvDKN/u2qSX/mngRe2+YkEOT7RbkiaYpz9j6JFcZkkAMrVSBq2zv0ZY+i2C6wxhSTk/h6nV4NOs2DYjtprRUalUaL+eEXIIDOQ6bItFkVoHcGJ6jIPEll4KSKvcBRuDrze91yUpWqx9IVkQPqe9kumGwF2UkGhmlbnMoMDOZ7kpZpY5j7ic12Hfnvf07CgODOhD0+lBDGYAW4tCviYsC4eYjtmtO5GFFcb0wpaqm8aJeNw7/h9NC2f1qQJ92ZUvJqtEeWwxQ+ckwLZWm1avJJ1IR9Oq3vZKzX1CEc+B6A+ei+aoXnjTDrHoYKTYWsDvGQk+PaaEyntD1U5xjsVDoc8m1q7zpXa3iow1KwN9SlxS1gGtwoT+edkmqDVLvhQp/qQXMIoASZNIPvQkSsmIh/nxrQ3wRL4V2W9QZ/fSRWjqGKxPkDpGYrQBsvNyJF6KefUFxCy3snqI6l0ewE4qEfkGxh3lGFXFz4Kt5YfR809d6ivneUf04hQad3a1/NKZDY6J2uplF4G7wzucB1tBnZH+l+3Rq+nz1RKFnsl1SyRKY+ZHVx0E/axtuxaZNlvwTbx/n0bvT7m9fzd/wekdBcfKWg1WW8EG9snBhB2OJk
 yROnt6uc
 6nqiqgO2n5Ep6GR8Rp4ABywm9bGBxC5gaqEKjaHJxAhf7qNKYvyuDgsBIXnR4RUcJE+V/H4F7xdnk/BHTf6SoS6bhcY+ekQTuyGs6UM2TE/8yTn8yiowq4mQ+uDJKQRwzCRfJqDi02T2sTz5DUpTBo5SkT1XINewFFP0ce5Dbh4e791shyTUw3wb/kZI5ZNVZbU++2YADKsSJ4rOkyprj1Alc2DKgvRDmApUwPh+pVVDWBTHuCi/NCvS0o1lizSgFjNpbyhl8poKM19cZfQaF2ZqEbNYLl0MtEl1UaXoDLtZJkX324DMOmwzInrxEZWuWmiF5/7OjsfXxa6fCZMFkIIVbWHTnorgfYQrL6H67sSsdcIS3AZQPrDvBrh7bhXE9KDdzH3/3K/bubs5S1ZGTqLSwxUcV5DYSvcXFQjdROtvIVWRqPjwNp2OkzDba83xK4HbrButnmnx8Cj0H0xP2uBEUCA160plrMdJ2rH2JzxFjVyuJ4BqwyQ5KGkWqnAdbwMsDXGkT8YCrL8t+ldrEtXAblw==
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

With asm_per_cpu no longer deriving the offset from the CPU number, drop
the stale TASK_TI_CPU_NUM asm offset as well.

Link: https://lists.riscv.org/g/tech-privileged/topic/risc_v_tech_arch_review/113437553?page=2
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/asm.h         | 6 +-----
 arch/riscv/include/asm/percpu.h      | 4 ++++
 arch/riscv/include/asm/switch_to.h   | 8 ++++++++
 arch/riscv/include/asm/thread_info.h | 3 ++-
 arch/riscv/kernel/asm-offsets.c      | 2 +-
 arch/riscv/kernel/smpboot.c          | 8 ++++++++
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
index 76b1b8c1fb953..9bf9f4cf4ca5a 100644
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
 #undef PERCPU_RW_OPS
 #undef __PERCPU_AMO_OP_CASE
 #undef PERCPU_OP
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
index a75f0cfea1e9f..f4f7ee976cd94 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -38,6 +38,7 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_SUM, task_struct, thread.sum);
 
 	OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
+	OFFSET(TASK_TI_PCPU_OFFSET, task_struct, thread_info.pcpu_offset);
 	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
 	OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
 	OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
@@ -50,7 +51,6 @@ void asm_offsets(void)
 	OFFSET(TASK_TI_A2, task_struct, thread_info.a2);
 #endif
 
-	OFFSET(TASK_TI_CPU_NUM, task_struct, thread_info.cpu);
 #ifdef CONFIG_RISCV_USER_CFI
 	OFFSET(TASK_TI_CFI_STATE, task_struct, thread_info.user_cfi_state);
 	OFFSET(TASK_TI_USER_SSP, task_struct, thread_info.user_cfi_state.user_shdw_stk);
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


