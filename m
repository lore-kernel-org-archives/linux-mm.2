Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D14C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A086B00A8; Sat, 27 Jun 2026 03:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019A16B00A9; Sat, 27 Jun 2026 03:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A256B00AA; Sat, 27 Jun 2026 03:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEC936B00A8
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:24:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DCBE140671
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:24:50 +0000 (UTC)
X-FDA: 84924855540.18.3E33783
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0DEB140007
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:24:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/vYdOKx";
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545088;
	b=wZqgSb9m7t824yQ+/AZth71ELt6tzOYR4rsw1l/Ck51E/5Yz+n9uVSKxVwYREVcgWFKwjI
	lAuLIMTPvhq4jT/7UDdSyHjNXJQBaljegfWv6F+6ZDVxykbiNzQeXBusBV7F0yN6/WFWhB
	jEcGesYknY/XX+xwdyu4PmJRwFZkZBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NQdcHPxDrEBhFiblLpcWfzToAlt+qmr/LfE1ctvG9DI=;
	b=wDKmiDpN8emIaYRs2qm/M+7Yme647gkKJKr5gOesglhlVMH4KR/l2HCJ6Abu7LdLcfPTqe
	HTKuR1zG7xhbj+QJCm5wVCqYO/zT4T+CBJ/Uk85Zmg6fQTabRmGRpMUlNI14KjXs1lc6st
	XOJEMqZJDk5at3rZSL64M0WtLvf188w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/vYdOKx";
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NQdcHPxDrEBhFiblLpcWfzToAlt+qmr/LfE1ctvG9DI=;
	b=s/vYdOKxRQPReBLZmbAOAK24B7a3gHz7B35xfMdthD62oSvuEtgUjtZbORLkIZ8AGIlGO/
	I20SSECLdW+Tauf0IR0QoVy1DvGaONdX3wjL+YXm28+sbQvIV03RKlyYmefsC9Vwhmz9Gc
	PYVcWLt+e6YSPvZ6QfVPeuaXuonoVLU=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 0/8] Introducte Reserved THP
Date: Sat, 27 Jun 2026 15:21:48 +0800
Message-ID: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tfgrm43x6a9bd7m67kaeqzxf4cochri6
X-Rspamd-Queue-Id: A0DEB140007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782545086-212631
X-HE-Meta: U2FsdGVkX18Ui5wYMRv78g/57YsAjkxGSwFqSW2HbEJVlZKPQ9+SMywKvOUmrmuHZktI49fK+40yTwhcOcWq99IjPu9lmSrsJ3dJIlpVejf1t3TBEYsST5Wqq/ZJl0jNzbsm5XY/+33JZIJ9otZwJYRCw1FKAY7TIf6K5VYGGZPl2zXTgceVu4cGtqHuzJFoZkwHa1iQzC2nKWfbpbqhedkAfvRxow/zjF4wh7FcbfuYTe/UMz6D911jp7AWiWkZMktgI6pF0pFiYmHOoGugPUME5l/v0wKeKATPNE+ks0BkcAUq5JVaU5u6s+7x6NxG2Ei1UMGSYlDnlKli8WLPc28eARZ6pppNw3ModxX0GOlJhPwLxHYCubghXRYW9+GcSftmWBHPStCmkPYl1v8g/QdUMkAM5IqOG15WXKX2/tVc7G1yvJXLNhSa4VDK/wwXcP8TQAOdLJhNuMHm2+GJFdQ73IH2NewNqViiYZBc/QQLiBniB3CGDrqRSwiv7Bh4l9bu2PGYz3T0f167ij34CxI6ncrv1EStqUEckwxqImtv8Kpxkp36fiBSmn30Gjf7T4/wKOUAPrUrE/ajxdOcU0wzma/qtyX4xRgL1WULLYLO5J2JhY5+p41XXExi2HKIZ5HFQIyD8glfZ74x50EIy42x4/5tLhYmuxFV66+Odf1r3L+89Ff/fpW+NCEAcK4vfWsG83HdrvST9f0xqCxP9WoDwwoTEdAhch2rag+59h2jMOIAJGKDNhn/cfkF7jnjPFoczqeCGVClXif5OrySqtHGotBI3KGM7lZdpX0MjcUafWtydYKaUn1ycnbE3ighmEZzlHrn4djh8giMuGWL2d4k5DtO8kwMxcTJtSpNAtFMnve7K2rGSNRyfFfekKlFoLw2fSTj/1pPfothYEInqH/Z31nxm2cBOFby6qdV6qPupgQ0TV6gRN4w8N7oLGJNMVzMu6X5fqD6FgjqBrY
 Y7qXI0My
 ktYzqmrn59hKfb58tiKirw5gjrMRg6eL0a5bdXlBPlw1Bvup7ZiC3HeMfV/gQUtX9xK15wTXkQx3H9yB9V5iHJrjHffPhGXs11sESDsbj89qeg81VomaPxL59hONO1kP35KgLZpJz1aHZCivpdkJ5uUgUDZDtCq8JYxBMgip7dWKIwULlWAbnyKVdexDim+2BvIprJbqrw51TKDvYodJMZHIr9Nmat3oJrywFyMAEWIbFdZOkLM1zs0Qe5ZE7BrBAI7VOlIvXUQqqx7zrtPqbSAwnPqr8TKDwxhDSV0l438EAZwLLYVe/ZfRWmymcCFouKkomYDIIVTUpzek+MTmbce/cXGwFyGA0EAq5NWYbVdu9M/c+rXf1vgrUlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This RFC patchset introduces a new feature called "Reserved THP", and I'd like
