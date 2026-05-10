Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCB0CD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54416B008A; Sun, 10 May 2026 09:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FB26B008C; Sun, 10 May 2026 09:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30706B0092; Sun, 10 May 2026 09:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF23F6B008A
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:55:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74F09A0403
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:55:58 +0000 (UTC)
X-FDA: 84751658796.07.F6CBDDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E57E3140007
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:55:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEhGLxDb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421356; a=rsa-sha256;
	cv=none;
	b=PqcpWpRBProu6fsxf77ll0IJvH1QLjSk91jLrQa6MhZE6vtX6EMFs0FIwK2kWX+jqrVAIQ
	8v5os14cdogA8Fe/9wnZBa8NVBCLjc/MYvhansQMYUYMY804zJYfGRaIpgdMCP8szlyByk
	E4mgTAwvC4U8LkjDv+CIvEh0YCrORos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEhGLxDb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmRKuObSsau2zJeVDw5KzHn10r+jHH3NX558K23imDM=;
	b=fq9nA04CmEjNUbJjWRxZmaEpdq7UwkKXEK0S+fPSOOttypSdWXCrufeQ8sfM9ZwlzxZLJ1
	+9RbSQhVdqd2c0oYDZ+Ddc7BFApzfNxy/85re7ZNfTnlgtYZgyFe+BJp4vO6cwbCY3YEsB
	LUBX375/aX1SEWIExmitKJpkVMUPJX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3567F600CB;
	Sun, 10 May 2026 13:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C4CC2BCB8;
	Sun, 10 May 2026 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421355;
	bh=9k0g05iUuWxp09AJbka1ulHptTpb/ZxjRQLmafQLgSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEhGLxDbpMUhgEQtSGsOP0KkM0cVqjCKmNJSCSeGWbBUeblNhiOl6zkfH9EqQ47jd
	 MayNaFHLc5OVSYunPiyqa6aG+yHAQOB+/CdeaRkUSOFXy7BMEzIn4Mqbeyj+4UWShK
	 qnJUpf4uVVHcSbAqARd6Tx9XNqFBtxneaFkUmE0G0GZeaC8Fg05tKHWip74ZlIn3yE
	 rsn+q543FTY9H1iwiOsK5mdlNU5DyiwBWm/qkfyWuF72ruuMEECOipfutU3ZjLNmgC
	 YtyJEWeGohId2G3aedgkauGvAFZR3GcBrgMVcglbDQmBM+PWubqBJxiUwIfuJMUPjY
	 Sxi7jv+UPkL7Q==
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
Subject: [PATCH v2 01/10] sh: remove CONFIG_NUMA and realted configuration options
Date: Sun, 10 May 2026 16:55:37 +0300
Message-ID: <20260510135546.13554-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xfihsjq5i4d9eq3hknk3eh1dcrgz44hg
X-Rspam-User: 
X-Rspamd-Queue-Id: E57E3140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778421356-419845
X-HE-Meta: U2FsdGVkX1+hEneipIQjTrLetMEznT2UR0dCeR97kUnpgNOHBfhWCMwhGoa3HKWkMw/DP1egYuExrpOd30ADnTV7JzsGSVODYs6Hwr7lS3fVPegu7Gb3IJGP9yaMgQDuANU8lYnFHlf4VU5RumyQMF4MRn6ncAKAosXvJle1BWhmf9+q81fwUZNr7a4InCetHLXRz9S+9GenN/6FraFgkFuGKW4+1FR/wt7rByO7xXvj6Iws37EK+JpG5GZvbsge/W4cpO3aVxjK4mLzZaRfMcXX+HxT99rGXcZpMEmGEHTYiaInfUh8Pe/A7J7nDTG/pjUx3TFZgPguInJ7GdQ6Uq68eN3J3bAWF7LbCJKMo8+id9RTK7iumB7K5RbTNTsa6X2YoEnxUNxkA+jFRTJ9qJMxHzEuvSQbq+qJzIXVNFsMU0TnqTdM1Gb+cd1m9rxsjfnLeg/670PdYp4SCA3bFKxFWXg/rvJ4V3cBWO4A21bjS1rZq+MJiyEHFu5AvmfrOK45UfuWb37zglcto+mHNh5ciEv2DK76mm7gfUW7V/UNkcEFOTrIKzsKY/JBu79UekE09mz8DqrEnnHUPYE+/7jYNwemH7EFUM4Vl05bu8w6lWZU7Et6vrdrhxzia+KZd1tVFLHOkbKqw1+TcwOm9OL+S97dIr8FrH5ahH7kVCG1c3OYJ3PaUrLjPkM2Pz+/hfivrbXNpfF9homk6DSoNPs6feKpEcu9mu0hPMKlHWxtiWqx6cXGcJLeSGL21/4Baam4QBlxDPwIlONjzKaUjQncwFvzwTMbwPRIYryaQde1Fs9MZ/TCIfYZClN9bLYgF+dE0JFdK5POHBndxVJdsJbrXJh7NOlZ8Kw8jioutSr9cC9Yx2TBM4UhRJbYhU5+ld4iPBchbucHA8AudfXTLZrlS3n+jOZI1GqJSnDch/fnKeXHyc58PsoUfkzSJFZNadWJlYbpjHrnld8l2j9
 T0kYWRoE
 /12XTDKGYDS0LQOvkZ3jnlOoHaLPpIFFKG+gy3vh9jHhJanoGNTCdbQDWIv/fP4WC25VtDhdwxJZ62L096ukypuNxFONkOJlLL2uTOTLP1aZbG971EzKJeVhXBfPo1pk3JO99uUUEFgAa8J4fvMUBWa2ltA5cwLZGh5bHLmjGOcxZ65U407QCEXiHiKp2+AubiUjpujpgyOXxkPOe08GohRGb1fObdcguuQMv7r0ISXYgzqqeHAB4sre2ctAmKAB9EIZ3Fqw/KbLmTgq4eny+x53x/A==
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/Kconfig                   |  6 ------
 arch/sh/configs/migor_defconfig   |  1 -
 arch/sh/configs/sdk7786_defconfig |  1 -
 arch/sh/configs/se7722_defconfig  |  1 -
 arch/sh/configs/shx3_defconfig    |  1 -
 arch/sh/configs/ul2_defconfig     |  1 -
 arch/sh/mm/Kconfig                | 19 -------------------
 7 files changed, 30 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index d5795067befa..d0ba91eba71a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -106,9 +106,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config SYS_SUPPORTS_SMP
 	bool
 
-config SYS_SUPPORTS_NUMA
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -197,7 +194,6 @@ config CPU_SHX3
 	bool
 	select DMA_COHERENT
 	select SYS_SUPPORTS_SMP
-	select SYS_SUPPORTS_NUMA
 
 config ARCH_SHMOBILE
 	bool
@@ -443,7 +439,6 @@ config CPU_SUBTYPE_SH7785
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -478,7 +473,6 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 
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
index 00a37944b043..1740a6465280 100644
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


