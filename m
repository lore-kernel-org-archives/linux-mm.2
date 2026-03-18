Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88624103E197
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C724F6B027A; Wed, 18 Mar 2026 11:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C226C6B027C; Wed, 18 Mar 2026 11:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11616B027D; Wed, 18 Mar 2026 11:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4966B027A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:45:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7045813BB47
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:45:41 +0000 (UTC)
X-FDA: 84559608882.17.F2E0963
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F410140009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:45:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sMi9NWdN;
	spf=pass (imf23.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773848739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6gmeMVPdTQy9BEMRG9Pt8pp3Mke6GzH6nH2NXf+FRA=;
	b=KFUABAdKAq1VmvH1oVxcQJrgayz4eFHhs3kBTHeYWqfeo1ubiV310i/H5LKwycSzOw2ZZC
	2Y9pqvfvVxsHtGN09Ale5oDnYiYInNaOoA5HPbMZ4uVHAfo54ELgFeKWe/13bKQJHVlGm2
	/R/ZFp0wkdiY5NVd/mhcU2mHwIY1B+o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773848739; a=rsa-sha256;
	cv=pass;
	b=jgBelYdi4VNF+Gj+755a0YX3ewjJqmbVaxYrnVAD70WT8mLtFxcZCnk04o2PH04Ou7sGWM
	H1cmAXraN3R7JMKzGiHX7d++jzOuj3CwocpyafDNNjuOwpo/dYh7yYzxvsYOo1Fmtx7K/b
	gSr1pxyUcGirrKtIQVf+KuNAIqulMdU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sMi9NWdN;
	spf=pass (imf23.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1270f10a774so10231c88.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:45:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773848738; cv=none;
        d=google.com; s=arc-20240605;
        b=QBPqlH0B5b/EfJIa9YudJNc78ycM/dKCoheg5S+ZgP1uE+Gg2vtPPFCW0yQ8Z+z+SX
         qbLXiWJhYcJjSikbwmQyIiMAxbTjR0isSdZoImIsziBM1OO/STvOx/ACi1UcOtjcN9JT
         hq48J6F4IjYRdUhspzHbi4p2XFjqjLHg6+8dO5Pq27SeSwxX9ZHzmD/1ahYHQlsdmrDn
         mZ9T4NTFwJDGNrRcozc5QZpmjdV0U10Mq8NlEVi6O9r6hFuDXWQyYlfnxYdFAiuOoCOT
         IfZlafual0XjAWqEF+DuomJD0d+vC9nxrytcMzf3l3b8oJry1kbZYr6rQmjAYuV5iAmr
         BqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O6gmeMVPdTQy9BEMRG9Pt8pp3Mke6GzH6nH2NXf+FRA=;
        fh=GsWnPO3I4jhHjSvQaa8toAIma26oeI5U7+cul5k66NA=;
        b=NZ23/+al6qBjx+OT1AzwtoxoVvv+x/nvRld+5ghVFtS+hPa3VpbRDBji+InitE8rb3
         hWiugROryJCotM6qBA0fCHHzKQK6UFVeC64dylsrCksHWhP3DJ59wcODqnJDjhR/0jKz
         mE9LNMCRIFcrRBTUadPpZl7gv2bOpAOM9iXRTZu4UIJJBfpOt9Ca+byXAiLoDrFye9s1
         FGjcuXkHty+B3O/7ysRrhKIP/UZMr1d+9opGWNngXl5oTxi1cBrnBUm11hnuvOjdNSta
         vFA7THGqN2yf9EmL3ddXON1Q5+HP9TDAxLHG7SUcgqQa6gORp7S/dAVsPkcB2q6zo6mp
         fEFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773848738; x=1774453538; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O6gmeMVPdTQy9BEMRG9Pt8pp3Mke6GzH6nH2NXf+FRA=;
        b=sMi9NWdNT93dAeAVVNcRxF7F3ImQ7k1ZwCfea+9f8fG3deP1zd9BgDlQ3Emg7cfJoF
         YHcjDmboTJf9q+2Iz3bO7UQAOmCE3W6r4PlDtG7AFyh02bfa5yv9pwY/uhT+nmMEOwUu
         Mb1efzfgqHONBB20MabYIDfzfyxP+X1nE84U650V8fljvfHDWmKQpvgEg50HBaFotOdq
         S6YmWrBiaA4v5jMz66hmCOZqbNroIwO0WCmAG2GYc8mrJH7HtSlcLbFXF5C+orknDICI
         Rx6FxV6oZRebb7kpSq8HevYMj9OW/NVUSUh1D5yStrnADK/ZF3VrAQOFbaskm97qAH7y
         ijhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773848738; x=1774453538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O6gmeMVPdTQy9BEMRG9Pt8pp3Mke6GzH6nH2NXf+FRA=;
        b=gzKZ+WtMITeUaLehcR0PSQwi/r50kRmiJuxGL7YLvvEaWsGMxyUMtJsBaYM6mPn/Ow
         aNnDDk0eEtAXKQrxR9wmaJmAg7v5xoWY0rWlLt1cNRiz+kpOOJvqDKnwq2DODeis97rD
         cqQ1LsPY/GX4WvEINgPyFbCP6QTWMVHJAxcVGT6JFu6IMtBnIVcyrTSrQwp8VP5/gc07
         r4duSjnD9zAOOJ+ORxI88/mnruTsofwGa2iAbZ2FrrkLTOTuc+52m1X31jEvwnqZnE/w
         wiGBCn9N9I3Gldr5KVm7PPqIGx0lZ8EUDXH83IxK/Dkxh7nhiNNLDNdCiQTKug77TxbK
         3qmg==
X-Forwarded-Encrypted: i=1; AJvYcCVMiknDf08a11a/f+lObJmsc6fj4M5tYyKr3d5cvuBNSrgH6bjK2H/olwXWql9wQfVnbhibd105TQ==@kvack.org
X-Gm-Message-State: AOJu0Yw88+oGz0+TE7uVIBkxIw1wJNjFGJ/yaBNyB+z5M9NvohQpNvNg
	lHMtL4ITVTyUY/f0RE2hZGRe0u/o9UPP5EZFPUy+ftbYI7U4ziVSNzj9dGoTgDBeAYzV1dMICHI
	wFH+9ojVB0Xh9hCtwrxpRRMAlP6AtxjhKsCkvpnsC
X-Gm-Gg: ATEYQzz9RGr4Y8cXWVvzxJKetk0pqv9l0QPsU0+ykopHZVTegSp+lvt1VRm8LTrqqEQ
	ftU6pBgFTQ+24meL0LCjGjHhaisxrUaEwlG44Wc+CbWeSUOy710ptfOa1YD+C4IvUn0LnUMpNcu
	bbqQld6aVC+3N3yAvKRaOuesBlUPuTLn+CNSw1ph2qMBgek0j6kjqHz3B2PDWdlA4XojnHXTKe3
	Wlo3dX4/JJP294Y0koOSy4cQokW7xcyG5A6CSS2SFdS38KitIEsPXR561kF+liGRBfYnkSrWLXl
	2PtNKw==
X-Received: by 2002:a05:7022:158d:b0:120:5719:624e with SMTP id
 a92af1059eb24-12a11f010acmr183038c88.21.1773848737286; Wed, 18 Mar 2026
 08:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com> <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com> <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
In-Reply-To: <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 18 Mar 2026 16:45:25 +0100
X-Gm-Features: AaiRm51mIhUJpu9fr7jrOrLMxLU9hXk7UnvNj60zpy5QVyfWqaaH2yeHe6cwuAQ
Message-ID: <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
To: Zi Yan <ziy@nvidia.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uctgw41hb6xjq3iqhsajpsrg5531x7wp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F410140009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773848739-591498
X-HE-Meta: U2FsdGVkX1/kckgV2voHNy409C3kySzc5AvwEbAAhOBBjH4gDbc4IcwpiNER+nDyj2EagzND9xMTLGrEkCK9KYuvusi82mo3lCKBnrL2yB+QhxzrmMDgW0iqN0X37OTlB9nC+q7CWN/cdUfLEB/Y880hldwEUFwvZEaGZQv3nvnx++zmAoqMIruV8CfhDkowMyr9Zw6LFVBUo0NCuzaZqZGy+JRYTnZySdS/moSFgEIbmiPx9xz0g9gmlBSvIVZ4tYihsrPdzZslIdWimWYeDmNezLrQdh9cUmzAro3RgfuT1cyVewA6o+D8+M+xnuXY65FP/js4BMTK9x8SeK4b7zzve1zuQ8wucewxQLUu2pBjbvAEgEx1HSfYd7CJr2udpeyGCbfnRW5pNdsdGB+vwte9ZA1BMxaiM9ceN5Lzmxjseio6JEY7oqdgNYabZparbVuye6NxOBQ7I5rrqAI2QD2Jo30QHKX47QMJQ66S0GGr1IoFTDJWy7VTqppT0hXokNWqcFrSoolwGhB79xJwaaxns61FGabHN8Ai1iAjqa6RNmRA+CiyIho+F6NeNl/catf8j/rnktZ4eYvI5MEb9jyjj/jRfCsZrRjpXP3GT32xCAeRz7p5p0xsibTDQ50W35dy7jooK/qciIDP6JaaroovAjUmp2kvPnbrIkfngDMEcSRm42M8mU9kxjFo1vZ0zVtV1jAXOHbh96LM/qhLaz7c1q+vs71C7Oa7azF/EPWi4jT/3pAE/U1rG67496AMHPZEAYH8w02knrYl8uaB1u39Fumh/DXrMqRx5JGBGQGwSMy2Ejxu4PyGk+b/qXakEg+8JWicN2BYDwqW7af22ZaNfQ5jr+60NQYGX8Har4YQKCGMmhd/GAhUexx1YKpyAG5ayOa3g+wMyVnPMVw0xDTH1h+EVeg/z0t532PwLQyFKTagJKtZEWhHZuRGjPFNRFq0a3LTAU/tDV1BZbd
 0tii5ksx
 NyYOOrY7vc1Qc5MAttoTlXzSdpR7WyFj+vEGIzQnl29bcTyGXfEVziwqG55tGEjsD7SY3Y3cu/Vr6wH81uu+bM2eijvS/wssf/tzr9vB73JU5NKYB4RzWxjw/idPb32+i8hRR9TyIcNXUG9UeguwOk8bZWQUFi2ynBCscZE0EoFzz0tM/5J8KawnxI+yGc5MzxRXjcxb753Sq0xuLBUCQZxXTBWZyWFNLIlhb26HPxyJzioyj15es50oGfYcYe2W1Wp478ktpC876eLqoGA497wXGaljVllG+uY6k3/V/OvDT2XEMydU4nPwrMgmTXjqA0Oxf3r8pNonUTdPN8WFmKaShJ0w2EN/MfJKb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 4:26=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 18 Mar 2026, at 11:18, Micha=C5=82 C=C5=82api=C5=84ski wrote:
>
> > On Wed, Mar 18, 2026 at 4:10=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 17 Mar 2026, at 10:15, Michal Clapinski wrote:
> >>
> >>> Currently, if DEFERRED is enabled, kho_release_scratch will initializ=
e
> >>> the struct pages and set migratetype of kho scratch. Unless the whole
> >>> scratch fit below first_deferred_pfn, some of that will be overwritte=
n
> >>> either by deferred_init_pages or memmap_init_reserved_pages.
> >>>
> >>> To fix it, I modified kho_release_scratch to only set the migratetype
> >>> on already initialized pages. Then, modified init_pageblock_migratety=
pe
> >>> to set the migratetype to CMA if the page is located inside scratch.
> >>>
> >>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> >>> ---
> >>>  include/linux/memblock.h           |  2 --
> >>>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
> >>>  mm/memblock.c                      | 22 ----------------------
> >>>  mm/page_alloc.c                    |  7 +++++++
> >>>  4 files changed, 13 insertions(+), 28 deletions(-)
> >>>
> >>
> >> <snip>
> >>
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index ee81f5c67c18..5ca078dde61d 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -55,6 +55,7 @@
> >>>  #include <linux/cacheinfo.h>
> >>>  #include <linux/pgalloc_tag.h>
> >>>  #include <linux/mmzone_lock.h>
> >>> +#include <linux/kexec_handover.h>
> >>>  #include <asm/div64.h>
> >>>  #include "internal.h"
> >>>  #include "shuffle.h"
> >>> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct=
 page *page,
> >>>                    migratetype < MIGRATE_PCPTYPES))
> >>>               migratetype =3D MIGRATE_UNMOVABLE;
> >>>
> >>> +     /*
> >>> +      * Mark KHO scratch as CMA so no unmovable allocations are made=
 there.
> >>> +      */
> >>> +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)=
))
> >>> +             migratetype =3D MIGRATE_CMA;
> >>> +
> >>
> >> If this is only for deferred init code, why not put it in deferred_fre=
e_pages()?
> >> Otherwise, all init_pageblock_migratetype() callers need to pay the pe=
nalty
> >> of traversing kho_scratch array.
> >
> > Because reserve_bootmem_region() doesn't call deferred_free_pages().
> > So I would also have to modify it.
> >
> > And the early initialization won't pay the penalty of traversing the
> > kho_scratch array, since then kho_scratch is NULL.
>
> How about hugetlb_bootmem_init_migratetype(), init_cma_pageblock(),
> init_cma_reserved_pageblock(), __init_page_from_nid(), memmap_init_range(=
),
> __init_zone_device_page()?
>
> 1. are they having any PFN range overlapping with kho?
> 2. is kho_scratch NULL for them?
>
> 1 tells us whether putting code in init_pageblock_migratetype() could sav=
e
> the hassle of changing all above locations.
> 2 tells us how many callers are affected by traversing kho_scratch.

I could try answering those questions but

1. I'm new to this and I'm not sure how correct the answers will be.

2. If you're not using CONFIG_KEXEC_HANDOVER, the performance penalty
will be zero.
If you are using it, currently you have to disable
CONFIG_DEFERRED_STRUCT_PAGE_INIT and the performance hit from this is
far, far greater. This solution saves 0.5s on my setup (100GB of
memory). We can always improve the performance further in the future.

> Thanks.
>
> Best Regards,
> Yan, Zi

