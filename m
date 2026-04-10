Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD17F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA416B00D3; Fri, 10 Apr 2026 08:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B13C6B00D5; Fri, 10 Apr 2026 08:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A516B00D6; Fri, 10 Apr 2026 08:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04C0A6B00D3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8BBE140515
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:05 +0000 (UTC)
X-FDA: 84642555690.10.119EED3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 29AFA20003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMEawaGf;
	spf=pass (imf03.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMEawaGf;
	spf=pass (imf03.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823664; a=rsa-sha256;
	cv=none;
	b=7jPt0QzOLj/X7cvrr1I3ftlzLumVog9g+RR64jVCS764ExRu5OjMEdDtBSG8NWsBL5u3El
	/1UXSgj2XxvOFudN1eWp3iccr+7ZderwFbv6mmLoD03ARzlicPLyW6fpXbFekbAcCvBGmJ
	CNCaUOXsXAYACwbUCpfJoHFEEw/U/fw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=knDLOL3Pglg0Ub7FLYkkPKBMBdISeZid22CAd3SOyJM=;
	b=DFaH3oCP7CLtc+eH4+7KDxjuSpFHv/iovAOpR46STWpTv6/i5Pk/DuqK3oKaRbkXAOSwqX
	Hg3ZWMDK4VQdrKWvSwHf5XuAeCb9vTLYmmZNepURLatB3dlvrMh4XqrgjMZyxPyjHeGZ+F
	v4ZLO3v0X7Jyigau6OBdN5EseyD2Dd0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5035961333;
	Fri, 10 Apr 2026 12:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21923C2BCB2;
	Fri, 10 Apr 2026 12:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823663;
	bh=arEz1VHg70GeH2cUr9Lpy43pf1nP5ZqGj9No6b3NvGc=;
	h=Date:From:To:Cc:Subject:References:From;
	b=NMEawaGfBmItTINOkOidvgB6jXoclDGf78qU2DQLeTlzGLrdEzTDk/muIR3isadas
	 Eyy5g0FnRv8ECHD8WNjJd+poKDwf709MD2FUA4Zxpq4v2gA+LwpA8vel0ik9BGCmUL
	 SRAcDP7ql7MsZ2nrhkZkSeh/8fnf2+XnKGt9MLspNLANeefspPmNjhAwKQtf/nBzwq
	 +qFTCUz5zVqyJxqgiY8VftvHSe0PhwZa05l9UZAVCASdReHFxw2Di6MoEIbRm/DACH
	 6EZjVdKmyCFY0ahPlTJF5Om8tUGbM3+RzMDvfnJ5JW0Kfa99RJyTmb3751RAHQJ2qn
	 SLzORLtraR9aA==
Date: Fri, 10 Apr 2026 14:21:00 +0200
Message-ID: <20260410120319.658485572@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
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
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 31/38] parisc: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 29AFA20003
X-Stat-Signature: b9txcxbgbjrhks8bw1ke5ymkniher17o
X-Rspam-User: 
X-HE-Tag: 1775823663-176848
X-HE-Meta: U2FsdGVkX19bEpT58+2L/Z/ZpP5DtN1cbkaNUhALBVaYeylgRE5UeGEVHVj9rUWC8kv5xrNNcIMSyf6aGh6FaKoJRL5Jx2urCZM/um9SbvN9AxK4g8gaYgy5DcM2Xdym23D+bAsBlGmzpHdu1Lpuq6dLwnbyNDYQ8JrKNbZKsSL/QTTNUP+Qt5/dbNZi41JX1ZR1eK3ZXhf9bQpz1ko/8B3VOoJekpJIzb2rZ9X9JVSZaPQlDzUIxUNMhImfz2IorVHhhL7F02HOCg5ZCua0XhqsT2TjmD21qTyOOsk3mzerFR3SvKLWNX0tEXf0xWDTqZPc4NG4oqKJGTvtV/zGB6UFMR2OoYRnyI/kODQljCTJzYhZZX1RCxHw5aLyI2rBxK2Ob7z1igcW2XcwhboDn0GJaV1XftWPXi1CwBTl9wov1rlKKXBOC1kQy1czBxbLCLs3jk5L1cqCPItnTtPkKLMqhocny0iE66KvUUKwlXiR5TQgZgGutOav+sHFdBZVLepn3bg79ybHssRGVbcTnlphAUAX/YyvKc7jCNet81NL3WU2CCVBdWFuwfLhLvSrmB8xdVKI1/VTkiLRojJl7lA0DDIk0zhQrdZzd+iNHBy5v3ylwq7Kx+4v7a5u9kOespHQwzbrazCVqUeT1ovMiEDAgYzwvwE3bPHtdxZIbtK1/W50UO+4IyzANk2G/lNzmrzB8lSxD/rFiRILbRsgvSorcfEKFtdALpawij5GXvr39QUo9AqGfCFkDmcfx+pM4dRZs+zchx0KN9UzYebjcA0a5nWLc4xGV6HJjPm1j2GtqIwITbXg3nYj2QUW+BUMQzctCTPbGz3Ab7tfNvSLtBAVY4M4PvJd5Lz2AWkPIsxkJF9NmDFzGhEqhqfqnqVYM9OdkltTDmlykjjvvSgj3mertVjG1hB6sPircPlq8G5lYCCW5VVOY1iAVEJ6WOj8vnzvCJRnkzIhB4S8WI7
 ZuYwLgli
 O27u6/cjfE/V2s5BLlQ9yQAwWWtli/35YyDuoIBEiqpTFfmSlDvhzJBAWHKpUBJQ4YIu3ZYV9fE8tQ+rOuIyHPKEDcjo/jOe+QTpCREtBGA6eRnHKghrHJXygMvpwOFnTTYHav29wbyJxfek1G+FqiC/RTI8DVzDWFIG1B5TFnCOzprcdLRTAZS6XPvOJqIOwvQbP/1a4dHPcuSSmJP5LqFlqXB54+SBm+vnCeuqmINQbopvDqRZvXzMHYhdaWRkaX1RFav7mekmx9wLXPEM8J5QKuy0B43xrzGYXmqyUADkZBjdz9Vw8KTs0Y187E8+j3FBE6MTbfM+kTZ/81n9sF7ZGjO0diTpTKbryIJzPLdiaOe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch parisc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/Kconfig              |    1 +
 arch/parisc/include/asm/random.h |   12 ++++++++++++
 arch/parisc/include/asm/timex.h  |    6 ------
 arch/parisc/kernel/processor.c   |    1 +
 arch/parisc/kernel/time.c        |    1 +
 5 files changed, 15 insertions(+), 6 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -16,6 +16,7 @@ config PARISC
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_NO_SG_CHAIN
 	select ARCH_SPLIT_ARG64 if !64BIT
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
--- /dev/null
+++ b/arch/parisc/include/asm/random.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASMPARISC_RANDOM_H
+#define _ASMPARISC_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return get_cycles();
+}
+
+#endif
--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -1,9 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm-parisc/timex.h
- *
- * PARISC architecture timex specifications
- */
 #ifndef _ASMPARISC_TIMEX_H
 #define _ASMPARISC_TIMEX_H
 
@@ -13,6 +8,5 @@ static inline cycles_t get_cycles(void)
 {
 	return mfctl(16);
 }
-#define get_cycles get_cycles
 
 #endif
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -30,6 +30,7 @@
 #include <asm/pdcpat.h>
 #include <asm/irq.h>		/* for struct irq_region */
 #include <asm/parisc-device.h>
+#include <asm/timex.h>
 
 struct system_cpuinfo_parisc boot_cpu_data __ro_after_init;
 EXPORT_SYMBOL(boot_cpu_data);
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <asm/processor.h>
 #include <asm/pdcpat.h>
+#include <asm/timex.h>
 
 static u64 cr16_clock_freq;
 static unsigned long clocktick;


