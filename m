Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326D8CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE11D8E009C; Fri, 22 Aug 2025 05:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94808E009A; Fri, 22 Aug 2025 05:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7178E009C; Fri, 22 Aug 2025 05:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7C5F8E009A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AAD51A06F6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:53 +0000 (UTC)
X-FDA: 83803944546.19.18ED1AA
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id 539F88000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf30.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4zsBjDo9fIMyYiR+8SqYfExwkkNhX/eHry1jx9HH6I=;
	b=LIs4M/bFwGAY0dQ/klPJCHc+1oUO03wB5Sjlnd0EY1/HlhLVpFSJcaNVkKB85OzsFvSN12
	WcyRQJZdRomBIgp4YNeA67lGItN1UB1nzLL9SuL3rkZTOGJ5rbC+HsZbvOr7VJpgEuiOYh
	HRaHVW12V+z6yDuyw3IVJxtObLEocdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856731; a=rsa-sha256;
	cv=none;
	b=5oOMty5bcUM9K/Vi81Igo+VEtB6pYM+ZmYM1XpePEuK1k/R0ANjLE4flX0DTIi5n5NqLde
	hXZheVWhApnIHq4h9iPBexiZ/6CG+vpp/wxJH69TQeXWXGEWAXB+1+lpcH9HHaOLXdjgb8
	YfB3GAey0nVEHKbN1AHxauy8KMgERuI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf30.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGw3RnVz9sSj;
	Fri, 22 Aug 2025 11:58:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3D3ihdjAxI-2; Fri, 22 Aug 2025 11:58:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGw2QVbz9sSh;
	Fri, 22 Aug 2025 11:58:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3B1398B780;
	Fri, 22 Aug 2025 11:58:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id hP4XdQ8I1l6j; Fri, 22 Aug 2025 11:58:16 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id EBC088B775;
	Fri, 22 Aug 2025 11:58:14 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 09/10] powerpc/32: Automatically adapt TASK_SIZE based on constraints
Date: Fri, 22 Aug 2025 11:58:05 +0200
Message-ID: <db7f9b12d731d88ac612a27e2caf4d99d76472d2.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=6153; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=Q5VXVewln3Cq8QBQY4zJ1R5L8lrSpoSHODi0pVwUSDQ=; b=fwATo2R/7pzKngfXSvD28g8yFziaXfShMsvp2zyLAu3QXHJwRYR4qxsHgfcYjKtZtpPTf9q2K 4B3BCNI3uM2Bvj2QoVQMyxr0RNNIKNZvnyBRF5R1eOM7dpw+/XsqHoi
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 539F88000E
X-Stat-Signature: 9kyx9zijxgkjnfzmpdc9pw9yenp47em3
X-Rspam-User: 
X-HE-Tag: 1755856731-382710
X-HE-Meta: U2FsdGVkX1+jpkvaFs6iKbJSTUpNJE1Xc6vpVskFNUvk4T6zSC0EEQl4PY6AGyCJ7Xtln5dLmU3JrMlymVsmiIeHah7pcyr/nt9SlvxEESwou8RZqPg1WmAXBUjb1unMmcbW0F0WXIpe+wao9GdsEFyL2dgK8gFwE5hqs8KX+eOvsYafm4D1TGL4O/9TNDEfXKk+DEIagqn3Y0RVKxalhwUnB2z38k5iB27QYC+KO2bAZhLCD9U3vD4Eiv9MdH4B8Cx0KMz8zvE98A4ZNf9SDGWYLEU4KB6L3wW3gK86s7k4ZQ5CRsk9sPIA51AdrZBi8wrBexIkuAl2gaMWdMfqq7w0DClbfSuV2t+ZnHHCohl+v1haBh1ZWvz+ENIsQxb7O1fkquFFKNUtNh2AmhlZxhp3qgT/sAxTWYydvVhy32l+erN/hyzU1V688Z/3iylcPaTmw63Bl/wPs7DBCGB98Nfd7iHEaAK40EYK9CTShRoLA/o41Rt1nL6hw39CISg6iDxAp1r6Aem2reAKrXKM8GaVihSiWyGYz1cwZb6oKU06ksTcvIK8ufb4c7Y8P+IKIaZnqxmXwL7Z6KKDubPAlwVkh+bbMdn+pn8me53HiZ669WmPPNVlBLxMGalbxmm6hSNw1/ofi2NgQsPAxE5mz3CR20gtYsy0RbCw1x7iYFpXwdWfKklkl+k6ermp4kODVaFXxWAcYmKIgo9W45vs2WmDjqG+Ze0ujXxFFT9Up1qQqZb3IkT2VvKGMoOfdty45jnIJ73oEJ5CZIjMFTANwT3f10UDoXpHIPbRS0HRZkG4N/QN2AMK23pAx5OzD1vr4IPlwz/anfdfGDLDkKM7dR2pmWO4ZORVEmOnDn2ifXxuamUTd2F/clJ3DssLQr5wWB33Kwv9wnVxgEf1rEA278AU6sGTwDhJXzP17jb8WHlNSrnizKA5oPZCPyBBuEaAtg7dH1UrRnkG9AQL2Aq
 RUptoH7j
 LCc8Cn5TtqMIgSZUqx2WLHz1AjQ/s0aDHFW8M+qBGZa/EIoJBX9f9X010WcbZK4dpIu5+/5ExhOZwkmVCxzGdSI97ns4ozIgUysdcTUbftQsGnVnDSCFYqOXkjHKjnWxmYguiyCloIiuZeEBuor0BMCP2tSkrL/+5qKymuEXMbiHqSF7RATKABaZFbcHY69Ks8l/hZqBGMYye8N4TOoPO7CScAiWAcVFJ3MC9URRbIFZHspl2Ay0RnpZ7uC7fQwFecdYLMQqyHSjMEjsdrmdz/ZXvzu3E2AfPJA4C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the time being, TASK_SIZE can be customized by the user via Kconfig
