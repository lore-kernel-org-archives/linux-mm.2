Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B17F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A696B00CB; Fri, 10 Apr 2026 08:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A256B00CD; Fri, 10 Apr 2026 08:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8D96B00CE; Fri, 10 Apr 2026 08:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A94B6B00CB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4EB4591FD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:45 +0000 (UTC)
X-FDA: 84642554850.12.588C1AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 532D5A0013
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKc8BIj0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=vKymtlo11yiDU4TLKycOojSP+rmgc8Jkf+2yejheXps=;
	b=dOS2voMw2BHVkJVdGluXI6XzSVxLZn3ie1y7D8+PGQa7eLlDOZW3uCgA5svlmjmFVK1Ddz
	w9Edd3jjwNQ5ikbvE2YWeh87lfSmK442IFHSd+aRy7KdAlp8HqGutGn2XwyHEfSNRu+HdQ
	z3U/S+8cdsDV3ikAcxP5giR+11O9tiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823644; a=rsa-sha256;
	cv=none;
	b=8TBuGEX/ZRkZmYZmjS0yHLA5W6N8qJMcq2SpDt8gOm/xmkXCha2EqNWPNeA4HkCvfUw76U
	TnyE89qJHDiwVlx9MrHm7gY2QRLsCuZs0rUO9CqHigy8rnSbqgF4ulUC/GsIdzd3Wtpn7P
	rwwTb4PwfslBKH1X3F+Jy3p6wjzpM90=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKc8BIj0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D2A206111B;
	Fri, 10 Apr 2026 12:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A4C19425;
	Fri, 10 Apr 2026 12:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823643;
	bh=ZI1DuZTKY+73ZiUZu5YDxjD9E28Vsj2HJPMLgb9lTAs=;
	h=Date:From:To:Cc:Subject:References:From;
	b=aKc8BIj04xl8fMPMfIdxvFnc9Be7sg+HcqnW4NP8XAVA8CoHWWZUH1TGoEDd3vKKD
	 FNpRo6Iom4qBRwumLXapTj7hfgRDejsC7j6E+L/Vx4C85D2LE1/deOAcMcctONxvIo
	 HMR5AMjZPk8wC2GcrGQEDXlt0rYZP0bNeTIqA2wyhnF5OK38Pv/q09G+oh4E6MeUyG
	 /IRrdxDk2wKuJ9eIif/wOJjQhHy2AsumkYu8PWY0TnTc6wXQmoLW+lJrShxrt0E6Gb
	 m+nyDRqFv+r0pZBlp7wkM/XjcKkMGym/WCszxlys26yMLXsGUqt11/GgfHwii1mXtv
	 FSYiSRKkHgM1Q==
