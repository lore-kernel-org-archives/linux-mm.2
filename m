Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1650FCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF908E0009; Wed, 15 Oct 2025 04:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6988C8E0002; Wed, 15 Oct 2025 04:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5850F8E0009; Wed, 15 Oct 2025 04:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35D348E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:15:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA05C1A0B53
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:15:40 +0000 (UTC)
X-FDA: 83999639640.26.7FB9F73
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B4CC4000D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:15:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LZVEiO/V";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516138;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIfqIsLc99bq87qQvOG2VjthDQ82hRvAcTCE74IdLVo=;
	b=PfqaG4U4dDyjGmmvmCirGmT0kVFsZ7OZyFOUZRoXC/ojB1TWQNJQHKA3csULfoTqyWlkVs
	0oimpxATOJuV+q3jT2j1+jsDRqkc2vsGYsSlU36PHXgoqupBZXjufRPNUL1YV4bxAHOugq
	0PBwNhgU314A48o0JZVt390MFjdxsZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516138; a=rsa-sha256;
	cv=none;
	b=XtpmwEy65cY65lcuODypjG9aFse72g1XYDW6bb1iPGI9ydkxgChKcovDevKIAo7qFmQRGy
	WsyRTZsKQQfBlQu04pY0MT0ooWCx0p8vjtIGznFlZG/QtkJYbVl8BM9RisqMzyJWmhAKbr
	92zlJiJrVtg/ohVzW6l74ot3VZEXRcg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LZVEiO/V";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3d5088259eso921587666b.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760516137; x=1761120937; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIfqIsLc99bq87qQvOG2VjthDQ82hRvAcTCE74IdLVo=;
        b=LZVEiO/VuKdsMivanoQDVxh9vAGg1tGmKPS2MTlXfPmE28U8d3fjgBIpWVEbLMdyh7
         BIJonMqVH4mwKzh8pB4aC9KOKTbCl2pPa22XnH2F8p1LSY/Dyv5Fth/gywjttjZWMtVM
         OsW5MGzXg7bfBIbRK5iOT3vk6702MQy4mT7RVSVxlRg3C0U2T7BEBC1mAl4jOrulDJfu
         Jd4QqkvS1EzE5Oh+w486ANKSOr3AZHM9+9hhtVI12lcpKPwEQ8nvSuQnyUtkELaz15os
         I2OOGNizoXsXnLcbsvmlq0jXDyVwRU9tp//56NJJo+oANeZ6wOv4CCVXiHEpHMslDs5g
         6oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760516137; x=1761120937;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BIfqIsLc99bq87qQvOG2VjthDQ82hRvAcTCE74IdLVo=;
        b=gZYl3h4eTZ+1DzeEJiuGBB7KQpF3nhjLaMiuulUWAZu1TWQBhCfD1Kv6qu6Fm0K1AM
         of7zgMRBuzulZ+BiYXXY11ykn6VuA3h71skhBt0/jNAKBduVJeT3klbs3h6OJv4iRNJ9
         SKBTKvVUc1/B7N55HBUGT989AX4+vkK0GJv4ivost2CkHPjvso9vGpr9N0ireFC4+M29
         8fxbNbLjgb6KpnxzDwoG+qSI1EjCkm6RDwGgpwhiSMmT06mb3diKXsiELWuDgF3JYgOa
         InCYtYSGIh6/XNCisWLc3mSF+zm9F9i/KFQfQm38ak325vS2BfApLkSe+JjszJNO++f6
         Vg9w==
X-Forwarded-Encrypted: i=1; AJvYcCVD8VXpq1O/mtnxBxuN4I41E2gNhQBkSaWGNZwSqxo8fZS0RBhZtXd/z9orl2KZYEJ68EJHz81CRw==@kvack.org
X-Gm-Message-State: AOJu0YwfjI2WVlESabgmbXffzFdEKQOTnO/j2igjXyqFnDBJYvcO7Bg6
	5HyXma5c6Vltdb6LXLe4SBPQ6ANkzgHKxI0Q54IA6YAlv50Ja5ZOILT0
