Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BAD3F588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBB26B0088; Mon, 20 Apr 2026 09:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3066B0089; Mon, 20 Apr 2026 09:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8F06B008C; Mon, 20 Apr 2026 09:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 816CE6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:11:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D7FB13BF5C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:11:19 +0000 (UTC)
X-FDA: 84678970278.01.EC71975
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 370F1C000E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:11:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jm8qTwlB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776690677; a=rsa-sha256;
	cv=pass;
	b=tmT+A8rft11DsQNXOUAO40gdkbWgOMKLeLbGUis7YOwSXtqiBkxwPOtago69wqfmbtEDf8
	Ox0lDTzzjMdrOofbO5D2I00SjS9cOyJjkIBdh9velnF0+zGTKRLjnaj67tgE8akSTxhw+j
	XFKICR3Mb90+q9Jz6LeTAY1B11DeJN8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jm8qTwlB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776690677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FVwLkQx8K1po5pri2al0PpGhu0V85k3MLpduafsc+s=;
	b=Pj5lfAblM0OiW77TWyHmp7gALhtUksr3r5oYdrlwLE4xXSpXBBmzeO/HEPa3oQvlhk5MO6
	q3L0TfH861zV/a1dz2Nspc+dgrqAb2EY4H5ju7Uj1+C9ELBsyh7bwdPP7W0pGOWvWFlQKM
	XKA+1WDB+k/l7cLwzoDOwd18F0P1LBQ=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1270f10a774so11791c88.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:11:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776690676; cv=none;
        d=google.com; s=arc-20240605;
        b=jlWCJD78N/CP/bafg3krLhFgvn+IICq3p7OyiOjQV5YZvXiA35+A15wyknqitKR4xn
         WncVEW8mmeedQJcA/anKH0Bt9DLw4Co2wNBN2cC51w2s/etTMPZ3t70JbCrSDDoWNTLk
         y0JToPIqw0E3MCSa24Gz5DAULExl6JtOuCG53DY/Zpq+C9d3f+2CKjx9/j1Fgs94ii79
         YU0FIKmui8qPhm73/vYg3EZXSTjQlxnhQv9ed7f0enbgQz9+dokK2mDzUO82pVfxmbwm
         bZ5zo9KqvZ61z7jUaFsZ/lKR8wHJz/QkPk0pcChdOjTGrpb8grZpJSN/TEYP6dG/deHo
         CreA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5FVwLkQx8K1po5pri2al0PpGhu0V85k3MLpduafsc+s=;
        fh=8Egj7IWGyckalusHjPTZKk/6LTeIwas2BL+DM3NuaYs=;
        b=kwL8xfybXnENp0Tsp7Oi8QFjk1+4Cz4/X2BDsf0UHkDM2Y7TCKSpW+lTyObRMe0mPc
         biYOkhxo8RO01Wrq0Aq0rsQ1twG0W8y6TAtfnzEyn4iEqrGFMreHx/RULsWjlR/NUWct
         sr6c/t1zEzuoYezM48pVC2DNxIVYFaAJKrxPqAQn2eEacl1t3SNb7jly+P1lae0BDNrN
         VxxQGaz1354Nw/D+DJpaxMtsfDnv71x7wYf4cPO446u6TblTO96do1UXK6jHnb8BKWqP
         xVHHoDuJlmVU+dAhgTg2a7UIqzm39QVH8hO0cqoi0WVCweBHEEwWOOR44r62HAQW/k56
         o31Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776690676; x=1777295476; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FVwLkQx8K1po5pri2al0PpGhu0V85k3MLpduafsc+s=;
        b=jm8qTwlBZlsJyuGeEVIRiLPnNtw9LW/+LQrA1cnta1PiFvUPiisRXM7hGSqFwMuvti
         zBDBfZwAZCRGI06lLZgXUWHv5v25NsRE3/CrR9OB4SjrY+XVrk9tiACOp0TKh6UsHOuc
         2j5yrnyNV8yxxq2S0GKMe4VRrsdXndP5so6DjLchVXU/II/c58is3WHejz/9azIfLzdU
         fmKoWkLlV3H+y/xAJUliHhA+iS0FqZ2yK/oIvgknzCUjHJ21Lu3FyY++94QdG9pGCR+8
         FGhtuzMh8nnnsNF8GfzFAr9gff15UX4vsAY8xAqvQC5YcI6ne3Jez+T+Nc4svB/eFQUv
         zUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776690676; x=1777295476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5FVwLkQx8K1po5pri2al0PpGhu0V85k3MLpduafsc+s=;
        b=N8smasdVXIHQYmCUTz9kDB55thx9ImM59WTBcoXQfhDfPwD3OSWvX4iyVZWW91i4JB
         TKtjiylbRMWw8F9vacSg0G0zg9Q4S+xtjUzzQEjdDIPQbUY9wYRgm7HDdVKo8pvLVTZp
         XUkPNC9avn/K2vhKNYUiDRc9WO+lQHlHuwyoodbWRz5zbatW7rKJBWy82C0jTMi2TPLO
         H8gRmLAExAaAfEZAM5WoyXiBfs2kt8iJ5AUX3O1oDUo2+1ktigjez+14tEyrVQrxpGwU
         AfVLrKSdOw+Z0x9yUWS5znlTthdiiXiqD0j0AfS7kU1TGS22JlovEFIaxyd756CbG7OG
         GuMw==
