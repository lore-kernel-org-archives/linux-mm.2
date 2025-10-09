Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36E6CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 02:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB438E005D; Wed,  8 Oct 2025 22:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B27E8E0002; Wed,  8 Oct 2025 22:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0488E005D; Wed,  8 Oct 2025 22:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E41E8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 22:08:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2B6DC08EA
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:08:21 +0000 (UTC)
X-FDA: 83976941202.09.A95F734
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6A07C0003
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:08:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IrbcZpJs;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975700;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkFdrJrfAH7dWQbm8FsVmXopTEMVHao6capeACrWuQc=;
	b=Om278r7vizS5bj3+adJDfHWUGhdLrErKIgt4prS5dxvBTqTDjwGLTUVvtYlC2pTNlYxS19
	+52aHsLvEzezUlq5TPZ8MmYJA61zvvraON4YgC37smYeOwSRd4ynWCp51WKOz9cSrUh/km
	s1+3bBZ/OgiWsxZbISYbZ54J5jWuYq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975700; a=rsa-sha256;
	cv=none;
	b=1ORzamryBbuVqXa13oDLGRzo1UK1E4GRiV1uTmUKxz322IumNS6rAyXdCp4RZSfp8+522o
	r0Lu5YvrJbYgryk2gcls8xkrFAeFkIocjkYte/6vKfxZBL4udlvtNxoC5Ddnlr3NmoRAIu
	QvKLF45Zn+6wxCiY7HR5WBFBBr/rso0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IrbcZpJs;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3b27b50090so75928266b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 19:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759975698; x=1760580498; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkFdrJrfAH7dWQbm8FsVmXopTEMVHao6capeACrWuQc=;
        b=IrbcZpJsB0+aqIa6mIUoPnLIiejypfkFVTefPuyVHYjMSOfzz6xYPBddRKa/m8+MV9
         58HIwSI0kavi6xt7K5SxRQt4h3bA4D3BscrRrd5BYgr9nb/gZ/3qEIaQfVuNhcv+ST00
         YIA7zLWo4KxPeDhF9DDioRkrAaA1xptZs7Yppd/4IoNjkbzc+y8gcmeIFP6Sc1qBTSuA
         8rFm9WpaAImYCOiMaXLc2XSf4CbPMFX0nZF0OrSKiclsqkvZk64Qu+xIQiTcgwql2VL5
         Fw3CP6V9IBuHPoVQfk5LxBAlxWQg6M/fbA71E4QX3VJn0/POaCqH8BE4aWyjILfLw1LG
         MMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975698; x=1760580498;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CkFdrJrfAH7dWQbm8FsVmXopTEMVHao6capeACrWuQc=;
        b=CDG9RIIAyKArNxiJ0GWZaEZWSHVhoodSNH4iD9uy/3yiB8kj8pKf3dzC0By7NEQ9rp
         6BsTo4BPX82A9WUQ9pDpay6UI93rc5mTesXpv8K9jH0XJct0u64SlNTlFx9ylQwBZsc6
         0ye4Jt2rKgg1jWSn7VBIxVVdyH834S5/Db/M49KaHMz6Vv5pyB/7ZddqErA29FpQ7NFP
         qETFLuvXw5rOtAhGeNrE2m/MfXGnumFpFSHBBSWBQ/MacfbykC8JtEUrx4Uk366a1EbE
         MSQqNANNznO5RshHSQpwYeg9+FrZrMWqhnTvm7NTLSE37FolVOU8xHqoGcqABSnNbTu9
         RFIg==
X-Forwarded-Encrypted: i=1; AJvYcCVzj1TZn/a8D1nf0NpchaTq9NUVFHH1YMjyBkyddQSYKyJXSRM1D6ITY7tCPxrdEhr2oBeSDSSncA==@kvack.org
X-Gm-Message-State: AOJu0YwdQmCdXucUi80jEhyCD8ZCiDYTcDpNYcVWHZ4TlS+YxImYVXyc
	AGMqJbRmrvsdWvzdIGPibG3eSQQQPiCa6W0hmAWe/Ut/eJRHSx4Kt4JZ
