Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89F8606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QwP0vdeH
Received: by kanga.kvack.org (Postfix)
	id D9FDF6B05C2; Thu, 12 Nov 2026 05:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76EF6B05C3; Thu, 12 Nov 2026 05:42:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F266B05C4; Thu, 12 Nov 2026 05:42:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A15B16B05C2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:42:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32C5F1604E8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:42:52 +0000 (UTC)
X-FDA: 85426128984.30.D8710A9
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D65E41C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:42:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QwP0vdeH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480169;
	b=bvWM+LP+flrGarlebnNJpqa0Nv25n2SbEDjVOrI40REapM0xfvwS620j9aqmX1bCO7b3BN
	pZy0uhjXWajfPN20KQTa/3G6P7KWSchQNEx6sC754YJazFP2E6FRr5wWCTdk9sVN7NWSB5
	jbXcW6MRkwG1fSArwH3AXMjwCDADJPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY5d4/TMcy//z+w9FDGxWLfQayj8V8d4N5emA0503YQ=;
	b=BDblyeKfAJa+bvqAoNVGZvRQTb8qWWapdMj1Pjo6VjNVB1feXs/3dfVSW2IfMfi1otVo5e
	1V+G4/Qb73854BJ/RFsWqBnKdOfMIcWuzOoHfAjqikAif06D/h1c/zxnm3HOLJWVt188Pq
	9nmCD1d1ljNZyWtaD95o9crxE2I3LfY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QwP0vdeH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-37628596783so4104473eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480167; x=1795084967; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bY5d4/TMcy//z+w9FDGxWLfQayj8V8d4N5emA0503YQ=;
        b=QwP0vdeHKMwII/jqGEJ4sW6NUs5RzAqNqmVx6XAElZQvAysZDGGSY/rH4t5UvQRVkc
         oSLN2KRnZjoHf6AaO3BxnmxR7TqeXZVkLB+dExyzpNwCHXA6ki9Oz1YhZZVSym2+n03p
         oKlBIX5rda81VWPHEXAEwAoJTpL9u22oIWKaSLkiDv4ihufk3iObWJX5YifFBe0lz89C
         byZKQUfZBgwaflEInpT4Pm3zqYWeNPGLrQp3+bE6AVYRjsmJEAUc56LTIPzdoiSYajfX
         ZD16YrI0+0jwRfhbN+xL5VLzKNKKn2dt4stj+zMLiVkjc2gdgIEoFkW5QELf0Sx1Dtev
         Kh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480167; x=1795084967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bY5d4/TMcy//z+w9FDGxWLfQayj8V8d4N5emA0503YQ=;
        b=tdlqE3o0uj5Y0yHLGH23vTVmr2t0xIa64cCzB97iMwZGqnu8sb1o6uH39bSYZXPj9j
         YXZOSW00zNSNBs95N0R2ZlMWBhsj9rclaIsBdQZEAooT/bTnwRPcLDYIsBH2QODj18SX
         MpJzNYL++P5XW7rlsLR7mXUK9oCwZzj9BWhnUzDA6sPlWTchemUD33AMQ6Ky64WpDrST
         fcvYYldsIudCBwX9NEksPIFoPGAZaZiwzKWR4nYTP20nrTlndosDTZq6LlIE9zrsQAI/
         zRSfpUyXOxQcXeIJkI805zdKCi1FadmtcqxT68SPqNTGxWh5Fd++eXuDbKBIWeH07nSI
         kPFw==
X-Forwarded-Encrypted: i=1; AL+hErEV7Vj59Cbn/1x2o4jPzAFeWuw9CpvJU36/PJ4m2DyNrcD7ZlcM7fCF2LEC88yur8yeAY1vGHo21w==@kvack.org
X-Gm-Message-State: APuU4Z+tN9Tnu+ts+wqMx8nyhnudiRKX4nRjpEHRnujdi/+45pl6E71v
	M42g5WWnzM3ZVazTVKnyq10wpBMG7ylpk1dRorUIILdVIl8oxJpu3piG3rSiJOOUzSg=
X-Gm-Gg: AYBFou1r+IIOJB/IbWI4OW/axSqncNj8y6SLbaQJmZcNdvtl3g1876fIISZOXjviZ1Z
	A75LTeTmNSkpvl3t7iRvITPP424qjMkrCDVHLvOJGcBviN5rtbAw6KV9kngRetDw+8UnYkymWie
	YoUVUUt+Kv+KdPiZwdxxeQ0C2du618LpXR9IlznWsY6T52Ep6+M4+PfP3p6yZaYVscuFEbdKQpO
	1q8ZMYrS4h3+rcUIDaWutNFuADHDM42uccAtFSv8VqwCAsKO98wRMy43kpYNThVAcj6UHYCacbP
	5koiSxmNAGJDS5JEw8hcUp/PEGvW2NdkmAC1FkcPwgseNex51EDeFu28osR91T6iB2c6vuGVtTi
	cYc3ES93+/y84x5VCg7r0o2UPBIx8hvhKRifn4Y/uOXfxAeIhl+A8oW6WUn0IOaQhA1memr4JwT
	JMeQIjVTGwBrgfwsMgidaagYab0eErSDw0M6La4uamcBzQ0MYDPYiBnUx8cY2+5ymr7BNvbHYOH
	GvMbotLTdEgPqmgNnz50JKiuGA/n5xSdyNAaQIKVojdAO9rIi4tOKpWyG4amFOHGQbympbs1Ag/
	JJt0jIIT0FdQQvkII+QEYzv0UcE3gKGz29Abdinvrv+L37O9VURqgp551tUaHEzCl7k=
