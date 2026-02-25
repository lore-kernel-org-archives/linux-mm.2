Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06103EFD213
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288636B0088; Wed, 25 Feb 2026 14:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2369B6B0089; Wed, 25 Feb 2026 14:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE1F6B008A; Wed, 25 Feb 2026 14:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED1EB6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:08:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99768BAB87
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:08:23 +0000 (UTC)
X-FDA: 84483914886.25.361E662
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 901F8180008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:08:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qGlPzt5d;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772046501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdv5n4oRZUOb0dBehW/2IVbvHxLeECYP3avwc2lNt7s=;
	b=hHrEYsKU72vEnDyomCF45ca3hW0w1HZxdLrO9ZALBv18dc1UBEQJnTYza4FXIpn2FqdMa0
	chLQlDKuaEh8fhHAb0PyF1gXpa0abV1/polXpRvjiYFaOzXUEfB4szYu4X4s6pXgSj6+Qw
	6W4tQR7jKtjJdnzhK32k5SkZ+J09my0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qGlPzt5d;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772046501; a=rsa-sha256;
	cv=pass;
	b=oI+9WQ0mM37tdzbWxs8zQ6huvjxFz/bxAsD3vGBQczc7fkJ6NF25CwFc8zLCVLa2vFsLyu
	pZ/PAtM8NFj41gQTFcRgvZhKokBtWWpSRmsHtv6wLQILFo0IaRmDDDjm+5rTkxgSnntfrw
	fg7S7pO6aSBlpkodty8CAfH4+2q6ejE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso62681cf.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:08:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772046500; cv=none;
        d=google.com; s=arc-20240605;
        b=Qp6pzJ+8zx3hJA37LGcNjsbUpQTm7ZRIgnqDF/jMuLO3PpAHqYg425tnZ4Q0gzdzxs
         4LnXziU15OnfYQU7qkniZuITWdASlfkx0jDnUO7BQTqC6tTWBFPi2An/EEYYdFC1+N1z
         pSX27pejt5W5ua/lLKrzDMxF47iaiI04mgr0chCoznZoUkMAObQwkQyyPIrkulOg4uar
         kDEI9aXcim4g5nRDdI1zmgEqOGsuGZmbHFJDNJlf2i6IXBGuE1pPgX6GdPAb0LkN8kso
         v0kHo7r1X7OHJTZOkaqoQJl5+bMgDi8MPMVHLaEJicU0DGH5Q9BodyuX18oAjmvtQZf3
         lXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pdv5n4oRZUOb0dBehW/2IVbvHxLeECYP3avwc2lNt7s=;
        fh=DtGDqwKVGjh/9fPqS7HKUnBHqOZnrNDDk+T6HDg/C7c=;
        b=TR3ysYpdFf9hIDdXvfcLR3y9xbZMiEBk29NKKFcEy5sSExDiCaSqzx4isfzcE9VcmO
         Rws/UodrMlLcbkGafFWNC74ac3fhTxKcrf1rZQAqxh5eFf3YfwHO5Tm2Stj4xugFRQmV
         +RszmU7C93lNS+li+3k+weC84Hu0cPMeOTQf13sGwvPdZb0PB694gOpuCqWfp34bSafi
         FCppeyFQ6Eb29YI2Sf9olryeX+9op4sImQDeyVIjkQZweYKIPLITUlYRr90eUtXq0d3L
         /T/D5tMhU99SLqeL8rXsVSHGX9Fi8K26ytFoScAYgOCiqovKBYzJNag5xiFuQ67YmLr1
         1Qnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772046500; x=1772651300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdv5n4oRZUOb0dBehW/2IVbvHxLeECYP3avwc2lNt7s=;
        b=qGlPzt5dA/tWfPBcRjL9lP4Sbjlqp21aV2zWzpQyyjkVeIS9csVugF4PYrMLHtY1Jl
         yzTNcmxZNdslT33P/G8yOr7jIIPcgtBnPwhBk14uEs3BOY9oo4pag4Em5aTcbbf1hQ9C
         BS/wgC9Nsvf4a/cdohaL8cdvfH2AxjPZA/tRnYfMtOokwTBJOeNm4xgWp9Yk8RbAiKUU
         Koi39gqLl0OwuBkjJ1ZGPAhima2kQww9nemv4ezgsqiVdK+C3Q989LmBbcsXK1RISDgp
         Lh0aVir/4Tdhb0pjbIFjJpOjquyLs1Rw1OwsdO2fC9U79oU1xGmOUh88vaGmwHksetE/
         5tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772046500; x=1772651300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pdv5n4oRZUOb0dBehW/2IVbvHxLeECYP3avwc2lNt7s=;
        b=BWAhXU7Bi4AEs5H40fVK+wvNIZUUZt48PO96Wxn5CFrW+d4QNN6x8ozIKrGEMdnMUi
         v36S1y1MuatQURcJx71seXWPk6k0qe5VqaxrY/qi5oPnX7wPih7ANTIq3SIEJJYfLGSb
         t/VFqN2T90VIbCPwlp8qRkMCf6jcdOIhg+XlBhM5UJhDdXseZl0jzfym7vsGRXWbuPUR
         g4pNimO11VoTrm2w7ej6MAppQm9dG98FJibCE3iPsm9dum9aYVm/iC7ZDqG5dJ6yAEfd
         9wpKKucMdWJ7tnddFRnoHvF25c00Pp5vUXJxex0xEcRnITQ5cEUtok9PchQw1A4YSXFZ
         x6SA==
