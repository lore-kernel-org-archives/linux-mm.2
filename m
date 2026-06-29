Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC16CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 04:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B90C6B0005; Mon, 29 Jun 2026 00:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A4F6B0088; Mon, 29 Jun 2026 00:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731636B008A; Mon, 29 Jun 2026 00:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41C7F6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:29:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAB641C3598
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:29:06 +0000 (UTC)
X-FDA: 84931670292.30.E5CB1B2
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCFAD40003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:29:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IiqDW7rW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782707344;
	b=XBIshjVVNKO/mdlxYH9n5w/cicso10pVaNJFb80hxnLs+9Pi4xZq5xHhtV2P/Kmr/o6+mX
	nnsyMUXX8M4XNnF0o2DsaxIh7obh9UTF6JQ1HUIzTcjmoNohUT0aCOeFj3CA0cGxot8CQV
	EA9sgSyghzW62jL24qjvAusjyDkawC4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782707344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sv6r/7ghxXIx8WE0gC8A58FpOd9N/PfzWMq25G3TlBA=;
	b=D8lkm6ChX3MpZDqmbDYrEqGS67U8s6BhluGJIVPkNC7hxTNd9L7/p6qxxQ8H+sH3pxzMlr
	OXhlrqfaWInrloW5ZNII2TAU+2xqsz8/VpKe3TtJQgev0ei+5H96M6h/AeynEir6ZmeHEN
	UqoGPk5k4LcMey2Sd8h6zMmlq3giLlE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IiqDW7rW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51bfd1a1b6eso47831cf.1
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782707344; cv=none;
        d=google.com; s=arc-20260327;
        b=aZg/EOX4jaOANOByTkClmPipqIYP4ujhHMnAgNsmde5g9IaDvt8TLzfY6jYJ2MZuBX
         RgLjnSmqzHy3axN10Ejb/CgWOSjJqVbW+57HLdJkbcYxVLpsBZQp1bmRcfBY2uwOiXyI
         rZZDBn9RRWfme1Qvmc7sMzdFFAR3pBa8zmdfsFa/JSVRGKSpJpDXZco3rVqiERQE2PDq
         PVeBJHRQYxYZEfaa/OadvllMlP2sB65Rti1EeicjxRCeXgeKYLgBx1P8siXizG/KbKbe
         yoHE3xtrO4vl83hky2er1V0RyrZ/rWNfzdtVitHCtPrpTnUidYdyiTnw2GHNhrKknLp3
         v1EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sv6r/7ghxXIx8WE0gC8A58FpOd9N/PfzWMq25G3TlBA=;
        fh=8j+u4TytkRazDSSY7eZq9ajwZCGGLz3ZbijIzOeYSWM=;
        b=Yoa3brdmALwmdYi4CHA09fWasxq1AcnFnik6gLsqszCgvHrSH+fs2eRk8zdvHb1flr
         hLytjonTFM5m3hXZqANFAXvLc26fV18lkjXtMKGzmZYxaL07ceOg5IDl8NUuB8TYIMDO
         TMvhzoJKJk/w02P9CgvUlqY2jSbsl1l/IUB62cGpQK2YeW/BcUD7VKbenXauMNz99oo6
         9rtMibJ+95ngJwX6QmvxQoJotQzyN83uaEpvNae+JjWEdixL72O+CUEIsBIDFdP0Cc/T
         dSvQcIrAwmFU9uJCLSlzJXqji/4ryAM18VscJdNCCZ+uknDbYpJF5OUB3q0pm2R6MUXS
         TDGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782707344; x=1783312144; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sv6r/7ghxXIx8WE0gC8A58FpOd9N/PfzWMq25G3TlBA=;
        b=IiqDW7rWrFLogD2I8Z//83kuYngvNeMENjoMuKKR/BMt6co2nu82SFxwe71yZWFU0h
         t7SGI9KtyQg2JS3NC3pdFwdtGfr60mN8FgBATOaU377QEi/3tGGIaJkzUW6XtkzEwEBi
         nLjRS1pC4rFEHInd9SvSFGl82UgQQoY+05LO1tBsqJcfbfIyjQOEZOmnPcBpMBkuP4vn
         cWcJK+RsEle6/0h5I+Yrjfe6fFiDgcfYU6rOHVLS/qRSyIUbuLTUIEyVbBQ8lyfRAdHa
         lui1qqLrcf0DmD5vevW77syt7+ctCd8XSH+LNHJrT4wZUcnmQTrxSyF5KF5GqJWciJ6G
         xuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782707344; x=1783312144;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sv6r/7ghxXIx8WE0gC8A58FpOd9N/PfzWMq25G3TlBA=;
        b=Yc1QtisM53E1DyJouD68Psyf/zTdAjNDHxlpJFp5h7ZBUEx6+lXKGq3KGpV+7+CM+L
         XgYxHbLfuLzByj5/1FhcJjJiinTR//83bnAunxbLmF4pRwdgyPGiwxSjt8KyWOudAIg1
         RGzSVsvxAo3Rh3dg3IAilK8STLGhqbtVbErTYYQRnLJz5CeMoH0S/kdfbM16MVnyIlwv
         TYdEhUOTLlP/bKPslzjT/qly6xvcmPiFl+CqodqgYuVJpCCkRXIp4KKi6LtqsTsTBsuc
         kcwOLihXH7AumhfxLe2JhlpzDrwPt/Hak8trJICaHyfXKXK69tWNLGeQD77rDh0A/+G7
         Pqig==
