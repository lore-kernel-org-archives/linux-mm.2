Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18ECEC61DE3
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 17:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F380C6B0088; Sat, 21 Feb 2026 12:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4E56B0089; Sat, 21 Feb 2026 12:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7946B008A; Sat, 21 Feb 2026 12:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C99806B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 12:44:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2677D1A04C3
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 17:44:13 +0000 (UTC)
X-FDA: 84469187586.02.A03534C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2BE6B80003
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 17:44:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wykhPWNf;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771695851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiY/m+KI4arHxjuY8F3SEwB02avueu/qClO5JqY8KVs=;
	b=GQLT75KltUzN13jJwPb69AZ9MEZwc8crpV6k4wVmHTQEU5Q6wTingPAVXguTI8NFr1je4h
	iTSkPng9QM3DJN++M6tjRUSTHgdQx7z8EfzlDqZm4yD++S9EKX0Av1HtcB6XrkvTF7s1Nl
	0/yS9N6pOLAo4DoXmRK+gqFgMhQ8DYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771695851; a=rsa-sha256;
	cv=none;
	b=znQYwAk56riuR0Hrye5Xh1z/NklSrWNHLeIi4hu+4M98k+W+eEUxueF4mWD9hRzjGMlAci
	s+4YZta5fzDYbSAvsahnFLm/hSVvItP09A79mx5uzivG156ybdyOEHwp7OsF7+iyNtNs3R
	0KNsDwUSOgTBqvjstD4bGDj2NYo+ILM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wykhPWNf;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 21 Feb 2026 09:44:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771695848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiY/m+KI4arHxjuY8F3SEwB02avueu/qClO5JqY8KVs=;
	b=wykhPWNf/XF4noMht/78PiUTFXpG1lCH4aE1pJ6KLZWfPfy/XUik5GlWpqw3wA7K8did8C
	htPvfzsYHp8Pr1BuTW+BBXWCVKbJTgoQuIR8wGXLNIzocQQQhCd3+7hjThirxBWTvmxOUD
	ur0MYvOE+qrMTTLxbzY1628Wx5pVsfY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <20260221163043.GA35350@shakeel.butt@linux.dev>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2BE6B80003
X-Stat-Signature: yjxbnz57ofnfih19qkxb3cxdzqfpiih6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771695850-843517
X-HE-Meta: U2FsdGVkX19m8QRJqVO2tCo1h/gs/nDrI9keCC+2pkCMRvyf+i6nBFqcha4BKoYLk9+rAr8SYIo1/dA0e9JFxOcmF49EoCbdTFZDG++0/d9HqF7Z2PRKi8XENiSjsjCxg6B2j7rm6nFZdklmS1Mw8Wfdvx/xS88S+eS5SMSwapY09hK6B1ww0bUTmvSZEefDoRR6zMkjdzH6jXH8XBDzFec77UbkDouaAkSzYHGowYTgj8AegFCf3XAuVNjvMgjdqHeHQDXhefUcTLKV++tYT7TsPagWGwgOriPmz21v8R8w1ktZotCSNmVabrjdli1ajf184pODJvwJuZF6kGMBUGBgx4cHvRTjBmVM/LCv75UwqP1Zqk42AUsIlP9sQFcPEQC3KAFnAyHNyeP6ZKPwxju+QCgSeepcsw+FTjgVh6lli7fcg7aDryl/Dg8rZu6N48qxVHDWB+LfR48EJdSiTRSQdemGCcLBFGbUAGsVPmRXtK+X8GfUGUqCIUfUpVYw7OBPcjptHI+p/S1C64reeEmbzRpD2cpuw5RVdz6ja8SzxRfFmdYU1H+hrye3t2C8WW5iAwC4ozeVWYK6wYEQ8kuxCeYvJ3gKyooUC4q4BbGigXYOr6DDdXEabosJChjQ82yV6dA12CUDa2yfzOgC5XerT5G5zV13E0xjXWwM2zOOSWvgJTDLLo+3HL+suYRFDPgSimQ5siLgydUTUeHokcVJaNrlSLLMlr/gN5DPImeAri2fdLjAPaCyT6kJ66khNCOuTwXISRL9iUmBCcY6XGrKmGUPTE+SZfER1nEVNFPymCPuJibl1O3OqAyBJfevXA6u0AMeJfEtzkgSq60/IZUW7WTza5aCJJLlgY0SGURpgN9OmjtCmvNYMR1g+bOHA5J2zF9fcamScUTDdT2L3GyrM1cwMCd7ZjqTqhlWbwifnT2xlTJfytDSGFstmWkRTdDP+bNDTqhI9Jpj/ux
 iNC6mYpj
 JexifI2Y9OXTDUznw1VmmfKImWJn3puz/Z3KXfqEG/V6Db0urghtO41RxgJ/uUtvsaEF9nVg5riwe27GaOSOWmwymFGlEWfSe4Z5LNqBClHQ9AV8e7fn0nkf95Gr61JnYSSW4aneSAVkWrkL5cEi000+E0h/+Tmm+IKPNwekdmPq2kg4Xo+G8tQl8Cjg5NXN61/ZXSWRhVpARLGzh0gVPB/yBag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:07:44PM -0800, Chris Li wrote:
