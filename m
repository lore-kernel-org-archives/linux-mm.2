Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F39CD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700E86B0093; Sun, 10 May 2026 09:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1B06B0095; Sun, 10 May 2026 09:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B446B0096; Sun, 10 May 2026 09:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 415CA6B0093
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C527B1A041C
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:06 +0000 (UTC)
X-FDA: 84751659132.16.2A35CF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43CBDA0002
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQT2Wxjs;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MKV9zifGGjr0RkVaxWL3NCZ71DSzJ+/iqax4eUMy34=;
	b=56+wGyr7VGVh5DoqRWwm9I2t/Ba2OdbCZ2BaIq4R5jx/8MgNYrSN8N802xF69I3PxWl+Ja
	yN5YVT4rE7AAcxzRclI52RjTGdW4xkQ6NltOsw0/hISBmnx46DMvnxaykTU7eyTbqlnXWK
	prsiYsto0NAovv6nfuxjB1FJNH04I2Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQT2Wxjs;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421365; a=rsa-sha256;
	cv=none;
	b=IWZLsLAkqkI/jUpwr2JJ80Fvacv0yVlhC0ktzjIL6f6a/T6BQhuPGEq12ugKQGSUK8k7MT
	Jbo3Eb1iVIPHzCaaH1hWd/fAEYdryWwGGZLY1GalIix8rSMgT9NoQJmcXse+smYGUXEoDc
	3zNFCr+FAxPI//5rc+tAQaB0qEbugYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBB0960121;
	Sun, 10 May 2026 13:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E1DC2BCC9;
	Sun, 10 May 2026 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421364;
	bh=t+0t9hvA3tabF5jUso2oxhF2AbVitxrNZunjEKj5M/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQT2Wxjs4v+g/nPjbC7YXF9SenInlURoMPi3uzxYo7W5Le0rVdc9n3EIL1+/cQZUr
	 561KxpXO5Y26QutNzT5arFgo6r6ReQOx2gamBfrrRcn5VnEHddYpCpMZ1LGs8K3UKT
	 cWsNOpCJ8xbFeu8apFhOlUuU9btobZmlBjFnDqG/lUaVAwUxMAZitvKNOBHtzJvi+m
	 nikzGApHg82ZELNIa5YmnCZW/u6AeADKG1ZKulXcnRN7/Pl9X69AigP0Uhsx7KkbJv
	 2bzwkflILNYftHh4qooLcKI02gkezN6m87CY1R4I9wRCvgnCB9Jbf36OYGK44utkAt
	 TJedGoYX6b+OA==
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
Subject: [PATCH v2 04/10] sh: remove setup_bootmem_node() and plat_mem_setup()
Date: Sun, 10 May 2026 16:55:40 +0300
Message-ID: <20260510135546.13554-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43CBDA0002
X-Stat-Signature: mnnhym9njfsxstr8z36j15zqzhxc8tzy
X-HE-Tag: 1778421365-422454
X-HE-Meta: U2FsdGVkX18rl6PfA70Umki1T1CByuJ+byeBSl/zPWpz2LIh1BtXm9H+CE4RYP+jogqpAjZzDOAOWfjsDeiIRgIBiQ5SyIH2E4R3K0DGY5bpReXRxZ45DhNQXlj0E/NP2bPhZw5dVDGADa4a8G7QvP/cYdTyEvzDOl1gIR9hpq7OnF9QnBGFegEgyUKlq5QxYKlCKeHDmK4aNCdpEqjQMg9EWc3+dqvyFuezV2p19bICk2BDOts9KrOVqq5kZfH7cQHM+2AoqHjJpcDU/mp6ATQv5bfK9VsO8oJ0+ZyH2skcYV4uu1eiQAcoQbFbKKXdbIVqxIEFp621NgSIO7jpSlJwNXRQSRd44fUdBUh3D+cn6Q7Sc0xY4qwAYHcZkk+WQm5ANaDdw7W1o6AL1PdbogEUKR34hLtbzB83zAbnVCmI6XkxXiP14DWNJvgXV8bStTHwGqSHQFeumBfHHgFmwWCZzowU61pTIjujpec+CHSlGWoa3gADIcAajNvP0i0Gv8wePvHdOgcnCRuvznO12IYm4ynsH3xwlUmjKF/atRQ9T7KCbjbNi8BFW0S2X/NlmlKi4rjecGG7WhD5nQ4+upjy3HXO6aCurxlyNcpcdS/FADFmjF8/gE6DH+Pr8zSasKarBQp3pncP6fNlYj003M8FRBwnxkCRj2twECUSsC2hmmWyqqlsbHtGbKYKq8boftt1cB46QRTZGY6zuvDIlFXE9yaKxNbD6TNwJlcL+p1Y1ykQ31IsLAMZA8wY1cJufnQJh5v2PTBhHeK+OfhrLGYTb94nsFWpxQ7+Zsq1105YnLbd5yLwAxvMZHdYkistt7bFudEjqkElVoGUmCLdvaoCx3DVtyaLFE77wM7LSy2paZfu+BWZ0g8ormoF3BV88iIP82jMzPa5+WVqpeKcuh6AaT3rd08azcYw57nqwvDWRWyyNA/BW92PmgoxXS24foJXncm9zQGt7+5PZMP
 rY24o0MY
 /z3YPe0ebDbByflVthq3ZjjtvKe6A74A7shFfQtcgHmg8dNvoIERLZthGbYNyGpjErZ6v29T+zVvuO3hUwj2lN6VKF751uynTaeGSYwUL8Z/MGzDdyjWVbaOlWtyEKxPVUwCgWeXhdceRo0AtvqlTTPijikvR3sfSGCQwvwm1zUh56MmtfuiX6K4Zkyeq2ZhYyXIGHRRo119V0cJjC7KfpE6k559/Z0ukQTWcgl3igU6nlCL6W/Dt0saqNhCKqPkiIkFRkWEmKlcxyf2zUsAXdI3dIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