X-Forwarded-Encrypted: i=1; AFNElJ+hLHT/K7AV6xfEHXh+0e0svPRx4a6qvi4TS0m6S+JKbhjR1DRGY7LYOSrqV69cyB9URtboAfAZrQ==@kvack.org
X-Gm-Message-State: AOJu0YwE+FKiLF8ccDwkSQShLHVUe/XWnGt7/Jn8GHu4V3uc9n5Ix92a
	cKI/a0X3rF1I2Ka5xJerPCgZ4DnieXy7CSo5QouFmjqGN+EJ5ANFqCpjuI9cqJjQyQWMAy/wzon
	4uRrkTuMFfNn4dNZYdzcgzJVVw852JT/K8pXoVW4e
X-Gm-Gg: AfdE7cngImotd5i7T7y+OWl0zpLMkCcgYGnXuPyJwffw1R4DNURUV9Hg60ktB5LXgm7
	2Q9PJbWpogUsBdS2LGCsM7gQISZBEfSSOQQoIQcqJ8HPvFn4rny2uL9G+kuwoxV8Z6zJ+9QsIeR
	EtkCYEgwB51ArXBf4CtSTwArEHlJUQK95EL2So9WZ2fA2chB32v1bBEuXQ0QSC8HQJOqWsHst+t
	NzxJxL4BliZUf5KnRUDY2e0/8OhEuGwjnFZJTk2ZPbLrBNjv99C3M4hWcOkLmvzapAsB9s=
X-Received: by 2002:a05:622a:550:b0:516:4f62:85eb with SMTP id
 d75a77b69052e-51a8f786868mr16304981cf.22.1782707343313; Sun, 28 Jun 2026
 21:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org> <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org> <akCJRTnmA2um3CIy@linux.dev>
 <akCSftF6mrsKsz1V@linux.dev> <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org> <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
In-Reply-To: <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 28 Jun 2026 21:28:51 -0700
X-Gm-Features: AVVi8CfJ6F2zxzpsySpsDlZXuUkyQdUzk_WDTAbOh5lKS3BWh5mnFAWsjkfimrA
Message-ID: <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCFAD40003
X-Rspam-User: 
X-Stat-Signature: 67zpn1ebh6c779yqkwd78bhr7kaw6cgx
X-HE-Tag: 1782707344-389616
X-HE-Meta: U2FsdGVkX1/k/8MYMTaFcHojbubaxdy1I04zIU/TbCHtkHbozRrs/dpWIf26k1Z1siE6SAcjmpD9bTvxypGPXOHYdxiV41gR5AchhKiBPCWZVIcLazkPEliY4Xq4zBDgjSFJpjL358LlgkY91gHL8O+6z1oLZ42jkLqW2y2tY+dKoVQvSjtt6ibweTSb2kU4UU0Kxe58U9QNvIqv68kUzCAw9nHKsjAbdrFhMYczZP/wX0NcUFuPq7inmcvC8Ye8BY5zbji79RQUK511fDv/QKmBh4j0BgPbfXz0wy0gKW0WmFX849blJ79QbooihkQy2fxs4L8BCpLPlBJX1dfZtNmsCKh71NBJnHwyq1f3SuOLZn+FBYrl8TXyJcZefHsfhKcYBvvxk8O6lLlj8o2cCl5GdChvo4mcsSeUHFnJBCDk3b+UqIC+XdNt1KOBG1AC4BVWgMa/hw4FbZARxceamnfPXBKatqh6Cwi8tCe8zAgpreA8Hfx+vC02uqEP9ocfoWn7PD7hUgevoPizOqj5dxHvid2F+m2P2Y42q62+NU3mRrPdtZXvC7duJDM4OCDy4x+yaLGPfEVPdOneHXe3hJTDTYnujHPtwt9Qg+3iUQpyKhns6Zq3DNnT4mLMwYwG8zjc/xaEXEoQ5IzjP06EC3hwaNiapdKiWg/XLa6KNyAM55G5WGKb1DH716lgqg3IH9PM4nFkm1PwJI7L4AIrAWpPj744XjyfJ6hrH6TiyL/SSv+NnPeMensis/3Ex6EUyW5j69guKTOOOUbJuzFGqNg7rujJ+HE7a8igzdV2jBQObMO5TaN0ylbU6GytKPQ7O2sXFx4nJ5MmSf6CYe8sNZN080/EjzC61f2ek/A42QSWgwXAw49tMPpjyhzZWFbksp43RUHFkUVnK4gBOpYJNa9fVTcUPmE2/4uRbHoI2c+0257jOPuKrL/F0YtM/MoDg5xI25PNLshbbp4W5iq
 N+LLzHCJ
 ihQj1uz10VjCmuHy90HkWcMXPsX+Y9jCGnf6YARlehgqm0v/lxc/O6gjK7zLvb8Gh0r+SfOhhcz4eh09C63R9ilR3+xNJGdx96ONCyFAnflH1pkpc5WTK+ftFsQySunhe9yVHlGsWO1iuJsw0eJH0xQ20YwZTQ50ak5Z4ltbnE50NV5ysqLwnSx64c2zB8yTuDUl72PE3aBqRz/akXBB8WzUuEd7nbsDvP+VNjB5FhCKmIBaFPST0rggjyUZDgof62h98vOS1Nh1nUIW108H5TQ1SwvrOjmpD7bmJhFlTmdVMd+wPUbHNnZkIsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 8:57=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote:
