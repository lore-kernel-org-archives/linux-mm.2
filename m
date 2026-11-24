Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516DD60A2609
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=mguqZbqG
Received: by kanga.kvack.org (Postfix)
	id 497716B0658; Tue, 24 Nov 2026 04:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F206B0659; Tue, 24 Nov 2026 04:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384E56B065A; Tue, 24 Nov 2026 04:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF356B0658
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:31:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86B4EC0A16
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:31:06 +0000 (UTC)
X-FDA: 85469493732.24.361075D
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf10.hostedemail.com (Postfix) with ESMTP id BA543C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:31:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mguqZbqG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795512664;
	b=1IIBzzcbrKufLgL+h9LBwrRiTVmVSeGRUqTxkxUcHVVj9y8/EadxUfyFfMR2WMVlmf1hNZ
	uLdORP+HLT6BQIG9xvwvcH06ZcHdCFX19Tt9F9bYYEW+D1aBMpAH3cpGk6L28wyUDSkDR/
	BO1eS72kfTiKhPUIQuKK31qO16rd+jQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795512664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6SizlEUlUcMUJkeRm0jMCJuR259t157CCu3O60oQoY=;
	b=IHVsQ2EN5zT450RtZwDO2TqUG3gazJOwSVFM6l7R0Rhg1YsYaTIMK8utpIZ40gc0wrJySk
	sopc1luttJ3eA3QlQZWiD3ldcXvDrlB4sfg6qV3g+6qgIQRpBsFKmK/j+1G4k3ar5bmdIk
	XayKQGhY7SsVHeAr5nrVCoie29UB8f0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mguqZbqG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795512657; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=b6SizlEUlUcMUJkeRm0jMCJuR259t157CCu3O60oQoY=;
 b=mguqZbqGLnox+yrja55To0uFWlowL7tgMYfbr9BJiZ3PxFs+RT7EICLhchY79nmY4ja2lp
 SjMUfsULy/ZbBCFQnGvP1BvIzWY4izid3VQDXTnnWWUlP7tY03Q55DjIZej4VDLT+NOx9m
 4NEPtQOz9kVWiyMZ1Pi7gKf11YjM7f2C+Mih7SfU0pnM1cI9dDmhyXBBtGKYSbAclv3U+v
 bYxJVZoxwGMLqlcifrQT8g2+LTes69681ak1Ihw4evsSc1cZJ+6M3RGuLxkHz7uvZIk45m
 OUtXWEAa3BNTxkiN/4c2BMMwcQ6XBzZnkXWliW81xWMLSPw3UJgRJdOJpJqdEw==
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] mm: add source selector to memory.reclaim
Message-Id: <d7b50e9b-1f34-459a-9902-7355bce76e79@bytedance.com>
References: <20261116110459.11048-1-lizhe.67@bytedance.com> <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>
Date: Tue, 24 Nov 2026 17:30:33 +0800
User-Agent: Mozilla Thunderbird
In-Reply-To: <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26b05594f+351603+kvack.org+lizhe.67@bytedance.com>
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<hannes@cmpxchg.org>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <rakie.kim@sk.com>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Stat-Signature: 84cm8dcmr8mprt5rmyrbuzyzz5e1q6up
X-Rspamd-Queue-Id: BA543C0003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795512663-814106
X-HE-Meta: U2FsdGVkX18o8aHMmoZzqPMpanAAGlLBouetDqZsCFrF39FiVofi2aWEGZ9YH0VXlC5tPaSZDzcZi6422Dy/MQ/9rC4TCg5qEPuC+52VfGI4N3r5fkD3dxB0Ze7vRA14iTuR1ufy5hCL64VmAI75YtRrg2y+oRfsrP9rbZHu+/CU66tr/cIoAXhD5VpVG6T5veJ2EZisKP/lo5wstB5a3EDCd02ySjisBCjtTEy42urfv05nGHuZn70Ve2n2wIM3vBiDFPfAw0mVWDcNnBE6WnW1W1HH2n+QnwiKVdJlpFGmwCajYXNG7SHM46dD97lb2F0fEqOoKafNrS08SwQR/0tnZUj9XwOvojvlnILmPSitMmahfM614aLnLq5/9Ak+HcuHIrGy1UrZOaj598gyhZwUQwwts+1sL6FSiurQSWu7RdJ9mD09pJT+YWd0XbwPkaHSIkTa0K6HzQTSmyhfRIIQQZzMDjJgDa8erTB+ZrdxGReRXFrlLtZ2ngDYmlIyRUY3Y3X6/HHBs9G8jFE1DHH1tUrOzzCRXjrqN0FCe7EsWmRloLVGcAgRRXatnhqoLhivkTG3Q4Lt3HY2WFOX7oOnjIPg//MrB6OVZ8u6wHCUAvPhY/50694/AubWrFrjyUXnQjbMMefa8LoZKey0jsnIUYR7qW6vHP/ALFiht5YiXPFdn2spw/XegEpCel5fhsrzXifS7hJLY4SASx9LDOfLhJ2MIu9OiwQptJIrw+NwHtnwo0yvPmnC1eevbZNgM97Z0mGi5n1mETIfb0X/LVLvsBzfH4NvPn0bv89qm/+4+ns4lUKpcOKd8f+tggx8oUzUyKVHT/EN82vDC8u882IpMUQ+k/LJhTPPucmkqWtSN8CAPramImdYuA+veAbSdpDxYayGATBOP27L2X+XzrUzrYXTGogJzEdOJ7g/OV7r7AFk4syf/E6PFEISGZcDnSgqQxezCiy5roet/LI
 NPH+6fsr
 K8FlBaiD0weRjCGATC42AZM0w8wwdonyO/gOy8D+kEP1qBdL0AzROx0TQFef85GDPXG3T3SqnZuHyAdewdN7X9+L9P7Iw+X0zihxlvEq2PCKaTKOf2JDoeMM6gCuNARqay5fTscxNetG8ZePkRQlFy0qy+H/jx5t4uT+eHlj3CHuUQY3RxA3Qxka0QnPg15AglBQCMenbJMPmG+V2Whs3sWgDlGZcgrdtyG0bjEaMn6kCwzVG5Sd2Fmxe+c4Vq/2KZBB06R5/8gjGpmXf2QQQAzoPMhWRAWzbyZsW41TrAcM7pRc0daX6YreF1bw/lSKJe0nTBHQ4nb9g3ffus10proKDQ5CzURkpf8qFg8bjgtBJaEIOofn+EFIIxCT7l7v3fRonrk6IcbWFsrTbG9Z1RqQQ6lsbUiYIg0aGEERZadx4e/dQh/azml50zykdSfWdsT5GgeXl5086AuPsI7sS53UWmmNGWRWfz/0Onty+gKKrCBUethYqP5TJ/CN3NmHF0cullZy2EwxOu9rX4E824/Pq7U9V1MpBuXsNEdfg8ppc6+bcWqQGvUYBf+0sdqxd0FprEeLYs57qDMYCiiveKU432IsM9Xj5Zx/P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 3:29 AM, Joshua Hahn wrote:
> On Mon, Nov 16, 2026 at 07:04:59PM +0800, Li Zhe wrote:
>> memory.reclaim can apply proactive reclaim to a memcg, but it cannot
>> target source nodes the way global node reclaim can. Proactive memcg
>> reclaim follows a fast-to-slow fallback order, which attempts demotion
>> before reclaiming from slower tiers.
>>
>> As a result, a memcg controller cannot decide whether reclaim should
>> start from DRAM or from a slower tier. For a cgroup that is close to OOM
>> and needs charge reduction, or for a controller trying to shape a
>> workload's DRAM/CXL resident distribution, the default policy may spend
>> reclaim effort on the wrong source tier.
>>
>> Add source=3Dnodes:<nodelist> to memory.reclaim. The selector only choos=
es
>> the resident source nodes where the existing memcg reclaim path applies
>> pressure. It does not select demotion targets, force demotion, force
>> eviction, promote pages, or change completion accounting. Leaving source
>> unspecified preserves existing behavior.
> Hi Zhe,
>
> Thanks for the patch and sorry that it took so long to reply.
> I've actually spent a lot of time thinking about this commit to see if
> it can be used to establish per-memcg-tier residency limits on machines
> running multiple workloads via memcgs.


Hi Joshua,

Thanks for the careful review and for thinking through this use case.

