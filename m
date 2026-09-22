Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97EC1C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F2B6B0092; Tue, 22 Sep 2026 11:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847876B0098; Tue, 22 Sep 2026 11:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C856B009D; Tue, 22 Sep 2026 11:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 482746B0092
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:36:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC6A8140436
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:36:39 +0000 (UTC)
X-FDA: 85241800518.01.C3CC970
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E36D2100004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:36:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R67Z13OC;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VXiX9n3DnMCC3J9R0sISRxzl+MX7Zyg3FggR/wL6kMI=;
	b=4FKiwS0k34xe1L6diVOgpMP012o7qXN24WVn1Rvlo/h5uMpyz0K23xc9++A96zOfa8Gowv
	6HmDBcBzpQ7BeD0193cxfTmBHXDmwrBPvGsNp/kJFWKSaYihspcXJP75Rg4vKKuD09Wchq
	IUH4zVQITL8ocjqvKj889AXFko42Pys=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R67Z13OC;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091398;
	b=2Qlv9bvgMUFFR02kPA4ck9+K3Yf6x4kQoOgWjuatHmsj91QZNru2lVbJ9jxms9FPxCbA5k
	55HQyZmrTit5RC/x8tRDmXrotWcqWO16uIwPSgTSVi1jgEj9ugAYt3TnUhPI1QQGOA9oLw
	aJCcqAsIpBveBzKclPJtHoyQPPgUIXk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C700D43963;
	Tue, 22 Sep 2026 15:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9EB1F000FF;
	Tue, 22 Sep 2026 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091396;
	bh=VXiX9n3DnMCC3J9R0sISRxzl+MX7Zyg3FggR/wL6kMI=;
	h=From:Subject:Date:To:Cc;
	b=R67Z13OCqNHhpextpDtKUWLbDW7yiHhi4n5/bkwznY7HLddIo9WPHKAA2DBcFdESQ
	 aTLkAYownEsapARcOFYcAKmhQSNWbbh/X/r9oqml/bIHf58cM2nIL36ROfM+Dl4L+I
	 UiZksdIkVFfwozFmgS2kl8At2oZ2TkI/DC0Oz3H6KV+honjprAI2RcIrluTKYhlbVU
	 whESDi4J1q42v6H56evGzPh8neoG0hiydR58OnYPkmtGkoa6iTpGYH5W4JPWEbVi+W
	 FZMuXWsUhIPIodCLFp6UyUsyq/t61zIRYV+6L30zgbwvdAjZ5xnSpLqlcQ/TQQQTvw
	 zgjSaHhhS5o9Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Date: Tue, 22 Sep 2026 16:35:31 +0100
Message-Id: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XOTQ6CMBAF4KuYrq3pD5TRlfcwLmgdoEoKaYFoC
 He3wAZjWL7kzfdmJAG9xUAuh5F4HGywjYshOR6IqXJXIrWPmIlgQjGQnHrT0zYvsct1jbTwiNa
 VFBKtNIJkKBiJt63Hwr4X93Zfc+j1E003Y3OjsqFr/GcZHvjcWzfObG9j4JTRNElVDtyA4OL6Q
 u+wPjW+JPPIILYM7DEiMrxQTKsEIQP8Y+SG4bvfyMhkGgwozmR854eZpukLkiTynlsBAAA=
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
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
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
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
 Randy Dunlap <rdunlap@infradead.org>
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
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9144; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Wwap+ApEsbk9vgTLRs8p+oZODzpBIVXUlFmQrIRiRHA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LciasfN977IfIiwBstYHxFOEvjKc/Csb6e801/xmd
 jGD58nVHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIy26G/x7fe7WfbfoRVm3l
 IJl8dL41e9KLLeurZ7c9YCtvq61fb83IcHDz9ZnSRguCQ3v39t5kmmP7Kb66rj9tdob9j5jGZ36
 inAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E36D2100004
