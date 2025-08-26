Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3CECA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 05:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9485E8E009D; Tue, 26 Aug 2025 01:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F94B8E0090; Tue, 26 Aug 2025 01:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7448E009D; Tue, 26 Aug 2025 01:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9068E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:17:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17E671A0662
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:17:42 +0000 (UTC)
X-FDA: 83817751164.11.6678A29
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 41D19120011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:17:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KZmJ4EUG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756185460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6KCkaaGO+9Jn63lszeHqOHrKxFsF7u4XrLjmhxlKN4=;
	b=DMlf7EZGedrGN9q4wMLvVxpwSWdKlvU3HyHoBj9Z6VJ1w0xpqCcjLr2zlAPC5jfiQxYcTY
	VHZXWqh4j9hgEtUtnmr8OxFAsJIaXdOcomMy+vChrOhzouwjNdV8iUZym15f7mV22jj8H0
	mZ9XQ6X7rtGnPagi4H+PbpqPvSf0Lkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KZmJ4EUG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756185460; a=rsa-sha256;
	cv=none;
	b=NhU6W9pDoKyCFGPDVC27CutCDAgoViTMlUh64eE28ZCgsgCv8IL719hopriOc/KXdURfXU
	2TEq3nfjqEDJyG4+bM1TMJ/7IefomtSZeTCp0cCfvuti2/fpKM2ATU/ijxRuETGVEjHCbZ
	rfXXOBlHXjuO7GCKjTTQ+uHU6S+bdps=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-53b171c1e82so3642500e0c.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 22:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756185459; x=1756790259; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6KCkaaGO+9Jn63lszeHqOHrKxFsF7u4XrLjmhxlKN4=;
        b=KZmJ4EUGYr7xRhSZubA7DzFyDhijzFfLfm3F4vP0Y3lZqaM/70wkDQritS5EyEkZES
         S8CH/S8Ft7tVPyP/OIts/bGA+wRqskPbmGmKDtunLbQqm4WVhS7GtWgk58IPY3i3dm/Y
         YW2kxY8NJoak5zMgauTv7MBkFTe0b1l5xssXNyb7F2JK5XUb1oaFPZI0eVET9Jz6kpiH
         Z4TOVHhByRdtoI9XbxZAUTN+pcbh6k79Kt/uq5K0r5RYxXFn1smIQ5ft6GMeMBdgVeSq
         DJwNTv38hDAfBIpbaOVNtMjg44dXgzt3g/2ZCCDnrPRKkutq6iKB7dg1DFmJtjw/OxXu
         i8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756185459; x=1756790259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6KCkaaGO+9Jn63lszeHqOHrKxFsF7u4XrLjmhxlKN4=;
        b=MTSo+W14lzfMhYYRGCPaVlG7vf98z1+YUZqzGWen5TCP89oGxESGaXEn2wAA7/DjM6
         EU+g42hUy/coaLWIuEO38Adm2WaN4vIB7MjiCz7l4zEOO+dvmZwfLXFQVEetoBNXCuTt
         YRZvFBpJaQX2bh6+oW9xJ6bLZzGLj9r3Y9o6rPHRdHxxT9sn4JFBYueFm7u/0t91iQlf
         b+ysbDXpJHuyDnjriW+jFwPlSc5VVPUidiOjRiqYltt6J3Mg2ZfNPq9LqGME4jufj1kG
         rqRS9YM+n8B2Ehsmk/Czpq/PbplIJeilfynnrIsa1Lo8kZp1oGdPVt/1oq84/zAYH24T
         uI0A==
X-Forwarded-Encrypted: i=1; AJvYcCW5ew36OQnkl/0gYmqOHkpQzHF2Fnv6L5B9vubjMoC1nznZTAtOAE7j45OMEY+qmNi2OlgWACNT7Q==@kvack.org
X-Gm-Message-State: AOJu0YwthRIav3PiXzqqdf/orzFMMwvD6/5pf/pZv2a71QBE/GIseXI8
	ZaCPaI/RfReP6AkzOOo/ll5eWpkVi+AYoS7JeSEizSVDF0gdAtvDTzuZJJUF/+hRQb4rwCaVewN
	k6fQBhzI/LncdMaXseU1KHi+F1R9hQUk=
