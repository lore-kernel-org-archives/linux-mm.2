Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91E2C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25E16B00BF; Mon, 20 Jul 2026 16:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8CA6B00C1; Mon, 20 Jul 2026 16:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5D26B00C3; Mon, 20 Jul 2026 16:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7202D6B00BF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:41:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0294CA08CD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:41:21 +0000 (UTC)
X-FDA: 85010325204.13.2343EAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A1444000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:41:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G9zHmT4Z;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784580079;
	b=MZG7YsQlfnHqHct9PESqEvY9yD1LyfqNJ9RIPCzwlQ7j2VkciEN7s74TKl0KuDbqhiRLuT
	KYbPD9nGtoraaTM9ueD/OM8/s3ADSLfo7opfymkBWXHjFirGEggBphJAztvzu0tUsz1U5G
	U7xwh1NgRMsxLGS1ygcFV8VGzTinN8o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G9zHmT4Z;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784580079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Hio1JKPJfA45kM7ChAsZwbqBUVf+PwQZRP+8NaKQzbw=;
	b=l0jFyKTJSutx9+kHLNRAeXjtH5H/zmjvYkF7kRREuSbpX8KP6IPjfxYZaPhT30oAII16vE
	hguFQgIkeWh9Eg/4F1a9QGH/VhESHNJPL1QfyPxqOstnKXDNWO9AJOEG9j1qof9QB7afMM
	Ms+hFTN7ewnfHRiAVLJ7yzUxxfI4bTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784580079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Hio1JKPJfA45kM7ChAsZwbqBUVf+PwQZRP+8NaKQzbw=;
	b=G9zHmT4Z/pXDPmwghET0EifBIgo2GZ9Nbw72eG9/eOaothLUVOICL7ItuhfbY3hVH4yhx0
	H/Ut1MT9KgHMOLTl2vhN7ANFNinvfGwnqsSpHjpPiFlAzn5F4gWfV6EnJJ+2gGL5ssJa54
	vZprRuXlHbEUrlJN49YhtxHIw0iPh9g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-OVtjgbjoO3-4r00YShC9YQ-1; Mon, 20 Jul 2026 16:41:17 -0400
X-MC-Unique: OVtjgbjoO3-4r00YShC9YQ-1
X-Mimecast-MFC-AGG-ID: OVtjgbjoO3-4r00YShC9YQ_1784580077
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8ec45d9628aso138220766d6.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784580077; x=1785184877;
        h=content-transfer-encoding:content-type:cc:to:subject:from
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hio1JKPJfA45kM7ChAsZwbqBUVf+PwQZRP+8NaKQzbw=;
        b=WNFn471O0FBaDIEJVEyWoatblIipWvXS7y8gejx+hWUkQJG3qLAg7k/wttE79RbWHi
         P54ODLppMOVPHZyG/HS+bxVuxZK01s996Sq1QJEoSURDuOogrCVUs84oGunQveQGqTal
         7K1JEd0mJpixPE3RH0n46LfyHIGacOGYW8hJp6t2iWujYSTMowtHgOhqrVIBJdBWArBs
         BPCkTKJcXAMMAiHMeGfyJH4mUTuGTgkxsrxKXq3wttvTdbjgc/ZZH1ITH+Bvcfc3hzKw
         DyphnmgvBvZse39rpJdRIVaazdBUteE44K8lN+kVpczdi4ixZ8lnyGwCGfBhioIwzBPl
         9ToA==
X-Forwarded-Encrypted: i=1; AHgh+RroSj9nf1DrvLPlxsEEL4HsAAlv3CLfc7lnpbPdoIgucXKRigRyI4GsfAdguPVTGBM/KyMxKtRVFw==@kvack.org
X-Gm-Message-State: AOJu0YwA/CGeEk276aoToO5s4gKSrHAF0Azddnof4a3jWnMdEfZ4ZGLr
	Ye7nC54Tz5VX0OOZ22H5infsJZP/wwS4iI+Yx8flkc3tg7J+4Ry+wpBOTTpeEluWA3rjxGlWsem
	9nkKDS4ukDnVSCWSqBc9TDr2d4mpAtO7Ot+OZTkaPt72cggW9FeRY
X-Gm-Gg: AR+sD13FIddgi7lKiXzjWh4fEz4qZ/+6ng3C6t8+HMsJM6E8NoimIzTkoCikuO779++
	0pMCjJ4ny6QBjx7xb9fZmdCY9rw+OGZsYjJ0NE+JLeH6ND319FBOgkNnfHWC9ZlsioibCITXWvS
	+QvHmuUhfqYPh4CS4qHiNx5itCfNhmyyasphoR4E5cHv3itGcTqGYAccArSvY5GiU6kWp2dJRpJ
	OSJg+4PwKd6WlPAjwDQ6kUHeFieRqA/UwZGrogs+miU+C4nhL0P4hczz9E7l4BE6jh2ftxVwDDL
	wIESwvcXUDkjdU7S1b1MXdCNIZKyOPAlwMA9Wt680HXZhN5IL4H+txcm0Tcusbxdz3wbpv3/SoQ
	3
X-Received: by 2002:a05:6214:5a05:b0:907:55e0:6627 with SMTP id 6a1803df08f44-9077832f751mr176684716d6.22.1784580076825;
        Mon, 20 Jul 2026 13:41:16 -0700 (PDT)
