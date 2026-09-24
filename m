Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928B8C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A936B008C; Thu, 24 Sep 2026 17:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3226B0092; Thu, 24 Sep 2026 17:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2D36B0093; Thu, 24 Sep 2026 17:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 235DA6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:11:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9D091A0463
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:11:05 +0000 (UTC)
X-FDA: 85249900890.01.D6080B3
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	by imf12.hostedemail.com (Postfix) with ESMTP id 840E140002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:11:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eeh4tDSK;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790284264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JbpUae+jrOVWHmmQgpTkyMsva3jsejUC1U++zNIk6o=;
	b=jcvjUdLsbC2He7cjPaESJChEJm5r4KdqytVt6HuLnqeTLQDa2YyUGqSUcLZEN0An1KVts3
	FpDIMWCmN6aT19qNgbdh3aWge6WOd1Q5rPm2JwMXNlNRwMpYYgSZi9kcBzboGnTzlXVtHd
	pCDlz+9teIGyT0LGI9y3rGvuAK5Q2DI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eeh4tDSK;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790284264;
	b=KMVPAfvPrWc7pvYUB7Y5eHCalgd+y4cttRZIMGIQDOKheYDBnf2QiQKRHsHzJ7eV1KGVM9
	WAc1Vt/RebpMtn98gqqEpmfHdoZfAxmutFGDtYboVseNnGaN74EnleP9guDOVPEQxd9FF+
	a76OBoS7PaTn4CS8IzuRJObYuOYcSjY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=geWEgMSYQDaXHL8PI+SwL20O2XP2TtLwPQS9ZQiVmS0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790284262; v=1; x=1790889062;
 b=Eeh4tDSK23G+TbvqhrDIDogpAxLZ6xsTOdlLHlKDetZUvHYMlAb3Ik1/Ut9G4V0OpLuS3y0m
 tmLn0/6MzpnzE+zUdW0zakrd9SIewOskKFysWTXFiUgIYljj4C4UMB51spUhO9DV8AYOc1SNMmb
 p165Nm7nJOoKWTlpRoaGar18=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id de8f8ffe1b04012f;
	Thu, 24 Sep 2026 21:11:01 +0000
