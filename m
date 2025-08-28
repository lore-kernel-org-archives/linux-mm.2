Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D19DECA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 21:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF7B8E0003; Thu, 28 Aug 2025 17:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FDC8E0001; Thu, 28 Aug 2025 17:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EC08E0003; Thu, 28 Aug 2025 17:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 817208E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:39:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 025B3119093
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:39:44 +0000 (UTC)
X-FDA: 83827483530.28.8C46937
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 27F3940006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:39:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVoqlxFM;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756417183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egeVb4jL6h5nFyN9xRw5wQS4OVht2YfrG8JsM55WIk4=;
	b=lV+Hcq28aX+0fLLbPvxaThTKWWwAaTvptf7nsxig3exHshzWYD5wEhihvjFLzl8ozdkwlB
	cyhxkGLFi6lwvi9isXUSw/moKpNFJmnYcP/a2jhmyAnub/836i88I80zi2RwOyxWQcOdwA
	6bnh5fD2di4WkugeJ06hpwV6uzg+mKY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVoqlxFM;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756417183; a=rsa-sha256;
	cv=none;
	b=buvk2amiuyDAH9iSc9JsrtO8UkHW1XQ4y7aFnb2LUro6qAnDdEa35rymRiCNZvi9S90foG
	tVE78E/MwwXoLds/oTeaVOsWScugc2ErShb5pHvwO7SjziMRsac5/yQDRjjO6YtIcaORP/
	ouvE6HniGlaQ0LjTcDdvR2Qqd0O788g=
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5206927215dso495635137.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756417182; x=1757021982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egeVb4jL6h5nFyN9xRw5wQS4OVht2YfrG8JsM55WIk4=;
        b=PVoqlxFM8tz4sEFrvolY7pOQdSolF102ytxuoP7hmJ/dBOl52bYdxbN4wg9c4igYsI
         4WWqsPD+FuZqvHdZ5meWXI0p0BfNfuHPrUaG5uSa6TIamakbGPjRra1hFasPAptcnaGN
         OAyiv5GGyzAe+csLpHRaFNGoTrSlmZHbwv3bqtZctLL6U7V2oLDeAJ46dWWLXuSz7m3p
         3yj3XUAQkBsctVMc3Jed7zW9Uq7FtuJ5bgjXA+KHP3xj3ecEkKXNqp3vc/YtuwiUSyRU
         /r8orFcJfwV6f7+UztrXMXtEcEMnaJ3X9XGVrLyHbmaf0jaAJStSqrifTWdSHRxxtbhE
         3wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756417182; x=1757021982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egeVb4jL6h5nFyN9xRw5wQS4OVht2YfrG8JsM55WIk4=;
        b=UH6/FvGVng22FQNKTlejtDI5mS5Ig6ODa7g5WrCOy0SHH4dqEG4ObOi0DYfEvV854J
         PkpsczECnMIpjz5i9g65vOHiPhRYuZIUWjNA1qrdAIEGEIrHAIOqqRcbtWOIfnifYarV
         Bq16M0BjkDGBjxCMVwy/I4mi0+tjUa/9s2tTN38Gr5IBSg2A+mMdgwT1kzkLYSNafUBS
         wkaFwTZlOqZSAUN0pcdrFwEVkTYCC4eVlZawj2oo4B/lxKkQLXLOS9faSZ4NJWRkyLNQ
         xylATWfPJtih7Olu3WA8O5QMmY/RxCzU09xGcTmlhrrDkulc/NtUsGQV2luJevmbp2eH
         8ABw==
X-Forwarded-Encrypted: i=1; AJvYcCUwy+53ILxNan3ElRshOi3vASOoMBRRsU4roczZi1w2Uw1VA/+l7zInhDAwmCIs6blipcdeM6EWxQ==@kvack.org
X-Gm-Message-State: AOJu0YxJwd/JtuipQ4aqLlN1BtOHo8EbcAJxlgA0GKzEqM+rZGLIsU/o
	+Up+Mupfuau04JptyGvAwpnrGKGfuGRNpKx4r4jDGWNVqp5PjmE9RfvCdHTaBI2VhYLibXWQRsH
	P/t4qAHBFF9GPeUDvAXO0Ydb0XpmWAl4=
