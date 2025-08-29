Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113F0CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532448E0007; Thu, 28 Aug 2025 23:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3248E0001; Thu, 28 Aug 2025 23:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C81E8E0007; Thu, 28 Aug 2025 23:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 292C38E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:42:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6821813A269
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:42:27 +0000 (UTC)
X-FDA: 83828397534.15.0A1D2E0
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91DECA0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:42:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jr5bWWvV;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756438945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9nsLcz9oLPq6b5kinEZVYxfA3jpb2WrADy8yf5QiW8=;
	b=W2BcKSocI7+9/9JbrGAY9kT4IqwGMVubueBO+0KCEz2AZodFN67SeN/ruGVExwk/obCKom
	jp89XFYSwKO2GtAUsq6Oe5VjaORPngupr5SBU+7RSo0KQz+xRFaQHOZHcWnY73sVBev4n6
	mB2rTv/IgVOsSq12kVA/sU9CL8O5fRU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jr5bWWvV;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756438945; a=rsa-sha256;
	cv=none;
	b=HhOEI5Gtmh2Wn5tV/iKtlA7SFdCJZq7pSeQd8L3G0ASFJW7AN83RB9+eHLpYA/EHKi0NKk
	mRvp+rzWDsGzdFnJoZUqtyHjrevYdgYDeNmRBw6oCXXDN5sqLj1remzvCgEaghbcmb7Byp
	6eiQYs/oEIXv2o7wRD2Sb8Omf4sGhkQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b2b859ab0dso15836881cf.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756438945; x=1757043745; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9nsLcz9oLPq6b5kinEZVYxfA3jpb2WrADy8yf5QiW8=;
        b=Jr5bWWvVeeLqqTySccGSmoH26eEhch7Jz53qgNMO0OYk7D9DO71VcTYlzQ3UVJu5kh
         1mmgNJ/TosGbJC6qgTZDDuDvBseSKjqXrcV7rvIoJOdnhlgeLLeeOspK8oUXDcCrcPUS
         djOvB8ogJdmWMIIrpvJ6nhHaME/oppGNphKQzyh5o6CehG0zXEt62GQsAPO5+fXT0ngz
         7eVmmmseUR99BTeqnRVSlE2ymi5t0LZ5oOPcST1LLA5fdVG7FElP7KdjuJwE6n925L6I
         FoDkT9ON24rIhTKdstncaKD/tyFd/5hvZRrdANYpAiX/psMEIJN+xg//0MvM2ftHCvST
         Rz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756438945; x=1757043745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9nsLcz9oLPq6b5kinEZVYxfA3jpb2WrADy8yf5QiW8=;
        b=Nl8p5hGOC5++OfHElEx+iCl3SFByX4O3t2PAuFGAxyl2ZlPpRCpuFr1Gr7ss+uptDo
         qxtQRzeAG3feuaqesdBrqLqUmA7WxViVI1p0ogO/FIQmPZ5XSZwqgOpMZJ+w54aPT/Fw
         B2OpBOYvyNgsUpExqMraImSawmTtflqMYS3EkxaGvTKSZApNjYj4U7iu5t+VFQ3dWhyr
         VqXES51cyqo1HK+RhwLnmDFcqgk77yQNV7jk/dyK3ugzqnHYbOifLKNiHLfLwWYkr5mE
         pbcDTJONx9fdLXnNnyAVw6zIWDWlKWvQujIru/vU4IAU4QSSszbvAcZ5mOY7ZDSr/pka
         j3uA==
X-Forwarded-Encrypted: i=1; AJvYcCVyABlkZQKGrSluuBXTxNEbu9NgHEyJIvYG68t64AsHMviRb2e9vbzG/WF+uBzCeyu3Pvwj6uuSgA==@kvack.org
X-Gm-Message-State: AOJu0YypSHbVUkFGiBJrSdc851WSoi9xY4pG8popsVx5tVeec5MpYZSt
	NFKTmqf92cEyPCzzFrpbopKDbMMmfZjekyqypNLb9NN9hPHnUVLAUseZBw+p0xDzFzsF02bKVwG
	3BXdVhn6MZ07PDchAXu7nn1uNFZs9Yl4=
X-Gm-Gg: ASbGncscgWxOOyGXv/eMmXzvaQBkXF2Qv9DViIAmVT4WMYIHWAKpBjg848WE6Z3NITe
	aUxn2ZKFya7Kn5svRzHMQu6Yy1JHttMXVnIpeMhGXIYCLBvppaLsMWI4NzKa53TazPZZT71QwH8
	Hcc67SR4qCp6NsoLMUhUm9ZLt6jM1uH1GcenhZjvc3n3myWGNyByQJbXBbQqqSVWNUKzVwE5nMI
	eZTb78=