X-Gm-Gg: ASbGncs+NxRFCTEqLPtvix+u1mW7ceHOXj8xY9CdZPOaFBP5BxyeKoN58LcJIN0BJAl
	VfGgYDrN6fMmVjyy0k/GhPfAAtTtXBaqGwLlSVVm3W/GdQYylDgtbXXJHxOmQ4Hjl/9nOsOlWYv
	FTJfzNA8Vz/i2Vn8oA9RINa27cQuFn6jZi2MZ011f97u7Gi3fsHJmzLkG7RD/lE36lzhjIOQMPF
	Z0qo8IlhTHJjYvPELJyQfdKfzBcYiqmPPXiPF4FEHMvK2oOz59G6bqjdiEn2p759j527jnAKdHL
	6veIhwvLCKZCH/ODDFLgUtTNmZtTeqBYUTO62mkP2z68jxmRilIZ+mgAF7YCrWXNWvgoCpkHTfE
	cieTy/WXoz8La6cLUXybBfGhVJtt/jtV8EAEAdcuHaC2TNcUcNG4=
X-Google-Smtp-Source: AGHT+IHDve9Dz7zcmKuULtJ8YBELBPq9HTdUfWbvjqy9EPGVXjjytQ9BNb9i9Wz7fy23tuSwn8G8aw==
X-Received: by 2002:a17:906:e20c:b0:b53:d97c:5203 with SMTP id a640c23a62f3a-b53d97c6304mr1973757066b.42.1760516136780;
        Wed, 15 Oct 2025 01:15:36 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cb965dac0sm173482466b.13.2025.10.15.01.15.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Oct 2025 01:15:36 -0700 (PDT)
Date: Wed, 15 Oct 2025 08:15:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/huge_memory: cleanup __split_unmapped_folio()
Message-ID: <20251015081535.qesjcj2mhb7flq6f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
 <B19F20C2-7B99-40AD-BC1F-944FF92ADECA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B19F20C2-7B99-40AD-BC1F-944FF92ADECA@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B4CC4000D
