Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4A2D6ACD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18FA6B0089; Thu, 18 Dec 2025 04:36:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7776B008A; Thu, 18 Dec 2025 04:36:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EC16B008C; Thu, 18 Dec 2025 04:36:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 877076B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:36:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20D80C0C3C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:36:18 +0000 (UTC)
X-FDA: 84232086036.07.29DB425
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A93440005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:36:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qF7ex1vz;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766050576; a=rsa-sha256;
	cv=none;
	b=sYkktsvfp2smvN29SyassnoqGS4f6EHuUqpfwUcHmqIWRaGQVPccRK283LIGLaUFuBrZBZ
	BtgWcOXR4lXF7n6VbGqRUPeGwnBwoWijK4oInBFZn5cI8C3cTO5w4Jc6KuUsZ6uKmRrOAI
	fFlLX+RN2BKV1FJERQf4JOkhLRJ/Iuk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qF7ex1vz;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXEVgSDfFQRZmqw91gtvqofxkpPFsKG1MF14J7844dQ=;
	b=f5oa4OOzKw25wcpVz616GJLh6oB0wzhlRLpj59E9J1BqI5bvQ048SUxhzxjUoS8Rl4UkzB
	Lc5IWNl8ip4DO1aH55J+z9MAPHHZh2SoooAe6TB2Sa4VzoqLwOHe7Z8OCVOAo14+r1+JKt
	lwFdPlgJzlkFjhYs1a/+VLQzVupWgSo=
Message-ID: <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766050574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXEVgSDfFQRZmqw91gtvqofxkpPFsKG1MF14J7844dQ=;
	b=qF7ex1vzVKMpqENmGb0AMh9twBFnr9nMf5mpXKR5++Gd6nWWWaAURqJCzsViZnil6yFo1B
	HOS+UAqUSEyN7ZMBZCH4sigL5pZfQDcy/5KZboawYghYgp/TmmRXe2/bnD2YFYp5F/RRRW
	EwT/AgFmuhPpXUU2TWiq2WzRFhdOpGY=
Date: Thu, 18 Dec 2025 17:36:00 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A93440005
X-Rspamd-Server: rspam04
X-Stat-Signature: 85mucp1p1goinywyiqbs1mfpe8feku8i
X-HE-Tag: 1766050575-742483
X-HE-Meta: U2FsdGVkX1871CvYuO6fEGZCbx9DhCtZHYplK6GBg2SH0aquauPmc5Bb/1p++JiLbVEAUEywAI7HBjkx497NhlSXLZ++ZgFAxUero7fx/jhVQG1FFxMtFuvhwr9clYjyXrxvcbFmr60uRnKJWxUSTjUxNMdPfHeakN2biKPCCfhUZSqqhhK65zgkDNrsGjQNh/hXdf0ZiwPGXwiPIyuVc1EcZIoJu1SSWCQFh7H/UlLcAX46nbNHanMDjvA+gZjBdaqI5W8uu3IJwZ6rkY0HtjCF66NuV8EFNeAOMTwxgxPqJ7smPaXUABqBUpg/KxF+Ek5fb8w32m8XdhNnfhk+0Mqnvw55S3kryLuc6B0NLT17PLDKnpinZSZGJRRCnzkesD8/NvdiECfzkW9hSVzgdq+NwOm5lTpS99D4Uz5tdti1MNlmBgDF8kFWKAWId1xJ19H2wbaO1sWMKEDKRhxfBkAL/ni+ebPUoUgNEusxFKIvVXGqVuK+wvXYOu6AC1646Lg5E1jh/0ybL/Rzhw/wPJR3uqTmYgPoWrtzTMJOrFKwroUdLFvVxxZRI0+0ObJB8W7GCHRnowKMxD5Nn5VzrCfpuEunRTROwNHeE+xdU7zsqvkNzzCNqCXooPnKZpdJX96bN4Po95+lCZXeW+XWNFOo/Fc722/YPl/5gp7m7w5v9gM9zrV2naZbQRnOpW8705J1GqaeFhW99yifjcCSQ+ypJB/6I/HLv/Xl6KIk6t1YmwncuGVT253mAfzGVHevGF6uzi59udDa568ZDycQiGhpzYnDtrr1LK39jXsQ52sSL3HiV/erFOxqR4M7N7BVm3jXJkz3WknQNc12omrHfXX+SD34mzj9xV6XldnKwckdzdq/Ahtcc5MVPQ86O2h6Mtttze+Q1PgPK5qZhGXS6WAe1K0i+pz3DcscwTRAuqtY5HRVsXIsyg3sUrMRDLK6Fk4huenpGi4UWPD4y0x
 8x18QeV7
 JBGGvR8CwaPdugs3ey7JXkXB4wolblQopsBmoMpx6ouYf3R1xu4XpdxNZQm94Mady7jy8UeEZIgM+jTD7JETGfZAZ5Rl2gYoQdk2RVZjabx86fT9e86pMjFkSzvvTaZgfKprAb6NJvvf7hRU3J7o6752VdoNhxkjX4uaAy6e5u4bgCeey+57S144INEw+dagOX/d4zhasiWrUZBEHkhkEkfpZ8SnJYus/OSmYDa1U0mBEBxi93KQ+i5G8i8MOkiQGtKhWgrnxOl97kartG7GE1CTdAHCbTLicrQoCf+qn3+AJ3/iDviJDQABBhruWc5NqNvNBolAqNZ0V9YM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
> On 12/17/25 08:27, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in folio_migrate_mapping().
> 
> We usually avoid talking about "patches".

Got it.

> 
> In __folio_migrate_mapping(), the rcu read lock ...

Will do.

> 
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>   mm/migrate.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 5169f9717f606..8bcd588c083ca 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct 
>> address_space *mapping,
>>           struct lruvec *old_lruvec, *new_lruvec;
>>           struct mem_cgroup *memcg;
>> +        rcu_read_lock();
>>           memcg = folio_memcg(folio);
> 
> In general, LGTM
> 
> I wonder, though, whether we should embed that in the ABI.
> 
> Like "lock RCU and get the memcg" in one operation, to the "return memcg 
> and unock rcu" in another operation.

Do you mean adding a helper function like get_mem_cgroup_from_folio()?

> 
> Something like "start / end" semantics.
> 
> -- 
> Cheers
> 
> David


