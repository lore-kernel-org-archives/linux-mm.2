Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD644CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 21:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78B46B0088; Mon, 22 Jun 2026 17:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50316B008A; Mon, 22 Jun 2026 17:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CA96B008C; Mon, 22 Jun 2026 17:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A31A6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:29:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E19F08D018
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:29:37 +0000 (UTC)
X-FDA: 84908840394.21.FD4F765
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E0EC518000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:29:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4KtN8W8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782163776;
	b=oqLXVB1ytAzns4ZTx3nIMGO64F4oiSI+q26Zzf8y2jGVntiEHVMscCsiPaCtFyW5xZEjAv
	WTTkHKjmkQ0GbOnx+zmW5DuN9FcfHp7QFFPwrM7SnNbPOb5W+mQFBsSkQOsywbxw3ij0S9
	zbDdENEEopm6+xHMsi98MyV1b+rKs7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782163776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXLoZ1hGoYCAtFF7te+jkqyRbBNr2vwPY2VH1Mi/VeU=;
	b=Hq/UvAct4LeagPDikPKltIl0VbvcbeeKH5h+psviF2QqEb6q54H1+Y8rRzkxKxLkk+9oTj
	8dnbdA1oG896kzotiPBo8KxlkHowPaCBLrOWVZMjgUrTW03Qk5T4OGHO/ICspNsnNsQsfq
	md2RnMR43kpcGBqI6Y/rkLb96s1H0CI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4KtN8W8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AE4C43B1E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FD51F00A3A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782163774;
	bh=SXLoZ1hGoYCAtFF7te+jkqyRbBNr2vwPY2VH1Mi/VeU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J4KtN8W8Fc25LPHVZJvbipnoTiPBAiQbCX5C1D9yr6G+yK3XWiPNDm/CVEUYjwF7d
	 YgeSMj7AvTnipAVxICqyud+oozJAoDg9cG46nBjADp9oNzhofZecaBlWTssP8Rtm5T
	 46mPBXq16hhytu1NHS65vWSeQcHfFePCXAIuKiqds8T5Atkd2fhxN5Om4ps+MOZrZ2
	 KcrlYsXvIZ976AVSUfrP1KUS1g39F6d7TTlBMqvpYenIvDg6XZbQ94YmsT1hK9TiYk
	 jZHlxDaHtG50xPBOrC3sAKFd63nfMCx9VIgQoJmJcyt3XmQ7EfmDov0tK8N9n8CTrp
	 PTpIUUJHP1zqg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c0e12cb1d90so209728666b.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:29:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ85oTL6cPcIT1hmW5clrH8xC7GABF/pR3qyCY7eJz2CsTzAFcsth5OovZJJHL0KiwlG2yvLWQeghw==@kvack.org
X-Gm-Message-State: AOJu0YwJReoTGQdP52ooyApTeH8WaZ7zAKmqhwExdFSgB1ZYZfhMgfjL
	I+0b3+e22ZFVGcN7W0VKnqHZy5bT+UY+2smzvB7DOD4u6hkht4RD5Ck6XG8Fxmt0K+e7l4WFnEc
	/OMDf8oLZASGhtcePdbLl2ffYZIh6Qfw=
X-Received: by 2002:a17:907:74d:b0:bed:19af:f89a with SMTP id
 a640c23a62f3a-c097ae2d9f9mr826269466b.7.1782163773890; Mon, 22 Jun 2026
 14:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <CAAAF57B-7DE9-45EA-8AB6-DE6CFAF60F47@linux.dev> <26a034b3-9cfa-e4f5-eea1-e69fbfff02b4@gmail.com>
 <ajkIkyajJEW2b7/0@yjaykim-PowerEdge-T330>
In-Reply-To: <ajkIkyajJEW2b7/0@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 22 Jun 2026 14:29:22 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOe8i3QXeg639aJbMEXAiHjbZvt0w7v6tn8MQyvysXP9Q@mail.gmail.com>
X-Gm-Features: AVVi8CdKnjEoAO3uPfDnZIRPxM_R9nTnVOUDlsdn8mjO-TtdAPtrEC9LrsVK0Ck
Message-ID: <CAO9r8zOe8i3QXeg639aJbMEXAiHjbZvt0w7v6tn8MQyvysXP9Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] mm/zswap: Implement per-cgroup proactive writeback
To: Youngjun Park <youngjun.park@lge.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Muchun Song <muchun.song@linux.dev>, 
	akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0EC518000E
