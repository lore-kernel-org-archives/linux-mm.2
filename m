Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68A1C44503
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 19:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1DA6B0088; Wed,  8 Jul 2026 15:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8CA6B008A; Wed,  8 Jul 2026 15:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1AD6B008C; Wed,  8 Jul 2026 15:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0386B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:33:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C83921C1875
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:33:00 +0000 (UTC)
X-FDA: 84966607320.03.F4F2C59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDC67140005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:32:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z6/VH4TR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783539178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RyCmZq0/lE6QV6OMT7U3gz7Iu3knKbBW94ncX2y3jo=;
	b=NLB3NPkp+QVRPIK5YoADvu+zRBuje/pQtqQJyUPPAbFy8SRRMseKxkfp+vx0ZgzFTeBzb1
	QNKUKq9Gc2M4XPChxfH+voFu5qyTR1tI5v/84tlbd1IF3kzbxeM6EOV0tyDc1YkV6hLx/t
	5u2gTjv4uhXDvWwx77+F+YNEyReZt+0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z6/VH4TR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783539178;
	b=YR7mTH9OP2FPo782lDr1GVLpQ2FOGy5iqg8t7C7HbePVWM8HcQhPLA3fseBtoIkcujxMZW
	B6audl4RYoVNblb4REfsolDUMkgSqWN1eoHCSeDWMz4iYsMWCbDjTgRtAHnuQo8JdoHezA
	OhXUqi5PqZ0ewR1lCUFkVb/ZOHZbroY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFD6B43FD5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44C21F00ACF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783539177;
	bh=3RyCmZq0/lE6QV6OMT7U3gz7Iu3knKbBW94ncX2y3jo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z6/VH4TRt22RQl9qp8z4DRL9//5CpEY3KsWplCr3tSsIxSxcKY+X2mryMOAHXwZQw
	 wECHunrPYNovRTZzwqvb/faGdh52R+EdyhGe//YE9/Suc3pAAhwqTTtXDi6FG2bzmE
	 /xSix+IBqWTMTisbKlBqs7EBOmHkNFLHQffyzoh9sOnrkEipohUB90//5V9zIScK08
	 9yrhMFhhWjW0aGr+VYUHoroZ5ZlyRXX/W/w/7i4ATJ5dd9ZPlf5WKE2rMwHOsxd8px
	 jSybX5fDMV8YpV79wxngjHZAfyW1+ca4dpBHNwwITGDND6g0hwuFDwtHZx1my/U0Yj
	 YioYttkBJAiCQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6984169c126so1838697a12.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 12:32:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoTPYTs6ZCzrqIDWiHTKNKcZx5ur5UMB6jdBwnaVUy2vW0vXfScbKzxMOtwVjSAlkmBywJIa+6Dyw==@kvack.org
X-Gm-Message-State: AOJu0YwSlf2PDYTaKa+l+XnvmGeF3PkZUVmd3yKcVcRD5gx00SPARqdn
	BkLfjACRZiL+7VcQpE0ySepzsVkVosSyXtyG83zVfjjaOkHtpVlYerQqLw4kKePOycbI+twSVHX
	/l1XAgTyPnUffk9FIKQnaYMGwjirl3yo=
X-Received: by 2002:a17:907:72cb:b0:c12:8664:6adc with SMTP id
 a640c23a62f3a-c15cde72297mr190966766b.13.1783539176532; Wed, 08 Jul 2026
 12:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org>
