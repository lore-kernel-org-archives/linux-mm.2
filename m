Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6075BCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BF26B00CA; Fri, 29 May 2026 13:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC426B00CE; Fri, 29 May 2026 13:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB246B00D1; Fri, 29 May 2026 13:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98D316B00CA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:27:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70B181C069C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:27 +0000 (UTC)
X-FDA: 84821138934.27.F8BAE51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BDFB18000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=loQx2kSe;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NfTzwAtyC5pYFlbHqtPUTEyIV17MhkMv9IDQiAjYQnI=;
	b=Qzxb7FA9C0aqpgAXSWh2am1DXjsLWi7f+vNs3SknpS4Orn3ThhBUcEFaCuxvp6Cd9kWTOz
	ba8+drVOXRBzsWovd3YJmDa86MXOwZolXvztIquc0u1uf1zqx0ppKsh5dOdD+EJr/76CBc
	IH7jLRASnhImAkEJS72wjAnhymyQ3ng=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=loQx2kSe;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075645; a=rsa-sha256;
	cv=none;
	b=DFknNyFNcdehoLiCTGJ3yl+c/tid9lJjcV/9VcbRio+LxJWx7XPxcLwTMhiLSB/uHEev3W
	uleOoKxkqRabfxE8pC3P2YusHEFPWRGXR8oRBq7Uq/ck4KxF0ebfl9wsB2s6naAf57IMKZ
	bzZqNk3Dwf5LT8bv0KgzXcvwHs3rZQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FEAE442A9;
	Fri, 29 May 2026 17:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B361F00898;
	Fri, 29 May 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075644;
	bh=NfTzwAtyC5pYFlbHqtPUTEyIV17MhkMv9IDQiAjYQnI=;
	h=From:To:Cc:Subject:Date;
	b=loQx2kSeAW4WGlbFF0SGccV3kFJaF+FgtJlJYVlFoJvme3GQ0VClJ/v7YHyvBT2XX
	 yJo2Tke4/qvLXVUS6jKk7zpYP9vRgl13mK7hMXlVUPYhzbOBgYxsPljG9q/VxAbuEC
	 m/cvId4ydW2GZ1WLYjGUIDF0PdRebv9RsgVUk1I+aJ00NVNEXJKkY/lHzC9bvay96F
	 kFl+mbK4B0mRuKPWZSnohV930dqs+dusBX0eZE7bAGKJwRtRjipIa0LTd7QE559Rui
	 F3x3ClaImIRWaZBLoCJZskLq4PblpsRn9B9xRfDiNNCLYCKuBp+YCfO/y0lRnEs+q3
	 0q5D0IAbh10Aw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3EEB2F4006F;
	Fri, 29 May 2026 13:27:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 29 May 2026 13:27:23 -0400
X-ME-Sender: <xms:e8wZat_1nNXv5CAdHB_HskvXv9SA7HT312ToLhM2ypvTldvN5NduHA>
    <xme:e8wZalpRedKX_up8i1mqRKcNoPad8j0aWZhI8YY96Mc0Et1x9lCUDw2oDX37vh_i1
    55RMExzVyRmqrB0gtW0f4ZTGrWK9MVu7Ikdo00v4t9YGpX20j-RoG4>
X-ME-Received: <xmr:e8wZaji_c_ARQdrw05OHCov1PcrYiFkmsptProFoVTdAjHE9ku-Wui0V0tuPEA>
X-ME-Proxy-Cause: dmFkZTFLqO2jamm4P7y4lIO2odxfIY2Q4usIAWWS/LuD7Qeu9DEkfQoY8X0zLzNn27/W0K
    vPAn66qDVYZ3B59GlkltUfBGXhHi4cMOTSpefcOSVS4BSujNAPqNjBnuaalAYApfmqJGCl
    PjiiIE8ahLGpAyEV8i51oONbzHPeeMgFWXGWXVTjhn2ou7ajp9XLjIEj3QVTj3ZEyL4Clq
    Om2XB5Xj94E2HEXocz3aMcBewUn2ZGX1VabLUKDQY4siPVTnjLgvSoJiWxt4Py9ppBw8Wz
    YFk1w+pg1vzY058LWIw8qWieUQvvCAcu1/5J6VptzCXcHLnyN2jEKM+QaNuF1DAT7g6yGl
    AwVZkfUIJEXHUZA/oYBBQbtbJHlySn1cVRG/uGpQxCRV+Ck8z6evUsxK1ZnW0mwUGmvPBl
    GJGyWqapotf69yDdTb1WfzPTzvbsSLhMhtPgw/WMdqB1ITnab7BzJu9a4GFUMAAYqNsNoP
    YEyh5WPYPpW3KaFyVFwGqDX3ma3usQEFA50FEI7q74CMocYl8WHlVDgpxVPIi0emKtSTQ0
    GJGvpzR/dR49fV5t/qnCT/WyiXopuEXz4Cg+JXNeYXZlOSAObkIJkP85o4Xtx2aOhLuYVl
    D7hUvwS2YVXSdZM2pZnE9xplWtQuvebkidV/0yd9ye8sKZKghnAM8pOzZnXA
