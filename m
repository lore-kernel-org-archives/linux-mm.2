Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9650BC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898816B0119; Thu, 16 Jul 2026 11:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870CD6B011B; Thu, 16 Jul 2026 11:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785E76B011F; Thu, 16 Jul 2026 11:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 499F96B0119
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:24:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5B351C010B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:24:58 +0000 (UTC)
X-FDA: 84995012676.09.AC53FF0
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id ECA5BA0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:24:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N2ZubBt1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784215496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
	b=kwMfPiCCLC71HmInWTOynExkOnOLuvaOlRyRanQN94O1RdRcSZBKJuQWrTQR2X5dUtf0lS
	V7KHXUH7UKW3CJs9TOUdalQxC4tjUhUjMzkT1bX8IRV60C8lLLqAsuiZrFd9l6TSic3FXM
	pxwe6MmX8VUdF2d6kINWDQD4kbtUxSI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N2ZubBt1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784215496;
	b=Dg6dVwsnzuS1P6oo78j2YBv6uw0K81UvNDPPOfA3lJdMWBc26O8b59moRpEz/1Uh8BSUjo
	EKDE7z9hfCzeqgvQR1ghcMEk9ubht4q/hG4Sk80R143OF6TOf9GOFxnQCLLZtH+7+w11Cl
	tKMAExBlY1exVQ/wgo5IcDDH7M39wGo=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10ed63c0so30841cf.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215496; cv=none;
        d=google.com; s=arc-20260327;
        b=hfJv+14m9g2wG+pWo+4ZtqSrWi2oiWFpgyc6vgvQUzoeCOvDKCoymzk9bIx8Y63Ku1
         qWc4T/bvswd1Dv6BdxiYvMaSjOxl8HvbIPYFpGtE6abf++MRPd4ZX8Jn9MFBTgYyhbyO
         JkyPKszV47+V37Su7WHNaI1nVzlq6KH3hQKhbNVaKVrECafSVGJLckVoa/mIsKCgNmAi
         e8qWkLUO7REUC45LZ9QL/X6Qj7DWxAnO0S0EslFaUeAQ2twVQ8x+FehGXnEzXLM0rX07
         nbNcFJnIg+ZWxfR5Vu3iv3UljdyfUfh95nY+Pj0dV9wpMelwg0GKgY65IveBu+s8ceG1
         1TEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
        fh=b0EJS569PJpsdjQTJ/FSBnKYbz+TZKNL56cLf+wf1nM=;
        b=e5gJ6pQOc91RVJh4RaNIaVQR2Ub24LD8sZM9f6w0NE6Z9r7/UFwzC4taXVYOv4bSMh
         UPfnzcfnkE7MDSS7yJKhRnWIgx5919nOfK/LPB1hd2VPF5J86VjQIXnZkaPjREUfp3Xm
         4iu2GyK5BaWPRQ05dFieQDu9hZ3lXMjeXQ9b0js1TSaNBymAavv9170s9dIYe9w6ArPr
         6Fmsm+etjCxXUa8lCRMdvA6e0Ax8eIrJRsN5kO3UnOMOkGG9Q9r6fj/r5Qr6K73oOkXh
         fveFCSMzogzevKY9nPsdag2c0qVPZRJy3spS4Jq7/racZMf2sHPGqFNyNma78GDw5Io4
         /qRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215496; x=1784820296; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
        b=N2ZubBt1ypMKIopNcqlEZaAs4Ftu7o94tSbFN3slo4df+k6vBunQBRL0b0/RksLFie
         d9LHu9MpQWCqp5Ai6nfLP+4dfZO2WSgJkW3zyCK9Jdnqm6ocwRQBuMUpp8BOxIXZmtJV
         jHNCPXFCvxuNMzi+EAp0y2ewt+6NTI6W+mim54Bcp298fgEfzqbOm2sPQY0Da+OCig33
         qiv0RdKkYR2e7KGn8d+KBzCD3JJwLG+uHTvNmIqkL1kUE3Mp/Qnr8e6G8YwyVLmQDBj4
         mHF8gUmOCwuNz/aW0uDFbkru/kMe5r9NjDq+T24AqE5PCOinBY/8FTeIjdc2ayHCAJWF
         Ni/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215496; x=1784820296;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
        b=aBg1pFYcHVitSCyxUbtOSnchKSHokxjbzDmNhEgrsj5KiJHnImLuZ+C9Bm3rLtVi6K
         9SYEk9TuzI00HW2qsG1JDkw6mvj2lrpWmaqb6sElcHUW8aSOodwOEAWC+mRckBuixe0T
         Mp0T6+tQ13UrWeu1RQcQlQOKoKrbTKtL1oHK71VPYHR/xbzN8AfiXPmwKkoBFciYnuoP
         yllZc+Zdcid+eE90mQ/ORtNawTiCkDvttvCX0NgPc+1GkSDYhQFIMWlYJm0ZrY3Qdn+V
         rFyEC+MeAkfr5FuFMBmsjO3dY/YgKdhofnvJi8F51qvjZUifD4u3EvUxCwa9Zu3N4Pnx
         aNmw==
