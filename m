Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 895E9D6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF5796B0089; Thu, 18 Dec 2025 10:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0996B008A; Thu, 18 Dec 2025 10:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD6B6B008C; Thu, 18 Dec 2025 10:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC8E16B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:09:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 658B21401E9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:57 +0000 (UTC)
X-FDA: 84232926834.03.078082F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6D6B4A0023
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWrFCKZS;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OsGPo9PG+9IrJHzVoXk+C1v53xpcUVelvFX2Bvyj1zQ=;
	b=J8tscbCWuDIJKFGvKNCYZWJ9DheK4ltQeMcL3GmsInuomjEaYE4HuFdyth6EYYjUcOFhdV
	ythqgN7SkQjS1jmtz8vMWGtv+g1N+zhnsWZcWoQ96ejmnxQsTpQb3KivolgQ2lmNrR+e7A
	DMod+54lrXE/bO6V1P3pg0kwZr8CSC0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWrFCKZS;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070595; a=rsa-sha256;
	cv=none;
	b=37yIbZVERVLwEuoQdZI+5h5jO5JL4aysi59oElhPcw3KforUu2et75ithFaUK7nJvFZEXx
	WCGWhXHWXF0PrOrPX3MBb8wNB1GFrqsGCzmefoUWgh5o76mwI6EQypl7Z5+70yMX8YrwpG
	asdA/2P4gi0JPRMCQ5uIVu7yBlSYRH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 610ED44264;
	Thu, 18 Dec 2025 15:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C29C4CEFB;
	Thu, 18 Dec 2025 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070594;
	bh=O6GP+t8IQVJzoleFoYNiOb4xlvArbWf4kOGt3VXh7rw=;
	h=From:To:Cc:Subject:Date:From;
	b=tWrFCKZSm/pbLlyurmjdxxHtCAvHG3U8OlVCKUCogeEA+1U068GLMP5zc9lpzWmFz
	 9+WZR+hGjsw7rOb+DGTPb4ZWbWNokXDkztk5FoZ2IDfg5+z2vwTcg08xVf7E1iHrKH
	 B4JvXaenngV0JXu6HlgXZetjzyf/WVRfJFn+Bthl8QkeWhnRXqmsP6dyNRwHKmPlZS
	 1yrCK+va2r6U0kJGF2z9XwHMHVsMBGQwvlNRNoggTSbENBgtXTfZcW+xvXjyanynJq
	 +A5rBd2fJh/3JH6+Ra4XLzW+LOcpBaivL6fTolqSKgxbYNJYwFQ+oCzlMnYLzLn1qd
	 ZHcyQC2bJEyAg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id CFAC3F40072;
	Thu, 18 Dec 2025 10:09:52 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 18 Dec 2025 10:09:52 -0500
X-ME-Sender: <xms:QBlEaWY3-8eA78_LsIRDslmH29nCNItXafiw7olAl3Y8W5iMv-BcPA>
    <xme:QBlEaYpyeoS6AP-0xR0uCMoHKW309MBUad6NeQpQD8DFFOtNugeKHA6kO9rPtGC7b
    t4jke058qtg-2jEmrKwvbO4j8VT4p2qdil7o9Nax4XbZ980vafXl_Y>
