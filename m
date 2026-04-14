Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF27AF9D0C8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFE36B0092; Tue, 14 Apr 2026 08:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6C76B0093; Tue, 14 Apr 2026 08:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4196B0095; Tue, 14 Apr 2026 08:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1FEA6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:00:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 745E01A055D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:00:21 +0000 (UTC)
X-FDA: 84657018642.09.BC1F8AB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 644CD180012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:00:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EVmT2dzH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776168019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3fAK3SKUUXtqAgfTBpOZX2mQTuTInTpWuuKpa94+FY=;
	b=VZSVBb/pOxjrf1an0xGH+MPXvsKi5WjUTehrugcN0uEn8kHndpUyZXkvu5n3H7dZwgtQ1z
	FtANAincjKB8J/LvIA0Uc/bCYJsxSiepqsUZWZ2ZmQacJiBONgp0GlmN1YVXbAz56nBID/
	HQ9TcZtRD3Ih2NjhWUzSBqG+k0/JLCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776168019; a=rsa-sha256;
	cv=none;
	b=dY4lnQFPqrzs1kFCqJGQ1oRQj5YFP+YzxvJStx/6X5Hp1mpTmbQxInyNJAVnjB2nx0eSt0
	+NvtCXNXaVtfYN67a2yP8U+oPakpnRTReGzO8EOG1QtVXMIciR0+P+ep9czUmsiN8zmbMM
	vZNErgADooMxY5NLBSN06XEB2wvJSsQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EVmT2dzH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAF404ECA;
	Tue, 14 Apr 2026 05:00:12 -0700 (PDT)
