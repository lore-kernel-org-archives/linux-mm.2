Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55128CCF2EE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC0A6B0199; Mon, 19 Jan 2026 06:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC4F6B019A; Mon, 19 Jan 2026 06:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569AD6B019B; Mon, 19 Jan 2026 06:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3306B0199
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:47:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF3BD140731
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:47:07 +0000 (UTC)
X-FDA: 84348537294.14.E679C8F
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1664D1C0004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:47:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="v6/n/Zc0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768823226; a=rsa-sha256;
	cv=none;
	b=i7H4XLMNZjoFfVxkgp+fLWmeRw6Mf4+zA5iHiPGg8GDDhf3osqr12stdCYPmcnot8JDOEy
	WG/iho0i9SBSEBZRep+LYtVtv8gyx1Zhl9lOVMnmAO8VCxrb+vZAugUDVKnK/FFoHJ9OH6
	0gpDNVW8OuyLvbfkk704YRrAOu7x8lM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="v6/n/Zc0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768823226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRFmlHmHxtkj66OtCK6T+HOCJPMhl+E1NtgBlZhUdNE=;
	b=fT93l8gOPG4oRex8y+k9L0toY2mMrW1RyZtSDakdOkDNA+qC6pNv7zOKrz3GyJPQJwgup+
	G2kZo5BSmNlflzcJAmb1r6IKo0BrE4X4J4dixd854R8GC9zrOh14b4olboSuEMOnB2nmwq
	EsPav9Ug2GvO6pu1mV90GUDTNmkFGFs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BRFmlHmHxtkj66OtCK6T+HOCJPMhl+E1NtgBlZhUdNE=;
	b=v6/n/Zc09m/Z6MolR9XbPU3B/pe0FvhJyNnzNcbVviDHS4ALfW1Sh5VJoLBP4zlUlENcBVLIn
	ibQrbELMjzJxHuK/S7c0vF4S6r2o5b/Pi/U5hJiMuMW1OwVxGR5QLF5f/hXQ4T81pij2/e6qCeS
	O6qydchjqtHQO29LvNkY4nk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dvpWG3kpczLlSS;
	Mon, 19 Jan 2026 19:43:38 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7DA2140565;
	Mon, 19 Jan 2026 19:47:00 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Jan 2026 19:46:59 +0800
Message-ID: <367b50c5-9320-491e-9652-9367faf38dcc@huawei.com>
Date: Mon, 19 Jan 2026 19:46:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <akpm@linuxfoundation.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
 <04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
 <20260115101252.2e0cbe0559e62b988e5f7151@linux-foundation.org>
 <1ad31dbd-6743-473d-9f66-a603b91d1e54@huawei.com>
 <70d46998-a6c6-4c18-b8d7-f813582d3143@kernel.org>
 <7471b637-537c-40db-ade0-ad373d7085f7@huawei.com>
 <87e0523c-1fc6-42aa-8159-150fd94d5b62@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <87e0523c-1fc6-42aa-8159-150fd94d5b62@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 1664D1C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: edycx4dp7jjwkd8odc1u6dizp77zrw7f
X-Rspam-User: 
X-HE-Tag: 1768823224-799782
X-HE-Meta: U2FsdGVkX19m/j2u241fXrpHYjtulAh2FGbNV4cGdH7ernt7wRw1TuT3BMhvLfa1SJ8pV0lE3zIOyIyeXQEk2//rnbYfC4ebi8VCQ9t04mjcVThOWgmKfrzZPbLtbn6kLwDbFuXNOYP0ceoi3XSBsWgvmrvumM6n0Hb5x5MT/asJq/4w1SyM5y8NUWA1zqssR23hT4N+CKdJGm3LKEyLUVVIkc/OxHg7nMn2yv5DVQxbOvqvx/2Wp+LZac7KrkgarzCKDvUdIl3LX4lsfKU9guCIbe7l/8Ha7aGKCv+uisQZmyDUhYFPmikj2+bLab29lRefyqGSNDNYcFgw4R1Wc2mm3ECVEt3/V88t9+aCHs3bDPFsMTm0RIBbbt6aOjUuNyjVLuOZ9z1RTdHokQ8pcp6mnR1aMBYybCxJxkn3xGkzxd1ahl2Xi2Wce9fAQXrR89o54qvu0rjIG4fH6GxHrUr0zSO0ohe1DfoXQM8KcX0wske6bOyBhlz2C97BVSVnDBYS2IM9Svw1hUEHznzmfoeAK4Orf9z8ZFCFGI7cLppmOde4xSP61U7VG6m4zKv7yaOgNnjS2yJukNaZ9zg3XFNXEGiVzXDZEq3XWCxy+8F9hhXsE7osKYORu8wGKZY5WBjf8xGORadIT5lV0g8AwoEf4l6XLPjGUr2GbfqGPFahx6I19gqoMhf3zVfmDq+ENKBs3YczTZlOQC4cSSrPiytkiLIpYDetigdG5EDxx05CVGDwRzN8qZNIZ9Z037P+evY12P8jVtEXHAIB2hasAoLuZgj9rMKXIev7MCa1KtWCMwu/JITPVwbAeq6GZIm9/UCDLrkwq8Zazlh59Z6mQV3yLwtxDEQNDUwWjwYwzn5svRg6VfT8ULjk0CUGxAIcO1TiHp1Xdf9pFZeKg1qQdpPvYkQ2H1UrvWJvNLH5ri62dWVG5qZ8rmIosplO94J/V1Acfbq5nbBeVGyNcXe
 onmXi0Ud
 LRL8J6LYNcnFJ8CLebXAD/JMbcPamFwZeknPww6Gqlz1yiqxsYEPWHppOtBaoXna5W2Llzt8JlQISm85jaytLWeTKtreGG0hjE+vIH77efY/Ob+SuQuZsXxGyuMLxXLukhgIHjwQmpNcOSssaMYBkx1w+garuew+h3ZIQc6G+eYLuME2zHqBK9CHJnhX7RWZJlQZwC/p5BK1KW2UQ6je8TGIaLMsM2ciXdETvRIvJAMhN7tmPt9/VI5ALoAJGkRAdTidVSZHnfq/skiUZ6bb9moqKIbDetGTQdjEXgUtJm6GufPUsD8wcGFotZXujk/cgNBKD79qhQYUwd4VKrnaAV8uK6lcushYxgNwHNjIHZvV4f7a7fDP0uixCntwXOMru/XFqHWIFsim55wk0V+3REo/Vl1bmBY1wSVd0qE6MXdsQViP9v8GGx3KmkbzEvNMXO3UUv4OyanCzxmfvNX2chtmsvwabs64p44x+jGJAvEj5hO0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/19 2:45, David Hildenbrand (Red Hat) 写道:
> On 1/17/26 02:00, Jinjiang Tu wrote:
>>
>> 在 2026/1/16 18:58, David Hildenbrand (Red Hat) 写道:
>>> On 1/16/26 07:43, Jinjiang Tu wrote:
>>>>
>>>> 在 2026/1/16 2:12, Andrew Morton 写道:
>>>>> On Thu, 15 Jan 2026 18:10:51 +0100 "David Hildenbrand (Red Hat)"
>>>>> <david@kernel.org> wrote:
>>>>>
>>>>>> On 12/23/25 12:05, Jinjiang Tu wrote:
>>>>>>> commit bda420b98505 ("numa balancing: migrate on fault among 
>>>>>>> multiple
>>>>>>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA
>>>>>>> balancing
>>>>>>> for MPOL_BIND memory policy.
>>>>>>>
>>>>>>> When the cpuset of tasks changes, the mempolicy of the task is
>>>>>>> rebound by
>>>>>>> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and
>>>>>>> MPOL_F_RELATIVE_NODES
>>>>>>> are both not set, the behaviour of rebinding should be same 
>>>>>>> whenever
>>>>>>> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
>>>>>>> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both
>>>>>>> MPOL_F_STATIC_NODES
>>>>>>> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed
>>>>>>> should
>>>>>>> be set to cpuset_current_mems_allowed nodemask. However, in current
>>>>>>> implementation, mpol_store_user_nodemask() wrongly returns true,
>>>>>>> causing
>>>>>>> mempolicy->w.user_nodemask to be incorrectly set to the
>>>>>>> user-specified
>>>>>>> nodemask. Later, when the cpuset of the application changes,
>>>>>>> mpol_rebind_nodemask() ends up rebinding based on the 
>>>>>>> user-specified
>>>>>>> nodemask rather than the cpuset_mems_allowed nodemask as intended.
>>>>>>>
>>>>>>> To fix this, only set mempolicy->w.user_nodemask to the
>>>>>>> user-specified
>>>>>>> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is 
>>>>>>> present.
>>>>>>>
>>>>>> ...
>>>>>>
>>>>>> I glimpsed over it and I think this is the right fix, thanks!
>>>>>>
>>>>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>>> Cool.  I decided this was "not for backporting", but the 
>>>>> description of
>>>>> the userspace-visible runtime effects isn't very clear. Jinjiang, can
>>>>> you please advise?
>>>>
>>>> I agree don't backport this patch. Users can only see tasks binding to
>>>> wrong NUMA after it's cpuset changes.
>>>>
>>>> Assuming there are 4 NUMA. task is binding to NUMA1 and it is in root
>>>> cpuset.
>>>> Move the task to a cpuset whose cpuset.mems.effective is 0-1. The
>>>> task should
>>>> still be binded to NUMA1, but is binded to NUMA0 wrongly.
>>>
>>> Do you think it's easy to write a reproducer to be run in a simple
>>> QEMU VM with 4 nodes?
>>
>> I can reproduce with the following steps:
>>
>> 1. echo '+cpuset' > /sys/fs/cgroup/cgroup.subtree_control
>> 2. mkdir /sys/fs/cgroup/test
>> 3. ./reproducer &
>> 4. cat /proc/$pid/numa_maps, the task is bound to NUMA 1
>> 5. echo $pid > /sys/fs/cgroup/test/cgroup.procs
>> 6. cat /proc/$pid/numa_maps, the task is bound to NUMA 0 now.
>>
>> The reproducer code:
>>
>> int main()
>> {
>>           struct bitmask *bmp;
>>           int ret;
>>
>>           bmp = numa_parse_nodestring("1");
>>           ret = set_mempolicy(MPOL_BIND | MPOL_F_NUMA_BALANCING, 
>> bmp->maskp, bmp->size + 1);
>>           if (ret < 0) {
>>                   perror("Failed to call set_mempolicy");
>>                   exit(-1);
>>           }
>>
>>           while (1);
>>           return 0;
>> }
>>
>> If I call set_mempolicy() without MPOL_F_NUMA_BALANCING. After step 
>> 5, the task is still bound to NUMA 1.
>>
>
> Great, can you incorporate that into an updated patch description?

No problem, I will update it.

>
> And it might make sense to point at commit bda420b98505 ("numa 
> balancing: migrate on fault among multiple bound nodes") where we 
> document
>
> "
>  we add MPOL_F_NUMA_BALANCING mode flag to
>  set_mempolicy() when mode is MPOL_BIND.  With the flag specified, NUMA
>  balancing will be enabled within the thread to optimize the page
>  placement within the constrains of the specified memory binding 
> policy. "
>
> The "within the constrains" is the crucial bit here.
>

