Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24A2C44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 01:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F9A6B0093; Wed, 15 Jul 2026 21:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837186B0095; Wed, 15 Jul 2026 21:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E1E6B0096; Wed, 15 Jul 2026 21:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 445AA6B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:28:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C50A340375
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:28:01 +0000 (UTC)
X-FDA: 84992903562.02.3034881
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF2FF40004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:27:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b5Y5F4f4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784165279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
	b=AwCaUArzQfcIzy1Cq7QysYd30C828r3puB0xFpYoPzZ9KKdXFQL1V7clUHrLFU4/oYxXZJ
	bVmW18LKOwvE25v2RPen1b9dxtNV6m2txP6flXEgQBCdmdx8iRjyJd3x/gSXDhLIeqyrr2
	iRaWQTXVKcKgXlv3mu5WGuCb585lZwQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b5Y5F4f4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784165279;
	b=YRN4UXs57P33uHNM5S4GVPGVZPq1iPTVAaEaKF5KNaQqO1sYMdrcTVOB9eS511IFJPkhKp
	1LlMKj0S85l7TqOl0TP4t4dbA+tVl4uK9iWVs7L9SqEq+9e5e0MJvYdjm75XDLxeSVH8kd
	qJMJO4sfPypQUkbUTnGi4lvNWavy2Rs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c10e86e52so79411cf.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784165279; cv=none;
        d=google.com; s=arc-20260327;
        b=l4wYyZCzawX5qMhCQD8YQM3nn2gUmjqY1R9r4UdBAzDJbPIirWvXYSZtPiWEzl7fUZ
         ax19SbQUS1Anm/jEe7AmjB0b2alEVyRRoeUIxsYPlxOEiq5knELqksBunn7+cybVB/my
         qtc8ZIC8Sd/cPv7xgM2DlA4wtjabiuKyoNPcWohNBXalPB4+onFuWn2StT9EJuzwVD3t
         +0/nvmSmtmbPzbIOuEZeCREy18sp2NEq9/tCNnb101wZIqVY+64DPt379xZsElQ4v0GS
         ozjqzc+LX/yiNg1OQoKWviMIuCwdV3ehYBlE1o9Ny4l9iSfauVemMyUo/zEDN8P5R9Gp
         JQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
        fh=ma5qIAYPeU4uP8VL8pSDOArjSGqcZbIRIanJ6U3I1HY=;
        b=m1ZfH9oi6pkP7wr3fzGoxZ6ITO6ri/qdo2MjyAiVidBe/qbwOp4KAp7GqSn0ZjBxc/
         /XFT4Cm2Y6aQBQuBc2tr6P+hZA4ZTE8aFGgw/LTTuzxjfyKQETDZ0pGlMPzFyZZnZYHd
         RtEUfHaZNvQZeRIZA9P/1T5/kWWjeRTXOwFNnC8EOCJiUSqdmIde0MObe1TGvb2y3wax
         XtKC7lhXTMrmekxMejWRlO1tTg5BkM3ymZaLu4SYoo2haeliGcZO0jjYaMe3oHPob2zg
         egTWHvt7Ty//thUT3PMlrAsR40vHw5ILXPduTwKMZHSSNSp9aVi6CaES1ZvhKH+mJ/Ot
         POuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784165279; x=1784770079; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
        b=b5Y5F4f4/1DPNti5BLpwDUsxuYFPu9+pRupjBza4XTMAL6tchswXlQusTgFEnLb2DE
         LPN2i5fT4KrZPcWgKsoEjsTGdNXw/WGmY7rFVhhA2MAPDrw+e3+to4Kiiew83nJ978e/
         95qerfcIKGDfdAq/SO9wte4vTpfWXtUIp5Gzv8LuLtaEEvTWc81mbV568enDbYtcOdPG
         HVy9/thgdTPbW5NMO8HS3kV4TIK4VeGqCIgZHKcayZZ8znUiUkmwBQgq448ESBxMAtfG
         MIWud7eTbt78LNGALC9OI1hOTdRWU2/TWIz1ovH8FOqHETOdYh/zOyfxlX3dtvJSCAXm
         cfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784165279; x=1784770079;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
        b=EmvRIv1ecw5EbUIIYfRxIhxDhJ9vt4UCykCQeH7zYpUv8HRGri/uc7DSTpTB3apYz9
         MhKKOA+SPKBUAbxl0SUlSdSfd9eZkBz+hPdgnq+u2LJ54/uQo3lVlPhgKoeVgSGrPPQk
         XuCmyzClnDbG4VSf2lWaYJeBGKDpxgIjVkqhE8spoB6kYRY49C8/4F3eUlBzFcw/TFoP
         bksVFNKImOGOWHgM8x7jFOOaE3AYbxHWqUc1Eh2amvhh73jx539ojNyvUO/wPyJF5thz
         TtbTC/hlGdCvXcESfKkjefS+hUmftbJbaQjz2DBvlV+hG3LGAfTFzWXrBu95jWR00YYm
         k+HQ==
