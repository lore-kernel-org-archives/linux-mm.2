Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C38CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5426B00A6; Tue, 26 May 2026 07:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FF16B00AA; Tue, 26 May 2026 07:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850506B00A9; Tue, 26 May 2026 07:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE986B00A6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26681403BD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:52 +0000 (UTC)
X-FDA: 84809321184.26.681F1E8
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6814180008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zZzXOMz1;
	spf=pass (imf06.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFgQI5aMdJK6GkuCY5wGRn20esivYerd6yQfalhpU20=;
	b=W2JbQKwA3bRupFwOh4Dnz/14hVvs2/EWLOBx9FzTNuaCdSiEBBXLQP68IR8XmiEOxSvsMe
	Gyvs+32U3JwFKjMJocfD0LZ2fL70fw87tSLVtEtQK7XLUP30tOr4yVWF2DuSi56bV6yBm+
	ZDNlwV2BD+ff35Ia+JIlF6DCn5IFC14=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zZzXOMz1;
	spf=pass (imf06.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794269; a=rsa-sha256;
	cv=none;
	b=cIuo9ACxOvcPrVsBj1ou1AMIjNvMSi1DRXUqKD+4I+6wdw2A5YZz5tjxKE06OY8AyYTpr9
	7L+BjnDN3FzfHFDGSwm8NbZQFp0BhMkgrhUbH1Bu+7j3GMqKi2nAmZqfWrLl2pdWzIdS0k
	rMWmrz86xO/BEOABVeK8MD1rGhaeKMg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aFgQI5aMdJK6GkuCY5wGRn20esivYerd6yQfalhpU20=;
	b=zZzXOMz1lMzP33XmKHCwqjbVopQ4NjEqn8wwOaV7lLtWJ1qGNnqtzEqZy2lNRcT4Q+6ffeXrV
	xQXGCroUgRfBbFP/qtlHYO41imXKuLENmGc5IR+xLCGgRzwzf3Y0zifUqLRC/k5ZudobWU9oRp6
	M6gL5ooQ1zDoGsQyE3pTWyU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gPqlb5ZnkznTXQ;
	Tue, 26 May 2026 19:09:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CA0940538;
	Tue, 26 May 2026 19:17:45 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 May 2026 19:17:44 +0800
Message-ID: <ec937b4e-2afc-496c-b980-4d3ea70e4a31@huawei.com>
Date: Tue, 26 May 2026 19:17:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: update file PMD counter before
 folio_put()
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Yang Shi
	<yang.shi@linux.alibaba.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20260526101337.1984081-1-yintirui@huawei.com>
 <ahV8PuP2sg7fV_DR@lucifer>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <ahV8PuP2sg7fV_DR@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: r1xzby7u6bjqmd9bdfa5gwg67pp7d7ej
X-Rspamd-Queue-Id: C6814180008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779794268-484642
X-HE-Meta: U2FsdGVkX1+YCedSzV/8myX1tx850TeR/X9MVHfg1juIwyHwyT0ItWz4yMW1OoIAs435LhAL/W30FnX0XcDQkr6hmW/cpKHRSm43MhRl3ViivTgMEFFX2BqvEJfkZ8Rh5xrLluhJIS45ndL+Ehdf5fyskNGfkf+NP3gx86qmmioflQHukMX3o01SBU6eIVjmOWmyuRGHMP/bCPCaLnUr7OfWBKBRTeO5HdjY/EMNhO8XlcyMgvJIKX0y4oZULV4FgF0KJ+4/p6zqcPFatLilymz30hsiQLJB+6QjMA2mz4YZxYi0Smq7P3yk7BD+zlj/sU8KJ68n7SakrGZmcwqZicy8LuhHFFVfydDiDGUj4TBppqOFV/FPk3swtGJHvvYitWab27nAqRUeoegQLNMEQah0wBOPq7YuqLEH87b/IC3iFftxC1aRJYJZpP7GBi79l+PU3Hw3ZuySlEtgIi3eFyYDBHi3BIRX+Pe85cvl+dmkAoEumHMoRwB81QjtpVqT/Q91c97jMwhI56ZhAo18Czbv5orwTkwib/mEhF5/pq8p6nzItf3DTxBuGH/V8IXaD9SOe71DMkBDSiZs8hgYg6gFTZkdKVXWLP7uJeEWDsgbQG4aixdZsROAVZxDf44cLGWxJjdgkfiSLcH7kc3hGeUsdFtdaWKGKkVzKNWMjhSZ/5FArZJdzrqtOcFkcLDDBEs/sr/+t9o85SZpgrEEjRU0wyqDGx6JqBAroXE45gPZBLFH4QKmZgwh9bcHkiKkXSX6aElytpNUkuJeaJNB26i7ZGzn5p6gq3gC6+0784CtVjMmNLJoNv7JdQtBN8wLy/DcwhPNsjZ/MsNz2Lw94d8K414bpwlzbzExg2/v39y9qJY8lpmdUrZZk0mTOf26wF/kLoof8oWhES1gJfPFfUM7UaSa4jjB2twiZxz5/Fr7tXUNm/57l59mEHruaXOO2qiUGwXD9EcmDB5XFYK
 waFtER0a
 vs3oNONMClXzULS0/N3VUOFjuS+H9EaKl+kZhqMJwLoxWkVZFpnyC5l1pGf5+RX+Q3FDs4kEIHjcVmG9pg+lJ87Cg06XpB5XBODzt5qjVeD9Px0Gs3E+N4ZaH1VuHDi1XPHPhaVgCOGCJ5g7sySI3UkttbkBX2f6VUgC4eaQGjsoyiJCcF7QGmIgJkJQUrTDampMXDXVfQdTZEy+5ZRGii9EkdJFRymLSU+mL7ICYBxfLq2nZ2NqO9jt16ZRavZA8WInwgfOBTV1Vef+OSdmGrdiDppbmG39CYw9lHHVh6HjW3Sd+UAB68hKqZN0RaUJ8yDkRSWUUeNfaScd0AiN1UztVPA80MRvJ9YjkXtpPP61DHXhm3uwPIaTsf25Bm+mwYgKjnSnwODbcnu2AECkyJOEk9QA4K3wqbuDu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/26/2026 7:05 PM, Lorenzo Stoakes wrote:
> On Tue, May 26, 2026 at 06:13:37PM +0800, Yin Tirui wrote:
>> __split_huge_pmd_locked() updates the file/shmem RSS counter after
>> dropping the PMD mapping's folio reference. If folio_put() drops the
>> last reference, mm_counter_file() can later read freed folio state via
>> folio_test_swapbacked().
>>
>> Move the counter update before folio_put().
>>
>> Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
> That's an old commit :) I mean I suspect we're probably not actually ever
> dropping the folio ref to 0 here since we never had a report since ~2018.
>
> The page cache keeping a reference I guess?
>
> But doesn't mean we shouldn't fix this on principal/there being some way
> this could happen.
Yes, agreed.
>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Thanks!
>> ---
>>   mm/huge_memory.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0135c29a4372..a5f4a48b7b77 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3145,7 +3145,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>   			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
>>   				folio_set_referenced(folio);
>>   			folio_remove_rmap_pmd(folio, page, vma);
>> +			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>>   			folio_put(folio);
>> +			return;
> Hmm, sucks to duplicate like this, but for purposes of backport and getting
> this resolved fine, we can clean it up later.
Yes, that was my intention as well: keep this patch minimal for backport.
I will post the related refactoring patch soon.
>>   		}
>>   		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>>   		return;
>> --
>> 2.43.0
>>
> Cheers, Lorenzo
>
-- 
Yin Tirui


