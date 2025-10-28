Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AEBCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A889F8E018F; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A390E8012D; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9A58E0190; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3808E018F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2981458CCC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:26 +0000 (UTC)
X-FDA: 84046969692.26.9F02671
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf21.hostedemail.com (Postfix) with ESMTP id 490551C0004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=g4iOmek2;
	spf=pass (imf21.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s23a9Lw4NQpwPG2KyF7SnuyVJ7pKxcR7EU7g+DNSJGU=;
	b=Pz32JEMrkCyyCCzl8R/7TOdqql1lHYtXhBnocnofp/NuYWI+VxHrO0kDUcdP761sED7s7P
	wv63b7qk/x8vNoT1xx7qpXKK5n5TucTse1VKduF+XKpVnDlEMKC/c0AiG1Dm0bPBiK4Qhh
	0UQpBKyZEnD/BtqqT17I59WuVralopo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=g4iOmek2;
	spf=pass (imf21.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643044; a=rsa-sha256;
	cv=none;
	b=3vkaKyJ5jsMTq2i9zw7LKZQRlCG5/zZ4FA0sYLq+O0RtBDnVmfEHJ311jCbj7Qg7VB3cP9
	xYXdaytpDDWNUh6XveJtDVLKrAXY8kKBaNEjoDdFOJJxA53VFskVYCdClOFv1cVH95CGdQ
	9MdxAVS6ERX2XzgvuQIvDdKz0bbk8Bw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643038;
	bh=vszDF/cx4qHYXXIt4CCpd4y86yZhshQ+o4PVe1g7Y50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g4iOmek2Pwb6uaHO9W+u8eso4VNQkDSU25wRqBElFVpQ8AW3A2IfvYY4xFaRdfeK6
	 zEYDZMZis6+oV/rFJ2NiXsUZGNdNOvetfhbmxtX9XJLFGpk9Pzfe6Yir6auEGfA+Be
	 3DzYkFALhdgDxn8UbMJq0+NthKJSN9gSw7gyLDRw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:40 +0100
Subject: [PATCH 05/10] x86/um: Drop gate area handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-5-e930063eff5f@weissschuh.net>
References: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
In-Reply-To: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=2787;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=vszDF/cx4qHYXXIt4CCpd4y86yZhshQ+o4PVe1g7Y50=;
 b=o4JmUMvwtaLOa6D398C8FcQZo9AegfjrZ0mzUtV8o6ruPGtlXeeSvSB1/HNV+nBp+yjVHkJSq
 0+5+Nf0zAGFCVqYDRn7QlgelnwkKGaCgWpd/sXbvXYOnmwS3ORxXiCa
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspamd-Queue-Id: 490551C0004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7stjic9s8f775c1uo3dx4eb8pu98gd95
X-HE-Tag: 1761643044-135660
X-HE-Meta: U2FsdGVkX1/JvOdMcfbp5XvrQJTZ2opN4HpzVioaBKUOh/STuhTyQKJv9gkxo+grss25bqz/HGhJCLjFUEXiIqvI1+5FUw00a1KwouhM3MVxMyopopefbPKaWYQA3LVKeGj8pcYumspRke2CcD3h3H2k+m8oKqJwu/r+syDFrIPkYcmDASbJYlHiCgG6wPRdskOSTKI9TLGLGso1SXI26CMwIgnJomgjJ3cLpYG+OQfD3ODmJCzjwO34EGgP5kgQEecqWtxpTXZu+kWchXhQGCVyVmfxIi4G9RELUh/hfOOSlb1VI3b6sS07brW3Rq/Bw0uLegixNzCqmcqL3HLcs5/xZs9hrVFZegXdrXqnya3WqY3ZM6IhDfeVNUCpT6r3cdE9dH7HzcIA6+2zc6eDO3dTO39v0OobZj2v/Yjiqg2Ay5cu1UHer7NH7oEJ30Ei5DeiyXpuredkct8taSaVMevkRHF11THSlkMvFVQbv1dJZ82wxywFh60m6ofFbtA4wlP515jP/f2lEcdEg6++c+pSsJMOqvVnWFiYKnB8rsrfAVK9NLfie6OIloxWEHSH+ciT4d424TDG6mEgHRvFDMAUAOz27bbQokR0VSI2Xi5hTAVQpEsguaOI28PwJGRusCSm6HO/+O4/DO/kPHZ2kxFpyacTLvMrkSGWjBpGWWtXVLf4DrwKzC7lhdDdrYRiNotvxoT/bn4Z6M9F80gwWkZ6oheip9wF5Wgu2B2XMv9H8Yxh0zZS9TZCEXGFlU5SwfcxCw3DJRWn4TJaKU/t72mhwXf5Mmy8t8fKY3z97RKNlORh70gbF7zAtZYNn+kzY3nGiAFBXocqDUh34vXNJChFLGOt6eoxI/xUn2Yx848wDn+tq2IKHQWCOSAw+ZNlOmCpVlzYrsN5CYcwU6Jd8zYqohW9vHV68hC+yeLOJf5ZCsaXNG/nZ8xK9pA5GHIm9DukQMv9RZpiLH4Bjyx
 tWkMdXJH
 Xh8D+Nlpk/qQ4t6Q1kB7XnAJy7U8DNkANpST1tY5H+t6zYlhxc1zSZIC6JJAKCb6336RV6JMTbwwxWvwzjqUVdbb2MSWLNck3jvOa4NvBe4FtljjZ+c/s20MhooiKo3RGe3c1US/c4m2Y5Ehbxt0P9pff/ztBgkoXKaL/DfBFit/L5k8cCv2WUuPITq/pW03Re3T1ZOZsgTxH0AxHoX9yMK73bd9Hxy96a8pEB7IvddxEfR7/6eLO48vx4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the removal of the vDSO passthrough from the host,
FIXADDR_USER_START is always 0 and the gate area setup code is dead.

Remove it.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/include/asm/page.h |  4 ----
 arch/x86/um/Makefile       |  4 ++--
 arch/x86/um/mem_32.c       | 50 ----------------------------------------------
 3 files changed, 2 insertions(+), 56 deletions(-)

diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 6f54254aaf44..2d363460d896 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -96,8 +96,4 @@ extern unsigned long uml_physmem;
 
 #endif	/* __ASSEMBLER__ */
 
-#ifdef CONFIG_X86_32
-#define __HAVE_ARCH_GATE_AREA 1
-#endif
-
 #endif	/* __UM_PAGE_H */
diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index 1767e6061b4d..f9ea75bf43ac 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -13,7 +13,7 @@ obj-y = bugs_$(BITS).o delay.o fault.o \
 	ptrace.o ptrace_$(BITS).o ptrace_user.o setjmp_$(BITS).o signal.o \
 	stub_segv.o \
 	sys_call_table_$(BITS).o sysrq_$(BITS).o tls_$(BITS).o \
-	mem_$(BITS).o subarch.o os-Linux/
+	subarch.o os-Linux/
 
 ifeq ($(CONFIG_X86_32),y)
 
@@ -26,7 +26,7 @@ subarch-y += ../kernel/sys_ia32.o
 
 else
 
-obj-y += syscalls_64.o vdso/
+obj-y += mem_64.o syscalls_64.o vdso/
 
 subarch-y = ../lib/csum-partial_64.o ../lib/memcpy_64.o \
 	../lib/memmove_64.o ../lib/memset_64.o
diff --git a/arch/x86/um/mem_32.c b/arch/x86/um/mem_32.c
deleted file mode 100644
index 29b2203bc82c..000000000000
--- a/arch/x86/um/mem_32.c
+++ /dev/null
@@ -1,50 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
- */
-
-#include <linux/mm.h>
-#include <asm/elf.h>
-
-static struct vm_area_struct gate_vma;
-
-static int __init gate_vma_init(void)
-{
-	if (!FIXADDR_USER_START)
-		return 0;
-
-	vma_init(&gate_vma, NULL);
-	gate_vma.vm_start = FIXADDR_USER_START;
-	gate_vma.vm_end = FIXADDR_USER_END;
-	vm_flags_init(&gate_vma, VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC);
-	gate_vma.vm_page_prot = PAGE_READONLY;
-
-	return 0;
-}
-__initcall(gate_vma_init);
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return FIXADDR_USER_START ? &gate_vma : NULL;
-}
-
-int in_gate_area_no_mm(unsigned long addr)
-{
-	if (!FIXADDR_USER_START)
-		return 0;
-
-	if ((addr >= FIXADDR_USER_START) && (addr < FIXADDR_USER_END))
-		return 1;
-
-	return 0;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	struct vm_area_struct *vma = get_gate_vma(mm);
-
-	if (!vma)
-		return 0;
-
-	return (addr >= vma->vm_start) && (addr < vma->vm_end);
-}

-- 
2.51.1.dirty


