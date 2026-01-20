Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B9CD2ECF9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 05:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE396B0361; Tue, 20 Jan 2026 00:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7719C6B0362; Tue, 20 Jan 2026 00:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686126B0363; Tue, 20 Jan 2026 00:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 529F96B0361
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 00:29:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2D5513AC87
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:29:10 +0000 (UTC)
X-FDA: 84351213660.01.91C2315
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88A0F180007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:29:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768886949; a=rsa-sha256;
	cv=none;
	b=pUvtDd6lScEPlmRga+r3PUnwwwdHzNud3rvapU2JjWy51+Ykkml9yMAdOsoVr/Z55iRlbj
	LiM4/aZ78Q7d0Llhl7HWeGHPI2FV67kbd8qr2fx+w/DrRIkXi8LDj8GN3l+Rv/fL2dr8SD
	e5POkLugoC/UnnkqIHRs1qEU9hNLNfs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768886949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1yBXuDPwCoYpW9VOkzbByY8xSKJz4xqcCmNr0XPvEy8=;
	b=PxjLCMMxr/OQuI7entxtgwBxyBzsMxpPdKvttVnS636xtWAGu9wNzodNj+S2QInXKbFgSN
	JVUMAh+crke4sFjfJXUapVUykzt+4as/E5DpGWOtlmyWW7wg1Qr4aYMqTRgRVAPdSPeCmL
	2vUo5ffXj4X3f6cboR3GeawtzUtCUcE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D259E1476;
	Mon, 19 Jan 2026 21:29:00 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1ADA3F740;
	Mon, 19 Jan 2026 21:29:03 -0800 (PST)
Message-ID: <f5f92d9d-d65c-444b-8357-17cca7ec176c@arm.com>
Date: Tue, 20 Jan 2026 10:59:01 +0530
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
X-Rspam-User: 
X-Stat-Signature: src4eu4jqjwhy8bdtcyy3sr84g5bfncs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88A0F180007
X-HE-Tag: 1768886948-574277
X-HE-Meta: U2FsdGVkX19Ocl+mLnCfXCyeMPYgO6iqUKIwGkduB5v9rOizW6zq3zpVJxrXikbO81AnYYwNSY4A3TRicAY0oNDhrSkFlvtGcHKCHkf5CDJbZdyZKtBmVV0A3x8yF81QOXf+9NOu6o1NnuI5RLOM3iXLZqwZfk5lCRndJPGBVsfFK9YK0Y6gqPB6fVjRg5xL348O9knwGSAfNQnmNO9sjiUBI+TfYLhixPlN+IagmB0ZW5NJjfBB5dR8UGHjv2wqLpzSpqMpO7nMknN3UD6UBAE5Qzg9czwkdgGSApSyeCBaM0YEkGQ+7j1txNRdGfwsXKhf1f+IvlRo/2fmAoaEMWLZjEy62CMsVFfZibECWaZZt0bztB0tsF9nVVd16RWtuXaX0p9blzldUkLITGySvsvliZHVzaniP1E3jM+kc6Pyf66P0CkPU8q+DdlBCStAnKt8X479Tg4TDD62rVs4T/Z8SWpAreWDlPQ4uJ5UWI7bT6pBO+T29dYxbP3fh1C9zUmIY3bDq9F7zgcGTcjWTgkPPsBwCKOq62bBas1UWJXpNOXDw3bDtcxuYyv1g+r3ddHkbfXZTLCx13DTYhf0IxF8vbVecBH08P5BjEV5kr3B+CKIfgWbKUoQ++3lQQdLZh4HXxtrk0Ni79Wxq2C/0deFEzvCfafX1Z3fQe0KfccTtwjv4r/LZW6q8y5kIkm4INM5OBdD6wwkTsMzw4YSt0LMv7cpskhrqkeUHt2dQPn1U5B8aiEPXGk2TIU3V81LE+lqqNVWoXTHF8sqBneatNcfzXtUVFPGo33MqNTa9ulrHE8yQIn0WaRW5L1+Jng0q47c1RWAEFRQr0QB/x4/Glg0TshrDnZYQ0AUz8wQklf0iq757SZO4k3bfV/JgE9LlvCZgneFT/QbY+bhgvXYRoCFUbuWdH72hb+HSgC6FD1lRwCotoGQ1K7u4d/ObLKD+XYynA/XXrEcU0Jx+OH
 246G7r/z
 PgiuqjWFfUmuH2JsHE1aj79PFHs2Kmn5uTOGv8vG4HAqP0jEfGSIN3D8vIHF6bwUalDDnHb1LPIKm0K3nkkFIjbOBUUxJGUfajK+Ex5B9iGIre+ZsX32xEvWHGWbIORfsdHlJ7Na7RR8zXTHRVMguSnqNjq17PbMoferp2Y7S8jR6pqwL7rWaSAF6bDADvNV2aeaz
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

