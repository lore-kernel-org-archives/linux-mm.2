Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A490FF41986
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D546B00A7; Wed, 15 Apr 2026 07:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154886B00A8; Wed, 15 Apr 2026 07:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A406B00A9; Wed, 15 Apr 2026 07:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9E9B6B00A7
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:22:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A10478B880
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:22:57 +0000 (UTC)
X-FDA: 84660553194.07.D1F9844
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91E41C000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:22:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RaGcxQDS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776252176; a=rsa-sha256;
	cv=none;
	b=fv/Qono8hPDM9xKacHhdTk+Y3Kzup5bEFcfxB8S1lUWYrg23ranWvhTR0whoSBwO/+hOOP
	DsIABlRB1+Nn6ylr5CDdUsbK2GyK1KsvzpCYKo/qSX6sXeKbcQNZ2jCGNcWF9/5GN8AXQB
	lWHIi8F2zjjktrRFNwDXYeIC3TD3rAQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RaGcxQDS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776252176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqCAsAgI0t6/akrOnA6+jyaIV6f8Vm9SfhfdX5V+FDk=;
	b=ZIJhzlFlR1Qpnkzw8ZqVQ/Bykerae/hiEUGD6JwyZ/icg948Bp5ITGw7pAk/WW3t6VIZTQ
	Y2bvg9q8K3D0Rz07TcTmktY4o9NltRNQA9RI6Yrz9LeUs+X/1owRt7YdMI2ei6IqihNH7N
	SAvBhTweBmdIaxMdnwHFstyKYxMr/3c=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776252173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QqCAsAgI0t6/akrOnA6+jyaIV6f8Vm9SfhfdX5V+FDk=;
	b=RaGcxQDSopj/bba3OgaNovmtsXkk6rePZxmzVbt3nTmIjJUQYozcPGze7Jb32nSgW5f06a
	wZtmqQYFIqXBBvJM91lDyIxSSjFLlHCqf/6G3zPINXJOyYOA6Vsoujg5XI7HuYoQXiaMpw
	gS7OsiK8i7Xsyp/6flz0+QI42Sndqdk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 00/49] mm: Generalize vmemmap optimization for DAX and
 HugeTLB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
Date: Wed, 15 Apr 2026 19:22:02 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
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
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D9685A9A-9791-4E34-B01B-F9F5F3B28B5D@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91E41C000B
X-Stat-Signature: crc7ed88ngxbqu5ic7ohhiiijsbacdba
X-HE-Tag: 1776252175-584992
X-HE-Meta: U2FsdGVkX19pUXwhE1YCw8iIzq4d4V+BFtEyOmY6DvQbgwnjBuel9hNxNHvzPZZFzx3jb2zKxEUvoRyaj0CrcpEmq4hRp0CaeT9B1/InYki+diTvgr0c5XyDF6UdC2/GFN4nlBOPDEIg7GyyhUn8+EqTnhRQT1oE7Nx2YSCgJfzTXg17JSOTQhZsEpWO7fXlf3vhY9p0Gcxi7Mjk0teuWI6FqqU7qWSO0/cfS7Jsw1hhQv66mm0LJr6YvCB3fr+MO4FaqEVEYAmu2nxLCcIzYYaxwnfCwDHKgtnFwAUhQX9ESiwj4b2vbFhEg1cmBp2si45nn1Tz48nmRGjKr+SwQs2AHjdJYmjNjK0gtbTJbwrTAU/S1X9kR0rh2794vBParEA2Lzz+Wv/s+2wJNOOp9JZw+xZho0LXIhaxkjkTp+qBYVYIVY+R+/QSywwLOvk5A3DpFk4M58D3SucfVbLZyEsWCgQuWL4asK9lJtvDaPzhZsENSjex6YTcbByHMPnbVaVU1K9WD68HrkXhqnrLi+qgiMPh8OAIhd7uD4E+4JIPYXl0wGUtyKHMdkyrasIFp9djfw76ksiogMLYrOq1Vn62P0CJFgqBdTUpiEexqxy2LXKUw8c2zD+x0l4E/nUvpSKkJ7pukbGwfRMTyRVogxkoj7GlAoNN8YYAkXXfigOvQAzKqTH1uZKwT3mwn8w/UjR8YoQrxu5zAQiah4fw+3qoxbCr4Q3N6DqFA3iywAwcIdbvj+nsR6cnk3a9WXWKqRLLjbzP4OyBWeiweOhfTKMt5lA+EYUmoeGdeBiHjSvfoArFrcDjMNB1fT4wxG3P4s1j1CfZFe/F3Dm1RwaYJZ1DGSz3aXgKVPTcZiWFK++uREydCCGzbbxmjiWXAWN4iiWpUQISxMnkQX2W8KRoef5N3dFvozHyeGpdd3nBirSdArEyFoOgatLw1N7HRRgMRf0SA5aO+fG+PxxnFMH
 LITJDA4N
 urny25uhu50VGKToLX9pcx93XeFUQ5kOXvV1nx0Ku20RLzcCA01LcDuXShcU1sUImNkdIRAIN2T9uw6a+YrnKEgQCJfASJuydi43Yc3c4KymePUzjxD7wpr/ZoWkjeGx1U7a0NN07O9RVfghHmHGpenqTrY/nl/99xEiNMYwT+XhImMAxm5d+qlsG7U52zDnkyQTeqgBrk4rw8/XpC2k1CrGq4DQoUfsGjeLg5GwV/wWaJUatjDeDHyez61aETJWVzdq0NZcBSWpvgxKTavlCK68DEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 5, 2026, at 20:51, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> Overview:
