Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53910C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7486B00AB; Wed,  1 Jul 2026 00:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380B56B00AC; Wed,  1 Jul 2026 00:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A496B00AD; Wed,  1 Jul 2026 00:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFA186B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:21:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FFB91C59F2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:21:47 +0000 (UTC)
X-FDA: 84938909454.16.DE2D6AE
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id C354340007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:21:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hb8HMv2f;
	spf=pass (imf07.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782879705;
	b=BHC71TkUPMyWWNp6779sdnH1CAaCP1t0qoTPTaMfpbmVBYEZsNHvW8rNnITOXq3U3KkuqX
	D5A7jN/m8UPneVlEtJkNDNaKelqpJ6w/Ptncdd/t3bBxDPrpD2MztqW5QgYBsD2QYsEaGO
	ZOTPe5LnHBmTY5tJbtPCI9qtn6dnLj0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782879705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnuBgzvf5f9RuvoOmaiu/mJRZVsQNa36FBt9511ZTis=;
	b=l/ROYRc76FUDEO8laHfAa4sWblQYL1LLIcCtkDjcdYGM6ohxsJxX36V1BhjaQoZ34GjpKS
	D0+MWvrLO9TL+eieab6vXTqAyva9El4YoscqZYeRewNB58GUW1go/sqt5uOhQ435ETLp0i
	E59ZE0b8Dl9GuAugOrFXRb7qouVHjSQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hb8HMv2f;
	spf=pass (imf07.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c979d03538so1265075ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782879703; x=1783484503; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnuBgzvf5f9RuvoOmaiu/mJRZVsQNa36FBt9511ZTis=;
        b=hb8HMv2fEniJpASBxajhubBtcnA/aVJwbAyH8xgR5n3zEuxfhbGpPW/06WxFV66mWM
         34Fh+sQjzFePc49wyIu9kgAbk+CUdMjZEjAFhscePdtTm0J+YzbRJyTfWufva3VUHCqS
         tnC2KHb6SMKil7A8RF+CyzubPnBMRDlcQCrGESRt2rQJNjLN1F5AunaiyfHUQEcdM5NB
         iiPC2SA/8/Cj2PxCy6TLzlACBUkexy4zZlU11I8NPtG2D1h1+aLRNJ3cyGnxwdkQDpZr
         hYnMFc5cmcgDaTzelnswA+ey8p2BGZnjusOyVfq7WjP+ycWS7EBWD7qt64MQw7nfBaFi
         HmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782879703; x=1783484503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EnuBgzvf5f9RuvoOmaiu/mJRZVsQNa36FBt9511ZTis=;
        b=UOb/fAWK0EqkRvQXhuUnVqWPhPGptrz7YOnEzo60a5eiwVqN0Z94aRrLxXOpGghmdX
         c/LUB0ElmIfzA38gDE0PQGEz0B3zsmUE6+h8xl5x53gfLeLlCX7voG8146nQsAp0wswL
         DDbRQNWR/PhmxXWlbwZl9ee2ClusLqHGw5gV5v0cZIo0RsWCKOLvDVkC4mDL118KgnWQ
         od9s5KBukL+XtVvQVNT7CZzZD5UMw/Jkrwy1VldRgZGOafLR+lA/8d0dylcFi2iyN0CX
         9P11vpY19JyYszvnT3jdDTcxRjSTrw3PX713mWhhihBJjxP+Yv6g6T91qsfKSsxW6o0R
         peCw==
X-Forwarded-Encrypted: i=1; AHgh+RqthpYP6AHuIX9vPNvC9z9seEIDfkl6PIyuHARK8dK/sP6cnGab4qUcznsKxQYIoQw9XacgjnO7Pw==@kvack.org
X-Gm-Message-State: AOJu0Yzcsw7Xxt41NjlctMH3XAsWWw0p02m9KTZJjoSDb5TZ1SA0DNOl
	VKFzy6XCr+FQOD/kYu90k+2QRCYudgR3TEbL3AXMsQnGXwJi0aIbai3svCk64vyULmc=
X-Gm-Gg: AfdE7ck41rNkfuvvyM1oaYFX8rLMSI+bvPlgj3zlo5cLiY1xYUoJvAEe/A3Zm9+D0uh
	EStz3kuWoS8vLJWjIKYWO+5BFsmtKgcRk7N5u4r4ojt5BqTlDNh73j/lixMVm/3fQauVaO+T92l
	MYKBqFQMJLTk2s00cM1QHQuE3BaWHtrh8rPK8X7kwWb5BWg2TpyYZOBv7QBiYTH6hmTizlc37tC
	yWUC7Lm0MtvVL9SUeRUv2fpiLzFSET4nLEkbv7jkGwvbTOxem6GVBuxsRDHerDe/hxl91DwLw+p
	jkDreZHiXdP2oK9oW/KPVhrpdfHpFSGLyaAqhPrtiuFwo/XYqXy4i9FH8f6lnH7PKsY0HTR+wD9
	gAEe2/r38J+8HvlwwkXFVCWG35W668HkO6ReHQobtB4FEN8PJuS0a0XgJ7XsZCx93GyJVxI6M13
	A8fKvawd6kW74mOgrlIGy5D4TGeIGzB0h/4hA4z+vFUkmVy1T1zaJnb54D
X-Received: by 2002:a17:903:8cb:b0:2c9:97a8:afef with SMTP id d9443c01a7336-2ca7e8c5933mr1230835ad.40.1782879702494;
        Tue, 30 Jun 2026 21:21:42 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c73a9csm24450865ad.21.2026.06.30.21.21.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Jun 2026 21:21:42 -0700 (PDT)
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
Subject: [PATCH v5 2/3] riscv: introduce percpu.h into include/asm
Date: Wed,  1 Jul 2026 12:20:40 +0800
Message-Id: <d6afed2c271de42efe2a3580ea30c7601cae9c0c.1782877663.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1782877663.git.cuiyunhui@bytedance.com>
References: <cover.1782877663.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C354340007
X-Rspam-User: 
X-Stat-Signature: md9tr1tomse8bzzr5f44zg6z76bjkozb
X-HE-Tag: 1782879703-34194
X-HE-Meta: U2FsdGVkX18JiP3dNE8QoQXjlqi+QdoeSy3hyb8Oa1HPV3DjB7G19aD6c8f31LFJ6rk8alxoBb/FXzF5eqco2A0EyabY++Im4spxzvLFvKXHoVGdwv5a49wXhkxY2Deko6HA58tDN7kCST2q/VwqoSjprPVYBW8mNB+fnfKvzoiWyP4cVJH8F4zxwsLEiEs0ZndKxiO+26VqUXTbntsFodN2nAMRLJdEC2cTHDmjNGN9ybJ7kLG1LC0K40EPQ/0N+gm1KXJ79fcBR2UXuSz8NPiuWejYzHOqWuswVGWEGmyucmNUrfBecNeHTwnPtG5elmlsrSwRP6RvZ1MlcdQQosyM2OmRnuq+dMkIp3Dc3StgMVTef9+bJok+nSWImqyMaqCk2/IX9+yLg3BpAhM0VCr0UfWQ0XMJAOPuzDn2ntSPVGU/OihAA23Aj3k6MZeoHTzAJTZ+JTaa3r5g1mvMSiw69W+FcSZteaGDIATxWuss04J5xFoBfxE17ceAHZbByVcrJpuXQZG/y/kqbwez4qaW8YI1RqPK8fbglNFPTuZMqs2PxoI3uGItlFoUfz/iyDJq2zaWkfUtpAb9X95BG0tD5fwpKm6Ige1h7Rn5a0kK2xSYNkHWLcmwsQtuwpgsfJUuiLZ3jZPR2ljbSB085WD4qHTDIkpoRiFtyRWkDZxDQg9uXdY7QtXTJJ/xUw2I/XpJUx2+o2vHFXo2hWS3F9E8N0IFP8Xr0e4Dh9S9CzVtKmMcRgUyj/LENnnKMeZz9rCcLyYa5hakuI+sUvY5GQHP5hFJsTFdYsFcMQx7hR5PGABo/Tj4ayV/S24C1LgWHGP5m18S8hUcWckCtU0peVEAXRyXeiAS6Gtvt714FkuXGY9IXOIhjKMEHI0h00KOsK4MVQMM7C187qC4gjzxT/oopoi2n9ZJlrhASCLTnK0LouEh9TPHK6h7MLdxC/zig4V4tnXd7XFaaiSeswr
 LgYNgc7u
 7aYYHoTRlUOzWQSorXCmsst1rCa8fUF2Ek1NCdS836kjngFTvUvd6oJR+va+LGU3iutkaCFy4hIpLkeX+pCT1IPjkyAGmkziGRiwwuELMFmvkKCirNT1UbiWoRwPXG7W6LFUwa7SqAqcgoBSZqZoRZrRfIjXC5/LKbm/Hi5EQtWvEpnvx9iBQ8E1DiXZkDQ7wJZPlwdsN2QZNcYBZgaR8GaJpCKpgyTKrf/ODg4rO/1uNqKJ4PAt/+v0m8tC/n+7QkoJS8m8RzBaRZh+uGjb+KZUdL0188rAXcBMC8kEni/1kz+pjED7cqOBcy6XgvXi1jeYCVpZ9zwlefnIkTbDwT5+L38rqQzJLvv32sMrEi4Cg2j+htQCRU13mrDJxwirbWOpWBDSSpgdsfD9TRAsgqjwKAgkSXX8dJWSktBnNrTEwarQ=
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
 arch/riscv/include/asm/percpu.h | 283 ++++++++++++++++++++++++++++++++
 1 file changed, 283 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..46f1901d3bb88
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,283 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <linux/bits.h>
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
+		u32 retx, rc;									\
+		val_type new_val_type;								\
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
+			: "=&r"(retx), "=&r"(rc), "+A"(*ptr32), "=&r"(new_val_type)		\
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
+			: "=&r"(old), "=&r"(tmp), "=&r"(new), "+A"(*ptr32)			\
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(PERCPU_8_16_GET_MASK(sz)), \
+			"r"(inv_mask)								\
+			: "memory");								\
+		return (val_type)(tmp >> shift);						\
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


