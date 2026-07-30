Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C95C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8AB6B0088; Thu, 30 Jul 2026 14:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359326B008C; Thu, 30 Jul 2026 14:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F286B0092; Thu, 30 Jul 2026 14:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04D6F6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:03:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A572FA0191
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:03:09 +0000 (UTC)
X-FDA: 85046214498.04.8F30047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id ACC8C1A000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:03:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QWH/7gUt";
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785434587;
	b=BLjgodIEJfg4m5WhfuiaftnhMbDCsP0wuyAuz3oTKAEkQv4drJClMWXLpQxN5xgyUjl8Ga
	w1HQP71HFK3TFHm3WNdeKJ+I+QkdUFvYz1/Q5E40o9yOGExMvqYGnJpQfNMGVauExLzL+S
	wBwULK4zrq4f/hAUVAXL7egULODXyXU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QWH/7gUt";
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785434587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uaWtblCQv/4DCdhc7jyYsoeQO3+YXZnfBpK3Ly+PEEA=;
	b=gSt7t3KuFg98KvnF0oAp/SPkaSYdIAipNaud+Vd/WxVWTWMegInKk6bLbBWG/wFWSm0Ns4
	gSwvn7z1cVJ/VFL4C47+C+9NkFUe8n6/k9I/8TdTObbWwjsNMfhjrVEs7Slmx5PooHQZTl
	VpYLv02GSKjFmsjLsLUgY0WbrwWOhbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6E5443E53
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ECB1F00A3A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785434586;
	bh=uaWtblCQv/4DCdhc7jyYsoeQO3+YXZnfBpK3Ly+PEEA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QWH/7gUtPVc6Cpxv27UYhzK9tvJNy1J9q5VhrVickDBsl+DyXd1bwNIyqVtr4Alao
	 LH5jI61q4yx9+UxisS4H/Ksrr6Gaw4EITazQb6OcIStxO9u+92dsP1etCGPtTtzkT4
	 O4oROwpSP3x8GSvcdFDzS1X2TG/VOVjY1sYOe5NB0eQgm5uJUfWlP3p8IBl/s67InG
	 38LR23VoLNXKuhcECoI8Qbw1Nbn1+bas76izYy4iTtN2HJqyjq73UoANipDda3SVfr
	 /LI3L+oEpmm+y+aPHXDNgC8jpIC0FupaH4GgbDoGlkoYkMC1qsVNFcxB4cyblfTmDy
	 AgniaTilN3Suw==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e65e18969so85605485a.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:03:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoqcSPMwmy6kE+fGsZ/SN4I4QUZgEsuds7WisRDSy4rQymJxx8qRVd0x9DS+Pr1pnNTYzmft02+HA==@kvack.org
X-Gm-Message-State: AOJu0Yynsgw2DTsqyUms99rK60jAZk7OTIOq9eVv2eOUPoHUZgKD1qOK
	2pyS4rLn3dlJ/kw8Q0s8Woa86V1TPTU1nXOG1DH98oEzY1eWWzCnNh3NnG83p8byIz0kb8SiAO/
	LJ0H5knAygN00qBRK8OchdsMxG2ULW2k=
X-Received: by 2002:a05:620a:8081:b0:92e:65d0:1cc4 with SMTP id
 af79cd13be357-9348e91c56dmr170609485a.30.1785434586093; Thu, 30 Jul 2026
 11:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com> <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
 <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
 <20260729181756.a37e0cc7ea3f6013959d1d25@linux-foundation.org>
 <CAO9r8zMPxdn=MOFD9mbrzed+C9HhOB5DpHG4QS0OJzqV_gLvsQ@mail.gmail.com> <20260730105952.7878a648c43c32b5e649d96d@linux-foundation.org>
