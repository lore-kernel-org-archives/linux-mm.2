Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0215DCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A7B6B0088; Thu,  1 Oct 2026 06:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073016B008A; Thu,  1 Oct 2026 06:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA326B009B; Thu,  1 Oct 2026 06:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF4546B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:59:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 429421203B3
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:59:22 +0000 (UTC)
X-FDA: 85273760964.03.F2378C2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF375100003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:59:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LCl1OI8l;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790852360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXA2KDE32vmEL8dBfumYlL+dA+/j3dJ1ohxuDqggpGk=;
	b=oxfw9j8ckt6Dqdhxx0V4CgI2FUUDlj3zuX/e1PlttrF4HHTjTb8801huuZyMib82loTrJV
	evSqIwyXjn+doqYrseIUbkNOEK5XoWa7zA2Ye6fhWbsLenZrfh752N6WGQoVLvAbhFmfa9
	+OHN9xGEBScnGAcwX0Fa+bceoNKbTVg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LCl1OI8l;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790852360;
	b=skke9zTDrXkZcAZr/Ob0QEE/km4ODgOSopPzviFg94hlzZ5PCvYqkBeJfv76X6oIO6XFZI
	h7emHUyXgeIsStM8TyE5UrP0xwSdnql8idFdtTcFDeCGynr1vX8jN9lMncGTTQtnaSoZkF
	gmcoHnL2BoQwXhV5wtW+4huNC1oEtJ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MXA2KDE32vmEL8dBfumYlL+dA+/j3dJ1ohxuDqggpGk=; b=LCl1OI8lRvcv+outLHBWL9A2bo
	DG5ITJUiFjfuw/CEH5vbNjtI/P+BGLUvwXGLDA3jC0T340gY/Wk7k1gpkQvW1Z70RfVbhOYmCo3xw
	AQrPBZuoPECelcO87vpNBk1zQqZk4sUCEzOkgiymVqQuPddoPjUy5oK3h0Qme/AB7rJNngceuc7hq
	SpH7CHPQ+yTaxLRhMOeVVPTVIV3l0euLPDh5NhuMo38PzhWMuEE+tFR7wdSAxCvYvgzjUDCfjyRZJ
	2Vfd5RXX1oJ8sfOXd6TivgxG21zO1fScJ0vlE+bpH4aP4s6m55zck+Q/N8LB/P1cBonRI090dOtPd
	BxfbrTrw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCEVK-00000006r8z-1WSi;
	Thu, 01 Oct 2026 10:59:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E81DA3001FD; Thu, 01 Oct 2026 12:59:09 +0200 (CEST)
Date: Thu, 1 Oct 2026 12:59:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com,
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
X-Stat-Signature: jkis713txunu9nwdkurcpy4xwq9pqq5g
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF375100003
X-HE-Tag: 1790852359-964430
X-HE-Meta: U2FsdGVkX18jPsecaSp2HN7Yhoe/9giBP8pourLdXX9IpvvrDcisAmiDlDolnqk+/FEiLmPkQFvn6ttgbFBqTqw0XiPAnmbahti+8NqJqWhXFPHOpOjAGeSxuVgncSwwB1700AZLW81jgzCFwt5sIljeuQ+RKQM9B1xmTMDPnEgqKzRgpJEi+gufT70YcGYGsCIO38F115uUKb+ym0L11kkjmi0grmjBHGKpVCmiW+DueGgV+qOVA0EydJVqlxGvKhNWUXoLnYwertmPz9WMYwhwDvptF1f4zSYKfiQtuy38ye3tJMJKSpOJqB7WojyfNncJmMVl/fBcWHoQXmINYi+2CHADBSaUTxNmicArbSmpoF3VunGnLKdU8hsP8M1mEWOOFDkoiu+caIRRZii+9KWN1VWeetEoeItfapGCSC5IFd6IpT39ymO03nR6cwni4eA5PyPLqzNG6ZeaRWj9wKpi2GxC5Q9sflrsb7qwTSwr9iWKyMHv0y4ibTnP8GTRXUBREMNq1WmQ6hAD9A6e1MXVj+Wv9cm6e+snDhV13VOyMw7WIKY6NSsFusXG9pAeixpFaVwyR+ls+5MR4Qdf6kgIhqZW29u9b9RZKMq8vOEEZuLerxAgFRynag7DPaBFiWTSv4TCtwavllAyzgtBEqsx5Fy/Gnfc3GnnPVcSku+ALSQRu5azo77RHuNq1z5OAswPT/na9OcwSftmkqFVh+YvixR87Y6TF6cbWWrTlrCD6SQsNQofifbwbYqUukXH2PdQ+vuswTqtRxFtzz+Xk/FBWDjIFOGCbhECfKXPZWuRizKYt01s28KPPNWb4+OCNReUYa2AU7NFp0rwjCCOplen9WQZTEs6K7z6CnVlB0xIOWyVy285Xi80tPiMwB6wk5V+Jt5fwTTpYc7QZjCD9hyYFlGoTApmcOVQPBlk+GFdNYHfk0P7wbuwzcicSaQIpz0g54ZAMImFsE5MiW9
 6bRJsH6C
 QLtc3c1QemxSn5Tl5YTR/BK3UKfPsZNDdcOPnA5YLO1loy85blRDz45jfDge/LtNLnfyMbuLmHMFrD3pOeCFQ1/+BVkOxO84uadnqcncjB3J6TVY7b7byeFeP1CELHfkNeEfAHDy/lcoLhOE2HvSUdb++mNBKnvb/UAStP7DutTPXgz9/cnRRBrPkcr8W863+Y74jVjpE8FDbLjZDoSBct+B3e1G5vYzWetv3xVCU7+87XyIWrClUoPlsxYMPHeUbgi5QdAOujSheVWD077XvIP7uaS3tc0JInB+5DBCe562oP46ge+L5X4eSYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:28:10AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> > This series lets a kernel thread say which cgroup it is working for.
> > That cgroup then sees the CPU time in its cpu.stat and the stalls in
> > its memory.pressure, and the CPU time comes out of its cpu.max quota.
> > The first user is the memcg reclaim that runs from high_work.
> 
> This doesn't translate to net rx, which is another major source of
> displaced CPU usage. Switching membership on each packet isn't going to
> work there. Attribution can't happen that way. We'd much rather count
> per-cgroup received packets and prorate the CPU consumption. If at all
> possible, I think it'd be better to adopt an approach which can cover
> both use cases.

Ideally RX would be split for each network queue, rather than lumped
into the one giant softirq that nobody owns.

I know PREEMPT_RT has been wanting something like that for ages. Not all
queues are created equal. Some might want RT priority while others
should definitely not.

Furthermore, without ingress throttling, your RX back charge could
completely deplete the actual cgroup time quota.

Anyway, if you get per queue RX processing threads, then you can move
them into cgroups where so desired.

