Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D083606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IQ7nupdB
Received: by kanga.kvack.org (Postfix)
	id 1B16E6B05B3; Wed, 28 Oct 2026 20:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161C06B05B4; Wed, 28 Oct 2026 20:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B2D6B05B5; Wed, 28 Oct 2026 20:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBD5C6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:52:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 382134025E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:52:37 +0000 (UTC)
X-FDA: 85373838354.17.E0F8EED
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A72D140006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:52:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IQ7nupdB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793235155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHPQoGuLDHaF2k2LL7mqI9My3qPyz/yrNCTublPv5XM=;
	b=a86Y9RwbiVSjEk0+ffFSeti5cN3yV56tpiel/Ck851MJbFs0yOMQBbRiId04rLnXhSG1X6
	5nAunx2s/2yYP7lwPNYLFznWiaASdvEXhEOjo75rXHDwU48OEywc2dxxcGR3+D2xFl//Mx
	SJVjq9lgptk8S5Q5+2FH8DnDioO94e4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IQ7nupdB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793235155;
	b=gi3Ees88Lwr0xMAbwVHalAZS0QNdxXmIYCtQjx2zlm0EqyoWoz2vhoZt/Dn5ldDLVfkIAK
	Xr6diB9nICSCsI0fWJpl1+vSQw7ofFNqbdOTpOjQQq6HjXRRcXxGLufPJCdDmcSr5nZBPX
	NZn5x1Kw7I1wlH9WqWXwxPlGGpBalvU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=H4+49ktcnrUz5wU1B741UzVopkyPlV0rkJlT+s//CUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793235153; v=1; x=1793839953;
 b=IQ7nupdBNTFnK8Bi0t2XEmSuof8HmZFAco9zgUtV/ensirH5+GOgI/14Ki8c06uGTVu8j4Tj
 m6DmoTVBmjWAlR6Oe6O0X5uCE0B5phxi6MfCnOWefN42NBp/OIEIRru4DF0lPGzIRtXzubNfI1P
 nAc0+5IwEXyPu3LJY0e9r5ao=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8fac3c08d8046dd3;
	Thu, 29 Oct 2026 00:52:33 +0000
X-Mizu-Trace-ID: 8fac3c08d8046dd3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:52:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, yosry@kernel.org, 
	joannelkoong@gmail.com
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
Message-ID: <auKYs_ucslI-tdar@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <auKSeCFvsWzP-XYy@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auKSeCFvsWzP-XYy@linux.dev>
X-Rspamd-Queue-Id: 3A72D140006
X-Stat-Signature: qbzxf9yj5u7n13td78woxemsz1xgn9ji
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793235154-915532
X-HE-Meta: U2FsdGVkX19NHkLXqTfXmXUVYb7vMbP6UgA49maq2pG9624EXzL09lnzxJWCEWvoimQGNBONxxpkXN5zllY74PDpDGbLT+8SYgcNBnUxxtdvM9bGk9voPbABCvObKAUe2vYrzqGOck9Lb4pub1XdVmu48t1+ycWK0z7NkQmFPGES2Tl9RxyHNRq7EjLQupsVEoeSaOwdGUCSn7B1pSB9hIc4QQwFhaS91+8YTwagVw6y622lIP33V/0eDKZ6bJpLu6SYQ2mYAJH+o/0Rn2Su+J/5j5uSiQVN37lTuxhI2LDE20MnmV5Ws2pK73IuPSEs7g1oMfgGqiME9z7egYxRI3qyd5+0ft/A7f0sOfmP+g6SRTp3mGi0psqEyv1WiFG5OOwHEMM/J5os18XxI6VIVwGlsKnsWOc0A4GFOdWa2BkvZeOBNNFfSBzTxgisHi2A4+tYm0m4iZEjPLiiNUUhyXj8IrAbLSdNPGQUBJ/LD220vlIsysoWfEi/5x7z4h2mCc/cWKjAqTA503G1dlAGL3czMhQ7IxzZCmK9eRZCZHfcKveLIDynuBGe2/x/jE4WpwVKwRgF5qen7KRg/zSOCPq7S27Ui1TFo/CHcisNxU7v0dEOQEyGqqUR1G/HEj6X+8QVBX0xlt4CFGSZ+J9gPni4EGAb2svB2G1TiQ5ZT3qVsfw5ysI9WtfBv31cKg/5b1uK0buAKc8wlPY3mSVJ80aYdgKbIPWq/PLB4dQrKMouyROSz9hewnnwDp1m3KgYskZF2S9/1z5O5yUyjkNR94oXU58pkWoLEloiINifupTwTIkGcrsXeWDpJQvRkcJtC2x0td/D0hw+JCtFJMHrj/apSJNKpn1w94Ar09TWn/kfMDxg352XqAu/Awim97xrhsRFcXdrXmmI9VQDHCMfFWhXaMQqgiUh0YCM/DkD8ZsYhBep36FbbZ6EfdiF6dUmn1i9KZoRFFP35rCAMSn
 YEVyOcsq
 l+9u+oNjQ/hEv2UC/jUhS2GfwAn7x5GvbDR8ASicJf2QaQptWUtLklVVwO6dUQscsMXCMeWnA8KT22UjN1HPEDRVzo8rPEBQrlCSXid9wVkgu7Jr2ISIkv6TtGA7Fn5NPE0+WWR+Q3CCeNfCR5nBnhquBYIGf8jDnTeO40BFO/h6Dnf83Nxb58eMrDFtHXCYPK2aoeBo5iPOkhnbDF5a1olTw4KdjAz80Usk7BHMsX0B566LTf4aRXbjgk6o0aB5NIfXNRFtHY7ZwnwdcuNV2E7U0uN+kyyEr/HmNWAVBwnU5QdHa2HB3FubCXkN0pAcvRMkgnDJdX2oXZCwH4vytSqX2WdyjQPmotP6fUf6EPKEdTSE1sNmLOG2j+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 05:41:04PM -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> > On our production fleet, we saw mem_cgroup_sk_charge() spent over
> > 3x the cycles of try_charge_memcg() although the former should be
> > a thin wrapper of the latter.
> > 
> > Looking at perf during tcp_rr, most of the cycles were spent in
> > mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> > due to cache line misses. (see patch 4)
> > 
> > Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> > many core machine. (see patch 5)
> > 
> > This series adds nr_sock[] to struct memcg_stock_pcp to batch
> > mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> > out of local_lock(&memcg_stock.lock).
> > 
> > With this series, tcp_rr w/ 10000 flows achieves 31% more
> > throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> > Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> > 
> >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> > 
> >   Metric                     |       Baseline |        Patched |    Diff
> >   ---------------------------+----------------+----------------+--------
> >   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
> >   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
> >   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
> >   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
> >   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> > 
> > 
> > Changes:
> >   v2:
> >     * Rebased on mm.git/mm-new
> >     * Add patch 5 for flaky throughput issue
> >     * Patch 4:
> >       * Benchmark again after rebase and update numbers
> >       * Check in_nmi() in __refill_stock()
> > 
> >   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> > 
> > 
> > Kuniyuki Iwashima (6):
> >   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
> >   memcg: Reduce nesting in consume_stock() and refill_stock().
> >   memcg: Annotate slow paths in consume_stock() and refill_stock().
> >   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
> >   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
> >   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
> 
> Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
> remaining patches separately and upfront.
> 
> For the 4th patch, I would prefer we first try to move the network sockets
> from memcg to objcg path. Then I would prefer we optimize the stats update for
> all stats instead of special casing for MEMCG_STOCK.
> 

MEMCG_SOCK instead of MEMCG_STOCK

