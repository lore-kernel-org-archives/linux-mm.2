Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AB1CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 00:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7A08E0022; Thu, 23 Oct 2025 20:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEBB8E0002; Thu, 23 Oct 2025 20:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E60B8E0022; Thu, 23 Oct 2025 20:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED2E88E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:47:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CA18129509
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:29 +0000 (UTC)
X-FDA: 84031169418.23.A1EC7EA
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F2C21C0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=zh9C0xBB;
	spf=pass (imf20.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761266847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CF37vASVu1lERWLdUzwSBXFPOIOWrH5SKBUxMwoNNU=;
	b=iLADgge7k/bTMCTiaaSeoNyg8EdFJhI1BGqyk7bdI5+iHTDgTj/8CG7t5zOfZMnW0hgajH
	tmwz4c3iJYGB6SwffvuYvDiHSXMGOunCEkpnabdYcqNS4Hng2VeQq57Gw98KQv8mcmjl3l
	C4WVEQQy2oWt55VbxX+7xH3hM8FR24w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=zh9C0xBB;
	spf=pass (imf20.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761266847; a=rsa-sha256;
	cv=none;
	b=Y0+/nisO6ePUlrZtNWhfur97d0lEfa1UdHSlt/CuJ+NoTa8jAQo9GelUJiJCUoUOfePWxu
	DJECfuB0uToiJVGGfYelyR5YPbG7CmOb9jgHTuJa9N+RWlHhDOIXoBrK5xSnuaBXcqo0G0
	YMzza4gcNzCncCW0PHueTFIkzZBW7EI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-27c369f8986so12380795ad.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761266846; x=1761871646; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0CF37vASVu1lERWLdUzwSBXFPOIOWrH5SKBUxMwoNNU=;
        b=zh9C0xBBGdj32Z39n2uA4/ntWZ7bD2EomRwvHweSq/VtIkqo0GcBzTwebDci2HFxMY
         H10bzXIfN27eK7SR33v8u4Je3TXVlxmhXTmQy7lkknBh56miC26jRsmUfqbjmf/BAwrK
         jYSTlciA7QJmA7B2fbDY0oFiY6BYNegoeC+xYfv6Fd5qVl9G0Vh/9yewETeEiCJ5Wurc
         /rns3BtdDaAjyue1U7eiPXAnFRiKShGFeAJuO5eVbbJ8cXh/DATeBspj5EhvM9UebxJI
         XJt1PYaJOZ79a8TOQD94uZbRgipXhaOZqIcZOBLRuXwdhFjtlZFj87cytqIt+hrcs8rM
         Wddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761266846; x=1761871646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CF37vASVu1lERWLdUzwSBXFPOIOWrH5SKBUxMwoNNU=;
        b=Joc1hHzEZO7eXhHWNREemqUVR89tK4RCdWWc5dfGj7xGP57RqIjKuEuBu+ozMFPcAN
         lzQJxC2Q+vW9vKVGK8fckGaMO1OnD9t6W7OaLQr908eZTzGkLktgr8BGj2WOq138fgW+
         acUBDA15adHDVUz0efX4heAMK859VoeDssWvUfGr5n+IcPcCPDglZCetdIRE7rTctRQc
         HY2YFhgtVlj6ldvkbi4BYXdZFK8nqwEv2NbzgCwF0Ga8gim/ukntqWUEOWx6wtB5KrZ5
         jGoGg/PtapIcbB4/hLHklXStKpKoaBKao8aNJsChaPXQ9ErbI+taUe8y1F5kMKyVSHaO
         4yNg==
X-Forwarded-Encrypted: i=1; AJvYcCWgtbqnITSBlo86y5v1FX7/KNpeVAYX8Er/C92VKifvOiz5SeMR2/M01BMsf0Vdg9CRtMLUojNfTQ==@kvack.org
X-Gm-Message-State: AOJu0YwIEIxpgePaH0IEWUkFEEEOtfw2Gg3ODVx824uR2GQseZ7V7yBH
	o35PSm78cPJ1WdWpP1PTU6LLNN6zuOPYHqMaSTt+R+9Gkw8nCm6l1L32W5Wiuy/P1IA=
X-Gm-Gg: ASbGncv2SBNH2PQjP+lBgjlh5QlSfPWbI2i4NQSZDDWXaWYHxPv4BQzBurBwdM20OoW
	lNgXUN83RQf5JrxmRHoZbF5+X/e4LlgZGO0+BzYw7Bg7WZKwHuULFNC/mk9PT/S8oiOl2z6prwd
	0YaI0DuOXPz3Gxc6/FkKVBwtWnc4cs7HB41EjU2yycXHWKRib+lRSY6t4/tjduk9CDBdBFWdL6p
	bG2gKxydZShq4W5H+e59zaGnd8xIZ+A3sTJI62Bw/E8ImFb9m9+U/JV6G1U3sTpbBhPb0zidt19
	W1JHXR06FkREDFKB5JOeG8jQ3fFIUbtSUjum5iazfv5K1ATWRQmxX/ZIWkLIxAiORVoc0MEmqBU
	eKlXWDI7ZjtovDxIt2tt8rYRxrWECmQnqULQsnyHcVlb1azQgaU/YHpV/AREs6bNC/JVO887jFA
	sNEyuZGJIwkVS7bfyN7qqhcG7Gy63ZLZKlyakXA1h0m7kQkZnPS56SPynoCR0zfA==
X-Google-Smtp-Source: AGHT+IFDKFuLVTTi6OytY2uLIOpcKsQrir4Q1MgzIDg9qpWsafYVGa2H0KmayI4Im05xT1m/s8LWxg==
X-Received: by 2002:a17:902:cec6:b0:290:ad27:c1fc with SMTP id d9443c01a7336-2948ba7ccdfmr4251065ad.55.1761266846085;
        Thu, 23 Oct 2025 17:47:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946ddec8d8sm36413325ad.36.2025.10.23.17.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 17:47:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vC5xi-00000001GcJ-27Ar;
	Fri, 24 Oct 2025 11:47:22 +1100
Date: Fri, 24 Oct 2025 11:47:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yifan Ji <412752700jyf@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [DISCUSS] Proposal: move slab shrinking into a dedicated kernel
 thread to improve reclaim efficiency
Message-ID: <aPrMmj1fNgV5ql-l@dread.disaster.area>
References: <CA+9cq0kkbk2Bpgyah=9bU2+=QNM2L1GfYLgMK6OuRhda-B80cg@mail.gmail.com>
 <aPcZX9dabaEqTBdG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPcZX9dabaEqTBdG@infradead.org>
X-Rspamd-Queue-Id: 8F2C21C0002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kh174wh3buesw6oscw6gxfqurm9rdtyb
X-HE-Tag: 1761266847-314591
X-HE-Meta: U2FsdGVkX1+Bu9kxoZueAcMNro2QTXN7yF5V5HLXZdLrupzTfN9avRbogOTn8+msubqyUNyFg0FaWIX0jINgDIJnKSuJI1Vv3di9vpYsw5YxedygkzzqFsoVyQ8tMhR9fitu1XoSict51l79kNjDHohKrqr0uMKGtLTarPrxoVqW6G+Mtk6qRYmgZZYzsl7KUk/r2uaY9zBsUeH5i6QpxncdTuYNCsQnTNl0Fe1v4J0QXtE4ut2/wp8HNqudhzTrCjTcpGzgA6jNtqCzkc/Lt6Czj2AkIehtZGOMAs575dvPMBtqjO0aUZSfnQcxsQTwvd2GVifI+xwIbLf6i+Vpgglbqk/7cBL3YUQhQ1Yn5x3wW+zBB5JymcL0yj7psXXb2ZUN5R0xw6x6p8Od+QLmir50MaKS0ChUcinlxAJK7JFTgaEowDct87VxFPmTFmnZR/59bFJz037h7Ikxy3EmA5BhG35OEdId/9rUkc3dcVZjK/itp5/mUkwdGmThuOCMO8OOTPhli6W6c8+pI6CZyhzBhxPTIIvbBsjXM1zk2IEyzaFHWRV/zTCUhfIUrex3NqgbiZLAiFuk5Mre3oLCcxkdpgkVZFXUUb6zdErIMGoI0vhklRE87LhKdwtUTQah+dmHjctZs8oOESoAYPODvOgsd+qK2RN8gVpkyAvwjU6lOW6tUT0UWxdkEFwd949MzWZI24KiEMnkzogQsUPxyE8pFL/EaRlYwcJ+7E9TRQy8d2CMJ7yZjiGwtnldNv6uhUw+THgXxM0k5KnS1iYw61t6ofn+W1GLuOCCSz7EG5c48jU7pYPAy0jNgcJnYbWMUXZW/gkofqN7zG0GbsuBZvyB2PaU5TKFCUj8rhEbm+A5s3rIpRbPLGrMcaKQCOlS5gbyRDBMUJRng6ISdq69/lRCpVmdvtktn9VxBHRomYoS7RuMy4C62/u6cqN/ywvzBvMsKqEdAfYVBEnmFrR
 RoEK+i5d
 xAUqpMfTDCVBrnHTFJXqLD9H5l+xJh2GHMiJXeKdIAlYG2CohBJDSvXaW5Xonul1+xLHbXvVgHFK81F7PCmlRAbcHznbL/RZRrMsiqLBprHI+W29yw6WN9ipEmwVLequ1aHisbP6IBIkclOE6Dlvu2x4a9d0cIYd2JTv+/zt/v4+WKogpoPOvlrZEtmJ0bz4yvF0DNpjlfQahVBFs05LmX/M6wv2uX2f4DfdLk8tbP/7/HYCjHi8OxbnwhAnL2ZxWGKcj9ZsThSQM476TMK8Mr+EYa9w0e221zycro/ghm6ignBFbugnL33pTkZPEB4vfGoh5cRTrOfX6rjs6bacIU7/LvaIQ87PckbTlPYQ8L6hMOdChVvjMRGAIJPHoxzqinUWUowxaDngsOHsKgFtKj7HAJ2b9aNLtIzsRL5ynw+2sZ/IHkLabGhG2ei/BfwfHDB7S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 10:25:51PM -0700, Christoph Hellwig wrote:
> [adding Dave who has spent a lot of time on shrinkers]
> 
> On Tue, Oct 21, 2025 at 10:52:41AM +0800, Yifan Ji wrote:
> > Hi all,
> > 
> > We've been profiling memory reclaim performance on mobile systems and found
> > that slab shrinking can dominate reclaim time, particularly when multiple
> > shrinkers are active. In some cases, shrink_slab() introduces noticeable
> > latency in both direct reclaim and kswapd contexts.

Sure, it can increase memory reclaim latency, but that's because
memory reclaim takes time to reclaim objects. The more ireclaimable
objects there are in shrinkable caches, the more time and overhead
it takes to reclaim them.

If the workload is heavily biased towards shrinkable caches rather
then file- or anon- pages, then profiles will show shrinkers taking
up all the reclaim time and CPU. This is not a bug, nor is it an
indication of an actual reclaim problem.

So before we start even thinking about "solutions", we need to
understand the problem you are trying to solve. Can you please post
the profiles, the workload analysis, the shrinkable cache sizes that
are being worked on along with the state of page reclaim at the same
time, etc?

i.e. we need to understand why the shrinkers are taking time and
determine if it is an individual subsystem shrinker implementation
issue, a shrinker/page reclaim balance issue, or something else that
is causing the symptoms you are seeing.

> > We are exploring an approach to move slab shrinking into a dedicated kernel
> > thread, decoupling it from direct reclaim and kswapd. The goal is to perform
> > slab reclaim asynchronously under controlled conditions such as idle periods
> > or vmpressure triggers.

There be dragons.

page reclaim and shrinker reclaim are intimately tied together to
balance the reclaim across all system caches. Maintaining
performance is related to working set retention, so we have to
balance reclaim across all caches that need to retain a working set
of cached objects. e.g. file page cache, dentry cache and inode
cache balance are all delicately balanced and changing by separating
page cache reclaim from dentry and inode cache reclaim is likely to
cause working set retention balance problems across the caches.

e.g. if progress is not being made, we have to increase reclaim
pressure on both page and shrinker reclaim at the same time so
reclaim balance is maintained. If we decouple them and only increase
pressure on one side then all sorts of bad things can happen.  e.g.
there's nothing left for page reclaim to reclaim, so it starts
thinking that we're approaching OOM territory. At the same time, the
shrinker caches could be making progress releasing objects from high
object count shrinkable caches, so it doesn;t think there is any
memory pressure at all.

Then we end up with the page reclaim side declaring OOM and killing
stuff, whilst there is still lots of reclaimable memory in the
machine and reclaim of that is making good progress. That would be a
bad thing, and this is one of the reasons taht page reclaim and
shrinker reclaim are intimately tied together....

Separating them whilst maintaining good co-ordination and control
will be no easy task. My intuition suggests that it'll end up having
too many corner cases where things go bad that evena mess of
heuristics won't be able to address....

> That would mirror what everyone in reclaim / writeback does and have the
> same benefits and pitfalls like throttling.  I'd suggest you give it a
> spin and report your findings.

Kind of, but not really. decoupling shrinkers from direct reclaim
doesn't address all latency and overhead problems with direct
reclaim (like inline memory comapction).

The IO-less dirty throttling implementation took direct writeback
from the throttling context and moved it all into the background.
We went from unbound writeback concurrency to writeback being
controlled by a single task. IOWs, we decoupled throttling
concurrency from writeback IO. This allowed writeback IO to be done
in the most efficient manner possible whilst not having to care
about incoming write concurrency.

The direct correlation to memory allocation is memory allocation
performing direct reclaim. i.e. memory allocation fails so it then
runs reclaim itself. We get unbound concurrency in memory reclaim,
and that means single threaded shrinkers are exposed to unbound
concurrency. This is exactly the same problem that direct writeback
from dirty page throttling had.

IOWs, if there's a problem with too much concurrency in single
threaded shrinkers, the solution is not to push the shrinkers into a
background thread, but to push all of direct reclaim into a set of
bound concurrency controlled asynchronous worker tasks.

Then memory allocation only needs to wait on reclaim progress being
made. it doesn't burn CPU scanning for things to reclaim, it doesn't
burn CPU contending on locks for exclusive reclaim resources or
single threaded shrinker paths, etc.

The control loop would be almost as simple as dirty page throttling.
i.e. allocation only needs to be able to kick background reclaim,
and tasks doing allocation only need to waits for a certain number
of pages to be reclaimed. (i.e. same as dirty page throttling).

As for per-memcg reclaim, this would be similar in concept to the
per-BDI dirty throttling. We would have a per-memcg relcaim waiter
queue, and as background reclaim frees pages associated with a
memcg, it is accounted to the memcg. When enough pages have been
reclaimed in the memcg, background reclaim wakes the first waiter on
the memcg reclaim queue.

IOWs, if the problems you are seeing is a result of too much
concurrency from direct reclaim, the solution is to get rid of
direct reclaim altogether.  Memory allocation only needs -something-
to make forwards progress reclaiming pages; it doesn't acutally need
to perform every possible garbage collection operation itself...

But unbound direct reclaim concurrency might not be the problem, so
that may not be the right solution. Hence we really need to
understand what problems you are trying to address before we can
really make any solid suggestions on how the problem could be best
resolved.

> > Motivation:
> >  - Reduce latency in direct reclaim paths.

Yup, direct reclaim is very harmful to performance in many cases.
Unbound concurrency causes reclaim efficiency issues (as per above),
in-line memory compaction is a massive resource hog (oh, boy does
that hurt!), and so on.

> >  - Improve reclaim efficiency by separating page and slab reclaim.

I'm not sure that it will have that effect. Seperating them
introduces a bunch of new complexity and behaviours that will have
to be managed, and in the mean time it doesn't address various
underlying issues that create inefficiencies...

> >  - Provide more flexible scheduling for slab shrinking.

Perhaps, but this by itself doesn't actually improve anything.

> > Proposed direction:
> >  - Introduce a kernel thread that periodically or conditionally calls
> > shrink_slab().

You can effectively simulate that with the /proc/sys/vm/drop_caches
infrastructure. Write a patch that allows you to specify how many
objects to reclaim in a pass and you can experiment with this
functionality from (multiple) userspace tasks however you want....

> > We'd appreciate feedback on:
> >  - Whether this decoupling aligns with the design of the current reclaim model.

IMO it is not a good fit, but others may have different views.

> >  - Possible implications on fairness, concurrency, and memcg behavior.

Lots - I barely touched the surface in my comments above.  You also
have to think about NUMA toplogy, how to co-ordinate reclaim across
multiple shrinker and page reclaim specific tasks within a node and
across a machine, supporting fast directed memcg-only reclaim, etc.

Really, though, we need to start with a common understanding of the
problem that you are trying to solve. Hence I think the best thing
you can do at this point is tell us in detail about the problem
being observed....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

