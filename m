Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CA0C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 00:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189666B0093; Wed,  5 Aug 2026 20:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A8E6B0095; Wed,  5 Aug 2026 20:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053566B0096; Wed,  5 Aug 2026 20:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A10ED6B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:47:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FE481205C4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:47:47 +0000 (UTC)
X-FDA: 85069006974.06.B2B668C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C7318000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:47:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pwNhlS0F;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785977266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKPwPKGJNzrSd7Eti/6rUaxXlZPULugR3ZSio0R9ypM=;
	b=7bKFsFOf+ApJF6ktnUZjlKXYjBn3NSqKDe9gY8XVJy3QWc8RmptoNeeUY/t74P+6m0pctN
	eAzH53Uy6btps5x3QbRdbRUU8JrKmmXcG6vsjCYhx1yrVSyafF1x+YYSWQiWuzb3cmmgCY
	zuj6JB0rOzwNvlJUDBKMosFMWWwxF2w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pwNhlS0F;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785977266;
	b=EwwwkINjkZq6Iz/7r3QYeZmbpk9sjI4JZh0tYwCNUnmftkBgG6yolUg01FFdNtA0jvvfYf
	eVh95OvG7VxNQcVu7C7/x1jOBglkrbbQQo6iRtkvzNGE3a/f+5e0jCDB1CEp1fSm8Bs2Ac
	tqXHN4ZivzUD4LHJU0Edu4cjL+Eq26I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785977262; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OKPwPKGJNzrSd7Eti/6rUaxXlZPULugR3ZSio0R9ypM=;
	b=pwNhlS0FnFBt/F+z/++qTPkpRyt7J3JXNJmlbtYy4DoulqI9meCugHTe+AbGPitl4v9y4Q/Wmod+75fUUTFz+lV5iGScjxFlcOhZg2PgBM53XVOMsvqa+fezC+iztBWJzWpvL1SVR5Gs8n1QpCg9XSF48KWfsIAdbt1AcoBUgog=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X8SEFVa_1785977259;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SEFVa_1785977259 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 08:47:40 +0800
Message-ID: <9a9b5563-9aae-4780-b628-d85b836f33cd@linux.alibaba.com>
Date: Thu, 6 Aug 2026 08:47:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] selftests: mm: extend the check_huge() to support
 mTHP check
To: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org
Cc: liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <f2ad5bbe868dc7ed8642842ad2f9751a1ce79f70.1785564857.git.baolin.wang@linux.alibaba.com>
 <DKH49QGMDJGZ.1GN8OC454DA9U@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <DKH49QGMDJGZ.1GN8OC454DA9U@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ud687gyh1kyms9qsbsqmo4n6c6mu78mk
