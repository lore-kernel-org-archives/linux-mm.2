Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B0E0C61DE8
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046166B008A; Mon, 31 Aug 2026 01:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12706B008C; Mon, 31 Aug 2026 01:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA5D6B0092; Mon, 31 Aug 2026 01:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A339C6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 349AAA00E6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:38 +0000 (UTC)
X-FDA: 85160472516.14.45378F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62635160003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BqfKECU3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+sjajWrfj2wM9zCU9qb6V0Zy3xK1fZ/kgY+W3FSBiiw=;
	b=Xpd0jApZRHUC1Ns/lRnMeJp7/sGjJZ7XzBKLbyiS4uLj1/AHl71Ik9uLZSJIFVCS4eI+Pu
	UAHoMOr0cxY9ngtBd1jO8WBB9bRJrSh/mLYVkg4CLjDLtuxdwYREsUbS4lGvHECvCEwBwK
	LONL20LfBFrNM3F5NrqcO67r7AwdMbc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BqfKECU3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155016;
	b=T93ugTwUVZDrxnxyD0B2qU2nI53QPwsjM1/4pny4fEC7Zj3OAbjq/j5t9oBkxFdVKmOodR
	Ud7EtVaVjIF6CpECGJCMf7OsfDalXHeR6vTL8VBAu13GpjsCYeODQ6V+gCFcMr1ZT5FAjM
	xLhqnS8m6Obiub5DvDnIqlE8ta733Mw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5511914BF;
	Sun, 30 Aug 2026 22:43:31 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B2D73F85F;
	Sun, 30 Aug 2026 22:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155015; bh=QKfwc4zep2ayth9wQau6lhc5F2hRk7N0saDoBUOnEqo=;
	h=From:To:Cc:Subject:Date:From;
	b=BqfKECU337E7qsCYRaYZ551VunTXFknuFyCaLMIudB5TVUVPy9lcqXU9kDceG55xE
	 3k/uh1THmhFNmRViRgc/nMwvFC4fkZ8h2ai9fhKnQX7Hczm+O8oU7JE/xv/FBEfkCv
	 3sSZnJfiyZzjdo3E1Ch5J2JPk2brrk5Zet6wHHlk=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: samuel.holland@sifive.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] mm: Drop pxd_ERROR()
