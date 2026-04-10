Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3266F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5436E6B00C1; Fri, 10 Apr 2026 08:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3FE6B00C3; Fri, 10 Apr 2026 08:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E32F6B00C4; Fri, 10 Apr 2026 08:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE716B00C1
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02967E1CDD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:21 +0000 (UTC)
X-FDA: 84642553884.18.7F2AAA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53557A0019
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7az2CYX;
	spf=pass (imf15.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823620; a=rsa-sha256;
	cv=none;
	b=smCl7F8eeH9m7aTsbycjgzS74dNbtqC7cJFyHKv/UmRhYmdqw1nN1efftJd/JZae6US7Tc
	ZYHgLWMFUzAHwy9EZP5MfKsQUFYQwpWfZxVraDZewFETCjGTShilzGvgBy++uOFBGI+DW7
	CFEM3Y1d/zBG6s0ruGButEt234QsMec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=AqOQD77ovJbDZAalLb7LttNXWfQNwpbHnO0m4lNbaKQ=;
	b=FARpJ6pkMAi9zeqIr2jUMlbY/5zBjQEHYgViIsVG2MdLzcDMGoRgmjdcfp1vfzRsrns9PB
	VX2IXPD5HQ3/notyD7nDBEibD6OiWuOvk3EXxj8nT2ECUABTpgTmiw0xa2ZRAkV8k0hINV
	3aGObpgleNWmHSskzry46vFJxvYEnK0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7az2CYX;
	spf=pass (imf15.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 806A043DD1;
	Fri, 10 Apr 2026 12:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E21BC19421;
	Fri, 10 Apr 2026 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823619;
	bh=qm3xQcBXEr96lL4hegVcj0UIOMtgXH0StGBPsgVLlKQ=;
	h=Date:From:To:Cc:Subject:References:From;
	b=C7az2CYXx68wjErxLRkuWTeHqh2CiNCWSqYoEW7CDASKgYcRJIgZbMFxC0wyGwYuo
	 q2wWS5Il3rSZIvkXMrziJDymJeOKDwzCu+GiLTUQ15ObFw+7EBHLm3ubP5lL1H6hxr
	 ReCtVW/VKZ0Y6HBv+Xxa78vZHjPEyhGg6WzSGQLG1W0Tyuqe7kgGZgc8KKs+JzIX6a
	 qzTQ3qBxeH5MKjO5ANy/+fOcCKNQ7HWyamJ7hE6VNKzzJsl13+xyi236101/gCvlT5
	 hn6GusmLxuTParC929bCg39takaaNPRV5A3bS+11CTndJSbqW1MjcdkxKmUqQfmLua
	 lqUqNEa3EnLWw==
Date: Fri, 10 Apr 2026 14:20:16 +0200
Message-ID: <20260410120319.064561422@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 22/38] random: Provide CONFIG_ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53557A0019
X-Stat-Signature: nf933dgrankfxbyu14babr8hh4a9rjiz
X-HE-Tag: 1775823620-390485
X-HE-Meta: U2FsdGVkX1/WSjIjsE0NqHxH5lMiUXBMSD/5pItcBzbf389AZlS0zeI0S4SVU4uzpywMosmQFI5u+yDcALVpzZjMK8s7mvy8sEVU9W0PghUchS3bjHX4c8KfmMTG7/70Wv/R4v1qoWj98lo0TXDCUPi4D5aFdJftpsOrz6MYb3myy+NuNTj7ndbj86k54vRbbQYtIklYS70SYy8xRm8Otp6Bgj8DBM0CzBc5jt3eTlFE9rkvKx6Yv4ri9YS61bt3Hjtt8rqI0IYSXdoUISn6TK6JQzSH9UyzrLxnEubdaA5SGEPhLTNgDl2KbstapmGWQtIOO9VvLQJ1Il6VL/TLnA1jqtwvJIZad4Vj7WqVwTZ51A7a74yvD+mv6Zdhk5bXLYvBtOE8LDCySNqRsQe0mF3ViPh9Hl/zQERxjwHayLWmd0BsPI5SSX1GD35KALgJ+uH3y9Ia+3pN/u55Q94y8oPyxG4heU7bCpgPl5NzcObsQx8KpESZTn27UcL7/mNFOarW4hFNOe1fG4hbE749802tLZ5tUCMZBCGkHSfLSAA+K6YjIAqSj1wVV2BbcUS1n6aebpzCuU2Ea2wQQw6OA/LxssR4T4y4wdqYFWZX+jpLSq1/UX/PPCFl08n/WCHrDFOVaHL9LW754HrkaFyd9tG1dsF96Q1l+aOBoED4BqqLJLcBqIi2cKHq8HsFZhCTo6eq2Lh9PBbN6n4CGUU1QgW+q634dd9qcvChQEIQDSwnXz+uIzFhk0jOsATeFUZgo5LBOajnhEsSPABX5DBUwEpSXSuFt1qQKA5Ene5ZAEqrmu/NwYepizB+7jAZu/yLgwDK6nuiHR1Aes9vQ0YfB/5IURPydFkH7hyvzP2V79m6FHxxlJfYZ9KVkUKdAxq3HYAGpqtv92LoYp6zl8mD1yA938OYUOyyP6uWxm5PIbu1R/WDtnqwZZhU2BJJS1tA4/DJ2ff1LuiULtSwuXf
 nIrEH3hV
 bWriYdM3zck2SzI4/tFhHqxPVlM9OTg9Ol6EnOFWyubTwnExo0StWVqyraielc+Q/9RBiwRUhR4g2hzci02Tr69qDKFfIP9dX4s/kp7/ccM6fjTjJPIxP2Qq1RKuqINPKaUORkcGjoMjdWg4WA1fRP5XJbVl6wEPbNPMFqkM04F5jMlX8QeyldeEDtYEU9I8LGuV3ZGx6Khh+ilTCCgYtnzpZAtCxQG5dwJCNrsCtFRHqJG/MWoDup8piJXxRlUXSgZrQ9Y8MFFPCAmCqkuqdHbl5tGJiusEKPQtYRk3koDTyqcYSo5gOK+rYXNmfEChu5qrFnJfSV0DA4UvnqEWH/sT8E0Gv7/+hBG/3rvLnwH+40CUoT5yIqpdW2Z5GJPVnYx04VwJpDd5etZvU9yLF8qMNmIBvAJOpOi7gGTXWnGEV7zK8lwzRembRXU/MavzyAhiClTDzDFOUEvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chasing down to what random_get_entropy() resolves is a 'spot the mouse'
game through a maze of #ifdeffery. Also the placement in timex.h is
non-obvious and has just been chosen because it provides conveniant access
to the underlying get_cycles() #ifdeffery.

Provide a config switch which is selectable by the architecture and a
temporary #ifdef guard in timex.h. Architectures which select the config
switch must provide asm/random.h with the architecture specific
implementation.

Update all usage sites to include linux/random.h so that the gradual
conversion does not cause build regressions.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
---
 arch/Kconfig                     |    3 +++
 arch/loongarch/kernel/relocate.c |    1 +
 arch/mips/kernel/relocate.c      |    1 +
 crypto/jitterentropy-kcapi.c     |    1 +
 include/linux/random.h           |   15 +++++++++++++++
 include/linux/timex.h            |    2 ++
 kernel/kcsan/core.c              |    1 +
 7 files changed, 24 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -370,6 +370,9 @@ config ARCH_HAS_CPU_FINALIZE_INIT
 config ARCH_HAS_DELAY_TIMER
 	bool
 
+config ARCH_HAS_RANDOM_ENTROPY
+	bool
+
 # The architecture has a per-task state that includes the mm's PASID
 config ARCH_HAS_CPU_PASID
 	bool
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/printk.h>
 #include <linux/panic_notifier.h>
+#include <linux/random.h>
 #include <linux/start_kernel.h>
 #include <asm/bootinfo.h>
 #include <asm/early_ioremap.h>
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -19,6 +19,7 @@
 #include <linux/libfdt.h>
 #include <linux/of_fdt.h>
 #include <linux/panic_notifier.h>
+#include <linux/random.h>
 #include <linux/sched/task.h>
 #include <linux/start_kernel.h>
 #include <linux/string.h>
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -42,6 +42,7 @@
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -139,4 +139,19 @@ int random_online_cpu(unsigned int cpu);
 extern const struct file_operations random_fops, urandom_fops;
 #endif
 
+unsigned long random_get_entropy_fallback(void);
+
+/*
+ * random_get_entropy() is used by the /dev/random driver in order to extract
+ * entropy via the relative unpredictability of when an interrupt takes places
+ * versus a high speed, fine-grained timing source or cycle counter.  Since it
+ * will be occurred on every single interrupt, it must have a very low
+ * cost/overhead.
+ *
+ * If an architecture does not provide it, then use random_get_entropy_fallback().
+ */
+#ifdef CONFIG_ARCH_HAS_RANDOM_ENTROPY
+#include <asm/random.h>
+#endif
+
 #endif /* _LINUX_RANDOM_H */
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -66,6 +66,7 @@ unsigned long random_get_entropy_fallbac
 
 #include <asm/timex.h>
 
+#ifndef CONFIG_ARCH_HAS_RANDOM_ENTROPY
 #ifndef random_get_entropy
 /*
  * The random_get_entropy() function is used by the /dev/random driver
@@ -85,6 +86,7 @@ unsigned long random_get_entropy_fallbac
 #define random_get_entropy()	random_get_entropy_fallback()
 #endif
 #endif
+#endif
 
 /*
  * SHIFT_PLL is used as a dampening factor to define how much we
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -18,6 +18,7 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
+#include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>


