Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E50CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 00:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E47F8E002F; Wed, 20 Aug 2025 20:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCBB8E0013; Wed, 20 Aug 2025 20:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9108E002F; Wed, 20 Aug 2025 20:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 075B48E0013
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:01:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE2E4B6B50
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:01:16 +0000 (UTC)
X-FDA: 83798809752.12.B493D5D
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id 70A68140004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:01:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pc35xtXI;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755734473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ger/qweYHHzaUe3FV4Wv14vSwD3CF++vJGGLP64KKcY=;
	b=qNhwB0IWf1SOGjVgf8NF5u53w+4TgEYdjGHrPUglTyqvuLIB332l6bHLX/nK5nm3HtcrOq
	N/72v74BnyP4IEKFL9D/ExZQvAV6A/M4g3WIOUqdzlquL5orG7fhAl05q0Ml5nro6O0spk
	s/P7IA4YgoBana2cwgXT1CWkBIG+W4c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pc35xtXI;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755734473; a=rsa-sha256;
	cv=none;
	b=sdnZsianofdXl7paeKYmLIS9LTENCm/SPSiy2YvbbGKREn2zraNhixJttSNJNg679+YtlM
	HWbzlxnjDxd8SGhQwJYXYMtpifsC++AKbYJspBSLWiVzW5gYhFyXglW6DVzCf2YZopn/0P
	yrSyxkaLBTmltUA45bOMBF4cu1oH+48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755734469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ger/qweYHHzaUe3FV4Wv14vSwD3CF++vJGGLP64KKcY=;
	b=pc35xtXIZlp2eACvENXjSMXLBYyW6kXDavibuV2c9ZWtE/1L58MNqp1IAVT9whMOGnnCxK
	yVFNSTpJOF0b688fs6q0QOEs5C23tZTm0+DPZaV9tex5GJLA1GQwqniu+DLj42mnKJo+pb
	lY2to00ZyhEojTxWBlpV6/lpNuOJKTs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/14] mm: BPF OOM
