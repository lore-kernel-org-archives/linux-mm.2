Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E19DD715C1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 05:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1FD6B058C; Sat, 24 Jan 2026 00:33:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C828F6B058E; Sat, 24 Jan 2026 00:33:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92BE6B058F; Sat, 24 Jan 2026 00:33:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0B326B058C
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 00:33:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C18588A4C
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:33:07 +0000 (UTC)
X-FDA: 84365738814.19.E7DD597
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DBD940004
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:33:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ipgyTR1b;
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769232785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69ficZS8wQSkubv49fT6hJg1WO9tCpEnE+aJ24mfEUI=;
	b=GwM6fxLLeVg0YTgJgLsYnY0GrRv0xCstRARktdeOH1W+wxSlJj300Q9Hzdx/s+Ca5Ayavv
	ADCK/kJns74AazgEJZAN6DWAUJeU47UouSnfK+IlG8ibz09dcNg1hAYPEx8wSrscgkf+aV
	x4MsnCPjFcOKJynKAymZ9bE3SdjObho=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ipgyTR1b;
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769232785; a=rsa-sha256;
	cv=pass;
	b=XWsx7dnm3E+VQSNCpoyydFOBpkSp1hmB0o+N9SpXzpzI31+IPPi3Q/NfgYKZxtCgh23Eu7
	5LsvIXnrseMAWsnkr6KdaSZSCzaK/aTMMG+I6UMbT+djcoXVOSSqSPBtKo4LTGxfARXpAv
	KXAyAvnpZ2fgRYvx+baQQJ3E73L7CFI=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47ee0a62115so32735e9.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 21:33:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769232784; cv=none;
        d=google.com; s=arc-20240605;
        b=lRI3GhneAJQjyGCEepHGZD6q9n33Sr0OT64+lEdKQxDlwiaT6cbGsBXl4gD/hP07lS
         7UhIIoNzdTnJyyVJPZdA+4XmNCs2OnMf86DevPmSY6mht3VblbYT9yvsQKoGE5fYKUYa
         LczMX88NlsCvEeheU7UCzsMzTZwphmlle/rluCVW5oxHwe6Lpj0VW4Wissp3v16EiXes
         IaShjkGvLjw74+dayFmjlzHo5QULcbLrOKGdmlLXbfuiy+LFnJ89wlpk6fv0rjOfiOyw
         e2ofoNt8bVV7ZFXBGnKTMKNC/tHvdUuhuwjFkrvrR3qUfbthL5Cl0LHK8uzCBu3rx4cc
         Bnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=69ficZS8wQSkubv49fT6hJg1WO9tCpEnE+aJ24mfEUI=;
        fh=m0HdoGcowdpPJM2VxY7L7ktcQCGRNo3l5MvTqiwCwPQ=;
        b=Cd8ioy3cgQktnaz6ChdhUGNgyKQsKGCGpPdBSqB19VhBL5Ga+65NoX3FgvbAh7OZDp
         cSddGb0C/K9ZC/9HYdeUFTasFK6jKbgvLQ8wBYQwoOLV/3Gjfr4BjC5hL3m/9f1tAHfa
         p8QXne310MXiG8KZIWeQNImwwvEuXYtkjnS93RDCsS9cH1ua2UlhOn158gzFW6VZSe5f
         fbMucB0mOvaXHuNw7FtwBP7rG5djw8V88zTB4bVvyyho6jxMknRWVuQRY0xN0p45YIwR
         fqD+oYr1ewDOKlKix5PlB1k0xgp2LmK/oE+kDIbYH0qWmiB/I3OIvhztfAT02EWdldUh
         XbRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769232784; x=1769837584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69ficZS8wQSkubv49fT6hJg1WO9tCpEnE+aJ24mfEUI=;
        b=ipgyTR1bTspkiF8qbz/qO23lF2hhOxp/+iL4kknLmI0EaQXQkqu/FUfxapkCr6+Nyb
         SRfxkswe88XfVyYYKuMyuVRc8pxN/96fo3hqiMu1JZ4mWvYIc4ywuiUrvQVK+ml5C79+
         mq1jiDjTrx2jcHc8SeEqUfhhWOd09vVxgiF1lNOEhiGJcPmn0u1GqBNHkIMvMizen6k+
         u7Qw/+2gxW3iw006EkRpkedSyUahvU1B1XU5zswaKzAKPDhJbsV17O6OD6oTxhlnraDe
         9/h0qIlVICuuoUXiB+DzMYMastrL+/lZBDhNJ8/KZIX60Xrrz87114RD5l97HSA3ezsh
         CMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769232784; x=1769837584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=69ficZS8wQSkubv49fT6hJg1WO9tCpEnE+aJ24mfEUI=;
        b=jh/x3cn1c7nxh6fb+KWeWXwuhxJ4ieMtFqC4TzGXXTyo625ClDN0A2TAcdc2icv8V0
         H06IQSi8K5afPQfA+xsax8TCLi5GUVfya6e0hfxydB+zp8EfIayYdoOMHCJUF/4IIb1n
         IFK3qbq6XTfBeNbiLbp/KyGwlG1q4gHPH9cl0W953QLouEBhBQzrODXNAaDWgv2c4uxp
         9lys8J4BthowreZ3MBD6EuSmFOHPEuwks6vLZLnef+oZILmYYPcPiG3BpkTxVAFFVOg2
         d1UClLjyDS+Wdw8sDzZTCUu9ZJvvR/xR3nmuFaKTGUh6Bu/2pW5WemtyrWlthMe+/LQD
         rCQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfUSAO+xC0TpnyDttXAE7fI4lz2YPW440Pc6X0WE11a9rPHrwBPD/iRDKFF53w0Ts9ECSZwefjqw==@kvack.org
