Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26627606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kD8MLizO
Received: by kanga.kvack.org (Postfix)
	id 4A3136B0BD2; Fri, 23 Oct 2026 15:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4547D6B0BD4; Fri, 23 Oct 2026 15:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BF46B0BD5; Fri, 23 Oct 2026 15:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2CB6B0BD2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:14:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D8591401A1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:14:50 +0000 (UTC)
X-FDA: 85354843140.13.BCF5940
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3B35140007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:14:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kD8MLizO;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792782888;
	b=1qD+nENFa8wRvMnvf9sFAFPmhkjFkjjTrjUqGj7WeewuYId1pTi7Rh5UIms1MHW3aNlYaz
	/CFsn030sbm2xcx0cHuX4rGzz5dqnnRcxNflwuk1TYcdxhqtHhtMkRZOg71dytN9IGlgtE
	+MOCEJBjKX6cHJIKDT0gU8pb2WonxdM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kD8MLizO;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792782888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
	b=BnJJEWyX8wg72SF+BHT5Yg8O++FRwXCZSls264lFNubMHxK5ufEASiPjOFwB6SqZD7IDa6
	N87tCYlfJ3fy09XuawEv0xY5EbdXwwl2FRiIpH8giuXzN9eE0spClqQ2ndRq2Z6Nkn+xju
	E5tYLQr26ayU1pgbjmvEsgd6SwkDAPc=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1e34ecb02so7842125e9.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792782887; cv=none;
        d=google.com; s=arc-20260327;
        b=hK1dr/lqCiEHZuoM6O/oSlCU6BpNNaRjBO8b/fzxc6zzXjdmB0/maKmYy4WKO1801x
         aat9Xk3D82p9ss/zuYk6uDV/9h4j5n5E0+EeXdXA15eDh1Cw+UlePwYJ8TeqxLTLSlTv
         KU0MqzFxFvhJEoZPYvD1P1FeX0mX34iTG+ILkt5Oa4xu7KGy6rA7stXdug31ky8IB6fR
         ZPCi6wUyjaHiOCXfBcne33k9UWACWmuNfu275ERufXhC6Bn9oRD3MR9SNq9pmdYi0C+N
         2DxDhO6oscvBeGgAamM5+Awhytop0yxWUs04K5IuyRKmlGsB7dVevQlfe7/MbhYqDloE
         016A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
        fh=A+Rlf8YVHCtF8T+AfC7HH82QlAD7uLDnOtfsmolzNYY=;
        b=NojdlBg/oWIIwrgsMT9AtqjdGg7RbQkCNVQoF62Kg/BEcn3W2wQx83oXeSyNAXLq7i
         WyXeEoq53tCY/PBAUj04XPe1n/OZEUIQqH/BHoFM+bFtlxqdQyA36ggWy+lFuLmP1bDA
         zpLJ97ip4BUWNRfmpAPJiwwIKsIpD9ppQWPe6m5wjj7EnUCF2WHUVCty075aqgxDvAg7
         nw0gcx0oeyaQhJh/lu/ixPFl8tfkp//OuVlkWZvNHvPvDD1iVly9MZ9tFDJQD+18f3i8
         8vc4k/l4MHUHP4mqwydP/kxeF24sdD+C44JVgby7hGSrvNa3wjdFJMViiNfeT/Fv8kQ/
         jw+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792782887; x=1793387687; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
        b=kD8MLizOkCE++sZiNLgX3fcjwQFIOylB/GaB/WHiwRxcHOWTQJSE9/E+UiAzQuPAmm
         JVho/Y3Y6UVMhUPmzwOvPnZmO12kOK6H8ablpXy1ENW2nigCSJK4B4Wz7T1pd6UQiNwL
         2BU8hHdX8h5DLn5myFnLz67qPafzOg5a4kcm/J27SipznuC7KuQpVJ7sPwrjaZOtrcE2
         BUlmTFP0l041NRC173qF4PyMqW7/TN7cy4JbOHqtia7w7oChiVKNv+94rAUnWyJ5cjI8
         zllzc2Ur8W6UQpzVFndTXuQzQLcF7+CcGl1YYXj3h0vQib6xcVSWgMDDTYd9O2rYar0u
         Y60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782887; x=1793387687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
        b=SwUnXqXfLzXAaYk8DCDaiuz0eRLrtHoEfMi+swrOK4+cBlKcwUiE00+14GF52p8BUx
         hSoICmdsLLe7DefYeJwVIFu2RwKSujOUp5tJT8Nb0EsAhoIfA5Q1fUOZjWdDYUTlt1A+
         lfOr8gsZGirssuhwNbnp1As0XXGMHnrWPybnqQzQ644w1PQ9iCfH3ikC5ES/KKbilYCh
         ndfwORr3NFgbOSNoFLDq3fNSx06Dfvhx+xTjPPb0rgdKpbe5xbtQnLtj1Xrv6F2f7lnr
         JD9JVPAuApFHH6YtdBYaLfoONPnJncD0RZcsaPzy9dYmQjegOMQfs8ZQ7bLv4YF3Kop4
         I6RA==
