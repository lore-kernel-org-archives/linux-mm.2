Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1249CA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554A79001FD; Thu, 14 Aug 2025 21:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE8C9001D5; Thu, 14 Aug 2025 21:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E129001FD; Thu, 14 Aug 2025 21:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 232AB9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:38:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 998EA5B7C5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:38:30 +0000 (UTC)
X-FDA: 83777281980.27.71F20D2
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D53D1C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:38:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rv7j8MQ3;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755221908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvIK9iJ7V8SHnncWDIUPYMTGNncr21um3VSz5HwThLw=;
	b=ffQh9YpPx70xuzgl2qvliXkk7w/lj2JVgeasNWZ0jrp0ySw+Fl7aKKKGplfLmi4/EPUgYV
	ZE0LG0bKKmo33d8eML68N5DVEV1dATTHajDmiCI/V0XA/b0jaQF2rkajZ0u0v/EfC/mI6c
	xTQ6hzjnz52FvDBsCe+NizpSnQnOXOg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rv7j8MQ3;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755221908; a=rsa-sha256;
	cv=none;
	b=tkm4HzheF7JevMgOXkXBIUDXdQQXl9k+juwonRHdsz7amfOMcFC3+VeCtHhluuYYP1btyE
	6VxA/reRlm1CrRmS0PuNpDnwyy2IRPc//JtdBwW/foKbAVa1vCgOcqSRSzbBmUZSyMZiDl
	dEVMp/GYxwxqyJQXnwBLyHqpO5qavGE=
Message-ID: <0032c975-1e37-484f-9b7b-a3f0fea0401a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755221905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FvIK9iJ7V8SHnncWDIUPYMTGNncr21um3VSz5HwThLw=;
	b=Rv7j8MQ3/UNGwwdvhntFdBWKEAHI300ZJy5nVbhPaQxP2lu1/Xv6QTPG/vsbkanIXvGX0v
	Gch2UTO+opI2CgstTS5Yq8HjzJWUE64pYMaswUN/0i1GK+1eJ5QD9hbCdcCiY1GLb9bJqV
	ZXEStufgTaSGJR+4CsA+mCz6bpgR/ME=
Date: Fri, 15 Aug 2025 09:38:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: simplify lowmem_reserve max calculation
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250814090053.22241-1-ye.liu@linux.dev>
 <EF575A1E-6AE2-45D7-9AC0-49C462A0CE5C@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <EF575A1E-6AE2-45D7-9AC0-49C462A0CE5C@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D53D1C0007
X-Stat-Signature: m77si3quwrn3wkokoiqhnyudgsbqffix
X-Rspam-User: 
X-HE-Tag: 1755221906-71885
X-HE-Meta: U2FsdGVkX189bRJ5kpPTy3AtviV7GwEYpaAFAGeKM55H31bge5dlTVpcWhpHHXFfZj0lEVbJw83qz/IWBPsjlTn1BYPNVRlMMp0awiEs/r5LemWkFz/jokO+JFZN8ldrSabOZAciXeFRNbQ9ZMUw/w279AyniEghPvm8npqWdQQRTwt+w+VNod2I88rsNWEipNU3ihoVx8Hn53jj/QLtGhP3z3QeQdQOYjAyhu9arYLRnhHvP5yLoA+VSoSgEmrt9PrZF6YwRh9QHQIKKml//F/rvc2bLR3FlvOjPPqphWcw710pdPXP0yNgwxkch5FdyCD00bb6SGBNm13/R54aKCJuaodzjAy3Us6J5T/FA0jSVzN52dOQEk8Dvnx8roCf2qNg0nifWxFu7u10HtE4TMI+YFrQ0zxF23NUtkssIobwvLfXsSBozN4vuuxfWblbC9H1diYzQzxSMKVqt54QuIKJMRDIklucxE39u+JBpZo+jqMsBS6qpfNUvygAYhJOsoJpw15oPuSsYVQjH9X8PQiCYqD2djB1TY8nPi/TflksOCiaU8tqoqNvxfN4bQTlB8JnSKxLBMAU5UUQexJnq7P4FaWF0mqPsQB7ArjZHi/pF9fX9Ee7h0XRqwC79HDtVaUEbFPWonvC6MrwGo6f3utoIfyEWevRfwrV/Ks9cjHHrDomk8SY+JtqOf/YbrhW6zZlucRUj6ZHoYZc9XUd81pQRDiteciIyPyozdiRycFGXxS3lmSQm4uXsOq/EfgelA9hqyXSV+y5TY3f88UoidPwuU35e7UsAkffDdTQ/MgLEOoqhV0blSWqaiNbnKTw6eIT9p63YPceKDBaMqQxX7NOXN0o30tZSIZhv4VOuYeMu7Rgy8hdm7AdnikCox1Twgim0tfISuKmKUHQ/4Ft8rbjBDGayxl/H5pl9LGgpLSEOU6zbepiye0ZZOklmTwwv8LQlEwKOgEfXzvhWTV
 MJ0/5cYC
 jltmUoyOIClYm+ORXH3oxwKcR8ik0GwlUsQ1lW7wWwDyLhSpeNU9bM+KJ8t5Wi/DYxMw9NdGjH5c8lAlK2ho2VvSxELvTWBhRfKeWkpxrQ++MWvreiACbg825JptPqkcHSPpL6MJAJvYpsCpMjATjlV0KlGpxIiuq9OaPbmujscd2amOswpY3q+TIransAfwBlOJs8gSjrVd8WCd7NpX+gDrkxzOB+j+92fEp00z4TuoJW5gEKXpc+T7n2WBCFCdsrwtGWGNeQ3+jxLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/8/14 22:47, Zi Yan 写道:
> On 14 Aug 2025, at 5:00, Ye Liu wrote:
> 
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Use max() macro to simplify the calculation of maximum lowmem_reserve
>> value in calculate_totalreserve_pages(), instead of open-coding the
>> comparison. The functionality remains identical.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/page_alloc.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 64872214bc7d..8a55a4951d19 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6236,8 +6236,7 @@ static void calculate_totalreserve_pages(void)
>>
>>  			/* Find valid and maximum lowmem_reserve in the zone */
>>  			for (j = i; j < MAX_NR_ZONES; j++) {
>> -				if (zone->lowmem_reserve[j] > max)
>> -					max = zone->lowmem_reserve[j];
>> +				max = max(max, zone->lowmem_reserve[j]);
>>  			}
> 
> There is a “if (max > managed_pages)” below. Maybe convert that as well?

I should use min() here, but I noticed the two variables have different types: 
one is 'long' and the other is 'unsigned long'. So, I should use min_t(). 
But then again, why is lowmem_reserve of type 'long'? 
It should be a non-negative number, right? 
Is it possible to change the type of lowmem_reserve to 'unsigned long' and 
change all uses of it at the same time? Is it necessary?

> 
> Feel free to add Acked-by: Zi Yan <ziy@nvidia.com>.
> 
> Best Regards,
> Yan, Zi

-- 
Thanks,
Ye Liu


