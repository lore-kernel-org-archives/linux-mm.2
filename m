Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD83F8E4B3
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 07:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1C96B00A4; Fri, 17 Apr 2026 03:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71E06B00A5; Fri, 17 Apr 2026 03:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87C86B00A6; Fri, 17 Apr 2026 03:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9682C6B00A4
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:21:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD96BC3660
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:21:41 +0000 (UTC)
X-FDA: 84667202802.23.DD2F3FB
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC8FF80007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:21:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gZpCuBNf;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776410500; a=rsa-sha256;
	cv=none;
	b=Zzdy+k/umUxqhgGd43FRXnU+BiIP8MV0StjHK5DqrnXuB/Ylx8O74LT1ZQZa352lw+5sBf
	PR8G4DyiIH8j4mb2l5Z9+/KwAOQkSBrRE6jSA2o6fYNYPFLmXCMKxmyOUdmikUaqrYGYmW
	oCyk/6fkvGFwi6lOsU75eoy6pgokRVY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gZpCuBNf;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776410500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93oxKOORlnBXcsnliXcH+HsS5Rt3NUtTsFQEOXV4lUw=;
	b=bNUQYKq6kg2Nw4A1iQD3PxevSMrVM+bA3XzWbv4Scd3ubediQzWjYHLkaMVD9nOqtRRbz0
	mJ28RlSk9ZgM8ODobw/XE+U5A43i8ePrj69YzoJKrHhha5nFal/kjk6PRNWM8cDZ8EcWrI
	CrW5hnP3kG23OolFzzkDzApbOd6NYgg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776410494; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=93oxKOORlnBXcsnliXcH+HsS5Rt3NUtTsFQEOXV4lUw=;
	b=gZpCuBNf1cnhjIyGxD0NUfHO9DP7y3nZHXg1cVqNVHA8rj8rpQj7RgfrHCtHhPURft8ioT3FO/2AsQFaUI1Y6wtqkWvmph5aqqr66evEZrzT9FaWUMbXsu/R9K4mDgfho9a9TbI3jSvbNQz83Jg5oAvTX59IyzNh9xlZEVRUdGo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X1AZ8vF_1776410492;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1AZ8vF_1776410492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 15:21:33 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sunny Patel <nueralspacetech@gmail.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
