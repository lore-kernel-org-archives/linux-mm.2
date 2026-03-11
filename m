Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C81F5FD88F4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79AF6B0095; Wed, 11 Mar 2026 00:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D786B0096; Wed, 11 Mar 2026 00:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49E96B0098; Wed, 11 Mar 2026 00:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A48356B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:57:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 402F7BA13E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:57:52 +0000 (UTC)
X-FDA: 84532574784.29.929CD35
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69DEF40008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:57:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbp4mhfo;
	spf=pass (imf27.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773205070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3GKruKazSJqdxffywFhZhbdqtqrnzIQRTyoTECkXVo=;
	b=Qu4cElSCFranQRC1+uJcC86GL22gIQHMNlUJ73rHnc2xzUH50SuZofU3cmajVDJKB1kVt2
	lYkC1su47ERQNpqxl8Ev6b58qL1QHJ05jymEA/3pxztDdYfiHmIBc95aEydW8+tgC4Z4cq
	ZZzwQc2qA80ZVBX2Gz5eM0qnVUTFSiw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbp4mhfo;
	spf=pass (imf27.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773205070; a=rsa-sha256;
	cv=none;
	b=WyEAFDlla+5EBlvlg1wOwj8kQIQTuei8CUm8GDj33RaShdsKk5v+RSQTkCUUbnn6xPsHSZ
	8YpW9yqc/KHSGkclqI93djK090VWhObs3291QB4ZlfVxq9neoztJTZxLPkwletTE+81a3n
	3eF+paGkScCQOR+AXtPLMjI6CNVcsTc=
Message-ID: <6076b8c2-c198-442d-974f-b3084a0cd1b1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773205068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o3GKruKazSJqdxffywFhZhbdqtqrnzIQRTyoTECkXVo=;
	b=sbp4mhfoNFMO/ByBa4DmfjKKiA8zcPlX7AW9UF/OTfNksyWsS2ot7SrdPIb22cwO09a4xr
	EL+cfpi3wKA0WxxPXvqO6jYyxaK7cO4EbbyqMIhO647x4QAgjJLZ7LiHDz2wfu4NiZa/Ef
	ScU0Q4SPXXS0QqHFyUuN4BLAsDwFpjE=
Date: Wed, 11 Mar 2026 12:57:34 +0800
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
To: Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Alexei Starovoitov <ast@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
 Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Emil Tsalapatis <emil@etsalapatis.com>, David Rientjes
 <rientjes@google.com>, Martin KaFai Lau <martin.lau@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 69DEF40008
X-Rspamd-Server: rspam07
X-Stat-Signature: s3xexky6akf5gq4i3ymyqp6bjjz3n5p6
X-Rspam-User: 
X-HE-Tag: 1773205070-443501
X-HE-Meta: U2FsdGVkX1/gXgRTA/dvht1mzwW8yxgPkJ/gqMEOOByoQWZNfDkH28PdnziokEG9cV/+N3LOHkG/FYiYlGDX1J2bfCmW37jb1Zny8L0RfwEMbvcn56YKFBKr2r0AcuV6dGKepVPtl7GCQd4NUpzx5rbbiGKglsXbfwjxcHNvlOIF6mXwD/hIk2AxRg3mgmFOHqwPCg79c5FvlL9YNWJmefzE5DNue50nq0WB7VWdx9Df9pDi8b6WAHOqrTbEj/422JDpFHt/KZRvC067tBPI1mkzrY0GaangM6+hrx1qjIgj/x8GvTDaRTYwtHuTJe/d3Wr7zHlAxcvnqFp1HublcA+doOxhxWiplu9n3W495/s9p3vMTNGNN4A4fcilvEUoJNXegBpK+KyWSs2SjAj5PYZtr5XnnEvgdHtSO0UKnfaB99xDLbFhMnneiCVZ5qI9dKMwnL/qm/hlD3CcmCrhefP1zRjyMkFOKuGvFO2eo4CDVC5pL4b+600xlyDad8eJ0wfzjRhbTxaiZfO5vtjWpUFjkqtlZzCbZVkc5hfCxFpOhMUQJMmpF3vam9hYr0pFKnuOzuIPUCEfSyZhzd1j3eaT4fioX3FKuN13jmBEV48+WN8EQOpNKlmkJcIoI6/b0b+Q8MxJkCBc45w6rbzlDTY2bGgC1sqlsop9+FSrg/mJvLHlfjm2dn+WLJYRXY60PaX2G4hVsqiApqHPDKZtAxUpzoMkX8WZdjcl1UtejN/g5mbuBvXBuNOdJgr1u7pucLHmJdLd6W3DxeYhM9NyWqTZUydR7W/EcD+B+hk/XMRT3XrBE8VDWJNGmQCtfiyXd1Y1OfEh2tzpMUWn7qYXfko45073wfD91sF5wq3/fSlEDv06OfH/Guj9gK8o/tCOLEuXY2DbN13cpTcewjbrUexlUSNnlrkiTh0n/eQITcHcxBzn/BXOtCm39rcFPAw6sWWWkpI/D4wFNm8BvXm
 BAJm00UQ
 AjmXcDeT+JszpJAKOwKHXiWugKYjcPYE/Gx+YoAR0kJQDbrF1sEtSF30LGDD+OWOcLLjFJx/Vgj6EU99J2lLemjuduMD67yaGLToD4wIl+0Pv4+fcq0VEbc21jcV5PKWp115xP1CvGYpCAM4VjI9q20MWxLyH99VMMTnHKA6cCFD/ljq4H4Q8MgaOECJjK4bToXo7UzsoCIwEfYJqz8mXXNPcc7v1GtFnCsd8tvFVZ7h1NTH2kreXKBn+BHo/GJZf/GvB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/8/26 2:24 AM, Shakeel Butt wrote:
> Over the last couple of weeks, I have been brainstorming on how I would go
> about redesigning memcg, taking inspiration from sched_ext and bpfoom, with a
> focus on existing challenges and issues. This proposal outlines the high-level
> direction. Followup emails and patch series will cover and brainstorm the
> mechanisms (of course BPF) to achieve these goals.
>
> Memory cgroups provide memory accounting and the ability to control memory usage
> of workloads through two categories of limits. Throttling limits (memory.max and
> memory.high) cap memory consumption. Protection limits (memory.min and
> memory.low) shield a workload's memory from reclaim under external memory
> pressure.
>
> Challenges
> ----------
>
> - Workload owners rarely know their actual memory requirements, leading to
>    overprovisioned limits, lower utilization, and higher infrastructure costs.
>
> - Throttling limit enforcement is synchronous in the allocating task's context,
>    which can stall latency-sensitive threads.
>
> - The stalled thread may hold shared locks, causing priority inversion -- all
>    waiters are blocked regardless of their priority.
>
> - Enforcement is indiscriminate -- there is no way to distinguish a
>    performance-critical or latency-critical allocator from a latency-tolerant
>    one.
>
> - Protection limits assume static working sets size, forcing owners to either
>    overprovision or build complex userspace infrastructure to dynamically adjust
>    them.
>
> Feature Wishlist
> ----------------
>
> Here is the list of features and capabilities I want to enable in the
> redesigned memcg limit enforcement world.
>
> Per-Memcg Background Reclaim
>
> In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> reclaim for limit enforcement, provide per-memcg background reclaimers which can
> scale across CPUs with the allocation rate.

This sounds like a very useful approach. I have a few questions I'm 
thinking through:

How would you approach implementing this background reclaim? I'm imagining
something like asynchronous memory.reclaim operations - is that in line
with your thinking?

And regarding cold page identification - do you have a preferred approach?
I'm curious what the most practical way would be to accurately identify
which pages to reclaim.

Would be great to hear your perspective.



