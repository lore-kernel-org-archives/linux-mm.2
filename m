Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2C4FD8FFD
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB1F6B00BB; Fri, 27 Feb 2026 14:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365A96B00BC; Fri, 27 Feb 2026 14:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265536B00BE; Fri, 27 Feb 2026 14:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11F286B00BB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6B6A59BD5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:14 +0000 (UTC)
X-FDA: 84491260308.02.7AEB377
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B6F1940006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nR5TWSeg;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sE1G1HL9oYx5uFfLbALmuzlxOBXXMmht3rkQfyJsuFM=;
	b=jQDQGbbaLWwsFUODvgizlwLfnACY63UTNBY4mA4ikacImRviP2u8nCHj6keJwzh9iCfyyX
	JiiC/Z5dQt1VimKUv0S3ot/+mRgoFGq8y+VKFwmazjjAO2ngPS3fpKo9yJFDytlLIWft+2
	lElPhAqaLMg9f2HagrSQeJ3jbHnVhE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221392; a=rsa-sha256;
	cv=none;
	b=17+CGbMwljHI2Tq5mk/k6w46HV2usF/ao/WmIvHL5keBTZakBIbm7Uq3Lo/a0+2DtH8rQQ
	f8dF2a2/CqM7zdnrnrLP5Uf+8uYhW+O2eHeGHr2S4FqB1KKUgUt+530ujOg9UFtvAwPKej
	AMcUYaJGBvDshxIz17B5tE5RUi+r7Gs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nR5TWSeg;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADE1C409DD;
	Fri, 27 Feb 2026 19:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F64C19421;
	Fri, 27 Feb 2026 19:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221391;
	bh=Eqd+kkKOLROO+nOoXS7ZuwJRjspyFKG6DtwT0T4pgSU=;
	h=From:To:Cc:Subject:Date:From;
	b=nR5TWSegwVG/clKHCY8uB3wbisVSqNHj/WKQx7dWenFLHuYoE20ZOkBwXbbzngg00
	 wGf4b2eDa4C9MrJU+Gf5jz+b5gkBl+BgXNPcoFCofcvFe+XyCKxLTuUMumTwkT9sfO
	 fkxFKpVDgEEnaOoDc5VxF3o7BhuI2CUF1vDcybfyDkLwxp0rXSVbF/yw5SLtwv0P77
	 Fn2ShcHLtt29YwGD4yBU3W+VNvNYG9DmSm5m1yvbywLZx60sY4w4lioY08TlbtYnG6
	 IXGGaNHhiiNlvkwsIkip0/8l34BFa/WAzdoeqki/ejt8nipAZZ5Lma8M6gW7DBkCZ8
	 EofLgek+n7mfA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id AA341F40068;
	Fri, 27 Feb 2026 14:43:09 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:43:09 -0500
X-ME-Sender: <xms:zfOhafRBwzTWVhsyzZUyL4oUqLWdEXlN1drGTOQMp-YliQGDqev-zw>
    <xme:zfOhaZ9WBZn4peiLQuy_3WiH3yDCUJFZLAa2vAN-1Azqe6HXQ-kpXSqmkUh5y9cr7
    DNEB_2y3A4zNeC7__wViAR7b7pJCy4CtI7boGxS-cVe9GNu96K9dzc>
