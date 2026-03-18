Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B004C107BCF2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2336C6B0162; Wed, 18 Mar 2026 06:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A626B0164; Wed, 18 Mar 2026 06:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9926B0165; Wed, 18 Mar 2026 06:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B2D6B0162
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:33:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F29513B4DF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:33:25 +0000 (UTC)
X-FDA: 84558821970.08.754EBDE
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 92DB840010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:33:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a0n9zBmm;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773830003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1YwBcD7XlNYfw4PFQzrHzcpcYPaaxw4aJMR4YVcRA4=;
	b=3YV3RD82QannDD9Vr0FM1LxQ6VxqhXRqSjKHjX6zFEffNctDGENi4Z0bdK5Iu4e7QMdEzL
	qu6j9P06+iODmCba5GMwpZ1se46Wdfwwf2+2hXtpFVQ8aXeUYSNU/3mkGV+IXB36BTYQJl
	QZOko+A5eAmsHJHXZnEDAsMmeuvEmdk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773830003; a=rsa-sha256;
	cv=pass;
	b=Np+uwW3SmuD1vdPNupK7+A3kF8zzL0DHB8h14vz5OcsjecgtvZ2+WLAsWR7kGrm+3oUi8a
	KJ5YfjdqEA1VT4FV4Nt2qA5eHqG/1FwOiYDO+XrvFEoKgH0kiObiCAM5f5KfUI5JP1eRWe
	zBVm2Hm3eHQBrBdP8WiGhA72/a2f+nw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a0n9zBmm;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-128ce536fe0so9383c88.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:33:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773830002; cv=none;
        d=google.com; s=arc-20240605;
        b=GaRVHaBM/Dy3y0a4RzJL/ZAuaNEdfPdslycaIUJ2MvW2gfk96SMrVGJ2WQuREOumZv
         WCD+fFtej91klVAdGpvQ7UnO2oVYJsxYXzovCFMxJmHSGeKjFB7/xBsiwkEzY/dl4hxc
         yj4I6CxXPGdUgeoTWzC4pwImfQz1JzYN3FVGM9/kEDiEBS+H9zsAzepax40H1AcwzHDq
         uSvCOHpNTQDCzv32iif084lLXgQYQ1ioPBF8up2KmncGgfL9ihvq7wMxtBOvqs2OM5Yy
         +Ot2ejzRmckdqxh0FEnddIMEww7l8258tpNJ0ByztbWlV4rIwiL1oYgSSrp7lBYOSimK
         LMHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h1YwBcD7XlNYfw4PFQzrHzcpcYPaaxw4aJMR4YVcRA4=;
        fh=uDkBClrt11L7AvQpW5jr2FNhoRUZdTK8hDDuDnNVEUk=;
        b=iiH+zru7GtrscS14uatTVHaFvxtu44xtZZqRlAErOnuSPcDpndS/yBLCsPFecVD7Fq
         wjlssj5OyoThP++Myv/QxO/lfKqWuH8ZktHxINcCmGuH9OI9A5tG5ImPx+WXse6PE8Eo
         7Z2WWBWq0pnRd1lx3j0TDfpQyoRwEJXfLrX6G9fKNFPFh3s0lHL55fU4wbakJePmDDiH
         AyfSrC3LD6TYTAE/dh88on1PC0DKlMbpz8HxmUVnOjzUXB0mvq8fj0gp8v7etRf83YPP
         OS+xh/HswR7dAxWBMsgHIGhJ5uA4oxt2uWtbMX/mtgCwwwgPjtI6n9ulIb2zu9FxNhSL
         VY4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773830002; x=1774434802; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1YwBcD7XlNYfw4PFQzrHzcpcYPaaxw4aJMR4YVcRA4=;
        b=a0n9zBmm+Nsb5x3w/ho/l8Vl1+sha1SZM7a8Keg1pmwhns15XOmpZQ82U7UAwaOmii
         baZhTVzQunpL237YW3rBWofotE7SBNvdvNTQUUo1Tvn4ZyM7ABVJdfEBk8Ll6lGSj0lA
         xlUmBsJ3xEAzzAQgwZ3JG5zLIlVeSEYHByysMLWUE5AWSVRzwkk0ewtH1BtPrrmrw9ac
         8jCFIpFiwOw02TW60skedQVz+kytrnXusztsCN/QIrlQMk7uHJUdikxE0gWcRi8akLER
         CdJzoV2VYT+DJM+vvYTSDdfsRmSRuD6GFdawj+bP5nWG7dePAuaA/YMUBxlSAuvp8u6K
         AabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773830002; x=1774434802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h1YwBcD7XlNYfw4PFQzrHzcpcYPaaxw4aJMR4YVcRA4=;
        b=s2THX7DTVuIAZLNZC2ywItFhlEPYhoH4q3AucRsvglICdkz26BWEpXclNr11cZ93up
         3AcvGx2RPjy5sFncjb+xtdxEhtLwQ56c7tmMH32gkeyGmLJ0FnbEJEOdPRL35O/ZG1rD
         pcn/poK5U0Djv9//8DNoZw6yFCUNMLbGSh5r38fDaAkF9iItixhvK24G7Wzpipa60HiE
         CB5+Sjb9EzV/ZlI4DBEcxm60W9WYmuo/Ixmlmri0Ll3dH1b1xxYU5RvEGdH904A+/1GQ
         mLiXRXM8kJ5Qn0E5pU0wqa6oH1hex9AOMgQQDN66bRfKJ3CXLJA+fDnOXTV/Ji0nqIxM
         7hCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmhksoAh/1mLX2ETPSSm6Nu6nbT+/RkY7GvRUDdTwZXqdmL3aVToHJIP6+GObK2W2gptsBHaD96Q==@kvack.org