X-Gm-Message-State: AOJu0Yzj9sHy9LRRVG4nxbSObklV87xLEZBi9oGa4znZYLpoYg/fwJin
	4uRPBfgu78oPlV1qksVK/QF+zy01wQzZ9dwfgrEp8X1wtenFVHczVZvDC61mEzNHuYv/jqAd609
	Bx3xHjL1sskhYZNgzCA7Sjh1m0kfTDSlF4WA9Hc2m
X-Gm-Gg: AZuq6aKO9E9HbsVvzMYQOGRVLzFvZM5HSCxSwBUWPsSm5fbYTJZpOTGR/2M8i25kDRX
	Abu3ky2a05POEUZ3yAxoQ7Q61O4XSQv52sE7xatHScObkTBR4CV2sMiqVT/kHsW0p+Zhmk7ubOw
	0qGr8rVY7v3dM+4hC5ZeKpOCk/U7/2+A3jGYMuf0Sxcd+YaG8yhGU7RkKL2INBPKi5A8+icQCxb
	V4q0doHbIbQKbWleYeoQojfAtjLq08qfxVz/bHAPvLW6ga83YAszMzJFFasMLnJFmiiGPaeobVE
	JVZA3vqzWECw7puf1U0/lEkQ5Yw=
X-Received: by 2002:a05:600c:8a1b:20b0:477:95a8:2563 with SMTP id
 5b1f17b1804b1-480544b05c1mr363265e9.14.1769232783429; Fri, 23 Jan 2026
 21:33:03 -0800 (PST)
MIME-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com> <20260112004923.888429-3-jiaqiyan@google.com>
 <d6b6ed0a-4bf6-21ac-b00f-3c2d05a8e728@huawei.com>
