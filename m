Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3DECED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C76B8E0005; Tue, 18 Nov 2025 00:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078498E0002; Tue, 18 Nov 2025 00:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81D08E0005; Tue, 18 Nov 2025 00:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D02B08E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:13:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 786DFB8A68
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:13:08 +0000 (UTC)
X-FDA: 84122558856.11.D9FAEB1
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 74D0B2000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:13:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GcpZIns2;
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3WlC2F/ZYjE5MyciXjRSRLSaVo0EtUipR3IBE4sFQo=;
	b=cqJ6srChrsl88gbdm91tUl1nE84jlIry0WGXs3xhU1Prgbzw4NH+yLhxShNg29mmwRoqtm
	KjDwDrre9MNTREFClxRftk401+YBv1MCROTDGp24VWoB0pTb8R/m0lbS95PZNpgCiT/DoS
	VMpVsJF+D3+zst85hIUVc8WNCODTf+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442786; a=rsa-sha256;
	cv=none;
	b=yO3GmTU2KUr6SGeQShsz8u+6bRdWP7yjwnHgdCx2gy/Ouv/7rFCgbftHmOUGfvlB5X64ar
	zzhsz/l6l3gtviPYFh16cy6hr2ZT+bUxUhms7wVsTZQs3w6v3KPALjl0lbTfdPMEn50AVK
	XAwPwTUU730sjbdcfVGiCZCyhRHwbJU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GcpZIns2;
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso32945e9.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763442785; x=1764047585; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3WlC2F/ZYjE5MyciXjRSRLSaVo0EtUipR3IBE4sFQo=;
        b=GcpZIns2DQHmwSOkXirxRaULia0/93wp8+LLjySe2eMpkZusBtjRYJoergq5RfbsKx
         Tv8kEB4fueS4VSlUMCn0gmC4WTfxXAuKcg0EI8qmB1abY9byXO8RUj8mEvCSUxtcz+pB
         ZHRHL0XfH1s9P3Qmb/vzykCxnggG5UMOhXMwAu0u9GFUSV1U2kKeGKt5VIPrTp23P4on
         jLJsPRB5bLqPwaM2FU6/Zqnw32QplwMtxn78XF6OVQH08C4SRnpJle2aarHVUqvaPdB9
         xZr7Xa2wEd/GkDxs6v6d3ZOSoJB+aPTadWMBT+1yGPLhlGTX/BbqHObuhgrmaKzCjv+X
         o7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763442785; x=1764047585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L3WlC2F/ZYjE5MyciXjRSRLSaVo0EtUipR3IBE4sFQo=;
        b=fbBESRaQyy5Tso+6u5fvy2mDHHZdp5uVdHZ/RLRF6wBlPcIv+9RwpkKfyiLO3sDEBL
         jC0HZjUTAfWEw2e8yLJ5f1e9kByjzGFCjE02SbsrhFD6BX1UNCreWRQwkNERxwXvG5xa
         2rRVEDMXgqs1WoAlsyuYhHvm3WeBunA3UqlRw6kItGLILc890eybzlXZDhM4cgYR0NH4
         Sid6XwZE7lefsoCFYK+Z0ONUw2CbmINYDPpZUUB1BNKidVSVhLLCF0FYNaFXHTAHBM30
         YuDF3YNQ+x3fY9GJAmH+w2OztwEr2vU7riNEFYwhJqL3+k/r9RS9pqGvy3YQAoqnfL7n
         cXRg==
X-Forwarded-Encrypted: i=1; AJvYcCVTs8ub61+2+myUpc2tPcpt4chWoDIR6ARy7qsbeK9NpBa1sZfulwDtnjWNYRus7Z5/E9nFl9sehA==@kvack.org
X-Gm-Message-State: AOJu0YztXBdVDzOKnbtCYXcK9FJ0aSJbcJguPl7/8rEM6U3Sv2Fx1O//
	lAL6CUXUYgDk3TMsrB1FUmnp44oAVT5olwJwkUgQsvvUI17ABL2Pg8Bv13eBH+qDOza3NDIFQQu
	jhgBYg2iFBDWK098X1z54XY73T6zGY8RBGeb9Vo6FcOR/P7frVakHyCUj