X-ME-Received: <xmr:zfOhae-cWq1uWS5J1y1j6u16mNRlEnPLmZnXQC-tFvVqCleYZtEbNhjw1pi0vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihlucfu
    hhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeetieekffduudfgheektddvgeetieefteefudefheekffeiteff
    ffelieeiueevhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudei
    udduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshh
    huthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
    dprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthht
    ohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfh
    hrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghi
    lhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtoh
    epohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:zfOhaf7eCmSJKJ0NWEKYEKO_5Dxof-8WwJmu39fPVe5Of6b7dUoNOg>
    <xmx:zfOhaUcQ3BfagXC-q2_7BXYOxtMNu_OFvSn9U0PVhaMFFrQOPivPSg>
    <xmx:zfOhaf07Eu8UZMgOr-eGWhydzMkawbr8GCFIeHu8KD9x09DODIZrhg>
    <xmx:zfOhaY9ASgz5JboEXSUKhvvdyksDMa9g48WJSfeYSz0OB_ivjetAXA>
    <xmx:zfOhaQ3XeeW2_kUhAG1QWCn0R0YinMjkpcZ5yTWrxzcsu2JPxAuu6vbd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:09 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCHv7 RESEND 00/17] mm: Eliminate fake head pages from vmemmap optimization
Date: Fri, 27 Feb 2026 19:42:38 +0000
Message-ID: <20260227194302.274384-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z1pw35gs5z1yi8fw89xqrg17ws6mjbdt
X-Rspamd-Queue-Id: B6F1940006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772221392-807943
X-HE-Meta: U2FsdGVkX18f0VyM4g6KTCBLgSCWpMdf0lNN+k2m0/xir/lrPD9xkYw3v4iYe4mtZ8Xx3dHq1kzmrM+7QRHmrVEXJsitJYkm0uGiS78blYhfUcUoGrLG6CgkenVm2o8twPJUfeHg4famvK2iATrPCj2mh1KQdltTeWNTi9aCJ9x4g+Pr11ywatAEDsV1z8N9qAH8QqAhAFC6QtqNiT8037Ofkc8pKwiz9uJEyqPsFdyD+3tdjU5VX4KUoUK4tewOrcY2PaV1yGhRoSWoJtnfbaf+FVb5uN0XZ8ISAsiNG0UZJxAyEHfp1C/0Xnb6s1YWz8ABpD8LYrt6tMjo7MxjOfeLn3R+obkQEjQ7Kk2ngZ/98zCxzhreXPcCoFODvDelpBiFRwIaTDsWWWxA8wwFa3v/3O6bUyAiaDjhGIDTaJYTtO5mZf8WLZ/Naxvfi035SI2/pqVZrDSasp0W1wKfIPvAcdtR8wVv7fxApEg4w/OEwfiV4VI/VbipO95HLpnHyf0wKh/Rwqfr6QXVpsgb6iwZfstdC9kQZXwK3sBu8J74KFpozbj0JS0JCjRFQnhTFtsY5ddufQAk8rFb91Sxkc791c/bSWbwvB0pd8QiaqXUgHq7xBBfQs3hBy4w8KTNK2R9Zx2K1e28yzVRYWVGIHGGlve6ahgpxkfrrBq5FJbsqU4JRafGmz0p6ECUN7mbJ+NWnpPfiAJhNpgzJbWZh8nwc7S64Jpjc0g3fbVWQEP6HaxD34k2VGuOOhPB/UANzqDWzVdq8p06qFf987MkpSP8NQsh3cgqhXctaLXvn8BsVEvNCXqIMmyhy9fp9w7mPr9UPxoIZk9XNkm0QrKPAcAhNHP/spqYPdOXKHo9jaTYL+2r2HM8ilcFRLhjQr2S4PNC4Dswt5/U7eh9o/ue7uKE6sCu9NQ4tV0WMvIFAfKMjkkSCjVgDEPkUUnyazwy02VSQh0C5FYqmK4C3sz
 K7oqzsiG
 RRJumTHY1Do0NReUeIgHT+YYTNri/ctKaE69cLMXqQlgMaPsVD38xzsspmlTPqsl7mcgMUxoa8p10QF2+3pTZQexg5YYV/gHpEWPDn5L7P4KbYBC/m+mADYNQYDtAQePdWm0NI8Ox63038ngHFHmANGjC2/h+UGLdwsqRxMUKCxrPB1P7c965mu8TEtI9fMF0327i90XZAady/fKE4U+K15gr7d4f6ifMQV7CdQGlRIMlhsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


