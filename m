Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68C2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9226B00A9; Wed,  1 Jul 2026 00:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1766B00AB; Wed,  1 Jul 2026 00:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B05D6B00AC; Wed,  1 Jul 2026 00:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC3E6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:21:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B280A401F1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:21:29 +0000 (UTC)
X-FDA: 84938908698.18.C75A141
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1644540005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:21:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UfW5EIvP;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782879687;
	b=of+/Cz4dzImM5nTFgwHyL9jMdGrvGZNmUEmAj2WBIXie7bI+vBxLmDwlqxMVWDsxpY6mvQ
	s4+5X90A/ne1fpEoQ8l295OZT6vPUvjXra/zz7nJEVZI39fDFuVSlf90P4AIaBYDfLiC5e
	6aZ6/p59GAeGmUdaZKLGU+zIbD2f3Yo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782879687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/qkNHfsDn8w5YxyUx5hOgj0iL6zLAhryV4C1f/Kz/4=;
	b=L02LkySbhFEdyDSxVEsra8uT1tXYs9CbSJG3BZqictduSb9a6Bj7n9nUhZbMFCNAtDtRDt
	qxPNNh0ZbUEvbmlPk+LQwxshIXlAPaI3FRlysYzVNmJBNupmOl5hGsKLVim3Gif7q7Coef
	jYh52Z8V/mnVTAv13/StxuURRVYlQ4w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UfW5EIvP;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ca1479dfe0so1413575ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782879686; x=1783484486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u/qkNHfsDn8w5YxyUx5hOgj0iL6zLAhryV4C1f/Kz/4=;
        b=UfW5EIvPWEf8wq+ENcC7x2L2w396S7U9geqviIV5N4GSjGlVBy473oIb0BInLw5J2V
         5VVb4Ok3lIQ6Nl5hvI7drp7t7Yncwf6OLXRmwddqn224mIk/Zl6KsjPLBnBc9rT83uRo
         MX62/6mxBu9j7VC0gIjOh7HeXTTsjGFWqSiHMGocC994B0zYjsNQPmmzqFYjTsAo2mNR
         eGNN9OCSASJAm8ViiGzZhLKk5Hd05BVXzKmCfVssr4TNyKkNLwzCD+iYD+024nHl7AS+
         NvjpNIkPWcHnDtdjBMxRMfxyrHjwvxIKPBJDNiatB6sLEQ0AEgfhj/Qs9bIiACcDWor5
         i7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782879686; x=1783484486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u/qkNHfsDn8w5YxyUx5hOgj0iL6zLAhryV4C1f/Kz/4=;
        b=Hmss8/JJFETSBdR53FRmycneyqbMTL0pZQ+kGqFUoXr/EOphOBdJZD/WpiQNi77fre
         Yrqf1obWViocyptGQ0IoXXukld+1w13w7toORXQDpaVXfPmS2VXKiTBQ8rbwHbwzoTO3
         5d2BvGkJqoPyerh7uZ9zMiVEEFFIpFh2w3i5QiLEIRH82VxoM/msLKmvqxgSOCFX9eJ3
         Cxyro7MU9lDDnV9EuR3JH4/Wui24fn2NmwW4YAqNJtdEcXZasYYhzjHYNhMYa/+Ado8b
         FhJP6PM6aJbJwnSUGY1SOtYN6AbIrCMnEwXZX1IhjUAT4SW4ojL0sAfiVevVoZaRK68D
         63tA==
X-Forwarded-Encrypted: i=1; AHgh+RrOcR2nxi4IfG1Pna5IRQuZnGw/Xb9D7TMhrm6Y1pBed7PRlj7KLkl45swInam0cB5Dc6hhRiK0aw==@kvack.org
X-Gm-Message-State: AOJu0YyIuF3z8f2srDhcnzSxeLD7e1V8SHfR3art4AITzafAB0Pm0iKl
	cMBsar0fylbP8L8UR6rXukZfyl12MGNxSJB04PMO6m2k1zOGBbWIgWbbD9C4UxhMy0w=
