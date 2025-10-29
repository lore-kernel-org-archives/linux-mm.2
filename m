Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EF5CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 06:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6949A8E0037; Wed, 29 Oct 2025 02:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BFF8E0015; Wed, 29 Oct 2025 02:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A92E8E0037; Wed, 29 Oct 2025 02:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46A818E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:40:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D401B14078B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:40:23 +0000 (UTC)
X-FDA: 84050202726.05.6858DB5
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf19.hostedemail.com (Postfix) with ESMTP id A494F1A0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:40:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IpMOnKmo;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761720022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2FdD5J/Lr6BnGwMKRTDIEW2p4Dh3z/n14/cPtSxKg4=;
	b=g7mBGoXMR8YMHNnJHv1L5tgrV6ffOSP25hSSOX3Egc6dhytnVdrC69uwoH+JAvcuvhMy+C
	b6Dw8O5wBprW+h58aufMVgtxlDZZKaDy9CCaFKJdQPs0p2Vgu1+yXGa521w18e9x0+WL7n
	PpNr6UVJO2rN+xEEH0Cv8ZjrJS7zQ6M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IpMOnKmo;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761720022; a=rsa-sha256;
	cv=none;
	b=TPShehj7DfHZab/gt4xoeLrQ2gd/tj3kqXLFXOTXXEWHtO/UPSCe1+D9w9pgPfhqHqWu9Y
	GESihtWoO1zbWO1Idf4+xVagQXeTWQlfwuYO/YyxIrEe3ylCtH4Lk+dPoYD+ITQiKJhbVW
	SGItmV6mh8z3wYNXN0bguKTqtBi4G8E=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=R2FdD5J/Lr6BnGwMKRTDIEW2p4Dh3z/n14/cPtSxKg4=;
	b=IpMOnKmoS6zK+4EVtk8S3WHaTh5AL00RQBseN5kgB2Ev70POZb4Je5zUJWtprvuJpp47OgMEq
	MOXFez0vV1bPbCJ4ziREV4gK0zcNxU3m1eII/EP21O++DpFU7LSEZsnLYqk6jaxqESBjosdlxTd
	uSlw04DKUcdrRNDy8XH4TYQ=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cxHfV2CvBz1prQ0;
	Wed, 29 Oct 2025 14:39:46 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8643D18048D;
	Wed, 29 Oct 2025 14:40:15 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Oct 2025 14:40:15 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Oct 2025 14:40:14 +0800
Subject: Re: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Long long Xia <xialonglong2025@163.com>
CC: <markus.elfring@web.de>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <wangkefeng.wang@huawei.com>,
	<qiuxu.zhuo@intel.com>, <xu.xin16@zte.com.cn>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Longlong Xia
	<xialonglong@kylinos.cn>, <david@redhat.com>, <lance.yang@linux.dev>
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <20251016101813.484565-2-xialonglong2025@163.com>
 <af769443-e855-81d0-a44a-d5890f5d1d2f@huawei.com>
 <7c069611-21e1-40df-bdb1-a3144c54507e@163.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <db70f612-bbb1-0f9a-3dd6-884b1d64ab61@huawei.com>
