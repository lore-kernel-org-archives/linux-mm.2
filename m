Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03150C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5446B0005; Fri, 10 Jul 2026 13:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95E86B0088; Fri, 10 Jul 2026 13:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60166B0092; Fri, 10 Jul 2026 13:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A39ED6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:16:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C0D71A0460
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:16:52 +0000 (UTC)
X-FDA: 84973521864.03.5327ADD
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F5DD4000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:16:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W72B15sv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783703810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwFXVkOioCJBvVi7yud7qnzgeFYYgA7YWUrMtz44JkQ=;
	b=a8Vtz40be13T0UQwXMtatQLsGTgOVVu2gn4SRirvkobKComW8dtXBCZKP9kgZeciLhWfFk
	/DfDwrhiFsg7rlYt7LKCNWOCcS8Icj3GgeDcLl9zluYAnJ0Td/l4fQsvSIA+tSS95d6+hj
	+J5ylEuGicgdUIuUZWlMPZthUdFwZl4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W72B15sv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783703810;
	b=rPSBM8oQmsWkvbcsdUZLZSJJGBFAdCtoykTuf6HVgrTA0A5eqA/gyTjPrUlzr1S5v6PQxr
	IA5UAGvo+gDjaR3bSVjbN5u5MTd/UTDtl6gyMbHxsRIwp9BRhDMQrBmH28LSyES/BpPakt
	mxLFHONG2V1JEwNdkhoNljebtZ9+blg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so1134434f8f.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:16:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783703809; cv=none;
        d=google.com; s=arc-20260327;
        b=tDw/w2CDVSQL8lYOdi7hUlquGUoEfMS9xreJwyAPxuaRie2V8U2c7F6+tv03aB3a2+
         AmyqPwf1fi++8Z8+3af/YOFmajOTQNdonXmhWMyUxaOM7v39uodiIgtpwNeC2ALH7wYi
         4yNEvH7l9Rk6mRWiBTXEKFihJPQ/zlo5eBUvEONzHWHUXv8Ut7QXD/ZodF+GEK1dqD5f
         A14Hd26asGhmLN3NHpn5gDymcHRX2rQeR8x4YPOWLDPLVMvk7YZG8FVlrQ5jl46Q4s+G
         gt7rsz8orifjuO3TPqkVb4bRsDYEkd2ZVDrgNpXYUF/fRc9Iu24lExJ8y1g4xxwT2Tfo
         60rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iwFXVkOioCJBvVi7yud7qnzgeFYYgA7YWUrMtz44JkQ=;
        fh=OeH9GDk1ayzVjC0j8c+48tosmGuoaOkgOmcvv0ehN+E=;
        b=dGk7phbcqbKQn2nGPzb+eDxZWLoBNg21L+v8xhC5bVcEV0Ld8atgk/593G3YwySyZM
         tJ/rMXePaLDFhbyXsp9KxGD98liCPn35LdkUpkT3FwwM4CSPbSrq/aTKd7N35bUW2w2+
         PUUqKCN4PVHGDaAMrtwgK8NRV7FdTWeQWkrtYkH/HH845bKb2Q7wJPJ/SWtEs3YhEeQl
         5yYk2KaUPrGV3Pjx9MkSH08nWWJxiVKrfikDF5tYFKiF4jd6pnWamJZb6IOBjE1KglJ4
         LMIubXUEwS/6VJdWhXwGyIV57qqlDaTwQm91NIqLhHgBB26b55mkoQnVmc8/2fPqFNF0
         U+7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783703809; x=1784308609; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iwFXVkOioCJBvVi7yud7qnzgeFYYgA7YWUrMtz44JkQ=;
        b=W72B15svyljhP53PIT9/5Oe3A7tYu+DI7xG9M4ibzVUUHjFcaSeafL5cVLuiXsFv2E
         /bo4nsG4nlkdY0k99muHzD5Wpx6rndPxxS7RZlPKajGhlfw0YhWMGPsYXMGojJQ4S+3h
         z4l9A0zou+K8723Qfyg/xfHziC/QwI9kQAw86OgnVeKxNviTQTDCqSvM07HU+jybRZqM
         8eok9WZt9+aFOkb+oGfIE13oMpTKvTrqpt6bf74xkEyQsgeGhFo6FrBh8we2GC/bjmmN
         cjK10EKQTlYpoMhLfJh6rNxh2VLj2Ul7lXLHTtPAMuuEe+YCThjpfNnf4sq05xzbqzom
         6v9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783703809; x=1784308609;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iwFXVkOioCJBvVi7yud7qnzgeFYYgA7YWUrMtz44JkQ=;
        b=tN6KriKahyuwH/eEGubdXyo/5CoK+H8NhAGBrzPiGW1vdCexEEK07CTUaHxj8y/cdZ
         tpn5sOmu6SGTvPLr7385TXi+B8z6ch9QXNn5RC6z7RTeY0vpBduHl9mmiNMoTflV+rt7
         0cr/QrIeZhbXqTTvH3Pw+GvZLe96B3w6DGaEYGdsGFsifqGgQ8T1FYyn5QZ2l5SJzNmJ
         D4uv2oei9kyukHY7kCdPrVMLRbSJM0g3MPCXrZlKfci6FJhO1uHOqgs1Tw/iArvnZ8rS
         gEXsN6jhBMneBpDXAemDo/E94kQEquADDpTP/OD01wp12wMrpL1S3yW5Ls0aIDMPah6a
         IBuQ==
