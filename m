Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE842CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468628E0099; Tue, 26 Aug 2025 00:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440198E0090; Tue, 26 Aug 2025 00:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356838E0099; Tue, 26 Aug 2025 00:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24E6C8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:42:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDCC6842BA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:42:24 +0000 (UTC)
X-FDA: 83817662208.12.0CAA2B9
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08F06180013
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:42:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cctg8uqX;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756183343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QeuOW/tAwdKvRds8hPNWFHvxC5GbUoV3RdzaFP3jJI=;
	b=wL5S79nzRIDWl6O6k/d6lajZgbgIxZfu8lOPKat2uAzJ03+otH902Hc9mUp1u3Poj7Cllo
	8HPqAdkekFal/UNQ2+20ch58VKcC+fngAYXASQcl/4zkCvWz8g//qvp5rjt4bQhjwnqbfc
	wVKZDXNtlEUOipHv9K8E/KReTyFUELo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cctg8uqX;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756183343; a=rsa-sha256;
	cv=none;
	b=2LMAGzJjBRdZxTdKqWZBOfaMCmFpBBJ4+mJXaMOD0QRmxDWoMpNtmR3ZnzsMlU93NPHUbs
	LSfMP2IvjC4hxnuE3L+aNLea3WcK/ccMQG/4flriEtJx6TnMs39xWcqfHtk/DiP1VuIrOr
	28Szf1TVAXFQ7OgeffDaaI+b1tr9EFQ=
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-89018eb083eso3088458241.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756183342; x=1756788142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QeuOW/tAwdKvRds8hPNWFHvxC5GbUoV3RdzaFP3jJI=;
        b=Cctg8uqXcjQRu+zhiAbe7QzDiVKBWMgPTVVEtL4hkyIBrGbHczHQ+lD2nue5TMfL4m
         RTThPLmAiWn4uyNE5/pJWMBQdYhzl5zay4QsmyKKZeHa4TuHIU81J2gCp6nsIjui5EGt
         4cFT1BCg9aPUkplhlKDyZq+MXrI+J8zu4Yif/1GVJpPBpHc06v/FxuM2qaleIaoHuUfH
         W/604xRgKVte/RTRzEtpDAZCyVYtVDeMwz1WzVQ3RvqvjEaVZ3JyBIluMCRMY7+gQQBa
         nDLDCaX6fQ9TxefcrJgQd5d+MKgEO66o9vRdyauAYc5x9L58PWAeK1WgxJGmHRuroVDA
         Ym8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756183342; x=1756788142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QeuOW/tAwdKvRds8hPNWFHvxC5GbUoV3RdzaFP3jJI=;
        b=u+7F24EmKPp7kE30GAlf2sSBFBIcopqFE5eWVCB0FCZw0LkLNY7ZH6e87X0Xvv8kQY
         dJ2P49Lm50MpuqHjE5ospLEw9u0gHbAAo9HVt5r8qhImM6CPgiJyqOJzddZ9hI9yy21D
         lpOTdk4E6rZs8Xl2D2LriPWFuE34EgZQ0gFnJXADjqmC4dd45K4Hj6nUvdtIm1LGkAFI
         fBSFhOLSm+Adywr0J/+pJNZPsxMnH1SwWhnxCmCorhYZs7RzW7Lwyz4lFbElXCgVxxUt
         zOrXqJOxq4OWKX1jSUSv8EELdBF9uj3AboRdV2Zngyo5gFSFw7P+bwcaZpOcbpeeUaxU
         vCmw==
X-Forwarded-Encrypted: i=1; AJvYcCV8MHZxftS3pIrxAvGXpNSXcMcH4y1T+bAJxCnlLNDb1VNy2MXGknfByHAa3HX8YjthgkfWjLwjIQ==@kvack.org
X-Gm-Message-State: AOJu0YzBnfxU53J5Ut4oHvAIs0jIE39q2WbMp2ybzGMir06UAzzqV3vC
	+FKCm71J1/wqyp3rSW1EbJ9ng+6MGHSZ6Q3FFqk8Qf1Mf2fkN9Ve13zPFi893DePWEB3Co8tBcS
	hziPW7HAjBBI+D1Zr7WS4tFfdRAk5zb4=
