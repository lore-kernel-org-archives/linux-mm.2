Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6881C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEECC6B00A8; Wed,  1 Jul 2026 08:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6D66B00A9; Wed,  1 Jul 2026 08:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB60F6B00AB; Wed,  1 Jul 2026 08:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7FAA6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:30:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39D461C2E53
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:30:51 +0000 (UTC)
X-FDA: 84940141902.08.D9DB7F7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 201CF20016
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:30:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ks3kdibO;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782909049;
	b=5Z998xK4dpi2XZs8QhmIiq/flkOWPCj9MBXIMzO158AxkacBj8le96BVmq0pk6Dg4QR0mX
	dsONmN+HF7olFmMU1AKWb5aRQ0dyFaG5U0KzciOQ3fG4Fb/v+6jZK7AnvhhaOHzoSDF8OM
	siXab6aDRVeZkyjL9AWdfWaOS8MS3AU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782909049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDd9DofNJHdq9P/rugFQPHi9oXh/6OPbyalY3nUgBIk=;
	b=j/7HZUuqOe2TBKDcWr0yzPPqKHwEcR/fVzzlAQgnBshSJEtY7GNXpu54XvyNqZrnbXdI1h
	3i4+x1uXPe6MdASbXtDoFoKIjdaxasuFuCm7AZXSy516G6X6XRBsnnw+s7G7kfhJzDb8dy
	bwzTTZ+2FS6yKK7+rohK4RNPff0McIs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ks3kdibO;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ca15944645so3766275ad.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782909048; x=1783513848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zDd9DofNJHdq9P/rugFQPHi9oXh/6OPbyalY3nUgBIk=;
        b=Ks3kdibOHtqreGUj5gDtJJJlZbWXW/o29ILSPWfo0e1yZgnYblFjxJYwCZL0sSDT2u
         RJbc5Ui9dTYWjFWaFtRwItPUuoAEst0slL01K8FM87x/XJszirocAo6nS0L2oLLJjYn9
         3ZQXiV+ehe3sa5+pGx5/0ww6VgufeA/IirACEZa3PayB3xcj2zlhNbGxU1kxYy0AeYB0
         Tx8ZzG3rWkUfDMdzuj96igMYmaGEYCCFoXrLWIEG5YuyxaJiguvgBYjuUaj3eE43XNrc
         vtazVnJUG11F8+xyav4AjhVDE/mEQczVJPMfLE+p3q4ZxVDqL5Hxgn6qYoE5b5f/KGX9
         KBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909048; x=1783513848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zDd9DofNJHdq9P/rugFQPHi9oXh/6OPbyalY3nUgBIk=;
        b=o8oWEKJWhds8IcCZtacbzmi4Sc7a3owM80Tlvphul2nmf+SRxbPhZhBi8HM56quJ9I
         DxYtGNZZ2+Rm5EZg51FRlB9mtAEiNQQ/0d1yBKdcz0mBK4+0Ypih04wrDF04uXhTwnNl
         K4wSFNFtdQqdPM1cJrZede/uXG0eFgh8B86hA+/1K6/o8KsLf2Tm/UsK1OjlonJqH/Re
         dR8yhdww+L732nFIIti9PsSKuf8fNRory8nzqUN5y8Gh6fDm1+CGnyG+at4U3qUViBIY
         RwhAkAbK3EeM6QF1RMMyY2ic52mmKcG+S/QTKvmlrpA0zSi7rntk+RFNuwFtXuvcMlhx
         zz3g==
X-Forwarded-Encrypted: i=1; AHgh+RoWBeRrvSOT813BytToRegySgh9mFUxSSZOvp+k7s7M276pL/5aWZ24Hvk6oJfzLBvFSHYWwf+iIg==@kvack.org
X-Gm-Message-State: AOJu0YwNx5uoshUUbWOBVijK/2FRlS1ukH+hMooODJyMS1xraOS7Wo4C
	hcqom5NBMjNz2OxVskiXm+LCdoDFlF+XIAKTIjAGtr8iMmWlsilLLJQZTVOy/PlIwo0=
X-Gm-Gg: AfdE7clOoPudCg6ytjlThCKV/n4bwMmF8Mt6n0cVbHce/IxUiFvUBBP28P6SvpkM/O/
	PVwBcERJ/CqgUXN0KzvZSy+aFE7xayV8knFHu+hySVIwpA7/d0xRAinXS1HGZnnhvm36w4ou6d0
	fPLyOJp0XXvNUi7tZlPb9NRa+ZFK5SzuzfpxK5IHS9mBWRWZIXBYMXLFNyCM1YFoRdrks9/G2VU
	9kQVHu/nteASft0JcBKcxE6rB0lWkvLW4qRw7OBcbhcQYp8vXFHUFWOd5N0Gm0MHQvGoxp0X0aF
	kcOTxkAT3nbER5T5tTPVvDPKsyi9YTGls7c2+6/GDoDzc/j9MhRPD+4WXC6nYc+TJU8yQEPzznJ
	iCmKjsN16L/82pJXTfOgfoZbRTO/PYLb3xHPU+VCRXEe+egzCcaPxZqaFMB/mB2A5jf5ieREOoi
	07hn8xHU2CgL5l3QKmsAfJ172Dxn58bFqmui9vSl2n+tlf4htzep4jmEzH
