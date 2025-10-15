Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E1ACCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646C18E0041; Wed, 15 Oct 2025 10:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F77C8E000A; Wed, 15 Oct 2025 10:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6028E0041; Wed, 15 Oct 2025 10:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30CC08E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:19:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 057481DC86D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:19:49 +0000 (UTC)
X-FDA: 84000557298.10.8D8EA39
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC8E210000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:19:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EQD7IUae;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUApJ/d2jv5ytp4hpBk/UGF4vKaPuPbb12BM57vyuxY=;
	b=zi1MbcuIfcvMoutjh0VOZdk45EGbTIuEHRX6WLdkGRlvPcM47QcVGEz40OQ9bBnU/6RatL
	OoRHH88Shcv5l0jUJYyv62/g/FQsmCr59mGbgep8P7CrXInTr0TTGIWlL7lgl868w6ogPb
	ClJoHE7ghMNLq1kgFrXyH9huRpT5J3A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EQD7IUae;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537987; a=rsa-sha256;
	cv=none;
	b=jTjPAiYsfBc833Gw+pLJXSNKVW3oFKnTYGJTqNoJnJyckViP7/zoSmpfUCp1IgdBFLHVEG
	1PJe8oNVNan2QOMT9HSvIbQxowpxMmYtb+re/Ecry6rH93wlDbFmsaLamp7AHkt+MhiDCi
	jiZTGnC4Yu0K36BltCJi4KDkViWXch0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-639102bba31so4633762a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760537985; x=1761142785; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUApJ/d2jv5ytp4hpBk/UGF4vKaPuPbb12BM57vyuxY=;
        b=EQD7IUaeGTwjQqAeEGKWLszN2I2ymrwbSwouhl2JNpLL/u2O+SQ0wKVYMFsNhqaMbB
         WESORn/gRXRqklaF/Oyc/JjOoHpKtkVJE0uokKOw0XQaX8YY3RgVcikrY2IGdaK4yZtm
         3or4/q9wjmG959rruj4SfAfu4cKYuxly9ATwGfkqIZ0QHa9wgty+tFtBYoNtSgrOQaRs
         W/CAtnWcZj7iaNhMsrSVanpjrDEoJRWeBiz/3cA2GC3NgCPr1UMXA0YJGlONe8lMUkGU
         sxnig8yBnSKepxxWH2o6xBHiIAEwiZnxa7m2nFVq65D9eB/y5PSvKXOOdsuN98tXrqhQ
         fe9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537985; x=1761142785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hUApJ/d2jv5ytp4hpBk/UGF4vKaPuPbb12BM57vyuxY=;
        b=mVGlFGlYfGbSnbE3pqr2uP6LtJrxCyJSVQgQ/Qu9o7Brc2kPIZE/Lypce4bMoDBW7U
         ih3aJGZN5KSqD9Kdu3NoGQnokC58gAhqr1hmrmnzdUZB8YFJkhX4tuztP0h/PRrAshY7
         iQXlJXfqgUW/c9Zj970Zloc6XUGhd2j1l5/mkaLVwJYye8GJ+FGlW4pr9ckXtOH3en43
         ARxFxScU5PrAXtRyvxK6fhs8HkpNlH8i9Rx/vvWtPKJ0QroTZZhmsPhDdRkFahYb9Xpi
         PP57c5+6Ss/y9DOvkx6cNKFcLCqkr98Upppb9TEeJMLkwX5iqi77aZqRrNOM1PjZd1wa
         XXEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUd4plwjJqsFZIyMw4+ZsmY/wt5P8TrGX4mYFVQ3Idy52ekeKLS/kRZ8roLRu+7rGepufRHUHmqQ==@kvack.org
X-Gm-Message-State: AOJu0Yygq3zruxVjxcxIYXbrp4pFpMIY/hE0/pedlXwWUqNtTmq4/6Jd
	usyOvZWvjY0cWMsugOuHo/it2PABI9KWp9v5kFDdFip51/vmABv/yLpnLT0b5Dq43dvNufc9ATT
	XRvcdxRA7YaHRoq4wlkfFEtIOTaRxsHg9BCA+a0VAeg==
X-Gm-Gg: ASbGncswLgu1fHNJmiSWk8+HWOHisiseFtZVC/q3o0lzKLjnwg/c705U5JSR9AX7L2H
	6u2B545OlfZ4Av9xEpwa8lQlfHw857bApL3cOfuYCow7dGCBFwdQIQePMFelfyvhrtr/sg3TwO3
	6bACiapJGw7cnbmq8HpHfNaNtYmcQDBKGBf1O5qhuFVthYRINWHre0LBBAsreBw4ci6kXDXClOy
	sdTdcnr2y8Vtuu4OfnwgDuH9GHPK/2Buw==
