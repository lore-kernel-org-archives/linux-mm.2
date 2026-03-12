Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5BE103E304
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2B46B0089; Wed, 11 Mar 2026 23:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D106B008A; Wed, 11 Mar 2026 23:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA076B008C; Wed, 11 Mar 2026 23:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A97646B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:06:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 588AB1606E3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:06:19 +0000 (UTC)
X-FDA: 84535922478.09.F67C1F7
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id B2368180003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:06:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyJEnX9t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773284777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGFurI1HMiVQpe/Es2aqTyJkXs9oXmKfRP7Wks7PWJc=;
	b=TtYRjzNQiGbQ7euQma67absMI3ohVM8Xfjo6Gaz29nnYC7mOoOUloPUqjWCsjzPuXBuxxN
	eyCyks+vBSDcROKxJypvrCzP9NKD7JYfpzxVajZwe3Gp/wZa8jeGbX2IOa42h//MsA0dZn
	jNSNKvSQ6kCFJAS9dyl5P9YVCzaSOcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773284777; a=rsa-sha256;
	cv=none;
	b=Zlx1jH6nQ9kwoMC35xgp4l4RVmqivXl7TLaPpa9w9Ex4/Y+0NgemLS+9k5pDUXu+APBa0r
	EW+9PkYkJ3AeISP/Mf+RH0eY08GmijL3fP6PZ4tHV+pQKa5N9T+XtddIZK3VLRnMtHci3p
	ih65/MJkLjxLzc8cnwwjmHS24JZ5jPY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyJEnX9t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773284773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGFurI1HMiVQpe/Es2aqTyJkXs9oXmKfRP7Wks7PWJc=;
	b=pyJEnX9tlRFDhTKkp80yezWuK2gIgc9vl+h3GItPkMF87DL/OK/8rlPY4hhNx5BPULTuui
	Wi40eGSovMFNAU+BtvJDgBWC0lM6qKR1FKBmKGUKXoZw3KfKJhaQ9RuuD5nH+6LXoogTNg
	zrm+4j5Av+dwyOI1ru5JFur2V3/H51c=
Date: Thu, 12 Mar 2026 03:06:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <e0390b058eb5123c99e6c8a72306efe7a1770411@linux.dev>
TLS-Required: No
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
To: "Shakeel Butt" <shakeel.butt@linux.dev>,
 lsf-pc@lists.linux-foundation.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Tejun Heo" <tj@kernel.org>,
 "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Alexei Starovoitov" <ast@kernel.org>, "=?utf-8?B?TWljaGFsIEtvdXRuw70=?="
 <mkoutny@suse.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "JP
 Kobryn" <inwardvessel@gmail.com>, "Muchun Song" <muchun.song@linux.dev>,
 "Geliang Tang" <geliang@kernel.org>, "Sweet Tea Dorminy"
 <sweettea-kernel@dorminy.me>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 "David Rientjes" <rientjes@google.com>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Meta kernel team" <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B2368180003
