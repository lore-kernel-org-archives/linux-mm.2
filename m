Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41CE4106ACC7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7504D6B0095; Thu, 12 Mar 2026 12:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD936B0096; Thu, 12 Mar 2026 12:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D376B0098; Thu, 12 Mar 2026 12:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD576B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:14:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22F061C11C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:14:12 +0000 (UTC)
X-FDA: 84537907944.13.6EBB72E
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08D9EC000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:14:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=foV+uUBl;
	spf=pass (imf22.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773332050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8S9kpSbMrF1j0QA2GDOXqTycEozhSapelcYr5ulLYWk=;
	b=l5pfJ77ErHvfjt8ApYYXv1pxd66osi2hIt/B37RSHVq04V02Py3FjNEil+NqWymG1ilpwq
	n/NYlgNp3MPL4GJULJvLqZDZCo3wq8hmakVsZar4ODhKAGt6E5SCe7J+kipfKtzb/T1SM2
	QoPQg0uXaDRm4CSex1eO6J0TBVsf2l8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=foV+uUBl;
	spf=pass (imf22.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773332050; a=rsa-sha256;
	cv=none;
	b=n629Xx/ubhLHRI8BHuCeRNwG9Ciu1jRc0lZniUU1xu69LoGXNFPg0Dy3H6TKfv2/PE+f5R
	8g6r/ih6G9+XjC9+YpDOZZSwSEvy6EIAYpEosCjBUDhC80tJyG23ONQefCK5VkQjAStxSz
	HWcEniibDOzFg4a2iiTIlScJhPF+SZs=
Message-ID: <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773332047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8S9kpSbMrF1j0QA2GDOXqTycEozhSapelcYr5ulLYWk=;
	b=foV+uUBlJDuw7ebXJrD2UQy+HMDbOyN1uiGoY/VhPevytnn5dXWRnRSayiOqBIlKU0menO
	48Tcq8P4hlTuSKLvFiNOlHu7YIe1SaoY4Q6TeSKOWGkYQrSs/j2yy1QuQu9eswLlXmMmf0
	tev69CksT9lwmShZNQ3xpJHFGmHYk4Y=
Date: Thu, 12 Mar 2026 09:13:49 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@suse.com
Cc: apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08D9EC000E
X-Stat-Signature: 9p1y7s8qhz3d7ar31h4d7bhhejffjxp8
X-Rspam-User: 
X-HE-Tag: 1773332049-648026
X-HE-Meta: U2FsdGVkX1/0ohsWURwglrzL1cbp/uSAvd7Bo1LYAeBlpR0dROUYMO5qhbRdrXIYBnlVQ8Caa/M6xbDlqqGAuCN3gQ6tn3oJNOjVq9R8hf9j/7Km5LoBwyq+nDwk7AcM0eGC7TPnQYbRObajqEpPwIcivOafcnvvUxR8Jgo1Y25XY2p2NPJrRUTP74icjLAx86yt0y54h+7HsVqBt7HRA9R9KK8rjOGsi/t/saxX4TFhtEefSmGDzuv/0/Q+UEV5DoxLfORn7tMQIg8wEXkSmh1lv7WjqqsIElQYYLvfqYGpx06Dlr8NTA9Bg0X5gGg04LmUTzT2PmDg0NPv/K3c+aCCG+nfHn6W/rvn9zxMQV7DU4dcFiw60j08GkqFRm9ApTt82LZEv9HZmWjqz/rebyOZOd3X69xnFrdupADfIbJkGbzz56YLAUPZHPEOYmCTiqbY+rkhv6p7Ryk9Yz9+3y20Zu16fa/hR93AjGpSs6YY4JyVQ7ixuFzQ5NtyUZrn44KbwshRqIrmnDYyff8NHKszFUmmW8QgkduNsVs19vtGv5mlFVTk8oxz2NVM26aU3FuIn/ZjQsXrrdAhSK6tnERTMOQ2fEysQyapx3MH0sdquG/1Q70T3lmNMMonZai//SgEw303iCHCShUqcgca6ftz3mHRbGEiUwmQFwLxAQBgMXy54V2xrMm3XM4PHEqi7EUe5qsdY1JXFhglxtHnec3s8E0JNbCFBllLAR70ij6K64XJBHT/dEImjls4SH/V/QPZjR1eZLZgjcMgwirgKUMAX2H9qv1cpp7YdQt1WtyRaK+46eaXkDY7b+XLmfBfUKtY7FA6ZoR/YvlKOLO0tHeTut8wI1OZINIPaZKAAc1NyvFxcfii9oGvT7HDl9XdJeSSc8Zrv1aCTkwL/8aZw3crRkWHPFRJ8QrgRQOhpwxkOoHi76IJ6EGXc39NZcJj223rg9qkVxDStTnT+7y
 jxTtfMQt
 HXPGFQEp1ERl7Vea0dJdwCp6d4+KvoiDqUMCv+2Nm1fOgTdwJ3K0+DcV+d99CbQIQns10flHyYSk2JXhSdN1riv3NPhY7KEIehed3cw4h9Aln3Z1M058Hs8lbmRs8/ErMAelcJcx0MfIc9KzpLggvyj4HaN1MJTvCFi8+er1T2/OINnlcCn6XKwPsNab4jvvgETbBXODFOCmSyzxrewy5mDI3vTkgSKR6izK+jrTIhpaiuwseRNtiD340feHJgCPXtQNH/vSv4hKkf8MYKZzwcWpy9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
> On 3/7/26 05:55, JP Kobryn (Meta) wrote:
>> When investigating pressure on a NUMA node, there is no straightforward way
>> to determine which policies are driving allocations to it.
>>
>> Add per-policy page allocation counters as new node stat items. These
>> counters track allocations to nodes and also whether the allocations were
>> intentional or fallbacks.
>>
>> The new stats follow the existing numa hit/miss/foreign style and have the
>> following meanings:
>>
>>    hit
>>      - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>>      - for other policies, allocation succeeded on intended node
>>      - counted on the node of the allocation
>>    miss
>>      - allocation intended for other node, but happened on this one
>>      - counted on other node
>>    foreign
>>      - allocation intended on this node, but happened on other node
>>      - counted on this node
>>
>> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
>> in /proc/vmstat.
>>
>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> 
> I think I've been on of the folks on previous versions arguing against the
> many counters, and one of the arguments was it they can't tell the full
> story anyway (compared to e.g. tracing), but I don't think adding even more
> counters is the right solution. Seems like a number of other people
> responding to the thread are providing similar feedback.
> 
> For example I'm still not sure how it would help me if I knew the
> hits/misses were due to a preferred vs preferred_many policy, or interleave
> vs weithed interleave?
> 

How about I change from per-policy hit/miss/foreign triplets to a single
aggregated policy triplet (i.e. just 3 new counters which account for
all policies)? They would follow the same hit/miss/foreign semantics
already proposed (visible in quoted text above). This would still
provide the otherwise missing signal of whether policy-driven
allocations to a node are intentional or fallback.

Note that I am also planning on moving the stats off of the memcg so the
3 new counters will be global per-node in response to similar feedback.

