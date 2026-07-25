Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A81C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A9D6B007B; Sat, 25 Jul 2026 13:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013556B0088; Sat, 25 Jul 2026 13:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C596B008A; Sat, 25 Jul 2026 13:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B65416B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:21:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 319FE1A0362
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:21:48 +0000 (UTC)
X-FDA: 85027966296.15.AA6C11E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AAA15C0009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:21:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXutIP05;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7dyLDTbuNQ4Mnu9158Q9qb9Rt9Em+4XSabywoE206Cw=;
	b=3oKRPbApH1MoMn1E+g2adBI8SLa1VzuNZ4teXXD8YesV45mf8RyCoRkk0mcWbQSbwvIcJZ
	GrDZT5vPmtDdAb6xRGEwP9ODwNYL3mKTsCCW6UDz05FrLV7edjZ5UVWY9h+3Os0Y6/ZZcO
	8odM49Wnd4VP/azUKgmoEET0xQwiTlQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXutIP05;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000106;
	b=ld3JNKsYx/Uyby79jA/IpAIMYgo6Ik273HLaPW6rF2b+sXdwoKPwKucP91LpRFco0LnVJP
	9mz9R6MCGiGBYKznlzuvrIJSSGXYFEsV9H/b8zUjdAqJ2tt/GtReoNZcr0f4ik+w/Qg9yC
	NrQ9qY8xASa8uBGuTZSaUa0YlDBs98A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 158E660A6E;
	Sat, 25 Jul 2026 17:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9680D1F000E9;
	Sat, 25 Jul 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000105;
	bh=7dyLDTbuNQ4Mnu9158Q9qb9Rt9Em+4XSabywoE206Cw=;
	h=From:To:Cc:Subject:Date;
	b=kXutIP05PHKcUzLMdZRTJpvovjOLdtpVVt8KYwQmxS7nnaQetnkvmwIG0x93vYcaZ
	 QE6QP8+gPQ1xt+Yd214BzNCTNfBQd2dekM/kpbQcxnEyBTwTWbTEkKAa5WG5zJsLpg
	 8yLy8h1qCz6bRvuVFnSu1+c46gwdBR7ESuQhg1LdBxZtVXGHjVMV26kVFh5lf5k3vq
	 ilcaYUwUh1Qy3Vaqnzvs4WDfUIbjEqjo4VNJwK41rlSiU6tBlLJUZDTP9Z+l8Mr6ot
	 wvOrllJSIcUkTjc8bTDrTm9cFaO/JGU8IRKPd9ypUMAeIpx4aIVlIe764oRGtzzU/Z
	 fT+vF8cx+owIw==
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
Subject: [PATCH v4 00/21] kho: make boot time huge page allocation work nicely with KHO
Date: Sat, 25 Jul 2026 19:21:00 +0200
Message-ID: <20260725172133.4018491-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AAA15C0009
X-Stat-Signature: 1zpbp4f5szif1yj5atftkbhtuqey1cmb
X-HE-Tag: 1785000106-706319
X-HE-Meta: U2FsdGVkX18P9B26DRprTuvciFguMTpaRqMj7foFzoxr9MUDt+YXtmqKMyo6jihjkNC+EpjrO4U0vAqiyh2TmVeRqKKH7kErO9al3HnR1/XrARlh8wy6You/tk9vSl1tUMtvf1/9C77/0Eoj6NZ1Wfpnh7sErm5trvDU1IMDuY25qBM7+f87i7XVkA4iSqClreFcyHF1TOcMM+aQZwop+WlA4lAPoIIvtMI0UCQAu4XUrrYJIKK9HYF1DA21Og5Whkmkxc7/042DtYU7ODmR0k2Ohl0wvfAfNSRhnVHUbDZNTA+mg3GgWe6e4AErAtzLmr0R7g9Ke0ojJ0unncmTRtLY4KRbExSX5/L3WaZvO1cRKe0qYVoWShZTGi7fciG93pKHhffr00X4SK0j0fcdUIBX9S8VCpv63Oznsp/64lgK9aZSLJQNXxoQmQDN6ETKXGaW7wZPLVRWRW53lALQ2l3yMnIAfkJIUWfVjEZ0znls68KpktUDpCiYyuZGNjkCHnK3Doyl0yGPjcDn+AK5X4PlemtKN1BubdTomuE8+ARXCQPveej2Cg+5comij7KSluJ0rHaRNpZYZc5faYzneZbUqr6T94fbl60t2F1tV8x+sA5Biiz1MeOm31aX2DctqUfnDNZPQbFohb18ZHWc/dNfhHMCO0sF2B3RDFeB80TUwIcsfsbKrdXEELch4e2DnTTp9DQ2piYEal4hrGQYFxgYTuE37kZrrbRoRHXDOxFmCpSLGCZESeOwhhBZs2bd0OD1tK0GVbGasix0J2mL2GxDctVbs602qSA19nO8s9blMXla6q7TsgxqVOy99FjZa4EzgjLhW0ETpviY0O+JBRX+oqV1vSX/pMt3xRfnUjMj3+jkA4htT+cFLfHh8DZ52YdGYw8qxWZd6DYisYYFmvprq374WAtbv4ihyy2/pQnfmgIPCmeuhQ75hYzWU8sWmKU9hmNQCH6YKqYG8vX
 qD+0mexd
 ag0itLl15bD5MhwxIeOioJeo9R7L/f5/o1D0AqVQbufGD9E4W2v46Xvrs8LMKRYrLhehQ7ByvnC4aEXq4ql54nu29DxJLCbp6vz28EDTwKtwQr07AxoUNaqhs8oAmViUaF7hfDEqApyWEtIKy1dyuQLp24gGWGsdn9PwXaOPoMTUa0+jPe4H44WutAfbIGM5WRvEp+nBjUYQaAxXkUc3CtQcovmCesn3XlE1p6mD9v9hiMHCsJSTfMxOnQjXPgubD8p09
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

Patch 19 adds the dedicated memblock hugetlb allocator.

Patch 20-21 fix the scratch size calculation with using scratch_scale.

This series is based on top of the liveupdate/kho-scratch branch.

[0] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u

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

Pratyush Yadav (Google) (20):
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
  memblock: make HugeTLB bootmem allocation work with KHO
  memblock: add memblock_reserved_hugetlb_size()
  kho: exclude hugetlb memory from scratch size calculation

 include/linux/kexec_handover.h              |  25 +
 include/linux/kho/abi/kexec_handover.h      |   9 +-
 include/linux/kho_radix_tree.h              |  44 +-
 include/linux/memblock.h                    |  23 +-
 kernel/liveupdate/Makefile                  |   1 -
 kernel/liveupdate/kexec_handover.c          | 526 +++++++++++++++-----
 kernel/liveupdate/kexec_handover_debug.c    |  25 -
 kernel/liveupdate/kexec_handover_internal.h |   9 -
 mm/hugetlb.c                                |  22 +-
 mm/memblock.c                               | 146 ++++--
 mm/mm_init.c                                |  45 +-
 tools/testing/memblock/internal.h           |   5 +
 12 files changed, 614 insertions(+), 266 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c


base-commit: 08412b8c707fdbccb7bf2116f0554fe09113cd53
-- 
2.55.0.229.g6434b31f56-goog


