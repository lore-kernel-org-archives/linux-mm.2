Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D030CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8978E00C8; Wed, 29 Oct 2025 14:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99178E00B2; Wed, 29 Oct 2025 14:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987A28E00C8; Wed, 29 Oct 2025 14:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86BA58E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:37:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37FFA13BE68
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:37:42 +0000 (UTC)
X-FDA: 84052010364.21.8597410
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 56D77C000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:37:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hyte+UfG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761763060; a=rsa-sha256;
	cv=none;
	b=7tlGG5ZKNwbmwBkc63+FYNY9TXKVnZ2z4wYklYhO+/ADpgg4nQPziFwH+ci/FyvgQFY0UB
	oHbD2HgNGwa0dmloj5bprSN2cJZwX3m1QgME4FDm33q9DdU74Xbu1ACRjnjNfmO8R0RpPY
	vkFrkuGtBXP8UJbMyQskMYjQohhVb0Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hyte+UfG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761763060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9Ey8iYhsNV4DmLuQuvf3CrjlZXkohripqbrbq2UPM8=;
	b=Rp6HOaBR96okXDZ+aCdfSfeEKyHG5LSOh+r7hvv26/QtkonHq5HZs6pHnar7bdZJpuMI/L
	NlJrxu1k4iCGzjaGo1sTionbxKJyeh6x0xXg65KPza5Y36v4p9YMKDdzNbNN/q7nDwiqe1
	4JcWZ+u8blxCgTVUl7dMGwpUlyhlfLQ=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso57651cf.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761763059; x=1762367859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9Ey8iYhsNV4DmLuQuvf3CrjlZXkohripqbrbq2UPM8=;
        b=hyte+UfGeJqMSPCyjbYzTmk/pO4M0Wj8vjT3MU/ue8GJc1AMpOBUZHd0dSITNtrie5
         aqy+EaTECDidkCyupcS3vPiE9WauawDrZ1gAAdbd3vSWo5XEbDaiNAw9UJOtMUdOnJkI
         st/TlHRJWBfTZs2NhFg9u5tueVhpYI7qO2/0J3BmE9KUNM0Od+om58QNJ9rFcY43G8+q
         /YXnwrzPyFya30+5tCuCiiu5W9t6UtaxuxXF6E8GlVUs71ywRqb9ZN9YMOr9UirxJO4s
         3IjgNwa3ZBNgKIVg0Js1wXEDeP2uc+aabp341+7tSAbPhv4Z4y4UAQLTyisCtLTeLzQk
         xLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761763059; x=1762367859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9Ey8iYhsNV4DmLuQuvf3CrjlZXkohripqbrbq2UPM8=;
        b=uqlb23AM5YC4MGZk/XmiKzJDk2OjsjSMosBK0ZZ7nS6q2aSPnARVUu4oPICNUc3vg6
         mb8cQLBuw82kXi52lCO9ASq9dH9XvFFcACfPsVDeEL6dXSOTS3ziYkyHiU0hDzHnGNjA
         vL5IIIYUvKBEHbOVFxTMh4X4cpbI1wpOlBfxkys6bJmrxIWOeC14NuaidKcrZ/2NbYf/
         jK2pdxT1dOnTun75GBXi2bwuTp5Xe5aTFp6zVQEhono8qQWu1iz8+k0t3oo7paS/5SDw
         cTpYHiNFQsFrUE8iEJJJdBCQoaUfNTG8lu1gm33EUPonLW4Hm9q+6gIKTpj89gWHW1ut
         Ho9w==
X-Forwarded-Encrypted: i=1; AJvYcCWew2h/HHd5FKVgWj7VbGYOBMXjleWT9B30ScNFBeqjNf+QaPsvteLBx4GsGeXz2jX+Q7EdUuDjxA==@kvack.org
X-Gm-Message-State: AOJu0YwoGzr3467tTaFl/PjxZg+ixFjIsh8NGJIunb0VVxTubo1gChfO
	NznYl4PbDQG2AQl3tjD07b1bH50pwV/+Xl0tnvPx68m4k0NriABC4ie9Yltwt+pSuaYGzc2t3TO
	s/MEl/OBUuxGv30c2jaInI+myJAvAnr0U29VOO9MI
