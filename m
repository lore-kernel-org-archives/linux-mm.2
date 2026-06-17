Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B1FCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C98D6B008A; Wed, 17 Jun 2026 02:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A7E6B008C; Wed, 17 Jun 2026 02:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869586B0092; Wed, 17 Jun 2026 02:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 592B46B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:56:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C257740397
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:56:16 +0000 (UTC)
X-FDA: 84888495552.19.AEEBE00
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9203C0002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:56:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ttcAU0uv;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781679375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pd8gbWlNCzyQkqrU5ZHSLBlgsjsUTsM3D0rkfq8QUW0=;
	b=NnB3gc5PRslRQ5HiOO4Z0KE/RdWiOKrznnT7NkzZKow99OmXpBUfDoNR9vZevq2xFL0R5+
	wrnyKktViK8oKLhtp8kRndccomMCnAhIiWLKI+FGy3F9lRa1pIxFiXgWzkFOhig7vGtc3b
	EHyRfYWtGPhkpszHlcRTSf7yHwQLFVw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ttcAU0uv;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781679375;
	b=Ka2Ps/fGIl8ssDOp0bqMQoy9gZh3/OaEIF7y9N9gSyxWF8SfG57D168+V7NAicZtRogo6d
	0Xa4arPQ9d030u+Bx7G9U1Eb1LAJ5pUUdmNAFmrz2t+QiOI6vxdGHkB3W8qLl+bTUBZCys
	ngVKkKNq63AkeZnxcqP9GiGecsojsJA=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781679372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pd8gbWlNCzyQkqrU5ZHSLBlgsjsUTsM3D0rkfq8QUW0=;
	b=ttcAU0uv6c4ydMwv2tlS3Wzs4bC6X98JE1iuB1K3Xm0VC+m/C51NpfOzx5cdFQzkyMK+vp
	YRs/Mhod1qpU9xD9YJL4sDSKUoMdQz4FqoMOwK397a4Fy+3cVA52NT6LDbcvy25HoPukjR
	7w3/v5h8h9a09AS9H3WcWW1T1bs3iCw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 00/19] mm: Refactor bootmem gigantic hugepage
 allocation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
Date: Wed, 17 Jun 2026 14:54:39 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Muchun Song <songmuchun@bytedance.com>,
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
 linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1213AB34-BDA3-4EB0-A2D1-83A4744C710F@linux.dev>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9203C0002
X-Stat-Signature: q8z1w1nn3xdcw5xko3bapf19fs8tutah
X-Rspam-User: 
X-HE-Tag: 1781679374-583818
X-HE-Meta: U2FsdGVkX19CtbOV0XP5iwrMGNGTENJhHYESLHd3AlHuygkvfaV9C6Sxo5LfI8g5pEiWMU8PMH5Uu0Bvp/JTt0II2edn5OboojvkZbwV4LZIL2WrKsIw6GZioE84Ez+/883pt0U1VHXimOGSeKip/BFmh/l4r3pT7dzdKEv0QeO8ft4pkgJsU1duR47LoVzjyvjNz45aII5jQZ3PBuI/skgq6bRIZuRlTaiyCb30llhoDdJ43sOqqeCgZxL7VR/IxLYshgH4S+ARBB+1RQQy0WsGVndWguohGBK+9FoAbWhH0bHB471NxByYWB57c9SZEbpxZdEDVH7rDyf+4XrQtdce52XBuz0oJR3QsVP72ZSXF9q/l5r+vmvnM1leHolXuf0zaaHcIsp+jaohay6a5KUl9D5pIzn3pMoPqqlmhpn/ihVKu/BYfaTg5wrh5OSzrM7u4AfoCefkpBjX1KBuQaouYb3b2ueOoF1TYbcGKmkFhivdhK12lE+MX22e3kVbmkdwDRrVDiFYbNHeFpXlFk5NjCMBAxYmLC4A/2Z3FLKkoeiIRRYN64nIkvZo3sjBahzjIw3SQF//AxLU4VGKzPK50tVSRmmRLip1okts+YaPAOr2FdEXhUAPjDtKuF775M7ZXlrGFIS+xsoc8D7LMBFaO0hd4itHL1dtuyTX4vtdHq6uokHFgep1wG62XO8N7/cNle02BHkE3FXFXmfj/FGNohuze33QlIkXH7+wurGxLqp/Z40DyV5d9hj0h6fWYEOz5SOgfpi59BqxslxfDDdrXaPzloLotmSgZwSENQKQWE0CU76CyD189XhJmtKZO3KKdnBdJsk+5+W0azevQduvRLOGNox+UJ5b3z5bwv7FuQJdh1wYtvG6JfPdUlW1juoCft0yw8uQesAF9GlF3bIaOKobPM+/iuz0FRN3o2P4UWb4p9KUF7Z/NZATFryV8aVPLa4ot3ztQ03Zd4F
 rtb0ywZy
 wAQ9aEeUKyIYHE13WYNhh5HFpv/jEa6of3fH1OjDr3YKEJJ9ZH/Sv6ArvArD2qbrZaA8mw1zW9vmXxsgfFTLUi262mD8sCXkz5OUCeZcbAtYYau+YUO0loVB+PwZQ0c6yr0ibqGH0njToK2bCntS0LfQJvOfUTrQ4KtXeZtLpRyunetz04AMSOMUa3f2UX7S4OKQwnsdqmjkY0ztqz7VrXzSb4QLVy5CPeFmIhmmF22yk/oPTKiHgZ171nY9xzs91hyPB4CdZYIgUavNmtaGT3IW43mjXMcZJNXVCXuuXVF40GwJ4wVOVujpJCa9iuJeEIVbZKdvw3gvuigXM8DQHJjQcx5RLWrJfimGszInNx9QNyNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 12, 2026, at 11:58, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> This series is split out from the earlier larger series "mm: =
