Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F8DCCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 21:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6CA8E0007; Mon, 20 Oct 2025 17:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E7D8E0005; Mon, 20 Oct 2025 17:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4728E0007; Mon, 20 Oct 2025 17:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 493E58E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:57:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C9DE1602F2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:57:15 +0000 (UTC)
X-FDA: 84019854030.04.92CFF97
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8FC00120005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:57:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AuEjzNp7;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760997433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yknPt/PYO8q5rRsHwsdUNqs0P5wiVU3fHyZ3dxpXBPg=;
	b=y/93ct9w7ZAluZpRfQRhAwCty6GoAPtOqFyd1pzyPZNKNf01sVkNKvfkYWOXPn8IhevPux
	rPx4kr0NZOvyPcBmeX33DMJirNl53wXWfSroYDmZNC8JtwT9k2okI3QWJBOriQxGCSeqhB
	UecHv8aDienr0bKwr94T2W/sYIWF0rU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760997433; a=rsa-sha256;
	cv=none;
	b=PDNkfb0L5566zHFUJ93QCannyNBNNvTvCN38bez6FsueXkzsIMnq3FR2OjkmPWcoesyuZW
	KEMxSYGyfomfVE4Ckeb/JdEE/P7hEFY8BDmfscEdZxGkactMaSCn9gVARQ5feFAmiX7x0m
	uHhEhctDBlx/6pGP0gruySqNSq7/6Jo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AuEjzNp7;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b40f11a1027so961810466b.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760997432; x=1761602232; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yknPt/PYO8q5rRsHwsdUNqs0P5wiVU3fHyZ3dxpXBPg=;
        b=AuEjzNp73WFZ/9oMBQdNJJ6FNoOgP4lSocC5MuITBh/ibodfz001K6ywzhyYjMy8+2
         RoHUooX9571BeEKVT0xIuWc7v7Ps0CwThiYK35QpYhGygcvEC5F6VPMZzzG/0ISbciLe
         qsyxdJTqocS0ezz4xhdDyABncLPXtefyPqDyOO13y5nh3SKMBrOHMGkwtpkPVzYeChFv
         I+WXuAHMXW/3i1Ck3IquCJBusA3xI/mcRBTc90lrCXi8HQjaYdeIMsEXyhp8gjb7IwqB
         jqeB6M2IoPH7PJ9jq8OP8IfcVD53CzajKFFrCV9dE1ARY3KlDO+8+Kb433GFiy9wcAqR
         t0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760997432; x=1761602232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yknPt/PYO8q5rRsHwsdUNqs0P5wiVU3fHyZ3dxpXBPg=;
        b=rYlPqs0mFLHiFFjP3PndzKf4vtBaoX+bogIvN2vpdmNOm9k6uv4OUEnvtSsuKeksLu
         yMhPK+i3nAYpI3TtnG/xpkRSk7EhSJ62y2x6csz50piaeInbUs/7EV96IJb0dLQlJ4Nz
         zkMmGosL301Azvgfz/8MD9F1RnsoiXzDJrnTbiyK0s7jhO2RiOqbO0Rwm2QjYHPEVQPw
         8afsCCMj5qGO52+EouN6E9GkjOfexYnOkUHM3ItB5x2ftSXBvURnUoVXxDDnzd4wGfS3
         ptxSAFHO6gDR8vxF3JXQ9lYwJ7lP6lg4KRiJEZvBOB2+ybfWjyRuMDnnVeQ/ctAWWVrL
         eHMg==
X-Forwarded-Encrypted: i=1; AJvYcCUhAeDs7fZbRcfkeQTS5F8Tj/LT+fw51Ige6iRws2PiMHJMA4cfxD9jcus21AS4EPQwo1rT8IIyvw==@kvack.org
X-Gm-Message-State: AOJu0YxlH+cTKhKi7kkIGe9MtZUGXyXMkYwdHoRQM9XomleJbLX7ZjA3
	YykwzBB8MDKuv1yNiddtwxlDOOIFnYLHyM+MLoQ1Ln0uatmHiIENdUVa7pyB6zM+YWqAomcSPlH
	/gspsx7XtvXXDaAemt5LqlufKpu9shG3U+nM+XSRtaA==
