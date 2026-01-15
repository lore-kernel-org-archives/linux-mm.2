Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DB5D44C56
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD976B0088; Thu, 15 Jan 2026 09:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D916B0089; Thu, 15 Jan 2026 09:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82EB6B008A; Thu, 15 Jan 2026 09:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB5AC6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1FF61AE385
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:13 +0000 (UTC)
X-FDA: 84334473426.11.63D09EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0B54A0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cG6Ewkbg;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2x5dGoTi1QO4ZvDc3srlkGLKQcMc3pi/SAl5vJBNtbo=;
	b=EOJZkuHk7fqFTh2zlxV3UtVyutPOCaFSmB/8DdpOp3nQSNmyTnN29FPfawkvKQeguqSg/s
	6HGw6mu7Cgzrwtyay2qffYkERrBSyZmVpDJ7ubyQhrtIflllkykCYrFcRkLvQBN+f5sNGm
	0guKMfxxxgSz4QacTNWkUyAiIjQzz1o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cG6Ewkbg;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488372; a=rsa-sha256;
	cv=none;
	b=M0GHUQ4/euesvOvMMGahmNj2MO2nah5S7TnedlwBnuymw48JoicPEWGtzaTpDVEIWhgKL2
	xvtm1Mw9L4hok2AxuVmBfIWLbf3wTMmIlq7RG/jS/LxkYpIM5daOjJaPYE91xygt3oD9fj
	K4yEXse1Uvu7A5p2N522/SZX4iSuUfU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AF2D600BB;
	Thu, 15 Jan 2026 14:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67937C16AAE;
	Thu, 15 Jan 2026 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488370;
	bh=gQRwWiu8OTubVEWpNxxTKEntQZOwqK9ndn+7y2YfMeU=;
	h=From:To:Cc:Subject:Date:From;
	b=cG6EwkbgwyQKiLnv66s7SFzmatUHBIUCDM4QOIPn3aHNm+DxGqEmq6GSAGlgCj3en
	 gpt3RxzOzbPF6eJxvJfv/Io6AGesEpb6hqKxA+N5WR989xL6SpoiPu/ytrhtEl/LRN
	 LpsMHF0KFLnJlKragLkc4V3sylyiyUV8R1GN9wjsO6p7jfquWji1R0Y7JXsQzdyEfV
	 cg42UU2RklQ+Gsku0mXjsxCdrWKZgJwq0H8rtsYfcq1HJFyCRzZMziFWFDO6ykgIyr
	 62dGP/Q4BfLAeFNdc8TUfxEnI+Zb3KCid8E4d3ehpug/OO8+aLHXBbLs6DEgchTSxY
	 U4dS5Ox+gz3ZQ==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6AACEF40068;
	Thu, 15 Jan 2026 09:46:09 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 15 Jan 2026 09:46:09 -0500
X-ME-Sender: <xms:sf1oadnLh2YuLJOioJebnpzBn0vcbhSQWSD2Ag_y8rFrTMdsWEisIA>
    <xme:sf1oaYH5uOerwzSkL3dCtfBdFpUSjFZbEOTdsdodjyViuqE9LEWjMd69qiDvaU53n
    M-XfEcUF29lFl5Etrm0M5JtudlcDgcQWngUHgBT4iNaHKiFGmcABw>
X-ME-Received: <xmr:sf1oaWcWN9U8UNtzu5p11s9xoeMYoOWaE_HOAFrHm6RnYwRvZSuKO02OKwIZtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epffdvhfdtgfekuddttdffgeeljeehueffvdfgjeejvdetiedtfeefgfetgfffhfffnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorh
    hgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguoh
    hrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:sf1oaVHrWryzUdOzZ14M3enusyGEmDAHD4Vm2Uul6hY9OWPzUKptcg>
    <xmx:sf1oaQFAGUKKfQ1xmFZolW5VZLUH4od4MbpruHINr-eQ9J_mQjgtnw>
    <xmx:sf1oaVN1MI_BkFzsWtV8-xb2zbpGjVxQFOpaEf94mTNhqI5PQASYBg>
    <xmx:sf1oaVptoqwqOVYrOERtpaQaoucIG1jc1ILJMxrXgQ-FyyMvw1Yrtg>
    <xmx:sf1oaWBV0p0rGR-26joNdEz2-iPXwxkjrmOMQrT7nKycHK4RjgF4eYl4>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:08 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 00/15] mm: Eliminate fake head pages from vmemmap optimization