X-Gm-Gg: ASbGnctjN+jC/eKaXRpbWQCEsINu7lirPyPyb0xhdUueWnUELg/DF9itlJaSOpoxjzP
	K/BncMKirmXFW5LZvU6hjg59Q6KJyBU8VIAtxoLLHwFPT3+mRFrr6Gqgph4SGG5RN1KG7cLgMGO
	4LfH2Ex0ndqAzGNSnkmBb34NCYqma3B6dvevGQEtXmfgmW/0EcQic4AcVOJTd2bUFbfi1zMhmGK
	g38pcXVzlnCity1SA==
X-Google-Smtp-Source: AGHT+IHW8PFR8+zVJx+H1F//I5Djns1GfxpRAjFWm2T8ulatbw+PZth3H+Z/Iuy2+xO6mHlBSstorcd9X74Q7lUd+ls=
X-Received: by 2002:a05:6122:3c51:b0:53b:174d:98f2 with SMTP id
 71dfb90a1353d-53c8a2afd87mr4059919e0c.3.1756185459220; Mon, 25 Aug 2025
 22:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com> <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Aug 2025 13:17:26 +0800
X-Gm-Features: Ac12FXwFLemTCGqls7xpPBf9Ugl5TECSEyLNR8RUZl5ccfrj7g2jmoWvOleOPpM
Message-ID: <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 41D19120011
X-Stat-Signature: 4hdd3x4jx3k18iefkhpym6acq9xy4b3z
X-Rspam-User: 
X-HE-Tag: 1756185460-686005
X-HE-Meta: U2FsdGVkX1/V7XgB1TXGkIiSqkPDae7tagebEEtp6hChAgKCDh+UGikxqFasjVHshFBN6okEfZWX3/PXNi0dwWMHVMtV7iWFBHfqzAYbGn00OY0JMcT7ufmtwM+UiDrslnLTlkew3djX23FKX6i5I+I+MydaQ9H7bOxCLjdTXzuGZ6LE2sEuhbFNRC9scrFN4MYiP9adqHMAbILhoZLBHyphkpY5WRYtA0goHMPail3/uA91kSbPYTIv/oilLQiuO7xUa451fYR41upf8Qz+PMuwYPWH1K5GAgwkoc6bmjF76A7zDyyWOnLVfSqhFQtr3uwh+dql1hoK0+9CbbT1kwrcdFqxS4mCuXrz7DHv9VtSIDFl7HFcmuRNG+fddhmoU/acL5LB4tZ0W/l7n3W5BJA518hcSF7twlwQViq3OyIY+zvAzpcgMuz4d/nVUiZ+LM7MfY2AnkY12C5Q6II6Z0ol5ILrBL/xESv6NJPD8Sr5dKHfcxS9MC0zkNjDyjDipZFjro0hak1vKyydJc3e8AiWM6A6Bl8BbjS67kWOt2mkBykxqwrBsOgniM/oyN/CXeXul+LWAHiFOO6jCzxuNKLS4dshzvEzJXjAWi9l+61bxkyDJnozZlv1uFmII5Ee31mu7OADeNN0tQmlY+/XgFoZADqjI3gJljzkB2CYvEsTAKTJphPi+fekIqASAiz/pJdwyhOyPqY/fz6/CT4LzdQv84JoPSVH4JALCwAyic0vTJAH8aZ7M+8hDRROy/2SK4FJM3SQcanES6dwBJmv6tLkJgQLcIgRWqAqzRyf3Ch+bbdk8tVuy9KDYbpoRIkRjcKV87RyeFAvp0I4Ny/cjX0GfqK+qXScrwbR+TJ5a5c4IX+PvGKvn5u4OUlxFiSVaYMTmqF1kNi6PP/ffnhfoW9IlybwgGJpNiXGQKdynBWfgDHMulC8FrEj205H8iKsozeng00elZdGol7zzrb
 hIdhLWrx
 HrDMS7CjRKcXMYe8qNlAlry7QwU1cBcP7MJDKRn1HXaWdWjrg2/iYR6gjVSR4WR94oej/9tXqOFFazGn4QjNR/wSHdr5D7P9sXxxcJWDFHVqkvfrvQWiFIl4Z1KeJQIK0Tyk9jAX5tKvJa2aHdw9gaPUlgaiDM81SjKgQC3XL45IPAHGar2B69s9D1b3SlFCROOJejIwHEMKYkhRjkZ/k0ERaWM89IP9DJdw2KsXP/LwiU1IiREcPvzlhDSHDHfiuf8VRNIaH8gD6Mw5i7/Uyvtbhtb2T5cTo5Gf4wB1a0BoXNoACpTUGICXhKkQHCV3OpJKABCg1M2tzEeOZNqkI6wWK1qsOtr0PjKpcOXnGsNiATd91IQtoqnxPXW4mImownUGINTCWEWLotLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > [...]
