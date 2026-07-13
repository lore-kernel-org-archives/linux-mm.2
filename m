Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CE3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038676B0098; Mon, 13 Jul 2026 13:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0102A6B00F8; Mon, 13 Jul 2026 13:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20996B0098; Mon, 13 Jul 2026 13:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBB756B0098
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:11:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51FD41A010B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:11:22 +0000 (UTC)
X-FDA: 84984394404.20.17DD081
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 81546160006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:11:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTAxNtRp;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQTumPEp3B0RtOhDCU3UTQhcVFGvQqZPO4jEe1rP18g=;
	b=qSfilC2l1i+Cui2DjZnebbf8b5bb6o1Kzir1nhBTLZAhfO0rAF1WE+uq4MF65fQLVfZLu+
	uvifXiGoXG1EwXFldc6sbbz+wT0aiqfvfWVJRpavAyxxBPxCIfkuBDmxgABqzhum8kOR0a
	PsK7kMDQ479Xj2xXIh54DKLfymuDl6A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTAxNtRp;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962680;
	b=qNuknK7Wkc+tEqnzP2TkVn4QrKVGE9O/kiYkG5cuXY2blkkYOjgsyL7H9RA3btrccEQEDf
	hjdOe3nXW3Cg9ixdVzqv3WQQeFwket7qhWSUnQ1YiectGZE2JqXkt4bqFgzQWOV0Cw3fih
	CjZrL9VUdkzVRzmJs/9NG2bgrkhe8MI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E51EA601DE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A88C1F00ADB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783962679;
	bh=BQTumPEp3B0RtOhDCU3UTQhcVFGvQqZPO4jEe1rP18g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DTAxNtRpb76h9S+rgALQP2b3SFjAnlNDGGE/2/KHiNt77ON78wFh6jWgO4RGJ8niO
	 v32AJz7e6z9/Uam+m3OY7S2cWzQOmtRiqduWaXCZuv5N00QCr1vaaDFv3txENjjeGN
	 ZJWm1VIw2zaySLdQLSk+8u/RfF79mDGR8u5MD86vszYQFIZ4IUw7Lvw7deKAR2VpgD
	 bMUuX0pRlW+A5SPNqCP6nEeINSa0OfCe0S6sIY9yD5ryqfW8pC0d2FDmeJvOQenF2Z
	 LVJeagIKJW2w8Nuy8aRkauoS/5/nbjmJtjltWtoNMiAu4g/0N9uBFKlQPKu4uRY/rM
	 PPHV+N2Jwe4fA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15ba5b151dso20385466b.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:11:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpqlPYHCInGio91W7rxgmvgkP3l2M4TzlE2+eAV6eEGgxtxR1YobkzUpZ6i3hMKyvGBTh5wLGjIHw==@kvack.org
X-Gm-Message-State: AOJu0Yw9UmIx/RSx/xbWEin1LeX8660mshyTwI2jmYeTIXnmStRSxKm8
	6E6cFYNh4gWHexk2q4sRw7vdKBhGf9iIQINrlSFt+qZktjMELuHctDrMRqjWHHedGK6cBDfNgj/
	qZjFcSIkpNb44Dy//UU1crmPYOQrDBQk=
X-Received: by 2002:a17:907:a785:b0:bed:9a7:5ed1 with SMTP id
 a640c23a62f3a-c161e956b92mr398059166b.5.1783962678493; Mon, 13 Jul 2026
 10:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
