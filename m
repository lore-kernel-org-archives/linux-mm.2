Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C0FECAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CEF8E0009; Mon,  8 Sep 2025 22:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED698E0001; Mon,  8 Sep 2025 22:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC0C8E0009; Mon,  8 Sep 2025 22:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67C128E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:32:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 100A614036D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:32:59 +0000 (UTC)
X-FDA: 83868139278.04.8D7C251
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B7CC40003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:32:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VF07VNeb;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757385177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqGZLA2OX1lVz766/XmCg7OsOS1a4ZDVYW0b4KhD9ps=;
	b=lbtbFipMehIDLndnqtJXkayWfDkrEhbUtzt+8V1tO87DH/Er4Ts+pwoyQP1TnwxVIPA080
	CXYVZHInFTxoccbeDnld6Es+tBymqE3Vda810IJVF27umpfbdquex2D6WHGjpiCSefjOYZ
	UWbwp2fwbnngoA56psp406eop6ouYwI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VF07VNeb;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757385177; a=rsa-sha256;
	cv=none;
	b=xsMIn70CTXKq+mgd7STvA9gZkImSNZJRS75hqa7eFfs9WrGcGWbDQArEl812F/wFkl1v0i
	W3Jx3EMXWKXxXjr5XP16A0qyD6Xaq0YSoTHPXBam6e0IgV+kz+Vvrw30+suG18dm83Db0l
	xDmJZq3/nRpfFKygu9NwWi7YWxO5zxs=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3e34dbc38easo2092840f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 19:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757385175; x=1757989975; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqGZLA2OX1lVz766/XmCg7OsOS1a4ZDVYW0b4KhD9ps=;
        b=VF07VNebg8ihZp354RXPeTl7x3Z1+fgZbrSQqakHuSIxlQFkqd1Ai00k2APJfv6wmS
         25IQOGpWl9pZ2T2OIeHEMbPV17n51gk9vNJdObOlPVQoM/GnAHEXWq9KeMyrJmjolNcy
         SRJtwfTPqzTGYkrp3+d2pjUu13i3eesURxwUtB9NARXrlm6so11Pzq+6Q2IsOnicEBtg
         jJ2Zu3vbQ8MwmeQZ+1OlBIrTeztE9Gnraqvv7ICNHOv1Ed0rkgsC6mNAct0tsI1QPqZo
         0VsS3o5wqFkBHXS/gOavChuzgsw/Rq5aSs81q7N/0Nstk8paI4Lmg8g5SQsBHn7R1FmT
         YZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757385175; x=1757989975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqGZLA2OX1lVz766/XmCg7OsOS1a4ZDVYW0b4KhD9ps=;
        b=UDGBuKPUcwbk8hi48FkO7HqdwyjiHdJ48yYSjf/jZjvC7FE3cmsscQlujETnXTeeK7
         oWLsnWhkRwdoF4b0OhhshnIzpzqlgDjNTHSePxBY64LLqLFUQavMtAIjjCCjRdC/qu6E
         fGCE0bp4q+rN5awnyoiPgvvzRFrz1dVafAXJRoeCOY9DbTg9xrJoSUXX29wlqHjpiEcI
         ywwdgPvZW3wJiPEUV8emLZKSRpEGcp2SjhpPhjVsCpEutO2s7iOsMvhJShKgFMCmYoWm
         L4akBe32WhC8e1FddFKV1QlLHTJAIcXLuYig1QhrUipOO0iXUIOrX9s9LbFfLCW9osel
         yeZg==
X-Forwarded-Encrypted: i=1; AJvYcCUUVlVGFpraSPxyt3v2DVxD6ypZyaIohM65xp+pNyC0H2kLKIuWvc3fW6uzflJddSLxCPQ5ljsYCA==@kvack.org
X-Gm-Message-State: AOJu0YwDOt65KUs6U229SCw/sW9dcDyDJycWSNSLxSmlHXObgS7Ecbed
	Z8f4NSxlYop/E4rYYmTVIyvxIEhHlflpwB5Wt1BmeggFQZQwrMUHplhxvQZtIKSr1U3+sgDOh1K
	zKZJVp9WxUF21xpW8rQmuupJ7giBi91I=
