Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6845CCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 14:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27178E000C; Wed, 24 Sep 2025 10:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE758E0001; Wed, 24 Sep 2025 10:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14E28E000C; Wed, 24 Sep 2025 10:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F61A8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:59:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54E39BBD63
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:59:07 +0000 (UTC)
X-FDA: 83924451534.04.99A8AB7
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57EA1140004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:59:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctuxQNHA;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758725945;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJ3VOvLLjDNAqLGJMWsio8p4fIYlLa29DcnArXmGIf4=;
	b=yUVILjJeRdz7/KsYVeKulswqZhy8qrUdJsTsNJKEKdg6qki2sG3oPcOsiwjIq5Web26BB9
	opB++ZlUW+LBKTf7MMDiiIiaHOmCWgLvESARpS41rnyBDyGN2zcGf7BktDI9pSfy9tAR+Q
	VbUGBP/W4OVk+1Qa7ZFulmVWoqI6dJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758725945; a=rsa-sha256;
	cv=none;
	b=1feWBCG1enperBPHk048WD/RLx8zAbJa3rlCu+Jx0ZFsf/yQ30s42cGGRr5YzIV/OyVonJ
	UlidWHxsAyB0+GrQnHFe/53f7smx2sx/3PfGdd0zUkT2udzYt3nWKf9eHCWikND6R7QoGQ
	GDmqGLPRzU8oH4p9sVXWuHLbI0X+C4k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctuxQNHA;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62f24b7be4fso11772611a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758725944; x=1759330744; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJ3VOvLLjDNAqLGJMWsio8p4fIYlLa29DcnArXmGIf4=;
        b=ctuxQNHAfOJ0o34mW9M8plHFTsVioM9dQwmeThGvQyhxJnovdRWlTjXJGs5lCmATw4
         AoI+l6K8yRA+at46HVCS16FQEue1fK3UKEEAvWxpgzVYgpnsPP6dbkSGf2bjs0Tk1sVE
         LBABa1ubU/OIk6wOSMIKBuSv7AMg5rJkj9mclAXK0igE8/bPvXtCgk4jtjK6Xjgy6/iV
         NcKHF11NAXy/z65xZBobVqQ22jo2M9BpVfo7Qhzm2N4+Q2q/sP65dvtv9X9Ng3ephPSQ
         2jXrhTXv7DXcFi5rC6J0dXDLStO7SNG8Zrtz25bnGkNUAcsT4XGTdYnpDwnJb7Y7SDaq
         pa6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758725944; x=1759330744;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJ3VOvLLjDNAqLGJMWsio8p4fIYlLa29DcnArXmGIf4=;
        b=jdo2uk/ILqqtyKL6bRIrEiIB/Tpy+PyOX3z6Or5EfZ9NaBqT6BOfStYg+DnzJ/HZ4c
         SES/qvjg5w8pB5UPBAD3JcFhfjWtKrKyxZNkeOaD29yOlxg7/dDuFJ60suhb0VqmcNwo
         Oi7fAvNxURAW6Ur/4UiGApfkSD0LhQMHaGzLsKSo+mw7g4yhMHl3UUiJDlqhiVNoga0i
         RiPPiTg/bR+4EaUQwQkht+sJ6BmuXaEeys+E+8obU68KUdzkkHA8qVBQasxgiPYfG/Qg
         3TKRTxf6YAcLDADSlFuHMmiunKHtLtuuPbv3p3V/wZnwTKqob/ibJBjE8erAtnIPjHDy
         2XtA==
X-Forwarded-Encrypted: i=1; AJvYcCWgPpNRz+9u7g23kjr7ilusZhCwTGop6LBDuDi3+dIlBYJzSej5KyFqlxZZ9wam6mE5fI6tN/8sOw==@kvack.org
X-Gm-Message-State: AOJu0YxyylU97EH1iYRYmIIbrDNl0+3zRrFCodUYbqn0uljk9wLlHt7y
	foZuD6Rg7hIuUXpPN+Aurn5Ggt11F5tYJdpay6MUCb2nap+Ua/6sjV+L
