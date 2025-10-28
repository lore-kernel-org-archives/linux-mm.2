Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A4ECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 20:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C628E0008; Tue, 28 Oct 2025 16:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9235F8E0005; Tue, 28 Oct 2025 16:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8609B8E0008; Tue, 28 Oct 2025 16:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7946F8E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:11:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EBEC88AF4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:11:12 +0000 (UTC)
X-FDA: 84048617184.25.9AF6AAE
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B8C4A000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:11:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kAKXqZCO;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761682270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=272mfK03DhLZ+PWwFMbt/hjHyzJqiJdlddFvMA6SlA0=;
	b=F65oxplF0EPYU+Bc0f4s57YnTlCfiPHnrMZUM3QFDGGM+lPoyBrPsNdlkGpDMtezD0ySUZ
	9Y92HLJ87IQefdpAKY7OHqYLBmoF2rzu/7S6PZEzuQ8lWm75eX1HslgPMIuIsa+3zXTzyQ
	W94kwdke98+yIbmM7b16lELs5J6vGy0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kAKXqZCO;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761682270; a=rsa-sha256;
	cv=none;
	b=rYlO+G190kz87si2ZfsHOQhpmEauRT6KypEIDqw+osJ4MafRcL/4w3m6FYq54SK7EglkQa
	tJwM5ywYtcW+KzRhyTSTZV1l8Z5kTo8GL1XBXflbWo7GuoQa5cjxREA7YrF6Qw/OR3l2bZ
	6rJTvBAAldEscw3eECZEd/MUi8yPVE4=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso95041cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761682269; x=1762287069; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=272mfK03DhLZ+PWwFMbt/hjHyzJqiJdlddFvMA6SlA0=;
        b=kAKXqZCOuKvIauwFAHTzSabWzwO0wt+gUS3XK6GFO/g5J/8crZZ6GfbJ4ZL/Q05Dzv
         DqZmB1bf3hb+xQkw8JlufvsTPS5+cD/zMp4uHTywhPYJFovqWsAZ+OQWeSl/8DzntNKw
         qRBwed9MI4m/2Q0nReEnbIRplCwNClnQwSmEeauCsY02Q/StmAw6fW0LXfqnIz9ajogL
         thtrh2VAhAIJfeMfWeX1gOZlggeOzOmnIVY5OZLl/gVvDk4j4t7MGUXp/y+Xohc6VLLE
         Cpc8Xzy3JtYQ2pQzMQGUif0SqMviyj5pLuEPG5MuZpIj8HLoEjonqrlLQYvIhC5uKJ8m
         fxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761682269; x=1762287069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=272mfK03DhLZ+PWwFMbt/hjHyzJqiJdlddFvMA6SlA0=;
        b=AifXP/Tce/9wTojAr6Y9bLuyQdLsB3loVHXk2hgN9gvrZ+ABsoA6aSG+R3YudEUOqW
         xKCfXr7Rlsi6l/b5yG/nJ+yCHoE657BV7zPma/vHp7haRMB5OS42EPeMFkFGjrM0/HE8
         XR/HkksorfpCpLvb5LqJA6JKAYmCJ7A0iNfrZB8O/GWJNNzZNFwTAgWMaYXK945qpaqm
         gePcJKO9w0MW6nb7li6VanCp1UCSqZmdJ88xg7sqvygV+yfJchWx7yMe8pAIyjewi2wj
         UoWpEIsA61BVYM+/G4NLRDDgFchho9NPtescpjZvi51GIfRyLFqlzMoOF5FxOcc7VnZA
         Q2Cg==
X-Forwarded-Encrypted: i=1; AJvYcCXRWV8g0Nlsp8R+kLqxHWTDmZmWU5vTfiVajZUqI9jx6x6cZCl1+3DRmkXofeamW3e0RZaA5TReEA==@kvack.org
X-Gm-Message-State: AOJu0Ywty5qb6o8VraSB8ZRN9SH0wGkOBeitDRDFjCgNYUQMRczBfng9
	0k5PtoBlJe2l6zG3YqlQ5i4St4+dsxjo07D7pc6v2Ytzp3Com+sLMXznJKBiA7WHcjQtb62Xaeo
	XYB6Fy18NnYSXWWTZCjTktzyRbCWi0hzu8DwAA5QR
