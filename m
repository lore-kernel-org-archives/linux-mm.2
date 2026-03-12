Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE72103E304
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178666B0088; Wed, 11 Mar 2026 22:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5486B0089; Wed, 11 Mar 2026 22:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0010A6B008A; Wed, 11 Mar 2026 22:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E47D06B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:47:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 451078B463
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:47:08 +0000 (UTC)
X-FDA: 84535874136.07.BC8B6EB
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3AC72180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:47:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pl1wvej5;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773283626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bn22wJ7ckCW5LunWe8zrG07xQ/9uHxRHUmDSBAcb/oU=;
	b=z8rnpv+Ju1w96GyUjG3RNna3c2VJaLUvOjgjfxFEcUgTjkGWsUKG/kfsorqU0iI89cvgT1
	OgbRMj+GE0cz7AaH05qp7UrEz3+XZMct2y4nquMFcIN3rkF4l9wQ+DGm7gnrbN/nj45FHY
	EVWtkpxLy6YCmHs4AcD7+DfnQraaqpM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pl1wvej5;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773283626; a=rsa-sha256;
	cv=none;
	b=HRBYg/6rOC6TSP0tsPLOjGtq/WFmJGLZrSgpivWwl/SATVilDh28kvTMk0Oen5igt8XLN6
	ppiXs0Ookk5nzKbFe++yjFYXiX9YvXrc6IkScGBVwx293Oevxisn3L7HoWHhUXpJJrKCnW
	D55k1f3QZQJJcsX/GOBTIu+hGo+ayMI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773283623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bn22wJ7ckCW5LunWe8zrG07xQ/9uHxRHUmDSBAcb/oU=;
	b=pl1wvej5D2Yz+aDVoFPsDWCvqwPHXwNrvdxO4nqaau4RsfYAyzqGQIDN8yI6wkuerZ+X4P
	ZDGbzlOcZxxm4FS8OyTxMRh9hMr0YrKMX3KTPpuJ9UK97OYQeLMnmLqJQCRsk4iXYPnBNm
	d1zUpjd9ueHL/DhtAMgYjaQcmKsyMQ0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <abHPsCypwo7ZhqIt@linux.dev>
Date: Thu, 12 Mar 2026 10:46:10 +0800
Cc: lsf-pc@lists.linux-foundation.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Alexei Starovoitov <ast@kernel.org>,
 =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hui Zhu <hui.zhu@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>,
 Geliang Tang <geliang@kernel.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 David Rientjes <rientjes@google.com>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8F3593EB-9D81-4459-8675-E922426DCB1E@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev> <abHPsCypwo7ZhqIt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3AC72180002
X-Rspamd-Server: rspam07
X-Stat-Signature: 5sd59os8szoor5r5igbtufd5ybkquhdy
X-Rspam-User: 
X-HE-Tag: 1773283625-952245
X-HE-Meta: U2FsdGVkX1+zvLL42cgyIe3iC4hO7rgo/FPPqSpyBhh0kjYmxbkbQxxvsgF6wIAN6OHIHcH8bzvQy36cMecWNZvWbni7zVVGLtrdFONBytzPSpTvr5izQIOdAAaePFpd+C+U2sXmMGifaChfR1/Mffp3uck98qt+D6l8YzAGMCdBiw02U+NUsCMx2ydBduvB1SeTrzI2JhabiJPn7WmXrdHWUL747KB+nxmdkoxa5zh3Vyfii8bVXKbAYJMjcZeAQkHRUdmAuEf3IpJfqgG51fUccO0tbsuj+DjoMoJqyTrH5MI3Wxg2F8KcMCIhoyFUpKMf7YbqDaOD/fqDdH+JGZ7nQPnVj4L4rxvEFULeVbIrnt463ghfHTRE/WSZJlWNMR+GN07ZkN1CGYHrN1/bo+rMyOoIVrqLNJVrVYgcDJhku8jFCW+nCassGX6ClR0V0iD8zOVJHkHd53BCQAoyo8c2Hi+SEThP/HGO2/0f5+mIT8YpNYnED11E1e0yk9E5q5CqmZpw7MFtRkpxqqn/qsPrlmdnLIBFaxwNZVX4FalItmLdG5Qf9rsalAhq9nk6n66vAJo6Lki1R/1c+P7kZqJ+SLcFwOXTHGapzCOj250ckDw+sGuCleMlUevhqsJzQFyxNf39wgVSdp2f/R47AfKRXrnynzZsBu0z8JUI/hOT4nwyN4cmU6hrzI1i5NoxSRm1dKV+p4/duRvDhGNRrgn3INv10GIvMhoN1qTO6dUms2a781zobnefg5eNV+OEu+hyFig1vaXsWkrHhsZwR3yBkJ/lPx4GuxJ4hUK3hJoYoT1dfm0rp34yDeN4FhNDrf8zrPdf8C6Jh5l/t4vieWoqzCXe4eH81kScpeNIf+Ku/2fo0U05T4hAGxi8SJ9bjGb83x6d9Dh524Ipo7sKLqrzt8omfEQ+jsvv8KzZE5EmH/mD5BWkMqe7kWwDEUyCacgOf+690467oBRlNNy
 vmQh3bRE
 CI0JWEdgGdvj0LI83ipIhbPb834Izz1FLvL4PbkatFUQaC1JrrCHyDwbjYPxibKphoXOkoIs/b0JWQANS3e1wi3U9HKtdKaiEk2N3wAOA40KfuIodXD7he7FRhadC++V5m4cFz0LTc4CXhmD0xY8IEDpiVwP5I3sENLHJDDTzdIuv1McTat+7OkNep00WoTh3xIPqgM17/JWba3gljWxYwzYwYyRZl4xjg1OaCtiEWRrNTF+v+4VmV+NIcaSKH4KE1IPPYFtX2wQJrGv9U/Aw5uyd9UrEou/iPF54/waMwBTKC09YABikCA6S4774LxPY9tKYkQj0LgVq8XU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Mar 12, 2026, at 04:39, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> On Wed, Mar 11, 2026 at 03:19:31PM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Mar 8, 2026, at 02:24, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>>>=20
