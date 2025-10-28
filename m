Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BE4CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080C1800E4; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08EF8E0006; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82B2800E4; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A33A98E0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6096613AD7A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:23 +0000 (UTC)
X-FDA: 84046969566.28.C471916
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf05.hostedemail.com (Postfix) with ESMTP id 818BD10000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=fOcEPXGU;
	spf=pass (imf05.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMJKZ+2p9PBUN7gseAdsSiMzoHjEnudKWJcGtVvbpm0=;
	b=qnZTMShkYoxoNfKRTtPRfUpobSUDl/54Gq9bEz9BWkh7zI/aaeFx3AZBeeH8B+kOBkV9os
	8K4RuszbG/hZgE6stsdjNQPrzQS1+S8LXmkh9/SpP+90Wqbpzy2tQtBNfgrdRlECm25jS3
	+kGV/tNgBOOmRaF9iqeeV3u+LEwh7rg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643041; a=rsa-sha256;
	cv=none;
	b=avcf9QmWJmoyravn84IlW+8d38Yp7XB/mtASNUSvyG1algsWly2PyMAvUQ6LlFwGB+38PE
	DyYAz1RqUJ55xl6gGt5yFtSU8KJIjQWbhA9jHaBVB0D5oX1W626ReYAFc+wxpW9QZEis0Y
	yJeBsi6YEnOewj9cbg+n+mSkY8EvsSQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=fOcEPXGU;
	spf=pass (imf05.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643037;
	bh=cyZyLundsyMK8gnrV8YrT8OZRfND/4ZKZAJIIljhbPk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fOcEPXGUde//TsAO89amRNfwk5vWdNVZYP+aINNzg7rgHGEX2bDHMTBjLH3TtKGFK
	 Kfxb8beObEbV9UDf8PxXAbWah1gfqirT5lfg8X8kpKypwItBTK7eXx8G2XZBHI+tAT
	 RU+j41JM3dcNxrsnz7E9s/vpjuUXU3Mw3KPPRRFM=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:39 +0100
Subject: [PATCH 04/10] x86/um: Do not inherit vDSO from host
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-4-e930063eff5f@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=7417;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=cyZyLundsyMK8gnrV8YrT8OZRfND/4ZKZAJIIljhbPk=;
 b=ErJu3hMj+Bqp4vF/M1+WxLQlIk5OXTslG7g273YGeACre+TpEugV839ttL9O5pU9rApJw0PoY
 XrePoO60HNiANfsfcDOlfyYLgfmuAiPahGEaDHecL2nvssfzBLDgjok
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspamd-Server: rspam05
X-Stat-Signature: iw5nreguc95fhhcuh79knfpmj1bixf3n
X-Rspam-User: 
X-Rspamd-Queue-Id: 818BD10000A
X-HE-Tag: 1761643041-495974
X-HE-Meta: U2FsdGVkX1/9h5ucEKBxUxbTgenWOeHALaqZm1N95RqQmQYYjVAyPZVd1hWw6uZ2Gwbyv8IAL9PjlRGJEdRJul8JWa5lf3u5o5a0WJorj1Ps+UlnEkOS7o8s7tOOa77zmdSaJcRkomBsZA+gXH+vwnsHa+GCkimCqfGw55B+o3LFOJEW9nUebBSHCWADveLs8P9+PwKBEF9h2vy4f3fWS6BFZF3z/lP+NvX38tJl++CnJAz7aE/51b/10FTYYpkryYyz/9mWwgTQGE5c52G3WYIcAH10Q1PdEP9z/hw0IsvEF6DgzJZQv5B5bhU6M4X89oP1AbN0t3G90041M/NQEJiDn8gQ64D43JLg7mf9FSslERyQFgrsfY1qDXn5AzBGTinqQc0V4bW5/GhoiGbDf3qOPkYvo3ual8wMcxOdt8TAb+CFxLFnvPVRs4mzNCSl0J1W6T/o9v0dt0A5FVEnac5YTWp7EjvuhE8fjwIGWvXTEe9PJeCarnDWuJmFGHFqgfLlW0tEBe1ERUCPUdKyKe6iOODHKNhHjJ3X+vap/iWrVd0vZKzviBc4950LmhIujJ5rrplfF5Zg8dGXJZaItFZuC6vePKl1y3+lIuykBCU2zOi9UctzTCvDSHgpVjpsWm1XwYwYctjcXfvtkgSf/UN9oBkTeyd4hO23LxDShknPqX3szwkjjoGGKzlCmPHGvjtnFiXXg6wVyqhTiFjON9VwIms9dux03jXrA7uFe3YCTBiZMyAsedV9wghOW1bjjTP8SbKChgEChUm02/5GMWYMjhj4awvTX0VLNz5TIrJzAQy1qZxBHN0uzTcX8dqG27MsGP8LVmYULZodn9Yz7ZH1xzdIUq75Wlnc3HmFLR3ajkQMLRRlUDV6wkEVXzp4u/XiNF5hMipkzYL0/oEVeEcKIAoskWrinQey0UNZyfm9jGjEYTvM0lFT85YsNsvQMOaSjhzhEDVaFm5Ouo7
 c5g08t0x
 oxBxW84XZeqNwws1cRnLftg1vSm3O+OOu0mnIT6CElwkDvh6piWqlHxIE31BiRRmuM6S4zvc6o4Y3swT039d3JcSM/05BMEnMnfOKwAUF5ziwFPVDqbHcRu9k8/wwD+a33TsrGiVCmf8VK+abcRQm08FgvZ/KygO8yRuCOX9Q1NPibRGTozuc+ie0l/SWpQE+6E07WSVCLDgUqrNNUF77fgxhgec7xU/ZC32XFMFE+HlrGC0HFVEPOLT1XA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inheriting the vDSO from the host is problematic. The values read
from the time functions will not be correct for the UML kernel.
Furthermore the start and end of the vDSO are not stable or
detectable by userspace. Specifically the vDSO datapages start
before AT_SYSINFO_EHDR and the vDSO itself is larger than a single page.

This codepath is only used on 32bit x86 UML. In my testing with both
32bit and 64bit hosts the passthrough functionality has always been
disabled anyways due to the checks against envp in scan_elf_aux().

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/os-Linux/elf_aux.c   | 27 ---------------
 arch/um/os-Linux/user_syms.c |  6 ----
 arch/x86/um/Kconfig          |  1 -
 arch/x86/um/Makefile         |  1 -
 arch/x86/um/asm/elf.h        | 29 ++--------------
 arch/x86/um/elfcore.c        | 78 --------------------------------------------
 6 files changed, 3 insertions(+), 139 deletions(-)

diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index 9ee0e3199790..f8927a5959d8 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -20,31 +20,15 @@ typedef Elf32_auxv_t elf_auxv_t;
 /* These are initialized very early in boot and never changed */
 char * elf_aux_platform;
 extern long elf_aux_hwcap;
-unsigned long vsyscall_ehdr;
-unsigned long vsyscall_end;
-unsigned long __kernel_vsyscall;
 
 __init void scan_elf_aux( char **envp)
 {
-	long page_size = 0;
 	elf_auxv_t * auxv;
 
 	while ( *envp++ != NULL) ;
 
 	for ( auxv = (elf_auxv_t *)envp; auxv->a_type != AT_NULL; auxv++) {
 		switch ( auxv->a_type ) {
-			case AT_SYSINFO:
-				__kernel_vsyscall = auxv->a_un.a_val;
-				/* See if the page is under TASK_SIZE */
-				if (__kernel_vsyscall < (unsigned long) envp)
-					__kernel_vsyscall = 0;
-				break;
-			case AT_SYSINFO_EHDR:
-				vsyscall_ehdr = auxv->a_un.a_val;
-				/* See if the page is under TASK_SIZE */
-				if (vsyscall_ehdr < (unsigned long) envp)
-					vsyscall_ehdr = 0;
-				break;
 			case AT_HWCAP:
 				elf_aux_hwcap = auxv->a_un.a_val;
 				break;
@@ -56,17 +40,6 @@ __init void scan_elf_aux( char **envp)
 				elf_aux_platform =
 					(char *) (long) auxv->a_un.a_val;
 				break;
-			case AT_PAGESZ:
-				page_size = auxv->a_un.a_val;
-				break;
 		}
 	}
-	if ( ! __kernel_vsyscall || ! vsyscall_ehdr ||
-	     ! page_size || (vsyscall_ehdr % page_size) ) {
-		__kernel_vsyscall = 0;
-		vsyscall_ehdr = 0;
-	}
-	else {
-		vsyscall_end = vsyscall_ehdr + page_size;
-	}
 }
diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
index a310ae27b479..67f6112318b6 100644
--- a/arch/um/os-Linux/user_syms.c
+++ b/arch/um/os-Linux/user_syms.c
@@ -31,12 +31,6 @@ extern void *memset(void *, int, size_t);
 EXPORT_SYMBOL(memset);
 #endif
 
-#ifdef CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA
-/* needed for __access_ok() */
-EXPORT_SYMBOL(vsyscall_ehdr);
-EXPORT_SYMBOL(vsyscall_end);
-#endif
-
 #ifdef _FORTIFY_SOURCE
 extern int __sprintf_chk(char *str, int flag, size_t len, const char *format);
 EXPORT_SYMBOL(__sprintf_chk);
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index c52fb5cb8d21..798c6cc53e82 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -8,7 +8,6 @@ endmenu
 
 config UML_X86
 	def_bool y
-	select ARCH_BINFMT_ELF_EXTRA_PHDRS if X86_32
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select DCACHE_WORD_ACCESS
diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index b42c31cd2390..1767e6061b4d 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -18,7 +18,6 @@ obj-y = bugs_$(BITS).o delay.o fault.o \
 ifeq ($(CONFIG_X86_32),y)
 
 obj-y += syscalls_32.o
-obj-$(CONFIG_ELF_CORE) += elfcore.o
 
 subarch-y = ../lib/string_32.o ../lib/atomic64_32.o ../lib/atomic64_cx8_32.o
 subarch-y += ../lib/cmpxchg8b_emu.o ../lib/atomic64_386_32.o
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index e7a045e01471..8d7df4684c38 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -72,32 +72,9 @@ extern char * elf_aux_platform;
 #define ELF_PLATFORM_FALLBACK "i586"
 #define ELF_PLATFORM (elf_aux_platform ?: ELF_PLATFORM_FALLBACK)
 
-extern unsigned long vsyscall_ehdr;
-extern unsigned long vsyscall_end;
-extern unsigned long __kernel_vsyscall;
-
-/*
- * This is the range that is readable by user mode, and things
- * acting like user mode such as get_user_pages.
- */
-#define FIXADDR_USER_START      vsyscall_ehdr
-#define FIXADDR_USER_END        vsyscall_end
-
-
-/*
- * Architecture-neutral AT_ values in 0-17, leave some room
- * for more of them, start the x86-specific ones at 32.
- */
-#define AT_SYSINFO		32
-#define AT_SYSINFO_EHDR		33
-
-#define ARCH_DLINFO						\
-do {								\
-	if ( vsyscall_ehdr ) {					\
-		NEW_AUX_ENT(AT_SYSINFO,	__kernel_vsyscall);	\
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, vsyscall_ehdr);	\
-	}							\
-} while (0)
+/* No user-accessible fixmap addresses, i.e. vsyscall */
+#define FIXADDR_USER_START      0
+#define FIXADDR_USER_END        0
 
 #else
 
diff --git a/arch/x86/um/elfcore.c b/arch/x86/um/elfcore.c
deleted file mode 100644
index ef50662fc40d..000000000000
--- a/arch/x86/um/elfcore.c
+++ /dev/null
@@ -1,78 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/elf.h>
-#include <linux/elfcore.h>
-#include <linux/coredump.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-
-#include <asm/elf.h>
-
-
-Elf32_Half elf_core_extra_phdrs(struct coredump_params *cprm)
-{
-	return vsyscall_ehdr ? (((struct elfhdr *)vsyscall_ehdr)->e_phnum) : 0;
-}
-
-int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
-{
-	if ( vsyscall_ehdr ) {
-		const struct elfhdr *const ehdrp =
-			(struct elfhdr *) vsyscall_ehdr;
-		const struct elf_phdr *const phdrp =
-			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
-		int i;
-		Elf32_Off ofs = 0;
-
-		for (i = 0; i < ehdrp->e_phnum; ++i) {
-			struct elf_phdr phdr = phdrp[i];
-
-			if (phdr.p_type == PT_LOAD) {
-				ofs = phdr.p_offset = offset;
-				offset += phdr.p_filesz;
-			} else {
-				phdr.p_offset += ofs;
-			}
-			phdr.p_paddr = 0; /* match other core phdrs */
-			if (!dump_emit(cprm, &phdr, sizeof(phdr)))
-				return 0;
-		}
-	}
-	return 1;
-}
-
-int elf_core_write_extra_data(struct coredump_params *cprm)
-{
-	if ( vsyscall_ehdr ) {
-		const struct elfhdr *const ehdrp =
-			(struct elfhdr *) vsyscall_ehdr;
-		const struct elf_phdr *const phdrp =
-			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
-		int i;
-
-		for (i = 0; i < ehdrp->e_phnum; ++i) {
-			if (phdrp[i].p_type == PT_LOAD) {
-				void *addr = (void *) phdrp[i].p_vaddr;
-				size_t filesz = phdrp[i].p_filesz;
-				if (!dump_emit(cprm, addr, filesz))
-					return 0;
-			}
-		}
-	}
-	return 1;
-}
-
-size_t elf_core_extra_data_size(struct coredump_params *cprm)
-{
-	if ( vsyscall_ehdr ) {
-		const struct elfhdr *const ehdrp =
-			(struct elfhdr *)vsyscall_ehdr;
-		const struct elf_phdr *const phdrp =
-			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
-		int i;
-
-		for (i = 0; i < ehdrp->e_phnum; ++i)
-			if (phdrp[i].p_type == PT_LOAD)
-				return (size_t) phdrp[i].p_filesz;
-	}
-	return 0;
-}

-- 
2.51.1.dirty