X-Gm-Gg: ASbGncvOsBvEMFa6206os3qFxLxJO9McDdjG0+537q1zXUq5uAqVZ21cuUHxFL7dIiT
	kZAIvScci+iWOp9qliwH0T/onNWrOavcCWhnboLpAgsPQhkFgRmf+Uvrwww5j3kNxuHdIFxteuN
	9NgCUrmi0e38HIYGySHDdWLdbdF8N8NVfi4TrFeiR9mdtXaiIek1RVSR96Ty+ik3XRzKDjAB/Ja
	+EwkbyXTHBvhFrJhFsKxYncehIWRNfMSRRv7j6Og1kI8jTmok84Kw7fRtbpVR6g2bGT7ofYgrEg
	sCY15HKT2Q9e0t9ifvVXaGcHbA==
X-Google-Smtp-Source: AGHT+IHZ8asVKG/p+GFrVFe2FQcRmFBWn+JUKCAiirVC9RvAmQHOreZsnq5pWKHohmAMzCiCmCmV6Iy74RqHQl/cez4=
X-Received: by 2002:ac8:7c44:0:b0:4e7:1e07:959c with SMTP id
 d75a77b69052e-4ed1589cf0emr1560601cf.10.1761682269006; Tue, 28 Oct 2025
 13:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-5-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-5-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 13:10:56 -0700
X-Gm-Features: AWmQ_bmhs1hdkHxO3mmC1NyEAmbGlRZHViudswGppVrbFdffFaapHoJsuste_o8
Message-ID: <CAJuCfpEesdC-yoUb3X+er0Rsm59SiYqXu=i4cHzJDcrO2=QmiQ@mail.gmail.com>
Subject: Re: [RFC PATCH V3 4/7] mm/slab: use stride to access slabobj_ext
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
X-Rspamd-Queue-Id: 4B8C4A000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cwwk9nbengo14uxjfh4mrjpwzm7d7c5s
X-HE-Tag: 1761682270-379132
X-HE-Meta: U2FsdGVkX1+WJhMm3WYvVoA3Qy5ZQIxGP1sVRPuC2zFsr1zwXh/GfB3nyhkI1V6Od5L7TfZ3acs3PnC97PXuJcxjTH/jH1JKLgZwryvIAUVPtDrmt1e+PSBpCZMBDVBSeZDKJatEFKuRVRI3znEXaXk8saa1zU7NAmSXDkrEpsJ776L4DeTofDJIqoLa0+lbtQMLzSzXXfe8D3YxBKYVKR0sxTgRuA6KeTUH5PzKmGncrVZt3jsRf/8x+usf1lCE7/P+C6Dxd9s2n5K8IYewrNY/3hPxGtb4rt9HVQPHeoldcgkIvNpBx5UH4UuAMvlh9r+z732DHkMEhHbKDZSKgUODp3UJXmTizB6ulR42hq1qfUsQzswqhw/i9iZrnyvt5Sa15XrtVeDHBva2Bl1Z1iTEHJGerQ+C209VpXtFIxowcERjsbzKHouYLcP63HJDhnAvJbNc+aTZNsFchdmwsIxvbE8lK8Z5yMESqfdNwIg9/QieC0w4mPnWIilR0hu1IzJU3dzCi9Odax+i4tDwKK5OGjFzWzVkOSdhS2PeDMLfgPl9rf5yqY/r3Y7MlKxlVBMof1pN52998iOxPxEP/lOk7Q3lFnDtjvrNrln6CVJGw6DYKIyJHydXMyKXh4aQloH8OheurEim+1ck2oIKtmzA23ATh7M5vHcUjvWAOw9t3ytwtZhrX7Zui64abhDzTJrzJwADj/D2xnsBPsxEXnPqgARuibbUhraMgAhCb8ITWU/SriMQqnTm/pAxAqBbJ88d27SpXIhN7mJIrFcCHMmdb+boo7NaSsxfBT3ymFShLQZxLvl5dzIq9dMUTJkHdZqQvcmtkpy0t9ZPlsRRg09LX/I/lK+HVOeS7xRfR17coXgTDgQeWBC7WBAJCk4IerOgQh5TRoJrbi+I3vjGBwKiJK6Khr1pyttMPVZqkTVFO81nKsJlNI/E96GgFrRsW2nee4zATtZ1SyplDvy
 5i+kOPbL
 Ml+7Ej3xhc5b/fDZlnPy1xhR+Y7LwYNLg8bBRShDpjgAUhWRhfZ3R8GLXKqiQRmyv4LOBzkGYSIttA7ogBUSH44aY/UNUot0WrvSHSZrU4ziIsgkeF+eZtFi3ec35bQtL9mkjFTLIoZKxrXlWBaMMCWUvdGGF667l1imUdvcqXQ2mZh/03LX4XUoBqtALS2TmHwI/eAhgBrR0q+tR8R60RfmGIP2iU5XPI01T2uTY7crzOvYpFpGAnkuvkqUHUwO7PEtAc+LoO3ma1JW2+T+FqZ4vRMse8HKetuM44Fmap1+E31FxmIDF7uw21pAJGwu3wOA652KxcayNgO+A/Z2mi2KK7dtHBIZKyj9ixVgykJ9QRApzvTMza1THBkEDy0FIn6raq91FjFZAaKU=
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
> Use a configurable stride value when accessing slab object extension
> metadata instead of assuming a fixed sizeof(struct slabobj_ext).
>
> Store stride value in free bits of slab->counters field. This allows
> for flexibility in cases where the extension is embedded within
> slab objects.
>
> Since these free bits exist only on 64-bit, any future optimizations
> that need to change stride value cannot be enabled on 32-bit architecture=
s.
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