X-Rspamd-Server: rspam02
X-Stat-Signature: du66u31f6manaycrsqg11gcj6nwhoqga
X-HE-Tag: 1760516138-887683
X-HE-Meta: U2FsdGVkX182VQOWiG/gq1l+QVavnA8K9j57QZ061mk36P0LSlJzPdyjpbBkH0LufCPIx6KjUNiyLuVrMRcxotbRLN41VvdzcQyXVz/A5baQf6QU2G33359S/YETPq7WJGMALagMFN68R8dbwsexM170Hg0HQWMT2T9+gzmOkmH0Jpt56PXKFI5ys/HQJtQT8JLHOlYt053WJUdvxZY+0PuQyrU0FGl/Io3uGpo5ZkRoXOLEDXkfv6CPqIUGqcxZbmpGB8tEMW5dWwKZo/gsz0i7BP32Kl1zgMemPc3vEkJlXxmNWpbKZcHrEm7plmwv45ppH8/0cp8rzQfuweb7t8BfG4mrsI+ELqbDvV+9b/1C3EN/IDOO5PMfStmE8L1QY48VQv2rAtyxpFigtehrWWcBAlX3/m8xCASRumHhfndWpZwBsTAVgpIJxAsqIyXJioc/p9hELK3cxctNRTM4kzRmsenYpuMZYR0PJe/Ekl1CWN32ikFYJS7xfmQKXv9IxkBZ5RJRjIQlenBPHRsLoqiyGEsRrBhY0nf3hfc4L/hbFh46AJe1eDvPoJ0wXl6io8kmnI21RnAWpwv9um7h2dW2OqFU4tWbAeTH4cUXMGuhL1E55zcsMtSoqszJ/8VqYjFIBeK3WL0Lh/9D54GBmjZoaeecI/09tW3KoDafEc3m1r6lUDwPk0YMPW5FVlYoKavpGRTlBV6CYlDhhNpvOnx4j1LhSNYD3O/ayDA8U8hXEbYij/rET6upvMZOXwnmKEtyE+hNF2Ojy1j2K0R5sHawgVxF6qaAt6xWSvS1FhE9sN4nNREapIOG7aIYfRAap66NyvPgw5uxrUpkbnabS31LAJYk+vo9FwCRMt6M2w9fdVzNBlOaQDuhQ2XVCMIphlmA7HGc42sIlIrabiYUo7RX/TMynhXwnYnWJr8vmknJ+JaV5xyNAB1h6yAVUeYkvf5uvN4KXz3xiN6nvy9
 W4eENZKC
 Kcb275RNZP5aPaGAb8ZwamOdvnl0wM76dK7leeoBTc/ibVozcygsgsmEyZ/+lGNjqlewoGwrQ3+jCJ7DqmQLchCZjP1lPpz2ODkbkEahYH4L0fUMvCpDNICXG1W6tGyTPahwcNsmPBzAoHM29+wtx/6YOONBJMijhSjCpIzWh7w2px8kDOuUqVFtQ4/SrBBWxloD7KzQkIpnK7bHHdh39YDLls1gP7XzL2Oe60CMQtmQfHE8hNL0XyQPDp0e3rucUNugZiSQxGJu8cYr3ALirwXnIdjV3ylxKOMUwf8zvX9IcrXndwLOL7ibfCcpqfRl5rx1Bq9pFjKnJgP9a4wye6hR7KFNDYQybxDubVTIVGSQ2HSJAJiy9Wqxoh++fiswGdZ2EDGy8N49u2wclpVSzS1PGGqcR05PhyYeWjlxEiSQQJ8+y2WmTKNMGfbMBMalE2m6ADB21NitMRnQfE+rippQYk9sZrLOo8doRSTY+RrpUk5wK5Ng/AgnG2nTzDS9QbqH/lcnqXhuoRtxf3w3hJa0ZXFCp+xMs+pOLNlqFeZFwH5KylVqqYvjdRA9kEuAbA221rPUb+VprZFkzaWvLNe0/M4GsHTbfSttIWGQlDFcDVMkg+spd0n6YxNc41mQ1y4yqY6gqrbA5B0782KYpNQQpU7KHgNWcShpAmSEdE5qfpi4rzSI3j09rgQSBskhBx6YJhowGSbLDDlcVT/tvTcNZGLu2OiaqwXGJlP4OFMHjxccHoiHb0BRd9Fjvn0/wbD4w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 08:45:43PM -0400, Zi Yan wrote:
>On 14 Oct 2025, at 9:46, Wei Yang wrote:
>
>> This short patch series cleans up and optimizes the internal logic of folio
>> splitting, particularly focusing on the __split_unmapped_folio() function.
>>
>> The goal is to improve clarity and efficiency by eliminating redundant
>> checks, caching stable attribute values, and simplifying the iteration
>> logic used for updating folio statistics.
>>
>> These changes make the code easier to follow and maintain.
>>
>> Wei Yang (5):
>>   mm/huge_memory: cache folio attribute in __split_unmapped_folio()
>>   mm/huge_memory: update folio stat after successful split
>>   mm/huge_memory: Optimize and simplify folio stat update after split
>>   mm/huge_memory: Optimize old_order derivation during folio splitting
>>   mm/huge_memory: Remove redundant split_order != new_order check in
>>     uniform_split
>>
>>  mm/huge_memory.c | 70 +++++++++++++-----------------------------------
>>  1 file changed, 18 insertions(+), 52 deletions(-)
>>
>The final code looks good to me, but patch 2-5 could be merged into one.
>The diff below is the patch 2-5 and is not that big. My comments are
>added below inline:
>

