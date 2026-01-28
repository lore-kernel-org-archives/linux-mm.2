Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D48D25B7F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2156B0005; Wed, 28 Jan 2026 08:55:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35D16B008A; Wed, 28 Jan 2026 08:55:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9172F6B008C; Wed, 28 Jan 2026 08:55:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7FE6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F3551A0699
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:09 +0000 (UTC)
X-FDA: 84381519138.09.654938D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 71FE320004
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NbLgWV5C;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4tFjXvIyz5i9WYgsLsSTlQ4UPNevxErkAH8B14hNEK0=;
	b=3nx4QPJWiVF9E/jar+zpxQE8UzOROlJUSsAVe7BQkDIltMg1ddHCCKTkytbJVkfWC8sHPi
	z0uXZXz2zQ5Q987UHKmr5LegviLBHoCWt8b5Acbvr/4RCCadW3iJsrUvGtXwlqhV+ttEOt
	HIR8uWXrDJVyuf742pYmr+sAOANhUcY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NbLgWV5C;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608507; a=rsa-sha256;
	cv=none;
	b=3v6/eLyuAz0tFBj2Nkg9VPvMtDgBPyNftlk96prLqgbFjgKi/Q2sRuXSS6IMFhGzzutn3K
	bZxePmDnA57STu4ZJUcNi3r0KA5/2aEuqL7L7WjBjzW/utQ5d5E62w766p2rJh740fp1M5
	amdqbCNf+uPbOMKPkBI8JINP17cDZBw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B93C060097;
	Wed, 28 Jan 2026 13:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664CEC4AF0B;
	Wed, 28 Jan 2026 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608506;
	bh=fxqweZtjhNjUzXJhjxx9w3CvgIGRJ0HGBGSiQo/CyUw=;
	h=From:To:Cc:Subject:Date:From;
	b=NbLgWV5CJfrpuvecf5rmT6u4t2tMqQTr5C2sPg2KoA9SmepOhl8lIwMNl92vpF7kw
	 VakhrxvT0Dp6FuBGLtWMITZtTg+/2SvS6z6KLnleOlfG2V7tuVG+HC/nynz9B/T1Fx
	 n8R3vSfptMxYyh9ebmyS9sLub3dbbKqmqUpf+PeTSFeEp/Be3DPn2/C+khcJwfV1Xp
	 k/J7OssMc2FBkT36SZz/dItAHd5Yon0WLQc/5KwLRL4VAoOCbqLnKAdMhtzKgtxP4j
	 7dC3RGGQBpscU/ug+lKVFYrIzNrBeeT8ypkYUcTsdD1jlXA7vf3+ZxWhK3Gbqzah1L
	 5tFI+fRJXxKqA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 89104F4006D;
	Wed, 28 Jan 2026 08:55:04 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:55:04 -0500
X-ME-Sender: <xms:OBV6aaPPMvM1-Yc9LoXUPUaMbyOwsY1rENAo48XpltruwcQHBOy7DA>
    <xme:OBV6aSLkI0ccUxbDEQI6fL9V_uyliBzDOzM1n7KPyuLG0lkyvYwvr5SGAezJF09IX
    RoAqFt6Nodgd-k_IbhDbDUqiShK1alXv0uxwsF5aCzc83ykDQX2MDY>
X-ME-Received: <xmr:OBV6abaPRFLoERJO1xQZX_Ed5t8_gDXUzxVwd5N0cpu4Xux0js8FQUJ4Hahd_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epffdvhfdtgfekuddttdffgeeljeehueffvdfgjeejvdetiedtfeefgfetgfffhfffnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehr
    vgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorh
    hgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguoh
    hrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:OBV6abkHOi0XxIHwLmbGmyEfUq6XgXtLhb4rAo_x4GuRaXlHl7o5gw>
    <xmx:OBV6aeZp7NXOkrQr0rTFx3DgFhu1k8MKCl0rc-aBlRVLcp2bgv2D7w>
    <xmx:OBV6abA-IQ0-64zbkFo4K51Ld32rKkDXxPTJkLLlbF25ktvL1fscig>
    <xmx:OBV6acY4Hwzt12D1Yn7yZUMjZ6V_lPOgduLZIgtlSTIr1ab8XtFONA>
    <xmx:OBV6aXjw3K5ggxbRrx212NCPfk0pnyfme_AFgqsqH4euXtTZbO1cOQAS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:03 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv5 00/17] mm: Eliminate fake head pages from vmemmap optimization
