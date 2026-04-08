Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B8810F9951
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64DD6B0089; Wed,  8 Apr 2026 11:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CE36B008A; Wed,  8 Apr 2026 11:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952C76B008C; Wed,  8 Apr 2026 11:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 872BB6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:30:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8949C06EB
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:30:01 +0000 (UTC)
X-FDA: 84635774202.08.674BDC2
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id B8DC54000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:29:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y4GN5udY;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of fvdl@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775662199; a=rsa-sha256;
	cv=pass;
	b=lO/Af8279OE0Or2yB0xbldHtCOgTbmJvYB3RKnbk/TN8PBahQt7z2OqgeDi/hXVDN/tZdJ
	IkbeVnFk4egc9IkP1DUajL3maiKLzYhHTlGMFNYO9rB4N03xswKiTUIjyVHFyqZZd/V4s4
	zLX8JQTgjH4PkDvhQ36ha9hwob5rezk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y4GN5udY;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of fvdl@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775662199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJHD6SMQiiS15OEauGdACHyjg3IeXbof2naajJssOZ4=;
	b=3vCg3ElL4y1/3xlKAvScMZYc9xgn/VOVdXgm2PPlQH2qvG2YVuDJ8I+v0K6xrhF6afnyGT
	8lyxHIp/jwYrXd5ojO5tjDPb2vwC+pqU7ChUxXu2MrPkJSAdNQs7W0ScUpxd3z6ggVIrxW
	TBKDBltuVtCovCV0OpPptm4WMkNKboo=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488879dcbc3so131175e9.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 08:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775662198; cv=none;
        d=google.com; s=arc-20240605;
        b=ZrPXy7Puzof2q8BBeFwf4GgId6pa9OWMoV3Rge+COz/wbiIDoXcFeu50KsCUsivnjO
         Bn1JNJH0XnOxzvKfxzclhdqT6+UYPKvsRVmiYyYRiXq+Z/leAuvyGFwK6PH6Y57mR1FM
         r3BWNLC/6H+MwUNq8V8vzsGL/kIYI1y7C9KSgO9Itc+BxTuAxunEjj3VCa661uhJ/pQo
         uMrcAIkIi2y79dUFwMtG1x4kM1zZviHFrwGE6iRkmZYXwH/xvABBOKsU+zW7nFWmsAVE
         DbA8lWFS8HuON/VwMF9snxlwa3ERGu6C/W+cQSFYTdX+GzW6cB2406UO8VGwrs2pTQCr
         wt3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sJHD6SMQiiS15OEauGdACHyjg3IeXbof2naajJssOZ4=;
        fh=h/LJ9fo4Xigp5DBbrQNbb5saygQ6t9juH5ufqc5g+sk=;
        b=IDD7+0kOklwj0Yvk1uYkdFhKHZseLjIyppfYCH7j0hBytuPCc24uVGGiedf0jkuDWI
         2XmGJLXH1ww2i9X8aUP1mLyOALykOsGKFchbfKYxHOaDxJAqZObuxay3V0zDdcPEkYzN
         Yp987DG3+/HMSFC0IwosbdHXIJfWNhqqsTW44y+26kiZuKyEwe2WEMsJMMePYC4dnh6N
         2sK04A6vfIwV7z2FHnpgmhh4Yhw3g9k02PGh3GPIeIsivrKuKJUlvr9oPuibKd7c5Z6A
         wtu3epf95mt3Qx2zLdPjzVL7rqgxkq9vZz3PwU8dOEgPbO97AbrmTwZP4ktNQdqztuKL
         nLJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775662198; x=1776266998; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJHD6SMQiiS15OEauGdACHyjg3IeXbof2naajJssOZ4=;
        b=Y4GN5udYvme5ij6G9ZbMpwVhSKMSSGKzYfAYUEk6kvdn98u6Ncy21WxsfYCsld/LN3
         i+1DWXUYDE7Plzs4RQJDrO0p2HVY7biPvnvvieNYFPYxiNTCWwKzNSfxX534Qig9aOsm
         CkVHNtMDnUJS6LNJnxSwSkSofv0JMYQwK6waTSfhLwZKxRGtaPp+zkjb/xnviqNQegCc
         kcWHDRtjOgRdG0a48GVd8MA1lDnrU+ssmqyoYIW6W6qE+pL1BqYWS3KIOoTmcgKiwSM6
         521VoKgR7zwfM0AWmPmmmdgnMd3C4WSSGobrIbIQSJeDFvjbMiWJNeJM7wChObpBZmw8
         LaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775662198; x=1776266998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sJHD6SMQiiS15OEauGdACHyjg3IeXbof2naajJssOZ4=;
        b=eEpHlksXzaytyW0l9ZBjML/Pn/9j4vgFZK3LWv2lLT8kxk/wPYU1ahEdDJoicWgzq4
         3TZEXY4lwNvWvVGBR+aWB6iXps2e+flzr4eqPh2Ok9NAylSWskBhiRrzQCxnDFto1vNx
         8FdtwNY5KVpkV/lIwx+s70zNSWqaFFsMIkG2aYsS7puTTZuTXJtCSFirqU8sM542HDzq
         uxKLKTQR97XvLHw1S7I2zY9O6cY6wvpzQsDwrddQjtEWR9wedo91CGb5CoXUieGQx4sv
         /ZHLfXG5fJvnPEP47k0E5vW3mFfxUjCPJQ0ccAMgwjoMHUl24Xl5r3fJ0VHMzGN80DdH
         41Tw==
