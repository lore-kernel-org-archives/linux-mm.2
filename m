Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C35D10FC465
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAAD6B008A; Wed,  8 Apr 2026 22:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B0D6B008C; Wed,  8 Apr 2026 22:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98096B0092; Wed,  8 Apr 2026 22:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B80E06B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:08:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D20E1B76FB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:08:33 +0000 (UTC)
X-FDA: 84637383306.09.70789EB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 755CFC0007
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:08:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q4o7vSn0;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q4o7vSn0;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775700511; a=rsa-sha256;
	cv=none;
	b=KStVfXXOgGXi/MUPuw0ygoDfvCHFVXh9ZB2L+xg1iHXnMeUUsLcbzXZzCfmL5eX90/ioWy
	Z7B/RNqKDAeovnZyr6hR4QMSnt9z82FFK/kTAZY8RKEdgyd0BfvmsreWZIGCKHqcPDTe7h
	VgkFlY4TrOtTNmrHVANzfMYGkG3YSuI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775700511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaytnJ6ZCFlO4gD8gW+Y2+bllQtwZ5ZchyRx+p3OVfA=;
	b=gHhuY2rrLiRGkkhEVormg7ngJCkfc0KYuv9wgbbzjwXeLS1B39WqDdpMPRC2MYme/wZzKD
	qqIhwjhRJu8YZBAg7QGRyY4s65Im8JY2lzQu8wCkx7PvUtjiaEg1bG5Z9lPi2oEC1ZWIoa
	62uYgogJyv1OLMwjnKjJeuQXoqQ39eI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C34B35C7;
	Wed,  8 Apr 2026 19:08:24 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B712B3F7D8;
	Wed,  8 Apr 2026 19:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775700510; bh=nb/Ldn1rG04kuyp/Gu2fW/d/DdD/8muloilUcAfi43U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q4o7vSn0CL3AE34IYW0A28ObmyC0/AovqMKiX8ETjREHWSV3hA/69vGjO4TEGCuXl
	 uxgKPmx5HpNKOENAA6d1klBtQOq5eCKj7Z/LFS6EYS4RU/mRRFjEfNhxoUYDreWYJ7
	 NnDQYFf/oHSxnHRrbb6eQa5wWiF9uyl5KKVRtj3c=
Message-ID: <1d3df806-fdf5-4cd8-960a-9ebb707de575@arm.com>
Date: Thu, 9 Apr 2026 07:38:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 00/16] arm64/mm: Enable 128 bit page table entries
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <a77b39a4-c6dd-4a8a-8ea4-2bdc31bd3601@kernel.org>
 <8d2c9ecb-ae33-42f2-a8ed-66b3286b9286@arm.com>
 <c664368c-fe2c-42d8-b488-e9e30b342491@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <c664368c-fe2c-42d8-b488-e9e30b342491@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 755CFC0007
