Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC75CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740E56B0011; Tue,  2 Sep 2025 13:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7178E6B0022; Tue,  2 Sep 2025 13:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D196B0023; Tue,  2 Sep 2025 13:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51CDD6B0011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:27:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F37BDC0170
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:27:15 +0000 (UTC)
X-FDA: 83844991230.15.E599B10
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 266ED80006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:27:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2f5jS+04;
	spf=pass (imf30.hostedemail.com: domain of fvdl@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vtd7VHBua4ceoiPNxCebsTr+W/5i6xNmrYZ+hl6cZwE=;
	b=bIJNWjCTw+leKhlLzGvOUb0fmqAERcHnowtk/kJbR8BsIdb//x1WExI6esaWoXkrE+Bukh
	VXMBi52rvKPjU9fqabUzOgGfkjy78sOoXXiYIogeGn2WnQbSkqy/l3/wn398Mxjh3TwKJr
	8TVDP+PVy1iUxYHImjaj7huZt46vXwU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2f5jS+04;
	spf=pass (imf30.hostedemail.com: domain of fvdl@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834034; a=rsa-sha256;
	cv=none;
	b=LAnT5xQGEkjL+zczsH6Lme6Y2M6GnwWj2AaZHcXhYlHwyxQpPkcJY7OCYBR7MkNMHRi6RY
	81v2BbJgDlUi8lzB5zz11ubZh5ckFp9gU1NFHiC4ABsP8WEQ1IQyjB5G+OgedN4jSnCleQ
	HlQax+vzgxX1d/Yilupebvlt5JFmQro=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b2f497c230so23751cf.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756834033; x=1757438833; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vtd7VHBua4ceoiPNxCebsTr+W/5i6xNmrYZ+hl6cZwE=;
        b=2f5jS+04jTjc5aBHu2UvCndwu+jmn51t3SF0PrWyPlOHNZFgzjW1L7ohKn9KRrkYi7
         +YisViQFr+1u6tDtCVQPHvC3lU7S6SvH0d9S6aCqPyCWZwIfPytDHvzZ5JW+PoFgbDlD
         B5eq9c+WsHiTlf+1ibJbBvnK5ZXPuZsxmoTk1TPAilkQkLNoFy9AqS8DqwQl3wi2XWE/
         GbS9jiwXL7VIr/GPfXh3Wq834/WM7L8j4OIa9QozxwnfiK7DH/au+KmmhRoPKQLjbj4i
         ojj+krga56ZMvQbrp21e/dZvkmCyOOOcPTT90ebwRqs2l++2O/M8AyIX7x3NBsYGALHn
         2zdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834033; x=1757438833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vtd7VHBua4ceoiPNxCebsTr+W/5i6xNmrYZ+hl6cZwE=;
        b=TLmNVf/MhEenX9JcjnAYmiZw62IyL06ZjShWxSKeOfwR+CZprEMjZ0Vul0uDrTC4Sg
         2/tZ69IXVlLhxm0Y4dJ5qLu7+dczq2jVSC9gitLxDLClt+pFITjJygO3v4piHCna0Vkc
         ASO74HqKi6BGUASdc3U4Ot6F8TqeMR+0rQ1SN4ueWyiL/xKr5qsLXzAV9N+TdIsw1KGl
         QPvEAq7eHN4RoFSHwigZarCb9VtUBqHCUs1Mj1uv+ol9wx9UUtWXLk1ga0L3cGKL8MHF
         G6j7vOYVS6/0KAuZSYyEqRDVHZM+Rx4QhZeErL0txcQi0QXGqI2ckQTn1d+wd/U9A0T9
         jsUg==
X-Forwarded-Encrypted: i=1; AJvYcCWaKP73K87xUHdR88BkVBGUF0itHkRBDI4l+73GfRRBaHXYkyiGZiII+jexZkuQaUbN+Y5NyUIBCg==@kvack.org
X-Gm-Message-State: AOJu0YxDOUnJJvfTpzqeE6OKsOUKWq/Vjmh9PEiK0Sc45jVdqAGjgQRW
	3X36zmgGAhXuUKXy26A2cYk7rhnhlIoe//DP8VRGjvJMK0T1V8G/HzcAAM0VBlk3SrCaXujvXw8
	HV2P9n++uVNwHxKAGBaFlxQV636Wn+v5DOLph+lgq
X-Gm-Gg: ASbGnctFh2iRe0JogFeOKST2g3EzUQDTmcVpbtaROdsy7bTFvXUvjojfvpS7pSFoQPq
	sWDaG55mFr+7RBlN548LfgK2N0s8Yj1fI4Qozt0Bb3KcKc/nA1ffJdbS9h+AMAHTH1fHpF8UU74
	P0qEzVeNsV4xfHYUiOEdE2Y92bGa6nXihpVPev4ZDoX1yzNc7ZiPQzYZyqmWuHT3Q2bv19AyKgT
	GPFnboyWc95H6brkvU73w==
X-Google-Smtp-Source: AGHT+IEC6y1tRdSi2UTqmtXyZZzRrZPY9SLNKXOIO98qFYX+T6uH0H7eN0bzXqp5gDwmp+jCKoimReIKubvN32ot1YM=
X-Received: by 2002:a05:622a:609:b0:4b2:9d13:e973 with SMTP id
 d75a77b69052e-4b48dc6d116mr536321cf.0.1756834032561; Tue, 02 Sep 2025
 10:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250902154630.4032984-1-thierry.reding@gmail.com> <20250902154630.4032984-4-thierry.reding@gmail.com>
In-Reply-To: <20250902154630.4032984-4-thierry.reding@gmail.com>
From: Frank van der Linden <fvdl@google.com>
Date: Tue, 2 Sep 2025 10:27:01 -0700
X-Gm-Features: Ac12FXxFN3O8AlGVbL0n79ufqlqXNkpXNtbyObY0H0t07exhvNnrkMb8tnUsJCI
Message-ID: <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 266ED80006
X-Rspam-User: 
X-Stat-Signature: 5dacwo3ojmrrh9dwdb48agxxmcmwp3x1
X-Rspamd-Server: rspam09
X-HE-Tag: 1756834033-692826
X-HE-Meta: U2FsdGVkX18WNq7kcKrmrzaFrLg3gmdHEk+9GpQOYiqkJ1upXFDv2BSfJ771IhoSu5cyt6O/T2qIEsBZtJWFB0kPMC9ujEuoQALJokj4Fxo65K/uusi13D7NruQT86r79i1jbXVO4pzoHlpcsOcO0S9lAoi80AVtKEn9lanbub3/BFdUS1ZC2zk0JpXMgCLAz8NELYQ+CzqFL/3oirD5toEKTbISmnI39rO54w6nYA+PJdU/ylHbWxz275KhoxmBS+C9tRNtHkfXLI05D2krV1Pmt4XnM0ym7Ap5LKmfcVqEr6YjiChPpYBNb5AaRpApLteoznQwnjFklKnr8hG8yDw2zff/jJP/b1/vAYHVtOgrygWFFxMEPB+xsicjxxcbxuiA6e3PSfKjWIqx/3yAowxsK+zCoZgiKXHlu7qLGJXL3Pt1vnWIYYGXq81MDDVzq5BmMNCLW+3b784ArU8EJS3mrhjmxeEJNkLqsgJy+9BYT7v2Mlu5nN3AaXuutdFVI+cQUpjjpajpMZSnASSUOzH+LlWzvr8dxmpLsQ4C2t7cK4tn9cQWBxoOGhLH5KRRU5HMdVCoabEPgBp/GsTzBdJV+piUn/DdkEblz9rFsi7Wxzh9W635mPDrsr+SjUrJsoKfUirQb0G8b/a6F4bD742ADHCAW3fNQbcB6mwRLxp2z3MV84RyS/RIi6pOEXPu6aBZuop1XCRWdOrxIwKBXKbYIRwIjf4LnYzIN9ZvwSGhrXESHHTu2ihaMdZjDFJoeW8PhzYIg7s8UPvZ6t9YwmrKwFKzhi3OGZGJGj6ytmVGZKT3GeQRs7Cz8r9PsRPVaqcP4qLFbVoj/0zE/ixwv6vpZQ/V91pk3kd3mqHGdfNMInEQfzuEO2xWTexRrRSXdcjV4OcP9Ra3IxMfuuH69WkzIoYYo/atHpg7MPfTCIkbODLga6KhsBOBeSrtbNhd1R7iXoG9NJNADkMnROB
 gRDZy6os
 ykidzHMl3v6RJfnHsLJZ1cxXTEvKetvrjfkKsHUw9X526ht4WGvuJLpOULbAxythv4E225YQoe3dZnPqr4veReIgvwxAZTLgZZPEkE+aG0Pi+JMM/MITajfiX6/DXGwL7ro6zFWGv2ZXrF2CLLcbktA81emdXo7DKb8HNzqhnT24lzudxmeX724Z7Mu9woJG7S+sHGzIFnGUF8P9vjgvQ8Zihf3UjA8B/r0mEBWqPGk92W68l/bj8UZ0H/Rzxp+Nrt2PfrXiQ4ILL531UxykV8Rv6OCCaIYOyua/+UFfMSfudDhlXv9gx9MrWQbpkca33XB95
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding@gmail=
.com> wrote:
>
> From: Thierry Reding <treding@nvidia.com>
>
> There is no technical reason why there should be a limited number of CMA
> regions, so extract some code into helpers and use them to create extra
> functions (cma_create() and cma_free()) that allow creating and freeing,
> respectively, CMA regions dynamically at runtime.
>
> Note that these dynamically created CMA areas are treated specially and
> do not contribute to the number of total CMA pages so that this count
> still only applies to the fixed number of CMA areas.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  include/linux/cma.h | 16 ++++++++
>  mm/cma.c            | 89 ++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 83 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 62d9c1cf6326..f1e20642198a 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -61,6 +61,10 @@ extern void cma_reserve_pages_on_error(struct cma *cma=
);
>  struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
>  bool cma_free_folio(struct cma *cma, const struct folio *folio);
>  bool cma_validate_zones(struct cma *cma);
> +
> +struct cma *cma_create(phys_addr_t base, phys_addr_t size,
> +                      unsigned int order_per_bit, const char *name);
> +void cma_free(struct cma *cma);
>  #else
>  static inline struct folio *cma_alloc_folio(struct cma *cma, int order, =
gfp_t gfp)
>  {
> @@ -71,10 +75,22 @@ static inline bool cma_free_folio(struct cma *cma, co=
nst struct folio *folio)
>  {
>         return false;
>  }
> +
>  static inline bool cma_validate_zones(struct cma *cma)
>  {
>         return false;
>  }
> +
> +static inline struct cma *cma_create(phys_addr_t base, phys_addr_t size,
> +                                    unsigned int order_per_bit,
> +                                    const char *name)
> +{
> +       return NULL;
> +}
> +
> +static inline void cma_free(struct cma *cma)
> +{
> +}
>  #endif
>
>  #endif
> diff --git a/mm/cma.c b/mm/cma.c
> index e56ec64d0567..8149227d319f 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -214,6 +214,18 @@ void __init cma_reserve_pages_on_error(struct cma *c=
ma)
>         set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
>  }
>
> +static void __init cma_init_area(struct cma *cma, const char *name,
> +                                phys_addr_t size, unsigned int order_per=
_bit)
> +{
> +       if (name)
> +               snprintf(cma->name, CMA_MAX_NAME, "%s", name);
> +       else
> +               snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_co=
unt);
> +
> +       cma->available_count =3D cma->count =3D size >> PAGE_SHIFT;
> +       cma->order_per_bit =3D order_per_bit;
> +}
> +
>  static int __init cma_new_area(const char *name, phys_addr_t size,
>                                unsigned int order_per_bit,
>                                struct cma **res_cma)
> @@ -232,13 +244,8 @@ static int __init cma_new_area(const char *name, phy=
s_addr_t size,
>         cma =3D &cma_areas[cma_area_count];
>         cma_area_count++;
>
> -       if (name)
> -               snprintf(cma->name, CMA_MAX_NAME, "%s", name);
> -       else
> -               snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_co=
unt);
> +       cma_init_area(cma, name, size, order_per_bit);
>
> -       cma->available_count =3D cma->count =3D size >> PAGE_SHIFT;
> -       cma->order_per_bit =3D order_per_bit;
>         *res_cma =3D cma;
>         totalcma_pages +=3D cma->count;
>
> @@ -251,6 +258,27 @@ static void __init cma_drop_area(struct cma *cma)
>         cma_area_count--;
>  }
>
> +static int __init cma_check_memory(phys_addr_t base, phys_addr_t size)
> +{
> +       if (!size || !memblock_is_region_reserved(base, size))
> +               return -EINVAL;
> +
> +       /*
> +        * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement whic=
h
> +        * needs pageblock_order to be initialized. Let's enforce it.
> +        */
> +       if (!pageblock_order) {
> +               pr_err("pageblock_order not yet initialized. Called durin=
g early boot?\n");
> +               return -EINVAL;
> +       }
> +
> +       /* ensure minimal alignment required by mm core */
> +       if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  /**
>   * cma_init_reserved_mem() - create custom contiguous area from reserved=
 memory
>   * @base: Base address of the reserved area
> @@ -271,22 +299,9 @@ int __init cma_init_reserved_mem(phys_addr_t base, p=
hys_addr_t size,
>         struct cma *cma;
>         int ret;
>
> -       /* Sanity checks */
> -       if (!size || !memblock_is_region_reserved(base, size))
> -               return -EINVAL;
> -
> -       /*
> -        * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement whic=
h
> -        * needs pageblock_order to be initialized. Let's enforce it.
> -        */
> -       if (!pageblock_order) {
> -               pr_err("pageblock_order not yet initialized. Called durin=
g early boot?\n");
> -               return -EINVAL;
> -       }
> -
> -       /* ensure minimal alignment required by mm core */
> -       if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
> -               return -EINVAL;
> +       ret =3D cma_check_memory(base, size);
> +       if (ret < 0)
> +               return ret;
>
>         ret =3D cma_new_area(name, size, order_per_bit, &cma);
>         if (ret !=3D 0)
> @@ -1112,3 +1127,33 @@ void __init *cma_reserve_early(struct cma *cma, un=
signed long size)
>
>         return ret;
>  }
> +
> +struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
> +                             unsigned int order_per_bit, const char *nam=
e)
> +{
> +       struct cma *cma;
> +       int ret;
> +
> +       ret =3D cma_check_memory(base, size);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +
> +       cma =3D kzalloc(sizeof(*cma), GFP_KERNEL);
> +       if (!cma)
> +               return ERR_PTR(-ENOMEM);
> +
> +       cma_init_area(cma, name, size, order_per_bit);
> +       cma->ranges[0].base_pfn =3D PFN_DOWN(base);
> +       cma->ranges[0].early_pfn =3D PFN_DOWN(base);
> +       cma->ranges[0].count =3D cma->count;
> +       cma->nranges =3D 1;
> +
> +       cma_activate_area(cma);
> +
> +       return cma;
> +}
> +
> +void cma_free(struct cma *cma)
> +{
> +       kfree(cma);
> +}
> --
> 2.50.0


I agree that supporting dynamic CMA areas would be good. However, by
doing it like this, these CMA areas are invisible to the rest of the
system. E.g. cma_for_each_area() does not know about them. It seems a
bit inconsistent that there will now be some areas that are globally
known, and some that are not.

I am being somewhat selfish here, as I have some WIP code that needs
the global list :-) But I think the inconsistency is a more general
point than just what I want (and the s390 code does use
cma_for_each_area()). Maybe you could keep maintaining a global
structure containing all areas? What do you think are the chances of
running out of the global count of areas?

Also, you say that "these are treated specially and do not contribute
to the number of total CMA pages". But, if I'm reading this right, you
do call cma_activate_area(), which will do
init_cma_reserved_pageblock() for each pageblock in it. Which adjusts
the CMA counters for the zone they are in. But your change does not
adjust totalcma_pages for dynamically created areas. That seems
inconsistent, too.

- Frank

