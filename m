Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5922CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 06:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B686B02F8; Sat,  9 May 2026 02:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C626B02F9; Sat,  9 May 2026 02:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49506B02FA; Sat,  9 May 2026 02:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B75F86B02F8
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:55:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DC231A0558
	for <linux-mm@kvack.org>; Sat,  9 May 2026 06:55:09 +0000 (UTC)
X-FDA: 84746969538.12.053AAF4
Received: from mail-m24125.xmail.ntesmail.com (mail-m24125.xmail.ntesmail.com [45.195.24.125])
	by imf18.hostedemail.com (Postfix) with ESMTP id DCACD1C0007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 06:55:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.125 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778309707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WdHXPeLYYnsnm6+yUMpVXKY/id2CgzM5sntQV40ciHI=;
	b=nPlOjL02c2W1WYumDAxZhoSzL4gA7CaMbe6GIipESuyJMtDqBnxEjyOAYUuIhHw7DOpcCj
	b7S9b5fUNafEMuKgOU3BqvlfHHXNCtT4QycOw3kVkT1eDdSJlLklil+5DO/B64cGomuvZv
	q9bT9rIMZh1DSLo5d6YrYOGNx1EIiKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778309707; a=rsa-sha256;
	cv=none;
	b=v8yrM1qvVklZmKTFzS13rShCT4LbIuHClDCV2tcefNqbdLiJJeAtBKWkazNTWsDYyFxiSh
	7p9m7IoX/J8yDGk0vt6zACmmfLNzM+fBOgylqfIGtNmK0S5TyrGvjUKCUbUIcaK6o6vy9z
	+7qL2o+PuhcK+SaLJswQmj3b9JsBnbc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.125 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19e78b935;
	Sat, 9 May 2026 14:54:58 +0800 (GMT+08:00)
Message-ID: <c757f87f-2f2d-4200-99fb-75fff3dc891e@easystack.cn>
Date: Sat, 9 May 2026 14:54:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] mm/page_owner: add print_mode filter
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260509002902.83937-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260509002902.83937-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e0b8493e80229kunm86e998da2622e9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGBhJVhoYSEpIHUJPTk0YQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DCACD1C0007
X-Stat-Signature: c5nfwb4oajikedhq3zkk7qi9m4haayhh
X-Rspam-User: 
X-HE-Tag: 1778309705-490344
X-HE-Meta: U2FsdGVkX1/wN68befznOmqoiNdn6iPyq3G/GdS5cHzVry/6Wd6ClKWuMWYKMUrSrRdqxOlW6c5JhH/XLLq11u7OQ48X1z0Kh+QtU4hE/A0kHoS2D5YdToTQuWJqOtoG/3bnYLLwpL2LT/mDuu1DI1yCOga3N4I1231ifj2h53f/KURw38k98Z0kXJBsvlUr5wdGQ2+IbspfZLRvxX1r8goMIeh74KH92ZzdbMgYu7zupZ58W76zjkuyB66goXW7rKGcRTwQb1q8Y4IJj6n90k1X8nzgKgWEbg/nhZv83aQ3cQ45aC9I39iLZCew0N8+JtfKhxxziZGGcp1pKEp9wuFa3baUoq52iR5+cSE/bRQWBVxHAP3UrWSDYcI5Al6lQTFifXGULPdtN0MAvOmWJLer3LJX5relkw7Z8Inr1cveBRYy/ZBmN0M3R0rRbuq0AnvYJclczI1RkIHqX9wk/atSfQPzlXEEF6d36M9KVBAcFWmLGuPe/2ynK4OcuG80O5xdJe/qX2lnOwk/iGg+8L9RNP2pt6anvEJBMZDgCM3vtwXfzxK8VEnJY/Dsqskx/Uifvy+MKIaXUV8mk2RBQR+OYyVGYHRaveZ+oK3j8yV9mn2xGT+A+/qhrDosDl/4xzcmI39VHp7N2VJFZwF70Bv72S4OOnz2S1QkTWmPPEobrcrEtTh84KPqWSQV1uFGItJSIqnCz+TwvOMxmRWBVImAIjFw5NzuaJHR63CGeox2yNBBTdAvtLRVTX1sG1ExZJ1nmhldRojGgTnmBLmbEqTMPWwC1sAXzMec2VAcBuA6eRa0MPuUGZEr4DfJeyCU9D004QX+XbFVhp6YhcIttkcXP/2zxPMGIWWSsjOzZF4IeaviZ1FPprjZQkGMsxSY/zcKdrN6M+T3iubfx2XTSqjz3mJLMcGjmFW40r17a/sOLsQJypufmGpngaPGmUlSIt+tGZk6aNnEwIHztux
 +HQf7BKq
 qMGFdAGi7JY6K02jfJHMiOxYJYhiE5KKWXyu8fmZ1luzBUoHzO8fWOXrLigaLcOOCBomiXJ4xFH30ftp42OJRp9qngNgM3e+bc+QhnbXBQwMHbpvDF88C9i/J0Drt2Ag5Ksbz/tUOUqywM1quPxL5P+4ir1Fz4aoXjJajxXyQCDbByaWiSNPc4lUcBEuj+9Cag90a4FrOPy53V+4p3JzxevI5zSGxxZU4wqzcwyJvC8/vympqZn51Ci6vhIQMVbZpe3ASm0N9sl4DmnCqWG2FVxR2aBfjL1Gn5mJkVouMu7NKCCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/9 08:29, SeongJae Park 写道:
> On Thu,  7 May 2026 14:46:41 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> Add a print_mode filter to page_owner that allows users to choose between
>> printing full stack traces or only stack handles, significantly reducing
>> output size for debugging and analysis.
>>
>> The filter provides a string-based interface under
>> /sys/kernel/debug/page_owner_filter/:
>> - Reading shows the current mode with [] brackets around active option
>> - Writing accepts "full_stack" or "stack_handle" strings
>>
>> The default full_stack mode maintains backward compatibility with existing
>> usage, displaying complete stack traces for each page allocation.
>>
>> The stack_handle mode dramatically reduces log size by showing only
>> the handle number instead of the full stack trace. The mapping from
>> handles to actual stack traces can be obtained via the
>> show_stacks_handles interface.
>>
>> Example usage:
>>    # echo stack_handle > /sys/kernel/debug/page_owner_filter/print_mode
>>    # cat /sys/kernel/debug/page_owner_filter/print_mode
>>    full_stack [stack_handle]
>>    # cat /sys/kernel/debug/page_owner
>>    Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>>    pid 1, tgid 1 (systemd), ts 123456789 ns
>>    PFN 0x1000 type Unmovable Block 1 type Unmovable
>>    Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>>    handle: 17432583
>>    ...
>>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> 
> I added a few trivial comments below, but overall looks good to me.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
>> ---
>>
>> Changes in v5:
>> - No code changes
>>
>> Changes in v4:
>> - Change from numeric (0/1) to string-based interface ("full_stack"/"stack_handle")
>> - Merge infrastructure patch into this patch
>>
>> Changes in v3:
>> - No code changes
>>
>> Changes in v2:
>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
>> - Update debugfs filename from 'compact' to 'print_mode'
> 
> Adding links to previous revisions would be helpful.

Good point. I will add lore links to all previous revisions in v6.

> 
>> ---
>>   mm/page_owner.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 91 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 8178e0be557f..28766c854d02 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
> [...]
>> @@ -575,7 +594,11 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   			migratetype_names[pageblock_mt],
>>   			&page->flags);
>>   
>> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>> +	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
>> +		ret += scnprintf(kbuf + ret, count - ret,
>> +				"handle: %d\n", handle);
>> +	} else
>> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> 
> Braces are unnecessary [2] because both branches have only one statement.
> 

Will fix in v6.

> [...]
>> +static ssize_t print_mode_write(struct file *file,
>> +				 const char __user *buf,
>> +				 size_t count, loff_t *ppos)
>> +{
>> +	char *kbuf;
>> +	int mode;
>> +	int ret = count;
>> +
>> +	/*
>> +	 * Limit input size. Maximum valid input is "stack_handle" (12 chars)
>> +	 * plus newline and null terminator. Use 32 bytes as a reasonable limit.
>> +	 */
>> +	if (count > 32)
>> +		return -EINVAL;
>> +
>> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
>> +	if (!kbuf)
>> +		return -ENOMEM;
> 
> Would it make sense to use kmalloc_objs(), or simply using a local array as
> Andrew suggested?

I'll use a local array instead. Since the input is limited to 32 bytes,
a stack-allocated array should be sufficient and simpler:

     char kbuf[32 + 1];


Thanks for the review!
> 
> [...]
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> [2] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces
> 
> 
> Thanks,
> SJ
> 
> 

Best regards,
Zhen

