Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 038D3104BEDB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFEA6B0005; Wed, 11 Mar 2026 06:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADFA6B0089; Wed, 11 Mar 2026 06:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEA46B008A; Wed, 11 Mar 2026 06:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92576B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:43:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8271E1A073C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:43:31 +0000 (UTC)
X-FDA: 84533445822.04.F85C42D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3389E160008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:43:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PklujyXJ;
	spf=pass (imf08.hostedemail.com: domain of minlei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=minlei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773225809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Xjw8yXZWjS7rmwloovrXF0TGyPb8EZi/Ah7SDvpbN0=;
	b=u6ZpOLpbtLyrG2H71JcCxye4Ba6r63TyKDGuOH+JBzY57v/URNS/juRaziZ5C9ICRoqs5F
	G6IxXlSveqALMEFcwSnOBxwfwtytT8e1jsBjQUhm6lBjVVEdL2BWlRyswmyZjOLkbQnZ6f
	Dtl/Y9w3gyzAzZIgmxNwORvYpoPx50A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773225809; a=rsa-sha256;
	cv=none;
	b=PKcKO35NfPZhvVsmcKIQQXl81Eo74IBRr1mW8HHVTIUWZt3uRgAwvvYcUOWXe2rvYy7rzh
	WG/9RztpXRBSR/MIQFMpeCv5vhMuo/+Z/EU0SLIhrmiKsahe8XUlCwy6IQl95Je1Mf6M/B
	K7IXhu6O8q9eBFf/IJ3hiAjICrvYwQ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PklujyXJ;
	spf=pass (imf08.hostedemail.com: domain of minlei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=minlei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773225808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Xjw8yXZWjS7rmwloovrXF0TGyPb8EZi/Ah7SDvpbN0=;
	b=PklujyXJYSQ1h7jaMy1HuO1CiVJI1MsgCYXT+8msyYNgBKFX9SeUYjnpGDeMIIUYc64WSn
	hakNNosFYb6OsI5AQub7Yta8PVMKZg9bF61SllZLhceMq/+Oq4Vdnyh3gWiw+4ERcuQo3G
	g5+nH09oevUzj3tEk/XjwGsHUnaEWkc=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-3dYXyzt2OcqBJOJV7GKSkQ-1; Wed, 11 Mar 2026 06:43:27 -0400
X-MC-Unique: 3dYXyzt2OcqBJOJV7GKSkQ-1
X-Mimecast-MFC-AGG-ID: 3dYXyzt2OcqBJOJV7GKSkQ_1773225807
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-9483c030e3bso11933966241.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773225806; x=1773830606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Xjw8yXZWjS7rmwloovrXF0TGyPb8EZi/Ah7SDvpbN0=;
        b=HSF4LTvjBXUcA3pSkYdIJNpDni5YYsN3kEYFcBeMEHA9ckfDMmch9MND+VU4+GQDhX
         3sU7N2DQzjnu74QfWOxG9rrfk+U6+L1cwhwphTmldx5FseSPIqHvpVTSvQoscKx4XOGU
         TFJGRiLwKCx+UfbvgL+3qJN1YzOpk37PJlljmx4b91dOz2a5JTcmhQCSd+0hNdGh4RFN
         xCDY+1+1XqLzRhjG2u/0uVf1H2XEKg2ZPVCl3yAKZy06eyqjAARLhl7/Rw0EL1OUm3dy
         ta3SuMjZp3LNXm7dFeS5DJRTBDuqklBoECtz69MAu+c7GG+JuvP6C7VXT2Lc4XteBqpp
         p3Zw==
X-Forwarded-Encrypted: i=1; AJvYcCWaG7sapENZLYeLc+Xth5tdwtj4/MoL5mTqPrSW73BkhHKga1Bmn5QsQ6kv6RSK/FCI7hMvEE8ETg==@kvack.org
X-Gm-Message-State: AOJu0YxkOk1g1zp+QTrCJMLwDP9h+fH2hq9817/FWSpfTK1NKuugZ6V0
	mX7OqUN3L7Ue09+OxNasiGSuHXztv4whl3wf6SwQvWJMNfQDDPewafWwdWtK+VhpU0xCtxQERxv
	/omLaS62Dd0IJVgb4rAfh1hzMSyI7HOGo/UO+B6oK4DFwRAU2OJEbTNKFyqp/Zr1bJOuALrmMOm
	0nDePYGDE0nIhUuI1azLvwONJ1vP8=
X-Gm-Gg: ATEYQzwpNiSVuLg6p9sQmFmRXsqtnOKH2cY2hlTv+UM5C/aEZobabgZ77OLbIhatcAZ
	1F9NZjuzXS4Ja1gvIqKi1parrtL85CnaM4wl8qCDu0mXROiVYBDrP2gBwQ2c5f+fEAsdOaGgIOY
	9ChlhFVALhQqvOb/RtWaFfONjgMMPdlNgIxVAic9SDhyj4XZKZaRMYoVgdMD1YVavOVC3UdQksA
	KD+wpPZ0p0YH29/Ag4l6YThlhBPSyrlfIi7mDU=
X-Received: by 2002:a05:6102:6ca:b0:5ff:bbc1:50a7 with SMTP id ada2fe7eead31-601df72aa68mr781425137.15.1773225805993;
        Wed, 11 Mar 2026 03:43:25 -0700 (PDT)
X-Received: by 2002:a05:6102:6ca:b0:5ff:bbc1:50a7 with SMTP id
 ada2fe7eead31-601df72aa68mr781415137.15.1773225805639; Wed, 11 Mar 2026
 03:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <aZ0SbIqaIkwoW2mB@fedora> <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org> <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org> <aapeVb_L5zohWRRe@hyeyoo>
 <d5cd4eb4-1703-41af-9c71-842ae33edbdf@kernel.org> <aaqq7YmUcOht3GWH@fedora>
 <abDA9UrJBT1wXh22@hyeyoo> <abFA17ZmsW6RgcYI@fedora>
In-Reply-To: <abFA17ZmsW6RgcYI@fedora>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 11 Mar 2026 18:43:14 +0800
X-Gm-Features: AaiRm506C_nISMUep0Od2dqpUzuzhQzDUy4U2M3p2Tx9SR_kxDokMrc0Dva4Nao
Message-ID: <CAFj5m9KutWuGfPN4cfAd-CjFNTCC+fLw0DtMsFFQrRBEeK-8LQ@mail.gmail.com>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 17ENYYbK2swAQ-7tnOI-ky1_VcoST3OFxJ7UR3UAOcw_1773225807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 44w1hxw1xyuz48rywpuh5pre69cr7ioc
X-Rspamd-Queue-Id: 3389E160008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773225809-604063
X-HE-Meta: U2FsdGVkX19Cs9wlRkKwXQ8ABgxhUYYOotciz1p5oVnOM+8+RAY9DnFO66aLfkNzEKT/Aq0bNgoi+bfC9k4UoSj0Q5WpIxOVTbiEvruE7GPikz7ZNx8iYIVJiYpbeQ04urdjihlhW5iVyVNBKOF9C4Urvq67+Liad0tYpNurAWgnb6JY8rWwczDpDekNuS4a6S54gNHd59Pc8equjLUwtTXQwVC1IYXr6WX/oWlZTWCJGAI81pDWitBQmPcIqVkkKGEvT0kLxx2RYRthm5vfv6izZPSTgw3551vDTVeCJXGFEpvtYXJZpQ3hHiy+8T662S6un2O0a+ikVkaqdYVtHif7msHWkbXBi4av3lOfdwDH65XwOl03yL8Fq6fOSqbKp1FuyNfosr2znWABL4d2lQbRKuF5gV08qGn8NqZHqe/ZOCX66GzC1pIOuRINW6Vws/hSYsevv1Pu14Q81LIzMWrWSN828dhiF2ssAfdYeEengKxjuLi6b+6efXKdjQLLAskE3QXshD9IqBvTVv/NrK/H/WcJsqvDa3HmfRyaSTiMBJNMWBsvTV+Jh8EUEKBfPAgALHmH63y47F3/1bRKrjwUWlXWBp1gCy6Zuto8QHfVh0zNziiWHSN98Y7ECMOhqzmRefYVhw64yfftNGGGukgoT1NB49zp8wEhJzP8PeFrvCtc5Ziwi00NLFfxHqad5qEoIHS5pkbqu7ZF2WWqih+cyNIC4yLSrL6xkN/swxzCTZpr628m7MXL6LXEeNAbTwltmshqG74y7IKnQGs07nXLRp79qA5yhrDRIa3QTrlS8qUqO6h5FC4kZdV+iEeg68qV6jtKFfcKb+3/tat4cXMpaTW0AIHz3g/MS+CGzc8z+lHJTUcVlYU5N1cQzVjWPdbKFZ0phWJ2Z6weqLboAINDlYUqC4MwsR75PIKHZ7eLhNMbOJIOuDOtO4dove8wrzn0orW0Aeu0Reknh5p
 fEvS60kb
 XgcaIN3zP7cyU/n5ZOeK8Sh7HUfus6oD+dPGB6zVI3SoBqlHhXBO71KCaXnilFgYKAMj5Un97EqqQ+LqPy/rrSxLBgYT6959P8e2lZhL/IxIWvnIup5mTSZkm2bw+uZeJpGLhI/J3B5Jh+Fl7t4A+FKFdblW87VMxmsQt6bpM7I6xN7jwH07B2VJSiaVoK6q3MSRJpb1f/t51DmRs8CDpNKHeV+OKlwOcGoML07Selpx6qHDtI2+h36J78VFs3nbBHQXgYS16mj4W3FO6PSzYbKM7EsJdxpH3oKmleWFYNMTVmGl2ZBvibkx9bueZiqhC4mgR3JRQtt0n34KLipP+oZU+N09+EYS0bwzw8C5KKPsykCaERkVh2AckgMNBixpqApg0vwyTQlSHP2jbf+bACmrvK6UERG/NhcOAZRwqZ/qq6WMUuBAKy6bOWDnnBvLAU1I+2PuAFQcpj64RcXh/gdT8t62e+J272ibq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 6:16=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Wed, Mar 11, 2026 at 10:10:13AM +0900, Harry Yoo wrote:
> > On Fri, Mar 06, 2026 at 06:22:37PM +0800, Ming Lei wrote:
> > > On Fri, Mar 06, 2026 at 09:47:27AM +0100, Vlastimil Babka (SUSE) wrot=
e:
> > > > On 3/6/26 05:55, Harry Yoo wrote:
> > > > > On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) =
wrote:
> > > > >> On 2/25/26 10:31, Ming Lei wrote:
> > > > >> > Hi Vlastimil,
> > > > >> >
> > > > >> > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUS=
E) wrote:
> > > > >> >> On 2/24/26 21:27, Vlastimil Babka wrote:
> > > > >> >> >
> > > > >> >> > It made sense to me not to refill sheaves when we can't rec=
laim, but I
> > > > >> >> > didn't anticipate this interaction with mempools. We could =
change them
> > > > >> >> > but there might be others using a similar pattern. Maybe it=
 would be for
