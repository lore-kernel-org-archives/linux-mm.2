Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 568B8FED2C6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78CF6B0088; Wed, 11 Mar 2026 23:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF90F6B0089; Wed, 11 Mar 2026 23:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25E36B008A; Wed, 11 Mar 2026 23:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91CF06B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:36:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CDF81B8830
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:36:30 +0000 (UTC)
X-FDA: 84535998540.21.904F836
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id A4BCA1A0016
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:36:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IYZJby7Y;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773286588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIeIxnDFvCAVP63KN+jaya1voCxZiwj51bRsQygs0ok=;
	b=Ih039ooxOAcLsPosIVzXTAr9SU6tbme5hskUez0fYOXpusy8dk6/yO+Df4GDAB5hkC5gmz
	6kjptilcBrTXeXqSq6EMa0A3qMkWeEjBj1dKGz0dujJEtNu6DgUax89qgqwdFpzg/gV58V
	pHhQ5oN8neriR9ZM3eNjT9k9x4bIvWk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IYZJby7Y;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773286588; a=rsa-sha256;
	cv=none;
	b=GM9J7X/g0k5lm5A+9+6qNmmmViwi/TEzhZMC66E5tZZUx3r8cuBveodabAchmazMAgO9+N
	xWwINTGdHTb85naY4DO9MkvQyLVngq1FOdqZJogPQaUq5W593D8tk8BobaVxyAcvWlrrHC
	5YGga1n1cHjNHu2k1HVt/ENoXMFT96E=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773286583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sIeIxnDFvCAVP63KN+jaya1voCxZiwj51bRsQygs0ok=;
	b=IYZJby7YmNF5PqJObweKxlt2ztpfKjN1MBTXhN0dFwGBJiLYqMS0qgEUy1itQcuW8lfJ/X
	MlXMyOy3uccORXsDLLBn5YQPZEHeG82Dc6J6io5oum0++DdKfNv9AXbaoxzAnTfsg6ItS1
	P4z3KYzUznaP8gVpK/Pcy0wg8BxYNT8=
Date: Thu, 12 Mar 2026 03:36:11 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <12bb0c22707193b94e7740b562daec80300544fe@linux.dev>
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
X-Rspamd-Queue-Id: A4BCA1A0016
X-Rspamd-Server: rspam07
X-Stat-Signature: bgi63iubk5x18kjpigtgwasktaxa1twa
X-Rspam-User: 
X-HE-Tag: 1773286586-593223
X-HE-Meta: U2FsdGVkX1/+O+D/9cGEmjQAERH33ZnPQP8F/PxiCKOk9QqKdlUpwtiQx86PnbYQWUqJDMQatQ+RqDb7byhYU0dNcdx9772cy/8lI9Dyqdd0e4zbKgZ841JXPTiLRZGvRn8kBB6M96azAJTlZPx6Pef9dl+PheEAvoq6gXQgnjaq0QGEILZ8ttuOQl5xpeHemtHhkZW38ShaHXDG8ew615dNjdO9QD2Phq8glLLO9tJMkOWB4Q7rKORo9na3UNJN1bBlwlLaYcnr0Zemnov6ybbUXE4825IFnQV0QRo6Qzan6fYDnmQwpqLXK7BySy2P+o4tJrucK15d1vs0OgXXXs7MsWGPy5z2n3ft6Yv8xhgG/0yFUSssRBz77KTo3PtK0u0fhyF+lAuNV2Xqqr1aJsJMZFnFWEUanUoo1vAqgqLDZOXw4WTBCwE+48WYRr+IVCZsG1gAX4CGK5+bI4gJY65X+eF3D1ea77W4FKRK2av705BKkbZH0C7M68AxE3aROwv5WpGh6QAzNB+u5mbX5jAVjc/mRpRVvmf3ngtcXmt7ETWjwV+WiYG3XAOmA7nVvKtqEsiRQ15yFmOwO149I7lwiixJ+eYdEWSEQBvg1Q/sRX4n0zqn0xFKdViN1R36cx9bH0Hqzwp/x4kN7FZHNjMJ5gkCOnoCISymKQi7p8pxts+vQPxiMp4By3hcytMTralPmtahOHoXG86hu1nhO4dmVAu8Ad0ApfgY6HYy3hG9MEVPlVP0dlP0DK7vz/feWnMjFsdkWXa272Mis9GjPDuHyV3GBX2jaAvmTby6xGfo40oIGEE/Fv0ddLxT0gdZDAMDgWl//X/zTNElCk4Cs0KMVdwCXttAke7U6nwbEi/LgSr4nM29R/A5dQdHr6qFTbdtm2gbi7gmTQR0ukgIy0/3ldqr3Rym1livBZlq6WmnDJPMkOJ+2jzRYSEWAbfJXry78p8QwuE4wlBA1Vf
 /Bfhfqs+
 9jMuYfzL188H2sWaMUj7OKyhyl4rf/I0Hfr3P+fvfF07b1kNtt8eCsVK4njc5tP21muTSS08jSKowy2ZTxmILfCZkH5B8IxEzk/PWIJNX0ut/IPUp8hYEEOz8v7SobG2sTQZHW9m9zeHFjmJBI11BtHi1ZOF1K9FoLVoNyrKvNKrPDd6U/C2hk/bsNsfi6R6W69J/P2aTE0pIT+FYKPwVYv1MbdIP+39/J+1TMuu9av+Ej3qtthJ6uXD9pzo/BGF7T7RY9SBAP8kIfk6UeoYBacuuGA==
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
>=20
>=20Per-Memcg Background Reclaim
>=20
>=20In the new memcg world, with the goal of (mostly) eliminating direct =
synchronous
> reclaim for limit enforcement, provide per-memcg background reclaimers =
which can
> scale across CPUs with the allocation rate.

I am aware that several companies maintain out-of-tree patches for
asynchronous reclaim, though some have not yet attempted to upstream
them.

Would it be feasible to introduce a generic memcg asynchronous reclaim
framework into the upstream kernel, where eBPF is used to orchestrate
and control the reclaim logic? In this model, the kernel's role would
be to enforce "guardrails" for these operations=E2=80=94for instance,
restricting a BPF program to initiating only one asynchronous reclaim
pass at a time=E2=80=94to ensure system safety and predictability.

Best,
Hui


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

