Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381AFCA5FD9
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 22:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11DB6B0088; Thu,  1 Oct 2026 18:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1DF6B008A; Thu,  1 Oct 2026 18:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7C76B008C; Thu,  1 Oct 2026 18:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A32D86B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:56:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F7681C2314
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:56:56 +0000 (UTC)
X-FDA: 85275569232.14.741A5ED
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8804100006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:56:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q+o+jMDv;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaJdI6UStUpPXManN559yRD9kEZu4jfOZdnpjlvCRYM=;
	b=eZBEA1RO1+X+dy4DLkPRNLEtU4fx9m7462y5qaYIvtoPQWLjPE82SdXg3s27AVRHllj/Gu
	aPmv/ijHpx0Peabqhzh/XUvejkEusZ1vT3/r/KyJeTdnKpsqEtHfMdWZKKroUobmSLgK4C
	cYnHsTuVPqvx+wGUVoUnGXNaYvyfxb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895414;
	b=XlX5suaymDBjMo/as/ojtNqQrnx/wbjiL/7NJDkDu/wxLQHZjNamcG9FtkYvSPD+6xTHSR
	0kQ3D7pdrvkZyQ/CzpHqYy2/utMHsJUY8bEz9bW3O9crel1vCZH1SG3LuZhzMNpFdDqvMa
	8TvyyEbMJ8YUakK1acxMCEoegrYPbAo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q+o+jMDv;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LLQ8+pbOCynS3JlGqiF6iafheWllDG7Lb60tw6hvgjk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790895409; v=1; x=1791500209;
 b=Q+o+jMDvVuzAdIo4XoXemkI+/mUNSF9KZFVLHjdwWllFqZOlVWQatEYuzA6inN1yO0CD7yFQ
 r0vmbDroiJX1NJDW+aWz4IRALSORsfUD7lql/HsSth/5OZpdGCQZ7rWFhLgtQQZd/7sCcB0HbnD
 KvHR68Su707/lmHt1C/sFLB4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e4abc687ef968c60;
	Thu, 01 Oct 2026 22:56:49 +0000
X-Mizu-Trace-ID: e4abc687ef968c60
X-Migadu-Flow: FLOW_OUT
Date: Thu, 1 Oct 2026 15:56:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <ar7H__jzvWVtqSn5@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31a871a07fccc99e953a2d633fc51edc@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8804100006
X-Stat-Signature: by5dfxjy859a8o44y5s1hqnxb4ccfhc5
X-HE-Tag: 1790895413-518089
X-HE-Meta: U2FsdGVkX18Hv7Ora0QCqSCgyvzWmRHbc82Cbi5sfH/RdF2E/bdtHa6bGKCLd6E2L1bMawK72f5N0O5R7AD3ivIyzHMkCg4w7mc2heeDaPxFs/9FPF9hKU1wnA442j4q1garZoUuP2PLGbSd7WUdCW2hwjVCbXITniY/iECzzAJlGHAX2bdhiHR/n/juNxBa4MYueS8P1KCXHMY4X3PnHIf0Fi0TtHvZZocM4IL4K/LwAngPJ0DK8KqHIwrvCtNsBy/feMR3R3H3RMXMPE28Lr1C2YYWbstfrPD4gq0IbhNedR+xbeY6bMfp6QMNLUpMLFx9qQBe419ZDPpunCSsb8xZzLyulEjRZ9rxFmbsvbgjSBfWkYlD3xvbPkyw19/sNfk6l7+1mseh5Agwf5KyuOyC3OJFgz+LmbHJRPmwbhNoqlGahwbp2R9FG6s7bo3IM1AelCFJ3hmiV1j93VzEbuWds51wSQYx37FpGw6WVuIxlRmfTtnOSiVQfPZOcgiPKPXFrLwflgTgxUW2A0yyzWXO2Qrm6uPIZJG3VrweR8PC9BTpRmljBMpRa0+287n4ANsbMvhF438tfZIQD+/PIOl0ZjTRHTk+UJ2MMD+rQQsH6c9szldVPxYjy/sCjUy/jNYvao/RbFXzV9QNeo2hbLjkOcwYBLmXKHf44GU5D6pCWF1jJdY+7Pmlvlusdw3crMbOOIOA5/vi/6f4qlB3SKcd58m2DiIfAJT8XbZYRwml26zIbIPyfPrgKvpG6S8Gi8e2REQexZ1Wp0dKJDXZDNVjUGqmucwy6sSf8UuWI4QVJavYYN6WSHymN1b8VJUjHQbKIk2gNyKExZb4qDnx0jgQfKyxDdWO5W5c0ZKueaxpO3k6c8zSsYnI36J6qk5/VdGR0SOKfzfj6ccLNAqnXKlgQ3TUNIR5IJ+rCkYaUcsw7DPtL82uZ1dSuvylQx5+aJ39msLNWvQF8pfz1Xh
 2xEoJEax
 fgfAG+DluPNvV5fvKnA1gby/TFYhXqegJQ/SogYQ8JaNU56tA7dsncwZVWrJUwSGJxFLsmn41nF3EGbrBvyZho6l6Cc5K7zTIpOzy084txEyX3Q3JvrObJpFQgd6yQjGAu4CfaLWbBPNLtHWD8k+BmJxvmxYqGVfN4xCbrI4z9BddTdyNhGIqZ6NzqpTtsYfe7SMY26W413Jy10oP/EDRgd21wV/g81eA5V0dTbpFy23gKcxY3YQpJIAYTpxagudQjja9WEH18VnM8OHFaaGWBvve6T6yryBALucyKpnoHznJI5b1jT9v50DTXoidLwici/mh+ViHaI4U/RZI5tgUe35E3qGytXTaU5hIkfHilxRnm/DYbb8eOLXZG7pIY92vEYNrwt/R1Bz5POE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 08:42:55AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
