Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13DAFD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 06:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0554D6B0088; Thu, 26 Feb 2026 01:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BB76B0089; Thu, 26 Feb 2026 01:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D166B0092; Thu, 26 Feb 2026 01:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFA406B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:46:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5ECECC311C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:46:01 +0000 (UTC)
X-FDA: 84485672922.12.C6A2EC8
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E03B1C0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:45:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqwCC+zh;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772088359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4rL/wwllg6CU5AzOZho/BUjc41JirXfRLVAIZITAog=;
	b=kTOHfnUgM6ueBwJ3H+rkvRtBoQ/z+b70ZQUtfbVpYbowy916HJ/9ZhzRZcdGu52nkUnyRC
	zP0g6UchRkR246u5iuScmAyxzooQHJP5ddWJCBRlcjxyInMNGmITXAxF0ZAHur/LFGU054
	3FRytJoe76WNM18AO0UmEnD1SkwlqL4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqwCC+zh;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772088359; a=rsa-sha256;
	cv=none;
	b=MSiHPTVayblrb9M0/1HfI1xoCQn8NsjNeg7dP3xS2Pnb6p4j3w01rFFG4dSO6tm4NvHrA1
	egHUuDwh8kKB3JhOIBSCJ8mhQObWGGjlTv5E4Ezqnf8hjb63qPJY7aQFqNzEjFzZXO8teU
	oBhXhtSSogHQKfgNVkRlar8cbLPTSI4=
Message-ID: <c155f9e7-e4fc-46e5-999d-4422072f7d4a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4rL/wwllg6CU5AzOZho/BUjc41JirXfRLVAIZITAog=;
	b=fqwCC+zho2n+4/p9/dwF/Zeky6wKhrtDbuYw1zzSrKqzghBSWcypfO12waZoixPntWyd45
	WYrm3j6GECj3OS1oxAzopUY1P1+JNiN5ZEXDRr/Oa1k/Ir5/biWrClmwF7xAkvmnc6nRP6
	nZ/FW3jXXhmkxVqNOAPdkrxYdwl9SBk=
Date: Thu, 26 Feb 2026 14:45:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <aZ-kefGBeT-RzGcG@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aZ-kefGBeT-RzGcG@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: eikxdhwhhj188ys4k6rojgsst6bwdrfy
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E03B1C0009
X-HE-Tag: 1772088359-966147
X-HE-Meta: U2FsdGVkX1/mh23TZ3mUKBN/zDVgc4Fj037RWkAjkXIOqbAW35ifUljQqo0GbmeNMytygtj+3TeVKIFZslp8ah9zgdPxK8XlmYa4ao2UCmfZGh0+UfmEY8ZB/lk0H2/xr/iUe9mrvamzaafQmxyvjRxrytg+pKbGjE7gD7ARx51TW0aG7J4P1tEW0E1GObygvHmWDVH1vAv7jXaJv5FcocutzP+RZJcLYXnJln+PxJNfLNebqS8OSVTIXihcDZsYs/9S9jkm7lluFR9ZzOeREZwBIFC0f76Q9BEmLKio43DV+4iGtsDMQYKfZvkGNtaLUo1QlwwO/pyyHgJgQfLNm9cEZrnC+OBsT+SxrrkO4Q+f373cXqaaeT4OiSadJ7CkyyljGQUpj4ACH2niSqUf0rNfu961BDFxXnAh+BzQCknU2ZTTfePDY93aRnGWcrE64bV7w284EMGZmBC/a/0TZGz6A0jGrdmTsDc9lfqNV3SaqgHCou43WWHOSFTTJRaSAJF1ktuRXKQUslomHlSzlf6oHS+Cnxhs6+uVAck5G+Ok0lUqi+/Ur0kXM/dtywoxcaM77ra5ENfcS8gbpfxvckl3PU6xPHOWfPuQctNghBTylUJkQu5P0P1UPD/gr77MF3XmNqspg+5QNekvB6mLtH5YSupdn9FjIE6APyldK3FWGgHFlXYE/vwea7AqJi6wTBkO9oilRvkRHkBF3QIw/M8XigDi59eBmbRNn94C4iev6XRly0IdNktFtFyxj5E8GjZ7bQpM5sJJKVH8cFVBQ4UaCiQUzPQGIXIGj9h1tOmXin3SHmtUaCqkKDpBftyFFqTmtIkeZIx2UnDe5cSRS+ongvKMYnHkaDq4Cor037uM0QmEJTu70KX6DABJf0rkZe/ld481rpIONtyfNcTjyh/kBs/Do/JIoXpDMp0JGJeXlZJ6VTHdcJqn8T4sdO04v0P9bY/FPE3kvK8PSt/
 ++HlQdFx
 zP3sLVvUWrofG/lFO+TLQPLxaJY6ixW9Wp3AZuefKEE91raRzVWKCL3Mq47LtTusDdtKXK+mWRtYd6gHRGH9cdWY++H1zKPiVZ+wc8R4cM8Dv3+vRfnUmSvB6y6OcsWhyBKk1tUkmasE8tvyUOHOU6ULz/MUR6w7nxzjG3M61HRbvJHec1EuXE9rAKQPgxoFvwATPwlUCakCJwVH+r1dhMhovrDpObup0dSTEx/WZS3gCgELVr+PVuu32bCqSlGUpG5r/BfzV3jTOz9BVGBnzL3Uuyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 9:41 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 03:53:12PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>> memcg to its parent memcg. This could cause problems for non-hierarchical
>> stats.
>>
>> As Yosry Ahmed pointed out:
>>
>> ```
>> In short, if memory is charged to a dying cgroup at the time of
>> reparenting, when the memory gets uncharged the stats updates will occur
>> at the parent. This will update both hierarchical and non-hierarchical
>> stats of the parent, which would corrupt the parent's non-hierarchical
>> stats (because those counters were never incremented when the memory was
>> charged).
>> ```
>>
>> Now we have the following two types of non-hierarchical stats, and they
>> are only used in CONFIG_MEMCG_V1:
>>
>> a. memcg->vmstats->state_local[i]
>> b. pn->lruvec_stats->state_local[i]
>>
>> To ensure that these non-hierarchical stats work properly, we need to
>> reparent these non-hierarchical stats after reparenting LRU folios. To
>> this end, this commit makes the following preparations:
>>
>> 1. implement reparent_state_local() to reparent non-hierarchical stats
>> 2. make css_killed_work_fn() to be called in rcu work, and implement
>>     get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>>     between mod_memcg_state()/mod_memcg_lruvec_state()
>>     and reparent_state_local()
>> 3. change these non-hierarchical stats to atomic_long_t type to avoid race
>>     between mem_cgroup_stat_aggregate() and reparent_state_local()
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> [...]
> 
>> --- a/mm/memcontrol-v1.h
>> +++ b/mm/memcontrol-v1.h
>> @@ -45,6 +45,7 @@ static inline bool do_memsw_account(void)
>>   
>>   unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
>>   unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
>> +void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);
> 
> The above seems like addition by mistake.

Yes, my mistake, need to be deleted directly. ;)

> 
> After fixing this, you can add:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

> 