Date: Wed, 28 Jan 2026 13:54:41 +0000
Message-ID: <20260128135500.22121-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: zr4mb11jbuh9y68oyrrb7o45mcqgjaro
X-Rspam-User: 
X-Rspamd-Queue-Id: 71FE320004
X-HE-Tag: 1769608507-232827
X-HE-Meta: U2FsdGVkX18QagCJ2yqkcI+ylYLVODeLDDutfthI/WHUMdNQKYpXZkaIV2zufu9lJ2PpcNMZCfFhT2FSXA8z+vZC/goWqZl2JFQYVCw2BTrxQJnPdfSyNMZX3rMXBqgoDoB34bzpWwOHyLCS8kqpqnRMdgcytTevdAp6YJxSTnPm6ftNlFBZXnriGpTU30z88p7HG62E15B7qXT9DMYiQ1NeOv4GJk9ExB7Q2vuO5JyVxfELpApiHqee3g5+z3Fo2fBdLtnidtTuc1ReQ04icY0Ijl0ESz2CFswhCwz+J+rtGTmnXk97/wlgmz+TcDrBsEDiFMG+OFk+Ya0tl4YaWfq6EWLNpHKFNYc2eNK7wg76tidQtgKYoV605JcMj8EE5Xei6kPSF7FLXFfX7oM3ro16umaQv3adt8XT0ywLXTvgbh52qGXda4oTZqESIrXSE93VOYji1ZN+AmzKLu1Q2GqZ+idyNfQxcnaF4Qds2JLul80IbXZglPRQ/D55du4LqQyiWfEGt5Mqw29suG59lGwl6xz2gMKgJYi6oKYKE50JXKtelOLD9eovEX4JATinTfLKiSGLqHIy0yCcLPnEstFtj8DU978+MGJeDuJecoahOPu0w5yo8tdqRC0AQ1cpeXwfYvAPDg2g5s/ZZ1j2zuUqAlqsjosS11M6GaLXar9b0wayrolaQR3DUVgsyosM7n1rai+okRVc7kSFWMw7JvbRsHFzwqiJGxQp/GQnqiCHODTFx6YYEGwSWzeEdN5p9bYQov3Rj1HG35HwTt0rmyy6CtHyhs98FKIFIScW0Jm/OK9CybY3mNjNzZMl8OZYfEIfwQWu1rbkcdki6YXjR8Cwk7pLfXaSDzfb71MIptYLp7TuRMITUwT/8Y9BxfYPcMqU7U/stVKagJqvHY8xzDFhVBZ7a+cuaybzwzuU02axCY20PiVb5zZEoWnVkx6MKaBAog6I0NkhKZnmicV
 2JcQY8fF
 m9+mmX5B5Fbxi6gFJdMl609mf8GMD3I4tFRJcNuAR0R1WzsIpYCl+GA0XvuPLo4HgkiDRxn90sqsuSITZqxBF8zWSbCAbCd5covgUMzCFQcKSYLLLGtRSM7L401bi6F2VqVLJoWnfbs3KPTAkapqCkhIivqssDx6Yiw8jLwW9SFpUvlLlcu8X+ACx7k2MS6NfuqVDWG9bK/GREyHYMvvC2v4zUQUJ+bqXo4yw8LNpMWwpzSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
belong to. This allows a single page of tail struct pages to be shared
across all huge pages of the same order on a NUMA node.

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

Patch 1: Preparation - move MAX_FOLIO_ORDER to mmzone.h
Patches 2-4: Refactoring - interface changes, field rename, code movement
Patches 5-6: Arch fixes - align vmemmap for riscv and LoongArch
Patch 7: Core change - new mask-based compound_head() encoding
Patch 8: Correctness fix - page_zonenum() must use head page
Patch 9: Add memmap alignment check for compound_info_has_mask()
Patch 10: Refactor vmemmap_walk for new design
Patch 11: Eliminate fake heads with shared tail pages
Patches 12-15: Cleanup - remove fake head infrastructure
Patch 16: Documentation update
Patch 17: Get rid of opencoded compound_head() in page_slab()

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


Kiryl Shutsemau (17):
  mm: Move MAX_FOLIO_ORDER definition to mmzone.h
  mm: Change the interface of prep_compound_tail()
  mm: Rename the 'compound_head' field in the 'struct page' to
    'compound_info'
  mm: Move set/clear_compound_head() next to compound_head()
  riscv/mm: Align vmemmap to maximal folio size
  LoongArch/mm: Align vmemmap to maximal folio size
  mm: Rework compound_head() for power-of-2 sizeof(struct page)
  mm: Make page_zonenum() use head page
  mm/sparse: Check memmap alignment for compound_info_has_mask()
  mm/hugetlb: Refactor code around vmemmap_walk
  mm/hugetlb: Remove fake head pages
  mm: Drop fake head checks
  hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
  mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
  mm: Remove the branch from compound_head()
  hugetlb: Update vmemmap_dedup.rst
  mm/slab: Use compound_head() in page_slab()

 .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
 Documentation/mm/vmemmap_dedup.rst            |  62 ++--
 arch/loongarch/include/asm/pgtable.h          |   3 +-
 arch/riscv/mm/init.c                          |   3 +-
 include/linux/mm.h                            |  31 --
 include/linux/mm_types.h                      |  20 +-
 include/linux/mmzone.h                        |  46 +++
 include/linux/page-flags.h                    | 167 +++++-----
 include/linux/page_ref.h                      |   8 +-
 include/linux/types.h                         |   2 +-
 kernel/vmcore_info.c                          |   2 +-
 mm/hugetlb.c                                  |   8 +-
 mm/hugetlb_vmemmap.c                          | 290 ++++++++----------
 mm/internal.h                                 |  12 +-
 mm/mm_init.c                                  |   2 +-
 mm/page_alloc.c                               |   4 +-
 mm/slab.h                                     |   8 +-
 mm/sparse-vmemmap.c                           |  44 ++-
 mm/sparse.c                                   |  13 +
 mm/util.c                                     |  16 +-
 20 files changed, 371 insertions(+), 372 deletions(-)

-- 
2.51.2