Received: from [10.164.148.48] (MacBook-Pro.blr.arm.com [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 205E33F7B4;
	Tue, 14 Apr 2026 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776168018; bh=n0FuSTRAL+hNCZiTzx44xxGhs7sDE7lq5mpQ894KpuE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EVmT2dzHsZucBiO1iVU5bKVRILDszlR629YATDHni3fQxwJeEmAEvzfmQQXjQuwXP
	 sVIr2+TDC8q/LHEjqJymV5mAr63YnSq3HLVqkPj7LjL7qDcgxsd5wfVOndGGOlOqKF
	 IrYdvk4t80VVypImjb3+Uwy20gJ/UeZ63u5dIC2g=
Message-ID: <f69cfdac-2718-4a1e-b00c-3c751716799a@arm.com>
Date: Tue, 14 Apr 2026 17:30:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: David Laight <david.laight.linux@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, shuah@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
 <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
 <134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
 <20260414104712.2b634741@pumpkin>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260414104712.2b634741@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 644CD180012
X-Stat-Signature: tjnpuctinrkd9qk6af94hbakey1sezhc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776168019-818500
X-HE-Meta: U2FsdGVkX19LAzAIDmTzw//0WqtbpuCgj+0OGwAXvuy37QVu4TaXxVNtCtMfIR4EwVxHlb2CYb0nGi49sa1ngR9NkBFZEHBRjhIYVU4c1z99YyjHJQHilSmqBwVqP7R+plix7g3Of9d/Z0SPF9iCWoKDRQyDihIg2Skyi8+H1YPXjKSx0C7lPXOKlGzIeQA5V6H1iJrEhK4GLfTvGigUw9IXCtIBcWbaCeZmEukk2T2uFKdciK0yjNpfpDwEdazTOAC1gI1k7OPmPNwaTscC6eCkATEgfN9+9loxZYQGFuPHInrE/48RnAxMqS5DCo/HK+fBT7U9jgAYs2X+OTm1t8zzoghmABdnY1KgZNyJDulHg05Q0uBf7V5HPdrF/pkHyXjV3U30qBx4ZI/2sT7PgmuI9daeRnz92YWB/Hq9gyIp/orohWAlb7yuDMtMPX3b05KYU9m89h9fr0gEmJwtOsPu2RBOitLL4+10tNwDdjTyHwkKfokj47UzxK5Iyw87W+xan/zSu5+vmgh5obW/NQ+CYv3dmW2vqQXjGkfKp2rYr8BT76mgOJWjntb/onw6kYLbxt+GQ50akmThEgLS8PY9FulFWNDt6d1P1AJ6iwRV/OzwCkNldrNYtHpUo2NnheCw7J91mm+jzGcX8VqaskF1YUMNOO4t1ITlErp1Ldy/CiSaxAZ6TM1GQHE5hNuH2IICRxLQBqE955lOosKXh767/ABuXWkwLdixgv5lD01VaBL90v+FXe4NKtU5nJHaodVANv1U2TXEMtpTkim8Vk4vcrOBTGy7te1bJUzPIqvLLXJ4Gl8KWvst9r6k9twoGBYksPNVAvpa1n3RvUVKQ6HVnWmAftYJEnvWiocoQmpLnkoqajgu3ESfjlLn1Tni+JDTYx/Muo7TUES6pA+boQDhpeeRWoatxaDhBKFsyB9Np+5i3adFAYy7g0qnN6A4lQldpluvA35YI1Frb0H
 by/CGcV2
 elDXVJPfZBGs9HW74maaeUFFe39pUSMyF9DIlnFDpLYY6uWj3BeSswYUwCJ4PyQAXlSC1mKbAV828mC9RwCJkwHN615jCkMbluQUlIJXjPJCViKGVLyQ+KH8NHT9wPI3Ng/8mkt3ndVsvZx0Dje8mSnF8eoGNP3YaFtsuv2UtG4e5qalVFwaR+NNbI4gUsmYDntdJ5GZeHtD1vd/3XDpE8eCZ3MacfNiqaLJXyAEJp6QcVmzSjDAqgruJDvmCjOBeNia+LcKTo9qZxRAO6kD7GIn2ijF3t5ef2jxoj3sbq/mnpAqFblUtRhwvrarqE8MJyYEKWRPoz48gnfaCHcBuxHs1w5yIl1Kcy6b5ZOYJvoMlEja3Qk1Yf2Xzj6Ek3nhCh1VDHzmkBfFAhfcdaNhOAAGE4yD8yFybLhIf7T4cCanfUgCgJokaVrlNSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/04/26 3:17 pm, David Laight wrote:
> On Tue, 14 Apr 2026 10:01:57 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 4/14/26 07:09, Dev Jain wrote:
>>>
>>>
>>> On 14/04/26 12:57 am, David Hildenbrand (Arm) wrote:  
>>>> On 4/10/26 16:30, Dev Jain wrote:  
>>>>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>>>>> mremap tests") validated remapped contents byte-by-byte and printed a
>>>>> mismatch index in case the bytes streams are not equal. That made
>>>>> validation expensive in both cases: for "no mismatch" (the common case when
>>>>> mremap is not buggy), it still walked all bytes in C; for "mismatch", it
>>>>> broke out of the loop after printing the mismatch index.
>>>>>
>>>>> Later, my commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>>>>> execution time from minutes to seconds using chunkwise memcmp") tried to
>>>>> optimize both cases by using chunk-wise memcmp() and only scanning bytes
>>>>> within a range which has been determined by memcmp as mismatching.
>>>>>
>>>>> But get_sqrt() in that commit is buggy: `high = mid - 1` is applied
>>>>> unconditionally. This makes the speed of checking the mismatch index
>>>>> suboptimal.  
>>>>
>>>> So is that the only problem with 7033c6cc9620: the speed?  
>>>
>>> Yes.
>>>
>>> I'll explain the algorithm in 7033c6cc9620.
>>>
>>> The problem statement is: given two buffers of equal length n, find the
>>> first mismatch index.
>>>
>>> Algorithm: Divide the buffers into sqrt(n) chunks. Do a memcmp() over
>>> each chunk. If all of them succeed, the buffers are equal, giving the
>>> result in O(sqrt(n)) * t, where t = time taken by memcmp().
>>>
>>> Otherwise, worst case is that we find the mismatch in the last chunk.
>>> Now brute-force iterate this chunk to find the mismatch. Since chunk
>>> size is sqrt(n), complexity is again
>>> sqrt(n) * t + sqrt(n) = O(sqrt(n)) * t.
>>>
>>> So if get_sqrt() computes a wrong square root, we lose this time
>>> complexity.  
>>
>> Ah, thanks for clarifying.
>>
>>>
>>> Maybe there is an optimal value of x = #number of chunks of the buffer,
>>> which may not be sqrt(n).
>>>
>>> But given the information we have, a CS course on algorithms will
>>> say this is one of the optimal ways to do it.
>>>   
>>>>  
>>>>>
>>>>> The mismatch index does not provide useful debugging value here: if
>>>>> validation fails, we know mremap behavior is wrong, and the specific byte
>>>>> offset does not make root-causing easier.  
>>>>
>>>> Fully agreed.
>>>>  
>>>>>
>>>>> So instead of fixing get_sqrt(), bite the bullet, drop mismatch index
>>>>> scanning and just compare the two byte streams with memcmp().  
>>>>
>>>> How does this affect the execution time of the test?  
>>>
>>> I just checked with ./mremap_test -t 0, the variance is very high on my
>>> system.
>>>
>>> In the common case of the test passing:
>>>
>>> before patch, there are multiple sub-length calls to memcmp.
>>> after patch, there is a single full-length call to memcmp.
>>>
>>> So the time should reduce but may not be very distinguishable.  
>>
>> Okay, so doesn't matter. I agree that we should simplify all that.
>>
>> The exact index is irrelevant. Whoever wants to debug the test failure
>> could modify the test to find that out. It's one of the tests we don't
>> really expect to fail (often).
>>
>>>   
>>>>  
>>>>>
>>>>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>  
>>>>
>>>> Fixes: 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution time
>>>> from minutes to seconds using chunkwise memcmp")
>>>>
>>>> ?  
>>>
>>> Not needed. 7033c6cc9620 does not create any incorrectness in the checking
>>> of mismatch index.  
>>
>> Yes, agreed.
>>
>>
>> I would suggest to rewrite/simplify/clarify the patch description, not
>> talking about "buggy" etc, focusing on the simplification.
>>
>> "
>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>> mremap tests") validated remapped contents byte-by-byte and printed a
>> mismatch index in case the bytes streams didn't match. That was rather
>> inefficient, especially also if the test passed.
>>
>> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>> execution time from minutes to seconds using chunkwise memcmp") used
>> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
>> the problematic index only if it discovered a problem.
>>
>> However, the implementation is overly complicated (e.g., get_sqrt() is
>> currently not optimal) and we don't really have to report the exact
>> index: whoever debugs the failing test can figure that out.
>>
>> Let's simplify by just comparing both byte streams with memcmp() and not
>> detecting the exact failed index.
>> "
> 
> ISTM that if you get a failure it doesn't really matter how long a
> second scan takes.
> So a simple byte loop that reports the offset and data of the first
> error and counts the number of errors is more than enough.

You are right in saying that it won't matter how long the second scan
takes, but it also doesn't matter what is the mismatch offset : ) so
let us remove some code while we can!

> 
> 	David
> 
> 


