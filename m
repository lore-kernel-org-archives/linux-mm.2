Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E0CCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 22:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF138E009F; Thu, 30 Oct 2025 18:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586EF8E006B; Thu, 30 Oct 2025 18:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3D88E009F; Thu, 30 Oct 2025 18:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 369388E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:42:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC3A1140298
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:42:26 +0000 (UTC)
X-FDA: 84056255892.01.9DAE439
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id 000BE80008
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:42:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w4Dw2W0B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=martin.lau@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761864145; a=rsa-sha256;
	cv=none;
	b=JhixjA5u7zJOJdL6Th+o0iPcYfanUQ+KtOVQL1FMXyrRF3iE8k/kEWt0nTE9MgOVJsM65A
	sPIcSZLOMcW7aM+E1XOxk/dLxsjuNyvNF7Hw3bobBnRZ3xcFbC+wyiM+0PdiZ9vXN9JmMi
	3jcb1sG/JGrn9WPKYKliWZiCd5ycnMk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w4Dw2W0B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=martin.lau@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761864145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6Vi5Tt+I174+kjp03D2P+wbVEq5YpTLLn5FP5kOQX8=;
	b=CenH0p7PyyfkHjwUdjmkdxJOBH8vUpZW4SJqgvewGqfU2SmPMNoFQg4DsVxBG6QamBEuGh
	8HWv6D43zCwOeOei7bUewwvcWEbHiwS2TLPB/yKm7Xugr8OjAEKH120ZIoBSoZxKEJXu/3
	M/RyuxIsv2kaBHh6KAkqxDs1rz2oigw=
Message-ID: <e027a330-8d51-44e5-badc-7c3ec4d41e23@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761864139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6Vi5Tt+I174+kjp03D2P+wbVEq5YpTLLn5FP5kOQX8=;
	b=w4Dw2W0BopQE6NK2KmOiFVG+F56rU0LbOgjR3js4+CdAu537cuAGApUf4DYOLlL9zRo8we
	cQeDGnzMfDQQIM9Mj5dgPvp9rD9tkmXzDkIlj4SxX23PqXXqYpnOKXLmajRX5+Of+uBcwt
	tJqXv97s/MFUkJnqiGdMXKUmBi8A4Nw=
Date: Thu, 30 Oct 2025 15:42:12 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to
 cgroups
To: Song Liu <song@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: Amery Hung <ameryhung@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Andrii Nakryiko <andrii@kernel.org>,
 JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, bpf@vger.kernel.org,
 Martin KaFai Lau <martin.lau@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev>
 <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
 <877bwcus3h.fsf@linux.dev>
 <CAHzjS_u5oqD3Dsk9JjK942QBL8UOMkqdM23xP0yTEb+MMuOoLw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHzjS_u5oqD3Dsk9JjK942QBL8UOMkqdM23xP0yTEb+MMuOoLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 000BE80008
X-Stat-Signature: d3m4pt7zcepttyki11c8bc8x4p6q8dcr
X-HE-Tag: 1761864142-178778
X-HE-Meta: U2FsdGVkX18mp5BoDmo5onotOHQVHFS77pxAPHaxd86qwyXdOY/88/LelnKRbQBlNp2z2C9INpcS6DujsLLiEtL1V9m7ESwGpF27mpBkwAJAH5puHXjBgpPPe+HcW+xQPb0fJ/9RzlxgbBTz2fsrhhVK/W5BKQIkrSW3/OUL27k0REjTcQSMrCeG9+O0DOHbFxFVe9lMmGFJKoSkUmiGQbBM+2zS4meF+6plGptnahW4+AJd+e4hsJGGU9cEMIJ7TP+kfNsONr33d6a5AX+M438Fd65M9thJSGacWz2FysQJZuH9CAzP8YBhbPkotBmehE6+4KPb4Ke1VeI8b2sBbhmMGDjh/hj7wCCiAJYbixo6R6kKygyFmsXYm5OuyPCt+dE41F+55TapG3ZffbKYhigxJ8FUnt+mUujRStnHTJeQRyjlfo/ALUBOvo40VtRT5pzdLEqzeFeXiHv2o18g/yUgrO2JhAT8IvfrrFgPh/AlCpLO6PO/NmtH/HeDqrDwEqXXqguXr8TYiysU+5mImGwlOTZ1XjiW6L56M1vQRtanqXFCeJgMknNvXRJAUt23N65C3+lmeaidUNNmjy9xStO6xKrXxk77trWoQjU/QtH+/07UrphM5Y5yhDaOonnJAQ2QZTj2VGNYII54IyLYhksHeaBdwHRQ8bdD9h+tuj+hUepLpVIuQ8BX59oVkqa9l/NSc9oaREq96HyjwBBNTIdskDPPvGHk7D40X84v4rzVpCs/qtM/bCABYvEhEMv5BaWNvAYb/rJ7JhRG9aRYwv0+pfGBtWkZs6ahEI6feI7JHIFLd0nx3zL2QKT5/n6mKuXwn/pjQtC14eYaI1RcRFgUtY6GX3yanZVQBClGdsgY3MRi04fYm1eBCxO2WSq1kRRzUZxmBaqFp0VTFQ4cxGgGryMI1ZRb2mOdqP9Z3sUvZpfZcWeD0ifRq3UFIDsL4ZCLx4+AXgEjAop2NdF
 Q/v+1Nxa
 K5eyQ6KiSYFntFrWecyzwxm3nSy+bTlQYiEZPVQjuRQnQFrJnX3dnkuMhpoXoa3gp9j3o1OemlCoYItLYVysOEVwo6KyEtdfdhwlr61YoME6fwRNNmrYaT64AMF61xKfzjk1G8FrdtgrjkApkl4f6OTWeoFDuhGvvalYxnqOfFyMD3F/7fnmxhNjk4YKCC9HBv6wSsp9OaAodG7+haeTxB9iriV7XcQtWGMkN3+1tvB7ja1xz0Pzt6660PgGqHI04FOXI9IFIAPH2TWlg0gn9L9jfXx3pfcx1l80X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/30/25 2:34 PM, Song Liu wrote:
