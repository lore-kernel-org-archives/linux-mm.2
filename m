Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308EED711C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 22:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B1A6B0089; Thu, 18 Dec 2025 17:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615176B008A; Thu, 18 Dec 2025 17:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537E86B008C; Thu, 18 Dec 2025 17:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42EE26B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:18:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B1BD8A2AC
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:18:22 +0000 (UTC)
X-FDA: 84234006444.11.C465A6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 01B5820010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:18:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eyJgYb7t;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766096300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vgLwUfZVR9RpRlYwnSQcIol4g2gjiobtIuSTXa6byI=;
	b=dDYBt1bntYprkJULBsLIO+74wi7OkZUAVfPqEDtYY5CRFUWNgmVhog3CX/Ep0Pv9dL2ptI
	S73xfC5mDbHWTnsGOFxgrOmcdTLQB0RoCXUChKeLxfQ0KMo27nqQ9PKmuTJDDgm09rfyEs
	QXHmoe5WYJPB0cRvq+1p+04hffXAM1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eyJgYb7t;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766096300; a=rsa-sha256;
	cv=none;
	b=1P4bC3RiesFF+C9OMoXQ4gHPP9HgCAlR6C1BBlaweT2evooCNXkzgZu4Ogofdgt6B0bZzA
	QlK8X3PynVnnkg7RaKNduH7Lli2ys39ypq7C5aD4jBbm4QeRiombR8wemYIFBfTgZ1XHOi
	DRxzU11Ak9oUT6mP/feJ1H2JBdAIf/Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D46A942E57;
	Thu, 18 Dec 2025 22:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26839C16AAE;
	Thu, 18 Dec 2025 22:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766096298;
	bh=FUgCeuiQNT4muIFBCmCzgaZfGQk40jmJWu4fIl3oYKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyJgYb7tg2MAyuKG6rI5UMjAdV3cDZNb9nU9LITotkmynISVw6eD/yPFDWZREz9vc
	 TF5DAwkRgvFQ1eSeGM0OJlP267Ahm3WbPM5LZqb/VJTwAWDija/3HEJo0MNstuc2Hv
	 93WEJWYFsihbwo2Jg9oO00IaoMXWYnvi+2d/cNO1EZoO7XIDKlivVDslLTuA/VIrU+
	 47Ol2bd48vSkaueLGIx5kINEJeQCQWLQAl1Z06FkxnhI5WYnlx24e15q8/CFlwqZEd
	 wur4hOBdx9Fhqig5THqzTZxSPHPhOKAJN8aIVd1dzd1O4v9vrafv2uRmIsjZh+AEE/
	 uJQuF/nCCR/sg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 601C4F4006D;
	Thu, 18 Dec 2025 17:18:17 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 18 Dec 2025 17:18:17 -0500
X-ME-Sender: <xms:qX1EaTz7izvLcduUg_22qEkWYwvSQKkS767iaRTZ_AefNM1zIW1abg>
    <xme:qX1EadXmUu5mhezqQPZMguY3coq1_DaOHq-wdNtsbhpc-eNBt7z57l4ImB35k5FA1
    B6kJmWEBuRceL_ji1nbuYKFiprIEyvCfWUJ_o1h5u1ocs1ERnZxQuaI>
X-ME-Received: <xmr:qX1EaXbuduq-XfSLSednr-WC547i5NufmCeS_MoAIo49zTXUpG2lue4BuCD6jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegieeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:qX1EaYN3Ut09ZxqGoJd7XQHjVn2v9-CjaYEQ55sURW6WMfKIdR6ZpA>
    <xmx:qX1Eabu-pbi6_iJ7-E9PpWEBG9kBksqjrInQovTtek8uqPM3mX308A>
    <xmx:qX1Eae0BdE73PogicHJtHPSjs76zOCGfcACPYnH36G71iX6ew8GONQ>
    <xmx:qX1EaZUaAMF0a6DbR9gUnSeEsKM4zxuVtybMoEg2ta2gSDDVer78vg>
    <xmx:qX1EaUuSs4NqwYdss3vvgbRdATZV5nf85GISJc6bdTGWXiwjUZHWfAHV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 17:18:16 -0500 (EST)
Date: Thu, 18 Dec 2025 22:18:15 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 00/14] Eliminate fake head pages from vmemmap
 optimization
