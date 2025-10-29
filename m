Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8508CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 07:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E12E8E0039; Wed, 29 Oct 2025 03:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092428E0015; Wed, 29 Oct 2025 03:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11278E0039; Wed, 29 Oct 2025 03:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E17948E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:13:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 739D588D64
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:13:19 +0000 (UTC)
X-FDA: 84050285718.23.3C2C5CD
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id E2789C0005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:13:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XGOPVyJ+;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf10.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761721997; a=rsa-sha256;
	cv=none;
	b=wB70FqSaXfOUXAWOJS0S49ad6Vwd6mpTLjF4AuMVC8f131qJKM6Zylfqe2ySQppVpkvBAP
	Y6YKGPMYkFFnIFxKySTRLHWJFrb9kbVnLcUgT6GaDJeSVvhrs7mKLz9byy906TejKrfEC/
	2tKUpLe+MSTdjdSNvuWjfhH062zDEvA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XGOPVyJ+;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf10.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761721997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylyZdhTdDFBEfzFVzWFW5oVHoSQafpEzmCbLwEsvc80=;
	b=Ggi7EGTEpyzNtASGEwWqoDIWy0dhiCtMl1FBtiRhEnBioT/0oReEXdGwhSLzJV5+akq0nf
	SNrw6ywrcKi65Ih2X+DqECjQjIiFjLfnx3cI+k7iLR7VYyBOb6CYl0VDScjfvrRTiikeEa
	2a2CkGVy5mvLUwC3wtZ45A89uj1uNyk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=ylyZdhTdDFBEfzFVzWFW5oVHoSQafpEzmCbLwEsvc80=;
	b=XGOPVyJ+6hI3WFdjUEo1vmSyGCLYDUOC3RwZvBiB99Y26hBP8mv4Jrl7UCAg4T
	xb77PF5twHA/DYl54XCrj5+LkzMsncjlE8yBkxrM7ql/7K/FfvD8XmrQ9mpUZXNU
	Ok6wwAFOWGo0/ZDYdtpWdq1Fgc66HF/I+9WrWjdmRMnwM=
Received: from [IPV6:240e:46c:1010:504f:3180:9bac:32c0:30b] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wAndmltvgFplf2dAA--.107S2;
	Wed, 29 Oct 2025 15:13:05 +0800 (CST)
Message-ID: <394cb428-c37b-44c7-8367-4f76514a6322@163.com>
Date: Wed, 29 Oct 2025 15:12:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: markus.elfring@web.de, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, qiuxu.zhuo@intel.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, david@redhat.com, lance.yang@linux.dev
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <20251016101813.484565-2-xialonglong2025@163.com>
 <af769443-e855-81d0-a44a-d5890f5d1d2f@huawei.com>
 <7c069611-21e1-40df-bdb1-a3144c54507e@163.com>
 <db70f612-bbb1-0f9a-3dd6-884b1d64ab61@huawei.com>
From: Long long Xia <xialonglong2025@163.com>
In-Reply-To: <db70f612-bbb1-0f9a-3dd6-884b1d64ab61@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAndmltvgFplf2dAA--.107S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw47Gw4kZF1rXrWfCw43GFg_yoW7JFW7pF
	y8Aa43Kr4rXFyfGr1Sqw4jyrySv3yktr4UXrWakw1xA3Z0yr97tr4Fgw1YgFy8ur4rGw4Y
	qF4Ygry3GrsYqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jxl1kUUUUU=
