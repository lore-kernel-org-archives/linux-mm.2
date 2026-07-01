Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E00C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9B76B00AB; Wed,  1 Jul 2026 08:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9813C6B00AC; Wed,  1 Jul 2026 08:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A176B00AD; Wed,  1 Jul 2026 08:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 578936B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:31:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D39B61C2E43
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:31:09 +0000 (UTC)
X-FDA: 84940142658.26.54395A4
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 660A8A000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:31:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XQDKbiLf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782909068;
	b=FEq7PeJxmMNUwYDmFg3EneB7EswYP787GeBhGHxZGfXtidLx+Gsl8MAvPivX7anDtCBVC/
	J/C2UNQJYZ8hkxQyzfnuodl4FvfQqXUcU+30e4fZLeP41Wtcg6L3fc2b23frcGj/UL05hi
	4jd639N9crXcy981sc3TdoaNguo4tOM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782909068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAJaR5LSpJ3CnGjWltmSLzlT17UwWjJ4qSirL9f+0QE=;
	b=dGm9airX2DWWK0iud40PiKSffdc/2CKlwvegy2gPcd+rA1kz0c5B3Rsgm4sfdhqLyfPpvV
	MBzkxwxW6nrZ7UncuCtpNXSRdw3+lSvpGzYbBTFlTEEqlLKacHXwePbnh2HaZI9Ws45Uw4
	ZXu9evdu1WRzqlbpx5N/TwFCzb0AoDE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XQDKbiLf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-37e4098e920so336610a91.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 05:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782909065; x=1783513865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cAJaR5LSpJ3CnGjWltmSLzlT17UwWjJ4qSirL9f+0QE=;
        b=XQDKbiLfJKTOHrjfcB5R/ldEXldnw5Yi99NJvVri8mi1Lang1om/1eLPgcETDNpz50
         rrTyg0HSRfOJawIHrdVKX/ADbk0JrDW3TMltaeYFcEXM6pw9n4mwH6HtMNH0eFg+jWPg
         6xdx905EEvlePRzuZqEZLbms2O6qMjOnIhTt/8DkepMCqqb+dwY5EfwTKxZadyQYMf0l
         1iOyD4E3eTNpphfGvfQL+LeFgdLx/egIy5Wh3EoqYDeez4D1FZUZOJKkDEYnzEEAC4/e
         eTXfLeDXm7eog298l+gQQg0bkNfCF1EF2aWS/yJa4xV2CnjJykFSIAPNpSVTdRxWNGdZ
         A/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909065; x=1783513865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cAJaR5LSpJ3CnGjWltmSLzlT17UwWjJ4qSirL9f+0QE=;
        b=qa948IPCumLxRaXK3AIQMJ1RAW7B5QMaka7lTm/ei8Xirn+BoNGkl1wF+oWH/Sj449
         U+iNR3dJstUJQXCDdcp4UgRs7dmEL2kkcNamdoDS+6eJuZfs+dN5IzWaoS119fLXosQg
         gmA1THb4ZPOUwh4ofQVoJviyGQ89k1pJvTXlUTbdnrGE2A/9suT63i1LK2UE1UXZ4WPN
         TKasTayu1iyxNIzn9YrLOMm8ip0/sfcQfY50UCaKj7/p85MjzVcs5g32ebBe534NcvsK
         +VemqOIfzt4COZol4wttzhtXOY3ckmTg//bFBh86j4WZzdz7qYN1TSxGyFhex7VnW2nZ
         0WCA==
X-Forwarded-Encrypted: i=1; AHgh+RrD/14eOdFb0b8cXc8zn2AvLOkoo17cINUgz5ioZDtTMjjY5hCe8OpGGmHkB+79iuySD2LbwIe/ig==@kvack.org
X-Gm-Message-State: AOJu0YxxrTPgl+Simtj80djqUuQF761AkABCp1BWymR9jp27V7/yGwtA
	DwjpKO3DeekMStTBL3fSFGm1K7L1ndzqZcAyREiFoOHnhGTaFWE4vEXUI6pyve0Cgq0=
X-Gm-Gg: AfdE7cmeu2Bv07m/11tJy9iEOoGBUCAbthfPcE49j0GpYSTovKf1rUNAuqZfWxtRWE6
	2nV89QS6Noxnrdmw/PbAcSNlFQO2bNrObchA2YxoaK4drNsNE1Gdm/jMIqFv7YQaXSmBxUfSMb5
	jjUjgk43BrRH9OtTPe+mTC/udKkZLBpbvobrZdy0yumwTj1Zro4lbUnFWbePoWJNUUELAmJoUV4
	B5eCCDunNEWUH/azzja5ErcNPtqQSWBKBJ3gpqXWH7lWpyJTNUgKCaywQeNQiGJLvFTbZ6gYshq
	mzTVZXTLm+K6mj0wU+ZgdQyYOT4BAebBpxAECH7gNCj17FXNJBVBbkAWJs60Y61ClF5QGDHhRmU
	0JhCWojVjY9PFn1ZZVFZiIYrt22W2nQsXOnTu4ZfvScea5W3VhrtJEGUZM5dYjYBnmiw4E+MqoY
	G2XIX1dNfXx2otPROt+YR5sKmgSDVF+exJaxatm5EAdnN27A==