I am also interested in using this for per-memcg-tier residency control.
My current understanding is that source=3Dnodes can support soft,
feedback-driven per-memcg-tier residency limit control, not strict
kernel-enforced per-tier limits. Strict limits would need stronger kernel
enforcement or reservation, while this patch only exposes a way to choose
the source of reclaim pressure. I think such soft limits are still useful
for many practical placement controllers.

>
> So you could have a daemon running, checking the per-tier usage for a
> cgroup, and creating pressure to evict pages downward from that cgroup
> specifically.


Yes, this is one of the intended use cases.

The contract I have in mind is intentionally narrow: source=3Dnodes says
where reclaim pressure is applied. It does not say where reclaimed folios
must go, reserve target-tier space, or turn memory.reclaim into a
placement transaction.

>
> So if a cgroup is using 10G more node0 (DRAM) than it should be, you can
> write "echo 10G source=3Dnodes:0" > memory.reclaim to try and free up tha=
t
> space. I'm running some experiments locally and really thinking through
> this to see what that would lead to.
>
> Anyways, to me the only concern that I have is what happens when that
> reclaim fails. Let's say that you have a situation where CXL is
> completely full, preventing future demtions. At the same time, we have
> a memcg that is using too much DRAM, so we try to reclaim from the
> DRAM node and pressure downwards.
>
> The thing is, I think proactive reclaim doesn't allow swapouts on tiered
> systems.


Thanks for clarifying this in the follow-up. If I understand correctly,
this is about top-tier proactive reclaim: when demotion is possible but
fails, proactive reclaim does not retry those folios for direct
reclaim/swapout. That is different from proactive reclaim on a lower or
terminal tier, where there is no further demotion target and reclaim can
still free pages and swap anon when swap is available.

>
> So what would happen is, you would (1) fail demotions, and then (2) fail
> to swap out, which means the pages have nowhere to go. And repeatedly
> running the same command over and over again will not lead to any
> progress at all.


Right. I think that is a valid failure mode of the existing proactive
reclaim policy. If top-tier reclaim makes no progress because the
demotion target is full, that is feedback to userspace: reclaim
lower-tier memory first. This means the daemon needs to consider
available or reclaimable headroom across tiers, not only the overage on
one source node.

For example, if there is reclaimable memory on the CXL tier:

 =C2=A0 echo "10G source=3Dnodes:<cxl_node>" > memory.reclaim=C2=A0 # creat=
e room
 =C2=A0 echo "10G source=3Dnodes:<dram_node>" > memory.reclaim # pressure D=
RAM

The first request creates room on the lower tier. If that succeeds, the
second request has a demotion target and can make progress.

>
>> With this, userspace can build the policy it needs on top of existing
>> kernel reclaim behavior:
>>
>> 1. start reclaim from lower-tier nodes to reduce the cgroup's memory
>>     usage more directly;
>> 2. steer reclaim toward over-represented nodes to shape a workload's
>>     DRAM/CXL resident distribution; and
>> 3. reclaim from lower-tier nodes first so later top-tier reclaim has
>>     room for demotion.
>>
>> Example: nodes 0-2=3DDRAM, node3=3DCXL
>>
>>    echo 1G > memory.reclaim # progress from nodes 0-3
>>    echo "1G source=3Dnodes:3" > memory.reclaim # reclaim from CXL
>>    echo "1G source=3Dnodes:0-2" > memory.reclaim # usually demote to CXL
> And so I can see why you would have to run something like this in order
> to actually make room, moving from the bottom going up. Make space for
> the memory that's about to come in from the top.
>
> To me this makes a lot of sense, and it's something that we (Meta) has
> thought about quite extensively internally as well (from Johannes and
> Gregory, who are also CC-ed in this mail).
>
> But at the same time, this is not really an atomic operation. So memory
> usage between the two operations can change very rapidly. I wanted to
> start a conversation about this point and whether this is something that
> the commit should address. I would like to hone in on a use case and
> think about how the users should be expected to use these things first.


