Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F378EC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 11:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF176B0092; Wed, 19 Aug 2026 07:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F666B0093; Wed, 19 Aug 2026 07:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5F96B0095; Wed, 19 Aug 2026 07:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCB06B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:30:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0607F140515
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:30:38 +0000 (UTC)
X-FDA: 85117801356.22.4261204
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF86F18000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:30:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DXE1Ay5m;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787139036;
	b=qkMJjEJjl5zIbZJMnc4zqvXwnXaNKx1BEaxYRz16pWY/gNd+VswbSyv3t/t3AoagTCueOE
	8JF2gD+wBQzcCKZaBcM4R+K6KTf3aiW+NpqQbS2LawK2DLrzcQCvm8oCwi99Jle67CQhu4
	RhQBm6CETuh77o5BYaccBxDc7/can/E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DXE1Ay5m;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787139036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIP0a02RHtgJJD2qgNYIbyr2OWA1pLpp8qK7n/TIfNc=;
	b=ygKy+7ufwu/s4P26dg8iGTEgf5qRiRHA0+ghDq+EDtU+XN70BSkRj6jHGr5sbBTXJnFa14
	0n+M+bfRWyLvh70P7f930JURbhv9h4mmFq6I8+FkOwIuxqULlf1leBUJEwW/2ioU+0I08g
	1k3AxwO+QTdpgmEPq0b4Sm+51fOuLSk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GioUN9ZNUFOOY2+qA7NRpGccjxk2FMqoVqjsSWyQoz8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787139034; v=1; x=1787743834;
 b=DXE1Ay5m1RT/7nBrQGBojVBFawQcROHxp4FIhaIp8CaZh4/McEHtilF8ugqdZmg1XwSPtRqM
 YbBysE+vRepq6BcSf/1/rBKaEuIcksqS3A8aRWGezt3FiFaWSJku2pGMBmQrh2ieX2jl2iD5IyY
 3vNjHjJoI8Yx/Tmkf4BSxG3s=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (2408:8606:1800:501::1:7)
	by mta10.migadu.com with ESMTPS id 2806ab966b61ca88;
	Wed, 19 Aug 2026 11:30:34 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 00/17] mm: Introduce section-based vmemmap optimization
 for HugeTLB
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
Date: Wed, 19 Aug 2026 19:30:15 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BDDE93CF-876C-4A65-A4F7-C717CDCE61F4@linux.dev>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: AF86F18000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pz8n5zbudri13fcwos9nprn39pgc6rh4
X-HE-Tag: 1787139035-771821
X-HE-Meta: U2FsdGVkX1+zAaTlHw2VAzGiil/gcfWZ3zbhZYr78HmFEMdJ450n+96O9CrMCoACKyCsO1TiiFme8Q4efJKYpxcco6w99vl2tlNnC4H33G4rKqKil3tPJTiFtKoQN8cAf3DQGeWRtmzPRv8LdVRzW0HH9SJ/WmxGpI2jMlLFFAPzJiI5AIfNdmqkA2/M0cD746dtEYOlpQyOf2lW7zndko0i+am8ahmjXAmEplJZniNK89oDxqHZnG7aFycZ+F3yEVV09Y1wF6RE3SSoA7Bt1gPM3HZoJof6RM6JyIlFPR+H7NK+zOFcYmqceZs3KdHRLtRbxJ/acKkiDRvngVOauSPYxadpy3mASOEURqfxBNJIbZSPdj5NGdXfdhyQWI7cp+FTa1mDCQRjh6MtRWFd/ueSHEt5tVG4nh2LIG4PKu6Z7U8lRFa+TahRbu+gF+rOCW1IDPjp+WNSiGbYLd+BA1x19eYl+XyWfuDPrCRBbo5KwY6c5x2/WFCQ4stBCQCMK95TMcXO52U55EUex7agW15B6dchIUBNyMQgZaPfcupzvpVIjCZj5waPm0qx1iCVPBKItAjBAk5aZnkKoC2KT+cPJkyM5TaWajYnXiZk8DgrrP47DAh5CKYq9Y5prj+xnFMVW5fQyhV2Muwze6CjjNI2MbB+bZBergV4PwhSnF7RqgcD34tXd4AYGI8ZEjzEkrRoN94lg832/De3fnEZgfkI9u2Erd+aTRPD6kz6Eof2z3loScqX/rTPwfLMF81ncSaX4KFT8dU9m7N3n2fIClJcFNBk7U4Rc0Voyk9IIUl6Ez16jK1Daq5AKzdLMrHvSMS2lka0s9zDEqhhOhgr06+ZojWI1K9CBZ8Zys1K1eqmfbcxGermny9fQXxxBp0Us3cPW1+jvmKxHAhrKkfjNs+F9B7Fwsw968BjJaDn5YXzMBefc6qpv/XcR2jd3zftQORgZgm1H8twKnBNTgL
 VvgMgjoi
 ss6JF8lXDQjzURcPH+WwmyWrtdYtDrb52KWVoBcdeMn6RsakqKjx4o1hSPz4GgtIJtpOclXEAB3wrSLeAm00NAwIkAEuywo9LkJBnE1N+2neFNHrgiWs1lkLqiuC8nRqoubVuK53xyK1PbE38LNNiG612W+hZhQHBqA3v2uqatRExouSAa2si0KaVZ8aw6TSNJa5wY9NRefqcY35hJyy4Zo8g6dveqgk7dQhX0bl6DSnj5T21iBwbaYVjeKT/t94FbLEdd/+A+P6abkalLpJsRj/squO9Ah97C1snFXeIaTsnYqysdWfF3e8mJ009D+9k2zthF5k2jpjxJEwlWbQ9AvzzaejSxV3yp5TN5yDGUxGW3I9zMdxlin7rppmhd6AGa7RwVrUnQGU2KRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 19, 2026, at 17:51, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> This series is split out from the earlier, larger series "mm: =
Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series =
generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset =
addresses
> a single, self-contained step: making the generic sparse-vmemmap code
> section-based optimization aware and switching HugeTLB bootmem pages =
to
> this path.
>=20
> HugeTLB vmemmap optimization currently has its own early boot setup
> path. It pre-populates optimized vmemmap mappings before the normal
> sparse-vmemmap population code runs, and sparsemem carries
> SPARSEMEM_VMEMMAP_PREINIT only to support that special case.
>=20
> That makes the HugeTLB vmemmap optimization path harder to share with
> other users of sparse-vmemmap optimization and leaves a fair amount of
> HugeTLB-specific boot-time state in the generic memory initialization
> flow.
>=20
> This series introduces section-based vmemmap optimization support in
> the sparse-vmemmap code and switches HugeTLB bootmem pages over to it.
> Instead of having HugeTLB pre-populate optimized vmemmap mappings
> itself, HugeTLB now records the compound page order in the =
corresponding
> memory sections. The generic sparse-vmemmap population path can then
> allocate or reuse shared tail vmemmap pages based on section metadata.
>=20
> The patches are organized as follows:
>=20
>  - patches 1-2 prepare sparsemem and vmemmap optimization metadata
>  - patches 3-8 teach the common sparse-vmemmap paths to use that state
>  - patches 9-10 switch HugeTLB bootmem optimization to the
>    section-based path
>  - patches 11-17 clean up sparsemem and HugeTLB bootmem code that is =
no
>    longer needed after the conversion
>=20
> This is intended to be the second smaller step toward the broader HVO
> generalization. The device DAX conversion and the wider HVO
> consolidation are left for follow-up series.

