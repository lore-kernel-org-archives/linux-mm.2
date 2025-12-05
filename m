Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECFDD3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445196B00A3; Fri,  5 Dec 2025 14:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C856B00A4; Fri,  5 Dec 2025 14:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332F76B00A5; Fri,  5 Dec 2025 14:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8636B00A3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:43:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD60813A85F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:43:58 +0000 (UTC)
X-FDA: 84186442956.19.9019902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C749220015
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:43:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VwQdtITy;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963836; a=rsa-sha256;
	cv=none;
	b=k0CsTXKLvc22kNGFXdq7zk2z3ikaBynjT5JzeARtg4+asHPytN2kvTYTJBo1/QnowoZtuz
	tjI4jixG1u8mYtvczrH1zKaTRvK4Nvemnm+YABpodNEnO3a4Ab/+0C0cBKvugOKj/PnY8Y
	QKAURSPC/3tKRKdO6pQWndRpz4Zk2Yc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+2isH8NiZrMMPHzWeNBQwdyUTbSlmrHIlT24vW7klNU=;
	b=rzZyY125BFcyryuvA7PzfaN7cmZvhHhbOwjJACR6T1aA70euy5oLwQKuT+vJWHIzoCh2he
	vIJxxt29XVmBSpCTD1Noo4ar2jQ3zjuykepy5RMnRq97Afzt+gFrxmCLJOQ5niCksbOKcU
	llAEAyIghVV3NPcKFVrUbU89Q935F9k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VwQdtITy;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F19160010;
	Fri,  5 Dec 2025 19:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D28C113D0;
	Fri,  5 Dec 2025 19:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963836;
	bh=IE3A7Bzdjrv2H3PsxZzz8Z5SPq9tyuKSoKo5G47PsRw=;
	h=From:To:Cc:Subject:Date:From;
	b=VwQdtITySOIrJw3EAMp49mTzaNsUq2+g8p9+k0n8CtvnlqriXPefrlabDfU3qgBcg
	 pjAG3sU0FstGyPb99LX9JHyiE84mCoWHl6bNoP6osZSBEeAPROaXrBGLC0CwOzxOld
	 56EUzm8W7D8T6yJmOmx7M4hw45bl2r0TJqf3caNgPhAdCLzbFudHmXr+cgtG6LrLKS
	 miZr1wcUhVwezji+/u1QsBRXQaboJ7ONWm1OcmLLtSV0TW8O7nR/XE0Xe63j8/r8sG
	 OqXBgL1xFXoinpr16TDxVIXTNEDfC/j5HPoaonlziRmKKGmkkDpwUovzY6VovXikqx
	 KK6vesSRRp8ag==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9D658F40070;
	Fri,  5 Dec 2025 14:43:54 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 05 Dec 2025 14:43:54 -0500
X-ME-Sender: <xms:-jUzaSHOwFvImqw4N7zvllybpT61Jwo3O_80sZ7auoimCZNDbtZttA>
    <xme:-jUzaXQpbIqDK4I7pCHiU7J3dUhzHIFiOi9LtY_P4dDmucOZtDrhWbqkv8s-lYHm6
    XeLUUGUEFrRR0U0z123r0olnobO5ybCKB5MTzkcnWyBzblVc4tD8lA>
X-ME-Received: <xmr:-jUzaQuVMvA9jOjO4grLbJYCCwWS8RcTT7QnG_NFcKiBvmiZSiOnDIHj4AksXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhhuhht
    shgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhepff
    dvhfdtgfekuddttdffgeeljeehueffvdfgjeejvdetiedtfeefgfetgfffhfffnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeg
    geegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvg
    dpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegr
    khhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutg
    hhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtg
    hpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrges
    shhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtg
    hlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhr
    tghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:-jUzaUBhO73Covcu8c31Xr5Q4PA9pFaDUSbBVChHRcFA7rgDkc9FYA>
    <xmx:-jUzaddFiycSZNK-3Uq35waaAq0L5zZNv5JHjA3QT4fZRxTgig1Uxw>
    <xmx:-jUzaco4L30e0AIqTXWcvxgU-50cYbMFZ5ZMOSuaf_PPFkg7rvcfjg>
    <xmx:-jUzaR7iDmVB08dSTGOAajYjCSHLQbaUC4v-RtRFk6ZZEUXXy-9HUQ>
    <xmx:-jUzaUAvhPi0bZEpd6IPVJYlQvoDzHUKwW5-8o0RxPmfIfNSlsXupVkZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:43:54 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap optimization