X-Forwarded-Encrypted: i=1; AJvYcCVD5OWgohJIX0Cn9MXYEV8rAUrhe8o8nEgtzM/kJvQQd+wk0LWOS1EpS8rDyKAMHoXiJ0SQDqF64Q==@kvack.org
X-Gm-Message-State: AOJu0Yw616c93kl7orb+bvAIs/kyd9qTTBa8lgBcLWuAaWCF84Jtbkea
	dwVSYmdIZlBX9LjxRZQDlhlnZ17CIq2d78Vyj+DX/lYwd6UXPm+rL6XS8T/NJd/MY/Gy3Zw2DrX
	ONoe47VIpEprgIkTGuH2p0a9W1IXs+Xe3k4kQ5c/g
X-Gm-Gg: AeBDieu57zxjCz4bJsG0TRugNjUneQvnZtNHw3QcNBF6BVQhmfRTnY1SUQNwnCU6eIn
	ogY6eNlyC3T73hMFBK3f70UFZe0pizLQrhn+Lpoioy8rlR6Ikk1eAp+JVYV+dmKCjNrT4utQQkl
	g58j5AUHDzndbhySrQM3jUfRMNjzTiUbVCJUvVDlZ/A+VU5/H/RxFfKa2omD4n23lrYOM3qqDcD
	SuniABQoQUuk6bIyYNVzwWT7j0V3pYpFm5GHXZJQimeegl8PZIycyfE3ElCzOpg1o47z3a0wUjQ
	z99HEXY=
X-Received: by 2002:a05:600c:4612:b0:485:2ab4:c1f9 with SMTP id
 5b1f17b1804b1-488cbf2e5b1mr176595e9.4.1775662197639; Wed, 08 Apr 2026
 08:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 8 Apr 2026 08:29:45 -0700
X-Gm-Features: AQROBzDIxpbHHhnqGHn8vjelH9Nu4WEufqUDV3KFtdzQowFVpT_ZJVEDEErX9Ks
Message-ID: <CAPTztWYp7P=zALy_R7evjZPmQq_xMUOD8QR1wOmJHqcaENJ7cg@mail.gmail.com>
Subject: Re: [PATCH 00/49] mm: Generalize vmemmap optimization for DAX and HugeTLB
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Michael Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uf1cptnwczt4yyy3a1qr817k4atdimrs
X-Rspamd-Queue-Id: B8DC54000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775662199-19389
X-HE-Meta: U2FsdGVkX19qsYBGR4bwYf84vXpa4UtAPdhTExctr/ILc/b8CTuK9cjf3dYNvcYBo4BgRYpRmjBTyZH5LNsYjQwxmEp4m5W1Sa9zp8ruz5PqkJkXw8itY2nW7FdWmSRRH7J5GzOEDfx85fH0WvS7/+b+S1W7e6yamdcHh7Pnd2zAjZSGAG2Mm8E/CZtLWtAiQtBENkEohwPodOiIvpYt+lsN1WXWrf+6SkT3W74DKuCdSL/E5jtEU8nHQ3cXDWqXVtKIcFEqHzno/bZ/n9Gm01wi4t4YdZWluQkCgem2DwZa1QKvF60iMVkfISR8DvIcLTKEMNdjVkDwL3eyXAsQT2M/CKdwcbxbfiAh8IoKFeWzJ7OV74CbMQ8WXyE4aGdhcbxHt07q3hjaX63cSR5G8xpqRJasXPvB3G3HDAsym5x96/8poNZ/Rf6LgkueFIdXXVAGE4ao/xG6ny7TxJQrFYXk00dUIDL/5wClx59huOMsER6WD5fZDdcPpPY+dQy4nCMXxlOC2K63KoU3qTVGAquzFE+WC1szvmkw24uGKhULwCal59zrntdWW0O5norK0Av9/vU536po5NuSgrXxpLD+X3zaSLB7kdqC2sf+dzRGZwVAwP3H4XlrfdRoLONWSTZHwmgEkHCtKRzp/mpvN/V/cgiIvSjHPlqIRhQC7P3TyEO19DNV5WVUBpdl+PSaJim52vBniwvmENDLNe2BUxNDV4ZetaZVdhY+qF5BkjaBmt5ZwxNbAtLjftxhPH+sbtZCUSfsI01p908jKyVhELAMok80Ces3FvvTdUcqjeP/CafmscRodxHGZU4et3YBL3OmNAOtOfg2KKb9DUcfElMaOTl8rW1SZyEHdH3KCrG3rKQMY4l0uVRkqfLgKrd1nQxqCJUo2oSeTeR1RGJrsSgw4fJDAuu+DhbLiE1iUNAXyhFchEIQda+rCr7DYfjwBi2dWrOXF55IRdDZPuP
 8rEM3sLE
 X6+D46v77NEESKiSstryeJzf5NSYnDh6N3eW72X1IADia+rHPcjJbBgdQGdZRoNYlkH7HZlSwlNIuw4Bf3pR2r/ozNrffakJJsXCqm83PpU/S3tZ9uy2X771gqIa1fxkx9cgbRMzXLfF2ffEy+Kq8Hj6DS/Db/Nti0X42OIk6EfbFLYBR12eCprzDLEOQbQ+OBIRJc0NLX16dlW3g9CJijoCrtnpqvI1f9j3a6QV8rsmgW8qFUW4T2ULl9SoHds5s7HJgIZIcC1glXuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 5, 2026 at 5:53=E2=80=AFAM Muchun Song <songmuchun@bytedance.co=