X-Gm-Gg: ASbGncur5JMh89uXnjJ1xDI2n8tsv9w+X7kMXY/Fl9jiYje6mWKITC8H2orAOF+icya
	fFMEVJAFyBGBTx0TNUgiBsT97hJ250amV0hr6mO5ODUMfrruMo21nKIevRgAWRSD9ArcmGsjX4r
	AZoarISy6jdunLKP3ynHkGVVaqdhSCX9j2UoWpIm3rTbBKUIcSoG8Urb1Hv60y4mMuD43zInQFK
	TDMz7egE8mM11oS1IDKW9Fm2BQo6gHBlmQQNkr9W9t8gs4Ro8kikAx9AD+kahO8ES53
X-Google-Smtp-Source: AGHT+IHQae2JTSc9wDUKvH2Zkgs7s+B9woSGFjjo4cTKOt1mF9fuNToFGqWKvdpPe0XvAAEv7aHWf3quANxxuxkPcIo=
X-Received: by 2002:a17:907:3d91:b0:b30:2f6b:448f with SMTP id
 a640c23a62f3a-b6473245877mr1851254166b.25.1760997431856; Mon, 20 Oct 2025
 14:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-9-pasha.tatashin@soleen.com> <aPXrLy8BmblbLpCG@kernel.org>
In-Reply-To: <aPXrLy8BmblbLpCG@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 20 Oct 2025 17:56:34 -0400
X-Gm-Features: AS18NWAztFjNYjBIm4rRiGeQCx-E5VPlPZGMKjs9EYAdnOCA2q6eV6QJOgzo-JU
Message-ID: <CA+CK2bDMYwd59_+OkRN-qcy70V=06Ui1AhCiMb9YJRPdn3-SYQ@mail.gmail.com>
Subject: Re: [PATCH v6 08/10] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: qykkr3rmn9kydey1am6gysknon1ff8gk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FC00120005
X-HE-Tag: 1760997433-692674
X-HE-Meta: U2FsdGVkX1/G+FRGgJGtDP1StEmdt5YGPhfZQkk1kyN5JO/DJ2Pw1rW10q9BD80oHWwhGMhxSA+WWUqPdStULSbO9zoGZOJ48IQPRW7hVUltO6ZH3Zzyj7ccR3/FIgn7IT5SVx87OX6ejh0VxTko8E2bcUnP0qDvkJbnKgDhuAPbI67zaQYvBJMMOVkQ+OG84CQhcRbVGiKCvHC7ksWQ5QUaq8UutJl2YTe0aXuPaFOH8eWQIWjTfpsS99nebbcRCTSJhhGuzvHGz0wDM46hTRKG/Qt1p5ziT+5tshgLNQ31oD283yTS6K31HqWoe89MqWR5AdPNgC3jolW4Frr3rhVloQ7hOJ/fOO7aaVLkDrpSu2vvYByHzdPspczUdc5cvdTn4cv9dwkWVV8pSX5ziJo5+AxEQ9IurrppC46w3EVNDACFdG5glp7Gh6LP9TBCzqWgW2Kg0OXQm5pWX2n1vDflnI2SWiiZb8Gh0kszoUrcP8L2Ia8GrwmY8fwXTnH7ovyZAhRr0/g/mVPRmmOjJKr9UWJNrwse5GNCJsrdvY+bRWc0z4jgK3N5AcnDW6qLP5IONZIo74wsQThZoig7EcDGa2ZA8D6sFXF+EcbCQaD1VJqjPcmMhRwhoaG3sk+LbO0Kc4Gx5qBrq5s3UM10pi53op8gaO3NMkxePcBtPGiIHC3rnI/WwDSYgynOqBuDiq5U0N+BE89fCCqZjW9viI24eLVZMcOox8L72R5w2CZKzt05QLgGt/UdbZClojVoOefz3I7haoI+qwOwp+0ZxKMpT7lrcUT2KVjacrP8tagxRr6RnegUqZJEc+ntw3sYNewNSbyXLGpEBDCdqCzk7S25rCv+arjf/mS/7AUKs+P6dLOrf6GLA8J3niLuLzh6gz7NxMo+74UOj+4D1b0nYTsHDWD4D+f5dmVfu2xHXM7/0D8KD2hIIKrBuK0X8g6DxQGOilrW0TZtngvIYmN
 YVmIDly4
 DmEkYKC+sNevqFsXB0xmwPBLVeSJyyP3Q+Q/6LKvLZ4M9bCMj7p6E2XpTO05zEIkYAo1c9AnQ8FStN4g8YdDXZoFJTzT6bw4GDt3SusZ100VPSRqzxNvAztwmYPrPr7IrDMG0ta6yzTbdZP6vX/ezhUqqtkW/4VzVjBVw9k9M9TsB0ZrZzEPR1JekKdxVy7IXmD23af/go4u9KG82FXYP3J7Mt+QTiS73KP40zCXaPK1zwqm/JHK1qybcvIbJ05yaD46Qb8MRIFny8gYnUELshoJxur5AO35/q1hZQOM2pwzt8Q9VzODyhNTgO4EYNS9SjpDI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +config KEXEC_HANDOVER_DEBUG
