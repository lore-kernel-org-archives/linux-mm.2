Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9407606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=KhJWSTE0
Received: by kanga.kvack.org (Postfix)
	id 91A276B05B2; Sun,  8 Nov 2026 06:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8E26B05B3; Sun,  8 Nov 2026 06:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9526B05B4; Sun,  8 Nov 2026 06:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 469586B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:05:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2C6712043D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:23 +0000 (UTC)
X-FDA: 85411670526.20.68EB759
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D2C91C0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KhJWSTE0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794135922;
	b=RfFToMfY4mBGWWvQUDqi73JRnGLqiflYnRtBOP7Nw/PazE97pVcEJ7Fw/G10f92RUcz+R5
	1GW3zQALPsDiOHwUCbNKiX027s7YF/KK8hZ8VLXJ/h9CZpfYXVu/G9x0MzDE77ZlGqIuvY
	tCT7aPB6fzyNYwixXTJ6VpzvcP2M2wE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794135922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UknItJXowOcjQfrYZmm9v6E5iZPTnDdyntGmdyqaylQ=;
	b=R9bDCE43RnToMcf8OHm12vpvW2YDOCKoydhdDiT9VUYtnbYjLXiP5wMOkPilPrCAbtd5Zj
	+ZTMd+99PsZ1eq8sSUbX7o/vD/GJBP5jgrIyQ48mpopicZD4aAeRcGLXUFfe938+pu1ZiM
	GHKgaEHKOtQV1jENF8x7cWBohbXsiMU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KhJWSTE0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdab9e9761cso3895a12.2
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 03:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794135920; x=1794740720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UknItJXowOcjQfrYZmm9v6E5iZPTnDdyntGmdyqaylQ=;
        b=KhJWSTE0zjE+PlXnBH4WBwVF3gjQZrG5xCvKawuZA10BdIO9lyBo4SYUhKL+AkBmaA
         hPyeHsM08kPz+yzQUcjV8Y+Lp4E/lyxgAjnRLMePN+aW4K2sjLD1WrW6WiS2ISSx0KxY
         kkrSgoqa9fZsvFDsiCoomSuXSoGILgYRwI4amVT+kHrJIizSPmlvbqEvevnUygd/coXc
         fWeywsqqCiXRnoZUbJQnmpJ5OASDO+hBvTTVXOa8cc/GfW3/OOl10LhHT0XMa1uNPDr2
         iNT6MlCSEAzvD0NIyTjIA9dab53yqR2Bpt/jzmkXr+oYUWGzEwJMQHZNELocFLObHQTl
         MhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794135920; x=1794740720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UknItJXowOcjQfrYZmm9v6E5iZPTnDdyntGmdyqaylQ=;
        b=AnON91MsgIPaP/H+59OJEof3+OlokgeTlsS6jw9geli0MwrxflBfWV/FjMmNYTYvtt
         oflZ3J4Rvb/ZICwvqx80jRVf/o7l6OU/kbnNUlZwBSUifFTJNAV/D+jErN4neXj1RHQc
         DW4cABzcNBRyB7+m/13049+RpbEuAGKL31Xa5ZljEZIaszvpPZh7voRMdaGo0yUVqOSV
         UftyKkcXALpdAJTRDtIuaKWcBXZ3+m/sdwBhEgqvMrBVgyf0LWPo9nXz8CuZ6xsbqxCN
         5pRa90GgyRw+0zvnq70thgtC0LDnLFhlH3aTNPQiB9pTc2ls7k6QPhzCwB6s0GETolEu
         Da4w==
X-Forwarded-Encrypted: i=1; AL+hErHJrlbKErOSNIsPyp1qzS6i67eoqaO1jS7KUblYB2eATuwtFNvEmmvQDNQ5tlXQWQRsA3WykhK1Zg==@kvack.org
X-Gm-Message-State: APuU4Z/eT2646fdwqCyPBPmcZch+7yYEMqE0bYyV3lrSylMmcg42S7Fb
	d7g2kbaanobc386j5E9nQfMmP92LNvBffQOyt8WTRkexOYKmqvnFXb63z3jOQGFK+DA=
