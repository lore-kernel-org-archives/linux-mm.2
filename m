Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E00AD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD5A6B03AD; Tue, 20 Jan 2026 05:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4E26B03AE; Tue, 20 Jan 2026 05:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBAB6B03AF; Tue, 20 Jan 2026 05:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADAD6B03AD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:20:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 200B8C1D01
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:20:55 +0000 (UTC)
X-FDA: 84351948870.14.55643CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id DCAB7A0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:20:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768904453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=flvbTW8cGb6deilLmI5t+JKo7K9LDXUoyDniHF2AX+Y=;
	b=z0UVOzi0HxoCCgC7CqLBFaX8OoDrcgQ9EwjHQbH5rRLN/9CPXJJ1GOLqg5ZkOXckQt85EN
	q0718oOn9DKC4lLvue7QU5WkOk5iqpBwUR4BAbMEzRREmGs0qC/0M9Bz6Ip810aEYvepcI
	6Km6sZhZTNLRVoAJakVlIotfmzAyO+A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768904453; a=rsa-sha256;
	cv=none;
	b=WBmOQt5IwIsIKYOvQSV/W2e/ZLEE8Q8+6DvvowY96GJWML3Oqk8A+8fQ6mWR93kDHpVXeB
	fy3v6uOBvJn8GSWGywGwrIGavPtjj2fpUT/zZapk9teIEsMvi5lXXsFAhL00viw/Lap7X6
	VtMBHaqibjO3LDJBklP4t41Rv8FXnRY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 271771476;
	Tue, 20 Jan 2026 02:20:45 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03AB03F694;
	Tue, 20 Jan 2026 02:20:47 -0800 (PST)
Message-ID: <27ca39af-27d2-4f99-8988-5c45211b659a@arm.com>
Date: Tue, 20 Jan 2026 15:50:45 +0530
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
 <f5f92d9d-d65c-444b-8357-17cca7ec176c@arm.com>
 <8acef9ff-c5e2-4111-9437-f50b427db061@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <8acef9ff-c5e2-4111-9437-f50b427db061@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DCAB7A0003
X-Stat-Signature: agdepytoupcg441khdcj8snoh7t8frpd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768904452-371268
X-HE-Meta: U2FsdGVkX1+zyx6GCib+h32W7zWre0+ewjs5hq0gEjAal0koLMUqUWaaxERR5UvbnvUwEV8FscfFHkt5uqAz6tr0DraxiPPdiNvUtkLA2548D/X1j3F1QrGyit9paBaJckJHupbuNLIm7BLrFzL/P1Hi8AENjybb9w/4Tf/rFU97Hm0zjfyRAinDQQgehoR5iTRB/qDgeoRthtpLZbtigZ1yKQSC6LSNjO+3O5evlwIBf/79d6jlrRf9XHPUJ05vnzOcqy9xMg5zHweUVj9LCu0GbPG6+0hgHqTfuQYu+YFnDnjgZ0JgL7UOrJbqfymSpHL5UbfO/OcnLygnxqzpdWt8zDDwHCsWJNI48S80YNKLdJ5YIMr9UpJf/SuaY/b5ZkotZu3UmBrLX2icSTQE4KRJ5Yn3Vrr0T/JDWpM+k3/0q/QbYtwdMBcK75yDy2oDubm2bT4rap1FOrEOTVA7Wax1HsSWmqszamaWfe/hF3z5R45TndcG190QQSUshvj/HOXoGk/hsM3vruusTE61DHwFDz8w5cw9hG9n+0BSzIZJHXc8W9HQbSoVz90fYZArN8o5p+trvo/EwJEPXN5frXIBuoMLiq2Su4+fHPzwZ81bhOc9j/slwqzLnSteSziQxYmKYUKn6HDlvlVq1ppzg8S7DsZ5pBpIYX4jaC2g/6QI5zl78yPKv5TZT3rf/ew5BMtHQhv7gSY2y0eIYxnwgd1Nm7p6jFaL3dSi7YamqG5/QwOVVszKkFoIhHj8JDZ59A3RRrpldOSJ3gP41IzwGyIkfZB8C8HEiz7AVSKXi/E+uItuSKtJ0QwRzwjLunTiEQ+ExgovIRPqkuXACJ6T0rpt2Q+39j2P9L9B9ddlUxIZXQsg68k4b03OH2/b5fU5hZQf52kGQgBbwBMEOI5rXQ+/WifUiafUyLUx0cJMwFt37HZ0Q5oCBzrdKGPLq/4F9lWi5PCaF+kj71T4op6
 kgHYyB+/
 4Nh4k6A5dhxP56TrRrvxU/dwIe4qEobrW4Zpq+skQ3k+L4Em9Ufd++veVhjH6P5lEJTGyRalcKqsfoGYUZA076Te5XmB5Sy18xv4t6Rmv1dGUtpEe+ySDp91gC/QOjKNLWKtrKVjv8UI+uhIFYVt6e1t/kafkyQVsOd1ZSCnpA+FRoJg9ovn4GeFWmKOHgYl34x1p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20/01/26 2:13 pm, Lorenzo Stoakes wrote:
> On Tue, Jan 20, 2026 at 10:59:01AM +0530, Dev Jain wrote:
>> I'll reply to everything here otherwise I'll have to repeat myself at different places.
>>
>> "Also exhausting VA space is an inherently silly thing for a test to do, you're
>> making assumptions about existing VMA layout which is absolutely an
>> implementation detail and may even be influence by libc..."
>>
>> The original version only uses mmap() and checks whether we got a high address mmap
>> success when we shouldn't have. There are no assumptions being made here about
>> VA layout. No matter the VA layout, the test will succeed because the kernel
>> must enforce the distinction between low and high addresses (but see point 3 below).
>>
>>
>> "It is therefore ENTIRELY a user-facing and kernel/user API thing that has to be tested from this perspective."
>>
>> So in merge.c, the statements ASSERT_NE(ptrx, MAP_FAILED) surely assert the
>> user-visible API - that mremap must not fail. But there are statements which
>> also assert where a VMA starts and where it ends, testing VMA merging -
>> I was concerned about these. It is not the goal of userspace to minimize the
>> number of VMAs while making a syscall - that is a kernel optimization. My point being,
>> I suspect that the mm selftests *already* test internal details a lot, and I believe
>> that they *need* to! Running selftests is the most convenient way of testing the mm subsystem.
>> Hence this should not be a ground for removal of test.
> Dev I would rather try to be positive not negative in review but again,
> this isn't constructive, we're not talking about merge.c and even if it
> contained the comment /* Ha ha I am a contradiction */ it wouldn't impact
> this discussion.
>
> You're not correct, mremap() has an API requirement that you can't cross
> VMA boundaries for most operations, therefore start/end of VMA's and
> merging _does_ matter. This also impacts how e.g. madvise() behaves.
>
> As I said before:
>
> 	But you do not - both VMA merge and CoW impact API. Re: merging
> 	certain user-facing functions, most notably mremap(), have API
> 	requirements that the user must not cross VMA boundaries. It is
> 	therefore ENTIRELY a user-facing and kernel/user API thing that has
> 	to be tested from this perspective.
>
> Can we drop the subject please?

I think we are talking past each other, and communication by email has not been
the greatest thing, so I'll step back.

>
>> Talking about the recent commits, they can be reverted. So, the ground for
>> removal should be that the ratio of the time taken by the test (exhausting VA
>> space), to the coverage of the test (for arm64, it is testing backward compatibility of 48-bit VA
>> on 52-bit VA, which one can argue is easy to spot if it ever breaks, and easy to fix)
>> is too large and does not justify a selftest. I tend to agree here.
>>
>> "Add a _new_ selftest, named something sensible like mmap_hint.c or something ..."
>>
>> va_high_addr_switch.c tests stuff around the switch boundary. But it does not
>> exhaust VA space. We *must* exhaust VA space if we are to check that the kernel,
>> in a situation of "emergency" (i.e exhausted lower VA space), starts giving out
>> high addresses, when it shouldn't. Again, one may argue that trying to test
>> this out is not worth it.
>>
>> I personally opine that besides testing the back compat of 48 bit VA on 52 bit VA,
>> we are testing something more important here: exhausting the VA space tests whether
>> the kernel can truly distinguish b/w virtual and physical memory - we stress the virtual
>> memory subsystem without touching physical memory, something which the kernel should be able
>> to handle. But again, any such test has the potential for a timeout. I wonder if there is a
>> faster way of filling up VA space.
>>
>> To summarize, I will agree with you that currently
>>
>> 1. The test is in a broken state
>> 2. The test is taking too much time to test something trivial
>> 3. It is a maintenance hazard. It turns out that the original version used
>>    MAP_CHUNK_SIZE of 16GB, but then it was changed to 1GB because (this is the bit
>>    where the dependency on VA layout comes) on some systems even a single 16GB mmap
>>    may fail. So now we are stuck in making a tradeoff between the size of a single
>>    mmap versus the time taken by the test
>>
>> So the better option seems to just remove the test.
> Right let's just focus on that.
>
>> A separate question: Do you think that the functionality advertised by validate_complete_va_space,
>> to check the gaps between VMAs, deserves a test in kunit / tools/testing/vma, or somewhere else?
> I don't think so as it's not a requirement set in stone as far as I
> understand it.
>
> But expectations as to what get_unmapped_area() should be doing makes more
> sense as a kunit test.
>
> Thanks, Lorenzo

