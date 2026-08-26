Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8E4C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F46E6B0092; Wed, 26 Aug 2026 17:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5466B0095; Wed, 26 Aug 2026 17:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394E56B0096; Wed, 26 Aug 2026 17:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 114C16B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:56:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FC321C132C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:56:14 +0000 (UTC)
X-FDA: 85144779468.12.A1D1052
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2C1B640003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:56:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nh5AToR+;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787781372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAkYXAYnfeM7EWZPb0UU2vxX96nlclIp0nAmWXUJyIA=;
	b=zS6BetAs4mR1YD5tm864NZQ08tmDMfU5z1uj+rNXamdlAphSYUdsaJ6xruvME4Sytu5Xg9
	GgwVW3/kW1lKV3Ik5xQSnE56K3swfCHRtgonSdJ61XCV+02cc3TyjOH9yhxjxKA+U+ZDmR
	rtjA8GJNgdh6zU/SXQYS7gnLC0TFHCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787781372;
	b=apGPiQLErSi0cr0dA7S6s/jZvlZ6CQZUydkQ45gs1Mq0JHVx1yHUlAkdzI5VOF6YbylHkc
	APv1/vwLaYF6znb52VyEbjLaJrUPrIi+EZ+4mB/5pulJqfpyFiKb+9kGEIJgjkV4Zs9KXm
	gcyZq+UDnUTD2yEauxKou9MR6Z5ecR8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nh5AToR+;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F16E40A22
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244301F00AC4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787781371;
	bh=KAkYXAYnfeM7EWZPb0UU2vxX96nlclIp0nAmWXUJyIA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nh5AToR+8+Hy4JwDQLkAQn8JX3nCyjf2TXZmf8hTWyRrvNiP4emkuq3ejwqhcSTdH
	 DszsCD25k42ll/3FlOorkTiVJttraFnX9zOHO+jGxgbohoypS7CAw0DGKXWUdFlmpO
	 80St1R6mG3vurizq/YaEuZnl218kTVqVfw1pPKxKb8oyrCWoojUxFT7hv6Xjbj8jAN
	 QkWLZzjvn0oJSDjBkjHHTIiamGHHdcJLDb5Qj51AdhxG+8oYNbtnuTErj17fBUehNM
	 lBXRlggcv/NNz7Xozb9hddNlKABSZqyDedCnu7O4A6hFVcd93XOnx/u+sqlrQkj5M6
	 88/QGrEhrsi+g==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1670dad7a8so250734966b.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:56:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqcMFFxyQvI+UroyAkA/ah2cGABzFSDizyKWTN2YhjC4XW8aMW3SkmvaOntdG/vZlLJopwmuaH01Q==@kvack.org
X-Gm-Message-State: AFuF++mQvP7xTc1uvKrwT/SSzMlM9zKNJrPHjp8HSqD3gLHvyc8E8KLw
	K/9ASLn8vhbAZ+gP9O6fyJR/SXQwRt3epm5xItrsdEoeRwdb4HncuFVhJpiFoATPZduSqGVgyHH
	8s/igwBhpDiUa2zZspoqDDv1JkL0qLwI=
X-Received: by 2002:a17:906:fd88:b0:c25:437:3dcf with SMTP id
 a640c23a62f3a-c250c3c07fcmr1219596066b.21.1787781370065; Wed, 26 Aug 2026
 14:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org> <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
 <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com> <ao9YFgBQJEy-85iB@linux.dev>
In-Reply-To: <ao9YFgBQJEy-85iB@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 26 Aug 2026 14:55:57 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
X-Gm-Features: AcwNN1XUi59_7wlRX-aPfKbk6cG14-Ur0Kp10Fes9lEailhZFHURR2vWvYp7IrI
Message-ID: <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joanne Koong <joannelkoong@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C1B640003
X-Stat-Signature: sngzadeyjmh7uprnf4bbwcti864aoy89
X-HE-Tag: 1787781372-589862
X-HE-Meta: U2FsdGVkX1/u79mHxInCTFK2cupcgBFOWkq7wjd3Zv3laNrk3aiqnr90nIDNcoBltH41SiRN0GLRiwo+JXjlSfz6n8BfBfBOMrD92nLDE/Mpvp9xKnU18GQXzAucEbaavPqL7uQr8rHUHyKiS6omxp7MTDk4scMeqtGIpQ/lZfSrH8giOa4OUZ7DBfd46NHmPycG2SHuTZhlivrkgJo1HqpOVN6Zlj9CNI4XgyaqiDExZwwZXoOvnKu/428zg1R63I3SNkKNUdnAMvtD2AVBAIo+mSRH6LV/1EffdbxilZNkO3y1utDkueDxSAjmX4h/Xj09bbRJkhwOMqteHuDq+PB6szz7c4vJKOXTI316pB4YLovq7fDkGI4T4UEJj+20vi8Ox+mYv8gJ62nWGNflXQgEdh2vpmEW+50NYXfXtWhwOBpOk+ax4i9XQ1Gj0sYLGPtcR8TUiH/Pag/qCLoN1ttrWzNENSmpUCCz2iXjimq7p3LbComFxaYSSWoiYe6oSYTSgp7yU927m3EaZVhcmf/KarWMJxC8msm8HllpdxjMbh9PghJHZX/p9zl7H5BF/EagkD4zx4Iabjz7vvNqXcngnQgL+BuAkckC3f3LDhnlbfUQd/DHh8vK1Ddtyf611vFAgRDsNK40oy89JN3TeGPMaVYxCGHhUYDRW6RMk7Yzn4CCntg6HMCA1tzO+iS0yI7TdvS1bVRbiGBTXBB8VDB9PzZ/Ikn/9Y6jnIpgCSx16vyjmtsEBIWI1QFHyE3B8BoWc+ncm/hAWSPz0MljlMdQArh9ICvYssEE5TXdVQqJubibKEk6t2Bu9WcX/3f9yqpK5G0e4HU2HGSnY4l+u0RSHBWEqTJRAPYRhKBoJphoC9WCAKX/s8xuqB35DmQMVcpVsgjshg5OhToycBZDTGOzVk9RCXHvs4Gc4q+DokR6xy2ni5Z6Sec9z4agAEzTMEFdzLvB4MlJo5P1aRv
 GxjvnXqw
 SKn6hFQONOINO+DLaVyzz3ryRqxIbiy5nXU+MpkjBMQubBt/4OaPBlukdRMp1D3tg4D5YwTJBwMHv07HkK4tQa90Wgi8bNN1R0YOlfkbEcNeSQZiayBx1ch9gN4EsgBeopbPv2jeAmMK5s65f6pvAGmUQ+si36McqxvGhDmqwPyLaSP711/iNQdIg+fhfUy+VAZS9dveH/VxPmCqEhubaFHobW4HGFaeIef/Hq6LFAnIcI1NyHW3gABPZUXwqZYPo5yUf/9tfPIegbeNZctjtG8ZbTv20lgb2XO1oLxqMxhDuih8egWeClRXwBqIwTo+aqMboMvC/qRYCMkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
