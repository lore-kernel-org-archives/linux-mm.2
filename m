Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000E6606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BWGzDCEU
Received: by kanga.kvack.org (Postfix)
	id 19D6B6B05B0; Mon, 16 Nov 2026 07:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1766D6B05B2; Mon, 16 Nov 2026 07:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091A26B05B3; Mon, 16 Nov 2026 07:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2AEB6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:48:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD2E312063F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:44 +0000 (UTC)
X-FDA: 85440961368.28.5FF86C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F362100007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWGzDCEU;
	spf=pass (imf05.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833323;
	b=rpVw1fGdQKIqFq1ayWFMzjfL/ODdQlZXE6BqheQejnLSh4dzJ3/lp4j2PsAvFTrQyX8hqC
	plPOSEjZXuRFlPuvMAir2FYzRWmCV/1iqhcZLs15icVVcHeqa88TgiPHkE7n7yGU10mIwc
	fadSxZgM78qRm73QdP4jEg92wcHCAXE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWGzDCEU;
	spf=pass (imf05.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cHwboy1N0wyypiMyN1HkFeKrDxUYIhWj1+v6URlvrGU=;
	b=lhox+kt+0LRBkbB6s7vJoLYWYIAnE3k1kyk++zfzN/Lgxm/4PBSoOpTq8wnX5W6DnG3yl8
	CbTIXylNRNBvteNMYkMCE8LMyOQGV+a7+uUo5ivUm08rzWcbys+gFxV+LzYSg1e78XP2XW
	7O7aWPrU1nW5FMRXxipmUZ9qAUNSIZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAA34039F;
	Mon, 16 Nov 2026 12:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF3E1F000C4;
	Mon, 16 Nov 2026 12:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833321;
	bh=cHwboy1N0wyypiMyN1HkFeKrDxUYIhWj1+v6URlvrGU=;
	h=From:To:Cc:Subject:Date;
	b=BWGzDCEUKXr34v4C6Dho8x9jma12SCGGbn8RtpnP3qX45i9pqa/vtpEIy71wryEv4
	 IDWOk5oa3ya3mNqxy+6UT4i70X+uEAWGil+v6ZahGuzUlfN6VIcqcuIrhrZIOo/ekd
	 EV+YXnEY6Cul1fybgHnM8yGocWvdjRFqe1EMtnbAU3dHGFdRStQauSRRT2AvWZgWgS
	 +CxxyH2MmUe3+drsDMXbdVpGvCSVANx8OaC9LoJ0Ma8LURv8oUrYUeQ3kK++srZffw
	 nHuLhWyZR7lw1gAqOMkhLwFNYtFfmVEA6Wq+X7rs6NMUj51o4mJUC4azDZ6J4FQ1Hj
	 5dUfR3eSzgLFA==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v3 00/10] mm: highmem cleanups
Date: Mon, 16 Nov 2026 13:48:22 +0100
Message-ID: <20261116124832.662455-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: prem5ubnh8yeh4ca7jxroox58cjuz3td
X-Rspamd-Queue-Id: 2F362100007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794833323-290281
X-HE-Meta: U2FsdGVkX1/BU+BmF4pbywIgJy6ApkiNnDv+mZAZY++3O7tcftW5c8QE1mZZEgegbO6sKA+nsV8mBq+nphVEgvlEHSpnqSNJCg2zSZ43RVURt0BYWmrpKhfLaZsTlNQZxiAoj1E1wi8gnHS0RcYGsAV3oJ0TSgDmQbTWkymGbHpKEPU1X7Jm3jzzADvBHRTms6ZdYRkRIVzbjCUSakgeumnwJ1zRGAP4VKYZ/ZSnoWAgAD5kt4LpYkvb0uwugd4jhlVaKWYg4oLLyzJYB5c87uBu0DORxZAhnFal3UNoVQhAOeVI1pj4N6Yp68mHo7FMjJsT+NFS+sBvoHThW3Io9Dcj9v3YJqnBkR6MLNX5JEX573sUbHXr8C8tFQVtGDZ3jZaTcMg8GDAUlb9j/SeMj54dhQwgW+ogSHvQ4VGqWTG4aiuByDF9HRlzRGIVjknvZgdwz2dP3vgSrOr6RBSRH1A59u8l7JPMNQzSsyJaackJNbLdWUjWaR0iYKPwYn7QXGAX+9osEmcFa16LaLts1T8ur8aatG4bEeKjAYsLxw6xRb34Ia+ZQ71qrBbDXC6S8Ed7l/b9MA3tdT+2fWDNWUfGdYxKOMEoK8EvaUgWvwUkLSwl6T+yX5dNJcCVSfZnwqNTDvIIe+BT0eZ9Y2o5pTb7ZlcAxQbLOGJ6AW+TBGY7Qr9NI5fYCtMol88x8td1MD2qtMjknlczHO4J5pIxHpP+u80x/nFVIYW/jcnqBH0kOfK3w4UpaZMLoI+HpLp9EdajVoRO6goI9kAaAo8Jcqne5W/9Gu3mjLhM8X/mfyxu7dO1uDQVPVzzXaYQR1mlTHUfg6x8C3izRzRGdCg89bqRj+5asv+hY01pQUoI04bW7lprhptbthJEbgPiZ2vx40tufj9I6zUkOO9J+JiOygye2ojBNKBM7wz8RoVPN1baTZGHoLl9LA2Nh7DdAtrVt17pfPbU0egaxBEG9Pj
 l6iwR4KG
 H+S4vRBdfDF2yH8tn2J9Ply0shT954lvoDjh8flJvEACNFF+6hAfeB/A/qiML/moh074DwXmT6aMzwY3IOitPOXmZsFxF3Eag9NJ3spn3TZaoHWi/SVAQOk7IofMGHumyvBuQ1zc8E0kGioIQzp/W0HZ2GBbhEGXEKz+JFZ4amPMZd5RbuHjOrpoPoyBwJv0TYR/luDMYxpgtUBm/Mdo/hlkm+gP5qyAmLBzcz8gXDo6LIAwgIXcFkOWEEyobeZYnSswCF5Q3PQ+pGIRqx1hv930NVzJahOU2OC+M5K5D0n9Mg3DFYbfZqwG+jQWcna83yJ4zOC8qVfq1NX0Aax5UuE9y07lfuJc7s6ThZiKm2J5pAPjvCn7saWzzIq6NF9Yz1eF3N9xzuo1rDPoTZY0ifD37E6KYfMww7O2qglZTOvwKylk+8SwtN8zWW6c1NC2obYoWQw4K4JatTPIQUqH4XBNSJoLVffh2VXElnNKdMtkOJh7ConCdnBeErAJkuQwBDKC55dh1uQhnoKxJWaigKj+TZUDlarQ/LXRj/eOfcVNwrWSCTdzGBAa7FBA5xqixERn70x6+KEITWg1jfWAu0ybkw5IgTXe5odztUyg9ddJhPNhDtsyZ4yqB9yNtOfL4L88V0MdwwWpGWFcT6xbOCEfofleuQ0jM6YybJWXsoI2kMw58MTK8vrxfjYOSNp4snH2EXncE87pZRbxSdVBVV3eCwLB03wdJG/SFMIFSQOq2QmZvwmOQ1Ma+7QWp2NawhPglUH3cfnwKBsF7U8fIhCqX05d+Xs51zEqZ/q0gkU9yRixjfeg0rBLcSe77HocWsia4la7jOkIJQpc8nHnGyMTA9x1+u6K/vr9prokkZX/nArMNWP8IVh4Ldo/scnLYeynt4B7Ivt4LNqxHqcYvFKPu4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

This is an updated series from what I posted last year [1] and
last week[2].

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

The change to use VMSPLIT_3G_OPT by default on Armv5 means that I could
include a patch to no longer support highmem at all on VIVT caches,
as suggested by Jason Gunthorpe. I also included the patch to drop
HIGHPTE support now, as suggested by David Hildenbrand.

The patches from this series are available in [4] for testing.

Once there are no further concerns about the contents, I would
suggest merging this through the asm-generic tree, as it touches
mostly architecture specific code and that is not easily split
from the core mm/* code. Merging everything through the mm
tree would of course also work.

     Arnd

[1] https://lore.kernel.org/all/20251219161559.556737-1-arnd@kernel.org/  # v1
[2] https://lore.kernel.org/all/20261112112528.1116405-1-arnd@kernel.org/ # v2
[3] https://lwn.net/Articles/1051010/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=highmem-7.4

Changes since v2:

 - Add preparation patch for Arm PXA [sashiko-bot] 
 - Add preparation patch for powerpc32/kvm [sashiko-bot]
 - Fix Arm ARCH_MMAP_RND_BITS_MAX calculation [sashiko-bot]
 - Simplification for pte_alloc_one() [Mike Rapoport]
 - Drop stale references to highpte [David Hildenbrand]
 - improve __print_bad_page_map_pgtable()
 - Split out Arm changes for CONFIG_VMSPLIT_2G_OPT

Changes since v1:
 - rebase to v7.4-rc
 - add patch to drop highpte

Arnd Bergmann (10):
  ARM: remove support for highmem on VIVT
  ARM: drop CONFIG_HIGHPTE support
  ARM: pxa: support arbitrary PAGE_OFFSET
  powerpc: kvm: allow flexible PAGE_OFFSET
  arch/*: increase lowmem size to avoid highmem use
  ARM: add CONFIG_VMSPLIT_2G_OPT option
  ARM: defconfig: turn off highmem in favor of CONFIG_VMSPLIT_2G_OPT
  mm: remove ARCH_NEEDS_KMAP_HIGH_GET
  mm: drop HIGHPTE support altogether
  mm: print pte in __print_bad_page_map_pgtable()

 arch/arm/Kconfig                            |  27 +++---
 arch/arm/configs/aspeed_g5_defconfig        |   3 +-
 arch/arm/configs/gemini_defconfig           |   1 -
 arch/arm/configs/lpae.config                |   1 +
 arch/arm/configs/multi_v5_defconfig         |   1 -
 arch/arm/configs/multi_v7_defconfig         |   1 +
 arch/arm/configs/mvebu_v5_defconfig         |   1 -
 arch/arm/configs/omap2plus_defconfig        |   1 +
 arch/arm/configs/u8500_defconfig            |   1 -
 arch/arm/configs/vt8500_v6_v7_defconfig     |   2 -
 arch/arm/include/asm/highmem.h              |  56 +----------
 arch/arm/include/asm/pgalloc.h              |  13 +--
 arch/arm/mach-omap2/Kconfig                 |   1 -
 arch/arm/mach-pxa/pxa3xx.c                  |   2 +-
 arch/arm/mm/cache-feroceon-l2.c             |  31 +-----
 arch/arm/mm/cache-xsc3l2.c                  |  47 +--------
 arch/arm/mm/dma-mapping.c                   |  12 +--
 arch/arm/mm/flush.c                         |  19 +---
 arch/microblaze/Kconfig                     |   9 +-
 arch/microblaze/configs/mmu_defconfig       |   1 -
 arch/powerpc/Kconfig                        |  24 +++--
 arch/powerpc/configs/44x/akebono_defconfig  |   1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig |   1 -
 arch/powerpc/configs/85xx/stx_gp3_defconfig |   1 -
 arch/powerpc/kvm/book3s_32_sr.S             |   4 +-
 arch/powerpc/kvm/booke_interrupts.S         |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c            |   3 +-
 arch/x86/Kconfig                            |   4 +-
 include/linux/hugetlb.h                     |   5 +-
 include/linux/mm.h                          |   1 -
 include/linux/pgtable.h                     |  13 ---
 mm/highmem.c                                | 100 ++------------------
 mm/memory.c                                 |  21 ++--
 mm/pgtable-generic.c                        |  25 +++--
 mm/userfaultfd.c                            |   6 +-
 35 files changed, 104 insertions(+), 339 deletions(-)

-- 
2.53.0

Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Walleij <linusw@kernel.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Malin Jonsson <malin.jonsson@est.tech>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: x86@kernel.org