X-Gm-Gg: ASbGnctQ4xm2DiueI29hdFJCYMVJBj4qpc2IeFBe8nSWhgo/YrD+t4FwhJMCb0JO86/
	CWfEhBiFnOP9NFY88YggNwPle+rJMKfhVSOcLGqq2bp7qNdy9YWduiL+Arl9ZbWUgvmCTj3S4hy
	IF+J9B+6ZPlLztkSe7N7q/xHYK4r03fcHG7Lug+8pqy+A4ZwfwmzK5jQ7h+gO6kAX/qoad+TKNG
	LmRwdHOUr/r2rWK7WVS2JH5MWDtMWWwKR8OXmDyLjMBE9fEd8oqeyOgXbcNS7NSOGj1A5hB91ZR
	/PeuhyFZ+6fL6h5//qBbH/fiG40p
X-Google-Smtp-Source: AGHT+IG7a+W56pa5px8Ke5ySaRypEp+/UIHTLNYMdTRbHZTR0wZ3pySD5fRRpgk4iVmEKxs03t0cwIuHrLmqaNeLZKE=
X-Received: by 2002:a7b:ca53:0:b0:477:86fd:fb19 with SMTP id
 5b1f17b1804b1-477ad06fc15mr5655e9.9.1763442784600; Mon, 17 Nov 2025 21:13:04
 -0800 (PST)
MIME-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com> <20251116014721.1561456-3-jiaqiyan@google.com>
 <CD886E34-9126-4B34-93B2-3DFBDAC4C454@nvidia.com>
