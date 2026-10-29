Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E5E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=I5ymTHUD
Received: by kanga.kvack.org (Postfix)
	id 247496B05BE; Wed, 28 Oct 2026 22:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1BB6B05BF; Wed, 28 Oct 2026 22:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099AD6B05C0; Wed, 28 Oct 2026 22:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC64C6B05BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:32:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 638E1C02A4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:32:43 +0000 (UTC)
X-FDA: 85374090606.20.1DCB66F
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id B1A37180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:32:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=I5ymTHUD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3SLDiagYKCJE5F83JF19916z.x97638FI-775Gvx5.9C1@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3SLDiagYKCJE5F83JF19916z.x97638FI-775Gvx5.9C1@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrsknUuPusVLZmi3TYlB3zEC9aJluMm+Yj7vSmErNwA=;
	b=p7/p2rRR6pY2CVdfu6xm9pOVfA/6x2eGGe0zXDBAs5xMKEp4VctsXECR4acDlGMzac78D7
	tHEqDAhMt2pYB4lU4xuVwqKRLxNvQ3xcGC3bVQx74NTugyPYtmo1kAsZUd25V694czSgLO
	Ff+rbMNX4n185fzJr35hvoe2zbp+10Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=I5ymTHUD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3SLDiagYKCJE5F83JF19916z.x97638FI-775Gvx5.9C1@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3SLDiagYKCJE5F83JF19916z.x97638FI-775Gvx5.9C1@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241161;
	b=wp0MPmhQwIO5U+jI8YwYTPoGjPpc9pFP0Bs/mYbqy4xNiwgCrTI7IC8TFZ9AyELT2Kz/z7
	zl+XEEhU9jPjZU3OqyDSm6Y8J2iRt5XmJssZOgXtQFormlo8VrB2du7z6haolwi5cNrLOD
	M9es/X6NT8fK7t4i7KQNwCiZzHcB818=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae73921fd1so106563a91.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793241160; x=1793845960; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rrsknUuPusVLZmi3TYlB3zEC9aJluMm+Yj7vSmErNwA=;
        b=I5ymTHUD7/NvKKZ81Aw5k3cQO++5w8SyfyVbnHnaOxAHGKG+MlcKizg3F15LzQZMEH
         RKpuelmxW1ruvqPtXMPBmeCUfM276rr/N1EgszbhE/bFvdnv/PPiqYs7F+kEXJjWEWge
         pik7qaquwS0Jz16ukqVt5c+Qqo3ruDqtMrsRdwOECh7vVAZYd3PUyxpeDvOb5XWcskmj
         l4zOa3je9e18Tf+iaXcjv+qzBzZyyQgS5bPXORU3PL+TsJuKmk1pwuQDHog4aOq7SQJv
         /PupxynERA8TXJOzUTudQm0AukXpIMA1MAGONpQ9w9P3KfMZlMBSCEA+vI+PxcRsQjJP
         QerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793241160; x=1793845960;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rrsknUuPusVLZmi3TYlB3zEC9aJluMm+Yj7vSmErNwA=;
        b=GpdkNV8tKUlQ0Bh+bq8fuoa1kHU9/6jg8fRcApPUpXYj8L6M2hXlaseFtd2wBWcONk
         27q5YSMBEzJASqiBTaIH+U26nn5e9yJag7JzrrKLbwaL99NBFOGzQp1zVD06QGNo0888
         9d3lfhWaClWzn4kYftsm433YunMHNTJVVqUOteVlb/H/ZfElsGSrqAngVbPfPzGUm1lA
         ZPBuEOMqmfuX/g89jc3icujJynwT4aDNxnaZA/qt40cYPLCXUMaXTqRUlf5e5Iv1zxuV
         b6R4ewGf3zJ3QczEMt+LbKrwmYzCCBS/lNXejlXjGbIeaffLPWTyu5BxjKnqXDpNTcQU
         XwkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcomci5uQGlqhal0oFm4izAMZS2NfCwAeysUsEV9No1vIQcy9Atu1f8ACr1+inJ3+ig4kq+gfwPg==@kvack.org
X-Gm-Message-State: AFq9FYKSr2VVM2wtgsPPOSHsqQGlRJM6Z/ytyk+eSi4S/zAbh2yFkq+r
	CIBLNheCDbTtOf9sBYv0jF3asP87VfkAgpALTEV+pGvzIiHqUf320Qmu068+ezd3rYCThI0h+KA
	pq7vttQ==
