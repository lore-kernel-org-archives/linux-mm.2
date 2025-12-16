Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1ACED609B0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472C56B0005; Tue, 16 Dec 2025 10:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4205E6B0088; Tue, 16 Dec 2025 10:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EDB6B008A; Tue, 16 Dec 2025 10:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD9D6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:52:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 851B959AB8
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:52:38 +0000 (UTC)
X-FDA: 84225776796.19.EB5AF30
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6BF2580007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:52:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ts43UMgE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765900356; a=rsa-sha256;
	cv=none;
	b=DGia1UUbsi6qucNnkjY9OUrJwlN9VWf0viFZH9XR3KS+adiQOTSBhmfixKrbJj6AOqrTRW
	EP58R/Y5Hu0co/zKTeQMLOJeEFRNEs0Kzia983ETDH6NhWTKmdKF5lsmutKxaTXjo0/Niu
	+h5sXI9bO9jI7hGROSAgbAtD019FGac=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ts43UMgE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765900356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXxGblJuerDWpBcIOypq80sXY6o3+TxONi+Sc9tFnGs=;
	b=xPecJk9UDVNNj5mLiUnPaCmc2EjmNp8qcmwgAZnYH/g/U7LWkGwKv8CRgUerMHp8yME3uS
	itJoRWfAJIofgLi6NWTpeKCHQc5jzdzA8Eo90rVuRnBhPZrL2GBCGShwNnu/v8yGCTb3LG
	wEWOq7nh+NxzmwfmYGqfqzYCw831rpI=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so821591566b.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765900355; x=1766505155; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXxGblJuerDWpBcIOypq80sXY6o3+TxONi+Sc9tFnGs=;
        b=Ts43UMgEkqveVcNLz4bjistB2GezdaAl/spMicXas+owmaxhe1ChZm0tPxnQN0+ETn
         JBd4Kp4y5Zn1rqcVd1QEPrg7dNmaWJZxKZ4JZM5ckYgCZF+bWVSh/NNemX+QC/eV4Kdk
         WnCbSnneD0fXBFbeRs7DYzGi+DL2l0G1HAOQ5pwLjGTkuTB1ZDPPuAnmDVzIxOlTPNC8
         PLnoU7DwSYyO88CIHvEnQSikQk8RpjzKzzKCOpuqiHa1DUYxdtJGAcmk5TpkLe9TTFP5
         wIt2as0wu5LdgBg3mPsLARj49c0JavfwGSAKe5CA54JxFP5cEviuPsTyWt28ZCUzFuxv
         CHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765900355; x=1766505155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QXxGblJuerDWpBcIOypq80sXY6o3+TxONi+Sc9tFnGs=;
        b=ggjBa1TFoQMj5c5HbmGK4+0/UtZtoDPDBI2luKkGYoNvpCyc3mni2R/3oqM4tqF+dC
         D6CfNnniriRT3VZPf6P/gwxy8SQIG6dYtINXaQAn/lfcmUiNLzg/kJzIb6N21VoGL5Rk
         4PitjAK3yejh3sVphu1X5GZcdnbjc03aXzW1n5AAr2C1HkHpkX4ND49Trn+hVhN9ycJ2
         r2gd0s3QBz8CQAqBUiXTnJv86WDY8Ob0ImYYre2Kq7P+WUkiEvRoAMWx4Hy5pKdjpzl5
         Lsq1I7jz+5lN0c5QCLvNWVXSDZReif48zaLR4qXptY//cadJLfYTveZIkLHrw5yp74Pl
         /h9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxGgVth6hmDBsLLW8dvwrMk2kXQA5AV1eyHBCCvbGF0V+8UtLilDlsATKW3HqVCN0mYt8ZuTSnKA==@kvack.org
X-Gm-Message-State: AOJu0YwX5A9YCfGrc+twNM9vJDTR/PZQ2owEPMer45Yz8sr6/XxQODiX
	IRX0LC6LJqTeXR/d6UlNFcFFsjF3O9xWogK4YQ77bseCvpQSnoYxl272DkAU8J4WV4y089haQch
	G3O840djKhVS7M9IVNdJUQgg94FT3pYCJPE76+pEzuQ==
