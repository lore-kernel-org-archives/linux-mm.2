Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC97C79F82
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 01:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE95B6B00AD; Sat,  5 Sep 2026 21:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFE36B00B2; Sat,  5 Sep 2026 21:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE336B00B8; Sat,  5 Sep 2026 21:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 745106B00AD
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 21:11:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC2ECC03ED
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:11:45 +0000 (UTC)
X-FDA: 85181560170.08.D3A78FE
Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	by imf16.hostedemail.com (Postfix) with ESMTP id C0B06180005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:11:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TIs/2n7U";
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.144 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788657104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFzQQFO3pa4ia108YylecqxyMbuCLlLnWSTgWHTgPLk=;
	b=Wm+2lkPmkjlWTKdr70pZb/BFXaDZHN8cvfj1vdjfi/NL2MoHdJYJch7hLZ//0EOu+7D4a7
	4O+nqiQFVr2nFFGZ2dQiK2lAeuaRQU0WQwLXcpsDVwhUS3W4W7yfaNgSasw/kXWsBOGNpe
	1jAwaSYMzhCBUhsW6iwm2Cm39lwC6gk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788657104;
	b=2MaqgfJ2MSgqw7U/+3MQp1AY446fsxFYytFwnggChnnIgqXLJPjjGKMa/xK3JOLC6ozT3N
	DrudWSyMDwtJ4TOwZ9SV8A6IAvRUons8OeRNmQ701xV1lwtBl7nEXiSeMSeFhF5R520uhq
	XTWFZvdPXR5TL38A5E8YSRiWH2gk0Hc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TIs/2n7U";
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.144 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zW7QNqiwYguh6Fh5GCujAnJ8mRwsK4X04rOZ+SnCXzU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788657102; v=1; x=1789261902;
 b=TIs/2n7UPrFFtv67oCWx/Km/lwRhljfKn3fPIRoN9oGPoYy/DjooFk1oMYppJxjBtW8V8SX2
 zfGxbVPfTtAQetOA+9sohO8ihXzBWoB5SLzHfyXRRpIiJ5ls64s9pv8CFxS3uDctIkPOqpH183S
 iwoKZWvHi/K/BhI5S23Q/+D8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d50bff216045863e;
	Sun, 06 Sep 2026 01:11:32 +0000
X-Mizu-Trace-ID: d50bff216045863e
X-Migadu-Flow: FLOW_OUT
Message-ID: <f65d4985-5e21-4e29-b5f4-dcff0fa479ab@linux.dev>
Date: Sun, 6 Sep 2026 09:11:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
To: David Laight <david.laight.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
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
 <20260904093743.23cde26b@pumpkin>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260904093743.23cde26b@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0B06180005
X-Stat-Signature: 6hh1rdwy17xqjpjrd7b5t6kgfpxz6jhd
X-HE-Tag: 1788657103-626128
X-HE-Meta: U2FsdGVkX18OID77kXkLg9WpvMMtyuqBYozvQzlJT3cH5TvU3vLn1w67Kw6d2h7OyYMqirys+wiL6wABebjMF1eCazgU4Qvaw+/Aa/aiIePG7m4rzHxGku3CNxKYilEYJUGIbsEbOyvxZPpHBQTp1wTBOf2nGdi1VlSh6OdA2e+SrgXnZxFEeFT3IW6caprH88n/aBDmNQUY/tYyhSZpREIPvn3rOOUclz+QLeEusUYUszG13A4clDFJxTXTZ+iuBdXcEkc0fcmgJ/IZH3U2ts/dNLcpxiHqkmOY2aL6RS6jj1fXzgyN9Sr64pNXGL1PFL4waa2JJKr9cc4AwrdF0sQ+ZKECGJiGNY/c6UKG+C7uNDxsSnJ3nfvwy6fTQSBsCxPGkVcIkXnKRlknRmNvD8597vfTrZt1p7MSzrrIXEvo9pA9Gc+0Ns4bmUqnuTR8ztX5k4dL34WyoRD19R+CaUS+qYS8Sg8al05VLXGo7JCMb5uGvnszUbKLjK1r+yb0v9ZjOMAwdaxnyXFmPOj3nmeFtbVVjrUP5L3nqkIM1uA2COdFZRTAO99ijPhskfprQ48Cu7Lgf4tsc/CjEfA/G9k3plIbPy+vP1ZShQUDBli5Aek8nRxvdtDifrWNhggPGs2+EjkcfF6va5kT4+OG1LWpG9o9Djyrf6xJITEjHnAIyB4ZkjWhK2J7xa4fYc+FVcGSlPK86vZlzYYZvWlv2+Kak3UFoH0T9ARSi+eQPI4Ur9RTHZhETRDOKibYsDvQBEPB/kdmY8Wa/EO/WwcBVMAcRqRxSZvbUvsfbNQ2QKYiDQJk6h8K1BINOgRZYIZAx+8I6a87gClQbWtVlLSTD4tFrrj8igApe7v/r3hHOPuhc8HQpyTqzqIL17nvaUFFV+7N8tynvVpKXsPdgyNHmDmKBLns8ZkkF0r64xEPj4ceVphyuLLflDJuZLuzPHBCQlrAtz2otfdO9VXZCYM
 8eUgDgx6
 3TWDhUZDQaV5W+J3MmkgYwTr2kUx9SGkHBxdTDRInIU5M92lgKSQC6uXofB6/fA0o2Bbwk+5XbSIoX1uhLMzMmfueEbpeVPa7mrwdAKTwNFPE1sZ6K9posDnFcK+FINaQSmZDa+O+WEzetY5JvnSyN7CbFsAofRfZRFFYO5U+qdSE18cWaEnp7w4i55r1Goqv7LM3HRM0pILm0WglTCM2c2r1NxbbJQEtcP/0vLtkCeFgBKiryPUzii6Gu1z1Gghyl4JEZskPk3Wlt/MOwJdPVABfUC84pWytKfCenVXU4SR3MTRppMg57QrrzdfsuArsqNys2jMoylgdPqj12yZmCfiL2umJ1CTM30+rHhkTByIPrP2aP/d/5S4bZh0qUwObJXm4WoGyCotaotkUIrpGp7u9/rHe3YWbp6cifSKoOpkmT87c89wxr3FMKDvOpxCMIA50Pdvi8am0WGhL/Sfsm66ox9/tEv55KeT855/bGLuZtaaju7LTh8jukJjIiBpqgoIh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/2026 4:37 PM, David Laight wrote:
> On Thu,  3 Sep 2026 11:19:51 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
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
> 
> On 32bit it is only necessary to use a 64bit intermediary.
> mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
> divide (and then maybe to a 64 by 32 one).
> But there is a lot of extra code before that happens.
> 

Hi David,

Thank you for your review.

Do you want me to split this for 32-bit, or is keeping the single
mul_u64_u64_div_u64() call for readability fine with you?

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
>>   
>> -		ep += unclaimed;
>> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);
> 
> If the ratio is forced to 1 there is no point doing the scaling.
> So maybe:
> 		if (likely(parent_unprotected > unprotected))
> 			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
> 							parent_unprotected);
> 		ep += unclaimed;
> OTOH if the min() generates a cmov rather than a conditional branch
> then you don't get a statically mispredicted branch in the normal case
> (which is very likely with the empty 'else' branch).
> 

I'd rather keep it as-is and avoid the extra branch. Does that work for you?

> 
>>   	}
>>   
>>   	return ep;
> 

-- 
Best regards
Ridong


