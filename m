Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 192F0FEFB7C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618436B009D; Fri, 27 Feb 2026 14:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2646B009F; Fri, 27 Feb 2026 14:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C436B00A1; Fri, 27 Feb 2026 14:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 320EE6B009D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C50AF5B6FA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:34 +0000 (UTC)
X-FDA: 84491228388.16.AFDE988
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C417440013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LvfAOcNs;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sE1G1HL9oYx5uFfLbALmuzlxOBXXMmht3rkQfyJsuFM=;
	b=GIZrdc+CbBWDINErp2u9A2SV1f5Pq5gs1yE7Gl93Fqj8c0UXpLFS+oAoMnPvRxQiEb8I53
	p0kkX5HN8kPIJ8uvGV7tF1QAJds2QgTiLexFseMYa3F1hxNDP2ZA6kpINBjFvXdfuzv+FH
	eEYMp51Ef7Ymy7XM64TwOhQSO2w2miQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LvfAOcNs;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220632; a=rsa-sha256;
	cv=none;
	b=CmvAWXqG5lFfWdM2qqJcLEwu7/mrzQVj5sd/epYN8I+zp+EgAVXQIgW3XbBX2RjYD0oZ4o
	z6vfZfI9cxInmFQLEESkoztJTRs6gCHocLwKGALacOA5pHli7ePs/j0CX8At7n6edJG9jJ
	7oamNbZIHugmqGeJDvQ2LkzUMlJ9aY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AA066013A;
	Fri, 27 Feb 2026 19:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0557C19421;
	Fri, 27 Feb 2026 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220631;
	bh=Eqd+kkKOLROO+nOoXS7ZuwJRjspyFKG6DtwT0T4pgSU=;
	h=From:To:Cc:Subject:Date:From;
	b=LvfAOcNs94K+m+2lImOdxxl/gxEZSKIOjNkH1YlJZlxlCGZvCAw4fRPhzQGb/iR/J
	 1N9g6h6VS+ciK67llaTZZVZLhro0A0l2k8AxfXRg8uBVgReHBaiOD205Bv7nrdxrMd
	 +uNZ/iUt5/PuVghaXI4+togzuwul4gYgD3bHaPGnKxMIzAy6qAy75TDpdPHz8onri+
	 ++9/3syXu1qklPns69F/1SJTEzAyV6CXx8OZaTNDOfb71yWm1IQt2GTlimEKJxghbP
	 I9EHvV4oyaPFLNWFHa6V69GxMLdLfJLT2/VCoCZJFUmiE8GguYrUBdf8OSNFrQbAV0
	 oVuE9UcXkL2Fg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id E6BE7F40068;
	Fri, 27 Feb 2026 14:30:29 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Feb 2026 14:30:29 -0500
X-ME-Sender: <xms:1fChaaWypHrOXhHiQdd5RjnFfCrOlqV3v_auBD8bLx4X9vgv4NvQsA>
    <xme:1fChafxXbUZVBLDYxL46mYahqqgkAKY3h7nhFpJqVXhEZVh4h9gtQ7NPr6lzjlXWl
    s3EsKUK_ip7EX8pEsAlCta9qXqfa6k_TNIBfYFU3cE3B7jfKBPm6Po>
X-ME-Received: <xmr:1fChaYi_mNsXeccnaTEkpBXSYkYVgS5gdV-2eMtDAcFEJbAY7XLnU6ylTsdgQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkoffoggfgsedtkeertdertddtnecuhfhrohhmpedfmfhirhihlhcu
    ufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqne
    cuggftrfgrthhtvghrnhepfeetjeeuieevffelgeelvdegtdetvddviefgtdfhjeetkeev
    tdelkeduffehjedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqddu
    ieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghessh
    hhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphht
    thhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinh
    hfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgr
    ihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtth
    hopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:1fChaSMQoXqbtZjJb7Ht37uRRKH-0qlxKIXp01X_ehMwG2rST0PpMA>
    <xmx:1fChaQg7Ego0t6dZrrFAyVAtE75bUCPaICgSLpR9ITbmHVWwQmdZew>
    <xmx:1fChaSrWd4LuLNdencqDMNrVjsQoHjJBg1wgtr81EPsk2v9APr7jSA>
    <xmx:1fChabhTjT5Ef8NE_KbHK_NUs6cC84utFJ0lugVTT1hQRgtgcB3Y-w>
    <xmx:1fChaYLVC8cQTmqXfIaVC38Oks4G7ZNDgl7VKPpFDo45uSehc5lDaMXe>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:29 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCHv7 00/17] mm: Eliminate fake head pages from vmemmap optimization