X-Rspamd-Queue-Id: 9C7318000C
X-HE-Tag: 1785977264-801694
X-HE-Meta: U2FsdGVkX183YRJpI2stfZEKt0s1eiD75+QWcFCMxMwow4VGFeOnIoqf2ioeHyxBCR5Xcwui088m2yujJiSKeF6iP7kQwMJST+7Ns+xSZA2wnCRmgC5MlsSVD3q8ScVeYn5AziYG6HFWuy5e3pr4qJjHYmqI/O3CKwhIcwMQNf0MSa7ZqdIWPfB4h3qhDyPIunnT66Hv0mLbsLrL1Zp74Cp1ReLApeFyOcDnyR3gD+tJcU9ZRfnCyGxBtUR6BDtskM2ObDFXSkr7Jhx8VIS652AWROh+9BhSSgsYV7pUYhISBVk55u0/yGJzu6Dpi9tL/oFPLPO8dn6qYjcNQRiBy486ihpQb0l5cJlPQVOHT5Mwg+ncbaHvvGImoPmnVqb4FdwGtDRrSBTzSva2jlLP62Qfn+caDuc6TrQqzZRqFvdC/0YK7A3/xVpW14JcJ/sfbT0Kcb95FeAPc2+hZjluuLWQO7oJzgSlCdAN7w+JZexEbJob2Jwpgg6V7VFSryeWDfB+sK7BowOu0Pa/55wMPaJICd+ypMFLbYtIt6N/VXYgzxvtNx6WM1paE6msS5IpatVVj/vThV5wGGdxUyGnjDAbK4vonLDtohqhKBkONcN1OqQoZzHU50or2SYmNmjyduLpaYW4MBTMAnbtsuTrv1pgKRPtD+h5ShdFEr97cW+xGyUM/a0BqqqANGmXFvHg33ht+K2pdOdq4EHirYPk/+kW4afxus4gfyHS9ZEDUx6PAPc6GZygfurLYMX8NaxobY5onA0mr0KaJQ4jeINhr7DrKgrjsca2boXnJaguyNv2W/OnJhKVwOQHumf/CnThjuKKodyQpt5yrEJoOGlerORTdBteX4CaIKZmedC0IEdSWGVfUHr8LeHChulxEW6vGRxqUb2qNg/u+1vxRcWh9y4kUj2QNIuhmY+44U9ZLDwHJGm1OtjQXxrRBa/2pJQhdygmn9v1ZSRgRIeiuPM
 SRHpPQY4
 BJnx8sArKyHcOyAwUo9cscS7XHYeDf3DF0ek5U7/5dG42xDmQJm10zNYQijht1rUQZOARefw/oEtrARZEqJA0Aiu0LvtonAzAaisR4MvUNR1iFr/yC1sKlNqHBzeAyRNTfUoAOyIJco9XUY1Oz2kJiMlpAF4aiiNe/sNRmU0SX6I68y2/A/DJr7rGj3vlaV1vPmN11lZiqXlt6BKmLYwp+IlBI2MfFmKu55VD0guIome1/OcK4gFFNdEm+IbYXYSmyzyZ62BU3rhgIWGL695qyEGIfgS9Ss0+LEKCPTFaVqsSng/bSJjAh/ptlkBkzWMfQvDDKN3TleAgjTc+4kvzewTCnDHfZrpve4ihqaIugZ/MJdByzIxkwLxEPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/26 11:31 PM, Zi Yan wrote:
> On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
>> To support checking for various sized mTHPs during mTHP collapse, extend the
>> check_huge() function prototype to accept two new parameters specifying the
>> address range and mTHP size, in preparation for the following patches.
>>
>> No functional changes.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   .../selftests/mm/folio_split_race_test.c      |  2 +-
>>   tools/testing/selftests/mm/khugepaged.c       | 66 ++++++++++---------
>>   tools/testing/selftests/mm/pagemap_ioctl.c    |  2 +-
>>   .../testing/selftests/mm/prctl_thp_disable.c  |  2 +-
>>   tools/testing/selftests/mm/soft-dirty.c       |  2 +-
>>   .../selftests/mm/split_huge_page_test.c       | 14 ++--
>>   tools/testing/selftests/mm/uffd-common.c      |  4 +-
>>   tools/testing/selftests/mm/vm_util.c          |  6 +-
>>   tools/testing/selftests/mm/vm_util.h          |  6 +-
>>   9 files changed, 56 insertions(+), 48 deletions(-)
>>
> 
> <snip>
> 
>> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
>> index 7799154b67ee..c7ae28dfda63 100644
>> --- a/tools/testing/selftests/mm/vm_util.h
>> +++ b/tools/testing/selftests/mm/vm_util.h
>> @@ -90,9 +90,9 @@ void clear_softdirty(void);
>>   bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
>>   uint64_t read_pmd_pagesize(void);
>>   unsigned long rss_anon(void);
>> -bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
>> -bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
>> -bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
>> +bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
>> +bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
>> +bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
>>   int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>>   int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
>>   
> 
> I get what "size" means only after I see Patch 3 where
> gather_after_split_folio_orders() is used. I think len is a better name
> if not addr_len and its type should be size_t to match
> gather_after_split_folio_orders()'s signature. The rest patches should
> have the same rename and type change. Thanks.

Will do.

> Otherwise, LGTM.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>

Thanks.

