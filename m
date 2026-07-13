Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95FAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A3B6B0005; Mon, 13 Jul 2026 15:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB5B6B0088; Mon, 13 Jul 2026 15:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3EE6B008A; Mon, 13 Jul 2026 15:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65A496B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:39:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0786140160
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:39:21 +0000 (UTC)
X-FDA: 84984767322.29.931B28C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D673C1C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:39:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/PuvFj3";
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783971558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qg6ZVGkGjyzsXwLwsor5+2jsXCyFbMN9y/cRQoYhLtY=;
	b=a9zeRmTOw/V2JN3fgNCINSArzlIcV2TmY3wluI0IJhfCiIydUdOhvaBRLwjGe96SIzqNaK
	0wYNxDXfrpjnIt3c8Gn6BKd9lieArurnPUwkH9PBv4UF4h8vAw9dHJrJhRvEUuq6kTXKJ8
	VjQXaWuOp3wb1nSH3mh/PLpjqVCD0tw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/PuvFj3";
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783971558;
	b=pEjNrbG1VSco7cpYwyNEoi3dK+DtFmsmsbpXg2wKHWNC3pbrf/ZhY5+pKG92psni6tXohe
	6xbTKxLJAKnmIfDTb49JAT9bEYbz0LhS/xPi0K+5uJAsSnw0OJdjtuJ21c0d7FFKtEp4KF
	8zRKujCcMskHn7AePZTX1QNdBPh6aq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33FBA43779
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126381F01559
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783971551;
	bh=Qg6ZVGkGjyzsXwLwsor5+2jsXCyFbMN9y/cRQoYhLtY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g/PuvFj3WZN7SPxlaHiWKlnfQ34UKeItcZxTaK6qVuNhqKbTNxCBiShOJrEttmUbn
	 eZxdia9ZVKdnmKze/ul6I59Plp9kOdzkNDOy/wWI92DF+EIrCZC2+hLe+mn3IYQdHp
	 PdKC/nPNbxt0aQAyMJWLaZi+0WP8+W0B8qbiEqO+5Z7B1JWfBS1Lm9nPfronv6GKDc
	 dSOX/OqeRhPNiLL3EzGhyL40ZwhMFL/XeZuVDBztrK/+izCcGWzuPCh22uqoOrVp9B
	 PYihbGK7+x9mC1O+T0pqOYb9s8a9Zz/AZJdHKfhTaEOikT9MiFplOK8ylVtsR9Eqq1
	 GIZCMAtMr5sRg==
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-664d22d7337so482836d50.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:39:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro1zx0vhY3I+X93IOTK5Hz+zrD3ixrddbS3os94C9pcG1E1bOrmHGwH4gumsQ8sFatYpPGP1oCs1Q==@kvack.org
X-Gm-Message-State: AOJu0Yz2xAqbpWT2s9i2rv90HN1Z/6Wcl2c8au3TjAGIbxJTtezBQXhy
	1vKusuqODMuNQnkbyQWUUNxqH863K3htNqcWz+PTHkUUA+fPKcpm6RUWlRStXoYu7DpfGthJO8D
	ilmrG7EdEpqjGYVBeyW3aThzG0XgKVKxpWr8cqXApqg==
X-Received: by 2002:a05:690e:108a:20b0:667:538a:ddeb with SMTP id
 956f58d0204a3-667d98ec4b4mr5287705d50.31.1783971550390; Mon, 13 Jul 2026
 12:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
 <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
 <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com> <CAO9r8zO4uW=SX7se154Z6+DrxfawZfAiRO6Ar5rUm3T78x5HUw@mail.gmail.com>
