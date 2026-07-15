Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4B3C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8833A6B0088; Wed, 15 Jul 2026 12:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BA86B008A; Wed, 15 Jul 2026 12:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772C36B0092; Wed, 15 Jul 2026 12:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC2C6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:26:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA6251C0160
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:26:12 +0000 (UTC)
X-FDA: 84991538184.17.9C976AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6A5FC000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:26:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSbTbhtn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dd9XYmJa91i3eHqCaDt/pfCx2M1RLfbCHPrhn8OTm3g=;
	b=ibv/5QaPI081aS3s58UI6OeT7ej4cey6VgnGl26RmK8qvu2typdAja4aa8/qlar1wFcojX
	Tt+ZzxiAH8rrefPiz8RDt7mZBQ9vnIaNsnZSg75v7NBnBq1BtAFNTD0DLcPq9FT4rNSUuA
	KxKEdO0lWfGlHi1HG+TGLBwUBXiztQc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSbTbhtn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784132771;
	b=wMsRSzcyUN9MM9GreL/WeGdd0LzTRMmTENqWYiB91Le0bh62MnKf/XTH09+XF3X/taD7F8
	rD0VlUBvBB5BMn6piwD0Ps09O+lyfL2A/fWKD5HGflnfdixXZmuTbX/gmY359KCJT8++o0
	5IekekW1dA6nGvAbz2W+NdiixMpeKUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72944325E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0021F00A3A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132769;
	bh=dd9XYmJa91i3eHqCaDt/pfCx2M1RLfbCHPrhn8OTm3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VSbTbhtn7fpK0+soZOL9sgblFUi1zKSEfeoi8Q9LQU9aCvgJghHuO1dXiRbeWX4B8
	 MdrOvpHtK3SdCjpFz2/siP6ZzgpwleA/YO2s8N9dPAEWuHtSZYkbJa5xioM8vJM3oH
	 f44bjwuTHYNPYHcXO/DvTPWqif+MJWs/9C8UvIpk3NfAv1spweRUNYlly61ftzMylr
	 43jivSpUCF8WZul+/VCfNJELtWZecKFUrrJ3nmUiwBIhvXSqKi1hBTl8c2eag0vhDX
	 VwzYkOAJHa/o3pqaKierR7F/pmt6s7m4b/HjrMXxmxyfowHKmKWk71tpnJxNw/Wruk
	 HjMgbybdE3Tkw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c160420289bso766978066b.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:26:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrSpiMTZMT+0t8SBiwnV11JZqMmlL7Feybu7YBz+vi1f4wNN0yGrjdrvYjKkXtiQoVjdvfnJknEXw==@kvack.org
X-Gm-Message-State: AOJu0Yyygm2JyUqw5PjRZVoz4DZvEtgJdX+P701/8aPga8CMrQeqN4oS
	xkdGxAMJVqyd8CKZdJjjasUKoCccrH1ngLQ6hfZFl9pj7ZrqiS0rR8k+cw/R1hyKrIzylFaymck
	1nEp1s77fCM42+Dne2lmPqCu1o7LXUkM=
X-Received: by 2002:a17:907:c19:b0:c16:f32:6ca3 with SMTP id
 a640c23a62f3a-c1667b3767cmr424280366b.46.1784132768582; Wed, 15 Jul 2026
 09:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev> <alcebHobUCUyO70k@yjaykim-PowerEdge-T330>
