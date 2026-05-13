Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C6E8CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE066B0005; Wed, 13 May 2026 09:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FFE6B008A; Wed, 13 May 2026 09:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DB06B008C; Wed, 13 May 2026 09:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43A076B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:07:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD58D140AAF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:37 +0000 (UTC)
X-FDA: 84762423354.20.2AB80C7
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93551140014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SOh1GvYj;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J8NpoUoHQ+aQSSKrd0jYtj6P28R/h0KlfJ/MEbWicLs=;
	b=FJQ2reP2Tc85d/yPcCjMnDcSfqqDuS7xu2r4IZ2zeo+7mXhzsuDpv+gvLoZfewEAMmb0/V
	S7Pkxh5kqW/IfkocNnevin6p3IPKFqMmRt02VLcI//0mjiOP51lAuqya8eXdUQwYV6qY0Q
	SLJMiImxDdXJUIeLfjdDnE2QVqxPbDU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SOh1GvYj;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677656; a=rsa-sha256;
	cv=none;
	b=tTMPJRVfOkkhis6TJQMhUQTBFAD5zdGq+eg21Uvus3i78kEZWvM9kQnjozR1tJewhBxDkt
	metztesgOqOp1V47r3oIylfwTRSOlFFFySeZJKDy+s9/6NmAzwzjBY5YpnjAHT49iYj973
	pH4q2cWJ5+C3c/mWbeuLzkfRjMoiWdo=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bd266f6fc0so4774295ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677653; x=1779282453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J8NpoUoHQ+aQSSKrd0jYtj6P28R/h0KlfJ/MEbWicLs=;
        b=SOh1GvYjg7IUVKbh/hpw0deS9O66pLE1QcGPpDZOhPO254p96pbDVxpTBlA5sfYaCf
         MRcJFCEDrL/O5Scx0kigctgXWv9ek0kyQqouJuYbZ/TDwMI4Hn0SlQRlzc5S24WOdp54
         zH81UnIVw+fZQxZ9jQvxT3PjC9TsCKxda/5HARqEYJjRpwEUPq6xHlqFlID03Ky2G/Bm
         uzHqYEtwPZ7KsaCsCBPPQjSyF7MSvagZut0JWbNAQduoSqQAokoJleEm5cQBSlHo8mm8
         ACEAf2z3voa073TaEp5/Q7Of5PkTa8irJUyc2/o3df1ef3DIPGAyTnE9SWvR5d1cL081
         AIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677653; x=1779282453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8NpoUoHQ+aQSSKrd0jYtj6P28R/h0KlfJ/MEbWicLs=;
        b=GhPpCF3YS4TF2kx9/dzSWSiGrGGbUO1tRsDGxrA7gPab5LN4A0N9YWRByQOfKhxwm+
         VB/cObh1AqrohikuJqfESN68VVTtqOmilil/fcge5TIr4clk+WNLHUYHIHnxkwFN4Jg8
         ilcCvdC5YlD6Ewc47ufLL4dOMVvUENdO4VmN/RfAsr6W/EtEG7Z+sUV5nxF7ReSpy07n
         Xate6nS2TdvqR3ArsYvcSy2kz0V1wHo86hL6cv1bW1chgc7ieXBrcZFDCjCGATNnKl6k
         x2c3FRESqHAdHxtwd8aDKlIsxAOvGUc1fj2NNqXgN1oQxXtFHLyAXyTepAtjeJTZ+kZu
         CO5g==
X-Forwarded-Encrypted: i=1; AFNElJ95eKX9r44tbnoOcNoedvsL5mYGk0RHRyVLjZqRjyMGtnY1+9RQOntg0gWakfG8fHTWMuO3LWml8A==@kvack.org
X-Gm-Message-State: AOJu0YxCaV6MwkTa83K8EBwHdWgFTdcDyfdABYrtnLJdnTygoYBNjq5A
	yIm8ATrKdaIw2obZ/hmlIFvGfBeJIViLdLZZvWwN0kWUZRLOJEm9pq+kVT0Sm2DCaCk=
X-Gm-Gg: Acq92OHMaqLGNTKsEOET2mnT4yU0Iklt9pz7Y1VD4veO1IEgsFGx63XwNTaOBiyPMUE
	fgWrqOZts5+0/zDkFPzlbCuSY4IKTMcNtqoCBGB2zqXdaHCU3+CKGwGJ7EJ92Iir7JDPoN86fJV
	8u0PnEEwqHb5ipvrgzb0ifOQnaYvT3FtDgoGmkYVJs2NaWbfzwu43Vp/a57LO8Av2B6e8FhrluF
	ln92EueIKVswxdTPOM816sv45q4QiNHfR09Wr5a7PsDUzu3b4vMjRIvPOr+QewcHTSEelRJGTyu
	G4b49IbYUn640t6XuzOXZdpbyiT7685/KSAfyCaY/3AeeW3dIP9CqCAmb+mWC2bFuUS1L+gitV6
	dJr7phfoeuz/QFB+OL1mG3cC7Z1nN1OfDpASwG9Sjj/TocWajQl1hioqD7UWAFEIoCYgN5Oxy8p
	hKMC568/X2lQLkrBJXOarwjKmXplNMcJ8dngIJ1vZpZiRSGuuPg3EKPEIvEZ0=