X-Gm-Gg: ASbGncutc7sbSpi4SiIJR2EunILJ/NKQO8VlotKr1n6tmnlQ8mrMJivJGW5C6YG09F0
	HZFIpUpbr2t6K2zUSFEO/ZzK1SbIQ4C7580KwxUvRChi+mVqgAHj6y5cstsq/eJPk5kut01OfF0
	a7L+t6KsdSFV6/b9QRF4EIX6fNlJ1A7puVnlqntxMCC/VYidtppSMTgi5MQgfqDcZ7jC2e5BJC7
	MWvskAeVk7v8FoLqhqHuClV+PkK8E/BMZev
X-Google-Smtp-Source: AGHT+IHyp/eLGeencmv3HRpkvDDMa5A9j/c/TphmUA+AbFrRCmfjZE4eqMeGKGIODZDGB4NvJj/IdnoieMNsDy+ELOY=
X-Received: by 2002:a05:6000:3101:b0:3e4:f194:2886 with SMTP id
 ffacd0b85a97d-3e642cadca2mr8416382f8f.19.1757385175131; Mon, 08 Sep 2025
 19:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250718021646.73353-1-alexei.starovoitov@gmail.com>
 <20250718021646.73353-7-alexei.starovoitov@gmail.com> <aH-ztTONTcgjU7xl@hyeyoo>
 <CAADnVQLrTJ7hu0Au-XzBu9=GUKHeobnvULsjZtYO3JHHd75MTA@mail.gmail.com>
 <aJtZrgcylnWgfR9r@hyeyoo> <aJt1FHnavjRv5CzI@hyeyoo> <CAADnVQ+aLojadnDgnOwJCTAE319can=rW7ELh2Xy5M-d2TWcHQ@mail.gmail.com>
 <aL-LX7JI6KLcB-dp@hyeyoo>
