Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569ABCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBF36B0005; Wed, 13 May 2026 02:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76066B008A; Wed, 13 May 2026 02:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9647E6B008C; Wed, 13 May 2026 02:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85D836B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:51:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A6A8A074A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:51:15 +0000 (UTC)
X-FDA: 84761474910.24.5AE38EA
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 366974000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:51:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NikSNfLX;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778655073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljaFWWwsq2EiNVrMSOLQz4qax9kr/k7rePcEqZBtHwE=;
	b=mHoWXr7vIzFOR/QOk/9oE9RwZcpLdwyyY6+7bQGnyjbxpGhdRi1ykveKSUABXEGGwNEFFe
	+01HdVG05jfGq+6gj+0nk1/qU+xaxclTOdKcAA6lbqTjJcCYc3+xd1E8V6dSr8zMSCdC/t
	9aIY9NzmUQqXrEHKWxaeOdA1TzS73KQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NikSNfLX;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778655073; a=rsa-sha256;
	cv=none;
	b=puLJSYghvVQDpif/IJgx/yA2/O7NlzVp8uVvqhaivIM0gtWezuIqAEbW3NdRZBoz90BmPR
	rV4tMx4uH9MTZegKliDM/S7GIFiRcaPxyoBaN8boHw2uYDM/X/kiIfqXhsGjUBVavJ4hr2
	D6d9omOLExO4YDt98znVKI4KSsR1UdU=
Message-ID: <fe1f36ac-84f1-4557-9411-41497737224d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778655070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ljaFWWwsq2EiNVrMSOLQz4qax9kr/k7rePcEqZBtHwE=;
	b=NikSNfLXZbTPU9WgKh/NocBWEiUXLWGUl/CB2u/Vp65cRn25HiKUBv31q/MJ8nw90Nujo2
	5EeBANeuVldlIOGLLmQZkLSwaeQHO4PzPBYZ3wpJPjxp71L6PRftoUIpoHY0JPtcYfBMwp
	Z6/az2eq4+PVLvS0MA2eGxT4zBklIOU=
Date: Wed, 13 May 2026 14:50:56 +0800
MIME-Version: 1.0
Subject: Re: [RESEND PATCH] mm/memory_failure: use bool for hugetlb indicator
 in try_memory_failure_hugetlb
To: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260513024853.65566-1-ye.liu@linux.dev>
 <agPx2woN458Co5Us@localhost.localdomain>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <agPx2woN458Co5Us@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gmkpk7a5fgf6t68jouccsu9wem86ocii
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 366974000A
X-Rspam-User: 
X-HE-Tag: 1778655072-15309
X-HE-Meta: U2FsdGVkX193cPn2YioPoUXNT+mqj8vE2Zta6PfCiGyLITKJw3/1f/MsrsEKErCpUfYOcObXvr4LgTDkDJ61SnT7HKvvBW+MiTOalQEg+Uju5F/yxtZgo00yKA2uyF6PsVzR4LQApPdwreIuqAXiFd4Tsy0D+3QKOrzU5h9c/+7KzM6A5DF9uiUpv7moY6RrpEVSKD0WS6dvE2D68W54xIkoJHFJTg5GOIEljXAnHkPB1795ySXtXqQw9hs6AbsKq1ala8MOIH+KNBTqm5/KLzN/HZBAbWDTE4In4a8D9iTu6yxmUXOC8vyuflvi4QQT5OGtCH4GNUno1Yp/PrFE3e/TEufS1Qbc4dBL0IXXBRQV7YVXEPsby+GOSscWA1/hae/Z9Rz33JPomjRl/Q+Ush3SWz3X/sA+4wQ7c06+5qdMbCwDjK699IRtEJJu3F9dW7JRj33oSlvepx8g8FRPjMgH7sHuv0jmRCMDlLi5s3BxnapigqB0WsnaOOR5Sne6yaEGM0E07gan34nC0PEf/HJfNGjZiKmiQyh90/O7stvF1B0uifzCttfOTw0zUpI9f56+DNMF5TW6Sgh/aFIrkLu+SxfU3RWTmV5WSzdaXHOJNpwV3IxCZF2okePSoc2B7JIzk6YjsXhoej7qz7AQxuOFujHiFnFqc276jnhFVBK7KSXL1pXOK72cX+k1VVWBj970lqt4rLvFRtE/vzHeL6LBVvdCu8SX9T1nRac+JFV+g0dMVJrxJwZkPDVZzeLllIP55IXyZ83E0txJ7xCWGInSQv1/7CkxNSErU4NII7E/jIYgOsdijfftw1jOYadYlIjBfbeSGdv7EySteAzRseTjMCkRKLeTSjnXpsHZ2VnPtyFlSHtXz+U6ZsHwgfohPgOrrsqM9zdaOhmjnLcPf3EGOF8YyB60KnYPWJkRefqjxhxAQomf+N/Ogn9hnM4oM6dHh5vQEEiIAsQZydS
 W5aWf/QV
 Ib6/988UhtwsYCnV66Z5TBUDCu21R5iJOQBpvSFrBp7GKvoUG2xsEO5Sp3/SBzAf7RHQk3E3ObBJvtYLvPKVt3muBKfB3sIog9oUYUknk/n/gco45EWJzxZ/vtcK13CncsYEWotHx48DHeTGnS48pQl7Wfx1KLK+e3lHg9tsuNctmPTmMNbuLHvaY9zwIaPYQ5McE+DkR1kR83Fx3TNb1eu5TFqIQ4MyCwWCes44gc9nBSCgnjLX+aO0ch5hlY3IYQvK9GJZpN5uxcUrBVpA7oIBQsfE5nqGrKcPUoYO1HScS3yfrte1aOLIekcEcpw5iN++P5kBeCcTKTS0CORV8yqz+TcfYpwvP0PZrVvx8Xbl8lKBRy9cvbYkzKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/13 11:36, Oscar Salvador 写道:
> On Wed, May 13, 2026 at 10:48:52AM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The hugetlb indicator in try_memory_failure_hugetlb is a Boolean
>> flag, but was declared and assigned as int/0/1. Convert to `bool`
>> and `true`/`false` for clarity and type safety.
>>
>> - try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
>> - testcase path in memory_failure(): bool hugetlb = false
>> - clear semantic conversion in MF_HUGETLB_NON_HUGEPAGE
>> - preserve behavior (no functional change)
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  mm/memory-failure.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 866c4428ac7e..f164fc5959f0 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2032,7 +2032,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>   *	-EHWPOISON	- folio or exact page already poisoned
>>   *	-EFAULT		- kill_accessing_process finds current->mm null
>>   */
>> -static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
>> +static int try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
>>  {
>>  	int res, rv;
>>  	struct page *p = pfn_to_page(pfn);
>> @@ -2040,12 +2040,12 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>>  	unsigned long page_flags;
>>  	bool migratable_cleared = false;
>>  
>> -	*hugetlb = 1;
>> +	*hugetlb = true;
>>  retry:
>>  	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
>>  	switch (res) {
>>  	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
>> -		*hugetlb = 0;
>> +		*hugetlb = false;
> 
> Do we really need this boolean though?
> Why do not simply return ENOENT when we find a non-hugetlb page, and then the caller
> knows that if we get ENOENT, it can proceed with normal page handling?
> 
> I might be missing something, but is not the following more cleaer?
> 
>  diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>  index ee42d4361309..44f388df5731 100644
>  --- a/mm/memory-failure.c
>  +++ b/mm/memory-failure.c
>  @@ -2026,13 +2026,14 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>    * So some of prechecks for hwpoison (pinning, and testing/setting
>    * PageHWPoison) should be done in single hugetlb_lock range.
>    * Returns:
>  - *     0               - not hugetlb, or recovered
>  + *     0               - recovered
>  + *     -ENOENT         - no hugetlb page
>    *     -EBUSY          - not recovered
>    *     -EOPNOTSUPP     - hwpoison_filter'ed
>    *     -EHWPOISON      - folio or exact page already poisoned
>    *     -EFAULT         - kill_accessing_process finds current->mm null
>    */
>  -static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
>  +static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>   {
>          int res, rv;
>          struct page *p = pfn_to_page(pfn);
>  @@ -2040,13 +2041,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>          unsigned long page_flags;
>          bool migratable_cleared = false;
>  
>  -       *hugetlb = 1;
>   retry:
>          res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
>          switch (res) {
>          case MF_HUGETLB_NON_HUGEPAGE:   /* fallback to normal page handling */
>  -               *hugetlb = 0;
>  -               return 0;
>  +               return -ENOENT;
>          case MF_HUGETLB_RETRY:
>                  if (!(flags & MF_NO_RETRY)) {
>                          flags |= MF_NO_RETRY;
>  @@ -2107,7 +2106,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>   }
>  
>   #else
>  -static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
>  +static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>   {
>          return 0;
>   }
>  @@ -2386,8 +2385,11 @@ int memory_failure(unsigned long pfn, int flags)
>          }
>  
>   try_again:
>  -       res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
>  -       if (hugetlb)
>  +       res = try_memory_failure_hugetlb(pfn, flags);
>  +       /*
>  +        * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
>  +        */
>  +       if (res != -ENOENT)
>                  goto unlock_mutex;
>  
>          if (TestSetPageHWPoison(p)) {
> 
> 


Hi Oscar,

Good point.  Using -ENOENT to distinguish "not a hugetlb page" from
"hugetlb handled" is indeed cleaner than carrying an extra output
parameter.

One thing to note: the #else stub when CONFIG_HUGETLB_PAGE is not set
currently does:

    return 0;

which with your change would mean "hugetlb handled, skip normal path"
instead of the intended "not hugetlb, proceed with normal handling".
It should be changed to:

    return -ENOENT;

Otherwise the non-hugetlb config would silently skip all normal page
failure processing.

-- 
Thanks,
Ye Liu