X-Gm-Gg: ASbGncslLEnBr9rsPByyBTmmdPZfgGvBiYSEbYCn6uevbFM22RPT2cg2pr3HjifMNxW
	TaeH3hD1wO+fU5ox4/PBgDPYQBS9/8MBdM0OqSscFBmaka/QIIgGs8lttQlPLvqH5wtTNJ15GXP
	2LQwMAhEj2mRKMauofW51ypXLwXVAimaMh2oHnrP7g++L+jcjkzJOc3POfnfyulghXw+FFgEN+q
	OCO3xSaraGOgpmln99ts02174R1b0xo9SjxIMztYweBBRBlCGVyIJa96CLzmU6OQZnRDJ4r0zHM
	Nm3sIcFcRc93sLoCJze79ViA+5nyKVlJeLV3Orb0ZTKB42QPVjCqtW0JhVn9R1v1l06oxCAGogs
	qqv5nJa7K0mHJ9PsaqKkQfFMz8YBs9XrM
X-Google-Smtp-Source: AGHT+IFUEoon2Cj6F02r4UVc7mYTfVy3/O6rvLSzlzsoqhmylk48LNP4yXi0yb8fVjNGBOE6htWliw==
X-Received: by 2002:a17:907:3d91:b0:b0e:d477:4961 with SMTP id a640c23a62f3a-b34b8d96245mr14623966b.23.1758725943475;
        Wed, 24 Sep 2025 07:59:03 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fc5f382b0sm1591218966b.2.2025.09.24.07.59.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Sep 2025 07:59:03 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, linux-mm@kvack.org,
	Kiryl Shutsemau <kirill@shutemov.name>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [Patch v3 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
Message-ID: <20250924145902.ew5jtskiehuycgqx@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-3-richard.weiyang@gmail.com>
 <1d593bac-0d9a-4cc5-8002-932e4ba88edd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d593bac-0d9a-4cc5-8002-932e4ba88edd@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: fqji34sbnaofo6crxckta1g64o7c8no1
X-Rspam-User: 
X-Rspamd-Queue-Id: 57EA1140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758725945-285210
X-HE-Meta: U2FsdGVkX191ztayDfuXfMCO2FltY56ThMKFwYfL97LByJwWwKITGc6w0cCSwEp2jo0ZbNgIpgbidqmNjD8HPFzbYCZQFMBzsNSy6wPiv319t0kd9PB5o9DsgNdlGJKv/t2zoc5NAWfbviEhlpM4LF2FAzOCVXZ7+uYFz3W/UYRQVd1X1iwhHnFVvkxpl+3AO00E+OOGhECjPo//pxEDuXYSjqMHsc1AxpyGWd7Jz/tzN8Su2L2LE3KVcqOUtxSDdFgBMoD1K8bc9gcIgDnqxsb1iPaDBPunwWhkI5SgnxtS8sINUzmvaGa8whKQY5A+oqFGIaIPZ3ify6dB8CZIWyc6W0TgCohtSvcH6ySw61YlPFSYpOt54+ZX116VAjHGbMEYQvsWX/yeYBNO64AUYADDQmFia+u1kl/cbiA53Cnv7qq1T2aM7LdQBhyu1iv4jlkbe5mptEI1KgKnhMrZdFTeXb5n3AP6U2z7K2NgcIsGjfCbwFI71rlR9sItv+44om+em0LlD7o9xkhZmSmSTKWTtjaLrBEo1IWwis5D8W8hXwvXGqRrq0dqtBjnHWrov+6qGYvb60G8F3fHjgQdlUAtuJKQFPNuUPNKmcCtLmdRbIEb+3rYcw9HqNwIVQATUx1wi7eJ272LVcoBooWRzVYh62L2laR0zEoJMNnef5VsXOb+MhQSh1qyO+NkTWgEDyPWboaR0YZLDy1If9ZArX+FrIutfUQbXVBunYg6rIY/qcLHcOTALiIdwRlaywGFKO6QKMpTtHfHTuvwYQ+sAC8pJk/Z+/fpA/+KH+N12NxZuIqCmvY/uiISqEiMT/4LrHfHHxlXeULPqBXdBwd9T3NcZE65/1Jp/PCBurFMDZB7Ok8BlFU9l+vxZHczK5hTZtVs4lbN81NmBmxP21hpKZG7GgpDk30Kf6c5eLSet+lRxE60vhZp9kcJqBirrz/dB5gNaDBIANqiOXuxdXD
 v63vkFQF
 HYdA8kputLlESdTL2Y6Fpcxy9hh7XnXQ4x3sGZsLiMkLUTX9FJ9qYeHgHuHCpqVqz5c1KR4BbZ2/PhiTIEWFhkMUoo8cZ2ln1UdecSwGwEDdXM1vIR/wwUs5ZLrh5jFjP2nVN+LrB+4Rt7LF08fufNymWCNfkipMSZfl3SgimTVDD62jwvQpTUUN8ErmQJatVe1WEGr7wJBfDhIhJoMyhZIrCOW3mNJFBXdSE7H9ONswT/Mh9PdI4YUWhWvOyPDugFOsoJsOTXDG6PX190Tbb3LXdPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 11:39:44AM +0200, David Hildenbrand wrote:
>On 24.09.25 02:48, Wei Yang wrote:
>> Current code is not correct to get struct khugepaged_mm_slot by
>> mm_slot_entry() without checking mm_slot is !NULL.
>
>"Current code calls mm_slot_entry() even when we don't have a valid slot,
>which is not future proof."
>
>There is no problem
>> reported since slot is the first element of struct khugepaged_mm_slot.
>
>"Currently, this is not a problem because "slot" is the first member in
>struct khugepaged_mm_slot."
>
>> 
>> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
>> is no need to define it.
>> 
>> Remove the definition of struct khugepaged_mm_slot, so there is not chance
>> to miss use mm_slot_entry().
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Kiryl Shutsemau <kirill@shutemov.name>
>> Cc: xu xin <xu.xin16@zte.com.cn>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Nico Pache <npache@redhat.com>
>> 
>> ---
>> v3:
>>    * fix a PF reported by SeongJae, where slot is changed to next one
>> ---
>>   mm/khugepaged.c | 58 ++++++++++++++++++-------------------------------
>>   1 file changed, 21 insertions(+), 37 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 204ce3059267..e3f7d1760567 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -103,14 +103,6 @@ struct collapse_control {
>>   	nodemask_t alloc_nmask;
>>   };
>> -/**
>> - * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
>> - * @slot: hash lookup from mm to mm_slot
>> - */
>> -struct khugepaged_mm_slot {
>> -	struct mm_slot slot;
>> -};
>> -
>>   /**
>>    * struct khugepaged_scan - cursor for scanning
>>    * @mm_head: the head of the mm list to scan
>> @@ -121,7 +113,7 @@ struct khugepaged_mm_slot {
>>    */
>>   struct khugepaged_scan {
>>   	struct list_head mm_head;
>> -	struct khugepaged_mm_slot *mm_slot;
>> +	struct mm_slot *mm_slot;
>>   	unsigned long address;
>>   };
>> @@ -384,7 +376,10 @@ int hugepage_madvise(struct vm_area_struct *vma,
>>   int __init khugepaged_init(void)
>>   {
>> -	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
>> +	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
>> +					  sizeof(struct mm_slot),
>> +					  __alignof__(struct mm_slot),
>> +					  0, NULL);
>
>
>Just wondering: do we really have to maintain the old name? Could we instead
>just have
>
>mm_slot_cache = KMEM_CACHE(mm_slot, 0);
>

Hmm... I am fine with this, if no other objections.


-- 
Wei Yang
Help you, Help me

