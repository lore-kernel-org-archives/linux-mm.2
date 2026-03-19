Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06331091907
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327436B054D; Thu, 19 Mar 2026 14:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEBD6B0553; Thu, 19 Mar 2026 14:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDE96B055B; Thu, 19 Mar 2026 14:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF4B6B054D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:18:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 807C31B877B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:18:04 +0000 (UTC)
X-FDA: 84563621688.06.F48B042
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6068180003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:18:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r0RGg2ef;
	spf=pass (imf24.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQeSlb7OEZ3xloMA9xhKbLU6mKFG3hm3XyxfgVq5ezM=;
	b=7dQYgeglhqH6ykXxFLwFkSorV6dtHMkXbqNEcs3VMoliP4rZiSdOdny68yOmdb0XdKIsJ1
	Oqaw501d2TAqtwlPDUBhb8Ruh/v93KyuCNRyYApXSUA811Wn7+XUPPEicdNxSHRvOqeufB
	Lh5FCkb56JscGVtBOuksTqL+ZhXVJtw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r0RGg2ef;
	spf=pass (imf24.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773944282; a=rsa-sha256;
	cv=pass;
	b=vX4u3a026Fa7+M52V0+3uFDmLtr4Le9Xa4uXFDewrbshhnKfLqcjnqyUeXn1pvpJJRYCYP
	goXwyNE7T3q128Y2akatgOeun8IDEJwOEC+SzB8gQDOXvZxa5NZrtxa9me2KoSGICEoyT1
	jqmgjI70jGy5HxHNHNm5Rq2ByBzDv28=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-126ea4e9697so960c88.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:18:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773944281; cv=none;
        d=google.com; s=arc-20240605;
        b=Yl5mQhKSWwWpjtyuxREjuVcWMK28fi1vhYnGtsQTuwT3a0UXF2qkP5EqFKAlZGvFXf
         LGafcND5ytoYymL0WJqtUtIsRIT2DVNf5mbJzeSPMY6CLp/kpICu0e4k9YY2ESVgR6lf
         1rxpXWHEUtLDclsvmuvVI3uZIVs+pEfPpqVKtYpPM9cK84o+4OOwT42hM2j3uks1ga8F
         Drfd1SAW5tc5hUBZ1C4i0JfoHbQZZJFti+SdVoy18cAkbWivaFbLyfg1hYdwxDy8t3kL
         u0q98e0XHnJyfIIRaBgHFZ6z4qnT0xZ1QBBuhng61sqbVztUljXCZGv/VZ+ZB4nZtPpB
         VnZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YQeSlb7OEZ3xloMA9xhKbLU6mKFG3hm3XyxfgVq5ezM=;
        fh=L03db5qOAp5gEmousYWwEc9swaxjhLoBod9ukh8xvhw=;
        b=kPsAgMbouFl7uSUPMDeQ3++Hde4fBt54CI0SUbWlu+70LFgD3VenVvcIev20x/88uI
         F7seeOtpiQROAP0tiykNml5EWUNayeVJe33SQ1GD2Tk9BuCnVPLZjLcJEPHvXDkqcBdq
         i8vY1D5/DBNqOrizyQsikSBDlrn1CwIdO/FkhVg5soVTuqPX+o367AUc2eBrcg8FGs/C
         t3apsJXkFX0NRjqz/dmsoa5H/pLrV9WKdirD+9q4yb4EgqPvntOGT0Vj6CYgfyU8Ku9I
         jbGgxLtmCYfTikofHCTXjMtb1brdXJYveYM/blIdaNV5i4+ZJCpB7DMj0kDzI+xtBAIV
         Tf/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773944281; x=1774549081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQeSlb7OEZ3xloMA9xhKbLU6mKFG3hm3XyxfgVq5ezM=;
        b=r0RGg2efVKobRKNutjvZ7e20TY4UBn/bc9ut42B63z7empDPbZZMA4H2r+2ZGHlbc6
         nCt3h6NteKdw3BOWiPLx8c0D6+P+6vXXqWBz8KvlSIv2RCWtngDgMeOzcvOpPFmRjQMJ
         kxdAlyX7ZAw3WBJ/0MXjnwY1/gyHrD2iuk0skakioKE8GyGZxOCTtqKEmhoXQzRM0JfD
         DS0zwef2ALQ+Zgxzps+n0I7+NJtmyW5SSnoT0IVQfKZ/HamlsSyZD6I312asW5y2dH2L
         TjCGEgQ+T0TA8LN1ABAZiSGVYs/YOKvaq/o3FwwIQ93t+YRCLFTyLpZu4FvYdSlHigAs
         BvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773944281; x=1774549081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YQeSlb7OEZ3xloMA9xhKbLU6mKFG3hm3XyxfgVq5ezM=;
        b=nnx/3qNuDUAAGyXUc3j18YUhAf5kAIQFMBtG7jasw1ouyU1LfEdFxexWdXp9nbGbBF
         tDWMG0MzJdFX5yRMuhIwKCMUK3QTSIqyeuVzsWYemuI43Q5kuP3vMT2/vA6ojhTXBjSF
         Fy1oGFSzLmP3OXkP5kh4UYRebtHUWFg41QRDfftoWASHSc35lkMZN5i/1Yj7jhJyyscK
         Xmg9WFguDzDdKKjwYy92OU8qPqakOhln2/mea4BkFqyZi5wiK0w0/QN7ac4zvambDLqw
         rP0j56qjNG5y/R1QXbpDmJYwFG4D4lhDj4LsP+Gejtr8gEE3zUZ/y/bVn0ZuQBqCA0AI
         ZvfQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3Qdvz5gcyJKk13D1qum4r4xLe2JGvvDvh5Tm+fMSWKjMEX6yDt9+fCkgfEyEZWrDIeC0NB3Wa0g==@kvack.org
X-Gm-Message-State: AOJu0YxPfs3fN1DDj+IZA26+2ceFmUkKaJv4W/tn/T3DR8aPRi/SpUlD
	wxtmV/jK3iYEdhQ5VPBPurKl8eV+uHDnVVV/axFBXfgPS2EJ/ykNxq5bOozpbW2Lyg5xnqhnkoh
	v7kGbSWy7G2l/wCpN/U5Q/sqgGEmVYekZ7u2U8SB5
X-Gm-Gg: ATEYQzwLa3hWx4uCuBjxqLFDVMUbB/caBkrvQiK5z9sh3lshMo/ccYLuYvSnPnZekI6
	rPE1WVAq50AVpL1YjPPrvB3zFMmnUY8WGBfA2W+YgbemeI7a6nNqr4qKt45VQQBWe33XUsMp42L
	nyyaT1nFomoxGZEa1EI09xKKg7f/2OHeGqq9ktTDL1bb56XE/1s3y7qWErDL6wwmftfElCkB13q
	d3NfyOLFKnxQwS59ehmbuIUVbCFFA5eqfk30V67ye8aNIffmAqsW5asSVEdBV/1TGIarjg4dyxA
	Fiylp6V2uqaAznxd
X-Received: by 2002:a05:7022:699d:b0:128:ec96:67 with SMTP id
 a92af1059eb24-12a724be71fmr6228c88.9.1773944280502; Thu, 19 Mar 2026 11:18:00
 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com> <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com> <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
 <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com> <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
 <58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com> <aburnbP64n9axmu_@kernel.org>
In-Reply-To: <aburnbP64n9axmu_@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 19 Mar 2026 19:17:48 +0100
X-Gm-Features: AaiRm505tq6vM1X9ULuY3A25VFS9p9k0Q14LqvIkt_uaKuJpyK0GLpRABpnGwjA
Message-ID: <CAAi7L5evx8ta8BifNiGNfUoTiaBUsv4cgQRbm_15RoAfdKPcMw@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
To: Mike Rapoport <rppt@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Evangelos Petrongonas <epetron@amazon.de>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6068180003
X-Rspamd-Server: rspam07
X-Stat-Signature: q6z55db9ajkuhcca5w69o6bfthbcspwr
X-Rspam-User: 
X-HE-Tag: 1773944282-434700
X-HE-Meta: U2FsdGVkX1+9LUFbZt+CocfrfmwGmYW3DdoWx4Ddg1d4UArZj/+OVNij5Y19BaVQN+3h7QF0STwYbbIRTUw62FNjpGaoiZC/HM+3eJA/9QWJuVV31mSL3NTJM/KOUxK3/mkqSINTBpKZ5JOwnZVGrCuv+dqs2CinbY+4wiedL07i/P+Mu3MsQ7tANbkALnDa1qgW79Lv/tS6QYxop1uCihZkbP+1D1BPoSv9Jr5uKYB7xq8RIjTlKGnCivkaNqdbf8cNQO+HlVZ1yYb8H91qth2IGlX8wZdUNRBjT10rhzroyf29oRgj7Z151KnLYCdU0D4lpw2s81C02spfVbmj2AXob1xldvX0cqCGIiEJmk2kkxRrBicbJCg4Z9MXepRFEf415QhltHjT+CyiGPbpbO52YcWchRTgg1lXsr9bsXKDzW/JI3UiEv0MUkPmvbxW9NxCflbGExuqUUT9ta1NO70Kjs8lqyLpdxYohDcFRLw0hPxYWMUcinDw307Pb34s76BNwx4RQnexSIkZ3gafdXuHJvoVAmbjaRhVRCbQzpUbgGeWU0nKvl4lscevrmHNAsPktct+JsW05cLFg+39hINS0UoNgumR0keE2u7IrvmAecjAE27P8FoHng26xXqPqnNCI0TzzZDr2g9DeX0Ev9qhWkiQ9pH2zZNNen4xRPz6Tv6mhJ8/CGXHHBgKblBhLdqwJhhvtEui5mKy3EYtODqHl20TjpnVvgq52TEg3JJFYrnUVs51rtQa8TP7gSFLFN5lsIhjFkbRjI0rweoTGekQCeB4vgXcubV6sykVhOoyMYdrhVvdWrAzKWaOvqyPuSdcJ/GIejfnVTIWEnEtvxnzKJ54x5V/8doRX8zKBo89WGbmqTleBPAey+ULi0+XB5BHTATgXwOKmeYjmVp2PDpU1A5TbXL2rsKKjYzu33dTVB19zQON2hfCXQ2wK6weGs7sCws0dlgIdEKOCa0
 gnpFhnp9
 3bEplJz63n2hPsrjmPVArEObXAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 8:54=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi,
>
> On Wed, Mar 18, 2026 at 01:36:07PM -0400, Zi Yan wrote:
> > On 18 Mar 2026, at 13:19, Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > > On Wed, Mar 18, 2026 at 6:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote=
:
> > >>
> > >> ## Call site analysis
> > >>
> > >> init_pageblock_migratetype() has nine call sites. The init call orde=
ring
> > >> relevant to scratch is:
> > >>
> > >> ```
> > >> setup_arch()
> > >>   zone_sizes_init() -> free_area_init() -> memmap_init_range()   [1]
>
> Hmm, this is slightly outdated, but largely correct :)
>
> > >>
> > >> mm_init_free_all() / start_kernel():
> > >>   kho_memory_init() -> kho_release_scratch()                     [2]
> > >>   memblock_free_all()
> > >>     free_low_memory_core_early()
> > >>       memmap_init_reserved_pages()
> > >>         reserve_bootmem_region() -> __init_deferred_page()
> > >>           -> __init_page_from_nid()                              [3]
> > >>   deferred init kthreads -> __init_page_from_nid()               [4]
>
> And this is wrong, deferred init does not call __init_page_from_nid, only
> reserve_bootmem_region() does.
>
> And there's a case claude missed:
>
> hugetlb_bootmem_free_invalid_page() -> __init_page_from_nid() that
> shouldn't check for KHO. Well, at least until we have support for hugetlb
> persistence and most probably even afterwards.
>
> I don't think we should modify reserve_bootmem_region(). If there are
> reserved pages in a pageblock, it does not matter if it's initialized to
> MIGRATE_CMA. It only becomes important if the reserved pages freed, so we
> can update pageblock migrate type in free_reserved_area().
> When we boot with KHO, all memblock allocations come from scratch, so
> anything freed in free_reserved_area() should become CMA again.

What happens if the reserved area covers one page and that page is
pageblock aligned? Then it won't be marked as CMA until it is freed
and unmovable allocation might appear in that pageblock, right?

>
> > >> ```
> > >
> > > I don't understand this. deferred_free_pages() doesn't call
> > > __init_page_from_nid(). So I would clearly need to modify both
> > > deferred_free_pages and __init_page_from_nid.
>
> For deferred_free_pages() we don't need kho_scratch_overlap(), we already
> have memblock_region (almost) at hand and it's enough to check if it's
> MEMBLOCK_KHO_SCRATCH.
>
> Something along these lines (compile tested only) should do the trick:
>
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 3e217414e12d..b9b1e0991ec8 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -275,6 +275,8 @@ static inline void __next_physmem_range(u64 *idx, str=
uct memblock_type *type,
>         __for_each_mem_range(i, &memblock.reserved, NULL, NUMA_NO_NODE, \
>                              MEMBLOCK_NONE, p_start, p_end, NULL)
>
> +struct memblock_region *memblock_region_from_iter(u64 iterator);
> +
>  static inline bool memblock_is_hotpluggable(struct memblock_region *m)
>  {
>         return m->flags & MEMBLOCK_HOTPLUG;
> diff --git a/mm/memblock.c b/mm/memblock.c
> index ae6a5af46bd7..9cf99f32279f 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1359,6 +1359,16 @@ void __init_memblock __next_mem_range_rev(u64 *idx=
, int nid,
>         *idx =3D ULLONG_MAX;
>  }
>
> +__init_memblock struct memblock_region *memblock_region_from_iter(u64 it=
erator)
> +{
> +       int index =3D iterator & 0xffffffff;

I'm not sure about this. __next_mem_range() has this code:
/*
* The region which ends first is
* advanced for the next iteration.
*/
if (m_end <=3D r_end)
        idx_a++;
else
        idx_b++;

Therefore, the index you get from this might be correct or it might
already be incremented.

> +
> +       if (index < 0 || index >=3D memblock.memory.cnt)
> +               return NULL;
> +
> +       return &memblock.memory.regions[index];
> +}
> +
>  /*
>   * Common iterator interface used to define for_each_mem_pfn_range().
>   */
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index cec7bb758bdd..96b25895ffbe 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1996,7 +1996,7 @@ unsigned long __init node_map_pfn_alignment(void)
>
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  static void __init deferred_free_pages(unsigned long pfn,
> -               unsigned long nr_pages)
> +               unsigned long nr_pages, enum migratetype mt)
>  {
>         struct page *page;
>         unsigned long i;
> @@ -2009,8 +2009,7 @@ static void __init deferred_free_pages(unsigned lon=
g pfn,
>         /* Free a large naturally-aligned chunk if possible */
>         if (nr_pages =3D=3D MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pf=
n)) {
>                 for (i =3D 0; i < nr_pages; i +=3D pageblock_nr_pages)
> -                       init_pageblock_migratetype(page + i, MIGRATE_MOVA=
BLE,
> -                                       false);
> +                       init_pageblock_migratetype(page + i, mt, false);
>                 __free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
>                 return;
>         }
> @@ -2020,8 +2019,7 @@ static void __init deferred_free_pages(unsigned lon=
g pfn,
>
>         for (i =3D 0; i < nr_pages; i++, page++, pfn++) {
>                 if (pageblock_aligned(pfn))
> -                       init_pageblock_migratetype(page, MIGRATE_MOVABLE,
> -                                       false);
> +                       init_pageblock_migratetype(page, mt, false);
>                 __free_pages_core(page, 0, MEMINIT_EARLY);
>         }
>  }
> @@ -2077,6 +2075,8 @@ deferred_init_memmap_chunk(unsigned long start_pfn,=
 unsigned long end_pfn,
>         u64 i =3D 0;
>
>         for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
> +               struct memblock_region *region =3D memblock_region_from_i=
ter(i);
> +               enum migratetype mt =3D MIGRATE_MOVABLE;
>                 unsigned long spfn =3D PFN_UP(start);
>                 unsigned long epfn =3D PFN_DOWN(end);
>
> @@ -2086,12 +2086,15 @@ deferred_init_memmap_chunk(unsigned long start_pf=
n, unsigned long end_pfn,
>                 spfn =3D max(spfn, start_pfn);
>                 epfn =3D min(epfn, end_pfn);
>
> +               if (memblock_is_kho_scratch(region))
> +                       mt =3D MIGRATE_CMA;
> +
>                 while (spfn < epfn) {
>                         unsigned long mo_pfn =3D ALIGN(spfn + 1, MAX_ORDE=
R_NR_PAGES);
>                         unsigned long chunk_end =3D min(mo_pfn, epfn);
>
>                         nr_pages +=3D deferred_init_pages(zone, spfn, chu=
nk_end);
> -                       deferred_free_pages(spfn, chunk_end - spfn);
> +                       deferred_free_pages(spfn, chunk_end - spfn, mt);
>
>                         spfn =3D chunk_end;
>
> --
> Sincerely yours,
> Mike.

