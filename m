Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110CAC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 21:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF556B008C; Mon, 24 Aug 2026 17:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70866B0092; Mon, 24 Aug 2026 17:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87016B0095; Mon, 24 Aug 2026 17:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A465D6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:16:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 302BD1401CA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:16:57 +0000 (UTC)
X-FDA: 85137422874.01.DA5A798
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3805318000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:16:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYAiNdgT;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787606215;
	b=xDo/n3GBnT4pe4vqt7ErhNvPzzV1CGEeM3StHt6Dzas2l+Fb1BZ4By0ETnx++6Dhox3PK7
	MazYgyngjh+bSwygnOR6SxUX+VnIEjfJKHWOBJ2H03DGhX1f8AaoLNjvfMCWREX2e+wNJb
	SN9w/otj6cRuR8CHaxJhKhhjWcQXlsc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYAiNdgT;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787606215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQKZF1h/N/D4mrYJD6sBnacAt/HDiKC7c3EIhWl4soU=;
	b=kHLHC/mv8TnIBT4mzuSoFdB1/rLdKyOwHVAaJwpX6xF//8qodHHlUEz3LqlmGam49sVQD2
	nsX+otWP4178zs7l8XFMSyV0mKSfblGlHL/1vIOzvyKXsaiebp2/CjpZZhrE4dUzmDOlEd
	qTFNPl+gMhE6E9qlTAutEtD3ET2P9E8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1595D43D82
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E173F1F00ADB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787606213;
	bh=EQKZF1h/N/D4mrYJD6sBnacAt/HDiKC7c3EIhWl4soU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dYAiNdgTvGs4RghXgi3/Mqm7lxwh76Z/tWL2/PiCEuqV/pi9Zff4zCNhSOai7pyVI
	 6sovKO2wjrESAYgiF0KHyWpQMvslU6D0imTD/9UYRNb193EN6I0NJQ+/tck0PMktIZ
	 wzBuVo+7oN10wvB18CU9tABcv/hmrBz7geZNYKRT9/8lXx0l2RnOw7BlJ9USX5mQM0
	 5rnytc8lWNvN3RlakrJHbrwenNTYT2i4m3GJ6dxh3qziW0z3MhX5+Y969YYs6cOabT
	 oQgL5z3iZRMMElDufkx6jbXaTcmjzBuGXVnagQahE1PMDmY1D7pqjhTVdhKBVW6n70
	 MLgI+ifEBjtKw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2074710751so732686066b.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:16:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoMLm4m6XzXlZdmbdafG4wWyMqPW7sXqnUc7gtVdlCc35/hGMCPBi/s8Q0SUkzd7SAV2IAZjgn1tg==@kvack.org
X-Gm-Message-State: AFuF++m6gHqqfQRLeeev+L2SrRnkMCl1XshwK1SmtsjOBr06kFlsi4Ey
	psOJyC+jgNsrhqqbXB25onfkc5zNfj+AbH5qwmIuqCn2pgSffIPLTOZKvpeZu4wSqylFijK4j6w
	RFbSy/1ANcW1cAFiZ/AzML5wjyJMDzVA=
X-Received: by 2002:a17:907:7b87:b0:c21:757:1bb4 with SMTP id
 a640c23a62f3a-c2492091991mr2465690466b.16.1787606212708; Mon, 24 Aug 2026
 14:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org> <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