>
>
> [ Adding Kees Cook for SLAB_BUCKETS conversation ]
>
> The thread:
> https://lore.kernel.org/linux-mm/20260625230029.703750-1-shakeel.butt@lin=
ux.dev/
>
> On 6/29/26 8:37 AM, Suren Baghdasaryan wrote:
> > On Sun, Jun 28, 2026 at 2:22=E2=80=AFAM Harry Yoo <harry@kernel.org> wr=
ote:
> >> On 6/28/26 4:47 PM, Vlastimil Babka (SUSE) wrote:
> >>> On 6/28/26 5:23 AM, Shakeel Butt wrote:
> >>>> On Sat, Jun 27, 2026 at 07:58:12PM -0700, Shakeel Butt wrote:
> >>>>> On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wr=
ote:
> >>>>> [...]
> >>>>>>>>> Fix it structurally by removing cycles of every shape: serve th=
e array
> >>>>>>>>> from a cache strictly larger than the one it describes whenever=
 it would
> >>>>>>>>> otherwise come from the same or a smaller cache.  Every referen=
ce edge
> >>>>>>>>> then points from a smaller to a larger cache (here kmalloc-1k's=
 array
> >>>>>>>>> moves to kmalloc-2k), so the relation is a DAG and cannot conta=
in a cycle.
> >>>>>>>>
> >>>>>>>> This will fix the problem.
> >>>>>>>>
> >>>>>>>> But this will waste memory as we need smaller obj_exts array
> >>>>>>>> as the size gets larger.
> >>>>>>>>
> >>>>>>>> We should probably create a new kmalloc type to avoid cycles ins=
tead?
> >>>>>>>> (needed only when memory profiling is enabled, though)
> >>>>>>>>
> >>>>>>>> That would also prevent recursion even further.
> >>>>>>>
> >>>>>>> Yes but I assume that would add kmem caches even for users not us=
ing memory
> >>>>>>> profiling. Anyways, I think that is a separate discussion. Am I u=
nderstanding
> >>>>>>> correctly that you don't have any concerns with this approach?
> >>>>>>
> >>>>>> Umm, the memory waste is a concern?
> >>>>>>
> >>>>>> Minimally I'd now want to only do that size bumping when allocatio=
n
> >>>>>> profiling is enabled. Ideally that means both configured in and no=
t booted
> >>>>>> with "never".
> >>>>>>
> >>>>>> We probably should have done that already in 280ea9c3154b2. Becaus=
e AFAIU
> >>>>>> memcg-only obj_exts array don't have this issue (or maybe they do =
have the
> >>>>>> [1] issue? Harry?). But if memcg-only should keep avoiding the sam=
e size
> >>>>>> bucket, it can keep what it was doing and only memalloc profiling =
would do
> >>>>>> the strictly larger thing.
> >>>>>
> >>>>> memcg should not have this issue as normal kmalloc caches do not se=
rve memcg
> >>>>> charged objects.
> >>>>
> >>>> I am wrong here as I went back and see d8df600b67d7.
> >>
> >> I was confused too :)
> >>
> >>> (8dafa9f5900c upstream)
> >>>
> >>>>>
> >>>>> So here we can do dedicated caches as Harry suggested or make this =
size bumping
> >>>>> very specialized as Vlastimil suggested. What do we want long term?=
 Orthogonally
