Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B460AF34C7E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96DA6B0088; Tue, 14 Apr 2026 01:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E736B0092; Tue, 14 Apr 2026 01:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB1E6B0093; Tue, 14 Apr 2026 01:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE6EF6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:09:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7280216041B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:09:34 +0000 (UTC)
X-FDA: 84655983468.05.8C24F59
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 292D240005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:09:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h+zMivZa;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776143372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw//WfVzYCVqE8TravtJdFEvuG2akkia0sEb57oFa/E=;
	b=QVJgfIuPjDHgNG93arSMLQNARqia7B8FY66o25xCs8kaAMLRDnof8CsR/wm1ciNd7Ebhy1
	IV1Uz9eqLba9jLkbeq8/yF8t7RgejgNN0klwPp4x8jHS3OySq9SSuv29K716DFgZKWkdWd
	bjEw+Jmbclo9wQ5RZuDMCRofNjE9TgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776143372; a=rsa-sha256;
	cv=none;
	b=cxb9xUJwiiViUaAJWhkw3JNk0kwJ0PynKdDj6P4dPDkvkce2verOUFgHxY6/C4sNLrCEN2
	t1iU4mGQ+ezkT3v/8eEEoxN0Fl51aBaJbkJ19V11sHOBxUw33mvKU47edhHBHe7PiXijPF
	M1Ah82m+p6GkIT+GIesp+ZSZErVW3M8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h+zMivZa;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 586194EE2;
	Mon, 13 Apr 2026 22:09:25 -0700 (PDT)