X-Gm-Gg: AY/fxX7Yt+bUhjH+4y72k46ZXC2apovR+U20/B29i5jqXUt+EDf6v3TWhvTrpismVpo
	LiMHlvwpjrblGfUu3lvX1igAM8Lxc6vLknC5OsdVTLm0kgdjzeqJPww8MNhOF/IDW+N2MSiJF05
	DuXs67DXO3PX6Hn1GHYMzuN0RIJQTRRm4BYCzVmGEm0Xg2OvMsV1qI91cQA4QdDnR54HP1l+RDc
	AwDfczPiLEF4iohFfvSX/cIBbEF9fzKfts20292XxkUCKHJwGxMy4srGzyBgX2MYUT3KRE1F8gA
	J/a00CuQ1ejTGuoufvJ6JLvP
X-Google-Smtp-Source: AGHT+IF8hUf/njs47ssOWxWrTAtN9SW44kkMcdwp9wLrZso0GjDwC7fAR8uTmXjFxwWpMLXPrdui4riC4+4Ir5L8T5c=
X-Received: by 2002:a17:907:3f21:b0:b76:f57a:b0a7 with SMTP id
 a640c23a62f3a-b7d238caf7dmr1725050066b.31.1765900354456; Tue, 16 Dec 2025
 07:52:34 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
In-Reply-To: <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Dec 2025 10:51:57 -0500
X-Gm-Features: AQt7F2oVU79Y7RmiV1TRfmRsHfWXG1IqX56Yslo2Aowm0vb9rvseAzO_YZsWkZw
Message-ID: <CA+CK2bDLkf=5Mk0XH2XvUFS1px4cROBRjO+eKd4zvgzrS=Z-xA@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6BF2580007
X-Rspamd-Server: rspam03
X-Stat-Signature: a8rjuwtito34qgc9amedhhziyoo6yfcm
X-Rspam-User: 
X-HE-Tag: 1765900356-605921
X-HE-Meta: U2FsdGVkX18Ras2BLh6F2xjbiQ0Fnu5uiAAZa3NVCJZDuH9lo1cFHcL71z1HzGNp3eUplDlu9INgkzqBTDbx9xjtf7McqkvLoPJ3KtICq1r/79SWP674fiJ/8gxdExgl2MUxhjfEnQ1Xb/EijKqmG4MKpefgZfn/CT2HOlbKsP9cnON0tJCUjBjIo4Z99SJC/+D/jySSEtJkLWauKdItwZMp79beQCEa0hxGvxc7JLHFGbWQSJTOUYTNPTZNNttWTozzD9Sqeefb+jBCGtTMMLsk1qmt+suB+Cj9otaIwFkvhrkblglFRSyqidu1tTfIF2m/2sxxWhLNAhIhArAL0y9JbKoM/2ontH7tIErObH6j6XRfGn/L01B0bUf62rT8RIODwq2kIoEdP5aaoXJV+MjZ8OqU2arTRfTJTZOSjILMcird7Sz2DxmgJV67sv5PDTunxHO+aC/Jkm+70rmiY7+IcftwR5jZ01AJTLg2Pqi0/kREpJRylNbKDIG+M6l/YxEQem7pnFwnbGEVMzUc8OgzmVsF0bdWIQYMknXV7r71kutvRwGL6M4Hqt09phuEDBeE6XITdov+GlWtuNv9aLqtcgYTcwSwtdAo2FhUCdq9jt7LK0zktzJMqmertC2uC/Q+alwcRyL9ea8nExyLoiqGpzbeDUdNXMT1x1GWi2IBg1p3QpdmGdcc46q6vRbHXvXnTxl+zttxAh6lTWEAjpI+KcVU6+QYME/hZqPa4DQsRWnMAsOaTxNPifVhFsCvsdV/TWDpCg7vXBnp0Y2wSxBQbYcCTrgyTO+JQQtw56PcxCQKCuqtt62wNQ3NkHMTXdKaSKjvhGhyxtueuNKrFVHvEla4pDpqgBqgXiTzglkxDNyuulqDimm8viLovfytJ5L8fUaBD3yyo3akGme4J/DYdoZCP9hlqm5d6nhbn+F1DPJkTqC4PeWcg8J/V8qrSGWolyo+j5xzgdpaA1A
 wKRHu7NQ
 fp/madWPl5bWmo4iWxsw05YqWV4+siy+erx0Aye2J6CKaaoOAtY8Wk5MQ82fYHXzx17Q6Q23XeMhMxX9ErfjCMphxieEJC1Sp4Oe8h8AW/aOJvvBLQ4T6O2c8e2FFKH40GGyCG7T75ovcyDdHrbOsDZ9HTYEt4zoK3MMhf1ix+b5TKDOv1N6B+mR4v6l4AmY5rsoqd2KHbvf2xbu1sU0Vg8M6Irs/T+QYeNdhBtBmk3JgSNbBVZq0MSJCIMVY1BNkTFkA1eXGf6+6Uotl+LwdgBFItA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:36=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Tue, Dec 16, 2025 at 10:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> =
