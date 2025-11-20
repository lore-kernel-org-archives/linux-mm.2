Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E75CCF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8CB6B00B9; Thu, 20 Nov 2025 04:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90156B00BB; Thu, 20 Nov 2025 04:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD126B00BC; Thu, 20 Nov 2025 04:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C91526B00B9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:30:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1EBC1A080C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:30:02 +0000 (UTC)
X-FDA: 84130463844.20.5FBEEF5
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id A118F10000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:30:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dtDoGHsj;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763631001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwimz9cV5XjfDnANvfrVBMpem/qAU7ggyHG03WSRMT8=;
	b=zUrXyu/omRIYRIfMwDEI52GxEd+MJeuTzwJJGaEMaauPQFk5SNPSW2935lRVduiMB3tOpP
	wmy4wKuzq5pZm4u/jQ1PaB5taCmgKF322LZhEND5g0Hh/LCe7IziTREGGez6jvxOL6jFsZ
	MfHDCe7OzKZZjbJLfoqlE/zZABhyDaY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dtDoGHsj;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763631001; a=rsa-sha256;
	cv=none;
	b=mfXCCBEvrAXgk2owJxyCjuYe/KnMNJ2lWegYRZ9jIiENPczKXFSllDpyFu759ORW58jNWz
	sIjWmOstMN8RGL5tsyglMfXKMhpNK1LadorN9quUhd+O97XJXRCu0GHKnSdI+b9et4I0Zh
	KA95I18/uifaqCi6OJhy1n9PdwpSQMI=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763630998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwimz9cV5XjfDnANvfrVBMpem/qAU7ggyHG03WSRMT8=;
	b=dtDoGHsjHF0f7eLfgt/72alDvV4DJdD6aK60GYDAs5ZFWzDt7l6gh9O0z/OP5dc+8VUiYl
	rR5yrsObR0rxNQ1wDXbKE/VMSuEjJHrj7xVlwLv9IIMgKz/F0Mv3GnjF/V0r6FCHXTO3TB
	e0gZL2EWmB62xNPGB3j1pFtg15MYcP8=
Date: Thu, 20 Nov 2025 09:29:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
To: "Roman Gushchin" <roman.gushchin@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Alexei 
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, "Song
 Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "John 
 Fastabend" <john.fastabend@gmail.com>, "KP Singh" <kpsingh@kernel.org>,
 "Stanislav Fomichev" <sdf@fomichev.me>, "Hao Luo" <haoluo@google.com>,
 "Jiri  Olsa" <jolsa@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Nathan  Chancellor" <nathan@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Tejun Heo" <tj@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>,
 mkoutny@suse.com, "Jan  Hendrik Farr" <kernel@jfarr.cc>, "Christian
 Brauner" <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Brian Gerst" <brgerst@gmail.com>, "Masahiro Yamada"
 <masahiroy@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <87ldk1mmk3.fsf@linux.dev>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A118F10000B
X-Stat-Signature: p3zmpkt5a9pp84mqcpa7zz3qxo18tgqa
X-Rspam-User: 
X-HE-Tag: 1763631000-276665
X-HE-Meta: U2FsdGVkX1+r/c36CXfBI7+Drf/Us1MG9DroBUtdo0pMRWYMPqpS9qYXgy0a6ymOcUG7WtvMsjcFA0PFgz/q4an3n+P4BWA19AtAEVZWEfulwz6ARzKSicf6jwFxjeFm+NzPdlVJm9JaAiM0HkXWTKAO+OZ6Pwm5F7wqvfbvLUQOVGlCE9DZHQeAgUtyriW5MDas23qwhxrMyfj8BGSMfC/FT4Xc+7Ppu/yOWTZ3t+zLUS3D8aen2wSmzQDH3jtQLSCCFaAMqECma6U+zzRV1q27L63ptrno+cDva5SI9aJzA6ywY+LBQ6GWH3/ZG1Idv7g6wOGNoJUuLVdEips0e9Qhxurc3UrpPUoRQj5YgNc8JAfq8cIWIzU5ymIhwZDikAiue4KBLYUumkdqQ6fe4tARf+Gw9FHG/Ti7I0ZMdl57M6WV0RcQMzwib/ndymV32AFLtm74G0SK3fpNOFCMCcXm9eoJesBpC438o/Mitf5eTPfOPHCVT5ZSTSHjGyDzv6H3U+93WK52VKgVHSWgWo7Jj3tm/Wg2LjjlD7IFR/uGXyS5AlVJAeikJ14dOVJ171q0i3LVnk1uhYmPP7pRCVF/9Sv47QMP+5J4XUlDPyhd3YwnYMiEaXlXOuHNyd/qrhPgsaGFGSYhVj92G/8FYWBvZ7GMGYSh86Qv7ODjnaCezDwg5mr0DGYLRYMsWVEcIu45WdypUPUvyawTjyQKPP+TrL3+Wh9eGU8Q4mJIy/TKRQOdrEskdWz54ATkb/2OvhmftUwUjJkNE3MQ9SF79tY4/hTMIJJXPQ8KCdFsIeaqv4q14vcvshPxAf8LRxdjs3v5cywNemYLiiKCZx3A3o6F4jd4jXcyW34nKsJMI6AnX+c2s3WjqbLxkQU6cJJP0cl9iV9WZglSvCmhhiTYtwQJBqYWpUynBjpTN6eHlROrterJcw8BR9xnAZ1vZR4fs62BkTdWVb4R4hm6YMm
 6xC3sfiA
 SMx1f8c5BU21zhDscHU3Pcf6ggeGq86BKz2Zryrw4TUA1kGjrXQ/Ox/PDq7/YIka9h2R4tuATrE5g53KqUzwhB2d67xx1SNTQvJGoWaAyd5r/6Kma42w3W6Tgr6SRiYADS6sRNNoiORW1O6o6yAx/uczkYxhnMtKdrArscGTq83dHqdUKwBFsoh1a649qQAVy4qV5Vbix6uDLTWvbB3AyqsAmSfKtdyjXMvBA3rZbKvpVuJEQiI7+0hn8d7UisKT6MWAxQVUrVk2m+Xx7L1tYHi+DJ6wPEweCGOd4z0Us9OcDTh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=8820=E6=97=A5 11:04, "Roman Gushchin" <roman.gushch=
