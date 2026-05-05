Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB3DFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2D26B008C; Tue,  5 May 2026 02:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6893A6B0092; Tue,  5 May 2026 02:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578866B0093; Tue,  5 May 2026 02:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46F346B008C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:21:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBD371203F3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:21:06 +0000 (UTC)
X-FDA: 84732368532.20.9830F64
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id BBBB0A0004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:21:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LYKgBN+m;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777962064; a=rsa-sha256;
	cv=none;
	b=gbn2qzmqHqszQG0fHAqoaGLOqufQjSRn1YMYZEjDxpMrYzg/O+hwlONs21EdEaSDw6lohD
	5FPInB7Z+cz53XNyxIa+FqwAO6ykiyuYBQVLWkw3/5cpr8LRAvl0df0J2KksoMz4JTycrS
	BN12mSvuqg3iQr5Mf51IvBYVcGBKuIE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LYKgBN+m;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777962064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUWhdkh+jSa+kjESo9b/CmN+H/tJl8wa3ioBeRpyc7Q=;
	b=Rqv9aMXxh287xk0pQD5C5L9unrTzo1DESXTDaT2DxU0Qqf2vz/S//uQHT7kZ8Q3A+59GYY
	8HXO+nCOl4pdjerHMH1I84JRBtQPxGnNngChw3uFb40yedbmwv3tJivXOKUAftYr6MZsVd
	Dv/cF/qLjjzS1kW8E0uZq28W8RxvT60=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8353c9f24d2so1486243b3a.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 23:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777962063; x=1778566863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUWhdkh+jSa+kjESo9b/CmN+H/tJl8wa3ioBeRpyc7Q=;
        b=LYKgBN+mrT+aDvVNSD6MvBBgRTNTKSRDAbzKIH41PiLXLh0Rq/LTtNU8cIl6Fx65JD
         81CZZZczZVu74dFFanv+EcXBGkGoLQ94vanuF412dShDNtvpR2Y76ISMd6SvSvcS6Yev
         l2EXjWNKbqe9BV5KX0GKBx1N4MPeUEauf3I00PA5vGkPySoKmBTX+VpUT+5wbCl05hi0
         xiMeNzp8UcxhDsaUNbeNtltBqriV78IRm9jSgGn1qVl/ZkCgLreQrJxE4HcdnN5ry1Qw
         7jRpiXqb4nsAceZD0lvyk9dRcpixIWDvte5tuEBlGWfmqbr5DYdNFPtxZuuB4BW0bg8j
         9bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777962063; x=1778566863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GUWhdkh+jSa+kjESo9b/CmN+H/tJl8wa3ioBeRpyc7Q=;
        b=aMSw1L2L1RIXGbni9ML467WS4e84hu3BX3XafKo/IT1nQsuz0bHKuc5iZYJXcRy9mJ
         TO0pOVXA1fFGXccRFdRHOhDVr2780PwISuCiH/jjhLS6iBM2wRf06tciz/+4ugo7KBbt
         gO6X8RQ0XOtTHqunJOdLxY2s05iVYt1IGvU3OPuMbDKmVJX/SDa5KGU6jVsTZFsyJopZ
         OFFN0x1q3ZFJ1qLgSHOAAoB0Di5cfiBNIDuxn3xH2ZRrn9fq/1EjNRgFLLoeqh8nCAuW
         Q67E71at9ZlAH8s6EYlodxsQD47GtRHiyh18wpJRuqCGIyOnPr1XCXmmkIuIXDVOoKIO
         N5tg==
X-Forwarded-Encrypted: i=1; AFNElJ/SnjXnV/CVCrWLtphu2apEwvQfAtu2tP/BqvODniJ+REt3DBJT4MWu2AHTNuH/EsxlTrwoWbiMwQ==@kvack.org
X-Gm-Message-State: AOJu0Yxnma2upmyKrbAKxNxiCLXzEejakBJ8fhI8auLwSAyP/E2KwQmx
	xo346oli0GZ1478ZlakOOZvgNiTO90/RxNMMaqeZIYaPOWokXJ82cWEpl8ekze/7rh0=
X-Gm-Gg: AeBDies/GiX1zP0obcHu5Ds0WzGv2N7RVYThBSJ8m1Vi4otu3Js+APRzI8DV0CgTFQw
	ZaJAfFaVBZwr9jSXi8LcjD5CRR0DWWSVUeHXK3O/t+tcBmWfhhHvbV2bnOsdNefeVxmKYJtFdQ4
	aIATrO0pA4kVDdl6SkG6Kw5rMlvpl3dNQjNE4AvqFIjCX5zPFYWx6pHGFDrXV8PQNaeQ5yUHflv
	us7hZvYmZRxnlLqcTQ882hPD6AkcbIVwZanrarn8rETFxVGRYmegBZciAWvnnuuh+I+tV3bin/C
	WapqSdNp7lriLclErOCn67RVbwMcRPGCfzawVgcHNPVyI8mtNrE8b4AVC1JUOpVCYEyhzSWrW85
	UOOgKhbUpVlfOA1Mu+zaG4ZBl+hnHW3QkCJ0StBmvq9CcZZ5g4YqzjyWXPvS6bSbrNvTw/PznpX
	MYLUumsx4wNCs63hTqC5crWiQHVGPWx5hvkNuN/DQZqwFt86UUcrcF4YkCDZkGdwi4
