Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACB3C5DF97
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8BE6B008C; Sun, 23 Aug 2026 23:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0716B0092; Sun, 23 Aug 2026 23:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C756B0095; Sun, 23 Aug 2026 23:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 547DB6B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:05:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE005C03F2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:05:21 +0000 (UTC)
X-FDA: 85134672042.17.25C06A3
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf09.hostedemail.com (Postfix) with ESMTP id A2BCD140003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:05:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sO9BQ/fq";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787540720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CycmvM2fajUETRfArGp6auHoCgCbKeON5qQKnKERhQo=;
	b=2HnI/7Z9HAw4EuQ1ykPVPGjK/xyId0chmVux8SD9eB+/dOroENQGwOpkB06Ao4bCi2Ozkw
	ZGJKB14HUN0IV5530k0M8eLDLIxWfF2O+RFRKR87KPxPhzB176bHmbcMOINM7nUCC3EYiH
	GYqbQWgeZPKlx2pTIt6OuEVEVwY1H54=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sO9BQ/fq";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787540720;
	b=qU78895RQTW1Ya5lDLxGlXmb01rlL76kyIZdqV/wqR02C0gKtro/eGjOzbtTFHG+0wELHh
	XBnEB5ViefnUjoHw79MqWwuDMVGQaaQNESt7HvTjsHjFiKGaGe++r8BX8RM+JYEvy4uG0D
	PvdRgZVYdXL4P2dqJTfW/ZpzThALWIU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TqxJYfxm291IpdzCBiyyGro/c+1ngMIo68kvFi7jpgw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787540718; v=1; x=1788145518;
 b=sO9BQ/fqXTkAmaWH0m41sN8IgWKMQ8Ncx5UzT2kiVFPJpbi4mwuVsbOk4d9NrIU9PUU3NFby
 DfvOjNHkjcaw/GOjMxjXf4JZy29sUkR59iTGdZGT1cL5m2gIU2tpoFK2i7ggZZZCQrx8i8FEeYi
 qz///EzoKDUH39Jughydfqss=
X-Envelope-To: linux-mm@kvack.org
Received: from webmail.migadu.com (2001:41d0:303:fc7a::)
	by smtp.migadu.com with ESMTPS id 900464cc304e1d33;
	Mon, 24 Aug 2026 03:05:17 +0000
X-Mizu-Trace-ID: 900464cc304e1d33
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Mon, 24 Aug 2026 03:05:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <90ff25cba63491e21a29e92b99f884bffde4eba2@linux.dev>
TLS-Required: No
Subject: Re: [PATCH mm-unstable v4 0/2] mm/vmscan: fix NR_ISOLATED accounting
 and throttling for MGLRU
To: "Kairui Song" <ryncsn@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Hui Zhu"
 <zhuhui@kylinos.cn>
In-Reply-To: <CAMgjq7BSy0ReiwsJzDroQUZuJ+W8eakjRdUOyVxSJJDkUo1DFw@mail.gmail.com>
References: <cover.1787193916.git.zhuhui@kylinos.cn>
 <CAMgjq7BSy0ReiwsJzDroQUZuJ+W8eakjRdUOyVxSJJDkUo1DFw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: wospm1frjjm8dso1jctcuxdax9kxn6m6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2BCD140003