X-Gm-Gg: AfdE7cmyuDEbO8pFslNZO4YUhnYL+/zrJeV6Odvk27Y3S98vLZg8XJMri48Yi5YTkSR
	rBoBxaywVEt6uYRxknzYVK1RiRQuuNBK0JqAVGGT99Q0GfYihbpoKG5GKYdE+KxldiEzS1+n7wb
	cs3BmCVXxJXoj2pkMhwS/Z4YOsAOpG5mwH1/2PeNq2ajxy0yqQX36OPFvUqBurf6OfBFkN8XtFE
	dB1qFVhOm/XIdSgLrgJSvFL+wgkRiCMD1FZGe6laRZI6gS5MwpG1EKV88KzjvD8Wz0OVn8yN+TK
	pFfYjWGubg9tghxd2DPM7e6qytzHNbZWr4RLY6Li+Qx+s9XIr+kWZ6RzmpssYYlMy3dqLcXp3UJ
	Pc4MeWCs+DvCw1j/YQjR43+v10XISIj0B0xlctL2i61UUEIT9VAEUTzJb4B1JQWqs6+K0ps8NwE
	tUWRhvm9BUgJ5hu4TVD8GeoxkRDAVell+PvbkSPJ4rsAxfZz9Dk+/2cKMO
X-Received: by 2002:a17:902:e952:b0:2c9:de53:f84f with SMTP id d9443c01a7336-2ca7e75031amr1396745ad.19.1782879685487;
        Tue, 30 Jun 2026 21:21:25 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c73a9csm24450865ad.21.2026.06.30.21.21.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Jun 2026 21:21:25 -0700 (PDT)
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
Subject: [PATCH v5 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
Date: Wed,  1 Jul 2026 12:20:39 +0800
Message-Id: <7988df83f6341ea045ebd7294af2e8907dbd5ee7.1782877663.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1782877663.git.cuiyunhui@bytedance.com>
References: <cover.1782877663.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bsmfe4bhkjrgeu556hz46m5zx8u6oiq4
X-Rspamd-Queue-Id: 1644540005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782879686-899950
X-HE-Meta: U2FsdGVkX1+5XX3F+OG3MiBRmHuAUwfRLJTSFfdr7svFbO2IFlZtNklKgqLVxzU0A8wOH+j5+RyTCCDj9U/r3bbcXdL2/HfesQTwB8ns3ZmaMpVMpI2YwZpRT+CPbzWWbGNuc6abmhBT7Y1bHDz0iB22W51jlCRyuqQPeqr3N1izf6X8g+j2UI5uZ7icMD3jm6nWbQHVNrs2iomItfZFZ7fyj8ZQ/wR3p6XJdFKMLDbFWqP5NLIwSUXfttmXeuPGDWWj4yVQq84U33qvqEyQ4MhPUK8Z5WB4eNHNhrQ2vd/ih+7edRZM+2GrM9GPRZvcs0sSwp+89PXFvvfg33jpI4FC4PCjrcvdZ/v3IhAseHfTJ9ovG6FlyN572Us4NUxQsGc/2LtxJTIB9VsWh28OFl7ilD9ffZ+wsdUJcQYji0PYi3Nr1aT5uHY/Scbf7KIKdFjR17Uzqyzkkd+SLhFyjGr474GWug+GIYLQrScat5+HEFTdj4KFRld9vkZzCPAAltK0AoZJd5HeKCSSVOfHPA9EbbId5FXjTI0ELQ7GVNo5a0guF68MmMUrxD62dfdn7YqThZ8mpceDE08E9kekIJC4s62dGgOlJFPxMgDfU1ShP6UsdEk0Kv3/c3OnYnnq8FR6z0pYfHo+mXY/coVY7qmV+CK/HycOYSP5k1GTGIwW2N3jjJlKXDZ4y8PhxIo0Dn1v4sUCWjAbtZOdAO7xotRD1ISlL1Gjmo4phaU1BqFGJjtMNl+K6bMj0SysecUtkh1BkInavkhb91xrSAfHMIMHFkrES1p27ajsFF/l0YSHQVhCKk+w/5Je1fEcqXiQWc8UDalb3s3Vky19HF0LGSpj0FkwlkI1b3agdThk+tfz4A+t+ssUOoQElbDce+wvW6ilRk2mlFR/KS1jYP7m/DyEfiTDJLQk5qm/OLlJxz8AtuIUP/RcT9wTmaA9YKKkhYkl8uvAA3IHzonaj9M
 Kgu58W8L
 9JVq9ORWAKUGK9YqxQCyaXtd+c69wEEl+TZmUNvLfVpyP/DP5EFqFr5113h7PjY9g7ci3OpvsVWkNNu2VYvRjO55bVzjBngUHkrluHxek40/mklA/FSuLt8r32sW5uaiqxz5e0nv4aUje7iJv3XckLU6TEcc/ny+7q0WXQpY+pYG9rzjJ4qad7P6iumcXdaLqXnK1fPQccW+9fzxpjrJnMLiHskBLYPQC+n5fKwOTUdL9wKmAAzw38QEfgD2Z7xU1d/5obYruncsEdRpJ3Mt1qS7S6zrkC/DYKDRkPnphv5rb2Yfl9EQNTDjnp/huKHPd3CSE1JZ8LPXH+rqEFuKyoJGstn1Ubouo40BKIlW9G9Cei+XtxflY5tQ3vwrPHpChP942sG0t+9aIG7depVbPeiWCJz4/6j4LJcrLeZPkdqUZu/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RISC-V implements its own string I/O helpers so port I/O can use the
architecture-specific ordering rules.  These helpers build an I/O address
from PCI_IOBASE and the port number before calling the raw accessors.

When port I/O is not supported, exposing the port-string helpers is both
unnecessary and can make clang diagnose null-pointer arithmetic from the
PCI_IOBASE based address expression.  Keep the MMIO string helpers
available as before, but only provide the port I/O variants when
CONFIG_HAS_IOPORT is enabled.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/io.h | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index 09bb5f57a9d34..6f5d70313c83e 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -56,6 +56,8 @@
 #define __io_pbw()	RISCV_FENCE(iow, o)
 #define __io_paw()	RISCV_FENCE(o, io)
 
+#define PCI_IO_ADDR(addr)	((void __iomem *)((unsigned long)PCI_IOBASE + (addr)))
+
 /*
  * Accesses from a single hart to a single I/O address must be ordered.  This
  * allows us to use the raw read macros, but we still need to fence before and
@@ -102,12 +104,14 @@ __io_reads_ins(reads, u32, l, __io_br(), __io_ar(addr))
 #define readsw(addr, buffer, count) __readsw(addr, buffer, count)
 #define readsl(addr, buffer, count) __readsl(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
-#define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
-#define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
-#define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
+#define insb(addr, buffer, count) __insb(PCI_IO_ADDR(addr), buffer, count)
+#define insw(addr, buffer, count) __insw(PCI_IO_ADDR(addr), buffer, count)
+#define insl(addr, buffer, count) __insl(PCI_IO_ADDR(addr), buffer, count)
+#endif
 
 __io_writes_outs(writes,  u8, b, __io_bw(), __io_aw())
 __io_writes_outs(writes, u16, w, __io_bw(), __io_aw())
@@ -116,25 +120,31 @@ __io_writes_outs(writes, u32, l, __io_bw(), __io_aw())
 #define writesw(addr, buffer, count) __writesw(addr, buffer, count)
 #define writesl(addr, buffer, count) __writesl(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_writes_outs(outs,  u8, b, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u16, w, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u32, l, __io_pbw(), __io_paw())
-#define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
-#define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
-#define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
+#define outsb(addr, buffer, count) __outsb(PCI_IO_ADDR(addr), buffer, count)
+#define outsw(addr, buffer, count) __outsw(PCI_IO_ADDR(addr), buffer, count)
+#define outsl(addr, buffer, count) __outsl(PCI_IO_ADDR(addr), buffer, count)
+#endif
 
 #ifdef CONFIG_64BIT
 __io_reads_ins(reads, u64, q, __io_br(), __io_ar(addr))
 #define readsq(addr, buffer, count) __readsq(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_reads_ins(ins, u64, q, __io_pbr(), __io_par(addr))
-#define insq(addr, buffer, count) __insq(PCI_IOBASE + (addr), buffer, count)
+#define insq(addr, buffer, count) __insq(PCI_IO_ADDR(addr), buffer, count)
+#endif
 
 __io_writes_outs(writes, u64, q, __io_bw(), __io_aw())
 #define writesq(addr, buffer, count) __writesq(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
-#define outsq(addr, buffer, count) __outsq(PCI_IOBASE + (addr), buffer, count)
+#define outsq(addr, buffer, count) __outsq(PCI_IO_ADDR(addr), buffer, count)
+#endif
 #endif
 
 #include <asm-generic/io.h>
-- 
2.39.5