X-Gm-Gg: AYBFou0/5y4h+VuNKUxgEoyU5XTCjfE2iOG8UBW10Eu8B7G3cgkfstA22+BMbgbTCnW
	QxFQGIG6LsE+2RtjlEVLKkQi4AaMCooCfmNR1I/N2MsdJbinAuOVxoHXHkad8EH7sm2mxJtE4/9
	C/9Ap0mFdNw/inbYh0gF4QdI87dd0dKZSQ/r9Q18sw4cNCY4bdh7SSkmtvtLdmcO6jBlR+gsTQB
	jhy7JT6x7VmPOvYFlwiLb6xILcSNqclYroAJfp+P+zlj9N/VXMTsRgyBrKKXO71yJqwa9yXBYp7
	78iJfqeEjrclrYQUPnwSkW+QiH1F/ZNKq1oTNM3/aDta7UqkVaQSaFm9Ed+NT9MAwEnukMrNPhi
	CStudvGtZ7T41zRn/NPfitdrEKW/C0aONSFveKCtmqCNfBPBPLaonwCH/DUGkXUYMHq0gdgZ9UP
	fb8MG/+opk8h87J4V6HeNJPLrOh0DX7CJW1+tIvUtTJKYnIXsZhjIeywdEKKZD5sTN9Nc5vW1Jr
	RFLS06fHKnanLxsYNWb+oOOqVbSUEwewLIbjRqPcw/i7m84SDfo3knXpJjSvYZM7rySL3mGunS6
	4Ld4hRXw0EYO35/DQ5pYPphJnybXHtE+WOsRk2ImpI2IUZqHIi265V/i73cnBCA=
X-Received: by 2002:a17:90b:39cc:b0:3a6:e901:e79b with SMTP id 98e67ed59e1d1-3b12d3e6f4dmr989964a91.15.1794135919750;
        Sun, 08 Nov 2026 03:05:19 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1278918f4sm2609818a91.6.2026.11.08.03.05.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 08 Nov 2026 03:05:18 -0800 (PST)
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
Subject: [PATCH v9 1/3] riscv: implement this_cpu operations
Date: Sun,  8 Nov 2026 19:04:04 +0800
Message-Id: <20261108110406.97495-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261108110406.97495-1-cuiyunhui@bytedance.com>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D2C91C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: xzrfycjxtmh9fjizaodk13ykficihirc
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794135921-507916
X-HE-Meta: U2FsdGVkX19P4hxzei0qkJYUelWFbTN9K084f9cjncL1lmzWR4CV+0Z3n4Py03/UisfbO/bUf69WKwlANl8p+yqbzoYDU/e4VZAjUPWW+00zU0XAkXGiIG2GmYLPxW6cx/vRN2IaAAs5NezbRP26YtLpmV7G0TH5qtiCFB1uuqX+Mkk1CqF4qcebcTzmrGQBgiqGA85nkWiBt5prT1CJ/c6kJIG7/8sRz3KOyYgKcylza0vRW2DOzVqOOmvLtZbaWUQLI9w7h3bDsJvL4FxE7mWxZZ/nTMcxulujmyv/Z3o0jUZKmehev+gk6zjPmeX6y6p0UDXC7wKn7Ae0gtJevmnlI+f324S+K6BK7f4XLjY5DDm0twKZtkiS9/R6CSPP1CSoWQerKZ/Y4fbLgRW7pglGrpl+ee4p4abvmYlP1kDASiW897B5sVqmSIByCde5iveW3lm/6Vi4tumHvWHP79oHZKvSqYADmrNcJv7KBAeEHmeA0SwlsagZ3Clzn8jsH3u7RBs3XCbODx3yCoSQYZDJykC/dzVMhYaW2gXhqx+OyJhiLlKYVEn3G5NrdFwz4ohYJhxqh7cabTHsY7/1XFaiH9gIlIBZlSlQUsyuPPSK3mViyRUpcUsPKaglVT6VX6tAVLSqofNtntFVF+GJaRpRPnOeNfkujLfZNVSnpQ7zaBvhBRclN8AzpMs+9FaWPGTvb8KlwVGkJItoFQy1bQAtkyaCv8Q1+gYPahYkVgzfMCxqL0IpSeKi3jPudx564ac8FQrXt8uESvCTdQfGKyPYSlUsOeoop77xG3lhJ6Mqb0fuakq+OOoh4YHNngBjODk457mze3t39HeAZihjdDb7Gz1ELjcvb6yvjtoxrmnOn4tTho+U/ARek5mjEIhrztMkJF+yqhi7bMzKPP/vQGtv16YXSXByZw2W9h13s49mgoBZA6+8xzd9qVku3Zp5NeiFms89ykOVZ1vlbbq
 v2vcX052
 JqDXaSjJ8a+ZblNdUz+GHMgcvgXfJGT2/dBA9vmWQZ8xW6uA51ecLuRVXLNT+c2jDoHrUKShuw6hlq4hlb8r328e+IUtwtYEFNYCPPMJQPMMwN1LABebrYAXgvLA4qgp3DB9VY0EkBcom1wpwloZ2MuKbzH2S/67psmKHZvJL0OlhGyuW3IyxJp7I5y5OxKt1dtQKtmqQdUGHuRW/2JMYoNFDpiguuCmLQhG96Kv4ut4vI38k5p6txduZEZyw/PSfw4zvccU6nATo5I3K1QejlmG+kLcCloj8c7h1urzqN6z9LxeTqu+Kuu7bMoBuRsNW9Q42eJGV9gAYhEOeo4bWcP/FObW19dDuHg7Xqk+E/GTPP5IHapYG27SARoEN4ZCPAhSfQ5FK4PQADghwEGP8oMx+poOzNQPYipVEQgujR4s4QOK91MOhul2c1GJG7V35dei9AtQHIzC4zQmOevlrqo6B0jPkoQbceGl0Q8/ZX58hSTJMNE8iFMPmoNNaVnbgALeGLor9e2YKentnl7A08Pp+O+u2yct7/py9PimoHBRT5WDrNb9ByxiUpyDj37JNPdyr3cYwvc4nWH+KougahAcTwrdHLaJ9fTGG+t/JGxBt7n72rzSZtCSJ07k6AyoSJferBEsezrBg8PBrhEclyEqN2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