X-Gm-Message-State: AOJu0YxRaVy0cDgyfORfk/cecAPS+KyV7pndkqyaxNF9K5cD/f04kpf7
	WQ8+xumt1nnGEqSmieH16gFmFxgVBdO8xKzjXWPVUnNHj1v1zKF9ZNfj4igYjtRki/M2fUadY72
	ThY4XZhzyCa8VL/UzmIGfIUHSDumfNN4=
X-Gm-Gg: AfdE7cnFbHSIVa8papsy8BVZLpcFez9IcFYMrJh5kTgH54udOdpLSYaa50nhDi3e4ub
	qqjYPKq91mjLDqnYbd4aG8G2vbmqYvSMFDA+t8oeBjifnUhEOBFdOd9wtQ3mLdNc/xhg12GA7vC
	YeptxdRaHq6bqVdRX1rP2roLGbq80UuPsn7C2Ks09QFwprsqbjALS4eQBxS7I96yPI/PJPiy2mP
	rwY3EdsWegFAu/sdQDOa6QoS65C0C0ItU8qXwYmkrUnhTKGbDMgYhGmzzWeCVa/4nZA7+XvC11J
	0dVzjnRxdvJvFD799O/rtWNvfqH+
X-Received: by 2002:a05:6000:26cc:b0:472:55a:ef90 with SMTP id
 ffacd0b85a97d-47df0714a9dmr13133499f8f.8.1783703808484; Fri, 10 Jul 2026
 10:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
In-Reply-To: <20260702180908.150136-1-yunzhao@cloudflare.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 10 Jul 2026 10:16:36 -0700
X-Gm-Features: AUfX_myw30BGzTSr11ESEFfBdFU81OKh_Mcc3MuunMXP3Z7-YpTSBqDvywXmR0c
Message-ID: <CAKEwX=PfEFcJQNEgZz1Qjw24CCBToNxC4QaPh6TSRgK0FNPoCg@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yunzhao Li <yunzhao@cloudflare.com>
Cc: linux-mm@kvack.org, yosryahmed@google.com, shakeel.butt@linux.dev, 
	hannes@cmpxchg.org, hawk@kernel.org, akpm@linux-foundation.org, 
	zhouchengming@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F5DD4000A