> > +     bool "Enable Kexec Handover debug checks"
> > +     depends on KEXEC_HANDOVER_DEBUGFS
> > +     help
> > +       This option enables extra sanity checks for the Kexec Handover
> > +       subsystem. Since, KHO performance is crucial in live update
> > +       scenarios and the extra code might be adding overhead it is
> > +       only optionally enabled.
>
> And empty line here would be nice.

Done.

>
> >  endmenu
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index c87d00c40c82..ebfc31814d16 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -8,6 +8,7 @@
> >
> >  #define pr_fmt(fmt) "KHO: " fmt
> >
> > +#include <linux/cleanup.h>
> >  #include <linux/cma.h>
> >  #include <linux/count_zeros.h>
> >  #include <linux/kexec.h>
> > @@ -131,26 +132,26 @@ static struct kho_out kho_out = {
> >
> >  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
> >  {
> > -     void *elm, *res;
> > +     void *res = xa_load(xa, index);
> >
> > -     elm = xa_load(xa, index);
> > -     if (elm)
> > -             return elm;
> > +     if (res)
> > +             return res;
> > +
> > +     void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
> >
> > -     elm = kzalloc(sz, GFP_KERNEL);
> >       if (!elm)
> >               return ERR_PTR(-ENOMEM);
> >
> > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
>
> I'd move the WARN_ON into kho_scratch_overlap().

I do not like O(N^2), let's keep it outside, even though it is a debug
kernel, there is no need to make it unnecessary slow, when we are
saving just two lines of code.

>
> > +             return ERR_PTR(-EINVAL);
> > +
> >       res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> >       if (xa_is_err(res))
> > -             res = ERR_PTR(xa_err(res));
> > -
> > -     if (res) {
> > -             kfree(elm);
> > +             return ERR_PTR(xa_err(res));
> > +     else if (res)
> >               return res;
> > -     }
> >
> > -     return elm;
> > +     return no_free_ptr(elm);
> >  }
>
> ...
>
> > @@ -379,14 +384,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
> >       struct khoser_mem_chunk *chunk = NULL;
> >       struct kho_mem_phys *physxa;
> >       unsigned long order;
> > +     int ret = -ENOMEM;
>
> Nit: s/ret/err/

Done.

>
> >
> >       xa_for_each(&kho_out->track.orders, order, physxa) {
> >               struct kho_mem_phys_bits *bits;
> >               unsigned long phys;
> >
> > diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
> > new file mode 100644
> > index 000000000000..7986dcc63047
> > --- /dev/null
> > +++ b/kernel/liveupdate/kexec_handover_debug.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * kexec_handover_debug.c - kexec handover optional debug functionality
> > + * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
> > + */
> > +
> > +#define pr_fmt(fmt) "KHO: " fmt
> > +
> > +#include "kexec_handover_internal.h"
> > +
> > +bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> > +{
> > +     phys_addr_t scratch_start, scratch_end;
> > +     unsigned int i;
> > +
> > +     for (i = 0; i < kho_scratch_cnt; i++) {
> > +             scratch_start = kho_scratch[i].addr;
> > +             scratch_end = kho_scratch[i].addr + kho_scratch[i].size - 1;
>
> I agree with Pratyush that
>
>                 scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
>
>                 if (phys < scratch_end ...
>
> is clearer.

Done.

Thanks,
Pasha

