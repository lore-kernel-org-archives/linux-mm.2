Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2554FC54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E877D6B0153; Wed, 29 Jul 2026 10:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39316B0154; Wed, 29 Jul 2026 10:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D3E6B0155; Wed, 29 Jul 2026 10:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A66196B0153
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 118D91401A9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:25 +0000 (UTC)
X-FDA: 85042115130.07.E367DD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90A382000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltnc5wGa;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xZtdLxdmiCoaJxpZb8xhov05MDUblZHK4SJtXgzdYGI=;
	b=C+1OV3DuKkcAEocVE07EBij3unb/t6AEG1zaa3MIaRKcbl3UInopnpvgHmCaVtC69r9TRF
	nPjlY3umNkS5HrwsoeVEpzcgj4C5Ko9vYf48+XFHcyNpPnMpZBx62qC4WwKn9vmdEQrWiJ
	gKuOq41pKbnJSLzFlZtEdXI9THDG7yk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltnc5wGa;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336983;
	b=rJY9XezXgRiqcE0NV1LI4Lu1WQOmQFx++DJ7foS1CdP3hIcDwLAezdmSx+Eas3RngMSwBB
	vgrgLQ9wiCzOdfGE3JMgfU3uA9Al294s3H05uWzgOs325C9WTd0g6+wHC4ajG0cGUTDuDz
	CsC3gzQg/u1DisvzLWWrSXTPX/yJ8us=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03E08600AB;
	Wed, 29 Jul 2026 14:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814671F00A3D;
	Wed, 29 Jul 2026 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336982;
	bh=xZtdLxdmiCoaJxpZb8xhov05MDUblZHK4SJtXgzdYGI=;
	h=From:To:Cc:Subject:Date;
	b=ltnc5wGayu1pi3ik3Po02ctcCzkjoHm8I2jiB1c/LP7TguQ69DCdpjDHbKLEGg7Hd
	 iKv1+Kwk/WY+1ZCzRe39DOxDAvW4BYQNrmqQsGnwrnREW450hJiCtyeC9lyNV6uZCO
	 oFqw40P2tEQrzu3mqePEEJ783Z5XjlAlvHc1KuNtnszh6FB/iuZQMA+YN497lPzXh0
	 ysV49FmaZHM7zb40V4tS/OSg8delirVjL1in88RZSO/xUXioDQjSDspXgDVHk5ckVg
	 I527rgDIymwjlJjXXKo5efmpkR6w8luW87Yzme8x4ua1Jqah6g3wzTDQOX87X3ZkNH
	 DI5oKuhBhznVg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 00/22] kho: make boot time huge page allocation work nicely with KHO
Date: Wed, 29 Jul 2026 16:55:45 +0200
Message-ID: <20260729145610.2827231-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90A382000D
X-Stat-Signature: snfium9zm6drpzkiu9fnedp1fxcaic75
X-HE-Tag: 1785336983-219353
X-HE-Meta: U2FsdGVkX1+/Hz3yoenCLQMY5H22dENsCj7io9t9Yj5XGrxd4YbJuouTUwLKlFvq08T51gCPtpzkx+7L/aN2Ufi7FuqTZRc99nFTxGNbdnRmvURwVGptsBw/xlv1lIZyxdbLmYeMAgUoU04/psemAA+uaqwqJoxwkQc/poqtNgFWrgzFzlAeZQsop+SerCBl8qyK/DIeYxOSXxlYfPPcDv7YdXEUvrI2ob759CgH9h3+slRuHsTqwlpiXsGL80o8pG4NUl3yT+oMvgGqu9v7hNrtF/454WHvFa71yFkZlD1v7GzCJ9pygGPv4cGvVix8h2Co4CcR1705yhGjc15YdChMl0sOYJ0gKsqJ3dYX7o0aebXMwklva563LoVJMPuyf0UDHYMpjqxh5AYxRLfSvKjoUgnP8WuJqFFDBGDRPz3h8pjIPqL09zYXamwgb7g7VcpfWQe447GVNngzWRBuVykqYmPCErSmh8HIk8p/Bn2/poUj01w6nXvwFMwYnx933RXBF/9TM/Bo3VJg0H7tHYzBxcnh2ANn9MXdIctXppG4RL/vwn2AYa7xMxOszPKO3aYEzGYqaLDvMuKwdmXiq8fkv/QLdjRCZSL+O3FXOnbN+EtPcrZkTqHwecyINLhpOMv8MuARYrvnTAA95dqwq2b3CvOjxvbFmurwRGK12fZcD0IDVTNJ0HwGiSx1Ziy+rAs4EvgIFDqdgV/Xd1W3C7It/urSSeYh2A9aQ//J0mdtBc/A55Mi+qdxSMyb8CGauveYYyDZKlpkQo1p4lkuNgESdGzW7qqudH8afEDZIlgKLks6PvIu1VoXbwh7LRHLlOftPhLLqw1deQ4ZdsbvD5NVjFrp56uXUN2V394P6JtZCeItdoc4+RRCluLs10FDjd95YnCGP8vIBUsNaU2mCkHaATLWLprmG5AQT8qCy4F5jcAlyrpQZjpOBqZjh3s/o256/3NmMR4/F0AbhAB
 FU+qgXxt
 2tc6lOZyx0BBuFYxqbNCKoTxLYjleN1JEI8ewgkT8WQNQW5jPViG5D8PNRx3oE7RY5rOIGegzCijITju4Q1f+ntZmxStrrLhHMbfJcfkDugSRbnOnoAdWX4P3WJ+WV02HhSq6pRs5dw6YiDgzNtUJPPuHgWa5axvAoyxd7/ErdncRPLAVyVe+chbzZHdl94niPa551tdbvXKgr646C+ozg849T4zxLQhy4pGr9q44l0t+t7X+n1aCWprSxa+yt6dHTDjQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

