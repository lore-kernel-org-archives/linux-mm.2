Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD87C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 01:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835E46B00B2; Tue, 21 Jul 2026 21:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB616B00B3; Tue, 21 Jul 2026 21:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC896B00B4; Tue, 21 Jul 2026 21:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 295726B00B2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:11:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CBBE40316
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:11:58 +0000 (UTC)
X-FDA: 85014635916.11.CD8A654
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42DA140006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:11:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GxOwvukR;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784682716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPeWjqbBuNWvil2Wi1GbJzxHLNLfXAIIvk3axfPdvVE=;
	b=3kt0GlrXpljh5IjBUo2PyPqfnB/WLJv7ejcfkJcn421s67e3IANa8ppCtK2ZCFTbw+YxUq
	q/pSdvDBtEV+2bb77D5RcdrzOfvZWMa/qZJwwF/sB5JTHouA7BBx0ASktIbj5o3FYg1w+u
	NpfSBq4UWVszqVSoKcVPi56K0yflol0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784682716;
	b=22Wn2V14J6IVsFUsJc+DcKdbdNank4hqPB8Xl5ZeYG2Pkvx2CUU40ySyO5aRLJk20e6XOq
	SRwnq0O875m1/HAtUBYrrRxrQWH28S2lJ/eLI6NEvonEq42UCpibJw6DvpOvZQ1uC05Mme
	rIUYi3NPBtjMxoX5pj6kSUMlJKYeFyM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GxOwvukR;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 21 Jul 2026 18:11:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784682712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPeWjqbBuNWvil2Wi1GbJzxHLNLfXAIIvk3axfPdvVE=;
	b=GxOwvukRpoFyR8PdP9f5TWXO15pCgm937M4Z1QA4Bz+5Po0vKLHau87RH8cURsoyLnX3e/
	/rQEhdPoJlOjrBDww2yRH0QVuvc9jZCtPjQkjFIL3MbP1o0ljrhhvh3FIXKP3MASNq90zn
	mQx97xDidduv6eGu9uNqBsT+dfH5bP0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, 
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amAYvvTtg8QLyInH@linux.dev>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
 <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42DA140006
X-Stat-Signature: yerejy8x8gi8jocemzzhqcykc6964t6s
X-Rspam-User: 
X-HE-Tag: 1784682716-861636
X-HE-Meta: U2FsdGVkX1/Py9IIS9CX5bUhUL2C+JKB6noe5SrqqWhvjhTIpHxvKoKVfACoS/lPNV9ExvgeSIDwUp2eW32g1Cw/KfEV47ktIJ1QY27kSLXHlCB/3rkR6mGxR8j3d7icpA63J3lQ1Yxyq8IDi/sLSHCJCuAiO62i9zybw0R47poE0h8xA3W0nse9MzTAsNuQ9ZNYlGYGmGlxawHuc42TS/J/RuL/f/BBHhNwPFHbwTAb0gZKJ3cS9Fd1wy5Z8otay7qfGANSHoGQnmBi40lQ5wK7kOG2CMo7TCbDB3jZ17UYGCShVCYou+guajec4W6Bhfqe1IiLSWHzGxu/bbfjaV9ihYq3PgSr7p5uN16HmgfgymEDGRrZcg2kCkkILRKTza5JYYOI7zuyj1PzPWhGUPbXRzniVY1Hnuk2pAYKOTuMGuj9D5wrlqtQCOrXQmJIgbg6kZvPQGDERKmZEKwFblXwiA/e0Buee3hQkS6e4MUbyDWejDGzfk0vZKRggp85FUZ95cxZ5EQ4O3iPr/CX4Htw/QSlzo97Aix5LZTKYmDKc+Ox17gqJcq+8k9O+A1bJD8M3+mrPY5Bp+McIAYyB1Hr6B9JNcwu8SRvDzyOqUoSDMms6mSvWmmvUCVCWsAD82+YAOroZbBTnGJdE+2tWs02wERcUZwW1JUc76ozL8U/Lt1dJ6jxzTRStwsdEO7yLkxiUIjRVMMx9pc+4Wv4l54Ll1K+LjSscIBntsaMvFT5ES9WgCaLwV9qELtfV/7RYMRtAslgG4+RK9blHH3zu6HhLxioXBFZtAuzEnCNXVKFgy/eTuSc4GES8GGpMFh0GAwqb5iLRGWKXPKb1lxZqU58GgSu7bSPeB+aejzcX/poF6oLsdYrjayZwIgNBjNHT8VnawvOOoGjUfao8D1voCeHysnKEFq5l0UxLETx/S6fWPCjYoS26+mpC4bw21ccjpEN5Rnbw0ZJywihwsm
 TiLUv7fq
 c6sG5Wba1Gz1kNUdOcB1gqYW3/fc11mkWtMt++ScCWg/rPyWYxpTcRQvuVOj1U2PHZJDbhJ2gvibfBo9dEYsFi1ma7+nN0SFt1tgUjGrZnor+46bPANwG0b54rmSNK1mk4snH8oUjwPCi4/SyqAYepDj68I3BpCKBplWpYC0Nfbn7NhBK6BBSUG5o49g4Jmj8uWxz/3UNSJRdRKYpErl3QuM2d3P82hpTK5j7vW4a4A3S1M1LOG+hkCewzy6cJUpIJibnNwxmEUZsF/3D7MmKw1iDy69/A6KiwhTb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 11:27:56AM -0700, Yosry Ahmed wrote:
> > Hello Yosry, Shakeel,
> >
> > I have been working through this in detail at the implementation level.
> > For now I am adding on/off control of zswap through the tier interface.
> >
> > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > disabled, nothing happens to the existing swapped out pages in this
> > > tier, but new pages do not get swapped out to it. This is the same
> > > behavior that happens if zswap is disabled at runtime.
> >
> > This part works as you described, with no real issues.
> >
> > > From the tiering perspective, we need to accept "zswap" as a possible
> > > tier, or maybe creating it as a tier by default if zswap is configured
> > > would be better to avoid handling the case where the user doesn't
> > > create a tier for zswap. We also need to disallow zswap being the only
> > > tier as that combination cannot work without vswap.
> >
> > I tried to forbid this at the implementation level as you suggested
> > , and that is where I ran into trouble.
> > A few code paths can end up with zswap as the only
> > tier, and they are awkward to handle.  Below is each case and what
> > handling it would take:
> >
> > 1) A write turns off the last device tier while zswap stays on.
> >    -> rejected with -EINVAL.  The write does not take effect.
> >
> > 2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
> >    -> the file goes empty, so zswap is not shown either.
> >
> > 3) A cgroup has zswap and one device tier on, and that tier is removed.
> >    -> the cgroup's zswap entry is reset to 0, which the user never
> >       asked for.
> >
> > 4) A cgroup has zswap and device tiers on, and swapoff empties them.
> >    -> the cgroup's zswap entry is reset to 0.
> >
> > So the problem is that in (3) and (4), memory.swap.tiers.max has to
> > change on its own independently of what the user wrote
> > and it is not like just error handling situation as (1).
> >
> > There is also a consistency point.  memory.swap.tiers.max already
> > accepts a child enabling a tier that its parent has disabled: the write
> > succeeds, no error is returned, and the difference is resolved
> > internally.  The user's setting is kept as written, and only the
> > effective behavior is constrained.  By that logic, accepting a
> > zswap-only setting and guaranteeing only that it cannot do anything
> > would fit how the interface already behaves.
> >
> > Having thought it over, I think one of these two directions would be
> > better than enforcing the rule as above.
> >
> > 1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
> >    work without vswap, so today the setting does nothing and there is
> >    nothing to prevent.  Once vswap/xswap lands it becomes meaningful on its
> >    own, with no interface change needed.
> >
> > 2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
> >    track the user-set and the effective-set separately.  Exposing
> >    the effective one would show that a zswap-only setting is not in
> >    effect, giving the user visibility instead of rewriting what they
> >    wrote.  It would also help the parent-off/child-on case, where the
> >    child could see from the effective value that the tier is off.
> >
> > What do you think? or any other ideas?
> 
> Hmm yes, seems like enforcing this rule comes with a lot of complexity
> for little gain. It's possible today to enable zswap without adding
> any swap devices, which would render zswap useless anyway. I suppose
> in the same way, we can just do (1) and allow users to disallow all
> tiers except zswap for a cgroup, which would effectively disable zswap
> in the same way (albeit a bit less clear). We can document this
> clearly in the memcg docs.
> 
> Shakeel, any objections to this?

Nopes, no objections.