X-Forwarded-Encrypted: i=1; AKwUvBymksuedANRib8EAhH5R6g+86n2gqm9MW/rZ+vHhoLingAt86XKoWq47U5lI/niyIXF8WHgveojWw==@kvack.org
X-Gm-Message-State: AFq9FYKSnj/NQ8lSp+BjHP1b+ORWfaGazNpsYC4Rfp42ehAf3Of6ep9J
	C7SZbYFsGcLbdh1La7tItD2cv5iqxltK3hkIfbSzgowV1H7k0yD3K+cDIERt67QWcQgevAlj7EU
	0+C8zVKK0m5wJvJZ+Or+2Yk9exA6gj/Y=
X-Gm-Gg: AYBFou3FYOuTRwFqjVVhSSWHGiRMkN5ZmPz9HyI5tOLv0/p5s3z9jUm85Ux8J1v/GUV
	hXFo8TxDXVEhx3BiQZ1D3saAEkO2R/nuXIkUn2cIrCokPbwRuyHGZk83hEiL6YRQ2PhI6dri5j4
	+L/G6wTk5bjN7Vj10Zn5EW/btP2LwP13k3CZ2uh5UfV7cUyzyA5y/y70hVQufCZLx2XT9YBV+1U
	YeaBZvtCF211YL5kvaobv9KbE2vIAB42a8DhlgHO+o5szs0hBHziavnciFAGDspPgajq+Ova/E5
	a5GjdWE9L8HWzkWejzsyy3j/I0ybv6HPxHVf5kxR39rkSaYYfPHyw5ptB8Vnbkq97Uh5tqkT/9K
	1U2xoobMX5kIyYDZ5dFgbfhrrp2C3TV+tL62icOzg1+c8JQdDKmwIGTiOaEz97K+HOArX8OToNk
	sW7H3IqC+DQuYXVksfuTEtMBXa8ABXnA6iYPT+Psg=
X-Received: by 2002:a05:600c:46c9:b0:4a1:d36f:1ba0 with SMTP id
 5b1f17b1804b1-4a211f371bbmr59163375e9.35.1792782886886; Fri, 23 Oct 2026
 12:14:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022200313.2354350-1-joannelkoong@gmail.com> <atp7tN-UfEAu3wdk@linux.dev>