X-Gm-Gg: ASbGncvd3gGg3yoVkU3hO1ITHAGGxbTEJwZCSxMXfGcnYyFidyfgky3DXz7gUHhY5zQ
	AGUz+FpHukOcMlsKYLxy0Gs/NqM0xWiYvPSCEX7Yb9UgyIKB6DMhuEmxNcwAIpnggIqstKZd5LG
	duQNrcnl2TjUoZEshCI5o6emUYMoOe1Gn76LcMl7dMUCfvh0aK/ORoctJ/V3fG40ZNUQByL8ijQ
	UwALhXpqoVKY4lE4aiN6/4dIZhC
X-Google-Smtp-Source: AGHT+IHie7MOkNsj8efrQCm04ILQxwbVuLefNNdiQWU7MzTGW0l35HwAhXQIlJpyb1p2xzNAzusa/ZuPiM79Z7UDlew=
X-Received: by 2002:a05:6102:5e86:b0:523:b5c8:2b0b with SMTP id
 ada2fe7eead31-523b5d7ac6dmr4910509137.12.1756417182085; Thu, 28 Aug 2025
 14:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com> <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 09:39:30 +1200
X-Gm-Features: Ac12FXwKgcdDELJZzuofq3TYBazdJbuunzZRTQMwHeFHqBjqIkT5JByIMca79Ik
Message-ID: <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
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
X-Stat-Signature: 3ptuf7yuhu91m6ff5ungro7yqrwtkgep
X-Rspam-User: 
X-Rspamd-Queue-Id: 27F3940006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756417183-296965
X-HE-Meta: U2FsdGVkX18t0IlHhGDJmbRGaB2VfWDlm031LdYkwgGXpc0WrgPYqyLa147DcOdtNKpjQwB/SX6XdRSENPMDjrP2fnI6/bgNGDPxyzP4HZ4ALSmKn1Irjw7MsSAY6anQBi+5ZnfkS7o/qDKKbB3AMarhl9+99LKC4Ip2Pb9y6v9IzWwEoMwETyvNsKj6E8ajHRCGIqMPLjuvFj+7BXj0ajbtOA/QcHCpmL6/eQ3mlspZftlHB/B3xoOsclr9bHjr7rwvvcrN10V0pCTdwnV+/vXVQJrTHWhRQjLKlUjykW6WpdKUhCr/GD+DUHOhL4T+1vyOp3osmmua1zt596Ke/6rYZ+eR8qVfF6D1ED8ZE9rqpkRx//LmUglhk9vh9hLMkE1rWzDTIyvMZomfRJdE2bYtjXcxHVESq/D0sPc41zJ5jSybAIRjmtCu9zmJTKL4NuDSsqlOoV4Wid/BpFaLjsPjf6gpqccXga3A5LRuOToWtHR+wH+U4kMNQPFWudtTenBBpjbw/4k2TmoEqspbPKSZyNSW1PXY94yCIeIeksbkqpcP5FeIZLoa9EX3F0Kn1HaFPIbgSEOhEToeI1vmcupDo6ykq0C1hHyU5vT/UAgOckWpSUBq57qB6kr9JFPOCk8nP+CWIaxT9rZtvZWnnoVwnzSyrha9Uj/Z4Yaj0WOCcF4pIfwhFQQh19k2FNkeLUn/xNCDKBjgHH5uOOThhOVacVSjyl4UFZGEqrnlVqn6x+Gu1YVJhwRnRu7RtmPyWf6PfSPbJYrstjxRebRowrR0ZpzYhaf220SHGemcCA0vMg6u12tz3CZkJTyNjLStGL7jthLg/829NrD/XFqFH7OWQvjxIYErs3KwFYvcqCMN1YiA9aYBLovji4ZUxHQSzoyeRkm0+oagn01veVmC4SrO4Ri17iFgA8GFQKQbM8nZ3LObHjvltlHw3CXtdH3Dk2LS6JyMe5IUIWf+CvT
 l8ofmmlF
 PQOp8JU9JBvrNuBQCJvbw7rWfkaizxCtTgwDhKusOGmQxa1sOlIQomHfg2QU/M6BpzO3t0QXWO/AzSLYQFYxWfTv7wMH4VWKRlfU4UE9CtB2EXWXGgAiQ9XL94rh5GhqbEXLiR83L1eTuZ/L1WpcXAHmEDDlEic4gE92G0xwdRZE8Q3LBH9yzYfCgWUbNZQ8/wg7Hb2uz3o25lEr9F5WtIQAKkqcwImeyaW3pcxcdxI6IGW4ZI8TukoDWnfhTXAfOPJ22MvHFgJVU5IPerNJr/ojheFeRmMBesOw2qYcvKJOGtzsfey3jekmrkflcMrBZm98AbuVaK0bIIFI/9G3oe3QUJADwGPxBtmfGTlTfLYYjrftIBDYyrgb7yAUpSvzfLau/RFCaHblsTHAF1KTZEVpWOFjuOkjacg4aIR1sE3fODIufrIKK3+OL9+3guwjZW4dWCm08Qw9nKfV++8hg757s5gvPvt9IQxONcTo4FNYBkTpaXUBa+RumhNeN3zQ49gM0qEtMOg4RXUI0SVmxLs7hucg+CRVhhmr2KrmrIACVF8BMvBRyf+WwUgqCGGhi7qakfHpeQyGnuJvWkNaDrlh2bKMJeSqH/Xwh8gGrderpz++lMvwnUeSeceTHLY99Mm7z9HQnbyO056xoYdIyt7t04gs6+9jo+SDxpv1cLBBP65tR1tWY7dHBklvbf6GCZot6hSA61551+FKavfiqYN+mNzP0tS+j2wgC/IRbOOvya07IjOVy+EMgkgfSOQ85fwD9Rxapnba27phFBNibTmTS3he/qVXTqya2ssoy3rJBk6kzzVJXCETvVgnvNh+dm4OMxWymtjBA57ILMGgVfKfB7Ar2r76udu5AuoDsAkDk9f2jfrfzNJ3G3k7vFQ+DGSNcAz491tTkVHU6A2quSCiDo8GXkdGWaMkcnNyMHUno7gd56DHXp6H/Pg7lnhePrlpt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 12:06=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Monday, August 25, 2025 10:17 PM
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
> > > > > > [...]
> > > > > > >
> > > > > > > +       /*
> > > > > > > +        * Set the unit of compress batching for large folios=
, for quick
> > > > > > > +        * retrieval in the zswap_compress() fast path:
> > > > > > > +        * If the compressor is sequential (@pool->compr_batc=
h_size is
> > 1),
> > > > > > > +        * large folios will be compressed in batches of
> > > > > > ZSWAP_MAX_BATCH_SIZE
> > > > > > > +        * pages, where each page in the batch is compressed
> > sequentially.
> > > > > > > +        * We see better performance by processing the folio =
in batches
> > of
> > > > > > > +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of wor=
king
> > set
> > > > > > > +        * structures.
> > > > > > > +        */
> > > > > > > +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> > > > > > > +                               pool->compr_batch_size :
> > ZSWAP_MAX_BATCH_SIZE;
> > > > > > > +
> > > > > > >         zswap_pool_debug("created", pool);
> > > > > > >
> > > > > > >         return pool;
> > > > > > >
> > > > > >
> > > > > > It=E2=80=99s hard to follow =E2=80=94 you add batch_size and co=
mpr_batch_size in this
> > > > > > patch, but only use them in another. Could we merge the related
> > changes
> > > > > > into one patch instead of splitting them into several that don=
=E2=80=99t work
> > > > > > independently?
> > > > >
> > > > > Hi Barry,
> > > > >
> > > > > Thanks for reviewing the code and for your comments! Sure, I can =
merge
> > > > > this patch with the next one. I was trying to keep the changes
> > modularized
> > > > > to a) zswap_cpu_comp_prepare(), b) zswap_store() and c)
> > > > zswap_compress()
> > > > > so the changes are broken into smaller parts, but I can see how t=
his can
> > > > > make the changes appear disjointed.
> > > > >
> > > > > One thing though: the commit logs for each of the patches will
> > > > > also probably need to be merged, since I have tried to explain th=
e
> > > > > changes in detail.
> > > >
> > > > It=E2=80=99s fine to merge the changelog and present the story as a=
 whole. Do we
