Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D312D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41CF6B000A; Sun,  7 Dec 2025 22:50:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19966B000C; Sun,  7 Dec 2025 22:50:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1616B000D; Sun,  7 Dec 2025 22:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB70A6B000A
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:50:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66357134606
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:40 +0000 (UTC)
X-FDA: 84194927040.29.72066AB
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5754F180012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ivDyptUH;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765165838; a=rsa-sha256;
	cv=none;
	b=7NOji/1JuTC/wY1MOnGCPpdm+F68tOlGCf61s18FHSju3DEhGmw3a7W+tVv5iFQMdOJWOq
	Ky6PtTKAYEWhUXSZN78Ez/mJFO1pBX4ltdJXdjoEBVgsJ75taaXFd8Fz/9bwRAqs/FzT0r
	JaRckIszNNRUfuZpoWMvkS4ur5eclok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765165838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcDdbeyUjaIQvBTZiz9kFlENYKGodkKBU6I+HMWpHSE=;
	b=3V7M/Q+S9hEYtE2v/gtQbilZAyMjNGhGQE8XEgWn7piEdNFfbbgBVMvJwx3XlGkEkMoLH1
	0AwKQsAOUaz5+T9zYXHsA0g25QVXlJCaPb0vvvoA+xsI3Hxxyfl9fFMJwr2Ak5RS1RMVjI
	Y85UxOow2xa3tkUx4mkk097dKy7Nanw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ivDyptUH;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-298145fe27eso62188775ad.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 19:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765165837; x=1765770637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TcDdbeyUjaIQvBTZiz9kFlENYKGodkKBU6I+HMWpHSE=;
        b=ivDyptUHK02bGd7YMPOsyfvMygsVjjl1x7o5C7ZpgBJ/6EWV3+gRnoYSv/9VX9HSMG
         jeo758Q6IFW3+DtwxwFppwnBEkmOlH8kC3EQ/WJQgnaJ4uioZr0vnYYjO6EP3J/uSUwc
         5DQbnQrqftWb/BvsRq6xQWZAbLTSJY9s+VfTVBDivDIZw7drajlfb3eSMdgT4Xg0hOwZ
         AaYFcEcQpjNel5OAEHcdg8ofQAoGS7l9/7ifVGGgFgReLGhY6b4BhOU2Gr7pkyEq2fYX
         615xFImbDP/Xvls9HgE3Q6CiXAfcoq5dhLUxeTjcxNJHHWfO+MLAiBGZl8xHq3Vzh7vU
         YhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765165837; x=1765770637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TcDdbeyUjaIQvBTZiz9kFlENYKGodkKBU6I+HMWpHSE=;
        b=Kez3Uppp9EJvjcdNab8OF3NOM5IQqMJ1cga8/0nGBrYA8ST+Q78TE0Ft54qBAw+hrT
         /G+c+lQc18A723KyeSt/0kAF7TgivYVsvpseKsqh8tWepAIGbmteYpYsLQxsk8T2ATEu
         smICx94t8VH7co56Icsu4HqvwUhBOAyfk7pGlXp8du378ojRIYhscW6AuE8XN9O20Nal
         FXCFfwg+adhjggMOUlPqMApoo3FO56WO6ZU6lgdzehM3zp99XhURRaEC5opuSx6fw5yz
         1kURakGuKzlck7EEN7C85FQ8nCMNDsRNX0NQwRDCN2npcbdDi+kLH9d94Qekv59pIx3X
         vVQw==
X-Forwarded-Encrypted: i=1; AJvYcCXEZp+ZLjm0tb5/b0ZqBJWxv4gO86Y3fUvQ100VoFIKKdXb+/jrlYWUa75Ztnjux1dPDMI9dgQXHw==@kvack.org
X-Gm-Message-State: AOJu0YwdJwwf07bwapboUTzbztrb8/ncO9yAUpVbXn6/ZwgKEvHG7B30
	5oDXgie4NO8QUvVzKBjEnvX+TPui2yE0dxA5lpYggsLPZg4M5bH6WM8KU9Sjo72m/o8=
