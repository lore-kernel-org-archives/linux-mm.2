Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DFBCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6188E010B; Wed, 29 Oct 2025 17:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DDE8E0106; Wed, 29 Oct 2025 17:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB9C8E010B; Wed, 29 Oct 2025 17:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F648E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:53:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3394ABC243
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:53:51 +0000 (UTC)
X-FDA: 84052504662.04.E58D969
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 332B9C000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:53:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=csOcxHFR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761774829; a=rsa-sha256;
	cv=none;
	b=T5dz4Vy2W+7TC5Bja0fQ/4tlL9r3LoL+ZPPLQGb7aB1N9hz3Qiu0vmdRsEH9xd+gV8FZ8m
	vMzxMhP1VDo4izd37YfBU0Mk5/eKplvvkmQhCzkjbG/q3Ubh1o1z6RPyKIMzCYSvyLKWBa
	pHmIl/K5hp6QZ9DcXIM2dLAO65E2ggw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=csOcxHFR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761774829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRbBQ8z+sVjizpZCWo5hT/mNnyCZzi3jD4cZdQbYlrk=;
	b=V8YAGiypyQCxFsB4a3VbgA2qzLfqMyj0KdiUl4ttLLAChFBtpflOYmIiUIKAPriS2JjyO2
	SUsLIGYbZRQzXojupFsbxxn/OPWAgpEiqD/QYTNpxFy/2PBClTbicS682GGyASktn8/Xmm
	y4eOIw4O/CWVLgKsgJnMFH7JQI8FKt0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761774826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRbBQ8z+sVjizpZCWo5hT/mNnyCZzi3jD4cZdQbYlrk=;
	b=csOcxHFRJMKoqy3bgapanUAkcjC8JMzxMX/V6v8WjihxeU45lzMu454aITCt7yS/w57B40
	6C/Th57sjWmYDj42CsxxgzABtVElBGYig2qHIacSpSCzNNU5MPWom2nD/vFeNo2jJL/fI1
	R0rwHvH1fMX8QhZftw1demdPjuW9x6I=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Song Liu <song@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
In-Reply-To: <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
	(Song Liu's message of "Wed, 29 Oct 2025 14:18:00 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-3-roman.gushchin@linux.dev>
	<aQJZgd8-xXpK-Af8@slm.duckdns.org> <87ldkte9pr.fsf@linux.dev>
	<aQJ61wC0mvzc7qIU@slm.duckdns.org>
	<CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
Date: Wed, 29 Oct 2025 14:53:39 -0700
Message-ID: <871pmle5ng.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 332B9C000C
X-Stat-Signature: gun3rtnzz6qahoa8yfy63eq1xdgmm8c3
X-HE-Tag: 1761774828-702052
X-HE-Meta: U2FsdGVkX19fXuFkxCDcW6xwZmpt85/8cOg/blRMKqopCGdA1lXDLuKQPISix8d54YkmAlnm9lM2oYvUynofyCmB3lqE8CXKgTWssK+JRndTjxg6OV4I8OjdfO0Fj9XSmbPx3E2Gmd42meDWSn7mb9mAZYU0vIzUF/zNkdIys6aCJ5xHNV2OFtd2rvTFwY8lHRdhYHapOEEVla5eBT8RUrQjGj4N9hP/0+zeoZTj6f+Fm8ClZswLACuYl6Zu9nwIn4hm0Vbb+4S9jjrFkl5ZQ4M10GSUG0rk292dkxplAKlIxsqGNNrLOSi8aEBL5WAlcsFxJhXLmwNGSb7o9Sj6Liajv5/J+Tp4KYGA52fAMtt4T1ctsu4hmC1na4hnon47DpVH3bfD+4cK+JAU0xNqkVDs0KTCkufOtTo3K+SD6o1le0xQ3zY5QAu0xEJOiYYWd04/NDIBNUXyVnrsFzPxNLaC4UaVGosgjTU4Bb6fvcYWUWBagonje/sasoMZRr5T+WZcNlpJZY/VcLPHyW1d6pLAqLj6tEc7uQWuUAKQy+8fdMuGvIzkaE42WnYrZ8V0kvLGsihBmGNocBlw3X8exQ9/+Sz7rMMxpFiIecYmUB/EziKp/uA5WFn4DqOAAMmTBXucBZKHsI1/4kCD5G6C//5FgWHTJBquK1UnBP02c0wqjmkyTpRMDr60D3awhmtb1WKA+5ObQp/fVZViQqwnTbnEo0iBeHp7xxVHkHlpQG1UbwkDz0waeQ+uZFjfYrRvb5d8i8sncHD2N+ItgP00Qlw9++2lKDwHfc3M190/dhoS3Ttx/92nb4KEulvyjBJeyYi0mPODHC/skV0USGbXKV52tEwsOTQAEgsE23vtnHE6flHRg/5xblXws4AtFg1wZywxkOqgpmsP2I7bboCGDkZHGk38cVWRwLcpWwinRsM5VB07CSA1bmESBYb61XkHTuqJLIOkLJFsDL92zlg
 IFt3fuzw
 wnHlslYKeLRU82QxZpR6Enx8LNVb09g8anAYIm31s2oATWz/840U87/QAg4vFB98cwO/SUrj8gstl4wyJE+pOs4UNMgCtAshP1AdOyec0LMQGmeoucnCe8g9EHk6HbmgVRk34ie6MALKFgoMFOEHbNYllHnVcQgMfpFzijPkN1xg1k38fIEfTv2FG2iIj+u2lMB02HBvhrA2RR4jQnb2Uxb3BX2IdVLiioE7pADRtlGCYrLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Song Liu <song@kernel.org> writes:

> Hi Tejun,
>
> On Wed, Oct 29, 2025 at 1:36=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>>
>> On Wed, Oct 29, 2025 at 01:25:52PM -0700, Roman Gushchin wrote:
>> > > BTW, for sched_ext sub-sched support, I'm just adding cgroup_id to
>> > > struct_ops, which seems to work fine. It'd be nice to align on the s=
ame
>> > > approach. What are the benefits of doing this through fd?
>> >
>> > Then you can attach a single struct ops to multiple cgroups (or Idk
>> > sockets or processes or some other objects in the future).
>> > And IMO it's just a more generic solution.
>>
>> I'm not very convinced that sharing a single struct_ops instance across
>> multiple cgroups would be all that useful. If you map this to normal
>> userspace programs, a given struct_ops instance is package of code and a=
ll
>> the global data (maps). ie. it's not like running the same program multi=
ple
>> times against different targets. It's more akin to running a single prog=
ram
>> instance which can handle multiple targets.
>>
>> Maybe that's useful in some cases, but that program would have to explic=
itly
>> distinguish the cgroups that it's attached to. I have a hard time imagin=
ing
>> use cases where a single struct_ops has to service multiple disjoint cgr=
oups
>> in the hierarchy and it ends up stepping outside of the usual operation
>> model of cgroups - commonality being expressed through the hierarchical
>> structure.
>
> How about we pass a pointer to mem_cgroup (and/or related pointers)
> to all the callbacks in the struct_ops? AFAICT, in-kernel _ops structures=
 like
> struct file_operations and struct tcp_congestion_ops use this method. And
> we can actually implement struct tcp_congestion_ops in BPF. With the
> struct tcp_congestion_ops model, the struct_ops map and the struct_ops
> link are both shared among multiple instances (sockets).

+1 to this.
I agree it might be debatable when it comes to cgroups, but when it comes to
sockets or similar objects, having a separate struct ops per object
isn't really an option.

