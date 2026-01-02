Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71926E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C113A6B0089; Fri,  2 Jan 2026 02:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC1B6B008A; Fri,  2 Jan 2026 02:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4826B008C; Fri,  2 Jan 2026 02:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3896B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:00:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 343D158764
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:00:27 +0000 (UTC)
X-FDA: 84286125294.23.73017F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88F0940006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:00:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kzLnd/zM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337225; a=rsa-sha256;
	cv=none;
	b=Pv3+I/Izc21/04qxrhhva6GXz8c1luVxiz9L1zeeHixvxKl5sLyLGzskJf/29gd1vboxQ7
	KCvsAtlQ2jPGbuEeorgdwoKcfysBjR2oP1pbJe5zGcd6BEHeQypJEgujyeq3jy08CipxLT
	1haPZBnM2TteN1V6NTR8QsJSGhOu3kQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kzLnd/zM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fzGScPL8fKRb0zTLLc43dI7u38BalcaTw4vJNG5xahY=;
	b=zATth1v0oZaTDcjQ5UObAf88NF7VHMVYxfMXcCONU/eCPkQqc4QJLGAmWR5fE14wdH2cdb
	vCHZKjpINir+SkNTyRdhUGSTW5vVW/ccmPcSO+4wyTuqM/v9DwhEKVrnYPYmMJGlASGaXO
	yr8Rdha2O2n8mHDGTEMa8/0ULKMc9D8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9720240427;
	Fri,  2 Jan 2026 07:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C319C116B1;
	Fri,  2 Jan 2026 07:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337224;
	bh=RKxDhFgzDq3YGxuar8UOMbGnphlEq9WWY3OvJ6HZDCo=;
	h=From:To:Cc:Subject:Date:From;
	b=kzLnd/zMHbNqm077UwFJpmx8HoFPlr4yUOCztzLmN9ZIQ5wnYsrJhy5QOduSZSZCu
	 ln9uSL2J89up8YOuvzJyKJyO0TdA9K2T7iLeGi3UcGq/gIK+YBe6n1UM9HyjDN81Sq
	 76SBcppamscXiSirWYQvkdTDQRv6PS/pxFFDuRGA16UKYTxA19TbqJvemVVe4C5li4
	 pveql/UPWwGhHkzRhKXcjRT1LfyID9hSKFNDryxzlL37GrYmkVlCNeoNw6tGBB11wg
	 4Q9cCOjdnixoCVxmJSjdUxwUdeNpINX7P7sMG5OTDvI2zodHKJ6nnE5Hqo24Re3kM2
	 Oq45tNJeyyGnA==
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
Subject: [PATCH v2 00/28] arch, mm: consolidate hugetlb early reservation
Date: Fri,  2 Jan 2026 08:59:36 +0200
Message-ID: <20260102070005.65328-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88F0940006
X-Stat-Signature: 64jyz9fb579ybe1mtrf4c87ia974nmet
X-Rspam-User: 
X-HE-Tag: 1767337225-163268
X-HE-Meta: U2FsdGVkX1+46u83upwVFuHR5KbWC+Ar/4RKAtuUavFy+XSQtniLR5vOtMN9VVveUVtHwu9R9KXxIXD9uD2MKQEpDE80+jH1QiaXrmaSpWX5MV+VunYhLJt2wxSQzbW/OIPMn+dIgoiJhpYONzCoZDNLBVrKsTDKYfDSsSLRbeoAG4cq6CfmNBt0k791pngBENkNEi+nS9MpAMk1LSmUq8TSqNcbawVQ/DfYv5KjH9e5pDBvBvA1VSPzeBZGLQe7y4wK/hQRUrxoxZ8Gwdw3NBqZLZF3nuaGUcFborS76LAvgqEfuaCqEdxmz3F8LuUcKZwBGfXL+7AYsp9VdlH5rJIGH8HAs+ukhU0+7n+8Rf5ni2db09IxLxdngcwkRT+jHVkrogEwb4aMyNbmDbSsGIxcz/9VCuJC+S6QJRelKU0XbX+MWA/w04V+il2UMfiNwGpwfCV/94RKyS4ZKE8ExtErI0WEcKLZUR8jN6Azn/MVwBkKEwWQ8n6r70BVCfoxyf2fhXqfm78ab1Ph7EACLNgtcie54Pezq/JDnegm1I8+vQMCnaAsd5M0iQqRuNbxbX5MNJnUzgDdE+K5TPwRYusWiE6RPHLlwSjCQibE/welTaj3nVqdyLSo7RuDX3G7Wex046PVvw9euQPQvfOKhPqjlphkIvIHOZmF6YrKaXZv9rEf5DjAWnBXfm+kGYvVKw4kaqfjXVZ9BjMVPF85buEipD6/pWM3yomDnwuyPGuBgZApz7Wrp3KGZgdGUiDg8j34qyhAcyj3wI+6UjocouOKEVA5KJ1D1iUiXlHaV3uZpHz23kZbVX+zIOPSZdPMARxywr6gCegQXqUf5M0oNKOT02JWeDSRRNIppO0lIBpXy1frRjHmXrqRau14v4fGCu5U951VIMJztP69Ujm2HOuOGe9VfEudOw74kv0cgHTdYcGSP81isiSn2uRNmtkyC620lTTNrvU0KNIC9zu
 qnvXduQo
 qlVyBD0xju5yrK6XqYUyFU3hkYw4sIvfE9RUdL6bTiYRAxReT5rU4xM9yf9UsEmGDnOCOpEuULuHbZw1FzJkVzodgT8ETZkGcKHxaJG0T0sILqKzErN0cFQM5X7dweHfbzoA40IfigvU2kRHXeX9SoDCBF/N7NfbTG3wn2J2kMLh9XmP7Hk0akT7rGFi028xNhc7ZgX533K3Lw5O/ZnJCvh5PJ1EOL5Mkfh3cmnoaWFMwRu4=
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
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=hugetlb-init/v2