In-Reply-To: <h2bmsuk7iq7i6hphp7vbaxndawwgjz42mhfntlcc2yt4u6but6@7xlre5c56xlq>
	(Shakeel Butt's message of "Wed, 20 Aug 2025 14:06:03 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<h2bmsuk7iq7i6hphp7vbaxndawwgjz42mhfntlcc2yt4u6but6@7xlre5c56xlq>
Date: Wed, 20 Aug 2025 17:01:00 -0700
Message-ID: <87ldndmtkz.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 70A68140004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 69by5qetjnpdgxgdxy98pqeptk7mu5ty
X-HE-Tag: 1755734473-227724
X-HE-Meta: U2FsdGVkX18TeAo9oLJqszxF0Cd05j+lr8WPeoK3r4AvyBAYJQM1V/Cd8kpo7muZUCZy9Ptk6VREXXa9UFXtCGBA3bg5OAFJm1XqPntJMqGGAza1pPBo5McBFg44FslWFTjBKhsPOIu0ej7uEXYEOM3ekgOKfJdq93YBKeiG9TAO1zdf2t0+InqCPX8KSm2Eob8HHS5kqqLCuEqwvGQW5b3Ls2xIbTyPECVoltW0PZ5Fu7f6IW0Jw9PgOoBWn2e3t2mA072/5Zl5ij5H5VA8XuRXEfYbJ8yFwWrgCO5R3G76+Ud/wlS0aFpcOkvsBpU3TQEYS7MpC2krSSBbgUVPLSt6d2PdaVBBEaP6K6hj8uQZrtQMKpdgyg2t4LlwKFA/gRuftAk5UfkSwGDwj5XQknxtf3e9+4mWvS5OqGCK8B+6XtWygdilcaLtahr7D6pkYqsYlhXTpjxGzT5jyK7VYd4SkZbbgm+Y5Mf4xEnfkbn16OMstdrSn0LZaJgu8l2Cc+yzTClzgn3WvpYv91fmi3SsQEkx74nt4T1GPNLdRFPNhKpIL7poFRxsRx9KoKmvtklIpb93dFFeiWL1dfhE1fYd8sEvVx1NA5EbKeypvcm0xjAA0ZWoYODRHjXGKUzasIqpRqisSdc4p2LXn/q6gvD22CdBrIgQd1FrY8dh3x7pqPNG+7F6JkpULtjts/cDxbEphun4HL6jhmEjtrsPwbS60Auwt7gIK3U6Plwsh2HEMZaXTqpVaagGBZ8XrLgmaKUNGmPJz73qdmGR5bnFSTUH3QHeL/zUBk3MJg1kTu3ALUZf41nO/+QlDQsWpL1l15J391IEOZ02sD54pcvLLXSuM7Fy+qPAvop68ujksX4AyEf4zozGsy8UM7WHGsufrTYwxt2Lvb0LUbNlYHdh7CJBtPf0FIh2HI4DnS2tgAKFXUgRiLdxtcpw03oKLQBpGCAtOlleil0fwfvm3lA
 +WFwfISf
 Zdxqv/S38pISXN76K01wKUFG2vBp3nW0f+626sxwUgN7MH54EumtHetkHwGdkZh1sFTcvy6gjBBabNn2ejujZtuTyS+gsStXLII0Dfpk5N9tnxdv9YClOUh0I8FQM+oJ6fR29fViDNq2rnLbyDpiO7zMrSTrUIOE1u15x5Aoqv1IV0sJr2Xtdlxu+rQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Mon, Aug 18, 2025 at 10:01:22AM -0700, Roman Gushchin wrote:
>> This patchset adds an ability to customize the out of memory
>> handling using bpf.
>> 
>> It focuses on two parts:
>> 1) OOM handling policy,
>> 2) PSI-based OOM invocation.
>> 
>> The idea to use bpf for customizing the OOM handling is not new, but
>> unlike the previous proposal [1], which augmented the existing task
>> ranking policy, this one tries to be as generic as possible and
>> leverage the full power of the modern bpf.
>> 
>> It provides a generic interface which is called before the existing OOM
>> killer code and allows implementing any policy, e.g. picking a victim
>> task or memory cgroup or potentially even releasing memory in other
>> ways, e.g. deleting tmpfs files (the last one might require some
>> additional but relatively simple changes).
>
> The releasing memory part is really interesting and useful. I can see
> much more reliable and targetted oom reaping with this approach.
>
>> 
>> The past attempt to implement memory-cgroup aware policy [2] showed
>> that there are multiple opinions on what the best policy is.  As it's
>> highly workload-dependent and specific to a concrete way of organizing
>> workloads, the structure of the cgroup tree etc,
>
> and user space policies like Google has very clear priorities among
> concurrently running workloads while many other users do not.
>
>> a customizable
>> bpf-based implementation is preferable over a in-kernel implementation
>> with a dozen on sysctls.
>
> +1
>
>> 
>> The second part is related to the fundamental question on when to
>> declare the OOM event. It's a trade-off between the risk of
>> unnecessary OOM kills and associated work losses and the risk of
>> infinite trashing and effective soft lockups.  In the last few years
>> several PSI-based userspace solutions were developed (e.g. OOMd [3] or
>> systemd-OOMd [4]
>
> and Android's LMKD (https://source.android.com/docs/core/perf/lmkd) uses
> PSI too.
>
>> ). The common idea was to use userspace daemons to
>> implement custom OOM logic as well as rely on PSI monitoring to avoid
>> stalls. In this scenario the userspace daemon was supposed to handle
>> the majority of OOMs, while the in-kernel OOM killer worked as the
>> last resort measure to guarantee that the system would never deadlock
>> on the memory. But this approach creates additional infrastructure
>> churn: userspace OOM daemon is a separate entity which needs to be
>> deployed, updated, monitored. A completely different pipeline needs to
>> be built to monitor both types of OOM events and collect associated
>> logs. A userspace daemon is more restricted in terms on what data is
>> available to it. Implementing a daemon which can work reliably under a
>> heavy memory pressure in the system is also tricky.
>
> Thanks for raising this and it is really challenging on very aggressive
> overcommitted system. The userspace oom-killer needs cpu (or scheduling)
> and memory guarantees as it needs to run and collect stats to decide who
> to kill. Even with that, it can still get stuck in some global kernel
> locks (I remember at Google I have seen their userspace oom-killer which
> was a thread in borglet stuck on cgroup mutex or kernfs lock or
> something). Anyways I see a lot of potential of this BPF based
> oom-killer.
>
> Orthogonally I am wondering if we can enable actions other than killing.
> For example some workloads might prefer to get frozen or migrated away
> instead of being killed.

Absolutely, PSI events handling in the kernel (via BPF) opens a broad
range of possibilities. e.g. we can tune cgroup knobs, freeze/unfreeze
tasks, remove tmpfs files, promote/demote memory to other tiers, etc.
I was also thinking about tuning the readahead based on the memory
pressure.

Thanks!

