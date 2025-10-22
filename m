Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14B3CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38EA8E000C; Wed, 22 Oct 2025 04:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA0C8E0002; Wed, 22 Oct 2025 04:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E265C8E000C; Wed, 22 Oct 2025 04:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD4028E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:11:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 720DD1607FD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:11:23 +0000 (UTC)
X-FDA: 84025030446.09.B5EC5A8
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE79D140003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:11:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vJpHD3lM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761120681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIvjRU+9W1e02BD6k4Ej3q4cCT3RiCjRqqzBqmFHkYo=;
	b=NfCY4skftpiQEboBtiegFd3LNx0nv6R4pYLL4532lQAn4ebUJyrLFYIvYQq4rBSEEtKv+0
	jWATKws2WuZHo11dsGndgXnitx98hKfHMIUGeQfbcRRGLz/lPb2dSO2SBvDRHPATY9Pgu9
	N/anZqdZtxHZ8pf+V5fq+6D652kNQL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761120681; a=rsa-sha256;
	cv=none;
	b=BdSBYCGJebmm7wI9VJh6GjrwHpusAz2qWhvRbBtxEqY0OEgtBebZ+awzIS8c/nVD+d80IT
	3/rFUprw+RP9V5CSkCS0QMNjEBx8ldcUdMJ7z2CS3RnA0cQphklhyAXq+CAzHb/GIRJup6
	2w6viJzKpZaJP3HoIvMJt7yuxecoSww=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vJpHD3lM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761120677; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=LIvjRU+9W1e02BD6k4Ej3q4cCT3RiCjRqqzBqmFHkYo=;
	b=vJpHD3lMj1ds9F7KUn0R3z5aJfgP9yz/RT64pbTFcTVi3EuXFdRSRe9pJHTtC8GxT9Lw87f3ga68wpyJNMHmHeq64apR+r2UKpXHP/EPevY8vnSt9U+x4o51e+62XrE07XBy2mvAQ/wqU57c3fP0BaYkzmjEHtC0M89s3R8e62I=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wqm7tPB_1761120676 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 16:11:17 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  linux-kernel@vger.kernel.org,  Catalin
 Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