> This patch series generalizes the HugeTLB Vmemmap Optimization (HVO)
> into a generic vmemmap optimization framework that can be used by both
> HugeTLB and DAX.
>=20
> Background:
> Currently, the vmemmap optimization feature is highly coupled with
> HugeTLB. However, DAX also has similar requirements for optimizing =
vmemmap
> pages to save memory. The current implementation has separate vmemmap
> optimization paths for HugeTLB and DAX, leading to duplicated logic,
> complex initialization sequences, and architecture-specific flags.
>=20
> Implementation:
> This series breaks down the optimization into a generic framework:
> - Patch 1-6: Fix bugs related to sparse vmemmap initialization and =
DAX.
> - Patch 7-13: Refactor the existing sparse vmemmap initialization.
> - Patch 14-26: Decouple the vmemmap optimization from HugeTLB and
>  introduce generic optimization macros and functions.
> - Patch 27-39: Switch HugeTLB and DAX to use the generic framework.
> - Patch 40-49: Clean up the old HVO-specific code and simplify it.
>=20
> Benifit:
> - When CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, all struct pages
>  utilizing HVO (HugeTLB Vmemmap Optimization) skip initialization in
>  memmap_init, significantly accelerating boot times.
> - All architectures supporting HVO benefit from the optimizations=20
>  provided by SPARSEMEM_VMEMMAP_PREINIT without requiring=20
>  architecture-specific adaptations.
> - Device DAX struct page savings are further improved, saving an=20
>  additional 4KB of struct page memory for every 2MB huge page.
> - Vmemmap tail pages used for Device DAX shared mappings are changed=20=

>  from read-write to read-only, enhancing system security.
> - HugeTLB and Device DAX now share a unified vmemmap optimization=20
>  framework, reducing long-term maintenance overhead.
>=20
> Testing:
> - Verification: Compiled and tested on x86 architecture.

Hi all,

I have factored out all the bug fixes from this patchset into a new,
dedicated series:

=
https://lore.kernel.org/linux-mm/20260415111412.1003526-1-songmuchun@byted=
ance.com/T/#t

Once those fixes are merged, I will follow up with v2 of this series.
Thanks for your patience and feedback!

Thanks,
Muchun