X-Forwarded-Encrypted: i=1; AJvYcCVndsQFZUmmwpbS7qnIHY7APGKJT9/qzK/b/wZ+Ox0ui/eJnfLiUpuZJWKgHNliJfaxE3t8PVD1Vg==@kvack.org
X-Gm-Message-State: AOJu0YwpWGP+cLnINoutG4yAGkmZ4XjW9S/wiVP4GE7OqeORTVqkUrtw
	jDc4dIFtLGJKih4eEQvzZxgD3XiS8iRtFer296d6NC0LhT7caNnAj9mTuubZ1QOKV80z7+r1F0y
	fXNw8xM/vQoMf7AlZaZmSxasBJrkj2rHoX7P71YDL
X-Gm-Gg: ATEYQzzfHrYGsvExBPYlXP/Ov06oMKWSF43d3MWcOKVrANRDVKIvIvEaevd1S/4G3Wk
	m3bcKYhMCTXxNY1cRTworVy2ld1KT9rsf8kGqYL+LcEITxNzzQVKtXrmqrHM4Sv/vXvrXhKMMlV
	bKGEDij7oDrRFEH8V8LeTnadsgX1Zt1nWMcn0cy0NwEOyq/vO0vExAskoNG1M/E3xGOuem2iV4l
	HV3/0sGBZCq8ih60erWIxl4nT/LdD+21qr8JKj4p8JkLQfC4mKRdKuNAJ+47W9b4Npat15X8fDQ
	uymUVc4v5QpBxFzKEylV9RJQ/U8MTtpggiE=
X-Received: by 2002:ac8:7f07:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-507441e7002mr1142051cf.18.1772046499964; Wed, 25 Feb 2026
 11:08:19 -0800 (PST)