I'll reply to everything here otherwise I'll have to repeat myself at different places.

"Also exhausting VA space is an inherently silly thing for a test to do, you're
making assumptions about existing VMA layout which is absolutely an
implementation detail and may even be influence by libc..."

The original version only uses mmap() and checks whether we got a high address mmap
success when we shouldn't have. There are no assumptions being made here about
VA layout. No matter the VA layout, the test will succeed because the kernel
must enforce the distinction between low and high addresses (but see point 3 below).


"It is therefore ENTIRELY a user-facing and kernel/user API thing that has to be tested from this perspective."

So in merge.c, the statements ASSERT_NE(ptrx, MAP_FAILED) surely assert the
user-visible API - that mremap must not fail. But there are statements which
also assert where a VMA starts and where it ends, testing VMA merging -
I was concerned about these. It is not the goal of userspace to minimize the
number of VMAs while making a syscall - that is a kernel optimization. My point being,
I suspect that the mm selftests *already* test internal details a lot, and I believe
that they *need* to! Running selftests is the most convenient way of testing the mm subsystem.
Hence this should not be a ground for removal of test.

Talking about the recent commits, they can be reverted. So, the ground for
removal should be that the ratio of the time taken by the test (exhausting VA
space), to the coverage of the test (for arm64, it is testing backward compatibility of 48-bit VA
on 52-bit VA, which one can argue is easy to spot if it ever breaks, and easy to fix)
is too large and does not justify a selftest. I tend to agree here.

"Add a _new_ selftest, named something sensible like mmap_hint.c or something ..."

va_high_addr_switch.c tests stuff around the switch boundary. But it does not
exhaust VA space. We *must* exhaust VA space if we are to check that the kernel,
in a situation of "emergency" (i.e exhausted lower VA space), starts giving out
high addresses, when it shouldn't. Again, one may argue that trying to test
this out is not worth it.

I personally opine that besides testing the back compat of 48 bit VA on 52 bit VA,
we are testing something more important here: exhausting the VA space tests whether
the kernel can truly distinguish b/w virtual and physical memory - we stress the virtual
memory subsystem without touching physical memory, something which the kernel should be able
to handle. But again, any such test has the potential for a timeout. I wonder if there is a
faster way of filling up VA space.

To summarize, I will agree with you that currently

1. The test is in a broken state
2. The test is taking too much time to test something trivial
3. It is a maintenance hazard. It turns out that the original version used
   MAP_CHUNK_SIZE of 16GB, but then it was changed to 1GB because (this is the bit
   where the dependency on VA layout comes) on some systems even a single 16GB mmap
   may fail. So now we are stuck in making a tradeoff between the size of a single
   mmap versus the time taken by the test

So the better option seems to just remove the test.

A separate question: Do you think that the functionality advertised by validate_complete_va_space,
to check the gaps between VMAs, deserves a test in kunit / tools/testing/vma, or somewhere else? 



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