X-Originating-IP: [240e:46c:1010:504f:3180:9bac:32c0:30b]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbBgAH1+GkBtkvUbQAAsg
X-Stat-Signature: pjnp466dp13isgsaaqam35zsxx3mn436
X-Rspamd-Queue-Id: E2789C0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761721996-315327
X-HE-Meta: U2FsdGVkX18O7KG7wEhqP50QCmjJbTAjnx+Heit42DHA8MuJkCJAqju94bovNWmdV37BCL8Df9gtXcbOVm6SA3bF5J35HgVkWKyXIWk38bXEN2kRchEIPYq4T7TAccVMIAnHs8POQfQreWhYeavDuQVmtH/OnGFf5uICLOvnnqFHlUcocF0zBiEGV4RLuaB18+UvZNZAeF563oiKoL5WD046IkRw45tzuofxxhs4cV6U0L+IGQQsAmpD3fzAp4Nb1q4UFJI13UtZDycq0ut7BH/GnobKNXK4jw4lf/NsR1BWge4QfPfPoSDqjwn1IHrXbK/SU+owFvzjsiFkaOPeBg3BaHFhuKAkSU6FFrBxk3PixgG6ZObNV3J3/sdyirCwP7/sX/waXBCE0YZAjdoMSb/EAa8+iA8mDxZdGlaY29P53uWAzrA/pYWpkSlKRtjJqunrKemXGd7VpytcUTkDZi6xNVcsrEyfiZusJ5h2OG+xTOoJtowbOXBjLeWOkPzU6ZCdbCeIZznUjfrHqpOJC96XXi50uqzXiYPxUznkijv/3ytbgefFUA4qE62035WbHT/o1jUICxpf3DPUTWsOPnlftVKNnauijd+E15Sx1VsF8/6wdTGnxkx3NSFIX9NI18Gf316m3aRtc044p6mimhR/TBFYcRV/rwLv+tVIM9LGJzW6H629woEJs6CvyeC7UfJuAkqDAEzMIuxi6TEy/VfmBWh8yGXeboZHc4y3CreVUhqCrUj/Qfj8COTOq8JhbOw9cH24qpkQdgsThcvF0MUT6z/abUr9t8bGjuelxm0M4BtnMySCtOW0pK/Hedu9IyQJL43WMoDKiI1Gzv78w8feRkUITD7SFBiYyxwHKfLRGkTKvsQ5AI074SsxcaKR5gtfVq+t1YtkStr3aQ8hLR+DWzvhgHVmsOd7bzszNhNvnfz1q7QdZhLvrCaw5gzgZK9D0sFvFBgZGTpzdUD
 AvjIkPUC
 6KXWXy+5r8UbirqC5KUZIWeIqLOG7cdSH3ZEyynJlhnY8AxFgSBzchqMw7vwtjgBrRdiZUWTnjJpiaQvC1NrLOAQomdqRVIF7KhlQZ/zHs+LNLKg9Ckezle0BqvyUci4fexEf4TXBlD5ARhcy16n6asIhzsH4cChzUtBomoqktZqvXFYr9q9bcS9oI0/cSYmeByt3cw5OXqUNwHWekVlHMNZLSHy5ptRGL4HLUDlNOePC7zgYmMqAV3lhiTCm8WsoFGYyQzQfoe7MoKWYAe4Ub+gzeCYNu1ctSFyFfGeQlAVGh2A7loJTq3o7u1P0XPB9eAp1qVJuG2FYsxKDIqFbcdevZtohbRWZHebbgNTvsk/t+9uFVD3RGpbh6AT3zhhj0+CC/IboM5bFTRRjafzwo0n/7GhpmhFmyCJJx3aHfMW+lxgPH0nZHeSNwndLY73/MG+QHr/3T5fPwofmuZYgjoT9eQjbrbMMAGmnsuTe2uY3Nhlspz6wrXxOoD0xx6X7ClMzN1/mGZRWEiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the reply.


