Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87413D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE716B0005; Sun, 28 Dec 2025 07:40:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C186B0089; Sun, 28 Dec 2025 07:40:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336986B008A; Sun, 28 Dec 2025 07:40:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 223A56B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:40:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C334213BBB6
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:40:26 +0000 (UTC)
X-FDA: 84268838052.24.CF79DF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A7B8140004
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:40:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JXSMQI8l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925625; a=rsa-sha256;
	cv=none;
	b=SPGC/TpZ12DDmsgyL03uCzN5hE2ngcNamcFf00yhM7fs+COMkAvz4FxrzVBDctLe1tKeLw
	bHogjTCcp3rIRDeQNZxQZbCQwMM958QB36cerej85PMn7tt++NWA1kEwzTsG6cUiJT1p+L
	QPkYBYcyayoIsqjmowUIZ6vB5GrMxbQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JXSMQI8l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IjGeO/B0++hlcCY+CNjpbur/tbcBqQHREI1B8jdkOt8=;
	b=Nowu1pZSDThpgMTZwRugOZNlaqbVWCLII62XWVdTRsVA4Ojiyvw1rvnz9keCRlfC9GTSb+
	R3XbxFybcoRQPhUJz5wiiCbsTq30wux7zgRNue4tn/28F3vseagm7e/jAfUczKGqdVpz/K
	FVYIJ4gynLNG0tSkb/8+zTsrk2FrOm8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 735C943DA5;
	Sun, 28 Dec 2025 12:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F68C4CEFB;
	Sun, 28 Dec 2025 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925623;
	bh=sXg/eGtpStxuOg/YYnTnKHLFWH8EKXy5iyUYi++8khY=;
	h=From:To:Cc:Subject:Date:From;
	b=JXSMQI8l5FZolejTk5mJv6quraHJlKmuF8twD40ZAWMOQZK+U7pyVygxOROMFe1B0
	 tr8vJLMrqIcrt++LIAENoYcVcJb437aztawcxW2Ryt48u9sfI48SxSG0pjE0ivfh5n
	 65ZIVAkGJycQK0LAPdjNnYFxj6kv4hkgMf38zWq6L2c161HN/YenbghDeWTPGysWbw
	 SFyckrxDWUHpRNZNS/PPTejvpAV5uJxzs8W19ji6hxViDYqKZqU23ZM1n/3rjhokjT
	 6QAFreOcfXfdT+EBPFCtGE3JapCzoxuwD9DDmvJ5sANYode+bX0kc9S3wM1fu5EwB5
	 pxYkAtiZ4jyJQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH 00/28] arch, mm: consolidate hugetlb early reservation
