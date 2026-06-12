Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0918DCD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419216B0005; Thu, 11 Jun 2026 23:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA2B6B0088; Thu, 11 Jun 2026 23:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA0C6B008C; Thu, 11 Jun 2026 23:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADE56B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCC631A03E3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:16 +0000 (UTC)
X-FDA: 84869905512.10.AF4F215
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8AA5E40003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PQ1jaX9i;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qXrTtpT2gfzfA9UVBfYwsqqZhVEbHAXGcBbRyTvn7RE=;
	b=vDTvv/S54hO7S8MH/JpqT50i0/Y6QtLNdT0Gq09dxsVV7MNZxBiuUjP5F+M54DWrwU/gkA
	pJxqN4lI6bmVZZs3S3JgTnORwpKmwSlGzv3P4lwjGLWO9I6BA/PzZzQaJ6z1U8EYysjafk
	8fQpkJGXf5zNTH81Q9icxNjAzB9ZzAc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PQ1jaX9i;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236755;
	b=j9cbwd0IlYq/x9P2eI/ZDFfupIAIIBiUlINMKapk6kRy4y2TVoKKATaU8u6B3nyzQ1wjgo
	7abix23gkiJ+z1eeQa+DFFMbNkI6b6RAazyPr7NpXEbMxIvo4mmz/OsYUQ+gjVf09m5gvj
	38A98T1Eq0pfCR3iREiQfvCpHuaxPmU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84232e83ca9so293046b3a.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236751; x=1781841551; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qXrTtpT2gfzfA9UVBfYwsqqZhVEbHAXGcBbRyTvn7RE=;
        b=PQ1jaX9i+6vPF3ToeZWavROP9kxxyNNDiZZ80e6lfj/U4sq/rqWOtRaZ/7VBpcpB5z
         KyX3Cg3En9Zc0ngETvEFvM0wbWX6rm3nIwED+pcgQaGBT2i5Lu219j4tUI736rdnbI9X
         ROF3WQsYRQ5ewCDPVH0THduwsaHXy4BUBLxstlG5rtu53Xszv178lQT2jMiB1UwIk0sf
         64xrnG4OfmfGNy+TUDsGUrA4mL9gMcyb9paA6XgFczGnpKFZw6KZIc/WhVwsL1jN/8rP
         qjB74Kn+R04BYREoXXVo5A1FNsdkkmhgeiw//MGBnuLXEFMd9jfzTR54J8NJ2yYrbbp+
         ZY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236751; x=1781841551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXrTtpT2gfzfA9UVBfYwsqqZhVEbHAXGcBbRyTvn7RE=;
        b=aXBdDykA4lTm2PaxTohsYP8mtA8BFpXAMarw/Cy6nibf32mHoCUqFRnoxsPQwjfHqW
         tax+sOPImgpPtzn6UTUyX+8M8mZGITu3Joy+tSK/F46Xm+6r74QSkz4J32rej1RoWc9r
         pyk+qXYdHeS6orRDVtiwBMO8YC0F07IhJ9qFwj/hUYOMQ0g3/CCZJzENE91NNryXWeyi
         D38W4L65+9lpzhmX1Hxd6f9AyVXYsOdCL4xrS3Su2oWfXfIxwMI7P7nN+8aOzgWx1ha8
         SlGvfWTsPQpyK7GxUZUCWIlS5HVv0ojclBLLJmALdl9TDQFyyTew0etCufKUT5RniQdu
         GNiw==
X-Forwarded-Encrypted: i=1; AFNElJ+pwAOZkj0LDG2lkJEbnguiRAcMhMOPOCNRTjf33HUTYGEgkmsek06cmNKKB7zjANJ6Ve4xg4vGkg==@kvack.org
X-Gm-Message-State: AOJu0Ywj4KiC/lDObeo2stLCoL0NrNbLgNIYUcSiXDTn2nEPrYWABvYU
	9412Ym9Bcg6Ic2N7+atpo4lfpOwnYNKEorPr+NStB8UzM0//4oVaOs+EHiVrMJBTm/I=
X-Gm-Gg: Acq92OFbCo/a6LoUvkmfC2FiIJaf661Ydd5zejB8ZN9JXb/YbKfZ+QqWhXRbqRnw5/Y
	okxII/Trl0ReKu7ZK0af+cHuTClN3F16s1b8IcGDBzC2smcDMxWbdFafLKLyjWaD1oaE0kVXcKy
	ALNnD82z5xf3WoOhIow8WlkUpStAjZ0rKw0z3Ru9VkCHtOOIwAVGizV0TkSFmg3ksIOmkhlrHig
	BRxFLplFeXZrPXJnrOcmx3guCRPSfPs+GDkBi0EIpoicMlZ5jMm/RpSlb6fjii+am26qk78geFb
	VQmHhEYHiSyZgW0aED1SiQBs/zaoSiUvxYyrmzyDLbmxKSSA5t1oq/8kU1cUxS1Aw80a61tBRAO
	cVfuo6Pjq0xZmvwJrU2qGyDqB3TqnG2BWnZ2RXg3+2KA4uwJpCc3Y2gbhwFzzzfo2DZ/AG1Y+v1
	lBfsvf/glgFVVSF5e4BdawA0/jasgoQDgwjWvzJyxNr6s=