X-Gm-Gg: ASbGncsMauZj0d7YQR0E49fwr6eIgINA4xpnVvzDyo+/GygjAkON5eokbkXw9tFTDOF
	YaM/kNCm8dKe2rD4hmgPoSLEtIRwj5lXxjVbf2wVPStsj6g7W0e0XzGYGQmf2VBUIqvT+Eu/QoB
	v6mk5eFhbd26njQSSYJ/vbKzu4LCP7/ZNPKoY0OhovbvwmqU5yBoZWUlt1Xa3OJuCVzWU0dNCyw
	fiXwquF14l3To0330cm2stjKCrRuI5NqtTEE9kao6HOOGpYbePQokRidGSJUwbVfP9K2lnW+oUv
	/3W1RBjj+OZczX5Kl8SxMd/7qFP8b1FLkP19YLluTLtcVC04FvjnSv4BElBqH/xki4BH9S/4oxs
	5fvjRD+wshZYgJWrqYSg3GSCrJmxA0FeadJjMvj31Z5sAoA==
X-Google-Smtp-Source: AGHT+IFjxf8fE271dv6+9bqGK9gnl2ayJZ6lC7iSTYsGqUlnQ0ZUzknc8Nx4Zy0/eidOyD9XTBxktA==
X-Received: by 2002:a17:907:728c:b0:b3e:e16a:8cdb with SMTP id a640c23a62f3a-b50aa48c4aemr631958066b.12.1759975698215;
        Wed, 08 Oct 2025 19:08:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4f3c7e057dsm630852866b.88.2025.10.08.19.08.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 19:08:17 -0700 (PDT)
Date: Thu, 9 Oct 2025 02:08:17 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/compaction: check the range to
 pageblock_pfn_to_page() is within the zone first
Message-ID: <20251009020817.y7ji6wqhrv44h5uz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251002033140.24462-2-richard.weiyang@gmail.com>
 <99824e33-bf25-40ef-b969-a48e3b916ad1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99824e33-bf25-40ef-b969-a48e3b916ad1@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Stat-Signature: bs9x9grzjehtj3h9yykfxcoo7cznjiy7
X-Rspam-User: 
X-Rspamd-Queue-Id: D6A07C0003
X-HE-Tag: 1759975699-398693
X-HE-Meta: U2FsdGVkX18rnUEGFBWkGKItpzR4cHbw+uRf24kvYpdBeuC5tH+drXMY0qOnH11tDtirDsNZjqxW+pTpvmin2tkXoMwGzvgfH87SLqkTI+a0q7zlbXOiQtGPXjBElkhV1k/0r6l+BYbY4xwo93QrPdMEOk5nmV+wzBgzs06dcPbexSLdkAwtRpWcwX3AGL56FnYFHik8tdIo6kZnJ5yDT8uyvFuHCfABSA+ESaDcGO0NE2ElYaRMpXvpEod/avGpmD0qi/xLGHSHNysjn57rRrI8hKE2RPLbf7mTzbwywJ8Ux5ii7sxFi6AwsUTrNi/pmriUsQt2eGXabhdMtM/r+HrPTQnglyDy+j8eOt1wF9WuFI4LCQyKokl7iqFA9J0PQTt+rwHGgoaYmdlHvE6ItZKGR/mwrgpvzdlYXHxN42Ruiy4DrncxIxEEcjlRKfFbY3M8m27Q+SGBrpvy3UiKJz0p4Qa64jLt2TcLOBwSLO5XlzfJldDlkt+gY5tQVv8MELAdq+DxBCvM6s6GRqUkHLtXoel43Wc22uGS6Usu+HgpNFZkB6WkQqRsNR/Pcp+cfCjvKNw6nbpLcJRMlAAmIBP3AhTBSns74XDVVe+K0Hq6UFumxHnqrmp0f8mn883Im1p/eMI6P8uL+UEFWe28oJlzc9FUPF1u9XON+Se4QUyBzMWIC4zjs1rwr+THLTb9Lty55aL3BXnZy7aMng/EHavEYyNloJzUpfXVBa/P+OgEcwSb6SLpZ+MvhbNcamfz1H7V+odN2LsEGPuiZ9eNoZ/j/TMkP2COmdDvRSXp8Rnu4Kj3fd2+L8reMPL87ZYMwaPch1kO8CqPQH6d1pEPn0ZydeJa4bxy9uGnwt+/sKdU01blqfjhWpwgIQusqS+T26a6iUNXnYMW7P6+D/v8k5qX1cBPLtopX9P8Q+rmLC//stGzC1bav8assk8i/FNMAgLfoxaTbYadMdwTQ5T
 NufiS0Ud
 MsMYXp69vsmu7NIG5CgvIel7KIiwbPVcW6rMVJhOvrY/QTOErZdpXZhlboK8S5ImSf50eEuen7pXfbwBXK6wA1GZdf7wjVSnDj4v4qfHe4PvrFMoLhHNAKte+fzZYMi+jZZ3Ggml6Pa0xil2dpKHJNOu1WilWLxY9Tynas9e4Sn9a0Ym7Ks4orhs+CKYmMjWGKbNqFbKMMHahqHzd/lUl+DzwTy7EWf+rb+fVqR5s/DQiKYXvAq/yzIii/0RLwyX0usQSVveqwnmpW2Ud0B9Vdp7Rh1vTPbUUzShZfpEQDSfLht+M0McWOfW4NQYaGRpIZDz7/a115QqTFXBRw+ck1ydZuB+ExxuKNMeCYUnVlSAQw0uwIHrssSy4EAOfvVUbAmJ5ir8tRRN7E8Q5Ax/C1dDaGmIS9ENIOQGZXtU3HbV9UjCiYEp6G83lC7XWT0gvFwV2iTOvzliNT5ZlLnQzM/q2aawjZ+XBdiZB6fyfPproRq695OY52k6VvmSyZIEh53oG3e4561zVAO6NIQPWl3DSWuNhsT3utTdATdxogUwEr+xwVr5MpBTaV1ThQTAaSqckPiggJx1C+BbsHYRQMv0hdk1c3yiPJ4oRjwWIlJ9/T3lJ2y03HR3ACV1LNOb3EGmrkt1XXxLMpqZpqRWCwkYg7z7+jfa89Cz/tGl8qMgcPXujbUywJHc9JBoUdkReIugYGZQJKaMufkDJpq/j1BGssaOGsD6/B5JwJlG7DA3VdRA5La9/jZ6fNQx2WGFpUi1+hwnXrZblSBz/+af/Hwlden8TNW28CgCy8DTHKuH/htE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:14:25PM +0200, David Hildenbrand wrote:
>On 02.10.25 05:31, Wei Yang wrote:
>> Function pageblock_pfn_to_page() is introduced by commit 7d49d8868336
>> ("mm, compaction: reduce zone checking frequency in the migration scanner"),
>> where there is no requirement on start_pfn/end_pfn except they are in
>> the same pageblock.
>> 
>> So at that time, pageblock_pfn_to_page() would be passed with pfn
>> without compared with zone boundary.
>> 
>> But after commit 7cf91a98e607 ("mm/compaction: speed up
>> pageblock_pfn_to_page() when zone is contiguous"), pageblock_pfn_to_page()
>> would think the range is valid and in the same zone if zone->contiguous,
>> even the range doesn't belong to this zone.
>> 
>> For example, in fast_isolate_freepages(), min_pfn is assigned to
>> pageblock_start_pfn() and passed to pageblock_pfn_to_page() without
>> checking with zone_start_pfn. And mostly, the end_pfn is not checked
>> with zone_end_pfn() before using.
>> 
>> To make this function robust, check the range is within the zone first.
>> 
>> Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> ---
>>   mm/internal.h | 3 +++
>>   1 file changed, 3 insertions(+)
>> 
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 38607b2821d9..8e1a3819c9f1 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -724,6 +724,9 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>>   static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>>   				unsigned long end_pfn, struct zone *zone)
>>   {
>> +	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
>> +		return NULL;
>> +
>>   	if (zone->contiguous)
>>   		return pfn_to_page(start_pfn);
>
>fast_isolate_around() adjusts the range to the zone boundaries before calling
>fast_isolate_around().
>

Correct.

>isolate_migratepages_range(), isolate_freepages_range(), isolate_freepages()
>and isolate_migratepages similarly all seem to take the zone range into
>account as well.

Maybe I missed something.

isolate_freepages() takes care of the end_pfn, but I don't see it adjust
start_pfn. Or you mean low_pfn is already adjusted?

isolate_freepages_range() / isolate_migratepages_range() just adjust start_pfn.

isolate_migratepages() seems not adjust start_pfn nor end_pfn?

Maybe I misunderstand you, would you mind giving more detail?

>
>Only fast_isolate_freepages is a bit more tricky. It definitely takes the end
>into account. The start comes from cc->free_pfn but IIRC it's always above
>the zone_start_pfn.
>

You mean we rely on the caller to make sure the range is in within zone?

>So I wonder -- if we want to add such a check --  whether it should instead
>be a VM_WARN_ON_ONCE()?
>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

