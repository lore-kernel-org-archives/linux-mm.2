Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F77CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 01:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D920C8E0005; Tue,  4 Nov 2025 20:13:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42588E0002; Tue,  4 Nov 2025 20:13:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30C98E0005; Tue,  4 Nov 2025 20:13:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B19B28E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 20:13:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 454ED14010E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:13:04 +0000 (UTC)
X-FDA: 84074779488.02.B5B5812
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CE1E1C0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:13:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gSbFzpyb;
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762305182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEppFMrKLaYig4LQcDZc9JttD0i9i7R12SVoQFz4438=;
	b=kGCvd7A/1i1SIXIDjYgsfpGGXGs9KkAncvg8+s/quW8MuElNJOLyT28uk5qG71r4xMcdy4
	VI1r/s5OcmkP3kdc48gBfC8H4C/HN3TfM54fZAao6fH9TTkvF6aAc4hBt88erW0QiRqGBM
	Ok4xxrNeywEElbKsDqCXelof302zmeQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gSbFzpyb;
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762305182; a=rsa-sha256;
	cv=none;
	b=EPzyFHKKVSnhnkQF+U9ih0LeJRvi7Z7u23vn/SwGR/2ObSlwEwc19juDEu7pBlMSrqAdi5
	06Ooxz8owb2/P8FIrkSl3+0qyp6XskNcubD278cFeEUbOk587F5CGxNyCVVcFf2cfhfYHj
	QacIIoq3O7lAzXlCT2iIMAhT7utmrWQ=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c2f6a580so1003742f8f.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 17:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762305181; x=1762909981; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEppFMrKLaYig4LQcDZc9JttD0i9i7R12SVoQFz4438=;
        b=gSbFzpybkUflMuKPle2ipFB7d+/iRyn3yJHST10B8IsI2FMzCenVlzLuQIdfwtVpcA
         34kWKBcDCh97z87W0f8l5MKf8gWutX1oYGqKXvyuYGH87qHw67Bcoi8NmXlT+NG07RaQ
         hJCpkEwThBxKx5wOJY8Rh372yZ0aPA1T61Aq8f9tVwN+6eMcmxThPxGjC4YLYXc2a+7v
         RHh3p4Srx78NNz/8PunEPdf8h6ofThUQDEpRfEm2RGWfwPxmmDlBgqdhnCCHJk1ka3Yb
         b6vKa3vQVYKvnSJYzECGlmjrLVhNnF4PL3FfJUbGqKFUgrjuRU+Gs50cisWtdd22iR/m
         QrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762305181; x=1762909981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EEppFMrKLaYig4LQcDZc9JttD0i9i7R12SVoQFz4438=;
        b=pNzRTcz+9KAe1e6j5UR3V7mU6vKYjfw4JM8NbWRr5QInpKSZVG/MvkX6zI5p8HjbZe
         3B0FQylA6O1EVopgIFlGiCmQwXDp+TkqfSLvqiyOCSVdNJFgF+hxfYLd2dBkr+qVDw4T
         BOG1/7ENJ9n3bpK/r8QB+CDurxu1rtOjv+jlIw7bbeiVO21BlMYoJIk9yqQOPaWqdO5I
         AAeiyzucyebDibHRVv/eAoTSZM177Sj0yyLxT6LcCR6JsgyhpLYt1FcL+8bK5B0EAaEb
         OchL6iGPPgPtDZ1qfFq48zIB6QJSePAnxvft+N4+lcuIQeUAP6DgRNr1BH9LinxgOaen
         WQvg==
X-Forwarded-Encrypted: i=1; AJvYcCWNYNpC6DlQnuNLV26Sb4otofDLTjoWu0ftu9vJj6D5u5krpkrxwi3cZ66i0R6gG7CA3nJ3NfaZdg==@kvack.org
X-Gm-Message-State: AOJu0Yyg6Ox5p2rc0um7hDLDAwsbvwXHdQPMyj1ggMvSPolbtm7lrp5c
	7Y/mY9WiPrefiVc4HI8QUGG34Iab/m0ICGirpTgO/PZpLto6I4SwLZQ+zWTOg2zXjMwa2Q/MYQq
	0IKouTxOcO5WJuim1qnppZjvBum8DVR0=
