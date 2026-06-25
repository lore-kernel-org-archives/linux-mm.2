Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1A1CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F346B00AB; Thu, 25 Jun 2026 16:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E04B6B00AC; Thu, 25 Jun 2026 16:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5516B00AD; Thu, 25 Jun 2026 16:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8806B00AB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:14:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA4B7401C4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:26 +0000 (UTC)
X-FDA: 84919537332.08.5C5961A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0351C40008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UWXo+xiw;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418465;
	b=4NGv+loNkPE9xKth010UeFBMD1q1PKcbBSEXtGgszly8WalhQyk44PJtRpWsuxcU3+BK3t
	fpV6Q+grBDcv+qlAByHTYgq/3iRRUQZUMNVXPDmsxroU9gy5Z2Qctp+22dA6Jys9cc4U/D
	j5kuoQRSU4tvXAv8g9sm02c40XtvxkU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2YRP3hjaIvkS7+GugYC8cjqq66SsCns5Rlunc+NOME=;
	b=ciQ3MmNOayprBGWXUGi/vYa6PUvXiRu+ep1iygI86k9Bo7JNaJKlZ/slm2ReZj9E1ctBlS
	p6yLJBwPqDMwowhcJlAjkTBFMJwBF3FU9gRsHN12aw/y2iGgjQETPWPjLk8/Rb/Pi35AmZ
	ETV+t0W3JTsZrqQxXngN6aUD7TkXL+I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UWXo+xiw;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Q2YRP3hjaIvkS7+GugYC8cjqq66SsCns5Rlunc+NOME=; b=UWXo+xiwqsM4tEXKb6FeJ2A96P
	57WKaGp1dZB9Cnl5Co/fG3aBjyDqumUkmyh79Zx9ZdunW4R+U85s3NGQMLWs1K5J/wm/3T0yPYCM/
	I816gZJTPXnw4cML7QqMEQ2eb3654MmkB0d7kXoHOphPcvlHFe1kS8WNenBoZ7KbYKy50DYMulYKo
	z+3iMGEgo6MVN6NgnXgMZYUGlS6eHMAAveV5b/EV1RlT2znRQvjTJ3spMQ6T/qvm9yJ7yxdTDNSTW
	iavUX/XPS76BKINXr0lX4sJoFFPC/A1ZibGcbw+OxiQUyyWkiw2OxIX96/g2stu/to6UAQLpnD+xI
	TdaWIr/A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq62-0000000AWZ9-0UVQ;
	Thu, 25 Jun 2026 19:50:46 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 11/11] mm: Remove VM_FAULT_COMPLETED
Date: Thu, 25 Jun 2026 20:50:37 +0100
Message-ID: <20260625195040.2508362-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zijgbm11pemofe9khsdkry63xxco97ic
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0351C40008
X-HE-Tag: 1782418464-133342
X-HE-Meta: U2FsdGVkX1+vY7ApE8dAPhSDQiGsh6olDNXnWzGjfg7w4m7QfUrtUtGd8ig20aA9wSWj6geR+qOMtQjxUhSgvtljKRHUenzyN/x+b82LNOAzXLBu+V9cXq0w62v+MnooNoq5CdQHGtVHaFsQdLzC45p4VX5Sprr8Cqy2UcpBqe5SMUJaBieS42+1bRtTjo3uxkNbQjl4TIvRoQBcESMQSw2m1XPFj5QHjMymRNVDsoV2LuavDHJTnC2XJS96wF28uQINZccnWiiqpAMOuCzJ8eynqxmJ70qnURekJniEgSK9RUBLyRMwYdXtNUTyso80rCz6BbrTPoIR4sytvRcaUoIo3P039wvS6xXnazNCHSQwPyEKYi+metG4ArykHwW6jHUiT1rU5DOzfcIsD41xX+tjrMMyKpoGK2D5XL7lOMWD8aDCmU3ZD4HiJGQ6Wf63pklw3mijtB+7OzEX1H+8thPMAC9wOG+gH0z0ITq9ev5RAdE4veb5B+9VEUvS2lgBNLFl1RYWxCemOihLHvsPlzk7Sso3R1ZVBdjQog7VFWVmeCSSjNBgCOCed4fCuNQ4JIQXCfroboYNFu/4i1AN6I1fFSqxvXSihI59zFlH1k14Vq62aOqm0mFCX277BNEZuMJSJiTRXxF2QuQh5JXfuKNRdHuv7CTP1iUsTrvEDD2ic/lUHffIuh42uT17QwrsNsJeYvGQo2sEFt9llBOFMcdNR0ByEpxt2W2ZUvWTnfNoquzxfm0wnj7kkJNHVN+sjijiVBCPHP+CuB8GBsm6npKi5/XTZ3Zy6bkgWogkyrBIgepM2GD0zXoqcfxCr+tVo6TqnQHcc2gtwHxiYTsk1s6kgwDvmqk1eHYzPhuXbg/+ktwIkAY+L/Gp2VNZtgyaJRHf/ZNiJVQl0cFhHC+qgGfS3zWFmsyy6ryfiUBXnBJGNE8RviraY3tQlVIlSMUKxjS/ihujipnS8O6w7gb
 cwbxzzCk
 0F8Gur+ccUKyC5OXPo07TBM9JYJyqMOEmSmMMulHgTDSSfDXOlteefYeFjWVb0mibhM46AQkf9oIvpf+Hb3QRlFFhbB1DQoVIFrfCwywlV/pvQ4xgMG+JV5AnnFODqyds3bdr63AXGrgvd4q+JdASRu6pCH9Kk7SzVtRn2qB6xdZ3sFDeoCgBWx+PaoO30TaCO4ECgQjq9PmNw+d2tgRay2PkbOuZuGT5eldS1zsmNFylTlrlsjGSvgvOgMc3OUwbqPQtLo34KlIAYlz8zM4faCJVBwR33EmnxTrfy2WkpwAWsmXgy0POyxzPyfjlIFU5V/HZoIRaXbffC845Q/qs1wtBA4SUUPZDq9gL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we hold the fault lock throughout fault_dirty_shared_page(),