v2 changes:
* move the hugetlb and memory map initializaion to mm_core_init_early()
* add Acks

v1: https://lore.kernel.org/all/20251228124001.3624742-1-rppt@kernel.org

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
 Documentation/mm/memory-model.rst             |  3 --
 .../translations/zh_CN/mm/memory-model.rst    |  2 -
 arch/alpha/kernel/setup.c                     |  1 -
 arch/alpha/mm/init.c                          | 16 ++++----
 arch/arc/mm/init.c                            | 37 +++++++++---------
 arch/arm/mm/init.c                            | 25 ++----------
 arch/arm64/include/asm/hugetlb.h              |  2 -
 arch/arm64/mm/hugetlbpage.c                   | 10 ++---
 arch/arm64/mm/init.c                          | 39 ++++++++-----------
 arch/csky/kernel/setup.c                      | 16 ++++----
 arch/hexagon/mm/init.c                        | 19 +++------
 arch/loongarch/include/asm/pgtable.h          |  2 -
 arch/loongarch/kernel/setup.c                 | 10 -----
 arch/loongarch/mm/init.c                      |  6 +--
 arch/m68k/mm/init.c                           |  8 ++--
 arch/m68k/mm/mcfmmu.c                         |  3 --
 arch/m68k/mm/motorola.c                       |  6 +--
 arch/m68k/mm/sun3mmu.c                        |  9 -----
 arch/microblaze/mm/init.c                     | 22 +++++------
 arch/mips/include/asm/pgalloc.h               |  2 -
 arch/mips/include/asm/pgtable.h               |  2 +-
 arch/mips/kernel/setup.c                      | 15 +------
 arch/mips/loongson64/numa.c                   | 10 ++---
 arch/mips/mm/init.c                           |  8 +---
 arch/mips/sgi-ip27/ip27-memory.c              |  8 +---
 arch/nios2/mm/init.c                          | 12 +++---
 arch/openrisc/mm/init.c                       | 10 +----
 arch/parisc/mm/init.c                         | 11 +-----
 arch/powerpc/include/asm/hugetlb.h            |  5 ---
 arch/powerpc/include/asm/setup.h              |  4 ++
 arch/powerpc/kernel/setup-common.c            |  1 -
 arch/powerpc/mm/hugetlbpage.c                 | 11 ++----
 arch/powerpc/mm/mem.c                         | 27 +++++--------
 arch/powerpc/mm/numa.c                        |  2 -
 arch/riscv/mm/hugetlbpage.c                   |  8 ++++
 arch/riscv/mm/init.c                          | 10 +----
 arch/s390/kernel/setup.c                      |  2 -
 arch/s390/mm/hugetlbpage.c                    |  8 ++++
 arch/s390/mm/init.c                           | 13 +++----
 arch/sh/mm/init.c                             | 12 +++---
 arch/sparc/mm/init_64.c                       | 17 +++-----
 arch/sparc/mm/srmmu.c                         | 17 ++++----
 arch/um/kernel/mem.c                          | 10 ++---
 arch/x86/kernel/setup.c                       |  5 ---
 arch/x86/mm/hugetlbpage.c                     |  8 ++++
 arch/x86/mm/init.c                            |  8 +---
 arch/x86/mm/init_32.c                         |  2 -
 arch/x86/mm/init_64.c                         |  4 --
 arch/x86/mm/mm_internal.h                     |  1 -
 arch/xtensa/mm/init.c                         | 14 +++----
 include/linux/hugetlb.h                       | 12 ++----
 include/linux/mm.h                            |  5 ++-
 include/linux/mmzone.h                        |  2 -
 init/main.c                                   |  1 +
 mm/hugetlb.c                                  | 13 -------
 mm/hugetlb_cma.c                              | 33 ++++++++--------
 mm/hugetlb_cma.h                              |  5 ---
 mm/hugetlb_vmemmap.c                          | 11 ------
 mm/internal.h                                 |  6 +++
 mm/mm_init.c                                  | 20 ++++++----
 61 files changed, 219 insertions(+), 394 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.0