X-Received: by 2002:a05:7300:2324:b0:36f:350b:3838 with SMTP id 5a478bee46e88-37686278c55mr7595712eec.31.1794480167105;
        Thu, 12 Nov 2026 02:42:47 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.42.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:42:46 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	oleg@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	broonie@kernel.org,
	cuiyunhui@bytedance.com,
	dave@stgolabs.net,
	david.laight.linux@gmail.com,
	jszhang@kernel.org,
	tglx@kernel.org,
	conor.dooley@microchip.com,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v10 1/9] riscv: store percpu offset into thread_info
Date: Thu, 12 Nov 2026 18:41:41 +0800
Message-Id: <20261112104149.38589-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D65E41C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: hk7pz74983rn436ccrkiupq94fjkp5s8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480168-866442
X-HE-Meta: U2FsdGVkX19tMgah+qhmgPEhxpsX9dBBprhJ462S/IhKCFH4jwh4Hp8p9mpk7ofvhwmvs45ukpsB4M/MUwu/nTTAEsAu2s30fbzyaIK3OS/KmnG+mOclkk7be2X6TMCtv+IepxaM+SeA/C/19CY2dr2BWpyN8BrwJsdQoFEwwTMd5o4TtaevGR/fS19Iklw0Ih0yA2Sx209Mqdksz1UefCD+wUD7Q+nB7i8fQg7W5OQu1r9bbsreIhC4dLhKBCTIIK8jLcBeuG+yEstBFkuvqleZQT9s5N1sTWGrxXEedqv1r5libUzuebjP705tDh3R7iPmCwMI5vMje9bRakviWbKSx/0CQdwzhI1lVjU04dHZp09mfkvOd9+cvftW2NX8OsMacLcAUgFrR7Hd6WlxqM4qwfj6r6ncksTGFctz/EAlnPvKIXlrZOmNTjzjLbG9YfEDiHaqtOJsRnQSjqUoNWJNvSH8+d2XJ65/3v42Ub9zJF5C7NJ9K7huDWRaFvH1KWwz0ajZBeWAzN/Ldo8iQ31ZBUMkC0by3yekPK4s26b44o6CL0gBWoNsKWrGOcEJ+UuQp0MfNyQbFlgGk/4nZ+0nt4ABN/adEFixu/qMJqG+8iLUA/Ob8ut7+mNDwuRex1IXLA7s66t3VkFkIyWX7a75zOgdTcHn/3U3gGY4TcA8V5RKOa3KLC8OYtYptXodbqZwEOTnWeT/CRFgSN7sVCuc68l8JYIrFJZQLJ/ICtHCsxe2/lBJAVTVLJUjM2HahP82MeFz08UDP43wb8yzonmzZgaP1QzL7/m0nDCFCAW/ikgnDc2gysZFo0Mu2wtj2VXwMnjr1k5x1dtzYwH3CAG9jae2SFrXtqUzOtT6XSi2eliALxoCkQwnGlHDtAmcbwgdr5pcej0Pk8hE3WJkTBzc1QUa4AfLhTw5C12FpxDUA6RXz9yip/cKtsnCye80AL9wBSVZNu8v+BrJGwK
 Tz7mmp5u
 m+81H3GvwPPgU4bO6pHkuzkkICpZhvA1oxmIVrBgtLRjfXeDHo7SjgBQ4DiDbNn0MZjPGs8SkqCBP2L4aSbHxZvlldomDr2r3YHAJpk0NY2rhLa78OUrQl/nZDjFAzV7ovDZcQtp5dRnX+f4sJ2/rCznx3+OG1eus68Nh8/63y6lC1IqJFNS/fHR8EYqUYJtW8W3qPRNK9x9gX7m8qaCwtPEd9u+yLml/FeUsj0buAS0FCQEZxe1QVocHbMHnKbS8azy2Oub6xDkxvYAfNbJMPwwhMRTgWSR/7GqQ39MzPhSFc2z8chkT9GvpWt5xXtRouNNK7j27P9qe67YknffA3+QcvqfUZu1rM4MeBHKjEsdL9CfxAnZlviDuXRtr65EXATajaYpSd8xGtRvmxtYJ1m3QYyPcmu/S9td3YajAeatvize6zlL7UARP1jum2wSykJ2Oa3/bTR4XZUPP7A4lvoxT2CmS0Pp/cqqCZs0TGWkxbWRgv8BvBWXrDXECpNQsC5PlcDJt67wWFhq0DVYj5Txvc2ak8evZcy5d8PlMZHsYqBZxA1+4uTBvJCYb1TFln+w7E9DEVkW5njjCIET8CRfh3mk3NhXTbxigI00JcE90YeXf0cxEdQ9r7voezhYlTilcoz4lMHXLtV4Q02BhCZj1jYrfTxsNR85YZfT9YKfC0QT2MFXl+dHIsNhJxQVha4oJ
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
 arch/riscv/include/asm/percpu.h      | 14 ++++++++++++++
 arch/riscv/include/asm/switch_to.h   |  9 +++++++++
 arch/riscv/include/asm/thread_info.h |  3 ++-
 arch/riscv/kernel/asm-offsets.c      |  2 +-
 arch/riscv/kernel/smpboot.c          | 10 +++++++++-
 arch/riscv/net/bpf_jit_comp64.c      |  9 +--------
 7 files changed, 37 insertions(+), 16 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

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
new file mode 100644
index 0000000000000..faf9a75ec66d7
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <linux/thread_info.h>
+
+#include <asm/current.h>
+
+#define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
+
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
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