setup_bootmem_node() and plat_mem_setup() were needed to setup NUMA "nodes"
for URAM memory ranges. Since there is no NUMA support anymore, these
functions are not needed.

Remove them.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |  5 -----
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |  6 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |  4 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |  6 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |  4 ----
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   | 17 -----------------
 arch/sh/mm/init.c                      |  7 -------
 7 files changed, 49 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c b/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
index 6676beef053e..0a4ceb9785f6 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
@@ -381,8 +381,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	/* TODO: Register Node 1 */
-}
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
index 0c6757ef63f4..2180819a1455 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -658,9 +658,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	/* Register the URAM space as Node 1 */
-	setup_bootmem_node(1, 0x055f0000, 0x05610000);
-}
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
index 2ad19a0c5e04..1f4396da00e5 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -1239,7 +1239,3 @@ void __init plat_irq_setup_pins(int mode)
 		BUG();
 	}
 }
-
-void __init plat_mem_setup(void)
-{
-}
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c b/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
index 3b4a414d60a9..95c3cc15a443 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -600,9 +600,3 @@ void __init plat_irq_setup_pins(int mode)
 		BUG();
 	}
 }
-
-void __init plat_mem_setup(void)
-{
-	/* Register the URAM space as Node 1 */
-	setup_bootmem_node(1, 0xe55f0000, 0xe5610000);
-}
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c b/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
index c048842d8a58..a46d6c3241a9 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -783,10 +783,6 @@ void __init plat_irq_setup_pins(int mode)
 	}
 }
 
-void __init plat_mem_setup(void)
-{
-}
-
 static int __init sh7786_devices_setup(void)
 {
 	int ret, irq;
diff --git a/arch/sh/kernel/cpu/sh4a/setup-shx3.c b/arch/sh/kernel/cpu/sh4a/setup-shx3.c
index 7014d6d199b3..3197ec2a65cd 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-shx3.c
@@ -377,20 +377,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	unsigned int nid = 1;
-
-	/* Register CPU#0 URAM space as Node 1 */
-	setup_bootmem_node(nid++, 0x145f0000, 0x14610000);	/* CPU0 */
-
-#if 0
-	/* XXX: Not yet.. */
-	setup_bootmem_node(nid++, 0x14df0000, 0x14e10000);	/* CPU1 */
-	setup_bootmem_node(nid++, 0x155f0000, 0x15610000);	/* CPU2 */
-	setup_bootmem_node(nid++, 0x15df0000, 0x15e10000);	/* CPU3 */
-#endif
-
-	setup_bootmem_node(nid++, 0x16000000, 0x16020000);	/* CSM */
-}
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index d73179116184..84dff240b113 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -38,11 +38,6 @@ void __init generic_mem_init(void)
 	memblock_add(__MEMORY_START, __MEMORY_SIZE);
 }
 
-void __init __weak plat_mem_setup(void)
-{
-	/* Nothing to see here, move along. */
-}
-
 #ifdef CONFIG_MMU
 static pte_t *__get_pte_phys(unsigned long addr)
 {
@@ -209,8 +204,6 @@ static void __init do_init_bootmem(void)
 		__add_active_range(0, start_pfn, end_pfn);
 
 	node_set_online(0);
-
-	plat_mem_setup();
 }
 
 static void __init early_reserve_mem(void)
-- 
2.53.0