X-Rspam-User: 
X-Stat-Signature: 8hfk1juocobqrpa5bc755iw5fp5177u3
X-HE-Tag: 1790091397-482394
X-HE-Meta: U2FsdGVkX1+UyLsYzIIKKMEvMoSZEdS5tMolZlhrx5ybh8wnZkW1LMRhBSue3YD3dk386LJGyhFs1BGmMY5l5BiRztnx9rhjiQm0nujkbOX/vxdSi6ILz5oOm75K1uGGhRqGHAfEiqSk99lENhMW9wNpA8+8OjjOKsBm79M6t6y/IuQ5T/BXPNA71T0pjEoLlocAuw/+oYlfZ0pjzG5/d+vH7Bgny1BHh5ULW6K5dXLmTlKUqunvGXHnuJ2zlYMpzdCJLQ57FBddIsFx3NwpV+xnFREkeFowKtggtLE7v5g5/lHdM/UCT3au8y/sZYqjQnfWGRdDqf8fxLHwCYgT8zSvk0PohUWZLI99CfREs0xW+OTM9CxGDmGrrtygK2Si9s65i1RXRZa4mMOIwmXAzdFymEqOqJMPSWsmPiLyV9idDy1fyqiJ/VEczws+habHGmmx1xpSaINuDZ4SgRtHE/vDNyUxteOLWPNT4P6p3RmKjDsSlV2/FS9fdB4Nu8wbqCLovjVfHoeLkZ2Cvg+VkMq95krM4pC9oemN42h6nO2YWRaEzYxZ8ikBBZBh3IoYVIldxoT6HVUMWv+sJX9sWifsohjII5vP+DUgmpg3gL/sS2KyPQRUT2wKk/9zE63Jfsq7E7RD9pDFtCu7pivlBwIoAr2wJCu/oE4jAuBTOwvpt1eSMaLcWvb3iYIJBYiHXTo7pIyCbch+wEhx256Gbh/cMRmIlOCbi+4LWmy6b2SDLg3xLAR81yfoadYYibhGVjTp3I7DEqYdr6yWaZAzWjsNYkH7yO3Z9GjJhn/YrTM53LUlS+DzsWNDM02KB256nqeTBsMKzA8rFGDUuFY2Iih7iZ0AeojS8cS9sW0PM85jBO9b9qE6XEo4uEa0pluZdk38g6991bwD4TxAthTvotdZLtkqnlBl1aHzJmDXWxxP9kloponc8n4wnExtCki2eHDLArtYP7aghjpx7l2
 y0gch++y
 dCWTm97yfzBe+a/7wkShBTp2JHJKbuKwfGM2zXFQ9M+dWzicaEaDNEAHE1zr/wIVlTZWaWMmVLhdNfnieIwI7su1q19zbzwJ5P7OnOO9u1fl1CCBdFT95cdOy+xHwNScci9TxC8j0WVjq875P+xlnPhkLeKOkXt74Svm5o3E+jroK3yFFZUmDMAf4sWHP5BRBIkPTRwMGalU/9gTkaMAaoSFIOATQhp+jDSlPzQZJ++8rBSeOhjhsLU8GApE59zT7Ml1STBmZgPcxJptX4HK9bUZlPLbAJ0ZCd96JC8OCLOCMjP86Pnnw6lGe+Hp7f2rRCV00nVvZUHdLccJl6jDLwwRAkMDOou7GzwkTJOBZX73yCvdB0nR23uuTylqho/KjiEVAcvQzi8yckOrLM1211jfq6ySzhhYdn+Y9/7LYoXwicOQ/hYDyU//ZdA==
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

An initial task this series addresses is to deposit a freshly allocated PTE
page table and RCU-free the existing PTE page table. Not doing so is
currently safe, but for page table walkers relying on RCU alone, it would
not be.

Additionally, it makes it possible to implement lockless RCU-only page
table walkers which otherwise would have required the PTE PTL.

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

(Note that sparc32 LEON SMP is not possible to emulate.)

v4:
* Updated the 1st patch to allocate a new page table on PTE deposit rather
  than deposit a page table that might currently be being walked by an
  RCU-only page table walker, as per David.

v3:
* Added Kiryl's tag to series (thanks! :)
* Corrected commit message, comment indentation in 11/12 as per Kiryl.
* Corrected 12/12 documentation as per Kiryl.
https://lore.kernel.org/r/20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org

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
https://lore.kernel.org/r/20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org

v1:
https://patch.msgid.link/20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (12):
      mm/khugepaged: deposit a newly allocated page table on collapse
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
 mm/khugepaged.c                          |  32 +++++++-
 mm/mmu_gather.c                          |  30 ++------
 mm/pgtable-generic.c                     |  15 +++-
 35 files changed, 223 insertions(+), 192 deletions(-)
---
base-commit: 88297631d4d42f6004cb39c0ba3da7d2d10a616f
change-id: 20260831-rcu-pagetable-freeing-84b6be830e20

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