Date: Sun, 28 Dec 2025 14:39:30 +0200
Message-ID: <20251228124001.3624742-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A7B8140004
X-Stat-Signature: rwwdus9nwhr3i3jdzueq1cfgy4b51ap8
X-HE-Tag: 1766925624-822411
X-HE-Meta: U2FsdGVkX19BWHyzUiC42v3RctFcgo3vHrwyMaa8xjLvbpL6jq9Ldxxiy6E5M4HoMCgKDFtumVq+S0NKgAZ2xk9DhWyyw5HYXSWrfX4Mg1m/Dpis7dcF6tX0fIw+ekyj7E9nAqC2deXogul6hkIZ9Om9TNQTMCLg0rJF4xjh3Q+pzAEkRT9DMPTrm0KUFG0FLr2OB5PdO7zjDDxgCKRjWDBtW4ztXygDE86QMO29q2emk989DBOSv0EhsDXhyFPpEQMZ8scdi/VOlSWQh50GJTEzfAAB89AG5xnFmM1Z1IOM8ASpeHOjSWhsStCNgLw6t61eNVjD78LAUZcOzvv88OFhwu/eKBRqfFfah5UKDqzxd3miTu4in1Nf1IzLXquM8g5IKEfh7P9Sc4ozEEwQW0ajCRGDMjSZeu0h+/75ez5+nfFfPO+CBYMWM/Q4uXzDWH0vJRwR/2SXF29uO3epzOxsZbOWLCf/yalMlzNTsXx3OGkXCaTcqnf85JJAMuh+f4U48okklYVUP1MOtkTbGnQukhgeIim043y2A3c+jxPZo2rJ+4V08xJotLhtKH0EARUUt+sHPi9MlG509hJDt/7jRS8mKRKEDWCrfnmmirT1hZ35w2H36LOhhAlITPBSNOErz6wLOGkufHXw0rUfzpADyxf01hPdPZrq1kNQ2dWAwH64DsIMX1inbckXuT50BIdFI56UvEtOO4xWYxPCYUSHwBqojCIIs2NfxJl/D1/jdoCAr25P6LhB1v5zIFCHZ3aQKiKILrhcK2hgkivAdK14rJjJd2CjMrF5ehXTa3rkW2B/R1dye+Mnly5sgBBsjQyU2ltfrCWV2tnTHwef8fyZPVF1WNLWeoQfZdx28MjLu38nJrzgz7J6WJuqza5xepPpEh0LhMbazPOoOnV1N+YINIanQ7KusfyMwoeNL7T6oQWVWV4YErL1zRs9OmMSsLPgzUwILFW2XHC6O8N
 q3tqiCYL
 IgEOFBp8EEiL0WnsPPz75MnwpDG7FBJ3qVlyGvcywWHUgjow5fCQL/Fs8+DtWvn7EFnGhCUgqeM2u7HOe5Eo1jUTSWuco10FL7GmNggS05uxNkIkQVcKm8a0vefuPvzOyTRnHK+VI3uZiEmv1EpZiiM/wKsR0EQHYa+iIiZH6XdGFRw+tqEV9fNtQBeEwlDzd/dtkzVOfPvU9sPT5KirZoCyfwHJ6CdDXt20Kv/Rb/eKx1X8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Order in which early memory reservation for hugetlb happens depends on
architecture, on configuration options and on command line parameters.

Some architectures rely on the core MM to call hugetlb_bootmem_alloc()
while others call it very early to allow pre-allocation of HVO-style
vmemmap.

When hugetlb_cma is supported by an architecture it is initialized during
setup_arch() and then later hugetlb_init code needs to understand did it
happen or not.

To make everything consistent and unified, both reservation of hugetlb
memory from bootmem and creation of CMA areas for hugetlb must be called
from core MM initialization and it would have been a simple change.
However, HVO-style pre-initialization ordering requirements slightly
complicate things and for HVO pre-init to work sparse and memory map should
be initialized after hugetlb reservations.

This required pulling out the call to free_area_init() out of setup_arch()
path and moving it MM initialization and this is what the first 23 patches
do.