[...]
> 
> > Here if you meant that default behavior of memory.high should work for most (if
> > not all) users then we are on same page. If some user want memory.high reclaim
> > to happen in a separate thread instead of return-to-userspace or synchronously,
> > this proposal provides mechanism through BPF to such users to achieve their
> > goals.
> 
> I think there's a common reasonable solution here, which is deciding by who
> the charge is for. A task charging for itself gets return-to-userspace
> enforcement plus the checks in the explicit bulk operations above. A kthread
> or anything else charging on behalf of a cgroup shouldn't be throttled for
> the cgroup's overrun. The overrun is attributed to the cgroup, async reclaim
> is kicked, and the cgroup's own tasks absorb the throttling on their next
> return to userspace. The in-charge synchronous fallback goes away. Each case
> has one reasonable answer, so I don't see a policy choice to expose here.
> 

Let me list the cases explicitly to see where we agree and where we disagree:

1. For the !in_task() charge path, today we trigger async reclaim and we will
   continue to do the same in the future.

2. For a kthread (or remote charging), today we throttle it similarly to user
   threads, but we want it to be handled similarly to the !in_task() case, i.e.
   trigger async reclaim. Regarding your statement "the cgroup's own tasks
   absorb the throttling on their next return to userspace", I assume you meant
   that when some other user thread of that memcg goes through the charge path,
   it will eventually do memory.high enforcement on return to userspace.

3. For a task, today we enforce memory.high on return to userspace, and if too
   much charge is accumulated in a single kernel entry, we enforce the high
   limit synchronously. You are suggesting that we remove the sync enforcement
   and add a couple of throttling points at known bulk allocation sites.

Please correct me if I misunderstood.

We are in agreement on (1) and (2) completely. For (3), I am fine with removing
the sync enforcement, but for throttling points for bulk operation sites,
I think we should only add them when there is an actual use case for that
or someone complains about overrun from those sites.

Now, setting aside the default behavior of memory.high, I want to provide
additional flexibility to users for (3) specifically. One specific case is
letting users opt in to async reclaim instead of the other forms of memory.high
enforcement. Basically, users can specify that instead of having their
application threads throttled, they would prefer async reclaim to bring their
usage back below memory.high. Whether we provide this functionality through
BPF or through something else, I am open to options.

thanks,
Shakeel



