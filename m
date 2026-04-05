Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B47F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83FA56B0088; Sun,  5 Apr 2026 08:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0AA6B0089; Sun,  5 Apr 2026 08:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF186B008A; Sun,  5 Apr 2026 08:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0846B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:53:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F32075BF97
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:25 +0000 (UTC)
X-FDA: 84624493170.11.B7565F1
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3E49C40002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="VuhyP/+v";
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="VuhyP/+v";
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393604; a=rsa-sha256;
	cv=none;
	b=yxpTscpEZc0XMVgAOC6gIuA+HW9qHIwBZzcTRMvYKTcQztAhdoRWemkPg6MSwCyXouXPN6
	1RudYWUfAGL4QJI4KK0GhvuBOhxSBp5pAeJ9Yk5KMx9BUZguJ4UEd/OyRpCIkz58qCw+kY
	w0dmIk18ZlZvOWDRWHYtdwVguWOIRxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vIYRrJ1FD8xk10dmqDqll/GEWBWA7JriVZCvyhEOAJE=;
	b=3emqMLLb2DhSm3goAvkICIXYxM8fLu42ZYXqIaV/U0Lh4YIDBgtDbbGuqHfG3eb0ac+pH8
	cb6tJThdbR8GRmEPL00mnI8WbYKHXOU8Wss8L5CaXo9QNlAOzQyyvQcIKLiz6EPieEVLMZ
	iRL4peFo5UsUNprJtS0ybJSti5lDZ2U=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so2029516a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393602; x=1775998402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vIYRrJ1FD8xk10dmqDqll/GEWBWA7JriVZCvyhEOAJE=;
        b=VuhyP/+vRNgK4wp6UsaWgod/BH4GdaNdPEP0eqIJPTwn/tEBQa3T1/oOOq4y883Dv7
         S1ld1cz9bk6T9Ng2wYFDLQCiA9vhfY0+dg3VTTBRlpFSIodAtXwQgggIAApSXTQ5xks1
         iC7rVc59uJuugEk2rHhGk9pYztpwwn+qwei4ycZMX3EpX/vmyZVE9uw03s0Wz/JYt8YU
         ZhLJ3neZrz/fH2THJH/R/knY6zfjTAkf2O76q9+Q10YEO87iqBHGsbp9jkAGVBbQd22k
         4hbwi3wGF8oYy8OpfXcyj7jmQ7b4KrxeJNmYlouKDzk6uoKtYxD/hM1CGD9pM8xoHroU
         wbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393602; x=1775998402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIYRrJ1FD8xk10dmqDqll/GEWBWA7JriVZCvyhEOAJE=;
        b=Vh1oRyWsl7nrSUYM2YYdxe4VPJM9mjVdTNYws9IcSG5gtIeUEhhM2heJSAoB9d/7mx
         +fjbJKyDjEuGuqgtVjr0cmmDqm9lqRx6dvte/KPjyjQP7FgJh7KZvAqMP1Y63RSisYnx
         pSPlElqNAYXlN0AMTrUJmGdYzbGmNMzrqE57f1HTHpV4b+tFjzGeEQ0IDNjAn3kE16rN
         DqaV22TgwCIYLDFsO1ZSTboZG2SB3InBrkHAtQfqr5ZyMRUQu6r342s17w18vppkbs8/
         UehBQ4hC9TmbyvCG0ZuOllna7UK9q5g1OfvX9Zo+9RccBc2f4N8tdK4iF0R6e3oW4YVj
         JNZw==
X-Forwarded-Encrypted: i=1; AJvYcCWug4kREGUaEsB3qlpY3fRyf9QUm6W0jNv3Lp5mIFXDKYj+7mYsyQLONqiXoGxKn2tO+zpGEqWESA==@kvack.org
X-Gm-Message-State: AOJu0Yzu7D3foRr17nXdOKKzDmG7qd7kC0wIEyY8I4aJhzlSpcPk48ZP
	/F34xEw55X0F2+tNV7C0GKHCY0vaPObUJZsl5aWF3eTvK4ApPTa7aFieVZLfqbN5jeY=
