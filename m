Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3ACCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4713C6B00AF; Tue,  2 Jun 2026 06:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422456B00B3; Tue,  2 Jun 2026 06:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337C86B00B5; Tue,  2 Jun 2026 06:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2731C6B00AF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:10:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E609F925D3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:52 +0000 (UTC)
X-FDA: 84834553944.04.CE4FF57
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44BBB10000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="O1eB5C/8";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zNGpJprl3yzyJVtHG2aqs675IpD1ef+Hoi2rqDj3HMc=;
	b=ADnlI2MN3kB/anBT+4SP8/XTLwKrfqvsU49McolfeVJcv8wHffCWGa8YN6ZItA5vSfoL9p
	ZHPVltAmGSvPYnX/iXIv46PfU1XbPBgPwmWHU0dSC3X40123DITbDsbF2fgJ+hzSs03WHv
	5Iixd1+YLhYAEPadjn1LfuV1+zO9ERk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="O1eB5C/8";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395051;
	b=4e0NvgYAIRw87CwS45gt5H59UJTwE0ZpzM7ZKkaDZMq2XiwctZAPM/FeerNNQZYT4B3MMe
	YIQF5zoUYx/abEaEz5o+YhmOTsRv4XIKMpvu6Cr0/uRvZld8OkG4aLfrLUfcGdayYTZ2G6
	Qk0obEXsL0foIbLJIdGh07SEM/xL5SY=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84236f9b638so1132782b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395049; x=1780999849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zNGpJprl3yzyJVtHG2aqs675IpD1ef+Hoi2rqDj3HMc=;
        b=O1eB5C/8WVOts6lukHP2jTC1MGCavCDJjdgiJaRlFZgBY+3FCc+GLbEyuDsUOva0lW
         38ev/B9eZ4ff88cXstnr3pnZmNzUGZgPQzFOaKJfdOHIrIm+m/TUsKFQW+gQ1Dsnaozb
         WQamavabVeR5I5GPP1C3SJXHhBOhr335dqNIHOlamSC4cU7YFxFNAfFqRq8uWSZBFa4Q
         MAfCcvm3xqDfgV655OLmeuzFRCtPGb8NQc6tYsCTtPT3n5u8nSnE1QtyL1qxYhhpAA8z
         jIi6YcnmwTTJyYjBNoecmU+kEAVb9ftqc+L1j18Pd0ycIc0cB/kvI/6JeYhQcjfNgdPg
         3ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395049; x=1780999849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNGpJprl3yzyJVtHG2aqs675IpD1ef+Hoi2rqDj3HMc=;
        b=KzAQMVUjd3Jj0ofzKvbmtjhoCtvNy9O0lAZKL4G/e+OURVCxlA0yYv7gEkA5Glgi5k
         oE4R6CzdIbIabOx1X+juovIZ6TnJwzO/r9cE3nTP89uRCZpklFfLalshChv7qqTM8CHm
         92zMrEhiLMxhlLsUNeALiV0OMb6Hy2Z2ib51KAHBM4/q7GeT7osvMtEcY1rdXIlDkJem
         1+RBTfwhLHcRDPC1mVH8iBsUxXeZZlALV0iggXR3kKzLYlR2Ep5wWEHstRWgM1CmmG6m
         7m2rWNL6/8S+UoJ9teTckowmVVgiyKBhnp0XP/dl8YQARoDpKjktvMEQ0fIldF1wHE44
         238A==
X-Forwarded-Encrypted: i=1; AFNElJ8xZXK2cfZuQVEUElrGzZGdoiqNkwLfX6ApbkXYRWCo6fbX1fo/4KgDn+rabAvoM50ALFaMwKTlaQ==@kvack.org
X-Gm-Message-State: AOJu0YygxPgeIPdjAOKTibrc0S81P4gBK5o4IJgRltfSH7yJL+zALA9N
	4HD9TmvS3F8G1aANbXTbDQCoUL4KQfixjni4eGOQ6jjM8FffWufgyjV/XiD2mLOGCd8=
