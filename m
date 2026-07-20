Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63EAC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A156B00A1; Mon, 20 Jul 2026 11:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929CD6B00A5; Mon, 20 Jul 2026 11:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1FC6B00A6; Mon, 20 Jul 2026 11:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5426B00A1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:56:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4206CA01DF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:56:48 +0000 (UTC)
X-FDA: 85009608096.28.5F67E37
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4DB96120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:56:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JcYv5lhU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784563006;
	b=PmZARtpJKg8gezR43WqyuVijKOI8D3NZkzTpMG82X8UYD60W6rK/LQxfpfmimo3XbrIV7w
	qVYkdQ5WSAKrEzENLaof/NZosZ1+lMvZrEiSyazymZ/UOU2Lm+iYNx044Uqhinu/EZE6ha
	6vdh6YvO6cOveZsZXwtzznPyKrgs48k=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JcYv5lhU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784563006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2pi/xAA08HOnx69PMlTRrck+6Y6k//FzJj5lUPYCGg=;
	b=a513rivxQD2uFDXUvVQj74qNkjQ51+E6FkfgxGfawQnmXUc+BFMOp6CZ+eeuV6xmfUqI9j
	xUdqtbep0nFKE0Aoje6Wq2Rbsqyx1DHqMIs9Dj2ayCtKxaygUyb4mYi3Vu+sfw0r8NW3Dx
	6KnhXtzxE7s3WBMAXo+gHHBux3KDAts=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-476d8e647e9so9382627f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:56:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784563005; cv=none;
        d=google.com; s=arc-20260327;
        b=gyQXhfeUzCEG5us33dyHuGgJykFyXiVFt8XSvuC/u+nQJRjGdKfwpHUjZNzbYI0apZ
         u9F9IWUvvLmOoNPuU7+vNmnVY21j34IR92UKXrm0d1s1UAieGThnOoM6GGSJ7DNGzEBm
         zwOpE8UlTci3IU4KrusAST41W1+IzWgaw2MR1TSwLAAvwA0wwLr8A24VvRGq/aWjvU0N
         wdOmQDHSkFYKXuBjsoEy7ywHNYensbWwIJGDz+he23Me1ieAhcGkExB3WYM8uQFsjEYR
         78cw3WOufMyimnPNfPyHVr32MkuIF7/jLFjB6MH4saeZQ5xK2TQfleIV3hdM2bB4UiXz
         GR5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n2pi/xAA08HOnx69PMlTRrck+6Y6k//FzJj5lUPYCGg=;
        fh=U5bfy5bOfgFOJYjBTJE6tZCC9Zq0KrQshKC8sQgoRVs=;
        b=AN79y8x0orMDMsQIflB3CcP4ugf66zJCwoep7JZ7cwx2fcW6E9NCv0LvIUpY/b9N0u
         LpHv2V4UpGdXHWkq0vSLFmUft9e8qUeXO+fKujUxnqwKAqWB8fQ966Tb9B/4uHDARa1O
         KYXe0AC6vfJDMinOu4giW75zEu65W+OXGXhI1wxhyWW+i7wUibyyQ+qmkKInaH7Se3DK
         h49OgmVeYEzcRVBCNh13U3wDAWXaj6StaQO/AkmC4y98w2Y8TT55FxZFtiS/kA0Ve2/N
         9Ueg5I1JmgPeRKrnWKuWCfSgoL9WRJzsBEgJV1EVBUd2msolZqJ5sEYK4P8lGfE4mw+J
         3gTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784563005; x=1785167805; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n2pi/xAA08HOnx69PMlTRrck+6Y6k//FzJj5lUPYCGg=;
        b=JcYv5lhUBynU3AD+Ni6Vz7/z7kUo+B/dLySRKDZLJIm5qi/SYwxcB9tKbOalFvEQSO
         7mdRAeAg8vh3ONX7qaAGkLeqVAjMmVlckXbLdcFyt0JdRJraWBiQ8WZs+L1qugclWI5j
         2JFpYK6l1B5qoFSvqGlgXIwpe0vBSTYcuvrVhzblOTOHfQ4clnyE0fki0IhxX45DPdyY
         73aOJThAFvpCAJ9xGTs1TqjqqGGX+oZFlb3Ac7yavEuDLrabmxYGhjhDRO9ZBQ9gs+To
         qMa+vuGxFgjWspWl/1LGDQ9CK7typZbO/UrkbTWOwHg4AgNzD0uhcz3sD0sQWGuhJQfW
         myPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784563005; x=1785167805;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2pi/xAA08HOnx69PMlTRrck+6Y6k//FzJj5lUPYCGg=;
        b=Lk2fqE0xzsh3aHOW8KLSloUt5tlxByWhGQmtJwG9AN4JN38QJQ6exrOOj+iifch8rV
         sX1qw6DwfS8pIopLxhhKtWJWavsGbAV51gW62yHD6i2U9mgyk+4sTtF5eEewuaEKjSY4
         bfhOlt2+VDTFXN2j5E3+VylH89UuKcr9RiVZDoh8nuqTvkAzWUw493qe9een5joBJben
         ZdoAaV2aIilN+n/EM+QusK9iK0hIaUPcqauUb7uKPa5g9r1MNqNLi3inZRvLEhWMOPtN
         cKdbG6UxGMq3IWtwL0pOD39ore5KmAyuzcrtvwyzzIAERxTBpH6JHOOM6onKyhE7tgoW
         DMMw==