X-Gm-Gg: ASbGncs+FOCyj9OwkWYeDJOYzUKYC3RsNBwmpC2OW0IrOHK5szYEgkLPo5siU34Fvxd
	EJswS45NLdmhy8feqUIENpH60cEB95KvybOBRYswNi+PkxbonOMwfCczM/qaGFMTY+XyKLa7Krc
	1fqoWmG9V7Tc8gMuQMnGv6VbwClGfIToggllQx6P3tcTKTImuqTgisvzwy5em3hhlsyWC36mFA5
	OZU0+rGxDplcOjz8A7y34eF0H2uvnVi3orBNotuz6ZoaEwANhX9G95cZqt7s4eL8CBtsnIB7ntf
	XjxCNCeBJKAb1eu0u+k=
X-Google-Smtp-Source: AGHT+IHCfgX3Z/LDuYoZSbqXwRjysY8+m7ec0N9w0xsi4VyTAQkq2Kw1AUpHu8Gn9+Htyk3mcPXjzFztaSDlGgcNE8c=
X-Received: by 2002:a05:6000:310a:b0:425:76e3:81c5 with SMTP id
 ffacd0b85a97d-429e32e9294mr950863f8f.17.1762305180706; Tue, 04 Nov 2025
 17:13:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1762267022.git.m.wieczorretman@pm.me> <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
In-Reply-To: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 5 Nov 2025 02:12:49 +0100
X-Gm-Features: AWmQ_bnQFmPxXQdMPzkfEOvXBlnPN2_-SgGdaVU5DLbX3hNjDp0f9mJkSXaOTEE
Message-ID: <CA+fCnZefD8F7rMu3-M4uDTbWR5R8y7qfLzjrB34sK3bz4di03g@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7CE1E1C0005
X-Stat-Signature: xgrjtxz1c7qnjyezcn46hpibmq7hudqt
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762305182-925617
X-HE-Meta: U2FsdGVkX1/lwH3KXgsSKY94+UKDsJ8Pi4tvYMFHIpaZaZEcEuB/6NulAcaq7rTO62Xp5o3LOrqy2hIDhwylDiRFPQxihV3Fd2WaBlK8r2WJhvIKGdYm/Cp2n/j4U8uGqzOPZVgEb8wWI82z7UBAUNkHxNtAJhdbgqZ5zT0+r748NU8rZsPrmLrjwewUqQl/8DxkPvQ4yHDVo2Jm5WQe0/JBycqzjh9MV//eTNMFba3XHMUNWHMH7ESI/pkO2gzjZVUfhxsbVcjoSp+RtfKT/ziw4+6FXJcf9+RUj0qXXn8seW31GhtRc2UMkKVI/6xTYb1bS5ftefSPtf/+zBJzA1C1xn5pg3k6Tr3FSb9o1zKpquzWppSvjMfYUTUtrmCOtk7GoxfUYbtWKQemnT17TIjcRUAyNGJyQoaPtsAttzfiVJ72WsU+iR/ORAV+XEzDHO58qg8SyGhfBHQIQV5pPh2Dd7M1WPQNwAU5VZUCOadSL9mRSGBvsVBBPYaZUcuXu4B3CeeHcFhHY0V6y1Omshrl4Dux0mCStNcp/wDFYqqpZ0cegGUNUUip9ybC/uAgUudtJFQc2w5g96J+dqAizH38lHEXzQuBVldcFItrm8vudldpOc5Jjvdv3D6fb6QRvXw/EbQd2uyQ0Qf5UJqkocGLQFt9nz0GNTr0mcCbKcfuccbXyXzAdPsF+bIQ6AIAfymFtRvVa9HUIMFockk+r7IataQo7zhcCC99U9kadb1DeAHqDqmaAvBXaOFGbeO58+lIIvjIi7qpJzHxcUGKM6D2DA32s8zd6BJUSiyihJzS3SsEuFelIO5psE/JCjGb5Lbgp3VNDTeeOtTO3iAms2ZjvtwZwg8IJdGOI2WS2xfDrM1ILSPelR6OvmUgi5X0tOAl8zNZKbLsCMOb3S0Ib4XCF6xMmZ2y0c3RgIWHibQXDV2eWTjRV9jr6Y9KgwvoCDLAvN+M/yaOHiHpaqx
 EnNwLfwG
 0p9MrP2CFHsfiSayIYf8MSnf76ueogHgMQhqJ2MIfaLi2js4e5icP1U0mjU4e9alC51FfIoUgslEgc0r7yAldal9t3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 3:49=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
