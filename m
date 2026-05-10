Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEEACD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6256B0098; Sun, 10 May 2026 09:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09576B0099; Sun, 10 May 2026 09:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1046B009B; Sun, 10 May 2026 09:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5126B0098
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 599BF1C1067
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:12 +0000 (UTC)
X-FDA: 84751659384.22.A35B670
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C54D440007
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkjhb+Kz;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdxHsufvVoo2o7HR2nC9/DjIAFoudux08ptHYcgvXEQ=;
	b=Lo+IKMIJgLaVpfuXNq/5VLd+ImBGe6lpwUeALZ60G/7yY8Cm76IQywiexdvbFZgXYUePgg
	x5+uD2Tf9KyEuVQRghGUhKRbuaUnS782SlWaM1u/uy0yZgAmPPUnTOwUiNMf7KejCwR5Qv
	M5+vyMHzshEtBAMztz66EsAx3dRgp08=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkjhb+Kz;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421370; a=rsa-sha256;
	cv=none;
	b=2vWsCgonS2GLl+r1dAXHJdsxr80IRu7L5sd3eZVe+50A8eTcQQGn/ANYuN4pbQXSLY2iAQ
	U6LbbAqmiLxS0GDXgmB04bXPn6Wio0IIle545HthCjAfwOhpkGHzMiDlswtTp9pq/Ao7Be
	ps1OiyaqGYJk6a6axADjKdiOIgQ26J0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A7DE60142;
	Sun, 10 May 2026 13:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7128C2BCB8;
	Sun, 10 May 2026 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421370;
	bh=ORqM0QrkLzkJER/HT4hgO46YxIS+mifkv/+oCy4Jx5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkjhb+KzBsRVhs6ypLJdhI0vd1VIapxsl0KqeH5qNGBl1Wlzy5tAeaPJJl8IqIRXo
	 xdQgfGEBeR6d+hx3Ch87FdBKxD92GW6wFq5wbHhUp0bEkY7ry97K7odnffqcCjcFWD
	 wq/iWrJrnbPQknsRvo7JvxVknki3AKYehUJuKIWMRxQamDP/188t48SvnAvrMNYZZl
	 0j6AeuA9KnwHwk0Pi/pFVPyV8sIL9yC6JPuw+u1w5dbkBrT93rwR+kuV9ogvw3bzRm
	 KN2KgP9LvBZWKGAMmiRSR2HvpwRqv6f/icPQp5PhkAFl4F+Opip9bXJtOlE0INj21J
	 XJsj81xrrA1pQ==
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
Subject: [PATCH v2 06/10] sh: drop include/asm/mmzone.h
Date: Sun, 10 May 2026 16:55:42 +0300
Message-ID: <20260510135546.13554-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: osa87zxnij7yot57sficnfj71ssf7o35
X-Rspamd-Queue-Id: C54D440007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778421370-190531
X-HE-Meta: U2FsdGVkX1/a42MX3Tp1BKl/irG9nONJkNnFp9GB7AYLdQ9Tq2Oh2wpmC9TeYyFtUTGmwcJeEwCCSPoTursgogHeKKLTus1T29MNnR1YO4gz3el+EozE3X2sC3Y3ALvY+sYQcFU0PaTgb97gca/67ooqxoLGKWRS1TpDSwqNTPf9hDdJQQ/ZLMJ4lWROxPRN4QsQ5LmsL4XSFgqE7DY+lb6oT3XKP+6QoETwpSUVEeVO6nift+z98T3hS8fqzqaW1+LpCsHOKkkx6iBMTuvtD+4ojx8FjdCXnOQMFgegCCEplIKmsscvHfR1n+EoMZpLp1tWta4uZx/l6u2Ml4W7iXLbTQvEGxZ2DIRt8JJ4v/Y+SEDMicsc6TTvCexRSqTajeA+Wt4VV5fRqJwl6ibhJoGc9MqzlDr890jOCe8zPiNT/OuufnLknBXyJIvVFHBL0/ppkna4o1D+6gV/8mVx31XRcpUz2ZgytN8FlqgOoZZGblGdpzZmkQqsqXumenMhO/jzKWsPwHzb8+NhuQ+AMSIMmf03/0LoSgry0GITc6ASW9YCrVhRV3byTiN52ii9WnNYOnXR4v1M+kcE/sjS8E+7e1l+M1MXEeZ6OX16AY5soJqa4nmsSF++TnXqJ9GCmk1ofenkGtsPEAXpFj8x1s+3CIwngVnPN4e9457PLE8GYhM9kmd23xrxm7F3rp9sfYcbVUIURENXX7TM71PAoKF6fOoQgB5PA6k8INBvMP1bBFg6vEVRbjbqVb9iSYf5RReUprE5g9WfR5qQd7ai70M3AwmhsGJdtgtLZopB9FamVNSpJ9jyyqNcImCkRzlKZMPlmQKBo0ly2iecXP+Wa2rRzjH7TKreaz9l/2nwU8MtR2DHZAqkfsSOibo9dSGgtsO2BiXPXQO0cmrVQyJi7HJNm5RzFKTYQjgz2b7cSj4J98Ept7wfGjWyorgCyPMEUf82CBHYgRPlPHjlwnS
 GMQoQJ+b
 puE8aWmomzEmCYFSOf+iHv95BWgKDMaXBtrgXXw2QSl/8vqt1h5gABwHlvOzG6Ugd16x6TjCGmD+vV4SZMoCWZcs3mV9BHXLb0CwUmrgolqZr671YIWd37v2Lzj2luHWOoBCPfNaPbI8I16LvyDUArplyOVm5kdrJalcyLwXtCCert8O8dc2++Mx4XUcgQ0ocJjFIR9Qc95xliYJrSEAAlk1l7QY+2pZYJPKbhFWRUquoUUc=
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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
index 63c9efc06348..ad9470359d61 100644
--- a/arch/sh/include/asm/setup.h
+++ b/arch/sh/include/asm/setup.h
@@ -24,4 +24,7 @@ void check_for_initrd(void);
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
index 84dff240b113..cb4b26485f4b 100644
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


