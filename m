Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E241CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864908E0005; Wed, 15 Oct 2025 03:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815918E0002; Wed, 15 Oct 2025 03:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B238E0005; Wed, 15 Oct 2025 03:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FCAA8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:52:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D848413C166
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:52:10 +0000 (UTC)
X-FDA: 83999580420.23.7FD5069
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D200E1C0012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:52:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dscn2Apa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760514729; a=rsa-sha256;
	cv=none;
	b=yHBcwXNbOP/enJSztceNSBR/Kkyo/qrZB6gmDosKECTOkYR8xfaby0wityd500qgw66H6w
	/bo2FwQQcthtpqhdgajjzSXAS2O/Lg4mzxAnf15ip6H65Jkgx7O2YWTpszUcrRf4p9Rth7
	nOT8VOZHOY1wUMF274mKDHUIBi6h4TM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dscn2Apa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760514729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0kxyBGabssp0rzho2WuiuH9lwTWVoSTEFB52ILRQDA=;
	b=MO7ddIT59Kto98Bsq416Q98+MIZGN4PMMkoL5J40b7IN3ORF2VlKUoFMEgkYVqif9WGgCH
	ZfDGRNhl5uxhcBosPOB9fLAIUUmT1jZBECljUQedKGUfyeqhg27f5pchm4kroMclUKIvEU
	BetAcdYFjYRBl+OZn9rcX0KQKPcf6+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B66954923F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96709C4CEF9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760514727;
	bh=Hk8FceSWL5r86KoiYChN7BiB6tlnUBYhdKKUtKnsBf0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dscn2ApaBkuh8EDk+NNw0Ct2slio/sqp/Dra1L+qTikaYBzhvDstLjLWZXHXJ2tT0
	 6uiCCAmA9ZqQo5LA69iR5c7Bq0PxD/SR+MzxAHIhcXUIrOKiiEwhX7ixX8fnhzZjS7
	 D5awNVe0jKY+x6aAkrmgY49xOIGSo+4iCUgSBK/DItRVgNez4EXDhkGEcTOk2OasgF
	 5EKA46AgxJlk6B6gVFDEsFZpyu/4kzSHmPkpZHA5wbidVffvwRl/WK9rQAteKLOg4n
	 7lLU93sKVh3SySgrtvME+3A6aJogBZpES+xuSfvxxz0iPCljqsAqeBVFpn+Rt+XQ1Q
	 Te8I85OgVol0w==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46fcf9f63b6so12292865e9.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:52:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXHCDcDOG2Eh5SXK+2YB1VBt0q6bbJ1aeDoogmggAaiwyNdmqRxo4mrCezeaXW5pdurBcvauw+3Ww==@kvack.org
X-Gm-Message-State: AOJu0YwZb6rCMMuZo65yWsn9VJf7SfRmR1VvBhVAvjubCB3iXgUVt7qb
	V/G5546zaDdpNP6AaEmvOCbvru7jAkph0GA9rffvzX9RuhR7Y42dzky6EN+rJ8BYZy0SY36MTjr
	x8te7bIi/pIJjj36XeEcVDU/M6T4/Oy4=
X-Google-Smtp-Source: AGHT+IEFaI3DZoRnbvDOhvRmHl+9oaMsWgpyEGx60mmVrJHDRbgxKRmZRxoBncYFiUSnm0OF0Il58OANJPKeCxbOxCQ=
X-Received: by 2002:a05:600c:154a:b0:46f:b327:f20d with SMTP id
 5b1f17b1804b1-46fb327f2aamr130646295e9.26.1760514726025; Wed, 15 Oct 2025
 00:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251015064759.2993842-1-rppt@kernel.org>
