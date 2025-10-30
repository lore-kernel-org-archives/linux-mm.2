Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF57CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 23:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BFAC8E01E8; Thu, 30 Oct 2025 19:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697CD8E006B; Thu, 30 Oct 2025 19:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5468E01E8; Thu, 30 Oct 2025 19:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4318E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:15:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8FCC1602C0
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:15:13 +0000 (UTC)
X-FDA: 84056338506.05.7B7938D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 05D2D40006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:15:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BqYnhxem;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761866112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbsSEZaCMc7K7Atlywq1UA86pTshfXfbD+JgyxyXRuw=;
	b=N6K08IUXPvuSz/X5eh5ud8JN0eK6ao9tQ2UcP8PVEBKOMUj8rEdRt1Hs8F0k4ElgKny0H4
	RtVtCasC1IkLlduXhPrXoc9hx/HhEWm6aCezTtq2PzPqAdQoKvP7eO4+hLTN65zTcBlRwy
	Zc1Y1+SggkRnoGxAVDG5aIDEOU3opZI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BqYnhxem;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761866112; a=rsa-sha256;
	cv=none;
	b=db93ljaj/oHKj8ystWcxuuWQvZYmlnuCf5fVDKUMoZVNXp+OOhxb5ic0aWPcG4PbJkuEka
	/ZE+MXNv8k181M7nsyhs+ItIPhDdTUyGW4ytqh4Q1X2+uEIGYzJh4PVg1U6UYBXGClgbwO
	LipodV3kKuVEv9DGMRkgPC/2C8cnfDo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761866108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nbsSEZaCMc7K7Atlywq1UA86pTshfXfbD+JgyxyXRuw=;
	b=BqYnhxemjKDpfH7eW6N6jRHjYMwxVKsjcN/cG4hJ/T6pdPe4keRlC9cXgEVIkTtv5p+oKQ
	GnmPbl0/rkAOQXBte6goaO5WKU8xpmSSgoKdLnR8zZsR2QT+6Mz336obgwm5/+sF49C/wu
	lUk4ZnQnJUDPb4AYlGp8YqKaJXOl8rk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>,  Amery Hung <ameryhung@gmail.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org,  Alexei
 Starovoitov <ast@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko
 <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Kumar Kartikeya Dwivedi
 <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
