Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C5CD358D6
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 06:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E80C6B0005; Fri, 30 Jan 2026 01:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5963C6B0089; Fri, 30 Jan 2026 01:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E216B008A; Fri, 30 Jan 2026 01:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35C766B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:17:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE331C14E7
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:17:48 +0000 (UTC)
X-FDA: 84387624216.11.2AA9012
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE9C480004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:17:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uh/m2RGZ";
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769753867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc43I2XjtgSCW/lhB/Z+tW4u7IMzTAGJYJqdI4VSEG8=;
	b=WnU3PSNpjF3AHiW5lpCMpqd5dxvs/Kyu3oWOd726uEHPeSM3prqrdJRrtadz6mQxCf8iNc
	zeTMG9Fm3SOEDMDsuTmsSvkHekRM0DGOqJLhVkO09BQXkGxGQLzZnjB3ilb8iLaQZt9e6h
	v7P83BYicG1q7iAswbu8B1G6tCY91us=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uh/m2RGZ";
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769753867; a=rsa-sha256;
	cv=none;
	b=RHze+LCkw91WoWmpXfZaPeyGx5+/9vdKvz2WA35OuwObOnCeBBAs2DMDG5z52OmDfeJwLV
	r4C6aj/htdMIjiXs7d1dKANt0x9bKouNc4sDDif32baTjG5XFkURo6a4f4eRUkHH7EfcDE
	0mLXIgLhH2YqmjjiyRrqk3u9PEWxwjY=
Date: Fri, 30 Jan 2026 14:17:32 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769753863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc43I2XjtgSCW/lhB/Z+tW4u7IMzTAGJYJqdI4VSEG8=;
	b=uh/m2RGZONlBv4grhrNFYxpeBB+mzaqQU52VLKVj8SSwhbfi1jnn0JW0X+4pOg5bJL5MqN
	o46QNk0LCfDriaEtLad5Vrtq/JHJ+bpLCNRk7tPdv48NALYk4ZsqIe55oErjRhM1dOsD5P
	+OEXEBCY2GU8MBZBsUmCb2GAq6Khez4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Message-ID: <oj5ossmsvybogs5fr2fjdmms66usoh7pdpkuxwlkagxniscrrb@vghtzkxauvix>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
 <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
 <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: b5dc7dtzztse13wngd64okjrbu37xcmq
X-Rspam-User: 
X-Rspamd-Queue-Id: CE9C480004
X-HE-Tag: 1769753866-848175
X-HE-Meta: U2FsdGVkX1+tWtrj8NdCwGAZ4ycwDvFOxPaQS94HX4ucdCEQStfhZWZORKsafsNYG34Vx69AA2n5xmV4sebsE8WQFVZBKB5XDBm3yWOFS5K0TGmpTicJ5B2ixIpd5VNixrhKKfiuc0jsTnEi8Ue9DmkxjSyibFd8zHmt+mps1IXT4udiNI6PWf7GcpKv/aWSzP0hbMEbCced1wKhBBWsSHruEDAU9G5+FXnHud3cP0aEryttCUget7Xhja+qvSfXQNLjrzNgAo8Ft4xLYCtx7p1LmBLhYwCtlxOlajgDhiKYnbdyqBxs0h7cwN0+6DJVnIZAnjsnbZ88NmcbPAwB/2SXAZ/AupwMqTT2MXYOwVvxMj2iLP7K1DdiVuD8R7vj07by7zoJPOxfz0LPUh079ClH+zuxhLQvbdfiWzzWqiYZpgemcKg5L7j0z+WnRWdUAqZwvXRDfRUtKdN4pqKcF6yJWplWlujmwTvpj9sgkIph8e6hL2uEMiNxEzp9gVMGJosj9LbxTMmGBsELMPmelljX6uKuCFKjPzuLu/DoFSM1JHzAqZqrgDjiShnsVFHidTSF3GM1OqtPQEC5fGk+S+FVSZfhO1mN/r7pzTBvpqKp1wUx5+EUuMpGUxutcIsmMZdlAbW7lQ1qC1854RFkTdYBlwc3JRxfaX8akbBC4pwmkagJTweplJZWrBHs/vDkzK+yBo7RVHPUQUqG+AA7eNU8AL3m64/EMj6Ox6MOBwy5IRWrlzqUcxuILH21YoVasQPamrPZRAYGLUfs5ROErInkrXutFFaH8o+cuzLwP5zrUSpvnbNSVXIK8okjPZxJiuzLobqhyy19JWpYETquc4x1bmH10FhAIUQdzzp0YmYmxdrsRkfkhPJlZE/0OQmNrACMz6JU7v5l57mE3GZJbjtbMJFS0XAn8pAJUWjmH0tQftL32VeTOUX17n1weNRNdwoBN67FtYr0q+fg73Z
 RhlXwp9i
 Jcqbj6MPn+/ulscvlXi1N+ZX4SIPcd0WCceQh79VbNClJE+oyB2b4OELS3xQXaFoco0XoU3wydEA8x042eCo301sqnRKHWJWlCnkzARs43+VSNLSgB6nR5pLy3ASY9A8omYFw2I/WmeMMDzk/KMl4ol4RVt2dOUoqZEibsUq7533XitjrgsxheUzEN5HwRKaSCnRXkdDRvXLPenEqD+1BJ+hbYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 12:50:25PM +0800, Hao Li wrote:
> On Thu, Jan 29, 2026 at 04:28:01PM +0100, Vlastimil Babka wrote:
> > 
> > So previously those would become kind of double
> > cached by both sheaves and cpu (partial) slabs (and thus hopefully benefited
> > more than they should) since sheaves introduction in 6.18, and now they are
> > not double cached anymore?
> > 
> 
> I've conducted new tests, and here are the details of three scenarios:
> 
>   1. Checked out commit 9d4e6ab865c4, which represents the state before the
>      introduction of the sheaves mechanism.
>   2. Tested with 6.19-rc5, which includes sheaves but does not yet apply the
>      "sheaves for all" patchset.
>   3. Applied the "sheaves for all" patchset and also included the "avoid
>      list_lock contention" patch.

Here is my testing environment information and the raw test data.

Command:

cd will-it-scale/
python3 ./runtest.py mmap2 25 process 0 0 64 128 192

Env:

CPU(s):                                  192
Thread(s) per core:                      1
Core(s) per socket:                      96
Socket(s):                               2
NUMA node(s):                            4
NUMA node0 CPU(s):                       0-47
NUMA node1 CPU(s):                       48-95
NUMA node2 CPU(s):                       96-143
NUMA node3 CPU(s):                       144-191
Memory:                                  1.5T

Raw data:

1. Checked out commit 9d4e6ab865c4, which represents the state before the
   introduction of the sheaves mechanism.

{
  "time.elapsed_time": 93.88,
  "time.elapsed_time.max": 93.88,
  "time.file_system_inputs": 2640,
  "time.file_system_outputs": 128,
  "time.involuntary_context_switches": 417738,
  "time.major_page_faults": 54,
  "time.maximum_resident_set_size": 90012,
  "time.minor_page_faults": 80569,
  "time.page_size": 4096,
  "time.percent_of_cpu_this_job_got": 5707,
  "time.system_time": 5272.97,
  "time.user_time": 85.59,
  "time.voluntary_context_switches": 2436,
  "will-it-scale.128.processes": 28445014,
  "will-it-scale.128.processes_idle": 33.89,
  "will-it-scale.192.processes": 39899678,
  "will-it-scale.192.processes_idle": 1.29,
  "will-it-scale.64.processes": 15645502,
  "will-it-scale.64.processes_idle": 66.75,
  "will-it-scale.per_process_ops": 224832,
  "will-it-scale.time.elapsed_time": 93.88,
  "will-it-scale.time.elapsed_time.max": 93.88,
  "will-it-scale.time.file_system_inputs": 2640,
  "will-it-scale.time.file_system_outputs": 128,
  "will-it-scale.time.involuntary_context_switches": 417738,
  "will-it-scale.time.major_page_faults": 54,
  "will-it-scale.time.maximum_resident_set_size": 90012,
  "will-it-scale.time.minor_page_faults": 80569,
  "will-it-scale.time.page_size": 4096,
  "will-it-scale.time.percent_of_cpu_this_job_got": 5707,
  "will-it-scale.time.system_time": 5272.97,
  "will-it-scale.time.user_time": 85.59,
  "will-it-scale.time.voluntary_context_switches": 2436,
  "will-it-scale.workload": 83990194
}

2. Tested with 6.19-rc5, which includes sheaves but does not yet apply the
   "sheaves for all" patchset.

