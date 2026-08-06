Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC25C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198B86B0092; Wed,  5 Aug 2026 21:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FF56B0093; Wed,  5 Aug 2026 21:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD7E6B0095; Wed,  5 Aug 2026 21:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD586B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:08:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF291404DD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:08:36 +0000 (UTC)
X-FDA: 85069059432.13.2B8AE39
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22FE540005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:08:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A6LgN6Nk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=af4kgtR65RjNTdAtxRPnSe6H2YT74ta8v6zpWeeJOXM=;
	b=qR/KAS4SsJ+vyjfj5+NJOjvtVg/i2Q+6nZMB1PkE8Z0TYJdIBvlP8qKUznUPzgF0lcfraa
	GNUfUDrkLHY0Dumi/V8R+O5FYU3oRsARaCgrUwuebZ7w6GbxnuW5nc4UIb8UQ5LHTODpkN
	z7j8FG4IKtItRk6wPAqCrS9Cb6/f2Eo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A6LgN6Nk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978515;
	b=c/3294e8EXgIo+hCn7LoSLqqN+7/gVBo9Mnuzul5J/r8L3BFdmFTCZDgSzWZ8N55ubaQUV
	n6wv8GM7DTqfluJg4fuU+WtEynVKEMG3hl0lj91S7TP2unO4Gmz3ckISIlKm+VjYQWH1Yj
	zTJv21rAIcFWZ+NLJhXletUfrUj/OUg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785978508; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=af4kgtR65RjNTdAtxRPnSe6H2YT74ta8v6zpWeeJOXM=;
	b=A6LgN6NkvbjBxv3/3QCdO8wilkOr0RdTaZfhA4BhypcigJecq4dD/Gb439fD4ywY8GM34iYM/EKX3mEfqfunmN3VcuIyL6RW+Hpda460fBqzmiQUryiHdJbRivgexZa4Nnk/50OxzLB5f2q40vABRwBgNvo1R4FaT5NF8h77mYo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X8SKbUo_1785978504;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SKbUo_1785978504 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 09:08:25 +0800
Message-ID: <6c778b79-5945-4832-bbf6-1a586c1c5647@linux.alibaba.com>
Date: Thu, 6 Aug 2026 09:08:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] selftests: mm: implement the mTHP-sized hugepage
 check helpers
To: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org
Cc: liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <eb75f6d510fb48f14e25fde85e5a5e2b67cef394.1785564857.git.baolin.wang@linux.alibaba.com>
 <DKH4VJXGIUNU.2ZENW7583Q6K5@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <DKH4VJXGIUNU.2ZENW7583Q6K5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: aqz7yfqwaxggdz3mpko6jykbzq54id4c
X-Rspamd-Queue-Id: 22FE540005
X-HE-Tag: 1785978512-501704
X-HE-Meta: U2FsdGVkX1/8q24Zsu7uBn1heW0SpYGWsqvV3ebohrBWz+AioDzjdQUycNwnSACH3cZo2IRKOOu8vljrVeSo9dDE7w/wH/10nHjxJjGrjjVeSRvy8ClnNWZkACTmjJTy6L4zBhujra6aJQSN1luRUu1K6lzAB1K4iPrBl+ydap9hlTAhpYCgj6a1LU5jit/tsqHdIDbrXcl/aoMfpAODvIS1TugSWxv1Q8vgedKbi9zuqE4zIBXvfz5euVRyCx7HoSeQS8mVNHdSDgLtgodMOf3kUq8lh2D1Ftl9MyJ3mdLYFTm8bqj9A+fzO2oaZrkb+3s2/0lTMKZyrMuic1xYWPY6sZjO7XJsqWg+44+i06jLeesR7MDO+IiU7b6dFSNdeq18Z1MgW1QAFlz23Ve0zYa7nCCMDF1MbkMQmMchMR7zDzN4wYepKgzODzm/HW96DiLI1lBIfLXKYd2CUp4Bxjf2XfZoRvJLVMvJ4IzWIKm/jSSQ/+2GCLZscyfIXQ7mUxMTw/mex6AIQJqYJ9swIyypnVf+G3AcPAiTk2mMA4shpcVWjrWKVkvxFfypKZ9YB7AjqAp1MOdE1g8RbI7ZulRkaM9gLzdHXuZi1rlcKiI8xY4wAZdyo6oyFpCwLTCgwz+mPqAWleUmzFk5BwpNXwGxALyOxTmxxs0x0iTpJG3k2UIh2mjc1t8kgeHaKnSwqLzyrSzJEMAzneRPsCUcZnoFGsNZNnZbqpW8QRbsr8UrnsDjdYzW+WkHeUOblZoKEdVGLtjajer4HWYo4HnwEVKqMfZbPX23KRtEcmOFeZqWfyv36frobPri5J5+Vr2koE4pqq+Dn8z/YwcHBLC7WPrRAucRAxgEzh/wBdN/epBrzYbEq8B3jT59roMyhn9Qrj6+uygIi8a3YdocgVh+tC/sXqcF8ygvlwptqFXj7uyappWlxzqutOZsSU4MptslqTp6oYZvV9dTHjc1vJI
 hzay08uQ
 YkdIof2KReZCSfHR01md+YAWVgKHqUR7nQVAxFvFm/B3Mc1kKTpHtOheCWuo4sdqwbjP/xf45gQSI3tEW3L5NaskwwV/p8xuiXnkzD0gMcTh3TsGArQpBe/hUygRWrWuTazk+ZQV5Jet2Vba6HAvBa2w3quMJJlftjM4fu9YZp5RLUQka5emUT4w4l1Ncg2q1clM3IUA6l0/oCl9nWH206M/m7dF0re+32hebJIBuY/mmFFpAbGxZADpbv2sO9TtMSbnKypdx9gh39cxb1aiiPwltVGdaoLS1cEbiHum+qvtxn0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/26 11:59 PM, Zi Yan wrote:
