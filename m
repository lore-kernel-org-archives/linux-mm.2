Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51CE7CD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359AE6B0088; Sun, 10 May 2026 09:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4FF6B008A; Sun, 10 May 2026 09:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8EC6B008C; Sun, 10 May 2026 09:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 028486B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:55:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1799BC1B81
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:55:56 +0000 (UTC)
X-FDA: 84751658712.01.B17D68F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BEB640008
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:55:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U8HWEcGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mNjqTCSLeCiUKIA8RiiLOo0+dRjtghFYWPFf+5Wb/zU=;
	b=bTz5SGO3LTHrB2uo6Br5hu9LSgmodN6AcCo7JnkgUM8/gDQPpOINZNoOCpiP5NvVS+saxF
	UO9TT65TBiI393cSwIrAPw+8/pJD7/f5AGeVLhIndXDJKvmjocqx3p8Zw8b8vqPAlcyh/q
	8Sj19T2vXo/iVDj84BKSfu3b4OduRy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421354; a=rsa-sha256;
	cv=none;
	b=mEmjtWGPfJG4+ciuaLE1rY2gVyTTe+24/8EuqXrfE33PGPuVIaUyJU6bJ+RWQ7WClpnVdw
	RBS91b449MDXquqwAEuZz0OX/pZrCuzrporxFe2DkFV9+5ibTspXG+V9l0n+Kkq/Qsh52F
	dzjWvV3L/HpGgxuA2mct9P3K/ksu/vo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U8HWEcGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 337CF43266;
	Sun, 10 May 2026 13:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF03FC2BCB8;
	Sun, 10 May 2026 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421353;
	bh=hEp+fB+szWATanm+aPu0c2FIrdulFwPdMHX38v8uO8w=;
	h=From:To:Cc:Subject:Date:From;
	b=U8HWEcGC+pnbmDN+tPhdfK8wlGhvesQEeyJR5DtCvsaOx7ArijakhUdvDNKN2a8p+
	 iyQNMau+dfWtmCGn9GaMTNkHNGLo906vPDOQeTpE02rqy3oYJmLCEbM0QxzoxYzcq1
	 e/XfGmmg96G2goDvBjEZXEQPVX2k1GhyIyARYWYRWeF3yF/SYTLsJopPQdJgMQYLX9
	 E9HJvIXzVu9iPXVBAeFDKEfM47gvQaL2aQpKIOFL/PQowMGADpmWuHgLJLVXlX8M+b
	 0jLw03sQuwYlSPA0yJtwXCw+SQPCmjBsZhuid6EsB9BEH3iFV8BJz3luUt1qp5a0DC
	 MEMS3L2DBJleg==
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
Subject: [PATCH v2 00/10] sh: remove NUMA and SPARSEMEM support
Date: Sun, 10 May 2026 16:55:36 +0300
Message-ID: <20260510135546.13554-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BEB640008
X-Stat-Signature: w7t38cwr9bxr76gicbw1apx36ajuuboa
X-Rspam-User: 
X-HE-Tag: 1778421354-728235
X-HE-Meta: U2FsdGVkX1/GLVw14FdQW23xwK5VB6QFt0dWett44gMxn9KLZJZq+7pobsWXF/EN/IpgFNGCYE44HIPqXlTU9kjGWblASoxTGAN631UG57qwLPOVx1uIFuW2ZRLujPip08ItGHom42znilZ4lpNMI4RjzY1Dv4EJ4b+oKVxAJT1kq/6EZA8oi+ObpYnPdmT7GC8gNVhq1TbMGER0hJUurTgWlfa8SYf/MWBDHiy1Xv6CVGDmludcH6FvK+ofGAVUN0OlEWLKVxllvZ+0HX94XvyYHmYkqTrHOmmwmLsOnpVY7byW+/w56AI7CLN/yLFwOMlTi7QaewrLHt+XhBf1NL7251LCPvUZgzd+CPx5zM/jcEFmwZiAHlbd6SAQbwWhaFALCE1dK4yP3r/aqg41/EFkxXv7aqvBggnFYvYe/ZoNhzz+tnLoxGHOPskVLDGpHYAOpoxJMCE8Ko0xXJ/bB0NoAPG0MRInsFCryET2vdce3kLm3gwsxhdmBPUHOQ48a9IzZILVaa56wLnUkfxHg7Jfp6rke4OUu6/tE8HQYfUuNiJ0OuHL3MVagVCt0xNrqbYfx9TAa5kkZ/lhOrHFB1QICkmwxAPVZuRLDz6k++rRLHCKZd6PVfPZGdGwHec19aXM+/ww6I+WZWAWkechArRq1g27czXc3igx6BQDo3o/PNr0gqc8ct3Ol/iG++mYI2r0zJH71G6KWs6WUMFqUSho8LX5l1iqT5x8wWNn4btvEW9GxLimjYrQD1vER8LZvHJsQUT11FB6ZSqrek+BuEfTeIDt6Oejv25HvvpdfBUCuKoAmOUdEvWVVazsuxxyAFWyPEZ+f3Nbg1qhfu8yi4OmlS5YtAYpomlyr8xyd2Y2ylvEbRSEpna/petqnddw1wyAA2sfVfut7sqUDVXRuZYAlDZaDXs598el0fZR/MwDMPimeUD8PuX9BVp4oKdmlOiF+G6P++06aZKZCoA
 H2SATLJ6
 4ZhN9fHwAVb6XaCBW/2r/xCS1LGG8zWQDRZzAEwDhSxPDB+/RtCSOVIU4bCrhTZ02p9rMAYAclz8OwXd/yakcjsfuYIScq7KCVMxAGjCfbQ2XJvX0bv52H6Rs8HJFl3BAKRSdtc7GDFa3hXXNtIqHT+6oNirqXNm8Kj/O/itiddy5dph1cXJys5HnNzJ9OlqjgpzgCrOL4B6+LHikKAXUZqSdAXjzPetlp336ojTjwc01rOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

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

