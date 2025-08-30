Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E56CA0FFD
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 08:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257C66B0026; Sat, 30 Aug 2025 04:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A026B0029; Sat, 30 Aug 2025 04:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F77A6B002A; Sat, 30 Aug 2025 04:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED2CB6B0026
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:41:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E29313AE12
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:41:11 +0000 (UTC)
X-FDA: 83832779142.26.BE0048F
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB95D40003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:41:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=doB5EkEh;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756543269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkUVdbpOU+SkveJ4KHnqt1C/hB2g9VfaofOPCWLWzE0=;
	b=TiowPUBhbzZR6xj2XC94oV/CFBVGMOAkCUraB64h037Fb/iTEdpQLJhC+BRkTp+tIFqV7M
	M8Ti3Kd3GhRe0d9O9TT4VCeDKNuxpzQwu47bq4nF/su810YmgNojk583qMQhgvwjZq98qK
	75DlvqWSBS7DI7bdp2yrSWaE1EWrosA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=doB5EkEh;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756543269; a=rsa-sha256;
	cv=none;
	b=dn7D8jX5BaEEpKansZgJWK5EOSSOcCcgw1uxpO2DQsde8ammSWtnCehosyw6h1/zFhp0+5
	sl/FsLB8mxdOPlZpUxEaWgrWEzjDRiRyWV6BaZ+56y6UO+2jP/ELba9MBPJYkHaNsy00gn
	zLRB5/P/L4xpD0xDBfaCi8BKnHXKSQA=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e8704da966so180564985a.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756543269; x=1757148069; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkUVdbpOU+SkveJ4KHnqt1C/hB2g9VfaofOPCWLWzE0=;
        b=doB5EkEhu2BkWfHMPjvLzNxngw4WQHt9ESzczA8TMZomzC1DYLusahk312AZoQ/v5F
         XvsMbE2pohGWTkKE5H9nE//W5cEKvBSOuPiJvN4jy0CLJ7QmheFj277sFIx0Ip0JoPQS
         HVjBhH2cT7WMdY8Ki+nalveHhejwPOntfOYijrdC6wG/OCnXxuowLmILqYwZ+4UdBxFm
         dPCUKsvLcMmTtx/8qQYFSej0yAaDnfybhuLqoss+qUzYQaNpFPf7LQ17E4gywRGZTKHd
         BWS5/KrV54XczhENvHhMfnUMNsXNbvDjiUfIZ1K9KeL6o1p6fMK5XhSb63Olv9qVWD/2
         glIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756543269; x=1757148069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jkUVdbpOU+SkveJ4KHnqt1C/hB2g9VfaofOPCWLWzE0=;
        b=cRJ2XvGaV8umblvmRosjrJ4xymoPN61WhU9gU7hZdtM1GFgQvXhLJxzzoYC1Fzj13K
         cpdkDrjbSCNWFjvdCs+6w6e4tOLQ0q7Txe0RyhV9j6yBKRMXnonV6CNDMdjM2Bp8qRXI
         P5o2m73MICKPSXYyIc/XHRhT9m0bTXaoS+CSYyigoQJwkfVNiWkJiIQEdWZ7vyU5POa9
         qXZIDd0tO7CbSmwjBkf5c3D8WoQvUprXK0XV2kV377r8aa66C7m9r9x/CkdEeXJdEKVw
         AOBkYNjP3h6RC/EqyWwKDm0Ot4ZJ0UP3Z3CKIIwcf+p7UdYxiu6QFfhrSVi6vjzK8WLa
         /k2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXamDb/+pC5ZplqbpEGEJOTY8wwRbq/m7TXIVI+Df0hdbuvUn8v0q7Vyjlv0eS4AoLIh6AyGhW1tg==@kvack.org
X-Gm-Message-State: AOJu0YxxzkB9CctYt+gSztxitJ+1psBt8a6m+j4aoV9sRtzXoQIO3mQe
	VqOO/r13OURTGP612bhe0VmvSyi+PrfplUfuzFUrWxIR9vmvbiNfLJFYHqwmVoid938asEXJkL4
	GqQ0X7vsocYnm9wf11GnO6SkUVJ94lxM=