In-Reply-To: <CAO9r8zO4uW=SX7se154Z6+DrxfawZfAiRO6Ar5rUm3T78x5HUw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 12:38:57 -0700
X-Gmail-Original-Message-ID: <CACePvbX5oWcTRpQeBCQsod5C5KEhd-0vA4B1PGYddNfgTW2tvA@mail.gmail.com>
X-Gm-Features: AVVi8Cfs2jnetf2lNr53IOa2b-MdHz_D4--892kNI-Xqp57Fk6NyE7rf5COXhGg
Message-ID: <CACePvbX5oWcTRpQeBCQsod5C5KEhd-0vA4B1PGYddNfgTW2tvA@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D673C1C0005
X-Stat-Signature: ur4cpzg5brs163cjfns1rrqcde9gi9qz
X-HE-Tag: 1783971556-536262
X-HE-Meta: U2FsdGVkX19QLsxeJvtPqnVfw+/SIqQrTW/KZmn3z3QbcxC11p7oGadNv5tByIz8kqrf8UdU0NrRq4e5WHut04A0U9v5jJjNklo70pxfdonT+ENKPxl/H/RZSgg4eWImRDNi55wFLApzVr80y85KoMcp30+mgXhyObEimH3AIIOf1xylLb7J+G65G4M+Yph9BC9rMgLOQ5O4aBzgBtl2U4ke2gmob9yfYl3ggDW0jsobBlAwS+n1FpmeaQthwD/l+aCSK5wPMckPz9SD8BIxsCmsSanAj4d7hc7Pd9ZCOVzDU1wRH7hpnU6mkZ0z4xWqdcik7um6gPlN/qG78uU3XLwYl3Z9UWNvfhzlaMwwFvyoRZQe8ZSidi7EinVTo9hHVqLIcnIiw18asgIA5pu2QQz3BqOgt90G7pLCuilZ+AfalW4qD3noH1aww6gndNR4fpsogZqvGM7mqt9cafguFfn+sLypFVhooe8tleafYPbHxtden3X4qoRqRqcYgzfsrZ7TdY0LnjIeANDKlXXSnmNE7tlUfB66TT6IK9kX70m3gKITKFT65OpHeYBNAMlR8tMOZcaqPxhoxp468/7L8Wb+v7mX1OeFPyHIsSin3k+9Zng59sDQdl/UsNkP+/bpaIanu7UfxYSLt/5/xx0FdALjIa1xg+hUIkAUccheooI3gO6ANi1M3ikJNOGR2s+OJkE32FJVWMeXY77hxDrxfdlwzsoWiaoJ/FId4KGhGUiZviL/LJan1F9ZxuoDY6XvH6LTsmwSFdY46uFcwvakZBy4Jz8UUCuPVIACo4NNeel79NqE33IUH1ef5IZMGvpCc2aScx/gMKKzryq3vwdhbmDUW10ns0O0iXoIHn0XHo1hMWM1jFp+b/P/HMZOJmC7Dpq7+WVYoO9+keEQi3xgABV/ojTkiEA7+CmKmJjCOJc9J+YivHcLep3qLHM3xT8o+HvQixzs+uxULmK45+Z
 aDofvv1L
 4xA+b/DLIPFUz7+EMRTCRFXSdA9v0GvHySak0X2avvGW3RUbJOr0IOivev75tm9M0W1TVZEVGHky6AepNT78fQaixmOROowSEkMgRLq4sIhKom8hZQ0itghVayknahqB91pWsmz1pFUxB3bFNQtOKfzvU40QBS9bTZSSpd6VKz5oHynstI//5EauSbE0Y2cNHu38r4EbrV43/KOZ7L3Ve6L2cBdi0wTu0KSqElgSQEr6g9HLi5PcghNLjum9gSMId9lp0IL/VWyWWWiodmGWw/HNh/faLwnHTZvi5ClyEGgsExjfZjKFrswarnY2/gAtJs69o6pdMMGI/iI6Ulr3li/1UaS6sKv9enaLsQMSsq62poT1XlvJb3/x/nHnC4iEdBV90
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 11:38=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> > > > Zswap will not be introduced as a tier. The existing user interface
> > > > makes zswap not exactly compatible with the tier ordering because i=
t
> > > > sits in front of every swapfile. If we change that, we break the us=
er
> > > > interface. I suggest we keep zswap working as it is now.
> > >
> > > The goal from making zswap a swap tier is to have a single framework
> > > to configure swapping for a cgroup, instead of configuring zswap
> > > separately. Yes, zswap currently sits in front of all swap
> > > devices/tiers, but we are heading in the direction of changing that
> > > such that zswap is standalone, at which point it becomes more
> > > obviously a swap tier. If you want us to wait until that happens
> > > before adding zswap as a tier, I don't necessarily object, but I want
> > > to make sure that nothing will break if we add zswap as a tier later.
> >
> > I'm afraid your zswap user interface will have to break. I don't see a
> > way around breaking your zswap user interface to fit the swap tiering.
> > Once we move to the swap tier world, I don't think we should continue
> > using zswap.writeback to control the tier write back behavior. We will
> > need to rethink this new world.
>
> I wasn't talking about the existing zswap interfaces. I want to make
> sure that if we introduce tiering initially without zswap as a tier,
> then add zswap as a tier, the semantics of tiering and user-visible
> zswap behavior doesn't break.

No, the user visible part of zswap must break because zswap currently
sits in front of every swapfile.
I don't see any other way around it.

If you do know how zswap can interact with swap.tiers without breaking
the user interface, make a formal proposal and lay out all the
details. I did that exercise myself and I my conclusion is that it is
better to accept zswap is the classic behavior without burdening the
unified swap tier too much.

> That being said, the existing zswap interfaces don't have to break
> with tiering, why do they? We may end up with redundant interfaces,

Because zswap does not have its own swap device, it borrows the swap
slot from the underlying swap device. That behavior is unique to zswap
and none of the other swap tiers have that.

> which is unfortunate, and we can work to deprecate some of them over
> time. But I don't see why we have to break them?

I don't want to special case the zswap for from the swap tiers.

> > > An advantage of adding zswap as a tier right away is the proactive
> > > writeback use case. It naturally fits in the tiering framework as
> > > proactive demotion between swap tiers, which I expect may be useful i=
n
> > > non-zswap use cases as well. Without zswap as a tier, we'll have to
> > > use a different interface for proactive writeback, and then if/when
> > > zswap becomes a tier, we'll have multiple ways to do proactive
> > > writeback which isn't ideal.
> >
> > I am looking forward to abstracting a more common write back behavior
> > in the swap tier world. The classic zswap behavior will be preserved.
>
> Right, but this requires zswap being a tier, which you seem to be opposed=
 to :)

It does not need to as far as I can tell. People who want classic
zswap can use zswap as it is. I am thinking the swap ops provide some
interface for classic zswap to use, but zswap itself is not a tier
because it does not own swap devices.

Chris