X-Gm-Gg: AeBDieuPPjyv4tjRBda+WCSU0K++2edRSB+Vtj4QO+ZSt8rUNAYErYYj3guHnfxTmM4
	aGkwVrRfvcefFep4WRGSKol3KYA6cL9+bAXD6xN50wvAhol/8FUYDmmPjT/JeoUstOAy09FfjS8
	XMz8WWwdnozY4ku8k2nJdWWGZcAvCMhyN1Op30btPu44vGWkv4JJeQV3b4SpY/KjMFjTKMX2cAh
	pthRSoY46uVTqATUG7FFgLXPtDB7AMXi8P9TM7pnBJk11E/flt8bZdRSQsjGsc4BbusPEfNTV+U
	pr8oiwL8w1bOiVgsdelXiyaKah+PptXgu4mXr+VhHReXzAMcONEIw68WBur2jFozsPI/m6domwv
	auH41jUv3EHRbte4yLpVcNPj1eIe6YV3txQhfYEO3c5GYFlt5W+IxRJZ7R/RjvzCusvL8lF6bu9
	gkYGe73/VYH8I61zI0lfQORWvsvoujuLFutoY7fsn50WXxnhr85UfgrA==
X-Received: by 2002:a17:90b:1e0f:b0:35b:e4f8:7cb0 with SMTP id 98e67ed59e1d1-35de691ad72mr8772276a91.21.1775393601639;
        Sun, 05 Apr 2026 05:53:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:53:21 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 00/49] mm: Generalize vmemmap optimization for DAX and HugeTLB
Date: Sun,  5 Apr 2026 20:51:51 +0800
Message-Id: <20260405125240.2558577-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E49C40002
X-Stat-Signature: r9n5iwk1cctsopdc88bfw4ua38591i48
X-Rspam-User: 
X-HE-Tag: 1775393603-325019
X-HE-Meta: U2FsdGVkX1/eoBPX+yJiTUN0U3rHYgI3YeD+9Fvv9jbCor6BsS0BHpw+jhLdEJvo03ubtD9eMAGl3zEqAIbz/Hys8e3ILPKHveCdlvOYvxU0TsqEuepz1oNSHRTe7PUo5AUl5L0Ztqol+TS5sfLvfBOVMP+RHotAANSFOJ2EnN8uHIe6I+uOhS3tkhrchR8qs0MQODT1OOGPwL7hVEUUDzpMxENe91y5Lxr8QLQFBku9PKItMHJfbQMQFOTE2DqjUtQTnJiZjyMx+PbMQ94at6B16YUh0EIpLimeJyT6W7o1VUb3swlCiU9t91qMRtZDlJKlWU8FDheDMW/KIqejf0ijbwr+Sipj/32O+uEiBQVWIwHPdUtqoOZAcSqHGG/3vI6cEnHk54JszFiErV4rS1bJEQfj7EgRV6jb7WaKs3aX4jaBa1LmrEbp3d31Tuo9WweHn7X1vYc9K6PO6X1eW+8qVi6sMBuDKg/CJPz90/af+UDdozCMXiLKv5N3UUBYZkzLZkInxykmTGs5bBu2WyEPTS6bina3SZmG4J2wP9/12VM7C3AF5+6qvVLFLsQSmmjYiCE3PpZCoGaTU6Lwjt4byfLzeVCWWNeIry4ZnvSgQpHlDazkHn0aVWAMTwug6KwtaJisDyCLvun1q1g+YGW8j96k4An4Jf7EPIIcPC0IcqVb/KC8mGxpJREAsT2mOCwIDPeA4uu/3vp9w4/OSw4mq6tIWh7v1X5RpImNQIcfWbnrYo828PWUeBRAXX11tUMPQPpKv7K2t3epN2qVXtQaze3vhjCgY0u2B2cc28H3ajvYpBY2BMtqpdVX72s9mCRQhak1zPlsvQqPXPfNk7ZbCduUA/C9OJcVwreMkQBHzItkogmjaLuV4xbbU40h5cDynTo0bPxD0dxokF6+gUUqGuJBeJsMpNUGHbRVBu8RJSdnUchhkXVfsWbpD0XvTOEb9sEUVeIIgW4SZTy
 tQiQ5V7r
 nAijRY5EegzLOAnM2bXKZDb5RO/4xtf9595A+zjnhlelTEnWQdlXGkTD+6rpG+b7rU4921aH2rw5GNg0u3bd109W0lgkzM3xYqtHWxeZvdQgNnrH6VH/HSu2xIwgZrrk/DivXWfW5690Z4UqN6rODwo8YsGCe6Vmo2YcOrce6CoGLEK3ff4Cex20s1S74V2BOgdFLPtmq2plPNDCmt+CY/w5zxiDvszAo64iKkAlX6k/Hx0ryxWNpqiixvZOdO6ktSDZsP7oPAcXaZkTb/dP9DNhSzNRNZyBWZcpW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Overview:
This patch series generalizes the HugeTLB Vmemmap Optimization (HVO)
into a generic vmemmap optimization framework that can be used by both
HugeTLB and DAX.

Background:
Currently, the vmemmap optimization feature is highly coupled with
HugeTLB. However, DAX also has similar requirements for optimizing vmemmap
pages to save memory. The current implementation has separate vmemmap
optimization paths for HugeTLB and DAX, leading to duplicated logic,
complex initialization sequences, and architecture-specific flags.

Implementation:
This series breaks down the optimization into a generic framework:
- Patch 1-6: Fix bugs related to sparse vmemmap initialization and DAX.
- Patch 7-13: Refactor the existing sparse vmemmap initialization.
- Patch 14-26: Decouple the vmemmap optimization from HugeTLB and
  introduce generic optimization macros and functions.
- Patch 27-39: Switch HugeTLB and DAX to use the generic framework.
- Patch 40-49: Clean up the old HVO-specific code and simplify it.

Benifit:
- When CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, all struct pages
  utilizing HVO (HugeTLB Vmemmap Optimization) skip initialization in
  memmap_init, significantly accelerating boot times.
- All architectures supporting HVO benefit from the optimizations 
  provided by SPARSEMEM_VMEMMAP_PREINIT without requiring 
  architecture-specific adaptations.
- Device DAX struct page savings are further improved, saving an 
  additional 4KB of struct page memory for every 2MB huge page.
- Vmemmap tail pages used for Device DAX shared mappings are changed 
  from read-write to read-only, enhancing system security.
- HugeTLB and Device DAX now share a unified vmemmap optimization 
  framework, reducing long-term maintenance overhead.

Testing:
- Verification: Compiled and tested on x86 architecture.


Chengkaitao (1):
  mm: Convert vmemmap_p?d_populate() to static functions