Date: Fri, 27 Feb 2026 19:30:01 +0000
Message-ID: <20260202155634.650837-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
X-getmail-retrieved-from-mailbox: Inbox
Tags: inbox
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C417440013
X-Stat-Signature: hom64aruj9xoxi583r3fzjskd6we6obr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772220632-181414
X-HE-Meta: U2FsdGVkX18VMJq+MxA+EZiOzg9lckypsAuns6/ClsRLYUM1EwsKWVXiqctIOcZcM4OeOaww0TGyRpJVCdNd2h/JzqBZ8ugCTrpxdBgTWbgdby3UBvnjyiSxY61VZWcz8gQb0qmU+Qrx+jI2K0Yf+FLBOJYipk1X5mISocbcMQz9L4uTxprkNw7FP74AJTVn4n8oDevKeM1UCA6u43RwJuFBIIXYQjnfWSFzjqVt4xjqSlqDTyhi1KigrtOLUZvEYVVVeYSWx0IVO6riijzdorlnfenBjQN7f6POkVyO7bAgKcTpnWqh0o9O6SYtnweSKpdOWL/s6PpZZaow53SwETSvR2au3P3BDI+JPkhwtLfbm4AQ0bGiZF93+wXbBvrjsWxOAAwAOkRsv0oak3xCkj0FbdanDan1k69waUKSPJogkkiq3Sjbqk9We4UacQQHeGoB/bC4F3AJIZxzshwNauC4wmq568iiE0Rt5CPOWzN1LPZQrdFVy44OwopQkdNYNJdm8FsPumvgbiVG+a9z+fEPxBRuQsfiGx9g27u/XmGu+IMJCoc0PzV4ePn5thrFV2fwSvs50N7Q5rgkUw0Aus+RhRO2//Tpz9issYvEgj/Gk7etR3ruRjvXQH7wMsjUCZxliehRPJNITsHMQoQtpKwMyqWiHD1rObW87kBgzwO5HSiVAgTr1naXI1lu73egRKywBLBaTBWmuokw/6oAwxlONaBArqB4h14MjQOqy1RP8ZmDBqlYX0r0h4AX/8tmvZ19i+ZMaE6QsHpXkoMbblPm+xAfuCgouLZ1XsjyMCiaQxEKx2HKTXENVADCC+Icf9nhYg34ppt5jmEu3wvMKTiGN9nZIrpI+90xjoDce6XidW8v8CBVqVW69bC6T31A1nliH2q2pKwuvKV1iR6K9NFuXMqY1xs2GBb5iPyAf5bGpMgIX/mLE4MnMdrEVTAtgNQGjGoeZywQPZHLDER
 mXukAEy2
 /P+/X1rE3xtWK5CbjoGggejYjuDT054jwGqS4sdi6adFoYJLskp4ma8bHAuOjxZKxrSkzb/wy8qkEZQ4mpgz2swqV7alKtDCOympgmoj5r9ruJTOv7qOtXF+x6cayBwkVDVw3vaAzA/EfFtF09jrCb5PfyFxJEo3j2EM9Hg5uyj3lLAEtYqP4V6Q+N7hsrku8FbrVKstkd0Sr205U0F2+kXAtWj9BDUtTJqUgdh8aB274iEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20260227193001.7FJRazzJPR-OFsixM_TIvPK0aVXOpUIoxQMtTZ2XZyU@z>

