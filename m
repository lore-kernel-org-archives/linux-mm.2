Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52993C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632816B0092; Mon, 31 Aug 2026 11:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609B76B0095; Mon, 31 Aug 2026 11:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9406B0096; Mon, 31 Aug 2026 11:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 372716B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:30:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6A29A01AE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:30:29 +0000 (UTC)
X-FDA: 85161951378.30.8123D7F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id C5F4D120014
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:30:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fu+LyaS3;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788190228;
	b=aZRq3H0LZsZQcZkpc/KgzBT5sMQlZ5r+MtmjM3hc6sC3MJLMwloxEMmCCJhHPYqozIIZhM
	KQcBNDpABHa80A6hPC7dztpNLNFvSoaEXPutD8TKKMUOzzaw0DVRQLGi3hHaF9oXP5hwhM
	GCsaSotT0HRjPbbeTbuV/IF7uj5ATyE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788190228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lj8vVsbmTwPT0Cjl/ChRV/xwb94gczxM5UfDJ4T5bS8=;
	b=u0zbUYbToljDr5gU3KbO72neoS0CakKeZ8Q9+ouQAMiLu6oANarTRHqlqAtDBzhyi6pDQx
	vrD9pzKgdLF+k0kxrhUbuJ8i1VvrlY579Ar1tByWwlVhsxgCkWucyF+KdVDFzrlGuxvwI0
	ub3p1K6Jn2h68Pxk1OuuaetGy9VfuEM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fu+LyaS3;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABB7814BF;
	Mon, 31 Aug 2026 08:30:22 -0700 (PDT)