Date: Mon, 31 Aug 2026 11:13:22 +0530
Message-ID: <20260831054331.625505-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62635160003
X-Stat-Signature: 8b1tyueikqc1b4joakar8eq4b9rggy7g
X-Rspam-User: 
X-HE-Tag: 1788155016-136534
X-HE-Meta: U2FsdGVkX19QlpB9M7E0fg6a8P5Gy2dr2gQ1KyRqTDMov87YvP6+GKcOpDodt4F87fS+Rl1KkckkElhkf82rv3oCGJnBlU8uHXAwLKiNniR8idqc8r9ZmPqxMgZo3g5d7rbTtMrS9sKNZgZO3S/0IF7TZ/aTTqYLtKn79yBZuC6jSDMIb65rTJUPUcpbrN9sFMql85uKAWDoRcbjOjO2i/bH1qvvdJl2swSvgMKSTLV3NSjo64uKuUfl8tRXShLfVbdYUzJZNcR6QcxW9ZGwTZVv9VZjb1epoDlhXjUq52Ja001OSFFmFOAhQbPYxYePCmW1P09WzqWnlB9+D0LIt84Cwf6U4iWLtD90BxFzN+vHKk9eBaQul2WrlGFRJFLk3Ut78d0JuhLWK9Hk6VHIPaA1Sfse3TWTtFrCo55u+zKSo/PTsu6PIIsNo/zO+xYFiTZ8v07oTI8orSvfCKmT8YP2ulQcnlhkPRuzDVZyhRtQaMmXRCNlGom4kpLp8vSpe11iXWMII/MyfYoub9vosOHsMhQzNDdyhSOiA1jx1BVm1RaECutn11lLO6izqwKs++dY2ZhjezMdLGrLCkVD8GsQjVApm6tNQ84k5N3NCzW5pNdj41igZtnl3JqGwAMtVDZMOEXBv8aolU9zyTaA/Ek4xoweAVtAkOuCpLGyhryfl+fuDShAkWp4zYh42nIA+MMdB+uu+xodkBSUtHmwbQWrR8tA2km2u5F9t0oZBJaXiSDrB3QuJwPvIGHrkGQ6sadAq5jGO/wBy7b1eW1pyMbXKZ/gfsEX4ohZCxA+lTmxq6RsAZ1vKVGpRoR2SDxUW4z51kBTkR3/g32jEyrufiBfc/8tzUTCaoRDnssltzdQPd3JfDk5iz8JqYFkJoaWN2/0wzJqCfOJdcSj8NrvY/mlur3CSe0u1QblfkxfdHDBOTFNSryCsnTSP76G+neOAxSZpzMPpmA6bJf3xw5
 SfXukRu1
 Rr5hs6o28Dc+myEQaWjpL8upZoRZzRwjBWMWHnYlk/SXlBOKJuMuPPJT7/Tsx9BtB3rGoFGF1OtPF3UsuvJguvu+Tb1yvKEJ0bFVXSzeBEirVd0DF2fuz2DX833ZninXkheFL8P4R7cfHOxIRnaQeeod3SpsCO6/KtxAjS0ymWvqXQIM0NptbVqJ5kZuR30ILdJGlH8h+7An/9Vv4kBTkquQp1L326Bt7O3umuTquu2SP+frf7K0G3IQzQawRmP5fEAdhqiQ1YxJEMXtq9rMjyw1+gQQqdmacW/DfLl6dHu8m8OIsmZSGngVondcZxQc0gK/UdyRhqHvn5T+YrKg2SwPAYV/8XXCpQ2Th6EpI+x2pFfBKxOtthclJC+pzH3U2OkXD3FQfPp1yPBFuRwzMb6ocIsdi7M1X3peAlgCkjVitftrkeixjvqa7gfsKcZm9kksPMkl5vuAoKaHzAIgdIHOIQQ8t02g+kutJq0Ocu+8c4OQcrALA8d2cRjbM+J3bhwuH6dBj2UEtR/3TLpfM/s9UAgU/6fCZKFGwb8gegSSxCUCX4SGFXayIx97iHtocdTBN8xzzLKDHi5l84Zd/gjcX8f39m3G5yYgVvGLtAS0/iWIfOJ9YX/OKRVV+5UhF0MUqB53jYQbZDkU7F6hQtGTC+aXi0vMi71fakXkRC1LyFq3PYU3z2OTOfyyO2m8NBYaK0RqadzrCD04K77oXb1w8Yu5c4o9jwmXfGFU7HmpOXmP/kNluG+0NYjj47Ocp97l+UQzifvjp2SZEVkHVDzqtCrvwbgHdKorsH4sOS8dqm+BwzhqbB8jrN7IO/X1J9d6H+emKa+f3JyII1JE5yZWqpoWPmrVvmTy3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pxd_ERROR() macros have been provided by all platforms, which are very much
identical and can be dropped off completely if these pgtable printing could
be moved to callers in generic MM aka all pxd_clear_bad().

But first cleanups and re-organizations are required in some platforms that
are using these macros internally. Afterwards [pte|pmd|pud|p4d|pgd]_ERROR()
macros have been completely dropped from the entire tree.

This series is based on v7.3-rc1 after the following patch and has also been
built tested on multiple platforms.

Changes in V1:

- Moved ptval_to_str() and adjcent declarations inside <include/linux/pgtable.h>
- Fixed type s/ptrval_to_str/ptval_to_str in [PATCH 1/8]
- Dropped PTE_FMT from riscv platform
- Added all tags received

Changes in RFC V3:

https://lore.kernel.org/all/20260818040041.1891769-1-anshuman.khandual@arm.com/

- Moved ptrval_to_str() as header in a separate patch
- Stopped using pxd_ERROR() in generic MM in a separate patch
- Dropped pxd_ERRO() macros from all platforms in a separate patch
- Dropped print_bad_pte() and also cleaned up set_pte_phys()
- Added some pr_error() messages in __get_pte_phys()
- Cleaned up error messages and used ptrval_to_str() in platforms

Changes in RFC V2:

https://lore.kernel.org/all/20260811042119.3652929-1-anshuman.khandual@arm.com/