X-Google-Smtp-Source: AGHT+IFgvnWABvFp2YO4aybRqOy0KXXsuvYtzVtzjFu719w6HusoLk54zzREdfAYZlsXpNluTDl3s5anm94ec20FQEM=
X-Received: by 2002:a05:6402:5244:b0:634:544b:a755 with SMTP id
 4fb4d7f45d1cf-639d5c3294cmr29350078a12.19.1760537985003; Wed, 15 Oct 2025
 07:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <mafs0v7kgjoxq.fsf@kernel.org>
In-Reply-To: <mafs0v7kgjoxq.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 10:19:08 -0400
X-Gm-Features: AS18NWBj8W1b8VguIoFufUrvIsQUXiGHkQ32JE7FqsyGBasY6kmjvm5a_9MOZ2k
Message-ID: <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com, 
	glider@google.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o65quh6eujy9je1zddu46fqffkp3s4g4
X-Rspamd-Queue-Id: EC8E210000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760537986-706630
X-HE-Meta: U2FsdGVkX18GW1A4R8fFLbN2iltSGsb1QdrN//3bqoWcLPaGJfgTNxBU9GcRjNGIUCTr9h++ANv+D4XIeIni9dzsqeER9y1HOEf8WvcSeS+oVmG84UJsPtThodoU6aAvGrnnySFjLaF49jMu+EbC7s2BdpWejOTTYwS+PeL3lZHUpfCXKZh/0IRYFDo+NFes7PiRwLNcVF95ek7M5k3kCV/0p5TWAseNjWNCfBaxDpO6xEQG3jgAa3Gb9+Xa7bufXX29pa07T2EVBs1ZwdknnwJ+DiX8+ZgV4LE8MMpn/5QZdQSoV9IYtFVWDFQHIHJpA7rMpxVu08H4llQtK4GL64xGVS2WlJ2uCs3BXWpye6EWRUxVw2PEF6uSLqeMaRxguVj8m0g0/9ZGLmSDgKm41A1YAvbnFTcnWM35nXs+DOaPaDlXJ6Bjo0RL0lqzUtqIV4jdGMnWRUJ+6U15yuH2tbTYpbgXVS8Zz2qd3UmPgd1KP2/36gIMPdTXDddoC+V29mQLgO3n8xIcTrhaOYR85vKEviTiYin3zIf2Gh+oWSYN4TYF9IIXEjUtdGyUrQl2He7wSO+pvLi1pkJpk1R79svZ7cFeyRLRqqprxovyCzaFgiOwGFJ3hjBOUNYq0S1itECvLC+mBIeF8C5zWcu5HT7F+/RgHWVA5U0PtbF3xlpxsi6tzKRPRrPMWQUgHMYH2vOTrCJsCw/RHEWT612qgqiQampSwUjv83EASjve7yG3jcp63nUmhmJiwe5McjdZPqlCAGWnvzG6BWhOExPJINzrFedqxJdVDFcQIHAIjFfRl+IIKUDnW7WcnxkHA8ra4/UOa8fajCMAb3dFaisIOUgjc6jri+JGGCwmiuRoPwrce+6UVn3oMZoj2j6hAjALTh54JzPtCHBQGZztEgXaHznOtlsYBTdYu27iYUeB/dlsnKueXRXFl4X2qkGjGnzRRLq0dC61S06UaZ5EJEH
 TD2bdkpr
 R9DXFifo7w9/RpVhoT9JqlpkUgpXtn9q0WpRyAEPBhy97xVFkht2j+XbpybdpqKO43Tqsy7pxg2dMiHmLVZg4n0kp4Pl3sgqFszicuVd4p1ANoDMJ0ixj9hooa+XrQ6Mf/EkWBw3MlIo493uHpc1IGz8UkiCGNew6uzhuuRgEjyZu41gFzYoLRoS8I5t3emUiD0eDYsG6pBHryp31mdlqlrr9Yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 9:05=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> +Cc Marco, Alexander
>
> On Wed, Oct 15 2025, Pasha Tatashin wrote:
>
> > KHO allocates metadata for its preserved memory map using the SLUB
> > allocator via kzalloc(). This metadata is temporary and is used by the
> > next kernel during early boot to find preserved memory.
> >
> > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > randomly intercepted by kfence_alloc(), which services the allocation
> > from a dedicated KFENCE memory pool. This pool is allocated early in
> > boot via memblock.
>
> At some point, we'd probably want to add support for preserving slab
> objects using KHO. That wouldn't work if the objects can land in scratch
> memory. Right now, the kfence pools are allocated right before KHO goes
> out of scratch-only and memblock frees pages to buddy.

If we do that, most likely we will add a GFP flag that goes with it,
so the slab can use a special pool of pages that are preservable.
Otherwise, we are going to be leaking memory from the old kernel in
the unpreserved parts of the pages. If we do that, kfence can ignore
allocations with that new preservable GFP flag.

Pasha

