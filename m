Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C69ACA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 06:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816268E0073; Fri, 22 Aug 2025 02:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C70D8E0056; Fri, 22 Aug 2025 02:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E648E0073; Fri, 22 Aug 2025 02:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF838E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:59:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5B51138A3D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:59:40 +0000 (UTC)
X-FDA: 83803492920.03.F4099FF
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id B985D40008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:59:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="pfiimE/s";
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755845979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkM4XdDBFAdRbT5J+s3/gC6XHNJgFJP15TsoieCtwm0=;
	b=eWR8g+mCSVE+xF7p8yv9G8kVHoBulZ0Ib+ngQEdRN5xgQvB1S4TsynE6E8QTJAdZlCMm+E
	+kt6oo9+pXPD40EzgcUdVZHae3i3gCfFKWMYm600Bcb0P924z9QfJYdqNIgysj8hB+l77x
	/gz5uZHCaCK3uRgkh2klTDbPkztuldk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="pfiimE/s";
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755845979; a=rsa-sha256;
	cv=none;
	b=DA+g3vGw8ba8QE4wwnst3gg59MPH1NW2tiXraXXJfEJAoSddFCJxg3qj2N+7i4efHx/Yrp
	t3v0CKzxeGWI8vMa1YUqdTtgfiRnNkb3kUlXnICIH/mIZI2CV/qh9NP73aQsFr1IKZlOfK
	Vl/HjWcG8vyW78k99Og0VYnSlRpFfeA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755845972; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YkM4XdDBFAdRbT5J+s3/gC6XHNJgFJP15TsoieCtwm0=;
	b=pfiimE/sbJXXZYInYbU3Sf/EO98R9P8qAcMF/8UcgB+8AXTq2Tg/0EBBodgWh/nsqveczHn83y7iO6mUXa7YK1xJVVfrNM+I8k5JFE0CwHHKUNdYlTqHKRtsNXkkNV2jZqnwk5TU6AmvwPhhvfgYyfoOpJgkoz2wXbFCJUJSWGM=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmIuUdM_1755845969 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 22 Aug 2025 14:59:30 +0800
Message-ID: <0269b6d4-23ce-416f-8c44-907478c3d6dd@linux.alibaba.com>
Date: Fri, 22 Aug 2025 14:59:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/13] khugepaged: kick khugepaged for enabling
 none-PMD-sized mTHPs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 david@redhat.com, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-11-npache@redhat.com>
 <d9a02ed5-0d6e-41e6-985d-23f5a2de093d@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <d9a02ed5-0d6e-41e6-985d-23f5a2de093d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g8wm654r843eii4ofeps8zkhcyrxex3h
X-Rspam-User: 
X-Rspamd-Queue-Id: B985D40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755845977-16178
X-HE-Meta: U2FsdGVkX19GhV/oI82aH6UPQJLoWtKKBzMDvi64twjwSBf9TkwvelG9Mu2jGmgzj3zHNzs2EwWfXfzFOpxc24xr+PnyFwrvO7+JJS5PH7iVQprbd14Er1xVCA0RVB5qwjUYIZAuqJF4TuyGKt7jfx0QocecZ2olGpfL/uxPO7kZlZYtSBn6RnHASxdY79enzqb3qApew6Y5ZD10tFmMPCqwu//WOqqzGqPzvhQXqSS/p5p51bgIgXnwJDwKg4vyd425VIn8gClor//7Hair9M1TZrlP5GATiw/3CSchaPqRPcfUtAbcKSSOGgvNur2bG2I6tmxkasPohzxeW6f3YfzYWE460hAbwyuhfuOMLAtxAFfghrRWE9MJmZtWhlJ6MVbYKB2xMoAJwZQ0zYCOiTtpy4K3kSLLVMFtYTQ3jfXPbaIWQj2ehQu1mKNycMItP9ljAt32q4ZzZmnpH2dhdR/+VG53sO1QrquoZj0bV29gY/PM7g3xy8RpJqMW9tJMiPorXp/rumx4savF7ra2oqpy7UKREpOxkp3BeSbR26rXFVSV5A6HhOjU/AsxYXiOqoClQodgUOCddu2i3tkMPnSvV4I1tGyLkOtfBVifs7edpOk+s1Am1J0D5rTBuMNajDu5HdLcqhkZYO5LuD22NZZuU+UnLCr3yDwq9pN+svIJtFu1oNibMkbnEwAWeWJ8dtJF5nMsLPxWsfnFpy/irvPH0CCMR8bLu8pS1SmZmVJhadFODHRxFN4XA5WW/iLUqpq+iO5TdevJ3x/sPWs8StY92ZrGGwiIAAYYiaZzWGU3/jMd3UTs9wIOKfjsm1gxvIHBYTdeWzRPDOGWB0yLgVu93y6z5ViOmiUFe4DuIA2GqDLFigFfpIBUsdrt57FhjtpFkQJx8zc16lFHKCja8rqmbadU8RCIO2KO+ruGl5GfB+gpDmz/uioPRnMYoIYHn76Kxfd9hyxGtGUMlms
 V4L8S1ch
 P3EjUqYcxNblUJX/njcSTgY3Q5/fS+HaO+Qapf7GiV3lC+CJaCT5eO4shomAnpMNp8yed8LCbs62Tf6EUCZaF0iPqsiNhCEGH6XMyBc7dkSupFGpI90hKmTB/LlWY3Y+t9u10xUttPMgt8FbjrAVGNaKxq16CWy+efJORRQg5IOQZrAWmoNlD4gcIDEmWMZjURMmWEiG1zpn6CCC/MwMDi6BtFZ2keeUtLC138DPnAGBNm84Z6N88t7cI9gNYQTIFVgr5LCrJFNHmZBpe9wuu8BiDTh72ua4igt7F5Kq3OOoCcM7CowA/sdBJ+HFTGs8uT0ccDp1lVcd4mJC46kquZGiW7T7NBOwcJ8sqTf5n0go/+oAXND+j9jir6g7KQGhaZNnidbplG1mKRWc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/21 22:18, Lorenzo Stoakes wrote:
