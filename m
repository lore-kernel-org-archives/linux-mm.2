Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357FECCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934658E0020; Mon, 20 Oct 2025 11:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BB98E0002; Mon, 20 Oct 2025 11:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848BC8E0020; Mon, 20 Oct 2025 11:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73CEF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:18:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5E28B6E52
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:18:39 +0000 (UTC)
X-FDA: 84018849558.03.9F12543
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2AC99160017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:18:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GlJ9HYs3;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760973518; a=rsa-sha256;
	cv=none;
	b=wGk0lHm+aIDsjTl3+iFQc3JzLZW441vBKMn4IE7l2TvHAZbLTlHKTCnBrBdX8VWm4sVuRz
	Ltnz1C2cCjH0VCJe3Jn4fyAOtESSuJlj1lB8vcgQX7f2/mUM5GZFv0yJ1qPbtEfkVGF648
	IIbkUHpIvEy4iVcdxNwPkZVy6Bz8BxA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GlJ9HYs3;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760973518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpTeSIPalU5Q5F/SFf9kGGh21yX7vRl7TM+QuLhYNT8=;
	b=nxvqtLfPrCpKRqrzRbHkajzvTnhkpc9cCi6PwbyvanhM8Ticol9H4ovURy+aXSQJaxfYgF
	vpV1DOjITj/4LHs3ASCxTistgn0FSY9/bAcKH4n/OiScXybEVrtQZtYA47HBTcbpq1OIoO
	VnFKjnUTnSJhyCmLttB4aAPNE+fU8R8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TpTeSIPalU5Q5F/SFf9kGGh21yX7vRl7TM+QuLhYNT8=;
	b=GlJ9HYs3/K39E23bWUO1LfhcnZx5Ukmzx6PbJtWUnogk2KZFXH4w2f+rFFBw0i987kM3bsbCR
	Vp/sCQAq6Rf/myY09X6BWMof+Q3AlvQFPqO5Hd6gpgjsnDyNEtwbq3vLYruc3tz7Ii9lbJ4/8A5
	uJmm6BsBuCLdRdH1ouxDQn0=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cqzYs2w0dzcb2f;
	Mon, 20 Oct 2025 23:17:21 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 519F2140257;
	Mon, 20 Oct 2025 23:18:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 23:18:28 +0800
Message-ID: <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
Date: Mon, 20 Oct 2025 23:18:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
To: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
 <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
 <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: 6jkyg56fijrkf3gi4ui8tpogaktics13
X-Rspamd-Queue-Id: 2AC99160017
X-Rspamd-Server: rspam09
X-HE-Tag: 1760973516-291492
X-HE-Meta: U2FsdGVkX19UAuX8IDBfI5eulgXb8+6RL3BsKcBcbvriXyFLoRR7VhiUHMSkKciciCj7uHWhXFtyYKCLjVaqWLrIhIBE1Q/knD2nDKjPpxeIJ2sVRyS9Fej21YnsYCdPiArwrOK+2TVxfRFSuoKFDxYZcXt8XxErt+vEjstaee4sfFYNLPKoAR6FiPiD3QRNCXt/nNXTRhJ8YhG132jTLXIge0jWdAyecUYS+vIp4CqkiG8KMS+wuJVUjRO//pdVa5bacFtRmWGz+93+evcknkd4FWYMrXh9FHYm4feVtKDvwZTSl39XEeKwkh5EA1829smviGUHQ0Kd0S9w56onMOwVWW/VVNB50U3dWCt4mZaHHbdRabN9oDPBAv6pI7JobBFELxIPDZ7M8kVtdqkwaq9UP3jdsBd4mFdGqTS6pf1oqnVQoceiYN4TSaeKn2TotzKP7feaQ6sna4VA7xPP57YATYhPhR0+lVvIjgNnXoNUuqpm4h1hFn0dd1k8btQoYwPG/XiuFGUm7Ln3iHqH+NQxvwecXrBqMGnJUIHzv4UswTG39juG+Njt7yLWtRZJhRkL9QWoY1ko0wPOg0v2WCdp1sARQG+/l+8WS51cYV8NtsmdxBJZCbP579sCRvBwmi7Puk4wqGif7nlx2GIHlAwPBtyhQyEzwV5vp9VgoQMbHe4ssm5LB/0za7l3moj8QvNTMQmu18uJ064Jf57qhfqH55dED1T3EiUkmKXBaPmNfvkfBOPY2tTqtht/4V/ev26Xk4IJHguINFbZmJBzu5zBMFxuvUFlX1GTKHHUdp8dwyQUvtJ4I9xGqhw+EHqaIkxM3oSfO2jOmRX6YbqK23KwauW5uE3EbgEOmvb5VH3q4LbXT6VysB5DosdBaRPduEUtf2QWvgatoHEd0RZl3fGK0Y/i/NLu7eCwDSZnofjWzlW1s6FTIDayVRAd0J7vUUJkaEHHvGHNaw6gOXB
 EQa98ojA
 X5AKFl80MVf/1FRrej90wleCPZX1MunY6AMfUVeIlE5UvteuI3YVJz8hBoTr+Iqc+saN44r1BsJGUXnGTJAkFiDSr10OWOMj3drjI8Kt2utznlJ1LHHgcOvaEPeQ3658SJC/NoKICuMekH2TGyGoQThUnof9+tT7sx4bMBtEoQ0fHQiAiO+omYxIk7/a2tcBb1ewS/E5TQjfZSGi4/7GqyFNBD53DPLiLVvndwJvo5pFifB0PdJj9JfWQhE/YDIZkbR3HXhCtAZyWeXkfGv1dawVHga2r/RTBsjWQig/vzfYxPTHGrdk1Z+A1j8DK8KHManz9jWrEgqwNjRJQwncBnO91H1AFilSkuzGrVlbnTOn1OA0f9gxqW2hAESKPqcFzDdMttlhN08ReRxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 21:23, David Hildenbrand wrote:
> 
>>>           /*
>>>            * Avoid trapping faults against the zero page. The read-only
>>>            * data is likely to be read-cached on the local CPU and
>>> @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather *tlb, 
>>> struct vm_area_struct *vma,
>>>           if (pmd_protnone(*pmd))
>>>               goto unlock;
>>>
>>> -        folio = pmd_folio(*pmd);
>>> -        toptier = node_is_toptier(folio_nid(folio));
>>> -        /*
>>> -         * Skip scanning top tier node if normal numa
>>> -         * balancing is disabled
>>> -         */
>>> -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
>>> -            toptier)
>>> -            goto unlock;
>>> +        /* Get target node for single threaded private VMAs */
>>> +        if (!(vma->vm_flags & VM_SHARED) &&
>>> +            atomic_read(&vma->vm_mm->mm_users) == 1)
>>> +            target_node = numa_node_id();
>>
>> This is duplicated in both callers, and only used by 
>> folio_needs_prot_numa(),
>> why not abstract this to the function also?
> 
> There was a discussion on that in v3 I think where I asked the same 
> question.
> 

Yes, it is in v1, for pte, we could avoid 512 times check and the
numa_node_id(), so we leave it as is.

