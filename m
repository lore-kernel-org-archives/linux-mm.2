Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC14CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 16:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234456B0088; Thu,  1 Oct 2026 12:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5146B0093; Thu,  1 Oct 2026 12:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D38E6B0096; Thu,  1 Oct 2026 12:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCA526B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:00:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C76514045F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:00:12 +0000 (UTC)
X-FDA: 85274519064.24.056D336
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC08220005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:00:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Exk80jZv;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790870410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/UmLJEY0a3iLYujZH4c7hJLto4+PkpocQpwMHfxzk4=;
	b=x0XRBH6KJ6GDCjsrgxVDW8ficaZKgncr2J4xjLGt2lQZwi2SjcxIPGJU8DFEANAtnfCGlN
	z65y1a4Dgc/mS3xNO+txprfV0PeAB2j7nI53WEn5CgIAtC74nfwTusTVB8Wm1JkhUC1ulj
	H5AASk57GmV7X6N2bj4lqcF4FKuUeCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790870410;
	b=m0hvTa5Qxyz8TKb7HsAyL3z81/1481y7M2OCvykfep4NSubkp7CrtV3LVU1yAAgZsvlU8j
	zplfs4mxNJC0ieN+SvR+s9ROefe7w4v5GGmirRUfokscwRy4aVtOs+XwrXeLPocKgNRUpG
	i9+jFbkEFs6N34w4uUvYSpoS9/oh8MU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Exk80jZv;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nQNXL5q4knr5P0PR//t77Jz5pY4phClaMKAM51WfU40=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790870407; v=1; x=1791475207;
 b=Exk80jZvoe5ccJQCgQeZt8Ca6D1jqS14CyBvgIo8nXhXYOpazRoGADCeZNiU1vDWygPqgumL
 Qqkw9dADHpmazD7czY0QvqUfwUvQxiyF8ZLlzfdDx7k+tQYuGCllI6bFEsAhlBOfeVIK49XSAR/
 8biMU8JiRvMotPQBZ1EzOE14=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4267819c097ea3ea;
	Thu, 01 Oct 2026 16:00:02 +0000
X-Mizu-Trace-ID: 4267819c097ea3ea
X-Migadu-Flow: FLOW_OUT
Date: Thu, 1 Oct 2026 09:00:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Frederic Weisbecker <frederic@kernel.org>, Aaron Lu <ziqianlu@bytedance.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <ar5eUZ7hibU0Bp5o@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
 <20261001121842.GJ4121620@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001121842.GJ4121620@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Stat-Signature: 9r1j5cyud3xzaa8egmq1y934tbsr7tbd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC08220005
