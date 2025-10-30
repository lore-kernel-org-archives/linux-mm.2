Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EEDCCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AD88E01BA; Wed, 29 Oct 2025 22:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A6B8E01B2; Wed, 29 Oct 2025 22:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5870C8E01BA; Wed, 29 Oct 2025 22:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46A2C8E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:56:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF724BB20E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:56:49 +0000 (UTC)
X-FDA: 84053268138.12.922466D
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id 508342000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:56:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=07btWpbi;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761793008; a=rsa-sha256;
	cv=none;
	b=02qFVYeJHR9JM3DFSGE+vrMD9pro43uJDmkmCq59YhxrX+ANcS4g1l/Ana0nwDnNIl08U2
	B3uYEsAB6yNmIKvyRVH1HdTzdyU272IJkvzkcVXx7Xn7KH3x0GvRL8Lk6pD67nmgkNOpY3
	B/nCUvCGu4YHlyV1uSDqKqjMKDUUSTU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=07btWpbi;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761793008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hQRTMFxdEmNDfeGmLa4tp3RC8FcGsqNeLnBB5VEq1c=;
	b=ex/EGv9F78tgsge23UqadQJBMjHNjIaHK179n1vQniVWBhtqeba9X2XiwjMjD4kzyiTCG3
	qbqZDhysZb2NU5lU5d4iKGRH7FEl3GyEY18DjN8PhPnHlHQoZRr9tyREyTi9Lel0BGON1e
	+4WoTnJppJsHe1IdtuEXaP1AgF2tq8w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0hQRTMFxdEmNDfeGmLa4tp3RC8FcGsqNeLnBB5VEq1c=;
	b=07btWpbiNwohyHweI9wu3LKC7j9YqX14x1hnrhD1+fM4hQbECyJblJChg2G+DUQNOyPl1NO3a
	+DhOrhcz9tOc0Af9ZY00AzcrDkVyplF1moRr/Up7Q8V067Tm13Y46+fC4fJqzhQd2YwVuikRMv3
	FRrgWfU7FV8AfF/YLPrIiao=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cxpd00sztzcZyk;
	Thu, 30 Oct 2025 10:55:16 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 5014F1400CA;
	Thu, 30 Oct 2025 10:56:41 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 10:56:41 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 10:56:40 +0800
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
 <db70f612-bbb1-0f9a-3dd6-884b1d64ab61@huawei.com>
 <394cb428-c37b-44c7-8367-4f76514a6322@163.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <64953691-ce0e-71d9-1ab3-7f8cefd6ace4@huawei.com>