In-Reply-To: <e027a330-8d51-44e5-badc-7c3ec4d41e23@linux.dev> (Martin KaFai
	Lau's message of "Thu, 30 Oct 2025 15:42:12 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-3-roman.gushchin@linux.dev>
	<CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
	<87zf98xq20.fsf@linux.dev>
	<CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
	<CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
	<877bwcus3h.fsf@linux.dev>
	<CAHzjS_u5oqD3Dsk9JjK942QBL8UOMkqdM23xP0yTEb+MMuOoLw@mail.gmail.com>
	<e027a330-8d51-44e5-badc-7c3ec4d41e23@linux.dev>
Date: Thu, 30 Oct 2025 16:14:59 -0700
Message-ID: <87bjloj824.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ai9zpns3omehx15y85hp3o4jjbnreomg
X-Rspamd-Queue-Id: 05D2D40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761866111-195061
X-HE-Meta: U2FsdGVkX1/ZJCCQ6QAIxTLtCiS64FE+9nWrksOJm9rR+Xk7vG69qB+i8R7Ufu6ztcioi6x54HPQ2Ae0o4L1yHYIbePjFDmELjIfc8agjcqPQbUBDQkRrYkpviaGAnuop+jmQUXGnEVC6xetQTk1sslZvzZ60T6ujM3sEm28Jtr+utJGmRXv4DosyIXeURVPd75mR1n2zHukyB1hZwzOAF31XnN5ddz+G8v4awIGNWST9sUyBsJ7glQArsVStXbXtfYc5iAluG2HJPCH3ccNcpO0c6QSdox0F+dJ8aSEshwYwNcHOE5hWOlqmF0OVSbEfit4J99l6sHyNJ7ZpLN5tbB/zTLB+H8lUP0lVwQMr6LgzZYWVjmiY4LsNeGioqSFF4bnbzsNXp9EKIe+HxLvFWD9zm/MvbgtlAN650/JgRwj7F4ql5zkUS8GG5PTsdOALKXsnZKH6oAMEXM00EqJRCtdp22qsYZ62hWAlBh7WaWS9Nf6Wxyok4sjHmgr5YYDiPVyh7E+wbI3jZdLX2RfThPoU6+HW8tix+N/irWMRIplFQTl+RfLp/Dk/x67yK0pBbST4vNXZGTybDE5zoezpXH/RSqDibaYLF8oTpzeMULbitFLgbyse1jwH2Z87TdD5HfcOrxvVwno3AdDdZffz/xxQ7TrPTL4KIfMuZMEQzF8/DFy3YUVqMjrJ/APDJbTOZ+G9DIBFaGDjUhkb1I4T7My5D7oSo2dr5QZIqquizEfdpoREnacGY7t3lhWjpgDBAyq50XjFI3zn/EJeeWJVE78OEsYKNdMw96rYBlRoZ5tj+/l7hgn9Rl9aGE2zimMz4Zs57lJhSaLw818L1DfWU++O6TFB9jFvqkAEflyvz5GYGqVIEkpyso6saEx+zCyv+vhnMYD9UWYZ8H28yIJpiTTnH1hMLT/6t0autOpDEVF0N4RgFMfsm30/O+47OuYJbHx8EM7RISdeCfJyDE
 v2o2ez7/
 uI7T1/85yTV+xOw1nq7Wd2DSfbDisScxtbqtA5Uf6n9JWXavCEG0otNUDllFwUGbconAe+vMr2tgj7YOuvxP9IujBsDk3lnk/FHyNEk19VMQh4H0luwhTEXkQCRco0rQCxuY463FL7AIvg7JAecycGzS+tUSWpMetLwzT+kGHp0vCzmtG6mAh9Y4i57tOmEWrbU4T6OSpR6QTu5GHO24kMP9HTCou7cQbVJ9eADvDJ7H585B3h9g86MXY/XTS6BW2wz2B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 10/30/25 2:34 PM, Song Liu wrote:
>> Hi Roman,
>> On Thu, Oct 30, 2025 at 12:07=E2=80=AFPM Roman Gushchin
>> <roman.gushchin@linux.dev> wrote:
>> [...]
>>>> In TCP congestion control and BPF qdisc's model:
>>>>
>>>> During link_create, both adds the struct_ops to a list, and the
>>>> struct_ops can be indexed by name. The struct_ops are not "active" by
>>>> this time.
>>>> Then, each has their own interface to 'apply' the struct_ops to a
>>>> socket or queue: setsockopt() or netlink.
>>>>
>>>> But maybe cgroup-related struct_ops are different.
>>>
>>> Both tcp congestion and qdisk cases are somewhat different because
>>> there already is a way to select between multiple implementations, bpf
>>> just adds another one. In the oom case, it's not true. As of today,
>>> there is only one (global) oom killer. Of course we can create
>>> interfaces to allow a user make a choice. But the question is do we want
>>> to create such interface for the oom case specifically (and later for
>>> each new case separately), or there is a place for some generalization?
>> Agreed that this approach requires a separate mechanism to attach
>> the struct_ops to an entity.
>>=20
>>> Ok, let me summarize the options we discussed here:
>> Thanks for the summary!
>>=20
>>>
>>> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
>>> itself. The attachment is happening at the reg() time.
>>>
>>>    +: It's convenient for complex stateful struct ops'es, because a
>>>        single entity represents a combination of code and data.
>>>    -: No way to attach a single struct ops to multiple entities.
>>>
>>> This approach is used by Tejun for per-cgroup sched_ext prototype.
>>>
>>> 2) Make the attachment details a part of bpf_link creation. The
>>> attachment is still happening at the reg() time.
>>>
>>>    +: A single struct ops can be attached to multiple entities.
>>>    -: Implementing stateful struct ops'es is harder and requires passing
>>>       an additional argument (some sort of "self") to all callbacks.
>>> I'm using this approach in the bpf oom proposal.
>>>
>> I think both 1) and 2) have the following issue. With cgroup_id in
>> struct_ops or the link, the cgroup_id works more like a filter. The
>> cgroup doesn't hold any reference to the struct_ops. The bpf link
>> holds the reference to the struct_ops, so we need to keep the
>> the link alive, either by keeping an active fd, or by pinning the
>> link to bpffs. When the cgroup is removed, we need to clean up
>> the bpf link separately.
>
> The link can be detached (struct_ops's unreg) by the user space.
>
> The link can also be detached from the subsystem (cgroup) here.
> It was requested by scx:
> https://lore.kernel.org/all/20240530065946.979330-7-thinker.li@gmail.com/
>
> Not sure if scx has started using it.
>
>>=20
>>> 3) Move the attachment out of .reg() scope entirely. reg() will register
>>> the implementation system-wide and then some 3rd-party interface
>>> (e.g. cgroupfs) should be used to select the implementation.
>>>
>>>    +: ?
>>>    -: New hard-coded interfaces might be required to enable bpf-driven
>>>       kernel customization. The "attachment" code is not shared between
>>>       various struct ops cases.
>>>       Implementing stateful struct ops'es is harder and requires passing
>>>       an additional argument (some sort of "self") to all callbacks.
>>>
>>> This approach works well for cases when there is already a selection
>>> of implementations (e.g. tcp congestion mechanisms), and bpf is adding
>>> another one.
>> Another benefit of 3) is that it allows loading an OOM controller in
>> a
>> kernel module, just like loading a file system in a kernel module. This
>> is possible with 3) because we paid the cost of adding a new select
>> attach interface.
>> A semi-separate topic, option 2) enables attaching a BPF program
>> to a kernel object (a cgroup here, but could be something else). This
>> is an interesting idea, and we may find it useful in other cases (attach
>> a BPF program to a task_struct, etc.).

Yep, task_struct is an attractive target for something like mm-related
policies (THP, NUMA, memory tiers etc).

>
> Does it have plan for a pure kernel module oom implementation?

I highly doubt.

> I think the link-to-cgrp support here does not necessary stop the
> later write to cgroupfs support if a kernel module oom is indeed needed
> in the future.
>
> imo, cgroup-bpf has a eco-system around it, so it is sort of special. bpf=
 user
> has expectation on how a bpf prog is attached to a cgroup. The introspect=
ion,
> auto detachment from the cgroup when the link is gone...etc.
>
> If link-to-cgrp is used, I prefer (2). Stay with one way to attach
> to a cgrp. It is also consistent with the current way of attaching a sing=
le
> bpf prog to a cgroup. It is now attaching a map/set of bpf prog to a cgro=
up.
> The individual struct_ops implementation can decide if it should
> allow a struct_ops be attached multiple times.

+1

