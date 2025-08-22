Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F772CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600648E00C4; Fri, 22 Aug 2025 13:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588638E009D; Fri, 22 Aug 2025 13:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429FE8E00C4; Fri, 22 Aug 2025 13:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2291F8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC51713843A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:34 +0000 (UTC)
X-FDA: 83805125628.06.C784DAB
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id D0DC31C000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EFeLeoE5;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf20.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884852; a=rsa-sha256;
	cv=none;
	b=2SnSlY0/d6h1pn7H+IdWHDtJmrWkD2mWdQ3l1JmOYy9sxC7EsIIv3EBggu7k5P1ljpM2FN
	GwN19hOXwrWDe4UAlx/p0JJf7xVTWIRzY1RBLAEx7JrHHFsF4YoAUNG8+oIrk7JErCVIS5
	5tsURWGkxJUq+oilxPyHjQyHRSsHZM4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EFeLeoE5;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf20.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=485omdnoiZ8q/zyCXrPmnF91ALfkIJJ0rUsYbVB32HY=;
	b=peT/DLhv4eiSgdDZOYKpbPUa7WSeIupN5csWU/Tx+5xBB5T2rQL2xYDRq7e61RNxqqqkkQ
	L3nwDK5PeUM9xXyV3LF+dM3SyrN96PBU/0QbWcLgzDGrF/ls/PnQtaUbI2d7lbFrmaW+ZJ
	Eoo6ySU8vkaf1JdG82V5MxXQChMqw+c=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b1099192b0so39199111cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884852; x=1756489652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=485omdnoiZ8q/zyCXrPmnF91ALfkIJJ0rUsYbVB32HY=;
        b=EFeLeoE5jleHpmFg5cq7vUfcE5n50pMojhVWqahhJIkrbn0d2YKIDXQmolZJSI1Jrn
         a4RN6wBHH6l7M+489O9l9D2WIaSponIUvkNyJOvaIza6sUAMABRyIOKl1cl+WUJ0U1Jl
         8VziCkxa5rxwWgZLSGNpSb1628RoSAOpHbXy9y4nV0h0cFeF36JxFZ8RLjUn0b4Q4LmT
         dgzBHbX+T/fEJViRUAEP2KkZ1ucSg/TXgQ5PbiY/YIOR3ba/DOi+uFtChnKXBY7frjsy
         N6MrgNyCLLyxeb9K+35PehpTvcZK8bBi8KKQq0A5Azwsue7gHMp3bZl2aDpUjlyEVEJl
         //1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884852; x=1756489652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=485omdnoiZ8q/zyCXrPmnF91ALfkIJJ0rUsYbVB32HY=;
        b=OVfa29CAqAs9jhysRB9H++o8iDlicmm6SAnwkPcqE8aWf/AY0Jl6uHkbbbRZhIHQi/
         n9hF4GrMV7syY2ZaHzFBS0Qp5CmBTk3GgV8nhe/7PgUQrdQsrZqt+DrY77W7j2kT21xp
         35o/aSdUzdrWDXiDO/Q8+Fawp2rGrt8nFoyljFFMimbhtH8OBft/prtspAe4IZ2Ya6zW
         rCbPnebM3qL7Y/MWsRaWeyvYX17q2qDHH5FIbNCUvC1Pv3bL3o8CgqlTDzwA66P421GS
         XT/VFiulnicvM+lf8fQmoMz5xqeq86C2gfXVZUz3atAZU9icYRLK1CyP7dREhVXtpkQs
         gTMg==
X-Forwarded-Encrypted: i=1; AJvYcCXogktyG1BO8Q6uENt8J6qT3NucOpYjyVoN1I0xNfZHZKGbaKs0vUebHOhCXGaLq35NDK308IoS5Q==@kvack.org
X-Gm-Message-State: AOJu0Yy4A7dGGQXpBMk+4mfT9W4ruD5bl0G6uOufduLFs1aingWaWBnv
	1RBC70m6y+k8G5HfBicWNGotFJkVs633F8v3bQC2L9ioVb+F61QfEzt3Z/LWpl9vRsg=