Date: Thu, 30 Oct 2025 10:56:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <394cb428-c37b-44c7-8367-4f76514a6322@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 508342000E
X-Stat-Signature: fsqn1wiy5ytcz9iesddck75zchzbiz8d
X-HE-Tag: 1761793005-135553
X-HE-Meta: U2FsdGVkX18Wf3cXa77q75Yr9wOmSeqGIRkKHEVh6BpFn3tTsItY9CERemIWw1+RpzydZHV4JELw4XJOfNIJIbmvRiC3s/TJINjqAR4PlRyUEplzFsLKBPdprEUO+xS43IVnfHN4cG3fxlfWrtSu/XAFImF/M9a7AAeU/1RDcwNRB5eQ8o+1/FNaXwc6YJK0turySY+QoVttfitFT/suCsDIMyGEEputWr02yae0tBeIUVQpQ5FixH3EFSwmlFwlTg4FFJ7mHLBTWXBM4Hq7Al3Ln7Sd/XHLDf+hYpj1VIDz/jeOl2kW46IWw45G4saVX3X+CTmmi//CV2J3ImYeundKD4qQogjCWqlavfyQx/XAsS4jVn7941UIvFjVh6EWUjeWUDBtSgTClpe31bROWliC9jmK46ycLIOS+dnX2JcsbUvTDnax3m2UBGDAp5DSD0PSpd1b/AHJwbKfjE+h1b+bMJtScFWVU3kCKPwFWorJf19JBxv1XjGyIWEKQGy11JSp2zAh3q+91Mr4Ld1XVnTIR6WEqcOiLTEoZEYvv+Y38Vv+HSqqGD+uaccpwYGII0QK2jMBVVBAYE7l5vS3Ai4MZOgnjbRdJsQEvMiSlpBi9QLWa/VnSahAiSoLc5dwbMmxciIGYTBz0uHlEqgI6o7CHw3QEZqng2Up5PyzIILsqwDfDRUzIDkBU5VPAXkfMj7REoER9RlYSxdPCYelDDcclyFNiQg5/N96Krywm2ugzVtFoFJWtrSXfhb5tTMt/h0HZhxmk3f60qHMciz7zZ2pGo4Nkuta7HvOTiCQwgZfGHiQu0vwnVkr2I2Rj0jpEjuNigQmBfIHGgptPuhjDNLGcAJrwpfZQmvCmbNfnhV3OtYR7oIE1VkyviUxqa4hxFPO11qdUqJ8qLx+eswJ9r5amURB14lK3Nc6/fq63N2aKIiYhvBOdyLy1rb25i3H9V3dHIyvLXn7M0qvJVo
 ByH/kLn6
 HwAIxig8bbg5ad0fFt6ioxEkNi4dYD/VNcsAzhNSeMgx09tmEQxdqJeZY6twcfHgY83nHP3gnwCSTkVd2yuTublpI1YRVmMjETEI953QoY0kQMeJdbgXdp38H05X/Po5BcZiiDT4biezwjEjPcpfVjLmcHlpydeaVH0gexGi/hNHvnAjo5U9A1vxIXoRlQVamlpGlIflKVKO6SOxUXatU7EMt/+5AWqJ2BvnPQM4TQtUYGls1bZHshGnJQxz3rAxMxE9T2pFlnodf3Oqafl1P5A6Q7+awmIX9DyKeTDf9WReOmWk0uCWLAfc7Kh65lbm0IytT+1+t2QKSt5luXfsSrMH3e9rvaZ29dXYluNgdwh/QpZ7MpG+OjjrSFZP/uFGeApLD6TgTPiNd6rtSiqJojkIwZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/29 15:12, Long long Xia wrote:
> Thanks for the reply.
> 
> 
> 在 2025/10/29 14:40, Miaohe Lin 写道:
>> On 2025/10/28 15:54, Long long Xia wrote:
>>> Thanks for the reply.
>>>
>>> 在 2025/10/23 19:54, Miaohe Lin 写道:
>>>> On 2025/10/16 18:18, Longlong Xia wrote:
>>>>> From: Longlong Xia <xialonglong@kylinos.cn>
>>>>>
>>>>> When a hardware memory error occurs on a KSM page, the current
>>>>> behavior is to kill all processes mapping that page. This can
>>>>> be overly aggressive when KSM has multiple duplicate pages in
>>>>> a chain where other duplicates are still healthy.
>>>>>
>>>>> This patch introduces a recovery mechanism that attempts to
>>>>> migrate mappings from the failing KSM page to a newly
>>>>> allocated KSM page or another healthy duplicate already
>>>>> present in the same chain, before falling back to the
>>>>> process-killing procedure.
>>>>>
>>>>> The recovery process works as follows:
>>>>> 1. Identify if the failing KSM page belongs to a stable node chain.
>>>>> 2. Locate a healthy duplicate KSM page within the same chain.
>>>>> 3. For each process mapping the failing page:
>>>>>      a. Attempt to allocate a new KSM page copy from healthy duplicate
>>>>>         KSM page. If successful, migrate the mapping to this new KSM page.
>>>>>      b. If allocation fails, migrate the mapping to the existing healthy
>>>>>         duplicate KSM page.
>>>>> 4. If all migrations succeed, remove the failing KSM page from the chain.
>>>>> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>>>>>      error) does the kernel fall back to killing the affected processes.
>>>>>
>>>>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>>>> Thanks for your patch. Some comments below.
>>>>
>>>>> ---
>>>>>    mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>    1 file changed, 246 insertions(+)
>>>>>
>>>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>>>> index 160787bb121c..9099bad1ab35 100644
>>>>> --- a/mm/ksm.c
>>>>> +++ b/mm/ksm.c
>>>>> @@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>>>>    }
>>>>>      #ifdef CONFIG_MEMORY_FAILURE
>>>>> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
>>>>> +{
>>>>> +    struct ksm_stable_node *stable_node, *dup;
>>>>> +    struct rb_node *node;
>>>>> +    int nid;
>>>>> +
>>>>> +    if (!is_stable_node_dup(dup_node))
>>>>> +        return NULL;
>>>>> +
>>>>> +    for (nid = 0; nid < ksm_nr_node_ids; nid++) {
>>>>> +        node = rb_first(root_stable_tree + nid);
>>>>> +        for (; node; node = rb_next(node)) {
>>>>> +            stable_node = rb_entry(node,
>>>>> +                    struct ksm_stable_node,
>>>>> +                    node);
>>>>> +
>>>>> +            if (!is_stable_node_chain(stable_node))
>>>>> +                continue;
>>>>> +
>>>>> +            hlist_for_each_entry(dup, &stable_node->hlist,
>>>>> +                    hlist_dup) {
>>>>> +                if (dup == dup_node)
>>>>> +                    return stable_node;
>>>>> +            }
> may I add cond_resched(); here ？
>>>>> +        }
>>>>> +    }
>>>> Would above multiple loops take a long time in some corner cases?
>>> Thanks for the concern.
>>>
>>> I do some simple test。
>>>
>>> Test 1: 10 Virtual Machines (Real-world Scenario)
>>> Environment: 10 VMs (256MB each) with KSM enabled
>>>
>>> KSM State:
>>> pages_sharing: 262,802 (≈1GB)
>>> pages_shared: 17,374 （≈68MB）
>>> pages_unshared = 124,057 (≈485MB)
>>> total ≈1.5GB
>>> chain_count = 9, not_chain_count = 17152
>>> Red-black tree nodes to traverse:
>>> 17,161 (9 chains + 17,152 non-chains)
>>>
>>> Performance:
>>> find_chain: 898 μs (0.9 ms)
>>> collect_procs_ksm: 4,409 μs (4.4 ms)
>>> Total memory failure handling: 6,135 μs (6.1 ms)
>>>
>>>
>>> Test 2: 10GB Single Process (Extreme Case)
>>> Environment: Single process with 10GB memory,
>>> 1,310,720 page pairs (each pair identical, different from others)
>>>
>>> KSM State:
>>> pages_sharing: 1,311,740 （≈5GB)
>>> pages_shared: 1,310,724 （≈5GB)
>>> pages_unshared = 0
>>> total ≈10GB
>>> Red-black tree nodes to traverse:
>>> 1,310,721 (1 chain + 1,310,720 non-chains)
>>>
>>> Performance:
>>> find_chain: 28,822 μs (28.8 ms)
>>> collect_procs_ksm: 45,944 μs (45.9 ms)
>>> Total memory failure handling: 46,594 μs (46.6 ms)
>> Thanks for your test.
>>
>>> Summary:
>>> The find_chain function shows approximately linear scaling with the number of red-black tree nodes.
>>> With a 76x increase in nodes (17,161 → 1,310,721), latency increased by 32x (898 μs → 28,822 μs).
>>> representing 62% of total memory failure handling time (46.6ms).
>>> However, since memory failures are rare events, this latency may be acceptable
>>> as it does not impact normal system performance and only affects error recovery paths.
>>>
>> IMHO, the execution time of a kernel function must not be too long without any scheduling points.
>> Otherwise it may affect the normal scheduling of the system and leads to something like performance
>> fluctuation. Or am I miss something?
>>
>> Thanks.
>> .
> 
> I will add cond_resched()in the loop of red-black tree to allow scheduling in find_chain(), may be it is enough?

It looks work to me.

Thanks.
.