X-Received: by 2002:a05:6a00:4b55:b0:82c:d9d0:f482 with SMTP id d2e1a72fcca58-83924eb8dd2mr1858261b3a.46.1777962063135;
        Mon, 04 May 2026 23:21:03 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c8c10sm880738b3a.37.2026.05.04.23.20.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 May 2026 23:21:02 -0700 (PDT)
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
Subject: [PATCH v4 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
Date: Tue,  5 May 2026 14:20:24 +0800
Message-Id: <20260505062026.91724-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260505062026.91724-1-cuiyunhui@bytedance.com>
References: <20260505062026.91724-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1sym91pnud654ctrk3kif3ped4rc8hyo
X-Rspam-User: 
X-Rspamd-Queue-Id: BBBB0A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1777962064-924763
X-HE-Meta: U2FsdGVkX1/0boj4p93pkgU0aS1OBg3O3iwOeorgQ0UYthHEaWzC+UGQwHQhbisZ1rCw+hETOJU0fkRrPnbdAttYQYAE+Nv7Q92S2zcMNFcBA/snRyG8e8JGi+Kuu1P/5VsoNQomqpHZJLtcfqqmnDB5L7VoDaQZhevb/08yGnJIxEILenl54l2Hdl4gYA6Eg3LHbPPdjFwyrDNuvZL6Xqa3pgyAZtvX1BevDj4kMu3Jrwa8LPyLe1dbAf4Yc6RDEQ7q+LdubPCTM6hTkqojXwTpKfDWiFTe1TXbeD+bk4J5TTqrE+LMyeMlJLOfnqvmU0dPYilSva8ij8i0oKp1zqTNsNkoX5l7x04gTuqxQJkxoE89FrH8YFnwVHU9lfa0dop0Qp9/g40XbomYMlENdQP+OoDK/GVsRoVZyZcPgaqxxIay7BDI5nhuGAGa8QJhnQtmxbWTIQXtMcm6mzvR+sw5U1r8u0vlTYdptT8xDcWhYow9V2zhjEqYzhzowKhR3JNu0s4oRhWyL/63x7L9zq9Sy5f6j2OtX+m7sW0BDY6i1RrHQ7/1c1ZQpaQR/3PGaPCNh69t53fmguYNwk9uluBwA9lB2B2YcrtDDS1QijaEKMplEX/5OSuy+u2UyC4/+dlaH/LSEpT8+qAFKnGzi/uWVjcd7TQDg+vIpt5V4FJAwrNX6vdIJE0M+obezOoLKcmZ4IwgOozMrhqc4oKyIVGxaPWMduHBWGd97YEzs0WnftV0VV+/DZa+P1gez6q1/n5F1WBoVWgfO3nMF1BDgFKgeVikeIY4EbHTrEEpIUP4DXBAzD1AUJFLrbC9Cc33oEgUXtepUHrNrINSzYVoTXPnt5GZYLaThg7uK0szDUeplvuKvwt3xJ0hlj4XrXHhMlDZDHQRxOBtukM15Xb7e9EMKprMpnZtVoUGs2nX3pfYq5gpt775aBmPgKJxiCB7yFg35BDfYt/enSI6f8W
 QhtAnPAL
 cyVfICko0u+ExZbqyJ4UDo4rlDlZNNZXBw7SSzTrhXltqOoBqfE1xz5RWELgeUzYfVUn0khe/GeIA0lOU4x0ptGzgJvnPhQJR7WMaWBGwa/NaQCazf1KqE0My6GPNp5VQTkPsYO8z0zrEUgsqeWAg8cobkeSbwA6d5N6BzjzBG3uq3q191rjlt6hUeHuag3khWBXcHOCc7O1ybm//u052fRqI987fsOc6yQrp/DJCjCNwvcna7ufD2rztKKCA6uOLn9wgtxXxWA8QwRSD1zJKeZr8j6hVS5/32kJVAdeapP106P5aHqL1TCB4c1dO9+pn0wLWs3hi2W5fmAoxgnta++VVl2w4Kv5WuSK0lZdrdy7Lp5+O8HxRi8kucQcxd8ur/vl/61Sxj+1qhJKNlGUUJo7sttTxyRHiSjQAtTdeAMmGAUYom+77+RApGoeMJZkMWtI1GsAMb2iSCXvQHfnbl0lMmzuoqZkig8jB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The RISC-V PIO helpers derive I/O addresses from PCI_IOBASE in ins*(),
outs*(), and ioport_map().

Under configurations where I/O port support is not available, these
expressions can still be formed during compilation and trigger
-Wnull-pointer-arithmetic warnings from clang.

Introduce a helper for the address calculation and guard the PIO-only
helpers with CONFIG_HAS_IOPORT so unsupported configurations do not
construct these PIO address expressions.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/io.h | 26 ++++++++++++++++++--------
 include/asm-generic/io.h    |  4 ++++
 2 files changed, 22 insertions(+), 8 deletions(-)

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
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index ca5a1ce6f0f89..d799e5ccc9437 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -1205,8 +1205,12 @@ static inline void __iomem *ioremap_np(phys_addr_t offset, size_t size)
 #define ioport_map ioport_map
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
+#ifdef CONFIG_HAS_IOPORT
 	port &= IO_SPACE_LIMIT;
 	return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
+#else
+	return NULL;
+#endif
 }
 #define ARCH_HAS_GENERIC_IOPORT_MAP
 #endif
-- 
2.39.5