In-Reply-To: <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 24 Aug 2026 14:16:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
X-Gm-Features: AcwNN1VhF-DW-ANxUu_icTydPBNd0qB-gIH9lvZbCtnw3opyxxp2c2Is8e9iQjM
Message-ID: <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3805318000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rtxo4i5kbbbjt687qh4ih5f7wkxxk366
X-HE-Tag: 1787606215-599320
X-HE-Meta: U2FsdGVkX1+v5Vgp6XN+ojGqCUyYQ0/auMaIi+yIVwGNisEk9pdvXYh+vv8mwaq8GsWdzuo0yVuZGIV3CjNevixqf0q8HfdrwzYoAxiRg8ZgsDyMEWKdAyABYsTSK7uN0jU51KTjUgFp2GnOt/lBES+VCXTWSgjcXZXzBsFQNO+JhWuaaKqGYwrAkaXwskDDc/dJ6z8C1Kabdk/GtNbrtgIg6iT9m72/ZeekwMWQW56UtiSzhKki/VEd2eV/zNFG27SxPtNv5dDCPvCZDJbxzdeNcAfPeMkLTInAUw7aiU4ZpDLxx45aQv7XhVJ35ppCFTwL/o9W6A1BRukw4KhkMNibkWAzvWgX5pEcJboYu8TeNai17SHPsm+ZvxxsyX69tdmSxMyD68MfI79uK6/XwKNiGvCmjvL3FO02SwPN2FzszGN/0HTanF+tBSal8StHlLGUqaap9X3g2cbpysFI/ajUhAU+i0lahQ6vIKnG5ybHEvdIGAlC8SgWlXfoQcpY+Kr7sgwD6w4bJhN/0lG7SPLf37yMyw5qL9WIbpoBBYWIbuViBaXwxLh9Xs9eFor9YQejYy+deKyP7vAep5KM3hBFdTBjsRIfR9qurZ1fwvowj/1y45M8Vj5c+1avowttys178nCgTaCQw02nfiMgBYivsG26DGnrQhfSspPv8oA4U4uJC+L5Nbpj+c6WC4gx8G5iTBxW3ftN5nXr2R7PjiHlajtGu7Ez0N3u49Vt5INR32WbTTSZ/emkx+EPl+nW5r1yGW70LdOXQ3qeeZ1sQmTW7lqIj11JPNh+vi44vOVfXjWDaBkuJObhBseUohb8Ap7g9KoypHGlDi3FU9dfRnny/+kFXtrCr73RGKXV+C+tliEEM+8jr06Y7hXdugDE/Rdgj38RlOY+VcC5x7Pn3jNI034IAs0BHjcQapK+hGXGRYdkPALbJ4ym1aZTGFfHsnHiv9IVoMys07dv7Y4
 kHh6jg6D
 z8WTdBLp/9+W44xX4aHIa2j6TpoqKQ0FpeJKBP1PFkCWE2XID7hjJvQEH4s85qVzM3PXkNNcuxD3f5u4nz1769MTuhiCDRZTDfkqlophcxVuaNuqBe07scOGwENSiE3TjFQoCoewI+u0L5pjmZKVZfR+JNdsAkxPdheMf8ppeN570/Ep5JiHiWduTJUfgvYHPVTrTHpQ7PKy/OWRhaMrds+mF8svbxg5G2/hC6301Wxv95gU/VPy9QyyYYMPxtAdwyFU4cFPXPRgGvm3uQGmtbpigmQIq/Ye1NsBB+O8YRq9JayBvwpJkyf7LGeqdeh6uFf4XQCD89jTA2wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > > > (switchable behind a runtime knob [1]):
