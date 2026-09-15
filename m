Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A293C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48BBD6B0092; Mon, 14 Sep 2026 22:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43CF16B0093; Mon, 14 Sep 2026 22:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352626B0095; Mon, 14 Sep 2026 22:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA896B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:25:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C05B1A02E3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:25:42 +0000 (UTC)
X-FDA: 85214405724.12.3E0E86B
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id B5C331C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:25:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7ciUKFq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789439140;
	b=FWQl63ZUhSxSdYImZRzB+lIISclUomNXkU0y5oIcMcmRvhP75aIB+DNmNz3LQjgCMAVzRu
	OpykLvEPhEX+9rt24bi5Vod4rOFLXCYlJ0i106sXr6y6u0psVPviW1d/Dau3rC8t3uI4g4
	1MpLcno66vZLWu9muVpnoPIMoYvFlr8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7ciUKFq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789439140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TsN/QBnTzQalbMed3Wxwi/M5F0q6IcRHiwwRS9oYQs8=;
	b=FvIXZ98uXpcmU7HRcIyJ+V8oGldwKYm+R/6STei2eiiW2OlOjhFlVS5kzMFi2FcwUpd9Oe
	9AoYd282grLNQ29UZoLwznhz9rMtPh5pvpdV3NmNKi/cD5nW3wbvz9ZtxLCtkFF1TjryBo
	elcRkYcUE/tLw0Hm9RqP7zDIUfYa0lo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=G7jAV2yOVUgDl7MjUvMbstEXrE2pwtF5/atE+hJu/P4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789439137; v=1; x=1790043937;
 b=t7ciUKFqPBEZwQMEJDKqx5K9iHlF57FcZMf5oYVFVQrPSyYyE7SIeyE5jA8UTi5ahazNbr8L
 /zLrNa5riwjmx0omISWKiWkmHx7rLe6rtFoaPnDB2GhU+anIzfGrPyABR7hUNqbyaQVwOay6e0z
 I/ndzDlxlLWuR6fPL6OJXO80=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8ebffbc4bc65cf5d;
	Tue, 15 Sep 2026 02:25:36 +0000
X-Mizu-Trace-ID: 8ebffbc4bc65cf5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc999f45-fcbc-4d6c-a0b6-2bea4da98013@linux.dev>
Date: Tue, 15 Sep 2026 10:25:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/vmalloc: extract vmap_insert_free_area helper
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-2-526f68559706@linux.dev> <aqgow3u0GSlj0P1Y@milan>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aqgow3u0GSlj0P1Y@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5C331C0003
X-Stat-Signature: xpqdp3yje5y115mu4qugiqt5yt14yiih
X-HE-Tag: 1789439138-684629
X-HE-Meta: U2FsdGVkX1/6YoIn+joH5J6SGKXIvj/mH1sqmUn16rKwV9axlEs6KixRQGrtx3UdzARU1WdOFd4QWyJW/vf7sVXlRkfB3F7SaKBWjNRvMSFq5L1GjPShZx7C1W/3u7snTR6P4wigOvcJ9IQc42efd2dwP57t7PDPK5+/vABJP3MSi3TjiH+KznJ8G7eMGaTe6YrgdNZgMFsrT9bfWS5qygQx77MtiQbNC643sishkHnV9vkCVX3uxEJ+Rv3IiQcXoxO2kv1r9gADH3vY4wlYisCM3WvJS07M6DWDpzC6IraBxrOzH9TQZh8low33xxbQUYSCRBTiJnudNb2j5oKllc9jyYFWtzOpw+0hIEjcwjJBWGwXIdTzJKFHzXb7VJqToALc6brLzspj8rORg6CePUZdEOW9IUXzJT34zW6FMyK8A2azOlqnxShCn6t7fcKgVpJ/k0Ie+xQYf/eF+JH18B4LLDei9rGNYB6+y8L45nC+FRT2yYMHpQ0CfqTQ53xOR9UklCUFd2GbokVSG+ta8WCVpWmufGWLKQIdykqtlA/e6FySl+Hks93EwUCy7UlcNo8CN7b/8koH3Vj9aAVcJP5FZGcqsFhQPGVdY+5glGnh9dFJ8gl+dRpYqtu4I73oyrVSKqpLfKSMhsMXHOjAKQxKXBMsmTSqsnwuCcpQH38bQYiSGkOoCktPCdXtJsYE0qI1JX6UbV12ualriYMluV7s/hOWiNqLjurkHdh4VNnJW0+SzmK1W5yGZ8FDI21oQXuaAOF5dM50srQs/X9KIgIy2iAWeRIw/o87rdKWZ/JtHe0ePgsAN5JdpU71G23t/pyoFBOJZi9ykIErb7N6Rjiq0PReckgXsKKFPFFTY7ia4d2rZ7eXNNE2F2S1edTnx9RkiPQOgvLT9HX9ii00n11R0oggb9V1aKOVJ9s0qsc2YqKi6f2S+Vbl6ZuZ0BTJP159R8UnMZ0TKuLdCnH
 /Eoda7I5
 vV67FwRJGiJonx91kNfMEjmWa3r5zWheKX6iN2ReHlDy14Smd8TSpXXHznXtsmxpwYWzZvV+9Adi0c6sRyeoqCVEcuoXDf+Mua0EhVBWA3kpO4EHnp0QHqzssJ9zfJjIBLWwdI8OmUuzgg7/2xiRgZ+xSJbWTWw3T3PfKgdk9lyN0avqdf9LhdygAVNmmw6EFDMymJeWXBt+8wReUOJb8nqlp1h7LonIcQUt7C/rxdFu0CvzfTCDu0ZRm7Xh1YkfKdmd36lhRX/u1pH3k/kPFz3x2e42ug8jz/toyLGNgqQZrWwtE1aCwz96k41j7oDKS03HCfpLzjJqQMEJ3IBdmslkfFlgDJT1L9CbQ49GtN5VxXhvjZBCb/FQ8qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/15 01:02, Uladzislau Rezki 写道:
> On Mon, Sep 14, 2026 at 11:34:01AM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The allocation and insertion of a free vmap_area is duplicated
>> between the loop body and the tail of vmap_init_free_space.  Factor
>> it into a small helper so the main function only deals with computing
>> the free gaps between busy regions.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/vmalloc.c | 41 ++++++++++++++++++-----------------------
>>  1 file changed, 18 insertions(+), 23 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 117483dd048c..797933ba9451 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -5433,11 +5433,23 @@ module_init(proc_vmalloc_init);
>>  
>>  #endif
>>  
>> +static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
>> +{
>> +	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
>> +
>> +	if (!WARN_ON_ONCE(!free)) {
>> +		free->va_start = start;
>> +		free->va_end = end;
>> +		insert_vmap_area_augment(free, NULL,
>> +					 &free_vmap_area_root,
>> +					 &free_vmap_area_list);
>> +	}
>> +}
>> +
>>  static void __init vmap_init_free_space(void)
>>  {
>>  	unsigned long vmap_start = 1;
>>  	const unsigned long vmap_end = ULONG_MAX;
>> -	struct vmap_area *free;
>>  	struct vm_struct *busy;
>>  
>>  	/*
>> @@ -5447,32 +5459,15 @@ static void __init vmap_init_free_space(void)
>>  	 *  |<--------------------------------->|
>>  	 */
>>  	for (busy = vmlist; busy; busy = busy->next) {
>> -		if ((unsigned long) busy->addr - vmap_start > 0) {
>>
> This line gets removed and then re-added below because of removing space
> after (unsigned long). Maybe it is better to keep that space.
However, the '{' is still there, but I'll add a space anyway.
> 
>> -			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
>> -			if (!WARN_ON_ONCE(!free)) {
>> -				free->va_start = vmap_start;
>> -				free->va_end = (unsigned long) busy->addr;
>> -
>> -				insert_vmap_area_augment(free, NULL,
>> -					&free_vmap_area_root,
>> -						&free_vmap_area_list);
>> -			}
>> -		}
>> +		if ((unsigned long)busy->addr - vmap_start > 0)
>> +			vmap_insert_free_area(vmap_start,
>> +					      (unsigned long)busy->addr);
>>  
>>  		vmap_start = (unsigned long) busy->addr + busy->size;
>>  	}
>>  
>> -	if (vmap_end - vmap_start > 0) {
>> -		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
>> -		if (!WARN_ON_ONCE(!free)) {
>> -			free->va_start = vmap_start;
>> -			free->va_end = vmap_end;
>> -
>> -			insert_vmap_area_augment(free, NULL,
>> -				&free_vmap_area_root,
>> -					&free_vmap_area_list);
>> -		}
>> -	}
>> +	if (vmap_end - vmap_start > 0)
>> +		vmap_insert_free_area(vmap_start, vmap_end);
>>  }
>>  
>>  static void vmap_init_nodes(void)
>>
>> -- 
>> 2.25.1
>>
> LGTM:
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> --
> Uladzislau Rezki

-- 
Thanks,
Ye Liu


