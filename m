Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7114EBFD38
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBAF6B0098; Mon, 13 Apr 2026 06:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2648C6B0099; Mon, 13 Apr 2026 06:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107566B009B; Mon, 13 Apr 2026 06:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFF376B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE1D6135DD0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:13 +0000 (UTC)
X-FDA: 84653205546.04.84590E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 273FCC000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=av3a0AwT;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077232; a=rsa-sha256;
	cv=none;
	b=XWsi1hoeKcvP064CXR3SpP7Wix0Uvlwvg6954Hqb0gZ35bgHC1UarHlB8sZoOOKdoEcY7n
	Ed+YKpVY2E7SBveQLWDt2bPezp8ZCvRG+vSYWwntQVp7U5kt/pl6BiQs06VO+5UvbLJwjv
	Zd+zIvEBOfzt2RYnENTIfuWn79V2Dk8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VLiFPxKhjqHd9u7sKt6ElFWbiKez4j+Ij69kKykAVo=;
	b=Y584bvvkuCFyAk5tfB4sAhhJAykKhEaWDQZ9p6AIbNgTTLMgq9JLKU8XdlQpWfSvzqVJTQ
	8wr29MQrOzO3vM/H+0m84K5iIxMH5RGw4vOhl7O49arPYnutwkKvNkzVJszWuXQGrnnqm4
	6Oe6gp5Pyy5RQbJzjPHM9ckf6mGQ/Ek=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=av3a0AwT;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A7A8C61338;
	Mon, 13 Apr 2026 10:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407D2C2BCB5;
	Mon, 13 Apr 2026 10:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077231;
	bh=1RIWNqZfuQSQXtyXYZxxAcYIBhO8O9EvGLJSM+pH4vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=av3a0AwTAc1okI6NtwTkrdgGqCjSuoBbOktZ9AJaCxUTYMwEDlvm9jSNqQUlUT9OU
	 q4dkfuyRkJCul5wkqOGIkpdt/+wGQR5A68XMYLVWUBY40HY0RRgaNFRlPeY0l4/iC3
	 BzlDDPYQYtEJsaGekSDmuAsOdgDfK29jfitzaGoPmAzjQcfVA7CLBIKPFGMKEQMD8v
	 knmdanNZdsgd1aGw6PtWjWZQN8q9HdhpbFqIFHJNvRWfNa6V0hOJ1kvc1BMsYviKo8
	 B6hFIbqwxSFIIUPxg6qNfgpam0eot1Vl8NFHYqAw+uu7FfX/zHlWC+1NW2MFuvbT95
	 bKgfHX9ebdsIg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/10] sh: drop include/asm/mmzone.h
Date: Mon, 13 Apr 2026 13:46:44 +0300
Message-ID: <20260413104649.852228-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 273FCC000E
X-Stat-Signature: ebmu9knt3kex9n7kr8ootkxyb6j57kfb
X-HE-Tag: 1776077232-998631
X-HE-Meta: U2FsdGVkX18C57YprVZXuVJiBPYuwbbWVnIBptZybcWuy+fqdB7ZwVQLzVFrpLnKgVRge9WbodgOfmcMa9tTFot7P1ZrjwGXdslGKmuVtz2cEIFAffc1GS39MOEQL/VMEHx+n752ZpEwD65fMGyM70ilZYFsTUWKC9Ee519VXhAM5BPut5U/exdVQGrBYxRndW60XYb/B1nJA5RjfD0z80eKip9xDqe93byCTKr9Fj1puIuBNtc/gaN2jBXI8CEVc+yejKkjDMztHCPISDXL6F7h4NGkxHF+5udNjjQ08m3qG4QPpq8hnmrgP08uaWKvHP4xqIbySEMdxtSgZWm6T4kHMjLsi1LYH2FA0ZuXE7wdbyCGQAwFjafCjaITFYgshozkPVclYmLwzEwPTJnbKs5/UTNCp7NJ6/freBdLV0jcki2woRc8t6gXG+h4wQi7c2V0uoW/tsPCL6obi1LZW1vW56Hcv/YApUlGmKEZ3HOYc3xrdaIGy2WzvKIcWq7orRUkyV3x4CFPyaTTiWWHM4V59LLC0AJ+s9LVJLgIfsLbd2XhhjFVR11kWq6R18xm05ZnSDYH+gsHavg3obvxud7fmD47qfzbJsJAEuYQ3zlQHzE9QVnpolo3l/ghR1UTQNGlXr4z6ftts0ZUxtWwwPod6UKOCvRnPphpgElebrlNpSVoaAZkLj/PJsmsAVnZFddxEplBudPgm2X13ZdEt5sscdsF8qWySoJxiFpYqWSnclWPzeI/Bs+B6P+AUE/xcmk0vhvO2vREb9TOVNI3Qu/kvwRtORi57HM0PDLX/Tw6U0v9jROKmb79m5+SvKtcrAdFBaZT6vvgojGHzJeUmhaA/LFBU5Fn6OH62Dn+CnSwA6MnVAKnpSPB19DGRhsD72a4zl1nuvJllbnI5UlTujVc93EkC1rTomBTw1WGIxCzo66zCXj/qYpL2De3TIuZFNSKlfep50JTeYtLowf
 RbvzhBJK
 9zWg++pkkdQB70eice7WcbufnpZetLlKn2l/PLFKKW7ivERIlyZbu4u4dEu5JF/xWut1RmVtaPHqqxeFVV6+Veq/hL+UfI1Qm206bYq7UeexKUvpSzGEU1Pff1p1UfsL42skYpftqBNRzC+y/5kyzw5OUQOkgvH8TaUvo5MaI/EWeu0H1k/ljC3wx4xrKHPdYWozjW6Mv6WfrLotdTJDY4HipJccu0bSm882NC+wSBLqGTW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

