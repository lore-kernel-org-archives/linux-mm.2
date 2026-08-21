Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6347AC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770736B00AF; Fri, 21 Aug 2026 15:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747FA6B00B0; Fri, 21 Aug 2026 15:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685076B00B1; Fri, 21 Aug 2026 15:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 440476B00AF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:28:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B828D8024B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:28:34 +0000 (UTC)
X-FDA: 85126263348.21.90A712E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1F87100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:28:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWRfRyTh;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340512;
	b=Mvanzvo3nggPPxxemtK77lW8vRhU3FlajDlSAN+Vwd9k/SL2nJgx9lyXGPAuuxbXGZXNVm
	uN2kWDNMJUwLB4Je2f+yCk14KH+2TeyTIZb4GUEPLiRSdSK0PPeEgquru0lDRy7sSg7o3z
	30hf1a9TVaBGD3qGE4A7XfBZptSGv24=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWRfRyTh;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQYbTMCroEPMgyDjWcLZcr196dy8ViWXT6a0e3vEN0M=;
	b=XgT1cdcZX2DbdCEztTrTYBo9mNc7IGAd4eNkRNz/tlu/7gEjJKPpAV92TAZcfu6VQyze4v
	GGIdzwlB2ZF98JEus1/a6X91iXNyW7vXUsDGdI05aoiEktGcNh9PqEtClmOAQmOt5ijV7A
	Xq07y9ytFJsT/XUMGxlhruQJsFAwTsk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FBB46136F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059581F00A3F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787340512;
	bh=FQYbTMCroEPMgyDjWcLZcr196dy8ViWXT6a0e3vEN0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OWRfRyThBSFDHDyK2iXoKb+NXHUY/T/H5L/Epxy9hs5B4q0twA+FUyRXl3cIB1s/J
	 CLRd34pG6JZD6aaW/GvKxfnXqZvodYt+AFXLSSlW36lzuKj5aVqd+VyLz2iGaEMIMW
	 DVPKRSi2OPz9LV+C8rCWK2Mv/GclTR7q4Lm9/BQuVqwWCUOS8i9d+hrCbGrGIalalH
	 Y8VqkZnCwbcAGKYNoHawjQBFAC4zODa0zwj3pE9h4pc53/gd+dgHoB2hLFlVv8vdmG
	 wSFs5WPtEUrkdvry70zPNKF1CBYxLiwbfbQhGg7LaAWF3yII352DBq8y7/3mtYiGI2
	 whJaDBrccA9HQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1c52d920b8so200489366b.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:28:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrnNEBYJ9y2+ygemAKPYRvfWWs3aeVx13HChEjjveL6XLYIRbnNOckBvDMSM57AS41aUdSuBgCl7Q==@kvack.org
X-Gm-Message-State: AFuF++kd+7jDKzO6DguIBs8cX+3YTtvraVT/+cUnQMSAz+NbRVCOUXoR
	dlkgQCDDuw2ImsxRmuET+rLtMdJWRgF93JuOeq7fPLe3Pzo8FgJMpyXBz7g+DzzTOLmo1j4F5wg
	w8zPgcW245SNKQTqn0K4TOBeUdf54EkQ=
X-Received: by 2002:a17:906:6b86:b0:c21:74ad:8b7a with SMTP id
 a640c23a62f3a-c246a398994mr687022066b.9.1787340510881; Fri, 21 Aug 2026
 12:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com> <aoiQPrudvYZ76ZSD@cmpxchg.org>