Received: from [10.57.6.141] (unknown [10.57.6.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B254C3F882;
	Mon, 31 Aug 2026 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788190226; bh=lj8vVsbmTwPT0Cjl/ChRV/xwb94gczxM5UfDJ4T5bS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fu+LyaS3+WfBA0uqQccLp34N9VvHid4HkKzlLtdtlaQk+RXZfyDKkixn1BSnTypDV
	 TP0ZysmdYLKJmf1Dww5bQbi7CLiGF2s1vJLj2DtgVlo8wtBBX+DEGruHr6TsXqR8/V
	 FlL4M8MdbsuWb6O6g0Ogz9KAuTGmx2FQxRiu+xps=
Message-ID: <e0897ac4-1e5b-4f65-93fb-a718b27ecfb4@arm.com>
Date: Mon, 31 Aug 2026 17:30:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 13/25] mm: kpkeys: Introduce early page table
 allocator
To: Dave Hansen <dave.hansen@intel.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
 <9ab4d7b8-6be9-4219-a410-ed26ae25c47e@intel.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <9ab4d7b8-6be9-4219-a410-ed26ae25c47e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5F4D120014
X-Stat-Signature: rjjtadd1y1bzix7fe6kkwxj1dpe1sip8
X-HE-Tag: 1788190227-965939
X-HE-Meta: U2FsdGVkX18Y6CUKOSBo3fO8Jmgip0cvU244O/5OXkWhxrx3KDHl9TcBzceuOKCvTtaBo0qW57aNCzHvKgXkpFkGRdcsPIhJKZmGduUYaajP8lU2XRlyXzh81zA1Xj7F7sCEU+Bso+jGT/EDHQMXjtgny2IZtx8tf02uLcZvOdeLMDHDBNVN5awtEDCC6jWCiH/xX5TloLNGlL2Sx4b8gkxkdfjQ1XCx7MUqKlkNYwuv9+HD4o+nAm+kopsKESRYtk5V4KRWF498Owydp24jZWVi6qifg4h7TYRFtxr3geEyBC/979dKeFyodHLl8Fo0VN/46mRFtrRSQ5/W5nVyHZnx7QwSwULOYRxLbUTMfhrRw33UV1YdaLESetyCg6ampG3WE8mnCN1Z92Etx2KqaCznnRj28SgK7tUEB4M5daDx0alOkXKjdsT2vnkL/uR6MIj/cuzFtQXF4ukbZv9Vhfx8R80Qk2xooFEjoiKDxd3Pmj1JthNzEBwfQgsDdknLiD8yTfMO+xOfWTluGKu+Gm3vLZIgAF0/oZ6NGxjZnfexNiLEs/swocfswsXbpMbxRvYumDbgE50yQ9RrSV3TQouftpYE7E9+YAp70/N3htMFHRCu2i7nmXSZHE8KClZyiJo36sbv4sTML23mKDlKcoxegMF/u4SyGfufAdW5ETNjzzu2NVK8urwKxLopnQKqnHHIGWgzynMfM37F6glzNYjfY2Ih2IdjSHNFdCCIUiovJyiT2nswUITwoua42+B638P2aJTEBcY8RH5iOyu0PlzJHnqiQQ19LUf1q5ZmAs9gszYHH8Yi2ruI0CG7DzVY/ox6DPnHtdjzrXg5X0SJVlnR0qipzE44z4iIObtFA4qT+2rJMhgF9tLDAS8ouq3J4LDFMGwpWKdEkEwXY8zaqJtIYr5x29YbBkXwUhU36W6KO5teIFwJ6rZmFi+HvylACbYQP6dhYTGbqkXudj8
 1HbzFNAG
 YD8AXM351rtNhXbhZEMsZthtlKkT8gQ41HJUj99FuUrk2zWQd8ND1N/An3/REmm01fcl6bRz/y4BpASX2OvlRLtzOuqgELgpTEhQi1+P4MVKryJEtRu7r/RY303mAzNcEt+9R/glzr8jnoQJc7FSypFl/USB2CACeDE/y9eSJ1cw4eyvvx9Nl5qJeTQ5lmo1R8bVkX7Z69eRESJJSZhjClne+bMnwWy/V3VRF7x2I48t9aH7pCCrnVFNebBm/fhR/yDNEZLKkcqR5i0HqsGHtTKYlLPAvKHMweBnPj/XXMvpGK3HmwResKqspnbc1Sbn5aX2VRLryn3d0vu98jjxSIbL85w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/08/2026 20:17, Dave Hansen wrote:
> On 8/18/26 07:08, Kevin Brodsky wrote:
>> This patch addresses the second category: PTPs allocated via memblock.
>> Such PTPs are notably used to create the linear map. Protecting them as
>> soon as they are allocated would require modifying the linear map while
>> it is being created, which seems at best difficult. Instead, a
>> simple allocator is introduced, obtaining pages from memblock and
>> keeping track of all allocated ranges to set their pkey once it is
>> safe to do so.
> What makes setting a pkey on the memory "unsafe"? Is there something
> preventing just making access permissive during boot?

There are two issues at play here:

1. When allocating page tables to create the direct map, we cannot
reliably set their pkey because that itself requires modifying the
direct map (and we may not even have mapped this particular page yet).
There may be ways around this, but it feels at best uncomfortable.

2. Specifically in the context of relying on the BBML3 feature on arm64:
when we create the direct map with large block mappings, there is a
window during boot (before all the secondary cores are up) where we do
not allow splitting blocks. This has caused troubles for other features
as well, see [1].

My understanding is that 1. is a problem regardless of the architecture.
2. is not actually relevant when we force the direct map to be
PTE-mapped, as is the case in this version, but it had to be considered
in RFC v6 where we tried to support block mappings.

As per the discussion with David (also in reply to this patch), the plan
is now to return to an earlier design where we walk the early kernel
page tables to set their pkey. This circumvents the allocation question
completely, albeit with the requirement that the direct map is fully
PTE-mapped.

- Kevin

[1]
https://lore.kernel.org/all/0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com/
[2]
https://lore.kernel.org/all/20260227175518.3728055-19-kevin.brodsky@arm.com/


