Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF33E7FDCD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 20:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190996B0005; Mon,  2 Feb 2026 15:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1477C6B0088; Mon,  2 Feb 2026 15:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0748D6B0089; Mon,  2 Feb 2026 15:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB81A6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:27:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE4B91A02C7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:27:25 +0000 (UTC)
X-FDA: 84400651650.05.E69C061
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9FFC44000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:27:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tuhOFMIo;
	spf=pass (imf12.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770064044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7DmDiMKWNORzGW7uB2SE6ZE4LS+pgjIFc42sklIo+Q=;
	b=HGw33dVM1e6S8wW1Ctw7gHeQ79EyBePAbIyOhMAi/0EyBifTTnooY9jslC2DVDcvWZAYG3
	4ZqKWsfyjucp6k2TKv1h+m5mxq9usIRN2Bwrp5sABwuNNCiU7bwPvExc9T+kygHlzsnZ5a
	5t3O8ycm3oewXEzH9ucrfyviW89CurE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tuhOFMIo;
	spf=pass (imf12.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770064044; a=rsa-sha256;
	cv=none;
	b=PLVtra8nTPd6qLqrS3afXDWuehNhCknQaQRik6//G0dklMf4K87WeGbZHh4ATHx93nI1+s
	1LqV7YvRi0suNbktxTa4gmO1KyX9wz6agtw8aO3fj/LjUDb4Zl9nSrzjmQ8qpXTW2F31gp
	MCYmJlUITZtWFIVJSVEiEEtjf2F5BiI=
Message-ID: <0ca47c0b-16a2-4a41-8990-2ec73e19563a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770064039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7DmDiMKWNORzGW7uB2SE6ZE4LS+pgjIFc42sklIo+Q=;
	b=tuhOFMIo7xjPiAM08YGM3Apph54a9KYTNsQEKT6NltNuqhWD+niFZFRY+8BRUQzetcB9sY
	Aqoc2K1Cm2hUk6+ybBaE7b5ROP02CwChLKtIGpVuy8j+wPQwvsUY89xUWkkC/aHgLMBKPp
	5FnIsPWgyzyxrC7qWgVyxTLsrxffA58=
Date: Mon, 2 Feb 2026 12:27:10 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>,
 Matt Bobrowski <mattbobrowski@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>,
 bpf@vger.kernel.org
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-8-roman.gushchin@linux.dev>
 <9483528f-83dd-4a30-9489-cf0fac4de5f7@linux.dev> <87qzr6znl0.fsf@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87qzr6znl0.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FFC44000E
X-Stat-Signature: 1okmzutuowzewd7nbp38gy38x71ygdwa
X-Rspam-User: 
X-HE-Tag: 1770064043-843573
X-HE-Meta: U2FsdGVkX19Gjjgywyy9/CXbVVuwHrCilum5gfF+q+31DuuMSzAAQMqRxdvfhhl85V5mNjkQpZ5V1aOlMWjCewpeDJJvkHvaFsc5npEGO6mHSpfYDAqHQetN8ypmHl6XSyF7S1DpSNEWzCnl9g0EEPb81+q79xTUSpfP2q+Jc5UdzyEq8xt+YaniGYsTnzwtbr8Q6wmKX4Ikt81Dn9cajP3A9H2ViUydIWHYMlQkzyi8PL7BScv7Im/+RljMG5lye1gw8aSTFSi4qlbTStHdLlgVBMXYcXfsBrYNaQk1t3KlIyotVKO4VNWCjXvxQYbdpKLINbSdo+kkdlcRFyNppXkM+z+Ia3s8hw631ltW8MrcPne2VM41GFXFWflY/V8vJm821j80FnkRjY7ZVC/90KyYY+lb62bi0SAp5w/aAbHjvX8Z9WVptTwcyWckKN47DAE3hvTpH+7a0jmseZkprFwQGK1IU4lONGQNRStBUusuFHvPt6msuziW8xtgJHKDlFrBl6PAvaKGaUr4pf1RRn/iZhCIRAx5CvaKW5ijCafrVol59ksQkBCJU8wjqmONGgmf2g5w+LB3Ycymk7PA77fvo4r3RZ5H3F6ZFM8eWf24a9Fq4M1qMXnBFKLTFcazu/N2emVB6yDFBY5WQw8Yw4guQ4NL101L51E/Bl031cwsNhGFtHrvi+oCydpQQJxRqwR0q4NncyDGzBKfm1C85A5NjOXKvj6HslU1ao+xmXYNBc098KqV7fmED+ArcIjOV1yxEGjZenVl8HxAmdSVhFd652ULJDzzm/v3GcPNe8O5zvmF8LykAEX3/UNtFcKc7qhAEbaYoK8jVOzzVyRNeWXDV1FiRIEbKJdQ7xKkqIdaZ7YZ85kFjBZA8ZlRlIjg9Rk6cZ2XcxglQ+RLMYzhWa7Rset0dd+YRUFrAfsy62LAmPjwlVx4WxfHrR97i/XFzycuCMDwKb8JIlzzsmP
 1VhPjxGX
 FOTcG1I8zx5S3x8w0JxSDlILiz2CwScCwYYZFNa/BsBpH3yTUqT7eYi/42bLrzwoiFN+T8rSYkuloyv8K5PUEr/hPFRfzERl4InnlPzok+VAqpw9LwWRPNuKTYP726r7k4r1FraUlMxK7FF4yepZ6P1KoEeVZqm0kcWHNI/iiTl1h3jHj3gTLk9AxH1vfhtpF6YliaIVnIFprhxMHOyfcC763FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/30/26 3:29 PM, Roman Gushchin wrote:
> Martin KaFai Lau <martin.lau@linux.dev> writes:
> 
>> On 1/26/26 6:44 PM, Roman Gushchin wrote:
>>> +bool bpf_handle_oom(struct oom_control *oc)
>>> +{
>>> +	struct bpf_struct_ops_link *st_link;
>>> +	struct bpf_oom_ops *bpf_oom_ops;
>>> +	struct mem_cgroup *memcg;
>>> +	struct bpf_map *map;
>>> +	int ret = 0;
>>> +
>>> +	/*
>>> +	 * System-wide OOMs are handled by the struct ops attached
>>> +	 * to the root memory cgroup
>>> +	 */
>>> +	memcg = oc->memcg ? oc->memcg : root_mem_cgroup;
>>> +
>>> +	rcu_read_lock_trace();
>>> +
>>> +	/* Find the nearest bpf_oom_ops traversing the cgroup tree upwards */
>>> +	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>>> +		st_link = rcu_dereference_check(memcg->css.cgroup->bpf.bpf_oom_link,
>>> +						rcu_read_lock_trace_held());
>>> +		if (!st_link)
>>> +			continue;
>>> +
>>> +		map = rcu_dereference_check((st_link->map),
>>> +					    rcu_read_lock_trace_held());
>>> +		if (!map)
>>> +			continue;
>>> +
>>> +		/* Call BPF OOM handler */
>>> +		bpf_oom_ops = bpf_struct_ops_data(map);
>>> +		ret = bpf_ops_handle_oom(bpf_oom_ops, st_link, oc);
>>> +		if (ret && oc->bpf_memory_freed)
>>> +			break;
>>> +		ret = 0;
>>> +	}
>>> +
>>> +	rcu_read_unlock_trace();
>>> +
>>> +	return ret && oc->bpf_memory_freed;
>>> +}
>>> +
>>
>> [ ... ]
>>
>>> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
>>> +{
>>> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
>>> +	struct cgroup *cgrp;
>>> +
>>> +	/* The link is not yet fully initialized, but cgroup should be set */
>>> +	if (!link)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	cgrp = st_link->cgroup;
>>> +	if (!cgrp)
>>> +		return -EINVAL;
>>> +
>>> +	if (cmpxchg(&cgrp->bpf.bpf_oom_link, NULL, st_link))
>>> +		return -EEXIST;
>> iiuc, this will allow only one oom_ops to be attached to a
>> cgroup. Considering oom_ops is the only user of the
>> cgrp->bpf.struct_ops_links (added in patch 2), the list should have
>> only one element for now.
>>
>> Copy some context from the patch 2 commit log.
> 
> Hi Martin!
> 
> Sorry, I'm not quite sure what do you mean, can you please elaborate
> more?
> 
> We decided (in conversations at LPC) that 1 bpf oom policy for
> memcg is good for now (with a potential to extend in the future, if
> there will be use cases). But it seems like there is a lot of interest
> to attach struct ops'es to cgroups (there are already a couple of
> patchsets posted based on my earlier v2 patches), so I tried to make the
> bpf link mechanics suitable for multiple use cases from scratch.
> 
> Did I answer your question?

Got it. The link list is for the future struct_ops implementations to 
attach to a cgroup.

I should have mentioned the context. My bad.

BPF_PROG_TYPE_SOCK_OPS is currently a cgroup BPF prog. I am thinking of 
adding a bpf_struct_ops support to have similar hooks as in the 
BPF_PROG_TYPE_SOCK_OPS. There are some issues that need to be worked 
out. A major one is that the current cgroup progs have expectations on 
the ordering and override behavior based on the BPF_F_* and the runtime 
cgroup hierarchy. I was trying to see if there are pieces in this set 
that can be built upon. The linked list is a start but will need more 
work to make it performant for networking use.

> 
>>
>>> This change doesn't answer the question how bpf programs belonging
>>> to these struct ops'es will be executed. It will be done individually
>>> for every bpf struct ops which supports this.
>>>
>>> Please, note that unlike "normal" bpf programs, struct ops'es
>>> are not propagated to cgroup sub-trees.
>>
>> There are NONE, BPF_F_ALLOW_OVERRIDE, and BPF_F_ALLOW_MULTI, which one
>> may be closer to the bpf_handle_oom() semantic. If it needs to change
>> the ordering (or allow multi) in the future, does it need a new flag
>> or the existing BPF_F_xxx flags can be used.
> 
> I hope that existing flags can be used, but also I'm not sure we ever
> would need multiple oom handlers per cgroup. Do you have any specific
> concerns here?

Another question that I have is the default behavior when none of the 
BPF_F_* is specified when attaching a struct_ops to a cgroup.

 From uapi/bpf.h:

* NONE (default): No further BPF programs allowed in the subtree

iiuc, the bpf_handle_oom() is not the same as NONE. Should each 
struct_ops implementation have its own default policy? For the 
BPF_PROG_TYPE_SOCK_OPS work, I am thinking the default policy should be 
BPF_F_ALLOW_MULTI which is always on/set now in the 
cgroup_bpf_link_attach().