In-Reply-To: <aoiQPrudvYZ76ZSD@cmpxchg.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 21 Aug 2026 12:28:19 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
X-Gm-Features: AcwNN1VUj4vml9Og6DbNDfvzAOBRtd1vwJMafEv_tIx0EqpC1URSYX4CJdr3k8o
Message-ID: <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1F87100005
X-Stat-Signature: 8wcsd5iqptnmd6pew1wn6dawp3jq94ie
X-HE-Tag: 1787340512-192471
X-HE-Meta: U2FsdGVkX1+rh7sJgd53uapXe8fjyrdjvMmeTIXHTF1eU08oHjadEGqSZP7ntgPYMQ6wvqWd0CU0vbvsnaapP9zMSA7Z9cCJ5M/QToRv7TcelxZrULlNlcTOiNBZoW9RGEoEwjp0rnAm3UvT9WqQSbPXdTEIxH8NlvgVBGI6ERRD384Qlrz59O7eFMVfyrt3fgQIWKhzu5iUqdfr14XtcgIpbF2PWxDFpsBsaQuwFlvKthh6xTMeSQ4GlVpVbhOfL8c45A9tvgOJT+iAweT/U3iwKrqAqmYr/5bDRJOL++aJQct7gV6k6eBaeC2VdqlPvUy4ebW9fyXTrdY3g1iynP5LzL+zlrrZ9rcUPaJdfXDU8n5F7O/rdfi/uDESGncCjjBqhqmkhAPHc6pOEGXUsxlqkSbliWrU9BQPMFn5Ta+N97fEbZHPf0uEMgHJRyf6niCpmypoLk4iB5XUseldx99NOXXmtbUfJeq8mWT+I/zOvsR6GGyne44VHSIZy+eJgEVvQbH2PWuh47NVc9ujD9aPOOu5wVFWiJTPu8R8AhhvjMbTFiDen58iE2fq4F2bNhhIxbEoOKSANTjEV1j1aC4GcDvSZ1hlUdmoJxVs0IiUgku9tqzJ6Cvhn+ovtSjEY++hVEm8OZ6GvdhdHQgPtgPjdsxyBuAOFrG0YQQApyLHH/WOISeFQEpPqjXjO6fVkN/koMEu9TRDGkAzpUU/ycUPNpsRaJMBXA5Ct4AX1vBv2864woO2ZH7flXEJxA5Nh6HDd3Z3kyQ6U1FL9VgjiKpXmVHQ8+XdOSmgm4L2U0/nDj1eTRwLz+CYZg0mOTHsrrMHTyhPK7mL9P20E0Q2Ze3+J4UIys9/gQbR77MepRppZ/uA4Eaf+MklcqB9Ge2MLXAGZz1mcd1wmj0708MoC4yFcOZN2duu//tBKNMkuebAIqNM92rBhyDLomk1eIqstGcx87jWlrKLrtu2g9M
 8ISmwxLF
 koLlH07YTJ+5G6pEvGmqcPdDnR3Jr+STz8g2ZFpvktplEA5W63bmzP/vah+cWZN0azC5jVJcSBtDksFXCjpjKXmn2eQQ0M/S5KM/jVWN08MneVo8VVcGe84Qel1hcc+/aVnDHFlN5eHUtGRIH4imCMKZHl/oAw2rk+oQXWFqeSeWir0+QIHWvYn4EO1qWoQl7P/i7Vbekd8dsatKb2GWtyzA78NnUNFMC7g6ZsLMoP//+PdRHk/itV7dzr6JKW4xGCUsaHoT7/znyg+I9upriNEabs3RWDuV5n8BTDw8GD+q0MmpMr2T9pfWIMtGU8LZzMfgQ9Dxbe03FNu3elZeIZYFAtZhvwqmm+rAhPIXbpI0XsyP+NIYPVdWP0EjhkdJbThZyAnUWHJ81FDlSaEU0Ntt7FkvNeak1zhLu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 10:52=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Thu, Aug 20, 2026 at 03:18:39PM -0700, Joanne Koong wrote:
> > On Tue, Aug 18, 2026 at 11:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> w=
rote:
> > > >
> > > >
> > > >
> > > > =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes t=
he
> > > > >> cgroup rstat hierarchy synchronously with force=3Dtrue, which sk=
ips
> > > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap stor=
m
> > > > >> with zswap.max configured, a container takes the global rstat lo=
ck
> > > > >> on every swapped-out folio.
> > > > >
> > > > > Any reason you are limiting zswap through zswap.max?
> > > > >
> > > >
> > > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > > can soak the pool and crowd out the others.  zswap.max is the only
> > > > per-cgroup control over that share; memory.max bounds the total
> > > > footprint, not the share of the pool.
> > > >
> > > > >>
> > > > >> zswap_shrinker_count() had the same pattern and switched to
> > > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count(=
)"),
> > > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > > >> kernel cycles under osq_lock on a 96-core machine.
> > > > >>
> > > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > > >> before the patch and 198,968 times after, while
> > > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > > >> attempt count almost exactly; the remainder comes from other sta=
ts
> > > > >> readers in the swap path.
> > > > >
> > > > > This is a known issue. Using ratelimited interface also comes wit=
h a drawback
> > > > > that the kernel may react on stale information and the consequenc=
es might be
> > > > > unneeded oom-kills.
> > > > >
> > > > > There was orthogonal discussion on moving zswap limit enforcement=
 away from
