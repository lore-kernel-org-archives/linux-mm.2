Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA09F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237DE6B00D9; Fri, 10 Apr 2026 08:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E88F6B00DB; Fri, 10 Apr 2026 08:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089236B00DC; Fri, 10 Apr 2026 08:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E94E66B00D9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB77AB9B86
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:19 +0000 (UTC)
X-FDA: 84642556278.28.AD6B0A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F97E100007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA4RjUak;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA4RjUak;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823678; a=rsa-sha256;
	cv=none;
	b=oGB01x6JhFJv4P38/Uv4nNR0dJItkUAlb8VkIdynZecinrF6+iR2VT6g7Ln6QzigVK7NrN
	8DeIoV393Tg0zMOCgdOjH8HJ/Hhy1fUJ0zpr196jbMSUvKUI1LQnrB9fGmvDiQaHLJ9hYJ
	tI8zhwK0Atx366tdgAchR3Bn+ofszMs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=U8y46tGevNTaaJuQgRNS3grY9omWgCX/AAW8OBbapGE=;
	b=3y/A/kaIBTY7wqo/7+PVgxHlDCgc4TFPhki2DP7YKR98sUGhhcni3t0T7pGsPz9eX/o+zh
	+1Ev+yM2ypuVKuWfXcEmPcYi0ZplQJZMJKSRGBWlvwGJj4TkkwMW4th2R+lVvVS8wzRRea
	NClRXJceGplKqcBQH6ItFRQL72UX2NU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5F7D6111B;
	Fri, 10 Apr 2026 12:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57879C2BCB3;
	Fri, 10 Apr 2026 12:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823677;
	bh=8aVhqN+bsjtC+8iOVhItTcCo4nE5t4ex+cjOCvHOROg=;
	h=Date:From:To:Cc:Subject:References:From;
	b=OA4RjUakSKbHP7uZl9Rn6aI/7Qts08y1gdCxG4212yNJdVKaYLulTRlHhQ1giBOu6
	 tARhrIBIltPo7n2ZqupgbCjM222ynMbD+JMBXCcsIED9ns8vEth54JFbieyU26o9rm
	 KoQTgfYyoH0jSRf5j3OQodGQDBBjhAykp4Hy5bQdfGP0P88P76fnb883frBXWWU03q
	 P/YOEYqjXf/L4ccO74xjFbM3qOQBRFdrvTUVXM6TfNVPJX1ACluXAp6rS0x+D02XQB
	 ZfqSCQC8dN3KdQ34VmPvfFKRcfafCQ6soBJ+KtAS56vLrMJXpWDVh/K6XVrYMUGmaP
	 YaxQP6ppalRew==
Date: Fri, 10 Apr 2026 14:21:14 +0200
Message-ID: <20260410120319.853669871@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
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
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 34/38] riscv: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F97E100007
X-Stat-Signature: o3pftoi9nsy1mqqb9ziud6rb194axd5u
X-Rspam-User: 
X-HE-Tag: 1775823678-953651
X-HE-Meta: U2FsdGVkX18vKCDXoV7hO+vObXoZCmFOXs9Y6uu575K3RYtLl6pmDYwKTZLh3uPJX1+Upjzn7XkiDqo9RndoJsQj/H81z9N6RiQwSvG7V1wPWq+Br+8GVwuWyDCjvS9bWQK0l5tJW6e4WXf4Qgabap1dGjs53rz3AYSoWmX3G5IB3hE5clORDBb8R8J6tcXx6CoDPDO53Bx0d1QbEpa1IHfbjOy25MvHqnLFoFv7CRurWxSPXtXsftNO3g+K3WPOWzhjr/pXxLDy6URjcjzCJ1RwaWkCuDcE9k84KyiPBmBVpRfySqdjE0g8gx3K1HX1Tgc7R1eeWT+Gmu2RWQ/WDvZVJNtnVKWD4W/SV7VHGlAWB3RvtL1BX8vm/b8lg4mNFD88xqtoAZyFue4CWLo1rr/sONfQzH0t0sOaKE6byldZT5dqcVAGHZP3Y07OIjVbHHgqRfWTiq6vJDH+lxV7tdmVoK1PQo8owhcbAId1cU9gF+1h3WMkkSYWreS2JFa8JE5jsbmuqFxUEhmpYo0BDM0ie1Qmkd0BmAUEOlVhcF86S/XWzFAWfA9sGDmgfdlM8+gsd4u1NBVLuVA647M0911XG9486mcy8p5hh/wM6RxEMhcnxX0k7Y3Jnx0laUTOdnMacTs/95Fpyt0qkCuBKKLfAxEeB4H/pIOW149A/KXyKDU9fItPFw5jDehVvVoJkqStetrAndRxf1Uk9ya7mXrHX6GtNPTj9M7asWG10Vmh5srSz8lY2KT2X4xVTWDQk9U7AmVasOGfIEpa+cp6nwgxr4oJ4r+8e0ekin5QyhSBIAru0U3XBvsfR/0PpVIUDjyI+74IeTvsTUc1L9WWpZZWPMcZxJ9shp7ewHOchqIl/uGPOx3RcYk6dkYZ+CkVFMCMw1CUSd4SqKRpLupzO8ta95oPACevozAQwniwRh83eKpTwrpuefwmUghfwDkKE/iAu1/zbRCt41i/lDL
 Hal8SUh9
 Q41STuJfSNWTYLZyufJOBSRUlnvUlXHp51NtA1hC6Rknfh4Hix9yKi5cQWeFQw3oUPvIX6RGHGsiNt9HXTMfcm0jwHZD08uySYX84l1WHkVLSX3xjeIBA/bUhN/pzH0mYuEVGGiPgSzuDIeZmsKaXcrvYyYAAwoJKoYEJPlEyhxAZMamN0mOfQygVksg+18rDtPoWTv9xL8ezxKM03AnhgALqpIN1tSoCOmorwWx/slPkaTuTwGWQwIw1YsudqUK8ar9aJ0eUW30OAzbZg38yKq1I/2XndVfHAwDpZsz7BI/Isgo7iumcQUy5YrQnpND+yBjuimwK++qDjemfesWuTY3z+SdqyP5rHUZ9h3XuULM/AhuJACfFTxhg+SEHvZpKwxaNEbf5o2eID0QLixpTLfxLzB3rb7+wUrkQCrx/SK1Up/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch riscv over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: linux-riscv@lists.infradead.org
