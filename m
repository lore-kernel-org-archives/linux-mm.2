Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D46FEEF25
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC406B00A9; Tue,  7 Apr 2026 08:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C4E6B00AB; Tue,  7 Apr 2026 08:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B0A6B00AC; Tue,  7 Apr 2026 08:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71E286B00A9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:22:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C27BD8C3E8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:22:02 +0000 (UTC)
X-FDA: 84631671684.24.C83D675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2ABC18000D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:22:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxjb17fO;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775564521; a=rsa-sha256;
	cv=none;
	b=0jhd6ln3ExeXNrx4iH95bBKkwlM3uFcOF+HZuKN2mUDMv1algJfay7mNaAMGhBFJ3nwTlT
	Yfne5mGYLzle04MivTquxsRjNn3iFqVnc83KeJ/h0eiWut6llQSUDBj9DSZk/kNWQYMmaC
	zwVDZQIrpEX3/Ng4jQPFP/sAAF3MWTE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775564521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wOl4pLQWmuX0KGYFs8He7ddqEm8KMqlJGnSnER8xC0=;
	b=ArDdMilIvjztcikOQNDwIPs9JO1IO/u70sXruYeYcsZbgEu8ouvClf3WgUhyvUqSfyKceY
	HZDBHXXqUYAxPfA3VGGoh4EcIo1A2xwMnkE7xTrb0OhCCSZzR5DMSytp5Pht+7cY0ED0J9
	u4pECnikXLJHhJO5SFD6A9iBT4p268c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxjb17fO;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75DF4600AC;
	Tue,  7 Apr 2026 12:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76D9C116C6;
	Tue,  7 Apr 2026 12:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775564520;
	bh=xHfxr7YSFJdG1HZby87mcGOZOFI3yTCdr2nCajTsyyk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mxjb17fObVgiL4e/YYWonCIVH4omn+ZE9R4Pyi7tcHPLYspqePB3hvSm7wBMo0kmG
	 4Di+xvooRJibn/a7Md9bbXg/VwPMyjhqPRvECggHhrr9SJVxOgt1jIdyTIHrq1+cCq
	 movlnsXgEMJrOORG7rThlg1GZ3r/88+CtNg0kPANOQt0q0nQQSOSH23pK3AZjQJyNv
	 KTV9P23MC1qC5apWMB/BeInuDu1UG/fk3uOli7FQXvB8ThktCMc3HV43D2ue0MXcav
	 iJZrLx027w5DqVZ5Hvs5l9t5wUoIs9Fo7FZyRYv6+19XWumkrUB+LXnk/T5x9VQUG0
	 baZFbd0sLwo6A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,  Zi
 Yan <ziy@nvidia.com>,
  Evangelos Petrongonas <epetron@amazon.de>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