> Hi Roman,
> 
> On Thu, Oct 30, 2025 at 12:07 PM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
> [...]
>>> In TCP congestion control and BPF qdisc's model:
>>>
>>> During link_create, both adds the struct_ops to a list, and the
>>> struct_ops can be indexed by name. The struct_ops are not "active" by
>>> this time.
>>> Then, each has their own interface to 'apply' the struct_ops to a
>>> socket or queue: setsockopt() or netlink.
>>>
>>> But maybe cgroup-related struct_ops are different.
>>
>> Both tcp congestion and qdisk cases are somewhat different because
>> there already is a way to select between multiple implementations, bpf
>> just adds another one. In the oom case, it's not true. As of today,
>> there is only one (global) oom killer. Of course we can create
>> interfaces to allow a user make a choice. But the question is do we want
>> to create such interface for the oom case specifically (and later for
>> each new case separately), or there is a place for some generalization?
> 
> Agreed that this approach requires a separate mechanism to attach
> the struct_ops to an entity.
> 
>> Ok, let me summarize the options we discussed here:
> 
> Thanks for the summary!
> 
>>
>> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
>> itself. The attachment is happening at the reg() time.
>>
>>    +: It's convenient for complex stateful struct ops'es, because a
>>        single entity represents a combination of code and data.
>>    -: No way to attach a single struct ops to multiple entities.
>>
>> This approach is used by Tejun for per-cgroup sched_ext prototype.
>>
>> 2) Make the attachment details a part of bpf_link creation. The
>> attachment is still happening at the reg() time.
>>
>>    +: A single struct ops can be attached to multiple entities.
>>    -: Implementing stateful struct ops'es is harder and requires passing
>>       an additional argument (some sort of "self") to all callbacks.
>> I'm using this approach in the bpf oom proposal.
>>
> 
> I think both 1) and 2) have the following issue. With cgroup_id in
> struct_ops or the link, the cgroup_id works more like a filter. The
> cgroup doesn't hold any reference to the struct_ops. The bpf link
> holds the reference to the struct_ops, so we need to keep the
> the link alive, either by keeping an active fd, or by pinning the
> link to bpffs. When the cgroup is removed, we need to clean up
> the bpf link separately.

The link can be detached (struct_ops's unreg) by the user space.

The link can also be detached from the subsystem (cgroup) here.
It was requested by scx:
https://lore.kernel.org/all/20240530065946.979330-7-thinker.li@gmail.com/

Not sure if scx has started using it.

> 
>> 3) Move the attachment out of .reg() scope entirely. reg() will register
>> the implementation system-wide and then some 3rd-party interface
>> (e.g. cgroupfs) should be used to select the implementation.
>>
>>    +: ?
>>    -: New hard-coded interfaces might be required to enable bpf-driven
>>       kernel customization. The "attachment" code is not shared between
>>       various struct ops cases.
>>       Implementing stateful struct ops'es is harder and requires passing
>>       an additional argument (some sort of "self") to all callbacks.
>>
>> This approach works well for cases when there is already a selection
>> of implementations (e.g. tcp congestion mechanisms), and bpf is adding
>> another one.
> 
> Another benefit of 3) is that it allows loading an OOM controller in a
> kernel module, just like loading a file system in a kernel module. This
> is possible with 3) because we paid the cost of adding a new select
> attach interface.
> 
> A semi-separate topic, option 2) enables attaching a BPF program
> to a kernel object (a cgroup here, but could be something else). This
> is an interesting idea, and we may find it useful in other cases (attach
> a BPF program to a task_struct, etc.).

Does it have plan for a pure kernel module oom implementation?
I think the link-to-cgrp support here does not necessary stop the
later write to cgroupfs support if a kernel module oom is indeed needed
in the future.

imo, cgroup-bpf has a eco-system around it, so it is sort of special. bpf user
has expectation on how a bpf prog is attached to a cgroup. The introspection,
auto detachment from the cgroup when the link is gone...etc.

If link-to-cgrp is used, I prefer (2). Stay with one way to attach
to a cgrp. It is also consistent with the current way of attaching a single
bpf prog to a cgroup. It is now attaching a map/set of bpf prog to a cgroup.
The individual struct_ops implementation can decide if it should
allow a struct_ops be attached multiple times.

