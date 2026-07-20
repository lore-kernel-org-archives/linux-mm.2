Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D558C44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B171A6B0088; Sun, 19 Jul 2026 22:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEBE6B008A; Sun, 19 Jul 2026 22:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B886B008C; Sun, 19 Jul 2026 22:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6836F6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:32:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA863160719
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:19 +0000 (UTC)
X-FDA: 85007580798.29.DC839A1
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id B540020007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oYYjtgH3;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784514738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zQIBCc7A0jp8hH0iRn/IpZGk9QLI5Bvnk2tEw8qHXE=;
	b=iBfb7Rz1+gchbARwMjJA6afLNL/LOxDkHxfxdFF/burloqmmUaPGWxAhtXZMygXUt8gGoS
	60bV9VQ/p9BA+s/ilZ45uYt9LAOdB1/JoFF/ms0fGAjntyIiB/BnyNQt7mp/CrFXBOZdsi
	k/lu42E+Y+bYoC+8W+nlJ5qT4T7fYno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784514738;
	b=pGaOk0zG3yih/R6o/QxzuTriM28ucYUP9WbzLut/dbPxbJtBkzewhRxRHGY785jj2+IQbV
	OBF9Gqshlf6feKvy3i0bzMWs09nwqjPlXzOiH2aVZRR7Zxqz1P+HLmCUHTvrTF8ndiRWP7
	XznMsQSXDxszOpJNeMeCjsU4+7RrVVs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oYYjtgH3;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c32645fe-4c66-428f-b027-0271cd99f76b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784514733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zQIBCc7A0jp8hH0iRn/IpZGk9QLI5Bvnk2tEw8qHXE=;
	b=oYYjtgH3YIMhc0f428t7smjHTRH5wJAoZbkfNarNMiRs81bcV+Hk2K7ci2ydaKrfo42gee
	e+IcpGliv1TIwnBByPrfzyCXXdyy2XFy+CQ/4P7HaLQBP4LrQLSdz5v/+6tk0eb60COEmY
	FRcFzr/eP8OkYGtytAilNXuQVgkS2vg=
Date: Mon, 20 Jul 2026 10:31:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/thp: expose deferred split folio memory usage in
 meminfo
To: Johannes Weiner <hannes@cmpxchg.org>, liuye <liuye@kylinos.cn>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
References: <20260717063025.168436-1-ye.liu@linux.dev>
 <alngSdkM6iEGpETe@lucifer> <102bada7-66ae-415d-abc8-12d5939b7ebb@linux.dev>
 <70294b26-86e1-4de0-832f-d5cb488cdb3e@kylinos.cn>
 <20260717102909.GA6843@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260717102909.GA6843@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B540020007
X-Stat-Signature: kokh7bfk4q8f3ux5kywtpnt1575o65ke
X-HE-Tag: 1784514737-38487
X-HE-Meta: U2FsdGVkX1+lY4IAAok0I8H48iTjnD6IuLfbRqzEunwPYkJRMeAPYS2M6+vj1V3NALQKZgorolJkO26QEBZihQBGcIVVFwP6TO0zWeMc8M+O0KwfrSHAgVU870rh7VJnP+GkApSEU9eu2fKUjmnyW87Kz4Eygl9Rp5a9wwCNNOdVeOse4qGnfoaxP5p55bP+huen3PuCiV4bpdQjWBMSXqXLWjllQ5Mn4ecLVheG1kQ2n70kM7Kj9Nmq5G19x8gTHRjx9OwpCRAdvJkWATJ9YgcRbJCyW9m6sOViKEPLZGdz5TLYWacSDxbsG5Ts4qNrSAmBkX91/oXx+2lbVsv8mwqW8HfQ3regSFzayDm0EFAqgQBEAz+aSkeJqhR24Gb0A+nWrrDQFhboTWLvlLGImV4Q8I5FoLZ53m8bE1234qGhZf1SnEJ2C0AF7JEjiLgCjzeaY08v73vy8kLwl+wf6g2Oy/gFmofREZbjqJsaoggiHa0jSjeTNfW7HLFSqaNfabg+j6SCVjqnwMEWFEQxWwQmysVh3JJCVQ7fAwdRE+SZaQvHuvNOzumLptb/eo529pkYoG/95oy7oiXhtyQ6uWIj+ArGQz6p6rq4Xihvsz++B9FI/yuzgw/o6OrlQGQPnOLjU4LZOsC/F3fJn3MVGiPZ462Qnh+oyNQFyuuCWp3fgpZfOBsoa7VujzyNhRoo4P3xn8/3BzSOsm+MUcPSong1fwhU7ofw9yO8iI95vO/RY1y3N1YmpJ4nBEmfhv6+q4/kxD28ucKiLrqOzIHd38w68I7qAf5NEfHkOAO3SKgAcFwJc9pZNfyei30Dp/OKVuxzyEIGuwWCt/hdt2x4ERtlxJp9H9DudOqXDKWwx7YqdSpxKogFN4ReQijKp4ZXmwcGHXm5Tya+x73T3+86l4RXN7ojq3ob+MJcX8ShcCqP4z++wsMYCfaw2KwEMHdwiKS6JRMTpyrRWVcRxqe
 G1Hk0hx2
 KJvJnYbbfsZig3y6j0VI+DuMTs4UQOHz229sp3Qcsj4MslzlHJM5Mmpxt9XuiMLdQEhfnxlo/ax+D4fmiys6UCIutLqL2L9nARXPEm4lVJSYDgwp0Vrh+FugavtYl1hUnx2rF6zZCpNtiuNNtZKpTJJnkAiVad/q1ZghhotgzJfDeS9DW1LRix+I6djutc5J+IDLH4i59tU20JMC8BTkRr/BtTBGxqg0k6lGs2rP23mzWnlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/17 18:29, Johannes Weiner 写道:
> Hello,
> 
> On Fri, Jul 17, 2026 at 05:38:10PM +0800, liuye wrote:
>>
>> 在 2026/7/17 17:24, Ye Liu 写道:
>>>
>>> 在 2026/7/17 16:08, Lorenzo Stoakes (ARM) 写道:
>>>> +cc Johannes
>>>>
>>>> On Fri, Jul 17, 2026 at 02:30:22PM +0800, Ye Liu wrote:
>>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>>
>>>>> Folios on the deferred split list hold physical memory that is
>>>>> invisible in meminfo. When a THP becomes partially mapped, the
>>>>> unmapped pages are removed from AnonPages but remain physically
>>>>> allocated until the shrinker splits the folio. This creates a
>>>>> memory accounting gap where used memory cannot be attributed to
>>>>> any meminfo field.
>>>> Is this really that much of an issue? You're not giving any use cases here.
>>>>
>>>> What real-world use case motivated this?
>>>>
>>> I have indeed encountered this situation in a customer environment,                           
> 
> We have run into this before as well. It's not super
> rare. Applications do partial unmaps or protection changes with no
> awareness for THPs. The issue is likely to stick around with legacy
> software for some time.
> 
> Do note that all information is there if you know how to look for
> it. But it is cumbersome and somewhat inconsistent, so I'm not opposed
> to fixing it:
> 
>>> but the environment is complex, and I cannot clearly explain why this memory                  
>>> black hole occurs in that scenario.                                                           
>>> However, I will provide an example to reproduce it below.                                     
>>> Use case: The system has 100GB of memory. A user-space program requests 80GB of memory.       
>>> For each 2MB block, only one page is retained, and the mapping of all other pages is unmapped,
>>> while the process continues to run.                                                           
>>> You'll find that in meminfo, MemFree: only 12GB remains,                                      
>>> but the process actually uses very little memory.                                             
>>> This creates a memory black hole situation.                                                   
>>> Below is the test program I used, from AI.                                                    
>>>
>>
>> ps -p $(pgrep -d, test) -o pid,comm,%mem,rss,vsz
>>     PID COMMAND         %MEM   RSS    VSZ
>>    9358 test             0.1 165220 166032
>>
>>
>> MemTotal:       101606276 kB
>> MemFree:        13172092 kB
>> MemAvailable:   13569668 kB
>> Buffers:            5352 kB
>> Cached:          1169520 kB
>> SwapCached:            0 kB
>> Active:         84730404 kB
>> Inactive:        1129792 kB
>> Active(anon):   84730404 kB
> 
> This shows actually allocated anon+shmem.
> 
>> Inactive(anon):        0 kB
>> Active(file):          0 kB
>> Inactive(file):  1129792 kB
>> Unevictable:        6192 kB
>> Mlocked:              32 kB
>> SwapTotal:       4194300 kB
>> SwapFree:        4194300 kB
>> Zswap:                 0 kB
>> Zswapped:              0 kB
>> Dirty:                24 kB
>> Writeback:             0 kB
>> AnonPages:        969280 kB
> 
> This shows anon *mapped*.
> 
>> Mapped:           308848 kB
>> Shmem:             45076 kB
> 
> This shows that your (in)active anon *isn't* driven by shmem.
> 
>> KReclaimable:      96144 kB
>> Slab:             269540 kB
>> SReclaimable:      96144 kB
>> SUnreclaim:       173396 kB
>> KernelStack:       27584 kB
>> PageTables:       187408 kB
>> SecPageTables:         0 kB
>> NFS_Unstable:          0 kB
>> Bounce:                0 kB
>> WritebackTmp:          0 kB
>> CommitLimit:    54997436 kB
>> Committed_AS:    6628776 kB
>> VmallocTotal:   261087232 kB
>> VmallocUsed:       38696 kB
>> VmallocChunk:          0 kB
>> Percpu:            42800 kB
>> HardwareCorrupted:     0 kB
>> AnonHugePages:    413696 kB
> 
> This shows anon pmd-mapped.
> 
>> ShmemHugePages:        0 kB
>> ShmemPmdMapped:        0 kB
>> FileHugePages:    172032 kB
>> FilePmdMapped:     28672 kB
> 
> This shows both allocated huge pages and the pmd-mapped portion.
> 
> So you *can* work it out by looking at the LRU ((in)active) and
> cross-checking the shmem position. But it is awkward, granted.
Yes, R&D personnel may be able to draw conclusions through analysis, 
but this is indeed not very intuitive for operations and maintenance personnel.
> 
> IMO if there is a case to be made, it's doing the same split we do for
> file and shmem - AnonHugePages (allocated) and AnonPmdMapped.

This also adds a new field, which doesn't seem to be welcomed.

-- 
Thanks,
Ye Liu


