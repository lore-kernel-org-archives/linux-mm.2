Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B9010775ED
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6646B02BF; Wed, 18 Mar 2026 13:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387876B02C0; Wed, 18 Mar 2026 13:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275D96B02C1; Wed, 18 Mar 2026 13:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 165C56B02BF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:19:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B181F8C66F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:19:51 +0000 (UTC)
X-FDA: 84559846182.11.A00C54A
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91F76C0012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:19:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ANfKNJPu;
	spf=pass (imf22.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773854389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLRA5wLn5WuPBfC09ox3pNnNkgYTeioPhs9JJbhrjUM=;
	b=jMvluCd6bKwYBQ517lrVtvYsHbY9+KLg7paTm16Vy9u1jkc4zzY95jHRenC7O1uIpenouu
	/RKzDcKgaqoIEvD7KY0IDXIfYLW9S630DexLrvbE5D9xF4FjYFKOi4X+lawBuYuzilzQlo
	HOR3ZdvT4IYabam9ppJ57X4jmwKb1lw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ANfKNJPu;
	spf=pass (imf22.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773854389; a=rsa-sha256;
	cv=pass;
	b=OLeq0VjvPcqFSeM13fuQPf3oUUWbzE3KZYyhIk8ViaD23upot3qMRiZTWFQvqW08Jui8aR
	Y1dL+qZIqTe5eD6MedULv5l1Ck/cS2MwpQ5Bc5fStYaS2AuBrKfROf9+i72P7814sEPeTg
	Dsog5Slx3LAsGeeDNkpKl+6mZOTQv8I=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-128ce536fe0so421c88.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773854388; cv=none;
        d=google.com; s=arc-20240605;
        b=TWsKOhXZ1lBN/qAe71xVQTMLfg4BIEzsk1s2yGBRI1D2nlmtzGCCzvkxIUPOZXnepH
         vvIvsCq2Fy5sJwVsQI5Gq6BhShv5/NAH6osp11etQXx+/E1EH7wvRUjfZfsjAkc6aIJd
         lNEl77khNEVWhsihNfQp5Svjwes3622nv3RnzFgjxqxLNYcroVw4R3wyR7enalgPoDmI
         exg2Ndkm4QZDxG5+kvzQlHHgFZAo6kNgnSq3stlxzpijMggB75ACtzerqniG+/V5G3U1
         hioIoXoNV3frDSflLHescWWyewdDaQRH1iOocn5tUyoQCicJ/DV2WHBzxtyJ7G6Aa3Fd
         1GgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NLRA5wLn5WuPBfC09ox3pNnNkgYTeioPhs9JJbhrjUM=;
        fh=cI3yaPHR3WsGneo0JaW4BgdHoMJuoU2I+zP/cBiypQA=;
        b=QwMcuQYbBLFmx3shH73Pyic8CmquTiDpcYvGUux+gvW4IbM+HQIPtzo3vunMDaxaVi
         6txStckJnBm2NII3CywS7HO7PJHb+XU7cjR2g/GT3Y1qgDfEjto2ZvYaxFzB+lN9iK7+
         U8PY2f0TFUDBSW589Znuv157IuH/nas3QQoE75PD286sXeIWf72JylElgqor3ZrlgnL3
         qRSfRBHZEFKeoyscXgV0MdkajQfPD8ydwsb4g/Q6CnXnq1ytb0a+VIsw6Rz6A/JOupXe
         i4joCw2gpOZwhwp+ZBGWg9pLnmUQvSYy4qe6xV3Ws05krfta8KxIrPFe6mD5RWvu5eFd
         kKqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773854388; x=1774459188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLRA5wLn5WuPBfC09ox3pNnNkgYTeioPhs9JJbhrjUM=;
        b=ANfKNJPuHJmIosJXmUi3RL6HTUVhHpK1d2eIErYM01k3Zm+gUFWCHAAahXqO8MRv7f
         gl3LANVehS5+xgfU8fm5zVniDHzQNVJaCnhC3WuBuGI1xo6agqvf05QMp2xJauRWKxss
         q9ytFcrmrShQLg9oQH2doNHDbv9lsEp33Q12cTCxYJqetrpGeqd4bAewrJE7/sCGvTfB
         ODDFRvKYers9kIUvn6ktP8cHRl2YwATk91P1aQMb+bGFISPd2PTVz40l8Zs1M9etGAC4
         phpqsaR2VzxkbzOdBv8q+dCz+V2WsPUqQZpaUGezcTAa9ovOk+xWdl0nAevndSCXaJDE
         0tFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773854388; x=1774459188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NLRA5wLn5WuPBfC09ox3pNnNkgYTeioPhs9JJbhrjUM=;
        b=oYMwhpVe5Wk4Pn3t04BL1hRobxEYABqHPKYKqmBen51os4Yt/fe7w6JKYDJRG8t4mx
         834dfRHOKKbYZ29Chry7mfn58TVoc/dQBasIj8BxaPuboHftVAbcgkSrfmqHlvvaka8+
         T1h2IpccJGc/7cLcWva8FxjcJpTDeaULjj9AyuOSjYujxHqhnN8QTLgT3VtvXqPf+E57
         q/oahGdecCehCKFxvyLDCXhHETMUePM8FMx9We+3w1rqczv7SYvN3uVt7KA99PRriLRs
         Y2dI5VlUw4QeF+0P/bjst0UgTfb+un8ULK0UTtdwJQl2itjh0UhXS1Qi2LuGPCsE8cb2
         U2iA==
X-Forwarded-Encrypted: i=1; AJvYcCWSauGh25GAELSOSWaVp8yXQMtNpfzqBEQJKX8bIci4h+9dd1vsSkK2DFlUH0G/GndrhptyS+8ASg==@kvack.org
X-Gm-Message-State: AOJu0YztH60qYm/VtSGApIBDB02cYJmzhzNvgiVcqEH4Mt+cMfYMmir3
	Ph/XJgMWNgPFgd8MkgTjoB6b+LI8ZCRhg7+5857S/IAYWIY8YrhJ4kkjSDVkqwWnOEE3mGQzBsP
	0MM3Ty2Uf+mlaJbbz+2rqBN5YrgaZd2l/hiJt2vRF
X-Gm-Gg: ATEYQzw7/vpmWdFO8FSF7aeQj7wtIRqi8HvQ+QUx+aFCrn8ZRnpNXkeoHYt/3vajZSi
	yLueqXmOeb1MLbTOFr+TgQVh3tasSBfiPS7fqCFnHVYJLlYxStFZP4DH4VqJnOGC4ot8ol2SFh6
	+bSkMr3pJIrjaevTrThqGxNMPCtu+KYI6TOnaYUZ3p6W0lqQm03Svg/SiYmY1ogQkKb3RdTByox
	Bw5FAZw1gfkwwLvMUmitKhnXXFT+Cva9Z6YH0D1R2ZUyteABvRoNPUVekXTH9LrC2l6Ht0/mC/x
	ao6Zrg==
X-Received: by 2002:a05:7022:124:b0:119:e56b:c1e3 with SMTP id
 a92af1059eb24-12a68d26a20mr10433c88.14.1773854387389; Wed, 18 Mar 2026
 10:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com> <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com> <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
 <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
In-Reply-To: <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 18 Mar 2026 18:19:35 +0100
X-Gm-Features: AaiRm52CPFaymzRa8X5AjTmLN3_97Lik6HaBOVaHylO9YyWT8r-Y2mIkOIgQpF8
Message-ID: <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
To: Zi Yan <ziy@nvidia.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 91F76C0012
X-Rspamd-Server: rspam08
X-Stat-Signature: 57949okk3f4tj78ie76rp8141yeuzhqa
X-HE-Tag: 1773854389-937706
X-HE-Meta: U2FsdGVkX18iXDKTvLZEeQwXIqddilN2mOf4R0Ae4UULQXInpTKJTE6cLsosgyZtXL3FneGnOEstRlKJTrqAusun6dxS+BPxaVVqKn4V8chBVsGIhQvpzS9+CteJYUDUGrnf5edAO9bTnZJaagUveJ/VcifHMTWcd4PWaoRdlGmb8wWw8bBwI4rYw/wgSsx0aMYEzYvzI39k9YCGn+9k6XkQQL+KsVs8f36uxq3z4rDP9C8eZHUzu56xQVuRMU7EBu8t/KGDZuoTN5c3pNcm42SAHFUA9aXlM2hfWQB3x2gfawmMCmgfYw10WgEl1j2adZ824ScRgWiqvaEgDhGLO35et3UXcadUd/jM3nA7/utB2ZbMcmf8m+DcMM0WhSEPgWxudHpIwV73MH/5y6I4sCcRuX2Mm/w1yo77p0MnxTKi8I9a6IwInKJih0swpSsKeU0uBBTU95/oP5dGiOCpp73usr7EEBMN/Gs/AOX/gRCcq/qQlqJqdAKhrpmb7q6wTmNkcSYurRqbkKgb7yz/iJqzoGIHxb/pm7gSz191uWP2oZyyZdT16SetUctZ/wzHsHx5HORgwVGIe5i22VVttGQGDfBQ5GmuqFIDslipedQxfm2xYMIZLc9knYXurcluVkYYPMrndpxriMaI+qiZBBG5JG8on+FBa2ILS23Ej+KWbFD/MVmLn25iWPV4G/cnZ8TVWZYRnQbm7W1fhz6XJLlDiAOde5IW8Als0jyXxXAQtdVkNeYhQE7ErNgrnihBEsIlvYM5wuDTb+uj0RwVQFvWpUJSLNtCURbaXndt5GxKiulyoZHqYwXq4EEtVFNmEOUFjLWMK3tQB3sNYYr4T7QWa5rZaMXyy1Xz6yb5RvCdZVeCpv8jONbH8qNnlgER7BnbKFj/nLUWo3A0slKackyJTuwGWrpIATu4vb4wJa3GFcy7m4vUF4AaWGB5LchN07RTKpaPAPfsb9HC4+J
 OaUONU1J
 22B45CMKioBpdpDvzSldEUbbsz0snRj3WWohrqalmcsThTWB9c0MA908A1swU6GcSDvu1ayP3Gz8A/+H4kOnfdA15lSobgrgMN8R/FlE5lYMo+7rP7fNF487yZ+HgKxQJ4cYSmetDTfn+YngfwZQOSjTWSuaB/wW8YzohoHcpitA/Et1kpfUjNSjogC8ENbA1sYlL3eDYbpHHREx6cBnT7qtlZAGF0B38mZlsOxoBEj3/LRT4VcXpSxY4cU4lRhYwGvPco7alyer6ZH0e+lcNPoSOkNcV81vPugXp1cA+ZPemmMqbfuoVXNyCgwddietqDqfxu5w0IqmkxOB8J85ukpvXWcy5SaikWTr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 6:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 18 Mar 2026, at 11:45, Micha=C5=82 C=C5=82api=C5=84ski wrote:
>
> > On Wed, Mar 18, 2026 at 4:26=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 18 Mar 2026, at 11:18, Micha=C5=82 C=C5=82api=C5=84ski wrote:
> >>
> >>> On Wed, Mar 18, 2026 at 4:10=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote=
:
> >>>>
> >>>> On 17 Mar 2026, at 10:15, Michal Clapinski wrote:
> >>>>
> >>>>> Currently, if DEFERRED is enabled, kho_release_scratch will initial=
ize
> >>>>> the struct pages and set migratetype of kho scratch. Unless the who=
le
> >>>>> scratch fit below first_deferred_pfn, some of that will be overwrit=
ten
> >>>>> either by deferred_init_pages or memmap_init_reserved_pages.
> >>>>>
> >>>>> To fix it, I modified kho_release_scratch to only set the migratety=
pe
> >>>>> on already initialized pages. Then, modified init_pageblock_migrate=
type
> >>>>> to set the migratetype to CMA if the page is located inside scratch=
.
> >>>>>
> >>>>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> >>>>> ---
> >>>>>  include/linux/memblock.h           |  2 --
> >>>>>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
> >>>>>  mm/memblock.c                      | 22 ----------------------
> >>>>>  mm/page_alloc.c                    |  7 +++++++
> >>>>>  4 files changed, 13 insertions(+), 28 deletions(-)
> >>>>>
> >>>>
> >>>> <snip>
> >>>>
> >>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>>> index ee81f5c67c18..5ca078dde61d 100644
> >>>>> --- a/mm/page_alloc.c
> >>>>> +++ b/mm/page_alloc.c
> >>>>> @@ -55,6 +55,7 @@
> >>>>>  #include <linux/cacheinfo.h>
> >>>>>  #include <linux/pgalloc_tag.h>
> >>>>>  #include <linux/mmzone_lock.h>
> >>>>> +#include <linux/kexec_handover.h>
> >>>>>  #include <asm/div64.h>
> >>>>>  #include "internal.h"
> >>>>>  #include "shuffle.h"
> >>>>> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(stru=
ct page *page,
> >>>>>                    migratetype < MIGRATE_PCPTYPES))
> >>>>>               migratetype =3D MIGRATE_UNMOVABLE;
> >>>>>
> >>>>> +     /*
> >>>>> +      * Mark KHO scratch as CMA so no unmovable allocations are ma=
de there.
> >>>>> +      */
> >>>>> +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZ=
E)))
> >>>>> +             migratetype =3D MIGRATE_CMA;
> >>>>> +
> >>>>
> >>>> If this is only for deferred init code, why not put it in deferred_f=
ree_pages()?
> >>>> Otherwise, all init_pageblock_migratetype() callers need to pay the =
penalty
> >>>> of traversing kho_scratch array.
> >>>
> >>> Because reserve_bootmem_region() doesn't call deferred_free_pages().
> >>> So I would also have to modify it.
> >>>
> >>> And the early initialization won't pay the penalty of traversing the
> >>> kho_scratch array, since then kho_scratch is NULL.
> >>
> >> How about hugetlb_bootmem_init_migratetype(), init_cma_pageblock(),
> >> init_cma_reserved_pageblock(), __init_page_from_nid(), memmap_init_ran=
ge(),
> >> __init_zone_device_page()?
> >>
> >> 1. are they having any PFN range overlapping with kho?
> >> 2. is kho_scratch NULL for them?
> >>
> >> 1 tells us whether putting code in init_pageblock_migratetype() could =
save
> >> the hassle of changing all above locations.
> >> 2 tells us how many callers are affected by traversing kho_scratch.
> >
> > I could try answering those questions but
> >
> > 1. I'm new to this and I'm not sure how correct the answers will be.
> >
> > 2. If you're not using CONFIG_KEXEC_HANDOVER, the performance penalty
> > will be zero.
> > If you are using it, currently you have to disable
> > CONFIG_DEFERRED_STRUCT_PAGE_INIT and the performance hit from this is
> > far, far greater. This solution saves 0.5s on my setup (100GB of
> > memory). We can always improve the performance further in the future.
> >
>
> OK, I asked Claude for help and the answer is that not all callers of
> init_pageblock_migratetype() touch kho scratch memory regions. Basically,
> you only need to perform the kho_scratch_overlap() check in
> __init_page_from_nid() to achieve the same end result.
>
>
> The below is the analysis from Claude.
> Based on my understanding,
> 1. memmap_init_range() is done before kho_memory_init(), so it does not n=
eed
> the check.
>
> 2. __init_zone_device_page() is not relevant.
>
> 3. init_cma_reserved_pageblock() / init_cma_pageblock() are already set
> to MIGRATE_CMA.
>
> 4. hugetlb is not used by kho scratch, so also does not need the check.
>
> 5. kho_release_scratch() already takes care of it.
>
> The remaining memblock_free_pages() needs a check, but I am not 100%.
>
>
> # kho_scratch_overlap() in init_pageblock_migratetype() =E2=80=94 scope a=
nalysis
>
> ## Context
>
> Commit a7700b3c6779 ("kho: fix deferred init of kho scratch") added a
> kho_scratch_overlap() call inside init_pageblock_migratetype() in
> mm/page_alloc.c:
>
> ```c
> if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
>     migratetype =3D MIGRATE_CMA;
> ```
>
> kho_scratch_overlap() does a NULL check followed by a loop over the
> kho_scratch array. For non-KHO boots (kho_scratch =3D=3D NULL) the cost i=
s
> a single NULL load and branch. For KHO boots the loop runs on every call
> to init_pageblock_migratetype().
>
> ## Question
>
> Does this add overhead for callers whose memory range cannot overlap
> with scratch? Can the check be moved to the caller side?
>
> ## Call site analysis
>
> init_pageblock_migratetype() has nine call sites. The init call ordering
> relevant to scratch is:
>
> ```
> setup_arch()
>   zone_sizes_init() -> free_area_init() -> memmap_init_range()   [1]
>
> mm_init_free_all() / start_kernel():
>   kho_memory_init() -> kho_release_scratch()                     [2]
>   memblock_free_all()
>     free_low_memory_core_early()
>       memmap_init_reserved_pages()
>         reserve_bootmem_region() -> __init_deferred_page()
>           -> __init_page_from_nid()                              [3]
>   deferred init kthreads -> __init_page_from_nid()               [4]
> ```