Date: Wed, 29 Oct 2025 14:40:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <7c069611-21e1-40df-bdb1-a3144c54507e@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: xypsdszqttptw8d54jpfdz6stojfar3t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A494F1A0009
X-HE-Tag: 1761720020-442591
X-HE-Meta: U2FsdGVkX1/nJflsxM9MZL+HaE8JO4VfwVHhzFq+FG9cwck24BotAg7NcDQtEBsxktL7R9HLraXihTtGekW9iC/zUeu1kA1Yjp0XUyCHE+hZU6YZ32Jz0nwbpx0YqVuB8bjc1VUi7qMsOCL1w7/enjVQdsdb+EiDMeFwCxq9iDOpkqZk1klt2mOu1g4iZ5C03wNaT2rP1b0P9LF/Kl6cVjBSaGGnAsopkqMT4RqldxiQMg+CIdZ74OjOr/4OxOhfrLMBYBHHiFukVC8d4VptExPsFvzFaBiQBNx6UdNTgynHO4ER5YdvBs2Xb7UV4aMVSxKykUDvMDJZUAenjTdkIWRp76/CVW8sRY85QhNElSUEzOvBoZ/WwI0nOAfbIzlWe1nuQdz9Zi15e6Aih2i4nICy9z0EE7w/EOLiZWwJCZjGYdfzwmq5ufMFEdsyrYpxctz0Dx9HNbcdD0/ZBPUk1CtfMkj/rvOabDptXQ4cMEa9B/AYQLw01IRIJ8BA8I/NuZEV9LQvltVPomVAcIBl4JteG7HV+j17nGzRfmeADV6MkzgKoEfttdZ2l+mV2bT5z7ReZNWh2Y9PkS9fJXiugdfK55DpWYrfVtakSKazv8/Z9TpdFvRwghAdRzxURna4Os8H8jHTklpLYovUvXpHwKr4TsBWbc8F6biTKRLOm7UFar3XLBqw+xwuqDIcAnkWXLS3SvSv/1ONJpeQIED93bPcQfGCyFLmU9XJwGXWZKPj+lk50WnufKC1wcNjU9WrrnAA4XhnsdjUHtbChHgW+Uf3R3nYO2mZqj1ynQ6dctmcCZ55ef4xfeOCUHO/oTuZiOqZLxcOlzyo7L922H4z1EeCG6GP1X9+RDDTSP3v/xrdKyvaul2sKmPQAaqXzlOyJ+vb4KRZXrcnn904T9ymX7KeZTqn2l3BdFrCeH7srlxMgfGyJd4dflv2eQv9gv+FiofDMGKKH3N5Vex0y7/
 HdOyP14H
 viiLm4xOg02UjJ08gnds5gSd3k/BfKRR1A/hKqvvZVw7Z9SnGu3PAr4L6srd26BRmtCxauHlDzvpE95ASVe4oWuscJq0QtmGcMBktFPxY0nJ5UBl8823xp1sA5ybJgUxtkuBf6XEXgr6C6HrLvrPiMcVx5ObGcpvdWBszjCF1F1xTOW9kGzwS6U+BUyg+GggXpoy7CL2dDR8BZ5DoSlr6vvN3ElzpBNXJFXuSjAjQe/YD1u9zqqziMZnX4asnS5LvpzkSF8hWBXfwTv1BmCzkutYSFiEwHY4GUSKOcsbUGqVCG8gmRfwwqkb6pp0YLwBQKxBmGndMN5aExzUDzfziWM3M/r+m52vzHn4KuD/XZS8Ao5uY7+7mZb6AVYi1YqwFhacQ9SFpAws+OzFzTQ0C8MHhEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/28 15:54, Long long Xia wrote:
> Thanks for the reply.
> 
> 在 2025/10/23 19:54, Miaohe Lin 写道:
>> On 2025/10/16 18:18, Longlong Xia wrote:
>>> From: Longlong Xia <xialonglong@kylinos.cn>
>>>
>>> When a hardware memory error occurs on a KSM page, the current
>>> behavior is to kill all processes mapping that page. This can
>>> be overly aggressive when KSM has multiple duplicate pages in
>>> a chain where other duplicates are still healthy.
>>>
>>> This patch introduces a recovery mechanism that attempts to
>>> migrate mappings from the failing KSM page to a newly
>>> allocated KSM page or another healthy duplicate already
>>> present in the same chain, before falling back to the
>>> process-killing procedure.
>>>
>>> The recovery process works as follows:
>>> 1. Identify if the failing KSM page belongs to a stable node chain.
>>> 2. Locate a healthy duplicate KSM page within the same chain.
>>> 3. For each process mapping the failing page:
>>>     a. Attempt to allocate a new KSM page copy from healthy duplicate
>>>        KSM page. If successful, migrate the mapping to this new KSM page.
>>>     b. If allocation fails, migrate the mapping to the existing healthy
>>>        duplicate KSM page.
>>> 4. If all migrations succeed, remove the failing KSM page from the chain.
>>> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>>>     error) does the kernel fall back to killing the affected processes.
>>>
>>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> Thanks for your patch. Some comments below.
>>
>>> ---
>>>   mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 246 insertions(+)
>>>
>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>> index 160787bb121c..9099bad1ab35 100644
>>> --- a/mm/ksm.c
>>> +++ b/mm/ksm.c
>>> @@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>>   }
>>>     #ifdef CONFIG_MEMORY_FAILURE
>>> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
>>> +{
>>> +    struct ksm_stable_node *stable_node, *dup;
>>> +    struct rb_node *node;
>>> +    int nid;
>>> +
>>> +    if (!is_stable_node_dup(dup_node))
>>> +        return NULL;
>>> +
>>> +    for (nid = 0; nid < ksm_nr_node_ids; nid++) {
>>> +        node = rb_first(root_stable_tree + nid);
>>> +        for (; node; node = rb_next(node)) {
>>> +            stable_node = rb_entry(node,
>>> +                    struct ksm_stable_node,
>>> +                    node);
>>> +
>>> +            if (!is_stable_node_chain(stable_node))
>>> +                continue;
>>> +
>>> +            hlist_for_each_entry(dup, &stable_node->hlist,
>>> +                    hlist_dup) {
>>> +                if (dup == dup_node)
>>> +                    return stable_node;
>>> +            }
>>> +        }
>>> +    }
>> Would above multiple loops take a long time in some corner cases?
> 
> Thanks for the concern.
> 
> I do some simple test。
> 
> Test 1: 10 Virtual Machines (Real-world Scenario)
> Environment: 10 VMs (256MB each) with KSM enabled
> 
> KSM State:
> pages_sharing: 262,802 (≈1GB)
> pages_shared: 17,374 （≈68MB）
> pages_unshared = 124,057 (≈485MB)
> total ≈1.5GB
> chain_count = 9, not_chain_count = 17152
> Red-black tree nodes to traverse:
> 17,161 (9 chains + 17,152 non-chains)
> 
> Performance:
> find_chain: 898 μs (0.9 ms)
> collect_procs_ksm: 4,409 μs (4.4 ms)
> Total memory failure handling: 6,135 μs (6.1 ms)
> 
> 
> Test 2: 10GB Single Process (Extreme Case)
> Environment: Single process with 10GB memory,
> 1,310,720 page pairs (each pair identical, different from others)
> 
> KSM State:
> pages_sharing: 1,311,740 （≈5GB)
> pages_shared: 1,310,724 （≈5GB)
> pages_unshared = 0
> total ≈10GB
> Red-black tree nodes to traverse:
> 1,310,721 (1 chain + 1,310,720 non-chains)
> 
> Performance:
> find_chain: 28,822 μs (28.8 ms)
> collect_procs_ksm: 45,944 μs (45.9 ms)
> Total memory failure handling: 46,594 μs (46.6 ms)

Thanks for your test.

> 
> Summary:
> The find_chain function shows approximately linear scaling with the number of red-black tree nodes.
> With a 76x increase in nodes (17,161 → 1,310,721), latency increased by 32x (898 μs → 28,822 μs).
> representing 62% of total memory failure handling time (46.6ms).
> However, since memory failures are rare events, this latency may be acceptable
> as it does not impact normal system performance and only affects error recovery paths.
> 

IMHO, the execution time of a kernel function must not be too long without any scheduling points.
Otherwise it may affect the normal scheduling of the system and leads to something like performance
fluctuation. Or am I miss something?

Thanks.
.

