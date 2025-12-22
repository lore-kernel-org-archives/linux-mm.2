Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5322D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 04:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102F06B0089; Sun, 21 Dec 2025 23:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1686B008A; Sun, 21 Dec 2025 23:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F203E6B008C; Sun, 21 Dec 2025 23:02:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2C676B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:02:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABFA01607AF
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:02:28 +0000 (UTC)
X-FDA: 84245759976.04.B4B1F48
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8A6E140004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:02:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V6/uE91c";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766376147; a=rsa-sha256;
	cv=none;
	b=AbdAGb9gYwtU7C0PIgGLFUwgXkn+I3Qg2x0X4xGCI7qjuyRDcHcgbKEFrLRUSozXrZXitZ
	k71EOfdHHg2/4N6PbyVdtvvl72g+oXL2jfZvUqZsE2CoJVFXy7IT7sZZFECXsp5qJDbYK/
	ftCpHvA9PwEOj6Wf7ApzfZlOjGeqQ9Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V6/uE91c";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766376147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8FBk6lNZ9dRAmbI0dX/dkHT+ceGlZUbr6C5gAhuy3k=;
	b=qAYNjCsysa4N9aE4pdPTViOmxU7i4ecKoGcVS5a+4egpzYqLwTaCj+LmSONF7xYHcldQWz
	c88/g2xPYFkjBFGEap78zg8Y3WjQqb/Zz/hg58GQsBr00Cv1bETLxX3orCKWKd0rUcCLmE
	wduSiJ0hMAgC1QV7QaYemCBgoVXvfoE=
Message-ID: <59867ffa-7e5d-442f-8e8e-79d5512e03c1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766376139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8FBk6lNZ9dRAmbI0dX/dkHT+ceGlZUbr6C5gAhuy3k=;
	b=V6/uE91cWY683In/e2wrMi2y7uYHTGMMTqM5DDPH8wgIwEsn0MWLF49vXKTFwmbN/vX4VP
	vh6AkuxI9K0XZy+np0SqpvJzBANodlUdtPWSfsqXrpMFNdXnexFC9B1Vc+fyhE9Is5DBUT
	AjEW6lareQy166USAQATDXjHm/cvKHg=
Date: Mon, 22 Dec 2025 12:02:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 15/28] mm: memcontrol: prevent memory cgroup release in
 mem_cgroup_swap_full()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
 <hvta76slujbvyb4av4cgipcevd7jctjrq2tmyw2pwpynfpjytg@ihr3aqp2brzq>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <hvta76slujbvyb4av4cgipcevd7jctjrq2tmyw2pwpynfpjytg@ihr3aqp2brzq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E8A6E140004
