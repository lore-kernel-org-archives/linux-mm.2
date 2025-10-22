Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717EBCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42648E0007; Tue, 21 Oct 2025 21:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3108E0002; Tue, 21 Oct 2025 21:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E18D8E0007; Tue, 21 Oct 2025 21:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 897708E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:34:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24891C061A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:34:06 +0000 (UTC)
X-FDA: 84024029292.18.3BC2C81
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6874A40003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:34:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZzL2pT4i;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761096844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYWp9CEjjLfMCUMyZ5HSSHuvO42FJgI67RYwZmoAUv4=;
	b=vfmQrc5XpJ1flmHSVdMDspeJpp9BfToTUsI+Voi91RN5NdlG4XBjyqnx6V4TlPAmObbTUO
	PECa72fF0OFNwC9pS+CDf1ioBwUt/y8hkkUKCaU1fI3Tv6mlpaUaTpnHBoI68jz2GXPf8M
	b01x5PLjiBbVwt8Rgk4Y/Fsg6GJ/Ydk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZzL2pT4i;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761096844; a=rsa-sha256;
	cv=none;
	b=cmtPnxaml/ZHoDCGdy8pYHplrz0bwVQUBLy+d82R4tDm8PAfkx5k5PySyEsDh0M5780aZq
	Jj9W7Ljc92uMAMZaKBeRLUAK2l5ixlNtEJUbxiBkRo4pJkpflS6AoQF5qaGzKXteNbEskv
	go5u2Vl0vgLUf1QO2R3IfIr/Y2Li5Hg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DYWp9CEjjLfMCUMyZ5HSSHuvO42FJgI67RYwZmoAUv4=;
	b=ZzL2pT4iFaZG1iyrVWXPZF9Ts8qVcaKGZQ/86PiPdU3QeEBmbY2mwZu0PiCtxaB6KN61M/rNH
	akbu78PhF9vx1eZEcL+hQBKYe2s+hQ1384XGup2h/6tQEX/pgJCkBKUxvVno7JzFucA4aE1SkRZ
	1WPXKKVwET5BzuBbGgIo/YE=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4crsBJ3SL3z1prLM;
	Wed, 22 Oct 2025 09:33:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F046140154;
	Wed, 22 Oct 2025 09:33:53 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 09:33:52 +0800
Message-ID: <5d94e515-5897-401a-a988-9ba540f15d75@huawei.com>
Date: Wed, 22 Oct 2025 09:33:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
 <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
 <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
 <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
 <8ed25b3a-58a0-4e8b-84c3-2d787f9ae636@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <8ed25b3a-58a0-4e8b-84c3-2d787f9ae636@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: jdjtp3d763box3k85ufreapsegf8cf8y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6874A40003
X-HE-Tag: 1761096842-776149
X-HE-Meta: U2FsdGVkX19h/ml6e8JK2u/4H09VFOEZRCZpmXKxVgtogW7LOKb+oaI9VHNbcJKZ+IVlMzyPoMmOSJuLxZeWqpQl2jv9h7NrXHCPdlyAc8H7uZrsgUqSiXhcPoaUp57TpTNzLeP+hKWCKgKzOOdykn4VafRNNpHlQpEuwsvetXa1xT82UNdz/N6byga6vkbpUbaQa968sfP82KfVT1iwVVHCvUUB4AAMsnQUNXVgH7UiTNcl7ZPeqfJ79vmb8jUuHz5U9AiEg+JFkh/4tIquutpXeXLQeJEX+lt5FdH7/m9gS78FHLznASLq7sbfu3wZx1EavjXqkIofqU62+goLEEfEmUdD/MsGphX4qbOChZQZ7obIY+FG9qIvPmyLcuyJlUufS1wE3KsgrCmgJh1q/v3Ml8bqU1sxsrrjEa7+rinvniTBTiqFIUGdpwKReCMHB5sxyhDkEWBbNxekSaSZpmNNET4vextfrspKAzNzstFKFpcqr1eABgeAjohL1iVH8a4tjAX4s8wbkXA6we1A+33N47GI5ZOMZ6hj+SGmhPAaunMd7BHieRV76vsdEwN7GX8u+5z6rlEPdfn7keYFYtY8XtQlu62/+tuR/SXB1jVcndela4hIVWpZqZfYWXatZEe0Kd2xYv6wLcPert6MELUuRLdRZajRyhBx82WMy/ZsqMlxx//n9csAX1ZqikwV96z4dISIi7VTOLQrERumb/YDJoFpflZylwvgQbZSoymmb4Y/tZgJcsX66ZlsreOUmEzy9INffkNpku8/O0HuUGNeWbYteCumP4arpWy9WgYhLwhS6tU7A/ovYWiBcyti70GKAwQpinndVqHQzOjRdhSAaw4teZMFYO+uO4wKXPp6KhOms2tDolj1JWveCksgPqejEsDK6M7ct8/BGg9wMqaaQ3PQYLbCcC6S+jFKPx+5/QO8AYf6MtOVRIwz6gcVmI2UyweEEwxZeXBGPfZ
 XRNruxkI
 KnEnNjpUdWHl8GbriTJBDMdN5R6lpzjZYeRbJqqj42BQYP5ZhpnCJ6avSjIYdAWezYXpPb4dnpIkf8/jBqDpeOBYpcMyCdE4rCJ13t0gQMUpV6h3PLvXm3t5YyZ10w7Dgpdy06wbuYtKw7ELNuoHtRa5CJsZHTHeo4D9YV0ah7cYHMhDxYNri+ihyNxzlq6Jn7v3F8fttkakEsuv3owW35og12RQTXAWUSE/3S5BGcIrfoRJCFVdXVa9ELIXFlJDHHu2O/GOA9yzgzSWR950bu7MdNKfsceOiLEJufddknT5JHt1B8QZtvaCwGAk+7c3cmrIyK44AjiUp6/ON5SfAFGAbwF2XcvO5bX5MFQmEsRnwVTYj5jI6Tir3vnS/P6qM3Zc1b6uiCzGEIlM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/21 23:29, Lorenzo Stoakes wrote:
> On Mon, Oct 20, 2025 at 11:18:27PM +0800, Kefeng Wang wrote:
>>
>>
>> On 2025/10/20 21:23, David Hildenbrand wrote:
>>>
>>>>>            /*
>>>>>             * Avoid trapping faults against the zero page. The read-only
>>>>>             * data is likely to be read-cached on the local CPU and
>>>>> @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather
>>>>> *tlb, struct vm_area_struct *vma,
>>>>>            if (pmd_protnone(*pmd))
>>>>>                goto unlock;
>>>>>
>>>>> -        folio = pmd_folio(*pmd);
>>>>> -        toptier = node_is_toptier(folio_nid(folio));
>>>>> -        /*
>>>>> -         * Skip scanning top tier node if normal numa
>>>>> -         * balancing is disabled
>>>>> -         */
>>>>> -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
>>>>> -            toptier)
>>>>> -            goto unlock;
>>>>> +        /* Get target node for single threaded private VMAs */
>>>>> +        if (!(vma->vm_flags & VM_SHARED) &&
>>>>> +            atomic_read(&vma->vm_mm->mm_users) == 1)
>>>>> +            target_node = numa_node_id();
>>>>
>>>> This is duplicated in both callers, and only used by
>>>> folio_needs_prot_numa(),
>>>> why not abstract this to the function also?
>>>
>>> There was a discussion on that in v3 I think where I asked the same
>>> question.
>>>
>>
>> Yes, it is in v1, for pte, we could avoid 512 times check and the
>> numa_node_id(), so we leave it as is.
>>
> 
> OK so what you're saying is that in change_pte_range() you only need do the
> check once (per PMD) rather than for each PTE entry.
> 
> It might be worth having this as a separate helper function as it sucks to
> duplicate that.
> 
> I actually really don't like that we pass in a 'target node' but only when it's
> single-threaded. That's a bit silly.
> 
> E.g.:
> 
> static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
> {
> 	if (vma->vm_flags & VM_SHARED)
> 		return false;
> 
> 	return atomic_read(&vma->vm_mm->mm_users) == 1;
> }
> 
> Then you can pass in a boolean and change:
> 
> 	/*
> 	 * Don't mess with PTEs if page is already on the node
> 	 * a single-threaded process is running on.
> 	 */
> 	nid = folio_nid(folio);
> 	if (target_node == nid)
> 		return false;
> 
> To:
> 
> 	/*
> 	 * Don't mess with PTEs if page is already on the node
> 	 * a single-threaded process is running on.
> 	 */
> 	if (is_private_single_threaded && folio_nid(folio) == numa_node_id())
> 		return false;
> 
> Which makes a lot more sense than passing in NUMA_NO_NODE for shared VMAs.
> 

OK, will add the helper to remove the duplication.

> Now we're sharing this I really don't know why the function is still in
> mprotect.c by the way? Shouldn't it be in mempolicy.c + have a stub
> function for !CONFIG_NUMA_BALANCING?

Do you mean that moving folio_can_map_numa_prot() near change_prot_numa()
function in mempolicy.c?  if so, I will change it.




