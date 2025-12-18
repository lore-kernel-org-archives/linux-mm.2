Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF477D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF146B0089; Thu, 18 Dec 2025 08:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6D36B008A; Thu, 18 Dec 2025 08:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2886B008C; Thu, 18 Dec 2025 08:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF316B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:05:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D86E0B30DF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:05:09 +0000 (UTC)
X-FDA: 84232612338.20.543D514
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A72310000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:05:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MCE/KsJk";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063108; a=rsa-sha256;
	cv=none;
	b=Nx1uUV7diuGzyQ4JVV/8Xf69txPKHDN1MI9GOKEO9e5qc+Bd3G4ElTJuDpsMn+iJbkVVAy
	CMc8he0n0HXMnuGhDBxEqFsUgeF5a3DlSGrODnvmXmks9muQ+p+gl8AypGKAu/f2agn5EI
	/rMzwo74zF7oeYotAZqqAx1igzlY038=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MCE/KsJk";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4Twd2OiZVHdlbAO9crFbVzGvbH7KAg1FGsXgm06tlI=;
	b=8AUBhBzlXtnyGiqPRVJ0XZl0xesbxQPXxKRvHHZcdCgpNT0GamqyKoEYbJqK3/Zih6P9LI
	zDRwnY8mj3OX7qCZ/CX/y7NtM1ZU+Oc1nM/HZcw0m4mQnFAv41vJgMoJPOm1bdqTouMrCS
	uwDsWy+Z+aXbZ3g+th2nR8yvGBzvmPI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFD3A432A5;
	Thu, 18 Dec 2025 13:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B91C4CEFB;
	Thu, 18 Dec 2025 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766063106;
	bh=wlrGBAWuPnDkrqpZ3OpcV2IRiPY3keO1pBIgIrsLYXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MCE/KsJkd9f5ZrdGW1PLNun0XeCg+Xh8HbqQz+yv/3v0MYk96s7RrtTDXtLgPZ9RM
	 c4IWPMVpcydxnrnRdx7aYdEoDAOfXET6HnqQTCCg9k5OS0pXgNjVumFXVJWqaAPjC2
	 g1+GjcIaoltN5KwMKBW7WSQi41HH15lg09vE2q+vdNJKJYBkGeLGmiqPv13KWRpANB
	 /L+9U48s4svbJDE3vOEobqtgg/JwZ0N0WksL9xYxPjJzbl9vR/wjRjSv8KQLRyNKs6
	 MnEu8di+BbAhXRzd06agcIeS703vdtZ2osdRTfk7JpLtVsNMtsaUnQnpAmgXmUN3cs
	 QJ7UOuedxQ51Q==
Message-ID: <49341ca3-1fc9-43d9-abbd-ecaabdda6ce0@kernel.org>
Date: Thu, 18 Dec 2025 14:04:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <3c32d80a-ba0e-4ed2-87ae-fb80fc3374f7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A72310000E
X-Rspamd-Server: rspam04
X-Stat-Signature: z93carycsqnoe4hmohj6facsocdfpr1p
X-HE-Tag: 1766063107-722592
X-HE-Meta: U2FsdGVkX18BKuve3KZwiA7SdSVYf0PY7+BTepmE9nGbYuH3lcvzrnUTb0ZF/nrAQaMRT+XcnPJHRBH9guvyT4IXm7ukZckL0WXRMVsEgEa+YQhu5MGpfwCVjghdJY5nKyjVsgumG1Kpunkk7rhvhG4bR9+Jw+h0THhKWa14Le2Y8fVQINfPkqwuRfO5OtQowAGSY9RDyvNts9C2kMfIdbJJJODnK66VIwmgSQP//D+hoiS4hH52TXr1P2zD1i8R53/OY8IsVQuRUl/NG0CXp2ZBwpKcT7nGb1uYipAalAv47TS+C6kvGEaiuFNVPOwa/HVAm3Q3wGRtOLQaFwyM01H6nraFZWaF5A0MR3bFL65yzNdso7f9vwNpxqpi+1jckD5bRn+j2kpMeVzxZO9Wxw51PijxUC3GjcpQdjl3p4XhQWzNCy7+aV7PgEuiTL4gD3OI5L5MyCYeIdfyc1DWW3hXZshzxNh25WMZczhHnt4AojNOunZDQTgNZVczy0B4LqA6l82LLqsKnoEnkVcitUfgNcmqIEnmmbFpcNUl23NfqVUvANkV7qe1qxi0VrraHayfSTRAEpGVAXnvD8HV/miGkLCjOIG70Mc/TGv0vl33jLbN5rbIiUKxhFrU4FOi9XHKgHblo4u1f+fFv6P60I2aemv4I3HAtQxeOY01LCYpDy6xB96v0QKqSDMMGhE0M0OnuAyI9MgVT07cLnHThxDgXCN/Wg3PkSRxwOC3h/MLQm9Zme1VIEbetrtjubu+z2TGGjdSOfNwQMq4BEmerdTqTJqqZlAIkX6u+48LSzYvyQ7i0hbLu+7I6CwvKEyST0TmM2608VtrDYlbWS6LL9GUHiyzNbtYKL+kc+7XEV3yddxi9b7Y6zwmDMW60PEuZQdg063rrLhldLAIxkJCPpWV3D7xs3S4Ltz69wbBk421ufThmIHwS4YKJ9aP0qQua8n5Fn5mem78NPkofWH
 Q5+f3QRM
 IZ6uk0uPtGdC/s+q9VNE8Q04vvHeACY5x+udr/XYbQuOs0TevR6DVapS+tyRp7WnjbUYOsAIvd2Vym0+ydANa8UXbUWx31qJcnXz42+V4Et01//tpfT2EJEb186bXnfNjVVl63S2yCnJUnEgE5JzVhmCW//vQv0xkqPbY4nk5F4lrfZWeytPdsNJrCO2ULQE2epRAojlLHYiV43W4IssjdQ+1OhOrr09cL2Mc3amgr6QDljhTPPRneQgsJklFYMAQsnIp1htpv1aWBuK0qfz8u2UQXOrH/fNPNB87aewYIwijXdD2tZztU84fB5C9rqErtgIfuK8jvm3zMv67q9WQWm18PmYS8FrzWLXB+uZEJjnP2Heb7IwVDEsPMR0N34VUaozw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 14:00, Qi Zheng wrote:
> 
> 
> On 12/18/25 7:56 PM, David Hildenbrand (Red Hat) wrote:
>> On 12/18/25 12:40, Qi Zheng wrote:
>>>
>>>
>>> On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
>>>> On 12/18/25 10:36, Qi Zheng wrote:
>>>>>
>>>>>
>>>>> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>>>>>> On 12/17/25 08:27, Qi Zheng wrote:
>>>>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>>>>
>>>>>>> In the near future, a folio will no longer pin its corresponding
>>>>>>> memory cgroup. To ensure safety, it will only be appropriate to
>>>>>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>>>>>> returned by folio_memcg(), thereby preventing it from being released.
>>>>>>>
>>>>>>> In the current patch, the rcu read lock is employed to safeguard
>>>>>>> against the release of the memory cgroup in folio_migrate_mapping().
>>>>>>
>>>>>> We usually avoid talking about "patches".
>>>>>
>>>>> Got it.
>>>>>
>>>>>>
>>>>>> In __folio_migrate_mapping(), the rcu read lock ...
>>>>>
>>>>> Will do.
>>>>>
>>>>>>
>>>>>>>
>>>>>>> This serves as a preparatory measure for the reparenting of the
>>>>>>> LRU pages.
>>>>>>>
>>>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>>>>> ---
>>>>>>>      mm/migrate.c | 2 ++
>>>>>>>      1 file changed, 2 insertions(+)
>>>>>>>
>>>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>>>> index 5169f9717f606..8bcd588c083ca 100644
>>>>>>> --- a/mm/migrate.c
>>>>>>> +++ b/mm/migrate.c
>>>>>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>>>>>> address_space *mapping,
>>>>>>>              struct lruvec *old_lruvec, *new_lruvec;
>>>>>>>              struct mem_cgroup *memcg;
>>>>>>> +        rcu_read_lock();
>>>>>>>              memcg = folio_memcg(folio);
>>>>>>
>>>>>> In general, LGTM
>>>>>>
>>>>>> I wonder, though, whether we should embed that in the ABI.
>>>>>>
>>>>>> Like "lock RCU and get the memcg" in one operation, to the "return
>>>>>> memcg
>>>>>> and unock rcu" in another operation.
>>>>>
>>>>> Do you mean adding a helper function like get_mem_cgroup_from_folio()?
>>>>
>>>> Right, something like
>>>>
>>>> memcg = folio_memcg_begin(folio);
>>>> folio_memcg_end(memcg);
>>>
>>> For some longer or might-sleep critical sections (such as those pointed
>>> by Johannes), perhaps it can be defined like this:
>>>
>>> struct mem_cgroup *folio_memcg_begin(struct folio *folio)
>>> {
>>>      return get_mem_cgroup_from_folio(folio);
>>> }
>>>
>>> void folio_memcg_end(struct mem_cgroup *memcg)
>>> {
>>>      mem_cgroup_put(memcg);
>>> }
>>>
>>> But for some short critical sections, using RCU lock directly might
>>> be the most convention option?
>>>
>>
>> Then put the rcu read locking in there instead?
> 
> So for some longer or might-sleep critical sections, using:
> 
> memcg = folio_memcg_begin(folio);
> do_some_thing(memcg);
> folio_memcg_end(folio);
> 
> for some short critical sections, using:
> 
> rcu_read_lock();
> memcg = folio_memcg(folio);
> do_some_thing(memcg);
> rcu_read_unlock();
> 
> Right?

What I mean is:

memcg = folio_memcg_begin(folio);
do_some_thing(memcg);
folio_memcg_end(folio);

but do the rcu_read_lock() in folio_memcg_begin() and the 
rcu_read_unlock() in folio_memcg_end().

You could also have (expensive) variants, as you describe, that mess 
with getting/dopping the memcg.

But my points was about hiding the rcu details in a set of helpers.

Sorry if what I say is confusing.

-- 
Cheers

David