operations use generic implementations that disable local interrupts.

Implement RISC-V-specific this_cpu operations with preemption disabled
to keep accesses on the current CPU. Native-width read-modify-write
operations use relaxed AMOs, while 8-bit and 16-bit read-modify-write
operations use Zabha when available or a local 32-bit LR/SC sequence
otherwise.

Link: https://lore.kernel.org/r/20260826010748.zphu3wh2hlm4t4o2@offworld
Tested-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 569 ++++++++++++++++++++++++++++++++
 1 file changed, 569 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..280b122b9fe69
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,569 @@
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
+#include <asm/irqflags.h>
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
+/*
+ * Use a real destination register instead of x0 even when the result is
+ * unused. Implementations may execute rd=x0 AMOs at a memory controller
+ * without returning the old value to the CPU. Value-returning AMOs are
+ * more likely to execute near the CPU, for example in the L1 cache. This
+ * better suits per-CPU data, which is typically accessed repeatedly by
+ * the same CPU.
+ *
+ * https://lore.kernel.org/r/e7d539ed-ced0-4b96-8ecd-048a5b803b85@paulmck-laptop
+ */
+#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\
+static inline void							\
+__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
+{									\
+	u##sz tmp;							\
+									\
+	asm volatile (							\
+		"amo" #amo_insn #sfx " %[tmp], %[val], %[ptr]"	\
+		: [ptr] "+A" (*(u##sz *)ptr), [tmp] "=r" (tmp)	\
+		: [val] "r" ((u##sz)(val)));				\
+}
+
+__PERCPU_AMO_OP_CASE(.w, add, 32, add)
+__PERCPU_AMO_OP_CASE(.w, and, 32, and)
+__PERCPU_AMO_OP_CASE(.w, or, 32, or)
+
+#ifdef CONFIG_64BIT
+__PERCPU_AMO_OP_CASE(.d, add, 64, add)
+__PERCPU_AMO_OP_CASE(.d, and, 64, and)
+__PERCPU_AMO_OP_CASE(.d, or, 64, or)
+#endif
+
+static inline u32 __percpu_add_return_amo_case_32(void *ptr, unsigned long val)
+{
+	register u32 ret;
+
+	asm volatile ("amoadd.w %[ret], %[val], %[ptr]"
+		: [ptr] "+A" (*(u32 *)ptr), [ret] "=r" (ret)
+		: [val] "r" ((u32)(val)));
+
+	return ret + val;
+}
+
+#ifdef CONFIG_64BIT
+static inline u64 __percpu_add_return_amo_case_64(void *ptr, unsigned long val)
+{
+	register u64 ret;
+
+	asm volatile ("amoadd.d %[ret], %[val], %[ptr]"
+		: [ptr] "+A" (*(u64 *)ptr), [ret] "=r" (ret)
+		: [val] "r" ((u64)(val)));
+
+	return ret + val;
+}
+#endif
+
+#define PERCPU_8_16_GET_SHIFT(ptr)	(((unsigned long)(ptr) & 0x3) * BITS_PER_BYTE)
+#define PERCPU_8_16_GET_MASK(sz)	GENMASK((sz) - 1, 0)
+#define PERCPU_8_16_GET_PTR32(ptr)	((u32 *)((unsigned long)(ptr) & ~0x3))
+
+static inline void __percpu_add_amo_case_8(void *ptr, unsigned long val)
+{
+	u8 tmp;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoadd.b %[tmp], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A" (*(u8 *)ptr), [tmp] "=r" (tmp)
+			: [val] "r" ((u8)(val & PERCPU_8_16_GET_MASK(8))));
+	} else {
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(8) << shift;
+		const u8 val_trunc = val & PERCPU_8_16_GET_MASK(8);
+		u32 old, new;
+		u8 field;
+
+		asm volatile ("0: lr.w %0, %2\n"
+			"and %3, %0, %4\n"
+			"srl %3, %3, %5\n"
+			"add %3, %3, %6\n"
+			"and %3, %3, %8\n"
+			"sll %3, %3, %5\n"
+			"and %1, %0, %7\n"
+			"or %1, %1, %3\n"
+			"sc.w %1, %1, %2\n"
+			"bnez %1, 0b\n"
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),
+			  "r"(PERCPU_8_16_GET_MASK(8)));
+	}
+}
+
+static inline void __percpu_add_amo_case_16(void *ptr, unsigned long val)
+{
+	u16 tmp;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoadd.h %[tmp], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A" (*(u16 *)ptr), [tmp] "=r" (tmp)
+			: [val] "r" ((u16)(val & PERCPU_8_16_GET_MASK(16))));
+	} else {
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(16) << shift;
+		const u16 val_trunc = val & PERCPU_8_16_GET_MASK(16);
+		u32 old, new;
+		u16 field;
+
+		asm volatile ("0: lr.w %0, %2\n"
+			"and %3, %0, %4\n"
+			"srl %3, %3, %5\n"
+			"add %3, %3, %6\n"
+			"and %3, %3, %8\n"
+			"sll %3, %3, %5\n"
+			"and %1, %0, %7\n"
+			"or %1, %1, %3\n"
+			"sc.w %1, %1, %2\n"
+			"bnez %1, 0b\n"
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),
+			  "r"(PERCPU_8_16_GET_MASK(16)));
+	}
+}
+
+static inline void __percpu_and_amo_case_8(void *ptr, unsigned long val)
+{
+	u8 tmp;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoand.b %[tmp], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A" (*(u8 *)ptr), [tmp] "=r" (tmp)
+			: [val] "r" ((u8)(val & PERCPU_8_16_GET_MASK(8))));
+	} else {
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(8) << shift;
+		const u8 val_trunc = val & PERCPU_8_16_GET_MASK(8);
+		u32 old, new;
+		u8 field;
+
+		asm volatile ("0: lr.w %0, %2\n"
+			"and %3, %0, %4\n"
+			"srl %3, %3, %5\n"
+			"and %3, %3, %6\n"
+			"and %3, %3, %8\n"
+			"sll %3, %3, %5\n"
+			"and %1, %0, %7\n"
+			"or %1, %1, %3\n"
+			"sc.w %1, %1, %2\n"
+			"bnez %1, 0b\n"
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),
+			  "r"(PERCPU_8_16_GET_MASK(8)));
+	}
+}
+
+static inline void __percpu_and_amo_case_16(void *ptr, unsigned long val)
+{
+	u16 tmp;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoand.h %[tmp], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A" (*(u16 *)ptr), [tmp] "=r" (tmp)
+			: [val] "r" ((u16)(val & PERCPU_8_16_GET_MASK(16))));
+	} else {
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(16) << shift;
+		const u16 val_trunc = val & PERCPU_8_16_GET_MASK(16);
+		u32 old, new;
+		u16 field;
+
+		asm volatile ("0: lr.w %0, %2\n"
+			"and %3, %0, %4\n"
+			"srl %3, %3, %5\n"
+			"and %3, %3, %6\n"
+			"and %3, %3, %8\n"
+			"sll %3, %3, %5\n"
+			"and %1, %0, %7\n"
+			"or %1, %1, %3\n"
+			"sc.w %1, %1, %2\n"
+			"bnez %1, 0b\n"
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),
+			  "r"(PERCPU_8_16_GET_MASK(16)));
+	}
+}
+
+static inline void __percpu_or_amo_case_8(void *ptr, unsigned long val)
+{
+	u8 tmp;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoor.b %[tmp], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A" (*(u8 *)ptr), [tmp] "=r" (tmp)
+			: [val] "r" ((u8)(val & PERCPU_8_16_GET_MASK(8))));
+	} else {
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(8) << shift;
+		const u8 val_trunc = val & PERCPU_8_16_GET_MASK(8);
+		u32 old, new;
+		u8 field;
+
+		asm volatile ("0: lr.w %0, %2\n"
+			"and %3, %0, %4\n"
+			"srl %3, %3, %5\n"
+			"or %3, %3, %6\n"
+			"and %3, %3, %8\n"
+			"sll %3, %3, %5\n"
+			"and %1, %0, %7\n"
+			"or %1, %1, %3\n"
+			"sc.w %1, %1, %2\n"
+			"bnez %1, 0b\n"
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),
+			  "r"(PERCPU_8_16_GET_MASK(8)));
+	}
+}
+
+static inline void __percpu_or_amo_case_16(void *ptr, unsigned long val)
+{
+	u16 tmp;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoor.h %[tmp], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A" (*(u16 *)ptr), [tmp] "=r" (tmp)
+			: [val] "r" ((u16)(val & PERCPU_8_16_GET_MASK(16))));
+	} else {
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(16) << shift;
+		const u16 val_trunc = val & PERCPU_8_16_GET_MASK(16);
+		u32 old, new;
+		u16 field;
+
+		asm volatile ("0: lr.w %0, %2\n"
+			"and %3, %0, %4\n"
+			"srl %3, %3, %5\n"
+			"or %3, %3, %6\n"
+			"and %3, %3, %8\n"
+			"sll %3, %3, %5\n"
+			"and %1, %0, %7\n"
+			"or %1, %1, %3\n"
+			"sc.w %1, %1, %2\n"
+			"bnez %1, 0b\n"
+			: "=&r"(old), "=&r"(new), "+A"(*ptr32), "=&r"(field)
+			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),
+			  "r"(PERCPU_8_16_GET_MASK(16)));
+	}
+}
+
+static inline u8 __percpu_add_return_amo_case_8(void *ptr, unsigned long val)
+{
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		register u8 ret;
+
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoadd.b %[ret], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A"(*(u8 *)ptr), [ret] "=r"(ret)
+			: [val] "r"((u8)(val & PERCPU_8_16_GET_MASK(8))));
+		return ret + (u8)(val & PERCPU_8_16_GET_MASK(8));
+	}
+
+	{
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(8) << shift;
+		const u32 inv_mask = ~mask;
+		const u8 val_trunc = val & PERCPU_8_16_GET_MASK(8);
+		u32 old, new, field;
+
+		asm volatile ("0: lr.w %0, %3\n"
+			"and %1, %0, %4\n"
+			"srl %1, %1, %5\n"
+			"add %1, %1, %6\n"
+			"and %1, %1, %7\n"
+			"sll %1, %1, %5\n"
+			"and %2, %0, %8\n"
+			"or %2, %2, %1\n"
+			"sc.w %2, %2, %3\n"
+			"bnez %2, 0b\n"
+			: "=&r"(old), "=&r"(field), "=&r"(new), "+A"(*ptr32)
+			: "r"(mask), "r"(shift), "r"(val_trunc),
+			  "r"(PERCPU_8_16_GET_MASK(8)), "r"(inv_mask));
+		return field >> shift;
+	}
+}
+
+static inline u16 __percpu_add_return_amo_case_16(void *ptr, unsigned long val)
+{
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		register u16 ret;
+
+		asm volatile (".option push\n"
+			".option arch, +zabha\n"
+			"amoadd.h %[ret], %[val], %[ptr]\n"
+			".option pop"
+			: [ptr] "+A"(*(u16 *)ptr), [ret] "=r"(ret)
+			: [val] "r"((u16)(val & PERCPU_8_16_GET_MASK(16))));
+		return ret + (u16)(val & PERCPU_8_16_GET_MASK(16));
+	}
+
+	{
+		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);
+		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);
+		const u32 mask = PERCPU_8_16_GET_MASK(16) << shift;
+		const u32 inv_mask = ~mask;
+		const u16 val_trunc = val & PERCPU_8_16_GET_MASK(16);
+		u32 old, new, field;
+
+		asm volatile ("0: lr.w %0, %3\n"
+			"and %1, %0, %4\n"
+			"srl %1, %1, %5\n"
+			"add %1, %1, %6\n"
+			"and %1, %1, %7\n"
+			"sll %1, %1, %5\n"
+			"and %2, %0, %8\n"
+			"or %2, %2, %1\n"
+			"sc.w %2, %2, %3\n"
+			"bnez %2, 0b\n"
+			: "=&r"(old), "=&r"(field), "=&r"(new), "+A"(*ptr32)
+			: "r"(mask), "r"(shift), "r"(val_trunc),
+			  "r"(PERCPU_8_16_GET_MASK(16)), "r"(inv_mask));
+		return field >> shift;
+	}
+}
+
+/*
+ * Put arch_cmpxchg_relaxed() behind a function boundary to isolate its macro
+ * locals from those at the call site. asm-generic implements
+ * this_cpu_try_cmpxchg_N() using this_cpu_cmpxchg_N() and a local named __old.
+ * RISC-V's _arch_cmpxchg() also declares __old, so expanding it in the caller's
+ * scope would turn its initializer into "__old = (__old)" and read the
+ * uninitialized inner variable.
+ *
+ * __always_inline avoids an out-of-line call.
+ * _pcp_protect_cmpxchg_return() provides the instrument_atomic_read_write()
+ * hook that cmpxchg_relaxed() would otherwise provide.
+ */
+#define PERCPU_CMPXCHG_OP(sz)						\
+static __always_inline unsigned long					\
+__percpu_cmpxchg_case_##sz(void *ptr, unsigned long old,		\
+			   unsigned long new)				\
+{									\
+	return arch_cmpxchg_relaxed((u##sz *)ptr, (u##sz)old,		\
+				    (u##sz)new);			\
+}
+
+PERCPU_CMPXCHG_OP(8)
+PERCPU_CMPXCHG_OP(16)
+PERCPU_CMPXCHG_OP(32)
+
+#ifdef CONFIG_64BIT
+PERCPU_CMPXCHG_OP(64)
+#endif
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
+#define _pcp_protect_cmpxchg_return(op, pcp, old, new)			\
+({									\
+	typeof(pcp) __retval;						\
+	typeof(pcp) *__pcp_ptr;						\
+									\
+	preempt_disable_notrace();					\
+	__pcp_ptr = raw_cpu_ptr(&(pcp));				\
+	instrument_atomic_read_write(__pcp_ptr, sizeof(*__pcp_ptr));	\
+	__retval = (typeof(pcp))op(__pcp_ptr, (unsigned long)(old),	\
+				     (unsigned long)(new));		\
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
+#define this_cpu_cmpxchg_1(pcp, o, n)					\
+	_pcp_protect_cmpxchg_return(__percpu_cmpxchg_case_8, pcp, o, n)
+
+#define this_cpu_cmpxchg_2(pcp, o, n)					\
+	_pcp_protect_cmpxchg_return(__percpu_cmpxchg_case_16, pcp, o, n)
+
+#define this_cpu_cmpxchg_4(pcp, o, n)					\
+	_pcp_protect_cmpxchg_return(__percpu_cmpxchg_case_32, pcp, o, n)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_cmpxchg_8(pcp, o, n)					\
+	_pcp_protect_cmpxchg_return(__percpu_cmpxchg_case_64, pcp, o, n)
+
+#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
+#endif
+
+#ifdef system_has_cmpxchg128
+static inline u128 __percpu_generic_cmpxchg128(void *ptr, u128 old_val,
+						      u128 new_val)
+{
+	unsigned long flags;
+	u128 *p = ptr;
+	u128 ret;
+
+	flags = arch_local_irq_save();
+	ret = *p;
+	if (ret == old_val)
+		*p = new_val;
+	arch_local_irq_restore(flags);
+
+	return ret;
+}
+
+#define this_cpu_cmpxchg128(pcp, o, n)					\
+({									\
+	u128 old__ = (o), new__ = (n), ret__;				\
+	typeof(pcp) *ptr__;						\
+									\
+	preempt_disable_notrace();					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
+	if (system_has_cmpxchg128())					\
+		ret__ = cmpxchg128_local(ptr__, old__, new__);		\
+	else								\
+		ret__ = __percpu_generic_cmpxchg128(ptr__, old__, new__); \
+	preempt_enable_notrace();					\
+	ret__;								\
+})
+#endif
+
+#undef PERCPU_RW_OPS
+#undef __PERCPU_AMO_OP_CASE
+#undef PERCPU_8_16_GET_SHIFT
+#undef PERCPU_8_16_GET_MASK
+#undef PERCPU_8_16_GET_PTR32
+#undef PERCPU_CMPXCHG_OP
+
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */

base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
-- 
2.39.5