I agree this is not an atomic operation. I do not think this patch should
try to make a multi-step placement policy atomic inside memory.reclaim.
The existing interface is already a best-effort pressure interface:
userspace asks the kernel to reclaim some amount, observes what actually
changed, and then decides the next step.

So my expected use model is a userspace feedback loop, mainly for
reducing a cgroup's memory usage from selected source nodes and shaping
the workload's DRAM/CXL resident distribution. I am happy to keep
discussing whether this model is sufficient, and what other use cases or
limitations the interface should consider.

Thanks again for the review and for thinking through the use case.

Thanks,
Zhe

>
> Thanks a lot Zhe, and sorry again for the delayed response.
> I hope you have a great day!
> Joshua
>
>> The typed source=3D form also leaves room for future source selectors
>> without changing the ABI introduced here.
>>
>> Tested in a CXL setup with nodes 0-2 as DRAM and node 3 as CXL. A
>> userspace controller steered eight cgroups toward a 50:50 DRAM:CXL
>> resident ratio while a background workload created reclaim and demotion
>> pressure. With source=3Dnodes, all eight cgroups ended with 45%-55% of
>> their memory on DRAM. Under the same pressure, the plain memory.reclaim
>> baseline left the worst cgroup far away from the target range.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>> v2: https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedanc=
e.com/#t
>> v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedanc=
e.com/
>>
>> Changes since v2:
>> - Dropped the separate cover letter and shortened/refocused the commit
>>    message, as suggested by Joshua Hahn and Gregory Price.
>> - Added an eight-cgroup CXL test summary under background
>>    reclaim/demotion pressure, as suggested by Joshua Hahn.
>>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
>>   mm/bpf_memcontrol.c                     |  3 +-
>>   mm/internal.h                           |  3 +-
>>   mm/memcontrol-v1.c                      |  6 ++-
>>   mm/memcontrol.c                         | 11 ++++--
>>   mm/vmscan.c                             | 49 +++++++++++++++++++++++--
>>   6 files changed, 72 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/adm=
in-guide/cgroup-v2.rst
>> index 9e3c67b02ae2..992f9bdc46a1 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1458,6 +1458,7 @@ The following nested keys are defined.
>>  =20
>>   	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>   	  swappiness            Swappiness value to reclaim with
>> +	  source                Source to apply reclaim pressure to
>>   	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>  =20
>>   	Specifying a swappiness value instructs the kernel to perform
>> @@ -1468,6 +1469,16 @@ The following nested keys are defined.
>>   	The valid range for swappiness is [0-200, max], setting
>>   	swappiness=3Dmax exclusively reclaims anonymous memory.
>>  =20
>> +	Specifying a source value constrains where proactive reclaim applies
>> +	pressure. Currently only source=3Dnodes:<nodelist> is supported. For
>> +	example::
>> +
>> +	  echo "1G source=3Dnodes:0-1" > memory.reclaim
>> +
>> +	This applies proactive reclaim pressure to memory of the target cgroup
>> +	resident on nodes 0-1. It does not constrain demotion targets and does
>> +	not change memory.reclaim completion accounting.
>> +
>>     memory.peak
>>   	A read-write single value file which exists on non-root cgroups.
>>  =20
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index d8f579c28560..7d98f55a044f 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -201,7 +201,8 @@ __bpf_kfunc long bpf_proactive_reclaim(struct mem_cg=
roup *memcg,
>>   	nr_reclaimed =3D try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KE=
RNEL,
>>   						    MEMCG_RECLAIM_MAY_SWAP |
>>   						    MEMCG_RECLAIM_PROACTIVE,
>> -						    swappiness =3D=3D -1 ? NULL : &swappiness);
>> +						    swappiness =3D=3D -1 ? NULL : &swappiness,
>> +						    NULL);
>>  =20
>>   	return nr_reclaimed * PAGE_SIZE;
>>   }
>> diff --git a/mm/internal.h b/mm/internal.h
>> index e3f92883bf23..ff24a58d47e8 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_=
cgroup *memcg,
>>   					   unsigned long nr_pages,
>>   					   gfp_t gfp_mask,
>>   					   unsigned int reclaim_options,
>> -					   int *swappiness);
>> +					   int *swappiness,
>> +					   const nodemask_t *source_nodes);
>>  =20
>>   #ifdef CONFIG_NUMA
>>   extern int sysctl_min_unmapped_ratio;
>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>> index b7f286888507..74aa06fee76a 100644
>> --- a/mm/memcontrol-v1.c
>> +++ b/mm/memcontrol-v1.c
>> @@ -1464,7 +1464,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup=
 *memcg,
