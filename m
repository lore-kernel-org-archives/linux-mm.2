Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B9E606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcej4SeG
Received: by kanga.kvack.org (Postfix)
	id B09D26B05C7; Thu, 12 Nov 2026 06:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0D66B05C8; Thu, 12 Nov 2026 06:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7166B05C9; Thu, 12 Nov 2026 06:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 781BC6B05C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:25:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 161F616051B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:25:47 +0000 (UTC)
X-FDA: 85426237134.17.83D9ADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C25F2000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:25:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcej4SeG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482745;
	b=AlGVQApgwUfxVHQyqayevdveMcp3h0S/eEKQUsX0Lcha5bnnZMirn/xJqyRDgaxCWBBTQ3
	NaRy9ChiYqk1dwDWYoWBWuEowlLKkGmvi+q9rH8T27MiP3AFFw8tctpajzAU9GtQpEwDGn
	OEwma21wQUIc5BLsEdBDOsnoi3Un1KE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nyAii04iv1TnyOOBwPCAP2EPWogK/SwQRxxQEJCCSUM=;
	b=PiTs8F7hrhrEOEcwDM3d1XWOe1rJvOrnmd1JzX8R+dtwxS4OsGs+YwXwjmdJdJp6dSkvC5
	7IekWGQ7gRZgyWRV/QXkIVcmaKJZAD1mUnh+zshRTqAmhAWOmTc+j4ppz5hd3qogrofS2o
	LNMx+oZJp9R1fBRrF/j1J3cfSa2iF70=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcej4SeG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16973639FD;
	Thu, 12 Nov 2026 11:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300D51F00A05;
	Thu, 12 Nov 2026 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482744;
	bh=nyAii04iv1TnyOOBwPCAP2EPWogK/SwQRxxQEJCCSUM=;
	h=From:To:Cc:Subject:Date;
	b=kcej4SeGNio953kxVJadAgWpMDZMpkWZMd+hDFdcbwBD6YqxOi5/s7jcM3dn5qkSo
	 JFjFFCvvWKdz0/D/1LD7AfJxJtAvjrb04S93zIylNgx499dpN+NQzloWAY3IS00PNX
	 ToYfTeKT9AfjBIh/2/JCQ81cMF4nF8JdQ1YgKhO3z3Kktfl6XBnC2mXQC5Rf4jyLim
	 a1Ar7lPvE18Ei+2zQ8KLCKzraZ0pFf7T7mxc8wFRF7N0eo1VNdCzDQiEsxnUr4MWL9
	 O/jp1yId0/ROUbt1HXRPmXoqR1BggR72fUy+EYYXcSYsvO7uJLDMn8zIE51FGdcUnE
	 GisdYH+T+tgPQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v2 0/6] mm: highmem cleanups
Date: Thu, 12 Nov 2026 12:25:22 +0100
Message-ID: <20261112112528.1116405-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C25F2000B
X-Rspamd-Server: rspam12
X-Stat-Signature: bkkb638xmqwp6sqgycrhzrozrad5zucd
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794482745-961261
X-HE-Meta: U2FsdGVkX18Ag7lOsfCDkKRYJRvqVxSPy0iu8YKQVwVMlanQzSp5K9/syD6BGD+2TV2To9COIrPB7rDeHDai9dcD2yQVpISTHIgVMBFIfmGF0wpM1G/Iz+/yxBnDaoTEqDZfc2NK5w3wvprHJsr6qfRF1WtpBoLmWiah2nT5GTUBl9edd9h9SG+GgJh9Jol3B+xl8+9mESEgegqnthIjtl20GtSjyAqvuyi9kMLyLZcxKWaYxVTo9sOg9CugevlKDUphN6JDXg5Dtssaq5JsZLqfdQ1mrgMmHlku4g7Re9RhoL/ia7QdX2hmhB0IpkRpEMcKgn+B5lxuxv6vJ5BZBxu8Up0rMGY0L5qN2duNsO62FDU/kzJ/1j2C0pe22+c8Arb8NMzVaafF3FIK614ZSdzsQRWNyUP9fXyXdahpbjeak0DtJi0SLTu/n5xpo0HajZDMwCCN0jF4XXrQyiSk9hXNEEB9Y1QV1ITfWV7N2ZJltJ+dJPfp00kx9Y5Z7H0Il6Iy9EZRYJiqI+Vxod0xsmnccjhmLx7CJYRKSUL5qaEFg47KTAINegqlkw8FE8E8MKkWY2l5yyFWzI+Uyf8KP9+766QGvyrQHLgOjhYLjphXuvDtuWuq+Ac2MtD4O13WuLzcT9OIF3Gv6OQPKWBtI/hWHkJg3oZNeWrIzSjoYwA9s1Hx5Xy8xH4JXWwtbuxOCYayTACxBXzBQIsfzaFB8ow0jit+194zU4mUqdBADf+ZyXy6HfL1sD4Pk/w9spCsW5/f2vnO4+K5aN8s2TrJBiBTeNvyqGRBBx2IaRLr6mWbNltzC0em/pm2gJym3af3IMzL2GJQeuOnXHzvteEeB01jqnoOv8Htldve0q2HnM5F71+7NQ1yS668s8075RVkeFhY+MdYNy2VZfIDsQ0QN1jtsnkCCHjrW4vGCiSIyuzvyfhMiG63QhdBjEhWxk3WSMij+MSDW5B1hQxGJ1P
 ZcgZnkxX
 nSYbdJr28pc2Okx+yaTHRMbQyAMAr43AuYcKodRsP+zk4O8KCn68Y8P2gikowrd/2X04KHaFbFcG0OrIUq6v6IS70UfYPloK9jq3vNZeLATFn6H+wwYIWjP/VAVCF79sGxo8tuK6lOBVHABvLEjvZxWge85Iv1GcoO8GyPJQNDMt2Y8DjlR6p2vkZ6N6PdjY9ZxTnozt2xJ7iXS7/PKP8waCbzFNSM1L2mnEA2vXw1cfsCllvXfpJERr2Svt6RGIAFzCc0G8J7sF1EFXpTZ6NQwceMfPxcKpoUYoZT2bGP95uXVwXVaRdnypcF6boWoP6yTEtUmz83yVffToOhyz5E9IMlgSbjVOeXsiOcjpk7/VdWt9orjXKi//7HJPt993GwtAWi6iR88VBUVydNgMxx3BHg4ORBaq4QzG5nXtHWmurT+kfOw3N5BaKiBn5qrYBi9MKzHKT2guLsgmT2l9c+lPzVmgF2y1wJPFFxzlmek8XvAWUMphx5OjNk1xemobbq8kM2V2LWvt6l3uaqKw7CR3Lcd63+rB5rrYhQSw5D1ILgSPlZ5wNT6pbLqUg2ceaTS8WHJ+MhiYdbhU8fiJ5WaMwF52ybW2m4mFhiTysIFVSGfYPjoGiO5LGEjl6Io/ISl4jcZoZ1GzFE/L8Cfy0kjdwUdYA4joOhRNxmHywFy3F+WF4XEYiZ1mMrWHuY0jocgh9CKKifJ87ainmwO/DdA/LzNOuvUHDKjhWXMc3al5uqo28+J750ouDr/5drZrVAa8Rl7twAPH6yszc9GdLQoJpMpE5Hv8e1GcGxUhZEQKDfUPO5S1VY8r8XWK/Kf3Bf7QCCzn8c8S7OfLBJSCfjuvf6Q0Kln3tgbPx28VyJLCDrR9JPSTnnAra+yMh3467RDjZS0Fix+EHiJQNBYulSH1V7I6Oi+RHsL6KkPid/fWWgT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