> > >
> > > Sure.
> > >
> > > > really need both pool->batch_size and pool->compr_batch_size? I ass=
ume
> > > > pool->batch_size =3D pool->compr_batch_size if HW supports batch;
> > otherwise
> > > > pool->compr_batch_size =3D 1.
> > >
> > > Actually not exactly. We have found value in compressing in batches o=
f
> > > ZSWAP_MAX_BATCH_SIZE even for software compressors. Latency benefits
> > > from cache locality of working-set data. Hence the approach that we h=
ave
> > > settled on is pool->batch_size =3D ZSWAP_MAX_BATCH_SIZE if
> > > the compressor does not support batching (i.e., if pool->compr_batch_=
size is
> > 1).
> > > If it does, then pool->batch_size =3D pool->compr_batch_size.
> >
> > I understand that even without a hardware batch, you can still
> > have some software batching that excludes compression.
> >
> > However, based on the code below, it looks like
> > pool->compr_batch_size is almost always either equal to
> > pool->batch_size or 1:
> >
> > +       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +                                    crypto_acomp_batch_size(acomp_ctx-=
>acomp));
>
> I would like to explain some of the considerations in coming up with this
> approach:
>
> 1) The compression algorithm gets to decide an optimal batch-size.
>     For a hardware accelerator such as IAA, this value could be different
>     than ZSWAP_MAX_BATCH_SIZE.
>
> 2) ZSWAP_MAX_BATCH_SIZE acts as a limiting factor to the # of acomp_ctx
>     per-CPU resources that will be allocated in zswap_cpu_comp_prepare();
>     as per Yosry's suggestion. This helps limit the memory overhead for
>     batching algorithms.
>
> 3) If a batching algorithm works with a batch size "X" , where
>      1 < X < ZSWAP_MAX_BATCH_SIZE, two things need to happen:
>      a) We want to only allocate "X" per-CPU resources.
>      b) We want to process the folio in batches of "X", not ZSWAP_MAX_BAT=
CH_SIZE
>           to avail of the benefits of hardware parallelism. This is the c=
ompression
>           step size you also mention.
>           In particular, we cannot treat batch_size as ZSWAP_MAX_BATCH_SI=
ZE,
>           and send a batch of ZSWAP_MAX_BATCH_SIZE pages to zswap_compres=
s()
>           in this case. For e.g., what if the compress step-size is 6, bu=
t the new
>           zswap_store_pages() introduced in patch 23 sends 8 pages to
>           zswap_compress() because ZSWAP_MAX_BATCH_SIZE is set to 8?
>           The code in zswap_compress() could get quite messy, which will =
impact
>           latency.

If ZSWAP_MAX_BATCH_SIZE is set to 8 and there is no hardware batching,
compression is done with a step size of 1. If the hardware step size is 4,
compression occurs in two steps. If the hardware step size is 6, the first
compression uses a step size of 6, and the second uses a step size of 2.
Do you think this will work?

I don=E2=80=99t quite understand why you want to save
ZSWAP_MAX_BATCH_SIZE - X resources, since even without hardware batching
you are still allocating all ZSWAP_MAX_BATCH_SIZE resources. This is the
case for all platforms except yours.

Thanks
Barry

