Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E539C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 04:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD80A6B00D1; Sun,  4 Jan 2026 23:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFB76B00D8; Sun,  4 Jan 2026 23:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5986B00D9; Sun,  4 Jan 2026 23:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2A06B00D1
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 23:52:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 169E81A1F61
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:52:16 +0000 (UTC)
X-FDA: 84296688672.20.52E57C7
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DDA5A0011
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:52:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c8ioliHE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767588734; a=rsa-sha256;
	cv=none;
	b=CfcNgRsjx6OI2tG2DcWr9xqxQtBD0w1bLQKrYi9PH6LHSQnRiwNb2DIG2Vkunk/YvzlUu9
	ephNiW4/m8gi+wOf6oIY+KjS1VVwprMIYvNstCJoInn51g1iPI66692B3lpapMq3hNUhkI
	jBw2wf+Z+l0F5e5Lo5naggikUFd13sk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c8ioliHE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767588734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEeY/rnS8rSB2Dg6HKwl5ETnj7+qifS9o7TBnlznks0=;
	b=6TWVPBGTWuzLxJyVLVJy8VpiIfa2wP7qKeFSl4UTeDR4Rp3AjYeKxdUDgAI8Imx5h10LZA
	10Y76jRaxQ52MkEFFN0Fs4izBRF/tdp6hdfGiyrz/QwxeR9W+61SzK/lAQLvfkElbtoFO6
	7CaVikvzmjdZ3LZ2OqV019HBQ34BfvU=
Date: Sun, 4 Jan 2026 20:51:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767588731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cEeY/rnS8rSB2Dg6HKwl5ETnj7+qifS9o7TBnlznks0=;
	b=c8ioliHEZHw1dAr6H7QXCal+ZW7hMAOBHbiFI/52p5F1EdA3y+c03Yr8L+QpwwChDTRHqM
	pudzb305btEREzNeMNF+9m+2aWP+xEboRHheoVR0muR1tmLejRdyfqImSATfwyq1sVjYGE
	2jChyixsWQeMCRYnSimL3Jq3aGWDNdQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2DDA5A0011
X-Rspamd-Server: rspam03
X-Stat-Signature: scnapssa95snq5it1bm5yh5byqojirbr
X-Rspam-User: 
X-HE-Tag: 1767588733-949640
X-HE-Meta: U2FsdGVkX1+xWyZdDNEz47+pokAMpz9gvP+dMFlstrcMBH5uRplN/AlHWhltUy67YJT7UMcIGoJLFS5/LMXE0GaL/jo6d/0TuMuPWQha1HlgtZBtYuuvjNszBiUfdI2dygLMaOAmBV3Njs4hUDhD7KyEl9op2bswPg+BYyS0P1DBgbi+UQoSj4MzyNfHgho1mFbHII80WFIRTKWJrDOHTXpFqpZsLqf+oT1FhAhG4Jcg6mkMKkiOEUZQuLyL3bw8yW71alrL0fQxwBMQvbDyYscNqzMR0xP6b/ubhEVG90Q8sI9PyG99zidFzR08rUoC6r0LNY5wAIYGfGBzQKTk687P33rZPfAG5qu4BtuITN+yu+JZjTiko8oZWQkwXO3iXEDWMitIbUxODmQFRJvtuCzPHGSv/95N2FJTMoaV3SSmgXXvqScb4s/pZztst6/Q6xZg2hFrxqw7DuyTl+FCx8GWCIkLgoZR8UKbhk6SzglK9ZxOHVIl9oTL9kFxerqiI1PTP62+eeeN3ijvSZp9uBt+FJU6vRlpPz8HyohwWOuPTwn0yAXdzp8AO/Qk20gaCFaiV+8Eb8lW/ZPOW/9xA6c+qQ2JB3g264XGDOfID/U+pYaKJH+MhgssWNeb6KEBeF9qHym0ng6Pfoz3gGiJYLllsItmFZJcZs9lA4f9XPZtoGcUsjsOoxe+FFIZOmAdxfRBLDSVMn4+hXdtC6oYQRJMAkdGrgmHOugTt672W5loSZtre0MkFTMm5QwQ6w0J8RaAleZZsjz5gnbZfHqxx/xVemxbI1nzVfcsI/1+YmNOm2gevJ++Ly9zmbbo+9e7RAayY15A0QOpSMeiGSuV5B33XD5oTUcBoWt4KZe+5mvqsjVXkZwGDSBR1j/Xj2G9mcYHVNnRklGxMJRBVbVYOH+VTbl/632MqMpPEXUut/4bmNgrTwp6Vpd/ZULn+6RWOl/MqQohFhPYGnaJDYu
 IGKRmT4K
 0viVJmRcoJcZ4LCXnyZ5k4vdPnfrhICcI9X/ZpcqPJQ+/OSzkNi4/MhrrA8u6IZxvBXwjrJJoK26UB6cDr/8h+dyPQ/V2+a+XjZ5h6yktWm8FAtDKfypjXDOvyDGco+r3AQ6Wz8LbPjuBIoJrrKIw6q/opoY3nCL/bz4y7xuh4iT344e7CVh+E/dAErMY2pMBOn6QzcUVoJHP5III/GekMURpM0I6DBugrlxuVO1sWjj0NV/ZIpd5v4mTEd3dOEmvdybBTftRgLf21OMdjplObMUowA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiayuan,

Sorry for late reply due to holidays/break. I will still be slow to
respond this week but will be fully back after one more week. Anyways,
let me respond below.