include/asm/mmzone.h was required for declarations of NUMA related
functionality.

The only function declared there that's not related to NUMA is
__add_active_range().

Move __add_active_range() declaration to include/asm/setup.h and drop
include/asm/mmzone.h

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/include/asm/mmzone.h           | 42 --------------------------
 arch/sh/include/asm/setup.h            |  3 ++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |  1 -
 arch/sh/kernel/setup.c                 |  2 --
 arch/sh/mm/init.c                      |  1 -
 11 files changed, 3 insertions(+), 52 deletions(-)
 delete mode 100644 arch/sh/include/asm/mmzone.h

diff --git a/arch/sh/include/asm/mmzone.h b/arch/sh/include/asm/mmzone.h
deleted file mode 100644
index 63f88b465e39..000000000000
--- a/arch/sh/include/asm/mmzone.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_SH_MMZONE_H
-#define __ASM_SH_MMZONE_H
-
-#ifdef CONFIG_NUMA
-#include <linux/numa.h>
-
-static inline int pfn_to_nid(unsigned long pfn)
-{
-	int nid;
-
-	for (nid = 0; nid < MAX_NUMNODES; nid++)
-		if (pfn >= node_start_pfn(nid) && pfn <= node_end_pfn(nid))
-			break;
-
-	return nid;
-}
-
-static inline struct pglist_data *pfn_to_pgdat(unsigned long pfn)
-{
-	return NODE_DATA(pfn_to_nid(pfn));
-}
-
-/* arch/sh/mm/numa.c */
-void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end);
-#else
-static inline void
-setup_bootmem_node(int nid, unsigned long start, unsigned long end)
-{
-}
-#endif /* CONFIG_NUMA */
-
-/* Platform specific mem init */
-void __init plat_mem_setup(void);
-
-/* arch/sh/kernel/setup.c */
-void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
-			       unsigned long end_pfn);
-/* arch/sh/mm/init.c */
-void __init allocate_pgdat(unsigned int nid);
-
-#endif /* __ASM_SH_MMZONE_H */
diff --git a/arch/sh/include/asm/setup.h b/arch/sh/include/asm/setup.h
index 84bb23a771f3..6bd5b0d87abe 100644
--- a/arch/sh/include/asm/setup.h
+++ b/arch/sh/include/asm/setup.h
@@ -23,4 +23,7 @@ void check_for_initrd(void);
 void per_cpu_trap_init(void);
 void sh_fdt_init(phys_addr_t dt_phys);
 
+void __add_active_range(unsigned int nid, unsigned long start_pfn,
+			unsigned long end_pfn);
+
 #endif /* _SH_SETUP_H */
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
index 2180819a1455..5e2c24c518b4 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -16,7 +16,6 @@
 #include <linux/usb/m66592.h>
 
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/siu.h>
 #include <asm/platform_early.h>
 
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c b/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
index d64d28c4f059..5c24ff407c89 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
@@ -17,7 +17,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 #include <cpu/sh7723.h>
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c b/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
index ef4b26a4b3d6..9441e4a0f402 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -24,7 +24,6 @@
 #include <asm/cacheflush.h>
 #include <asm/suspend.h>
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 #include <cpu/dma-register.h>
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
index 1f4396da00e5..3750b598d6bd 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -21,7 +21,6 @@
 #include <cpu/dma-register.h>
 #include <cpu/sh7757.h>
 
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 static struct plat_sci_port scif2_platform_data = {
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c b/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
index 95c3cc15a443..13f08c44fb02 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -13,7 +13,6 @@
 #include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 #include <cpu/dma-register.h>
 
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c b/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
index a46d6c3241a9..79484c598b83 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -22,7 +22,6 @@
 #include <linux/sh_intc.h>
 #include <linux/usb/ohci_pdriver.h>
 #include <cpu/dma-register.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 static struct plat_sci_port scif0_platform_data = {
diff --git a/arch/sh/kernel/cpu/sh4a/setup-shx3.c b/arch/sh/kernel/cpu/sh4a/setup-shx3.c
index 3197ec2a65cd..93cdd1ee888d 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-shx3.c
@@ -13,7 +13,6 @@
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
 #include <cpu/shx3.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 /*
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 5e25c1db4d61..2f2764061003 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -23,7 +23,6 @@
 #include <linux/smp.h>
 #include <linux/err.h>
 #include <linux/crash_dump.h>
-#include <linux/mmzone.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -41,7 +40,6 @@
 #include <asm/clock.h>
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
-#include <asm/mmzone.h>
 #include <asm/processor.h>
 #include <asm/sparsemem.h>
 #include <asm/platform_early.h>
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index b34ba42d1e18..31a9676efbe3 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -20,7 +20,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <asm/mmu_context.h>
-#include <asm/mmzone.h>
 #include <asm/kexec.h>
 #include <asm/tlb.h>
 #include <asm/cacheflush.h>
-- 
2.53.0


