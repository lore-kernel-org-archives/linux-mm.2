Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11EACD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7F36B0093; Tue,  5 May 2026 02:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F6C6B0095; Tue,  5 May 2026 02:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5B36B0096; Tue,  5 May 2026 02:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36D576B0093
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:21:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDDC9C1C1F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:21:16 +0000 (UTC)
X-FDA: 84732368952.16.C71033E
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB80B1C0011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:21:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=O7kNg40w;
	spf=pass (imf20.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777962075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oo8D+bpHIA0LAgv97mwhWXEIJKH4RloET0FJQLqr/w0=;
	b=soiGB7B3xiVPgOn7tVad4ecJJLSWRo0Hk5Ro1/+0E6LsNRx45ou2WqFvFLXVyqvkhs+g5k
	xHZ+42chu1mKeyzTa7Vu9icy1OLd0dTjY69Z0yueeNGyyNLMwbiTOBEVKCZY/3Qmxl31U/
	EDK4hO9p7sPdzjtG2+mesCNHfMpYMYI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=O7kNg40w;
	spf=pass (imf20.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777962075; a=rsa-sha256;
	cv=none;
	b=QyERMBFIQNyRWZk3itjZaSBI+MrPaAJrqdnnzUBpli3WHxPUjCCtG8QU55q8zd7AFATGWs
	PEc3/jmdbour9M4JRWt+htKMRMiBzeUctOB3p2SVLAaiqdcoy1j/fnb1feW6f6vvrf6zNi
	s6YR4fVX/E/NSbrdWPIbfXlsrhaOCtE=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-83975e992e1so105981b3a.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 23:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777962074; x=1778566874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oo8D+bpHIA0LAgv97mwhWXEIJKH4RloET0FJQLqr/w0=;
        b=O7kNg40wTn6bjVRtYGUDGJ3q3+dsXetxoqbilmBq0pOs21p2E5fnxG7XzcJmbAoAVG
         m08DeufJwY53noDPhnISkDfvqwHXSSHvejAkTlS5Yfd+/gxr96L8sDhBVHkyTrlw8ADh
         +OVKfbniLVYh+GWDk+g0bJYUveI09hoB1RByU3Zcakt4cHCiC5ybqsW6oGpQw64tk1O7
         vM1N0Zsa5t/G2UiXyTlBCTIlG1fqkwAM+XPQIJqHyuVr2w5a11CvdHrFitArQX3HWUfH
         IdjkrL2htbJJWhq7apOToX/yJYBb6mTW63zkjbT42ZUMWbXI8jGFwSB2HjQxXYRUnSD0
         +c8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777962074; x=1778566874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oo8D+bpHIA0LAgv97mwhWXEIJKH4RloET0FJQLqr/w0=;
        b=G7NWnBWar34/hG8/rx3wGXvTS9k79hKu4tdjwF7lHU0pTX4yv0MXPzc0bkreWDLgWZ
         oES6upRKnEzuSd6mRY0SRv+pg2n0mMgRnDDWrfXDbdFuAEuTBjbE913/RpzG9G8qZuLO
         6cRu6+c8cfCuc1ExVPd0yAWlNjyHM+CAWXw9C321fpC3D6ANgL3M2TLUcuvuupMe60iC
         LkkbtP+By0il0XTKOTeIlCTXdJ7t52PTp9Moth9AHU+g/8jfbVnlkKJtgZODZcDMDiHy
         GFrjVysAIcscGvV5QFK5KP/o2hV1GFsdvwmnmvdW32lRm3qw8CoPi3sTzY0UzPUAXqiO
         ySnQ==
X-Forwarded-Encrypted: i=1; AFNElJ84y8YkjysoSkh2Y96rEL+PPBovZiJIHJj+c/JH+K5szaaLoU6Gob3/YRD9jecpQS59sgdRh+MN2g==@kvack.org
X-Gm-Message-State: AOJu0Ywwtu8Li6XVpPy8ycz46IvEoBJLOjrP50IY5GEo657uvoJ217p7
	lB360VBJJVzhHeLEEJjzx8jb6SnwdfN62sFs0R0n9sWF0Y/Pc2pQDmF5ExMuZh5wc6A=
X-Gm-Gg: AeBDieucWj8rpd6tDPWVnmdxrwgn5Mu03Vmx+4nl0zAbj88P8ek2vTRw4IKBeqtuirK
	KlXuEx7QaYqkvU1nEn7DxkS867xdGhqjlyIBg77tLuZAwR1G1uhEjGveuyTKl58P1TVfOjenEvc
	CZ+r/HXDd86OJREE2zikYN0c0T/tiFJm8bUzbrUQPjp3d6BVH7O1cxExHb+smT2eocVLn5aLxhe
	r7cjB7+nmQ+hSy3cv3pYlTZcMUPEg+1qeoBgCVRpuovhHcYS8HdSvWiJP78slWrxSpb6ZzyKJ7s
	Hk46xYsnPWk8q3QhswRUICtd71DK55M4oq3LaFQBMUWmKRvvyRXRfNGTf8qjFpxwqkKx9/MhmfY
	ELBdEdyI92o/EbL4HE4AG2WnCxsKUSQFH775m9DzGsXCX1zb0aQzTBEG+PTJpSK2AE2BsyCsz3T
	yKfIuaX+rTAfHbONHUb1RPArg9xGDluX0gZNZyGIxhVXDKtMbkMpSJIzDrp0jdlIwTXkkD7ya/T
	8c=
X-Received: by 2002:a05:6a00:b90a:b0:829:7d31:dd99 with SMTP id d2e1a72fcca58-839246bc34fmr1947042b3a.38.1777962073663;
        Mon, 04 May 2026 23:21:13 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c8c10sm880738b3a.37.2026.05.04.23.21.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 May 2026 23:21:13 -0700 (PDT)
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
Subject: [PATCH v4 2/3] riscv: introduce percpu.h into include/asm
Date: Tue,  5 May 2026 14:20:25 +0800
Message-Id: <20260505062026.91724-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260505062026.91724-1-cuiyunhui@bytedance.com>
References: <20260505062026.91724-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u58wutdcad3r5i8n6w77yt19knm5isdj
X-Rspamd-Queue-Id: EB80B1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777962074-622697
X-HE-Meta: U2FsdGVkX1+P21ENBJYrJF1N7sKD9k5Y2BAuwar0vS14D/ifZG6FFFx7BHPnJu8HtijIgGhjTzJaM8eqbv200kXDwVU42d1uu6wYC8YxEGvQemvvfYdPjuHsqLcdyzkyuSoKa/0PrD4uOEsl4NOqjxFJcucTsNXq8BNcOFYWgtK1ykJmT+rbI04yFepbCFvj3I7NOwWPKqN43GpW9e2hSw2tCHRO280pdi4bfttARFehroU3rupmxfEVK2iD5Qgc9ncfJW061gjbpzIQzbQOAqN92/c2jSTxS0kWnZbQxdwjULT7sfxXPx/5LHMnFfiLLqtdGjUr7WfNW9z0vnZHLiXD5szEtl1QRYRsSezQDw3FPj55tcA+E9N2jNLr0pK6yVFVBBPahc8A8nZpFXk7o4VGDkCNsBcCL/fiepeDJ0yPQSaAE+T3FFfo1Skzw9dNizxX1dRzznxOtHNGOsyhFNb10akL/8FYvvAtv0SXLfIGEACZPojscUIIafIsQmivcnYjT2+SPXn03dun3ZwObTGZN4IefZvtDUTjz1NvUjo7GCeEaJsYJrm6CAWclsMT+LCy8slBRAxMMFzBbPhs0nBE7Q363LSPcdGdU408qYR99qsWXOY2fwW42BdK1BRKido4w4MniTgiQvn6MhpDaxntpJ0IN2EgqlmyuRFpBzLPdzaGRV+ZABEvkdXOnHjYpfmurM4Ms9S0lWB/qzE8aaI4Ic2ze+W70EnuSK2k7yWR46yAiKzEQlSS8VBCMxgXhjqvJuOsRha4+cg7O5bY8xaVHKfiO2/TEJoedVpQuSmxkltpKgK8S1vkoV00/dL95t8wy4KxQzjJMLduR/hi2GRYG2kdivVsQHE3MtMbiT3Pxbf59OP6NxcL0Xwsg1GHwUb8dwc273pdMFNitJL6Sys8gFilN8+Yx3CDgTYK2Fa82qfLFfAZxALdeKGxR9ziKHBgwWnSJwynOHSAnEk
 bEAgxzf0
 s1IyxBE7kxgbArbH+k/jnn/rTpEjyP7Dhw7CoIJYSI/qN6T1e1evd0LHRr6IIXAURyIyG4GAzZaE8GL2Pu47jCr7NRxI0dszJCnXa+SnFUJn1EEjab2vIBB5DIlSLn93mN/CD3mBsNI+32E3/YjxRNd6Up0L1XZGr9eyg47itJayY/gWx1UjjtJYzvuZdVttn+IyCPlGeU3u3EEL8dbJbakKZ+3nCy8+HB5SJaxs/ghT3t+eMv2yG33X8RsXQQcYmGE3y/lu7o+Kd6+CK7PwFaK/XLwGreSCU9JXlMb0XFdyFWJrUGbTmFIbYGQjB2UN4F0jMqmdPmGQKZzWh3kFG+PZjeuK4QUV7GL/Bd23eTAbTtAhJ8BRS42TOup5O143UHurJ1y8XB21l2IKqU1LUb5QUiytweYYB57ynm1ou+Sb4+1atBFa1b52NkLq6/c12iO+SAQK99PBl2rMsPj/ZVkwLc+jKSnIzQYUg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a RISC-V percpu header with direct this_cpu helpers for
read/write/add/and/or/xchg/cmpxchg operations.

Make the 8/16-bit add_return LR/SC fallback return the logical
subword result so callers at non-zero subword offsets see the
expected value.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 280 ++++++++++++++++++++++++++++++++
 1 file changed, 280 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..3b26fe45e70f4
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,280 @@
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
+			: "=r"(old), "=r"(tmp), "=&r"(new), "+A"(*ptr32)			\
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
+#define this_cpu_and_4(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_32, pcp, ~(val))
+
+#ifdef CONFIG_64BIT
+#define this_cpu_and_8(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_64, pcp, ~(val))
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