X-Gm-Gg: ASbGnct08iDQPaGYHi4Pr5/C6vapOP97ZsX7BjynbuL+tNLrbDNgNVDeSi3IqWU6s/2
	fBsQLr0RdHzDlAkY5Y6I2FDf2hxT8SlHZuAQfoU1pfIMImK18Zx3tVpIfROVgWy5vmxS9kgiMY/
	8kMVskfXtC656mMjOaUxnnEvKwfKbjX5/NmNO4NZmZY/Isi8gp2Uxx92bVdX5MHWJkM4E/r5mpz
	QAKL+w0aa1SeEza2gl72XVGyZwpgBr0mdXlFMDBnxvsxYh9O5xltY8cJF+wbz5OImsbf8JXVhbq
	A5UmdGGvTDst0aTSuYKxTtf2JI0EXgphsoELRd3TYD8eSXnjYXJbSnNZdf+NtrvN/MM+GNZGsTQ
	GRBBlN0g1n0uopj8t5P1yOj8NDeG2IilPFPNI0AcpK0qr9JWjLPIRGffQrdiyJbaqfhkMkQSD/r
	EpmATzQFJRSTE0xU14i61Be/eAxEv8bygXrLmLtXytftRc
X-Google-Smtp-Source: AGHT+IEsyS70YjfqcY6uDUzuCw0QsSiDGBq56vWCrB/xumiB1z4Fux5bNgh47wXnVIwNcfKaN47/fA==
X-Received: by 2002:a17:902:cf0f:b0:297:c4b0:8d53 with SMTP id d9443c01a7336-29df5e1b2femr51595245ad.54.1765165836888;
        Sun, 07 Dec 2025 19:50:36 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6d96sm108871275ad.102.2025.12.07.19.50.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Dec 2025 19:50:36 -0800 (PST)
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
Subject: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
Date: Mon,  8 Dec 2025 11:49:43 +0800
Message-Id: <20251208034944.73113-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20251208034944.73113-1-cuiyunhui@bytedance.com>
References: <20251208034944.73113-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5754F180012
X-Stat-Signature: md39us3i69kd9yexcfhhz81mbfcoacgm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765165838-669053
X-HE-Meta: U2FsdGVkX18w33VRD75o7cCBQ8sza/BWQTmkMYx/FNco9mSeKOwHTB+iVdGsUNnQMUTx/WZoND0/j+Xf7pqC2/C5jSG2K3u0TZgkXcPLUOFIjPsIoUBMljcqBP6T60F0K/FbD2hbB2IaY2NgdX71HnWuqpMhpDse2QEWYMmrBbjhQGQwxPIz07qFusXrNMgcnS9BvOwRqv/ZS5cfLul71JBbWWxlj2G/Cl0E8zQrlxPfViCmu0rYT0MGWnvKw05rZWm67EV0wJuaZGJDy9Nu8Fn9yEORulg2Mtmwt+Ae2H79ZkFGAMZqIEGrQVIS4Yl2lr1ncDybbY43SzA/WiyuP9JkWjIAcI1Zu9nv9MGetQMs9kqTE7CE3SSA1kc/n7WJXIH/10gJawwriUgkYohenexZm8Pz+7TBDthKyjHqgGT3aQiAP0jDX8jFZlX+kVoiT6vBClVaMZCDJzw3VFvI88qi3B3EEQh9gK/ol/kDZ8Vek9INpmH2SiD5//HV3/jPzrKa6cilvHkPEAg6zcMH3fONkGuky1qE6btxu1xC+0RFn0tOuUHSAQFg5eCSE3WPi1a5UqI7nQr3hiw/Rpl6aMG38fHI73d7Y1Sq5FNf69nQ3wWwA9tzqCnk4s5EQQRoCId6yQzlV58Q7A9bmTucH5LZIg/HNK75EV3EUyIfhmxiTaWUsMYW/CFX1zjR7F8b1FaZSMZ5ZFPFszIR1N4SOnlL1MLoVwSBuNuoXMi8Vc2uwhscQuBk2GD2MI9rDSWQSHiSxKfTIQ5OnLa/qTotUWlhg6G+GfTUsZTY0qJYePE+Qck2YKO4M3KCUKFH17xgvqPxX+8+9fSJrdBdrbjSk0xqoQCosr4exwlxU4oDKdvFmWbakavdbMd0alZYJP+w6MQstQBhgd96IYH077bvw4tNvN/FOQ2q0bvio9h0sAJB4Yb97zXEJqXFrdsfG0qDmryZxacdkM8e6AaMUPh
 c0AMQuIY
 A5ZRL/pg4XXMssa9qxzCF3ea3qrnzmHY88HmQCirIyx/TSHi0MzKhv/IJiTfO1LcYUeP3uQ8sQs0B+b+zNgHwMZT4UrDJq/o72Ki+MnLNh6QHDw4v1CzItVoeTupv99EdGJppj5ALxY4Xv0m7OaiKJiWINkDcIH+oweVIU/JIXe2T5Ht+x8xJaWvlJtATUeZStzyqUBJX4U/gj/cvKQJf7bMgmaJbFt5XovOJbFUlqhdV8kG4A48hNOB5wkCq1Bko2ooqFjcBJQtBw5qpHPo+3wQf7HUosegxUZSt0IPyvmSGWOxWs7+QBtjYkUx+Yos2e0soqQwltc9sw71iL9AaRcWdYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current percpu operations rely on generic implementations, where