- Added clean up patches for platforms with existing pxd_ERROR() usage
- Dropped __FILE__ and __LINE__ from all print sections per David

Changes in RFC V1:

https://lore.kernel.org/all/20260806080639.1916749-1-anshuman.khandual@arm.com/

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: linux-alpha@vger.kernel.org
Cc: linux-snps-arc@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-csky@vger.kernel.org
Cc: linux-hexagon@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-mips@vger.kernel.org
Cc: linux-openrisc@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-um@lists.infradead.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (8):
  mm: Make ptval_to_str() generally available
  mm: Stop using pxd_ERROR()
  loongarch/mm: Stop using pte_ERROR()
  parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
  sh/mm: Stop using pte_ERROR()
  sh/mm: Stop using [p4d|pud|pmd]_ERROR()
  sh/mm: Stop using pgd_ERROR()
  mm: Drop pxd_ERROR()

 arch/alpha/include/asm/pgtable.h              |  7 -------
 arch/arc/include/asm/pgtable-levels.h         | 11 ----------
 arch/arm/include/asm/pgtable.h                |  7 -------
 arch/arm/kernel/traps.c                       | 17 ----------------
 arch/arm64/include/asm/pgtable.h              | 15 --------------
 arch/csky/include/asm/pgtable.h               |  4 ----
 arch/hexagon/include/asm/pgtable.h            |  3 ---
 arch/loongarch/include/asm/pgtable.h          | 13 ------------
 arch/loongarch/mm/init.c                      |  4 +++-
 arch/m68k/include/asm/mcf_pgtable.h           |  6 ------
 arch/m68k/include/asm/motorola_pgtable.h      |  8 --------
 arch/m68k/include/asm/sun3_pgtable.h          |  7 -------
 arch/microblaze/include/asm/pgtable.h         |  7 -------
 arch/mips/include/asm/pgtable-32.h            | 10 ----------
 arch/mips/include/asm/pgtable-64.h            | 13 ------------
 arch/nios2/include/asm/pgtable.h              |  7 -------
 arch/openrisc/include/asm/pgtable.h           |  7 -------
 arch/parisc/include/asm/pgtable.h             |  9 ---------
 arch/parisc/kernel/pci-dma.c                  |  6 ++----
 arch/powerpc/include/asm/book3s/32/pgtable.h  |  2 --
 arch/powerpc/include/asm/book3s/64/pgtable.h  |  7 -------
 arch/powerpc/include/asm/nohash/32/pgtable.h  |  2 --
 .../include/asm/nohash/64/pgtable-4k.h        |  3 ---
 arch/powerpc/include/asm/nohash/64/pgtable.h  |  5 -----
 arch/riscv/include/asm/page.h                 |  6 ------
 arch/riscv/include/asm/pgtable-64.h           |  9 ---------
 arch/riscv/include/asm/pgtable.h              |  4 ----
 arch/s390/include/asm/pgtable.h               | 11 ----------
 arch/sh/include/asm/pgtable-3level.h          |  3 ---
 arch/sh/include/asm/pgtable_32.h              | 13 ------------
 arch/sh/mm/init.c                             | 16 ++++++++-------
 arch/sparc/include/asm/pgtable_32.h           |  3 ---
 arch/sparc/include/asm/pgtable_64.h           | 10 ----------
 arch/um/include/asm/pgtable-2level.h          |  7 -------
 arch/um/include/asm/pgtable-4level.h          | 13 ------------
 arch/x86/include/asm/pgtable-2level.h         |  5 -----
 arch/x86/include/asm/pgtable-3level.h         | 11 ----------
 arch/x86/include/asm/pgtable_64.h             | 18 -----------------
 arch/xtensa/include/asm/pgtable.h             |  4 ----
 include/asm-generic/pgtable-nop4d.h           |  1 -
 include/asm-generic/pgtable-nopmd.h           |  1 -
 include/asm-generic/pgtable-nopud.h           |  1 -
 include/linux/pgtable.h                       | 14 +++++++++++++
 mm/memory.c                                   | 15 +-------------
 mm/pgtable-generic.c                          | 20 +++++++++++++++----
 45 files changed, 45 insertions(+), 320 deletions(-)

-- 
2.43.0