in@linux.dev mailto:roman.gushchin@linux.dev?to=3D%22Roman%20Gushchin%22%=
20%3Croman.gushchin%40linux.dev%3E > =E5=86=99=E5=88=B0:


>=20
>=20Hui Zhu <hui.zhu@linux.dev> writes:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20>  This series proposes adding eBPF support to the Linux memory
> >  controller, enabling dynamic and extensible memory management
> >  policies at runtime.
> >=20
>=20>  Background
> >=20
>=20>  The memory controller (memcg) currently provides fixed memory
> >  accounting and reclamation policies through static kernel code.
> >  This limits flexibility for specialized workloads and use cases
> >  that require custom memory management strategies.
> >=20
>=20>  By enabling eBPF programs to hook into key memory control
> >  operations, administrators can implement custom policies without
> >  recompiling the kernel, while maintaining the safety guarantees
> >  provided by the BPF verifier.
> >=20
>=20>  Use Cases
> >=20
>=20>  1. Custom memory reclamation strategies for specialized workloads
> >  2. Dynamic memory pressure monitoring and telemetry
> >  3. Memory accounting adjustments based on runtime conditions
> >  4. Integration with container orchestration systems for
> >  intelligent resource management
> >  5. Research and experimentation with novel memory management
> >  algorithms
> >=20
>=20>  Design Overview
> >=20
>=20>  This series introduces:
> >=20
>=20>  1. A new BPF struct ops type (`memcg_ops`) that allows eBPF
> >  programs to implement custom behavior for memory charging
> >  operations.
> >=20
>=20>  2. A hook point in the `try_charge_memcg()` fast path that
> >  invokes registered eBPF programs to determine if custom
> >  memory management should be applied.
> >=20
>=20>  3. The eBPF handler can inspect memory cgroup context and
> >  optionally modify certain parameters (e.g., `nr_pages` for
> >  reclamation size).
> >=20
>=20>  4. A reference counting mechanism using `percpu_ref` to safely
> >  manage the lifecycle of registered eBPF struct ops instances.
> >=20
>=20Can you please describe how these hooks will be used in practice?
> What's the problem you can solve with it and can't without?
>=20
>=20I generally agree with an idea to use BPF for various memcg-related
> policies, but I'm not sure how specific callbacks can be used in
> practice.

Hi Roman,

Following are some ideas that can use ebpf memcg:

Priority=E2=80=91Based Reclaim and Limits in Multi=E2=80=91Tenant Environ=
ments:
On a single machine with multiple tenants / namespaces / containers,
under memory pressure it=E2=80=99s hard to decide =E2=80=9Cwho should be =
squeezed first=E2=80=9D
with static policies baked into the kernel.
Assign a BPF profile to each tenant=E2=80=99s memcg:
Under high global pressure, BPF can decide:
Which memcgs=E2=80=99 memory.high should be raised (delaying reclaim),
Which memcgs should be scanned and reclaimed more aggressively.

Online Profiling / Diagnosing Memory Hotspots:
A cgroup=E2=80=99s memory keeps growing, but without patching the kernel =
it=E2=80=99s
difficult to obtain fine=E2=80=91grained information.
Attach BPF to the memcg charge/uncharge path:
Record large allocations (greater than N KB) with call stacks and
owning file/module, and send them to user space via a BPF ring buffer.
Based on sampled data, generate:
=E2=80=9CTop N memory allocation stacks in this container over the last 1=
0 minutes,=E2=80=9D
Reports of which objects / call paths are growing fastest.
This makes it possible to pinpoint the root cause of host memory
anomalies without changing application code, which is very useful
in operations/ops scenarios.

SLO=E2=80=91Driven Auto Throttling / Scale=E2=80=91In/Out Signals:
Use eBPF to observe memory usage slope, frequent reclaim,
or near=E2=80=91OOM behavior within a memcg.
When it decides =E2=80=9COOM is imminent,=E2=80=9D instead of just killin=
g/raising
limits, it can emit a signal to a control=E2=80=91plane component.
For example, send an event to a user=E2=80=91space agent to trigger
automatic scaling, QPS adjustment, or throttling.

Prevent a cgroup from launching a large=E2=80=91scale fork+malloc attack:
BPF checks per=E2=80=91uid or per=E2=80=91cgroup allocation behavior over=
 the
last few seconds during memcg charge.

And I maintain a software project, https://github.com/teawater/mem-agent,
for specialized memory management and related functions.
However, I found that implementing certain memory QoS categories
for memcg solely from user space is rather inefficient,
as it requires frequent access to values within memcg.
This is why I want memcg to support eBPF=E2=80=94so that I can place
custom memory management logic directly into the kernel using eBPF,
greatly improving efficiency.

Best,
Hui

>=20
>=20Thanks!
>