> > > > >
> > > > > +       /*
> > > > > +        * Set the unit of compress batching for large folios, fo=
r quick
> > > > > +        * retrieval in the zswap_compress() fast path:
> > > > > +        * If the compressor is sequential (@pool->compr_batch_si=
ze is 1),
> > > > > +        * large folios will be compressed in batches of
> > > > ZSWAP_MAX_BATCH_SIZE
> > > > > +        * pages, where each page in the batch is compressed sequ=
entially.
> > > > > +        * We see better performance by processing the folio in b=
atches of
> > > > > +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working=
 set
> > > > > +        * structures.
> > > > > +        */
> > > > > +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> > > > > +                               pool->compr_batch_size : ZSWAP_MA=
X_BATCH_SIZE;
> > > > > +
> > > > >         zswap_pool_debug("created", pool);
> > > > >
> > > > >         return pool;
> > > > >
> > > >
> > > > It=E2=80=99s hard to follow =E2=80=94 you add batch_size and compr_=
batch_size in this
> > > > patch, but only use them in another. Could we merge the related cha=
nges
> > > > into one patch instead of splitting them into several that don=E2=
=80=99t work
> > > > independently?
> > >
> > > Hi Barry,
> > >
> > > Thanks for reviewing the code and for your comments! Sure, I can merg=
e
> > > this patch with the next one. I was trying to keep the changes modula=
rized
> > > to a) zswap_cpu_comp_prepare(), b) zswap_store() and c)
> > zswap_compress()
> > > so the changes are broken into smaller parts, but I can see how this =
can
> > > make the changes appear disjointed.
> > >
> > > One thing though: the commit logs for each of the patches will
> > > also probably need to be merged, since I have tried to explain the
> > > changes in detail.
> >
> > It=E2=80=99s fine to merge the changelog and present the story as a who=
le. Do we
>
> Sure.
>
> > really need both pool->batch_size and pool->compr_batch_size? I assume
> > pool->batch_size =3D pool->compr_batch_size if HW supports batch; other=
wise
> > pool->compr_batch_size =3D 1.
>
> Actually not exactly. We have found value in compressing in batches of
> ZSWAP_MAX_BATCH_SIZE even for software compressors. Latency benefits
> from cache locality of working-set data. Hence the approach that we have
> settled on is pool->batch_size =3D ZSWAP_MAX_BATCH_SIZE if
> the compressor does not support batching (i.e., if pool->compr_batch_size=
 is 1).
> If it does, then pool->batch_size =3D pool->compr_batch_size.

I understand that even without a hardware batch, you can still
have some software batching that excludes compression.

However, based on the code below, it looks like
pool->compr_batch_size is almost always either equal to
pool->batch_size or 1:

+       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
+                                    crypto_acomp_batch_size(acomp_ctx->aco=
mp));

+       pool->batch_size =3D (pool->compr_batch_size > 1) ?
+                               pool->compr_batch_size : ZSWAP_MAX_BATCH_SI=
ZE;


It seems one of these two variables may be redundant.
For instance, no matter if pool->compr_batch_size > 1, could we always trea=
t
batch_size as ZSWAP_MAX_BATCH_SIZE?  if we remove
pool->batch_size, could we just use pool->compr_batch_size as the
step size for compression no matter if pool->compr_batch_size > 1.

for example:
       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
                                    crypto_acomp_batch_size(acomp_ctx->acom=
p));

Then batch the zswap store using ZSWAP_MAX_BATCH_SIZE, but set the
compression step to pool->compr_batch_size.

Thanks
Barry