In-Reply-To: <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 8 Jul 2026 12:32:44 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
X-Gm-Features: AVVi8CeIZgFy1fjHketasniUWUIBn3aMxNf0vO9cS8k43flb8mYqC_6dJss1YaI
Message-ID: <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yunzhao Li <yunzhao@cloudflare.com>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 99afkaxqaax9wuuc3ir9ctfeqd316pni
X-Rspamd-Queue-Id: CDC67140005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783539178-885361
X-HE-Meta: U2FsdGVkX18B6VvMRMmVqhHafDpHjMoBMx2JMtZihnwQbW2/9347SmmC6stuUMihWkXbKRI9Y/XH87briDTRsDvuhIr0HJrpgHZ7mnDLLgXxZdXug8BaVSG51EPo+NE/Ww0+Z5MeNFguIgtDK6lV7w5ftISzHchkojqQ8p27YIbuYEgHi7xRC80FBh3UyFsd2xhEx8IF/3aglCfyNQ4PwgdOnzmNo4OfJsnpSpxO0R5yy8Vs5clUrZdB7d8jj8Cas+hUDsWkNwD559aI7WnyXgk5i5uWSXjYCKKOPw9FkB3ajVzsirCWvA9Wac6k6rdiOFOlw+U/HFC43QIDLHb5kqsBfY0MqJ4LMnrxS4MX6DUxmZwZyGK0Pow/9y8Keyvk77IxAuap/g7IgvHvJtePxG3EabTIX9FWkhTMjjscWk8EjYepS7pG7yM2/Mr+6wBg/7Ij9SC4KZeuUgM/b/cvITs+TB4Ggp7bQdTG0vRDnvOzDiWyuIVg0sUSetpucEzi0qZiKtpXiOc3CEnTALj3uH+C5nfL/FC4uqN507KerYuP03LHaouEuPwF8zkXwdtS5JXi5ERADpx5iOxo1E6xllQs5yMGYSVnFJw3hrT5fOWKJ3q1GUzotpOrCKi/RHfHZirh5tAKDMWyyW8uDxm+1Lb1WT2m80AHqig8v0T8npXkfhoTsSrx0noJq0uN0vBwOFJfqU9qZQFL8dzkHPsgLfamI/mfOAV4bxNx0y/Q0Mra6fvSriUfCDm/i3He3sQsWgbNGZQBiTJmAXrXAN+GePvvtqIxPt651CjdP5T9TQyuPwC96joz0OhrHIjcrtA9oLuM+sNoDjf7JY5JF9ZbLrNkNFEP2e1gi17p4UcLSqcyh8L8OK/FM8+2mqgnTDgI2/bM2tp7SImLxOJadmLGu5gQE1m1+4+BRYxXGRlYsPiP+qbPg2+c0HUYVwxPuoRlnTY35BT+mN4l0g2ezhB
 XrTh0gtH
 9onZS/ngJnm69eHOKGSabyLLHVkrG7k2+863EgsR6c5UXT6PCJw1PSGABrjdS896sstF1rqj18d5nvjwV2mBa0xXz7i2tUIJ/OfDhc55QfouoSJJOxZK0ZILT0OrYjfYdmms0g7mRqwSJptmDiyDqTxiOQ1c1/3eIPlxAzNGnpceiygFSXi2+m74/ahw1wQY+dNiMzZ2BlL2LY6iIojrzlkBjILQ+8cwpvS9t8wpWdg97a4OKP0BWYsFGrRJQfX70UmQeTeZl8aANNgKiPYEk1QmV93yk8w+GwwKNkpkebRpVgyZMmCc6ttr+v6i6DR8KhZvthamwTilbnnmmxANnqSrtG2O+sRTg9+nF2IyqlXPzUN47g/TAnWAEY9WhHFXOl3+UMfaRdCAIAPd8AYd0jwzDPmPfQxVqXf/PFSSvrPknVfcrdtnLRBqNvpqYC7WH/BwI62v9kgo2mz6cMiVWIj7zt8BBROfypTewivuo9+H2slMSPA+StjNx64yrPfnqgF1s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 2:11=E2=80=AFAM Jesper Dangaard Brouer <hawk@kernel.=