wrote:
> >
> > On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
> > > > > +static struct page *__init kho_get_preserved_page(phys_addr_t ph=
ys,
> > > > > +                                               unsigned int orde=
r)
> > > > > +{
> > > > > +     unsigned long pfn =3D PHYS_PFN(phys);
> > > > > +     int nid =3D early_pfn_to_nid(pfn);
> > > > > +
> > > > > +     for (int i =3D 0; i < (1 << order); i++)
> > > > > +             init_deferred_page(pfn + i, nid);
> > > >
> > > > This will skip pages below node->first_deferred_pfn, we need to use
> > > > __init_page_from_nid() here.
> > >
> > > Mike, but those struct pages should be initialized early anyway. If
> > > they are not yet initialized we have a problem, as they are going to
> > > be re-initialized later.
> >
> > Can say I understand your point. Which pages should be initialized earl=
t?
>
> All pages below node->first_deferred_pfn.
>
> > And which pages will be reinitialized?
>
> kho_memory_init() is called after free_area_init() (which calls
> memmap_init_range to initialize low memory struct pages). So, if we
> use __init_page_from_nid() as suggested, we would be blindly running
> __init_single_page() again on those low-memory pages that
> memmap_init_range() already set up. This would cause double
> initialization and corruptions due to losing the order information.
>
> > > > > +
> > > > > +     return pfn_to_page(pfn);
> > > > > +}
> > > > > +
> > > > >  static void __init deserialize_bitmap(unsigned int order,
> > > > >                                     struct khoser_mem_bitmap_ptr =
*elm)
> > > > >  {
> > > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigne=
d int order,
> > > > >               int sz =3D 1 << (order + PAGE_SHIFT);
> > > > >               phys_addr_t phys =3D
> > > > >                       elm->phys_start + (bit << (order + PAGE_SHI=
FT));
> > > > > -             struct page *page =3D phys_to_page(phys);
> > > > > +             struct page *page =3D kho_get_preserved_page(phys, =
order);
> > > >
> > > > I think it's better to initialize deferred struct pages later in
> > > > kho_restore_page. deserialize_bitmap() runs before SMP and it alrea=
dy does
> > >
> > > The KHO memory should still be accessible early in boot, right?
> >
> > The memory is accessible. And we anyway should not use struct page for
> > preserved memory before kho_restore_{folio,pages}.
>
> This makes sense, what happens if someone calls kho_restore_folio()
> before deferred pages are initialized?

I looked at your repo. I think what you're proposing makes sense, and
indeed it will provide a performance boost if some of the folios are
restored in parallel. Just kho_init_deferred_pages() should be using
init_deferred_page() to avoid re-initializing the lower memory pages.
Also, I am still wondering how it will work with HVO, but I need to
take a look at Pratyuh's series for that.

Thanks,
Pasha

