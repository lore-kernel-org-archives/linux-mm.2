Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C71CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 03:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3608E002C; Tue, 28 Oct 2025 23:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA9F8E0015; Tue, 28 Oct 2025 23:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFF28E002C; Tue, 28 Oct 2025 23:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2ED8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:07:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEACF49B67
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:07:57 +0000 (UTC)
X-FDA: 84049667394.12.C5D0A5F
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55EDAC0003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:07:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pfhYeCyt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761707276; a=rsa-sha256;
	cv=none;
	b=VIm8FJbOVtUci/xAts3k6oVQOnbK4OSlU5aufx/k0zIsREBR74ZyL2NqDThW+aYm/NI7NT
	o4u/YrDPSaiaLb9PwAPPmQePFwgrRjQBWPfW9vWMWo9WQiZYSbYeHPMKuW35g/yws3/qjS
	hF25oGGtUqS/jRGBYLi94aq87j9DLGU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pfhYeCyt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761707276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SaWOKKkkRsdmyBWJZ4jc5bh/UT1GoLzP1sDM1wf19po=;
	b=HQi9f6ZmLMjinwfeeGB29jQVLaeSGzZyOLfvp1+MhSV0osVyLUN1huMYWVudx8JcGNWrow
	hSrhRcpXhdAzRztdS2EyjaZevpVDUdgj+6C2kpziZ26wezGMCuvDkt9wVJAKY+MLl+6kEU
	sVOWA404eOX4ioALHD3dp6419zDoybs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4eccff716f4so190571cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761707275; x=1762312075; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SaWOKKkkRsdmyBWJZ4jc5bh/UT1GoLzP1sDM1wf19po=;
        b=pfhYeCytUkWhKH0DXLAZFqXn2I8qREq5Mi42G+9JFKJ8apK/4yxZZinC1aDWITzQal
         uVm65rP2OpuhCBjv2vZ1DxOnxAw2H/9KVWOrGprl6CObSRx1TC+30Q39q/vo/6WSfW4c
         tVdrwBcH6SwLM3MC18DDx359qIilZDx8006VJENakV0hPZDUwWJpqAJ3wLyBsUMIY+0R
         NSP1/23LdQgjqwQF2a9qw2jPeSrP6Eo3kGVgf2Ek96TewIMYVtKFZfrGjZWm1y5zhluH
         dp4trkk9tjfIlzkJkhCMK0QQOfM5noIxF72V9QmvP2whsTOhuUgNNlmtrsg5HPPf6zD4
         emjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761707275; x=1762312075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SaWOKKkkRsdmyBWJZ4jc5bh/UT1GoLzP1sDM1wf19po=;
        b=UlLwJom82rFRdJY7/fw7nNxBPfrXp2sWWB7KTVNCZ1TFUJQOMEzCB/CUdw5il6FLF/
         a220fPfEKkzohFuOzwycX8FXIE3Ki7VSVB5xjTm7+hcppAW9G44Xee6Xqt86BlVADHFO
         BWSYyGjg01+h+qbRiyUhVMZTrDGKtJGihO85PVftNtWqQL5E8L9dIoNU2YWwQCn61Sd0
         0ab434ZJkBSvziW1IZ3L5aB0+7hSoIskZ9YFy4xfmxcM0ycq1Etk+0BxTSYdZ0eAHnYM
         PF/vTuN0O32ziCJoLYPznKHFGhCIyK8RDx15QO73gj2iXalRUXwl7RBEcj5+1i37rOdY
         8u4g==
X-Forwarded-Encrypted: i=1; AJvYcCVTM3xRn7m+t9YibF0tJTEhvAzksbZpgwnS/4oc0j6Y8g4+wxc2wfyPEb54F8+SYgBoDiaWB37QTQ==@kvack.org
X-Gm-Message-State: AOJu0YwlhZ5udn8HmpymAHy1lXManrsAt0AbKr8exXLEFVdj3kFVh+my
	Zb6Zts/p+LdSGwg5PsMD8o3IlIuDu2VyWGo0SJzsNuQ8Ou7Hsr9+pcYlfQU1y84oSQ7xR6kNU0w
	uherTHgQ4vIpP7/8RipJizui3BuToedDQ0okLTnp/4JlZuc9hEHLoYEwAl8A=
