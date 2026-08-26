Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F54C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 23:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69B86B0088; Wed, 26 Aug 2026 19:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A756B008A; Wed, 26 Aug 2026 19:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9304B6B008C; Wed, 26 Aug 2026 19:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1E76B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:15:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4ABB1402CF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:15:09 +0000 (UTC)
X-FDA: 85144978338.15.06167EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C3451A0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:15:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jwg1mBsn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787786108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUaMLPNhuDaYNJ0D8OpsuiWvuLoQ1w65HAWCQ0qaaRI=;
	b=rE8pPpnkwqL7Y9plVqpp0C/y7Vfxx7MAlACQhyYRjd+2DgVuMCHTzSsPtQ9cd6Bene0lYL
	Yf7rd60De8xrr1uDPpaXAlR3jG5KIX8TXPTsQD+eoEB2zmhaHEQcHNtx9krY84zlKdzYR2
	871cDUV9k8K0ObWe5heFVpP7sdzkKQ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jwg1mBsn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787786108;
	b=pagMV3KytkoWrp3gKrub4aKbv3QWKkiYsMiAaYbPH+k19FKrq3qM6iMlMXsA/KVy9W3Juo
	svLHBDnCJPnR8duBXa2xDHwFRA51/v0WgqoXZg8TsEUniNCEmhYQ2SDtpOlQSC2Z5laVbK
	Y06u4JunxQ344l9l3odfWARJRDakpsQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D55CE61886
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897D51F00ADE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786106;
	bh=YUaMLPNhuDaYNJ0D8OpsuiWvuLoQ1w65HAWCQ0qaaRI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Jwg1mBsnwMtqkVVzzMFGfQCThc1btDwD3mJ7wJaHS8UvvA/rFu4oJgn+Y9VYOL2Zw
	 AQr3u1wr+7wXmarpeIsQ7iPPK8i125aNwfUcdHXwoIo3FAx/5HcEi93YE58NiInHva
	 KTjaQc7I4dHL/yYzXPid8YPXIwQayoFRx1IR6u84Giy7ZuYDqAB9iH/12nAAfJ3uZ4
	 keEfIm8qgocd5PcPj6jfpw8FTrPpAOa/GnlP3bw4NgF+c4PRScn5FAMdcfqt2gQbKV
	 2BgDuEHxtsBt2cKTtJ74gfGFQSxd22in6wzk2iF7e3QIz3KdQW3NLGSJjo+B0Qqb4u
	 /DzueysUCHcbg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso238233266b.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:15:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rruzsnrry4QqBQnOF/6o1RxAaXtCaaiWvm5rGGPf8YKbeL0CmbcMipAZMGt51ObZ83D1R/l8w+Urw==@kvack.org
X-Gm-Message-State: AFuF++mnc0aZOPtc07gfAGgJrC5omRG4ld2o5io0SFJyJmt6TTeuEaVW
	B2Tl8Xdu1gjpf7kpdsMgjVI02bdgGbP0WSJynlt6zGIyiOWQ0DYHxvNrwuzqrfQkuhT99wF42td
	8lwQgu7rwVuTySWgpgoDDEfxx3SK532E=
X-Received: by 2002:a17:907:980e:b0:c25:2f12:1441 with SMTP id
 a640c23a62f3a-c252f121647mr587317666b.12.1787786105306; Wed, 26 Aug 2026
 16:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <1787017182353556.21.seg@mailgw.kylinos.cn> <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
 <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org> <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
 <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
 <ao9YFgBQJEy-85iB@linux.dev> <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
 <ao9q-m9k-NMxDvA1@linux.dev>
In-Reply-To: <ao9q-m9k-NMxDvA1@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 26 Aug 2026 16:14:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
X-Gm-Features: AcwNN1V63NfeSNegK4PJcDTArzQ_WtI1O3OguNxglcCIZITphCd5lzAAhhQ5eqc
Message-ID: <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joanne Koong <joannelkoong@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f5fwzc9mg6ei488ghui6e1pgcxonxepk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C3451A0005
X-Rspam-User: 
X-HE-Tag: 1787786107-467775
X-HE-Meta: U2FsdGVkX1/B35Vs0ZnJb9B6ty6/HewWqha/vTfYSKCd8R5E1A+p/rICqlF6CgoVw7XcaAcjIywu5sHi8LdewtqSO57V2CK36XNR3VRrs9He9S610AomH0IOWOVRoq+TrEr6JXkBW/sEKRcw9YHMQJOwclyh7XI71gD4pcX2LbPzlLwIcBGlD1EoTzazrjqHJ6b0lXMuaUpUD/fWer+RYj39Z8S9z83YnWStgsy3/s4Z3Q1xa32FX4kJSKELyyeCN8IAvErX/yvujrHK1l/DPvu58oyjOVfShQ/SyGMOvJWfJtl/hhgC5wXWZCUkoTehBS03mOZWQ0uKfTscFm7INrmB3dPijpIe5xGU/fxgeRBWm6bBGX551g4cwIzsC1beRZs0QLX+ZIbXp5RhaK1tgkcadtiIR34RDieL3D1C8uLmAZOyYuHBs8NVbRmIU5p/aRvu+W5Ps58h1ByJmkxyHJ4zva8QtqsgINc90WIa7GbO8U3w+WCtawx7kP2eL9np/oLD/f1DijY97vOXEJQuodnPbmZ3me+WLMk2aR5hXxU1+nupwGoUgHw+t60ZxbQ9HIQnZikRZm0LafIKQ+yoH0MYLV5tI8LMg+O0nlG+RZBSnFsUehsfKQ7Bs2N+utuiHNxCxCORBCXIEa5h7zcLTefRCJ9zIcM3owkdUubAUAyxvDvh6UKKadVVLaWwRmknxbM+To0N/pc7YHDRIsprRT1ofOIV/tq9TOs1EqdLaed9KTY+xqgrqf3IV+jDSZso1S9GLrc5hGn8FFMgBXDaWZ8k2KJEIFFxjfHehalJQTaEDcSexHXlhgMzCl4UCxAOHLNI46VWjgvt9x7DjGxf+40t0GT3GLeejcq16spjFhX7CuBrcSxIjJxl3GBGKdhsMBPaaVCXprtQXBQy+V+4PCiXnd15OvZo+0jeIUkbPt711MBkZ446MBp/3STnItamomVn8j0mYHtUUg46vBl
 tudv2GqW
 zuwOJSXIGxZsz7OWW4f5Z8+E5CWdaXvGH6HLm2Ug+c4ehobWcXTnjRUV/urhk6ge9k5SSPylqyWS0WBU5XRWHIurcuwjx8SJ4TIAAEEPwq2mv0YsWqOnE7ZTh8Sj/j8E4+BPoZqyr1mkGgKyDZ9DzlF8/pHSmBo/BoL4Y8X5IOg2id0ZKrOvXUpiSC4PGo/epAD/0Edu/snO3csWWSvGBjiAQ5JmcL0jiWXf9qvSD+YUesM7IojQlFwLdb9KmxbLqSv0D92xsw7QSyluGxZsLckBhhkPYC205JuTuLfyzdDreIGBTfsUAw9FePF4OpQmEnFEQogFgU/M48H0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 4:08=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Wed, Aug 26, 2026 at 02:55:57PM -0700, Yosry Ahmed wrote:
> > > >
> [...]
> > > > If (c) is holding up for writeback and vmscan, I would question a m=
ore
> > > > radical approach of tearing apart the rstat framework and using it
> > > > across the board. That is obviously a heavier lift and more
> > > > controversial,
> > >
> > > Yes controversial because we used to have similar mechanism which did=
 not work
> > > and we had to move to rstat. Check the commit 42a300353577 and fixes =
to it.
> >
> > IIUC, in that commit, the update side modifies one per-CPU per-cgroup
> > counters, and when those counters exceed a threshold atomic updates
> > are performed on all parents, which I think is the slow side. Then,
> > the read side just reads the potentially stale atomic. That was
> > problematic because:
> > (1) The update side can end up performing atomic updates on all parents=
.
> > (2) The read side can be inaccurate by up to MEMCG_CHARGE_BATCH *
> > nr_cpus * nr_children
> >
> > What I am proposing in (c) is different:
> >
> > (1) The update side always updates per-CPU per-cgroup counters in all
> > the parents. It never does atomic operations. The parent iteration is
> > not cheap, but it is cheaper than atomics for sure and we already do
> > parent iteration today in some cases in memcg_rstat_updated().So the
> > "slow" path should be the same as today.
>
> Yes but that parent traversal is short circuited when we hit the flush
> threshold. At Meta scale, we have observed significant cpus being spent o=
n
> memcg_rstat_updated before that.

Interesting. So the upward per-CPU traversal takes time? Perhaps due
to concurrent flushers causing the cachelines to bounce?

>
> > (2) The read side always iterates per-CPU counters in this cgroup, so
> > it's always accurate. This might be more expensive on an rstat flush
> > on average (e.g. if memcg_vmstats_needs_flush() skips the flush), but
> > it is much more consistent and the tail latency is much better.
> >
>
> It might be or not. Usually such things are more clear at scale in produc=
tion
> instead of benchmarks.

Agreed.

>
> > >
> > > This worked for zswap stats because their update and consumption are =
not on
> > > performance critical code paths i.e. these are on the way to compress=
 or
> > > decompress or in reclaim context.
> >
> > Well, decompression is in the fault path, that's performance critical
> > to some extent (although not like other stats updated by networking).
> > Anyway, I think the update path shouldn't regress much with the
> > approach described in (c).
>
> Decompression is on the scale of micro-seconds (and I suspect the simple =
minor
> page faults are on nano-seconds scale) and the upward traversal is defini=
tely
> much cheaper and will be a noise there.
>
> >
> > >
> > > > but if we can get away with it, I think it will
> > > > simplify things greatly and honestly rstat has been causing a lot o=
f
> > > > trouble in the last few years.
> > > >
> > > > But this can be done incrementally too, we can start by separating =
out
> > > > the problematic stats to use the new update/flushing scheme,
> > >
> > > This I think we do need but for specific stats. I think the stats whi=
ch have
> > > in-kernel consumers need this. However not all such stats might be fi=
ne with
> > > slow update side like zswap. So, we need to evaluate thoroughly.
> >
> > I think in the proposed approach (c) the main concern is actually read
> > latency, not update latency. So if it works for in-kernel consumers it
> > should definitely work for userspace consumers as well?
>
> Here I was mainly talking about consumers which has more strict staleness
> requirements and those are mainly kernel consumers. Rstat flushing is def=
initely
> more expensive than this for-each-cpu traversal and most of the time they=
 just
> need it for one or very small set of stats.
>
> I am imagining once we have this special mechanism for selected stats, we=
 can
> potentially remove ratelimited flush and stats update threshold code.

Yeah that's the hope. I was basically saying that I am hoping for
more, to transition everything to this flushing scheme if it works
well.

Anyway, as you mentioned, ideally we need production data to proceed.
Joanne, is this something that you are trying to collect by any
chance? :)

