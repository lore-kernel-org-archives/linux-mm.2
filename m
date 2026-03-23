Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E220D58B00
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61F06B0005; Mon, 23 Mar 2026 08:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13A46B0088; Mon, 23 Mar 2026 08:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28F36B0089; Mon, 23 Mar 2026 08:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2FFC6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:37:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53C69140B02
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:37:57 +0000 (UTC)
X-FDA: 84577279794.16.2F0CF36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0840100002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:37:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qm/vDxPr";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774269475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCA+hl7nXD71syHZF/12USZbpLgCENC3QFd+0pYTue4=;
	b=gUXeuTlodNPvKhMZf9E5SM2g3GrrHb+fLEyjwUk4kgTBVotcTqz148CnF0nlkwszKhdu4P
	lcUFDYkGf2DV1czdtrg9/kh+3GTKUTyDWZP5CugC3CGWZhwJKE/krQAwEitggLa1DbLLep
	dT45/2+wCGnrGrjXyaY09y853jyj2t8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qm/vDxPr";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774269475; a=rsa-sha256;
	cv=none;
	b=fUSezIEnhqM4sBZkh5ue8htSg+ySPiLv69t9/2QhbbFNTCId0/21OHuX3lLamNycQPKS8N
	6sf2Tt15cSWL01+0YuslWEeS5/NnRl8/4pc/bv36f2ltAWseH1nxfzzfpb9/bHzH9m9fRm
	BhANW9Apbqaa4ovX5Mej3ADSA7lEwu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26C66600AC;
	Mon, 23 Mar 2026 12:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1930CC4CEF7;
	Mon, 23 Mar 2026 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774269474;
	bh=pWOP+TV+f5i3NcLiRMbYoqpmIUSaEtA5/yTUoUGxcSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qm/vDxPrEbfxJgKA4RY8T4W9WY7KiU2gd+tsuieKY1TaNbT7xBKjOb/khD6y1AUoY
	 zrH+3DtDE2rvETWUHXpgQtooOZYzAKmL4Z2CEcDZcXmC1/USZ+ZxKYdmyY8o6iiLFp
	 bNjweA7La3lULqs8ogfeh0KW1EIMBH6Jx8CK99MVSZlP+sWusMxn5EWpn7vVrFsYGD
	 6S4aOANsN+X7NQz7bInid7zOlKFXuTN/eSxBxSyG+H/dPl58QaURyYvUs4Dz25lxZc
	 6C6quFi/S4DEhG9kDKUSc2yxVCK0PInTMzfMHKTiBa2UJP4tCxphZW0cyzHEs1vchy
	 cQGohV4osDI0g==
Date: Mon, 23 Mar 2026 12:37:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] memblock: move reserve_bootmem_range() to memblock.c
 and make it static
