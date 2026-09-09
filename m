Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12FFC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EE26B00A4; Wed,  9 Sep 2026 06:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF6E6B00A5; Wed,  9 Sep 2026 06:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6A36B00A6; Wed,  9 Sep 2026 06:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3846B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:17:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3C1316016E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:17:23 +0000 (UTC)
X-FDA: 85193821566.19.664AD2B
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id C935740004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:17:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g9v+IJ0I;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949041;
	b=KBRcyaol/Y6eO4XkKBepjLDRk13eFzjbYDgXcr7jtUXeainwpFE0FioOk2tDMj/GJ6+WAu
	5yx9HB/Pa4gAUGpnJL8Sw0YcpZs2/o1qlAiQYIsLhwv1ZoX91ZLHVI6IYIAQjsiuO858be
	zGw/oIcrw14dsUlGKMXeHBjecdo4+eI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g9v+IJ0I;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9TQ0wBr48lwedZK/j5nLOqNZEnam2jeudD0oRNqYxI=;
	b=y+Cr0R7U65GpAEWc0I4wMSBLHeYu4oGKXkHgdS8QBrs1E28KAqmHAvtEgKdJD4UNERw/K9
	34IbmCYZrGPIOBB6TZ4bL7eTo/nl8i2qs64UGkDpRnGQG4dj0Aozpx8McErLL8fFLEafEi
	aIyiLYUbPM7OuxAAxWj7MiHN8u4Xr7w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788949036; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=K9TQ0wBr48lwedZK/j5nLOqNZEnam2jeudD0oRNqYxI=;
	b=g9v+IJ0IzwAEhs00oCH+KdRcDCZAwaG2TZ+ihqKIwPVytuXtaJJJGxOgK+Ku9+pc84bZW5H+rNWmcqd0jaS/ETbcGAkfJQwvb/6+MtbQiKqxu1/f3Heylec1e25OrxQBdpr+ci5WK1QYEXq2HArtXKHmIQpEjGeqBcnkYKccRIY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XAefvwB_1788949032;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAefvwB_1788949032 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 18:17:13 +0800
Message-ID: <7a2b0427-674b-4a7c-9727-8b078bce0afc@linux.alibaba.com>
Date: Wed, 9 Sep 2026 18:17:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/19] selftests/mm: scale khugepaged's collapse wait
 with the PMD size
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-4-kirill@shutemov.name>
 <6ac7ea7d-38ae-45eb-8d98-f626951a43cd@linux.alibaba.com>
 <aqEvyYMGaPiyW_Tt@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqEvyYMGaPiyW_Tt@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C935740004