I've confirmed that all the reports from Sashiko are false positives in
this version, and they also appeared as duplicates in the previous one.

Thanks.

>=20
> v4:
> - Rename pfn_vmemmap_optimizable() to vmemmap_optimizable_pfn() for
>  consistency with vmemmap_optimizable_order().
> - Move section_nr_vmemmap_pages() outside CONFIG_MEMORY_HOTPLUG to fix
>  CONFIG_MEMORY_HOTPLUG=3Dn builds (reported by kernel test robot).
>=20
> v3:
> - Replaced the !SPARSEMEM __pfn_to_section() stub with
>  pfn_to_section_order() so callers can keep mem_section access inside
>  sparse helpers (suggested by Mike Rapoport).
> - Added vmemmap_optimizable_order() for order-based vmemmap
>  optimization checks and used it for HugeTLB bootmem decisions.
> - Fixed the pfn_to_zone() commit message to name mm/mm_init.h instead
>  of mm/internal.h.
> - Collected Acked-by tags from Mike Rapoport.
>=20
> v2:
> - Kept struct mem_section aligned after relaxing lookup constraints
>  (suggested by David Laight).
> - Folded section order tracking into the first user instead of keeping
>  a standalone API-only patch (suggested by Mike Rapoport).
> - Renamed the HVO order macros with a VMEMMAP_OPTIMIZATION prefix
>  (suggested by Mike Rapoport).
> - Moved pfn_to_zone() before the sparse-vmemmap optimization changes
>  (suggested by Mike Rapoport).
> - Kept vmemmap accounting and population logic in sparse-vmemmap.c
>  (suggested by Mike Rapoport).
> - Renamed the early sparsemem helper to sparse_sections_init()
>  (suggested by Mike Rapoport).
> - Fixed the !SPARSEMEM stub name so SPARSEMEM=3Dn builds compile
>  (reported by Sashiko).
> - Guarded section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
>  it returns 0 when HVO is disabled and lets the compiler optimize the
>  code as much as possible (suggested by Mike Rapoport).
> - Collected Acked-by tags from Mike Rapoport.
>=20
> [1] =
https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedan=
ce.com/
>=20
> Muchun Song (17):
>  mm/sparse: relax struct mem_section size constraints
>  mm/sparse-vmemmap: rename HVO order macros
>  mm/mm_init: skip initializing shared vmemmap tail pages
>  mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
>  mm/sparse-vmemmap: support section-based vmemmap accounting
>  mm/mm_init: factor out pfn_to_zone()
>  mm/sparse-vmemmap: move vmemmap_get_tail() before PTE population
>  mm/sparse-vmemmap: support section-based vmemmap optimization
>  mm/sparse: initialize memory sections earlier
>  mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
>  mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
>  mm/sparse: inline usemap allocation into sparse_init_nid()
>  mm/sparse: remove section_map_size()
>  mm/hugetlb: remove HUGE_BOOTMEM_HVO
>  mm/hugetlb: remove HUGE_BOOTMEM_CMA
>  mm/hugetlb: localize struct huge_bootmem_page
>  mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
>=20
> arch/x86/Kconfig        |   1 -
> fs/Kconfig              |   1 -
> include/linux/hugetlb.h |   5 -
> include/linux/mm.h      |   4 -
> include/linux/mmzone.h  |  66 ++++--------
> mm/Kconfig              |   5 -
> mm/hugetlb.c            |  64 ++++--------
> mm/hugetlb_vmemmap.c    | 103 +------------------
> mm/hugetlb_vmemmap.h    |  13 +--
> mm/internal.h           |   7 --
> mm/mm_init.c            |  63 +++++++-----
> mm/mm_init.h            |   1 +
> mm/sparse-vmemmap.c     | 216 ++++++++++++++++++----------------------
> mm/sparse.c             |  94 ++++-------------
> mm/sparse.h             |  85 ++++++++++++++++
> scripts/gdb/linux/mm.py |   6 +-
> 16 files changed, 285 insertions(+), 449 deletions(-)
>=20
>=20
> base-commit: 5453bc3279e9f8578ac3e534d476240e40c879e1
> --=20
> 2.54.0
>=20


