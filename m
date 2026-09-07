Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6E1C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0798E6B009B; Sun,  6 Sep 2026 22:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A426B009D; Sun,  6 Sep 2026 22:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D346B009E; Sun,  6 Sep 2026 22:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA9286B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:08:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 440AC160662
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:08:42 +0000 (UTC)
X-FDA: 85185332484.25.CB72ECD
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9FA8020008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:08:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q9kMccRM;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788746920;
	b=8ETVh02tI4WpyAUqk+1X5+uTQCsC9Bojb4QItPcusPhesEoNqs6p6+bISiTOXLmah5+XFF
	ZCAt+ZWKRw2BiFORygXL3McnfQsm8XohD6IRUAHv/olkZn8XH/ynOFhnNNvJbVn5vu8He+
	pwPR+1H9hNUowCJoDSRdk5MlBfX1+EY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q9kMccRM;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788746920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBRUIgwFXZL3adHdfnRer/mGh0NU0opxKVak5T1GH+c=;
	b=JsDNVDDQeXX1gbPWDp0Vi+TVwOEd5R+nBsGTy41DhGGSGzUBET820KvA2ZOexJrswlNRym
	PkXFY6yrOOzCRLzwUpiUAlMesvnDM/Tt9YWSQIDQE25kWPmEzmocrvUyVdy/eHVKoEXAve
	pXZYdYpX9xuZgv4cVH1BCnyaTIS7WrA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LzaE8JGTRIG+1dFbwA1G5yAmK7QHt16tXyvwzCJNb+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788746915; v=1; x=1789351715;
 b=Q9kMccRMT3uafmyFewup31luuM6O10A1KE/oDyetb1ndPJ2hYkFQK42/jV12GtglNUpZt6r3
 CNs8k4vdBFB+KZwvHULoCNNoWg3KfdZ/DOa2l+Ojqz03fHeX3vvCOPS/0nNY/TVoSUwX0f5OXQK
 CMcOhvrDBDycS8Gm5UEnG2bs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 385f2f7eacdaa4a4;
	Mon, 07 Sep 2026 02:08:28 +0000
X-Mizu-Trace-ID: 385f2f7eacdaa4a4
X-Migadu-Flow: FLOW_OUT
Message-ID: <e081c02a-a663-484b-8ce6-1d7624a4188e@linux.dev>
Date: Mon, 7 Sep 2026 10:08:18 +0800
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
 <f65d4985-5e21-4e29-b5f4-dcff0fa479ab@linux.dev>
 <20260906111618.644362b3@pumpkin>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260906111618.644362b3@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FA8020008