X-Forwarded-Encrypted: i=1; AFNElJ9weCSwpCQmFQ2P2XsWJO4ES+nLkhsmj0ziSMQMswkQlARmm9OKnBdJA2cpgdFflGmPEsuWZKgToQ==@kvack.org
X-Gm-Message-State: AOJu0YwNm/J5BLwFkqez4Iej4FteCf0aDBbQ1f3SPAkgGMi4lR6k5O9C
	0sszV24pPcG9tY6E8IQaYhOxZJt2E2klIcx6lMcZ1vVGMGn6EU/98ev7iZcrzuPzJpECpovnJwN
	jhiYHKAo/p1dVbWpgUbWPOE7G/CelUv+0H/OGbDLe
X-Gm-Gg: AeBDies26zPpT4v73q5xtIyVXR02m1A6Tao+450I69gXhMTBwA19VZ6rdjAPtEpvanl
	77amd04Tfrs71x6u5J0X0IKdLslEVCSkW9lijr9I57qGiz70UVgHBPewBZxKLIPT3X2bUL5x5ca
	aq8eW/nzSZNyHnGvUj9cOpYsBRgDeyMtPiqiXarLxevWx5VSw5+OAFspI/TmZdAyLFDVUUnhznE
	1loIxKOdrXDgU8seZameBnKYuVVclPkCWfQ/uiMcQckKbuO2v7S4kaSJKkd57tajhccD3e0kU0T
	AWGO3soNaQS/dmrCUvgVgjXNXRdGctUVpmWMZyqC4TqegRt/jg2Ya7Et8HE=
X-Received: by 2002:a05:7022:7f19:b0:12c:8c69:8f57 with SMTP id
 a92af1059eb24-12c8c69912amr48697c88.21.1776690675122; Mon, 20 Apr 2026
 06:11:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com> <aeD2Fzr6yr4pu9-X@kernel.org>
 <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com> <aeEKksfLxQ0A7Jun@kernel.org>
