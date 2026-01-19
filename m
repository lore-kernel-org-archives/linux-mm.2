Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECACDCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282E96B0112; Mon, 19 Jan 2026 01:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235A56B0113; Mon, 19 Jan 2026 01:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DB16B0114; Mon, 19 Jan 2026 01:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 031E26B0112
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:21:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AC4913B728
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:21:57 +0000 (UTC)
X-FDA: 84347717874.05.6EA9A46
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 53E4418000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:21:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768803715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Wjb9fkvBIiqY+RLfUxYtM1kjyOd2PQIyJqlBw3bXqA=;
	b=YNVjBCtqBIfk1wz5AtCTOkPY2v5Wt++T6nx91CdcEjP+TaSY+3rPS+8HO9L1B5MAZ/An9A
	WcCw7HvcUOgZ9i6gcMytaGRTYMMZ6R+Vd21Gl9/I2XLgR+0OgNW5XDLyRd3/Bwhdj2eCqB
	Vx+bQfNXuqDWLXpgc9OkMfhADwZgQ30=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768803715; a=rsa-sha256;
	cv=none;
	b=7KcZ1rsL1XyXwKlsD3CdJjW8gXzdeHkKUaLSHgq1anSZw84FrVc/cjJj4scwm1OjZjztG3
	fP1cZL6QRw1dIeXObCGmDrRVbXaf8Faic05ube83GQw1+0x7GqYKp6UPYLLscUaNwfjt93
	/0l+4sAjLsQsyTig8+6cUq9XQbI+hGs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8869A1517;
	Sun, 18 Jan 2026 22:21:47 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 615313F632;
	Sun, 18 Jan 2026 22:21:50 -0800 (PST)
Message-ID: <e71ffffc-8623-48d6-88b7-4684af4534aa@arm.com>
Date: Mon, 19 Jan 2026 11:51:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dev Jain <dev.jain@arm.com>
Subject: Re: [PATCH] selftests/mm: remove virtual_address_range test
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 aneesh.kumar@kernel.org, Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260116132053.857887-1-lorenzo.stoakes@oracle.com>
 <5957ae48-87b8-4981-a6f7-8113141e7b6b@arm.com>
 <f44fdda0-80da-49a6-a9dd-75b9a46e1f76@lucifer.local>
Content-Language: en-US
In-Reply-To: <f44fdda0-80da-49a6-a9dd-75b9a46e1f76@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ujgwfcy9at1adum46n7x9di5e4kia5gq
X-Rspamd-Queue-Id: 53E4418000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768803715-495765
X-HE-Meta: U2FsdGVkX19CforvUN4zxXxAcSrAKLhfGYKaksE/MOnKJgR0av4jIdSP+GpDLO5rORj30mLlQU/HI1iRdcvDGxTFQYOlKSsq3JBXI45bC/EekWUN8U6t4g6SWlSKfXm3Y3Ewnr73MXK4KnwbHznC3a8wgJkooAPi4sJvPRJ/B5mUrBlanyzOKOBKyYjhnCNAzvoVQjG0gyUjTjlu9YMF3A6CU5VYBXaYhVQvE/8DpEUUiVHt7B/R6mqoeqw2Nd9K4zAb8oEFR2wcQId/TKSGHLWgsLRJQmuxg+PmlBFWJ0Wv9b7/VsplsMWkR/M40mFUkf/y8+Rjfra4Rjawv96ZVavuewjNfd34F0qcgHPUdYL4oPC/vx0ms6y9ypDTR7bNOM0Z4FYlGsYp7GlXRZJwTbGDVuKFn3nIdUxhoTnWkIDx1d5VxZJ1EM/J4QqS2M+SUjA7p5/iqwoH8BRt+TCPJyxpHbkPZ54zaaWV0datlK+SFF9H9+S1IrhD6cGizp0Tofu5ychKFym1LkqOeywk6fFqNZdG59Ok8RqzkSuc5mQYVMs6FpAfNOnZut4JKslVewpGmvnxSB9y6JgpbBswlXTn4dT+bryrhSVU6PVyMRUkMeycDSx4gyLU9tYuk8nhuTpVjafXs7RKydwoXNpsjQEyw9UKQ2Nva6GOMvqWeZtyb72Qj7eHniVn0uY2wMV8byVNZuewSg56ByY3xlf2V659qH/E9Twa/YB+5YkbZrNyA3E75Lh3GnTs6sELBTpI+R/okXr7LAJAZpVmFAs0QjG3Tds+p0BG9WhVtT9TGyYc2cK6Id0UUhikGgXS+TwifXXs/4qVkxrdJPWbUpub5/IFPHUyuWHCM3Xcg6z12WGJW+SK9xPGzH2CdBEkHbA5cNAZyVDqCGapr/B+8+m9XKOIoPMLWKu0bgc+cg5YaAMgaN69aVU8jaZZc7liU48zoHi0cCeNCE46f0jVhyy
 qUXvoc7q
 MEYBvNKQdGSAh6qbqizIWAW/m1dKowgsCfJdYymQ2UT7NVL0fYyeFO5r7OH/AGnZHgCu4tGf+E7c5yFKaOEVc11YXuYEcs5QijTQVKNYcfquNBmQcZWh4hM52kVheRXaFl+PNmN1K47IYHCd8h5Xq0+vvQqI/j+7LlTsKMBfCw8gKTuwLMtXtj8Apgt8N9Xdb7gmwetlND7jtzq9xM2jhyFkOfflryuC2hnn6WMTb9DmVp1AXl2+YIKWqW+IFAVp7GPiRoOeKLnM1yRaqqSvvyIoTkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/01/26 6:28 pm, Lorenzo Stoakes wrote:
> One note - Dev please wrap lines to 75 chars as per standard kernel
> practice. It's super hard to read your mail with unwrapped lines, thanks.
> On Sun, Jan 18, 2026 at 01:25:25PM +0530, Dev Jain wrote:
>> On 16/01/26 6:50 pm, Lorenzo Stoakes wrote:
>>> This self test is asserting internal implementation details and is highly
>>> vulnerable to internal kernel changes as a result.
>>>
>>> It is currently failing locally from at least v6.17, and it seems that it
>>> may have been failing for longer in many configurations/hardware as it
>>> skips if e.g. CONFIG_ANON_VMA_NAME is not specified.
>> True, the test gets skipped for me since the mark_range function was added.
> This is underlining the issue with this test.
>
>>> With these skips and the fact that run_vmtests.sh won't run the tests in
>>> certain configurations it is likely we have simply missed this test being
>>> broken in CI for a long while.
>>>
>>> I have tried multiple versions of these tests and am unable to find a
>>> working bisect as previous versions of the test fail also.
>> Does the test fail for you even for commit 13e860961fd4 ("selftests/mm: virtual_address_range: Switch to ksft_exit_fail_msg").
>> I have never observed failure at this.
> It fails consistently with everything as I said, I gave up on trying to
> bisect it at v6.17.
>
> It's been broken for a whole bunch of commits all over the place so is also
> an active bisection hazard.
>
>>> The tests are essentially mmap()'ing a series of mappings with no hint and
>>> asserting what the get_unmapped_area*() functions will come up with, with
>>> seemingly few checks for what other mappings may already be in place.
>>>
>>> It then appears to be mmap()'ing with a hint, and making a series of
>>> similar assertions about the internal implementation details of the hinting
>>> logic.
>> The revelation of internal detail starts at 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()").
>> All that does is to check whether mmap failure actually means exhaustion. This can reveal bugs in maple tree,
>> if it cannot find a 1G chunk in it, even when the gap is present. This is an internal detail which is not
>> expected to change - no one reports any breakage (AFAIK, please correct if I am wrong) until after 10 months, at
> 'Internal detail that is not expected to change' is incorrect - you can have no
> expectations about internal implementation details.
>
> Another thing I didn't mention is this test takes a LONG time to run, and we are
> already having timeout issues with test runs.
>
>> commit a005145b9c96 ("selftests/mm: virtual_address_range: mmap() without PROT_WRITE"), that too not at the
>> gap assertion code - the breakage happens at the while (start_addr + hop < end_addr) chunk of code. In retrospect I should
>> not have added this chunk - the purpose was to check whether the VMAs being advertised in procfs are actually usable, testing
>> something which, in case breaks, is extremely easy to figure out and fix, without putting this functionality in the test. And, I
>> had no knowledge at the time that this will cause pagetable allocation and will touch physical memory. So commits
>> b2a79f62133a and 3bd6137220bb could have simply been avoided by removing the bit of code I mentioned.
> OK thanks for the explanation, but I don't think this changes anything.
>
>>> Commit 0ef3783d7558 ("selftests/mm: add support to test 4PB VA on PPC64"),
>>> commit 3bd6137220bb ("selftests/mm: virtual_address_range: avoid reading
>>> from VM_IO mappings"), and especially commit a005145b9c96 ("selftests/mm:
>>> virtual_address_range: mmap() without PROT_WRITE") are good examples of the
>>> whack-a-mole nature of maintaining this test.
>>>
>>> The last commit there being particularly pertinent as it was accounting for
>>> an internal implementation detail change that really should have no bearing
>>> on self-tests, that is commit e93d2521b27f ("x86/vdso: Split virtual clock
>>> pages into dedicated mapping").
>>>
>>> The purpose of the mm self-tests are to assert attributes about the API
>>> exposed to users, and to ensure that expectations are met.
>>>
>>> This test is emphatically not doing this, rather making a series of
>>> assumptions about internal implementation details and asserting them.
>>>
>>> It therefore, sadly, seems that the best course is to remove this test
>>> altogether.
>> The objective of the test is to exhaust VA space and find out bugs in mmap(). It has
> Well no, you're asserting gap lengths repeatedly, you are making assertions
> about get_unmapped_area() behaviour that are totally inappropriate in a
> self-test.

Apologies - so I discussed with Aneesh and Anshuman (CCed) and it turns out that the objective
of the test was to test the switch boundary. Upon exhaustion of the lower VA space, kernel
must not start giving out VMAs in the higher VA space, if the hint address is not given. The
original commit is 4e5ce33ceb32 ("selftests/vm: add a test for virtual address range mapping").

I cannot find this API requirement on the man page (because no one bothered to update it),
but it is mentioned in Documentation/arch/arm64/memory.rst:

"To maintain compatibility with software that relies on the ARMv8.0 VA space maximum size
of 48-bits, the kernel will, by default, return virtual addresses to userspace from
a 48-bit range.

Software can "opt-in" to receiving VAs from a 52-bit space by specifying an mmap hint
parameter that is larger than 48-bit."

So this is a thing that needs to be tested on arm64, and on ppc64 (for which the test
was originally added). Not sure about x86.


> I would suggest looking into actually writing unit tests for get_unmapped_area()
> functions using kunit or similar would be the correct approach.
>
> But again I'm not sure that it's appropriate to just have a test assert
> that functions do what they're implemented to do.
>
>> been useful in discovering a bug at [1].
>>
>> [1] https://lore.kernel.org/all/20240123171420.3970220-1-ryan.roberts@arm.com/
> I mean that proves my point that this test is _actually_ a wrongly-abstracted
> get_unmapped_area() unit test...
>
> I'm glad it was useful there, but it's just at the wrong level of abstraction.
>
> The test has been broken consistently, right now it's broken and nobody noticed
> because it got skipped (!), it simply does not work on my threadripper in any
> configuration, nor in virtme-ng, I've looked at the CI and it seems it's not
> been running there either, and it's adding maintenance burden and making test
> runs slow even if you have CONFIG_ANON_VMA_NAME set up.
>
> Every time somebody changes an internal implementation detail about mmap()
> layout, this will fail even though nothing has broken. This alone renders the
> test inappropriate.
>
> It reminds me a little of CRIU, which is tooling that makes a bunch of internal
> kernel impl detail assumptions to work - we are not obliged to keep these kinds
> of things working.
>
> When I first saw this test I felt it was asserting internal impl. details and
> thus not suitable as a self-test but let it go as relatively harmless.

About internal impl details, how is this test any different from merge.c, cow.c,
etc - which consistently test/depend on whether the VMA splits/merges?

>
> Now it's actively harming my work flow (I run mm selftests locally a
> lot). I think on the basis of all the above it's appropriate to remove it.
>
> Thanks, Lorenzo