> On Tue, Aug 19, 2025 at 07:42:02AM -0600, Nico Pache wrote:
>> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>>
>> When only non-PMD-sized mTHP is enabled (such as only 64K mTHP enabled),
> 
> I don't think this example is very useful, probably just remove it.
> 
> Also 'non-PMD-sized mTHP' implies there is such a thing as PMD-sized mTP :)
> 
>> we should also allow kicking khugepaged to attempt scanning and collapsing
> 
> What is kicking? I think this should be rephrased to something like 'we should
> also allow khugepaged to attempt scanning...'
> 
>> 64K mTHP. Modify hugepage_pmd_enabled() to support mTHP collapse, and
> 
> 64K mTHP -> "of mTHP ranges". Put the 'Modify...' bit in a new paragraph to
> be clear.
> 
>> while we are at it, rename it to make the function name more clear.
> 
> To make this clearer let me suggest:
> 
> 	In order for khugepaged to operate when only mTHP sizes are
> 	specified in sysfs, we must modify the predicate function that
> 	determines whether it ought to run to do so.
> 
> 	This function is currently called hugepage_pmd_enabled(), this
> 	patch renames it to hugepage_enabled() and updates the logic to
> 	check to determine whether any valid orders may exist which would
> 	justify khugepaged running.

Thanks. This looks good to me.

>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
> 
>> ---
>>   mm/khugepaged.c | 20 ++++++++++----------
>>   1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 2cadd07341de..81d2ffd56ab9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -430,7 +430,7 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>   }
>>
>> -static bool hugepage_pmd_enabled(void)
>> +static bool hugepage_enabled(void)
>>   {
>>   	/*
>>   	 * We cover the anon, shmem and the file-backed case here; file-backed
>> @@ -442,11 +442,11 @@ static bool hugepage_pmd_enabled(void)
> 
> The comment above this still references PMD-sized, please make sure to update
> comments when you change the described behaviour, as it is now incorrect:
> 
> 	/*
> 	 * We cover the anon, shmem and the file-backed case here; file-backed
> 	 * hugepages, when configured in, are determined by the global control.
> 	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> 	 */
> 
> Please correct this.

Sure. How about:

/*
  * We cover the anon, shmem and the file-backed case here; file-backed
  * hugepages, when configured in, are determined by the global control.
  * Anon hugepages are determined by its per-size mTHP control.
  * Shmem pmd-sized hugepages are also determined by its pmd-size control,
  * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
  */

>>   	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>   	    hugepage_global_enabled())
>>   		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>> +	if (READ_ONCE(huge_anon_orders_always))
>>   		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> +	if (READ_ONCE(huge_anon_orders_madvise))
>>   		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>>   	    hugepage_global_enabled())
> 
> I guess READ_ONCE() is probably sufficient here as memory ordering isn't
> important here, right?

Yes, I think so.

