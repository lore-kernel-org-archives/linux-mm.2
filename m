Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86CDC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7845C6B00B5; Mon, 20 Jul 2026 16:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75BC46B00B6; Mon, 20 Jul 2026 16:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CC46B00B8; Mon, 20 Jul 2026 16:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2473F6B00B5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:55:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3B321C02FA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:55:19 +0000 (UTC)
X-FDA: 85010360358.07.3D3D7C1
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70D3E1C000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:55:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b="D/RcsDS2";
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784580918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bn0OPPHDLrPNo248991htmvWYggkIEJNcp5ynt/7bC8=;
	b=w3nLrrfZRkiIOtAcWO0fWDcz9RoMaUz+Ea5Tg99gDBalgIEKQvO6iulLz+owti99Kbfy97
	DEHea/fFHEgwavptUrv/kWpU/kY3BP5Ow5G6DxfED59UY9FcfPilp1Pd9U/7ASX8qvKj8S
	7PxhsadE5jLK7dbVpQ9hVhxYDjaExJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b="D/RcsDS2";
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784580918;
	b=p96IOIjRq2O7Eruft8fxlRJ4SelhqSDoz8ZRBg6+CYJlIvfbJxabRw0nbC9wnmplvATI7b
	ohAB0YnGCAa1QZtShbRuabNgvqXF2FPrhbVVxE4AD9QMqrhz6a9oZYUF1rJL5rkWZJfxO3
	zgN76ojIYncaaXgOMUFChd9PV8vMWj4=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 66KKsvRT4008460
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 20 Jul 2026 13:54:58 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 66KKsvRT4008460
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1784580899;
	bh=Bn0OPPHDLrPNo248991htmvWYggkIEJNcp5ynt/7bC8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=D/RcsDS2+D8bqOsleCmb0Yl8x3M0oaT4yQhn0sSTiLqozAw0jVi7QtMpWbU7x9lAa
	 Hxvued9XE7GMdLyBoeIStvRpaHN0pz6hZmDnLEtOwNC/ahjeRU/gBJf7X+ALLhAu5R
	 XqF6xpR42fXKlHP+cI0Neb9oCnV0Lq4hdnGFaRvmYHpoM06NEk3LVbRIuvjAn6uh2p
	 Y3Hfp4mBjHTvQAukMkc8GPi/fOVbR7fozia39mTFPdq21TI1faxvtH8Q9+Ong56IWS
	 9mV5AvMD6xa9zxDBFUYyRA6NNCjPUmQgO9sB2nInCZjZqicXNGwUE++QS9GhYXgUlh
	 NIR+7afNQfgxg==
Date: Mon, 20 Jul 2026 13:54:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Luiz Capitulino <luizcap@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
        corbet@lwn.net, "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v2] x86: remove the BIOS memory corruption check feature
