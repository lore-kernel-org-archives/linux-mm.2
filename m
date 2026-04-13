Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F520EBFD38
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BE76B008A; Mon, 13 Apr 2026 06:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7E06B0092; Mon, 13 Apr 2026 06:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89146B0093; Mon, 13 Apr 2026 06:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9BF46B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49D7D8720F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:00 +0000 (UTC)
X-FDA: 84653205000.19.0DC77F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B33BA40002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:46:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F1/t6hzl";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077218; a=rsa-sha256;
	cv=none;
	b=wfXMukendpkJ76etGadOV5/TqZ5K0Ve+TkH1xCZl835Zj1fY34EQ5VhHplpTx/xub29BUU
	MjcGP1mb3cpvS+0pcHdTrK03cvgLw258l4ouTCivMDP9fh1PPj5pQFD37k72f3KrkvJHzv
	8y2BHhSSlwQ7zIjBmQlk9/IUiIjaSfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5xjbVLprflDkPf/pFEWNqQ4xViVS74UkIZozTdoRsM=;
	b=WP1n9Eb3+kkBEThwNfrw+hH6tg6uHLVgTXVWwg3sfF/BU035yS1tJo8Rt8lRiaC6zTILhD
	5Hu1VUtl/OPrTZAE81GXhOaLxaSlg0bQiyLW5N1QDOlF9ZieDPTOAlLjizOHXrNATsEBd1
	oX8oEHfVNZCrhMZI9QhXdTx/tZNeEjw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F1/t6hzl";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 194F26111B;
	Mon, 13 Apr 2026 10:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6DEC19421;
	Mon, 13 Apr 2026 10:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077217;
	bh=o+bRmTWfQc+OTMbhFAbbaOgxp/R/J7MaFpD/5SmWYO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1/t6hzls0Rjl3gyKupeUJWxd+mYvAWoin2QDRTaHfVaenGgwRweLoJiYCns/lygw
	 1Npu61IKoodT/KgO0m/rQZlWyXp7jTbwDjBvhRO4o0A/WxeXzbXBoA0DUfo6bk+qeU
	 oHbs4FKM8DiP9teJ+ampOxl/c+EHA8///3tykEWbkPEQOWxH/ELqGKqj/6nlr5BFUi
	 eXSR09mkDRIk+tJrj1blBy5Pv8t2FkYR/UYyChOztnsz/T7uelXgUq/XgugVDRCa+Z
	 +r6glmj5kvP723TA1I0Ul3blSZ4cP8Hv3BgstuCbTFQcMvEAxND3nN4I8+TaAiGHrf
	 l5FEVSkpsHueg==
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
Subject: [PATCH 01/10] sh: remove CONFIG_NUMA and realted configuration options
Date: Mon, 13 Apr 2026 13:46:39 +0300
Message-ID: <20260413104649.852228-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B33BA40002
X-Stat-Signature: fphen8g4ko8yyb54w6udwdzriusxemyp
X-HE-Tag: 1776077218-783767
X-HE-Meta: U2FsdGVkX1/1hqGQdTovSn0/QYXsPIXpWvfmI0oNIFgZ+bBhysRJJekWk53Mu4chRFPozhCn1DDxAZOkFIxyJwIeJ0UwZUftPYpnaimkkV+32ya4lPfSpwLxnsdNndrpN8S8docGHfGtne/2l8IwVGcsQW90+MjuIZC6n7xjsnv0uX7vDVfDZusiAC5E+X4JWWGdi88Tdqa2TCe7VEGw1a10siFDlod/5zrSkzDkqRfMJZ7oWk647DUiqu0lRO96gtnTB6shB69A8+ZWePVXRFIfi+teX8no2X1BwTPV9r8TZWZAJGpkOb72XRQAbsshDFuHvjQTxsD4kh1xwNexoLR85YR4WWmQ858wbvWVePkc0y8/HeRGOSkYpC5Iy3pkWcmQ3w+sS5LBuwq3o015aN/WK5/ymK084atlANldoc7reVMSSh3DI7RM5Rzfg0zT+L+bgR8FGjnAbfIzbwuaP5OJ9fPRtmRhe3Z5p7TG8+pqv305dwFI/9HJqCs6wfj/sHi0fUhn4PedsChhFvfSD39tdKECdgocvW1Nrv4kvjEBtGC+OIA4nDUiMa82ZOunbl1U9++f5q3wtdB52AByWczp1aKEfEzgR1zAEkXCFQDyYlmwi09Ii95qHdUucXMBDbArRzS7b+94ku0hIwhMCby7oSczADA00zPcPmEQQKvMZ9Hn2dD5NajUt49xoF6zkboambM6N4xj3M5F8Umu/e3aPA1C3w8Tmbo3usJ4SkaK6sBXB3PWwedAjRJCoXmUuoQ1cReXv5696l/L3GyHwaA2UOa0HAJCJbed4hNRVtngh0xCBg4gM+tDX6PIdRrlqknwhbGc/Uz/gOJOPpM5hhYUKLw4O+vnfGCAdNmrPTBPxVcn39xuJ3s/dyLajaA508oDfV7t83QjFyN++Hw3Es9XsLBeGd7gV0m7Y+xnwWWeN8sbmK49RPsp97lNzAPyJkzR11qWV7khCbbgbZz
 3mVlx6H+
 2Ufrzf9yy3AY3pLisEVDABCr9/Mad+UR4UdwbJUmUb6QdJoQ9Ru6N/rrahl2n7JAXE9c2gAXm9PLhF14DWWqaLNS4o4TTKB6EwyFKyV3r1yK/NvyqcVlRSja2z61IU9QluQujWquCsyDdujRWM7AHLLYeX3PylgJD9urvBuGSOuAkLJ5n0M7N/EjsnBbnYDZz0h9fkjBnOQHQ3jHynr/gaStCSOhkhatS7CKOiYPbKxHiGFLRFx2rDJRqge2QeXPDEoNmo2KNSBDDQSbwJ8Q+igXcFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

