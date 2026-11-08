Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A29606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=SzGpWYaQ
Received: by kanga.kvack.org (Postfix)
	id 3E7E26B05B5; Sun,  8 Nov 2026 06:05:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5326B05B6; Sun,  8 Nov 2026 06:05:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF1F6B05B7; Sun,  8 Nov 2026 06:05:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 081FA6B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:05:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89051140452
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:44 +0000 (UTC)
X-FDA: 85411671408.30.95D8EE7
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0298DC0007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SzGpWYaQ;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794135942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moiGcSV9g6fEFglU5jjTd2VsTAmD/aUVb3CUOrfKCF0=;
	b=xqtGxyAwTecY2Frv/6j5NJB1f2TJvQepPyTHkaSJ59nZ4sPheYp5+519O8qRhRhcHx6yj7
	RdLYBMmgAi0czs0YPplO+hNlLlXfQJJ+1sqCbkJfr49MDRgSRwgTYKVzATBNv7b6rWt0DP
	KWh7bU/+mQYzyJeK5rNOy/H+9C+dxGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794135942;
	b=AAI4KAAQ31vRNGJ/HAHWX3NeBgY8w+peSldAEAUy9/Tv63gB4VPbOOwpzVKAcP1soHDIk1
	WlCWDHv+0OEvGGi9DDMmXYXSpY1pNgVcgHmohmV0Qd7B2Md+LahRw/6dkKvanz1Ne/8sBP
	NtOm/mgYMvGjsGo6Ya5wDV/Y5ICrTeI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SzGpWYaQ;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso20342a91.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 03:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794135941; x=1794740741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=moiGcSV9g6fEFglU5jjTd2VsTAmD/aUVb3CUOrfKCF0=;
        b=SzGpWYaQcrUra4LywWxkfXGPf8RPaV91QFb8E1LfrKU5GG7CK6fRZhhi53BoPY6xl3
         xakCHcJX88DB25xrLLhw722Ry1/CGl/UWb7pkyAObOiLyFt92QELokCDcmv1Z4Y/o+uj
         J5Ik8b8HzEW6Z1OyWnoWwVo0srltFH09pEhrTCQx4FwpGYxnEZJ8wEHq5kmpakrx/WZJ
         gszKo/+HWayIUETkD0p0CY+S5fio+tjTNcEZyRICsXwCLTHDB4aRXCIYl9p8KEv0U0Of
         LYd5bCxqOslRssCkWmC3Iffo4YeKVI3AxDXJmy+4BogS7c5SsuKWa5146jesrHnm2jHJ
         w4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794135941; x=1794740741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=moiGcSV9g6fEFglU5jjTd2VsTAmD/aUVb3CUOrfKCF0=;
        b=kESmkvofbA9smQ6Z6LcybQmeXw+Ogo7oC3kSmrQ8x5vl7sQcfEdktMZczdmpU4+dI1
         SAmm+iJb21YdktPGqwyIqqjJ0DCTIQMeIb6MirVivJAXgpKXkj6blnGraxmZk2DLb+Yn
         YS0qA0PI+ZzZLOp+3V0rUCQncjVSFwA/yH/SQHPG9Vuc65u8XYiToSQuD8aiy+cej8kw
         0qCSZTegAxh/dhtusBOzkJS6Uy6nnAll1s8JFLzrPW/n27H38Q0SYsTWgw0l6Xw9JlCY
         Y2mf8/+sZv8FIReNnWb62Z8Nq+hQF8fBl7ekFecvNDZuJIPvKCrsohIDuybMs6UeoFwY
         CDeg==
X-Forwarded-Encrypted: i=1; AL+hErEUHI89M3FLhMM/s1u0we8Vmca14m5atsdxEomxwnjehSZjKRJ6vtrZ6e3dnMxmZkrhKDNbYE/13w==@kvack.org
X-Gm-Message-State: APuU4Z/NKtcI/J6DWty247gpXn2cYv8mNu8jBjsu4gOSSN7M4dMdFh7i
	Y6n1yD1KkabMVs4lfRq/rtb2T4rHlC+r9FDLT+dDFUhXWC8Vxgpo0Rz2STL2GNZaarU=