X-Gm-Gg: ASbGncvaWfLKSBSru3te03QoAV0+KrX61ai23Kyot94/ky9an5Ygb2WtM8tNN7mN4oN
	IadrkB2JAvxodsHsu+xPz/1rmLAcl0Y7UHWHAx3pMnReXJrk/ynne7tFi4MWvdsTNZeMFbQplSN
	l2PJi8bICOm/7HPxzZJLWYBM0d3wQH20Xbjtqv/nvHV+DQuYgXiZBLpQLJpV3+97cX2QvbM8gHV
	j1Erdfj7aF5S/meX9WijCEpkgM61KZGcZZjFDKVVu4zs4RRNF9GYKHsoFaKoevZ2UeVkR8G1487
	eUsMxVVJUB8Khc63u86ybhGkcsIx62+EsIFZIKDyicdUPi/h6z9W/0oqln5t8nrO07FTBtS4lEt
	Lnz8VNF9uE0TZt2Lu5qubjiPyTEF5L5w5/Z866sBjrCs7fwJ5Pl35pyzSbwWg5F8paVCQnYj7yj
	xIVkMkytKGsXTmunLW
X-Google-Smtp-Source: AGHT+IGoenLDbU6hbLQEKjRKYVSKG56q+cISud/2IPoQ+SsuP/D2JDv3vRwFBNiEIIl5J7Ci/Xlcfg==
X-Received: by 2002:a05:622a:1115:b0:4b2:8ac4:f07f with SMTP id d75a77b69052e-4b2aab8c4e6mr52180651cf.81.1755884851684;
        Fri, 22 Aug 2025 10:47:31 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:31 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 6/8] riscv: ptrace: Add hw breakpoint support
Date: Fri, 22 Aug 2025 10:47:13 -0700
Message-ID: <20250822174715.1269138-7-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D0DC31C000D
X-Stat-Signature: qagrj5h8bgr6g9jwgqtuyj81s36bxfdq
X-HE-Tag: 1755884852-296143
X-HE-Meta: U2FsdGVkX1/LdVYAB8pN1qiv+25TofIP7KQ2ktPeHG53SndbSKQpe6DXfr9BfqwRnb85aDWcb8ntubrqAFjXPSq5hByk23U+HC9DhwxtUI79k/uI4KOQ7zCwcUMrbKwTKg36PcTzKUeS7im8nad6raSoJu7KnYAYj4OeqhNUEiF2CX3BTf6TvLX1Vozte/6xOn8ARNWnWEnZ7m4/gkUMZe6uF2Kyzd2io7N1dtT2K9egrbXeRpQDLeKxWmWqA5fPj+9/YRNehwfgVn5nVK/51xpOxFUXR7YdGqaMeEhZRqIh+OHBeeRWdV4N6cBt8wmYb3B7aohMShIYEnkQOgKdJkJj5FHbm8xO7hJyBHmmFl8+B2gGSXWfVOu7qQkONbmzE4OQwquqX3M+xI1KsLlZlsV62Xb55OuRXKBKJmAPs1QzwJZqHTMaq2yu9nHAr/mjApXP3WJ97Q+uidCCRQS13UR855W5JEdzHIc/xDsqFaUkP/4sCBTZrxMly0sp/ElC89QaUwfeupWtcwQ/5DsTtI/23chDT/5d3KRtbAJqlcBFzprTaKxfggVPC4MvKA+/acqYrUXGf8bA9loSglwHa4f5+CKYZ4sNcrjYA89yXTDOaSBY1lw0yJfgUOtlfRer8bTb+sj/xJGu8NG2DZLeZft3ync6voI3hbsmLpdhpIbSclLQHLyfHTU+UaM3n3MbKfGsBQQIOIPbUBqPP+dpDRdmIKI+gG5/ceMHBRhkh08S8igcTTA7gFWgSMCUt75BtUfrxUOr9fI7uxza+q0VdwRYoNiqKw16RNwJ9mRMqXZR1XnjSG6z+2lwepKYW6L0er02NICQ0BkFebzTZhgYl07cFRzwr/XuQ/q7NRnacExKQiABRnKv2Wcut0lN6ES2ealEsjzgtu3B7t7NlwLWrX37jwjVyb56uXzYjjzuxCMx8+wl8bb3MRIHWDdLddvDMaOxP669M/F6eJ7Jglc
 3iqcXfHm
 MCJVeJk7PEJYh7Mw1aWFR2P1gSxpGjDkUUozt/u5PrRhlNQLdn75poVAs9IjI8kxrMnXcejhFmGTrTSkzUiN1C6xAMGbLMzJsTylMAxVzT3nbPgh2VhqHRI4cnQmeoElyPFzJGe4FKQ2J9FeyBXz+OcIMcgqpkg1yYRc3+ksUIPQFk44EByC9acw3UlsCyMVm1eK9+SJSg2gaBfP4svX8n2UYrfkblIV84pnY1FiTqJF98UanjgVYsnXyrog/s/JBrg7qHfEwULQ9zuAUH80dps5V57Lxa3hHOid6f6WAbyvvBO20ihyWG1e1J+iwEjvxtyjCaskpWeRrcs/fKnG/uSSMhMxyC4RTrOvMDhgMoCMz9bQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ability to setup hw breakpoints to ptrace. Call defines a new