X-Received: by 2002:a17:903:1b4f:b0:2b0:9c2b:641d with SMTP id d9443c01a7336-2bd2f4dbc06mr31307215ad.2.1778677652955;
        Wed, 13 May 2026 06:07:32 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.07.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:07:32 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 00/69] mm: Generalize HVO for HugeTLB and device DAX
Date: Wed, 13 May 2026 21:04:28 +0800
Message-ID: <20260513130542.35604-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 93551140014
X-Rspam-User: 
X-Stat-Signature: qepidunoseh1z6t3pqw4ukgbbhu36boa
X-HE-Tag: 1778677654-130849
X-HE-Meta: U2FsdGVkX1/RDBdr0L9C0N/CbDMh3VW9kIPOcGxToFZmWRgiIxsQ5RKWYNAZDYZENKYUaqaD094xrOnENhK9JJ3hsAq/OpWAc+BKIOYvJpTqZNDbmDcMcz8XCvouNqvE4zwwYw7qkHiflrtmlrFhsQdgl7FesH49YTRgsDOoYyRr97lqu6IkN20DnGHRYaSal0SOA69uCXjvSkITyimLZ78ZExoz25jty2FotEQ8xi/OMw2/ugakWQPgRggfUbGjrkac4n9CH++jKUqg1LM1ZX+uMTMcIFA0dsBkocLzHiHSjzhCKU7gnvh0XGX+bsd6BvekDlwhtVAjxWzdpnh2yFXBIX+V2LSeWpPzV8NlBrM0kPxtsPqfn5q0C6Ui9NDXz8Qc5L/bVsbNuDkfowpIqgptonCA365pbklV2P1xPj9eirUq19QzNzGMG8j9AqqcbCJ/HSti34fquxZGukggOetEIV4YxDPr4EfxPK2KJvfk/Zvkd11sbBrjV87Mjcd/kIzJRGusG/2dWOjJgjb2OYAu0Jl14aJg6xdnXUronqjmbqDUizLW/IFDcWyKsKZUVBFcro6FghZ4iVHbAV+xNmgneQIQ1A7uLF72tovuwOJjHQwQK/nPSkrFbmmy3cIBTu5FWufer/YxKbKc6yCXb7rBEEsfsavkA2bXObcHR0EGLBB8oqSRQ1oxVhw8g6Aw09FKHBE//YVNxAxVEakP/3jQwrfZOLJ+JVCUFdVGYwcPtVFKUcxnc4HPO+RKl96A9/WFpP3JMsW/ztskADyFTIBG9E2zOXfoqiqi0Q31UKrLp5YlogHCLTsARAPbcgeCBXOMgzYmepMpzDFh3G99hvBoA27d+2TSb6bDbEdwj6bXMRSkYbe8hiYlyBa7No+LK9U5EDSi3LfzfGYtRq0WPWh144FuYWZUBiq26ZmyIKfq4cF5UkrcZz34Yc7ZPZ3ct+hvN0r0l/enFYp5wMy
 gUm2/15r
 njugLHamqVEUcHOAyPEOnAZoHFq5JmK3Z31hhxb/0GmD0i4fssBvXi6z4PMg3Wpy6PhwHKJr5MN0HDK9o6roGVdT8rPiscVnk+YlRR7ZuwyWCswVIOhq/l44oz9n5LOCdet13qIIk0shEhhdY3UyOzQmXb9QTBgFyi/o7CpRhHelYTX8QMcwRWxg7Eq6U99s5/sRL8hJJYbwl5UI7ZN1dunA2S3MHfctXjfMY3bOulvizVdp6aEwDLiEOgnKmaKmrLF/dZlJJOMeZuRbd+L6v8qEx6RyP0PIWKOza
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In this series, HVO is redefined as Hugepage Vmemmap Optimization: a
general vmemmap optimization model for large hugepage-backed mappings,
rather than a HugeTLB-only implementation detail.

The existing code grew around the original HugeTLB-specific HVO path,
while device DAX developed similar but separate vmemmap optimization
handling. As a result, the current implementation carries duplicated
logic, boot-time special cases, and subsystem-specific interfaces around
what is fundamentally the same sparse-vmemmap optimization.

