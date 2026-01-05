Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18FBC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E6D6B00C2; Sun,  4 Jan 2026 21:10:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1EA46B00C3; Sun,  4 Jan 2026 21:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B816B00C4; Sun,  4 Jan 2026 21:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D46356B00C2
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:10:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92C37161D15
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:10:00 +0000 (UTC)
X-FDA: 84296279760.19.A0CBD17
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F6A040002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:09:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hc1DzIWl;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767578999; a=rsa-sha256;
	cv=none;
	b=Xk++R9KX8n4SeurIUsT37kTHn33yEtDGrLtzOM/ipiQOwZgmJDpDLIaHrzcWUZ4LKIsYoD
	ff60M/GNUpcw2pzlBt9AeG/dzp2U7rpawjHCohVpwFAfmB8HtOGkBAJ8EagOUWjG+7GpeM
	stgChP463BvkURS6fcUVMrUA8WOfnZI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hc1DzIWl;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767578998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNRGv23p5K6B6+hbFqyk7acP1QElSBybPClHvzoXsN4=;
	b=PvpUoxPaznNL9JEwd0NyU7gb9bU9rFl/AB5vnAV33qY0p+fPHpPa3BbVcJgNnXsqJiYREc
	ynhmQijv/A23e0HIcvTipcYHZmfye8XdTIQD56a1zjXIc1kFf3iMKuMyQiHI3D2S3/xryf
	s7axvZRwqgFWjxprRM4kxAT7O6qorV4=
Message-ID: <b85dad10-3a4a-4986-80ba-f2ac055bcea1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767578996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNRGv23p5K6B6+hbFqyk7acP1QElSBybPClHvzoXsN4=;
	b=hc1DzIWlNRpdtkcj5GBA2EPwYztubu8pdn+LfsS+7LACW29MMqI+9MgKLvh0mHdjDEQ1X1
	Tmkvd35wV+0LIit+Kx56sEI6nr5pQYF7f9VhZSYDAAgVZgI+2p5ESO5F7gj/u4BapZYXY/
	IxRBmmxu2jN8SqALKVsvEaDFwIUmb68=
Date: Mon, 5 Jan 2026 10:09:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 6/6] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Vernon Yang <vernon2gm@gmail.com>, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-7-yanglincheng@kylinos.cn>
 <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
 <20260105003128.7xitfioeno56h7f3@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260105003128.7xitfioeno56h7f3@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F6A040002
X-Rspamd-Server: rspam04
X-Stat-Signature: grjmxk96hwjzsku3e6f81m95xjoxdky4
X-HE-Tag: 1767578998-542440
X-HE-Meta: U2FsdGVkX192VP6WQWBGKcrnVbdvLma/aGLqQvPXIp6UnqLluk3Nx9xEED5VpRLScNCQ5nDKnJ0eeWNWZhQXhRcykhmqzISltXrZV+YKplmnmVu/c2EZxJtr+PwwsPSoJQi1Iot99QZoxfkpulyFpKqkgCPPxQlWGXwqXmmbJj6SOUtcwtYQ6I5QfzGOBExBUGnDZgoK2V4G0PFv+dmL4OnUgMpcwtfaFm9YTdjqN1ymYc2aoe1GNz8CESbOMzNjNpiFIRG4UazMtVGBWtZaDfTvmmt6EjmoCDyd11iUEh8Xh+rYSMECN2bqRWnByZU1ZUyzU3HclruTLe/lBwMPEcn/Tklbtp1nSDX/cD3rLoETx+rzDMrotTWrArAQLvbOPB7K9ZpvJN+R6DovwR4s52jMtU+6XdjtfYLIZQ8yScghZ8Y6/v6meaN9VNSUB9MoKU6q2lI1x2VBJfV1oGNheo9DL2kOANDptsovwVNqWAecFGdxjKt/BhsPIhAQGrzgycWe02Wb8upYZjef5WtxauhaGMGuSctmGS1nKWxE3fTxvBdiTGjDOJbnPtxlJNKKx/+fef3+ckn1QkhVMY+VjhQZSAnSfMyvyJfVJiv22m7m6GGdo9mq9BMhxkuW4FucwBYBz73DybJXW5WLvdye0ea7DZEiG7b0DeAl/z/Pz6++YiJ5mF67IpX1tAj1OW8F0f0j7YPIn2y+msdeg3mYHtXrwWf0PLC5Ni6uTeMjT7PVASLCpAFHX1aDg4f3FbJBdyxlhlgc5ZZNmCf0P+ZoYklsdOKCj+OCfhbKPgMJBBdKIShYW5L33rJ6nuWLetRWJKfY7VBBfB4vfKT3+ZepqG8f9mT8VwJWcc4CCFbNrj04hW2XZjweRrqgfc3eTwwCj3Yi/UFnMRi+hwz7beBvifkaam7crKrIPSWaBYaBwp7vSluiRsRt61uo6kJp36Two+vWyNLIZwvSf+ZBtvE
 ZRkVAoSo
 ydmPIitIJ+Bc+w+VqRcBhLviTrKdOjPbGdJxqIbMS8EWBzBE30J7YrRe6BouzuYA1myNgXMSghYVBOvCwUNhyv8UCikUGNDK3MZD66GkXk6hoXBqUgf0r2LAplQjqwxfyxqfL9XqQ8aeWabW6SVtqpSghGGNpdyXzYIJ2ySEkah72eJNXW8HiU8MDgODa5SBfdzgTdouMU69zzvlVA956vbb11n+LOU6lNk8gLFsZXOvYFt4MQ7wX8xnqC7m7ZAEJvFGMk448rrr7qNFtYE9zNUTt0xWVjkrH7LiH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/5 08:31, Wei Yang wrote:
> On Sun, Jan 04, 2026 at 08:20:29PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/1/4 13:41, Vernon Yang wrote:
>>> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
>>> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
>>> reduce redundant operation.
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>    mm/khugepaged.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 1ca034a5f653..d4ed0f397335 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2541,7 +2541,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>    	 * Release the current mm_slot if this mm is about to die, or
>>>    	 * if we scanned all vmas of this mm.
>>>    	 */
>>> -	if (hpage_collapse_test_exit(mm) || !vma) {
>>> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>>>    		/*
>>>    		 * Make sure that if mm_users is reaching zero while
>>>    		 * khugepaged runs here, khugepaged_exit will find
>>
>>
>> Let's convert hpage_collapse_test_exit() in collect_mm_slot() as well,
>> otherwise the mm_slot would not be freed and will be scanned again ...
>>
>> static void collect_mm_slot(struct mm_slot *slot)
>> {
>> 	struct mm_struct *mm = slot->mm;
>>
>> 	lockdep_assert_held(&khugepaged_mm_lock);
>>
>> 	if (hpage_collapse_test_exit(mm)) { <-
>>
> 
> What if user toggle the MMF_DISABLE_THP_COMPLETELY flag again?

Maybe it's fine :)

If user sets MMF_DISABLE_THP_COMPLETELY, they probaly would not
clear it soon. Keeping the slot wastes memory.

If they do clear it later, page faults will trigger
do_huge_pmd_anonymous_page() -> khugepaged_enter_vma(), which
re-adds the mm.

Anyway, no strong opinion on that.

> 
>> 		hash_del(&slot->hash);
>> 		list_del(&slot->mm_node);
>>
>> 		mm_slot_free(mm_slot_cache, slot);
>> 		mmdrop(mm);
>> 	}
>> }
> 


