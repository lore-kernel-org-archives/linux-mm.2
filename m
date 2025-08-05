Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595CFC87FD2
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBB36B00AD; Tue,  5 Aug 2025 15:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E0C6B00AE; Tue,  5 Aug 2025 15:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7F16B00AF; Tue,  5 Aug 2025 15:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 986946B00AD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5ED65114AF5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:14 +0000 (UTC)
X-FDA: 83743719948.28.78BA986
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EC4C40011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VlJA6QaE;
	spf=pass (imf12.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NaF/ZBQxTUv12deyQ9gwmEo84+EIUJjfCF9ZC+Wrs8=;
	b=L1n29HBw5GgclkTQVpRmLvq4XMPhhc4AqYZVsbjBSP9TmTDLHDlw9BkJfBXSWSgG7d9Yzf
	VsoeF4UgcnsfwIIYa39O59mS1PXhg66FIEq+8KoWRubsFOsDoX8l05uiACaN9OxEtYF2M/
	Z6Lo25KMzZTNGgAE/6ap2VNRTH2Tb1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422812; a=rsa-sha256;
	cv=none;
	b=cCh2PZKP4AEbL9Q3V3ln5SroCloWl9hpvhVjsD2QvKIeWtYrDaRYzd8wUEEvMBdTYSAK36
	7pu2Jy55p8aOIZWK7P+96nsjEnjOgwB+d0DFoT4k00IdexfoCfUFZ5SguWoD47vS5kexmd
	CuwLuof880QtleycXtnzDrrV5Qg4v+k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VlJA6QaE;
	spf=pass (imf12.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e33d36491dso617659785a.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422811; x=1755027611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NaF/ZBQxTUv12deyQ9gwmEo84+EIUJjfCF9ZC+Wrs8=;
        b=VlJA6QaEwkDjPDuW/Y084yqIIG/shfXkoZiZw8DIZ0pgRFqcUEkB4MwAq7g8Dd3Pgj
         oX65nC7LY1GWJjyh8rk1swUrS82vW00ERpxofI9c7234rov+6tJtVXnDPgUBe29KPeNR
         PCSA5Aa0hsIpbuwx7AHhxd+Zg4+IeLOTQGm9HkGVClUS1V4mA5onl3AJZA+oCFqfaCAL
         e8F3BnMLWd4kgVTsmJftxm5dOCktdD+R1RzH0hAGIRBVqvxYq2rtRQgruRH6OjS8gICd
         aKhstIwxsTstOhg5NbnBE8GqSfu0ubdfO2EaL5ZqruBaoNEDq5vm7ncbFh8FIM71QSZh
         myig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422811; x=1755027611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NaF/ZBQxTUv12deyQ9gwmEo84+EIUJjfCF9ZC+Wrs8=;
        b=AVq6qleekQXL6m86h+PgDgVTFfsWOeRlTb2DsFWx3ANU1M0ef0KcAUNwHHFLTV19G0
         h10RqI2b46aJ4kpZPYV2O5L2UIjoPosCdIqiYdY2xZm9V6HU4u84vya07yiVvBjrPZ4z
         e2aDqSYaSFp4FKGflveS4VGfMyC5WB4n7yXOFdDaxcBvLiOka2GCH3trVF+3cznaGCuv
         R+upEzJdHcY2rLTOoqVgG3ZMR8RagwgDw76Q2Y1DhkJ0FP6lK4YScc/nMVwNkcI9XPpL
         lF1i4I3yBwZuxTOyTzLTdCmVNAU3xftk/RNWVRMhwWcuHKXTDeKfwbcq+BYfHXorrgDX
         FMIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVol1Cak3/QEkOKVoave//B7+E0zzK7mJwqJd0EJo9BUOip4ISpjRoHNMYMkPtivedt8nZYv0Bntw==@kvack.org
X-Gm-Message-State: AOJu0Yy1F+5ftECu9NgtOZLUVMGhjW8I8Vb7ddXY2wbu0Tn7RxFeE6UU
	sfItzXi8skL7yVze76blIbaI3jHU1PC2OWK+bmMvG4SV/kU75RXQmeXXnf1sAVGIfJo=
X-Gm-Gg: ASbGncsYatmVBcc5DHG/6I0G46K8ranASd5Aq/k8s62+uDkw48awbOpB48o6Db0PL7/
	AwjuK7vSMkiDdAlvYw/QEw/5j/lFUmw+qXcklPw0z2pSLEBBWSW9OGBO6lkB+3vEkj4rTYRz4XX
	L7evTS2hL89zdLYkcULK+HR2Hi3w2sNRMlfzS3CoxwhNKim97BHYQ1zusiBiNfPI18rz9sMXYLV
	YVDNIL7lklzuyylWAKYq1OOpK6bw8S89/IY30/Y2kPkdiTWpqvydhoFiTm622AxFEpCp87pl2+v
	NZvtA2Bj4Dx32zeiYmARvI+9nZJ6h0Gb90oGGneWaTuVoOEzrFezsWBNrqePxdmVUaD3CbElKqs
	tIP3mr0P82zq2k62/gjpVQBnlNqR1lCIDj1MqNTdYJFBlL/dUBtUzE5B4swL5/jP3leFB/wZv8L
	lDEfNdlg==
X-Google-Smtp-Source: AGHT+IEiw5qn5MBLjumC4Tao3Un++oIx9bSGZnVNfPEZCF9kraUYTZzvHsq8Xt6WwLTbl66stoXsIA==
X-Received: by 2002:a05:620a:4410:b0:7e6:2f06:aca5 with SMTP id af79cd13be357-7e814ef34d2mr82086785a.61.1754422811237;
        Tue, 05 Aug 2025 12:40:11 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:40:10 -0700 (PDT)
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
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley  <conor.dooley@microchip.com>,
	Deepak Gupta  <debug@rivosinc.com>,
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
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 6/8] riscv: ptrace: Add hw breakpoint support
Date: Tue,  5 Aug 2025 12:39:53 -0700
Message-ID: <20250805193955.798277-7-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EC4C40011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: zr793gq6abz74b8qnsxyfhjpcuu5khxy
X-HE-Tag: 1754422812-524061
X-HE-Meta: U2FsdGVkX18+HuuEorKnOYNLaqDwQWD+E8dMvUjN2juMx0NcClDCXU4+8E1gGIaQ+1z4vOQj+fcZ2PNVtMrFXv4kBFvrxA3Hxfnd2bE2Y1XzFpF85leakSOsduVE6koWHBFBfWFEQS5JmSQ0PqZ8bsqJyrAz6kA6xcy6m8oNac5hRfJF4YD6yGgtWn8voKtWe5sD3a/4gTxJ4+WfBhDMAIH1RBcmYyziiXLFpD2ZDPs1jEyUMKzU7++aCQB+Y/F5D8n8QEsG/2w4DveJYAJHgqI2j0XI1w3DXmsAqg8nfMcXFHHoE9lROL58CVy0oCDlXNMJpgmdAro+pNLCBarEy46iUofcWAvJEosNlXmTyVQJ6VXTGs0Bys5zljajfFg/1af8nMOSFD3G1jAb0tntTmzlxLdELLzR/FcFyQjrXhwM1/IXE1ldPBnSh1VwHPsHZgDeiSZDSGAPZIRZbqPVflkkMc8r4Sg3lg8xjDxr2riA0t4OxiFxu/Utk/bIK8NYozXaDCliiPcURq2173W/wAHCVVFGwo1u7uyPvHihvchM9Cf7HPxIeuMcCU4vI9/9njgpZS1k/fY4l4+P6/lrgDiKOslFNy+CX51mGBiMn+kgSpXPlpXyiZKEQkuShzE9UMcRGxwK8i+AyTqJSuSdY10HdG+Td1vDrAxb7pXOWLkCoRW0RlnKPXOWtVChMmywKJoFp4ZJZwY3SBAyiYLq0f6sry0p9RziFJIgp4rKaGovUUBy/fUesEDnz7AtF53Hk0Yf5wTuHoA4B1t5WgutqgpofLS7xCORBNjYedmd87Z08RXnAWt2rj650kUPMxb11r7UO/GXkgsIopq7V+hbpfZGBdHCz/O2tbHOcjVNhqpuU0CA4O+z+LxDXCfZMpuoGSHh0sgftjTpJQm65jltO3oMJvWBFcHOmNuiwMFF2iAv4ceTXet/y+/v+3+VswZIkGKYS24KmwLNE2o9lRV
 L1/GoHv8
 B0cBeIgR/2ZW+A9pkhdakeOKrHExjnp2g3FwHowBO/5nKA5z217P0F73swzRFnyiG6u+Bfx8CJLcChRIDOPMNaic2Qr4oeuJK8cFYhxFykIFDowiFjeypf6T0zE47PWSWCYl6JCjqtqQB5ZQGUhJgSvdXZdwEzZbY4vTO64LaJ4rTlcfu/SxNBkW33U/B5Tzq3uU0rzj25Lixax/nGvkkuZx2ly5VlRxzQ1lhJ6n4PuVAmrFktTONkjeK8m3P5tmMVpCVxhRU751nspwHGkFsHaeHtAJh5J4dX9CjxI9xd5gktfBekY6HPq42yVOjDGVqqpUAJpfzdl+CA5U+KL2SCMGen85mifC3QeM4
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
index 1e70ef9e6867..b1c9c40f5fde 100644
--- a/arch/riscv/kernel/hw_breakpoint.c
+++ b/arch/riscv/kernel/hw_breakpoint.c
@@ -721,7 +721,19 @@ void arch_uninstall_hw_breakpoint(struct perf_event *event)
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