Message-ID: <pr22ew7pmqercu5tlabw2ros4cdeoyhlqbqmogvfqgekesfbfz@f5nls3gxj76t>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
X-Rspamd-Server: rspam02
X-Stat-Signature: ypnb6u4jzxuz87kk5xh1ngkmahh1je1h
X-Rspam-User: 
X-Rspamd-Queue-Id: 01B5820010
X-HE-Tag: 1766096299-694767
X-HE-Meta: U2FsdGVkX18URpJ22yyfqwsD8zEAFyZqszFmey+Rb2Cb2q404JWZk9GRKc/IF9MXLxkATyY0CMY0LrQkAgbW757WzwVOgKVMboolJp47kz3WMWM7asqVnfnC6iv8hCLC9qsWlWAA/Fzw37IX6QenxJzplsLdyWzagT+AHtpAO8Bpg2bslQyknMpVEJ+8IzoRVw1fcRKYhcrb1/+F42A5iEu/ybiaj0jVhFMV59jOd6+mWREhvHtBKNCr4MLDmN1aIWWbEzqv55SJHOnU/oADetoSHwT8ZzrhER13G9fiBiOLF6d8HBEAJq7LHYpTa1KIe+NsPWBnsKIltrzj63IB5WHc2deh29Nz4zK8ETYYTepJvLdqYkz9RRKvNz/numNlUO/H5SiaQnuWfbx27r49wgUqF5oVwb793x6tjwjrl7nGsVsM2cV/ik6YyeoA3/p5bAyyZakoIETtiJxItNN60P03FGqjDw9do6C7GumLg05spSjlXldRWkX+x0RzQlP0jHKBjjkhEehetDSdlgD6hT78l0W5sVMuALADXiJlFidMOovkBJDMeqVDAjeYeaYxBQqC2PF7hUha4W0r2lWhSgUVrk1/tw3cgnHpwnkPOrXT+SaYfkPW+/79LcjMa37SeXhm/DwJiqiqcQlL0FnIsAhO2oeb0KKRDbBrlXDPGGhdtLxH7dNF5zA/UiNxHCfjtScRl5v9SsfmO5T5PDGdMsB3T+K/HNx8MhfaidjHRxNUOvVjuw7JGaVblfInwnTzufvIvLngC1805MaAKS91IPZcFAJA4Milc7Gg/ciKY3muh/hpc+HnU9Sj0Fnwqr1guYvWZy13vQxZeXJxB39+DnH1Oo3FFGw1kBvrmmMVpg8+ElUzy7uG7w5nIbou1FzqeLUD1wUlX4MO3RFJpVRpcgKwV7a5e6+5IqepuJaSqI5ww+7k8TmJctHrsrHofBbkCap7I8wkP7P01A6ppdT
 9bRtxkQj
 dMtP3YrG4t0sFaiJc2crKLi1J0P3wj/eWkt1+u2vYQsyRz/6lpIhjameCHfi/eCFRnR7f2N74mr7+7AKk1vb33MzGq0Aq+3mU8/u8lFfkNPQBDrZszveMQsZIJrCXHy8uVZvjJTvr7OZ9qRm0nNrT1IoXQ0yuiz8qBNDq60qcYrwEf4GtfT8WMXq2kpfRLLEyj1bB7rWC74z8rOuZTu/PrlkcYlGCiYvvKvOBp+02QF5eVXkVY7jRpAu1io7C1UdEx+oCkT1K+CxgD0jwf52nKy7Z3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Oopsie. Add the Subject.

