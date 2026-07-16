Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776C9C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 01:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306FC6B008C; Wed, 15 Jul 2026 21:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7896B0092; Wed, 15 Jul 2026 21:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6CA6B0093; Wed, 15 Jul 2026 21:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7FAC6B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:44:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39C321A0397
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:44:36 +0000 (UTC)
X-FDA: 84992945352.04.20B2AC0
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3EA71A0009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:44:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=paZe0zp8;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784166274;
	b=vSIDjzvXrGFuOPWTIQdCHeRWubF9/OLeBfycles7VLve9tfPeeRTwO8lXhTVd+CizuNJlO
	IJjw1SRfPXKs0ulYkbinds+3ZjBtHC4CxD7NgxTFQEJfdD8bLirnmOqGODMMWxTO4Ne1+T
	dAfvLPj4qrnD9N7RnI9JXAbuyrIbSA8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=paZe0zp8;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784166274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
	b=DNb24OR7Ct6QIEKjEI07XsxGd64+wcI4iT+OxScs0tGdzhZfHOqrcjOwf2r+xBGXRp4M3w
	hzk22dJz3rV79IgOaAOOmnMpe8Z5zBmJFUSyPpDp7aoExKcsDgnkqbDDBP0+W689L/FPO/
	hD6ivWRtByRBLjPAg5tbpkZIAljpPj8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c10ed63c0so85811cf.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:44:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784166273; cv=none;
        d=google.com; s=arc-20260327;
        b=I96ZyaGPc/CiKYir0friwTt9+e769PhCMkdWMH94mcyPbaAJM9q3Od8/QsWXsQ5skP
         w0xtsfmr0TBEsqmCiC5cIFcuEONgkpLyDos5Jh9DpT+w6Ly32P7wY1sdwBU1NsX4HZ1n
         ln3t+wUeTT5X8PJhE1E1ccxPW3VNNc+FpXvodjSnWbdxtLOASe0aJnmJ914ROxADhQRA
         FjGruapfUDqWvZDp6mvr8BiXklKR4RqWJb/EXJaR4wXB3DgBro/oBlqNuN7Lkq4ygt/g
         JvkTcsTmL4H+2/nTDhEX1Ox4NDY/MThAYrZcpdu/eOFN3gqoTxF7wlk2FDRYfwBDSZWW
         Q4Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
        fh=iCgTmoPHXQ62GBgDPaI53km/vX7OCX1LyAjDl1SgX0k=;
        b=F7g5BN1GSgFKIBidE0f3od1zGpwbu15o8+aQkZqMq3UvwMZRcR95tNKT1b/7QnqxjP
         48xc/H6/NJh3GtG7Y+aqYyRflCcQUtJTszOxobgqTfVMpWI54Esmqg/T3pfZDoeCihTw
         IH9JYTGvrUY8MXSY++vJ+uiuBuC4MiZFZwsCaWvM9EMhuiPR9EolRuPCfS0cTBplL8W8
         jbLYLJ+YiugMDpI8wdADpoP5umPJSr4ioe+2gXFAg7uClzqn/g3avi30yZOx1SROX8Ad
         bfiXMxCO4/UJn8KxtkmnPv/KvwNJ1ARodzn89JbGxmH37Bsk1fok62OXnjVSaVg4naLp
         LU+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784166273; x=1784771073; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
        b=paZe0zp8Sw0zYcFqh2weGBd8r3pTaY8pib1w9FraMiXs4+S2zDK2c3MqEXzhFhYDjV
         C8PTHz8f0km8wNnXoaOyfMAiewRf12A4tUOfxDWrfcwyDQHvHq4yD4VTOPajnVB2w4pj
         z2J2H0MdvMgLyGbLEdBFQnkQ/HgptpbYG95lTu2bDqbFquCx0BL7Cc0T9N1mJZ4hLTqo
         laeHkR8jDQrOrqtppW/kf0+3C0szI8YTS7CsXq/RyRd9mwPzSYCEQ5/ixWRZAfWqH+ld
         T2DDXItI3zOT7DU/+mSK0ifzFAW+QFh9Z+Ww+DdiJTa3UZzxzpdzoB5XsAouiTD0H1r4
         pj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784166273; x=1784771073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
        b=VQTHv8St0B2DqdrB08671sOukIUYO46X8hv2K+r4CsQFlIWmavb+ry0tdENg9Bvtjc
         BsjnSQLSuJHxWUMeNA/Yi/NNDI34vLPij/vAXV9YbvwiZzgKEdMsE2eIrNctSD3U33hd
         81dcdbm45ZEJ5Q/pBFHsgZnLkRSBkDIG2pvp0xLZuxF+FkIkjQ6FpkcZjqUoyPHoQX+u
         l/0PaHKYaQowb7eOsz34D/2mxGXXK4NBUn1L/Z5cVg1xAtLPPC1eb2yOazZ1ZJcIAwt7
         c+Q3SAYuHrBsvLMFbluQROsMzbyZpZAhGBpwiAaWSd+J2uQr9IT6gbOjf7UTrGW9e3OQ
         mkgA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+kLBF/0U3SmwclmvLY9sxzYbtudJp+sdM9VRm7/v/rA4Z9e1PgwaFETGL5oDJb0Vj3Rhp7zTPsA==@kvack.org