This series removes "fake head pages" from the HugeTLB vmemmap
optimization (HVO) by changing how tail pages encode their relationship
to the head page.

It simplifies compound_head() and page_ref_add_unless(). Both are in the
hot path.

Background
==========

HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
and remapping the freed virtual addresses to a single physical page.
Previously, all tail page vmemmap entries were remapped to the first
vmemmap page (containing the head struct page), creating "fake heads" -
tail pages that appear to have PG_head set when accessed through the
deduplicated vmemmap.

This required special handling in compound_head() to detect and work
around fake heads, adding complexity and overhead to a very hot path.

New Approach
============

For architectures/configs where sizeof(struct page) is a power of 2 (the
common case), this series changes how position of the head page is encoded
in the tail pages.

Instead of storing a pointer to the head page, the ->compound_info
(renamed from ->compound_head) now stores a mask.

The mask can be applied to any tail page's virtual address to compute
the head page address. Critically, all tail pages of the same order now
have identical compound_info values, regardless of which compound page
they belong to.

The key insight is that all tail pages of the same order now have
identical compound_info values, regardless of which compound page they
belong to.

In v7, these shared tail pages are allocated per-zone. This ensures 
that zone information (stored in page->flags) is correct even for 
shared tail pages, removing the need for the special-casing in 
page_zonenum() proposed in earlier versions.

To support per-zone shared pages for boot-allocated gigantic pages, 
the vmemmap population is deferred until zones are initialized. This 
simplifies the logic significantly and allows the removal of 
vmemmap_undo_hvo().

Benefits
========

1. Simplified compound_head(): No fake head detection needed, can be
   implemented in a branchless manner.

2. Simplified page_ref_add_unless(): RCU protection removed since there's
   no race with fake head remapping.

3. Cleaner architecture: The shared tail pages are truly read-only and
   contain valid tail page metadata.

If sizeof(struct page) is not power-of-2, there are no functional changes.
HVO is not supported in this configuration.

I had hoped to see performance improvement, but my testing thus far has
shown either no change or only a slight improvement within the noise.

Series Organization
===================

Patch 1: Move MAX_FOLIO_ORDER definition to mmzone.h.
Patches 2-4: Refactoring of field names and interfaces.
Patches 5-6: Architecture alignment for LoongArch and RISC-V.
Patch 7: Mask-based compound_head() implementation.
Patch 8: Add memmap alignment checks.
Patch 9: Branchless compound_head() optimization.
Patch 10: Defer vmemmap population for bootmem hugepages.
Patch 11: Refactor vmemmap_walk.
Patch 12: x86 vDSO build fix.
Patch 13: Eliminate fake heads with per-zone shared tail pages.
Patches 14-16: Cleanup of fake head infrastructure.
Patch 17: Documentation update.
Patch 18: Use compound_head() in page_slab().

Changes in v7:
==============

  - Move vmemmap_tails from per-node to per-zone. This ensures tail
    pages have correct zone information.

  - Defer vmemmap population for boot-allocated huge pages to 
    hugetlb_vmemmap_init_late(). This makes zone information available 
    during population and allows removing vmemmap_undo_hvo().

  - Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for x86 vdso32 to 
    fix build issues.

  - Remove the patch that modified page_zonenum(), as per-zone 
    shared pages make it unnecessary.

Changes in v6:
==============
  - Simplify memmap alignment check in mm/sparse.c: use VM_BUG_ON()
    (Muchun)

  - Store struct page pointers in vmemmap_tails[] instead of PFNs.
    (Muchun)

  - Fix build error on powerpc due to negative NR_VMEMMAP_TAILS.

Changes in v5:
==============
  - Rebased to mm-everything-2026-01-27-04-35

  - Add arch-specific patches to align vmemmap to maximal folio size
    for riscv and LoongArch architectures.

  - Strengthen the memmap alignment check in mm/sparse.c: use BUG()
    for CONFIG_DEBUG_VM, WARN() otherwise. (Muchun)

  - Use cmpxchg() instead of hugetlb_lock to update vmemmap_tails
    array. (Muchun)

  - Update page_slab().

