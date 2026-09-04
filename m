Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2264AC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124C26B008C; Thu,  3 Sep 2026 23:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6476B0092; Thu,  3 Sep 2026 23:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012F76B0095; Thu,  3 Sep 2026 23:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1FEF6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:34:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66D9DA0759
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:34:24 +0000 (UTC)
X-FDA: 85174662048.24.6954B09
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36E0914000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:34:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gatbf+PX;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788492862;
	b=o4rxiK0fu5yPMYMdPVqCCDyFhXfz6RNXf/ajas4Cb3Wft9fEKoh3BeDYdnmZbgvlP6PAWT
	iBjkee7beiQfB4cm6V6wbvQuv6757aSW/vubGI4TaW2+etB1lftQ5BkCPZXlFd1OXkfjh3
	rdbbfAnR5I9o1CBd5cMVAB1mHthiPwk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gatbf+PX;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkXJA8+TwP0t94onh+VMi8eYNlWOODLQP8zvu7lb+4M=;
	b=EseFz9ZpHJ8a3+W+e8M6K+pSZBma6ZAhSAIJRQTvYuGB1nTUqZL/+j5UmZ7eeXDWfVibwg
	p9U7UwqtZutrq0qGWi5Ze5qaI22UnMGvdPq7D5x3z4izqLLisV1fFuTM5RucRLPVk75YS0
	wEpmXQR1o5yWF7sexpEMa19WTvg2SwM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3SHH6vyIlZHKBx7a2xpBQWHNha23K0qy+t33DbJnCJ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788492860; v=1; x=1789097660;
 b=gatbf+PXkROPX8r+/toXU0c7tzFZwmNXoMwnKB9jesRtDCuXkSmKWykcxVpaEa3YKCW39mrr
 d3LY0ltYkG842W0sgNSUPcf6S4wSLFxIhG8SfOIVLmooYFA+jZs+VpQQTUoo9Z97iSZeZuMdVL4
 XEHtFdtngQHVPlB01J7OYoBk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 76df9403c32be4f8;
	Fri, 04 Sep 2026 03:34:20 +0000
X-Mizu-Trace-ID: 76df9403c32be4f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce8d1bec-d281-459f-920c-7ce5bb17e417@linux.dev>
Date: Fri, 4 Sep 2026 11:34:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Chris Down <chris@chrisdown.name>,
 Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-2-ridong.chen@linux.dev>
 <20260903140003.GR3004@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260903140003.GR3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36E0914000B
X-Stat-Signature: r95msjhesnrshejsccq6ikukhash4z73
X-HE-Tag: 1788492862-665805
X-HE-Meta: U2FsdGVkX18YcvKCokgeS6dFg4M4HSMXZlSSaFr0Bwx4APYUfrSNhRn3IscFiA6Jp01xcHvSJNKOOouXjzsNtbaodCUn40oPmItDDBFW8URQvrmjT/qzRviyh1H6jGlCbkNQmg6a3IkW5h0gJdyBmdLAMrCsmrs6y2gczqLD76pDDmprfDg7nNaWvplKK0EC9HaNKT6fBHH0/CacCdge74+NeAI2uzkhRNcfcfQHXhwox/Dhjp5sF4hOM4qG2c5b9fOat2bIR60CZdOZ3esxmMU18R/z6iUVo04u4PhJ2ElKtguODhK5jRFqlqpaDQ+jojoPKeK9GSuBOdpja3+aGs6Tfo+EetMuzvvY+8U4UthtAoreILbbv7XFcLjpVgSRyTUeVYbpTRhSNBzUI3BcWrzlJxEuzXmWATPFwDrhriD7j+0h/GgY1s0DARu9aYB/SYwzW+TgFdZmgl1EzJuJ2CCnWSZIH5VGt5hoCSPM2IPVDjG3mBRYThpW7ZqkUS52SRUcxhYApl5gYVYjzFO38Gtte9Zz4PfdIA2Lo8+QoVOgDe2NC4f19lHnuRAu+7ky/nohpntsGs26G4fz3/HEOYdHdKWMyVEMMcaEaxInupwmsWG4IXIuKZs1dqw3rVparLvw4osl0l7BBytU1VJ5ufzabjLgoojb8dXEmIEpvfe9oMCaN4Q7Dqd9J6TY0MAu5BUV1f4uavK7QiXNbcYqRabhYE9Rzw1Bm6lb5H6o4kZxD/OWM6viID+c5ZN6bKzOWyeBHvQL0y27MYh3LQWaJo9Ys4cLJHLQOYAR3kBpmPWw7y+82dw3duz8nwzaxj5IjNEb4yCiqAM7h0wlA/uAhVELBfwhqDJLUafVzPEE1cLJhYhd0s4ZxV3cOJJibSFo8300KtJayQscYWtoLRjFNX4/HXh0vwMIf4yvu5dyEVEp/RTly/goAJ5omqQn4/ENGXH7sEzJOX7voAHJzXK
 sFRqlI6T
 beyLZC5oTSuBe5tI6wAVGH9vZ06pnDURAjgYQepd+RxzT0HZ1WQgFkbYNt5207bHuxtHXQUX8o+xr8NHlpQFzpqH3z9JuSKyuq5UH0UfVVRtUN927v8Nw+Aw3DVXJCf46flv767QJlFQYNzUrVudgsD8H5ckkycmAVxtDkRkeANe+pk6/1kwgcYhW+Ng6GWchdHQw0KWH3kRDa3FZnXeWxwvxAZnPoAVh+plVF8eInPj/lbqU5RA2vwj/aOKISMCZuAf14LEAXM3t/WiwFxkpkulCz/lJs7NFGSoqbOKXnBItQlibWmDKRQKFBypNS9oytvj1ERlUY6r/qimRaF8K+fOCJgjWeRlT1LJp+bBbxfrtA1txmOhs5GF370VRstuObaGtR+Qo9zZrK9EboOrk/jw7kNBfOvCocetexiWKoyUncfWt92HmDc7RpbY0l7487DNH0gW/rw0uNqNOIGWDjPRjFlXI3zoVf7N+MGP+8MgUavE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/2026 10:00 PM, Johannes Weiner wrote:
> On Thu, Sep 03, 2026 at 11:19:51AM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> effective_protection() scales a parent's protection by a ratio of page
>> counts, e.g. for recursive protection:
>>
>> 	(parent_effective - siblings_protected) * (usage - protected)
>> 		/ (parent_usage - siblings_protected)
>>
>> The multiply is done at unsigned long width before dividing. On systems
>> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
>> protection value and silently breaking memory.min/low enforcement.
>>
>> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
>> usage and parent_usage are not read atomically (a child is charged
>> before its parent), usage - protected can briefly exceed the divisor,
>> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
>> the ratio stays <= 1.
>>
>> Reported by the sashiko review tool [1].
>>
>> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1
>>
>> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
>> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/page_counter.c | 19 +++++++++++++------
>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/page_counter.c b/mm/page_counter.c
>> index 661e0f2a5127..e8bd512069c5 100644
>> --- a/mm/page_counter.c
>> +++ b/mm/page_counter.c
>> @@ -8,6 +8,7 @@
>>   #include <linux/page_counter.h>
>>   #include <linux/atomic.h>
>>   #include <linux/kernel.h>
>> +#include <linux/math64.h>
>>   #include <linux/string.h>
>>   #include <linux/sched.h>
>>   #include <linux/bug.h>
>> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
>>   	 * otherwise get a smaller chunk than what they claimed.
>>   	 */
>>   	if (siblings_protected > parent_effective)
>> -		return protected * parent_effective / siblings_protected;
>> +		return mul_u64_u64_div_u64(protected, parent_effective,
>> +					   siblings_protected);
>>   
>>   	/*
>>   	 * Ok, utilized protection of all children is within what the
>> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
>>   	if (parent_effective > siblings_protected &&
>>   	    parent_usage > siblings_protected &&
>>   	    usage > protected) {
>> -		unsigned long unclaimed;
>> +		unsigned long unclaimed = parent_effective - siblings_protected;
>> +		unsigned long unprotected = usage - protected;
>> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
>>   
>> -		unclaimed = parent_effective - siblings_protected;
>> -		unclaimed *= usage - protected;
>> -		unclaimed /= parent_usage - siblings_protected;
>> +		/*
>> +		 * The usages aren't read atomically, so a child can transiently
>> +		 * appear to use more than its parent, making the ratio exceed 1
>> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
>> +		 */
>> +		unprotected = min(unprotected, parent_unprotected);
> 
> Looks correct to me. But a few nits on readability, since this code
> already is quite painfully complicated.
> 
> Please don't do math in the declaration block.
> 
> `unclaimed` made a bit more sense when it held *this group's* final
> share of the unclaimed protection. As an intermediate, it's *the
> parent's* unclaimed protection.
> 
> Put together, it should look something like this:
> 
> 		unsigned long parent_unclaimed, parent_unprotected, unprotected;
> 
> 		parent_unclaimed = parent_effective - siblings_protected;
> 		parent_unprotected = parent_usage - siblings_protected;
> 		unprotected = usage - protected;
> 
> 		/* overflow comment */
> 		unprotected = min(usage - protected, parent_unprotected);
> 		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected, parent_unprotected);
> 
> With that,
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thank you for your suggestion. Will update.

-- 
Best regards
Ridong