X-Google-Smtp-Source: AGHT+IHSLkm5K+k2w+6sBnrX/gOo2iWdZK+eBp5voDRHxu9SAC/ISPssrMgLw4Sv4FNHTUzekbupzxvNT+r7HLHqU3g=
X-Received: by 2002:a05:620a:394b:b0:7e8:2c22:8e0e with SMTP id
 af79cd13be357-7ea1107cbabmr3284967285a.49.1756438944142; Thu, 28 Aug 2025
 20:42:24 -0700 (PDT)
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
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com> <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:42:12 +0800
X-Gm-Features: Ac12FXyg8yM_nrW9tpGwrsqMNR1iGLArF5rK3V7hQyzvGqOBzOtw6u8bvrLvgxg
Message-ID: <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 91DECA0006
X-Stat-Signature: pufayi6tthrcfb8g9zxy7jszk63c1nki
X-Rspam-User: 
X-HE-Tag: 1756438945-673262
X-HE-Meta: U2FsdGVkX195vays6/MLjDXzTOYUGf9Dv/LDDKk4k19Yqf4iywZTZ46L+sHqsyX7N27pApEjfTAyDcdNx8KXoyxvuAOuPxqcKf8+57Ak1t/Om8ZaofK04OGmY/4GrIULecl0l8LvsRvTDG+P+v4VvoAKfoZUwZMx659Mq/Q3dDvFRWOnuT+GGcYFatZoVV98uREfzauWkazDsaEglAzxSysgM4FcTRBEl61U+d42VRbB/YMguqj2VLs/wBaibMyOKEMzoQUDnlV4jyw+tw70T2wpqkZ7HQS0p57tJskXjXyl2e21BMTtz6sMOYcooUlRuExUbznrf8IAjc/4a7IVEXr5Opbx4iBHu7SvZe8EQcop4+9ds33Cs1+0J/VDwTGeCtc0vJtw6DAiwEOr1thVtpbTvww27Kaf3Hjqn1Osxdn4n1s5krkcPU2A8XQsbdf05vzUI9lR5LJR97FmkKrBS0nD1rcPp/u4WW18NpxjVyNKNacx3BE6/CKkQ36PiTwEBXAEIq4ZrK/kCdpDoEx2sEMV8Bfs92JAGNaBcLmTn2qsIq+PzwlY3iC8rAnaEpctmnUbyjNZk8IDJvZAp5SCcDf2qsXfGUp40qwsrVy5xo2Q9YbvcOucN9M2epC8OZuU5+g0YCojLonAFIBpLm/1//gEDC66JEZJ1Eq/nZXTUoe9NSxjN5+Ax7JRzydz87EQlY2kX4aE0kT9jd87245TPkHn9J2X6D+DffonqFwN0MucPKrRWpYsffzzRwq4242FuLkn1zBWFxXq0M2cZ4sFFuh67ZwZhAtGUAz87FNRn4TUmW76tqY3Mx+i60JL/dqc7eW1KhjQK+nVX6n6nUWSmWMiCLpRaJcF3SiTseKp+OAao9bV9EYr3OW3Qtdjxeg9HeFfXq0D54hL5fx4T3ZBfWOpks73oK2Y1tbHf60eiiQlqcG5rFWrUPaXqvAweIrXEvAXz0XOd2hB/1meW8O
 ka00DhoU
 Y+qnF5yQFORmcHBXYkdqoS+S9PFry7yt4KiCD5Z33Z8QGxEo7QwfqL08T3htqkW3Sh/advdcYjDjqNHZd6hegfUqibOBtq77HVPUJmbgaeAYl0kMqOmG8KVpoFd6oe4JBDc2lpPCcxuwMZV66uMAMi4oom7Z6p/TtKov5KlsjVN1s1ILV/+ha0YvE0+n/bIFADvXozuWma/p9wH+ZZFtJp+t/UsIrNzuHRlh11eo15FkU3HbjQz6xyQyoiWsnDmTMTVgn4VK7TusRSAdY17dpx5ZNSscwK9FTnbL9OvojnPtvA8gAnOv3icHv0+S3Yk4Rz3eheu6vDhraHWSLm8eM+Z7feUICQx3Y4tSsexCRy7ZiOj3vb7Qr336MnpY6kSuDIMq3KUGEivwcWT27C7vG76yavSdkTTy2/gClTNkBOovGoo6uCy1LoLfaJTo6CSrfycnC8VfWcJq9Wy46IlmVLp6cPew0nO8Pz/gcARntuipALyLYSlVPVxh3603eqHFDhjN6e8gVO8n2iSFYhaNg4rphd2u/HHj49nOEedfkoKkqi8kkN8TjigCpZ8ufoWzJ2vtYj51GYfX7NxeeC98fH8+MEDe9auPHssg4uF/FDXTDAZdIJThZD7ivW1qGXSnlGuxLjagtVe/Pf4UEiLrFZE+WwHhu94ABp4jEXbp8sdlLJEz4D9k2DbI0pN6dPr5wOKEntfmm7Giw/OyhTmMyZAiBrb0E7WLiB3JaQsaNZ4eyfVjyQVSs9zfY50sUtKMejXg4o4lhjg9gbJ6N1kcoES3T1uZbC6QP1WHxqobaov5tRf+rUJqLMpvzgJrTqjXnQSxUhcspdfny8tRbtAfeQSRvg7O8eviHZQDJbIcmS7zT6GSyozDfvgFMiFi7OxpTLaLKf/wSqNwBzKIyxlqFT833NxPUqjFWDiUsjTUdS7i0CEmSlPskntgZFu+qRugQb9uh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 10:57=E2=80=AFAM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Thursday, August 28, 2025 4:29 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; ying.huang@linux.alibaba.com; akpm@linux-