structure of __riscv_hwdebug_state which will be passed to ptrace.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
RFC -> V1:
 - Add struct __riscv_hwdebug_state for ptrace_hbp_set/get
 - Break out ptrace_hbp_set/get so regset can use them
 - Check for NULL instead of IS_ERR_OR_NULL
 - Move	ptrace_get/sethbpregs above user_regset
V1 -> V2:
 - No change
---
 arch/riscv/include/asm/processor.h   |   4 +
 arch/riscv/include/uapi/asm/ptrace.h |   9 +++
 arch/riscv/kernel/hw_breakpoint.c    |  14 +++-
 arch/riscv/kernel/process.c          |   4 +
 arch/riscv/kernel/ptrace.c           | 110 +++++++++++++++++++++++++++
 5 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 5f56eb9d114a..488d956a951f 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -12,6 +12,7 @@
 
 #include <vdso/processor.h>
 
+#include <asm/hw_breakpoint.h>
 #include <asm/ptrace.h>
 
 #define arch_get_mmap_end(addr, len, flags)			\
@@ -108,6 +109,9 @@ struct thread_struct {
 	struct __riscv_v_ext_state vstate;
 	unsigned long align_ctl;
 	struct __riscv_v_ext_state kernel_vstate;
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	struct perf_event *ptrace_bps[RV_MAX_TRIGGERS];
+#endif
 #ifdef CONFIG_SMP
 	/* Flush the icache on migration */
 	bool force_icache_flush;
diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index a38268b19c3d..20d1aa595cbd 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -14,6 +14,8 @@
 
 #define PTRACE_GETFDPIC_EXEC	0
 #define PTRACE_GETFDPIC_INTERP	1
+#define PTRACE_GETHBPREGS	2
+#define PTRACE_SETHBPREGS	3
 
 /*
  * User-mode register state for core dumps, ptrace, sigcontext
@@ -120,6 +122,13 @@ struct __riscv_v_regset_state {
 	char vreg[];
 };
 
+struct __riscv_hwdebug_state {
+	unsigned long addr;
+	unsigned long type;
+	unsigned long len;
+	unsigned long ctrl;
+} __packed;
+
 /*
  * According to spec: The number of bits in a single vector register,
  * VLEN >= ELEN, which must be a power of 2, and must be no greater than
diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_breakpoint.c
index f12306247436..f8841941f2ab 100644
--- a/arch/riscv/kernel/hw_breakpoint.c
+++ b/arch/riscv/kernel/hw_breakpoint.c
@@ -715,7 +715,19 @@ void arch_uninstall_hw_breakpoint(struct perf_event *event)
 		pr_warn("%s: Failed to uninstall trigger %d. error: %ld\n", __func__, i, ret.error);
 }
 
-void flush_ptrace_hw_breakpoint(struct task_struct *tsk) { }
+/*
+ * Release the user breakpoints used by ptrace
+ */
+void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
+{
+	int i;
+	struct thread_struct *t = &tsk->thread;
+
+	for (i = 0; i < dbtr_total_num; i++) {
+		unregister_hw_breakpoint(t->ptrace_bps[i]);
+		t->ptrace_bps[i] = NULL;
+	}
+}
 
 void hw_breakpoint_pmu_read(struct perf_event *bp) { }
 
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 15d8f75902f8..9cf07ecfb523 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/cpu.h>
+#include <linux/hw_breakpoint.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
@@ -164,6 +165,7 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 
 void flush_thread(void)
 {
+	flush_ptrace_hw_breakpoint(current);
 #ifdef CONFIG_FPU
 	/*
 	 * Reset FPU state and context
@@ -218,6 +220,8 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		set_bit(MM_CONTEXT_LOCK_PMLEN, &p->mm->context.flags);
 
 	memset(&p->thread.s, 0, sizeof(p->thread.s));
+	if (IS_ENABLED(CONFIG_HAVE_HW_BREAKPOINT))
+		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(args->fn)) {
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index ea67e9fb7a58..e097e6a61910 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -9,11 +9,13 @@
 
 #include <asm/vector.h>
 #include <asm/ptrace.h>
+#include <asm/hw_breakpoint.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
 #include <asm/switch_to.h>
 #include <linux/audit.h>
 #include <linux/compat.h>
+#include <linux/hw_breakpoint.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
 #include <linux/regset.h>
@@ -184,6 +186,104 @@ static int tagged_addr_ctrl_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+static void ptrace_hbptriggered(struct perf_event *bp,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	struct arch_hw_breakpoint *bkpt = counter_arch_bp(bp);
+	int num = 0;
+
+	force_sig_ptrace_errno_trap(num, (void __user *)bkpt->address);
+}
+
+static int ptrace_hbp_get(struct task_struct *child, unsigned long idx,
+			  struct __riscv_hwdebug_state *state)
+{
+	struct perf_event *bp;
+
+	if (idx >= RV_MAX_TRIGGERS)
+		return -EINVAL;
+
+	bp = child->thread.ptrace_bps[idx];
+
+	if (!bp)
+		return -ENOENT;
+
+	state->addr = bp->attr.bp_addr;
+	state->len = bp->attr.bp_len;
+	state->type = bp->attr.bp_type;
+	state->ctrl = bp->attr.disabled == 1;
+
+	return 0;
+}
+
+static int ptrace_hbp_set(struct task_struct *child, unsigned long idx,
+			  struct __riscv_hwdebug_state *state)
+{
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+
+	if (idx >= RV_MAX_TRIGGERS)
+		return -EINVAL;
+
+	bp = child->thread.ptrace_bps[idx];
+	if (bp)
+		attr = bp->attr;
+	else
+		ptrace_breakpoint_init(&attr);
+
+	attr.bp_addr = state->addr;
+	attr.bp_len = state->len;
+	attr.bp_type = state->type;
+	attr.disabled = state->ctrl == 1;
+
+	if (!bp) {
+		bp = register_user_hw_breakpoint(&attr, ptrace_hbptriggered, NULL,
+					   child);
+		if (IS_ERR(bp))
+			return PTR_ERR(bp);
+
+		child->thread.ptrace_bps[idx] = bp;
+		return 0;
+	}
+
+	return modify_user_hw_breakpoint(bp, &attr);
+}
+
+/*
+ * idx selects the breakpoint index.
+ * Both PTRACE_GETHBPREGS and PTRACE_SETHBPREGS transfer __riscv_hwdebug_state
+ */
+
+static long ptrace_gethbpregs(struct task_struct *child, unsigned long idx,
+			      unsigned long __user *datap)
+{
+	struct __riscv_hwdebug_state state;
+	long ret;
+
+	ret = ptrace_hbp_get(child, idx, &state);
+	if (ret)
+		return ret;
+	if (copy_to_user(datap, &state, sizeof(state)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long ptrace_sethbpregs(struct task_struct *child, unsigned long idx,
+			      unsigned long __user *datap)
+{
+	struct __riscv_hwdebug_state state;
+
+	if (copy_from_user(&state, datap, sizeof(state)))
+		return -EFAULT;
+
+	return ptrace_hbp_set(child, idx, &state);
+
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		.core_note_type = NT_PRSTATUS,
@@ -340,8 +440,18 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	long ret = -EIO;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	case PTRACE_GETHBPREGS:
+		ret = ptrace_gethbpregs(child, addr, datap);
+		break;
+
+	case PTRACE_SETHBPREGS:
+		ret = ptrace_sethbpregs(child, addr, datap);
+		break;
+#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
-- 
2.43.0


