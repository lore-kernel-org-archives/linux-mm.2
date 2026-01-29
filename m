Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67553D73E9B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C006B00AE; Thu, 29 Jan 2026 17:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D776B00AF; Thu, 29 Jan 2026 17:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5664C6B00B6; Thu, 29 Jan 2026 17:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4797F6B00AE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:03:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C494CD47A3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:03:39 +0000 (UTC)
X-FDA: 84386378958.06.B7979FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA1B318000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:03:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e2moscRO;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769724218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wjvwruhMiXhW6s5sNbKYQyMtxcB2O46DJ1/cRr2oxdo=;
	b=3eOdJTIZYy8yTn1Zfp8VIc/4H7W7gCQIvqPX2Uv+wKoogWVc+9yREGwsciJUiw7mJ30ukB
	e8acL1gfOwU/HhQHhOEGGRi86Lf56n9gU13/+qebdJfgF2qqaexQL6WksYr0CXQEyv+SGz
	SNQIaek2mqtOsA7sTGAl+O1lA9heXeA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e2moscRO;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769724218; a=rsa-sha256;
	cv=none;
	b=XkfJCEOMBvn0fRy+8vP0mCdQ4F1AnvKyt8oV0Yo6z64caPCsEBqtIG62R4dB4X8Uu9nN74
	GWV4NdHAlY+9Hf6+tOQVMbJjGik2aRf+rSPVPoZJJerWZHx0NjlJyRWM2hsC3eB9MVkuK+
	AiBMS3368abH8bUEAoYBD9EVtLbbAJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769724217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wjvwruhMiXhW6s5sNbKYQyMtxcB2O46DJ1/cRr2oxdo=;
	b=e2moscROUFrD1sjqo3gGp6asZgEa9tlOYSZiMW56FD02oO4zvNbzJ+zH3oJK3fzpYlXwUc
	mGoFuf/PAPNCpEWrXhEgUNBKZDZ34D9SHHDC3+qLgovQQ025yMn/49uLO0jSjaOTyJo3a3
	sPE9stw6/HUeNE60MeKOZQYM9qHwm+o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-IK_08TK5MK2n44uUIhC9UQ-1; Thu,
 29 Jan 2026 17:03:33 -0500
X-MC-Unique: IK_08TK5MK2n44uUIhC9UQ-1
X-Mimecast-MFC-AGG-ID: IK_08TK5MK2n44uUIhC9UQ_1769724211
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 229AB1955E8C;
	Thu, 29 Jan 2026 22:03:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.89.142])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F3C018009A0;
	Thu, 29 Jan 2026 22:03:26 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org