X-Stat-Signature: w3jnnzti16tdean36bcww7ehfz37s5oh
X-HE-Tag: 1788746918-515533
X-HE-Meta: U2FsdGVkX1/6Hm4inSbtUucBQ0d8jMTgszEkiLk/yjH5MNJeXCj/HQaF8QA7rxj8BKRPwzW5W7KKhs+u75YrCrI3lMg/27QBMHlbUVfJ0ik7HkLYjv01Z4Q4FTld7XoBUm9RT/KN/ZX0a7Q3IZe+zuNYxBBmqLdGywYZgAfcrMEySh2U8TZ0u4GZjfpVsrJ4+zXvpHKf63ebK6CySEYRldU5W7Ap537C2KfEc7FB3diIhXQhV5Yu6051aMVb7emcjHg6iCGBOM3vbydCVtmvfKYUPGW9HUnyu8EyCOcsK3sxpZmCymL8cL62XW02PfyT7s735wPoDFoYM6h+zRLGBQxsHFE0MyHEOHFzXXUWe1R9K9WcqFZANKmdbxH7LCfb+VvizLpgoUYhdlANnS/nMvOvYpj2JdC/Mf9ZTifoePDa6yd8RNbhdssLSgU8Cadbp2KGorZukTbHgox2KmIEr8+9i3+F5GgREK2pLnKI4FmHZ+DbjFYur1JqPAqTHtuQPqOQM3rqJqfK3JXJjrL/Z2Tid6B+oZfC9QsvNB7BKltkKJDx00o1UfNuMPVF4mutUbYMkTdVQTadXaDquzd5LrTDODlv/viVHfhrLTGA11GJoVt8lsavx2nJv4o0JabKlveTe0jqPsUaacMC8lQXb4skrPpdpTWUgOWfwKTsaUFx5ZPvh0rNBsIjpVMm0ye9GHwVONH9+Mput5Yixwa06yddGmHHE9ZbUoNv8uvg8uibejxEHRfyzTSMEfvC2NUwDorfAdPGOp3TvgvHwj6/2w7ZqliqlA4/Z8pkF61TDa4pZB8MyORPjNQiNddIDTwx/9+2bRWpyh/TPTjjf9pUKo7TRvwXxWRHrKUun//o434q8Tlc0kT5rff51GgnDtoCebbvyvHCycNOkcEMWN5grOCdhxINYp8yXnzOvAculS2qsGwyhJ6XrGQBmSb0QGxypbPV7RiTEVP1SEvRKy0
 hbdD3P1G
 Fy9myUqKPA6M8ywldq9CEF4NjTnrUFIlE6AMbykxQKyvJIlH3n7vWSjGgQpsfE1I7JOh0Ot8MMjQyW8kxQ7ZOx3zpA80ZN1H9HWox+yKGQk7TLrK53Gj/LlObq++eWr2+Ctqoc7FIBJZ/JzcuzWajhXrT45UxHe+TocHJtdDob1E7EOqKGyUwnHpybeTTGbtom8jqxZFJmhcmb7fNZbfgaPEETM8k22vhiUERwSeUveMyWKKRXV0RKX46Sg+k40ES/HBCJO4AFByq7nmY1tC/K340xXgx/Rgn2UnoVCwUmJFtgif4EAJit073MFIT4Ir4VSCxX7e4w9Lngm8hOpEhi7XHGnxuUaDdxhRFxXeHHko+xceK+IMszLq48QX/WkZX3E4SKha5DsSfFhN3uODXnv4yriipLwBDo5pohs0KzEG6g1i/ooEnEqkjrGEHNfDP9oLGF7MvEjUpNQ1qJqJJmCwSRnZuN0csU9TKSbkelTp7yeJCDbkSCEs9ChEiUoQu/fxSdPrBuPpDpSDcPRJ+VY5U4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/6/2026 6:16 PM, David Laight wrote:
> On Sun, 6 Sep 2026 09:11:24 +0800
> Ridong Chen<ridong.chen@linux.dev> wrote:
> 
>> On 9/4/2026 4:37 PM, David Laight wrote:
>>> On Thu,  3 Sep 2026 11:19:51 +0800
>>> Ridong Chen<ridong.chen@linux.dev> wrote:
>>>    
>>>> From: Ridong Chen<chenridong@xiaomi.com>
>>>>
>>>> effective_protection() scales a parent's protection by a ratio of page
>>>> counts, e.g. for recursive protection:
>>>>
>>>> 	(parent_effective - siblings_protected) * (usage - protected)
>>>> 		/ (parent_usage - siblings_protected)
>>>>
>>>> The multiply is done at unsigned long width before dividing. On systems
>>>> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
>>>> protection value and silently breaking memory.min/low enforcement.
>>>>
>>>> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
>>>> usage and parent_usage are not read atomically (a child is charged
>>>> before its parent), usage - protected can briefly exceed the divisor,
>>>> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
>>>> the ratio stays <= 1.
>>>>
>>>> Reported by the sashiko review tool [1].
>>>>
>>>> [1]https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev? 
>>>> part=1
>>>>
>>>> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
>>>> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
>>>> Cc:stable@vger.kernel.org
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Reviewed-by: Barry Song<baohua@kernel.org>
>>>> Signed-off-by: Ridong Chen<chenridong@xiaomi.com>
>>>> ---
>>>>    mm/page_counter.c | 19 +++++++++++++------
>>>>    1 file changed, 13 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/page_counter.c b/mm/page_counter.c
>>>> index 661e0f2a5127..e8bd512069c5 100644
>>>> --- a/mm/page_counter.c
>>>> +++ b/mm/page_counter.c
>>>> @@ -8,6 +8,7 @@
>>>>    #include <linux/page_counter.h>
>>>>    #include <linux/atomic.h>
>>>>    #include <linux/kernel.h>
>>>> +#include <linux/math64.h>
>>>>    #include <linux/string.h>
>>>>    #include <linux/sched.h>
>>>>    #include <linux/bug.h>
>>>> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
>>>>    	 * otherwise get a smaller chunk than what they claimed.
>>>>    	 */
>>>>    	if (siblings_protected > parent_effective)
>>>> -		return protected * parent_effective / siblings_protected;
>>>> +		return mul_u64_u64_div_u64(protected, parent_effective,
>>>> +					   siblings_protected);
>>> On 32bit it is only necessary to use a 64bit intermediary.
>>> mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
>>> divide (and then maybe to a 64 by 32 one).
>>> But there is a lot of extra code before that happens.
>>>    
>> Hi David,
>>
>> Thank you for your review.
>>
>> Do you want me to split this for 32-bit, or is keeping the single
>> mul_u64_u64_div_u64() call for readability fine with you?
> Maybe I'll look at wrapping mul_u64_add_u64_div_u64() with something that
> checks statically_true(((a) | (b) | (c) | (d)) < 1ull << 32).
> 
> Probably neater than the conditional here.
> 