> On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
>> Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
>> Also rename the existing PMD-sized huge page check function to
>> __check_pmd_huge() for clarity.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   tools/testing/selftests/mm/vm_util.c | 60 ++++++++++++++++++++++++++--
>>   1 file changed, 56 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>> index 09e5d5cabe21..1240d783669c 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -15,6 +15,10 @@
>>   #define SMAP_FILE_PATH "/proc/self/smaps"
>>   #define STATUS_FILE_PATH "/proc/self/status"
>>   #define MAX_LINE_LENGTH 500
>> +#define PAGEMAP_PATH "/proc/self/pagemap"
>> +#define KPAGEFLAGS_PATH "/proc/kpageflags"
>> +#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
> 
> This is a fast way of getting log2, but there is no check of the type of
> nr_pages. What prevents one using it on a long variable?
> 
> At least you can convert nr_pages to unsigned int and add a comment.

Good point. Ack.

>> +#define NR_ORDERS 20
> 
> Why 20? mTHP orders can only be in [1, pmd_order - 1] and different arch
> has different pmd_orders. check_large_folios() probably should just cap
> NR_ORDERS at pmd_order.

I followed the NR_ORDERS definition in selftests/mm/hugepage_settings.h, 
and I think this function is not only for mTHP. Other test cases may 
also call it to get the count of large folios beyond PMD order in the 
future.

>>   unsigned int __page_size;
>>   unsigned int __page_shift;
>> @@ -348,7 +352,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
>>   	return entry;
>>   }
>>   
>> -bool __check_huge(void *addr, char *pattern, int nr_hpages,
>> +static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
>>   		  uint64_t hpage_size)
>>   {
>>   	char buffer[MAX_LINE_LENGTH];
>> @@ -366,19 +370,67 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
>>   	return thp == (nr_hpages * (hpage_size >> 10));
>>   }
>>   
>> +static bool check_large_folios(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>> +{
>> +	int order = 0, pagesize = getpagesize();
>> +	int nr_pages = hpage_size / pagesize;
>> +	int pagemap_fd, kpageflags_fd;
>> +	int orders[NR_ORDERS], status;
> 
> NR_ORDERS is a constant, so you can put orders on stack. I think you can
> rename it to MAX_NR_ORDERS, use 20, 

Sure.

and check pmd_order is not bigger
> than MAX_NR_ORDERS.

I don't think we need this. As I mentioned above, I hope this function 
can also be used in the future to get the number of large folios beyond 
PMD order.

>> +	bool ret = false;
>> +
>> +	if (nr_pages > 0)
>> +		order = GET_ORDER(nr_pages);
> 
> This funciton can fail early if nr_pages is 0.

Ack.

>> +
>> +	if (!order || order >= NR_ORDERS)
>> +		ksft_exit_fail_msg("invalid order\n");
> 
> It should check against pmd_order.

Ditto.

> 
>> +
>> +	memset(orders, 0, sizeof(int) * NR_ORDERS);
>> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
>> +	if (pagemap_fd == -1)
>> +		ksft_exit_fail_msg("read pagemap fail\n");
>> +
>> +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
>> +	if (kpageflags_fd == -1) {
>> +		close(pagemap_fd);
>> +		ksft_exit_fail_msg("read kpageflags fail\n");
>> +	}
>> +
>> +	status = gather_folio_orders(addr, size, pagemap_fd,
>> +			kpageflags_fd, orders, NR_ORDERS);
>> +	if (status)
>> +		goto out;
>> +
>> +	if (orders[order] == nr_hpages)
>> +		ret = true;
>> +
>> +out:
>> +	close(pagemap_fd);
>> +	close(kpageflags_fd);
>> +	return ret;
>> +}
>> +
>>   bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>>   {
>> -	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
>> +	if (hpage_size == read_pmd_pagesize())
> 
> read_pmd_pagesize() can fail and return 0. Either you need a check here
> or add a ksft_exit_fail_msg() in read_pmd_pagesize() to remove the
> burden from all callers.

Ack.

> 
>> +		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
>> +
>> +	return check_large_folios(addr, size, nr_hpages, hpage_size);
>>   }
>>   
>>   bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>>   {
>> -	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
>> +	if (hpage_size == read_pmd_pagesize())
>> +		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
>> +
>> +	return check_large_folios(addr, size, nr_hpages, hpage_size);
>>   }
>>   
>>   bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>>   {
>> -	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
>> +	if (hpage_size == read_pmd_pagesize())
>> +		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
>> +
>> +	return check_large_folios(addr, size, nr_hpages, hpage_size);
>>   }
>>   
>>   int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> 
> All read_pmd_pagesize()s above need to be handled.

Sure. Thanks for taking a look.

