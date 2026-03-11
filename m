Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77A2FD0644
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08336B0005; Wed, 11 Mar 2026 03:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6A06B0089; Wed, 11 Mar 2026 03:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D6F6B008A; Wed, 11 Mar 2026 03:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3FE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:30:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7DF613B484
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:30:24 +0000 (UTC)
X-FDA: 84532959168.08.5414428
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 021E010000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:30:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c4rfGoCT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of gthelen@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=gthelen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773214223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t31ZXnqtqcleggzMvKNbvy7pSVYvoYusm5tH26uIFr4=;
	b=PMXt8RzS3lCAc8zihTGvzj2ffBwD2h9AMfYakjIPOHSBFS1oeFcdG9NQJc3O4hsALMgdjh
	zdWoQKcfXbHMRMXNVOkmKyVMHKL4krtRLd0i55pYER4SgXkRkWu5QAdMKjb7nAGpHkfDte
	/r9ZEfaDQ5W7QZ4A4eMkJ7gdibhRK6Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773214223; a=rsa-sha256;
	cv=pass;
	b=YaViABd7FQ6zvH4q11CSlwiWHIrOLGg1WGH0/sg/Uw84NVStdkReEQqabUpSmk7xI55Hbq
	wrJ83OY/XcsYOn9lrKNJLjrKha/kScNvSYYkiZKYRIBbDqaNkYqrfe5wBo4kgaD/NFsgho
	RfpZaPO1nZkWS/xppXplPFPxytGAm0s=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c4rfGoCT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of gthelen@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=gthelen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50906a98ffeso453011cf.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:30:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773214222; cv=none;
        d=google.com; s=arc-20240605;
        b=VhH+Y4JEUsVogo6uI0TjmLv25d0YmKIc4a5DVXaFI5umLrXYu0Dgcti6/kP3unK0Ji
         7xuVeT01wc72VC6eOD65ytR7CWYNj4EUy7ZA5U5jxZL2xybQANC+U6B3drivvgncIwHK
         aIrahNFFBxEJeEauH54a+lh+Nsht9P53A/dGOnUYDnO6BsT+AtnaKIcGhRiKvol46RHM
         pPVy1jYBDhaLmhjQPwwj7192CnJq/zXnyBmpKYit0TJRpHlbcaLml1psX47I2Z8DOm6n
         KCD7279AaIIU+E4IvDcNL3kP3vlcNJm/9zYvcKamUgbjzpypWDRlzzC9zectPtdj1hMC
         H1bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t31ZXnqtqcleggzMvKNbvy7pSVYvoYusm5tH26uIFr4=;
        fh=5aKli/OKZEtFoqiy21FnhFADKYH/Mv4WYYbR9/JO2FE=;
        b=cdfF9Xz5m2XWJiPV68pvYjS6bUEZ0Si6udtCQI7KCHNJPJWouiXtVMmQKo4sYrA0NV
         yXFSl9bMSQaLS/nO2GqABaOhcpm5sfQNw5FOtcBvUj8vPHF5og5WiqtffQk4M93U8ECO
         PRcyzD508Xb68fE1zziJl0j4KlNFpHyx3aqTdlPWkPaNJ6nTAqWf+000HTiiVbd3z40N
         ax+5JSixoGyEw/LIaXSAY4qX3rSYrX4I99n6RfFXxcXLCEjfBNag2TM6PZT8/+iK8eQO
         2JdRG7UoMllW5xOStNwEm/oeNmd36kNZQvOfQar2w/3Y2+HdqXS2SE69MTwYS80uQxH8
         zQ0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773214222; x=1773819022; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t31ZXnqtqcleggzMvKNbvy7pSVYvoYusm5tH26uIFr4=;
        b=c4rfGoCT0Jl6tcCCC3LiFHdEmMc+DUUG3wPfBJBeksw8cEhdNiBjLM92huDGSZO+LM
         Z+jXLUP8DgjBjniXC2zlX5YT6l8PdooX7MB5FucnHkgnojXSJhN1LGr+fxiFHrWqhwHE
         /LdeI/YiDqz19/tjkP4Hy+S+wIfbOBCwt7R8BlHl+9BgVpkgq/+uNYU6zc2pLuxD3QGJ
         31xO8JM0yiMCFQjQrHLNR+cVWz0p2qIamgP3zLGNwYjLOwWqzNWILtSZkDw04psJo3bx
         0UvKqXh8D074V14N3wb6k+mOC/WeFXqvUMERKysUc70fCVPlTxpf5OBSiF5NV67W8O2/
         9rYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773214222; x=1773819022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t31ZXnqtqcleggzMvKNbvy7pSVYvoYusm5tH26uIFr4=;
        b=oLNQRkSUtug0QXsksCUi5kRQ3G3d9xfMUHJaXXojI6TqwNI/ThCquG+zhldhgjCrGk
         6oKFbOtGwrmHFrZQvSf7hperoTJ3heWo+dN5X54hfxhi4ZD8XVVqCZPaQztO2HkLcHiL
         23JSyF1BRuWuXDgDUCn/3Awk2NcePphOrU2TFl6guBcb6BzaIxvCPWRzAYrFMPzOzEI2
         EnqGSXwDTvbdL8cmYz89kaIxnoNiOMLpFZTAbiFCXLq2Fq2/12h6gsSsNiPTNN3Mr2UK
         x752PmCaLZcviTXtUbHL+0gd0F70bcWQ4QoLyJvA/NF8q+02+YsINialYLo0W/VaRVkH
         hJ7w==