X-Received: by 2002:a05:6214:5a05:b0:907:55e0:6627 with SMTP id 6a1803df08f44-9077832f751mr176684346d6.22.1784580076377;
        Mon, 20 Jul 2026 13:41:16 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.81.60])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90778543d85sm99133526d6.3.2026.07.20.13.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 13:41:16 -0700 (PDT)
Message-ID: <9e1a161e-9246-41d1-9651-ffa85b1bc99b@redhat.com>
Date: Mon, 20 Jul 2026 16:41:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2] x86: remove the BIOS memory corruption check feature
To: LKML <linux-kernel@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>, x86@kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, corbet@lwn.net, hpa@zytor.com,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PU3wMZsjKOHBgJ9q1zWnZLQQDaHj-hmISu1oqsZArYI_1784580077
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A1444000D
X-Stat-Signature: jzbhp74eu783re5g9smgchjqpnt1o5k1
X-Rspam-User: 
X-HE-Tag: 1784580079-94147
X-HE-Meta: U2FsdGVkX18tOVSc2dqWQoNNKfOd49yke18t/7UMMkVhjP6pfJdvvmRWuY4PxgioQLqfZg8pe2q2iAPh51/hwh8HuCZE3LKBHmqJDmXN3ByeSA+s+oF+3jbCmr+DpIHsS+A3muuNIGXo3sbuyCbDqfmTUKGp9bGDl7Qs9UX5KsJg50eQ1T2NzKiMZ7U8lch1LkUvI1OSYuwTBjmEN7ZVy406u6d7+yCYWeii3IBMbJ55hg9BmQwX2sgDzZ0AqEKkXaFL1e+pg2+ugRUkyRLKshXZbIKpaRxEJqLuuFcG3WBeH5a6EUSpuHrVf8kqsJfmfwwkA5ozgxx8D2k72/ylTyiVd/oh5ffWm6VtSwthYGyP659+qe4F122t0zwESfV+9/8RrQXPMG7n/sNQI4fjwBFUN+l+tGZYtA+QKxVYAzbL6GnsDU72s0GHdZ/5gI1FU4dEA7PDw6OgrUktJLCeI5hvIVS4mut83PJERCP2D/ausD5tQOtahJeakvX2KXQ+MoY6GDLEZXxe5FmU5tZ4iyjvRXvRiB/2gL8YSoQBDwHg/MhVlFqueQWTwUUljpA3oAc/gHSG+KlW7uhYFmIj6PFZJf+iEQyP4wfL2O8IDmjHnNL8Sw5a1TLqKArswTFtQ7IzB5GK2fAkxFTNQ3ZOgKFtzHpg7KF8PxOQV1t5cZ5UWWQY3a4VA6NMWe/Yo3QXXuuyYnIG/jtYeGUHV7McdtRw3NiDYbjw+3Ry0k7rm4jh0TyzM2NRbU4cM5laCA05bdb3FpQXLNspMAR28861ds50Rd+oVgrEvssdo80HyvY8/bneYb8FRulgdHZi7tydS1SlvvDF+WZiJzky+b5lFxsfbleF2DT1zrWcsE6tY0izHMBrWRPlKDiLwNVEgDD/em2ov/p/Z43udcMjGGSQrwuTWbUz4u1k6H1vAkM7LfWokj2q80ZIA4i50kVFC/SW9I4ee7lx2eD+ZPd09SJ
 TlG1ORC2
 6dvT9OosR2PFAuVSTsBZ/BdMvpg25wfHuctDEod98ThHbaN0q++Clezor0jxTB+EvyW4h6AdJQSdzo3F5H4oYNdVNvPE5EREsT67gEkNf3whbLaVy0M3z/StOqhvcOvSxxAWxD/4KBg96xQ4wmOs4jwhwCmPDk28vKqDKzT5/1FnYtz+KVYID7qRjAlJLG7QOJ53MR23cg+Dr+9Y8FXNOZly8S4i2QZAQ7UYp9+PeRcIYp+24zJ7PjDwb8354883e3+D9LKq68gLA7ZDeIELQF1Lmhf+gmhFPW28AF6CIHcVKGLPTlZticy6uINP4vQqgPX2fCEPvgKp37g2UR2KWRD6+62H5Ut1wHXSvexbXGW5hRQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By default, the BIOS memory corruption check works by reserving the
first 64 KiB physical area from memblock, zeroing it and then scanning it
periodically.

However, this functionality has been broken since v5.13 by two commits:

- Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
   Moved trim_low_memory_range() into early_reserve_memory(), which runs
   earlier in setup_arch(), causing the first 64 KiB to be reserved (when
   CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs

- Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
   Hardcodes the reservation of the first 64 KiB early in
   early_reserve_memory()

It might be possible to get this feature to work by allowing
setup_bios_corruption_check() to run first, but it's just not worth it
given that the kernel will never access this memory area anyways.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---

Changelog
=========

v2
- Rebase against latest Linus tree (v7.2-rc4)
- Improve changelog

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
index b5493a7f8f22..314a2a0dc9cd 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3935,29 +3935,6 @@ Kernel parameters
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
index bdad90f210e4..cce558ca5c6c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1601,36 +1601,6 @@ config X86_PMEM_LEGACY
  
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
index 914eb32581c7..1f58361eb038 100644
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
index 46882ce79c3a..ec2cbe3f800d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1096,10 +1096,6 @@ void __init setup_arch(char **cmdline_p)
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