In-Reply-To: <20251015064759.2993842-1-rppt@kernel.org>
From: Guo Ren <guoren@kernel.org>
Date: Wed, 15 Oct 2025 15:51:53 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTgG2DhqLC2B6URsNusjzcwCaxi-k=MUZTc1FTEHbaf+g@mail.gmail.com>
X-Gm-Features: AS18NWC3MAeshMbUqk61Elrq_2rSWAMD4mfkq-zOY9A84heCjfIMCusAIOWNVzY
Message-ID: <CAJF2gTTgG2DhqLC2B6URsNusjzcwCaxi-k=MUZTc1FTEHbaf+g@mail.gmail.com>
Subject: Re: [PATCH] csky/mm: fix build errors cause by folio flags changes
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sedz17h1y19oguzoq7pj1qhqqcr3rofs
X-Rspamd-Queue-Id: D200E1C0012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760514728-857811
X-HE-Meta: U2FsdGVkX19Pk/vuunA9xCV8+4O4tAJgRQ2E+F9sFpbbfJyVph6ZTOH3gPRO3Y9awGjbcORfpoisOx6Uz3w2GreWtIQWKvjLclvDsujwTBYjrA8Z9fxYM97l0B4+yEp8022+goPAP3O/iQY8JwOaOFGyvtJLkJlhZiERFrxlkK7LX/9oZeaJRp8iTWzlLIvsZz2XGcQEXtCd1eWdI/zCM8ZIu44BeIMONh4RbTHHmOIcnJsoRWUmC3raIOhf4/3MlI01eo85e2rhtDkm4B3VgG8Yx9ILnPkBf36yKj9sQ1lBBq523d1kFUUfvFPU//ez34YJiyFwBIkTPTr056xlgVTUOrKpRu/ZNijZtUgeutnycleIrvM4AC5qUiyrKpryuaeQfETxI0bGfjR1gbv1nsvInz59f+AzpnUj+kixCAbCZdYACAhuadt2k8m0pVVvAgRqIrTGDoazdrVkyncnaVDW0oyVfgTKWU0HKfgZLFl3UxqnL9MMLgP7aien0Vg7GY4UCMXp2LJLc6tqLEricy3MnmhpTnCKy5/SDb5ZGD3PVB10HXYKdIRGWvj86hsv/efC687DlLui6LF8cEufwDWCkzH6ogogqwZWtn0FQdBvNks+9glauCKEj3/s381O9GmXkSM9aFmiqzBPGLGmHQjM61PCnE8VSrMOHnnB5EshUM0DjqTKouFSb5EjnddqxA8KmiSv3Zw55RY6RMlLCcC7XK0f2IYowjhY+Ppw0SEVoeEs3DhxnqS1kvG4W9fiLR34W2m14hGJMs/N52SRwMxQdSGxZwlCR0YRgphLMYRrHKeQzqDZ+rSQp997t4h8S/OwHdOLWRjYJ+XZtVkw7pnmIl08fXHNdZhoy3ahNhzDoKPNAFelfD7dZjgMwkKVqawnC2UwHDiWwpFOuRKAeSS5MMe8CP4mhBCr3tAmXYeqCajIRDbI/cdqpFmmbDWpL2BUByHe5YEVEena3dK
 ylZJU62k
 Xuqa8pALipRCO/2nwZR//AW6/kzQQBmstSuBkBAm/tOh+dQNpO72dXET4KkoXOUrpZy6w4g6NSL3qL1Mgp01bRsot/tXQ/EVrlWljChw7KJsWQdWPaY9s+EsqwZfmwGII9UYSFufhYyP4FSy7cQskc4kIp0nw2YcX+JMJ97PaVQk46h6KGx1lOkJo/arlpCKktF4OtHsvTmdL8P+C+jXg2V4tixY5J06l73xloR3pV/M8OGZG3oXil9mRnOWEoI4MdahNWTT351+m7xjnkyJa8yPYSnXSkZJT5rkGIhettSkrM8ORZVjglv2S1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the fixup. If you want to go through your tree, please add the t=
ag:
Acked-by: Guo Ren <guoren@kernel.org>

On Wed, Oct 15, 2025 at 2:48=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Kernel compilation on csky fails because csky was not updated during
> conversion of folio flags to memdesc_flags_t:
>
> arch/csky/abiv2/inc/abi/cacheflush.h: In function 'flush_dcache_folio':
> arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of =
'const_test_bit' from incompatible pointer type [-Werror=3Dincompatible-poi=
nter-types]
>    23 |         if (test_bit(PG_dcache_clean, &folio->flags))
>       |                                       ^~~~~~~~~~~~~
>       |                                       |
>       |                                       memdesc_flags_t *
> include/linux/bitops.h:47:24: note: in definition of macro 'bitop'
>    47 |          const##op(nr, addr) : op(nr, addr))
>       |                        ^~~~
> arch/csky/abiv2/inc/abi/cacheflush.h:23:13: note: in expansion of macro '=
test_bit'
>    23 |         if (test_bit(PG_dcache_clean, &folio->flags))
>       |             ^~~~~~~~
>
> Update references of folio->flags in arch/csky.
>
> Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/csky/abiv2/cacheflush.c         | 2 +-
>  arch/csky/abiv2/inc/abi/cacheflush.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/csky/abiv2/cacheflush.c b/arch/csky/abiv2/cacheflush.c
> index 876028b1083f..064b0f0f95ca 100644
> --- a/arch/csky/abiv2/cacheflush.c
> +++ b/arch/csky/abiv2/cacheflush.c
> @@ -21,7 +21,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struc=
t vm_area_struct *vma,
>
>         folio =3D page_folio(pfn_to_page(pfn));
>
> -       if (test_and_set_bit(PG_dcache_clean, &folio->flags))
> +       if (test_and_set_bit(PG_dcache_clean, &folio->flags.f))
>                 return;
>
>         icache_inv_range(address, address + nr*PAGE_SIZE);
> diff --git a/arch/csky/abiv2/inc/abi/cacheflush.h b/arch/csky/abiv2/inc/a=
bi/cacheflush.h
> index 6513ac5d2578..da51a0f02391 100644
> --- a/arch/csky/abiv2/inc/abi/cacheflush.h
> +++ b/arch/csky/abiv2/inc/abi/cacheflush.h
> @@ -20,8 +20,8 @@
>
>  static inline void flush_dcache_folio(struct folio *folio)
>  {
> -       if (test_bit(PG_dcache_clean, &folio->flags))
> -               clear_bit(PG_dcache_clean, &folio->flags);
> +       if (test_bit(PG_dcache_clean, &folio->flags.f))
> +               clear_bit(PG_dcache_clean, &folio->flags.f);
>  }
>  #define flush_dcache_folio flush_dcache_folio
>
>
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> --
> 2.50.1
>


--=20
Best Regards
 Guo Ren