X-Gm-Message-State: AOJu0YxB8MrtQEJMqBDr1CSnTc7J1ImsE57jVSZxQYfiO7ciyZO9Asxk
	crJunOblSq3Kz6p09/I7ryHSazMeyI+y7B2LOEryOW2oexB5X7HbOnbtnbVc6oXaeFKn+dBFi+x
	XT+0BrIDYysdw+fyvHoefIWCH2ePNpmrQ4A4QdPYT
X-Gm-Gg: AfdE7clvKfv7z0Sj1mbTMr9PuaeMotY3vzNFC8Dhibmpq7rL92fZWTihX9hqD6qNF4t
	DZ1l76Zq1gYzb6HKjU5/8s71PwdC07hRHNtn8MiKkCCx1haw98UGewajLY2W6vKZFXs/INON2UX
	uorm+sO2vjPL/QSrOFWAHGIWTx11HKjhHTA/mLrnXeQ6G0Qr9Li2uFNIJnWsyWA4hR3Fvqn2YxA
	1U9j8wRnHIji/JlywKirQnEBhf+BZiYLAsa+V+mOdHRMPGAzNlpZ94O7rZEuHL5b96e/mE=
X-Received: by 2002:a05:622a:40c:b0:51c:7a8b:c3fe with SMTP id
 d75a77b69052e-51fa52b5f3emr2319101cf.23.1784166272682; Wed, 15 Jul 2026
 18:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-7-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-7-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:44:21 -0700
X-Gm-Features: AUfX_mxRzfbpXvPbtzleNmr4pCqVCmMSR5OiMWvVmadzdCakdqzD_65vP0JDxsA
Message-ID: <CAJuCfpGVDnBJ9eBFBYSG=x4iYRPQa8EXNwT8raCWLbNyHQgTpw@mail.gmail.com>
Subject: Re: [PATCH RFC 07/12] mm/slab: replace slab.stride with obj_exts_in_object
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EA71A0009
X-Stat-Signature: e1xxhg9gph7ef46ne81e7k4ygrbgqnkx
X-HE-Tag: 1784166274-278011
X-HE-Meta: U2FsdGVkX1/+22cQPPK8KDMIwto2nFJUS7Pkwcqnc/TTkDbv+U2h14l/4hQHU0Oxv7HOyVMBxRp8dpRVmGn/mL+p92t+VAFrgNCFIgqeYB0pCipvUyK3OopU46Fsm9zCMG7b8eFZMfz/BrdcnWfPRRxRfK2NMYOLo14TmViA35pYFpz6+PlsKQCMACMOOrDBmGBXOOks46Asbq8UM9IDvhUdDnVxhMA1O4Urn8ZYXBQd0OOXf1Gq+XaAaKG8iELdqpvntxWB6OhWPOWra6cZ3rKO+sk4Q+us93z4TqoemB/BmSA7jMB3nQqFVZKtji/6rJashoqT/IgqwVJJ3YP6vKDLsgEGhM6kwojFpUDA96ftkP0gOPw9sV9TTeqrHjQlGfu1nGN8Sac3spLwRZierm38FFb60h4h0act8g5zxQ+PII+ZF2vo24MVWwRodzBEWiG2EibO9lvaSgCMFlD04nIlLXXebvkSwOUKfytstjhVfV/rghbXoZywT3DlGuTnwP8RMzTfd7Qhk+uR6izQDl7d3L/JVh1SvCz2E2u9SzXD++itz28L1OT/Y0auwhzY9RdI/S7bJrBlRAjFemQmc/BWf229Ajwh76sHPG8/3KOm3BWEqMAIf53wKfWsydyU6Rlow4AymzxdPyD+dPEfpYgKclr5lFG5KaJADaA0pHIVVsIfoNVnpm/XXR4Oi56ckkkkSGr+5RCX0WVl7DP3UiQK1ab9qb75IdLDLEIXSPcz1swZfLuotGSy3hMfkQbEx0PMURpnHO/yx4dBvPKf0fR1Q4rMQsWZPqZewubzWBfbMp7/accZmA7oDsN57VY6PnNv9zEz1Cxw+6ulr/zid1kyw37d2HMmyLCAH62tYpZjwPRIrxJKUgZhJpuhrtHYxv/MhtB7Ir7l83/pDFltNxBPXtmT9InWBalOb4iDNRebDIYSg9unBOG1o6YRh+gblAY7SVY+1CXWaSkYIuK
 4qBemE4J
 r6hG5AGU+i7+oWx5MWO80vIOY28Isf/4RzxiY6xJ4Z7Ey5+36ZIotGyWNhA1VN4mFURLqpmIFjUfxL8KKMwMlqMpjC01ZHAT/hXIU2rVfAxEIdqtoeHrblrZSCXBhtjLcY8XajvE5bMw1t+bASfnh0yb09WNIIsJKY7EZ/hywkaq9jlKRnlGyxxrO/ZW9X2R2s4/fZMwn8k/gcr6FMeorEhgrm8EIzJTzYz1D3jzMSHegwj9D+ILPULFTUCW+Ti6YEJgTzGJHYw5Wy9ATjoN6iGhxul0CZGaEMONL0YgJqZbanzKElwtJPrt6c32XBCs2Kubo+05eI90fh78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> The stride field is used to convert object index to an slabobj_ext so