X-Gm-Gg: ASbGncuWhwaW8eYSJeFfUO9vIK0Tvm2R3Ba9u8cz+NTUsURUSHS5t4ZdzpxdHYeviCx
	zUXPjz/WsOpg0l0lLh1rKjXxZTZgb/Um0L5Vc/DjZfDu5JGjraepNYzZtolLZPthAnNyCNmk1Vx
	btt3YFAQDOv4+E8nsWjkQ/vlrqYjtjLSyP1LIxjSSm9NW91Q3cjGoA3VolQ7z7J6s1hEXihVwJR
	pvtAKGIYd8Q7HEQcJw5mRpOrgg+ij681wsOVJrdMNiv1RLYkps1Q0brH96mOZJKBNp8CA==
X-Google-Smtp-Source: AGHT+IGR25PwQaLqmJ5rY9EBaAEdLAPQJDuXw/9ST8rJRTTwp62lE6PuWrSM+BQMx0U7Z2OGGytFG0CIxBKZdsAq028=
X-Received: by 2002:a05:622a:53c4:b0:4b0:f1f3:db94 with SMTP id
 d75a77b69052e-4ed16580052mr2242901cf.5.1761707274919; Tue, 28 Oct 2025
 20:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-7-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-7-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 20:07:42 -0700
