Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943CC606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=AXAfi8MA
Received: by kanga.kvack.org (Postfix)
	id BA5B66B05B0; Fri,  6 Nov 2026 01:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B566C6B05B1; Fri,  6 Nov 2026 01:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C076B05B4; Fri,  6 Nov 2026 01:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 849406B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:30:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 190B8A02A3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:30:51 +0000 (UTC)
X-FDA: 85403721102.19.045644C
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F79E100002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:30:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AXAfi8MA;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793946649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mX+GdBvA4yT9OKqPBs6xrJW5OhdpJfdnYKs9cQ6hIug=;
	b=CyqdZbkQIh7ezAloCM34U/p0bvL+7LxAk/zF0Stpzlb0pJ1bTXTy6d9ZlSPhMzRjn4Z6Kp
	2k2+Q7NmrrlhD3aV+R7QM/xOCRezhrl+bj7Fbm/Gyijlnj9TGhN4vFduX6CQxmmqaq0GRy
	OiPVGbbAFPJfa7OhllN4g+9Jn/lnVMg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AXAfi8MA;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793946649;
	b=AoAMIjnFbJBjNHhumHhOcg/Emt7tj98MVD86jRPBmsfRMCPtcOe6MpyLP5by0TksDKnySG
	rlC/et+bN+zfh5T5owPgRIQOQI3zubZwYSi7h24PkUV0R/1mZKzWl9b8ikOT2cDK4r5dEA
	IEt46Og0evRv3IcKp2mHDPQ7sMJTay0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793946642; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=mX+GdBvA4yT9OKqPBs6xrJW5OhdpJfdnYKs9cQ6hIug=;
 b=AXAfi8MAeYMfRwp75m4q7uKGottwQNMcwq51XUps/ybwkQjrm0EsryCXwTySAOMXlWJqXz
 ttH2Ue6oEewi6z/F34ayHQ06ZZKWVQj0Ou165thrcsKC+6MswJt7txK1Z8rWytXRTQfAHd
 S8yinosH+3i0QlrxbMXxIIqGqXXeHYfyW6M/XcqNif7emc8buI0VS0vP5Cuyw+udWwpj/N
 g9JSUdM1CXIFEeKyR3rtugWDT+YELigoItLWGxxeARHrouXGcfYKQ3oQB6YTFY3AyuGR+/
 DUeAORED5feXdGmRTxCdmvawtkIMn3gPbK3O746lGN+8gXtoPY+zcQwByjt6bg==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
Message-Id: <67fcd8db-269d-43f1-aea2-8c41165747d0@bytedance.com>
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
To: "Gregory Price" <gourry@gourry.net>
Date: Fri, 6 Nov 2026 14:30:17 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aurTz8SiB-nQ22lJ@gourry-fedora-PF4VCD3F>
References: <20261103122816.48037-1-lizhe.67@bytedance.com> <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org> <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com> <aurTz8SiB-nQ22lJ@gourry-fedora-PF4VCD3F>
X-Lms-Return-Path: <lba+26aed740f+529295+kvack.org+lizhe.67@bytedance.com>
Cc: "Tejun Heo" <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<ljs@kernel.org>, <liam@infradead.org>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<bpf@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: u9y19kxd9ap4e6heyrnj7izu65f3e3qu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6F79E100002
X-HE-Tag: 1793946648-257012
X-HE-Meta: U2FsdGVkX1+VGqRGziq9q6QIMwHYvkqQxRtRGt94r+pvqOFhxTQRlUOmBBOARJKQWgr02Ig6SejblGDaZEQEBPIrZVyzYtdzgdES6tzr1la07Xrvq/185yH02uMRGN4Es/88w5ibZn4GCuI0QZ49KXmkPK9uWBSREOLKxbH7KGFZpJ4iIFdsELquoTahEvShviDgfRsmRUOkECEM0N1xmW/wqi/EaEk3uwD0nTuTaKOzh/hvMmQw73ndYPpXLy/+FUxemH5UcOpnupykstSDQR+2CAYoC010/6H2qPg0TbKCdj8GC3CNqfeYIhl1YHo2E3tY7kMytYSbGsBwrAOjGPaGpjIV6G5C24iWq0yBinqblYn1r96usA/1MjEWs1siKyzXv3SztORHB5wcYcW17H6PtDvwFIx3M6PBw7bMhvht3RUb/2l7p+Vcx4jnIxzxHAol0MTuV0+zt/CRPhN8c3TBXpfkQxfPF0K8ixnZONm/8iOwlrva+UmDSq/VvhopQBlpHhso4vpiMbQlCxJn1deBr8KVhAxzi7qXNRLPwMgIpD7OSiObP3YBhU1soDNw8FeZi7+98iw00BIMRusgkhk/Wr4NYstXphCQmR5RdUz76ahoLbfB4+YIIfL5Y4D845gx4CxO94Jbn3p8Fz78r0YQJtpemkPvG0n5QuyPQhgddHQevEWN6YBDKwS8WJffCbMpszd/2f/a5M0nwLh2uYhalaKlXlVCApak14ShY9hmYo49JgyayOUuQ7u7KlDxafBmKmxtnbE5sbnlaZodXDAVtvoqK1lxPA0uC3jK+sC0YmJcaSEX0YGQtMtENFRz+7BXk1SNetnpaFfljZ0PFl++GR+0IWbWBRvaanHq0NEk1DZCjZdxbh4p0VVnPYpu4RFGLpjI43Ey79q+ppfBtujuCKDgV56IDQd5zn5zKK1BFvFgmaDprjVCDeoyYJ9befBu/PAPP3ULf0y1+2X
 fWBrsENO
 qw28RllnXBTbH6MApxW/2dI7qElVHdHiXdDHE3s8G5hbUh119OqVN9NTNc3Cy2yij4qQ2spgLoUGmm0Rv7rsTzvNXzzNw9zds1/58Pupn8BmvJd+tcOgUORHrC2sjEIRtNzJIZZ8KxOLe1iD+G+iR1YGsaR9Gzd8WQ+8V3lg1ybVg7bDLVZS9oSu8+tG5+chHeABwbtqE8ApovCyvZ1pAg1NxO4bAjoFWcvcWNRK3P7Q1y69maryxI25Eh4MXEhj3ThaAsiq7Yl08Muc8lGxGppEL22M7pLgz6pqgZ3ZVDo0gkalWMYpQMJgIWMl5p8nHhYI7USVjhrWDtZW7uelYLuAtNrVnSmYYf2n09VXZAL4zbWKwyxdszqegKwfGObhynpMghyJJZqAlp/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 2:42 PM, Gregory Price wrote:
> On Wed, Nov 04, 2026 at 10:44:46AM +0800, Li Zhe wrote:
>> Does that distinction make the cgroup-scoped override acceptable? If not,
>> could you suggest a better way to support this kind of administrative
>> weight override without adding new mempolicy syscalls?
>>
> I'm a little confused why cgroup-anything is needed here when you could
> just override the weight table / interleave functions.
>
> I don't particularly like the idea of bpf hooks for a single mempolicy
> mode as opposed to something more generally useful - and I question
> how useful task-mempolicies are in general for tiered memory systems
> (they also affect kernel allocation placement, which is not great).
>
> You have many patch proposals recently trying to adjust the mempolicy
> components and I think it might be helpful if we could chat a bit
> about what big problems you're actually trying to solve.
>
> I get that you want better control over task/task-groups, i think that
> can be useful - but I also know that demotion immediately mucks all
> this placement logic up (and we can't check vma / task policies at
> demotion time) so I question how realisitic the value of these
> extensions will be.


Thanks for the feedback.

Our target environment is a class of machines with both DRAM and CXL
memory. On these machines, different services run together in different
cgroups. For us, CXL memory has two main values: it increases the total
memory capacity of the machine, and it lowers the memory cost for
workloads that need a large resident memory footprint. DRAM is the
faster but also more expensive tier, so the practical question becomes:
how much DRAM does each workload really need, and how much of the rest
can be placed on CXL memory?

 From our earlier testing, different workloads have different suitable
DRAM/CXL ratios. By "suitable", I do not mean maintaining a fixed ratio
for its own sake. I mean that, after using some CXL memory, the
workload's important metrics, such as throughput, average latency, tail
latency, or other SLOs, are still within an acceptable range.

So the core problem I am trying to solve is: on a mixed DRAM/CXL memory
machine, each workload in each cgroup should be able to run with its own
suitable DRAM/CXL ratio, so that it can stay near its own
performance/cost balance point.

This is why a single system-wide weighted interleave table is not enough
for our use case. Two co-located services may have completely different
suitable DRAM/CXL ratios. The cgroup is also the more natural management
unit for us, because resource isolation, charging, SLO monitoring, and
userspace control logic are all organized by cgroup, not by individual
task.

I understand that Joshua's approach can solve part of this problem.
However, based on the current discussion, that direction still seems to
need more discussion before it can move forward upstream.

Of course, initial allocation is not the whole story. Demotion and
promotion will change the actual page placement over time, so I do not
expect weighted interleave alone to provide long-term placement control.
For long-term adjustment, using a userspace controller with
memory.reclaim is a more natural and convenient way to adjust placement
over time.

The value of weighted interleave here is in the initial allocation
phase. First, for bandwidth-sensitive workloads, it allows DRAM and CXL
bandwidth to be used together from startup, instead of concentrating
allocations on one tier first and relying on later reclaim or demotion to
reshape the distribution. Second, it gives the container scheduler a
more deterministic view of memory capacity, so the scheduler can place
workloads based on the total memory capacity provided by both DRAM and
CXL, rather than treating only DRAM as the schedulable capacity.

In the long term, we want to maintain the target ratio through a dynamic
control loop. Memory tiering promotes hot pages back to DRAM. A
userspace controller observes each cgroup's per-tier memory footprint
and workload metrics, decides whether the current ratio has deviated
from the target, and then uses memory.reclaim to apply reclaim pressure
to the source tier that should be relieved [1].

The target ratio is not meant to be a strict hard limit. The userspace
controller can adjust the policy based on workload metrics: when cost is
the priority, it can keep more cold memory on CXL; when performance or
SLO pressure becomes high, it can temporarily relax the ratio and allow
the workload to use more DRAM. In other words, I am not trying to make
demotion reinterpret task policy or VMA policy. I am trying to adjust
the actual resident distribution at cgroup granularity through a
userspace feedback loop.

This is also the background for my other patchsets. The memory.reclaim
source selector is intended to give the userspace controller a more
precise actuator [1]. In our testing, this is an important capability for
building the feedback loop.

The sched/numa memory tiering patchset came from issues we found while
testing this model [2]. Its goal is to make tiering promotion behavior
adapt better to different scenarios, and to avoid tiering-only feedback
being misused by the normal AutoNUMA task placement heuristic.

I am not attached to the exact API shape in this RFC. If the
per-cgroup weighted interleave BPF kfuncs are too narrow, or if you
think there is a more general control plane, or a better control
granularity, I am happy to adjust the direction.

[1] 
https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/
[2] 
https://lore.kernel.org/all/20261028041253.74839-1-lizhe.67@bytedance.com/

Thanks,
Zhe

>
> ~Gregory