In-Reply-To: <d6b6ed0a-4bf6-21ac-b00f-3c2d05a8e728@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 23 Jan 2026 21:32:51 -0800
X-Gm-Features: AZwV_Qi3SSSi7Iy7X9UJqK5SEzigcPo8CI9WuKtgr1jBfDp5PGVBJeQp4qUasQE
Message-ID: <CACw3F502Xb20NL6vZ7WFJG90B_=pSYzGtjpO+xX+ZaW_sH5UNg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DBD940004
X-Stat-Signature: i6wo9ib5c7wb96w5yyajn9fe1mbqsj87
X-Rspam-User: 
X-HE-Tag: 1769232784-827475
X-HE-Meta: U2FsdGVkX1+lXu8shb3J5iWCHRUC+CEnUDS8mfHg5o6C0Woc0/P1OuyAFxC1hKaKHoMYEcwzAOByeLfnOz7AVHg5Tx7P6IPTz6WScyPFP+U/slnBTE9jN3vo7Fty7wVOVQXUrkNgWwmDBbprmV/mfg5CfqWhnSpCXZ0smbHwwFMqZC4tMsCPFXbRsNrp2zkacWVXBzv9hJK/1h7V16ZqYkVgKDok4aJ3DTAfOE5ziZZ7FSFNA4Sl/4s0i1M4IChBWzy9Xv+m3VIYyFfoJuqSSOmOKysxUK76Np5H5139YjHQgWPILJjOxZwWj1G8V4msvC+YxHAInwuTF61XsGezVgKJgzMqgDUvvLrilDUX2VbBWNKMYHGh9JTdhTZv54KUYweMEEAkNgs955Ltd9DIN45lqqezJUJoi4A2J+dDyIym/fxWJM/8pbEaHXvCJ1QRZaKSLhHxFN5aNk4T3r5P+5mYcXcPNyKXWEVxLcTxTBEljt+vfAHF40gKbvHMx8niIvrSwlDleIamosr+IijN+F5pxXb/AyOGVeWqetNkg645PXvXrbiuWyXUuvJJPBjcrV/g8cLdLK+GaO3z/h4ZYdxAWhzXAAcCWabPZRufzPxQv3IuIKqGzBz7QWVlXPOL0ptbiQ+kKpHFHKFaUtDNsMmCvEcpNOEqQdtZm4pmc1usfsmFxe/yvyWMfD1weRRNi0rrBJp5GvhGWKYMDL3Vj2JFNSdPfZXMcIDixlbqmdmwuBIkMwTu7lG/TOerqs2oRIkVxB9XG9VpsICV8AVKfm5ZUNmTXmW1ru+jbVDlG5w4T79XigSbmge/V2ahKETx9rgAOXQaAPMBUbBaQNF6M39OmDCbtVgyBsDnPnMwnUKHJqAg+RSwH936YoNJ5L4Qh7J7VQdHGvxjWjcGthfd87LXotQfoBEJqYs1aetbXyqfgREvKrLGgwfjZvqo5HQ6LFqRMJ86oPJBmhbLhaW
 7VLGvPr5
 4uHTKJ091x14CdgURIyUM7Ewd/LIyVERy0ZyNOwouD3mwVn7PbSodamAqtEvWt/zDBRagODXdQBDXX+mV0ATKNniX/IWAXYBoaH2YRFHz4hAcGZteL80q/DURh/d5ilWVR7WMNAt+ItrP/pD3ZkuqwTNCwT/YDqfWAwZzCfqOJvutxvI3g8Ys44MgXqszLatM+QXreSLZIc7j8Mg1EeI0aNbF7IecJLECx3hFK85adtaXtJ0siEcm4e2wy/RTQPeS++qNnyneaEPQhVjsj22qUhFywhdDj2iOEngN3Ir127LczCQuJvjVVvU3v9KCgjZRCqeJHrbr4rbczFuPup6n1qIUJEeElNn7ELvBqbHakCF4YMr4LEW/+EBrIB1tg71pRYdEhpjWoMxHyjyO5wiDTCTF0bORqJUmwqSaHbYe5QZ3NK2rLnNcpcoWvP+yWjcXz0bOniIHef8j5LXruP+PuuqBs0r6OaUC5Hl/R9fouV2WSSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:05=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2026/1/12 8:49, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> > becomes non-HugeTLB, and it is released to buddy allocator
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
> > dissolve_free_hugetlb_folio(). However, there is always a time
> > window between dissolve_free_hugetlb_folio() frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
> >
> > One obvious way to avoid this problem is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce free_has_hwpoisoned() to only free the healthy pages
> > and to exclude the HWPoison ones in the high-order folio.
> > The idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages. Instead of freeing
> > pages one by one, decompose healthy ranges into the largest
> > possible blocks having different orders. Every block meets the
> > requirements to be freed via __free_one_page().
> >
> > free_has_hwpoisoned() has linear time complexity wrt the number
> > of pages in the folio. While the power-of-two decomposition
> > ensures that the number of calls to the buddy allocator is
> > logarithmic for each contiguous healthy range, the mandatory
> > linear scan of pages to identify PageHWPoison() defines the
> > overall time complexity. For a 1G hugepage having several
> > HWPoison pages, free_has_hwpoisoned() takes around 2ms on
> > average.
> >
> > Since free_has_hwpoisoned() has nontrivial overhead, it is
> > wrapped inside free_pages_prepare_has_hwpoisoned() and done
> > only PG_has_hwpoisoned indicates HWPoison page exists and
> > after free_pages_prepare() succeeded.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> Thanks for your patch. This patch looks good to me. A few nits below.

Thanks for taking a look, Miaohe!