X-Forwarded-Encrypted: i=1; AJvYcCXdl4Gj10wQx3NmUxF2UwSfzgr1nfly9EaaajZGwAWoBLo/BIw2IYZW33oKWMzys4QFaRDZo4HkEg==@kvack.org
X-Gm-Message-State: AOJu0YysQB+D1fLM9wGJtcPI4PDqdDdqznjLbxsp5xyCelC+dpVKHWOt
	HwF8/3mfe+xUPS9CZdHwEfij778yxwgY/xtdjtRtg38IBNu56kOE5edtcZiRGgSBbobPyMpjYDw
	HJADdO/Ih0qFPPVQWSgI0rld+Tx8ljLkc8kmdWl7c
X-Gm-Gg: ATEYQzzMq7rGO3Bb1kq795tyJdhdKOaOV1tdYzXYhB0Ns2zJwQXsaXGJx/4n6URQhYq
	lkSw89AW8DKcQbNJeORtBXdX3t2x5iJ8nXVd1MLhrdMz+3NMgjwedMDO6xErAUvuXY51QrOtLJ0
	EO9pX3gx3e/FriKvUCDHQ3BkKFOEf8p65gXI2cDD+7IfdJVAaafhsfSiy4KibyOjFAe3VGLBRsC
	vPDZ3WZc+lbomAsSaq2AVAqvWgyuOZzLInW56RI+igSj56mNoF8eQg1Vu666ZxreB2wP38qtvpZ
	8ShPbaWsJgZ7z1cx/qYHGadwJPep6cwWxvzmCYk8bkpg9D44GQ==
X-Received: by 2002:ac8:7dcc:0:b0:506:a3c8:d44d with SMTP id
 d75a77b69052e-50939a11387mr7655101cf.9.1773214221216; Wed, 11 Mar 2026
 00:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 11 Mar 2026 00:29:45 -0700
X-Gm-Features: AaiRm52ewDXuj78L5TdgZnsKsJPibJbmvYXCb1R6-Es0rphZaXLYpR2TicuVGA0
Message-ID: <CAHH2K0ZBJV1peAZVZC9Lm=rFRzSfxsvbrxRjyB=+0xkHGRcdLA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Alexei Starovoitov <ast@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hui Zhu <hui.zhu@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Muchun Song <muchun.song@linux.dev>, 
	Geliang Tang <geliang@kernel.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Emil Tsalapatis <emil@etsalapatis.com>, David Rientjes <rientjes@google.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 021E010000E