In-Reply-To: <20260730105952.7878a648c43c32b5e649d96d@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 30 Jul 2026 11:02:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNnswXgnk6_1fXwvjyzdA3J7JNH4txau5y4AF1J8ODYkA@mail.gmail.com>
X-Gm-Features: AUfX_mzx67h0JEqZoctBWdcDXnKtJNhaTEhESBJ0YTmJdBBac9wda2yHtwtXuF4
Message-ID: <CAO9r8zNnswXgnk6_1fXwvjyzdA3J7JNH4txau5y4AF1J8ODYkA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ACC8C1A000F
X-Stat-Signature: 3i5c8qk9mur8qb3s8pbbcf41o7e7uwc7
X-Rspam-User: 
X-HE-Tag: 1785434587-485018
X-HE-Meta: U2FsdGVkX1+EyYqczr/UdQQfs8Ku8XJk3SzUmqBwZdm55V40lOp05XvnwqUSR7FlZ39W74SO/pC356AXRCmrHimjBTzQWEpWZ6OpyCPEg6Qm9ALw6YuXtAFdi4CiiO6KHmSntDNZlVkH7qHgXEvIeAeLhQ1lMAo6Q8Eyq5/i3swq82O3pt9xul3sn1QwDKqupIMNFClmhBxYAKqLcxg25GsFTZoZ5isfIeRicLjTzF4oHPbJqT3Sh6P5Zvune6X/UJQKQtotcAZ6BsM467Si78067mMP3g1oc/SXdEAZVKMZxQ8guFQQB1JrvPv6inHweGLlq2T5Vk1RHwoln0jxjIkeEZ0ctZph9gnTiWfb+sPyHs8RT3+uK0EvabyqNZpnn9Wa7YThk8N73n3IzWrOROF3K2Gl6w/WbIr9T4SZd3lFXzltMkyeh/theanLpY6eV5bJq+xhr6mM/5/bAY+QTnw4BYFeCWgL/Vcjk5dI0SCi+mJ9fTmHyKyzRLcz7gd5S7LaC5p15nbMcDGj8XLMhcIAwThqzi0rurM49w14OLejI2rJIrOruFOO7302EOxt6tbdPDlyCDN2mBaceJOeZo/+kRdh+fImZNW2iht3Q6VAGpX9BaPH8YcSd0HpUrGCK2N4MbWSWBOqOek2/gms9rlEqugBa02mCpVXXTKFnSLX5pU18Bn4osr1iIi+/Utz06DouWLGxuW67jWJ1VWlPbrJHPTFMgZeJ7JLsV9IxYXrh5m6VhRrPSZK8pauzn8TQzLj1c0JiULufxdpWufHMUVgoiQhjZhPCQeMbnubTLwKp903xxnks6FKCiS/4GZwRC9aO0sD+aMt7G4psPZquusNIQ2W12L5c77b//ABvpqruuEZHMhF5nDAS9q0jvTkkdIVfnK3KiSRK5uhs5rfj25G8I6nt7CCRjhkpAn6a8bPAqKA+Qli5WwU+7pEGE0b61wcF62Z8maYyGGn9GW
 4cIvh9ZK
 movuO/FtLUxSKMVQyDEN5+0Nng/SU9p25/Mo+/tzMNuROp7tHU9vjiWl15qBVqQV8p5jxgzPGiBPLsqVlRQnj30ANQCT5F73XDHVc0mo8BrQuiwrnn4p/SPYvJ4liWFpRYMNm8ixbrMZDsCeWv4LxujtfMs3DVOkDfszbnsBisRzuUjQNZg4z8nBHMSYzIpUD6o92PyFplePIh7TqaO8YqnVwb9jqxf8fjzEd07yY3F6mkrUTFE4mnDq5ib8892G1rl9HajUoKnS4WeeapB81A5OhwuZAi6is4VnBD3iK2NM1j5eu3OcWGpGGS0ifKEDD/nq/Qukmj4pHdnh14K/yu5A81sZ0D65eFLorIS61lZOc+lw4toR4Gg+bM+4+9+vktZFJ5KxWq/1Mrv/BN6qyklTlK2mW3s3ZettYiMnP/yyCt6cV+hrN7aNomhEW0XC2sjIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:59=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 30 Jul 2026 09:52:38 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > > >
> > > > > How does this affect users?  What behavior do they observe when i=
t
> > > > > occurs?
> > > >
> > > > I think the first paragraph sums it up pretty well, especially the
> > > > last sentence "hotter pages with higher fault latency".
> > >
> > > How do users observe that?
> > >
> > > See, what I'm looking for here is an explanation for why we're
> > > proposing a backport.  How are our users harmed by the current code a=
nd
> > > how does this change benefit them?
> >
> > It's a potential performance regression when using zswap with memcg
> > disabled. Sorry I just realized you were looking for a high level
> > description not detailed symptoms :)
>
> Are we able to guess how significant this is?  It should have
> significant impact to justify a backport.

It depends on the workload. I think a lot of workloads may not notice
tbh, I don't think it's common to use zswap without cgroups.

> Sorry to push - I'm forever trying to train people to describe the
> userspace-visible effects so we can make these backporting decisions!
>
> And to justify those decisions to -stable maintainers
>
> And so that someone who is experiencing a slowdown in some private
> kernel branch can look at the changelog and decide whether this might
> fix it for them.

I don't think it's super important to backport, but it is also
something that we broke at some point and the fix is straightforward
and simple, so imo the risk/reward function is leaning toward
backporting it just in case. That being said, I don't feel strongly.