> > > > a) rstat + forced flush       (baseline aka what the tree does today)
> > > > b) rstat + ratelimited         (Song's proposal)
> > > > c) hierarchical per-CPU   (Yosry's idea from [2])
> > > > d) page counters              (following what all the other memcg limits do)
> >
> > Thanks for trying this. I actually thought about page counters but
> > quickly dismissed it because zswap needs sub-page charging. I see you
> > are using the page counters here as byte counters tho :)
> >
> > It's probably fine, I think the risk of overflow is low (at least on 64-bit).
> >
> > > >
> > > > For the setup, the benchmark creates a cgroup chain at depth X with
> > > > memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
> > > > every level, and spins up 20 processes there that each allocate 100
> > > > MiB, fault it in, and touch every page four more times. With that 2000
> > > > MiB against the 1 GiB memory.max, it triggers reclaim continuously and
> > > > makes the swap traffic go through zswap. The machine I ran this on had
> > > > 80 CPUs.
> > > >
> > > > I also ran it with no memory.zswap.max set (ie no reads triggered,
> > > > only update path runs) - as I understand it, this is the configuration
> > > > that is more often used in practice.
> > > >
> > > > These are the results I saw:
> > > >
> > > > kernel cpu time (in ns) per zswap store, zswap.max set
> > > >                       a)                     b)            c)                d)
> > > > depth 1        567,116          35,604     35,841     34,995
> > > > depth 2      1,082,007          35,507     37,803     36,209
> > > > depth 4      2,153,329          37,591     40,117     39,893
> > > > depth 8      4,211,692          34,963     41,070     44,211
> > > > depth 32    15,728,220       53,575     94,685     65,946
> > > >
> > > > kernel cpu time (in ns) per zswap store, no zswap.max (update path only):
> > > >                         a)                  b)              c)            d)
> > > > depth 1         34,787          34,062     34,930     35,630
> > > > depth 2         34,913          35,061     36,404     36,360
> > > > depth 4         36,422          36,809     36,922     37,483
> > > > depth 8         42,177          34,440     36,679     40,793
> > > > depth 32        55,309          55,321     57,671     59,190
> > > >
> > > > c) and d) are for the most part pretty comparable to b) without
> > > > introducing the staleness problem of b). Between c) and d), I think d)
> > > > ends up outperforming c) as the # of cpus and depth gets larger.
> >
> > The main advantage of (c) to me is that we can probably update ~all
> > memcg stats to use this scheme, or at least the problematic ones, it
> > should be generic enough. Also, I have a concern about (d), see below.
> >
> > > >
> > > > I'm seeing that all the other memory limits (eg memory.swap.max,
> > > > memory.max, etc) are already using page counters. Is there a reason
> > > > the zswap stat can't? If not, does it make sense for the zswap stat to
> > > > switch over to using page counters?
> > >
> > > Thanks for running these.
> > >
> > > I used the vmstat counter on the assumption that setting zswap.max is
> > > rare and the counter is maintained anyway for memory.stat.
> > >
> > > But I never actually tested it. The assumption was that surely walking
> > > ancestors on a quick if (max == PAGE_COUNTER_MAX) continue would be
> > > much cheaper than page counter atomics at every level. And so I'm
> > > surprised by your results.
>
> I think your assumptions are correct. In that second table above (no
> zswap.max set, only update path runs), d) has worse performance than
> the baseline a) (except for depth=8, which was a noisy fluke). Rerun
> with 20 reps, I saw similiar-ish results:
>
> depth       a)                       d)                       diff
>      1  35051 +/- 116   35635 +/- 149    +584 +/- 189   (+1.7%)
>      2  35603 +/- 142   35859 +/- 179    +256 +/- 229   (+0.7%)
>      4  36358 +/- 115   37761 +/- 167   +1403 +/- 203   (+3.9%)
>      8  39537 +/- 178   41225 +/- 240   +1688 +/- 299   (+4.3%)
>    32  52181 +/- 210   59042 +/- 161   +6861 +/- 265  (+13.2%)
>
> I think the atomics do cost roughly what you assumed, but compared to
> the overall latency of the zswap path, it's adding hundreds of
> nanoseconds to a path that takes tens of microseconds.
>
> >
> > +1.
> >
> > I previously did an experiment with per-cgroup atomics (should be the
> > same as page counters), and it scaled more poorly than the numbers you
> > have here. I was running tests in a VM on an AMD Turin CPU, and I
> > think I tried 10, 20, and 50 processes, so maybe I pushed it to the
> > limit. I remember seeing a large regression with 50 processes. I used
> > bpftrace to measure the latency of zswap loads and zswap stores.
> >
> > Would you be able to also collect numbers with >20 processes and with
>
> Beyond 20 workers, I'm seeing that the additional workers basically
> just queue, without improving throughput much. I don't think this
> bottleneck is related to the accounting method used though. a), c) and
> d) all are within 1% of each other at 40 and 80 workers, so all 3
> approaches are bottlenecked by this.
>
> > zswap loads? I think latency of zswap loads is more critical because
> > it's usually in the fault path. One other thing is, you need to be
> > careful with zswap loads because a miss will be really fast, so they
> > will pull the average latency down. Ideally you'd only measure zswap
> > load hits. It would also be useful to see the latency at the tail
> > (e.g. p90, p95, p99), as people usually care a lot about page fault
> > latency at the tail, not just the average.
> >
> > Sorry if I am asking too much :)
> >
> > Honestly, I am not sure if >20 processes is a practical concern, but
> > zswap load latency is.
>
> Ah, thanks for pointing out the zswap load path and its relation to
> faults. These are the results I'm seeing:
>
> zswap_load() latency, (hits only (retval == 0), no zswap.max set, 20
> workers on 80 cpus, 5 runs, ns):
>                   a)              c)       d)
>   depth 2
>     p50        6,850      6,700    6,850
>     p90       10,000    9,750   10,000
>     p95       11,050   10,800   11,000
>     p99       13,600   13,350   13,500
>     avg       7,269    7,128    7,297
>   depth 4
>     p50        6,600    6,500    6,700
>     p90        9,700    9,650    9,950
>     p95       10,800   10,750   11,000
>     p99       13,350   13,250   13,550
>     avg       7,034    7,029    7,266
>   depth 8
>     p50        6,000    6,150    6,750
>     p90        9,000    9,250    9,900
>     p95       10,050   10,300   11,050
>     p99       12,500   12,800   13,650
>     avg       6,508    6,652    7,273
>   depth 32
>     p50        5,250    5,400    9,100
>     p90        7,900    8,050   12,550
>     p95        9,000    9,150   13,800
>     p99       11,550   11,700   16,450
>     avg       5,786    5,958    9,469
>
> For depths 2 and 4, there's no real difference for d), but depth 8+
> shows worse performance. In Meta's fleet, hierarchies of depth 8+ are
> common.
>
> >
> > That being said, I generally prefer (c) better because it should scale
>
> I now prefer (c) as well. I hadn't realized setting zswap.max is a
> rare path until Johannes mentioned it, and with your mention of
> zswap_load() sitting in the fault-critical path, I think the benchmark
> results show a clear improvement for c) over d) at higher depths.
>
> I was uneasy about the cost of c)'s reads scaling linearly with the #
> of cpus on a system (ie for_each_possible_cpu per level), but given
> the uncommonness of the zswap.max path, I think that's the right thing
> to trade away. Either way, it's a big improvement over the baseline a)
> path that currently exists anyways.
>
> > with more concurrency/CPUs and should generalize better to other
> > stats. But I am obviously biased :P
>
> I'm still investigating the writeback and vmscan cases. For writeback,
> using (c) is more complicated since NR_FILE_DIRTY and NR_WRITEBACK are
> node stats. I'm planning to spend time this week running benchmarks
> for it.
>
> If for those cases, (c) is viable, then I'll send a patch that adds
> (c) as general infrastructure. Otherwise, I'll send out (c) as a zswap
> specific patch.
>
> Does this sound good to everyone? If there are any objections, please
> let me know.

If (c) is holding up for writeback and vmscan, I would question a more
radical approach of tearing apart the rstat framework and using it
across the board. That is obviously a heavier lift and more
controversial, but if we can get away with it, I think it will
simplify things greatly and honestly rstat has been causing a lot of
trouble in the last few years.

But this can be done incrementally too, we can start by separating out
the problematic stats to use the new update/flushing scheme, and then
do the larger overhaul when it holds up.

Either way, thanks a lot for all the work you're doing here.

