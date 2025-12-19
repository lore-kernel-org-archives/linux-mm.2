Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8E4D7495A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F036B008A; Fri, 19 Dec 2025 01:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076D06B008C; Fri, 19 Dec 2025 01:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF916B0092; Fri, 19 Dec 2025 01:18:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9DDA6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:18:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 748C01A0424
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:18:36 +0000 (UTC)
X-FDA: 84235216632.09.D09E865
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE32DC000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:18:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqgGZDtI;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766125114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfaVF9h7+k3nDM/rgQDYjbWkYDW+uVQm3XtwB/toh3w=;
	b=Wx2MsqksIeqB3fDAhg9+F3WVlv8GnolXvIUA4+rsFdMo4Q3W8CD2DVu4US1FVJdPOUNWAm
	9+S9Fs1spRnHomC4vsmKskVNY/U1uqxKaAfs+O7tPEN29UOM0PPYvR3v0fcZoRoWLKf+ox
	D/Xq2l6upKr0IJrDdDCz8cWAHNhhxCg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqgGZDtI;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766125114; a=rsa-sha256;
	cv=none;
	b=LJu//yAC8L+XpeN0rlw4ED8y0MTeGk0LjYL7EsanZAYsVaGwbEfxOmeu7ht5sO+5HL7G6P
	8AcIuoFsyTYm1n7pWJoOOa0WW9NrTkmgP3m6DGrys8H8K1JlRT/LKk53Q7d3Bkv4n4wBTG
	Q5hHzBP5myPSAonICNpKizLxfaCNm3w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E60860008;
	Fri, 19 Dec 2025 06:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32648C4CEF1;
	Fri, 19 Dec 2025 06:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766125113;
	bh=xMlIHS8RXqYBLJVVEzUZMFwENBOT//REo0D9YNRvPpU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gqgGZDtI1zhIVleIDAu0xskWmE2Fgbb2lH2Cz0pdmMBcNwjk/LP2OLp6DR8sE/ncy
	 JtEBvuEw8OFnUCfpw+z7srVGdjs1qv3OQ1JkobH4OzPRQfbisNpbB05U3+sd8bOwI/
	 JcuuwoAMEzD3Svwp/O/KZ1rxsdZkIWAWzS4W5RQ+QwBUf6+rh5TEC6X2ivhlRod2cy
	 tWyT+yEe0d+uJ+WHQo415+9ft7U2x7LtPu22tFVp/1GYVihMOWQlepnAPcCAsJM70e
	 NOxy3x+GSmfieI7dfWpIOeUmfBv4H7puXAAU4YwJiJHg0gXzyKhS0Z7zqTCKPAtruT
	 ED/lw+zbKuf1w==
Message-ID: <1b87adbb-a34d-4c7e-98d4-664ccf71fc60@kernel.org>
Date: Fri, 19 Dec 2025 07:18:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
 <d62756d4-c249-474e-ae80-478d3c7cf34d@kernel.org>
 <4effa243-bae3-45e4-8662-dca86a7e5d12@linux.dev>
 <11a60eba-3447-47de-9d59-af5842f5dc5e@kernel.org>
 <3c32d80a-ba0e-4ed2-87ae-fb80fc3374f7@linux.dev>
 <49341ca3-1fc9-43d9-abbd-ecaabdda6ce0@kernel.org>
 <a35751e3-9c06-4e02-81f0-c211d4383e5f@linux.dev> <aUTQuyUV4_ed9tSU@hyeyoo>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUTQuyUV4_ed9tSU@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9664e3z3os97nkryhhkf55sfn5w5ptzc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE32DC000C