> > > I now prefer (c) as well. I hadn't realized setting zswap.max is a
> > > rare path until Johannes mentioned it, and with your mention of
> > > zswap_load() sitting in the fault-critical path, I think the benchmark
> > > results show a clear improvement for c) over d) at higher depths.
> > >
> > > I was uneasy about the cost of c)'s reads scaling linearly with the #
> > > of cpus on a system (ie for_each_possible_cpu per level), but given
> > > the uncommonness of the zswap.max path, I think that's the right thing
> > > to trade away. Either way, it's a big improvement over the baseline a)
> > > path that currently exists anyways.
> > >
> > > > with more concurrency/CPUs and should generalize better to other
> > > > stats. But I am obviously biased :P
> > >
> > > I'm still investigating the writeback and vmscan cases. For writeback,
> > > using (c) is more complicated since NR_FILE_DIRTY and NR_WRITEBACK are
> > > node stats. I'm planning to spend time this week running benchmarks
> > > for it.
> > >
> > > If for those cases, (c) is viable, then I'll send a patch that adds
> > > (c) as general infrastructure. Otherwise, I'll send out (c) as a zswap
> > > specific patch.
> > >
> > > Does this sound good to everyone? If there are any objections, please
> > > let me know.
> >
> > If (c) is holding up for writeback and vmscan, I would question a more
> > radical approach of tearing apart the rstat framework and using it
> > across the board. That is obviously a heavier lift and more
> > controversial,
>
> Yes controversial because we used to have similar mechanism which did not work
> and we had to move to rstat. Check the commit 42a300353577 and fixes to it.

IIUC, in that commit, the update side modifies one per-CPU per-cgroup
counters, and when those counters exceed a threshold atomic updates
are performed on all parents, which I think is the slow side. Then,
the read side just reads the potentially stale atomic. That was
problematic because:
(1) The update side can end up performing atomic updates on all parents.
(2) The read side can be inaccurate by up to MEMCG_CHARGE_BATCH *
nr_cpus * nr_children

What I am proposing in (c) is different:

(1) The update side always updates per-CPU per-cgroup counters in all
the parents. It never does atomic operations. The parent iteration is
not cheap, but it is cheaper than atomics for sure and we already do
parent iteration today in some cases in memcg_rstat_updated(). So the
"slow" path should be the same as today.
(2) The read side always iterates per-CPU counters in this cgroup, so
it's always accurate. This might be more expensive on an rstat flush
on average (e.g. if memcg_vmstats_needs_flush() skips the flush), but
it is much more consistent and the tail latency is much better.

>
> This worked for zswap stats because their update and consumption are not on
> performance critical code paths i.e. these are on the way to compress or
> decompress or in reclaim context.

Well, decompression is in the fault path, that's performance critical
to some extent (although not like other stats updated by networking).
Anyway, I think the update path shouldn't regress much with the
approach described in (c).

>
> > but if we can get away with it, I think it will
> > simplify things greatly and honestly rstat has been causing a lot of
> > trouble in the last few years.
> >
> > But this can be done incrementally too, we can start by separating out
> > the problematic stats to use the new update/flushing scheme,
>
> This I think we do need but for specific stats. I think the stats which have
> in-kernel consumers need this. However not all such stats might be fine with
> slow update side like zswap. So, we need to evaluate thoroughly.

I think in the proposed approach (c) the main concern is actually read
latency, not update latency. So if it works for in-kernel consumers it
should definitely work for userspace consumers as well?

