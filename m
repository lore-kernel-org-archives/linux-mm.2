Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DC5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 19:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA1D6B009D; Mon,  6 Jul 2026 15:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591BA6B009E; Mon,  6 Jul 2026 15:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7D26B009F; Mon,  6 Jul 2026 15:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB596B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:46:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 909131401A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:46:42 +0000 (UTC)
X-FDA: 84959384244.23.F68065E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9CAE340004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:46:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VquJ4H9J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783367200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcfMcRC34wJYIJOReAVw6FjUg/KnmPPUyiL/XHd/3vM=;
	b=MEdFZ1IbatpgWYv6s17PwcYSPnHgQwlEnitCCT0NdRjlVs6Ky1FnSL0nXMHEgQmL/7atBm
	RWHBahH4t/kSSmiHSOAy0RSwxk3h7fHWRPlPrlfPtL+3FcIMxIjAI3VnKsSasCaP2r7z+n
	o06zGL0/0C6fZBTfsmtsJEM6rE4ThgQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VquJ4H9J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783367200;
	b=4guGdg7Vf4h43dKeCd+/856Vo93/REc4lAx6XYL3FVZYBsox9YtPzK8gMw0iMsQLP44uL0
	JL4aQXfVJ+MI8EgMrh0qaWOES8j626oTmhF5vfKWDuyo2jzXdCd9mmibdZVnQwzKn5H4IJ
	H7CGS+BqfEBI1MAjA78qAofZdXkQ47g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F088C61389
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53BD1F00A3A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783367199;
	bh=ZcfMcRC34wJYIJOReAVw6FjUg/KnmPPUyiL/XHd/3vM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VquJ4H9Jqy0TLAtZPmee4V8a+QJVmYctUi8Lucx3//v1utn+gZ7m+6/0saj74HumU
	 MnOjeszK5D6wZG+P1Idm77TZRlfDYsfDsD1GRyeY61UidprZu9mQK1k1JmuE8GJ7VS
	 iw5MIr/vBuKl5pfmnginIXOAs38Z9e4tYOtFjOshNfsgteS+y+98zppyznuWqVWpWt
	 E0SH2284owdRQfz/AvQvbvyCp+KZEcIlNjD4+Y0UBJHUsRsw/Iut2q2vyW5W3nOYT9
	 GSJ4zxEUj3dK5ry4pWN7eAsooNSr+sEMSOafosUk4UyGRAu25MCbQH+HFgo5Bl3hyK
	 qlJYIuW8gE2TQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c12758e75afso420778066b.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 12:46:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqZeEX6xK6haauRxNn5c3Y6hK1jGzAQ4AGNPHr1hdtyclFFUJmMknjYucnFf4WPXrgwrvHYCykCGw==@kvack.org
X-Gm-Message-State: AOJu0YwUif/5vO9fNSiHrq1QCLtHaJiSMAs83bK+y6EqKpnFt+UIpMsA
	NlyBsM8r3kyf8V0vMCqGFVzr0b/fIJuyz5iTOvNc/RJYkqr8w+XBHuc0bTdQdykPMVcxbXzuPVF
	Jxu8KKHQMnX5MBn7z4VLdK3fAghtoSfE=
X-Received: by 2002:a17:907:3e28:b0:c12:e178:9e96 with SMTP id
 a640c23a62f3a-c15a6797765mr128483266b.14.1783367198555; Mon, 06 Jul 2026
 12:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com> <akbHBZP9HxOJMtQB@cmpxchg.org>
In-Reply-To: <akbHBZP9HxOJMtQB@cmpxchg.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 6 Jul 2026 12:46:27 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
X-Gm-Features: AVVi8CcYHTIUvLkh9UA2RdZUVBokOnUsgD4RTA7rZq7yAGo97stNZjbAipCqUsk
Message-ID: <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yunzhao Li <yunzhao@cloudflare.com>, linux-mm@kvack.org, nphamcs@gmail.com, 
	yosryahmed@google.com, shakeel.butt@linux.dev, hawk@kernel.org, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CAE340004
