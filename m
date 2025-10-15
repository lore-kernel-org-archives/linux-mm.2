Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B5CECCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27AD8E0057; Wed, 15 Oct 2025 12:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF5A8E0005; Wed, 15 Oct 2025 12:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C1B8E0057; Wed, 15 Oct 2025 12:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 938808E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:51:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 498471A01C4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:51:59 +0000 (UTC)
X-FDA: 84000940758.12.9C25FCD
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 53B0F1C0017
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:51:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iXIDXDBZ;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760547117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9apsDayZRzDTw/yqZt7bxlKxNDmDz0cZMGpkHc07gM=;
	b=awzaubCPUcLAiJGuMmIOybcp1LeyBgq/O6cQeme/n3pr98ka0zisYeUv2+aWPd9qR63RAz
	CmmxMB6NyAnqazfXajb6qil27uWg62yeVGVW9rg3xx7eePaFWMtPIzdq+QV5B8e9WsCliX
	8bkY9543PTBTNnKQ4OjUwe8awQeeuC8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iXIDXDBZ;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760547117; a=rsa-sha256;
	cv=none;
	b=pKuR5iIERmBpEKc0WrslwXsw+2mVhn0DA4TWy2H7Q+RWLg/SbwZuOjcano4jCn9tigiZ0u
	UWv+rXCUOM0wgWXvlaGCrC1DKcsHLZzNtwWDrZ1yOGYTgs3d6mus4+CeFL7gOlbjJxnsho
	lM8pdCoGkiUKkA5CiSaSfcOQCO31UN0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so15062a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760547116; x=1761151916; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9apsDayZRzDTw/yqZt7bxlKxNDmDz0cZMGpkHc07gM=;
        b=iXIDXDBZBe0oIyt7B7TYKhLqi658axNUVmXtVy47C+U09OTw90Tu5ft45++1PYRljh
         QGFtm4fygky33ZbTuvOV8OqeB8FYrdsy0kVJawTqnGc817bSTwXEStfL07PoHOj0pipj
         f6gCtiXCPELjOKbkUV+FCVFdKC4QxTQ81mmiPIaXFiJONNrOYvHLRSuAbMzJlxRcGAO4
         SZUsAD/UcbWY6Las4I3JAREeOljB78AiDPJP5m4DnhAjoNQilHKOZV7hAHuOU8IHyrq4
         Cu3YVz6MoWbx2J+ZHxiWsnRs7ga3AQTuGmCGO7EtyRPvKpCgJkvpwTtisN5eVF0COi7Y
         AEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760547116; x=1761151916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9apsDayZRzDTw/yqZt7bxlKxNDmDz0cZMGpkHc07gM=;
        b=qFHVN2tvIHrZYhPh4y94/7FZNoNqFcwjtUYyhKFne2pKYjQuAn2+rwwmQ0Icuosbar
         vyOKMOF9rwo9PbQZC/oASHICk/TDtBsAw8KZO7Mj4fvQeJXzXaZFJqpbu7GTMm7fTIHy
         dFBJWatdxRnKvvufVMDvIXrspFQsUE3sL8wlwD1GUn0fNl3BH+FI0J4IzDCHia07mTBU
         d5Es0+hn/VDC5NMf5ralTIAFBb2AqOahFJv6SNf39V3jUcZlAS86ua5xOZuy1ZLU6dzy
         DMh8RfzlgFMsWCHxqIPlMiI31DyNXQXGg6QGQSjyT4gKyHDWfG6JQTl9+7nMtxbsS/5X
         nKLw==
X-Forwarded-Encrypted: i=1; AJvYcCWgFiod5UDGNrDAS9ryxCCSwsMFr+itbV4Oqbh7wMZJ/q+b92gKA+689eOv+xz9vNU0RSgpQSeGgg==@kvack.org
X-Gm-Message-State: AOJu0YxwEfSNjtpUxqieQqksHMUljphSEldu2OPU6Yk1N/yVlOhw18xg
	t1WIm/zMqlVNTxoGqkiEvV+lgUBwE59p95bO4wyq/rc5FkG0bezXvgefM7yehcwEQqUVccUnj6R
	C4KgbgpiVKSU96cKcVFsG0nCIc1Qree/K1BC69Uf+
