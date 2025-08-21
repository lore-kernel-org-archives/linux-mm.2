Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2A5CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 00:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64CF8E000D; Wed, 20 Aug 2025 20:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C7D8E0008; Wed, 20 Aug 2025 20:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79828E000D; Wed, 20 Aug 2025 20:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C79988E0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:25:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B4A7B6D76
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:25:05 +0000 (UTC)
X-FDA: 83798869770.10.9CB0A5D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77E2E40003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:25:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f1pzUfMI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755735903; a=rsa-sha256;
	cv=none;
	b=tZ4cYCbX1O+OHRGXadD+AC9whqmROvYeY8wqQ0kYqWmVQOWoRWnm4eZ0qZqv8iUalMBikZ
	tmk2xI8LxVHGsfA7Jc6PWKgP3HcrUaFylwpbBrS4jY/9xvuWRqNrpqP6xsO3Lw11pNPQQU
	WbyQn9H7+NOr6j5lMo5p48Bq50iFYlk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f1pzUfMI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755735903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FX8HTbC4t5mzQ4enhPjum2fJkgBjClbezU/1uRSatWo=;
	b=sRcU6CKfH8wbbN1Bw+E+CQSgvrnx9VvxqgfDofbX7jx/fbRbZnxOmG7HA4/J5Pg5i3sbmA
	0jRnnFpY3ctH+t+2ER7fa1RzJUVamXRJtTgjPqcnUj46rxpGKLKqHGcBdvpVQXlUsHGUfa
	AQa14pYom+pOBF1WnIBzREn/SfByEBU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755735901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FX8HTbC4t5mzQ4enhPjum2fJkgBjClbezU/1uRSatWo=;
	b=f1pzUfMIl0HI3yotPn3qpxVBD1cKujg+g6E8HGFQ5nAimJQw+BiEoqriXFs4nxLNRKFJGL
	NPq2l0X93eWXYRqCBpbtt9pwXN7X3O1Nwr5+RPYx9X8y+cIS9ODDvrqbh70Sn6+Gq+RDFc
	HiORW6wg5SfKJnsYMAYau0YC1xkWHtE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Wed, 20 Aug 2025 13:28:46
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
Date: Wed, 20 Aug 2025 17:24:55 -0700
Message-ID: <87ms7tldwo.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 77E2E40003
X-Stat-Signature: cc8po9dogboys1sgxpufcbpqk1c8gxsp
X-HE-Tag: 1755735903-107000
X-HE-Meta: U2FsdGVkX1+DoSp8b4gErzLLX1hauT3+tm3E4WWtIJMHlCT+gLaFCYFnqj5kyH9UhiMC8kY7roj4qTf/Yq1fYJDTp+P8hl7RbQM4fhVaEgxSN6qVeOyHseAxo36FIDOG7v9teqqFuQQGZUOG2BcQQLJqgLAl8msny1qM+rrJUXvzGO4tYVhIi89QFTJjuZBDNmCEd9so8dqKaryOctYVZeQfIJAPr5BUTyhc/nZStFw+rmfZ7FySMAFp91Ijo/xj3cQvwVrJ3NKgWMGxyJ9JhTh6alSp+GhCyohslAccEyBekMxVdo8YBRX/gG6GDqwXOs9RxzEnxOefMPNj/6ErWHaCNB00NaWeRV6td8ivRWLtmgYArag53B7xw4k5ETy2+tuohECbJ49W4x8ST9lijJEXfx1NErtjTLr8tsz6qqhDqm6ipTnfRxqKYjs9jzS7F4YhU5/zUM4QqdOxpBMGATwe5xiAAfmHjXWg1ukIlxs3vALrOvl5T6Omy8cEZfUB2D3AdECMscHaLc2aXTV8n0rxF8ii91YWk5rfJDrk52Yd6l2Bu7Xd++SKpt9KMrGOcD1MwPYOS9bXX94Wk5Z0oVjRltynW80SpwuqxxZpd2oJGYHVqXEqqr6GSR6MXH5+r1HIgwfTQQ/JfdkWwjJDXntXCQTpic1XlS5h+7RLuagW/nGPv8rbnzRUJweU65GOQ/SG40KhbPR8GQCl/4eAdgwL0X0A5Pkr2rjyhn+0NjOjpmsHuN6YfJ42WiJjoCx+WVplkIlKQvjV85x8ZsU0idW+fyQIC3n+zM+zLYfF8HqnwpL989VUYcBFsveET2uN1LrkkPnnD9IYDzs22g7mJEjqz0UaOxzHUZl2yeqfbIFz6jE6Puu+ebxB69LCsOQsjqhHcCf442hJRGXh+FmLvZsI0aXlOpluyjmi+ALf4QRtoa23ylHybIgHwtYq7GCaGfvZqycPWHN4zjBsVTQ
 TbDDMqMz
 /3ycJI7bZRImMN8/lAKHjGVzH1+tFa8a7paKbyL409iYfMxE3qRfeEQ1gq6SJlGS/ZbbJgX32lmZIKX02cc2xn2dpAOBe92yAepFWG2TsPnEUe+kWWo4Psq44wnAKZj7wb889gAgC9kwQMq2Gk3JC8OqoiNsVUjFrmsyDxJxJ9RNN0sf4RYIQhot7vfJnvHxZgx5SS0CyegnEdY8kHT+tHZFe9EQncHqyu+dFopap6FJPV4LUWnSWfdoyObjlXiVdGo5BoHYkN9Qd1hA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> Introduce a bpf struct ops for implementing custom OOM handling policies.
