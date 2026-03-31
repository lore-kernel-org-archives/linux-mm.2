Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8095E1061B28
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 02:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2A16B008C; Mon, 30 Mar 2026 22:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA6E6B0095; Mon, 30 Mar 2026 22:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFFB6B0096; Mon, 30 Mar 2026 22:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB0FD6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:04:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C21913BFB7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:04:28 +0000 (UTC)
X-FDA: 84604713816.08.64BF83A
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8F3C2180009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:04:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JfTt7K/L";
	spf=pass (imf06.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774922666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JB5ukn0uCa6Qxbx0qz8yn2WmcmtYcqs4HV7hWyMTUYc=;
	b=ie3hw1Q0M9/2y7nHH0V6L/e441lI5qDJMmP6nr2ixSNc7hqUrh2ckAd43N90149OJpHgw+
	5DcO6AGdrIinOZpMpWsK0osSM375tLDSONJzwS6lonPoPhjh0L/S02Mq+aO33KfNX+3/LE
	newBbRZFbD09eeepuk+u6P989pHeL80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774922666; a=rsa-sha256;
	cv=none;
	b=SNRfJcj7/5YRHmZOGhHbbGSYlGpaCBtCkQh4J6t/02qt+J3Mgs4jl9FzfBe4fjqGcSPtje
	jS8P3Q52cKy0O8QI5wRTseCbs+JX3eSaH5wQEv++Xld/3jwnlIR6d4XICiINeEnxhcM7Vm
	HRfSsJzc+rbolp69l8YJJXbeCkOWhZM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JfTt7K/L";
	spf=pass (imf06.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-35c238f1063so2526741a91.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774922665; x=1775527465; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JB5ukn0uCa6Qxbx0qz8yn2WmcmtYcqs4HV7hWyMTUYc=;
        b=JfTt7K/LRTWpz3lgviLVXI7xp4Z499tt3SRWFxY1gXpwY/lU07jcX61XN7CYpi+eyc
         99/Y8oiyY4hv9UzI6M4v//rswPy3KJgbopzqrQwAybA9KfPteWX6GckKt3hssh14BpNG
         IuF38Ftayzu3oIZxAVl6Jn4SpTiTgQCkMR8+odk8WKNmcvKuqGRhMp/YkZ6woVci9VpX
         Z8VMoJzuXJyXMoAQGjMX7hjkOODmurikVmT/XSXPEFDY4WARODkuTBJlVdCVAv52xN8X
         ACqrQ08zsbGfGlsMkpwTwfE+J4R5bDGFU2zqF8AooVpMHMgIGPGCI6rkw0MEqnaH19O7
         e1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774922665; x=1775527465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JB5ukn0uCa6Qxbx0qz8yn2WmcmtYcqs4HV7hWyMTUYc=;
        b=ANOzB7DxsPZCkr6o5PTWYjs/RSjTIcsLit1SEpBSCdCcDbuzPug61BRuo+rSVpCp7d
         y2jL0jm5cggCyKR/m5GoMfbLzwmFaj3f6aWzTloo3Nwcg1wAtrbXCV1IdWgCrfFYTCG4
         K2RH1owPq/elmh4qf1YFgsEkTH7EFKa8NJOl/ryQ2EHE9ZTpBgPDYTtBam+YYYom80hq
         knSKxeGmV22SFNqsln27Ad+Ph9haYy2J3UoBDz3BeUrUhzV/Z1EvnmPRzFgZGNAlFgSH
         1OQtTAvW33MAQZ3OnVotlx4BkcOISXWAVvwU9giJU4rbfN70m8eTfjbJl/ecd7tWHTMH
         ttMw==
X-Gm-Message-State: AOJu0Yw30Xg5e3/pWvBFEDiflF91TtDB1OcbYhkAR2U577nTq3K2llwJ
	lUubY3uY/XTKXyTJ2ty3kkhxOlK4QqlCInXF38zZ6QRrWat1djUZ3s+s
X-Gm-Gg: ATEYQzw7LClqI6McqB0lsoaN2I+adXwhugUbGcHnW6bqrWr0CqII02B8SrO3UXlm+6y
	rcN2IOmDovMgdoYgzcoxI5iEy7j0bjXElZBHrLAkZredRbs0SWkx74e0VSx4DoGUITVjt2AD7EF
	xagR1Z3hGSzS0wx8s5QvO8dcCi7n+QiA5kGA0cwD+u1pbLMBXxDnxXS19S1AuQ687M68jJQ89Ha
	tL4dwComvfE2jBAcmmB1B7UK/OPj8iAgIBNOozkIDNVT/HxFXGrHqcUrrB/dPwvvkp61OodPm1+
	mi4tIhIcvBvGCBTrpm+aBAbz7ivIMq8LV+hqiSTa4dixREPreQ3eGJVtOj6kp//tz2RT66tE/oe
	GzsWUuCqCDy0pkUsjocaDoNHF1r1qicfw0gWypgGzZQLo+JaEn2YpEx0Cio/ZYOyQ8ISR1oYO0f
	MjPExkzU18KUUZHBR0Ntws5qiB/wFeRyoVhBss7u/RF0/igXK+
X-Received: by 2002:a17:90b:4f42:b0:35b:e52a:6fe5 with SMTP id 98e67ed59e1d1-35c2ff26762mr13137266a91.5.1774922665300;
        Mon, 30 Mar 2026 19:04:25 -0700 (PDT)
Received: from [172.19.21.154] ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35da9ef1b70sm4251292a91.16.2026.03.30.19.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 19:04:24 -0700 (PDT)
Message-ID: <6f0fcf07-9ee1-43a7-a0ac-0a5200acf099@gmail.com>
Date: Tue, 31 Mar 2026 10:04:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
To: Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
References: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
 <1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com>
Content-Language: en-US
From: Ke Zhao <ke.zhao.kernel@gmail.com>
In-Reply-To: <1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8F3C2180009
X-Stat-Signature: wxacbdswc57qmewd1f87kf5f9zpgsfhg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774922666-211410
X-HE-Meta: U2FsdGVkX18yggyJXq9RhBY60zg57C5NRCa0sZNGIV7AQixMc3/CX0WOPzQQF7AxhibWpUMxdiAdUA0e3nN45l93vUcDGFbWjzQu8iCkAxtOect/3TYXe0DuML3Z3+rKCMYiwUxX6umfxR4xjD46LpSIiDUhAZ67oNB8NPpb1a9FYeW3R/qtzGUhax0D7XQ8+yZQpRPEe9pDZ2FJyQ6yaJQ57wRZAxYq7u96UDPkm+URpqRr3pKG2o2oAJD2Ac7/aKMMSyaXvqTdhK88TYkQyidMGTOpw3c09wwLoLKaZpGQg37rQ0YR/H56dwMssv3wlw7YQ6CSkXifL8fboYCou7ARoUhLnhWJqkQ9acN5aL6vYCREl1QmIFNFNw0Q5q6dpsVTcn6U0c0pAfOUvnQkLgfXwe+TdDvVeqcxUGY0oBSZQL88KfJh4yXUmZ0yQNcEVNrdR3gp2JGlA3Rdm7U7UYq2YOUpofXtCYKQOXh6wBn10Cf48/OjLyZY3iuRaFHBYtttTpnvO1VgKpM5/A5vexIhauIazvgm0o93IV4xl+yzKt6MMO9DnNGMidLp443vv8hnpEx8KUs3ogFXNA9vsSfzg4crZNs1YIcAxTCtixn/a+UJA5FyKLAxVrOt4IgEyLtIy+MTMWeMn+dMX6XFt5PKO0lh/QIhoNa5EWfP1zghP6d+xlF279VKGE23nwKYH8t5+j9EQcti7Ps5QmiQPFfJXN5ZRavPbQ7Y04mBZo1p8S5KfesBGrgpipQHukX7srjZ12xj5CId1aRovg6tUaAPp4g69xoMxx03GjnVNQDMuaIch3hKTUFkOlAnwA641i+gKsxCL4GAeoT9G7zrhYPbp/NAQO2UyZ8vAMb44AxVwsFruhqN/6EBugATjSMP0IuwnuZbNNi4s2CTAna+QmVDtXvpjLwXNBM1a0gLYuJQ+J36Pdc8eva91PkPZNITzwrFRxdzsRKT7CqXEjK
 RxyqcOMA
 K8uR4AO8DxiMDVyiWkmI2Fqv/dggKcW5sZUQ9xdtzQEhBHfZ0mU3wMDLXx23fQURIoWVO2L90kNzDi1e5+5vCC3Im2//Qev0xKfc+NKot2F1mEu27li+DVOJjO0SrGPD4Ep+G6Yousri4uJSD11y0EKQm6/ake7LdO8/LUGgniY6mohHj9Hydi5A3rFUriAL+s4bG7N6IETn2CPOC7vLqrRVgFkSWW2x0ytluqfX9ifXeCMh+pznZlKHmhG8UEZqWyMFldiQFO6Ln0pVYV2yE3YhJ9eqbKBPQ8IBBn9pJnqbXpPAIHu/n3RQ2cCc+h1d3vEvfKwhubuUm7h/p5BbaLtkcNW/5iNt0BGcYhcGoti2QXhV7bexC/geZZOXUiEIhcifDhDl6yClysybQtO/IJPlHQIZXhBCuQ5+m/XJpzhygyx96FGjXs03wJnxrYOYLsacO4aHyvQWYbmeNpsLDaTI0xFy2VCQHKWnsqzKxc4F8y7xLasMMBMlX2SAei5Kdg0UwBHbBLv0e0LholFlFJbm5IeGm6z+f/9g+iZID2E4PydyFD3buz/RYcWFSjpxKXls2qNT3KSeJ4SQxRQETTvGimXUPOAnlxJOMglMEGZpDIHumJg8nX3UjJ10ny++p4f3uR9GPbxmNVIaKv/ARCO+2Q9cLlaCqWkFI0xQcf/1hq1j1TSvOdF6a+clQ+AawhzV7QmbLl8uNbjejZQnyrB1coUfxQ/hNiCwha0jJAumJzDjZ5MToNSVsMdsSb96E+gvHZY71MJQBQr2GbTMxJ3Tv+LKC2uWtzNYQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/31/2026 4:39 AM, Usama Anjum wrote:
> On 30/03/2026 9:36 am, Ke Zhao wrote:
>> Some page allocation paths that call post_alloc_hook() but skip
>> kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
>> Fix this by explicitly calling kmsan_alloc_page() after they
>> successfully get new pages.
>>
>> Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34
>>
>> Signed-off-by: Ke Zhao <ke.zhao.kernel@gmail.com>
>> ---
>>   mm/page_alloc.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 2d4b6f1a554e..6435e8708ef4 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>   
>>   		prep_new_page(page, 0, gfp, 0);
>>   		set_page_refcounted(page);
>> +
>> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
>> +		kmsan_alloc_page(page, 0, gfp);
>> +
>>   		page_array[nr_populated++] = page;
>>   	}
>>   
>> @@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>>   			int i;
>>   
>>   			post_alloc_hook(page, order, gfp_mask);
>> +			/*
>> +			 * Initialize KMSAN state right after post_alloc_hook().
>> +			 * This prepares the pages for subsequent outer callers
>> +			 * that might free sub-pages after the split.
>> +			 */
>> +			kmsan_alloc_page(page, order, gfp_mask);
>>   			if (!order)
>>   				continue;
>>   
>> @@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>>   
>>   		check_new_pages(head, order);
>>   		prep_new_page(head, order, gfp_mask, 0);
>> +
>> +		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));
>> +		kmsan_alloc_page(page, order, gfp_mask);
> There is no page defined in this function. Most probably you wanted
> to use head in place of page here.
> 
Sorry, I just simply compiled with the change but add wrong code into 
the commit. I can hardly make an environment that could trigger the same 
warning here. I'm not sure if I can trigger syzbot to test this.
> How did you compiled and tested this change?
> 
>>   	} else {
>>   		ret = -EINVAL;
>>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
>>
>> ---
>> base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
>> change-id: 20260325-fix-kmsan-e291f752a949
>>
>> Best regards,
> 
> Thanks,
> Usama