User-Agent: K-9 Mail for Android
In-Reply-To: <9e1a161e-9246-41d1-9651-ffa85b1bc99b@redhat.com>
References: <9e1a161e-9246-41d1-9651-ffa85b1bc99b@redhat.com>
Message-ID: <62515FC9-68B1-439D-B81E-E184597515B3@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70D3E1C000D
X-Stat-Signature: q3iinfktnzmksttsmuwfxgtz1hwdp6zr
X-HE-Tag: 1784580917-569750
X-HE-Meta: U2FsdGVkX196Dvf1X1eBxbTZP5hqKpWDgZZa4v2xuELSy+AYDbA8wbhnzaeHhyKMY2OsCglo44/w8ja9fofiutlabisS3IhVtv2pVtk62Np8Nxnq9rRQbfYchRw/fU66Vj/a5UfWmnizR0dLlmVD5ytaS9iHkMXzZaIgBQnP/5RiMNgvmDb5gDChNNhRA4FUg/i9hDlpPyZwI2R9tzBsNq8CIKOeTqRd3XswNgaa4/QVNzrI7rWdNGFi9lsYZ6fD3ZhvRen7zKMdVyfAPaSr1aJgbrPrhAyoSTcGroDMf2N1oFCkL8+vlMwq1/RoxeM23N/AAcOjXEESmZ+G0gN2tksSMDleXQ+7dZu14kJ7Fv+X594uX+nFyPjiIhxW4I1GXFMY5v7mAdF3cOT/QrRhjQO8xjU+1KQ4qsCaRNV9LdKpzWX16dGMytOnBkYUuK/1xO13ritYUspVxPTv6JpUh8uqbQsDCCLDND6M61JiGfIRLlVEnTSzC5zx8nkLkB6SpWvIJiub/6ZM1PjrFLIfKy5NLQottTzIODG81TXZz2m59GrsTX1x5T9oxuY/ZsSwlCoXy2Uii5FZ0A0EeXXQvgYyMf6LkFrctffO+1WE66U6RgNP7BcG6FCXnlpF3VHYTMY6eHMZcS7ROLPxAKpgNbL3/oQZWzKQtR7V6B3PJd6ZtX/5c/ksL2O2fjhaRaxK1BsKFrr2hDk9JOqavEZKN7Vlr3lkxp5aRfOhdLKOoo7qhNlhaODVPI7OHUX2y2Bc6YZGQk/BP2ofEYZBJ502sjtQrlsTcJYUHQ7ryRLi1gTIWxiIGssse6w9qixAHDdRSxN0+jUn157ozkhHj+SO/KQdfm7RKJqbvvWwwpMyEtG3YZtrHp9sMIB74uR82x7yZK4cPaJHYJ2q1OGBeOJyY9xJ75Kh2EgAh7EwIhLWIR1uehIUTK17p44cUe+ImKdartJ8N4acnVjqm8K6xKL
 Af3594xw
 k2bjzW7Al7CBINl+2dSemTOsqCT9RyLgPSPWxyargT88LO90lRmDRQvB0RHeTvGTWTs5BKsk3qYLeBAqrT6djr/ZvjojqbYXXrJLqxvQobNUUUXGTGeHTrMFrN/4zm8O8AfVkT3gAB9/IAmQaA4p66AIHuiD7exZgbztn25rVTcsKp4Zu7M13tBn96fiF7BAJjz8sxOqZaCqouAF2cSlNR2oDk9Q5XEmkdUEcE+wVXH8FJG0QlMWsCTv2ep+zo0V+uYuBKIwJT0377JMunuKOMCz2SD8LNvpJOKwSZP5clzJ5UJMHIERaf3p0Kx+2nlVDZrhT9HeFR88KjQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On July 20, 2026 1:41:05 PM PDT, Luiz Capitulino <luizcap@redhat=2Ecom> wro=