Agreed. Other callers face the same 32-bit concern, so a wrapper that does the 
statically_true(...) check once would be cleaner than open-coding a conditional 
in each site.

>>>>    
>>>>    	/*
>>>>    	 * Ok, utilized protection of all children is within what the
>>>> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
>>>>    	if (parent_effective > siblings_protected &&
>>>>    	    parent_usage > siblings_protected &&
>>>>    	    usage > protected) {
>>>> -		unsigned long unclaimed;
>>>> +		unsigned long unclaimed = parent_effective - siblings_protected;
>>>> +		unsigned long unprotected = usage - protected;
>>>> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
>>>>    
>>>> -		unclaimed = parent_effective - siblings_protected;
>>>> -		unclaimed *= usage - protected;
>>>> -		unclaimed /= parent_usage - siblings_protected;
>>>> +		/*
>>>> +		 * The usages aren't read atomically, so a child can transiently
>>>> +		 * appear to use more than its parent, making the ratio exceed 1
>>>> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
>>>> +		 */
>>>> +		unprotected = min(unprotected, parent_unprotected);
>>>>    
>>>> -		ep += unclaimed;
>>>> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);
>>> If the ratio is forced to 1 there is no point doing the scaling.
>>> So maybe:
>>> 		if (likely(parent_unprotected > unprotected))
>>> 			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
>>> 							parent_unprotected);
>>> 		ep += unclaimed;
>>> OTOH if the min() generates a cmov rather than a conditional branch
>>> then you don't get a statically mispredicted branch in the normal case
>>> (which is very likely with the empty 'else' branch).
>>>    
>> I'd rather keep it as-is and avoid the extra branch. Does that work for you?
> I nearly came to that conclusion while writing the comment!
> Actually the same might go for the other three tests - generating a 0 or 1
> from a conditional move ought to be better than the possibly mispredicted
> very unlikely branch.
> (I am right in thinking that they should never fail?)
> 

No — these three checks fail all the time in normal operation, so I'd
keep the branch:

if (parent_effective > siblings_protected &&
	parent_usage > siblings_protected &&
	usage > protected) {

Checks 1 and 3 just ask "is there anything left to distribute?". Often
there isn't, so they fail routinely.

Check 2 is a divide-by-zero guard. parent_usage - siblings_protected is
the divisor. A conditional-move can't replace it: the division would run
anyway and only get multiplied by zero afterwards, so we'd still divide
by zero when the two are equal. The branch is what stops us reaching the
division.

> I also suspect the #UD is the least of the problems.
> You don't want the scaling to produce a bigger number at all.
> 

Agreed, and the min() already ensures that. It caps the value so the
result can never be larger than unclaimed. Avoiding the trap is just a
bonus of that same cap.

So I'll keep the patch as-is. Thanks for the review!

-- 
Best regards
Ridong


