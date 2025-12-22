Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA302D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2EB6B0089; Sun, 21 Dec 2025 22:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B49D6B008A; Sun, 21 Dec 2025 22:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7076B008C; Sun, 21 Dec 2025 22:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39B4A6B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:43:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFBF260BDC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:43:01 +0000 (UTC)
X-FDA: 84245710962.25.21F5331
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0924840009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:42:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hVmiX6uT;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766374980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz1xuPsgdNZC4b636x1LrK4fMi9S/EGh27EdWq41RBA=;
	b=xDWWRJTAoW2qHAF52b9YFKnwr8eXGcrXmXQVdEmLCh5+OEbUMFKVCOHGBin25V39jmK3PU
	d7hALE01fExnhsN6OgmJftZajZSmNyLhAVhhQiQiTz1RnN4P38WeelCkOeGw9rpTGAs/wJ
	E+kiFWz/ErWooaG1ObWrpt4nGF4jAJk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hVmiX6uT;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766374980; a=rsa-sha256;
	cv=none;
	b=h9D7iWaaBzC0hcwZZUuDU6VqewZehrEg2KaiuziLFPvTWdpKcDylMqklb9AAhSXPjVJ5Y6
	/GpJ7XtPbQvJR/rRsZP/BwX0Y+6EfVSQWS/BdxkDDY5R4l9XL2EpW4F/y/40dBhO+Rgwdd
	wF3zVereVPI6rFX+01CmaxIxGdoqGQ0=
Message-ID: <c998d9ef-5538-4ad2-9a95-a20ef299ce55@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766374973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bz1xuPsgdNZC4b636x1LrK4fMi9S/EGh27EdWq41RBA=;
	b=hVmiX6uTnWbBzcdQMwstWbBHDPWFlAHlSeClZfctafz8wzOcVHzyKB8XX1SNWtyuAQP6kv
	TuQWLWUGs84KFl8rDmsFxUq27C45eAxgWZGQm3bHTLBNKiLJJqEAwM6hh4jpBBslKOnFtW
	KCrikMCmmHQwn2YykjCeCfScSa6UH14=
Date: Mon, 22 Dec 2025 11:42:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Johannes Weiner <hannes@cmpxchg.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <aUQPB0cUP9PXnrqh@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUQPB0cUP9PXnrqh@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0924840009
X-Stat-Signature: nq15kscozjuikbgt7ro86cpoayt1shs5
X-HE-Tag: 1766374979-796932
X-HE-Meta: U2FsdGVkX18wI4wQY3Ztz2lTDRGKeewCNM9Z3MB9Jc4vdaoDlNTOd/5B0qPBInlxbNYL/RwoOUifCtpGTVlMEDoSHICV3dbZclUfrcSSk4UA93gOAwm1Qk4vdtqZdDRuFJltAIma7XQwxjgcZpdpMzjjpaD7jF57qc3v4jRt9SbELAycbn88ta+DK3BuShU0iJ2OB0llHIFE2s0yuJX6+/+kFn58fqECEG5N3pdcjfXrBLsKmyqwno7fmf/x9MqMWFaK3xYyT33X9P/UaBrQ26vpOoQyUT7wa71s7x8doksCAc4sAsioWwZs3/0vgQ9Y77IhT8MN48rkLJ9NbWwyL4OpOQhF27PWPUotnLegXsaH/YlHpDWLiIUymeM0qMEZayFH7bbIEX7kEnIMC/gm7DMtSMklRPRPzny/lbH7t3mx6+pzMpzbprrC1gHtcRibuzu+f7wlfYKDyXyZSWxmh1HjX/8Vfbv26nY4mHDS/PhHUIaG1xA7fz06jjK0BKEDhftpLmXT8wRwr+7LpzllaRephlimP0OvOcSKjnislLVGeZoyRHKo+1ifBLJDt65JXYAgoURHs4pe6Y2++hEpD+JhyH19ombeWdPVScKLxJIOENZPH03uqffmdXsjTkhcCyIC3amZ+r5U7LCAQNsKlSU6X4BCmZ60GiOR6+XZD2mGa1zYEEgZ5y1YTziuuKHvb0FudqAd2v4bq+oblj96e8Je5IYa9Rvol16cizJdN8FjDx8PfWZ1NBLEu0VQ7TRxKvSjH+Pp3DYqm9wLDLv6CL0Z4RpIYDZV28bNtOuikpAsvwSPd+5A4vaLBA5XT2IZg9+QeSkw0LnSBFtX9fXZQAh4NOEgmcYs4a2EZ3axyTKNa7jw6NmdRxTXXP1JZK8xvWj3chHi8Ux6qs0WSm0PMvrqWpKrHT2HfKdAABd8rW4JIbd129Izl9uB5jzeEELpXxC2xU6b38nB6raTG0B
 NzYuyq4Z
 n/Tri9kTQWA8u7y9+lHzZKnIgS2OgQfyHGbovzbMaHMYzCxVS59VHjV0afGcVvgmQeHGYIxzLDSeRjJmVil8ECdaGSLyrpnQsB62eVgpUQVf1NAvLZM1nOi/S+EasLetqdhMi7QKUydZhnfB3O0MdpnZopd7GOe6mlHBmKC8Kol3545k/sWM3OeDbzZvUNOpMZwpPYl2Rhv+8LIKNTNEnzHppAXddjvy/rECMK0NL/GfytCiy+EdgRzuorH9hiantf5ojG0sq1lgdluftQAtMBGwFxS2y030ahyBugCvpCmCM1Ig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 10:26 PM, Johannes Weiner wrote:
> On Thu, Dec 18, 2025 at 10:09:21AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/17/25 08:27, Qi Zheng wrote:
>>> From: Muchun Song <songmuchun@bytedance.com>
>>>
>>> In the near future, a folio will no longer pin its corresponding
>>> memory cgroup. To ensure safety, it will only be appropriate to
>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>> returned by folio_memcg(), thereby preventing it from being released.
>>>
>>> In the current patch, the rcu read lock is employed to safeguard
>>> against the release of the memory cgroup in folio_migrate_mapping().
>>
>> We usually avoid talking about "patches".
>>
>> In __folio_migrate_mapping(), the rcu read lock ...
>>
>>>
>>> This serves as a preparatory measure for the reparenting of the
>>> LRU pages.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>> ---
>>>    mm/migrate.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 5169f9717f606..8bcd588c083ca 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>>>    		struct lruvec *old_lruvec, *new_lruvec;
>>>    		struct mem_cgroup *memcg;
>>>    
>>> +		rcu_read_lock();
>>>    		memcg = folio_memcg(folio);
>>
>> In general, LGTM
>>
>> I wonder, though, whether we should embed that in the ABI.
>>
>> Like "lock RCU and get the memcg" in one operation, to the "return memcg
>> and unock rcu" in another operation.
>>
>> Something like "start / end" semantics.
> 
> The advantage of open-coding this particular one is that 1)
> rcu_read_lock() is something the caller could already be
> holding/using, implicitly or explicitly; and 2) it's immediately
> obvious that this is an atomic section (which was already useful in
> spotting a bug in the workingset patch of this series).
> 
> "start/end" terminology hides this. "lock" we can't use because it
> would suggest binding stability. The only other idea I'd have would be
> to spell it all out:
> 
> memcg = folio_memcg_rcu_read_lock(folio);
> stuff(memcg);
> otherstuff();
> rcu_read_unlock();
> 
> But that might not be worth it. Maybe somebody can think of a better
> name. But I'd be hesitant to trade off the obviousness of what's going
> on given how simple the locking + access scheme is.

Agree. I also prefer to keep the open-coding method for now, and if a
better helper is available later, a cleanup patch can be added to
accomplish this.

Thanks,
Qi