X-Stat-Signature: 6576s15giu6zzcaor1q4x66hmygxgynw
X-HE-Tag: 1783367200-771206
X-HE-Meta: U2FsdGVkX1+S8GYHuM3MfO3RjQ+q10cc/J2evF7/mNhqNEuggiLVOlWqJqPAcx646FM5XEGftU1niZcdqWekxFuRfh99QxnAPmr+JLNgWvJ5ZlL8Fjkh3QEcUryNqrzucDMMBUstgf/CYBZ/6XqE8KCeSDk3f6TxDbXk7UQB3lFNV0LvacEYYGs6KO24wWCyNmGC2dLSijyPQ9TnHOix3z6IvsanJmTDObo7JGc/p4kWqBPrSSVnlrkI7H1lHPmw3URw/UH0o0t2FOhvP9w2zXHFO8u3bmDdc9LiXQffKdE3UiM51dOzJacmzxg7rC0vr5X2QuJxbwSFpPiUNvJtZDy1Kc+HNLN95U1UXVeaGN7Aktr0dRYecRuDJQDovw4Gfj8GBm4xQrVaOGeDfQF8eQ4UGUsIwtz540HFbZcC9SY9gEiknYHoC9di5dTMsJ5FXEDxwrDT6EbvoOvrqgWpbNP8V7f3clRbJQ7Bff+zS4QVKtXxTQ72XHTu76zlBuNT6hylVazj75MaF0i82jLu6y9dr0XDXIPWZQo7VXb2PlIKNvmOcVfz1a13PNoz6Aoww+xrHL31y234VJD1GTi8EclZiF9blEpJkrP2KzMMQf72kLavx12BDN0vwdgw+TkX1BEkZRESo5dkk8Lk/yTz6KcE7J4pYtbWZPB4YMsXUlWmCBvb19mFHv/I14MjB7zJqA9goaBs+1JwOg7Rw6sfhTC2KoOz5Ys6vrp7cyH9dOFIKcUfywaTanfnhnToH1r3/fXMEU+LlDaQmnPWR25A9JaG2ATBaoTW1b21Pi2aXhfHyUBhzfyV/xlrxVD2MkGlI3B0xCcsFB0Y/wPbctfmOXGmNXfqX4daMdMGkAboKcyNT8V5WsKIW5EY2A8OTyGOa3kUdw5MqB+hpol51QjC7RkIKybtw9xsgQBXRKeGkT3ULzTlN0RKq8WpDPPXlgUOxtqqFqSMh2YQJ4Sunxx
 cORUDn1O
 G4GezJzZr39cU2v3qf5+9YNy3d0lS0Ihy0TKywV0SSN0QXLKc+waupHg7e4EpPlXWATX2Fw9GbRHZYuar0nKDiOZDEBjgmt6fOAQth3MS8Ykw7A/9XlNIIzdhADNj5JwI3PJOBRofcbpan87dk0t3FlHT6AGq4CW9Q3kn3HAv08LGzsUxkdz71vUWmVkugmr0vhHGseTZofBSLRk6deP5S9s7ars16IzNBVSRf8qlnO0RYdYhytSuOezSVWtittEvJdjEmIqtQBvLZGzLKnar4MEBvvUCWzauk0Og7cyUXdzfbQsDslvPzPadU/VHT3cs5FcHGcUJze/Af9OsJK4Jq8GcuSEn0jbgKKHQ954C7RbSDamyAm9sK3Sp++sZxZnlA4Z2T8UvNh08M8VSjheo4QytCEu+2nmqJR+H61hh6Kn5VM1fjNmnDQnKKDxYPy86PG9MxxtDcwFO2xnpntKVMmyFMD4q8Ldk4NUy8sfvYyR5o+Z4ykwP392sCTq+b/lAQT+w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 6:01=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Thu, Jul 02, 2026 at 11:07:35AM -0700, Yunzhao Li wrote:
> > zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
> > global cgroup rstat lock synchronously. On machines with many CPUs and
> > NUMA nodes, this creates severe lock contention in the kswapd reclaim
> > path:
> >
> >   - Multiple kswapd threads (one per NUMA node) run concurrently.
> >   - do_shrink_slab() invokes zswap_shrinker_count() for each
> >     memcg-aware shrinker pass.
> >   - Each call flushes the full cgroup rstat hierarchy under the global
> >     lock.
> >
> > On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
> > running production workloads with zswap enabled, perf shows 2.88% of
> > kernel cycles in osq_lock contention from this path:
> >
> >      2.88%  [k] osq_lock
> >               --__mutex_lock.constprop.0
> >                   --__cgroup_rstat_lock
> >                       --cgroup_rstat_flush_locked
> >                           --cgroup_rstat_flush
> >                               --zswap_shrinker_count
> >                                   do_shrink_slab
> >                                   shrink_slab
> >                                   shrink_node
> >                                   balance_pgdat
> >                                   kswapd
> >
> > 84% of kswapd kernel cycles are spent in
> > shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actua=
l
> > page reclaim (shrink_lruvec).
> >
> > Controlled A/B on identical hardware and workload:
> >
> >   shrinker=3DY: 2.88% osq_lock, memory PSI 1.58%
> >   shrinker=3DN: 0.00% osq_lock, memory PSI 0.57%
> >
> > eBPF-based rstat lock wait measurement across 8 production metals
> > confirms the contention splits cleanly along shrinker enablement:
> >
> >   shrinker=3DY: 50-250x more contended lock acquisitions (248/s vs 1.1/=
s)
> >   shrinker=3DN: baseline lock wait (0.0017 s/s vs 1.04 s/s)
> >
> > zswap_shrinker_count() only produces a heuristic estimate, scaled by
> > compression ratio via mult_frac(). The actual writeback happens in
> > zswap_shrinker_scan(). Slightly stale stats are acceptable here.
> >
> > Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
> > the periodic 2-second flusher is one full cycle late. This matches the
> > approach already used in prepare_scan_control() (mm/vmscan.c) for the
> > same reclaim path.
> >
> > After applying this patch, rstat flush latency and lock wait time on
> > shrinker=3DY machines dropped to the same level as shrinker=3DN control=
s,
> > while the zswap shrinker continues to function (pool size remains
> > bounded under the max_pool_percent cap).
> >
> > Previously discussed:
> >   - Chengming Zhou (Dec 2023): rstat contention from
> >     zswap_shrinker_count [1]
> >   - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
> >     flush [2]
> >   - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
> >     flushers [3]
> >   - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]
> >
> > [1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhoucheng=
ming@bytedance.com/
> > [2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMK=
QwX_=3DNPCWB_mFW+oQ@mail.gmail.com/
> > [3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsN=
p-c5CGOA-4Bq9oXSg@mail.gmail.com/
> > [4] https://lore.kernel.org/linux-mm/172616070094.2055617.1767604252267=
9701515.stgit@firesoul/
> >
> > Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
> > Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
> > Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
> > Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> A lot can happen in 2s, but I agree doing this every time is
> silly. vmscan has been good with 2s for a while, so this should be
> fine as well. We can re-evaluate if we run into weird behavior.

Hmm actually we are starting to exercise kernels with the 2s change in
the vmscan path, and we are observing some seemingly premature OOM
kills for VMs under memory pressure. We are still looking into it, but
I would honestly hold off on adding another ratelimited flush here. It
may not be as big of a deal for the zswap path, but I'd rather fix
this properly instead of just plugging it. We should probably move
away from using rstat for zswapped/zswap_b stats and use page counters
as we discussed previously (i.e. eliminating the flushes to begin
with).

(Adding James here as he's looking into the premature OOM kills internally)

