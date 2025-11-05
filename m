Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0819CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3988C8E000D; Wed,  5 Nov 2025 04:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3705A8E000B; Wed,  5 Nov 2025 04:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286828E000D; Wed,  5 Nov 2025 04:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17CF68E000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:15:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A00CE13A071
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:15:37 +0000 (UTC)
X-FDA: 84075995514.16.B9CBE10
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CC554000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:15:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFznvZMd;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334135;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRKYAMJbZl0KZC7JdmAy2pr59Vv33ZSOQwC9YmM6cQE=;
	b=s0GYU1DDfM8wj4iOPjbpO3CbQyYzFxBCEOMdbQTemKO6mWADv1dUfYeawd1N7ZNdF1zr2o
	kyY51W3C1neEEJUcVMrEsgOm26b5en0Q0O33JK8TVacxGZxzIBDdBEhFB6oeruRqghhIwM
	pNIld4hDhfhm5P3tyTFm9zw9SQJCen4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFznvZMd;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334135; a=rsa-sha256;
	cv=none;
	b=co/oI1y8/9ynAqi1JlMvvxZ+lr+Sl4vK+WyjNexgctGWoGugSjSVix8CnhJLg6uTPm5FXa
	a03TPmT2oJnZkUjt9oOFTJhQPXDuzSWm0FX9JniNtcIduHAMld/8YErY1hA4wuWSJzbmM+
	5YS1XCj38m94a57fmnXI8cWM+4FAZ4Q=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso1131249a12.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 01:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762334134; x=1762938934; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRKYAMJbZl0KZC7JdmAy2pr59Vv33ZSOQwC9YmM6cQE=;
        b=lFznvZMd06XmijmoDeIUZUhu/ypZn+C/O+L3zyPIqXy0g7kk3bcLTu/f5EZYLLl248
         6zd0dkJpUfOAQtRlttuENNIbhCw0Q6p12eYM3JOorEg1JROPhzTqeL7Gy128PyyCrv1h
         tMo88Dj+18HE3T6mQKyqWBZ+k2aTfHsHp+xKq1+Wyjay1MIwY+uXSl6oxOf7c93yMjz2
         t+d5/9ayXamlYF329e2WWLNtSvPK6eaGJCAKEIlUUr3I1IzwL2hxs1bOFPUpW+GFf/sc
         +7eyT+RttmRbBfA2jJs24fdOXDfJmL/OZOhhxNOFeE7WtpyHSa6r5qz8VOCPIl5S1ZNS
         FlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762334134; x=1762938934;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YRKYAMJbZl0KZC7JdmAy2pr59Vv33ZSOQwC9YmM6cQE=;
        b=JPUMANZbYS7nb3b3k0d7xGL0i0LQai4keAw1f3f4p0LH2H4CMYvcuhH7KAU6joCO7y
         QO4xTRiWWd+lRHM2DEZn58JF/7GzC6JvrJiFMOo1pNmljY8oGK4hQVnl2JI3aV5NuA+y
         ChKSYWGQA9sxMjbjcN1h2Tb9lIDQguKl7YIhGYaCauejyjQvpbv8vDqf8Ne4A69WKxNR
         GmWCysBx2tOkp12DfbVMzZwqwTbeltc0D2KJtpSWArbeK1GgaUeWfAqBZHQONmhzB8YU
         BW1OWgerEfVElxOJYS9WExsxCz+3Uu1hlYZOoo+y+XKq8yqHiaBbeZynK9qK7DJjAz4M
         q4nA==
X-Forwarded-Encrypted: i=1; AJvYcCXNIw+iXKsgjQhob1qOJXs7Jr89+NnIZFOt4s0It14UUC/rmDgPE+oeRUx1uVfDj4OzVKBwc6+MeA==@kvack.org
X-Gm-Message-State: AOJu0YzZQ270o3Ra4BK0gIFtyILNbGogGWU3dlPqyeVau5Jko/91zRmU
	XLgCDX3FqgA5hyldsPv5JYTR9oMLwcA73Ljd1WBbR85G3u5gRwASqBXI
X-Gm-Gg: ASbGncs+z6zHvq+y6jM63kZ8GWmnhUhBgVpy7FV1phIE3TsdBiRsfEygQ90RC+S2G88
	HzOE1v9XV2iAzUaIadSt3E9S4nbgNAIV4pww8K7A1lAoAHUYOR9Plu0JOwl6sFXWR0l4Gmvw6PD
	ZEtyKRQPlO7t7EDpu+8VreN/uOmP2PwcEewOQRAi5XE7ItkxUZjgmUCAkACR6QD8TSCU+od4bD8
	MV0HtqVtmXBMl+xryFy7Zegjxr8ETL9yeesG/wjI34UFLcmOW8i62G1sy1WI0ZlIT+LyCG3cP4/
	UIpBPaNhmLiC/6v6kxjLar+a2GvnLE5GKdT446a5rDaz55V/JR6uHKDOR1nAd4W88ZjOZuVQVPi
	Kkby+9NoYTQ3ZKOstsitP0C3Q2X0lG2RmmFvxvZKkgoDQULqHN5FTeMGAZ97/mkPuiViHcy7XYZ
	o=