This is an updated series from what I posted last year [1], sorry for
taking way longer with this than I had planned. Linus brought it up today,
which triggered me to rebase the earlier patches and post it again.

At LPC 2025 [3], we got rough consensus on the plan to keep the
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

As I had to change the powerpc version a bit for the rebase, this
current version is entirely untested, but I hope that Richard and
Christophe are able to help out there, as they both understand this
code better than I do.

The change to use VMSPLIT_3G_OPT by default on Armv5 means that I could
include a patch to no longer support highmem at all on VIVT caches,
as suggested by Jason Gunthorpe. I also included the patch to drop
HIGHPTE support now, as suggested by David Hildenbrand.

The patches from this series are available in [4] for testing.

     Arnd

[1] https://lore.kernel.org/all/20251219161559.556737-1-arnd@kernel.org/
[2] https://lore.kernel.org/all/CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com/
[3] https://lwn.net/Articles/1051010/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=highmem-7.4

Arnd Bergmann (5):
  ARM: remove support for highmem on VIVT
  mm: remove ARCH_NEEDS_KMAP_HIGH_GET
  ARM: drop CONFIG_HIGHPTE support
  mm: drop HIGHPTE support altogether
  arch/*: increase lowmem size to avoid highmem use

 arch/arm/Kconfig                            | 17 ++--
 arch/arm/configs/aspeed_g5_defconfig        |  1 -
 arch/arm/configs/gemini_defconfig           |  1 -
 arch/arm/configs/multi_v5_defconfig         |  1 -
 arch/arm/configs/mvebu_v5_defconfig         |  1 -
 arch/arm/configs/u8500_defconfig            |  1 -
 arch/arm/configs/vt8500_v6_v7_defconfig     |  2 -
 arch/arm/include/asm/highmem.h              | 56 +-------------
 arch/arm/include/asm/pgalloc.h              |  8 +-
 arch/arm/mach-omap2/Kconfig                 |  1 -
 arch/arm/mm/cache-feroceon-l2.c             | 31 +-------
 arch/arm/mm/cache-xsc3l2.c                  | 47 ++---------
 arch/arm/mm/dma-mapping.c                   | 12 +--
 arch/arm/mm/flush.c                         | 19 +----
 arch/microblaze/Kconfig                     |  9 ++-
 arch/microblaze/configs/mmu_defconfig       |  1 -
 arch/powerpc/Kconfig                        | 14 ++--
 arch/powerpc/configs/44x/akebono_defconfig  |  1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
 arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -
 arch/x86/Kconfig                            |  4 +-
 include/linux/hugetlb.h                     |  5 +-
 include/linux/mm.h                          |  1 -
 include/linux/pgtable.h                     |  9 ---
 mm/highmem.c                                | 86 +++------------------
 25 files changed, 50 insertions(+), 280 deletions(-)

-- 
2.53.0

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Malin Jonsson <malin.jonsson@est.tech>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: x86@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