> > > > > rstat. Yosry, any updates on that?
> > >
> > > I am not actively looking into that, but Joanne was looking into
> > > AFAICT. I will respond to the thread there and CC Song as well.
> > >
> >
> > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > (switchable behind a runtime knob [1]):
> > a) rstat + forced flush       (baseline aka what the tree does today)
> > b) rstat + ratelimited         (Song's proposal)
> > c) hierarchical per-CPU   (Yosry's idea from [2])
> > d) page counters              (following what all the other memcg limit=
s do)

Thanks for trying this. I actually thought about page counters but
quickly dismissed it because zswap needs sub-page charging. I see you
are using the page counters here as byte counters tho :)

It's probably fine, I think the risk of overflow is low (at least on 64-bit=
).

> >
> > For the setup, the benchmark creates a cgroup chain at depth X with
> > memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
> > every level, and spins up 20 processes there that each allocate 100
> > MiB, fault it in, and touch every page four more times. With that 2000
> > MiB against the 1 GiB memory.max, it triggers reclaim continuously and
> > makes the swap traffic go through zswap. The machine I ran this on had
> > 80 CPUs.
> >
> > I also ran it with no memory.zswap.max set (ie no reads triggered,
> > only update path runs) - as I understand it, this is the configuration
> > that is more often used in practice.
> >
> > These are the results I saw:
> >
> > kernel cpu time (in ns) per zswap store, zswap.max set
> >                       a)                     b)            c)          =
      d)
> > depth 1        567,116          35,604     35,841     34,995
> > depth 2      1,082,007          35,507     37,803     36,209
> > depth 4      2,153,329          37,591     40,117     39,893
> > depth 8      4,211,692          34,963     41,070     44,211
> > depth 32    15,728,220       53,575     94,685     65,946
> >
> > kernel cpu time (in ns) per zswap store, no zswap.max (update path only=
):
> >                         a)                  b)              c)         =
   d)
> > depth 1         34,787          34,062     34,930     35,630
> > depth 2         34,913          35,061     36,404     36,360
> > depth 4         36,422          36,809     36,922     37,483
> > depth 8         42,177          34,440     36,679     40,793
> > depth 32        55,309          55,321     57,671     59,190
> >
> > c) and d) are for the most part pretty comparable to b) without
> > introducing the staleness problem of b). Between c) and d), I think d)
> > ends up outperforming c) as the # of cpus and depth gets larger.

The main advantage of (c) to me is that we can probably update ~all
memcg stats to use this scheme, or at least the problematic ones, it
should be generic enough. Also, I have a concern about (d), see below.

> >
> > I'm seeing that all the other memory limits (eg memory.swap.max,
> > memory.max, etc) are already using page counters. Is there a reason
> > the zswap stat can't? If not, does it make sense for the zswap stat to
> > switch over to using page counters?
>
> Thanks for running these.
>
> I used the vmstat counter on the assumption that setting zswap.max is
> rare and the counter is maintained anyway for memory.stat.
>
> But I never actually tested it. The assumption was that surely walking
> ancestors on a quick if (max =3D=3D PAGE_COUNTER_MAX) continue would be
> much cheaper than page counter atomics at every level. And so I'm
> surprised by your results.

+1.

I previously did an experiment with per-cgroup atomics (should be the
same as page counters), and it scaled more poorly than the numbers you
have here. I was running tests in a VM on an AMD Turin CPU, and I
think I tried 10, 20, and 50 processes, so maybe I pushed it to the
limit. I remember seeing a large regression with 50 processes. I used
bpftrace to measure the latency of zswap loads and zswap stores.

Would you be able to also collect numbers with >20 processes and with
zswap loads? I think latency of zswap loads is more critical because
it's usually in the fault path. One other thing is, you need to be
careful with zswap loads because a miss will be really fast, so they
will pull the average latency down. Ideally you'd only measure zswap
load hits. It would also be useful to see the latency at the tail
(e.g. p90, p95, p99), as people usually care a lot about page fault
latency at the tail, not just the average.

Sorry if I am asking too much :)

Honestly, I am not sure if >20 processes is a practical concern, but
zswap load latency is.

That being said, I generally prefer (c) better because it should scale
with more concurrency/CPUs and should generalize better to other
stats. But I am obviously biased :P

>
> But that was the sole reason. If it doesn't stand up to benchmarking,
> no objection to streamlining the control to a standard implementation.