X-Google-Smtp-Source: AGHT+IFnww3Rslq2YJ/Q9ZgOTxZB+wnHR9GlR+sddp6kJVrT9WI+n3x/xjaoGOsuZhQmg73qaQPlig==
X-Received: by 2002:a17:907:94c9:b0:b72:7a86:e497 with SMTP id a640c23a62f3a-b727a86e579mr35131166b.5.1762334133820;
        Wed, 05 Nov 2025 01:15:33 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e06f8sm464434966b.38.2025.11.05.01.15.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Nov 2025 01:15:33 -0800 (PST)
Date: Wed, 5 Nov 2025 09:15:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251105091532.zns677dyv436t2d6@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251105072521.1505-1-richard.weiyang@gmail.com>
 <dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9CC554000A
X-Stat-Signature: fsmpsbgsnojzcgt3qr99k7ejf9cwemni
X-Rspam-User: 
X-HE-Tag: 1762334135-960681
X-HE-Meta: U2FsdGVkX19cS330Z+GB5Kufe9vz2E72fkosTQnf0lhQMgg42Yts9VGSF8qDwUNZinhirEdyghJgTDE29ENM6TdVyuMRfk8dg2SXBGNxEBmZvG+u65w0cno2zANjURfpZyhR6dpxutsu1qyDrbt7g6ut7VvTmEZqgZ3UPJ4N0isCw5X0CqTkqi1L4KNSV2RN+dy7PJwPMQSexMrBJsmAJqGhPtkSy0adIei4XzomaDy5FhdNUTz3S41FzKkOKTa3F9UQou3DGFbfr0k6QHAA/Nm42ucMebsP223n6zt36xZhvce0MvfUnvkL+wKodd07ue3bVMGELSDEhui9/SnYNgtTTdqA+fH7IhPP7RAYJS/HVV+QzOvRpd4NIzFK+mUyJUpKWwW0w/1eyYaTb6m0iNhDnn1YqjVL2DMsVV67P99o8ItyJxENPm/r60yMATGu70+nCM1VOyr8KawcrNwGggz2DjNgNuBXepcNZzil6Wv0h3wzKXE0lJb0Hl5rwarnINyeOGEPvySlAdG1/xGflfofb2qQ4CgYz5PNsZHco4Z2ykA/RyJ2ryDCzxp0APZN4r7XhWcFDMTAldJnjJuc/Xd+afB1brM9XwDqUNeO8l5UivmRIbUnG1BxsLaEmJ6nViQiwrkjkOrhaepRv0aheOtyBGVwVudcFcNn4dKz2ds49VC5iYYGjYA5hDFm8FbsGtEe6gEjWlbsOIi79tQZFnAst+Uiq/Qd4cov03bfOFlwTHf5Ru+fuIZiEJjOCezU1mMJMeEPrlHI5+4oZ6l1AgbN6H73NRazQ6zuUCX4tgVHjdoHgGh7DElk7M8FJtIVd+zGzhYHmsVRwXtrtl9sKMdrpKyUNFXzCQXE5jd/lXhiV8yTUKvwvmkLt9iqXz1Fajmg4PSYr7w8+M4o24LM0jJSn3t6rTnAuTmc5y8G6wtrqey0TOo4i9U4gO71gtDhoZrPyRUYxwdKkZI19II
 0gz/Yi9T
 a79PA3eS10M8j/rMSmLsBL09W6bWrj3GfxanB1I4fXi8Bkg47qNLGcEuRgL0q8m/b7afd67ym1WcT5lka09c4cfyYHhidoD6drmBTgDlvXpDTAt/pBnr8duKIkx3KMfiXwTHMAh2LuniyzzCJ3Mlz1aP6iJatKVtrXjYqIjb5Qb1Bs0+eVhJmYG0PviyHnJ35i4NWnJk7Y/n8pS3S3nxckdftlLhjfrMdbCVIVVC+M10MUKxoJZHr0555W67odQiP8gIP9TwpD1ioXe9U83XLN+QOE45o9Du+/6ZyzBesNZ33Rr7Teh+CbleffVPtNT+HmOWwFeZIGbfi5voUoYK37xYRP3nsQUOSv+7fKr5RJE++i8FUS4yWv5nA52rBY1D48vSr6nGF/KANsXYS9SL8kLx0f6wOyTwbAPOh68CxspJoi1TCC1voXlF8Kfg9FNmmyuh/Hns4+ql82phDum21BJobh49ErxROdNnttF6OtORgdNog7JZ81Rj/PqCa3uLC6ny6QP59rHGpZfb1DlEB0aAbECPPZ7ftLLlwMmaazw2WENFgyaHe6HUX5ICT7frkpPyhR9rDZxy8TKKJFIZpXN+o9d4iM8OwDIuiS0mZd4s4FjfDuXBG1J993wKYv8sB6f59bCdUyxR+VhDjIxFmGO1w9TJjgxvOZqFdsbW9tHNvdDLDF03wbn9Nb73o1tkA2QyZpr+wCQO3vu5DBak2dSVvK89EXf8NHYh6GTvQkvmmPrd+Jhuy5VM503/5ZraioWywJZi4l0Ui95ScqWxx38JJV2i8SCh1tpJzwB0addWemGMCh8m/vGPsZsdt8561/VcC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 09:05:31AM +0100, David Hildenbrand (Red Hat) wrote:
>On 05.11.25 08:25, Wei Yang wrote:
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>> 
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order.
>> 
>> The reason for this check comes from the following two aspects:
>> 
>>    * some file system or swap cache just supports order-0 folio
>>    * the behavioral difference between uniform/non-uniform split
>> 
>> The behavioral difference between uniform split and non-uniform:
>> 
>>    * uniform split splits folio directly to @new_order
>>    * non-uniform split creates after-split folios with orders from
>>      folio_order(folio) - 1 to new_order.
>> 
>> This means for non-uniform split or !new_order split we should check the
>> file system and swap cache respectively.
>> 
>> This commit unifies the logic and merge the two functions into a single
>> combined helper, removing redundant code and simplifying the split
>> support checking mechanism.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> 
>> ---
>> v2:
>>    * remove need_check
>>    * update comment
>>    * add more explanation in change log
>>    * selftests/split_huge_page_test pass
>> ---
>>   include/linux/huge_mm.h |  8 ++---
>>   mm/huge_memory.c        | 70 ++++++++++++++++++-----------------------
>>   2 files changed, 33 insertions(+), 45 deletions(-)
>> 
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index cbb2243f8e56..79343809a7be 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>>   		unsigned int new_order, bool unmapped);
>>   int min_order_for_split(struct folio *folio);
>>   int split_folio_to_list(struct folio *folio, struct list_head *list);
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns);
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns);
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns);
>>   int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>   		struct list_head *list);
>> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>>   static inline int try_folio_split_to_order(struct folio *folio,
>>   		struct page *page, unsigned int new_order)
>>   {
>> -	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
>> +	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
>>   		return split_huge_page_to_order(&folio->page, new_order);
>>   	return folio_split(folio, new_order, page, NULL);
>>   }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 381a49c5ac3f..db442e0e3a46 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3666,55 +3666,49 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>   	return 0;
>>   }
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns)
>>   {
>>   	if (folio_test_anon(folio)) {
>>   		/* order-1 is not supported for anonymous THP. */
>>   		VM_WARN_ONCE(warns && new_order == 1,
>>   				"Cannot split to order-1 folio");
>>   		return new_order != 1;
>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    !mapping_large_folio_support(folio->mapping)) {
>> -		/*
>> -		 * No split if the file system does not support large folio.
>> -		 * Note that we might still have THPs in such mappings due to
>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>> -		 * does not actually support large folios properly.
>> -		 */
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split file folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	/* Only swapping a whole PMD-mapped folio is supported */
>> -	if (folio_test_swapcache(folio)) {
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split swapcache folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	return true;
>> -}
>> -
>> -/* See comments in non_uniform_split_supported() */
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> -{
>> -	if (folio_test_anon(folio)) {
>> -		VM_WARN_ONCE(warns && new_order == 1,
>> -				"Cannot split to order-1 folio");
>> -		return new_order != 1;
>> -	} else  if (new_order) {
>> +	} else if (!uniform_split || new_order) {
>>   		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>   		    !mapping_large_folio_support(folio->mapping)) {
>> +			/*
>> +			 * We can always split a folio down to a single page
>> +			 * (new_order == 0) uniformly.
>> +			 *
>> +			 * For any other scenario
>> +			 *   a) uniform split targeting a large folio
>> +			 *      (new_order > 0)
>> +			 *   b) any non-uniform split
>> +			 * we must confirm that the file system supports large
>> +			 * folios.
>> +			 *
>> +			 * Note that we might still have THPs in such
>> +			 * mappings, which is created from khugepaged when
>> +			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> +			 * case, the mapping does not actually support large
>> +			 * folios properly.
>> +			 */
>>   			VM_WARN_ONCE(warns,
>>   				"Cannot split file folio to non-0 order");
>>   			return false;
>>   		}
>>   	}
>> -	if (new_order && folio_test_swapcache(folio)) {
>> +	/*
>> +	 * swapcache folio could only be split to order 0
>> +	 *
>> +	 * non-uniform split creates after-split folios with orders from
>> +	 * folio_order(folio) - 1 to new_order, making it not suitable for any
>> +	 * swapcache folio split. Only uniform split to order-0 can be used
>> +	 * here.
>> +	 */
>> +	if ((!uniform_split || new_order) && folio_test_swapcache(folio)) {
>
>Staring at the existing code, how would we reach the folio_test_swapcache()
>test for anon folios?
>
>At the beginning of the function we have
>
>if (folio_test_anon()) {
>	...
>	return new_order != 1;
>}
>
>Aren't we missing a check for anon folios that are in the swapcache?
>

Hmm... haven't noticed this.

I need to do some home work on it.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