This series generalizes that optimization into a common framework used
by both HugeTLB and device DAX.

The first few patches include some minor bug fixes found during AI-aided
review of the current code. These fixes are not the main goal of the
series, but the later refactoring and unification work depends on them,
so they are included here as preparatory changes.

The series then reworks the relevant early boot and sparse
initialization paths, introduces a generic section-based sparse-vmemmap
optimization infrastructure, switches HugeTLB and device DAX over to the
shared implementation, and removes the old special-case code.

At a high level, the series does the following:

  - apply a small set of preparatory bug fixes
  - reorder early boot and sparse initialization so optimized vmemmap
    setup has the required zone and pageblock state
  - introduce generic section-based vmemmap optimization infrastructure
  - switch HugeTLB and device DAX to the shared implementation
  - consolidate HVO enablement and naming
  - remove obsolete HugeTLB-specific boot-time and architecture-specific
    optimization code
  - rewrite the documentation around the unified design

This brings a few concrete benefits:

  - HugeTLB and device DAX share one vmemmap optimization framework,
    reducing duplicated logic and long-term maintenance overhead
  - when CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, optimized struct
    pages can skip the usual memmap_init() initialization work, which
    helps reduce boot-time overhead
  - all architectures that support HVO benefit from the generic
    sparse-vmemmap optimization path without extra architecture-specific
    preinit handling
  - device DAX improves its struct page savings further by dropping the
    extra reserved tail page
  - shared vmemmap tail pages are mapped read-only, improving robustness

I have only built and tested this series on x86. I do not currently have
a powerpc test environment, so any testing or feedback on powerpc would
be much appreciated.

Changes since v1:
  - rebased onto current next tree
  - added the preparatory minor bug fixes found during AI-aided review
  - added further refactoring on top of the new infrastructure