In-Reply-To: <atp7tN-UfEAu3wdk@linux.dev>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 23 Oct 2026 12:14:34 -0700
X-Gm-Features: AclHuK9GOSg39fW35zWfZPhaCmkMiyUa4Zn9exIqhsrQZdxL_FAMLVB4ykhQxBQ
Message-ID: <CAJnrk1bDfg=uEO5xU3S8nK3AY-Zg=j3oYX1+cv8kVqmFiD8dCA@mail.gmail.com>
Subject: Re: [PATCH v1] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A3B35140007
X-Stat-Signature: p1tdi8ahtseekykxa7ny5zwwsxpr5ccp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792782888-819597
X-HE-Meta: U2FsdGVkX18QQ9iBaXPtAmuWITSTLZNLXfUxQea8bTaa1I0eb7DGWrA7Nd9GT2s3epmO83zNO7MIdNVZ9g6yMiQIeR6lV0R6Z+DjsBScRV9c5t6CAJdaIlLShnPWzPmudhPpX/erlNuBaUZRW7GC5O2Ro/X8LRXkmQGI3cOV5NxLi/MifJpzBtMIYHi4WOm9hocwu/l18av4RLw9HfvveoToaQIp3XGoet+Wioft8ZfyvEGytp3Hp2dAOnV5lrtzON5rm6MY3qXurIHrSFeh+iVsSgujcYAiPzBKpwkHuAPCTMFQ5iWlGP78mhpgAO3LJ9mQz6qZginkjyrqfAFKRUlZn34+dzYv9JMO44ELyRWicvL7SjjFtJ28sawIlpu2tR+09aOssdqWWvr/XdfwaVgGuIuHZdrSGPR2tb/smphOiVWx9YdxlEr7epB6a8DI54Bi6XxK3tC26SgZsQX3Bl1HNgNdboy2KTM09hTDNLSGLbm2VdrFVXPwz7YxP52SsFnDzFVBX68xpD6Ef/aa2mvbreTBVreDWt5vYOKWq4xDISBhT51LfjnQrvRp7PwKSBF8uky3+3JdQkjbkJh6EzKGnHM4ZCFejPnoIWEWONO3UEkP4xPFM8aS1m/ES6LOZk+eKd0duQkTmyD5C+6f3xTSHcwaQRkZZoC96os85Gc7PZZE5T0ky6GmjbHt9qjLgulapNvQc70u3VyfewLERgHKYX7w5QOUoqEFxjdiFYKMnUg303+Kb+eohNULswGY4TwREdJz1+k6GiAbHn+akb4yJXzxq81kwTZh/iNRmMi9JLQnppLnRSof0yfA0n6cwdeCnKnryB+fMoUb7Qmu/78J1pS9dyLi6lsU0gv4rIdtgEbMYZxS8QS3jt8ew3WVrbNztaqSRQEwMJDrn9KmING8oDOjWhkXls1F9x1UchCNX/I6uPq6EympbLBLbBK/cNS2uYqy4zccdvDb+hQ
 Imj7kz7e
 uKC8I8HgtLHUuKp8nZQx3mlAWCP6Jxffw4Zx7piovWYbWjNOM8/vpc5Nvr4yI5q7lO73o8nsnbsksOBV7lWEjo5ujqkXVx+Qlan+hH0+mYXtHSRmO26hI0yRQd/CUFlquZiuXOWSkDtO2kPn5sxDL0wXJzQvARBorm0I+KI39Ap7TQaSRvvSIBPFxyMN0bepH42bPESEdBGCfJxz1Hy8X2yq+jIAR8BW3JLzqxBIBpFy11X/rhuy9liX5dSomDrbKD6rPA9F10hLxCXLf432+pEV7+dUvMZN1Sp4DmnSL1xnjMH6HmgysLq/rrNQepd0cbCz+JE00npxIjKJcBhtSzmOU+Mga/Kgl2iBLLV8XYlxawu22qfC6Sh3pRn0etrBXIsPS5HRLV2pArIIV6/8qMyNO0535hqf3N9wnT7s2zJsfW6Qrq3Dm77OEgwmu2qQgGu2lp7eo+2mxKQ72z357gCT2bqn/GF1XSXDN00YXTmfSB0CDgFukLZv8fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 2:17=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Oct 22, 2026 at 01:03:13PM -0700, Joanne Koong wrote:
> > folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> > once per batch, but they update the node and memcg lruvec stats for
> > every folio in the batch while holding the lock. Only the LRU lists and
> > the memcg lru_zone_size need lru_lock. Updating the stats while holding
> > the lru_lock is unnecessary, and they make up a large part of the
> > critical section, as seen in [1].
>
> Can you please add a tldr from [1] here? Too much text in that link.

Will do in v2. THe relevant part of [1] is that a change that added
just a few instructions to the memcg stat update path cost about 2%
throughput because the LRU stat updates run under lru_lock and the
overhead went away once they were moved outside of the lock, which is
what motivated this patch.