> > > > >> >> > the best to just drop that heuristic from __pcs_replace_emp=
ty_main()
> > > > >> >> > (but carefully as some deadlock avoidance depends on it, we=
 might need
> > > > >> >> > to e.g. replace it with gfpflags_allow_spinning()). I'll se=
nd a patch
> > > > >> >> > tomorrow to test this theory, unless someone beats me to it=
 (feel free to).
> > > > >> >> Could you try this then, please? Thanks!
> > > > >> >
> > > > >> > Thanks for working on this issue!
> > > > >> >
> > > > >> > Unfortunately the patch doesn't make a difference on IOPS in t=
he perf test,
> > > > >> > follows the collected perf profile on linus tree(basically 7.0=
-rc1 with your patch):
> > > > >>
> > > > >> what about this patch in addition to the previous one? Thanks.
> > > > >>
> > > > >> ----8<----
> > > > >> From d3e8118c078996d1372a9f89285179d93971fdb2 Mon Sep 17 00:00:0=
0 2001
> > > > >> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> > > > >> Date: Thu, 26 Feb 2026 18:59:56 +0100
> > > > >> Subject: [PATCH] mm/slab: put barn on every online node
> > > > >>
> > > > >> Including memoryless nodes.
> > > > >>
> > > > >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > > > >> ---
> > > > >
> > > > > Just taking a quick grasp...
> > > > >
> > > > >> @@ -6121,7 +6122,8 @@ void slab_free(struct kmem_cache *s, struc=
t slab *slab, void *object,
> > > > >>        if (unlikely(!slab_free_hook(s, object, slab_want_init_on=
_free(s), false)))
> > > > >>                return;
> > > > >>
> > > > >> -      if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=
=3D numa_mem_id())
> > > > >> +      if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) =
=3D=3D numa_mem_id())
> > > > >> +                      || !node_isset(slab_nid(slab), slab_nodes=
))
> > > > >
> > > > > I think you intended !node_isset(numa_mem_id(), slab_nodes)?
> > > > >
> > > > > "Skip freeing to pcs if it's remote free, but memoryless nodes is
> > > > >  an exception".
> > > >
> > > > Indeed, thanks! Ming, could you retry with that fixed up please?
> > >
> > > After applying the following change, IOPS is ~25M:
> > >
> > > - delta change on the two patches
> > >
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 085fe49eec68..56fe8bd956c0 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -6142,7 +6142,7 @@ void slab_free(struct kmem_cache *s, struct sla=
b *slab, void *object,
> > >                 return;
> > >
> > >         if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) =3D=3D=
 numa_mem_id())
