Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D85C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 01:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12266B009D; Mon,  6 Jul 2026 21:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2ED6B009E; Mon,  6 Jul 2026 21:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBDB6B009F; Mon,  6 Jul 2026 21:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C36E6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:50:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2119C168A56
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:50:18 +0000 (UTC)
X-FDA: 84960300516.30.83ACF13
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id E98A280004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:50:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iGuO03Qb;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783389016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTk3bWiQbEnp9NY0pyiBv+XodrV//lC9BoLhtxJEGoA=;
	b=ehukV5r8UQCrJo2JNWnV0MUodeQ4mdyJ+KIoxWPiqb4g/Ey3GxtZU66TZjSvtmOEVda4B5
	0G5NWYvwNh/Q7LeGb7SFqN3G14ZEgktguWb5XK4DNDtHL+LfEuHVEEGHNGcCAe/ob1owmW
	dKMNXGxA6BSpKK3DJVFieNWviSZnv68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783389016;
	b=r67bSM3GHUK7fiUa1JMtmekD8Mxs5JlhkUizrh3ErhG7w3K9zsFHEPwDPSEozY2qUAliaN
	LHFHPrXR9otinfgb0SZObGMXq7Ues1XH4BWDAuu+qQLszXpXXWyE9gGcL4GWiKWP4zp/ng
	5W4u663FcNKM5tXCjljcEOvg77weOxE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iGuO03Qb;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 6 Jul 2026 18:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783389012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pTk3bWiQbEnp9NY0pyiBv+XodrV//lC9BoLhtxJEGoA=;
	b=iGuO03QbteJKA9aIihTwgX5AqWkgRqrX05rDKfDWlAWxDk7BNPcW0y5ca39Xps5t56uFb/
	16s4rxVCluAQKhlh0zAY3smINquMtK0ZkTszFMX2OyuRCmfoPf5vVYOqLwrcLGYWDiEW8h
	Qjag8AlxR8nfinWL6s7frKd+vQzT4ls=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: Ziyang Men <ziyang.meme@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kernel-team@meta.com, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
Message-ID: <akxW5dzvR9e2CfGq@linux.dev>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E98A280004
X-Stat-Signature: pbsk5bnicr9uorji6tsekhkuw653jkkr
X-HE-Tag: 1783389015-709683
X-HE-Meta: U2FsdGVkX1/i8OxS62YK9Q5sFJNOTwqc/Y8lXOOeUJF5MjVtkILjDkGtzIwZJCbOWktFFLesgEVcXh42byC/WfH+3UcCWEAPikzCDpLaya0BHHISFlvOS6xJGurC+4IdzNuSCU2zBOIIDji7fkyxYxZndWIn4gbYSVNrHuM2Rt5kCAJCorCodKb8vuiRbZhgCSLt6FzrxwJS0znJhvwrrXwAWT2aHaOJhzk4jJ0C30E/lgaYlVEzljZie6J9jxUL3dxKwfj22lQn9RZLmVHo2PpYPlzWyOkW/CroULIS19wKw39qJo0IkphAE5P18VV9p+b/mQ1x4d5fz33eFkslAOrMOshUK6Yo6pc1c+hy+HazX9AVqlAtjwN3dyjrtSpEkAkuJ4l4Ro8Af5iJSC3mAC/333kAEp0h7smdOCHqn8W8v4PtMr8SV5TFRV8jnTJZmxsaIchCpOdqwv/01Hk8Uo6dWGvS7V/jzCccOmFsXxiKmqNZ/aSY5n60qZJvWOrabaZ3OitHR3bvTcy9915LGO6D6v8UTWONLncvhoG9ZujkLXplnrID4Ux78cIV7H+wxs4VluUaVJTUXQmMZMoQtlpyrUzFaYmzhXnS7J85g1nIIkCaduUuUYvNU/PzibweTCuO1aAU6Njl1ZLypaPLY92Vaj91vL6VmIzBhLaZ3oOJ2FkLQmE6xeep3+3jxexWTjmaZPOyDufrQDiqX0RDOuGowCOsCBjF0pzK8DAoziEsljoagfrZddRwl9keB7whadEvhKPEssEADGEtwgzhVsOy3/T/9EMkTOnNryHeFtz0BpK7MLlUSc3QNNE5rZCJDOHmdVuBCYUaChy07CBAH2upSkpfSjDl/qMXpIy1CIXybOzxa5Ss3HVJvjAI4u7JG0ay8iACSoHOMdoqbi+0gHcKb3NXiVHtgAqNvF4a0Gm2FvVBSacgLdmuPICnA8JyysjiF+cVgeijpaPhp3w
 G08/MIPx
 /OmT9uvUBM0LdN43MssrWiImGnJosD0HTyR2MdJdxe7hI5ScbzK1V3lVP4nrQXrVLWMytOHUpijcz8IFWNvG9KBvyQ3G7q0cOIy4aWf3VoZzTkHjRd9r+LhgQyYZKa24IV/P2xW8deeXfBJdfpO69ja9OUVkajTw4uvKUMUtGuDgB+M1o4omi8w82QRaB2wsPsKyx+FUlhI2DXE3KJuzZhT2GrPQVmlFOuKtoialn1yR7jfv1QOeD1kAZNc06MuplAJfIH/fBbFt9vfiiy52/fIop9Y1WWV8IuhSI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 05:17:50PM -0700, Eduard Zingerman wrote:
> On Fri, 2026-07-03 at 21:56 -0700, Ziyang Men wrote:
> 
> [...]
> 
> Hi Ziyang,
> 
> I'm a bit hesitant adding 2.5K lines of code to the BPF selftests,
> as this code would need to be (a) maintained, (b) run at each CI invocation.
> Hence, the tests added need to be relevant for the BPF sub-system.
> 
> Regarding the benchmarking part, as you state yourself:
> 
>   > In my testing (a 60-CPU VM) the BPF path is roughly an order of magnitude
>   > faster than the per-cgroup memory.stat parse for a whole-tree scan, mainly
>   > because it avoids the per-cgroup open/read and string parsing.
> 
> With this, I think the benchmarking code can be dropped altogether.
> 
> Next, the three memcg_stat_{reader,churn,churn_percpu}.c files share a
> lot of utility code almost verbatim (e.g. tree definition/construction).
> Such duplication should be avoided.
> 
> Finally, from the BPF point of view the test exercises the following functionality:
> - kfuncs:
>   - bpf_mem_cgroup_page_state
>   - bpf_mem_cgroup_vm_events
>   - bpf_put_mem_cgroup
>   - bpf_get_mem_cgroup
> - main iterator logic.
> 
> All kfuncs but bpf_get_mem_cgroup() are thin wrappers around mm/memcontrol.c code,
> all kfuncs including the bpf_get_mem_cgroup() are already exercised in the selftests.
> The iterator logic itself is covered by 8 sub-tests in the prog_tests/cgroup_iter.c.
> Hence two questions:
> - What do these new tests add in terms of tests coverage?
> - Why do BPF selftests need to exercise the churn and churn_percpu scenarios?
> 
> Shakeel, could you please comment as well?

Hi Eduard,

Thanks a lot for taking a look. The main motivation I had behind requesting
Ziyang to send this series (beside making him learn the tooling and process of
sending patches to lkml) was to have a reference implementation and performance
comparison for BPF based cgroup/memcg stats collection.

However you have correctly pointed out that selftests might not be the right
place for such kind of code as selftests are more focused on functional tests
and run by a lot of CIs while this is a performance benchmarking code.

I am wondering if there is a place for this benchmarking code in kernel under
tools folder but archiving it on lkml might be good enough and should be easily
searchable. Anyways thanks again for your time.

thanks,
Shakeel