>>
>> The struct ops provides the bpf_handle_out_of_memory() callback,
>> which expected to return 1 if it was able to free some memory and 0
>> otherwise.
>>
>> In the latter case it's guaranteed that the in-kernel OOM killer will
>> be invoked. Otherwise the kernel also checks the bpf_memory_freed
>> field of the oom_control structure, which is expected to be set by
>> kfuncs suitable for releasing memory. It's a safety mechanism which
>> prevents a bpf program to claim forward progress without actually
>> releasing memory. The callback program is sleepable to enable using
>> iterators, e.g. cgroup iterators.
>>
>> The callback receives struct oom_control as an argument, so it can
>> easily filter out OOM's it doesn't want to handle, e.g. global vs
>> memcg OOM's.
>>
>> The callback is executed just before the kernel victim task selection
>> algorithm, so all heuristics and sysctls like panic on oom,
>> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
>> are respected.
>>
>> The struct ops also has the name field, which allows to define a
>> custom name for the implemented policy. It's printed in the OOM report
>> in the oom_policy=<policy> format. "default" is printed if bpf is not
>> used or policy name is not specified.
>>
>> [  112.696676] test_progs invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>>                oom_policy=bpf_test_policy
>> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
>> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
>> [  112.698167] Call Trace:
>> [  112.698177]  <TASK>
>> [  112.698182]  dump_stack_lvl+0x4d/0x70
>> [  112.698192]  dump_header+0x59/0x1c6
>> [  112.698199]  oom_kill_process.cold+0x8/0xef
>> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
>> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
>> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
>> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
>> [  112.698250]  out_of_memory+0xab/0x5c0
>> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
>> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
>> [  112.698288]  charge_memcg+0x2f/0xc0
>> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
>> [  112.698299]  do_anonymous_page+0x40f/0xa50
>> [  112.698311]  __handle_mm_fault+0xbba/0x1140
>> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [  112.698335]  handle_mm_fault+0xe6/0x370
>> [  112.698343]  do_user_addr_fault+0x211/0x6a0
>> [  112.698354]  exc_page_fault+0x75/0x1d0
>> [  112.698363]  asm_exc_page_fault+0x26/0x30
>> [  112.698366] RIP: 0033:0x7fa97236db00
>>
>> It's possible to load multiple bpf struct programs. In the case of
>> oom, they will be executed one by one in the same order they been
>> loaded until one of them returns 1 and bpf_memory_freed is set to 1
>> - an indication that the memory was freed. This allows to have
>> multiple bpf programs to focus on different types of OOM's - e.g.
>> one program can only handle memcg OOM's in one memory cgroup.
>> But the filtering is done in bpf - so it's fully flexible.
>
> I think a natural question here is ordering. Is this ability to have
> multiple OOM programs critical right now?

Good question. Initially I had only supported a single bpf policy.
But then I realized that likely people would want to have different
policies handling different parts of the cgroup tree.
E.g. a global policy and several policies handling OOMs only
in some memory cgroups.
So having just a single policy is likely a no go.

> How is it decided who gets to run before the other? Is it based on
> order of attachment (which can be non-deterministic)?

Yeah, now it's the order of attachment.

> There was a lot of discussion on something similar for tc progs, and
> we went with specific flags that capture partial ordering constraints
> (instead of priorities that may collide).
> https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox.net
> It would be nice if we can find a way of making this consistent.

I'll take a look, thanks!

I hope that my naive approach might be good enough for the start
and we can implement something more sophisticated later, but maybe
I'm wrong here.

