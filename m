Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2964ACA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 15:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83B56B0088; Sat, 10 Oct 2026 11:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35116B008A; Sat, 10 Oct 2026 11:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22466B008C; Sat, 10 Oct 2026 11:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73BDA6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:36:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED39E405E0
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:36:22 +0000 (UTC)
X-FDA: 85307118204.09.98B08DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4257100007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:36:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JnpKtl1z;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791646581;
	b=iRXCWIu2tpRw1lbhH/uHnJfeJhDuEMC4HvYDnntfUGeVSsPU6WT7GowD925rT8wqeMUs1X
	ghgmguN4+U2X3ue8ooHRVQctrKL0lvAhgvwU+9rW3Rsr1y2sXGJxH4+vfDO/H02we8Wcl6
	x1APUtlrE/uGsjomZrzAzr2CYL4GHYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JnpKtl1z;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791646581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Pq5FjxO/hkjNCAD7oK5Rp/29NdzYWJFKEWa0cRXpaC8=;
	b=T2SRbqEMEUVifCPPawsLSQRWycuEGOta7Gv5OVNA4YAM8PGzD07HCy0cHqAr3fuJ71nKf/
	Ydy3nre9/Y5cRHYiJq2g1BpFkpCXDKh3fJ3l5EO1fplWIzzWmNpJUDJCriAMZwUj4A8W9v
	u+qQC69gZGEsWe6fmwO/iVmc8rzHDJo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791646580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Pq5FjxO/hkjNCAD7oK5Rp/29NdzYWJFKEWa0cRXpaC8=;
	b=JnpKtl1zH1bmA/bOIgnZznJSU4glqnCc0kIGxXqtw1D7Iby85JR16vFkVMYXjNmPOWblXG
	oKWU0DcphfzDwPrxxS++aVxVsAcBv0P493JR7cnD2m/kcWcJNbuZytXkej+DgQvvRmXyim
	pjr88i35fcCGR6tpVka947SeBI230Yg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-yCcSzwzVMb2LkUj1dszBRA-1; Sat,
 10 Oct 2026 15:36:16 +0000
X-MC-Unique: yCcSzwzVMb2LkUj1dszBRA-1
X-Mimecast-MFC-AGG-ID: yCcSzwzVMb2LkUj1dszBRA_1791646574
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1021C1955F7E;
	Sat, 10 Oct 2026 15:36:14 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DAD018004D4;
	Sat, 10 Oct 2026 15:36:10 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	blum@kernel.org,
	david@kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] x86/corruption-check: Remove the BIOS memory corruption check feature
