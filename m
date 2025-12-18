Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE077D6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425216B0088; Thu, 18 Dec 2025 08:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9916B0089; Thu, 18 Dec 2025 08:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312866B008A; Thu, 18 Dec 2025 08:18:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 242076B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:18:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4FCD138B08
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:18:43 +0000 (UTC)
X-FDA: 84232646526.20.EACCC48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1433C1A0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:18:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnSYbaFp2CAHTZ+yw/lF5QDuvZiXHxAuex7bg8JKT8Y=;
	b=JJ6Qd9XRBjhp0xufXDhata++HE2NoBg6cHlrFOqbqPfzjl6g2x9i9PVeL4+pr/OBIxm8jN
	XdGvTnhzCj5u6qxYUNhsj9wYQT0evSDWN4LFeaCwmdRoiBW9oj7VpdxJyDJEtl/bnbGZYI
	iwO7dqra4RneOvw73u1yDdZNysD82cQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063922; a=rsa-sha256;
	cv=none;
	b=111hyTlURdOKx3PtVwD4IbLsBFCx9mTlHAT2ucMCG7yMMfS+VO/z8omZiKNTUNqR338IhV
	BYsBiGdER/JqcFvUW/cCTcK0Wn4C8+JT7VNmK1n2xDyiEJPWOmLMyeYRj28PlnYrOW+JOA
	0fXr70LGDPHeLVsP6ge6qYiLmfPxqO4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC3F0FEC;
	Thu, 18 Dec 2025 05:18:33 -0800 (PST)
Received: from [10.57.45.71] (unknown [10.57.45.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2C763F73F;
	Thu, 18 Dec 2025 05:18:38 -0800 (PST)
Message-ID: <0575bcf6-c1a3-4ebf-a199-3113758fbdc5@arm.com>
Date: Thu, 18 Dec 2025 14:18:35 +0100
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <6aa47cdb-d2e7-4977-929b-7019b6f991c1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5nsrfwrk5zsjgwkffu9s1tdyxpdfrfee
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1433C1A0003
X-HE-Tag: 1766063921-913667
X-HE-Meta: U2FsdGVkX1/+PIP6zgv4H47VrUmx/7mE3GuYfOFf7LLYQl5fNw7IcNkdSLXQs/oBRiiKOCo42tcJpfxnmy9IIPoJPcYOVjrMoUoXDq7K8s1u44rVDg5L9C/+gBF+gbF1aqwYvsNN4GMrh5Ko0AVVLF05mlKg8ckWyoAv5ymPtLvGyiTE6ipyjR3yCUH1xldWmvQEJ3EjaA61kntB+2P/Fks0yG927lrYhSyXyUGTKXzpuBnPvBx+fp+/n76EUbWo3YA2l/HLgIN5HXvU5bubrRwPzg4EVreT+CI2mHBms2TOOigI2JR2NrJscsztzD7j4hyEa6Ua7Z0MsdMVtVvUuyIuo5fdDQ+8A12qqg1Tpy4Sj3lbSSDrStkoDoHLbyjJwvI9n5x+RPl/mmkNwmr8Ex2tHV83s4vMgbPKAx+kj+4NncbxPGZk+Bx4KMzeVSZrqKk+6IikoTxLx2B0jB/s2gWoH2JmIYomLdaMKa3LbIdZRqsqetu2AI1jB6ZNd46z1R6waxo2HFUAU/8Z38oeJYoa6FqIk1IfIN2Ie58OdId4HmiLAAb0BH3aCgqD/jFTWHoWVBw/EtgOCwV6D9GT0HXGcN1IvJquB9bf6+D2+akWBUgXbYOg76bXnfVC4oSZoTC8wJi2+WuTW4hPfdJaTUorZVtVrEyTzIVWtNJzR00gCBdb6xXP40l7b5H+DYxhVjvsiL8e3m8bFM1JKNAjoZU8A0VQXwXYz5b5gpW+dPCiSm/JDzLautcCHvTtaNsILgLiPEOUy91jiZDRpZQCCdYljlt7ZHFOOZF6YleUlEXeZIq3VpHXf8kKwu7xfW3LkOM8aT9sHybsJypFtJurcxQi/NOEhLAif5wDdB40meYcDiYieV72UmDMUwGy0RBH0o1l5bftbN/pGB03dXnfxg+jkHS5BaeqT+D+anXsNHlm25XUVbKvsKWwDiNSWum2LxHMN+KOnpZQiPsf8Sj
 lDTs4hVo
 kRa071Z5nODmrh6ulClCQ1Thdl5J3JDwo3Dl9Bae7d4XvDQTLHd09VF+XK12E8HfQ238lMS10ywdvL/mQ/MY8af12Ahcqupbm38U8U1qxkx6RB74bnzgINP8tvyICMpWOdNzKs2o3q9crYjDHMWgYQaNisAdkTduH7G6f1o9P/8+hPvwX2h0Mke0dB3u4g0IbUIIPXw8adOXYVT76I0GZdLLzE87CKHyELIXskvTa8paIAdbniE4U3xv/b51PxZnER2zfFBV+7NF7PdKICcgtszsFXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/12/2025 09:05, David Hildenbrand (Red Hat) wrote:
> On 12/16/25 15:56, Ryan Roberts wrote:
>> On 16/12/2025 14:26, Kevin Brodsky wrote:
>>> One of the pagemap_ioctl tests attempts to fault in pages by
>>> memcpy()'ing them to an unused buffer. This probably worked
>>> originally, but since commit 46036188ea1f ("selftests/mm: build with
>>> -O2") the compiler is free to optimise away that unused buffer and
>>> the memcpy() with it. As a result there might not be any resident
>>> page in the mapping and the test may fail.
>>>
>>> We don't need to copy all that memory anyway. Just fault in every
>>> page by forcing the compiler to read the first byte.
>>>
>>> Cc: Usama Anjum <Usama.Anjum@arm.com>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>>   tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c
>>> b/tools/testing/selftests/mm/pagemap_ioctl.c
>>> index 2cb5441f29c7..67a7a3705604 100644
>>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>>> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>>>       struct page_region *vec;
>>>       char *mem, *fmem;
>>>       struct stat sbuf;
>>> -    char *tmp_buf;
>>>         /* 1. wrong operation */
>>>       mem_size = 10 * page_size;
>>> @@ -1167,8 +1166,9 @@ int sanity_tests(void)
>>>       if (fmem == MAP_FAILED)
>>>           ksft_exit_fail_msg("error nomem %d %s\n", errno,
>>> strerror(errno));
>>>   -    tmp_buf = malloc(sbuf.st_size);
>>> -    memcpy(tmp_buf, fmem, sbuf.st_size);
>>> +    /* Fault in every page by reading the first byte */
>>> +    for (i = 0; i < sbuf.st_size; i += page_size)
>>> +        (void)*(volatile char *)(fmem + i);
>>
>> We have FORCE_READ() in vm_util.h for this. Perhaps that would be
>> better?
>
> Agreed, and if we have multiple patterns where we want to force_read a
> bigger area, maybe we should provide a helper for that?

I've found just a couple of cases where FORCE_READ() is used for a
larger area (in hugetlb-madvise.c and split_huge_page_test.c). The step
size isn't the same in any of these cases though. We could have
something like fault_area(addr, size, step) but maybe the loops are
clear enough already?

- Kevin

