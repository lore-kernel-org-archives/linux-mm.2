Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81E1CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 23:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17E68E019B; Tue, 28 Oct 2025 19:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFDF8E0015; Tue, 28 Oct 2025 19:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDE98E019B; Tue, 28 Oct 2025 19:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBC398E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:03:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 682841405DA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:03:36 +0000 (UTC)
X-FDA: 84049051632.14.C93FB02
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 85C6D2000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:03:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=niiBoW9r;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761692614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkCc0HiMOR5b7f9hSisLtYABo21aEVFL1TENQmedR60=;
	b=LlurDm9ZkKO6DwXeobLzj5BbIf8JbNS4gCtngIDhEeBTZZYOEliWvuO5E3sAyb/Qui/XRz
	QWdKuN0MZoYnu0xaELk12O+FcncNejmUhrAAjmedsBkMaEIMQ4eFn/hR+K0ORkQI9jTTYq
	F+3yj3PwW+UKMcTB6os55HQ20tGOlzc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=niiBoW9r;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761692614; a=rsa-sha256;
	cv=none;
	b=wYDsoVrEZtlCcwUWaV9Lnfa7gHKGs3nLYvyLRlVXE0YEQxMlhKcQVFxfmdqrzqwkKH+2zR
	/sV7q02Dgg0+uGYVTfAKbA270pbqU5knh8OAjjXwk9NHxWDfb8J+9icUx21Ye0D+qafXWG
	+2KznkmqicXw2w5UkVvQ7ao1pgqHFmw=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ea12242d2eso78851cf.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692613; x=1762297413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkCc0HiMOR5b7f9hSisLtYABo21aEVFL1TENQmedR60=;
        b=niiBoW9r3oeL5TdtJxOTrv+ZP1m7W6TeAi3uZs8FG0vUhADwlMqPv5VR2RfGC/rmyU
         D5TumVwX3BVipHCQTmtG/av08yFYcLmAWU1T4v7nzwnoB7ho8Ad6TiZOwJpe5qUwStNf
         L7QVzaaYiH3Z/8vBaS5cDdBmdM5INoTgAO3p12d552zOHlxyeew9Z0t7AGuE+/Z1rPy+
         sMsK66LXQGCMTVLlrrps8EXCi46ozS8GaXFwCdbhS2001JP27Ui9ww9aQ2Mk/Tf7iqHS
         V+Pjs4516dXngiCBLyeQUntPANHze0CnJXt0VZom+urnEmQ8i1ZVzHWD+/F411oA6hSZ
         xzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692613; x=1762297413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkCc0HiMOR5b7f9hSisLtYABo21aEVFL1TENQmedR60=;
        b=oZbsKTmqi4InM0H/P8mnws6t1kP/MYZ7CFnzc1Xy6q19IPVsIJIK9G+z0N4seszDIY
         mpmMzh1Sx79OKQ4+YHjs56RmXPn8wHNN0TtVEVQCZpCz6JN6B1jB6dGRrixr5psZceDA
         hhs4gwSh0ovMnMMNJXlOvZTQajjDd/PZn2omfjMJxxt+t6mdd7+CuHe9fHjUlEzcQjyu
         Z+RK+Oq0yrqh+GbNc8ofPtFKPuXiEVFd3zVmEI/qNWTnr4HFc7fmPH/BaXmzA7rryUSQ
         EWOcaNNq8eM3IaQwp4vQ5eBEAUJ8vWbGtHR9fTJcz1H9v8d0KCbzvlvyas54hrrSIEkC
         XigA==
X-Forwarded-Encrypted: i=1; AJvYcCUNMDc6A7c21Fv7WVr1JfvjNiAk0lc7N1YIg8gPOh9p4wPmnrvv3LORhVVXQq6EhqtPyVnnq8/MTg==@kvack.org
X-Gm-Message-State: AOJu0Yz9YqxtzZJlhtYvOnIasm9if2AxYzruetd/DTTwwZwbqBy48BMM
	MhES7TH21BifwxBX8TE9Ft/bO2y2Hoi+/P/gkwPv1SGwfQ7O0jrBTVnt7L6MRIgZHOzFiweJ/ra
	2JFuBdzZSVe5+BCaz4ZDtgjPEAUOV9l/GIHBfE3ZMqkvAvJPl3fe5dWNmIcY=
