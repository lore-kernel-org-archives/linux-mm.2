Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFF8C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24CD06B008A; Tue,  8 Sep 2026 08:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE346B008C; Tue,  8 Sep 2026 08:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5776B0092; Tue,  8 Sep 2026 08:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D72CB6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:32:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50A72805D4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:32:52 +0000 (UTC)
X-FDA: 85190534184.07.405BF37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 946F42000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:32:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFYrYtjg;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/NX9zTuBJprAZbDQG/MM/JRatg67RVZV2hcrO8X3ERc=;
	b=xI9BkKurN1J0318vPDPHJUMxwRb2he8kQXRmwOVXi8LyhkpsXD+JTV89dLcjLhLTCk+Bdx
	xgEOcchsufxbiIbVwLLObyqRrpNRPeP7STnqS3GAJgHIXsEPUf7MlG9yFdgEviZYrqkk5s
	M67u2jdS0Y1GyYu8dcsNAcoPdwaf5qU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFYrYtjg;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870770;
	b=X+YLJvy2BvLIHxhHIIbALCoc092f9Gmc3ExgcA08jvAxhmnM+zkWSs6fpXeem+2fJZCfTD
	6ju0p5opyGeEVDmsRvH2uX9qYBhypeF7afmsnqflONOg0gQesLDKrap0McsJhw91gPpX2N
	pQjRbS/8m4Ladjl6gIH2DKuU4phLF/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAE44601F7;
	Tue,  8 Sep 2026 12:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571151F00A3D;
	Tue,  8 Sep 2026 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870769;
	bh=/NX9zTuBJprAZbDQG/MM/JRatg67RVZV2hcrO8X3ERc=;
	h=From:Subject:Date:To:Cc;
	b=WFYrYtjgPpbr/hwidvATlDVODrjSwP+HWI8Kl7S9xrf2WgC3hQDP6khQr1nMFslTq
	 TbSm406p2qpnuADTGC+6tE/nTPxYxMVF+4OFtbIonotcYcHnM0FVW7CQcNxhAggcUy
	 RUdZFz3Rk4EOtD42o1C7QsyTeI5jB0+a6xBDK24YSnjooKgQkR1yPg/GDD4Dz5VziZ
	 BxufFpXHgn4IVJSiax8MYtTD99s3cRPFgRvhIRmYZXTK3A3NSD3NKUSHwY+wRDWw4x
	 AiTr+io3dyDrqPy5gGGEQnV2GsPbu53vfgOvd1ivuOT3ziJeq3xMIIW4RCuGKGmMx3
	 Ugtds1cv924RQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/12] mm: make userland page table freeing RCU-safe
Date: Tue, 08 Sep 2026 13:32:09 +0100
Message-Id: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNyw6CMBBFf4V07Zi2PFJd+R+GRVuHMmoKmQLRE
 P5dHmuXJ7n3nFkkZMIkrtksGCdK1MUV9CkTvrUxINBjZaGlrqTJFbAfobcBB+veCA0jUgxgClc
 5NLlELcX67Rkb+uzee31wGt0T/bDJtkVLaej4u4cnte2OxkX+a0wKJJRFWVmjvNFK317IEd/nj
 oOol2X5AezF2aLNAAAA
X-Change-ID: 20260831-rcu-pagetable-freeing-84b6be830e20
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8463; i=ljs@kernel.org;
 h=from:subject:message-id; bh=6eCzrD026JWfYI3OjzZFVyRbHq3AG1HN1FE1U0t3tyE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMIRPP602XYgnvmNS5vJCMbXi/Y9CAn9+rTILzeg6J
 7XCLf9QRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbiacrwV1w7LODHtGezX1a+
 O/iahycpqH6l3pK+3atiru6YLOVywZSRYb500p4Ln7ZVv/qQpiCk9ija67Fe34cr3Wdu5kYzTTl
 VzgYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: mowaxh6z3thw65y5in3y3iut6py9p9sc
