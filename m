Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EF4C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 23:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C3A6B0088; Wed, 26 Aug 2026 19:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E186B008A; Wed, 26 Aug 2026 19:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555CE6B008C; Wed, 26 Aug 2026 19:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3203F6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:08:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1F8940299
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:08:21 +0000 (UTC)
X-FDA: 85144961202.30.8F14C4E
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7ACFC1C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:08:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DT5vIEV/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787785700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7vtYW7GiR0BSBlof4x147wbx40CvW/HfTi/gy3gw3I=;
	b=aG6wVZqYPaQn45VHENfXnjkH4qBMaHazDtamAmXcTSDwD0mrDeGMfPKJjSAQ5Z2me1+Q9u
	QFfRkjoTHpvoTO58w0qRRKtZk9LdzM9qX5yBHbce7OWtgL+t+tCZp3H3mCPg7HiINXf1pJ
	GqpxJNDb94RxW4C3n5vDcYcU6l2rem8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DT5vIEV/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787785700;
	b=K0WYohnglvc1JSnRCj6GCDOtEtHRJOyJYVYjZKXn0ynBBU0VBmCE4dLL+5ImAmKqidwIIK
	0XG+XLR2pSeOOn8QXX17C3oqBhOHrtejG72Dw/3Ef/1jO2DckC+EL5uwlP93jq9qKLe83Y
	c/mrNZs1XGDykvXDhjSg6LLMAQCou/A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=noRPLNdLIahOGuFurijMFn6y8l/0FZg7N9AF61uRmC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787785697; v=1; x=1788390497;
 b=DT5vIEV/bquOIInj1H3LekDV3nFXNIgsOzU4ZlUHzMk50FLqFYYu1WEo3c5t/WRLgZNgHex1
 W/xPHXt2Zh1DKABImooRkPof02s4LEX6iGntwOBzLa4gxZc+1X7JhnM2JgruUHL1zAe2jdvfQ8J
 7WRtR60m6JS8CDXeo/Tumsgg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:1d::)
	by smtp.migadu.com with ESMTPS id 8f2a058e7e3a482c;
	Wed, 26 Aug 2026 23:08:07 +0000
X-Mizu-Trace-ID: 8f2a058e7e3a482c
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:08:06 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
Message-ID: <ao9q-m9k-NMxDvA1@linux.dev>
References: <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
 <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org>
 <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
 <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
 <ao9YFgBQJEy-85iB@linux.dev>
 <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pyuctd1j1xbfk9s91poj58rthjmf75dw
X-Rspamd-Queue-Id: 7ACFC1C0004
X-HE-Tag: 1787785699-926950
X-HE-Meta: U2FsdGVkX18hVMvUM91PamRJCjnBxZ1ROE6HFndQ1f6YGfoXGqSNPFQb68b6uWdgXB7mafeYBo8b+cLWdgplQnbNfqiFT26PWqoiTstkn3V6UlYPMCfApIU/eBRd5EyPhhOAvtmX/Dcth2d6NWdl7E9FlEQbzZz2fOH55TmqN2jWT/TafY/cCCR0htoFPCBf2IoI/YnbF4FRMazR6m+3eUB0Y7OfPpmz6s0Pc/2UfhWb5EmnQIJ0IGmmP++MZiai/ZvssUA7/ytYeIp3cvmBqwZnE0d68LaI11UK6cx35hUenpUSVnpaY1KrPbLSXeGnqpA+Du/QCupc/poiP+Ce/ycY+8w/5iG3ji3C9oqcESV4y7ntNrdfv14G4SKzAWOYLEMSRAZAInm6lCKpZXD2SSXopBxryG3Mi8Ey0MfL6MKYfpSmNM4rrHft4fBgaOu+Q4n/DbaVbTWBe8W/nkl+uv1Bh6kmAU8RJUlqROcd3D9ekJszZghhvHA5P48PjOzp33H5nWXcvaCOvlTMHiK0r1fDlhRqQzpDD5CL+5rJ2j1UG/nAHw/plYZjJ+RCCDgO860j2So+mgfrUbbreNIRLswVtBO6WonuvBEeTiS9faX9laiZnhvrcDxUgLR/3vgQsK4AR1m8X1iK0dlBRwt/qnKC9mvjZMwgzhhcxv9OnsVkCnZFisZ5IVvEN0rAYNJC+6YZRyeDC7SHApHnwHFg6VcIELoqvvGen9Ha9I1tvlRowgI+y5JtIKtrDTBktR2KJjy5cA2/jFW6Tbtl+beGsvaB+uWlgtOTUt7t0SR4Mrcexm6z4WB22ZYE9YFWEdPy//QMnoiKaHbrTH/padqtYJlC/Iud9SfSkgyBaaIOO6EwCmOL+xgyzoK1rpGvWAwDxrwnzrep859WbJceTk8qFxY8MaW01itBieYpuFhQY58Kva4HvOeWMQkZQK6PbFf+JlPZa9D7DXDFm+EfyUO
 jkGZIFkn
 1Z0Ee0ig4To4ggDK2g58TVBKCNtwzMOUtummzm8Et/gPEQpv2l/Y0LkaZ+fIJdUQ+0AstOHecOs9JqtzoUi4NDcpk9p0Wxp1FT4B3JcDDL/wk2Xa6ezgw/6VZkHU6g2Ri88Ziw1iL6nDnT5NPhYEcVtbQ2Wq6ey46K+zXHLg3n9RohW/SsUksDwy8eArFj7XCe4Tibp2+TcQdv+hAjEAinL7LsOE5IBgUPce0AGxMnbnrGJctsiKeBw+JVf+d4sVmTBx2A8hlOM1Trg2ovtnIkmrNAEUbDcApz2lVhr9/QGHiQCG2EAyEGqJL3fmzh2OVIeepbUr/ZBOqr+ao5I9MYUZjBEbB827OAn02IuI/NNF0HvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 02:55:57PM -0700, Yosry Ahmed wrote:
> > >
[...]
> > > If (c) is holding up for writeback and vmscan, I would question a more
> > > radical approach of tearing apart the rstat framework and using it
> > > across the board. That is obviously a heavier lift and more
> > > controversial,
> >
> > Yes controversial because we used to have similar mechanism which did not work
> > and we had to move to rstat. Check the commit 42a300353577 and fixes to it.
> 
> IIUC, in that commit, the update side modifies one per-CPU per-cgroup
> counters, and when those counters exceed a threshold atomic updates
> are performed on all parents, which I think is the slow side. Then,
> the read side just reads the potentially stale atomic. That was
> problematic because:
> (1) The update side can end up performing atomic updates on all parents.
> (2) The read side can be inaccurate by up to MEMCG_CHARGE_BATCH *
> nr_cpus * nr_children
> 
> What I am proposing in (c) is different:
> 
> (1) The update side always updates per-CPU per-cgroup counters in all
> the parents. It never does atomic operations. The parent iteration is
> not cheap, but it is cheaper than atomics for sure and we already do
> parent iteration today in some cases in memcg_rstat_updated().So the
> "slow" path should be the same as today.

Yes but that parent traversal is short circuited when we hit the flush
threshold. At Meta scale, we have observed significant cpus being spent on
memcg_rstat_updated before that.

> (2) The read side always iterates per-CPU counters in this cgroup, so
> it's always accurate. This might be more expensive on an rstat flush
> on average (e.g. if memcg_vmstats_needs_flush() skips the flush), but
> it is much more consistent and the tail latency is much better.
> 

It might be or not. Usually such things are more clear at scale in production
instead of benchmarks.

> >
> > This worked for zswap stats because their update and consumption are not on
> > performance critical code paths i.e. these are on the way to compress or
> > decompress or in reclaim context.
> 
> Well, decompression is in the fault path, that's performance critical
> to some extent (although not like other stats updated by networking).
> Anyway, I think the update path shouldn't regress much with the
> approach described in (c).

Decompression is on the scale of micro-seconds (and I suspect the simple minor
page faults are on nano-seconds scale) and the upward traversal is definitely
much cheaper and will be a noise there.

> 
> >
> > > but if we can get away with it, I think it will
> > > simplify things greatly and honestly rstat has been causing a lot of
> > > trouble in the last few years.
> > >
> > > But this can be done incrementally too, we can start by separating out
> > > the problematic stats to use the new update/flushing scheme,
> >
> > This I think we do need but for specific stats. I think the stats which have
> > in-kernel consumers need this. However not all such stats might be fine with
> > slow update side like zswap. So, we need to evaluate thoroughly.
> 
> I think in the proposed approach (c) the main concern is actually read
> latency, not update latency. So if it works for in-kernel consumers it
> should definitely work for userspace consumers as well?

Here I was mainly talking about consumers which has more strict staleness
requirements and those are mainly kernel consumers. Rstat flushing is definitely
more expensive than this for-each-cpu traversal and most of the time they just
need it for one or very small set of stats.

I am imagining once we have this special mechanism for selected stats, we can
potentially remove ratelimited flush and stats update threshold code.



