Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063DACA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC1D6B0095; Thu,  1 Oct 2026 08:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E566B0096; Thu,  1 Oct 2026 08:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2D46B0098; Thu,  1 Oct 2026 08:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFA536B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:18:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3224B120396
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:18:56 +0000 (UTC)
X-FDA: 85273961472.02.97D1ACC
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id DEA9880006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:18:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=OiPIkXFh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790857134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xQHNY097cBtbkyro3E4qxSO+Gg+rAp0ETijwlM2SaY=;
	b=Jg5YF8sOKHgwViW6BPXKi1GKC9tgQdTwB6PMh+ZBo+nm3pCt2C3Mliidgart57aNKZVN3k
	9oRO3cVUKB1HsacRXV/FEXMf+rNJjsH2CCWI2NDUBkPT+aj+janMugS3JH63z3b0ip3ddx
	1Rb8sJMKB5Hq4qWpZVXGBZRO+zBG6hc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=OiPIkXFh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790857134;
	b=5lL4ykV+ZH0pvnthSHVvMH2Z5BCGL0h0xtjrjHBAAfENom77NrAM/M7mk+nnmLw4O6X9fj
	FAL52sIzuE5jHHGozbnL1vJdZnGC8Bh+hA79EoSFCslmgrAOGDRXdeyoVb/TsA0WFdlKmH
	qowtoNBejrU6gxjitFAx4/nfv/KGy/k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7xQHNY097cBtbkyro3E4qxSO+Gg+rAp0ETijwlM2SaY=; b=OiPIkXFhwRsB7f4czffZ0jIZlm
	MCegJdLQMkRCITcBPZnjFi+xdFJmNsNYnkZ9B4CHXl8n/ymjc5GGKywxn+HO8CUzgI4tyswsKvAqG
	IEyk1gdrEjJcyNNll0GXiOdPIz5+009/vS4jAKYGN/PZVHPDP/KfEHnFARdHdAzaotCRe7FHa03Ox
	w4x26e8bbZjFvBTInTMYBT4reQytBaZGcobnOqemIzcSVXJhMp+X6GhTYVW5Lmy/4lvxbBJyn/kM8
	JG5Hsrb89Bs24SboJ23d6HZHCLw5zeztahs1xSuG6b0YPmq/plhVBaGeh66+OVKS56EtawE8lKtqS
	bkU1HZPQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1xCFkK-00000004xMh-08zf;
	Thu, 01 Oct 2026 12:18:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1EE53300578; Thu, 01 Oct 2026 14:18:42 +0200 (CEST)
Date: Thu, 1 Oct 2026 14:18:42 +0200
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
Message-ID: <20261001121842.GJ4121620@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
X-Stat-Signature: f6zthbkgtt7xm5gs199i6s1ao9jm93ty
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DEA9880006
X-HE-Tag: 1790857133-973084
X-HE-Meta: U2FsdGVkX19hhWJdgpvWO6t6z5Gabtj7LfWJNZcP+cDUHWaePi6m1+fP3sIN9pf5OMPXDt58OV80XVJnaPfiljeeNL9GkmTH571jsR86vEPTZGsK6yGhREu6Ayh2kKlx/kyA314+SAjYAqZeDAzqTGi1+yTiW5Tr5OENqUFl/of7c/Bk7sKctHOloKiKui31KZJ7BBKHPgZd8zFRqE+6vskwkibMuw/9OOMy8Nwz8iTtlAzGG7ZNTiYuUk5e+UdUlT8VCMX8MBwVx0cjcC4R1XWybw5Ro9SNYkNgdTZveKsF84cvsgNnq3vkVHgrjIOmYuPbmEvuwwkB7I/2qg5BKW90JZhLLEOZsxGf12edWH6pr/aENynIsX8zUF1uyEcMXJqtNLhysoQeHoT+0EoaGqrAV1mmvJO/+Ptb0zzMyXaAdKwGHwS7lrGdmcQW6N3vifGzbi099oiSXNlnE3c8eOAg34Tmslb8adaWYk7i2Uc8yhpbQyWgDhNpZHg0ltcC2bMiGp194T+O03OyT9/NuGK2D4DqZVhV1gYa2vCYifqWUwAXOnLoIJe1ei6ME7qzvuqpQ0XNvjJqRFKVKI3LwtKIapr20OHkfmUmJja7wJh/FM3sbIXoCykmtFrWW2l0aZxheciU6xIiYES7VDCF+RGD4s/PdZpTvyC0u7AhyHIUJPgQtBeYiTBbm3u1p5lXEDo+SHUg6GXU9o4nRrj5UHkiPHCiIA3NnSawDq4zLVV6n1sNZCRNtRFniZ9YwYMcRajKc6DnbNUszFkGWvAiomhPsQEP7xmWoUKVv0eg+woCqjiuo4QPzrIpRiToDbGDGhVIR43tReDxRrUqfb4fIsgfyaaqVuWtUeqwlV9XtsZBLS17Q+BW8zYFT21vvGZwgjUa6I2UFQ9co4fQKP3IILCp4bgUwCVsV0xB7WFXLliUxe7G08+P2NRuPtL9cw4iZ5IfDjopYrRThBt2v7Y
 MWm4Yje7
 5gSexhFKRtfr6R6WzCVPXW7A4nn+vPi2FT1IZ3JLcefUXqsZjWzR/ZcpOIYRhmduUg+OeZpvqUhTQbkvhGnxV4lxZMF5aG4rSOeQ6/rTRZUQrBqC1pSuK9bCGJ2NhROZ8Xqq052YNbNsa1B1FrlDfAv9647u+0MNG3rMm5hVvzDPeBWQAIvnjs+UrSG+LCUMLoxSxlfob4yvPwt127aoNDrinknzCiGvP5RuSGXa5rGIBFDz8G/r7gBsNtQk9fVlSr5Jxq0xZ3/4obWuyUqatoU3UdqxOY+PwmHjPQRDnXPUHtpfk1sz8l+qNvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 12:59:09PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 24, 2026 at 10:28:10AM -1000, Tejun Heo wrote:
> > Hello, Shakeel.
> > 
> > On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> > > This series lets a kernel thread say which cgroup it is working for.
> > > That cgroup then sees the CPU time in its cpu.stat and the stalls in
> > > its memory.pressure, and the CPU time comes out of its cpu.max quota.
> > > The first user is the memcg reclaim that runs from high_work.
> > 
> > This doesn't translate to net rx, which is another major source of
> > displaced CPU usage. Switching membership on each packet isn't going to
> > work there. Attribution can't happen that way. We'd much rather count
> > per-cgroup received packets and prorate the CPU consumption. If at all
> > possible, I think it'd be better to adopt an approach which can cover
> > both use cases.
> 
> Ideally RX would be split for each network queue, rather than lumped
> into the one giant softirq that nobody owns.
> 
> I know PREEMPT_RT has been wanting something like that for ages. Not all
> queues are created equal. Some might want RT priority while others
> should definitely not.
> 
> Furthermore, without ingress throttling, your RX back charge could
> completely deplete the actual cgroup time quota.
> 
> Anyway, if you get per queue RX processing threads, then you can move
> them into cgroups where so desired.

Gemini is trying to tell me this exists and is called Threaded NAPI.

