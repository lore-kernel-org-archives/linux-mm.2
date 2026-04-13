Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE42EBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B0B6B0095; Mon, 13 Apr 2026 06:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBBD6B0096; Mon, 13 Apr 2026 06:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266DB6B0098; Mon, 13 Apr 2026 06:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 127DA6B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD65CE02A0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:08 +0000 (UTC)
X-FDA: 84653205336.26.10BE1A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF763140008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+F5Z2nG;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+F5Z2nG;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077227; a=rsa-sha256;
	cv=none;
	b=piu9tX6E25ZvOdF6//G6eoC3Yka1Fh4c4lRzyu+4tw1HySb43ZoymmaxzZae9YXvNeeBhb
	DQUgQSDx2tEY95Tww1i+2Iskz7Sif+4aWEQOmM8MMgcoceRpELXk4sZtXtWlSRcl3iHLUd
	VaCOpbkX4O5Qx4qIyAIOFU7Rvw6C5pk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzwR8yA/7KtFdxpWgkyD0zLS26A/D+VsVJvySqEXd34=;
	b=QFND27qAtmLWUG3ejr14QU1k8wB/a490/uyB1xa7GdRU1zH+lQ+n2pS/yYRwG8RQCAeAOA
	nbUQxHEQJVLrbhw3EcWo7TpvcXToXYzJzQNxfezy7n3ooLJ/zTqooyhFrnFxl0PUJwXx0a
	83Tj7GhCUcY8e4GkzcG3Kr8o3bwGXUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FD764408D;
	Mon, 13 Apr 2026 10:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC9EC19421;
	Mon, 13 Apr 2026 10:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077226;
	bh=NTx/BlRB94FmVGy5XD+EGk+9lfiA/foFvPvF3Gh8bjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+F5Z2nGhLm5eUA+/YoN+Dn4qQW+AkyGZP0kCoDy+JOdVppgzGlrkv10Mp2EX2VqT
	 o0cC7LlQIac4TUoCUQq3XxKiGQkfF2JUmSKlROxBD/KZLPgT6DoGJHk5sdq7sg9VT0
	 5rkt8E0i7lhguHm6lk0BSNttMd9y+UpGmVR6qNZ2gJtIkwnWuA3kUemklLFYo4npFr
	 /QzgdaEQpF84w+WV7I+b9em7dOY7ne/yN7CVUbCeoxUgKWK+dOL3W4ojruVSARks6D
	 y2sgQ9EDu08KAUVsUP/GNZFql/dInKz0VS0yv0Gk/2+ziSxivgvsHn565ZEza0HUvl
	 CcQI1da6DWTEQ==
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
Subject: [PATCH 04/10] sh: remove setup_bootmem_node() and plat_mem_setup()
Date: Mon, 13 Apr 2026 13:46:42 +0300
Message-ID: <20260413104649.852228-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF763140008
X-Stat-Signature: c5e544td96u3xfeb3gqcyz6mnoqydrzm
X-Rspam-User: 
X-HE-Tag: 1776077226-714721
X-HE-Meta: U2FsdGVkX1+u3IUJJVwwvn180r4/I0AzEwXf8F+o+mejKV4JIgONxfymAOqdvf0lr2pr+6SRrlSGbxvhYa+Omg2cILUUgW4VAHqIRH2fkb426+Y38JR/1iB0aWXQdE6hO8OpaCCoy1GT81yTgK2BrinGPnB+N8u6es4Gg61xiKOAyqAQW1K2TvQCBbcik8Uk4BhLLfq7kXEJ2lyh0ny+ZP4x1m/nK9WQaZ8ClwMLbyo7MIIqwJ5ouTLXQrd1Si2X1LTVgkY3vIF+T2JHcVpGIEzjICIaBBzw1pwkJmvyjuG+xCLt//hClwYe4vFzvM6XYJNGQbZBAHBZABQOLjq0Wd3Nhr4qkRyNFnFtb6xOHPeiJZ8DNv0mIIdbCtec3WXlwXeuWTQIaoLWDzNV8P3sE3pDZQqP42ROOPViqXj7gG8cE0Up1IzX/VwOdAfr59xIAInl+x7SAEjKwPc7zGuYW3Ef/xu50H/x3mJaPYUhjTesM521gWYG2T+S4bUr+mcqH0UGCOADWgJedZsWJ+dguSD90b/BHyBREkd8pOKLCwSzSX2Mrj8N7heWv43CddWSQBVHZF6Zm0s55gagwkQsMvfyBDyal6WhB4xva45ghatwBgWNHQW94d4PBdXtLL9Kt5pL5d4cHCG/E5cg2DTqjN6IDqvQi7Gg5cuUF1a/YyqOY46PloxSP9RnepWlriAW4xFBfTnO1yUZiON28UtxLWy5wqEOLorgFf9WsGuusiVt4fa5qg4Q4wnxbDulvz+r2m/vWi1s8ssiDFtTL4QTtyuAXKifp/mcwYk8HjvbpCvOZ28N3unHPdx6Si1Kmtcg/Ry3QoWfBWec8mlNpFaA9cQEiZY+XNS6apX8nz8zxaGhkqH0Kw9KEfk2TPUq86ztG1eI+R5434m35rbjmMoiTyxlaoV3dLbKCOka7QI4m5I82FMobostfJ5kJQJoFg6O40bnstCdpYOiOcLbwqe
 DHdPQvVM
 bAZhFNcLvbRomDJpoLRkdPp5zbrT/MhfWMiH9zrTJrIKhIEeQ+ISnuO06tdcWHXO0Ad1ZLC297cdPGT1MXwIDLAlmy+Gh1LbrIjBYkqsfXEdVFp20Y7sJsnVSscf0uuDIr32yQ1DLVJrE22ckjTu6CcQbqaWr2FvKxV3jFSdO1ZLDdvp6DLWdhp+AdNr2vnbX1cD/46OCLsVrWhxNRKm0Fr1CE6UTKCRwwPVGw6iveSKxjcQusQC575YGWxUGYGQcCzXghahUnCY03TBAVngeDWBNBw==
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
index 977392b478b3..b34ba42d1e18 100644
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


