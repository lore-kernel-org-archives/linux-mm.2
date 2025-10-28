Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449D3CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECF28012D; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F42088012E; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2E18012D; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5E838012E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83ADC885C7
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:26 +0000 (UTC)
X-FDA: 84046969692.06.1003E9A
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A70FA0017
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=bhTSQc+M;
	spf=pass (imf15.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q34nTOaqy3DhfsQv2suPwzL0o80tfMD+CKeIBR3BDS4=;
	b=AdAZg1me4Q2F86zYYndV0nz4fYjJYzwC9hsHn2VIZAX7hSWMlFNvwYS+KJ8Y1LI2RMlSel
	e2dHkFkH/1m+oRDHbcLfjoXmNagRCNIkad++NEDUtuY3U3eDau6N4zFgJ6hH5t58oJbQSQ
	0QxbW9ho9sIf9JtTmlcvIVLL3XNBl08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643044; a=rsa-sha256;
	cv=none;
	b=ta7edNiKg9RoNqCADioEvNjZuf+AEzmqEDQBO4JYro0jaQeCOpDHzSHoMOe3y9F51GbGJ9
	w/DHAx/or64EOd9YM2CAmGaxERL5/dQ5B8gSh16z9ULaCstg60+uxWcsM3Ot4u+6Mi/7BQ
	af8TdTIAqK0JS+xhcEk+m0b7Jhir9Jc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=bhTSQc+M;
	spf=pass (imf15.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643039;
	bh=jBXvd5o8xd7AxDkdev4MjEnueBp7q9FqgNwPncpJjP4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bhTSQc+MY8Q4Cb+L9hfMs4rpSyUf5r09v4+C8O9IY/bbbuhUeh4np0tT66UmWWWFy
	 a8OZaeJ8mBgHbZD8bQdIv0kZBBNNaw8+vPz9/f2gUJ41umiZ1ftofd4YJQOTG5lE7f
	 wBsch4Zd6p/JxPiev10JnJhD5LKWA361L0jQQpNU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:45 +0100
Subject: [PATCH 10/10] um: Always set up AT_HWCAP and AT_PLATFORM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-10-e930063eff5f@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=3821;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=jBXvd5o8xd7AxDkdev4MjEnueBp7q9FqgNwPncpJjP4=;
 b=l/5J9hB4UN4Sm4P7Sd031ZesVQaS000sV+zNJuYPMvpNlqHe+eaZ7Dhvyr9wnNWMKKghulBXM
 bI1FX/3fgRwDwcgAxTVaiUY1rpJZ2iMUr1X0NnzY9WZIKRwnVaUfC9Y
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspamd-Server: rspam05
X-Stat-Signature: pme1ng58ntpio1b5tprmxm8s39tkaq9o
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A70FA0017
X-HE-Tag: 1761643044-464938
X-HE-Meta: U2FsdGVkX196NF4+T95Zdv9vihBy0mJswozRLL9reFZPc80hMia9vVk0mJDiwrq1WMwDS7DY9y8TDRrICGXt7FfuDpCQ7T3LbVGjDD8eTmUjxQpRfWCsObhyoBMOyMm4S9bI9OWFHoBWSk0NBzGD42yQ6j4Lm1LdyAZ4Mt4sUDxlrzHSPZJmu2aNRMPsZF2TKk5GJ0tY0SgsbSekBsdyqTo6mcMX4d5YAqNfkdAsr5RjGymcTrTe+43NOK0ifcAXH/8qsyWwG58B+SfDm2vutenuI1JYCCx+yE8jYdzd+V0mqvXokEZ//c5cMtI8zsqwR6uQy686/9pKXe4ePAKs/ydmqhefzcq2ZvfkKwqHvkHWjUAi1pdi8x3aMunySBrVBnftkIE0te3g66DPZfwmzG31mq2aIhshdv2zG05g5jWq+Iozpcedzg+SL6r2mm6J0IOOvkdg2OhPzNe9GsAodVY6QiHCRuBr/1DAxIvD/+4GKBlzCl4xpGCG+V86KmR0w5Bq14cOBQVocAhlpSslB8SOVO1sPlXVD94UdFSadGgEr5toDxWdCSvtr+An48tobWCEMp6lw14o0RZQmwlsAEXeokcq61sn0ZDkZsBPZMIg2lBnO2Sg2ISIyTFIEz6Y7OPvoqxU46S3RfqOx+pSa5StqOdneXGWJMxnERGCN9ljcBHH78nb6oKj0eo2M+hbKjRJDjlGXq7eIgN96FFPL7o7aJ0Y7K7+etrlADS5ziNFx4idjiPfn5ykIY4+6FU+zK70BJDzCilbt9UWNRy1B+bVXLqWvEFVHGkj+ixHnkHSSBq8qhneKBHRSWinsHbuXEC/1NyeI62RGBtGU4bYXjUXIL3xPB4dwL8c8axC4A2QsWdURo7ftJvZ8A/B1Dc60CpAFwRcxKcIhzd4YsgHBRk31QFDgcerox8RD1NJt0WIbyy4ZOKAyQ5O+nVlu2MX9Ce67N7LxtmmpCyMqRi
 g/mpQinX
 9H9ewppA/FWq8t/J4yFGzef5NIQAg6WZGzbC1hlRzmNd10Jmyz9rYeNWGWkqGl2i4uaLsbhaXvL8TaR0XcLFGIM4LyK6WSoIfYuImICN36pZDfi3NsBqQ/d5KiQUZ34+j0s88KwYOuA9njmE/rrKLXiUNKzUG2mNXbFPpmZV+D57KMl9Al8FSg91IC6ZN6EE+b9r6H/m/f+di3a9vH5Gf+pt17udtUPrSy9JDYaILIQKVSDV0xr8Io1//frk6SocdutQS+3MANgpiP/JKLsTjL65t9bcXbledD+pHxb+S2Y4Q7FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically the code to set up AT_HWCAP and AT_PLATFORM was only built
for 32bit x86 as it was intermingled with the vDSO passthrough code.

Now that vDSO passthrough has been removed, always pass through AT_HWCAP
and AT_PLATFORM.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/os-Linux/Makefile  | 4 +---
 arch/um/os-Linux/elf_aux.c | 7 ++++++-
 arch/um/os-Linux/main.c    | 4 ----
 arch/x86/um/Kconfig        | 3 ---
 arch/x86/um/asm/elf.h      | 7 ++++---
 5 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index 70c73c22f715..f8d672d570d9 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -6,7 +6,7 @@
 # Don't instrument UML-specific code
 KCOV_INSTRUMENT                := n
 
-obj-y = execvp.o file.o helper.o irq.o main.o mem.o process.o \
+obj-y = elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o \
 	umid.o user_syms.o util.o skas/
 
@@ -14,8 +14,6 @@ CFLAGS_signal.o += -Wframe-larger-than=4096
 
 CFLAGS_main.o += -Wno-frame-larger-than
 
-obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
-
 obj-$(CONFIG_SMP) += smp.o
 
 USER_OBJS := $(user-objs-y) elf_aux.o execvp.o file.o helper.o irq.o \
diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index f8927a5959d8..72f416edf252 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -14,12 +14,17 @@
 #include <elf_user.h>
 #include <mem_user.h>
 #include "internal.h"
+#include <linux/swab.h>
 
+#if __BITS_PER_LONG == 64
+typedef Elf64_auxv_t elf_auxv_t;
+#else
 typedef Elf32_auxv_t elf_auxv_t;
+#endif
 
 /* These are initialized very early in boot and never changed */
 char * elf_aux_platform;
-extern long elf_aux_hwcap;
+long elf_aux_hwcap;
 
 __init void scan_elf_aux( char **envp)
 {
diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index 730723106228..7e114862a723 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -21,8 +21,6 @@
 
 #define STACKSIZE (8 * 1024 * 1024)
 
-long elf_aux_hwcap;
-
 static void __init set_stklim(void)
 {
 	struct rlimit lim;
@@ -149,9 +147,7 @@ int __init main(int argc, char **argv, char **envp)
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
 
-#ifdef CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA
 	scan_elf_aux(envp);
-#endif
 
 	change_sig(SIGPIPE, 0);
 	ret = linux_main(argc, argv, envp);
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 798c6cc53e82..bdd7c8e39b01 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -34,8 +34,5 @@ config X86_64
 config ARCH_HAS_SC_SIGNALS
 	def_bool !64BIT
 
-config ARCH_REUSE_HOST_VSYSCALL_AREA
-	def_bool !64BIT
-
 config GENERIC_HWEIGHT
 	def_bool y
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index fdd5a612f678..22d0111b543b 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -68,9 +68,7 @@
 	pr_reg[16] = PT_REGS_SS(regs);		\
 } while (0);
 
-extern char * elf_aux_platform;
 #define ELF_PLATFORM_FALLBACK "i586"
-#define ELF_PLATFORM (elf_aux_platform ?: ELF_PLATFORM_FALLBACK)
 
 #else
 
@@ -151,7 +149,7 @@ extern char * elf_aux_platform;
 	(pr_reg)[25] = 0;					\
 	(pr_reg)[26] = 0;
 
-#define ELF_PLATFORM "x86_64"
+#define ELF_PLATFORM_FALLBACK "x86_64"
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 struct linux_binprm;
@@ -180,6 +178,9 @@ struct task_struct;
 extern long elf_aux_hwcap;
 #define ELF_HWCAP (elf_aux_hwcap)
 
+extern char *elf_aux_platform;
+#define ELF_PLATFORM (elf_aux_platform ?: ELF_PLATFORM_FALLBACK)
+
 #define SET_PERSONALITY(ex) do {} while(0)
 
 #endif

-- 
2.51.1.dirty


