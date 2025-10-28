Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B17CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49948801A0; Tue, 28 Oct 2025 13:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470D980199; Tue, 28 Oct 2025 13:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386D0801A0; Tue, 28 Oct 2025 13:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24F1480199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:55:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C61F088AF8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:55:53 +0000 (UTC)
X-FDA: 84048276186.13.97C4382
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id CBC8F160011
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:55:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BWv79444;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761674151; a=rsa-sha256;
	cv=none;
	b=r+EZJHfv1jFagXV8YQ+1iQ9sagg7DXY+oxjNx4ngnVoCoEB38SnhV6mc5d71FgcLY44nSZ
	6IcDREjvI/HBbOlcoluMGsCZ6E8INbZIWHS3VazeauU1M7cPFK6UWmO8OMiN1EZA3q0T3N
	2VA2XMQJ0EKlZT3yTWXSs9IVcgMiMyY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BWv79444;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761674151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEQPDQeMOb+zP03ZLfbq8HiFiymDeHxHs9qyniKVrJQ=;
	b=2QfIgPOUi73ZSec6v2KetSjfevi0GVmDILUBG/hpV7RnHMG97q2IqWkZty4ZLgqzQRhwve
	ysTgzypnq+3zePTT1yGunJOjrRT2NJM7hz63dmupC987P8ZYdWazvzeiny3vPYp7x6vTkd
	YYaDcbNcOQbWYJX0Q3eQO7pHBYB2YS8=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ecfafb92bcso31371cf.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761674151; x=1762278951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEQPDQeMOb+zP03ZLfbq8HiFiymDeHxHs9qyniKVrJQ=;
        b=BWv79444HunJNedJF37V9YMWTDPNDVwzK1pPCP3aPO8BF49Q4RENLu/bD96dhfb+Td
         b7m6k1/HZeRp40Y8T44wbNejk7Zb9gmvevJiifHtAf1477ozIDil01t4Nkvz/4tPCVG2
         2v50PbC6fV5iM5ovcF2wFm0gs5Vo91U4CNyvld3WAWzRwOTKHURqPab/NqFX3Xi4Ub6g
         qZx6+OYHFSnVLBZPp6zngE/yfwEDbwWWa+e++kXCB8zTm/btKQeskJYtLNQqo4f5j9qZ
         MIdQVbCVqFlbJV0vfbiOPv+p0UYLoa+HC643vGChvKD/u5MXSAJz0AXok4qtJdTUIOSK
         Febg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761674151; x=1762278951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEQPDQeMOb+zP03ZLfbq8HiFiymDeHxHs9qyniKVrJQ=;
        b=IoJylljNIsDcd2p5vDN8pUvakaeSVx/LmJKQhf56S6Mf+9Qo21BMUuXiM0rM8T0y2Y
         NVbk5RoRrwXpHv/GfWzNQu22bSgyBh/uyImwOMtZP44BUh3NnExH4nBo38TVX8hUROH7
         CxwwWYILxOR0TpZf3HosYf89NuHcmwplrv4jvnpfrZFlUqcb07mGiNQW8BoH+SO4W6sn
         f0UjXTJOtgEVdv2HqFRmS3AJ/ucerUKWc4wfIvFabDHa9jA3bIMYFhqIpcGnp025zPk9
         JPqH6aOfNhcnKulDJSo+sfO2hTWKJNbIyy1fbFA0kgHdTXsH4J1aCzdVAl5lpHMnwyf1
         cE2A==
X-Forwarded-Encrypted: i=1; AJvYcCUWrWH2Hmwa5vL2oaMI/O2Wr0AJsmyr4ReoTar8zicf+h7xlpaXC8AGsotgiibeXD/BmwQ/2UHuOg==@kvack.org
X-Gm-Message-State: AOJu0Yy8l5+fRPMf89HFOXQ80bdcbuBJPdAWxOzo6MXAMXiqR8jd/khP
	fZcDP6bAa7xlubE5rofBxfbWWlTWi8r/N1YnLwO2jzzrmqf11rc/3zVkc51VlFPRY5sRwHQiw+b
	KtLQbQD2u/2nv746hKa2UoCyWhfvlUNx8uSdNpcG9
