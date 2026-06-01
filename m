Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD37ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057236B0253; Mon,  1 Jun 2026 01:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007ED6B0255; Mon,  1 Jun 2026 01:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FF56B0256; Mon,  1 Jun 2026 01:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84DC6B0253
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:11:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B3481C0884
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:11:01 +0000 (UTC)
X-FDA: 84830169522.07.A371AC7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4110180007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:10:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J929W38F;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780290660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkbNeBZoEo4pLZ40QtVxRzSEmJWZh1MR3cAsJSh50A4=;
	b=nLgM9bxDsYJ+D0DtU9vrZ9UhNBDdN+hkPwpRMROn2adBSzieq17AOsRP5GCWVgruUFiMaD
	yepVZol8OJekPPqoTP6lJDhodVDKyXr1ikRH7BVguKlrXLwC6kUbYXUuONVWbyBvHjU5lu
	ug0PLs6RPvaZTOUBQ1P/9Y01r4AHnU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780290660; a=rsa-sha256;
	cv=none;
	b=iqWuaF2MtsflXJKeNfOTVf2hEblRUjTiM/y4SW5mhzXfajXxqAUyJbfsele+5RWaKrdbqY
	gPWAB3EFq8HP9CsWnr07uSjc4EKOsWNEfHDSEHPyR2+DvmzviXXHydPkbDOsp7SurdoBsJ
	bEikpxt/RUX/j9ZpoMsrfZdaD5wAvdE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J929W38F;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F4EB1E8D;
	Sun, 31 May 2026 22:10:53 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF2B73F905;
	Sun, 31 May 2026 22:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780290658; bh=qZykCeIEuuTgb9GlAqiogrswfP/kAWEd1ZLACls/B6w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J929W38FRr+8S8Oxa0hQ6yak8/IEHc9osZlR5XkH1pGbhlKB1uuTqvmLzn/aounLe
	 CDk+nL3SruTivMk06gvDaAOFBff5IzwN6xq844qybUXHsDHIBsrf71bDyQqHV85/03
	 u+ywcuJQxSt41IqLavfixgOexQdtAd5o15/xqPi4=
Message-ID: <7750de96-44c6-47b0-b0a9-dd948fca2e90@arm.com>
Date: Mon, 1 Jun 2026 10:40:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD
 device-private entries
To: Balbir Singh <balbirs@nvidia.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 david@kernel.org, shuah@kernel.org
Cc: vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-kselftest@vger.kernel.org, usama.arif@linux.dev,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260530085413.1270139-3-dev.jain@arm.com>
 <9d8bffb5-bb07-4cde-8a20-8b9b9996f8cf@nvidia.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <9d8bffb5-bb07-4cde-8a20-8b9b9996f8cf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B4110180007
X-Stat-Signature: 4p1xh17czznq1xi3j7f7s1qbmenfk6tz
X-Rspamd-Server: rspam06
X-HE-Tag: 1780290659-142920
X-HE-Meta: U2FsdGVkX1/uVbU6G5lfjyydfDxaK/eLYH/Vqd9/j90M5gyptc8nwO7zPUJCqRhva/j7o/9Of8i/N2UPjZgs6QQEoF4r/WtcuRpPvq+Slnbpg+tNLwpAHgPuKRDtGca5dBH2DR+l0HuooiCTGigmzYVyhxOSGWnPRXFKAzahjYJK6mkWkkm/ZNn5WAZGlHbJMGx4dKPx2XdTCm7DnbU0PbR/pSji4EaOjaxC7vYHAOvyVoqpevD6K+D6VAetsur8iNmJNTvkWxR/X4xSNcjLU/hce2Hj4vYGozHY4uceQ6ZusBsAeZWQATWRMwrA720kwXHnraFdxgF0eq2AJxjv5pVIUrRubJw9BFD8g+Q158nQwFAhQs1kUg+WRFKCt2/rg2Lp7szuTZdGiiAZCOEQG79o29Yr48cYl12HWFYEKdcph4NYmLzRgoeWvuIEqinhDOCX6YwwIt+Na8iEftBYC42FEM6VPbvi8Mdk7oW4rcdnbUdG37XCopJzk2JAyC2vEmV8HCcRA8vR6ZrET9M3a6rDLngMz3xxkT9vJ/2qEv1pNLa8qVeJmje5lFkUju5XLORQuCsEJLfT6RmgpDFZv1VMTqM7neeFuycgmdNPOWZcuwnaSy+bXVzc1ucWaSrOVxL5qHHIPdYVzx4sI3UhHM3soC/EVQZ4vHht5+Og40eMIzCXFfQ7QxBdJOOGAn52grxXfHO2PiHVb3GKuTfOu/DSd/JOYhnCNxKMOvIiS1F6Y5wNtbUAYvOy4r9TTGidpWwS38McrxxFPVeRCQYKcYKDbxJhTcDeJMe+da4BgNWwKPAmMthOpK4qNqjhCVnEJNS2gvR4DTFVfICaRWnCuSCdBQhgT77VWrOP0DAHuDP+2H8Vwu9h7Dvwkf0//YEsiw5p1rR+4COpQP74fUBjvqWvipV6vqfz3iTQ64HLLMWUAkV7ykbPMmFqj6SbBRkAgyuN69OrpCvvwgdfbkn
 FlBOEBpH
 WGr1CgjNMmqz9HVC0kgIkOTLcFwF2PsnBoQw+tGre0FgUqj0kYQC53Q07MkSQiKuG6CA6s50fTWJKA6XA0YFerSW2kB4DUGGK7FnerctGB1z/C+z8Dn/I+iyWv6EKPAM3XGg5rA7MXLMGW2OvDZ8mmURK3RhRcOMGLDCpcAas+MRZCk/FIKepq7SgK5zeMOjjHcFzwvOc1dSVf4G2DTrn4mbNVtKGjPMyZ6KZ5NUvpQLzi+Z1LkGanh5XmCOqRxvzuPMFk4Peu5O3Hb3S2KcQaErFo2e5JnaSQngsmarWWjOEDqvOoUVGzQfze0PjCKCK4EEKRYqC9Uum9zA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/06/26 5:39 am, Balbir Singh wrote:
> On 5/30/26 18:54, Dev Jain wrote:
>> To cover pagemap paths scanning PMD entries, add assertions to check
>> whether a device-private PMD entry has the correct pagemap information -
>> the PM_SWAP bit must be on in the pagemap entry. Before that, we must
>> assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
>> at PMD level and not PTE level.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
>> index e1c8a679a4cf3..d09d4a9081de1 100644
>> --- a/tools/testing/selftests/mm/hmm-tests.c
>> +++ b/tools/testing/selftests/mm/hmm-tests.c
>> @@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
>>  	unsigned long npages;
>>  	unsigned long size;
>>  	unsigned long i;
>> +	unsigned char *m;
>> +	uint64_t entry;
>>  	void *old_ptr;
>>  	void *map;
>> +	int pagemap_fd;
>>  	int *ptr;
>>  	int ret;
>>  
>> @@ -2318,6 +2321,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
>>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>>  		ASSERT_EQ(ptr[i], i);
>>  
>> +	if (!hmm_is_coherent_type(variant->device_number)) {
>> +		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
>> +				      buffer, npages);
>> +		ASSERT_EQ(ret, 0);
>> +		ASSERT_EQ(buffer->cpages, npages);
>> +
>> +		m = buffer->mirror;
>> +		for (i = 0; i < npages; ++i)
>> +			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
>> +					HMM_DMIRROR_PROT_WRITE |
>> +					HMM_DMIRROR_PROT_PMD);
> 
> madvise(..., MADV_HUGEPAGE) is not sufficient to guarantee that the allocation
> was indeed converted to THP. Might be worth using the kpageflags interface (but that
> requires elevated privileges) and then KPF_THP? Otherwise the HMM_DMIRROR_PROT_PMD
> can be a miss from time to time. One other option is not to assert, but to check
> and inform?

I'll then use the existing check_huge_anon() to assert that a PMD THP got allocated.

> 
>> +
>> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>> +		ASSERT_GE(pagemap_fd, 0);
>> +
>> +		for (i = 0; i < npages; ++i) {
>> +			entry = pagemap_get_entry(pagemap_fd,
>> +					(char *)buffer->ptr + i * self->page_size);
>> +
> 
> If this is a THP entry, do we have valid pagemap entries for offset of i * page_size?

Yep we do, see the populate_pagemap label in pagemap_pmd_range_thp.

> 
>> +			ASSERT_NE(entry & PM_SWAP, 0);
>> +			ASSERT_EQ(entry & PM_PRESENT, 0);
> 
> Nit: You can use PAGEMAP_PRESENT()

Okay.

> 
>> +		}
>> +
>> +		close(pagemap_fd);
>> +	}
>> +
>>  	/* Fault pages back to system memory and check them. */
>>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>>  		ASSERT_EQ(ptr[i], i);
> 
> Balbir Singh