MIME-Version: 1.0
References: <20260225163407.2218712-1-surenb@google.com>
In-Reply-To: <20260225163407.2218712-1-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 25 Feb 2026 19:08:09 +0000
X-Gm-Features: AaiRm518uYOgnm58APBpc_-5TJ7TrM4AalLW1XmytYKV1TXGn9WcLsqN8_K-A2o
Message-ID: <CAJuCfpH-+trdZ=68v0FTj_yKn6+gmE10gKjmjrTyPvO2EaXdRQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/slab: mark alloc tags empty for sheaves
 allocated with __GFP_NO_OBJ_EXT
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, 00107082@163.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dbsier7dz69onpuq41d4p93ps6ajpbuu
X-Rspam-User: 
X-Rspamd-Queue-Id: 901F8180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1772046501-202085
X-HE-Meta: U2FsdGVkX1+yE0aTwEpvz5llL/eSJoe8MA2iUB8XWZg/BkHTs7twysyTzf+47jYu4bLtpvUwgLBEPDm/q+YseUUAFJ8m1vtD2NnM7nQFKQZfQx22IvVh3Y0vfqAu8Be1i9U8Nmep2gCnSUQBWOtZKu0lFSA0WyH+6JhhvLzIIkuit07VzMMCHIIDaO3KMLIx24bXJVet4YHkW29rAbp5gyNPhKjy7mg4mW8gUDbVUmtoy29WjS7rVkj3GDNMVsdOv5Xatf2i4jk7FOa2Lsyj974J2yoYSSEX7y1O817LktIztgaUHe6kPAnBO34Fmjfm68oClfmwNdYCwVyuQBX+S2xiXCl10PeHQ8YgsVyrVex3jlSLORuq/FEQufXYSAYz2ORPnrw1rcMfd0Xak9RJfLAmRtMBV2wywygCEBmdbzcEc13GViGhAd32o8yf/HOSUayewAVGE2VBA/IzGB+jGkseM2nleNOxadlZ+mVgR/rayCPgGtZm4lltyEEmRoDTWhsUxkh1Jq4ut5Yk+Xk1k0lz4ThQ8xwOMq+zm+xL7yIXhJryHqJaWozXPq7fAgSQDoUWtYIBU5SDdYAjepVuEE5qsqHGvH85d2/p24bCHBUkR72Qo3x4DKL3i1XY0uCZGRFnnn6P7Fh1xM/3FEF2QUhHkKHdweLjSg3OvV5THPtpFh34fwjV4xoR0a1k6gu1GsGR9CMj1HpZZPtYjQPktqp7Em3CxKg8dWQH55ys5nM6Ut5FGCua2heIgMqduAtgo/8QTPZPXk9RFcolPqb+ETiYyzyfehI8kB5uAvXpi3NJaG0PXkXyX7i8hZQSQ9QiNqEGKLXVUi367ijG5yMb5jzBJuVj9o5519rICy3NqI7T91d/hgPZyGBpj4PKTqYWiyeqCH6bheYt51Ch31IXASRPVwK+9wGFPkMQQAyoTYCQncDmGqeXmNPkpRKcvt7bUIybYnto2fKyjsJ7RVI
 homY+vdg
 BWhck0H/ujK2rNQL+xhWU46+ihMWiM3pVe8OXJi39Mee1kgh1WvypEj0AmXULzG9YId5EhPyKAG8XNsSZzJTCYrXjbadRLdg8Pv9RGqhrMdrmfjnPBDqDowkMEXg0SHKwhZ7zIRPg/FqnJO8hgIS1mgCVgeJsnXbjPv+isRGRH3ZIDkM3HDcQO1wlC3Kkuvy13LA0OqYR3QSbqpxL25k5K+vTCwOR30Fk1YLznNuLbX5HsOFktkjEhIEcKal3rxfj1cWijidDDFPiz68I9Kl/uTT9hdvBi0dW9AYgBZLnYXHzbNhIVfJjDHDRroQVhl1OSru42H4fKk4LetDhXTi/46R9OfC/aT1PhcRc0m/nFKch9rq/ojKFtfxYv/8MeT6Oj+A5TgAx+oZwJdoQbt7lChS2Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 4:34=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> alloc_empty_sheaf() allocates sheaves from SLAB_KMALLOC caches using
> __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> allocation tags empty before freeing, which results in a warning when
> CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
> tags for such sheaves as empty.
>

I think this should also have:

Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_empty_shea=
f()")

and CC to stable for inclusion into 6.19.
Andrew, Vlastimil, should I post another version CC'ing stable or you
can add that line and forward to stable?

