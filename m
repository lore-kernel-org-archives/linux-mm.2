Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E6D4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8059F6B0092; Mon, 13 Jul 2026 14:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC476B00CB; Mon, 13 Jul 2026 14:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A176B00FB; Mon, 13 Jul 2026 14:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 404AF6B00CB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:34:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D208B1C009E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:34:45 +0000 (UTC)
X-FDA: 84984604530.06.1F267D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E0BEB1C0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:34:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cECWHdp7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783967684;
	b=8YnkHu/Uqx3uU/F7EqcqAkYGzrX6QbiiBZQ2Q1z4hL1LmqDW6TLjD+1bmvtxgvfgPdETEB
	nHoeen2SP4x9wiYgHIs5e2RleerR2jcc6kVOfUSL33+O+OcVMxu3eAE4JJdp+qqiXsvl3k
	dAJOPAiBbR+cfLQ1NY/oJRYD0XGvcj4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cECWHdp7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783967684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJUFlkccjUuS4qFP6mqB53gOiHxnLKsqxQ1sG3XJ0eA=;
	b=Lh7e9XcrdUUYtIO4w1VYW8Nh6M/CooTkBqXDNqDFsrqa2nxaQegsnAxzNmu+HNYrtRrIqy
	YdaiVA8O1KbYgTaXWCAA+UTaHWf8EUIek85suxBA0KxfXozid98pdGgeMN1sZzZXWI7bVx
	MTLIeuTpVuS5WWoRgM62U3feiGAPboU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C774E4365E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFE11F00A3E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783967682;
	bh=iJUFlkccjUuS4qFP6mqB53gOiHxnLKsqxQ1sG3XJ0eA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cECWHdp7lten2hk6CI+Xh2vNetW0oXjQIYCSMViZPio4BeUld1qEWik2mjlo27Sn0
	 MqWl0QZfG5h5291YbXhUhRwIOqxRamjy4FC+C46RrWM3BIirmvAVGAJGZnCbSZ63nx
	 iUr4BvXWNQpqYT8kUkHvkyihGJkKGX/ItcVQOvltCa8fE1MHCrSUHbk4GvOTcbbZTs
	 tV+kEWZztSAS2ZL1MeTM6c/9Sr1gXHkQTYevvnw4z2oJ+b3vLa2hFm7J9CphBKRgt+
	 uTNJOg/JQibI4jWgAzauneQ3HcunUayBK6t6kOnDD/Y+Cna5EqGUxZLLUKJ6XDDZ9R
	 4VkEj08EXjfGw==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-664ce3000e6so213751d50.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:34:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrSTPP5+fdCJ6C02cieCBHxIWPAH78mFMQ3OCqBaAiQtE1jFCtnhV3/4l3OJh9/zXF2SPE7a9H2/A==@kvack.org
X-Gm-Message-State: AOJu0Yw7HRKOJRF6giLLu9V7QrcIbew2V4o761hbGoV8EhpPl41GYT0E
	ohgC5Vsp6Sktx4BtwJAYi1Uc+lpX3DoZ3Uu5ZsALiAn6MTe3C+WAcSDVMqi+KvpMUsN8557Y0rV
	FgPhrCchWMKHz6MLwfiG/A5pAkl4cXjoKD8rfqvTzWw==
X-Received: by 2002:a53:ac94:0:b0:667:e0f3:3229 with SMTP id
 956f58d0204a3-667e0f332b6mr5996729d50.105.1783967681919; Mon, 13 Jul 2026
 11:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com> <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