On Tue, Dec 23, 2025 at 08:22:43AM +0000, Jiayuan Chen wrote:
> December 23, 2025 at 14:11, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.butt@linux.dev?to=%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E > wrote:
> 
> 
> > 
> > On Tue, Dec 23, 2025 at 01:42:37AM +0000, Jiayuan Chen wrote:
> > 
> > > 
> > > December 23, 2025 at 05:15, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.butt@linux.dev?to=%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E > wrote:
> > > 
> > [...]
> > 
> > > 
> > > > 
> > >  I don't think kswapd is an issue here. The system is out of memory and
> > >  most of the memory is unreclaimable. Either change the workload to use
> > >  less memory or enable swap (or zswap) to have more reclaimable memory.
> > >  
> > >  
> > >  Hi,
> > >  Thanks for looking into this.
> > >  
> > >  Sorry, I didn't describe the scenario clearly enough in the original patch. Let me clarify:
> > >  
> > >  This is a multi-NUMA system where the memory pressure is not global but node-local. The key observation is:
> > >  
> > >  Node 0: Under memory pressure, most memory is anonymous (unreclaimable without swap)
> > >  Node 1: Has plenty of reclaimable memory (~60GB file cache out of 125GB total)
> > > 
> > Thanks and now the situation is much more clear. IIUC you are running
> > multiple workloads (pods) on the system. How is the memcg limits
> > configured for these workloads. You mentioned memory.high, what about
> 
> Thanks for the questions. We have pods configured with memory.high and pods configured with memory.max.
> 
> Actually, memory.max itself causes heavy I/O issues for us, because it keeps trying to reclaim hot
> pages within the cgroup aggressively without killing the process. 
> 
> So we configured some pods with memory.high instead, since it performs reclaim in resume_user_mode_work,
> which somewhat throttles the memory allocation of user processes.
> 
> > memory.max? Also are you using cpusets to limit the pods to individual
> > nodes (cpu & memory) or they can run on any node?
> 
> Yes, we have cpusets(only cpuset.cpus not cpuset.mems) configured for our cgroups, binding
> them to specific NUMA nodes. But I don't think this is directly related to the issue - the
> problem can occur with or without cpusets. Even without cpusets.cpus, the kernel prefers
> to allocate memory from the node where the process is running, so if a process happens to
> run on a CPU belonging to Node 0, the behavior would be similar.

Are you limiting (using cpuset.cpus) the workloads to single respective
nodes or the individual workloads can still run on multiple nodes? For
example do you have a workload which can run on both (or more) nodes?

> 
> 
> > 
> > Overall I still think it is unbalanced numa nodes in terms of memory and
> > may for cpu as well. Anyways let's talk about kswapd.
> > > 
> > > Node 0's kswapd runs continuously but cannot reclaim anything
> > >  Direct reclaim succeeds by reclaiming from Node 1
> > >  Direct reclaim resets kswapd_failures,
> > > 
> > So successful reclaim on one node does not reset kswapd_failures on
> > other node. The kernel reclaims each node one by one, so if Node 0
> > direct reclaim was successfull only then kernel allows to reset the
> > kswapd_failures of Node 0 to be reset.
> 
> Let me dig deeper into this.
> 
> When either memory.max or memory.high is reached, direct reclaim is
> triggered. The memory being reclaimed depends on the CPU where the
> process is running.
> 
> When the problem occurred, we had workloads continuously hitting 
> memory.max and workloads continuously hitting memory.high:
> 
> reclaim_high    ->   -> try_to_free_mem_cgroup_pages
>                    ^      do_try_to_free_pages(zone of current node)
>                    |         shrink_zones()
> try_charge_memcg  -              shrink_node()
>                                      kswapd_failures = 0
> 
> Although the pages are hot, if we scan aggressively enough, they will eventually
> be reclaimed, and then kswapd_failures gets reset to 0 - because even reclaiming
> a single page resets kswapd_failures to 0.
> 
> The end result is that we most workloads, which didn't even hit their high
> or max limits, experiencing continuous refaults, causing heavy I/O.
> 

So, the decision to reset kswapd_failures on memcg reclaim can be
re-evaluated but I think that is not the root cause here. The
kswapd_failures mechanism is for situations where kswapd is unable to
reclaim and then punting on the direct reclaimers but in your situation
the workloads are not numa memory bound and thus there really is not any
numa level direct reclaimers. Also the lack of reclaimable memory is
making the situation worse.


> Thanks.
> 
> > > 
> > > preventing Node 0's kswapd from stopping
> > >  The few file pages on Node 0 are hot and keep refaulting, causing heavy I/O
> > > 
> > Have you tried numa balancing? Though I think it would be better to
> > schedule upfront in a way that one node is not overcommitted but numa
> > balancing provides a dynamic way to adjust the load on each node.
> 
> Yes, we have tried it. Actually, I submitted a patch about a month ago to improve
> its observability:
> https://lore.kernel.org/all/20251124153331.465306a2@gandalf.local.home/
> (though only Steven replied, a bit awkward :( ).
> 
> We found that the default settings didn't work well for our workloads. When we tried
> to increase scan_size to make it more aggressive, we noticed the system load started
> to increase. So we haven't fully adopted it yet.
> 

I feel the numa balancing will not help as well as or it might make it
worse as the workloads may have allocated some memory on the other node
which numa balancing might try to move to the node which is already
under pressure.

Let me say what I think is the issue. You have the situation where node
0 is overcommitted and is mostly filled with unreclaimable memory. The
workloads running on node 0 have their workingset continuously getting
reclaimed due to node 0 being OOM.

I think the simplest solution for you is to enable swap to have more
reclaimable memory on the system. Hopefully you will have workingset of
the workloads fully in memory on each node.

You can try to change application/workload to be more numa aware and
balance their anon memory on the given nodes but I think that would much
more involved and error prone.

Shakeel