X-ME-Proxy: <xmx:e8wZarDLkKiYxbqDPGTXMD00i2sTrYLiijkVd6XJ7tG_LsOVhLcgEQ>
    <xmx:e8wZapssrxGS24UCos53QVMLvOLehmL29ZY_9TXhy1lSCAcQh-OzIg>
    <xmx:e8wZat5R1nF8GKzaH6Oz1vxGfgDQfe-v1U_sOmOZ9c4wqFW5tuob9A>
    <xmx:e8wZard1Z1L3zdyTC-fn-QlsZqBQQc1htk50wn6ssWhD4YbYEOy9hQ>
    <xmx:e8wZatW3JZnHEE7iQ1eIV_qGD95Uy9ebTQJIUGuspqgW17VB3vtT02vQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:27:21 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v6 00/15] userfaultfd: working set tracking for VM guest memory
Date: Fri, 29 May 2026 18:26:29 +0100
Message-ID: <20260529172716.357179-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BDFB18000C
X-Stat-Signature: swzt8rkhfho6c6u5ako1f3dfjcogn4ka
X-HE-Tag: 1780075645-210280
X-HE-Meta: U2FsdGVkX19jxTDbOgDdAc08Y2orH3VL9EjQGw/nYylUE54SeI0VDOmMElVG8A2wxZjpoXQAnbD1T0SLvmHmVJNtTSVHzseEZ9IoH/J3O7Fc0JvbzCoGWY48aU//kf94tObfGMLrfWhYea9qQAEq88ZD7TlijicjLds81chYJMpkOWmJY6BQPrNTHeHY+jm1tw2D3D09ewiUx1yC1BYdJM3TwMUca6Tdil/epjGCULxEgsqJcck2NlsiStYD9H6TiT41q3H1VrXkfoZTLeXQoGM0os/WJ3jBQVq8vpSPqvrx5B1lO+VOCEArbQaF8GcpNGx3oa/UJwHqWoA6WEGretWpibcR2pHxr6Df3vkKMl1htzZO6U0Yw8zEKj3ON6RhSFT9lveUKUt57Nrd8CW5CtaPAB/MtbuIookGqFBet1xZJg1zUNXFiPh/jSPZW2ehVRWNKdXyJw8RGFgzDcukJBUEYjPHSayK2UcsAgI2coN5uCT2UhLp6nbBdfz5TBstdsCj85Z4pMEgEi1IlviEMb4NlcG8+dh9bBsd7/dAb156VzLCFVY3IOU376U5LMDjBcRzFwe9ev4ENBmA+GQv7fLyL4WNynr2/kHq4VKLCu4AwOOmL6xLR2mIc+j67jvzpjRwE0MSQBDFC1KUsxrDR6flESRs4JHrnzF5xS4fn4myV4JJY7wLQhTr1lM+AyWSPCnYzCLkfV2NIx1XCCDzckJkGpU9iZJce5yMY+PqR8yrc3M3HIlcTJ4ctPrT02u2e4Jdh3bTuGhaislojQGHiz7n4zRH5QI+TMtHFOCc7h12Vjkf9JtLw24qMlpzQehMCT117a0vmocH8g1sspBUmCzX6+FGLVuDqd+7nUhAHmqP0ijXf0wKPfg4wwft+kTOU5arZcQeLgas+tCSiduu83PzzuWTDmG/aD2PfORSN8GxbNfZ3yc1wBO7pJo3/T6nx2b/1sYLe0EWD9BHAZe
 kCJrfBzL
 v2xYr5nBKD3pUGjbcktW11tu50E99FaX6JV8ozP5oXEYu9RhjwJxCnogYfemKZaU9Iscm0BaOI5nz2UeOLc577wQ9Cxj/AetBSeSOhtgSgaUzoXpoSWkZApcJokurOSLvKK/5RTBQbmPtM6hCopqO2mr1vXLwnZqXE08MueveeAa1ilRLXEbNnBNnOssSaULUtISRUdjS2ciwrBx9jQr6t3xU6A9OkCanKtY3yphk4V0xPdXJBdl9AWKTmLoapIX+nJ+HCRXBAHwwfbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds userfaultfd support for tracking the working set of
