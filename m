Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE4CD6ACE9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B396B0088; Thu, 18 Dec 2025 06:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7222D6B0089; Thu, 18 Dec 2025 06:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631A06B008A; Thu, 18 Dec 2025 06:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 541E26B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:41:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2E8E13C216
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:41:20 +0000 (UTC)
X-FDA: 84232401120.24.D641351
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 034381A0015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:41:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E7H2Crh7;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058079; a=rsa-sha256;
	cv=none;
	b=7rnbuVbQHr4SLx7ogUiqwDSQsMv4x5g/mjGp5qoMgIkkj1gy/g7hc8PIB+5jhqeoqK2n9W
	JrD77kWBP9B0ed40osRe7Ka+4dW7nS5/KJcQsFJp/pLvFQrTcMYqQEapsXlKx03+qOA0Se
	Fvn+sCaTZ26XL6ol6OUMSGAvqNhwdb8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E7H2Crh7;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bv+aDdmLUwbT/Rl2vd0tHpuESUGfI/xwE/ZSUQEBgM=;
	b=IravL+Lv8DqMC7ximV/PoWCidgVztZqxkB/yKaRthp54RMT9RrOr5ATHbTG5R/dEGcDCev
	3/Kh7/jVQOaw8U2kArwQYQSkiWIQ+tVjnWto+XwcduCCBDmebPKtK0pdYvxGbUjFsw0jb7
	O0CHMvvSFNG8SvlhouirmvTXeAHcF50=
Message-ID: <4effa243-bae3-45e4-8662-dca86a7e5d12@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766058071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5bv+aDdmLUwbT/Rl2vd0tHpuESUGfI/xwE/ZSUQEBgM=;
	b=E7H2Crh7Tjtpdw3/pt1bEzDFr+XY5jMekcgGa0dJx6pR8/ey2yQI9Q3z9khKF/MXx1eOrT
	wZtnaWkFqPthwPwTH3GtZ36Msdu2nBZ71cmvI2IZ3C+jixvKGkBR54aZuNXH/ExEc2lguI
	Hyjjb81j7HxKPFwmarfVQOLO3jGFnvo=
Date: Thu, 18 Dec 2025 19:40:43 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <d62756d4-c249-474e-ae80-478d3c7cf34d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 034381A0015
X-Rspamd-Server: rspam04
X-Stat-Signature: d1ha88cjauyeieinfm19yg6cjqqftcgq
X-HE-Tag: 1766058078-466856
X-HE-Meta: U2FsdGVkX1//R6ZfVdCCsFnsdPIRf2f7aRNHQWzViaN59xdWPECyz6met7vA4/t276+HMhBrY4aJLg3J6/t99SR5I367sHEyiGuX/Oci0sAL5sIBTH2wveRZpB8BSK+aSDnhTZiVo5FOAqSZmmC9yBhKG6UslPYI9ymfdU9aZlbkrxHzK4dMoXsAfiiQgcpwwxDXUeP12lLKfHJd3LaUOxrbwoMAUdcS/DW81F2fQu520WakEeqHIpcWIb3bWNzGui73RuVgbf7VS6EpJKPIVfS+Xy1uhnmAWCbfehGVeQGSk7DLTnMM1ysx6DSBZA31rIgH78Cb2zVzeHiMec0Zn4/z3dWvh7QDEdT1+52ERj49BVOpt6wbrhg0lllsgAuI5OSevAe3pPvwLFt9DgsYCtvjROkL4IwK+rdTgGgsn5iAWOx4LbSHoq9cOVx+XGYoERKolh/9aasOkDsAjktX5gYBz1yaOXydoN6tW8eR0vI/bC2MXdBoL2HUK09JDfxawHw8+ec14a5xpXhgqXBkgLzD5J4tZqthZWi4upruETulJ2SHLzJ7hjiOptg0NvffPZrCI3RvQLR0Q3gREYi4hmRRoVPmqeviNAWVUcJLyvIxVt0FAZPU8TeB27VcZQwhg8YE4jKbdpa7iUZeJjApslsiXtteEyQHd+v2Nf4oFmfN+QMFGw5xxrDO5C67svFR8r6/wtZCnAhOGsEzeiTQEdtDdu8iw5J/AObMb/II1nWPDUpcbxR6xU4VFeZJVN6R4ZIgCiaP2snNDorztcWXXmvKtsT43vHGDZza0PyLUAetlmpivk1fcUwe32ZogFv1zgrzn10qVy9dEZQ2iTtU5pA40J22aDt29CI1MmiptZUQXfOhD4V550Gph1PX2bjvw3fPga8sl489RItpR6XajjrbNM5fUgasVb+c9MRPO+ADBkkm2oj8GDAoPWM7xWvZVVN0yo0i6NstZ3Q6dsr
 RiyDtLa4
 S+Bvc+NTtUFTXaURG9lHo96M4wRSwUpL/jo6bmbTO8qt3GjvxrsC1uF8dmtv33+3s+ZBYvZgSgsSwpTCVpAcIxkmxLorjCyzvM1wKjjaRxs7HF/kMGlXvdf5q9+70oRYyz6AMlEmmTsUPEbxV1iGm8Ky+I3E4SUFzCPEOrgG4+/SJhi2B+PA7yGAz+woCQw77Itt3V6qk2mFw7WMGV99iawH3dxS9/M4al4WJJ/GdqfqpFjpVmOXCd+nKQ2kLKbDA+CnjA8OyV7FaLCmEd18FlOBNlQlhJDPKBY6lpBIbLefzOdivZ49+8CpsXQHnU9gPCxWD8jGYMZjPfGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 10:36, Qi Zheng wrote:
>>
>>
>> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>>> On 12/17/25 08:27, Qi Zheng wrote:
>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>
>>>> In the near future, a folio will no longer pin its corresponding
>>>> memory cgroup. To ensure safety, it will only be appropriate to
>>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>>> returned by folio_memcg(), thereby preventing it from being released.
>>>>
>>>> In the current patch, the rcu read lock is employed to safeguard
>>>> against the release of the memory cgroup in folio_migrate_mapping().
>>>
>>> We usually avoid talking about "patches".
>>
>> Got it.
>>
>>>
>>> In __folio_migrate_mapping(), the rcu read lock ...
>>
>> Will do.
>>
>>>
>>>>
>>>> This serves as a preparatory measure for the reparenting of the
>>>> LRU pages.
>>>>
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>> ---
>>>>    mm/migrate.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 5169f9717f606..8bcd588c083ca 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>>> address_space *mapping,
>>>>            struct lruvec *old_lruvec, *new_lruvec;
>>>>            struct mem_cgroup *memcg;
>>>> +        rcu_read_lock();
>>>>            memcg = folio_memcg(folio);
>>>
>>> In general, LGTM
>>>
>>> I wonder, though, whether we should embed that in the ABI.
>>>
>>> Like "lock RCU and get the memcg" in one operation, to the "return memcg
>>> and unock rcu" in another operation.
>>
>> Do you mean adding a helper function like get_mem_cgroup_from_folio()?
> 
> Right, something like
> 
> memcg = folio_memcg_begin(folio);
> folio_memcg_end(memcg);

For some longer or might-sleep critical sections (such as those pointed
by Johannes), perhaps it can be defined like this:

struct mem_cgroup *folio_memcg_begin(struct folio *folio)
{
	return get_mem_cgroup_from_folio(folio);
}

void folio_memcg_end(struct mem_cgroup *memcg)
{
	mem_cgroup_put(memcg);
}

But for some short critical sections, using RCU lock directly might
be the most convention option?

> 
> Maybe someone reading along has a better idea. Then you can nicely 
> document the requirements in the kerneldocs, and it is clear why the RCU 
> lock is used (internally).
> 