Date: Fri, 10 Apr 2026 14:20:40 +0200
Message-ID: <20260410120319.397219631@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
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
Subject: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 532D5A0013
X-Stat-Signature: 1zowjkdqfcyn7d5wmbuf8kmqxqtcsxxw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775823644-53925
X-HE-Meta: U2FsdGVkX18oEN4kge7D9dV18b5XszRIEZCiXf/IirGXzpXUtNRGeA4WErYNKI8jw/Vw5jFtwMRMHQf7xXa27+PAGWo5GV7DLUAVBeK45g4mYw+kgqPJLAzmwYnYqzlnuIemuOYY0bHe4CUO3wbWzRrMkbsl47v53hqdZRVDQVS/ofzpQnrmOG4R4Hg5O1pMu2D9Ii9PLKaYtOqnq02yV+4+ic8Lk2HTWTRZ498IU7iJfnpfOilwWp2QFIvKSdz9YKL01jWOsYI+f2ooQmEqFiy9mSG5rfKOXlkVhD9X360F8f+vwjSCGr8v+dPVTkQP9bB2jITJwWvp958CskmNYzJ6L07vB8g/ef48UDYus8md94NJ/4SFB7AZJVTsLyHP+h+yLIcLdIsuX7YAhnZwjsfrpdmQPa6D5lyM9C7DfbkWTVTWiVY18XuiBZ4GH1gwrr8E+8u0aZgCqP2lmALyQmuLqbXMOxQx/Dulq7bn9g+rrfJGOZmzlITNfIUP0CW8/EK8bq5gX3CeIHGAuVjEshT3DUjRgS5nFZHQK0xFBdiJHJybJOzHgX7wABETBo+i0TNv/Y2JEXlRNDqUOXfBjzrj65FHeiThhOmn/3GTEdyr/VdRtQLU5EVxK7ChPemjipNREAduX3/n/s/mspTjLkMPyhP/bSlqWtTk6eRty4GomUM9HHpB3jNHBfHb+jg3+nDV48TJtarifiPvTRpN8lX4TFjBiTh/NvxJi/15z3BpmgTrj1xzCz527xBcLM8RIKlOCX70jLnAzYhXM62cF/6FxrJZ+NDp7zbDsre1QKZWyNg9UvvhEQfjcVVlEkihV6JYTG2pBaJ/e9qTNyKQ7ZhOdWOoQjFlkT0ukXtG68bqlv8TxgIxf9E/A6kpUh3lEsh9bzADHlmdjjz7IQ03mMsocoe0YbvAPsHwjrCUx1p+aDmiSIouP3lUYCaK8tI3cH8aZd5aXBUeUWTAuEH
 APWaEMFK
 88amMOUaFBfcOGGmoNOhj5V6dR65nDumukiUdlRibhJFqy3t8yj7E2VaL5VXx4H+nMm+YrmjGcrifzSL0aM77Zl26FSG6YOdYgwGfxhJWE70yotEt+j86DDnMjvJXYIcMf9zHuQ6Ov5waXgaZpX77X5nClmM8BtAcYmYYTJJCoiMbSVHAVYv2GrOMsZ8sG5Z5Sm4XMA7VICv5yJtxzCDS8ohiv+oYkItnzpQX9Hm3B7gpBNAtp2pTqL2st6AbRad/8Xa7vEthiwaoU8p+S/PETEkeNLNgCAfnVAKqmaXCB6+ZFF/YCh9DOJsLZlZvv2BoaZX81uPx8lBFVY9XLElxDy9cxp+gd2EWqTG1H6qNisC6qLrxzTL1ibAxfqhSJaCr8WX46OAHd5LBb5mmjKHg94ZerpmtT+cUesFxhVQNPX8ewkNTYx5kaAP0kUqf6FZFRsqkTRXVOMocRvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide
random_get_entropy().

Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/Kconfig              |    1 +
 arch/m68k/amiga/config.c       |    1 +
 arch/m68k/include/asm/random.h |   14 ++++++++++++++
 arch/m68k/include/asm/timex.h  |   25 -------------------------
 arch/m68k/kernel/time.c        |    2 +-
 5 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_PREP_COHERENT if M68K_NONCOHERENT_DMA && !COLDFIRE
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if M68K_NONCOHERENT_DMA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -36,6 +36,7 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/config.h>
+#include <asm/random.h>
 
 #include "amiga.h"
 
--- /dev/null
+++ b/arch/m68k/include/asm/random.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASMm68K_RANDOM_H
+#define _ASMm68K_RANDOM_H
+
+extern unsigned long (*mach_random_get_entropy)(void);
+
+static inline unsigned long random_get_entropy(void)
+{
+	if (mach_random_get_entropy)
+		return mach_random_get_entropy();
+	return random_get_entropy_fallback();
+}
+
+#endif
--- a/arch/m68k/include/asm/timex.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm-m68k/timex.h
- *
- * m68k architecture timex specifications
- */
-#ifndef _ASMm68K_TIMEX_H
-#define _ASMm68K_TIMEX_H
-
-static inline cycles_t get_cycles(void)
-{
-	return 0;
-}
-
-extern unsigned long (*mach_random_get_entropy)(void);
-
-static inline unsigned long random_get_entropy(void)
-{
-	if (mach_random_get_entropy)
-		return mach_random_get_entropy();
-	return random_get_entropy_fallback();
-}
-#define random_get_entropy	random_get_entropy
-
-#endif
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -26,12 +26,12 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/irq_regs.h>
+#include <asm/random.h>
 
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/profile.h>
 
-
 unsigned long (*mach_random_get_entropy)(void);
 EXPORT_SYMBOL_GPL(mach_random_get_entropy);
 