X-Forwarded-Encrypted: i=1; AHgh+RrNQMqehOhCv3XOXxpdPCiGq9M1G/8x0cyqndDm++Sli5J02KsQaJ70bTi+oQ1O5JdxloKeznTpwA==@kvack.org
X-Gm-Message-State: AOJu0YwdSpEau3F4gsOLVnuC13xdYH/yUGUV4ezAlilzHHkHxOsXI9ig
	93X5BmUFDgz3waBBSruHrMRYYVVJUlvHfQyR+wC+n3pC9KyMLUlwaZrekDzLNSbDcg3PR2z+g2j
	iaM7wCya1Af6jrhJgf7KDvHcnB7uN33o=
X-Gm-Gg: AR+sD128T3MeGTS8MyelZgWImX9lRKgonhgoarOt26gn6R9O0Up0zsd+8EiwckOLqny
	SyZ9tGhBohE+PP+s0cB7XrX2Eg1BrSKuX67wob4Bkm7d4kaiDnIb04J4gO+MQiSvbKLiTeQ8iXb
	RwOpsTwQ7AUueWS5o9jE/NwOkJ9/YhC21VHxtsF9yXLvYyADZOKNGFonzf1YCdIwbZ9hZ1eI3eP
	XRTjIJKHF02zJMetZR+EzBP4tjAaDDnzK5NV4qqwiIVLeTA4BNLw4J4ruAhgv9T6ZOHMEPgJHcD
	ucdrYiyBGm9gsyKZ3A==
X-Received: by 2002:a05:6000:220a:b0:47f:6fe0:294a with SMTP id
 ffacd0b85a97d-47f6fe02b02mr10096598f8f.23.1784563004542; Mon, 20 Jul 2026
 08:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
