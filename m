Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 975C4C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA9C6B009D; Mon,  7 Sep 2026 00:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2DC6B009E; Mon,  7 Sep 2026 00:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701976B009F; Mon,  7 Sep 2026 00:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 424C76B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:08:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A353E12067C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:08:13 +0000 (UTC)
X-FDA: 85185633666.28.ACEA005
Received: from mail-m6010.netease.com (mail-m6010.netease.com [210.79.60.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 36A7F40003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:08:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.10 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788754092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5IMkeW2wGRtLB3HXs6itwoS5gWbbEsZi2H9pFnOd/o=;
	b=TMP/ip4uXC/P1Zhzhpz8b4dktvD72uO0XIwcr+tL+VKVRyfsFrQ6c+F7Y+ehomLkhG/7UX
	/lLyXWugxhgCqmebZh0MDNEZ8k5hx0HJ6LdLOEsV8BCoT81OijE6lxa+6BfEoNtTkwGnG+
	Q7IQphiQji40Bim8eaYpP7a5oZwBhyo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.10 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788754092;
	b=f3i9g2X0ez/97J++zvHAZF19sLMY2iAZIdHcTv1QBQOD7bckGAXg2Xb82EPylzknR0zpaV
	nqpj8BAKH8CyEV5T8g1AV74rvKY0IbIV1i5oWoZ8fFDw1/9unNe7SZH3jipdroGx908G5n
	QHTsR17QOSqOpr9kSR3QPyCKjiTQOxk=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec3c789f;
	Mon, 7 Sep 2026 12:08:02 +0800 (GMT+08:00)
Message-ID: <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
Date: Mon, 7 Sep 2026 12:08:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07a0d39ea0229kunm364620a714e1c3
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGR5MVh5DSE5DQ0IaSEweHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Stat-Signature: i5i1nqqe38ckyepbfmpepg6rwihr43mq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36A7F40003
X-Rspam-User: 
X-HE-Tag: 1788754089-751659
X-HE-Meta: U2FsdGVkX1/5tSoXCtrlfwSXGXCl21L6MgSOTVns8GvMTBuR8Hg7MD7e8MYi4k+PfjhUMvojm7og8u8mvm6aJrRP7sz+qEMCEfFSgNk/eWTGTz5OnSqoauWGniu2gH0iNb0SzxKCtJZ7lkJ+s+LwqSdyDq/58NuTZkZdolMDtD348eRj6Kx3YY5e26HSrNTohVM+irIfL9m4FeU2i+FRJGYePCzPhcd2fpBDwD+q5mO92DmcEGmxofgpaYvjOf41SEho8GY5p0b8vXd5vMWDIofdEGvO/ynuaBsyjhKNDFjlA4rXVVWD8T/ba0GCoy90hELjFfvNhOVyVLtRcqv6iAp5jRDlSmLhF+33k6isupWS/JjLJDUNnSpdC+B6BI3oV/hdyeqIf+mekb15FYpDQqZiMC0JpQ/FbLlr2YScFyEojyRirs+/D6gWsZtDpnmTOPEeSwKN864vpSGdElWkUozSsSAlR3ZE2n+BzlChj+Oz4trwG98jES37ob6rux60ud848diV86CLB7FdN2iGSmc8aSsdfYwKVgQsOqoVALWrRd5K33R+7rF3brsveijDGDDszzxynP7A7Xp6mrmuZfw3nj22nswHXeJObBLkZ13hSpCr4Wjb64n51o+4nYViIU81kJk+oWEoPQwCJfehTzkEvMoRis8ihZaZfhfh/TmblMWPRpw6+GrdjvnGYXmO5tOhCivqlDYUtyvtWb/kl5oirmzx6q4N78aDT68flyeUWurK9xySO7YRPxRSA7bNzaF3Dcw6oFoXM1k9ERGVyVLrlt/o5PnGIhPEZKxK3DFtX5cHOVNIpvr+NykPqZbkV/qxp7hDp6vHZkRRSXEu/AmFNEuNhPOiAXS6dAbgsGl1yQjOkzo2KRoScKgcPsKZqI9cNnWYDbIx89C6K8auK2BxybzzrYynMtNVWHqNzujA3gdxsHElBruSdzWnnTlm960BR1tFRkEnVv3f44F
 05xrusJC
 g9yI4fAgf+/apVboZvVwX4R2nPQzRKKZyGVFaBoMT+oruTHk7JNzXV3qYPDRNAKxBzSIzhhl7BSojacKvkwm8a/kimduIvTT3eExBQcMdl6FTXB8eoCSSI/RXVA2AtuQ/ODkq4onuAOgE3mdT9YK0qQaCjFPI0zqV88YIhjahHxO5B6D9+uj1QSC3rUmMpTsdOj4lo9UwN3KOyTh14Yy7mSrjXH/6jTU60EGV/typfkFirA8leAJCHVsUncghqNxf35/TU7/IOUeOz5Mvse+mcomu4gCTwmaD4+9MmB17g0MKT3iJukl0azYLJs6FCSpOIh5rYPH06ROFxds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/4 16:25, Vlastimil Babka (SUSE) 写道:
> On 9/3/26 06:18, Zhen Ni wrote:
>> This patch series adds process and memory cgroup filtering support to
>> page_owner. Following the previous series that introduced print_mode and
>> NUMA node filters:
>>    https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
>>
>> This series adds filtering capabilities to page_owner, allowing users to
>> filter output by specific processes and memory cgroups. Users can now
>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>> memory cgroup path. This makes page_owner debugging more focused and
>> efficient for tracking memory allocations in specific contexts.
> 
> I wonder about the usefulness of all the new filters. In my experience
> page_owner is useful to find a kernel memory leak code, and for that the
> stacktraces are most useful. Dealing with things like pid/tgid/comm/cgroups
> sounds more like your aim is to profile and optimize particular userspace to
> use less kernel memory? In that case, isn't it rather the area of memory
> allocation profiling (or maybe tracing with bpf), not page_owner?
> 
> Moreover, tracing or bpf can already do such kind of filtering and AFAIK
> ftrace filters for tracepoints are nice and generic, while this is adding a
> bunch of custom parsing and filtering. So that makes me somewhat sceptical.
> 

Thanks for the review, and the scepticism is fair - let me first
clarify where I agree with you, then explain the niche I think these
filters fill.

In memory usage source analysis and memory leak analysis, I believe
page_owner has its own unique niche:

1. Nearly all historical allocation records are queryable. Dynamic
    tracing tools (bpf, ftrace) cannot do this.

2. The full allocation stack is recorded via stackdepot. Memory
    allocation profiling as a code-tagging technique cannot do this.

3. Zero extra usage cost (works as long as page_owner is enabled) and
    a low barrier to entry (one echo line versus writing a bpf
    program).

On the pain points that motivated the series. On production machines
with large memory configurations (e.g., 250GB+):

1. Collecting page_owner information takes minutes to tens of minutes.
2. The output is several gigabytes to over 10GB.

That makes the raw output nearly unreadable and forces post-processing
with tools/mm/page_owner_sort.c, adding further workload. The root
causes are:

1. The PFN scan itself - unavoidable, it is the price of page_owner's
    core function of covering every page.
2. Printing every stack for every page - this dominates the cost and
    is avoidable. stackdepot already deduplicates stacks and keeps a
    refcount per unique stack; page_owner then re-prints the same stack
    once per page, and page_owner_sort deduplicates it all over again
    in userspace.

The filters target exactly this waste: they keep page_owner focused on
the user's area of interest instead of paying the full print cost.

On the overlap with dynamic tracing and allocation profiling: the
features do look similar, but the usage scenarios differ. page_owner
is not enabled by default on production systems, so most developers
rightly reach for the lighter-weight tools first - dynamic tracing or
allocation profiling. But when page_owner is already enabled, or the
lighter-weight tools cannot solve (or cannot conveniently solve) the
problem and enabling page_owner is an option, the advantages above
kick in: the historical snapshot is filterable in place, and the
filtered output is small enough to read directly.

So I see the filters as completing page_owner for the scenarios where
it is the right tool, rather than competing with the profiling and
tracing tooling.

>> Targeted filtering provides significant performance benefits on large memory
>> servers by reducing both execution time and output size. By filtering at the
>> kernel level before reading, only relevant page allocations are processed,
>> dramatically reducing the amount of data that needs to be handled in userspace.
>>

Thanks,
Zhen Ni