>=20
>=20
> Chengkaitao (1):
>  mm: Convert vmemmap_p?d_populate() to static functions
>=20
> Muchun Song (48):
>  mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
>  mm/sparse: add a @pgmap argument to memory deactivation paths
>  mm/sparse: fix vmemmap page accounting for HVOed DAX
>  mm/sparse: add a @pgmap parameter to arch vmemmap_populate()
>  mm/sparse: fix missing architecture-specific page table sync for HVO
>    DAX
>  mm/mm_init: fix uninitialized pageblock migratetype for ZONE_DEVICE
>    compound pages
>  mm/mm_init: use pageblock_migratetype_init_range() in
>    deferred_free_pages()
>  mm: panic on memory allocation failure in sparse_init_nid()
>  mm: move subsection_map_init() into sparse_init()
>  mm: defer sparse_init() until after zone initialization
>  mm: make set_pageblock_order() static
>  mm: integrate sparse_vmemmap_init_nid_late() into sparse_init_nid()
>  mm/cma: validate hugetlb CMA range by zone at reserve time
>  mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
>  mm/hugetlb: initialize vmemmap optimization in early stage
>  mm: remove sparse_vmemmap_init_nid_late()
>  mm/mm_init: make __init_page_from_nid() static
>  mm/sparse-vmemmap: remove the VMEMMAP_POPULATE_PAGEREF flag
>  mm: rename vmemmap optimization macros to generic names
>  mm/sparse: drop power-of-2 size requirement for struct mem_section
>  mm/sparse: introduce compound page order to mem_section
>  mm/mm_init: skip initializing shared tail pages for compound pages
>  mm/sparse-vmemmap: initialize shared tail vmemmap page upon =
allocation
>  mm/sparse-vmemmap: support vmemmap-optimizable compound page
>    population
>  mm/hugetlb: use generic vmemmap optimization macros
>  mm: call memblocks_present() before HugeTLB initialization
>  mm/hugetlb: switch HugeTLB to use generic vmemmap optimization
>  mm: extract pfn_to_zone() helper
>  mm/sparse-vmemmap: remove unused SPARSEMEM_VMEMMAP_PREINIT feature
>  mm/hugetlb: remove HUGE_BOOTMEM_HVO flag and simplify pre-HVO logic
>  mm/sparse-vmemmap: consolidate shared tail page allocation
>  mm: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>  mm/sparse-vmemmap: switch DAX to use generic vmemmap optimization
>  mm/sparse-vmemmap: introduce section zone to struct mem_section
>  powerpc/mm: use generic vmemmap_shared_tail_page() in compound =
vmemmap
>  mm/sparse-vmemmap: unify DAX and HugeTLB vmemmap optimization
>  mm/sparse-vmemmap: remap the shared tail pages as read-only
>  mm/sparse-vmemmap: remove unused ptpfn argument
>  mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo() and related code
>  mm/sparse: simplify section_vmemmap_pages()
>  mm/sparse-vmemmap: introduce section_vmemmap_page_structs()
>  powerpc/mm: rely on generic vmemmap_can_optimize() to simplify code
>  mm/sparse-vmemmap: drop ARCH_WANT_OPTIMIZE_DAX_VMEMMAP and simplify
>    checks
>  mm/sparse-vmemmap: drop @pgmap parameter from vmemmap populate APIs
>  mm/sparse: replace pgmap with order and zone in sparse_add_section()
>  mm: redefine HVO as Hugepage Vmemmap Optimization
>  Documentation/mm: restructure vmemmap_dedup.rst to reflect =
generalized
>    HVO
>  mm: consolidate struct page power-of-2 size checks for HVO
>=20
> .../admin-guide/kernel-parameters.txt         |   2 +-
> Documentation/admin-guide/sysctl/vm.rst       |   2 +-
> Documentation/mm/vmemmap_dedup.rst            | 218 ++--------
> arch/powerpc/Kconfig                          |   1 -
> arch/powerpc/include/asm/book3s/64/radix.h    |  12 -
> arch/powerpc/mm/book3s64/radix_pgtable.c      | 114 +----
> arch/powerpc/mm/init_64.c                     |   1 +
> arch/riscv/Kconfig                            |   1 -
> arch/x86/Kconfig                              |   2 -
> fs/Kconfig                                    |   6 +-
> include/linux/hugetlb.h                       |   7 +-
> include/linux/memory_hotplug.h                |   2 +-
> include/linux/mm.h                            |  50 +--
> include/linux/mm_types.h                      |   2 +
> include/linux/mm_types_task.h                 |   4 +
> include/linux/mmzone.h                        | 143 ++++---
> include/linux/page-flags.h                    |  31 +-
> kernel/bounds.c                               |   2 +
> mm/Kconfig                                    |  20 +-
> mm/bootmem_info.c                             |   5 +-
> mm/cma.c                                      |   3 +-
> mm/hugetlb.c                                  | 143 +++----
> mm/hugetlb_cma.c                              |   3 +-
> mm/hugetlb_vmemmap.c                          | 237 +----------
> mm/hugetlb_vmemmap.h                          |  35 +-
> mm/internal.h                                 |  26 +-
> mm/memory_hotplug.c                           |  15 +-
> mm/mm_init.c                                  | 138 +++---
> mm/sparse-vmemmap.c                           | 392 +++++-------------
> mm/sparse.c                                   |  85 ++--
> mm/util.c                                     |   2 +-
> scripts/gdb/linux/mm.py                       |   6 +-
> 32 files changed, 513 insertions(+), 1197 deletions(-)
>=20
> --=20
> 2.20.1
>=20