In-Reply-To: <20260718093723.153324-2-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 20 Jul 2026 08:56:32 -0700
X-Gm-Features: AUfX_mxuiyoIjzhEutGTO511_NhirARSYjjeIOZoGjTVYtHHDTkIhdeMfEHtsQY
Message-ID: <CAKEwX=Nn0dMc1K9drXFVMwt7wMZ2P6KToeh7T3rE1+Xq5yrCFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4DB96120002
X-Stat-Signature: j1jf5t9rmom6cphaen1crgpk6dfwpzrg
X-Rspam-User: 
X-HE-Tag: 1784563006-599495
X-HE-Meta: U2FsdGVkX1/b1Jz4U6mG3zYZ4p0aXMIO9/9FbBeubpxOdw6qjNdh5JIQ5OEwr+kOAYzch0NqJ3S41yd372/XxDq0xXsv8WMWSuZQtm3dgjsaGt6DHSY5OpROTHbEd8i1yhBB6Ljx31SW/cUzviC0UPUBD7w+C1GjNiDc2xNYkjZ7ZX+9DsxNrCcfsQeBcH5EkDIRKiK5SBHy7NKzvFff6bPt8J6jzFIWzl6pTTJQbSdNIuG9hZfXBFBPOiDA+jznDdZc81r8QDpBFaEXKwbs7gqstI2vT3IqcdBN+RyYYFCFSzJ4j6F1EDgpaY7loYZM80kA6Oaq6O3jak4koYHPME33T5YrEswN30wcDiIUoIpjIrpVUpZZED68t2niCKqw/fWQOA4mudgNB4YMpXMcSVk68EtlacELtN9fzUgCmue8VCXSwHuiHqJ64eNJauiuhUd64p3Ij779wO+l38plhI2XojzWcclMUV2iD+qjOT7kPGrSND/02ZZxTe0VaReZs5/5nM8GwMjNpO823uRvFmbYdLqHScyR3ERjH5lGSqYN2SGh+CN/TdynVEYR5Pewa8WHtnUQG4eFCfNn15+Ebe0cl9jxIGN8l8eYnkMOSXbWpBbkES7fAIbeuK51m47t8zpzwkWpRCNCnNts0rMt/ix+pp2nthbyUVD9onEJ2HvQjKlsi1OS0JB5ogmpQ+TcxXAsSRviSWzd0hF7aw8R8ikHOhgj6LW+EYvD0LJ1ThP9Lef2Is9OzDK4xFAS/GKo9fGp/lGGy7FUnX3WhBhTbIWIhLqE6kvc2l1GRSH7xQ+Y1Nuz1WVHImYSLKiIS7xJ52C1Fp4vbvRDwRS4gIK7PGM/KGLJAyzE2b3DrKqRLun93vErJ8MytpZNCB2DCmbTyJrLnvwRKdO0cN6ut97tyNGPtJU8w8OOsM2HY8v/eJqVd+Vf1ric9AcIh7cSQOP+OfucbdZNHSYczRIWk/0
 1fJYpf5P
 Zy/p3iGxKOqeLs6fSLzqjnPhijN8balLy0tU1wQwc8M66lbEM+TJaPULBSXm2C8Nfc9Y3VUE7FtTxUv37igJxosC2pAR0EvPckPSK57So7yfJ4Czgxo89tmy2+bWOtNWKjuSrkiPVl8/NNwohY11ZB7tRiUd8wxOJe1YP/SBs91pNFskHvOKnCWkNNI1uNkiTD4c3phX7SX79eY+ADaie6JRQez+BiBDKKhAPsTzqBo4MnIR/lMFqRC/A3LyR8KTdxyoKteRFpFTMplS0WnRT63D7a8WPcGAXeajAOcd8CLhVeakaxRZD1wAg6kxw5rdrTjZvcNiRXFldPjvDKiSWmLHspNQZqnCVXMxhcOhGNPHYRLaqptgJEG/vjotR9MXuj7q7miOPkUVFsLdo08cUnJPZzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 2:38=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> When zswap writes an entry back, it allocates a swap cache folio,