In-Reply-To: <b5a1b52c-75ef-4915-a254-a502b9f78eeb@arm.com> (Anshuman
	Khandual's message of "Wed, 22 Oct 2025 13:28:43 +0530")
References: <20251022032951.3498553-1-anshuman.khandual@arm.com>
	<87ecqve6gg.fsf@DESKTOP-5N7EMDA>
	<b5a1b52c-75ef-4915-a254-a502b9f78eeb@arm.com>
Date: Wed, 22 Oct 2025 16:11:15 +0800
Message-ID: <87o6pzbbks.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Stat-Signature: uzn6mq8kwqjykmq4tjt885tnag6f9bzm
X-Rspam-User: 
X-Rspamd-Queue-Id: BE79D140003
X-HE-Tag: 1761120680-570113
X-HE-Meta: U2FsdGVkX1/9p0oK0XnYByqBU7KsIeyDDFdLkdVJOiUejSipOb7P2veFF/J/LKAEMgUJf9HtUgvNlZMuf6nhuE3GrRFkONDnu70zNn+j5T4TuL62xwgXvcZlcpF2rN9/MqkrtPYaT7y7PVR90af6U2Bnqa4FleHlPvx7TRur34MbYjeY8q6d9QWiwDICSXjAjE3R6L4Wmb//bwtluaL/67/oq31BG6b+MfDWnkkQDNqGv42gUB0zbddJBWRW2iIEQvglYC90Tt+zRTsDkrwgAcpeL5U7BiN8ScHDv0LH/WGTmyLlefCsM1aKL4C0mjhRUrs6G1+T/AwMhyS+GmDyBGiY6fiG/F5+qheADa+rNk8jCX66Gt7qgdUTd3SEMVVmB/n/wEc+U/iIZJl4vFLFQZ3dRdaoIBVrYk3aRcUBVqKbx+ChiORJayRMQk6tkXxX1974iu4NBAdvOXEas+i0/ELUZqoHZEPzKWZHLsoppytLcDuXme5wuMczlb8rfMG7MB9krijUSxsxMJ+8gugDt2qBKa3xRBNI8JsZuHcF+1ax/7ejMjOMw0rVyaAAz5izEILWf/BLc5eono9VGKMW5zl/tq1fna3rTodpCqelP4L0aX43KyxD32XhTEj686QM7kq0crIO7NQ0phVadaFP7MZeYb/mqidcAijqEckUIacU3XRQmaOK1N7XnKRmX/wEkVz4Uev+7IcKo0GWB7EmhklC0IK/XSMH37vpIuRnpVQymMpVbr4sUuNBug8wxM9qw9+qKXG+kyyElM5vD5JNP7jzhuCr5inIZNV/s5+gHCKSvaHrLjql+nSY8kWp7dzE73YLnWVCK7dq98eqa/bIr5f8lnd3wX3oJYfgORtpOzvRVHS5Z5MlHFRoW763aOh4NA6k+VXmph6imJHVg5KQwMKsh6oNyPvx3Xm6wtvE+GhMy/6jotjy/b0TewcfZjvDryMDCx9JUQ55NkdHU5g
 2m7xfihb
 0d3EbYZFSZ5kwUVPlQvhOC+C8F26USqaUADYMTWAY67nh9krFYU/OUjycfPUhfET8raVZPaMLBW8PmIM3P5vKWNPL59OQ0IESSJBBco4rCn9ad/bZ7ahrDVv9rhiGi5IFwSbH/yrwDSfmbhbhFTzj562s/7/XcYAPUHBEVNzq1pr3jfbWirZA3HVDb/14lsQOmgXum6cgs0lZ+FfKqt2jM6N17ATWzZVOeGF03pb01rWTzjtx1u5YQ2Fhf4AfHiFOf0IKvQkuweUBU68wrY6qh3OUqf5NhRW5Q36I9XhOLH4gM4gIrFRfUYbz/jzSV9sAyn3BxjEmAO5OAjG0hndD/93W7KcDpqe3ZiGKVFCFeUQMzOBnRMLolNSe+n/wB5CoGjtv2rFTgeyU+L9HrEozPfsIgbHNrzLPsR6+5UkiwJLvF56fdNFtuH2fxZXY6EQxwkuO3iyK8+6FbSfwn7Kc69Y6Bh9UNrejSh5S24pxve9nA3h+NXOZ9EdJuOR5yJ1uNksXQHqX7bUmctyhcEyQc0wWlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anshuman Khandual <anshuman.khandual@arm.com> writes:

> On 22/10/25 1:03 PM, Huang, Ying wrote:
>> Anshuman Khandual <anshuman.khandual@arm.com> writes:
>> 
>>> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>> These tests clear on arm64 platform after the following recent patch.
>>>
>>> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>>>
>>> Changes in V2:
>>>
>>> - Added a new test combination per Huang
>>>
>>> Changes in V1:
>>>
>>> https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/
>>>
>>>  mm/debug_vm_pgtable.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>>> index 830107b6dd08..def344bb4a32 100644
>>> --- a/mm/debug_vm_pgtable.c
>>> +++ b/mm/debug_vm_pgtable.c
>>> @@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>>>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>>>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>>>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>>> +
>>> +	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
>>> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>>> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
>> 
>> Why do you use
>> 
>> pte_mkwrite_novma(pte)
>> 
>> instead of
>> 
>> pte_mkwrite(pte, args->vma)
> Just wanted to have more coverage for pte_mkwrite_novma() helper which was missing
> till now in this test. But just wondering is there a specific reason for replacing
> this with pte_mkwrite() helper instead here ? Also we could probably add tests for
> both these helper variations if that is preferred.

IIUC, pte_mkwrite() is a more formal interface.  pte_mkwrite_novma() is
used to implement pte_mkwrite().  So, IMHO, we should use the more
formal pte_mkwrite() interface if possible.

---
Best Regards,
Huang, Ying