> both compact arrays (kmalloc() or in-slab-leftover) and spread
> in-object-padding obj_ext layouts are supported.
>
> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
>
> This simplifies the calculations, but with the upcoming slabobj_ext
> handling changes, it will be easier to stop storing the stride and
> instead just have a flag whether obj_ext is in the object padding.
> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
> can use that to determine the stride.
>
> No functional change intended. Performance impact TBD, hopefully
> in the noise.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 43 ++++++++++++++++++++++++-------------------
>  mm/slub.c | 42 ++++++++++++++++--------------------------
>  2 files changed, 40 insertions(+), 45 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index e3f8e42070f1..3ad9777ad600 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -81,10 +81,10 @@ struct freelist_counters {
>  #ifdef CONFIG_64BIT
>                                         /*
>                                          * Some optimizations use free bi=
ts in 'counters' field
> -                                        * to save memory. In case ->stri=
de field is not available,
> +                                        * to save memory. If these free =
bits are not available,
>                                          * such optimizations are disable=
d.
>                                          */
> -                                       unsigned int stride;
> +                                       unsigned obj_exts_in_object:1;
>  #endif
>                                 };
>                         };
> @@ -617,22 +617,20 @@ static inline void put_slab_obj_exts(unsigned long =
obj_exts)
>  }
>
>  #ifdef CONFIG_64BIT
> -static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e)
> +static inline bool obj_exts_in_object(struct slab *slab)
>  {
> -       slab->stride =3D stride;
> -}
> -static inline unsigned int slab_get_stride(struct slab *slab)
> -{
> -       return slab->stride;
> +       /*
> +        * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and n=
eed to
> +        * check the per-slab bit. A cache can have SLAB_OBJ_EXT_IN_OBJ s=
et, but
> +        * allocations within_slab_leftover are preferred. And those may =
be
> +        * possible or not depending on the particular slab's size.
> +        */
> +       return slab->obj_exts_in_object;
>  }
>  #else
> -static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e)
> +static inline bool obj_exts_in_object(struct slab *slab)
>  {
> -       VM_WARN_ON_ONCE(stride !=3D sizeof(struct slabobj_ext));
> -}
> -static inline unsigned int slab_get_stride(struct slab *slab)
> -{
> -       return sizeof(struct slabobj_ext);
> +       return false;
>  }
>  #endif
>
> @@ -656,8 +654,14 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab=
, unsigned long obj_exts,
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
>         index =3D obj_to_index(s, slab, obj);
> -       obj_ext =3D (struct slabobj_ext *)(obj_exts +
> -                                        slab_get_stride(slab) * index);
> +
> +       if (!obj_exts_in_object(slab)) {
> +               obj_ext =3D ((struct slabobj_ext *)obj_exts) + index;
> +       } else {
> +               unsigned int stride =3D s->size;
> +               obj_ext =3D (struct slabobj_ext *)(obj_exts + index * str=
ide);
> +       }
> +
>         return kasan_reset_tag(obj_ext);
>  }
>
> @@ -693,9 +697,10 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab=
, unsigned long obj_exts,
>         return NULL;
>  }
>
> -static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e) { }
> -static inline unsigned int slab_get_stride(struct slab *slab) { return 0=
; }
> -
> +static inline bool obj_exts_in_object(struct slab *slab)
> +{
> +       return false;
> +}
>
>  #endif /* CONFIG_SLAB_OBJ_EXT */
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 2bfcabc4c51a..98a14e5842a2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -870,18 +870,6 @@ static inline bool obj_exts_in_slab(struct kmem_cach=
e *s, struct slab *slab)
>  #endif
>
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> -static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
> -{
> -       /*
> -        * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and n=
eed to
> -        * check the stride. A cache can have SLAB_OBJ_EXT_IN_OBJ set, bu=
t
> -        * allocations within_slab_leftover are preferred. And those may =
be
> -        * possible or not depending on the particular slab's size.
> -        */
> -       return obj_exts_in_slab(s, slab) &&
> -              (slab_get_stride(slab) =3D=3D s->size);
> -}
> -
>  static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
>  {
>         unsigned int offset =3D get_info_end(s);
> @@ -896,16 +884,20 @@ static unsigned int obj_exts_offset_in_object(struc=
t kmem_cache *s)
>
>         return offset;
>  }
> -#else
> -static inline bool obj_exts_in_object(struct kmem_cache *s, struct slab =
*slab)
> +
> +static inline void slab_set_obj_exts_in_object(struct slab *slab)
>  {
> -       return false;
> +       slab->obj_exts_in_object =3D 1;
>  }
> -
> +#else
>  static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *=
s)
>  {
>         return 0;
>  }
> +
> +static inline void slab_set_obj_exts_in_object(struct slab *slab)
> +{
> +}
>  #endif
>
>  #ifdef CONFIG_SLUB_DEBUG
> @@ -1206,7 +1198,7 @@ static void print_trailer(struct kmem_cache *s, str=
uct slab *slab, u8 *p)
>
>         off +=3D kasan_metadata_size(s, false);
>
> -       if (obj_exts_in_object(s, slab))
> +       if (obj_exts_in_object(slab))
>                 off +=3D sizeof(struct slabobj_ext);
>
>         if (off !=3D size_from_object(s))
> @@ -1411,7 +1403,7 @@ static int check_pad_bytes(struct kmem_cache *s, st=
ruct slab *slab, u8 *p)
>
>         off +=3D kasan_metadata_size(s, false);
>
> -       if (obj_exts_in_object(s, slab))
> +       if (obj_exts_in_object(slab))
>                 off +=3D sizeof(struct slabobj_ext);
>
>         if (size_from_object(s) =3D=3D off)
> @@ -1439,7 +1431,7 @@ slab_pad_check(struct kmem_cache *s, struct slab *s=
lab)
>         length =3D slab_size(slab);
>         end =3D start + length;
>
> -       if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
> +       if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(slab)) {
>                 remainder =3D length;
>                 remainder -=3D obj_exts_offset_in_slab(s, slab);
>                 remainder -=3D obj_exts_size_in_slab(slab);
> @@ -2253,9 +2245,6 @@ static void alloc_slab_obj_exts_early(struct kmem_c=
ache *s, struct slab *slab)
>         void *addr;
>         unsigned long obj_exts;
>
> -       /* Initialize stride early to avoid memory ordering issues */
> -       slab_set_stride(slab, sizeof(struct slabobj_ext));
> -
>         if (!need_slab_obj_exts(s))
>                 return;
>
> @@ -2289,7 +2278,7 @@ static void alloc_slab_obj_exts_early(struct kmem_c=
ache *s, struct slab *slab)
>                 obj_exts |=3D MEMCG_DATA_OBJEXTS;
>  #endif
>                 slab->obj_exts =3D obj_exts;
> -               slab_set_stride(slab, s->size);
> +               slab_set_obj_exts_in_object(slab);
>         }
>  }
>
> @@ -3402,9 +3391,10 @@ static struct slab *allocate_slab(struct kmem_cach=
e *s, gfp_t flags,
>                 stat(s, ORDER_FALLBACK);
>         }
>
> +       /* Initializes frozen, inuse, and any extra 64bit-only flags */
> +       slab->counters =3D 0;
> +
>         slab->objects =3D oo_objects(oo);
> -       slab->inuse =3D 0;
> -       slab->frozen =3D 0;
>
>         slab->slab_cache =3D s;
>
> @@ -6537,7 +6527,7 @@ static inline size_t slab_ksize(struct slab *slab)
>          */
>         if (s->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_STORE_USER))
>                 return s->inuse;
> -       else if (obj_exts_in_object(s, slab))
> +       else if (obj_exts_in_object(slab))
>                 return s->inuse;
>         /*
>          * Else we can use all the padding etc for the allocation
>
> --
> 2.55.0
>