Changes in v4:
==============
  - Fix build issues due to linux/mmzone.h <-> linux/pgtable.h
    dependency loop by avoiding including linux/pgtable.h into
    linux/mmzone.h

  - Rework vmemmap_remap_alloc() interface. (Muchun)

  - Use &folio->page instead of folio address for optimization
    target. (Muchun)

Changes in v3:
==============
  - Fixed error recovery path in vmemmap_remap_free() to pass correct start
    address for TLB flush. (Muchun)

  - Wrapped the mask-based compound_info encoding within CONFIG_SPARSEMEM_VMEMMAP
    check via compound_info_has_mask(). For other memory models, alignment
    guarantees are harder to verify. (Muchun)

  - Updated vmemmap_dedup.rst documentation wording: changed "vmemmap_tail
    shared for the struct hstate" to "A single, per-node page frame shared
    among all hugepages of the same size". (Muchun)

  - Fixed build error with MAX_FOLIO_ORDER expanding to undefined PUD_ORDER
    in certain configurations. (kernel test robot)

Changes in v2:
==============

- Handle boot-allocated huge pages correctly. (Frank)

- Changed from per-hstate vmemmap_tail to per-node vmemmap_tails[] array
  in pglist_data. (Muchun)

- Added spin_lock(&hugetlb_lock) protection in vmemmap_get_tail() to fix
  a race condition where two threads could both allocate tail pages.
  The losing thread now properly frees its allocated page. (Usama)

- Add warning if memmap is not aligned to MAX_FOLIO_SIZE, which is
  required for the mask approach. (Muchun)

- Make page_zonenum() use head page - correctness fix since shared
  tail pages cannot have valid zone information. (Muchun)

- Added 'const' qualifier to head parameter in set_compound_head() and
  prep_compound_tail(). (Usama)

- Updated commit messages.

Kiryl Shutsemau (16):
  mm: Move MAX_FOLIO_ORDER definition to mmzone.h
  mm: Change the interface of prep_compound_tail()
  mm: Rename the 'compound_head' field in the 'struct page' to
    'compound_info'
  mm: Move set/clear_compound_head() next to compound_head()
  riscv/mm: Align vmemmap to maximal folio size
  LoongArch/mm: Align vmemmap to maximal folio size
  mm: Rework compound_head() for power-of-2 sizeof(struct page)
  mm/sparse: Check memmap alignment for compound_info_has_mask()
  mm/hugetlb: Refactor code around vmemmap_walk
  mm/hugetlb: Remove fake head pages
  mm: Drop fake head checks
  hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
  mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
  mm: Remove the branch from compound_head()
  hugetlb: Update vmemmap_dedup.rst
  mm/slab: Use compound_head() in page_slab()

Kiryl Shutsemau (Meta) (2):
  mm/hugetlb: Defer vmemmap population for bootmem hugepages
  x86/vdso: Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32

 .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
 Documentation/mm/vmemmap_dedup.rst            |  62 ++-
 arch/loongarch/include/asm/pgtable.h          |   3 +-
 arch/riscv/mm/init.c                          |   3 +-
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   1 +
 include/linux/mm.h                            |  36 +-
 include/linux/mm_types.h                      |  20 +-
 include/linux/mmzone.h                        |  57 +++
 include/linux/page-flags.h                    | 166 ++++----
 include/linux/page_ref.h                      |   8 +-
 include/linux/types.h                         |   2 +-
 kernel/vmcore_info.c                          |   2 +-
 mm/hugetlb.c                                  |   8 +-
 mm/hugetlb_vmemmap.c                          | 362 +++++++++---------
 mm/internal.h                                 |  18 +-
 mm/mm_init.c                                  |   2 +-
 mm/page_alloc.c                               |   4 +-
 mm/slab.h                                     |   8 +-
 mm/sparse-vmemmap.c                           | 110 +++---
 mm/sparse.c                                   |   5 +
 mm/util.c                                     |  16 +-
 21 files changed, 448 insertions(+), 447 deletions(-)

-- 
2.51.2