Generalize
> HVO for HugeTLB and device DAX" [1]. It collects the first 19 patches =
of
> that series as a standalone set of fixes and preparatory cleanups =
around
> bootmem HugeTLB handling, sparse initialization ordering, and related
> vmemmap setup.
>=20
> The first patches fix a few bugs found while reviewing the existing
> code, including incorrect bootmem HVO handling, wrong vmemmap
> registration arguments, a powerpc compound-vmemmap tracking bug, and
> too-late initialization of gigantic bootmem HugeTLB struct pages.
>=20
> The rest of the series reorders early memory initialization so the
> relevant zone state is available before sparse and HugeTLB boot-time
> setup runs, then simplifies the remaining bootmem gigantic hugepage
> allocation path and removes code made obsolete by that rework.
>=20
> At a high level:
>  - patches [1-4] fix boot-time and arch-specific bugs
>  - patches [5-12] reorder and simplify sparse/mm/hugetlb early init
>  - patches [13-19] refactor bootmem gigantic hugepage allocation and
>    remove obsolete helpers and state
>=20
> Changes since v3:
>  - patches 2-4: add Cc: stable@vger.kernel.org to the applicable fixes
>  - patch 3: collect Reviewed-by from Ritesh Harjani
>  - patch 15: move pfn_to_zone() before hugetlb_vmemmap_init_early()
>    instead of using a forward declaration
>  - patches 15-17: collect Acked-by from Mike Rapoport where applicable
>  - patch 15: collect Acked-by from Usama Arif
>  - patch 18: clarify that the changelog also covers the early CMA
>    bootmem allocation fallback refactoring
>  - patch 19: initialize pgdat at declaration in
>    __init_deferred_page() and collect Reviewed-by from Mike Rapoport
>=20
> [1] =
https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedan=
ce.com/

Hi Andrew,

Would you mind picking these up for the mm-unstable branch? Almost all
patches have received a Reviewed-by or Acked-by.

Regarding the Sashiko review comments, it reported 5 issues in total, =
and
I've verified all of them:

- Patches 7 & 11: These are pre-existing issues and not introduced by =
this
  series.
- Patch 14: This is a false positive.
- Patches 8 & 9: These are valid observations but not a practical issue. =
The
  report mentioned:

	"moving these reservations after free_area_init() artificially =
inflate
	 nr_kernel_pages and nr_all_pages, potentially causing an early =
boot OOM"

However, this aligns the 1GB HugeTLB allocation behavior with the =
existing
2MB HugeTLB allocation, which already behaves this way. So it won't =
introduce
new risks.

Thanks for your time!

Best regards,
Muchun

>=20
> Muchun Song (19):
>  mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
>  mm/hugetlb_vmemmap: Fix __hugetlb_vmemmap_optimize_folios()
>  powerpc/mm: Fix wrong addr_pfn tracking in compound vmemmap =
population
>  mm/hugetlb: Initialize gigantic bootmem hugepage struct pages earlier
>  mm/mm_init: Simplify deferred_free_pages() migratetype init
>  mm/sparse: Panic on memmap and usemap allocation failure
>  mm/sparse: Move subsection_map_init() into sparse_init()
>  mm/mm_init: Defer sparse_init() until after zone initialization
>  mm/mm_init: Defer hugetlb reservation until after zone initialization
>  mm/mm_init: Remove set_pageblock_order() call from sparse_init()
>  mm/sparse: Move sparse_vmemmap_init_nid_late() into sparse_init_nid()
>  mm/hugetlb_cma: Validate hugetlb CMA range by zone at reserve time
>  mm/hugetlb: Refactor early boot gigantic hugepage allocation
>  mm/hugetlb: Free cross-zone bootmem gigantic pages after allocation
>  mm/hugetlb_vmemmap: Move bootmem HVO setup to early init
>  mm/hugetlb: Remove obsolete bootmem cross-zone checks
>  mm/sparse-vmemmap: Remove sparse_vmemmap_init_nid_late()
>  mm/hugetlb: Remove unused bootmem cma field
>  mm/mm_init: Fold __init_page_from_nid() into __init_deferred_page()
>=20
> arch/powerpc/mm/book3s64/radix_pgtable.c |   7 +-
> arch/powerpc/mm/hugetlbpage.c            |  13 +-
> include/linux/hugetlb.h                  |  24 +--
> include/linux/mmzone.h                   |   7 -
> mm/cma.c                                 |   3 +-
> mm/hugetlb.c                             | 259 +++++++++++------------
> mm/hugetlb_cma.c                         |  44 ++--
> mm/hugetlb_cma.h                         |   8 +-
> mm/hugetlb_vmemmap.c                     | 120 +++--------
> mm/hugetlb_vmemmap.h                     |   5 -
> mm/internal.h                            |  14 +-
> mm/mm_init.c                             |  86 +++-----
> mm/sparse-vmemmap.c                      |  26 ++-
> mm/sparse.c                              |  48 +----
> 14 files changed, 251 insertions(+), 413 deletions(-)
>=20
>=20
> base-commit: ec039126b7fac4e3af35ebccaa7c6f9b6875ba81
> --=20
> 2.54.0