> decompresses the entry into it and writes it out. That folio is cold by
> construction, but it is currently left on the LRU for page reclaim to fin=
d
> and free later. This wastes a reclaim scan and keeps cold memory resident
> longer than necessary.
>
> For synchronous-IO swap devices writeback completes in the calling contex=
t,
> so the folio can be freed right after the write rather than left behind; =
do
> that. Because it is freed directly rather than through reclaim, it is
> allocated off the LRU: dropping the last reference on a folio still on th=
e
> LRU would trip the free-time page-flag checks. A folio that a concurrent
> swapin has meanwhile claimed is left in place and reclaimed as usual.
>
> Asynchronous and filesystem-backed swap complete writeback in interrupt
> context, where the folio cannot be freed; they are handled in a later
> change.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap.h       |  3 ++-
>  mm/swap_state.c | 17 +++++++++++------
>  mm/zswap.c      | 36 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 47 insertions(+), 9 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..c617e5a0257f 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -306,7 +306,8 @@ void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp=
_mask,
>                                      unsigned long orders, struct vm_faul=
t *vmf,
> -                                    struct mempolicy *mpol, pgoff_t ilx)=
;
> +                                    struct mempolicy *mpol, pgoff_t ilx,
> +                                    bool skip_lru);
>  /* Below helpers require the caller to lock and pass in the swap cluster=
. */
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
>                             struct folio *folio, swp_entry_t entry);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 9c3a5cf99778..048efc7ca612 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -403,7 +403,8 @@ void __swap_cache_replace_folio(struct swap_cluster_i=
nfo *ci,
>  static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>                                         swp_entry_t targ_entry, gfp_t gfp=
,
>                                         unsigned int order, struct vm_fau=
lt *vmf,
> -                                       struct mempolicy *mpol, pgoff_t i=
lx)
> +                                       struct mempolicy *mpol, pgoff_t i=
lx,
> +                                       bool skip_lru)
>  {
>         int err;
>         swp_entry_t entry;
> @@ -484,7 +485,8 @@ static struct folio *__swap_cache_alloc(struct swap_c=
luster_info *ci,
>         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
>
>         /* Caller will initiate read into locked new_folio */
> -       folio_add_lru(folio);
> +       if (!skip_lru)
> +               folio_add_lru(folio);
>         return folio;
>  }
>
> @@ -507,7 +509,8 @@ static struct folio *__swap_cache_alloc(struct swap_c=
luster_info *ci,
>   */
>  struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>                                      unsigned long orders, struct vm_faul=
t *vmf,
> -                                    struct mempolicy *mpol, pgoff_t ilx)
> +                                    struct mempolicy *mpol, pgoff_t ilx,
> +                                    bool skip_lru)
>  {
>         int order, err;
>         struct folio *ret;
> @@ -522,7 +525,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ=
_entry, gfp_t gfp,
>
>         do {
>                 ret =3D __swap_cache_alloc(ci, targ_entry, gfp, order,
> -                                        vmf, mpol, ilx);
> +                                        vmf, mpol, ilx, skip_lru);
>                 if (!IS_ERR(ret))
>                         break;
>                 err =3D PTR_ERR(ret);
> @@ -643,7 +646,8 @@ static struct folio *swap_cache_read_folio(swp_entry_=
t entry, gfp_t gfp,
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         return folio;
> -               folio =3D swap_cache_alloc_folio(entry, gfp, BIT(0), NULL=
, mpol, ilx);
> +               folio =3D swap_cache_alloc_folio(entry, gfp, BIT(0), NULL=
, mpol, ilx,
> +                                              false);
>         } while (PTR_ERR(folio) =3D=3D -EEXIST);
>
>         if (IS_ERR_OR_NULL(folio))
> @@ -683,7 +687,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gf=
p, unsigned long orders,
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         return folio;
> -               folio =3D swap_cache_alloc_folio(entry, gfp, orders, vmf,=
 mpol, ilx);
> +               folio =3D swap_cache_alloc_folio(entry, gfp, orders, vmf,=
 mpol, ilx,
> +                                              false);
>         } while (PTR_ERR(folio) =3D=3D -EEXIST);
>
>         if (IS_ERR(folio))
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..3c494c5a671c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *ent=
ry, struct folio *folio)
>  /*********************************
>  * writeback code
>  **********************************/
> +static void zswap_writeback_free_folio(struct folio *folio)
> +{
> +       folio_lock(folio);
> +
> +       /* The folio was allocated off the LRU and nothing re-adds it her=
e. */
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> +
> +       /*
> +        * Gate remove_mapping() on folio_test_swapcache(): a racing swap=
in may
> +        * have freed the swap slot (folio_free_swap()) and dropped the f=
olio from
> +        * the cache, and remove_mapping() must not run on a non-swapcach=
e folio
> +        * (it would trip __remove_mapping()'s mapping =3D=3D folio_mappi=
ng() check).
> +        */
> +       if (folio_test_swapcache(folio) &&
> +           remove_mapping(swap_address_space(folio->swap), folio))

Hmm I think you also have to test for writeback and dirty here right?

After a racing swapin freed the swap slot, the folio might be dirtied
and swapped out again. We probably shouldn't try to remove_mapping()
such a folio?

We also do similar check for zswap/sync-io devices in pageout handling
(mm/vmscan.c, shrink_folio_list()), and the other dropbehind handler
(filemap_end_dropbehind()).

When I was playing with this, I also tested the folio with
folio_test_active() and folio_mapped(), but I must admit - I do not
remember why I did it. Could just be me making sure we dont get rid of
frequently used folio rather than for strict correctness. :)

