Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED19ACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD2C6B02ED; Mon,  1 Jun 2026 05:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E706B02EF; Mon,  1 Jun 2026 05:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE62F6B02F0; Mon,  1 Jun 2026 05:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE3E76B02ED
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:14:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 856431A05D3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:14:40 +0000 (UTC)
X-FDA: 84830783520.28.78AAEBF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E9F240009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:14:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NJ8wPokP;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780305278; a=rsa-sha256;
	cv=none;
	b=jJjfT01+JVF4h0Xxm7AL4XCyJUnKnBCkZa1Vh5shgfDyZenVyckHV+k1YCYuCHHjJQmbN5
	s95T5UIi5Xxdq3Q1nopoVzv82P5/3ZLVvCQSL0c1D6H1mferhQctRUEdw9Dj2BzMKjSiyP
	R0T8mBwh7KLSixaq7DR/0JTAvMy0NdA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NJ8wPokP;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780305278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEazZgXX6yfrNi9YyR3tNhoYlfRoEfti9CQyvf+Sf3I=;
	b=fXbCmuAZdkW39Muc6cGkcfqYt1Ds7KTC2ZK+qyDaRSNC3LBX/OurtihfzxnsgwTYWjZprh
	SX2G7EnZEM4VaWA5vWC+lEJwHIF3M6Vgm6pnCFgBfZP8p6ko/4K+sdpXLdYSQ/vHhy2Ba2
	WZ2a90K0coBS9iSyhXtvbT+NBKhfws8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 469EA1FCD;
	Mon,  1 Jun 2026 02:14:32 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9CC13F905;
	Mon,  1 Jun 2026 02:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780305277; bh=h838crh2cFkXrbwjE1UKSICfRuEgy6SwChiZVz3UvrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NJ8wPokPqFJEjcJHWuI8Z9iNFV6h7LrUyx5sTA83Y42dAgIBjNpOx+u3wuWvef+Go
	 u951O7Qq51z3n+IinzUAgyxUDkGVGxdfL8DQthXmjCFxcQMzkIrJlmMcouvOZto6Em
	 Btelm0kthvpRg58KLSUeGmJwfZeXZTOGf0Tg/TrM=
Message-ID: <9d861614-2c84-4390-a34f-af7bb42aad1b@arm.com>
Date: Mon, 1 Jun 2026 14:44:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD
 device-private entries
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, akpm@linux-foundation.org,
 liam@infradead.org, jgg@ziepe.ca, leon@kernel.org, david@kernel.org,
 shuah@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-kselftest@vger.kernel.org, usama.arif@linux.dev,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260530085413.1270139-3-dev.jain@arm.com>
 <9d8bffb5-bb07-4cde-8a20-8b9b9996f8cf@nvidia.com>
 <7750de96-44c6-47b0-b0a9-dd948fca2e90@arm.com> <ah1EI_JfZYop7VF8@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ah1EI_JfZYop7VF8@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E9F240009
X-Stat-Signature: f85zy4cx7xtsdjri54eta4axnazygs8y
X-HE-Tag: 1780305278-143812
X-HE-Meta: U2FsdGVkX1/bbC6mVBsV1qKPp4fIgIlGEigTgHmtKnTQChPJ0CooJrL8SVG33vg96TtwviC3q/vAguqDwd+JKzes3dmHRR2eSs99sDQ5Q0XE4K/us2ti3YnY1+e9qq5/dntnn0+iQOLdP52do6J66eyRF0R4vS0wVftQHQls/8vBtQLkzlO76BlAk6Va5vIaDjlYu4OrMhfVOxj4ziNVW/F+5ntLw0YaXqPQwZ9cDAflq8pGGYfirj29iUyLvi4mZqf5UmxWZ0uU39tUR5tGVceABZjYvegD8w4W4tbS7UJXkf6+WpCaLcUBOugkgx6jzqV6j1iDzFpE+pTW97ZgV6X4IFZ635Bi9BzAYFGgjwIu3B+HVPeKXozVXzPamHBOPNUwzC1M6kCDr/5vLfSncFdEY8xpvkHMccTMifwY8Gg3OY0zE2BY2DsqhATMh2J+XuZVa6/bRTsdTt6gjegoCH4iOjulL8OpjWeQNIekI6SZrv5h6h26KM7ORsDq98lhD4S0qIfml2mvb/hCwBK7mlHm3ui7kF73xOWBf5c2l51xP9rLnxAbgnXqSCWI03Q5UVfMQQv+hiP6/bYDRZSezXt21k5Hev6eMZRjZsxlBZPZrkjy7M+9clCXU7Ze8r/UlfVxRq/Zm0O5sXSXJVXA/vOIEFeUTzto+X9rXVExksYiRGPTfDGiLmOz6fXQsCbOnUJ0n2zljocawu5vXFQS30cmbKyfrjNmKy9BduVVVwiiFBhmGrlumncfJmGAbEFfBp83h/KbgL4LZJjUGxStU7HTOPkTnTNcptBUWjy2gnapuw/DqY6KdwnFhod6hjDNHI85ccDzCRgSG7EDEgu/1AfMTN5oD3dO4kghKeSxwE8LBHZLuhfhUDIgPGx2yEo7PmA0grVbEb+5LKbmXI8K8kjkL0qVz6cJxth3UrN1fy6756y0SdNlEwNzJJ9kZGlnGuwEnSSEbo6iL/HoIA9
 xTpG8SQu
 +M57sUXs7RVqZR+oPLxnJBRW/Tc7eH5CeR6sZvj05UoYAU7cdjUSOowQ/+SjF+dIQ7w/fLWTu4yTNZwteSSUihNEPpgZeNgrVRcX/ZLZaWZW+9TOinimME2ErHB3TUQ6fdyn8Xa+7vbP5DoVme88U0zmQ9F3CHapujK5qYQt3ZiaWCTjW+WVvmJL4IE03Y9vII1Rk11OKeF3+br4W877jy9AOo4vUCs11UL6Ny6HNHTnSaCI8le+lHdpz5fidYi0hcbFBVvzu3oEIt7va65W/B+uiPkiuCmH4bgDhmY40I3YQpr8Lh2NtxGNkNLfa2G20tHkv2MNTwmSqQ3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/06/26 2:05 pm, Lorenzo Stoakes wrote:
> On Mon, Jun 01, 2026 at 10:40:48AM +0530, Dev Jain wrote:
>>
>>
>> On 01/06/26 5:39 am, Balbir Singh wrote:
>>> On 5/30/26 18:54, Dev Jain wrote:
>>>> To cover pagemap paths scanning PMD entries, add assertions to check
>>>> whether a device-private PMD entry has the correct pagemap information -
>>>> the PM_SWAP bit must be on in the pagemap entry. Before that, we must
>>>> assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
>>>> at PMD level and not PTE level.
>>>>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>>  tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
>>>>  1 file changed, 29 insertions(+)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
>>>> index e1c8a679a4cf3..d09d4a9081de1 100644
>>>> --- a/tools/testing/selftests/mm/hmm-tests.c
>>>> +++ b/tools/testing/selftests/mm/hmm-tests.c
>>>> @@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
>>>>  	unsigned long npages;
>>>>  	unsigned long size;
>>>>  	unsigned long i;
>>>> +	unsigned char *m;
>>>> +	uint64_t entry;
>>>>  	void *old_ptr;
>>>>  	void *map;
>>>> +	int pagemap_fd;
>>>>  	int *ptr;
>>>>  	int ret;
>>>>
>>>> @@ -2318,6 +2321,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
>>>>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>>>>  		ASSERT_EQ(ptr[i], i);
>>>>
>>>> +	if (!hmm_is_coherent_type(variant->device_number)) {
>>>> +		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
>>>> +				      buffer, npages);
>>>> +		ASSERT_EQ(ret, 0);
>>>> +		ASSERT_EQ(buffer->cpages, npages);
>>>> +
>>>> +		m = buffer->mirror;
>>>> +		for (i = 0; i < npages; ++i)
>>>> +			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
>>>> +					HMM_DMIRROR_PROT_WRITE |
>>>> +					HMM_DMIRROR_PROT_PMD);
>>>
>>> madvise(..., MADV_HUGEPAGE) is not sufficient to guarantee that the allocation
>>> was indeed converted to THP. Might be worth using the kpageflags interface (but that
>>> requires elevated privileges) and then KPF_THP? Otherwise the HMM_DMIRROR_PROT_PMD
>>> can be a miss from time to time. One other option is not to assert, but to check
>>> and inform?
>>
>> I'll then use the existing check_huge_anon() to assert that a PMD THP got allocated.
> 
> Would MADV_COLLAPSE work here?

So MADV_COLLAPSE requires at least one page to be faulted in (or precisely,
HPAGE_PMD_NR - khugepaged_max_ptes_none). So I rejected that, but now I
noticed that we are initializing the buffer first.

So yes I will use this, thanks.

> 
>>
>>>
>>>> +
>>>> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>>>> +		ASSERT_GE(pagemap_fd, 0);
>>>> +
>>>> +		for (i = 0; i < npages; ++i) {
>>>> +			entry = pagemap_get_entry(pagemap_fd,
>>>> +					(char *)buffer->ptr + i * self->page_size);
>>>> +
>>>
>>> If this is a THP entry, do we have valid pagemap entries for offset of i * page_size?
>>
>> Yep we do, see the populate_pagemap label in pagemap_pmd_range_thp.
>>
>>>
>>>> +			ASSERT_NE(entry & PM_SWAP, 0);
>>>> +			ASSERT_EQ(entry & PM_PRESENT, 0);
>>>
>>> Nit: You can use PAGEMAP_PRESENT()
>>
>> Okay.
>>
>>>
>>>> +		}
>>>> +
>>>> +		close(pagemap_fd);
>>>> +	}
>>>> +
>>>>  	/* Fault pages back to system memory and check them. */
>>>>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>>>>  		ASSERT_EQ(ptr[i], i);
>>>
>>> Balbir Singh
>>
> 
> Cheers, Lorenzo