X-Stat-Signature: 4qc91bemto5fnnrt8ehw8rt8tg56m49q
X-Rspam-User: 
X-HE-Tag: 1773214222-621417
X-HE-Meta: U2FsdGVkX18tvdJmR3aqWYFFK9KOnhFMs0gBGGFiSxFRCLw9G1MA3JMt1zt1oIHqa2+AwpkX+dI1VU09ysRrOONtC84c1MF8ZaaWpzyqHnYzvJdgvAIOOHPHTzoF6EzBRB9byEn9E7pDflmuelwbv0wc1H1gUK53XnAtYzv5qWCXNAXY7MtU7eBfakA8Dm1pJMjqMHfvJUebHGDsYrBZhyMMRCjh0uh/59wucjB38cc35gTbeUQzgy5EL84o93l1jv9VDcaU7pfb6bds4VEP5xvU2rMyiann0JIhPjtC1yywQncPjPe28ahFo11B9K6IouF6QB4X8xSUqxT+y2lNHiKObg13bulv0qHDgxqIVwqnFDK3wEBgAimZmtV8CQyywr3s86Xs1ms8zoliSwoivlLMsse9Zn7/J9I4vYq65nE1jUDlR3hIq5Q0cTn4/UYx476GN7hf57QYVkL8ckFLHf2G/7W2fIza2TtftEsoL6M7+K6uRqiGO9jn2e0SMw8mNRe3FGWFN9k+Dkkjl0PYFsC+4FBWcVnhC7hghf6EOXICosW2GiGDVmyHBdts0upf1dz/ubQ8gt5vibrLLK/rV7ReCFQfVEY9hrLhY4Sw44I3ytOAtAKb/8buBVrRtV5RUEo6aerw7N/4lEq7CqDvS8eCoLn/3P8qFeX+qk/FNpeJ/K6oMv+OC6BX1v3lmHIzSkF/R5Bt30bK0QstvvfdEiQCwevNNZHYJbFuSgCR252KbBav96zKWbDM9wWEuAr2pTtxo4SDmrA58cyx2tf/CKYABx4vudnawtCV1LwKYH1CK4jn+nYoKcy62Aqja1TRGsHWehT/5X3+aUV29vLO8c0VEzKacttMb+PctUQ3dn1eYTBUejBWcbZfvqSesdewd9d7zX6pSUEEhx0u/knUk1imTTVLivhN09UCpnk0NoUahG+RM6u3HM/7xqz43vDsW1H9TXDXyExpe8yDBTi
 YYqRm/hz
 SPA9+laxcPI5sQDCTmDVFCDD0FBuS6UWKAQYi7C3K+IGb349EPsdq/rR17/8wLPdJkbpIQuxDKnxVXG80GLto9t3dXh0wGdNJjcajL6vAYhRx3C8rRpugl8tE5zXJ1F5gMqqFlDvGkx8pHMX36uESjJiSf+1jc94Y7XlZjC95kJN7dKFCvdASxM42UWZaJL6WR31taN2se8e6yhLgVzY80DEdBgtv2GwDmSyb6EYM0myMi1d4+FKf4KAsPu9A/cocDRFyfgzoq/wIiE5vcEqZVFQV5/XrH1gfmQX6xQRZCEsLXAiqQFgw7bkWlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 7, 2026 at 10:24=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Over the last couple of weeks, I have been brainstorming on how I would g=
o
> about redesigning memcg, taking inspiration from sched_ext and bpfoom, wi=
th a
> focus on existing challenges and issues. This proposal outlines the high-=
level
> direction. Followup emails and patch series will cover and brainstorm the
> mechanisms (of course BPF) to achieve these goals.
>
> Memory cgroups provide memory accounting and the ability to control memor=
y usage
> of workloads through two categories of limits. Throttling limits (memory.=
max and
> memory.high) cap memory consumption. Protection limits (memory.min and
> memory.low) shield a workload's memory from reclaim under external memory
> pressure.
>
> Challenges
> ----------
>
> - Workload owners rarely know their actual memory requirements, leading t=
o
>   overprovisioned limits, lower utilization, and higher infrastructure co=
sts.
>
> - Throttling limit enforcement is synchronous in the allocating task's co=
ntext,
>   which can stall latency-sensitive threads.
>
> - The stalled thread may hold shared locks, causing priority inversion --=
 all
>   waiters are blocked regardless of their priority.
>
> - Enforcement is indiscriminate -- there is no way to distinguish a
>   performance-critical or latency-critical allocator from a latency-toler=
ant
>   one.
>
> - Protection limits assume static working sets size, forcing owners to ei=
ther
>   overprovision or build complex userspace infrastructure to dynamically =
adjust
>   them.
>
> Feature Wishlist
> ----------------
>
> Here is the list of features and capabilities I want to enable in the
> redesigned memcg limit enforcement world.
>
> Per-Memcg Background Reclaim
>
> In the new memcg world, with the goal of (mostly) eliminating direct sync=
hronous
> reclaim for limit enforcement, provide per-memcg background reclaimers wh=
ich can
> scale across CPUs with the allocation rate.
>
> Lock-Aware Throttling
>
> The ability to avoid throttling an allocating task that is holding locks,=
 to