VM guest memory, so a VMM can identify cold pages and evict them to
tiered or remote storage.

v1: https://lore.kernel.org/all/20260427114607.4068647-1-kas@kernel.org/
v2: https://lore.kernel.org/all/cover.1778254670.git.kas@kernel.org/
v3: https://lore.kernel.org/all/20260522133857.552279-1-kirill@shutemov.name/
v4: https://lore.kernel.org/all/20260525113737.1942478-1-kas@kernel.org/
v5: https://lore.kernel.org/all/20260526130509.2748441-1-kirill@shutemov.name/

This series is based on the "userfaultfd/pagemap: pre-existing fixes"
series, posted separately; that series carries the pre-existing
Fixes:/Cc: stable@ patches that used to live at the front of v5 (the
four from v5 plus two more surfaced since).

= Changes since v5 =

  - Split the pre-existing fixes out into a separate series; this is
    rebased on top. (Lorenzo, Andrew)
  - Rework the mk_vma_flags() OOB fix to config-gated per-mode masks
    (mk_vma_flags_from_masks()); moved to the fixes series. (Lorenzo)
  - New prep patch 04/15: convert the userfaultfd_*() helpers to
    vma_test_any_mask(). (Lorenzo)
  - 08/15: gup_can_follow_protnone() forces the RWP fault only on
    accessible VMAs, fixing a FOLL_FORCE loop on a VM_UFFD_RWP VMA that
    was mprotect(PROT_NONE)'d.

uffd-unit-tests 113/113, pagemap_ioctl 117/117.

= Problem =

A VMM managing guest memory needs to:

  1. detect which pages are still being touched (working-set
     tracking);
  2. safely evict cold pages to slower tiered or remote storage;
  3. fetch them back on demand when accessed again.

= Approach =

UFFDIO_REGISTER_MODE_RWP is a new userfaultfd registration mode, in
parallel with the existing MODE_MISSING / MODE_WP / MODE_MINOR. It
uses the same mechanism on every backing -- anon, shmem, hugetlbfs:

  - PAGE_NONE on the PTE (the same primitive NUMA balancing uses)
    makes the page inaccessible while keeping it resident;
  - the uffd PTE bit (the one MODE_WP already owns) marks the entry
    as "userfaultfd-tracked" so the protnone fault path can tell an
    RWP fault apart from an mprotect(PROT_NONE) or NUMA hinting
    fault.

VM_UFFD_WP and VM_UFFD_RWP are mutually exclusive per VMA, so the
same PTE bit safely carries both meanings depending on the
registered VMA flag.

In sync mode, the kernel delivers a UFFD_PAGEFAULT_FLAG_RWP message
to the registered handler, and the handler resolves the fault with
UFFDIO_RWPROTECT clearing MODE_RWP. In async mode
(UFFD_FEATURE_RWP_ASYNC), the fault is auto-resolved in-place: the
kernel restores the original PTE permissions and the faulting thread
continues without a userfaultfd message ever being delivered.
Userspace then learns which pages were touched by reading
PAGE_IS_ACCESSED out of PAGEMAP_SCAN -- pages whose uffd bit is
still set were not re-accessed since the last RWP cycle.

UFFDIO_RWPROTECT is the protect/unprotect ioctl, mirroring
UFFDIO_WRITEPROTECT.

UFFDIO_SET_MODE flips RWP_ASYNC <-> sync at runtime under
mmap_write_lock() + vma_start_write(), so a VMM can run in async
mode for detection and switch to sync for race-free eviction without
re-registering the userfaultfd.

= Typical VMM workflow =

  /* arm */
  UFFDIO_API(features = RWP | RWP_ASYNC)
  UFFDIO_REGISTER(MODE_RWP)

  /* detection cycle (async) */
  UFFDIO_RWPROTECT(range, RWP)
  sleep(interval)

  /* freeze the cold snapshot before scanning */
  UFFDIO_SET_MODE(disable = RWP_ASYNC)                  /* sync */
  PAGEMAP_SCAN(!PAGE_IS_ACCESSED) -> cold pages

  /* eviction (sync mode traps races) */
  pwrite(cold) + fallocate(FALLOC_FL_PUNCH_HOLE, cold)
  UFFDIO_WAKE(cold)
  UFFDIO_SET_MODE(enable  = RWP_ASYNC)                  /* resume */

= Series layout =