In-Reply-To: <aL-LX7JI6KLcB-dp@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 8 Sep 2025 19:32:43 -0700
X-Gm-Features: AS18NWD2ijOkR7C_EFgiM3P_wPzb5yEZ3i8W9mhM8tIKd0KmklGpXA5KL5Y2Y3o
Message-ID: <CAADnVQKQLEEJ4hj4dd0Br7R6tCSvO7EuccxLTL7LjHW3pXC+mQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] slab: Introduce kmalloc_nolock() and kfree_nolock().
To: Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B7CC40003
X-Rspamd-Server: rspam05
X-Stat-Signature: 333wh3uf8ymhci3n8ujcipxzhrizbphx
X-Rspam-User: 
X-HE-Tag: 1757385176-570793
X-HE-Meta: U2FsdGVkX1/5N5JNpI1r58wbB20WYK0EWSOTqGKmKOgClcBx8ZBGXdG53PwsvrPr1v1xoc16LhcP3GR+OvsRiuISg6gWsoJy8kvZwi4AHXOqN61eql6O9iuaRQpFrCa7Sb6kTEQQI22Rj679zqJKROR9aju2DiXQ3Kc1KwMZmYVr9HQqWq3JIQfP2D52eNyZfNvYbjXILe2QUjR++ClRY7aVA/NXibuQ1VKb+5N5CYHbJCWq2gDh5GZDU523MY5NueT8WutsBhdNQU1+T3SOqFx/sQt6JzQR/L02RlnxmWWCyt75WmuhnognTSNc11B71bZXN/gkswpBWbcREhSGteMdm0vKYwF3m3dwN/93i7CauJfk4rAVIaM7CTU9G6nMYmjCyLs9hGGzYBE4D86sVT9vp+XPdTOTqlQ5X0uLTlBaKE9E6+3WYf8JXSl29SBwcS3b0vorylEofinQNIDxaLzWGepd1D0a+uVXGU/YCM/6RPY+O03KZRXbc4xw0XhqrSTLDPO2fWNGMxDc/hOru9BkY+hS6n/GgAe8h29J7sSgQZM2gwq8hOslb7eheGsGwJnXuEQ+PBEEGgJ2ZsAIzBTP/FczWZ/7kCAUBWlB2IUv/zOuiBmDv9/NLU8wOqX2wMaWwBmKNxtMdZMGApJ3fKhLOKoGKYZdwpmwpW6lBCX+JSddbS8Ur5N6A0hCbLEZb6u0TesRD9eIL39TjF4zjVmyqryx1vbNNS7RL3WNxH0095I1O9BW9G+MI5alRZTCX945AehwWCQpXHCog9ZCKKFuQCYR9f/7dvSnvIDA9zO9bRiBTBprQewZgf++5SXVymN+zKcwD8hNQW5X05Prh03RLZyXcTuL0MgDx9Ygqa+59rS9LuUoLmTCdKHsDhnfgRoMxBLxorTYoH91InluMnFHNnbCdKIv5LH9q6ZyDxQd6xc39+wr/GoNqZ3VEZzgvjxmMphYpE5hT4cx+tf
 Q0KEdVHH
 W1tku5Ag48sEWNnjAkBDB7V50IzrjuMv5ILkcEogNcEAdHl1iSmrsmhQb6NtsmoS/8+cAHhK/e/L89O0PsXtp9LwP/nK9u+9JkOTnmsgAxF28x9rWXGgLBaL8h2vEbThQTBwqDDiMr+qz+bKSMPv99AVtQu+WK2s9At5lXnWuox+qJjlIIX1eESV01DwbCLAJ/SYExA3jkSL5d31oB9YMSocSvq/ZVsv0mYzkatk8zAWLIDaLVUTIKEZv7x+aNpUkm9YBUzZQqhOC59gmcecN29hzFxJWQSYdxX4yb4uoU/y3jrgJE8GH/Vd/FcHMJnL82CXCqgfkde9hvPNCODxGWmXWsLkQ0H5XYgFnVoomAE4KY0WPLuCJweHK0cW0EoJnUNhbv1piRFkpnpru3zT8coWAkLG/gHRfU3XkzX+BkpfxaK2IkhiEV57aYlKHTrEkzMKLPPiYTiX+Mtk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 7:05=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wro=