X-Gm-Gg: ASbGncvVfPGxybwsV7Vj/emfItp8+61pJDUkm4ErzApAi5EQ8Egdeo1EiQVEn1OqWJj
	HxJkMU/zbJ6vhSvn8h5tPU/DlMshuwPNBHLg9OVJjTPDhQo8l4YLeN2mEp1WR4D+zdgEHieZvvP
	+rmd8YDrLpgacv6/p57brlIcUMJs2U/Akp/XmZGWV2gAygax6pXI9IyHhXOQdpcvfJPuL9HI1Cu
	CgQrIplAuvS4D6SfuLQW9nqNOR8kbtzu0Befy+kXGjBSLKWkHc0Ykr8h6UOj/QqzYlQHEAB1hgB
	X0guotfQClmixXs=
X-Google-Smtp-Source: AGHT+IH8IJb4mdzugiyUJiKdhE834SZN43FZI5L8PRxmHgVcBPjtH4b1oNSC1LgJcs2h4W7p2Gjsrm8SLTOCSL+1dcU=
X-Received: by 2002:a05:622a:1a10:b0:4e6:e07f:dc98 with SMTP id
 d75a77b69052e-4ed225a220fmr699031cf.9.1761763058976; Wed, 29 Oct 2025
 11:37:38 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-7-harry.yoo@oracle.com>
 <CAJuCfpGY0h2d6VEAEa4kjH2yUMGDdke_QTFt6d+gb+kH=rnXyQ@mail.gmail.com> <aQHJfyoUN-tbnVFr@hyeyoo>
In-Reply-To: <aQHJfyoUN-tbnVFr@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 11:37:27 -0700
X-Gm-Features: AWmQ_bnE1BJ3ZIc4019sKWySDFgx82v_dnppIEExUnniJ2zZNGhyRwNQFzNWTEQ
Message-ID: <CAJuCfpFhaPTqtKbjrigptPJ-9kKJB--mPnicBzN1=rfJxhN3PQ@mail.gmail.com>
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
X-Stat-Signature: zpzrqfk38ust616re4598q955yiia16q
X-Rspamd-Queue-Id: 56D77C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761763060-380309
X-HE-Meta: U2FsdGVkX18bZ2GIJR5gRs/VF3emi5Gs7U2o9LtbcLgjz+fBZpSM+PWLc1hrDNJusJ0L32wv0MI+CK5rxebP207JR/3Yrz+0tFEj0roES/Q+DFb8GuxtnlejwGvlL1jjHHuNk3X7F7QA4TlZI4u7g9do33qLgJowEDYa0RokJ62GMc1+Yma17JyqxmLkDiVQ/hdmz1bT6mB4WYyNY3ljrnB5fFeXWiVjhJi0Efyjnqs1A2xI2ZcAHmcLPjnEIj0tNtEwIlFxiNZKd1hKIvjfEZJxvlsisJWsrrrNQK5CiOoK+1fK9Oz7Yf9WJ2uXguGQnbF09zfSle61CvQT+nLz89qvo6RB/ZZwVhDATE1OwCQOZeYFMwimcUYxeM6ks8aFG+ke/Ns2O1PbgmHkegQwbsXwpc9tMe6EzuzQKw5CSKSVANt4mTgnEh2kP/Z+FJ8CA/cUAPvlKvbIIGo/4agczbpZ8AEK5YRbgvLt7GGwoZzOQ5vojHcEeIvbP2Z6Ukgjximr1snhXUP7QoT0lXj4EBbIhi6RB52N/aSsuWmhTG4YSsoAlg6DZCMl6nSiEnRzKhf02WpjCZ2gXlfveqk1ddQUhQLtnfPMmY0ZpAwJ8pJLqNBatnbmfTMGoTVnbmE4fT7qB8UDRC/d6/QnjT9Eaem0S83DljQh1zep9XjK0klOR3hxI/yvDMZ5A/WsmBJn7YUyqwtvsMls5bgSizIBUJ1aHmlwuSidOwu1a7kLQOyDFcs/zpfDfucXdZB+jbTZ3zhlq4a3+4aPZioIHJ9w4b60ecywb5ctJT3mnME7wqTreZ1HclbtJjF0tlTemaqC1HXLKBTvkicxFnE6yoiGINOT0aniTJRnYnh2AI73HCL3lM9CkHJEO4iHN7f2w+Z3DWyER485/9edwVVJ83uwZNpRp9ZbbWhFGCG0QrzTTP7WRzxMh+jUrUpuzF3Cj663cOGnaMSESxuzurHGfJg
 gcLbN7me
 oxQEzk3MFIOQ6oWcjqj86vq9pSvzXtarEQeqfSaMBgDaJrGTj4Sv2fpZkVe5YESP+0O2m03yPQZtIfam/YEwUMwYtQMDiF1EwLlWCfLbT9cmmS+rXnZxj/zeG2LSYC5pd8+D+Biq3NxxEKcdaPSxoQpK6bRN1/lx36cCnCoy6VIln4Hlo9kQnoCUk3Eer5SXEcvgseT+ymEy4tIJzB+4fHZHC8fO1oilAn8Li2PbCQOKeMcYi/rIfrGj5A1aTsNYraBlUz/vXHyAdeSEzETdtqhzfJ9D6L/J9pHAJJr5W7M8NhJUjLKh0AiaSzyUrI91bOJqwmU56TSP6nfbb9lYKtzOrVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 1:00=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Oct 28, 2025 at 08:07:42PM -0700, Suren Baghdasaryan wrote:
> > On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > The leftover space in a slab is always smaller than s->size, and
> > > kmem caches for large objects that are not power-of-two sizes tend to=
 have
> > > a greater amount of leftover space per slab. In some cases, the lefto=
ver
> > > space is larger than the size of the slabobj_ext array for the slab.
> > >
> > > An excellent example of such a cache is ext4_inode_cache. On my syste=
m,
> > > the object size is 1144, with a preferred order of 3, 28 objects per =
slab,
> > > and 736 bytes of leftover space per slab.
> > >
> > > Since the size of the slabobj_ext array is only 224 bytes (w/o mem
> > > profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
> > > fits within the leftover space.
> > >
> > > Allocate the slabobj_exts array from this unused space instead of usi=
ng
> > > kcalloc(), when it is large enough. The array is always allocated whe=
n
> > > creating new slabs, because implementing lazy allocation correctly is
> > > difficult without expensive synchronization.
> > >
> > > To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
> > > MEM_ALLOC_PROFILING are not used for the cache, only allocate the
> > > slabobj_ext array only when either of them are enabled when slabs are
> > > created.
> > >
> > > [ MEMCG=3Dy, MEM_ALLOC_PROFILING=3Dn ]
> > >
> > > Before patch (creating 2M directories on ext4):
> > >   Slab:            3575348 kB
> > >   SReclaimable:    3137804 kB
> > >   SUnreclaim:       437544 kB
> > >
> > > After patch (creating 2M directories on ext4):
> > >   Slab:            3558236 kB
> > >   SReclaimable:    3139268 kB
> > >   SUnreclaim:       418968 kB (-18.14 MiB)
> > >
> > > Enjoy the memory savings!
> > >
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  mm/slub.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
--
> > >  1 file changed, 142 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 13acc9437ef5..8101df5fdccf 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > +static inline bool obj_exts_in_slab(struct kmem_cache *s, struct sla=
b *slab)
> > > +{
> > > +       unsigned long obj_exts;
> > > +
> > > +       if (!obj_exts_fit_within_slab_leftover(s, slab))
> > > +               return false;
> > > +
> > > +       obj_exts =3D (unsigned long)slab_address(slab);
> > > +       obj_exts +=3D obj_exts_offset_in_slab(s, slab);
> > > +       return obj_exts =3D=3D slab_obj_exts(slab);
> >
> > You can check that slab_obj_exts(slab) is not NULL before making the
> > above calculations.
>
> Did you mean this?
>
>   if (!slab_obj_exts(slab))
>       return false;

Yes but you can store the returned value to reuse later in the last
"return obj_exts =3D=3D slab_obj_exts(slab);" expression.


>
> If so, yes that makes sense.
>
> > > @@ -2185,6 +2311,11 @@ static inline void free_slab_obj_exts(struct s=
lab *slab)
> > >  {
> > >  }
> > >
> > > +static inline void alloc_slab_obj_exts_early(struct kmem_cache *s,
> > > +                                                      struct slab *s=
lab)
> > > +{
> > > +}
> > > +
> > >  #endif /* CONFIG_SLAB_OBJ_EXT */
> > >
> > >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > > @@ -3155,7 +3286,9 @@ static inline bool shuffle_freelist(struct kmem=
_cache *s, struct slab *slab)
> > >  static __always_inline void account_slab(struct slab *slab, int orde=
r,
> > >                                          struct kmem_cache *s, gfp_t =
gfp)
> > >  {
> > > -       if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
> > > +       if (memcg_kmem_online() &&
> > > +                       (s->flags & SLAB_ACCOUNT) &&
> > > +                       !slab_obj_exts(slab))
> > >                 alloc_slab_obj_exts(slab, s, gfp, true);
> >
> > Don't you need to add a check for !obj_exts_in_slab() inside
> > alloc_slab_obj_exts() to avoid allocating slab->obj_exts?
>
> slab_obj_exts() should have returned a nonzero value
> and then we don't call alloc_slab_obj_exts()?

Sorry, I mean that you would need to check
obj_exts_fit_within_slab_leftover() inside alloc_slab_obj_exts() to
avoid allocating the vector when obj_exts can fit inside the slab
itself. This is because alloc_slab_obj_exts() can be called from other
places as well. However, from your next comment, I realize that your
intention might have been to keep those other callers intact and
allocate the vector separately even if the obj_exts could have been
squeezed inside the slab. Is that correct?

>
> > >         mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
> > > @@ -3219,9 +3352,6 @@ static struct slab *allocate_slab(struct kmem_c=
ache *s, gfp_t flags, int node)
> > >         slab->objects =3D oo_objects(oo);slab_obj_exts
> > >         slab->inuse =3D 0;
> > >         slab->frozen =3D 0;
> > > -       init_slab_obj_exts(slab);
> > > -
> > > -       account_slab(slab, oo_order(oo), s, flags);
> > >
> > >         slab->slab_cache =3D s;
> > >
> > > @@ -3230,6 +3360,13 @@ static struct slab *allocate_slab(struct kmem_=
cache *s, gfp_t flags, int node)
> > >         start =3D slab_address(slab);
> > >
> > >         setup_slab_debug(s, slab, start);
> > > +       init_slab_obj_exts(slab);
> > > +       /*
> > > +        * Poison the slab before initializing the slabobj_ext array
> > > +        * to prevent the array from being overwritten.
> > > +        */
> > > +       alloc_slab_obj_exts_early(s, slab);
> > > +       account_slab(slab, oo_order(oo), s, flags);
> >
> >  alloc_slab_obj_exts() is called in 2 other places:
> > 1. __memcg_slab_post_alloc_hook()
> > 2. prepare_slab_obj_exts_hook()
> >
> > Don't you need alloc_slab_obj_exts_early() there as well?
>
> That's good point, and I thought it's difficult to address
> concurrency problem without using a per-slab lock.
>
> Thread A                    Thread B
> - sees slab->obj_exts =3D=3D 0
>                             - sees slab->obj_exts =3D=3D 0
>                             - allocates the vector from unused space
>                               and initializes it.
>                             - try cmpxchg()
> - allocates the vector
>   from unused space and
>   initializes it.
>   (the vector is already
>    in use and it's overwritten!)
>
> - try cmpxchg()
>
> But since this is slowpath, using slab_{lock,unlock}() here is probably
> fine. What do you think?

Ok, was your original intent to leave these callers as is and allocate
the vector like we do today even if obj_exts fit inside the slab?

>
> --
> Cheers,
> Harry / Hyeonggon