m> wrote:
>
> Overview:
> This patch series generalizes the HugeTLB Vmemmap Optimization (HVO)
> into a generic vmemmap optimization framework that can be used by both
> HugeTLB and DAX.
>
> Background:
> Currently, the vmemmap optimization feature is highly coupled with
> HugeTLB. However, DAX also has similar requirements for optimizing vmemma=
p
> pages to save memory. The current implementation has separate vmemmap
> optimization paths for HugeTLB and DAX, leading to duplicated logic,
> complex initialization sequences, and architecture-specific flags.
>
> Implementation:
> This series breaks down the optimization into a generic framework:
> - Patch 1-6: Fix bugs related to sparse vmemmap initialization and DAX.
> - Patch 7-13: Refactor the existing sparse vmemmap initialization.
> - Patch 14-26: Decouple the vmemmap optimization from HugeTLB and
>   introduce generic optimization macros and functions.
> - Patch 27-39: Switch HugeTLB and DAX to use the generic framework.
> - Patch 40-49: Clean up the old HVO-specific code and simplify it.
>
> Benifit:
> - When CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, all struct pages
>   utilizing HVO (HugeTLB Vmemmap Optimization) skip initialization in
>   memmap_init, significantly accelerating boot times.
> - All architectures supporting HVO benefit from the optimizations
>   provided by SPARSEMEM_VMEMMAP_PREINIT without requiring
>   architecture-specific adaptations.
> - Device DAX struct page savings are further improved, saving an
>   additional 4KB of struct page memory for every 2MB huge page.
> - Vmemmap tail pages used for Device DAX shared mappings are changed
>   from read-write to read-only, enhancing system security.
> - HugeTLB and Device DAX now share a unified vmemmap optimization
>   framework, reducing long-term maintenance overhead.
>
> Testing:
> - Verification: Compiled and tested on x86 architecture.
>
>
> Chengkaitao (1):
>   mm: Convert vmemmap_p?d_populate() to static functions
>
> Muchun Song (48):
>   mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
>   mm/sparse: add a @pgmap argument to memory deactivation paths
>   mm/sparse: fix vmemmap page accounting for HVOed DAX
>   mm/sparse: add a @pgmap parameter to arch vmemmap_populate()
>   mm/sparse: fix missing architecture-specific page table sync for HVO
>     DAX
>   mm/mm_init: fix uninitialized pageblock migratetype for ZONE_DEVICE
>     compound pages
>   mm/mm_init: use pageblock_migratetype_init_range() in
>     deferred_free_pages()
>   mm: panic on memory allocation failure in sparse_init_nid()
>   mm: move subsection_map_init() into sparse_init()
>   mm: defer sparse_init() until after zone initialization
>   mm: make set_pageblock_order() static
>   mm: integrate sparse_vmemmap_init_nid_late() into sparse_init_nid()
>   mm/cma: validate hugetlb CMA range by zone at reserve time
>   mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
>   mm/hugetlb: initialize vmemmap optimization in early stage
>   mm: remove sparse_vmemmap_init_nid_late()
>   mm/mm_init: make __init_page_from_nid() static
>   mm/sparse-vmemmap: remove the VMEMMAP_POPULATE_PAGEREF flag
>   mm: rename vmemmap optimization macros to generic names
>   mm/sparse: drop power-of-2 size requirement for struct mem_section
>   mm/sparse: introduce compound page order to mem_section
>   mm/mm_init: skip initializing shared tail pages for compound pages
>   mm/sparse-vmemmap: initialize shared tail vmemmap page upon allocation
>   mm/sparse-vmemmap: support vmemmap-optimizable compound page
>     population
>   mm/hugetlb: use generic vmemmap optimization macros
>   mm: call memblocks_present() before HugeTLB initialization
>   mm/hugetlb: switch HugeTLB to use generic vmemmap optimization
>   mm: extract pfn_to_zone() helper
>   mm/sparse-vmemmap: remove unused SPARSEMEM_VMEMMAP_PREINIT feature
>   mm/hugetlb: remove HUGE_BOOTMEM_HVO flag and simplify pre-HVO logic
>   mm/sparse-vmemmap: consolidate shared tail page allocation
>   mm: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>   mm/sparse-vmemmap: switch DAX to use generic vmemmap optimization
>   mm/sparse-vmemmap: introduce section zone to struct mem_section
>   powerpc/mm: use generic vmemmap_shared_tail_page() in compound vmemmap
>   mm/sparse-vmemmap: unify DAX and HugeTLB vmemmap optimization
>   mm/sparse-vmemmap: remap the shared tail pages as read-only
>   mm/sparse-vmemmap: remove unused ptpfn argument
>   mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo() and related code
>   mm/sparse: simplify section_vmemmap_pages()
>   mm/sparse-vmemmap: introduce section_vmemmap_page_structs()
>   powerpc/mm: rely on generic vmemmap_can_optimize() to simplify code
>   mm/sparse-vmemmap: drop ARCH_WANT_OPTIMIZE_DAX_VMEMMAP and simplify
>     checks
>   mm/sparse-vmemmap: drop @pgmap parameter from vmemmap populate APIs
>   mm/sparse: replace pgmap with order and zone in sparse_add_section()
>   mm: redefine HVO as Hugepage Vmemmap Optimization
>   Documentation/mm: restructure vmemmap_dedup.rst to reflect generalized
>     HVO
>   mm: consolidate struct page power-of-2 size checks for HVO
>
>  .../admin-guide/kernel-parameters.txt         |   2 +-
>  Documentation/admin-guide/sysctl/vm.rst       |   2 +-
>  Documentation/mm/vmemmap_dedup.rst            | 218 ++--------
>  arch/powerpc/Kconfig                          |   1 -
>  arch/powerpc/include/asm/book3s/64/radix.h    |  12 -
>  arch/powerpc/mm/book3s64/radix_pgtable.c      | 114 +----
>  arch/powerpc/mm/init_64.c                     |   1 +
>  arch/riscv/Kconfig                            |   1 -
>  arch/x86/Kconfig                              |   2 -
>  fs/Kconfig                                    |   6 +-
>  include/linux/hugetlb.h                       |   7 +-
>  include/linux/memory_hotplug.h                |   2 +-
>  include/linux/mm.h                            |  50 +--
>  include/linux/mm_types.h                      |   2 +
>  include/linux/mm_types_task.h                 |   4 +
>  include/linux/mmzone.h                        | 143 ++++---
>  include/linux/page-flags.h                    |  31 +-
>  kernel/bounds.c                               |   2 +
>  mm/Kconfig                                    |  20 +-
>  mm/bootmem_info.c                             |   5 +-
>  mm/cma.c                                      |   3 +-
>  mm/hugetlb.c                                  | 143 +++----
>  mm/hugetlb_cma.c                              |   3 +-
>  mm/hugetlb_vmemmap.c                          | 237 +----------
>  mm/hugetlb_vmemmap.h                          |  35 +-
>  mm/internal.h                                 |  26 +-
>  mm/memory_hotplug.c                           |  15 +-
>  mm/mm_init.c                                  | 138 +++---
>  mm/sparse-vmemmap.c                           | 392 +++++-------------
>  mm/sparse.c                                   |  85 ++--
>  mm/util.c                                     |   2 +-
>  scripts/gdb/linux/mm.py                       |   6 +-
>  32 files changed, 513 insertions(+), 1197 deletions(-)
>
> --
> 2.20.1

Thanks very much for doing this. This cleans up a lot of stuff. I did
want to do some of this when I did the pre-HVO code, but I ended up
not doing it to prevent perfect being the enemy of good.

I haven't looked at all the individual patches yet, but overall this
looks great to me.

- Frank