X-Stat-Signature: 1wncjj9ug5u3cm4us4htw8r994xdyz5j
X-Rspam-User: 
X-HE-Tag: 1775700511-680812
X-HE-Meta: U2FsdGVkX1+ZObujydssvIS3MICj7s68ogqYDUBrRMNxLEHku0sQvXoS60bXyOojGwyIsO3sFLT3oVyirxtUInWIfva364nZiIn3fvbENtKQG4/B3BMdLxFtLHARYd1vTJq0nBhR3mJLIxgsr8oVJugVmSRthlFRmlhOgHa31xd/IE68AGt9w7ls5mZgGAIniMGFlFt6z2qvh13/1O+INuA3lu6To4+e7QQ92L/yypSdd48dWH1HCcQNBsQVz64Oc2n1mYeh24Vqq/InTMQysmdjhYEw+x9xOjRnKJVzYKc3uUuqPVpFs+3h/086LfRPpuOZyrqUeivbkq5QQ08w5YPGl8F45Swu8usP4+QlKh4t0jhaGmgoHYgZOBeNors/n5r/inIFUuPF0pOqQ0ILx5Zsm1xGDsq1xl9l472Z7g/X8mHd/4o/YOzVIlFmCO+mB3oxwkH1f7iCcQFKQxFqbs6DuuarD1KdXzdEdxhobSwC3GcHvBhffOxUIC0FbNtsQQUqjq66N4EkupxsMxdi/Lo+Zj0LdK60U8eKQlLUOQ9qKzeIyNomIkM6RMUp0z+LgzSkxjB/4QRbGZ3TDt6A+nOTt0oiUcQOTj2F/rZO9EdOxUlEz6w/LeYNJnLXHGuExR1hOfbFSHR8rfJVUZhbL0mF7SC2hxamu3R4pIr1diaQkyIU24J/XbFQbjhiGbhNDdwy3TxwenCObLRoB88vzEQVxmRca7W6rbjOgXSaK9oRJLcM65jaPNxv9a4740SgKUzBBe4zNhMvQNNEBbZlbcAlReGcFLb+Bu2UjtaD0XXWXQsILcHCQ5TwEZpxXZVqVdl7Pez8TAJAUlB/kHE1ysXsKWpNRFRDx5PGn9zxU8voyvwh3+ZHld6XBSRo9hAWk7ZdZIE0nQfRu+Dy7NtUqfvQusiJ/NfvoqyXYZs5FjTu5NpD0tSo9pAWiNnSZV1KpExwchkKHY9oRobLQH4
 CShw1lMu
 1ErrUlO9X8minSpIkyGPUScoZZHhP8Qa2tZj3mHEj4kVIwrsJmksZa4nOehWM5xWr4FMyRxxPxUGNrwuiSZxAiAmcXjfCW/dYpKCfYj4+J0Bj4l1SA3nY0T+X9clpsqC3eB66LUpBMnmrMqvBIM0aEEprE2ND3H0Jtj9A2HkZfrkZilL5wNdK+/eaYR8hbkMNBh0YVSwZucs7Rw3vxh2xbX8A6JTTixXrAeqYXkF026U/3Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 5:43 PM, David Hildenbrand (Arm) wrote:
> On 4/8/26 12:53, Anshuman Khandual wrote:
>> On 07/04/26 8:14 PM, David Hildenbrand (Arm) wrote:
>>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>>> FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
>>>> translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
>>>> So with this feature arm64 platforms could have two different translation
>>>> systems, VMSAv8-64 and VMSAv9-128 could selectively be enabled.
>>>>
>>>> FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
>>>> and virtual address range while also expanding available room for more MMU
>>>> management feature bits both for HW and SW. 
>>>>
>>>> This series has been split into two parts. Generic MM changes followed by
>>>> arm64 platform changes, finally enabling D128 with a new config ARM64_D128.
>>>>
>>>> READ_ONCE() on page table entries get routed via level specific pxdp_get()
>>>> helpers which platforms could then override when required. These accessors
>>>> on arm64 platform help in ensuring page table accesses are performed in an
>>>> atomic manner while reading 128 bit page table entries.
>>>>
>>>> All ARM64_VA_BITS and ARM64_PA_BITS combinations for all page sizes are now
>>>> supported both on D64 and D128 translation regimes. Although new 56 bits VA
>>>> space is not yet supported. Similarly FEAT_D128 skip level is not supported
>>>> currently.
>>>>
>>>> Basic page table geometry has been changed with D128 as there are now fewer
>>>> entries per level. Please refer to the following table for leaf entry sizes
>>>>
>>>>                     D64              D128
>>>> ------------------------------------------------
>>>> | PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
>>>> -----------------------------|-----------------|
>>>> |     4K    |    2M  |  1G   |    1M  |  256M  |
>>>> |    16K    |   32M  | 64G   |   16M  |   16G  |
>>>> |    64K    |  512M  |  4T   |  256M  |    1T  |
>>>> ------------------------------------------------
>>>>
>>>
>>> Interesting. That means user space will have it even harder to optimize
>>> for THP sizes.
>>>
>>> What's the effect on cont-pte? Do they still span the same number of
>>> entries and there is effectively no change?
>>
>> The numbers are the same for 4K base page size but will need
>> some changes for 16K and 64K base page sizes. Something that
>> git missed in this series, will fix it.
> 
> Oh, and it would be great to also clearly spell out the effect on
> hugetlb as well. I assume the available hugetlb sizes will change as well.

Sure will update the required information in the commit message as well as in
file arch/arm64/mm/hugetlb.c, where HugeTLB sizes support matrix is enlisted.