but it is not possible to check all constraints in Kconfig. Impossible
setups are detected at compile time with BUILD_BUG() but that leads
to build failure when setting crazy values. It is not a problem on its
own because the user will usually either use the default value or set
a well thought value. However build robots generate crazy random
configs that lead to build failures, and build robots see it as a
regression every time a patch adds such a constraint.

So instead of failing the build when the custom TASK_SIZE is too
big, just adjust it to the maximum possible value matching the setup.

Several architectures already calculate TASK_SIZE based on other
parameters and options.

In order to do so, move MODULES_VADDR calculation into task_size_32.h
and ensure that:
- On book3s/32, userspace and module area have their own segments (256M)
- On 8xx, userspace has its own full PGDIR entries (4M)

Then TASK_SIZE is garantied to be correct so remove related
BUILD_BUG()s.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/Kconfig                         |  3 +--
 arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ---
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h |  4 ---
 arch/powerpc/include/asm/task_size_32.h      | 26 ++++++++++++++++++++
 arch/powerpc/mm/book3s32/mmu.c               |  2 --
 arch/powerpc/mm/mem.c                        |  2 --
 arch/powerpc/mm/nohash/8xx.c                 |  2 --
 7 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 93402a1d9c9f..74e514577ee5 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1296,9 +1296,8 @@ config TASK_SIZE_BOOL
 	  Say N here unless you know what you are doing.
 
 config TASK_SIZE
-	hex "Size of user task space" if TASK_SIZE_BOOL
+	hex "Size of maximum user task space" if TASK_SIZE_BOOL
 	default "0x80000000" if PPC_8xx
-	default "0xb0000000" if PPC_BOOK3S_32 && EXECMEM
 	default "0xc0000000"
 
 config MODULES_SIZE_BOOL
diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 92d21c6faf1e..d02d50ca0387 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -195,10 +195,6 @@ void unmap_kernel_page(unsigned long va);
 #define VMALLOC_END	ioremap_bot
 #endif
 
-#define MODULES_END	ALIGN_DOWN(PAGE_OFFSET, SZ_256M)
-#define MODULES_SIZE	(CONFIG_MODULES_SIZE * SZ_1M)
-#define MODULES_VADDR	(MODULES_END - MODULES_SIZE)
-
 #ifndef __ASSEMBLY__
 #include <linux/sched.h>
 #include <linux/threads.h>
