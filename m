Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6711CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 11:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EAF8E0003; Sat,  6 Sep 2025 07:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE9F8E0001; Sat,  6 Sep 2025 07:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD848E0003; Sat,  6 Sep 2025 07:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6598E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:58:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC8DC13B2FF
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:58:57 +0000 (UTC)
X-FDA: 83858679114.24.4B75A02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C1855C000F
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:58:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OeBjEByJ;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757159936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkbvYiCc5FNF/QDK4AC4j2iWKQBXch2lEyheo86P8dU=;
	b=wzEPjsI7ST/dUCFIf8r8SgH20JcwCPDGxe6pjqH/+RiDInT0NpkXfUn+Z3ppebKMvxyARV
	uY8AUUC82Zd9giEkeFHEwlI2m9op1jmw/Hf+2XlQtaFPSB5xxDhBl2bZbZN+QVkpQJ6mtR
	84dA42ONo8uKPBHpBLU8SDppUSPsxe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757159936; a=rsa-sha256;
	cv=none;
	b=4k9Lr7ivZavKpXspk9HK++UcqQoEyLCeHg2+Pc/O3OS33iogAcpyf5dn38zxv/PxQfWe1E
	enDrQkTwk29Q8sVx8jWDqZrJf5wcUdHjUxH5vyGO8z0oaeGKz9ZY+WPPno4lItNX18LyWy
	QyTWP71jCTzalFhuy+TojzbeVk2tLOo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OeBjEByJ;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78A1945084
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB7CC4CEFD
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757159934;
	bh=Y+R6OdqfM70uWhWnuBfHr9o5HKUIm94zXuJivP6hw4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OeBjEByJku7Yc2fSJnPtWiWQVZWsK3hgRrEfXSNiiFkKsVFh90/1j6XQD5XIhrDA5
	 ZEnHcc1tOWVqANRmQwebPZvDP2hR4OznAfJTILuV4B3C+t+IN061O5Pc/vWvMdmvpz
	 cAl4ajwrSIrwh3/tgpk/XZlo1aztmkXn/YFeKgzqAJjiYgYX2MWVUrDIlwwMe4MVRO
	 DyfA7jUzffVpXRLrSutSpqBcy0qEkcSWceMEBjDTHXdO3FiESuWA4YNfJlu43RiePD
	 btY4ipsgjE7/C7cbW+09o3Qb8aI6CYdv72rTEXEKuQCJjgA5ife3j0AXzk3/zgEzeI
	 6loDtZJvfCT3A==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so46895e9.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 04:58:54 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw/b0xRUQfsTifl74YSrFD31N1ZOm8mbdw59W15zCbWPfZ3biX1
	wqyjQ86qMNwtwFuXuRmRE0IKv8FzKuJ64K/aMKQ/SCGI9oiKT4/MqXvraq2sHWWUxPOFlzXZjHp
	0p+VfKmCPJ75zfCiVdXvze13uy069pOyW/bdbi82o
X-Google-Smtp-Source: AGHT+IEdfbwBEn4ztTNn03ZcNZmiIGdjx6/+5WFlkp555xMk8nvWcFO4gxEF1owQmIfOxcr9ircCaRUpI4x2hMJXAAY=
X-Received: by 2002:a05:600c:34cb:b0:45c:b678:296 with SMTP id
 5b1f17b1804b1-45dde17c034mr899185e9.5.1757159932937; Sat, 06 Sep 2025
 04:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-4-ryncsn@gmail.com>
 <CAF8kJuNhLDovRO+8Y25ArdMBVFjXnYBVjmASzMBtdsdZkQ0NLQ@mail.gmail.com> <CAMgjq7CyXEy3+98JdATscgPu9b9oLbE6CM7-2pFpiQP2QrsrpQ@mail.gmail.com>