In-Reply-To: <acAAp4JaTGn_STBH@kernel.org> (Mike Rapoport's message of "Sun,
	22 Mar 2026 16:45:59 +0200")
References: <20260317141534.815634-3-mclapinski@google.com>
	<AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
	<CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
	<76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
	<CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
	<0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
	<CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
	<58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
	<aburnbP64n9axmu_@kernel.org>
	<CAAi7L5evx8ta8BifNiGNfUoTiaBUsv4cgQRbm_15RoAfdKPcMw@mail.gmail.com>
	<acAAp4JaTGn_STBH@kernel.org>
Date: Tue, 07 Apr 2026 12:21:56 +0000
Message-ID: <2vxzwlyj9d0b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2ABC18000D
X-Stat-Signature: hyrn3ffjn7rn3mtzubm4e6uw6zdkxxm6
X-HE-Tag: 1775564520-117932
X-HE-Meta: U2FsdGVkX18M89U22UFEKCfeCVsFyNpAooIC8xq/HOMmOlrrsmEchKOBSvKMel/YYxvcHg6JQlxsCDkuqktRSg90tqgsZGsN43/frVNH/bEjFxWm9PvsvN0PByd1lg+5TlHihVIBCe8layHkf98I7LUebXt6qd279phQNgDgaIeqiKu+weaXX90Y5ex4+zqRQ2OGllSslNVWclp345/bBfqIBrMUbZht/3eMMM3rD0fUKkrSUHbbvyyDSB7pSAmfeMVJk7XuPbfXJoRe0LaR2TZECTqYv/RbAwnPb8abPbrD2PsZzsZfGusaz+GfNk5DTO7RYnXZkHICNrETH5uK2MuaNbX+fp39JT7TY7x3gh1+0yNMOvhGZD/a36m0/7f/xyHGigr/FqxShr7PreVOr2lmWCGzBzxq4eC0xv6n22QHMobK/jQrP32Xck3MEBYh2Vgn5b0h1Yvp/WiGLLnCv4UsxXH4io/V0eo7m2p8iQGC5Hlbi0C0QDH9ZpvOim7HFIyxT53NvoSMlRRXBkdgnoYFMcD4m9gnFq16dQab/ndM3serru8h5unR9h0kfIVaefFt1WoWrqMOTm6an8eHH+yJoMMdjrLElVrXSSpRv+ml6dOj2hjL//fDZ8THXw1H76otDTRKrWST5gnvHHA4A3HNrMvECzY2gljqb1O6LcidHXEHmE0m30YA6O5a3YGJbFmPxhfk7Wf/wW0usLbzGnKBwvg1T9d/mVz4/KwegtMzJBFoW9/lnZZXW89dU9w5g4hKUEp4p89cwTmpTFbcXt4z1Jxp5LKDOhRR/M+eUSDAQsVyEo3nk2vlPUlbAhgX5dgesrGtdLnx3SWwilXaBHwFI/GDyH+faRuYJVrqVsIwSktZ8QAS2v/cfzUaaFqcneE1QGYiHZWTRulp90UmcPdPj7IDStXCpYLefJ/AoMp3BhesECEodtgzEaZHwFeozXXIb2L2YGO/OAYGAP1
 ijPZS0q5
 tFr8A/154pIxN+650pTC6OzWiV1u7VESVLKh8CkYs0B2c/ws7DH52VQgiuv2Fp9RywfmI+2zmtV5w6sifNKfrBwL4k87OMvqvN1W8Xx7Y8fTfpC4jssBBPTI2lGcJMgHQY+E9ALa7rmCXC1E8roXkidTAqIjDYGWH0Q9efr6zxEKIgqgLtHEalD8Xg/5OtvbbK/LGQq+AvLNTXYUtgl9h2do3A7fVHwgQVc7gobfjrCNvzK6362AQPN2GQW/rwkZ2qCOzqdMYXjsnEak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22 2026, Mike Rapoport wrote:

> On Thu, Mar 19, 2026 at 07:17:48PM +0100, Micha=C5=82 C=C5=82api=C5=84ski=
 wrote:
>> On Thu, Mar 19, 2026 at 8:54=E2=80=AFAM Mike Rapoport <rppt@kernel.org> =
wrote:
[...]
>> > +__init_memblock struct memblock_region *memblock_region_from_iter(u64=
 iterator)
>> > +{
>> > +       int index =3D iterator & 0xffffffff;
>>=20
>> I'm not sure about this. __next_mem_range() has this code:
>> /*
>> * The region which ends first is
>> * advanced for the next iteration.
>> */
>> if (m_end <=3D r_end)
>>         idx_a++;
>> else
>>         idx_b++;
>>=20
>> Therefore, the index you get from this might be correct or it might
>> already be incremented.
>
> Hmm, right, missed that :/
>
> Still, we can check if an address is inside scratch in
> reserve_bootmem_regions() and in deferred_init_pages() and set migrate ty=
pe
> to CMA in that case.
>
> I think something like the patch below should work. It might not be the
> most optimized, but it localizes the changes to mm_init and memblock and
> does not complicated the code (well, almost).
>
> The patch is on top of
> https://lore.kernel.org/linux-mm/20260322143144.3540679-1-rppt@kernel.org=
/T/#u
>
> and I pushed the entire set here:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=3Dk=
ho-deferred-init
>
> It compiles and passes kho self test with both deferred pages enabled and
> disabled, but I didn't do further testing yet.
>
> From 97aa1ea8e085a128dd5add73f81a5a1e4e0aad5e Mon Sep 17 00:00:00 2001
> From: Michal Clapinski <mclapinski@google.com>
> Date: Tue, 17 Mar 2026 15:15:33 +0100
> Subject: [PATCH] kho: fix deferred initialization of scratch areas
>
> Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
> kho_release_scratch() will initialize the struct pages and set migratetype
> of KHO scratch. Unless the whole scratch fits below first_deferred_pfn, s=
ome
> of that will be overwritten either by deferred_init_pages() or
> memmap_init_reserved_range().
>
> To fix it, modify kho_release_scratch() to only set the migratetype on
> already initialized pages and make deferred_init_pages() and
> memmap_init_reserved_range() recognize KHO scratch regions and set
> migratetype of pageblocks in that regions to MIGRATE_CMA.

Hmm, I don't like that how complex this is. It adds another layer of
complexity to the initialization of the migratetype, and you have to dig
through all the possible call sites to be sure that we catch all the
cases. Makes it harder to wrap your head around it. Plus, makes it more
likely for bugs to slip through if later refactors change some page init
flow.

Is the cost to look through the scratch array really that bad? I would
suspect we'd have at most 4-6 per-node scratches, and one global one
lowmem. So I'd expect around 10 items to look through, and it will
probably be in the cache anyway.

Michal, did you ever run any numbers on how much extra time
init_pageblock_migratetype() takes as a result of your patch?

Anyway, Mike, if you do want to do it this way, it LGTM for the most
part, but some comments below.

>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/memblock.h           |  7 ++++--
>  kernel/liveupdate/kexec_handover.c | 10 +++++---
>  mm/memblock.c                      | 39 +++++++++++++-----------------
>  mm/mm_init.c                       | 14 ++++++-----
>  4 files changed, 36 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 6ec5e9ac0699..410f2a399691 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -614,11 +614,14 @@ static inline void memtest_report_meminfo(struct se=
q_file *m) { }
>  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>  void memblock_set_kho_scratch_only(void);
>  void memblock_clear_kho_scratch_only(void);
> -void memmap_init_kho_scratch_pages(void);
> +bool memblock_is_kho_scratch_memory(phys_addr_t addr);
>  #else
>  static inline void memblock_set_kho_scratch_only(void) { }
>  static inline void memblock_clear_kho_scratch_only(void) { }
> -static inline void memmap_init_kho_scratch_pages(void) {}
> +static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
> +{
> +	return false;
> +}
>  #endif
>=20=20
>  #endif /* _LINUX_MEMBLOCK_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 532f455c5d4f..12292b83bf49 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1457,8 +1457,7 @@ static void __init kho_release_scratch(void)
>  {
>  	phys_addr_t start, end;
>  	u64 i;
> -
> -	memmap_init_kho_scratch_pages();
> +	int nid;
>=20=20
>  	/*
>  	 * Mark scratch mem as CMA before we return it. That way we
> @@ -1466,10 +1465,13 @@ static void __init kho_release_scratch(void)
>  	 * we can reuse it as scratch memory again later.
>  	 */
>  	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> +			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
>  		ulong start_pfn =3D pageblock_start_pfn(PFN_DOWN(start));
>  		ulong end_pfn =3D pageblock_align(PFN_UP(end));
>  		ulong pfn;
> +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> +		end_pfn =3D min(end_pfn, NODE_DATA(nid)->first_deferred_pfn);
> +#endif

Can we just get rid of this entirely? And just update
memmap_init_zone_range() to also look for scratch and set the
migratetype correctly from the get go? That's more consistent IMO. The
two main places that initialize the struct page,
memmap_init_zone_range() and deferred_init_memmap_chunk(), check for
scratch and set the migratetype correctly.
>=20=20
>  		for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D pageblock_nr_pages)
>  			init_pageblock_migratetype(pfn_to_page(pfn),
> @@ -1480,8 +1482,8 @@ static void __init kho_release_scratch(void)
>  void __init kho_memory_init(void)
>  {
>  	if (kho_in.scratch_phys) {
> -		kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
>  		kho_release_scratch();
> +		kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
>=20=20
>  		if (kho_mem_retrieve(kho_get_fdt()))
>  			kho_in.fdt_phys =3D 0;
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 17aa8661b84d..fe50d60db9c6 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -17,6 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> +#include <linux/page-isolation.h>
>=20=20
>  #ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
> @@ -959,28 +960,6 @@ __init void memblock_clear_kho_scratch_only(void)
>  {
>  	kho_scratch_only =3D false;
>  }
> -
> -__init void memmap_init_kho_scratch_pages(void)
> -{
> -	phys_addr_t start, end;
> -	unsigned long pfn;
> -	int nid;
> -	u64 i;
> -
> -	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
> -		return;
> -
> -	/*
> -	 * Initialize struct pages for free scratch memory.
> -	 * The struct pages for reserved scratch memory will be set up in
> -	 * reserve_bootmem_region()
> -	 */
> -	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> -		for (pfn =3D PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
> -			init_deferred_page(pfn, nid);
> -	}
> -}
>  #endif
>=20=20
>  /**
> @@ -1971,6 +1950,18 @@ bool __init_memblock memblock_is_map_memory(phys_a=
ddr_t addr)
>  	return !memblock_is_nomap(&memblock.memory.regions[i]);
>  }
>=20=20
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> +bool __init_memblock memblock_is_kho_scratch_memory(phys_addr_t addr)
> +{
> +	int i =3D memblock_search(&memblock.memory, addr);
> +
> +	if (i =3D=3D -1)
> +		return false;
> +
> +	return memblock_is_kho_scratch(&memblock.memory.regions[i]);
> +}
> +#endif
> +
>  int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
>  			 unsigned long *start_pfn, unsigned long *end_pfn)
>  {
> @@ -2262,6 +2253,10 @@ static void __init memmap_init_reserved_range(phys=
_addr_t start,
>  		 * access it yet.
>  		 */
>  		__SetPageReserved(page);
> +
> +		if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> +		    pageblock_aligned(pfn))
> +			init_pageblock_migratetype(page, MIGRATE_CMA, false);
>  	}
>  }
>=20=20
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 96ae6024a75f..5ead2b0f07c6 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1971,7 +1971,7 @@ unsigned long __init node_map_pfn_alignment(void)
>=20=20
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  static void __init deferred_free_pages(unsigned long pfn,
> -		unsigned long nr_pages)
> +		unsigned long nr_pages, enum migratetype mt)
>  {
>  	struct page *page;
>  	unsigned long i;
> @@ -1984,8 +1984,7 @@ static void __init deferred_free_pages(unsigned lon=
g pfn,
>  	/* Free a large naturally-aligned chunk if possible */
>  	if (nr_pages =3D=3D MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
>  		for (i =3D 0; i < nr_pages; i +=3D pageblock_nr_pages)
> -			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
> -					false);
> +			init_pageblock_migratetype(page + i, mt, false);
>  		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
>  		return;
>  	}
> @@ -1995,8 +1994,7 @@ static void __init deferred_free_pages(unsigned lon=
g pfn,
>=20=20
>  	for (i =3D 0; i < nr_pages; i++, page++, pfn++) {
>  		if (pageblock_aligned(pfn))
> -			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
> -					false);
> +			init_pageblock_migratetype(page, mt, false);
>  		__free_pages_core(page, 0, MEMINIT_EARLY);
>  	}
>  }
> @@ -2052,6 +2050,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn,=
 unsigned long end_pfn,
>  	u64 i =3D 0;
>=20=20
>  	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
> +		enum migratetype mt =3D MIGRATE_MOVABLE;
>  		unsigned long spfn =3D PFN_UP(start);
>  		unsigned long epfn =3D PFN_DOWN(end);
>=20=20
> @@ -2061,12 +2060,15 @@ deferred_init_memmap_chunk(unsigned long start_pf=
n, unsigned long end_pfn,
>  		spfn =3D max(spfn, start_pfn);
>  		epfn =3D min(epfn, end_pfn);
>=20=20
> +		if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
> +			mt =3D MIGRATE_CMA;

Would it make sense for for_each_free_mem_range() to also return the
flags for the region? Then you won't have to do another search. It adds
yet another parameter to it so no strong opinion, but something to
consider.

> +
>  		while (spfn < epfn) {
>  			unsigned long mo_pfn =3D ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>  			unsigned long chunk_end =3D min(mo_pfn, epfn);
>=20=20
>  			nr_pages +=3D deferred_init_pages(zone, spfn, chunk_end);
> -			deferred_free_pages(spfn, chunk_end - spfn);
> +			deferred_free_pages(spfn, chunk_end - spfn, mt);
>=20=20
>  			spfn =3D chunk_end;
>=20=20
> --=20
>
> 2.53.0

--=20
Regards,
Pratyush Yadav