NUMA support for SuperH was introduced a long time ago by commit
b241cb0c885e ("sh: Support for multiple nodes.")

	"... for boards with many different memory blocks that are
	 otherwise unused (SH7722/SH7785 URAM and so forth)"

In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
shx3 at the expense of all the NUMA related code in the kernel.

For build of v7.0-rc7 with defconfig and the same configuration with
CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
overhead in code and static data that does not take into the account data
structures allocated at run time.

And all this overhead has been there for nothing for almost 8 years
because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
those additional "nodes" could not be used by the core MM because the
maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.

Start removing NUMA support on sh with removing CONFIG_NUMA and related
configuration options in arch/sh/Kconfig and arch/sh/mm/Kconfig.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/configs/migor_defconfig   |  1 -
 arch/sh/configs/sdk7786_defconfig |  1 -
 arch/sh/configs/se7722_defconfig  |  1 -
 arch/sh/configs/shx3_defconfig    |  1 -
 arch/sh/configs/ul2_defconfig     |  1 -
 arch/sh/mm/Kconfig                | 19 -------------------
 6 files changed, 24 deletions(-)

diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index 1d9d543eef4c..db993616f14e 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -9,7 +9,6 @@ CONFIG_MODULES=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7722=y
 CONFIG_MEMORY_START=0x0c000000
-CONFIG_NUMA=y
 # CONFIG_MIGRATION is not set
 CONFIG_SH_MIGOR=y
 # CONFIG_SH_TIMER_CMT is not set
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index d6fa3a422e24..36e6dd0622f7 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -41,7 +41,6 @@ CONFIG_CPU_SUBTYPE_SH7786=y
 CONFIG_MEMORY_START=0x40000000
 CONFIG_MEMORY_SIZE=0x20000000
 CONFIG_PMB=y
-CONFIG_NUMA=y
 CONFIG_HUGETLB_PAGE_SIZE_64MB=y
 CONFIG_KSM=y
 CONFIG_SH_STORE_QUEUES=y
diff --git a/arch/sh/configs/se7722_defconfig b/arch/sh/configs/se7722_defconfig
index 85b8eb013b79..2908611b118e 100644
--- a/arch/sh/configs/se7722_defconfig
+++ b/arch/sh/configs/se7722_defconfig
@@ -10,7 +10,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7722=y
 CONFIG_MEMORY_START=0x0c000000
-CONFIG_NUMA=y
 CONFIG_SH_STORE_QUEUES=y
 CONFIG_SH_7722_SOLUTION_ENGINE=y
 # CONFIG_SH_TIMER_CMT is not set
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index 0cb69a0b92cb..22c242cf89f7 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -29,7 +29,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SHX3=y
 CONFIG_MEMORY_START=0x0c000000
-CONFIG_NUMA=y
 CONFIG_PAGE_SIZE_64KB=y
 CONFIG_SH_STORE_QUEUES=y
 CONFIG_SH_X3PROTO=y
diff --git a/arch/sh/configs/ul2_defconfig b/arch/sh/configs/ul2_defconfig
index 0d1c858754db..ff15d68dd12d 100644
--- a/arch/sh/configs/ul2_defconfig
+++ b/arch/sh/configs/ul2_defconfig
@@ -10,7 +10,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7366=y
 CONFIG_MEMORY_SIZE=0x01f00000
-CONFIG_NUMA=y
 # CONFIG_MIGRATION is not set
 # CONFIG_SH_DSP is not set
 # CONFIG_SH_TIMER_CMT is not set
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index 1862411665ab..71fecbbb080e 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -112,27 +112,8 @@ config VSYSCALL
 	  For systems with an MMU that can afford to give up a page,
 	  (the default value) say Y.
 
-config NUMA
-	bool "Non-Uniform Memory Access (NUMA) Support"
-	depends on MMU && SYS_SUPPORTS_NUMA
-	select ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	default n
-	help
-	  Some SH systems have many various memories scattered around
-	  the address space, each with varying latencies. This enables
-	  support for these blocks by binding them to nodes and allowing
-	  memory policies to be used for prioritizing and controlling
-	  allocation behaviour.
-
-config NODES_SHIFT
-	int
-	default "3" if CPU_SUBTYPE_SHX3
-	default "1"
-	depends on NUMA
-
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on !NUMA
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-- 
2.53.0