> prevent priority inversion. In Meta's fleet, we have observed lock holder=
s stuck
> in memcg reclaim, blocking all waiters regardless of their priority or
> criticality.
>
> Thread-Level Throttling Control
>
> Workloads should be able to indicate at the thread level which threads ca=
n be
> synchronously throttled and which cannot. For example, while experimentin=
g with
> sched_ext, we drastically improved the performance of AI training workloa=
ds by
> prioritizing threads interacting with the GPU. Similarly, applications ca=
n
> identify the threads or thread pools on their performance-critical paths =
and
> the memcg enforcement mechanism should not throttle them.
>
> Combined Memory and Swap Limits
>
> Some users (Google actually) need the ability to enforce limits based on
> combined memory and swap usage, similar to cgroup v1's memsw limit, provi=
ding a
> ceiling on total memory commitment rather than treating memory and swap
> independently.
>
> Dynamic Protection Limits
>
> Rather than static protection limits, the kernel should support defining
> protection based on the actual working set of the workload, leveraging si=
gnals
> such as working set estimation, PSI, refault rates, or a combination ther=
eof to
> automatically adapt to the workload's current memory needs.
>
> Shared Memory Semantics
>
> With more flexibility in limit enforcement, the kernel should be able to
> account for memory shared between workloads (cgroups) during enforcement.
> Today, enforcement only looks at each workload's memory usage independent=
ly.
> Sensible shared memory semantics would allow the enforcer to consider
> cross-cgroup sharing when making reclaim and throttling decisions.
>
> Memory Tiering
>
> With a flexible limit enforcement mechanism, the kernel can balance memor=
y
> usage of different workloads across memory tiers based on their performan=
ce
> requirements. Tier accounting and hotness tracking are orthogonal, but th=
e
> decisions of when and how to balance memory between tiers should be handl=
ed by
> the enforcer.
>
> Collaborative Load Shedding
>
> Many workloads communicate with an external entity for load balancing and=
 rely
> on their own usage metrics like RSS or memory pressure to signal whether =
they
> can accept more or less work. This is guesswork. Instead of the
> workload guessing, the limit enforcer -- which is actually managing the
> workload's memory usage -- should be able to communicate available headro=
om or
> request the workload to shed load or reduce memory usage. This collaborat=
ive
> load shedding mechanism would allow workloads to make informed decisions =
rather
> than reacting to coarse signals.
>
> Cross-Subsystem Collaboration
>
> Finally, the limit enforcement mechanism should collaborate with the CPU
> scheduler and other subsystems that can release memory. For example, dirt=
y
> memory is not reclaimable and the memory subsystem wakes up flushers to t=
rigger
> writeback. However, flushers need CPU to run -- asking the CPU scheduler =
to
> prioritize them ensures the kernel does not lack reclaimable memory under
> stressful conditions. Similarly, some subsystems free memory through work=
queues
> or RCU callbacks. While this may seem orthogonal to limit enforcement, we=
 can
> definitely take advantage by having visibility into these situations.
>
> Putting It All Together
> -----------------------
>
> To illustrate the end goal, here is an example of the scenario I want to
> enable. Suppose there is an AI agent controlling the resources of a host.=
 I
> should be able to provide the following policy and everything should work=
 out
> of the box:
>
> Policy: "keep system-level memory utilization below 95 percent;
> avoid priority inversions by not throttling allocators holding locks; tri=
m each
> workload's usage to its working set without regressing its relevant perfo=
rmance
> metrics; collaborate with workloads on load shedding and memory trimming
> decisions; and under extreme memory pressure, collaborate with the OOM ki=
ller
> and the central job scheduler to kill and clean up a workload."
>
> Initially I added this example for fun, but from [1] it seems like there =
is a
> real need to enable such capabilities.
>
> [1] https://arxiv.org/abs/2602.09345
>

Very interesting set of topics. A few more come to mind.

I've wondered about preallocating memory or guaranteeing access to
physical memory for a job. Memcg has max limits and min protections,
but no preallocation (i.e. no conceptual memcg free list). So if a job
is configured with 1GB min workingset protection that only ensures 1GB
won't be reclaimed, not that 1GB can be allocated in a reasonable
amount of time. This isn't just a job startup problem: if a page is
freed with MADV_DONTNEED a subsequent pgfault may require a lot of
time to handle, even if usage is below min.

Initial allocation policies are controlled by mempolicy/cpuset. Should
we continue to keep allocation policies and resource accounting
separate? It's a little strange that memcg can (1) cap max usage of
tier X memory, and (2) provide minimum protection for tier X usage,
but has no influence on where memory is initially allocated?