X-Gm-Message-State: AOJu0Yy/AwYB1PY8lDHn97jbynef2+zJgxDjO09xOHL1+nru3nS/crMg
	Pcl/UHiZXfXGny19b+CYLa5SDKbZlxWy49NEJ7QM8SW2ppx33sEHErv8m217ktGo/voZh1ZDRhT
	1oZH9HoAyXVH2JVdZFPEmGEOPtR+7jYerMASd72zH
X-Gm-Gg: ATEYQzyWpyyYuiv6g9llV0Gq8bpZzCujWehN+ONjHj7SL+oW8p57bk1ADqDJXE1n82d
	4VELMCVeeFQ2awAIRvb3OQKnRQCoCZbtp80gmgBxIhOdagsVZ6NrCfiVWr9WaVPPIgAw6SB5Tqu
	Kmw+spW1XK1+UBoVP8KZW9Tn6k42n8dDNe1qFYvNbYdzC4e6mlIEep1GaH3VhysCbjIKDcUAA9g
	DiMlc8Bfkp+mOTc3aCiqZAu/bb+Vsk+duKr6fIpoaFiLPXgmm/THC9RqOmehO3He73p7+ENXNVF
	yh5Vig==
X-Received: by 2002:a05:7022:3a83:b0:128:def1:f77f with SMTP id
 a92af1059eb24-129c5927900mr173162c88.20.1773830001815; Wed, 18 Mar 2026
 03:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com> <abpxUEijdHJzziEV@kernel.org>
