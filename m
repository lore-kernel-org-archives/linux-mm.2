Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCC3D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6C36B0088; Thu, 18 Dec 2025 08:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8745B6B0089; Thu, 18 Dec 2025 08:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756BE6B008A; Thu, 18 Dec 2025 08:16:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 642386B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:16:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E07EB160156
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:16:38 +0000 (UTC)
X-FDA: 84232641276.07.9C5D7F5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0CCB2001A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:16:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjV+vqLm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063796; a=rsa-sha256;
	cv=none;
	b=xJP434U6GYwTg+t0n/kyYJ322xIIH9RH3rF1HDwv5xZ7ilntn4R2BD3H/xfHKR09JuCnRN
	ovwxzHXuWsSmmwIPDi9j19pKNi+MxHkcKxKVVoni3zFPHlWOpgdk74mwX0FcqCgsLg165M
	m9suBQMJ/AY0eA32CL6szB/irs3ygcI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjV+vqLm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoPCD9Q1tLO32LKLo1wra7n/7+sv/Ika5Xpd76iQ9qc=;
	b=8kbZ1Ua5fN4shPrmHmkbjfcxwlUjXoZlYtdsSItVcnekyaQzR6x39aQjifvISdYo5oOD6y
	bitU3WZJ4M5AazBPbUcVUQdZiwuVFVgS+s2FjExuClnwyOgpClBMsVuDD6GlDapB0DUN8t
	D2ZLZR6UV8UGc9QpqaQDuRzR4NqLaLs=
Message-ID: <a35751e3-9c06-4e02-81f0-c211d4383e5f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766063788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoPCD9Q1tLO32LKLo1wra7n/7+sv/Ika5Xpd76iQ9qc=;
	b=YjV+vqLmCwHos0s8P5DDywxWwvDyIJIcwQtaJiSqYJ7mlXKNxMQ5MMVfxS0o7A43cIzePy
	TE+SrEkPlTBYAnn1N5vyc973X/mKLP5O/bIZVxsnPA+RqHTc8AdP6nmJlPQHbZ/qMG9VYE
	M+9CoImDm/Hz43Tp47WIQmiwGYLyUuI=
Date: Thu, 18 Dec 2025 21:16:11 +0800
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
 <3c32d80a-ba0e-4ed2-87ae-fb80fc3374f7@linux.dev>
 <49341ca3-1fc9-43d9-abbd-ecaabdda6ce0@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <49341ca3-1fc9-43d9-abbd-ecaabdda6ce0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E0CCB2001A
X-Rspamd-Server: rspam10
X-Stat-Signature: u97sczc1qd45sjci57kt96keofkye75i
X-HE-Tag: 1766063795-606443
X-HE-Meta: U2FsdGVkX18ZxM8U35G5GvuxHppFpm5h6g/XZaYVKBEafNYNiJTx5KUYZHDSHEeJdNHak+VutCbCiEg+UVxad8fioXFqoNW+lNcDBOxcDIN9rIhMkSUddAFznImYSMXWjdo7mPsrrHJjmR3rlep2CJwsKPQqkqfLvY5ZlAKeVme14Q3m24l8wInRgikRKtbTjBoZFJM/Xvf6umFyDOWTalZZJBlokIcVP4l5BBXEwby52ZIiS3uaUjBU/Tf/1R1SOASuwjYYZqzRhXYK8yY8+LUZytIcmjAJqB6r9PJF4oALBUxkLdXzFR+4sBRQhxNQfol6x/xTfXxYhEI6M99fOjzXclyGNg7NjPIjrgMintDBaJ+bsPmfH75cDu1Ig3OSWJMzHWbBIW5EXh59VKQ/ciEvjyuGzPqZs34fwYU7CD0ny5hYGoT02d1dTQDJJv4nOL+0TFi1Cf5AHXFi0CcTCGGDN8r43u4YORm2pvnFXWs1a3Bq6dIiHQMhmpD+1w2TD+p+YzFB+5/1BuJURLOmAaKfabq7w0+bVCBirWcvLrV6yGeazixWbBQZEmBI75ZmkVDg5ItghvFA29tC9tQuTdb4B3BSmlxKCAVlf2+Ifj/6jVygcduJKUDNX5bwbhTbWOSSRAEcvqGBU9ZljkJ70Nth4bQgo3XPxzZNdEwGzpMkiM1Aj3LLDQgImmCNvO+QNsa8Es4Vn1ATUbGzJjtz6bI+FAs1F16X1A3Ngnn+I9pboyt7HZCrSAoGheDUMPlZ5UClo5P4sqfwCswGrO9sPIN4uWBuIB/yIcUc2riA8Ird2QwN/tAHx9YycijHCdesI6FQ8PrfBzWZDRpSKB4PtsvgsYoGms3Z/BP2GTK4IWbOP0ObYNgw7St9P6IQt0m40rJXX/ootdW9XSu5n+YuuB50Q+EUqd7Yly/QY5sXHZnDcxImLh9gakfKowEEmwEfAu5tpRGIGmi3MDz6ndN
 sCkotNJt
 BoWHDCtQ0A878t1ZWm7JVKjWzDuSQXIaSh6sdCRyD+Q8oGO/Ql0LLSABxdGNTL4TLcWEM6RcE7KMyg5KZKO+oGZZgHlx6SSYInXRzgkaKtDjU5mI/edABeYBvgNICjx1CaYdhwE4hb+aRvmaUHu7537Kahf6/g+AfmefGqd3zcxlxYv7/4vE9jnwPbx10MSkh7zYc4z8gUOy+kBlGewwxOYW3rrsgMaP2Z5HhnBP+jOL1l1kuDGb7cITmu9MM/Xu3C1OKlBk2zGSXyYsMn7jQgGTGj9EkfgzzCD5Uco4NfsQpsrNIUkYB9eOU/Kbm23ydDsghXgRTTCVH114=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 9:04 PM, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 14:00, Qi Zheng wrote:
>>
>>
>> On 12/18/25 7:56 PM, David Hildenbrand (Red Hat) wrote:
>>> On 12/18/25 12:40, Qi Zheng wrote:
>>>>
>>>>
>>>> On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
>>>>> On 12/18/25 10:36, Qi Zheng wrote:
>>>>>>
>>>>>>
>>>>>> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>>>>>>> On 12/17/25 08:27, Qi Zheng wrote:
>>>>>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>>>>>
>>>>>>>> In the near future, a folio will no longer pin its corresponding
>>>>>>>> memory cgroup. To ensure safety, it will only be appropriate to
>>>>>>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>>>>>>> returned by folio_memcg(), thereby preventing it from being 
>>>>>>>> released.
>>>>>>>>
>>>>>>>> In the current patch, the rcu read lock is employed to safeguard
>>>>>>>> against the release of the memory cgroup in 
>>>>>>>> folio_migrate_mapping().
>>>>>>>
>>>>>>> We usually avoid talking about "patches".
>>>>>>
>>>>>> Got it.
>>>>>>
>>>>>>>
>>>>>>> In __folio_migrate_mapping(), the rcu read lock ...
>>>>>>
>>>>>> Will do.
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> This serves as a preparatory measure for the reparenting of the
>>>>>>>> LRU pages.
>>>>>>>>
>>>>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>>>>>> ---
>>>>>>>>      mm/migrate.c | 2 ++
>>>>>>>>      1 file changed, 2 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>>>>> index 5169f9717f606..8bcd588c083ca 100644
>>>>>>>> --- a/mm/migrate.c
>>>>>>>> +++ b/mm/migrate.c
>>>>>>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>>>>>>> address_space *mapping,
>>>>>>>>              struct lruvec *old_lruvec, *new_lruvec;
>>>>>>>>              struct mem_cgroup *memcg;
>>>>>>>> +        rcu_read_lock();
>>>>>>>>              memcg = folio_memcg(folio);
>>>>>>>
>>>>>>> In general, LGTM
>>>>>>>
>>>>>>> I wonder, though, whether we should embed that in the ABI.
>>>>>>>
>>>>>>> Like "lock RCU and get the memcg" in one operation, to the "return
>>>>>>> memcg
>>>>>>> and unock rcu" in another operation.
>>>>>>
>>>>>> Do you mean adding a helper function like 
>>>>>> get_mem_cgroup_from_folio()?
>>>>>
>>>>> Right, something like
>>>>>
>>>>> memcg = folio_memcg_begin(folio);
>>>>> folio_memcg_end(memcg);
>>>>
>>>> For some longer or might-sleep critical sections (such as those pointed
>>>> by Johannes), perhaps it can be defined like this:
>>>>
>>>> struct mem_cgroup *folio_memcg_begin(struct folio *folio)
>>>> {
>>>>      return get_mem_cgroup_from_folio(folio);
>>>> }
>>>>
>>>> void folio_memcg_end(struct mem_cgroup *memcg)
>>>> {
>>>>      mem_cgroup_put(memcg);
>>>> }
>>>>
>>>> But for some short critical sections, using RCU lock directly might
>>>> be the most convention option?
>>>>
>>>
>>> Then put the rcu read locking in there instead?
>>
>> So for some longer or might-sleep critical sections, using:
>>
>> memcg = folio_memcg_begin(folio);
>> do_some_thing(memcg);
>> folio_memcg_end(folio);
>>
>> for some short critical sections, using:
>>
>> rcu_read_lock();
>> memcg = folio_memcg(folio);
>> do_some_thing(memcg);
>> rcu_read_unlock();
>>
>> Right?
> 
> What I mean is:
> 
> memcg = folio_memcg_begin(folio);
> do_some_thing(memcg);
> folio_memcg_end(folio);
> 
> but do the rcu_read_lock() in folio_memcg_begin() and the 
> rcu_read_unlock() in folio_memcg_end().
> 
> You could also have (expensive) variants, as you describe, that mess 
> with getting/dopping the memcg.

Or simple use folio_memcg_begin(memcg)/folio_memcg_end(memcg) in all cases.

Or add a parameter to them:

struct mem_cgroup *folio_memcg_begin(struct folio *folio, bool get_refcnt)
{
	struct mem_cgroup *memcg;

	if (get_refcnt)
		memcg = get_mem_cgroup_from_folio(folio);
	else {
		rcu_read_lock();
		memcg = folio_memcg(folio);
	}

	return memcg;
}

void folio_memcg_end(struct mem_cgroup *memcg, bool get_refcnt)
{
	if (get_refcnt)
		mem_cgroup_put(memcg);
	else
		rcu_read_unlock();
}



> 
> But my points was about hiding the rcu details in a set of helpers.
> 
> Sorry if what I say is confusing.
> 


