Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E75D6ACD7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5C06B0089; Thu, 18 Dec 2025 04:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7486B008A; Thu, 18 Dec 2025 04:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6DB6B008C; Thu, 18 Dec 2025 04:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 931C06B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:31:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D179BE167
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:31:21 +0000 (UTC)
X-FDA: 84232073562.09.7942D67
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A38D12000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:31:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="w+/deaOu";
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mEjU8wX83Cg3o+9Hcgc6XPzGswLeHLk0tmhTdtZzxA=;
	b=AGHwWBhM4mh0lQV0fnIldG+OFt8LeZUo9Zf9C8j2Hz/OcMXNgKaK46m80s2DpNv5+znhS8
	wYZcwCN8biNCHSA3KjCGVOI0wv5C5dbanFyZ/C1pMf4KDeSx+xFWlNr0rgkiFNj4VgMJC1
	FCt5Y7Cs3RMM61rcr6p4Gn3FoApGQF0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="w+/deaOu";
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766050279; a=rsa-sha256;
	cv=none;
	b=CPFURc2Uyr9utX+4i0QFV3YhnLrcXyIqbKhQPo5lFvApenBEmR/muZIFNsvZ3R0OkFE+TU
	CUxGok6mt9PQLy+wSb2mhE7mRxXRDhfK3CgYuHBGKSyeu7k4dle5Wrg9li0s1JFIOx5AbX
	c5K/1CyRgPu1dDcKdADDqiRkbhXwwR8=
Message-ID: <8d9592ea-988c-4c97-b059-a58afb05b3f3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766050276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9mEjU8wX83Cg3o+9Hcgc6XPzGswLeHLk0tmhTdtZzxA=;
	b=w+/deaOukBWJ4ZgZ3I1WlhHxaGiV/8cdmYNowXHEEUM+0aRZQcIlLFeoPi5rQoMl+cjSJo
	m9T+bhiZ1Q8ktwvjUNQ3J9w0OH/psy86bJ93ChPyG30NihzHHvBY9JO3496dt85GKI/p1v
	m+C9Zwyx5GyP3/toJ6v/5zimaZ/y0j0=
Date: Thu, 18 Dec 2025 17:31:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 04/28] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
 <87e59cd3-a554-4911-aaca-21be2080e2c6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <87e59cd3-a554-4911-aaca-21be2080e2c6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A38D12000A
X-Stat-Signature: 5c5rx574mf93i8egospndh5jo8hr3nag
X-HE-Tag: 1766050279-786503
X-HE-Meta: U2FsdGVkX1+461YyDS0f0664uKoz/8/9/MmNv03oJblIK2hEQDF8+OBRs5phqiFL616UjrhK8TCONLgv5IZN0p2AHGijVeMRYdQRDoOPHXQkLX1kf5vlVzNRJYd+DxlHc19gqEs5t9KErWOl4FOL6A37U7M3sT2fcWrljbvdzqzeT+7rVAZRa4ISGJkuhCTGxqmvG/NlsRfX4MfMG1YmLU8hcZKfl0nwoirKFM5gEXLDakWaOOw4tlM6zYcV3P4/HaQwd6NSpOwfkz1WehOKGTkqye/x7X0KdIllfuqSu1BGrmYKD90sAspUIUw8ouWpgPqVVyuqjVpeS1U8K/HxMORe5pSYaGBj67nWwVkSE8QaUE1n9aO/WzRD96gSRG+ynSjgXn1si53JUgMfVmD5KS0Oq22ecpvT4k7Pcp6zbDry8cz8+YqhIpErUpldmbJ0IF1K2OoGCoXq6l7OyXQ0FxdulySUUtrfQXOJoAvibGb7mmOpElvatimAs4r6GYC5k/KZ1DbiT0iZ1ibsCspCOz5OmiENOKQO5HC0650atIj8zqKXdFhRyvVbCgpsaC/0cS/qo+317iPKi6L5hPVZME/BvtU+ehhLV5UN3vmrwtKArtHto+ZLXpeDeszlFlC+h3zCdJAZurRIDRTUlro0lZO3psc3J6WWCusEJXPzAIlzbdQTm7x0uKmAPfaEIKlDJoVobSWFXi//NRJd9PhWyP2ZvbVxmSHAVb3s9zIDc6P9PEGgPXqCV4VuN9d54Nl4fdxFl4iUKtU/G1M7RB/jtb7hNNj1mXMi+XoRuR2kFH2FwebnTD7A8UEYMAxn+Eh3ztGaZxyqulTqoklaG3i+A+iIkq+dRwrrbJUpRb4hEdcem8eJJ8rld4F1M5zIO+e5fe2t0rIAUAWykHQqdGu+HwOBISLVtIxj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 5:04 PM, David Hildenbrand (Red Hat) wrote:
> On 12/17/25 08:27, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> After refactoring the move_folios_to_lru(), its caller no longer needs to
>> hold the lruvec lock, the disabling IRQ is only for __count_vm_events()
>> and __mod_node_page_state().
>>
>> On the PREEMPT_RT kernel, the local_irq_disable() cannot be used. To
>> avoid using local_irq_disable() and reduce the critical section of
>> disabling IRQ, make all callers of move_folios_to_lru() use IRQ-safed
>> count_vm_events() and mod_node_page_state().
> 
> The patch description is a bit confusing for me.
> 
> I assume you mean something like
> 
> "Once we refactor move_folios_to_lru(), its callers will no longer have 
> to hold the lruvec lock; disabling IRQs is then only required for 
> __count_vm_events() and __mod_node_page_state().
> 
> To prepare for that, let's $YOURDETAILSHERE"

It is indeed clearer, will do in the next version.

> 