X-Gm-Gg: ASbGncu0IaKqNyBdp9LQ27rwItmMtbGJHu8CtXWWZ/lF0Tb/sOf7QrysmOo0CLia3Gf
	OGzh3vXiqovQ0Gxtp2YVXdKGXZCxbndVItFWAPkN37Qe4pLRLDPaapSVq4VcAFfm6ytmia5NuJE
	fr5XhvuxdKDM9m9x8eFa9z3eXhyk9wZymL27gkCDUUrJmk3l45UZZ/XN1DrAAO+DtxawZ/Vs+ej
	JUHnLCWbvX+o022HOwhYgh0otjWqFejV1US9xTfqU8tisFVSVbA+1TioJFiZ4usskFfan3nR+/Y
	xA5CHgch8AF2BUs=
X-Google-Smtp-Source: AGHT+IECtf9j9yYYwTn83cGtMlWRO+L58MiSVVzfRwL7ZACF7lRW0t5eFEDX3F1aP2yNHZmUSVGxHQMgdOvIOlbYDik=
X-Received: by 2002:a05:622a:4d99:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4ed1657e9f6mr1478901cf.7.1761692613074; Tue, 28 Oct 2025
 16:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-6-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-6-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 16:03:22 -0700
X-Gm-Features: AWmQ_blkp33Z4IMNKRW2xp9LBJRuH74c1VWBZTuALiMugzMI2usvKqnVdAqBpzQ
Message-ID: <CAJuCfpG=Lb4WhYuPkSpdNO4Ehtjm1YcEEK0OM=3g9i=LxmpHSQ@mail.gmail.com>
Subject: Re: [RFC PATCH V3 5/7] mm/memcontrol,alloc_tag: handle slabobj_ext
 access under KASAN poison
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
X-Rspamd-Queue-Id: 85C6D2000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uhzw67nyjpjpumnqk575r9948fwbu7du
X-HE-Tag: 1761692614-221369
X-HE-Meta: U2FsdGVkX19UVT66fuB76zNYdKEKzo5GmPDUyqeGVxHyw+fVlUnVPRfUzGu8mkW6IXYR+EjR2s0wUgi3qlnTcAMYojkzu62E8D8jgPkYQkBqeK4EWBq+Yk7C5SNoPU0iYNJV6b3mZO/asRWROSfd9180YEJYpMwsOrKW6UM7M2IpG1AxFLlAoyHWiOGC+k1jOlBk0ss1yy9BvsGIknjOqb1y+efwB2IUpIDZQ9mS6pFyfOoDHyuX4N9lVO8xxJO9MnNXZ+PAwyo18TBTLXnRXv3m+Hipz/5vBEGwnkwgBjf6FKR4Jb2ZqW5dh9vwhmB9xhooHn2GVSos4sqGx4RJDkxmDTUiX5sUpc2cHLSk9VfxqnHAv+fZ4LrkymeZMIKLUfkOxlcDhAJQEj0V+mFQjdIhP1KLxYnq7TNW4RmrnxWNMt1+T/DQFtREiFCRDDmKyTX1FoulAhoCFXpjMqtORmchaskNDlBscSA0ltVBu4zXS3BsdosVX0yn5twGj54UyahijnBMRSpzTrfn2iHDGnSpVddB7Bp1ini6VbkWWolBSKccNdpGenmU0Ei4tarVIIAaUjWVXM1l4Nj5/29u17wRU9l4g0XcRK2ogzwCvgqF+fna7Sj5M0CKcnk3KqMtyYNy3VutDSTiPptWwddIOg8TWjmqVi14J4cRhqhxdm+T7RG53tJCPjJ8HapBqrI3COmU1FD4YtjuUrJMP7T+g91uCnVsHd8XSDlatkj/915OUQPWsJqpfelGiLKj3FwhSJGY1d+EtWfoEjXcYJUapYjBgT7er6VUXnc5x7bQ/rxLaQaqJ2J7bApIzy7kV3ftY/IgEHOeFkpbp/rGklnoEKW8DBowMTlO6g7rwhFYbT/wfZxa35fU+2vrH8f7609B+gczuuUrDUxZWx4P/F+/CzOrQqbGfc9W55YTDr5nHzJlllDieqDDJY1q5FECTNDzZ8DoFvLRB33ozj93rvz
 EUmQqTsa
 pq+1eQLfng2X1uthIn+m5lIK3M63UASt4m8ijJBsFLIrf/C+O+fDNl5CqtEeumyi3UBjBBhS3ZNxPB1UUsCb/yTjbaohGAMf/vjbq64qJNecIqnAw7majfrPZm81pPjr67p1LNIBwdD/BwLdsFyf2dekAdaFkub1kAj3I9rRiZk1haXHFLztsYs/FEc1xb6vamjmJpObO5LQGtjQqVRWZEkOTHHOAtm5oGcK8tCER30zewTiMstoX16YfaBeINXTEi5eweN3DE7Scoiw+Le1hyYwJOTUm2bctObg8giTc6L/VBqoZ+C2HWYlZwFu5V+1KFg4Y
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
> In the near future, slabobj_ext may reside outside the allocated slab
> object range within a slab, which could be reported as an out-of-bounds
> access by KASAN. To prevent false positives, explicitly disable KASAN
> and KMSAN checks when accessing slabobj_ext.