Message-ID: <445a1456-68da-45e7-ac0a-c1ed0cd086c4@lucifer.local>
References: <20260323072042.3651061-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260323072042.3651061-1-rppt@kernel.org>
X-Stat-Signature: bt7zoak5c5ks7eitbc1xk3tmoo3cfjgf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B0840100002
X-HE-Tag: 1774269475-310669
X-HE-Meta: U2FsdGVkX19+l+rHCyDh4LkAYz5ZRrSADZHtF9xWEodT2GbACMZnOtJaj+aedFaC3vHsaiNGTboJZWljLAR/FrBlY1R+ECRHyODHL9ce928TGqFrvEmktpcJPXP2L9ePguQMtCm4r6bN0Vhm5/MQPxf20k4mUXbg966+GFc/QJQpxicKyvrnlXMYYAKgLjbEoKOuyQs8DYbEA+BLWT11Jq+IePbgQGE+ylE34dvxoLvHadxyP5LegF/icrbe7gIJhfiA06LKbn5QE0qhLyUea/epCknZWix2Edfowy45us16Kb73PAE0V4sL7oHwvmuCTxMaEtaC//KchmfPurJES0B/hmcoKN5x6j1i4cBacjzxWhbHmp6cIxSdC2PIPh5ofELRbuBmaKN3ZFpb6jajKzinv1PbXJDwNlqGI+MvR0Kf+J5Dcp7iaooQXUeNcg6l1sX4h6AbXpNzC0dxOyL93ZPeXwQmOtGZmUtbqZrbDeoLmfGT0nR2V5pGPDQn0omgy3xmmVs3OTh3WSHgD0jtxcBpd/dnvqNrhIWUgfh4uaBSabr9kjb46Q0uvVCVRDty7JTYSEYuQXhEGUrlN6B+yL4NshsaGqsR2oiindL61C9UpURzWtHqJ+JWVDVXzJTjWMSQf1w/o7lQyhMCcXs8qSJELyuLLqhBNgqAxjuL/sun7WoCPUB3iGElBBUeZSGl+n4V3rlfJ4pYptulGG1zVAXtmze5hdxGznjBabIpYu1BOK7yG/0c5zv/FVtoWyscRE5pqToQ5ARJ2rFWptsl50FVwF6fI9Mv/wgxsaVJWFPshBjRRU4apdwxtVGC2FgcX/sTfCU6Qx2IhZSvB8wvp8CrW1c0nUr2kcUA95dvFgoXAwR3KnP1ybY1DqrJf7WnKvOiyGgrLf1IZTKT3TYIPnhWHdK5yrcuwhXt5bK6DZ/wuJJljVgrQt/yfaD1sbhJu7GSAJZnTWbNBcC8a12
 Ol7Z0+wh
 CIwn8nlig7h+jjMJrnk5UAbJbjEagWKUo4+MJXQifQkLnNsSzSOLusnkllJwrzCtH/D8xwQVL8mdcq1r/Zdb7lQTCpovjV9ny4EsyWcw/ZJn4m4M7pdrys6I4U7t/X9X8X644kV+xhIqguwsyZrRsfgfji8Gauiizmv98MTrkl2Wmi19fokyTV92tLjKkhswhl8rf65EzaYrd+YFC9t7Vz7F5a95RaEc+c3SBSmIWUZJqW+Io02DmhLTcV5ha9MLR2ndoC/znW2n2aBQcfnu0rKFSakPCDMYj1O54hx0SWNdT40ei0Y2wlROwe8eGChsQavelpKoemTV6ZWq/ebCogCjgnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 09:20:42AM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> reserve_bootmem_region() is only called from