X-HE-Tag: 1787540719-353406
X-HE-Meta: U2FsdGVkX18CiCDHap9ALErCk1+7q0obHQC5IlOaytHuvZQeXrD9RJzLS9DL1Giy7zGrBrGS/QSz7dmpmSWXMIURfuIPsfC9COQwFHmXAFbuQmF9ysMvVf+nWqLYXXnOtnjzvDkwJRXXmb3x4hUa/WhLCCAONhB3x3feqCZpv09zsfXCVTWNqD8cd43I4hO0Vs/kgxnxZ2vF85qqsHWc/I7mT49qhZo1verQVR53DUkzj0D+9UUIOzC/CmblRkEGHrgS7MnErD+7Pin8QLZnAj3vACAV6KX1t7Mr8Jl0rpCAo48XUrbhLN3YUoJ1myjkedfuCbcHP/HbMuBEIjApplxSZ+ncRi0QX+o9+lvxlhCu1pYk48oagP9XzZZChpFrGX9vl6yWYMbnCo9iwQvUFvKLk5LuiKconwRKabvAVX7KDHVmBBaflbe0lChf0fDV6fFP2wKTgnEWJbCM/4WKMKi92LzkW1eDjTFuH6CHMX/Pt/XEtnWd+YmSa8rzl64GCvlbzR6x5/fiC/VwqEStfunuTBR7rcBlR+rGQkNVoesoDVMBW+wpqiPbIjLErFXpK2RdBBSmcNnAcLMu+Q+3j54ApP9NK92xXx7rHQKfAIdpSeIUms1VdsvEMAxmgjZRBCGI6c+4ap2lKOGGs8rDhr7G3xM/a9JbO6bnxVfETBOYcOlQ4SyKLUGhU7A4vVzc5+3r0lAPuWs55t7Lxl/iPwG/xhmWkpFyHobVfUTpa7B5+40qjP6M7jE+xIvaQqQ1roPiJbxzsWi57eo8/atLyVI9YGzNUeaoFVnY0lOwwqQCCbxk0fJ85nG/ZsggsdjvyJ5gYwB+KMAN/sKPBa3OZv6mhn6f8ean7R7ygoaUpj70ienxMaQg7rFbEtZCUGehtkSZTMmPiuEWHl5HlktQCVTV62RgBv8kty0QiA6d09OlGgwdgzX6nbd4OUV7uzQt0haNv5RIFRG0usik24u
 Xb6PrO+P
 +/FuYQ349p1mBQrkgmhWQwsSngst4oAjuhT0jX7KleeUZPdwGKk+4eOTssgIvy09QSjfXypiwX9+SRfoWGSCpfsB3sXvngUKvTI5gKZP2HHQc0qZdA4qrsJ+Dx2odP4v+08RYhxcLLKnpNS2FYwriNMZgv3dCKrx5RuV4yGnpQMg2RadOR1M5JY8KN8wz+SOKy/28U02SCZQcd5RXRbOr3ecVH0JD20kNxCzhU8vMNhgTDRgFTU5+agSzUQD7h6JBynVcUMeiHlcD8CdaUUmtdGkAtQdR5DfikVtIodd9GRouXON50+ubJF9P8Il4VvuwAbHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Thu, Aug 20, 2026 at 10:49 AM Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20Hello, thanks for the update!
>=20
>=20>=20
>=20> The legacy reclaim path updates the NR_ISOLATED_ANON/FILE node
> >  counters around isolation and throttles direct reclaimers via
> >  too_many_isolated() when isolated folios pile up. The MGLRU eviction
> >  path does neither: evict_folios() isolates folios without touching
> >  the counters and never consults too_many_isolated().
> >=20
>=20>  Patch 1 updates NR_ISOLATED_ANON/FILE around isolation in
> >  evict_folios(), reusing the existing nr_isolated. Without this the
> >  counters stay at zero while MGLRU reclaim is active, so compaction's
> >  too_many_isolated() cannot see the pages MGLRU has isolated.
> >=20
>=20>  Patch 2 adds throttle_evictable_types() and calls it from
> >  evict_folios(), before the lruvec lock is taken since throttling
> >  sleeps, leaving the legacy path untouched. The MGLRU check differs
> >  from the legacy per-list one in shrink_inactive_list() because
> >  isolate_folios() picks the type to scan from the refault feedback
> >  and may fall back to the other one: it computes the set of evictable
> >  types that are not over-isolated and only sleeps when all of them
> >  are, waiting once for concurrent reclaimers exactly like the legacy
> >  path. The mask of the remaining types is passed to isolate_folios(),
> >  which restricts both its initial choice and its fallback to it, so
> >  isolation never lands on an over-isolated type and a type that is
> >  merely over-isolated never blocks the reclaim of the other one.
> >  This way the MGLRU eviction path backs off when isolated folios pile
> >  up instead of thrashing the shrinking LRU lists - the scenario the
> >  too_many_isolated() check exists for. A dying task fakes reclaim
> >  progress exactly like the legacy path so it exits reclaim quickly.
> >=20
>=20Hmm, could too_many_isolated gets over aggressive or over passive,
> since the inactive number of MGLRU is just a compatiblity shim and
> does not have the same meaning of classical LRU? Especially when you
> run out of swap space or hit a memcg's swap limit, the anon inactive
> number becomes a jumpy random number. Proactive aging also makes the
> inactive number become huge for MGLRU. I still think even a "/
> MIN_NR_GENS" is better than using inactive value, MGLRU used to use
> that as the aging trigger like this:
>=20
>=20if (young * MIN_NR_GENS > total)
>  return true;
> if (old * (MIN_NR_GENS + 2) < total)
>  return true;
>=20

