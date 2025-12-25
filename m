Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D01E7AD5E
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 14:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2A16B0088; Thu, 25 Dec 2025 09:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3C86B0089; Thu, 25 Dec 2025 09:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5F86B008A; Thu, 25 Dec 2025 09:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19C246B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:24:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C3F91404AE
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 14:24:32 +0000 (UTC)
X-FDA: 84258213984.30.6750035
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C96E100002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 14:24:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EGWPahYv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766672670; a=rsa-sha256;
	cv=none;
	b=j7Hn29PMQ4REyOJ7qdaciD9ayDgECl44nA3rf+IksJW3yJf/YiJ7Q3P8FsvI2oDsNQ/Slf
	1+lN8lhOVlg6HFdpQWRlQbiRz2NzANgYL8PUwxgibODECp0yx51jDhjvSBQiYlE7IWPDhQ
	eEHI7jyaZplzhaSzONK1g2sWVDAsh/E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EGWPahYv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766672670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYLFNJEHTSWA/rTg/7WAiD/Mb4jLY5XsAYJsDyTHIHk=;
	b=6noUeaOYqA6edAXtMT8c+z9rPfUIvwjBtBeHF1pskxtlzhbJQh1aCKuUiChl0KHhOO11AN
	tiaBr2oh0TT+iJnmWFO0c29TYbU4+ipBpNewb73ueSpHXSx7jzG/mpkh18t/nObRqYBytl
	OP61uXKSwiKMGTyta+tMJX88PXSe3ao=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b4f730a02so10852479a12.0
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 06:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766672669; x=1767277469; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYLFNJEHTSWA/rTg/7WAiD/Mb4jLY5XsAYJsDyTHIHk=;
        b=EGWPahYvc+GHgBmkGVqHiCmq9iAryorbpe3p67CiFSmfMUy/ZIRMMhV2r/zqJWGfO1
         n8AoRZ1qcx93TZhbYAXZzPLr8t70HGZPPqKhUlIMutVnNtTjpDXo7NiHMnBzvB8FkaMW
         06GHvxKFNe9Z32oi1Iu5G3t7RyxHW116XIwkRDHyO34FDgtldBIlLQzda8pXghNAsSnd
         6zJApwFnUWHG/5gMeWIIdzu3msYfWpNbBMZB3NI9EoIOHsJqta3QOtI0phqBN5lNCdN/
         Lpq4KWWRsx1ZtMjlZJ2ZRYaTI7TdSWSynri1q4QaMrV0eHR9uPozeM+NylaFtnC+T1dz
         m4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766672669; x=1767277469;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYLFNJEHTSWA/rTg/7WAiD/Mb4jLY5XsAYJsDyTHIHk=;
        b=PP6AvpqRZenOzMgQBV4XMe712VgI7XM5FqqAD1f1dsAC7yXDY/R8Me92i11/zYsz4e
         7bTBAGf/t+2V+YECXq3thIJqpQTyhBWAF94CnuXy34stNwBjLeSGY2vdu9UsGZq5gsNm
         3LRpmQdfn4BKiKMiIg99pFjvB5o5kN0HUoHbpw86Qi0R6r1Z6G6kkVuO206urjL3RgjF
         pJqVWQhMWr3taHgsBudJaNzVuA6qcMpUxVrpQaTDcjDcWQknvRQKy2RSG8bm5Q5S4JFE
         dB8K8gHhrbFYCN0BEaZ5Rm39pXyk9W0NdiyKBjk/GHiNLUBu4x55SMeA9MjtpHj3M9sl
         /zGg==
X-Forwarded-Encrypted: i=1; AJvYcCXgeV3GBSKUuRwqvOItYgFXWJBDQGGw6x/tA5D52eE8nfRS8N9u7jyl9fLAxqUFxgWZGD6vQShVHw==@kvack.org
X-Gm-Message-State: AOJu0YxYuBts1w4Z6X461XYueMA2JOufBmicNyxQxzFOPj4iBggcJR33
	T/9fO+a2u9wpP9hgklyOLFkdxgEWiwO9Ln3Fm6autqDnH/JI65Z+CSba