On Thu, Dec 18, 2025 at 03:09:31PM +0000, Kiryl Shutsemau wrote:
> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
> 
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.
> 
> Background
> ==========
> 
> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> and remapping the freed virtual addresses to a single physical page.
> Previously, all tail page vmemmap entries were remapped to the first
> vmemmap page (containing the head struct page), creating "fake heads" -
> tail pages that appear to have PG_head set when accessed through the
> deduplicated vmemmap.
> 
> This required special handling in compound_head() to detect and work
> around fake heads, adding complexity and overhead to a very hot path.
> 
> New Approach
> ============
> 
> For architectures/configs where sizeof(struct page) is a power of 2 (the
> common case), this series changes how position of the head page is encoded
> in the tail pages.
> 
> Instead of storing a pointer to the head page, the ->compound_info
> (renamed from ->compound_head) now stores a mask.
> 
> The mask can be applied to any tail page's virtual address to compute
> the head page address. Critically, all tail pages of the same order now
> have identical compound_info values, regardless of which compound page
> they belong to.
> 
> The key insight is that all tail pages of the same order now have
> identical compound_info values, regardless of which compound page they
> belong to. This allows a single page of tail struct pages to be shared
> across all huge pages of the same order on a NUMA node.
> 
> Benefits
> ========
> 
> 1. Simplified compound_head(): No fake head detection needed, can be
>    implemented in a branchless manner.
> 
> 2. Simplified page_ref_add_unless(): RCU protection removed since there's
>    no race with fake head remapping.
> 
> 3. Cleaner architecture: The shared tail pages are truly read-only and
>    contain valid tail page metadata.
> 
> If sizeof(struct page) is not power-of-2, there are no functional changes.
> HVO is not supported in this configuration.
> 
> I had hoped to see performance improvement, but my testing thus far has
> shown either no change or only a slight improvement within the noise.
> 
> Series Organization
> ===================
> 
> Patches 1-2: Preparation - move MAX_FOLIO_ORDER, add alignment check
> Patches 3-5: Refactoring - interface changes, field rename, code movement
> Patch 6: Core change - new mask-based compound_head() encoding
> Patch 7: Correctness fix - page_zonenum() must use head page
> Patch 8: Refactor vmemmap_walk for new design
> Patch 9: Eliminate fake heads with shared tail pages
> Patches 10-13: Cleanup - remove fake head infrastructure
> Patch 14: Documentation update
> 
> Changes in v2:
> ==============
> 
> - Handle boot-allocated huge pages correctly. (Frank)
> 
> - Changed from per-hstate vmemmap_tail to per-node vmemmap_tails[] array
>   in pglist_data. (Muchun)
> 
> - Added spin_lock(&hugetlb_lock) protection in vmemmap_get_tail() to fix
>   a race condition where two threads could both allocate tail pages.
>   The losing thread now properly frees its allocated page. (Usama)
> 
> - Add warning if memmap is not aligned to MAX_FOLIO_SIZE, which is
>   required for the mask approach. (Muchun)
> 
> - Make page_zonenum() use head page - correctness fix since shared
>   tail pages cannot have valid zone information. (Muchun)
> 
> - Added 'const' qualifier to head parameter in set_compound_head() and
>   prep_compound_tail(). (Usama)
> 
> - Updated commit messages.
> 
> Kiryl Shutsemau (14):
>   mm: Move MAX_FOLIO_ORDER definition to mmzone.h
>   mm/sparse: Check memmap alignment
>   mm: Change the interface of prep_compound_tail()
>   mm: Rename the 'compound_head' field in the 'struct page' to
>     'compound_info'
>   mm: Move set/clear_compound_head() next to compound_head()
>   mm: Rework compound_head() for power-of-2 sizeof(struct page)
>   mm: Make page_zonenum() use head page
>   mm/hugetlb: Refactor code around vmemmap_walk
>   mm/hugetlb: Remove fake head pages
>   mm: Drop fake head checks
>   hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
>   mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
>   mm: Remove the branch from compound_head()
>   hugetlb: Update vmemmap_dedup.rst
> 
>  .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
>  Documentation/mm/vmemmap_dedup.rst            |  62 ++--
>  include/linux/mm.h                            |  31 --
>  include/linux/mm_types.h                      |  20 +-
>  include/linux/mmzone.h                        |  47 +++
>  include/linux/page-flags.h                    | 163 ++++-------
>  include/linux/page_ref.h                      |   8 +-
>  include/linux/types.h                         |   2 +-
>  kernel/vmcore_info.c                          |   2 +-
>  mm/hugetlb.c                                  |   8 +-
>  mm/hugetlb_vmemmap.c                          | 270 +++++++++---------
>  mm/internal.h                                 |  12 +-
>  mm/mm_init.c                                  |   2 +-
>  mm/page_alloc.c                               |   4 +-
>  mm/slab.h                                     |   2 +-
>  mm/sparse-vmemmap.c                           |  44 ++-
>  mm/sparse.c                                   |   3 +
>  mm/util.c                                     |  16 +-
>  18 files changed, 345 insertions(+), 353 deletions(-)
> 
> -- 
> 2.51.2
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