Muchun Song (48):
  mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
  mm/sparse: add a @pgmap argument to memory deactivation paths
  mm/sparse: fix vmemmap page accounting for HVOed DAX
  mm/sparse: add a @pgmap parameter to arch vmemmap_populate()
  mm/sparse: fix missing architecture-specific page table sync for HVO
    DAX
  mm/mm_init: fix uninitialized pageblock migratetype for ZONE_DEVICE
    compound pages
  mm/mm_init: use pageblock_migratetype_init_range() in
    deferred_free_pages()
  mm: panic on memory allocation failure in sparse_init_nid()
  mm: move subsection_map_init() into sparse_init()
  mm: defer sparse_init() until after zone initialization
  mm: make set_pageblock_order() static
  mm: integrate sparse_vmemmap_init_nid_late() into sparse_init_nid()
  mm/cma: validate hugetlb CMA range by zone at reserve time
  mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
  mm/hugetlb: initialize vmemmap optimization in early stage
  mm: remove sparse_vmemmap_init_nid_late()
  mm/mm_init: make __init_page_from_nid() static
  mm/sparse-vmemmap: remove the VMEMMAP_POPULATE_PAGEREF flag
  mm: rename vmemmap optimization macros to generic names
  mm/sparse: drop power-of-2 size requirement for struct mem_section
  mm/sparse: introduce compound page order to mem_section
  mm/mm_init: skip initializing shared tail pages for compound pages
  mm/sparse-vmemmap: initialize shared tail vmemmap page upon allocation
  mm/sparse-vmemmap: support vmemmap-optimizable compound page
    population
  mm/hugetlb: use generic vmemmap optimization macros
  mm: call memblocks_present() before HugeTLB initialization
  mm/hugetlb: switch HugeTLB to use generic vmemmap optimization
  mm: extract pfn_to_zone() helper
  mm/sparse-vmemmap: remove unused SPARSEMEM_VMEMMAP_PREINIT feature
  mm/hugetlb: remove HUGE_BOOTMEM_HVO flag and simplify pre-HVO logic
  mm/sparse-vmemmap: consolidate shared tail page allocation
  mm: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: switch DAX to use generic vmemmap optimization
  mm/sparse-vmemmap: introduce section zone to struct mem_section
  powerpc/mm: use generic vmemmap_shared_tail_page() in compound vmemmap
  mm/sparse-vmemmap: unify DAX and HugeTLB vmemmap optimization
  mm/sparse-vmemmap: remap the shared tail pages as read-only
  mm/sparse-vmemmap: remove unused ptpfn argument
  mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo() and related code
  mm/sparse: simplify section_vmemmap_pages()
  mm/sparse-vmemmap: introduce section_vmemmap_page_structs()
  powerpc/mm: rely on generic vmemmap_can_optimize() to simplify code
  mm/sparse-vmemmap: drop ARCH_WANT_OPTIMIZE_DAX_VMEMMAP and simplify
    checks
  mm/sparse-vmemmap: drop @pgmap parameter from vmemmap populate APIs
  mm/sparse: replace pgmap with order and zone in sparse_add_section()
  mm: redefine HVO as Hugepage Vmemmap Optimization
  Documentation/mm: restructure vmemmap_dedup.rst to reflect generalized
    HVO
  mm: consolidate struct page power-of-2 size checks for HVO

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/admin-guide/sysctl/vm.rst       |   2 +-
 Documentation/mm/vmemmap_dedup.rst            | 218 ++--------
 arch/powerpc/Kconfig                          |   1 -
 arch/powerpc/include/asm/book3s/64/radix.h    |  12 -
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 114 +----
 arch/powerpc/mm/init_64.c                     |   1 +
 arch/riscv/Kconfig                            |   1 -
 arch/x86/Kconfig                              |   2 -
 fs/Kconfig                                    |   6 +-
 include/linux/hugetlb.h                       |   7 +-
 include/linux/memory_hotplug.h                |   2 +-
 include/linux/mm.h                            |  50 +--
 include/linux/mm_types.h                      |   2 +
 include/linux/mm_types_task.h                 |   4 +
 include/linux/mmzone.h                        | 143 ++++---
 include/linux/page-flags.h                    |  31 +-
 kernel/bounds.c                               |   2 +
 mm/Kconfig                                    |  20 +-
 mm/bootmem_info.c                             |   5 +-
 mm/cma.c                                      |   3 +-
 mm/hugetlb.c                                  | 143 +++----
 mm/hugetlb_cma.c                              |   3 +-
 mm/hugetlb_vmemmap.c                          | 237 +----------
 mm/hugetlb_vmemmap.h                          |  35 +-
 mm/internal.h                                 |  26 +-
 mm/memory_hotplug.c                           |  15 +-
 mm/mm_init.c                                  | 138 +++---
 mm/sparse-vmemmap.c                           | 392 +++++-------------
 mm/sparse.c                                   |  85 ++--
 mm/util.c                                     |   2 +-
 scripts/gdb/linux/mm.py                       |   6 +-
 32 files changed, 513 insertions(+), 1197 deletions(-)

-- 
2.20.1