X-Gm-Gg: ASbGncv4rUQxmgT7uvyqjFDbsDTCmsie2MrS4XA1rNUgiWdxI/kJfRcX1e7Atbi3IQ8
	Ix/JXqNaVl8m66Xh+2RewH8BA6SEvvybaPbvrotWMxsvsDIzAGdECf5pW24RQWdmPu/ZGPhtd9F
	Q85GYV5K2klEDWKT/lLxzpmb/9me+vCicrzI9mOExow+pPM354a4uGBu9AfcqXmGFEGDf47/tTT
	QYA7zJdoGVeLTaj2g==
X-Google-Smtp-Source: AGHT+IH5b0xCIWtqEG+h9ra5vWc4g5n84Q9ziHeF9o3vOHY8vzNL1C4z2v2bOjHCTTM16yDC4g/RAi16yBCVpf9ru9A=
X-Received: by 2002:a05:6122:896:b0:53c:6d68:1cd7 with SMTP id
 71dfb90a1353d-53c8a3f18f2mr4610648e0c.13.1756183341907; Mon, 25 Aug 2025
 21:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Aug 2025 12:42:09 +0800
X-Gm-Features: Ac12FXwIVh1CBUbWctN1hUqXXVlFsJoqPjkIW5ijU8kZiggqZfat8Ckeul-2aTI
Message-ID: <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 08F06180013
X-Stat-Signature: htgu9h6t4sqosxawnjs6afp8eaxxg9en
X-Rspam-User: 
X-HE-Tag: 1756183342-318630
X-HE-Meta: U2FsdGVkX19hrr7F40VUBAzly2amDYc1d7VcvRwG0bpyEU6EQ2+96OiWebU6zd7dp8kAFd6OhQrHVhf450SE1TzYdO14CzRTLVIBVhylHsMU3AlooTkym6zadBdg76qH0i9MBBo1KpDDXcTSMB4HGiSJRWE037EU0nAXKWdiXxSdBFWniLPJbhrNwfhh9oW525qOS7xNeziN3OJRZE2wRZQOjTL405Z/rxGyDSoNvS4jRuqUO/pQnPGSX1LotOlICHUNdcTYD81GhEJBAsvZpa4faHgwkZqwbjIWOg9YcOkVI5zMAzJizo74TE6wwM9GqITSNSqvjK9qRLEBHTtOFZu1QTrkdrfkFxjbUH2Dx9CNhm1kDV6IPGssgNUtmJZwtfN82Vv/6Wf0jonq9K5ENph5dkyJEwstC0JPjGaMrzKL6IS1EpEtkKXc2pehspPEW8Xb7uxJNjB9/mE7gtNZ2FLJChhMVEsoe1yIoRrVkCVmMtGyiB0q+61sn5pUM/uwVWbu2PLjn0sQwUakz3QFdlgltASwVH8yMVuJlf4duB4Ghr8Jmm4GIy4EoiVwVz7/wbE9O/TLV78uJc5drAF5GEVRalBOdaKR8DKCajsWxf6lGo4bBm+VnjYELX/i8o7ILJLc91ulbV1TnHirR0lOkPLUfLdY6JuCtz88NG0WHbPxfUZwG1SKt61dn7duLPJVKciFA6I9HUmg3dLvtthgBJjsc9nTPD85OvFrl92+yuhO8N4WDCvrzFAX0Nxl27w+1I+dD7y/AoFICT9egE2gAo8k05rdoNUzNcV9aUC6rM3QIIuyjLOfB5XLUb6cGTpReP3XQBQpK+N4rox5gEY2LWnmut6KyMKWMl4a4Onic38DhvnJstrDQlf22WvuE0bCrRYdGd0DhuuqPNw+ygzJUipAILGaJZqn45uL8G8edezxItIu1A5l8rgKgsikevnV0x7Zfdm+XiHWP2PsuA9
 DTfPpCpA
 yB2/9RBipnCCocaAUEOR3VPI7GQ4H5XOe+LULrvB5ZH8uuv6rsWyTc0qwGO6KKOPDbAUBcZNjpOlWBXFn85NepJDxw74eJD7JIahnR9tet938lPokZ+EmctqFmQWnwQ7Xb896Z3PY43ofKmy28EelK8CSPhuYtyI/9bKx4VxWdaXrDWMOJe1SAuMTb/hTzqpwbtB6EBKvgGhWnUmsY/TFGiwIQke/dYt51kRwAFgMJ8cAgR1CAnVz5P/AiH70WdL4VVAmKumilNqp+Rn2TUUT8Chd8Dgi64XWAzOuevjrbthIgXKg37Pwn9hvh1l/MRkrBLENcXdia3hWtE1Pu+4v26HAUI8VSv4ZMiWUOomRfKKDihIZWciWVi+l9U8CFimoTpEqHCsgfJEpjrLrBqm0dCordmAL6imEesKmEygg1hCGv1hFMRHbv1jMzVRCHOZeBV5MKyIUZH3i2RBFm7xb623rJuOhTz6wJP4mSd3YynTxrMPXBg6/M3DqIHOObyUJwMIS6vit96KAIEQJm5w177gBtmqrhpij62M8IY+HHFLvg9jC0K6CpeVm353D+jcC0ekvOOcIwUMQCJUfu4tFPC2ggb4JHA+lurfM4jiBbVZnbUj9tdHtLUNUvgXV/vvSoxE/+stGXX8+S0Ato0TZfruz2czfOm+UtfbozPo169hV2yItS7c2Hm19MVpcdOhVvEfLKkLoekui+xMmbp0DsjxFbLqSkm7Nd9CZ9coiPrAWCOnrel1q1/jbxuL+9JjRu/PFCYVHGp0UkyLDzW+ITkPoB1BYeQhH4NxKVVhsVN9NWrh/cOHP0JAJ8Ay8pmhEOlPw/0jopjus9gE7bXkzmOXtPTP8O6S3EXPP7T8pSZ2EBAPu6gWx89G+mWqd/abjv4+SI+++35TelUhB1T0yjQJ4g5rlzOs3cM6Y/ixBH2Dxh4u997YFWR6xSOrsO+7bBfzQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 12:27=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Monday, August 25, 2025 8:48 PM
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
> > Hi Kanchana,
> >
> >
> > [...]
> > >
> > > +       /*
> > > +        * Set the unit of compress batching for large folios, for qu=
ick
> > > +        * retrieval in the zswap_compress() fast path:
> > > +        * If the compressor is sequential (@pool->compr_batch_size i=
s 1),
> > > +        * large folios will be compressed in batches of
> > ZSWAP_MAX_BATCH_SIZE
> > > +        * pages, where each page in the batch is compressed sequenti=
ally.
> > > +        * We see better performance by processing the folio in batch=
es of
> > > +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
> > > +        * structures.
> > > +        */
> > > +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> > > +                               pool->compr_batch_size : ZSWAP_MAX_BA=
TCH_SIZE;
> > > +
> > >         zswap_pool_debug("created", pool);
> > >
> > >         return pool;
> > >
> >
> > It=E2=80=99s hard to follow =E2=80=94 you add batch_size and compr_batc=
h_size in this
> > patch, but only use them in another. Could we merge the related changes
> > into one patch instead of splitting them into several that don=E2=80=99=
t work
> > independently?
>
> Hi Barry,
>
> Thanks for reviewing the code and for your comments! Sure, I can merge
> this patch with the next one. I was trying to keep the changes modularize=
d
> to a) zswap_cpu_comp_prepare(), b) zswap_store() and c) zswap_compress()
> so the changes are broken into smaller parts, but I can see how this can
> make the changes appear disjointed.
>
> One thing though: the commit logs for each of the patches will
> also probably need to be merged, since I have tried to explain the
> changes in detail.

It=E2=80=99s fine to merge the changelog and present the story as a whole. =
Do we
really need both pool->batch_size and pool->compr_batch_size? I assume
pool->batch_size =3D pool->compr_batch_size if HW supports batch; otherwise
pool->compr_batch_size =3D 1. It seems pool->compr_batch_size should either
be a bool or be dropped. If we drop it, you can still check whether HW
supports batch via crypto_acomp_batch_size() when doing compression:

if (crypto_acomp_batch_size() > 1)
    compress in steps of PAGE_SIZE;
else
    compress in steps of batch_size;

no ?

Thanks
Barry