> >>>
> >>> Maybe long term we make kmem_buckets unconditional and use that.
> >>>
> >>>>> we do want this fix to be backported easily to older stable kernels=
. I will see
> >>>>> how does this narrowed down size bumping looks like.
> >>>>>
> >>>>
> >>>> BTW I think we need something like the following, right?
> >>>>
> >>>>      if (mem_alloc_profiling_enabled()) {
> >>>>              if (obj_exts_cache->object_size <=3D s->object_size)
> >>>>                      return s->object_size + 1;
> >>>>      } else {
> >>>>              if (obj_exts_cache->object_size =3D=3D s->object_size)
> >>>>                      return s->object_size + 1;
> >>>>      }
> >>
> >> We should not add mem_alloc_profiling_enabled() check because,
> >> then we're not fixing this issue on SLUB_TINY, when the caller specifi=
es
> >> __GFP_RECLAIMABLE|__GFP_ACCOUNT without memory allocation profiling.
> >>
> >> `if (!is_kmalloc_normal(s))` check already bails out when it doesn't
> >> need to bump the size.
> >>
> >> So Shakeel's original code will work fine.
> >>
> >> We're only pessimizing memory allocation profiling and
> >> SLUB_TINY && MEMCG users, but (as Vlastimil suggests off-list)
> >> it wouldn't make much sense to enable MEMCG on memory restricted syste=
ms
> >> anyway. (IIRC even raspberry pis don't enable the memory controller by
> >> default...)
> >>
> >> I think it's okay to fix the bug first, but we need to address
> >> the memory wastage issue sooner or later if companies (Meta and
> >> Google I guess?) are deploying kernels with memory allocation profilin=
g
> >> on in production systems.
> >
> > Sorry for the delay folks. I just got a chance to read through this thr=
ead.
>
> Hi Suren, no worries!
>
> > I think adding a new KMALLOC_TYPE would be the cleanest way to fix
> > this recursion problem once and for all. This size bumping and the
> > special case of SLUB_TINY are quite confusing.
>
> As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
> infrastructure would be more straightforward than new KMALLOC_TYPE
> because (I think) the kmalloc type is decided purely based on GFP
> flags and we need to somehow work around that. SLAB_BUCKETS provides
> a nice abstraction to do this.
>
> Luckily, SLAB_BUCKETS is introduced in v6.11.
> Unfortunately, SLAB_BUCKETS is optional.
>
> > We could define that> new KMALLOC_TYPE only if memory allocation profil=
ing or SLUB_TINY are
> > enabled to avoid new caches when not needed. Does not seem too complex
> > but maybe I'm missing something? WDYT?
>
> I think we need some enhancements to achieve that with SLAB_BUCKETS
>
> 1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
>    (w/ SLAB_BUCKETS being a transitional config for _HARDENING)
>
> 2. Make the SLAB_BUCKETS infrastructure unconditional,
>    but the decision is made at runtime:
>
>    1) actually creating a kmem_buckets vs.
>    2) falling back to kmalloc.
>
> 3. kmem_buckets_create() creates kmem_buckets only when
>    SLAB_BUCKETS_HARDENING is enabled.
>
> 4. SLUB decides (not) to create kmem_buckets for internal use
>    during the boot process. Use the kmem_buckets for obj_exts
>    array allocation.
>
> Side note: this would unconditionally add the kmem_buckets parameter to
> the kmalloc slowpath. Probably it'd be worth introducing a dedicated
> entrypoint for kmem_buckets instead.

Yeah, this sounds quite complex. Maybe we could use the new
kmalloc_flags() introduced by Vlastimil in [1] to avoid using GFP
flags to indicate that we want to use this new KMALLOC_TYPE? That
seems simpler, though it's not backportable because kmalloc_flags() is
brand new.

[1] https://lore.kernel.org/all/20260615-slab_alloc_flags-v3-0-ce1146d140fb=
@kernel.org/

>
> > If it is more complex than I imaging then I'm fine with Shakeel's
> > approach as a temporary fix.
>
> Since above requires quite some changes, I'd say let's proeed with
> the fix (since it's one line of code change that fixes a bug),
> and then see how we can make SLAB_BUCKETS changes as minimal
> as possible for backporting?

I was thinking Shakeel's approach for backports and
kmalloc_flags()+KMALLOC_TYPE going forward. Just throwing this as an
option. I haven't looked closely into SLAB_BUCKETS yet, so that might
be indeed a better direction.

>
> --
> Cheers,
> Harry / Hyeonggon