X-Gm-Gg: AY/fxX4gJ+5eFmT2t7hbxW7TxXuVgNdHNsH/xVRFpvlL9jKWN8ig65Gvz35DrxRd4gA
	6q3ZHUOsCAzciNX3SPsU6QGUGWQYTVFvlSzckczPVcDSn9J1y9Uz+MuNRu8YwNlpN1oDKAA87Ht
	z9ja54jx0OSj0ShXi6uwtbRi6QWoWNS4TqHd1YNYIVwKhDkbbJ1xykCpHDXTn/ADp3pDfMr1mbF
	7z2bXlIU1WfWxyDgNUG4xLjHhJvBqM21AsMKQ1a/J6acGpqJvxaNBV9KIe/n/TKjx+xu0nFHe40
	U45CCrqHGRSnp7Qx2TwSmplafzP32bptf/uDoCzWm8cUQcIPsYZP3QWZvH8fKOekKP6TwaGY/mW
	RJSZ3yz4k4QT0zITqK9iMQpXYNMZ9os1jxjWFhu8WKBfElgp0vSQlCQdBqoSl/i8bTOQrLLx6NB
	57XMKuBK9XaQ==
X-Google-Smtp-Source: AGHT+IFco2ZSS1k/XWSKYY0R8AjYGyeFBM+ARahghc7zBTZoamAt6Q0hV8iYR6hU94s+s5EkzQ+z7A==
X-Received: by 2002:a05:6402:5248:b0:649:2347:e15f with SMTP id 4fb4d7f45d1cf-64b8f02987fmr17060473a12.31.1766672668897;
        Thu, 25 Dec 2025 06:24:28 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b91056726sm19393276a12.10.2025.12.25.06.24.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Dec 2025 06:24:27 -0800 (PST)
Date: Thu, 25 Dec 2025 14:24:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove unused function inc_node_state()
Message-ID: <20251225142427.3hsby5q26mwka4ib@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251225015445.16727-1-richard.weiyang@gmail.com>
 <20251225075217.1298303-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225075217.1298303-1-joshua.hahnjy@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C96E100002
X-Rspamd-Server: rspam10
X-Stat-Signature: xgnxaajk39zx4xaokwj9rktdjncysc3w
X-HE-Tag: 1766672670-211667
X-HE-Meta: U2FsdGVkX18qSXs3trA5quA9g2WXf+N/1SzabRAXBACivb6s0UxZRwkwj5o6gHDsdZpciAoT12JzH5MsPMNtEUuLPtgqz+0xppfOlBUH6eyN1g+/N7Fm6pc6h1Oh4szhyx580jSWCEdr2PHJHeyTJYBw6e0aNEurKn4oGpwPS8R3iU5DzaAfk1/i0dcssEizE68rWQhfXEm0lOX4gGvfUegPwRxnvZiAmyeVTZsv5PrHV072B0igKnl61Rkp7GfeyFtSOomKnKIw+3NWXtIPcXP9nLNB5mmL3IAdlwMfb61mUZTgzDV+GHzdh/OWdrXdQLlQJ7rTXby0gd3rOj5UVUNr5EMtR4lpDZ7Bm1ago190yNM2o+HrDi6D31meCREWVENj/+UlNxt017vqVc+UkwbQk0DCSr2yClYpNdpizcRubsBArxBCkp7F0nA96DsowHsfBMhn6vgZq8quXPCIxZdQSM0znMGUT77lK/9NpG79+oAhwxaQLD2AT84v4mXal7BQhef/iMwxKQwdNo77YsPOPLuaYiNDhfW324cXmPperjRe9FVkB7pb7isj7qdjiPmPmMANZ5vDTrc2V33SUL8+t87t2fkuVOUUHjdwle3WHzBASIZ88i7THGolG19j0JAxas2T6PDhOXLszK5UYMw9rClF2vjWdsfaIvH2c05G++LcFXIV9flVGYFufNdtrJGOA1krmw0iOv3DVUlV3TScX9yHazGbrTuUrcoh61HxYZeYHq0l5cwVfnxO+XzjIv5/HxZCfBDN2dn4AQZeNi/Oz4fUO+y8UG062jf93Za7XaR4moci/rfC7J9sXIlrjBkHD4wn+M3q1aUgO58iH7kjGLo44mffM8HQiRHMkffhVilScwPl0lz1lRXG3WRwp4rlOSA8oRsWDtxQB0gsL4mSSHpqVFetGksax2O5tybAYmSKlkAQjsiNk7oHN2fYZSDQM2cWeUP+FcSfnhr
 SSRPUm1C
 LbC0KLBwFecq2bAr0CzV+k87yg0gTXdSenchVpcyAYZMzwFzE3IDfxyZqVJzpTMN6fF0v6tRLWQ1PsBwRctyXJ6hCig7JWgXok4CU/FW9kHrgNREwZl53CQD/+1UvS1n3CB0NNh+2LkRxSOd6N6Kvpfg2uGAc6wAQqzg2xczVoQUOJv6OKcigLRzuroc8C8/6/FalbJenjRi5tB1Hw1Rsa7zB4GEkHh+SbyV4AvTbRVjatPLPUI7VNhpanDpAw6ZZ6eJj04vxCsFTBGC1J/wpvyhutyLaB8oR8ame6w2EzXuyenHpL08JOQYBdzUrFGZJmiK6uxZtGUIC6fk+uviN/EXpRROUJmBKiroTCsMDoeL9yOYakGOUPR0T6CDgTZe50IZ/CTfEpFCjhsytqU7pB4gznTk6uxXat1CM5IVAJjVqt2W3+qzn7yyBjnMza8CeOzSZwEjr4SdiFruMmMmheRTr+6UEOClQW0ZLF+isN5QvniMR8o64s753VMDrhyWqncx2v2Yh/kN9w5liQz++/jwddWnEuQ9kz7qIirKimsDSdwNXuyTl42CvmqcvFcT8LGVrIcUJywA9IJ0fbgoOA3qhHfsbojj9Lj9sVOYsalV0uIKgPQGzdx7gTJj+EQcaU7yLzeKzMb5fFQU6L8Xb+SBvIkS90EqSeCU3yBIfOmnRfzYwDRtamlFrJzMduTdxCV6WVdQmLYSf0YDmQ+FuvEaSooIhbBqychsB65tMTX1FBZcf6rE+ov2cgzeM6zzEKKQgTYYXH9I4AZqowQoSNE4UA+cdFeYWuwc5T73q9kJQFcvFYxcLJCsX0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 11:52:17PM -0800, Joshua Hahn wrote:
>On Thu, 25 Dec 2025 01:54:45 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> The function inc_node_state() is no longer utilized by any part of the
>> kernel.
>> 
>> This commit removes the dead code.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>
>Hello Wei,
>
>Thank you for this patch! AFAICT it seems like the last users were removed
>all the way back in 2017, in 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats
>infrastructure"). 
>
>Maybe outside of the scope of this patch, but I think it might be a good
>opportunity to also remove dec_zone_state and inc_zone_state as well since
>they are right next to the functions you just remoted : -)
>

Thanks for pointing out. I will take a look into it.

>(Interestingly, dec_node_state does not exist already).

If I am correct, we don't create it at the first place.

>
>Thanks again! This patch looks good to me as-is, but please feel free to
>also remove the two functions above if that sounds reasonable to you.
>
>Have a great day!
>Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>
>> ---
>>  include/linux/vmstat.h |  2 --
>>  mm/vmstat.c            | 15 ---------------
>>  2 files changed, 17 deletions(-)
>> 
>> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
>> index 3398a345bda8..864a78287371 100644
>> --- a/include/linux/vmstat.h
>> +++ b/include/linux/vmstat.h
>> @@ -286,7 +286,6 @@ void mod_node_page_state(struct pglist_data *, enum node_stat_item, long);
>>  void inc_node_page_state(struct page *, enum node_stat_item);
>>  void dec_node_page_state(struct page *, enum node_stat_item);
>>  
>> -extern void inc_node_state(struct pglist_data *, enum node_stat_item);
>>  extern void __inc_zone_state(struct zone *, enum zone_stat_item);
>>  extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
>>  extern void dec_zone_state(struct zone *, enum zone_stat_item);
>> @@ -395,7 +394,6 @@ static inline void __dec_node_page_state(struct page *page,
>>  #define mod_node_page_state __mod_node_page_state
>>  
>>  #define inc_zone_state __inc_zone_state
>> -#define inc_node_state __inc_node_state
>>  #define dec_zone_state __dec_zone_state
>>  
>>  #define set_pgdat_percpu_threshold(pgdat, callback) { }
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 090b5c5294b9..16b7cb24d411 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -671,11 +671,6 @@ void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>>  }
>>  EXPORT_SYMBOL(mod_node_page_state);
>>  
>> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>> -{
>> -	mod_node_state(pgdat, item, 1, 1);
>> -}
>> -
>>  void inc_node_page_state(struct page *page, enum node_stat_item item)
>>  {
>>  	mod_node_state(page_pgdat(page), item, 1, 1);
>> @@ -724,16 +719,6 @@ void dec_zone_page_state(struct page *page, enum zone_stat_item item)
>>  }
>>  EXPORT_SYMBOL(dec_zone_page_state);
>>  
>> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>> -{
>> -	unsigned long flags;
>> -
>> -	local_irq_save(flags);
>> -	__inc_node_state(pgdat, item);
>> -	local_irq_restore(flags);
>> -}
>> -EXPORT_SYMBOL(inc_node_state);
>> -
>>  void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>>  					long delta)
>>  {
>> -- 
>> 2.34.1

-- 
Wei Yang
Help you, Help me