在 2025/10/29 14:40, Miaohe Lin 写道:
> On 2025/10/28 15:54, Long long Xia wrote:
>> Thanks for the reply.
>>
>> 在 2025/10/23 19:54, Miaohe Lin 写道:
>>> On 2025/10/16 18:18, Longlong Xia wrote:
>>>> From: Longlong Xia <xialonglong@kylinos.cn>
>>>>
>>>> When a hardware memory error occurs on a KSM page, the current
>>>> behavior is to kill all processes mapping that page. This can
>>>> be overly aggressive when KSM has multiple duplicate pages in
>>>> a chain where other duplicates are still healthy.
>>>>
>>>> This patch introduces a recovery mechanism that attempts to
>>>> migrate mappings from the failing KSM page to a newly
>>>> allocated KSM page or another healthy duplicate already
>>>> present in the same chain, before falling back to the
>>>> process-killing procedure.
>>>>
>>>> The recovery process works as follows:
>>>> 1. Identify if the failing KSM page belongs to a stable node chain.
>>>> 2. Locate a healthy duplicate KSM page within the same chain.
>>>> 3. For each process mapping the failing page:
>>>>      a. Attempt to allocate a new KSM page copy from healthy duplicate
>>>>         KSM page. If successful, migrate the mapping to this new KSM page.
>>>>      b. If allocation fails, migrate the mapping to the existing healthy
>>>>         duplicate KSM page.
>>>> 4. If all migrations succeed, remove the failing KSM page from the chain.
>>>> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>>>>      error) does the kernel fall back to killing the affected processes.
>>>>
>>>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>>> Thanks for your patch. Some comments below.
>>>
>>>> ---
>>>>    mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 246 insertions(+)
>>>>
>>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>>> index 160787bb121c..9099bad1ab35 100644
>>>> --- a/mm/ksm.c
>>>> +++ b/mm/ksm.c
>>>> @@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>>>    }
>>>>      #ifdef CONFIG_MEMORY_FAILURE
>>>> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
>>>> +{
>>>> +    struct ksm_stable_node *stable_node, *dup;
>>>> +    struct rb_node *node;
>>>> +    int nid;
>>>> +
>>>> +    if (!is_stable_node_dup(dup_node))
>>>> +        return NULL;
>>>> +
>>>> +    for (nid = 0; nid < ksm_nr_node_ids; nid++) {
>>>> +        node = rb_first(root_stable_tree + nid);
>>>> +        for (; node; node = rb_next(node)) {
>>>> +            stable_node = rb_entry(node,
>>>> +                    struct ksm_stable_node,
>>>> +                    node);
>>>> +
>>>> +            if (!is_stable_node_chain(stable_node))
>>>> +                continue;
>>>> +
>>>> +            hlist_for_each_entry(dup, &stable_node->hlist,
>>>> +                    hlist_dup) {
>>>> +                if (dup == dup_node)
>>>> +                    return stable_node;
>>>> +            }
may I add cond_resched(); here ？
>>>> +        }
>>>> +    }
>>> Would above multiple loops take a long time in some corner cases?
>> Thanks for the concern.
>>
>> I do some simple test。
>>
>> Test 1: 10 Virtual Machines (Real-world Scenario)
>> Environment: 10 VMs (256MB each) with KSM enabled
>>
>> KSM State:
>> pages_sharing: 262,802 (≈1GB)
>> pages_shared: 17,374 （≈68MB）
>> pages_unshared = 124,057 (≈485MB)
>> total ≈1.5GB
>> chain_count = 9, not_chain_count = 17152
>> Red-black tree nodes to traverse:
>> 17,161 (9 chains + 17,152 non-chains)
>>
>> Performance:
>> find_chain: 898 μs (0.9 ms)
>> collect_procs_ksm: 4,409 μs (4.4 ms)
>> Total memory failure handling: 6,135 μs (6.1 ms)
>>
>>
>> Test 2: 10GB Single Process (Extreme Case)
>> Environment: Single process with 10GB memory,
>> 1,310,720 page pairs (each pair identical, different from others)
>>
>> KSM State:
>> pages_sharing: 1,311,740 （≈5GB)
>> pages_shared: 1,310,724 （≈5GB)
>> pages_unshared = 0
>> total ≈10GB
>> Red-black tree nodes to traverse:
>> 1,310,721 (1 chain + 1,310,720 non-chains)
>>
>> Performance:
>> find_chain: 28,822 μs (28.8 ms)
>> collect_procs_ksm: 45,944 μs (45.9 ms)
>> Total memory failure handling: 46,594 μs (46.6 ms)
> Thanks for your test.
>
>> Summary:
>> The find_chain function shows approximately linear scaling with the number of red-black tree nodes.
>> With a 76x increase in nodes (17,161 → 1,310,721), latency increased by 32x (898 μs → 28,822 μs).
>> representing 62% of total memory failure handling time (46.6ms).
>> However, since memory failures are rare events, this latency may be acceptable
>> as it does not impact normal system performance and only affects error recovery paths.
>>
> IMHO, the execution time of a kernel function must not be too long without any scheduling points.
> Otherwise it may affect the normal scheduling of the system and leads to something like performance
> fluctuation. Or am I miss something?
>
> Thanks.
> .

I will add cond_resched()in the loop of red-black tree to allow 
scheduling in find_chain(), may be it is enough?

Best regards,
Longlong Xia