X-Forwarded-Encrypted: i=1; AHgh+RobdxIym8X6ghiVEGzNyhET+4r4qPKpZ8iQ60cmJH61F+QkfQCDp2KrxdNxyXgH+229hOmXkT/tyg==@kvack.org
X-Gm-Message-State: AOJu0Yzm7/xZYJzJaNehPOl64jo/ZfujY99CKcGiNLIC0XwMW+AvP1Tz
	1cTjY1lefE5OBaVs5MCTXbdLNQSbzLt0min7Yb2Wx3dInA+M3YAHqJuvBPiLVHywOvqC5TWv8Aa
	SiuaFz8BiiXHJSeaCVQI/TVY625zbYS1cYvsDvNgzLRRp1dX+Okq2KO6mOAo=
X-Gm-Gg: AfdE7cmOKSYjRUEwoMlfEaOh6N/i5t8ACaxptgkWi6bauVGZ/WMuakvveaKJhbLAe1I
	v9ra60gzWUftSugflX7H0P0heDU4wd7m3ES0PiZxcVzoNk+vY6iPI+KOuZi/afAWCO3K4Efkay4
	4O9xe0J2C6t0L4VTaeocZXsJs8y6/SDKzSr+5nQlvgY3tE/E9a0nbq39QMgNuC/Ej/HRkICASW2
	t+EG1oclbxvVLCe5uAUkjeZMriLBlI2g0Ho35R+NwvBCMFUs5jx3ENXtFnzHhUXlyVPw/cu/OGQ
	NI+NBpiFDgzRbtM=
X-Received: by 2002:a05:622a:4d95:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51fa50ac9f9mr8409571cf.21.1784215495436; Thu, 16 Jul 2026
 08:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org> <CAJuCfpHgMwM7SK-sanGpEyCxCi-T+gDqFJHnV_AMt=S-x5oynw@mail.gmail.com>
 <ab9782bf-d3dd-4cb5-ae66-127b3a16330b@kernel.org>
In-Reply-To: <ab9782bf-d3dd-4cb5-ae66-127b3a16330b@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:24:43 -0700
X-Gm-Features: AUfX_myqpLnbRL2quNm_tjL_Hd-IYL14KeopYjkYUcXz5awHSzMzA6UH-PT2010
Message-ID: <CAJuCfpG3SWhrow=wScgsFe5orhKz8Djf8MHvFBH+T7uTG+AUJQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/12] mm/slab: skip kfence objects in allocation profiling
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ECA5BA0008
X-Stat-Signature: 6n7b5ik5pegkdeimx7onz48pypc5nzef
X-HE-Tag: 1784215496-201674
X-HE-Meta: U2FsdGVkX19negH5QbXoj3ZWuVrIDO5xhRWTPwCQrw2x9qJ2bg7b/WrdoprAjd1yeLkF3FOnHW/Vl/xNcMfajUFyy4XLpQpOKA884sZEe91nHWftLiXhVfXja/aDWieeWsxooZGi7n+oDREfxVea/DjOeOiWDgtZqomJUljOmaVcWj0pOAgtoIopkueVUI6+mN87hoLOuOPAdtSNiuzD3UqfZ4VrRhcRC7adOBivWuEqaeUiHnMooqqeEzce4crrpqASBQKmu2UUDgxXee1wf7hljS0LAKjZgLh+v98eJNbkupPbFHY+JpZkFPKQR2jdJOQqkFc5ULMqSqfEnicLnq4yfVch768MizjVEQTaS5X4yO0mZmlmIgypL0P1meXAEIz4v0TLW6DEqvgBs9QoUwNv+O7V44Vk7EQ1GKqQvG9jku5pIJovM/pTyTfzZqfuIMJ4PCGzyghXHfO+FJTzIZsndzxcB+Dh9aALJM7P2zTc6/ZvtEdnMiol8Mcu3roxDXp1Om/42wlNGehzPWmvgEQbCqDmlKo9xt0ys12GfBj3ZDO2rf6gaYH3j5ZuyjQoGlQo9mCunwRuxtX1lm0boso+/4SLhfiuxG8sri0ce/92Y2wMy2cCRQ5BoDnXp+uabZrEntD/dY2p9ZqzUvblULjwz9IgVk4OnTTtDjfYPKwbQI1BMKIhss3VXpMGcRt0E0979f3YA5DV5BTwIx6rQz4+zeaN1HGAixVMvUHIXcA0va0YT3mV6yA269ncylkbn1HpBLuu6wHNA9K0o8TnjqCqPuXuB/mFMCG9qEJ5q1dZlEy7umLrG4VKdsyLA5YZkd6w7n3K81z+3NXki883XyHd6pdnguSpdEq2OVyjopUomjGkIVQmDxEcUYYMrYDEBx1+9XDSjYqoF0PfJm5qICE40qew1a5JP7zzH8KlCBbjvUK903v6Zt8WrtfNI0ruBdiW+HbpakELGW4QgWz
 oTRNsvJZ
 nxN6Wn6g+wASNvPcD9zFgGTOZQPvabqtXDMSfUbZRStS+pjxDA8p1oZjwRkjAcc+nBpjpaPbXXz3xSz0K27aa8uoK4ddo2y8A7c+pYTNC0hh6S5GeVyRKm4l9EsMXbU+Tm9fXvpGJHZmqutq48/u+wCePu4WCjkFk8srQFhB3IbfjAHMXT6TQZQ0F9cg3cfJ6sHfcMLRxNvmYxwNnx0hkDxdPjFTDC1C0TzFZXolxbqzNOnf5khA2IGAip5XFscpfgmnVnoRoUa+2XmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 2:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/15/26 18:02, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >>