X-Gm-Features: AWmQ_blIZCXemcxp_kCAoc_ArhIEAXqf9CHgTRdQdgcyRfAQOBZ2sKmzOJ1YHEU
Message-ID: <CAJuCfpGY0h2d6VEAEa4kjH2yUMGDdke_QTFt6d+gb+kH=rnXyQ@mail.gmail.com>
Subject: Re: [RFC PATCH V3 6/7] mm/slab: save memory by allocating slabobj_ext
 array from leftover
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
X-Stat-Signature: ennezdi1d3spxzbneh3a5iuhhpouczct
X-Rspamd-Queue-Id: 55EDAC0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761707276-859470
X-HE-Meta: U2FsdGVkX1+TbjVkg4VdoDdyYpsDf4POmIbcAex8ZxzX9a6/bex8f9eGvtGprWZNQ2TdXapnsYvsFRGR/NKMPCUdWkyFYpHIg7UBWhmGX+J/DQOThvKi8h/23+TFwOx7Ev7xtP/hx8mqIl3NxJtC5dhOrAvZszP8QcCqXCE03mJijmMZ7FkwXwbZWci1Mm9r1EPX8PND0nKNmrCnNcw9iRA9rNR/ppqGoklYlLLexFlrfxsOpshQnUIgUTw9xAnnpeRxsH5GVcuShpq+uj4g6gX9ViqZ4zyMC6+9oCwJF/yLs2wxtdJKwJKamUHzDrG49IkLv9+Ml97DG/LvzRMsOIa9eXsOtV5IOzqTOY/EJ7f4ad9ALpUiSpaMhtjz9b9XKZzsyZcuWKIh3SanCXpCAI8iqR6RpyYHwTmCdv2gpF+2bDTXGZs3VqjjoCtLVWvXyouypJVUSpcoMS3b9fHau4l5z/smtE8Z+M64V++rsvAY+CwVkqw8kcdKK2zCWvS0m6bc/JgsjcQRs7KLfV58XergHupSDvYD0YM6NiMc1QoEZ1UwBYumVgT3H0yZHObI8jLltTV3juAVBq1TEOqrrOLvjQgZS75Y4XeDyrDsNfPdicId1zrzbpvEl8Df6QcjFi61H06nnD5QZ59xThxovDAxsUKrr6ngiU5yqPklTwMB5524BTJYzjsU24eK/sQrU7dF5JjB5yPUCLzvkkTmlkMZt6HG0d9S+GN9IOQrjha5uMObqclIazRrSNOPxC7qGMJOMk58r974MAGWjGOibBuj2nTIdAeIyL8HBgZ2BnWCwm0JRpPmFTxIxWy+yQhBByo6XSR/ci4OrJDu8i4QuT+B/6P2gvCji7MZ0Glay4K6g2+bfjpE2zYU5AXUHoqBj+CYpd8bQWQK8vAvBMBjFc04o+1yZ5P6LvGIzaT8XdX70xZ/KtFabvqb3PL2F0nt7xYlZu6nqc34yzIGW5x
 g35RMrnJ
 /QwOOh8+Fgd6nGWG2Dmzd6FCrP/tmHsf79zyyNXr3CAF2yt/91VzNEGI12l6pNRMuZH3BKvagvJBmUx7n8fDD45aLYg==
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
> The leftover space in a slab is always smaller than s->size, and
> kmem caches for large objects that are not power-of-two sizes tend to hav=
e
> a greater amount of leftover space per slab. In some cases, the leftover
> space is larger than the size of the slabobj_ext array for the slab.
>
> An excellent example of such a cache is ext4_inode_cache. On my system,
> the object size is 1144, with a preferred order of 3, 28 objects per slab=
,
> and 736 bytes of leftover space per slab.
>
> Since the size of the slabobj_ext array is only 224 bytes (w/o mem
> profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
> fits within the leftover space.
>
> Allocate the slabobj_exts array from this unused space instead of using
> kcalloc(), when it is large enough. The array is always allocated when
> creating new slabs, because implementing lazy allocation correctly is
> difficult without expensive synchronization.
>
> To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
> MEM_ALLOC_PROFILING are not used for the cache, only allocate the
> slabobj_ext array only when either of them are enabled when slabs are
> created.
>
> [ MEMCG=3Dy, MEM_ALLOC_PROFILING=3Dn ]
>
> Before patch (creating 2M directories on ext4):
>   Slab:            3575348 kB
>   SReclaimable:    3137804 kB
>   SUnreclaim:       437544 kB
>
> After patch (creating 2M directories on ext4):
>   Slab:            3558236 kB
>   SReclaimable:    3139268 kB
>   SUnreclaim:       418968 kB (-18.14 MiB)
>
> Enjoy the memory savings!
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slub.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 142 insertions(+), 5 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 13acc9437ef5..8101df5fdccf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -884,6 +884,94 @@ static inline unsigned int get_orig_size(struct kmem=
_cache *s, void *object)
>         return *(unsigned int *)p;
>  }
>
> +#ifdef CONFIG_SLAB_OBJ_EXT
> +
> +/*
> + * Check if memory cgroup or memory allocation profiling is enabled.
> + * If enabled, SLUB tries to reduce memory overhead of accounting
> + * slab objects. If neither is enabled when this function is called,
> + * the optimization is simply skipped to avoid affecting caches that do =
not
> + * need slabobj_ext metadata.
> + *
> + * However, this may disable optimization when memory cgroup or memory
> + * allocation profiling is used, but slabs are created too early
> + * even before those subsystems are initialized.
> + */
> +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> +{
> +       if (!mem_cgroup_disabled() && (s->flags & SLAB_ACCOUNT))
> +               return true;
> +
> +       if (mem_alloc_profiling_enabled())
> +               return true;
> +
> +       return false;
> +}
> +
> +static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
> +{
> +       return sizeof(struct slabobj_ext) * slab->objects;
> +}
> +
> +static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s=
,
> +                                                   struct slab *slab)
> +{
> +       unsigned long objext_offset;
> +
> +       objext_offset =3D s->red_left_pad + s->size * slab->objects;
> +       objext_offset =3D ALIGN(objext_offset, sizeof(struct slabobj_ext)=
);
> +       return objext_offset;
> +}
> +
> +static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *=
s,
> +                                                    struct slab *slab)
> +{
> +       unsigned long objext_offset =3D obj_exts_offset_in_slab(s, slab);
> +       unsigned long objext_size =3D obj_exts_size_in_slab(slab);
> +
> +       return objext_offset + objext_size <=3D slab_size(slab);
> +}
> +
> +static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *s=
lab)
> +{
> +       unsigned long obj_exts;
> +
> +       if (!obj_exts_fit_within_slab_leftover(s, slab))
> +               return false;
> +
> +       obj_exts =3D (unsigned long)slab_address(slab);
> +       obj_exts +=3D obj_exts_offset_in_slab(s, slab);
> +       return obj_exts =3D=3D slab_obj_exts(slab);

You can check that slab_obj_exts(slab) is not NULL before making the
above calculations.

> +}
> +#else
> +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> +{
> +       return false;
> +}
> +
> +static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
> +{
> +       return 0;
> +}
> +
> +static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s=
,
> +                                                   struct slab *slab)
> +{
> +       return 0;
> +}
> +
> +static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *=
s,
> +                                                    struct slab *slab)
> +{
> +       return false;
> +}
> +
> +static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *s=
lab)
> +{
> +       return false;
> +}
> +#endif
> +
>  #ifdef CONFIG_SLUB_DEBUG
>
>  /*
> @@ -1404,7 +1492,15 @@ slab_pad_check(struct kmem_cache *s, struct slab *=
slab)
>         start =3D slab_address(slab);
>         length =3D slab_size(slab);
>         end =3D start + length;
> -       remainder =3D length % s->size;
> +
> +       if (obj_exts_in_slab(s, slab)) {
> +               remainder =3D length;
> +               remainder -=3D obj_exts_offset_in_slab(s, slab);
> +               remainder -=3D obj_exts_size_in_slab(slab);
> +       } else {
> +               remainder =3D length % s->size;
> +       }
> +
>         if (!remainder)
>                 return;
>
> @@ -2154,6 +2250,11 @@ static inline void free_slab_obj_exts(struct slab =
*slab)
>         if (!obj_exts)
>                 return;
>
> +       if (obj_exts_in_slab(slab->slab_cache, slab)) {
> +               slab->obj_exts =3D 0;
> +               return;
> +       }
> +
>         /*
>          * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
>          * corresponding extension will be NULL. alloc_tag_sub() will thr=
ow a
> @@ -2169,6 +2270,31 @@ static inline void free_slab_obj_exts(struct slab =
*slab)
>         slab->obj_exts =3D 0;
>  }
>
> +/*
> + * Try to allocate slabobj_ext array from unused space.
> + * This function must be called on a freshly allocated slab to prevent
> + * concurrency problems.
> + */
> +static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab =
*slab)
> +{
> +       void *addr;
> +
> +       if (!need_slab_obj_exts(s))
> +               return;
> +
> +       metadata_access_enable();
> +       if (obj_exts_fit_within_slab_leftover(s, slab)) {
> +               addr =3D slab_address(slab) + obj_exts_offset_in_slab(s, =
slab);
> +               addr =3D kasan_reset_tag(addr);
> +               memset(addr, 0, obj_exts_size_in_slab(slab));
> +               slab->obj_exts =3D (unsigned long)addr;
> +               if (IS_ENABLED(CONFIG_MEMCG))
> +                       slab->obj_exts |=3D MEMCG_DATA_OBJEXTS;
> +               slab_set_stride(slab, sizeof(struct slabobj_ext));
> +       }
> +       metadata_access_disable();
> +}
> +
>  #else /* CONFIG_SLAB_OBJ_EXT */
>
>  static inline void init_slab_obj_exts(struct slab *slab)
> @@ -2185,6 +2311,11 @@ static inline void free_slab_obj_exts(struct slab =
*slab)
>  {
>  }
>
> +static inline void alloc_slab_obj_exts_early(struct kmem_cache *s,
> +                                                      struct slab *slab)
> +{
> +}
> +
>  #endif /* CONFIG_SLAB_OBJ_EXT */
>
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> @@ -3155,7 +3286,9 @@ static inline bool shuffle_freelist(struct kmem_cac=
he *s, struct slab *slab)
>  static __always_inline void account_slab(struct slab *slab, int order,
>                                          struct kmem_cache *s, gfp_t gfp)
>  {
> -       if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
> +       if (memcg_kmem_online() &&
> +                       (s->flags & SLAB_ACCOUNT) &&
> +                       !slab_obj_exts(slab))
>                 alloc_slab_obj_exts(slab, s, gfp, true);

Don't you need to add a check for !obj_exts_in_slab() inside
alloc_slab_obj_exts() to avoid allocating slab->obj_exts?

>
>         mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
> @@ -3219,9 +3352,6 @@ static struct slab *allocate_slab(struct kmem_cache=
 *s, gfp_t flags, int node)
>         slab->objects =3D oo_objects(oo);slab_obj_exts
>         slab->inuse =3D 0;
>         slab->frozen =3D 0;
> -       init_slab_obj_exts(slab);
> -
> -       account_slab(slab, oo_order(oo), s, flags);
>
>         slab->slab_cache =3D s;
>
> @@ -3230,6 +3360,13 @@ static struct slab *allocate_slab(struct kmem_cach=
e *s, gfp_t flags, int node)
>         start =3D slab_address(slab);
>
>         setup_slab_debug(s, slab, start);
> +       init_slab_obj_exts(slab);
> +       /*
> +        * Poison the slab before initializing the slabobj_ext array
> +        * to prevent the array from being overwritten.
> +        */
> +       alloc_slab_obj_exts_early(s, slab);
> +       account_slab(slab, oo_order(oo), s, flags);

 alloc_slab_obj_exts() is called in 2 other places:
1. __memcg_slab_post_alloc_hook()
2. prepare_slab_obj_exts_hook()

Don't you need alloc_slab_obj_exts_early() there as well?

>
>         shuffle =3D shuffle_freelist(s, slab);
>
> --
> 2.43.0
>