X-Gm-Gg: ASbGnctzCu4jMzZCeNnU4imnfDCeIOt02dW+nkZoG/jVgUYoIiZHTyDuTvbT0WzTXYE
	F3bf4vSYHM9PSos6vBBICY0rN1w/eXNn2vx3bHlctSRcxMgpP7H4FOy2EJcxkuFm7vCgvU0OirT
	TuRbTKqqqUBYuIUwHKFjes1k0kzvgTXbZlikWAz7PA6nzQWERBoqP4SL/Hyin7OPSaUW2qxNoEP
	ps8ONE4+Zmtrhsa5Dd6p6LFY2kF92/I68MfzDDCXNBj0/uw1VHkiROvy+YOF86jNxQfeLNYdjeQ
	/SkYJsYH
X-Google-Smtp-Source: AGHT+IFdygiMrtAr3w7DSDw7JV9029btHscJYvjgfYSwaS21yzc+Kl0Y+SRoposbiwbIa6UvUKMeWDqflKBTeUkbkUk=
X-Received: by 2002:a05:6402:2346:b0:634:909c:d3c with SMTP id
 4fb4d7f45d1cf-63bebf9d4c8mr145952a12.2.1760547115463; Wed, 15 Oct 2025
 09:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20251015141642.700170-1-hao.ge@linux.dev> <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
 <6728a58d-7849-4eba-bce4-68968dd55afe@suse.cz>
In-Reply-To: <6728a58d-7849-4eba-bce4-68968dd55afe@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Oct 2025 09:51:42 -0700
X-Gm-Features: AS18NWDqQ41FVH8ZYboWxXt6zcq7Vx8LpxfxJ3nRfWr_DO8FT0wuSBcm_pg4RZo
Message-ID: <CAJuCfpEMqh81=Cx0jnrxFnjV3wYOisoOLUoHi6gzbb0XRsQ-Rw@mail.gmail.com>
Subject: Re: [PATCH v5] slab: reset obj_ext when it is not actually valid
 during freeing
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ykscrorhpey46698rmqfg3y3qz3b9m6b
X-Rspamd-Queue-Id: 53B0F1C0017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760547117-847251
X-HE-Meta: U2FsdGVkX1+gpeR+oPdzUx4gKpymvLC1b5idi6pd04TqJFRKbL8BuFFXQWQGNJVhPm/xybiU8KAl+vhyPsTU3MOaIcSQXG3fCgSI6Why+wqJiHR1Qv16QWF3cfUBUsNTUnfm5bC5iCAqfcsbhR22mGasvNFCBOCF9b08IePi7qOn4KmPjAdD0NjaUGrBibSPmpevZdeewVd1y6/KnuJPmFj5O9DrNf0OxlPnwIeRAD7v6TqM9udePXMPFrWIWgHWuWGoKJY9BMBSy7lZFCjx/Z/2zY09BtbIFgTaLCRMcKXT+J0KQnIlYfamdrESb4BYUjV25mxz02dNz6Ec5inukrJvLW3p16f1LD+amoQBuc7ai+kDSOq0cVs3NjJkbwGJhbju2edCLFaVWjdF8p7VWdihVs9ZCdrizgu0nIJntG54ZVuX8XoaVWAaQcxzxindq+plvMbUbnztMsgbjsj7Qc8k4Pz3IZNRKFn/WKzUdS5Mg6gzl3NCCpIKsIQvk7BmPMZ6yq5aPBmOBlUExhq2/hbZBOldxvOZFbzQ8ocZglxa/yrHbhEOLl4sWpfSsX//gSTS9ydFOmEmX0BePdmh8atv48KEMTeTgWiF3PUm3uZkoUl1kkRt1XKAmJ44SjyZ8q5/q/TOGume/FKk4Kvcz0FTh3cQLsehwl7efmVnH03XlRkYaTPbGIHj3ob4T8AUReHsJ8JYx4AQ3oYv+XcbGlxdRtUvoqd/beHt/P+tI6R7MfTZroWvhDKKSM5+ARWhEoyxDLkHA9SrD/EBnEkqJOJ0kz+tEGuGOxbkS+n5YKvIpXWy9upkT5fgO2r9gO29dy6uzTvyPXYWJawx7hL9CeK4ig673GrsWNQvkazHj0rb4dk9dbQf6p7MwWklVNrXxmKWauNpUz9XB371dS/pgsTpV0N3To3C2ur8Pz6SMC3Zz3JTICRUMrg7X4QZl0dJwAYCxkgBvl502hdc6jf
 hdRjqjDz
 hrXLRbfTse09UFApi99daWoE+KUybh3pF/96nh/pAttLuePNaZTMQnpISmrnj5uQupQpQJ/Lz/vw0X2iU52n2QKG+D7Tfoi+eJlGv2qUtLrJ6P9DAI5KEljZrvto/yTXB6hQAN6qwK97UHB3I3NQlmkQFWsZ/LXuxyWp2auMwQ4m6pIm2Nu5TDRqlcKSoJNZdoy7ZpCB8RjjlCIPGhK2C/LfZR7lfHN/d3N82FlNLmcWLaL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 9:37=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/15/25 18:29, Suren Baghdasaryan wrote:
> > On Wed, Oct 15, 2025 at 7:17=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> >>
> >> From: Hao Ge <gehao@kylinos.cn>
> >>
> >> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_=
FAIL,
> >> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAI=
L and
> >> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> >> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> >> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> >> a valid folio->memcg_data was not cleared before freeing the folio.
> >>
> >> When freeing a slab, we clear slab->obj_exts and reset it to 0
> >> if the obj_ext array has been successfully allocated.
> >> So let's reset slab->obj_exts to 0 when freeing a slab if
> >> the obj_ext array allocated fail to allow them to be returned
> >> to the buddy system more smoothly.
> >>
> >> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >> ---
> >> v5: Adopt the simpler solution proposed by Vlastimil;
> >>     Many thanks to him
> >> ---
> >>  mm/slub.c | 10 +++++++++-
> >>  1 file changed, 9 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index b1f15598fbfd..2e4340c75be2 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2170,8 +2170,16 @@ static inline void free_slab_obj_exts(struct sl=
ab *slab)
> >>         struct slabobj_ext *obj_exts;
> >>
> >>         obj_exts =3D slab_obj_exts(slab);
> >> -       if (!obj_exts)
> >> +       if (!obj_exts) {
> >> +               /*
> >> +                * If obj_exts allocation failed, slab->obj_exts is se=
t to OBJEXTS_ALLOC_FAIL,
> >> +                * In this case, we will end up here.
> >> +                * Therefore, we should clear the OBJEXTS_ALLOC_FAIL f=
lag first when freeing a slab.
> >> +                * Then let's set it to 0 as below.
> >> +                */
> >> +               slab->obj_exts =3D 0;
> >>                 return;
> >> +       }
> >
> > How about this instead:
> >
> > static inline void free_slab_obj_exts(struct slab *slab)
> > {
> >         struct slabobj_ext *obj_exts;
> >
> >         obj_exts =3D slab_obj_exts(slab);
> > +        /*
> > +         * Reset obj_exts to ensure all bits including OBJEXTS_ALLOC_F=
AIL
> > +         * are always cleared.
> > +         */
> > +        slab->obj_exts =3D 0;
> >         if (!obj_exts)
> >                 return;
> >
> >         /*
> >          * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore i=
ts
> >          * corresponding extension will be NULL. alloc_tag_sub() will t=
hrow a
> >          * warning if slab has extensions but the extension of an objec=
t is
> >          * NULL, therefore replace NULL with CODETAG_EMPTY to indicate =
that
> >          * the extension for obj_exts is expected to be NULL.
> >          */
> >         mark_objexts_empty(obj_exts);
> >         kfree(obj_exts);
> > -        slab->obj_exts =3D 0;
>
> You have an older base, check current mainline, we evaluate slab->obj_ext=
s
> later in the function

Ah, sorry about that. Yeah, then this looks good.

>
> > }
> >
> >>
> >>         /*
> >>          * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore =
its
> >> --
> >> 2.25.1
> >>
>

