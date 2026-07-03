Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 440C1C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36DE6B00B4; Fri,  3 Jul 2026 08:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E006B00B7; Fri,  3 Jul 2026 08:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C242A6B00B8; Fri,  3 Jul 2026 08:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6297F6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:29:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 866D6120519
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:30 +0000 (UTC)
X-FDA: 84947396100.10.FAE0508
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7A56B8000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bAP0Uwz2;
	spf=pass (imf30.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081768;
	b=lOhiOw05NoAH0iDsLgeZ+CCwOSzX//HkjXewt/mgE+B8YIPgZHXfI9MkX9d/i3W0iBW1o1
	KbuSchP5r2rwGNN6W0BEc7GaLVYYk1iTTvj/bRppIJpTz/+WViQ3Avn7PKguYa9GjrFJhR
	a1tmPhW7EOW6fv3VkYa5l8q32Ywd/x8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1+gFKW+hS3rC0joaH/H8WLhsT6tdelp56PcQVXSPXM=;
	b=eb/B9vUw+e+yL/boRnPTGHZUjgG6AFiN3KTTqoMFWyQBK4tb7nSSRKeyn9zU9TR8Uo233N
	Cbj76MKdyDYHo4m5Dp4kFs6WHWXt8+LjwSwyLvoO7kZhYg6czFYg3MFlfmdQdoKt6C068a
	zSGuTWw4T5Y4R/Ilbu4jBqW+qc1gcq4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bAP0Uwz2;
	spf=pass (imf30.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so532132a12.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1783081767; x=1783686567; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P1+gFKW+hS3rC0joaH/H8WLhsT6tdelp56PcQVXSPXM=;
        b=bAP0Uwz2rPHu9DlGdLAVAeQN34ZVNFd0N4ku21tSyocOo29kL+MsVmcSdy91IKuP+M
         1l03zgHzYm4i0lhuOjuzva4HyjXTEF0ghgivsOdi4McmZCZPtm6h1J4O15sHAYA/TU6L
         Xtvt4IekECcxjhdLCKeTDDQ3+bs920Nl5jfZACVpWYV24HFNnzW/a2lx+POYFEawx3jR
         kSvV5UHw4ZzZ2eVasDWbsOMPHKF6nYAzcdXRSEkemiTLj1D6RHoZaM4navepWwp1XIo6
         wLhrp+OgvFPZKoRw5gWSZlGeBbIKfUQ/0zawDXHHjTLqCpsBtHyb2xnqLttZf/vBA/WY
         1WSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081767; x=1783686567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P1+gFKW+hS3rC0joaH/H8WLhsT6tdelp56PcQVXSPXM=;
        b=rOzPXXXgFTYqnPfrxW+l9JHc4UuVatLtaX1fa6IJpiZ5ouDjkkFMXp1QIFi3AajIzF
         Bx/2AAUsKsxSRDSgw2cGIPOE5iiCWvaW/MP+Jzbw0VFAgkznMVnCHqcH0zVfwBygXqfO
         Vocrg+UwmgKof1hqmk0skzjRYYVZjDzZ/bSFTF7axrnXIOreZC5MfSYyBXCTi7mSatcT
         pSIW0/Upf4TvcjBJUIRveuQGeDKSWXNdPScMbsdmOaKol5wYy/sontH+8G9cgUIL+DrL
         FBr8A1Ru/Jlt4GMoYVUJldNTJY304zw2KqhYNZ//nsx3IbYJH471WN8M+h8wntBp8TIA
         yLDw==
X-Forwarded-Encrypted: i=1; AFNElJ9hGxdqpTDw+Piovg+uXq6E5ODSV+ejKgDZlGT3HqrWdjXyIc+2hkClbtCt8PEJfOMRCAb+8lYGYw==@kvack.org
X-Gm-Message-State: AOJu0Yykl64UEz8UQP5iaQqeSl+FXs0MoUsQ+GvOijm0JjckbxmxCK3s
	2i7mI9z7yAdkZ9XL74E7GidH8PFLzC/McJs63wTl1aLQ0JIvLFU09KC7GMWwt5qQ6hs=
X-Gm-Gg: AfdE7cmO0cGvdqxwgNG4sv7Ul6fdRMbPuxWLVJEjfWLm7iqFjjFKmpoVxbFKE1xYFEm
	oWHldDVHl3B4cgQVXGArY+BlHljAoKb/TWDtqoe/HH76JD1YYM9zKEqVzuyIdO6hHvpJ+c4zPhg
	nv9BCYKOdDyAGMPeIpFDpz+QRiHNJ65DgCPKDB2ALgvQPSfDNsG4VPq4uvsg8vqtLGgzI5wlH8r
	jz3mNp6NWa8EoRafcXzXHsu5cDQaWa9EzvSNT/hIerx+qC6hbSZjqQ715Y6HoW70ozLlsgj0pu/
	BNIroX0x0u9qwMUE4JV8f/RD0zm1cViQUoWa8uz/9j0SYhVTUoGPeDIgFwq7jmispX86jWk9UfE
	YguK1e5IfOzg5RSU1hUAq43vqjX6oKJ/aMI1wqDH5Vsn4MwluWFIzoG9RjvG9U+Q5GP/17b7q69
	5qGM2ZzoJP8ea+jUv8TpXX2OfPw4/M/pqHGMz/TbGhNful6aLNDRw=
X-Received: by 2002:a05:6a20:4327:b0:3bf:6363:11c9 with SMTP id adf61e73a8af0-3bff3ffd7b4mr11172094637.1.1783081767222;
        Fri, 03 Jul 2026 05:29:27 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8f3d74ccsm2705551a12.9.2026.07.03.05.29.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Jul 2026 05:29:26 -0700 (PDT)
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
Subject: [PATCH v8 2/3] riscv: introduce percpu.h into include/asm
Date: Fri,  3 Jul 2026 20:28:31 +0800
Message-Id: <20260703122832.15984-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260703122832.15984-1-cuiyunhui@bytedance.com>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A56B8000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: c38o7sfngrydq5qk47b56xp46oosfj6q
X-HE-Tag: 1783081768-947750
X-HE-Meta: U2FsdGVkX1+AofBDgapFag/I8yltg0e7u2sFCjqwnX+Ljc+DHCMTkScKY5YdmxDhaDvQH8fMCZSuObjBwGk7GmLa8hHTOfWj7f5yza3hCslzVEeRV/RE46eWk0i4g5bQACXmwrETHFV8IWruX0UsoCWmK8VYvn5dkcBkBn7Ou+7aYS8B1F/JDfJiWPWLcUkV+POGsgozw+BcDFdKHB89TbhWNPF0Nm3VgpiU9ltaUuYysbHDdIaNO9phvMdInWW4i/6LOVc35IJsTUKjCOJFE17CCUKcqJCJeYHKlBzrisebGviL6Ced6oc7NaYPYMwQ14n2Ex9hwV/TSsbypguAu5qS7xiO7Y+xj5y7oG4H7HVaGM3gsklKz1nH0vSPOH43q2MK0j5ljwBQrqQCu6+Ce7d4L2BypCJHZ8z1Mh63HxRUrpq/4+GiHU3KYzqb5SlFVi3ivugw22idz4TpepdbdSglpGmQbjjYbysb5r8+mJsDSM+98mYkJzFzMSkC7gZDSAq7iHRcXfu65JcJUZoBMPqdLnWSkYxCmegHHKZsnGPPsNpoxhOZCCScQ5La9fkLFaJZC51hVj16GFiYH1CLZigTQmS9V+jeN5/FXIRi2wOyjXLZHJS/cgomVW3gPd9X3Kmd2dJRJlFLbAiDs2uHMHl+S9XXlSUppBxu+0DDU2sqYOorlhwfadM7DJZMsle3eL4h4Gd+Q8nAZ8XaDcjun3y4tpbpFzoEPUtF8ezUVdO6Aco1IkeomMX4S8KfhMrUigxWwWH3IJ0NyfJZEoPgExGx7Ca+1/ogDg/bWTGMWPZoELRuopp6oJr4SsJwIpymr/PLHbv9wof6Kwdtbbo/HJ7NgJcTtuP02B4SGO4DuKGrksfvZBTtNif9ieUI0yqgvfb72bJs0MwLIhd9L3XLIz63t64qpP7U7RP1rZc1i++jOBMcPj7uGSjyHq18HrQz36w06zY7zaWYMNGhGqG
 nwCSIPrj
 L15IV+SXb4aRDgXLvfq/P6vNegbWnTVv0ql92Nmwc+6wsH6mHsjbFQQ6yh3PFX7d6CpNXO3CZUMJsqWtd14JhUJ4Jqc1w1hVjWCgXaHIQ/2uJuJ5MrhgRdFPizl58zCHNlrEhMA6O1LNDdxh/Pu7ATggwuO1B2UWbU91+gFoWEfvianvVrbFD/qKqhzctP01ohESYq2VkpIKppZAh84xRDV1Gny10aZq/02gOLJCCK7dMmoUA0J2swovb2TAW5eyKUl7vldDIattZdTRFc2LneT7nsUEwVYVx4gxubAinoqKCINhRTz5IrbjdfcQ76HCXpYa8LuKS7PYOcUNFpNSEV1iFY702xKRYMTbd2TN1lS8okcqxkkYqbenpVO1LZqNwEpCBWu8Miu8fjQZUMJLGbBgNDWjdOtdwLsIVRobdCJ8R9Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add RISC-V specific this_cpu helpers so common percpu operations can use
short architecture sequences instead of the generic implementation.
Native-width operations use AMOs, while 8/16-bit operations use Zabha when
available and a local 32-bit LR/SC fallback otherwise.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 296 ++++++++++++++++++++++++++++++++
 1 file changed, 296 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..76b1b8c1fb953
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,296 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <linux/bits.h>
+#include <linux/preempt.h>
+
+#include <asm/alternative-macros.h>
+#include <asm/cmpxchg.h>
+#include <asm/cpufeature-macros.h>
+#include <asm/hwcap.h>
+
+#define PERCPU_RW_OPS(sz)						\
+static inline unsigned long __percpu_read_##sz(void *ptr)		\
+{									\
+	return READ_ONCE(*(u##sz *)ptr);				\
+}									\
+									\
+static inline void __percpu_write_##sz(void *ptr, unsigned long val)	\
+{									\
+	WRITE_ONCE(*(u##sz *)ptr, (u##sz)val);				\
+}
+
+PERCPU_RW_OPS(8)
+PERCPU_RW_OPS(16)
+PERCPU_RW_OPS(32)
+
+#ifdef CONFIG_64BIT
+PERCPU_RW_OPS(64)
+#endif
+
+#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\
+static inline void							\
+__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
+{									\
+	asm volatile (							\
+		"amo" #amo_insn #sfx " zero, %[val], %[ptr]"		\
+		: [ptr] "+A" (*(u##sz *)ptr)				\
+		: [val] "r" ((u##sz)(val))				\
+		: "memory");						\
+}
+
+#ifdef CONFIG_64BIT
+#define PERCPU_OP(name, amo_insn)					\
+	__PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)			\
+	__PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
+#else
+#define PERCPU_OP(name, amo_insn)					\
+	__PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)
+#endif
+
+PERCPU_OP(add, add)
+PERCPU_OP(and, and)
+PERCPU_OP(or, or)
+
+/*
+ * Currently, only this_cpu_add_return_xxx() requires a return value,
+ * and the PERCPU_RET_OP() does not account for other operations.
+ */
+#define __PERCPU_AMO_RET_OP_CASE(sfx, name, sz, amo_insn)		\
+static inline u##sz							\
+__percpu_##name##_return_amo_case_##sz(void *ptr, unsigned long val)	\
+{									\
+	register u##sz ret;						\
+									\
+	asm volatile (							\
+		"amo" #amo_insn #sfx " %[ret], %[val], %[ptr]"		\
+		: [ptr] "+A" (*(u##sz *)ptr), [ret] "=r" (ret)		\
+		: [val] "r" ((u##sz)(val))				\
+		: "memory");						\
+									\
+	return ret + val;						\
+}
+
+#ifdef CONFIG_64BIT
+#define PERCPU_RET_OP(name, amo_insn)					\
+	__PERCPU_AMO_RET_OP_CASE(.w, name, 32, amo_insn)		\
+	__PERCPU_AMO_RET_OP_CASE(.d, name, 64, amo_insn)
+#else
+#define PERCPU_RET_OP(name, amo_insn)					\
+	__PERCPU_AMO_RET_OP_CASE(.w, name, 32, amo_insn)
+#endif
+
+PERCPU_RET_OP(add, add)
+
+#define PERCPU_8_16_GET_SHIFT(ptr)	(((unsigned long)(ptr) & 0x3) * BITS_PER_BYTE)
+#define PERCPU_8_16_GET_MASK(sz)	GENMASK((sz) - 1, 0)
+#define PERCPU_8_16_GET_PTR32(ptr)	((u32 *)((unsigned long)(ptr) & ~0x3))
+
+#define PERCPU_8_16_OP(name, amo_insn, sz, sfx, val_type, new_val_expr, asm_op)			\
+static inline void __percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
+{												\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&						\
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {				\
+		asm volatile ("amo" #amo_insn #sfx " zero, %[val], %[ptr]"			\
+			: [ptr] "+A"(*(val_type *)ptr)						\
+			: [val] "r"((val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz)))	\
+			: "memory");								\
+	} else {										\
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
+		const u32 mask = PERCPU_8_16_GET_MASK(sz) << shift;				\
+		const val_type val_trunc = (val_type)((new_val_expr)				\
+					   & PERCPU_8_16_GET_MASK(sz));				\
+		u32 old, new;									\
+		val_type field;									\
+												\
+		asm volatile (									\
+			"0: lr.w %0, %2\n"							\
+			"and %3, %0, %4\n"							\
+			"srl %3, %3, %5\n"							\
+			#asm_op " %3, %3, %6\n"							\
+			"and %3, %3, %8\n"							\
+			"sll %3, %3, %5\n"							\
+			"and %1, %0, %7\n"							\
+			"or %1, %1, %3\n"							\
+			"sc.w %1, %1, %2\n"							\
+			"bnez %1, 0b\n"								\
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)			\
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),			\
+			  "r"(PERCPU_8_16_GET_MASK(sz))						\
+			: "memory");								\
+		}										\
+}
+
+#define PERCPU_OP_8_16(op_name, op, expr, final_op)			\
+	PERCPU_8_16_OP(op_name, op, 8, .b, u8, expr, final_op);		\
+	PERCPU_8_16_OP(op_name, op, 16, .h, u16, expr, final_op)
+
+PERCPU_OP_8_16(add, add, val, add)
+PERCPU_OP_8_16(and, and, val, and)
+PERCPU_OP_8_16(or, or, val, or)
+
+#define PERCPU_8_16_RET_OP(name, amo_insn, sz, sfx, val_type, new_val_expr)			\
+static inline val_type __percpu_##name##_return_amo_case_##sz(void *ptr, unsigned long val)	\
+{												\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&						\
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {				\
+		register val_type ret;								\
+		asm volatile ("amo" #amo_insn #sfx " %[ret], %[val], %[ptr]"			\
+			: [ptr] "+A"(*(val_type *)ptr), [ret] "=r"(ret)				\
+			: [val] "r"((val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz)))	\
+			: "memory");								\
+		return ret + (val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz));		\
+	} else {										\
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
+		const u32 mask = (PERCPU_8_16_GET_MASK(sz) << shift);				\
+		const u32 inv_mask = ~mask;							\
+		const val_type val_trunc = (val_type)((new_val_expr)				\
+					   & PERCPU_8_16_GET_MASK(sz));				\
+		u32 old, new, field;								\
+												\
+		asm volatile (									\
+			"0: lr.w %0, %3\n"							\
+			"and %1, %0, %4\n"							\
+			"srl %1, %1, %5\n"							\
+			"add %1, %1, %6\n"							\
+			"and %1, %1, %7\n"							\
+			"sll %1, %1, %5\n"							\
+			"and %2, %0, %8\n"							\
+			"or %2, %2, %1\n"							\
+			"sc.w %2, %2, %3\n"							\
+			"bnez %2, 0b\n"								\
+			: "=&r"(old), "=&r"(field), "=&r"(new), "+A"(*ptr32)			\
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(PERCPU_8_16_GET_MASK(sz)), \
+			"r"(inv_mask)								\
+			: "memory");								\
+		return (val_type)(field >> shift);						\
+	}											\
+}
+
+PERCPU_8_16_RET_OP(add, add, 8, .b, u8, val)
+PERCPU_8_16_RET_OP(add, add, 16, .h, u16, val)
+
+#define _pcp_protect(op, pcp, ...)					\
+({									\
+	preempt_disable_notrace();					\
+	op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);				\
+	preempt_enable_notrace();					\
+})
+
+#define _pcp_protect_return(op, pcp, args...)				\
+({									\
+	typeof(pcp) __retval;						\
+	preempt_disable_notrace();					\
+	__retval = (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);	\
+	preempt_enable_notrace();					\
+	__retval;							\
+})
+
+#define this_cpu_read_1(pcp)		_pcp_protect_return(__percpu_read_8, pcp)
+#define this_cpu_read_2(pcp)		_pcp_protect_return(__percpu_read_16, pcp)
+#define this_cpu_read_4(pcp)		_pcp_protect_return(__percpu_read_32, pcp)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_read_8(pcp)		_pcp_protect_return(__percpu_read_64, pcp)
+#endif
+
+#define this_cpu_write_1(pcp, val)	_pcp_protect(__percpu_write_8, pcp, (unsigned long)val)
+#define this_cpu_write_2(pcp, val)	_pcp_protect(__percpu_write_16, pcp, (unsigned long)val)
+#define this_cpu_write_4(pcp, val)	_pcp_protect(__percpu_write_32, pcp, (unsigned long)val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_write_8(pcp, val)	_pcp_protect(__percpu_write_64, pcp, (unsigned long)val)
+#endif
+
+#define this_cpu_add_1(pcp, val)	_pcp_protect(__percpu_add_amo_case_8, pcp, val)
+#define this_cpu_add_2(pcp, val)	_pcp_protect(__percpu_add_amo_case_16, pcp, val)
+#define this_cpu_add_4(pcp, val)	_pcp_protect(__percpu_add_amo_case_32, pcp, val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_add_8(pcp, val)	_pcp_protect(__percpu_add_amo_case_64, pcp, val)
+#endif
+
+#define this_cpu_add_return_1(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_8, pcp, val)
+
+#define this_cpu_add_return_2(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_16, pcp, val)
+
+#define this_cpu_add_return_4(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_32, pcp, val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_add_return_8(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
+#endif
+
+#define this_cpu_and_1(pcp, val)	_pcp_protect(__percpu_and_amo_case_8, pcp, val)
+#define this_cpu_and_2(pcp, val)	_pcp_protect(__percpu_and_amo_case_16, pcp, val)
+#define this_cpu_and_4(pcp, val)	_pcp_protect(__percpu_and_amo_case_32, pcp, val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_and_8(pcp, val)	_pcp_protect(__percpu_and_amo_case_64, pcp, val)
+#endif
+
+#define this_cpu_or_1(pcp, val)	_pcp_protect(__percpu_or_amo_case_8, pcp, val)
+#define this_cpu_or_2(pcp, val)	_pcp_protect(__percpu_or_amo_case_16, pcp, val)
+#define this_cpu_or_4(pcp, val)	_pcp_protect(__percpu_or_amo_case_32, pcp, val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_or_8(pcp, val)	_pcp_protect(__percpu_or_amo_case_64, pcp, val)
+#endif
+
+#define this_cpu_xchg_1(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_2(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_4(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_xchg_8(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#endif
+
+#define this_cpu_cmpxchg_1(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_2(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_4(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_cmpxchg_8(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+
+#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
+#endif
+
+#ifdef system_has_cmpxchg128
+#define this_cpu_cmpxchg128(pcp, o, n)					\
+({									\
+	u128 ret__;							\
+	typeof(pcp) *ptr__;						\
+									\
+	preempt_disable_notrace();					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
+	if (system_has_cmpxchg128())					\
+		ret__ = cmpxchg128_local(ptr__, (o), (n));		\
+	else								\
+		ret__ = this_cpu_generic_cmpxchg(pcp, (o), (n));	\
+	preempt_enable_notrace();					\
+	ret__;								\
+})
+#endif
+
+#undef PERCPU_RW_OPS
+#undef __PERCPU_AMO_OP_CASE
+#undef PERCPU_OP
+#undef __PERCPU_AMO_RET_OP_CASE
+#undef PERCPU_RET_OP
+#undef PERCPU_8_16_GET_SHIFT
+#undef PERCPU_8_16_GET_MASK
+#undef PERCPU_8_16_GET_PTR32
+#undef PERCPU_8_16_OP
+#undef PERCPU_OP_8_16
+#undef PERCPU_8_16_RET_OP
+
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
-- 
2.39.5