Hmm. This is fragile IMO. Every time someone accesses slabobj_ext they
should remember to call
metadata_access_enable/metadata_access_disable.
Have you considered replacing slab_obj_ext() function with
get_slab_obj_ext()/put_slab_obj_ext()? get_slab_obj_ext() can call
metadata_access_enable() and return slabobj_ext as it does today.
put_slab_obj_ext() will simple call metadata_access_disable(). WDYT?

>
> While an alternative approach could be to unpoison slabobj_ext,
> out-of-bounds accesses outside the slab allocator are generally more
> common.
>
> Move metadata_access_enable()/disable() helpers to mm/slab.h so that
> it can be used outside mm/slub.c. Wrap accesses to slabobj_ext metadata
> in memcg and alloc_tag code with these helpers.
>
> Call kasan_reset_tag() in slab_obj_ext() before returning the address to
> prevent SW or HW tag-based KASAN from reporting false positives.
>
> Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/memcontrol.c | 15 ++++++++++++---
>  mm/slab.h       | 24 +++++++++++++++++++++++-
>  mm/slub.c       | 33 +++++++++++++--------------------
>  3 files changed, 48 insertions(+), 24 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2a9dc246e802..38e6e9099ff5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2570,17 +2570,22 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(stru=
ct folio *folio, void *p)
>                 struct slabobj_ext *obj_ext;
>                 struct slab *slab;
>                 unsigned int off;
> +               struct mem_cgroup *memcg;
>
>                 slab =3D folio_slab(folio);
>                 obj_exts =3D slab_obj_exts(slab);
>                 if (!obj_exts)
>                         return NULL;
>
> +               metadata_access_enable();
>                 off =3D obj_to_index(slab->slab_cache, slab, p);
>                 obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> -               if (obj_ext->objcg)
> -                       return obj_cgroup_memcg(obj_ext->objcg);
> -
> +               if (obj_ext->objcg) {
> +                       memcg =3D obj_cgroup_memcg(obj_ext->objcg);
> +                       metadata_access_disable();
> +                       return memcg;
> +               }
> +               metadata_access_disable();
>                 return NULL;
>         }
>
> @@ -3197,9 +3202,11 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cach=
e *s, struct list_lru *lru,
>
>                 obj_exts =3D slab_obj_exts(slab);
>                 off =3D obj_to_index(s, slab, p[i]);
> +               metadata_access_enable();
>                 obj_ext =3D slab_obj_ext(slab, obj_exts, off);
>                 obj_cgroup_get(objcg);
>                 obj_ext->objcg =3D objcg;
> +               metadata_access_disable();
>         }
>
>         return true;
> @@ -3210,6 +3217,7 @@ void __memcg_slab_free_hook(struct kmem_cache *s, s=
truct slab *slab,
>  {
>         size_t obj_size =3D obj_full_size(s);
>
> +       metadata_access_enable();
>         for (int i =3D 0; i < objects; i++) {
>                 struct obj_cgroup *objcg;
>                 struct slabobj_ext *obj_ext;
> @@ -3226,6 +3234,7 @@ void __memcg_slab_free_hook(struct kmem_cache *s, s=
truct slab *slab,
>                                  slab_pgdat(slab), cache_vmstat_idx(s));
>                 obj_cgroup_put(objcg);
>         }
> +       metadata_access_disable();
>  }
>
>  /*
> diff --git a/mm/slab.h b/mm/slab.h
> index 22ee28cb55e1..13f4ca65cb42 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -591,10 +591,14 @@ static inline struct slabobj_ext *slab_obj_ext(stru=
ct slab *slab,
>                                                unsigned long obj_exts,
>                                                unsigned int index)
>  {
> +       struct slabobj_ext *obj_ext;
> +
>         VM_WARN_ON_ONCE(!slab_obj_exts(slab));
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
> -       return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * =
index);
> +       obj_ext =3D (struct slabobj_ext *)(obj_exts +
> +                                        slab_get_stride(slab) * index);
> +       return kasan_reset_tag(obj_ext);
>  }
>
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> @@ -625,6 +629,24 @@ static inline enum node_stat_item cache_vmstat_idx(s=
truct kmem_cache *s)
>                 NR_SLAB_RECLAIMABLE_B : NR_SLAB_UNRECLAIMABLE_B;
>  }
>
> +/*
> + * slub is about to manipulate internal object metadata.  This memory li=
es
> + * outside the range of the allocated object, so accessing it would norm=
ally
> + * be reported by kasan as a bounds error.  metadata_access_enable() is =
used
> + * to tell kasan that these accesses are OK.
> + */
> +static inline void metadata_access_enable(void)
> +{
> +       kasan_disable_current();
> +       kmsan_disable_current();
> +}
> +
> +static inline void metadata_access_disable(void)
> +{
> +       kmsan_enable_current();
> +       kasan_enable_current();
> +}
> +
>  #ifdef CONFIG_MEMCG
>  bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru =
*lru,
>                                   gfp_t flags, size_t size, void **p);
> diff --git a/mm/slub.c b/mm/slub.c
> index 4383740a4d34..13acc9437ef5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -973,24 +973,6 @@ static slab_flags_t slub_debug;
>  static char *slub_debug_string;
>  static int disable_higher_order_debug;
>
> -/*
> - * slub is about to manipulate internal object metadata.  This memory li=
es
> - * outside the range of the allocated object, so accessing it would norm=
ally
> - * be reported by kasan as a bounds error.  metadata_access_enable() is =
used
> - * to tell kasan that these accesses are OK.
> - */
> -static inline void metadata_access_enable(void)
> -{
> -       kasan_disable_current();
> -       kmsan_disable_current();
> -}
> -
> -static inline void metadata_access_disable(void)
> -{
> -       kmsan_enable_current();
> -       kasan_enable_current();
> -}
> -
>  /*
>   * Object debugging
>   */
> @@ -2042,9 +2024,11 @@ static inline void mark_objexts_empty(struct slabo=
bj_ext *obj_exts)
>                 struct slabobj_ext *ext =3D slab_obj_ext(obj_exts_slab,
>                                                        slab_exts, offs);
>
> +               metadata_access_enable();
>                 /* codetag should be NULL */
>                 WARN_ON(ext->ref.ct);
>                 set_codetag_empty(&ext->ref);
> +               metadata_access_disable();
>         }
>  }
>
> @@ -2245,8 +2229,11 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache =
*s, void *object, gfp_t flags)
>          * If other users appear then mem_alloc_profiling_enabled()
>          * check should be added before alloc_tag_add().
>          */
> -       if (likely(obj_ext))
> +       if (likely(obj_ext)) {
> +               metadata_access_enable();
>                 alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size)=
;
> +               metadata_access_disable();
> +       }
>  }
>
>  static inline void
> @@ -2272,11 +2259,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>         if (!obj_exts)
>                 return;
>
> +       metadata_access_enable();
>         for (i =3D 0; i < objects; i++) {
>                 unsigned int off =3D obj_to_index(s, slab, p[i]);
>
>                 alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s-=
>size);
>         }
> +       metadata_access_disable();
>  }
>
>  static inline void
> @@ -2394,8 +2383,12 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         if (obj_exts) {
>                 off =3D obj_to_index(s, slab, p);
>                 obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> -               if (unlikely(obj_ext->objcg))
> +               metadata_access_enable();
> +               if (unlikely(obj_ext->objcg)) {
> +                       metadata_access_disable();
>                         return true;
> +               }
> +               metadata_access_disable();
>         }
>
>         return __memcg_slab_post_alloc_hook(s, NULL, flags, 1, &p);
> --
> 2.43.0
>

