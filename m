Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0590DD3E798
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 06:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE476B0005; Thu, 11 Dec 2025 01:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE546B0007; Thu, 11 Dec 2025 01:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEC06B0008; Thu, 11 Dec 2025 01:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA6BE6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:37:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7408B8B043
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:37:40 +0000 (UTC)
X-FDA: 84206234280.24.A2F349A
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9CAA40006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:37:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HG5C+xKF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765435058; a=rsa-sha256;
	cv=none;
	b=dq/vgw5b2DX8+d2urMBfSRJ0QHNtO4pRH88MwRfglox2ZyWM0qGTERV1XjeS+W3Ge7PMyy
	8AsGv+sdC534efyDJnzKQ0qjtFbUgFi8u5Gt5vQBJZ22zOFVHLA245Wk8L/zMvI68d3Zyr
	GtsRpTP3svR6QE0wa0P9HFtEsiOJWJE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HG5C+xKF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765435058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TlMnYbsEikMCU86ATB/+VkxjG3VrfNznBjHnlh9ByQ=;
	b=kf5nTI+QXfE2HLKdQTf3paRtVGuvb6qJT6hOw1qJJP88xhvwy3yYHE801A66HW6QEaop5v
	x7sBgw89CmGFspZatBhhiUwDYA+I8CmaG7ODPrH7pgMeDq1Irnj3l2i+rwWUwjIMSQFfvz
	FZa4jaL3Z2oC901F+M9FsEsJQj3muSc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4TlMnYbsEikMCU86ATB/+VkxjG3VrfNznBjHnlh9ByQ=;
	b=HG5C+xKFF5uHObuaqDHsgTxbRJTnOZtKflcoN3OcIyr+7VCmYEoI7CQUExSMFBMLWiTfzSq0F
	IO5lUs+7p5W+GTO2+rddRpAwl8jnZq3Ejr9gsjW3G49zeD9vrST4gSlqzpDO6bwrLGzT+tHpQDT
	Seu7N/Pqllwc+1YDdsesZIA=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dRjWp28Ynz1cyPb;
	Thu, 11 Dec 2025 14:35:34 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 94E701A016C;
	Thu, 11 Dec 2025 14:37:31 +0800 (CST)
Received: from [10.174.178.114] (10.174.178.114) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Dec 2025 14:37:30 +0800
Message-ID: <1c08ac4e-f4d0-49e8-9b7e-3fa201288c56@huawei.com>
Date: Thu, 11 Dec 2025 14:37:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <willy@infradead.org>, <david@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <kernel-team@meta.com>
Subject: Re: [RFC LPC2025 PATCH 0/4] Deprecate zone_reclaim_mode
To: <joshua.hahnjy@gmail.com>
References: <20251210123003.424248-1-joshua.hahnjy@gmail.com>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20251210123003.424248-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.114]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Queue-Id: C9CAA40006
X-Stat-Signature: d8zkeqsne7ooiw3ehqins9gwkzfcnces
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765435056-284112
X-HE-Meta: U2FsdGVkX1/VWXXFnj2O4MOyzI57421zfF+SlwU3fM8++sFZrkZSqKrvVe3GlMrD9uDh8ux5fXU3zCoDP5xEtVpQPEZeDAodcjbsfkbZzM+XGs4DU0MG+yQ6Iam41O0AZrQsuT5iH6rjLGUVANuQFQ4NCb2kY83kcQNV1a5pps8tahw2qe7WL7z258FmgG+vx3rTrnEhZOpeXindRS9373ilmDo3IpyD3UEXUTS37yHf0l2WPAVEZfmffgAhcENxumMSTeQItzccI1I/v8wso3njT+QpRapjHnyWXuoF5KS5ObvEFKXchfsZ1MMyo7D9It6W2yaK7J0vxFgOe7e5ywSxi4hvDvsv2KF3Uroh7sqqJhb/ZZg6w0QyzRoDn295cNXGEBLPpATU9gDYihVhxN5u1ltWUwB3ehUNZFnzY12HfYRp5qHcwyHb+YZy8WEJuGmNv8xmOJbf402CZjA0r66uarnfR7FXhLnAS5+40RW0QYBuS6pGVcQ/v/RcGyX266J8TwFeT3tbrUgBsd+pm+eD0Y9K65DSS3pcVIVHZ47E8iIuXXu/j6lWDY3P1WlKn2eDS++EveQHMQAQzuAMbWhF5sCgy3I18UoK0gY2PjRgB1ptDUKoCkqorycOaij3yXeNxbFKM+eS9uHVlPD7Bwq/utR9jXckrfJiUz2OjyjxV0ah270Rpy79zfIu7KruNTHvatq7Z6xTDzoAiepfWpKlvhU9AQNtbszN9WXR+hpJ1rUkZlIYpDVhg/BVwrVDLqfYKZHYwAcaPj5y8/9kG7Vu5j8Wn8t08+Fni1Jt7nggDUFrUxlDvKnBdScHpUx7BJSxtmj6nll1ly5AIbMJ6EgMFdbBeNwAQPhxm6e0aHVE3z9EgUHx39+rrk2lw8zlE4MoHTBO5kx+Fg3tayXuksqgmh3l5D/Uy0Uz6ZwMB6A265o78xyM5gGW1cQMVzDNxxhcvbTUcptPRuZx4z2
 CbUkhZtj
 tV099SAAjimkv3lJy3z4bzQrWNZtspe/sWcZf8kb6V78QaNUuHiPyxKKs8J5UdLIVi4DZwF01NvXfwDrv7+8/Qvb+vjIR5MjBS9eDeGtAnFPvx2uaD/gR2NooWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/10 20:30, Joshua Hahn wrote:
> On Tue, 9 Dec 2025 20:43:01 +0800 mawupeng <mawupeng1@huawei.com> wrote:
>>
>> On 2025/12/6 7:32, Joshua Hahn wrote:
>>> Hello folks, 
>>> This is a code RFC for my upcoming discussion at LPC 2025 in Tokyo [1].
>>>
>>> zone_reclaim_mode was introduced in 2005 to prevent the kernel from facing
>>> the high remote access latency associated with NUMA systems. With it enabled,
>>> when the kernel sees that the local node is full, it will stall allocations and
>>> trigger direct reclaim locally, instead of making a remote allocation, even
>>> when there may still be free memory. Thsi is the preferred way to consume memory
>>> if remote memory access is more expensive than performing direct reclaim.
>>> The choice is made on a system-wide basis, but can be toggled at runtime.
>>>
>>> This series deprecates the zone_reclaim_mode sysctl in favor of other NUMA
>>> aware mechanisms, such as NUMA balancing, memory.reclaim, membind, and
>>> tiering / promotion / demotion. Let's break down what differences there are
>>> in these mechanisms, based on workload characteristics.
> 
> [...snip...]
> 
> Hello mawupeng, thank you for your feedback on this RFC.
> 
> I was wondering if you were planning to attend LPC this year. If so, I'll be
> discussing this idea at the MM microconference tomorrow (December 11th) and
> would love to discuss this after the presentation with you in the hallway.
> I want to make sure that I'm not missing any important nuances or use cases
> for zone_reclaim_mode. After all, my only motivation for deprecating this is
> to simplify the code allocation path and reduce maintenence burden, both of
> which definitely does not outweigh valid usecases. On the other hand if we can
> find out that we can deprecate zone_reclaim_mode, and also find some
> alternatives that lead to better performance on your end, that sounds
> like the ultimate win-win scenario for me : -)
> 
>> In real-world scenarios, we have observed on a dual-socket (2P) server with multiple
>> NUMA nodes—each having relatively limited local memory capacity—that page cache
>> negatively impacts overall performance. The zone_reclaim_node feature is used to
>> alleviate performance issues.
>>
>> The main reason is that page cache consumes free memory on the local node, causing
>> processes without mbind restrictions to fall back to other nodes that still have free
>> memory. Accessing remote memory comes with a significant latency penalty. In extreme
>> testing, if a system is fully populated with page cache beforehand, Spark application
>> performance can drop by 80%. However, with zone_reclaim enabled, the performance
>> degradation is limited to only about 30%.
> 
> This sounds right to me. In fact, I have observed similar results in some
> experiments that I ran myself, where on a 2-NUMA system with 125GB memory each,
> I fill up one node with 100G of garbage filecache and try to run a 60G anon
> workload in it. Here are the average access latency results:
> 
> - zone_reclaim_mode enabled: 56.34 ns/access
> - zone_reclaim_mode disabled: 67.86 ns/access
> 
> However, I was able to achieve better results by disabling zone_reclaim_mode
> and using membind instead:
> 
> - zone_reclaim_mode disabled + membind: 52.98 ns/access
> 
> Of course, these are on my specific system with my specific workload so the
> numbers (and results) may be different on your end. You specifically mentioned
> "processes without mbind restrictions". Is there a reason why these workloads
> cannot be membound to a node?

My apologies for the delayed response — I’ve been discussing the actual workload
scenarios with HPC experts.

In HPC workloads, certain specialized tasks are responsible for initialization,
checkpointing by specific processes, post‑processing, I/O operations, and so on.
Since the memory access patterns are not completely uniform, binding them to a
specific NUMA node via membind is often a more suitable approach.

However, two main concerns arise here:

If a workload spans more than a single NUMA node, binding it to just one node may
not be appropriate. Binding to multiple NUMA nodes might be feasible, but the
impact on page cache behavior requires further evaluation.

