Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13341C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B2F6B008A; Fri,  3 Jul 2026 08:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C446B00B7; Fri,  3 Jul 2026 08:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46FF6B008A; Fri,  3 Jul 2026 08:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD5716B0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:29:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17AD31A0526
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:17 +0000 (UTC)
X-FDA: 84947395554.12.6110B89
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id D391980009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=giAOS5Vr;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081755;
	b=bWGxoW1SaJg9QASK+PKVs8ouQhBTFrEcANgS2rL0rzCV64t7tPMM7X8bJg1xgWdO8vXgFL
	6ehSdKSoO12p/q4lun+4kNS+UDH9/CCRr5+eSTlgQrWEVMAxfMApxROeenD+Ve8iNGqUhX
	blI89XEfihmPn7pNxBJV6+yGBugoJFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+VxPGsXEB5teg9HEsa3LZ3vy1Qgi8wQBPtiYzVf6Qc=;
	b=FJTbhERVzd0A2jsjH+yIO+EE/4xaXTQu9VlFza1mZb802Csp/R8eWoQHHqK8szkSdSn2p6
	SpU+drrx4rfioqNKr4XCuPWmJdcv3iGaChNr9ROZfyYABK2tfhno3VqrwN4M3hNq0EJoYa
	OstsimNms4+j/SqyBWaztnGQz+i6zMc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=giAOS5Vr;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-846970f0acaso422080b3a.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1783081753; x=1783686553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v+VxPGsXEB5teg9HEsa3LZ3vy1Qgi8wQBPtiYzVf6Qc=;
        b=giAOS5VrO+BCTJcKwW5KgHb0IxbBS+YYxBreJCGsF3mviOXkJq/Ey0ZCrdxCPakl1R
         bcSPvB2oNkwzqEcS9JspNiQ3yUS3QPnBRG1niL1tVjByDvqssbwGufVgtiWhMhW3PRII
         7uQavbDLIFamRU1H28KICi7g9iGWHcw2LvTVo8f7jBbkeTWhbE8NNil1eNXMi0R5LD7E
         NeAu9RJ2gTvESUMTb+JNphIOWZ7GaqkhllLvnHFzyYCUKhhI42BIPR3nlIFLbXJdKAwT
         kkK+xPO1C0ZzlZiu0fP5HirmtnQu/sH7necRL9WB81I3RmvaLyVv5AQs1Q+kdgq35ER7
         Q4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081753; x=1783686553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v+VxPGsXEB5teg9HEsa3LZ3vy1Qgi8wQBPtiYzVf6Qc=;
        b=GkDgqaRXeKNJAbezVNUxc4w3K5OEhbG5K/BaSxBDwNG6ucKO+JqONZ5bqEec0Db4MG
         ZXn4PchW9WhDOu5XMjyMaykMSxlz6Cfv0b5G9HWyDZvmWtLP72OpDThkHo+b1jYZUyKo
         nbQA8Drh06fIrQFTY2lVo+yktFsyCYLLiuR3tDRwt1Q3h48GPYWTNU/0ojZTR8d3PMm1
         F0Fze5ms3zuxd3qQenhRKKl0XWaqdap9DjK6giJQCDHgQ0r2XlrcKcR/1/kAjznn1LJA
         X/yjn6LYgtB+Z5oCRvQ2wE8TQ3AfxYsD17+sbB7sUuOlvt4ecOsnTMFdAwPuULTtMdc/
         JRsQ==
X-Forwarded-Encrypted: i=1; AFNElJ/lHjHD8KT1PjShA/iSFX4fDemD/zRmQ5764uld3UtvyJsx2Qah1/rBeq5LHgQ4c/6IvtCg4w+vJg==@kvack.org
X-Gm-Message-State: AOJu0YzlVD4r07lMkpbJeV/sAWJac8UKh2LfdAZlMN41hIEZrQGX6hOs
	Ko/mnHK2sNWu7A1FoCY8/02f0m8ddxGSJnMTWP5QR3aP/Na1cJgRqFd/e/X6ZkxsJQY=
X-Gm-Gg: AfdE7cn8E3lxe+mOU+EJsVpjsnEsE0toB2wOBfchBLnPD5BAuC+GN2djRW4tXPXcQD6
	C1nu+jgY1nuA3ReEVjcifCKOpjaHBZngT8+5w9zPW2EwyxteDzHsbeWtl0TQD85lAVzXobyMalM
	IlLNkaoOOX5/0Pvx7mA2s52pK/2jmQ4DBB8bLVAy58nRKzFdLcemfIy7P1g6/VR4V7IxVtbU7tr
	zTPmWg4FgRbE8gtd6Bjdl9i4+KXaC+hRQXCpY3DMXxpMmPL+qDaC/zVvAbb/I1l3DTVimOepygb
	ApUh4Abk7xAJXtwn+jm0U0a8PPeY+GNuEZtjVLPcqgtkiSJ6hNK4tLxwSI3S9p1jKnE9wXWA78C
	OsEyc/UCpCx3P+aLEsKIT9g9p0Xm7ZB97JwZIUjA5PU3mWNMzgGdQHt2kEA41rwd+mEPPh9My9Y
	VhRj3LYwgaROoSH4AawcFOaTzOIkizt7uUwdhvlmTK6daBAoPe0Ig=