---
 arch/riscv/Kconfig                         |    1 +
 arch/riscv/include/asm/random.h            |   25 +++++++++++++++++++++++++
 arch/riscv/include/asm/timex.h             |   13 -------------
 arch/riscv/kernel/unaligned_access_speed.c |    1 +
 arch/riscv/kvm/vcpu_timer.c                |    1 +
 arch/riscv/lib/delay.c                     |    1 +
 6 files changed, 29 insertions(+), 13 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -47,6 +47,7 @@ config RISCV
 	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
 	select ARCH_HAS_PTDUMP if MMU
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
 	select ARCH_HAS_SET_MEMORY if MMU
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
--- /dev/null
+++ b/arch/riscv/include/asm/random.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_RISCV_RANDOM_H
+#define _ASM_RISCV_RANDOM_H
+
+#include <asm/timex.h>
+
+#ifdef CONFIG_RISCV_M_MODE
+/*
+ * Much like MIPS, we may not have a viable counter to use at an early point
+ * in the boot process. Unfortunately we don't have a fallback, so instead
+ * invoke the fallback function.
+ */
+static inline unsigned long random_get_entropy(void)
+{
+	if (unlikely(clint_time_val == NULL))
+		return random_get_entropy_fallback();
+	return get_cycles();
+}
+#else  /* !CONFIG_RISCV_M_MODE */
+static inline unsigned long random_get_entropy(void)
+{
+	return get_cycles();
+}
+#endif /* CONFIG_RISCV_M_MODE */
+#endif /* _ASM_RISCV_RANDOM_H */
--- a/arch/riscv/include/asm/timex.h
+++ b/arch/riscv/include/asm/timex.h
@@ -31,19 +31,6 @@ static inline u32 get_cycles_hi(void)
 #define get_cycles_hi get_cycles_hi
 #endif /* CONFIG_64BIT */
 
-/*
- * Much like MIPS, we may not have a viable counter to use at an early point
- * in the boot process. Unfortunately we don't have a fallback, so instead
- * we just return 0.
- */
-static inline unsigned long random_get_entropy(void)
-{
-	if (unlikely(clint_time_val == NULL))
-		return random_get_entropy_fallback();
-	return get_cycles();
-}
-#define random_get_entropy()	random_get_entropy()
-
 #else /* CONFIG_RISCV_M_MODE */
 
 static inline cycles_t get_cycles(void)
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <asm/cpufeature.h>
 #include <asm/hwprobe.h>
+#include <asm/timex.h>
 #include <asm/vector.h>
 
 #include "copy-unaligned.h"
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/kvm_nacl.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/timex.h>
 
 static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
 {
--- a/arch/riscv/lib/delay.c
+++ b/arch/riscv/lib/delay.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 
 #include <asm/processor.h>
+#include <asm/timex.h>
 
 /*
  * This is copies from arch/arm/include/asm/delay.h