In-Reply-To: <CAMgjq7CyXEy3+98JdATscgPu9b9oLbE6CM7-2pFpiQP2QrsrpQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 6 Sep 2025 04:58:41 -0700
X-Gmail-Original-Message-ID: <CAF8kJuM1M=gDwkuQF0tU_d4YXxf9dpZfNe13ycPjgMcr1RUkJA@mail.gmail.com>
X-Gm-Features: AS18NWDL9WLHuN5sS1DbFEP7WJoIPUp7pl0etFR5WWyMwBy3lQ4adYkPyeehV-o
Message-ID: <CAF8kJuM1M=gDwkuQF0tU_d4YXxf9dpZfNe13ycPjgMcr1RUkJA@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1855C000F
X-Stat-Signature: 1oqxd4mc5pz3x8kh3gd1in4kd7o3odnh
X-Rspam-User: 
X-HE-Tag: 1757159935-551636
X-HE-Meta: U2FsdGVkX19B4FTNCQCs1GMzH+F6E96UwjGyh5kSaVLtb91XtaA+X6ztThR4VG53yTpyxAym8pwx6V4TWNZAmD7H4rzKmYy+IEBVOntg/lmTWSonZzu1BDJnqWoBN67sTCtMyUiFT4M8q1HdsJnBxvqpPqyKP6eY3PsiPvX6u+HRulc4QlTkAAz/tTBNxStA4nYYc4fF0u35bZckKhtbjSaY5gtrbnXB3J3DoqjulSKjExtGNH9zbxynHOZYA7mbVVPnX6AoQhj9JWl7zEb3apUluK3V/5NLWheOPEiBwJtOlie9H78dYUCdSWaqqZdIy90SEdwOMMDH0lB1a2DQ6FN0UKE4VPtUGJ/GisrIKIPSaceC3aDXQ5KXoSTBaTx6z6NZQuCO70M5fDMO5/A0K7sT2AgYLe6+12SYSWOQMjzsR7XQnEfWHNbgYJ32UKclfHOX2k1aHA6aVkcyDIycHZNIw25RS3yHvaBjUnnpEzr9MwtyACVjvW2mHXmYEbkD6759VijljDkZLT43AZjyv/Z7SboHK0J+9uy35Ogdudsk7Su5t4Rg5VWO1ngxjgD+unKQ6VJUZ5lV2XkHWFEtX3luu0lPsw4tiuF2C8jDL49VsIT0hi621P0J4k+S4/OuTP8z7HLs9HCGC3Gqgxe30BhdZElHz9hlo56r6JWrGLUFIB+KJvkRnTJRebfoy0SuvWrET76Y5Q4uBE7BsIN5U942j1+3Oe/Lt5EAt62eaaZFNVU+NbWHBr+TIQbADO2Yq5TIEBn+RrKSBL/U4FWxIcAi4HRGaP9S/l6Di6vufiNYFRCArhkj7UnrTXqdkNFlCsxrz7daud6NZTmuxIX8ALIVCj8jnC80CA8Mho2NYL2Q2nui7SPaA5DVa5z9Ezg82yJHIjAj6oGGv8qZF6R8GN/kLQLDtqRtHIbhr/rccnPDjy1OzL7RnRcSHtk8AhnskbzolI8Qjms2HyixOQB
 tqULRf9c
 /R/oxd/O2f1P7lL5ndctK93fpSpOzr7hfyeaMAI5iM0C2TvruCl/poil06CsStaktfwL0UmEGvgTpVPoCQv/j6mLbfgnWoEe0lJtPjx5e2hvllu1/DURO9qyFhX/kP9cvSj0Wpurn/oXsPYWXuy2Kz4nC3D6lDxqidvXeo3OUxJpPLL/kIz1FLP+02tG+rX1iJPlsU4SveIGiCzAeTBu9nZuy7dZenBtdwrZDbgykbDQiz6uqJrXeQgbR2UQqUY7RPpStK039q76hbw8+IrPHqRpUZQ6XYZCG2Oytkf176sD3eotgWpDbzgd4PAmN282CwwV7UsHgBJsKbDz2NwVZVUC9pG7TEkYsLftbnkOhniWomrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 11:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Sep 6, 2025 at 11:19=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > Hi Kairui,
> >
> > The patch looks obviously correct to me with some very minor nitpicks f=
ollowing.
> >
> > Acked-by: Chris Li <chrisl@kernel.org>
> >
> > On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The allocator will reclaim cached slots while scanning. Currently, it
> > > will try again if the reclaim found a folio that is already removed f=
rom
> > > the swap cache due to a race. But the following lookup will be using =
the
> > > wrong index. It won't cause any OOB issue since the swap cache index =
is
> > > truncated upon lookup, but it may lead to reclaiming of an irrelevant
> > > folio.
> > >
> > > This should not cause a measurable issue, but we should fix it.
> > >
> > > Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cac=
he")
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/swapfile.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 4b8ab2cb49ca..4c63fc62f4cb 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_in=
fo_struct *si,
> > >          * Offset could point to the middle of a large folio, or foli=
o
> > >          * may no longer point to the expected offset before it's loc=
ked.
> > >          */
> > > -       entry =3D folio->swap;
> > Nitpick:
> > This and the following reuse the folio->swap dereference and
> > swp_offset() many times.
> > You can use some local variables to cache the value into a register
> > and less function calls. I haven't looked into if the compiler will do
> > the same expression elimination on this, a good compiler should. The
> > following looks less busy and doesn't need the compiler to optimize it
> > for you.
> >
> >            fe =3D folio->swap;
> >            eoffset =3D swp_offset(fe);
> >            if (offset < eoffset ) || offset >=3D eoffset + nr_pages) {
> > ...
> >            }
> >            offset =3D eoffset;
> >
> > This might generate better code due to less function code. If the
> > compiler does the perfect jobs the original code can generate the same
> > optimized code as well.
>
> Right, this part of the code will be gone soon so I think maybe better
> to keep the change minimal, and it's not a hot path.

Ack. It is nitpick anyway. Most likely doesn't make a difference to
modern compilers anyway.

Chris