> Reported-by: David Wang <00107082@163.com>
> Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.co=
m/
> Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Tested-by: Harry Yoo <harry.yoo@oracle.com>
> Tested-by: David Wang <00107082@163.com>
> ---
>  include/linux/gfp_types.h |  2 ++
>  mm/slab.h                 |  4 ++--
>  mm/slub.c                 | 33 +++++++++++++++++++++++----------
>  3 files changed, 27 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 814bb2892f99..6c75df30a281 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -139,6 +139,8 @@ enum {
>   * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
>   *
>   * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
> + * mark_obj_codetag_empty() should be called upon freeing for objects al=
located
> + * with this flag to indicate that their NULL tags are expected and norm=
al.
>   */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
>  #define __GFP_WRITE    ((__force gfp_t)___GFP_WRITE)
> diff --git a/mm/slab.h b/mm/slab.h
> index 71c7261bf822..f6ef862b60ef 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -290,14 +290,14 @@ static inline void *nearest_obj(struct kmem_cache *=
cache,
>
>  /* Determine object index from a given position */
>  static inline unsigned int __obj_to_index(const struct kmem_cache *cache=
,
> -                                         void *addr, void *obj)
> +                                         void *addr, const void *obj)
>  {
>         return reciprocal_divide(kasan_reset_tag(obj) - addr,
>                                  cache->reciprocal_size);
>  }
>
>  static inline unsigned int obj_to_index(const struct kmem_cache *cache,
> -                                       const struct slab *slab, void *ob=
j)
> +                                       const struct slab *slab, const vo=
id *obj)
>  {
>         if (is_kfence_address(obj))
>                 return 0;
> diff --git a/mm/slub.c b/mm/slub.c
> index 862642c165ed..34c32749f091 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2041,18 +2041,18 @@ static inline void dec_slabs_node(struct kmem_cac=
he *s, int node,
>
>  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>
> -static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
> +static inline void mark_obj_codetag_empty(const void *obj)
>  {
> -       struct slab *obj_exts_slab;
> +       struct slab *obj_slab;
>         unsigned long slab_exts;
>
> -       obj_exts_slab =3D virt_to_slab(obj_exts);
> -       slab_exts =3D slab_obj_exts(obj_exts_slab);
> +       obj_slab =3D virt_to_slab(obj);
> +       slab_exts =3D slab_obj_exts(obj_slab);
>         if (slab_exts) {
>                 get_slab_obj_exts(slab_exts);
> -               unsigned int offs =3D obj_to_index(obj_exts_slab->slab_ca=
che,
> -                                                obj_exts_slab, obj_exts)=
;
> -               struct slabobj_ext *ext =3D slab_obj_ext(obj_exts_slab,
> +               unsigned int offs =3D obj_to_index(obj_slab->slab_cache,
> +                                                obj_slab, obj);
> +               struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
>                                                        slab_exts, offs);
>
>                 if (unlikely(is_codetag_empty(&ext->ref))) {
> @@ -2090,7 +2090,7 @@ static inline void handle_failed_objexts_alloc(unsi=
gned long obj_exts,
>
>  #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>
> -static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
> +static inline void mark_obj_codetag_empty(const void *obj) {}
>  static inline bool mark_failed_objexts_alloc(struct slab *slab) { return=
 false; }
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>                         struct slabobj_ext *vec, unsigned int objects) {}
> @@ -2211,7 +2211,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>                  * assign slabobj_exts in parallel. In this case the exis=
ting
>                  * objcg vector should be reused.
>                  */
> -               mark_objexts_empty(vec);
> +               mark_obj_codetag_empty(vec);
>                 if (unlikely(!allow_spin))
>                         kfree_nolock(vec);
>                 else
> @@ -2254,7 +2254,7 @@ static inline void free_slab_obj_exts(struct slab *=
slab, bool allow_spin)
>          * NULL, therefore replace NULL with CODETAG_EMPTY to indicate th=
at
>          * the extension for obj_exts is expected to be NULL.
>          */
> -       mark_objexts_empty(obj_exts);
> +       mark_obj_codetag_empty(obj_exts);
>         if (allow_spin)
>                 kfree(obj_exts);
>         else
> @@ -2312,6 +2312,10 @@ static void alloc_slab_obj_exts_early(struct kmem_=
cache *s, struct slab *slab)
>
>  #else /* CONFIG_SLAB_OBJ_EXT */
>
> +static inline void mark_obj_codetag_empty(const void *obj)
> +{
> +}
> +
>  static inline void init_slab_obj_exts(struct slab *slab)
>  {
>  }
> @@ -2783,6 +2787,15 @@ static inline struct slab_sheaf *alloc_empty_sheaf=
(struct kmem_cache *s,
>
>  static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sh=
eaf)
>  {
> +       /*
> +        * If the sheaf was created with __GFP_NO_OBJ_EXT flag then its
> +        * corresponding extension is NULL and alloc_tag_sub() will throw=
 a
> +        * warning, therefore replace NULL with CODETAG_EMPTY to indicate
> +        * that the extension for this sheaf is expected to be NULL.
> +        */
> +       if (s->flags & SLAB_KMALLOC)
> +               mark_obj_codetag_empty(sheaf);
> +
>         kfree(sheaf);
>
>         stat(s, SHEAF_FREE);
>
> base-commit: 7dff99b354601dd01829e1511711846e04340a69
> --
> 2.53.0.414.gf7e9f6c205-goog
>

