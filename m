Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA00CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0856B0266; Mon,  1 Jun 2026 01:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA05F6B0269; Mon,  1 Jun 2026 01:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6196B026A; Mon,  1 Jun 2026 01:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8586B0266
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:49:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34372A051C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:49:06 +0000 (UTC)
X-FDA: 84830265492.25.903A6F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 594E5A0006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:49:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGYTIAjH;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780292944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpqqGQV4/Eyz5S8QpIkBPLCi6r5ufcIpCf3i736CDOw=;
	b=pf1Lu1h777CR3vSFGnPdhxpswqCoQmgxUgj1GyK0KwLSCVNJPfXTj8F+o37r8mwqpJk/22
	XtkUUxv7tCDZV+zfNtRQpnTDkY5HHb/GolVBsfMYXTP4sRZmuSF+A9pphkWh08PX4MZSKb
	Ei4Zjr5TRQYQa79KskPdTSHScZV4fiE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGYTIAjH;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780292944; a=rsa-sha256;
	cv=none;
	b=UeH45Rt0mRXm4MqVyL7hRE3CmltKKFoUHDNfvq9bStUIaiefXxEW0TrvFhGJ9zjR8z98j1
	uOHx/VqdulJgx6QLNO4b0w5vqo3tRz2c+ceb3TjJ7opNZdlPlWoWT4aAjTQoQx/Hycjm1B
	IPTV2vkSwXuCzqghurKSxIBDZaAjCGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 491DB44608;
	Mon,  1 Jun 2026 05:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654381F00893;
	Mon,  1 Jun 2026 05:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780292943;
	bh=VpqqGQV4/Eyz5S8QpIkBPLCi6r5ufcIpCf3i736CDOw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jGYTIAjHQSbrm6posFzuL7i5KjhivxA56qf4ytkcfMVmowfejvF/uYtc6NOBbYWD0
	 xdr6MnmgyF84ZX3Tq5JKdRcwkPQArdGU/W+ZmpBIp7yBlQzR7yCY6KxhoK69TWBB86
	 TLqBdauE4vFalFq8LKceEFBtsVlKVcd4Zlz8/ZAuoH7x/+IYVuy/2aQ08T3oVRlWkK
	 bpC0IihIgOWCzX5N9087um4S+xmFH92NnmF7djFYpC6VMsYB7YGrru+rFcquKim8Xf
	 1Xh4RBPV0v8HNEaB0up4VPITy3L7Jlx+3vs1RMMfOd09LZtKd86ogiZU7FzZn1tNCc
	 hqXx+X45vtIpw==
Message-ID: <e1d8c02d-6c3b-4805-af04-eff9c2ea48da@kernel.org>
Date: Mon, 1 Jun 2026 07:48:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration pmd
 entry
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 shuah@kernel.org
Cc: vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org,
 Usama Arif <usama.arif@linux.dev>
References: <20260529111704.1078346-1-dev.jain@arm.com>
 <a62302f8-24ea-4d21-963d-48bec766766b@kernel.org>
 <9d13d62f-df3d-46aa-8411-4abebb92c35e@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9d13d62f-df3d-46aa-8411-4abebb92c35e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 594E5A0006
X-Stat-Signature: yhsoqz549ape5rfiuu9sutab8bgw8oyy
X-HE-Tag: 1780292944-429966
X-HE-Meta: U2FsdGVkX19tzX+3CuxFoA4XTe2H9Gr9Fa/k1icve627xK8bpPsrgG53M3C4NiAauXnMhVria91HyyH0yPfAOhcpCbrhSweGlmGZZeUdw4SVs8fBCi0MFaZ/Lw/JbU6I/wTCcUX1CT823QW3Uy5MsO6I3pvSjZM5qP8In9FRD/ZfFCOyHAIcclJro23Dc8WtQNRG/7Xcf/FdGyfKZFdku0lgl2Xg00QahKoumeA5OhU2pVyg5Tm43t1UGbWm0DHlTNd9xATIw6vSlEPlN5GyxSjBj4prPRaNbb2WA0yvl88sf3I8vuZbtgqVePs4zSfxKkg4B34NcdLO3yOBTxl52/rcCnWYgLvLGVVxSLpsrGaOXNR47V8tBTcmJf6nl9f1RMk1igIxvBIWc2kWDWo0nq/N3UMFSlF4HJPOE4RY06Jhg6Jf/0wvQLj9g0bCInXXDwPIRqn+h6w25j1JNU1urPRJlUeQGROzB/XkIjmIcq8dEl5gfYc63cao6Tbv/Vura0F6DoHfWFHYvrHEHDM+ikyEQjPVej/G5hCZA9Va9ZlBM9uXEkx3l6uBRI8/P992AnpQW4RJfAVmEVmm33Q8zevj0NsNF7w0UmHiJbXSRUO1AVDW157++SaRcb4/mqbOnMj2geE7Y3+LxsFmH4OuxtB5u2/Nfp8JG1uiOobQi/NGsOh1uf1ParlEf9mhLNlkQxBZF0HObS9Hykom9Rf0BQ1GIX5DY2nsSjaMUzV51I8yNI3fl8KUVcW5qWMuJAban34XwtZzIa9AtRFTR7uD3YPM4MdW+O3VeuH5gP5KHVevBt/xHNLNd3YdzW3VY2iRS98Zr9mvshbUEvcITgRre8B3X2aUTbqqjpcANXmiOei838Pf/jsAGxeBIe4kZnoMS8x9xIaqBZPPSOVmOFtkkP6wphkM9cNe2JfFMEUzH9c8Y9pGngkevaX5ylSpyjZEf1VOArrjSHZI843y1TM
 tZR1LPGj
 qGxsP39aMRjuSnJ0vumQb0S3cM7fh3yOOgWf+XU9dVj2njeU5XuT9S19NFmvdgYdzuKfL0BX4Jpij5z3JNnE7k6qf3q8hvDIBz2xlqwiP5YT7j+sF2/4WZsOSP+9VMJV2EB1SFHn2+OQrRVix8gC2/JmRFPyMQmoYmKA7dvJ3h3DK1AY0U9YCKHkmqKFPsueXVNkofmKH5zuFhCnU0J8hUN3Z8wj0hmS8Xb7TYX//uYjsDX84kib8249VJcsRj8bbVMkoH1W0X80LcsogLp22XOIzVy+I9K49En5cVWDtScs9tjmrUQZxr3ltEoI16rP0AHiyk9uQvs5Y7ka8wYm5J3KbbFAe/bqRD6Q+Qi0VoI95j/Gjx2Fi5s9zuxtUaoiX3ROC8krAJg334myW/1AC2OwbfmFNAR+BHgh1DVqbGQFX56Uyzd3h9D8Lqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 06:56, Dev Jain wrote:
> 
> 
> On 01/06/26 12:41 am, David Hildenbrand (Arm) wrote:
>> On 5/29/26 13:17, Dev Jain wrote:
>>> pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
>>> entry. This became false once device-private entries at the PMD level were
>>> added.
>>>
>>> One can hit the warning by patching hmm-tests.c with the following:
>>>
>>> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
>>> index e1c8a679a4cf3..7f0a3384f3c5f 100644
>>> --- a/tools/testing/selftests/mm/hmm-tests.c
>>> +++ b/tools/testing/selftests/mm/hmm-tests.c
>>> @@ -209,6 +209,37 @@ static int hmm_dmirror_cmd(int fd,
>>>  	return 0;
>>>  }
>>>
>>> +static int hmm_read_self_pagemap(void *addr, unsigned long npages,
>>> +				 unsigned long page_size)
>>> +{
>>> +	const size_t entry_size = sizeof(uint64_t);
>>> +	const off_t offset = ((uintptr_t)addr / page_size) * entry_size;
>>> +	uint64_t *entries;
>>> +	ssize_t nread;
>>> +	int fd;
>>> +
>>> +	entries = malloc(npages * entry_size);
>>> +	if (!entries)
>>> +		return -ENOMEM;
>>> +
>>> +	fd = open("/proc/self/pagemap", O_RDONLY);
>>> +	if (fd < 0) {
>>> +		free(entries);
>>> +		return -errno;
>>> +	}
>>> +
>>> +	nread = pread(fd, entries, npages * entry_size, offset);
>>> +	close(fd);
>>> +	free(entries);
>>> +
>>> +	if (nread < 0)
>>> +		return -errno;
>>> +	if ((size_t)nread != npages * entry_size)
>>> +		return -EIO;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static void hmm_buffer_free(struct hmm_buffer *buffer)
>>>  {
>>>  	if (buffer == NULL)
>>> @@ -2314,6 +2345,10 @@ TEST_F(hmm, migrate_anon_huge_fault)
>>>  	ASSERT_EQ(ret, 0);
>>>  	ASSERT_EQ(buffer->cpages, npages);
>>>
>>> +	/* Exercise pagemap on a PMD device-private entry. */
>>> +	ret = hmm_read_self_pagemap(buffer->ptr, npages, self->page_size);
>>> +	ASSERT_EQ(ret, 0);
>>> +
>>>  	/* Check what the device read. */
>>>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>>>  		ASSERT_EQ(ptr[i], i);
>>>
>>>
>>
>>
>>> Therefore, remove the stale migration-only assertion.
>>>
>>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>> Applies on mm-unstable (404fb4f38e8f).
>>>
>>>  fs/proc/task_mmu.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>>> index 1e3a15bf46f4e..58938e62154d9 100644
>>> --- a/fs/proc/task_mmu.c
>>> +++ b/fs/proc/task_mmu.c
>>> @@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>>>  			flags |= PM_SOFT_DIRTY;
>>>  		if (pmd_swp_uffd_wp(pmd))
>>>  			flags |= PM_UFFD_WP;
>>> -		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
>>>  		page = softleaf_to_page(entry);
>>>  	}
>>>  
>>
>> The whole thp_migration_supported() guard is a bit shaky, right?
> 
> I think if you remove this, then you will trigger a WARN_ON in softleaf_to_page(),
> for the case of !CONFIG_ARCH_ENABLE_THP_MIGRATION.

Right, what I noted below.

Right now it's all a bit hacked on top of initial migration entry support.

>>
>> I guess device-private entries currently imply thp_migration_supported(), but
>> that thp_migration_supported() check is really questionable and should likely
>> just go away (else if -> else).
>>
>> Staring at pte_to_pagemap_entry(), likely we'd also want
>>
>> if (softleaf_has_pfn(entry))
>> 	page = softleaf_to_page(entry);
>>
>> to prepare for PMD swap entries.
> 
> Correct, and this is done in
> https://lore.kernel.org/all/20260427100553.2754667-4-usama.arif@linux.dev/
> 
> I think in addition to that, Usama can also remove the thp_migration_supported() check.
Yes, that one should go away.

-- 
Cheers,

David