X-Rspamd-Queue-Id: 946F42000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1788870770-454370
X-HE-Meta: U2FsdGVkX1+ajevacPUyOYPRSURvkDsdh6ySkdA16/ZKGSWyX2ESYb69zfW2C86LCvkHwvY6tgg7YAhf/YRLqXnDIZnjb6wREBkpzFW201p/0NtNjyXPEQYS0cZjBTbuFn1Xw9JtjUeveFRIxfkRpu5m6MQ0eXhU5s94DR4LsttSFP9kZUp5hrudozkhHvl1A3D35SfTJxqBcyUlTzmrvMT6LF4csEuul/jQTjq8uTAhmFDz3eRpqmV3DAPcKCX7RSSVDHhgTa0KKZu/Ch75lAENhoF0dOtZL9SLNeotTsF6MYwEbbcBD2xpuTRaIKYf/zCEe/9RDUz/9YGP7KIb05zdhxU5t6YM7Zmu0nkgRIgTCZIto8G7n7y08FWcIiYKyL7OV3xmAb1rHvmQsnRTibET4qRiTOPOslexFmptMODPlrwbIS08IIcOL+Yid0t0Rr2mOcdZlPE1TME/Q4/uH8SboRP9I/joUwY96LUVqaeHEJtAwHuAeCt1o2FOJAsNLQPJXw8CLch9tTVi9U1Hu+yZsa/6o0vzhfN/LgT/9jFUnCZxa/JFJGCJ8EXikmGmrOAL+Km2B2NRMZQWj4xRD2ev6VBo4KiJVNcnVSOniewqio+jtevDhLQY8q/w5868dfuZl7DNqtp44cT1Kov4sk7Iq7EW1GWcHU5cnggfFQBCfKUV5Uhri2UHCwgHvdyCz3QvXc60VwnAo5Y0lT5gFGFj+/jwWqZfPRJ7mjTuwHD/sHgyjSM8F173mI7EJpZxkSIJWEPWq75ag7h2o4dVpst7dUDY+iGN6PwjzUD8RuXbIP+4qvv0cR54zdH9TxGQ5U8LWC3+cD9g8/HpF/MLAHGjYgd8pTnVhau3Cy4D8eSfiVGwrQ68n3ikHyWCqOxgRXohqjJM34NOlNjJ0ZpXROahMM90PrMuBP2UmrpTEDrv2TwCNSGsBBoVK/RogUm1H+f5FOaVf6g7o1uZWoS
 E882mwEE
 situ1qQ41V1+XCSBAWTpKZo4GW23hs0ZS4spcaDUF1CsqpDqQxEYeRczbiU5dpPXjOr3bGvnRWaQWtvUy1ynwsJ5VYQnwcyFPWosGbQxUdLQg8LnDhUaOwIo2gS7jEb86ZjpVUGgsV/KGkuKvBO1xvuFr8OOssk6H/U3nKGHwVCSohxn1fU4BRjxbEQn52bfH91RrQVVQ5QDTaHxP4kiP/kHb8/Ia/0/tujk+KZu9m2m4xPeX+xpkICfRZ6oCZ6nqXwQbI05t9x9uqxO2wEFRv3goQDbZFAjt2d+xbAYyju5nEqo+LRGGWQQSNQBuKQVLe+TKasfgheGdPXXQch3U9kMV0j2QfyXfrNHL4HxqwjKnr5Y6dVziCl7WKBIHwQShjKhN9XLJhrBdIFhdcOyHiKuAYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The majority of architectures in the kernel defer page table freeing until
an RCU grace period has elapsed, this series converts all remaining
architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
altogether.

This is important because it enables safe lockless page table walking under
RCU alone.

Doing so allows for reduced lock contention, avoids lock ordering concerns
and enables fast, efficient and correct page table walking as a result.

Additionally it removes a bunch of code and architecture-specific behaviour
which is always a beneficial thing to do.

There has been much recent work on this:

* In 2023 Hugh Dickins RCU-deferred khugepaged page table retraction in
  commit 13cf577e6b66 ("mm/pgtable: add pte_free_defer() for pgtable as
  page").

* Qi Zheng has done most of the work that made this possible starting with
  the critical commit 718b13861d22 ("x86: mm: free page table pages by RCU
  instead of semi RCU").

* Qi then went on to convert a large number of architectures in commit
  e3ecf7c7d082 ("mm: pgtable: convert some architectures to use
  tlb_remove_ptdesc()"), commit 44b079583f7d ("alpha: mm: enable
  MMU_GATHER_RCU_TABLE_FREE") and the series to which it belongs.

* Qi then introduced the important CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
  option in commit 086498aed3f6 ("mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE
  to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config").

* Finally, and critically, Lance Yang then converted the batch allocation
  fallback case to be RCU-safe in commit 1fb3d8c20bfa ("mm/mmu_gather:
  replace IPI with synchronize_rcu() when batch allocation fails").

The work I do here is only possible due to the work Hugh, Qi, Lance and
others have done previously.

An initial task this series addresses is to zap deposited page tables after
an RCU grace period. Not doing so is currently safe, but for page table
walkers relying on RCU alone, it would not be.

The changes are largely mechanical - the majority of arches already have
the machinery required to support CONFIG_MMU_GATHER_RCU_TABLE_FREE and
simply needed configuration changes or small implementation changes to
switch over.

However some arches required extra attention - sh-X2, m68k-motorola and
sparc32.

sh-X2 allocates PMDs from the slab allocator and PTEs as normal. Therefore
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is set to customise page table freeing
and the LSB is used to encode which page table level is used, with
__tlb_remove_table() doing the right thing depending on this.

This pattern is repeated for m68k-motorola and sparc32 to account for
different page table levels. In each case, the page tables are aligned such
that sufficient bits are available in each case for encoding this
information.

m68k-motorola required the biggest change - since RCU page table freeing
uses call_rcu(), this means page table freeing can arise from softirq
context.

This was fixed with an IRQ-safe spin lock used in both get_pointer_table()
and free_pointer_table().

As part of this change, the logic for allocation of a new pointer table was
separated out into add_pointer_table() to make the locking more obviously
correct.

Finally, sparc32 was similar to m68k-motorola in that locking was required,
however this was already implemented via a spinlock, and only had to be
updated to be IRQ-safe.

Additionally, the nocache pool's bit_map lock was updated to be IRQ-safe
for softirq frees.

Separately, the PTE path can't take mm->page_table_lock from softirq (no mm
there), which is fine because the page reference count transitions are
atomic and fully ordered.

The series finally removes CONFIG_MMU_GATHER_RCU_TABLE_FREE and all related
configurations and code that supported !CONFIG_MMU_GATHER_RCU_TABLE_FREE.

As a result, page table walks can now be performed safely under RCU without
any risk of page tables being freed underneath a walker.

However, this is the only guarantee that this work provides - page table
walkers must still ensure that page table entries are as expected
throughout.

All changes have been build tested. As most of the conversions are simply
utilising existing mechanics that are known to work, this suffices for most
cases.

However those arches where significant changes have been made -
m68k-motorola, sparc32 and sh-X2 - have been tested further.

For each of these a boot test and stress test has been performed - fork 400
children, each mmap()'ing 2 MiB and touching every page then partially
munmap()'ing then exiting to trigger as much page table freeing as
possible.

All were found to be working correctly.

Note that sparc32 LEON SMP is not emulated, Andreas - do you have a means
of testing this?

v2:
* Updated commit message to reflect CONFIG_MMU dependency for xtensa as per
  Suren.
* Updated 12/12 to correctly describe the new contract re: readers/writes
  as per Kiryl. Also fixed up typos there as per Kiryl, Suren and slightly
  reworded for clarity, and updated commit message to reflect.
* Updated 11/12 to reflect the fact the change is for userland only as per
  Kiryl, also added a note about write locks similarly to 12/12.
* Fixed bug as reported by sashiko for the sparc32 change (10/12) - the
  refcounts are insufficient on their own, so replace the page_table_lock
  altogether with an IRQ-safe spinlock.

v1:
https://patch.msgid.link/20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (12):
      mm/huge_memory: zap deposited page tables after an RCU grace period
      mm: enable MMU_GATHER_RCU_TABLE_FREE for most 2-level architectures
      mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU riscv
      mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
      mm: enable MMU_GATHER_RCU_TABLE_FREE for arc, microblaze, xtensa
      mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
      mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-coldfire
      mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
      mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-motorola
      mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
      mm: make userland page table freeing RCU-safe
      mm: change the contract for free_pgtables(), update docs

 Documentation/mm/process_addrs.rst       |   6 ++
 arch/Kconfig                             |   8 --
 arch/alpha/Kconfig                       |   1 -
 arch/arc/include/asm/pgalloc.h           |   6 +-
 arch/arm/Kconfig                         |   1 -
 arch/arm64/Kconfig                       |   1 -
 arch/loongarch/Kconfig                   |   1 -
 arch/m68k/Kconfig                        |   1 +
 arch/m68k/include/asm/mcf_pgalloc.h      |   5 +-
 arch/m68k/include/asm/motorola_pgalloc.h |   9 ++-
 arch/m68k/mm/motorola.c                  | 121 ++++++++++++++++++++-----------
 arch/microblaze/include/asm/pgalloc.h    |   2 +-
 arch/mips/Kconfig                        |   1 -
 arch/parisc/Kconfig                      |   1 -
 arch/powerpc/Kconfig                     |   1 -
 arch/riscv/Kconfig                       |   1 -
 arch/s390/Kconfig                        |   1 -
 arch/sh/Kconfig                          |   1 +
 arch/sh/include/asm/pgalloc.h            |   6 +-
 arch/sh/mm/pgtable.c                     |  20 +++++
 arch/sparc/Kconfig                       |   4 +-
 arch/sparc/include/asm/pgalloc_32.h      |   7 +-
 arch/sparc/include/asm/pgalloc_64.h      |   8 --
 arch/sparc/include/asm/tlb_64.h          |   2 -
 arch/sparc/lib/bitext.c                  |  14 ++--
 arch/sparc/mm/srmmu.c                    |  32 ++++++--
 arch/um/Kconfig                          |   1 -
 arch/x86/Kconfig                         |   1 -
 arch/xtensa/include/asm/tlb.h            |   2 +-
 include/asm-generic/tlb.h                |  66 +++--------------
 mm/Kconfig                               |   2 +-
 mm/gup.c                                 |   5 +-
 mm/huge_memory.c                         |   2 +-
 mm/mmu_gather.c                          |  30 ++------
 mm/pgtable-generic.c                     |  15 +++-
 35 files changed, 194 insertions(+), 191 deletions(-)
---
base-commit: 88297631d4d42f6004cb39c0ba3da7d2d10a616f
change-id: 20260831-rcu-pagetable-freeing-84b6be830e20

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