X-Gm-Gg: ASbGncszGwuucp1xtjdJP2IUkiNbNlEfgjIx+QvBiJ8bgsT/Noc9Hm7O1XMOfNWbOf6
	g163u0dCttXxjsuXFSptArUPCnsFzMvzCH9WdB+uYbeGF6IezPFZWfglliEFn33+Ebg9qQ/ROsh
	0J0PRB0UEraPXpeTeH4/aUfx3HVEfvMjx+iW20hNAZ0q/pfn6XpC2lCJURgBRaevhcifGzaSPSV
	WCU2O5QU0YEXIFqMZHtHUiV/QMNseDhFeB3687Maa8lhQy+XxKrUdimSGraMbh9RoHvXM/l1ohA
	7eV3NKg2lRdLspah3BjMUtAmpw==
X-Google-Smtp-Source: AGHT+IE4E344p3HvFpIsLYI5M9X4WV2Y7oB0kX580su6zBAwlKd1hdG3cfoOpCRO56waorA3KTYtH/DLpgCm8hLFEkg=
X-Received: by 2002:a05:622a:1307:b0:4e8:b04a:82e3 with SMTP id
 d75a77b69052e-4ed1588e627mr400851cf.10.1761674150355; Tue, 28 Oct 2025
 10:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-4-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-4-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 10:55:39 -0700
X-Gm-Features: AWmQ_bndOQ1c1b7afJ0YZYVN9VO4Il9GK8ViNlP50-zWVw6oU176SbWk_uCfUOQ
Message-ID: <CAJuCfpE9PRvd1Tsm6gAvxKvPFgVt640q3vSbt0wAWOa3G4tnfA@mail.gmail.com>
Subject: Re: [RFC PATCH V3 3/7] mm/slab: abstract slabobj_ext access via new
 slab_obj_ext() helper
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: dh9ghef5ydp6m7xs1bkpidy7pwm9s54b
X-Rspamd-Queue-Id: CBC8F160011
X-Rspamd-Server: rspam09
X-HE-Tag: 1761674151-445226
X-HE-Meta: U2FsdGVkX1/oIONVOacrj3pjyAV0NjIU4K0gt5/dmmECWDZSKiJVk3VpcuzEJ+ioX7jw8zNrZiJl5DrK+UkBW6TFNnpIGb06pmuYu6mjPrPCmRSBzPdpClua5jxLzOAhYlaHBigFbaG04YSozdAfmhY5F0frviXuwam2iJpr9Jk/mn+oeDFjBqQy6XWOXyRylNWpOipXbKDkPNKRzO7rehO26/rU2nlGwy6Z0y1gUCHZTwLBwt9oOkoxBS9UNH0OITM9Xw0fYvWu7+2dy7xBYBHqlkZA1mOMH09Svt2URym0oOXZF/5NgRK7Oa5LUy+ZqAiR2xF40bQi8IEOLjRi4F2G7kSJsQtgnPi6OGVW8aJfA5hc9al8PGtCLJPcCJpjSWjnjYwvxFS67KWPLLgKjAKn3J8Rkkf9dktN3Ywm/qswJF7C+BNiA5eXJkT9QcC0LiJiaG1k/DwAeiXT0VvB7KLEUJoltadXmqcKoYJpoRBuBKAp4wjozpGgYc+jGCZqiPYqoyVVvdd1QO1dIQALCWJWBkXp+1KxWr+ckK0EuapqbtE9OKiXrA6Uv/cAYGbd+Wd3YSTAJTRe6yak3aJLH3+lKc2WIfGabWI5d3iNXErMt+uxYQ9uWPCj5SAGlpNfhY97GQSu81+JlhSXs0VlT7mlSsc/o9cbeneHUeXlGL95OGK0WRSYcAm7icbzF1vTlzoXhYtKSWeMbT9Tgwx+nRiC3jtbkiQBH2+r0SA9EkNhmwzI+fZ/Xk/jsfUd3HD6OPaItCOzg493erWivaCv3q24T6uGdstFNukYddAOMPJp2chmTz+g840I1HMPwbxituNYzpXq5ZIva+0nTBn4QPVJvt4ynETQjRoAlkZTEnVuoP29Vvmr0ZlWdbv+YQeY8ugorolNWqMQvI5Ityo8WN4sqGVw/vOLQIMbfr4y/vOe4bvEyCR8d5izjWozmGhZmFaRb4KoLhy9/lm3oP5
 oG7NZJAd
 aUBxdKJAZuRkgu89cE3usW9F78e78OAbxse5w/zotJ4wMkZyTrzxBDc/Ep7+/9NYwS7limIr5zDVFmKx4mVzB2FU35Tq7pTGy9VwSR3a0eWSabKSDnHr9BKsMS2LpXjh8bhQtCaSvlm1Je/wUiXOGKVa8kLdgG9TgqbADIMeIDu4FXhB7oJ3Knil+rUF8+B2eJUCOrW78yGkJr8eiwSppl4VMWzNhxtBTEV+1QeyE4Oj7hp5/Ydhq6oHKxxeDKdyKKPLbKgqHG/azQ0Lw6SDSGIZgEblWGSSlgynwUbqj3QJiawM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> Currently, the slab allocator assumes that slab->obj_exts is a pointer