X-Received: by 2002:a17:90a:d44b:b0:37c:7090:821b with SMTP id 98e67ed59e1d1-380aa0f436amr1235947a91.10.1782909065079;
        Wed, 01 Jul 2026 05:31:05 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca4bae1e2asm25166825ad.73.2026.07.01.05.30.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 05:31:04 -0700 (PDT)
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
Subject: [PATCH v6 2/3] riscv: introduce percpu.h into include/asm
Date: Wed,  1 Jul 2026 20:29:47 +0800
Message-Id: <20260701122948.57584-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260701122948.57584-1-cuiyunhui@bytedance.com>
References: <20260701122948.57584-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 660A8A000E
X-Stat-Signature: knemtmqu4sxr1z1sedrchg7o18juqsd3
X-HE-Tag: 1782909066-6142
X-HE-Meta: U2FsdGVkX198SFogoyiKARERwsSce5jWkggBs0AaPsQLZHxQCOtfYCQRepJcOaoq7yVIFxjy6kEUW6WpIxWzQwTkUC33s6By1HJnfoMeBp+W6YWB+SXFGfgHluV90VJPnYfBk8+RGC+9zf5esRnL/TP4ewdKGQ0RxEq+QesM8pI/Jih1VQrEAcH/a/n3RdtaDT7HdGB1fbvcb7fMs5Q0KiD0dNlUBGsp6UdDOoa36U5/djo+Rlz5s8UpyfIuajwejEQCxtg1GKSuL22+KppbEvXGg2TOwd9HHZTzMH9H6+0YdaXyjxAK+6251OMDPiSwjBoqLAXiqM87qlPInbkpjkxAMxqBxF/WObSJKAIkWj1dW9fWF6xlS+D5lPXtNrfyOrswFhlk3++Rljd68TLB+dX6RmZfa8hYFFNjAldOXmgvWV/FqwL8ThZW2oxpxbdIv59A48bwl3uwQXC42us/wJ0yoSAJvVXbhnI6qL4x7cecu6OWfOTPOnotYgh4F7ZNRAKJEBv25irexnutKAD3IQSZzNGHEYE90NhmmRkC8+ZBBcuyV0r2A5A3Uuh0nbQNu+iIW2nyLo3CApQzshHNFqeG5hKjlAgsqI7j69gTIDmvrA6kXxjtKQZC5W6JwUYbLF21+DswrW6FCNafxmzm8pD+bonCZIEeTu/6G1GrW32xSgxGSKqFQyCKOOD4cWX3WByGxsenvUnT3UMkJH0/oYezmFjTco3JcgHWHhLtoy49DeiJhl9d47LzxUqPKqpVLizSbsSr6rRxx1A0pPIYUA79ThWzwxiv/5EtgnbP5ok+8lU0lKcaBdJYvNPLw0sPxE1hHzPWWpkRMa+D1YTcRYp5MPgpCK83Bs36V7e5b3caqcljrlnbZzgUiqHK/jkY5Gh7AHl4uKr89oHiD5XUEZfRZTP7K+W0B/sLoWrXMjvqmwC+dcs5Ks99r2TUozpV9I/0JtQX2wzXsrCjuzl
 2laqKoBT
 Buw5WZhMxHGT07bixvEtrAMV4Ts7udKA1uLsRzmyTCiHveM/fNbGkzZQJ7gNQLHl/wathzPvpAvlZJGVWLoOlIjMyYnC0JtBEKVF1saSX6UqZZeFe8nO0stOGEIQL7OPM58YwK7c+O93zS6HEzb+4hlh6I1L9sR18yqr3mNJLobQO5dx/b8POoLPS3MitCHgvUW/1ZqUBbrgwXIEoI6bsIoH/2g6G7pWMrZAfDjps6FhPDsGUqIeGXAwAAMDuCXIHh1ZVFutLyRpilQUd80DdCLwtC0J2+c8EFfRdgNY8kku1LQ5sRlaevv8lFtHw6dySxsMqqlBqVvh+fmXAHTvcMt6B/VGbM9XGD7+0uwShsPuucgi+JCOPuslb/KIupH05rufunnoFyNYhOIifA0B9lUYKP365skc9TjoROSDxwhrESZ0=
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
 arch/riscv/include/asm/percpu.h | 284 ++++++++++++++++++++++++++++++++
 1 file changed, 284 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..34483253e946f
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,284 @@
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
+		val_type field;								\
+												\
+		asm volatile (									\
+			"0: lr.w %0, %2\n"							\
+			"and %3, %0, %4\n"							\
+			"srl %3, %3, %5\n"							\
+			#asm_op " %3, %3, %6\n"							\
+			"and %3, %3, %8\n"						\
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
+PERCPU_OP_8_16(andnot, and, ~(val), and)
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
+#define this_cpu_and_1(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_8, pcp, ~(val))
+#define this_cpu_and_2(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_16, pcp, ~(val))
+#define this_cpu_and_4(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_32, pcp, val)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_and_8(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_64, pcp, val)
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
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
-- 
2.39.5