X-Received: by 2002:a05:6a00:3a29:b0:842:5b63:6118 with SMTP id d2e1a72fcca58-8434cd0b6e4mr980556b3a.3.1781236750991;
        Thu, 11 Jun 2026 20:59:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 00/19] mm: Refactor bootmem gigantic hugepage allocation
Date: Fri, 12 Jun 2026 11:58:44 +0800
Message-ID: <20260612035903.2468601-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8AA5E40003
X-Stat-Signature: ntustj34rjz1zgs5o6943ghds4n9dbqz
X-Rspam-User: 
X-HE-Tag: 1781236752-353703
X-HE-Meta: U2FsdGVkX1+BqYGVOUjt3qp61HOjEuzDanGdkQ3qlXGhDwOvPibeMpENeAP3m8CJGu6/c17+KSgCw+G7d3GyRcZCsezidn0Q+hAJ6z8pMif02EgEIUPdmoQ7c5PGiGk3HuAgvcebpqxZeLKGyEw3H16lVp8UlZ7mBBSbRQX5yOfmtTtxMfqdplCfe2YYhH4YonnzjRxIrAqg+rBJOrZzgRVPgW/o29wAZBL/clQQCZxc0T9W4BmZax46YYWrB3rufG9r8w+HZ+cuC7Ih3ZaxU367zITUREVfHwLHEZacAcgjWNLF4JNNvIuFQvMfhgIU7WA0lX3MEP4+fXljeykhaBJZ8vx6kJt5YSvFuGku+NeXxLCg3giuDSiL7qiI9zIGGy6bZQIkDPNVa1fJh4wmLJx1nfayCI32mSOrsZzndFJXz5Kb2vOnXzqKYDlzSMQC18QOHedQ4E545xUzE8Geie/JjHCLH0lRaqnf0wShwK52ospR0WQiGxFPANMn49vV0XPXzqBagBqUu2utoUNDpoPtn5T2d8do1u1A1yvy/h3D8zPtdFGRPEGHxCVNOj8ojVKU0cXzaK+YsX54gGH3gmGMBx5WVLn34YSZM7Ra0mrZZD+B9NDWEtmxzh0sp7x+Tsnpu7+x3pgwf+zpNXZNaauuY9IJzcncVR9eE0hIeSVdqwYulZjb6uwpQc3JHtmjoLfAelu3juju/ww7OBmDfwpFctWTpWNBt2lIFKJLZiBNIZj/4JO+L2Sp41rrGyzDLZkWsRs31edP8QBH5SwYndDshm5GnCqQR4wlTOVkNX22vfUGcdkuhqJz1MtyNTiAr+QZ2ahpgStMtwpMhoK+BLhnp3Ce/BpZZY19BwTl/88L3gRUznS2NX/uUw8Eh9HTYxwHXNsVVOEBIb7r2t1FV4L+61lKEmizNDqXHq2hkCiwcJTkrNJlJI9Za7gTX9hp1e14Mtz/ykoxz4hUgpv
 TAa4CaCX
 fltr1ncqZ23aS3nmYGDEhAWeLVCvMnamq5HYCs91/aQ7XpDMkKEvZMDCRkSbXAq5DWIVbNlzXQPOu/FlS25mXew66aUI46ScylNT7VdX6sbgj7JO94pGZm9/ELnh9yv7zV9qVlf9d3o0GDCDgQk/AP1lSqH3SrISsekv7tEsPAKvxcqnOW4HkpDmNunHJ+8cumQqD6ywsiv54xRd7oJUMSSoWlD0hlD94OJjs5XzNgxIQpdFhbm4kyDTo+tgOAaqOAiaVN1QGm4gMMPoGuUGgHGaEOkKo3Mk900jtz8wcVv/M+r/gNf9xoxeOd3+9WM94CIUxT2iZOs9J1ydIk1JwuTJsU/RB6FXw6RM7B3LwmSJsefJgrI/eNzKSWJvf/CFdNZJj/6olruJ6eSYvoURI58ckX+4/jS97S4TTB16uRgxfFc6Vk6yrEe+hkVQ6OfIIL5zy1WTeqQnEoXCKTvRwLrteRj0LQKzL+OwaLCQqYd3F6D42yp7DxwXpFw==
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

Changes since v3:
  - patches 2-4: add Cc: stable@vger.kernel.org to the applicable fixes
  - patch 3: collect Reviewed-by from Ritesh Harjani
  - patch 15: move pfn_to_zone() before hugetlb_vmemmap_init_early()
    instead of using a forward declaration
  - patches 15-17: collect Acked-by from Mike Rapoport where applicable
  - patch 15: collect Acked-by from Usama Arif
  - patch 18: clarify that the changelog also covers the early CMA
    bootmem allocation fallback refactoring
  - patch 19: initialize pgdat at declaration in
    __init_deferred_page() and collect Reviewed-by from Mike Rapoport

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
 mm/hugetlb_vmemmap.c                     | 120 +++--------
 mm/hugetlb_vmemmap.h                     |   5 -
 mm/internal.h                            |  14 +-
 mm/mm_init.c                             |  86 +++-----
 mm/sparse-vmemmap.c                      |  26 ++-
 mm/sparse.c                              |  48 +----
 14 files changed, 251 insertions(+), 413 deletions(-)


base-commit: ec039126b7fac4e3af35ebccaa7c6f9b6875ba81
-- 
2.54.0