to open up a discussion on how to use this as a stepping stone toward unifying
HugeTLB and THP (Transparent Huge Page).

1. Background
=============

Currently, two huge page solutions co-exist in the kernel:

1. HugeTLB: Supports reservation, guaranteeing successful allocation within the
            reserved pool. However, it does not support features like swap. And
            it is a relatively independent subsystem.
2. THP: Does not support reservation and may fail to allocate and fallback to
        small pages when system memory is fragmented, but it is more tightly
        integrated with mm core and supports features like swap.

Both have their pros and cons. However, in one of our internal scenarios, it
seems we need to combine the features of both to meet the requirements.

In our internal scenario, a user process needs to reserve double the amount
of Hugetlb memory due to hot-upgrade requirements. For example, if the
process needs 16GB of Hugetlb, an additional 16GB is required during the
hot-upgrade to satisfy memory allocations. After the upgrade, the old
process exits and releases the 16GB of HugeTLB. Therefore, in most cases,
the extra 16GB of HugeTLB is wasted.

A straightforward idea is to use the Hugetlb CMA feature, reserving a total
of 32GB of hugetlb_cma. During normal operation, 16GB is consumed, and the
remaining 16GB can be used by other processes. During hot-upgrade, we could
try to migrate the memory used by other processes to allocate the required
extra 16GB of Hugetlb. This might work, but it still requires reserving 32GB
of memory.

We also found that during the hot upgrade, about 10GB of the old process's
hugetlb is actually cold memory, which could theoretically be reclaimed. In
extreme cases, we could reserve only 22GB of memory and reclaim the
remaining 10GB during the hot upgrade. But unfortunately, hugetlb currently
does not support swap, and supporting it seems quite difficult.

Therefore, we are wondering if we can introduce "reserved THP", which is THP
that can be reserved. It can be consumed through methods like madvise(), while
normal memory allocation cannot consume it. This can achieve an effect similar
to hugetlb. And because it is THP, it can relatively easily support swap
features, which perfectly solves the above problem.

Additionally, in 2024 (or possibly earlier), there have been discussions about
the possibility of unifying Hugetlb and THP:

Link: https://lwn.net/Articles/974491/

After all, hugetlb's management is relatively independent and requires too
much special handling in mm core. The introduction of reserved THP might be
an opportunity. In the future, reserved THP could be enhanced to support
various hugetlb features, such as acting as a backend for hugetlbfs. When
reserved THP can completely replace HugeTLB, HugeTLB could be entirely
removed, and reserved THP would just become a feature of THP.

2. Implementation
=================

In 2024, Yu Zhao proposed a similar idea:

Link: https://lore.kernel.org/all/20240229183436.4110845-2-yuzhao@google.com/

The idea was to introduce two virt zones: ZONE_NOSPLIT and ZONE_NOMERGE to
guarantee the allocation success rate of THP, achieving an effect similar to
reservation. However, it seems there was no further progress, perhaps because of
reluctance to introduce more virt zones like ZONE_MOVABLE.

This RFC wants to discuss another implementation:

1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserved_size`
   and `thp_reserved_nr`. When set, the required memory is marked as
   MIGRATE_RESERVED_THP and put back into the buddy allocator.
3. Introduce a new madvise parameter: `MADV_RESERVED_THP`. Pages marked as
   MIGRATE_RESERVED_THP can only be consumed via `madvise(MADV_RESERVED_THP)`.
   Other normal memory allocations cannot consume MIGRATE_RESERVED_THP memory.

This can achieve a reservation effect similar to HugeTLB and guarantee
allocation success.

3. Future Plans
===============

3.1 Enhance swap-out and swap-in for large folios
-------------------------------------------------

Currently, For swap-out, THP_SWAP is supported, but it only tries to swap out
the THP folio as a whole. It is still possible to be forced to split in some
situations (e.g., fragmented swap space, memory.swap.max limits, etc). For
swap-in, it is almost impossible to directly swap in the THP folio as a whole.

But for reserved THP, splitting is not allowed. We need to ensure that it
remains a whole huge page during swap-out and swap-in, to achieve a function
similar to hugetlb swap.


3.2 Integrate reserved THP into the common reclaim path
-------------------------------------------------------

Once swap-in and swap-out of huge pages can be supported without splitting,
reserved THP can be integrated into the common reclaim path as a normal LRU
folio for memory reclamation. This fills the gap of the hugetlb swap function.

3.3 Use reserved THP as a backend for shmem/tmpfs
-------------------------------------------------

This would allow shared or file-like usage to utilize reserved THP.

3.4 Use reserved THP as a backend for hugetlbfs
-----------------------------------------------

This would allow existing hugetlb users or applications to seamlessly switch to
reserved THP.

3.5 Add 1GB page support to reserved THP
----------------------------------------

Historically, there have been several attempts to add 1GB huge page support to
THP:

1. https://lore.kernel.org/linux-mm/20260202005451.774496-1-usamaarif642@gmail.com/
2. https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.com/

Adding 1GB huge page support for reserved THP would be relatively simpler
compared to regular THP.

3.6 Remove Hugetlb
------------------

Once reserved THP can completely replace the existing functions of hugetlb, we
can gradually remove Hugetlb, leaving only one huge page management system in
the kernel.

This series is based on the next-20260623.

Comments and feedback are welcome!

Thanks,
Qi

Qi Zheng (8):
  mm: page_alloc: add reserved THP pageblock type
  mm: add boot-time reserved THP pageblock capacity
  mm: page_alloc: add a reserved THP allocation primitive
  mm: add reserved THP quota helpers
  mm: add reserved THP vma flag
  mm: maintain reserved THP quota across VMA changes
  mm: support reserved THP VMAs in anonymous faults
  mm: add MADV_RESERVED_THP range policy

 arch/alpha/include/uapi/asm/mman.h     |   2 +
 arch/mips/include/uapi/asm/mman.h      |   2 +
 arch/parisc/include/uapi/asm/mman.h    |   2 +
 arch/xtensa/include/uapi/asm/mman.h    |   2 +
 fs/proc/task_mmu.c                     |   3 +
 include/linux/gfp.h                    |   3 +
 include/linux/gfp_types.h              |   8 +-
 include/linux/huge_mm.h                |   4 +-
 include/linux/mm.h                     |   7 ++
 include/linux/mmzone.h                 |  11 +-
 include/trace/events/mmflags.h         |   4 +-
 include/uapi/asm-generic/mman-common.h |   2 +
 mm/Makefile                            |   2 +-
 mm/huge_memory.c                       |  18 +++-
 mm/internal.h                          |   6 ++
 mm/khugepaged.c                        |   8 ++
 mm/madvise.c                           |  83 ++++++++++++++-
 mm/memory.c                            |   3 +
 mm/mmap.c                              |  18 ++++
 mm/mremap.c                            | 121 ++++++++++++++++------
 mm/page_alloc.c                        |  73 +++++++++++++-
 mm/reserved_thp.c                      | 133 +++++++++++++++++++++++++
 mm/show_mem.c                          |   5 +
 mm/vma.c                               |  23 +++++
 mm/vma.h                               |   1 +
 tools/include/linux/gfp_types.h        |   4 +-
 tools/perf/builtin-kmem.c              |   1 +
 tools/testing/vma/include/dup.h        |   1 +
 28 files changed, 499 insertions(+), 51 deletions(-)
 create mode 100644 mm/reserved_thp.c

-- 
2.54.0