HPC applications vary widely, and not all can be addressed by membind. At the same
time, zone_reclaim_mode may not be a complete solution either—this also needs
further investigation.

We should explore whether there are better ways to balance memory locality with
memory availability.

> 
> On that note, I had another follow-up question. If remote latency really is a
> big concern, I am wondering if you have seen remote allocations despite
> enabling zone_reclaim_mode. From my understanding of the code, zone_reclaim_mode
> is not a strict guarantee of memory locality. If direct reclaim fails and
> we fail to reclaim enough, the allocation is serviced from a remote node anyways.
> 
> Maybe I did not make this clear in my RFC, but I definitely believe that there
> are workloads out there that benefit from zone_reclaim_mode. However, I
> also believe that membind is just a better alternative for all the scenarios
> that I can think of, so it would really be helpful for my education to learn
> about workloads that benefit from zone_reclaim_mode but cannot use membind.
> 
>> Furthermore, for typical HPC applications, memory pressure tends to be balanced
>> across NUMA nodes. Yet page cache is often generated by background tasks—such as
>> logging modules—which breaks memory locality and adversely affects overall performance.
> 
> I see. From my very limited understanding of HPC applications, they tend to be
> perfectly sized for the nodes they run on, so having logging agents generate
> additional page cache really does sound like a problem to me. 
> 
>> At the same time, there are a large number of __GFP_THISNODE memory allocation requests in
>> the system. Anonymous pages that fall back from other nodes cannot be migrated or easily
>> reclaimed (especially when swap is disabled), leading to uneven distribution of available
>> memory within a single node. By enabling zone_reclaim_mode, the kernel preferentially reclaims
>> file pages within the local NUMA node to satisfy local anonymous-page allocations, which
>> effectively avoids warn_alloc problems caused by uneven distribution of anonymous pages.
>>
>> In such scenarios, relying solely on mbind may offer limited flexibility.
> 
> I see. So if I understand your scenario correctly, what you want is something
> between mbind which is strict in guaranteeing that memory comes locally, and
> the default memory allocation preference, which prefers allocating from
> remote nodes when the local node runs out of memory.
> 
> I have some follow-up questions here.
> It seems like the fact that anonymous memory from remote processes leaking
> their memory into the current node is actually caused by two characteristics
> of zone_reclaim_mode. Namely, that it does not guarantee memory locality,
> and that it is a system-wide setting. Under your scenario, we cannot have
> a mixture of HPC workloads that cannot handle remote memory access latency,
> as well as non-HPC workloads that would actually benefit from being able to
> consume free memory from remote nodes before triggering reclaim.
> 
> So in a scenario where we have multiple HPC workloads running on a multi-NUMA
> system, we can just size each workload to fit the nodes, and membind them so
> that we don't have to worry about migrating or reclaiming remote processes'
> anonymous memory.
> 
> In a scenario where we have an HPC workload + non-HPC workloads, we can membind
> the HPC workload to a single node, and exclude that node from the other
> workloads' nodemasks to prevent anonymous memory from leaking into it.

Maybe we can try to mbind to multiple node for this scenario as above.

> 
>> We have also experimented with proactively waking kswapd to improve synchronous reclaim
>> efficiency. Our actual tests show that this can roughly double the memory allocation rate[1].
> 
> Personally I believe that this could be the way forward. However, there are
> still some problems that we have to address, the biggest one being: pagecache
> can be considered "garbage" in both your HPC workloads and my microbenchmark.
> However, the pagecache can be very valuable in certain scenarios. What if
> the workload will access the pagecache in the future? I'm not really sure if
> it makes sense to clean up that pagecache and allocate locally, when the
> worst-case scenario is that we have to incur much more latency reading from
> disk and bringing in those pages again, when there is free memory still
> available in the system.

If a larger file cache is required, disabling zone_reclaim_mode may help alleviate the
issue, but it indeed lacks some flexibility.

In my personal understanding, the main problem is that page cache tends to occupy all
available free memory, leading to an unreasonable increase in fallback.
> 
> Perhaps the real solution is to deprecate zone_reclaim_mode and offer more
> granular (per-workload basis), and sane (guarantee memory locality and also
> perform kswapd when the ndoe is full) options for the user.

I think it’s worth looking into whether there are better approaches to address the
current issue.

> 
>> We could also discuss whether there are better solutions for such HPC scenarios.
> 
> Yes, I really hope that we can reach the win-win scenario that I mentioned at
> the beginning of the reply. I really want to help users achieve the best
> performance they can, and also help keep the kernel easy to maintain in the
> long-run. Thank you for sharing your perspective, I really learned a lot.
> Looking forward to your response, or if you are coming to LPC, would love to
> grab a coffee. Have a grat day!
> Joshua
> 
>> [1]: https://lore.kernel.org/all/20251011062043.772549-1-mawupeng1@huawei.com/