> to an array of struct slabobj_ext objects. However, to support storage
> methods where struct slabobj_ext is embedded within objects, the slab
> allocator should not make this assumption. Instead of directly
> dereferencing the slabobj_exts array, abstract access to
> struct slabobj_ext via helper functions.
>
> Introduce a new API slabobj_ext metadata access:
>
>   slab_obj_ext(slab, obj_exts, index) - returns the pointer to
>   struct slabobj_ext element at the given index.
>
> Directly dereferencing the return value of slab_obj_exts() is no longer
> allowed. Instead, slab_obj_ext() must always be used to access
> individual struct slabobj_ext objects.

If direct access to the vector is not allowed, it would be better to
eliminate slab_obj_exts() function completely and use the new
slab_obj_ext() instead. I think that's possible. We might need an
additional `bool is_slab_obj_exts()` helper for an early check before
we calculate the object index but that's quite easy.

>
> Convert all users to use these APIs.
> No functional changes intended.
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/memcontrol.c | 23 ++++++++++++++++-------
>  mm/slab.h       | 43 ++++++++++++++++++++++++++++++++++++------
>  mm/slub.c       | 50 ++++++++++++++++++++++++++++---------------------
>  3 files changed, 82 insertions(+), 34 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8dd7fbed5a94..2a9dc246e802 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2566,7 +2566,8 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struct=
 folio *folio, void *p)
>          * slab->obj_exts.
>          */
>         if (folio_test_slab(folio)) {
> -               struct slabobj_ext *obj_exts;
> +               unsigned long obj_exts;
> +               struct slabobj_ext *obj_ext;
>                 struct slab *slab;
>                 unsigned int off;
>
> @@ -2576,8 +2577,9 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struct=
 folio *folio, void *p)