In-Reply-To: <alcebHobUCUyO70k@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 15 Jul 2026 09:25:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM+PNf-r4ToVQn_vMJfozN9ow6qCG_0WVfh9TWdxmdzrw@mail.gmail.com>
X-Gm-Features: AUfX_myoQfmUvN8TiC3tXP59YsSu6CWZLautLR1tX1O8JZHdTCD8HIK9MKOgOsU
Message-ID: <CAO9r8zM+PNf-r4ToVQn_vMJfozN9ow6qCG_0WVfh9TWdxmdzrw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6A5FC000F
X-Stat-Signature: yiho5i84jqpj3sh9r4q5nyyr5r17jnqd
X-Rspam-User: 
X-HE-Tag: 1784132770-804547
X-HE-Meta: U2FsdGVkX1+sCUner0EtDlVbxsym4a0kK5ktsMvxszMdme5nwOAAUhl2NdPAAq9/Txf38cCGEhlzRvTga0SswLiJSy5e230v1Zz4QN/VHyOgHTrZT4XA0H0jxCiLMw4I2PqYRM2L/WpMhxpv7ytf8MFxzQweERHMfeAh54vDrM7kWVojhBeg5FqEzIJv5wep6vaBjXJs5ApoF+n6FrDOd9eA0hMMVkb3XjOtAdVhVIUIzremZuhOc7sas5Zp8CL3Yuift1AEMpD+bKitt0kJTBD1RbTdKhUgOl2Hx4ok4oqkh4wA8KZJ3hrjwOv/jeEk2Up0Qg6IrJMwnvfRLQb0TZdJKg9wV1DXuGxRQlpIqYiXBsPELunx7i15MG1d18b9gYoUgPI19y26JUBQrdCqxent3f0s7ACSYhOwiqJv6TUCGiQMB9JFrb3TsGXB/aP4yQLEtJ2Oip6JPk54EA7eqoUz/12foP7ixu0bOvsMqipoaVVxCGeR2mYD5FrbO9agS19Yv1OjBe69hA8Sf1ca3ftInKZHmfG53d+M01SpewMzWSRS94OA5iYyQeks2In8PZnzPiX+x8P5BPk1EWP+DlMHJMlHK9u2IJBC8AfA405ZIuP4AGsYw/hh7ECwWwAghZPhXLo81wHBRziReGbENNi/Kfdw5A46EyKAH54+ij+gJ6lWbRBlUVq4jlpzTPtO2fULtkPCFhX8X9/muZNh6hS0p2SXgx+D5ptl+8MNsz//nlcB7Jdei29t9/LAwZoxq7NYb+zLlprY9KS7TpnulzTFkUf97igO1y8FJPRnwBiUAfVbTdftvsAmduh5Cm0BTuWJqpPTwXgMABx6k2Az3futRYxBvNyeQZBwGKd3Io31SCAoqYrg1xAQ4YgXJxIwd5xpd1W1CZBPKKn5Sw9P4lVcP/zkpugxv5sLa6ZaJrU/lsY/aAXrU4cWIMPNgibEyui4qNj0AHr+GJdcR0O
 Y8IuXtOP
 i9g8OAMMg7Dud2gvJ09GgP+bd2AqSC92h7W3NTGmFro91SWR+QuRR/9nyJWQ0PaCb/VyI5zRPAPM0HjoRBbK5HauYqN8zcIpRo8VceLHP3MjeaukkJ8ebhizruHocUVPU0rquPIacpPZYPgqBe1ebwBaUz53DDI4yyWIePxWcXd4HRaM7zTtd64abns0L3r4n1EPxxNqf+R00UXtsLIJh3d/n8s7BlJfGErQo+sttso2lam3UvzS/38JYdVxXsp2EFjA5XcQCkAbaOsDuke3F/+1VL4njLf2qRQhqkxhN2KoCl+sMs9utl0qDdiGEaQr2Jxmih7iaZb2uCmwbUHlB8cMyF7LaHRBCWgp9+kE2pU7b2Cxgsz6YVPoCWSzWcwWXyDyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:45=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Tue, Jul 14, 2026 at 01:44:28PM -0700, Shakeel Butt wrote:
> > Hi Youngjun,
> >
> > Thanks for keep pushing this effort.
>
> Hi Shakeel
> Huge thanks again for suggestion.
>
> > > Right, that's the plan.
> > >
> > > > but I would check all
> > > > user-visible behaviors related to zswap (e.g. interaction with othe=
r
> > > > zswap interfaces) to make sure nothing breaks or changes in a
> > > > meaningful way when zswap is introduced as a tier later.
>
> At now, the answer is there are nothing breaks or changes as a first revi=
ew.
> I think it'll be better to introduce zswap tier after this patch.
> (Details are going on the below)
>
> > > Fair point. Let me review this more and get back to you!
> >
> > Please do report back what you find.
> >
> > Yosry, what is needed to enable zswap as a swap tier? What will be the =
minimum
> > requirements for that? If that is not too much, we can make that part o=
f this
> > series.
> >
> > Shakeel
>
> I tried to verify what changes once the zswap tier is introduced.
> Please correct me if I'm wrong!
>
> First observation: before the zswap tier is introduced, some of this
> is already possible today:
>
>   - a "zswap-only" tier equivalent on cgroup: memory.zswap.writeback =3D =
0
>   - disabling zswap entirely on cgroup: memory.zswap.max =3D 0
>   - disabling swap (and zswap) entirely on cgroup: memory.swap.max =3D 0
>
> Given that, my take is that introducing the tier concept itself
> doesn't change any user-visible zswap behavior, since on/off control
> for the zswap tier is basically already possible today through other
> knobs. So this isn't really a user-facing problem; it's more
> something we need to think through carefully in the patch that
> introduces the tier concept itself. That's what the points below are
> about.
>
> The cgroup interface knobs and the zswap-global knobs need a
> different kind of review, so let's start with the global ones. The
> zswap-global knobs (compressor, max_pool_percent,
> accept_threshold_percent, shrinker_enabled) look fine with tiers.
> They're zswap-internal tuning, orthogonal to the tier concept, so
> tiers shouldn't change their behavior. The remaining one, "enabled",
> does overlap in spirit with the tier on/off knob: enabled =3D false is
> basically the same as disabling zswap for every cgroup. But like the
> other overlaps below, this doesn't look like a real problem.