X-Forwarded-Encrypted: i=1; AHgh+RqATek6l7nmQxfKjo3OvBEhPLPOABerBw7RT3iiX3ZOlTRkDyBGAthCofcLOlkRtdYUoNu3NRUnXg==@kvack.org
X-Gm-Message-State: AOJu0YySnVx3eSMDw4Og7PJMDyfylXtD6Lkf9VJOhrg3u0g5feEjntOQ
	VhOpNzp5oVNUY9kry3wslvVp6oluQFdN0OuZWLaiPg9+3ThRar4XZTN9QcK+F/WBLxatf9EjThL
	8mt7G6IkITkyHoLuNQGR96EGEWNbMyBMcA4v7SnpI
X-Gm-Gg: AfdE7cnQ2XZJ14KD4wiT7G4eY4QuMOWHf3vPuMF4MsAn9Mobr18NonF+A3GwaKalpHU
	WqaLKt6k5MufYASp+7M2goW0BviM4XjnuwGlAXdsOzN1imRXdqCSGPYkUmDtmaVnC6RAp2G/hYw
	7u8WRR4IOs5pkEoi8luGkM+JS6iECl9RR4GVf4YWRn2tir3YEGYTZnEqUiM4QSmrK4TKPqoUxfN
	RKL3YR3BYQTakbTsdIeEvBw0yhuBJsqPxngv9359GDF72x+ah1EQYEkdq/q
X-Received: by 2002:ac8:57cb:0:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51f7d272648mr4128911cf.2.1784165278136; Wed, 15 Jul 2026
 18:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:27:47 -0700
X-Gm-Features: AUfX_mw0hxBE87l_puhHNr7S0k7RJO-VLoBt5DLKGkywTu7tTOxb6OYu6XzRYSU
Message-ID: <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF2FF40004
X-Stat-Signature: 1oy5udrs5831szdbsjee8wsm9nas7s37
X-HE-Tag: 1784165279-981687
X-HE-Meta: U2FsdGVkX1+/jAtNYCHo6ga4wETewhRrbqp/ulBrwvgSkMFP/YgTCvvVNpQWlYEOruPEZTbjtouqsrCyXOaBdhFaSU+VjGmlps6Tdqh34VzamgpQ7r7xWIQZ6VnOFYFy7M5Y0zBVr2mrJh0/qdx6fjbLETlAvfol9K8ZQ9LNEVbB8IClRmLYBxoEn6yCKywDev3JVsZhSaNgTvuyAlWDnHuk2cOItNKmubiSNafKghG6Hhec9+a3COzshPVVRQYs7FzJglZfygdf9VSgSmOQdePdvQ37iQFHhDQYDVBm3PnIDEH3yGWW9pAXgVcKOGaEl25twKTFpqnXU2GC0h8Bi29F/MwACHLirs84YWDbJxtblbqxAcRnZisDWSSRgKzBkjEPylise3FTzrWgfXSQaGcD+3PUoLypUXQ75BUhKqOMI/gNiqxfaNQTrzkmjhSwYkyMwATMIU1gnHllO6on7TyvX3g27V1x+oYn+ewgbraWEE1qHfINLGYDex8I5Xr0+pXeIDeACZVxVv1ujGtNdReCRXaAoCZJkW3fLkjXP2Fnemu6yFrtcnA/Ki/KhUqIU0BeIJ/PtsZGu/t/wuj3qI0hDKJOAdbW28emzb/5M543TJ1J1gJfVhQxWjsAAblxfHQUs+mjoJgBYavTFWlhnM19QkqpFb/WqjvCxS5c2mrM2swrZi/YNDhV4Pg7+AjcObdWMkQZ0/Z2FGx6H5lp9V9LAdwnh//iyHHNFpf9VMjQRsu2qqZHgcBhi+uEbDSgNxDD0F/Zwv13Y+5A2eGz/qBTm0Blh8IIlqNQdsfgLpslsEZK+11WGhRuwFJcoqKJFtgTkJ4rs95uZkSLpmshyXDlenoA94qIg9tMA/hbkHZhq4IN74k6kx4NvgLq4/dTzkIccyKvWyt5wWI2oSeidJpW1QTJe6U4k2XJUpIwhKjmaYkFxk+WgrJAfwN1o8XfKcNBe2SknpY1NS2s6hc
 UHhWrjMQ
 agNIQoMre+UGqS+7HAlZhz5oFrfe9n1FnYB+wQf+fa7dwKE0bk1L2YvdMIP3pYIWTIL21VdaJco7JPwPht5vaQ/bLhFScGjYc1yIzpgkXHN5Y7KOUThMkZHGudo6kNVvqCi8ORxZT2x9yV6L5KCwpmEpMJ13WmPOlRl1Tpxeh0HGHjzJzeUB2NzMx0C7svUeKFrv0v+PHf5g6KaY68H5nJic3B4SAl/QcsOvMqUTsWSfnRx0D4LAlrIT5t67r0k4/z0T7qeBfUy6Mg+2eUqkR0eYuD34TW1jvvKlH8VPAPUXkOcMWqEmk/J3qKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> In preparation for changes to the structure, abstract access to the