X-Gm-Gg: AYBFou0HtXtRAQLLZqPkllKUZHFwoYfT6gHWVtxLem804auSJ1NYIm6SoztrI/GK3ZU
	ANPD4E+I37emRNW68qwvYQUwaIRjHGqTD/keKRnwJX2Jpoh8McJy1VSmFmLXFFGoNfFCFY4VVdg
	uNYXPO4tiMQCIxPnLfB5fOSmGPAxvpfuEampdxS/VmBIuQwYbXDPOis5mgWP3XXRRJS2b6yLWbi
	CtXLNyUDz/RHr0ZiOhoS6jgBfbZAmDiRavvA3xSQv2zJ21Y7rm3Ao9aYxE+O60SWrmtBjKtfY6A
	vIf2Qv3SgHaTVCeh2hYmdzJ8d+Pn+h2PbpgtsRepGloh+SRWktNvr6ExNy8TUPn6GtMtLbyQCVa
	93BwfsXJdScypbP/f/O1sahxc5g62u6jVW59KJ9V5C0sE4H4Icbdz/kWnswagF5qITpKr3jfmAE
	qLMyKn9sNxJ8TQZJKchFVsJDNspd71YT4pgcDapWccNriahzHPztgGghh4WRrZI7u7t+q4kUkzY
	JFHStzIyh4yJF4bVF0KAsJZJlZEs4LCKuTct0Sf69ODfHvXkPJKZeFdCmXWG74LRM9Mrmdziidt
	qWOntD2UNoMbMq8tobBDRTQL0Qp+YMu3TBkgpjOR0OgEmCCAjb0DfRPd1ynFf2c=
X-Received: by 2002:a17:90a:e7c9:b0:39e:4c7f:7308 with SMTP id 98e67ed59e1d1-3b12d37ecffmr886982a91.31.1794135940233;
        Sun, 08 Nov 2026 03:05:40 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1278918f4sm2609818a91.6.2026.11.08.03.05.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 08 Nov 2026 03:05:36 -0800 (PST)
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
	llvm@lists.linux.dev,
	dave@stgolabs.net,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	broonie@kernel.org,
	cuiyunhui@bytedance.com
Subject: [PATCH v9 2/3] riscv: store percpu offset into thread_info
Date: Sun,  8 Nov 2026 19:04:05 +0800
Message-Id: <20261108110406.97495-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261108110406.97495-1-cuiyunhui@bytedance.com>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ye68oqcykays58kfs9k5hcyiy9qxz8y5
X-Rspamd-Queue-Id: 0298DC0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794135941-637983
X-HE-Meta: U2FsdGVkX1+SibyoKoZM5522YuKotuuFLtRsXNQ8dOcrKfX2s/jlLETHxdYEQ6ojNc8iL3EPEiuMcnuX3zfM59JZQj9oV5FU5IYaGIJ8yFQLf5HRx74kMbp28PmZsfGrymJYqLvw7Pieovu1h3PvkdH/+jbvzm4XgRcnE8Z/oj8nKnZxMq9I9oPJgE32NPENoQ4QHFKOOOyMsNVodlg2KZMTkSlqhj1x24wymj7gMFS/mkDiwN7a/VWwAMGQ5oCd7hHTMXJOonrRpJblStZoLazlMeHycZLvGLYlv/ZvoHVnXfvj1t0pHrwt6f+lEBLwobHBQqOjM//0URGfzOxt0lFKWvLwfeoP0iZ8YTd84YPgs+B3vOlGBniw/3GQUnuPQdguOhvx1AErCJl3OXPIlDeC6VWFadpHusE3dNQ5BvRYIVwN6uOrDNxxX68sAEYTLoWotomKMQ6XC4sXclBntyP7pwOQRr7opETQUqQD8kDWcPBJNOeVavL694Z/UxU8VTySmvWmBXJgbzt2jVw+H0vyXFyOv4ku0W2HLSVMufbMPuSr5IIARPquKMfMNQEpo4/7cUWRKK42ZShaJ66m8iaETT7oUpyxPASi2opouWCXKFV3P6vKtFALFbyKisTWglcjcHxeHs9VkG4MG20BPSP3+Lh9A+HjafGWYqTbt3XXDQVyxctDTI9BmezcBGD9A6jyaBhN+q4UKkVon331LHlvkb5BkNzhMrXLq2px05K2xkKf5JzmMKl4uLtlNXaJCxgWwLSMTSPyYW+plb35wVfno7AqdNrMYj0hRDy5kE+eJCoyZ4XUWIU7FFPAQ2XVP+KhlOpkKWRp5/5BgGBD5tn8NWhfTQc+sWa4PaY1qxyJXupe9qPJ2wvaSlvwq94gi3bXiM3g8fTH2ITOQ2qPTSHwmFFClvyvohTjAo3DLpi2QtAN3v47Lt3ynWKlf3d84hRLHNS+eN01R5v6c8u
 1wE8/ykS
 5Fg0E2DMG871c41nzU0GcgTwYwdUVeO9Nr4fg8jsyyu10vUEBymR0IlfvkWz62PMCAAeID0AXAfU00tR5LaU8DBiVIAW4efLJKPmw/6kg/CR9G7xe62egxER36RMtOHYGT7JenFQuLKWRTvZ8hxqfHOB9k/Zj9jHrO5MyI+TFJLSG7V7A6/yfodXuIBpvkoIdHqraVyLU+yW/bFTlNV7XYY5flRHKl34rN81by5g8So23Hb7RI2s5d6oL8fU6ofHQNXaDj4q+RtJlmiUg789y/34y0h4nFUmamUdqi4bFIOLLDMsh+R16pIyrnLfldNxfoIDEHkimdvI+32nXlZ+RYhG2s/iJNqNEKJ4bIQ9EAtvBlI+bOjiOBJLokiuJAOVe4CUj7WqqQgFnc48RcK9txkbUdgP5S6jM32/xpjks9Yzd7gTE+lokdp6zdTTtGtJcsKOD+DPOq0Hjdcqf6Ayz6a4ti5i3RxfvqEdyUS+H2MbD1zybSNff5BxCq8yOhWtGpdrf8WdI3sueVS0PU49TuWn3w/p9e7LY8pvyaj2HIVqSTQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RISC-V currently derives the current per-CPU offset from the CPU number