Patches 1 to 4 are preparatory:

  1: decouple protnone helpers from CONFIG_NUMA_BALANCING.
  2-3: rename _PAGE_BIT_UFFD_WP, pte_uffd_wp() and friends to drop
       the _WP suffix, since the bit now carries WP and RWP meaning
       depending on the VMA flag. The SCAN_PTE_UFFD enum's ftrace
       output string is intentionally kept as "pte_uffd_wp" so
       trace-based tooling does not silently break.
  4: convert the userfaultfd_*() flag helpers to vma_test_any_mask().

Patches 5 to 8 add the in-kernel mechanism:

  5: VM_UFFD_RWP VMA flag (aliased to VM_NONE until 09/15 introduces
     CONFIG_USERFAULTFD_RWP together with the UAPI).
  6: MM_CP_UFFD_RWP change_protection() primitive (PAGE_NONE +
     uffd bit, plus a RESOLVE counterpart).
  7: marker preservation across swap, device-exclusive, migration,
     fork, mremap, UFFDIO_MOVE, hugetlb copy, and mprotect().
  8: handle VM_UFFD_RWP in khugepaged, rmap, and GUP.

Patches 9 to 13 wire the userspace surface:

  9: UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing.
 10: RWP fault delivery; turn the UAPI on.
 11: PAGE_IS_ACCESSED in PAGEMAP_SCAN.
 12: UFFD_FEATURE_RWP_ASYNC.
 13: UFFDIO_SET_MODE runtime sync/async toggle.

Patches 14 to 15 are selftests and documentation.

Kiryl Shutsemau (Meta) (15):
  mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
  mm: rename uffd-wp PTE bit macros to uffd
  mm: rename uffd-wp PTE accessors to uffd
  userfaultfd: test uffd VMA flags through the vma_flags_t API
  mm: add VM_UFFD_RWP VMA flag
  mm: add MM_CP_UFFD_RWP change_protection() flag
  mm: preserve RWP marker across PTE rewrites
  mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
  userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT
    plumbing
  mm/userfaultfd: add RWP fault delivery and expose
    UFFDIO_REGISTER_MODE_RWP
  mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
  userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
  userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
  selftests/mm: add userfaultfd RWP tests
  Documentation/userfaultfd: document RWP working set tracking

 Documentation/admin-guide/mm/pagemap.rst     |  13 +-
 Documentation/admin-guide/mm/userfaultfd.rst | 253 +++++-
 Documentation/filesystems/proc.rst           |   1 +
 arch/arm64/Kconfig                           |   1 +
 arch/arm64/include/asm/pgtable-prot.h        |   8 +-
 arch/arm64/include/asm/pgtable.h             |  47 +-
 arch/loongarch/Kconfig                       |   1 +
 arch/loongarch/include/asm/pgtable.h         |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |   8 +-
 arch/powerpc/platforms/Kconfig.cputype       |   1 +
 arch/riscv/Kconfig                           |   1 +
 arch/riscv/include/asm/pgtable-bits.h        |  12 +-
 arch/riscv/include/asm/pgtable.h             |  59 +-
 arch/s390/Kconfig                            |   1 +
 arch/s390/include/asm/hugetlb.h              |  12 +-
 arch/s390/include/asm/pgtable.h              |   4 +-
 arch/x86/Kconfig                             |   1 +
 arch/x86/include/asm/pgtable.h               |  56 +-
 arch/x86/include/asm/pgtable_types.h         |  16 +-
 fs/proc/task_mmu.c                           |  98 ++-
 include/asm-generic/hugetlb.h                |  18 +-
 include/asm-generic/pgtable_uffd.h           |  32 +-
 include/linux/huge_mm.h                      |   7 +
 include/linux/leafops.h                      |   4 +-
 include/linux/mm.h                           |  65 +-
 include/linux/mm_inline.h                    |   4 +-
 include/linux/pgtable.h                      |  32 +-
 include/linux/swapops.h                      |   4 +-
 include/linux/userfaultfd_k.h                |  89 ++-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 159 ++--
 mm/hugetlb.c                                 | 158 +++-
 mm/internal.h                                |   4 +-
 mm/khugepaged.c                              |  40 +-
 mm/memory.c                                  | 135 +++-
 mm/migrate.c                                 |  20 +-
 mm/migrate_device.c                          |   8 +-
 mm/mprotect.c                                |  70 +-
 mm/mremap.c                                  |  17 +-
 mm/page_table_check.c                        |   8 +-
 mm/rmap.c                                    |  18 +-
 mm/swapfile.c                                |   9 +-
 mm/userfaultfd.c                             | 387 +++++++++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 765 +++++++++++++++++++
 51 files changed, 2300 insertions(+), 436 deletions(-)


base-commit: 9110948da327947a01830604020e0548c15b96f1
-- 
2.54.0