raw_local_irq_save() introduces substantial overhead. Optimization
is achieved through atomic operations and preemption disabling.

Currently, since RISC-V does not support lr/sc.b/h, when ZABHA is
not supported, lr/sc.w needs to be used instead, which requires
some additional mask operations.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 238 ++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..b173729926126
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,238 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <linux/preempt.h>
+
+#include <asm/alternative-macros.h>
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
+PERCPU_RW_OPS(64)
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
+#define PERCPU_OP(name, amo_insn)					\
+	__PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)			\
+	__PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
+
+PERCPU_OP(add, add)
+PERCPU_OP(andnot, and)
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
+#define PERCPU_RET_OP(name, amo_insn)					\
+	__PERCPU_AMO_RET_OP_CASE(.w, name, 32, amo_insn)		\
+	__PERCPU_AMO_RET_OP_CASE(.d, name, 64, amo_insn)
+
+PERCPU_RET_OP(add, add)
+
+#define PERCPU_8_16_GET_SHIFT(ptr)	(((unsigned long)(ptr) & 0x3) * BITS_PER_BYTE)
+#define PERCPU_8_16_GET_MASK(sz)	GENMASK((sz)-1, 0)
+#define PERCPU_8_16_GET_PTR32(ptr)	((u32 *)((unsigned long)(ptr) & ~0x3))
+
+#define PERCPU_8_16_OP(name, amo_insn, sz, sfx, val_type, new_val_expr, asm_op)			\
+static inline void __percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
+{												\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&						\
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {				\
+		asm volatile ("amo" #amo_insn #sfx " zero, %[val], %[ptr]"			\
+			: [ptr] "+A"(*(val_type *)ptr)						\
+			: [val] "r"((val_type)(new_val_expr))					\
+			: "memory");								\
+	} else {										\
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
+		const u32 mask = PERCPU_8_16_GET_MASK(sz) << shift;				\
+		const val_type val_trunc = (val_type)(new_val_expr);				\
+		u32 retx, rc;									\
+		val_type new_val_type;								\
+												\
+		asm volatile (									\
+			"0: lr.w %0, %2\n"							\
+			"and %3, %0, %4\n"							\
+			"srl %3, %3, %5\n"							\
+			#asm_op " %3, %3, %6\n"							\
+			"sll %3, %3, %5\n"							\
+			"and %1, %0, %7\n"							\
+			"or %1, %1, %3\n"							\
+			"sc.w %1, %1, %2\n"							\
+			"bnez %1, 0b\n"								\
+			: "=&r"(retx), "=&r"(rc), "+A"(*ptr32), "=&r"(new_val_type)		\
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask)			\
+			: "memory");								\
+		}										\
+}
+
+#define PERCPU_OP_8_16(op_name, op, expr, final_op)			\
+	PERCPU_8_16_OP(op_name, op, 8, .b, u8, expr, final_op);		\
+	PERCPU_8_16_OP(op_name, op, 16, .h, u16, expr, final_op)
+
+PERCPU_OP_8_16(add, add, val, add)
+PERCPU_OP_8_16(andnot, and, ~val, and)
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
+			: [val] "r"((val_type)(new_val_expr))					\
+			: "memory");								\
+		return ret + (val_type)(new_val_expr);						\
+	} else {										\
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
+		const u32 mask = (PERCPU_8_16_GET_MASK(sz) << shift);				\
+		const u32 inv_mask = ~mask;							\
+		const val_type val_trunc = (val_type)(new_val_expr);				\
+		u32 old, new, tmp;								\
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
+			: "=r"(old), "=r"(tmp), "=&r"(new), "+A"(*ptr32)			\
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(PERCPU_8_16_GET_MASK(sz)), \
+			"r"(inv_mask)								\
+			: "memory");								\
+		return (val_type)(tmp);								\
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
+#define this_cpu_read_8(pcp)		_pcp_protect_return(__percpu_read_64, pcp)
+
+#define this_cpu_write_1(pcp, val)	_pcp_protect(__percpu_write_8, pcp, (unsigned long)val)
+#define this_cpu_write_2(pcp, val)	_pcp_protect(__percpu_write_16, pcp, (unsigned long)val)
+#define this_cpu_write_4(pcp, val)	_pcp_protect(__percpu_write_32, pcp, (unsigned long)val)
+#define this_cpu_write_8(pcp, val)	_pcp_protect(__percpu_write_64, pcp, (unsigned long)val)
+
+#define this_cpu_add_1(pcp, val)	_pcp_protect(__percpu_add_amo_case_8, pcp, val)
+#define this_cpu_add_2(pcp, val)	_pcp_protect(__percpu_add_amo_case_16, pcp, val)
+#define this_cpu_add_4(pcp, val)	_pcp_protect(__percpu_add_amo_case_32, pcp, val)
+#define this_cpu_add_8(pcp, val)	_pcp_protect(__percpu_add_amo_case_64, pcp, val)
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
+#define this_cpu_add_return_8(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
+
+#define this_cpu_and_1(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_8, pcp, ~val)
+#define this_cpu_and_2(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_16, pcp, ~val)
+#define this_cpu_and_4(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_32, pcp, ~val)
+#define this_cpu_and_8(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_64, pcp, ~val)
+
+#define this_cpu_or_1(pcp, val)	_pcp_protect(__percpu_or_amo_case_8, pcp, val)
+#define this_cpu_or_2(pcp, val)	_pcp_protect(__percpu_or_amo_case_16, pcp, val)
+#define this_cpu_or_4(pcp, val)	_pcp_protect(__percpu_or_amo_case_32, pcp, val)
+#define this_cpu_or_8(pcp, val)	_pcp_protect(__percpu_or_amo_case_64, pcp, val)
+
+#define this_cpu_xchg_1(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_2(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_4(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_8(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+
+#define this_cpu_cmpxchg_1(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_2(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_4(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_8(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+
+#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
+
+#define this_cpu_cmpxchg128(pcp, o, n)					\
+({									\
+	u128 old__, new__, ret__;					\
+	typeof(pcp) *ptr__;						\
+	old__ = o;							\
+	new__ = n;							\
+	preempt_disable_notrace();					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
+	ret__ = cmpxchg128_local(ptr__, old__, new__);			\
+	preempt_enable_notrace();					\
+	ret__;								\
+})
+
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
-- 
2.39.5