Date: Thu, 15 Jan 2026 14:45:46 +0000
Message-ID: <20260115144604.822702-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kmi9i9cfk1tj1gffy4imweipo6mqekxg
X-Rspamd-Queue-Id: F0B54A0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768488371-194311
X-HE-Meta: U2FsdGVkX18wKA45GbZ81N/wjaGmPkr9/6UnGGVH58Um+TENON9UepQCnz7UT/60YBeFZV0Bg3Ow0SvJmayXmqVsOSZ060cmPsSqmK3fN9UbJRjHreJ+om6ZG037Yp2Vn/BxsjhhlC4qUvhARtcOD45K912xPHgElfBKAziXR5128O5u6+4eCrlvqdodO9XhMhuzGCdwlw2zDNgLMdrfutCW0JHzpcdvPsAjsqe6KNhFFqwe4a1Rbck3NJashd1M1lglOuPsVPK7cig37JCF56oCoQABePOrMwsWxbpbGryjsPhh3oXVF7ruSmmR9A0W7vhXph/ZgMozL9LsCcw2vS2LWaT02Ih6lywB6Zq9CvEPnJzRKzlUVPRH02o2l8MCztvNWfZzhz3orGipfXVHQ1jPjr66/srX4bjcaVDYIMxOtPlCdOrMTT1yqhnyJPpj0appcrdqLYaedMp6bTDtg5jHnL7QFNxgamKg0R55dtKK7gKpxShj00nNetgTaE3ERIJYPiCatnwDqzuLbKgkbVoWfR4SJ/pJfUFBy89I8R5K+EFeWYYwDFD2FSJ2uKIQgTgaCwAtffuxhNy90cLiZQ/c5VAXCLoMjSp9MOnXUueeoYNrzRDD0T8S4xaSagHHaGkADNq4pilz/UYe9vbc6QBn6fFq4uDfQSbque79AQa372px1LpRBt2rA9J7bbhpxYGG6zlyjEBygQHZz6e1HvkPgN5/DeSQW1Lc5/ZDV4PfD32zEwzDp6I4YyQA08g0NW1TL3qsEyqrgslWdhJvlgWeHm+BHTuGOX+slU9IGR6Rb/xQW6kyDxAjf+eABcpbpZqw0iePY/TFktfNdmhiUYR3X4uMUOda2vLWaOugXwVfol+gOOKjiLdAgalaZQTnsB9b1Oi6EHJ5ThAJSujTvmNjcnPTTc60TQAuMl37HfL34jTTwKSvY1ZFLSwlhAphKXkz53jdtHOFyrBFo0V
 2EYDh+67
 WG/5wpEj8StZ+ylA//UXhRv+GdbLdPT5AncsyNV3XuBgQcT3IqxxWOiHLN0WV9nKTliD4Rwu3JdmLBEsfjTVq//6kq62D7q4bQqOZtyip0mgc4aEcG6NAj24epXF/jcl5xHKRMPWlBDuBtWthr6vPc/CZKVLfu4EdxKF95ziuMjBPfAShcn/bWhqNJR+RCgHZYe2Z+D+QuRMVeeJpgBI9PMV0J7o3bfnffLSUN9Ih+nEg6ik=
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

Patch 1-2: Preparation - move MAX_FOLIO_ORDER to mmzone.h and build fix
	   for x86/vdso32
Patches 3-5: Refactoring - interface changes, field rename, code movement
Patch 6: Core change - new mask-based compound_head() encoding
Patch 7: Correctness fix - page_zonenum() must use head page
Patch 8: Add memmap alignment check for compound_info_has_mask()
Patch 9: Refactor vmemmap_walk for new design
Patch 10: Eliminate fake heads with shared tail pages
Patches 11-14: Cleanup - remove fake head infrastructure
Patch 15: Documentation update

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

Kiryl Shutsemau (15):
  x86/vdso32: Prepare for <linux/pgtable.h> inclusion
  mm: Move MAX_FOLIO_ORDER definition to mmzone.h
  mm: Change the interface of prep_compound_tail()
  mm: Rename the 'compound_head' field in the 'struct page' to
    'compound_info'
  mm: Move set/clear_compound_head() next to compound_head()
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

 .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
 Documentation/mm/vmemmap_dedup.rst            |  62 ++--
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   2 +
 include/linux/mm.h                            |  31 --
 include/linux/mm_types.h                      |  20 +-
 include/linux/mmzone.h                        |  48 ++++
 include/linux/page-flags.h                    | 167 +++++------
 include/linux/page_ref.h                      |   8 +-
 include/linux/types.h                         |   2 +-
 kernel/vmcore_info.c                          |   2 +-
 mm/hugetlb.c                                  |   8 +-
 mm/hugetlb_vmemmap.c                          | 270 +++++++++---------
 mm/internal.h                                 |  12 +-
 mm/mm_init.c                                  |   2 +-
 mm/page_alloc.c                               |   4 +-
 mm/slab.h                                     |   2 +-
 mm/sparse-vmemmap.c                           |  44 ++-
 mm/sparse.c                                   |   5 +
 mm/util.c                                     |  16 +-
 19 files changed, 363 insertions(+), 344 deletions(-)

-- 
2.51.2