>                         return NULL;
>
>                 off =3D obj_to_index(slab->slab_cache, slab, p);
> -               if (obj_exts[off].objcg)
> -                       return obj_cgroup_memcg(obj_exts[off].objcg);
> +               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               if (obj_ext->objcg)
> +                       return obj_cgroup_memcg(obj_ext->objcg);
>
>                 return NULL;
>         }
> @@ -3168,6 +3170,9 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>         }
>
>         for (i =3D 0; i < size; i++) {
> +               unsigned long obj_exts;
> +               struct slabobj_ext *obj_ext;
> +
>                 slab =3D virt_to_slab(p[i]);
>
>                 if (!slab_obj_exts(slab) &&
> @@ -3190,29 +3195,33 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cac=
he *s, struct list_lru *lru,
>                                         slab_pgdat(slab), cache_vmstat_id=
x(s)))
>                         return false;
>
> +               obj_exts =3D slab_obj_exts(slab);
>                 off =3D obj_to_index(s, slab, p[i]);
> +               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
>                 obj_cgroup_get(objcg);
> -               slab_obj_exts(slab)[off].objcg =3D objcg;
> +               obj_ext->objcg =3D objcg;
>         }
>
>         return true;
>  }
>
>  void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
> -                           void **p, int objects, struct slabobj_ext *ob=
j_exts)
> +                           void **p, int objects, unsigned long obj_exts=
)
>  {
>         size_t obj_size =3D obj_full_size(s);
>
>         for (int i =3D 0; i < objects; i++) {
>                 struct obj_cgroup *objcg;
> +               struct slabobj_ext *obj_ext;
>                 unsigned int off;
>
>                 off =3D obj_to_index(s, slab, p[i]);
> -               objcg =3D obj_exts[off].objcg;
> +               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               objcg =3D obj_ext->objcg;
>                 if (!objcg)
>                         continue;
>
> -               obj_exts[off].objcg =3D NULL;
> +               obj_ext->objcg =3D NULL;
>                 refill_obj_stock(objcg, obj_size, true, -obj_size,
>                                  slab_pgdat(slab), cache_vmstat_idx(s));
>                 obj_cgroup_put(objcg);
> diff --git a/mm/slab.h b/mm/slab.h
> index d63cc9b5e313..df2c987d950d 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -528,10 +528,12 @@ static inline bool slab_in_kunit_test(void) { retur=
n false; }
>   * associated with a slab.
>   * @slab: a pointer to the slab struct
>   *
> - * Returns a pointer to the object extension vector associated with the =
slab,
> - * or NULL if no such vector has been associated yet.
> + * Returns the address of the object extension vector associated with th=
e slab,
> + * or zero if no such vector has been associated yet.
> + * Do not dereference the return value directly; use slab_obj_ext() to a=
ccess
> + * its elements.
>   */
> -static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
> +static inline unsigned long slab_obj_exts(struct slab *slab)
>  {
>         unsigned long obj_exts =3D READ_ONCE(slab->obj_exts);
>
> @@ -544,7 +546,30 @@ static inline struct slabobj_ext *slab_obj_exts(stru=
ct slab *slab)
>                        obj_exts !=3D OBJEXTS_ALLOC_FAIL, slab_page(slab))=
;
>         VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
>  #endif
> -       return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
> +
> +       return obj_exts & ~OBJEXTS_FLAGS_MASK;
> +}
> +
> +/*
> + * slab_obj_ext - get the pointer to the slab object extension metadata
> + * associated with an object in a slab.
> + * @slab: a pointer to the slab struct
> + * @obj_exts: a pointer to the object extension vector
> + * @index: an index of the object
> + *
> + * Returns a pointer to the object extension associated with the object.
> + */
> +static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> +                                              unsigned long obj_exts,
> +                                              unsigned int index)
> +{
> +       struct slabobj_ext *obj_ext;
> +
> +       VM_WARN_ON_ONCE(!slab_obj_exts(slab));
> +       VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
> +
> +       obj_ext =3D (struct slabobj_ext *)obj_exts;
> +       return &obj_ext[index];
>  }
>
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> @@ -552,7 +577,13 @@ int alloc_slab_obj_exts(struct slab *slab, struct km=
em_cache *s,
>
>  #else /* CONFIG_SLAB_OBJ_EXT */
>
> -static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
> +static inline unsigned long slab_obj_exts(struct slab *slab)
> +{
> +       return false;
> +}
> +
> +static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> +                                              unsigned int index)
>  {
>         return NULL;
>  }
> @@ -569,7 +600,7 @@ static inline enum node_stat_item cache_vmstat_idx(st=
ruct kmem_cache *s)
>  bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru =
*lru,
>                                   gfp_t flags, size_t size, void **p);
>  void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
> -                           void **p, int objects, struct slabobj_ext *ob=
j_exts);
> +                           void **p, int objects, unsigned long obj_exts=
);
>  #endif
>
>  void kvfree_rcu_cb(struct rcu_head *head);
> diff --git a/mm/slub.c b/mm/slub.c
> index 64705cb3734f..ae73403f8c29 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2031,7 +2031,7 @@ static bool freelist_corrupted(struct kmem_cache *s=
, struct slab *slab,
>
>  static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>  {
> -       struct slabobj_ext *slab_exts;
> +       unsigned long slab_exts;
>         struct slab *obj_exts_slab;
>
>         obj_exts_slab =3D virt_to_slab(obj_exts);
> @@ -2039,9 +2039,12 @@ static inline void mark_objexts_empty(struct slabo=
bj_ext *obj_exts)
>         if (slab_exts) {
>                 unsigned int offs =3D obj_to_index(obj_exts_slab->slab_ca=
che,
>                                                  obj_exts_slab, obj_exts)=
;
> +               struct slabobj_ext *ext =3D slab_obj_ext(obj_exts_slab,
> +                                                      slab_exts, offs);
> +
>                 /* codetag should be NULL */
> -               WARN_ON(slab_exts[offs].ref.ct);
> -               set_codetag_empty(&slab_exts[offs].ref);
> +               WARN_ON(ext->ref.ct);
> +               set_codetag_empty(&ext->ref);
>         }
>  }
>
> @@ -2159,7 +2162,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>
>  static inline void free_slab_obj_exts(struct slab *slab)
>  {
> -       struct slabobj_ext *obj_exts;
> +       unsigned long obj_exts;
>
>         obj_exts =3D slab_obj_exts(slab);
>         if (!obj_exts)
> @@ -2172,11 +2175,11 @@ static inline void free_slab_obj_exts(struct slab=
 *slab)
>          * NULL, therefore replace NULL with CODETAG_EMPTY to indicate th=
at
>          * the extension for obj_exts is expected to be NULL.
>          */
> -       mark_objexts_empty(obj_exts);
> +       mark_objexts_empty((struct slabobj_ext *)obj_exts);
>         if (unlikely(READ_ONCE(slab->obj_exts) & OBJEXTS_NOSPIN_ALLOC))
> -               kfree_nolock(obj_exts);
> +               kfree_nolock((void *)obj_exts);
>         else
> -               kfree(obj_exts);
> +               kfree((void *)obj_exts);
>         slab->obj_exts =3D 0;
>  }
>
> @@ -2201,9 +2204,10 @@ static inline void free_slab_obj_exts(struct slab =
*slab)
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>
>  static inline struct slabobj_ext *
> -prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
> +prepare_slab_obj_ext_hook(struct kmem_cache *s, gfp_t flags, void *p)
>  {
>         struct slab *slab;
> +       unsigned long obj_exts;
>
>         if (!p)
>                 return NULL;
> @@ -2215,30 +2219,32 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, =
gfp_t flags, void *p)
>                 return NULL;
>
>         slab =3D virt_to_slab(p);
> -       if (!slab_obj_exts(slab) &&
> +       obj_exts =3D slab_obj_exts(slab);
> +       if (!obj_exts &&
>             alloc_slab_obj_exts(slab, s, flags, false)) {
>                 pr_warn_once("%s, %s: Failed to create slab extension vec=
tor!\n",
>                              __func__, s->name);
>                 return NULL;
>         }
>
> -       return slab_obj_exts(slab) + obj_to_index(s, slab, p);
> +       obj_exts =3D slab_obj_exts(slab);
> +       return slab_obj_ext(slab, obj_exts, obj_to_index(s, slab, p));
>  }
>
>  /* Should be called only if mem_alloc_profiling_enabled() */
>  static noinline void
>  __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_=
t flags)
>  {
> -       struct slabobj_ext *obj_exts;
> +       struct slabobj_ext *obj_ext;
>
> -       obj_exts =3D prepare_slab_obj_exts_hook(s, flags, object);
> +       obj_ext =3D prepare_slab_obj_ext_hook(s, flags, object);
>         /*
>          * Currently obj_exts is used only for allocation profiling.
>          * If other users appear then mem_alloc_profiling_enabled()
>          * check should be added before alloc_tag_add().
>          */
> -       if (likely(obj_exts))
> -               alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size=
);
> +       if (likely(obj_ext))
> +               alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size)=
;
>  }
>
>  static inline void
> @@ -2253,8 +2259,8 @@ static noinline void
>  __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, =
void **p,
>                                int objects)
>  {
> -       struct slabobj_ext *obj_exts;
>         int i;
> +       unsigned long obj_exts;
>
>         /* slab->obj_exts might not be NULL if it was created for MEMCG a=
ccounting. */
>         if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> @@ -2267,7 +2273,7 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s=
, struct slab *slab, void **p
>         for (i =3D 0; i < objects; i++) {
>                 unsigned int off =3D obj_to_index(s, slab, p[i]);
>
> -               alloc_tag_sub(&obj_exts[off].ref, s->size);
> +               alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s-=
>size);
>         }
>  }
>
> @@ -2326,7 +2332,7 @@ static __fastpath_inline
>  void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void =
**p,
>                           int objects)
>  {
> -       struct slabobj_ext *obj_exts;
> +       unsigned long obj_exts;
>
>         if (!memcg_kmem_online())
>                 return;
> @@ -2341,7 +2347,8 @@ void memcg_slab_free_hook(struct kmem_cache *s, str=
uct slab *slab, void **p,
>  static __fastpath_inline
>  bool memcg_slab_post_charge(void *p, gfp_t flags)
>  {
> -       struct slabobj_ext *slab_exts;
> +       unsigned long obj_exts;
> +       struct slabobj_ext *obj_ext;
>         struct kmem_cache *s;
>         struct folio *folio;
>         struct slab *slab;
> @@ -2381,10 +2388,11 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>                 return true;
>
>         /* Ignore already charged objects. */
> -       slab_exts =3D slab_obj_exts(slab);
> -       if (slab_exts) {
> +       obj_exts =3D slab_obj_exts(slab);
> +       if (obj_exts) {
>                 off =3D obj_to_index(s, slab, p);
> -               if (unlikely(slab_exts[off].objcg))
> +               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               if (unlikely(obj_ext->objcg))
>                         return true;
>         }
>
> --
> 2.43.0
>