Muchun Song (69):
  mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
  mm/hugetlb_vmemmap: Fix __hugetlb_vmemmap_optimize_folios()
  powerpc/mm: Fix wrong addr_pfn tracking in compound vmemmap population
  mm/hugetlb: Initialize gigantic bootmem hugepage struct pages earlier
  mm/mm_init: Simplify deferred_free_pages() migratetype init
  mm/sparse: Panic on memmap and usemap allocation failure
  mm/sparse: Move subsection_map_init() into sparse_init()
  mm/mm_init: Defer sparse_init() until after zone initialization
  mm/mm_init: Defer hugetlb reservation until after zone initialization
  mm/mm_init: Remove set_pageblock_order() call from sparse_init()
  mm/sparse: Move sparse_vmemmap_init_nid_late() into sparse_init_nid()
  mm/hugetlb_cma: Validate hugetlb CMA range by zone at reserve time
  mm/hugetlb: Refactor early boot gigantic hugepage allocation
  mm/hugetlb: Free cross-zone bootmem gigantic pages after allocation
  mm/hugetlb_vmemmap: Move bootmem HVO setup to early init
  mm/hugetlb: Remove obsolete bootmem cross-zone checks
  mm/sparse-vmemmap: Remove sparse_vmemmap_init_nid_late()
  mm/hugetlb: Remove unused bootmem cma field
  mm/mm_init: Make __init_page_from_nid() static
  mm/sparse-vmemmap: Drop VMEMMAP_POPULATE_PAGEREF
  mm: Rename vmemmap optimization macros around folio semantics
  mm/sparse: Drop power-of-2 size requirement for struct mem_section
  mm/sparse-vmemmap: track compound page order in struct mem_section
  mm/mm_init: Skip initializing shared vmemmap tail pages
  mm/sparse-vmemmap: Initialize shared tail vmemmap pages on allocation
  mm/sparse-vmemmap: Support section-based vmemmap accounting
  mm/sparse-vmemmap: Support section-based vmemmap optimization
  mm/hugetlb: Use generic vmemmap optimization macros
  mm/sparse: Mark memblocks present earlier
  mm/hugetlb: Switch HugeTLB to section-based vmemmap optimization
  mm/sparse: Remove section_map_size()
  mm/mm_init: Factor out pfn_to_zone() as a shared helper
  mm/sparse: Remove SPARSEMEM_VMEMMAP_PREINIT
  mm/sparse: Inline usemap allocation into sparse_init_nid()
  mm/hugetlb: Remove HUGE_BOOTMEM_HVO
  mm/hugetlb: Remove HUGE_BOOTMEM_CMA
  mm/sparse-vmemmap: Factor out shared vmemmap page allocation
  mm/sparse-vmemmap: Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: Switch DAX to vmemmap_shared_tail_page()
  powerpc/mm: Switch DAX to vmemmap_shared_tail_page()
  mm/sparse-vmemmap: Drop the extra tail page from DAX reservation
  mm/sparse-vmemmap: Switch DAX to section-based vmemmap optimization
  mm/sparse-vmemmap: Unify DAX and HugeTLB population paths
  mm/sparse-vmemmap: Remove the unused ptpfn argument
  powerpc/mm: Make vmemmap_populate_compound_pages() static
  mm/sparse-vmemmap: Map shared vmemmap tail pages read-only
  powerpc/mm: Map shared vmemmap tail pages read-only
  mm/sparse-vmemmap: Inline vmemmap_populate_address() into its caller
  mm/hugetlb_vmemmap: Remove vmemmap_wrprotect_hvo()
  mm/sparse: Simplify section_nr_vmemmap_pages()
  mm/sparse-vmemmap: Introduce vmemmap_nr_struct_pages()
  powerpc/mm: Drop powerpc vmemmap_can_optimize()
  mm/sparse-vmemmap: Drop vmemmap_can_optimize()
  mm/sparse-vmemmap: Drop @pgmap from vmemmap population APIs
  mm/sparse: Decouple section activation from ZONE_DEVICE
  mm: Redefine HVO as Hugepage Vmemmap Optimization
  mm/sparse-vmemmap: Consolidate HVO enable checks
  mm/hugetlb: Make HVO optimizable checks depend on generic logic
  mm/sparse-vmemmap: Localize init_compound_tail()
  mm/mm_init: Check zone consistency on optimized vmemmap sections
  mm/hugetlb: Drop boot-time HVO handling for gigantic folios
  mm/hugetlb: Simplify hugetlb_folio_init_vmemmap()
  mm/hugetlb: Initialize the full bootmem hugepage in hugetlb code
  mm/mm_init: Factor out compound page initialization
  mm/mm_init: Make __init_single_page() static
  mm/cma: Move CMA pageblock initialization into cma_activate_area()
  mm/cma: Move init_cma_pageblock() into cma.c
  mm/mm_init: Initialize pageblock migratetype in memmap init helpers
  Documentation/mm: Rewrite vmemmap_dedup.rst for unified HVO

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/admin-guide/mm/hugetlbpage.rst  |   4 +-
 .../admin-guide/mm/memory-hotplug.rst         |   2 +-
 Documentation/admin-guide/sysctl/vm.rst       |   3 +-
 Documentation/arch/powerpc/index.rst          |   1 -
 Documentation/arch/powerpc/vmemmap_dedup.rst  | 101 ----
 Documentation/mm/vmemmap_dedup.rst            | 217 ++------
 arch/arm64/mm/mmu.c                           |   5 +-
 arch/loongarch/mm/init.c                      |   5 +-
 arch/powerpc/include/asm/book3s/64/radix.h    |  12 -
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 154 +-----
 arch/powerpc/mm/hugetlbpage.c                 |  11 +-
 arch/powerpc/mm/init_64.c                     |   1 +
 arch/powerpc/mm/mem.c                         |   5 +-
 arch/riscv/mm/init.c                          |   5 +-
 arch/s390/mm/init.c                           |   5 +-
 arch/x86/Kconfig                              |   1 -
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   1 -
 arch/x86/mm/init_64.c                         |   5 +-
 drivers/dax/Kconfig                           |   1 +
 fs/Kconfig                                    |   6 +-
 include/linux/hugetlb.h                       |  23 +-
 include/linux/memory_hotplug.h                |  12 +-
 include/linux/mm.h                            |  44 +-
 include/linux/mm_types.h                      |   3 +-
 include/linux/mmzone.h                        | 151 ++++--
 include/linux/page-flags-layout.h             |   2 +
 include/linux/page-flags.h                    |  31 +-
 kernel/bounds.c                               |   5 +
 mm/Kconfig                                    |   9 +-
 mm/bootmem_info.c                             |   5 +-
 mm/cma.c                                      |  18 +-
 mm/hugetlb.c                                  | 337 ++++--------
 mm/hugetlb_cma.c                              |  41 +-
 mm/hugetlb_cma.h                              |   4 +-
 mm/hugetlb_vmemmap.c                          | 266 +--------
 mm/hugetlb_vmemmap.h                          |  64 +--
 mm/internal.h                                 |  72 ++-
 mm/memory-failure.c                           |   6 +-
 mm/memory_hotplug.c                           |  22 +-
 mm/memremap.c                                 |   4 +-
 mm/mm_init.c                                  | 241 ++++-----
 mm/sparse-vmemmap.c                           | 511 ++++++------------
 mm/sparse.c                                   | 129 +----
 mm/util.c                                     |   2 +-
 scripts/gdb/linux/mm.py                       |   6 +-
 46 files changed, 743 insertions(+), 1812 deletions(-)
 delete mode 100644 Documentation/arch/powerpc/vmemmap_dedup.rst


base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