>>   		}
>>  =20
>>   		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
>> -				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
>> +				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
>> +				NULL, NULL)) {
>>   			ret =3D -EBUSY;
>>   			break;
>>   		}
>> @@ -1500,7 +1501,8 @@ static int mem_cgroup_force_empty(struct mem_cgrou=
p *memcg)
>>   			break;
>>  =20
>>   		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
>> -						  MEMCG_RECLAIM_MAY_SWAP, NULL))
>> +						  MEMCG_RECLAIM_MAY_SWAP,
>> +						  NULL, NULL))
>>   			nr_retries--;
>>   	}
>>  =20
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 84f4a8fd4d16..116c6853c9ba 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2444,7 +2444,7 @@ static unsigned long reclaim_high(struct mem_cgrou=
p *memcg,
>>   		nr_reclaimed +=3D try_to_free_mem_cgroup_pages(memcg, nr_pages,
>>   							gfp_mask,
>>   							MEMCG_RECLAIM_MAY_SWAP,
>> -							NULL);
>> +							NULL, NULL);
>>   		psi_memstall_leave(&pflags);
>>   	} while ((memcg =3D parent_mem_cgroup(memcg)) &&
>>   		 !mem_cgroup_is_root(memcg));
>> @@ -2774,7 +2774,8 @@ static int try_charge_memcg(struct mem_cgroup *mem=
cg, gfp_t gfp_mask,
>>  =20
>>   	psi_memstall_enter(&pflags);
>>   	nr_reclaimed =3D try_to_free_mem_cgroup_pages(mem_over_limit, nr_page=
s,
>> -						    gfp_mask, reclaim_options, NULL);
>> +						    gfp_mask, reclaim_options,
>> +						    NULL, NULL);
>>   	psi_memstall_leave(&pflags);
>>  =20
>>   	if (mem_cgroup_margin(mem_over_limit) >=3D nr_pages)
>> @@ -5001,7 +5002,8 @@ static ssize_t memory_high_write(struct kernfs_ope=
n_file *of,
>>   		}
>>  =20
>>   		reclaimed =3D try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
>> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
>> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
>> +					NULL, NULL);
>>  =20
>>   		if (!reclaimed && !nr_retries--)
>>   			break;
>> @@ -5060,7 +5062,8 @@ static ssize_t memory_max_write(struct kernfs_open=
_file *of,
>>  =20
>>   		if (nr_reclaims) {
>>   			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
>> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
>> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
>> +					NULL, NULL))
>>   				nr_reclaims--;
>>   			continue;
>>   		}
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 6a1af9b92349..15e2e5710468 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struc=
t mem_cgroup *memcg,
>>   					   unsigned long nr_pages,
>>   					   gfp_t gfp_mask,
>>   					   unsigned int reclaim_options,
>> -					   int *swappiness)
>> +					   int *swappiness,
>> +					   const nodemask_t *source_nodes)
>>   {
>>   	unsigned long nr_reclaimed;
>>   	unsigned int noreclaim_flag;
>>   	struct scan_control sc =3D {
>>   		.nr_to_reclaim =3D max(nr_pages, SWAP_CLUSTER_MAX),
>> +		.nodemask =3D source_nodes,
>>   		.proactive_swappiness =3D swappiness,
>>   		.gfp_mask =3D (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
>>   				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
>> @@ -7054,7 +7056,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct =
mem_cgroup *memcg,
>>   					   unsigned long nr_pages,
>>   					   gfp_t gfp_mask,
>>   					   unsigned int reclaim_options,
>> -					   int *swappiness)
>> +					   int *swappiness,
>> +					   const nodemask_t *source_nodes)
>>   {
>>   	return 0;
>>   }
>> @@ -8098,20 +8101,51 @@ static unsigned long __node_reclaim(struct pglis=
t_data *pgdat,
>>   enum {
>>   	MEMORY_RECLAIM_SWAPPINESS =3D 0,
>>   	MEMORY_RECLAIM_SWAPPINESS_MAX,
>> +	MEMORY_RECLAIM_SOURCE,
>>   	MEMORY_RECLAIM_NULL,
>>   };
>>   static const match_table_t tokens =3D {
>>   	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=3D%d"},
>>   	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=3Dmax"},
>> +	{ MEMORY_RECLAIM_SOURCE, "source=3D%s"},
>>   	{ MEMORY_RECLAIM_NULL, NULL },
>>   };
>>  =20
>> +#define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
>> +#define MEMORY_RECLAIM_SOURCE_NODES_LEN	(sizeof(MEMORY_RECLAIM_SOURCE_N=
ODES) - 1)
>> +
>> +static int parse_memory_reclaim_source(const char *source,
>> +				       nodemask_t *source_nodes)
>> +{
>> +	const char *nodes;
>> +
>> +	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
>> +		    MEMORY_RECLAIM_SOURCE_NODES_LEN))
>> +		return -EINVAL;
>> +
>> +	nodes =3D source + MEMORY_RECLAIM_SOURCE_NODES_LEN;
>> +	if (!*nodes)
>> +		return -EINVAL;
>> +
>> +	nodes_clear(*source_nodes);
>> +	if (nodelist_parse(nodes, *source_nodes))
>> +		return -EINVAL;
>> +
>> +	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
>> +	if (nodes_empty(*source_nodes))
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>>   int user_proactive_reclaim(char *buf,
>>   			   struct mem_cgroup *memcg, pg_data_t *pgdat)
>>   {
>>   	unsigned int nr_retries =3D MAX_RECLAIM_RETRIES;
>>   	unsigned long nr_to_reclaim, nr_reclaimed =3D 0;
>>   	int swappiness =3D -1;
>> +	nodemask_t source_nodes;
>> +	const nodemask_t *source_nodemask =3D NULL;
>>   	char *old_buf, *start;
>>   	substring_t args[MAX_OPT_ARGS];
>>   	gfp_t gfp_mask =3D GFP_KERNEL;
>> @@ -8142,6 +8176,14 @@ int user_proactive_reclaim(char *buf,
>>   		case MEMORY_RECLAIM_SWAPPINESS_MAX:
>>   			swappiness =3D SWAPPINESS_ANON_ONLY;
>>   			break;
>> +		case MEMORY_RECLAIM_SOURCE:
>> +			if (!memcg || source_nodemask)
>> +				return -EINVAL;
>> +			if (parse_memory_reclaim_source(args[0].from,
>> +							&source_nodes))
>> +				return -EINVAL;
>> +			source_nodemask =3D &source_nodes;
>> +			break;
>>   		default:
>>   			return -EINVAL;
>>   		}
>> @@ -8181,7 +8223,8 @@ int user_proactive_reclaim(char *buf,
>>   			reclaimed =3D try_to_free_mem_cgroup_pages(memcg,
>>   						 batch_size, gfp_mask,
>>   						 reclaim_options,
>> -						 swappiness =3D=3D -1 ? NULL : &swappiness);
>> +						 swappiness =3D=3D -1 ? NULL : &swappiness,
>> +						 source_nodemask);
>>   		} else {
>>   			struct scan_control sc =3D {
>>   				.gfp_mask =3D current_gfp_context(gfp_mask),
>> --=20
>> 2.20.1