te:
>By default, the BIOS memory corruption check works by reserving the
>first 64 KiB physical area from memblock, zeroing it and then scanning it
>periodically=2E
>
>However, this functionality has been broken since v5=2E13 by two commits:
>
>- Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations"=
)=2E
>  Moved trim_low_memory_range() into early_reserve_memory(), which runs
>  earlier in setup_arch(), causing the first 64 KiB to be reserved (when
>  CONFIG_X86_RESERVE_LOW=3D64) before setup_bios_corruption_check() runs
>
>- Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM")=
=2E
>  Hardcodes the reservation of the first 64 KiB early in
>  early_reserve_memory()
>
>It might be possible to get this feature to work by allowing
>setup_bios_corruption_check() to run first, but it's just not worth it
>given that the kernel will never access this memory area anyways=2E
>
>Signed-off-by: Luiz Capitulino <luizcap@redhat=2Ecom>
>---
>
>Changelog
>=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>v2
>- Rebase against latest Linus tree (v7=2E2-rc4)
>- Improve changelog
>
> =2E=2E=2E/admin-guide/kernel-parameters=2Etxt         |  23 ---
> arch/x86/Kconfig                              |  30 ---
> arch/x86/configs/i386_defconfig               |   1 -
> arch/x86/configs/x86_64_defconfig             |   1 -
> arch/x86/include/asm/bios_ebda=2Eh              |  17 --
> arch/x86/include/asm/setup=2Eh                  |   1 -
> arch/x86/kernel/Makefile                      |   2 -
> arch/x86/kernel/check=2Ec                       | 187 ------------------
> arch/x86/kernel/setup=2Ec                       |   4 -
> 9 files changed, 266 deletions(-)
> delete mode 100644 arch/x86/kernel/check=2Ec
>
>diff --git a/Documentation/admin-guide/kernel-parameters=2Etxt b/Document=
ation/admin-guide/kernel-parameters=2Etxt
>index b5493a7f8f22=2E=2E314a2a0dc9cd 100644
>--- a/Documentation/admin-guide/kernel-parameters=2Etxt
>+++ b/Documentation/admin-guide/kernel-parameters=2Etxt
>@@ -3935,29 +3935,6 @@ Kernel parameters
> 			specified as e820 types, e=2Eg=2E, 1 =3D RAM, 2 =3D reserved,
> 			3 =3D ACPI, 12 =3D PRAM=2E
> -	memory_corruption_check=3D0/1 [X86,EARLY]
>-			Some BIOSes seem to corrupt the first 64k of
>-			memory when doing things like suspend/resume=2E
>-			Setting this option will scan the memory
>-			looking for corruption=2E  Enabling this will
>-			both detect corruption and prevent the kernel
>-			from using the memory being corrupted=2E
>-			However, it's intended as a diagnostic tool; if
>-			repeatable BIOS-originated corruption always
>-			affects the same memory, you can use memmap=3D
>-			to prevent the kernel from using that memory=2E
>-
>-	memory_corruption_check_size=3Dsize [X86,EARLY]
>-			By default it checks for corruption in the low
>-			64k, making this memory unavailable for normal
>-			use=2E  Use this parameter to scan for
>-			corruption in more or less memory=2E
>-
>-	memory_corruption_check_period=3Dseconds [X86,EARLY]
>-			By default it checks for corruption every 60
>-			seconds=2E  Use this parameter to check at some
>-			other rate=2E  0 disables periodic checking=2E
>-
> 	memory_hotplug=2Ememmap_on_memory
> 			[KNL,X86,ARM] Boolean flag to enable this feature=2E
> 			Format: {on | off (default)}
>diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>index bdad90f210e4=2E=2Ecce558ca5c6c 100644
>--- a/arch/x86/Kconfig
>+++ b/arch/x86/Kconfig
>@@ -1601,36 +1601,6 @@ config X86_PMEM_LEGACY
>  	  Say Y if unsure=2E
> -config X86_CHECK_BIOS_CORRUPTION
>-	bool "Check for low memory corruption"
>-	help
>-	  Periodically check for memory corruption in low memory, which
>-	  is suspected to be caused by BIOS=2E  Even when enabled in the
>-	  configuration, it is disabled at runtime=2E  Enable it by
>-	  setting "memory_corruption_check=3D1" on the kernel command
>-	  line=2E  By default it scans the low 64k of memory every 60
>-	  seconds; see the memory_corruption_check_size and
>-	  memory_corruption_check_period parameters in
>-	  Documentation/admin-guide/kernel-parameters=2Erst to adjust this=2E
>-
>-	  When enabled with the default parameters, this option has
>-	  almost no overhead, as it reserves a relatively small amount
>-	  of memory and scans it infrequently=2E  It both detects corruption
>-	  and prevents it from affecting the running system=2E
>-
>-	  It is, however, intended as a diagnostic tool; if repeatable
>-	  BIOS-originated corruption always affects the same memory,
>-	  you can use memmap=3D to prevent the kernel from using that
>-	  memory=2E
>-
>-config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
>-	bool "Set the default setting of memory_corruption_check"
>-	depends on X86_CHECK_BIOS_CORRUPTION
>-	default y
>-	help
>-	  Set whether the default state of memory_corruption_check is
>-	  on or off=2E
>-
> config MTRR
> 	def_bool y
> 	prompt "MTRR (Memory Type Range Register) support" if EXPERT
>diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defc=
onfig
>index 79fa38ca954d=2E=2E848c2d924668 100644
>--- a/arch/x86/configs/i386_defconfig
>+++ b/arch/x86/configs/i386_defconfig
>@@ -36,7 +36,6 @@ CONFIG_PARAVIRT=3Dy
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=3Dy
> CONFIG_X86_MSR=3Dy
> CONFIG_X86_CPUID=3Dy
>-CONFIG_X86_CHECK_BIOS_CORRUPTION=3Dy
> # CONFIG_MTRR_SANITIZER is not set
> CONFIG_EFI=3Dy
> CONFIG_EFI_STUB=3Dy
>diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_=
defconfig
>index 269f7d808be4=2E=2Ee05d67f708cb 100644
>--- a/arch/x86/configs/x86_64_defconfig
>+++ b/arch/x86/configs/x86_64_defconfig
>@@ -35,7 +35,6 @@ CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=3Dy
> CONFIG_X86_MSR=3Dy
> CONFIG_X86_CPUID=3Dy
> CONFIG_NUMA=3Dy
>-CONFIG_X86_CHECK_BIOS_CORRUPTION=3Dy
> # CONFIG_MTRR_SANITIZER is not set
> CONFIG_EFI=3Dy
> CONFIG_EFI_STUB=3Dy
>diff --git a/arch/x86/include/asm/bios_ebda=2Eh b/arch/x86/include/asm/bi=
os_ebda=2Eh
>index 4d5a17e2febe=2E=2E2f441fd9ebf8 100644
>--- a/arch/x86/include/asm/bios_ebda=2Eh
>+++ b/arch/x86/include/asm/bios_ebda=2Eh
>@@ -20,21 +20,4 @@ static inline unsigned int get_bios_ebda(void)
>  void reserve_bios_regions(void);
> -#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
>-/*
>- * This is obviously not a great place for this, but we want to be
>- * able to scatter it around anywhere in the kernel=2E
>- */
>-void check_for_bios_corruption(void);
>-void start_periodic_check_for_corruption(void);
>-#else
>-static inline void check_for_bios_corruption(void)
>-{
>-}
>-
>-static inline void start_periodic_check_for_corruption(void)
>-{
>-}
>-#endif
>-
> #endif /* _ASM_X86_BIOS_EBDA_H */
>diff --git a/arch/x86/include/asm/setup=2Eh b/arch/x86/include/asm/setup=
=2Eh
>index 914eb32581c7=2E=2E1f58361eb038 100644
>--- a/arch/x86/include/asm/setup=2Eh
>+++ b/arch/x86/include/asm/setup=2Eh
>@@ -42,7 +42,6 @@ static inline void vsmp_init(void) { }
>  struct pt_regs;
> -void setup_bios_corruption_check(void);
> void early_platform_quirks(void);
>  extern unsigned long saved_video_mode;
>diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>index 31f46fd00527=2E=2E702536938433 100644
>--- a/arch/x86/kernel/Makefile
>+++ b/arch/x86/kernel/Makefile
>@@ -149,8 +149,6 @@ obj-$(CONFIG_JAILHOUSE_GUEST)	+=3D jailhouse=2Eo
> obj-$(CONFIG_EISA)		+=3D eisa=2Eo
> obj-$(CONFIG_PCSPKR_PLATFORM)	+=3D pcspeaker=2Eo
> -obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) +=3D check=2Eo
>-
> obj-$(CONFIG_OF)			+=3D devicetree=2Eo
> obj-$(CONFIG_UPROBES)			+=3D uprobes=2Eo
> diff --git a/arch/x86/kernel/check=2Ec b/arch/x86/kernel/check=2Ec
>deleted file mode 100644
>index 5136e6818da8=2E=2E000000000000
>--- a/arch/x86/kernel/check=2Ec
>+++ /dev/null
>@@ -1,187 +0,0 @@
>-// SPDX-License-Identifier: GPL-2=2E0
>-
>-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>-
>-#include <linux/init=2Eh>
>-#include <linux/sched=2Eh>
>-#include <linux/kthread=2Eh>
>-#include <linux/workqueue=2Eh>
>-#include <linux/memblock=2Eh>
>-
>-#include <asm/proto=2Eh>
>-#include <asm/setup=2Eh>
>-
>-/*
>- * Some BIOSes seem to corrupt the low 64k of memory during events
>- * like suspend/resume and unplugging an HDMI cable=2E  Reserve all
>- * remaining free memory in that area and fill it with a distinct
>- * pattern=2E
>- */
>-#define MAX_SCAN_AREAS	8
>-
>-static int __read_mostly memory_corruption_check =3D -1;
>-
>-static unsigned __read_mostly corruption_check_size =3D 64*1024;
>-static unsigned __read_mostly corruption_check_period =3D 60; /* seconds=
 */