> memmap_init_reserved_pages() and it was in mm/mm_init.c because of its
> dependecies on static init_deferred_page().
>
> Since init_deferred_page() is not static anymore, move
> reserve_bootmem_region(), rename it to memmap_init_reserved_range() and
> make it static.
>
> Update the comment describing it to better reflect what the function
> does and drop bogus comment about reserved pages in free_bootmem_page().
>
> Update memblock test stubs to reflect the core changes.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM and passed local tests so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/bootmem_info.h      |  4 ----
>  include/linux/mm.h                |  3 ---
>  mm/memblock.c                     | 31 ++++++++++++++++++++++++++++---
>  mm/mm_init.c                      | 25 -------------------------
>  tools/include/linux/mm.h          |  2 --
>  tools/testing/memblock/internal.h |  9 +++++++++
>  tools/testing/memblock/mmzone.c   |  4 ----
>  7 files changed, 37 insertions(+), 41 deletions(-)
>
> diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
> index 4c506e76a808..492ceeb1cdf8 100644
> --- a/include/linux/bootmem_info.h
> +++ b/include/linux/bootmem_info.h
> @@ -44,10 +44,6 @@ static inline void free_bootmem_page(struct page *page)
>  {
>  	enum bootmem_type type = bootmem_type(page);
>
> -	/*
> -	 * The reserve_bootmem_region sets the reserved flag on bootmem
> -	 * pages.
> -	 */
>  	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
>
>  	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index abb4963c1f06..764d10fdfb5d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3686,9 +3686,6 @@ extern unsigned long free_reserved_area(void *start, void *end,
>
>  extern void adjust_managed_page_count(struct page *page, long count);
>
> -extern void reserve_bootmem_region(phys_addr_t start,
> -				   phys_addr_t end, int nid);
> -
>  /* Free the reserved page into the buddy system, so it gets managed. */
>  void free_reserved_page(struct page *page);
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..d504205cdbf5 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -973,7 +973,7 @@ __init void memmap_init_kho_scratch_pages(void)
>  	/*
>  	 * Initialize struct pages for free scratch memory.
>  	 * The struct pages for reserved scratch memory will be set up in
> -	 * reserve_bootmem_region()
> +	 * memmap_init_reserved_pages()
>  	 */
>  	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
>  			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> @@ -2240,6 +2240,31 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>  	return end_pfn - start_pfn;
>  }
>
> +/*
> + * Initialised pages do not have PageReserved set. This function is called
> + * for each reserved range and marks the pages PageReserved.
> + * When deferred initialization of struct pages is enabled it also ensures
> + * that struct pages are properly initialised.
> + */
> +static void __init memmap_init_reserved_range(phys_addr_t start,
> +					      phys_addr_t end, int nid)
> +{
> +	unsigned long pfn;
> +
> +	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		init_deferred_page(pfn, nid);
> +
> +		/*
> +		 * no need for atomic set_bit because the struct
> +		 * page is not visible yet so nobody should
> +		 * access it yet.
> +		 */
> +		__SetPageReserved(page);
> +	}
> +}
> +
>  static void __init memmap_init_reserved_pages(void)
>  {
>  	struct memblock_region *region;
> @@ -2259,7 +2284,7 @@ static void __init memmap_init_reserved_pages(void)
>  		end = start + region->size;
>
>  		if (memblock_is_nomap(region))
> -			reserve_bootmem_region(start, end, nid);
> +			memmap_init_reserved_range(start, end, nid);
>
>  		memblock_set_node(start, region->size, &memblock.reserved, nid);
>  	}
> @@ -2284,7 +2309,7 @@ static void __init memmap_init_reserved_pages(void)
>  			if (!numa_valid_node(nid))
>  				nid = early_pfn_to_nid(PFN_DOWN(start));
>
> -			reserve_bootmem_region(start, end, nid);
> +			memmap_init_reserved_range(start, end, nid);
>  		}
>  	}
>  }
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..ea8d3de43470 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -772,31 +772,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
>  	__init_deferred_page(pfn, nid);
>  }
>
> -/*
> - * Initialised pages do not have PageReserved set. This function is
> - * called for each range allocated by the bootmem allocator and
> - * marks the pages PageReserved. The remaining valid pages are later
> - * sent to the buddy page allocator.
> - */
> -void __meminit reserve_bootmem_region(phys_addr_t start,
> -				      phys_addr_t end, int nid)
> -{
> -	unsigned long pfn;
> -
> -	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
> -		struct page *page = pfn_to_page(pfn);
> -
> -		__init_deferred_page(pfn, nid);
> -
> -		/*
> -		 * no need for atomic set_bit because the struct
> -		 * page is not visible yet so nobody should
> -		 * access it yet.
> -		 */
> -		__SetPageReserved(page);
> -	}
> -}
> -
>  /* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
>  static bool __meminit
>  overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
> index 028f3faf46e7..74cbd51dbea2 100644
> --- a/tools/include/linux/mm.h
> +++ b/tools/include/linux/mm.h
> @@ -32,8 +32,6 @@ static inline phys_addr_t virt_to_phys(volatile void *address)
>  	return (phys_addr_t)address;
>  }
>
> -void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid);
> -
>  static inline void totalram_pages_inc(void)
>  {
>  }
> diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
> index 009b97bbdd22..eb02d5771f4c 100644
> --- a/tools/testing/memblock/internal.h
> +++ b/tools/testing/memblock/internal.h
> @@ -29,4 +29,13 @@ static inline unsigned long free_reserved_area(void *start, void *end,
>  	return 0;
>  }
>
> +#define for_each_valid_pfn(pfn, start_pfn, end_pfn)                     \
> +       for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
> +
> +static inline void init_deferred_page(unsigned long pfn, int nid)
> +{
> +}
> +
> +#define __SetPageReserved(p)	((void)(p))
> +
>  #endif
> diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/mmzone.c
> index d3d58851864e..e719450f81cb 100644
> --- a/tools/testing/memblock/mmzone.c
> +++ b/tools/testing/memblock/mmzone.c
> @@ -11,10 +11,6 @@ struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
>  	return NULL;
>  }
>
> -void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid)
> -{
> -}
> -
>  void atomic_long_set(atomic_long_t *v, long i)
>  {
>  }
> --
> 2.53.0
>

FYI I saw the below when running make in tools/testing/memblock, doesn't look
related to this change but maybe something to address?


cc -I. -I../../include -Wall -O2 -fsanitize=address -fsanitize=undefined -D CONFIG_PHYS_ADDR_T_64BIT   -c -o memblock.o memblock.c
memblock.c: In function ‘memblock_add_range.isra’:
memblock.c:710:17: warning: ‘end_rgn’ may be used uninitialized [-Wmaybe-uninitialized]
  710 |                 memblock_merge_regions(type, start_rgn, end_rgn);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
memblock.c:616:42: note: ‘end_rgn’ was declared here
  616 |         int idx, nr_new, start_rgn = -1, end_rgn;
      |                                          ^~~~~~~

