Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38626CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E6F6B008A; Thu,  1 Oct 2026 08:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EA36B0093; Thu,  1 Oct 2026 08:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354AE6B0095; Thu,  1 Oct 2026 08:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13E8E6B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:40:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98BDD403D9
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:40:20 +0000 (UTC)
X-FDA: 85274015400.28.327ADF1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id CA9404000F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:40:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vNaTELMc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pAZafPjW;
	spf=pass (imf17.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790858419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IYPn7YfrvPH70i6iIWikqwHZmBwJ1LMaRivmCTeR70=;
	b=GKUiEoxV0Wg84MEl25gLPXfUJO10EbalR4bk988yZ+PTrFkx1UzooxKKYB3i8NTJlRrMZU
	pSLZ9xmFtnBiEjahze6Ga4ErCQvGPZIy2/3fRiVkfTlA004c1e8v2ciG03jEpSkbLn/YSG
	XYhhsTaKrcx/6muIULaaSD3vGnf5WFo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vNaTELMc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pAZafPjW;
	spf=pass (imf17.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790858419;
	b=278YvLOiG0Id3nKa8VAWjcBPqA6MMVkdCBbu0K3TKPwFePvdw+L4g0I9QjJodCSN/zd6LZ
	YvGYfXedWXWixIAQgyAgmuNBIuJH2UbDS2F+XTDFg9VwprDKGnm7HDk+V5d6O1A8iohj5h
	ErTLaY/5LUNwqCpMTHzu1N+Tz16fvn4=
Date: Thu, 1 Oct 2026 14:40:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790858415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1IYPn7YfrvPH70i6iIWikqwHZmBwJ1LMaRivmCTeR70=;
	b=vNaTELMcGtZilr3kGDKfaocYqzlhPhhj4xUL8tc8l010QOAzqE1gfbhxJxRwY/CJQP2iNN
	dHH9FpmfCdOtt3+N3ScPLclEH64H0HxXM0XyxMXuAR4+tua64mSsXSPvBxry0xTcvdbkgm
	KPRAZxR5XGVY81qLZ13LeTCgnXQJ8G/pcZnnyr1fQKL3ADxyj2/P+q44R5p5vwJEURPdve
	lDaLdKElLZTBjIqC6N6SL4+K/9BV7zd5iVpAb4rYcJyYrsh5EVPwtridKE5DW3m8G1VJLC
	Umo9drwa6UmjTEY4g0S+6CJYedQIHJzFOepjcyObBpIb6WpgFvmNXH1pzeKY4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790858415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1IYPn7YfrvPH70i6iIWikqwHZmBwJ1LMaRivmCTeR70=;
	b=pAZafPjW5uf+ns5DVLvxgNdHgjcPnL7GKMJPYR3Qva+5gI6njuOLuPRYsAYBNuVlPHuNQB
	PI483XSZ/izTLNCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
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
Message-ID: <20261001124013.UZsWvi4g@linutronix.de>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA9404000F
X-Rspam-User: 
X-Stat-Signature: xkpawoohincijcdhf3xnf63qwwjtr544
X-HE-Tag: 1790858418-669001
X-HE-Meta: U2FsdGVkX181/rlPdc+MAp7n5H8WHLOgUtYIv1KNulyEmgUeu4Ok3q/ynJxq9K/xDMmnUTs4a/5lCxtVWssKnzCx0ndYMk1kujQiUPHwdP3ulqQ6rFSd4I4wWGdkar9oCewoaVkjTLIOivEFatC10fZR9W7upLr7FGmNY/Dt+NGsNksiJeKkFAlr5nBGxxg+FM9KaohmA4zasS6m2r5GrR0ubNwtfFahple/PDg1uCSetQL4VpxRdaKkgqxgamk6sfuqM4erHBloC/zhbGH49e3EavINPtCAQxHjsLGwuD5kB5+r0RV6yqaD2kWfOAcgeaLyLaRj4rb956znCRizVaaT75U3G+znrayVeNDKBa5atnarToI0XCTP+bfgu0FoO64QA5CUL9cCkNWJG7i+QmxkKOvQK9CwaIOEn9EWbPyYi4mHjkxZyE0m/K53l/21J3A0u0jFpiXWMpC1D8INhTwQHLgDFCKNkJQWxZVGmlheWxlCqrDrZBQyo2V6BLfMjbVTD4mG7dcWwTV16ANNxxMU99vZ+DV1zqYbzMwI7nWctahFyj1FRcrLFNC3wxKyE6ZXbQt3wqCgD/U9CUVkKEQSOtCn4WIp4wg7HmfUEJU5FwY+fKEKrcxAiaOGD9/3njcItJceiIiv1EpuU414n8NKnI9xXqStqn3gabvs3+p5amtnDliI6XNVk2BaC9HaP2XOunVm/7SQFgrHx9Q5+6+tzdQgK8ekWOsM17qCTufMyEDP6hvHxKPWmdpZBcburFvhZ0u2LbKIkxNV99uWfFj2WvTZknM1IkJAEs8gJyrK4vjbsBPbDjZCv9R4ufHdRDQpp5//+ehdka/zsFW+/0QhJj0i1YAb7dxQdCRSiRWNGVxdV2RRHCSs+K9dak2lemXq3k+o1IKoLu9DWw09N/CHz+KW+7mwg//n/8CC6pb0//OC9377EAKb8tRJB/T/Dn/eAcUrs5VyedC/+y3
 fakrKczW
 F3sPWkdWgwWnWEnntJY+ZxK0dZkKWLQHq0v4MR+HEbKVVV4DKlrk2nEj1oe9ypQER4VAckJEDZonl77A28sDErrbXZePd980ZYV0iIBO62DiZBDrg4+6UiU+m2ttSh5HZy2GDjhr0j+Y2MDak54IZ1U8zHaMcBfocah5dokzl1abC64LnObbdkv24P5xcM6L/Bmix09Q3Wz0C7FdFKTQdxt7LDlyooZiWDcP7SFFE2/fCfqdoCT8wRpu4w14Ht8NIel+jc/m4sAU/Ji54vQnrJYBwb+1+HNk5sZpUoS5a5Eas68Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-01 12:59:09 [+0200], Peter Zijlstra wrote:
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

What currently kind of works is threaded NAPI. The interrupt wakes the
NAPI thread rather than adding NET_RX to the global flag softirq flags.

I was thinking about making the softirq flags per-thread rather than
per-CPU. This avoid the "catch up" of other raised but unrelated
softirqs.

For now a painless setup is to have "bulk queues" and "real-time" queues
and what gets where is configured via hardware filters.

> Furthermore, without ingress throttling, your RX back charge could
> completely deplete the actual cgroup time quota.
> 
> Anyway, if you get per queue RX processing threads, then you can move
> them into cgroups where so desired.

Sebastian