X-Gm-Gg: Acq92OGensYkHWvW+KjhtpmvmQsXKTkHL+Q8FvCiW+I4H1V3h9rMtBbYJ8SyGFEJY9c
	2OxlAhTywjqCFymb67+88CeKl/lky0lqbiCWVKq9TdNFL/Dx20TvR+zPaQpP22oMs9+THHB3H8E
	ZYAEi4YDy+SIQQfyXJn7bLGrVnqipYFxrhN6TPL8/YeE6NUGeP2ZaZSSbOLVKmzqxbVNDUJC0y3
	AVQaadYfjk1OKPnrM2J5wnFgvdM4gdnLzNX6QIsPCykAlYD0KQ0ag+SBmyGSPswZQIniOaCm48V
	Od5X9hb3R9UOyBtadCbDgLrFf/r2yS0Kv4AuYf9hYCQc399cphEV2aCOXPGA+sURbsKCFkKSalc
	jjANi6r/eSpmNwx2D425RR3hfAc8kzHoxLSjCQCof+R/6mptGKshJ5PCmyXBZtTPcoWzY3pG5Pa
	CLgZge13UA9RSa7PGNVXEX52IDmx0OYT0Mql1ke4O6zLq8rPLIENAp+30=
X-Received: by 2002:a05:6a00:6f50:b0:842:2ae0:968d with SMTP id d2e1a72fcca58-8422ae09a48mr11734407b3a.32.1780395048489;
        Tue, 02 Jun 2026 03:10:48 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:10:47 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 00/19] mm: Refactor bootmem gigantic hugepage allocation
Date: Tue,  2 Jun 2026 18:10:20 +0800
Message-ID: <20260602101039.1867613-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 31b191em1kbu8xpo5pct6bqzj1d1qh1z
X-Rspamd-Queue-Id: 44BBB10000F
X-HE-Tag: 1780395050-977515
X-HE-Meta: U2FsdGVkX1+EFB6hqbwITABwB0AAJDfHM1EaDFAnzvik4BLaXsj3WaQyHJ+jKjT7fOE1wICEAfSC9UnPXPJ4dbKVzPIZq4NsT4WWiDNiXrsFkpX15X/cepWJoogfkLnRE/tOUcO+vFCN5x+Fw/95CI6Ug5o35gUNGp7ZxcDHanAJhRdxnZfRYNFBb2xg5+w1PIAznvQ7+mmNPPpFu9DbrOaLk8FhMkMKhA0CsKTZGEaN+6NwjqynSFNJngDS08jjcI+Mdal+exLy6wXiPLK3HR/+N6MEKXmU3CYe+9su2ixNJv8dW42hHKaj0W7UqZl+hlDqc42f0dEIaH0LKz7BrJo3Opz32JuxT9tn004o4bfEJyBQE5z5m2FI34M45mxWFGOwyNzVGiASZFBoP7eog7tPGSI/SaHt5FG9qnYGKi97nyLfueJ8Oq0d/aEtkYMvNP74bRsZH2LQAGz6hJu33M5nA8+YmtDdJUbrG4GKBVmA0zve1LgeZabT30tTxqND5kThTSf2sM0/RB+QbM6ZldIELktjaZMGg2jrRAbG6j476GNKkXDllHxM5IPNxZ9c0HWcRo00Rs88rRLdf3pUWMkq1hs//ry2jlBziQOnQvLbKSUg6Neffhok0u1bc3WUd+8dNpbE5K8Pmo/cdoNa5WDRXgPVdHBFfpf1r6yBM75XwjjW2FPb8L2nMAXU61elMiNdNZdcup3tAPESIZhUsswdu3bahCo7BuijeRIeAzLIUTV9M+olaZI7EcBgqb2G6qR0j11pV76xSubU7dUPSdHHxRqNadUA5cqpnM3AwGwCYHc6RbW+50ommGA/VPNTqoLe8LLA9ZArn3YIEWjsB+z2z6oTRbk4LZBY2C7ZFk4DgFLAEBsOi+BsuXvqqnhLTHDhe5Aq/JyiNalIa19C9Kwe0AbaWZwTX6TFlJ9KotB8O7f5/JEt2MegCMVjRMJ11X+RSoQUuFgWDcNAcw+
 LRWkXEuT
 mH0x+unq4Y6YD23xXbmT5L7G9MUQM6ZTPFF61dJrhiniAmbsN+StiXLRc9kAQ/M5Y6V0YTmbCabarrDoxgkFFkuhDMjxslGvE+cP+WSz/mgkuOlwA1DXhDlf3Nr2k1i5yikU1Zqx78nKw9Gc7YjOB6mF4xcjZiG6tWB2O9gi0Y2b/M+oNU+46TdzeyatpJF+xP53JKH2rxFnYuFQfAGY9ZJIYoEsWZ8WCu4DGuoBjqYbdL5cnKPobI6y+0gYAHegUmPSqnVuCL0mPnEec3qp6/Z7UjSmfsrgTs7GiAOwG36VLI5hWl0T3moeZICwJMqkTNzk15Bwq9F/uo77yLMWFxfVt8pyXGa1mJD3oRsEqi+FKRJgcNe123+NvXIJTxGlvyZfn0QYv8vTT6XigT+49bTleX+SoyEOUfOH7LtnnDg5TBsZ2n7DqKzQCYtHDpkuapXf9ix4My0Z8D6Vt0bou3E3OhPQ8pQ+l5r4i+nuH7L7O+NNjV3K0lxMIQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is split out from the earlier larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. It collects the first 19 patches of