te:
>
> On Mon, Sep 08, 2025 at 05:08:43PM -0700, Alexei Starovoitov wrote:
> > On Tue, Aug 12, 2025 at 10:08=E2=80=AFAM Harry Yoo <harry.yoo@oracle.co=
m> wrote:
> >
> > Sorry for the delay. I addressed all other comments
> > and will respin soon.
>
> No worries! Welcome back.
>
> > Only below question remains..
> >
> > > > > > >  {
> > > > > > > @@ -3732,9 +3808,13 @@ static void *___slab_alloc(struct kmem=
_cache *s, gfp_t gfpflags, int node,
> > > > > > >       if (unlikely(!node_match(slab, node))) {
> > > > > > >               /*
> > > > > > >                * same as above but node_match() being false a=
lready
> > > > > > > -              * implies node !=3D NUMA_NO_NODE
> > > > > > > +              * implies node !=3D NUMA_NO_NODE.
> > > > > > > +              * Reentrant slub cannot take locks necessary t=
o
> > > > > > > +              * deactivate_slab, hence ignore node preferenc=
e.
> > > > > >
> > > > > > Now that we have defer_deactivate_slab(), we need to either upd=
ate the
> > > > > > code or comment?
> > > > > >
> > > > > > 1. Deactivate slabs when node / pfmemalloc mismatches
> > > > > > or 2. Update comments to explain why it's still undesirable
> > > > >
> > > > > Well, defer_deactivate_slab() is a heavy hammer.
> > > > > In !SLUB_TINY it pretty much never happens.
> > > > >
> > > > > This bit:
> > > > >
> > > > > retry_load_slab:
> > > > >
> > > > >         local_lock_cpu_slab(s, flags);
> > > > >         if (unlikely(c->slab)) {
> > > > >
> > > > > is very rare. I couldn't trigger it at all in my stress test.
> > > > >
> > > > > But in this hunk the node mismatch is not rare, so ignoring node =
preference
> > > > > for kmalloc_nolock() is a much better trade off.
> > >
> > > But users would have requested that specific node instead of
> > > NUMA_NO_NODE because (at least) they think it's worth it.
> > > (e.g., allocating kernel data structures tied to specified node)
> > >
> > > I don't understand why kmalloc()/kmem_cache_alloc() try harder
> > > (by deactivating cpu slab) to respect the node parameter,
> > > but kmalloc_nolock() does not.
> >
> > Because kmalloc_nolock() tries to be as least intrusive as possible
> > to kmalloc slabs that the rest of the kernel is using.
> >
> > There won't be kmem_cache_alloc _nolock() version, because
> > the algorithm retries from a different bucket when the primary one
> > is locked. So it's only kmalloc_nolock() flavor and it takes
> > from generic kmalloc slab buckets with or without memcg.
> >
> > My understanding that c->slab is effectively a cache and in the long
> > run all c->slab-s should be stable.
>
> You're right and that's what makes it inefficient when users call
> kmalloc_node() or kmem_cache_alloc_node() every time with different
> node id because c->slab will be deactivated too often.

Exactly.

> > A given cpu should be kmalloc-ing the memory suitable for this local cp=
u.
> > In that sense deactivate_slab is a heavy hammer. kmalloc_nolock()
> > is for users who cannot control their running context. imo such
> > users shouldn't affect the cache property of c->slab hence ignoring
> > node preference for !allow_spin is not great, but imo it's a better
> > trade off than defer_deactivate_slab.
>
> The assumption here is that calling kmalloc_node() with a specific
> node other than the local node is a pretty niche case. And thus
> kmalloc_nolock() does not want to affect existing kmalloc() users.

yes.

> But given that assumption and your reasoning, even normal kmalloc_node()
> (perhaps even kmem_cache_alloc_node()) users shouldn't fill c->slab with
> a slab from a remote node then? Since most of users should be allocating
> memory from the local node anyway.

Hard to say. I think kmem_cache_alloc_node() users created
kmem_cache for their specific needs and node is more likely
an actual node id that comes all the way from user space.
At least this is how bpf maps are operating. node id is provided
at map creation time, then all map elements are preallocated
from that node, and in run-time elements are recycled through
the prealloc area. numa id is critical for performance for
some bpf map use cases like networking, but such strict numa
hurts tracing use cases where elements should be local to cpu.
So I'd keep deactivate_slab behavior for kmem_cache_alloc_node()
and try hard to allocate from specified numa id,
but I would do an audit of kmalloc_node() users (they aren't many)
and see whether "ignore node id when c->slab is different" approach
is a good thing. On a quick glance net/core/skbuff.c might prefer
to allocate from local cpu instead of deactivate and allocating
the whole new slab which might fail.

>
> > defer_deactivate_slab() is there for a rare race in retry_load_slab.
> > It can be done for !node_match(c->slab, node) too,
> > but it feels like a worse-r evil. Especially since kmalloc_nolock()
> > doesn't support __GFP_THISNODE.
>
> ...maybe it is fair to ignore node preference for kmalloc_node()
> in a sense that it isn't great to trylock n->list_lock and fail, then
> allocate new slabs (even when there are partial slabs available for the
> node).

Yep. Exactly my thinking. At least that's my preference for kmalloc_nolock(=
)
and it is arguably a better choice for generic kmalloc(),
but probably not for kmem_cache_alloc_node().
To make such a decision for kmalloc we'd need to collect a ton
of data. It's hard to optimize for all possible cases.
While for kmalloc_nolock() BPF will be the main user initially
and we have a better understanding of trade offs.
We can change all that in the future, of course, if intuition turns
out to be incorrect.