In-Reply-To: <CD886E34-9126-4B34-93B2-3DFBDAC4C454@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 17 Nov 2025 21:12:53 -0800
X-Gm-Features: AWmQ_bn4yLVuQDw4Ux8NVwahCGaKHuF98rPNAY5nKN0RpM3KQoxIzo5zKkLBmPk
Message-ID: <CACw3F50aVFoeaEnTptvq+qjVibupM1e8XJUeU2W_y-JMzJx1iw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory-failure: avoid free HWPoison high-order folio
To: Zi Yan <ziy@nvidia.com>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yt67n6k4u344ow1rinwyp9mf8msbisc5
X-Rspam-User: 
X-Rspamd-Queue-Id: 74D0B2000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763442786-251211
X-HE-Meta: U2FsdGVkX18S7uw7aDjmhielLL72pPiZb3ByO2o+/ow/ZRkPQ+2CsTggM1iUVWYwG1BLCet1ds20jKR3ws98DTRC7t99PiRuVhqEN37AQX6lkQ0PNTYQzHCc6lkUWXlGjtQgpvhPIPNWh8Qdca6gbxwTIKYu1nVlr+Ktv1xXakzT3GmKtc3N6UIgbp/tAsnnyHsfBclCza3KgsS05jjRQhn8juv/zNHRhoLZQcWq6qdfELcYUDn2fIc1iczmCD5U7FiNbQBQ4pEFMLCgImFU1gOlKfJ+0UL562dLreYN6iqEuTzmSX5Ca25nJWGosCfBfeGSVy4UsFiPWEGvVsS769FcEgpVRQIZVXCsVmKnZTR+ySb1Zmp6hMp+o40Nwk/zyqGBRwJrIGulDaqzkioXUXQYyy/qf6zwjNjkbRT87W1/G/QvLj1cAe+oVf82keek5Ank1WoL3uVmPRSqHyoOna90UxtnBntyXLK3rtRbdPXu332rbKCt41dUl0C7CcRyeadGC3dgx8udPfALvV/5jUQL+ymc9nNWQkd3IWrHKGFtmx4Kg1+GYZhGzO3LdHjI2Whg6HCVoNbTjavcbR/hH79H3B1x1Y5JyhqGQVjQfzChCyRjde2PpSB0dQAfOCapoqSXUDk+zKij5FQymT2CKz66/yI7DA7JDs/lMtJPTRIvbLhuVG3Xy+rj9X+HCKX/jlJsxQxOfrFagnN9bgWbCDdYREkNm2S/BfiRk3kzW5AQ8Tz9OFUPnahUAUT3loVVKSueugpObFxd2o6lU1U4ye+Tq6LHTYNBqnQEccSUYfe+4XdvNUUSE6UVrdtWmArtnMuXEKCyjcEcjyh0XEsrYXdqfTnfwEfyG1SOZ/NroKR9oWg+tF9Sx9L9t+hcMw3NGPNP/X3rbsIuKPIN5n87e6r/CikmorZXHvrFKx1qkaItGjVfiI6NFFtnBm2N7w3l5u99+JVecBmopKPeFO8
 TEONtTmH
 3z39/2xzfggNL4XW4PwqMQUiQU6pgCnzKBMMeAD4Yy7ue1YJWcU2FL7Jm1SBDBtMiYcXhazxlJBnjU7gg//nmG36K5I1ZPYCdd97YN4jfphTLau7RNUb7xAlNidGWrUhClhIXC0hT6Cy5eDOKimJjKWAjTUa5YKejWpuH59F7wQvLPMcJPy6nsif0MzIa2OgmyipA5RQc7RuHO6Z8pnXloZYervGf1wjNR0yeA151WqOrH7B8sd3lClhrRbB+a7dshG41n5wr74vO0P9O1fLFm1/TGsF7kAkUr21kRgecKLiTJ4q4W8Jshl/KIY+wBPMHKwByDeeflW3NqPXtYaaWutj8hELkF4gkDnpf0Av3/Av96X3Bg/gTCI2VRMVU04SdW5skxzNkA1OX81PbdT7kE5qphj3mpW9kO7iM7jHbQIdE7gZBSPE2HmSMa3Ty1dWriDs9jo8moNr++YsTVvvqmskzIg5WFi6bTrkp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 6:10=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 15 Nov 2025, at 20:47, Jiaqi Yan wrote:
>
> > At the end of dissolve_free_hugetlb_folio, when a free HugeTLB
> > folio becomes non-HugeTLB, it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio. However, there is always a time
> > window between freed to buddy allocator and taken off from
> > buddy allocator.
> >
> > One obvious way to avoid this problem is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce hugetlb_free_hwpoison_folio to solve this problem.
> > The idea is, in case a HugeTLB folio for sure contains HWPoison
> > page(s), first split the non-HugeTLB high-order folio uniformly
> > into 0-order folios, then let healthy pages join the buddy
> > allocator while reject the HWPoison ones.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net/
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net/
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  include/linux/hugetlb.h |  4 ++++
> >  mm/hugetlb.c            |  8 ++++++--
> >  mm/memory-failure.c     | 43 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 53 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 8e63e46b8e1f0..e1c334a7db2fe 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -870,8 +870,12 @@ int dissolve_free_hugetlb_folios(unsigned long sta=
rt_pfn,
> >                                   unsigned long end_pfn);
> >
> >  #ifdef CONFIG_MEMORY_FAILURE
> > +extern void hugetlb_free_hwpoison_folio(struct folio *folio);
> >  extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
> >  #else
> > +static inline void hugetlb_free_hwpoison_folio(struct folio *folio)
> > +{
> > +}
> >  static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
> >  {
> >  }
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 0455119716ec0..801ca1a14c0f0 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1596,6 +1596,7 @@ static void __update_and_free_hugetlb_folio(struc=
t hstate *h,
> >                                               struct folio *folio)
> >  {
> >       bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(folio);
> > +     bool has_hwpoison =3D folio_test_hwpoison(folio);
> >
> >       if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> >               return;
> > @@ -1638,12 +1639,15 @@ static void __update_and_free_hugetlb_folio(str=
uct hstate *h,
> >        * Move PageHWPoison flag from head page to the raw error pages,
> >        * which makes any healthy subpages reusable.
> >        */
> > -     if (unlikely(folio_test_hwpoison(folio)))
> > +     if (unlikely(has_hwpoison))
> >               folio_clear_hugetlb_hwpoison(folio);
> >
> >       folio_ref_unfreeze(folio, 1);
> >
> > -     hugetlb_free_folio(folio);
> > +     if (unlikely(has_hwpoison))
> > +             hugetlb_free_hwpoison_folio(folio);
> > +     else
> > +             hugetlb_free_folio(folio);
> >  }
> >
> >  /*
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 3edebb0cda30b..e6a9deba6292a 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2002,6 +2002,49 @@ int __get_huge_page_for_hwpoison(unsigned long p=
fn, int flags,
> >       return ret;
> >  }
> >
> > +void hugetlb_free_hwpoison_folio(struct folio *folio)
> > +{
> > +     struct folio *curr, *next;
> > +     struct folio *end_folio =3D folio_next(folio);
> > +     int ret;
> > +
> > +     VM_WARN_ON_FOLIO(folio_ref_count(folio) !=3D 1, folio);
> > +
> > +     ret =3D uniform_split_unmapped_folio_to_zero_order(folio);
>
> I realize that __split_unmapped_folio() is a wrong name and causes confus=
ion.
> It should be __split_frozen_folio(), since when you look at its current
> call site, it is called after the folio is frozen. There probably
> should be a check in __split_unmapped_folio() to make sure the folio is f=
rozen.
>
> Is it possible to change hugetlb_free_hwpoison_folio() so that it
> can be called before folio_ref_unfreeze(folio, 1)? In this way,
> __split_unmapped_folio() is called at frozen folios.
>
> You can add a preparation patch to rename __split_unmapped_folio() to
> __split_frozen_folio() and add
> VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio) !=3D 0, folio) to the functi=
on.
>

FWIW, I am going to still follow your suggestion to improve code
healthiness or readability :)

> Thanks.

Thanks, Zi!

>
> > +     if (ret) {
> > +             /*
> > +              * In case of split failure, none of the pages in folio
> > +              * will be freed to buddy allocator.
> > +              */
> > +             pr_err("%#lx: failed to split free %d-order folio with HW=
Poison page(s): %d\n",
> > +                    folio_pfn(folio), folio_order(folio), ret);
> > +             return;
> > +     }
> > +
> > +     /* Expect 1st folio's refcount=3D=3D1, and other's refcount=3D=3D=
0. */
> > +     for (curr =3D folio; curr !=3D end_folio; curr =3D next) {
> > +             next =3D folio_next(curr);
> > +
> > +             VM_WARN_ON_FOLIO(folio_order(curr), curr);
> > +
> > +             if (PageHWPoison(&curr->page)) {
> > +                     if (curr !=3D folio)
> > +                             folio_ref_inc(curr);
> > +
> > +                     VM_WARN_ON_FOLIO(folio_ref_count(curr) !=3D 1, cu=
rr);
> > +                     pr_warn("%#lx: prevented freeing HWPoison page\n"=
,
> > +                             folio_pfn(curr));
> > +                     continue;
> > +             }
> > +
> > +             if (curr =3D=3D folio)
> > +                     folio_ref_dec(curr);
> > +
> > +             VM_WARN_ON_FOLIO(folio_ref_count(curr), curr);
> > +             free_frozen_pages(&curr->page, folio_order(curr));
> > +     }
> > +}
> > +
> >  /*
> >   * Taking refcount of hugetlb pages needs extra care about race condit=
ions
> >   * with basic operations like hugepage allocation/free/demotion.
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
>
>
> --
> Best Regards,
> Yan, Zi