X-HE-Tag: 1790870408-336630
X-HE-Meta: U2FsdGVkX18p1OODckdi9LGFUPAEvOEa4SMxqt6/YdlZyHPO127bfdewlMOh2owaIa8e3P6g8coJ4eA33pv2l25bQuw+RZBnP80AGZYvNII4YNIhpbyC5nApErTnXW5sG+YOUuiQS6j07TFsOkirLh8NiQ3CONZCL9I8fxkkfppO6rVC4lkTHxA03Ix4rh8lCXILJGVSNP1xOYyWYf6uk0hTPmt4z/5N5gz7vKs1jKYrY1dy2kN9VJH+iXS1AcCO+JzX2ejquuovHQ1hACd1a6LC3ETlt8Aa2HacSf90442//jIp71ip5g9lu16h2UChPYKgrzSgYfxMg8Rw5eF7Kaak8zXLnrIA4/xJBIBBiYt+cWcOE1pEioZ5E/g1O7QravHMRpLL8opvxITbCmnoA0tOQ7zCdgAMFQHkegG78kVVjyiP9t17MK+H9wGmz2mMOkTC61RGzzcucRlXfwZg/iu83Cm3QnbPpPtZyZBA4Erl0gBknsYo2YYzU3IkHdEcjXRtKsW6zzgfiI2zrd2R5Gr0uGM2UfaV/FKxTdOoXDvglyWtafhXgor6cjdBCjp27lQeO+SltYN33m/KVPeO5mLVAmK1bVbwrQ8AVO5HZJhFiGZ84eH6sG/vMmn/cd+O3L3SAoedGIeCeDCzBQYD/Bqv6+VouBbTWBJpHuiwv/LA6guzQXVIYoSRX5zKQHAc1CwXHHykZy6HLRPWpRvCfaKs4IHUtzaAkvoME2G6B1UM5cfy42PBaneQ1G4B8ySAQR89HaLnAVLnPGxDwsjSoBPuC1GYT6MjWYRN1nhqdceHbbV6X/GOGVbhHushvpaHItfLXo5rct28aWO7dSsDgTOqoz/hp19Gy3nWC8QlolOVCc3SKkyMG7TzGaxpmLUaCgf5SS1CG23LgPlwC7cOuKg5Ai66wSxYlsAKi+/c25zzevvq6aeRGKnAT8G+fw20QoblZ98VmR5DSzyfqlm
 +rF/kU8T
 OEwg9q9vJ9k4vT+In6AADcsb7+Gom9I0D897lsIk5gTiFFjB0imrAZkSSFibmeNof/DG9Pw/7UdTOy7SRl46GhOr/gN1bnYi2epDWR9YpIODNw0mDJTcN6dT8z267/akYvYxijK3zNNHzXHsAOl5eWL9Qlw4cJAqNStei8rzJfPQIuGJqQ21vVDPsTYWUhScGYA1rD/Z6CoIz/ovvRIlq3JtofVPp/8xmHCl/AJArp5h7YB//PinYxKSt2ersxiVmJ86VPQQmLhmg2R6lKWkDDQZ/solPr+I8WVaqUpvCYsWsH6hTHL8ib37/kGDAOzSkJ3KkB+6BXUGwHkip7hlX9xzWhOpM8HZ1bNWFoPXobeCPxrT2bGgs/fH5rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 02:18:42PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 01, 2026 at 12:59:09PM +0200, Peter Zijlstra wrote:
> > On Thu, Sep 24, 2026 at 10:28:10AM -1000, Tejun Heo wrote:
> > > Hello, Shakeel.
> > > 
> > > On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> > > > This series lets a kernel thread say which cgroup it is working for.
> > > > That cgroup then sees the CPU time in its cpu.stat and the stalls in
> > > > its memory.pressure, and the CPU time comes out of its cpu.max quota.
> > > > The first user is the memcg reclaim that runs from high_work.
> > > 
> > > This doesn't translate to net rx, which is another major source of
> > > displaced CPU usage. Switching membership on each packet isn't going to
> > > work there. Attribution can't happen that way. We'd much rather count
> > > per-cgroup received packets and prorate the CPU consumption. If at all
> > > possible, I think it'd be better to adopt an approach which can cover
> > > both use cases.
> > 
> > Ideally RX would be split for each network queue, rather than lumped
> > into the one giant softirq that nobody owns.
> > 
> > I know PREEMPT_RT has been wanting something like that for ages. Not all
> > queues are created equal. Some might want RT priority while others
> > should definitely not.
> > 
> > Furthermore, without ingress throttling, your RX back charge could
> > completely deplete the actual cgroup time quota.
> > 
> > Anyway, if you get per queue RX processing threads, then you can move
> > them into cgroups where so desired.
> 
> Gemini is trying to tell me this exists and is called Threaded NAPI.

For the accurate cpu accounting of net rx, threaded NAPI or softirq is not
that important. I think it is steering packets of the workload/cgroup to their
dedicated queues and only newer NICs have support for hardware rx steering.

For old NICs, we will still be getting packets for different cgroups on the
same NIC queue and I think Tejun is asking for cgroup cpu accounting for this
scenario to work.