Date: Sat, 10 Oct 2026 11:36:04 -0400
Message-ID: <20261010153604.1885381-1-luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: o-vdZZ1hVCF4E5LPp4cu741AEzSn8n7uh6ezFEPukvw_1791646574
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4257100007
X-Stat-Signature: 48ukb944icguo5wjx8e7b8gxk3s7k9sf
X-HE-Tag: 1791646580-321241
X-HE-Meta: U2FsdGVkX19K7P0z8H2/dBnTLGH81L/f2/2UE0cWDNctPgL+KsHZLp6Snaf3AB68KwXjBUCwLPy+ZHgTwqPcy2i9PimRpXrKuI455vvRkE6JbvdXCfzLKqLFAxzSZuL+7ZrBM0huHA4n6OjtKBQusGFgbpCvuWwcRPMLcO5e4hs//XEJzUxlIj23nJkapCK26bvV/aJmE26ebRMbiIZQl9bA3NdY1e4wx0IGxG9z50nKpFFD4T1t3LFNps3k5r76Q8NmMhsHEgEjTJSwlQJefdi348mB/OlCYQrfOle71goN9bTFqAA/2dqTqN6MDIN9IDPxPb58bCuo4cGTVs0f6Ffd/4tgSHWOGuTjpcQami1ua61IaDHwM2u7VGoinfcJBZC5qrtaBWi65gYNVXwQLOgXtFHSKhzBNCfqNm5fKUhn8AaX4jJkBr66r2x76oEXRbZLZyE357xF4SH7hU5sHUs01mXbVXK8Yambz8HqhyaZ+N76IdVhRUS6LRqDLgH+GavvnYRl1d1/ZKAen5BGlPLCqpcnOxZTm7BKkF1lSckMeNvdM1eATSqgxv6gyCQn/WoqVsoyKGcElk1Ync31P8xZ2EEs0AlP78OOIr3Crqb0L9cVBlVtne4hfrNrXxakf1Wg0qsZSqLF5BlS3IHYiGh9eOg5ykNfVheITcQTgyOErbL7qG5WBUzh1G1jvrsARg6frYsxHecdnDTKGSO5MspQmZm2HUwbOBgIGJzqAKXvwvNIFHTfUKvqmYh3vmrBwlkpZbK8tYikD7RRictk7GW7m+404fwQyREQdtdKGNG7BJeplu7anRAxQf1dwZ8IUtJH1kLdSOLDMdqjT3K8YjBDEbqcZp8Z9tqyuXt0H++l4oFxrgErgDXNo5uau9EA0EKhAcOVv1RAt6Wy/wTEyw9gUnfEow30E9fekqQ5IFrUh8vkFHXCYEdyJ+vpzApDmmz4Op4IF8QNMTrvP0T
 /uA08h64
 6XEIbBkFGLiOdlfJqzcyoiQS7Kj1/riDEe37fJeI1ZsqDTsztVMHqCatekFqsK5uhwEF1XcO9meXPkNbywZWJwqYtCedz7xQ7OCSQPRMz8YAKnIwUgZLRS7wNi4pPmbvcnfL8TwCdJZXCPawjoeFFyHQIBh2PE7+UtqbPuUrQCdevbB3BqKBeLRhmAguKWrHFpw1zjUM4uHYlbdlmDMIoYrKScYRE0Bvc1xRF4EP/H4WBro7fGrZgYuV6t1e2ajfXOWfLAwwKPToMN4K+KQ7f7SATfrKr+QyG3ysrJ0Sw9g3Oh5+Kho2g5gUDo3X8CQnFUE+hOJE9hywmnYF9uoZYIxcnuaYjHFej2IYO2gHpMO7LH/7XWZDJe0Y/d9T5XCZfbSbqrSoQJEuqa3zHmmiTkm2ekg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By default, the BIOS memory corruption check works by reserving the
first 64 KiB physical area from memblock, zeroing it and then scanning it
periodically.

However, this functionality has been broken in its default configuration
since v5.13 by two commits:

- Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
  Moved trim_low_memory_range() into early_reserve_memory(), which runs
  earlier in setup_arch(), causing the first 64 KiB to be reserved (when
  CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs

- Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
  Hardcodes the reservation of the first 64 KiB early in
  early_reserve_memory()

It might be possible to get the default case to work by allowing
setup_bios_corruption_check() to run first, but it's just not worth it
given that the kernel will never access the first 64 KiB area anyway.

Lastly, note that it's possible to get the corruption check to work with
a different region by passing memory_corruption_check_size=. However,
the main goal of the feature was to check the first 64 KiB. Besides,
the region picked will be almost random as setup_bios_corruption_check()
will pick a region by size.

Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---

Notes:
  - Posting late in the cycle, but this is not urgent
  - v2 was mangled by my MUA and did not apply, the diff is unchanged

v3
  - Updated changelog to emphasize that the default configuration is broken
    (Thorsten)
  - Improved subject prefix
  - Resending on top of latest Linus tree

v2
  - Rebased against latest Linus tree (v7.2-rc4)
  - Improved changelog

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
index e75344f4e0cd..a7f7667d307d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3984,29 +3984,6 @@ Kernel parameters
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
index 15fd9ec5ecac..4ae227dd29d0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1605,36 +1605,6 @@ config X86_PMEM_LEGACY
 
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
 config MTRR
 	def_bool y
 	prompt "MTRR (Memory Type Range Register) support" if EXPERT
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
index 269f7d808be4..e05d67f708cb 100644
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
index 895d09faaf83..cd042752e6ce 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -42,7 +42,6 @@ static inline void vsmp_init(void) { }
 
 struct pt_regs;
 
-void setup_bios_corruption_check(void);
 void early_platform_quirks(void);
 
 extern unsigned long saved_video_mode;
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 31f46fd00527..702536938433 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -149,8 +149,6 @@ obj-$(CONFIG_JAILHOUSE_GUEST)	+= jailhouse.o
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
index cda6adb9f69c..c579c010ae54 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1108,10 +1108,6 @@ void __init setup_arch(char **cmdline_p)
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
2.55.0


