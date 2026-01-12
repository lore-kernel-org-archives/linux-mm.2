Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7A3CF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1E66B0096; Mon, 12 Jan 2026 14:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8866B009B; Mon, 12 Jan 2026 14:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4B26B009D; Mon, 12 Jan 2026 14:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 176406B0096
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:39:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C17EDC3B0A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:39:06 +0000 (UTC)
X-FDA: 84324325092.13.F17E2D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 15BC440002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:39:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhoWURqt;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYA3VkQyeoywI9Uib2hEJ0dyhsd9yXElkVDiL1MQhrQ=;
	b=tEaY/BWSv8GhRzLMuidjqz78TWPV7Cxmm5CRWxWQjZ2RVVVm09HeIKqvQEmAwAO1vtFQkB
	kSuWqA0N2EP3EbSshfbfcBU8jMtLsAzbLGl4HQO+bGqHRD/tnOa99SNAZ6B7vCjPgc2K6r
	qpraYdnyh4F0u7Q2RnCW2uzSqK8YZSo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhoWURqt;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246745; a=rsa-sha256;
	cv=none;
	b=StHUrZ3bHUI9EZsk3XbaKO4l/TGZkjhtgUayCJwWgrbbX5zbTHJkvWrW3A4wNRUY4MGwv3
	V1n9m0Z066Lmyl9N9qmhN4NaKvKEJQSiofPZtyCBFDVNPS6nq7Y4lylKXB7SJ4i5d/6iRo
	JDLkYygASn4Qc0A9O6VCXhn73qD5KiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B1716001D;
	Mon, 12 Jan 2026 19:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F52C116D0;
	Mon, 12 Jan 2026 19:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768246744;
	bh=fG98iHfpwmOpTvQQdTx9szKrtu5tnsEY/6JGTID9Mkc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QhoWURqtb9dPAfNCm5xzw5IC9+5x+l+VElHvr4WAoz0v5HTvpMIv2tBVNH5F6Nho+
	 CeuBxuxdQANtNKYrQb4gcQaFj78aoJ5iVCJfaW+lkV4CT3dUQIxUKLjekDzJlIIRZT
	 sDwSgyCR75SYmM4dxA/jK7hiNORRbfddmBXzkB0oO74vftJZklhUB/+noUSK2NHpWK
	 eak8PD2rX4oWxVrWPrvDyGlqeDY2jrr0mQLEVQuabSnnyaXXBSMyhRfCEkKIs8u8pU
	 3IHBs2s3V87LuVYz6JpbbrJOvT6aEdFtHHJdkjJbmpiUfwN6a9agLEpI6S0o8nks9y
	 ULAEJUAxpi9QQ==
Message-ID: <d6a544a5-9d22-4c89-bd53-92330f4a9f51@kernel.org>
Date: Mon, 12 Jan 2026 20:38:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 nao.horiguchi@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
 shuah@kernel.org, Philip Li <philip.li@intel.com>
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
 <9413a995-9182-493e-a28a-6d2d3a17236b@kernel.org>
 <2ae04380-fd60-a8a1-6217-386454fec610@huawei.com>
 <693dc9aa-cf86-48c7-be9c-ec554f9da855@kernel.org>
 <d958d80a-8412-6107-e144-975b8d545568@huawei.com>
 <b258b6c0-7af1-4443-bd81-2722dec610f7@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <b258b6c0-7af1-4443-bd81-2722dec610f7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8bz1qcm7q37tgcczi3q36ewst7rca316