In-Reply-To: <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 10:11:06 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
X-Gm-Features: AVVi8CcAg9n2PdlNTHyoGC1oIxbThm2NtEI-8VIlrgHUzA8UGuYNTJ-1-2Xqom4
Message-ID: <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Chris Li <chrisl@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 81546160006
X-Stat-Signature: di8ajoakieaehhoueg59fgfqyubtqny7
X-HE-Tag: 1783962680-741292
X-HE-Meta: U2FsdGVkX18htlezjROoM5TdmyKiVW/hCsC44JHY6r2b7YHkcCYx1QQbS2VUqLjGiMv2u5ksmNkibrjRaLMGxIeXHQ/k4//FTnvDtecR366V/p29dRvly8xvhDKR8CNNNDbKBJfqhpXLGrtmzesQP3kcvKwQh9dQ1YnoKSetMQAFQplBzJ3w3/aol6+gquAkwaolN5vPFRz2OqWDsD2bX/fzWJpEpM7aacTtev4xDT9//WGnZfuusKRHF3DzfqJPkFaxuZcA/yPfs4iRRyw0p/Zlpb8QSdsY9InA+gcxTab9Cqx701Wp3Oi6jZQj0xurHvg6c7xNYwggDIWdgQBLgNVft8cBySJDsCLkX4Len4RC4qWKVD3XK75pa2wMVM8gBuekYpuL7NX9yOO7xI2DABuWqfs6lY84JV9JCL85ZxRObDscTBP0ZzxLDBaglNc4Vaj0joZCGdWYhWlFQ1fVl4OfVDHTL8lCo2JEwC1LoCInODmCpfOYBilmdWC2apRnP3thiWO3oT0t7FERvCpFwSJsupdsSuucht2C8/dLzAYgy2vmaQ3X00EgaHc1MMKNKOa6xJmzdEtb8KJJiHlOj9tCNj13usV8Fbn5/GfjaMGcVm5f1yv5EQdMYooy6B5byEFMbE9EOv23b+/ExST73Wvoj0MyDr30i2TMZArmNayCXzFT94hhF8ODVAUE5NgFYB6XLhHf5NS75lQk5q1PRGnuiQM9iHXxxfD/awvE9olctLXPCt+9ZzKIMw75Nm/dpuzo79LjV3Q95OdqbNjit0EE3rUNEayuyVsTZlfURUllVRPnAQ7Mct7NqvWC0KYkSPHykjaHnqZyMQCJ8TF6ba0bapw09i0YmcdnbjDEUjggsH+TlZKna3pejVVXhUWaXIYMHqxLmpqpaJjUjyWVUFnmytPP9O1K1QMwnGtVD0C5GDVrGZfS2ystU0V54//4ZkigwwgaOvD4q1gE78a
 3rLYv1oy
 ZsVD8UVzrPokvrpvvAVtXvMnxzt5horxp90nQVfI9bRa6IQ6Ctuz/l5ZseqcvC7R5MlgJyFZC5WLgIC0VJbXmu2dwVFn2HD1llVweTyRjE82J3J62v5DS02enW4w7bG5NRZd90/0S4ytWZa4iS9Mcp+eMCWKhciiWgJ4TvnXN8RWxylVwMvVRCJqq/4hE5BFh0wiLBRU5hTdqR+7MPoTIjaY5/A5hw3xei5sR4K5tzQZRCEQvhEKX2Y9F0kELlo9tznwCcoBjYnrnO4+M2xs20lQT4nUfpcpdjkLkc1odDPyuu2GDzU8dutwmdX8QSq3+T6pVlyNZVpHuuAu5pEmOqJ+WMlTBGmTFQ5AFuKwiE25Kmn4jBbmFAKVds8tXeOMJ7tdI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:03=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Mon, Jul 13, 2026 at 9:01=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> > > My plan is to land the swap tier infrastructure together with the
> > > first use case (cgroup-based swap control) first, and then follow
> > > up with zswap tier support in a subsequent series, continuing the
> > > discussions we've had above.
> > > (I mentioned on cover letter, right above the overview section)
> > >
> > > Does that approach sound reasonable to you?
> >
> > How does swap tiering work with zswap in the current series? I assume
> > zswap is just enabled for all devices in all tiers? I wonder if
>
> Zswap is not part of the tiers exactly because it sits in front of all
> swap devices (tiers) and uses a different control to enable or disable
> it.
> Let's not combine these two; let zswap use its own existing cgroup
> control interface.
>
> > introducing zswap as a tier after the fact changes user-visible
> > behavior. I guess if zswap will be introduced with a default "max"
> > value it will more-or-less be the same behavior, but I would check all
> > user-visible behaviors related to zswap (e.g. interaction with other
> > zswap interfaces) to make sure nothing breaks or changes in a
> > meaningful way when zswap is introduced as a tier later.
>
> Zswap will not be introduced as a tier. The existing user interface
> makes zswap not exactly compatible with the tier ordering because it
> sits in front of every swapfile. If we change that, we break the user
> interface. I suggest we keep zswap working as it is now.

The goal from making zswap a swap tier is to have a single framework
to configure swapping for a cgroup, instead of configuring zswap
separately. Yes, zswap currently sits in front of all swap
devices/tiers, but we are heading in the direction of changing that
such that zswap is standalone, at which point it becomes more
obviously a swap tier. If you want us to wait until that happens
before adding zswap as a tier, I don't necessarily object, but I want
to make sure that nothing will break if we add zswap as a tier later.

An advantage of adding zswap as a tier right away is the proactive
writeback use case. It naturally fits in the tiering framework as
proactive demotion between swap tiers, which I expect may be useful in
non-zswap use cases as well. Without zswap as a tier, we'll have to
use a different interface for proactive writeback, and then if/when
zswap becomes a tier, we'll have multiple ways to do proactive
writeback which isn't ideal.