In-Reply-To: <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 11:34:31 -0700
X-Gmail-Original-Message-ID: <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com>
X-Gm-Features: AVVi8CezeMcaD2E5KHpd5R8bV0jZbW0uSawnGnnjL02HdmwndEm4NxRU0MShMiU
Message-ID: <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com>
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
X-Rspamd-Queue-Id: E0BEB1C0009
X-Rspam-User: 
X-Stat-Signature: 6fxs44miotxjhwcyj3xifnehnzsqjdhr
X-Rspamd-Server: rspam03
X-HE-Tag: 1783967683-963433
X-HE-Meta: U2FsdGVkX1/nXcHogOhkNXCqG/e0UVpomeNjA+toCah9AKceAJNTkNhmwBdaBvzIvz6wls/wEQbF8ntZc+0tQGa4V8YaYysQOBmR4ATfOGG09fv8gHgWQHER/w01LKwE6HPHJkVRh4GRoVkyp/HfRZuSKs9omoJhP2NoUm2yJPZy6V/l8YV9O4KEKTGaIwsqt4kyVDuX7SMAp2iSzk2Ne4QVjiC0SkD6EzJsdlKVzaeQxt/Pi/gY26upQvyukfh2cm1FDIXUw5AEQsZZDUCQZpfoGfeNVoBzIouVlwVFKxYGPJmt1ggVK3D6lzf73kIs+bo/sd8ZSf710GXgkEOkRbYZ3zDyP1ZIvnvVvXZZOAT8QpgpLdIbzpi2+aFaeSzs0ShHHuTHqdoOpq+5iiRDwjoOqUYtAUgmTzyjqCAAXLrXud6tQfH2Texrc78ueHP4lvMKMVvXyHF4mnU5LjBhk6UFR+mGduN1gB4tnTS2z8xyt7bHtZol4P1Tvs9k/mbU28RYfEKaUVlAGt54ScId6smD8mmIm+Gv/REvkL/CDf4tYyJpabARQEX64RatTsENZjpsZkbipOn2wN7TxdJfVbQ8uupnO3Xz27zTnN3tVqavkKmn2KdwkGlEPHDdZBAG2skYMDpuXwBr7xyjf6rbyRAKd1ZT9KF8vdljFJdVEXiBmPlLnt+a1jSZRExGBz68iS3X0FInsV5coC3mTb6u+XS58Xqun31Edg9N4iR1ucla+NrlEOAQSbH8iskCTyhAEr64pwDb0gYVxiL3LczH/ZYa+/vykACXZrXZgHy438hDTysKGNwSbYfUZig/+rwxlV+D+p+LJrY465ER6kLShh+Ko7Vw6ICiqUSBodQDelxEtXeLY0lESdUrAY3pzBaIluHxOTz5JQJ1aNmzUpmnTAORZKnOFZOkf0keGTbMBdqS/+76PNOYKOwbI+htaufFR2gE0LApexYBk91eZzJ
 Hw2OlVim
 Fm9YfEAdFeV4U+ihGWiy6PF1F4RGDtgMJb6JniWETLi1/EBfq6gqjCjnUNR6u7LXpztw1CsF7xdzGI6YI0/CvmDe2GH4F9LSoYf5o8IGVwxVT5K48aqitD9ZSBb++KqYDc3mE6qmVSrBYZFTNsIKXGrGQzGpY0wGAbrMOCsqmy0Lju3DgrylIN8h82LgY3OU7hAYzfqDL+bZGjpTuPrUkr8bb23RVlmSeN4u1+qrSDt//t8uE20VG7e3hZz8xEBGpK8ORdhVnsd4W4tGnUkZwZeGpU7+yP7PkhFFBSDvbYPcI6o36QSwDEWl803pLhrdE81JGs7gZ01tBGaNkXgu6Ll4et2/3+LPJjc17xZ738lvZR4M6IcorTp5vPEvyBdX9ZmuG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:11=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Jul 13, 2026 at 10:03=E2=80=AFAM Chris Li <chrisl@kernel.org> wro=
te:
> >
> > On Mon, Jul 13, 2026 at 9:01=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > > > My plan is to land the swap tier infrastructure together with the
> > > > first use case (cgroup-based swap control) first, and then follow
> > > > up with zswap tier support in a subsequent series, continuing the
> > > > discussions we've had above.
> > > > (I mentioned on cover letter, right above the overview section)
> > > >
> > > > Does that approach sound reasonable to you?
> > >
> > > How does swap tiering work with zswap in the current series? I assume
> > > zswap is just enabled for all devices in all tiers? I wonder if
> >
> > Zswap is not part of the tiers exactly because it sits in front of all
> > swap devices (tiers) and uses a different control to enable or disable
> > it.
> > Let's not combine these two; let zswap use its own existing cgroup
> > control interface.
> >
> > > introducing zswap as a tier after the fact changes user-visible
> > > behavior. I guess if zswap will be introduced with a default "max"
> > > value it will more-or-less be the same behavior, but I would check al=
l
> > > user-visible behaviors related to zswap (e.g. interaction with other
> > > zswap interfaces) to make sure nothing breaks or changes in a
> > > meaningful way when zswap is introduced as a tier later.
> >
> > Zswap will not be introduced as a tier. The existing user interface
> > makes zswap not exactly compatible with the tier ordering because it
> > sits in front of every swapfile. If we change that, we break the user
> > interface. I suggest we keep zswap working as it is now.
>
> The goal from making zswap a swap tier is to have a single framework
> to configure swapping for a cgroup, instead of configuring zswap
> separately. Yes, zswap currently sits in front of all swap
> devices/tiers, but we are heading in the direction of changing that
> such that zswap is standalone, at which point it becomes more
> obviously a swap tier. If you want us to wait until that happens
> before adding zswap as a tier, I don't necessarily object, but I want
> to make sure that nothing will break if we add zswap as a tier later.

I'm afraid your zswap user interface will have to break. I don't see a
way around breaking your zswap user interface to fit the swap tiering.
Once we move to the swap tier world, I don't think we should continue
using zswap.writeback to control the tier write back behavior. We will
need to rethink this new world.

> An advantage of adding zswap as a tier right away is the proactive
> writeback use case. It naturally fits in the tiering framework as
> proactive demotion between swap tiers, which I expect may be useful in
> non-zswap use cases as well. Without zswap as a tier, we'll have to
> use a different interface for proactive writeback, and then if/when
> zswap becomes a tier, we'll have multiple ways to do proactive
> writeback which isn't ideal.

I am looking forward to abstracting a more common write back behavior
in the swap tier world. The classic zswap behavior will be preserved.

Chris