X-Received: from pgdo3-n2.prod.google.com ([2002:a05:6a02:6203:20b0:cd6:1345:d20b])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e185:b0:3ad:77fd:c3d8
 with SMTP id 98e67ed59e1d1-3ae57e2b5b1mr3164327a91.1.1793241160346; Wed, 28
 Oct 2026 19:32:40 -0700 (PDT)
Date: Thu, 29 Oct 2026 02:32:39 +0000
In-Reply-To: <auKcNvAizn-B92xB@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev> <auKcNvAizn-B92xB@google.com>
Message-ID: <auKvUCpDaGgvJcmQ@google.com>
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, yosry@kernel.org, joannelkoong@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: B1A37180003
X-Stat-Signature: kymrckntaiu5qayr14xj9jh3a71xq7dq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793241161-637624
X-HE-Meta: U2FsdGVkX1+kSrKch00w85F6rWhVKEIAFPak4c7sttd+AGd8hT8m4/Nwz8t/P0xtsr5IqO1UaYZTJRjvfYlPWF4x2ZrKep3RFqKySHaEIgWN2o2jmjVzMfNaR8TLw+Chf8mvedENKPChdN5vgOxX7AT86F+ZUQPwSULaaFLd4KirZDlHA2RTb0YIrulLPRwHNETDRVhqhqsIhN+B2aIc+BkIZHnoKV28K0bpWSlm6QoQL8nYSGCk9i+GnP9tiIB/twSCuAO2SBSdZrzD+BPplfA7MC28gRlE9phCDIH89nHs3sI/lR3Ib8XSGtyZfxbavNYdvc3Vu61KKS50v7i3pFltQJ1wOiTQDXLDnHVgkKWWJzCKol1OQ8t4N+0480e8QrAJtN3G6OqyOZ/Gjf3hLA0o7oyUljbqSZntdl1iaJPOSZD4JzBoHLSxDqEYIT/v1Ric5SMmMOrZbrksGsFAzu/eyP2cWWnkZCLAz1J+/GkFQZhvDTF3bHNq1P3lvwe8uQIn4ylesJwUQzzlnauD3igsEKlhZ+BCt64DHXQynnIuAll2vJq0Sz648hEv9/bCt4oOCMbRcoG/xsZVD4dZDDYx5rMIhdcUeMEm+3Dz0UjgXePhtOlU6uty0SCPW15by9fRtw/08m8uy5YI0LqiI13mXvmlDxqNWsqDP31ApbHFm4sUNw803wuCx2suU4ECtBWenQPX+fat7EcGPcA4k134G5WPIAT7f55pad8ZWJPthedrqypq99r4redOqCcXTnx744+f8q9X1hwYnLiZ1CQDovuljw09bkQ/xsrPfwIOGdZmNEQHFANkf1vNQdNE5njadGd2FZCkYcpGWWu9nMlMdRtBWeD0mvEGsYEObf9R/hkjmu2f5+DD7qzwM2GDg96FP31x+dtRSrcHY6WvxOFH1KGNqlf9Sq3zi3YwWMVet2CasntGrcFdSzs3H7DKrTBREldAhrKy6HN3pCa
 bJ4gEiWA
 bMQgIccRE1WO5oiRxaZiOQSFqXaSOPGiMOoGojvoHpTwXooeBsMTg7nrYeK5lCST3NgM4Lc6FJWQZkCNWRXGyGLUhDhzh/If0WwMGY5V5gOehNp4oXqxhMUJ3cygpy6c/eCPS90xGkl2uLWmmNIisSDIsvjOPu4h7xcJW0uhFshH/Xoi7N3BZFJ/NYA/1pRq3vm/D2ACV/R5fjQH3OryJ+uJdQs1nzY2pFmRAv/CTiV1iwufitsmiioN0HHUnmrfJluT4A7fDMjN71GEujCJRaB9qekcqux4JBAI/OZJZrpVJmiJttJrDs299MTwhWTRHY2J3Gx3jNY6QDDD6pEXm7hPY8j5Ef9uqmjZLAGOYHMkEVSkImstM5hESC408nqgzqS7mkSXliJ+l40PdeMY3Ys00iC41JK5Pjld13PDWoqI34TH0WfFwypvftcNF97f8TGhyQCGqofZJ8XlMYpd5AAuC8FRA9X2Pe68TDPOlcY7neJz7ZeQ/IoAfpeYMnSWsWHsAxozZm4L+Awla5irkJPCTV2dtzs81AZH4C8/Fkv4t+qGmGPMrIYzfy2cfBwMdMMcu5cJDAW7PlBoBUXQ4j4Qli4wWzmOD2EKmeZsZ6slzjYhirtXRPAWHhaxQGYTE61IA790s1itIDf/YPQqnmGxWaMbEeKETBjuEf1Z+IVRFwq5IoVscSkMXgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 01:35:18 +0000, Kuniyuki Iwashima wrote:
> On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
> > On Wed, Oct 28, 2026 at 05:41:04PM -0700, Shakeel Butt wrote:
> > > On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> > > > On our production fleet, we saw mem_cgroup_sk_charge() spent over
> > > > 3x the cycles of try_charge_memcg() although the former should be
> > > > a thin wrapper of the latter.
> > > > 
> > > > Looking at perf during tcp_rr, most of the cycles were spent in
> > > > mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> > > > due to cache line misses. (see patch 4)
> > > > 
> > > > Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> > > > many core machine. (see patch 5)
> > > > 
> > > > This series adds nr_sock[] to struct memcg_stock_pcp to batch
> > > > mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> > > > out of local_lock(&memcg_stock.lock).
> > > > 
> > > > With this series, tcp_rr w/ 10000 flows achieves 31% more
> > > > throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> > > > Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> > > > 
> > > >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> > > > 
> > > >   Metric                     |       Baseline |        Patched |    Diff
> > > >   ---------------------------+----------------+----------------+--------
> > > >   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
> > > >   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
> > > >   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
> > > >   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
> > > >   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> > > > 
> > > > 
> > > > Changes:
> > > >   v2:
> > > >     * Rebased on mm.git/mm-new
> > > >     * Add patch 5 for flaky throughput issue
> > > >     * Patch 4:
> > > >       * Benchmark again after rebase and update numbers
> > > >       * Check in_nmi() in __refill_stock()
> > > > 
> > > >   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> > > > 
> > > > 
> > > > Kuniyuki Iwashima (6):
> > > >   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
> > > >   memcg: Reduce nesting in consume_stock() and refill_stock().
> > > >   memcg: Annotate slow paths in consume_stock() and refill_stock().
> > > >   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
> > > >   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
> > > >   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
> > > 
> > > Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
> > > remaining patches separately and upfront.
> 
> Sure.
> 
> 
> > > 
> > > For the 4th patch, I would prefer we first try to move the network sockets
> > > from memcg to objcg path.
> 
> sk_forward_alloc is already batched per page, and I think
> migrating to objcg would just add an indirect layer and some
> costs for css_tryget() / css_put(), and still inlining
> __consume_stock() or batching in memcg_stock would be crucial.

Interestingly, patch 5 only (without patch 4) gives even more
throughput gain on the platform mentioned in patch 4.

But as expected, __css_rstat_updated() spends more cycles.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |   Patched  |    Diff
  ---------------------------+----------------+---------------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%

  perf cycles (10000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |    Diff
  ---------------------------+--------------------+-----------------------+--------
  Host Total Cycles          |        4,566,914 M |        4,548,747 M |   -0.4%
  tcp_rcv_established()      | 158,009 M (3.460%) | 158,773 M (3.490%) |   +0.5%
  mem_cgroup_sk_charge()     |  18,420 M (0.403%) |  16,211 M (0.356%) |  -12.0%
  mem_cgroup_sk_uncharge()   |  16,593 M (0.363%) |  12,121 M (0.266%) |  -27.0%
  __css_rstat_updated()      |   3,502 M (0.077%) |   5,606 M (0.123%) |  +60.0%
  Memcg Sock Total           |  38,515 M (0.843%) |  33,937 M (0.746%) |  -11.9%


> 
> 
> > > Then I would prefer we optimize the stats update for
> > > all stats instead of special casing for MEMCG_STOCK.
> > > 
> > 
> > MEMCG_SOCK instead of MEMCG_STOCK
> 
> I guess you mean optimising MEMCG_SOCK along with MEMCG_KMEM (or
> mod_memcg_state() / memcg_rstat_updated() in general).
> 
> I can give it a try, though some stats already have specialised
> batching (e.g. NR_SLAB_RECLAIMABLE_B in obj_stock and folio stats
> in uncharge_batch()).

