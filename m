Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A96DEC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A90A6B0093; Fri, 18 Sep 2026 03:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859A66B0095; Fri, 18 Sep 2026 03:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795C86B0096; Fri, 18 Sep 2026 03:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFFC6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:14:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98BD4805D1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:14:07 +0000 (UTC)
X-FDA: 85226018934.05.EBB7174
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E5771C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:14:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwQ9+HE4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPja/cjHElFD0uzEegkx8fIwtmRtWZZ628xauj+vnig=;
	b=aNH3JfCMBXf27Wnjb8yG44SZwP+X9zeUGswZQ5FzGwbgyM5xwFIiADO1aLwy8Xob66hXJa
	3jw5pcIxT4uaMvkZZcDFVrdmNmLjHmU0NPD2CwjgsvZDcrDy7l655vUZIM9zzxbWqe1k2C
	V//3cVGgQ7mdXHsrOEZwkghzo8WVirQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715646;
	b=Qz92DtAZ2U8+e3kHTQYtGWzVUvzNItdDvc/pJyJRHdZJwbDPBmPbiRUrwAol8bseGkA13m
	s0P1zQe5vki+jxL/I7w8mp0kqUjBARbhAXjWpC0WFpM8EhA0SFQH3HrFrV6723CS8/ZYcC
	9hZKB+9rKVWT9Cde0U//D+Z/+zXunmg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwQ9+HE4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F70940A5F;
	Fri, 18 Sep 2026 07:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8311F00893;
	Fri, 18 Sep 2026 07:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715645;
	bh=qPja/cjHElFD0uzEegkx8fIwtmRtWZZ628xauj+vnig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VwQ9+HE4NY0tnT9IpCZZjkrYpUgU+Q3MI0b8/kYWYNXLBz0OBgneUCZ0sypjFtJsp
	 uk8yMrodDG/EeLJ8Cw8NNo8KiwNI51f8ZD8ksE/h0ATyzWe0rOhA2zD55Bv4UGXOqW
	 XN8cdNsIiGEswI8idXhx9LsXVV8pMBpdua0A2GKBMdibbYRuZmFHYhRVj+1e05f18V
	 eH2pa2QHQGVyGAQKDpc8Rp21vRQpejf9qtKhrlKELzpduu2vOfPRzZeJau0po3nnmS
	 8o+tIVL/BCsxVeANYa0wNC3Hgxqs9ydfhcyzw7TqvV+sVHAZ3QOve+6n3SeMFjIw8i
	 5ToAQGv9yBMiQ==
Date: Fri, 18 Sep 2026 00:14:02 -0700
From: Namhyung Kim <namhyung@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Tim Menninger <tmenninger@everpuredata.com>, linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>, linux-nfs@vger.kernel.org,
	Jon Curley <jcurley@everpuredata.com>,
	Eric Badger <ebadger@everpuredata.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation
 on dual-socket NFS/RDMA
Message-ID: <aqzkugwB_I5X2JYx@z2>
References: <20260916232227.4098143-1-tmenninger@everpuredata.com>
 <aqvq8-6IJBDer90O@thinkstation>
 <aqvy8NqRRRmUlxjR@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqvy8NqRRRmUlxjR@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E5771C000B