Received: from [10.164.148.48] (MacBook-Pro.blr.arm.com [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B9E93F7B4;
	Mon, 13 Apr 2026 22:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776143371; bh=bMLXuh2nFkKLo/z+idXyRjTafBVLLyWtKePx463V+gE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h+zMivZaaKvGn9QCaP2IWTEEDcneKP3DW5Vaq7DlEi38jyaZAxvN9sORQZx+VuClo
	 J6XITjJLgPF77FcNi1VGrtbkinX3ZFcbDfDhbD3uabIwhtO6EcrjkrceIJBlEDpZ48
	 t9m6Ii6td49dDnzBwpcTzMkqXgFCHRfs9Y3jV3WY=
Message-ID: <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
Date: Tue, 14 Apr 2026 10:39:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: zmxx94k643urqsjxgsg8sxqha4nzf6gj
X-Rspamd-Queue-Id: 292D240005
X-Rspam-User: 
X-HE-Tag: 1776143371-609449
X-HE-Meta: U2FsdGVkX1/X0mngLIL6niWuQZjrfaV/ljhj1uXufEmTuEs7QjJJiU2Nrqc4BxkBaG4Vf2f8mRksEOYNHCxf8bkIA6n/ZB+3M1kCZiq2GmYnemB+CDGNArM0J/VKVjpp7MCXGKSoiLUkMiJYbRG/V4eMBflpnGwtO16NALK1aK2w+fL6+NhK+Cqw8flE9niz/CXQpUlrojWWG5jGpjqMPYGB5sLloornGJ11fyzqi/grPfHwYZhtp/k75O28zkqtb83RKuGoWals09q4hkiehqVFD121MMBMPu4sUeypFqSvHhY3DVlPJa2pAhsjC4CLfDazlIfnIuQoynCniyqiBpaI4Po69IFTEyMxVVbLZ2evFrMbR+Omws4Im3smQDo6hX0jpvlrs52vYHhJU7KtjJ9XQZM2Z7ej5qfsRjzG7uwqPMSLIWVrl6uBuo5pikqhnQkOOFbI80X+Z//xUngFl64H805cX8ymNPTFcoZA6wyfT6fkKDKcBxW2Z4KbE+o5FtpvHmQWDNcfdx0IuwqSK2BoQx/jcn2JffdzCM2RgfEQc7LytSXY/aQItnu7Qk/1GjCPbhHixWGFZ/os3UmmqlpeHBkxS90mQxnok1ZXTrIphbVWR7ddJq5N1NbKOLcfWmkgzlRhqbQreE5+nb+jIDNhWDxjGEPCrbjf5k1QTGjypoPw7aycIl67xqrONuiS4jqJW7lvbl44/0HjtOGD2om2oGIFAvAivT60okncZGW3xQbMmcihlD5L1FKaEO+r8CQVeA/JbRXOehV+h/xc1nvUJZaCoHG/l71pBkksihZrRHO7H5qmkQuIcHSegsZTL0mhKA+XRMBpXk91hOSxAQtxmIqBaB5Pf7q21ZipEBrlLl0u3w/+tchVKonf2J61hnRqdst4uxWETLGDAFiyZq5uAd31ZOQY/2WkJvGe94XoTGQH5hTlV3ZLprgAPGWIveVQ1t+kPleMONYPv0p
 OI6ux9LY
 z1Ocubi3bFOXW1+4GFIE+4207pMfJslCAHb5ZLW7tEHr69lAWEJjeLMYJbvjXDUuYlQczFyG591uw066cLHhruchFCZsMEQTfZZ/QQ8iZ6fa5cdWeYX3ttoOq7RubiCsN+VQ1APAE46+ff9+mpD8B69iCMvZVupOoAIYGkxzwtBbAtcsPPeGTD8Y22EMEEKvJNaBEBr0iyoDirsb8Ztb9IXh8NdkFmaZUQJWZ6hYxA6jpNrnt/C6dwuZRHShySCaCXhJF1X07s8+xDuuMzJAZu7pKnRProKB1mehsWjJPPoAzuzmTLseXIouZIWOapwVlX4N1R28G63l9YqoN95xQPjvMeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/04/26 12:57 am, David Hildenbrand (Arm) wrote:
> On 4/10/26 16:30, Dev Jain wrote:
>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>> mremap tests") validated remapped contents byte-by-byte and printed a
>> mismatch index in case the bytes streams are not equal. That made
>> validation expensive in both cases: for "no mismatch" (the common case when
>> mremap is not buggy), it still walked all bytes in C; for "mismatch", it
>> broke out of the loop after printing the mismatch index.
>>
>> Later, my commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>> execution time from minutes to seconds using chunkwise memcmp") tried to
>> optimize both cases by using chunk-wise memcmp() and only scanning bytes
>> within a range which has been determined by memcmp as mismatching.
>>
>> But get_sqrt() in that commit is buggy: `high = mid - 1` is applied
>> unconditionally. This makes the speed of checking the mismatch index
>> suboptimal.
> 
> So is that the only problem with 7033c6cc9620: the speed?

Yes.

I'll explain the algorithm in 7033c6cc9620.

The problem statement is: given two buffers of equal length n, find the
first mismatch index.

Algorithm: Divide the buffers into sqrt(n) chunks. Do a memcmp() over
each chunk. If all of them succeed, the buffers are equal, giving the
result in O(sqrt(n)) * t, where t = time taken by memcmp().

Otherwise, worst case is that we find the mismatch in the last chunk.
Now brute-force iterate this chunk to find the mismatch. Since chunk
size is sqrt(n), complexity is again
sqrt(n) * t + sqrt(n) = O(sqrt(n)) * t.

So if get_sqrt() computes a wrong square root, we lose this time
complexity.

Maybe there is an optimal value of x = #number of chunks of the buffer,
which may not be sqrt(n).

But given the information we have, a CS course on algorithms will
say this is one of the optimal ways to do it.

> 
>>
>> The mismatch index does not provide useful debugging value here: if
>> validation fails, we know mremap behavior is wrong, and the specific byte
>> offset does not make root-causing easier.
> 
> Fully agreed.
> 
>>
>> So instead of fixing get_sqrt(), bite the bullet, drop mismatch index
>> scanning and just compare the two byte streams with memcmp().
> 
> How does this affect the execution time of the test?

I just checked with ./mremap_test -t 0, the variance is very high on my
system.

In the common case of the test passing:

before patch, there are multiple sub-length calls to memcmp.
after patch, there is a single full-length call to memcmp.

So the time should reduce but may not be very distinguishable.

> 
>>
>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> Fixes: 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution time
> from minutes to seconds using chunkwise memcmp")
> 
> ?

Not needed. 7033c6cc9620 does not create any incorrectness in the checking
of mismatch index.

> 
>> ---
>> Sorry for sending two patchsets the same day - the problem was made known
>> to me today, and I couldn't help myself but fix it immediately, imagine
>> my embarrassment when I found out that I made a typo in the binary search
>> code which I had been writing consistently throughout college :)
> 
> :)
> 
>>
>> Applies on mm-unstable.
>>
>>  tools/testing/selftests/mm/mremap_test.c | 109 +++--------------------
>>  1 file changed, 10 insertions(+), 99 deletions(-)
> 
> I mean, it certainly looks like a nice cleanup.
> 