X-Stat-Signature: gtos96ep3hcp5jnak4unreympjo34ca4
X-HE-Tag: 1782163775-356346
X-HE-Meta: U2FsdGVkX1/UA+A4+XYdYnvfmNBCF7TAvtEditqjlVlrEw8UhTwMdgJ784nFT8/EL7VbZjILKcgDKLRx2mtA+IGGy28VKI8pYQ1jA41IFIYC/qGKVQcmqbopEK6jdZcHiuN5ha3V/uJTMQGmXgjageEkjmVNlL3K/O/dCSqBo85jJ9K+Podp4OaA5jB1xckRHGds4QLvPGBNzmb9NS6MYJ+PDdiJkB4K5wEWy99PIqkY0DmmOKUZd/9CGnW8p81UBDGAH2b2CmoSIoi7nOjKj5BPTYCXQINJZwenHmWfzCx3yL3ci4SzOu2zn3XdoBehmIqROboSLasAZ2YksUJonmG/ui5UBcdmNMw1LxY9shMT2T9aZUgMPeQztgPu7gSGO55tFgojtmrb6h86nuD845b5KIR18TvEdklh4s8764+LMmYsWgsvoG8yvthiGJ/030uDDiUTGY7VaTwda1quJ9DMDSAqN/JcPjtegLnKbueNFd3n7o4FUE1xvLqUN074Pfcvjk5fJI4Qf3Dlhz3fj+dmnFizQXuQABPiVWSLwrvukH2wVK9t+3+9cfjScb4z3YVubBVlUEKVyhC7NJWlE6RQPPNOOaOFwoKTi8HJl62N9M6mkA/u81N9lxYwBjUsKLY4i9f2pVsb2KBUY7NzfOpU6WEJFvqk/ezyIdHfKvQX/fS5FLFzn2YZbZRD4JuFIMPR6hMpFHY/+Gg1IxXF27sLfaRDrSqT2HfmZfJ67SlVTkp8q5HI3E1cF0pzAQa2Yes9lQSsk40VupDxHoW+oCoIV7NouDnmBxApWm354ZOTMyhXRea2ZL/lJcAJoHS1ZHja+lS2CxEbCDSVzVVvR97Ai6biAFPq6D488BdaiXBv5uq4bfV74ctNJOtijFv47/oy2KpWzcK/ww1c9v8ZkSph+/r6IJehAjDMMGJ7d3lZa4KQkrWic/M3rogESkqW6KKP37PCP4CEhNadGpB
 y/+3tQLK
 blalrmFAVLyFipOnqPDsBqeQFaZarTZOHTqh6zaoyXxZWNwUJQzNfOnLlBjfb5AqkLzyQP9ZbuNIuZHWSoNwz0u/1C7/8sTi5SqGgvAC1lCHt9JH52zW4RexDIlXT7SFsUuRBvydV7cJWtB0qAbbcLAVqL5vY24BccLI8hXgFbcSOxfMY+YduXIqbbNxjPfUwrP7JIh4yehBNIrjRbdg/+GrvupGyPriDgw0t0aWbHqz6iNDYYG1LzskCXFQ9Ym8WtZmPcGi8q1lYoKQz2hocYwvTMnwYJp9w8THIDXkVURbP6BKK3kTV3BPmzkN5R5+a6BMAhXMVsGhQwuBkBhbbUxceomM9k6yo3R9FhFsqobz+rqdOj3otIcKLfJUvfYcCMku6DwMpwS9K5d08ZNzC+GB4ilQ98xRv8zF/EcRDG4RkD6zt4lrBS8KOy7dyeiMrw9obXDeeuzkNLovq2IvhErOX8Fe131hGHewZtaK7xPUYGI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:04=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> On Mon, Jun 22, 2026 at 02:08:49PM +0800, Hao Jia wrote:
> >
> >
> > On 2026/6/21 12:20, Muchun Song wrote:
> > >
> > >
> > > > On Jun 18, 2026, at 12:48, Hao Jia <jiahao.kernel@gmail.com> wrote:
> > > >
> > > > From: Hao Jia <jiahao1@lixiang.com>
> > > >
> > > > Zswap currently writes back pages to backing swap reactively, trigg=
ered
> > > > either by the shrinker or by the pool reaching its size limit. Alth=
ough
> > > > proactive memory reclaim can automatically write back a portion of =
zswap
> > > > pages via the shrinker, it cannot explicitly control the amount of
> > > > writeback for a specific memory cgroup. Moreover, proactive memory =
reclaim
> > > > may not always be triggered during a steady state.
> > > >
> > > > In certain scenarios, it is desirable to trigger writeback in advan=
ce to
> > > > free up memory. For example, users may want to prepare for an upcom=
ing
> > > > memory-intensive workload by flushing cold memory to the backing st=
orage
> > > > when the system is relatively idle.
> > > >
> > > > This patch series introduces a "zswap_writeback_only" key to memory=
.reclaim
> > > > cgroup interface, allowing users to proactively write back cold com=
pressed
> > > > data from zswap to the backing swap device. When specified, this ke=
y
> > > > bypasses standard memory reclaim and exclusively performs proactive=
 zswap
> > > > writeback up to the requested budget. If omitted, the default recla=
im
> > > > behavior remains unchanged.
> > > >
> > > > Example usage:
> > > >   # Write back 10MB of compressed data from zswap to the backing sw=
ap
> > > >   echo "10M zswap_writeback_only" > memory.reclaim
> > >
> > > I=E2=80=99m not entirely sure if other candidate names were already b=
rought up
> > > in previous discussions, so my apologies if I'm repeating something h=
ere!
> > > I do think expanding memory.reclaim is a great approach. That said, I
> > > was wondering if we could make the interface a bit more concise while
> > > keeping it flexible for future extensions.
> > >
> > > Essentially, what we want is to control the specific targets of the r=
eclaim
> > > process=E2=80=94such as file, anon, or zswap. What do you think about=
 using
> > > something like "source=3Dzswap"? For instance, if we want to reclaim =
10M from
> > > zswap, the command would look like this:
> > >
> > >     echo "10M source=3Dzswap" > memory.reclaim

I like this suggestion, but I think ultimately we want proactive zswap
writeback to be part of a more general proactive swap demotion, and
zswap is just a swap tier.

> > >
[..]

>
> I also preferred sharing the `memory.reclaim` interface in the future swa=
p demotion,
> since it already takes `zswap_writeback_only`.
> https://lore.kernel.org/all/aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330/
>
> Alternatively, we could use a separate interface as Yosry suggested
> (e.g. 'swap.tiers.demote'?).
>
> But as Nhat pointed out, allowing user-triggered demotion from the swap t=
ier
> perspective could lead to issues like LRU inversion. We probably need to
> discuss whether this kind of user-triggered tier demotion will actually b=
e
> supported at all.
> https://lore.kernel.org/linux-mm/CAKEwX=3DNfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9=
vk_cbnnr6J6PQ@mail.gmail.com/

I believe what Nhat said is that swap demotion may be used to
prevent/alleviate LRU inversion, not cause it. I don't see how
demotion can cause LRU inversion.

>
> So, IMHO..
>
> 1. If swap tier demotion is NOT exposed.
>
> We can simply choose between "source=3D" and `zswap_writeback_only` based
> on preference. (since there is no need to consider "swap_tier" demotion.)
>
> However, "source=3D" seems to offer better extensibility if it is expande=
d
> to file and anon use cases in the future.
>
> 2. If swap tier demotion IS exposed.
> We need to consider integration vs decoupling.
>
> (In my view, This is a design consideration. avoiding potentially
> redundant interfaces vs adding a new one if it is architecturally correct=
.)
>
> 2.1 Integration
>  - Integrating into 'memory.reclaim':
>   - "source=3D": Seems easier to integrate by explicitly specifying the t=
arget. (Your suggestion)
>   - 'zswap_writeback_only': Harder to integrate than "source=3D".
>
>  - Integrating into 'memory.swap.tiers.demote'
>   - 'memory.swap.tiers.demote' could absorb the memory.reclaim functional=
ity.
>   (But since we only want to allow tiering for vswap+zswap cases like
>   the zswap writeback feature as we discussed, the reclaim interface beha=
vior might
>   still need to stay for zswap only.)
>
> 2.2 Decoupling
>  - 'memory.swap.tiers.demote' handles other swap devices (excluding zswap=
),
> while "source=3D" or 'zswap_writeback_only' handles only zswap.

I personally think making proactive zswap writeback one use case of
proactive swap demotion makes sense. I think swap demotion in general
makes sense.