> > > -                       || !node_isset(slab_nid(slab), slab_nodes))
> > > +                       || !node_isset(numa_mem_id(), slab_nodes))
> > >             && likely(!slab_test_pfmemalloc(slab))) {
> > >                 if (likely(free_to_pcs(s, object, true)))
> > >                         return;
> > >
> >
> > Hi Ming, thanks a lot for helping testing!
> >
> > The stats look quite fine to me, but we're still seeing suboptimal IOPS=
.
> >
> > > - slab stat on patched `815c8e35511d Merge branch 'slab/for-7.0/sheav=
es' into slab/for-next`
> >
> > Does that doesn't include Vlastimil's (fb1091febd66 mm/slab: allow shea=
f
> > refill if blocking is not allowed)?
>
> No, because fb1091febd66 isn't included into `815c8e35511d Merge branch
> 'slab/for-7.0/sheaves'.
>
> >
> > Next time when testing it, could you please test on top of 7.0-rc3 w/
> > the memoryless node patch (w/ the delta above) applied?
>
> IOPS is same between `815c8e35511d Merge branch 'slab/for-7.0/sheaves' in=
to slab/for-next`
> and 7.0-rc3 with the two patches.
>
> IMO, it should be more easier to compare & investigate by focusing on
> 815c8e35511d, given there is only 41 patches between v6.19-rc5 and
> commit 815c8e35511d.
>
> >
> > Also, let us check a few things...
> >
> > 1) Does bumping up sheaf capacity change the slab stats & IOPS?
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 0c906fefc31b..5207279417e2 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7611,13 +7611,13 @@ static unsigned int calculate_sheaf_capacity(st=
ruct kmem_cache *s,
> >        * should result in similar lock contention (barn or list_lock)
> >        */
> >       if (s->size >=3D PAGE_SIZE)
> > -             capacity =3D 4;
> > +             capacity =3D 6;
> >       else if (s->size >=3D 1024)
> > -             capacity =3D 12;
> > +             capacity =3D 24;
> >       else if (s->size >=3D 256)
> > -             capacity =3D 26;
> > +             capacity =3D 52;
> >       else
> > -             capacity =3D 60;
> > +             capacity =3D 120;
> >
> >       /* Increment capacity to make sheaf exactly a kmalloc size bucket=
 */
> >       size =3D struct_size_t(struct slab_sheaf, objects, capacity);
>
> IOPS can be increased from 24M to 29M with this patch, against 7.0-rc3 wi=
th
> Vlastimil's today patchset.

BTW, the improvement looks unstable; sometimes it reaches 28=E2=80=9329M, b=
ut sometimes
it doesn't, just 25=E2=80=9326M.

Thanks,