I don't understand this. deferred_free_pages() doesn't call
__init_page_from_nid(). So I would clearly need to modify both
deferred_free_pages and __init_page_from_nid.

>
> ### Per call site
>
> **mm/mm_init.c =E2=80=94 __init_page_from_nid() (deferred init)**
>
> Called for every deferred pfn (>=3D first_deferred_pfn). Scratch pages
> in the deferred range are not touched by kho_release_scratch() (new
> code clips end_pfn to first_deferred_pfn) and not touched by
> memmap_init_range() (stops at first_deferred_pfn). This path sets
> MIGRATE_MOVABLE on deferred scratch pageblocks after
> kho_release_scratch() has already run.
>
> **Needs the fix: yes.**
>
> Both sub-paths that reach this function for deferred scratch pages:
> - deferred init kthreads [4]
> - reserve_bootmem_region() -> __init_deferred_page() [3]
>   (early_page_initialised() returns early for non-deferred pfns, so
>   __init_page_from_nid() is only reached for deferred pfns here too)
>
> **mm/mm_init.c =E2=80=94 memmap_init_range()**
>
> Runs during setup_arch() [1], before kho_memory_init() [2]. Sets
> MIGRATE_MOVABLE on scratch pageblocks, but kho_release_scratch() runs
> afterward and correctly overrides to MIGRATE_CMA for non-deferred
> scratch. For deferred scratch, memmap_init_range() stops at
> first_deferred_pfn and never processes them.
>
> **Needs the fix: no.**
>
> **mm/mm_init.c =E2=80=94 __init_zone_device_page()**
>
> ZONE_DEVICE path only. Scratch is normal RAM, not ZONE_DEVICE.
>
> **Needs the fix: no.**
>
> **mm/mm_init.c =E2=80=94 memblock_free_pages() (lines ~2012 and ~2023)**
>
> Called by memblock_free_all() for free (non-reserved) memblock regions.
> Scratch is memblock-reserved and released through the CMA path, not
> through memblock_free_all().
>
> **Needs the fix: no.**
>
> **mm/mm_init.c =E2=80=94 init_cma_reserved_pageblock() / init_cma_pageblo=
ck()**
>
> Both already pass MIGRATE_CMA. The kho_scratch_overlap() check would
> be redundant even if scratch reaches these paths.
>
> **Needs the fix: no (redundant).**
>
> **mm/hugetlb.c =E2=80=94 __prep_compound_gigantic_folio()**
>
> Gigantic hugepage setup. Scratch regions are not used for gigantic
> hugepages.
>
> **Needs the fix: no.**
>
> **kernel/liveupdate/kexec_handover.c =E2=80=94 kho_release_scratch()**
>
> Already passes MIGRATE_CMA. Additionally, kho_scratch is NULL at the
> point kho_release_scratch() runs (kho_memory_init() sets kho_scratch
> only after kho_release_scratch() returns), so kho_scratch_overlap()
> would return false regardless.
>
> **Needs the fix: no.**
>
> ## Conclusion
>
> The only path that actually requires the MIGRATE_CMA override is
> __init_page_from_nid(). All problematic sub-paths (deferred init
> kthreads and reserve_bootmem_region()) converge there.
>
> The check could be moved to __init_page_from_nid() to keep the
> KHO-specific concern out of the generic init_pageblock_migratetype():
>
> ```c
> /* mm/mm_init.c: __init_page_from_nid() */
> if (pageblock_aligned(pfn)) {
>     enum migratetype mt =3D MIGRATE_MOVABLE;
>     if (kho_scratch_overlap(PFN_PHYS(pfn), PAGE_SIZE))
>         mt =3D MIGRATE_CMA;
>     init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
> }
> ```
>
> __init_page_from_nid() is only compiled under CONFIG_DEFERRED_STRUCT_PAGE=
_INIT,
> which is the only configuration where the bug can occur, so the
> kho_scratch_overlap() call would be naturally gated by that config.
>
>
>
> Best Regards,
> Yan, Zi