Agreed, I don't think there's a problem there.

>
> The part that needs more thought is the overlap between
> memory.zswap.max / memory.zswap.writeback, memory.swap.max, and the
> new tier on/off knob. Since all of the above is already possible
> today, adding a tier on top means we should make sure it doesn't
> create confusing overlap.
>
> 1) memory.swap.max vs. tier on/off
>
>    memory.swap.max =3D 0 disables swap (and zswap) entirely, and
>    memory.swap.max =3D max leaves everything enabled, so one knob can
>    make the other a no-op. I don't think this is confusing in
>    practice; they're just two independent ways to reach the same end
>    state.
>
>    Conceptually, the tier knob controls on/off/auto-scale, while
>    memory.swap.max controls pure quantity, so they cover different
>    concerns and can coexist. Even if the tier knob later takes a
>    numeric value, that number would apply per tier, while swap.max is
>    a total budget that doesn't care how the tiers split it up, so
>    they still shouldn't step on each other.

The memory.swap.max interaction with tier on/off would be the same as
memory.max with memory tiers AFAICT. We just need to make sure we
remain consistent.

> 2) memory.zswap.max vs. zswap tier on/off
>
>    memory.zswap.max =3D 0 looks semantically equivalent to turning the
>    zswap tier off. Could memory.zswap.max simply be folded into
>    memory.<zswap_tier_name>.max?
>
>    Yosry pointed out:
>
>    > > memory.zswap.max integrates naturally (it's
>    > > memory.<tier_name>.max).
>    > Not really. memory.zswap.max is in terms of memory usage
>    > (compressed size), not swap usage (uncompressed size).
>
>    I'm not sure where the tier limit would actually apply here: is it
>    checked in zswap_store() against the pre-compression size, while
>    memory.zswap.max keeps tracking the compressed size?

As the tier limit can only be 0 or max for now, I don't think this is
a problem. zswap_store() would just check that the tier is not
disabled.

>    If so, once you give the tier limit a number, wouldn't its usage end u=
p
>    meaning basically the same thing as memory.zswap.max?

If we allow values other than 0/max, I think for zswap that would be
the limit on the uncompressed size to remain consistent with other
swap tiers. So it would be different from memory.zswap.max.

> For limit =3D 0 the two already look identical to me (both just block zsw=
ap
>    usage). I'd like to understand what benefit a non-zero tier limit
>    (uncompressed) gives us over the existing memory.zswap.max
>    (compressed), once tiers exist. Let me know if I'm missing
>    something here.

Yeah limit=3D0 and limit=3Dmax would behave similarly for both. If we do
support other limits, the meaning would be different. Since most usage
of zswap.max is either setting it to 0/max, we can check if we can
deprecate that interface once we add zswap as a tier.

>    Also note the mixed states this creates:
>
>      - memory.zswap.max has room, but the tier is off, so zswap can't
>        be used.
>      - memory.zswap.max =3D 0, but the tier is on, so zswap still can't
>        be used.
>
>    Both knobs can independently block zswap usage, which seems worth
>    flagging even if it's not harmful by itself.
>
>    On top of that, the tier knob is likely to stay on/off/auto-scale
>    without a numeric limit, while memory.zswap.max only handles the
>    numeric side, so the two should coexist as is. If the tier ever
>    gains its own numeric limit, we'd need to revisit unifying it with
>    memory.zswap.max.
>
> 3) memory.zswap.writeback vs. a "zswap-only" tier
>
>    memory.zswap.writeback =3D 0 can act like a zswap-only tier today,
>    because zswap still borrows a slot from the real swap device to
>    store data; writeback =3D 0 just skips writing that data out to the
>    device . A tier restriction works differently: it applies at
>    allocation time, so a zswap-only tier would block allocating any
>    slot from another device. Since zswap currently depends on that
>    very slot to store anything, this would break zswap instead of
>    giving us a working zswap-only mode, so the tier restriction can't
>    substitute for memory.zswap.writeback here.

Yes, the semantics of zswap.writeback would be different than using
zswap as the only tier, but we shouldn't allow zswap as the only tier
anyway as I mentioned.

>    With vswap, this changes: tier off and writeback =3D 0 converge to
>    the same effect(right now the pure zswap only tier),

Yes.

>    since zswap no longer needs to borrow a slot from
>    another device. Even so, memory.zswap.writeback still needs to
>    stay, since vswap itself can be disabled at compile time or
>    runtime, and we'd still need a way to express zswap-only behavior
>    without it. I'd like to unify the two eventually, but for now they
>    have to stay separate. I'll keep thinking about it.

The goal is to eventually make zswap depend on vswap. Once we have
that, we can deprecate zswap.writeback in favor of the tiering
interface.

>
> How do you think?
>
> thanks
> Youngjun