X-Received: by 2002:a17:902:e841:b0:2c8:be9:1d9e with SMTP id d9443c01a7336-2ca7e86485dmr15171775ad.34.1782909047857;
        Wed, 01 Jul 2026 05:30:47 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca4bae1e2asm25166825ad.73.2026.07.01.05.30.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 05:30:47 -0700 (PDT)
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
Subject: [PATCH v6 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
Date: Wed,  1 Jul 2026 20:29:46 +0800
Message-Id: <20260701122948.57584-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260701122948.57584-1-cuiyunhui@bytedance.com>
References: <20260701122948.57584-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rdzcj4u1ctmz4ekckuc968xw37qemux3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 201CF20016
X-HE-Tag: 1782909048-817455
X-HE-Meta: U2FsdGVkX1/B+zj9quQ9Ldcoj8gV6OtUNYvyX9QOeuGKioyFMAS70aVqWwqjGBPhcY+vJbAv5MJL4NMM9AKh4OrVuu92lB2egX0PNA1pvxiBnHCa0yZ6xfujEFAis07/YLusYe08v5v+RbfcYL4GOBGHMMC+2NbXrKUqpxrUyURZ5Hnb/CJQD7ETYPWcnThn9v6wjLljTuy48dV6iYwMkLo9g1e/N29O/9VeFhfW4OVwYOUnPAE0pOIvnQ/UMCY9rX2t7EMsFLntJDBXK03xJuNpT3p2aD9l0ZIPyrv/Hpw0+zSMMXNiinKhBtYakc6Pze1CVAQBxcw5IPxKcY52LAaEvTZqezsZ+oxH130u2FMJj+m0Yd4B//UyMhQ8fEcQpsE2BdI/d9z436gQtH8Petja3aEKx7XeOl5AIGn3l/gIMuR8AePfmfNEu0S/4uCCX8xeRmzqB1OWWgp+baSEgYxxS0aKSZ0o5/mLHiZB+sd2szjnPQl8vAfcKqqC3c8e+sutl/STNvVbRWtGb4ydS5ybN/TDewAfzIJuTMNxOhHjgIi44hkEm4auq8uMCnvPG9JbkJZg/+eAN++eCmbH4LtHSxCIgdOfD0RcYoOpx8sxRrgtQILYGGHzYXOqh6fKItnrsNtWh/yc2f/u0bg92lLbx7iMBp1v5ze4WEapT7O+pWPKBFHo9GLSXUxsZ3ypg0E/1/lk1Jy75klfqLqZ5E3VH5MDouwozfBQ3wB8ruZxO3C/nq0Chenyc3f39ah7v6z3I0QyAsbKb8S32pcLEo02BqJKx3mj1ArLGQTD7jMikCBTk1cuCUkFy8BI2szoJ6sKNX2ryWDeObaTxwfsjyn5daxxmETLaevL7Owlx+5q61TK4hZXFYW2YUE0Hb+Zhyh+5dkFZczVKBA1vpygQhp3BxqPGhaDzCd+fjX+fjUbnH5req2ISsf/ZHEm2LWyUVM/NrtnJ5SIzHEEsfm
 jbZKQYn0
 rlXHVUU8Fdujlu09blfKZMEQ+oqSBzLYn9Ane2oXJ+3naSnEaL0dZxzfEvSiVzFVM/XWTvsfOalAAeKiIXKIAG8lqnQO2MYXm+Th7v2worWryCNqP4uGJIGTIsN2dzeqWRPcaX0R6VZIXlPy4siwe/ho7AaI+7Zl3xSBNPQFU6GDY6Vv+Lnq2rfRHatfDvwqfOlUTjiSOE/6uMtLSpzSReaNzv0OF8bSsnfEBfq1iVbQ/G+8rdi1++bV15/HvZNBID/YhhfmLsKuE3Quck2nDfn4EN8VKKV9V2Z4nUfUD3KzTfLYyJOEMhPnP2pGXdb372AjXsXvkw4lXzcm3CI7Joh0JF04qm++pv1whr7F3iyasBqsZxPYSam+VUoBixFOd2zfgupAPpkq2uF8GBvnObU9E1iNFePcgcZZ7jKe2P6EQNhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When port I/O is not supported, exposing the port-string helpers is both
unnecessary and can make clang diagnose null-pointer arithmetic from the
PCI_IOBASE based address expression.  Keep the MMIO string helpers
available as before, but only provide the port I/O variants when
CONFIG_HAS_IOPORT is enabled.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index 09bb5f57a9d34..92d5f831f3495 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -102,12 +102,14 @@ __io_reads_ins(reads, u32, l, __io_br(), __io_ar(addr))
 #define readsw(addr, buffer, count) __readsw(addr, buffer, count)
 #define readsl(addr, buffer, count) __readsl(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
 #define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
 #define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
 #define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
+#endif
 
 __io_writes_outs(writes,  u8, b, __io_bw(), __io_aw())
 __io_writes_outs(writes, u16, w, __io_bw(), __io_aw())
@@ -116,26 +118,32 @@ __io_writes_outs(writes, u32, l, __io_bw(), __io_aw())
 #define writesw(addr, buffer, count) __writesw(addr, buffer, count)
 #define writesl(addr, buffer, count) __writesl(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_writes_outs(outs,  u8, b, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u16, w, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u32, l, __io_pbw(), __io_paw())
 #define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
 #define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
 #define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
+#endif
 
 #ifdef CONFIG_64BIT
 __io_reads_ins(reads, u64, q, __io_br(), __io_ar(addr))
 #define readsq(addr, buffer, count) __readsq(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_reads_ins(ins, u64, q, __io_pbr(), __io_par(addr))
 #define insq(addr, buffer, count) __insq(PCI_IOBASE + (addr), buffer, count)
+#endif
 
 __io_writes_outs(writes, u64, q, __io_bw(), __io_aw())
 #define writesq(addr, buffer, count) __writesq(addr, buffer, count)
 
+#ifdef CONFIG_HAS_IOPORT
 __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
 #define outsq(addr, buffer, count) __outsq(PCI_IOBASE + (addr), buffer, count)
 #endif
+#endif
 
 #include <asm-generic/io.h>
 
-- 
2.39.5


