Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB11F433E5
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732E36B008A; Thu, 16 Apr 2026 01:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3426B008C; Thu, 16 Apr 2026 01:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D26A6B0092; Thu, 16 Apr 2026 01:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2356B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:49:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5B341B8885
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:49:14 +0000 (UTC)
X-FDA: 84663341028.30.58A64AE
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEA1816000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:49:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="h6/qK1xv";
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776318553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daWfBerFBtT6n6dMWAtcr/2jBz+Sptdt/5I1F7o3Ajo=;
	b=CVCHvt9k2paNyK+ARQC+RuPDasReBosYaJQgM9P8HCA+zNloJnYXjevB96Fw48JnPeGNiz
	cln8Xhh/kqG+olHPUwkl4vLu9zfMtsqM8ZSlFgMwT2yET9xSkOMzgx3RMIlsrETwo5hj/a
	PMzbd1vkN1AYpodeyUoHhku2+TB36ro=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="h6/qK1xv";
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776318553; a=rsa-sha256;
	cv=none;
	b=GsWVkWqAkVp6sGZrvlTN9O046e+66F8FOVvULY1riQQBKxRuYDUr0ZynWCWNVhv9JyVuhF
	YJd6W+mpS4q4S8dEdM7quOwlYXalC6zB1sZ9gfiKn2FFrxUIYaqgzp3qhmgGYjSHpw49hj
	fLhKL9/Xi0zV2lF9hrPkVQcyMiGae/4=
Date: Thu, 16 Apr 2026 13:49:01 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776318550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=daWfBerFBtT6n6dMWAtcr/2jBz+Sptdt/5I1F7o3Ajo=;
	b=h6/qK1xvi2S4mvTdtK8i52FkkUAQxLQouCQjmen+LKngtBUEWtn0zWozRuOh5d+iNtFYMs
	Uj/ZE3s5glWlmk4u8JCLe/fy7q/y+4NsjJE8lKpPSZjPU5Oe8/TQ3GHu8zgyO1Z5uY7QxX
	bkD9RY7nZ5T2XwfGIEtPtLt1GXAU4GM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.orgg
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <wamsxmuhcbr6hj5y53bheub4cmkq7pd3psntl66o74k4bmtygi@qhyse67jvr3f>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <87a4v47xk5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4v47xk5.fsf@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7445nc4n9twcceu8i1qf4oyx8w5mjc6t
X-Rspamd-Queue-Id: DEA1816000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776318552-125072
X-HE-Meta: U2FsdGVkX1+Jre3xt3waJ3hvxLVn7w0aJasAMuavlu38is0O+M+dXIeO8esMry7IbZjpfpP8DBLNS0ejt+OcGVxpQz5dMS6eNChPavSHAbnuYOQPhRaymY7JNo8g18PkCXRFhUPequsok7qFtvNt52oYw+oX4briU0jWak15so5cyLxMW+utR83uMORq5N4EPVA5Nq4pGLfATOVVj+sv4g742w7LuMSNVyTmJZhue+MR7hqv1OfDT/5y+mDBx+V/0pJAd68fG3ChwUbV0QkL9pg43DY0ejkfKwLGXm5nKGQZ6CYnnnqhEVNUglppL2Huim9LISZXJG6cP9ksWZvZxJ/fLuP+qQ3VXtI8uA6E9D59RKaRKEAwU5N4L3MGXn+J6cIaUqoy4Kics2IR96ElQEyNqALquaqlZNBR1QfA3VMfNl8TIXfywdNWzKcKuTx5V4uOWGiPR+xE4859wWbVDgYZdDXxG8P04Qk+0/MHuVRc5IbVVDfelFCE2gy77s7lb7dbkYQff+Ox40dQVw1KgUNJYr8n8BMkN/q8ExLn4VTq2TrqmLT2n7MtkXuAFSCWyTyubadT0I1IGi+S/0zkoVwImk87ORxwXOnZVKKdfiXzhn+//OAHljikOn2oU0AbUlm982BUlLrLXsfokeyYOnzXlluj41Z8p472c1fcwkRrVdaE25+91zjZOYeIoIPIo0TLcO3E/yvWe2B5H3IQssO0QdAarRmGggTtDrztGrCry604bdNG8/kR0EDhH+G45ymMvIMFMERZER+rgtffxke3wn+MXfK2zudK98NCSo95D+ve2XipBCYUid/B5qP+QvC9WIm71JTJf99kKElDGnKPO3RAK4sxyVZ6ctSGGf1c3fPpOIWy6hSDi1305NVsxna9TYE4WyuF4lM+ze0NEgIIup0iVuofdQZlbin9JSHe8s4ZxlshpFKTbJNJjb7peUCGrh3kLqRxJoSnSZc
 D5E/CKSA
 sK2pyfFqYemRkUYpc37XVcneK42K1VE+SRTeUgFo5vEeETk8Yqou4mzjk8bqgaEXj/Vbr2fzI7TJ64J+sBPpK4fyuuFdAyu3gBvCQGY1nRJUHE/1ph3F9Yt9mPjWFGAFc744coRzf6BBc55ihFIvsF6jQzSFMnbWa8OwknDLdaxgK286Ut0mMr0wtSwwLQGZIcOJz5XKtjs0KiWG3Bkqugpw2r+/fhbXv01BS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 01:55:54PM -0700, Vinicius Costa Gomes wrote:
> Hao Li <hao.li@linux.dev> writes:
> 
> > When performing objects refill, we tend to optimistically assume that
> > there will be more allocation requests coming next; this is the
> > fundamental assumption behind this optimization.
> >
> > When __refill_objects_node() isolates a partial slab and satisfies a
> > bulk allocation from its freelist, the slab can still have a small tail
> > of free objects left over. Today those objects are freed back to the
> > slab immediately.
> >
> > If the leftover tail is local and small enough to fit, keep it in the
> > current CPU's sheaves instead. This avoids pushing those objects back
> > through the __slab_free slowpath.
> >
> > Add a helper to obtain both the freelist and its free-object count, and
> > then spill the remaining objects into a percpu sheaf when:
> > - the tail fits in a sheaf
> > - the slab is local to the current CPU
> > - the slab is not pfmemalloc
> > - the target sheaf has enough free space
> >
> > Otherwise keep the existing fallback and free the tail back to the slab.
> >
> > Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
> > stats.
> >
> > On the mmap2 case in the will-it-scale benchmark suite, this patch can
> > improve performance by about 2~5%.
> >
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> >
> > This patch is an exploratory attempt to address the leftover objects and
> > partial slab issues in the refill path, and it is marked as RFC to warmly
> > welcome any feedback, suggestions, and discussion!
> >
> 
> I was also looking at these regressions, but I went from a different
> direction, and ended up with 3 patches:
> 
> 1. the regressions showed a lot of increase in the cache misses,
>    which gave me the idea that a cache would help (and it seemed to help)
> 
> 2. Allowing smaller refills (but potentially more frequent);
> 
> 3. A cute (but with small impact) use of prefetch();
> 

Great!
Thanks for sharing those infos!

> The numbers are here (the commentary from the bot are very hit or miss,
> so don't pay too much attention to them):
> 
> https://github.com/vcgomes/linux/commit/c898c39ee8def5252942281353eda6acdd83d4ea
> 
> I am re-running the tests against a more recent tree, but if you
> want to take a look:
> 
> https://github.com/vcgomes/linux/tree/mm-sheaves-regression-timerfd
> 
> Also, if you feel it's useful, I can send a RFC.


I also tried stashing leftover objects into the PCS before, but at the time I
observed that this could quickly drain the node partial list, which then led to
slab alloc/free churn, and the end result was a performance regression. So I
gave up this direction :/

I took a quick look at the code and performance report in your GitHub repo, and
the performance gains you showed there are really interesting to me!
I'm going to try testing it on my own machine as well.

Also, the idea of a warm_slab looks very interesting. I had previously thought
about something along similar lines, except that I was considering stashing
leftover untouched slabs at the per-CPU level. But that would effectively bring
back the old stale CPU partial list in another form, so I ended up dropping
that direction. But you direction is really interesting!

I'd be very happy to see a new approach come out of this. If it's convenient
for you, I'd love to see an RFC. Thanks!

-- 
Thanks,
Hao

