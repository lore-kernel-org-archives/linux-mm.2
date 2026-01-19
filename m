Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04282CCF2CF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5069E6B0140; Mon, 19 Jan 2026 04:06:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7B36B0141; Mon, 19 Jan 2026 04:06:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40EE06B0142; Mon, 19 Jan 2026 04:06:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F20F6B0140
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:06:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDF1E160515
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:06:14 +0000 (UTC)
X-FDA: 84348131868.22.DA6960A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id B2CB320006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:06:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768813573; a=rsa-sha256;
	cv=none;
	b=ORm2tlZOnRAlu4k/xjvcY2gwQk3gp/J5z7OJhjK3DvzGlXRG/CQmVyT5t1FHZG3I4dJFQF
	c6zTzULAEpyKtSde8Yrdndq6U3J7d7ahZjdEqOIhdCju5mD4AhNuFb82gdR72ZJl+Hp8fY
	00EuBcxc22/SHLjqS9CGjH2OBq6SK8c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768813573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ynVV0oCKArEADYcS7dO1lfWHaAyLOCcf8LYn7vHkkPI=;
	b=D4B5+hsxuhV8Wil8qm0UuMqew937y5eeD7F/lHCXHrD9FziQOSGoIF2WI+Wn96fBWpJZOy
	eqQ9DI8i2obtD6djVgduvowJDK2R6uOy29RYjZ/UM66jKosCwICmqCGkNb9bBkOx8UXrAg
	xncd/L1t2iVYhtGqMEKy0N962AZBgFs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01F001517;
	Mon, 19 Jan 2026 01:06:05 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE9DD3F740;
	Mon, 19 Jan 2026 01:06:07 -0800 (PST)
Message-ID: <c978c50f-16b0-4514-8169-96b69bc7af33@arm.com>
Date: Mon, 19 Jan 2026 14:36:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
 <e71ffffc-8623-48d6-88b7-4684af4534aa@arm.com>
 <f7ed83bf-3554-4bfb-8d77-30ed4785a4a8@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <f7ed83bf-3554-4bfb-8d77-30ed4785a4a8@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2CB320006
X-Rspamd-Server: rspam06
X-Stat-Signature: 7pjj3rgs54nco36isqa5th8b91ij4y5e
X-Rspam-User: 
X-HE-Tag: 1768813572-984369
X-HE-Meta: U2FsdGVkX185Y5vetZ/1W4xqURIBl1i4omjwjl9XXEV2JZx96sc04ESilOYhiOfAbDiL6uHzJdWh1nWf/M9++TDTgcXY3UyLRlI4lJS2YC+Ox73uABELS3EnE5qrf18ghcpLwM6gS/pd1rJZYhs1B2lrdHokokCZKptNdDN1X0qcRCYj+jJHDtwLusi0WQkEVyAiM3xeF7pCwcke22AfSDtDCdHAph5irQovyuVUbN5oVDOY+hb+Koz4mzKKDTaqeErJmgkhtJpo1asW29Jb/fGQCDVyImAf7AzTioiuAxFKkv2bkEuClNVo8YvXWZ5II9XpnaCYy7vRsvZMFWPRXQ1XTa1pXTBInwzYZoNGsqcEtLkXXdssvz13i8MAdlBJOBToeEEdf3BezWEH2TAw2t/8ZqdSdpkQxUsBbX/AP9V6oLSeZEOAPsFNsUqGsipVrcJCh51DEHc4KjOyDGMYAAWEX77R684TVheMPQXB4SJMbmCrGWkPugooHMCMq5lBF8RkZn96W5ai9hnddBlWwLRV36w2RAjdrjIuN5gpHlKHuIcGYdDSPy72v3fn5tRsvaqUz1x2MN/bZQ+8LJa7IyHsm3dmaArWzasOF1132fq5F264XiARZJeUGgrLAXoWP7TJrSqDE5dTl80PkdBImJRrSJtN5DirCorUqC/akePbPQ64yPUdj7JW6veIB1PRamkmuGs4kDD6RMMNH8iRocp2LnqWPfW7bvuPh0sV+bciW96WrkTQj4+BtBHQQalG6FLo2p1t51SVqBFQB/CPL8VmnFedcvXC2FRKn5eIAz5WeCYrT+y24m+TSfm9JTye81+6B6ZZIg6wZBbz5VOZCt5yCSRakcT0PmTfCy29+JZD6SUr/2981gl7Lg+BlcJ2uCjG7rYsCOsnYGIpasL2IZqAmbEOeQkOTUVEE9mQnrJzcgNHvoOxBiH3CWbqutWZphjUp4Xp0b0f9XzX2KO
 1SA2Actx
 4YotflFEJY7eq0ruAKEBwQoeAXa8NeBVT5ZDRI32O1jouJABzV/+9oJo0rfFN7ENzNVLx92hP7FDqdAnHns3gFib4tZdn6a32pM/gHXBTJ60h1q43LcniL+Ho5oWUVr8QSZ641aCq3iMgHaAohcBLbbMLU41Rny0AKmPyqgTfSZdHRufh3SAqA9w/+41sgf/89AIr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 2:29 pm, Lorenzo Stoakes wrote:
> On Mon, Jan 19, 2026 at 11:51:47AM +0530, Dev Jain wrote:
>>> Well no, you're asserting gap lengths repeatedly, you are making assertions
>>> about get_unmapped_area() behaviour that are totally inappropriate in a
>>> self-test.
>> Apologies - so I discussed with Aneesh and Anshuman (CCed) and it turns out that the objective
>> of the test was to test the switch boundary. Upon exhaustion of the lower VA space, kernel
>> must not start giving out VMAs in the higher VA space, if the hint address is not given. The
>> original commit is 4e5ce33ceb32 ("selftests/vm: add a test for virtual address range mapping").
> This doesn't change anything, this is still testing get_unmapped_area() which by
> definition is what is returning this.
>
> Also exhausting VA space is an inherently silly thing for a test to do, you're
> making assumptions about existing VMA layout which is absolutely an
> implementation detail and may even be influence by libc...
>
>> I cannot find this API requirement on the man page (because no one bothered to update it),
>> but it is mentioned in Documentation/arch/arm64/memory.rst:
>>
>> "To maintain compatibility with software that relies on the ARMv8.0 VA space maximum size
>> of 48-bits, the kernel will, by default, return virtual addresses to userspace from
>> a 48-bit range.
>>
>> Software can "opt-in" to receiving VAs from a 52-bit space by specifying an mmap hint
>> parameter that is larger than 48-bit."
>>
>> So this is a thing that needs to be tested on arm64, and on ppc64 (for which the test
>> was originally added). Not sure about x86.
> Well 'needs' is strong here...
>
> It would be far more efficient to implement this as a kunit test and wouldn't
> require a extremely slow test that makes assumptions about VMA layout.
>
>> About internal impl details, how is this test any different from merge.c, cow.c,
>> etc - which consistently test/depend on whether the VMA splits/merges?
> This is not a hugely civil/productive way of responding here to be honest, it's
> what-about-ery and implying something that isn't very kind...

Sorry if I have offended you, I did not mean to imply "two wrongs make a right", I
meant to understand how the two tests differ...

>
> But since I am a reasonable if grumpy maintainer, let me indulge you a second
> here.
>
> I thought I'd been clear BUT for avoidance of doubt, I want to remove this test
> because of the COMBINATION of:
>
> 1. It is completely broken and has been broken for some time and nobody noticed.
> 2. It is asserting kernel implementation details.
> 3. It is poorly implemented and breaks often.
> 4. It takes a very long time to run even on fast machines and is a timeout risk.
>
> So even if you had a point, it wouldn't argue against removal.
>
> But you do not - both VMA merge and CoW impact API. Re: merging certain
> user-facing functions, most notably mremap(), have API requirements that the
> user must not cross VMA boundaries. It is therefore ENTIRELY a user-facing and
> kernel/user API thing that has to be tested from this perspective.
>
> CoW is equally a documented and expected behaviour and also affects merging.
>
> Anyway.
>
> Practically speaking I think there are two ways forward here (not mutually
> exclusive):
>
> 1. Implement something in kunit or similar that explicitly tests
>    get_unmapped_area().
>
> 2. Add a _new_ selftest, named something sensible like mmap_hint.c or something,
>    that runs only on relevant arches, and does NOT try to do crazy stuff like
>    mapping the entire VA space, but instead simply tries some trial unhinted
>    mappings some hints in 48-bit space, and some hints in 52-bit space and
>    asserts things are as expected.
>
> If you do point 2, please please use a. use the kselftest_harness.h to write the
> tests in a nice way (see e.g. guard-regions.c for an example of how it's used)
> and b. use the procmap helpers in vm_util.h to check on VMA ranges, you can see
> how they're used in... the merge.c tests you so deride :)
>
> If you or others do both/either I promise to dedicate review resource to the
> series(es). That fair enough?
>
> Thanks, Lorenzo