v2 changes:
* remove stale SYS_SUPPORTS_NUMA
* add Arnd's Reviewed-by

v1: https://lore.kernel.org/all/20260413104649.852228-1-rppt@kernel.org

Mike Rapoport (Microsoft) (10):
  sh: remove CONFIG_NUMA and realted configuration options
  sh: mm: remove numa.c
  sh: mm: drop allocate_pgdat()
  sh: remove setup_bootmem_node() and plat_mem_setup()
  sh: drop dead code guarded by #ifdef CONFIG_NUMA
  sh: drop include/asm/mmzone.h
  init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
  sh: init: remove call the memblock_set_node()
  sh: remove SPARSEMEM related entries from Kconfig
  sh: drop include/asm/sparsemem.h

 arch/sh/Kconfig                        | 12 ------
 arch/sh/configs/migor_defconfig        |  1 -
 arch/sh/configs/sdk7786_defconfig      |  1 -
 arch/sh/configs/se7722_defconfig       |  1 -
 arch/sh/configs/shx3_defconfig         |  1 -
 arch/sh/configs/ul2_defconfig          |  1 -
 arch/sh/include/asm/mmu.h              |  2 +
 arch/sh/include/asm/mmzone.h           | 42 --------------------
 arch/sh/include/asm/setup.h            |  3 ++
 arch/sh/include/asm/sparsemem.h        | 12 ------
 arch/sh/include/asm/topology.h         | 13 -------
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |  5 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |  7 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |  5 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |  7 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |  5 ---
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   | 18 ---------
 arch/sh/kernel/setup.c                 |  7 ----
 arch/sh/kernel/topology.c              | 12 ------
 arch/sh/kernel/vmcore_info.c           |  4 --
 arch/sh/mm/Kconfig                     | 29 --------------
 arch/sh/mm/Makefile                    |  1 -
 arch/sh/mm/init.c                      | 24 ------------
 arch/sh/mm/numa.c                      | 53 --------------------------
 arch/sh/mm/sram.c                      |  3 +-
 init/Kconfig                           |  7 ----
 28 files changed, 6 insertions(+), 272 deletions(-)
 delete mode 100644 arch/sh/include/asm/mmzone.h
 delete mode 100644 arch/sh/include/asm/sparsemem.h
 delete mode 100644 arch/sh/mm/numa.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.53.0