Subject: [PATCH] x86: remove the BIOS memory corruption check
Date: Thu, 29 Jan 2026 17:03:20 -0500
Message-ID: <20260129220320.3012571-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Queue-Id: DA1B318000C
X-Rspamd-Server: rspam07
X-Stat-Signature: ayx6biu1qby5nunsr8u77uan4wccb5xz
X-HE-Tag: 1769724217-913142
X-HE-Meta: U2FsdGVkX19PnJleoQNVowCknGb6rCbTwTqgebu1vX7P1XndvWJAVOYfupu25b7iKHwcASEbBYJ+zETcQGEIZ9MJySorGIc5wc5eMP0QviyDipzTvfh8xCsP/Vp9aOKni6OyWWr0lqEU0sUbw41KsKwI5zVytrJoV8vlaUBysO7p95iLc2semQ9CZgsR5rylPzBiE5YVXTi7bgSbzcP9ELEtbhTu7a7n9QEav68Tk+2xN9f8InqEswx+g5SaJ8nbzdA8+PABAVP5rc55fbCr4di2uoz6jXte07VA2JrGNvW9xAIB2AyN54WfqTS3NRvrhPVXmU0zlZrfF2kRa/mn1Z5WpCxaICcz9F1B+zNJjrSnq78i/g6OuL2M9gKicQd8hFnKpLi/2ByLVfvR38CzNCh4bMkP+8ALtWeG5Iv9bPRXWSw618Lw/HuQVaUaKiG+r1Rg/pMl5QmRUJtr1880lvJy6Kmul+W2FXUcD4VYuyLEb2Rq4frI0wgjWGtEn2kba7Aitm5OPQlKRr1QlGC4+KAcHrrJeIRgkbKlz6WtZL0qslhkNkT0vBJ18p2HboQdIPjVIYFFHvhrUd6tKYkZ3j4pv4WWhKJAUy+qlb+AOlidvdimpfBFJ7YKeHgpVDtnFfB8N7SURLEkrocBNV3crpPsS/X8iIkloLroIsjykkIZuvZzZoq6BUEiGRJcmki4OF7JuHjFUyjY4SyqXICG4ugBhkI99fizF5BtNRzzMJsjdIOaF5A1uADRY38ZGpDY26nbnKHjGGHy0O9XlYADEQ9Y8jPXt+ERumvMziLw/sivaGktvedAAsfdnWZChHj73toOhOglmuFiAA67WCK0W8wx0EI2/3GG0mwTBP+PhELkNfpX3kN3cZAN7nVphbGE93j/5z0cwjOkeyTescrk+u4mgrYIJe7jiwfmDIg72y6cGUtsfRmN0Aju0dnLItB7wl0eZVMk2MwQbw/lZ2K
 ciNYoCRY
 TPPDHpQvAqqrBVrAqr9e9WZf+nN/77sMY0bZSKnBT2CF84/e9nXTM8DvKYUhxcEBZgVM/LT7kYHtX4UX6tSYToDLkTfsP+lvQrBOikGSGB9ni+np6K8NtNu0PSZzxbYwtxbwbpPJB7waG7hXkXqHs8j1CEjAK2cNA0wHw6/dUQUSa6zuzgN7lRn5VZorp7B9N+hFcr65/Unm6H1qW2YWYUuzLENgpq9Fc3tpeIL4z28NK+iDZH9YDd56/91IIUb0ZNjxwE7l7SNTCzR3vBVBHnhx7YAgP+MjkNdV6PagT1e6eZdxDluBD9WR4bqP2vwpmG/xHE19jQMHlAVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit a799c2bd29d1 ("x86/setup: Consolidate early memory
reservations") moved the reservation of the first 64K of physical memory
to very early in setup_arch(). This silently broke the BIOS memory
corruption check feature, as setup_bios_corruption_check() runs later
and relies on finding free memblocks in the 0-64K range to reserve for
scanning.

This has been broken since v5.13. Fixing it would probably require
parsing e820 ranges directly which adds unnecessary complexity.

Since x86 unconditionally reserves the first 64K range, any BIOS
corruption in this range cannot affect the kernel which makes this
feature purely informational. Remove it.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---

I tried a few different fixes for this, but they would re-introduce
the issues commit a799c2bd29d1 is trying to fix or be too
complex. Since this is broken for years and apparently nobody
complained, I concluded it's best to just drop it.

 .../admin-guide/kernel-parameters.txt         |  23 ---
 arch/x86/Kconfig                              |  30 ---
 arch/x86/configs/i386_defconfig               |   1 -
 arch/x86/configs/x86_64_defconfig             |   1 -
 arch/x86/include/asm/bios_ebda.h              |  17 --
 arch/x86/include/asm/setup.h                  |   1 -
 arch/x86/kernel/Makefile                      |   2 -
 arch/x86/kernel/check.c                       | 187 ------------------
 arch/x86/kernel/setup.c                       |   4 -
 9 files changed, 266 deletions(-)
 delete mode 100644 arch/x86/kernel/check.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1058f2a6d6a8..edf9966eaa54 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3890,29 +3890,6 @@ Kernel parameters
 			specified as e820 types, e.g., 1 = RAM, 2 = reserved,
 			3 = ACPI, 12 = PRAM.
 
-	memory_corruption_check=0/1 [X86,EARLY]
-			Some BIOSes seem to corrupt the first 64k of
-			memory when doing things like suspend/resume.
-			Setting this option will scan the memory
-			looking for corruption.  Enabling this will
-			both detect corruption and prevent the kernel
-			from using the memory being corrupted.
-			However, it's intended as a diagnostic tool; if
-			repeatable BIOS-originated corruption always
-			affects the same memory, you can use memmap=
-			to prevent the kernel from using that memory.
-
-	memory_corruption_check_size=size [X86,EARLY]
-			By default it checks for corruption in the low
-			64k, making this memory unavailable for normal
-			use.  Use this parameter to scan for
-			corruption in more or less memory.
-
-	memory_corruption_check_period=seconds [X86,EARLY]
-			By default it checks for corruption every 60
-			seconds.  Use this parameter to check at some
-			other rate.  0 disables periodic checking.
-
 	memory_hotplug.memmap_on_memory
 			[KNL,X86,ARM] Boolean flag to enable this feature.
 			Format: {on | off (default)}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80527299f859..4dbadd3f7af0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1608,36 +1608,6 @@ config X86_PMEM_LEGACY
 
 	  Say Y if unsure.
 
-config X86_CHECK_BIOS_CORRUPTION
-	bool "Check for low memory corruption"
-	help
-	  Periodically check for memory corruption in low memory, which
-	  is suspected to be caused by BIOS.  Even when enabled in the
-	  configuration, it is disabled at runtime.  Enable it by
-	  setting "memory_corruption_check=1" on the kernel command
-	  line.  By default it scans the low 64k of memory every 60
-	  seconds; see the memory_corruption_check_size and
-	  memory_corruption_check_period parameters in
-	  Documentation/admin-guide/kernel-parameters.rst to adjust this.
-
-	  When enabled with the default parameters, this option has
-	  almost no overhead, as it reserves a relatively small amount
-	  of memory and scans it infrequently.  It both detects corruption
-	  and prevents it from affecting the running system.
-
-	  It is, however, intended as a diagnostic tool; if repeatable
-	  BIOS-originated corruption always affects the same memory,
-	  you can use memmap= to prevent the kernel from using that
-	  memory.
-
-config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
-	bool "Set the default setting of memory_corruption_check"
-	depends on X86_CHECK_BIOS_CORRUPTION
-	default y
-	help
-	  Set whether the default state of memory_corruption_check is
-	  on or off.
-
 config MATH_EMULATION
 	bool
 	depends on MODIFY_LDT_SYSCALL
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 79fa38ca954d..848c2d924668 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -36,7 +36,6 @@ CONFIG_PARAVIRT=y
 CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
-CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 # CONFIG_MTRR_SANITIZER is not set
 CONFIG_EFI=y
 CONFIG_EFI_STUB=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 7d7310cdf8b0..8047f2779768 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -35,7 +35,6 @@ CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
 CONFIG_NUMA=y
-CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 # CONFIG_MTRR_SANITIZER is not set
 CONFIG_EFI=y
 CONFIG_EFI_STUB=y
diff --git a/arch/x86/include/asm/bios_ebda.h b/arch/x86/include/asm/bios_ebda.h
index 4d5a17e2febe..2f441fd9ebf8 100644
--- a/arch/x86/include/asm/bios_ebda.h
+++ b/arch/x86/include/asm/bios_ebda.h
@@ -20,21 +20,4 @@ static inline unsigned int get_bios_ebda(void)
 
 void reserve_bios_regions(void);
 
-#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
-/*
- * This is obviously not a great place for this, but we want to be
- * able to scatter it around anywhere in the kernel.
- */
-void check_for_bios_corruption(void);
-void start_periodic_check_for_corruption(void);
-#else
-static inline void check_for_bios_corruption(void)
-{
-}
-
-static inline void start_periodic_check_for_corruption(void)
-{
-}
-#endif
-
 #endif /* _ASM_X86_BIOS_EBDA_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 914eb32581c7..1f58361eb038 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -42,7 +42,6 @@ static inline void vsmp_init(void) { }
 
 struct pt_regs;
 
-void setup_bios_corruption_check(void);
 void early_platform_quirks(void);
 
 extern unsigned long saved_video_mode;
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index bc184dd38d99..d39c7e078f67 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -135,8 +135,6 @@ obj-$(CONFIG_JAILHOUSE_GUEST)	+= jailhouse.o
 obj-$(CONFIG_EISA)		+= eisa.o
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
-obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
-
 obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
 
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
deleted file mode 100644
index 5136e6818da8..000000000000
--- a/arch/x86/kernel/check.c
+++ /dev/null
@@ -1,187 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/kthread.h>
-#include <linux/workqueue.h>
-#include <linux/memblock.h>
-
-#include <asm/proto.h>
-#include <asm/setup.h>
-
-/*
- * Some BIOSes seem to corrupt the low 64k of memory during events
- * like suspend/resume and unplugging an HDMI cable.  Reserve all
- * remaining free memory in that area and fill it with a distinct
- * pattern.
- */
-#define MAX_SCAN_AREAS	8
-
-static int __read_mostly memory_corruption_check = -1;
-
-static unsigned __read_mostly corruption_check_size = 64*1024;
-static unsigned __read_mostly corruption_check_period = 60; /* seconds */
-
-static struct scan_area {
-	u64 addr;
-	u64 size;
-} scan_areas[MAX_SCAN_AREAS];
-static int num_scan_areas;
-
-static __init int set_corruption_check(char *arg)
-{
-	ssize_t ret;
-	unsigned long val;
-
-	if (!arg) {
-		pr_err("memory_corruption_check config string not provided\n");
-		return -EINVAL;
-	}
-
-	ret = kstrtoul(arg, 10, &val);
-	if (ret)
-		return ret;
-
-	memory_corruption_check = val;
-
-	return 0;
-}
-early_param("memory_corruption_check", set_corruption_check);
-
-static __init int set_corruption_check_period(char *arg)
-{
-	ssize_t ret;
-	unsigned long val;
-
-	if (!arg) {
-		pr_err("memory_corruption_check_period config string not provided\n");
-		return -EINVAL;
-	}
-
-	ret = kstrtoul(arg, 10, &val);
-	if (ret)
-		return ret;
-
-	corruption_check_period = val;
-	return 0;
-}
-early_param("memory_corruption_check_period", set_corruption_check_period);
-
-static __init int set_corruption_check_size(char *arg)
-{
-	char *end;
-	unsigned size;
-
-	if (!arg) {
-		pr_err("memory_corruption_check_size config string not provided\n");
-		return -EINVAL;
-	}
-
-	size = memparse(arg, &end);
-
-	if (*end == '\0')
-		corruption_check_size = size;
-
-	return (size == corruption_check_size) ? 0 : -EINVAL;
-}
-early_param("memory_corruption_check_size", set_corruption_check_size);
-
-
-void __init setup_bios_corruption_check(void)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	if (memory_corruption_check == -1) {
-		memory_corruption_check =
-#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
-			1
-#else
-			0
-#endif
-			;
-	}
-
-	if (corruption_check_size == 0)
-		memory_corruption_check = 0;
-
-	if (!memory_corruption_check)
-		return;
-
-	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
-
-	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
-				NULL) {
-		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
-				PAGE_SIZE, corruption_check_size);
-		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
-			      PAGE_SIZE, corruption_check_size);
-		if (start >= end)
-			continue;
-
-		memblock_reserve(start, end - start);
-		scan_areas[num_scan_areas].addr = start;
-		scan_areas[num_scan_areas].size = end - start;
-
-		/* Assume we've already mapped this early memory */
-		memset(__va(start), 0, end - start);
-
-		if (++num_scan_areas >= MAX_SCAN_AREAS)
-			break;
-	}
-
-	if (num_scan_areas)
-		pr_info("Scanning %d areas for low memory corruption\n", num_scan_areas);
-}
-
-
-static void check_for_bios_corruption(void)
-{
-	int i;
-	int corruption = 0;
-
-	if (!memory_corruption_check)
-		return;
-
-	for (i = 0; i < num_scan_areas; i++) {
-		unsigned long *addr = __va(scan_areas[i].addr);
-		unsigned long size = scan_areas[i].size;
-
-		for (; size; addr++, size -= sizeof(unsigned long)) {
-			if (!*addr)
-				continue;
-			pr_err("Corrupted low memory at %p (%lx phys) = %08lx\n", addr, __pa(addr), *addr);
-			corruption = 1;
-			*addr = 0;
-		}
-	}
-
-	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\n");
-}
-
-static void check_corruption(struct work_struct *dummy);
-static DECLARE_DELAYED_WORK(bios_check_work, check_corruption);
-
-static void check_corruption(struct work_struct *dummy)
-{
-	check_for_bios_corruption();
-	schedule_delayed_work(&bios_check_work,
-		round_jiffies_relative(corruption_check_period*HZ));
-}
-
-static int start_periodic_check_for_corruption(void)
-{
-	if (!num_scan_areas || !memory_corruption_check || corruption_check_period == 0)
-		return 0;
-
-	pr_info("Scanning for low memory corruption every %d seconds\n", corruption_check_period);
-
-	/* First time we run the checks right away */
-	schedule_delayed_work(&bios_check_work, 0);
-
-	return 0;
-}
-device_initcall(start_periodic_check_for_corruption);
-
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1b2edd07a3e1..82e4cc0734a4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1094,10 +1094,6 @@ void __init setup_arch(char **cmdline_p)
 	/* preallocate 4k for mptable mpc */
 	e820__memblock_alloc_reserved_mpc_new();
 
-#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
-	setup_bios_corruption_check();
-#endif
-
 #ifdef CONFIG_X86_32
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
-- 
2.52.0


