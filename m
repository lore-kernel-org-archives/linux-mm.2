Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C077EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08976B0491; Thu, 13 Aug 2026 07:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9916B04AB; Thu, 13 Aug 2026 07:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F69E6B04AD; Thu, 13 Aug 2026 07:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD3A6B0491
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:06:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 161B3C05E9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:06:51 +0000 (UTC)
X-FDA: 85095968622.18.5CBA8DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8EDDB14000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:06:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V6eusabv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W2WE5+G5sDCD83p3y7rTlSpYQ/0YIWhOKGLGbZFH7Jg=;
	b=G0fUS4oCEbY3LJig4ZZ9t5A3YT2Ta3/hYARrDYOCY2ivIxvNs9FE3OYHJX3aujNthSsu3b
	PVnCNRO6BJDe/lzHO1TmDyacTZah/DcxDn6X51FrbzzM9uK0R7LG7sVZJkYB7MeE10/AGp
	vjRNxDJfrMLNlmHA57vix30/IX/CKfQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V6eusabv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619209;
	b=20lAoP3WBTecijulKpcx2YQWmP3sMo0TXfIB208Rb9LUO7EXpxTRn7EclhhetpubhrixdU
	dMGC0Gvzh2S2+hHHUMfvXsj9avUBpLiqSY3sCGsLBT8D8C+1PNI6f/UUHj2shG4RI/T1K2
	1dSeV19cSRyd5iwxu7g7JLxatsHfed8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 172DC601DE;
	Thu, 13 Aug 2026 11:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479C81F000E9;
	Thu, 13 Aug 2026 11:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786619208;
	bh=W2WE5+G5sDCD83p3y7rTlSpYQ/0YIWhOKGLGbZFH7Jg=;
	h=From:To:Cc:Subject:Date;
	b=V6eusabv8ZIAhH8MAj2WQAUS02gYzwcvx5jopw7/bWh6rRc+c1FgEiRr2KQYDKd35
	 J5q9S0YM2dVIVPQ31rboet3QNulhVbYL1XgYRfKQzfzUtuflgq02NmUa/Vld7Naw2V
	 gyZP8Q0qIhZ1ob2Rd95PuRXL7yE8yrQ8maHfPp1AHWuqXX7BLFuO4WDZNiqknekDOe
	 XiDiDumVdnBQxKuGSf6b4jjekK974fkhX214h3zO0nAdwM/94KhfJE4fxXuU/jChwi
	 iXt/xhURB7PYldvHVw7EEiGBsonK7iT44SSnthN5cv49IScx8CTnQ48Yv+sPQw0t+Q
	 ZEIK2YkZCnt/A==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock: updates for 7.3-rc1
Date: Thu, 13 Aug 2026 14:06:17 +0300
Message-ID: <20260813110636.2482716-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p441xjwjy6itnssxaom5u3skz4aou74q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EDDB14000F
X-HE-Tag: 1786619209-200474
X-HE-Meta: U2FsdGVkX19ncs6EGzvNDIsOC6gURMJIgtHMWM5qzY8MX23HL+o8Qp6t4kMlcdGP48tcObLtMXR6siyQ7Edm5Z2KInxsyiZC/vtI3zd1M8wsXCCpQxOq3lBsI+/4h6yKN6yIdy+7tbqw3BKkMao+T/LJYa70OdWeOWFxEWI3VojIypLtHqOBWyZXZOs80ai4ttdNTAzU3+CQS20IrTM2HygMPynxjrPI50f/1Zv7hg7oV2IWXD9NmeD9ZKP5SEOVeowislb2PlaZhGhA27mXkvDgSalj74VFOmawEXHm4auHGzN841B86hGAaSH3bbaRxIazwULDl5ZRDh0MiuwF9B3oqKJcSYt5kECd7j8JEZJTvCJMiATL2VHE4tGILSxT9OTNWtf8Rta684UOhhxDNcsYzTRwQyLvPq9ktcYI9UqJQ6IzqrzS++3CZADdLge+8ld6kNYSGEY3ZCnrfI5W4dDzhPTqOTmVUsR9Bh3g1jZAkZMX8+qzxLxaTHbo/z7xyQU86h0du/QzR7aUsNlgAVj2uh6wXFD+01croMlCD5hjnmtWS3QlDBIhAadczzsZUYr6mw+UYHjz2G0C5A19ljbLm/NpyCSdkIiGNcnUvt4FP8WdHQovsGOiBZm7pt3KRYvFtfQ4e8hqV4IluEV5oQEA1mlBWRNK3SknfjYDf5wQot0/0UceXZvWqtK8XnMqmYbadeasR8a2n3wiuhpd2H5Emwlo+BYaH3H/y8HvZ9EzJF1zzTarw8m1CroSi2LdelhwKuljbjsGIXzY1A7fe0XNa0NCF+OIzembUk0lWmzPfoJaujlKez5t9i/tuFDARVkhdSurBJTbkf/n3Q5A4dpjK1O5t8BrS4jekJSx9MDAzgIhTs5lIv53TJt7vonutIQ0SlBGvhkjH0LeGKQqKBSVzrnzQ50+8y5uoFJHdfBtNdyITIfCCBkEsO5J30zOOeirxNU4c9No6BI2IXy
 1tqIY5fj
 hoZICnVFmjhqlOi5HDtmSouHF0uPAJFzOSiCpfj2IVuf2NxruL3uHhlZ8wiRrrl8dEpFHRYCgItSOWRA0W2pVrlEve+GB/GfI/yVkUsBAQNU5n4gafeflmqLRMK2wEFEWFXzStOIXpY8zESx4SgeYWWrjxfk6auOx2VRY133xuPcWfk16t1gTO0c/vGQ/YHC1l19SVbpunt4R0qWGAxDLkW/ZjyZL9g5FChcQnp/0I+8Vu6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.3-rc1