> >> struct kfence_metadata only has obj_exts with CONFIG_MEMCG.
> >
> > I don't quite understand this statement. obj_exts are allocated when
> > either CONFIG_MEMCG or CONFIG_MEM_ALLOC_PROFILING is enabled.
>
> See in mm/kfence/kfence.h
>
> struct kfence_metadata {
> ...
> #ifdef CONFIG_MEMCG
>         struct slabobj_ext obj_exts;
> #endif
> ...
>
> then in mm/kfence/core.c kfence_init_pool()
>
> #ifdef CONFIG_MEMCG
>                 struct slab *slab =3D page_slab(page);
>                 slab->obj_exts =3D (unsigned long)&kfence_metadata_init[i=
 / 2 - 1].obj_exts |
>                                  MEMCG_DATA_OBJEXTS;
> #endif
>
> So the slab kfence fakes only has this pre-inited obj_exts
> with CONFIG_MEMCG.
>
> What happens if we run memalloc profiling without MEMCG and this
> fake slab doesn't have a pre-assigned obj_exts? I guess
> __alloc_tagging_slab_alloc_hook() will allocate it via
> prepare_slab_obj_exts_hook().
>
> But it's something that was done consciously and probably
> just accidentally works.

Ok, I see. Maybe you can expand this description to explain the
details more thoroughly? This whole kfence.obj_exts deal is not very
intuitive.

>
> >> If it's
> >> enabled, it does also work for allocation profiling, but there's littl=
e
> >> value recording tags for KFENCE objects.
> >
> > Unless we are leaking them, right?
>
> Well if there are leaks in a particular callsite, we should see that from=
 all
> the allocations that don't end up in kfence (as kfence allocations are ra=
re).
> So we are very unlikely to miss a leak due to this.

Ok, makes sense. Thanks for the explanation!

>
> >> Furthermore it would complicate
> >> the upcoming changes, so just skip them in the slab hooks.
> >
> > Ok, I can understand that. If we do this, we should document that
> > kfence objects are no longer tracked.
> >
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slub.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 0337e60db5ac..a4be70d080fb 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2352,6 +2352,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cach=
e *s, void *object, gfp_t flags,
> >>         if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
> >>                 return;
> >>
> >> +       if (is_kfence_address(object))
> >> +               return;
> >> +
> >>         slab =3D virt_to_slab(object);
> >>         obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_=
flags, object);
> >>         /*
> >> @@ -2399,6 +2402,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache=
 *s, struct slab *slab, void **p
> >>         for (i =3D 0; i < objects; i++) {
> >>                 unsigned int off =3D obj_to_index(s, slab, p[i]);
> >>
> >> +               if (is_kfence_address(p[i]))
> >> +                       continue;
> >> +
> >>                 alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref,=
 s->size);
> >>         }
> >>         put_slab_obj_exts(obj_exts);
> >>
> >> --
> >> 2.55.0
> >>
>

