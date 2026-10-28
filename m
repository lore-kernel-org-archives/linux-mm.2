Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D817606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WeW0dcEy
Received: by kanga.kvack.org (Postfix)
	id 217E26B0612; Wed, 28 Oct 2026 00:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF2C6B0613; Wed, 28 Oct 2026 00:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106CD6B0616; Wed, 28 Oct 2026 00:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E37C46B0612
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:33:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE46B140B91
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:33:24 +0000 (UTC)
X-FDA: 85370765928.14.EB6CE06
Received: from mta1.migadu.com (out-222.mta1.migadu.com [95.215.58.222])
	by imf22.hostedemail.com (Postfix) with ESMTP id B4703C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:33:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WeW0dcEy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.222 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793162003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoaYYE9clIuJ0Ig445chvZt4nolRKxe5BT9MRTh3Egg=;
	b=6b48w78tV586ASuhvH2z1CWor+9xBk1BZKG0ewz6WYVpc5cUuXWcQpaWxBoZtne7ZfRui4
	cGQIbCthfmiiDYKR0B9ImeqtAm9+J8LsuJ6hV78rmwxiBUWB1EfSBazA5pqQWHMYIUScCB
	rQ9VTUgFLZt0uzYKPSyQKMedGgrse/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WeW0dcEy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.222 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793162003;
	b=rx9xda0wuDdZjMbDUp4ph6hOSZj1WMhptwNlkUoxV3pz+HLs+ZrzJcFrcUwOy21wISG4zT
	TAqdYDaaX6wwZ9E3rHFMmLqkxpnD3bEgFfe71jmQZf5AlF90S6MCk1xi1Sd+qL0Zy6lJe7
	Pux9+enmg5MnuMoKGsSzqC4/BHhARJs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T4efCo2Hap6aPJgKK/ehUGhK0yIt+mn0LCQnSmlQd0s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793162000; v=1; x=1793766800;
 b=WeW0dcEyzkw6mTIdVt2Z06iHEedOA9csfafpNxIqlvgXWGNleOMk4G5+xIqtxnfY0oJlEGQo
 3RIOLo03odtO32V/gvt274JFHEpf0OAsY2K6WgJh+s2w2M9H9KOLel/juzZL0FcuRQ3OjvRdcI0
 9UEAxWdkfJdjVzGrmw7+tycY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bee4a2cb7972e2c2;
	Wed, 28 Oct 2026 04:33:20 +0000
X-Mizu-Trace-ID: bee4a2cb7972e2c2
X-Migadu-Flow: FLOW_OUT
Message-ID: <fa0f07af-e8d7-44b0-b1e7-ad325d75ac34@linux.dev>
Date: Wed, 28 Oct 2026 12:32:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 32/46] mm/memory_hotplug: avoid races in
 pfn_to_online_page() with dying pgmap
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org,
 peterz@infradead.org, jannh@google.com, pfalcato@suse.de, hughd@google.com,
 pasha.tatashin@soleen.com, pratyush@kernel.org, willy@infradead.org,
 jack@suse.cz, ziy@nvidia.com, riel@surriel.com, harry@kernel.org,
 apopple@nvidia.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, jhubbard@nvidia.com, peterx@redhat.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 osalvador@suse.de, minchan@kernel.org, muchun.song@linux.dev,
 xu.xin@linux.dev, chengming.zhou@linux.dev, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, youngjun.park@lge.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, jgg@ziepe.ca, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, josef@toxicpanda.com
References: <20261027-fixes_core-v1-32-6f74bec9a5bb@kernel.org>
 <20261027121307.40431-1-lance.yang@linux.dev>
 <87e3d64e-8b25-4d51-a984-7ab8a58f785d@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <87e3d64e-8b25-4d51-a984-7ab8a58f785d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B4703C0002