X-Rspam-User: 
X-Stat-Signature: bgqwkymny3kexizuw6fz8zb7ef474b3p
X-HE-Tag: 1788949039-790806
X-HE-Meta: U2FsdGVkX18F0TIW9sDjimrutdvKb7A9plsAij0da2EzZnmcOSRCaanTTZTaCrgi11UI4w1usKMlxLIjFtv0v5ItuL1k1kNwVTnshUaSJzDT1th8l8nhhKtVrjA+4CMvUKJwu4l8riqy0WrJpEJzUPX//hPu/tbqrd4R3GFsxQZHuTQ28qq2NaY5sqYQeuaMBc6o8GUKGEXn5h0q1JKeN8KSoYOOKH0+4noXH1lVX4RzxI6iomWR+RL5JAGFpO++izYuSc3+wLBaEPXfn6QEl6BS8LEKOsWBvgLGl8R1koa23zDbYupmDF/VLt9IBp+qDlIVWJsGUdLCHsIYOYBrK2bPlG3k8Upq4QaizO2sRQa4mn0toTKtySwN6fTcUXnSzRWOBUpwqxcpP2/LLUFEq0e3dOPHvWtVzRR76Vk912XPGSpuKn0FCZjHyKCtcx04SbXEUdqmpBBH0G0o+iQvslcRL/gucc6KwIlj4+7EQVP/E3yvrDGICjQQHdKkEdy/KjMxg/fwXghodf4xRUaYiQAhd9+IePwS/JYspweWki4ZkffMSsU90Uh0ZtrOZxCocrEkaPjUaRzF12hKv3ueoDdN4yToo+LgG0fi7sXjohkSIU8AgMgq/WiFC9kInrQaBeeM+ZIqikv4rEc8RHFy2d7udV3qU3sl6nH3BiexsG4i9W/jT1kYPAsYqYzFxH3HLura8zZhJ+IFJE4RMByuLqPGusaSOJEBGBSdrlH2vltV9587upQBqVG4npqCoR//9F4YdvKwOBbhXtlFHNaVhpF4Jfjom8vgtLh1GUuIZShgiE7ZpATamDBOvks24qO7nI4HcapVNXsxYuPkfm8lxF/Ci1ZPVzhXurm62wqaPrM4CRupSnvX2n96+qsu6R6TW5h7XH1IBVswImxyNxyiohBQqEX29q2e0OJrhYrpe2OrU1LVKXCOa8saDhvv5ttz74t3vnKMBF3n4GMTnHE
 1FBTD/0a
 BwkorNi8qMpwbTn9H5iKFgIwEBVeLfir5wq9axHyJoNYpjCfQPx6AN4GKYKXONpe3zmlIskD9UJIjR9a72jcGnWVVwtJZpHgML3En8/SdWNp+mEwi1Qrv0L194tpE+USzSYoUmkRaQIjm24OOPw8aSDtHcT4AGt4f+wE8uVwSZpegi/qwBDGBuYa4v0r/g6zGyof2Brb670EpF60X5vF9M9EYGIMnMOkF+HMq2a8JFLxshXsLpo+BoXla5PmcXaMKzWwNThoNoRg03C29VcOqwhReTG5zzcPIdHI40WldB9Q9fMXrA10Ra0Cn6l0VfzE3Xd7nSQwVEo7yZXcm+DRKrt2O+SBruj74IZNAxpUZRKtWjOx0EqUO2Lkw5aAuZ9+Yd2D5oOCE9x6c/619s2ZaJefNOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/26 6:09 PM, Kiryl Shutsemau wrote:
> On Wed, Sep 09, 2026 at 03:59:37PM +0800, Baolin Wang wrote:
>>
>>
>> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> wait_for_scan() gives every case the same three seconds, whatever the huge
>>> page costs to build.  collapse_full() asks for four of them: 8M at a 2M
>>> PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.  Three seconds is
>>> thin at that size, and the case has reported a failure for a collapse that
>>> was still going.
>>>
>>> The timeout is a ceiling on a poll loop, not a sleep: the loop stops as
>>> soon as ops->check_huge() sees the collapse, or as soon as full_scans has
>>> advanced by two.  Raising it costs a passing case nothing.  Across 80 runs
>>> of collapse_full() on arm64 with 64K pages the wait was half a second in
>>> 73 of them, with a tail to two seconds.
>>>
>>> Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
>>> PMD is unchanged, so x86-64 is too; a 512M PMD gets 19 seconds.
>>>
>>> On arm64 with 64K pages a passing ./khugepaged all:anon takes 49 seconds
>>> under TCG before and after this change.
>>>
>>> Assisted-by: LLM
>>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> ---
>>>    tools/testing/selftests/mm/khugepaged.c | 7 +++++--
>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>> index 1ca7c6978571..48e0040d53b4 100644
>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>> @@ -556,8 +556,11 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>>>    		int nr_hpages, int collap_order, struct mem_ops *ops)
>>>    {
>>>    	unsigned long hpage_size = page_size << collap_order;
>>> -	int full_scans;
>>> -	int timeout = 6; /* 3 seconds */
>>> +	unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
>>
>> We already pass in the 'len' parameter, and its size is also 'nr_hpages *
>> hpage_size", so you can drop the 'bytes' variable. With that,
> 
> They are the same for the PMD contexts, but not for mthp_khugepaged:
> mthp_khugepaged_collapse() passes len = hpage_pmd_size, the range scanned,
> while nr_hpages is the number of folios asked for.  collapse_single_mthp()
> asks for one order-N folio in a whole PMD.
> 
> That matters on arm64 with 64K pages, where the PMD is 512M: with len the
> single-mTHP case would wait up to 7 seconds for one folio, with
> nr_hpages * hpage_size it gets the 3 second floor.  The budget should
> follow what gets built, not what gets scanned, so I would keep it.

OK. Got it. Thanks.

> Does the Reviewed-by stand with that?

Yes. Please keep my reviewed tag.