In-Reply-To: <aeEKksfLxQ0A7Jun@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Mon, 20 Apr 2026 15:11:03 +0200
X-Gm-Features: AQROBzB3QuDSyAD1D1K_U7KpKhvC1Hwu7IFcApx7uCWmoXxgKHNIl6UKX4G9oas
Message-ID: <CAAi7L5cp3B0DFEQex5EqFdLDkqVWwRw228-pgp0PnhfgLP=e6Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: zyreq6zx9qr31ipff17gzt7ypctne4ax
X-Rspam-User: 
X-Rspamd-Queue-Id: 370F1C000E
X-HE-Tag: 1776690676-981678
X-HE-Meta: U2FsdGVkX1/wrDnlciUs03elhKTxOYVbPojZOemlqE8ZUaOrh3r3cJ/UmGXy81LO2VfJOLn26aatKlZOdpQCNNsSLLoCtHxC1PyoY87rHyV9ZmXCaUCncuzWAHhG7iJ5VVlCJ2zXX2pRbZ5DfCHvoMXyK0GfBrAukKDPVOFWMMGBKJ5xYB+1gwuEm+ELTisEOb2B1alUipivGFfGZKc11t3NwvS705u1n3X5SiZqWBd+ol0JuE102hKgj52nvjIUEXkdD0/Cyt8LSnSudRo/qDnSABnQx4J7XRjURwpcUcfn+8QZYDy6JhRVi3+lCRkkfteFUMUHuDswwHW7JGoAVjA3m+KvHLmNCY82bMSht+rP8EhIzuDu/zphdqOaKy1e5lehBIJeyXKVN3X5tiRiCdmN0UU/QavAwLMOZBvhZTb2GkfyOuAIfyVbIQaxjLP3E/zbzOc5Ct2p3mJcotdpKJp7VRHPsNnTY0VYlcJNg9qkGxj3uGEHYDYBPd4POsS+zdIM3oREGh+60J/bCtSCQdaqN8hJ1VO9G39mzSJ27BWli4eviwe4Cgfahw2WSi/eWVMO521aO9wx63Hgs9ZSD9jC0HE0bzfVZszDkkuR2jDXvWmmXDPlESpvKYW6O7c/T4qTNlVLGkEdbIYXHmj2/7w7EqAp11ysoMT56sYv+vH9hjARfHQkqkPuhk36yVpnrRrCJlAbHxcL5gHZnK/IRdmuH8PABx4+1vJ2+4LOb0pyD8dGXL1k2nNQOdyFj8ddTRH71R1jeOsGp+mVXpUq3DP09iARdhwnp+sYBMhF72NCvmd8v7TMTraXE2NeMfZwVE2FxSwt1IppJrDMcSNaYyN7XuGrC5M8z4pFrRh1jAHAufDbmVmzf0B9tX80oSyPEP/nHVPMvldwsxdhpAA0xWjTDvnJtpzWp3WxjaLr9EHeUJJ0lLTIraeyP16FhGHf6ZOX9MGRYWZC29rbjZl
 RgYDTwJa
 03qL14giKswBKDIu/fxsfkCyUFuHJusma8CbQbZm8MKV0QuaBrD2k34KUhU5Rh9O1N+nCB286vTD0dOnslDuSNcR2wRySkGLdGhaPT2nAlZFa4Mo9lIyPAeyahOSRhBdl2Wr1P2o+HQcEaejnTlJjOcU2hSodSDRvzuMGx64W8qL9/8mlJ3LyH6A02Kw/q2mtd4BYfDVXv3m2adLX2fbHAczWn1hBEmDZSMFU6h/mhI+5dzfQWoaZkjkkOJLcVHj92lCJVYLMsFMdeJVe18FnhV/3kVzVkdsSSEYrTPIoka7IZ4Pn9vqhIw8aEQzmQtUB11JilrNPvJSdmyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 6:13=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Apr 16, 2026 at 05:06:10PM +0200, Micha=C5=82 C=C5=82api=C5=84ski=
 wrote:
> > On Thu, Apr 16, 2026 at 4:45=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > Hi Michal,
> > >
> > > On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> > > > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_rang=
e(phys_addr_t start,
> > > >                * access it yet.
> > > >                */
> > > >               __SetPageReserved(page);
> > > > +
> > > > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> > >
> > > No need for #ifdef here, there's a stub returning false for
> > > CONFIG_MEMBLOCK_KHO_SCRATCH=3Dn case.
> >
> > In all 3 places the #ifdef is there because MIGRATE_CMA might be
> > undefined. I already broke mm-new branch in the past because of that.
>
> Hmm, that hurts :/
>
> The best I can think of is to add a static inline in memblock.h and ifdef=
s
> around it.

Sorry, I don't understand what you mean. What would that static inline cont=
ain?

> > > > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> > > > +                 pageblock_aligned(pfn))
> > > > +                     init_pageblock_migratetype(page, MIGRATE_CMA,=
 false);
> > > > +#endif
> > > >       }
> > > >  }
>
> --
> Sincerely yours,
> Mike.