> >
[...]
> > >
> > > I agree that using BPF would provide greater flexibility, allowing control not
> > > just at the memcg level, but also per-process or for complex workloads.
> > > (As like orchestrator and node controller)
> >
> > Yes it provides the flexibility but that is not the main reason I am pushing for
> > it. The reason I want you to first try the BPF approach without introducing any
> > stable interfaces. Show how swap tiers will be used and configured in production
> 
> Is that your biggest concern?

No, that is secondary because I am not seeing the real use-case of
controlling/partitioning swap devices among sub-workloads. Until that is
figured out, adding a stable API is not good.

> Many different ways exist to solve that
> problem. e.g. We can put a config option protecting it and mark it as
> experimental. This will unblock the development allow experiment. We
> can have more people to try it out and give feedback.
> 
> > environment and then we can talk if a stable interface is needed. I am still not
> > convinced that swap tiers need to be controlled hierarchically and the non-root
> > should be able to control it.
> 
> Yes, my company uses a different swap device at different cgroup
> level. I did ask my coworker to confirm that usage. Control at the non
> root level is a real need.

I am assuming you meant Google and particularly Prodkernel team and not
Android or ChromeOS. Google's prodkernel used to have per-cgroup
swapfiles exposed through memory.swapfiles (if I remember correctly
Suleiman implemented this along with ghost swapfiles). Later this was
deprecated (by Yu Zhao) and global (ghost) swapfiles were being used.
The memory.swapfiles interface instead of supporting real swapfiles
started having select options among default, ghost/zswap and real
(something like that). However such interface was used to just disable
or enable zswap for a workload and never about hierarchically
controlling the swap devices (Google prodkernel only have zswap). Has
something changed?

> 
> >
> > >
> > > However, I am concerned that this level of freedom might introduce logical
> > > contradictions, particularly regarding cgroup hierarchy semantics.
> > >
> > > For example, BPF might allow a topology that violates hierarchical constraints
> > > (a concern that was also touched upon during LPC)
> >
> > Yes BPF provides more power but it is controlled by admin and admin can shoot
> > their foot in multiple ways.
> 
> I think this swap device control is a very basic need.

Please explain that very basic need.

> All your
> objections to swapping control in the group can equally apply to
> zswap.writeback. Unlike zswap.writeback, which only control from the
> zswap behavior. This is a more generic version control swap device
> other than zswap as well. BTW, I raised that concern about
> zswap.writeback was not generic enough as swap control was limited
> when zswap was proposed. We did hold back zswap.writeback. The
> consensers is interface can be improved as later iterations. So here
> we are.

This just motivates me to pushback even harder on adding a new interface
without a clear use-case.

> 
> >
> > >
> > >   - Group A (Parent): Assigned to SSD1
> > >   - Group B (Child of A): Assigned to SSD2
> > >
> > > If Group A has a `memory.swap.max` limit, and Group B swaps out to SSD2, it
> > > creates a consistency issue. Group B consumes Group A's swap quota, but it is
> > > utilizing a device (SSD2) that is distinct from the Parent's assignment. This
> > > could lead to situations where the Parent's limit is exhausted by usage on a
> > > device it effectively doesn't "own" or shouldn't be using.
> > >
> > > One might suggest restricting BPF to strictly adhere to these hierarchical
> > > constraints.
> >
> > No need to constraint anything.
> >
> > Taking a step back, can you describe your use-case a bit more and share
> > requirements?
> 
> There is a very long thread on the linux-mm maillist. I'm too lazy to dig it up.
> 
> I can share our usage requirement to refresh your memory. We
> internally use a cgroup swapfile control interface that has not been
> upstreamed. With this we can remove the need of that internal
> interface and go upstream instead.

I already asked above but let me say it again. What's the actual real
world use-case to control/allow/disallow swap devices hierarchically?

> >
> > You have multiple swap devices of different properties and you want to assign
> > those swap devices to different workloads. Now couple of questions:
> >
> > 1. If more than one device is assign to a workload, do you want to have
> >    some kind of ordering between them for the worklod or do you want option to
> >    have round robin kind of policy?
> 
> It depends on the number of devices in the tiers. Different tiers
> maintain an order. Within the same tier round robin.
> 
> >
> > 2. What's the reason to use 'tiers' in the name? Is it similar to memory tiers
> >    and you want promotion/demotion among the tiers?
> 
> I propose the tier name. Guilty. Yes, in was inpired by memory tiers.
> It just different class of swap speeds. I am not fixed on the name. We
> can also call it swap.device_speed_classes. You can suggest
> alternatives.
> 
> Promotion / demotion is possible in the future. The current state,
> without promotion or demotion, already provides value. Our current
> deployment uses only one class of swap device at a time. However I do
> know other companies use  more than one class of swap device.
> 
> >
> > 3. If a workload has multiple swap devices assigned, can you describe the
> >    scenario where such workloads need to partition/divide given devices to their
> >    sub-workloads?
> 
> In our deployment, we always use more than one swap device to reduce
> swap device lock contention.

Having more than one swap devices to reduce lock contention is unrelated
to hierarchically control swap devices among sub-workloads.


