Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8929DCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 04:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD8C6B0250; Mon,  1 Jun 2026 00:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437746B0251; Mon,  1 Jun 2026 00:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300566B0252; Mon,  1 Jun 2026 00:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0106B0250
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:56:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E08BC1E45
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:56:58 +0000 (UTC)
X-FDA: 84830134116.01.C44C416
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 567D040004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:56:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="HaUyy/Q3";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780289816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARykLE2mE2vQ/lINLvO895ohlHNvuzpDrMJsV1OaQ6Y=;
	b=CJdpN82sqrIPA7lUAU6M/JYDz/4xY/9B1rYY5zmhfJv/sZaRmuClSYXBtO6xvzvsp2aikU
	JRMjBz5M6H6AqZYSIaC57F4/kcpcUfY46JZ/wgyd25NvHGPjVoWio4lXBGkwSqrehfnXAr
	V+2OiBrGTZYd12PDujhDPqJGL++hjGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780289816; a=rsa-sha256;
	cv=none;
	b=g8uuLkvugH0z9Jwv0F+Rnk6uEehVXxiHf0n6UbWx1dyAdI5NH0fre5i0eV0yeYZ3CmmmLJ
	ZIW2YRUiEoMuqZ1W7XWyuTyqvD0DqU8dG1louFO1lNimCSFWuVQHpWwhR5IWh2aGvIEDQV
	ZYpeZFbrpNN+Mr3L6wOAzdzQ7jxCtZs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="HaUyy/Q3";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 169751E8D;
	Sun, 31 May 2026 21:56:50 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB7FB3F93E;
	Sun, 31 May 2026 21:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780289815; bh=uh04jOx1nBkRcF0Uf+qmlp1xwS9hdzC1jSrjru2+IQE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HaUyy/Q3QQY8LFo0HHWNssQu++Ryy4dWmAHD4fasvlTInFEZouDCQj/vtZBX+P2ZC
	 VtrFIsX83pVwwuosFxTpDu3u1Et3kGCE7TcgrBQlrgqw5orWkEXPYGukRONyM8mxS9
	 fpXC/jZe5fUPVnPzy7oIKCbV0BibT+oV/WFEDKT4=
Message-ID: <9d13d62f-df3d-46aa-8411-4abebb92c35e@arm.com>
Date: Mon, 1 Jun 2026 10:26:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration pmd
 entry
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 shuah@kernel.org
Cc: vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260529111704.1078346-1-dev.jain@arm.com>
 <a62302f8-24ea-4d21-963d-48bec766766b@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a62302f8-24ea-4d21-963d-48bec766766b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: coqn45csjaphkpdkudrmzzfck3ew456w
X-Rspamd-Queue-Id: 567D040004
X-Rspam-User: 
X-HE-Tag: 1780289816-361171
X-HE-Meta: U2FsdGVkX196Gvcxt+oxyVFL+HYmdUhFPMdGXJMCacGUnD9bRPggoeXgDkVy1au8aRgQMnl1yz7VbNyPfUQarRklRbkikTJUkItFKQZL35YZo5Xt7/G52dp6jNLpP5BEr0haeElFKtYgPFes8/QbB3SzPmoF4O4g4Au4TG5Pnne71F2stzBEmyjEfYGkn6GT7QYzwsk3UsmIub4boDCkF9TLCGdASMfpf6BBKD/OrHPOQIN1LD62/ca5ZYYTgGs6Kzk8CY+U2lzOYkpD3qDVFLumjga4Otguoo2VhnJT+HaDYwM8FuN9CnLPWhoIwSKDMuNHJK11oUByffSt8YfvNx4/dc3737E4Ifn0a3GLtCXJbwn/8U2PFpi10s068IsinfceiiOKFYx3V4Y5/iBUJfGTIbfjhy8l8l3yCK5G2fqem7ZZSO1eXFgmFGjyA33rcc0+yJjOSMXO/ARQJrLp8xtapYz1JuvTD2yp8tTNi8y0Tm1+defv15nDgUpKOvXJnfrB7at4l83Z62G+T1z8cq+89V1tv/20sqW6BymtIrMjDymgPjNvCWJAXeyJad8VFGgweeqxBqqsQdNPyMZAjUYrkRMuwD19yrRpRzryjBT+qeX4tbQ9fsjKkywEhe5QfRjfxGyivDZKC84QDuB9Zr8CkrI9DZoDJTFRyiOwFAdwyh1dY76Ot+ADzNDaS6PzNQ79TuRqjcq+Nn8PGMyMYcyHCs6uBP4MThIyxsNyXFZPF7YZ/uaaqe1U52t6ywoM2r4TQdIy+awcC2t+HcQbUF92ko0oO42RYYYHyl9Wm6sD5Gp/1jpUQVFcFCLvo/Z1CloBQClM1suV5dfEWUpbWr8wrXluqjuora6go6w+wEauXD7jDEWVE8mSTTqAHEudN/QoBm6G6FkCpgygi2veaPGp2o2xyp4nIbD0ZuhoE6gpaL5uhk+puE0dSfkZVMLjXPAefUxQ5+nxcPItMIG
 FRpyK8rY
 m4JV+ZMQ41H1GUMUcuOFWJNIp4+V71ncc1U63y29XTMocLFCf5cNh8pul46xonPulRgHLSnYixUSyKOra2g/CgtSeYHwe69PY0TniP4+SqYA22J30VE5nohKy34aBPUjZmNQwc7WF0HDajIaUQcMuDLcPyV4fSWev3x24/SB4RYYZlnt9t2nGiRlGvSFXqpLywrP2FgXl6xT3VWhaXSB4T87WQp3dKITN5hb1yp/LgKvNkOSQ/zq7jHYkQ3sIkcPQz/MhTF8IQ9daCff/iyh/y7+vMRt63ZL1UhvfHt+pJFLY74kySgUAyi8Mqo3di5Rn7IrGRO2aMhN7pE61jADr9xy8s+B+t6FoNwn6cFgqsBKfKE8d6klBUMLyMXjQHpT7Jm3ydHjNOTlTsuMFSzC225EI6UO172sfKcc6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/06/26 12:41 am, David Hildenbrand (Arm) wrote:
> On 5/29/26 13:17, Dev Jain wrote:
>> pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
>> entry. This became false once device-private entries at the PMD level were
>> added.
>>
>> One can hit the warning by patching hmm-tests.c with the following:
>>
>> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
>> index e1c8a679a4cf3..7f0a3384f3c5f 100644
>> --- a/tools/testing/selftests/mm/hmm-tests.c
>> +++ b/tools/testing/selftests/mm/hmm-tests.c
>> @@ -209,6 +209,37 @@ static int hmm_dmirror_cmd(int fd,
>>  	return 0;
>>  }
>>
>> +static int hmm_read_self_pagemap(void *addr, unsigned long npages,
>> +				 unsigned long page_size)
>> +{
>> +	const size_t entry_size = sizeof(uint64_t);
>> +	const off_t offset = ((uintptr_t)addr / page_size) * entry_size;
>> +	uint64_t *entries;
>> +	ssize_t nread;
>> +	int fd;
>> +
>> +	entries = malloc(npages * entry_size);
>> +	if (!entries)
>> +		return -ENOMEM;
>> +
>> +	fd = open("/proc/self/pagemap", O_RDONLY);
>> +	if (fd < 0) {
>> +		free(entries);
>> +		return -errno;
>> +	}
>> +
>> +	nread = pread(fd, entries, npages * entry_size, offset);
>> +	close(fd);
>> +	free(entries);
>> +
>> +	if (nread < 0)
>> +		return -errno;
>> +	if ((size_t)nread != npages * entry_size)
>> +		return -EIO;
>> +
>> +	return 0;
>> +}
>> +
>>  static void hmm_buffer_free(struct hmm_buffer *buffer)
>>  {
>>  	if (buffer == NULL)
>> @@ -2314,6 +2345,10 @@ TEST_F(hmm, migrate_anon_huge_fault)
>>  	ASSERT_EQ(ret, 0);
>>  	ASSERT_EQ(buffer->cpages, npages);
>>
>> +	/* Exercise pagemap on a PMD device-private entry. */
>> +	ret = hmm_read_self_pagemap(buffer->ptr, npages, self->page_size);
>> +	ASSERT_EQ(ret, 0);
>> +
>>  	/* Check what the device read. */
>>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>>  		ASSERT_EQ(ptr[i], i);
>>
>>
> 
> 
>> Therefore, remove the stale migration-only assertion.
>>
>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> Applies on mm-unstable (404fb4f38e8f).
>>
>>  fs/proc/task_mmu.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 1e3a15bf46f4e..58938e62154d9 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>>  			flags |= PM_SOFT_DIRTY;
>>  		if (pmd_swp_uffd_wp(pmd))
>>  			flags |= PM_UFFD_WP;
>> -		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
>>  		page = softleaf_to_page(entry);
>>  	}
>>  
> 
> The whole thp_migration_supported() guard is a bit shaky, right?

I think if you remove this, then you will trigger a WARN_ON in softleaf_to_page(),
for the case of !CONFIG_ARCH_ENABLE_THP_MIGRATION.
> 
> I guess device-private entries currently imply thp_migration_supported(), but
> that thp_migration_supported() check is really questionable and should likely
> just go away (else if -> else).
> 
> Staring at pte_to_pagemap_entry(), likely we'd also want
> 
> if (softleaf_has_pfn(entry))
> 	page = softleaf_to_page(entry);
> 
> to prepare for PMD swap entries.

Correct, and this is done in
https://lore.kernel.org/all/20260427100553.2754667-4-usama.arif@linux.dev/

I think in addition to that, Usama can also remove the thp_migration_supported() check.
> 
> 
> Anyhow, both are unrelated (can you send patches to clean it up?)
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