X-Received: by 2002:a05:6a21:514:b0:3bf:b960:6fc4 with SMTP id adf61e73a8af0-3bfed4701b4mr11795889637.30.1783081752569;
        Fri, 03 Jul 2026 05:29:12 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8f3d74ccsm2705551a12.9.2026.07.03.05.28.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Jul 2026 05:29:11 -0700 (PDT)
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
Subject: [PATCH v8 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
Date: Fri,  3 Jul 2026 20:28:30 +0800
Message-Id: <20260703122832.15984-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260703122832.15984-1-cuiyunhui@bytedance.com>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D391980009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: sdukm8dx6uej7gpe5kox68xnwdt699of
X-HE-Tag: 1783081753-772228
X-HE-Meta: U2FsdGVkX198xS7O64b/u8pm3K31PRkJLJYKXGpuT13G1GVh4hpMwX/hhIUC3M9Ds4VssGTJUr08o7Q+HuWvXEiv9/SbCy1A+kDPJFQTEcYriJV7gmbBRNzLMXdzPirWfNTeVpAWVet2KdhXkHqVYkdObpVkDzUKF1tVsvKFMFrScqwFu77WIFwk7wCHZSP3XCZs34qIIKlzPtjbhFCQOON5H04WzZhMYoonSw+2HGaa9bTlK4izP5V52lEgZPFmAkywPeKz3EF5VR6mRAO8JEl3B9ukHqaWiimX/xlieboPHCF/6w0Sc9r58cg2vM6NkFGksFv68PPWbcZvry4B73hFWP0jxqTC+RFl+U1bhtHuNRjHONSfv3MQ9becqgYjnaI/n4agBPp8KQsrEZaKcfdbc/pFvcIte2BOCUekLgOUe0Vr+aE9qrDbDSDMN9em/9c3wsOHyzVRM1RQR5cgzaOhz0D4lE9Y65liSRmDxfTN00M6o5j2cQsFN/f8IqbECM+noPJEERw5YNPQ+02n8WQtdCdjysPKVUVBjCFXEP3kh9MQCPX4th9EE56J2Oc6r4zemGNk+iGFn6KlFbD1jkE1UnAngP2QXcRks2DnAVv+W7W0b/ovD141SAEpC5l7LH/qz08d58ApRDWqx4B8ly810qwq/YnjCYJPc7tupfFwM3oBah45zJY8IzYj6YQHFAh+FJxtQwkAUvFf69wxzgcGKo0kn9B6xpfxK1cYO3q6ZFg9hawdnhOzmy40s658sJYtL6xXEGhr/J1PpK4If/yDG8BtsF/I7kEqBwNk0r94x9DxVYxY98JBJ1lnNxmui2CVmLBdp2/bE/k6404qIAVnJd+qy7FSxcamnrHkvxVzEGTUKZa1rTc2v2sGqvWXc8cbAskC9qANFddVUxKc9av6nvYKTYi2vs/rWu9IQsLxgAomm6NML2+LO/i5ep8DvVs+6ZkrJO08JSpKEuo
 maX6d8M/
 QumnBpXBCuqNgyH/nNMkPoC31LRNlhLRfl8jdq4L9nS1SmWZzWAeeR2O70HyP5n1uhn00E/m9F2DBuuw1QHDZps8CGhTSEV9AYgI3jC+JgzjooHt7//Ps1EUdAKiBfYOnfRv4jJeHda/6PGJ15gUIJMP0D+dsy4QXu1btbe2uJIUyfpkJPCfFFh4NxWvbAz/elm2Jf75vS9t2gL2VOU52aMl+mCOEdIqsDygdebx7FeF388eLkXwbe40X5ykF4iLP6oMs9gUSLcbLcQi9hd0TNTQwVr26MV5CidknlaPBNMMvPqGtu0tLJyMC9jeqmTj7bC92n56SlHgfaQuLQi2Gyyi86UOSsgTo7/kyomYNpp2ps7449hPBkeDzeGGKFf0Er1OOvt2wb4MiYaTbrZWgySpvnDl6GusLg2VmojPiFstNP3E=
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
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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