In-Reply-To: <abpxUEijdHJzziEV@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 18 Mar 2026 11:33:09 +0100
X-Gm-Features: AaiRm51MWIfBPmVPLB2qYcQk0b3M6X8XFd5NBfBzpi7jH-NiRIi6OxA361n9fs0
Message-ID: <CAAi7L5e9GxgvGTFvPfcn81Ve59N-K-o7FOh+Y8qKHwpuCYycCw@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: e8e56184mumh5tife1aat4okaj933mfq
X-Rspamd-Queue-Id: 92DB840010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773830003-902415
X-HE-Meta: U2FsdGVkX1/EEIo6+aNOe2060Hx9tFB/bV2TqU8D9+It6gp2lcJmItD1ujmjm5f3VA3jCbQ4U9Z22oqyNRA0rmwk8SQdSHQG+iDeYgEaFRUp5bD0JuUtMa3PmW5N9XiGGxrvawccMbEKm/dtzStX1UIJqRgr0fYwy2wjNhUVOy1kTJ4+gZ6uhBNgpoSnsWbga/6OQ2hgnw5otnWmBq+KGiiWauiG/eWhntA4DInvrFZK5BZ6S7PwpHnRRGYxeC+9FTYKuCqzOdHsTq+l6YWwGyn6VwsdNys4BwBt8l4fM/y/tfKGgyS6ZV3vqlz1y8dZt3iHWGgH5L0F0EI+2Co0cda2gLO1VC2BJ14YnhUYviEDWHW0t3F5HLwToAx1444mdaSkqkxzBusBZK3B9xsNHythU/eJU1ZAO/fcgDEV591bqgqE7gwRVPATBj0A/euAvgnAFyw1fJ0aaKPPKbruBCScVxHtNKrtS2c0tzHRqCuTTtCLf//S5BrbN3kdMdSIqgkCMOgmq8aZgynyTfie7UxI7Adk0gPSOEAEnJNq0tDWOnBfMTaQvWN5vRqcgEMegzJiMQsMNmALmfWtJPPnxrGYgVhF8cnFiQTFfZYPq8LHew7hLFuZC0OBDnmslQNkxnHf/JrzsTCq76WFtcmaaEkjmoobkJSRObIepX9HVlMER7OjW68pFOAj1kyx0i3ipmbDV2+tIu7yiw8pZsLFPd9OC/E1sBBICfM72+ebfDA9s7kfeyvSinP6eeF1JXDK1yC+45B3nkmC8ljYNOmyyDikOqToCTtTTgkb8f/FDbHkPkam3lEu7VCzY1GtyeONN0gRVsJx6cpjkSJ3ePZW+TMdhieFWXPndkPDl4IrLWtGjBl/jsuR4QrtXblCTU/JFldOnFlVqimg5WkZPXJW8KQiJSqVsWEKsmAH4MbyebSd3SQAL/+4pchEGk5a/3ua+l4JFr4YbEYa/+9S+AE
 TzAj5bBY
 p4hrfdl6Ds6+NWavrwd2dPLjabpW6lwyTDOsCSRE/VJH6c2crT0Km4rNDPikjvWF2b+iiFZZ+UvrAHPF8aZUhWP+6tdq/LFpJhGNlLsAs0vphj3npMjA1/40yQlDi/pTcsaj1p8aJhWhQnXi2aEb0MnMuxMBGHKmKxJMT4S9NB5cyFJNAhJ/1+rfT8nAbECLl44Dtm5/XAt7ZXqF8N3xjh/nHHPorC1DaNYfE1hDOo5ldxkdmVpXBsW1fPknWEqFrVrAo3YCrZ7Lb2AsaTcI/4qydpxNVAaQ0uYSh/ePigEtRtIh44MZ7Jg2y5vyH5My5LTWs+zZr+J3Lfxskga7qJDr30vCzioM0GY1CgyygZTXjBrZSx13+DAqU2PYDmK85XbSj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:33=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> Hi Michal,
