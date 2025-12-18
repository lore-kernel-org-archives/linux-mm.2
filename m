Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8768ED6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAD96B0089; Thu, 18 Dec 2025 08:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A9F6B008A; Thu, 18 Dec 2025 08:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C942F6B008C; Thu, 18 Dec 2025 08:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2F7F6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:01:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 797B4C0155
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:01:18 +0000 (UTC)
X-FDA: 84232602636.24.BB96245
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7BBEB40005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:01:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SEdTet5h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062876; a=rsa-sha256;
	cv=none;
	b=ouMEqj1xIenjCBYX2indJWzGBG7eSWhbgk3Hna6z3ulQkH7GDZ8FE4DZlTfHkhnSa80Qf7
	LLm/2c64pj2C96hILbJYiqTjB2A37QpjhUGQ0tvSS1oBGHej3nXhnr7TRo1TV8JlxFeFYf
	PEziSVzi+KqIAnA84AWJuynpwDBl0Lo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SEdTet5h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fhAxNBkZvzSd2fHbQh2tDrHQZkQx5sWn3l+p/o/E8Q=;
	b=1/Jt1X557eyyqgDXJB+7aR1XxnH5jIXKPF5sY5MiYhlP4wf34bx4pxZfe61MSeMiNlTi4X
	CY1u10Rxq0PpauTIGooH9HPQa4gflR39V7VdANMmcpIgv7E7z+v73V3cBnfDEPJLhNCBAP
	AgKD/0u5kfZwCcg7APB/AVuIOSad2CQ=
Message-ID: <3c32d80a-ba0e-4ed2-87ae-fb80fc3374f7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766062869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fhAxNBkZvzSd2fHbQh2tDrHQZkQx5sWn3l+p/o/E8Q=;
	b=SEdTet5hPnFsPgIW/3Ked4lMxNyGaR8bXywSfUqJ8il0v4bSoUw+RR4+SYdKpVn0eDCKe1
	vGGTrfKrIRypODY1FnZzLP6m3+ob7vnBehCZpZcY2GWy0V8nSWYIROMhcJB1zl0N5JNZ6H
	W5k9IvQQ0QkpOnvStZGedD0aFZuvlhw=
Date: Thu, 18 Dec 2025 21:00:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
 <d62756d4-c249-474e-ae80-478d3c7cf34d@kernel.org>
 <4effa243-bae3-45e4-8662-dca86a7e5d12@linux.dev>
 <11a60eba-3447-47de-9d59-af5842f5dc5e@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <11a60eba-3447-47de-9d59-af5842f5dc5e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7BBEB40005
X-Stat-Signature: cth4a4wmw5ryrffi3qbhg7r7f8c5q333
X-HE-Tag: 1766062876-395195
X-HE-Meta: U2FsdGVkX1/wEEq+/DEoX1rzzHrDrAMonrH7GG2Omws9wwu/kxZN64XTwjEyulaDAKp9NboprjAv2usaGmURdP1F0sM076DR9MbgiYX/Gru+LbeqfK9dZpzxn/YmKu4XPBMYaTL9BEYu0voFjaTR3k/OyTvq/AIIwWkyVTb7RaW/LbrdzM9V1Q/cFDC9iop8+cjfoOnf6pnYXOQgB8Ial78ndQPdEangQ9/tCSWF1k7gMSNlrZCrdVfXp4eFhn8GnHbeU/w2OpafBFvYitU7sz79+OzWQWBfaaIdIHrakDYzEg+v0q/H4KoPCaghNOn4z4dpBAozzNw33hTqtlTTlLWx7bbeZgB29chY7lfzLoQ2thm593hORPRhVguNBCksM/bCLZqL/6u1+jDkrMxOgqtSS3KHiuTylrj1D6eKUwBeE5oLFLyFSAv8eCPK7zlcX93mRVARm4fgMWKA5vn4Us4L9wQbtGN5KKNQgqVlj6QQT93I79TqmoADZLmCbmeZe4KGTDhICvLYWn4+cOXup71ayhksG9HvDdX0gfkCXbijbnjOu+WFj62gmUDDpkeylxLdf7iX/oLtywv6TtB76V3nQCR6uvdO/GYJqwhD5GGYtxlZxyhJjKZQyKPTvUJLuRN+XWbLWoh426Y3NOrkNcxOeeBMAWnUYlo3hMlhtDyKJtOPOSJUQOoQg+OqqlIcywBWJF6eQMYpkSQiI5TD6AFw08e7cTh6sZyy2Jj5oDkp9UTMRhyqCcGWpmcRF00tYHcsztt2X1DFDRe3FEz/KjNdF0qXLNbrEHJN6GGsHEakNqq9Er63CH5t9mEDqqvzIjCNmf+NNSuIQDnGdXCy33PwVPwD8JhcZx2wtvTX/A8oujKxs54W5QDPxBhLQ1WymejaXhJOHS3UKQfNR19r2F+8049KNKXiziMhjbrOhCOF7D9hoekwT0Oticbev0RyDRVpbfO2rtw+EqB0bY5
 NzCALMW6
 +gbH8EhwhnyEbRuumuRn3FoW9qq5RUD68Kw8ljE4tVacjcag+e5j3aMHgZx0mIapHfeu8OFUxlPhC9Yjlu6mzV1BuxtjTbIY8/oNXCYyqJ0wuNgJLu6KTQNX4OBhCTgglLOReIobY0uwmX9RbaQsIUP7MLxF82168MLsyFf84lHfvu637NYtcx+7Axvf7Sx6kjG2XjDA4MjfFqhHD/BeseVoeVfTsWyNN81972miJaiVxgLdX8CFiCCVisCtJA7B1grYEOTxE2ZDol1fRRB7X7xs6FLGha4fGIosqC67TJExQmv10HIgpaqbErwI/+tmuhbi3ldYyF6Ji4+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 7:56 PM, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 12:40, Qi Zheng wrote:
>>
>>
>> On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
>>> On 12/18/25 10:36, Qi Zheng wrote:
>>>>
>>>>
>>>> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>>>>> On 12/17/25 08:27, Qi Zheng wrote:
>>>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>>>
>>>>>> In the near future, a folio will no longer pin its corresponding
>>>>>> memory cgroup. To ensure safety, it will only be appropriate to
>>>>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>>>>> returned by folio_memcg(), thereby preventing it from being released.
>>>>>>
>>>>>> In the current patch, the rcu read lock is employed to safeguard
>>>>>> against the release of the memory cgroup in folio_migrate_mapping().
>>>>>
>>>>> We usually avoid talking about "patches".
>>>>
>>>> Got it.
>>>>
>>>>>
>>>>> In __folio_migrate_mapping(), the rcu read lock ...
>>>>
>>>> Will do.
>>>>
>>>>>
>>>>>>
>>>>>> This serves as a preparatory measure for the reparenting of the
>>>>>> LRU pages.
>>>>>>
>>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>>>> ---
>>>>>>     mm/migrate.c | 2 ++
>>>>>>     1 file changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>>> index 5169f9717f606..8bcd588c083ca 100644
>>>>>> --- a/mm/migrate.c
>>>>>> +++ b/mm/migrate.c
>>>>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>>>>> address_space *mapping,
>>>>>>             struct lruvec *old_lruvec, *new_lruvec;
>>>>>>             struct mem_cgroup *memcg;
>>>>>> +        rcu_read_lock();
>>>>>>             memcg = folio_memcg(folio);
>>>>>
>>>>> In general, LGTM
>>>>>
>>>>> I wonder, though, whether we should embed that in the ABI.
>>>>>
>>>>> Like "lock RCU and get the memcg" in one operation, to the "return 
>>>>> memcg
>>>>> and unock rcu" in another operation.
>>>>
>>>> Do you mean adding a helper function like get_mem_cgroup_from_folio()?
>>>
>>> Right, something like
>>>
>>> memcg = folio_memcg_begin(folio);
>>> folio_memcg_end(memcg);
>>
>> For some longer or might-sleep critical sections (such as those pointed
>> by Johannes), perhaps it can be defined like this:
>>
>> struct mem_cgroup *folio_memcg_begin(struct folio *folio)
>> {
>>     return get_mem_cgroup_from_folio(folio);
>> }
>>
>> void folio_memcg_end(struct mem_cgroup *memcg)
>> {
>>     mem_cgroup_put(memcg);
>> }
>>
>> But for some short critical sections, using RCU lock directly might
>> be the most convention option?
>>
> 
> Then put the rcu read locking in there instead?

So for some longer or might-sleep critical sections, using:

memcg = folio_memcg_begin(folio);
do_some_thing(memcg);
folio_memcg_end(folio);

for some short critical sections, using:

rcu_read_lock();
memcg = folio_memcg(folio);
do_some_thing(memcg);
rcu_read_unlock();

Right?


> 