>=20
> [...]
>=20
>>>=20
>>> Per-Memcg Background Reclaim
>>>=20
>>> In the new memcg world, with the goal of (mostly) eliminating direct =
synchronous
>>> reclaim for limit enforcement, provide per-memcg background =
reclaimers which can
>>> scale across CPUs with the allocation rate.
>>=20
>> Hi Shakeel,
>>=20
>> I'm quite interested in this. Internally, we privately maintain a set
>> of code to implement asynchronous reclamation, but we're also trying =
to
>> discard these private codes as much as possible. Therefore, we want =
to
>> implement a similar asynchronous reclamation mechanism in user space
>> through the memory.reclaim mechanism. However, currently there's a =
lack
>> of suitable policy notification mechanisms to trigger user threads to
>> proactively reclaim in advance.
>=20
> Cool, can you please share what "suitable policy notification =
mechanisms" you
> need for your use-case? This will give me more data on the comparison =
between
> memory.reclaim and the proposed approach.

If we expect the proactive reclamation to be triggered when the current
memcg's memory usage reaches a certain point, we have to continuously =
read
memory.current to determine whether it has reached our set watermark =
value
to trigger asynchronous reclamation. Perhaps we need an event that can =
notify
user-space threads when the current memory usage reaches a specific
watermark value. Currently, the events supported by memory.events may =
lack
the capability for custom watermarks.

>=20
>=20
>>=20
>>>=20
>>> Lock-Aware Throttling
>>>=20
>>> The ability to avoid throttling an allocating task that is holding =
locks, to
>>> prevent priority inversion. In Meta's fleet, we have observed lock =
holders stuck
>>> in memcg reclaim, blocking all waiters regardless of their priority =
or
>>> criticality.
>>=20
>> This is a real problem we encountered, especially with the jbd =
handler
>> resources of the ext4 file system. Our current attempt is to defer
>> memory reclamation until returning to user space, in order to solve
>> various priority inversion issues caused by the jbd handler. =
Therefore,
>> I would be interested to discuss this topic.
>=20
> Awesome, do you use memory.max and memory.high both and defer the =
reclaim for
> both? Are you deferring all the reclaims or just the ones where the =
charging
> process has the lock? (I need to look what jbd handler is).
>=20

We do not use memory.high, although it supports deferring memory =
reclamation
to user-space, it also attempts to throttle memory allocation speed, =
which
introduces significant latency. In our application's case, we would =
rather
accept an OOM under such circumstances. We previously attempted to =
address
the priority inversion issue caused by the jbd handler separately (which =
we
frequently encounter since we use the ext4 file system), and you can =
refer
to this [1]. Of course, this solution lacks generality, as it requires
calling new interfaces for various lock resources. Therefore, we =
internally
have a more aggressive idea: defer all reclamation triggered by =
kernel-space
memory allocation until just before returning to user-space. This should
resolve the vast majority of priority inversion problems. The only =
potential
issue introduced is that kernel-space memory usage may briefly exceed =
memory.max.

[1] =
https://lore.kernel.org/linux-mm/cover.1750234270.git.hezhongkun.hzk@byted=
ance.com/#r

Muchun,
Thanks.