In-Reply-To: <d95ee512-73ca-4535-9fc6-a2c77eeb350e@kernel.org> (David
	Hildenbrand's message of "Thu, 16 Apr 2026 21:44:15 +0200")
References: <20260414141344.29949-1-nueralspacetech@gmail.com>
	<d95ee512-73ca-4535-9fc6-a2c77eeb350e@kernel.org>
Date: Fri, 17 Apr 2026 15:21:31 +0800
Message-ID: <87y0imhx1g.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: BC8FF80007
X-Stat-Signature: er8ub5gpxez3f5j87yhq4fncbsc3n11t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776410498-672956
X-HE-Meta: U2FsdGVkX1/FDHDoShc3thefMu5U60aHzi1zGUL2JzB6puUv6YEQZ9nlCMg/DSVLxykEZyocxAxCj8GmkMyh+Mpf5O1TACiSE3Aq5Y4O4H1u4Aju+bl9U4IDjjVaDgBO6E90yb13/OMKR/o19hIeCYxQEo3KjfiTvtjSs6ifEglpQawL55jIYl4PKCHan/zmcgD7snUEpMGigbb70pUYToA3k69iBaptF6uwZWiEz5DdCWTIbtL86hgK2aoJ8Dy6eF2c80No5Wu30IGBK4CB5zOQagY9gxLk1Epv/uKWVF1KwcitF8bGm+5b1QCWGwUoSIDi4uMpfsE2eWLW6U7RTsN5mYViiPomkZMwD7GbMGLg+TtRO+LyOPIsOCRde9kpBuikBGtcFeSd8Jc/MzMQ3UTztAnPKsue6/J+vGHoeXfPBqMF3NZeeNDCkv33cIkv4IHNiMwCEVW7yy9TSzpHfrb9mJuJJr+XrmjvSbE8VtzrMFzLE5Z+37/BYMWbv6viU/K2yqgjFX3VrRpQZs4pfIRGSoOYpfkfT6xOQjkZisj0bRU+n8Y4o4Oa++4YSWey3IEM8AXcC0kzDdYafjHNd+ee3JHsF02n2w15mgMsD3LP3MxkNRFLRcef9pyLG+rhf6zvNhgGgTjZnHAWxSTJHCLzGwplCxjYiW3H47PJ3932btkPu4HpC6PhX2CHKgAYbCapJR+ims/c8042YqhzLah/25lMJE9saL5GyGE0uR//c67AfLbc9t5MpGnQseDeKkU7D0/dWTm4nEBMjrKYc7/a7iJ/r+2N+D8Q3YwirAyzi5qQKXGEhmC0XO/r3mXye4gRP8PwBLxJVyyoTZj3yw2xCkR/Fc3fU4s1oOlSGcM3jzr4AvHMv7QoxPgQifZpLg9KU9DQTZTCPddinowUzF2shdPH2N/UsQ2kuexz0oN4708AGGTyVS8gbSCTHBv2XAi+PylT+3PCaEjFnVI
 xWIE6+ZA
 lqoTMQuz+i7Z+RTUm/oHVXVxiEhmIT1ulFU7z8MKHu4EbmQ2iMknYsrZn/lzL93aYK2M8KeuQJrfnyUUkdUlnEVkDHfaXSg4jpFbKFVevDa914P81/pLBIGi3JYSgEx51bHCdPlRza+44z6gMJjn0KrT1Yd9ydYqpkzWYfRPaRcJrPCMfKxzZvxDF972G5Jgq2zxOiY/AsZnwMZEUeDy7EahY30cJAcsg6ogtsq0McNbQWuAbYO1gYhlmodtqnDWTFJK0tdpCt2Voidn3fcElmW73UxeeNp9flHP4P8VT+zqb1nwjMcWrmSMsNkXprUwOhxxQbL5/+gzgDL4gsWO8VkCN9+BqjjdFiktxmhj8Ry6kB7bQBFwy/Va/PSrSNeUjAj1OfHhJCCFFuwryBMK8jvYa+Fp87x2VbANFRGzinB/dHhcifEGIHn2vFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 4/14/26 16:13, Sunny Patel wrote:
>> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
>> with a simpler VM_WARN_ON_ONCE(!folio) check.
>> 
>> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
>> !is_huge_zero_pmd(*pmdp)).
>> 
>> Refactor the PMD checks to use pmd_present(), making the control flow
>> clearer and avoiding duplicate condition checks.
>> 
>> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
>> ---
>>  mm/migrate_device.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 8079676c8f1f..fe1c1999aa2d 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -807,8 +807,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  	bool flush = false;
>>  	unsigned long i;
>>  
>> -	VM_WARN_ON_FOLIO(!folio, folio);
>> -	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
>> +	VM_WARN_ON_ONCE(!folio);
>
> I'd test for "page" here instead. But it doesn't matter as of today.
>
>>  
>>  	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
>>  		return -EINVAL;
>> @@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  	if (userfaultfd_missing(vma))
>>  		goto unlock_abort;
>>  
>> -	if (!pmd_none(*pmdp)) {
>> +	if (pmd_present(*pmdp)) {
>>  		if (!is_huge_zero_pmd(*pmdp))
>>  			goto unlock_abort;
>>  		flush = true;
>> -	} else if (!pmd_none(*pmdp))
>> +	} else if (!pmd_none(*pmdp)) {
>>  		goto unlock_abort;
>> +	}
>>  
>>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>  	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>
> is_huge_zero_pmd() checks pmd_present(), so we didn't have a bug before.
>
> We could also do:
>
> if (is_huge_zero_pmd(*pmdp)) {
> 	flush = true;
> } else if (!pmd_none(*pmdp)) {
> 	goto unlock_abort;
> }

I think that this is better.  And because the patch is for code cleanup,
why not do it better.

> But I don't particularly care
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

---
Best Regards,
Huang, Ying