X-Rspam-User: 
X-Rspamd-Queue-Id: 15BC440002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768246744-481748
X-HE-Meta: U2FsdGVkX1/uc3yadzItjUck8Y9pQdsk+bih+Z9o89nl61aZgJjy1CQXfwOlmJBbyqAhYpPZr4beCh0Dt5ihiguc9P2MwM4uBo1TUx+eAYL3OZHQuwsTeEG9Qmko5TuEzBummdrMrRoIkWp7+X7r93CLZSPwWOV5gpfRrjPFU+BfeJDQUX1jDGgRj5ao7tcP0YmlPytHalwoy2lyWck/0VzbWu/EfpxBcOKoJRZnIa8Qizs32O8VO9bUkIRQTX5XJqQHlXMyaJ+ccs8LJylDdvylBibGvo+ieGxzUjvCuYkBt+p9cTFPeA5W9Z+zNqAtJR0rxgsLukRslVJMoWpn389DmK9s+sYsgei0VheaGhgbGSVbLjuEWGnhURCZKiXnDN+m9UnOlddT9fKxJt4y1oEmSoEru789JY/wYauy/9D7BBJnbClP7L/joyl8qsZzmsqdFiKwtFhJWfW6He7KZLB1dpQY+Lt2cZBpG3PrJkP3RkCS+EEOywjhn0Zp1pGaTN4q67Afk/r4PF9x7C94oM+VkEWIEMn7rZ5KIrAM7UdmNZTKFoowOfA2Yx4K+ejb82dB3yhqnLS/isXx20elGfTHuue4aXA729/7+L6MMDBeXFHWhNw4TRmt0Gsp8mJIf4+hCDBhRQNP/CBFjSA016a/82fSbssPjCzmX1Z/dKew/Q7++DZG8KqKnV4ELMZJap0hCAIqq9ddXhHAzZqdIGl17Dgqye4DV+T9PdtHHkHhswqi4cOwQoahPYqzjYxsxJCNmliHZRcj90lNEPsfqPBOxvIZWH6RSwQd+rKoiYENF6g0l8B5nhjJM3xLRAJa+arCQFBx4NG8kyWrFiAAapumK9jww/01+QKT9fgdi82JBT3T1JDmmDPX6Gk8tE2kNqGkoY6W4k9lU0eDi/SXAx9uTvFxojNcbeOy2/D267KRC7tZqDdz+JK+XxnYu62mmnxP8Wf5WOT6a0WvQRf
 bvRPoc55
 lELUOeCk41WsQ/hFFCwzSMSmLjEaVD3LcAg7WLSl0Y5bgUurQFrWfm+4CBPARvQYKlqDqHxFjHKbf4BvYwD4FrOy3eA+iwERlp13RY/pX2Mokq9/Y41ga/rebs4Xzay5YVaXqrr3oN8eJs1iRTGdgazL8RoqJNaiqURcoR5NkW9Z6yVWL/j70E6wow+wCnxGGjWXkICsk4cHzRBp0MF6FBfe3h8AhP76RO1bpUfGcaq/mugHWOxt2Ra4h22dIivf0adeIqszyR1xPTnLzvNUv27/2FGR+l0RzUhYpA99MB79AgCknoMpOtfKTeFF0ijAxDv+M7sBE/HtlTNqDbC51z5zW0ckjufHjNsixZd4wiFo2TZ2jCCSJsQmfrBlXTzSGYq/blaz3126OYVGVghJx31AM/RfZJ913JX1wXPyh8hRClpdLRDj33Q2mZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 13:44, Miaohe Lin wrote:
> On 2026/1/12 19:33, Miaohe Lin wrote:
>> On 2026/1/12 17:40, David Hildenbrand (Red Hat) wrote:
>>> On 1/12/26 10:19, Miaohe Lin wrote:
>>>> On 2026/1/9 21:45, David Hildenbrand (Red Hat) wrote:
>>>>> On 1/7/26 10:37, Miaohe Lin wrote:
>>>>>> Introduce selftests to validate the functionality of memory failure.
>>>>>> These tests help ensure that memory failure handling for anonymous
>>>>>> pages, pagecaches pages works correctly, including proper SIGBUS
>>>>>> delivery to user processes, page isolation, and recovery paths.
>>>>>>
>>>>>> Currently madvise syscall is used to inject memory failures. And only
>>>>>> anonymous pages and pagecaches are tested. More test scenarios, e.g.
>>>>>> hugetlb, shmem, thp, will be added. Also more memory failure injecting
>>>>>> methods will be supported, e.g. APEI Error INJection, if required.
>>>>>
>>>>
>>>> Thanks for test and report. :)
>>>>
>>>>> 0day reports that these tests fail:
>>>>>
>>>>> # # ------------------------
>>>>> # # running ./memory-failure
>>>>> # # ------------------------
>>>>> # # TAP version 13
>>>>> # # 1..6
>>>>> # # # Starting 6 tests from 2 test cases.
>>>>> # # #  RUN           memory_failure.madv_hard.anon ...
>>>>> # # #            OK  memory_failure.madv_hard.anon
>>>>> # # ok 1 memory_failure.madv_hard.anon
>>>>> # # #  RUN           memory_failure.madv_hard.clean_pagecache ...
>>>>> # # # memory-failure.c:166:clean_pagecache:Expected setjmp (1) == 0 (0)
>>>>> # # # clean_pagecache: Test terminated by assertion
>>>>> # # #          FAIL  memory_failure.madv_hard.clean_pagecache
>>>>> # # not ok 2 memory_failure.madv_hard.clean_pagecache
>>>>> # # #  RUN           memory_failure.madv_hard.dirty_pagecache ...
>>>>> # # # memory-failure.c:207:dirty_pagecache:Expected unpoison_memory(self->pfn) (-16) == 0 (0)
>>>>> # # # dirty_pagecache: Test terminated by assertion
>>>>> # # #          FAIL  memory_failure.madv_hard.dirty_pagecache
>>>>> # # not ok 3 memory_failure.madv_hard.dirty_pagecache
>>>>> # # #  RUN           memory_failure.madv_soft.anon ...
>>>>> # # #            OK  memory_failure.madv_soft.anon
>>>>> # # ok 4 memory_failure.madv_soft.anon
>>>>> # # #  RUN           memory_failure.madv_soft.clean_pagecache ...
>>>>> # # # memory-failure.c:282:clean_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
>>>>> # # # clean_pagecache: Test terminated by assertion
>>>>> # # #          FAIL  memory_failure.madv_soft.clean_pagecache
>>>>> # # not ok 5 memory_failure.madv_soft.clean_pagecache
>>>>> # # #  RUN           memory_failure.madv_soft.dirty_pagecache ...
>>>>> # # # memory-failure.c:319:dirty_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
>>>>> # # # dirty_pagecache: Test terminated by assertion
>>>>> # # #          FAIL  memory_failure.madv_soft.dirty_pagecache
>>>>> # # not ok 6 memory_failure.madv_soft.dirty_pagecache
>>>>> # # # FAILED: 2 / 6 tests passed.
>>>>> # # # Totals: pass:2 fail:4 xfail:0 xpass:0 skip:0 error:0
>>>>> # # [FAIL]
>>>>> # not ok 71 memory-failure # exit=1
>>>>>
>>>>>
>>>>> Can the test maybe not deal with running in certain environments (config options etc)?
>>>>
>>>> To run the test, I think there should be:
>>>>     1.CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should be enabled.
>>>>     2.Root privilege is required.
>>>>     3.For dirty/clean pagecache testcases, the test file "./clean-page-cache-test-file" and
>>>>       "./dirty-page-cache-test-file" are assumed to be created on non-memory file systems
>>>>       such as xfs, ext4, etc.
>>>>
>>>> Does your test environment break any of the above rules?
>>>
>>> It is 0day environment, so very likely yes. I suspect 1).
> 
> Hi David,
> 
> After taking a more close look, I think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should have been
> enabled in 0day environment or testcase memory_failure.madv_hard.anon should fail. memory_failure.madv_hard.anon
> will inject memory failure and expects seeing a SIGBUG signal.

Good point.

> 
>>>
>>>> Am I expected to add some code to
>>>> guard against this?
>>>
>>> Yes, at least some.
>>>
>>> Checking for root privileges is not required. The tests are commonly run from non-memory file systems, but, in theory, could be run from nfs etc.
>>>
>>> If you require special file systems, take a look at gup_longterm.o where we test for some fileystsem types.
> 
> And I think the cause of failures of testcases memory_failure.madv_hard.clean_pagecache and memory_failure.madv_hard.dirty_pagecache
> is they running on memory filesystems. The error pages are kept in page cache in that case while memory_failure.madv_hard.clean_pagecache
> expects to see the error page truncated.

Maybe they are run on shmem? Good question. (@Phil?)

> 
> But I have no idea why memory_failure.madv_soft.dirty_pagecache and memory_failure.madv_soft.clean_pagecache return -1(-EPERM?) when try
> to inject memory error through madvise syscall. It could be really helpful if more information can be provided.

Here is more information:

https://download.01.org/0day-ci/archive/20260110/202601100241.326d7cce-lkp@intel.com

Unfortunately no config yet. (@Phil, could we provide that one as well 
as part of that bundle?)

-- 
Cheers

David

