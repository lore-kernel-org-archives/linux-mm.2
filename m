Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491DA606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XLa/rrVV
Received: by kanga.kvack.org (Postfix)
	id 5AC566B05B2; Wed, 28 Oct 2026 21:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D426B05B3; Wed, 28 Oct 2026 21:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472B96B05B4; Wed, 28 Oct 2026 21:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1055B6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:35:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7705A1401FD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:35:22 +0000 (UTC)
X-FDA: 85373946084.12.9FE0CC1
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC8CFC0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:35:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="XLa/rrVV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 31qLiagYKCAUpzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=31qLiagYKCAUpzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793237720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEH1NfbaYrwZPx3ay7Pd4dSyZn96eHDpie+yn6sEgao=;
	b=qZOnsddwAM7GfNU97Hw62NHQWcWdEzcc96+sI5LazufedCbYn8ZNimQl+iSGii4Phy0LBn
	P3praWsi4dbnbX165+GfcfNjgMsBdAvh5jjEjWsTjqZPdNJyCWDArVSKY/Of68qC15uoVP
	Mg4pLCLUe4FzfF9lIO6KGhYl2iNTv6Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="XLa/rrVV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 31qLiagYKCAUpzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=31qLiagYKCAUpzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793237720;
	b=N8uZx9PLkv+2vfo5KKpoK87C6A/Vga8fQ7mo50JFflZ7unDZ2eBFuoD4Wns+0AwnzOSHJ2
	F2levZ7kx71iLTVeT10TO6zpX/kvAn1sr/e9+TRxj0OK8KToQoesVsaOtZUM6HWIGYES5o
	7S3HxVs3TwCsB2ckC/TkNBaDSAo+gZQ=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a08e315b5cso701846b3a.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793237719; x=1793842519; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JEH1NfbaYrwZPx3ay7Pd4dSyZn96eHDpie+yn6sEgao=;
        b=XLa/rrVVVmeiKTZlNyuqTIT/vqhFccEm8SGe89Y6q7Zc4uhT7WmROCOiRksf6qPMZl
         NDbMng+DAcsqm1JQGosN5zAw9gADSP7m2i0c2l2zRDqBeUYw+mnUEk31dBfVne8uwNcz
         h3LhzR312cdHil+LamwfrynBptsVOoWw6k4nfnMrTLjQGKhV+mMqfyjr1didJfFrTQwF
         EFGukPOqK1QxAgm8jmC47prZBozFY//I/wZLNb7ezsmqhQln6j/7E5ieulTktWjfE1as
         XUXYx2iEh1fY17nykxnO7Ph5lsxUOoI/ota/1M8Z/+7GZ1VghD0e8gUtLPuEzQ65MSZW
         TNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793237719; x=1793842519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JEH1NfbaYrwZPx3ay7Pd4dSyZn96eHDpie+yn6sEgao=;
        b=JuLFZl1zfHrdwWg+s51ZWJ2PuLfBmTa8djBGq9WL6q6DBX/B2lNQ5w4wFOvrN/pcin
         mmJw0aiqtWl+lAAhWakQK9oHDCu9c0EPaRYAjBMRM8ZUtS9ZEc4tYcWEXgrVxKTXoQhf
         YEE0qUdz7PC2uyGX0knn+/+Axoj5mVJAOwECXoFvnx+dt621dtBMiBxA3+30v0K6OO5x
         7Hs+6lZ0k7dRFdOXcv7BJcjia9rpajoFM0guA5c8X5VDNZqRlXnooctlnf7GOrYPaNiX
         XHxXHhjcM5oXlNstDKI4a+cPTeeCapbne33SL9E2ZYfakkN9LQfG5SS9u5b0uUgXdzmU
         dmaw==