diff --git a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
index 2986f9ba40b8..866574655ffe 100644
--- a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
@@ -170,10 +170,6 @@
 
 #define mmu_linear_psize	MMU_PAGE_8M
 
-#define MODULES_END	PAGE_OFFSET
-#define MODULES_SIZE	(CONFIG_MODULES_SIZE * SZ_1M)
-#define MODULES_VADDR	(MODULES_END - MODULES_SIZE)
-
 #ifndef __ASSEMBLY__
 
 #include <linux/mmdebug.h>
diff --git a/arch/powerpc/include/asm/task_size_32.h b/arch/powerpc/include/asm/task_size_32.h
index 30edc21f71fb..42a64bbd1964 100644
--- a/arch/powerpc/include/asm/task_size_32.h
+++ b/arch/powerpc/include/asm/task_size_32.h
@@ -2,11 +2,37 @@
 #ifndef _ASM_POWERPC_TASK_SIZE_32_H
 #define _ASM_POWERPC_TASK_SIZE_32_H
 
+#include <linux/sizes.h>
+
 #if CONFIG_TASK_SIZE > CONFIG_KERNEL_START
 #error User TASK_SIZE overlaps with KERNEL_START address
 #endif
 
+#ifdef CONFIG_PPC_8xx
+#define MODULES_END	ASM_CONST(CONFIG_PAGE_OFFSET)
+#define MODULES_SIZE	(CONFIG_MODULES_SIZE * SZ_1M)
+#define MODULES_VADDR	(MODULES_END - MODULES_SIZE)
+#define MODULES_BASE	(MODULES_VADDR & ~(UL(SZ_4M) - 1))
+#define USER_TOP	MODULES_BASE
+#endif
+
+#ifdef CONFIG_PPC_BOOK3S_32
+#define MODULES_END	(ASM_CONST(CONFIG_PAGE_OFFSET) & ~(UL(SZ_256M) - 1))
+#define MODULES_SIZE	(CONFIG_MODULES_SIZE * SZ_1M)
+#define MODULES_VADDR	(MODULES_END - MODULES_SIZE)
+#define MODULES_BASE	(MODULES_VADDR & ~(UL(SZ_256M) - 1))
+#define USER_TOP	MODULES_BASE
+#endif
+
+#ifndef USER_TOP
+#define USER_TOP	ASM_CONST(CONFIG_PAGE_OFFSET)
+#endif
+
+#if CONFIG_TASK_SIZE < USER_TOP
 #define TASK_SIZE ASM_CONST(CONFIG_TASK_SIZE)
+#else
+#define TASK_SIZE USER_TOP
+#endif
 
 /*
  * This decides where the kernel will search for a free chunk of vm space during
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index afc9b5cac5a6..35ef3a117d3f 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -223,8 +223,6 @@ int mmu_mark_initmem_nx(void)
 
 	update_bats();
 
-	BUILD_BUG_ON(ALIGN_DOWN(MODULES_VADDR, SZ_256M) < TASK_SIZE);
-
 	for (i = ALIGN(TASK_SIZE, SZ_256M) >> 28; i < 16; i++) {
 		/* Do not set NX on VM space for modules */
 		if (is_module_segment(i << 28))
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 3ddbfdbfa941..bc0f1a9eb0bc 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -401,8 +401,6 @@ struct execmem_info __init *execmem_arch_setup(void)
 #ifdef MODULES_VADDR
 	unsigned long limit = (unsigned long)_etext - SZ_32M;
 
-	BUILD_BUG_ON(TASK_SIZE > MODULES_VADDR);
-
 	/* First try within 32M limit from _etext to avoid branch trampolines */
 	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
 		start = limit;
diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index ab1505cf42bf..a9d3f4729ead 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -209,8 +209,6 @@ void __init setup_initial_memory_limit(phys_addr_t first_memblock_base,
 
 	/* 8xx can only access 32MB at the moment */
 	memblock_set_current_limit(min_t(u64, first_memblock_size, SZ_32M));
-
-	BUILD_BUG_ON(ALIGN_DOWN(MODULES_VADDR, PGDIR_SIZE) < TASK_SIZE);
 }
 
 int pud_clear_huge(pud_t *pud)
-- 
2.49.0