X-HE-Tag: 1766125114-375107
X-HE-Meta: U2FsdGVkX1/PPVE443TCBCCA7E8HWKzM2CI8QiV6pBCMrNekg7LakmqgHIrzgR7fh949t9QzV/DQ2z3urcRguKyTSSLl86KVptAGQonW4XH/SncpSfxVKqGp0cp7ampvv8JconTgFTewVdNRj8WDRt9v/Wak2wCCu18ZJbfX2jmBEvrG6LWUcOIQNEho7tp6kPmXfgI8pVQmktLO2f9uZGqe6Rol0k51wZbjCWe2QaYx24rQgIabVtiBJ4C5DuvawOj9roMxc4lfc3LCuPx6/xiPKievinwL/h93uCfsPq2zJRZT1rR3Vru+LCGLCXOMfIjQBaChEopq1Iv2F5meJLYJOjQuUdrAjaRirK8liORW1ixAYxybNxRLkpnEv3IRVQJywJDI7Lk/vylyAmgpFpiPgXV8gF9pY+Tts4WxtQ9W9fMchcLNkTE4BoTC/IRZN8RBeeLcQIpkaZ7S4H6mavNm2ygGCZU33OMmkjfzYvBjfA7v7H2XCidTXl9TOrpI1f0ojwYf8g62MjD8PW8XFiNSb/WX6hYdZnsYndqiclnEv5iXT1NOzS6jijvvrpDAWg/iQauM+Vwap+hcuzaX/uAcg384plpLFvXtYFB1/yE5itJWt8C3L1UxS9omrbT0Escg4TzJvdwo7LyNqcsNlQpyNBz3FKTuwE1Uttx8qWRjkJPjE8ymnJ3WpKjE0VnbItPpfohOd0Q7O6Nlf32w5AV2VeFiM8slbw4VvHBLgLtjevWSnTZzYJothaIC4b9Onug0Jx8uODnkuEuNR7zFb+R/daSZ7+hdGvThUKAu05+H6O4j/c6M/xrtR2j/2f/ycZRcmmZ9Jem+kGRy3uVHE7pMMFFLJVkOVmucp6lyc9caA+N5p/GBZC+NXV9MkZILw5unmsryJ3ev9Tjl4tbLABYfkKqcBT2YofDyWVBeu26irgI+ocMG+mdB+QpPfQXBvmXtNzxRW24CJayh4Pk
 FTbOjXz9
 VQPZu7ee3K/butTyr0CoFKsbEM4rE6BCYG8S7h/QyT++4TYf3jSrEASTmZKWI+dAAv3F8bui1JlZko1PcFCqH9FAR++2EMMK5a6nJTAf7Y6rW8JrmgIcY2f2diumv7RRrcr9ffwUjiTjYa8Xd1p1y6Y1Ju6sfMvHY9lm0VNqntAdiZTYedvf2TPYgGohWWH5wICfhkve3cYaJDgw2uSUohpW8b1HMhf9FtTiUKvXz6dF5YOiRo7Mb9CM2E/BGerHIx9Zc3teoCKjnLFVpXA/LPdp2/7NyjPDgbmaB1FTAZsaNngNu28wJXzmVfCccJGQjTUzZUYQfSqCIJ/tTmz97tLA9CdCegcxHvIgbEJDvLOaORdcpBnCOBGEjVQ6otbwrpq1Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 05:12, Harry Yoo wrote:
> On Thu, Dec 18, 2025 at 09:16:11PM +0800, Qi Zheng wrote:
>>
>>
>> On 12/18/25 9:04 PM, David Hildenbrand (Red Hat) wrote:
>>> On 12/18/25 14:00, Qi Zheng wrote:
>>>>
>>>>
>>>> On 12/18/25 7:56 PM, David Hildenbrand (Red Hat) wrote:
>>>>> On 12/18/25 12:40, Qi Zheng wrote:
>>>>>>
>>>>>>
>>>>>> On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
>>>>>>> On 12/18/25 10:36, Qi Zheng wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>>>>>>>>> On 12/17/25 08:27, Qi Zheng wrote:
>>>>>>>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>>>>>>>
>>>>>>>>>> In the near future, a folio will no longer pin its corresponding
>>>>>>>>>> memory cgroup. To ensure safety, it will only be appropriate to
>>>>>>>>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>>>>>>>>> returned by folio_memcg(), thereby
>>>>>>>>>> preventing it from being released.
>>>>>>>>>>
>>>>>>>>>> In the current patch, the rcu read lock is employed to safeguard
>>>>>>>>>> against the release of the memory cgroup in
>>>>>>>>>> folio_migrate_mapping().
>>>>>>>>>
>>>>>>>>> We usually avoid talking about "patches".
>>>>>>>>
>>>>>>>> Got it.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> In __folio_migrate_mapping(), the rcu read lock ...
>>>>>>>>
>>>>>>>> Will do.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> This serves as a preparatory measure for the reparenting of the
>>>>>>>>>> LRU pages.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>>>>>>>> ---
>>>>>>>>>>       mm/migrate.c | 2 ++
>>>>>>>>>>       1 file changed, 2 insertions(+)
>>>>>>>>>>
>>>>>>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>>>>>>> index 5169f9717f606..8bcd588c083ca 100644
>>>>>>>>>> --- a/mm/migrate.c
>>>>>>>>>> +++ b/mm/migrate.c
>>>>>>>>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>>>>>>>>> address_space *mapping,
>>>>>>>>>>               struct lruvec *old_lruvec, *new_lruvec;
>>>>>>>>>>               struct mem_cgroup *memcg;
>>>>>>>>>> +        rcu_read_lock();
>>>>>>>>>>               memcg = folio_memcg(folio);
>>>>>>>>>
>>>>>>>>> In general, LGTM
>>>>>>>>>
>>>>>>>>> I wonder, though, whether we should embed that in the ABI.
>>>>>>>>>
>>>>>>>>> Like "lock RCU and get the memcg" in one operation, to the "return
>>>>>>>>> memcg
>>>>>>>>> and unock rcu" in another operation.
>>>>>>>>
>>>>>>>> Do you mean adding a helper function like
>>>>>>>> get_mem_cgroup_from_folio()?
>>>>>>>
>>>>>>> Right, something like
>>>>>>>
>>>>>>> memcg = folio_memcg_begin(folio);
>>>>>>> folio_memcg_end(memcg);
>>>>>>
>>>>>> For some longer or might-sleep critical sections (such as those pointed
>>>>>> by Johannes), perhaps it can be defined like this:
>>>>>>
>>>>>> struct mem_cgroup *folio_memcg_begin(struct folio *folio)
>>>>>> {
>>>>>>       return get_mem_cgroup_from_folio(folio);
>>>>>> }
>>>>>>
>>>>>> void folio_memcg_end(struct mem_cgroup *memcg)
>>>>>> {
>>>>>>       mem_cgroup_put(memcg);
>>>>>> }
>>>>>>
>>>>>> But for some short critical sections, using RCU lock directly might
>>>>>> be the most convention option?
>>>>>>
>>>>>
>>>>> Then put the rcu read locking in there instead?
>>>>
>>>> So for some longer or might-sleep critical sections, using:
>>>>
>>>> memcg = folio_memcg_begin(folio);
>>>> do_some_thing(memcg);
>>>> folio_memcg_end(folio);
>>>>
>>>> for some short critical sections, using:
>>>>
>>>> rcu_read_lock();
>>>> memcg = folio_memcg(folio);
>>>> do_some_thing(memcg);
>>>> rcu_read_unlock();
>>>>
>>>> Right?
>>>
>>> What I mean is:
>>>
>>> memcg = folio_memcg_begin(folio);
>>> do_some_thing(memcg);
>>> folio_memcg_end(folio);
>>>
>>> but do the rcu_read_lock() in folio_memcg_begin() and the
>>> rcu_read_unlock() in folio_memcg_end().
>>>
>>> You could also have (expensive) variants, as you describe, that mess
>>> with getting/dopping the memcg.
>>
>> Or simple use folio_memcg_begin(memcg)/folio_memcg_end(memcg) in all cases.
>>
>> Or add a parameter to them:
>>
>> struct mem_cgroup *folio_memcg_begin(struct folio *folio, bool get_refcnt)
>> {
>> 	struct mem_cgroup *memcg;
>>
>> 	if (get_refcnt)
>> 		memcg = get_mem_cgroup_from_folio(folio);
>> 	else {
>> 		rcu_read_lock();
>> 		memcg = folio_memcg(folio);
>> 	}
>>
>> 	return memcg;
>> }
>>
>> void folio_memcg_end(struct mem_cgroup *memcg, bool get_refcnt)
>> {
>> 	if (get_refcnt)
>> 		mem_cgroup_put(memcg);
>> 	else
>> 		rcu_read_unlock();
>> }
> 
> I would like to vote for open coding as we do now, because I think hiding
> the RCU lock / refcount acquisition into a less obvious API doesn't make
> it more readable.

I wouldn't do it in an API as proposed above.

I prefer to not have magical RCU locking in every caller. Easy to get wrong.

See how we did something similar in the pte_*map*() vs. pte_unmap() API, 
without requiring all callers to open-code this.

-- 
Cheers

David

