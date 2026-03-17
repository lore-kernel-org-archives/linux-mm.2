Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA9CFB5EBC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEC06B0005; Tue, 17 Mar 2026 00:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6806B0088; Tue, 17 Mar 2026 00:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14236B0089; Tue, 17 Mar 2026 00:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A18146B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:37:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E48013AF36
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:37:17 +0000 (UTC)
X-FDA: 84554295714.02.3893DF4
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 516944000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:37:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fYW/2Z+H";
	spf=pass (imf01.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773722235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/D/uyf3nn8bxGRwMVEfXcttdOuJQ2DTCrN1S57yUG8=;
	b=bQg5Gy8bFs9EuXKNiDQ/JiUwNZ8wlnjQ8mh6zM1h8aMHNCjQ8qFKC72ihAlO3GNt568YKl
	Q+7G9Uj9I0kyEmEus819LbXeEP+4wNLgDhQoQiG7VeA/7xwV/LBK8UpyLAVMBIoZuQABc9
	DgdoKD5I+rY3lOgzm2my4yns6idAPpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773722235; a=rsa-sha256;
	cv=none;
	b=IcKZJVFHKGFNjl0H8a8XXFQ0IPHUYhobETAWFzjf2ST1SCZGXzKOf1Sgrk65wmvFGwAIma
	NrNBscA4y39VXrzruM+cRjqDQB42pUGUI/WJ45XLeki1GrMHi0wt5gAAm9e0E2NLnzCPzC
	n9O7BAmbfNPOW22wkX6kBhkYfKSQv2I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fYW/2Z+H";
	spf=pass (imf01.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0d66401f-9874-4047-971b-632723b0b7ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773722232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/D/uyf3nn8bxGRwMVEfXcttdOuJQ2DTCrN1S57yUG8=;
	b=fYW/2Z+H7GDqviCHCJxlMlopFyd0rVRST+Kt+qnMmSRDH0/2HSkqYnt2zM4572KfZ1IoMF
	QdgnYxrOKNf7viUh8MhHQAFvHJN7K/tJkMImaj7zfLcg4xzDV79pXlx4AMJIuYxrBKmTmc
	5yfsO6dct2hccDcLaUMMZOKdVvIkn3k=
Date: Mon, 16 Mar 2026 21:37:01 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@suse.com, apopple@nvidia.com,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
 <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
 <c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
 <87sea0o55p.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <87sea0o55p.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 516944000C
X-Stat-Signature: qxgaa8pmt4rbb1fhnk79djchq81c73ss
X-Rspam-User: 
X-HE-Tag: 1773722235-24095
X-HE-Meta: U2FsdGVkX1+XOyqSGTDoA9i4tX43ZuWinkgwMM+mr4PQHah8N7yMrGGgvTRTZjP6V8GkCydN2MuxZx0M5eqzT/8qRn1MbOQj8N5B3zngVSjdMk5XGOVoBhki16gP7jlY8P+opnvttqTDAoWEq63wjKLDrqFeKIm4Y2b+oa6v1N5GD9aBLc0DKZhniHGpUZmHoknRY1IKjCML+BY/NEEOiG3gWAi/9ZeKcAguBTeDpz4w6qJs+Zds3BCLx3U9teoeacTEicEjj8r1tq77b07BduD+wWuwMLghWv4RQYU5hGJ15D2NM6+Ld3ummk7Zqxz073nuZVgL3nUtg4BSn7LjtT/bhGaMlrXunDYVZyrTkyQFKmFaFMkSwfERemXfWM6RUYkdUQhJFpTTvELkouyNQJ3tLE8z2DuXnh2rGk3ebYMs3EyQRYdyW0DEcEWanp+v8+0nPM708fTfeYrW6qE2aFGOZeY/Bt5/Az1dhtxaWcT3Y0H9Ch/XaNESRqLh8sF1BCqi9NVB58eKGF5ZPMvS5ER0YU8R2YSw5Y1I4fFRV1KjmR9TxUVT7+1lPELDdkrSuEporK947iJNz4LmOrMTjVaKUQU7oP4oU6SijL7GFu8zwXaxq8npgC3ZgDXHKdjO5rPCfuf0tUNC2jlXa6tVZ9ylbZbm7yGV9+Wfn9nwggS49alLYrtWCRN7kB3fd2+HSkPzte1rWLXxHLrLio+go/UkyHik2Gttj5Q6WvxJdJw2TZRN3OBvfvdsMPKeQCuYY5cqW4LbkLDxHfeD1IiwEwiy5mBTrRe61gbDXkkq+MwUBz6rkMTfmkK1aksOW7s0761Uwq+6qelMAyZhPK1H53bMIkAxt8pafc+Vhz9zePhcWPrVbZLokfzFH0Ht72uZPANSR+/vHRg4L6+RC1+eaComZzcN5N5L6eSlJq7nEFK7iCEZ3SyEZyloDXHXZFo2iVZs+qCZswbsHj7DWuA
 vTB0Uu5X
 YkE7AXzibz+yoCK+Cilx2AsrVfEI5gTvUP+sTQk+q53E1OWtsFZODAQU2JwmTXwk2N/b9UKDzJfSvnBF7S0PsGMRof3/9SLzcIZsPNUkcl0KnOnEpBZPkvst324bfFwPK/XYK5wsHglBsfioVViKTrGPds13GrueSuk9ZI00+PiQjRy9Hv7PLzsQbDUsm54VPyST9aBtIKecxBU+Gc/9XBsjHuYt3b2ROWMOrNdoW/NDOzcrBzY1OGU5RZwlnGhIkSnZhWIg81g4B5bUd2J8rPFuOHXhZThQUtpajWHaZZaogyN3B15zlZsEPoErBq1SHrewO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 7:54 PM, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>> On 3/13/26 12:34 AM, Vlastimil Babka (SUSE) wrote:
>>> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>>>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>>>
>>>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>>>
>>>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>>>> already proposed (visible in quoted text above). This would still
>>>>>> provide the otherwise missing signal of whether policy-driven
>>>>>> allocations to a node are intentional or fallback.
>>>>>>
>>>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>>>> 3 new counters will be global per-node in response to similar feedback.
>>>>>
>>>>> Emm, what's the difference between these newly added counters and the
>>>>> existing numa_hit/miss/foreign counters?
>>>>
>>>> The existing counters don't account for node masks in the policies that
>>>> make use of them. An allocation can land on a node in the mask and still
>>>> be considered a miss because it wasn't the preferred node.
>>> That sounds like we could just a new counter e.g. numa_hit_preferred
>>> and
>>> adjust definitions accordingly? Or some other variant that fills the gap?
>>
>> It's an interesting thought. Looking into these existing counters more,
>> the in-kernel direct node allocations, which don't fall under any
>> mempolicy, are also included in these stats. One good example might be
>> include/linux/skbuff.h, where __dev_alloc_pages() calls
>> alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
>> zone_statistics() and increments the stats.
> 
> IIUC, the default memory policy is used here, that is, MPOL_LOCAL.

I'm not seeing that. zone_statistics() is eventually reached.
alloc_pages_mpol() is not.