>
> > ---
> >  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 154 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 822e05f1a9646..9393589118604 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -215,6 +215,9 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOOT_M=
ASK;
> >  unsigned int pageblock_order __read_mostly;
> >  #endif
> >
> > +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
> > +                                           unsigned int order,
> > +                                           fpi_t fpi_flags);
> >  static void __free_pages_ok(struct page *page, unsigned int order,
> >                           fpi_t fpi_flags);
> >
> > @@ -1568,8 +1571,10 @@ static void __free_pages_ok(struct page *page, u=
nsigned int order,
> >       unsigned long pfn =3D page_to_pfn(page);
> >       struct zone *zone =3D page_zone(page);
> >
> > -     if (free_pages_prepare(page, order))
> > -             free_one_page(zone, page, pfn, order, fpi_flags);
> > +     if (!free_pages_prepare_has_hwpoisoned(page, order, fpi_flags))
> > +             return;
> > +
> > +     free_one_page(zone, page, pfn, order, fpi_flags);
>
> It might be better to write as:
>
> if (free_pages_prepare_has_hwpoisoned(page, order, fpi_flags))
>         free_one_page(zone, page, pfn, order, fpi_flags);
>
> just like previous one.

Ack, but I probably won't need this change after merging
free_pages_prepare_has_hwpoisoned() into free_pages_prepare().

>
> >  }
> >
> >  void __meminit __free_pages_core(struct page *page, unsigned int order=
,
> > @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zone=
 *zone,
> >       return ret;
> >  }
> >
> > +/*
> > + * Given a range of physically contiguous pages, efficiently free them
> > + * block by block. Block order is chosen to meet the PFN alignment
> > + * requirement in __free_one_page().
> > + */
> > +static void free_contiguous_pages(struct page *curr, unsigned long nr_=
pages,
> > +                               fpi_t fpi_flags)
> > +{
> > +     unsigned int order;
> > +     unsigned int align_order;
> > +     unsigned int size_order;
> > +     unsigned long remaining;
> > +     unsigned long pfn =3D page_to_pfn(curr);
> > +     const unsigned long end_pfn =3D pfn + nr_pages;
> > +     struct zone *zone =3D page_zone(curr);
> > +
> > +     /*
> > +      * This decomposition algorithm at every iteration chooses the
> > +      * order to be the minimum of two constraints:
> > +      * - Alignment: the largest power-of-two that divides current pfn=
.
> > +      * - Size: the largest power-of-two that fits in the current
> > +      *   remaining number of pages.
> > +      */
> > +     while (pfn < end_pfn) {
> > +             remaining =3D end_pfn - pfn;
> > +             align_order =3D ffs(pfn) - 1;
> > +             size_order =3D fls_long(remaining) - 1;
> > +             order =3D min(align_order, size_order);
> > +
> > +             free_one_page(zone, curr, pfn, order, fpi_flags);
> > +             curr +=3D (1UL << order);
> > +             pfn +=3D (1UL << order);
> > +     }
> > +
> > +     VM_WARN_ON(pfn !=3D end_pfn);
> > +}
> > +
> > +/*
> > + * Given a high-order compound page containing certain number of HWPoi=
son
> > + * pages, free only the healthy ones to buddy allocator.
> > + *
> > + * Pages must have passed free_pages_prepare(). Even if having HWPoiso=
n
> > + * pages, breaking down compound page and updating metadata (e.g. page
> > + * owner, alloc tag) can be done together during free_pages_prepare(),
> > + * which simplifies the splitting here: unlike __split_unmapped_folio(=
),
> > + * there is no need to turn split pages into a compound page or to car=
ry
> > + * metadata.
> > + *
> > + * It calls free_one_page O(2^order) times and cause nontrivial overhe=
ad.
> > + * So only use this when the compound page really contains HWPoison.
> > + *
> > + * This implementation doesn't work in memdesc world.
> > + */
> > +static void free_has_hwpoisoned(struct page *page, unsigned int order,
> > +                             fpi_t fpi_flags)
> > +{
> > +     struct page *curr =3D page;
> > +     struct page *next;
> > +     unsigned long nr_pages;
> > +     /*
> > +      * Don't assume end points to a valid page. It is only used
> > +      * here for pointer arithmetic.
> > +      */
> > +     struct page *end =3D page + (1 << order);
> > +     unsigned long total_freed =3D 0;
> > +     unsigned long total_hwp =3D 0;
> > +
> > +     VM_WARN_ON(order =3D=3D 0);
> > +     VM_WARN_ON(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP);
> > +
> > +     while (curr < end) {
> > +             next =3D curr;
> > +             nr_pages =3D 0;
> > +
> > +             while (next < end && !PageHWPoison(next)) {
> > +                     ++next;
> > +                     ++nr_pages;
> > +             }
> > +
> > +             if (next !=3D end && PageHWPoison(next)) {
>
> A comment why clear_page_tag_ref is needed here should be helpful.

Ack.

>
> > +                     clear_page_tag_ref(next);
> > +                     ++total_hwp;
> > +             }
> > +
> > +             free_contiguous_pages(curr, nr_pages, fpi_flags);
> > +             total_freed +=3D nr_pages;
> > +             if (next =3D=3D end)
> > +                     break;
> > +
> > +             curr =3D PageHWPoison(next) ? next + 1 : next;
>
> IIUC, when code reaches here, we must have found a hwpoison page or next =
will equal to end.
> So I think PageHWPoison(next) is always true and above code can be simpli=
fied as:
>
>         curr =3D next + 1;

Yeah, good catch! Will simplify.

>
> Thanks.
> .

