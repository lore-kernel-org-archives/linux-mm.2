Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0D1CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19E98E0039; Wed, 20 Aug 2025 18:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA498E0031; Wed, 20 Aug 2025 18:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8CC8E0039; Wed, 20 Aug 2025 18:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86C408E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:50:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4536EC015B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:50:05 +0000 (UTC)
X-FDA: 83798630370.12.C73C184
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id 00E2140011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:50:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nB9asYOT;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755730202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsdDNWT0aPaFWkXNVMSJrwjwzzlXY8/IesqRJaJrUFg=;
	b=tbJk2b1QK5riCLb2EXOM6z4LQE50NJ9xr4I/0MfNf6tImFiAQDcbimGOfxr7IIku1FfnXo
	S1msyyAiADjEngmbVDgiRZQ8wrPz5rSDeHESw83w+1P4SU5NK07Tsomk5Efd7+H8v05euS
	JxdLGJIuQzmC2m+KbDUrfd/Tomhfk8Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nB9asYOT;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755730202; a=rsa-sha256;
	cv=none;
	b=r0kKeIcvKNqDj9ra/y9Fm2BHwkSSz+rUOwDf5LLdQq3kKN0LDeUmzNQMm9t3hfGd0d57Ho
	MrNL/ybqa3IPF2q40954aaLCIg7ca2RuSDNmOmO7h+AQADZ+05j3cjr1mdcapVe1yLlhwf
	zu1o29BuHOb0fbFB7aAuvw0Spj65W8A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755730200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UsdDNWT0aPaFWkXNVMSJrwjwzzlXY8/IesqRJaJrUFg=;
	b=nB9asYOTay3SplClMlGUjqJrUlNm40iBpD5ePjlHlcko7ltyfZdyC8gCY3jD40zA+3I/ZU
	UINeNtc0dBEbM/WktZuxCAHr4Af/b1uEbFb0lAqxvpNyZU8B1+B1tmnxpcRHvi2ZRfyOR/
	NZWzYbGQCeZ/LrkD4Df+fjs3Ag8mOic=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 10/14] bpf: selftests: bpf OOM handler test
In-Reply-To: <CAP01T75_ArZiy9AB6TwNZCxKJKw+2yg58xz1ubTGZr4ynVt+Mg@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Wed, 20 Aug 2025 11:33:42
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-11-roman.gushchin@linux.dev>
	<CAP01T75_ArZiy9AB6TwNZCxKJKw+2yg58xz1ubTGZr4ynVt+Mg@mail.gmail.com>
Date: Wed, 20 Aug 2025 15:49:53 -0700
Message-ID: <878qjdobfy.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1mxo9giosd619uyb3x665som7d3bedcc
X-Rspam-User: 
X-Rspamd-Queue-Id: 00E2140011
X-Rspamd-Server: rspam05
X-HE-Tag: 1755730201-16995
X-HE-Meta: U2FsdGVkX1+X2VRMoy1G73tXHNeHTFTfgbRYHISOxRjalemDai+8hg1/l0V0QHGbgHmJAsslkjxBsIEe7QxtN3AHXPPSynX/2gqnbA3ofFRMSR3qziYPxOBk6rRfO905WH0pe1In1MGeOeNzIXRTB7xZOQE4EeanWESkN+3HYtmot59RCpVJbWw3f3AHCYtlGMcry+zhcpIniiEVJ/dkcNwfWzsU76sR+6FTrRbEOYU41bA9LuewKoJAPopdUmuZHMJhJBsvAG/ajR4dmhToC+Gzdh3T5Eg6iEvpq66n5G3jJcXM0mYftHpljxmeWpTul7R5m+3d9APhXniFGh6ODKJkKHbmqQ/HAI0NEJujj5TdPHE4k7lJICaDXgVEryKSgLaotJUg/pgfpeVBnndpKF2Ks2rop9BukcArXNc1p+AQQ7kL/uiltVe+Tp+aaZdwb9HI+lLYpMxjpmMBA2ogJ1be/B0sc2BtrBD8VpBO1rH/LnPzmnTSGOSwe3LHf0SHENXDx/rmxSj8XYMeihaGVLeK742N3akHY3Wg4+//SAcZnDB5izMxHUNQ79u6s7r4JC7m7l5oXHDpIp8CwDlVsScJp/32t7t2NKlvndafZ1knOks2lXjEkkQ13M2RGorh74qM6s3zvFiS8JqXZShIU4Ii//B96OxwQuPpTjazDdi7LEBZ3q0MgXMWV0nEU9eFD7cBH1bmQQ0k/ca+N9OPCml1DfPXluEnVBeGwbuDPmxBxrMw65CQIUL9V/IMBVnb4APYWDiYHfI3YZx5Kb352ddC07sD3JCXEqETXfJIS6vYBHaJoLKFuuO1cn57ldToGJ9CbGHX9Xi/d+KhfalunHPdMXKacMZQzdlU9AWxjTiBWvf4bHCkjw9x3O7VFBh2Nm1UsTeySKm1nyLvFqWi1nHd5I1D5NBsQ3fxmqO6o5jN5xUoxU87m39Lfy4jSr1t/9YvcRBfiZ7MPRUSViT
 R2fZZNTB
 KvXsSW7FBbklHn705WPBSREA/L68y88Nvx7ll9ET7xhWVzMEfybgcshqlX3T2FPDggIIDuGro0IrliYpi/A/kwrG4abSm8ptyFUqF3W4w59t5Ub80pCEYJ3At4taSAEkYz3iQ8Eunh3//v/ztzUfva6aubay/3HK9na/t/uQiEiymHBgtTtdfjiSlbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> Implement a pseudo-realistic test for the OOM handling