X-Stat-Signature: yhzkeq17hhqy7heezih9443as8p7zchu
X-Rspam-User: 
X-HE-Tag: 1773284777-618262
X-HE-Meta: U2FsdGVkX18CtEbbN0QdHH4uQxobPOC0CkCp9skCqj6DJJZC483r7KUntSO82JEiQJofetIjEFhMztIin0HhHq6hwo96+L4eQOZH6TbjhyZFOzkCb08JsrBUoX+TFAIuC8dxaG4ERi85AnpwUL35mU8ULZexsUKh6Hqkit+aKSfY2jewWzS9p0VKiHxNJSxuDpz6TDb5kbEtzFDbsL1IpNhNIXrcE3BmMMSD0rvmcfyyPfwCi+CheWiF4EZgsYUlru490HLY/wUvuMwaFVbYVKq9FJtXWlCT9Aio/PdLJQi3QQfg+T1M3MWOUrFnFsVqajrgj+FAAzrn1nTO1dRjGAg2Fi25aM83KOEr4KihFm1UJ5gwLQJacuQJyRDsWTLvt9ib//pF2ScXSif5p8pdWXsMsNsB9cobHn/64OCFlhSDEkTjaxsSoeCietUyTt5M57L3i7CGbfOAEjtDwNxnuiQS9oNBf8xD3Hp+A4wogLniqZgsLYCrPoc2cZKUJVZGGwZ2c0CXHVBJVNzoT7479wAzz/t3d4/kLzpWQy2sWtItkW7JN7yRmkMg6hmJuMzMBlQ+Z8CdHojV6r9btbMJxVkcC/pOU91dD063f/qIuZ9HeV8E3+LRHAHhKHDrFLodbJB71MDmUsX7pFFr7UqmF4YKKIg6bOj6YtqxXXJ7RjHPnlh7IgvZ6di0lQN8f/yYi7vtEzM5O8Wf/ZvCaec/P8KqiXGBtQicJa4jxo9p3nqj3CC5F9ROnLq11ptK7Pha38TF3zCaAYLlAKl+0P0xqALd3RlZFsoK4jt3A1AV+KA89rA4L9ycuAOlGlBT98jY0pSNb+2IUzTvR/kvssBgMppqPQMQlpKsfrfj9sXmdHH2EuX83t7Zupb8PL1ELd1125/u6HDJ8erzyH06fYpKhOePwKznlmnz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B43=E6=9C=888=E6=97=A5 02:24, "Shakeel Butt" <shakeel.butt@lin=
ux.dev mailto:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshake=
el.butt%40linux.dev%3E > =E5=86=99=E5=88=B0:


>=20
>=20Over the last couple of weeks, I have been brainstorming on how I wou=
ld go
> about redesigning memcg, taking inspiration from sched_ext and bpfoom, =
with a
> focus on existing challenges and issues. This proposal outlines the hig=
h-level
> direction. Followup emails and patch series will cover and brainstorm t=
he
> mechanisms (of course BPF) to achieve these goals.
>=20
>=20Memory cgroups provide memory accounting and the ability to control m=
emory usage
> of workloads through two categories of limits. Throttling limits (memor=
y.max and
> memory.high) cap memory consumption. Protection limits (memory.min and
> memory.low) shield a workload's memory from reclaim under external memo=
ry
> pressure.
>=20
>=20Challenges
> ----------
>=20
>=20- Workload owners rarely know their actual memory requirements, leadi=
ng to
>  overprovisioned limits, lower utilization, and higher infrastructure c=
osts.
>=20
>=20- Throttling limit enforcement is synchronous in the allocating task'=
s context,
>  which can stall latency-sensitive threads.
>=20
>=20- The stalled thread may hold shared locks, causing priority inversio=
n -- all
>  waiters are blocked regardless of their priority.
>=20
>=20- Enforcement is indiscriminate -- there is no way to distinguish a
>  performance-critical or latency-critical allocator from a latency-tole=
rant
>  one.
>=20
>=20- Protection limits assume static working sets size, forcing owners t=
o either
>  overprovision or build complex userspace infrastructure to dynamically=
 adjust
>  them.
>=20
>=20Feature Wishlist
> ----------------
>=20
>=20Here is the list of features and capabilities I want to enable in the
> redesigned memcg limit enforcement world.

Thanks for summarizing and categorizing all of this.

>=20
>=20Per-Memcg Background Reclaim
>=20
>=20In the new memcg world, with the goal of (mostly) eliminating direct =
synchronous
> reclaim for limit enforcement, provide per-memcg background reclaimers =
which can
> scale across CPUs with the allocation rate.
>=20
>=20Lock-Aware Throttling
>=20
>=20The ability to avoid throttling an allocating task that is holding lo=
cks, to
> prevent priority inversion. In Meta's fleet, we have observed lock hold=
ers stuck
> in memcg reclaim, blocking all waiters regardless of their priority or
> criticality.
>=20
>=20Thread-Level Throttling Control
>=20
>=20Workloads should be able to indicate at the thread level which thread=
s can be
> synchronously throttled and which cannot. For example, while experiment=
ing with
> sched_ext, we drastically improved the performance of AI training workl=
oads by
> prioritizing threads interacting with the GPU. Similarly, applications =
can
> identify the threads or thread pools on their performance-critical path=
s and
> the memcg enforcement mechanism should not throttle them.