X-Stat-Signature: 1kssk17oxdowgimjm536eh8u8bwxmt4f
X-HE-Tag: 1789715645-670540
X-HE-Meta: U2FsdGVkX1/HFiO/tNk1A0zBQj5pFdV/sqFxOsarU5CANpZAqVF/moRpCzGYpTJhC2rbixx7NPZbPZKkTyU6RL8wxtCEszTBa9bzB38STCbXmCpnc9rGkbP/gluTHAFciJRz51t6OVLBINtk4zTf0pi1RODY4TpSPzX8iNfUrKNpRyJ0rexS2xeLOT2MGVxN5+dsmXnOged+s9Pd+R8WSEJNnqV43Q5QXl1Wd9+rDdU5bjU2cSWmq4VnvgT8lVdyiNwhmDyIJaIqcqQmKAl5lqpw8j48B90AzPm+UVou3qyaN8awUiyaoAJwlIaYqrSlj+9azXoW3VXiuwOYv4/HTFAruVYu99DpVQxm9MUEwoB9q6jRkhM9jW9VBF0G4+ShDm3xEWmxi2nzipeDkLFXDm6QhQj0B82enXvJ9zaLvo7Rc7bfQTl6FQsHzdfG+4BzCHXfcDyV/2GzpEP9hJPvDcpz0S9KuGZpFKX7ISTi+yvvR3F+3zj4LfnPPxPBr35zqSgUYV0L2qc1A6BXJAvR0l4Xb8DVYJp4LSlvBvn1aM+RfGRrd5qj0ikpm0TCDNer6oJfSVCdt5Pzi+Eb6yXZ1L6uu69s74y4BEmt3Mz6LlUbvFIITpeMeVUeGyA8exLtN1axOzqNXEtD7KKh5Ds21GIgwNSWT5/+AeOM6wudDU8AhL0Yj5wFfsR3O2WlcpHwudkfgh2qBJypOaCx7eN0NeTuSF01ScvP6DcM251rovMXIPMzBCvSEHz5H4ZX8GXzdV7noxBbsqHPrcT4KrirVqnBbijZJ2IyNXn1oB3sTPhJoo3ax/TTePmOUPU+UU0YkdDHmKdKQMxQ6w2Lkx0pBm11I9IRjTraMSxKBVxhf7SAG/YRxWQ4Ig9CA8Du0Cd1LtxRP3D1oSk2UHxMvRFvU7GoTRuohF9L8GhiaTJ5DGVGmsa7O8SQb68UIvVLb0ra0nUpdES3gBtnqheZrN2
 3HOJOpSt
 SXULAGhuKdV1SMuJFU0O4EI9KOJnUHn27PTXvCe6I/T5v446JAJSuza7czf2jVkF0LXs/CTSJ18ABW7hfdX998MJi0GQfJI1mxi+o8zi/Zi+kRmnVSXeAmCM28rv/c06PFeAJJqoXKak1+JeIYmPJ/Bhg0GaWU3iNv/5hL/wPjpWNxeGOkloeq7TzUVVk2sMnFTHoAMbie6YR78CgKSVqvnivtwSZ25EPUYhXq46JrGhUDVgmdCXUp27XaZzjOndNYnpUqFahsQCqvyZlEDKh+sdanRGf+jGWumA9IGvmhJwIXgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 03:10:47PM +0100, Harry Yoo wrote:
> ... now I realize we need to add PERFORMANCE EVENTS SUBSYSTEM folks 
> as well ;-)
> 
> Hmm, sounds like perf lock is somehow triggering slab allocations
> and interfering the workload.
> 
> It could be because SLUB is merging nfs_page cache with some other
> cache that perf uses.
> 
> Could you please check if it reproduces with slab_nomerge kernel
> parameter?
> 
> On Thu, Sep 17, 2026 at 02:46:24PM +0100, Harry Yoo wrote:
> > Hi Tim and Chuck, thanks for reporting this to linux-mm.
> > Will take a look at this but let me Cc SLAB ALLOCATOR folks here first.
> > 
> > -- 
> > Cheers,
> > Harry / Hyeonggon
> > 
[SNIP]
> > On Wed, Sep 16, 2026 at 11:22:27PM +0000, Tim Menninger wrote:
> > > My questions are:
> > > 
> > > 1. Do the uninstrumented cmpxchg_double_fail rates above look abnormal
> > >    for this workload/topology, or are they within the range one would
> > >    expect from this degree of concurrency and NUMA placement?
> > > 
> > > 2. Is there a less invasive way you would recommend measuring the
> > >    nfs_page list_lock/freelist contention? I would like to distinguish
> > >    the steady-state behavior from what is observed during the perf-lock
> > >    capture.

You can use the BPF version of perf lock to check lock contention like
below.  (it only work with 'contention' subcommand.)  It won't create
a data file and just shows the result.

  $ sudo perf lock con -ab sleep 10

or

  $ sudo perf lock con -ab -E 5 sleep 10

to see top-5 locks only.

Thanks,
Namhyung