that series as a standalone set of fixes and preparatory cleanups around
bootmem HugeTLB handling, sparse initialization ordering, and related
vmemmap setup.

The first patches fix a few bugs found while reviewing the existing
code, including incorrect bootmem HVO handling, wrong vmemmap
registration arguments, a powerpc compound-vmemmap tracking bug, and
too-late initialization of gigantic bootmem HugeTLB struct pages.

The rest of the series reorders early memory initialization so the
relevant zone state is available before sparse and HugeTLB boot-time
setup runs, then simplifies the remaining bootmem gigantic hugepage
allocation path and removes code made obsolete by that rework.

At a high level:
  - patches [1-4] fix boot-time and arch-specific bugs
  - patches [5-12] reorder and simplify sparse/mm/hugetlb early init
  - patches [13-19] refactor bootmem gigantic hugepage allocation and
    remove obsolete helpers and state

Changes since v2:
  - patch 1: add a comment explaining why shared tail pages must be
    initialized from gather_bootmem_prealloc() before
    hugetlb_vmemmap_init() runs
  - patch 1: update the stale sparse-vmemmap comment to point to
    gather_bootmem_prealloc() as the shared-tail initialization site
  - patch 2: collect Acked-by from Oscar Salvador
  - patch 19: fold __init_page_from_nid() into __init_deferred_page()
    instead of only making it static

[1] https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (19):
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
  mm/mm_init: Fold __init_page_from_nid() into __init_deferred_page()

 arch/powerpc/mm/book3s64/radix_pgtable.c |   7 +-
 arch/powerpc/mm/hugetlbpage.c            |  13 +-
 include/linux/hugetlb.h                  |  24 +--
 include/linux/mmzone.h                   |   7 -
 mm/cma.c                                 |   3 +-
 mm/hugetlb.c                             | 259 +++++++++++------------
 mm/hugetlb_cma.c                         |  44 ++--
 mm/hugetlb_cma.h                         |   8 +-
 mm/hugetlb_vmemmap.c                     |  94 ++------
 mm/hugetlb_vmemmap.h                     |   5 -
 mm/internal.h                            |  14 +-
 mm/mm_init.c                             |  88 +++-----
 mm/sparse-vmemmap.c                      |  26 ++-
 mm/sparse.c                              |  48 +----
 14 files changed, 241 insertions(+), 399 deletions(-)


base-commit: 08484c504b55a98bd100527fbe10a3caf55ff3ff
-- 
2.54.0