> objcg field with a slab_obj_ext_objcgp() function.
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
>
> No functional change intended.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/core.c |  2 +-
>  mm/memcontrol.c  | 23 +++++++++++++++--------
>  mm/slab.h        |  9 ++++++++-
>  mm/slub.c        |  2 +-
>  4 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6577bd76954e..717e8baf7e5d 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -1249,7 +1249,7 @@ void __kfence_free(void *addr)
>         struct kfence_metadata *meta =3D addr_to_metadata((unsigned long)=
addr);
>
>  #ifdef CONFIG_MEMCG
> -       KFENCE_WARN_ON(meta->obj_exts.objcg);
> +       KFENCE_WARN_ON(*slab_obj_ext_objcgp(&meta->obj_exts));
>  #endif
>         /*
>          * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer fr=
eeing
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4e427286a88a..6303a2b1a9d0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2865,6 +2865,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct =
slab *slab, void *p)
>          */
>         unsigned long obj_exts;
>         struct slabobj_ext *obj_ext;
> +       struct obj_cgroup *objcg;
>
>         obj_exts =3D slab_obj_exts(slab);
>         if (!obj_exts)
> @@ -2872,9 +2873,8 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct =
slab *slab, void *p)
>
>         get_slab_obj_exts(obj_exts);
>         obj_ext =3D slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
> -       if (obj_ext->objcg) {
> -               struct obj_cgroup *objcg =3D obj_ext->objcg;
> -
> +       objcg =3D *slab_obj_ext_objcgp(obj_ext);
> +       if (objcg) {
>                 put_slab_obj_exts(obj_exts);
>                 return obj_cgroup_memcg(objcg);
>         }
> @@ -3577,6 +3577,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>                 unsigned long obj_exts;
>                 struct slabobj_ext *obj_ext;
>                 struct obj_stock_pcp *stock;
> +               struct obj_cgroup **objcgp;
>
>                 slab =3D virt_to_slab(p[i]);
>
> @@ -3612,10 +3613,15 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cac=
he *s, struct list_lru *lru,
>                 unlock_stock(stock);
>
>                 obj_exts =3D slab_obj_exts(slab);
> +
>                 get_slab_obj_exts(obj_exts);
> +
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> +               objcgp =3D slab_obj_ext_objcgp(obj_ext);
> +
>                 obj_cgroup_get(objcg);
> -               obj_ext->objcg =3D objcg;
> +               *objcgp =3D objcg;
> +
>                 put_slab_obj_exts(obj_exts);
>         }
>
> @@ -3628,16 +3634,17 @@ void __memcg_slab_free_hook(struct kmem_cache *s,=
 struct slab *slab,
>         size_t obj_size =3D obj_full_size(s);
>
>         for (int i =3D 0; i < objects; i++) {
> -               struct obj_cgroup *objcg;
> +               struct obj_cgroup **objcgp, *objcg;
>                 struct slabobj_ext *obj_ext;
>                 struct obj_stock_pcp *stock;
>
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> -               objcg =3D obj_ext->objcg;
> -               if (!objcg)
> +               objcgp =3D slab_obj_ext_objcgp(obj_ext);
> +               if (!*objcgp)
>                         continue;
>
> -               obj_ext->objcg =3D NULL;
> +               objcg =3D *objcgp;
> +               *objcgp =3D NULL;
>
>                 stock =3D trylock_stock();
>                 __refill_obj_stock(objcg, stock, obj_size, true);
> diff --git a/mm/slab.h b/mm/slab.h
> index 36d067d6e7c0..789bd292075f 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
>   */
>  struct slabobj_ext {
>  #ifdef CONFIG_MEMCG
> -       struct obj_cgroup *objcg;
> +       struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>         union codetag_ref ref;
> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab=
, unsigned long obj_exts,
>         return kasan_reset_tag(obj_ext);
>  }
>
> +#ifdef CONFIG_MEMCG
> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext=
 *obj_ext)

I understand why you need to return obj_cgroup** but maybe instead we
can have a separate setter function and just return a pointer here?
That would also help catch cases when someone wants to set
obj_ext._objcg that was optimized away (for that the setter would need
an additional parameter to identify whether we allocated optimized
objext vector).

> +{
> +       return &obj_ext->_objcg;
> +}
> +#endif
> +
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 5e3f53bcd0d3..48e10198a3ce 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         if (obj_exts) {
>                 get_slab_obj_exts(obj_exts);
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p);
> -               if (unlikely(obj_ext->objcg)) {
> +               if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
>                         put_slab_obj_exts(obj_exts);
>                         return true;
>                 }
>
> --
> 2.55.0
>