> > foundation.org; senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; davem@davemloft.net;
> > clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> > surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> > Gomes, Vinicius <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resour=
ces
> > if the compressor supports batching.
> >
> > > >
> > > > If ZSWAP_MAX_BATCH_SIZE is set to 8 and there is no hardware batchi=
ng,
> > > > compression is done with a step size of 1. If the hardware step siz=
e is 4,
> > > > compression occurs in two steps. If the hardware step size is 6, th=
e first
> > > > compression uses a step size of 6, and the second uses a step size =
of 2.
> > > > Do you think this will work?
> > >
> > > Hi Barry,
> > >
> > > This would be non-optimal from code simplicity and latency perspectiv=
es.
> > > One of the benefits of using the hardware accelerator's "batch parall=
elism"
> > > is cost amortization across the batch. We might lose this benefit if =
we make
> > > multiple calls to zswap_compress() to ask the hardware accelerator to
> > > batch compress in smaller batches. Compression throughput would also
> > > be sub-optimal.
> >
> > I guess it wouldn=E2=80=99t be an issue if both ZSWAP_MAX_BATCH_SIZE an=
d
> > pool->compr_batch_size are powers of two. As you mentioned, we still
> > gain improvement with ZSWAP_MAX_BATCH_SIZE batching even when
> > pool->compr_batch_size =3D=3D 1, by compressing pages one by one but
> > batching other work such as zswap_entries_cache_alloc_batch() ?
> >
> > >
> > > In my patch-series, the rule is simple: if an algorithm has specified=
 a
> > > batch-size, carve out the folio by that "batch-size" # of pages to be
> > > compressed as a batch in zswap_compress(). This custom batch-size
> > > is capped at ZSWAP_MAX_BATCH_SIZE.
> > >
> > > If an algorithm has not specified a batch-size, the default batch-siz=
e
> > > is 1. In this case, carve out the folio by ZSWAP_MAX_BATCH_SIZE
> > > # of pages to be compressed as a batch in zswap_compress().
> >
> > Yes, I understand your rule. However, having two global variables is st=
ill
> > somewhat confusing. It might be clearer to use a single variable with a
> > comment, since one variable can clearly determine the value of the othe=
r.
> >
> > Can we get the batch_size at runtime based on pool->compr_batch_size?
> >
> > /*
> >  * If hardware compression supports batching, we use the hardware step =
size.
> >  * Otherwise, we use ZSWAP_MAX_BATCH_SIZE for batching, but still
> > compress
> >  * one page at a time.
> >  */
> > batch_size =3D pool->compr_batch_size > 1 ? pool->compr_batch_size :
> >              ZSWAP_MAX_BATCH_SIZE;
> >
> > We probably don=E2=80=99t need this if both pool->compr_batch_size and
> > ZSWAP_MAX_BATCH_SIZE are powers of two?
>
> I am not sure I understand this rationale, but I do want to reiterate
> that the patch-set implements a simple set of rules/design choices
> to provide a batching framework for software and hardware compressors,
> that has shown good performance improvements with both, while
> unifying zswap_store()/zswap_compress() code paths for both.

I=E2=80=99m really curious: if ZSWAP_MAX_BATCH_SIZE =3D 8 and
compr_batch_size =3D 4, why wouldn=E2=80=99t batch_size =3D 8 and
compr_batch_size =3D 4 perform better than batch_size =3D 4 and
compr_batch_size =3D 4?

In short, I=E2=80=99d like the case of compr_batch_size =3D=3D 1 to be trea=
ted the same
as compr_batch_size =3D=3D 2, 4, etc., since you can still see performance
improvements when ZSWAP_MAX_BATCH_SIZE =3D 8 and compr_batch_size =3D=3D 1,
as batching occurs even outside compression.

Therefore, I would expect batch_size =3D=3D 8 and compr_batch_size =3D=3D 2=
 to
perform better than when both are 2.

The only thing preventing this from happening is that compr_batch_size
might be 5, 6, or 7, which are not powers of two?

>
> As explained before, keeping the two variables as distinct u8 members
> of struct zswap_pool is a design choice with these benefits:
>
> 1) Saves computes by avoiding computing this in performance-critical
>     zswap_store() code. I have verified that dynamically computing the
>     batch_size based on pool->compr_batch_size impacts latency.

Ok, I=E2=80=99m a bit surprised, since this small computation wouldn=E2=80=
=99t
cause a branch misprediction at all.

In any case, if you want to keep both variables, that=E2=80=99s fine.
But can we at least rename one of them? For example, use
pool->store_batch_size and pool->compr_batch_size instead of
pool->batch_size and pool->compr_batch_size, since pool->batch_size
generally has a broader semantic scope than compr_batch_size.

Thanks
Barry