>> functionality.
>>
>> The OOM handling policy which is implemented in bpf is to
>> kill all tasks belonging to the biggest leaf cgroup, which
>> doesn't contain unkillable tasks (tasks with oom_score_adj
>> set to -1000). Pagecache size is excluded from the accounting.
>>
>> The test creates a hierarchy of memory cgroups, causes an
>> OOM at the top level, checks that the expected process will be
>> killed and checks memcg's oom statistics.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  [...]
>> +
>> +/*
>> + * Find the largest leaf cgroup (ignoring page cache) without unkillable tasks
>> + * and kill all belonging tasks.
>> + */
>> +SEC("struct_ops.s/handle_out_of_memory")
>> +int BPF_PROG(test_out_of_memory, struct oom_control *oc)
>> +{
>> +       struct task_struct *task;
>> +       struct mem_cgroup *root_memcg = oc->memcg;
>> +       struct mem_cgroup *memcg, *victim = NULL;
>> +       struct cgroup_subsys_state *css_pos;
>> +       unsigned long usage, max_usage = 0;
>> +       unsigned long pagecache = 0;
>> +       int ret = 0;
>> +
>> +       if (root_memcg)
>> +               root_memcg = bpf_get_mem_cgroup(&root_memcg->css);
>> +       else
>> +               root_memcg = bpf_get_root_mem_cgroup();
>> +
>> +       if (!root_memcg)
>> +               return 0;
>> +
>> +       bpf_rcu_read_lock();
>> +       bpf_for_each(css, css_pos, &root_memcg->css, BPF_CGROUP_ITER_DESCENDANTS_POST) {
>> +               if (css_pos->cgroup->nr_descendants + css_pos->cgroup->nr_dying_descendants)
>> +                       continue;
>> +
>> +               memcg = bpf_get_mem_cgroup(css_pos);
>> +               if (!memcg)
>> +                       continue;
>> +
>> +               usage = bpf_mem_cgroup_usage(memcg);
>> +               pagecache = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
>> +
>> +               if (usage > pagecache)
>> +                       usage -= pagecache;
>> +               else
>> +                       usage = 0;
>> +
>> +               if ((usage > max_usage) && mem_cgroup_killable(memcg)) {
>> +                       max_usage = usage;
>> +                       if (victim)
>> +                               bpf_put_mem_cgroup(victim);
>> +                       victim = bpf_get_mem_cgroup(&memcg->css);
>> +               }
>> +
>> +               bpf_put_mem_cgroup(memcg);
>> +       }
>> +       bpf_rcu_read_unlock();
>> +
>> +       if (!victim)
>> +               goto exit;
>> +
>> +       bpf_for_each(css_task, task, &victim->css, CSS_TASK_ITER_PROCS) {
>> +               struct task_struct *t = bpf_task_acquire(task);
>> +
>> +               if (t) {
>> +                       if (!bpf_task_is_oom_victim(task))
>> +                               bpf_oom_kill_process(oc, task, "bpf oom test");
>
> Is there a scenario where we want to invoke bpf_oom_kill_process when
> the task is not an oom victim?

Not really, but...

> Would it be better to subsume this check in the kfunc itself?

bpf_task_is_oom_victim() is useful by itself, because if we see
a task which is about to be killed, we can likely simple bail out.
Let me adjust the test to reflect it.