I hope slab_obj_exts() can be removed in the next revision, but otherwise L=
GTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 37 +++++++++++++++++++++++++++++++++----
>  mm/slub.c |  2 ++
>  2 files changed, 35 insertions(+), 4 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index df2c987d950d..22ee28cb55e1 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -83,6 +83,14 @@ struct slab {
>                                                          * that the slab =
was corrupted
>                                                          */
>                                                         unsigned frozen:1=
;
> +#ifdef CONFIG_64BIT
> +                                                       /*
> +                                                        * Some optimizat=
ions use free bits in 'counters' field
> +                                                        * to save memory=
. In case ->stride field is not available,
> +                                                        * such optimizat=
ions are disabled.
> +                                                        */
> +                                                       unsigned short st=
ride;
> +#endif
>                                                 };
>                                         };
>                                 };
> @@ -550,6 +558,26 @@ static inline unsigned long slab_obj_exts(struct sla=
b *slab)
>         return obj_exts & ~OBJEXTS_FLAGS_MASK;
>  }
>
> +#ifdef CONFIG_64BIT
> +static inline void slab_set_stride(struct slab *slab, unsigned short str=
ide)
> +{
> +       slab->stride =3D stride;
> +}
> +static inline unsigned short slab_get_stride(struct slab *slab)
> +{
> +       return slab->stride;
> +}
> +#else
> +static inline void slab_set_stride(struct slab *slab, unsigned short str=
ide)
> +{
> +       VM_WARN_ON_ONCE(stride !=3D sizeof(struct slabobj_ext));
> +}
> +static inline unsigned short slab_get_stride(struct slab *slab)
> +{
> +       return sizeof(struct slabobj_ext);
> +}
> +#endif
> +
>  /*
>   * slab_obj_ext - get the pointer to the slab object extension metadata
>   * associated with an object in a slab.
> @@ -563,13 +591,10 @@ static inline struct slabobj_ext *slab_obj_ext(stru=
ct slab *slab,
>                                                unsigned long obj_exts,
>                                                unsigned int index)
>  {
> -       struct slabobj_ext *obj_ext;
> -
>         VM_WARN_ON_ONCE(!slab_obj_exts(slab));
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
> -       obj_ext =3D (struct slabobj_ext *)obj_exts;
> -       return &obj_ext[index];
> +       return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * =
index);
>  }
>
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> @@ -588,6 +613,10 @@ static inline struct slabobj_ext *slab_obj_ext(struc=
t slab *slab,
>         return NULL;
>  }
>
> +static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e) { }
> +static inline unsigned int slab_get_stride(struct slab *slab) { return 0=
; }
> +
> +
>  #endif /* CONFIG_SLAB_OBJ_EXT */
>
>  static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
> diff --git a/mm/slub.c b/mm/slub.c
> index ae73403f8c29..4383740a4d34 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2134,6 +2134,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>  #endif
>         old_exts =3D READ_ONCE(slab->obj_exts);
>         handle_failed_objexts_alloc(old_exts, vec, objects);
> +       slab_set_stride(slab, sizeof(struct slabobj_ext));
> +
>         if (new_slab) {
>                 /*
>                  * If the slab is brand new and nobody can yet access its
> --
> 2.43.0
>