{
  "time.elapsed_time": 93.86000000000001,
  "time.elapsed_time.max": 93.86000000000001,
  "time.file_system_inputs": 1952,
  "time.file_system_outputs": 160,
  "time.involuntary_context_switches": 766225,
  "time.major_page_faults": 50.666666666666664,
  "time.maximum_resident_set_size": 90012,
  "time.minor_page_faults": 80635,
  "time.page_size": 4096,
  "time.percent_of_cpu_this_job_got": 5738,
  "time.system_time": 5251.88,
  "time.user_time": 134.57666666666665,
  "time.voluntary_context_switches": 2539,
  "will-it-scale.128.processes": 38223543.333333336,
  "will-it-scale.128.processes_idle": 33.833333333333336,
  "will-it-scale.192.processes": 54039039,
  "will-it-scale.192.processes_idle": 1.26,
  "will-it-scale.64.processes": 20579207.666666668,
  "will-it-scale.64.processes_idle": 66.74333333333334,
  "will-it-scale.per_process_ops": 300541,
  "will-it-scale.time.elapsed_time": 93.86000000000001,
  "will-it-scale.time.elapsed_time.max": 93.86000000000001,
  "will-it-scale.time.file_system_inputs": 1952,
  "will-it-scale.time.file_system_outputs": 160,
  "will-it-scale.time.involuntary_context_switches": 766225,
  "will-it-scale.time.major_page_faults": 50.666666666666664,
  "will-it-scale.time.maximum_resident_set_size": 90012,
  "will-it-scale.time.minor_page_faults": 80635,
  "will-it-scale.time.page_size": 4096,
  "will-it-scale.time.percent_of_cpu_this_job_got": 5738,
  "will-it-scale.time.system_time": 5251.88,
  "will-it-scale.time.user_time": 134.57666666666665,
  "will-it-scale.time.voluntary_context_switches": 2539,
  "will-it-scale.workload": 112841790
}

3. Applied the "sheaves for all" patchset and also included the "avoid
   list_lock contention" patch.

{
  "time.elapsed_time": 93.86666666666667,
  "time.elapsed_time.max": 93.86666666666667,
  "time.file_system_inputs": 1800,
  "time.file_system_outputs": 149.33333333333334,
  "time.involuntary_context_switches": 421120,
  "time.major_page_faults": 37,
  "time.maximum_resident_set_size": 90016,
  "time.minor_page_faults": 80645,
  "time.page_size": 4096,
  "time.percent_of_cpu_this_job_got": 5714.666666666667,
  "time.system_time": 5256.176666666667,
  "time.user_time": 108.88333333333333,
  "time.voluntary_context_switches": 2513,
  "will-it-scale.128.processes": 28067051.333333332,
  "will-it-scale.128.processes_idle": 33.82,
  "will-it-scale.192.processes": 38232965.666666664,
  "will-it-scale.192.processes_idle": 1.2733333333333334,
  "will-it-scale.64.processes": 15464041.333333334,
  "will-it-scale.64.processes_idle": 66.76333333333334,
  "will-it-scale.per_process_ops": 220009.33333333334,
  "will-it-scale.time.elapsed_time": 93.86666666666667,
  "will-it-scale.time.elapsed_time.max": 93.86666666666667,
  "will-it-scale.time.file_system_inputs": 1800,
  "will-it-scale.time.file_system_outputs": 149.33333333333334,
  "will-it-scale.time.involuntary_context_switches": 421120,
  "will-it-scale.time.major_page_faults": 37,
  "will-it-scale.time.maximum_resident_set_size": 90016,
  "will-it-scale.time.minor_page_faults": 80645,
  "will-it-scale.time.page_size": 4096,
  "will-it-scale.time.percent_of_cpu_this_job_got": 5714.666666666667,
  "will-it-scale.time.system_time": 5256.176666666667,
  "will-it-scale.time.user_time": 108.88333333333333,
  "will-it-scale.time.voluntary_context_switches": 2513,
  "will-it-scale.workload": 81764058.33333333
}

> 
> 
> Results:
> 
> For scenario 2 (with sheaves but without "sheaves for all"), there is a
> noticeable performance improvement compared to scenario 1:
> 
> will-it-scale.128.processes +34.3%
> will-it-scale.192.processes +35.4%
> will-it-scale.64.processes +31.5%
> will-it-scale.per_process_ops +33.7%
> 
> For scenario 3 (after applying "sheaves for all"), performance slightly
> regressed compared to scenario 1:
> 
> will-it-scale.128.processes -1.3%
> will-it-scale.192.processes -4.2%
> will-it-scale.64.processes -1.2%
> will-it-scale.per_process_ops -2.1%
> 
> Analysis:
> 
> So when the sheaf size for maple nodes is set to 32 by default, the performance
> of fully adopting the sheaves mechanism roughly matches the performance of the
> previous approach that relied solely on the percpu slab partial list.
> 
> The performance regression observed with the "sheaves for all" patchset can
> actually be explained as follows: moving from scenario 1 to scenario 2
> introduces an additional cache layer, which boosts performance temporarily.
> When moving from scenario 2 to scenario 3, this additional cache layer is
> removed, then performance reverted to its original level.
> 
> So I think the performance of the percpu partial list and the sheaves mechanism
> is roughly the same, which is consistent with our expectations.
> 
> -- 
> Thanks,
> Hao