Date: Fri,  5 Dec 2025 19:43:36 +0000
Message-ID: <20251205194351.1646318-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C749220015
X-Stat-Signature: 6zdpky1ywtwzugowamtz5prjdbpziqpi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764963836-24676
X-HE-Meta: U2FsdGVkX19MqWd0F4f4an3+fynvavB8+5oSXrB25acvZeqcPq8fgXWCgMcpPMtHvuBcLCcsqQLlM+mINui2jzQH/9T2i0SD/8qXgqfmnZgxpbLawqB1RNcjRUW4qheKNLTh0W9Bxgcf0dL4uoJtkBy9QNTbNOMt8iC62ELj/BMJvm+qdY9H9OIQOm2R36wqU1UHRkOB3PL+dUY9pGPHt6ZLmr5uJC2+aeBoIcHAFWcPFA+zsziy73aWrGniXPuZxqVa88sUuotqcZWGpm3ObdjyYfFTDLcyHN3K0rHEk3IgrqlIUnKvo2oaYov2IVXVkEiSkzClsBqWaF+kPaV188ZzjnZvbje92cnzpJLltSFzOCnPCvc2J33MY0mKjxmx2umcBCbMEZbmGnsJcim0tVXFJ5RPU4HU0+YdRcKcqApfEKbX/tqhn89L16+YOSWLN6XEHLQs6Z+wg+6Q52DYH3swOeNror6Edn/Xe2tUw8fbhzW+wfJnJ8Sr9W46BYE90LWIA7U4cPB6h/PVXVFTOSBk+GzVTmsHOA0pzwI8K6aQQ1oiDkqftkL3Vf5QWg0JzNahEZmwYbWaTC6ctZZdWR5ygXAAFHX2rp0SCFKM/W+QyDYCQdYzfvVMQR8l+J1BHgM5N8Yx7ZVCMh4q0mAnZ/z6FFHZKA9n1D40R0EbhokyiFuRhzf9yKqdgwHJLl4fQenET79YF4/bjyRkKE/yR/+2nOFuwQz+9yEKRkkMT+mFd8BB4tAIywGH+KGMDI+dPscZeUxSb16BROYETmu4Imjkggv5gzcRhS6gPOYbNoIRAu7Riz0tFHJv0Ds6yVJjSQODB5+KzP/D6bAbPMgyrCcVucWeO6Ud/pIEt+ZPwRzsQwc3J9N4vcFwFTJu42ltd+wRSeZ1Mo7DpozBKS4DA73WdSBFKLf/BoM3thS0J7WPnOG0i2zhr+cme3NhYGjW46g2ouk6EbPqKokkiV3
 QpZsWte3
 txJS1sUbEL4ndkohOHfgp2RtYDh0izU3fVpZHNRDyA0J1au3YlEiHRjqrSs7WarupRw1Ko+gMkgOR8G9VhohG/rnrxvdbqNzAtsO+IgflUXy9bYSxY4q1WlwFnLigGINd0RZaGvmikGuld20XV3ZVF9R3Xs2eqbcAQ72I8kU6fTsfetteDuzOh01chqR89iURSzHNsDscXFyFE5n8Y9nOru4RAd4UkFs/qRTEI21OduMVrRU=
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

This enables a key optimization: instead of remapping tail vmemmap
entries to the head page (creating fake heads), we remap them to a
shared, pre-initialized vmemmap_tail page per hstate. The head page
gets its own dedicated vmemmap page, eliminating fake heads entirely.

Benefits
========

1. Smaller generated code. On defconfig, I see ~15K reduction of text
   in vmlinux:

   add/remove: 6/33 grow/shrink: 54/262 up/down: 6130/-21922 (-15792)

2. Simplified compound_head(): No fake head detection needed. The
   function is now branchless for power-of-2 struct page sizes.

3. Eliminated race condition: The old scheme required synchronize_rcu()
   to coordinate between HVO remapping and speculative PFN walkers that
   might write to fake heads. With the head page always in writable
   memory, this synchronization is unnecessary.

4. Removed static key: hugetlb_optimize_vmemmap_key is no longer needed
   since compound_head() no longer has HVO-specific branches.

5. Cleaner architecture: The vmemmap layout is now straightforward -
   head page has its own vmemmap, tails share a read-only template.

I had hoped to see performance improvement, but my testing thus far has
shown either no change or only a slight improvement within the noise.

Series Organization
===================

Patches 1-3: Preparatory refactoring
  - Change prep_compound_tail() interface to take order
  - Rename compound_head field to compound_info
  - Move set/clear_compound_head() near compound_head()

Patch 4: Core encoding change
  - Implement mask-based encoding for power-of-2 struct page

Patches 5-6: HVO restructuring
  - Refactor vmemmap_walk to support separate head/tail pages
  - Introduce per-hstate vmemmap_tail, eliminate fake heads

Patches 7-9: Cleanup
  - Remove fake head checks from compound_head(), PageTail(), etc.
  - Remove VMEMMAP_SYNCHRONIZE_RCU and synchronize_rcu() calls
  - Remove hugetlb_optimize_vmemmap_key static key

Patch 10: Optimization
  - Implement branchless compound_head() for power-of-2 case

Patch 11: Documentation
  - Update vmemmap_dedup.rst to reflect new architecture

Kiryl Shutsemau (11):
  mm: Change the interface of prep_compound_tail()
  mm: Rename the 'compound_head' field in the 'struct page' to
    'compound_info'
  mm: Move set/clear_compound_head() to compound_head()
  mm: Rework compound_head() for power-of-2 sizeof(struct page)
  mm/hugetlb: Refactor code around vmemmap_walk
  mm/hugetlb: Remove fake head pages
  mm: Drop fake head checks and fix a race condition
  hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
  mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
  mm: Remove the branch from compound_head()
  hugetlb: Update vmemmap_dedup.rst

 .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
 Documentation/mm/vmemmap_dedup.rst            |  62 ++---
 include/linux/hugetlb.h                       |   3 +
 include/linux/mm_types.h                      |  20 +-
 include/linux/page-flags.h                    | 163 +++++-------
 include/linux/page_ref.h                      |   8 +-
 include/linux/types.h                         |   2 +-
 kernel/vmcore_info.c                          |   2 +-
 mm/hugetlb.c                                  |   8 +-
 mm/hugetlb_vmemmap.c                          | 245 ++++++++----------
 mm/hugetlb_vmemmap.h                          |   4 +-
 mm/internal.h                                 |  11 +-
 mm/mm_init.c                                  |   2 +-
 mm/page_alloc.c                               |   4 +-
 mm/slab.h                                     |   2 +-
 mm/util.c                                     |  15 +-
 16 files changed, 242 insertions(+), 311 deletions(-)

-- 
2.51.2


