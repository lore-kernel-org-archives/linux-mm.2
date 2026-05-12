Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46763CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F866B0088; Tue, 12 May 2026 08:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6EF6B008A; Tue, 12 May 2026 08:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50CEA6B008C; Tue, 12 May 2026 08:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 405906B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:49:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66D331A0494
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:49:15 +0000 (UTC)
X-FDA: 84758748270.02.A1209D2
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 449171A0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:49:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y0UNX/fZ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mk7t5MkLo6XzuMHVqU+2InNqpcc/cRZVM5/ZDanGOMU=;
	b=Ldz8peWv1bRJRc3luMEWec6atIamGl17nhFn+2D/2IeMbHt5JpHfqoPkaaeAdbn8ZSbrLP
	+hKsk3GB+TUJp9pvxHjeLoCrOszyHVctMpgfqw10gov/HA4gJzZZJt9+VYKgIUWvRG1POo
	8IriEd2lC/nq/vacpvphxXLVmWvLuh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778590153; a=rsa-sha256;
	cv=none;
	b=7TuGtBFxKWCgzbEeBcXqsdYDU5bu7/8p4FkdqnNcy1yShlVEy8M30SULR7mPRZ+nIBeKLE
	bLEd2Ha0Dhvn7O+wW168JojxuXgT5NintthvwZjI3MYaSURN49UThRYxtoAfic54cZGUfh
	77Twtx9ThueQ9YRvAvHTg8Q58X+seG0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y0UNX/fZ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778590150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mk7t5MkLo6XzuMHVqU+2InNqpcc/cRZVM5/ZDanGOMU=;
	b=Y0UNX/fZohdD2/O+ae5TCK7pk3M3M0epqtEBV1l66A576fgZVKcBPMZWjonXh9hxeMayja
	Ff7SKFC1E9eA17pAEV26oVIAVy3HLg+MRUwuSDMY67Ykn6RMPBwvWKgfa3r2iozKrlyl/d
	eCHC5MpBah/awdxD7pDcdmucX/Gy/KU=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: leitao@debian.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	liam@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	lance.yang@linux.dev
Subject: Re: [PATCH v6 1/4] mm/memory-failure: report MF_MSG_KERNEL for reserved pages
Date: Tue, 12 May 2026 20:48:37 +0800
Message-Id: <20260512124837.38883-1-lance.yang@linux.dev>
In-Reply-To: <9504c193-8c01-4d03-8f62-c50fd7fbdbc0@kernel.org>
References: <9504c193-8c01-4d03-8f62-c50fd7fbdbc0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 449171A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: phf9qf8xkogarge7fhpx4se4u96feyk8
X-HE-Tag: 1778590153-696900
X-HE-Meta: U2FsdGVkX192qGaK4E5qxSKCvQ0gTJc/JQO7fGUy39tYf0JQz1gIetvF0klzTDhmJ8bO58nN0xa9Fl3zN5AznuaNZr5uRRkk+dDSBXUDu2YbbO9ScWUzFrvGQ6TeL6jj9zrVb7vcq6cFPljpajw7Y4LwOceUfp6PXhDuw/fwLLhzjxTrXBrHqEka0JkjHTOy+Q9YrRqfz+m2NY9L/9KWG+9iIIvXoeN52JqMI+YFF8JJtIRqy5wsSFoUj/QhroxcB1/4hp9c+y8V4WfYY+zVBNNNWdDuN6uYcj4TuNoW/1wEgmAQwEk9s0CGxROrbXv56yS4FYq1/16ABHu4geFGMdSvALaTrvzp+RVzv91qQkjeJ9UCcBucbhVkEZWg4ULaIcH21E40YfvPJSlIAQFtwM4A2Mb5bD5CAT36uzh4Thy7vrUQ/7appCXEKrDP6OzjSZRP5npuijgX00KwHx1IhZxcdSBIhVZgeCgk26r3sCbExl6g912pZ1kgl6aiBrTXMIwSzIXtjwU+0tA/TU06Kz414TBceF1H/Ccj2NU2s+Ff9WVCWoh5+lFTnxFFcjrlGu7i++pTY3YZ5RV0ThsmkND16fTWrv9Ivi6BRlSqpx9Tqq9ipgBTDK9iRHz5NuwPGGE5hTM6HYbbKP6ECDSMPGNS6PBUqEc8Jfvdu1xBEicJD8c2kEwx4BH0+bQ1pRpSrzWh3VTrqH+bbb7QaFFpKScEs/L2uBr94u6yJh4894jGjkPRQKaACE/opP6B1O5aamBFaBGAPoeuK1QUDvtK5EkV8hm938jUlipc5L/sp2BGikvozfAV63ok4uw2RWCxiC7PILe/rppzD39QlRMNFDX0MJiBOg6+bPBM1NfgnZv1jG9YoBPG3y4o5WNqY4AGcjNwW3jgwx6Bw9BIf4J3JtiNzrRRqsdt94/ie4+HJJMrAGT8spuiWEcrzDkcpekzthuI6HO39wBaxOOOj2X
 IS2stAj4
 WYUcacsyVMJFpLs6UxcHvSnuZUMnnVqQ3z0HtMr4LWOTJ1WUSkCHqHn1RaongViieBWfQSx282nDYCHMCrtgymwuUNlHQQU1wUdbkdWVvgC7rNaLV56DnyKGWB2rKffTdngEnMWdF6sZJH46zKvb3+LNWU2o/8noFaVOh3zzPg9vcN2RDPehRQbwoHqgct6BlE42UZs2IA1pGcTsYRrVU7nxB9TMdDzvqTLQ+gOKtpRsHlVuiq4Vfgcsa83qg2JqYoR1zVpGmjvYlaJquan3b9VvNO+aExGcs9AHofgRRDgdUTQHNb4kvmN/o1aNpqskuHvG2GZQ1r9K/CcA0bksYtyelMUSrRbreVJORDShGzNSoyqu3fhnN4RSuA4r1Efw+XrAkq59+KKkHZQ4aAX4AXcmmOZwTSCmFpvZbKJ0MA7AenmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, May 12, 2026 at 10:17:00AM +0200, David Hildenbrand (Arm) wrote:
>On 5/11/26 17:38, Breno Leitao wrote:
>> When get_hwpoison_page() returns a negative value, distinguish
>> reserved pages from other failure cases by reporting MF_MSG_KERNEL
>> instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
>> and should be classified accordingly for proper handling.
>> 
>> Sample PG_reserved before the get_hwpoison_page() call. In the
>> MF_COUNT_INCREASED path get_any_page() can drop the caller's
>> reference before returning -EIO, after which the underlying page may
>> have been freed and reallocated with page->flags reset; reading
>> PageReserved(p) at that point would observe stale or unrelated state.
>> The pre-call snapshot reflects what the page actually was at the
>> time of the failure event.
>> 
>> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Breno Leitao <leitao@debian.org>
>> ---
>>  mm/memory-failure.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>> 
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 866c4428ac7ef..f112fb27a8ff6 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2348,6 +2348,7 @@ int memory_failure(unsigned long pfn, int flags)
>>  	unsigned long page_flags;
>>  	bool retry = true;
>>  	int hugetlb = 0;
>> +	bool is_reserved;
>>  
>>  	if (!sysctl_memory_failure_recovery)
>>  		panic("Memory failure on page %lx", pfn);
>> @@ -2411,6 +2412,18 @@ int memory_failure(unsigned long pfn, int flags)
>>  	 * In fact it's dangerous to directly bump up page count from 0,
>>  	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>>  	 */
>> +	/*
>> +	 * Pages with PG_reserved set are not currently managed by the
>> +	 * page allocator (memblock-reserved memory, driver reservations,
>> +	 * etc.), so classify them as kernel-owned for reporting.
>> +	 *
>> +	 * Sample the flag before get_hwpoison_page(): in the
>> +	 * MF_COUNT_INCREASED path, get_any_page() can drop the caller's
>> +	 * reference before returning -EIO, after which page->flags may
>> +	 * have been reset by the allocator.
>> +	 */
>> +	is_reserved = PageReserved(p);
>> +
>>  	res = get_hwpoison_page(p, flags);
>>  	if (!res) {
>>  		if (is_free_buddy_page(p)) {
>> @@ -2432,7 +2445,11 @@ int memory_failure(unsigned long pfn, int flags)
>>  		}
>>  		goto unlock_mutex;
>>  	} else if (res < 0) {
>> -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>> +		if (is_reserved)
>> +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
>> +		else
>> +			res = action_result(pfn, MF_MSG_GET_HWPOISON,
>> +					    MF_IGNORED);
>>  		goto unlock_mutex;
>>  	}
>>  
>> 
>
>It's a bit odd that we need this handling when we already have handling for
>reserved pages in error_states[].
>
>HWPoisonHandlable() would always essentially reject PG_reserved pages. So
>__get_hwpoison_page() ... would always fail? Making
>get_hwpoison_page()->get_any_page() always fail?
>
>But then, we never call identify_page_state()? And never call me_kernel()?

Looks like we never get that far ...

>This all looks very odd.
>
>Why would you even want to call get_hwpoison_page() in the first place if you
>find PageReserved?

Ah, I see :)

For a PG_reserved page, I would not expect PageLRU to be set, nor would
I expect it to be in the buddy allocator.

include/linux/page-flags.h also says:

"
Once (if ever) freed, PG_reserved is cleared and they will be given to
the page allocator.
"

So maybe special-case PageReserved() before get_hwpoison_page()?
Something like:

	if (PageReserved(p)){
		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
		goto unlock_mutex; 	
	}

	res = get_hwpoison_page(p, flags, &gp_status);

Cheers, Lance