>
> On Tue, Mar 17, 2026 at 03:15:33PM +0100, Michal Clapinski wrote:
> > Currently, if DEFERRED is enabled, kho_release_scratch will initialize
>
> Please spell out CONFIG_DEFERRED_STRUCT_PAGE_INIT
>
> > the struct pages and set migratetype of kho scratch. Unless the whole
> > scratch fit below first_deferred_pfn, some of that will be overwritten
> > either by deferred_init_pages or memmap_init_reserved_pages.
>
> Usually we put brackets after function names to make them more visible.
>
> > To fix it, I modified kho_release_scratch to only set the migratetype
>
> Prefer an imperative mood please, e.g. "To fix it, modify
> kho_release_scratch() ..."
>
> > on already initialized pages. Then, modified init_pageblock_migratetype
> > to set the migratetype to CMA if the page is located inside scratch.
> >
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > ---
> >  include/linux/memblock.h           |  2 --
> >  kernel/liveupdate/kexec_handover.c | 10 ++++++----
> >  mm/memblock.c                      | 22 ----------------------
> >  mm/page_alloc.c                    |  7 +++++++
> >  4 files changed, 13 insertions(+), 28 deletions(-)
> >
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index 6ec5e9ac0699..3e217414e12d 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct s=
eq_file *m) { }
> >  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> >  void memblock_set_kho_scratch_only(void);
> >  void memblock_clear_kho_scratch_only(void);
> > -void memmap_init_kho_scratch_pages(void);
> >  #else
> >  static inline void memblock_set_kho_scratch_only(void) { }
> >  static inline void memblock_clear_kho_scratch_only(void) { }
> > -static inline void memmap_init_kho_scratch_pages(void) {}
> >  #endif
> >
> >  #endif /* _LINUX_MEMBLOCK_H */
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index c9b982372d6e..e511a50fab9c 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -1477,8 +1477,7 @@ static void __init kho_release_scratch(void)
> >  {
> >       phys_addr_t start, end;
> >       u64 i;
> > -
> > -     memmap_init_kho_scratch_pages();
> > +     int nid;
> >
> >       /*
> >        * Mark scratch mem as CMA before we return it. That way we
> > @@ -1486,10 +1485,13 @@ static void __init kho_release_scratch(void)
> >        * we can reuse it as scratch memory again later.
> >        */
> >       __for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> > -                          MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> > +                          MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> >               ulong start_pfn =3D pageblock_start_pfn(PFN_DOWN(start));
> >               ulong end_pfn =3D pageblock_align(PFN_UP(end));
> >               ulong pfn;
> > +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> > +             end_pfn =3D min(end_pfn, NODE_DATA(nid)->first_deferred_p=
fn);
> > +#endif
>
> A helper that returns first_deferred_pfn or ULONG_MAX might be beeter
> looking.
>
> >
> >               for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D pageblock=
_nr_pages)
> >                       init_pageblock_migratetype(pfn_to_page(pfn),
> > @@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(void)
> >  void __init kho_memory_init(void)
> >  {
> >       if (kho_in.scratch_phys) {
> > -             kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
> >               kho_release_scratch();
> > +             kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
>
> Why this change is needed?

It's not necessary but kho_release_scratch() will call
kho_scratch_overlap(). If kho_scratch is NULL, kho_scratch_overlap()
will return early, making it slightly faster. Alternatively, I skip
invoking kho_scratch_overlap() if migratetype is already MIGRATE_CMA.
(resending this since the last email was html)

> >
> >               if (kho_mem_retrieve(kho_get_fdt()))
> >                       kho_in.fdt_phys =3D 0;
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index b3ddfdec7a80..ae6a5af46bd7 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
> >  {
> >       kho_scratch_only =3D false;
> >  }
> > -
> > -__init void memmap_init_kho_scratch_pages(void)
> > -{
> > -     phys_addr_t start, end;
> > -     unsigned long pfn;
> > -     int nid;
> > -     u64 i;
> > -
> > -     if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
> > -             return;
> > -
> > -     /*
> > -      * Initialize struct pages for free scratch memory.
> > -      * The struct pages for reserved scratch memory will be set up in
> > -      * reserve_bootmem_region()
> > -      */
> > -     __for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> > -                          MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> > -             for (pfn =3D PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
> > -                     init_deferred_page(pfn, nid);
> > -     }
> > -}
> >  #endif
> >
> >  /**
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index ee81f5c67c18..5ca078dde61d 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -55,6 +55,7 @@
> >  #include <linux/cacheinfo.h>
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/mmzone_lock.h>
> > +#include <linux/kexec_handover.h>
> >  #include <asm/div64.h>
> >  #include "internal.h"
> >  #include "shuffle.h"
> > @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct p=
age *page,
> >                    migratetype < MIGRATE_PCPTYPES))
> >               migratetype =3D MIGRATE_UNMOVABLE;
> >
> > +     /*
> > +      * Mark KHO scratch as CMA so no unmovable allocations are made t=
here.
> > +      */
> > +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> > +             migratetype =3D MIGRATE_CMA;
> > +
>
> Please pick SJ's fixup for the next respin :)
>
> >       flags =3D migratetype;
> >
> >  #ifdef CONFIG_MEMORY_ISOLATION
> > --
> > 2.53.0.851.ga537e3e6e9-goog
> >
>
> --
> Sincerely yours,
> Mike.