Agreed.=20The next version drops the inactive-based threshold and
instead compares the isolated count against the total evictable pages
of the type divided by MIN_NR_GENS, and makes the check per lruvec,
where the MGLRU isolation happens.

> >=20
>=20> Testing
> >  =3D=3D=3D=3D=3D=3D=3D
> >=20
>=20>  Test on 8G RAM qemu.
> >  The reproducer confines stress-ng workers in a 192M memcg and swaps
> >  through dm-delay (300ms write latency) so pageout is slow and isolat=
ed
> >  folios pile up; the workload is intentionally extreme. nr_isolated_*
> >  is sampled every 50ms against the per-type too_many_isolated
> >  threshold (inactive/8), and throttle events are counted via the
> >  mm_vmscan_throttled tracepoint.
> >  The test scripts and test log are in [1].
> >=20
>=20>  Test 1, reclaim throttling, parallel direct reclaim in the memcg:
> >=20
>=20>  before after
> >  throttle events (ISOLATED) 0 0
> >  - from kswapd 0 0
> >  nr_isolated_anon peak 0 3166
> >  nr_isolated_file peak 0 174
> >  - samples above the
> >  too_many_isolated threshold 0/1088 89/1077
> >  pgscan_direct 1540044096 858332151
> >  pswpout 6299497 725819
> >=20
>=20The throttling avoids premature OOM and over scan when there are too
> many reclaimers, it is not for IO balancing. Because writeback folios
> are not isolated, they are putback to LRU waiting to be rotated, not
> isolated. So reclaimers never wait on the device however slow the
> device is (except cgroup V1 have some special quirks I think we should
> ignore), it's mostly CPU bound. I think the mechanism might be a bit
> outdated, even for classical LRU.
>=20
>=20The result just shows that swap became less aggressive when under
> pressure, which is somewhat counter-intuitive. Overly aggressive
> throttling will unnecessarily slows performance if anon pages are
> actually cold or should be evicted. These results reflect a reclaim
> behavior change, not a performance improvement. And I think we
> shouldn't rely on throttling for balancing, those are two different
> things. Heat or I/O cost-based methods are better.

Right. This script is only meant to show that the isolation accounting
and the throttling kick in; it was not intended as a performance
evaluation. As you pointed out, it also sampled the old node-level
inactive-based threshold, which no longer matches the new check. Will
provide a new test aimed at the premature OOM / overscanning scenario.

>=20
>=20For example the test you posted, it just stress-ng which only spawns
> anon memory IIUC, so when you reclaim file, your code segments got
> reclaimed and hence the process stall and has to wait for code
> segments IO, which I think it will only slowdown the actual
> performance?
>

Yes, will fix that in the new test as well.

Best,
Hui