>-
>-static struct scan_area {
>-	u64 addr;
>-	u64 size;
>-} scan_areas[MAX_SCAN_AREAS];
>-static int num_scan_areas;
>-
>-static __init int set_corruption_check(char *arg)
>-{
>-	ssize_t ret;
>-	unsigned long val;
>-
>-	if (!arg) {
>-		pr_err("memory_corruption_check config string not provided\n");
>-		return -EINVAL;
>-	}
>-
>-	ret =3D kstrtoul(arg, 10, &val);
>-	if (ret)
>-		return ret;
>-
>-	memory_corruption_check =3D val;
>-
>-	return 0;
>-}
>-early_param("memory_corruption_check", set_corruption_check);
>-
>-static __init int set_corruption_check_period(char *arg)
>-{
>-	ssize_t ret;
>-	unsigned long val;
>-
>-	if (!arg) {
>-		pr_err("memory_corruption_check_period config string not provided\n");
>-		return -EINVAL;
>-	}
>-
>-	ret =3D kstrtoul(arg, 10, &val);
>-	if (ret)
>-		return ret;
>-
>-	corruption_check_period =3D val;
>-	return 0;
>-}
>-early_param("memory_corruption_check_period", set_corruption_check_perio=
d);
>-
>-static __init int set_corruption_check_size(char *arg)
>-{
>-	char *end;
>-	unsigned size;
>-
>-	if (!arg) {
>-		pr_err("memory_corruption_check_size config string not provided\n");
>-		return -EINVAL;
>-	}
>-
>-	size =3D memparse(arg, &end);
>-
>-	if (*end =3D=3D '\0')
>-		corruption_check_size =3D size;
>-
>-	return (size =3D=3D corruption_check_size) ? 0 : -EINVAL;
>-}
>-early_param("memory_corruption_check_size", set_corruption_check_size);
>-
>-
>-void __init setup_bios_corruption_check(void)
>-{
>-	phys_addr_t start, end;
>-	u64 i;
>-
>-	if (memory_corruption_check =3D=3D -1) {
>-		memory_corruption_check =3D
>-#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
>-			1
>-#else
>-			0
>-#endif
>-			;
>-	}
>-
>-	if (corruption_check_size =3D=3D 0)
>-		memory_corruption_check =3D 0;
>-
>-	if (!memory_corruption_check)
>-		return;
>-
>-	corruption_check_size =3D round_up(corruption_check_size, PAGE_SIZE);
>-
>-	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
>-				NULL) {
>-		start =3D clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
>-				PAGE_SIZE, corruption_check_size);
>-		end =3D clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
>-			      PAGE_SIZE, corruption_check_size);
>-		if (start >=3D end)
>-			continue;
>-
>-		memblock_reserve(start, end - start);
>-		scan_areas[num_scan_areas]=2Eaddr =3D start;
>-		scan_areas[num_scan_areas]=2Esize =3D end - start;
>-
>-		/* Assume we've already mapped this early memory */
>-		memset(__va(start), 0, end - start);
>-
>-		if (++num_scan_areas >=3D MAX_SCAN_AREAS)
>-			break;
>-	}
>-
>-	if (num_scan_areas)
>-		pr_info("Scanning %d areas for low memory corruption\n", num_scan_area=
s);
>-}
>-
>-
>-static void check_for_bios_corruption(void)
>-{
>-	int i;
>-	int corruption =3D 0;
>-
>-	if (!memory_corruption_check)
>-		return;
>-
>-	for (i =3D 0; i < num_scan_areas; i++) {
>-		unsigned long *addr =3D __va(scan_areas[i]=2Eaddr);
>-		unsigned long size =3D scan_areas[i]=2Esize;
>-
>-		for (; size; addr++, size -=3D sizeof(unsigned long)) {
>-			if (!*addr)
>-				continue;
>-			pr_err("Corrupted low memory at %p (%lx phys) =3D %08lx\n", addr, __p=
a(addr), *addr);
>-			corruption =3D 1;
>-			*addr =3D 0;
>-		}
>-	}
>-
>-	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memor=
y\n");
>-}
>-
>-static void check_corruption(struct work_struct *dummy);
>-static DECLARE_DELAYED_WORK(bios_check_work, check_corruption);
>-
>-static void check_corruption(struct work_struct *dummy)
>-{
>-	check_for_bios_corruption();
>-	schedule_delayed_work(&bios_check_work,
>-		round_jiffies_relative(corruption_check_period*HZ));
>-}
>-
>-static int start_periodic_check_for_corruption(void)
>-{
>-	if (!num_scan_areas || !memory_corruption_check || corruption_check_per=
iod =3D=3D 0)
>-		return 0;
>-
>-	pr_info("Scanning for low memory corruption every %d seconds\n", corrup=
tion_check_period);
>-
>-	/* First time we run the checks right away */
>-	schedule_delayed_work(&bios_check_work, 0);
>-
>-	return 0;
>-}
>-device_initcall(start_periodic_check_for_corruption);
>-
>diff --git a/arch/x86/kernel/setup=2Ec b/arch/x86/kernel/setup=2Ec
>index 46882ce79c3a=2E=2Eec2cbe3f800d 100644
>--- a/arch/x86/kernel/setup=2Ec
>+++ b/arch/x86/kernel/setup=2Ec
>@@ -1096,10 +1096,6 @@ void __init setup_arch(char **cmdline_p)
> 	/* preallocate 4k for mptable mpc */
> 	e820__memblock_alloc_reserved_mpc_new();
> -#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
>-	setup_bios_corruption_check();
>-#endif
>-
> #ifdef CONFIG_X86_32
> 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
> 			(max_pfn_mapped<<PAGE_SHIFT) - 1);

Acked-by: H=2E Peter Anvin <hpa@zytor=2Ecom>