X-Rspam-User: 
X-Stat-Signature: gxfc7itzcpg73y3bmhkbyajafamxkjhd
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793162002-461208
X-HE-Meta: U2FsdGVkX1+alCybVjyQYo/QDJAEdYev3D65CNkYZdd7b6rybCaaAzTcGcHOZABy1eMJ7ZUaplhVISsWFRD9wYEkJ+RcIMlHJDtQdQOzj5KhJ37oiLHyzAetjiKudPx5rBhwgIj0mcZj0QqyxOLfslRDEUKLYbzw0mleASDQTBEzw4MvPwpeD5ZlbLX8URjp8JQWT5OOR1ieE6HTfTQcyZ1jGzqCiLHGq/AyfA0JW43h9dH04Apf2lCnu59fMjzL8s5AywSgPD8e6DxH1BBut/cVV418ZmczTuyrrNzkNPFiBbYoV+up0EfEDuAMTUenviZn30RjGiRVwFkxzsoTNfb814R2IXvO3pgWTD2+xd0+4qc7VXGRF1UySA+Z/p2Un9FhHwfJFyUFIB4MYyUF8ohoJjT9IRcWeYyequIfvGpgc5YaiSDGZWwRrEp4qmoPqz1+BjNJ0UpCZPUYIKaXUErAVDvULJh70dN3HWGJkhwYWgkebxWykXty5Hk+pZ4rfRhigBNbymQyDzOrzL+ShHmlJWsu9W0MgKpTNohUnpTwjUl9HEs96EgJ8nDHHcbZXbyd9+8eVbJhNEVZJSInJYnEUe0YiGgQZqud+nV+Y31lBfaC6XS3W78y+I47Rxq8XqSlPXmziULoBAtfcmZFq/wXRzpZgbCDlBFovV2EX3J89QuCYAETuiCuAmcL1BZ7BSLXRdBaSi6fteOYR/TAWRCVIdszPYaSe1wycJ9Wk3/1/l8gNEF8YyTAcizz/hst9t3RqHAkYVRPP9V69/56vDxSn8BypyAr2+u78bgM4EeuL1ZdFWTM9UeWvK8VhEpmo4XbzhF28MkpVMay4fraJApmqLXAkB2RaFuWAkcd5kUebiQIMkNGSwjKxLmVdkwhI5LEz/b8hyUW+YLwudVA1xlr59eDTe+YihgIlnJMjRjDT57L9jSS+9NJew5cLzXMnwrJC/NQFBdm4jwyUz/
 RaixzGF3
 3dF2FVrAc3o2zJCu47uIv/ddbV+fQUJVMuq+t+vpTRSG4fIzmQqlwr6vk31Vc6UuXfBHhC8YiD9foHx5rWL+MFUg8CqcGOgUn2hsOL/7+6QlY3yHLaU/wGnTLhYvD8EEhPFiCwMRsBH5sOTnpMyf+QzQeGzji2NqufpOE7PoUwXLm8MExF17R7+J486ONp2Kr/vV1pz3w3ycpigwoNVX898OFbicrJuovSN3RyMPaxaw7jYhoLU0kewKajBw0dEvWGUyjSpLk+6S0Pwt8gXwSRBSBTV3zNqbbpH+XDALAP6Pu1QQO0A1wQM6ZHhoHaflQN0MVF9nu0QbvaqtfdAYrxP1wEtza0QMFFoQSkAsM6lUNW1+dPvvoMY9wiTpSl6D/clIHHu3Bjx2+JY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/28 03:41, David Hildenbrand (Arm) wrote:
>> LLM stumbled upon a possible race in kpage_read() ...
>>
>> Say the reader passes pfn_section_valid() for a device PFN in a section
>> shared with online RAM, gets preempted, and resumes after
>> pgmap_array_delete(). We'd then find no pgmap and return pfn_to_page(pfn),
>> even though the subsection is no longer valid ...
> 
> I think that's similar to our pfn_to_online_page() vs. memory offlining races,
> just slightly different. Getting these races down to 0 is pretty hard.
> 
> This patch here tries to do better and arguably almost looks like a cleanup.
> 
> I wouldn't worry about that one for now; it's extremely unlikely to hit. And it'

Ack.

>>
>> Could we take the memory hotplug read lock in kpage_read(), covering both
>> the lookup and the metadata reads? We can drop it before put_user(), once
>> we're done with the page.
>>
>> Maybe along these lines?
>>
>> ---8<---
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index 6aa99e42ec22..12bed36d76dc 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -12,6 +12,7 @@
>>   #include <linux/hugetlb.h>
>>   #include <linux/memremap.h>
>>   #include <linux/memcontrol.h>
>> +#include <linux/memory_hotplug.h>
>>   #include <linux/mmu_notifier.h>
>>   #include <linux/page_idle.h>
>>   #include <linux/kernel-page-flags.h>
>> @@ -77,6 +78,8 @@ static ssize_t kpage_read(struct file *file, char __user *buf,
>>   	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
>>
>>   	while (count > 0) {
>> +		/* Prevent memory removal while inspecting the memmap. */
>> +		get_online_mems();
> get_online_mems() is the big hammer we try to avoid (or ideally remove at some
> point). And it's most pfn_to_online_page() users that are affected.
> 
> A seqcount in pfn_to_online_page() could detect concurrent pgmap removal and
> retry from the start. But I'd rather delay something like that.

Fair enough, let's leave it alone for now given how unlikely it is to hit :)

> Thanks for taking a look! (Can I convince you to review some of the THP fixes?
> pleeeeaaasseee :) )

Of coursssssssse! I'm already looking through the THP fixes :D

Cheers, Lance