for you to fetch changes up to b3c1ec1a9ad84ec2f14d343d28c6032feaec5b79:

  Merge branch 'misc' into for-next (2026-08-07 11:47:13 +0300)

----------------------------------------------------------------
memblock: updates for 7.3-rc1

Non-urgent fixes:

* Fix calculation of node_spanned_pages when running with kernelcore=mirror
* Properly handle failure to allocate per_cpu_nodestats in
  free_area_init_core_hotplug()
* Fix deferred initialization of the memory map for configurations where
  node's RAM end is not aligned on PAGES_PER_SECTION

Cleanups:

* Remove redundant pageblock_align() call in free_unused_memmap()
* Remove unnecessary invalid range checks in users of memblock iterators.
  Some users of for_each_mem_range() and for_each_mem_pfn_range() verify
  that start < end for each range. This is redundant because memblock
  iterators guarantee to never return an invalid range
* Stop overlapping zones with kernelcore=mirror and align behaviour of
  kernelcore=mirror with other variants of kernelcore=/movablecore=
* Remove redundant updates of numa_nodes_parsed mask in the callers of
  numa_add_memblk(), the latter always updates the mask anyway
* Remove unnecessary initialization of pgdat->per_cpu_nodestats to NULL,
  the variable is reset to the actual value a few lines below

----------------------------------------------------------------
Alexander Graf (1):
      mm/mm_init: deferred_grow_zone(): fix out-of-range first_deferred_pfn

Gregory Price (1):
      mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

Mike Rapoport (Microsoft) (10):
      Merge patch series "treewide: remove unnecessary invalid range checks in memblock iteration loops"
      mm/mm_init: don't overlap NORMAL and MOVABLE zones with kernelcore=mirror
      mm/mm_init: drop overlap_memmap_init()
      Merge patch series "mm/mm_init: don't overlap zones with kernelcore=mirror"
      Merge patch series "treewide, numa_memblks: remove redundant work during NUMA init"
      Merge branch 'fixes' into for-next
      Merge branch 'kernelcore-mirror' into for-next
      Merge branch 'numa_memblks-redundant-work' into for-next
      Merge branch 'range-checks' into for-next
      Merge branch 'misc' into for-next

Sang-Heon Jeon (19):
      arm64: mm: remove unreachable invalid range check in kasan_init_shadow()
      LoongArch: remove unreachable invalid range check in kasan_init()
      riscv: remove unreachable invalid range check in create_linear_mapping_page_table()
      riscv: remove unreachable invalid range check in kasan_init()
      ARM: remove unreachable invalid range check in kasan_init()
      powerpc64/kasan: Remove unreachable invalid range check in kasan_init_phys_region()
      mm: remove unnecessary empty range check in early_calculate_totalpages()
      mm/hugetlb: remove unnecessary empty range check in hugetlb_bootmem_set_nodes()
      mm: numa_memblks: set numa_nodes_parsed in numa_add_memblk()
      ACPI: NUMA: remove redundant numa_nodes_parsed node_set()
      of/numa: remove redundant numa_nodes_parsed node_set()
      x86/numa: remove redundant numa_nodes_parsed node_set()
      arch_numa: remove redundant numa_nodes_parsed node_set()
      LoongArch: remove redundant numa_nodes_parsed node_set()
      mm: numa_memblks: remove redundant numa_nodemask_from_meminfo()
      arch_numa: remove redundant node_possible_map assignment
      mm: numa_memblks: use numa_add_reserved_memblk() in numa_cleanup_meminfo()
      mm/mm_init: remove redundant memset in free_area_init()
      mm/mm_init: remove unnecessary initialization of pgdat->per_cpu_nodestats

Wei Yang (1):
      mm/mm_init: fix incorrect node_spanned_pages

Zhen Ni (1):
      mm/memblock: Remove redundant pageblock_align() in free_unused_memmap()

 arch/arm/mm/kasan_init.c               |  6 ---
 arch/arm64/mm/kasan_init.c             |  3 --
 arch/loongarch/kernel/numa.c           |  1 -
 arch/loongarch/mm/kasan_init.c         |  3 --
 arch/powerpc/mm/kasan/init_book3e_64.c |  3 --
 arch/powerpc/mm/kasan/init_book3s_64.c |  3 --
 arch/riscv/mm/init.c                   |  2 -
 arch/riscv/mm/kasan_init.c             |  3 --
 arch/x86/mm/amdtopology.c              |  1 -
 arch/x86/mm/numa.c                     |  1 -
 drivers/acpi/numa/srat.c               |  2 -
 drivers/base/arch_numa.c               |  4 --
 drivers/of/of_numa.c                   |  5 +-
 include/linux/memory_hotplug.h         |  2 +-
 mm/hugetlb.c                           |  7 +--
 mm/memblock.c                          |  4 +-
 mm/memory_hotplug.c                    |  3 +-
 mm/mm_init.c                           | 93 +++++++++-------------------------
 mm/numa_memblks.c                      | 41 +++++++--------
 19 files changed, 49 insertions(+), 138 deletions(-)