Sure, let me try to merge them. The challenge for me is how to merge the
change log :-(

Below commit log looks good to you?


    mm/huge_memory: Optimize and simplify __split_unmapped_folio() logic
    
    This commit refactors the statistic update and iteration logic within
    __split_unmapped_folio() to improve clarity and efficiency.
    
    The current implementation is overly complicated due to two main issues:
    
      1. It iterates over all resulting new folios to perform two combined
         tasks: update statistics and determine the folio for the next
         split.
    
      2. It uses confusing conditional logic (skipping the stat update for
         the folio at @split_at on success, only to attempt updating it
         later on a subsequent failure path).
    
    This refactoring removes the confusing iteration and conditional updates
    by leveraging information that is already known, allowing us to directly
    calculate and update the folio statistics upon a successful split:
    
      * All resulting folios have a known order: @split_order.
    
      * The number of new folios can be calculated directly from @old_order
        and @split_order.
    
      * The folio for the next split is easily identified as the one
        containing @split_at.
    
    This change results in a much cleaner and more efficient stat update
    without the complex looping logic.
    
    This commit also includes a related cleanup to the uniform splitting
    logic by removing the check for split_order != new_order, as this
    condition will not logically occur within the expected flow of a uniform
    split.

>
>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index b2a48e8e4e08..46ed647f85c1 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3528,9 +3528,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  		struct address_space *mapping, bool uniform_split)
>>  {
>>  	bool is_anon = folio_test_anon(folio);
>> -	int order = folio_order(folio);
>> -	int start_order = uniform_split ? new_order : order - 1;
>
>I would like to retain this, no need to inflate the initialization part
>of for loop.

Sure

>
>> -	struct folio *next;
>> +	int old_order = folio_order(folio);
>>  	int split_order;
>>  	folio_clear_has_hwpoisoned(folio);
>> @@ -3539,18 +3537,14 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  	 * split to new_order one order at a time. For uniform split,
>>  	 * folio is split to new_order directly.
>>  	 */
>> -	for (split_order = start_order;
>> +	for (split_order = uniform_split ? new_order : old_order - 1;
>>  	     split_order >= new_order;
>>  	     split_order--) {
>> -		struct folio *end_folio = folio_next(folio);
>> -		int old_order = folio_order(folio);
>> -		struct folio *new_folio;
>> +		int new_folios = 1UL << (old_order - split_order);
>
>nr_new_folios is better.
>

Sounds good.

>>  		/* order-1 anonymous folio is not supported */
>>  		if (is_anon && split_order == 1)
>>  			continue;
>> -		if (uniform_split && split_order != new_order)
>> -			continue;
>
>This is probably dead code in my initial implementation.
>>  		if (mapping) {
>>  			/*
>> @@ -3573,19 +3567,12 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  		pgalloc_tag_split(folio, old_order, split_order);
>>  		__split_folio_to_order(folio, old_order, split_order);
>> -		if (is_anon)
>> +		if (is_anon) {
>>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>> -		/*
>> -		 * Iterate through after-split folios and update folio stats.
>> -		 */
>> -		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
>> -			next = folio_next(new_folio);
>> -			if (new_folio == page_folio(split_at))
>> -				folio = new_folio;
>> -			if (is_anon)
>> -				mod_mthp_stat(folio_order(new_folio),
>> -					      MTHP_STAT_NR_ANON, 1);
>> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
>>  		}
>> +		folio = page_folio(split_at);
>
>This is where non-uniform split moves to next to-be-split folio.
>For uniform split, the for loop only iterates once, so this one
>and the one below do not affect anything.
>
>A comment above this assignment would help reader understand the difference
>between uniform split and non-uniform split.
>

How about this?

		/*
		 * For uniform split, we have finished the job.
		 * For non-uniform split, we assign folio to the one the one
		 * containing @split_at and assign @old_order to @split_order.
		 */

>> +		old_order = split_order;
>>  	}
>>  	return 0;
>>
>
>Otherwise, looks good to me. Thanks for the cleanup.
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