Gigantic huge page allocation is somewhat broken currently with KHO.

First, they break scratch size accounting. Since they are allocated
using the memblock alloc APIs, they count towards RSRV_KERN, and this
scratch size when using scratch_scale. This means if huge pages take a
large enough chunk of system memory scratch size will blow up and fail
to allocate.

Second, scratch can not contain preserved memory, and if hugepages are
allocated from scratch, they will fail to be preserved with the upcoming
hugetlb preservation series [0].

Fix this by introducing the concept of extended scratch areas. They are
areas that the kernel discovers on boot by walking the radix tree and
finding free memory ranges. See patch 10 for more details.

Discovering the scratch areas needs some preparatory changes to KHO, the
radix tree APIs, and to memblock. Patches 1-17 do that.

Patch 18 adds the scratch discovery logic.

Patch 19-20 add the dedicated memblock hugetlb allocator.

Patch 21-22 fix the scratch size calculation with using scratch_scale.

This series is based on top of the liveupdate/kho-scratch branch.

[0] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u

Changes in v5:

- Fix memblock test compilation because KHO headers are now always
  included. Since some stubs also need to be added, move the change to a
  new patch "memblock: always include KHO headers".
- Reset start and end to default values when opening up search to all
  nodes in memblock_alloc_hugetlb().
- Update search end instead of start in memblock_alloc_hugetlb() in top
  down mode.

Changes in v4:

- Commit message fixups.
- Rename leaktrace to kmemleak_trace in memblock_prep_allocation().
- Move definition of kho_scratch_overlap() in
  tools/testing/memblock/internal.h to the patch that exposed it.
- Rename KHO_EXT_SHIFT to KHO_EXT_BLKSHIFT.
- Add a comment above kho_decode_radix_key() call in kho_ext_walk_leaf()
  which makes it clearer what the key is for and what it decodes to.
- Get rid of kho_init_scratch_migratetype(). Call
  kho_scratch_migratetype() for each pageblock.
- Use Muchun's patch
  https://lore.kernel.org/linux-mm/20260612035903.2468601-6-songmuchun@bytedance.com/
  to simplify migratetype init for deferred init.
- Drop #ifdef CONFIG_KEXEC_HANDOVER around KHO includes in memblock to
  make sure it builds when the config is disabled. This is because
  memblock_alloc_hugetlb() uses kho_scratch_overlap(), and KHO header
  provides a stub when the config is disabled.

Changes in v3:

More notable changes:

- Refactor how key width and table depth is calculated.
- I noticed that extended scratch breaks migrate type init during
  testing. Below two changes fix it:
- Remove memblock_is_kho_scratch_memory() and kho_scratch_migratetype().
  Instead, add kho_init_scratch_migratetype() and rework how migrate
  type for scratch pages is initialized.
- Move migrate type initialization from deferred_free_pages() to
  deferred_init_pages().

Other changes:

- Use kho_get_mem_map() directly in kho_populate() and add a comment on
  why it is okay to use.
- Don't say "export kho_scratch_overlap()".
- Add a comment in kho_extend_scratch() that it should always be called
  after efi_init()::reserve_regions().
- Get rid of memblock_reserved_size_flags(). Use
  memblock_reserved_hugetlb_size() instead.
