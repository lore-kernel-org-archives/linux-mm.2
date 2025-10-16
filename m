Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B4CCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930CF8E0086; Wed, 15 Oct 2025 21:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908DD8E0008; Wed, 15 Oct 2025 21:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845E78E0086; Wed, 15 Oct 2025 21:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEBD8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:00:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F27056064
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:00:47 +0000 (UTC)
X-FDA: 84002172534.01.EFC6736
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id DBB2D4000E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:00:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1Z3pfU79;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760576445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfDL4WUVuSvO/PJUvMT3ITZB7plYPga5Lrc/6DP0IeU=;
	b=cxcYPS8B56KKzMQWH/EozH6jQ6rulKKh9lJCGpAJcmBi+rAgzMmn40ZO26MSHtZcdRQyC8
	5nJGnBYk/FxTqIiauAaJQy9LjsFk8fE1qeGPSwaWpd+vfe3AEouMcz1+M8HC+Grb8oeoa8
	ua925sw7JP3roqgWFdS5CO9dGM/lypA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760576445; a=rsa-sha256;
	cv=none;
	b=OGiGzF5MSfSVF3qRVPqCLnMEZAt0qN4R60eh01/NAJWXALKLv949ggklrBHzCfmDOvbuSw
	d4ije0cQMf1oJrQsK+WhX72tcuO1c7cAGB3ECrYHpUeJSzHgUYhVQC4/AnW3PHR7N24L8E
	SGa/Mi5gbwn+oaUNg8hi/vEAc6GPK6g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1Z3pfU79;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bfDL4WUVuSvO/PJUvMT3ITZB7plYPga5Lrc/6DP0IeU=;
	b=1Z3pfU79zHRpCR4oOfBThH3I8fluDRm6ttjlyQI1sJk9Tf+kOHCpd2Wxogfjr0IzNuqtIpXH0
	UX2L53Btt4wysLufxrDa+PtbILkdIymt6/attRCkkqnz1XLP7iuo+yciNbslDuk7kELaV6ai4pI
	a+6Y6VLGXTksjp/LaIK0yig=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cn8k35DZrzcb44;
	Thu, 16 Oct 2025 08:59:39 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 48945180064;
	Thu, 16 Oct 2025 09:00:39 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 09:00:38 +0800
Message-ID: <0d26ce96-2c59-47bd-a034-d7810ce6aa5f@huawei.com>
Date: Thu, 16 Oct 2025 09:00:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
 <47f69b78-8141-42a6-b04a-f67ba0b90ee9@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <47f69b78-8141-42a6-b04a-f67ba0b90ee9@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: y54yazq95uqswtwakgps5xcyhokedtr3
X-Rspam-User: 
X-Rspamd-Queue-Id: DBB2D4000E
X-HE-Tag: 1760576443-45755
X-HE-Meta: U2FsdGVkX19dNrdz0RvkWafd9oIIcyWp+LvwJhafVVKvx+PdKj0TeizF6NHnspJq7kcchwZDKiwBSKPAoW8tRoApggv594mx/BcZuZbF7mxrkyzsaR3yYncUac6eIyOG59qTlayPcDs/PuSNykyXyZetHHSaslNSgsCithTRXn28dukVxBtbs07HAFlz+mkP3XL42YI80sUsY/4sJGFRi/R0yGezXSYoGkHQ8MuwKRiIwtT4s0YLCCtnb3krz/VAPr/2CDYURpNBmn30EZ+zeM3J0Z5Ob9vG7arCrONut7L+jonCwh3EMmMHHYbVant5LFkYv2I0sIvDEBjl1WcRvF+uF0e8KWl4KoKU7tarTFsqB42WtgmwKsM4U9xQPsDDfD9BMxU+5rCoH3O6hPLkX+pEheFIKojpG0PVjVslaKJz6VGlWRpPkBCmUZL8Ot1ZA+hJcF6dv3kQ8UoDMCogUznA9nHkvXM/mXjgWt0B7QiQIXfheIKxSQCjsUoP1sB0q7s4Ajsp6OBIKXWVM8UoT5S1GZHtvl0mutLdBZRD0EIw/2CFW0+4iXUQ5aNZ2aLuotle9A9k359zmYl3Ga3pQ4IJzM19Q36uhWN9HZha06l20Ls372DBSXCBqemrD+Ze2KJXcnm76EU2uolqvkAlcRtmWQSO+exBdFDI7FbA56fvNI+/G+w7F320pnK/78rcVzX1SMH8dfiUi4T3By3VcxTnKoLnVV+8lQC5M94UArYsXh5yAKe8D+dhmDgoNJUmn5HAxj4GucW96ZDTq57Z8kZiNz6r4E7zTI9SZPP0ITHqDYmn83TGdl/bgHfLTwPFHsZ5q/w1fcfbCJD4YmdxgDZ2CCeNLmELqq1xnX78IFxJ668fx8/BzyD6O/UAxVPhaGXUZKx9m9Rg+RPWShdynHdbdnHvo5zvaEo8w8wRj+f54QNEZMYZQlHGoIAHtDa2IHBthTGC6bwB1tkCZRY
 uyXqBsIu
 6KJ2gmaCjlxl02OhvII+qodv8mkhrNlSSEdAcUwLcjQdL0X7gxLM7fR+cLSBmA3MUlxC4wyO5oWGVhUD2hozoPaq0ocP2Z1EjgKL1fUwH/WliLD6seZWKOJCbL1aAF2dCHLRAMzAkiso7yxI/dGuenFD3eWtNbG9bhRr0Mc95hH1SGSkKZmCj7ukp9cDztlk7fjhe+NJuFVoIaH1TT2WpRd5KhWrLSGycnAoAJXqdUwVJIjhw+CwTJuZtUheyz96a3UzVSiPffhoRxLCiZv2u1MwZRS1uuASInh+s34denQ5WB50Kyma8B0dnEMdpFcWAIMRaOL/v5w5gP0PESvHgzJk6vgF6eocex54KdGfLyNYYZmxPISF5KdYRWM7V/vhE9xVONOMjhp0YU3LTwPX6Qi8brcOga5Z2kLO+q/X/hpBvqNRF4SVa3g7PRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 23:32, Lorenzo Stoakes wrote:
> On Wed, Oct 15, 2025 at 08:35:14PM +0800, Kefeng Wang wrote:
>> If the folio(even not CoW folio) is dma pinned, it can't be
>> migrated, so always skip pinned folio to avoid a waste of cycles
>> when folios migration.
> 
> NIT: 'when folios migration' -> 'when folios are migrated'.
> 
> Maybe worth saying 'due to elevated reference count?'
> 

Hope Andrew could help to update the changelog.

>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> LGTM though so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks all.

> 
>> ---
>>   mm/mprotect.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 113b48985834..bb59a42809b8 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>>   	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
>>   		goto skip;
>>
>> -	/* Also skip shared copy-on-write pages */
>> -	if (is_cow_mapping(vma->vm_flags) &&
>> -	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
>> +	/* Also skip shared copy-on-write folios */
>> +	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
>> +		goto skip;
>> +
>> +	/* Folios are pinned and can't be migrated */
>> +	if (folio_maybe_dma_pinned(folio))
>>   		goto skip;
>>
>>   	/*
>> --
>> 2.27.0
>>
>>
> 