we no longer return VM_FAULT_COMPLETED anywhere and can remove the
return code.  This is mostly a revert of d92725256b4f and 7a32b58be9ba,
but some functions have been modified since.

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 arch/alpha/mm/fault.c         |  4 ----
 arch/arc/mm/fault.c           |  4 ----
 arch/arm/mm/fault.c           |  6 +-----
 arch/arm64/mm/fault.c         |  6 +-----
 arch/csky/mm/fault.c          |  4 ----
 arch/hexagon/mm/vm_fault.c    |  4 ----
 arch/loongarch/mm/fault.c     |  6 +-----
 arch/m68k/mm/fault.c          |  4 ----
 arch/microblaze/mm/fault.c    |  4 ----
 arch/mips/mm/fault.c          |  4 ----
 arch/nios2/mm/fault.c         |  4 ----
 arch/openrisc/mm/fault.c      |  4 ----
 arch/parisc/mm/fault.c        |  4 ----
 arch/powerpc/mm/copro_fault.c |  5 -----
 arch/powerpc/mm/fault.c       |  7 +------
 arch/riscv/mm/fault.c         |  6 +-----
 arch/s390/mm/fault.c          |  6 +-----
 arch/sh/mm/fault.c            |  4 ----
 arch/sparc/mm/fault_32.c      |  4 ----
 arch/sparc/mm/fault_64.c      |  5 -----
 arch/um/kernel/trap.c         |  4 ----
 arch/x86/mm/fault.c           |  6 +-----
 arch/xtensa/mm/fault.c        |  4 ----
 include/linux/mm_types.h      |  3 ---
 mm/gup.c                      | 34 +---------------------------------
 25 files changed, 8 insertions(+), 138 deletions(-)

diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index a9816bbc9f34..8b73bb5c8dfb 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -150,10 +150,6 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index 95119a5e7761..4e3c811f1e3a 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -141,10 +141,6 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	/*
 	 * Fault retry nuances, mmap_lock already relinquished by core mm
 	 */
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index e62cc4be5adf..5716ef16b9cd 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -403,7 +403,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		goto bad_area;
 	}
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+	if (!(fault & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
@@ -453,10 +453,6 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		return 0;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return 0;
-
 	if (!(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 85e23388f9bb..cedb528e9caf 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -706,7 +706,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	}
 
 	fault = handle_mm_fault(vma, addr, mm_flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+	if (!(fault & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
@@ -757,10 +757,6 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 		return 0;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return 0;
-
 	if (fault & VM_FAULT_RETRY) {
 		mm_flags |= FAULT_FLAG_TRIED;
 		goto retry;
diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index 7ff401108985..f97754207f69 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -273,10 +273,6 @@ asmlinkage void do_page_fault(struct pt_regs *regs)
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_RETRY)) {
 		flags |= FAULT_FLAG_TRIED;
 
diff --git a/arch/hexagon/mm/vm_fault.c b/arch/hexagon/mm/vm_fault.c
index 3771fb453898..c341f3bcc4a9 100644
--- a/arch/hexagon/mm/vm_fault.c
+++ b/arch/hexagon/mm/vm_fault.c
@@ -89,10 +89,6 @@ static void do_page_fault(unsigned long address, long cause, struct pt_regs *reg
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	/* The most common case -- we are done. */
 	if (likely(!(fault & VM_FAULT_ERROR))) {
 		if (fault & VM_FAULT_RETRY) {
diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
index 2c93d33356e5..0779a84b3f4a 100644
--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -247,7 +247,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 	}
 
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+	if (!(fault & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
@@ -314,10 +314,6 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_RETRY)) {
 		flags |= FAULT_FLAG_TRIED;
 
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index fa3c5f38d989..a291e21061e4 100644
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -147,10 +147,6 @@ int do_page_fault(struct pt_regs *regs, unsigned long address,
 		return 0;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return 0;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index d3c3c33b73a6..2d83e5eb262e 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -226,10 +226,6 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 37fedeaca2e9..a598099a60aa 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -155,10 +155,6 @@ static void __do_page_fault(struct pt_regs *regs, unsigned long write,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/nios2/mm/fault.c b/arch/nios2/mm/fault.c
index e3fa9c15181d..c02a60cc2c67 100644
--- a/arch/nios2/mm/fault.c
+++ b/arch/nios2/mm/fault.c
@@ -129,10 +129,6 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long cause,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/openrisc/mm/fault.c b/arch/openrisc/mm/fault.c
index 29e232d78d82..f3ea3c0724f2 100644
--- a/arch/openrisc/mm/fault.c
+++ b/arch/openrisc/mm/fault.c
@@ -171,10 +171,6 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long address,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index f1785640b049..f20a61b431b5 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -325,10 +325,6 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		/*
 		 * We hit a shared mapping outside of the file, or some
diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
index f5f8692e2c69..edc9a7d09fed 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -55,11 +55,6 @@ int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
 
 	ret = 0;
 	*flt = handle_mm_fault(vma, ea, is_write ? FAULT_FLAG_WRITE : 0, NULL);
-
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (*flt & VM_FAULT_COMPLETED)
-		return 0;
-
 	if (unlikely(*flt & VM_FAULT_ERROR)) {
 		if (*flt & VM_FAULT_OOM) {
 			ret = -ENOMEM;
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 806c74e0d5ab..569309a2592c 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -503,7 +503,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	}
 
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+	if (!(fault & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
@@ -552,10 +552,6 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (fault_signal_pending(fault, regs))
 		return user_mode(regs) ? 0 : SIGBUS;
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		goto out;
-
 	/*
 	 * Handle the retry right now, the mmap_lock has been released in that
 	 * case.
@@ -571,7 +567,6 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (unlikely(fault & VM_FAULT_ERROR))
 		return mm_fault_error(regs, address, fault);
 
-out:
 	/*
 	 * Major/minor page fault accounting.
 	 */
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4..d4c1559a2787 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -360,7 +360,7 @@ void handle_page_fault(struct pt_regs *regs)
 	}
 
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+	if (!(fault & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
@@ -416,10 +416,6 @@ void handle_page_fault(struct pt_regs *regs)
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_RETRY)) {
 		flags |= FAULT_FLAG_TRIED;
 
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 028aeb9c48d6..4d81827f8beb 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -303,9 +303,8 @@ static void do_exception(struct pt_regs *regs, int access)
 		return handle_fault_error_nolock(regs, SEGV_ACCERR);
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
-		vma_end_read(vma);
 	if (!(fault & VM_FAULT_RETRY)) {
+		vma_end_read(vma);
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
 		goto done;
 	}
@@ -331,9 +330,6 @@ static void do_exception(struct pt_regs *regs, int access)
 			handle_fault_error_nolock(regs, 0);
 		return;
 	}
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
 	if (fault & VM_FAULT_RETRY) {
 		flags |= FAULT_FLAG_TRIED;
 		goto retry;
diff --git a/arch/sh/mm/fault.c b/arch/sh/mm/fault.c
index 06e6b4952924..9d846b1ce391 100644
--- a/arch/sh/mm/fault.c
+++ b/arch/sh/mm/fault.c
@@ -472,10 +472,6 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		if (mm_fault_error(regs, error_code, address, fault))
 			return;
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (fault & VM_FAULT_RETRY) {
 		flags |= FAULT_FLAG_TRIED;
 
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index 86a831ebd8c8..68998c77177c 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -184,10 +184,6 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs, int text_fault, int write,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index e326caf708c6..0015abadcce4 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -436,10 +436,6 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 		goto exit_exception;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		goto lock_released;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -462,7 +458,6 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 	}
 	mmap_read_unlock(mm);
 
-lock_released:
 	mm_rss = get_mm_rss(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	mm_rss -= (mm->context.thp_pte_count * (HPAGE_SIZE / PAGE_SIZE));
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 177615820a4c..b2043a75919b 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -182,10 +182,6 @@ int handle_page_fault(unsigned long address, unsigned long ip,
 		if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 			goto out_nosemaphore;
 
-		/* The fault is fully completed (including releasing mmap lock) */
-		if (fault & VM_FAULT_COMPLETED)
-			return 0;
-
 		if (unlikely(fault & VM_FAULT_ERROR)) {
 			if (fault & VM_FAULT_OOM) {
 				goto out_of_memory;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index dd9b50676f71..4a2e2ff41117 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1341,7 +1341,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 		return;
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+	if (!(fault & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
@@ -1405,10 +1405,6 @@ void do_user_addr_fault(struct pt_regs *regs,
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	/*
 	 * If we need to retry the mmap_lock has already been released,
 	 * and if there is a fatal signal pending there is no guarantee
diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index 16e11b6f6f78..b945c485f716 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -164,10 +164,6 @@ void do_page_fault(struct pt_regs *regs)
 		return;
 	}
 
-	/* The fault is fully completed (including releasing mmap lock) */
-	if (fault & VM_FAULT_COMPLETED)
-		return;
-
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1691b61df877..b3671c5bd7f9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1674,7 +1674,6 @@ typedef __bitwise unsigned int vm_fault_t;
  * @VM_FAULT_NEEDDSYNC:		->fault did not modify page tables and needs
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
- * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1691,7 +1690,6 @@ enum vm_fault_reason {
 	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
 	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
 	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
-	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
@@ -1716,7 +1714,6 @@ enum vm_fault_reason {
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/gup.c b/mm/gup.c
index 70c94d62fdfd..1927d66ffc76 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1124,25 +1124,6 @@ static int faultin_page(struct vm_area_struct *vma,
 	}
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
-
-	if (ret & VM_FAULT_COMPLETED) {
-		/*
-		 * With FAULT_FLAG_RETRY_NOWAIT we'll never release the
-		 * mmap lock in the page fault handler. Sanity check this.
-		 */
-		WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAIT);
-		*locked = 0;
-
-		/*
-		 * We should do the same as VM_FAULT_RETRY, but let's not
-		 * return -EBUSY since that's not reflecting the reality of
-		 * what has happened - we've just fully completed a page
-		 * fault, with the mmap lock released.  Use -EAGAIN to show
-		 * that we want to take the mmap lock _again_.
-		 */
-		return -EAGAIN;
-	}
-
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, flags);
 
@@ -1431,7 +1412,6 @@ static long __get_user_pages(struct mm_struct *mm,
 			case 0:
 				goto retry;
 			case -EBUSY:
-			case -EAGAIN:
 				ret = 0;
 				fallthrough;
 			case -EFAULT:
@@ -1585,18 +1565,6 @@ int fixup_user_fault(struct mm_struct *mm,
 		return -EINTR;
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
-
-	if (ret & VM_FAULT_COMPLETED) {
-		/*
-		 * NOTE: it's a pity that we need to retake the lock here
-		 * to pair with the unlock() in the callers. Ideally we
-		 * could tell the callers so they do not need to unlock.
-		 */
-		mmap_read_lock(mm);
-		*unlocked = true;
-		return 0;
-	}
-
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, 0);
 
@@ -1696,7 +1664,7 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 			break;
 		}
 
-		/* VM_FAULT_RETRY or VM_FAULT_COMPLETED cannot return errors */
+		/* VM_FAULT_RETRY cannot return errors */
 		VM_WARN_ON_ONCE(!*locked && (ret < 0 || ret >= nr_pages));
 
 		if (ret > 0) {
-- 
2.47.3


