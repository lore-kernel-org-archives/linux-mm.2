Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289AFC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50AB6B0088; Sat, 29 Aug 2026 03:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00E56B008A; Sat, 29 Aug 2026 03:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18ED6B008C; Sat, 29 Aug 2026 03:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 933326B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:17:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 914D91A064B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:17:06 +0000 (UTC)
X-FDA: 85153450452.22.154F2C7
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0895318000C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:17:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="B/1Ex00v";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787987824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNys40qzCinjjkeQyfa5/uHXe62MEi0scb5rOsIlERM=;
	b=HdrdjJYC/mkzFpRQINxZViJo6opcW4OrZ7xXGsPywKrEfRnfLJC3uGHyugQ7eS5Id4UVxZ
	tqpOY1aIcM2v5fNSBJGHJncHWA82ogq/if8xHId6rVmVxjcGhHimm6sM7aXkjUIn4/Hkw+
	fyPPtJ1ywHkl2kc7y2X6Wwj/I2oxgKs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="B/1Ex00v";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787987824;
	b=Z0DRzyITpCTcdeBpNWsj424fHurJ7mfHLNzOlJSzThubqagyRGMQ8LnGZjYRh41cxEeJYb
	J+1XDX18fK3dwrMiZu40xpmPz8czGovQUNCxNJp+cXkQpwZ/VrogDlarSYTzahFtwGZSzZ
	e3a0xDA5bZ7duFXDG4UIoaZFBqGu8GQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xNys40qzCinjjkeQyfa5/uHXe62MEi0scb5rOsIlERM=;
	b=B/1Ex00vL4B1NGhygBdjgt8P6GU9hjy/4FB9a2qGim9uYzJ0pyfJtu43TFUGqY5BYSMvKYImN
	BPSdVPKIgwz39emn7ft14BIO5fzULtpQDvdbIpawvP65j4M80CTtjAWbDuUjQpzJFBBZD8BsFU1
	Ja2sEl4QSGFFrQNNHH4YvSo=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hX5rY0VMyzmVZQ;
	Sat, 29 Aug 2026 15:06:05 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id A77E74048B;
	Sat, 29 Aug 2026 15:16:52 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 15:16:51 +0800
Message-ID: <c7b0dc34-ae1e-4a3d-a286-fdae0e1d978b@huawei.com>
Date: Sat, 29 Aug 2026 15:16:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/page_isolation: guard compound_order() against
 racing
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <wangkefeng.wang@huawei.com>
References: <20260825120549.966271-1-xiqi2@huawei.com>
 <20260825120549.966271-3-xiqi2@huawei.com>
 <20260827204732.367c52ad420acb0b87bf29ed@linux-foundation.org>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <20260827204732.367c52ad420acb0b87bf29ed@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: amp8nkoq536o8kd44iiboq7rwkjqguay
X-Rspamd-Queue-Id: 0895318000C
X-HE-Tag: 1787987822-624876
X-HE-Meta: U2FsdGVkX1/+aNJ9kwSV8B0sf0RcVsSnS97ptq/iVAXYLitOvCOSjKiRwwryvKHmgwaZuph5gauuKCqLt228XKVlQbq/l+b4PK4NgAiDvpWgWv3pvy2M5Suxx+yyohEKq2fXkK+wTU+WiUQ6ho7Ff6RovqQEwRDXE4m+POzmFfzDkYaO7vJpVWOL1OdPtNIKMgcxgqn2OFQXv7HGL6jpAhdiYe38e+TINhTjDGZ8r3Vw3ThEnGsDXou2eq8lmR1a6SeR8nAjFxsM3MZeKyCCxAcabxj3PLg2/NXZKk5HqWfxUKhSmFvVAlFxpak8k88pM59MmZWnkZv2uBEq7lfge+kvKm7yonpdmVbtfrsfacXUEkZYArJ61XFNebrJNNYV/36nj168Q/VZcjv/uDbnFNOaQC0crzWRE66ShcEolpJxtz7Y0jqG3DBTSlvbtfYnl45HsplGMuygNDm2B22d5OUsFb64Di0qCUqukE7F1J+O114u9y3K6KJxNRcvYRdoeVZsR0sW9ttXiF6q0fa0PQbVMDicN+t+eCevV1rFS7mAJF3P+2wXexTQG2c6j4YlV7c7S+ZjE6uq15F2E6HvkPSgt+RyPGJEb2U1r9GuLE1f/7bSe3LJqDBKshVIU0Wa2sHKoMTpBvFH2n1Nvl6ho/Sig0jFMvch5fNmVEBpv/19mClc5regTDWpIy70Gur//mQ4kAl6TRLiwyDVSVJRvYdH4Qcp8NPGFetaCbJCTLq0+J/uYZTa9apyo1M7bQ6AptijbdjAUK69QoGZBF64ioDqXQ4Y2D3zAKUQ/1t3Dhb31sn0rwDUytbDOdmgvM3E2PZH9cvQ2F2I4i7nYTwrGVjeo9RkOLvQL9mXqgiMnYFrNQQJa0WJ/N6qVFbEmh1AZGXgPBPrqRMNWk5QPLPPf6PFnVlM6vzuSl7v+AQ0+nMm3zrxtIhtqeVLi6VeAiUotXjjdnNcmSUEiM8umLM
 YumwldmV
 F66C4WA2DPtmMFMAwNYpXeH3jp7yyGVyg31WpvPYv/HP5GGadPIxhI79/7126DF9CZtD1DJcettdHhizUYfjyL/vwMoe1M9pcyP/u77BW3b0zovxTnKM+ANcV+Lvs+z4fje+07/J7VddN+ipKEgsyEZv0UwplIX5dqe1vDMfNIhHGpkVNUiZDKr4KbwqNeeWeTM5HM2NKqfHy52hECe6xzH77Fk4znatWuOzrs1Sv9ifQ1yuP+D1lcl+ybhr5RU9pEbBCz2hcni+zNhlyfFXssOzWal8jFlWw2Qt1lx4J0J+x8k5n11/6BTfWCHpfBWL5pjUapLarNP/NhIzJRGmjn0tvdY1lWrWN0c4YHsI5lRB172ungKjIB9Cr9nSMHCwV898wBRf7WDpICWjHJEKJyg8p41t80oIyqdhXZG5av4+ci6KmmdMp+A5/Zzi+roV8H3mqDgbYJecIof9w+4zF9XC2Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for raising this. I checked the path: PageHuge(head) resolves to