- Define KHO_EXT_BLKSIZE to SZ_1G and add a comment explaining why the
  size was picked.
- Fix memblock tests build.
- Rename kho_ext_walk_key() to kho_ext_walk_leaf().
- Add some comments around the kho_ext tree callbacks to clarify which
  tree the function is called for and which one it uses.
- Move initialization of kho_in.radix_tree to kho_memory_init_early().
- Do not check if the tree is already initialized in kho_radix_init_tree().

Changes in v2:

Detailed changelog below.

At a high level, the major change in this version is to remove
MEMBLOCK_KHO_SCRATCH_EXT. Keep MEMBLOCK_KHO_SCRATCH as the only memory
type and mark the discovered areas with it. For HugeTLB, add a dedicated
allocation routine and if allocated memory lands in scratch, do a retry.
Also introduce MEMBLOCK_RSRV_HUGETLB to help with accounting of scratch
area sizes.

- Fixup commit message in patch 1 to make namespacing change clearer.
- Use @key in kernel-doc for radix functions.
- Add a runtime check on key width.
- Move all mem retrieval logic to kho_mem_retrieve().
- Add a comment in kho_mem_retrieve() explaining why mem_map won't be NULL.
- Rename callbacks to ->leaf() and ->node().
- Fixup commit messages.
- Clear tree->root in kho_radix_destroy_tree(). This lets the tree be
  re-initialized by calling kho_radix_init_tree()
- Add kho_get_mem_map() earlier in the series.
- Export kho_scratch_overlap() and use it in memblock_is_kho_scratch_memory().
- Get rid of MEMBLOCK_KHO_SCRATCH_EXT.
- Introduce MEMBLOCK_RSRV_HUGETLB.
- Introduce memblock_alloc_hugetlb() for hugetlb bootmem allocations.
- Refactor memblock_reserved_kern_size() to allow calculating size by flags.
- Exclude hugetlb memory from scratch size calculation.
- Collect R-bys.

Regards,
Pratyush Yadav

Muchun Song (1):
  mm/mm_init: simplify deferred_free_pages() migratetype init

Pratyush Yadav (Google) (21):
  kho: generalize radix tree APIs
  kho: make radix max key width more obvious
  kho: disallow wide keys in radix tree
  kho: return virtual address of mem_map from kho_get_mem_map()
  kho: store incoming radix tree in kho_in
  kho: move all memory retrieval logic to kho_mem_retrieve()
  kho: add a struct for radix callbacks
  kho: add callback for table pages
  kho: add data argument to radix walk callback
  kho: allow early-boot usage of the KHO radix tree
  kho: allow destroying KHO radix tree
  kho: add kho_radix_init_tree()
  kho: expose kho_scratch_overlap() to kexec_handover.h
  kho: initialize kho_scratch pointer earlier in boot
  kho: initialize preserved memory map radix tree earlier
  mm/mm_init: don't rely on memblock to get KHO scratch migratetype
  kho: extend scratch
  memblock: always include KHO headers
  memblock: make HugeTLB bootmem allocation work with KHO
  memblock: add memblock_reserved_hugetlb_size()
  kho: exclude hugetlb memory from scratch size calculation

 include/linux/kexec_handover.h                |  25 +
 include/linux/kho/abi/kexec_handover.h        |   9 +-
 include/linux/kho_radix_tree.h                |  44 +-
 include/linux/memblock.h                      |  23 +-
 kernel/liveupdate/Makefile                    |   1 -
 kernel/liveupdate/kexec_handover.c            | 526 ++++++++++++++----
 kernel/liveupdate/kexec_handover_debug.c      |  25 -
 kernel/liveupdate/kexec_handover_internal.h   |   9 -
 mm/hugetlb.c                                  |  22 +-
 mm/memblock.c                                 | 154 +++--
 mm/mm_init.c                                  |  45 +-
 tools/testing/memblock/internal.h             |   5 +
 tools/testing/memblock/linux/kexec_handover.h |   9 +
 .../testing/memblock/linux/kho/abi/memblock.h |  10 +
 tools/testing/memblock/linux/libfdt.h         |   9 +
 15 files changed, 650 insertions(+), 266 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 tools/testing/memblock/linux/kexec_handover.h
 create mode 100644 tools/testing/memblock/linux/kho/abi/memblock.h
 create mode 100644 tools/testing/memblock/linux/libfdt.h


base-commit: 08412b8c707fdbccb7bf2116f0554fe09113cd53
-- 
2.55.0.508.g3f0d502094-goog


