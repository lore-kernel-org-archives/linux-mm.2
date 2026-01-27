Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D9CD2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC616B0005; Tue, 27 Jan 2026 16:13:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BA66B0089; Tue, 27 Jan 2026 16:13:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C586F6B008A; Tue, 27 Jan 2026 16:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B84576B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:13:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 573B4B8724
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:13:20 +0000 (UTC)
X-FDA: 84378994560.28.15235BA
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5AD3C0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:13:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KLjUKGIV;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769548399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kiGEnGoweVmTyxsL2DKf2fIPpWt5tDh3VmH3bD1i63I=;
	b=8JvRIwOd9/Nv/EL1glSYig8umSsYAyUB4e88QRVF0QOYEQqR7MSK9rz8cbQBDzQnotcVCl
	1G29ZXfEc362V29vue+2puLI8xXgF1Csjz7gJGjbwz36dqhni9qlkPyl23Rd3XU9ZKHxFa
	hwQs+RSi8nTliNdAzTgDbYYjVNj8sqM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KLjUKGIV;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769548399; a=rsa-sha256;
	cv=none;
	b=A29CdPdwOtPq89UABeO/DkOk46SOd/JwY1kemIfoptfLjBucClkXUOFsUs2IqNUiAH18NO
	GsM6tFtqzqwP1791+x0EhEdtRc8B6zhVnewVS5MwcKVAVGe83NNfXhleIcN7fKL85cK5z1
	4bnlxI3E0m1MQ81or0ewDKOqMVdLOMk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769548396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kiGEnGoweVmTyxsL2DKf2fIPpWt5tDh3VmH3bD1i63I=;
	b=KLjUKGIVKKiUgOpaKmO7R7vTimJ1GcMzFpF3pehqjITQ+8twLC/k5bWDZEGLq7bfHfUSMB
	alS/VUZiKgofs9CTbd8JrOjjSZFQfz+mKt3Dt30icS0Jjf/QkaNvUoB7eMwQDUhD0Yh+hz
	4T/rjG7S8/jIYR73JOT2XbFQcYx0Gd8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: bpf@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,  Matt
 Bobrowski <mattbobrowski@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
In-Reply-To: <aXiHok-3SKqLncCf@tiehlicka> (Michal Hocko's message of "Tue, 27
	Jan 2026 10:38:42 +0100")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-8-roman.gushchin@linux.dev>
	<aXiHok-3SKqLncCf@tiehlicka>
Date: Tue, 27 Jan 2026 21:12:56 +0000
Message-ID: <7ia4tsw6hi93.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5AD3C0005
X-Stat-Signature: fdqxg874rih531ojtffrozdkscax7ipk
X-Rspam-User: 
X-HE-Tag: 1769548398-855049
X-HE-Meta: U2FsdGVkX1/0b7kGIpR10MfyLW16bEbHeZAEeMEDAAGARXO5MHXCrmI0KQBihd2NowrY6OsIbkVqIQdAJoBK9otL9OiDonESYfFv46DaZ5aCbN2cgL4PNXRi5IPHoaBG2saNaphA85S62TaVvZXLQl9GwWQkPBeUhUDpgeMCWo5Qi9NYoC36FykAvwrmJuYI8eSxWG5e/s0nm1AGaJ5OYB6ald1ealXPl/8jpzB0QdRtxwPFu1bECTrOf8qJdgMVIgMBKAOMkdWBoNJN/KlY2+Q/mddHhz26ofoOY7hsx31cWAWqt+8RTvLrQD46mdfNQz1SHEXn/baByNI37CXag2HA0ni/GL6tab2zAxE2mEKmIfa+8Il4wKXDcr0GD70zSozBhH251b8jLo24ZHNidN6LYva7nQrtP+k9b5pSdDrVARbGqc7yFubjo5Yz5hBal37ZD/yaq9YrCCLxgH4I3w9lUIQn0DHXyQ6kEJedlR7VgdDr+neUEf75ajL+lOZ57WlkaRn1f6pmYB9m6sSwrNylDBCVwsoUbcTSgh6fgp/whxwa1b5z8tqmdJ81O6F8r680+4PTqnBLkn7cMOD4zRP4IyUF1613MwOL+XykUUOEx8RQc4pdp9JvIm4/or9/SDrPhA8N/Dw8Ja1X+3aa8yI93dM/haPZsiZtKY0T59PtNKUpiM8fkrfn7vZyEDm4KEbEb187oCmqevBXRtXhc4cZb7hwjKbxNhAOf1BWOWII5urWudHTQSoEAMuqRJRzmsAv3PIIFJbFiY+KCU7uOJDgYpshQRi8kceiJZe2DQ3S4GK7F/QQHkNK2GMOYukfxRwJWJk+9xs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
>> Introduce a bpf struct ops for implementing custom OOM handling
>> policies.
>> 
>> It's possible to load one bpf_oom_ops for the system and one
>> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
>> cgroup tree is traversed from the OOM'ing memcg up to the root and
>> corresponding BPF OOM handlers are executed until some memory is
>> freed. If no memory is freed, the kernel OOM killer is invoked.
>> 
>> The struct ops provides the bpf_handle_out_of_memory() callback,
>> which expected to return 1 if it was able to free some memory and 0
>> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
>> field of the oom_control structure, which is expected to be set by
>> kfuncs suitable for releasing memory (which will be introduced later
>> in the patch series). If both are set, OOM is considered handled,
>> otherwise the next OOM handler in the chain is executed: e.g. BPF OOM
>> attached to the parent cgroup or the kernel OOM killer.
>
> I still find this dual reporting a bit confusing. I can see your
> intention in having a pre-defined "releasers" of the memory to trust BPF
> handlers more but they do have access to oc->bpf_memory_freed so they
> can manipulate it. Therefore an additional level of protection is rather
> weak.

No, they can't. They have only a read-only access.

> It is also not really clear to me how this works while there is OOM
> victim on the way out. (i.e. tsk_is_oom_victim() -> abort case). This
> will result in no killing therefore no bpf_memory_freed, right? Handler
> itself should consider its work done. How exactly is this handled.

It's a good question, I see your point...
Basically we want to give a handler an option to exit with "I promise,
some memory will be freed soon" without doing anything destructive.
But keeping it save at the same time.

I don't have a perfect answer out of my head, maybe some sort of a
rate-limiter/counter might work? E.g. a handler can promise this N times
before the kernel kicks in? Any ideas?

> Also is there any way to handle the oom by increasing the memcg limit?
> I do not see a callback for that.

There is no kfunc yet, but it's a good idea (which we accidentally
discussed few days ago). I'll implement it.

Thank you!