folio_test_hugetlb(), which reads page_type via data_race(). I don't think
it's the same issue this series targets:

- It never touches page->flags or PF_SECOND — folio_test_hugetlb() reads
page_type on the head page via FOLIO_TYPE_OPS, a separate "page type" mechanism,
so neither folio_flags() nor its VM_BUG_ON_PGFLAGS assertions are on its path.
- The only shift is a fixed >> 24 on a u32, not a variable 1 << order,
so it can't produce the shift-out-of-bounds UBSAN this series fixes.

So no extra stabilization seems needed for PageHuge() itself.
Happy to add it if you see a case I missed.

Qi

On 28/08/2026 11:47, Andrew Morton wrote:
> On Tue, 25 Aug 2026 20:05:49 +0800 Qi Xi <xiqi2@huawei.com> wrote:
>
>> The PageCompound branch reads compound_head() without holding a reference.
>> A racing split or free can cause compound_head() to return a stale pointer,
>> and compound_nr() reads the order from that stale head, leading to
>> out-of-range shifts and making the skip distance meaningless.
>>
>> Read the order explicitly with compound_order() and validate it is within
>> MAX_FOLIO_ORDER before shifting. Also verify the derived head_pfn against
>> the legitimate pfn: the head must not be past pfn, must be aligned to
>> nr_pages, and pfn must fall within the compound page. Bail out with
>> -EBUSY if any check fails.
>>
>> ...
>>
>> --- a/mm/page_isolation.c
>> +++ b/mm/page_isolation.c
>> @@ -418,10 +418,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
>>   		if (PageCompound(page)) {
>>   			struct page *head = compound_head(page);
>>   			unsigned long head_pfn = page_to_pfn(head);
>> -			unsigned long nr_pages = compound_nr(head);
>> +			unsigned int order = compound_order(head);
>> +			unsigned long nr_pages;
>> +
>> +			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
>> +			if (order > MAX_FOLIO_ORDER)
>> +				goto failed;
>> +
>> +			nr_pages = 1UL << order;
>> +
>> +			/*
>> +			 * compound_head() is also racy, so the derived head_pfn
>> +			 * needs additional checks to make sure it is valid.
>> +			 * Otherwise, just fail the check. pfn comes from
>> +			 * __first_valid_page() as a legitimate PFN, so use it to
>> +			 * check head_pfn.
>> +			 */
>> +			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
>> +			    pfn - head_pfn >= nr_pages)
>> +				goto failed;
>>   
>>   			if (head_pfn + nr_pages <= boundary_pfn ||
>> -			    PageHuge(page)) {
>> +			    PageHuge(head)) {
> Sashiko suggests that this PageHuge() test suffers the same issue?
>
> 	https://sashiko.dev/#/patchset/20260825120549.966271-1-xiqi2@huawei.com
>
>>   				pfn = head_pfn + nr_pages;
>>   				continue;
>>   			}
>> -- 
>> 2.33.0
>>