X-Gm-Gg: ASbGncu3LjVwy+zBp7Kv8ArOj4r7UHuYHcnT0O6zjUZ6k4MSqmZYDYEp7BeZKvYjNv2
	CuLUnTy1002qKnZqajNBEuTKn90hP0c/CS1oNVPcC90fhEsLy63n6ZclhXi/rzos+Xrkv+aVv0u
	4JWy93jQz03oqkvMkC0CCLFqeTw0J9TzOPzzkHZgUAwDEcFKV7iRHOQFJDIWimsjMUUQGW4cy6+
	B7oYASQ6NBWVuSYZ65Ofa8swDEf
X-Google-Smtp-Source: AGHT+IHiBcp+DLTL1DFIy/5DJtQgKHM1E9fLaKA4e6Epk8HBp8ZNiEmwjJXBcfdTsOI2gw7V8C886efkoeZ+tKvM1YY=
X-Received: by 2002:a05:620a:4256:b0:7f6:74fc:2a94 with SMTP id
 af79cd13be357-7ff27094456mr136276085a.2.1756543268719; Sat, 30 Aug 2025
 01:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
 <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
 <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com> <SA3PR11MB81201972CB6D308FB4659E7DC93AA@SA3PR11MB8120.namprd11.prod.outlook.com>
In-Reply-To: <SA3PR11MB81201972CB6D308FB4659E7DC93AA@SA3PR11MB8120.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 30 Aug 2025 16:40:57 +0800
X-Gm-Features: Ac12FXxQQzVz3ZwE12kpQKBS_WIg20ZLii0Hl9TF9Df55yGu3hbeQmQN-gJ_jbQ
Message-ID: <CAGsJ_4x38iz1XmRp_j3jX-8fY8o_3RNXLx78wc3s_4-o+N0URQ@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BB95D40003
X-Rspam-User: 
X-Stat-Signature: x8crt4drfms8cnzm1o7ywcpw6doyywr3
X-Rspamd-Server: rspam09
X-HE-Tag: 1756543269-909597
X-HE-Meta: U2FsdGVkX1/G6DBx1Bb8ZNUD+tklvUSubke8+tp2wMUFN0g1jrsc10DpZaATNMv92ukYITpwaL4CZGabUETg60ztyq8ZBVGa99XB0mv22dDlUiX9zOnXkTqE1+Zp9jUpo58cYEjTAj+zmtl7jRKFDmkibeoJxVkMkI8U+XvfLHy/lSazmU5tNPBAJits+iLW+J0acFO9c1TwsQZ3vIGbVQ2mAEGHDq1Xufq5t88ZZS42V3AXu6qKdnWu97pMf6bGKhX5iGDiu5fm3S3Xgw4JPkN2c9jH7Q1C45A+dRqi90ASL6excWVp0oq9toeASu8p1lnStUbppMkYyfJfTz2gl09q5ffFYkAzHHB4op3ZheKqe0p/8n1QN5ZFPb/PlHQnDGJXSOk3P9T0ITztKuB8rcSzHhybYd/pKjOqvdySQV2tiuUVpt4C7WoYVHz9JojepPpvltFDn5GEZArxGE7tzONV494An7aTBo8KWAKSd/ikWs3VpdWtzRj/djmrSXb1fvdYlJQn3mvKEyryOfDQKYhZzCHkGtGVIGptlwMEyLy3S17xLicb0x6SMqoOb7dfrzh8ElgxJ5XoDKRvk5r3drboY+YNbq1eaQW2WEojwOH32oGGGho71EzrxdBitQpsIIUpfKJFBlu4Lz0gDSW1nZtxSpHNisCH+eEI5oXzBr8c+/LVNmDxFOzkjdE6oGayPmhtQ+jfmWrc2atnL1fKKowlndV54OANENCwAVh9m2v+WBd6WPKxr89lf0gO9UGzffyH8/ctPBJ4v4sFYrGdFZYDRC/j+tJrVVRFcywhwTXGPFB6iAm/mE2GscrDyDprB28kzCD29Ndxet/rvjOjAtHPrBjFhSnAHpCi7VXHV1yp5vbuyuN5ZdSYuvFJWrU7m9JkYnVvii0Ahg8XCel6WVtwdtSAHZJvbYtYoKzq8Ow09h+YiRLcHh5agqtScAfK87NUqSlJvXwMDMU2fg2
 Yi76FeGj
 jFxjlV1r6oaOJH7CgeTi0myaBh3aZL4qO7YFW3dev73zhI2j2jcLNAoo+E0sljB9NiYw75oDWH4kVreP5JCASW7zmXOlxrym5GFlWTCgfZMWd/LXiK2G/KSQZclm9arRIyBXaezBbSbytjdxP4g65DNaySPV4X7QrXFeKGymKilYQl3H35tlqVdcXpd3eUyk83gltHVomDRSD7bNjopphOYbDXWuvvfIJnsWKamt47EEWCzLoLnI9v4hZ6VOC5gX3SkidygXbGuPp5YQgWQefAv02/6S90Ht4CZm8Gqo0vSRL5AAgqjCehQkEDr7EQtNoU64kOP79WjOLAec/rYGKN5wGF3t7RDkNYIgzi+zc8oJYucUs/BWSpX6BeCD5jZmwLx2lAVBko+k9em0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > >
> > > I am not sure I understand this rationale, but I do want to reiterate
> > > that the patch-set implements a simple set of rules/design choices
> > > to provide a batching framework for software and hardware compressors=
,
> > > that has shown good performance improvements with both, while
> > > unifying zswap_store()/zswap_compress() code paths for both.
> >
> > I=E2=80=99m really curious: if ZSWAP_MAX_BATCH_SIZE =3D 8 and
> > compr_batch_size =3D 4, why wouldn=E2=80=99t batch_size =3D 8 and
> > compr_batch_size =3D 4 perform better than batch_size =3D 4 and
> > compr_batch_size =3D 4?
> >
> > In short, I=E2=80=99d like the case of compr_batch_size =3D=3D 1 to be =
treated the same
> > as compr_batch_size =3D=3D 2, 4, etc., since you can still see performa=
nce
> > improvements when ZSWAP_MAX_BATCH_SIZE =3D 8 and compr_batch_size =3D=
=3D
> > 1,
> > as batching occurs even outside compression.
> >
> > Therefore, I would expect batch_size =3D=3D 8 and compr_batch_size =3D=
=3D 2 to
> > perform better than when both are 2.
> >
> > The only thing preventing this from happening is that compr_batch_size
> > might be 5, 6, or 7, which are not powers of two?
>
> It would be interesting to see if a generalization of pool->compr_batch_s=
ize
> being a factor "N" (where N > 1) of ZSWAP_MAX_BATCH_SIZE yields better
> performance than the current set of rules. However, we would still need t=
o
> handle the case where it is not, as you mention, which might still necess=
itate
> the use of a distinct pool->batch_size to avoid re-calculating this dynam=
ically,
> when this information doesn't change after pool creation.
>
> The current implementation gives preference to the algorithm to determine
> not just the batch compression step-size, but also the working-set size f=
or
> other zswap processing for the batch, i.e., bulk allocation of entries,
> zpool writes, etc. The algorithm's batch-size is what zswap uses for the =
latter
> (the zswap_store_pages() in my patch-set). This has been shown to work
> well.
>
> To change this design to be driven instead by ZSWAP_MAX_BATCH_SIZE
> always (while handling non-factor pool->compr_batch_size) requires more
> data gathering. I am inclined to keep the existing implementation and
> we can continue to improve upon this if its Ok with you.

Right, I have no objection at this stage. I=E2=80=99m just curious=E2=80=94=
since some hardware
now supports HW compression with only one queue, and in the future may
increase to two or four queues but not many overall=E2=80=94whether batch_s=
ize =3D=3D
compr_batch_size is always the best rule.

BTW, is HW compression always better than software? For example, when
kswapd, proactive reclamation, and direct reclamation all run simultaneousl=
y,
the CPU-based approach can leverage multiple CPUs to perform compression
in parallel. But if the hardware only provides a limited number of queues,
software might actually perform better. An extreme case is when multiple
threads are running MADV_PAGEOUT at the same time.

I=E2=80=99m not opposing your current patchset, just sharing some side thou=
ghts :-)

Thanks
Barry

