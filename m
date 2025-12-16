Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98FAD5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7FE6B008A; Mon, 15 Dec 2025 20:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B76A6B008C; Mon, 15 Dec 2025 20:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCD26B0092; Mon, 15 Dec 2025 20:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8086B008A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:48:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6C9058CAD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:48:07 +0000 (UTC)
X-FDA: 84223648614.26.318CABB
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0296B18000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:48:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RaOIQa0o;
	spf=pass (imf06.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765849686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ42/sbmz8Lmn/bYYmmjbSafUG0TF5vzn0H0OboHesU=;
	b=xoLxQLEH5k2g68bgHlYE9EnE/rb1KOHMmMhVOVbnpGaCIujpbiCZwEUQeAVwrESP/K2fFZ
	QKyIg0aBzTpNjUplVy1csmUzC3aJzLOxW6xbiADPEKybxwlCsexsjCO843Kcg2WZdbZ7nY
	llfiKCfX/Hdn6NilWSdM3cUUH7n0FrA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RaOIQa0o;
	spf=pass (imf06.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765849686; a=rsa-sha256;
	cv=none;
	b=y9bqy2huIVOpzBwNOYXpiSnyWrnwm2uw/o93Vgg0F8YdplNHvKeOx2ZvGV87gn3oVLGsYI
	Z2580aMC3kXzPXEmpX1/ra+QVUkkJFJX01tprfSK8G7hNhgX/uFol/P8EpVkXahCbEoEOC
	y4i0NFNpxqOzAoLP3ry6Sj7OX/EXdtQ=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7baf61be569so4860972b3a.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765849684; x=1766454484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZ42/sbmz8Lmn/bYYmmjbSafUG0TF5vzn0H0OboHesU=;
        b=RaOIQa0oXMAZg3GBTNbUZBynkj5Yb5NHXezksVAq91ISOnA0oYT/fcFAwVi3mFz7o8
         jw9g5QvWxVrgV9fNfw5h0TRKcDyNyzPwBV9cH/M53k0xV1XklfUr9gL73+YP1ejAIbJk
         CawMJpSO2x+il+moWFr+54hRmKjekbyDFZJ1CJUcS2feBJKMR9Z0+XonYgkUCqtB66PI
         I+FItGS7Mq/cBZohP04LN4nd+E6YZ8avWCXu6ibZoBP+9jqqXf0PteaSptEbtzQyTbkb
         O3cX+Zw/29vEH58WCsO66PLzNtr8XYQl6uWgKh5jAeXnM21gJsvg7qEjabKbtb4aen8A
         rbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765849684; x=1766454484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NZ42/sbmz8Lmn/bYYmmjbSafUG0TF5vzn0H0OboHesU=;
        b=asTlN5i6sgGeB9SL+BaF4szpFDe4yWi4jtIdfuQTIil6jJp7qA7SviriOX46l7WxpS
         6d2Qr07/Qc32JeDsYJKsJTpZOS+ypy20SiCZNhHhvQpE8ksduau8WI5rTin8EqSDS191
         +tQCWc1/q38bjfaayCF0rT5myJ9YnHbqm5vrJ5BOI2RTDJTJlRN6mLarmbQVSbahUHux
         79V4iwFQfzC/vodo1OOuz9RFsCe1WANbYB2lDYnQzbs5Iz3M2Sh0gsH1nOucDPwmpdhg
         SczxqqVFECJGZp03bBRaXxQz3Yi2YhJk3Ae03LMK2CCaYaEaujRG4fJqJ85eH2tnjnKl
         t+TQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBjuxv6aUQ/KMkFsIxfQh4uqxHqB16hcotoK9XgmiFGF5BoSr3lMSVyrJ0faLoSdxvKuqAFNtiLg==@kvack.org
X-Gm-Message-State: AOJu0YwdkEWXeiorgVV/QpbFZWr2kybTRMRKzZb4lSbYuTcv35hDn+bc
	II5cXhJrKTxGJPbgOnXuCkWONFalnUoDgNECA4lEDVpRyjgHomUVEKr44mVTusdNTgI=
X-Gm-Gg: AY/fxX5X3AoEKBDX93fjvxJUPkp/MFBxAk89JQsbijJb5LZtne+hCIFlq9b8auMUdxe
	6k0MnjXhBsRo8zC/rhvF7iLTknju8tKJbT4HmJ7DsSGWjSNU7b0ZDg3HwV4temMZvghLpbWW0+Y
	sNvI+DtJgVHMvBGyGwLlM/aewOFHEMtdmYj3n0SDllwpDk+Rd6tXyjzN/76pAsth7ZIpl1fYXGl
	1S2aqH4qWKuR4kWs/fRgOW5Dfv2UkmdCxYB1pOkNs5+hhXXAS8KJVsLBNdbGSRs5H1h330XSin/
	EpaykxKxRSN7niwbGOor+g0r4+jeYw0/O1YgEVgWxb1XK11Ezd5YnuNYuuTNfCl5HJ51Fn00xwr
	mB1C+gecH6affNB6Bi96LkY4gSg53WZDXmO/2MqQ99RuuAulhNb/rfIhiSopfCQcPiLxwLVWq+C
	W9096LzNfCYi9dDd7DbhBaFb4EnMMZ8A34Ei/SUA+Rbw6GsAsLLOOkT24=
X-Google-Smtp-Source: AGHT+IF0Uf8lvlh30Nn7GSqY/8GMM8obSexPj1wW9Mkh/42IqtKHShPE4ar+CFDAwHgUlgPq1eOrYg==
X-Received: by 2002:a05:6a20:3c8d:b0:366:19cc:c6c9 with SMTP id adf61e73a8af0-369adad03d8mr11818590637.3.1765849684442;
        Mon, 15 Dec 2025 17:48:04 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c963b53sm13632790a12.36.2025.12.15.17.47.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 15 Dec 2025 17:48:02 -0800 (PST)
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
Subject: [PATCH v3 2/3] riscv: introduce percpu.h into include/asm
Date: Tue, 16 Dec 2025 09:47:20 +0800
Message-Id: <20251216014721.42262-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20251216014721.42262-1-cuiyunhui@bytedance.com>
References: <20251216014721.42262-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58xt6cjzsmdijng4ef7ddjr5gjqed5zt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0296B18000C
X-HE-Tag: 1765849685-660969
X-HE-Meta: U2FsdGVkX1/3TvTsPlQOK3PC/qEhDhHCSLbI+LO5fDjL0IMqrA8hJLFLcfjBnI1c2YCTYrUfN4901O8CNPRE2AdsZ3ch0IlR4iAwApemhwT3IZp9dIkqs+8rBI+EAKTRUEd93DQHw9dSNoyb7r84Mr+tLeXwWTmM6vLa2SeEyeJSKcH6p/LQp3coUhPrm0HJkJG7qqTGImQuLeKjWxgfnYYeAUioqp+1wT8mwrdIF+J6M1A1VrAtU35jasEF1VUsDbJhk2+I8spmmh5ky7ukR+9r5dk9kiIx5iOH8bdPBcw39UiOZD6qT8snwv/KPaYmfsIN2hKw1VXqnct4TPyzkjcgrzTF5BoTBj87c+klJnNm7Swqh3VsbpivlwdAVZpFsIRO7WzdryRMBw1GQFHQ1WFlPe9g1INNiusONhwhrp3y3sY4XBHKj5JmDi3cj9jnEH/yUXGGqgzYeFw1Pb1qDUK8HLXBEH7BiMCDkEnPaDE77qDj6QUwKVVb3yE2c6BmjQgHfaBowpEN3fLkGj7rInuuaGoflnT5ZeqhWZ0dr0t3LULBi0DNAJRq1ztdv2MgBAJx1mFAuNVh62LwQmc6Go+NKxMaJ2aGo2xrsJf/94sQKlG7Be2EQb5rw2+3QkJJJQHGktk7SXCcLaZ/fp/mpiMdnFRTB+pPdH1hGOlr3CsYiAWtLSmxXyoU24sanrXx77cMYyfdiO8p95uXYglPa8h7CHIMIizyfjBT1faSNaA8kU7A92pOT52lQ3qop50leJ7ahF+v3NsB17Q8JSxIFg69CzjK8dSxn/X0qdwat7ZRvpKTUzI5S3SbLgHgPiyge3/vxfuQ/yFDf95IfXRW5PhYN9f1w8OY9TCaniFhILx3taHSKHQgDtBPL2ywCj+oOP2gkFmq04h/JXGp5TEnoZFNSmV7BVC2xyahGPRLJQ9nLIFP2fa/53utIEJvLqq6EKNJQVfsUi2gOx+7ySu
 JhKjRfBv
 DqrosbbwHuEf/osWXTs399wBIb7BfM6ua853RVUvE94n4yf0G5HuVJ04/z8OwycaJC+M1NR4fF79K4pd7hPQFWm5Cf4HjReggEqv7vPR8GoJOdNWxgIZIlb8t92vAOeQhNqPxeH010liF3AqNPKHk18ur6ESuM+tWSYzwtd4HNfOzLU0+Cvij2JlWYiuVSZB+WhuIHHrIScnAogsMsbeqN6Mp7oTe8w76uSjmAyXJ8QEkdtXI+5AiIZDsKS0qd7ey+oYYvTTO26o2n448w89eRPxSsiALgDxfLM1V0ZxqjRGZeUUC/NLe83ocxYl7xuL3IBM6+saVI0UmwlMwLhOzneHcqUy3yN5+IeXEQAZn7uU1bjcLC7lnAyPwJr89Mfw8kUJMhc5jB1JJ6h7U+ylEWOkU63yEkGLdRhNL
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
 arch/riscv/include/asm/percpu.h | 244 ++++++++++++++++++++++++++++++++
 1 file changed, 244 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..c5bacf6d864ee
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,244 @@
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
+			: [val] "r"((val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz)))	\
+			: "memory");								\
+	} else {										\
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
+		const u32 mask = PERCPU_8_16_GET_MASK(sz) << shift;				\
+		const val_type val_trunc = (val_type)((new_val_expr)				\
+					   & PERCPU_8_16_GET_MASK(sz));				\
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
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
-- 
2.39.5