X-Forwarded-Encrypted: i=1; AKwUvBwRA9yzE8tUkJ9d4vOVePx7HlRImhDEnsLo4RGVQAigJ4H0DysPj2zo5GTn7vTXxPOcLGLxpF9kDQ==@kvack.org
X-Gm-Message-State: AFq9FYIhf5LMyGSca+OXN2IZ7K93ryQm8bj2hlxjdGBZr3e0J/vAIKZV
	7z7StmF7I9/35cfDWuoM/gVAHaLXtorxRz1ZOcE9OBg0d+TZ+kneMM9B2CqcRcl22Bunhm4x+0D
	fgTbzoQ==
X-Received: from pfbft10.prod.google.com ([2002:a05:6a00:81ca:b0:887:8dda:c9e4])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1d99:b0:89f:fc75:6d99
 with SMTP id d2e1a72fcca58-8a6e869953emr3363442b3a.60.1793237718994; Wed, 28
 Oct 2026 18:35:18 -0700 (PDT)
Date: Thu, 29 Oct 2026 01:35:18 +0000
In-Reply-To: <auKYs_ucslI-tdar@linux.dev>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev>
Message-ID: <auKcNvAizn-B92xB@google.com>
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, yosry@kernel.org, joannelkoong@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: BC8CFC0002
X-Stat-Signature: 59uue8pq7rxh769fx11xhaqf9o4ephuw
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793237720-124444
X-HE-Meta: U2FsdGVkX18iPV14eoRHmWB9MEOGm2umGZ8o/3U9mioU41bHtMJtuiRu1/ckgpaTzWnE4MJjB7cp8/C2ZJ6cXV6BKtzMclIj8KgWvPLj4nR75b+dGwPxCUR4ugjxOm8bphCm9+9QQGlcG0VAxHNBYlORPaMNx+FpgCTezOCgR2kBUd6jwTxuEhPHfG+LQ4aH0BqCilgSClz1wSRXVflwD8ObT3TzvRBqCrGPlaD4GCfL9vW2T69a+FirmeezQRpPouL6zBcb9wLZZfzFmSv8CRrqHWsHitlZOphnX4z+BQnszZBoy+Kk2iRbJoj7hV8LxzPHcby02Xs5EzspD5jQItnJgiU/r2bK6fci78pE+VT06KAEtpPAdgDqpPpbL57Qm8qXi9sPzf3891UbtTcGgAZDPe6u80W2Snw48nwmcksUlff92Ongc5tL6jm+qiWwSqSXllhM9XQs1Dx+i04gMLaN8orX9X7GfVoNaLiToB4ByFd+OdA8JRa7kuhAsoNOPBnBA5cdpm69LYgvmT2nQ5kWfuejcsGeU8Z9WraVs+KMTQT+BDS92DHU5habIK2pPwdOrQwGZ5JSvKJwvBK5eTbbJOoa3FFepEYZ0HulXNllUoGKyoixnqGOpDJ2bRcxV4mKBHochrXzItS1Tbqgy8BjUUJmvLkCeFQAPBKyddP9Dz5YDiiHQlDsptPaWf2YPSEhJ7DfbYqkGyuVeWrWidjju/qXkWDkduAfnrJrlASCg5JjaHSzZyDMmHSKCfyvHOECKxutid0luPOMKj1NghizIBhW184xWd8jIPO3lyJKId4gwrA0m0QmkvG7pu3/4EJISyY1M3lFPdQNRwiG5CHLEk4cJ12IpHtK9AJCRjBipFN3iF1iKoQwHZgWeFzlHJt4fVUx/V7D5BOFSb3QSFWHQIbpnuCVuOS8zjEi3xiLNNvBlrxiinSvzx7uPhwBM4DNtnmIjy6v4V5EmG7
 2r/S4kjg
 kTwUYqnSd8/83GssK1C8P+fY/NfBSOs1aOtKcOkDxKhoADRIYrqzs75JQq1onLMyE/linDpgYhrmAx7GmV826LeTYhGPZprqXPJm5TIR5lTXMdNxkmGNx7WZcybCwKiel+nYK/NzQD5N2GLWUCzAeLsUhnc5dA7JeyiDulmUA9MmJpNmBEBh+oWyzCydel0TIC+S3+D/ExaFzZ+Bn2Sjv1jvDuUtwvzyHZQMgFONGCKQ+CMrNZ4P+ftcPVw5+wm1eLU7b+1vYsuFUFUHhKMwpphQfT4CbHi+zMh2Q4pjCZ1S1To6j+zprTJ6yCE3nT10OJibveZtrG1dquDQujWRWD5IzbtUTfZOyHhqKn34I3sQsB8eMETZqq6FMsvk+GAxRHWHZBXFOWORsJ1Qg3zEOiUMb3SQcvG24GdL0XOir9RgVir/KmX2AslZiwTHtoKID31reYsYqdhq5t6pMT0qBCFfM9FsJ+5j+Okm90QZTLYwTd/t3RoVAn7x0LKdmDiw5YolQ0maROg4X6Zk+nrepB6lZqdPDE78KKKGyIWC1CfYD3dLz07VeeQliLGQVpd0jDUkBTxfng6MxS3PPtfYhacYQLCK7HDGpwxSzXbcwi51tW3jBRP6CA8Ro2AoosoYhVe/TJNiyRm0W8HID5g2lGd6mv772hOZ6SHSDigvlwPlczphjSAqYXeeZjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 05:41:04PM -0700, Shakeel Butt wrote:
> > On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> > > On our production fleet, we saw mem_cgroup_sk_charge() spent over
> > > 3x the cycles of try_charge_memcg() although the former should be
> > > a thin wrapper of the latter.
> > > 
> > > Looking at perf during tcp_rr, most of the cycles were spent in
> > > mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> > > due to cache line misses. (see patch 4)
> > > 
> > > Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> > > many core machine. (see patch 5)
> > > 
> > > This series adds nr_sock[] to struct memcg_stock_pcp to batch
> > > mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> > > out of local_lock(&memcg_stock.lock).
> > > 
> > > With this series, tcp_rr w/ 10000 flows achieves 31% more
> > > throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> > > Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> > > 
> > >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> > > 
> > >   Metric                     |       Baseline |        Patched |    Diff
> > >   ---------------------------+----------------+----------------+--------
> > >   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
> > >   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
> > >   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
> > >   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
> > >   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> > > 
> > > 
> > > Changes:
> > >   v2:
> > >     * Rebased on mm.git/mm-new
> > >     * Add patch 5 for flaky throughput issue
> > >     * Patch 4:
> > >       * Benchmark again after rebase and update numbers
> > >       * Check in_nmi() in __refill_stock()
> > > 
> > >   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> > > 
> > > 
> > > Kuniyuki Iwashima (6):
> > >   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
> > >   memcg: Reduce nesting in consume_stock() and refill_stock().
> > >   memcg: Annotate slow paths in consume_stock() and refill_stock().
> > >   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
> > >   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
> > >   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
> > 
> > Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
> > remaining patches separately and upfront.

Sure.


> > 
> > For the 4th patch, I would prefer we first try to move the network sockets
> > from memcg to objcg path.

sk_forward_alloc is already batched per page, and I think
migrating to objcg would just add an indirect layer and some
costs for css_tryget() / css_put(), and still inlining
__consume_stock() or batching in memcg_stock would be crucial.


> > Then I would prefer we optimize the stats update for
> > all stats instead of special casing for MEMCG_STOCK.
> > 
> 
> MEMCG_SOCK instead of MEMCG_STOCK

I guess you mean optimising MEMCG_SOCK along with MEMCG_KMEM (or
mod_memcg_state() / memcg_rstat_updated() in general).

I can give it a try, though some stats already have specialised
batching (e.g. NR_SLAB_RECLAIMABLE_B in obj_stock and folio stats
in uncharge_batch()).