>
> > With many threads faulting and freeing
> > memory in a single memcg, about half of all cycles are spent waiting fo=
r
> > lru_lock, and the hold time of the lru_lock directly limits throughput.
>
> Do you have perf profile showing this? Mainly I want to know where in sta=
ts
> update we are spending the CPU most.

The perf profile run on the top commit of mm-new (commit fcec4f4bcc
"riscv: mm: fix concurrency in mark_new_valid_map()) using the same
benchmark setup (80 threads, shmem) shows:
- 52.8% of all cycles are spent spinning on the lru_lock (evenly split
between folio_batch_move_lru() and folios_put_refs())
- About 25% of the time spent holding lru_lock in those 2 paths goes
to the LRU stat updates (the ones this patch moves to outside the
lock) and the rest is the list manipulation itself
- Most of the cost in __mod_memcg_lruvec_state() is cache misses
(loading pn->memcg, pn->lruvec_stats_percpu, and the per-cpu
counters).

The stat updates are only 0.7% of total cycles but I think it's the
lock contention on callers waiting for the lock that ends up hurting
throughput.

>
> I wonder if we can find a lower bound here by removing the stats update
> altogether in this code path (just for experimentation) and measure the
> throughput we get.

With the LRU stat updates removed from these paths entirely, I'm
seeing that throughput is essentially the same as with this patch
(within noise):

                       mm-new   this patch   no stat updates
    shmem, 80 threads  7.94M    10.33M       10.31M
    anon,  20 threads  3.04M     3.35M        3.33M

I think once the updates are moved out of the critical section
entirely, they don't cost much to do.

>
> >
> > Accumulate the stat changes per LRU list while holding the lock instead=
,
> > and only apply them after dropping the lock (while still inside
> > the RCU read section that keeps the lruvec's memcg alive). This moves
> > the stat updates out of the lru_lock critical section and turns the
> > per-folio updates into at most one update per LRU list per batch.
> >
> > The batch is attached to the lruvec while lru_lock is held so that the
> > LRU add/del helpers don't need to pass it down. To keep struct lruvec
> > from growing, cost_lock is moved into the hole after lru_lock, which
> > leaves room for the batch pointer in the same cacheline as lru_lock.
> >
> > The stats can now lag behind the LRU lists by one batch, which is well
> > within the per-cpu batching they already have.
> >
> > On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> > CPUs repeatedly faulting in and freeing memory in a single memcg,
> > average pages per second over 7 freshly created memcgs per run, 2 boots
> > each:
> >
> >                      before    after
> >   shmem, 20 threads  4.74M     5.47M   (+15%)
> >   shmem, 80 threads  7.94M    10.33M   (+30%)
> >   anon,  20 threads  3.04M     3.35M   (+10%)
> >   anon,  80 threads  3.23M     3.41M   (+5%)
> >
> > Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76=
izMS=3DqGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> > An alternative that avoids adding the lru_size_batch pointer to the lru=
vec
> > struct is to pass the batch down explicitly, but the plumbing for this =
is a
> > bit ugly (and doesn't cover mglru paths). The code looks like [2]. Happ=
y to go
> > with this if that is preferred.
>
> Do you expect there might be opportunity to batch the stats other than LR=
U stats
> you batched in this patch? If there is then I think we should at least ex=
plore
> if a more general stat batching can be done.

I had experimented a little with doing this for LRU size stats in the
reclaim paths in vmscan and deferring the count_memcg_events() calls
in the same batch paths, but none of them made a measurable difference
to throughput. For the reclaim paths, I think it's because there
reclaim rather than the lru_lock is the bottleneck, and my benchmark
doesn't really exercise the paths that call count_memcg_events(). As
far as I can tell, the rmap stats (NR_ANON_MAPPED, NR_FILE_MAPPED) are
under the page table lock but that lock isn't really contended. I
think the other maybe-potentially-promising candidate is the page
cache stats (NR_FILE_PAGES, NR_SHMEM, ...) that are updated per folio
under the mapping's i_pages lock but that would matter only for
threads working on a single shared file. I can look more into the page
cache stats and see whether the complexity would be worth it there.

Thanks for taking a look at this patch!

Thanks,
Joanne

