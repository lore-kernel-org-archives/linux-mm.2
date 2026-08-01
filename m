Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458E6C55175
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FA86B007B; Sat,  1 Aug 2026 04:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0006B0088; Sat,  1 Aug 2026 04:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5D16B008A; Sat,  1 Aug 2026 04:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A443A6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AB09A146A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:00 +0000 (UTC)
X-FDA: 85052075640.04.5A4E2E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 637ACC0002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:48:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVwYHLmN;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7asJfnrthwfJPU/ImVGAUedz7QigUY6doZPItgOT9jM=;
	b=GhmdrIVYX0H6VbH2Hf/87p2sHfW+ipdUFrQQOw1y41QVP0OP60Xphp3rxPQJaAwPOrhkgr
	ba170sbLV2xwnOJDYc8Xw9mP4PeMz+Ix0GzjjLKbwtMxWM8JDy/LbY4wvLodn+DmQeKbYc
	n15nrM+0VusYzA0wZG7NWWvEZ8KqQ24=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVwYHLmN;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574138;
	b=n2TCiqmxLG10az1dpJ++h4HHglXj8lT/vhGcj9waPaZ7plri2mI2va/qwazX3p4ehPam6L
	03g6kDkoHx2+jc05UkpZXC0I/3bIOLql8K8ROwk1m3oWZpwU65uLMdyP1oPBwIj99F22Md
	e/w5j32FhfA6rbOSbvlxI8sZYypX79U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFAA24374C;
	Sat,  1 Aug 2026 08:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891741F00AC4;
	Sat,  1 Aug 2026 08:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574131;
	bh=7asJfnrthwfJPU/ImVGAUedz7QigUY6doZPItgOT9jM=;
	h=From:To:Cc:Subject:Date;
	b=DVwYHLmN1+a7P4P+S6Zsy/REgMTBFNANr4zg49Wrt0Kl7oiZhVjGERysUKfDgYtPV
	 A2q/v6xK8kipe9ReAfz68nqMvBlCdet2wbww1sOyOevPqke4KRe3tAIb5AFaYWPmQI
	 s8dMp9MubjAuia3A3fv0Rtqz5LwVds5Ck45SRRTNRHNpUyQPMEMelwmz8WqkDvD4OP
	 aHCBQ49GIpAN4TS8Qb2T6ABBEsOi0R1El0sdm/uO56Uujrvh2sf6ZQjBgAilkxrrk5
	 wzoFNQP4TZymqZrgd8LIX3j7yYwhigCE9HLcwMrgLC40NEqVhZFTf5yga2REgxfavF
	 L6wHg0bKtY9pw==
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
Subject: [PATCH v6 00/22] kho: make boot time huge page allocation work nicely with KHO
Date: Sat,  1 Aug 2026 10:48:09 +0200
Message-ID: <20260801084833.1897543-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 637ACC0002
X-Rspam-User: 
X-Stat-Signature: msuayoxnxpbtf6w3yrab7jbu1mbrrkx8
X-Rspamd-Server: rspam04
X-HE-Tag: 1785574138-963741
X-HE-Meta: U2FsdGVkX18ZtZjBK13GfQtzg3nIUIaszsp4AO6a4bSmG0NsQ0jgbQOQXI/PxNRmlhYtlJgwkXVMHOqjDj7uUnW4leCFvT+njB5IEbQ0hXGnEghctlj6uWPdYzq37b5h2U2JpIA387Jtr4qgr4S2QoY6HmPqyFjBdYbw0M+OZxa77QY+X4rm0wmwn/0sYnuUsX44OerzbrgpKPucctnjgsb5fjCYQVTWbv4Ke8KvrIRvtco24TtWx3WUYd+s5cTGVZj74s2gpNg09eOPmHQDLqT54vHBNMeW3p9psJpC8tc4hRawFBDxkUenzr1mM6hN0ODCT22LOG0NTTfeS6iXfBqOs7FjL0zZltLe5r/1dCEbc4wRaQIOsxGIRyR+7UYwmy7O7X/br08Rg3e9o6zPQK6zFO+kRreyGxC69EKcIT8SaaPeQJXqbgH9KNTuRe72UAedOa18sSw3LpLtarY3ufVkJ0CJxvXVn1o8UCk1zh/lHivnnizBSSHDMZ//IWcsO8/p7DnmhoKH3w9uaU7z4a/tU+gMZ2XFXtaHEbf2tPbZ+BRv3HJJHDM2z+E6wqwgIKI6w+QJVo9zTZ0YXA1vHTaXERJ20ecLWGgkUVjaRf3TXSf/WGuVzgR4PKC0uekeb/4BlQVFlXF0v1CpsTrPAmqG+Ug4nA35wBtK12hlt1bd4KO8ricG+qcaw5OYSoTQoAECqk5Ehkou2qtIpYElesydN9Z1eEzGeYEekUt3za3zWxfM1PWdQMMYYOZu99/dsNcAo5o/yhFaHsKmvZx3IFVqrfzC70mM/NF0Tqv40qDXZnAnYKPFuMPWSdX0hpoa6nEu/27nbG1OJXvP6YENSp+ZTATri+Vm6dOEJ7NDft49TSzSap8TwRfxI5p6nWMXj+gQ7UKtekYdd6IfmUgAsM3AYJxsTYY3widZ282g1YswTp1AhStk+4Mb3ROItRPP3qYxflOWG95xJDFEwi8
 6qtGzCPH
 h5+gX7c8X8ot8AgdJ3IbvRUOUGnQshtaMvCEL1MxfO54Lf1jEcUpD3awXzmcxwkJJfcmzQB5gFuwRubQpXdnro6Djp34Xt2IEavIW9KZhCIYwXIpIeQxtb+edcMWq+St4ON172ufQaH0TE3Gv0cKfio4ZE3i5daO5yL6foJyDPlkGSxsJ8piPSascBUYGYn4Lo8oBHYgkomSoypT2/8HMh03RX9gkLjHElnSrzaEl15cveJT4pk/Z+JfZJTH8q89ghp5v
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

Changes in v6:
- Rename the radix tree in kho_extend_scratch() to busy_blocks. This
  name is more descriptive.
- Make lockdep happy by setting a different class for busy_blocks.lock.
- Make KHO radix tree documentation generic.
- Use mm.h instead of mmzone.h in kexec_handover.h.

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
 include/linux/kho_radix_tree.h                |  60 +-
 include/linux/memblock.h                      |  23 +-
 kernel/liveupdate/Makefile                    |   1 -
 kernel/liveupdate/kexec_handover.c            | 534 ++++++++++++++----
 kernel/liveupdate/kexec_handover_debug.c      |  25 -
 kernel/liveupdate/kexec_handover_internal.h   |   9 -
 mm/hugetlb.c                                  |  22 +-
 mm/memblock.c                                 | 154 +++--
 mm/mm_init.c                                  |  45 +-
 tools/testing/memblock/internal.h             |   5 +
 tools/testing/memblock/linux/kexec_handover.h |   9 +
 .../testing/memblock/linux/kho/abi/memblock.h |  10 +
 tools/testing/memblock/linux/libfdt.h         |   9 +
 15 files changed, 668 insertions(+), 272 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 tools/testing/memblock/linux/kexec_handover.h
 create mode 100644 tools/testing/memblock/linux/kho/abi/memblock.h
 create mode 100644 tools/testing/memblock/linux/libfdt.h


base-commit: 08412b8c707fdbccb7bf2116f0554fe09113cd53
-- 
2.55.0.571.g244d577d93-goog