org> wrote:
>
>
>
> On 06/07/2026 21.46, Yosry Ahmed wrote:
> > On Thu, Jul 2, 2026 at 6:01=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.=
org> wrote:
> >>
> >> On Thu, Jul 02, 2026 at 11:07:35AM -0700, Yunzhao Li wrote:
> >>> zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes th=
e
> >>> global cgroup rstat lock synchronously. On machines with many CPUs an=
d
> >>> NUMA nodes, this creates severe lock contention in the kswapd reclaim
> >>> path:
> >>>
> >>>    - Multiple kswapd threads (one per NUMA node) run concurrently.
> >>>    - do_shrink_slab() invokes zswap_shrinker_count() for each
> >>>      memcg-aware shrinker pass.
> >>>    - Each call flushes the full cgroup rstat hierarchy under the glob=
al
> >>>      lock.
> >>>
> >>> On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
> >>> running production workloads with zswap enabled, perf shows 2.88% of
> >>> kernel cycles in osq_lock contention from this path:
> >>>
> >>>       2.88%  [k] osq_lock
> >>>                --__mutex_lock.constprop.0
> >>>                    --__cgroup_rstat_lock
> >>>                        --cgroup_rstat_flush_locked
> >>>                            --cgroup_rstat_flush
> >>>                                --zswap_shrinker_count
> >>>                                    do_shrink_slab
> >>>                                    shrink_slab
> >>>                                    shrink_node
> >>>                                    balance_pgdat
> >>>                                    kswapd
> >>>
> >>> 84% of kswapd kernel cycles are spent in
> >>> shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in act=
ual
> >>> page reclaim (shrink_lruvec).
> >>>
> >>> Controlled A/B on identical hardware and workload:
> >>>
> >>>    shrinker=3DY: 2.88% osq_lock, memory PSI 1.58%
> >>>    shrinker=3DN: 0.00% osq_lock, memory PSI 0.57%
> >>>
> >>> eBPF-based rstat lock wait measurement across 8 production metals
> >>> confirms the contention splits cleanly along shrinker enablement:
> >>>
> >>>    shrinker=3DY: 50-250x more contended lock acquisitions (248/s vs 1=
.1/s)
> >>>    shrinker=3DN: baseline lock wait (0.0017 s/s vs 1.04 s/s)
> >>>
> >>> zswap_shrinker_count() only produces a heuristic estimate, scaled by
> >>> compression ratio via mult_frac(). The actual writeback happens in
> >>> zswap_shrinker_scan(). Slightly stale stats are acceptable here.
> >>>
> >>> Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
> >>> the periodic 2-second flusher is one full cycle late. This matches th=
e
> >>> approach already used in prepare_scan_control() (mm/vmscan.c) for the
> >>> same reclaim path.
> >>>
> >>> After applying this patch, rstat flush latency and lock wait time on
> >>> shrinker=3DY machines dropped to the same level as shrinker=3DN contr=
ols,
> >>> while the zswap shrinker continues to function (pool size remains
> >>> bounded under the max_pool_percent cap).
> >>>
> >>> Previously discussed:
> >>>    - Chengming Zhou (Dec 2023): rstat contention from
> >>>      zswap_shrinker_count [1]
> >>>    - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
> >>>      flush [2]
> >>>    - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
> >>>      flushers [3]
> >>>    - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]
> >>>
> >>> [1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouche=
ngming@bytedance.com/
> >>> [2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPG=
MKQwX_=3DNPCWB_mFW+oQ@mail.gmail.com/
> >>> [3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtp=
sNp-c5CGOA-4Bq9oXSg@mail.gmail.com/
> >>> [4] https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522=
679701515.stgit@firesoul/
> >>>
> >>> Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
> >>> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
> >>> Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
> >>> Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
> >>
> >> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>
> >> A lot can happen in 2s, but I agree doing this every time is
> >> silly. vmscan has been good with 2s for a while, so this should be
> >> fine as well. We can re-evaluate if we run into weird behavior.
> >
> > Hmm actually we are starting to exercise kernels with the 2s change in
> > the vmscan path, and we are observing some seemingly premature OOM
> > kills for VMs under memory pressure. We are still looking into it, but
> > I would honestly hold off on adding another ratelimited flush here. It
> > may not be as big of a deal for the zswap path, but I'd rather fix
> > this properly instead of just plugging it. We should probably move
> > away from using rstat for zswapped/zswap_b stats and use page counters
> > as we discussed previously (i.e. eliminating the flushes to begin
> > with).
> >
> > (Adding James here as he's looking into the premature OOM kills interna=
lly)
>
> IMHO it doesn't make any sense to hold off on this patch.
> This only relates to zswap path with shrinker enabled. Today we are
> forced to run with shrinker disabled.
>
> If you find some better approach to ratelimited flush, then that is
> great.  You can change this code again for your use-case. No reason to
> stall this patch IMHO.

I think we should at least try a proper solution before falling back
to the whack-a-mole approach here. I don't like the ratelimited flush
because we use stale stats and the formulas start making less sense.
If it causes any problems, it's hard to reason about them. I agree
it's probably not gonna cause significant problems with the zswap
shrinker, but we should at least make an attempt at a proper fix
before resorting to this.

I *think* we should stop using rstat for MEMCG_ZSWAPPED and
MEMCG_ZSWAP_B. We can probably use per-memcg atomics for those, and
just iterate the parents and update the counters. It will also get rid
of the flush in obj_cgroup_may_zswap(), which is also problematic if
memory.zswap.max is used. Yes, it's more expensive, but I suspect it
may be just fine. The reclaim path is a slow path anyway. The fault
path is probably more concerning but we won't know unless we try.
rstat has a heavily optimized update path and a really expensive read
path, and I think that tradeoff just doesn't make much sense in the
zswap case.

Can we try doing that instead? If there aren't significant performance
regressions it would put us in a much better place imo.

Also, a curious question, the changelog says:
> while the zswap shrinker continues to function (pool size remains
> bounded under the max_pool_percent cap).

AFAICT the shrinker's goal is not to keep the pool size under the cap,
that should happen regardless of whether or not the shrinker is
enabled. The shrinker proactively writes back memory from zswap as
part of reclaim, rather than waiting for the limit (global or memcg)
to be hit. What disadvantages are you running into with disabling the
shrinker?