Does this mean that different threads within the same memcg can be
selectively exempt from throttling control via BPF?

>=20
>=20Combined Memory and Swap Limits
>=20
>=20Some users (Google actually) need the ability to enforce limits based=
 on
> combined memory and swap usage, similar to cgroup v1's memsw limit, pro=
viding a
> ceiling on total memory commitment rather than treating memory and swap
> independently.
>=20
>=20Dynamic Protection Limits
>=20
>=20Rather than static protection limits, the kernel should support defin=
ing
> protection based on the actual working set of the workload, leveraging =
signals
> such as working set estimation, PSI, refault rates, or a combination th=
ereof to
> automatically adapt to the workload's current memory needs.

This part is what we are interesting now.
https://www.spinics.net/lists/kernel/msg6037006.html this is the RFC for =
it.

Best,
Hui

>=20
>=20Shared Memory Semantics
>=20
>=20With more flexibility in limit enforcement, the kernel should be able=
 to
> account for memory shared between workloads (cgroups) during enforcemen=
t.
> Today, enforcement only looks at each workload's memory usage independe=
ntly.
> Sensible shared memory semantics would allow the enforcer to consider
> cross-cgroup sharing when making reclaim and throttling decisions.
>=20
>=20Memory Tiering
>=20
>=20With a flexible limit enforcement mechanism, the kernel can balance m=
emory
> usage of different workloads across memory tiers based on their perform=
ance
> requirements. Tier accounting and hotness tracking are orthogonal, but =
the
> decisions of when and how to balance memory between tiers should be han=
dled by
> the enforcer.
>=20
>=20Collaborative Load Shedding
>=20
>=20Many workloads communicate with an external entity for load balancing=
 and rely
> on their own usage metrics like RSS or memory pressure to signal whethe=
r they
> can accept more or less work. This is guesswork. Instead of the
> workload guessing, the limit enforcer -- which is actually managing the
> workload's memory usage -- should be able to communicate available head=
room or
> request the workload to shed load or reduce memory usage. This collabor=
ative
> load shedding mechanism would allow workloads to make informed decision=
s rather
> than reacting to coarse signals.
>=20
>=20Cross-Subsystem Collaboration
>=20
>=20Finally, the limit enforcement mechanism should collaborate with the =
CPU
> scheduler and other subsystems that can release memory. For example, di=
rty
> memory is not reclaimable and the memory subsystem wakes up flushers to=
 trigger
> writeback. However, flushers need CPU to run -- asking the CPU schedule=
r to
> prioritize them ensures the kernel does not lack reclaimable memory und=
er
> stressful conditions. Similarly, some subsystems free memory through wo=
rkqueues
> or RCU callbacks. While this may seem orthogonal to limit enforcement, =
we can
> definitely take advantage by having visibility into these situations.
>=20
>=20Putting It All Together
> -----------------------
>=20
>=20To illustrate the end goal, here is an example of the scenario I want=
 to
> enable. Suppose there is an AI agent controlling the resources of a hos=
t. I
> should be able to provide the following policy and everything should wo=
rk out
> of the box:
>=20
>=20Policy: "keep system-level memory utilization below 95 percent;
> avoid priority inversions by not throttling allocators holding locks; t=
rim each
> workload's usage to its working set without regressing its relevant per=
formance
> metrics; collaborate with workloads on load shedding and memory trimmin=
g
> decisions; and under extreme memory pressure, collaborate with the OOM =
killer
> and the central job scheduler to kill and clean up a workload."
>=20
>=20Initially I added this example for fun, but from [1] it seems like th=
ere is a
> real need to enable such capabilities.
>=20
>=20[1] https://arxiv.org/abs/2602.09345
>

