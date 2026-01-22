Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC32D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94CC76B02E2; Thu, 22 Jan 2026 13:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA1B6B02E4; Thu, 22 Jan 2026 13:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2D26B02E5; Thu, 22 Jan 2026 13:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0146B02E2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:00:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CD7B1604BC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:00:07 +0000 (UTC)
X-FDA: 84360363654.26.620CD81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 679D5140012
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:00:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EfIyL8jj;
	spf=pass (imf26.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769104803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZLWX7Ttit3Pt1qm85Tbi244EW7S3psWz/a7zbS1I90=;
	b=VKh6Hdl7dk2vVRqwI8aD/ifI6bYkcZtu+eQ92pemz1Yn8p1uD8KStvgsiLoQY0W7f0nuHd
	2D6MX4ihF3wC71XpoqvBgwRvgHdwWhLoSPQ0zCPTVqQ/cczp4cFfEdlZtW56OxHylPZH71
	4Y/vHRjZdXw+uGkWB0W3Hn369H+Zpas=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EfIyL8jj;
	spf=pass (imf26.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769104803; a=rsa-sha256;
	cv=none;
	b=vWPABJA6VuKSann3IXLEwe/1Kxdh6CVGvX2qOnQ/RorEue5L2ivbFvNHq96b7mSc4iuE5I
	/oLKDT4gLxmcQX843dSQSUjA7+9HWUssVYvVf6XgpD+LLbqFx5dVmPu2NCGghDiDGre7sS
	MhgKf/1gsVif66rItcyfUmaQxwxe9YM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769104802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZLWX7Ttit3Pt1qm85Tbi244EW7S3psWz/a7zbS1I90=;
	b=EfIyL8jjGp4xUDTAEygL0coSOoCAJnbr1Q1fvKvOyKXuRVf3IbhUcifuaaJt4WlIrKyc7k
	Ldalk1+kc8WdaOgQJ08WTlmCVn5Tp1oU4cHBF7MyU4FyqKQ6/txKQl5cpqFGdklykqNxVi
	Y7eQA/WsNHcA8GRWP7WI1GZoYuB6O2g=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-8lw59hIpMF-oGm9zjxat0w-1; Thu, 22 Jan 2026 13:00:01 -0500
X-MC-Unique: 8lw59hIpMF-oGm9zjxat0w-1
X-Mimecast-MFC-AGG-ID: 8lw59hIpMF-oGm9zjxat0w_1769104800
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c53919fbfcso284464285a.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:00:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769104800; x=1769709600;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZLWX7Ttit3Pt1qm85Tbi244EW7S3psWz/a7zbS1I90=;
        b=cTcAX2WU4hjC+SYCiidI5+cQnoDzXpEIr+Bl6qsL7V8OP0WqortPOfY+PAEKymoPsr
         ODg+6PDy9TM/34ZpP9lPQcQXkfLYtwiQeadu8y2DmNTDhXCTwWqpad+YASVJeWtrvih3
         KdzRDe6JYB5P61+/0nm9PzPFNQrCrkE3bk6yS7AvmxOV+DpFS4BbdN1mgtJCay2XAotZ
         Ybi+cxqWfYnuPsWqTUxlceAPgiyE1DD2rh5HnP8AiR+S1F7Ke8aD0n2V+CFMc32GHXA5
         LNMFL+QlVglUq+mMVOhsdGgkbAbX8Kdvxonsy76xYbw0nR8k8MeBOmv2EYwElxNnf1GJ
         eDLA==
X-Forwarded-Encrypted: i=1; AJvYcCXmqs8al6x5UzcszC0le1mtoO2EJzLHp7A6RnAXL2LkOxmJC6goW8kOKjAX1QhDMuDf8PlvytV2GQ==@kvack.org
X-Gm-Message-State: AOJu0Ywi8EDETBcn727regpMrurQIsI2wqDemcTpvd3+IWg4Nx8FN6AD
	3kEzLFIm41wiTSZGtJb5V5whXuPuPH44/9AdZQw+7reObtwJbqbVURKSjZm+LKLWQDMYwOHNk0j
	dV5iP2psyfgZi9H/O4Du1z3nGl686p8llwPjMCjvd01SCzx9GbAMB
X-Gm-Gg: AZuq6aKAeMd1JYcH9XLOuWUvbFbJmpRi11r41QkNaQvKFNECfw6Eybkmqg1XSDcLPf6
	OwJcfZv9zlUhOZTjGoXPP1nXM2RKTksRZXhVGG48XBuj8SLrXnW7erJ6GCMJjKjk/0xOTGnEpRi
	+oiFj+nFOSKBt4wvOJwSTXaszUbapFWomg6CknTe0cf7ryIn9aSTawkJ3o4vMV1mubS2z7xq3B2
	GiR58R/d7Lf30iJr0YMg8mlNvDunMrJopT1409SQokKtuTVYFNpaN3fMK+3B2UPMXXQIRevHuR6
	zhOYjGMWZhiD5SZNmGDx+mXriO3cJtE7vViPu/R5ISQy9DuyrDCczlyXMVAFVdhiBq8eGv+bLYc
	Qy3uFzMQmYZ1PsYmtEWrjc81HJUbedOjAJPhRW+qlPh4gjuJPA8LxzSi1
X-Received: by 2002:a05:620a:1924:b0:89f:9693:2522 with SMTP id af79cd13be357-8c6e2e4ac7cmr34980085a.73.1769104800445;
        Thu, 22 Jan 2026 10:00:00 -0800 (PST)
X-Received: by 2002:a05:620a:1924:b0:89f:9693:2522 with SMTP id af79cd13be357-8c6e2e4ac7cmr34977385a.73.1769104800080;
        Thu, 22 Jan 2026 10:00:00 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6af506829sm1272959385a.37.2026.01.22.09.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 09:59:58 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <0fcbb05f-fa7b-47a1-bd4a-d59f1e0ddc35@redhat.com>
Date: Thu, 22 Jan 2026 12:59:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_init: Don't call cond_resched() in
 deferred_init_memmap_chunk() if rcu_preempt_depth() set
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 "Paul E. McKenney" <paulmck@kernel.org>
Cc: Waiman Long <llong@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Wei Yang <richard.weiyang@gmail.com>,
 David Hildenbrand <david@kernel.org>
References: <20260121191036.461389-1-longman@redhat.com>
 <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
 <0e385146-67a3-4fdd-b119-059caba8c5f0@redhat.com>
 <13d0b8b5-1ba7-4a3e-a686-13a7b993d471@paulmck-laptop>
 <20260122075747.uSLrSJez@linutronix.de>
In-Reply-To: <20260122075747.uSLrSJez@linutronix.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4Aaw0zZCu7bSebdOOYH0ileFLCdaACCKfFZKSkX3vjc_1769104800
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 6rpdganc3hfwijyy3ncuzqouznkugomf
X-Rspam-User: 
X-Rspamd-Queue-Id: 679D5140012
X-HE-Tag: 1769104803-83313
X-HE-Meta: U2FsdGVkX1/Bmi01oViMEOwrzXYYj+rVC0DSQB/F+hUNRZ727vtjnbhEszF4SQx1HRRtSpYlx9qHBkfZ84eF9nu+FtgMcXT7uKBKlUlAdPRAiP+2xiKj258VHiR5aWjRhIw1LiXDt/IujhITC4S6CLrti0BJmUTyxmkYFOz+P42examgUJvNZlYrf7Kog39UKfXYW7RpLZaHTNzvDuRQBMCaVnxnJC2o8mBVTsix+AKYKzqKoEI6qfHvd7akgFKE/YNMaLLbkfTcuUMx8kxcjzux+C+enK0qe0zTs/mXN6gAJ56toYiDJXfDNEOyWKbDsgRUPUKRmbkpLBpeD82DXC3vi6e+LbU3eZnEZZQbL/vNjW10sQz3zcSoXKAMrxHBkeOsdX9LL9DGz3AEQ1I5ME50g2243PT2rzsFDTrwWIM0loO0wAQZbnzfERnRwpyemARUrLZOTgQgnYey2ogiyXuuPlCwi95KPtVCJfqeh3oK/IEC9bY68ooERJxlxd9KG+fkhdoLuMQsHSgJjWsvj9IPtbtCiw5lbEMcx7xHuv+jlNCPvpNO/aHssKIqoA5ZjcCatD2QR79bYsITYe6kx0D8wqqUB1+NKNo81O5Jh2vKZmB7F9oXQJ8q2xO9Lf6hj5bAQcU8Q2BRSTS51clQUay/oOujwSu8GHosyxxNXBNlaIzdZKK92TxGoImfrPJ4Lb8Xe2avrqHt3ElAWj1A4TmMXJG35oQn7Tvtn2rxKWMa5kogWV/PlJ/toRhOgB+MfwbUP2SxoYhbSKtYFGm2dQVSutyAcXqXros49VStYH+19+FQDDFI34MI0nx4u4WxVFFqp2eXP2bxJr+X+wgj/CcJyjkgUZS/sIS7GSxMdtBZNBXzfqCCIVdWg25UfY5HdbN4z1H8iHPcC9LSYMyhBG1uoB9nYjJe+XbjP51S6YK/0+7fd3gzYe++KMVUfKqg72RKH4myoSgBRnEUpR4
 0NG3wSnp
 ebKls2Kchac22LTCyhagVwdAYtWk62Higy8wqUZB5+Xq0YuGdxrq/tPOmdTePHMNsz3yRSZbmnPxwAkeWZGxeEtQjkABVKKhg92H9qUD0O0mk1dKhpNuSPfNva6QiFTT0R72Q8jU4iIZleUmGb4+mjD2CyZ4v0Mj46hCcx+ERvh7rv7l2wgR0CfkLoJZmuTwzFxQqs9Ff8mn/VG+frsS+Zwa0zKqd37blKNyYGJCz32qo2BOrTHNfKRR5yVO3GZGYWDFy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 2:57 AM, Sebastian Andrzej Siewior wrote:
> On 2026-01-21 13:27:32 [-0800], Paul E. McKenney wrote:
>>>>> --- a/mm/mm_init.c
>>>>> +++ b/mm/mm_init.c
>>>>> @@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>>>>>    			spfn = chunk_end;
>>>>> -			if (irqs_disabled())
>>>>> +			/*
>>>>> +			 * pgdat_resize_lock() only disables irqs in non-RT
>>>>> +			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
>>>>> +			 * kernel.
>>>>> +			 */
>>>>> +			if (irqs_disabled() || rcu_preempt_depth())
>>>>>    				touch_nmi_watchdog();
>>>> rcu_preempt_depth() seems a fairly internal low-level thing - it's
>>>> rarely used.
> If you acquire a lock from time to time and you pass a bool the let the
> function below know whether scheduling is fine or not then it is
> obvious. If you choose to check for symptoms of an acquired lock then
> you have to use also the rarely used functions ;)
>
>>> That is true. Beside the scheduler, workqueue also use rcu_preempt_depth().
>>> This API is included in "include/linux/rcupdate.h" which is included
>>> directly or indirectly by many kernel files. So even though it is rarely
>>> used, but it is still a public API.
>> It is a bit tricky, for example, given a kernel built with both
>> CONFIG_PREEMPT_NONE=y and CONFIG_PREEMPT_DYNAMIC=y, it will never
>> invoke touch_nmi_watchdog(), even if it really is in an RCU read-side
>> critical section.  This is because it was intended for lockdep-like use,
>> where (for example) you don't want to complain about sleeping in an RCU
>> read-side critical section unless you are 100% sure that you are in fact
>> in an RCU read-side critical section.
>>
>> Maybe something like this?
>>
>> 	if (irqs_disabled() || !IS_ENABLED(CONFIG_PREEMPT_RCU) || rcu_preempt_depth())
>> 		touch_nmi_watchdog();
> I don't understand the PREEMPT_NONE+DYNAMIC reasoning. irqs_disabled()
> should not be affected by this and rcu_preempt_depth() will be 0 for
> !CONFIG_PREEMPT_RCU so I don't think this is required.
>
>> This would *always* invoke touch_nmi_watchdog() for such kernels, which
>> might or might not be OK.
>>
>> I freely confesss that I am not sure which of these is appropriate in
>> this setting.
> What about a more straight forward and obvious approach?
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index fc2a6f1e518f1..0b283fd48b282 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2059,7 +2059,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
>    */
>   static unsigned long __init
>   deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> -			   struct zone *zone)
> +			   struct zone *zone, bool may_schedule)
>   {
>   	int nid = zone_to_nid(zone);
>   	unsigned long nr_pages = 0;
> @@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>   
>   			spfn = chunk_end;
>   
> -			if (irqs_disabled())
> -				touch_nmi_watchdog();
> -			else
> +			if (may_schedule)
>   				cond_resched();
> +			else
> +				touch_nmi_watchdog();
>   		}
>   	}
>   
> @@ -2101,7 +2101,7 @@ deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
>   {
>   	struct zone *zone = arg;
>   
> -	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
> +	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
>   }
>   
>   static unsigned int __init
> @@ -2216,7 +2216,7 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
>   	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
>   	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
>   	     spfn = epfn, epfn += PAGES_PER_SECTION) {
> -		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
> +		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
>   	}
>   
>   	/*
>
> Wouldn't this work?

Yes, I think that is the better approach. I will post a v3 with change 
as Mike has no objection to it. Thanks!

Cheers,
Longman