> It was reported on arm64 and reproduced on x86. It can be explained in
> the following points:
>
>         1. There can be more than one virtual memory chunk.
>         2. Chunk's base address has a tag.
>         3. The base address points at the first chunk and thus inherits
>            the tag of the first chunk.
>         4. The subsequent chunks will be accessed with the tag from the
>            first chunk.
>         5. Thus, the subsequent chunks need to have their tag set to
>            match that of the first chunk.
>
> Refactor code by moving it into a helper in preparation for the actual
> fix.
>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Tested-by: Baoquan He <bhe@redhat.com>
> ---
> Changelog v1 (after splitting of from the KASAN series):
> - Rewrite first paragraph of the patch message to point at the user
>   impact of the issue.
> - Move helper to common.c so it can be compiled in all KASAN modes.
>
>  include/linux/kasan.h | 10 ++++++++++
>  mm/kasan/common.c     | 11 +++++++++++
>  mm/vmalloc.c          |  4 +---
>  3 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index d12e1a5f5a9a..b00849ea8ffd 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -614,6 +614,13 @@ static __always_inline void kasan_poison_vmalloc(con=
st void *start,
>                 __kasan_poison_vmalloc(start, size);
>  }
>
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
> +static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct *=
*vms, int nr_vms)
> +{
> +       if (kasan_enabled())
> +               __kasan_unpoison_vmap_areas(vms, nr_vms);
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> @@ -638,6 +645,9 @@ static inline void *kasan_unpoison_vmalloc(const void=
 *start,
>  static inline void kasan_poison_vmalloc(const void *start, unsigned long=
 size)
>  { }
>
> +static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int=
 nr_vms)
> +{ }
> +
>  #endif /* CONFIG_KASAN_VMALLOC */
>
>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && =
\
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index d4c14359feaf..c63544a98c24 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -28,6 +28,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/bug.h>
> +#include <linux/vmalloc.h>
>
>  #include "kasan.h"
>  #include "../slab.h"
> @@ -582,3 +583,13 @@ bool __kasan_check_byte(const void *address, unsigne=
d long ip)
>         }
>         return true;
>  }
> +
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +       int area;
> +
> +       for (area =3D 0 ; area < nr_vms ; area++) {
> +               kasan_poison(vms[area]->addr, vms[area]->size,
> +                            arch_kasan_get_tag(vms[area]->addr), false);

The patch description says this patch is a refactoring, but the patch
changes the logic of the code.

We don't call __kasan_unpoison_vmalloc() anymore and don't perform all
the related checks. This might be OK, assuming the checks always
succeed/fail, but this needs to be explained (note that there two
versions of __kasan_unpoison_vmalloc() with different checks).

And also we don't assign a random tag anymore - we should.

Also, you can just use get/set_tag(), no need to use the arch_ version
(and in the following patch too).





> +       }
> +}
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..934c8bfbcebf 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4870,9 +4870,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned=
 long *offsets,
>          * With hardware tag-based KASAN, marking is skipped for
>          * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
>          */
> -       for (area =3D 0; area < nr_vms; area++)
> -               vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->add=
r,
> -                               vms[area]->size, KASAN_VMALLOC_PROT_NORMA=
L);
> +       kasan_unpoison_vmap_areas(vms, nr_vms);
>
>         kfree(vas);
>         return vms;
> --
> 2.51.0
>
>

