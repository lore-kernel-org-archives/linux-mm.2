Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9850BE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 11:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B8C6B0088; Mon, 29 Dec 2025 06:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49366B0089; Mon, 29 Dec 2025 06:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955E66B008A; Mon, 29 Dec 2025 06:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 860646B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:46:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39DF7BEAF7
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:46:53 +0000 (UTC)
X-FDA: 84272331906.17.951EFA4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id EAA1740008
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:46:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767008811; a=rsa-sha256;
	cv=none;
	b=3Er6IJXS9XgBPP+JW5tAblJx72p45bGPEcuYEantmdRBDZrgT9KuOswDZf9cJmSGZPbtkh
	pml5j32TvsdAL+mfw3XVHPeCV2+/Yn0uClYe4OCP4MRJE2T1grpmLaSoRR56AHlf5Nps+j
	2KfqRIzMTau2F34l8gmLdTQFKdwNX4U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767008811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=55HigBlQHbzxhusODOnJSc5MeYRZFy/kHhQUkZrIBNE=;
	b=RbSVK69tv+GnBv9Ip8ieo9ANkGBFg5RzRz0P7GIChBUOaoW7XfdMrxipo9waVRROjILjg/
	QnDEWxCberVGJHO5br9Z/2hz4OXWJrlSfC4uyL1N9Ex6CQHkfSogMTDNNj89+6RT/XiF/+
	ijYLD3CyOGnguzJDpLIM9p3Xl7U5ggY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4A93339;
	Mon, 29 Dec 2025 03:46:42 -0800 (PST)
Received: from [10.57.45.222] (unknown [10.57.45.222])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9303B3F5A1;
	Mon, 29 Dec 2025 03:46:47 -0800 (PST)
Message-ID: <7f0ac47d-1eff-4b79-b260-7812bf3ebc80@arm.com>
Date: Mon, 29 Dec 2025 12:46:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests/mm: fix faulting-in code in pagemap_ioctl
 test
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-4-kevin.brodsky@arm.com>
 <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
 <6aa47cdb-d2e7-4977-929b-7019b6f991c1@kernel.org>
 <0575bcf6-c1a3-4ebf-a199-3113758fbdc5@arm.com>
 <a3ca6293-8f85-4489-a48e-eb8d0d3792c5@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <a3ca6293-8f85-4489-a48e-eb8d0d3792c5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EAA1740008
X-Stat-Signature: ofpm68tx41ci56y5k8dfm4j1gf5kdasy
X-Rspam-User: 
X-HE-Tag: 1767008810-57783
X-HE-Meta: U2FsdGVkX1+RG844j8dgY6YrVeGxgs784d2DkILovZaGhCE/+cIcvRUAWjd8T7+vWraaKmfqktwaH3LfOQWTFCWfmafrjUoGkemRkdL4nWp7NBP2EXr2asxrgZOqp1L3MoXZu80dckKFhIhQqXA85iFJqf6c02Dr1nWx9+0s0cB8WgebQHd/6Eq0s4r6/e91KOuKi6tgosXDbg8hiCDfnvpxvSsXPSri7wMYHKsY73OMwE0f5dG1p1bVh4rWVloc11O+pThGbc5VWGNO9ym/+A96Lpf73z5v18MfCstwTDzaPcedrtd5ejyecpixbm3GDq//UV1pavjTK+qI030CzT7MZuHJzTUA3prGUek0boPo054ONpMy59vP2iZMa6npImerthCuMQiAUeknKQUk6AhR9zbeEopQptKmwyZrWl1E10X+eikHYMoudJzqJOAH/tlX6g2gS67MY9LDcu3ZhxroN2u+GDWHTurIrRTXcIB4Ga+MrP6Q74Kc2CC8bsVC2XuqSPE2mYJ8qw0SkkTu1zuuiQ6KZOV21KBwrzcn2iqWEh8rIjLpjdad2UK4ycHb16zIdGyLo+PgCcBwaf7Pa9Fb5ED2yhLVgxYI3ILBsKc6hiTXBlfXIBXd5Zt6vSlMHspHV9a5eJZQP6sWDeUoqcrFdVZhW8wwVu4vBO3ugfP4V2V2FHejZe+flxNDJJ1MQcUpg87ga4M0YuWvneDI0Z/l/K5so6IzsU/LSFTqIcdG0JeHJpGsV6i42l4VkHHJJvcyCBqJeyMW+cvs/X3H2tkQe8ifP859ZPiuTeRpmVq5fUpOnN7SoVwW9LC6LJcFOPJoqdH4cAqERTsQ+DesadSqEzEUkK8OD+93hddfG3BV9KsiECGBJEhApoeVkeWbRBxyt6XspSLANoL8aqx00NiAH9KHFaEzNgmsPKh4H0iO5QyzgTi2luLbmYjQ9X0S0NHU7f1hxX1sqPCbRWS
 42wnLDgR
 /SkbO52zGmuXamj7+7PTqOuY+ryzkmXHE2lKYxn7TTxicYML9JF5jZvamxXNoDJWImZeKChRI72JhoP5L9Oh4hbQF96BPfKfG8aS9WvUpyBvWU5U8EhUxHLClsQGy7INDux/Jimo6n7FAfQghnOUSCdhUW1LwflvZFaeZc2r27CY+bARhdCMnQCAoGkby5aNSYBEIvALXber/8NYtmQVZE3d0/IgWZXohd8ZAH+1nEPoTEVE1GSlAuFws5qQRmd8MYd+2+57VTcRtaM9oOpp9AJsBZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/12/2025 09:29, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 14:18, Kevin Brodsky wrote:
>> On 18/12/2025 09:05, David Hildenbrand (Red Hat) wrote:
>>> On 12/16/25 15:56, Ryan Roberts wrote:
>>>> On 16/12/2025 14:26, Kevin Brodsky wrote:
>>>>> One of the pagemap_ioctl tests attempts to fault in pages by
>>>>> memcpy()'ing them to an unused buffer. This probably worked
>>>>> originally, but since commit 46036188ea1f ("selftests/mm: build with
>>>>> -O2") the compiler is free to optimise away that unused buffer and
>>>>> the memcpy() with it. As a result there might not be any resident
>>>>> page in the mapping and the test may fail.
>>>>>
>>>>> We don't need to copy all that memory anyway. Just fault in every
>>>>> page by forcing the compiler to read the first byte.
>>>>>
>>>>> Cc: Usama Anjum <Usama.Anjum@arm.com>
>>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>>> ---
>>>>>    tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c
>>>>> b/tools/testing/selftests/mm/pagemap_ioctl.c
>>>>> index 2cb5441f29c7..67a7a3705604 100644
>>>>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>>>>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>>>>> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>>>>>        struct page_region *vec;
>>>>>        char *mem, *fmem;
>>>>>        struct stat sbuf;
>>>>> -    char *tmp_buf;
>>>>>          /* 1. wrong operation */
>>>>>        mem_size = 10 * page_size;
>>>>> @@ -1167,8 +1166,9 @@ int sanity_tests(void)
>>>>>        if (fmem == MAP_FAILED)
>>>>>            ksft_exit_fail_msg("error nomem %d %s\n", errno,
>>>>> strerror(errno));
>>>>>    -    tmp_buf = malloc(sbuf.st_size);
>>>>> -    memcpy(tmp_buf, fmem, sbuf.st_size);
>>>>> +    /* Fault in every page by reading the first byte */
>>>>> +    for (i = 0; i < sbuf.st_size; i += page_size)
>>>>> +        (void)*(volatile char *)(fmem + i);
>>>>
>>>> We have FORCE_READ() in vm_util.h for this. Perhaps that would be
>>>> better?
>>>
>>> Agreed, and if we have multiple patterns where we want to force_read a
>>> bigger area, maybe we should provide a helper for that?
>>
>> I've found just a couple of cases where FORCE_READ() is used for a
>> larger area (in hugetlb-madvise.c and split_huge_page_test.c). The step
>> size isn't the same in any of these cases though. We could have
>> something like fault_area(addr, size, step) but maybe the loops are
>> clear enough already?
>
> Note that even for hugtlb we can read page-per-page, no need to
> hugetlb-page-per-hugetlb-page. Not sure if the performance change
> would make any real performance difference in this testing code.

Fair point. In fact in split_huge_page_test.c we're reading every byte
but that's unnecessary. I'll add a helper that reads page-by-page and
use that in all 3 cases.

- Kevin