X-Mizu-Trace-ID: de8f8ffe1b04012f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 14:11:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Peter Zijlstra <peterz@infradead.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Frederic Weisbecker <frederic@kernel.org>, Aaron Lu <ziqianlu@bytedance.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <arWLq4p488JPhuZ1@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
X-Stat-Signature: e7uwfw1wu4e8qgsi1fckqm6ngrcckf94
X-Rspamd-Queue-Id: 840E140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790284263-597305
X-HE-Meta: U2FsdGVkX1+2NdM3AobLJmorgK2zWYOJ0R1qIZwXFTg+Ni6d2UgCK3NRMBIECnnLbUR207vCq/ElQT9Ak2i202qb6ekYfCnafVYiDz55KKTbDiE5gyDb86vL2dhhgNwKAMHA1c9o4XaUu3v/Pt0SZHhXE3OPi2DFeWD9tObaWSdMqZK/keNFvUey3qEGNCSs7c6ya+KTWO77FN4gVbcIXFEmPLNDKnJpHkYzXfeEcUiMN2oBh56V9YkMAVEnt/dlPGWW+4GuGng2C47diIlIJmFIQh0A+VsbVL5ly1xxFlcpXuzV7cu7Lr5JO0u/xthjW6ARDpbzOn14MqV8eQd6XADqf1bp5ncVUvQweLZo5gOKzi7BlzYgSgSeBfhAnyzPvU8sOCRyL4/e+MSfO/jorWys1a19FlrLl5TzbVvmzUDTZD7C2AwmyoUrT6M4rDvaYRX4iBQ5MArezXhbnCIq7OYXJWQhrrDHEoGQ+iFhE/dI58MDQ0wrje7eo5svlsd+2cs6JEdFIqpZfMSgDcEz8RlmXY9ButX5U75NeQSkcT6Jstrzm9IPd2YOGTNGbuMHEVbcoBw99L0rt5xPIsHTWSyPAE6VGO/h5lgcAbpO5pjm4SXnjbCfHhpAvI307rw0FDgBQkt6dhq8+4mue9cckbS0xH5W1HCrQbENeYu5oEucKk7xLo/j/8frbXY4suZbOdmCUpsunxhQi5dL0bF8zzKBBGSjLlr7fv9JDli7ietK46mkbtnxKZK4sZZyCVsp14m/y4BJXnqE9bKAo4QoMnC3hoMgma8+jl0AnYqVu0sjkcsX1KzIB37BITwWqOZ0RVkGK3I/C2m29ohnhln610nX714V2ALl8owlHnHfevYFVOLi6LyCrqdKKFHoEFj2VXQV2CJAZXOFH7Cf2m/MLEBG6j/RhD3MCBtKmQW2j3O6ABwrNmxQfQnoZ0/p3fX1vwTNaaq/4V1eWjJForf
 6o1vVMj8
 fzgqZlI001Ir7otJx3B2lN6wFBxv771w8rrV03PdCAUvspXZUoQeqEZUPegxfWKweF0YQi9VQvb/UUR1mM36WEzlKV9Gg3kmFs4+lsuXr7lMbxPdKhWFFw8OOX4sHEiDEhkUvkCnn/wVXu3GSvuZ5kv0FQJZof5fPpWveTvCfRbuRTQszV6IAHAOl0brPlC8o/z2zDw64QAigqNwIyOaVMaG0rIKXeWaBGxbltKCdW9Z+NFfnBAZO8OiVfmIVDWyMrqjeZo6uZF2cDWJz2js4KHodtNmm3DGnQUtXsioe+GNWe/3nSJH+pPIWp4kY5ZUqiO9iGVMcTx4ghUcak7hgxFF8TOg6/uTvPXK4acOy+7ExGeXX993pbPtrSKqvmdVmkON+
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

Very good point. I think we need to think for net rx for two scenarios. First,
the modern NICs with rx steering support and second, old NIC with shared queues.

On the modern NICs where the workloads get their own rx queues, I think the
proposed mechanism can help to do the accurate accounting (I have to extend this
to softirqs as it is limited to kthreads atm) very easily.

The challenge you mentioned is for the old NICs where we get to know the cgroup
assosiation of the rx packets very late (or deep) in the stack. Also CPU spent
on each packet is not necessarily uniform (due to out-of-order or drops or
checksum errors or window shrinking) but for simplicity we can assume uniform
CPU. Maybe the right place to charge for such scenario might be at application
receiving those packets into the memory. I feel like we might need a very
special way to account for this case (maybe through BPF or something). At
the moment to me it seems very hard to have a universal solution which helps
this case and the reclaim case I am targetted.

If you don't mind, I think having solution for modern NICs i.e. dedicated rx
queues, should suffice for now (unless you want the solution for old NICs as
well). Let me know what you think.

> 
> >  - The debt is capped at one period's quota, so one long piece of
> >    work cannot starve the cgroup for long. Time over the cap still
> >    shows up in cpu.stat. Writing cpu.max or cpu.max.burst clears the
> >    debt.
> 
> I don't like the debt capping. Having debt doesn't have to mean that
> the cgroup doesn't get any bandwidth at all. The cgroup just needs to
> be slowed down enough that the generation of new work is throttled and
> the whole thing doesn't go out of control. IO control already does
> this: when IO debt is accumulated, userspace is heavily throttled, but
> not completely stalled, until the whole cgroup's consumption comes
> under control. I don't see why the debts would need to be forgiven
> unconditionally. The cgroup can keep paying them while running at a
> minimal rate to avoid triggering stall failures, and if the situation
> doesn't resolve quickly, that will most likely trigger pressure based
> kills in any reasonable setup anyway.

Sounds good, I will remove this capping in the next version.

Thanks for taking a look.