X-Stat-Signature: 1w73esfut5gjj1wnf1gr6bnw8ei6rp5g
X-HE-Tag: 1783703810-829120
X-HE-Meta: U2FsdGVkX195Icucn9BqdeP4g/EIU5WocOJ5h3GXovNQcpTPgfb4guQLOk9kOqcwO+MQY37MwXFb9KkvXblFfelcAnpMxK0Pu6wbzORnK6UrvgHegoOAcESF299zMCOaBIMcOW/VU2ZgTjDUyoxYLBPiE6cCKoSeCuEnql7/BQLnN2nwh5N9w25adzFQn8jiC5SuelgOUlgfi3kx+75w48RSYd9q0NVqz5iiPjAAUl3cLc7yVhSao6fjwKHzRGdOiC9FK0l/7Trn97BRqdtXA7ogh41NzcrUUmyuYtftA7pcZ/4PALicS6CNhkk9ET1scqJ57YivHVLTcvqdQ+KvYceIWz7bqPhciPD9UW+l7+N8bs5ualtB9gMxg1+rJxD8fUbDLwsnaQ4okbSJE3M5OHQVQ04CWzvf3FkK18vjbN+Uy9aWqdCJtNm6Fi+wgCILFH/iqePJ+uH5Sd3lh3NleuvFihyKH0a3fKhncIwOa6HDlQu8NqvlDIy3RNJaWQh2bDzehm6AL/IgYAhNVdiQ+PqViIjV0t5XUyDAn0XewZAKnldWslMWNQbvIxHMZ+OUf7/a6wNEDKKe+6Ja8kL3Z/8uok26zqLE7azzQb29LQilU/ZJM5N9AYbdPcte18SLRvLFNc3n4QgmUiAUsdEeooQIMzA0X6G8H4DALw2np+eOhOzSa9iuyhrEOV8BQwAJUXy0RawV57Yo+73te1n2SZoaJWdePhIrpITtvyoeHcdEEnqg/0nnduOfISvekLI6fHOBmemh3YotDAgm6QOyVP8wLA1TONUD7zCA7S7LsXQhenC91NbR7tZQNSP/9fG+6BeOB7jv3FHWg6VRa85UjIojsolgM8PWaZb8z+Ion6NtF/Nc1sa7p1wnYZx2uReT68O0aT5BHqxjgDwATc94Tw1E5xmFydFoCrqE/PoJZdtU9+LBGyDcKApc7MCrWIVUK9xccHLgaihVJ/rVLPH
 lnZTBYTz
 MGRgNeqX8tJiqiQUcoiaFN6mm/whRW24g3BKL2jclAuBVMiKjPH825kb5oq/g+ci4jm+iTMSEC8ReT/61iwRipt5JDZvahy/yltHyx2vp3vSGtveBeh7/w7XP6/APqQ2gnuXCO3p9lWYvpHqIqLLfiLrgcyfR35iUDwzuYe9BDT5uDK5GmjSxEeRCegINfluyMnLNR9fSYvMFs2lbs9QSNcOj533ZOQsf39h48GQSVrrDAQ2WdKoibzJluD8y1OI3Amhy0vGpMzH5gkdRCyBWzZlIuRDd/AJtOrNElPDLs/H+xlEQSdD+TeNSIpPfbSVGYSVbpjeejYXG8KAM5dJQ1SbL1HvXdzZB/zRzTQYaAzUyjSV/rBMD60/+Tz4uiiDXYK2xZZPwPoDq1JKFcR56U0Wq2WW+1/VH08UkfHrCTJ7otm7cR06ob7PgwheW8wxRNJM5gxo5pfdBpY6ro1/mB8ya7rPiztCT02fa4bn1ngzF7hBJ6p3L9t9X2tC0h29SvrPWlrpsVXaPnr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 11:10=E2=80=AFAM Yunzhao Li <yunzhao@cloudflare.com>=
 wrote:
>
> zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
> global cgroup rstat lock synchronously. On machines with many CPUs and
> NUMA nodes, this creates severe lock contention in the kswapd reclaim
> path:
>
>   - Multiple kswapd threads (one per NUMA node) run concurrently.
>   - do_shrink_slab() invokes zswap_shrinker_count() for each
>     memcg-aware shrinker pass.
>   - Each call flushes the full cgroup rstat hierarchy under the global
>     lock.
>
> On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
> running production workloads with zswap enabled, perf shows 2.88% of
> kernel cycles in osq_lock contention from this path:
>
>      2.88%  [k] osq_lock
>               --__mutex_lock.constprop.0
>                   --__cgroup_rstat_lock
>                       --cgroup_rstat_flush_locked
>                           --cgroup_rstat_flush
>                               --zswap_shrinker_count
>                                   do_shrink_slab
>                                   shrink_slab
>                                   shrink_node
>                                   balance_pgdat
>                                   kswapd
>
> 84% of kswapd kernel cycles are spent in
> shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
> page reclaim (shrink_lruvec).
>
> Controlled A/B on identical hardware and workload:
>
>   shrinker=3DY: 2.88% osq_lock, memory PSI 1.58%
>   shrinker=3DN: 0.00% osq_lock, memory PSI 0.57%
>
> eBPF-based rstat lock wait measurement across 8 production metals
> confirms the contention splits cleanly along shrinker enablement:
>
>   shrinker=3DY: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
>   shrinker=3DN: baseline lock wait (0.0017 s/s vs 1.04 s/s)
>
> zswap_shrinker_count() only produces a heuristic estimate, scaled by
> compression ratio via mult_frac(). The actual writeback happens in
> zswap_shrinker_scan(). Slightly stale stats are acceptable here.
>
> Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
> the periodic 2-second flusher is one full cycle late. This matches the
> approach already used in prepare_scan_control() (mm/vmscan.c) for the
> same reclaim path.
>
> After applying this patch, rstat flush latency and lock wait time on
> shrinker=3DY machines dropped to the same level as shrinker=3DN controls,
> while the zswap shrinker continues to function (pool size remains
> bounded under the max_pool_percent cap).

I think I'm fine with this. It's been awhile and I no longer have the
perf trace, but this (the flushing) was one of the more expensive
parts when I was experimenting with zswap shrinker on a production
service.

If memory (and my brief revision of the codebase) serves, these two
stats are only used to estimate the compressibility of a workload.
Yes, a lot can happen in the duration induced by the ratelimiting, but
from what I have observed in production, compression ratio tends to
remain fairly stable in well-behaved systems :)

With all of that pre-amble out of the way, this looks good to me.
Thank you for fixing this, and please feel free to add this:

Acked-by: Nhat Pham <nphamcs@gmail.com>