X-Rspamd-Server: rspam03
X-Stat-Signature: kzigfcrw15cgurouicqx5ope6o9uf14a
X-Rspam-User: 
X-HE-Tag: 1766376146-630563
X-HE-Meta: U2FsdGVkX1/mZFgZKONhWQGq/g5LNzXDtVa+wA+ZxVL3vOhGIsWQ3+b9QNCBb4Yl5PygkKTLAl/jXKzt37ONLQ5EAiOyfERctYpM6D4QkF0yqFUdwP1SB0AGibBgFrpi8k0lGTOr0bTEicLNUS2YcaaVsef44UmkmfSYM3ERtRMj8vVKpDu/zS08D8KJlh36Af6U71gWjlO/DpkQ5BUeb9Q52DMGScj1AHdTLfHg+aS3q2gA6a6ZbqwvCZneCbe8a9lz7pbmN3hrislMkRt5l+c+EeIVXTUhTnd4JmmIH1juN5sPm0w4VHrYH5jeXdWh9CbB2G061VY+i0RhtCHU0dMZbUUMArHhUd8uZ+Urv7obSVwTYbCNJTvz3al7tEtUBfiPK6m3FNBTeUjqAhJinAl3XGpAGFuQ+pZxEJI15/IfL9rkOnLLKFQrvJSX/fu5HeU4bEFecqw/qnhYSUMKXDBLxbVlRWOol7ByBulqkpTqbyGEWhEUfRn0lznEuaJX9Zz7wf+xqL/QPaC1hGXj/c0eNV+6eNzXd2/8pwEeT+/rlyDsNz1Q+LRHXaNMvzk/MKEIb7gR2nd5+7+qrjOLYjMFbHYxSEo6YIlQPfcDeUmBJBkAfBpc8TIylTuIBywmiYCo3wD21ttP0EVtcvvQykZf2MXM5PWQM46aC2kyEWdOSwbUr1b8WF6Qmfo2ViTRH74z4g5E04pcbE+lvRx3QpUdqHvorNYd6iMFs7BMhkmj4bt0gVB/y42lSC+TuKnZlef9swqigYGfVk73/9TvRNUOTs07z+WpfjGZ+su93KT53aEj78pCkEvMnpvsPXt55bavF81wKJXjpTu1x/pXxI9qB+sAur0ZSgC+WljaVTH181Qj+uZx1dTAdDBA3N4Zdx0nJTufHke0KjLA/i2KxFueGyxdUmrqbox6CId8tooXtsUX1e5wlWh8ZqiFJ2JIiWJjazUqj4ExEWx6Gyr
 y+xW8dIG
 GxEwAnZkJAfvJoys0TH7ou6sIqza5kz1yZJOvpWT3NxP7J/XoI5ISwKBq7x8jDbxs6IQ/Y66Qnma2lJUPE+uysPBbR1qmQIGwXehsCYpwlIrzYq9JapfNieyD38E8/9FoqVcITtkSXmxkHAn+3cTbem6VPjdO9YU0dFJSlrkFKkrDrbGpSgCcd2MFFOO5fexCqfUOkkY4UCvm55IWW/J+PWEmvnEPaGXCx+kEu9n0ZHcKMw7MDX6VEtJzVNJzxG1o7m3xD/GKIuYZff0OkmPZj34S43aBzgzFhikQZUQLzxLLDkqln2Tqgl6mwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/20/25 9:05 AM, Shakeel Butt wrote:
> On Wed, Dec 17, 2025 at 03:27:39PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in mem_cgroup_swap_full().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>   mm/memcontrol.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 131f940c03fa0..f2c891c1f49d5 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5267,17 +5267,21 @@ bool mem_cgroup_swap_full(struct folio *folio)
>>   	if (do_memsw_account())
>>   		return false;
>>   
>> -	memcg = folio_memcg(folio);
>> -	if (!memcg)
>> +	if (!folio_memcg_charged(folio))
>>   		return false;
>>   
>> +	rcu_read_lock();
>> +	memcg = folio_memcg(folio);
>>   	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>>   		unsigned long usage = page_counter_read(&memcg->swap);
>>   
>>   		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
>> -		    usage * 2 >= READ_ONCE(memcg->swap.max))
>> +		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
>> +			rcu_read_unlock();
>>   			return true;
>> +		}
>>   	}
>> +	rcu_read_unlock();
>>   
>>   	return false;
>>   }
> 
> How about the following?
> 
> 
>   bool mem_cgroup_swap_full(struct folio *folio)
>   {
>   	struct mem_cgroup *memcg;
> +	bool ret = false;
>   
>   	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>   
>   	if (vm_swap_full())
>   		return true;
> -	if (do_memsw_account())
> -		return false;
>   
> -	if (!folio_memcg_charged(folio))
> -		return false;
> +	if (do_memsw_account() || !folio_memcg_charged(folio))
> +		return ret;
>   
>   	rcu_read_lock();
>   	memcg = folio_memcg(folio);
> @@ -5277,13 +5276,13 @@ bool mem_cgroup_swap_full(struct folio *folio)
>   
>   		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
>   		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
> -			rcu_read_unlock();
> -			return true;
> +			ret = true;
> +			break;
>   		}
>   	}
>   	rcu_read_unlock();
>   
> -	return false;
> +	return ret;
>   }

LGTM, will do.

>   
> 
> Anyways LGTM.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!



