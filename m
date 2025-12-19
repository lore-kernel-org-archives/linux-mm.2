Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4B2D7879C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DBD6B00C0; Fri, 19 Dec 2025 11:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257B06B00C2; Fri, 19 Dec 2025 11:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154906B00C6; Fri, 19 Dec 2025 11:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 03BC66B00C0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:16:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABCA5C04EC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:40 +0000 (UTC)
X-FDA: 84236723760.16.989CD4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D158C120014
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJ64F8Y9;
	spf=pass (imf29.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766160999; a=rsa-sha256;
	cv=none;
	b=HLFJyfdbSm7yB8sDbA7mhiYwDS7oXE4LCSfW4Up92uNjFPgESkhxpg2Z4gTdfuOIFyXX9e
	+/KZTZJFtxQJ7wE3S9UeGM3BFIcNcn4pIf6pkKr5gp46favWH8d0EXpc+kP3FYT3pqg9sx
	mYFy3cj7c13DVt9Qjti01IdJ/D4oFqU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJ64F8Y9;
	spf=pass (imf29.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766160999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YrMU+/etl5QuQSZUiyvkx0eeq2klzraORmvlUQahEc8=;
	b=AI29a3+zbdELeLnBWZ48Rig0Jww4E/JZicI/1U8sgq9AT0n0oC0Vw5W0hu0XhO/KFOP0D1
	Fg8c8pxcNgUvKO2qOGUkupNSg6k5Qr3fFMlub2g9s6ZgkHFEdICRk2G+H0MtvNn6rWsuwX
	/3JDFVU4T9FWsWBKJywNtUhZgeb+rg4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA1D740A41;
	Fri, 19 Dec 2025 16:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B064FC4CEF1;
	Fri, 19 Dec 2025 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766160997;
	bh=JUANTRw13L53ZJeWRkytCQq3wemKN/QVSV7VD+meYXA=;
	h=From:To:Cc:Subject:Date:From;
	b=AJ64F8Y9Olu9SXqmaxmT9KT0vAWaGBKrVOSF5D/0Oz74R9S7OUB4519d3Z2Lp1bl+
	 O8u/lVF5zadcmz+Jg7ZazmZGrJW4d4Va1PnH2siAZQ+9ghPxuy5UAsm7DU/mLVfq5r
	 hnksEovGij6hUHhTTaexE7/wA0zSddCm3xkBo5gXW6F07o6HD0gY/tadQ3Mrz7EbXB
	 S1D4hNCpD473VLN7fQzyjsiHa49R2e0xMzWwQkDuiqzMQmmO9guk6Kqz94jCpgzdfP
	 hn3U6Jmry9eImWjt1gJ5CsTA5x9BkByml4oyXj5zLBrNtTGtQjGdonwP5jZ7tWWVGG
	 gJZ0MXw+MyIAw==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthew Wilcox <willy@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH 0/4] mm: increase lowmem size in linux-7.0
Date: Fri, 19 Dec 2025 17:15:55 +0100
Message-Id: <20251219161559.556737-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D158C120014
X-Rspamd-Server: rspam04
X-Stat-Signature: hjbbpnbx6ruqydjby7ftzb4rgqdeh9k8
X-HE-Tag: 1766160998-652977
X-HE-Meta: U2FsdGVkX181Vj6rKzL/Pezu89u1SCuTx1NsnVZv/9xFsaCNmDk/QhMQikuYRQh418yM7AOtdDWvIKYiOxliCeXKWk5WCnxD5VXWWe23QUImqIz8Nm+Uct7r7bRFtmA1/qirjv2zlImBKA55wwGF6SIWGgckXJqo+15xpNA26XZkezbzItdhCnPjibvZe9QcJvSYfEkWm4ftcOu9TYebwZGbNys9Ju6zGx4jcorWc15VqTMH1LhfsR9q+kPyZr65Gu8NLm+izgvk0alBggWFj8fc5e/pnVMWP6JWzeqtc+7t0lVju+OaQdbdY7dBwZNLBniNClBeb2EHQ8/dU94QZYjxYr1GeFDwYntFje1I3syFbsrRlraQIxkW+u9zQKDazu0CNaNOkK8dFR321o203jr2LQuFxB6LowVJXM+E59jDWMjyUM1NcdDUWOgiQ+8bB+i1cnXh4bRFF9ledTWMBcRinOfdLARqe9BeaG3Sc9t2QvbuWodauR7JWODsbx6Nn5cM9YXmrDG25XKNj3xXZwEL0+FBslfSuzpYrN1hHe5yz10G9ctSIZsCBAr2btRoYW3gJSeafKfqctwLoANpMfrKDXWnv6FuNdYbkzK2wtbcKSSWWtSxVTBWNuPbLfSKuGLqLLIOT83/B+CkYladCYtFEd/Eqctj4O3yYDCCBFv8NwSP38LeaVO14lJa6xjvV22m3vkabmC0G03hCOWivXfeuHQ1JIv9BiXbBjHBUIezsDwNkgknSPrxMHpNaRlAzFHE0uphWUyuRrMh18cw4ik0Oz5tAtsYwLU1wo7f+vLUTsF7p2QdYp13odf4Z14evmPyt4LPd3rBIKVLOrNySly1yFdEygul7+Gg02OwIQJC/KwRHBNigh7E7bKvSahK/VIXb+j11gaEf/RITUzJB/g6up/KoivI3i1tHMKns7lPPNTlSk2Fl5z0nMWoZcr0mDc/HltwlBLpDnG25OR
 FuXAg/7R
 VB7AvIvf8ymfLreI2Bs2fbxAMv8w/HFjnxsGpRaIMv4E96YDnbXq+751dAhlbYWQHZEV39DXh3w28QQFdHWkcBvoNefRSepHz6WeRkv0DqetjAM+dfEJ7hW+OC7XO7O3iNK9jr33XwyGgW/bmtyfSAx9ut7WWCpJirKK8XXAY0i7Dv+zskZH/JgV71BlqvEQYNrii3Bf9lMbYERJV0agcXiuNn/FqlSuOKYIILRSg75oUPSLuLoj8RFCt4ZMTyiy46PntbvlfBdGuBD8zRgdPTe2+uhfM8iBNPTpO5lofdOQq2ltH/AYIRgOY5VB7VzWl+x+PrAoqx7fpvbLOKs7OmSPbGshdGToYlvTY53YBCSNFjDHXabPOYggOdK4I22cCX/tdtYuErnoZ8xItluyiX+KIrVhpwB/tygNc82eZgcrjirdQF1npaQxz3W8gMw9qLiANlHGT53Hflfmgfl0l4lbLvctOwi0/0BLwDUt8J7KVHOwj137LaSts0F0l/2l8eGTbuZaIjZYp21Cq0Zy67t0V2ithXBFdjam1h3PbrVoMW00hWVI+0/ka6m0q0ovMQwIKXXgQOYCEUokeX3+RdqzpP7J4Tp7OA+lC1DTVOgWNv0ekg4A1WNH+wHEBkWV5YVrHkOndJi/9NkO69W/wuq0J/8pRsCRoZY5NDnNv9FkB0/5FnkMePdgZeGoSvLycbeq2ogvBJj5gzLf/QyLO54pxo2RFTTq4/weGE+ZmVazA8nuFq+XQQNnT0P0Zht4ouz7phkpTfUBxR4U3OThN7gIuQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

At the kernel summit in Tokyo last week, I hosted a session on dealing
with highmem in the long run, see the link below.

My feeling was that we got sufficient consensus on the plan to keep the
funcationality present for the time being but instead reduce the scope
of highmem in the kernel as much as we can without hurting users.

The short summary is a three stage process:

 1. Nudge users towards using a larger lowmem zone with the
    CONFIG_VMSPLIT_* options if at all possible.

 2. Drop most __GFP_HIGHMEM allocations and corresponding kmap()
    calls from the kernel, leaving only the subset that is likely
    to contain the majority of the actual allocations.
    Specifically we will keep anonymous and regular file backed
    user mappings, zsmalloc, and huge pages.

 3. In a few years, also drop the page cache allocations and leave
    perhaps only zsmalloc using a much simpler interface.  I suggested
    five years as the time until we do this, but the timing depends a
    lot on how the first two stages work out in practice, and how long
    the remaining highmem users plan to keep updating their kernels.

This series implements stage 1, mostly using Kconfig changes to the
default settings but leaving the traditional behavior as a CONFIG_EXPERT
choice in Kconfig. With the new defaults, most installations that use
highmem today with 1 GiB or 2 GiB of system RAM will see all of their
RAM in the lowmem zone after upgrading their kernels. My estimate is
that instead of 80% to 90% of maintained embedded 32-bit systems, this
should cover over 98%.

As I don't actually have hardware in the category that still needs
highmem, I tested this using a qemu-system for Armv7 and PPC6xx running a
Debian userland with all combinations of VMSPLIT and HIGHMEM options. I
ran some kernel builds on the Arm guest to ensure that the new options
don't cause functional or performance regressions for regular workloads
that don't exceed the virtual address space. I also ran some tests
with Firefox and was positively surprised to see that this still works
on the VMSPLIT_2G_OPT configuration without highmem, though it gets
close to both the address space and lowmem size limits.

The change to use VMSPLIT_3G_OPT by default on Armv5 means that I could
include a patch to no longer support highmem at all on VIVT caches,
as suggested by Jason Gunthorpe.

     Arnd

Link: https://lpc.events/event/19/contributions/2261/

Arnd Bergmann (4):
  arch/*: increase lowmem size to avoid highmem use
  ARM: add CONFIG_VMSPLIT_2G_OPT option
  ARM: remove support for highmem on VIVT
  mm: remove ARCH_NEEDS_KMAP_HIGH_GET

 arch/arm/Kconfig                            |  12 ++-
 arch/arm/configs/aspeed_g5_defconfig        |   1 -
 arch/arm/configs/dove_defconfig             |   2 -
 arch/arm/configs/gemini_defconfig           |   1 -
 arch/arm/configs/multi_v5_defconfig         |   1 -
 arch/arm/configs/mv78xx0_defconfig          |   2 -
 arch/arm/configs/mvebu_v5_defconfig         |   1 -
 arch/arm/configs/u8500_defconfig            |   1 -
 arch/arm/configs/vt8500_v6_v7_defconfig     |   3 -
 arch/arm/include/asm/highmem.h              |  56 +----------
 arch/arm/mach-omap2/Kconfig                 |   1 -
 arch/arm/mm/cache-feroceon-l2.c             |  31 +-----
 arch/arm/mm/cache-xsc3l2.c                  |  47 +--------
 arch/arm/mm/dma-mapping.c                   |  12 +--
 arch/arm/mm/flush.c                         |  19 +---
 arch/microblaze/Kconfig                     |   9 +-
 arch/microblaze/configs/mmu_defconfig       |   1 -
 arch/powerpc/Kconfig                        |  17 ++--
 arch/powerpc/configs/44x/akebono_defconfig  |   1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig |   1 -
 arch/powerpc/configs/85xx/stx_gp3_defconfig |   1 -
 arch/x86/Kconfig                            |   4 +-
 mm/highmem.c                                | 100 ++------------------
 23 files changed, 56 insertions(+), 268 deletions(-)

-- 
2.39.5

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: x86@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>