X-ME-Received: <xmr:QBlEaTy1oci3tP3xz6MuGxJP-04oYbhc3qWXJoFA2dKmb4owR7C13sNr55Gicg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ffvdfhtdfgkedutddtffegleejheeuffdvgfejjedvteeitdeffefgtefgfffhffenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllh
    domhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdek
    geeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmh
    gvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuh
    gthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
    dprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphht
    thhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrughorh
    esshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:QBlEaQLqz02TregJ9f8ttrlMcADx62ZDo1mvHg7KqYNxE_MucnoiVA>
    <xmx:QBlEaV636JZA9D-qkvJRBpPdZpGewOshUrLvqSQq70lFe5VyTzCTCA>
    <xmx:QBlEaezVf8A0u-3BtKN0dJvIM4e_31uEVqIsx5AjyNogSy9t1cmAeQ>
    <xmx:QBlEaX8ERLcd4Uta6oomL2eK_YYV3nb4E2LKbgwIcKf0A1pN4mKN2w>
    <xmx:QBlEaSHuhr4W2yFEJEEtqphv3UlPTfy0BzVCkvK_BcavLPAOsyKoRb85>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:09:52 -0500 (EST)
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
Subject: [PATCHv2 00/14] 
Date: Thu, 18 Dec 2025 15:09:31 +0000
Message-ID: <20251218150949.721480-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3unmoks1zjtfrecqe95q8u1ft5s4ap3q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D6B4A0023
X-HE-Tag: 1766070595-653018
X-HE-Meta: U2FsdGVkX1+w/0ez6cszHioSFfTzK5TAnDGAUM50qW/N3KRWi6u37ly3caTViMSg6dLHZHcB0mqoqyu/lTk8Ocj+GYf8hkPv6bX7VUaeSgDiPeGh0QEO3qcjh8TxvSOnoFOYymFI2/WVnfK2iK6o7L19zvLarFVBCz/ib4o1fqjGKssV9hXbrCWHe6J4IVLWBon9HLmIX3SkfMwKyP4EKCwZYKUY84yI3ICJPQ/at1jwMz00hcVVzoa0AFki4pL9HuzXhkk58s2Kmo7BqGLUKugUwIkdqG3MBb9a+p4dsrjq9lJW5A5R7z44rcRpiLvdh+b2FN5g8svR6rEpuTEajuf7A+fN69IY7dLQLOJOZnyC+S8kv9FaHNS/L7w29DJ9LSHnh+UGYm5DYH4HcpF0AwYNlQY1wbs5y2vd9J2K5nl4IT5WahRQs3dYNYfNodziWqpO0oj6AkDzK+XwK0dLqp5vQNkKqMnV96iTmSyF+4g+Krz+y1F6irQ4OYLPMzOFO/+teaVlOnmqzzZtEmNm+ocMnTw9LkouT+JMQHZEnJMHgvDQdMGtXZXFsvL4H7YtK5RXcMxIGNmE9LUybxeSex09pTeSYSx6SE7tv070hIKncQsBC5IdqzYIW5mRvCLW4j/DQNYXTBW62qsZtEdzHFz0Zv4/bxLUBa7/houa0F1jBL55zY7ObRk2k63JLa5i6Dey19CvOYrBeN4AdpN548TNGOpmfIVhNcdEpfvOv/v2dpuZcGAtFmxAVgHNYHlMorqL0RbqV0aq6hcbOcbxQQwAZ50K+I/JiOmaBbkia4twx/z/MeGvs/TkPrZrj8wa3t5r5VIT8pKXAX5ye0IvxKuJcQQWLi1snyCoLm3s/M75jWtu09w7DBWLUrtTvuo1u4ZVw8WJUgDZnGgRS1THXn5gTgVzL+eKMyQjFLz84mLiwPMa2+ynqlMYq+eHLF0XDkwmbJzmmON3wEFMwYr
 v3w0V+4f
 S86abHh5aF6rBbAkn+hq+D//vYcGMd2ndMuRaQ7twgleZaFJW2VscprU8RtY//WK2nPa/6JoShrGh01YCHveDPAbCt1x9qH8Pgx1zhyXuV8RgPoktpT715ezFoK7LHpExXupQ1LPZC8ehGrPc7vDUdUL8a2lPiFJqaeNwIa/mF8CuMR6wmi+oZmCNeieukwJzo+F3R/BFGaJtbRvW37AA3yn/ONIEqMrpQ67v5cFRovgCs4EntJYDzEAOb9iIC46iKuaj+qwgsw7b7nTEVqax5Ng6JA==
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

Patches 1-2: Preparation - move MAX_FOLIO_ORDER, add alignment check
Patches 3-5: Refactoring - interface changes, field rename, code movement
Patch 6: Core change - new mask-based compound_head() encoding
Patch 7: Correctness fix - page_zonenum() must use head page
Patch 8: Refactor vmemmap_walk for new design
Patch 9: Eliminate fake heads with shared tail pages
Patches 10-13: Cleanup - remove fake head infrastructure
Patch 14: Documentation update

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

Kiryl Shutsemau (14):
  mm: Move MAX_FOLIO_ORDER definition to mmzone.h
  mm/sparse: Check memmap alignment
  mm: Change the interface of prep_compound_tail()
  mm: Rename the 'compound_head' field in the 'struct page' to
    'compound_info'
  mm: Move set/clear_compound_head() next to compound_head()
  mm: Rework compound_head() for power-of-2 sizeof(struct page)
  mm: Make page_zonenum() use head page
  mm/hugetlb: Refactor code around vmemmap_walk
  mm/hugetlb: Remove fake head pages
  mm: Drop fake head checks
  hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
  mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
  mm: Remove the branch from compound_head()
  hugetlb: Update vmemmap_dedup.rst

 .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
 Documentation/mm/vmemmap_dedup.rst            |  62 ++--
 include/linux/mm.h                            |  31 --
 include/linux/mm_types.h                      |  20 +-
 include/linux/mmzone.h                        |  47 +++
 include/linux/page-flags.h                    | 163 ++++-------
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
 mm/sparse.c                                   |   3 +
 mm/util.c                                     |  16 +-
 18 files changed, 345 insertions(+), 353 deletions(-)

-- 
2.51.2