These changes are deliberately split into per-arch patches that change how
the zone limits are calculated for each architecture and the patches 22 and
23 just remove the calls to free_area_init() and sprase_init() from arch/*.

Patch 24 is a simple cleanup for MIPS.

Patches 25 and 26 actually consolidate hugetlb reservations and patches 27
and 28 perform some aftermath cleanups.

I tried to trim the distribution list and although it's still quite long
if you feel that someone was wrongly excluded please add them back.

The changes also available in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=hugetlb-init/v1

Mike Rapoport (Microsoft) (28):
  alpha: introduce arch_zone_limits_init()
  arc: introduce arch_zone_limits_init()
  arm: introduce arch_zone_limits_init()
  arm64: introduce arch_zone_limits_init()
  csky: introduce arch_zone_limits_init()
  hexagon: introduce arch_zone_limits_init()
  loongarch: introduce arch_zone_limits_init()
  m68k: introduce arch_zone_limits_init()
  microblaze: introduce arch_zone_limits_init()
  mips: introduce arch_zone_limits_init()
  nios2: introduce arch_zone_limits_init()
  openrisc: introduce arch_zone_limits_init()
  parisc: introduce arch_zone_limits_init()
  powerpc: introduce arch_zone_limits_init()
  riscv: introduce arch_zone_limits_init()
  s390: introduce arch_zone_limits_init()
  sh: introduce arch_zone_limits_init()
  sparc: introduce arch_zone_limits_init()
  um: introduce arch_zone_limits_init()
  x86: introduce arch_zone_limits_init()
  xtensa: introduce arch_zone_limits_init()
  arch, mm: consolidate initialization of nodes, zones and memory map
  arch, mm: consolidate initialization of SPARSE memory model
  mips: drop paging_init()
  x86: don't reserve hugetlb memory in setup_arch()
  mm, arch: consolidate hugetlb CMA reservation
  mm/hugetlb: drop hugetlb_cma_check()
  Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"

 .../driver-api/cxl/linux/early-boot.rst       |  2 +-
 Documentation/mm/memory-model.rst             |  3 -
 .../translations/zh_CN/mm/memory-model.rst    |  2 -
 arch/alpha/kernel/setup.c                     |  1 -
 arch/alpha/mm/init.c                          | 16 ++--
 arch/arc/mm/init.c                            | 37 ++++----
 arch/arm/mm/init.c                            | 25 +----
 arch/arm64/include/asm/hugetlb.h              |  2 -
 arch/arm64/mm/hugetlbpage.c                   | 10 +-
 arch/arm64/mm/init.c                          | 39 ++++----
 arch/csky/kernel/setup.c                      | 16 ++--
 arch/hexagon/mm/init.c                        | 19 +---
 arch/loongarch/include/asm/pgtable.h          |  2 -
 arch/loongarch/kernel/setup.c                 | 10 --
 arch/loongarch/mm/init.c                      |  6 +-
 arch/m68k/mm/init.c                           |  8 +-
 arch/m68k/mm/mcfmmu.c                         |  3 -
 arch/m68k/mm/motorola.c                       |  6 +-
 arch/m68k/mm/sun3mmu.c                        |  9 --
 arch/microblaze/mm/init.c                     | 22 ++---
 arch/mips/include/asm/pgalloc.h               |  2 -
 arch/mips/include/asm/pgtable.h               |  2 +-
 arch/mips/kernel/setup.c                      | 15 +--
 arch/mips/loongson64/numa.c                   | 10 +-
 arch/mips/mm/init.c                           |  8 +-
 arch/mips/sgi-ip27/ip27-memory.c              |  8 +-
 arch/nios2/mm/init.c                          | 12 +--
 arch/openrisc/mm/init.c                       | 10 +-
 arch/parisc/mm/init.c                         | 11 +--
 arch/powerpc/include/asm/hugetlb.h            |  5 -
 arch/powerpc/include/asm/setup.h              |  4 +
 arch/powerpc/kernel/setup-common.c            |  1 -
 arch/powerpc/mm/hugetlbpage.c                 | 11 +--
 arch/powerpc/mm/mem.c                         | 27 ++----
 arch/powerpc/mm/numa.c                        |  2 -
 arch/riscv/mm/hugetlbpage.c                   |  8 ++
 arch/riscv/mm/init.c                          | 10 +-
 arch/s390/kernel/setup.c                      |  2 -
 arch/s390/mm/hugetlbpage.c                    |  8 ++
 arch/s390/mm/init.c                           | 13 ++-
 arch/sh/mm/init.c                             | 12 +--
 arch/sparc/mm/init_64.c                       | 17 +---
 arch/sparc/mm/srmmu.c                         | 17 ++--
 arch/um/kernel/mem.c                          | 10 +-
 arch/x86/kernel/setup.c                       |  5 -
 arch/x86/mm/hugetlbpage.c                     |  8 ++
 arch/x86/mm/init.c                            |  8 +-
 arch/x86/mm/init_32.c                         |  2 -
 arch/x86/mm/init_64.c                         |  4 -
 arch/x86/mm/mm_internal.h                     |  1 -
 arch/xtensa/mm/init.c                         | 14 +--
 include/linux/hugetlb.h                       | 12 +--
 include/linux/mm.h                            |  5 +-
 include/linux/mmzone.h                        |  2 -
 init/main.c                                   |  1 +
 mm/hugetlb.c                                  | 13 ---
 mm/hugetlb_cma.c                              | 33 ++++---
 mm/hugetlb_cma.h                              |  5 -
 mm/hugetlb_vmemmap.c                          | 11 ---
 mm/internal.h                                 |  6 ++
 mm/mm_init.c                                  | 94 +++++++++++--------
 61 files changed, 263 insertions(+), 424 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.0