and __per_cpu_offset[]. Cache it in thread_info so per-CPU accesses can
load the offset directly.

Initialize the cached offset for the boot and secondary CPUs, and
propagate it across context switches. Set it before each secondary CPU
startup, including parallel bringup and CPU hotplug.

Link: https://lists.riscv.org/g/tech-privileged/topic/risc_v_tech_arch_review/113437553?page=2
Link: https://lore.kernel.org/r/20260826012457.ig3rfmji7vywf6kc@offworld
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/asm.h         |  6 +-----
 arch/riscv/include/asm/percpu.h      |  5 +++++
 arch/riscv/include/asm/switch_to.h   |  9 +++++++++
 arch/riscv/include/asm/thread_info.h |  3 ++-
 arch/riscv/kernel/asm-offsets.c      |  2 +-
 arch/riscv/kernel/smpboot.c          | 10 +++++++++-
 arch/riscv/net/bpf_jit_comp64.c      |  9 +--------
 7 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index b8bf842d4c136..06ac38f733b0a 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -92,11 +92,7 @@
 
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
index 280b122b9fe69..2a3ddc3538869 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -9,9 +9,12 @@
 #include <asm/alternative-macros.h>
 #include <asm/cmpxchg.h>
 #include <asm/cpufeature-macros.h>
+#include <asm/current.h>
 #include <asm/hwcap.h>
 #include <asm/irqflags.h>
 
+#include <linux/thread_info.h>
+
 #define PERCPU_RW_OPS(sz)						\
 static inline unsigned long __percpu_read_##sz(void *ptr)		\
 {									\
@@ -557,6 +560,8 @@ static inline u128 __percpu_generic_cmpxchg128(void *ptr, u128 old_val,
 })
 #endif
 
+#define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
+
 #undef PERCPU_RW_OPS
 #undef __PERCPU_AMO_OP_CASE
 #undef PERCPU_8_16_GET_SHIFT
diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 123c89b694e87..b4a4d4a44f25d 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -89,6 +89,14 @@ static inline void __switch_to_envcfg(struct task_struct *next)
 			:: "r" (next->thread.envcfg) : "memory");
 }
 
+static inline void __switch_to_pcpu_offset(struct task_struct *prev,
+					   struct task_struct *next)
+{
+#ifdef CONFIG_SMP
+	next->thread_info.pcpu_offset = prev->thread_info.pcpu_offset;
+#endif
+}
+
 extern struct task_struct *__switch_to(struct task_struct *,
 				       struct task_struct *);
 
@@ -125,6 +133,7 @@ do {							\
 	if (switch_to_should_flush_icache(__next))	\
 		local_flush_icache_all();		\
 	__switch_to_envcfg(__next);			\
+	__switch_to_pcpu_offset(__prev, __next);		\
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
index a9de2dae804c6..6431914d21165 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -175,6 +175,10 @@ void __init setup_smp(void)
 
 static int start_secondary_cpu(int cpu, struct task_struct *tidle)
 {
+	/* The idle task is reused across CPU hotplug. */
+	tidle->thread_info.cpu = cpu;
+	tidle->thread_info.pcpu_offset = per_cpu_offset(cpu);
+
 	if (cpu_ops->cpu_start)
 		return cpu_ops->cpu_start(cpu, tidle);
 
@@ -190,7 +194,6 @@ int arch_cpuhp_kick_ap_alive(unsigned int cpu, struct task_struct *tidle)
 int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
-	tidle->thread_info.cpu = cpu;
 
 	ret = start_secondary_cpu(cpu, tidle);
 	if (!ret) {
@@ -208,6 +211,11 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
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
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 371405598faa7..fa6ce5613c4d6 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1466,15 +1466,8 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
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


